local Decompile, Libraries = {
    WaitDecompile = false,
    getupvalues = false,
    getconstants = false,
    setclipboard = true
}, {
    "bit32",
    "buffer",
    "coroutine",
    "debug",
    "math",
    "os",
    "string",
    "table",
    "task",
    "utf8"
}

local Variables = {}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function Wait()
    if Decompile.WaitDecompile then
        task.wait()
    end
end

local function IsInvalid(str)
    return str:find("[%s0123456789%-%+/|]") ~= nil
end

local function GetParams(func)
    local info = debug.getinfo(func)
    local params = {}
    for i = 1, info.nparams do
        table.insert(params, "Val" .. i)
    end
    if info.isvararg then
        table.insert(params, "...")
    end
    return table.concat(params, ", ")
end

local function GetColorRGB(color)
    local r, g, b = color.R, color.G, color.B
    return string.format("%d, %d, %d", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
end

local function GetIndex(index)
    if type(index) == "number" or (type(index) == "string" and not IsInvalid(index)) then
        return string.format("[%s]", tostring(index))
    else
        return string.format("[\"%s\"]", tostring(index))
    end
end

function Decompile:Type(part, indent)
    Wait()
    local partType = typeof(part)
    local script = ""

    if partType == "boolean" or partType == "nil" then
        script = tostring(part)
    elseif partType == "table" then
        script = "{"
        for k, v in pairs(part) do
            script = script .. "\n" .. indent .. "  " .. GetIndex(k) .. " = " .. self:Type(v, indent .. "  ") .. ","
        end
        script = script .. "\n" .. indent .. "}"
    elseif partType == "string" then
        script = string.format("%q", part)
    elseif partType == "Instance" then
        local instancePath = part:GetFullName():gsub(" ", "")
        local instanceName = instancePath:match("^[^.]+")
        if not table.find(Variables, instanceName) then
            if not game:FindFirstChild(instanceName) then
                return instanceName .. " --[[ nil Instance ]]"
            end
            table.insert(Variables, instanceName)
        end
        script = instancePath:gsub("%.", ".")
    elseif partType == "function" then
        script = "function(" .. GetParams(part) .. ")\n"
        if Decompile.getupvalues then
            local upvalues = debug.getupvalues(part)
            if upvalues then
                script = script .. indent .. "  local upvalues = {\n"
                for i, uv in pairs(upvalues) do
                    script = script .. indent .. "    [" .. i .. "] = " .. self:Type(uv, indent .. "    ") .. ",\n"
                end
                script = script .. indent .. "  }\n"
            end
        end
        if Decompile.getconstants then
            local constants = debug.getconstants(part)
            if constants then
                script = script .. indent .. "  local constants = {\n"
                for i, c in pairs(constants) do
                    script = script .. indent .. "    [" .. i .. "] = " .. self:Type(c, indent .. "    ") .. ",\n"
                end
                script = script .. indent .. "  }\n"
            end
        end
        script = script .. indent .. "end"
    elseif partType == "CFrame" or partType == "Vector3" or partType == "Vector2" or partType == "UDim" or partType == "UDim2" then
        script = string.format("%s.new(%s)", partType, tostring(part))
    elseif partType == "Color3" then
        script = "Color3.fromRGB(" .. GetColorRGB(part) .. ")"
    elseif partType == "BrickColor" then
        script = "BrickColor.new(\"" .. tostring(part) .. "\")"
    elseif partType == "TweenInfo" or partType == "Axes" then
        script = string.format("%s.new(%s)", partType, tostring(part))
    else
        script = tostring(part):find("inf") and "math.huge" or tostring(part)
    end

    return script
end

function Decompile.new(part)
    local script, indent = "", "  "
    Variables = {}

    local function GetClass(p)
        if typeof(p) == "Instance" then
            if p:IsA("LocalScript") then
                return debug.getsenv(p)
            elseif p:IsA("ModuleScript") then
                local module = require(p)
                if type(module) == "function" then
                    return debug.getupvalues(module)
                end
                return module
            end
        end
        return p
    end

    local classPart = GetClass(part)
    script = typeof(part) == "Instance" and string.format("local Script = %s\n\n", Decompile:Type(part, "")) or ""
    script = script .. "local Decompile = {"

    if type(classPart) == "table" then
        for k, v in pairs(classPart) do
            script = script .. "\n" .. indent .. GetIndex(k) .. " = " .. Decompile:Type(v, indent) .. ","
        end
    else
        script = script .. "\n" .. indent .. "[\"1\"] = " .. Decompile:Type(classPart, indent)
    end

    script = script .. "\n}"

    local variableDefinitions = ""
    for _, v in ipairs(Variables) do
        variableDefinitions = variableDefinitions .. string.format("local %s = game:GetService(\"%s\")\n", v, v)
    end

    if Decompile.setclipboard then
        setclipboard(variableDefinitions .. "\n" .. script)
    end

    return variableDefinitions .. "\n" .. script
end

return Decompile
