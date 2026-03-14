/*
    Custom Skins System - Commands
    
    Admin and player commands for managing custom skins
    Include this after custom-skins.inc
*/

// ============================================================================
// DIALOG IDS (Add to your dialog enum)
// ============================================================================

#define DIALOG_CUSTOM_SKINS         9050
#define DIALOG_CUSTOM_SKIN_BUY      9051
#define DIALOG_CUSTOM_SKIN_PREVIEW  9052
#define DIALOG_ADMIN_CUSTOM_SKINS   9053

// ============================================================================
// PLAYER COMMANDS
// ============================================================================

CMD:customskins(playerid, params[]) {
    ShowCustomSkinDialog(playerid, 0);
    return 1;
}

CMD:myskins(playerid, params[]) {
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "SELECT cs.skin_id, cs.skin_name, pcs.times_used, pcs.last_used \
        FROM player_custom_skins pcs \
        INNER JOIN custom_skins cs ON pcs.skin_id = cs.skin_id \
        WHERE pcs.user_id = %d \
        ORDER BY pcs.purchased_at DESC",
        PlayerInfo[playerid][pID]
    );
    
    mysql_tquery(connectionID, query, "OnShowPlayerSkins", "d", playerid);
    return 1;
}

CMD:removecustomskin(playerid, params[]) {
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "UPDATE players SET current_custom_skin = 0 WHERE user_id = %d",
        PlayerInfo[playerid][pID]
    );
    mysql_tquery(connectionID, query);
    
    // Update in-memory
    PlayerInfo[playerid][pCustomSkin] = 0;
    
    // Set back to regular skin
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    
    SendClientMessage(playerid, COLOR_AQUA, "[Custom Skins] Custom skin removed. Using your regular skin.");
    return 1;
}

CMD:buyskin(playerid, params[]) {
    new skinid;
    if(sscanf(params, "d", skinid)) {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /buyskin [skinid]");
    }
    
    if(!IsCustomSkinID(skinid)) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Invalid custom skin ID!");
    }
    
    new index = GetCustomSkinIndex(skinid);
    if(index == -1) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Custom skin not found!");
    }
    
    // Check if already owned
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "SELECT id FROM player_custom_skins WHERE user_id = %d AND skin_id = %d",
        PlayerInfo[playerid][pID], skinid
    );
    
    mysql_tquery(connectionID, query, "OnCheckSkinOwnership", "dd", playerid, skinid);
    return 1;
}

CMD:skinstats(playerid, params[]) {
    new targetid = playerid;
    
    if(sscanf(params, "u", targetid)) {
        targetid = playerid;
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Player not connected!");
    }
    
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "SELECT COUNT(*) as total_skins, SUM(times_used) as total_uses \
        FROM player_custom_skins \
        WHERE user_id = %d",
        PlayerInfo[targetid][pID]
    );
    
    mysql_tquery(connectionID, query, "OnShowSkinStats", "dd", playerid, targetid);
    return 1;
}

// ============================================================================
// ADMIN COMMANDS
// ============================================================================

CMD:givecustomskin(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] < 5) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "You don't have permission to use this command!");
    }
    
    new targetid, skinid;
    if(sscanf(params, "ud", targetid, skinid)) {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /givecustomskin [playerid] [skinid]");
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Player not connected!");
    }
    
    if(!IsCustomSkinID(skinid)) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Invalid custom skin ID!");
    }
    
    SetPlayerCustomSkin(targetid, skinid);
    
    new string[128], skinname[64];
    GetCustomSkinName(skinid, skinname);
    
    format(string, sizeof(string), "Admin %s set your skin to: %s (ID: %d)", GetRPName(playerid), skinname, skinid);
    SendClientMessage(targetid, COLOR_AQUA, string);
    
    format(string, sizeof(string), "You set %s's skin to: %s (ID: %d)", GetRPName(targetid), skinname, skinid);
    SendClientMessage(playerid, COLOR_AQUA, string);
    
    return 1;
}

