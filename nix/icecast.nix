{ config
, lib
, pkgs
, user
, ...
}:
let
  cfg = config.services.icecastJasper;
in
{
  ###### interface

  options = {
    services.icecastJasper = {
      enable = lib.mkEnableOption "Icecast server";

      hostname = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "DNS name or IP address that will be used for the stream directory lookups or possibly the playlist generation if a Host header is not provided.";
        default = config.networking.domain;
        defaultText = lib.literalExpression "config.networking.domain";
      };

      admin = {
        user = lib.mkOption {
          type = lib.types.str;
          description = "Username used for all administration functions.";
          default = "admin";
        };

        password = lib.mkOption {
          type = lib.types.str;
          description = "Password used for all administration functions.";
        };
      };

      logDir = lib.mkOption {
        type = lib.types.path;
        description = "Base directory used for logging.";
        default = "/var/log/icecast";
      };

      listen = {
        port = lib.mkOption {
          type = lib.types.port;
          description = "TCP port that will be used to accept client connections.";
          default = 8000;
        };

        address = lib.mkOption {
          type = lib.types.str;
          description = "Address Icecast will listen on.";
          default = "::";
        };
      };

      package = lib.mkOption {
        type = lib.types.package;
        description = "Package providing icecast.";
        default = pkgs.icecast;
      };

      user = lib.mkOption {
        type = lib.types.str;
        description = "User privileges for the server.";
        default = "nobody";
      };

      group = lib.mkOption {
        type = lib.types.str;
        description = "Group privileges for the server.";
        default = "nogroup";
      };

      extraConf = lib.mkOption {
        type = lib.types.lines;
        description = "icecast.xml content.";
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.icecastJasper = {
      after = [ "network.target" ];
      description = "Icecast Network Audio Streaming Server";
      wantedBy = [ "multi-user.target" ];

      preStart = "mkdir -p ${cfg.logDir} && chown ${cfg.user}:${cfg.group} ${cfg.logDir}";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/icecast -c /home/${user}/.icecast.xml";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
