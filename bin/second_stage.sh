

# Second Stage of archinstall


hostname=$1
boot_partition_path=$2


# Localization

bash /opt/archinstall.git/bin/localization.sh


# Network Configuration
bash /opt/archinstall.git/bin/network_configuration.sh $hostname


# Initramfs

# implement if needed ...


# Set default Password

echo "root:root" | chpasswd
echo "Default password for user root set - OK"
echo ""
sleep 1


# Bootloader Installation

bash /opt/archinstall.git/bin/install_bootloader.sh $boot_partition_path
