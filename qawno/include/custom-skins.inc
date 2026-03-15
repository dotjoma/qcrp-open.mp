/*
    Custom Skins System v1.0
    
    Allows using custom character models with IDs starting from 20001+
    Works with open.mp and requires AddCharModel for custom skins
    
    Requirements:
        - MySQL (a_mysql.inc)
        - Pawn.RakNet (optional for client mod detection)
        - open.mp server with artwork.enable = true
        
    Usage:
        SetPlayerCustomSkin(playerid, 20001); // Sets custom skin ID 20001
        GetPlayerCustomSkin(playerid);        // Returns custom skin ID or -1
*/

#if defined _custom_skins_included
    #endinput
#endif
#define _custom_skins_included

// Check for required includes
#if !defined _samp_included
    #error "Please include <a_samp> before <custom-skins>"
#endif

// Check for RakNet (optional but recommended)
#if defined PAWNRAKNET_INC_
    #define CUSTOM_SKINS_USE_RAKNET
    // RakNet support enabled
#else
    // RakNet not found - mod detection disabled
#endif

// ============================================================================
// CONFIGURATION
// ============================================================================

#define CUSTOM_SKIN_START_ID        20001   // Starting ID for custom skins (open.mp requirement)
#define MAX_CUSTOM_SKINS            500     // Maximum custom skins (20001-20500)
#define CUSTOM_SKIN_FALLBACK        0       // Default fallback skin if client doesn't support

// RakNet RPC IDs
#define RPC_CUSTOM_SKIN_DETECTION   155     // Client -> Server: Mod detection
#define RPC_CUSTOM_SKIN_LOAD        153     // Server -> Client: Load skin
#define RPC_CUSTOM_SKIN_CONFIRM     154     // Client -> Server: Load confirmation

// Dialog ID (change if conflicts with your gamemode)
#if !defined DIALOG_CUSTOM_SKINS
    #define DIALOG_CUSTOM_SKINS     9050
#endif

#if !defined DIALOG_CUSTOM_SKIN_BUY
    #define DIALOG_CUSTOM_SKIN_BUY  9051
#endif

// Forward declarations
#if defined CUSTOM_SKINS_USE_RAKNET
    stock CustomSkins_OnIncomingRPC(playerid, rpcid, BitStream:bs);
#endif

// MySQL connection handle from gamemode (defined in main gamemode)
new connectionID; // Will use the global connectionID from gamemode

// ============================================================================
// PLAYER DATA
// ============================================================================

enum E_CUSTOM_SKIN_DATA {
    bool:csHasClientMod,        // Does player have custom skin client mod?
    csCurrentSkin,              // Current custom skin ID (-1 if using default)
    csRequestedSkin,            // Requested skin (for verification)
    csLastUpdate,               // Timestamp of last skin change
    csAuthToken,                // Authentication token for this session
    csClientFingerprint,        // Client fingerprint for validation
    csDetectionAttempts         // Number of detection attempts (anti-spam)
}

static PlayerCustomSkinData[MAX_PLAYERS][E_CUSTOM_SKIN_DATA];

// ============================================================================
// CUSTOM SKIN DATABASE
// ============================================================================

enum E_CUSTOM_SKIN_INFO {
    csSkinID,                   // Custom skin ID (1000+)
    csSkinName[64],             // Skin name/description
    csModelFile[128],           // DFF file name
    csTextureFile[128],         // TXD file name
    csBaseSkinID,               // Base skin ID for fallback
    bool:csRequiresVIP,         // VIP only?
    csMinLevel,                 // Minimum level required
    csCost                      // Cost to purchase (0 = free)
}

static CustomSkinInfo[MAX_CUSTOM_SKINS][E_CUSTOM_SKIN_INFO];
static TotalCustomSkins = 0;

