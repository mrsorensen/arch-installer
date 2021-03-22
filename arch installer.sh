loadkeys no
ls /sys/firmware/efi/efivars
wifi-menu
timedatectl set-ntp true
timedatectl set-timezone Europe/Oslo
echo "Make /dev/sda1 - 512M EFI System"
echo "Make /dev/sda2 - xG Linux swap"
echo "Make /dev/sda3 - xG Linux Filesystem"
cfdisk /dev/sda

mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt
mkfs.fat -F32 /dev/sda1
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mkswap /dev/sda2
swapon /dev/sda2

pacstrap /mnt base base-devel linux linux-lts linux-firmware vim ranger netctl
genfstab -U /mnt > /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc
echo "Uncomment en_US.UTF-8 UTF-8"
vim /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8
LC_COLLATE=C" > /etc/locale.conf
echo "KEYMAP=no" > /etc/vconsole.conf
echo "arch" > /etc/hostname
echo "127.0.0.1 localhost
::1 localhost
127.0.1.1 arch.localdomain arch" >> /etc/hosts
passwd

mkinitcpio -P
bootctl install
vim /boot/loader/entries/arch.conf
pacman -S amd-ucode

pacman -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

exit
umount -R /mnt
reboot

