{ pkgs }:

let
  inherit (pkgs) buildEnv;

in {
  # TODO: this needs to be tested
  # imports = [ ./rustlang-config.nix ];

  allowUnfree = true;

  packageOverrides = pkgs: {
    main = (buildEnv {
      name = "main";
      paths = with pkgs; [
        bat
        cmake
        discord
        exa
        feh
        fff
        fzf
        gitui
        gtypist
        iosevka
        jq
        lolcat
        lynx
        nerdfonts
        neovim-remote
        obsidian
        rust-analyzer
        starship
        tab-rs
        tealdeer
        tmux
        traceroute
        tree-sitter
        yt-dlp
        zathura
      ];

      pathsToLink = [ "/share" "/bin" ];
    });
  };
}
