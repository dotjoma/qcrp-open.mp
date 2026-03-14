/*
    Custom Skins System - Dialog Handlers
    
    Add this to your OnDialogResponse in the main gamemode
    
    INSTRUCTIONS:
    1. Find "public OnDialogResponse" in GM_Nuron.pwn
    2. Add this code inside the switch(dialogid) block:
    
        case DIALOG_CUSTOM_SKIN_BUY: {
            if(!response) {
                DeletePVar(playerid, "BuyingSkinID");
                return 1;
            }
            
            new skinid = GetPVarInt(playerid, "BuyingSkinID");
            DeletePVar(playerid, "BuyingSkinID");
            
            new index = GetCustomSkinIndex(skinid);
            if(index == -1) return 1;
            
            new sid, bskin, vlevel, vcost;
            new bool:vipreq;
            new mfile[128], tfile[128], sname[64];
            GetCustomSkinData(index, sid, bskin, vipreq, vlevel, vcost, mfile, tfile, sname, 64);
            
            new cost = vcost;
            
            if(PlayerInfo[playerid][pCash] < cost) {
                SendClientMessage(playerid, COLOR_LIGHTRED, "You don't have enough money!");
                return 1;
            }
            
            // Deduct money
            PlayerInfo[playerid][pCash] -= cost;
            GivePlayerMoney(playerid, -cost);
            
            // Add to player_custom_skins table
            new query[256];
            mysql_format(connectionID, query, sizeof(query),
                "INSERT INTO player_custom_skins (user_id, skin_id, purchase_price) \
                VALUES (%d, %d, %d)",
                PlayerInfo[playerid][pID], skinid, cost
            );
            mysql_tquery(connectionID, query);
            
            // Save to players table (current_custom_skin column)
            mysql_format(connectionID, query, sizeof(query),
                "UPDATE players SET current_custom_skin = %d WHERE user_id = %d",
                skinid, PlayerInfo[playerid][pID]
            );
            mysql_tquery(connectionID, query);
            
            // Update in-memory
            PlayerInfo[playerid][pCustomSkin] = skinid;
            
            // Equip skin
            SetPlayerCustomSkin(playerid, skinid);
            
            new string[128], skinname[64];
            GetCustomSkinName(skinid, skinname);
            
            format(string, sizeof(string), "You purchased and equipped: %s for $%s", 
                skinname, FormatNumber(cost));
            SendClientMessage(playerid, COLOR_AQUA, string);
            
            return 1;
        }
*/
