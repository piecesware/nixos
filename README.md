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
