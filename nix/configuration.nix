{ lib
, pkgs
, user
, version
, hostname
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./steam.nix
  ];

  hardware.i2c.enable = true;
  boot = {
    kernelModules = [ "i2c-dev" ];
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  time.timeZone = "Australia/Sydney";

  security.polkit.enable = true;
  security.rtkit.enable = true;

  hardware.pulseaudio.enable = lib.mkForce false;

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/${user}/Music";
      user = "${user}";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Pipewire Output"
        }
      '';
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    dbus.enable = true;
    openssh.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    displayManager = {
      sddm.enable = true;
    };
  };

  systemd = {
    services = {
      mpd.environment = {
        XDG_RUNTIME_DIR = "/run/user/1000";
      };
      NetworkManager-wait-online.enable = lib.mkForce false;
      "display-brightness-up" = {
        script = ''
          ${pkgs.ddcutil}/bin/ddcutil --model VG258 setvcp 10 50
          ${pkgs.ddcutil}/bin/ddcutil --model VX2758-SERIES setvcp 10 80
          ${pkgs.ddcutil}/bin/ddcutil --model 'DELL S2421HS' setvcp 10 70
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
      "display-brightness-down" = {
        script = ''
          ${pkgs.ddcutil}/bin/ddcutil --model VG258 setvcp 10 20
          ${pkgs.ddcutil}/bin/ddcutil --model VX2758-SERIES setvcp 10 50
          ${pkgs.ddcutil}/bin/ddcutil --model 'DELL S2421HS' setvcp 10 30
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
    timers = {
      "display-brightness-down" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*-*-* 17:30:00";
          Persistent = true;
        };
      };
      "display-brightness-up" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "1m";
        };
      };
    };
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    home = "/home/${user}";
    shell = pkgs.zsh;
  };

  programs = {
    nix-ld = {
      enable = true;
    };
    hyprland.enable = true;
    zsh.enable = true;
    nh = {
      enable = true;
      flake = "/home/${user}/.nixos";
    };
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "${version}"; # Did you read the comment?
}
