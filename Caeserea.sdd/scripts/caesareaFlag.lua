--most simple unit script
--allows the unit to be created & killed

include "lib_caeserea.lua"
FlagRotor= piece"FlagRotor"
center= piece"center"
TablesOfPiecesGroups = {}
function script.Create()
	TablesOfPiecesGroups = makePiecesTablesByNameGroups(false, true)
	Move(center,y_axis,math.random(-45,0),0)
	StartThread(turnInWind)
end

local SIG_WAVE=2

boolOnce=false
function turnInWind()
	while true do
		dirX, dirY, dirZ,strength, normDirX, normDirY, normDirZ=Spring.GetWind()
		
		if strength > 5 then
			Turn(FlagRotor,x_axis,math.rad(-90),9)	
			Turn(FlagRotor,y_axis,math.rad(-90),9)	
			TurnTowardsWind(FlagRotor,5,0)
			if boolOnce == false then boolOnce = true; StartThread(waveInWind)end
		else
			Signal(SIG_WAVE)
			boolOnce = false
			Turn(FlagRotor,x_axis,math.rad(0),3)
			resetT(TablesOfPiecesGroups)	
			WaitForTurn(FlagRotor,x_axis)
		end
		Sleep(150)
	end
	
end

function waveInWind()
	Signal(SIG_WAVE)
	SetSignalMask(SIG_WAVE)
	while true do
		currentDegree= 0
		seconds = Spring.GetGameSeconds() 
		piPercent= (((seconds)%300)/300)*math.pi
		
		for i = 1, #TablesOfPiecesGroups["Flag"], 1 do
			relativeDegree= 0
			
			relativeDegree = math.ceil((math.abs(math.sin((seconds)+ i * piPercent)) * 15.0) - currentDegree)			
			currentDegree = currentDegree + relativeDegree 
			Turn(TablesOfPiecesGroups["Flag"][i], x_axis, math.rad(relativeDegree), 10)
		end
		
		WaitForTurns(TablesOfPiecesGroups["Flag"])
		Sleep(1)
	end
	
	
end



function script.Killed(recentDamage, maxHealth)
	
end