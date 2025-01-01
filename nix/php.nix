{ pkgs
, lib
, config
, user
, ...
}:
let
  app = "atlas";
  domain = "localhost";
  dataDir = "/home/${user}/Projects/PHP/Atlas";
in
{
  services.phpfpm.pools.${app} = {
    user = app;
    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };
  services.nginx = {
    enable = true;
    virtualHosts.${domain} = {
      listen = [
        {
          addr = "localhost";
          port = 3000;
        }
      ];
      locations."/" = {
        root = dataDir;
        tryFiles = "$uri $uri/ /jasperclarke.com/index.php?$query_string";
        extraConfig = ''
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_pass unix:${config.services.phpfpm.pools.${app}.socket};
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
      };
    };
  };
  users.users.${app} = {
    isSystemUser = true;
    createHome = true;
    home = dataDir;
    group = app;
  };
  users.groups.${app} = { };
}
