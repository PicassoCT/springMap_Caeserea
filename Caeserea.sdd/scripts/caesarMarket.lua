--most simple unit script
--allows the unit to be created & killed
include "lib_caeserea.lua"

	center= piece"center"
TablesOfPiecesGroups = {}

function script.Create()
StartThread(bodyBuilder)
	
end
function bodyBuilder()


	TablesOfPiecesGroups = makePiecesTablesByNameGroups(false, true)
	
	
	process(TablesOfPiecesGroups["Prop"],
			function(id)
				if math.random(0,1)==1 then Show(id) else Hide(id) end			
			end
			)
end
function script.Killed(recentDamage, maxHealth)
	
end