/*
    FISHING ZONES MANAGER
    Admin zone management with MySQL
*/

#if defined _fishing_zones_manager_included
    #endinput
#endif
#define _fishing_zones_manager_included

// Constants
#define MAX_ZONES               50
#define ZONE_PREVIEW_OBJECTS    16

// Visual object models (choose based on zone type)
#define ZONE_MARKER_BUOY        3095  // Floating buoy
#define ZONE_MARKER_BARREL      1685  // Barrel (alternative)
#define ZONE_MARKER_FISH        1608  // Fish statue (decorative)

// Zone types
#define ZONE_TYPE_BEACH         0
#define ZONE_TYPE_RIVER         1
#define ZONE_TYPE_LAKE          2
#define ZONE_TYPE_DEEPSEA       3

// Dialogs
#define DIALOG_FISHZONE_CREATE      9010
#define DIALOG_FISHZONE_CREATE_TYPE 9009  // New dialog for selecting type during creation
#define DIALOG_FISHZONE_EDIT_MENU   9011
#define DIALOG_FISHZONE_DELETE      9012
#define DIALOG_FISHZONE_LIST        9013
#define DIALOG_FISHZONE_EDIT_NAME   9014
#define DIALOG_FISHZONE_EDIT_TYPE   9015
#define DIALOG_FISHZONE_EDIT_RADIUS 9016
#define DIALOG_FISHZONE_EDIT_TIME   9017

// Zone data
enum E_ZONE
{
    zID,
    zName[64],
    Float:zPosX,
    Float:zPosY,
    Float:zPosZ,
    Float:zRadius,
    zType,
    zTimeBonus[32],
    zTurfID,
    zCreatedBy,
    bool:zActive,
    Text3D:zLabel,
    zAreaID,
    zPreviewObjects[ZONE_PREVIEW_OBJECTS],
    zCenterMarker,          // Central floating object
    zGangZoneID,            // Map/radar indicator
    zMapIconID              // Map icon for zone center
}

new Zones[MAX_ZONES][E_ZONE];
new TotalZones = 0;
new PlayerEditingZone[MAX_PLAYERS] = {-1, ...};
new PlayerCreatingZone[MAX_PLAYERS] = {false, ...};
new PlayerCreatingZoneType[MAX_PLAYERS] = {-1, ...}; // Store selected zone type during creation

// Initialize zone data
stock InitZoneData()
{
    for(new i = 0; i < MAX_ZONES; i++)
    {
        Zones[i][zID] = 0;
        Zones[i][zActive] = false;
        Zones[i][zLabel] = Text3D:INVALID_3DTEXT_ID;
        Zones[i][zAreaID] = -1;
        Zones[i][zCenterMarker] = INVALID_OBJECT_ID;
        Zones[i][zGangZoneID] = -1;
        Zones[i][zMapIconID] = -1;
        for(new j = 0; j < ZONE_PREVIEW_OBJECTS; j++)
            Zones[i][zPreviewObjects][j] = INVALID_OBJECT_ID;
    }
    printf("[FISHING ZONES] Zone data initialized");
}

// Zone type helpers
stock GetZoneTypeName(type)
{
    new typeName[32];
    switch(type)
    {
        case ZONE_TYPE_BEACH: typeName = "Beach";
        case ZONE_TYPE_RIVER: typeName = "River";
        case ZONE_TYPE_LAKE: typeName = "Lake";
        case ZONE_TYPE_DEEPSEA: typeName = "Deep Sea";
        default: typeName = "Unknown";
    }
    return typeName;
}

stock GetZoneTypeColor(type)
{
    new color;
    switch(type)
    {
        case ZONE_TYPE_BEACH: color = 0xF39C12FF;
        case ZONE_TYPE_RIVER: color = 0x3498DBFF;
        case ZONE_TYPE_LAKE: color = 0x1ABC9CFF;
        case ZONE_TYPE_DEEPSEA: color = 0x2C3E50FF;
        default: color = 0xFFFFFFFF;
    }
    return color;
}

// Get zone type marker object
stock GetZoneTypeMarker(type)
{
    new objectid;
    switch(type)
    {
        case ZONE_TYPE_BEACH: objectid = ZONE_MARKER_BARREL;
        case ZONE_TYPE_RIVER: objectid = ZONE_MARKER_BUOY;
        case ZONE_TYPE_LAKE: objectid = ZONE_MARKER_BUOY;
        case ZONE_TYPE_DEEPSEA: objectid = ZONE_MARKER_FISH;
        default: objectid = ZONE_MARKER_BUOY;
    }
    return objectid;
}

// Get transparent color for gang zone (map radar) - More visible
stock GetZoneTypeGangZoneColor(type)
{
    new color;
    switch(type)
    {
        case ZONE_TYPE_BEACH: color = 0xF39C12FF;  // Orange - fully opaque
        case ZONE_TYPE_RIVER: color = 0x3498DBFF;  // Blue - fully opaque
        case ZONE_TYPE_LAKE: color = 0x1ABC9CFF;   // Teal - fully opaque
        case ZONE_TYPE_DEEPSEA: color = 0x2C3E50FF; // Dark blue - fully opaque
        default: color = 0xFFFFFFFF;
    }
    return color;
}

// Load zones from database
stock LoadFishingZonesFromDB()
{
    InitZoneData(); // Initialize all zone data first
    new query[256];
    format(query, sizeof(query),
        "SELECT * FROM fishing_zones WHERE is_active = 1 ORDER BY id ASC");
    mysql_tquery(connectionID, query, "OnLoadZones");
    printf("[FISHING ZONES] Loading zones from database...");
}

