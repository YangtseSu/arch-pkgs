# arch-pkgs

My personal Arch Linux PKGBUILDs. These packages are not in the AUR, except where a row says otherwise.

## Packages

| Package | Upstream | Description |
| --- | --- | --- |
| [atvv-git](atvv-git/) | <https://github.com/YangtseSu/atvv-linux> | ATVV v1.0 userspace stack for Bluetooth voice remotes; split packages `atvv-git` (daemon, CLI, MCP) and `atvv-gui-git` (GTK configuration app) |
| [cirrocast-git](cirrocast-git/) | <https://github.com/YangtseSu/cirrocast> | Terminal weather client with pluggable backends |
| [monitor-control-git](monitor-control-git/) | <https://github.com/lilydjwg/monitor-control> | Fast get/set of one DDC/CI monitor value, plus `monitor-input` to switch the input source (VCP 0x60) with one key; ships the udev `uaccess` rule that replaces ddcutil's, so `/dev/i2c-*` is reachable without the `i2c` group |
| [atrust](atrust/) | <https://www.sangfor.com/> | Sangfor aTrust SDP client (repack of the vendor deb; bundled Electron kept, root daemon started and stopped by the tray launcher, bundled-curl/SQLCipher preloads and the libmmkv exec-stack patch applied) |
| [zlib-git](zlib-git/) | <https://github.com/heartleo/zlib> | Command-line tool for Z-Library |

## Use

Each package has its own directory with a `PKGBUILD` file.

```bash
git clone https://github.com/YangtseSu/arch-pkgs.git
cd arch-pkgs/zlib-git
makepkg -sif
```

A `-git` package builds the tip of the branch its `source=()` names, which is the upstream default
branch unless the PKGBUILD pins one.
Update one like this — `-C` deletes `$srcdir/`, which is what re-clones the new commits (`-e` would
reuse the old checkout and silently keep the previous commit):

```bash
git pull
cd zlib-git
makepkg -C --noconfirm
makepkg -i --noconfirm
```

## License

The PKGBUILD files in this repository use the 0BSD license. RFC40 and RFC52 define this rule. See [LICENSES](LICENSES/).

Each packaged program keeps its own license. See `/usr/share/licenses/<pkgname>/` on your system.