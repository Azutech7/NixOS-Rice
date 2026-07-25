{ inputs, lib, ... }: {

	systems = [ "x86_64-linux" ];

	imports = [
		(inputs.flake-file.flakeModules.dendritic or { })
		(inputs.den.flakeModules.dendritic or { })
	];
	
	flake-file.inputs = {
		den.url = "github:denful/den";
		flake-file.url = "github:denful/flake-file";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		flake-parts = {
      		url = "github:hercules-ci/flake-parts";
      		inputs.nixpkgs-lib.follows = "nixpkgs";
    	};
		import-tree.url = "github:vic/import-tree";
		nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.xz";
	};

}
