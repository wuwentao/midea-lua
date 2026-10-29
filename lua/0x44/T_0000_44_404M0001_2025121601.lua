local bit = require("bit")
local uptable = {}
uptable["VALUE_VERSION"] = 4
local JSON = require("cjson")
local bit32 = require("bit")
function decToHex(dec)
    local hex = ""
    while dec > 0 do
        local remainder = dec % 16
        if remainder < 10 then
            hex = string.char(48 + remainder) .. hex
        else
            hex = string.char(55 + remainder) .. hex
        end
        dec = math.floor(dec / 16)
    end
    return hex
end
local function bit_band(a, b)
    local cloud_bl = true
    local ret
    if cloud_bl then
        ret = bit.band(a, b)
    else
        ret = bit32.band(a, b)
    end
    return ret
end
local function bit_bor(a, b)
    local cloud_bl = true
    local ret
    if cloud_bl then
        ret = bit.bor(a, b)
    else
        ret = bit32.bor(a, b)
    end
    return ret
end
local function printtb(tb)
    print("start")
    if tb == nil then
        print("nil")
    else
        local len = #tb
        for i = 0, len do
            print(tb[i])
        end
    end
    print("end")
end
local function decodeJsonToTable(cmd)
    local tb
    if JSON == nil then
        JSON = require("cjson")
    end
    tb = JSON.decode(cmd)
    return tb
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
local function table2hex(cmd)
    local ret = ""
    if cmd == nil then
        return ret
    end
    for i = 1, #cmd do
        ret = ret .. string.format("%02x", cmd[i])
    end
    return ret
end
local function getNumber(x)
    local t = type(x)
    local rs = x
    if t == "number" then
    elseif t == "string" then
        rs = tonumber(x) or x
    end
    return rs
end
local function getNumberNew(x)
    if x ~= nil then
        if x == "on" then
            return tonumber(1)
        elseif x == "off" then
            return tonumber(0)
        else
            return tonumber(x)
        end
    else
        return getNumber(nil)
    end
end
local function getBodyBytes(len)
    local bodyBytes = {}
    for i = 0, len do
        bodyBytes[i] = 0xFF
    end
    return bodyBytes
end
local function makeSum(tmpbuf, start_pos, end_pos)
    local resVal = 0
    for si = start_pos, end_pos do
        resVal = resVal + tmpbuf[si]
    end
    resVal = bit.bnot(resVal) + 1
    resVal = bit_band(resVal, 0x00ff)
    return resVal
end
local function padStart(str, length, char)
    char = char or " "
    local padLen = length - #str
    if padLen <= 0 then
        return str
    else
        return string.rep(char, padLen) .. str
    end
end
local function cmdTValue(status, key, bodyBytesValue)
    if bodyBytesValue ~= 0xFF then
        status[key] = bodyBytesValue
    end
end
local function bitTValue(status, key1, key2, key3, key4, bodyBytesValue)
    local value = bit_band(bodyBytesValue, 0x03)
    if value ~= 0x03 and key1 ~= nil then
        status[key1] = value
    end
    value = bit_band(bodyBytesValue, 0x0C)
    if key2 ~= nil then
        if value == 0x00 then
            status[key2] = 0
        elseif value == 0x04 then
            status[key2] = 1
        elseif value == 0x08 then
            status[key2] = 2
        end
    end
    value = bit_band(bodyBytesValue, 0x30)
    if key3 ~= nil then
        if value == 0x00 then
            status[key3] = 0
        elseif value == 0x10 then
            status[key3] = 1
        elseif value == 0x20 then
            status[key3] = 2
        end
    end
    value = bit_band(bodyBytesValue, 0xC0)
    if key4 ~= nil then
        if value == 0x00 then
            status[key4] = 0
        elseif value == 0x40 then
            status[key4] = 1
        elseif value == 0x80 then
            status[key4] = 2
        end
    end
end
local function toScnJson(status, bodyBytes)
    cmdTValue(status, "hasToken", tonumber(bodyBytes[13]))
    cmdTValue(status, "status", tonumber(bodyBytes[14]))
    cmdTValue(status, "errorCode", tonumber(bodyBytes[15]))
    bitTValue(status, "leftButton", "midButton", "rightButton", nil, tonumber(bodyBytes[16]))
    bitTValue(status, "shwBtnNamSw", "clsTBrightSw", "sleepMdSw", "slpMdMuteSw", tonumber(bodyBytes[17]))
    cmdTValue(status, "auOffScrnType", tonumber(bodyBytes[18]))
    cmdTValue(status, "theme", tonumber(bodyBytes[19]))
    cmdTValue(status, "nightVolume", tonumber(bodyBytes[20]))
    cmdTValue(status, "voiceVolume", tonumber(bodyBytes[21]))
    cmdTValue(status, "slpMdStartH", tonumber(bodyBytes[22]))
    cmdTValue(status, "slpMdStartM", tonumber(bodyBytes[23]))
    cmdTValue(status, "slpMdH", tonumber(bodyBytes[24]))
    cmdTValue(status, "slpMdM", tonumber(bodyBytes[25]))
    bitTValue(
        status,
        "leftButtonKeepState",
        "middleButtonKeepState",
        "rightButtonKeepState",
        nil,
        tonumber(bodyBytes[26])
    )
    bitTValue(status, "voiceCtrlSw", "sleepMode", "screenState", nil, tonumber(bodyBytes[27]))
    cmdTValue(status, "brightness", tonumber(bodyBytes[28]))
    cmdTValue(status, "leftButtonWorkMode", tonumber(bodyBytes[29]))
    cmdTValue(status, "middleButtonWorkMode", tonumber(bodyBytes[30]))
    cmdTValue(status, "rightButtonWorkMode", tonumber(bodyBytes[31]))
    return status
