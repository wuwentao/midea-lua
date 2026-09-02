-- 协议解析文件描述，根据实际情况修正
-- author : andywo
-- email  :
-- date   : 2022-01-24
-- T0xFD  : 气味小播灯
-- https://www.cnblogs.com/kingkie/p/17192509.html

-- 必须要引入的库
local JSON = require "cjson"



-- 协议相关常量，请勿修改

-- 控制请求
local BYTE_CONTROL_REQUEST = 0x02
-- 查询请求
local BYTE_QUERY_REQUEST = 0x03
-- 协议头
local BYTE_PROTOCOL_HEAD = 0xAA
-- 协议头长度
local BYTE_PROTOCOL_LENGTH = 0x0A

-- 公共属性值，预定义的值，请勿修改
-- 属性值为未知值时，使用此值。
local VALUE_UNKNOWN = "unknown"
-- 属性值为无效值时，使用此值。
local VALUE_INVALID = "invalid"



-- 协议相关变量,此部分根据实际需要修改，但是local变量的个数不能超过60个，若超过，请使用table封装变量。

-- 数据返回类型，02:控制返回, 03:查询返回, 04:主动上报, 05:主动上报(需要响应), 06:设备异常事件上报。
local dataType = 0
-- 子命令（若有）
local cmdType=0

-- profile 中的 key定义，若太多，请使用table封装变量
local KEY_VERSION = "version"
local KEY_POWER = "power"
local KEY_SCENE_LIGHT = "scene_light"
local KEY_COLOR_TEMPERATURE = "color_temperature"
local KEY_BRIGHTNESS = "brightness"
local KEY_DELAY_LIGHT_OFF = "delay_light_off"
local KEY_LIFE_COLOR_TEMPERATURE = "life_color_temperature"
local KEY_LIFE_BRIGHTNESS = "life_brightness"
local KEY_READ_COLOR_TEMPERATURE = "read_color_temperature"
local KEY_READ_BRIGHTNESS = "read_brightness"
local KEY_MILD_COLOR_TEMPERATURE = "mild_color_temperature"
local KEY_MILD_BRIGHTNESS = "mild_brightness"
local KEY_FILM_COLOR_TEMPERATURE = "film_color_temperature"
local KEY_FILM_BRIGHTNESS = "film_brightness"
local KEY_LIGHT_COLOR_TEMPERATURE = "light_color_temperature"
local KEY_LIGHT_BRIGHTNESS = "light_brightness"
local KEY_RESULT = "result"

-- 存储属性值的变量，若太多，请使用table封装变量
local powerValue = 0
local sceneLight = 0
local colorTemperature = 0
local brightness = 0
local delayLightOff = 0
local lifeColorTemperature = 0
local lifeBrightness = 0
local readColorTemperature = 0
local readBrightness = 0
local mildColorTemperature = 0
local mildBrightness = 0
local filmColorTemperature = 0
local filmBrightness = 0
local lightColorTemperature = 0
local lightBrightness = 0
local colorRed=0
local colorGreen=0
local colorBlue=0
local result=0



--公共的函数，请勿随意修改。

-- 从电控协议(byteData)中提取消息体(body)，返回的消息体数组索引从0开始。
local function extractBodyBytes(byteData)
    local msgLength = #byteData
    local msgBytes = {}
    local bodyBytes = {}
    for i = 1, msgLength do
        msgBytes[i - 1] = byteData[i]
    end
    --去掉消息头和校验码就剩下消息体
    local bodyLength = msgLength - BYTE_PROTOCOL_LENGTH - 1
    --获取消息体 body 部分
    for i = 0, bodyLength - 1 do
        bodyBytes[i] = msgBytes[i + BYTE_PROTOCOL_LENGTH]
    end
    return bodyBytes
end

-- 计算校验和
local function makeSum(tmpbuf, start_pos, end_pos)
    local resVal = 0
    for si = start_pos, end_pos do
        resVal = resVal + tmpbuf[si]
    end
    resVal = bit.bnot(resVal)+1
    resVal = bit.band(resVal, 0x00ff)
    return resVal
end

