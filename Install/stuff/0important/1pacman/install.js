
import * as install from "../../../install.js"

await install.installFile("pacman.conf", "/etc/pacman.conf");
await install.run("pacman -Fy && pacman -Syu && pacman -Qtdq | pacman -Rsn -");
await install.run("pacman -Syu");
await install.installPkg("rankmirrors:pacman-contrib");

await install.installFile("pacmanmirrorupdate.sh", "/usr/local/bin/pacmanmirrorupdate");
await install.installFile("pacmanmirrorupdate.service", "/etc/systemd/system/pacmanmirrorupdate.service");
await install.installFile("pacmanmirrorupdate.timer", "/etc/systemd/system/pacmanmirrorupdate.timer");
await install.run("systemctl enable pacmanmirrorupdate.timer && systemctl start pacmanmirrorupdate.timer");

