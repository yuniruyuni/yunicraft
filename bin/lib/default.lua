local function default(def, obj)
    local res = {}
	for k, v in pairs(def) do
		res[k] = v
	end
	for k, v in pairs(obj) do
		res[k] = v
	end
    return res
end

return default
