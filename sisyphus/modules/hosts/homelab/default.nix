{ self, inputs, ... }: {
  flake.nixosConfigurations.delta = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.deltaConfiguration
    ];
  };
}
