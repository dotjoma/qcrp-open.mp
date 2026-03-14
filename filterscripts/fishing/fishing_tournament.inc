/*
    FISHING RPG SYSTEM - TOURNAMENT MODULE
    Server-wide fishing events and competitions
*/

#if defined _fishing_tournament_included
    #endinput
#endif
#define _fishing_tournament_included

// ============================================
// TOURNAMENT MANAGEMENT
// ============================================

stock StartFishingTournament(type, duration)
{
    if(TournamentData[tournamentActive])
    {
        return 0; // Tournament already active
    }
    
    TournamentData[tournamentActive] = true;
    TournamentData[tournamentType] = type;
    TournamentData[tournamentStartTime] = gettime();
    TournamentData[tournamentEndTime] = gettime() + duration;
    TournamentData[tournamentWinnerID] = -1;
    format(TournamentData[tournamentWinnerName], 24, "None");
    TournamentData[tournamentWinnerScore] = 0.0;
    
    // Reset all player scores
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        TournamentPlayerScore[i] = 0.0;
        TournamentPlayerCaught[i] = 0;
    }
    
    // Announce tournament
    new string[256];
    new typeName[32];
    
    switch(type)
    {
        case TOURNAMENT_BIGGEST: format(typeName, sizeof(typeName), "Biggest Fish");
        case TOURNAMENT_MOST: format(typeName, sizeof(typeName), "Most Fish");
        case TOURNAMENT_RAREST: format(typeName, sizeof(typeName), "Rarest Fish");
    }
    
    format(string, sizeof(string), 
        "{F39C12}╔════════════════════════════════════╗");
    SendClientMessageToAll(-1, string);
    
    SendClientMessageToAll(-1, 
        "{F39C12}║ {FFFFFF}FISHING TOURNAMENT STARTED!");
    
    format(string, sizeof(string), 
        "{F39C12}║ {FFFFFF}Type: {F39C12}%s", typeName);
    SendClientMessageToAll(-1, string);
    
    format(string, sizeof(string), 
        "{F39C12}║ {FFFFFF}Duration: {F39C12}%d minutes", duration / 60);
    SendClientMessageToAll(-1, string);
    
    SendClientMessageToAll(-1, 
        "{F39C12}║ {FFFFFF}Start fishing to compete!");
    
    format(string, sizeof(string), 
        "{F39C12}╚════════════════════════════════════╝");
    SendClientMessageToAll(-1, string);
    
    // Set timer to end tournament
    new timerName[32];
    format(timerName, sizeof(timerName), "EndFishingTournament");
    SetTimerEx(timerName, duration * 1000, false, "");
    
    return 1;
}

forward EndFishingTournament();
public EndFishingTournament()
{
    if(!TournamentData[tournamentActive])
        return;
    
    // Find winner
    new winnerID = -1;
    new Float:winnerScore = 0.0;
    
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        
        new Float:playerScore = 0.0;
        
        switch(TournamentData[tournamentType])
        {
            case TOURNAMENT_BIGGEST:
            {
                playerScore = TournamentPlayerScore[i]; // Biggest fish weight
            }
            case TOURNAMENT_MOST:
            {
                playerScore = float(TournamentPlayerCaught[i]); // Total caught
            }
            case TOURNAMENT_RAREST:
            {
                playerScore = TournamentPlayerScore[i]; // Rarity score
            }
        }
        
        if(playerScore > winnerScore)
        {
            winnerScore = playerScore;
            winnerID = i;
        }
    }
    
    // Announce winner
    new string[256];
    
    format(string, sizeof(string), 
        "{F39C12}╔════════════════════════════════════╗");
    SendClientMessageToAll(-1, string);
    
    SendClientMessageToAll(-1, 
        "{F39C12}║ {FFFFFF}FISHING TOURNAMENT ENDED!");
    
    if(winnerID != -1)
    {
        TournamentData[tournamentWinnerID] = winnerID;
        GetPlayerName(winnerID, TournamentData[tournamentWinnerName], 24);
        TournamentData[tournamentWinnerScore] = winnerScore;
        
        format(string, sizeof(string), 
            "{F39C12}║ {FFFFFF}Winner: {F39C12}%s", TournamentData[tournamentWinnerName]);
        SendClientMessageToAll(-1, string);
        
        switch(TournamentData[tournamentType])
        {
            case TOURNAMENT_BIGGEST:
            {
                format(string, sizeof(string), 
                    "{F39C12}║ {FFFFFF}Biggest Fish: {F39C12}%.2fkg", winnerScore);
            }
            case TOURNAMENT_MOST:
            {
                format(string, sizeof(string), 
                    "{F39C12}║ {FFFFFF}Total Caught: {F39C12}%d fish", floatround(winnerScore));
            }
            case TOURNAMENT_RAREST:
            {
                format(string, sizeof(string), 
                    "{F39C12}║ {FFFFFF}Rarity Score: {F39C12}%.0f points", winnerScore);
            }
        }
        SendClientMessageToAll(-1, string);
        
        // Give rewards
        GiveTournamentRewards(winnerID);
    }
    else
    {
        SendClientMessageToAll(-1, 
            "{F39C12}║ {FFFFFF}No winner - no one participated!");
    }
    
    format(string, sizeof(string), 
        "{F39C12}╚════════════════════════════════════╝");
    SendClientMessageToAll(-1, string);
    
    TournamentData[tournamentActive] = false;
}


