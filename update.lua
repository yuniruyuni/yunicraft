tag = arg[1]
if not tag then
    tag = "main"
end

fs.delete("bin")
fs.makeDir("bin")

FILELIST = {
    "area-dig.lua",
    "dig.lua",
    "digf-l3.lua",
    "digforward.lua",
    "digup-tree.lua",
    "digup.lua",
    "item.lua",
    "opendoor.lua",
    "total-dig.lua",
    "update.lua",
}

for idx = 1, #FILELIST do
    local file = FILELIST[idx]
    local url = "https://raw.githubusercontent.com/yuniruyuni/yunicraft/" .. tag .. "/" .. file
    local req = http.get(url)
    local downloaded = req.readAll()
    local f = fs.open("bin/" .. file, "w")
    f.write(downloaded)
    f.close()
    req.close()
end

fs.delete("update.lua")
fs.move("bin/update.lua", "update.lua")