forward OnLoadZones();
public OnLoadZones()
{
    new rows = cache_get_row_count(connectionID);
    printf("[FISHING ZONES] OnLoadZones callback - rows found: %d", rows);
    
    if(rows == 0)
    {
        printf("[FISHING ZONES] No zones found in database!");
        printf("[FISHING ZONES] Make sure fishing_zones table exists and has active zones (is_active = 1)");
        return;
    }
    
    TotalZones = 0;
    for(new i = 0; i < rows && i < MAX_ZONES; i++)
    {
        Zones[i][zID] = cache_get_field_content_int(i, "id");
        cache_get_field_content(i, "zone_name", Zones[i][zName], connectionID, 64);
        Zones[i][zPosX] = cache_get_field_content_float(i, "pos_x");
        Zones[i][zPosY] = cache_get_field_content_float(i, "pos_y");
        Zones[i][zPosZ] = cache_get_field_content_float(i, "pos_z");
        Zones[i][zRadius] = cache_get_field_content_float(i, "radius");
        
        printf("[FISHING ZONES] Loading zone %d: ID=%d, Name=%s, Pos=(%.2f, %.2f, %.2f), Radius=%.2f", 
            i, Zones[i][zID], Zones[i][zName], Zones[i][zPosX], Zones[i][zPosY], Zones[i][zPosZ], Zones[i][zRadius]);
        
        new zoneTypeStr[32];
        cache_get_field_content(i, "zone_type", zoneTypeStr, connectionID, 32);
        if(!strcmp(zoneTypeStr, "Beach", true)) Zones[i][zType] = ZONE_TYPE_BEACH;
        else if(!strcmp(zoneTypeStr, "River", true)) Zones[i][zType] = ZONE_TYPE_RIVER;
        else if(!strcmp(zoneTypeStr, "Lake", true)) Zones[i][zType] = ZONE_TYPE_LAKE;
        else if(!strcmp(zoneTypeStr, "Deep Sea", true)) Zones[i][zType] = ZONE_TYPE_DEEPSEA;
        else Zones[i][zType] = ZONE_TYPE_LAKE;
        
        cache_get_field_content(i, "time_bonus", Zones[i][zTimeBonus], connectionID, 32);
        Zones[i][zTurfID] = cache_get_field_content_int(i, "turf_id");
        Zones[i][zCreatedBy] = cache_get_field_content_int(i, "created_by");
        Zones[i][zActive] = true;
        
        printf("[FISHING ZONES] Zone %d marked as ACTIVE", i);
        
        CreateZoneVisuals(i);
        TotalZones++;
    }
    printf("[FISHING ZONES] Successfully loaded %d zones from database", TotalZones);
    printf("[FISHING ZONES] Zone detection is now active - players must be in a zone to fish");
}

