
import * as install from "../../../install.js"

await install.installPkg("grub-install:grub");
await install.run("mkdir -p /boot/efi; mount -a");
await install.run("grub-install --boot-directory=/boot --efi-directory=/boot/efi --removable");
await install.run("grub-mkconfig -o /boot/grub/grub.cfg")
