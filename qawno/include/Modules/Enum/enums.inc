enum inventoryData
{
	invExists,
	invItem[32 char],
	invModel,
	invAmount,
	invTotalQuantity
};

enum e_InventoryItems
{
	e_InventoryItem[32],// Item Name
	e_InventoryModel,	// Object Model
	e_InventoryTotal    // Item Quantity
};

enum
{
    MECHANIC_TYPE_HOOD = 1,
    MECHANIC_TYPE_VENT = 2,
    MECHANIC_TYPE_LIGHTS = 3,
    MECHANIC_TYPE_EXHAUST = 4,
    MECHANIC_TYPE_FBUMPER = 5,
    MECHANIC_TYPE_RBUMPER = 6,
    MECHANIC_TYPE_ROOF = 7,
    MECHANIC_TYPE_SPOILER = 8,
    MECHANIC_TYPE_SKIRT = 9,
    MECHANIC_TYPE_BBAR = 10,
    MECHANIC_TYPE_WHEEL = 11,
	MECHANIC_TYPE_PAINTJOB = 12
};

// Local Buyer System
enum lbuyerenum
{
    lBuyerID,
    lBuyerActor,
	lBuyerType,
	lBuyerSkin,
	lBuyerExists,
	lBuyerName[40],
	Float:lBuyerPosX,
	Float:lBuyerPosY,
	Float:lBuyerPosZ,
	Float:lBuyerPosA,
	lBuyerWorld,
	Text3D:lBuyerText
};

// Plant Pot System
enum ppotEnum
{
	pPotExists,
	pPotID,
	Float:pPotMinX,
	Float:pPotMinY,
	Float:pPotMaxX,
	Float:pPotMaxY,
	Float:pPotHeight,
	Float:pPotX,
	Float:pPotY,
	Float:pPotZ,
	pPotZone,
	pPotArea,
	pPotLabels,
 	Text3D:pPotText,
	pPotPickup
};

// Paintball System
enum PBenum
{
	PBArenaExists,
	PBArenaID,
	PBArenaName[40],
	PBArenaHealth,
	PBArenaArmor,
	PBArenaIcon,
	PBArenaCbug,
    PBArenaType,
    PBArenaMoney,
	PBArenaTime,
	PBArenaReady,
	PBArenaWeapon[3],
	PBArenaPassword[40],
	Float:PBArenaPosX[5],
	Float:PBArenaPosY[5],
	Float:PBArenaPosZ[5],
	Float:PBArenaPosA[5],
	PBArenaInterior,
	PBArenaWorld,
	PBArenaPickup,
	Text3D:PBArenaText
};

// Dynamic Label
enum CreateLabelEnum
{
	ClabelExists,
	ClabelID,
	ClabelName[40],
	ClabelIcon,
    ClabelType,
	Float:ClabelPosX,
	Float:ClabelPosY,
	Float:ClabelPosZ,
	ClabelInterior,
	ClabelWorld,
	ClabelPickup,
	Text3D:ClabelText
};

// Dynamic Rent Vehicle
enum RentVEnum
{
	RentVExists,
	RentVID,
	RentVName[40],
	RentVIcon,
	Float:RenVPosX,
	Float:RenVPosY,
	Float:RenVPosZ,
	RentVInterior,
	RentVWorld,
	RentVPickup,
	Text3D:RentVText
};

// Dynamic Public Garage
enum PublicGEnum
{
	PGexists,
	PGID,
	PGName[40],
	PGIcon,
	Float:PGPosX,
	Float:PGPosY,
	Float:PGPosZ,
	Float:PGSpawnPosX,
	Float:PGSpawnPosY,
	Float:PGSpawnPosZ,
	PGInterior,
	PGWorld,
	PGPickup,
	PGMIcon,
	Text3D:PGText
};

// Dynamic Tollgate
enum TollGateEnum {
	TollgateID,
	TollgateExists,
	TollgateOpened,
	TollgateModel,
	TollgateTime,
	TollgateInterior,
	TollgateWorld,
	TollgateLinkID,
	TollgatePass[32],
	TollgateTimer,
	TollgateObject,
	Float:TollgateSpeed,
	Float:TollgateRadius,
	Float:TollgatePos[6],
	Float:TollgateMove[6]
};

