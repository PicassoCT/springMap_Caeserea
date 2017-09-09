
-->generates a Pieces List 
function generatepiecesTableAndArrayCode(unitID, boolLoud)
    bLoud = boolLoud or false

    if bLoud == true then
        Spring.Echo("")
        Spring.Echo("--PIECESLIST::BEGIN |>----------------------------")
        Spring.Echo("piecesTable={}")
        piecesTable = {}
        piecesTable = Spring.GetUnitPieceList(unitID)
        --Spring.Echo("local piecesTable={}")
        if piecesTable ~= nil then
            for i = 1, #piecesTable, 1 do
                workingString = piecesTable[i]
                Spring.Echo("" .. piecesTable[i] .. " = piece(\"" .. piecesTable[i] .. "\")\n piecesTable[#piecesTable+1]= " .. piecesTable[i])
            end
        end

        Spring.Echo("PIECESLIST::END |>-----------------------------")
    end


    return makePieceTable(unitID)
end


--> finds GenericNames and Creates Tables with them
function makePiecesTablesByNameGroups(boolMakePiecesTable, boolSilent)

    boolSilentRun = boolSilent or true
    pieceMap = Spring.GetUnitPieceMap(unitID)
    piecesTable = Spring.GetUnitPieceList(unitID)

    TableByName = {}
    NameAndNumber = {}
    ReturnTable = {}

    for i = 1, #piecesTable, 1 do
        s = string.reverse(piecesTable[i])

        for w in string.gmatch(s, "%d+") do
            if w then
                s = string.sub(s, string.len(w), string.len(s))
                NameAndNumber[i] = {
                    name = string.sub(piecesTable[i], 1, string.len(piecesTable[i]) - string.len(w)),
                    number = string.reverse(w)
                }

                if TableByName[NameAndNumber[i].name] then
                    TableByName[NameAndNumber[i].name] = TableByName[NameAndNumber[i].name] + 1
                else
                    TableByName[NameAndNumber[i].name] = 1
                end
                break
            end
        end
        if not NameAndNumber[i] then NameAndNumber[i] = { name = string.reverse(s) } end
    end


    if boolSilentRun == false then
        for k, v in pairs(TableByName) do
            if v > 1 then
                Spring.Echo(k .. " = {}")
            end
        end


        for k, v in pairs(NameAndNumber) do

            if v and v.number then
                Spring.Echo(v.name .. v.number .. " = piece\"" .. v.name .. v.number .. "\"")
                Spring.Echo(v.name .. "[" .. v.number .. "]= " .. v.name .. v.number)
            else
                Spring.Echo(v.name .. " = piece(" .. v.name .. ")")
            end
        end

        if boolMakePiecesTable and boolMakePiecesTable == true then
            generatepiecesTableAndArrayCode(unitID)
        end

    else

        --pack the piecesTables in a UeberTable by Name
        for tableName, _ in pairs(TableByName) do
            local PackedAllNames = {}
            --Add the Pieces to the Table
            for k, v in pairs(NameAndNumber) do

                if v and v.number and v.name == tableName then
                    piecename = v.name .. v.number
                    if lib_boolDebug == true then
                        if lib_boolDebug == true and pieceMap[piecename] then
                            Spring.Echo(v.name .. "[" .. v.number .. "] = " .. piecename .. " Piecenumber: " .. pieceMap[piecename])
                        else
                            Spring.Echo("pieceMap contains no piece named " .. piecename)
                        end
                    end
                    convertToNumber = tonumber(v.number)
                    PackedAllNames[convertToNumber] = pieceMap[piecename]
                end
            end
            ReturnTable[tableName] = PackedAllNames
        end

        return ReturnTable
    end
end


-->Reset a Table of Pieces at speed

function resetT(tableName, speed, ShowAll, boolWait, boolIstantUpdate, interValStart, interValEnd)
    lboolWait = boolWait or false
    lspeed = speed or 0
	interValStart= interValStart or 1
	interValEnd = interValEnd or #tableName

    assert(tableName, "libAnimation::resetT: No valid Table")

    for i = interValStart, interValEnd do

        reset(tableName[i], lspeed, false, boolIstantUpdate)
        if ShowAll and tableName[i] then
            Show(tableName[i])
        end
    end

    if lboolWait == true then
        WaitForTurns(tableName)
    end
end

-->Waits for anyTurnToComplete
function WaitForTurns(...)
	local arg = arg
	if (not arg) then arg = {...}; arg.n = #arg end
   if not arg then echo("No arguments for WaitForTurns");   return   end

   typeArg = type(arg)

    if typeArg == "table" then

        for k, v in pairs(arg) do
            if type(v) == "number" then
                WaitForTurn(v, x_axis)
                WaitForTurn(v, y_axis)
                WaitForTurn(v, z_axis)
            end
        end
        return
    elseif typeArg == "number" then
        WaitForTurn(arg, x_axis)
        WaitForTurn(arg, y_axis)
        WaitForTurn(arg, z_axis)
    end
end

-->Turns a piece in wind direction with offset
function TurnTowardsWind(piecename, speed, offset)
    offSet = offset or 0
    dx, dy, dz = Spring.GetWind()
    headRad = math.atan2(dx, dz)
    Turn(piecename, y_axis, headRad + offSet, speed)
    return headRad
end

-->itterates over a table, executing a function with a argumentTable
function elementWise(T, fooNction, ArghT)
    reTable = {}

    for k, v in pairs(T) do
        reTable[k] = fooNction(T[k], ArghT)
    end

    return reTable
end

--> takes a Table, and executes Function on it
-- non Function Values are handed to the function following it
-- returning nil removes a element from the process chain
function process(Table, ...)
    local arg = { ... }
    local arg = arg; if (not arg) then arg = { ... }; arg.n = #arg end
    T = {}
    if Table then
        T = Table
    else
        if lib_boolDebug == true then
            echo("Lua:lib_UnitScript:Process: No Table handed over")
            return
        end
    end
    if not arg then echo("No args in process") return end
    if type(arg) == "function" then return elementWise(T, arg) end


    TempArg = {}
    TempFunc = {}
    --if not arg then return Table end

    for _, f in pairs(arg) do
        if type(f) == "function" then
            T = elementWise(T, f, TempArg)
            TempArg = {}
        else
            TempArg[#TempArg + 1] = f
        end
    end
    return T
end


--> Hides a PiecesTable, 
function hideT(tablename, lowLimit, upLimit, delay)
    if not tablename then return end
    boolDebugActive = (lib_boolDebug == true and lowLimit and type(lowLimit) ~= "string")

    if lowLimit and upLimit then
        for i = upLimit, lowLimit, -1 do
            if tablename[i] then
                Hide(tablename[i])
            elseif boolDebugActive == true then
                echo("In HideT, table " .. lowLimit .. " contains a empty entry")
            end

            if delay and delay > 0 then Sleep(delay) end
        end

    else
        for i = 1, table.getn(tablename), 1 do
            if tablename[i] then
                Hide(tablename[i])
            elseif boolDebugActive == true then
                echo("In HideT, table " .. lowLimit .. " contains a empty entry")
            end
        end
    end
end
-->Shows a Pieces Table
function showT(tablename, lowLimit, upLimit, delay)
    if not tablename then Spring.Echo("No table given as argument for showT") return end

    if lowLimit and upLimit then
        for i = lowLimit, upLimit, 1 do
            if tablename[i] then
                Show(tablename[i])
            end
            if delay and delay > 0 then Sleep(delay) end
        end

    else
        for i = 1, table.getn(tablename), 1 do
            if tablename[i] then
                Show(tablename[i])
            end
        end
    end
end