// Visual elements
stock CreateZoneVisuals(idx)
{
    if(idx < 0 || idx >= MAX_ZONES) return;
    
    // 1. Create 3D Text Label
    new labelText[256];
    format(labelText, sizeof(labelText),
        "{FFFFFF}Fish Zone #{%06x}%d\n{FFFFFF}Name: {FFFF00}%s\n{FFFFFF}Type: {00FF00}%s\n{FFFFFF}Radius: {00FFFF}%.1fm",
        GetZoneTypeColor(Zones[idx][zType]) >>> 8,
        Zones[idx][zID],
        Zones[idx][zName],
        GetZoneTypeName(Zones[idx][zType]),
        Zones[idx][zRadius]);
    
    Zones[idx][zLabel] = Create3DTextLabel(labelText, GetZoneTypeColor(Zones[idx][zType]),
        Zones[idx][zPosX], Zones[idx][zPosY], Zones[idx][zPosZ] + 5.0, 50.0, 0, 0);
    
    // 2. Create Central Floating Marker Object
    new markerModel = GetZoneTypeMarker(Zones[idx][zType]);
    #if defined _streamer_included
    Zones[idx][zCenterMarker] = CreateDynamicObject(markerModel, 
        Zones[idx][zPosX], Zones[idx][zPosY], Zones[idx][zPosZ] + 1.0,
        0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
    #else
    Zones[idx][zCenterMarker] = CreateObject(markerModel,
        Zones[idx][zPosX], Zones[idx][zPosY], Zones[idx][zPosZ] + 1.0,
        0.0, 0.0, 0.0, 300.0);
    #endif
    
    // 3. Create Dynamic Area for detection
    #if defined _streamer_included
    Zones[idx][zAreaID] = CreateDynamicSphere(Zones[idx][zPosX], Zones[idx][zPosY], 
        Zones[idx][zPosZ], Zones[idx][zRadius]);
    #endif
    
    // 4. Create Gang Zone for Map/Radar Display
    // GangZones are square, so we create a square that encompasses the circular radius
    // To better represent the circle, we use the radius directly
    new Float:minX = Zones[idx][zPosX] - Zones[idx][zRadius];
    new Float:minY = Zones[idx][zPosY] - Zones[idx][zRadius];
    new Float:maxX = Zones[idx][zPosX] + Zones[idx][zRadius];
    new Float:maxY = Zones[idx][zPosY] + Zones[idx][zRadius];
    
    Zones[idx][zGangZoneID] = GangZoneCreate(minX, minY, maxX, maxY);
    
    if(Zones[idx][zGangZoneID] != -1)
    {
        new color = GetZoneTypeGangZoneColor(Zones[idx][zType]);
        GangZoneShowForAll(Zones[idx][zGangZoneID], color);
        printf("[FISHING ZONES] Created gang zone %d for zone #%d (%.1f, %.1f to %.1f, %.1f) - Color: 0x%08x", 
            Zones[idx][zGangZoneID], Zones[idx][zID], minX, minY, maxX, maxY, color);
    }
    else
    {
        printf("[FISHING ZONES] ERROR: Failed to create gang zone for zone #%d - Possible gang zone limit reached!", Zones[idx][zID]);
    }
    
    // 5. Create Map Icon at center
    #if defined _streamer_included
    Zones[idx][zMapIconID] = CreateDynamicMapIcon(Zones[idx][zPosX], Zones[idx][zPosY], Zones[idx][zPosZ],
        36, GetZoneTypeColor(Zones[idx][zType]) >>> 8, -1, -1, -1, 300.0, MAPICON_GLOBAL);
    #endif
    
    // 6. Create Rectangular Boundary Preview Objects (corners and edges)
    // Reuse the rectangular bounds already calculated above for gang zone
    
    // Create objects along the 4 edges of the rectangle
    new objectsPerSide = ZONE_PREVIEW_OBJECTS / 4; // Divide objects among 4 sides
    new Float:spacing = (Zones[idx][zRadius] * 2.0) / objectsPerSide;
    new objIdx = 0;
    
    // Top edge (minY, from minX to maxX)
    for(new i = 0; i <= objectsPerSide && objIdx < ZONE_PREVIEW_OBJECTS; i++)
    {
        new Float:x = minX + (i * spacing);
        #if defined _streamer_included
        Zones[idx][zPreviewObjects][objIdx] = CreateDynamicObject(19135, x, minY, Zones[idx][zPosZ], 
            0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
        #else
        Zones[idx][zPreviewObjects][objIdx] = CreateObject(19135, x, minY, Zones[idx][zPosZ], 
            0.0, 0.0, 0.0, 300.0);
        #endif
        objIdx++;
    }
    
    // Right edge (maxX, from minY to maxY)
    for(new i = 1; i <= objectsPerSide && objIdx < ZONE_PREVIEW_OBJECTS; i++)
    {
        new Float:y = minY + (i * spacing);
        #if defined _streamer_included
        Zones[idx][zPreviewObjects][objIdx] = CreateDynamicObject(19135, maxX, y, Zones[idx][zPosZ], 
            0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
        #else
        Zones[idx][zPreviewObjects][objIdx] = CreateObject(19135, maxX, y, Zones[idx][zPosZ], 
            0.0, 0.0, 0.0, 300.0);
        #endif
        objIdx++;
    }
    
    // Bottom edge (maxY, from maxX to minX)
    for(new i = 1; i <= objectsPerSide && objIdx < ZONE_PREVIEW_OBJECTS; i++)
    {
        new Float:x = maxX - (i * spacing);
        #if defined _streamer_included
        Zones[idx][zPreviewObjects][objIdx] = CreateDynamicObject(19135, x, maxY, Zones[idx][zPosZ], 
            0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
        #else
        Zones[idx][zPreviewObjects][objIdx] = CreateObject(19135, x, maxY, Zones[idx][zPosZ], 
            0.0, 0.0, 0.0, 300.0);
        #endif
        objIdx++;
    }
    
    // Left edge (minX, from maxY to minY)
    for(new i = 1; i < objectsPerSide && objIdx < ZONE_PREVIEW_OBJECTS; i++)
    {
        new Float:y = maxY - (i * spacing);
        #if defined _streamer_included
        Zones[idx][zPreviewObjects][objIdx] = CreateDynamicObject(19135, minX, y, Zones[idx][zPosZ], 
            0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
        #else
        Zones[idx][zPreviewObjects][objIdx] = CreateObject(19135, minX, y, Zones[idx][zPosZ], 
            0.0, 0.0, 0.0, 300.0);
        #endif
        objIdx++;
    }
    
    printf("[FISHING ZONES] Created visuals for zone #%d (%s) - %d boundary objects", Zones[idx][zID], Zones[idx][zName], objIdx);
}

stock DestroyZoneVisuals(idx)
{
    if(idx < 0 || idx >= MAX_ZONES) return;
    
    // Destroy 3D Text Label
    if(Zones[idx][zLabel] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(Zones[idx][zLabel]);
        Zones[idx][zLabel] = Text3D:INVALID_3DTEXT_ID;
    }
    
    // Destroy Central Marker Object
    #if defined _streamer_included
    if(Zones[idx][zCenterMarker] != INVALID_OBJECT_ID)
    {
        DestroyDynamicObject(Zones[idx][zCenterMarker]);
        Zones[idx][zCenterMarker] = INVALID_OBJECT_ID;
    }
    #else
    if(Zones[idx][zCenterMarker] != INVALID_OBJECT_ID)
    {
        DestroyObject(Zones[idx][zCenterMarker]);
        Zones[idx][zCenterMarker] = INVALID_OBJECT_ID;
    }
    #endif
    
    // Destroy Dynamic Area
    #if defined _streamer_included
    if(Zones[idx][zAreaID] != -1)
    {
        DestroyDynamicArea(Zones[idx][zAreaID]);
        Zones[idx][zAreaID] = -1;
    }
    #endif
    
    // Destroy Gang Zone (Map Radar)
    if(Zones[idx][zGangZoneID] != -1)
    {
        GangZoneDestroy(Zones[idx][zGangZoneID]);
        Zones[idx][zGangZoneID] = -1;
    }
    
    // Destroy Map Icon
    #if defined _streamer_included
    if(Zones[idx][zMapIconID] != -1)
    {
        DestroyDynamicMapIcon(Zones[idx][zMapIconID]);
        Zones[idx][zMapIconID] = -1;
    }
    #endif
    
    // Destroy Preview Objects (radius circle)
    for(new i = 0; i < ZONE_PREVIEW_OBJECTS; i++)
    {
        #if defined _streamer_included
        if(Zones[idx][zPreviewObjects][i] != INVALID_OBJECT_ID)
        {
            DestroyDynamicObject(Zones[idx][zPreviewObjects][i]);
            Zones[idx][zPreviewObjects][i] = INVALID_OBJECT_ID;
        }
        #else
        if(Zones[idx][zPreviewObjects][i] != INVALID_OBJECT_ID)
        {
            DestroyObject(Zones[idx][zPreviewObjects][i]);
            Zones[idx][zPreviewObjects][i] = INVALID_OBJECT_ID;
        }
        #endif
    }
    
    printf("[FISHING ZONES] Destroyed visuals for zone #%d", Zones[idx][zID]);
}

stock UpdateZoneVisuals(idx)
{
    DestroyZoneVisuals(idx);
    CreateZoneVisuals(idx);
}

// Zone detection
// Internal stock function for zone detection (RECTANGULAR to match gang zone on map)
stock GetPlayerZoneInternal(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    printf("[FISHING ZONES DEBUG] GetPlayerZone - playerid: %d, pos: %.2f, %.2f, %.2f", playerid, x, y, z);
    printf("[FISHING ZONES DEBUG] TotalZones: %d", TotalZones);
    
    for(new i = 0; i < TotalZones; i++)
    {
        if(!Zones[i][zActive]) 
        {
            printf("[FISHING ZONES DEBUG] Zone %d (ID: %d) is not active, skipping", i, Zones[i][zID]);
            continue;
        }
        
        // Calculate rectangular bounds (same as gang zone)
        new Float:minX = Zones[i][zPosX] - Zones[i][zRadius];
        new Float:minY = Zones[i][zPosY] - Zones[i][zRadius];
        new Float:maxX = Zones[i][zPosX] + Zones[i][zRadius];
        new Float:maxY = Zones[i][zPosY] + Zones[i][zRadius];
        
        printf("[FISHING ZONES DEBUG] Zone %d (ID: %d, Name: %s) - Bounds: (%.1f, %.1f) to (%.1f, %.1f)", 
            i, Zones[i][zID], Zones[i][zName], minX, minY, maxX, maxY);
        
        // Check if player is within rectangular bounds
        if(x >= minX && x <= maxX && y >= minY && y <= maxY)
        {
            printf("[FISHING ZONES DEBUG] Player %d is in zone %d (ID: %d, Name: %s)", 
                playerid, i, Zones[i][zID], Zones[i][zName]);
            return i + 1; // Return 1-based index (1, 2, 3...) so 0 means no zone
        }
    }
    
    printf("[FISHING ZONES DEBUG] Player %d is not in any fishing zone", playerid);
    return 0; // Return 0 if not in any zone
}

// Public wrapper for CallRemoteFunction
forward GetPlayerZone(playerid);
public GetPlayerZone(playerid)
{
    return GetPlayerZoneInternal(playerid);
}

forward IsPlayerInZone(playerid);
stock IsPlayerInZone(playerid)
{
    new zoneIdx = GetPlayerZoneInternal(playerid);
    return (zoneIdx > 0); // Check if > 0 instead of != -1
}

// Admin commands
CMD:fishzone(playerid, params[])
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Admin level 8+ required");
    
    new subcmd[32], zoneid;
    if(sscanf(params, "s[32]D(-1)", subcmd, zoneid))
    {
        SendClientMessage(playerid, 0x3498DBFF, "--- FISH ZONE MANAGEMENT ---");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone create");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone edit [id]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone delete [id]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone goto [id]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone list");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone info");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone preview [radius] - Preview zone at your position");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone hidepreview - Hide preview");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishzone refresh - Refresh map markers");
        return 1;
    }
    
    if(!strcmp(subcmd, "create", true)) return cmd_fishzone_create(playerid, "");
    else if(!strcmp(subcmd, "edit", true))
    {
        if(zoneid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishzone edit [id]");
        return cmd_fishzone_edit(playerid, zoneid);
    }
    else if(!strcmp(subcmd, "delete", true))
    {
        if(zoneid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishzone delete [id]");
        return cmd_fishzone_delete(playerid, zoneid);
    }
    else if(!strcmp(subcmd, "goto", true))
    {
        if(zoneid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishzone goto [id]");
        return cmd_fishzone_goto(playerid, zoneid);
    }
    else if(!strcmp(subcmd, "list", true)) return cmd_fishzone_list(playerid, "");
    else if(!strcmp(subcmd, "info", true)) return cmd_fishzone_info(playerid, "");
    else if(!strcmp(subcmd, "preview", true))
    {
        new Float:radius = (zoneid == -1) ? 50.0 : float(zoneid);
        return cmd_fishzone_preview(playerid, radius);
    }
    else if(!strcmp(subcmd, "hidepreview", true)) return cmd_fishzone_hidepreview(playerid, "");
    else if(!strcmp(subcmd, "refresh", true)) return cmd_fishzone_refresh(playerid, "");
    return 1;
}

cmd_fishzone_create(playerid, params[])
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8) return 1;
    ShowPlayerDialog(playerid, DIALOG_FISHZONE_CREATE_TYPE, DIALOG_STYLE_LIST,
        "{3498DB}Create Fishing Zone - Select Type",
        "{FFFFFF}Beach\nRiver\nLake\nDeep Sea",
        "Next", "Cancel");
    PlayerCreatingZone[playerid] = true;
    return 1;
}

cmd_fishzone_edit(playerid, zoneid)
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8) return 1;
    new idx = -1;
    for(new i = 0; i < TotalZones; i++)
    {
        if(Zones[i][zID] == zoneid) { idx = i; break; }
    }
    if(idx == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Zone not found!");
    
    PlayerEditingZone[playerid] = idx;
    new dialog[512];
    format(dialog, sizeof(dialog),
        "{FFFFFF}Edit Name\n\
        {FFFFFF}Edit Type (Current: {00FF00}%s{FFFFFF})\n\
        {FFFFFF}Edit Radius (Current: {00FFFF}%.1fm{FFFFFF})\n\
        {FFFFFF}Edit Time Bonus (Current: {FF00FF}%s{FFFFFF})\n\
        {FFFFFF}Move to My Position\n\
        {FF0000}Cancel",
        GetZoneTypeName(Zones[idx][zType]), Zones[idx][zRadius], Zones[idx][zTimeBonus]);
    ShowPlayerDialog(playerid, DIALOG_FISHZONE_EDIT_MENU, DIALOG_STYLE_LIST,
        "{3498DB}Edit Fishing Zone", dialog, "Select", "Cancel");
    return 1;
}

cmd_fishzone_delete(playerid, zoneid)
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8) return 1;
    new idx = -1;
    for(new i = 0; i < TotalZones; i++)
    {
        if(Zones[i][zID] == zoneid) { idx = i; break; }
    }
    if(idx == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Zone not found!");
    
    new dialog[256];
    format(dialog, sizeof(dialog),
        "{FFFFFF}Delete zone:\n\n\
        {FFFF00}#%d: %s\n\
        {FFFFFF}Type: {00FF00}%s\n\
        {FFFFFF}Radius: {00FFFF}%.1fm\n\n\
        {FF0000}This cannot be undone!",
        Zones[idx][zID], Zones[idx][zName], GetZoneTypeName(Zones[idx][zType]), Zones[idx][zRadius]);
    ShowPlayerDialog(playerid, DIALOG_FISHZONE_DELETE, DIALOG_STYLE_MSGBOX,
        "{E74C3C}Delete Fishing Zone", dialog, "Delete", "Cancel");
    PlayerEditingZone[playerid] = idx;
    return 1;
}