// Sabong System
enum Betting_Info
{
    bool:Started,
    bool:Closed,
    BetTime,
    RedTotalBet,
    BlueTotalBet,
    PlayerBlueID,
    PlayerRedID,
    RedPercentage,
    BluePercentage
}

// Voucher System
enum carvouch
{
    vouchVehicleModel,
    vouchVehicleName[128]
};

// Hotwire System
enum ScrambleData
{
	ScrambleWords[125],
	eUnscrambledWord[125]
};

// Arrest Point
enum ArrestEnum
{
	ArrestPointExists,
	ArrestPointID,
	Float:ArrestPointX,
	Float:ArrestPointY,
	Float:ArrestPointZ,
	ArrestPointInterior,
	ArrestPointWorld,
	ArrestPointPickup,
	Text3D:ArrestPointText
};

// Fuel Type
enum VehicleFuelType
{
	fFuelType
}

// BILLIARDS
enum POOL_ENUM
{
    bID,
    bBalls[16],
    bTable,
    bInterior,
    bWorld,
    bUsed,
    bPlayer1,
    bPlayer2,
    bCurrentShooter,
    bLastShooter,
    Float:bPosX,
    Float:bPosY,
    Float:bPosZ,
};

// Deliver PT
enum DeliverEnum
{
	DeliverExists,
	DeliverID,
	DeliverName[40],
	DeliverIcon,
    DeliverType,
	Float:DeliverPosX,
	Float:DeliverPosY,
	Float:DeliverPosZ,
	DeliverInterior,
	DeliverWorld,
	DeliverPickup,
	Text3D:DeliverText
};

// Dynamic Actor - By Tokyo
enum ActorEnum
{
    ActorID,
    DynamicActor,
    ActorAnim,
	ActorSkin,
	ActorExists,
	ActorName[40],
	Float:ActorPosX,
	Float:ActorPosY,
	Float:ActorPosZ,
	Float:ActorPosA,
	ActorWorld,
	Text3D:ActorText
};

// ORE MINING
enum e_ores
{
	oreName[16],
	oreColor,
	Float: oreModifier,
	oreAmount, // how many of this ore spawns in a vein
	oreValue, // value of this ore
	oreRate // successful mining rate
}

enum e_veins
{
	veinType,
	veinAmount,
	bool: BeingMined,
	VeinObject,
	Text3D: VeinLabel,
	bool: VeinExists
}

enum e_dialogs
{
    DIALOG_ORE_INFO = 18740,
    DIALOG_ORE_TAKE
}

enum e_droppedores
{
	dropType,
	OreTimer,
	OreObject,
	Text3D: OreLabel,
	bool: OreExists
}

enum e_droppoints
{
	dropLocation[32],
	Float: dropPointX,
	Float: dropPointY,
	Float: dropPointZ,
	dropPointCP,
	Text3D: dropPointLabel
}

// GIFTBOXES
enum 	E_SAZONE_MAIN
{
	SAZONE_NAME[MAX_ZONE_NAME],
	Float: SAZONE_AREA[6]
}
enum    OPRP_DROP_BOX
{
	DropTimeLeft,
	EventTimer
}
enum    E_GIFT_BOX_COORDS
{
	Float: GiftBoxSpawnX,
	Float: GiftBoxSpawnY,
	Float: GiftBoxSpawnZ
}
enum    E_GIFT_BOX
{
	Float: GiftBoxX,
	Float: GiftBoxY,
	Float: GiftBoxZ,
	GiftBoxTimeLeft,
	GiftBoxPickup,
	Text3D: GiftBoxLabel,
	GiftBoxTimer,
	bool: GiftBoxExists
}

enum PLAYER_TEMP_ENUM
{
    pDamagesCount,
    pInjuredTime,
    pInjuredLegTime,
    pDialogList,
    Float:pInvulnerable,
    pHelpUp3dText,
    UsingCorpse,
	UsingBort
}

enum DAMAGE_ENUM
{
	damageOn,
	damageWeapon,
	damageBodypart,
	Float:damageAmount,
	damageArmour,
	damageTime,
	damageBy[MAX_PLAYER_NAME]
};