{ inputs, den, pkgs, lib, host, ... }: {

imports = [ inputs.den.flakeModule ];

	den.aspects.common.provides.network.provides.dnssec = {
		nixos = { ... }: {

			services.unbound = {
				enable = true;
				enableRootTrustAnchor = true;
				settings = {
					server = {
						interface = [ "127.0.0.1" ];
						access-control = [ "127.0.0.0/8 allow" ];
						qname-minimisation = "yes";
					};
				};
			};
			
			networking.nameservers = [ "127.0.0.1" ];

		};
	};
}