end
local function toE1Json(status, bodyBytes)
    cmdTValue(status, "deviceType", tonumber(bodyBytes[15]))
    cmdTValue(status, "deviceId", tonumber(bodyBytes[16]))
    bitTValue(status, nil, nil, nil, "power", tonumber(bodyBytes[20]))
    cmdTValue(status, "operate", tonumber(bodyBytes[21]))
end
local function toE2Json(status, bodyBytes)
    cmdTValue(status, "deviceType", tonumber(bodyBytes[15]))
    cmdTValue(status, "deviceId", tonumber(bodyBytes[16]))
    bitTValue(status, "power", "tempCtrl", nil, nil, tonumber(bodyBytes[20]))
end
local function toE3Json(status, bodyBytes)
    cmdTValue(status, "deviceType", tonumber(bodyBytes[15]))
    cmdTValue(status, "deviceId", tonumber(bodyBytes[16]))
    bitTValue(status, "power", "tempCtrl", "coldWater", nil, tonumber(bodyBytes[20]))
end
local function toB6Json(status, bodyBytes)
    cmdTValue(status, "deviceType", tonumber(bodyBytes[15]))
    cmdTValue(status, "deviceId", tonumber(bodyBytes[16]))
    bitTValue(status, "power", "lightSw", nil, nil, tonumber(bodyBytes[20]))
    cmdTValue(status, "gear", tonumber(bodyBytes[21]))
    cmdTValue(status, "lightness", tonumber(bodyBytes[22]))
end
local function toD9Json(status, bodyBytes)
    cmdTValue(status, "deviceType", tonumber(bodyBytes[15]))
    cmdTValue(status, "deviceId", tonumber(bodyBytes[16]))
    bitTValue(status, nil, "inletValue", "soften", "regeneration", tonumber(bodyBytes[18]))
end
local function toD3Json(status, bodyBytes)
    cmdTValue(status, "deviceType", tonumber(bodyBytes[15]))
    cmdTValue(status, "deviceId", tonumber(bodyBytes[16]))
    bitTValue(status, "filterWash", "heat", nil, nil, tonumber(bodyBytes[18]))
end
local function toDAJson(status, bodyBytes)
    cmdTValue(status, "deviceType", tonumber(bodyBytes[15]))
    cmdTValue(status, "deviceId", tonumber(bodyBytes[16]))
    bitTValue(status, nil, "clean", nil, nil, tonumber(bodyBytes[18]))
end
local function unicodeTCmd(bodyBytes, key, unicodeStr, len)
    if len > 0 then
        bodyBytes[key] = len
        local temp = len * 2
        for i = 1, temp do
            bodyBytes[key + i] = "0x" .. string.sub(unicodeStr, i * 2 - 1, i * 2)
        end
        key = key + temp + 1
    else
        key = key + 2
    end
    return key
end
local function bitTCmd(bodyBytes, key, value1, value2, value3, value4)
    bodyBytes[key] = 0
    if value1 == nil then
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x03)
    elseif value1 == 1 then
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x01)
    else
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x00)
    end
    if value2 == nil then
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x0C)
    elseif value2 == 1 then
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x04)
    else
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x00)
    end
    if value3 == nil then
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x30)
    elseif value3 == 1 then
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x10)
    else
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x00)
    end
    if value4 == nil then
        bodyBytes[key] = bit_bor(bodyBytes[key], 0xC0)
    elseif value4 == 1 then
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x40)
    else
        bodyBytes[key] = bit_bor(bodyBytes[key], 0x00)
    end
end
local function valueTCmd(bodyBytes, key, value)
    if value ~= nil then
        bodyBytes[key] = getNumber(value)
    end
end
local function concatBytes(bodyBytes, bytes)
    local bLen = #bodyBytes
    local len = #bytes
    for i = 0, len do
        bodyBytes[bLen + i + 1] = bytes[i]
    end