-- 1.将bodyBytes组装上电控协议头(10字节)和尾部校验码(1字节)。
-- 2.传入的 bodyBytes 为索引从0开始。
-- 3.返回的 table 索引也从0开始。
local function assembleUart(bodyBytes, type)
    local bodyLength = #bodyBytes + 1
    if bodyLength == 0 then
        return nil
    end

    local msgLength = (bodyLength + BYTE_PROTOCOL_LENGTH + 1)
    local msgBytes = {}

    for i = 0, msgLength - 1 do
        msgBytes[i] = 0
    end
    --构造消息部分
    msgBytes[0] = BYTE_PROTOCOL_HEAD
    msgBytes[1] = msgLength - 1
    msgBytes[2] = 0x13
    msgBytes[9] = type

    for i = 0, bodyLength - 1 do
        msgBytes[i + BYTE_PROTOCOL_LENGTH] = bodyBytes[i]
    end

    msgBytes[msgLength - 1] = makeSum(msgBytes, 1, msgLength - 2)
    return msgBytes
end

-- CRC码表
local crc8_854_table =
{
    0, 94, 188, 226, 97, 63, 221, 131, 194, 156, 126, 32, 163, 253, 31, 65,
    157, 195, 33, 127, 252, 162, 64, 30, 95, 1, 227, 189, 62, 96, 130, 220,
    35, 125, 159, 193, 66, 28, 254, 160, 225, 191, 93, 3, 128, 222, 60, 98,
    190, 224, 2, 92, 223, 129, 99, 61, 124, 34, 192, 158, 29, 67, 161, 255,
    70, 24, 250, 164, 39, 121, 155, 197, 132, 218, 56, 102, 229, 187, 89, 7,
    219, 133, 103, 57, 186, 228, 6, 88, 25, 71, 165, 251, 120, 38, 196, 154,
    101, 59, 217, 135, 4, 90, 184, 230, 167, 249, 27, 69, 198, 152, 122, 36,
    248, 166, 68, 26, 153, 199, 37, 123, 58, 100, 134, 216, 91, 5, 231, 185,
    140, 210, 48, 110, 237, 179, 81, 15, 78, 16, 242, 172, 47, 113, 147, 205,
    17, 79, 173, 243, 112, 46, 204, 146, 211, 141, 111, 49, 178, 236, 14, 80,
    175, 241, 19, 77, 206, 144, 114, 44, 109, 51, 209, 143, 12, 82, 176, 238,
    50, 108, 142, 208, 83, 13, 239, 177, 240, 174, 76, 18, 145, 207, 45, 115,
    202, 148, 118, 40, 171, 245, 23, 73, 8, 86, 180, 234, 105, 55, 213, 139,
    87, 9, 235, 181, 54, 104, 138, 212, 149, 203, 41, 119, 244, 170, 72, 22,
    233, 183, 85, 11, 136, 214, 52, 106, 43, 117, 151, 201, 74, 20, 246, 168,
    116, 42, 200, 150, 21, 75, 169, 247, 182, 232, 10, 84, 215, 137, 107, 53
}

-- CRC校验码
local function crc8_854(dataBuf, start_pos, end_pos)
    local crc = 0

    for si = start_pos, end_pos do
        crc = crc8_854_table[bit.band(bit.bxor(crc, dataBuf[si]), 0xFF) + 1]
    end

    return crc
end

-- 将json字符串转换为LUA中的table
local function decodeJsonToTable(cmd)
    local tb

    if JSON == nil then
        JSON = require "cjson"
    end

    tb = JSON.decode(cmd)

    return tb
end

-- 将LUA中的table转换为json字符串
local function encodeTableToJson(luaTable)
    local jsonStr

    if JSON == nil then
        JSON = require "cjson"
    end

    jsonStr = JSON.encode(luaTable)

    return jsonStr
end

-- 将十六进制string字符串转成LUA中的table
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

-- 将table转成字符串
local function table2string(cmd)
    local ret = ""
    local i

    for i = 1, #cmd do
        ret = ret .. string.char(cmd[i])
    end

    return ret
end

-- 将字符串转成十六进制字符串输出
local function string2hexstring(str)
    local ret = ""

    for i = 1, #str do
        ret = ret .. string.format("%02x", str:byte(i))
    end

    return ret
end

-- 检查data的值是否超过边界
local function checkBoundary(data, min, max)
    if (not data) then
        data = 0
    end

    data = tonumber(data)

    if ((data >= min) and (data <= max)) then
        return data
    else
        if (data < min) then
            return min
        else
            return max
        end
    end
end

-- 将String转int
local function string2Int(data)
    if (not data) then
        data = tonumber("0")
    end
    data = tonumber(data)
    if (data == nil) then
        data = 0
    end
    return data
end

-- 将int转String
local function int2String(data)
    if (not data) then
        data = tostring(0)
    end
    data = tostring(data)
    if (data == nil) then
        data = "0"
    end
    return data
end

