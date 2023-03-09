local test = require("bin/test")
require("bin/lib/util")

test:case("deepEquals", function (t)
    t:assert(deepEquals({}, {}))
    t:assert(deepEquals({a = "a"}, {a = "a"}))
    t:assert(not deepEquals({a = "a"}, {a = "b"}))
    t:assert(not deepEquals({a = "a"}, {b = "a"}))
    t:assert(deepEquals(
        {xs = {i = "i"}},
        {xs = {i = "i"}}
    ))
    t:assert(not deepEquals(
        {xs = {i = "i"}},
        {xs = {i = "j"}}
    ))
    t:assert(not deepEquals(
        {xs = {i = "i"}},
        {ys = {i = "i"}}
    ))
end)


return test