cmd_fishzone_goto(playerid, zoneid)
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8) return 1;
    new idx = -1;
    for(new i = 0; i < TotalZones; i++)
    {
        if(Zones[i][zID] == zoneid) { idx = i; break; }
    }
    if(idx == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Zone not found!");
    
    SetPlayerPos(playerid, Zones[idx][zPosX], Zones[idx][zPosY], Zones[idx][zPosZ] + 2.0);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    
    new string[128];
    format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Teleported to zone #{3498DB}%d{FFFFFF}: {FFFF00}%s",
        Zones[idx][zID], Zones[idx][zName]);
    SendClientMessage(playerid, -1, string);
    return 1;
}

cmd_fishzone_list(playerid, params[])
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8) return 1;
    if(TotalZones == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[FISHING]{FFFFFF} No zones created yet!");
        return 1;
    }
    SendClientMessage(playerid, 0x3498DBFF, "--- FISHING ZONES ---");
    for(new i = 0; i < TotalZones; i++)
    {
        new string[256];
        format(string, sizeof(string), "{FFFFFF}#%d: {FFFF00}%s {FFFFFF}| Type: {00FF00}%s {FFFFFF}| Radius: {00FFFF}%.1fm",
            Zones[i][zID], Zones[i][zName], GetZoneTypeName(Zones[i][zType]), Zones[i][zRadius]);
        SendClientMessage(playerid, -1, string);
    }
    SendClientMessage(playerid, 0x3498DBFF, "____________________");
    return 1;
}

