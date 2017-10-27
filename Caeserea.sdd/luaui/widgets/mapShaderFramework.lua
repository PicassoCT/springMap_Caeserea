function widget:GetInfo()
	enabled = (gl.CreateShader ~= nil)
	if not enabled then
		Spring.Echo("MapShaderFramework:No valid ShaderCard MapShaderFramework disabled ")
	else
		Spring.Echo("MapShaderFramework:Reporting In")
	end		
	
	return {		
		name = "MapShaderFramework",
		desc = "MapShader",
		author = "A very drunk picasso and his cousin",
		date = "",
		license = "",
		layer = 0,
		enabled = enabled
	}
end

-- TODO Remove later
local shader, timeID, pointsID, pointsSizeID

local MAX_POINTS = 10
local points = {}
--Name of the Shader Subfolders
FragmentDIR = "Fragment"
VertexDIR = "Vertex"
UniformDIR = "Uniform"

FileEndingVertex =".vs"
FileEndingFragment =".fs"

--Name of the mainDirectory within the spring directory
RootDIR = "luaui/widgets"


local shader= {}
local compiledMapShader = 0
function getShaderDistributionMapPath()
	return RootDIR.."/shaderDistributionMap.png"
end
function getUniformDirectory()
	return RootDIR.."/"..UniformDIR
end
function getFragmentDirectory()
	return RootDIR.."/".. FragmentDIR
end

function getVertexDirectory()
	return RootDIR.."/".. VertexDIR
end

--Loads a list of files from a given Directory - returns the full filepath
function getDirectoryContentList(Path)
	fileList = VFS.DirList(Path)
	return fileList
end

function reset()
	matchCounter=1
	boolReMainderCut= false
	boolMainStartCompleted= false
	boolPreAmbleOnce = false
	boolMainEnded = false
	
	mainParenthesisStack = {
		openBraces=0, 
		getn=function() return mainParenthesisStack.openBraces; end,
		pop= function() mainParenthesisStack.openBraces = mainParenthesisStack.openBraces-1; end,
		push= function()mainParenthesisStack.openBraces =mainParenthesisStack.openBraces +1; end
	}	
end

