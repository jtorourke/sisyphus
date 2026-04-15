{ self, inputs, ... }: {
  flake.nixosModules.docker = { pkgs, lib, config, ... }: {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
