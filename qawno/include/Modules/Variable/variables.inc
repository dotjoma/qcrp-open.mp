// Lock Pick System
new
    PlayerText:LockText[12],
    bool:LockUse[MAX_PLAYERS],
    Float:LockProgress = 207.0,
    Float:LockLocation[MAX_PLAYERS],
    Float:LockSize[MAX_PLAYERS],
    LockCount[MAX_PLAYERS],
    LockTimer[MAX_PLAYERS],
    Correct[MAX_PLAYERS],
    VehicleLockedID[MAX_PLAYERS];
new
    Engine[MAX_PLAYERS],
    Lights[MAX_PLAYERS],
    Alarm[MAX_PLAYERS],
    DoorsLockPick[MAX_PLAYERS],
    Bonnet[MAX_PLAYERS],
    Boot[MAX_PLAYERS],
    Objective[MAX_PLAYERS];

// Mechanic System
new mechanicstage[MAX_PLAYERS];
// Hood
new componentpjob[MAX_PLAYERS];
new const TypePaintJob[7] = {-1, 0, 1, 2, 3, 4, 5};
// Hood
new componenthood[MAX_PLAYERS];
new const TypeHood401[2] = {1005, 1004};
new const TypeHood518[1] = {1005};
new const TypeHood589[1] = {1005};
new const TypeHood492[2] = {1005, 1004};
new const TypeHood426[2] = {1005, 1004};
new const TypeHood550[2] = {1005, 1004};
new const TypeHood549[2] = {1011, 1012};
// Vents
new componentvent1[MAX_PLAYERS];
new componentvent2[MAX_PLAYERS];
new const Type1Vent401[2] = {1142, 1144};
new const Type2Vent401[2] = {1143, 1145};
new const Type1Vent518[2] = {1142, 1144};
new const Type2Vent518[2] = {1143, 1145};
new const Type1Vent546[2] = {1142, 1144};
new const Type2Vent546[2] = {1143, 1145};
new const Type1Vent517[2] = {1142, 1144};
new const Type2Vent517[2] = {1143, 1145};
new const Type1Vent603[2] = {1142, 1144};
new const Type2Vent603[2] = {1143, 1145};
new const Type1Vent547[1] = {1142};
new const Type2Vent547[1] = {1143};
new const Type1Vent439[2] = {1142, 1144};
new const Type2Vent439[2] = {1143, 1145};
new const Type1Vent550[2] = {1142, 1144};
new const Type2Vent550[2] = {1143, 1145};
new const Type1Vent549[2] = {1142, 1144};
new const Type2Vent549[2] = {1143, 1145};
// Lights
new componentlights[MAX_PLAYERS];
new const TypeLights401[2] = {1013};
new const TypeLights518[2] = {1013};
new const TypeLights589[2] = {1013, 1024};
new const TypeLights400[2] = {1013, 1024};
new const TypeLights436[1] = {1013};
new const TypeLights439[1] = {1013};
new const TypeLights603[1] = {1024};
// Exhaust
new componentexhaust[MAX_PLAYERS];
new const TypeExhaust562[2] = {1034, 1037};
new const TypeExhaust565[2] = {1046, 1045};
new const TypeExhaust559[2] = {1065, 1066};
new const TypeExhaust558[2] = {1089, 1092};
new const TypeExhaust561[2] = {1064, 1059};
new const TypeExhaust560[2] = {1028, 1029};
new const TypeExhaust575[2] = {1044, 1043};
new const TypeExhaust534[2] = {1126, 1127};
new const TypeExhaust567[2] = {1129, 1132};
new const TypeExhaust536[2] = {1104, 1105};
new const TypeExhaust576[2] = {1136, 1135};
new const TypeExhaust535[2] = {1113, 1114};
new const TypeExhaust401[1] = {1020};
new const TypeExhaust518[3] = {1020, 1019, 1018};
new const TypeExhaust527[3] = {1020, 1021, 1018};
new const TypeExhaust542[4] = {1020, 1021, 1019, 1018};
new const TypeExhaust589[2] = {1020, 1018};
new const TypeExhaust400[4] = {1020, 1021, 1019, 1018};
new const TypeExhaust517[3] = {1020, 1019, 1018};
new const TypeExhaust603[3] = {1021, 1019, 1018};
new const TypeExhaust426[2] = {1021, 1019};
new const TypeExhaust547[4] = {1020, 1021, 1019, 1018};
new const TypeExhaust405[4] = {1020, 1021, 1019, 1018};
new const TypeExhaust580[2] = {1020, 1018};
new const TypeExhaust550[3] = {1020, 1019, 1018};
new const TypeExhaust549[3] = {1020, 1019, 1018};
new const TypeExhaust477[4] = {1020, 1021, 1019, 1018};
new const TypeExhaust436[2] = {1022, 1019};
new const TypeExhaust415[2] = {1018, 1019};
new const TypeExhaust546[2] = {1018, 1019};
// Front Bumber
new componentfbump[MAX_PLAYERS];
new const TypeFBump562[2] = {1171, 1172};
new const TypeFBump565[2] = {1153, 1152};
new const TypeFBump559[2] = {1160, 1173};
new const TypeFBump561[2] = {1155, 1157};
new const TypeFBump558[2] = {1166, 1165};
new const TypeFBump560[2] = {1169, 1170};
new const TypeFBump575[2] = {1174, 1175};
new const TypeFBump534[2] = {1179, 1185};
new const TypeFBump567[2] = {1189, 1188};
new const TypeFBump536[2] = {1182, 1181};
new const TypeFBump576[2] = {1191, 1190};
new const TypeFBump535[2] = {1115, 1116};
// Rear Bumber
new componentrbump[MAX_PLAYERS];
new const TypeRBump562[2] = {1149, 1148};
new const TypeRBump565[2] = {1150, 1151};
new const TypeRBump559[2] = {1159, 1161};
new const TypeRBump561[2] = {1154, 1156};
new const TypeRBump558[2] = {1168, 1167};
new const TypeRBump560[2] = {1141, 1140};
new const TypeRBump575[1] = {1176};
//new const TypeRBump534[2] = {1179, 1185};
//new const TypeRBump567[2] = {1189, 1188};
//new const TypeRBump536[2] = {1182, 1181};
//new const TypeRBump576[2] = {1191, 1190};
//new const TypeRBump535[2] = {1115, 1116};
// Roof
new componentroof[MAX_PLAYERS];
new const TypeRoof562[2] = {1038, 1035};
new const TypeRoof565[2] = {1054, 1053};
new const TypeRoof559[2] = {1067, 1068};
new const TypeRoof561[2] = {1055, 1061};
new const TypeRoof558[2] = {1088, 1091};
new const TypeRoof560[2] = {1032, 1033};
new const TypeRoof567[2] = {1030, 1031};
new const TypeRoof536[2] = {1128, 1103};
new const TypeRoof401[1] = {1106};
new const TypeRoof518[1] = {1106};
new const TypeRoof589[1] = {1106};
new const TypeRoof492[1] = {1106};
new const TypeRoof546[1] = {1106};
new const TypeRoof603[1] = {1106};
new const TypeRoof426[1] = {1106};
new const TypeRoof436[1] = {1106};
new const TypeRoof580[1] = {1106};
new const TypeRoof550[1] = {1106};
new const TypeRoof477[1] = {1106};
// Spoiler
new componetspoiler[MAX_PLAYERS];
new const TypeSpoiler562[2] = {1147, 1146};
new const TypeSpoiler565[2] = {1149, 1150};
new const TypeSpoiler559[2] = {1162, 1158};
new const TypeSpoiler561[2] = {1158, 1160};
new const TypeSpoiler558[2] = {1164, 1163};
new const TypeSpoiler560[2] = {1138, 1139};
new const TypeSpoiler401[2] = {1001, 1003};
new const TypeSpoiler518[4] = {1001, 1023, 1003, 1000};
new const TypeSpoiler527[2] = {1001, 1014};
new const TypeSpoiler415[3] = {1001, 1023, 1003};
new const TypeSpoiler546[3] = {1001, 1023, 1002};
new const TypeSpoiler603[3] = {1001, 1023, 1002};
new const TypeSpoiler426[2] = {1001, 1003};
new const TypeSpoiler436[2] = {1001, 1003};
new const TypeSpoiler405[4] = {1001, 1023, 1000, 1014};
new const TypeSpoiler477[4] = {1001, 1023, 1003, 1001};
new const TypeSpoiler580[2] = {1001, 1023};
new const TypeSpoiler550[2] = {1001, 1023};
new const TypeSpoiler549[3] = {1001, 1023, 1003};
new const TypeSpoiler517[3] = {1002, 1023, 1003};
new const TypeSpoiler547[2] = {1003, 1000};
new const TypeSpoiler492[1] = {1000};
new const TypeSpoiler542[1] = {1014};
// Skirt
new componetskirt1[MAX_PLAYERS];
new componetskirt2[MAX_PLAYERS];
new const Type1Skirt562[2] = {1036, 1039};
new const Type2Skirt562[2] = {1042, 1041};
new const Type1Skirt565[2] = {1047, 1048};
new const Type2Skirt565[2] = {1051, 1052};
new const Type1Skirt559[2] = {1069, 1070};
new const Type2Skirt559[2] = {1071, 1072};
new const Type1Skirt561[2] = {1056, 1057};
new const Type2Skirt561[2] = {1062, 1063};
new const Type1Skirt558[2] = {1090, 1093};
new const Type2Skirt558[2] = {1094, 1095};
new const Type1Skirt560[2] = {1026, 1031};
new const Type2Skirt560[2] = {1027, 1030};
new const Type1Skirt575[1] = {1042};
new const Type2Skirt575[1] = {1099};
new const Type1Skirt536[2] = {1108};
new const Type2Skirt536[2] = {1107};
new const Type1Skirt576[2] = {1134};
new const Type2Skirt576[2] = {1137};
new const Type1Skirt534[2] = {1122, 1106};
new const Type2Skirt534[2] = {1101, 1124};
new const Type1Skirt535[2] = {1118, 1119};
new const Type2Skirt535[2] = {1120, 1121};
new const Type1Skirt401[2] = {1107};
new const Type2Skirt401[2] = {1117};
new const Type1Skirt518[2] = {1107};
new const Type2Skirt518[2] = {1117};
new const Type1Skirt527[2] = {1107};
new const Type2Skirt527[2] = {1117};
new const Type1Skirt415[2] = {1107};
new const Type2Skirt415[2] = {1117};
new const Type1Skirt589[2] = {1107};
new const Type2Skirt589[2] = {1117};
new const Type1Skirt546[2] = {1107};
new const Type2Skirt546[2] = {1117};
new const Type1Skirt517[2] = {1107};
new const Type2Skirt517[2] = {1117};
new const Type1Skirt603[2] = {1107};
new const Type2Skirt603[2] = {1117};
new const Type1Skirt436[2] = {1107};
new const Type2Skirt436[2] = {1117};
new const Type1Skirt439[2] = {1107};
new const Type2Skirt439[2] = {1117};
new const Type1Skirt580[2] = {1107};
new const Type2Skirt580[2] = {1117};
new const Type1Skirt549[2] = {1107};
new const Type2Skirt549[2] = {1117};
new const Type1Skirt477[2] = {1107};
new const Type2Skirt477[2] = {1117};
// Bull Bars
new componentbbar[MAX_PLAYERS];
new const TypeBBar534[3] = {1100, 1123, 1125};
new const TypeBBar535[1] = {1117};
// Wheels
new componentwheel[MAX_PLAYERS];
new const TypeWheels[17] = {1025, 1074, 1076, 1078, 1081, 1082, 1085, 1096, 1097, 1098, 1084, 1073, 1075, 1077, 1079, 1080, 1083};

