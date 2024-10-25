
import * as install from "../../../install.js"

install.installPkg("ssh:openssh");
install.installFile("srvssh", "/etc/srvssh");
install.installFile("srvssh.sh", "/usr/local/bin/srvssh");

