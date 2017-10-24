--most simple unit script
--allows the unit to be created & killed

include "lib_caeserea.lua"

center= piece"center"
TablesOfPiecesGroups = {}

Housenames = {"Googlefrog", "JK", "Licho", "Yak", "Pako", "Sprung","Anarchid","Hokomoko","Aquanim","Pepeampero","Think","lurker","Knorke","Codeman","KingRaptor","Kloot","Braindamage" }

function script.Create()
	name = Housenames[math.random(1,#Housenames)]
	Spring.SetUnitTooltip(unitID," of the great family of "..name)
	
	if math.random(0,1)==1 then
		T= Spring.GetPlayerList()
		process(T,
		function(id)
					name = Spring.GetPlayerInfo(id)
					if name and type(name)=="string" and name ~= "" and math.random(0,2)==1  then
						Spring.SetUnitTooltip(unitID," of the great family of "..name)
					end
		end
		
		)
	end

	TablesOfPiecesGroups = makePiecesTablesByNameGroups(false, true)

	process(TablesOfPiecesGroups["Prop"],
		function(id)
			if math.random(0,1) ==1 then Hide(id)else Show(id)end		
		end	
		)	

	process(TablesOfPiecesGroups["win"],
		function(id)
			if math.random(0,1)==1 then Hide(id)else Show(id)end		
		end	
		)
		
		value= math.random(-25,25)
		Turn(TablesOfPiecesGroups["Prop"][1],y_axis,math.rad(value),0)
			value= math.random(-25,25)
		Turn(TablesOfPiecesGroups["Prop"][34],y_axis,math.rad(value),0)
			value= math.random(-25,25)
		Turn(TablesOfPiecesGroups["Prop"][35],y_axis,math.rad(value),0)
	
end

function script.Killed(recentDamage, maxHealth)
	
end