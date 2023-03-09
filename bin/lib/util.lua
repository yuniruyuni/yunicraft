function deepEquals(lhs, rhs)
    if type(lhs) ~= "table" then return lhs == rhs end
    if type(rhs) ~= "table" then return lhs == rhs end

    for k, v in pairs(lhs) do
        if not deepEquals(lhs[k], rhs[k]) then
            return false
        end
    end

    for k, v in pairs(rhs) do
        if not deepEquals(lhs[k], rhs[k]) then
            return false
        end
    end

    return true
end
