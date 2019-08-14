--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- mapinfo.lua
--

local mapinfo = {
	name        = "River Of Flame",
	shortname   = "riverofflame",
	description = "River of Flame! East vs West recommended. 2-8 players.",
	author      = "raaar",
	version     = "v1.2",
	--mutator   = "deployment";
	mapfile   = "maps/riverofflame.smf", --// location of smf/sm3 file (optional)
	modtype     = 3, --// 1=primary, 0=hidden, 3=map
	depend      = {},
	replace     = {},

	--startpic   = "", --// deprecated
	--StartMusic = "", --// deprecated

	maphardness     = 400,
	notDeformable   = false,
	gravity         = 130,
	tidalStrength   = 0,
	maxMetal        = 6.00,
	extractorRadius = 32.0,
	voidWater       = true,
	autoShowMetal   = true,


	smf = {
		minheight = -100,
		maxheight = 1000,
		smtFileName0 = "maps/riverofflame.smt",
		--smtFileName1 = "",
		--smtFileName.. = "",
		--smtFileNameN = "",
	},

	sound = {
		--// Sets the _reverb_ preset (= echo parameters),
		--// passfilter (the direct sound) is unchanged.
		--//
		--// To get a list of all possible presets check:
		--//   https://github.com/spring/spring/blob/master/rts/System/Sound/EFXPresets.cpp
		--//
		--// Hint:
		--// You can change the preset at runtime via:
		--//   /tset UseEFX [1|0]
		--//   /tset snd_eaxpreset preset_name   (may change to a real cmd in the future)
		--//   /tset snd_filter %gainlf %gainhf  (may    "   "  "  "    "  "   "    "   )
		preset = "default",

		passfilter = {
			--// Note, you likely want to set these
			--// tags due to the fact that they are
			--// _not_ set by `preset`!
			--// So if you want to create a muffled
			--// sound you need to use them.
			gainlf = 1.0,
			gainhf = 1.0,
		},

		reverb = {
			--// Normally you just want use the `preset` tag
			--// but you can use handtweak a preset if wanted
			--// with the following tags.
			--// To know their function & ranges check the
			--// official OpenAL1.1 SDK document.
			
			--density
			--diffusion
			--gain
			--gainhf
			--gainlf
			--decaytime
			--decayhflimit
			--decayhfratio
			--decaylfratio
			--reflectionsgain
			--reflectionsdelay
			--reflectionspan
			--latereverbgain
			--latereverbdelay
			--latereverbpan
			--echotime
			--echodepth
			--modtime
			--moddepth
			--airabsorptiongainhf
			--hfreference
			--lfreference
			--roomrollofffactor
		},
	},

	resources = {
		--grassBladeTex = "",
		--grassShadingTex = "",
		detailTex = "maps/detailtexbright.bmp",
		--specularTex = "",
		--splatDetailTex = "",
		--splatDistrTex = "",
		--skyReflectModTex = "",
		--detailNormalTex = "",
		--lightEmissionTex = "",
	},

	splats = {
		texScales = {0.02, 0.02, 0.02, 0.02},
		texMults  = {1.0, 1.0, 1.0, 1.0},
	},

	atmosphere = {
		minWind      = 5.0,
		maxWind      = 20.0,

		fogStart     = 0.5,
		fogEnd       = 1.0,
		fogColor     = {0.7, 0.5, 0.4},

		sunColor     = {1.0, 1.0, 1.0},
		skyColor     = {0.9, 0.9, 1.0},
		skyDir       = {0.0, 0.0, -10.0},
		skyBox       = "",

		cloudDensity = 0.5,
		cloudColor   = {1.0, 1.0, 1.0},
	},

	grass = {
		bladeWaveScale = 1.0,
		bladeWidth  = 0.32,
		bladeHeight = 4.0,
		bladeAngle  = 1.57,
		bladeColor  = {0.59, 0.81, 0.57}, --// does nothing when `grassBladeTex` is set
	},

	lighting = {
		--// dynsun
		sunStartAngle = 0.0,
		sunOrbitTime  = 1440.0,
		sunDir        = {0.3, 1.0, 1},

		--// unit & ground lighting
		groundAmbientColor  = {1.0, 1.0, 1.0},
		groundDiffuseColor  = {1.0, 1.0, 1.0},
		groundSpecularColor = {0.0, 0.0, 0.0},
		groundShadowDensity = 0.8,
		unitAmbientColor    = {0.5, 0.5, 0.5},
		unitDiffuseColor    = {0.7, 0.7, 0.7},
		unitSpecularColor   = {0.7, 0.7, 0.7},
		unitShadowDensity   = 0.8,
		
		specularExponent    = 100.0,
	},
	
	
	water = {
		damage =  100.0,

		repeatX = 0.0,
		repeatY = 0.0,

		absorb    = {0.0, 0.0, 0.0},
		baseColor = {0.8, 0.6, 0.2},
		minColor  = {0.8, 0.6, 0.2},

		ambientFactor  = 0.0,
		diffuseFactor  = 0.0,
		specularFactor = 0.0,
		specularPower  = 20.0,

		planeColor = {0.5, 0.5, 0.5},

		surfaceColor  = {0.8, 0.6, 0.2},
		surfaceAlpha  = 1.0,
		diffuseColor  = {0.8, 0.6, 0.2},
		specularColor = {0.8, 0.6, 0.2},

		fresnelMin   = 0.2,
		fresnelMax   = 0.8,
		fresnelPower = 4.0,

		reflectionDistortion = 1.0,

		blurBase      = 2.0,
		blurExponent = 1.5,

		perlinStartFreq  =  8.0,
		perlinLacunarity = 3.0,
		perlinAmplitude  =  0.9,
		windSpeed = 1.0, --// does nothing yet

		shoreWaves = false,
		forceRendering = false,

		--// undefined == load them from resources.lua!
		--texture =       "",
		--foamTexture =   "",
		--normalTexture = "",
		--caustics = {
		--	"",
		--	"",
		--},
	},

	teams = {
		[0] = {startPos = {x = 500, z = 500}},		-- nw
		[2] = {startPos = {x = 500, z = 6144-500}},		-- sw
		
		[1] = {startPos = {x = 7168-500, z = 6144-500}},	--se
		[3] = {startPos = {x = 7168-500, z = 500}},		-- ne

	},

	terrainTypes = {
		[0] = {
			name = "Ground",
			hardness = 1.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},
		[255] = {
			name = "Lava",
			hardness = 1000.0,
			receiveTracks = false,
			moveSpeeds = {
				tank  = 0.0,
				kbot  = 0.0,
				hover = 0.0,
				ship  = 0.0,
			},
		},	
	},

	custom = {
		zkminwindmult = 0.4,
		fog = {
			color    = {1.0, 1.0, 1.0},
			height   = "30%", --// allows either absolute sizes or in percent of map's MaxHeight
			fogatten = 0.003, -- 0.003
		},
	},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Helper

local function lowerkeys(ta)
	local fix = {}
	for i,v in pairs(ta) do
		if (type(i) == "string") then
			if (i ~= i:lower()) then
				fix[#fix+1] = i
			end
		end
		if (type(v) == "table") then
			lowerkeys(v)
		end
	end
	
	for i=1,#fix do
		local idx = fix[i]
		ta[idx:lower()] = ta[idx]
		ta[idx] = nil
	end
end

lowerkeys(mapinfo)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Map Options

if (Spring and Spring.GetMapOptions) then
	local function tmerge(t1, t2)
		for i,v in pairs(t2) do
			if (type(v) == "table") then
				t1[i] = t1[i] or {}
				tmerge(t1[i], v)
			else
				t1[i] = v
			end
		end
	end

	getfenv()["mapinfo"] = mapinfo
		local files = VFS.DirList("mapconfig/mapinfo/", "*.lua")
		table.sort(files)
		for i=1,#files do
			local newcfg = VFS.Include(files[i])
			if newcfg then
				lowerkeys(newcfg)
				tmerge(mapinfo, newcfg)
			end
		end
	getfenv()["mapinfo"] = nil
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return mapinfo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
