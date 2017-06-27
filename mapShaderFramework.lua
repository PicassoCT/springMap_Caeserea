function widget:GetInfo()
	return {
		name      = "Map Shader Framework",
		desc      = "Loads and applys shaders within a mapfolder",
		author    = "Picasso",
		date      = "",
		license   = "",
		layer     = 0,
		enabled   = true,
	}
end

local shaderList = {}

function widget:Initialize()
-- Loads a Set of Shaders as Defined in the Fragment/ Vertex/ folders and applys 
-- them following a  bitmask distribution map
-- Every RGB Value consists of a list of shaders to apply 3 == Shader1 & Shader 2

-- every shader needs to provide the following functions
-- getVertexShader
-- getFragmentShader
-- registerUnforms
-- apllyUniformFunctions

-- apply said shaders
end

function widget:DrawWorld()
	for name, shader in pairs(shaderList) do
		gl.UseShader(shader.compiled)
		if not timeID then
			timeID         = gl.GetUniformLocation(shader, "time")
			pointsID       = gl.GetUniformLocation(shader, "points")
			pointSizeID    = gl.GetUniformLocation(shader, "pointSize")
		end
		gl.Uniform(     timeID,       os.clock())
		gl.UniformInt(  pointSizeID,  #points/3)
		gl.UniformArray(pointsID,     1, points)	
		gl.UseShader(0)
	end
end