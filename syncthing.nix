{config, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "hana";
    group = "users";
    configDir = "${config.users.users.hana.home}/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        phone = {
          id = "N2XK34D-Y6HRJVH-AJYS6MH-XUZAF4Y-UOFPBUG-ZECJC5Y-JRM3Q3J-AJSNHAY";
          name = "Kočk Xperia 1 V";
        };
        nas = {
          id = "PY5VBZF-EGC5OPF-WDTCBG4-2MBZCK2-WD66ETA-T6WMOCC-CXIORH3-3J3K7AR";
          name = "NAS";
        };
        dawn-desktop = {
          id = "3M4GJYE-KCTH2GI-7XIC6IG-BKZ2TKI-HJTMVP3-UXBCFIY-CVJT2GQ-6VBF6QH";
          name = "PONI-CATTO";
        };
        dawn-phone = {
          id = "CLEC7MH-JMO7LCR-542RMDK-ABUGSDZ-2D5UJUK-6TSJT36-Q4IXTJM-NIUAGQI";
          name = "Dawn Pixel 6 Pro";
        };
      };

      folders = {
        "6zqvq-sn64z" = {
          label = "Kot";
          path = "${config.users.users.hana.home}/syncthing/Kot";
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "31";
          };
          devices = ["phone" "nas"];
        };
        "snekurr-shared" = {
          label = "Shared";
          path = "${config.users.users.hana.home}/syncthing/Shared";
          devices = ["phone" "nas" "dawn-desktop" "dawn-phone"];
        };
      };
    };
  };
}
