{
  pkgs,
  username,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    settings = {
      auto-update = "off"; # Nix handles updates
      font-family = "MesloLGS Nerd Font Mono";
    };
  };

  home.packages = [pkgs.nerd-fonts.meslo-lg];
}
