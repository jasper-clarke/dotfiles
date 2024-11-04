{ pkgs, ... }: {
  home.packages = with pkgs; [
    playerctl
    spotify
    spotify-tray
    rmpc
    mpc-cli
    mpdris2
  ];
}