stock UpdateTournamentScore(playerid, Float:fishWeight, fish_rarity)
{
    #pragma unused fish_rarity
    if(!TournamentData[tournamentActive])
        return;
    
    TournamentPlayerCaught[playerid]++;
    
    switch(TournamentData[tournamentType])
    {
        case TOURNAMENT_BIGGEST:
        {
            // Track biggest fish
            if(fishWeight > TournamentPlayerScore[playerid])
            {
                TournamentPlayerScore[playerid] = fishWeight;
                
                new string[128];
                format(string, sizeof(string), 
                    "{F39C12}[TOURNAMENT]{FFFFFF} New personal best: %.2fkg!", fishWeight);
                SendClientMessage(playerid, -1, string);
            }
        }
        
        case TOURNAMENT_MOST:
        {
            // Count total fish
            TournamentPlayerScore[playerid] = float(TournamentPlayerCaught[playerid]);
            
            new string[128];
            format(string, sizeof(string), 
                "{F39C12}[TOURNAMENT]{FFFFFF} Total caught: %d fish", TournamentPlayerCaught[playerid]);
            SendClientMessage(playerid, -1, string);
        }
        
        case TOURNAMENT_RAREST:
        {
            // Score based on rarity
            new rarityPoints = 0;
            switch(fish_rarity)
            {
                case RARITY_COMMON: rarityPoints = 1;
                case RARITY_UNCOMMON: rarityPoints = 5;
                case RARITY_RARE: rarityPoints = 15;
                case RARITY_LEGENDARY: rarityPoints = 50;
            }
            
            TournamentPlayerScore[playerid] += float(rarityPoints);
            
            new string[128];
            format(string, sizeof(string), 
                "{F39C12}[TOURNAMENT]{FFFFFF} +%d points! Total: %.0f points", 
                rarityPoints, TournamentPlayerScore[playerid]);
            SendClientMessage(playerid, -1, string);
        }
    }
}

stock GiveTournamentRewards(playerid)
{
    // Money reward
    new moneyReward = 50000;
    CallRemoteFunction("GivePlayerCash", "ii", playerid, moneyReward);
    
    // Token reward
    new tokenReward = 200;
    PlayerFishingData[playerid][pFishingTokens] += tokenReward;
    
    // Special bait reward
    PlayerFishingData[playerid][pFishingBaitAmount] += 50;
    
    new string[256];
    
    SendClientMessage(playerid, 0x2ECC71FF, "═══════════════════════════════════");
    SendClientMessage(playerid, -1, "{2ECC71}[TOURNAMENT REWARDS]");
    
    format(string, sizeof(string), 
        "{FFFFFF}• Money: {2ECC71}$%d", moneyReward);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}• Fishing Tokens: {F39C12}%d", tokenReward);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}• Special Bait: {3498DB}50 units");
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(playerid, 0x2ECC71FF, "═══════════════════════════════════");
    
    SavePlayerFishingData(playerid);
}

// ============================================
// TOURNAMENT COMMANDS
// ============================================

CMD:starttournament(playerid, params[])
{
    // Admin only
    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "You don't have permission!");
        return 1;
    }
    
    new type, duration;
    if(sscanf(params, "dd", type, duration))
    {
        SendClientMessage(playerid, -1, "Usage: /starttournament [type] [duration in minutes]");
        SendClientMessage(playerid, -1, "Types: 0=Biggest Fish, 1=Most Fish, 2=Rarest Fish");
        return 1;
    }
    
    if(type < 0 || type > 2)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "Invalid type! Use 0-2");
        return 1;
    }
    
    if(duration < 1 || duration > 60)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "Duration must be between 1-60 minutes");
        return 1;
    }
    
    if(StartFishingTournament(type, duration * 60))
    {
        new string[128];
        format(string, sizeof(string), 
            "{2ECC71}[ADMIN]{FFFFFF} You started a fishing tournament!");
        SendClientMessage(playerid, -1, string);
    }
    else
    {
        SendClientMessage(playerid, 0xE74C3CFF, "A tournament is already active!");
    }
    
    return 1;
}