CMD:giveplayerskin(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] < 6) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "You don't have permission to use this command!");
    }
    
    new targetid, skinid;
    if(sscanf(params, "ud", targetid, skinid)) {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /giveplayerskin [playerid] [skinid] - Gives ownership");
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Player not connected!");
    }
    
    if(!IsCustomSkinID(skinid)) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Invalid custom skin ID!");
    }
    
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "INSERT IGNORE INTO player_custom_skins (user_id, skin_id, purchase_price) \
        VALUES (%d, %d, 0)",
        PlayerInfo[targetid][pID], skinid
    );
    
    mysql_tquery(connectionID, query, "OnAdminGiveSkin", "ddd", playerid, targetid, skinid);
    return 1;
}

CMD:reloadcustomskins(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] < 6) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "You don't have permission to use this command!");
    }
    
    CustomSkins_Init();
    
    SendClientMessage(playerid, COLOR_AQUA, "[Custom Skins] System reloaded from database!");
    
    new string[128];
    format(string, sizeof(string), "[Custom Skins] Total skins loaded: %d", GetTotalCustomSkins());
    SendClientMessage(playerid, COLOR_YELLOW, string);
    
    return 1;
}

CMD:customskininfo(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] < 3) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "You don't have permission to use this command!");
    }
    
    new skinid;
    if(sscanf(params, "d", skinid)) {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /customskininfo [skinid]");
    }
    
    new index = GetCustomSkinIndex(skinid);
    if(index == -1) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Custom skin not found!");
    }
    
    new string[256], skinname[64];
    GetCustomSkinName(skinid, skinname);
    
    SendClientMessage(playerid, COLOR_AQUA, "__________ Custom Skin Info __________");
    
    format(string, sizeof(string), "ID: %d | Name: %s", skinid, skinname);
    SendClientMessage(playerid, COLOR_WHITE, string);
    
    new modelfile[128], txdfile[128], baseskin, vip, minlevel, cost;
    new bool:isVip;
    GetCustomSkinData(index, skinid, baseskin, isVip, minlevel, cost, modelfile, txdfile, skinname, 64);
    
    format(string, sizeof(string), "Model: %s | Texture: %s", modelfile, txdfile);
    SendClientMessage(playerid, COLOR_WHITE, string);
    
    format(string, sizeof(string), "Fallback Skin: %d | VIP: %s | Min Level: %d", 
        baseskin,
        isVip ? "Yes" : "No",
        minlevel
    );
    SendClientMessage(playerid, COLOR_WHITE, string);
    
    format(string, sizeof(string), "Cost: $%s", FormatNumber(cost));
    SendClientMessage(playerid, COLOR_WHITE, string);
    
    return 1;
}

CMD:listcustomskins(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] < 3) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "You don't have permission to use this command!");
    }
    
    new string[128];
    format(string, sizeof(string), "[Custom Skins] Total registered: %d", GetTotalCustomSkins());
    SendClientMessage(playerid, COLOR_AQUA, string);
    
    for(new i = 0; i < GetTotalCustomSkins(); i++) {
        new sid, bskin, vlevel, vcost;
        new bool:vipreq;
        new mfile[128], tfile[128], sname[64];
        GetCustomSkinData(i, sid, bskin, vipreq, vlevel, vcost, mfile, tfile, sname, 64);
        
        format(string, sizeof(string), "ID %d: %s %s(Level %d, $%s)",
            sid,
            sname,
            vipreq ? "{FFD700}[VIP] " : "",
            vlevel,
            FormatNumber(vcost)
        );
        SendClientMessage(playerid, COLOR_WHITE, string);
    }
    
    return 1;
}

// ============================================================================
// DATABASE CALLBACKS
// ============================================================================

forward OnShowPlayerSkins(playerid);
public OnShowPlayerSkins(playerid) {
    new rows = cache_num_rows();
    
    if(rows == 0) {
        SendClientMessage(playerid, COLOR_LIGHTRED, "You don't own any custom skins yet!");
        SendClientMessage(playerid, COLOR_YELLOW, "Use /customskins to browse available skins.");
        return 1;
    }
    
    new string[256], skinid, skinname[64], times_used;
    
    SendClientMessage(playerid, COLOR_AQUA, "__________ Your Custom Skins __________");
    
    for(new i = 0; i < rows; i++) {
        skinid = cache_get_field_content_int(i, "skin_id", connectionID);
        cache_get_field_content(i, "skin_name", skinname, connectionID, 64);
        times_used = cache_get_field_content_int(i, "times_used", connectionID);
        
        format(string, sizeof(string), "ID %d: %s (Used %d times)", skinid, skinname, times_used);
        SendClientMessage(playerid, COLOR_WHITE, string);
    }
    
    SendClientMessage(playerid, COLOR_YELLOW, "Use /customskins to change your skin.");
    
    return 1;
}

