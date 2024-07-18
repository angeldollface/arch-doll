#!/usr/bin/env bash

base_setup(){
    loadkeys de-latin1
    setfont ter-132b
    ip link
    timedatectl
    cfdisk
    mkfs.ext4 /dev/sda1
    mkfs.fat -F 32 /dev/sda2
    mount /dev/sda1 /mnt
    mount /dev/sda2 /mnt/boot --mkdir
    pactsrap -K /mnt \
        base \
        linux-zen \
        linux-firmware \
        alsa-utils \
        base-devel \
        efibootmgr \
        firefox \
        git \
        grub \
        gvfs \
        lightdm \
        lightdm-gtk-greeter \
        neovim \
        networkmanager \
        pulseaudio \
        sudo \
        thunar \
        xorg \
        plymouth \
        rust \
        noto-fonts-emoji \
    genfstab -U /mnt >> /mtn/etc/fstab
}

finish_setup(){
   ln -sf /usr/share/zoneinfo/Europe/Vienna /etc/localtime | arch-chroot /mnt /bin/bash
   hwclock --systohc | arch-chroot /mnt /bin/bash
   nvim /etc/locale.gen | arch-chroot /mnt /bin/bash
   locale-gen | arch-chroot /mnt /bin/bash
   touch /etc/locale.conf | arch-chroot /mnt /bin/bash
   echo "LANG=en_GB.UTF-8" > /etc/locale.conf | arch-chroot /mnt /bin/bash
   touch /etc/vconsole.conf | arch-chroot /mnt /bin/bash
   echo "KEYMAP=de-latin1-nodeadkeys" > /etc/vconsole.conf | arch-chroot /mnt /bin/bash
   touch /etc/hostname | arch-chroot /mnt /bin/bash
   echo "angelswings" > /etc/hostname | arch-chroot /mnt /bin/bash
   export EDITOR=nvim | arch-chroot /mnt /bin/bash
   visudo | arch-chroot /mnt /bin/bash
   useradd -m angel | arch-chroot /mnt /bin/bash
   passwd root | arch-chroot /mnt /bin/bash
   passwd angel | arch-chroot /mnt /bin/bash
   usermod -aG wheel angel | arch-chroot /mnt /bin/bash
   grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB | arch-chroot /mnt /bin/bash
   grub-mkconfig -o /boot/grub/grub.cfg | arch-chroot /mnt /bin/bash
   systemctl enable NetworkManager.service | arch-chroot /mnt /bin/bash
   systemctl start NetworkManager.service | arch-chroot /mnt /bin/bash
   su - angel | arch-chroot /mnt /bin/bash
   git clone https://aur.archlinux.org/paru.git | arch-chroot /mnt /bin/bash
   cd paru | arch-chroot /mnt /bin/bash
   makepkg -si | arch-chroot /mnt /bin/bash
   cd .. | arch-chroot /mnt /bin/bash
   rm -rf paru | arch-chroot /mnt /bin/bash
   
   # STILL MISSING:
   # - Install my splashscreen.
   # - Install my wallpapers.
   # - Install my new rice.
   # - Change init system to Open RC.
}