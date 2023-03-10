-- test framework

require("lib/util")

local Case = {}

function Case:statusText()
    if self.succeeded then
        return "[SUCCESS] " .. self.name
    else
        return "[FAILURE] " .. self.name
    end
end

function Case:assert(want)
    if not want then
        self.succeeded = false
    end
end

local function toString(obj)
    if obj == nil then return "<nil>" end
    return textutils.serialiseJSON(obj)
end

function Case:equals(want, got)
    if want ~= got then
        self.succeeded = false
        self.diff = self.diff .. "want: " .. toString(want) .. "\n"
        self.diff = self.diff .. " got: " .. toString(got)  .. "\n"
    end
end

function Case:deepEquals(want, got)
    if not deepEquals(want, got) then
        self.succeeded = false
        self.diff = self.diff .. "want: " .. toString(want) .. "\n"
        self.diff = self.diff .. " got: " .. toString(got)  .. "\n"
    end
end

function Case:noerror(f, ...)
    local ok, _ = pcall(f, ...)
    if not ok then
        self.succeeded = false
    end
end

function Case:error(f, ...)
    local ok , _ = pcall(f, ...)
    if ok then
        self.succeeded = false
    end
end

function Case.new(name)
    local obj = {
        name = name,
        succeeded = true,
        diff = "",
    }
    return setmetatable(obj, { __index = Case })
end

local Test = {}

function Test:case(name, f)
    local t = Case.new(name)
    table.insert(self.cases, t)
    f(t)
end

function Test:resultText()
    local res = {}
    for i, c in ipairs(self.cases) do
        table.insert(res, c:statusText())
    end
    return table.concat(res, "\n")
end

function Test:failuresText()
    local res = {}
    for i, c in ipairs(self.cases) do
        if not c.succeeded then
            table.insert(res, c:statusText())
            if c.diff ~= "" then
                table.insert(res, c.diff)
            end
        end
    end
    return table.concat(res, "\n")
end

function Test:succeededCount()
    local count = 0
    for i, c in ipairs(self.cases) do
        if c.succeeded then
            count = count + 1
        end
    end
    return count
end

function Test:failureCount()
    return self:caseCount() - self:succeededCount()
end

function Test:caseCount()
    return #self.cases
end

local test = {
    cases = {},
}
return setmetatable(test, { __index = Test })
