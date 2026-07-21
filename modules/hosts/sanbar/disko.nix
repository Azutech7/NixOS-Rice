{ inputs, den, pkgs, lib, host, ... }: {

    imports = [
        inputs.disko.flakeModules.default
	];

    flake.nixosConfigurations.sanbar = {
        imports = [
            inputs.disko.nixosModules.disko
            inputs.self.diskoConfigurations.sanbar
        ];
    };

    flake.diskoConfigurations.sanbar = {
        disko.devices = {
            disk = {
                sanbar_disko_disk = {
                    type = "disk";
                    device = "/dev/disk/by-id/wwn-500a0751e9aba137";
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
                            
                            sanbar_disko_part = {
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
}