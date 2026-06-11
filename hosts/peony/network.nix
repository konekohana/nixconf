{pkgs, ...}: {
  networking.hostName = "peony";

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    wifi.backend = "iwd";
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  networking.wireless.iwd = {
    enable = true;
    settings = {
      General.AddressRandomization = "network";
      General.Country = "CS";
      Settings.AutoConnect = true; # https://unix.stackexchange.com/a/623037
    };
  };
}
