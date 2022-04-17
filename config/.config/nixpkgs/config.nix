with import <nixpkgs> {};

{
  allowUnfree = false;

  packageOverrides = pkgs: with pkgs; {
    main = pkgs.buildEnv {
      name = "main";
      paths = [
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
        starship
        tab-rs
        tealdeer
        tmux
        traceroute
        tree-sitter
        yt-dlp
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