// Boombox PLayer Music
new GetBBMusicName[MAX_PLAYERS][500];
new GetBBMusicURL[MAX_PLAYERS][500];
new BBMusicList[MAX_PLAYERS][100];

// Player Phonebook System
new GetNamePhoneBook[MAX_PLAYERS][MAX_PLAYER_NAME];
new PhoneBookList[MAX_PLAYERS][100];
new PhoneBookSMS[MAX_PLAYERS];

// Bind System
new pBindData[MAX_PLAYERS][MAX_BINDS];
new pBindTextData[MAX_PLAYERS][MAX_BINDS][254];

new LocalBData[MAX_LOCAL_BUYER][lbuyerenum];

new PlantZoneInfo[MAX_PLANTPOT][ppotEnum];

new PaintballInfo[MAX_PAINTBALL][PBenum];
new PaintballKill[MAX_PLAYERS];

new LabelInfo[MAX_CDYNAMIC_LABEL][CreateLabelEnum];

new RentVInfo[MAX_RENT_VEHICLE][RentVEnum];
new RentedVehicleTime[MAX_VEHICLES];
new RentedVehicleKillTime[MAX_VEHICLES];
new PGInfo[MAX_PUBLICGARAGE][PublicGEnum];

new TollgateData[MAX_TOLLGATES][TollGateEnum];

