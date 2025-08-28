class MovToMp4 < Formula
  desc "Ultra-light .mov → .mp4 converter (macOS droplet)"
  homepage "https://github.com/yourname/movtomp4"
  url "https://github.com/yourname/movtomp4/releases/download/v1.0.0/MovToMp4.zip"
  sha256 "REPLACE_WITH_SHA256"
  license "MIT"

  depends_on "ffmpeg"

  def install
    prefix.install Dir["*"]
    # App bundle installed into prefix; user can link or run from prefix
  end

  def caveats
    <<~EOS
      MovToMp4.app installed to:
        #{prefix}/MovToMp4.app

      You can move it to /Applications:
        cp -R #{prefix}/MovToMp4.app /Applications/

      Or right-click a .mov → Open With → MovToMp4
    EOS
  end
end


