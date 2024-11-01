
import * as install from "../../../install.js"

install.installPkg("ssh:openssh");
install.installFile("srvssh", "/etc/srvssh");
install.installFile("srvssh.sh", "/usr/local/bin/srvssh");
for (const user of install.users) {
	install.run("ssh-keygen -t ed25519; true", user);
	install.run(`git config --global url."git@github.com:".insteadOf "https://github.com/"`, user)
}
