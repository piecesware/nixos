{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.disko = {
    url = github:nix-community/disko;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, disko, ... }: {
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
