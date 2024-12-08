--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
if (SERVER) then
    util.AddNetworkString("ipr_swheelsync")
end
function ipr_NumberOfBits(n)
    return isnumber(n) and ((n <= 1) and 0 or (math.floor(math.log(n) / math.log(2)) + 1)) or 0
end
