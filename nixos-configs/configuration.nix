# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
#  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];

#  nix = {
#    autoOptimiseStore = true;
    # nixPath = [
      # "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      # "nixos-config=/etc/nixos/hosts/${variables.hostname}/default.nix"
      # "/nix/var/nix/profiles/per-user/root/channels"
    # ];
#  };
  
  environment.systemPackages = with pkgs; [
    curl
    exfatprogs
    firefox
    git
    gparted
    htop
    kate
    krusader
    vlc
    #vscode
    wget
    #kakoune
  ];

# https://www.tweag.io/blog/2022-11-01-hard-user-separation-with-nixos/
# encrypted /boot https://elvishjerricco.github.io/2018/12/06/encrypted-boot-on-zfs-with-nixos.html
# encrypted boot https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f
# encrypted swap partition https://ipetkov.dev/blog/nixos-on-the-pibox/
# https://nixos.wiki/wiki/Change_root
# https://www.adyxax.org/blog/2023/11/13/recovering-a-nixos-installation-from-a-linux-rescue-image/?utm_source=indieblog.page&utm_medium=list&utm_campaign=indieblog.page
# https://www.reddit.com/r/NixOS/comments/18wcns9/can_you_rebuild_nixos_from_a_configurationnix/

  boot.loader.systemd-boot.enable = false;
  boot.loader = {
    # Tell NixOS to install Grub as an EFI application in /efi
    efi.efiSysMountPoint = "/boot";

    grub = {
      enable = true;
      #device = "/dev/nvme0n1" #
      device = "nodev"; # Do not install Grub for BIOS booting.
      efiSupport = true;
      useOSProber = false;
      #extraInitrd = "/boot/initrd.keys.gz"; # Add our LUKS key to the initrd
      enableCryptodisk = true; # Allow Grub to boot from LUKS devices.
      #zfsSupport = true;
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
       '';
    };
    grub.efiInstallAsRemovable = false;
    efi.canTouchEfiVariables = false;
  };

#  boot.kernelPackages = pkgs.linuxPackages_latest;
  # to prevent a boot issue with LVM+LUKS
  boot.initrd.preLVMCommands = "lvm vgchange -ay";
  boot.supportedFilesystems = [ "btrfs" ];
#  hardware.enableAllFirmware = true;

  # some wifi cards may not work without it
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "minime";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  sound.enable = true;
  hardware.pulseaudio.enable = true;

#  services.xserver.enable
# Enable KDE Plasma 6
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  services.xserver = {
#    displayManager.sddm.enable = true;
    enable = true;
    xkb.layout = "us";
    xkb.variant = ""; 
#    desktopManager.plasma5.enable = true;
#    libinput.enable = true;
    # simple setup with i3
    #windowManager.i3.enable = true;
  };

  # declaring a shared user between the two contexts
  users.users.geoffadmin = {
    isNormalUser = true;
    #initialPassword = "";
    hashedPassword = "$y$j9T$445xsJ9GliL7DURqP3.6A1$BWc81tf9r0T/TLRGcbJsb/gvAphSNvt1.9ZveF8Xjc4";
    #shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager" "sudo"];
  };

  services.openssh.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
}