-- 打印table表
local function print_lua_table(lua_table, indent)
    indent = indent or 0

    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end

        local szSuffix = ""

        if type(v) == "table" then
            szSuffix = "{"
        end

        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix .. "[" .. k .. "]" .. " = " .. szSuffix

        if type(v) == "table" then
            print(formatting)

            print_lua_table(v, indent + 1)

            print(szPrefix .. "},")
        else
            local szValue = ""

            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end

            print(formatting .. szValue .. ",")
        end
    end
end



-- 根据电控协议不同，需要改变的函数

-- 根据传入的json修改全局变量值
local function updateGlobalPropertyValueByJson(luaTable)
    if luaTable[KEY_POWER] == "on" then
        powerValue = 0x01
    elseif luaTable[KEY_POWER] == "off" then
        powerValue = 0x00
    end

    if luaTable[KEY_SCENE_LIGHT] == "life" then
        sceneLight=0x02
    elseif luaTable[KEY_SCENE_LIGHT] == "read" then
        sceneLight=0x03
    elseif luaTable[KEY_SCENE_LIGHT] == "mild" then
        sceneLight=0x04
    elseif luaTable[KEY_SCENE_LIGHT] == "film" then
        sceneLight=0x05
    elseif luaTable[KEY_SCENE_LIGHT] == "light" then
        sceneLight=0x06
    end

    if luaTable[KEY_COLOR_TEMPERATURE] ~= nil then
        colorTemperature=string2Int(luaTable[KEY_COLOR_TEMPERATURE])
    end

    if luaTable[KEY_BRIGHTNESS] ~= nil then
        brightness=string2Int(luaTable[KEY_BRIGHTNESS])
    end

    if luaTable[KEY_DELAY_LIGHT_OFF] ~= nil then
        delayLightOff=string2Int(luaTable[KEY_DELAY_LIGHT_OFF])
    end

    --设置色温/亮度
    if luaTable[KEY_LIFE_COLOR_TEMPERATURE] ~= nil then
        lifeColorTemperature=string2Int(luaTable[KEY_LIFE_COLOR_TEMPERATURE])
    end
    if luaTable[KEY_LIFE_BRIGHTNESS] ~= nil then
        lifeBrightness=string2Int(luaTable[KEY_LIFE_BRIGHTNESS])
    end

    if luaTable[KEY_READ_COLOR_TEMPERATURE] ~= nil then
        readColorTemperature=string2Int(luaTable[KEY_READ_COLOR_TEMPERATURE])
    end

    if luaTable[KEY_READ_BRIGHTNESS] ~= nil then
        readBrightness=string2Int(luaTable[KEY_READ_BRIGHTNESS])
    end

    if luaTable[KEY_MILD_COLOR_TEMPERATURE] ~= nil then
        mildColorTemperature=string2Int(luaTable[KEY_MILD_COLOR_TEMPERATURE])
    end
    if luaTable[KEY_MILD_BRIGHTNESS] ~= nil then
        mildBrightness=string2Int(luaTable[KEY_MILD_BRIGHTNESS])
    end

    if luaTable[KEY_FILM_COLOR_TEMPERATURE] ~= nil then
        filmColorTemperature=string2Int(luaTable[KEY_FILM_COLOR_TEMPERATURE])
    end
    if luaTable[KEY_FILM_BRIGHTNESS] ~= nil then
        filmBrightness=string2Int(luaTable[KEY_FILM_BRIGHTNESS])
    end

    if luaTable[KEY_LIGHT_COLOR_TEMPERATURE] ~= nil then
        lightColorTemperature=string2Int(luaTable[KEY_LIGHT_COLOR_TEMPERATURE])
    end
    if luaTable[KEY_LIGHT_BRIGHTNESS] ~= nil then
        lightBrightness=string2Int(luaTable[KEY_LIGHT_BRIGHTNESS])
    end
end

