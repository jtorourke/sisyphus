{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.lambdaNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.lambdaNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.lambdaNoctalia)
        ];
        
        spawn-sh-at-startup = [
          "steam"
          "app.zen_browser.zen"
          "discord"
          "spotify"
          "obs"
          "emacs"
          "sleep 3 && niri msg action focus-workspace 1"
        ];
        


        prefer-no-csd = _: {};
        
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input = {
          keyboard = {
            xkb.layout = "us,ua";
          };
          touchpad = {
            natural-scroll = _: {};
            tap = _: {};
          };
          mouse = {
            accel-profile = "flat";
          };
        };

        outputs = {
          "DP-1" = {
            mode = "3440x1440@164.999";
          };
        };

        environment = {
          XCURSOR_THEME = "Capitaine Cursors (Gruvbox)";  # your actual theme name
          XCURSOR_SIZE = "14";
        };
        
        binds = {
          # Session Management
          "Mod+Ctrl+Delete".spawn-sh = "systemctl --user restart niri";
          #"Mod+Ctrl+L".spawn-sh = "nix run nixpkgs#noctalia-shell ipc call lockScreen lock";
          #"Mod+P".spawn-sh = "nix run nixpkgs#noctalia-shell ipc call sessionMenu toggle";
          
          # Programs
          "Mod+T".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+N".spawn-sh = lib.getExe pkgs.nautilus;
          "Mod+B".spawn-sh = "flatpak run app.zen_browser.zen";
          "Mod+E".spawn-sh = lib.getExe pkgs.emacs;
          "Mod+R".spawn-sh = "${lib.getExe self'.packages.lambdaNoctalia} ipc call launcher toggle";
          "Mod+O".toggle-overview = _: {};

          # Window Management
          "Mod+Q".close-window = _: {};
          "Mod+F".maximize-column = _: {};
          "Mod+G".fullscreen-window = _: {};
          "Mod+Space".toggle-window-floating = _: {};
          "Mod+C".center-column = _: {};
          
          ## Windows Movement/Focus
          "Mod+H".focus-column-left = _: {};
          "Mod+L".focus-column-right = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+J".focus-window-down = _: {};

          "Mod+Left".focus-column-left = _: {};
          "Mod+Right".focus-column-right = _: {};
          "Mod+Up".focus-window-up = _: {};
          "Mod+Down".focus-window-down = _: {};

          "Mod+Shift+H".move-column-left = _: {};
          "Mod+Shift+L".move-column-right = _: {};
          #"Mod+Shift+K".move-column-up = _: {};
          #"Mod+Shift+J".move-column-down = _: {};
          "Mod+Alt+K".move-window-up = _: {};
          "Mod+Alt+J".move-window-down = _: {};
 
          ## Size
          "Mod+Ctrl+H".set-column-width = "-5%";
          "Mod+Ctrl+L".set-column-width = "+5%";
          "Mod+Ctrl+J".set-window-height = "-5%";
          "Mod+Ctrl+K".set-window-height = "+5%";
          
          ## Workspaces
         
          "Mod+1".focus-workspace = "w0";
          "Mod+2".focus-workspace = "w1";
          "Mod+3".focus-workspace = "w2";
          "Mod+4".focus-workspace = "w3";
         # "Mod+5".focus-workspace = "w4";
         # "Mod+6".focus-workspace = "w5";
         # "Mod+7".focus-workspace = "w6";
         # "Mod+8".focus-workspace = "w7";
         # "Mod+9".focus-workspace = "w8";
         # "Mod+0".focus-workspace = "w9";

          "Mod+Shift+1".move-column-to-workspace = "w0";
          "Mod+Shift+2".move-column-to-workspace = "w1";
          "Mod+Shift+3".move-column-to-workspace = "w2";
          "Mod+Shift+4".move-column-to-workspace = "w3";
         # "Mod+Shift+5".move-column-to-workspace = "w4";
         # "Mod+Shift+6".move-column-to-workspace = "w5";
         # "Mod+Shift+7".move-column-to-workspace = "w6";
         # "Mod+Shift+8".move-column-to-workspace = "w7";
         # "Mod+Shift+9".move-column-to-workspace = "w8";
         # "Mod+Shift+0".move-column-to-workspace = "w9";
        };

        #cursor._props = {
        #  theme = "Capitaine Cursors (Gruvbox)";
        #  size = 18;
        #};
        
        window-rules = [
          {
            matches = [{ app-id = "^steam$"; }];
            open-on-workspace = "w2";  # workspace 3
          }
          {
            matches = [{ app-id = "^com\\.obsproject\\.Studio$"; }];
            open-on-workspace = "w3";  # workspace 4
          }
          {
            matches = [
              { app-id = "^discord$"; }
              { app-id = "^spotify$"; }
            ];
            open-on-workspace = "w1";  # workspace 2
          }
          {
            matches = [
              { app-id = "^Emacs$"; }
              { app-id = "^app\\.zen_browser\\.zen$"; }
            ];
            open-on-workspace = "w0";  # workspace 1
          }
        ];
        
        layout = {
          gaps = 8;

          focus-ring = {
            width = 2;
            active-color = "#689D6A";
            inactive-color = "#928374";
          };
        };

        workspaces = let
          settings = {layout.gaps = 8;};
        in {
          "w0" = settings;
          "w1" = settings;
          "w2" = settings;
          "w3" = settings;
         # "w4" = settings;
         # "w5" = settings;
         # "w6" = settings;
         # "w7" = settings;
         # "w8" = settings;
         # "w9" = settings;
        };

      };
    };
  };
}
