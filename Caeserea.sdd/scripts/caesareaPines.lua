--most simple unit script
--allows the unit to be created & killed

include "lib_caeserea.lua"

center= piece"center"
TablesOfPiecesGroups = {}
function script.Create()
	TablesOfPiecesGroups = makePiecesTablesByNameGroups(false, true)
	hideT(TablesOfPiecesGroups["Pine"])
	dice= math.ceil(math.random(1,3))
	Show(TablesOfPiecesGroups["Pine"][dice])
end





function script.Killed(recentDamage, maxHealth)
	
end