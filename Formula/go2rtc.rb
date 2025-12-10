class Go2rtc < Formula
  desc "Ultimate camera streaming application with RTSP, WebRTC, RTMP, etc."
  homepage "https://github.com/AlexxIT/go2rtc"
  version "1.9.12"

  # 根据架构选择 URL 和 SHA
  if Hardware::CPU.arm?
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.12/go2rtc_mac_arm64.zip"
    sha256 "63d3e986ecc6e9878cd10bb92b7e7fefc427f390519b10e059f8f47dba33dd5e"
  else
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.12/go2rtc_mac_amd64.zip"
    sha256 "865e0f46823a80980b9cccad05c29b6ff8f4003de7b00520db353d5ca84d12d7"
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
