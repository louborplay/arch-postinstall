#!/bin/sh

set -e

# Set pacman config
sudo cp ./configs/pacman.conf /etc/pacman.conf

sudo pacman -Syy

# Remove beep
sudo sh -c 'echo "blacklist pcspkr" >> /etc/mkinitcpio.d/nobeep.conf'

# Install Refletor
sudo pacman -S --needed rsync reflector --noconfirm

# Change mirrors -- BR
#sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
#sudo sh -c 'reflector -c br --sort delay --protocol https >> /etc/pacman.d/mirrorlist'

# Install yay
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --needed --noconfirm
cd ..
sudo rm -rf ./yay

# Kernel
sudo pacman -S --needed linux-headers --noconfirm

# Bluetooth
sudo pacman -S -needed bluez bluez-utils --noconfirm

# Gnome
sudo pacman -S --needed gnome gnome-tweaks  --noconfirm
sudo pacman -Rs epiphany gnome-tour --noconfirm
sudo pacman -S --needed papirus-icon-theme --noconfirm
sudo pacman -S --needed file-roller --noconfirm
sudo pacman -S --needed gtk-engines gtk-engine-murrine gnome-themes-extra --noconfirm
yay -S --needed gnome-shell-extension-radio-git gnome-shell-extension-caffeine-git gnome-shell-extension-systemd-manager gnome-shell-extension-appindicator gnome-shell-extension-x11gestures gnome-shell-extension-gpu-profile-selector-git gnome-browser-connector menulibre --noconfirm
sudo systemctl enanle gdm.service

# Utils
sudo pacman -S --needed man bash-completion discord ntfs-3g android-tools qbittorrent sysstat unrar p7zip perl-rename touchegg mangohud --noconfirm

# Devel
sudo pacman -S --needed ufw docker docker-compose vim zsh samba neofetch --noconfirm

# SDKs
sudo pacman -S --needed jdk8-openjdk jdk11-openjdk jdk17-openjdk jdk-openjdk --noconfirm
sudo pacman -S --needed nodejs-lts-hydrogen npm --noconfirm

# Wine
sudo pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader --noconfirm

# NVIDIA Drivers
sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader --noconfirm

# Game Center
sudo pacman -S --needed lutris steam --noconfirm

# AUR packages
yay -S --needed timeshift visual-studio-code-bin google-chrome --noconfirm
xdg-mime default org.gnome.Nautilus.desktop inode/directory

# Clean
yay -Yc --noconfirm
yay -Scc --noconfirm
yay -Sc --noconfirm

# Configure Docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Services
sudo systemctl enable touchegg.service bluetooth.service avahi-daemon.service nmb.service cronie.service

# Config SAMBA
sudo cp configs/smb.conf /etc/samba/smb.conf

# QT5 for MultiMC
sudo pacman --needed qt5-base --noconfirm

# boot
sudo mkinitcpio -P

# Firewall
sudo ufw enable
sudo ufw allow CIFS
sudo ufw allow 8096

# Backup
sudo timeshift --create

# SHELL
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "export EDITOR=vim" >> ~/.zshrc
echo "export ANDROID_HOME=/home/danilo/Android/Sdk" >> ~/.zshrc

# Reboot
sudo reboot now
