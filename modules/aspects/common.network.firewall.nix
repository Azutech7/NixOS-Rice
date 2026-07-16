{ inputs, den, pkgs, lib, host, user, ... }: {

imports = [ inputs.den.flakeModule ];

	den.aspects.common._.network._.firewall = {
		nixos = { ... }: {
			networking.firewall = {
				enable = true;
				
				allowedUDPPorts = [ 53 88 500 3544 4500 ];
				allowedTCPPorts = [ 53 80 3074 ];
				
				extraCommands = "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT";
			};
		};
	};
}
