# NixOS on VPS
install nix package manager on local computer
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run nixpkgs#cowsay hello world!

create ssh key on local computer
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)-$(date -I)"

need a password for root
passwd root to set password

copy public key to VPS
ssh-copy-id -i ~/.ssh/nixos-vps_ed25519.pub root@[server_ip]

test ssh login with key
ssh -i ~/.ssh/nixos-vps_ed25519 root@[server_ip]

clone git repository onto local computer
git clone

the nix configuration will create an initial password

change into the git directory
cd

Start install of NixOS
nix run github:numtide/nixos-anywhere -- --flake ./#[system_name] -i ~/.ssh/nixos-vps_ed25519 root@[server_ip]

It will take about 10 minutes to install NixOS

Connect to VPS
ssh -i ~/.ssh/nixos-vps_ed25519 root@2[server_ip]

change password for each user.


nixos-rebuild --flake github:piecesware/nixos#pieces2 switch
nixos-rebuild --flake github:piecesware/nixos#pieces2 switch --option eval-cache false --option tarball-ttl 0

https://discourse.nixos.org/t/luks-on-lvm-external-hdd-after-hw-scan-system-wont-boot/9783/4
No, no matter what I set preLVM to [EDIT please see edit below], it won’t boot unless I comment out the section on hardware-configuration.nix.
EDIT: I had to set “preLVM = false” instead. Man that is a confusing name. It means “if set to true, decryption will be attempted before LVM scan”.
Still, this isn’t a good solution because now I can’t boot without the external drive plugged in, so I still depend on crypttab for now.
boot.initrd.luks.devices."ilanders-crypt".preLVM = false;
boot.initrd.luks.devices."ilanders-crypt".device = "/dev/disk/by-uuid/[uuidhere]"

https://unix.stackexchange.com/questions/574215/setting-up-nixos-with-lvmcache-and-luks-on-lvm
boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "ehci_pci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-cache" "dm-cache-smq" "dm-cache-mq" "dm-cache-cleaner" ];
  boot.kernelModules = [ "kvm-amd" "dm-cache" "dm-cache-smq" "dm-persistent-data" "dm-bio-prison" "dm-clone" "dm-crypt" "dm-writecache" "dm-mirror" "dm-snapshot"];

  boot.initrd.luks.devices = {
    "decrypted" = {
      device = "/dev/mapper/vg-crypt";
      allowDiscards = true;
      preLVM = false;
    };
  };
The main trick was to have "dm-cache-smq" in modules - without it, I was getting a similar error message like what you're getting.

You'll have an ugly warning message about cache_check missing - to get rid of it, add this too:
services.lvm.boot.thin.enable = true;

https://cinnabar.fr/posts/2018-12-24-nixos-installation.html
https://discourse.nixos.org/t/decrypting-other-drives-after-the-root-device-has-been-decrypted-using-a-keyfile/21281
https://discourse.nixos.org/t/security-pam-mount-no-examples/26585
https://github.com/tweag/nixos-specialisation-dual-boot/blob/master/configuration/work.nix
https://www.tweag.io/blog/2022-11-01-hard-user-separation-with-nixos/
https://git.sr.ht/~fd/nix-configs/tree
https://ersei.net/en/blog/its-nixin-time
https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
https://www.tweag.io/blog/2022-08-18-nixos-specialisations/
https://www.reddit.com/r/NixOS/comments/tzksw4/mount_an_encrypted_zfs_datastore_on_login/?rdt=62878
https://mynixos.com/options/users.extraUsers.%3Cname%3E
https://github.com/nix-community/home-manager/pull/2548
https://www.reddit.com/r/NixOS/comments/183mgu1/encrypted_home_homemanager_service_startup_order/
https://www.google.com/search?q=cryptHomeLuks&sourceid=chrome&ie=UTF-8
https://github.com/NixOS/nixpkgs/issues/21314
https://www.google.com/search?q=nixos+mount+luks+during+login&sca_esv=597851563&ei=Z4GhZcWKBszCkPIPl8WtuAI&oq=nixos+mount+luks+during+l&gs_lp=Egxnd3Mtd2l6LXNlcnAaAhgDIhluaXhvcyBtb3VudCBsdWtzIGR1cmluZyBsKgIIAjIIECEYoAEYiwMyCBAhGKABGIsDMggQIRigARiLAzIIECEYoAEYiwMyCBAhGKABGIsDMggQIRigARiLAzIIECEYoAEYiwMyCBAhGKABGIsDMggQIRigARiLAzIIECEYqwIYiwNI19gBUKEEWOauAXAAeACQAQCYAbwCoAG2KqoBCDAuMjAuOS4yuAEDyAEA-AEBwgILEAAYiQUYogQYsAPCAgsQABiABBiiBBiwA8ICCBAAGIkFGKIEwgIIEAAYgAQYogTCAgYQABgWGB7CAgsQABiABBiKBRiRAsICBRAAGIAEwgIREAAYgAQYigUYkQIYsQMYgwHCAgsQABiABBixAxiDAcICBRAhGKsCwgIFECEYoAHiAwQYASBBiAYBkAYE&sclient=gws-wiz-serp#ip=1
