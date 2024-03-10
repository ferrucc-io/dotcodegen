class Dotcodegen < Formula
  desc "Generate tests for your code using LLMs"
  homepage "https://github.com/ferrucc-io/dotcodegen"
  url "https://github.com/ferrucc-io/dotcodegen/archive/main.tar.gz"
  version "0.1.0"
  sha256 "e2282bde80c5a374201abc67d1bbad24647cd652b2de9b18273fa1aa8bdce181"

  depends_on "ruby@3.3"

  def install
    system "gem", "build", "dotcodegen.gemspec"
    system "gem", "install", "dotcodegen-0.1.0.gem"
    bin.install "bin/run" => "codegen"
  end

  test do
    system "#{bin}/codegen", "--version"
  end
end