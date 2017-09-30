function widget:GetInfo()
	return {
		name      = "MapShaderFramework",
		desc      = "MapShader demo",
		author    = "gajop",
		date      = "",
		license   = "",
		layer     = 0,
		enabled   = gl.CreateShader,
	}
end


--Name of the Shader Subfolders
FragmentDIR = "Fragments"
VertexDIR = "Vertex"

--Name of the mainDirectory within the spring directory
RootDIR = "Shaders"

local shader =  {}

function getFragmentDirectory()
	return  RootDIR.."/".. FragmenDIR
end

function getVertexDirectory()
	return  CentralDIR.."/".. VertexDIR
end

--Loads a list of files from a given Directory
function getDirectoryContentList(Path)
--TODO
	local f = io.popen("dir \"C:\\users\\\"")
	if f then
		print(f:read("*a"))
	else
		print("failed to read")
	end

end

--Verifies wether 
function checkShaderCompleteness(listOfVertexFiles, listOfFragmentFiles)

	Spring.Echo("Could not find "..fileName)
	--TODO
	return true
end

function loadFile(fileName)


end

patternsToIgnore = {
					"", --empty Strings
				}
function ignoreLine(line)
	for i=1,#patternsToIgnore do
		if ine:gmatch(linesToIgnore[i]) then return true end

	end
return false
end

--extracts the Context, the Uniforms
function extractContextMain(listOfFiles)
concatContext, concatMain = "", ""
boolMainStarted = false
Uniform = {}  -- [Name] = {Typ, InitValue}


	for num, fileName in pairs (listOfFiles) do
		file = loadFile(fileName)
		concatContext= concatContext.. "/* "..fileName.." Context */\n"
		for line in file:lines() do
			if ignoreLine(line) == false then

				if not line:gmatch("") or boolMainStarted == true then
					concatContext= concatContext.."\n"..

				else
				--TODO Count parantheses


				end
			end

		end
	end
	
return vertexAggregatedContext, vertexAggregatedMain, Uniform
end

function addUniformTables(shaderT, uniformVertex, uniformFragment)
--TODO

shaderT.uniformInt = {
            texSampler = 0,
            pointSize  = 0,
        }

shaderT.uniformFloat=		,
        {
            time = 0,
        }

return shaderT

end


function loadShader()

listOfVertexFiles	= getDirectoryContentList(getVertexDirectory())
listOfFragmentFiles	= getDirectoryContentList(getVertexDirectory())

boolComplete = checkShaderCompleteness(listOfVertexFiles, listOfFragmentFiles)

if boolComplete == false then 	return {} end


listOfVertexFiles = sortByNumberInName( listOfVertexFiles)
listOfFragmentFiles = sortByNumberInName( listOfFragmentFiles)

vertexAggregatedContext, vertexAggregatedMain, uniformVertex = extractContextMain(listOfVertexFiles)
fragmentAggregatedContext, fragmentAggregatedMain,uniformFragment  = extractContextMain(listOfVertexFiles)


shader.fragment = fragmentAggregatedContext.. "\n main() { \n"..fragmentAggregatedMain.."\n }"
shader.vertex = vertexAggregatedContext.. "\n main() { \n"..vertexAggregatedMain.."\n }"

shader = addUniformTables(shader,uniformVertex,uniformFragment)


end


function widget:Initialize()
	shader = {}
	-- load shadders from folders
	
	-- extract 
	
	
	
    local vertexShader = [[
        #define SMF_TEXSQR_SIZE 1024.0

        uniform ivec2 texSquare;
        varying vec2 texCoors;

        varying vec4 colorChange;
		varying vec4 vertexWorldPos;

        uniform float time;
        uniform float points[MAX_POINTS];
        uniform int pointSize;

        void main(void) {
            texCoors = (floor(gl_Vertex.xz) / SMF_TEXSQR_SIZE) - vec2(texSquare);

            vec4 pos = gl_Vertex;
            colorChange = vec4(0, 0, 0, 1);
            for (int i = 0; i < pointSize; i++) {
                float d = distance(vec2(points[i*3], points[i*3+1]), pos.xz);
                float dtime = time - points[i*3+2];

                float timeFalloff = pow(dtime, 3) + 1;
                float rangeFalloff = pow(d/400, 2) + 1;
                float rangeFrequency = sin(d/1000 + 1);
                pos.y += sin(dtime*10) * 200 / rangeFalloff * rangeFrequency / timeFalloff;

                colorChange += vec4(sin(dtime*10) * 200 / rangeFalloff * rangeFrequency / timeFalloff) / 1000;
            }
            gl_Position = gl_ModelViewProjectionMatrix * pos;
			vertexWorldPos = gl_Vertex;
        }
    ]]
    vertexShader = vertexShader:gsub("MAX_POINTS", tostring(MAX_POINTS*3))
    shader = gl.CreateShader({
        vertex = vertexShader,

        fragment = [[
            uniform sampler2D texSampler;

            varying vec2 texCoors;

            varying vec4 colorChange;
			varying vec4 vertexWorldPos;

            void main(void) {
                gl_FragColor = texture2D(texSampler, texCoors);
				if (vertexWorldPos.x > 2000. && vertexWorldPos.x < 4000.) {
					float w = sqrt((vertexWorldPos.x - 3000.) * (vertexWorldPos.x - 3000.));
					w /= 1000;
					w = min(1., w);
					gl_FragColor.rgb = mix(vec3(vertexWorldPos.y)/1024., gl_FragColor.rbg, w);//vec3((gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) / 3.);
				}
                //gl_FragColor += colorChange;
            }
        ]],

        uniformInt = {
            texSampler = 0,
            pointSize  = 0,
        },
        uniformFloat = {
            time = 0,
        },
    })

    local errors = gl.GetShaderLog(shader)
    if errors ~= "" then
        Spring.Log("MapShaders", LOG.ERROR, errors)
    end
    Spring.SetMapShader(shader, 0)
end

function widget:Shutdown()
    Spring.SetMapShader(0, 0)
end

function widget:DrawWorld()
    gl.UseShader(shader)
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
