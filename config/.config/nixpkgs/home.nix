{ pkgs, ...}: {
  home.username = "qwerty_asdf";
  home.homeDirectory = "/home/qwerty_asdf";

  home.stateVersion = "22.05";

  # let home-manager manage itself
  programs.home-manager.enable = true;

  fonts.fontconfig = {
    enable = true;
  };
  
  home.packages = with pkgs; [
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
    neovim-remote
    nerdfonts
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
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
