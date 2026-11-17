# CMS Make

This is CMS Make, a `make` workalike for VM/CMS systems.

This is not the first `make` for VM/CMS. <br/>
It is at least the second by one author, and there are others.

This `make` is intended to support the syntax used by `make` on other
platforms. With care, rules files for CMS Make can be used with any `make`.
A limited number of programs are included which work similarly
to their Unix/Linux counterparts.

## cmsmake

CMS Make provides similar function on CMS systems
as traditional `make` provides on POSIX systems.
Rules files are visually compatible with standard makefiles,
except that the Tab character can be ordinary white space.

This is a really really simple implementation.
The purpose is to allow a subset of `make` functionality
which can be used interchangeably between CMS and Unix/Linux/POSIX.
With care, common rules files can be crafted and. <br/> It works.

Several commands which work like their Unix/Linux/POSIX counterparts
are included in order to facilitate rules files which work the same
between CMS Make and POSIX/Unix `make`. Notable examples are `curl`
and `wget`.

CMS Make, and all utilities included with it, is hungry.
If you find a missing feature, please contribute, either by way of
a Git pull request or by contacting the author.


