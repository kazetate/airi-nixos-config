{ config, pkgs, ... }:
{
  # Dev tools layer (scaffold).
  programs.git.enable = true;
  programs.zsh.enable = true;
}

