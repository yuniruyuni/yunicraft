while true do
    redstone.setOutput("top", true)
    os.sleep(0.05)
    redstone.setOutput("top", false)
    os.sleep(0.05)
end