// Accessor functions for commands file
stock GetCustomSkinData(index, &skinid, &baseskin, &bool:vip, &minlevel, &cost, modelfile[], txdfile[], name[], maxlen = 64) {
    if(index < 0 || index >= TotalCustomSkins) return 0;
    
    skinid = CustomSkinInfo[index][csSkinID];
    baseskin = CustomSkinInfo[index][csBaseSkinID];
    vip = CustomSkinInfo[index][csRequiresVIP];
    minlevel = CustomSkinInfo[index][csMinLevel];
    cost = CustomSkinInfo[index][csCost];
    
    format(modelfile, 128, "%s", CustomSkinInfo[index][csModelFile]);
    format(txdfile, 128, "%s", CustomSkinInfo[index][csTextureFile]);
    format(name, maxlen, "%s", CustomSkinInfo[index][csSkinName]);
    
    return 1;
}

// ============================================================================
// INITIALIZATION
// ============================================================================

stock CustomSkins_Init() {
    // Reset all player data
    for(new i = 0; i < MAX_PLAYERS; i++) {
        CustomSkins_ResetPlayer(i);
    }
    
    // Load custom skins from database
    mysql_tquery(connectionID, "SELECT * FROM custom_skins ORDER BY skin_id ASC", "OnLoadCustomSkins");
    
    printf("[Custom Skins] System initialized. Max skins: %d", MAX_CUSTOM_SKINS);
    return 1;
}

// ============================================================================
// PLAYER FUNCTIONS
// ============================================================================

stock CustomSkins_ResetPlayer(playerid) {
    PlayerCustomSkinData[playerid][csHasClientMod] = false;
    PlayerCustomSkinData[playerid][csCurrentSkin] = -1;
    PlayerCustomSkinData[playerid][csRequestedSkin] = -1;
    PlayerCustomSkinData[playerid][csLastUpdate] = 0;
    PlayerCustomSkinData[playerid][csAuthToken] = 0;
    PlayerCustomSkinData[playerid][csClientFingerprint] = 0;
    PlayerCustomSkinData[playerid][csDetectionAttempts] = 0;
    return 1;
}

// Generate authentication token for player
stock GenerateAuthToken(playerid) {
    // Generate pseudo-random token based on player data + time
    new token = random(999999) + gettime() + playerid * 1337;
    PlayerCustomSkinData[playerid][csAuthToken] = token;
    return token;
}

stock SetPlayerCustomSkin(playerid, skinid) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    // Check if it's a custom skin ID
    if(skinid < CUSTOM_SKIN_START_ID) {
        // Regular SA-MP skin
        SetPlayerSkin(playerid, skinid);
        PlayerCustomSkinData[playerid][csCurrentSkin] = -1;
        return 1;
    }
    
    // Check if custom skin exists
    new index = GetCustomSkinIndex(skinid);
    if(index == -1) {
        printf("[Custom Skins] ERROR: Skin ID %d not found!", skinid);
        return 0;
    }
    
    // Update player data
    PlayerCustomSkinData[playerid][csCurrentSkin] = skinid;
    PlayerCustomSkinData[playerid][csLastUpdate] = gettime();
    
    // Simply set the custom skin ID - open.mp handles the rest!
    // The client will automatically download the DFF/TXD files via AddCharModel
    SetPlayerSkin(playerid, skinid);
    
    printf("[Custom Skins] Set player %d to custom skin %d", playerid, skinid);
    
    return 1;
}

#if !defined GetPlayerCustomSkin
stock GetPlayerCustomSkin(playerid) {
    if(!IsPlayerConnected(playerid)) return -1;
    return PlayerCustomSkinData[playerid][csCurrentSkin];
}
#endif

stock bool:PlayerHasCustomSkinMod(playerid) {
    if(!IsPlayerConnected(playerid)) return false;
    return PlayerCustomSkinData[playerid][csHasClientMod];
}

stock SetPlayerHasCustomSkinMod(playerid, bool:has) {
    if(!IsPlayerConnected(playerid)) return 0;
    PlayerCustomSkinData[playerid][csHasClientMod] = has;
    return 1;
}

// ============================================================================
// CUSTOM SKIN MANAGEMENT
// ============================================================================