end
local function getSceneCmd(control)
    local len = 2
    local nameLen = 1
    if control["sceneName"] ~= nil then
        nameLen = #control["sceneName"] / 4
    end
    len = len + 1 + nameLen
    local bodyBytes = getBodyBytes(len)
    valueTCmd(bodyBytes, 0, getNumber(control["sceneId"]))
    valueTCmd(bodyBytes, 1, getNumber(control["sceneIcon"]))
    if nameLen > 1 then
        unicodeTCmd(bodyBytes, 2, control["sceneName"], nameLen)
    end
    return bodyBytes
end
local function getDeviceCmd(control)
    local len = 2
    local nameLen = 1
    if control["deviceName"] ~= nil then
        nameLen = #control["deviceName"] / 4
    end
    len = len + 1 + nameLen
    local bodyBytes = getBodyBytes(len)
    valueTCmd(bodyBytes, 0, getNumber(control["deviceId"]))
    valueTCmd(bodyBytes, 1, getNumber(control["deviceType"]))
    if nameLen > 1 then
        unicodeTCmd(bodyBytes, 2, control["deviceName"], nameLen)
    end
    return bodyBytes
end
local function getE3ErrorCode(errorCode, index)
    local E3_ERROR_CODE_MAP = {
        E0 = "01000000",
        E1 = "02000000",
        E2 = "04000000",
        E3 = "08000000",
        E4 = "10000000",
        E5 = "20000000",
        E6 = "40000000",
        E8 = "80000000",
        E9 = "00010000",
        EA = "00020000",
        EE = "00040000",
        EF = "00080000",
        EH = "00100000",
        A6 = "00200000",
        CE = "00400000",
        CF = "00800000",
        C0 = "00000100",
        C1 = "00000200",
        C2 = "00000400",
        C3 = "00000800",
        C4 = "00001000",
        C5 = "00002000",
        C6 = "00004000",
        C7 = "00008000",
        C8 = "00000001",
        F2 = "00000002",
    }
    local errorValue = E3_ERROR_CODE_MAP[errorCode]
    if errorValue ~= nil then
        local value = "0x" .. string.sub(errorValue, 2 * index - 1, 2 * index)
        return getNumber(value)
    else
        return 0
    end
end
local function toBtnCmd(control)
    local bodyBytes = getBodyBytes(5)
    bodyBytes[0] = 0x08
    bodyBytes[1] = 0x01
    bodyBytes[2] = 0xFF
    valueTCmd(bodyBytes, 3, getNumber(control["buttonNum"]))
    valueTCmd(bodyBytes, 4, getNumber(control["buttonType"]))
    bitTCmd(bodyBytes, 5, getNumber(control["btnSmartSw"]), getNumber(control["btnVoiceSw"]), nil, nil)
    return bodyBytes
end
local function toInfoCmd(control)
    local bodyBytes = getBodyBytes(22)
    bodyBytes[0] = 0x08
    bodyBytes[1] = 0x05
    if control["msgDeviceType"] ~= nil then
        valueTCmd(bodyBytes, 2, getNumber(control["msgDeviceType"]))
    end
    local zero_single = getNumberNew(control["zero_single"])
    local cold_water_master = getNumberNew(control["cold_water_master"])
    local zero_dot = getNumberNew(control["zero_dot"])
    local zero_timing = getNumberNew(control["zero_timing"])
    bitTCmd(bodyBytes, 3, zero_single, cold_water_master, zero_dot, zero_timing)
    local power = getNumberNew(control["power"])
    local feedback = getNumberNew(control["feedback"])
    local cold_water_high_tem = getNumberNew(control["cold_water_high_tem"])
    bitTCmd(bodyBytes, 4, power, feedback, cold_water_high_tem, nil)
    if control["water_volume"] ~= nil then
        valueTCmd(bodyBytes, 5, getNumber(control["water_volume"]))
    end
    if control["temperature"] ~= nil then
        valueTCmd(bodyBytes, 6, getNumber(control["temperature"]))
    end
    if control["cold_hold_duration"] ~= nil then
        valueTCmd(bodyBytes, 7, getNumber(control["cold_hold_duration"]))
    end
    if control["in_water_tem"] ~= nil then
        valueTCmd(bodyBytes, 8, getNumber(control["in_water_tem"]))
    end
    if control["bubble"] ~= nil then
        if control["bubble"] == "on" then
            valueTCmd(bodyBytes, 9, getNumber(1))
        elseif control["bubble"] == "off" then
            valueTCmd(bodyBytes, 9, getNumber(0))
        else
            valueTCmd(bodyBytes, 9, getNumber(control["bubble"]))
        end
    end
    if control["bathtub_curve"] ~= nil then
        valueTCmd(bodyBytes, 10, getNumber(control["bathtub_curve"]))
    end
    if control["error_code"] ~= nil then
        if control["error_code"] == "none" then
            valueTCmd(bodyBytes, 11, getNumber(0))
        else
            valueTCmd(bodyBytes, 11, getNumber(1))
            valueTCmd(bodyBytes, 12, getE3ErrorCode(control["error_code"], 1))
            valueTCmd(bodyBytes, 13, getE3ErrorCode(control["error_code"], 2))
            valueTCmd(bodyBytes, 14, getE3ErrorCode(control["error_code"], 3))
            valueTCmd(bodyBytes, 15, getE3ErrorCode(control["error_code"], 4))
        end
    else
        valueTCmd(bodyBytes, 11, nill)
    end
    if control["deviceId"] ~= nil then
        local deviceId = padStart(decToHex(getNumber(control["deviceId"])), 14, "0")
        for i = 1, 7 do
            bodyBytes[i + 15] = "0x" .. string.sub(deviceId, i * 2 - 1, i * 2)
        end
    end
    return bodyBytes
