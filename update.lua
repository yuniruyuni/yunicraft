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
}

for idx = 1, #FILELIST do
    local file = FILELIST[idx]
    local url = "https://raw.githubusercontent.com/yuniruyuni/yunicraft/main/" .. file
    local req = http.get(url)
    local downloaded = req.readAll()
    local f = fs.open("bin/" .. file, "w")
    f.write(downloaded)
    f.close()
    req.close()
end
