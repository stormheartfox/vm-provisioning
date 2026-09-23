## The Beautiful Virtual Machine Environment

This is the setup required for a fresh VM with dev tools and quality of life bits and bobs to deliver client work or develop stuff for CRABE etc.

This is a completely automated setup for a dev environment, it can be run on any hypervisor - though it
runs checks for VirtualBox QoL stuff. There are no external dependencies beyond dnf and systemd so it should run perfectly fine.

## Before the before - Notes
This documentation assumes you are provisioning your VM adequately, any issues with crashing etc is outside of the remit of this set of scripts. I have made the assumption you know how to set up a virtal machine with enough cores and RAM etc. You will not see any set up instructions for that here. So make sure you do your due diligence.
Now witout further ado, here's what you need to do to get it in a ready to work state.

## Before you start: Rocky Linux installation (Minimal ISO) - recommended so you only get exactly what you need!

These steps happen in the Rocky installer itself (Anaconda), before first boot:

1. Boot the Rocky Linux Minimal ISO in your hypervisor of choice (VirtualBox, etc.).
2. On the installation summary screen, go into **User Creation** and tick
   **"Make this user administrator"**. This adds the user to the `wheel` group
   and enables passwordless-capable sudo, without this, none of the scripts will be able to run.
3. Go into **Network & Host Name** and toggle the network adapter ON, and set a
   hostname if you want one. Minimal ISO installs usually leaves the NIC disabled by default.
4. Complete the install and reboot into the new system.

## First boot: manual pre-steps (cannot be scripted, no git/network yet)

1. Log in to the machine, then run: 
`sudo dnf update -y`

2. If a kernel update was applied, reboot before continuing: 
`sudo reboot`

3. Install git, since it doesn't exist by default: 
`sudo dnf install -y git`


## Clone and run the provisioning scripts

Now that your VM is ready to begin installing, you just need to pull the repo and let 'er rip!

1. `git clone my-repo-name`

2. cd into the repo - `cd vm-provisioning`

3. Run the installs - `sudo ./install.sh`


This runs, in order:

1. **Desktop environment** — installs the Workstation group if this is a
   minimal install, and sets the boot target giving you a GNOME GUI.
2. **Repositories** — registers all the repos we might need - EPEL, Docker, Microsoft etc. - importing their GPG keys.
3. **Packages** — installs the dev toolchain, container runtime, languages (Python, Go etc), and application/CLI tools.
4. **Desktop config** — disables Wayland in GDM for display support(sometimes you can't resize your window - this fixes that problem).
5. **VirtualBox detection** — if running under VirtualBox, enables Guest
   Additions services if present, and warns if they're missing.
6. **Docker and Neo4j** — enables Docker, and starts Neo4j as a container - you can turn this off if you're not pulling down cloud infra stuff - but it's a nice to have as a local DB for things if you need it.

## Manual step required for VirtualBox only

Guest Additions cannot be installed via dnf, they're delivered as an ISO
attached by the hypervisor. After `install.sh` completes:

1. In the VirtualBox menu: **Devices > Insert Guest Additions CD Image**.
2. Mount and run it inside the VM:

   ```
   sudo mkdir -p /mnt/cdrom
   sudo mount /dev/cdrom /mnt/cdrom
   sudo /mnt/cdrom/VBoxLinuxAdditions.run
   sudo umount /mnt/cdrom
   ```

3. Reboot.

## Reboot and verify

`install.sh` will prompt to reboot automatically if the graphical target or
Wayland setting changed. Once back up, confirm the environment:

```
docker ps
docker compose -f /opt/neo4j/docker-compose.yml ps
code --version
pwsh --version
az --version
go version
```

This list isn't exhaustive - if you have added anything to the programming languages list in config then you should test those.

## Please note

- Golang is installed from the default AppStream repo. Check `dnf info golang`
  if you need a specific version, the distro package may lag behind upstream. This is just how Rocky Linux rolls.
- Re-running `sudo ./install.sh` on an already-provisioned machine is safe there are checkers to make sure you're not re-running stuff and dnf gracefully exits so it won't break anything.
- VirtualBox-specific steps are automatically skipped on other hypervisors, the script checks for VB via `systemd-detect-virt`.