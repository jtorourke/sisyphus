{ self, inputs, ... }: {
  flake.nixosModules.containers = { pkgs, lib, config, ... }: {
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        copyparty = {
          image = "copyparty/ac:latest";
          ports = [ "3923:3923" ];
          volumes = [
            "/srv/copyparty:/w"
            "/var/lib/copyparty:/cfg"
          ];
        };

        searxng = {
          image = "searxng/searxng:latest";
          ports = [ "8888:8080" ];
          volumes = [ "/var/lib/searxng:/etc/searxng" ];
          environment = {
            SEARXNG_BASE_URL = "http://homelab:8888/";
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/copyparty 0755 root root -"
      "d /var/lib/copyparty 0755 root root -"
      "d /var/lib/searxng 0755 root root -"
    ];
  };
}