matchCounter=1
boolReMainderCut= false
--TODO Find a waterproof main detector
function foundMainStartCompleted(line)
	index=1
	
	stringComponents= {
		[1] = "void",
		[2] = "main",
		[3] = "%(",
		[4] = "void",
		[5] = "%)",
		[6] = "{"
	}
	
	start,ends=0,0
	for i= matchCounter,#stringComponents do
		start, ends =string.find(line, stringComponents[i],index)
		if i== 5 then 		mainParenthesisStack.push() end
		
		if start then
			index = ends + 1
			matchCounter=matchCounter + 1
		else 
			break
		end
	end
	boolMainStarted = matchCounter > 1 
	boolMainStartCompleted = matchCounter == #stringComponents +1
	
	if boolMainStartCompleted == true and boolReMainderCut == false then 
		boolReMainderCut= true
		line = string.sub(line, ends+1,#line)
	end
	
	return boolMainStarted,boolMainStartCompleted,boolMainEnded, line
end

function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function loadFile(filePathAndName)
	
	resultRaw= VFS.LoadFile(filePathAndName)
	local result = split(resultRaw,"\n")
	if not result then 
		Spring.Echo("MapShaderFramework:: File not loaded "..filePathAndName)
	else
		Spring.Echo("MapShaderFramework:: File loading "..filePathAndName)
		return result
	end
end

patternsToIgnore = {
	--"", --empty Strings
}
function ignoreLine(line)
	for i=1,#patternsToIgnore do
		if line:gmatch(patternsToIgnore[i]) then return true end		
	end
	return false
end

mainParenthesisStack = {
	openBraces=0, 
	getn=function() return mainParenthesisStack.openBraces; end,
	pop= function() mainParenthesisStack.openBraces = mainParenthesisStack.openBraces-1; end,
	push= function()mainParenthesisStack.openBraces =mainParenthesisStack.openBraces +1; end
}	

-- update the parenthesis stack
function mainBraceManagement(line, boolMainStartCompleted)
	for i = 1, #line do
		local c = line:sub(i,i)
		if c == "{" then mainParenthesisStack.push() end
		if c == "}" then mainParenthesisStack.pop() end
		
		if boolMainStartCompleted == true and boolMainEnded == false and mainParenthesisStack.getn()==0 then
			boolMainEnded = true
			return "" -- string.sub(line,i+1,#line)		
		end		
	end
	return line
end

function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

boolMainStartCompleted= false
boolPreAmbleOnce = false
boolMainEnded = false

--extracts the Context
function extractContextMain(listOfFiles)
	concatContext, concatMain = "", ""
	boolMainStarted = false
	
	
	for num, fileName in pairs (listOfFiles) do
		local file = loadFile(fileName)
		
		
		
		for i=1, #file do
			line = file[i]	
			
			if ignoreLine(line) == false then
				
				boolMainStarted, boolMainStartCompleted, boolMainEnded,line = foundMainStartCompleted(line)
				line= mainBraceManagement(line, boolMainStartCompleted)
				if (boolMainStarted== false or boolMainStartCompleted == false) or boolMainEnded == true then
					concatContext= concatContext..string.gsub(line,"\r","\n")
				end
				
				if boolMainStartCompleted== true and boolPreAmbleOnce == false then
					boolPreAmbleOnce=true
					concatMain= concatMain.. "// Main::"..fileName.." \n"
				end					
				
				if boolMainStartCompleted == true and mainParenthesisStack.getn() > 0 then
					if mainParenthesisStack.getn() > 0 then
						concatMain = concatMain..string.gsub(line,"\r","\n")
					end
				end
				
			end
		end
		reset()
	end
	
	
	return concatContext, concatMain
end

function sortByNumberInName( listOfFiles, fileEnding)
	local retTable={}
	index=1
	for _,name in pairs(listOfFiles) do
		Spring.Echo(name)
		_,start= string.find(name,"_")
		strend,_= string.find(name,fileEnding)
		number= trim(string.gsub(string.sub(name,start+1,strend),"_",""))
		if not number then echo("MapShaderFramework:: No number in filename :"..name); end
		if number then	
			retTable[number]=name
		end
	end
	return retTable
end


function loadUniform(shaderT)
	-- load the uniform sourcecode fromt he uniformfolder
	file = VFS.LoadFile(getUniformDirectory().."/Uniform.txt")
	if not file then Spring.Echo("No Uniform Sourcefile found at "..getUniformDirectory()); return shaderT end
	uniformFunction = loadstring(file)
	uniformTables= uniformFunction()
	
	for key, value in pairs(uniformTables) do
		shaderT[key] = value
	end
	
	return shaderT
end

function loadShaderDistributionMap()
	shaderDistributionMapPath=	getShaderDistributionMapPath()
	  --possible ${opt}'s are:
     -- 'n' = nearest
     -- 'l' = linear
     -- 'a' = aniso
     -- 'i' = invert
     -- 'g' = greyed
     -- 'c' = clamped
     -- 'b' = border
     -- 't%r,%g,%b' = tint
     -- 'r%width,%height' = resize
	-- The above ${opt}'s are NOT available for .DDS textures! .dds will load faster than other image formats.
	preFix ="::/"
	gl.Texture(preFix..shaderDistributionMapPath)


end

function loadMapShader()
	--load distribution texture
	loadShaderDistributionMap()
	--load shader
	listOfVertexFiles	= getDirectoryContentList(getVertexDirectory())
	if not listOfVertexFiles then echo("MapShaderFramework::No Vertex Files found"); return end
	listOfFragmentFiles	= getDirectoryContentList(getFragmentDirectory())
	if not listOfFragmentFiles then echo("MapShaderFramework::No Fragment Files found"); return end
	
	listOfVertexFiles = sortByNumberInName( listOfVertexFiles, FileEndingVertex)
	listOfFragmentFiles = sortByNumberInName( listOfFragmentFiles, FileEndingFragment)
	
	vertexAggregatedContext, vertexAggregatedMain = extractContextMain(listOfVertexFiles)
	fragmentAggregatedContext, fragmentAggregatedMain = extractContextMain(listOfFragmentFiles)
	
	shader = loadUniform(shader)
	
	local fragment = "#version 120\n"..fragmentAggregatedContext.. "\n void main(void) { \n"..fragmentAggregatedMain.."\n } \n"
	local vertex = "#version 120\n"..vertexAggregatedContext.."\n void main(void) { \n"..vertexAggregatedMain.."\n } \n"	
	
	compiledMapShader = gl.CreateShader({vertex= vertex,
		fragment= fragment,
		uniformInt= shader.uniformInt,
		uniformFloat = shader.uniformFloat
	})
	
	local errors = gl.GetShaderLog(shader)
	if errors ~= "" or not compiledMapShader then
		Spring.Echo("===================================Fragment Source=================================")
		Spring.Echo(fragment)
		Spring.Echo("===================================Vertex Source ==================================")
		Spring.Echo(vertex)
		Spring.Echo("===================================================================================")
		Spring.Log("MapShaderFramework::Error:", LOG.ERROR, errors)
	end
	Spring.SetMapShader(compiledMapShader, 0)
end


function widget:Initialize()
	loadMapShader()
end

function widget:Shutdown()
	Spring.SetMapShader(0, 0)
end

function widget:DrawWorld()
	if compiledMapShader then
		gl.UseShader(compiledMapShader)	
		--shader.updateUniforms(compiledMapShader)
		if not timeID then
			timeID = gl.GetUniformLocation(compiledMapShader, "time")
			pointsID = gl.GetUniformLocation(compiledMapShader, "points")
			pointSizeID = gl.GetUniformLocation(compiledMapShader, "pointSize")
		end
		gl.Uniform( timeID, os.clock())
		gl.UniformInt( pointSizeID, #points/3)
		gl.UniformArray(pointsID, 1, points)
		
		gl.UseShader(0)

	end
end

function widget:MousePress(x, y, button)
	local time = os.clock()
	if button == 1 or button == 3 then
		local result, coords = Spring.TraceScreenRay(x, y, true)
		if result == "ground" then
			if #points >= 10 * 3 then
				table.remove(points, 1)
				table.remove(points, 1)
				table.remove(points, 1)
			end
			table.insert(points, coords[1])
			table.insert(points, coords[3])
			table.insert(points, time)
		end
	end
end