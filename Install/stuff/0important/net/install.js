
import * as install from "../../../install.js"

await install.installPkg(["iw", "iwd", "dhcpcd", "polkit"]);
await install.run("systemctl enable dhcpcd && systemctl start dhcpcd");

await install.installFile("resolved.conf", "/etc/resolved.conf");
await install.run("systemctl enable systemd-resolved && systemctl restart systemd-resolved");
