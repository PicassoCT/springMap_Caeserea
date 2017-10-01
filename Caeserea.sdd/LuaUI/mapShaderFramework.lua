function widget:GetInfo()
	return {
		name      = "MapShaderFramework",
		desc      = "MapShader",
		author    = "A very drunk picasso and his cousin",
		date      = "",
		license   = "",
		layer     = 0,
		enabled   = gl.CreateShader,
	}
end


--Name of the Shader Subfolders
FragmentDIR = "Fragment"
VertexDIR = "Vertex"
UniformDIR = "Uniform"

FileEndingVertex =".vs"
FileEndingFragment =".fs"

--Name of the mainDirectory within the spring directory
RootDIR = "Shaders"

local shader =  {}
function getUniformDirectory()
return RootDIR.."/"..UniformDIR

end
function getFragmentDirectory()
	return  RootDIR.."/".. FragmenDIR
end

function getVertexDirectory()
	return  CentralDIR.."/".. VertexDIR
end

--Loads a list of files from a given Directory - returns the full filepath
function getDirectoryContentList(Path)
fileList = VFS.DirList(Path)
	for i=1,#fileList do
		fileList[i]= Path.."/"..fileList[i]
	end
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
		elsebfu	
			break
		end
	end
boolMainStarted =  matchCounter > 1
boolMainStartCompleted = matchCounter == #stringComponents +1 

if boolMainStartCompleted == true and  boolReMainderCut == false then 
	boolReMainderCut= true
	line = string.sub(line, ends+1,#line)
end

return boolMainStarted,boolMainStartCompleted, line
end


function loadFile(filePathAndName)

result= VFS.LoadFile(filePathAndName)
	if not result then 
		Spring.Echo("File not loaded "..filePathAndName)
	else
		return result
	end
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

Stack = {}

-- Create a Table with stack functions
function Stack:Create()

  -- stack table
  local t = {}
  -- entry table
  t._et = {}

  -- push a value on to the stack
  function t:push(...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        table.insert(self._et, v)
      end
    end
  end
  -- get entries
  function t:getn()
    return #self._et
  end

  -- pop a value from the stack
  function t:pop(num)

    -- get num values from stack
    local num = num or 1

    -- return table
    local entries = {}

    -- get values into entries
    for i = 1, num do
      -- get last entry
      if #self._et ~= 0 then
        table.insert(entries, self._et[#self._et])
        -- remove last value
        table.remove(self._et)
      else
        break
      end
    end
    -- return unpacked entries
    return unpack(entries)
  end


  -- list values
  function t:list()
    for i,v in pairs(self._et) do
      print(i, v)
    end
  end
  return t
end

-- update the parenthesis stack
function parentThesis(line, parenthesisStack)
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



--extracts the Context, the Uniforms
function extractContextMain(listOfFiles)
concatContext, concatMain = "", ""
boolMainStarted = false
boolMainStartCompleted= false




	for num, fileName in pairs (listOfFiles) do
		file = loadFile(fileName)
		parenthesisStack = Stack:Create()
		
		concatContext= concatContext.. "/* "..fileName.." Context */\n"
		for line in file:lines() do
			if ignoreLine(line) == false then

			boolMainStarted, boolMainStartCompleted,line = foundMainStartCompleted(line)
				if boolMainStarted == false or parenthesisStack.getn()== 0 then
					concatContext= concatContext.."\n"..
				end
				
				if boolMainStarted == true and boolMainStartCompleted== true  then
					parenthesisStack.push(true)
				end	
				
						
				if boolMainStartCompleted == true and parenthesisStack.getn() > 0  then
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
	_,start= string.find(name,"_")
	strend,_= string.find(name,fileEnding)
	number= trim(string.gsub(string.sub(name,start+1,strend),"_",""))
	index = tonumber(number)
	retTable[index]=name

	end

end


function loadUniform(shaderT)
-- load the uniform sourcecode fromt he uniformfolder
file = VFS.LoadFile(getUniformDirectory())
if not file then Spring.Echo("No Uniform Sourcefile found at "..getUniformDirectory()); return shaderT end
uniformFunction = loadstring(uniformCode)
uniformTables= uniformFunction()

	for key, value in pairs(uniformTables) do
		shaderT[key] = value
	end

return shaderT
end


function loadMapShader()

	listOfVertexFiles	= getDirectoryContentList(getVertexDirectory())
	listOfFragmentFiles	= getDirectoryContentList(getVertexDirectory())

	listOfVertexFiles = sortByNumberInName( listOfVertexFiles, FileEndingVertex)
	listOfFragmentFiles = sortByNumberInName( listOfFragmentFiles, FileEndingFragment)

	vertexAggregatedContext, vertexAggregatedMain = extractContextMain(listOfVertexFiles)
	fragmentAggregatedContext, fragmentAggregatedMain  = extractContextMain(listOfVertexFiles)


	shader.fragment = fragmentAggregatedContext.. "\n main() { \n"..fragmentAggregatedMain.."\n }"
	shader.vertex = vertexAggregatedContext.. "\n main() { \n"..vertexAggregatedMain.."\n }"

	shader = loadUniform(shader)

	compiledMapShader =  gl.CreateShader(shader)

 local errors = gl.GetShaderLog(shader)
    if errors ~= "" then
        Spring.Log("MapShaders", LOG.ERROR, errors)
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
    gl.UseShader(compiledMapShader)
	
	if shader.bindUniforms then 	shader.bindUniforms()	end
	
	if shader.updateUniforms then shader.updateUniforms(os.clock()) end
	
    gl.UseShader(0)
end
