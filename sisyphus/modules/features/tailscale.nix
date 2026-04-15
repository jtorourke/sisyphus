{ self, inputs, ... }: {
  flake.nixosModules.tailscale = { pkgs, lib, config, ... }: {
    services.tailscale.enable = true;
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ 41641 ];
    };    
  };
}
