class Go2rtc < Formula
  desc "Ultimate camera streaming application with RTSP, WebRTC, RTMP, etc."
  homepage "https://github.com/AlexxIT/go2rtc"
  version "1.9.12"

  # 只处理 macOS（arm64 / amd64），URL 和 SHA 由 workflow 自动填入
  if Hardware::CPU.arm?
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.12/go2rtc_mac_arm64.zip"
    sha256 "63d3e986ecc6e9878cd10bb92b7e7fefc427f390519b10e059f8f47dba33dd5e"
  else
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.12/go2rtc_mac_amd64.zip"
    sha256 "865e0f46823a80980b9cccad05c29b6ff8f4003de7b00520db353d5ca84d12d7"
  end

  def install
    # 上游 zip 解压后里面的二进制名是 go2rtc_mac_arm64 / go2rtc_mac_amd64
    bin_name = if Hardware::CPU.arm?
      "go2rtc_mac_arm64"
    else
      "go2rtc_mac_amd64"
    end

    bin.install bin_name => "go2rtc"

    # 默认配置目录：/opt/homebrew/etc/go2rtc/go2rtc.yaml
    (etc/"go2rtc").mkpath
    config_file = etc/"go2rtc/go2rtc.yaml"
    unless config_file.exist?
      config_file.write <<~YAML
        # go2rtc default config
        # 修改这个文件后重启服务生效：brew services restart go2rtc
        streams: {}
      YAML
    end
  end

  def post_install
    # 工作目录和日志目录
    (var/"go2rtc").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      配置文件:
        \#{etc}/go2rtc/go2rtc.yaml

      日志文件:
        \#{var}/log/go2rtc.log

      作为守护进程运行、开机自启:
        brew services start \#{name.downcase}

      停止守护进程:
        brew services stop \#{name.downcase}

      修改配置后重启:
        brew services restart \#{name.downcase}
    EOS
  end

  # Homebrew 守护进程配置 => 转成 launchd plist
  service do
    run [opt_bin/"go2rtc", "-config", etc/"go2rtc/go2rtc.yaml"]
    working_dir var/"go2rtc"

    # 崩溃/退出自动重启 & 开机自启
    keep_alive true

    # 日志
    log_path var/"log/go2rtc.log"
    error_log_path var/"log/go2rtc.log"
  end

  test do
    output = shell_output("\#{bin}/go2rtc -h 2>&1")
    assert_match "go2rtc", output
  end
end
