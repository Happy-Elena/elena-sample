#!/usr/bin/env bash
# Rebuild the video-editing toolkit in a fresh cloud session.
# Idempotent: re-running skips what is already in place.
# Usage: bash CloudSkills/video-studio/setup.sh   (installs into ~/video-studio)
set -euo pipefail

STUDIO="${VIDEO_STUDIO:-$HOME/video-studio}"
REMOTION_VERSION=4.0.540
HYPERFRAMES_VERSION=0.9.13
WHISPER_TAG=v1.9.5
WHISPER_MODEL=ggml-large-v3-turbo-q5_0.bin
YTDLP_VERSION=2026.10.26

mkdir -p "$STUDIO"/{bin,tools,models,out}
cd "$STUDIO"

need() { command -v "$1" >/dev/null || { echo "missing: $1" >&2; exit 1; }; }
need node; need npm; need git; need cmake; need ffmpeg; need ffprobe

# 1+2. Remotion and HyperFrames (npm)
[ -f package.json ] || npm init -y >/dev/null
npm i --no-fund --no-audit \
  "remotion@$REMOTION_VERSION" "@remotion/cli@$REMOTION_VERSION" react@19 react-dom@19 \
  "hyperframes@$HYPERFRAMES_VERSION"
npx hyperframes skills update   # core skills -> ~/.claude/skills

# 3. FFmpeg: system package (Ubuntu 24.04 ships 6.1.1)
ffmpeg -hide_banner -version | head -1

# 4. whisper.cpp + model
if [ ! -x tools/whisper.cpp/build/bin/whisper-cli ]; then
  rm -rf tools/whisper.cpp
  git clone -q --depth 1 --branch "$WHISPER_TAG" https://github.com/ggml-org/whisper.cpp.git tools/whisper.cpp
  cmake -S tools/whisper.cpp -B tools/whisper.cpp/build -DCMAKE_BUILD_TYPE=Release -DWHISPER_BUILD_TESTS=OFF >/dev/null
  cmake --build tools/whisper.cpp/build -j"$(nproc)" --config Release >/dev/null
fi
ln -sf ../tools/whisper.cpp/build/bin/whisper-cli bin/whisper-cli
[ -s "models/$WHISPER_MODEL" ] || curl -sSL --fail -o "models/$WHISPER_MODEL" \
  "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/$WHISPER_MODEL"

# 5. yt-dlp (GitHub release binary, checksum-verified)
if [ ! -x bin/yt-dlp ] || [ "$(bin/yt-dlp --version)" != "$YTDLP_VERSION" ]; then
  base="https://github.com/yt-dlp/yt-dlp/releases/download/$YTDLP_VERSION"
  curl -sSL --fail -o bin/yt-dlp.tmp "$base/yt-dlp_linux"
  want=$(curl -sSL --fail "$base/SHA2-256SUMS" | awk '$2=="yt-dlp_linux"{print $1}')
  got=$(sha256sum bin/yt-dlp.tmp | awk '{print $1}')
  [ "$want" = "$got" ] || { echo "yt-dlp checksum mismatch" >&2; rm -f bin/yt-dlp.tmp; exit 1; }
  chmod +x bin/yt-dlp.tmp && mv bin/yt-dlp.tmp bin/yt-dlp
fi

echo
echo "Ready in $STUDIO. Add to PATH:  export PATH=\"$STUDIO/bin:\$PATH\""
echo "remotion    $(npx remotion versions 2>/dev/null | grep -q 'correct version' && echo $REMOTION_VERSION)"
echo "hyperframes $(npx hyperframes --version)"
echo "ffmpeg      $(ffmpeg -hide_banner -version | head -1 | awk '{print $3}')"
echo "whisper     $(bin/whisper-cli --version 2>&1 | head -1 | awk '{print $NF}') + $WHISPER_MODEL"
echo "yt-dlp      $(bin/yt-dlp --version)"
