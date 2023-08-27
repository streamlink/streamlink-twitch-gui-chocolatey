import path from "path";
import fs from "fs";
import { XMLParser } from "fast-xml-parser";
import { Octokit } from "@octokit/rest";
import { assert } from "ts-essentials";
import crypto from "crypto";
import fetch from "node-fetch";
import _ from "lodash";
import { program } from "commander";
import { execSync } from "child_process";

const owner = "streamlink";
const repo = "streamlink-twitch-gui";
const packageFolder = path.join(__dirname, "..", "Streamlink Twitch GUI");
const nuspecPath = path.join(packageFolder, "streamlink-twitch-gui.nuspec");
const installPwshPath = path.join(
  packageFolder,
  "tools",
  "chocolateyinstall.ps1"
);

async function main(): Promise<void> {
  program.option("--upload", "Upload the new chocolatey package");
  program.option("--force", "Force update the package");
  program.parse(process.argv);
  const options = program.opts();

  const current = getCurrentVersion();
  const latest = await getLatestVersion();
  if (current !== latest.version || options.force) {
    if (current !== latest.version) {
      console.log(`New version available!`);
    } else {
      console.log(`Forcing update!`);
    }

    const win32Hash = await getSha256(
      latest.win32Installer.browser_download_url
    );
    console.log(`win32Hash: ${win32Hash}`);
    const win64Hash = await getSha256(
      latest.win64Installer.browser_download_url
    );
    console.log(`win64Hash: ${win64Hash}`);

    await updateStreamlinkPackage({
      version: latest.version,
      hash32: win32Hash,
      hash64: win64Hash,
      win32DownloadUrl: latest.win32Installer.browser_download_url,
      win64DownloadUrl: latest.win64Installer.browser_download_url,
    });

    await createNupkgAndUpload(options.upload);
  } else {
    console.log(`No new version available`);
  }
}

async function createNupkgAndUpload(shouldUpload: boolean) {
  console.log("Creating nupkg...");
  try {
    execSync("choco pack", {
      cwd: packageFolder,
      stdio: "inherit",
    });
  } catch (error: unknown) {
    console.error("Error while creating nupkg:", (error as Error).message);
  }

  if (shouldUpload) {
    console.log("Uploading nupkg...");
    assert(process.env.CHOCOLATEY_API_KEY, "Need an API key to upload");

    try {
      execSync(
        `choco push  --source=https://push.chocolatey.org/ --api-key ${process.env.CHOCOLATEY_API_KEY}`,
        {
          cwd: packageFolder,
          stdio: "inherit",
        }
      );
    } catch (error: unknown) {
      console.error("Error while uploading nupkg:", (error as Error).message);
    }
  }
}

async function updateStreamlinkPackage({
  version,
  hash32,
  hash64,
  win32DownloadUrl,
  win64DownloadUrl,
}: {
  version: string;
  hash32: string;
  hash64: string;
  win32DownloadUrl: string;
  win64DownloadUrl: string;
}) {
  const nuspec = fs.readFileSync(nuspecPath, "utf8");
  const newNuspec = _.replace(
    nuspec,
    /<version>(.*)<\/version>/,
    `<version>${version}</version>`
  );
  fs.writeFileSync(nuspecPath, newNuspec);

  let installPwsh = fs.readFileSync(installPwshPath, "utf8");
  installPwsh = _.replace(
    installPwsh,
    /\$url \= .*/,
    `$url = "${win32DownloadUrl}"`
  );
  installPwsh = _.replace(installPwsh, /\$hash \= .*/, `$hash = "${hash32}"`);
  installPwsh = _.replace(
    installPwsh,
    /\$url64 \= .*/,
    `$url64 = "${win64DownloadUrl}"`
  );
  installPwsh = _.replace(
    installPwsh,
    /\$hash64 \= .*/,
    `$hash64 = "${hash64}"`
  );
  fs.writeFileSync(installPwshPath, installPwsh);
}

async function getSha256(download_url: string): Promise<string> {
  console.log("Downloading installer...");
  const response = await fetch(download_url, {});
  const buffer = await response.arrayBuffer();
  const input = Buffer.from(buffer);
  return crypto.createHash("sha256").update(input).digest("hex");
}

function getCurrentVersion(): string {
  const parser = new XMLParser();

  // synchronously read the file contents
  const nuspecString = fs.readFileSync(nuspecPath, "utf8");
  const nuspec = parser.parse(nuspecString);
  const currentVersion = nuspec.package.metadata.version;
  console.log(`Current version: ${currentVersion}`);

  return currentVersion;
}

async function getLatestVersion() {
  const octokit = new Octokit({
    // Authenticated requests have a higher rate limit.
    auth: process.env.GITHUB_TOKEN ?? undefined,
  });
  const release = await octokit.repos.getLatestRelease({
    owner,
    repo,
  });

  const latestVersion = release.data.tag_name;
  console.log(`Latest version: ${latestVersion}`);

  const win32Installer = release.data.assets.find((asset) => {
    return asset.name.endsWith("win32-installer.exe");
  });

  const win64Installer = release.data.assets.find((asset) => {
    return asset.name.endsWith("win64-installer.exe");
  });

  assert(win32Installer);
  assert(win64Installer);

  // HACK: This will come as 'v2.1.0', we want '2.1.0'
  return {
    version: _.replace(latestVersion, "v", ""),
    win32Installer,
    win64Installer,
  };
}

main();
