
import * as install from "../../../install.js"

await install.installPkg(["tzdata", "jq:jq"]);
await install.run("systemctl enable systemd-timesyncd.service && systemctl start systemd-timesyncd.service");

await install.installFile("tzupdate.sh", "/usr/local/bin/tzupdate");
await install.installFile("tzupdate.service", "/etc/systemd/system/tzupdate.service");
await install.installFile("tzupdate.timer", "/etc/systemd/system/tzupdate.timer");
await install.run("systemctl enable tzupdate.timer && systemctl start tzupdate.timer");
