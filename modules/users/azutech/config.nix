{ inputs, den, config, ... }: {

imports = [ inputs.den.flakeModule ];

	den.aspects.azutech = {
		
		includes = [
			den.provides.primary-user

			den.aspects.bash
			den.aspects.btop
			den.aspects.cava
			den.aspects.fastfetch
			den.aspects.firefox
			den.aspects.flatpak
			den.aspects.fuzzel
			den.aspects.hyprland._.hypridle
			den.aspects.hyprland._.hyprlock
			den.aspects.hyprland._.hyprpaper
			den.aspects.hyprland._.hyprshot
			den.aspects.hyprland
			den.aspects.kitty
			den.aspects.ly
			den.aspects.mako
			den.aspects.micro
			den.aspects.steam
			den.aspects.theme
			den.aspects.waybar

			den.aspects.theme._.selenized

			#(den.batteries.unfree [ "discord-1.0.138" ])
		];

		nixos = { pkgs, ... }: {
			environment.systemPackages = with pkgs; [
				
			];
		};

		homeManager = { config, pkgs, ... }: {
		
			home.packages = with pkgs; [
				#discord
				#spotify
				#zoom-us
				#prismlauncher
			];

			home.sessionVariables = {
				XCURSOR_THEME = config.modules.theme.cursor.name;
				XCURSOR_SIZE = config.modules.theme.cursor.size;
				HYPRCURSOR_THEME = config.modules.theme.cursor.name;
				HYPRCURSOR_SIZE = config.modules.theme.cursor.size;
			};

			home.pointerCursor = {
				package = config.modules.theme.cursor.package;
				name = config.modules.theme.cursor.name;
				size = config.modules.theme.cursor.size;
				gtk.enable = true;
				x11.enable = true;
			};

			gtk = {
				enable = true;
				cursorTheme = {
					package = config.modules.theme.cursor.package;
					name = config.modules.theme.cursor.name;
				};
				gtk4.theme = null;
			};
				
			
			programs.git.enable = true;
			programs.git.settings = {
				user.name = "Azutech7";
				user.email = "masonheuberger@gmail.com";
			};

			
		};
		
	};
}
