{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-2.tar.gz";
    home-manager.url = "github:nix-community/home-manager/master";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    #self,
    nixpkgs,
    nixos-hardware,
    lix-module,
    home-manager,
    ...
  }: {
    nixosConfigurations.peony = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit nixpkgs;};
      system = "x86_64-linux";
      modules = [
        hosts/peony
        nixos-hardware.nixosModules.framework-13-7040-amd
        lix-module.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.hana = hosts/peony/home;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };
  };
}
