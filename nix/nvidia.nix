{
  pkgs,
  config,
  libs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  # environment.systemPackages = with pkgs; [
  # ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
