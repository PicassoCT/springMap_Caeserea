--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- mapinfo.lua
--

local mapinfo = {
	name        = "Caeserea",
	shortname   = "Caeserea",
	description = "a city by the desert. Proudly made with Springboard",
	author      = "PicassoCT",
	version     = "6",
	--mutator   = "deployment";
	--mapfile   = "", --// location of smf/sm3 file (optional)
	modtype     = 3, --// 1=primary, 0=hidden, 3=map
	depend      = {"Map Helper v1"},
	replace     = {},

	--startpic   = "", --// deprecated
	--StartMusic = "", --// deprecated

	maphardness     = 100,
	notDeformable   = false,
	gravity         = 130,
	tidalStrength   = 0,
	maxMetal        = 6.00,
	extractorRadius = 32.0,
	voidWater       = false,
	autoShowMetal   = true,


	smf = {
		minheight = -275,--589 -- -260
		maxheight = 273,--1152
		--smtFileName0 = "",
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
		grassBladeTex = "grassbladetex.bmp",
		grassShadingTex = "grassshading.bmp",
		detailTex = "terradetail.bmp",
		specularTex = "spec.tif",
		splatDetailTex = "splatt.tif",
		splatDistrTex = "splatd.tif",
		--skyReflectModTex = "",
		--detailNormalTex = "",
		--lightEmissionTex = "",
	},

	splats = {
	--	texScales = {0.02, 0.006125, 0.003125, 0.006125},
		texScales = {0.01, 0.006125, 0.003125, 0.006125},
		texMults  = {2.14159, 1.414, 1.9141, 0.91},
	},

atmosphere = {

		minWind      = 2,
		maxWind      = 30,

		fogStart     = 0.9,
		fogEnd       = 1.0,
		fogColor     = {0.0, 0.0, 0.0},

		sunColor     = {1.0, 0.5, 0.4},
		skycolor     = {0.9, 0.1, 0.0},
		skyDir       = {0.0, 0.0, -1.0},
		skyBox       = "yellowclouds.dds",

		cloudDensity = 0.65,
		cloudColor   = {0.1, 0.1, 1},
	},

	grass = {
		bladeWaveScale = 3.0,
		bladeWidth  = 0.4,
		bladeHeight = 4.3,
		bladeAngle  = 1.57,
		bladeColor  = {0.26, 0.46, 0.03}, --// does nothing when `grassBladeTex` is set
	},

	lighting = {
		--// dynsun
		sunStartAngle = 0.0,
		sunOrbitTime  = 1440.0,
		sundir        = { -0.5, 0.5, 0.5 },

		--// unit & ground lighting
         groundambientcolor            = { 0.94, 0.64, 0.74 },
         grounddiffusecolor            = { 1.0, 0.75, 0.8 },
         groundshadowdensity           = 0.95,
         unitambientcolor           = { 0.85, 0.55, 0.65 },
         unitdiffusecolor           = { 1.0, 0.75, 0.8 },
         unitshadowdensity          = 0.95,
		 specularsuncolor           = { 1.0, 0.65, 0.75 },
		 
		specularExponent    = 100.0,
	},
	
	water = {
		damage =  0,

		repeatX = 0.0,
		repeatY = 0.0,

		absorb    = { 0.012, 0.006, 0.0045 },
		basecolor = { 0.70, 0.9, 1.0 },
		mincolor  = { 0.02, 0.45, 0.65 },

		ambientFactor  = 1.3,
		diffuseFactor  = 1.0,
		specularFactor = 1.4,
		specularPower  = 40.0,

		surfacecolor  = { 0.6, 0.54, 0.86 },
		surfaceAlpha  = 0.16,
		--diffuseColor  = {0.0, 0.0, 0.0},
		specularColor = {0.5, 0.5, 0.5},
		--planeColor = {0.0, 0.0, 0.0},

		fresnelMin   = 0.3,
		fresnelMax   = 0.8,
		fresnelPower = 8.0,

		reflectionDistortion = 1.0,

		blurBase      = 2.0,
		blurExponent = 1.5,

		perlinStartFreq  =  8.0,
		perlinLacunarity = 3.0,
		perlinAmplitude  =  0.9,
		windSpeed = 1.0, --// does nothing yet

		shoreWaves = true,
		forceRendering = false,
		
		hasWaterPlane = false,

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
		[0] = {startPos = {x = 256, z = 256}},
		[1] = {startPos = {x = 4096-256, z = 256}},
		[2] = {startPos = {x = 4096-256, z = 4096-256}},
		[3] = {startPos = {x = 256, z = 4096-256}},
	},

	terrainTypes = {
		[0] = {
			name = "Default",
			hardness = 1.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},
	},

	custom = {
		fog = {
			color    = {0.26, 0.30, 0.41},
			height   = "80%", --// allows either absolue sizes or in percent of map's MaxHeight
			fogatten = 0.003,
		},
		precipitation = {
			density   = 30000,
			size      = 1.5,
			speed     = 50,
			windscale = 1.2,
			texture   = 'LuaGaia/effects/snowflake.png',
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
