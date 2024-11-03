{pkgs, lib, config, user, ...}:
{
  programs.firefox = {
    enable = true;
    profiles.${user} = {
      isDefault = true;
      search = {
        default = "DuckDuckGo";
        force = true;
      };
    };
  };
}
