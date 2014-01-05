require 'formula'

class Libsbmlsim < Formula
  homepage 'http://fun.bio.keio.ac.jp/software/libsbmlsim/'
  url 'http://fun.bio.keio.ac.jp/software/libsbmlsim/downloads/libsbmlsim-1.1.0.tar.gz'
  version '1.1.0'
  sha1 '1608c36d06b0b2d4ae7eb64ff3d9cd380a3c4edb'

  LANGUAGES_OPTIONAL = { 
    'csharp' => 'C#',
    'java' => 'Java',
    'ruby' => 'Ruby',
    'python' => 'Python'
  }
  LANGUAGES_OPTIONAL.each do |opt, lang|
    option "with-#{opt}", "generate #{lang} language binding"
  end

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on 'libsbml'
  depends_on :python => :optional

  def install
    mkdir 'build' do
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"

      python do
        args << '-DWITH_PYTHON=ON'
        args << "-DPYTHON_INCLUDE_DIR='#{python.incdir}'"
        args << "-DPYTHON_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
        args << "-DPYTHON_SETUP_ARGS:STRING='--prefix=#{prefix} --single-version-externally-managed --record=installed.txt'"
      end

      args << '-DWITH_JAVA=ON' if build.with? 'java'
      args << '-DWITH_RUBY=ON' if build.with? 'ruby'
      args << '-DWITH_CSHARP=ON' if build.with? 'csharp'

      system 'cmake', '..', *args
      #ENV.deparallelize # uncomment for debug
      system 'make', 'install'
    end
  end
end

__END__
