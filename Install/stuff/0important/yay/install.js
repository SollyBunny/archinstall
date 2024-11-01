
import * as install from "../../../install.js"

if (!install.which("yay")) {
	await install.installPkg("git:git");
	await install.run("[ ! -d ~/.cache/yay/yay-bin/ ] && git clone --depth 1 https://aur.archlinux.org/yay-bin.git ~/.cache/yay/yay-bin; true", install.user);
	await install.run("cd ~/.cache/yay/yay-bin && makepkg -f", install.user);
	await install.run(`pacman -U $(find ${install.home()}/.cache/yay/yay-bin -maxdepth 1 -type f -name *pkg* ! -name *debug* -print -quit)`);
}
