{ pkgs, ...}: {
  home.username = "qwerty_asdf";
  home.homeDirectory = "/home/qwerty_asdf";

  home.stateVersion = "22.05";

  # let home-manager manage itself
  programs.home-manager.enable = true;

  fonts.fontconfig = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    bat
    btop
    cava
    clang
    cmake
    discord
    exa
    feh
    ffmpeg
    firefox
    fzf
    gitui
    gtypist
    iosevka
    imagemagick
    jq
    ktlint
    lld
    lolcat
    lynx
    mitmproxy
    mpv
    neofetch
    neovim-remote
    nerdfonts
    nmap
    nnn
    obsidian
    # pass - uncomment when using X
    pass-wayland
    racket
    react-native-debugger
    ripasso-cursive
    ripgrep
    rustup
    starship
    tab-rs
    tealdeer
    tmux
    traceroute
    tree-sitter
    # unclutter-xfixes
    # xclip
    yt-dlp
    zathura
    zig
    zk
    zsh
    zsh-autocomplete
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
