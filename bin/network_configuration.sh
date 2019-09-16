

# Network Configuration

touch /etc/hostname
echo $1 > /etc/hostname

touch /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts

echo "Network configuration done - OK"
echo ""
sleep 1
