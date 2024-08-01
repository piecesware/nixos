{
  inputs = {
    # NOTE: Replace "nixos-23.11" with that which is in system.stateVersion of
    # configuration.nix. You can also use latter versions if you wish to
    # upgrade.
    nixpkgs2311.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = github:nix-community/disko;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = input@{ self, nixpkgs, disko, impermanence ... }: {
    nixosConfigurations.minime = nixpkgs.lib.nixosSystem {
      # NOTE: Change this to aarch64-linux if you are on ARM
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix 
        inputs.impermanence.nixosModules.impermanence
      ];
    };
    nixosConfigurations.pieces2 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configs/vconf.nix
        disko.nixosModules.disko
        ./disk-config.nix
        {
          _module.args.disks = [ "/dev/sda" ];
          boot.loader.grub = {
            devices = [ "/dev/sda" ];
          };
        }
      ];
    };
    nixosConfigurations.pieces2-lvm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configs/vconf.nix
        disko.nixosModules.disko
        ./disk-config-lvm.nix
        {
          _module.args.disks = [ "/dev/sda" ];
          boot.loader.grub = {
            devices = [ "/dev/sda" ];
          };
        }
      ];
    };
    nixosConfigurations.pieces2-lvm-luks = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configs/vconf.nix
        disko.nixosModules.disko
        ./disk-config-lvm-luks.nix
        {
          _module.args.disks = [ "/dev/sda" ];
          boot.loader.grub = {
            devices = [ "/dev/sda" ];
          };
        }
      ];
    };
  };
}
