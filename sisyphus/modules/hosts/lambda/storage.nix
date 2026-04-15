{ self, inputs, ... }: {
  flake.nixosModules.lambdaStorage = { config, lib, pkgs, ... }: {
    fileSystems."/mnt/spare" = {
      device = "/dev/disk/by-uuid/4827ed9a-ba16-4b69-b8e2-4a639d44c504";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"           # don't update access times, faster for game loads
        "compress=zstd:3"   # transparent compression, saves space on game assets
        "space_cache=v2"
        "nofail"            # don't block boot if drive is missing
        "x-gvfs-show"       # show in file managers
      ];
    };

    # Make sure the mountpoint exists with correct ownership
    systemd.tmpfiles.rules = [
      "d /mnt/spare 0755 john users - -"
    ];
  };
}
