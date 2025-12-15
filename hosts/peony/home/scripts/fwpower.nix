{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "fwpower";
      runtimeInputs = [pkgs.bc];
      text = ''
        current_raw="$(cat /sys/class/power_supply/BAT1/current_now)"
        voltage_raw="$(cat /sys/class/power_supply/BAT1/voltage_now)"

        current="$(bc <<<"scale=5; $current_raw/1000000")"
        voltage="$(bc <<<"scale=5; $voltage_raw/1000000")"
        power="$(bc <<<"$voltage*$current")"

        case "$(cat /sys/class/power_supply/BAT1/status)" in
          Charging)    sign="+" ;;
          Discharging) sign="-" ;;
          *)           sign="" ;;
        esac

        LC_NUMERIC="en_US.UTF-8" printf "%s%.2f W\n" "$sign" "$power"
      '';
    })
  ];
}
