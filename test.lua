-- test entry point

function concat(...)
    local res = {}

    local args = {...}
    for i, arg in ipairs(args) do
        for j, v in ipairs(arg) do
            table.insert(res, v)
        end
    end

    return res
end

local tests = concat(
    fs.find("bin/*/*_test.lua"),
    fs.find("bin/*_test.lua")
)

for i, f in ipairs(tests) do
    for mod in string.gmatch(f, "(bin/.+_test).lua") do
        local result = require(mod)
        result:showResult()
        print("-------")
        result:showFailures()
        print(result:succeededCount() .. " / " .. result:caseCount())
    end
end
