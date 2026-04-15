{ self, inputs, ... }: {
  flake.nixosModules.zsh = { pkgs, lib, config, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      ohMyZsh = {
        enable = true;
        theme = "jonathan";
        plugins = [];                 
      };

      #shellInit = "fastfetch";
      
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "cursor"
          "root"
        ];
        patterns = { "rm -rf *" = "fg=white,bold,bg=red"; };
      };

      # History settings
      histSize = 10000;
      histFile = "$HOME/.zsh_history";

      # Aliases
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake sisyphus/.#lambda";
        cdd = "cd ..";
        rm = "rm -i";
        mv = "mv -i";
        la = "ls -a";
        ll = "ls -al";
        doom = "~/.emacs.d/bin/doom";
        crone = "crontab -e";
        cronl = "crontab -l";
        gs = "git status";
        ngc = "sudo nix-collect-garbage --deleted-old";
      };
    };

    # Set Zsh as the default shell for user 'john'
    users.users.john = {
      shell = pkgs.zsh;              # uses the standard zsh from nixpkgs
    };
  };
}
