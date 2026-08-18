{
  pkgs,
  lib,
  ...
}: {
  services.llama-cpp = let
    qwen38-udq6kxl = pkgs.fetchurl {
      url = "https://huggingface.co/unsloth/Qwen3.8-27B-GGUF/resolve/fdd03b8bbd279c1694563650e79d85a2373d9934/Qwen3.8-27B-UD-Q6_K_XL.gguf";
      hash = "sha256-c5ICGG/ZOJu1hJfFi1bIoNQlPZnSATHmoEJ+Nj5nj8g=";
    };
  in {
    enable = true;
    package = pkgs.llama-cpp-vulkan;
    settings = {
      port = 63274;
      offline = true;
      no-warmup = true;
      parallel = 1;
      sleep-idle-seconds = 900;
      models-preset = pkgs.writeText "llama-models.ini" (
        lib.generators.toINI {} {
          "unsloth/Qwen3.8-27B:UD-Q6_K_XL" = {
            model = qwen38-udq6kxl;
            fit = "off";
            gpu-layers = "all";
            ctx-size = 262144;
            flash-attn = "on";
            temp = "1";
            top-p = "0.95";
            min-p = "0.00";
            top-k = "20";
            spec-type = "draft-mtp";
            spec-draft-n-max = 5;
            #chat-template-kwargs = builtins.toJSON {enable_thinking = false;};
          };
        }
      );
    };
  };
}
