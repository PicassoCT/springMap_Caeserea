
function widget:GetInfo()
  return {
    name      = "LOS brightness Modifier",
    desc      = "overrides LOS brightness for some maps",
    author    = "raaar",
    date      = "2019",
    license   = "PD",
    layer     = 9999999,
    enabled   = true,
  }
end	


local spGetLosViewColors = Spring.GetLosViewColors
local spSetLosViewColors = Spring.SetLosViewColors

local alwaysMod = {0.38,0.38,0.38}  -- default 0.2
local LOSMod = {0.16,0.16,0.16}  -- default 0.3

function widget:Initialize()	
	-- ZK workaround
	if WG.game_SetLosFogBrightnessMinimum then
		WG.game_SetLosFogBrightnessMinimum(0.45)
		return
	end

	-- get current colors
	local always, LOS, radar, jam, radar2 = spGetLosViewColors()
	
	-- update colors
	if (LOS) then
		-- Spring.Echo("always={"..always[1]..","..always[2]..","..always[3].."}")
		-- Spring.Echo("LOS={"..LOS[1]..","..LOS[2]..","..LOS[3].."}")
		-- Spring.Echo("radar={"..radar[1]..","..radar[2]..","..radar[3].."}")
		-- Spring.Echo("jam={"..jam[1]..","..jam[2]..","..jam[3].."}")
		-- Spring.Echo("radar2={"..radar2[1]..","..radar2[2]..","..radar2[3].."}")
		
		spSetLosViewColors(alwaysMod, LOSMod, radar, jam, radar2)
	end
end


function widget:Destroy()	
end
