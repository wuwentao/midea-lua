local bit                                        = require "bit"
local uptable                                    = {}
local JSON                                       = require "cjson"
local KEY_VERSION                                = "version"
uptable["KEY_POWER"]                             = "power"
uptable["KEY_FANSPEED"]                          = "wind_speed"
uptable["KEY_SET_HUMIDITY"]                      = "humidity"
uptable["KEY_TANK_STATUS"]                       = "tank_status"
uptable["KEY_CUR_HUMIDITY"]                      = "cur_humidity"
uptable["KEY_CUR_TEMPERATURE"]                   = "cur_temperature"
uptable["KEY_ERROR_CODE"]                        = "error_code"
uptable["KEY_HUMIDIFY_MODE"]                     = "humidity_mode"
uptable["KEY_BRIGHT_LED"]                        = "bright_led"
uptable["KEY_SCHEDULE_CLOSE_SWITCHER"]           = "power_off_timer"
uptable["KEY_SCHEDULE_CLOSE_TIME"]               = "time_off"
uptable["KEY_SCHEDULE_OPEN_SWITCHER"]            = "power_on_timer"
uptable["KEY_SCHEDULE_OPEN_TIME"]                = "time_on"
uptable["KEY_RUNNING_PERCENT"]                   = "running_percent"
uptable["KEY_DISINFECT_ON_OFF"]                  = "disinfect_on_off"
uptable["KEY_WIND_GEAR"]                         = "wind_gear"
local VALUE_VERSION                              = 25
uptable["VALUE_ON"]                              = "on"
uptable["VALUE_OFF"]                             = "off"
uptable["VALUE_FANSPEED_HIGH"]                   = "high"
uptable["VALUE_FANSPEED_MID"]                    = "middle"
uptable["VALUE_FANSPEED_LOW"]                    = "low"
uptable["VALUE_FANSPEED_AUTO"]                   = "auto"
uptable["VALUE_FANSPEED_OFF"]                    = "off"
uptable["VALUE_FANSPEED_LOWEST"]                 = "lowest"
uptable["VALUE_MODE_CONTINUE"]                   = "continue"
uptable["VALUE_MODE_PARLOUR"]                    = "parlour"
uptable["VALUE_MODE_BEDROOM"]                    = "bedroom"
uptable["VALUE_MODE_KITCHEN"]                    = "kitchen"
uptable["VALUE_MODE_MANUAL"]                     = "manual"
uptable["VALUE_MODE_AUTO"]                       = "auto"
uptable["VALUE_MODE_SLEEP"]                      = "sleep"
uptable["VALUE_BRIGHT_LIGHT"]                    = "light"
uptable["VALUE_BRIGHT_DARK"]                     = "dark"
uptable["VALUE_BRIGHT_EXIT"]                     = "exit"
uptable["VALUE_SCHEDULE_CLOSE_SWITCHER_ON"]      = "on"
uptable["VALUE_SCHEDULE_CLOSE_SWITCHER_OFF"]     = "off"
uptable["VALUE_SCHEDULE_OPEN_SWITCHER_ON"]       = "on"
uptable["VALUE_SCHEDULE_OPEN_SWITCHER_OFF"]      = "off"
uptable["VALUE_DISINFECT_ON"]                    = "on"
uptable["VALUE_DISINFECT_OFF"]                   = "off"
uptable["VALUE_DISINFECT_INVALID"]               = "invalid"
uptable["BYTE_DEVICE_TYPE"]                      = 0xFD
uptable["BYTE_CONTROL_REQUEST"]                  = 0x02
uptable["BYTE_QUERY_REQUEST"]                    = 0x03
uptable["BYTE_PROTOCOL_HEAD"]                    = 0xAA
uptable["BYTE_PROTOCOL_LENGTH"]                  = 0x0A
uptable["BYTE_POWER_ON"]                         = 0x01
uptable["BYTE_POWER_OFF"]                        = 0x00
uptable["BYTE_FANSPEED_LOW"]                     = 0x28
uptable["BYTE_FANSPEED_LOW_2"]                   = 0x27
uptable["BYTE_FANSPEED_MID"]                     = 0x3C
uptable["BYTE_FANSPEED_MID_2"]                   = 0x3B
uptable["BYTE_FANSPEED_HIGH"]                    = 0x50
uptable["BYTE_FANSPEED_AUTO"]                    = 0x66
uptable["BYTE_FANSPEED_AUTO_2"]                  = 0x65
uptable["BYTE_FANSPEED_OFF"]                     = 0x7F
uptable["BYTE_FANSPEED_LOWEST"]                  = 0x01
uptable["BYTE_BUZZER_ON"]                        = 0x40
uptable["BYTE_BUZZER_OFF"]                       = 0x00
uptable["BYTE_MODE_MANUAL"]                      = 0x01
uptable["BYTE_MODE_AUTO"]                        = 0x02
uptable["BYTE_MODE_CONTINUE"]                    = 0x03
uptable["BYTE_MODE_PARLOUR"]                     = 0x04
uptable["BYTE_MODE_BEDROOM"]                     = 0x05
uptable["BYTE_MODE_KITCHEN"]                     = 0x06
uptable["BYTE_MODE_SLEEP"]                       = 0x07
uptable["BYTE_BRIGHT_LIGHT"]                     = 0x00
uptable["BYTE_BRIGHT_DARK"]                      = 0x06
uptable["BYTE_BRIGHT_EXIT"]                      = 0x07
uptable["BYTE_SCHEDULE_CLOSE_TIME_SWITCHER_ON"]  = 0x80
uptable["BYTE_SCHEDULE_CLOSE_TIME_SWITCHER_OFF"] = 0x7F
uptable["BYTE_SCHEDULE_OPEN_TIME_SWITCHER_ON"]   = 0x80
uptable["BYTE_SCHEDULE_OPEN_TIME_SWITCHER_OFF"]  = 0x7F
uptable["BYTE_DISINFECT_ON"]                     = 0x01
uptable["BYTE_DISINFECT_OFF"]                    = 0x02
uptable["BYTE_DISINFECT_INVALID"]                = 0x00
uptable["powerValue"]                            = 0
uptable["setHumidityValue"]                      = 0
uptable["fanspeedValue"]                         = 0
uptable["currentHumidityValue"]                  = 0
uptable["tankStatusValue"]                       = 0
uptable["errorCode"]                             = 0
uptable["disinfectOnOffValue"]                   = 0
uptable["windGearValue"]                         = 0
uptable["currentTemperatureValue"]               = 0
uptable["running_percent"]                       = 0
uptable["humidityMode"]                          = 0
uptable["brightLED"]                             = 0
uptable["scheduleCloseSwitcher"]                 = false
uptable["scheduleCloseTime"]                     = 0
uptable["scheduleOpenSwitcher"]                  = false
uptable["scheduleOpenTime"]                      = 0
local function print_lua_table(lua_table, indent)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then k = string.format("%q", k) end
        local szSuffix = ""
        if type(v) == "table" then szSuffix = "{" end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix .. "[" .. k .. "]" .. " = " .. szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix .. "},")
        else
            local szValue = ""
            if type(v) == "string" then szValue = string.format("%q", v) else szValue = tostring(v) end
            print(formatting .. szValue .. ",")
        end
    end
