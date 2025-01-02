{ pkgs
, inputs
, user
, version
, system
, ...
}: {
  imports = [
    ./terminal.nix
    ./browser.nix
    ./music.nix
  ];

  # programs.autorandr = {
  #   enable = true;
  #   profiles.default = {
  #     config = {
  #       "DP-2" = {
  #         enable = true;
  #         mode = "2560x1440";
  #         position = "0x0";
  #         rate = "144.00";
  #         primary = true;
  #       };
  #       "DP-0" = {
  #         enable = true;
  #         mode = "1920x1080";
  #         position = "2560x0";
  #         rate = "75.00";
  #         rotate = "left";
  #       };
  #     };
  #     fingerprint = {
  #       "DP-2" = "00ffffffffffff005a6338a72f5d0000151f0104b53c22783f9f00ad4f44ac270d5054bfef80d1c08140818090409500a940b300a9c09ee00078a0a032501040350056502100001e000000fd003092f0f03c010a202020202020000000fc005658323735382d534552494553000000ff005656463231323132333835350a0184020324f151010304050790121314161f2021223f4061230907078301000065030c001000f5bd00a0a0a032502040450056502100001e023a801871382d403020360056502100001efa7e8088703812401820350056502100001e565e00a0a0a029503020350056502100001e00000000000000000000000000000000000000c8";
  #       "DP-0" = "00ffffffffffff0010acf341425a3041331f0104a5351e783bf995a755549c260f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00393639333448330a2020202020000000fc0044454c4c20533234323148530a000000fd00304b535312010a20202020202001ab020325f14f90050403020716010611121513141f2309070783010000681a00000101304b002a4480a070382740302035000f282100001a011d007251d01e206e2855000f282100001e011d8018711c1620582c25000f282100009e8c0ad08a20e02d10103e96000f28210000180000000000000000000000000000000000001c";
  #     };
  #   };
  # };

  # services.autorandr.enable = true;

  services.gnome-keyring.enable = true;

  stylix.targets = {
    wofi.enable = false;
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "${version}";
    packages = with pkgs; [
      (writers.writeBashBin "herb-ws-switch" ./scripts/herb-ws-switch)
      # (writers.writeBashBin "p" ./scripts/projs)
      gum
      nerd-fonts.iosevka
      rounded-mgenplus
      motrix
      gimp
      btop
      inputs.nixvim.packages.${system}.default
      nitrogen
      picom
      rofi
      polybar
      flameshot
      xclip
      xsel
      wmctrl
      mpv
      appimage-run
      unzip
      zip
      zed-editor

      audacity

      prismlauncher
    ];
    file = {
      ".config/herbstluftwm/autostart" = {
        source = ./config/herbstluftwm;
        force = true;
        executable = true;
      };
      ".config/picom.conf" = {
        source = ./config/picom.conf;
        force = true;
      };
      ".config/polybar/config.ini" = {
        source = ./config/polybar.ini;
        force = true;
      };
    };
  };
}
