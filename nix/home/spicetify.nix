{ lib
, pkgs
, inputs
, ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  spicetify-nix = inputs.spicetify-nix;
in
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
    ];

  # import the flake's module for your system
  imports = [ spicetify-nix.homeManagerModules.default ];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    # theme = spicePkgs.themes.Sleek;
    # colorScheme = "BladeRunner";

    enabledExtensions = with spicePkgs.extensions; [
      # fullAppDisplay
      hidePodcasts
      adblock
    ];
  };

  # home.packages = [
  # pkgs.spotify-tray
  # ];
}