end
local function checkBoundary(data, min, max)
    if (not data) then data = 0 end
    data = tonumber(data)
    if (data == nil) then data = 0 end
    if ((data >= min) and (data <= max)) then return data else if (data < min) then return min else return max end end
end
local function table2string(cmd)
    local ret = ""
    local i
    for i = 1, #cmd do ret = ret .. string.char(cmd[i]) end
    return ret
end
local function string2table(hexstr)
    local tb = {}
    local i = 1
    local j = 1
    for i = 1, #hexstr - 1, 2 do
        local doublebytestr = string.sub(hexstr, i, i + 1)
        tb[j] = tonumber(doublebytestr, 16)
        j = j + 1
    end
    return tb
end
local function string2hexstring(str)
    local ret = ""
    for i = 1, #str do ret = ret .. string.format("%02x", str:byte(i)) end
    return ret
end
local function string2Int(data)
    if (not data) then data = tonumber("0") end
    data = tonumber(data)
    if (data == nil) then data = 0 end
    return data
end
local function int2String(data)
    if (not data) then data = tostring(0) end
    data = tostring(data)
    if (data == nil) then data = "0" end
    return data
end
local function encode(cmd)
    local tb
    if JSON == nil then JSON = require "cjson" end
    tb = JSON.encode(cmd)
    return tb
end
local function decode(cmd)
    local tb
    if JSON == nil then JSON = require "cjson" end
    tb = JSON.decode(cmd)
    return tb
end
local function makeSum(tmpbuf, start_pos, end_pos)
    local resVal = 0
    for si = start_pos, end_pos do
        resVal = resVal + tmpbuf[si]
        if resVal > 0xff then resVal = bit.band(resVal, 0xff) end
    end
    resVal = 255 - resVal + 1
    return resVal
end
local crc8_854_table = { 0, 94, 188, 226, 97, 63, 221, 131, 194, 156, 126, 32, 163, 253, 31, 65, 157, 195, 33, 127, 252, 162, 64, 30, 95, 1, 227, 189, 62, 96, 130, 220, 35, 125, 159, 193, 66, 28, 254, 160, 225, 191, 93, 3, 128, 222, 60, 98, 190, 224, 2, 92, 223, 129, 99, 61, 124, 34, 192, 158, 29, 67, 161, 255, 70, 24, 250, 164, 39, 121, 155, 197, 132, 218, 56, 102, 229, 187, 89, 7, 219, 133, 103, 57, 186, 228, 6, 88, 25, 71, 165, 251, 120, 38, 196, 154, 101, 59, 217, 135, 4, 90, 184, 230, 167, 249, 27, 69, 198, 152, 122, 36, 248, 166, 68, 26, 153, 199, 37, 123, 58, 100, 134, 216, 91, 5, 231, 185, 140, 210, 48, 110, 237, 179, 81, 15, 78, 16, 242, 172, 47, 113, 147, 205, 17, 79, 173, 243, 112, 46, 204, 146, 211, 141, 111, 49, 178, 236, 14, 80, 175, 241, 19, 77, 206, 144, 114, 44, 109, 51, 209, 143, 12, 82, 176, 238, 50, 108, 142, 208, 83, 13, 239, 177, 240, 174, 76, 18, 145, 207, 45, 115, 202, 148, 118, 40, 171, 245, 23, 73, 8, 86, 180, 234, 105, 55, 213, 139, 87, 9, 235, 181, 54, 104, 138, 212, 149, 203, 41, 119, 244, 170, 72, 22, 233, 183, 85, 11, 136, 214, 52, 106, 43, 117, 151, 201, 74, 20, 246, 168, 116, 42, 200, 150, 21, 75, 169, 247, 182, 232, 10, 84, 215, 137, 107, 53 }
local function crc8_854(dataBuf, start_pos, end_pos)
    local crc = 0
    for si = start_pos, end_pos do crc = crc8_854_table[bit.band(bit.bxor(crc, dataBuf[si]), 0xFF) + 1] end
    return crc
