

# Set timezone

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "Timezone set - OK"
echo ""
sleep 1


# Localization - Greetings from Germany

echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE ISO-8859-1" >> /etc/locale.gen
echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen

locale-gen

touch /etc/locale.conf
echo "LANG=de_DE.UTF-8" > /etc/locale.conf

touch /etc/vconsole.conf
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

# this just works after installing a desktop environment (e.g. xorg and xfce4 package)
# localectl --no-convert set-x11-keymap de pc105 nodeadkeys  # desktop keyboard layout

echo "German localization done - OK"
echo ""
sleep 1
