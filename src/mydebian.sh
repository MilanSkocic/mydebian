#!/usr/bin/env bash

# DEFINE
PROGNAME="mydebian"
PROGVERSION="0.1"
SHORTDESCRIPTION="Post install for Debian."
HOMEPAGE=""
LICENSE="MIT"
MANSECTION="1"
RED="\e[31m"
BLACK="\e[0m"
GREEN="\e[32m"

CACHEDIR=$HOME/.cache/$PROGNAME

DEB13="build-essential checkinstall autotools-dev make cmake
       libreadline-dev libncurses-dev libssl-dev libsqlite3-dev tk-dev
       libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev liblzma-dev
       libgdbm-compat-dev libnsl-dev
       git lazygit
       gcc gfortran gcc-12 gfortran-12 gcc-13 gfortran-13 gcc-14 gfortran-14
       npm golang valac
       libopenblas0 libopenblas-dev
       python3-pip python3-setuptools
       neovim neomutt calcurse kitty tmux tree pass doxygen
       stow btop htop fastfetch zoxide fzf tree pass gpg zsh
       fonts-ubuntu fonts-ubuntu-console fonts-ubuntu-title
       yaru-theme-gtk yaru-theme-icon
       graphviz imagemagick inkscape gimp dia geogebra texlive-full"

DEB14="$DEB13 fortran-fpm"
FLAG_LIST=0
FLAG_VERBOSE=0

help () {
    echo "Usage: $PROGNAME COMMAND [SUBCOMMAND_OPTIONS]" 
    echo "\`$PROGNAME\` -- $SHORTDESCRIPTION"
    echo ""

    echo "Options:"
    echo "  -v, --version   Display version."
    echo "  -h, --help      Display help."
    echo ""
    
    echo "*Commands*"
    echo "  debian13|13|trixie [OPTIONS]            Post installation for Debian 13 (trixie)."
    echo "  debian14|14|trixie [OPTIONS]            Post installation for Debian 14 (forky)."
    echo "  add <gcc|python> <version> <priority>   Add alternate for gcc or python."
    echo "  dowload_python <version>                Download python from python.org."
    echo ""
    
    echo "*Subcommand options*"
    echo "  --list                                   List packages."
    echo ""

    echo "Examples:"
    echo "  $PROGNAME 13                        Install package for debian 13." 
    echo "  $PROGNAME 13 --list                 Install and list package for debian 13." 
    echo "  $PROGNAME add gcc 15 100            Add gcc alternative."
    echo "  $PROGNAME.sh add python 14 100      Add Python alternative."

    echo "Report bugs to <http://github.com/MilanSkocic/mydebian>"
}

version () {
    echo "$PROGNAME $PROGVERSION"
    echo ""
    echo "Copyright (c) 2025 Milan Skocic."
    echo "MIT License."
    echo ""
    echo "Written by M. Skocic"
}

debianpackages () {
    # $1: debian version
    # $2: flag list
    # $3: flag verbose
    echo "Post install for debian $1..."
    local pkgs=""
    case $1 in 
        13)
            pkgs=$DEB13
            ;;
        14)
            pkgs=$DEB14
            ;;
        *)
            ;;
    esac
    if [[ $2 == 1 ]]; then
        echo $pkgs
    fi
    if [[ $3 == 1 ]]; then
        sudo apt install -y $pkgs
    else
        sudo apt install -y $pkgs >/dev/null 2>&1
    fi
    if [[ $? != 0 ]]; then
        echo "Error occured. Most likely, you required packages from the wrong Debian version."
        echo "Requested Debian version: $1."
        echo "You Debian version      : $(lsb_release -a | grep 'Release' | cut -d ":" -f 2 | sed -z 's/^[[:space:]]*//')."
    else
        echo "Done."
    fi
    return $?
}

add_gcc () {
    # $1: gcc version
    # $2: priority
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$1 $2 --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-$1 --slave /usr/bin/gcov gcov /usr/bin/gcov-$1
}

add_python () {
    sudo update-alternatives --install /usr/bin/python3 python /usr/local/bin/python$1 $2 --slave /usr/bin/pip3 pip /usr/local/bin/pip$1
}

download_python () {
    mkdir -p $CACHEDIR
    if [[ ! -f $CACHEDIR/Python-$1.tgz ]]; then
        wget -P $CACHEDIR https://www.python.org/ftp/python/$1/Python-$1.tgz
    else
        echo "Python $1 has already been downloaded."
    fi
}

args=$*
for i in $args; do
    case $i in

        "--list")
            FLAG_LIST=1
            ;;
        "-v"|"--verbose")
            FLAG_VERBOSE=1
            ;;
        *)
            ;;
    esac
done

case $1 in
    "--help"|"-h")
        help 
        exit 0
        ;;
    "--version"|"-v")
        version
        exit 0
        ;;
    "debian13"|"13"|"trixie")
        debianpackages 13 $FLAG_LIST $FLAG_VERBOSE
        exit $?
        ;;
    "debian14"|"14"|"forky")
        debianpackages 14 $FLAG_LIST $FLAG_VERBOSE
        exit $?
        ;;
    "add")
        case $2 in
            "gcc")
                add_gcc $3 $4
                exit 0
                ;;
            "python")
                add_python $3 $4
                exit 0
                ;;
            *)  
                echo "Missing gcc or python."
                help
                exit 0
                ;;
        esac
        ;;
    "download_python")
        download_python $2
        exit 0
        ;;
    *)
        echo "Command $1 not recognized."
        help
        exit $?
        ;;
esac
