{ inputs, lib, ... }: {

	systems = [ "x86_64-linux" ];

	imports = [
	  (inputs.flake-file.flakeModules.dendritic or { })
	  (inputs.den.flakeModules.dendritic or { })
	];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	
	flake-file.inputs = {
	  den.url = "github:denful/den";
	  flake-file.url = "github:denful/flake-file";
	  home-manager = {
	    url = "github:nix-community/home-manager";
	    inputs.nixpkgs.follows = "nixpkgs";
	  };
	};

}
