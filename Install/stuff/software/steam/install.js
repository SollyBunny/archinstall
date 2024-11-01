
import * as install from "../../../install.js"

install.installPkg("steam:steam", "gnutls", "lib32-gnutls");
install.installLink("/run/systemd/resolve/stub-resolv.conf", "/etc/resolv.conf");
