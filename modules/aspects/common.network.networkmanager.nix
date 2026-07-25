{ inputs, den, pkgs, lib, host, user, ... }: {

imports = [ inputs.den.flakeModule ];

	den.aspects.common._.network._.networkmanager = {
		nixos = { ... }: {
			networking = {
				networkmanager = {
					enable = true;
					wifi.macAddress = "random";
					wifi.scanMacAddress = "random";
				};

				enableIPv6 = false;
				preferIPv4 = true;

				nameservers = lib.mkDefault [ "1.1.1.1" "8.8.8.8" ];
				dns = lib.mkDefault "default";
			};
		};
	};
}
