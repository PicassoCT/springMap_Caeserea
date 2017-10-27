--most simple unit script
--allows the unit to be created & killed
include "lib_caeserea.lua"

center= piece"center"
eagle= piece"eagle"
TablesOfPiecesGroups = {}
--> returns a randomized Signum
function randSign()
    if math.random(0, 1) == 1 then return 1 else return -1 end
end

function script.Create()
TablesOfPiecesGroups = makePiecesTablesByNameGroups(false, true)
	Spin(center,y_axis,math.rad(42),0)
	Move(center,y_axis,150,0)
	StartThread(circleAltering)	
	StartThread(moveControl)	
	hideT(TablesOfPiecesGroups["e"])
	dice=math.random(1,5)
	Show(TablesOfPiecesGroups["e"][dice])
end

function timeBasedOffset()
return math.sin((((Spring.GetGameFrame() % 15000)/15000)*2*math.pi) -math.pi) * 500
end

function moveControl()
Spring.MoveCtrl.Enable(unitID,true)
xsignum= randSign()
zsignum= randSign()
x,y,z=Spring.GetUnitPosition(unitID)
	while true do
	 Spring.MoveCtrl.SetPosition(unitID, x +timeBasedOffset()*xsignum, y+ 100 ,z +timeBasedOffset()*zsignum)
	Sleep(100)
	end

end

function circleAltering()
	value=150
	sign= -1
	while true do
		rand= math.random(25,100)
		value=value+ sign
		Move(center,y_axis,value,1)
		if value < 150 or value > 400 then sign= sign *-1 end
		Move(eagle,x_axis,rand,3)
		Sleep(50000)
	end
end

function script.Killed(recentDamage, maxHealth)
	
end