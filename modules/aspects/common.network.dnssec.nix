{ inputs, den, pkgs, lib, host, ... }: {

imports = [ inputs.den.flakeModule ];

	den.aspects.common.provides.network.provides.dnssec = {
		nixos = { ... }: {

			services.dnscrypt-proxy = {
				  enable = true;
				  settings = {
				  
				    server_names = [ "cloudflare" "quad9-dnscrypt-main" ];
				    
				    listen_addresses = [ "127.0.0.1:53" ];
				    require_dnssec = true;
				    require_nolog = true;
				  };
				};

			networking = {
				nameservers = [ "127.0.0.1" ];
				networkmanager = {
					enable = true;
					dns = "none";
				};
			};

		};
	};
}
