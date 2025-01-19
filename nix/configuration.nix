{ lib
, pkgs
, user
, version
, hostname
, config
, ...
}:
let
  colors = {
    slug = "Vapor";
    scheme = "Vapor Theme";
    author = "Jasper Clarke (https://jasperclarke.com)";
    base00 = "#131313";
    base01 = "#1A1A1A";
    base02 = "#212121";
    base03 = "#4C4C4C";
    base04 = "#686868";
    base05 = "#D1D1D1";
    base06 = "#E1E1E1";
    base07 = "#F1F1F1";
    base08 = "#E57B9E";
    base09 = "#E5A27B";
    base0A = "#E5D07B";
    base0B = "#87D996";
    base0C = "#7BC6E5";
    base0D = "#8495E5";
    base0E = "#B87BE5";
    base0F = "#E57B7B";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./steam.nix
    ./icecast.nix
    # ./php.nix
  ];

  sops = {
    defaultSopsFile = ../secrets/mine.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [
        "/home/${user}/.ssh/private"
      ];
      generateKey = true;
    };
    secrets = {
      icecast_password = { };
    };
  };

  stylix = {
    enable = true;
    image = ./home/walls/to-the-stars.jpg;
    polarity = "dark";
    base16Scheme = colors;
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
    kernelPackages = pkgs.linuxKernel.packages.linux_6_11;
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
    # substituters = [ "https://ezkea.cachix.org" ];
    # trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    hosts = {
      "127.0.0.1" = [ "jasperclarke.local" ];
    };
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 8000;
          to = 8090;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 8000;
          to = 8090;
        }
      ];
    };
  };

  time.timeZone = "Australia/Sydney";

  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = 29360128;
    }
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = 29360128;
    }
  ];

  hardware.pulseaudio.enable = lib.mkForce false;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.libvirtd.enable = true;
  virtualisation.docker = {
    enable = true;
    # enableNvidia = true;
  };

  # Keyboard
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services = {
    wordpress.sites."localhost" = { };
    cloudflared = {
      enable = true;
      tunnels = {
        "6336a42b-24da-454d-949c-7ac44c4a72b6" = {
          credentialsFile = "/home/cloudflared/.cloudflared/6336a42b-24da-454d-949c-7ac44c4a72b6.json";
          default = "http_status:404";
        };
      };
    };
    icecastJasper = {
      enable = true;
      # package = pkgs.icecast.overrideAttrs (old: {
      #   version = "2.5-beta3";
      #   src = ../icecast-2.4.99.3;
      #   nativeBuildInputs = [
      #     pkgs.libxml2
      #     pkgs.libxml2.dev
      #     pkgs.libxslt
      #   ];
      #   buildInputs = [
      #     pkgs.pkg-config
      #     pkgs.libxml2
      #     pkgs.libxslt
      #     pkgs.curl
      #     pkgs.libvorbis
      #     pkgs.libtheora
      #     pkgs.speex
      #     pkgs.libkate
      #     pkgs.libopus
      #   ];
      # });
      # hostname = "localhost";
      # listen.port = 8050;
      # admin = {
      # user = "admin";
      # };
      # extraConf = ''
      # <shoutcast-mount>/live.nsv</shoutcast-mount>
      # '';
    };
    mpd = {
      enable = true;
      musicDirectory = "/home/${user}/Music";
      user = "${user}";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Pipewire Output"
        }

        audio_output {
          type "shout"
          name "Icecast Stream"
          host "localhost"
          port "8050"
          mount "/mpd"
          bitrate "192"
          format "44800:16:2"
          encoding "ogg"
          user "source"
          password "notfilled"
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
      # xrandrHeads = [
      #   {
      #     output = "DP-2";
      #     primary = true;
      #     monitorConfig = ''
      #       Modeline "2560x1440_144" 575.020 2560 2576 2640 2680 1440 1443 1448 1490 +hsync +vsync
      #       Option "PreferredMode" "2560x1440_144"
      #     '';
      #   }
      #   {
      #     output = "DP-0";
      #     monitorConfig = ''
      #       Modeline "1920x1080_60" 148.500 1920 2008 2052 2200 1080 1084 1089 1125 +hsync +vsync
      #       Option "Rotate" "left"
      #       Option "RightOf" "DP-2"
      #     '';
      #   }
      # ];
      displayManager = {
        setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 2560x1440 --rate 144.00 --primary --output DP-0 --mode 1920x1080 --rate 75.00 --right-of DP-2 --rotate left";
        startx.enable = true;
      };
      windowManager.herbstluftwm.enable = true;
      # windowManager.xmonad = {
      #   enable = true;
      #   # config = ./home/config/xmonad.hs;
      #   extraPackages = hpkgs: [
      #     hpkgs.xmonad-contrib_0_18_1
      #     hpkgs.xmonad-extras
      #   ];
      # };
    };
    displayManager.sddm = {
      enable = true;
      theme = "sugar-dark";
      extraPackages = with pkgs; [
        libsForQt5.qtgraphicaleffects
      ];
    };
  };

  environment.systemPackages = with pkgs; let
    sddm-themes = pkgs.callPackage ./sddm.nix { };
  in
  [
    # Keyboard
    blueman
    gnupg
    sddm-themes.sddm-sugar-dark
    butt

    # Haskell Language Server XMonad Support
    # (haskellPackages.ghcWithPackages (hpkgs: [
    #   hpkgs.xmonad
    #   hpkgs.xmonad-contrib_0_18_1
    #   hpkgs.xmonad-extras
    #   hpkgs.xmobar
    # ]))
    # xmobar
  ];

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
    # ladybird.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        curl
        dbus
        expat
        fontconfig
        freetype
        fuse3
        gdk-pixbuf
        glib
        gtk3
        icu
        wayland
        libGL
        libGLU
        glfw
        glew
        libappindicator-gtk3
        libdrm
        libglvnd
        libnotify
        libpulseaudio
        libunwind
        libusb1
        libuuid
        libxkbcommon
        libxml2
        mesa
        nspr
        nss
        openssl
        pango
        pipewire
        stdenv.cc.cc
        systemd
        vulkan-loader
        xorg.libX11
        xorg.libXScrnSaver
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libxcb
        xorg.libxkbfile
        xorg.libxshmfence
        xorg.libXxf86vm
        zlib
      ];
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
    zsh.enable = true;
    nh = {
      enable = true;
      flake = "/home/${user}/.nixos";
    };
  };

  system.stateVersion = "${version}"; # Did you read the comment?
}