forward OnCheckSkinOwnership(playerid, skinid);
public OnCheckSkinOwnership(playerid, skinid) {
    new rows = cache_num_rows();
    
    if(rows > 0) {
        SendClientMessage(playerid, COLOR_LIGHTRED, "You already own this skin!");
        SendClientMessage(playerid, COLOR_YELLOW, "Use /customskins to equip it.");
        return 1;
    }
    
    // Check permissions and cost
    new index = GetCustomSkinIndex(skinid);
    
    // Get skin data
    new sid, bskin, vlevel, vcost;
    new bool:vipreq;
    new mfile[128], tfile[128], sname[64];
    GetCustomSkinData(index, sid, bskin, vipreq, vlevel, vcost, mfile, tfile, sname, 64);
    
    if(!CanPlayerUseCustomSkin(playerid, skinid)) {
        SendClientMessage(playerid, COLOR_LIGHTRED, "You don't meet the requirements for this skin!");
        
        if(vipreq) {
            SendClientMessage(playerid, COLOR_YELLOW, "This skin requires VIP membership.");
        }
        
        if(PlayerInfo[playerid][pLevel] < vlevel) {
            new string[128];
            format(string, sizeof(string), "Required level: %d (You are level %d)", 
                vlevel, PlayerInfo[playerid][pLevel]);
            SendClientMessage(playerid, COLOR_YELLOW, string);
        }
        
        return 1;
    }
    
    new cost = vcost;
    
    if(PlayerInfo[playerid][pCash] < cost) {
        new string[128];
        format(string, sizeof(string), "You need $%s to buy this skin! (You have: $%s)", 
            FormatNumber(cost), FormatNumber(PlayerInfo[playerid][pCash]));
        SendClientMessage(playerid, COLOR_LIGHTRED, string);
        return 1;
    }
    
    // Show confirmation dialog
    new dialogStr[256], skinname[64];
    GetCustomSkinName(skinid, skinname);
    
    format(dialogStr, sizeof(dialogStr), 
        "Skin: %s\nID: %d\nCost: $%s\n\nDo you want to purchase this skin?",
        skinname, skinid, FormatNumber(cost)
    );
    
    SetPVarInt(playerid, "BuyingSkinID", skinid);
    ShowPlayerDialog(playerid, DIALOG_CUSTOM_SKIN_BUY, DIALOG_STYLE_MSGBOX, 
        "Purchase Custom Skin", dialogStr, "Buy", "Cancel");
    
    return 1;
}

forward OnAdminGiveSkin(adminid, targetid, skinid);
public OnAdminGiveSkin(adminid, targetid, skinid) {
    if(!IsPlayerConnected(adminid) || !IsPlayerConnected(targetid)) return 1;
    
    new string[128], skinname[64];
    GetCustomSkinName(skinid, skinname);
    
    format(string, sizeof(string), "Admin %s gave you custom skin: %s (ID: %d)", 
        GetRPName(adminid), skinname, skinid);
    SendClientMessage(targetid, COLOR_AQUA, string);
    
    format(string, sizeof(string), "You gave %s custom skin: %s (ID: %d)", 
        GetRPName(targetid), skinname, skinid);
    SendClientMessage(adminid, COLOR_AQUA, string);
    
    return 1;
}

