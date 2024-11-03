{ config, pkgs, lib, inputs, user, version, system, ... }:
{
  imports = [
    ./hypr
    ./terminal.nix
    ./browser.nix
  ];
 
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "${version}";
    packages = with pkgs; [
      inputs.nixvim.packages.${system}.default
      jetbrains-mono
      inter
      (nerdfonts.override {fonts = [ "Iosevka" ]; })
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
