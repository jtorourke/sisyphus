{ self, inputs, ... }: {
  flake.nixosModules.containers = { pkgs, lib, config, ... }: {
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        copyparty = {
          image = "copyparty/ac:latest";
          ports = [ "3923:3923" ];
          volumes = [
            "/home/john/bulk/copyparty:/w"
            "/var/lib/copyparty:/cfg"
          ];
	  cmd = [
	    "-a" "john:jto"
	    "-v" "/w::rw,john"
	  ];
        };

        searxng = {
          image = "searxng/searxng:latest";
          ports = [ "8888:8080" ];
          volumes = [ "/var/lib/searxng:/etc/searxng" ];
          environment = {
            SEARXNG_BASE_URL = "http://delta:8888/";
          };
        };

        prometheus = {
          image = "prom/prometheus:latest";
          ports = [ "9090:9090" ];
          volumes = [
            "/var/lib/prometheus/config:/etc/prometheus"
            "/home/john/bulk/prometheus:/prometheus"
          ];
          cmd = [
            "--config.file=/etc/prometheus/prometheus.yml"
            "--storage.tsdb.path=/prometheus"
            "--storage.tsdb.retention.time=30d"
          ];
          extraOptions = [ "--network=host" ];
        };
        
        node-exporter = {
          image = "prom/node-exporter:latest";
          extraOptions = [
            "--network=host"
            "--pid=host"
          ];
          volumes = [
            "/proc:/host/proc:ro"
            "/sys:/host/sys:ro"
            "/:/rootfs:ro"
          ];
          cmd = [
            "--path.procfs=/host/proc"
            "--path.sysfs=/host/sys"
            "--path.rootfs=/rootfs"
            "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)"
          ];
        };
        
        cadvisor = {
          image = "gcr.io/cadvisor/cadvisor:latest";
          ports = [ "8080:8080" ];
          volumes = [
            "/:/rootfs:ro"
            "/var/run:/var/run:ro"
            "/sys:/sys:ro"
            "/var/lib/docker/:/var/lib/docker:ro"
            "/dev/disk/:/dev/disk:ro"
          ];
          extraOptions = [ "--privileged" "--device=/dev/kmsg" ];
        };
        
        grafana = {
          image = "grafana/grafana:latest";
          ports = [ "3000:3000" ];
          volumes = [ "/home/john/bulk/grafana:/var/lib/grafana" ];
          environment = {
            GF_SECURITY_ADMIN_PASSWORD = "changeme";
            GF_USERS_ALLOW_SIGN_UP = "false";
          };
          extraOptions = [ "--network=host" ];
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /home/john/bulk/copyparty 0755 root root -"
      "d /var/lib/copyparty 0755 root root -"
      "d /var/lib/searxng 0755 root root -"
      "d /var/lib/prometheus/config 0755 root root -"
      "d /home/john/bulk/prometheus 0755 nobody nogroup -"
      "d /home/john/bulk/grafana 0755 472 472 -"
    ];
  };
}
