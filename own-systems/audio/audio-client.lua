-- Modern Audio Client for SA-MP
-- Listens for audio commands via client messages

print("=== Audio Client for CONR-RP ===")
print("Starting script initialization...")

-- Safe require function with error handling
local function safeRequire(module)
    local success, result = pcall(require, module)
    if not success then
        print("Failed to load module: " .. module)
        print("Error: " .. tostring(result))
        return false
    end
    print("Successfully loaded: " .. module)
    return result
end

-- Load required modules
local moonloader = safeRequire("moonloader")
local sampfuncs = safeRequire("sampfuncs")
local sampev = safeRequire("lib.samp.events")
local bass = safeRequire("lib.bass")

-- Don't terminate if modules fail - let main() handle it
if not moonloader then
    print("ERROR: moonloader module not found!")
end

if not sampfuncs then
    print("ERROR: sampfuncs module not found!")
end

if not sampev then
    print("ERROR: lib.samp.events module not found!")
end

if not bass then
    print("WARNING: BASS library not found!")
    print("Audio playback will not work without BASS library")
    print("Download from: https://github.com/THE-FYP/BASS.lua")
end

script_name("Audio Client")
script_author("CONR-RP")
script_version("1.0")

-- Audio streams storage
local audioStreams = {}
local logFile = nil
local bassInitialized = false

-- Initialize log file
local function initLog()
    local scriptPath = thisScript().path
    local logPath = scriptPath:gsub("%.lua$", ".log")
    logFile = io.open(logPath, "a")
    if logFile then
        logFile:write(string.format("\n=== Audio Client Started: %s ===\n", os.date("%Y-%m-%d %H:%M:%S")))
        logFile:flush()
        print("Log file created: " .. logPath)
    else
        print("ERROR: Failed to create log file")
    end
end

-- Write to log file
local function writeLog(message)
    local timestamp = os.date("%H:%M:%S")
    local logMessage = string.format("[%s] %s", timestamp, message)
    
    -- Print to console
    print(logMessage)
    
    -- Write to file
    if logFile then
        logFile:write(logMessage .. "\n")
        logFile:flush()
    end
end

-- Initialize BASS
local function initBass()
    if not bass then
        writeLog("BASS library not available")
        return false
    end
    
    -- BASS_Init(device, freq, flags, win, clsid)
    -- device: -1 = default device
    -- freq: 44100 = sample rate
    -- flags: 0 = no special flags
    -- win: 0 = no window handle (for 3D)
    -- clsid: nil = not used
    local result = bass.BASS_Init(-1, 44100, 0, 0, nil)
    if result then
        bassInitialized = true
        writeLog("BASS initialized successfully")
        return true
    else
        local errorCode = bass.BASS_ErrorGetCode()
        writeLog(string.format("BASS initialization failed with error code: %d", errorCode))
        return false
    end
end

