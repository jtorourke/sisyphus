{ config, lib, pkgs, inputs, self, ... }: {
  home.username = "john";
  home.homeDirectory = "/home/john";

  # IMPORTANT: pin this to the NixOS release you started on. Do not bump it
  # casually -- it controls HM's stateful-data compatibility, just like
  # system.stateVersion.
  home.stateVersion = "25.11";

  # Let HM manage itself
  programs.home-manager.enable = true;

  # ----- Packages (moved from users.users.john.packages in configuration.nix) -----
  home.packages = with pkgs; [
    # CLI tools
    wget
    curl
    ripgrep
    fd
    htop
    coreutils
    pandoc
    lazygit
    ranger
    nnn
    fastfetch
    screenfetch
    tuigreet
    wlgreet
    grimblast
    wf-recorder
    wl-clip-persist
    wl-clipboard
    appimage-run

    # Mounting / filesystem
    udevil
    udiskie
    udisks
    gvfs
    ntfs3g
    exfat
    usermount
    simplebluez

    # GUI apps
    kitty
    alacritty
    qview
    mpv
    audacious
    nautilus
    spotify-player
    inkscape-with-extensions
    pom
    discord
    vesktop
    qmk
    vial
    protonmail-bridge
    bitwarden-desktop
    obs-studio
    obs-studio-plugins.wlrobs
    davinci-resolve
    dbeaver-bin

    # Editors
    emacs
    vim
    neovim

    # Languages / toolchains / LSPs
    rustc
    cargo
    rust-analyzer
    clang
    cmake
    gnumake
    stack
    ghc
    haskell-language-server
    R
    python314
    isort
    pipenv
    php
    nixfmt
    graphviz
    shellcheck
    zig
    (julia_111-bin.withPackages [
      "DataFrames"
      "DataFramesMeta"
      "Statistics"
      "Plots"
      "CSV"
      "Random"
    ])

    # TeX
    texliveFull
    texlivePackages.wrapfig2
    texlivePackages.pdfmsym
    texlivePackages.ifsym
    texlivePackages.utfsym
    texlivePackages.marvosym
    texlivePackages.wasysym
  ];

  # ----- Programs (HM-native, preferred over dropping binaries in packages) -----
  programs.git = {
    enable = true;
    userName = "jtorourke";              # <-- fill in
    userEmail = "johnt@orourke.one";  # <-- fill in
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka NFM";
      size = 12;
    };
    themeFile = "GruvboxMaterialDarkHard";  # from kitty-themes; or omit and set colors manually
    settings = {
      background_opacity = "0.95";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      scrollback_lines = 10000;
      cursor_shape = "beam";
      window_padding_width = 8;
      tab_bar_style = "powerline";
    };
    keybindings = {
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+t" = "new_tab";
      "ctrl+alt+t" = "close_tab";
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
    };
    shellIntegration.enableZshIntegration = true;
  };
  
  programs.starship.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;  
    nix-direnv.enable = true;
  };

  home.pointerCursor = {
    name = "Capitaine Cursors (Gruvbox)";
    package = pkgs.capitaine-cursors-themed;
    size = 18;
    gtk.enable = true;
    x11.enable = true;
  };
  
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Capitaine Cursors (Gruvbox)";
      package = pkgs.capitaine-cursors-themed;
      size = 18;
    };
    font = {  
      name = "Iosevka Nerd Font Mono";
      size = 12;
    };
  };
  
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Iosevka Nerd Font Mono" ];
    sansSerif = [ "Iosevka Nerd Font Mono" ];
    serif = [ "Iosevka Nerd Font Mono" ];
  };
  
  # Force the env vars — something in your session is setting XCURSOR_THEME=default
  home.sessionVariables = {
    XCURSOR_THEME = "Capitaine Cursors (Gruvbox)";
    XCURSOR_SIZE = "18";
  };
  
  # Override the broken index.theme that HM generates with quotes
  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=Capitaine Cursors (Gruvbox)
  '';

  #programs.zsh = {
  #  enable = true;
  #  enableCompletion = true;
  #  syntaxHighlighting.enable = true;
  #  autosuggestion.enable = true;
  #  history.size = 10000;

  ##  oh-my-zsh = {
  ##    enable = true;
  ##    theme = "jonathan";
  ##    plugins = [ "git" ];
  ##  };

  ##  initContent = ''
  ##    fastfetch
  ##  '';

  ##  shellAliases = {
  ##    rebuild = "sudo nixos-rebuild switch --flake sisyphus/.#lambda";
  ##    cdd = "cd ..";
  ##    rm = "rm -i";
  ##    mv = "mv -i";
  ##    la = "ls -a";
  ##    ll = "ls -al";
  ##    doom = "~/.emacs.d/bin/doom";
  ##    crone = "crontab -e";
  ##    cronl = "crontab -l";
  ##    gs = "git status";
  ##    ngc = "sudo nix-collect-garbage --delete-old";
  ##  };
  #};
}
