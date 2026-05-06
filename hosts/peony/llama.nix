{pkgs, ...}: {
  services.llama-cpp = {
    enable = true;
    port = 63274;
    extraFlags = ["--offline"];
    package = pkgs.llama-cpp-vulkan;
    modelsPreset = {
      "unsloth/gemma-4-E2B-it-GGUF:IQ3_XXS" = {
        hf-repo = "unsloth/gemma-4-E2B-it-GGUF:UD-IQ3_XXS";
        fit = "off";
        gpu-layers = "all";
        no-mmproj = true;
        ctx-size = 32768;
        flash-attn = "on";
        jinja = "on";
        cache-ram = "0";
        ctx-checkpoints = "0";
        temp = "1.0";
        top-p = "0.95";
        top-k = "64";
        #chat-template-kwargs = ''{"enable_thinking": false}'';
        chat-template-kwargs = builtins.toJSON {enable_thinking = false;};
        #reasoning-budget = "0";
      };
    };
  };
}
