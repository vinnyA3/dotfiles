{ pkgs }:

let
  inherit (pkgs) buildEnv;

in {
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
