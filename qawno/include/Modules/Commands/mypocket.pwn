CMD:mypocket(playerid, params[]) return DisplayPocketItemsByJoma(playerid);

DisplayPocketItemsByJoma(playerid, targetid = INVALID_PLAYER_ID)
{
	if(targetid == INVALID_PLAYER_ID) targetid = playerid;
	new super[1000], str[6000], titlestring[1000];
    new name[1000];

    if(playerid == MAX_PLAYERS){strcpy(name, PlayerInfo[playerid][pUsername]);}else{strcat(name, GetRPName(playerid));}

	format(super, sizeof(super), "%s's Pocket", name);
  	strcat(titlestring, super);

    format(super, sizeof(super), "{FFFFFF}(Food: %i) - (Water: %i) - (Cigar: %i)\n", PlayerInfo[playerid][pFood], PlayerInfo[playerid][pDrink], PlayerInfo[playerid][pCigars]);
   	strcat(str, super);

    format(super, sizeof(super), "{FFFFFF}(Bandage: %i) - (Medkit: %i) - (Vest: %i)\n", PlayerInfo[playerid][pBandage], PlayerInfo[playerid][pFirstAid], PlayerInfo[playerid][pVest]);
   	strcat(str, super);

    format(super, sizeof(super), "{FFFFFF}============================================================");
   	strcat(str, super);

	ShowPlayerDialog(targetid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, titlestring, str, "Okay", "");
	return 1;
}