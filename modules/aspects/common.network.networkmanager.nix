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
			};
		};
	};
}