cmd_fishzone_info(playerid, params[])
{
    new idx = GetPlayerZoneInternal(playerid);
    if(idx == -1)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[FISHING]{FFFFFF} You are not in a fishing zone!");
        return 1;
    }
    new string[256];
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    format(string, sizeof(string), "{3498DB}[ZONE INFO]{FFFFFF} %s (ID: #%d)",
        Zones[idx][zName], Zones[idx][zID]);
    SendClientMessage(playerid, -1, string);
    format(string, sizeof(string), "{FFFFFF}Type: {00FF00}%s {FFFFFF}| Radius: {00FFFF}%.1fm",
        GetZoneTypeName(Zones[idx][zType]), Zones[idx][zRadius]);
    SendClientMessage(playerid, -1, string);
    format(string, sizeof(string), "{FFFFFF}Time Bonus: {FF00FF}%s", Zones[idx][zTimeBonus]);
    SendClientMessage(playerid, -1, string);
    format(string, sizeof(string), "{FFFFFF}Gang Zone ID: {FFFF00}%d {FFFFFF}| Map Icon: {FFFF00}%d",
        Zones[idx][zGangZoneID], Zones[idx][zMapIconID]);
    SendClientMessage(playerid, -1, string);
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    return 1;
}

// Debug command to refresh gang zones
cmd_fishzone_refresh(playerid, params[])
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8) return 1;
    
    new count = 0;
    for(new i = 0; i < TotalZones; i++)
    {
        if(!Zones[i][zActive]) continue;
        
        // Destroy old gang zone
        if(Zones[i][zGangZoneID] != -1)
        {
            GangZoneDestroy(Zones[i][zGangZoneID]);
        }
        
        // Recreate gang zone
        new Float:minX = Zones[i][zPosX] - Zones[i][zRadius];
        new Float:minY = Zones[i][zPosY] - Zones[i][zRadius];
        new Float:maxX = Zones[i][zPosX] + Zones[i][zRadius];
        new Float:maxY = Zones[i][zPosY] + Zones[i][zRadius];
        
        Zones[i][zGangZoneID] = GangZoneCreate(minX, minY, maxX, maxY);
        if(Zones[i][zGangZoneID] != -1)
        {
            GangZoneShowForAll(Zones[i][zGangZoneID], GetZoneTypeGangZoneColor(Zones[i][zType]));
            count++;
        }
    }
    
    new string[128];
    format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Refreshed %d gang zones on map", count);
    SendClientMessage(playerid, -1, string);
    return 1;
}

