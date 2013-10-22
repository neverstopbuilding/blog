---
layout: post
title: "How to Mount a Filesystem via SSH on OSX Mountain Lion"
date: 2013-01-04 14:13
comments: true
categories: [quick tips, devops]
---

If you find yourself with remote development environments, but prefer working on your local mac, you may find some joy with mounting the remote filesystem over ssh. This way you can access it as if it were a native set of files.

##Install OSXFUSE
This is the successor to the MacFuse software that allowed this in the past. The steps I followed are:

1. Download the package: [https://github.com/osxfuse/osxfuse/downloads](https://github.com/osxfuse/osxfuse/downloads)
2. Install the package.
3. Restart your computer as recommended.

##Install SSHFS
To take care of mounting the file system you will need [sshfs](http://fuse.sourceforge.net/sshfs.html), which can be installed effortlessly with [homebrew](http://mxcl.github.com/homebrew/), which you certainly should be using.

    brew install sshfs

##Mounting a Remote System

First create a location for your mount, I placed mine in my default development directory:

    mkdir -pv ~/development/sshfs-mount

Assuming you have your ssh keys set up already it will be a simple matter of running:

    sshfs your.remote.system.com:/ ~/development/sshfs-mount

Of course replacing `your.remote.system.com` with, well, your remote system. You can mount a specific folder after the `:`. The above mounts the root directory, while leaving it off mounts the home directory.


