{ inputs, den, lib, config, ... }: {

	den.default.includes = [
		den.batteries.hostname
		{ nixos = { ... }: { 
			imports = [
				(inputs.disko.nixosModules.disko or {})
			];
			system.stateVersion = "25.11";
		}; }
	];

    den.schema.host = host: {

		nixos = { lib, inputs, ... }: {
			den.nixpkgs = {
				source = inputs.nixpkgs;
				system = host.system; # Maps "x86_64-linux" directly
				config.allowUnfree = true;
			};
		 
			_module.args.inputs = inputs;
			
			nix.settings.experimental-features = [ "nix-command" "flakes" ];
			time.timeZone = lib.mkDefault "America/Los_Angeles";
		};
	};
}