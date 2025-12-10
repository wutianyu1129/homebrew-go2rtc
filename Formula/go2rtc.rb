class Go2rtc < Formula
  desc "Ultimate camera streaming application with RTSP, WebRTC, RTMP, etc."
  homepage "https://github.com/AlexxIT/go2rtc"
  version "1.9.12"

  if Hardware::CPU.arm?
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.12/go2rtc_mac_arm64.zip"
    sha256 "63d3e986ecc6e9878cd10bb92b7e7fefc427f390519b10e059f8f47dba33dd5e"
  else
    url "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.12/go2rtc_mac_amd64.zip"
    sha256 "865e0f46823a80980b9cccad05c29b6ff8f4003de7b00520db353d5ca84d12d7"
  end

  def install
    if Hardware::CPU.arm?
      bin.install "go2rtc_mac_arm64" => "go2rtc"
    else
      bin.install "go2rtc_mac_amd64" => "go2rtc"
    end
  end

  test do
    output = shell_output("#{bin}/go2rtc -h 2>&1")
    assert_match "go2rtc", output
  end
end
