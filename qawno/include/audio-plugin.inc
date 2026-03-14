/*
 * Modern Audio Plugin - Server Include
 * SA-MP Audio System with HTTP/WebSocket Communication
 */

#if defined _audio_plugin_included
    #endinput
#endif
#define _audio_plugin_included

// Audio flags
#define AUDIO_LOOP          (1)
#define AUDIO_3D            (2)
#define AUDIO_AUTOPLAY      (4)

// Max values
#define MAX_AUDIO_STREAMS   (10)
#define MAX_AUDIO_URL       (256)

// Natives
native Audio_Play(playerid, const url[], Float:volume = 1.0, flags = 0);
native Audio_Play3D(playerid, const url[], Float:x, Float:y, Float:z, Float:distance = 50.0, Float:volume = 1.0, flags = 0);
native Audio_Stop(playerid, audioid);
native Audio_StopAll(playerid);
native Audio_SetVolume(playerid, audioid, Float:volume);
native Audio_SetPosition(playerid, audioid, Float:x, Float:y, Float:z);
native Audio_GetStatus(playerid, audioid);
native Audio_IsPlaying(playerid, audioid);
native Audio_Pause(playerid, audioid);
native Audio_Resume(playerid, audioid);
native Audio_SetLooping(playerid, audioid, bool:loop);

// Callbacks
forward OnAudioFinished(playerid, audioid);
forward OnAudioError(playerid, audioid, errorcode);

// Internal callback for sending commands to client
forward Audio_SendToClient(playerid, const command[]);

// Default implementation - override this in your gamemode
public Audio_SendToClient(playerid, const command[])
{
	// Log the command being sent
	printf("[Audio] Sending to player %d: %s", playerid, command);
	
	// Send as client message with special prefix that Lua script will detect
	new msg[256];
	format(msg, sizeof(msg), "{000000}[AUDIO]%s", command);
	SendClientMessage(playerid, 0x00000000, msg);
	
	printf("[Audio] Message sent: %s", msg);
	return 1;
}

// Helper functions
stock Audio_PlayForAll(const url[], Float:volume = 1.0, flags = 0) {
    new audioid = -1;
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            audioid = Audio_Play(i, url, volume, flags);
        }
    }
    return audioid;
}

stock Audio_PlayInRange(Float:x, Float:y, Float:z, Float:range, const url[], Float:volume = 1.0) {
    new audioid = -1;
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            new Float:px, Float:py, Float:pz;
            GetPlayerPos(i, px, py, pz);
            if(GetDistance3D(x, y, z, px, py, pz) <= range) {
                audioid = Audio_Play3D(i, url, x, y, z, range, volume, AUDIO_3D);
            }
        }
    }
    return audioid;
}

stock Float:GetDistance3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {
    return floatsqroot(
        floatpower(x2 - x1, 2.0) +
        floatpower(y2 - y1, 2.0) +
        floatpower(z2 - z1, 2.0)
    );
}
