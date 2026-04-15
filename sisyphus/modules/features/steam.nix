{ self, inputs, ... }: {
  flake.nixosModules.steam = { config, lib, pkgs, ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    programs.gamemode.enable = true;

    # 32-bit graphics libraries for Steam/Proton
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
