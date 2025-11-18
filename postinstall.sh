#!/usr/bin/env bash

# DEFINE
PROGNAME="postinstall"
PROGVERSION="1.0"
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
       gcc gfortran
       gcc-12 gfortran-12
       gcc-13 gfortran-13
       gcc-14 gfortran-14
       libopenblas0 libopenblas-dev
       python3-pip python3-setuptools
       neovim neomutt calcurse kitty tmux
       stow btop htop fastfetch zoxide fzf
       fonts-ubuntu fonts-ubuntu-console fonts-ubuntu-title
       graphviz imagemagick inkscape gimp dia geogebra texlive-full"

DEB14=$DEB13
FLAG_LIST=0

init () {
    echo -n "Checking wget..."
    if command -v wget >/dev/null 2>&1 ; then echo "done."; else echo "not found."; fi
    return 0
}

help () {
    echo "NAME"
    echo "    $PROGNAME($MANSECTION) - $SHORTDESCRIPTION"
    echo ""

    echo "SYNOPSIS"
    echo "    $PROGNAME SUBCOMMAND [SUBCOMMAND_OPTIONS]" 
    echo ""

    echo "DESCRIPTION"
    echo "   $PROGNAME install a list of predefined packages."
    echo ""

    echo "OPTIONS"
    echo "   -v, --version        Display version."
    echo "   -h, --help           Display help."
    echo ""
    
    echo "SUBCOMMANDS"
    echo "+debian13|13|trixie [OPTIONS]              Post installation for Debian 13 (trixie)."
    echo "+debian14|14|trixie [OPTIONS]              Post installation for Debian 14 (forky)."
    echo "+add <gcc|python> <version> <priority>     Add alternate for gcc or python."
    echo "+dowload_python <version>                  Download python from python.org."
    echo ""
    
    echo "SUBCOMMANDS OPTIONS"
    echo "  --list                                   List packages."
    echo ""

    echo "EXAMPLES"
    echo "Install package for debian 13."
    echo "  > ./$PROGNAME.sh 13" 
    echo ""
    echo "Install and list package for debian 13."
    echo "  > ./$PROGNAME.sh 13 --list" 
    echo ""
    echo "Add gcc/python alternative."
    echo "  > ./$PROGNAME.sh add gcc 15 100"
    echo "  > ./$PROGNAME.sh add pytthon 14 100"
}

help_usage () {
    echo "USAGE: $PROGNAME SUBCOMMAND [SUBCOMMAND_OPTIONS]"
}

version () {
    echo "Version:      $PROGVERSION"
    echo "Program:      $PROGNAME"
    echo "Description:  $SHORTDESCRIPTION"
    echo "Home Page:    $HOMEPAGE"
    echo "License:      $LICENSE"
    echo "OS Type:      $OSTYPE"
}

debian13 () {
    echo "Post install for debian 13 trixie..."
    if [[ $1 == 1 ]]; then
        echo $DEB13
    fi
    sudo apt install -y $DEB13
    echo "Done."
    return 0
}

debian14 () {
    echo "Post install for debian 14 forky..."
    if [[ $1 == 1 ]]; then
        echo $DEB14
    fi
    sudo apt install -y $DEB14
    echo "Done."
    return 0
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
    wget -P $CACHEDIR https://www.python.org/ftp/python/$1/Python-$1.tgz
}

init 

args=$*
for i in $args; do
    if [[ "$i" == "--list" ]]; then
        FLAG_LIST=1
    fi
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
        debian13 $FLAG_LIST
        exit 0
        ;;
    "debian14"|"14"|"forky")
        debian14 $FLAG_LIST
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
                ;;
        esac
        ;;
    "download_python")
        download_python $2
        exit 0
        ;;
    *)
        echo "Command $1 not recognized."
        help_usage
        exit $?
        ;;
esac
