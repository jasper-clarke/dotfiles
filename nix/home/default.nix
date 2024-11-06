{ pkgs
, inputs
, user
, version
, system
, ...
}: {
  imports = [
    ./hypr
    ./terminal.nix
    ./browser.nix
    ./music.nix
  ];

  services.gnome-keyring.enable = true;

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "${version}";
    packages = with pkgs; [
      (writers.writeBashBin "ws-switch" ./scripts/ws-switch)
      inputs.nixvim.packages.${system}.default
      jetbrains-mono
      motrix
      inter
      zed-editor
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      size = 44;
      package = pkgs.bibata-cursors;
      name = "Bibata Modern Ice";
    };
  };
}
