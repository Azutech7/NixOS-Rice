{ inputs, den, pkgs, lib, host, config, ... }: {

	imports = [ 
		inputs.den.flakeModule
		inputs.disko.flakeModules.default
	];

	flake-file.inputs.disko = {
		url = "github:nix-community/disko";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	den.default.includes = [ { nixos = { ... }: { imports = [ inputs.disko.nixosModules.disko ]; }; } ];

	den.aspects.common.provides.storage.provides.disko = {

		nixos = { ... }: {
			imports = [
			  inputs.disko.nixosModules.disko
			];

			disko.enableConfig = true;
		};

		provides.mkPrimaryDrive = {

			includes = [ den.aspects.common._.storage._.disko ];

			__functor = self: { devicePath, ... }: {

				# FIX: Define the disko config directly at the flake level inside the functor!
				# This handles multiple hosts dynamically based on their hostName.
				flake.diskoConfigurations."${host.hostName}" = {
					disko.devices = {
					    disk = {
					      "${host.hostName}_disko_disk" = {
					        type = "disk";
					        device = devicePath;
					        content = {
					          type = "gpt";
					          partitions = {
					          
					            ESP = {
					              name = "ESP";
					              priority = 1;
					              size = "1G";
					              type = "EF00";
					              content = {
					                type = "filesystem";
					                format = "vfat";
					                mountpoint = "/boot";
					                mountOptions = [ "umask=0077" ];
					              };
					            };
					            
					            "${host.hostName}_disko_part" = {
					              size = "100%";
					              content = {
					                type = "btrfs";
					                extraArgs = [ "-f" ]; 
					                
					                subvolumes = {
					                  "/rootfs" = {
					                    mountpoint = "/";
					                  };
					                  "/home" = {
					                    mountOptions = [ "compress=zstd" ];
					                    mountpoint = "/home";
					                  };
					                  "/nix" = {
					                    mountOptions = [
					                      "compress=zstd"
					                      "noatime"
					                    ];
					                    mountpoint = "/nix";
					                  };
					                  "/swap" = {
					                    mountpoint = "/.swapvol";
					                    swap = {
					                      swapfile.size = "8G";
					                    };
					                  };
					                };
					                mountpoint = "/partition-root";
					                swap = {
					                  swapfile = {
					                    size = "8G";
					                  };
					                };
					              };
					            };
					          };
					        };
					      };
					    };
					  };
				};

				flake.nixosConfigurations."${host.hostName}".disko.devices = flake.diskoConfigurations."${host.hostName}".disko.devices;

				# Now point your NixOS target module directly back to the flake configuration
				#nixos = { config, host, ... }: {
				#	disko.enableConfig = true;
				#	
				#	# Read the layout definitions dynamically from the flake scope we built above
				#	disko.devices = config.diskoConfigurations."${host.hostName}".disko.devices;
				#};
			};
		};
	};
}
