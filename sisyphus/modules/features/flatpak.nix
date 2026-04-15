{ self, inputs, ... }: {
  flake.nixosModules.flatpak = { pkgs, ... }: {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

    services.flatpak = {
      enable = true;
      uninstallUnmanaged = false;
      update.onActivation = true;
      
      remotes = [{
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }];
      
      packages = [
        "app.zen_browser.zen"
      ];
      
      overrides = {
        "app.zen_browser.zen" = {
          Context.filesystems = [
            "/run/current-system/sw/share/icons:ro"
            "xdg-config/gtk-3.0:ro"
            "xdg-config/gtk-4.0:ro"
          ];
          Environment = {
            XCURSOR_SIZE = "18";
            XCURSOR_THEME = "'Capitaine Cursors (Gruvbox)'";
          };
        };
      };
    };
  };
}
