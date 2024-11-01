
import * as install from "../../../install.js"

install.installPkg(["cpupower:cpupower", "bc:bc"]);
install.installFile("cpufreq.sh", "/usr/local/bin/cpufreq");
