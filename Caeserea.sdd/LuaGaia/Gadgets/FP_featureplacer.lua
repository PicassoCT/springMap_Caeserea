function gadget:GetInfo()
	return {
		name      = "feature placer",
		desc      = "Spawns Features and Units",
		author    = "Gnome, Smoth",
		date      = "August 2008",
		license   = "PD",
		layer     = 452,
		enabled   = true  --  loaded by default?
	}
end



if (not gadgetHandler:IsSyncedCode()) then
  return false
end

if (Spring.GetGameFrame() >= 1) then
  return false
end

local SetUnitNeutral        = Spring.SetUnitNeutral
local SetUnitBlocking       = Spring.SetUnitBlocking
local SetUnitRotation       = Spring.SetUnitRotation
local SetUnitAlwaysVisible  = Spring.SetUnitAlwaysVisible
local CreateUnit            = Spring.CreateUnit
local CreateFeature         = Spring.CreateFeature

local featurecfg
local featureslist
local buildinglist
local unitlist


if VFS.FileExists("mapconfig/featureplacer/config.lua") then
	featurecfg = VFS.Include("mapconfig/featureplacer/config.lua")
	
	featureslist = featurecfg.objectlist
	buildinglist = featurecfg.buildinglist
	unitlist     = featurecfg.unitlist
else
	Spring.Echo("Featureplacer: missing file")
	Spring.Echo("Featureplacer: No features loaded")
end
convertDegToRot = function (degVal)
vx,vz =math.cos(math.rad(degVal)%math.pi),math.sin(math.rad(degVal)%math.pi)
return Spring.GetHeadingFromVector(vx,vz)..""
end

if ( featurecfg ) then
	local gaiaID = Spring.GetGaiaTeamID()

	if ( featureslist ) then
		for i,fDef in pairs(featureslist) do
			local flagID = CreateFeature(fDef.name, fDef.x, Spring.GetGroundHeight(fDef.x,fDef.z)+5, fDef.z, fDef.rot)
		end
	end

	if ( buildinglist ) then
		local los_status = {los=true, prevLos=true, contRadar=true, radar=true}
		for i,uDef in pairs(unitlist) do
			local flagID = CreateUnit(uDef.name, uDef.x, 0, uDef.z, 1, gaiaID)

			rotVal= ( convertDegToRot(uDef.rot) * -math.pi) / 32768,
			Spring.SetUnitRotation(flagID, 0, rotVal, 0)
			Spring.SetUnitNeutral(flagID,true)
			Spring.SetUnitLosState(flagID,0,los_status)
			SetUnitAlwaysVisible(flagID,true)
			SetUnitBlocking(flagID,true)
		end
	end


end

 return false --unload
