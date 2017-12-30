# foo_nohide - foobar2000 plugin

This plugin was made because foobar2000 starts minimized if it was minimized while closing it. This happens for example on a reboot or on shutdown. That behaviour annoys me so i wrote this plugin which brings the foobar mainwindow to front on every launch.


## C++?
The official foobar2000 plugin SDK makes heavy use of C++ classes, because of that it is not soo easy to write plugins in other languages. For a plugin like this, based on a couple of Winapi calls this is much overhead so i decided to write it in assembler.

This code can be a good base for other plugins with small footprint or can be a reference on how to implement the SDK in other languages like Delphi.


## Stability
Uhm... yeah maybe. Since not everything of the original SDK is implemented this code can crash now or in future versions of foobar2000. But right now everything seems fine. If you encounter crashes or bugs please write an [issue](https://github.com/LFriede/foo_nohide/issues) and i'll take care about it.  
I'm running this since foobar version: **1.3.16**


## Installation
Just copy `foo_nohide.dll` to `%AppData%\foobar2000\user-components\foo_nohide\`.


## Build
You can build this plugin with [flat assembler](https://flatassembler.net/download.php):
```
fasm foo_nohide.asm
```
Make sure that your INCLUDE environment variable is set. You can use `build.bat` for that.
