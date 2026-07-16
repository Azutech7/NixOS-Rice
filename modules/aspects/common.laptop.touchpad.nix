{ inputs, den, config, ... }: {

imports = [ inputs.den.flakeModule ];

	den.aspects.common.laptop.touchpad = {

		nixos = { ... }: 
			{
				services.libinput.enable = true;
			};
			
	};
}
