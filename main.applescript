-- MovToMp4 — ultra-light .mov → .mp4 converter (AppleScript droplet)
-- Usage:
--  - Drag/drop .mov onto the app OR
--  - Right-click .mov → Open With → MovToMp4 OR
--  - Launch app to pick files

-- Silent mode: no UI, no notifications

on run
    -- No UI on direct launch; do nothing
end run

on open droppedItems
    set ffmpegPath to my findFfmpeg()
    repeat with anItem in droppedItems
        try
            set inPosixPath to POSIX path of anItem
            set inQ to quoted form of inPosixPath

            -- compute output path, avoid overwrite by adding _N if needed
            set outPosixPath to do shell script "dir=$(dirname " & inQ & "); base=$(basename " & inQ & "); root=${base%.*}; out=\"$dir/$root.mp4\"; if [ -e \"$out\" ]; then i=1; while [ -e \"$dir/$root_$i.mp4\" ]; do i=$((i+1)); done; out=\"$dir/$root_$i.mp4\"; fi; printf '%s' \"$out\""
            set outQ to quoted form of outPosixPath

            -- try fastest path: stream copy into MP4 container
            try
                do shell script quoted form of ffmpegPath & " -hide_banner -loglevel error -y -i " & inQ & " -c copy -movflags +faststart " & outQ
            on error
                -- fallback: hardware-accelerated re-encode for maximum efficiency
                do shell script quoted form of ffmpegPath & " -hide_banner -loglevel error -y -hwaccel videotoolbox -i " & inQ & " -c:v h264_videotoolbox -b:v 6M -c:a aac -b:a 160k -movflags +faststart " & outQ
            end try
        on error errMsg
            -- Silent failure; no UI
        end try
    end repeat
end open

on filenameFromPath(p)
    set AppleScript's text item delimiters to "/"
    set parts to text items of p
    set AppleScript's text item delimiters to ""
    return item -1 of parts
end filenameFromPath

on findFfmpeg()
    try
        set path1 to do shell script "command -v ffmpeg || true"
        if path1 is not "" then return path1
    end try
    repeat with candidate in {"/opt/homebrew/bin/ffmpeg", "/usr/local/bin/ffmpeg", "/usr/bin/ffmpeg"}
        try
            do shell script "test -x " & quoted form of candidate
            return candidate as string
        end try
    end repeat
    error "ffmpeg not found. Install via Homebrew: brew install ffmpeg"
end findFfmpeg


