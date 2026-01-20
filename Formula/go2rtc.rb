class Go2rtc < Formula
  desc "Ultimate camera streaming application with RTSP, WebRTC, RTMP, etc."
  homepage "https://github.com/AlexxIT/go2rtc"
  version "1.9.13"

  # stable (release)
  if Hardware::CPU.arm?
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.14/go2rtc_mac_arm64.zip"
    sha256 "919b78adc759d6b3883d1e1b2ac915ac0985bb903ff1897b4d228527bd64690c"
  else
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.14/go2rtc_mac_amd64.zip"
    sha256 "9b0b9a27a4dc3a5b8b93376e7e8fc2787c6af624a512842622be84aec0171c7a"
  end

  # HEAD (nightly artifacts)
  head do
    if Hardware::CPU.arm?
      url "https://nightly.link/AlexxIT/go2rtc/workflows/build/master/go2rtc_mac_arm64.zip"
      sha256 "9bcf919d09616f42e4eb1150651f20c4253c4f14af3224bc833fedd8c36caab5"
    else
      url "https://nightly.link/AlexxIT/go2rtc/workflows/build/master/go2rtc_mac_amd64.zip"
      sha256 "968d68973cb61d572ff2325b2f5becc35d3fb016168f96b5aeb155de4c15278b"
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