end
local function toScnCmd(control)
    local bodyBytes = getBodyBytes(20)
    bodyBytes[0] = 0x08
    bodyBytes[1] = 0x02
    bitTCmd(
        bodyBytes,
        5,
        getNumber(control["leftButton"]),
        getNumber(control["midButton"]),
        getNumber(control["rightButton"]),
        nil
    )
    bitTCmd(
        bodyBytes,
        6,
        getNumber(control["shwBtnNamSw"]),
        getNumber(control["clsTBrightSw"]),
        getNumber(control["sleepMdSw"]),
        getNumber(control["slpMdMuteSw"])
    )
    valueTCmd(bodyBytes, 7, getNumber(control["auOffScrnType"]))
    valueTCmd(bodyBytes, 8, getNumber(control["theme"]))
    valueTCmd(bodyBytes, 9, getNumber(control["nightVolume"]))
    valueTCmd(bodyBytes, 10, getNumber(control["voiceVolume"]))
    valueTCmd(bodyBytes, 11, getNumber(control["slpMdStartH"]))
    valueTCmd(bodyBytes, 12, getNumber(control["slpMdStartM"]))
    valueTCmd(bodyBytes, 13, getNumber(control["slpMdH"]))
    valueTCmd(bodyBytes, 14, getNumber(control["slpMdM"]))
    bitTCmd(
        bodyBytes,
        15,
        getNumber(control["leftButtonKeepState"]),
        getNumber(control["middleButtonKeepState"]),
        getNumber(control["rightButtonKeepState"]),
        nil
    )
    bitTCmd(
        bodyBytes,
        16,
        getNumber(control["voiceCtrlSw"]),
        getNumber(control["sleepMode"]),
        getNumber(control["screenState"]),
        nil
    )
    valueTCmd(bodyBytes, 17, getNumber(control["brightness"]))
    valueTCmd(bodyBytes, 18, getNumber(control["leftButtonWorkMode"]))
    valueTCmd(bodyBytes, 19, getNumber(control["middleButtonWorkMode"]))
    valueTCmd(bodyBytes, 20, getNumber(control["rightButtonWorkMode"]))
    return bodyBytes
end
local function toSceneCmd(control)
    local bodyBytes = getBodyBytes(4)
    bodyBytes[0] = 0x08
    bodyBytes[1] = 0x03
    bodyBytes[2] = 0xFF
    local list = control["list"]
    if list == nil or #list == 0 then
        return bodyBytes
    end
    local listLen = #list
    bodyBytes[3] = listLen
    for i, v in ipairs(list) do
        local sceneBytes = getSceneCmd(v)
        concatBytes(bodyBytes, sceneBytes)
    end
    return bodyBytes
end
local function toDevCmd(control)
    local bodyBytes = getBodyBytes(4)
    bodyBytes[0] = 0x08
    bodyBytes[1] = 0x04
    bodyBytes[2] = 0xFF
    local list = control["list"]
    local listLen = #list
    bodyBytes[3] = listLen
    for i, v in ipairs(list) do
        local deviceBytes = getDeviceCmd(v)
        concatBytes(bodyBytes, deviceBytes)
    end
    return bodyBytes
end
local function toDEE1Cmd(control)
    local bodyBytes = getBodyBytes(10)
    local len = 7
    bodyBytes[0] = 0xE1
    valueTCmd(bodyBytes, 1, getNumber(control["deviceId"]))
    valueTCmd(bodyBytes, 3, getNumber(control["deviceStatus"]))
    valueTCmd(bodyBytes, 4, getNumber(control["deviceError"]))
    bitTCmd(
        bodyBytes,
        5,
        getNumber(control["doorStatus"]),
        getNumber(control["salt"]),
        getNumber(control["bright"]),
        getNumber(control["power"])
    )
    valueTCmd(bodyBytes, 7, getNumber(control["washStage"]))
    valueTCmd(bodyBytes, 8, getNumber(control["leftTimeH"]))
    valueTCmd(bodyBytes, 9, getNumber(control["leftTimeM"]))
    valueTCmd(bodyBytes, 2, len)
    return bodyBytes