// Dialog responses
stock OnFishZoneDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    printf("[FISHING ZONES DEBUG] OnFishZoneDialogResponse called - dialogid: %d, response: %d", dialogid, response);
    
    if(dialogid == DIALOG_FISHZONE_CREATE_TYPE)
    {
        if(!response)
        {
            PlayerCreatingZone[playerid] = false;
            return 1;
        }
        
        // Store selected zone type
        PlayerCreatingZoneType[playerid] = listitem; // 0=Beach, 1=River, 2=Lake, 3=Deep Sea
        
        // Show confirmation dialog
        new typeNames[4][16] = {"Beach", "River", "Lake", "Deep Sea"};
        new dialog[256];
        format(dialog, sizeof(dialog),
            "{FFFFFF}Zone will be created at your current position\n\n\
            Type: {00FF00}%s\n\
            Default radius: {00FFFF}50m\n\n\
            {FFFFFF}You can edit it after creation using /fishzone edit",
            typeNames[listitem]);
        
        ShowPlayerDialog(playerid, DIALOG_FISHZONE_CREATE, DIALOG_STYLE_MSGBOX,
            "{3498DB}Create Fishing Zone", dialog, "Create", "Cancel");
        return 1;
    }
    else if(dialogid == DIALOG_FISHZONE_CREATE)
    {
        printf("[FISHING ZONES DEBUG] DIALOG_FISHZONE_CREATE detected");
        if(!response)
        {
            printf("[FISHING ZONES DEBUG] Player cancelled dialog");
            PlayerCreatingZone[playerid] = false;
            PlayerCreatingZoneType[playerid] = -1;
            return 1;
        }
        
        printf("[FISHING ZONES DEBUG] Player clicked Create button");
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        printf("[FISHING ZONES DEBUG] Player position: %.2f, %.2f, %.2f", x, y, z);
        
        // Get zone type name from stored selection
        new zoneTypeStr[16];
        switch(PlayerCreatingZoneType[playerid])
        {
            case 0: format(zoneTypeStr, sizeof(zoneTypeStr), "Beach");
            case 1: format(zoneTypeStr, sizeof(zoneTypeStr), "River");
            case 2: format(zoneTypeStr, sizeof(zoneTypeStr), "Lake");
            case 3: format(zoneTypeStr, sizeof(zoneTypeStr), "Deep Sea");
            default: format(zoneTypeStr, sizeof(zoneTypeStr), "Lake");
        }
        
        printf("[FISHING ZONES DEBUG] Selected zone type: %s (index: %d)", zoneTypeStr, PlayerCreatingZoneType[playerid]);
        
        new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
        new query[512];
        format(query, sizeof(query),
            "INSERT INTO fishing_zones (zone_name, pos_x, pos_y, pos_z, radius, zone_type, time_bonus, created_by) VALUES ('New Fishing Zone', %f, %f, %f, 50.0, '%s', 'none', %d)",
            x, y, z, zoneTypeStr, adminLevel);
        
        printf("[FISHING ZONES DEBUG] Executing query: %s", query);
        mysql_tquery(connectionID, query, "OnCreateZone", "ifff", playerid, x, y, z);
        SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Creating zone...");
        printf("[FISHING ZONES DEBUG] Query sent to MySQL");
        
        // Reset creation variables
        PlayerCreatingZone[playerid] = false;
        PlayerCreatingZoneType[playerid] = -1;
    }
    else if(dialogid == DIALOG_FISHZONE_EDIT_MENU)
    {
        if(!response || PlayerEditingZone[playerid] == -1) return 1;
        new idx = PlayerEditingZone[playerid];
        switch(listitem)
        {
            case 0: ShowPlayerDialog(playerid, DIALOG_FISHZONE_EDIT_NAME, DIALOG_STYLE_INPUT,
                "{3498DB}Edit Zone Name", "{FFFFFF}Enter new zone name:", "Save", "Cancel");
            case 1: ShowPlayerDialog(playerid, DIALOG_FISHZONE_EDIT_TYPE, DIALOG_STYLE_LIST,
                "{3498DB}Edit Zone Type", "{FFFFFF}Beach\nRiver\nLake\nDeep Sea", "Select", "Cancel");
            case 2: ShowPlayerDialog(playerid, DIALOG_FISHZONE_EDIT_RADIUS, DIALOG_STYLE_INPUT,
                "{3498DB}Edit Zone Radius", "{FFFFFF}Enter new radius (10-200):", "Save", "Cancel");
            case 3: ShowPlayerDialog(playerid, DIALOG_FISHZONE_EDIT_TIME, DIALOG_STYLE_LIST,
                "{3498DB}Edit Time Bonus", "{FFFFFF}None\nMorning\nAfternoon\nEvening\nNight", "Select", "Cancel");
            case 4:
            {
                new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                Zones[idx][zPosX] = x; Zones[idx][zPosY] = y; Zones[idx][zPosZ] = z;
                new query[256];
                mysql_format(connectionID, query, sizeof(query),
                    "UPDATE fishing_zones SET pos_x = %f, pos_y = %f, pos_z = %f WHERE id = %d",
                    x, y, z, Zones[idx][zID]);
                mysql_tquery(connectionID, query);
                UpdateZoneVisuals(idx);
                SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Zone position updated!");
            }
        }
    }
    else if(dialogid == DIALOG_FISHZONE_DELETE)
    {
        if(!response || PlayerEditingZone[playerid] == -1) return 1;
        new idx = PlayerEditingZone[playerid];
        
        // Hard delete from database
        new query[128];
        mysql_format(connectionID, query, sizeof(query),
            "DELETE FROM fishing_zones WHERE id = %d", Zones[idx][zID]);
        mysql_tquery(connectionID, query);
        
        // Destroy all visuals
        DestroyZoneVisuals(idx);
        
        // Remove from memory by shifting array
        for(new i = idx; i < TotalZones - 1; i++)
        {
            Zones[i] = Zones[i + 1];
        }
        
        // Clear the last zone slot
        Zones[TotalZones - 1][zID] = 0;
        Zones[TotalZones - 1][zActive] = false;
        Zones[TotalZones - 1][zLabel] = Text3D:INVALID_3DTEXT_ID;
        Zones[TotalZones - 1][zAreaID] = -1;
        Zones[TotalZones - 1][zCenterMarker] = INVALID_OBJECT_ID;
        Zones[TotalZones - 1][zGangZoneID] = -1;
        Zones[TotalZones - 1][zMapIconID] = -1;
        
        // Decrease total zones count
        TotalZones--;
        
        SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Zone permanently deleted!");
        printf("[FISHING ZONES] Zone #%d deleted by admin %d", Zones[idx][zID], playerid);
        PlayerEditingZone[playerid] = -1;
    }
    else if(dialogid == DIALOG_FISHZONE_EDIT_NAME)
    {
        if(!response || PlayerEditingZone[playerid] == -1) return 1;
        new idx = PlayerEditingZone[playerid];
        if(strlen(inputtext) < 3 || strlen(inputtext) > 63)
        {
            SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Name must be 3-63 characters!");
            return 1;
        }
        format(Zones[idx][zName], 64, "%s", inputtext);
        new query[256];
        mysql_format(connectionID, query, sizeof(query),
            "UPDATE fishing_zones SET zone_name = '%e' WHERE id = %d", inputtext, Zones[idx][zID]);
        mysql_tquery(connectionID, query);
        UpdateZoneVisuals(idx);
        new string[128];
        format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Zone name updated to: {FFFF00}%s", inputtext);
        SendClientMessage(playerid, -1, string);
        PlayerEditingZone[playerid] = -1;
    }
    else if(dialogid == DIALOG_FISHZONE_EDIT_TYPE)
    {
        if(!response || PlayerEditingZone[playerid] == -1) return 1;
        new idx = PlayerEditingZone[playerid], zoneTypeStr[32], newType;
        switch(listitem)
        {
            case 0: { newType = ZONE_TYPE_BEACH; zoneTypeStr = "Beach"; }
            case 1: { newType = ZONE_TYPE_RIVER; zoneTypeStr = "River"; }
            case 2: { newType = ZONE_TYPE_LAKE; zoneTypeStr = "Lake"; }
            case 3: { newType = ZONE_TYPE_DEEPSEA; zoneTypeStr = "Deep Sea"; }
        }
        Zones[idx][zType] = newType;
        new query[256];
        mysql_format(connectionID, query, sizeof(query),
            "UPDATE fishing_zones SET zone_type = '%s' WHERE id = %d", zoneTypeStr, Zones[idx][zID]);
        mysql_tquery(connectionID, query);
        UpdateZoneVisuals(idx);
        new string[128];
        format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Zone type updated to: {00FF00}%s", zoneTypeStr);
        SendClientMessage(playerid, -1, string);
        PlayerEditingZone[playerid] = -1;
    }
    else if(dialogid == DIALOG_FISHZONE_EDIT_RADIUS)
    {
        if(!response || PlayerEditingZone[playerid] == -1) return 1;
        new idx = PlayerEditingZone[playerid], Float:newRadius = floatstr(inputtext);
        if(newRadius < 10.0 || newRadius > 200.0)
        {
            SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Radius must be 10-200!");
            return 1;
        }
        Zones[idx][zRadius] = newRadius;
        new query[256];
        mysql_format(connectionID, query, sizeof(query),
            "UPDATE fishing_zones SET radius = %f WHERE id = %d", newRadius, Zones[idx][zID]);
        mysql_tquery(connectionID, query);
        UpdateZoneVisuals(idx);
        new string[128];
        format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Zone radius updated to: {00FFFF}%.1fm", newRadius);
        SendClientMessage(playerid, -1, string);
        PlayerEditingZone[playerid] = -1;
    }
    else if(dialogid == DIALOG_FISHZONE_EDIT_TIME)
    {
        if(!response || PlayerEditingZone[playerid] == -1) return 1;
        new idx = PlayerEditingZone[playerid], timeBonusStr[32];
        switch(listitem)
        {
            case 0: timeBonusStr = "none";
            case 1: timeBonusStr = "morning";
            case 2: timeBonusStr = "afternoon";
            case 3: timeBonusStr = "evening";
            case 4: timeBonusStr = "night";
        }
        format(Zones[idx][zTimeBonus], 32, "%s", timeBonusStr);
        new query[256];
        mysql_format(connectionID, query, sizeof(query),
            "UPDATE fishing_zones SET time_bonus = '%s' WHERE id = %d", timeBonusStr, Zones[idx][zID]);
        mysql_tquery(connectionID, query);
        UpdateZoneVisuals(idx);
        new string[128];
        format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Time bonus updated to: {FF00FF}%s", timeBonusStr);
        SendClientMessage(playerid, -1, string);
        PlayerEditingZone[playerid] = -1;
    }
    return 1;
}

