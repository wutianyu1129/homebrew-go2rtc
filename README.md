# homebrew-go2rtc

非官方 Homebrew tap，用于在 macOS 上安装并管理 [go2rtc](https://github.com/AlexxIT/go2rtc)：

- 使用官方发布的 macOS 二进制（arm64 / amd64）
- 通过 `brew services` 以守护进程方式运行
- 支持开机自启、崩溃自动重启
- 自动跟随上游 release 更新（GitHub Actions 每日检查）

## 安装

```bash
# 添加 tap
brew tap wutianyu1129/go2rtc

# 安装 go2rtc
brew install go2rtc
