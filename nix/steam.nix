{ pkgs
, user
, ...
}: {
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    gamemode.enable = true;
  };

  /*
    services.joycond.enable = true;
  */

  environment.systemPackages = with pkgs; [
    protonup
    mangohud
    /*
      joycond-cemuhook
    */
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${user}/.steam/root/compatibilitytools.d";
  };
}
