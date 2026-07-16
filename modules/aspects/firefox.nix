{ inputs, den, pkgs, lib, host, user, ... }: {

imports = [ inputs.den.flakeModule ];

    den.aspects.firefox = {
        nixos = { ... }: {
            programs.firefox.enable = true;
        };
    };
}
