public OnPlayerSpawn(playerid)
{
	PlayerInfo[playerid][ServerOwnerColor] = 1;

	// Attach Weapon By Joma
    if(PlayerHasWeapon(playerid, 30))
	{
	    SetPlayerAttachedObject(playerid, 6, 355, 1, 0.179, -0.142, 0.115, 0, 171.8, 0, 1, 1, 1);
	}
	else if(PlayerHasWeapon(playerid, 31))
	{
	    SetPlayerAttachedObject(playerid, 6, 356, 1, 0.129, 0.169, 0.114, -11.9, 159.4, 19.2, 1, 1, 1);
	}
	/*================================*/

    if(PlayerInfo[playerid][pKicked]) return 0;
	PreloadAnims(playerid);

	if(PlayerInfo[playerid][pSetup])
	{
	    if(PlayerInfo[playerid][pTutorial])
		{
	    	KillTimer(PlayerInfo[playerid][pTutorialTimer]);
	    	PlayerInfo[playerid][pTutorial] = 0;
		}

		InsideTut[playerid] = 1;
		AdjustActor(playerid, 2);
		SetPlayerPos(playerid, 1450.867187, -2286.864013, 13.546875);
		SetPlayerFacingAngle(playerid, 84.46);
		SetPlayerInterior(playerid, 0);
	 	SetPlayerVirtualWorld(playerid, 0);

		TogglePlayerControllable(playerid, 0);
		InterpolateCameraPos(playerid, 650.249572, -1850.245483, 47.655937, 2930.458007, -1378.834960, 82.204711, 40000);
		InterpolateCameraLookAt(playerid, 653.807678, -1846.742065, 47.399448, 2926.791748, -1382.053344, 81.109413, 40000);
		EnableHealthBarForPlayer(playerid, bool:false);
		ShowPlayerDialog(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Select", "<<");
	}

	else if(PlayerInfo[playerid][pJailTime] > 0)
	{
	    SetPlayerInJail(playerid);
	    if(PlayerInfo[playerid][pJailType] == 2)
	    {
	        SM(playerid, COLOR_LIGHTRED, "** You were placed in admin prison by %s, reason: %s", PlayerInfo[playerid][pPrisonedBy], PlayerInfo[playerid][pPrisonReason]);
		}
		else
		{
			SCM(playerid, COLOR_LIGHTRED, "** You haven't completed your jail sentence yet.");
		}
	}
	else if(PlayerInfo[playerid][pPaintball] > 0)
	{
	    SetPlayerInPaintball(playerid, PlayerInfo[playerid][pPaintball]);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnfreezePlayerEx", 500, false, "i", playerid);
	}
	else
	{
	    PlayerInfo[playerid][pJoinedEvent] = 0;
	    PlayerInfo[playerid][pDueling] = INVALID_PLAYER_ID;
		PlayerInfo[playerid][pSabongBoxing] = INVALID_PLAYER_ID;

	    if(PlayerInfo[playerid][pInjured])
		{
			#if defined zombiemode
			if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
			{
				SpawnZombie(playerid);
				return 1;
			}
			#endif
			
			if(IsPlayerInAnyVehicle(playerid))
			{
				ApplyAnimation(playerid, "PED", "CAR_DEAD_LHS", 4.0, 1, 0, 0, 0, 0, 1);
			}
			
			// Only reset deathcooldown if it's 0 (new injury, not relog)
			if(PlayerInfo[playerid][pDeathCooldown] <= 0)
			{
				PlayerInfo[playerid][pDeathCooldown] = 60;
			}
			
			// Set health based on remaining deathcooldown time
			// 300 seconds / 3 seconds per HP = 100 HP max
			new Float:remainingHealth = float(PlayerInfo[playerid][pDeathCooldown]) / 3.0;
			if(remainingHealth > 100.0) remainingHealth = 100.0;
			if(remainingHealth < 1.0) remainingHealth = 1.0;
			
			SetPlayerHealth(playerid, remainingHealth);
			SetPlayerArmour(playerid, 0.0);
			ApplyAnimation(playerid, "CRACK", "crckidle1", 4.0, 1, 0, 0, 0, 0, 1);

			ErrorNotif(playerid, "Wounded", "You have been severely injured.", 10000);
			SM(playerid, COLOR_LIGHTRED,"[ ! ] >> {FFFFFF}You were hurt %i times, use /dmg %i for more details.", pTemp[playerid][pDamagesCount], playerid);
			
			new string[128];
			format(string, sizeof(string), "(( Has been injured %i times, /damages %i for more information. ))", pTemp[playerid][pDamagesCount], playerid);
			UpdateDynamic3DTextLabelText(InjuredLabel[playerid], COLOR_DOCTOR, string);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("UnfreezePlayerEx", 500, false, "i", playerid);

			Maskara[playerid] = 0;
			FaceMask[playerid] = 0;
			Peeing[playerid] = 0;
		}

	    else if(PlayerInfo[playerid][pHospital])
	    {
	        if(PlayerInfo[playerid][pInsurance] == 0)
     	   		SetPlayerInHospital(playerid);
			else if(PlayerInfo[playerid][pInsurance] == HOSPITAL_VIP)
     	   		SetPlayerInVIP(playerid);
			else if(PlayerInfo[playerid][pInsurance] == HOME_CARE)
     	   		SetPlayerInVIP(playerid);
	        else
				SetPlayerInHospital(playerid, .type = PlayerInfo[playerid][pInsurance]);

			ResetPlayerWeaponsEx(playerid);
	    }
	    else
		{
		    SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
		    SetScriptArmour(playerid, PlayerInfo[playerid][pArmor]);
		}

		if(!PlayerInfo[playerid][pHospital])
		{
		    if(PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
			{
				PlayerInfo[PlayerInfo[playerid][pDueling]][pDueling] = INVALID_PLAYER_ID;
				PlayerInfo[playerid][pDueling] = INVALID_PLAYER_ID;
			}
		    if(PlayerInfo[playerid][pSabongBoxing] != INVALID_PLAYER_ID)
			{
				PlayerInfo[PlayerInfo[playerid][pSabongBoxing]][pSabongBoxing] = INVALID_PLAYER_ID;
				PlayerInfo[playerid][pSabongBoxing] = INVALID_PLAYER_ID;
			}

			SetFreezePos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
			SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);
			SetPlayerInterior(playerid, PlayerInfo[playerid][pInterior]);
	 		SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pWorld]);
			SetPlayerWeapons(playerid);
		}
	}

	// Set player skin (check for custom skin first)
	if(PlayerInfo[playerid][pCustomSkin] > 0 && IsCustomSkinID(PlayerInfo[playerid][pCustomSkin])) {
		// Player has a custom skin, use it
		SetPlayerCustomSkin(playerid, PlayerInfo[playerid][pCustomSkin]);
	} else {
		// Use regular skin
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	}
	
	SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, PlayerInfo[playerid][pUZIskill]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, PlayerInfo[playerid][p9mmSkill]);
 	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, PlayerInfo[playerid][pSawnOffSkill]);
	SetPlayerClothing(playerid);

	if(PlayerInfo[playerid][pLogged])
	{
	    // Joma Hunger TD
        for(new i = 0; i < 20; i ++)
		{
	        PlayerTextDrawShow(playerid, HungerTD_ByJoma[playerid][i]);
		}

		// Introduction
		for(new i = 0; i < 12; i ++)
		{
			TextDrawHideForPlayer(playerid, IntroductionTD[i]);
		}

       /* new priotext[250];
		if(GetPVarString(playerid, "PrioTDTimer", priotext, sizeof(priotext)))
		{
			TextDrawSetString(PriorityCooldownTD, priotext);
		}
		else TextDrawShowForPlayer(playerid, PriorityCooldownTD);    */

		TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnfreezePlayerEx", 2000, false, "i", playerid);
	}
	for(new i = 0; i < MAX_GREENZONE; i ++)
	{
		GangZoneShowForAll(GreenzoneInfo[i][gzGangZone], 0x00FF0096);
	}
	if( GetPVarInt( playerid, "PlayMine" ) == 1 ) HideCasinoTDs( playerid ); // MINESWEEPER
	return 1;
}