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
        exa
        fff
        fzf
        gtypist
        iosevka
        jq
        lynx
        nerdfonts
        neovim
        obsidian
        starship
        tab-rs
        tealdeer
        tmux
        traceroute
        tree-sitter
        yt-dlp
      ];

      pathsToLink = [ "/share" "/bin" ];
    });
  };
}
