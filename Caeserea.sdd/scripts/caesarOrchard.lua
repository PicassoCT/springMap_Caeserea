--most simple unit script
--allows the unit to be created & killed

include "lib_caeserea.lua"

center= piece"center"
TablesOfPiecesGroups = {}
function script.Create()
	TablesOfPiecesGroups = makePiecesTablesByNameGroups(false, true)
	hideT(TablesOfPiecesGroups["Tree"])
	hideT(TablesOfPiecesGroups["fruit"])
	dice= math.ceil(math.random(1,5))
	
	Show(TablesOfPiecesGroups["Tree"][dice])
	for i=1,5 do
		val=math.random(0,360)
		Turn(TablesOfPiecesGroups["Tree"][dice],y_axis,math.rad(val),0)
		if math.random(1,5) == 3 then 	Show(TablesOfPiecesGroups["Tree"][i]) end
	end
	
	for i=1,4 do
		if math.random(0,1) == 1 then
			Show(TablesOfPiecesGroups["fruit"][i])
			
		end
	end
	
end





function script.Killed(recentDamage, maxHealth)
	
end