{ config, lib, pkgs, user, version, hostname, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nvidia.nix
    ];

    boot = {
      supportedFilesystems = ["ntfs"];
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

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      home = "/home/${user}";
      shell = pkgs.zsh;
    };

    programs = {
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

