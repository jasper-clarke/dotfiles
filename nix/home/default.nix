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
      jetbrains-mono
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
      motrix
      inter
      gimp
      btop
      zed-editor
      inputs.nixvim.packages.${system}.default

      nitrogen
      picom
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
