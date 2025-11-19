# NAME
**mydebian(1)** - Post install for Debian.

# SYNOPSIS
**mydebian** SUBCOMMAND [SUBCOMMAND_OPTIONS]

# DESCRIPTION
Install a list of predefined packages after a fresh installation.

# OPTIONS
`-v, --version`
: Display version.

`-h, --help`
: Display help.

# SUBCOMMANDS
`debian13|13|trixie[OPTIONS]`
: Post installation for Debian 13 (trixie).

`debian14|14|trixie [OPTIONS]` 
: Post installation for Debian 14 (forky).

`add <gcc|python> <version> <priority>`
: Add alternate for gcc or python.

`dowload_python <version>`        
: Download python from python.org.

# SUBCOMMANDS OPTIONS 
`--list` 
: List packages.

# EXAMPLES
Install package for debian 13.

```
mydebian 13
```

Install and list package for debian 13.

```
mydebian 13 --list
```

Add gcc/python alternative.

```
mydebian add gcc 15 100
mydebian add pytthon 14 100
```
