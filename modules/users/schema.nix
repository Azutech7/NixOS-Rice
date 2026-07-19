{ inputs, den, lib, config, ... }: {

    den.default.homeManager.home.stateVersion = "25.11";

    den.schema.user = user: {
		includes = [ den.provides.define-user ];
		classes = lib.mkDefault [ "homeManager" ];

		homeManager = { ... }: {
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;
		};
	};
}