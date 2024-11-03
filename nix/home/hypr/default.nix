{ pkgs
, inputs
, system
, ...
}: {
  services.mako = {
    enable = false;
    anchor = "top-right";
    font = "Inter Bold 12";
    backgroundColor = "#1A1B26";
    textColor = "#c0caf5";
  };

  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/eww" = {
      source = ./eww;
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    inputs.swww.packages.${system}.swww
    grimblast
    hyprpicker
    tofi
    swappy
    eww
    wl-clipboard
    clipse
  ];
}
