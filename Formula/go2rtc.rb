class Go2rtc < Formula
  desc "Ultimate camera streaming application with RTSP, WebRTC, RTMP, etc."
  homepage "https://github.com/AlexxIT/go2rtc"
  version "1.9.13"

  # stable (release)
  if Hardware::CPU.arm?
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.13/go2rtc_mac_arm64.zip"
    sha256 "71d5621e73070da821dbb7bbc88074ccc52c7be0d96b47dcd4837533cd00ca47"
  else
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.13/go2rtc_mac_amd64.zip"
    sha256 "e06257c82f05e8bfce88769f7ff1fd9c6d838d1b8de7a9d8154888ccc93f31ee"
  end

  # HEAD (nightly artifacts)
  head do
    if Hardware::CPU.arm?
      url "https://nightly.link/AlexxIT/go2rtc/workflows/build/master/go2rtc_mac_arm64.zip"
      sha256 "e1440d9b952b354d5a082d241ec64a9803f1e02b2e8ef77c782af945efcceb1a"
    else
      url "https://nightly.link/AlexxIT/go2rtc/workflows/build/master/go2rtc_mac_amd64.zip"
      sha256 "0043cbdb403d68794385f2b400649eec3466d2f8a771fd6f6b84d4b5907e8a74"
    end
  end

  def install
    bin.install "go2rtc"

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

      安装 HEAD (nightly): brew install #{name.downcase} --HEAD
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
