# todo
# udev rule for shutdown on battery low
#   https://superuser.com/a/1850835
{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./ssh.nix
    ./tlp.nix
    ./netdata.nix
  ];

  networking.hostName = "baobab";

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  nix.settings.experimental-features = ["flakes" "nix-command"];

  networking.firewall.enable = false;
  services.fail2ban.enable = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  users.users.hana = {
    isNormalUser = true;
    description = "hana";
    extraGroups = ["wheel"];
  };

  system.stateVersion = "25.05";
}
