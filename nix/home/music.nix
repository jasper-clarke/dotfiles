{ pkgs, ... }: {
  home.packages = with pkgs; [
    playerctl
    spotify
    rmpc
    mpc-cli
    mpdris2
  ];

  home.file.".config/wireplumber/wireplumber.conf.d/pebble-reverse.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            node.name = "~alsa_output.usb-ACTIONS_Pebble_V3-00.*",
          }
        ]
        actions = {
          update-props = {
            audio.position = ["FR", "FL"],
          }
        }
      }
    ]
  '';
}
