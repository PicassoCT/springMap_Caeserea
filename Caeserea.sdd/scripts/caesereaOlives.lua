--most simple unit script
--allows the unit to be created & killed

include "lib_caeserea.lua"

center= piece"center"
TablesOfPiecesGroups = {}
function script.Create()
	TablesOfPiecesGroups = makePiecesTablesByNameGroups(false, true)
	local degValue=0
	dice = math.random(0,2) 
	hideT(	TablesOfPiecesGroups["root"])
	if dice ==1 then
		Show(TablesOfPiecesGroups["root"][1])
	elseif dice== 2 then
		Show(TablesOfPiecesGroups["root"][2])
	else
		showT(	TablesOfPiecesGroups["root"])
	end
	process(TablesOfPiecesGroups["root"],
		function(id)
			val= math.random(-360,360)
			Turn(id,y_axis,math.rad(val),0)
		end
		)
	showT(TablesOfPiecesGroups["branch"])	
	
	
	process(TablesOfPiecesGroups["branch"],
		function(id)
			Turn(id,y_axis,math.rad(degValue),0)
			degValue= degValue + math.random(25,76)
		end
	)
	

	if dice ==1 then
		Hide(TablesOfPiecesGroups["branch"][2])
		hideT(TablesOfPiecesGroups["branch"],4,6)	
	elseif dice== 2 then
		Hide(TablesOfPiecesGroups["branch"][1])
		hideT(TablesOfPiecesGroups["branch"],1,3)
	end
end

function script.Killed(recentDamage, maxHealth)
	
end