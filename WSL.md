# WSL (Windows Subsystem for Linux)

WSL is a relatively new project from Microsoft that allows you to operate a
fully-functioning Linux environment within your Windows session. The main
advantage for us is that Linux is a much better environment for running Python
than Windows is. WSL is tightly integrated with VSCode with no configuration
needed to connect the two. You get an easy-to-use Python environment out of the
box with a few simple steps.

# Setup

WSL is still a relatively new project and Microsoft's documentation is a bit
scattershot. WSL is supposed to be installable through the MS App Store. If you
can't find it there, it can also be installed by opening Powershell and using
the commmand `wsl --install`. See
[here](https://docs.microsoft.com/en-us/windows/wsl/install) for more details.

# Github SSH

Setting your WSL up to work with Github through SSH is easy and only has to be
done once. Follow the instructions
[here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
(be sure to follow the Linux instructions).

# Known Network Issue

We have come across a network issue in WSL that appears to relate to our VPN.
The problem is basically that trying to do something over the network (e.g. SSH
or copy data to a GIS server) results in the process getting stuck and hanging
indefinitely. We suspect this will be fixed in the next release of WSL. In the
meantime, if you need to do something over the network with WSL you can fix the
problem by running this command within WSL: 
`sudo ip link set dev eth0 mtu 1392`. 
This will prompt you for your password, which is set up at the time you install
WSL. Unfortunately we can't force this setting to persist across reboots so it
has to be done anytime you restart your computer and open WSL. (But only if
you're needing to do something over the network.)

# Developing in WSL with VSCode

WSL and VSCode are tightly integrated. To open your code, simply navigate in WSL
to your project directory and issue the command `code .` (the `.` refers to the
current directory in Linux). This will bring up VSCode in Windows with the
built-in terminal environment already connected to your WSL instance.

# Mapping network drives in WSL

You can ensure command line access to everything on the K, I, etc. drives by mounting them. Ensure you have WSL2 (latest version) installed, and do the following:
1. Make the drive mountpoint, e.g. run `sudo mkdir /mnt/z`
2. Add the drive to your fstab for persistent mounting
    * Open your fstab file, `sudo nano /etc/fstab`
    * Add `Z: /mnt/z drvfs defaults 0 0` at end of file and save it.
3. Reload fstab file `sudo mount -a`
