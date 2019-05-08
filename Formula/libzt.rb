class Libzt < Formula
  desc "ZeroTier: libzt -- An encrypted P2P networking library for applications"
  homepage "https://www.zerotier.com"

  url "https://github.com/zerotier/libzt.git",
  :tag      => "1.3.0",
  :revision => "2a377146d6124bb004b9aa263c47f7df2366e7ea"

  depends_on "cmake" => :build
  depends_on "make" => :build

  def install
    system "make", "update"
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "make", "install"
    cp "LICENSE.GPL-3", "#{prefix}/LICENSE"
  end

  def caveats
    <<~EOS
      Visit https://my.zerotier.com to create virtual networks and authorize devices.
      Visit https://www.zerotier.com/manual.shtml to learn more about how ZeroTier works.
      Visit https://github.com/zerotier/ZeroTierOne/tree/master/controller to learn how to run your own network controller (advanced).
    EOS
  end

  test do
    # Writes a simple test program to test.cpp which calls a library function. The expected output of this
    # function is -2. This test verifies the following:
    # - The library was installed correctly
    # - The library was linked correctly
    # - Library code executes successfully and sends the proper error code to the test program
    (testpath/"test.cpp").write <<-EOS
      #include<cstdlib>\n#include<ZeroTier.h>\nint main(){return zts_socket(0,0,0)!=-2;}
    EOS

    system ENV.cc, "-v", "test.cpp", "-o", "test", "-L#{lib}/Release", "-lzt"
    system "./test"
  end
end
