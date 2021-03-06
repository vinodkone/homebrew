class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/archive/v2.3.1.tar.gz"
  sha256 "34d6f62feefb239ca443abae4b0878a89557de064c8405b170d0df509150f33c"
  head "https://github.com/shadowsocks/shadowsocks-libev.git"

  bottle do
    cellar :any
    sha256 "3e3cd76b4a440d90a5f2c74fa9a8cb6fb7b0b9a90fddb1ba3bc551ee8caaba23" => :yosemite
    sha256 "ecd5f0ba20f6d3f97e614a8591aff8085778e5f53c04681864a7bed03d44b378" => :mavericks
    sha256 "036a8a9c0333a6b0b0890c2e72c91e738a665d3b9faf2c2650f74f29c6b5ceca" => :mountain_lion
  end

  depends_on "openssl"

  def install
    args = ["--prefix=#{prefix}"]

    system "./configure", *args
    system "make"

    bin.install "src/ss-local"
    bin.install "src/ss-tunnel"

    (buildpath/"shadowsocks-libev.json").write <<-EOS.undent
      {
          "server":"localhost",
          "server_port":8388,
          "local_port":1080,
          "password":"barfoo!",
          "timeout":600,
          "method":null
      }
    EOS
    etc.install "shadowsocks-libev.json"

    inreplace "shadowsocks-libev.8", "/etc/shadowsocks-libev/config.json", "#{etc}/shadowsocks-libev.json"
    man8.install "shadowsocks-libev.8"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/shadowsocks-libev/bin/ss-local -c #{HOMEBREW_PREFIX}/etc/shadowsocks-libev.json"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/ss-local</string>
          <string>-c</string>
          <string>#{etc}/shadowsocks-libev.json</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
