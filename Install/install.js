#!/bin/env node

// Config

export const user = "solly"
export const users = [user];
export const host = "arch"

// Main

if (process.getuid() !== 0) {
	console.error("This script must be run as root");
	process.exit(1);
}

import fs from "fs";
global.fs = fs;
import path from "path";
import { execSync } from "child_process";

export function home(u) {
	if (u === undefined) u = user;
	const passwd = fs.readFileSync("/etc/passwd").toString().split("\n");
	for (const line of passwd) {
		if (line.startsWith(u))
			return line.split(":")[5] || undefined;
	}
	return false;
}

export function which(cmd) {
	const paths = process.env.PATH.split(path.delimiter);
	for (const dir of paths) {
		const fullPath = path.join(dir, cmd);
		let stat;
		try {
			stat = fs.statSync(fullPath);
		} catch (e) {
			continue;
		}
		if (stat.isFile() && stat.mode & 0o111)
			return fullPath;
	}
	return undefined;
}

export async function run(cmd, as) {
	if (as === undefined) {
		console.log(`Running: ${cmd}`);
	} else {
		console.log(`Running: ${cmd} (as ${as})`);
		cmd = `sudo -u ${as} sh -c '${cmd.replaceAll("'", "'\\''")}'`;
	}
	execSync(cmd, { stdio: "inherit", shell: true });
}

export async function installPkg(pkgs, asdeps) {
	let cmd = ["pacman -S --needed"];
	if (typeof(pkgs) === "string")
		pkgs = [pkgs];
	if (asdeps)
		cmd.push("--asdep");
	let flag = false;
	for (const pkg of pkgs) {
		const i = pkg.indexOf(":")
		if (!i) {
			cmd.push(pkg);
			flag = true;
		} else if (!which(pkg.substring(0, i))) {
			cmd.push(pkg.substring(i + 1));
			flag = true;
		}
	}
	if (!flag) return;
	await run(cmd.join(" "));
}

export async function installYay(pkgs, asdeps) {
	let cmd = ["yay -S --needed"];
	if (asdeps)
		cmd.push("--asdep");
	if (typeof(pkgs) === "string")
		pkgs = [pkgs];
	let flag = false;
	for (const pkg of pkgs) {
		const i = pkg.indexOf(":")
		if (!i) {
			cmd.push(pkg);
			flag = true;
		} else if (!which(pkg.substring(0, i))) {
			cmd.push(pkg.substring(i + 1));
			flag = true;
		}
	}
	if (!flag) return;
	await run(cmd.join(" "), user);
}

export async function installFile(inp, out, as) {
	await run(`rsync --progress --mkpath --delete -I -r -h ${inp} ${out}`, as);
}

export async function installLink(inp, out, as) {
	await run(`ln -sf ${inp} ${out}`, as);
}

export async function installGit2Code(path, repo) {
	run(`[ ! -d ~/Code/${path} ] && git clone --depth 1 ${repo} ~/Code/${path}; true`, user);
	run(`cd ~/Code/${path}; git pull; make`, user);
	run(`cd ${home()}/Code/${path}; make install`);
}

async function main() {
	async function runFile(path) {
		const cwd = process.cwd();
		process.chdir(path.substring(0, path.lastIndexOf("/")));
		console.log(`Running: ${path}`);
		await import(path);
		process.chdir(cwd);
	}
	async function recurse(folder, depth) {
		const files = fs.readdirSync(folder);
		for (const file of files) {
			const path = `${folder}/${file}`;
			const stats = fs.statSync(path);
			if (stats.isDirectory()) {
				await recurse(path, depth + 1);
			} else if (file === "install.js" && depth > 0) {
				await runFile(path);
			}
		}
	}
	await recurse(".", 0);
}

if (import.meta.url === `file://${process.argv[1]}`) {
	main();
}
