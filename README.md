# Introduction

`mydebian` is simple `bash` script allowing to quickly install
a set of useful packages after a fresh installation.

# Dependencies

```
bash
debian
```

# Installation

A makefile is provided for installing the script and its man page.

```
make 
make install
```

The script is installed `$DESTDIR/$PREFIX/bin/` and the man page is 
installed in `$DESTDIR/$PREFIX/share/man/man1/`.
By default:
* `DESTDIR=`
* `PREFIX=$(HOME)/.local`

You can the installation path by settings `PREFIX` as shown in the example
below where the installation will be system-wide.

```
make
PREFIX=usr/local make install
```
