
import * as install from "../../../install.js"

await install.installPkg("doas:doas");
await install.installLink("/usr/bin/doas", "/usr/bin/sudo");
await install.installFile("doas.conf", "/etc/doas.conf");
await install.installYay("sudo:doas-sudo-shim");
