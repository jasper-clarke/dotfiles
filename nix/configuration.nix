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
    # ./steam.nix
  ];

  stylix = {
    enable = true;
    image = ./home/walls/dark-fuji.png;
    polarity = "dark";
    base16Scheme = {
      slug = "Vapor";
      scheme = "Vapor Theme";
      author = "Jasper Clarke (https://jasperclarke.com)";
      base00 = "#12141A";
      base01 = "#181A22";
      base02 = "#1E202A";
      base03 = "#2A2C36";
      base04 = "#666B7A";
      base05 = "#D1D3DA";
      base06 = "#E1E3EA";
      base07 = "#F1F3FA";
      base08 = "#E57B9E";
      base09 = "#E5A27B";
      base0A = "#E5D07B";
      base0B = "#87D996";
      base0C = "#7BC6E5";
      base0D = "#8495E5";
      base0E = "#B87BE5";
      base0F = "#E57B7B";
    };
    fonts = {
      sizes = {
        terminal = 17;
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
    };
    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 44;
    };
  };

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

  # virtualisation.virtualbox.host.enable = true;

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
      displayManager.startx.enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
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
    # Haskell Language Server XMonad Support
    (haskellPackages.ghcWithPackages (hpkgs: [
      hpkgs.xmonad
      hpkgs.xmonad-contrib
      hpkgs.xmonad-extras
    ]))
  ];

  system.stateVersion = "${version}"; # Did you read the comment?
}
