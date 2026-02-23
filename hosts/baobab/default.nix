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

  nix.settings.experimental-features = ["flakes" "nix-command"];

  networking.firewall.enable = false;
  services.fail2ban.enable = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # This is needed because otherwise systemd-logind spams the journal with:
  # Requested suspend operation not supported, ignoring.
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  users.users.hana = {
    isNormalUser = true;
    description = "hana";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