end
local function toDEE2Cmd(control)
    local bodyBytes = getBodyBytes(11)
    local len = 8
    bodyBytes[0] = 0xE2
    valueTCmd(bodyBytes, 1, getNumber(control["deviceId"]))
    valueTCmd(bodyBytes, 3, getNumber(control["deviceStatus"]))
    valueTCmd(bodyBytes, 4, getNumber(control["deviceError"]))
    bitTCmd(
        bodyBytes,
        5,
        getNumber(control["power"]),
        getNumber(control["tempCtrl"]),
        getNumber(control["isWashTemp"]),
        nil
    )
    valueTCmd(bodyBytes, 6, getNumber(control["currentTemp"]))
    valueTCmd(bodyBytes, 7, getNumber(control["tempSet"]))
    valueTCmd(bodyBytes, 8, getNumber(control["fuzzyWater"]))
    valueTCmd(bodyBytes, 9, getNumber(control["leftTimeH"]))
    valueTCmd(bodyBytes, 10, getNumber(control["leftTimeM"]))
    valueTCmd(bodyBytes, 2, len)
    return bodyBytes
end
local function toDEE3Cmd(control)
    local bodyBytes = getBodyBytes(8)
    local len = 5
    bodyBytes[0] = 0xE3
    valueTCmd(bodyBytes, 1, getNumber(control["deviceId"]))
    valueTCmd(bodyBytes, 3, getNumber(control["deviceStatus"]))
    valueTCmd(bodyBytes, 4, getNumber(control["deviceError"]))
    bitTCmd(
        bodyBytes,
        5,
        getNumber(control["power"]),
        getNumber(control["tempCtrl"]),
        getNumber(control["coldWater"]),
        nil
    )
    valueTCmd(bodyBytes, 6, getNumber(control["tempSet"]))
    valueTCmd(bodyBytes, 7, getNumber(control["leftTimePer"]))
    valueTCmd(bodyBytes, 2, len)
    return bodyBytes
end
local function toDEB6Cmd(control)
    local bodyBytes = getBodyBytes(8)
    local len = 5
    bodyBytes[0] = 0xB6
    valueTCmd(bodyBytes, 1, getNumber(control["deviceId"]))
    valueTCmd(bodyBytes, 3, getNumber(control["deviceStatus"]))
    valueTCmd(bodyBytes, 4, getNumber(control["deviceError"]))
    bitTCmd(bodyBytes, 5, getNumber(control["power"]), getNumber(control["lightSw"]), nil, nil)
    valueTCmd(bodyBytes, 6, getNumber(control["gear"]))
    valueTCmd(bodyBytes, 7, getNumber(control["lightness"]))
    valueTCmd(bodyBytes, 2, len)
    return bodyBytes
end
local function toDED9Cmd(control)
    local bodyBytes = getBodyBytes(14)
    local len = 11
    bodyBytes[0] = 0xD9
    valueTCmd(bodyBytes, 1, getNumber(control["deviceId"]))
    bitTCmd(
        bodyBytes,
        3,
        getNumber(control["isNew"]),
        getNumber(control["inletValue"]),
        getNumber(control["soften"]),
        getNumber(control["regeneration"])
    )
    valueTCmd(bodyBytes, 4, getNumber(control["deviceStatus"]))
    valueTCmd(bodyBytes, 5, getNumber(control["deviceError"]))
    local saValue = padStart(string.format("%x", getNumber(control["softAvailable"])), 8, "0")
    for i = 1, 4 do
        bodyBytes[5 + i] = "0x" .. string.sub(saValue, i * 2 - 1, i * 2)
    end
    valueTCmd(bodyBytes, 10, getNumber(control["leftTimeH"]))
    valueTCmd(bodyBytes, 11, getNumber(control["leftTimeM"]))
    valueTCmd(bodyBytes, 12, getNumber(control["saltAvailable"]))
    valueTCmd(bodyBytes, 13, getNumber(control["velocity"]))
    valueTCmd(bodyBytes, 2, len)
    return bodyBytes
