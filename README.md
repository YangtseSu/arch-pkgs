# arch-pkgs

My personal Arch Linux PKGBUILDs. These packages are not in the AUR, except where a row says otherwise.

## Packages

| Package | Upstream | Description |
| --- | --- | --- |
| [cirrocast-git](cirrocast-git/) | <https://github.com/YangtseSu/cirrocast> | Terminal weather client with pluggable backends |
| [monitor-control-git](monitor-control-git/) | <https://github.com/lilydjwg/monitor-control> | Fast get/set of one DDC/CI monitor value, plus `monitor-input` to switch the input source (VCP 0x60) with one key; ships the udev `uaccess` rule that replaces ddcutil's, so `/dev/i2c-*` is reachable without the `i2c` group |
| [atrust](atrust/) | <https://www.sangfor.com/> | Sangfor aTrust SDP client (repack of the vendor deb; bundled Electron kept, root daemon started and stopped by the tray launcher, bundled-curl/SQLCipher preloads and the libmmkv exec-stack patch applied) |
| [zlib-git](zlib-git/) | <https://github.com/heartleo/zlib> | Command-line tool for Z-Library |
| [zju-connect-git](zju-connect-git/) | <https://github.com/YangtseSu/zju-connect> | Go client for ZJU RVPN and Sangfor aTrust gateways, built from the fork that integrates every change of ours on its `dev` branch |
| [ez4connect-git](ez4connect-git/) | <https://github.com/YangtseSu/EZ4Connect> | Qt GUI for that core, built from the matching fork (branch `dev`, which already carries the fixes upstream has not merged, including the one needed to log in where the gateway asks for a TOTP token or a click captcha); `check()` runs the project's ctest suite |

`zju-connect-git` and `ez4connect-git` are the local test builds of the two forks. They are drop-in
replacements for archlinuxcn's `zju-connect-bin` and `ez4connect`: they conflict with those names,
and the core package also provides `zju-connect-bin` so the GUI keeps a satisfied dependency while
both come from the forks. Install both, or neither.

## Use

Each package has its own directory with a `PKGBUILD` file.

```bash
git clone https://github.com/YangtseSu/arch-pkgs.git
cd arch-pkgs/zlib-git
makepkg -sif
```

A `-git` package builds the tip of the branch its `source=()` names: `zju-connect-git` and
`ez4connect-git` follow the `dev` branch of their fork, the others the upstream default branch.
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