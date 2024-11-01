
import * as install from "../../../install.js"



let id = 1000;
for (const user of install.users) {
	if (install.home(user)) continue;
	install.run(`useradd -m -u ${id++} ${user}`);
	install.run(`usermod -aG wheel ${user}`);
	install.run(`chown ${user}:${user} $(getent passwd ${user} | cut -d ":" -f 6)`);
	console.log(`Password for ${user}`);
	install.run(`passwd ${user}`);
}

install.run("usermod -aG wheel root");
install.run("passwd");


