{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    #self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      peony = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit nixpkgs;};
        system = "x86_64-linux";
        modules = [
          hosts/peony
          modules/nixos/shell.nix
          modules/nixos/lix.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hana = hosts/peony/home;
            home-manager.users.root = {
              imports = [modules/home/shell.nix];
              home.username = "root";
              home.homeDirectory = "/root";
              home.stateVersion = "24.11";
            };
          }
        ];
      };

      baobab = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit nixpkgs;};
        system = "x86_64-linux";
        modules = [
          hosts/baobab
          modules/nixos/shell.nix
          modules/nixos/lix.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hana = hosts/baobab/home;
            home-manager.users.root = {
              imports = [modules/home/shell.nix];
              home.username = "root";
              home.homeDirectory = "/root";
              home.stateVersion = "25.05";
            };
          }
        ];
      };
    };
  };
}
