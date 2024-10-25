
if pgrep -x "openvpn" > /dev/null; then
	exit 0
fi

country=$(curl -s http://ipinfo.io/country)

mirrors=$(curl -s "https://archlinux.org/mirrorlist/?country=$country&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -p -)

echo "${mirrors}" | head -n 5 > /etc/pacman.d/mirrorlist
echo "${mirrors}" | tail -n +6 | sed 's/^/# /' >> /etc/pacman.d/mirrorlist