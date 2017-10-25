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


--Name of the Shader Subfolders
FragmentDIR = "Fragment"
VertexDIR = "Vertex"
UniformDIR = "Uniform"

FileEndingVertex =".vs"
FileEndingFragment =".fs"

--Name of the mainDirectory within the spring directory
RootDIR = "luaui/widgets"

local shader = {}
compiledMapShader= {}

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
	boolMainStartCompleted = matchCounter == #stringComponents  +1
	
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
					concatContext= concatContext..line
				end
				
				if boolMainStartCompleted== true and boolPreAmbleOnce == false then
					boolPreAmbleOnce=true
					concatMain= concatMain.. "// Main::"..fileName.." \n"
				end					
				
				if boolMainStartCompleted == true and mainParenthesisStack.getn() > 0 then
					if mainParenthesisStack.getn() > 0 then
						concatMain = concatMain..line
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


function loadMapShader()
	
	listOfVertexFiles	= getDirectoryContentList(getVertexDirectory())
	if not listOfVertexFiles then echo("MapShaderFramework::No Vertex Files found"); return end
	listOfFragmentFiles	= getDirectoryContentList(getFragmentDirectory())
	if not listOfFragmentFiles then echo("MapShaderFramework::No Fragment Files found"); return end
	
	listOfVertexFiles = sortByNumberInName( listOfVertexFiles, FileEndingVertex)
	listOfFragmentFiles = sortByNumberInName( listOfFragmentFiles, FileEndingFragment)
	
	vertexAggregatedContext, vertexAggregatedMain = extractContextMain(listOfVertexFiles)
	fragmentAggregatedContext, fragmentAggregatedMain = extractContextMain(listOfFragmentFiles)
	
	shader.fragment = fragmentAggregatedContext.. "\n void main(void) { \n"..fragmentAggregatedMain.."\n }"
	shader.vertex = vertexAggregatedContext.. "\n void main(void) { \n"..vertexAggregatedMain.."\n }"
	
	shader = loadUniform(shader)
	
	compiledMapShader = gl.CreateShader(shader)
	
	local errors = gl.GetShaderLog(shader)
	if errors ~= "" or not compiledMapShader then
		Spring.Log("MapShaderFramework::Error:", LOG.ERROR, errors)
		Spring.Echo("===================================Fragment Source=================================")
		Spring.Echo(shader.fragment)
		Spring.Echo("===================================Vertex Source ==================================")
		Spring.Echo(shader.vertex)
		Spring.Echo("===================================================================================")
		
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
	end
	
	if shader.bindUniforms then 	shader.bindUniforms()	end
	
	if shader.updateUniforms then shader.updateUniforms(os.clock()) end
	if compiledMapShader then
		gl.UseShader(0)
	end
end