# foo_nohide - foobar2000 plugin

This plugin was made because foobar2000 starts minimized if it was minimized while closing it. This happens for example on a reboot or on shutdown. That behaviour annoys me so I wrote this plugin which brings the foobar mainwindow to front on every launch.

The plugin works with foobar2000 version **1.3.16** till **2.x** (32 and 64 bit). It should also work with older versions than **1.3.16**, but that's the lowest I tested.

## C++?
The official foobar2000 plugin SDK makes heavy use of C++ classes, because of that it's not so easy to write plugins in other languages. For a plugin like this, based on a couple of Winapi calls this is much overhead so I decided to write it in assembler.

This code can be a good base for other plugins with small footprint or can be a reference on how to implement the SDK in other languages like Delphi.

This code only implements minimal portions of the plugin SDK, just to get it loaded and show up in settings -> components. That's of course a litte bit hacky, but everything seems to be stable, I encountered no crashes since I wrote the plugin in 2017.


## Installation

Version 0.2 of this plugin is 64 bit only, please use version 0.1 for 32 bit versions of foobar2000. There are no new features in 0.2, it's just the x64 port. To install the plugin you need to copy the dll file to a specific location, depending on the foobar2000 version you are using:

### foobar version 2.x 64 bit
Copy `foo_nohide64.dll` to `%AppData%\foobar2000-v2\user-components-x64\foo_nohide64\`.

### foobar version 2.x 32 bit
Copy `foo_nohide.dll` to `%AppData%\foobar2000-v2\user-components\foo_nohide\`.

### foobar version 1.x 32 bit
Copy `foo_nohide.dll` to `%AppData%\foobar2000\user-components\foo_nohide\`.

## Build
You can build this plugin with [flat assembler](https://flatassembler.net/download.php):
```console
fasm foo_nohide64.asm
```
Make sure that your INCLUDE environment variable is set. You can use `build.bat` for that.