end
local function toDED3Cmd(control)
    local len = 10
    if control["filterName1"] ~= nil and control["filter1"] ~= nil then
        local len1 = #control["filterName1"] / 2
        len = len + 2 + len1
    else
        len = len + 3
    end
    if control["filterName2"] ~= nil and control["filter2"] ~= nil then
        local len2 = #control["filterName2"] / 2
        len = len + 2 + len2
    else
        len = len + 3
    end
    if control["filterName3"] ~= nil and control["filter3"] ~= nil then
        local len3 = #control["filterName3"] / 2
        len = len + 2 + len3
    else
        len = len + 3
    end
    if control["filterName4"] ~= nil and control["filter4"] ~= nil then
        local len4 = #control["filterName4"] / 2
        len = len + 2 + len4
    else
        len = len + 3
    end
    if control["filterName5"] ~= nil and control["filter5"] ~= nil then
        local len5 = #control["filterName5"] / 2
        len = len + 2 + len5
    else
        len = len + 3
    end
    local bodyBytes = getBodyBytes(len)
    local key = 10
    bodyBytes[0] = 0xD3
    valueTCmd(bodyBytes, 1, getNumber(control["deviceId"]))
    valueTCmd(bodyBytes, 2, len - 3)
    valueTCmd(bodyBytes, 3, getNumber(control["deviceStatus"]))
    valueTCmd(bodyBytes, 4, getNumber(control["deviceError"]))
    bitTCmd(bodyBytes, 5, getNumber(control["filterWash"]), getNumber(control["heat"]), nil, nil)
    local inValue = padStart(string.format("%x", getNumber(control["inTds"])), 4, "0")
    for i = 1, 2 do
        bodyBytes[5 + i] = "0x" .. string.sub(inValue, i * 2 - 1, i * 2)
    end
    local outValue = padStart(string.format("%x", getNumber(control["outTds"])), 4, "0")
    for i = 1, 2 do
        bodyBytes[7 + i] = "0x" .. string.sub(outValue, i * 2 - 1, i * 2)
    end
    if control["filterName1"] ~= nil and control["filter1"] ~= nil then
        valueTCmd(bodyBytes, key, getNumber(control["filter1"]))
        key = key + 1
        local len1 = #control["filterName1"] / 4
        key = unicodeTCmd(bodyBytes, key, control["filterName1"], len1)
    else
        key = key + 3
    end
    if control["filterName2"] ~= nil and control["filter2"] ~= nil then
        valueTCmd(bodyBytes, key, getNumber(control["filter2"]))
        key = key + 1
        local len = #control["filterName2"] / 4
        key = unicodeTCmd(bodyBytes, key, control["filterName2"], len)
    else
        key = key + 3
    end
    if control["filterName3"] ~= nil and control["filter3"] ~= nil then
        valueTCmd(bodyBytes, key, getNumber(control["filter3"]))
        key = key + 1
        local len = #control["filterName3"] / 4
        key = unicodeTCmd(bodyBytes, key, control["filterName3"], len)
    else
        key = key + 3
    end
    if control["filterName4"] ~= nil and control["filter4"] ~= nil then
        valueTCmd(bodyBytes, key, getNumber(control["filter4"]))
        key = key + 1
        local len = #control["filterName4"] / 4
        key = unicodeTCmd(bodyBytes, key, control["filterName4"], len)
    else
        key = key + 3
    end
    if control["filterName5"] ~= nil and control["filter5"] ~= nil then
        valueTCmd(bodyBytes, key, getNumber(control["filter5"]))
        key = key + 1
        local len = #control["filterName5"] / 4
        key = unicodeTCmd(bodyBytes, key, control["filterName5"], len)
    end
    return bodyBytes
end
local function toDEDACmd(control)
    local bodyBytes = getBodyBytes(9)
    local len = 6
    bodyBytes[0] = 0xDA
    valueTCmd(bodyBytes, 1, getNumber(control["deviceId"]))
    bitTCmd(bodyBytes, 3, getNumber(control["isNew"]), getNumber(control["clean"]), nil, nil)
    valueTCmd(bodyBytes, 4, getNumber(control["deviceStatus"]))
    valueTCmd(bodyBytes, 5, getNumber(control["deviceError"]))
    valueTCmd(bodyBytes, 6, getNumber(control["leftTimeH"]))
    valueTCmd(bodyBytes, 7, getNumber(control["leftTimeM"]))
    valueTCmd(bodyBytes, 8, getNumber(control["velocity"]))
    valueTCmd(bodyBytes, 2, len)
    return bodyBytes
end
local function toDDCmd(control)
    local bodyBytes = getBodyBytes(9)
    local deviceId = padStart(decToHex(getNumber(control["deviceId"])), 12, "0")
    bodyBytes[0] = 0xDD
    for i = 1, 6 do
        bodyBytes[i] = "0x" .. string.sub(deviceId, i * 2 - 1, i * 2)
    end
    valueTCmd(bodyBytes, 7, getNumber(control["deviceType"]))
    valueTCmd(bodyBytes, 8, getNumber(control["eventType"]))
    valueTCmd(bodyBytes, 9, getNumber(control["consumeKey"]))
    return bodyBytes
end
local function getDeviceDataCmd(control)
    local deviceType = getNumber(control["deviceType"])
    if deviceType ~= nil then
        if deviceType == 0xE1 then
            return toDEE1Cmd(control)
        elseif deviceType == 0xE2 then
            return toDEE2Cmd(control)
        elseif deviceType == 0xE3 then
            return toDEE3Cmd(control)
        elseif deviceType == 0xB6 then
            return toDEB6Cmd(control)
        elseif deviceType == 0xD9 then
            return toDED9Cmd(control)
        elseif deviceType == 0xD3 then
            return toDED3Cmd(control)
        elseif deviceType == 0xDA then
            return toDEDACmd(control)
        else
            return nil
        end
    else
        return nil
    end
