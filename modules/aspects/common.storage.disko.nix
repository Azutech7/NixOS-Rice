{ inputs, den, pkgs, lib, host, config, ... }: {

	imports = [ 
		inputs.den.flakeModule
		inputs.disko.flakeModules.default
	];

	flake-file.inputs.disko = {
		url = "github:nix-community/disko";
		inputs.nixpkgs.follows = "nixpkgs";
	};

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

				nixos = { host, ... }: {

					disko.enableConfig = true;

					flake.diskoConfigurations."${host.hostName}".disko.devices = config.disko.devices;

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
			};
		};
	};
}
