{ self, inputs, ... }: {

  flake.nixosModules.lambdaConfiguration = {config, lib, pkgs, ... }: {
    # import any other modules from here
    imports = [
      self.nixosModules.lambdaHardware
      self.nixosModules.lambdaStorage
      self.nixosModules.niri
      self.nixosModules.homeManager
      self.nixosModules.flatpak
      self.nixosModules.zsh
      self.nixosModules.steam
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
    boot = {
      kernelParams = [ "nvidia_drm.fbdev=1" ];
		  kernelModules = [ "ntfs3" "exfat" ];
		  loader = {
			  timeout = 60;
			  limine = {
				  enable = true;
				  efiSupport = true;
				  maxGenerations = 5;
				  style = {
					  interface.resolution = "3440x1440";
            wallpapers = [ "/home/john/Pictures/gruvbox-wallpapers/wallpapers/anime/light/my-neighbor-totoro-sunflowers.png" ];
            interface.branding = "Sisyphus";
            interface.brandingColor = 5;
          };
          extraEntries = ''
            [CachyOS]
            protocol: efi_boot_entry
            volume: UUID=9C74-5C63
            path: /EFI/limine/limine_x64.efi
          '';
			  };
			 efi = {
			   canTouchEfiVariables = true;
			 };
		  };
	    binfmt.registrations.appimage = {
		      wrapInterpreterInShell = false;
          interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    		  recognitionType = "magic";
    		  offset = 0;
    		  mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    		  magicOrExtension = ''\x7fELF....AI\x02'';
		    };
      };
	networking.hostName = "Lambda"; # Define your hostname.

  programs.appimage.binfmt = true;

  #Docker Setup
  virtualisation = {
    waydroid = {
      enable = true;
    };
    docker = {
      enable = true;
    };
    #podman = {
    #  enable = true;
    #  dockerCompat = true;
    #  defaultNetwork.settings.dns_enabled = true;
    #};
  };

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  users.extraGroups.docker.members = [ "john" ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-32.3.3"
    "electron-34.5.8"
    #"qtwebkit-5.212.0-alpha4"
  ];

  programs = {
    zsh = {
      enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
  
  nix.settings.download-buffer-size = 524288000;

  users.defaultUserShell = pkgs.zsh;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "niri-session";
        user = "john";
      };
      default_session = {
        command = "niri-session";
        user = "john";
      };
    };
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    #WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

    services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Hardware config for Nvidia
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    EGL_PLATFORM = "wayland";
  };

  # NOTE: User-level packages have moved to Home Manager (modules/home/_john.nix).
  # The user definition stays here -- HM configures users, it does not create them.
  users.users.john = {
    isNormalUser = true;
    description = "John";
    extraGroups = [ "networkmanager" "wheel" "storage" ];
  };

  services.tailscale = {
    enable = true;
  };
  
  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
  
  services.emacs.package = pkgs.emacs-unstable;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2 = {
    enable = true;
    settings = {
      defaults = {
        #automount-filter = "*";
        #automount-options = "nosuid, nodev, nofail, x-gvfs-show";
      };
    };
    mountOnMedia = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages. User-only stuff has been moved to Home Manager.
  environment.systemPackages = with pkgs; [
    # System Packages
    wget
    ffmpeg-full
    nvidia-vaapi-driver
    libtool
    docker
    docker-compose
    podman
    podman-desktop
    podman-compose
    curl
    xorg.xrandr
    os-prober
    gitFull
    home-manager
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.cuda_cccl
    cudaPackages.cuda_nvcc

    # Office tools
    protonmail-desktop
    protonvpn-gui
    proton-pass
    onlyoffice-desktopeditors
    
    # Misc system tools
    handbrake
    libresprite
    yubioath-flutter
    tree
    localsend
    #morgen
    git-credential-oauth
    git-credential-manager
    ispell
    flatpak
    fontpreview
    spotify

    # Languages available system-wide (kept here for root shells / build envs)
    beam28Packages.erlang
    beam28Packages.rebar3
    gleam
    glas

    # Window manager / wayland bits (system-level)
    libnotify
    xdg-desktop-portal-gtk
    xwayland
    meson
    wayland-protocols
    wayland-utils
    wlroots
    pavucontrol
    blueman
    bluez
    bluez-tools

    # Games Support
    steam
    r2modman
    lutris

    # Filesystem support
    btrfs-progs

    # Theming
    gruvbox-gtk-theme
    gruvbox-plus-icons
    capitaine-cursors-themed
    catppuccin
  ];

  fonts.packages = with pkgs; [
    iosevka
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.symbols-only
    font-awesome
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
};
}