stock RegisterCustomSkin(skinid, const name[], const dff[], const txd[], baseskin = 0, bool:vip = false, minlevel = 0, cost = 0) {
    if(TotalCustomSkins >= MAX_CUSTOM_SKINS) {
        printf("[Custom Skins] ERROR: Maximum custom skins reached!");
        return -1;
    }
    
    if(skinid < CUSTOM_SKIN_START_ID) {
        printf("[Custom Skins] ERROR: Skin ID must be >= %d", CUSTOM_SKIN_START_ID);
        return -1;
    }
    
    new index = TotalCustomSkins;
    
    CustomSkinInfo[index][csSkinID] = skinid;
    format(CustomSkinInfo[index][csSkinName], 64, "%s", name);
    format(CustomSkinInfo[index][csModelFile], 128, "%s", dff);
    format(CustomSkinInfo[index][csTextureFile], 128, "%s", txd);
    CustomSkinInfo[index][csBaseSkinID] = baseskin;
    CustomSkinInfo[index][csRequiresVIP] = vip;
    CustomSkinInfo[index][csMinLevel] = minlevel;
    CustomSkinInfo[index][csCost] = cost;
    
    TotalCustomSkins++;
    
    printf("[Custom Skins] Registered: ID %d - %s (DFF: %s, TXD: %s)", skinid, name, dff, txd);
    return index;
}

stock GetCustomSkinIndex(skinid) {
    for(new i = 0; i < TotalCustomSkins; i++) {
        if(CustomSkinInfo[i][csSkinID] == skinid) {
            return i;
        }
    }
    return -1;
}

stock GetCustomSkinName(skinid, output[], maxlen = sizeof(output)) {
    new index = GetCustomSkinIndex(skinid);
    if(index == -1) {
        format(output, maxlen, "Unknown");
        return 0;
    }
    format(output, maxlen, "%s", CustomSkinInfo[index][csSkinName]);
    return 1;
}

stock bool:IsCustomSkinID(skinid) {
    return (skinid >= CUSTOM_SKIN_START_ID && GetCustomSkinIndex(skinid) != -1);
}

stock GetTotalCustomSkins() {
    return TotalCustomSkins;
}

// ============================================================================
// PERMISSION CHECKS
// ============================================================================

stock bool:CanPlayerUseCustomSkin(playerid, skinid) {
    if(!IsPlayerConnected(playerid)) return false;
    
    new index = GetCustomSkinIndex(skinid);
    if(index == -1) return false;
    
    // Check VIP requirement (if PlayerInfo exists in your gamemode)
    #if defined PlayerInfo
        if(CustomSkinInfo[index][csRequiresVIP] && !PlayerInfo[playerid][pVIP]) {
            return false;
        }
        
        // Check level requirement
        if(PlayerInfo[playerid][pLevel] < CustomSkinInfo[index][csMinLevel]) {
            return false;
        }
    #endif
    
    return true;
}

// ============================================================================
// DATABASE CALLBACKS
// ============================================================================

forward OnLoadCustomSkins();
public OnLoadCustomSkins() 
{
    new rows = cache_num_rows();
    
    printf("[Custom Skins] OnLoadCustomSkins called - rows: %d", rows);
    TotalCustomSkins = 0;
        
    for(new i = 0; i < rows && i < MAX_CUSTOM_SKINS; i++) {
        CustomSkinInfo[i][csSkinID] = cache_get_field_content_int(i, "skin_id");
        cache_get_field_content(i, "skin_name", CustomSkinInfo[i][csSkinName], connectionID, 64);
        cache_get_field_content(i, "model_file", CustomSkinInfo[i][csModelFile], connectionID, 128);
        cache_get_field_content(i, "texture_file", CustomSkinInfo[i][csTextureFile], connectionID, 128);
        CustomSkinInfo[i][csBaseSkinID] = cache_get_field_content_int(i, "base_skin_id");
        CustomSkinInfo[i][csRequiresVIP] = bool:cache_get_field_content_int(i, "requires_vip");
        CustomSkinInfo[i][csMinLevel] = cache_get_field_content_int(i, "min_level");
        CustomSkinInfo[i][csCost] = cache_get_field_content_int(i, "cost");
        TotalCustomSkins++;
    }
        
    printf("[Custom Skins] Loaded %d custom skins from database", TotalCustomSkins);
    
    // NOTE: Models are loaded via artconfig.txt instead of gamemode
    // This prevents "Model already in use" errors and is more efficient
    // LoadCustomSkinsWithAddCharModel(); // DISABLED - using artconfig.txt

    return 1;
}