forward OnCreateZone(playerid, Float:x, Float:y, Float:z);
public OnCreateZone(playerid, Float:x, Float:y, Float:z)
{
    new insert_id = cache_insert_id();
    if(insert_id > 0 && TotalZones < MAX_ZONES)
    {
        // Query the database to get the full zone data including zone_type
        new query[256];
        mysql_format(connectionID, query, sizeof(query),
            "SELECT * FROM fishing_zones WHERE id = %d", insert_id);
        mysql_tquery(connectionID, query, "OnLoadNewZone", "ifffi", playerid, x, y, z, insert_id);
    }
    else SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Failed to create zone!");
}

forward OnLoadNewZone(playerid, Float:x, Float:y, Float:z, insert_id);
public OnLoadNewZone(playerid, Float:x, Float:y, Float:z, insert_id)
{
    new rows = cache_get_row_count(connectionID);
    if(rows > 0 && TotalZones < MAX_ZONES)
    {
        new idx = TotalZones;
        Zones[idx][zID] = insert_id;
        cache_get_field_content(0, "zone_name", Zones[idx][zName], connectionID, 64);
        Zones[idx][zPosX] = x; Zones[idx][zPosY] = y; Zones[idx][zPosZ] = z;
        Zones[idx][zRadius] = cache_get_field_content_float(0, "radius");
        
        // Get zone type from database
        new zoneTypeStr[32];
        cache_get_field_content(0, "zone_type", zoneTypeStr, connectionID, 32);
        if(!strcmp(zoneTypeStr, "Beach", true)) Zones[idx][zType] = ZONE_TYPE_BEACH;
        else if(!strcmp(zoneTypeStr, "River", true)) Zones[idx][zType] = ZONE_TYPE_RIVER;
        else if(!strcmp(zoneTypeStr, "Lake", true)) Zones[idx][zType] = ZONE_TYPE_LAKE;
        else if(!strcmp(zoneTypeStr, "Deep Sea", true)) Zones[idx][zType] = ZONE_TYPE_DEEPSEA;
        else Zones[idx][zType] = ZONE_TYPE_LAKE;
        
        cache_get_field_content(0, "time_bonus", Zones[idx][zTimeBonus], connectionID, 32);
        Zones[idx][zTurfID] = cache_get_field_content_int(0, "turf_id");
        Zones[idx][zCreatedBy] = cache_get_field_content_int(0, "created_by");
        Zones[idx][zActive] = true;
        
        CreateZoneVisuals(idx);
        TotalZones++;
        
        new string[128];
        format(string, sizeof(string),
            "{2ECC71}[FISHING]{FFFFFF} Zone created! ID: {3498DB}#%d {FFFFFF}Type: {00FF00}%s {FFFFFF}| Use {FFFF00}/fishzone edit %d",
            insert_id, zoneTypeStr, insert_id);
        SendClientMessage(playerid, -1, string);
        printf("[FISHING ZONES] Admin %d created zone #%d (Type: %s)", playerid, insert_id, zoneTypeStr);
    }
    else SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Failed to load created zone!");
}

stock CleanupZones()
{
    for(new i = 0; i < TotalZones; i++) DestroyZoneVisuals(i);
    printf("[FISHING ZONES] Cleaned up %d zones", TotalZones);
}

// ============================================
// ADMIN PREVIEW SYSTEM
// ============================================

// Preview data for each player
enum E_ZONE_PREVIEW
{
    bool:pActive,
    Float:pRadius,
    pPreviewObjects[ZONE_PREVIEW_OBJECTS],
    pCenterMarker,
    pGangZone,
    Text3D:pLabel
}

new PlayerZonePreview[MAX_PLAYERS][E_ZONE_PREVIEW];

// Initialize preview data
stock InitPlayerZonePreview(playerid)
{
    PlayerZonePreview[playerid][pActive] = false;
    PlayerZonePreview[playerid][pRadius] = 0.0;
    PlayerZonePreview[playerid][pCenterMarker] = INVALID_OBJECT_ID;
    PlayerZonePreview[playerid][pGangZone] = -1;
    PlayerZonePreview[playerid][pLabel] = Text3D:INVALID_3DTEXT_ID;
    for(new i = 0; i < ZONE_PREVIEW_OBJECTS; i++)
        PlayerZonePreview[playerid][pPreviewObjects][i] = INVALID_OBJECT_ID;
}

