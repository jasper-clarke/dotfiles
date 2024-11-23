{ inputs
, user
, pkgs
, system
, ...
}: {
  home.packages = [
    inputs.zen-browser.packages.${system}.default
    pkgs.tridactyl-native
  ];
  programs.firefox = {
    enable = false;
    # nativeMessagingHosts = [ pkgs.tridactyl-native ];
    profiles.${user} = {
      isDefault = true;
      # extensions = with inputs.firefox-addons.packages.${system}; [
      #   bitwarden
      #   darkreader
      #   ublock-origin
      #   tridactyl
      # ];
      search = {
        default = "DuckDuckGo";
        force = true;
      };
    };
  };
}
