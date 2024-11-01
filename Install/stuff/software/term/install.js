
import * as install from "../../../install.js"

install.installPkg("kitty:kitty");
install.installLink("/usr/bin/kitty", "/usr/local/bin/term");
install.installFile("kitty.conf", "/etc/kitty.conf")
