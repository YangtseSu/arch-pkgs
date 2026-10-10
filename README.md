# arch-pkgs

My personal Arch Linux PKGBUILDs. These packages are not in the AUR, except where a row says otherwise.

## Packages

| Package | Upstream | Description |
| --- | --- | --- |
| [cirrocast-git](cirrocast-git/) | <https://github.com/YangtseSu/cirrocast> | Terminal weather client with pluggable backends |
| [sangfor-atrust-bin](sangfor-atrust-bin/) | <https://www.sangfor.com/> | Sangfor aTrust SDP client (fork of the AUR package of the same name, with the Arch fixes: bundled curl/SQLCipher preloads and the libmmkv exec-stack patch) |
| [zlib-git](zlib-git/) | <https://github.com/heartleo/zlib> | Command-line tool for Z-Library |

## Use

Each package has its own directory with a `PKGBUILD` file.

```bash
git clone https://github.com/YangtseSu/arch-pkgs.git
cd arch-pkgs/zlib-git
makepkg -sif
```

A `-git` package tracks the upstream `main` branch. Run this to update it.

```bash
git pull
cd zlib-git
makepkg -u --noextract
makepkg -sif
```

## License

The PKGBUILD files in this repository use the 0BSD license. RFC40 and RFC52 define this rule. See [LICENSES](LICENSES/).

Each packaged program keeps its own license. See `/usr/share/licenses/<pkgname>/` on your system.