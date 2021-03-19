#!/bin/sh

# Pre-requisites (need to be installed on this system to build FFmpeg) :
#
# 1 - Homebrew (Download instructions here: https://brew.sh/)
# 2 - nasm - assembler for x86 (Run "brew install nasm" ... after installing Homebrew)
# 3 - clang - C compiler (Run "xcode-select --install")

# Binaries will be placed one level above the source folder (i.e. in the same location as this script)
echo "Starting Build-Script for FFMpeg Build ...\n"
echo "Setting local variables ...\n"
export binDir=".."

#echo "SourceArchivName = ffmpeg-sourceCode.bz2 \n"
## The name of the FFmpeg source code archive (which will be expanded)
#export sourceArchiveName="ffmpeg-sourceCode.bz2"

echo "SourceArchivName = ffmpeg-4.2.2.tar.bz2 \n"
# The name of the FFmpeg source code archive (which will be expanded)
export sourceArchiveName="ffmpeg-4.2.2.tar.bz2"

#echo "SourceDirectoryName = ffmpeg-4.1 \n"
## The name of the FFmpeg source directory (once the archive has been uncompressed)
#export sourceDirectoryName="ffmpeg-4.1"

echo "SourceDirectoryName = ffmpeg-4.2.2 \n"
# The name of the FFmpeg source directory (once the archive has been uncompressed)
<<<<<<< HEAD
export sourceDirectoryName="ffmpeg-4.2.2"

echo "Cleanup SourceDirectory from previous runs...\n"
# Delete source directory to clenaup previous incomplete runs...
rm -rf ../$sourceDirectoryName
=======
export sourceDirectoryName="ffmpeg-4.3.1"
>>>>>>> upstream/master

# Extract source code from archive
echo "Extracting FFmpeg sources from archive ...\n"
tar xjf $sourceArchiveName
echo "Done extracting FFmpeg sources from archive.\n"

# CD to the source directory and configure FFmpeg
cd $sourceDirectoryName
<<<<<<< HEAD

echo "Configuring FFmpeg ... \n"
=======
echo "\nConfiguring FFmpeg ..."
>>>>>>> upstream/master

./configure \
--cc=/usr/bin/clang \
--extra-ldexeflags="-mmacosx-version-min=10.12" \
--extra-ldflags="-mmacosx-version-min=10.12" \
--extra-cflags="-mmacosx-version-min=10.12" \
--bindir="$binDir" \
--enable-gpl \
--enable-version3 \
--enable-shared \
--disable-static \
--enable-runtime-cpudetect \
--enable-pthreads \
--disable-doc \
--disable-txtpages \
--disable-htmlpages \
--disable-manpages \
--disable-podpages \
--disable-debug \
--disable-swscale \
--disable-avdevice \
--disable-sdl2 \
--disable-ffplay \
--disable-ffmpeg \
--disable-ffprobe \
--disable-network \
--disable-postproc \
--disable-appkit \
--enable-avfoundation \
--enable-audiotoolbox \
--disable-libspeex \
--disable-libopencore_amrnb \
--disable-libopencore_amrwb \
--disable-coreimage \
--disable-protocols \
--disable-iconv \
--enable-zlib \
--disable-bzlib \
--disable-lzma \
--enable-protocol=file \
--disable-indevs \
--disable-outdevs \
--disable-videotoolbox \
--disable-securetransport \
--disable-bsfs \
--disable-filters \
--disable-muxers \
--enable-demuxers \
--disable-hwaccels \
--disable-nvenc \
--disable-xvmc \
--enable-parsers \
--disable-encoders \
--enable-decoders

echo "Done configuring FFmpeg.\n"
#exit 0

# Build FFmpeg
<<<<<<< HEAD
echo "Building FFmpeg ... \n"
make && make install
echo "Done make and install FFmpeg.\n"
=======
echo "\nBuilding FFmpeg ..."
make && make install
echo "Done building FFmpeg.\n"

cd ..
mkdir sharedLibs

echo "\nCopying shared libraries to 'sharedLibs' directory ..."

cp $sourceDirectoryName/libavcodec/libavcodec.58.dylib sharedLibs
cp $sourceDirectoryName/libavformat/libavformat.58.dylib sharedLibs
cp $sourceDirectoryName/libavutil/libavutil.56.dylib sharedLibs
cp $sourceDirectoryName/libswresample/libswresample.3.dylib sharedLibs

echo "Done copying shared libraries to 'sharedLibs' directory.\n"

cd sharedLibs

echo "Fixing install names of shared libraries ..."

install_name_tool -id @loader_path/../Frameworks/libavcodec.58.dylib libavcodec.58.dylib
install_name_tool -change /usr/local/lib/libswresample.3.dylib @loader_path/../Frameworks/libswresample.3.dylib libavcodec.58.dylib
install_name_tool -change /usr/local/lib/libavutil.56.dylib @loader_path/../Frameworks/libavutil.56.dylib libavcodec.58.dylib

install_name_tool -id @loader_path/../Frameworks/libavformat.58.dylib libavformat.58.dylib
install_name_tool -change /usr/local/lib/libavcodec.58.dylib @loader_path/../Frameworks/libavcodec.58.dylib libavformat.58.dylib
install_name_tool -change /usr/local/lib/libswresample.3.dylib @loader_path/../Frameworks/libswresample.3.dylib libavformat.58.dylib
install_name_tool -change /usr/local/lib/libavutil.56.dylib @loader_path/../Frameworks/libavutil.56.dylib libavformat.58.dylib

install_name_tool -id @loader_path/../Frameworks/libavutil.56.dylib libavutil.56.dylib

install_name_tool -id @loader_path/../Frameworks/libswresample.3.dylib libswresample.3.dylib
install_name_tool -change /usr/local/lib/libavutil.56.dylib @loader_path/../Frameworks/libavutil.56.dylib libswresample.3.dylib

echo "Done fixing install names of shared libraries.\n"

cd ..
>>>>>>> upstream/master

echo "Remove Source Directory ...\n"
# Delete source directory
<<<<<<< HEAD
rm -rf ../$sourceDirectoryName

echo "Done building FFmpeg and Cleanup.\n"
=======
rm -rf $sourceDirectoryName

echo "All done !\n"
>>>>>>> upstream/master
