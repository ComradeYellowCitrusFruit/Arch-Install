#!/usr/bin/env python
import os

print("Running arch-chroot /mnt")
os.system("arch-chroot /mnt")
print("Installing base packages:")
print("GRUB")
print("efibootmgr")
print("os-prober")
print("xz")
print("gcc")
print("Make")
print("Git")
print("Vim")
print("Pacman")
os.system("pacman -S grub efibootmgr os-prober xz gcc make git vim pacman")
print("Do you want to install any additional packages at the moment? Y/N")
if input() == "Y":
    print("Enter x at any time to stop")
    Continue = True
    packages = "pacman -S "
    while Continue:
        packages += input()
    os.system(packages)
print("What do you want your hostname to be?")
hostname = input()
hostGen = "echo " + hostname + " >> /etc/hostname"
os.system(hostGen)
print("If you are going to modify locale.gen, do it now.")
os.system("vim /etc/locale.gen")
os.system("locale-gen")
print("If you are going to modify mkinitcpio.conf, do it now.")
os.system("vim /etc/mkinitcpio.conf")
os.system("mkinitcpio -P")
print("Running passwd")
os.system("passwd")
print("Do you want to install GRUB at the moment? Please note this will install GRUB for UEFI, with the efi directory set to /boot/efi, and the removable option set Y/N")
if input() == "Y":
    os.system("mkdir /boot/grub")
    os.system("grub-mkconfig -o /boot/grub/grub.cfg")
    os.system("grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable")
print("Exitting the chroot")
os.system("exit")
print("At this time, the script has done as much as it can to aid installation of archlinux.")
print("All that is left to do on your end is to configure the timezone, and boot into the new system.")