-- Parse audio command from client message
local function parseAudioCommand(text)
    -- Remove color codes first (e.g., {000000}, {FFFFFF}, etc.)
    local cleanText = text:gsub("{%x%x%x%x%x%x}", "")
    
    -- Check if message starts with [AUDIO] prefix
    if not cleanText:match("^%[AUDIO%]") then
        return nil
    end
    
    writeLog("Found [AUDIO] prefix in message: " .. cleanText)
    
    -- Remove prefix and parse command
    local command = cleanText:gsub("^%[AUDIO%]", "")
    writeLog("Command after prefix removal: " .. command)
    
    local parts = {}
    for part in command:gmatch("[^|]+") do
        table.insert(parts, part)
        writeLog(string.format("Parsed part #%d: %s", #parts, part))
    end
    
    return parts
end

-- Handle AUDIO_PLAY command
local function handleAudioPlay(parts)
    if not bassInitialized then
        writeLog("ERROR: BASS not initialized, cannot play audio")
        return
    end
    
    local audioid = tonumber(parts[2])
    local url = parts[3]
    local volume = tonumber(parts[4]) or 1.0
    local flags = tonumber(parts[5]) or 0
    
    writeLog(string.format("handleAudioPlay: audioid=%s, url=%s, volume=%s, flags=%s", 
        tostring(audioid), tostring(url), tostring(volume), tostring(flags)))
    
    if not audioid or not url then
        writeLog("ERROR: Missing audioid or url")
        return
    end
    
    local stream
    
    -- Check if URL is HTTP/HTTPS or local file
    if url:match("^https?://") then
        writeLog("Creating stream from URL: " .. url)
        stream = bass.BASS_StreamCreateURL(url, 0, 0, nil, nil)
    else
        -- Treat as local file path relative to GTA SA directory (not moonloader)
        local filePath = url
        
        -- If relative path, prepend GTA SA directory (go up 2 levels from moonloader)
        if not filePath:match("^%a:") then
            -- Get moonloader directory
            local moonloaderPath = getWorkingDirectory()
            -- Go up one level to GTA SA root
            local gtaPath = moonloaderPath:match("^(.+)\\[^\\]+$")
            filePath = gtaPath .. "\\" .. url
        end
        
        writeLog("Creating stream from file: " .. filePath)
        
        -- Check if file exists
        local file = io.open(filePath, "r")
        if file then
            file:close()
            writeLog("File exists: " .. filePath)
        else
            writeLog("ERROR: File not found: " .. filePath)
            return
        end
        
        -- Create stream from file
        stream = bass.BASS_StreamCreateFile(false, filePath, 0, 0, 0)
    end
    
    if stream == 0 then
        local errorCode = bass.BASS_ErrorGetCode()
        writeLog(string.format("ERROR: Failed to create stream (BASS Error: %d)", errorCode))
        return
    end
    
    writeLog("Stream created successfully: " .. tostring(stream))
    
    -- Set volume (0.0 to 1.0) BEFORE playing
    writeLog("Setting volume to: " .. tostring(volume))
    bass.BASS_ChannelSetAttribute(stream, bass.BASS_ATTRIB_VOL, volume)
    
    -- Check if loop flag is set
    if flags == 1 then
        writeLog("Setting loop flag...")
        bass.BASS_ChannelFlags(stream, bass.BASS_SAMPLE_LOOP, bass.BASS_SAMPLE_LOOP)
        writeLog("Loop flag set")
    end
    
    -- Play stream
    writeLog("Attempting to play stream...")
    local playResult = bass.BASS_ChannelPlay(stream, false)
    writeLog("Play result: " .. tostring(playResult))
    
    if not playResult or playResult == 0 then
        local errorCode = bass.BASS_ErrorGetCode()
        writeLog(string.format("ERROR: Failed to play stream (BASS Error: %d)", errorCode))
        bass.BASS_StreamFree(stream)
        return
    end
    
    -- Store stream
    audioStreams[audioid] = stream
    
    writeLog(string.format("SUCCESS: Playing audio ID=%d", audioid))
end

-- Handle AUDIO_STOP command
local function handleAudioStop(parts)
    if not bassInitialized then
        return
    end
    
    local audioid = tonumber(parts[2])
    
    if not audioid or not audioStreams[audioid] then
        return
    end
    
    bass.BASS_ChannelStop(audioStreams[audioid])
    bass.BASS_StreamFree(audioStreams[audioid])
    audioStreams[audioid] = nil
    
    writeLog(string.format("Stopped: ID=%d", audioid))
end

-- Handle AUDIO_STOPALL command
local function handleAudioStopAll()
    if not bassInitialized then
        return
    end
    
    for audioid, stream in pairs(audioStreams) do
        bass.BASS_ChannelStop(stream)
        bass.BASS_StreamFree(stream)
    end
    audioStreams = {}
    writeLog("Stopped all streams")
end

-- Event handler for server messages
function sampev.onServerMessage(color, text)
    writeLog(string.format("Received message: color=0x%08X, text=%s", color, text))
    
    local parts = parseAudioCommand(text)
    
    if not parts then
        return
    end
    
    writeLog("Parsed command: " .. parts[1])
    
    local command = parts[1]
    
    if command == "AUDIO_PLAY" then
        writeLog("Handling AUDIO_PLAY command")
        handleAudioPlay(parts)
        return false -- Hide message from chat
    elseif command == "AUDIO_STOP" then
        writeLog("Handling AUDIO_STOP command")
        handleAudioStop(parts)
        return false
    elseif command == "AUDIO_STOPALL" then
        writeLog("Handling AUDIO_STOPALL command")
        handleAudioStopAll()
        return false
    end
end

-- Main function
function main()
    -- Check if critical modules loaded
    if not moonloader then
        print("FATAL: moonloader not loaded - script cannot run")
        return
    end
    
    if not sampfuncs then
        print("FATAL: sampfuncs not loaded - script cannot run")
        return
    end
    
    if not sampev then
        print("FATAL: lib.samp.events not loaded - script cannot run")
        return
    end
    
    -- Wait for SAMP to load
    print("Waiting for SAMP to load...")
    if not isSampLoaded() or not isSampfuncsLoaded() then
        print("SAMP not loaded yet, waiting...")
        return
    end
    
    while not isSampAvailable() do
        wait(100)
    end
    
    print("SAMP is available, initializing script...")
    
    -- Send chat message to confirm script loaded
    sampAddChatMessage("{00FF00}[Audio Client] Script loaded successfully!", 0xFFFFFFFF)
    
    initLog()
    writeLog("Audio Client loaded successfully")
    
    if bass then
        if initBass() then
            -- sampAddChatMessage("{00FF00}[Audio Client] BASS initialized - audio ready!", 0xFFFFFFFF)
        else
            sampAddChatMessage("{FF0000}[Audio Client] BASS initialization failed!", 0xFFFFFFFF)
        end
    else
        sampAddChatMessage("{FFFF00}[Audio Client] Running without BASS - audio disabled", 0xFFFFFFFF)
        writeLog("Running without BASS - audio playback disabled")
    end
    
    writeLog("Listening for audio commands...")
    
    wait(-1)
end

-- Cleanup on script unload
function onScriptTerminate(script, quitGame)
    if script == thisScript() then
        writeLog("Script terminating, cleaning up...")
        if bassInitialized then
            handleAudioStopAll()
            bass.BASS_Free()
        end
        if logFile then
            logFile:close()
        end
    end
end
