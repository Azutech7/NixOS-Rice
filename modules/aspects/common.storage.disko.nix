{ inputs, den, pkgs, lib, host, ... }: {

	imports = [ inputs.den.flakeModule ];

	flake-file.inputs.disko = {
		url = "github:nix-community/disko";
		inputs.nixpkgs.follows = "nixpkgs"; # Standard follows syntax works here
	};

	den.aspects.common.provides.storage.provides.disko = {

		nixos = { ... }: {
			imports = [
			  # Safely fall back to an empty module if disko isn't written to the flake yet
			  (inputs.disko.nixosModules.disko or { })
			];

			disko.enableConfig = true;
		};

		provides.mkPrimaryDrive = {

			includes = [ den.aspects.common._.storage._.disko ];

			__functor = self: { devicePath, ... }: { #### devicePath: /dev/disk/by-id/<ID>

				nixos = { host, ... }: {

					#imports = [
					#	# Safely fall back to an empty module if disko isn't written to the flake yet
					#	(inputs.disko.nixosModules.disko or { })
					#];

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