end
local function toDACmd(control)
    local bodyBytes = getBodyBytes(4)
    bodyBytes[0] = 0xDA
    if control["resId"] ~= nil then
        bodyBytes[1] = getNumber(control["resId"])
    end
    if control["resStatus"] ~= nil then
        bodyBytes[2] = getNumber(control["resStatus"])
        if control["resStatus"] == 0 and control["rejType"] ~= nil then
            bodyBytes[3] = getNumber(control["rejType"])
        end
    end
    if control["funcType"] ~= nil then
        local funcType = control["funcType"]
        if funcType == 0x03 then
            local sceneBytes = toSceneCmd(control)
            for i = 1, #sceneBytes do
                bodyBytes[3 + i] = sceneBytes[i]
            end
        elseif funcType == 0x04 then
            local deviceBytes = toDevCmd(control)
            for i = 1, #deviceBytes do
                bodyBytes[3 + i] = deviceBytes[i]
            end
        end
    elseif control["deviceList"] ~= nil and #control["deviceList"] > 0 then
        local deviceList = control["deviceList"]
        local deBytes = getBodyBytes(1)
        deBytes[0] = #deviceList
        for i, v in ipairs(deviceList) do
            local deviceDataBytes = getDeviceDataCmd(v)
            concatBytes(deBytes, deviceDataBytes)
        end
        for i = 0, #deBytes do
            bodyBytes[3 + 1 + i] = deBytes[i]
        end
    elseif control["btnList"] ~= nil and #control["btnList"] > 0 then
        local btnList = control["btnList"]
        local btnBytes = getBodyBytes(1)
        btnBytes[0] = #btnList
        for i, v in ipairs(btnList) do
            local btnDataBytes = toBtnCmd(v)
            local btnCopyBytes = {}
            for j = 2, #btnDataBytes do
                btnCopyBytes[j - 2] = btnDataBytes[j]
            end
            concatBytes(btnBytes, btnCopyBytes)
        end
        concatBytes(bodyBytes, btnBytes)
    else
        bodyBytes[4] = 0xff
    end
    return bodyBytes
end
local function assembleUart(bodyBytes, type)
    if bodyBytes == nil then
        return nil
    end
    local bodyLength = #bodyBytes + 1
    local msgLength = (bodyLength + 0x0A + 1)
    local msgBytes = {}
    for i = 0, msgLength - 1 do
        msgBytes[i] = 0
    end
    msgBytes[0] = 0xAA
    msgBytes[1] = msgLength - 1
    msgBytes[2] = 0x44
    msgBytes[9] = type
    for i = 0, bodyLength - 1 do
        msgBytes[i + 0x0A] = bodyBytes[i]
    end
    msgBytes[msgLength - 1] = makeSum(msgBytes, 1, msgLength - 2)
    local msgBytesTemp = {}
    local length = #msgBytes + 1
    for i = 1, length do
        msgBytesTemp[i] = msgBytes[i - 1]
    end
    return msgBytesTemp
end
local function controlToBodyBytes(control)
    local msgType = getNumber(control["msgType"])
    if msgType == nil then
        return nil
    end
    if msgType == 8 then
        local funcType = getNumber(control["funcType"])
        if funcType == nil then
            return nil
        end
        if funcType == 1 then
            return toBtnCmd(control)
        elseif funcType == 2 then
            return toScnCmd(control)
        elseif funcType == 3 then
            return toSceneCmd(control)
        elseif funcType == 4 then
            return toDevCmd(control)
        elseif funcType == 5 then
            return toInfoCmd(control)
        else
            return nil
        end
    elseif msgType == 0xDA then
        return toDACmd(control)
    elseif msgType == 0xDD then
        return toDDCmd(control)
    elseif msgType == 0xDE then
        local deviceList = control["deviceList"]
        local deBytes = {}
        deBytes[0] = 0xDE
        if deviceList ~= nil and #deviceList > 0 then
            deBytes[1] = #deviceList
            for i, v in ipairs(deviceList) do
                local deviceDataBytes = getDeviceDataCmd(v)
                concatBytes(deBytes, deviceDataBytes)
            end
        else
            local deviceDataBytes = getDeviceDataCmd(control)
            if deviceDataBytes ~= nil then
                deBytes[1] = 0x01
                concatBytes(deBytes, deviceDataBytes)
            else
                deBytes[1] = 0xFF
            end
        end
        return deBytes
    else
        return nil
    end
end
local function queryToBodyBytes(query)
    local queryType = getNumber(query["queryType"])
    if queryType == nil then
        queryType = 0x02
    end
    local msgBytes = {}
    msgBytes[0] = 0x08
    msgBytes[1] = queryType
    return msgBytes
