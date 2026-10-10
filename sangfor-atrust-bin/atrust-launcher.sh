#!/bin/bash
# aTrust 托盘启动器: 确保核心服务运行后启动托盘
SVC=aTrustDaemon.service
if ! systemctl is-active --quiet "$SVC"; then
    pkexec systemctl start "$SVC" || true
    sleep 2
fi
APP=/usr/share/sangfor/aTrust
export LD_LIBRARY_PATH="$APP/uem/bin:$APP/uem/lib:$APP/resources/bin:$APP/resources/lib:$APP${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
# 托盘进程里 Electron(Chromium) 会带进系统 libsqlite3.so.0, 与客户端自带的
# resources/bin/libsqlite3.so (=SQLCipher) 互插符号, 把它自己的 provider 初始化搅坏
# -> 提交网址那一下 SIGSEGV。预加载自带这份, 让客户端内部的 sqlite3_* 调用闭回自己
# (3.31.0, 对 Electron 9 的用量足够); 只影响由本启动器拉起的托盘及其子进程。
export LD_PRELOAD="$APP/resources/bin/libsqlite3.so${LD_PRELOAD:+ $LD_PRELOAD}"
export ELECTRON_IS_DEV=0
export ELECTRON_FORCE_IS_PACKAGED=true
export NODE_ENV=production
cd "$APP"
exec "$APP/aTrustTray" --no-sandbox --disable-gpu "$@"
