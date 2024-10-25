
import * as install from "../../../install.js"

install.installPkg("steam:steam");
install.installLink("/run/systemd/resolve/stub-resolv.conf", "/etc/resolv.conf");
