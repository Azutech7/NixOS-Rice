{ inputs, den, pkgs, lib, host, user, ... }: {

imports = [ inputs.den.flakeModule ];

    den.aspects.common._.audio._.pipewire = {
        nixos = { ... }: {
            services.pipewire = {
            	enable = true;
            	pulse.enable = true;
            };
        };
    };
}