new BettingInfo[Betting_Info];
new PlayerBetRed[MAX_PLAYERS],
    PlayerBetBlue[MAX_PLAYERS];

new CarVouchData[][carvouch] =
{
    {402, "Buffalo"},
    {411, "Infernus"},
    {415, "Cheetah"},
    {419, "Esperanto"},
    {424, "BF Injection"},
    {429, "Banshee"},
    {431, "Bus"},
    {434, "Hot Knife"},
    {439, "Stallion"},
    {442, "Romero"},
    {444, "Monster"},
    {556, "Monster A"},
    {557, "Monster B"},
    {451, "Turismo"},
    {470, "Patriot"},
    {474, "Hermes"},
    {480, "Comet"},
    {494, "Hotring Racer"},
    {502, "Hotring A"},
    {503, "Hotring B"},
    {504, "Bloodring"},
    {506, "Super GT"},
    {522, "NRG-500"},
    {535, "Slamvan"},
    {541, "Bullet"},
    {545, "Hustler"},
    {559, "Jester"},
    {560, "Sultan"},
    {561, "Stratum"},
    {562, "Elegy"},
    {565, "Flash"},
    {580, "Stafford"},
    {587, "Euros"},
    {603, "Phoenix"},
    {487, "Maverick"}
};

new HotwireData[][ScrambleData] =
{
    {"DEAR", "READ"},
    {"WTERI", "WRITE"},
    {"OBOK", "BOOK"},
    {"SOSNLE", "LESSON"},
    {"NEARL", "LEARN"},
    {"UDYST", "STUDY"},
    {"DUMOLE", "MODULE"},
    {"LCSHOO", "SCHOOL"},
    {"SETON", "NOTES"}
};

