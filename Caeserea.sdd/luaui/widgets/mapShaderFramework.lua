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
	return RootDIR.."/".. FragmenDIR
end

function getVertexDirectory()
	return RootDIR.."/".. VertexDIR
end

--Loads a list of files from a given Directory - returns the full filepath
function getDirectoryContentList(Path)
	fileList = VFS.DirList(Path)
	return fileList
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
		[4] = "%)",
		[5] = "{"
	}
	
	start,ends=0,0
	for i= matchCounter,#stringComponents do
		print(line,stringComponents[i])
		start, ends =string.find(line, stringComponents[i],index)
		if start then
			index = ends+1
			matchCounter=matchCounter +1
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
	
	return boolMainStarted,boolMainStartCompleted, line
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

parenthesisStack = {
					openBraces=0, 
					getn=function() return parenthesisStack.openBraces; end,
					pop= function() parenthesisStack.openBraces = parenthesisStack.openBraces-1; end,
					push= function()parenthesisStack.openBraces =parenthesisStack.openBraces +1; end
		}	
		
-- update the parenthesis stack
function parentThesis(line)
	for i = 1, #line do
		local c = line:sub(i,i)
		if parenthesisStack.getn()==0 then return parenthesisStack end
		if c == "{" then parenthesisStack.push(true) end
		if c == "}" then parenthesisStack.pop() end
	end
	return parenthesisStack
end




function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end



--extracts the Context
function extractContextMain(listOfFiles)
	concatContext, concatMain = "", ""
	boolMainStarted = false
	boolMainStartCompleted= false
	
	
	
	
	for num, fileName in pairs (listOfFiles) do
		local file = loadFile(fileName)	
		
		concatContext= concatContext.. "// "..fileName.." Context \n"
		for i=1, #file do
		local line = file[i]	
	--	Spring.Echo(line)
			if ignoreLine(line) == false then
				
				boolMainStarted, boolMainStartCompleted,line = foundMainStartCompleted(line)
				if boolMainStarted == false or parenthesisStack.getn()== 0 then
					concatContext= concatContext..line.."\n"
				end
				
				if boolMainStarted == true and boolMainStartCompleted== true then
				concatMain= concatMain.. "// "..fileName.." Main \n"
					parenthesisStack.push(true)
				end	
				
				
				if boolMainStartCompleted == true and parenthesisStack.getn() > 0 then
					parenthesisStack= parentThesis(line,parenthesisStack)
					if parenthesisStack.getn() > 0 then
						concatMain = concatMain..line
					end
				end
				
			end
		end
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
		if not number then echo("MapShaderFramework:: No number in filename :"..name);  end
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
	listOfFragmentFiles	= getDirectoryContentList(getVertexDirectory())
	if not listOfFragmentFiles then echo("MapShaderFramework::No Fragment Files found"); return end
	
	listOfVertexFiles = sortByNumberInName( listOfVertexFiles, FileEndingVertex)
	listOfFragmentFiles = sortByNumberInName( listOfFragmentFiles, FileEndingFragment)
	
	vertexAggregatedContext, vertexAggregatedMain = extractContextMain(listOfVertexFiles)
	fragmentAggregatedContext, fragmentAggregatedMain = extractContextMain(listOfFragmentFiles)
	
	shader.fragment = fragmentAggregatedContext.. "\n main(void) { \n"..fragmentAggregatedMain.."\n }"
	shader.vertex = vertexAggregatedContext.. "\n main(void) { \n"..vertexAggregatedMain.."\n }"
	
	shader = loadUniform(shader)
	
	compiledMapShader = gl.CreateShader(shader)
	
	local errors = gl.GetShaderLog(shader)
	if errors ~= "" or not compiledMapShader then
		Spring.Log("MapShaderFramework::Error:", LOG.ERROR, errors)
		Spring.Echo(shader.fragment)
		Spring.Echo(shader.vertex)
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