// ============================================================================
// HOOKS
// ============================================================================

// Hook OnPlayerConnect
public OnPlayerConnect(playerid) {
    CustomSkins_ResetPlayer(playerid);
    
    #if defined CustomSkins_OnPlayerConnect
        return CustomSkins_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect CustomSkins_OnPlayerConnect
#if defined CustomSkins_OnPlayerConnect
    forward CustomSkins_OnPlayerConnect(playerid);
#endif

// Hook OnGameModeInit to register RPCs
public OnGameModeInit() {
    #if defined CUSTOM_SKINS_USE_RAKNET
        printf("[Custom Skins] RPC handlers ready (155, 154)");
    #endif
    
    #if defined CustomSkins_OnGameModeInit
        return CustomSkins_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit CustomSkins_OnGameModeInit
#if defined CustomSkins_OnGameModeInit
    forward CustomSkins_OnGameModeInit();
#endif

// Hook OnIncomingRPC to automatically detect client mod
#if defined CUSTOM_SKINS_USE_RAKNET

// Hook OnIncomingRPC to automatically detect client mod
#if defined CUSTOM_SKINS_USE_RAKNET

public OnIncomingRPC(playerid, rpcid, BitStream:bs) {
    // RPC 155 = Client mod detection packet - DISABLED (not used anymore)
    // Just ignore it and pass through
    if(rpcid == RPC_CUSTOM_SKIN_DETECTION) {
        // Silently ignore detection packets
        #if defined CustomSkins_OnIncomingRPC
            return CustomSkins_OnIncomingRPC(playerid, rpcid, bs);
        #else
            return 1;
        #endif
    }
    
    // RPC 154 = Skin load confirmation from client (SECURED)
    if(rpcid == RPC_CUSTOM_SKIN_CONFIRM) {
        
        // Read skinid as 4 bytes
        new b1, b2, b3, b4;
        BS_ReadValue(bs, PR_UINT8, b1);
        BS_ReadValue(bs, PR_UINT8, b2);
        BS_ReadValue(bs, PR_UINT8, b3);
        BS_ReadValue(bs, PR_UINT8, b4);
        new skinid = b1 + (b2 * 256) + (b3 * 65536) + (b4 * 16777216);
        
        // Read success as 4 bytes
        new s1, s2, s3, s4;
        BS_ReadValue(bs, PR_UINT8, s1);
        BS_ReadValue(bs, PR_UINT8, s2);
        BS_ReadValue(bs, PR_UINT8, s3);
        BS_ReadValue(bs, PR_UINT8, s4);
        new success = s1 + (s2 * 256) + (s3 * 65536) + (s4 * 16777216);
        
        // Read token as 4 bytes
        new t1, t2, t3, t4;
        BS_ReadValue(bs, PR_UINT8, t1);
        BS_ReadValue(bs, PR_UINT8, t2);
        BS_ReadValue(bs, PR_UINT8, t3);
        BS_ReadValue(bs, PR_UINT8, t4);
        new clientToken = t1 + (t2 * 256) + (t3 * 65536) + (t4 * 16777216);
        
        // Validate token
        new expectedToken = PlayerCustomSkinData[playerid][csAuthToken];
        if(clientToken != expectedToken) {
            printf("[Custom Skins] SECURITY: Invalid token from player %d (Got: %d, Expected: %d)", 
                playerid, clientToken, expectedToken);
            SendClientMessage(playerid, 0xFF0000FF, "[Custom Skins] Security validation failed!");
            
            #if defined CustomSkins_OnIncomingRPC
                return CustomSkins_OnIncomingRPC(playerid, rpcid, bs);
            #else
                return 1;
            #endif
        }
        
        // Validate requested skin matches
        if(skinid != PlayerCustomSkinData[playerid][csRequestedSkin]) {
            printf("[Custom Skins] SECURITY: Skin ID mismatch from player %d (Got: %d, Expected: %d)", 
                playerid, skinid, PlayerCustomSkinData[playerid][csRequestedSkin]);
            
            #if defined CustomSkins_OnIncomingRPC
                return CustomSkins_OnIncomingRPC(playerid, rpcid, bs);
            #else
                return 1;
            #endif
        }
        
        if(success) {
            printf("[Custom Skins] Player %d confirmed skin %d loaded successfully", playerid, skinid);
            
            new string[128], skinname[64];
            GetCustomSkinName(skinid, skinname);
            format(string, sizeof(string), "[Custom Skins] Skin loaded: %s (ID: %d)", skinname, skinid);
            SendClientMessage(playerid, 0x00FF00FF, string);
        } else {
            printf("[Custom Skins] Player %d failed to load skin %d", playerid, skinid);
            SendClientMessage(playerid, 0xFF6347FF, "[Custom Skins] Failed to load custom skin. Using fallback.");
            
            // Revert to fallback
            new index = GetCustomSkinIndex(skinid);
            if(index != -1) {
                SetPlayerSkin(playerid, CustomSkinInfo[index][csBaseSkinID]);
            }
        }
        
        // Clear token after use (one-time use)
        PlayerCustomSkinData[playerid][csAuthToken] = 0;
        
        #if defined CustomSkins_OnIncomingRPC
            return CustomSkins_OnIncomingRPC(playerid, rpcid, bs);
        #else
            return 1;
        #endif
    }
    
    #if defined CustomSkins_OnIncomingRPC
        return CustomSkins_OnIncomingRPC(playerid, rpcid, bs);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnIncomingRPC
    #undef OnIncomingRPC
#else
    #define _ALS_OnIncomingRPC
#endif
#define OnIncomingRPC CustomSkins_OnIncomingRPC

#endif // CUSTOM_SKINS_USE_RAKNET

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

stock ShowCustomSkinDialog(playerid, page = 0) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    new string[2048], skinname[64], temp[128];
    new itemsPerPage = 20;
    new startIndex = page * itemsPerPage;
    new endIndex = startIndex + itemsPerPage;
    
    if(endIndex > TotalCustomSkins) endIndex = TotalCustomSkins;
    
    strcat(string, "ID\tName\tLevel\tCost\n");
    
    for(new i = startIndex; i < endIndex; i++) {
        format(skinname, sizeof(skinname), "%s%s%s",
            CustomSkinInfo[i][csRequiresVIP] ? "{FFD700}[VIP] " : "",
            CustomSkinInfo[i][csSkinName],
            !CanPlayerUseCustomSkin(playerid, CustomSkinInfo[i][csSkinID]) ? " {FF0000}(Locked)" : ""
        );
        
        format(temp, sizeof(temp), "%d\t%s\t%d\t$%d\n",
            CustomSkinInfo[i][csSkinID],
            skinname,
            CustomSkinInfo[i][csMinLevel],
            CustomSkinInfo[i][csCost]
        );
        strcat(string, temp);
    }
    
    if(endIndex < TotalCustomSkins) {
        strcat(string, "\n{FFFF00}>> Next Page");
    }
    
    ShowPlayerDialog(playerid, DIALOG_CUSTOM_SKINS, DIALOG_STYLE_TABLIST_HEADERS, 
        "Custom Skins", string, "Select", "Close");
    
    return 1;
}

// Callback: Load player's saved custom skin after login
forward OnLoadPlayerCustomSkin(playerid);
public OnLoadPlayerCustomSkin(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    new rows = cache_num_rows();
    if(rows > 0) {
        new customSkinID = cache_get_field_content_int(0, "current_custom_skin", connectionID);
        
        if(customSkinID > 0) {
            // Player has a saved custom skin, equip it
            printf("[Custom Skins] Loading saved custom skin %d for player %s", customSkinID, GetPlayerNameEx(playerid));
            SetPlayerCustomSkin(playerid, customSkinID);
        }
    }
    
    return 1;
}