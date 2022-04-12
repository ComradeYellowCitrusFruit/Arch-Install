#!/bin/bash
help() 
{
    echo This is a simple Arch installation aid I made.
    echo Options:
    echo R: Tells the installer to run pacstrap, as well as the mountpoint
    echo p: Tells the installer some additional packages to install
    echo "g: Tells the installer to run 'grub-mkconfig -o %arg'"
    echo "G: Tells the installer to run 'grub-install --target=x86_64-efi --efi-directory=%arg --bootloader-id=GRUB'"
    echo r: Tells the installer the timezone region
    echo c: Tells the installer the timezone city
    exit
}

while getopts ":p:g:G:r:c:h:R:n" installFlag
do
    case "${flag}" in
        R) mountpoint=${OPTARG};;
        p) packages=${OPTARG};;
        g) grubConfDir=${OPTARG};;
        G) grubEfiDir=${OPTARG};;
        r) region=${OPTARG};;
        c) city=${OPTARG};;
        h) help;;
        \j) help;;
    esac
done
if [ -n ${mountpoint} ]; then
    echo "Running pacstrap on $mountpoint"
    pacstrap $mountpoint base linux linux-firmware
    echo Generating fstab on $mountpoint
    genfstab -U ${mountpoint} >> ${mountpoint}/etc/fstab
    echo Changing root to ${mountpoint}
fi
if [ -n ${region} ]; then
    if [ -z ${city} ]; then
        ls /usr/share/zoneinfo/${region}
        read -rep "From the preceding list, which city/region do you belong too?    " city
    fi
else
    ls /usr/share/zoneinfo
    read -rep "From the preceding list, which country/region do you belong too?     " region
    if [ -z ${city} ]; then
        ls /usr/share/zoneinfo/${region}
        read -rep "From the preceding list, which city/region do you belong too?    " city
    fi
fi
echo Setting timezone
ln -sf /usr/share/zoneinfo/${region}/${city} /etc/localtime
hwclock --systohc
read -rep "What would you like to make your hostname?   " hostname
echo $hostname > /etc/hostname
echo Installing constant and very important packages
pacman -S pacman efibootmgr grub make git sudo
read -rep "Vim (default), Vi, Emacs, or Nano? (enter anwser in lower case)    " -i "vim" textEditor
echo Installing $textEditor
pacman -S $textEditor
if [ -n ${packages} ]; then
echo Installing user requested packages
pacman -S $packages
fi
if [ -z ${grubConfDir} && -z ${grubEfiDir} ]; then
    read -rep "Would you like to install grub?  " -i "NO" grubcheck
fi