end
local function bodyBytesToJson(bodyBytes)
    local status = {}
    if bodyBytes[10] == 0x04 then
        if bodyBytes[11] == 0x08 then
            status["msgType"] = tonumber(bodyBytes[11])
            status["funcType"] = tonumber(bodyBytes[12])
            if bodyBytes[12] == 0x02 then
                toScnJson(status, bodyBytes)
            elseif bodyBytes[12] == 0xDA and bodyBytes[12] ~= 0xFF then
                status["msgType"] = tonumber(bodyBytes[11])
                status["funcType"] = tonumber(bodyBytes[12])
                cmdTValue(status, "reqId", tonumber(bodyBytes[13]))
                cmdTValue(status, "reqType", tonumber(bodyBytes[14]))
                if bodyBytes[14] == 0x01 then
                    cmdTValue(status, "leftRadioBtnState", tonumber(bodyBytes[15]))
                    cmdTValue(status, "leftVoiceBtnState", tonumber(bodyBytes[16]))
                    cmdTValue(status, "middleRadioBtnState", tonumber(bodyBytes[17]))
                    cmdTValue(status, "middleVoiceBtnState", tonumber(bodyBytes[18]))
                    cmdTValue(status, "rightRadioBtnState", tonumber(bodyBytes[19]))
                    cmdTValue(status, "rightVoiceBtnState", tonumber(bodyBytes[20]))
                elseif bodyBytes[14] == 0x02 then
                    cmdTValue(status, "order", tonumber(bodyBytes[15]))
                elseif bodyBytes[14] == 0x03 then
                    cmdTValue(status, "sceneId", tonumber(bodyBytes[15]))
                elseif bodyBytes[14] == 0x04 then
                    local deviceType = tonumber(bodyBytes[15])
                    if deviceType == 0xE1 then
                        toE1Json(status, bodyBytes)
                    elseif deviceType == 0xE2 then
                        toE2Json(status, bodyBytes)
                    elseif deviceType == 0xE3 then
                        toE3Json(status, bodyBytes)
                    elseif deviceType == 0xB6 then
                        toB6Json(status, bodyBytes)
                    elseif deviceType == 0xD9 then
                        toD9Json(status, bodyBytes)
                    elseif deviceType == 0xD3 then
                        toD3Json(status, bodyBytes)
                    elseif deviceType == 0xDA then
                        toDAJson(status, bodyBytes)
                    end
                elseif bodyBytes[14] == 0x05 or bodyBytes[14] == 0x06 or bodyBytes[14] == 0x07 then
                elseif bodyBytes[14] == 0x08 then
                    cmdTValue(status, "deviceId", tonumber(bodyBytes[15]))
                end
            end
        end
    elseif bodyBytes[10] == 0x03 then
        if bodyBytes[11] == 0x08 then
            status["msgType"] = tonumber(bodyBytes[11])
            status["funcType"] = tonumber(bodyBytes[12])
            if bodyBytes[12] == 0x02 then
                toScnJson(status, bodyBytes)
            end
        end
    elseif bodyBytes[10] == 0x02 then
        if bodyBytes[11] == 0x08 then
            status["msgType"] = tonumber(bodyBytes[11])
            status["funcType"] = tonumber(bodyBytes[12])
            if bodyBytes[12] == 0x01 or bodyBytes[12] == 0x03 or bodyBytes[12] == 0x04 then
                cmdTValue(status, "reqStatus", tonumber(bodyBytes[13]))
            elseif bodyBytes[12] == 0x02 then
                toScnJson(status, bodyBytes)
            end
        end
    end
    return status
end
function jsonToData(jsonCmdStr)
    print(jsonCmdStr)
    if #jsonCmdStr == 0 then
        return nil
    end
    local json = decodeJsonToTable(jsonCmdStr)
    local query = json["query"]
    local control = json["control"]
    local bodyBytes = {}
    if control then
        bodyBytes = controlToBodyBytes(control)
    elseif query then
        bodyBytes = queryToBodyBytes(query)
    end
    local msgBytes = {}
    if control then
        msgBytes = assembleUart(bodyBytes, 0x02)
    elseif query then
        msgBytes = assembleUart(bodyBytes, 0x03)
    end
    return table2hex(msgBytes)
end
function dataToJson(jsonStr)
    if not jsonStr then
        return nil
    end
    local json = decodeJsonToTable(jsonStr)
    local binData = json["msg"]["data"]
    local ret = {}
    ret["status"] = {}
    local bodyBytes = string2table(binData)
    ret["status"] = bodyBytesToJson(bodyBytes)
    ret["status"]["cmd"] = binData
    ret["status"]["version"] = uptable["VALUE_VERSION"]
    local ret = JSON.encode(ret)
    return ret
end
