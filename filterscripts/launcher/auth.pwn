/*
    QcRP Launcher Authentication System
    
    This filterscript validates launcher sessions via backend API when players connect.
    Requires: Requests (HTTP plugin) - https://github.com/Southclaws/pawn-requests
    
    Features:
    - API-based session validation (secure)
    - HWID ban checking via API
    - Real-time validation
    - Security logging
    
    IMPORTANT: Players must launch via launcher which passes HWID as player name
*/

#include <a_samp>
#include <requests>

#pragma warning disable 239

// Configuration
#define API_BASE_URL            "https://qcrp-backend.vercel.app"
#define LAUNCHER_REQUIRED       true
#define VALIDATION_TIMEOUT      10      // Seconds
#define HEARTBEAT_CHECK_INTERVAL 30     // Check every 30 seconds

// Forward declarations
forward OnSessionValidated(Request:id, E_HTTP_STATUS:status, Node:node);
forward KickPlayer(playerid);
forward CheckPlayerHeartbeat();

// Player data
enum E_PLAYER_AUTH {
    bool:pAuthValidated,
    pAuthHWID[65],
    pAuthTimer,
    Request:pAuthRequest
}
new PlayerAuth[MAX_PLAYERS][E_PLAYER_AUTH];

// HWID is passed as player name by launcher (no file needed)

// API Client
new RequestsClient:g_ApiClient;

public OnFilterScriptInit() {
    print("\n========================================");
    print(" QcRP Launcher Authentication System");
    print(" Version: 2.0.0 (API-based)");
    print(" Backend: https://qcrp-backend.vercel.app");
    print("========================================\n");
    
    // Initialize API client
    g_ApiClient = RequestsClient(API_BASE_URL);
    
    // Start heartbeat checker (runs every 60 seconds)
    SetTimer("CheckPlayerHeartbeat", HEARTBEAT_CHECK_INTERVAL * 1000, true);
    
    return 1;
}

public OnFilterScriptExit() {
    return 1;
}

public OnPlayerConnect(playerid)
{
    printf("[AUTH DEBUG] ========== PLAYER CONNECT ==========");
    printf("[AUTH DEBUG] Player ID: %d", playerid);
    
    // Reset auth data
    PlayerAuth[playerid][pAuthValidated] = false;
    PlayerAuth[playerid][pAuthHWID][0] = EOS;
    PlayerAuth[playerid][pAuthRequest] = Request:-1;
    
    // Show authentication message
    SendClientMessage(playerid, 0xFFFFFFFF, "QcRP Server - Authentication");
    SendClientMessage(playerid, 0xFFFFFFFF, "Validating your session...");
    SendClientMessage(playerid, 0xFFFFFFFF, "Please wait...");

    // Get player info
    new name[MAX_PLAYER_NAME];
    new ip[16];
    GetPlayerName(playerid, name, sizeof(name));
    GetPlayerIp(playerid, ip, sizeof(ip));
    
    printf("[AUTH DEBUG] Player name: '%s'", name);
    printf("[AUTH DEBUG] Player IP: '%s'", ip);
    printf("[AUTH DEBUG] Validating session with backend...");
    printf("[AUTH DEBUG] ========================================");
    
    // Validate session with backend API (using IP address)
    ValidatePlayerSession(playerid);

    // Set timeout for authentication
    PlayerAuth[playerid][pAuthTimer] = SetTimerEx("KickPlayer", VALIDATION_TIMEOUT * 1000, false, "i", playerid);

    return 1;
}

// Removed CheckPlayerHWID - no longer needed since HWID comes from player name

public OnPlayerDisconnect(playerid, reason) {
    // Kill timer if exists
    if(PlayerAuth[playerid][pAuthTimer]) {
        KillTimer(PlayerAuth[playerid][pAuthTimer]);
        PlayerAuth[playerid][pAuthTimer] = 0;
    }
    
    // Reset request handle
    PlayerAuth[playerid][pAuthRequest] = Request:-1;
    
    return 1;
}

// Validate session via backend API (check if IP has active session)
ValidatePlayerSession(playerid) {
    new ip[16];
    GetPlayerIp(playerid, ip, sizeof(ip));
    
    // Build JSON payload with IP address
    new Node:json = JsonObject(
        "ip", JsonString(ip)
    );
    
    // Make API request to check if this IP has valid active session
    new Request:request = RequestJSON(
        g_ApiClient,
        "/api/auth/validate-session",
        HTTP_METHOD_POST,
        "OnSessionValidated",
        json,
        RequestHeaders("Content-Type", "application/json")
    );
    
    PlayerAuth[playerid][pAuthRequest] = request;
    
    printf("[AUTH] Validating session for player %d (IP: %s)", playerid, ip);
}

