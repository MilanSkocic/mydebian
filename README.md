# Debian Pinning
Pinning allows you to control with precision the version of a package 
(unstable, testing and stable) as it is more extensively explained here. 
Pinning unstable and experimental versions is not really an issue for 
desktop use at home but I wouldn't recommend it for workstations or servers.

Usually, it works fine but it happens that dependencies are broken when you 
use Gnome or KDE as desktop environments. 
I have encountered less problems when I use LXDE which is much more modular 
and do not rely on a bunch of common libraries.

Here are examples of **sources.list** and preferences files. Both files are 
located in **/etc/apt/** and the **preference** file is not created by default.

# Debian sudo users
In order to add john as sudo user enter the following command after logging 
as root in the terminal. 

 
``$su - root``

``# adduser john sudo``

Edit the **/etc/sudoers.d/** with the ``visudo`` command othervise it will 
not work because **/etc/sudoers** is read-only even for root. 

``#visudo``

Change %sudo with john and save.

# Debian mini.iso

Daily build for mini.iso available here https://d-i.debian.org/daily-images/amd64/daily/netboot/mini.iso

# Debian upgrade
Apply updates to the current version.

``sudo apt update ``

``sudo apt upgrade``

``sudo apt full-upgrade``

``sudo apt --purge autoremove``

Modify /etc/apt/sources.list with the adequate version.

``sudo apt update ``

``sudo apt upgrade``

``sudo apt full-upgrade``

``sudo apt --purge autoremove``