new ArrestInfo[MAX_ARREST][ArrestEnum];

new FuelTypeData[212][VehicleFuelType] =
{
    //Fuel Type   	// Arange Vehicle
    {FUEL_DIESEL	}, //Landstalker
    {FUEL_GASOLINA	}, //Bravura
    {FUEL_GASOLINA	}, //Buffalo
    {FUEL_DIESEL	}, //Linerunner
    {FUEL_GASOLINA	}, //Perenial
    {FUEL_GASOLINA	}, //Sentinel
    {FUEL_DIESEL	}, //Dumper
    {FUEL_DIESEL	}, //Firetruck
    {FUEL_DIESEL	}, //Trashmaster
    {FUEL_GASOLINA	}, //Stretch
    {FUEL_GASOLINA	}, //Manana
    {FUEL_GASOLINA	}, //Infernus
    {FUEL_GASOLINA	}, //Voodoo
    {FUEL_DIESEL	}, //Pony
    {FUEL_DIESEL	}, //Mule
    {FUEL_GASOLINA	}, //Cheetah
    {FUEL_DIESEL	}, //Ambulance
    {FUEL_GASOLINA	}, //Leviathan
    {FUEL_GASOLINA	}, //Moonbeam
    {FUEL_GASOLINA	}, //Esperanto
    {FUEL_GASOLINA	}, //Taxi
    {FUEL_GASOLINA	}, //Washington
    {FUEL_DIESEL	}, //Bobcat
    {FUEL_DIESEL	}, //Mr Whoopee
    {FUEL_DIESEL	}, //BF Injection
    {FUEL_GASOLINA	}, //Hunter
    {FUEL_GASOLINA	}, //Premier
    {FUEL_DIESEL	}, //Enforcer
    {FUEL_DIESEL	}, //Securicar
    {FUEL_GASOLINA	}, //Banshee
    {FUEL_GASOLINA	}, //Predator
    {FUEL_DIESEL	}, //Bus
    {FUEL_DIESEL	}, //Rhino
    {FUEL_DIESEL	}, //Barracks
    {FUEL_GASOLINA	}, //Hotknife
    {FUEL_NONE		}, //Artigo Trailer
    {FUEL_GASOLINA	}, //Previon
    {FUEL_DIESEL	}, //Coach
    {FUEL_GASOLINA	}, //Cabbie
    {FUEL_GASOLINA	}, //Stallion
    {FUEL_DIESEL	}, //Rumpo
    {FUEL_GASOLINA	}, //RC Bandit
    {FUEL_GASOLINA	}, //Romero
    {FUEL_DIESEL	}, //Packer
    {FUEL_DIESEL	}, //Monster
    {FUEL_GASOLINA	}, //Admiral
    {FUEL_GASOLINA	}, //Squallo
    {FUEL_GASOLINA	}, //Seasparrow
    {FUEL_GASOLINA	}, //Pizzaboy
    {FUEL_GASOLINA	}, //Tram
    {FUEL_NONE		}, //Artigo Trailer 2
    {FUEL_GASOLINA	}, //Turismo
    {FUEL_GASOLINA	}, //Speeder
    {FUEL_GASOLINA	}, //Reefer
    {FUEL_GASOLINA	}, //Tropic
    {FUEL_DIESEL	}, //Flatbed
    {FUEL_DIESEL	}, //Yankee
    {FUEL_GASOLINA	}, //Caddy
    {FUEL_GASOLINA	}, //Solair
    {FUEL_DIESEL	}, //Berkley's RC Van
    {FUEL_GASOLINA	}, //Skimmer
    {FUEL_GASOLINA	}, //PCJ-600
    {FUEL_GASOLINA	}, //Faggio
    {FUEL_GASOLINA	}, //Freeway
    {FUEL_GASOLINA	}, //RC Baron
    {FUEL_GASOLINA	}, //RC Raider
    {FUEL_GASOLINA	}, //Glendale
    {FUEL_GASOLINA	}, //Oceanic
    {FUEL_GASOLINA	}, //Sanchez
    {FUEL_GASOLINA	}, //Sparrow
    {FUEL_DIESEL	}, //Patriot
    {FUEL_GASOLINA	}, //Quad
    {FUEL_GASOLINA	}, //Coastguard
    {FUEL_GASOLINA	}, //Dinghy
    {FUEL_GASOLINA	}, //Hermes
    {FUEL_GASOLINA	}, //Sabre
    {FUEL_GASOLINA	}, //Rustler
    {FUEL_GASOLINA	}, //ZR-350
    {FUEL_DIESEL	}, //Walton
    {FUEL_DIESEL	}, //Regina
    {FUEL_GASOLINA	}, //Comet
    {FUEL_NONE		}, //BMX
    {FUEL_DIESEL	}, //Burrito
    {FUEL_DIESEL	}, //Camper
    {FUEL_GASOLINA	}, //Marquis
    {FUEL_GASOLINA	}, //Baggage
    {FUEL_DIESEL	}, //Dozer
    {FUEL_GASOLINA	}, //Maverick
    {FUEL_GASOLINA	}, //SAN News Maverick
    {FUEL_DIESEL	}, //Rancher
    {FUEL_DIESEL	}, //FBI Rancher
    {FUEL_GASOLINA	}, //Virgo
    {FUEL_GASOLINA	}, //Greenwood
    {FUEL_GASOLINA	}, //Jetmax
    {FUEL_GASOLINA	}, //Hotring Racer
    {FUEL_DIESEL	}, //Sandking
    {FUEL_GASOLINA	}, //Blista Compact
    {FUEL_GASOLINA	}, //Police Maverick
    {FUEL_DIESEL	}, //Boxville
    {FUEL_DIESEL	}, //Benson
    {FUEL_DIESEL	}, //Mesa
    {FUEL_GASOLINA	}, //RC Goblin
    {FUEL_GASOLINA	}, //Hotring Racer
    {FUEL_GASOLINA	}, //Hotring Racer
    {FUEL_GASOLINA	}, //Bloodring Banger
    {FUEL_DIESEL	}, //Rancher
    {FUEL_GASOLINA	}, //Super GT
    {FUEL_GASOLINA	}, //Elegant
    {FUEL_DIESEL	}, //Journey
    {FUEL_NONE		}, //Bike
    {FUEL_NONE		}, //Mountain Bike
    {FUEL_GASOLINA	}, //Beagle
    {FUEL_GASOLINA	}, //Cropduster
    {FUEL_GASOLINA	}, //Stuntplane
    {FUEL_DIESEL	}, //Tanker
    {FUEL_DIESEL	}, //Roadtrain
    {FUEL_GASOLINA	}, //Nebula
    {FUEL_GASOLINA	}, //Majestic
    {FUEL_GASOLINA	}, //Buccaneer
    {FUEL_GASOLINA	}, //Shamal
    {FUEL_GASOLINA	}, //Hydra
    {FUEL_GASOLINA	}, //FCR-900
    {FUEL_GASOLINA	}, //NRG-500
    {FUEL_GASOLINA	}, //Cop Bike HPV1000
    {FUEL_DIESEL	}, //Cement Truck
    {FUEL_DIESEL	}, //Towtruck
    {FUEL_GASOLINA	}, //Fortune
    {FUEL_GASOLINA	}, //Cadrona
    {FUEL_DIESEL	}, //FBI Truck
    {FUEL_GASOLINA	}, //Willard
    {FUEL_DIESEL	}, //Forklift
    {FUEL_DIESEL	}, //Tractor
    {FUEL_DIESEL	}, //Combine Harvester
    {FUEL_GASOLINA	}, //Feltzer
    {FUEL_GASOLINA	}, //Remington
    {FUEL_DIESEL	}, //Slamvan
    {FUEL_GASOLINA	}, //Blade
    {FUEL_DIESEL	}, //Freight (Train)
    {FUEL_DIESEL	}, //Brownstreak (Train)
    {FUEL_GASOLINA	}, //Vortex
    {FUEL_GASOLINA	}, //Vincent
    {FUEL_GASOLINA	}, //Bullet
    {FUEL_GASOLINA	}, //Clover
    {FUEL_DIESEL	}, //Sadler
    {FUEL_DIESEL	}, //Firetruck LA
    {FUEL_GASOLINA	}, //Hustler
    {FUEL_GASOLINA	}, //Intruder
    {FUEL_GASOLINA	}, //Primo
    {FUEL_GASOLINA	}, //Cargobob
    {FUEL_GASOLINA	}, //Tampa
    {FUEL_GASOLINA	}, //Sunrise
    {FUEL_GASOLINA	}, //Merit
    {FUEL_DIESEL	}, //Utility Van
    {FUEL_GASOLINA	}, //Nevada
    {FUEL_DIESEL	}, //Yosemite
    {FUEL_GASOLINA	}, //Windsor
    {FUEL_DIESEL	}, //Monster "A"
    {FUEL_DIESEL	}, //Monster "B"
    {FUEL_GASOLINA	}, //Uranus
    {FUEL_GASOLINA	}, //Jester
    {FUEL_GASOLINA	}, //Sultan
    {FUEL_GASOLINA	}, //Stratum
    {FUEL_GASOLINA	}, //Elegy
    {FUEL_GASOLINA	}, //Raindance
    {FUEL_GASOLINA	}, //RC Tiger
    {FUEL_GASOLINA	}, //Flash
    {FUEL_GASOLINA	}, //Tahoma
    {FUEL_GASOLINA	}, //Savanna
    {FUEL_GASOLINA	}, //Bandito
    {FUEL_NONE		}, //Freight Flat Trailer (Train)
    {FUEL_NONE		}, //Streak Trailer (Train)
    {FUEL_GASOLINA	}, //Kart
    {FUEL_DIESEL	}, //Mower
    {FUEL_DIESEL	}, //Dune
    {FUEL_DIESEL	}, //varrerer
    {FUEL_GASOLINA	}, //Broadway
    {FUEL_GASOLINA	}, //Tornado
    {FUEL_GASOLINA	}, //AT400
    {FUEL_DIESEL	}, //DFT-30
    {FUEL_DIESEL	}, //Huntley
    {FUEL_GASOLINA	}, //Stafford
    {FUEL_GASOLINA	}, //BF-400
    {FUEL_DIESEL	}, //Newsvan
    {FUEL_GASOLINA	}, //Tug
    {FUEL_NONE		}, //Petrol Trailer
    {FUEL_GASOLINA	}, //Emperor
    {FUEL_GASOLINA	}, //Wayfarer
    {FUEL_GASOLINA	}, //Euros
    {FUEL_DIESEL	}, //Hotdog
    {FUEL_GASOLINA	}, //Club
    {FUEL_NONE		}, //Freight Box Trailer (Train)
    {FUEL_NONE		}, //Artigo Trailer 3
    {FUEL_GASOLINA	}, //Andromada
    {FUEL_GASOLINA	}, //Dodo
    {FUEL_GASOLINA	}, //RC Cam
    {FUEL_GASOLINA	}, //Launch
    {FUEL_GASOLINA	}, //Police Car (LSPD)
    {FUEL_GASOLINA	}, //Police Car (SFPD)
    {FUEL_GASOLINA	}, //Police Car (LVPD)
    {FUEL_DIESEL	}, //Police Ranger
    {FUEL_GASOLINA	}, //Picador
    {FUEL_DIESEL	}, //S.W.A.T.
    {FUEL_GASOLINA	}, //Alpha
    {FUEL_GASOLINA	}, //Phoenix
    {FUEL_GASOLINA	}, //Glendale Shit
    {FUEL_GASOLINA	}, //Sadler Shit
    {FUEL_NONE		}, //Baggage Trailer "A"
    {FUEL_NONE		}, //Baggage Trailer "B"
    {FUEL_NONE		}, //Tug Stairs Trailer
    {FUEL_DIESEL	}, //Boxville
    {FUEL_NONE		}, //Farm Trailer
    {FUEL_NONE		} //Utility Trailer
};

