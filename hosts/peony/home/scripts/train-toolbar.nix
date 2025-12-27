{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "train-toolbar";
      runtimeInputs = with pkgs; [curl jq wirelesstools];
      text = ''
        function getdata() {
            if [ "$(iwgetid -r)" != "$1" ];
                then return 1;
            fi

            if ! val="$(curl -s --max-time 4.8 "$2")"; then
                return 1
            fi

            $3 <<<"$val"
        }

        function process_oebb()   { sed 's|.*|🚄🇦🇹  & km/h|'; }
        function process_cdwifi() { jq -r '"🚄  \(.speed) km/h  \(.altitude) m"'; }

        if getdata "CDWiFi" 'http://cdwifi.cz/portal/api/vehicle/realtime' process_cdwifi; then exit 0; fi
        if getdata "OEBB" 'https://railnet.oebb.at/api/speed' process_oebb; then exit 0; fi
      '';
    })
  ];
}
