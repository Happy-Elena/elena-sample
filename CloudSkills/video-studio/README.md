# video-studio

Toolkit for video editing in a cloud session. Not a skill: run `setup.sh` once per
fresh container, it installs everything into `~/video-studio` (outside the repo).

| Tool | Source | Version | Binary |
|---|---|---|---|
| Remotion | npm `remotion`, `@remotion/cli` | 4.0.540 | `npx remotion` |
| HyperFrames | npm `hyperframes` + core skills in `~/.claude/skills` | 0.9.13 | `npx hyperframes` |
| FFmpeg | Ubuntu package | 6.1.1 | `ffmpeg`, `ffprobe` |
| whisper.cpp | github.com/ggml-org/whisper.cpp, built locally | v1.9.5 | `bin/whisper-cli` |
| Whisper model | huggingface.co/ggerganov/whisper.cpp | large-v3-turbo-q5_0 | `models/` |
| yt-dlp | GitHub release, SHA-256 verified | 2026.10.26 | `bin/yt-dlp` |

Notes:
- Remotion license: free for individuals and companies up to 3 people.
- YouTube refuses media downloads to cloud IPs (metadata works); other sites are fine.
- HyperFrames sends usage telemetry; disable with `HYPERFRAMES_NO_TELEMETRY=1`.
- Whisper on 4 CPU cores: about 1.6x real time for Russian with this model.