forward OnShowSkinStats(playerid, targetid);
public OnShowSkinStats(playerid, targetid) {
    new rows = cache_num_rows();
    
    if(rows == 0) {
        SendClientMessage(playerid, COLOR_LIGHTRED, "No skin data found for this player.");
        return 1;
    }
    
    new total_skins, total_uses;
    total_skins = cache_get_field_content_int(0, "total_skins", connectionID);
    total_uses = cache_get_field_content_int(0, "total_uses", connectionID);
    
    new string[256];
    
    if(targetid == playerid) {
        format(string, sizeof(string), "Your Skin Stats: %d skins owned | %d total uses", 
            total_skins, total_uses);
    } else {
        format(string, sizeof(string), "%s's Skin Stats: %d skins owned | %d total uses", 
            GetRPName(targetid), total_skins, total_uses);
    }
    
    SendClientMessage(playerid, COLOR_AQUA, string);
    
    return 1;
}

forward OnSelectCustomSkin(playerid);
public OnSelectCustomSkin(playerid) {
    new rows = cache_num_rows();
    new skinid = GetPVarInt(playerid, "SelectedSkinID");
    DeletePVar(playerid, "SelectedSkinID");
    
    if(rows > 0) {
        // Player owns this skin, equip it
        SetPlayerCustomSkin(playerid, skinid);
        
        // Save to players table (current_custom_skin column)
        new query[256];
        mysql_format(connectionID, query, sizeof(query),
            "UPDATE players SET current_custom_skin = %d WHERE user_id = %d",
            skinid, PlayerInfo[playerid][pID]
        );
        mysql_tquery(connectionID, query);
        
        // Also update in-memory
        PlayerInfo[playerid][pCustomSkin] = skinid;
        
        // Update times_used in player_custom_skins
        mysql_format(connectionID, query, sizeof(query),
            "UPDATE player_custom_skins SET times_used = times_used + 1, last_used = NOW() \
            WHERE user_id = %d AND skin_id = %d",
            PlayerInfo[playerid][pID], skinid
        );
        mysql_tquery(connectionID, query);
        
        new string[128], skinname[64];
        GetCustomSkinName(skinid, skinname);
        format(string, sizeof(string), "You equipped: %s (ID: %d)", skinname, skinid);
        SendClientMessage(playerid, COLOR_AQUA, string);
    } else {
        // Player doesn't own this skin, show buy dialog
        new index = GetCustomSkinIndex(skinid);
        if(index == -1) return 1;
        
        new sid, bskin, vlevel, vcost;
        new bool:vipreq;
        new mfile[128], tfile[128], sname[64];
        GetCustomSkinData(index, sid, bskin, vipreq, vlevel, vcost, mfile, tfile, sname, 64);
        
        if(!CanPlayerUseCustomSkin(playerid, skinid)) {
            SendClientMessage(playerid, COLOR_LIGHTRED, "You don't meet the requirements for this skin!");
            
            if(vipreq) {
                SendClientMessage(playerid, COLOR_YELLOW, "This skin requires VIP membership.");
            }
            
            if(PlayerInfo[playerid][pLevel] < vlevel) {
                new string[128];
                format(string, sizeof(string), "Required level: %d (You are level %d)", 
                    vlevel, PlayerInfo[playerid][pLevel]);
                SendClientMessage(playerid, COLOR_YELLOW, string);
            }
            
            return 1;
        }
        
        new cost = vcost;
        
        if(PlayerInfo[playerid][pCash] < cost) {
            new string[128];
            format(string, sizeof(string), "You need $%s to buy this skin! (You have: $%s)", 
                FormatNumber(cost), FormatNumber(PlayerInfo[playerid][pCash]));
            SendClientMessage(playerid, COLOR_LIGHTRED, string);
            return 1;
        }
        
        // Show confirmation dialog
        new dialogStr[256], skinname[64];
        GetCustomSkinName(skinid, skinname);
        
        format(dialogStr, sizeof(dialogStr), 
            "Skin: %s\nID: %d\nCost: $%s\n\nDo you want to purchase this skin?",
            skinname, skinid, FormatNumber(cost)
        );
        
        SetPVarInt(playerid, "BuyingSkinID", skinid);
        ShowPlayerDialog(playerid, DIALOG_CUSTOM_SKIN_BUY, DIALOG_STYLE_MSGBOX, 
            "Purchase Custom Skin", dialogStr, "Buy", "Cancel");
    }
    
    return 1;
}
