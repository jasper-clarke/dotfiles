{ pkgs, ... }: {
  programs.spotify-player = {
    enable = true;
    settings = {
      client_id = "ee811fa5ad8f4e08823683a5c4efad22";
      login_redirect_uri = "http://localhost:3000";
      default_device = "nixos-player";
      device = {
        name = "nixos-player";
        device_type = "computer";
        volume = 100;
        bitrate = 320;
        normalization = true;
      };
    };
  };
  home.packages = with pkgs; [
    rmpc
    mpc-cli
    mpdris2
  ];
}
