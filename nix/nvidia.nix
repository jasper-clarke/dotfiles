{ config, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];

  # environment.systemPackages = with pkgs; [
  # ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    forceFullCompositionPipeline = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # set environment variables
  environment.sessionVariables = {
    __GL_SYNC_DISPLAY_DEVICE = "DP-2";
    __GL_SYNC_TO_VBLANK = 0;
  };
}
