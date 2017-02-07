This is a super-hackish script to setup all the tools necessary to build 
[TWLoader](https://github.com/Robz8/TWLoader) on Windows.

It creates a self-contained installation containing
- MSYS2
- devkitARM r45
- Necessary libraries

The script mounts the output directory to the T: drive, which is a poor-man's 
method of creating a portable app.

Usage:
- **setup.cmd** Script which will download and extract the required tools, and 
  download and build all the required code, as well as TWLoader.
- **msys.cmd** Opens a shell prompt with the appropriate environment variables set 
  so you can re-compile TWLoader.

These commits of the various libraries are known to work.  Unless otherwise 
specified, they are the current versions as of this writing.

| Project                        | Commit                                                                                                                                | Notes                                                           |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| devkitPro/3ds_portlibs         | [`9f06d968b75158f6938cf0d704ef66b0c3e1bad8`](https://github.com/devkitPro/3ds_portlibs/tree/9f06d968b75158f6938cf0d704ef66b0c3e1bad8)   | Last commit which works with devkitARM r45                      |
| smealum/ctrulib                | [`396d341a8f8430c2724c6e9d596488f0160a6062`](https://github.com/smealum/ctrulib/tree/396d341a8f8430c2724c6e9d596488f0160a6062)          | Last commit which works with devkitARM r45                      |
| fincs/citro3d                  | [`a28fff9391ef4ec84a931401fd2d9879d83497af`](https://github.com/fincs/citro3d/tree/a28fff9391ef4ec84a931401fd2d9879d83497af)            |                                                                 |
| ahezard/libnds                 | [`019efcd26af45ddc7ea76b6e7c1cc6d775fb834b`](https://github.com/ahezard/libnds/tree/019efcd26af45ddc7ea76b6e7c1cc6d775fb834b)           |                                                                 |
| xerpi/sf2dlib                  | [`c5aaec5eaf0337c979d5d832fed7f0e4342bae8e`](https://github.com/xerpi/sf2dlib/tree/c5aaec5eaf0337c979d5d832fed7f0e4342bae8e)            |                                                                 |
| xerpi/sfillib                  | [`2ee78c766343aabbc5cf61dee0feb22468e61d4c`](https://github.com/xerpi/sfillib/tree/2ee78c766343aabbc5cf61dee0feb22468e61d4c)            |                                                                 |
| xerpi/sftdlib                  | [`c5aa104bd3e55365d7a55f6daab094dec0aa9f29`](https://github.com/xerpi/sftdlib/tree/c5aa104bd3e55365d7a55f6daab094dec0aa9f29)            |                                                                 |
| profi200/Project_CTR (makerom) | [`70e0d1280ff761c41c4aba41b0bae22bc27603aa`](https://github.com/profi200/Project_CTR/tree/70e0d1280ff761c41c4aba41b0bae22bc27603aa)     |                                                                 |
| noxiousninja/ctr_toolkit       | [`1eae85d904056ea27e9193e0c42322746276e864`](https://github.com/noxiousninja/ctr_toolkit/tree/1eae85d904056ea27e9193e0c42322746276e864) | Fork of ihaveamac/ctr_toolkit with some compile warnings fixed. |
| Steveice10/bannertool          | [`04b124f400e8a8447774b4d573d46a8fd7912909`](https://github.com/Steveice10/bannertool/tree/04b124f400e8a8447774b4d573d46a8fd7912909)    |                                                                 |

This script also uses `libfat-nds` 1.0.14 and `maxmod-nds` 1.0.9.  These 
versions were chosen somewhat arbitrarily as being released before devkitARM 
r46; it's possible newer versions will also work.
