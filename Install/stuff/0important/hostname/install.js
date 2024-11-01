
import * as install from "../../../install.js"

await install.run(`echo ${install.host} > /etc/hostname`);
