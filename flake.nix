{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    zen-browser.url = "github:FBIGlowie/zen-browser-flake";

    nixvim.url = "path:/home/jasper/.nixvim";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";
      version = "25.05";
      user = "jasper";
      hostname = "lambda";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        ${hostname} = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit user hostname version inputs pkgs; };
          modules = [
            ./nix/configuration.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit pkgs user system version inputs; };
              home-manager.users.${user} = {
                imports = [
                  ./nix/home
                ];
              };
            }
          ];
        };
      };
    };
}
