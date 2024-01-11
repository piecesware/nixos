{ pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    exa
    xclip
    tree
  ];

  networking.hostName = "nixos"; # Define your hostname.
  #networking.networkmanager.enable = true;

  # Disable NixOS's builtin firewall
  networking.firewall.enable = false;

  #networking.firewall.allowedTCPPorts = [ 22 ];

  # Disable DHCP and configure IP manually
  networking.useDHCP = false;

  # Manage networking with systemd-networkd
  systemd.network.enable = true;
  services.resolved.enable = false;

  # Configure network IP and DNS
  systemd.network.networks.enp3s0 = {
    address = ["208.87.134.118/24"];
    gateway = ["208.87.134.1"];
    matchConfig.Name = "enp3s0";
  };
  networking.nameservers = [
    "8.8.8.8"
  ];  

  nixpkgs.config.allowUnfree = true;

  # user configuration
  users.users = {
    user1 = { # change this to you liking
      initialPassword = "helloworld";
      #hashedPassword = "";
      createHome = true;
      isNormalUser = true; # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/users-groups.nix#L100
      extraGroups = [
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDanr1bZEyyOywFYct6x4Mbesep6G5xjMyvaq9gWMDD+rAWf5YoPsM70BQQ+4osDWfd86ptrgFwNoM+NqHmtnfOh6rtaid4h4THegdehgmB+8OxhPejwDNpXbQ4gFUHzpHVw6bSA2bjPj8xbO8TMRSEGybADD9ytY3cMI/9ZtYqlBAofqeeb6Qe0yne36I+goUGcLVe0bvpYa3RqG1QstTMHGwrBUGWiSvqbUbzNfBoUtmtTDGA70UkTEXc/qkUlLHk+HN4iw9v23Q3d5fLz9z1/4oa7J47YB/L4BBEgDeritYqfxYZB228HbzMCnaKcydU5zc+KLdNucGFxkYTbfTqddKcSJDbqv7de6wK8GYm+Di1IYpIAeAOLv+ROFP6Y/xWXX2cOdNjQNs8SY9XV3eQP3KGi48WfKDCAt8qU9PSr6urZm2XqXBD2MQTftCBTnJLCsCf3PpZe39hS7pcrQyA9qfkHDCY2JSxgEJ/5kR5ZSexT3N0v+6Swh6NCrLPyXs= root@pieces1"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+1oWhpvuKi0Fqihi9BTafXTFTQvrEDzuVHb0Gmi+b/ geoff-admin@pieces1"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwwnyt/Zc4wsTbAovq83n5gGgMWLFIPSOfyIrW3F9L8JAxmu7Y1kPXw3pWqhjQlS5vHcgDZjFMw9QX5evxi7jTDy8Y999gwZO4YRiYYgAY6RS/2TM+b42plfRJewz4OcgJXT9XWwmnRmsAL9XZuCvbFzinkMksX7OwMSwG5/RhYOOmMzEhXuuxsJP2LQHcmSDaUdhmHlSqCcAiaROSYWktecZVAA6ZmvqbCaZymy2TSlF2wuodwfOy0EDVqJBN5/s5YQ+UG1Wc1TlrQzTQ91FHxZUvuflmCB8uSZreJdg9QzXNq5xdUkJVKaP9oJrihxbVIeeFaeyNYhnRU98z6TyG0OmlKC96mKeLI2zr7UtUV3fm8iUCTXcg93970HQO7+ooCKpiGrhzOSSTDg7edatHrvxGrTU15aKMo/LLK0ZGfRCiuZ75E/9XD3FTydIKquHLBGly+OHQ57nMRS46BYOtDblBe+rOXWjvEkSNY6IosCW6oQ8K7bRVuV5S9kRtl7M= root@DEBIAN-ASUS-BR1100FKA-YS02T"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHu0TVPp+cfaNCRaaqG1dsT+0Xb9tm7eaRDOTNPAXdQJ root@DEBIAN-ASUS-BR1100FKA-YS02T"
      ];
    };
    root = {
      initialPassword = "helloworld";
      #hashedPassword = "";
      extraGroups = [
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDanr1bZEyyOywFYct6x4Mbesep6G5xjMyvaq9gWMDD+rAWf5YoPsM70BQQ+4osDWfd86ptrgFwNoM+NqHmtnfOh6rtaid4h4THegdehgmB+8OxhPejwDNpXbQ4gFUHzpHVw6bSA2bjPj8xbO8TMRSEGybADD9ytY3cMI/9ZtYqlBAofqeeb6Qe0yne36I+goUGcLVe0bvpYa3RqG1QstTMHGwrBUGWiSvqbUbzNfBoUtmtTDGA70UkTEXc/qkUlLHk+HN4iw9v23Q3d5fLz9z1/4oa7J47YB/L4BBEgDeritYqfxYZB228HbzMCnaKcydU5zc+KLdNucGFxkYTbfTqddKcSJDbqv7de6wK8GYm+Di1IYpIAeAOLv+ROFP6Y/xWXX2cOdNjQNs8SY9XV3eQP3KGi48WfKDCAt8qU9PSr6urZm2XqXBD2MQTftCBTnJLCsCf3PpZe39hS7pcrQyA9qfkHDCY2JSxgEJ/5kR5ZSexT3N0v+6Swh6NCrLPyXs= root@pieces1"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+1oWhpvuKi0Fqihi9BTafXTFTQvrEDzuVHb0Gmi+b/ geoff-admin@pieces1"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwwnyt/Zc4wsTbAovq83n5gGgMWLFIPSOfyIrW3F9L8JAxmu7Y1kPXw3pWqhjQlS5vHcgDZjFMw9QX5evxi7jTDy8Y999gwZO4YRiYYgAY6RS/2TM+b42plfRJewz4OcgJXT9XWwmnRmsAL9XZuCvbFzinkMksX7OwMSwG5/RhYOOmMzEhXuuxsJP2LQHcmSDaUdhmHlSqCcAiaROSYWktecZVAA6ZmvqbCaZymy2TSlF2wuodwfOy0EDVqJBN5/s5YQ+UG1Wc1TlrQzTQ91FHxZUvuflmCB8uSZreJdg9QzXNq5xdUkJVKaP9oJrihxbVIeeFaeyNYhnRU98z6TyG0OmlKC96mKeLI2zr7UtUV3fm8iUCTXcg93970HQO7+ooCKpiGrhzOSSTDg7edatHrvxGrTU15aKMo/LLK0ZGfRCiuZ75E/9XD3FTydIKquHLBGly+OHQ57nMRS46BYOtDblBe+rOXWjvEkSNY6IosCW6oQ8K7bRVuV5S9kRtl7M= root@DEBIAN-ASUS-BR1100FKA-YS02T"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHu0TVPp+cfaNCRaaqG1dsT+0Xb9tm7eaRDOTNPAXdQJ root@DEBIAN-ASUS-BR1100FKA-YS02T"
      ];
    };
  };

  # ssh
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      #kexAlgorithms = [ "curve25519-sha256" ];
      #ciphers = [ "chacha20-poly1305@openssh.com" ];
      PasswordAuthentication = true;
      PermitRootLogin = "yes"; # do not allow to login as root user
      #kbdInteractiveAuthentication = false;
    };
  };

  # Timezone, change based on your location
  time.timeZone = "America/New_York";

  system.stateVersion = "23.11";
}
