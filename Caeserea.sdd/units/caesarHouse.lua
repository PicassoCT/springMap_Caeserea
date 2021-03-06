local unitName = "caesarhouse"

	local unitDef = {
	name = "",
	Description = "House of the great family of ..",
	objectName = "caesarHouse.s3o",
	script = "caesareaHouse.lua",
	buildPic = "placeholder.png",
	levelGround =false,
	--cost
	buildCostMetal = 15,
	buildCostEnergy = 1,
	buildTime = 1,
	--Health
	maxDamage = 6660,
	idleAutoHeal = 15,
	autoheal=10,
	--Movement
	mass=18020,
	upRight=true,
	blocking=false,
	pushResistant=true,
	Acceleration = 0.0000001,
	BrakeRate = 0.0001,
	FootprintX = 4,
	FootprintZ = 4,


	sightDistance = 80,

	reclaimable=false,
	Builder = false,
	CanAttack = true,
	CanGuard = false,
	CanMove = true,
	CanPatrol = false,
	CanStop = true,
	LeaveTracks = false,
	useSmoothMesh = false,

	 corpse             = "lavafeature",
	 

	 
	  customParams = {},
	 sfxtypes = {
		explosiongenerators = {	    
					   "custom:spawnpointicon",
					   "custom:factory_explosion",
					   "custom:flames",
					   "custom:glowsmoke",
					   "custom:blackerthensmoke",
					   "custom:LightUponSmoke",  
							  },
		
				},

	 
	 
	Category = [[LAND]],




}

return lowerkeys({ [unitName] = unitDef })