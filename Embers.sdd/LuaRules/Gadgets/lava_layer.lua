function gadget:GetInfo()
  return {
    name      = "lava_layer",
    desc      = "draws lava layers",
    author    = "raaar",
    date      = "2019",
    license   = "pd",
    layer     = 0,
    enabled   = true
  }
end

local spGetGameSeconds = Spring.GetGameSeconds
local sin = math.sin
local cos = math.cos
local pi = math.pi
local rand = math.random
local periodFactor = 0
local glowPeriodFactor = 0
local signum = 1
------------------------------------ SYNCED
if (gadgetHandler:IsSyncedCode()) then


------------------------------------ UNSYNCED
else

function gadget:DrawWorldPreUnit ()  
	-- lava planes

	drawPlane(":a:LuaRules\\Images\\lavacolor6.png",15,7,30,0.001,{1.0,1.0,1.0,1.0},"alpha") 
	drawPlane(":a:LuaRules\\Images\\lavacolor6.png",20,10.8,28,0.0021,{1.0,1.0,1.0,0.6},"alpha") 
	
	-- fog planes
	drawPlane(":a:LuaRules\\Images\\lavafog.png",23,1.9,13.9,0.0043,{1.0,1.0,1.0,0.30},"alpha_add" ) 
	drawPlane(":a:LuaRules\\Images\\lavafog.png",26,1.3,9.2,0.003,{1.0,1.0,0.1,0.25}, "add") 
end


function drawPlane (texture,y,scaleFactor,periodS,growFactor,rgba, mode)
	local t = spGetGameSeconds()
	
	gl.PushAttrib(GL.ALL_ATTRIB_BITS)
	gl.Blending( mode )--alpha_add
	gl.DepthTest(true)
	gl.DepthMask(true)	
	
	periodFactor =  sin(2*pi*t/periodS) * math.pi
	
	glowPeriodFactor = sin(2*pi*t/(periodS*1.3))
	scaleFactor = scaleFactor * (1+ periodFactor * growFactor)
	gl.Texture(0,texture)-- Texture file	
	gl.Texture(1,texture)-- Texture file	
	gl.Color(rgba[1]*(0.9+0.1*glowPeriodFactor),rgba[2]*(0.8+0.2*glowPeriodFactor),rgba[3]*(0.7+0.3*glowPeriodFactor),rgba[4]*(0.9+0.1*glowPeriodFactor))
	
	gl.BeginEnd(GL.QUADS,drawPlaneVertexes,y,scaleFactor,periodFactor)
	gl.Texture(false)
	gl.DepthMask(false)
	gl.DepthTest(false)	
	gl.PopAttrib()
	gl.Blending(false)
end



-- these are drawn off-center towards the south-east
-- but still cover the 9x map area around the actual playable area
-- this is so lava flows back/forth in a consistent direction
function drawPlaneVertexes (y,scaleFactor,periodFactor)
	local s = scaleFactor
	local x = Game.mapSizeX
	local z = Game.mapSizeZ
	local xOffset = x * 0.005 * periodFactor
	local zOffset = z * 0.002 * periodFactor

	gl.MultiTexCoord(0,-s,-s)
	gl.MultiTexCoord(1,-s*2.1,-s*1.5)
	--gl.Vertex(-x+xOffset ,y, -z+zOffset)
	gl.Vertex(-0.5*x+xOffset ,y, 0+zOffset)

	gl.MultiTexCoord(0,-s,s)
	gl.MultiTexCoord(1,-s*2.5,s*1.1)
	--gl.Vertex(-x+xOffset,y,4*z+zOffset)
	gl.Vertex(-0.5*x+xOffset,y, z+zOffset)

	gl.MultiTexCoord(0,s,s)
	gl.MultiTexCoord(1,s*2.1,s*1.5)
	--gl.Vertex(4*x+xOffset,y,4*z+zOffset)
	gl.Vertex(1.5*x+xOffset,y,z+zOffset)

	gl.MultiTexCoord(0,s,-s)
	gl.MultiTexCoord(1,s*2.5,-s*1.1)
	--gl.Vertex(4*x+xOffset,y,-z+zOffset)
	gl.Vertex(1.5*x+xOffset,y,0+zOffset)
 
end

end 