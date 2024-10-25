
import * as install from "../../../install.js"

if (!install.which("yay")) {
	await install.installPkg("git:git")
	await install.run("git clone --depth 1 https://aur.archlinux.org/yay-bin.git ~/.cache/yay/yay-bin", install.user);
	await install.run("cd ~/.cache/yay/yay-bin && makepkg -si");
}