end
local function jsonToModel(jsonCmd)
    local streams = jsonCmd
    if (streams[uptable["KEY_POWER"]] == uptable["VALUE_ON"]) then
        uptable["powerValue"] = uptable["BYTE_POWER_ON"]
    elseif (streams[uptable["KEY_POWER"]] == uptable["VALUE_OFF"]) then
        uptable["powerValue"] =
            uptable["BYTE_POWER_OFF"]
    end
    if (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_HIGH"]) then
        uptable["fanspeedValue"] = uptable
            ["BYTE_FANSPEED_HIGH"]
    elseif (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_MID"]) then
        uptable["fanspeedValue"] =
            uptable["BYTE_FANSPEED_MID"]
    elseif (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_LOW"]) then
        uptable["fanspeedValue"] =
            uptable["BYTE_FANSPEED_LOW"]
    elseif (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_AUTO"]) then
        uptable["fanspeedValue"] =
            uptable["BYTE_FANSPEED_AUTO"]
    elseif (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_OFF"]) then
        uptable["fanspeedValue"] =
            uptable["BYTE_FANSPEED_OFF"]
    end
    if (streams[uptable["KEY_SET_HUMIDITY"]] ~= nil) then
        uptable["setHumidityValue"] = checkBoundary(
            streams[uptable["KEY_SET_HUMIDITY"]], 1, 100)
    end
    if (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_CONTINUE"]) then
        uptable["humidityMode"] = uptable
            ["BYTE_MODE_CONTINUE"]
    elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_PARLOUR"]) then
        uptable["humidityMode"] =
            uptable["BYTE_MODE_PARLOUR"]
    elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_BEDROOM"]) then
        uptable["humidityMode"] =
            uptable["BYTE_MODE_BEDROOM"]
    elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_KITCHEN"]) then
        uptable["humidityMode"] =
            uptable["BYTE_MODE_KITCHEN"]
    elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_MANUAL"]) then
        uptable["humidityMode"] =
            uptable["BYTE_MODE_MANUAL"]
    elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_AUTO"]) then
        uptable["humidityMode"] =
            uptable["BYTE_MODE_AUTO"]
    elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_SLEEP"]) then
        uptable["humidityMode"] =
            uptable["BYTE_MODE_SLEEP"]
    end
    if (streams[uptable["KEY_BRIGHT_LED"]] == uptable["VALUE_BRIGHT_LIGHT"]) then
        uptable["brightLED"] = uptable
            ["BYTE_BRIGHT_LIGHT"]
    elseif (streams[uptable["KEY_BRIGHT_LED"]] == uptable["VALUE_BRIGHT_DARK"]) then
        uptable["brightLED"] =
            uptable["BYTE_BRIGHT_DARK"]
    elseif (streams[uptable["KEY_BRIGHT_LED"]] == uptable["VALUE_BRIGHT_EXIT"]) then
        uptable["brightLED"] =
            uptable["BYTE_BRIGHT_EXIT"]
    end
    if streams[uptable["KEY_SCHEDULE_CLOSE_SWITCHER"]] == uptable["VALUE_SCHEDULE_CLOSE_SWITCHER_ON"] then uptable["scheduleCloseSwitcher"] = true elseif streams[uptable["KEY_SCHEDULE_CLOSE_SWITCHER"]] == uptable["VALUE_SCHEDULE_CLOSE_SWITCHER_OFF"] then uptable["scheduleCloseSwitcher"] = false end
    if streams[uptable["KEY_SCHEDULE_CLOSE_TIME"]] ~= nil then
        uptable["scheduleCloseTime"] = streams
            [uptable["KEY_SCHEDULE_CLOSE_TIME"]]
    end
    if streams[uptable["KEY_SCHEDULE_OPEN_SWITCHER"]] == uptable["VALUE_SCHEDULE_OPEN_SWITCHER_ON"] then uptable["scheduleOpenSwitcher"] = true elseif streams[uptable["KEY_SCHEDULE_OPEN_SWITCHER"]] == uptable["VALUE_SCHEDULE_OPEN_SWITCHER_OFF"] then uptable["scheduleOpenSwitcher"] = false end
    if streams[uptable["KEY_SCHEDULE_OPEN_TIME"]] ~= nil then
        uptable["scheduleOpenTime"] = streams
            [uptable["KEY_SCHEDULE_OPEN_TIME"]]
    end
    if streams[uptable["KEY_DISINFECT_ON_OFF"]] ~= nil then
        if streams[uptable["KEY_DISINFECT_ON_OFF"]] == uptable["VALUE_DISINFECT_ON"] then
            uptable["disinfectOnOffValue"] =
                uptable["BYTE_DISINFECT_ON"]
        elseif streams[uptable["KEY_DISINFECT_ON_OFF"]] == uptable["VALUE_DISINFECT_OFF"] then
            uptable["disinfectOnOffValue"] =
                uptable["BYTE_DISINFECT_OFF"]
        elseif streams[uptable["KEY_DISINFECT_ON_OFF"]] == uptable["VALUE_DISINFECT_INVALID"] then
            uptable["disinfectOnOffValue"] =
                uptable["BYTE_DISINFECT_INVALID"]
        end
    end
    if (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_HIGH"]) then
        uptable["windGearValue"] = uptable
            ["BYTE_FANSPEED_HIGH"]
    elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_MID"]) then
        uptable["windGearValue"] =
            uptable["BYTE_FANSPEED_MID"]
    elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_LOW"]) then
        uptable["windGearValue"] =
            uptable["BYTE_FANSPEED_LOW"]
    elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_LOWEST"]) then
        uptable["windGearValue"] =
            uptable["BYTE_FANSPEED_LOWEST"]
    elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_AUTO"]) then
        uptable["windGearValue"] =
            uptable["BYTE_FANSPEED_AUTO"]
    elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_OFF"]) then
        uptable["windGearValue"] =
            uptable["BYTE_FANSPEED_OFF"]
    end
end
local function jsonToModelByStatus(jsonCmd, subType)
    local streams = jsonCmd
    if (streams[uptable["KEY_POWER"]] == uptable["VALUE_ON"]) then
        uptable["powerValue"] = uptable["BYTE_POWER_ON"]
    elseif (streams[uptable["KEY_POWER"]] == uptable["VALUE_OFF"]) then
        uptable["powerValue"] =
            uptable["BYTE_POWER_OFF"]
    end
    uptable["fanspeedValue"] = 0
    if subType < 8 then
        if (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_HIGH"]) then
            uptable["fanspeedValue"] =
                uptable["BYTE_FANSPEED_HIGH"]
        elseif (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_MID"]) then
            uptable["fanspeedValue"] =
                uptable["BYTE_FANSPEED_MID"]
        elseif (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_LOW"]) then
            uptable["fanspeedValue"] =
                uptable["BYTE_FANSPEED_LOW"]
        elseif (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_AUTO"]) then
            uptable["fanspeedValue"] =
                uptable["BYTE_FANSPEED_AUTO"]
        elseif (streams[uptable["KEY_FANSPEED"]] == uptable["VALUE_FANSPEED_OFF"]) then
            uptable["fanspeedValue"] =
                uptable["BYTE_FANSPEED_OFF"]
        end
    end
    if (streams[uptable["KEY_SET_HUMIDITY"]] ~= nil) then
        uptable["setHumidityValue"] = checkBoundary(
            streams[uptable["KEY_SET_HUMIDITY"]], 1, 100)
    end
    uptable["humidityMode"] = 0
    if subType < 8 then
        if (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_CONTINUE"]) then
            uptable["humidityMode"] =
                uptable["BYTE_MODE_CONTINUE"]
        elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_PARLOUR"]) then
            uptable["humidityMode"] =
                uptable["BYTE_MODE_PARLOUR"]
        elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_BEDROOM"]) then
            uptable["humidityMode"] =
                uptable["BYTE_MODE_BEDROOM"]
        elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_KITCHEN"]) then
            uptable["humidityMode"] =
                uptable["BYTE_MODE_KITCHEN"]
        elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_MANUAL"]) then
            uptable["humidityMode"] =
                uptable["BYTE_MODE_MANUAL"]
        elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_AUTO"]) then
            uptable["humidityMode"] =
                uptable["BYTE_MODE_AUTO"]
        elseif (streams[uptable["KEY_HUMIDIFY_MODE"]] == uptable["VALUE_MODE_SLEEP"]) then
            uptable["humidityMode"] =
                uptable["BYTE_MODE_SLEEP"]
        end
    end
    if (streams[uptable["KEY_BRIGHT_LED"]] == uptable["VALUE_BRIGHT_LIGHT"]) then
        uptable["brightLED"] = uptable
            ["BYTE_BRIGHT_LIGHT"]
    elseif (streams[uptable["KEY_BRIGHT_LED"]] == uptable["VALUE_BRIGHT_DARK"]) then
        uptable["brightLED"] =
            uptable["BYTE_BRIGHT_DARK"]
    elseif (streams[uptable["KEY_BRIGHT_LED"]] == uptable["VALUE_BRIGHT_EXIT"]) then
        uptable["brightLED"] =
            uptable["BYTE_BRIGHT_EXIT"]
    end
    if streams[uptable["KEY_SCHEDULE_CLOSE_SWITCHER"]] == uptable["VALUE_SCHEDULE_CLOSE_SWITCHER_ON"] then uptable["scheduleCloseSwitcher"] = true elseif streams[uptable["KEY_SCHEDULE_CLOSE_SWITCHER"]] == uptable["VALUE_SCHEDULE_CLOSE_SWITCHER_OFF"] then uptable["scheduleCloseSwitcher"] = false end
    if streams[uptable["KEY_SCHEDULE_CLOSE_TIME"]] ~= nil then
        uptable["scheduleCloseTime"] = streams
            [uptable["KEY_SCHEDULE_CLOSE_TIME"]]
    end
    if streams[uptable["KEY_SCHEDULE_OPEN_SWITCHER"]] == uptable["VALUE_SCHEDULE_OPEN_SWITCHER_ON"] then uptable["scheduleOpenSwitcher"] = true elseif streams[uptable["KEY_SCHEDULE_OPEN_SWITCHER"]] == uptable["VALUE_SCHEDULE_OPEN_SWITCHER_OFF"] then uptable["scheduleOpenSwitcher"] = false end
    if streams[uptable["KEY_SCHEDULE_OPEN_TIME"]] ~= nil then
        uptable["scheduleOpenTime"] = streams
            [uptable["KEY_SCHEDULE_OPEN_TIME"]]
    end
    if streams[uptable["KEY_DISINFECT_ON_OFF"]] ~= nil then
        if streams[uptable["KEY_DISINFECT_ON_OFF"]] == uptable["VALUE_DISINFECT_ON"] then
            uptable["disinfectOnOffValue"] =
                uptable["BYTE_DISINFECT_ON"]
        elseif streams[uptable["KEY_DISINFECT_ON_OFF"]] == uptable["VALUE_DISINFECT_OFF"] then
            uptable["disinfectOnOffValue"] =
                uptable["BYTE_DISINFECT_OFF"]
        elseif streams[uptable["KEY_DISINFECT_ON_OFF"]] == uptable["VALUE_DISINFECT_INVALID"] then
            uptable["disinfectOnOffValue"] =
                uptable["BYTE_DISINFECT_INVALID"]
        end
    end
    uptable["windGearValue"] = 0
    if subType < 8 then
        if (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_HIGH"]) then
            uptable["windGearValue"] =
                uptable["BYTE_FANSPEED_HIGH"]
        elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_MID"]) then
            uptable["windGearValue"] =
                uptable["BYTE_FANSPEED_MID"]
        elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_LOW"]) then
            uptable["windGearValue"] =
                uptable["BYTE_FANSPEED_LOW"]
        elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_LOWEST"]) then
            uptable["windGearValue"] =
                uptable["BYTE_FANSPEED_LOWEST"]
        elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_AUTO"]) then
            uptable["windGearValue"] =
                uptable["BYTE_FANSPEED_AUTO"]
        elseif (streams[uptable["KEY_WIND_GEAR"]] == uptable["VALUE_FANSPEED_OFF"]) then
            uptable["windGearValue"] =
                uptable["BYTE_FANSPEED_OFF"]
        end
    end
end
local function binToModel(binData)
    if (#binData == 0) then return nil end
    local messageBytes = binData
    local sub_cmd = messageBytes[0]
    uptable["powerValue"] = bit.band(messageBytes[1], 0x01)
    uptable["fanspeedValue"] = bit.band(messageBytes[3], 0x7F)
    uptable["setHumidityValue"] = messageBytes[7]
    uptable["currentHumidityValue"] = messageBytes[16]
    uptable["currentTemperatureValue"] = (messageBytes[17] - 50) / 2
    uptable["tankStatusValue"] = messageBytes[10]
    uptable["errorCode"] = messageBytes[21]
    if sub_cmd == 0xC8 then
        uptable["humidityMode"] = bit.rshift(bit.band(messageBytes[8], 0x70), 4)
    elseif sub_cmd == 0xA0 then
        uptable["humidityMode"] =
            bit.band(messageBytes[10], 0x07)
    end
    uptable["brightLED"] = bit.band(messageBytes[9], 0x07)
    if (bit.band(messageBytes[5], uptable["BYTE_SCHEDULE_CLOSE_TIME_SWITCHER_ON"]) == uptable["BYTE_SCHEDULE_CLOSE_TIME_SWITCHER_ON"]) then uptable["scheduleCloseSwitcher"] = true else uptable["scheduleCloseSwitcher"] = false end
    local timingOffMul15 = bit.band(messageBytes[5], 0x7F)
    local timingOffLeft15 = bit.band(messageBytes[6], 0x0F)
    uptable["scheduleCloseTime"] = timingOffMul15 * 15 + (15 - timingOffLeft15)
    if (bit.band(messageBytes[4], uptable["BYTE_SCHEDULE_OPEN_TIME_SWITCHER_ON"]) == uptable["BYTE_SCHEDULE_OPEN_TIME_SWITCHER_ON"]) then uptable["scheduleOpenSwitcher"] = true else uptable["scheduleOpenSwitcher"] = false end
    local timingOnMul15         = bit.band(messageBytes[4], 0x7F)
    local timingOnLeft15        = bit.rshift(bit.band(messageBytes[6], 0xf0), 4)
    uptable["scheduleOpenTime"] = timingOnMul15 * 15 + (15 - timingOnLeft15)
    if #messageBytes >= 33 then uptable["running_percent"] = messageBytes[30] end
    if sub_cmd == 0xC8 then
        if #messageBytes >= 37 then uptable["disinfectOnOffValue"] = bit.band(messageBytes[34], 0x03) end
    elseif sub_cmd == 0xA0 then
        if #messageBytes >= 30 then
            uptable["disinfectOnOffValue"] =
                bit.band(messageBytes[27], 0x03)
        end
    end
    if sub_cmd == 0xC8 then
        if #messageBytes >= 41 then uptable["windGearValue"] = messageBytes[39] end
    elseif sub_cmd == 0xA0 then
        if #messageBytes >= 34 then
            uptable["windGearValue"] =
                messageBytes[32]
        end
    end
end
function jsonToData(jsonCmd)
    if (#jsonCmd == 0) then return nil end
    local infoM = {}
    local bodyBytes = {}
    local json = decode(jsonCmd)
    local deviceSubType = json["deviceinfo"]["deviceSubType"]
    if deviceSubType == nil then
        deviceSubType = 0
    else
        if type(deviceSubType) == "string" then
            deviceSubType = tonumber(
                deviceSubType)
        end
    end
    if (deviceSubType > 5) then
        uptable["BYTE_FANSPEED_MID"]  = 0x3B
        uptable["BYTE_FANSPEED_LOW"]  = 0x27
        uptable["BYTE_FANSPEED_AUTO"] = 0x65
    end
    local query = json["query"]
    local control = json["control"]
    local status = json["status"]
    if (status) then jsonToModelByStatus(status, deviceSubType) end
    local bodyLength = 0
    local msgBytes = {}
    if (query) then bodyLength = 21 elseif (control) then bodyLength = 23 end
    local msgLength = bodyLength + uptable["BYTE_PROTOCOL_LENGTH"] + 1
    for i = 0, bodyLength do bodyBytes[i] = 0 end
    for i = 0, msgLength do msgBytes[i] = 0 end
    msgBytes[0] = uptable["BYTE_PROTOCOL_HEAD"]
    msgBytes[1] = bodyLength + uptable["BYTE_PROTOCOL_LENGTH"] + 1
    msgBytes[2] = uptable["BYTE_DEVICE_TYPE"]
    if (query) then
        bodyBytes[0] = 0x41
        bodyBytes[1] = 0x81
        bodyBytes[3] = 0xFF
        bodyBytes[4] = 0x03
        bodyBytes[7] = 0x02
        math.randomseed(os.time())
        bodyBytes[20] = math.random(1, 254)
        bodyBytes[bodyLength] = crc8_854(bodyBytes, 0, bodyLength - 1)
        msgBytes[9] = uptable["BYTE_QUERY_REQUEST"]
    elseif (control) then
        if (status) then jsonToModelByStatus(status, deviceSubType) end
        if (control) then jsonToModel(control) end
        bodyBytes[0] = 0x48
        if (uptable["powerValue"] ~= nil) then
            bodyBytes[1] = bit.bor(
                bit.bor(uptable["powerValue"], uptable["BYTE_BUZZER_ON"]), 0x02)
        end
        if (uptable["fanspeedValue"] ~= nil) then bodyBytes[3] = uptable["fanspeedValue"] end
        local timingOffValue = uptable["scheduleCloseTime"]
        if type(timingOffValue) == "string" then timingOffValue = string2Int(timingOffValue) end
        local timingOffMul15 = math.floor(timingOffValue / 15)
        local timingOffLeft15 = 15 - (timingOffValue % 15)
        if uptable["scheduleCloseSwitcher"] == true then
            bodyBytes[3] = bit.bor(bodyBytes[3], 0x80)
            bodyBytes[5] = bit.bor(uptable["BYTE_SCHEDULE_CLOSE_TIME_SWITCHER_ON"], timingOffMul15)
        else
            bodyBytes[5] = bit.bor(uptable["BYTE_SCHEDULE_CLOSE_TIME_SWITCHER_OFF"], timingOffMul15)
        end
        bodyBytes[6] = bit.bor(bodyBytes[6], timingOffLeft15)
        if timingOffValue == 1920 then
            bodyBytes[5] = 0x7F
            bodyBytes[6] = bit.band(bodyBytes[6], 0xF0)
        end
        local timingOnValue = uptable["scheduleOpenTime"]
        if type(timingOnValue) == "string" then timingOnValue = string2Int(timingOnValue) end
        local timingOnMul15 = math.floor(timingOnValue / 15)
        local timingOnLeft15 = 15 - (timingOnValue % 15)
        if uptable["scheduleOpenSwitcher"] == true then
            bodyBytes[3] = bit.bor(bodyBytes[3], 0x80)
            bodyBytes[4] = bit.bor(uptable["BYTE_SCHEDULE_OPEN_TIME_SWITCHER_ON"], timingOnMul15)
        else
            bodyBytes[4] = bit.bor(uptable["BYTE_SCHEDULE_OPEN_TIME_SWITCHER_OFF"], timingOnMul15)
        end
        bodyBytes[6] = bit.bor(bodyBytes[6], bit.lshift(timingOnLeft15, 4))
        if timingOnValue == 1920 then
            bodyBytes[4] = 0x7F
            bodyBytes[6] = bit.band(bodyBytes[6], 0x0F)
        end
        if (uptable["setHumidityValue"] ~= nil) then bodyBytes[7] = uptable["setHumidityValue"] end
        if (uptable["brightLED"] ~= nil) then bodyBytes[9] = uptable["brightLED"] end
        if (uptable["humidityMode"] ~= nil) then bodyBytes[10] = uptable["humidityMode"] end
        if uptable["disinfectOnOffValue"] ~= nil then bodyBytes[15] = uptable["disinfectOnOffValue"] end
        if uptable["windGearValue"] ~= nil then bodyBytes[18] = uptable["windGearValue"] end
        bodyBytes[22] = math.random(1, 254)
        bodyBytes[bodyLength] = crc8_854(bodyBytes, 0, bodyLength - 1)
        msgBytes[9] = uptable["BYTE_CONTROL_REQUEST"]
    end
    for i = 0, bodyLength do msgBytes[i + uptable["BYTE_PROTOCOL_LENGTH"]] = bodyBytes[i] end
    msgBytes[msgLength] = makeSum(msgBytes, 1, msgLength - 1)
    for i = 1, msgLength + 1 do infoM[i] = msgBytes[i - 1] end
    local ret = table2string(infoM)
    ret = string2hexstring(ret)
    return ret
end

function dataToJson(jsonCmd)
    if (not jsonCmd) then return nil end
    local json = decode(jsonCmd)
    local deviceinfo = json["deviceinfo"]
    local deviceSubType = deviceinfo["deviceSubType"]
    if deviceSubType == nil then
        deviceSubType = 0
    else
        if type(deviceSubType) == "string" then
            deviceSubType = tonumber(
                deviceSubType)
        end
    end
    uptable["BYTE_FANSPEED_LOW"]  = 0x28
    uptable["BYTE_FANSPEED_MID"]  = 0x3C
    uptable["BYTE_FANSPEED_AUTO"] = 0x66
    local binData                 = json["msg"]["data"]
    local info                    = {}
    local msgBytes                = {}
    local bodyBytes               = {}
    local msgLength               = 0
    local bodyLength              = 0
    info                          = string2table(binData)
    local dataType                = info[10]
    if ((dataType ~= 0x02) and (dataType ~= 0x03) and (dataType ~= 0x04)) then return nil end
    local sub_cmd = info[11]
    if sub_cmd == 0x01 then return nil end
    for i = 1, #info do msgBytes[i - 1] = info[i] end
    msgLength = msgBytes[1]
    bodyLength = msgLength - uptable["BYTE_PROTOCOL_LENGTH"] - 1
    for i = 0, bodyLength do bodyBytes[i] = msgBytes[i + uptable["BYTE_PROTOCOL_LENGTH"]] end
    binToModel(bodyBytes)
    local streams = {}
    streams[KEY_VERSION] = VALUE_VERSION
    if (uptable["powerValue"] == uptable["BYTE_POWER_ON"]) then
        streams[uptable["KEY_POWER"]] = uptable["VALUE_ON"]
    elseif (uptable["powerValue"] == uptable["BYTE_POWER_OFF"]) then
        streams[uptable["KEY_POWER"]] =
            uptable["VALUE_OFF"]
    end
    if (uptable["fanspeedValue"] == uptable["BYTE_FANSPEED_HIGH"]) then
        streams[uptable["KEY_FANSPEED"]] = uptable
            ["VALUE_FANSPEED_HIGH"]
    elseif (uptable["fanspeedValue"] == uptable["BYTE_FANSPEED_MID"] or uptable["fanspeedValue"] == uptable["BYTE_FANSPEED_MID_2"]) then
        streams[uptable["KEY_FANSPEED"]] =
            uptable["VALUE_FANSPEED_MID"]
    elseif (uptable["fanspeedValue"] == uptable["BYTE_FANSPEED_LOW"] or uptable["fanspeedValue"] == uptable["BYTE_FANSPEED_LOW_2"]) then
        streams[uptable["KEY_FANSPEED"]] =
            uptable["VALUE_FANSPEED_LOW"]
    elseif (uptable["fanspeedValue"] == uptable["BYTE_FANSPEED_AUTO"] or uptable["fanspeedValue"] == uptable["BYTE_FANSPEED_AUTO_2"]) then
        streams[uptable["KEY_FANSPEED"]] =
            uptable["VALUE_FANSPEED_AUTO"]
    elseif (uptable["fanspeedValue"] == uptable["BYTE_FANSPEED_OFF"]) then
        streams[uptable["KEY_FANSPEED"]] =
            uptable["VALUE_FANSPEED_OFF"]
    end
    streams[uptable["KEY_SET_HUMIDITY"]] = uptable["setHumidityValue"]
    streams[uptable["KEY_CUR_HUMIDITY"]] = uptable["currentHumidityValue"]
    streams[uptable["KEY_CUR_TEMPERATURE"]] = uptable["currentTemperatureValue"]
    streams[uptable["KEY_TANK_STATUS"]] = uptable["tankStatusValue"]
    streams[uptable["KEY_ERROR_CODE"]] = uptable["errorCode"]
    if (uptable["brightLED"] == uptable["BYTE_BRIGHT_LIGHT"]) then
        streams[uptable["KEY_BRIGHT_LED"]] = uptable
            ["VALUE_BRIGHT_LIGHT"]
    elseif (uptable["brightLED"] == uptable["BYTE_BRIGHT_DARK"]) then
        streams[uptable["KEY_BRIGHT_LED"]] =
            uptable["VALUE_BRIGHT_DARK"]
    elseif (uptable["brightLED"] == uptable["BYTE_BRIGHT_EXIT"]) then
        streams[uptable["KEY_BRIGHT_LED"]] =
            uptable["VALUE_BRIGHT_EXIT"]
    end
    if (uptable["humidityMode"] == uptable["BYTE_MODE_CONTINUE"]) then
        streams[uptable["KEY_HUMIDIFY_MODE"]] = uptable
            ["VALUE_MODE_CONTINUE"]
    elseif (uptable["humidityMode"] == uptable["BYTE_MODE_PARLOUR"]) then
        streams[uptable["KEY_HUMIDIFY_MODE"]] =
            uptable["VALUE_MODE_PARLOUR"]
    elseif (uptable["humidityMode"] == uptable["BYTE_MODE_BEDROOM"]) then
        streams[uptable["KEY_HUMIDIFY_MODE"]] =
            uptable["VALUE_MODE_BEDROOM"]
    elseif (uptable["humidityMode"] == uptable["BYTE_MODE_KITCHEN"]) then
        streams[uptable["KEY_HUMIDIFY_MODE"]] =
            uptable["VALUE_MODE_KITCHEN"]
    elseif (uptable["humidityMode"] == uptable["BYTE_MODE_MANUAL"]) then
        streams[uptable["KEY_HUMIDIFY_MODE"]] =
            uptable["VALUE_MODE_MANUAL"]
    elseif (uptable["humidityMode"] == uptable["BYTE_MODE_AUTO"]) then
        streams[uptable["KEY_HUMIDIFY_MODE"]] =
            uptable["VALUE_MODE_AUTO"]
    elseif (uptable["humidityMode"] == uptable["BYTE_MODE_SLEEP"]) then
        streams[uptable["KEY_HUMIDIFY_MODE"]] =
            uptable["VALUE_MODE_SLEEP"]
    end
    if uptable["scheduleCloseSwitcher"] then
        streams[uptable["KEY_SCHEDULE_CLOSE_SWITCHER"]] = uptable
            ["VALUE_SCHEDULE_CLOSE_SWITCHER_ON"]
    else
        streams[uptable["KEY_SCHEDULE_CLOSE_SWITCHER"]] = uptable
            ["VALUE_SCHEDULE_CLOSE_SWITCHER_OFF"]
    end
    streams[uptable["KEY_SCHEDULE_CLOSE_TIME"]] = uptable["scheduleCloseTime"]
    if uptable["scheduleOpenSwitcher"] then
        streams[uptable["KEY_SCHEDULE_OPEN_SWITCHER"]] = uptable
            ["VALUE_SCHEDULE_OPEN_SWITCHER_ON"]
    else
        streams[uptable["KEY_SCHEDULE_OPEN_SWITCHER"]] = uptable
            ["VALUE_SCHEDULE_OPEN_SWITCHER_OFF"]
    end
    streams[uptable["KEY_SCHEDULE_OPEN_TIME"]] = uptable["scheduleOpenTime"]
    streams[uptable["KEY_RUNNING_PERCENT"]] = uptable["running_percent"]
    if (uptable["disinfectOnOffValue"] == uptable["BYTE_DISINFECT_ON"]) then
        streams[uptable["KEY_DISINFECT_ON_OFF"]] =
            uptable["VALUE_DISINFECT_ON"]
    elseif (uptable["disinfectOnOffValue"] == uptable["BYTE_DISINFECT_OFF"]) then
        streams[uptable["KEY_DISINFECT_ON_OFF"]] =
            uptable["VALUE_DISINFECT_OFF"]
    elseif (uptable["disinfectOnOffValue"] == uptable["BYTE_DISINFECT_INVALID"]) then
        streams[uptable["KEY_DISINFECT_ON_OFF"]] =
            uptable["VALUE_DISINFECT_INVALID"]
    end
    if (uptable["windGearValue"] == uptable["BYTE_FANSPEED_HIGH"]) then
        streams[uptable["KEY_WIND_GEAR"]] = uptable
            ["VALUE_FANSPEED_HIGH"]
    elseif (uptable["windGearValue"] == uptable["BYTE_FANSPEED_MID"] or uptable["windGearValue"] == uptable["BYTE_FANSPEED_MID_2"]) then
        streams[uptable["KEY_WIND_GEAR"]] =
            uptable["VALUE_FANSPEED_MID"]
    elseif (uptable["windGearValue"] == uptable["BYTE_FANSPEED_LOW"] or uptable["windGearValue"] == uptable["BYTE_FANSPEED_LOW_2"]) then
        streams[uptable["KEY_WIND_GEAR"]] =
            uptable["VALUE_FANSPEED_LOW"]
    elseif (uptable["windGearValue"] == uptable["BYTE_FANSPEED_AUTO"] or uptable["windGearValue"] == uptable["BYTE_FANSPEED_AUTO_2"]) then
        streams[uptable["KEY_WIND_GEAR"]] =
            uptable["VALUE_FANSPEED_AUTO"]
    elseif (uptable["windGearValue"] == uptable["BYTE_FANSPEED_LOWEST"]) then
        streams[uptable["KEY_WIND_GEAR"]] =
            uptable["VALUE_FANSPEED_LOWEST"]
    elseif (uptable["windGearValue"] == uptable["BYTE_FANSPEED_OFF"]) then
        streams[uptable["KEY_WIND_GEAR"]] =
            uptable["VALUE_FANSPEED_OFF"]
    end
    local retTable = {}
    retTable["status"] = streams
    local ret = encode(retTable)
    return ret
end