CMD:tournamentstatus(playerid, params[])
{
    if(!TournamentData[tournamentActive])
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[TOURNAMENT]{FFFFFF} No tournament is currently active!");
        return 1;
    }
    
    new string[256];
    new timeLeft = TournamentData[tournamentEndTime] - gettime();
    new minutesLeft = timeLeft / 60;
    new secondsLeft = timeLeft % 60;
    
    SendClientMessage(playerid, 0xF39C12FF, "═══════════════════════════════════");
    SendClientMessage(playerid, -1, "{F39C12}[FISHING TOURNAMENT]");
    
    new typeName[32];
    switch(TournamentData[tournamentType])
    {
        case TOURNAMENT_BIGGEST: format(typeName, sizeof(typeName), "Biggest Fish");
        case TOURNAMENT_MOST: format(typeName, sizeof(typeName), "Most Fish");
        case TOURNAMENT_RAREST: format(typeName, sizeof(typeName), "Rarest Fish");
    }
    
    format(string, sizeof(string), 
        "{FFFFFF}Type: {F39C12}%s", typeName);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}Time Left: {F39C12}%02d:%02d", minutesLeft, secondsLeft);
    SendClientMessage(playerid, -1, string);
    
    // Show player's current standing
    switch(TournamentData[tournamentType])
    {
        case TOURNAMENT_BIGGEST:
        {
            format(string, sizeof(string), 
                "{FFFFFF}Your Best: {3498DB}%.2fkg", TournamentPlayerScore[playerid]);
        }
        case TOURNAMENT_MOST:
        {
            format(string, sizeof(string), 
                "{FFFFFF}Your Total: {3498DB}%d fish", TournamentPlayerCaught[playerid]);
        }
        case TOURNAMENT_RAREST:
        {
            format(string, sizeof(string), 
                "{FFFFFF}Your Score: {3498DB}%.0f points", TournamentPlayerScore[playerid]);
        }
    }
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(playerid, 0xF39C12FF, "═══════════════════════════════════");
    
    return 1;
}

CMD:tournamentleaders(playerid, params[])
{
    if(!TournamentData[tournamentActive])
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[TOURNAMENT]{FFFFFF} No tournament is currently active!");
        return 1;
    }
    
    // Create leaderboard
    new leaders[MAX_PLAYERS][2]; // [playerid][score]
    new leaderCount = 0;
    
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(TournamentPlayerScore[i] == 0.0 && TournamentPlayerCaught[i] == 0) continue;
        
        leaders[leaderCount][0] = i;
        leaders[leaderCount][1] = floatround(TournamentPlayerScore[i] * 100.0); // Store as int for sorting
        leaderCount++;
    }
    
    // Sort leaders (bubble sort)
    for(new i = 0; i < leaderCount - 1; i++)
    {
        for(new j = 0; j < leaderCount - i - 1; j++)
        {
            if(leaders[j][1] < leaders[j + 1][1])
            {
                new tempID = leaders[j][0];
                new tempScore = leaders[j][1];
                leaders[j][0] = leaders[j + 1][0];
                leaders[j][1] = leaders[j + 1][1];
                leaders[j + 1][0] = tempID;
                leaders[j + 1][1] = tempScore;
            }
        }
    }
    
    // Display top 10
    SendClientMessage(playerid, 0xF39C12FF, "═══ TOURNAMENT LEADERBOARD ═══");
    
    new displayCount = (leaderCount < 10) ? leaderCount : 10;
    for(new i = 0; i < displayCount; i++)
    {
        new pid = leaders[i][0];
        new string[128];
        new playerName[24];
        GetPlayerName(pid, playerName, 24);
        
        switch(TournamentData[tournamentType])
        {
            case TOURNAMENT_BIGGEST:
            {
                format(string, sizeof(string), 
                    "{F39C12}%d. {FFFFFF}%s - {3498DB}%.2fkg", 
                    i + 1, playerName, TournamentPlayerScore[pid]);
            }
            case TOURNAMENT_MOST:
            {
                format(string, sizeof(string), 
                    "{F39C12}%d. {FFFFFF}%s - {3498DB}%d fish", 
                    i + 1, playerName, TournamentPlayerCaught[pid]);
            }
            case TOURNAMENT_RAREST:
            {
                format(string, sizeof(string), 
                    "{F39C12}%d. {FFFFFF}%s - {3498DB}%.0f points", 
                    i + 1, playerName, TournamentPlayerScore[pid]);
            }
        }
        SendClientMessage(playerid, -1, string);
    }
    
    return 1;
}
