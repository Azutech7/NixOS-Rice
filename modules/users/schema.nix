{ inputs, den, lib, config, ... }: {

	den.default.includes = [ { homeManager = { ... }: { home.stateVersion = "25.11"; }; } ];
	
    den.schema.user = user: {
		includes = [ den.provides.define-user ];

		classes = lib.mkDefault [ "homeManager" ];

		homeManager = { lib, ... }: {
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;
		};
	};
}