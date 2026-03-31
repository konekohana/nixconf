{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      alejandra
      basedpyright
      clang-tools # for clangd
      nil
      package-version-server
      rust-analyzer
      rustfmt
      ruff
    ];
    extensions = ["nix" "catppuccin" "toml"];
    userSettings = {
      edit_predictions.mode = "subtle";
      theme = {
        mode = "system";
        dark = "Catppuccin Macchiato";
        light = "Catppuccin Latte";
      };
      languages.Nix.formatter.external = {
        command = "alejandra";
        arguments = ["--quiet" "--"];
      };
      languages."Plain Text" = {
        ensure_final_newline_on_save = false;
        format_on_save = "off";
      };
    };
  };
}
