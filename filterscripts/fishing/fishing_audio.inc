/*
    FISHING RPG SYSTEM - AUDIO MODULE
    Background music and sound effects for fishing
*/

#if defined _fishing_audio_included
    #endinput
#endif
#define _fishing_audio_included

// Audio IDs storage per player
new PlayerFishingMusic[MAX_PLAYERS] = {-1, ...};
new PlayerReelSound[MAX_PLAYERS] = {-1, ...};
new PlayerSuccessSound[MAX_PLAYERS] = {-1, ...};
new PlayerBattleSound[MAX_PLAYERS] = {-1, ...};

// Audio URLs - local file path
#define FISHING_THEME_URL       "audio/conrrp_resources/fishing/fish_theme.mp3"
#define CATCH_SUCCESS_URL       "audio/conrrp_resources/fishing/fish_success.mp3"
#define LEVELUP_SOUND_URL       "audio/conrrp_resources/fishing/levelup.mp3"
#define FISHING_START_URL       "audio/conrrp_resources/fishing/fish_start.mp3"
#define FISHING_STRIKE_URL      "audio/conrrp_resources/fishing/fishing_strike.mp3"
#define FISHING_REEL_URL        "audio/conrrp_resources/fishing/fishing_reel.mp3"
#define FISHING_REEL_BATTLE_1   "audio/conrrp_resources/fishing/fishing_reel_battle_1.mp3"
#define FISHING_REEL_BATTLE_2   "audio/conrrp_resources/fishing/fishing_reel_battle_2.mp3"
#define FISHING_REEL_BATTLE_3   "audio/conrrp_resources/fishing/fishing_reel_battle_3.mp3"
#define FISHING_REEL_BATTLE_4   "audio/conrrp_resources/fishing/fishing_reel_battle_4.mp3"
#define FISHING_LINE_SNAP       "audio/conrrp_resources/fishing/fishline_snap.mp3"
#define FISHING_REEL_RUN        "audio/conrrp_resources/fishing/fishing_reel_run.mp3"

// ============================================
// AUDIO FUNCTIONS
// ============================================

stock StartFishingMusic(playerid)
{
    // Stop any existing music first
    if(PlayerFishingMusic[playerid] != -1)
    {
        printf("[FISHING AUDIO DEBUG] Stopping existing music ID: %d", PlayerFishingMusic[playerid]);
        Audio_Stop(playerid, PlayerFishingMusic[playerid]);
    }
    
    // Play fishing theme music (looped, low volume)
    new audioid = Audio_Play(playerid, 
        FISHING_THEME_URL, 
        0.3,  // 30% volume para hindi masyadong malakas
        AUDIO_LOOP
    );
    
    PlayerFishingMusic[playerid] = audioid;
    
    printf("[FISHING AUDIO] Started music for player %d (Audio ID: %d)", 
        playerid, PlayerFishingMusic[playerid]);
}

stock StopFishingMusic(playerid)
{
    printf("[FISHING AUDIO DEBUG] StopFishingMusic called for player %d, current audio ID: %d", 
        playerid, PlayerFishingMusic[playerid]);
    
    if(PlayerFishingMusic[playerid] != -1)
    {
        printf("[FISHING AUDIO DEBUG] Calling Audio_Stop for player %d, audio ID: %d", 
            playerid, PlayerFishingMusic[playerid]);
        
        Audio_Stop(playerid, PlayerFishingMusic[playerid]);
        PlayerFishingMusic[playerid] = -1;
        
        printf("[FISHING AUDIO] Stopped music for player %d", playerid);
    }
    else
    {
        printf("[FISHING AUDIO DEBUG] No music to stop (audio ID is -1)");
    }
}

// Ambient sounds removed - not needed

stock PlayFishingStrikeSound(playerid)
{
    // Play success sound effect (no loop)
    Audio_Play(playerid, FISHING_STRIKE_URL, 0.8, 0);
}

stock PlayCatchSuccessSound(playerid)
{
    // Play success sound effect (no loop) and store the audio ID
    PlayerSuccessSound[playerid] = Audio_Play(playerid, CATCH_SUCCESS_URL, 0.8, 0);
}

stock PlayLevelUpSound(playerid)
{
    // Play level up sound effect
    Audio_Play(playerid, LEVELUP_SOUND_URL, 1.0, 0);
}

stock PlayFishingStartSound(playerid)
{
    // Play fishing start sound effect
    Audio_Play(playerid, FISHING_START_URL, 0.7, 0);
}

