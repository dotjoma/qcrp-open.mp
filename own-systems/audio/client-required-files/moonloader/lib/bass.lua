local ffi  = require( "ffi" )
local libs = ffi_Bass_libs or {
   OSX     = { x86 = "libbass.dylib",       x64 = "libbass.dylib" },
   Windows = { x86 = "bass.dll", x64 = "" },
   Linux   = { x86 = "libbass.so",    x64 = "libbass.so", arm = "libbass.so"  },
   BSD     = { },
   POSIX   = { },
   Other   = { }, 
}
local lib  = ffi_Bass_lib or libs[ ffi.os ][ ffi.arch ] or "Bass"
local bass = ffi.load( lib )

ffi.cdef [[
    typedef unsigned char BYTE;
    typedef unsigned short WORD;
    typedef unsigned long DWORD;
    typedef unsigned __int64 QWORD;
    typedef unsigned long HWND;
    typedef unsigned long GUID;
    typedef int BOOL;

    typedef struct _GUID {
      DWORD Data1;
      WORD  Data2;
      WORD  Data3;
      BYTE  Data4[8];
    } GUID;

    typedef DWORD HMUSIC;       // MOD music handle
    typedef DWORD HSAMPLE;      // sample handle
    typedef DWORD HCHANNEL;     // playing sample's channel handle
    typedef DWORD HSTREAM;      // sample stream handle
    typedef DWORD HRECORD;      // recording handle
    typedef DWORD HSYNC;        // synchronizer handle
    typedef DWORD HDSP;         // DSP handle
    typedef DWORD HFX;          // DX8 effect handle
    typedef DWORD HPLUGIN;      // Plugin handle

    typedef void (__stdcall *DOWNLOADPROC)(const void *buffer, DWORD length, void *user);

    enum {
      BASS_POS_BYTE = 0,
      BASS_ACTIVE_PLAYING = 1,
      BASS_STREAM_PRESCAN = 0x20000, // enable pin-point seeking/length (MP3/MP2/MP1)
      BASS_SAMPLE_LOOP = 4,
      BASS_ATTRIB_VOL = 2,
    };

    BOOL BASS_Init(int device, DWORD freq, DWORD flags, HWND win, const GUID *dsguid);
    BOOL BASS_Free();
    HSTREAM BASS_StreamCreateFile(BOOL mem, const void *file, QWORD offset, QWORD length, DWORD flags);
    HSTREAM BASS_StreamCreateURL(const char *url, DWORD offset, DWORD flags, DOWNLOADPROC *proc, void *user);
    BOOL BASS_StreamFree(HSTREAM handle);
    BOOL BASS_Start();
    BOOL BASS_Update(DWORD length);

    BOOL BASS_ChannelPlay(DWORD handle, BOOL restart);
    BOOL BASS_ChannelPause(DWORD handle);
    BOOL BASS_ChannelStop(DWORD handle);
    DWORD BASS_ChannelIsActive(DWORD handle);
    BOOL BASS_ChannelSetPosition(DWORD handle, QWORD pos, DWORD mode);
    QWORD BASS_ChannelSeconds2Bytes(DWORD handle, double pos);
    QWORD BASS_ChannelGetPosition(DWORD handle, DWORD mode);
    QWORD BASS_ChannelSeconds2Bytes(DWORD handle, double pos);
    double BASS_ChannelBytes2Seconds(DWORD handle, QWORD pos);
    QWORD BASS_ChannelGetLength(DWORD handle, DWORD mode);
    BOOL BASS_ChannelSetAttribute(DWORD handle, DWORD attrib, float value);
    BOOL BASS_ChannelGetAttribute(DWORD handle, DWORD attrib, float *value);
    DWORD BASS_ChannelFlags(DWORD handle, DWORD flags, DWORD mask);
    HSAMPLE BASS_SampleLoad(BOOL mem, const void *file, QWORD offset, DWORD length, DWORD max, DWORD flags);
    HCHANNEL BASS_SampleGetChannel(HSAMPLE handle, BOOL onlynew);

    int BASS_ErrorGetCode();
]]

return bass