// Callback when API responds
public OnSessionValidated(Request:id, E_HTTP_STATUS:status, Node:node) {
    // Find which player this request belongs to
    new playerid = INVALID_PLAYER_ID;
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(PlayerAuth[i][pAuthRequest] == id) {
            playerid = i;
            break;
        }
    }
    
    if(playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid)) return;
    
    PlayerAuth[playerid][pAuthRequest] = Request:-1;
    
    // Check if this is initial auth or heartbeat check
    new bool:isInitialAuth = !PlayerAuth[playerid][pAuthValidated];
    
    // Check HTTP status
    if(status != HTTP_STATUS_OK) {
        printf("[AUTH] API error for player %d: HTTP %d", playerid, _:status);
        
        if(isInitialAuth) {
            SendClientMessage(playerid, 0xFF0000FF, "[QcRP Server] Authentication server error!");
            SendClientMessage(playerid, 0xFFFFFFFF, "Please try again later or contact support.");
            
            // Kill timer and kick after 2 seconds (so player can see messages)
            if(PlayerAuth[playerid][pAuthTimer]) {
                KillTimer(PlayerAuth[playerid][pAuthTimer]);
            }
            PlayerAuth[playerid][pAuthTimer] = SetTimerEx("KickPlayer", 2000, false, "i", playerid);
        }
        return;
    }
    
    // Parse JSON response
    new bool:valid;
    new error[64];
    new hwid[65];
    
    new ret;
    ret = JsonGetBool(node, "valid", valid);
    printf("[AUTH DEBUG] JsonGetBool('valid') returned: %d, value: %d", ret, valid);
    
    ret = JsonGetString(node, "error", error, sizeof(error));
    printf("[AUTH DEBUG] JsonGetString('error') returned: %d, value: '%s'", ret, error);
    
    ret = JsonGetString(node, "hwid", hwid, sizeof(hwid));
    printf("[AUTH DEBUG] JsonGetString('hwid') returned: %d, value: '%s'", ret, hwid);
    
    printf("[AUTH DEBUG] ========================================");
    
    if(!valid) {
        printf("[AUTH] Session validation failed for player %d: %s", playerid, error);
        
        SendClientMessage(playerid, 0xFF0000FF, "[QcRP Server] Authentication failed!");
        
        if(strcmp(error, "BANNED", true) == 0) {
            new reason[128];
            JsonGetString(node, "reason", reason, sizeof(reason));
            new message[256];
            format(message, sizeof(message), "[QcRP Server] You are banned: %s", reason);
            SendClientMessage(playerid, 0xFFFFFFFF, message);
        } else if(strcmp(error, "NO_SESSION", true) == 0 || strcmp(error, "SESSION_EXPIRED", true) == 0) {
            SendClientMessage(playerid, 0xFFFFFFFF, "[QcRP Server] No active session found.");
            SendClientMessage(playerid, 0xFFFFFFFF, "Please launch through QcRP Launcher.");
        } else if(strcmp(error, "LAUNCHER_NOT_RUNNING", true) == 0) {
            SendClientMessage(playerid, 0xFFFFFFFF, "[QcRP Server] Launcher is not running!");
            SendClientMessage(playerid, 0xFFFFFFFF, "Please keep the launcher open while playing.");
        } else {
            new message[256];
            format(message, sizeof(message), "[QcRP Server] Error: %s", error);
            SendClientMessage(playerid, 0xFFFFFFFF, message);
        }
        
        // Mark player as no longer authenticated
        PlayerAuth[playerid][pAuthValidated] = false;
        
        // Kill existing timer if any
        if(PlayerAuth[playerid][pAuthTimer]) {
            KillTimer(PlayerAuth[playerid][pAuthTimer]);
        }
        
        // Set new timer to kick player (works for both initial auth and heartbeat checks)
        PlayerAuth[playerid][pAuthTimer] = SetTimerEx("KickPlayer", 200, false, "i", playerid);
        return;
    }
    
    // Store HWID from backend response
    format(PlayerAuth[playerid][pAuthHWID], 65, "%s", hwid);
    
    // Success! Player is authenticated
    PlayerAuth[playerid][pAuthValidated] = true;
    
    // Only do initial setup on first authentication, not on heartbeat checks
    if(isInitialAuth) {
        // Kill timeout timer
        if(PlayerAuth[playerid][pAuthTimer]) {
            KillTimer(PlayerAuth[playerid][pAuthTimer]);
            PlayerAuth[playerid][pAuthTimer] = 0;
        }
        
        // Notify player
        SendClientMessage(playerid, 0x00FF00FF, "[QcRP Server] Authentication successful!");
        SendClientMessage(playerid, 0xFFFFFFFF, "Welcome to Quezon City Roleplay: Reborn!");
        
        printf("[AUTH] Player %d authenticated successfully (HWID: %s)", playerid, PlayerAuth[playerid][pAuthHWID]);
        
        // Call gamemode callback to initialize player systems (ONLY on initial auth)
        CallRemoteFunction("OnPlayerAuthenticated", "i", playerid);
    } else {
        // This is a heartbeat check - just log it
        printf("[AUTH] Heartbeat check passed for player %d", playerid);
    }
}

public KickPlayer(playerid) {
    if(IsPlayerConnected(playerid) && !PlayerAuth[playerid][pAuthValidated]) {
        SendClientMessage(playerid, 0xFF0000FF, "[QcRP Server] Authentication timeout!");
        Kick(playerid);
    }
}

// Check all connected players' launcher heartbeat
public CheckPlayerHeartbeat() {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && PlayerAuth[i][pAuthValidated]) {
            // Re-validate session to check if launcher is still running
            ValidatePlayerSession(i);
        }
    }
}

// Public functions for gamemode
stock bool:IsPlayerAuthenticated(playerid) {
    return PlayerAuth[playerid][pAuthValidated];
}

stock GetPlayerHWID(playerid, dest[], maxlen = sizeof(dest)) {
    format(dest, maxlen, "%s", PlayerAuth[playerid][pAuthHWID]);
}
