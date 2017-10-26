--most simple unit script
--allows the unit to be created & killed
include "lib_caeserea.lua"

	center= piece"Line"
TablesOfPiecesGroups = {}

function script.Create()
StartThread(delayedActivation)
	
end
function delayedActivation()
Sleep(1)
	Spring.SetUnitBlocking(unitID, false)
	Spring.SetUnitNoSelect(unitID, true)
	TablesOfPiecesGroups = makePiecesTablesByNameGroups(false, true)
	index=1
	T= Spring.GetPlayerList(true)
	T= process(T,
			function(id)
				name=Spring.GetPlayerInfo(id)
			return name
			end
			)
			
	if not T then T= {"William Defoe","Shakespear","Hardhat","Whatever"}end
	
	selectedT= {}
	selectedT[1],selectedT[2],selectedT[3]=Spring.GetUnitPosition(unitID)
	selectedT[4] = math.random(1,2048)
	direction=Spring.GetUnitHeading(unitID)
	direction = math.abs(direction)
	preSeed= direction
	for i=1,4 do
		seed,preSeed=pseudoRandom(T[i],preSeed)
		selectedT[i]= 	selectedT[i]+ math.floor(seed)%6 +1
	end
	
	hideT(TablesOfPiecesGroups["Cloth"])
	
	for i=1,4 do
		index =math.floor(((i-1)*6)+ ( selectedT[i])%6+1)
		if TablesOfPiecesGroups["Cloth"][index] then
				Show(TablesOfPiecesGroups["Cloth"][index] )	
		else
			Show(TablesOfPiecesGroups["Cloth"][((i-1)*6)+ 2] )	
			Spring.Echo("Cloth:Not defined for "..index)
		end
	end

end
function script.Killed(recentDamage, maxHealth)
	
end