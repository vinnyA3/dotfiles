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
    cmake
    discord
    exa
    feh
    ffmpeg
    fzf
    gitui
    gtypist
    iosevka
    jq
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
    ripgrep
    rust-analyzer
    rustup
    starship
    tab-rs
    tealdeer
    tmux
    traceroute
    tree-sitter
    unclutter-xfixes
    xclip
    yt-dlp
    zathura
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
