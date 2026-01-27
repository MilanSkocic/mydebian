#!/usr/bin/env bash

# DEFINE
PROGNAME="mydebian"
PROGVERSION="0.1"
SHORTDESCRIPTION="Simple postinstaller for Debian."
HOMEPAGE=""
LICENSE="MIT"
MANSECTION="1"
RED="\e[31m"
BLACK="\e[0m"
GREEN="\e[32m"

CACHEDIR=$HOME/.cache/$PROGNAME

PYDEV="build-essential checkinstall autotools-dev make cmake
       libreadline-dev libncurses-dev libssl-dev libsqlite3-dev tk-dev
       libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev liblzma-dev
       libgdbm-compat-dev libnsl-dev
       python3-pip python3-setuptools"
GIT="git lazygit"
COMPILERS="gcc gfortran gcc-12 gfortran-12 gcc-13 gfortran-13 gcc-14 gfortran-14 
           npm golang valac"
NUMERIC="libopenblas0 libopenblas-dev libgsl-dev gsl-bin"
YARU="yaru-theme-gtk yaru-theme-icon"
UBUNTU="fonts-ubuntu fonts-ubuntu-console fonts-ubuntu-title"
TEX="texlive-full"
TOOLS="neovim neomutt calcurse kitty tmux tree pass doxygen
       stow btop htop fastfetch zoxide fzf tree pass gpg zsh
       graphviz imagemagick inkscape gimp dia geogebra
       help2man man2html txt2man"

DEB13="$PYDEV $GIT $COMPILERS $NUMERIC $YARU $UBUNTU $TOOLS"
DEB14="$DEB13 fortran-fpm"

FLAG_LIST=0
FLAG_VERBOSE=0

help () {
    echo "NAME"
    echo "  $PROGNAME - post installer for Debian."
    echo ""
    echo "SYNOPSIS                                                             "
    echo "  $PROGNAME COMMAND [OPTIONS]" 
    echo ""
    echo "DESCRIPTION"
    echo "  Simple post installer for Debian." 
    echo ""
    echo "OPTIONS"
    echo "  o debian13|13|trixie [OPTIONS]             Post installation for Debian 13 (trixie)."
    echo "  o debian14|14|trixie [OPTIONS]             Post installation for Debian 14 (forky)."
    echo "  o add <gcc|python> <version> <priority>    Add alternate for gcc or python."
    echo "  o dowload_python <version>                 Download python from python.org."
    echo "  o --list          List packages."
    echo "  o --version, -v   Display version."
    echo "  o --help, -h      Display help."
    echo ""
    echo "EXAMPLE"
    echo "  Minimal example"
    echo ""
    echo "     $PROGNAME 13" 
    echo "     $PROGNAME 13 --list" 
    echo "     $PROGNAME add gcc 15 100"
    echo "     $PROGNAME.sh add python 14 100"
    echo ""
    echo "SEE ALSO"
    echo "  apt(8)"
}


version () {
    echo "PROGRAM:      $PROGNAME                          "
    echo "DESCRIPTION:  $SHORTDESCRIPTION                  "
    echo "VERSION:      $PROGVERSION                       "
    echo "AUTHOR:       M. Skocic                          "
    echo "LICENSE:      $LICENSE                           "
}

debianpackages () {
    # $1: debian version
    # $2: flag list
    # $3: flag verbose
    echo "Post install for debian $1..."
    local pkgs=""
    case $1 in 
        13)
            pkgs=$(printf "%s\n" $DEB13 | sort -t " ")
            ;;
        14)
            pkgs=$(printf "%s\n" $DEB14 | sort -t " ")
            ;;
        *)
            ;;
    esac
    if [[ $2 == 1 ]]; then 
        echo $(printf "%s\n" $pkgs | sort -t " "); 
        return 0; 
    fi
    if [[ $3 == 1 ]]; then
        sudo apt install -y $pkgs
    else
        sudo apt install -y $pkgs >/dev/null 2>&1
    fi
    if [[ $? != 0 ]]; then
        echo "Error occurred. Most likely, you required packages from the wrong Debian version."
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
        help
        exit $?
        ;;
esac
