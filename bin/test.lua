-- test framework

local Case = {}

function Case:statusText()
    if self.succeeded then
        return "[SUCCESS] " .. self.name
    else
        return "[FAILURE] " .. self.name
    end
end

function Case:assert(want, got)
    if want ~= got then
        self.succeeded = false
    end
end

function Case.new(name)
    local obj = {
        name = name,
        succeeded = true
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
