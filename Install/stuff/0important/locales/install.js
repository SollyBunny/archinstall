
import * as install from "../../../install.js"

await install.run("echo en_GB.UTF-8 UTF-8 > /etc/locale.gen && echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen");
await install.run("echo LANG=en_GB.UTF-8 > /etc/locale.conf");
