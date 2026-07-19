# NixOS Config

This directory contains dotfiles that I really only want to use on my NixOS user machines.

## Usage

To pull only these nixos files, you can run the following in your `$HOME` directory:

```
git clone --filter=blob:none --no-checkout git@github.com:vinnyA3/dotfiles.git .dotfiles
cd .dotfiles

git sparse-checkout init --cone
git sparse-checkout set nixos

git checkout main
```
```
```
