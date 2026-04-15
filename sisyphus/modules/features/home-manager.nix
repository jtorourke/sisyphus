{ self, inputs, ... }: {
  flake.nixosModules.homeManager = { config, lib, pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;       # share the system nixpkgs (with allowUnfree etc.)
      useUserPackages = true;     # install HM packages into /etc/profiles/per-user
      backupFileExtension = "hm-backup";

      # Pass flake inputs/self into HM modules so they can see them
      extraSpecialArgs = { inherit inputs self; };

      users.john = import ../home/_john.nix;
    };
  };
}