-- 根据传入的byte[]修改全局变量值
local function updateGlobalPropertyValueByByte(messageBytes)
    cmdType=messageBytes[0]
    if cmdType==0x81 then
        --powerValue=messageBytes[1]
        result=messageBytes[1]
    end
    if cmdType==0x82 then
        --sceneLight=messageBytes[1]
        result=messageBytes[1]
    end
    if cmdType==0x83 then
        --colorTemperature=messageBytes[1]
        result=messageBytes[1]
    end
    if cmdType==0x84 then
        --brightness=messageBytes[1]
        result=messageBytes[1]
    end
    if cmdType==0x85 then
        --delayLightOff=messageBytes[1]
        result=messageBytes[1]
    end
    if cmdType==0xa4 then
        brightness=messageBytes[1]
        colorTemperature=messageBytes[2]
        sceneLight=messageBytes[3]
        delayLightOff=messageBytes[4]

        colorRed=messageBytes[5]
        colorGreen=messageBytes[6]
        colorBlue=messageBytes[7]

        powerValue=messageBytes[8]

        lifeBrightness=messageBytes[9]
        lifeColorTemperature=messageBytes[10]
        readBrightness=messageBytes[11]
        readColorTemperature=messageBytes[12]
        mildBrightness=messageBytes[13]
        mildColorTemperature=messageBytes[14]
        filmBrightness=messageBytes[15]
        filmColorTemperature=messageBytes[16]
        lightBrightness=messageBytes[17]
        lightColorTemperature=messageBytes[18]
    end

    if cmdType==0x86 then
        --lifeBrightness=messageBytes[1]
        --lifeColorTemperature=messageBytes[2]
        result=messageBytes[1]
    end
    if cmdType==0x87 then
        --readBrightness=messageBytes[1]
        --readColorTemperature=messageBytes[2]
        result=messageBytes[1]
    end
    if cmdType==0x88 then
        --mildBrightness=messageBytes[1]
        --mildColorTemperature=messageBytes[2]
        result=messageBytes[1]
    end
    if cmdType==0x89 then
        --filmBrightness=messageBytes[1]
        --filmColorTemperature=messageBytes[2]
        result=messageBytes[1]
    end
    if cmdType==0x8a then
        --lightBrightness=messageBytes[1]
        --lightColorTemperature=messageBytes[2]
        result=messageBytes[1]
    end
end

-- 将属性值转换为最终table
local function assembleJsonByGlobalProperty()
    local streams = {}
    --版本
    streams[KEY_VERSION] = "2"

    if cmdType==0xa4 then

        streams[KEY_BRIGHTNESS]=int2String(brightness)
        streams[KEY_COLOR_TEMPERATURE]=int2String(colorTemperature)

        if sceneLight==0x02 then
            streams[KEY_SCENE_LIGHT] = "life"
        elseif sceneLight==0x03 then
            streams[KEY_SCENE_LIGHT] = "read"
        elseif sceneLight==0x04 then
            streams[KEY_SCENE_LIGHT] = "mild"
        elseif sceneLight==0x05 then
            streams[KEY_SCENE_LIGHT] = "film"
        elseif sceneLight==0x06 then
            streams[KEY_SCENE_LIGHT] = "light"
        elseif sceneLight==0x01 then
            streams[KEY_SCENE_LIGHT] = "manual"
        end

        streams[KEY_DELAY_LIGHT_OFF]=int2String(delayLightOff)

        streams["color_red"]=int2String(colorRed)
        streams["color_green"]=int2String(colorGreen)
        streams["color_blue"]=int2String(colorBlue)

        if powerValue==0x01 then
            streams[KEY_POWER] = "on"
        elseif powerValue==0x00 then
            streams[KEY_POWER] = "off"
        end

        streams[KEY_LIFE_BRIGHTNESS]=int2String(lifeBrightness)
        streams[KEY_LIFE_COLOR_TEMPERATURE]=int2String(lifeColorTemperature)
        streams[KEY_READ_BRIGHTNESS]=int2String(readBrightness)
        streams[KEY_READ_COLOR_TEMPERATURE]=int2String(readColorTemperature)
        streams[KEY_MILD_BRIGHTNESS]=int2String(mildBrightness)
        streams[KEY_MILD_COLOR_TEMPERATURE]=int2String(mildColorTemperature)
        streams[KEY_FILM_BRIGHTNESS]=int2String(filmBrightness)
        streams[KEY_FILM_COLOR_TEMPERATURE]=int2String(filmColorTemperature)
        streams[KEY_LIGHT_BRIGHTNESS]=int2String(lightBrightness)
        streams[KEY_LIGHT_COLOR_TEMPERATURE]=int2String(lightColorTemperature)

        streams[KEY_RESULT]="1"
    else
        streams[KEY_RESULT]=int2String(result)
    end

    return streams
end