new PoolInfo[MAX_POOL][POOL_ENUM];
new CueTimer[MAX_PLAYERS] = {-1, ...};
new Float:CuePower[MAX_PLAYERS];
new Float:CueAimAngle[MAX_PLAYERS][2];
new PoolDir[MAX_PLAYERS];
new AimObject[MAX_PLAYERS];
new Text:PoolTD[4];

new DeliverInfo[MAX_DELIVERPT][DeliverEnum];

new ActorInfo[MAX_DYNAMIC_ACTORS][ActorEnum];

new
	OreData[MAX_ORE_TYPES][e_ores] = {
		// name,   		color,     		modifier, spawn amount, value, mining rate
	    {"Copper", 		0xB87333FF, 	0.75, 		8, 			100, 	65},
	    {"Amethyst", 	0x9B59B6FF, 	0.60, 		6, 			300, 	58},
	    {"Emerald", 	0x2ECC71FF, 	0.40, 		4, 			500, 	50},
		{"Ruby", 		0xD10056FF, 	0.35, 		3, 			1000, 	55},
		{"Sapphire", 	0x0F52BAFF,		0.30, 		3, 			1500, 	45},
        {"Gold", 		0xFFD700FF, 	0.25, 		4, 			1000, 	40}
	};

new
	VeinData[MAX_VEINS][e_veins],
	DroppedOres[MAX_ORES][e_droppedores];

