class Go2rtc < Formula
  desc "Ultimate camera streaming application with RTSP, WebRTC, RTMP, etc."
  homepage "https://github.com/AlexxIT/go2rtc"
  version "1.9.13"

  # 根据架构选择 URL 和 SHA
  if Hardware::CPU.arm?
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.13/go2rtc_mac_arm64.zip"
    sha256 "71d5621e73070da821dbb7bbc88074ccc52c7be0d96b47dcd4837533cd00ca47"
  else
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.13/go2rtc_mac_amd64.zip"
    sha256 "e06257c82f05e8bfce88769f7ff1fd9c6d838d1b8de7a9d8154888ccc93f31ee"
  end

  def install
    # 关键修改：直接安装名为 go2rtc 的二进制文件
    bin.install "go2rtc"

    # 配置文件逻辑
    (etc/"go2rtc").mkpath
    config_file = etc/"go2rtc/go2rtc.yaml"
    unless config_file.exist?
      config_file.write <<~YAML
        streams: {}
      YAML
    end
  end

  def post_install
    (var/"go2rtc").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      配置文件: #{etc}/go2rtc/go2rtc.yaml
      日志文件: #{var}/log/go2rtc.log
      
      启动服务: brew services start #{name.downcase}
      重启服务: brew services restart #{name.downcase}
    EOS
  end

  service do
    run [opt_bin/"go2rtc", "-config", etc/"go2rtc/go2rtc.yaml"]
    working_dir var/"go2rtc"
    keep_alive true
    log_path var/"log/go2rtc.log"
    error_log_path var/"log/go2rtc.log"
  end

  test do
    output = shell_output("#{bin}/go2rtc -h 2>&1")
    assert_match "go2rtc", output
  end
end