stock PlayFishingReelSound(playerid)
{
    printf("[FISHING AUDIO DEBUG] PlayFishingReelSound called for player %d", playerid);
    
    // Stop any existing reel sound
    if(PlayerReelSound[playerid] != -1)
    {
        printf("[FISHING AUDIO DEBUG] Stopping existing reel sound ID: %d", PlayerReelSound[playerid]);
        Audio_Stop(playerid, PlayerReelSound[playerid]);
    }
    
    // Play fishing reel sound effect (looping for continuous sound)
    PlayerReelSound[playerid] = Audio_Play(playerid, FISHING_REEL_URL, 0.6, AUDIO_LOOP);
    printf("[FISHING AUDIO DEBUG] Started new reel sound with ID: %d", PlayerReelSound[playerid]);
}

stock StopFishingReelSound(playerid)
{
    printf("[FISHING AUDIO DEBUG] StopFishingReelSound called for player %d, current reel sound ID: %d", 
        playerid, PlayerReelSound[playerid]);
    
    if(PlayerReelSound[playerid] != -1)
    {
        printf("[FISHING AUDIO DEBUG] Calling Audio_Stop for reel sound ID: %d", PlayerReelSound[playerid]);
        Audio_Stop(playerid, PlayerReelSound[playerid]);
        PlayerReelSound[playerid] = -1;
        printf("[FISHING AUDIO DEBUG] Reel sound stopped and ID reset to -1");
    }
    else
    {
        printf("[FISHING AUDIO DEBUG] No reel sound to stop (ID is -1)");
    }
}

stock PlayReelBattleSound(playerid, intensity)
{
    // Stop any existing battle sound
    if(PlayerBattleSound[playerid] != -1)
    {
        Audio_Stop(playerid, PlayerBattleSound[playerid]);
    }
    
    // Play reel battle sound based on intensity (1-4)
    new url[128];
    switch(intensity)
    {
        case 1: format(url, sizeof(url), FISHING_REEL_BATTLE_1);
        case 2: format(url, sizeof(url), FISHING_REEL_BATTLE_2);
        case 3: format(url, sizeof(url), FISHING_REEL_BATTLE_3);
        case 4: format(url, sizeof(url), FISHING_REEL_BATTLE_4);
        default: format(url, sizeof(url), FISHING_REEL_BATTLE_1);
    }
    PlayerBattleSound[playerid] = Audio_Play(playerid, url, 0.7, 0);
}

stock Play3DFishingSound(Float:x, Float:y, Float:z, const url[], Float:distance = 30.0)
{
    // Play 3D positional sound for all nearby players
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            Audio_Play3D(i, url, x, y, z, distance, 0.6, AUDIO_3D);
        }
    }
}

// Zone-based audio removed - not needed

// ============================================
// AUDIO CLEANUP
// ============================================

stock CleanupPlayerAudio(playerid)
{
    StopFishingMusic(playerid);
    StopFishingReelSound(playerid);
    Audio_StopAll(playerid);
    
    PlayerFishingMusic[playerid] = -1;
    PlayerReelSound[playerid] = -1;
}

// Selective audio cleanup - excludes specified sounds from being stopped
stock CleanupPlayerAudioExcept(playerid, bool:excludeSuccess = false)
{
    printf("[FISHING AUDIO DEBUG] CleanupPlayerAudioExcept called for player %d, excludeSuccess: %d", 
        playerid, excludeSuccess);
    
    // Stop fishing music
    StopFishingMusic(playerid);
    
    // Stop reel sound
    StopFishingReelSound(playerid);
    
    // Stop battle sound
    if(PlayerBattleSound[playerid] != -1)
    {
        printf("[FISHING AUDIO DEBUG] Stopping battle sound ID: %d", PlayerBattleSound[playerid]);
        Audio_Stop(playerid, PlayerBattleSound[playerid]);
        PlayerBattleSound[playerid] = -1;
    }
    
    // If we're not excluding success sound, stop it too
    if(!excludeSuccess && PlayerSuccessSound[playerid] != -1)
    {
        printf("[FISHING AUDIO DEBUG] Stopping success sound ID: %d", PlayerSuccessSound[playerid]);
        Audio_Stop(playerid, PlayerSuccessSound[playerid]);
        PlayerSuccessSound[playerid] = -1;
    }
    else if(excludeSuccess)
    {
        printf("[FISHING AUDIO DEBUG] Preserving success sound ID: %d", PlayerSuccessSound[playerid]);
    }
    
    // Note: We don't call Audio_StopAll here to preserve excluded sounds
    
    PlayerFishingMusic[playerid] = -1;
    PlayerReelSound[playerid] = -1;
    PlayerBattleSound[playerid] = -1;
}