new
	MiningVein[MAX_PLAYERS] = {-1, ...},
	MiningTimer[MAX_PLAYERS] = {-1, ...},
	CarryingOre[MAX_PLAYERS] = {-1, ...},
	LoadingPoint[MAX_PLAYERS] = {-1, ...},
	PlayerBar: MiningBar[MAX_PLAYERS] = {INVALID_PLAYER_BAR_ID, ...};

new
	LoadedOres[MAX_VEHICLES][MAX_ORE_TYPES];

new
	DropPoints[][e_droppoints] = {
	// location, x, y, z
	    //{"Las Venturas", 2489.462646, 2773.271240, 10.789896},
		//{"San Fierro", -1830.025878, 164.676559, 15.117187},
		{"Drop Point", 328.702575, 861.540222, 20.406250}
	};
new
    PointIcons[MAX_PLAYERS][sizeof(DropPoints)];

// Faction Banned
new PlayerFactionBanLift[MAX_PLAYERS];

// DISCORD BOT ACTIVITY
new DCC_Role: REMDCROLE;
new DCC_Role: DCROLE;
new DCC_Guild: GUILDSVR;
new DCBOTPLAYER;

new
	GiftBoxData[MAX_GIFT_BOXES][E_GIFT_BOX];
new
	DropGiftBoxSAData[OPRP_DROP_BOX];

// VEHICLE WITH INTERIOR
new Injourney[MAX_PLAYERS];
new InEnforcer[MAX_PLAYERS];

// Anti Spawn Broken Leg
new AntiBrokenLeg[MAX_PLAYERS];

// FIREWORKS
new Rocket[MAX_LAUNCH];
new RocketLight[MAX_LAUNCH];
new RocketSmoke[MAX_LAUNCH];
new RocketExplosions[MAX_LAUNCH];
new Float:rocketx[MAX_LAUNCH];
new Float:rockety[MAX_LAUNCH];
new Float:rocketz[MAX_LAUNCH];
new FireworkTotal;
new Fired;

// LOTTERY
new gLottoTimer, gDrawNumber, gLotto, LottoStarted;

// Damage System

new Text3D:status_upd[MAX_PLAYERS];

new pTemp[MAX_PLAYERS][PLAYER_TEMP_ENUM];

new ContinueDamage[MAX_PLAYERS];

new DamageInfo[MAX_PLAYERS][MAX_DAMAGES][DAMAGE_ENUM];
