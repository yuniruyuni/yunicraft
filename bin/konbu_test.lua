local test = require("bin/test")

test:case("assert test", function(t)
    t:assert(1 + 1, 2)
end)

return test