// Create preview at player position
cmd_fishzone_preview(playerid, Float:radius)
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8) return 1;
    
    if(radius < 10.0 || radius > 200.0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Radius must be 10-200!");
        return 1;
    }
    
    // Remove existing preview
    if(PlayerZonePreview[playerid][pActive])
        cmd_fishzone_hidepreview(playerid, "");
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    // Create preview label
    new labelText[128];
    format(labelText, sizeof(labelText),
        "{FFFF00}ZONE PREVIEW\n{FFFFFF}Radius: {00FFFF}%.1fm\n{FFFFFF}Use /fishzone create to save",
        radius);
    PlayerZonePreview[playerid][pLabel] = Create3DTextLabel(labelText, 0xFFFF00FF,
        x, y, z + 5.0, 50.0, 0, 0);
    
    // Create center marker
    #if defined _streamer_included
    PlayerZonePreview[playerid][pCenterMarker] = CreateDynamicObject(ZONE_MARKER_BUOY,
        x, y, z + 1.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
    #else
    PlayerZonePreview[playerid][pCenterMarker] = CreateObject(ZONE_MARKER_BUOY,
        x, y, z + 1.0, 0.0, 0.0, 0.0, 300.0);
    #endif
    
    // Create gang zone for map
    new Float:minX = x - radius;
    new Float:minY = y - radius;
    new Float:maxX = x + radius;
    new Float:maxY = y + radius;
    
    PlayerZonePreview[playerid][pGangZone] = GangZoneCreate(minX, minY, maxX, maxY);
    GangZoneShowForPlayer(playerid, PlayerZonePreview[playerid][pGangZone], 0xFFFF0066);
    
    // Create radius circle
    new Float:angle = 0.0, Float:angleStep = 360.0 / ZONE_PREVIEW_OBJECTS;
    for(new i = 0; i < ZONE_PREVIEW_OBJECTS; i++)
    {
        new Float:objX = x + (radius * floatcos(angle, degrees));
        new Float:objY = y + (radius * floatsin(angle, degrees));
        
        #if defined _streamer_included
        PlayerZonePreview[playerid][pPreviewObjects][i] = CreateDynamicObject(19135,
            objX, objY, z, 0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
        #else
        PlayerZonePreview[playerid][pPreviewObjects][i] = CreateObject(19135,
            objX, objY, z, 0.0, 0.0, 0.0, 300.0);
        #endif
        
        angle += angleStep;
    }
    
    PlayerZonePreview[playerid][pActive] = true;
    PlayerZonePreview[playerid][pRadius] = radius;
    
    new string[128];
    format(string, sizeof(string),
        "{2ECC71}[FISHING]{FFFFFF} Preview created! Radius: {00FFFF}%.1fm {FFFFFF}| Use {FFFF00}/fishzone hidepreview {FFFFFF}to remove",
        radius);
    SendClientMessage(playerid, -1, string);
    return 1;
}

// Hide preview
cmd_fishzone_hidepreview(playerid, params[])
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8) return 1;
    
    if(!PlayerZonePreview[playerid][pActive])
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} No preview active!");
        return 1;
    }
    
    // Destroy label
    if(PlayerZonePreview[playerid][pLabel] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(PlayerZonePreview[playerid][pLabel]);
        PlayerZonePreview[playerid][pLabel] = Text3D:INVALID_3DTEXT_ID;
    }
    
    // Destroy center marker
    #if defined _streamer_included
    if(PlayerZonePreview[playerid][pCenterMarker] != INVALID_OBJECT_ID)
    {
        DestroyDynamicObject(PlayerZonePreview[playerid][pCenterMarker]);
        PlayerZonePreview[playerid][pCenterMarker] = INVALID_OBJECT_ID;
    }
    #else
    if(PlayerZonePreview[playerid][pCenterMarker] != INVALID_OBJECT_ID)
    {
        DestroyObject(PlayerZonePreview[playerid][pCenterMarker]);
        PlayerZonePreview[playerid][pCenterMarker] = INVALID_OBJECT_ID;
    }
    #endif
    
    // Destroy gang zone
    if(PlayerZonePreview[playerid][pGangZone] != -1)
    {
        GangZoneDestroy(PlayerZonePreview[playerid][pGangZone]);
        PlayerZonePreview[playerid][pGangZone] = -1;
    }
    
    // Destroy preview objects
    for(new i = 0; i < ZONE_PREVIEW_OBJECTS; i++)
    {
        #if defined _streamer_included
        if(PlayerZonePreview[playerid][pPreviewObjects][i] != INVALID_OBJECT_ID)
        {
            DestroyDynamicObject(PlayerZonePreview[playerid][pPreviewObjects][i]);
            PlayerZonePreview[playerid][pPreviewObjects][i] = INVALID_OBJECT_ID;
        }
        #else
        if(PlayerZonePreview[playerid][pPreviewObjects][i] != INVALID_OBJECT_ID)
        {
            DestroyObject(PlayerZonePreview[playerid][pPreviewObjects][i]);
            PlayerZonePreview[playerid][pPreviewObjects][i] = INVALID_OBJECT_ID;
        }
        #endif
    }
    
    PlayerZonePreview[playerid][pActive] = false;
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Preview hidden!");
    return 1;
}

// Call this when player disconnects
stock OnPlayerDisconnectZonePreview(playerid)
{
    if(PlayerZonePreview[playerid][pActive])
        cmd_fishzone_hidepreview(playerid, "");
    InitPlayerZonePreview(playerid);
}

// Show all fishing zones to a player (call on connect/spawn)
stock ShowFishingZonesToPlayer(playerid)
{
    new count = 0;
    for(new i = 0; i < TotalZones; i++)
    {
        if(!Zones[i][zActive]) continue;
        if(Zones[i][zGangZoneID] == -1) continue;
        
        new color = GetZoneTypeGangZoneColor(Zones[i][zType]);
        GangZoneShowForPlayer(playerid, Zones[i][zGangZoneID], color);
        count++;
    }
    
    if(count > 0)
    {
        printf("[FISHING ZONES] Showed %d fishing zones to player %d", count, playerid);
    }
    return count;
}
