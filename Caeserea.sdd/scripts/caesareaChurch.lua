--most simple unit script
--allows the unit to be created & killed

include "lib_caeserea.lua"

center= piece"center"
TablesOfPiecesGroups = {}
function script.Create()
	StartThread(bellWhileDamaged)
end
boolDamaged = false
boolAllreadyPlaing=false
function bellWhileDamaged()
	while true do
		if boolDamaged == true then
			Spring.PlaySoundFile("sounds/churchbells.ogg", 1)
			boolDamaged= false
			boolAllreadyPlaing=true
		end
		for i=1,35 do 
			Sleep(1000)
			if boolDamaged== true and boolAllreadyPlaing == false then break end
		end
		boolAllreadyPlaing=false
	end
end

function script.HitByWeapon(x, z, weaponDefID, damage)
	Spring.Echo("Psychologically damaged Church")
	boolDamaged = true
	return 0
end

function script.Killed(recentDamage, maxHealth)
	
end