-- 接口方法，json转二进制，可传入原状态，此方法不能使用local修饰
function jsonToData(jsonCmdStr)
    if (#jsonCmdStr == 0) then
        return nil
    end
    local msgBytes


    local json = decodeJsonToTable(jsonCmdStr)

    local deviceSubType = json["deviceinfo"]["deviceSubType"]

    local query = json["query"]
    local control = json["control"]
    local status = json["status"]

    --当前是查询指令，构造固定的二进制即可

    if (control) then
        --将原始状态 转换为属性（全状态协议时使用）
        if (status) then
            --updateGlobalPropertyValueByJson(status)
        end

        --将用户控制 转换为属性
        if (control) then
            updateGlobalPropertyValueByJson(control)
        end

        local bodyLength = 5
        local bodyBytes = {}
        for i = 0, bodyLength - 1 do
            bodyBytes[i] = 0
        end
        --构造消息 body 部分

        if control[KEY_POWER] ~=nil then
            bodyBytes[0] = 0x01
            bodyBytes[1] = powerValue
        elseif control[KEY_SCENE_LIGHT] ~= nil then
            bodyBytes[0] = 0x02
            bodyBytes[1] = sceneLight
        elseif control[KEY_COLOR_TEMPERATURE] ~= nil then
            bodyBytes[0] = 0x03
            bodyBytes[1] = colorTemperature
        elseif control[KEY_BRIGHTNESS] ~= nil then
            bodyBytes[0] = 0x04
            bodyBytes[1] = brightness
        elseif control[KEY_DELAY_LIGHT_OFF] ~= nil then
            bodyBytes[0] = 0x05
            bodyBytes[1] = delayLightOff
        elseif control[KEY_LIFE_COLOR_TEMPERATURE] ~= nil and control[KEY_LIFE_BRIGHTNESS] ~= nil then
            bodyBytes[0] = 0x06
            bodyBytes[1] = lifeBrightness
            bodyBytes[2] = lifeColorTemperature
        elseif control[KEY_READ_COLOR_TEMPERATURE] ~= nil and control[KEY_READ_BRIGHTNESS] ~= nil then
            bodyBytes[0] = 0x07
            bodyBytes[1] = readBrightness
            bodyBytes[2] = readColorTemperature
        elseif control[KEY_MILD_COLOR_TEMPERATURE] ~= nil and control[KEY_MILD_BRIGHTNESS] ~= nil then
            bodyBytes[0] = 0x08
            bodyBytes[1] = mildBrightness
            bodyBytes[2] = mildColorTemperature
        elseif control[KEY_FILM_COLOR_TEMPERATURE] ~= nil and control[KEY_FILM_BRIGHTNESS] ~= nil then
            bodyBytes[0] = 0x09
            bodyBytes[1] = filmBrightness
            bodyBytes[2] = filmColorTemperature
        elseif control[KEY_LIGHT_COLOR_TEMPERATURE] ~= nil and control[KEY_LIGHT_BRIGHTNESS] ~= nil then
            bodyBytes[0] = 0x0A
            bodyBytes[1] = lightBrightness
            bodyBytes[2] = lightColorTemperature
        end

        msgBytes = assembleUart(bodyBytes, BYTE_CONTROL_REQUEST)
    elseif (query) then
        --构造消息 body 部分
        local bodyLength = 5
        local bodyBytes = {}
        for i = 0, bodyLength - 1 do
            bodyBytes[i] = 0
        end
        bodyBytes[0] = 0x24

        msgBytes = assembleUart(bodyBytes, BYTE_QUERY_REQUEST)
    end

    --lua table 索引从 1 开始，因此此处要重新转换一次
    local infoM = {}

    local length = #msgBytes + 1

    for i = 1, length do
        infoM[i] = msgBytes[i - 1]
    end

    --table 转换成 string 之后返回
    local ret = table2string(infoM)
    ret = string2hexstring(ret)
    return ret
end

-- 接口方法，二进制转json，此方法不能使用local修饰
function dataToJson(jsonStr)
    if (not jsonStr) then
        return nil
    end

    local json = decodeJsonToTable(jsonStr)

    local deviceinfo = json["deviceinfo"]

    --根据设备子类型来处理协议差异
    local deviceSubType = deviceinfo["deviceSubType"]
    if (deviceSubType == 1) then
    end

    local binData = json["msg"]["data"]

    local bodyBytes = {}
    --包括Uart头
    local byteData = string2table(binData)

    --获取消息数据类型
    dataType = byteData[10];

    bodyBytes = extractBodyBytes(byteData)

    --将二进制状态解析为属性值
    local ret = updateGlobalPropertyValueByByte(bodyBytes)
    local retTable = {}
    --将属性转换为table
    retTable["status"] = assembleJsonByGlobalProperty()
    --将table转换为json
    local ret = encodeTableToJson(retTable)
    return ret
end