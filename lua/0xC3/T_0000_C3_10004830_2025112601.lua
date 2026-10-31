-- 协议解析文件描述，根据实际情况修正

-- author : laojr1

-- email  : laojr1@midea.com

-- date   : 2024-01-30

-- 0xC3   : 120L2 热泵控制器



-- 修改记录

-- 2024-01-18 创建 参考吸顶灯模板

-- 2024-01-19 更新 assembleGlobalPropertyValueByJson

--            注释 updateGlobalPropertyValueByByte/assembleJsonByGlobalProperty

-- 2024-01-22 重写 updateGlobalPropertyValueByJson

--            更新 assembleQueryValueByJson/assembleJsonByByteFormat0

--            更新 assembleJsonByByte

--            更新 0xFF/0xFFFF等作为无效值

-- 2024-01-23 更新 0.0.1

-- 2024-02-21 更新 0.0.2

-- 2024-02-21 更新 0.0.3

-- 2024-02-21 更新 0.0.4

-- 2024-03-04 更新 0.0.5

-- 2024-03-05 更新 0.0.6

-- 2024-03-05 更新 0.0.7 增加 from 字段

-- 2024-03-06 更新 0.0.8 兼容旧版本处理/DEBUG_SWITCH/checkHeadBytes()/debugPrint()

-- 2024-03-06 更新 0.0.9 完善 Weekday 类型处理

-- 2024-03-07 更新 0.0.10 完善 xxx_run_time 类型

-- 2024-03-12 更新 0.0.11 增加 unit_display

-- 2024-03-13 更新 0.0.12 

--            增加 dataToJsonCoreTypeHandle()/dataToJsonAsciiTypeHandle()

--            移除 u8_system_units/u8_series/u16_profile

-- 2024-03-19 更新 0.0.13 修复居家定时mode类型/映射表统一存放

-- 2024-03-20 更新 0.0.14 修复区域2周定时mode类型

-- 2024-03-22 更新 0.0.15 更新2080命令长度

-- 2024-03-22 更新 0.0.16 重命名 zone1/zone2/C/HEmission

--                        tempDrypeak 使用U16

-- 2024-03-22 更新 0.0.17 cmd/query/control/_type 放到 status 里

-- 2024-04-07 更新 0.0.18 增加 type2/"Int"

-- 2024-04-24 更新 0.0.19 增加 type2/"0.01"

--                        更新 type2/UnitMode

-- 2024-04-28 更新 0.0.20 回滚能耗点位的缩放处理补丁

-- 2024-05-13 更新 0.0.21 加入能耗点位的缩放处理补丁

-- 2025-01-07 更新 0.0.22 若没有传 query_type,默认为 0x2010(alexa,googlehome)

-- 2025-04-24 更新 0.0.23 若没有传 control_type/u16_table,默认为 0x2010(alexa,googlehome)

-- 2025-04-29 增加场景中的互斥逻辑(其实就是直接同步120L中的 sceneDoMutex 方法)

-- 2025-05-15 fix:开启选择房间温度，APP场景修改温度值，不生效

-- 2025-11-20 更新 0.0.26 更新idu/odu版本的补丁函数，更新水流量/水压的倍率处理

-- 2025-11-26 更新 0.0.27 更新能耗点位的倍率，更新模式





-- 必须要引入的库

local JSON = require "cjson"

local bit  = require "bit"



local LUA_VERSION = { 0, 0, 27 }



local DEBUG_SWITCH = false



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



-- 双向映射表

local DOUBLEMAP = {

    ["OnOff"] = {

        [0] = "off",

        [1] = "on",

        [255] = VALUE_INVALID,



        ["off"] = 0,

        ["on"] = 1,

        [VALUE_INVALID] = 255,

    },

    ["IduMode"] = {

        [0] = "off",

        [1] = "wind",

        [2] = "cool",

        [3] = "heat",

        [4] = "force_cool",

        [5] = "auto",

        [6] = "humi",

        [116] = "on",

        [117] = "dehumi",

        [255] = VALUE_INVALID,



        ["off"] = 0,

        ["wind"] = 1,

        ["cool"] = 2,

        ["heat"] = 3,

        ["force_cool"] = 4,

        ["auto"] = 5,

        ["humi"] = 6,

        ["on"] = 116,

        ["dehumi"] = 117,

        [VALUE_INVALID] = 255,

    },

    ["TempType"] = {

        [0] = "water_temperature_type",

        [1] = "room_temperature_type",

        [255] = VALUE_INVALID,



        ["water_temperature_type"] = 0,

        ["room_temperature_type"] = 0,

        [VALUE_INVALID] = 255,

    },

    ["TerminalType"] = {

        [0] = "fan_coil",

        [1] = "radiatior",

        [2] = "floor_heat", 

        [255] = VALUE_INVALID,



        ["fan_coil"] = 0,

        ["radiatior"] = 1,

        ["floor_heat"] = 2, 

        [VALUE_INVALID] = 255,

    },

    ["AutoMode"] = {

        [0] = "normal",

        [1] = "cool",

        [2] = "heat", 

        [255] = VALUE_INVALID,



        ["normal"] = 0,

        ["cool"] = 1,

        ["heat"] = 2, 

        [VALUE_INVALID] = 255,

    },

    ["SilenceLv"] = {

        [0] = "level_1",

        [1] = "level_2",

        [2] = "level_3", 

        [255] = VALUE_INVALID,



        ["level_1"] = 0,

        ["level_2"] = 1,

        ["level_3"] = 2,

        [VALUE_INVALID] = 255,

    },

    ["Weekday"] = { 

        [0x02] = 'Mon',

        [0x04] = 'Tue',

        [0x08] = 'Wed',

        [0x10] = 'Thu',

        [0x20] = 'Fri',

        [0x40] = 'Sat',

        [0x01] = 'Sun',

        [255] = VALUE_INVALID,



        ["Mon"] = 0x02,

        ["Tue"] = 0x04,

        ["Wed"] = 0x08,

        ["Thu"] = 0x10,

        ["Fri"] = 0x20,

        ["Sat"] = 0x40,

        ["Sun"] = 0x01,

        [VALUE_INVALID] = 255,

    },

    ["UnitMode"] = { 

        [0] = 'off',

        [1] = 'auto',

        [2] = 'cool',

        [3] = 'heat',

        [4] = 'force cool',

        [5] = 'dhw',

        [6] = 'off',

        [17] = 'auto+dhw',

        [18] = 'Cooling+DHW',

        [19] = 'Heating+DHW',

        [20] = 'force cool+dhw',

        [22] = 'off+dhw',

        [255] = VALUE_INVALID,



        ["off"] = 0,

        ["auto"] = 1,

        ["cool"] = 2,

        ["heat"] = 3,

        ["force cool"] = 4,

        ["dhw"] = 5,

        ["off"] = 6,

        ["auto+dhw"] = 17,

        ["Cooling+DHW"] = 18,

        ["Heating+DHW"] = 19,

        ["force cool+dhw"] = 20,

        ["off+dhw"] = 22,



        [VALUE_INVALID] = 255,

    },

}



local function debugPrint(byteData)

    if DEBUG_SWITCH == true then

        print(byteData)

    end

end



-- profile中的 key定义太多，使用table封装变量

-- 存储属性值的变量太多，请用table封装变量





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

    msgBytes[2] = 0xC3

    msgBytes[9] = type



    for i = 0, bodyLength - 1 do

        msgBytes[i + BYTE_PROTOCOL_LENGTH] = bodyBytes[i]

    end



    msgBytes[msgLength - 1] = makeSum(msgBytes, 1, msgLength - 2)

    return msgBytes

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



-- --------------------------------------------------------------------------------------------------

-- ---------------------------------------- 120L2 表格 ------------------------------------------------

-- --------------------------------------------------------------------------------------------------

local cmd_2010 = {

    [0] =  { key = "zone1_power_state", type = "U8", type2 = "OnOff", },

    [1] =  { key = "zone2_power_state", type = "U8", type2 = "OnOff", },

    [2] =  { key = "dhw_power_state", type = "U8", type2 = "OnOff", },

    [3] =  { key = "run_mode_set", type = "U8", type2 = "IduMode", },

    [4] =  { key = "zone1_temp_set", type = "U16", type2 = "Temp", },

    [5] =  { key = "zone2_temp_set", type = "U16", type2 = "Temp", },

    [6] =  { key = "room_temp_set", type = "U16", type2 = "Temp", },

    [7] =  { key = "dhw_temp_set", type = "U16", type2 = "Temp", },

    [8] =  { key = "zone1_curve_state", type = "U8", type2 = "OnOff", },

    [9] =  { key = "zone2_curve_state", type = "U8", type2 = "OnOff", },

    [10] =  { key = "forcetbh_state", type = "U8", type2 = "OnOff", },

    [11] =  { key = "fastdhw_state", type = "U8", type2 = "OnOff", },

    [12] =  { key = "remote_onoff", type = "U8", type2 = "OnOff", },

    [13] =  { key = "silence_set_state", type = "U8", type2 = "OnOff", },

    [14] =  { key = "heat_enable", type = "U8", type2 = "OnOff", },

    [15] =  { key = "cool_enable", type = "U8", type2 = "OnOff", },

    [16] =  { key = "dhw_enable", type = "U8", type2 = "OnOff", },

    [17] =  { key = "double_zone_enable", type = "U8", type2 = "OnOff", },

    [18] =  { key = "zone1_temp_type", type = "U8", type2 = "TempType", },

    [19] =  { key = "zone2_temp_type", type = "U8", type2 = "TempType", },

    [20] =  { key = "room_thermalen_state", type = "U8", type2 = "OnOff", },

    [21] =  { key = "room_thermalmode_state", type = "U8", type2 = "OnOff", },

    [22] =  { key = "time_set_state", type = "U8", type2 = "OnOff", },

    [23] =  { key = "silence_on_state", type = "U8", type2 = "OnOff", },

    [24] =  { key = "holiday_on_state", type = "U8", type2 = "OnOff", },

    [25] =  { key = "eco_on_state", type = "U8", type2 = "OnOff", },

    [26] =  { key = "zone1_terminal_type", type = "U8", type2 = "TerminalType", },

    [27] =  { key = "zone2_terminal_type", type = "U8", type2 = "TerminalType", },

    [28] =  { key = "runmode_under_auto", type = "U8", type2 = "AutoMode", },

    [29] =  { key = "zone1_heat_max_set_temp", type = "U16", type2 = "Temp", },

    [30] =  { key = "zone1_heat_min_set_temp", type = "U16", type2 = "Temp", },

    [31] =  { key = "zone1_cool_max_set_temp", type = "U16", type2 = "Temp", },

    [32] =  { key = "zone1_cool_min_set_temp", type = "U16", type2 = "Temp", },

    [33] =  { key = "zone2_heat_max_set_temp", type = "U16", type2 = "Temp", },

    [34] =  { key = "zone2_heat_min_set_temp", type = "U16", type2 = "Temp", },

    [35] =  { key = "zone2_cool_max_set_temp", type = "U16", type2 = "Temp", },

    [36] =  { key = "zone2_cool_min_set_temp", type = "U16", type2 = "Temp", },

    [37] =  { key = "room_max_set_temp", type = "U16", type2 = "Temp", },

    [38] =  { key = "room_min_set_temp", type = "U16", type2 = "Temp", },

    [39] =  { key = "dhw_max_set_temp", type = "U16", type2 = "Temp", },

    [40] =  { key = "dhw_min_set_temp", type = "U16", type2 = "Temp", },

    [41] =  { key = "tank_actual_temp", type = "U16", type2 = "Temp", from = "idu", },

    [42] =  { key = "error_code", type = "U8", },

    [43] =  { key = "protocol_newfunction_en", type = "U8", type2 = "OnOff", },

    [44] =  { key = "boostertbh_en", type = "U8", type2 = "OnOff", },

    [45] =  { key = "zone1_curve_type", type = "U8", },

    [46] =  { key = "zone2_curve_type", type = "U8", },

    [47] =  { key = "SysEnergyAnaEN", type = "U8", type2 = "OnOff", from = "idu", },

    [48] =  { key = "HMIEnergyAnaSetEN", type = "U8", type2 = "OnOff", },

    [49] =  { key = "error_new_code", type = "ASCII/5", },

    [50] =  { key = "error_code_str", type = "ASCII/12", },

    [51] =  { key = "config_code", type = "U32", },

    [52] =  { key = "t4", type = "U16", type2 = "Temp", from = "idu", },

    [53] =  { key = "zone1_cool_curve_state", type = "U8", type2 = "OnOff", },

    [54] =  { key = "zone1_heat_curve_state", type = "U8", type2 = "OnOff", },

    [55] =  { key = "zone2_cool_curve_state", type = "U8", type2 = "OnOff", },

    [56] =  { key = "zone2_heat_curve_state", type = "U8", type2 = "OnOff", },

    [57] =  { key = "holiday_on_type", type = "U8", },

    [58] =  { key = "year", type = "U8", },

    [59] =  { key = "month", type = "U8", },

    [60] =  { key = "day", type = "U8", },

    [61] =  { key = "hour", type = "U8", },

    [62] =  { key = "minute", type = "U8", },

    [63] =  { key = "backupSensorState", type = "U8", },

    [64] =  { key = "backupSensorRemainTime", type = "U16", },

    [65] =  { key = "backupSensorOverAccuracy", type = "U8", },

    [66] =  { key = "unit_display", type = "U8", },

}



local cmd_2020 = {

    [0] =  { key = "daytimer_timer1en", type = "U8", type2 = "OnOff", },

    [1] =  { key = "daytimer_timer1_mode", type = "U8", type2 = "IduMode", },

    [2] =  { key = "daytimer_timer1_temp", type = "U16", type2 = "Temp", },

    [3] =  { key = "daytimer_timer1_openhour", type = "U8", },

    [4] =  { key = "daytimer_timer1_openmin", type = "U8", },

    [5] =  { key = "daytimer_timer2en", type = "U8", type2 = "OnOff", },

    [6] =  { key = "daytimer_timer2_mode", type = "U8", type2 = "IduMode", },

    [7] =  { key = "daytimer_timer2_temp", type = "U16", type2 = "Temp", },

    [8] =  { key = "daytimer_timer2_openhour", type = "U8", },

    [9] =  { key = "daytimer_timer2_openmin", type = "U8", },

    [10] =  { key = "daytimer_timer3en", type = "U8", type2 = "OnOff", },

    [11] =  { key = "daytimer_timer3_mode", type = "U8", type2 = "IduMode", },

    [12] =  { key = "daytimer_timer3_temp", type = "U16", type2 = "Temp", },

    [13] =  { key = "daytimer_timer3_openhour", type = "U8", },

    [14] =  { key = "daytimer_timer3_openmin", type = "U8", },

    [15] =  { key = "daytimer_timer4en", type = "U8", type2 = "OnOff", },

    [16] =  { key = "daytimer_timer4_mode", type = "U8", type2 = "IduMode", },

    [17] =  { key = "daytimer_timer4_temp", type = "U16", type2 = "Temp", },

    [18] =  { key = "daytimer_timer4_openhour", type = "U8", },

    [19] =  { key = "daytimer_timer4_openmin", type = "U8", },

    [20] =  { key = "daytimer_timer5en", type = "U8", type2 = "OnOff", },

    [21] =  { key = "daytimer_timer5_mode", type = "U8", type2 = "IduMode", },

    [22] =  { key = "daytimer_timer5_temp", type = "U16", type2 = "Temp", },

    [23] =  { key = "daytimer_timer5_openhour", type = "U8", },

    [24] =  { key = "daytimer_timer5_openmin", type = "U8", },

    [25] =  { key = "daytimer_timer6en", type = "U8", type2 = "OnOff", },

    [26] =  { key = "daytimer_timer6_mode", type = "U8", type2 = "IduMode", },

    [27] =  { key = "daytimer_timer6_temp", type = "U16", type2 = "Temp", },

    [28] =  { key = "daytimer_timer6_openhour", type = "U8", },

    [29] =  { key = "daytimer_timer6_openmin", type = "U8", },

    [30] =  { key = "zone2daytimer_timer1en", type = "U8", type2 = "OnOff", },

    [31] =  { key = "zone2daytimer_timer1_mode", type = "U8", type2 = "IduMode", },

    [32] =  { key = "zone2daytimer_timer1_temp", type = "U16", type2 = "Temp", },

    [33] =  { key = "zone2daytimer_timer1_openhour", type = "U8", },

    [34] =  { key = "zone2daytimer_timer1_openmin", type = "U8", },

    [35] =  { key = "zone2daytimer_timer2en", type = "U8", type2 = "OnOff", },

    [36] =  { key = "zone2daytimer_timer2_mode", type = "U8", type2 = "IduMode", },

    [37] =  { key = "zone2daytimer_timer2_temp", type = "U16", type2 = "Temp", },

    [38] =  { key = "zone2daytimer_timer2_openhour", type = "U8", },

    [39] =  { key = "zone2daytimer_timer2_openmin", type = "U8", },

    [40] =  { key = "zone2daytimer_timer3en", type = "U8", type2 = "OnOff", },

    [41] =  { key = "zone2daytimer_timer3_mode", type = "U8", type2 = "IduMode", },

    [42] =  { key = "zone2daytimer_timer3_temp", type = "U16", type2 = "Temp", },

    [43] =  { key = "zone2daytimer_timer3_openhour", type = "U8", },

    [44] =  { key = "zone2daytimer_timer3_openmin", type = "U8", },

    [45] =  { key = "zone2daytimer_timer4en", type = "U8", type2 = "OnOff", },

    [46] =  { key = "zone2daytimer_timer4_mode", type = "U8", type2 = "IduMode", },

    [47] =  { key = "zone2daytimer_timer4_temp", type = "U16", type2 = "Temp", },

    [48] =  { key = "zone2daytimer_timer4_openhour", type = "U8", },

    [49] =  { key = "zone2daytimer_timer4_openmin", type = "U8", },

    [50] =  { key = "zone2daytimer_timer5en", type = "U8", type2 = "OnOff", },

    [51] =  { key = "zone2daytimer_timer5_mode", type = "U8", type2 = "IduMode", },

    [52] =  { key = "zone2daytimer_timer5_temp", type = "U16", type2 = "Temp", },

    [53] =  { key = "zone2daytimer_timer5_openhour", type = "U8", },

    [54] =  { key = "zone2daytimer_timer5_openmin", type = "U8", },

    [55] =  { key = "zone2daytimer_timer6en", type = "U8", type2 = "OnOff", },

    [56] =  { key = "zone2daytimer_timer6_mode", type = "U8", type2 = "IduMode", },

    [57] =  { key = "zone2daytimer_timer6_temp", type = "U16", type2 = "Temp", },

    [58] =  { key = "zone2daytimer_timer6_openhour", type = "U8", },

    [59] =  { key = "zone2daytimer_timer6_openmin", type = "U8", },

    [60] =  { key = "dhwdaytimer_timer1en", type = "U8", type2 = "OnOff", },

    [61] =  { key = "dhwdaytimer_timer1_mode", type = "U8", type2 = "OnOff", },

    [62] =  { key = "dhwdaytimer_timer1_temp", type = "U16", type2 = "Temp", },

    [63] =  { key = "dhwdaytimer_timer1_openhour", type = "U8", },

    [64] =  { key = "dhwdaytimer_timer1_openmin", type = "U8", },

    [65] =  { key = "dhwdaytimer_timer2en", type = "U8", type2 = "OnOff", },

    [66] =  { key = "dhwdaytimer_timer2_mode", type = "U8", type2 = "OnOff", },

    [67] =  { key = "dhwdaytimer_timer2_temp", type = "U16", type2 = "Temp", },

    [68] =  { key = "dhwdaytimer_timer2_openhour", type = "U8", },

    [69] =  { key = "dhwdaytimer_timer2_openmin", type = "U8", },

    [70] =  { key = "dhwdaytimer_timer3en", type = "U8", type2 = "OnOff", },

    [71] =  { key = "dhwdaytimer_timer3_mode", type = "U8", type2 = "OnOff", },

    [72] =  { key = "dhwdaytimer_timer3_temp", type = "U16", type2 = "Temp", },

    [73] =  { key = "dhwdaytimer_timer3_openhour", type = "U8", },

    [74] =  { key = "dhwdaytimer_timer3_openmin", type = "U8", },

    [75] =  { key = "dhwdaytimer_timer4en", type = "U8", type2 = "OnOff", },

    [76] =  { key = "dhwdaytimer_timer4_mode", type = "U8", type2 = "OnOff", },

    [77] =  { key = "dhwdaytimer_timer4_temp", type = "U16", type2 = "Temp", },

    [78] =  { key = "dhwdaytimer_timer4_openhour", type = "U8", },

    [79] =  { key = "dhwdaytimer_timer4_openmin", type = "U8", },

    [80] =  { key = "dhwdaytimer_timer5en", type = "U8", type2 = "OnOff", },

    [81] =  { key = "dhwdaytimer_timer5_mode", type = "U8", type2 = "OnOff", },

    [82] =  { key = "dhwdaytimer_timer5_temp", type = "U16", type2 = "Temp", },

    [83] =  { key = "dhwdaytimer_timer5_openhour", type = "U8", },

    [84] =  { key = "dhwdaytimer_timer5_openmin", type = "U8", },

    [85] =  { key = "dhwdaytimer_timer6en", type = "U8", type2 = "OnOff", },

    [86] =  { key = "dhwdaytimer_timer6_mode", type = "U8", type2 = "OnOff", },

    [87] =  { key = "dhwdaytimer_timer6_temp", type = "U16", type2 = "Temp", },

    [88] =  { key = "dhwdaytimer_timer6_openhour", type = "U8", },

    [89] =  { key = "dhwdaytimer_timer6_openmin", type = "U8", },

}



local cmd_2040 = {

    [0] =  { key = "holidayaway_state", type = "U8", type2 = "OnOff", },

    [1] =  { key = "holidayaway_heat_state", type = "U8", type2 = "OnOff", },

    [2] =  { key = "holidayaway_dhw_state", type = "U8", type2 = "OnOff", },

    [3] =  { key = "holidayaway_disinfect_state", type = "U8", type2 = "OnOff", },

    [4] =  { key = "holidayaway_startyear", type = "U8", },

    [5] =  { key = "holidayaway_startmonth", type = "U8", },

    [6] =  { key = "holidayaway_startdate", type = "U8", },

    [7] =  { key = "holidayaway_endyear", type = "U8", },

    [8] =  { key = "holidayaway_endmonth", type = "U8", },

    [9] =  { key = "holidayaway_enddate", type = "U8", },

    [10] =  { key = "holidayaway_heat_temp", type = "U16", type2 = "Temp", },

    [11] =  { key = "holidayaway_dhw_temp", type = "U16", type2 = "Temp", },

}



local cmd_2050 = {

    [0] =  { key = "silence_function_state", type = "U8", type2 = "OnOff", },

    [1] =  { key = "silence_function_level", type = "U8", type2 = "SilenceLv", },

    [2] =  { key = "silence_timer1_state", type = "U8", type2 = "OnOff", },

    [3] =  { key = "silence_timer1_starthour", type = "U8", },

    [4] =  { key = "silence_timer1_startmin", type = "U8", },

    [5] =  { key = "silence_timer1_endhour", type = "U8", },

    [6] =  { key = "silence_timer1_endmin", type = "U8", },

    [7] =  { key = "silence_timer2_state", type = "U8", type2 = "OnOff", },

    [8] =  { key = "silence_timer2_starthour", type = "U8", },

    [9] =  { key = "silence_timer2_startmin", type = "U8", },

    [10] =  { key = "silence_timer2_endhour", type = "U8", },

    [11] =  { key = "silence_timer2_endmin", type = "U8", },

}



local cmd_2060 = {

    [0] =  { key = "holidayhome_state", type = "U8", type2 = "OnOff", },

    [1] =  { key = "holidayhome_startyear", type = "U8", },

    [2] =  { key = "holidayhome_startmonth", type = "U8", },

    [3] =  { key = "holidayhome_startdate", type = "U8", },

    [4] =  { key = "holidayhome_endyear", type = "U8", },

    [5] =  { key = "holidayhome_endmonth", type = "U8", },

    [6] =  { key = "holidayhome_enddate", type = "U8", },

    [7] =  { key = "holhometimer_timer1en", type = "U8", type2 = "OnOff", },

    [8] =  { key = "holhometimer_timer2en", type = "U8", type2 = "OnOff", },

    [9] =  { key = "holhometimer_timer3en", type = "U8", type2 = "OnOff", },

    [10] =  { key = "holhometimer_timer4en", type = "U8", type2 = "OnOff", },

    [11] =  { key = "holhometimer_timer5en", type = "U8", type2 = "OnOff", },

    [12] =  { key = "holhometimer_timer6en", type = "U8", type2 = "OnOff", },

    [13] =  { key = "holhometimer_timer1_mode", type = "U8", type2 = "IduMode", },

    [14] =  { key = "holhometimer_timer1_temp", type = "U16", type2 = "Temp", },

    [15] =  { key = "holhometimer_timer1_openhour", type = "U8", },

    [16] =  { key = "holhometimer_timer1_openmin", type = "U8", },

    [17] =  { key = "holhometimer_timer2_mode", type = "U8", type2 = "IduMode", },

    [18] =  { key = "holhometimer_timer2_temp", type = "U16", type2 = "Temp", },

    [19] =  { key = "holhometimer_timer2_openhour", type = "U8", },

    [20] =  { key = "holhometimer_timer2_openmin", type = "U8", },

    [21] =  { key = "holhometimer_timer3_mode", type = "U8", type2 = "IduMode", },

    [22] =  { key = "holhometimer_timer3_temp", type = "U16", type2 = "Temp", },

    [23] =  { key = "holhometimer_timer3_openhour", type = "U8", },

    [24] =  { key = "holhometimer_timer3_openmin", type = "U8", },

    [25] =  { key = "holhometimer_timer4_mode", type = "U8", type2 = "IduMode", },

    [26] =  { key = "holhometimer_timer4_temp", type = "U16", type2 = "Temp", },

    [27] =  { key = "holhometimer_timer4_openhour", type = "U8", },

    [28] =  { key = "holhometimer_timer4_openmin", type = "U8", },

    [29] =  { key = "holhometimer_timer5_mode", type = "U8", type2 = "IduMode", },

    [30] =  { key = "holhometimer_timer5_temp", type = "U16", type2 = "Temp", },

    [31] =  { key = "holhometimer_timer5_openhour", type = "U8", },

    [32] =  { key = "holhometimer_timer5_openmin", type = "U8", },

    [33] =  { key = "holhometimer_timer6_mode", type = "U8", type2 = "IduMode", },

    [34] =  { key = "holhometimer_timer6_temp", type = "U16", type2 = "Temp", },

    [35] =  { key = "holhometimer_timer6_openhour", type = "U8", },

    [36] =  { key = "holhometimer_timer6_openmin", type = "U8", },

    [37] =  { key = "zone2holhometimer_timer1en", type = "U8", type2 = "OnOff", },

    [38] =  { key = "zone2holhometimer_timer2en", type = "U8", type2 = "OnOff", },

    [39] =  { key = "zone2holhometimer_timer3en", type = "U8", type2 = "OnOff", },

    [40] =  { key = "zone2holhometimer_timer4en", type = "U8", type2 = "OnOff", },

    [41] =  { key = "zone2holhometimer_timer5en", type = "U8", type2 = "OnOff", },

    [42] =  { key = "zone2holhometimer_timer6en", type = "U8", type2 = "OnOff", },

    [43] =  { key = "zone2holhometimer_timer1_mode", type = "U8", type2 = "IduMode", },

    [44] =  { key = "zone2holhometimer_timer1_temp", type = "U16", type2 = "Temp", },

    [45] =  { key = "zone2holhometimer_timer1_openhour", type = "U8", },

    [46] =  { key = "zone2holhometimer_timer1_openmin", type = "U8", },

    [47] =  { key = "zone2holhometimer_timer2_mode", type = "U8", type2 = "IduMode", },

    [48] =  { key = "zone2holhometimer_timer2_temp", type = "U16", type2 = "Temp", },

    [49] =  { key = "zone2holhometimer_timer2_openhour", type = "U8", },

    [50] =  { key = "zone2holhometimer_timer2_openmin", type = "U8", },

    [51] =  { key = "zone2holhometimer_timer3_mode", type = "U8", type2 = "IduMode", },

    [52] =  { key = "zone2holhometimer_timer3_temp", type = "U16", type2 = "Temp", },

    [53] =  { key = "zone2holhometimer_timer3_openhour", type = "U8", },

    [54] =  { key = "zone2holhometimer_timer3_openmin", type = "U8", },

    [55] =  { key = "zone2holhometimer_timer4_mode", type = "U8", type2 = "IduMode", },

    [56] =  { key = "zone2holhometimer_timer4_temp", type = "U16", type2 = "Temp", },

    [57] =  { key = "zone2holhometimer_timer4_openhour", type = "U8", },

    [58] =  { key = "zone2holhometimer_timer4_openmin", type = "U8", },

    [59] =  { key = "zone2holhometimer_timer5_mode", type = "U8", type2 = "IduMode", },

    [60] =  { key = "zone2holhometimer_timer5_temp", type = "U16", type2 = "Temp", },

    [61] =  { key = "zone2holhometimer_timer5_openhour", type = "U8", },

    [62] =  { key = "zone2holhometimer_timer5_openmin", type = "U8", },

    [63] =  { key = "zone2holhometimer_timer6_mode", type = "U8", type2 = "IduMode", },

    [64] =  { key = "zone2holhometimer_timer6_temp", type = "U16", type2 = "Temp", },

    [65] =  { key = "zone2holhometimer_timer6_openhour", type = "U8", },

    [66] =  { key = "zone2holhometimer_timer6_openmin", type = "U8", },

    [67] =  { key = "dhwholhometimer_timer1en", type = "U8", type2 = "OnOff", },

    [68] =  { key = "dhwholhometimer_timer2en", type = "U8", type2 = "OnOff", },

    [69] =  { key = "dhwholhometimer_timer3en", type = "U8", type2 = "OnOff", },

    [70] =  { key = "dhwholhometimer_timer4en", type = "U8", type2 = "OnOff", },

    [71] =  { key = "dhwholhometimer_timer5en", type = "U8", type2 = "OnOff", },

    [72] =  { key = "dhwholhometimer_timer6en", type = "U8", type2 = "OnOff", },

    [73] =  { key = "dhwholhometimer_timer1_mode", type = "U8", type2 = "OnOff", },

    [74] =  { key = "dhwholhometimer_timer1_temp", type = "U16", type2 = "Temp", },

    [75] =  { key = "dhwholhometimer_timer1_openhour", type = "U8", },

    [76] =  { key = "dhwholhometimer_timer1_openmin", type = "U8", },

    [77] =  { key = "dhwholhometimer_timer2_mode", type = "U8", type2 = "OnOff", },

    [78] =  { key = "dhwholhometimer_timer2_temp", type = "U16", type2 = "Temp", },

    [79] =  { key = "dhwholhometimer_timer2_openhour", type = "U8", },

    [80] =  { key = "dhwholhometimer_timer2_openmin", type = "U8", },

    [81] =  { key = "dhwholhometimer_timer3_mode", type = "U8", type2 = "OnOff", },

    [82] =  { key = "dhwholhometimer_timer3_temp", type = "U16", type2 = "Temp", },

    [83] =  { key = "dhwholhometimer_timer3_openhour", type = "U8", },

    [84] =  { key = "dhwholhometimer_timer3_openmin", type = "U8", },

    [85] =  { key = "dhwholhometimer_timer4_mode", type = "U8", type2 = "OnOff", },

    [86] =  { key = "dhwholhometimer_timer4_temp", type = "U16", type2 = "Temp", },

    [87] =  { key = "dhwholhometimer_timer4_openhour", type = "U8", },

    [88] =  { key = "dhwholhometimer_timer4_openmin", type = "U8", },

    [89] =  { key = "dhwholhometimer_timer5_mode", type = "U8", type2 = "OnOff", },

    [90] =  { key = "dhwholhometimer_timer5_temp", type = "U16", type2 = "Temp", },

    [91] =  { key = "dhwholhometimer_timer5_openhour", type = "U8", },

    [92] =  { key = "dhwholhometimer_timer5_openmin", type = "U8", },

    [93] =  { key = "dhwholhometimer_timer6_mode", type = "U8", type2 = "OnOff", },

    [94] =  { key = "dhwholhometimer_timer6_temp", type = "U16", type2 = "Temp", },

    [95] =  { key = "dhwholhometimer_timer6_openhour", type = "U8", },

    [96] =  { key = "dhwholhometimer_timer6_openmin", type = "U8", },

}



local cmd_2070 = {

    [0] =  { key = "eco_function_state", type = "U8", type2 = "OnOff", },

    [1] =  { key = "eco_timer_state", type = "U8", type2 = "OnOff", },

    [2] =  { key = "eco_timer_starthour", type = "U8", },

    [3] =  { key = "eco_timer_startmin", type = "U8", },

    [4] =  { key = "eco_timer_endhour", type = "U8", },

    [5] =  { key = "eco_timer_endmin", type = "U8", },

    [6] =  { key = "eco_curve_type", type = "U8", },

}



local cmd_2080 = {

    [0] =  { key = "dhwEnable", type = "U8", type2 = "OnOff", },

    [1] =  { key = "boostertbhEn", type = "U8", type2 = "OnOff", },

    [2] =  { key = "disinfectEnable", type = "U8", type2 = "OnOff", },

    [3] =  { key = "dhwPumpEnable", type = "U8", type2 = "OnOff", },

    [4] =  { key = "dhwPriorityTime", type = "U8", type2 = "OnOff", },

    [5] =  { key = "dhwPumpDIEnable", type = "U8", type2 = "OnOff", },

    [6] =  { key = "coolEnable", type = "U8", type2 = "OnOff", },

    [7] =  { key = "fgZone1CoolTempHigh", type = "U8", type2 = "OnOff", },

    [8] =  { key = "heatEnable", type = "U8", type2 = "OnOff", },

    [9] =  { key = "fgZone1HeatTempHigh", type = "U8", type2 = "OnOff", },

    [10] =  { key = "pumpiSliModeEn", type = "U8", type2 = "OnOff", },

    [11] =  { key = "roomSensorEn", type = "U8", type2 = "OnOff", },

    [12] =  { key = "roomTherEn", type = "U8", type2 = "OnOff", },

    [13] =  { key = "roomTherSetModeEn", type = "U8", type2 = "OnOff", },

    [14] =  { key = "dualroomThermostatEn", type = "U8", type2 = "OnOff", },

    [15] =  { key = "fgdhwPriorEn", type = "U8", type2 = "OnOff", },

    [16] =  { key = "acsEnable", type = "U8", type2 = "OnOff", },

    [17] =  { key = "dhwHeaterAhsEn", type = "U8", type2 = "OnOff", },

    [18] =  { key = "tempPcbEn", type = "U8", type2 = "OnOff", },

    [19] =  { key = "tbt2ProbeEn", type = "U8", type2 = "OnOff", },

    [20] =  { key = "pipeExceed10m", type = "U8", type2 = "OnOff", },

    [21] =  { key = "solarCn18En", type = "U8", type2 = "OnOff", },

    [22] =  { key = "fgOwnSolarEn", type = "U8", type2 = "OnOff", },

    [23] =  { key = "fgInputDhwHeater", type = "U8", type2 = "OnOff", },

    [24] =  { key = "smartgridEn", type = "U8", type2 = "OnOff", },

    [25] =  { key = "t1bProbeEn", type = "U8", type2 = "OnOff", },

    [26] =  { key = "fgZone2CoolTempHigh", type = "U8", type2 = "OnOff", },

    [27] =  { key = "fgZone2HeatTempHigh", type = "U8", type2 = "OnOff", },

    [28] =  { key = "doubleZoneEn", type = "U8", type2 = "OnOff", },

    [29] =  { key = "fgTaProbeIdu", type = "U8", type2 = "OnOff", },

    [30] =  { key = "tbt1ProbeEn", type = "U8", type2 = "OnOff", },

    [31] =  { key = "fgIbhInTank", type = "U8", type2 = "OnOff", },

    [32] =  { key = "dT5On", type = "U16", type2 = "Temp", },

    [33] =  { key = "dT1S5", type = "U16", type2 = "Temp", },

    [34] =  { key = "tIntervaDhw", type = "U8", },

    [35] =  { key = "t4Dhwmax", type = "U16", type2 = "Temp", },

    [36] =  { key = "t4Dhwmin", type = "U16", type2 = "Temp", },

    [37] =  { key = "tTBHdelay", type = "U8", },

    [38] =  { key = "dT5STBHoff", type = "U16", type2 = "Temp", },

    [39] =  { key = "t4TBHon", type = "U16", type2 = "Temp", },

    [40] =  { key = "t5sDI", type = "U16", type2 = "Temp", },

    [41] =  { key = "tDImax", type = "U16", },

    [42] =  { key = "tDIhightemp", type = "U8", },

    [43] =  { key = "tIntervalC", type = "U8", },

    [44] =  { key = "dT1SC", type = "U16", type2 = "Temp", },

    [45] =  { key = "dTSC", type = "U16", type2 = "Temp", },

    [46] =  { key = "t4Cmax", type = "U16", type2 = "Temp", },

    [47] =  { key = "t4Cmin", type = "U16", type2 = "Temp", },

    [48] =  { key = "tIntervalH", type = "U8", },

    [49] =  { key = "dT1SH", type = "U16", type2 = "Temp", },

    [50] =  { key = "dTSH", type = "U16", type2 = "Temp", },

    [51] =  { key = "t4Hmax", type = "U16", type2 = "Temp", },

    [52] =  { key = "t4Hmin", type = "U16", type2 = "Temp", },

    [53] =  { key = "t4IBHon", type = "U16", type2 = "Temp", },

    [54] =  { key = "dT1IBHon", type = "U16", type2 = "Temp", },

    [55] =  { key = "tIBHdelay", type = "U8", },

    [56] =  { key = "tIBH12delay", type = "U8", },

    [57] =  { key = "t4AHSon", type = "U16", type2 = "Temp", },

    [58] =  { key = "dT1AHSon", type = "U16", type2 = "Temp", },

    [59] =  { key = "dT1AHSoff", type = "U16", type2 = "Temp", },

    [60] =  { key = "tAHSdelay", type = "U8", },

    [61] =  { key = "tDHWHPmax", type = "U16", },

    [62] =  { key = "tDHWHPrestrict", type = "U16", },

    [63] =  { key = "t4autocmin", type = "U16", type2 = "Temp", },

    [64] =  { key = "t4autohmax", type = "U16", type2 = "Temp", },

    [65] =  { key = "t1sHolHeat", type = "U16", type2 = "Temp", },

    [66] =  { key = "t5SHolDhw", type = "U16", type2 = "Temp", },

    [67] =  { key = "perStart", type = "U8", },

    [68] =  { key = "timeAdjust", type = "U8", },

    [69] =  { key = "dTbt2", type = "U16", type2 = "Temp", },

    [70] =  { key = "powerIbh1", type = "U8", type2 = "0.1kW", },

    [71] =  { key = "powerIbh2", type = "U8", type2 = "0.1kW", },

    [72] =  { key = "powerTbh", type = "U8", type2 = "0.1kW", },

    [73] =  { key = "ecoHeatT1s", type = "U16", type2 = "Temp", },

    [74] =  { key = "ecoHeatTs", type = "U16", type2 = "Temp", },

    [75] =  { key = "tDryup", type = "U8", },

    [76] =  { key = "tDrypeak", type = "U8", },

    [77] =  { key = "tdrydown", type = "U8", },

    [78] =  { key = "tempDrypeak", type = "U16", type2 = "Temp", },

    [79] =  { key = "timePreheatFloor", type = "U8", },

    [80] =  { key = "t1SPreheatFloor", type = "U16", type2 = "Temp", },

    [81] =  { key = "t1SetC1", type = "U16", type2 = "Temp", },

    [82] =  { key = "t1SetC2", type = "U16", type2 = "Temp", },

    [83] =  { key = "t4C1", type = "U16", type2 = "Temp", },

    [84] =  { key = "t4C2", type = "U16", type2 = "Temp", },

    [85] =  { key = "t1SetH1", type = "U16", type2 = "Temp", },

    [86] =  { key = "t1SetH2", type = "U16", type2 = "Temp", },

    [87] =  { key = "t4H1", type = "U16", type2 = "Temp", },

    [88] =  { key = "t4H2", type = "U16", type2 = "Temp", },

    [89] =  { key = "typeVolLmt", type = "U8", },

    [90] =  { key = "timeT4FreshC", type = "U8", },

    [91] =  { key = "timeT4FreshH", type = "U8", },

    [92] =  { key = "tPumpiDelay", type = "U8", },

    [93] =  { key = "deltaTsloar", type = "U16", type2 = "Temp", },

    [94] =  { key = "solarFunction", type = "U8", },

    [95] =  { key = "enSwitchPDC", type = "U8", type2 = "OnOff", },

    [96] =  { key = "gasCost", type = "U16", },

    [97] =  { key = "eleCost", type = "U16", },

    [98] =  { key = "ahsSetTempMax", type = "U16", type2 = "Temp", },

    [99] =  { key = "ahsSetTempMin", type = "U16", type2 = "Temp", },

    [100] =  { key = "ahsSetTempMaxVolt", type = "U16", },

    [101] =  { key = "ahsSetTempMinVolt", type = "U16", },

    [102] =  { key = "t2AntiSVRun", type = "U8", },

    [103] =  { key = "dftPortFuncEn", type = "U8", },

    [104] =  { key = "t1AntiPump", type = "U8", },

    [105] =  { key = "t2AntiPumpRun", type = "U16", },

    [106] =  { key = "t1AntiLockSV", type = "U8", },

    [107] =  { key = "tbhEnFunc", type = "U8", },

    [108] =  { key = "ibhEnFunc", type = "U8", },

    [109] =  { key = "ahsEnFunc", type = "U8", },

    [110] =  { key = "ahsPumpiControl", type = "U8", },

    [111] =  { key = "modeSetPri", type = "U8", },

    [112] =  { key = "pumpType", type = "U8", },

    [113] =  { key = "pumpiSilentOutput", type = "U8", },

    [114] =  { key = "timeReportSet", type = "U8", },

    [115] =  { key = "backupSensorVaild", type = "U8", from = "idu", },

    [116] =  { key = "backupSensorEnabe", type = "U8", from = "idu", },

    [117] =  { key = "backupSensorTime", type = "U16", from = "idu", },

    [118] =  { key = "energyCorrection", type = "U16", type2 = "Int", from = "odu", },

    [119] =  { key = "c2FaultResotre", type = "U8", },

    [120] =  { key = "flashSNCode", type = "U8", },

    [121] =  { key = "syncInstallParams", type = "U8", },

    [122] =  { key = "zone2T1SetC1", type = "U16", type2 = "Temp", },

    [123] =  { key = "zone2T1SetC2", type = "U16", type2 = "Temp", },

    [124] =  { key = "zone2T4C1", type = "U16", type2 = "Temp", },

    [125] =  { key = "zone2T4C2", type = "U16", type2 = "Temp", },

    [126] =  { key = "zone2T1SetH1", type = "U16", type2 = "Temp", },

    [127] =  { key = "zone2T1SetH2", type = "U16", type2 = "Temp", },

    [128] =  { key = "zone2T4H1", type = "U16", type2 = "Temp", },

    [129] =  { key = "zone2T4H2", type = "U16", type2 = "Temp", },

    [130] =  { key = "zone1CEmission", type = "U8", },

    [131] =  { key = "zone1HEmission", type = "U8", },

    [132] =  { key = "zone2CEmission", type = "U8", },

    [133] =  { key = "zone2HEmission", type = "U8", },

    [134] =  { key = "t1SCLmin", type = "U16", type2 = "Temp", },

}





local cmd_2090 = {

    [0] =  { key = "disinfect_function_state", type = "U8", type2 = "OnOff", },

    [1] =  { key = "disinfect_run_state", type = "U8", type2 = "OnOff", from = "idu", },

    [2] =  { key = "disinfect_setweekday", type = "U8", },

    [3] =  { key = "disinfect_starthour", type = "U8", },

    [4] =  { key = "disinfect_startmin", type = "U8", },

    [5] =  { key = "disinfect_valid", type = "U8", type2 = "OnOff", from = "idu", },

    [6] =  { key = "disinfect_control", type = "U8", type2 = "OnOff", },

}



local cmd_2100 = {

    [0] =  { key = "t1SClimitExist",           type = "U8", type2 = "OnOff", from = "idu", },

    [1] =  { key = "ACSExist",                 type = "U8", type2 = "OnOff", from = "idu", },

    [2] =  { key = "HMISetIBHExist",           type = "U8", type2 = "OnOff", from = "idu", },

    [3] =  { key = "HMISetAHSExist",           type = "U8", type2 = "OnOff", from = "idu", },

    [4] =  { key = "HMISetTBHExist",           type = "U8", type2 = "OnOff", from = "idu", },

    [5] =  { key = "pumpiSilentModeExist",     type = "U8", type2 = "OnOff", from = "idu", },

    [6] =  { key = "pPipeLengthExist",         type = "U8", type2 = "OnOff", from = "idu", },

    [7] =  { key = "energyCorrectionExist",    type = "U8", type2 = "OnOff", from = "idu", },

    [8] =  { key = "backupSenserExist",        type = "U8", type2 = "OnOff", from = "idu", },

    [9] =  { key = "energyMeterExist",         type = "U8", type2 = "OnOff", from = "idu", },

    [10] = { key = "boostExist",               type = "U8", type2 = "OnOff", from = "idu", },

    [11] = { key = "pumpOExist",               type = "U8", type2 = "OnOff", from = "idu", },

    [12] = { key = "modeSetPriExist",          type = "U8", type2 = "OnOff", from = "idu", },

    [13] = { key = "AHSPumpExist",             type = "U8", type2 = "OnOff", from = "idu", },

    [14] = { key = "zone2CoolExist",           type = "U8", type2 = "OnOff", from = "idu", },

}



local cmd_20A0 = {

    [0] =  { key = "hmiVersionNum", type = "ASCII/32", },

    [1] =  { key = "compRunCurTime0", type = "U32", },

    [2] =  { key = "compRunTotalTime0", type = "U32", },

    [3] =  { key = "fanRunTotalTime0", type = "U32", },

    [4] =  { key = "pumpiRunTotalTime0", type = "U32", },

    [5] =  { key = "ibh1RunTotalTime0", type = "U32", },

    [6] =  { key = "ibh2RunTotalTime0", type = "U32", },

    [7] =  { key = "tbhRunTotalTime0", type = "U32", },

    [8] =  { key = "ahsRunTotalTime0", type = "U32", },

    [9] =  { key = "arrayServiceTel0", type = "ASCII/1", },

    [10] =  { key = "arrayServiceTel1", type = "ASCII/1", },

    [11] =  { key = "arrayServiceTel2", type = "ASCII/1", },

    [12] =  { key = "arrayServiceTel3", type = "ASCII/1", },

    [13] =  { key = "arrayServiceTel4", type = "ASCII/1", },

    [14] =  { key = "arrayServiceTel5", type = "ASCII/1", },

    [15] =  { key = "arrayServiceTel6", type = "ASCII/1", },

    [16] =  { key = "arrayServiceTel7", type = "ASCII/1", },

    [17] =  { key = "arrayServiceTel8", type = "ASCII/1", },

    [18] =  { key = "arrayServiceTel9", type = "ASCII/1", },

    [19] =  { key = "arrayServiceTel10", type = "ASCII/1", },

    [20] =  { key = "arrayServiceTel11", type = "ASCII/1", },

    [21] =  { key = "arrayServiceTel12", type = "ASCII/1", },

    [22] =  { key = "arrayServiceTel13", type = "ASCII/1", },

    [23] =  { key = "arrayServiceTel14", type = "ASCII/1", },

    [24] =  { key = "ArrayServiceCel0", type = "ASCII/1", },

    [25] =  { key = "ArrayServiceCel1", type = "ASCII/1", },

    [26] =  { key = "ArrayServiceCel2", type = "ASCII/1", },

    [27] =  { key = "ArrayServiceCel3", type = "ASCII/1", },

    [28] =  { key = "ArrayServiceCel4", type = "ASCII/1", },

    [29] =  { key = "ArrayServiceCel5", type = "ASCII/1", },

    [30] =  { key = "ArrayServiceCel6", type = "ASCII/1", },

    [31] =  { key = "ArrayServiceCel7", type = "ASCII/1", },

    [32] =  { key = "ArrayServiceCel8", type = "ASCII/1", },

    [33] =  { key = "ArrayServiceCel9", type = "ASCII/1", },

    [34] =  { key = "ArrayServiceCel10", type = "ASCII/1", },

    [35] =  { key = "ArrayServiceCel11", type = "ASCII/1", },

    [36] =  { key = "ArrayServiceCel12", type = "ASCII/1", },

    [37] =  { key = "ArrayServiceCel13", type = "ASCII/1", },

    [38] =  { key = "ArrayServiceCel14", type = "ASCII/1", },

    [39] =  { key = "u8warnTotal", type = "U8", },

    [40] =  { key = "codeErrProt1", type = "ASCII/5", },

    [41] =  { key = "warnAddress1", type = "U8", },

    [42] =  { key = "warnHour1", type = "U8", },

    [43] =  { key = "warnMin1", type = "U8", },

    [44] =  { key = "warnYear1", type = "U8", },

    [45] =  { key = "warnMonth1", type = "U8", },

    [46] =  { key = "warnDate1", type = "U8", },

    [47] =  { key = "codeErrProt2", type = "ASCII/5", },

    [48] =  { key = "warnAddress2", type = "U8", },

    [49] =  { key = "warnHour2", type = "U8", },

    [50] =  { key = "warnMin2", type = "U8", },

    [51] =  { key = "warnYear2", type = "U8", },

    [52] =  { key = "warnMonth2", type = "U8", },

    [53] =  { key = "warnDate2", type = "U8", },

    [54] =  { key = "codeErrProt3", type = "ASCII/5", },

    [55] =  { key = "warnAddress3", type = "U8", },

    [56] =  { key = "warnHour3", type = "U8", },

    [57] =  { key = "warnMin3", type = "U8", },

    [58] =  { key = "warnYear3", type = "U8", },

    [59] =  { key = "warnMonth3", type = "U8", },

    [60] =  { key = "warnDate3", type = "U8", },

    [61] =  { key = "codeErrProt4", type = "ASCII/5", },

    [62] =  { key = "warnAddress4", type = "U8", },

    [63] =  { key = "warnHour4", type = "U8", },

    [64] =  { key = "warnMin4", type = "U8", },

    [65] =  { key = "warnYear4", type = "U8", },

    [66] =  { key = "warnMonth4", type = "U8", },

    [67] =  { key = "warnDate4", type = "U8", },

    [68] =  { key = "codeErrProt5", type = "ASCII/5", },

    [69] =  { key = "warnAddress5", type = "U8", },

    [70] =  { key = "warnHour5", type = "U8", },

    [71] =  { key = "warnMin5", type = "U8", },

    [72] =  { key = "warnYear5", type = "U8", },

    [73] =  { key = "warnMonth5", type = "U8", },

    [74] =  { key = "warnDate5", type = "U8", },

    [75] =  { key = "codeErrProt6", type = "ASCII/5", },

    [76] =  { key = "warnAddress6", type = "U8", },

    [77] =  { key = "warnHour6", type = "U8", },

    [78] =  { key = "warnMin6", type = "U8", },

    [79] =  { key = "warnYear6", type = "U8", },

    [80] =  { key = "warnMonth6", type = "U8", },

    [81] =  { key = "warnDate6", type = "U8", },

    [82] =  { key = "codeErrStr1", type = "ASCII/12", },

    [83] =  { key = "codeErrStr2", type = "ASCII/12", },

    [84] =  { key = "codeErrStr3", type = "ASCII/12", },

    [85] =  { key = "codeErrStr4", type = "ASCII/12", },

    [86] =  { key = "codeErrStr5", type = "ASCII/12", },

    [87] =  { key = "codeErrStr6", type = "ASCII/12", },

}



local cmd_20B0 = {

    [0] =  { key = "compRunFreq", type = "U8", from = "odu", },

    [1] =  { key = "unitModeRun", type = "U8", type2 = "UnitMode", from = "idu", },

    [2] =  { key = "fanSpeed", type = "U16", from = "odu", },

    [3] =  { key = "machVersion", type = "U8", from = "idu", },

    [4] =  { key = "fgCapacityNeed", type = "U8", type2 = "OnOff", from = "idu", },

    [5] =  { key = "tempT3", type = "U16", type2 = "Temp", from = "idu", },

    [6] =  { key = "tempT4", type = "U16", type2 = "Temp", from = "idu", },

    [7] =  { key = "tempTp", type = "U16", type2 = "Temp", from = "idu", },

    [8] =  { key = "tempTwin", type = "U16", type2 = "Temp", from = "idu", },

    [9] =  { key = "tempTwout", type = "U16", type2 = "Temp", from = "idu", },

    [10] =  { key = "tempTsolar", type = "U16", type2 = "Temp", from = "idu", },

    [11] =  { key = "hydboxSubtype", type = "U8", from = "idu", },

    [12] =  { key = "fgUSBInfoConnect", type = "U8", from = "idu", },

    [13] =  { key = "usbIndexMax", type = "U8", from = "idu", },

    [14] =  { key = "p6ErrCode", type = "U16", from = "idu", },

    [15] =  { key = "oduCompCurrent", type = "U16", from = "odu", },

    [16] =  { key = "oduVoltage", type = "U16", from = "odu", },

    [17] =  { key = "exvCurrent", type = "U16", from = "odu", },

    [18] =  { key = "oduModel", type = "U8", from = "odu", },

    [19] =  { key = "unitonlineNum", type = "U8", from = "idu", },

    [20] =  { key = "currentCode", type = "U8", from = "idu", },

    [21] =  { key = "u8Code1", type = "U8", from = "idu", },

    [22] =  { key = "u8Code2", type = "U8", from = "idu", },

    [23] =  { key = "u8Code3", type = "U8", from = "idu", },

    [24] =  { key = "fgReqParaSet", type = "U8", type2 = "OnOff", from = "idu", },

    [25] =  { key = "fgReqVerAsk", type = "U8", type2 = "OnOff", from = "idu", },

    [26] =  { key = "fgReqSNAsk", type = "U8", type2 = "OnOff", from = "idu", },

    [27] =  { key = "fgUnitLockSignal", type = "U8", type2 = "OnOff", from = "idu", },

    [28] =  { key = "fgEVUSignal", type = "U8", type2 = "OnOff", from = "idu", },

    [29] =  { key = "fgSGSignal", type = "U8", type2 = "OnOff", from = "idu", },

    [30] =  { key = "fgTankAntiFreeze", type = "U8", type2 = "OnOff", from = "idu", },

    [31] =  { key = "fgSolarInput", type = "U8", type2 = "OnOff", from = "idu", },

    [32] =  { key = "fgRoomTherCoolRun", type = "U8", type2 = "OnOff", from = "idu", },

    [33] =  { key = "fgRoomTherHeatRun", type = "U8", type2 = "OnOff", from = "idu", },

    [34] =  { key = "fgOutDoorTestMode", type = "U8", type2 = "OnOff", from = "idu", },

    [35] =  { key = "fgRemoteOnOff", type = "U8", type2 = "OnOff", from = "idu", },

    [36] =  { key = "fgBackOil", type = "U8", type2 = "OnOff", from = "idu", },

    [37] =  { key = "fgAntiFreezeRun", type = "U8", type2 = "OnOff", from = "idu", },

    [38] =  { key = "fgDefrost", type = "U8", type2 = "OnOff", from = "idu", },

    [39] =  { key = "fgIsSlaveUnit", type = "U8", type2 = "OnOff", from = "idu", },

    [40] =  { key = "fgTBHEnable", type = "U8", type2 = "OnOff", from = "idu", },

    [41] =  { key = "fgAHSIsOwn", type = "U8", type2 = "OnOff", from = "idu", },

    [42] =  { key = "fgCapTestEnable", type = "U8", type2 = "OnOff", from = "idu", },

    [43] =  { key = "fgT1BSensorEnable", type = "U8", type2 = "OnOff", from = "idu", },

    [44] =  { key = "fgAHSDHWMode", type = "U8", from = "idu", },

    [45] =  { key = "fgIBH1Enable", type = "U8", type2 = "OnOff", from = "idu", },

    [46] =  { key = "fgT1SensorEnable", type = "U8", type2 = "OnOff", from = "idu", },

    [47] =  { key = "fgEdgeVersionType", type = "U8", from = "idu", },

    [48] =  { key = "fgFactReqTherHeatOn", type = "U8", type2 = "OnOff", from = "idu", },

    [49] =  { key = "fgDHWRun", type = "U8", type2 = "OnOff", from = "idu", },

    [50] =  { key = "fgHeatRun", type = "U8", type2 = "OnOff", from = "idu", },

    [51] =  { key = "fgCoolRun", type = "U8", type2 = "OnOff", from = "idu", },

    [52] =  { key = "fgFactReqTherCoolOn", type = "U8", type2 = "OnOff", from = "idu", },

    [53] =  { key = "fgFactReqSolarOn", type = "U8", type2 = "OnOff", from = "idu", },

    [54] =  { key = "fgFactoryRun", type = "U8", type2 = "OnOff", from = "idu", },

    [55] =  { key = "fgDefValveOn", type = "U8", type2 = "OnOff", from = "idu", },

    [56] =  { key = "fgAHSValveOn", type = "U8", type2 = "OnOff", from = "idu", },

    [57] =  { key = "fgRunValveOn", type = "U8", type2 = "OnOff", from = "idu", },

    [58] =  { key = "fgAlmValveOn", type = "U8", type2 = "OnOff", from = "idu", },

    [59] =  { key = "fgPumpSolarOn", type = "U8", type2 = "OnOff", from = "idu", },

    [60] =  { key = "fgHeat4ValveOn", type = "U8", type2 = "OnOff", from = "idu", },

    [61] =  { key = "fgSV3Output", type = "U8", type2 = "OnOff", from = "idu", },

    [62] =  { key = "fgMixedPumpValveOn", type = "U8", type2 = "OnOff", from = "idu", },

    [63] =  { key = "fgPumpDHWOn", type = "U8", type2 = "OnOff", from = "idu", },

    [64] =  { key = "fgPumpOOn", type = "U8", type2 = "OnOff", from = "idu", },

    [65] =  { key = "fgSV2On", type = "U8", type2 = "OnOff", from = "idu", },

    [66] =  { key = "fgSV1On", type = "U8", type2 = "OnOff", from = "idu", },

    [67] =  { key = "fgPumpIOutput", type = "U8", type2 = "OnOff", from = "idu", },

    [68] =  { key = "fgTBHOutput", type = "U8", type2 = "OnOff", from = "idu", },

    [69] =  { key = "fgIBH2Output", type = "U8", type2 = "OnOff", from = "idu", },

    [70] =  { key = "fgIBH1Output", type = "U8", type2 = "OnOff", from = "idu", },

    [71] =  { key = "tempT1", type = "U16", type2 = "Temp", from = "idu", },

    [72] =  { key = "tempTw2", type = "U16", type2 = "Temp", from = "idu", },

    [73] =  { key = "tempT2", type = "U16", type2 = "Temp", from = "idu", },

    [74] =  { key = "tempT2b", type = "U16", type2 = "Temp", from = "idu", },

    [75] =  { key = "tempT5", type = "U16", type2 = "Temp", from = "idu", },

    [76] =  { key = "tempTa", type = "U16", type2 = "Temp", from = "idu", },

    [77] =  { key = "tempTbt1", type = "U16", type2 = "Temp", from = "idu", },

    [78] =  { key = "tempTbt2", type = "U16", type2 = "Temp", from = "idu", },

    [79] =  { key = "hydroboxCapacity", type = "U8", from = "idu", },

    [80] =  { key = "pressureHigh", type = "U16", from = "idu", },

    [81] =  { key = "pressureLow", type = "U16", from = "idu", },

    [82] =  { key = "tempTh", type = "U16", type2 = "Temp", from = "idu", },

    [83] =  { key = "machineType", type = "U8", from = "idu", },

    [84] =  { key = "oduTargetFre", type = "U8", from = "odu", from = "idu", },

    [85] =  { key = "dcCurrent", type = "U8", from = "idu", },

    [86] =  { key = "dcVoltage", type = "U8", from = "idu", },

    [87] =  { key = "tempTf", type = "U16", type2 = "Temp", from = "idu", },

    [88] =  { key = "iduT1s1", type = "U16", type2 = "Temp", from = "idu", },

    [89] =  { key = "iduT1s2", type = "U16", type2 = "Temp", from = "idu", },

    [90] =  { key = "waterFlow", type = "U16", from = "idu", type2 = "0.01" },

    [91] =  { key = "oduPlanVolLmt", type = "U16", from = "odu", },

    [92] =  { key = "currentUnitCapacity", type = "U16", from = "idu", },

    [93] =  { key = "spheraAHSVoltage", type = "U16", from = "idu", },

    [94] =  { key = "tempT4Aver", type = "U16", type2 = "Temp", from = "idu", },

    [95] =  { key = "waterPressure", type = "U16", from = "idu", type2 = "0.1", },

    [96] =  { key = "roomRelHum", type = "U16", from = "idu", },

    [97] =  { key = "pwmPumpOut", type = "U8", from = "idu", },

    [98] =  { key = "totalelectricity0", type = "U32", from = "idu", },

    [99] =  { key = "totalthermal0", type = "U32", from = "idu", },

    [100] =  { key = "heatElecTotConsum0", type = "U32", from = "idu", },

    [101] =  { key = "heatTotCapacity0", type = "U32", from = "idu", },

    [102] =  { key = "instantPower0", type = "U32", from = "idu", },

    [103] =  { key = "instantRenewPower0", type = "U32", from = "idu", },

    [104] =  { key = "totalRenewPower0", type = "U32", from = "idu", },

    [105] =  { key = "tempT9i", type = "U16", type2 = "Temp", from = "idu", },

    [106] =  { key = "tempT9o", type = "U16", type2 = "Temp", from = "idu", },

    [107] =  { key = "exv2Current", type = "U16", from = "odu", },

    [108] =  { key = "exv3Current", type = "U16", from = "odu", },

}





local cmd_20B1 = {

    [0] =  { key = "iduVersionNum", type = "U8", from = "idu", },

    [1] =  { key = "oduVersionNum", type = "U8", from = "odu", },

    [2] =  { key = "iduSNCode0", type = "ASCII/1", from = "idu", },

    [3] =  { key = "iduSNCode1", type = "ASCII/1", from = "idu", },

    [4] =  { key = "iduSNCode2", type = "ASCII/1", from = "idu", },

    [5] =  { key = "iduSNCode3", type = "ASCII/1", from = "idu", },

    [6] =  { key = "iduSNCode4", type = "ASCII/1", from = "idu", },

    [7] =  { key = "iduSNCode5", type = "ASCII/1", from = "idu", },

    [8] =  { key = "iduSNCode6", type = "ASCII/1", from = "idu", },

    [9] =  { key = "iduSNCode7", type = "ASCII/1", from = "idu", },

    [10] =  { key = "iduSNCode8", type = "ASCII/1", from = "idu", },

    [11] =  { key = "iduSNCode9", type = "ASCII/1", from = "idu", },

    [12] =  { key = "iduSNCode10", type = "ASCII/1", from = "idu", },

    [13] =  { key = "iduSNCode11", type = "ASCII/1", from = "idu", },

    [14] =  { key = "iduSNCode12", type = "ASCII/1", from = "idu", },

    [15] =  { key = "iduSNCode13", type = "ASCII/1", from = "idu", },

    [16] =  { key = "iduSNCode14", type = "ASCII/1", from = "idu", },

    [17] =  { key = "iduSNCode15", type = "ASCII/1", from = "idu", },

    [18] =  { key = "iduSNCode16", type = "ASCII/1", from = "idu", },

    [19] =  { key = "iduSNCode17", type = "ASCII/1", from = "idu", },

    [20] =  { key = "iduSNCode18", type = "ASCII/1", from = "idu", },

    [21] =  { key = "iduSNCode19", type = "ASCII/1", from = "idu", },

    [22] =  { key = "iduSNCode20", type = "ASCII/1", from = "idu", },

    [23] =  { key = "iduSNCode21", type = "ASCII/1", from = "idu", },

    [24] =  { key = "iduSNCode22", type = "ASCII/1", from = "idu", },

    [25] =  { key = "iduSNCode23", type = "ASCII/1", from = "idu", },

    [26] =  { key = "iduSNCode24", type = "ASCII/1", from = "idu", },

    [27] =  { key = "iduSNCode25", type = "ASCII/1", from = "idu", },

    [28] =  { key = "iduSNCode26", type = "ASCII/1", from = "idu", },

    [29] =  { key = "iduSNCode27", type = "ASCII/1", from = "idu", },

    [30] =  { key = "iduSNCode28", type = "ASCII/1", from = "idu", },

    [31] =  { key = "iduSNCode29", type = "ASCII/1", from = "idu", },

    [32] =  { key = "iduSNCode30", type = "ASCII/1", from = "idu", },

    [33] =  { key = "iduSNCode31", type = "ASCII/1", from = "idu", },

    [34] =  { key = "oduSNCode0", type = "ASCII/1", from = "odu", },

    [35] =  { key = "oduSNCode1", type = "ASCII/1", from = "odu", },

    [36] =  { key = "oduSNCode2", type = "ASCII/1", from = "odu", },

    [37] =  { key = "oduSNCode3", type = "ASCII/1", from = "odu", },

    [38] =  { key = "oduSNCode4", type = "ASCII/1", from = "odu", },

    [39] =  { key = "oduSNCode5", type = "ASCII/1", from = "odu", },

    [40] =  { key = "oduSNCode6", type = "ASCII/1", from = "odu", },

    [41] =  { key = "oduSNCode7", type = "ASCII/1", from = "odu", },

    [42] =  { key = "oduSNCode8", type = "ASCII/1", from = "odu", },

    [43] =  { key = "oduSNCode9", type = "ASCII/1", from = "odu", },

    [44] =  { key = "oduSNCode10", type = "ASCII/1", from = "odu", },

    [45] =  { key = "oduSNCode11", type = "ASCII/1", from = "odu", },

    [46] =  { key = "oduSNCode12", type = "ASCII/1", from = "odu", },

    [47] =  { key = "oduSNCode13", type = "ASCII/1", from = "odu", },

    [48] =  { key = "oduSNCode14", type = "ASCII/1", from = "odu", },

    [49] =  { key = "oduSNCode15", type = "ASCII/1", from = "odu", },

    [50] =  { key = "oduSNCode16", type = "ASCII/1", from = "odu", },

    [51] =  { key = "oduSNCode17", type = "ASCII/1", from = "odu", },

    [52] =  { key = "oduSNCode18", type = "ASCII/1", from = "odu", },

    [53] =  { key = "oduSNCode19", type = "ASCII/1", from = "odu", },

    [54] =  { key = "oduSNCode20", type = "ASCII/1", from = "odu", },

    [55] =  { key = "oduSNCode21", type = "ASCII/1", from = "odu", },

    [56] =  { key = "oduSNCode22", type = "ASCII/1", from = "odu", },

    [57] =  { key = "oduSNCode23", type = "ASCII/1", from = "odu", },

    [58] =  { key = "oduSNCode24", type = "ASCII/1", from = "odu", },

    [59] =  { key = "oduSNCode25", type = "ASCII/1", from = "odu", },

    [60] =  { key = "oduSNCode26", type = "ASCII/1", from = "odu", },

    [61] =  { key = "oduSNCode27", type = "ASCII/1", from = "odu", },

    [62] =  { key = "oduSNCode28", type = "ASCII/1", from = "odu", },

    [63] =  { key = "oduSNCode29", type = "ASCII/1", from = "odu", },

    [64] =  { key = "oduSNCode30", type = "ASCII/1", from = "odu", },

    [65] =  { key = "oduSNCode31", type = "ASCII/1", from = "odu", },

    [66] =  { key = "hmiSNCode0", type = "ASCII/1", },

    [67] =  { key = "hmiSNCode1", type = "ASCII/1", },

    [68] =  { key = "hmiSNCode2", type = "ASCII/1", },

    [69] =  { key = "hmiSNCode3", type = "ASCII/1", },

    [70] =  { key = "hmiSNCode4", type = "ASCII/1", },

    [71] =  { key = "hmiSNCode5", type = "ASCII/1", },

    [72] =  { key = "hmiSNCode6", type = "ASCII/1", },

    [73] =  { key = "hmiSNCode7", type = "ASCII/1", },

    [74] =  { key = "hmiSNCode8", type = "ASCII/1", },

    [75] =  { key = "hmiSNCode9", type = "ASCII/1", },

    [76] =  { key = "hmiSNCode10", type = "ASCII/1", },

    [77] =  { key = "hmiSNCode11", type = "ASCII/1", },

    [78] =  { key = "hmiSNCode12", type = "ASCII/1", },

    [79] =  { key = "hmiSNCode13", type = "ASCII/1", },

    [80] =  { key = "hmiSNCode14", type = "ASCII/1", },

    [81] =  { key = "hmiSNCode15", type = "ASCII/1", },

    [82] =  { key = "hmiSNCode16", type = "ASCII/1", },

    [83] =  { key = "hmiSNCode17", type = "ASCII/1", },

    [84] =  { key = "hmiSNCode18", type = "ASCII/1", },

    [85] =  { key = "hmiSNCode19", type = "ASCII/1", },

    [86] =  { key = "hmiSNCode20", type = "ASCII/1", },

    [87] =  { key = "hmiSNCode21", type = "ASCII/1", },

    [88] =  { key = "hmiSNCode22", type = "ASCII/1", },

    [89] =  { key = "hmiSNCode23", type = "ASCII/1", },

    [90] =  { key = "hmiSNCode24", type = "ASCII/1", },

    [91] =  { key = "hmiSNCode25", type = "ASCII/1", },

    [92] =  { key = "hmiSNCode26", type = "ASCII/1", },

    [93] =  { key = "hmiSNCode27", type = "ASCII/1", },

    [94] =  { key = "hmiSNCode28", type = "ASCII/1", },

    [95] =  { key = "hmiSNCode29", type = "ASCII/1", },

    [96] =  { key = "hmiSNCode30", type = "ASCII/1", },

    [97] =  { key = "hmiSNCode31", type = "ASCII/1", },

    [98] =  { key = "oduVersionDate", type = "U16", from = "odu", },

    [99] =  { key = "iduVersionDate", type = "U16", from = "idu", },

}



local cmd_20D0 = {

    [0] =  { key = "dhw_weeklytimer_status", type = "U8", type2 = "OnOff", },

    [1] =  { key = "dhw_weeklytimer_schedule_num", type = "U8", },

    [2] =  { key = "dhw_weeklytimer_schedule_1_status", type = "U8", type2 = "OnOff", },

    [3] =  { key = "dhw_weeklytimer_schedule_2_status", type = "U8", type2 = "OnOff", },

    [4] =  { key = "dhw_weeklytimer_schedule_3_status", type = "U8", type2 = "OnOff", },

    [5] =  { key = "dhw_weeklytimer_schedule_4_status", type = "U8", type2 = "OnOff", },

    [6] =  { key = "dhw_weeklytimer_schedule_1_weekday", type = "U8", },

    [7] =  { key = "dhw_weeklytimer_schedule_1_timer_1_en", type = "U8", type2 = "OnOff", },

    [8] =  { key = "dhw_weeklytimer_schedule_1_timer_1_mode", type = "U8", type2 = "OnOff", },

    [9] =  { key = "dhw_weeklytimer_schedule_1_timer_1_temp", type = "U16", type2 = "Temp", },

    [10] =  { key = "dhw_weeklytimer_schedule_1_timer_1_starthour", type = "U8", },

    [11] =  { key = "dhw_weeklytimer_schedule_1_timer_1_startmin", type = "U8", },

    [12] =  { key = "dhw_weeklytimer_schedule_1_timer_2_en", type = "U8", type2 = "OnOff", },

    [13] =  { key = "dhw_weeklytimer_schedule_1_timer_2_mode", type = "U8", type2 = "OnOff", },

    [14] =  { key = "dhw_weeklytimer_schedule_1_timer_2_temp", type = "U16", type2 = "Temp", },

    [15] =  { key = "dhw_weeklytimer_schedule_1_timer_2_starthour", type = "U8", },

    [16] =  { key = "dhw_weeklytimer_schedule_1_timer_2_startmin", type = "U8", },

    [17] =  { key = "dhw_weeklytimer_schedule_1_timer_3_en", type = "U8", type2 = "OnOff", },

    [18] =  { key = "dhw_weeklytimer_schedule_1_timer_3_mode", type = "U8", type2 = "OnOff", },

    [19] =  { key = "dhw_weeklytimer_schedule_1_timer_3_temp", type = "U16", type2 = "Temp", },

    [20] =  { key = "dhw_weeklytimer_schedule_1_timer_3_starthour", type = "U8", },

    [21] =  { key = "dhw_weeklytimer_schedule_1_timer_3_startmin", type = "U8", },

    [22] =  { key = "dhw_weeklytimer_schedule_1_timer_4_en", type = "U8", type2 = "OnOff", },

    [23] =  { key = "dhw_weeklytimer_schedule_1_timer_4_mode", type = "U8", type2 = "OnOff", },

    [24] =  { key = "dhw_weeklytimer_schedule_1_timer_4_temp", type = "U16", type2 = "Temp", },

    [25] =  { key = "dhw_weeklytimer_schedule_1_timer_4_starthour", type = "U8", },

    [26] =  { key = "dhw_weeklytimer_schedule_1_timer_4_startmin", type = "U8", },

    [27] =  { key = "dhw_weeklytimer_schedule_2_weekday", type = "U8", },

    [28] =  { key = "dhw_weeklytimer_schedule_2_timer_1_en", type = "U8", type2 = "OnOff", },

    [29] =  { key = "dhw_weeklytimer_schedule_2_timer_1_mode", type = "U8", type2 = "OnOff", },

    [30] =  { key = "dhw_weeklytimer_schedule_2_timer_1_temp", type = "U16", type2 = "Temp", },

    [31] =  { key = "dhw_weeklytimer_schedule_2_timer_1_starthour", type = "U8", },

    [32] =  { key = "dhw_weeklytimer_schedule_2_timer_1_startmin", type = "U8", },

    [33] =  { key = "dhw_weeklytimer_schedule_2_timer_2_en", type = "U8", type2 = "OnOff", },

    [34] =  { key = "dhw_weeklytimer_schedule_2_timer_2_mode", type = "U8", type2 = "OnOff", },

    [35] =  { key = "dhw_weeklytimer_schedule_2_timer_2_temp", type = "U16", type2 = "Temp", },

    [36] =  { key = "dhw_weeklytimer_schedule_2_timer_2_starthour", type = "U8", },

    [37] =  { key = "dhw_weeklytimer_schedule_2_timer_2_startmin", type = "U8", },

    [38] =  { key = "dhw_weeklytimer_schedule_2_timer_3_en", type = "U8", type2 = "OnOff", },

    [39] =  { key = "dhw_weeklytimer_schedule_2_timer_3_mode", type = "U8", type2 = "OnOff", },

    [40] =  { key = "dhw_weeklytimer_schedule_2_timer_3_temp", type = "U16", type2 = "Temp", },

    [41] =  { key = "dhw_weeklytimer_schedule_2_timer_3_starthour", type = "U8", },

    [42] =  { key = "dhw_weeklytimer_schedule_2_timer_3_startmin", type = "U8", },

    [43] =  { key = "dhw_weeklytimer_schedule_2_timer_4_en", type = "U8", type2 = "OnOff", },

    [44] =  { key = "dhw_weeklytimer_schedule_2_timer_4_mode", type = "U8", type2 = "OnOff", },

    [45] =  { key = "dhw_weeklytimer_schedule_2_timer_4_temp", type = "U16", type2 = "Temp", },

    [46] =  { key = "dhw_weeklytimer_schedule_2_timer_4_starthour", type = "U8", },

    [47] =  { key = "dhw_weeklytimer_schedule_2_timer_4_startmin", type = "U8", },

    [48] =  { key = "dhw_weeklytimer_schedule_3_weekday", type = "U8", },

    [49] =  { key = "dhw_weeklytimer_schedule_3_timer_1_en", type = "U8", type2 = "OnOff", },

    [50] =  { key = "dhw_weeklytimer_schedule_3_timer_1_mode", type = "U8", type2 = "OnOff", },

    [51] =  { key = "dhw_weeklytimer_schedule_3_timer_1_temp", type = "U16", type2 = "Temp", },

    [52] =  { key = "dhw_weeklytimer_schedule_3_timer_1_starthour", type = "U8", },

    [53] =  { key = "dhw_weeklytimer_schedule_3_timer_1_startmin", type = "U8", },

    [54] =  { key = "dhw_weeklytimer_schedule_3_timer_2_en", type = "U8", type2 = "OnOff", },

    [55] =  { key = "dhw_weeklytimer_schedule_3_timer_2_mode", type = "U8", type2 = "OnOff", },

    [56] =  { key = "dhw_weeklytimer_schedule_3_timer_2_temp", type = "U16", type2 = "Temp", },

    [57] =  { key = "dhw_weeklytimer_schedule_3_timer_2_starthour", type = "U8", },

    [58] =  { key = "dhw_weeklytimer_schedule_3_timer_2_startmin", type = "U8", },

    [59] =  { key = "dhw_weeklytimer_schedule_3_timer_3_en", type = "U8", type2 = "OnOff", },

    [60] =  { key = "dhw_weeklytimer_schedule_3_timer_3_mode", type = "U8", type2 = "OnOff", },

    [61] =  { key = "dhw_weeklytimer_schedule_3_timer_3_temp", type = "U16", type2 = "Temp", },

    [62] =  { key = "dhw_weeklytimer_schedule_3_timer_3_starthour", type = "U8", },

    [63] =  { key = "dhw_weeklytimer_schedule_3_timer_3_startmin", type = "U8", },

    [64] =  { key = "dhw_weeklytimer_schedule_3_timer_4_en", type = "U8", type2 = "OnOff", },

    [65] =  { key = "dhw_weeklytimer_schedule_3_timer_4_mode", type = "U8", type2 = "OnOff", },

    [66] =  { key = "dhw_weeklytimer_schedule_3_timer_4_temp", type = "U16", type2 = "Temp", },

    [67] =  { key = "dhw_weeklytimer_schedule_3_timer_4_starthour", type = "U8", },

    [68] =  { key = "dhw_weeklytimer_schedule_3_timer_4_startmin", type = "U8", },

    [69] =  { key = "dhw_weeklytimer_schedule_4_weekday", type = "U8", },

    [70] =  { key = "dhw_weeklytimer_schedule_4_timer_1_en", type = "U8", type2 = "OnOff", },

    [71] =  { key = "dhw_weeklytimer_schedule_4_timer_1_mode", type = "U8", type2 = "OnOff", },

    [72] =  { key = "dhw_weeklytimer_schedule_4_timer_1_temp", type = "U16", type2 = "Temp", },

    [73] =  { key = "dhw_weeklytimer_schedule_4_timer_1_starthour", type = "U8", },

    [74] =  { key = "dhw_weeklytimer_schedule_4_timer_1_startmin", type = "U8", },

    [75] =  { key = "dhw_weeklytimer_schedule_4_timer_2_en", type = "U8", type2 = "OnOff", },

    [76] =  { key = "dhw_weeklytimer_schedule_4_timer_2_mode", type = "U8", type2 = "OnOff", },

    [77] =  { key = "dhw_weeklytimer_schedule_4_timer_2_temp", type = "U16", type2 = "Temp", },

    [78] =  { key = "dhw_weeklytimer_schedule_4_timer_2_starthour", type = "U8", },

    [79] =  { key = "dhw_weeklytimer_schedule_4_timer_2_startmin", type = "U8", },

    [80] =  { key = "dhw_weeklytimer_schedule_4_timer_3_en", type = "U8", type2 = "OnOff", },

    [81] =  { key = "dhw_weeklytimer_schedule_4_timer_3_mode", type = "U8", type2 = "OnOff", },

    [82] =  { key = "dhw_weeklytimer_schedule_4_timer_3_temp", type = "U16", type2 = "Temp", },

    [83] =  { key = "dhw_weeklytimer_schedule_4_timer_3_starthour", type = "U8", },

    [84] =  { key = "dhw_weeklytimer_schedule_4_timer_3_startmin", type = "U8", },

    [85] =  { key = "dhw_weeklytimer_schedule_4_timer_4_en", type = "U8", type2 = "OnOff", },

    [86] =  { key = "dhw_weeklytimer_schedule_4_timer_4_mode", type = "U8", type2 = "OnOff", },

    [87] =  { key = "dhw_weeklytimer_schedule_4_timer_4_temp", type = "U16", type2 = "Temp", },

    [88] =  { key = "dhw_weeklytimer_schedule_4_timer_4_starthour", type = "U8", },

    [89] =  { key = "dhw_weeklytimer_schedule_4_timer_4_startmin", type = "U8", },

}



local cmd_20E0 = {

    [0] =  { key = "zone1_weeklytimer_status", type = "U8", type2 = "OnOff", },

    [1] =  { key = "zone1_weeklytimer_schedule_num", type = "U8", },

    [2] =  { key = "zone1_weeklytimer_schedule_1_status", type = "U8", type2 = "OnOff", },

    [3] =  { key = "zone1_weeklytimer_schedule_2_status", type = "U8", type2 = "OnOff", },

    [4] =  { key = "zone1_weeklytimer_schedule_3_status", type = "U8", type2 = "OnOff", },

    [5] =  { key = "zone1_weeklytimer_schedule_4_status", type = "U8", type2 = "OnOff", },

    [6] =  { key = "zone1_weeklytimer_schedule_1_weekday", type = "U8", },

    [7] =  { key = "zone1_weeklytimer_schedule_1_timer_1_en", type = "U8", type2 = "OnOff", },

    [8] =  { key = "zone1_weeklytimer_schedule_1_timer_1_mode", type = "U8", type2 = "IduMode", },

    [9] =  { key = "zone1_weeklytimer_schedule_1_timer_1_temp", type = "U16", type2 = "Temp", },

    [10] =  { key = "zone1_weeklytimer_schedule_1_timer_1_starthour", type = "U8", },

    [11] =  { key = "zone1_weeklytimer_schedule_1_timer_1_startmin", type = "U8", },

    [12] =  { key = "zone1_weeklytimer_schedule_1_timer_2_en", type = "U8", type2 = "OnOff", },

    [13] =  { key = "zone1_weeklytimer_schedule_1_timer_2_mode", type = "U8", type2 = "IduMode", },

    [14] =  { key = "zone1_weeklytimer_schedule_1_timer_2_temp", type = "U16", type2 = "Temp", },

    [15] =  { key = "zone1_weeklytimer_schedule_1_timer_2_starthour", type = "U8", },

    [16] =  { key = "zone1_weeklytimer_schedule_1_timer_2_startmin", type = "U8", },

    [17] =  { key = "zone1_weeklytimer_schedule_1_timer_3_en", type = "U8", type2 = "OnOff", },

    [18] =  { key = "zone1_weeklytimer_schedule_1_timer_3_mode", type = "U8", type2 = "IduMode", },

    [19] =  { key = "zone1_weeklytimer_schedule_1_timer_3_temp", type = "U16", type2 = "Temp", },

    [20] =  { key = "zone1_weeklytimer_schedule_1_timer_3_starthour", type = "U8", },

    [21] =  { key = "zone1_weeklytimer_schedule_1_timer_3_startmin", type = "U8", },

    [22] =  { key = "zone1_weeklytimer_schedule_1_timer_4_en", type = "U8", type2 = "OnOff", },

    [23] =  { key = "zone1_weeklytimer_schedule_1_timer_4_mode", type = "U8", type2 = "IduMode", },

    [24] =  { key = "zone1_weeklytimer_schedule_1_timer_4_temp", type = "U16", type2 = "Temp", },

    [25] =  { key = "zone1_weeklytimer_schedule_1_timer_4_starthour", type = "U8", },

    [26] =  { key = "zone1_weeklytimer_schedule_1_timer_4_startmin", type = "U8", },

    [27] =  { key = "zone1_weeklytimer_schedule_2_weekday", type = "U8", },

    [28] =  { key = "zone1_weeklytimer_schedule_2_timer_1_en", type = "U8", type2 = "OnOff", },

    [29] =  { key = "zone1_weeklytimer_schedule_2_timer_1_mode", type = "U8", type2 = "IduMode", },

    [30] =  { key = "zone1_weeklytimer_schedule_2_timer_1_temp", type = "U16", type2 = "Temp", },

    [31] =  { key = "zone1_weeklytimer_schedule_2_timer_1_starthour", type = "U8", },

    [32] =  { key = "zone1_weeklytimer_schedule_2_timer_1_startmin", type = "U8", },

    [33] =  { key = "zone1_weeklytimer_schedule_2_timer_2_en", type = "U8", type2 = "OnOff", },

    [34] =  { key = "zone1_weeklytimer_schedule_2_timer_2_mode", type = "U8", type2 = "IduMode", },

    [35] =  { key = "zone1_weeklytimer_schedule_2_timer_2_temp", type = "U16", type2 = "Temp", },

    [36] =  { key = "zone1_weeklytimer_schedule_2_timer_2_starthour", type = "U8", },

    [37] =  { key = "zone1_weeklytimer_schedule_2_timer_2_startmin", type = "U8", },

    [38] =  { key = "zone1_weeklytimer_schedule_2_timer_3_en", type = "U8", type2 = "OnOff", },

    [39] =  { key = "zone1_weeklytimer_schedule_2_timer_3_mode", type = "U8", type2 = "IduMode", },

    [40] =  { key = "zone1_weeklytimer_schedule_2_timer_3_temp", type = "U16", type2 = "Temp", },

    [41] =  { key = "zone1_weeklytimer_schedule_2_timer_3_starthour", type = "U8", },

    [42] =  { key = "zone1_weeklytimer_schedule_2_timer_3_startmin", type = "U8", },

    [43] =  { key = "zone1_weeklytimer_schedule_2_timer_4_en", type = "U8", type2 = "OnOff", },

    [44] =  { key = "zone1_weeklytimer_schedule_2_timer_4_mode", type = "U8", type2 = "IduMode", },

    [45] =  { key = "zone1_weeklytimer_schedule_2_timer_4_temp", type = "U16", type2 = "Temp", },

    [46] =  { key = "zone1_weeklytimer_schedule_2_timer_4_starthour", type = "U8", },

    [47] =  { key = "zone1_weeklytimer_schedule_2_timer_4_startmin", type = "U8", },

    [48] =  { key = "zone1_weeklytimer_schedule_3_weekday", type = "U8", },

    [49] =  { key = "zone1_weeklytimer_schedule_3_timer_1_en", type = "U8", type2 = "OnOff", },

    [50] =  { key = "zone1_weeklytimer_schedule_3_timer_1_mode", type = "U8", type2 = "IduMode", },

    [51] =  { key = "zone1_weeklytimer_schedule_3_timer_1_temp", type = "U16", type2 = "Temp", },

    [52] =  { key = "zone1_weeklytimer_schedule_3_timer_1_starthour", type = "U8", },

    [53] =  { key = "zone1_weeklytimer_schedule_3_timer_1_startmin", type = "U8", },

    [54] =  { key = "zone1_weeklytimer_schedule_3_timer_2_en", type = "U8", type2 = "OnOff", },

    [55] =  { key = "zone1_weeklytimer_schedule_3_timer_2_mode", type = "U8", type2 = "IduMode", },

    [56] =  { key = "zone1_weeklytimer_schedule_3_timer_2_temp", type = "U16", type2 = "Temp", },

    [57] =  { key = "zone1_weeklytimer_schedule_3_timer_2_starthour", type = "U8", },

    [58] =  { key = "zone1_weeklytimer_schedule_3_timer_2_startmin", type = "U8", },

    [59] =  { key = "zone1_weeklytimer_schedule_3_timer_3_en", type = "U8", type2 = "OnOff", },

    [60] =  { key = "zone1_weeklytimer_schedule_3_timer_3_mode", type = "U8", type2 = "IduMode", },

    [61] =  { key = "zone1_weeklytimer_schedule_3_timer_3_temp", type = "U16", type2 = "Temp", },

    [62] =  { key = "zone1_weeklytimer_schedule_3_timer_3_starthour", type = "U8", },

    [63] =  { key = "zone1_weeklytimer_schedule_3_timer_3_startmin", type = "U8", },

    [64] =  { key = "zone1_weeklytimer_schedule_3_timer_4_en", type = "U8", type2 = "OnOff", },

    [65] =  { key = "zone1_weeklytimer_schedule_3_timer_4_mode", type = "U8", type2 = "IduMode", },

    [66] =  { key = "zone1_weeklytimer_schedule_3_timer_4_temp", type = "U16", type2 = "Temp", },

    [67] =  { key = "zone1_weeklytimer_schedule_3_timer_4_starthour", type = "U8", },

    [68] =  { key = "zone1_weeklytimer_schedule_3_timer_4_startmin", type = "U8", },

    [69] =  { key = "zone1_weeklytimer_schedule_4_weekday", type = "U8", },

    [70] =  { key = "zone1_weeklytimer_schedule_4_timer_1_en", type = "U8", type2 = "OnOff", },

    [71] =  { key = "zone1_weeklytimer_schedule_4_timer_1_mode", type = "U8", type2 = "IduMode", },

    [72] =  { key = "zone1_weeklytimer_schedule_4_timer_1_temp", type = "U16", type2 = "Temp", },

    [73] =  { key = "zone1_weeklytimer_schedule_4_timer_1_starthour", type = "U8", },

    [74] =  { key = "zone1_weeklytimer_schedule_4_timer_1_startmin", type = "U8", },

    [75] =  { key = "zone1_weeklytimer_schedule_4_timer_2_en", type = "U8", type2 = "OnOff", },

    [76] =  { key = "zone1_weeklytimer_schedule_4_timer_2_mode", type = "U8", type2 = "IduMode", },

    [77] =  { key = "zone1_weeklytimer_schedule_4_timer_2_temp", type = "U16", type2 = "Temp", },

    [78] =  { key = "zone1_weeklytimer_schedule_4_timer_2_starthour", type = "U8", },

    [79] =  { key = "zone1_weeklytimer_schedule_4_timer_2_startmin", type = "U8", },

    [80] =  { key = "zone1_weeklytimer_schedule_4_timer_3_en", type = "U8", type2 = "OnOff", },

    [81] =  { key = "zone1_weeklytimer_schedule_4_timer_3_mode", type = "U8", type2 = "IduMode", },

    [82] =  { key = "zone1_weeklytimer_schedule_4_timer_3_temp", type = "U16", type2 = "Temp", },

    [83] =  { key = "zone1_weeklytimer_schedule_4_timer_3_starthour", type = "U8", },

    [84] =  { key = "zone1_weeklytimer_schedule_4_timer_3_startmin", type = "U8", },

    [85] =  { key = "zone1_weeklytimer_schedule_4_timer_4_en", type = "U8", type2 = "OnOff", },

    [86] =  { key = "zone1_weeklytimer_schedule_4_timer_4_mode", type = "U8", type2 = "IduMode", },

    [87] =  { key = "zone1_weeklytimer_schedule_4_timer_4_temp", type = "U16", type2 = "Temp", },

    [88] =  { key = "zone1_weeklytimer_schedule_4_timer_4_starthour", type = "U8", },

    [89] =  { key = "zone1_weeklytimer_schedule_4_timer_4_startmin", type = "U8", },

}





local cmd_20F0 = {

    [0] =  { key = "zone2_weeklytimer_status", type = "U8", type2 = "OnOff", },

    [1] =  { key = "zone2_weeklytimer_schedule_num", type = "U8", },

    [2] =  { key = "zone2_weeklytimer_schedule_1_status", type = "U8", type2 = "OnOff", },

    [3] =  { key = "zone2_weeklytimer_schedule_2_status", type = "U8", type2 = "OnOff", },

    [4] =  { key = "zone2_weeklytimer_schedule_3_status", type = "U8", type2 = "OnOff", },

    [5] =  { key = "zone2_weeklytimer_schedule_4_status", type = "U8", type2 = "OnOff", },

    [6] =  { key = "zone2_weeklytimer_schedule_1_weekday", type = "U8", },

    [7] =  { key = "zone2_weeklytimer_schedule_1_timer_1_en", type = "U8", type2 = "OnOff", },

    [8] =  { key = "zone2_weeklytimer_schedule_1_timer_1_mode", type = "U8", type2 = "IduMode", },

    [9] =  { key = "zone2_weeklytimer_schedule_1_timer_1_temp", type = "U16", type2 = "Temp", },

    [10] =  { key = "zone2_weeklytimer_schedule_1_timer_1_starthour", type = "U8", },

    [11] =  { key = "zone2_weeklytimer_schedule_1_timer_1_startmin", type = "U8", },

    [12] =  { key = "zone2_weeklytimer_schedule_1_timer_2_en", type = "U8", type2 = "OnOff", },

    [13] =  { key = "zone2_weeklytimer_schedule_1_timer_2_mode", type = "U8", type2 = "IduMode", },

    [14] =  { key = "zone2_weeklytimer_schedule_1_timer_2_temp", type = "U16", type2 = "Temp", },

    [15] =  { key = "zone2_weeklytimer_schedule_1_timer_2_starthour", type = "U8", },

    [16] =  { key = "zone2_weeklytimer_schedule_1_timer_2_startmin", type = "U8", },

    [17] =  { key = "zone2_weeklytimer_schedule_1_timer_3_en", type = "U8", type2 = "OnOff", },

    [18] =  { key = "zone2_weeklytimer_schedule_1_timer_3_mode", type = "U8", type2 = "IduMode", },

    [19] =  { key = "zone2_weeklytimer_schedule_1_timer_3_temp", type = "U16", type2 = "Temp", },

    [20] =  { key = "zone2_weeklytimer_schedule_1_timer_3_starthour", type = "U8", },

    [21] =  { key = "zone2_weeklytimer_schedule_1_timer_3_startmin", type = "U8", },

    [22] =  { key = "zone2_weeklytimer_schedule_1_timer_4_en", type = "U8", type2 = "OnOff", },

    [23] =  { key = "zone2_weeklytimer_schedule_1_timer_4_mode", type = "U8", type2 = "IduMode", },

    [24] =  { key = "zone2_weeklytimer_schedule_1_timer_4_temp", type = "U16", type2 = "Temp", },

    [25] =  { key = "zone2_weeklytimer_schedule_1_timer_4_starthour", type = "U8", },

    [26] =  { key = "zone2_weeklytimer_schedule_1_timer_4_startmin", type = "U8", },

    [27] =  { key = "zone2_weeklytimer_schedule_2_weekday", type = "U8", },

    [28] =  { key = "zone2_weeklytimer_schedule_2_timer_1_en", type = "U8", type2 = "OnOff", },

    [29] =  { key = "zone2_weeklytimer_schedule_2_timer_1_mode", type = "U8", type2 = "IduMode", },

    [30] =  { key = "zone2_weeklytimer_schedule_2_timer_1_temp", type = "U16", type2 = "Temp", },

    [31] =  { key = "zone2_weeklytimer_schedule_2_timer_1_starthour", type = "U8", },

    [32] =  { key = "zone2_weeklytimer_schedule_2_timer_1_startmin", type = "U8", },

    [33] =  { key = "zone2_weeklytimer_schedule_2_timer_2_en", type = "U8", type2 = "OnOff", },

    [34] =  { key = "zone2_weeklytimer_schedule_2_timer_2_mode", type = "U8", type2 = "IduMode", },

    [35] =  { key = "zone2_weeklytimer_schedule_2_timer_2_temp", type = "U16", type2 = "Temp", },

    [36] =  { key = "zone2_weeklytimer_schedule_2_timer_2_starthour", type = "U8", },

    [37] =  { key = "zone2_weeklytimer_schedule_2_timer_2_startmin", type = "U8", },

    [38] =  { key = "zone2_weeklytimer_schedule_2_timer_3_en", type = "U8", type2 = "OnOff", },

    [39] =  { key = "zone2_weeklytimer_schedule_2_timer_3_mode", type = "U8", type2 = "IduMode", },

    [40] =  { key = "zone2_weeklytimer_schedule_2_timer_3_temp", type = "U16", type2 = "Temp", },

    [41] =  { key = "zone2_weeklytimer_schedule_2_timer_3_starthour", type = "U8", },

    [42] =  { key = "zone2_weeklytimer_schedule_2_timer_3_startmin", type = "U8", },

    [43] =  { key = "zone2_weeklytimer_schedule_2_timer_4_en", type = "U8", type2 = "OnOff", },

    [44] =  { key = "zone2_weeklytimer_schedule_2_timer_4_mode", type = "U8", type2 = "IduMode", },

    [45] =  { key = "zone2_weeklytimer_schedule_2_timer_4_temp", type = "U16", type2 = "Temp", },

    [46] =  { key = "zone2_weeklytimer_schedule_2_timer_4_starthour", type = "U8", },

    [47] =  { key = "zone2_weeklytimer_schedule_2_timer_4_startmin", type = "U8", },

    [48] =  { key = "zone2_weeklytimer_schedule_3_weekday", type = "U8", },

    [49] =  { key = "zone2_weeklytimer_schedule_3_timer_1_en", type = "U8", type2 = "OnOff", },

    [50] =  { key = "zone2_weeklytimer_schedule_3_timer_1_mode", type = "U8", type2 = "IduMode", },

    [51] =  { key = "zone2_weeklytimer_schedule_3_timer_1_temp", type = "U16", type2 = "Temp", },

    [52] =  { key = "zone2_weeklytimer_schedule_3_timer_1_starthour", type = "U8", },

    [53] =  { key = "zone2_weeklytimer_schedule_3_timer_1_startmin", type = "U8", },

    [54] =  { key = "zone2_weeklytimer_schedule_3_timer_2_en", type = "U8", type2 = "OnOff", },

    [55] =  { key = "zone2_weeklytimer_schedule_3_timer_2_mode", type = "U8", type2 = "IduMode", },

    [56] =  { key = "zone2_weeklytimer_schedule_3_timer_2_temp", type = "U16", type2 = "Temp", },

    [57] =  { key = "zone2_weeklytimer_schedule_3_timer_2_starthour", type = "U8", },

    [58] =  { key = "zone2_weeklytimer_schedule_3_timer_2_startmin", type = "U8", },

    [59] =  { key = "zone2_weeklytimer_schedule_3_timer_3_en", type = "U8", type2 = "OnOff", },

    [60] =  { key = "zone2_weeklytimer_schedule_3_timer_3_mode", type = "U8", type2 = "IduMode", },

    [61] =  { key = "zone2_weeklytimer_schedule_3_timer_3_temp", type = "U16", type2 = "Temp", },

    [62] =  { key = "zone2_weeklytimer_schedule_3_timer_3_starthour", type = "U8", },

    [63] =  { key = "zone2_weeklytimer_schedule_3_timer_3_startmin", type = "U8", },

    [64] =  { key = "zone2_weeklytimer_schedule_3_timer_4_en", type = "U8", type2 = "OnOff", },

    [65] =  { key = "zone2_weeklytimer_schedule_3_timer_4_mode", type = "U8", type2 = "IduMode", },

    [66] =  { key = "zone2_weeklytimer_schedule_3_timer_4_temp", type = "U16", type2 = "Temp", },

    [67] =  { key = "zone2_weeklytimer_schedule_3_timer_4_starthour", type = "U8", },

    [68] =  { key = "zone2_weeklytimer_schedule_3_timer_4_startmin", type = "U8", },

    [69] =  { key = "zone2_weeklytimer_schedule_4_weekday", type = "U8", },

    [70] =  { key = "zone2_weeklytimer_schedule_4_timer_1_en", type = "U8", type2 = "OnOff", },

    [71] =  { key = "zone2_weeklytimer_schedule_4_timer_1_mode", type = "U8", type2 = "IduMode", },

    [72] =  { key = "zone2_weeklytimer_schedule_4_timer_1_temp", type = "U16", type2 = "Temp", },

    [73] =  { key = "zone2_weeklytimer_schedule_4_timer_1_starthour", type = "U8", },

    [74] =  { key = "zone2_weeklytimer_schedule_4_timer_1_startmin", type = "U8", },

    [75] =  { key = "zone2_weeklytimer_schedule_4_timer_2_en", type = "U8", type2 = "OnOff", },

    [76] =  { key = "zone2_weeklytimer_schedule_4_timer_2_mode", type = "U8", type2 = "IduMode", },

    [77] =  { key = "zone2_weeklytimer_schedule_4_timer_2_temp", type = "U16", type2 = "Temp", },

    [78] =  { key = "zone2_weeklytimer_schedule_4_timer_2_starthour", type = "U8", },

    [79] =  { key = "zone2_weeklytimer_schedule_4_timer_2_startmin", type = "U8", },

    [80] =  { key = "zone2_weeklytimer_schedule_4_timer_3_en", type = "U8", type2 = "OnOff", },

    [81] =  { key = "zone2_weeklytimer_schedule_4_timer_3_mode", type = "U8", type2 = "IduMode", },

    [82] =  { key = "zone2_weeklytimer_schedule_4_timer_3_temp", type = "U16", type2 = "Temp", },

    [83] =  { key = "zone2_weeklytimer_schedule_4_timer_3_starthour", type = "U8", },

    [84] =  { key = "zone2_weeklytimer_schedule_4_timer_3_startmin", type = "U8", },

    [85] =  { key = "zone2_weeklytimer_schedule_4_timer_4_en", type = "U8", type2 = "OnOff", },

    [86] =  { key = "zone2_weeklytimer_schedule_4_timer_4_mode", type = "U8", type2 = "IduMode", },

    [87] =  { key = "zone2_weeklytimer_schedule_4_timer_4_temp", type = "U16", type2 = "Temp", },

    [88] =  { key = "zone2_weeklytimer_schedule_4_timer_4_starthour", type = "U8", },

    [89] =  { key = "zone2_weeklytimer_schedule_4_timer_4_startmin", type = "U8", },

}





local cmd_2F10 = {

    [0] =  { key = "compRunFreq", type = "U8", from = "odu", },

    [1] =  { key = "fanSpeed", type = "U16", from = "odu", },

    [2] =  { key = "tempT3", type = "U16", type2 = "Temp", from = "idu", },

    [3] =  { key = "tempT4", type = "U16", type2 = "Temp", from = "idu", },

    [4] =  { key = "tempTp", type = "U16", type2 = "Temp", from = "idu", },

    [5] =  { key = "tempTwin", type = "U16", type2 = "Temp", from = "idu", },

    [6] =  { key = "tempTwout", type = "U16", type2 = "Temp", from = "idu", },

    [7] =  { key = "oduCompCurrent", type = "U16", from = "odu", },

    [8] =  { key = "oduVoltage", type = "U16", from = "odu", },

    [9] =  { key = "tempT1", type = "U16", type2 = "Temp", from = "idu", },

    [10] =  { key = "tempTw2", type = "U16", type2 = "Temp", from = "idu", },

    [11] =  { key = "tempT2", type = "U16", type2 = "Temp", from = "idu", },

    [12] =  { key = "tempT2b", type = "U16", type2 = "Temp", from = "idu", },

    [13] =  { key = "tempT5", type = "U16", type2 = "Temp", from = "idu", },

    [14] =  { key = "tempTa", type = "U16", type2 = "Temp", from = "idu", },

    [15] =  { key = "pressureHigh", type = "U16", from = "odu", },

    [16] =  { key = "pressureLow", type = "U16", from = "odu", },

    [17] =  { key = "tempTh", type = "U16", type2 = "Temp", from = "idu", },

    [18] =  { key = "oduTargetFre", type = "U8", from = "odu", },

    [19] =  { key = "tempTf", type = "U16", type2 = "Temp", from = "idu", },

    [20] =  { key = "iduT1s1", type = "U16", type2 = "Temp", from = "idu", },

    [21] =  { key = "iduT1s2", type = "U16", type2 = "Temp", from = "idu", },

    [22] =  { key = "waterFlow", type = "U16", from = "idu", type2 = "0.01" },

    [23] =  { key = "currentUnitCapacity", type = "U16", from = "idu", },

    [24] =  { key = "waterPressure", type = "U16", from = "idu", type2 = "0.1", },

    [25] =  { key = "roomRelHum", type = "U16", from = "idu", },

    [26] =  { key = "totalelectricity0", type = "U32", from = "idu", },

    [27] =  { key = "totalthermal0", type = "U32", from = "idu", },

    [28] =  { key = "heatElecTotConsum0", type = "U32", from = "idu", },

    [29] =  { key = "heatTotCapacity0", type = "U32", from = "idu", },

    [30] =  { key = "instantPower0", type = "U32", from = "idu", },

    [31] =  { key = "instantRenewPower0", type = "U32", from = "idu", },

    [32] =  { key = "totalRenewPower0", type = "U32", from = "idu", },

    [33] =  { key = "compRunTotalTime0", type = "U32", from = "idu", },

    [34] =  { key = "pwmPumpOut", type = "U8", from = "idu", },

    [35] =  { key = "run_mode_set", type = "U8", type2 = "IduMode", },

    [36] =  { key = "unitModeRun", type = "U8", type2 = "UnitMode", from = "idu", },

    [37] =  { key = "TempTl", type = "U16", type2 = "Temp", from = "odu", },

    [38] =  { key = "P1_calc", type = "U16", type2 = "Temp", from = "odu", },

    [39] =  { key = "P2_calc", type = "U16", type2 = "Temp", from = "odu", },

    [40] =  { key = "Tp_calc", type = "U16", type2 = "Temp", from = "idu", },

    [41] =  { key = "Th_calc", type = "U16", type2 = "Temp", from = "idu", },

    [42] =  { key = "T3_calc", type = "U16", type2 = "Temp", from = "idu", },

    [43] =  { key = "TL_calc", type = "U16", type2 = "Temp", from = "idu", },

    [44] =  { key = "T4_calc", type = "U16", type2 = "Temp", from = "idu", },

    [45] =  { key = "T2b_calc", type = "U16", type2 = "Temp", from = "idu", },

    [46] =  { key = "T2_calc", type = "U16", type2 = "Temp", from = "idu", },

    [47] =  { key = "Tw_in_calc", type = "U16", type2 = "Temp", from = "idu", },

    [48] =  { key = "Tw_out_calc", type = "U16", type2 = "Temp", from = "idu", },

    [49] =  { key = "Operation_status", type = "U8", type2 = "OnOff", from = "idu", },

    [50] =  { key = "Frequency_limited_type", type = "U8", from = "idu", },

    [51] =  { key = "Online_unit_number", type = "U8", from = "idu", },

    [52] =  { key = "ODU_model", type = "U8", from = "idu", },

    [53] =  { key = "Comp_run_time", type = "U32", from = "idu", },

    [54] =  { key = "Expansion_valve", type = "U16", from = "idu", },

    [55] =  { key = "Expansion_valve_2", type = "U16", from = "idu", },

    [56] =  { key = "T9i_temp", type = "U16", type2 = "Temp", from = "idu", },

    [57] =  { key = "T9o_temp", type = "U16", type2 = "Temp", from = "idu", },

    [58] =  { key = "T5_2_water_tank_temp", type = "U16", type2 = "Temp", from = "idu", },

    [59] =  { key = "TBt_buffer_tank_temp", type = "U16", type2 = "Temp", from = "idu", },

    [60] =  { key = "Tsolar", type = "U16", type2 = "Temp", from = "idu", },

    [61] =  { key = "DC_voltage", type = "U16", from = "idu", },

    [62] =  { key = "DC_current", type = "U16", type2 = "Current", from = "idu", },

    [63] =  { key = "SV1", type = "U8", type2 = "OnOff", from = "idu", },

    [64] =  { key = "SV2", type = "U8", type2 = "OnOff", from = "idu", },

    [65] =  { key = "SV3", type = "U8", type2 = "OnOff", from = "idu", },

    [66] =  { key = "Pump_I", type = "U8", type2 = "OnOff", from = "idu", },

    [67] =  { key = "Pump_O", type = "U8", type2 = "OnOff", from = "idu", },

    [68] =  { key = "Pump_C", type = "U8", type2 = "OnOff", from = "idu", },

    [69] =  { key = "Pump_S", type = "U8", type2 = "OnOff", from = "idu", },

    [70] =  { key = "Pump_D", type = "U8", type2 = "OnOff", from = "idu", },

    [71] =  { key = "IBH1", type = "U8", type2 = "OnOff", from = "idu", },

    [72] =  { key = "IBH2", type = "U8", type2 = "OnOff", from = "idu", },

    [73] =  { key = "TBH", type = "U8", type2 = "OnOff", from = "idu", },

    [74] =  { key = "AHS", type = "U8", type2 = "OnOff", from = "idu", },

    [75] =  { key = "Fan_total_run_time", type = "U32", from = "idu", },

    [76] =  { key = "Pump_I_total_run_time", type = "U32", from = "idu", },

    [77] =  { key = "IBH1_total_run_time", type = "U32", from = "idu", },

    [78] =  { key = "IBH2_total_run_time", type = "U32", from = "idu", },

    [79] =  { key = "TBH_total_run_time", type = "U32", from = "idu", },

    [80] =  { key = "AHS_total_run_time", type = "U32", from = "idu", },

    [81] =  { key = "Flowsensor", type = "U8", type2 = "OnOff", from = "idu", },

}





local cmd_2F11 = {

    [0] =  { key = "SysEnergyAnaEN", type = "U8", type2 = "OnOff", from = "idu", },

    [1] =  { key = "HMIEnergyAnaSetEN", type = "U8", type2 = "OnOff", },

    [2] =  { key = "SysPrecision", type = "U8", },

    [3] =  { key = "SysEnergyMethod", type = "U8", from = "idu", },

    [4] =  { key = "SysHeatInsHPCapacity", type = "U32", type2 = "0.01", from = "idu", },

    [5] =  { key = "SysHeatInsRenewPower", type = "U32", type2 = "0.01", from = "idu", },

    [6] =  { key = "SysHeatInsPower", type = "U32", type2 = "0.01", from = "idu", },

    [7] =  { key = "SysHeatInsCopEER", type = "U32", type2 = "0.01", from = "idu", },

    [8] =  { key = "SysHeatCapacity", type = "U32", type2 = "0.01", from = "idu", },

    [9] =  { key = "SysHeatRenewPower", type = "U32", type2 = "0.01", from = "idu", },

    [10] =  { key = "SysHeatElecConsum", type = "U32", type2 = "0.01", from = "idu", },

    [11] =  { key = "SysHeatCOPEER", type = "U32", type2 = "0.01", from = "idu", },

    [12] =  { key = "SysCoolInsHPCapacity", type = "U32", type2 = "0.01", from = "idu", },

    [13] =  { key = "SysCoolInsRenewPower", type = "U32", type2 = "0.01", from = "idu", },

    [14] =  { key = "SysCoolInsPower", type = "U32", type2 = "0.01", from = "idu", },

    [15] =  { key = "SysCoolInsCopEER", type = "U32", type2 = "0.01", from = "idu", },

    [16] =  { key = "SysCoolCapacity", type = "U32", type2 = "0.01", from = "idu", },

    [17] =  { key = "SysCoolRenewPower", type = "U32", type2 = "0.01", from = "idu", },

    [18] =  { key = "SysCoolElecConsum", type = "U32", type2 = "0.01", from = "idu", },

    [19] =  { key = "SysCoolCOPEER", type = "U32", type2 = "0.01", from = "idu", },

    [20] =  { key = "SysHeatDayCapacity", type = "U32", type2 = "0.01", },

    [21] =  { key = "SysHeatDayRenewPower", type = "U32", type2 = "0.01", },

    [22] =  { key = "SysHeatDayElecConsum", type = "U32", type2 = "0.01", },

    [23] =  { key = "SysHeatDayCOPEER", type = "U32", type2 = "0.01", },

    [24] =  { key = "SysHeatWeekCapacity", type = "U32", type2 = "0.01", },

    [25] =  { key = "SysHeatWeekRenewPower", type = "U32", type2 = "0.01", },

    [26] =  { key = "SysHeatWeekElecConsum", type = "U32", type2 = "0.01", },

    [27] =  { key = "SysHeatWeekCOPEER", type = "U32", type2 = "0.01", },

    [28] =  { key = "SysHeatMonthCapacity", type = "U32", type2 = "0.01", },

    [29] =  { key = "SysHeatMonthRenewPower", type = "U32", type2 = "0.01", },

    [30] =  { key = "SysHeatMonthElecConsum", type = "U32", type2 = "0.01", },

    [31] =  { key = "SysHeatMonthCOPEER", type = "U32", type2 = "0.01", },

    [32] =  { key = "SysHeatYearCapacity", type = "U32", type2 = "0.01", },

    [33] =  { key = "SysHeatYearRenewPower", type = "U32", type2 = "0.01", },

    [34] =  { key = "SysHeatYearElecConsum", type = "U32", type2 = "0.01", },

    [35] =  { key = "SysHeatYearCOPEER", type = "U32", type2 = "0.01", },

    [36] =  { key = "SysCoolDayCapacity", type = "U32", type2 = "0.01", },

    [37] =  { key = "SysCoolDayRenewPower", type = "U32", type2 = "0.01", },

    [38] =  { key = "SysCoolDayElecConsum", type = "U32", type2 = "0.01", },

    [39] =  { key = "SysCoolDayCOPEER", type = "U32", type2 = "0.01", },

    [40] =  { key = "SysCoolWeekCapacity", type = "U32", type2 = "0.01", },

    [41] =  { key = "SysCoolWeekRenewPower", type = "U32", type2 = "0.01", },

    [42] =  { key = "SysCoolWeekElecConsum", type = "U32", type2 = "0.01", },

    [43] =  { key = "SysCoolWeekCOPEER", type = "U32", type2 = "0.01", },

    [44] =  { key = "SysCoolMonthCapacity", type = "U32", type2 = "0.01", },

    [45] =  { key = "SysCoolMonthRenewPower", type = "U32", type2 = "0.01", },

    [46] =  { key = "SysCoolMonthElecConsum", type = "U32", type2 = "0.01", },

    [47] =  { key = "SysCoolMonthCOPEER", type = "U32", type2 = "0.01", },

    [48] =  { key = "SysCoolYearCapacity", type = "U32", type2 = "0.01", },

    [49] =  { key = "SysCoolYearRenewPower", type = "U32", type2 = "0.01", },

    [50] =  { key = "SysCoolYearElecConsum", type = "U32", type2 = "0.01", },

    [51] =  { key = "SysCoolYearCOPEER", type = "U32", type2 = "0.01", },

}





local cmd_2F12 = {

    [0] =  { key = "SysPrecision", type = "U8", },

    [1] =  { key = "SysTotalPowerConsum2", type = "U32", from = "idu", type2 = "0.01", },

    [2] =  { key = "SysInstantHPCapacity", type = "U16", from = "idu", type2 = "0.01", },

    [3] =  { key = "SysInstantRenewPower", type = "U16", from = "idu", type2 = "0.01", },

    [4] =  { key = "SysInstantPower", type = "U16", from = "idu", type2 = "0.01", },

    [5] =  { key = "SysInstantCopEER", type = "U32", from = "idu", type2 = "0.01", },

    [6] =  { key = "SysTotalHPCapacity", type = "U32", from = "idu", type2 = "0.01", },

    [7] =  { key = "SysTotalHeatCapacity", type = "U32", from = "idu", type2 = "0.01", },

    [8] =  { key = "SysTotalRenewPower", type = "U32", from = "idu", type2 = "0.01", },

    [9] =  { key = "SysTotalPowerConsum", type = "U32", from = "idu", type2 = "0.01", },

    [10] =  { key = "SysTotalHeatElecConsum", type = "U32", from = "idu", type2 = "0.01", },

    [11] =  { key = "SysTotalCOPEER", type = "U32", from = "idu", type2 = "0.01", },

    [12] =  { key = "SysDhwInsHPCapacity", type = "U32", from = "idu", type2 = "0.01", },

    [13] =  { key = "SysDhwInsRenewPower", type = "U32", from = "idu", type2 = "0.01", },

    [14] =  { key = "SysDhwInsPower", type = "U32", from = "idu", type2 = "0.01", },

    [15] =  { key = "SysDhwInsCopEER", type = "U32", from = "idu", type2 = "0.01", },

    [16] =  { key = "SysDhwCapacity", type = "U32", from = "idu", type2 = "0.01", },

    [17] =  { key = "SysDhwRenewPower", type = "U32", from = "idu", type2 = "0.01", },

    [18] =  { key = "SysDhwElecConsum", type = "U32", from = "idu", type2 = "0.01", },

    [19] =  { key = "SysDhwCOPEER", type = "U32", from = "idu", type2 = "0.01", },

    [20] =  { key = "SysDhwDayCapacity", type = "U32", type2 = "0.01", },

    [21] =  { key = "SysDhwDayRenewPower", type = "U32", type2 = "0.01", },

    [22] =  { key = "SysDhwDayElecConsum", type = "U32", type2 = "0.01", },

    [23] =  { key = "SysDhwDayCOPEER", type = "U32", type2 = "0.01", },

    [24] =  { key = "SysDhwWeekCapacity", type = "U32", type2 = "0.01", },

    [25] =  { key = "SysDhwWeekRenewPower", type = "U32", type2 = "0.01", },

    [26] =  { key = "SysDhwWeekElecConsum", type = "U32", type2 = "0.01", },

    [27] =  { key = "SysDhwWeekCOPEER", type = "U32", type2 = "0.01", },

    [28] =  { key = "SysDhwMonthCapacity", type = "U32", type2 = "0.01", },

    [29] =  { key = "SysDhwMonthRenewPower", type = "U32", type2 = "0.01", },

    [30] =  { key = "SysDhwMonthElecConsum", type = "U32", type2 = "0.01", },

    [31] =  { key = "SysDhwMonthCOPEER", type = "U32", type2 = "0.01", },

    [32] =  { key = "SysDhwYearCapacity", type = "U32", type2 = "0.01", },

    [33] =  { key = "SysDhwYearRenewPower", type = "U32", type2 = "0.01", },

    [34] =  { key = "SysDhwYearElecConsum", type = "U32", type2 = "0.01", },

    [35] =  { key = "SysDhwYearCOPEER", type = "U32", type2 = "0.01", },

}



local cmd_2F17 = {

    [0] =  { key = "powercons_version", type = "U8", },

    [1] =  { key = "isheatrun0", type = "U8", type2 = "OnOff", from = "idu", },

    [2] =  { key = "iscoolrun0", type = "U8", type2 = "OnOff", from = "idu", },

    [3] =  { key = "isdhwrun0", type = "U8", type2 = "OnOff", from = "idu", },

    [4] =  { key = "istbhrun0", type = "U8", type2 = "OnOff", from = "idu", },

    [5] =  { key = "isibhrun0", type = "U8", type2 = "OnOff", from = "idu", },

    [6] =  { key = "issmartgrid0", type = "U8", type2 = "OnOff", from = "idu", },

    [7] =  { key = "ishighprices0", type = "U8", type2 = "OnOff", from = "idu", },

    [8] =  { key = "isbottomprices0", type = "U8", type2 = "OnOff", from = "idu", },

    [9] =  { key = "totalelectricity0", type = "U32", from = "idu", },

    [10] =  { key = "totalthermal0", type = "U32", from = "idu", },

    [11] =  { key = "t4", type = "U16", type2 = "Temp", from = "idu", from = "idu", },

    [12] =  { key = "zone1_temp_set", type = "U16", type2 = "Temp", },

    [13] =  { key = "zone2_temp_set", type = "U16", type2 = "Temp", },

    [14] =  { key = "t5s", type = "U16", type2 = "Temp", },

    [15] =  { key = "tas", type = "U16", type2 = "Temp", },

    [16] =  { key = "newt1s1", type = "U16", type2 = "Temp", from = "idu", },

    [17] =  { key = "newt1s2", type = "U16", type2 = "Temp", from = "idu", },

    [18] =  { key = "onlinenum", type = "U8", from = "idu", },

    [19] =  { key = "power_ibh1", type = "U8", type2 = "0.1kW", },

    [20] =  { key = "power_ibh2", type = "U8", type2 = "0.1kW", },

    [21] =  { key = "power_tbh", type = "U8", type2 = "0.1kW", },

    [22] =  { key = "isonline1", type = "U8", type2 = "OnOff", from = "idu", },

    [23] =  { key = "isonline2", type = "U8", type2 = "OnOff", from = "idu", },

    [24] =  { key = "isonline3", type = "U8", type2 = "OnOff", from = "idu", },

    [25] =  { key = "isonline4", type = "U8", type2 = "OnOff", from = "idu", },

    [26] =  { key = "isonline5", type = "U8", type2 = "OnOff", from = "idu", },

    [27] =  { key = "isonline6", type = "U8", type2 = "OnOff", from = "idu", },

    [28] =  { key = "isonline7", type = "U8", type2 = "OnOff", from = "idu", },

    [29] =  { key = "isonline8", type = "U8", type2 = "OnOff", from = "idu", },

    [30] =  { key = "isonline9", type = "U8", type2 = "OnOff", from = "idu", },

    [31] =  { key = "isonline10", type = "U8", type2 = "OnOff", from = "idu", },

    [32] =  { key = "isonline11", type = "U8", type2 = "OnOff", from = "idu", },

    [33] =  { key = "isonline12", type = "U8", type2 = "OnOff", from = "idu", },

    [34] =  { key = "isonline13", type = "U8", type2 = "OnOff", from = "idu", },

    [35] =  { key = "isonline14", type = "U8", type2 = "OnOff", from = "idu", },

    [36] =  { key = "isonline15", type = "U8", type2 = "OnOff", from = "idu", },

    [37] =  { key = "isheatrun1", type = "U8", type2 = "OnOff", from = "idu", },

    [38] =  { key = "isheatrun2", type = "U8", type2 = "OnOff", from = "idu", },

    [39] =  { key = "isheatrun3", type = "U8", type2 = "OnOff", from = "idu", },

    [40] =  { key = "isheatrun4", type = "U8", type2 = "OnOff", from = "idu", },

    [41] =  { key = "isheatrun5", type = "U8", type2 = "OnOff", from = "idu", },

    [42] =  { key = "isheatrun6", type = "U8", type2 = "OnOff", from = "idu", },

    [43] =  { key = "isheatrun7", type = "U8", type2 = "OnOff", from = "idu", },

    [44] =  { key = "isheatrun8", type = "U8", type2 = "OnOff", from = "idu", },

    [45] =  { key = "isheatrun9", type = "U8", type2 = "OnOff", from = "idu", },

    [46] =  { key = "isheatrun10", type = "U8", type2 = "OnOff", from = "idu", },

    [47] =  { key = "isheatrun11", type = "U8", type2 = "OnOff", from = "idu", },

    [48] =  { key = "isheatrun12", type = "U8", type2 = "OnOff", from = "idu", },

    [49] =  { key = "isheatrun13", type = "U8", type2 = "OnOff", from = "idu", },

    [50] =  { key = "isheatrun14", type = "U8", type2 = "OnOff", from = "idu", },

    [51] =  { key = "isheatrun15", type = "U8", type2 = "OnOff", from = "idu", },

    [52] =  { key = "iscoolrun1", type = "U8", type2 = "OnOff", from = "idu", },

    [53] =  { key = "iscoolrun2", type = "U8", type2 = "OnOff", from = "idu", },

    [54] =  { key = "iscoolrun3", type = "U8", type2 = "OnOff", from = "idu", },

    [55] =  { key = "iscoolrun4", type = "U8", type2 = "OnOff", from = "idu", },

    [56] =  { key = "iscoolrun5", type = "U8", type2 = "OnOff", from = "idu", },

    [57] =  { key = "iscoolrun6", type = "U8", type2 = "OnOff", from = "idu", },

    [58] =  { key = "iscoolrun7", type = "U8", type2 = "OnOff", from = "idu", },

    [59] =  { key = "iscoolrun8", type = "U8", type2 = "OnOff", from = "idu", },

    [60] =  { key = "iscoolrun9", type = "U8", type2 = "OnOff", from = "idu", },

    [61] =  { key = "iscoolrun10", type = "U8", type2 = "OnOff", from = "idu", },

    [62] =  { key = "iscoolrun11", type = "U8", type2 = "OnOff", from = "idu", },

    [63] =  { key = "iscoolrun12", type = "U8", type2 = "OnOff", from = "idu", },

    [64] =  { key = "iscoolrun13", type = "U8", type2 = "OnOff", from = "idu", },

    [65] =  { key = "iscoolrun14", type = "U8", type2 = "OnOff", from = "idu", },

    [66] =  { key = "iscoolrun15", type = "U8", type2 = "OnOff", from = "idu", },

}





local cmd_2F18 = {

    [0] =  { key = "isdhwrun1", type = "U8", type2 = "OnOff", from = "idu", },

    [1] =  { key = "isdhwrun2", type = "U8", type2 = "OnOff", from = "idu", },

    [2] =  { key = "isdhwrun3", type = "U8", type2 = "OnOff", from = "idu", },

    [3] =  { key = "isdhwrun4", type = "U8", type2 = "OnOff", from = "idu", },

    [4] =  { key = "isdhwrun5", type = "U8", type2 = "OnOff", from = "idu", },

    [5] =  { key = "isdhwrun6", type = "U8", type2 = "OnOff", from = "idu", },

    [6] =  { key = "isdhwrun7", type = "U8", type2 = "OnOff", from = "idu", },

    [7] =  { key = "isdhwrun8", type = "U8", type2 = "OnOff", from = "idu", },

    [8] =  { key = "isdhwrun9", type = "U8", type2 = "OnOff", from = "idu", },

    [9] =  { key = "isdhwrun10", type = "U8", type2 = "OnOff", from = "idu", },

    [10] =  { key = "isdhwrun11", type = "U8", type2 = "OnOff", from = "idu", },

    [11] =  { key = "isdhwrun12", type = "U8", type2 = "OnOff", from = "idu", },

    [12] =  { key = "isdhwrun13", type = "U8", type2 = "OnOff", from = "idu", },

    [13] =  { key = "isdhwrun14", type = "U8", type2 = "OnOff", from = "idu", },

    [14] =  { key = "isdhwrun15", type = "U8", type2 = "OnOff", from = "idu", },

    [15] =  { key = "isibhrun1", type = "U8", type2 = "OnOff", from = "idu", },

    [16] =  { key = "isibhrun2", type = "U8", type2 = "OnOff", from = "idu", },

    [17] =  { key = "isibhrun3", type = "U8", type2 = "OnOff", from = "idu", },

    [18] =  { key = "isibhrun4", type = "U8", type2 = "OnOff", from = "idu", },

    [19] =  { key = "isibhrun5", type = "U8", type2 = "OnOff", from = "idu", },

    [20] =  { key = "isibhrun6", type = "U8", type2 = "OnOff", from = "idu", },

    [21] =  { key = "isibhrun7", type = "U8", type2 = "OnOff", from = "idu", },

    [22] =  { key = "isibhrun8", type = "U8", type2 = "OnOff", from = "idu", },

    [23] =  { key = "isibhrun9", type = "U8", type2 = "OnOff", from = "idu", },

    [24] =  { key = "isibhrun10", type = "U8", type2 = "OnOff", from = "idu", },

    [25] =  { key = "isibhrun11", type = "U8", type2 = "OnOff", from = "idu", },

    [26] =  { key = "isibhrun12", type = "U8", type2 = "OnOff", from = "idu", },

    [27] =  { key = "isibhrun13", type = "U8", type2 = "OnOff", from = "idu", },

    [28] =  { key = "isibhrun14", type = "U8", type2 = "OnOff", from = "idu", },

    [29] =  { key = "isibhrun15", type = "U8", type2 = "OnOff", from = "idu", },

    [30] =  { key = "istbhrun1", type = "U8", type2 = "OnOff", from = "idu", },

    [31] =  { key = "istbhrun2", type = "U8", type2 = "OnOff", from = "idu", },

    [32] =  { key = "istbhrun3", type = "U8", type2 = "OnOff", from = "idu", },

    [33] =  { key = "istbhrun4", type = "U8", type2 = "OnOff", from = "idu", },

    [34] =  { key = "istbhrun5", type = "U8", type2 = "OnOff", from = "idu", },

    [35] =  { key = "istbhrun6", type = "U8", type2 = "OnOff", from = "idu", },

    [36] =  { key = "istbhrun7", type = "U8", type2 = "OnOff", from = "idu", },

    [37] =  { key = "istbhrun8", type = "U8", type2 = "OnOff", from = "idu", },

    [38] =  { key = "istbhrun9", type = "U8", type2 = "OnOff", from = "idu", },

    [39] =  { key = "istbhrun10", type = "U8", type2 = "OnOff", from = "idu", },

    [40] =  { key = "istbhrun11", type = "U8", type2 = "OnOff", from = "idu", },

    [41] =  { key = "istbhrun12", type = "U8", type2 = "OnOff", from = "idu", },

    [42] =  { key = "istbhrun13", type = "U8", type2 = "OnOff", from = "idu", },

    [43] =  { key = "istbhrun14", type = "U8", type2 = "OnOff", from = "idu", },

    [44] =  { key = "istbhrun15", type = "U8", type2 = "OnOff", from = "idu", },

    [45] =  { key = "totalelectricity1", type = "U32", from = "idu", },

    [46] =  { key = "totalelectricity2", type = "U32", from = "idu", },

    [47] =  { key = "totalelectricity3", type = "U32", from = "idu", },

    [48] =  { key = "totalelectricity4", type = "U32", from = "idu", },

    [49] =  { key = "totalelectricity5", type = "U32", from = "idu", },

    [50] =  { key = "totalelectricity6", type = "U32", from = "idu", },

    [51] =  { key = "totalelectricity7", type = "U32", from = "idu", },

    [52] =  { key = "totalelectricity8", type = "U32", from = "idu", },

    [53] =  { key = "totalelectricity9", type = "U32", from = "idu", },

    [54] =  { key = "totalelectricity10", type = "U32", from = "idu", },

    [55] =  { key = "totalelectricity11", type = "U32", from = "idu", },

    [56] =  { key = "totalelectricity12", type = "U32", from = "idu", },

    [57] =  { key = "totalelectricity13", type = "U32", from = "idu", },

    [58] =  { key = "totalelectricity14", type = "U32", from = "idu", },

    [59] =  { key = "totalelectricity15", type = "U32", from = "idu", },

    [60] =  { key = "totalthermal1", type = "U32", from = "idu", },

    [61] =  { key = "totalthermal2", type = "U32", from = "idu", },

    [62] =  { key = "totalthermal3", type = "U32", from = "idu", },

    [63] =  { key = "totalthermal4", type = "U32", from = "idu", },

    [64] =  { key = "totalthermal5", type = "U32", from = "idu", },

    [65] =  { key = "totalthermal6", type = "U32", from = "idu", },

    [66] =  { key = "totalthermal7", type = "U32", from = "idu", },

    [67] =  { key = "totalthermal8", type = "U32", from = "idu", },

    [68] =  { key = "totalthermal9", type = "U32", from = "idu", },

    [69] =  { key = "totalthermal10", type = "U32", from = "idu", },

    [70] =  { key = "totalthermal11", type = "U32", from = "idu", },

    [71] =  { key = "totalthermal12", type = "U32", from = "idu", },

    [72] =  { key = "totalthermal13", type = "U32", from = "idu", },

    [73] =  { key = "totalthermal14", type = "U32", from = "idu", },

    [74] =  { key = "totalthermal15", type = "U32", from = "idu", },

    [75] =  { key = "isibh2run0", type = "U8", type2 = "OnOff", from = "idu", },

    [76] =  { key = "isibh2run1", type = "U8", type2 = "OnOff", from = "idu", },

    [77] =  { key = "isibh2run2", type = "U8", type2 = "OnOff", from = "idu", },

    [78] =  { key = "isibh2run3", type = "U8", type2 = "OnOff", from = "idu", },

    [79] =  { key = "isibh2run4", type = "U8", type2 = "OnOff", from = "idu", },

    [80] =  { key = "isibh2run5", type = "U8", type2 = "OnOff", from = "idu", },

    [81] =  { key = "isibh2run6", type = "U8", type2 = "OnOff", from = "idu", },

    [82] =  { key = "isibh2run7", type = "U8", type2 = "OnOff", from = "idu", },

    [83] =  { key = "isibh2run8", type = "U8", type2 = "OnOff", from = "idu", },

    [84] =  { key = "isibh2run9", type = "U8", type2 = "OnOff", from = "idu", },

    [85] =  { key = "isibh2run10", type = "U8", type2 = "OnOff", from = "idu", },

    [86] =  { key = "isibh2run11", type = "U8", type2 = "OnOff", from = "idu", },

    [87] =  { key = "isibh2run12", type = "U8", type2 = "OnOff", from = "idu", },

    [88] =  { key = "isibh2run13", type = "U8", type2 = "OnOff", from = "idu", },

    [89] =  { key = "isibh2run14", type = "U8", type2 = "OnOff", from = "idu", },

    [90] =  { key = "isibh2run15", type = "U8", type2 = "OnOff", from = "idu", },

    [91] =  { key = "voltage0", type = "U8", from = "idu", },

    [92] =  { key = "voltage1", type = "U8", from = "idu", },

    [93] =  { key = "voltage2", type = "U8", from = "idu", },

    [94] =  { key = "voltage3", type = "U8", from = "idu", },

    [95] =  { key = "voltage4", type = "U8", from = "idu", },

    [96] =  { key = "voltage5", type = "U8", from = "idu", },

    [97] =  { key = "voltage6", type = "U8", from = "idu", },

    [98] =  { key = "voltage7", type = "U8", from = "idu", },

    [99] =  { key = "voltage8", type = "U8", from = "idu", },

    [100] =  { key = "voltage9", type = "U8", from = "idu", },

    [101] =  { key = "voltage10", type = "U8", from = "idu", },

    [102] =  { key = "voltage11", type = "U8", from = "idu", },

    [103] =  { key = "voltage12", type = "U8", from = "idu", },

    [104] =  { key = "voltage13", type = "U8", from = "idu", },

    [105] =  { key = "voltage14", type = "U8", from = "idu", },

    [106] =  { key = "voltage15", type = "U8", from = "idu", },

}





local cmd_2F20 = {

    [0] =  { key = "cmd_flag", type = "U16" },

    [1] =  { key = "timer_callback", type = "U16" },

}



local cmd_table = {

    ["2010"] = cmd_2010,

    ["2020"] = cmd_2020,

    ["2040"] = cmd_2040,

    ["2050"] = cmd_2050,

    ["2060"] = cmd_2060,

    ["2070"] = cmd_2070,

    ["2080"] = cmd_2080,

    ["2090"] = cmd_2090,

    ["20A0"] = cmd_20A0,

    ["20B0"] = cmd_20B0,

    ["20B1"] = cmd_20B1,

    ["20D0"] = cmd_20D0,

    ["20E0"] = cmd_20E0,

    ["20F0"] = cmd_20F0,

    ["2100"] = cmd_2100,

    ["2F10"] = cmd_2F10,

    ["2F11"] = cmd_2F11,

    ["2F12"] = cmd_2F12,

    ["2F17"] = cmd_2F17,

    ["2F18"] = cmd_2F18,

    ["2F20"] = cmd_2F20,

}



-- 分割线

-- --------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------

-- 根据电控协议不同，需要改变的函数



-- 根据传入的json修改全局变量值，并构造消息 body 部分

local function updateGlobalPropertyValueByJson(luaTable)

    

    -- 工作表，默认 000

    local u16_table = "0x2010"

    if luaTable["u16_table"] ~= nil then

        u16_table = luaTable["u16_table"]

    end

    -- 兼容旧版本 control_type

    if luaTable["control_type"] ~= nil then

        u16_table = luaTable["control_type"]

    end



    if luaTable["u16_table"] == nil then

        luaTable["u16_table"] = u16_table

    end



    -- 匹配工作表

    local cmd_x = cmd_table[string.format("%X",u16_table)]



    if cmd_x ~= nil then

        for i = 0, #cmd_x do

            -- 写入 Json 的 Value

            local propertyValue = luaTable[cmd_x[i]["key"]]

            cmd_x[i]["dirty"] = false



            if propertyValue ~= nil then

                cmd_x[i]["value"] = propertyValue

                cmd_x[i]["dirty"] = true

            end

        end

    end



    return cmd_x

end



-- 根据传入的byte[]修改返回 Json

local function updateGlobalPropertyValueByByte(messageBytes)

    -- ignore

end



-- 将属性值转换为最终table

local function assembleJsonByGlobalProperty()

    -- ignore

end



-- --------------------------------------------------------------------------------------------------

-- --------------------------------  MBT 自定义函数 --------------------------------------------------

-- --------------------------------------------------------------------------------------------------

-- 用于转换 control/status 变量到 bodyBytes

local function assembleGlobalPropertyValueByJson(status, cmd_x)



    -- 前10字节是协议头

    local bodyBytes = {}



    -- 当前协议是 0

    local u8_protocol =0

    if status["u8_protocol"] ~= nil then

        u8_protocol =tonumber(status["u8_protocol"])

    end

    bodyBytes[0] = bit.band(u8_protocol,0xff)



    -- 工作表,默认 0xffff，如何处理交给控制器

    local u16_table = 0xffff

    if status["u16_table"] ~= nil then

        u16_table = tonumber(status["u16_table"], 16)

    end

    -- 兼容旧版本 control_type

    if status["control_type"] ~= nil then

        u16_table = status["control_type"]

    end

    bodyBytes[1] = bit.band(bit.rshift(u16_table, 8), 0x00ff)

    bodyBytes[2] = bit.band(u16_table, 0x00ff)



    -- Profile 版本，默认传入0xff不处理

    local u8_profile = 0xff

    if status["u8_profile"] ~= nil then

        u8_profile = tonumber(status["u8_profile"])

    end

    bodyBytes[3] = 0xff

    bodyBytes[4] = bit.band(u8_profile, 0xff)



    -- 默认传入ff，不处理

    bodyBytes[5] = 0xff



    -- 默认传入ff，不处理

    bodyBytes[6] = 0xff



    -- 解析格式，默认 0x01/TLV

    local u8_format = 0x01

    if status["u8_format"] ~= nil then

        u8_format = tonumber(status["u8_format"])        

    end

    bodyBytes[7] = bit.band(u8_format, 0xff)



    -- 默认传入ff，不处理

    bodyBytes[8] = 0xff

    bodyBytes[9] = 0xff



    -- 匹配命令表

    if cmd_x ~= nil then

        local propertyValue = nil

        local propertyType  = nil

        local propertyType2  = nil

        -- 注意 开始 id = 0

        for i = 0, #cmd_x do

            propertyValue = cmd_x[i]["value"]

            propertyType  = cmd_x[i]["type"]

            propertyType2  = cmd_x[i]["type2"]



            -- 全协议格式/顺序格式

            if  u8_format == 0 then

                -- 提供默认值

                if propertyValue == nil or propertyValue == VALUE_INVALID or propertyValue == VALUE_UNKNOWN then

                    if propertyType == "U8" then

                        propertyValue = "255"

                    elseif propertyType == "U16" then

                        if propertyType2 == "Temp" then

                            propertyValue = "32767"

                        elseif propertyType2 == "Current" then

                            propertyValue = "65535"

                        else

                            propertyValue = "65535"

                        end

                    elseif propertyType == "U32" then

                        propertyValue = "4294967295"

                    elseif string.match(propertyType, "ASCII/%d+") ~= nil then

                        propertyValue = ""

                    end

                end

            -- TLV 格式

            elseif cmd_x[i]["dirty"] == true then

                cmd_x[i]["dirty"] = false

                -- tag * 2 Bytes

                table.insert(bodyBytes, bit.band(bit.rshift(i, 8), 0x00ff))

                table.insert(bodyBytes, bit.band(i, 0x00ff))

                -- Length * 1 Byte

                if propertyType == "U8" then

                    table.insert(bodyBytes, 1)

                elseif propertyType == "U16" then

                    table.insert(bodyBytes, 2)

                elseif propertyType == "U32" then

                    table.insert(bodyBytes, 4)

                elseif string.match(propertyType, "ASCII/%d+") ~= nil then

                    -- 最长64

                    local len = tonumber(string.match(propertyType, "%d+")) % 65

                    table.insert(bodyBytes, len)

                end

            else

                propertyValue = nil

            end

            -- 写入 Json 的控制值

            if propertyValue ~= nil then

                if propertyType == "U8" then

                    if propertyValue == "255" then

                        propertyValue = tonumber("255")

                    -- Type 2

                    elseif propertyType2 == "OnOff" then

                        propertyValue = DOUBLEMAP[propertyType2][propertyValue]

                    elseif propertyType2 == "IduMode" then

                        propertyValue = DOUBLEMAP[propertyType2][propertyValue]

                    elseif propertyType2 == "TempType" then

                        propertyValue = DOUBLEMAP[propertyType2][propertyValue]

                    elseif propertyType2 == "TerminalType" then

                        propertyValue = DOUBLEMAP[propertyType2][propertyValue]

                    elseif propertyType2 == "AutoMode" then

                        propertyValue = DOUBLEMAP[propertyType2][propertyValue]

                    elseif propertyType2 == "SilenceLv" then

                        propertyValue = DOUBLEMAP[propertyType2][propertyValue]

                    elseif propertyType2 == "Weekday" then

                        local substrings = {}

                        for s in string.gmatch(propertyValue, "[^,]+") do

                            table.insert(substrings, s)

                        end

                        propertyValue = 0

                        for k, v in pairs(substrings) do

                            if DOUBLEMAP[propertyType2][v] ~= nil then

                                propertyValue = bit.bor(propertyValue, DOUBLEMAP[propertyType2][v])

                            end

                        end

                    elseif propertyType2 == "UnitMode" then

                        propertyValue = DOUBLEMAP[propertyType2][propertyValue]

                    elseif propertyType2 == "0.1kW" then

                        propertyValue = tonumber(propertyValue) * 10 % 256

                    elseif propertyType2 == "0.01" then

                        if propertyType == "U8" then

                            propertyValue = tonumber(propertyValue) * 100 % 256

                        elseif propertyType == "U16" then

                            propertyValue = tonumber(propertyValue) * 100 % 65535

                        else

                            propertyValue = tonumber(propertyValue) * 100 % 4294967295

                        end

                    elseif propertyType2 == "Int" then

                        if propertyType == "U8" then

                            propertyValue = tonumber(propertyValue) % 256

                        elseif propertyType == "U16" then

                            propertyValue = tonumber(propertyValue) % 65535

                        elseif propertyType == "U32" then

                            propertyValue = tonumber(propertyValue) % 4294967295

                        else

                            propertyValue = tonumber(propertyValue) % 256

                        end

                    else

                        propertyValue = tonumber(propertyValue) % 256

                    end



                    if propertyValue == nil then

                        propertyValue = tonumber("255")

                    end



                    -- OK

                    table.insert(bodyBytes, propertyValue)

                elseif propertyType == "U16" then



                    -- Type 2

                    if propertyValue == "65535" or propertyValue == "32767" then

                        propertyValue = tonumber(propertyValue)

                    elseif propertyType2 == "Temp" then

                        propertyValue = tonumber(propertyValue) * 10 % 65536

                    elseif propertyType2 == "Current" then

                        propertyValue = tonumber(propertyValue) * 100 % 65536

                    else

                        propertyValue = tonumber(propertyValue) % 65536

                    end



                    -- for debug

                    -- debugPrint(propertyValue)

   

                    table.insert(bodyBytes, bit.band(bit.rshift(propertyValue, 8), 0x00ff))

                    table.insert(bodyBytes, bit.band(propertyValue, 0x00ff))

                elseif propertyType == "U32" then

                    propertyValue = tonumber(propertyValue) % 4294967296

                    table.insert(bodyBytes, bit.band(bit.rshift(propertyValue, 24), 0x000000ff))

                    table.insert(bodyBytes, bit.band(bit.rshift(propertyValue, 16), 0x000000ff))

                    table.insert(bodyBytes, bit.band(bit.rshift(propertyValue, 8), 0x000000ff))

                    table.insert(bodyBytes, bit.band(propertyValue, 0x000000ff))

                elseif string.match(propertyType, "ASCII/%d+") ~= nil then

                    -- 最长64

                    local len = tonumber(string.match(propertyType, "%d+")) % 65

                    for i = 1, len do

                        local byte_i = propertyValue:byte(i)

                        if byte_i == nil then

                            byte_i = 0

                        end

                        -- for debug

                        -- debugPrint(propertyValue:byte(i), propertyValue, byte_i)

                        table.insert(bodyBytes, byte_i)

                    end                    

                end

            end

        end

    end



    return bodyBytes

end





local function assembleQueryValueByJson(luaTable)



    -- 前10字节是协议头

    local bodyBytes = {}



    -- 格式

    local u8_protocol =0

    if luaTable["u8_protocol"]~= nil then

        u8_protocol =tonumber(luaTable["u8_protocol"])

    end

    bodyBytes[0] = bit.band(u8_protocol,0xff)



    -- 工作表

   local u16_table = 0x2010

    if luaTable["u16_table"] ~= nil then

        u16_table = tonumber(luaTable["u16_table"], 16)

    -- 兼容旧版本 query_type

    elseif luaTable["query_type"] ~= nil then

        u16_table = tonumber(luaTable["query_type"])

    end



    bodyBytes[1] = bit.band(bit.rshift(u16_table, 8), 0x00ff)

    bodyBytes[2] = bit.band(u16_table, 0x00ff)



    -- 保持0

    bodyBytes[3] = 0xff

    bodyBytes[4] = 0xff

    bodyBytes[5] = 0xff

    bodyBytes[6] = 0xff



    local u8_format = 0

    if luaTable["u8_format"]~= nil then

        u8_format =tonumber(luaTable["u8_format"])

    end

    bodyBytes[7] = bit.band(u8_format, 0xff)



    bodyBytes[8] = 0xff

    bodyBytes[9] = 0xff



    return bodyBytes

end



local function handleIntergerWithRate(type1, rate, msgByte, sign)

    local retValue = ""

    if type1 == "U8" then

        -- 正数

        if sign == false or msgByte <= 0x7F then

            retValue = tostring(msgByte / rate)

        else

        -- 负数

            retValue = -bit.band(bit.bnot(msgByte) + 1, 2 ^ 8 - 1) 

            retValue = tostring(retValue / rate)

        end

    elseif type1 == "U16" then

        -- 正数

        if sign == false or msgByte <= 0x7FFF then

            retValue = tostring(msgByte / rate)

        else

        -- 负数

            retValue = -bit.band(bit.bnot(msgByte) + 1, 2 ^ 16 - 1) 

            retValue = tostring(retValue / rate)

        end

    elseif type1 == "U32" then

        -- 正数

        if sign == false or msgByte <= 0x7FFFFFFF then

            retValue = tostring(msgByte / rate)

        else

        -- 负数

            retValue = -bit.band(bit.bnot(msgByte) + 1, 2 ^ 32 - 1) 

            retValue = tostring(retValue / rate)

        end 

    end

    return retValue

end



-- dataToJson/Core Type Handle

local function dataToJsonCoreTypeHandle(type1, type2, msgByte)

    local retValue = ""



    if type2 == "OnOff" then

        retValue = DOUBLEMAP[type2][msgByte]

    elseif type2 == "IduMode" then

        retValue = DOUBLEMAP[type2][msgByte]

    elseif type2 == "TempType" then

        retValue = DOUBLEMAP[type2][msgByte]

    elseif type2 == "TerminalType" then

        retValue = DOUBLEMAP[type2][msgByte]

    elseif type2 == "AutoMode" then

        retValue = DOUBLEMAP[type2][msgByte]

    elseif type2 == "SilenceLv" then

        retValue = DOUBLEMAP[type2][msgByte]

    elseif type2 == "Weekday" then

        for i = 0, 7 do

            if (bit.band(bit.lshift(0x01, i), msgByte)) ~= 0 then

                retValue = retValue .. DOUBLEMAP[type2][bit.lshift(0x01, i)] .. ","

            end

        end

    elseif type2 == "UnitMode" then

        retValue = DOUBLEMAP[type2][msgByte]

    elseif type2 == "0.1kW" then

        if type1 == "U8" and msgByte == 0xFF then

            retValue = VALUE_INVALID

        else

            retValue = handleIntergerWithRate(type1, 10, msgByte, false)

        end

    elseif type2 == "0.01" then

        if type1 == "U8" and msgByte == 0xFF then

            retValue = VALUE_INVALID

        elseif type1 == "U16" and msgByte == 0xFFFF then

            retValue = VALUE_INVALID

        elseif type1 == "U32" and msgByte == 0xFFFFFFFF then

            retValue = VALUE_INVALID

        else

            retValue = handleIntergerWithRate(type1, 100, msgByte, false)

        end

    elseif type2 == "Int" then

        retValue = handleIntergerWithRate(type1, 1, msgByte, true)

    elseif type2 == "Temp" then

        if msgByte == 0x7FFF then

            retValue = VALUE_INVALID

        else

            retValue = handleIntergerWithRate(type1, 10, msgByte, true)

        end

    elseif type2 == "Current" then

        retValue = handleIntergerWithRate(type1, 100, msgByte, false)

    else

        retValue = tostring(msgByte)



        -- Invalid value

        if type1 == "U8" and retValue == "255" then

            retValue = VALUE_INVALID

        elseif type1 == "U16" and retValue == "65535" then

            retValue = VALUE_INVALID

        elseif type1 == "U32" and retValue == "4294967295" then

            retValue = VALUE_INVALID

        elseif retValue == nil then

            retValue = VALUE_INVALID

        end

    end



    return retValue

end



-- dataToJson/ASCII Type Handle

local function dataToJsonAsciiTypeHandle(bytes, index, len)

    local messageChars = ""

    for j = 1, len do

        local tempByte = bytes[index+j-1]

        if tempByte == 0 then

            break

        end

        messageChars = messageChars .. string.char(tempByte)

    end

    return messageChars

end



-- dataToJson 提取二进制字节后,转换成字符串

local function assembleJsonByByteFormat0(messageBytes)

    local retTable = {}

    local fromTable = {}



    if #messageBytes < 10 then

        return retTable, fromTable

    end



    local u16_table = messageBytes[1] * 0x100 + messageBytes[2]

    local cmd_x = cmd_table[string.format("%X",u16_table)]



    if cmd_x == nil then

        return retTable, fromTable

    end



    local u8_format = messageBytes[7]



    retTable["u8_protocol"] = tostring(messageBytes[0])

    retTable["u16_table"]   = string.format("%X", u16_table)

    retTable["u8_reserved"] = tostring(messageBytes[3])

    retTable["u8_profile"] = tostring(messageBytes[4])

    retTable["u8_reserved"]   = tostring(messageBytes[5])

    retTable["u8_reserved"] = tostring(messageBytes[6])

    retTable["u8_format"]  = tostring(u8_format)

    retTable["u8_reserved"] = tostring(messageBytes[8])

    retTable["u8_reserved"] = tostring(messageBytes[9])



    -- 重新开始解析电控指令报文

    local messageIndex  = 10

    local messageLength = #messageBytes



    -- TLV格式

    if u8_format == 1 then

        for i = 0, #cmd_x do

            if messageLength - messageIndex < 3 then

                break

            end

            -- tag

            local tag = bit.bor(bit.lshift(messageBytes[messageIndex], 8), messageBytes[messageIndex+1])

            -- length

            local length = messageBytes[messageIndex+2]

            messageIndex = messageIndex + 3

            -- value

            local x = cmd_x[tag]

            if x ~= nil then

                local propertyType = x["type"]

                local propertyType2 = x["type2"]



                if x["from"] == nil then

                    fromTable[x["key"]] = "controller"

                else

                    fromTable[x["key"]] = x["from"]

                end



                if propertyType == "U8" then

                    if length ~= 1 then

                        return {}, {}

                    end

                    -- handle type

                    retTable[x["key"]] = dataToJsonCoreTypeHandle(propertyType, propertyType2, messageBytes[messageIndex])

                    messageIndex = messageIndex + 1

    

                elseif propertyType == "U16" then

                    if length ~= 2 then

                        return {}, {}

                    end

                    -- handle type

                    retTable[x["key"]] = dataToJsonCoreTypeHandle(propertyType, propertyType2, messageBytes[messageIndex] * 0x100 + messageBytes[messageIndex+1])

                    messageIndex = messageIndex + 2

    

                elseif propertyType == "U32" then

                    if length ~= 4 then

                        return {}, {}

                    end

                    -- handle type

                    retTable[x["key"]] = dataToJsonCoreTypeHandle(propertyType, propertyType2, messageBytes[messageIndex] * 0x1000000 + messageBytes[messageIndex+1] * 0x10000 + messageBytes[messageIndex+2] * 0x100 + messageBytes[messageIndex+3])

                    messageIndex = messageIndex + 4

    

                elseif string.match(propertyType, "ASCII/%d+") ~= nil then

                    -- 最长64

                    local len = tonumber(string.match(propertyType, "%d+")) % 65

                    if length ~= len then

                        return {}, {}

                    end

                    retTable[x["key"]] = dataToJsonAsciiTypeHandle(messageBytes, messageIndex, len)

                    messageIndex = messageIndex + len

                end

            end

        end

    -- 顺序

    else

        -- 遍历 table

        -- 注意 开始 id = 0

        for i = 0, #cmd_x do

            -- debugPrint(i, cmd_x[i]["type"], cmd_x[i]["key"])

            if messageIndex > messageLength then

                break

            end

            local x = cmd_x[i]

            local propertyType = x["type"]

            local propertyType2 = x["type2"]



            if x["from"] == nil then

                fromTable[x["key"]] = "controller"

            else

                fromTable[x["key"]] = x["from"]

            end



            if propertyType == "U8" then

                -- Handle type

                retTable[x["key"]] = dataToJsonCoreTypeHandle(propertyType, propertyType2, messageBytes[messageIndex])

                messageIndex = messageIndex + 1



            elseif propertyType == "U16" then

                -- Handle type

                retTable[x["key"]] = dataToJsonCoreTypeHandle(propertyType, propertyType2, messageBytes[messageIndex] * 0x100 + messageBytes[messageIndex+1])

                messageIndex = messageIndex + 2



            elseif propertyType == "U32" then

                -- Handle type

                retTable[x["key"]] = dataToJsonCoreTypeHandle(propertyType, propertyType2, messageBytes[messageIndex] * 0x1000000 + messageBytes[messageIndex+1] * 0x10000 + messageBytes[messageIndex+2] * 0x100 + messageBytes[messageIndex+3])

                messageIndex = messageIndex + 4



            elseif string.match(propertyType, "ASCII/%d+") ~= nil then

                -- 最长64

                local len = tonumber(string.match(propertyType, "%d+")) % 65

                if messageIndex + len - 1 >  messageLength then

                    break

                end

                retTable[x["key"]] = dataToJsonAsciiTypeHandle(messageBytes, messageIndex, len)

                messageIndex = messageIndex + len

            end

        end

    end



    return retTable, fromTable

end



local function assembleJsonByByte(messageBytes)

    if messageBytes[0] == 0 then

        return assembleJsonByByteFormat0(messageBytes)

    else

        return {}, {}

    end

end



-- --------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------

local function patch_iduversion(json_data)

    local iduVersionNum = json_data['status']['iduVersionNum']

    local iduVersionDate = json_data['status']['iduVersionDate']



    if  iduVersionNum  ~= nil 

    and iduVersionDate ~= nil then

        local year = bit.rshift(bit.band(tonumber(iduVersionDate), 0xFE00), 9)

        local mon  = bit.rshift(bit.band(tonumber(iduVersionDate), 0x01E0), 5)

        local day  = bit.rshift(bit.band(tonumber(iduVersionDate), 0x001F), 0)

        json_data['status']['iduVersionNum'] = string.format("%02d%02d%02dV%02d", year, mon, day, tonumber(iduVersionNum))

    end

end



local function patch_oduversion(json_data)

    local oduVersionNum = json_data['status']['oduVersionNum']

    local oduVersionDate = json_data['status']['oduVersionDate']



    if  oduVersionNum  ~= nil 

    and oduVersionDate ~= nil  then

        local year = bit.rshift(bit.band(tonumber(oduVersionDate), 0xFE00), 9)

        local mon  = bit.rshift(bit.band(tonumber(oduVersionDate), 0x01E0), 5)

        local day  = bit.rshift(bit.band(tonumber(oduVersionDate), 0x001F), 0)

        json_data['status']['oduVersionNum'] = string.format("%02d%02d%02dV%02d", year, mon, day, tonumber(oduVersionNum))

    end

end



-- 补丁,增加消息校验码的校验

local function checkHeadBytes(byteData)

    local msgLength = #byteData



    if byteData[1] ~= BYTE_PROTOCOL_HEAD

    or byteData[2] ~= msgLength-1

    or byteData[3] ~= 0xC3

    or byteData[msgLength] ~= makeSum(byteData, 2, msgLength - 1) then

        -- for debug

        -- debugPrint('format error\n')

        return false

    end

    return true

end





  --[[

  场景发送过来的指令，进行互斥判断

  --]]

  local function sceneDoMutex(json)

    -- ____xxx___ 这种格式，是为了mutexTable 的可读性

    local ______0______ = false

    local ______1______ = true

    local _zone1_power_ = 'zone1_power_state'

    local _zone2_power_ = 'zone2_power_state'

    local ___mode_set__ = 'run_mode_set'



    local ___holiday___ = 'holiday_on_state'--在运行休假中

    local _thermal_mode = 'room_thermalmode_state'--房间温控器模式设定使能

    local _thermal_en__ = 'room_thermalen_state'--房间温控器使能

    local __double_en__ = 'double_zone_enable'--双区域开启使能

    local ___reserve___ = 'reserve'



    -- 功能互斥表

    local mutexTable = {

        {'           ', ___holiday___, _thermal_mode, _thermal_en__, ___reserve___},

        {_zone1_power_, ______1______, ______1______, ______1______, ______0______},

        {_zone2_power_, ______1______, ______1______, ______1______, ______0______},

        {___mode_set__, ______1______, ______1______, ______0______, ______0______},

    }



    local function getMutexKeys( target) 

        local keys = {}

    

        if mutexTable == nil then 

            return keys

        end

    

        for i,row in ipairs(mutexTable) do 

            if row[1] == target then

                for j,item in ipairs(row) do

                    if item == true then 

                        table.insert(keys, mutexTable[1][j])

                    end

                end

            end

        

        end

        return keys

    end



    -- 常规互斥：可以通过互斥表实现的简单互斥判断

    local function doMutexByTable(json,targets)

        for i,target in ipairs(targets) do

            local mutexkeys = getMutexKeys(target)



            --  如果 mutexkeys对应的值为开，则 zone1_power_state保持原来的值下发

             if #mutexkeys ~= 0 then

                for j,key in ipairs(mutexkeys) do 

                    if(json['status'][key]) == "on" then

                        if(json['status'][target] ~= nil) then 

                            json['control'][target] = json['status'][target]--把原来原来的值复制到control中

                        end

                    end

                end

            end

        end

       

    end



    -- zone2 power特殊互斥实现 

    local function zone2PowerDoMutex(device)

        local isOk = true



        if (not isDoubleZoneEnable(device)) then

            isOk = false

        elseif(

             (device['control']['zone2_power_state'] == 'on' ) and

             (device.status.run_mode_set == 'cool' or (device.status.run_mode_set == 'auto' and device.status.runmode_under_auto == 'cool'))

        ) then

               --[[

                    插件逻辑:

                    区域2不支持制冷(zone2CoolExist == false)，且实际运行的模式为制冷(run_mode_set == cool ||(run_mode_set == auto && runmode_under_auto == cool) ),

                    则提示：'Zone 2 cooling function is invalid',不能进行开机操作

                    但由于但alexa中由于获取不到zone2CoolExist 点位，所以仅进行实际运行的模式为制冷的判断

               --]]

            isOk = false

        end



        if(isOk == false) then

            if(device['status']['zone2_power_state'] ~= nil) then 

                json['control']['zone2_power_state'] = json['status']['zone2_power_state']--把原来原来的值复制到control中

            end

        end

        

    end



    -- mode 特殊互斥实现 

    local function modeDoMutex(device)

        local mode = device['control']['run_mode_set']

        local isOk = true



           --[[

            插件逻辑:

            制冷支持，才能设置制冷；

            制热支持，才能设置制热；

            制热,制热都支持，才能设置自动；

        --]]

        if ((mode == 'auto' and (device.status.cool_enable ~= 'on' or device.status.heat_enable ~= 'on'))) then

            isOk = false

        elseif (mode == 'cool' and device.status.cool_enable ~= 'on') then

            isOk = false

        elseif (mode == 'heat' and device.status.heat_enable ~= 'on') then

            isOk = false

        end



        --若 支持房间温控器使能 (room_thermalen_state == "on") && 当前模式为自动

        --则原来原来的值复制到control中

        if (device.status.room_thermalen_state == 'on' and mode == 'auto') then

            isOk = false

        end



        if(isOk == false) then

            if(device['status']['run_mode_set'] ~= nil) then 

                json['control']['run_mode_set'] = json['status']['run_mode_set']--把原来原来的值复制到control中

            end

        end

    end



    local function isHolidayActived( device) 

        return device.status.holiday_on_state == 'on'

    end



    local function isEcoActived(device) 

        return device.status.eco_on_state == 'on'

    end

    local function isZone1RoomTemp(device) 

        return device.status.zone1_temp_type == 'room_temperature_type'

    end

    

    local function isZone1CurveOn(device) 

        return device.status.zone1_curve_state == 'on'

    end



    local function hasCurveNewKey(device) 

        return (

            device.zone1_cool_curve_state or

            device.zone1_heat_curve_state or

            device.zone2_cool_curve_state or

            device.zone2_heat_curve_state

        )

    end



    --[[

        获取线控器实际运行的模式

    --]]

    function getActualRunMode(device) 

        if (device.status.run_mode_set == 'auto') then

            return device.status.runmode_under_auto

        end



        return device.status.run_mode_set

    end  

    

    function isZone1HeatCurveStateOn(device) 

        return device.status.zone1_heat_curve_state == 'on'

    end



    function isZone1CoolCurveStateOn(device) 

        return device.status.zone1_cool_curve_state == 'on'

    end



    local function getZone1CurveStatus(device) 

        -- 旧版本判断

        if (not(hasCurveNewKey(device)))  then

        --[[

            由于获取不到以下点位，因此alexa中仅判断 eco_on_state，一旦为开，就不能设置温度

            if (!this.isEcoTimeOn) return true



            curve: on && ecoTimer: on && isWithinECORunTimer: on => true

            if (this.isWithinECORunTimer) return true



            curve: on && ecoTimer: on && isWithinECORunTimer: off => true

            if (!this.isWithinECORunTimer) return false                

            --]]

            if (isEcoActived(device)) then

                return true

            end



            return isZone1CurveOn(device) or isHolidayActived(device)

        end



        



        if(getActualRunMode(device) == 'heat') then

            if (isZone1HeatCurveStateOn(device)) then

                

                --[[

                    由于获取不到以下点位，因此alexa中仅判断 eco_on_state，一旦为开，就不能设置温度

                    curve: on && ecoTimer: off => true

                    if (!this.isEcoTimeOn) return true



                    curve: on && ecoTimer: on && isWithinECORunTimer: on => true

                    if (this.isWithinECORunTimer) return true



                    curve: on && ecoTimer: on && isWithinECORunTimer: off => true

                    if (!this.isWithinECORunTimer) return false

                --]]



                if (isEcoActived(device)) then

                    return true

                end

            



                return isHolidayActived(device)

            elseif(getActualRunMode(device) == 'cool') then

                return isZone1CoolCurveStateOn(device) or isHolidayActived(device)

            end

            

        end

    end



    --[[

        是否不支持设置温度

    --]]

    local function isDisabled(device) 

        -- 1.当温度类型为气温时，可以设置温度（优化级最高）

        if (isZone1RoomTemp(device) and not(isHolidayActived(device))) then

            return false

        end



        -- 2.当ECO运行中，温度不可设置

        if (isEcoActived(device)) then

            return true

        end

        -- 3.当curve标示为on时，要判断当前模式zone1_heat_curve_state/zone1_cool_curve_state是否为on。若zone1_heat_curve_state为on时，则制热温度不可设，不影响制冷温度设置

        if (isZone1CurveOn(device)) then 

            return getZone1CurveStatus(device)

        end



        return isHolidayActived(device)

    end



    function isDoubleZoneEnable(device) 

        return device.status.double_zone_enable == 'on'

    end

    

    function isZone2RoomTemp(device) 

        return device.status.zone2_temp_type == 'room_temperature_type'

    end

    

    function isZone2WaterTemp(device) 

        return device.status.zone2_temp_type == 'water_temperature_type'

    end



    function isZone2HeatCurveStateOn(device) 

        return device.status.zone2_heat_curve_state == 'on'

    end



    function isZone2CoolCurveStateOn(device) 

        return device.status.zone2_cool_curve_state == 'on'

    end



    function isZone2CurveOn(device) 

        return device.status.zone2_curve_state == 'on'

    end





    --获取温度范围：https://www.processon.com/diagraming/6389af387d9c086a817e3d58

    local function getRange(device) 

        local min = 0

        local max = 100

        --房间温度开启，就直接用房间温度的范围

        if (device.status.zone1_temp_type == 'room_temperature_type') then

            min = device.status.room_min_set_temp

            max = device.status.room_max_set_temp

        else 

            if(getActualRunMode(device) == 'cool') then 

                min = device.status.zone1_cool_min_set_temp

                max = device.status.zone1_cool_max_set_temp

            elseif(getActualRunMode(device) == 'heat') then 

                min = device.status.zone1_heat_min_set_temp

                max = device.status.zone1_heat_max_set_temp

            end



        end

       

        return {

            max = tonumber(max),

            min = tonumber(min)

        }

    end





    --获取温度范围：https://www.processon.com/diagraming/6389af387d9c086a817e3d58

    function getZone2Range(device) 

        local min = 0

        local max = 100

        --房间温度开启，就直接用房间温度的范围

        if (device.status.zone2_temp_type == 'room_temperature_type') then

            min = device.status.room_min_set_temp

            max = device.status.room_max_set_temp

         else 

            if(getActualRunMode(device) == 'cool') then 

                min = device.status.zone2_cool_min_set_temp

                max = device.status.zone2_cool_max_set_temp

            elseif(getActualRunMode(device) == 'heat') then 

                min = device.status.zone2_heat_min_set_temp

                max = device.status.zone2_heat_max_set_temp

            end

        end



        return {

            max =  tonumber(max),

            min =  tonumber(min)

        }

    end    



    -- zone1 temperature 特殊互斥实现 

    local function zone1TemperatureDoMutex(device)

        local isOk = true



      



        --线控器在运行休假中，不能设置温度.

        if (isHolidayActived( device)) then 

            isOk = false

        --ECO开启 &&  出水温度，不能设置温度.

        elseif (isEcoActived(device) and not(isZone1RoomTemp(device))) then

            isOk = false

        elseif (isDisabled(device)) then

            isOk = false

        end



        if(isOk == false) then

            if(device['status']['zone1_temp_set'] ~= nil) then 

                device['control']['zone1_temp_set'] = device['status']['zone1_temp_set']--把原来原来的值复制到control中

            end





            -- 如果当前是房间温度，则把房间温度也复位

            if (device.status.zone1_temp_type == 'room_temperature_type') then

                if(device['status']['room_temp_set'] ~= nil) then 

                    device['control']['room_temp_set'] = device['status']['room_temp_set']--把原来原来的值复制到control中

                end

            end

        else  

            local range = getRange(device) --获取温度范围

            local tempValue = tonumber(device['control']['zone1_temp_set']) --设置的值

            

            if (tempValue < range.min) then

                tempValue = range.min

            elseif (tempValue > range.max) then

                tempValue = range.max

            end



            --[[

                如果zone1用的是房间温度(zone1_temp_type == room_temperature_type)，

                就用房间温度的值(room_temp_set),同时zone1_temp_set也要下发新值(原因：实测发现zone1开启房间温度后，通过插件下发 room_temp_set设为 x值， zone1_temp_set 和 zone2_temp_set也会在之后的主动上报中变为x值,因此在这种情况下，room_temp_set和 zone1_temp_set的值要保持一致)；

                否则，就用zone1温度的值(zone1_temp_set)

            --]]

            if (device.status.zone1_temp_type == 'room_temperature_type') then

                device['control']['room_temp_set']  = tempValue                  

            end

             

            device['control']['zone1_temp_set'] = tempValue

        end

    end

    

    -- zone2 temperature 特殊互斥实现

    local function zone2TemperatureDoMutex(device)

        local isOk = true



        if (not(isDoubleZoneEnable(device))) then

            isOk = false

        --线控器在运行休假中，不能设置温度.

        elseif (isHolidayActived(device)) then

            isOk = false

        elseif (not(hasCurveNewKey(device)) and isZone2CurveOn(device))then 

            -- 旧版本判断

            isOk = false

         elseif (

            (getActualRunMode(device) == 'heat' and isZone2HeatCurveStateOn(device)) or

            (getActualRunMode(device) == 'cool' and isZone2CoolCurveStateOn(device))

        ) then

            isOk = false

        elseif (isDisabled(device)) then

            isOk = false

        end



        if(isOk == false) then

            if(device['status']['zone2_temp_set'] ~= nil) then 

                device['control']['zone2_temp_set'] = device['status']['zone2_temp_set']--把原来原来的值复制到control中

            end 





             -- 如果当前是房间温度，则把房间温度也复位

            if (device.status.zone2_temp_type == 'room_temperature_type') then

                if(device['status']['room_temp_set'] ~= nil) then 

                    device['control']['room_temp_set'] = device['status']['room_temp_set']--把原来原来的值复制到control中

                end

            end            

        else

            local range = getZone2Range(device) --获取温度范围

            local tempValue = tonumber(device['control']['zone2_temp_set']) --设置的值

            

            if (tempValue < range.min) then

                tempValue = range.min

            elseif (tempValue > range.max) then

                tempValue = range.max

            end





             --[[

                如果zone2用的是房间温度(zone2_temp_type == room_temperature_type)，

                就用房间温度的值(room_temp_set),同时zone2_temp_set也要下发新值(原因：实测发现zone2开启房间温度后，通过插件下发 room_temp_set设为 x值， zone2_temp_set 也会在之后的主动上报中变为x值,因此在这种情况下，room_temp_set和 zone2_temp_set的值要保持一致)；

                否则，就用zone2温度的值(zone1_temp_set)

            --]]

            if (device.status.zone2_temp_type == 'room_temperature_type') then

                device['control']['room_temp_set']  = tempValue

            end           

            

             device['control']['zone2_temp_set'] = tempValue

        end

    end



    -- anylysisCode 是国际美居场景的特殊标识

    if(json['anylysisCode'] ~= nil) then

        -- 要根据control中要控制的字段更新

        for key, value in pairs(json['control']) do

            if( key == 'zone1_power_state') then

                doMutexByTable(json,{_zone1_power_})

            elseif (key == 'zone2_power_state') then

                doMutexByTable(json,{_zone2_power_})

                zone2PowerDoMutex(json)

            elseif (key == 'run_mode_set') then

                doMutexByTable(json,{ ___mode_set__})

                modeDoMutex(json)

            elseif (key == 'zone1_temp_set') then

                zone1TemperatureDoMutex(json)

            elseif (key == 'zone2_temp_set') then

                zone2TemperatureDoMutex(json)

            end

        end

    end

end



-- 接口方法，json转二进制，可传入原状态，此方法不能使用local修饰

function jsonToData(jsonCmdStr)

    if (#jsonCmdStr == 0) then

        return nil

    end

    local msgBytes



    local json = decodeJsonToTable(jsonCmdStr)



    -- local deviceSubType = json["deviceinfo"]["deviceSubType"]



    local query = json["query"]

    local control = json["control"]

    local status = json["status"]

    local bodyBytes = {}

    

    if (control) then

        sceneDoMutex(json)



        -- 兼容旧版本

        -- if status == nil then

            status = {}

        -- end



        -- 在 Lua 中使用 control 中的属性覆盖 status 中的属性

        for k, v in pairs(control) do

            status[k] = v

        end



        --将用户控制 转换为属性

        local cmd_x = updateGlobalPropertyValueByJson(status)



        bodyBytes = assembleGlobalPropertyValueByJson(status, cmd_x)

        -- for debug

        -- debugPrint("assembleGlobalPropertyValueByJson")

        -- print_lua_table(bodyBytes)

        

        msgBytes = assembleUart(bodyBytes, BYTE_CONTROL_REQUEST)



        -- -- for debug

        -- debugPrint("assembleUart")

        -- print_lua_table(msgBytes)

        

    --当前是查询指令，构造固定的二进制即可

    elseif (query) then



        bodyBytes = assembleQueryValueByJson(query)

        -- for debug

        -- print_lua_table(bodyBytes)



        msgBytes = assembleUart(bodyBytes, BYTE_QUERY_REQUEST)

        -- for debug

        -- debugPrint("assembleUart")

        -- print_lua_table(msgBytes)

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

    -- for debug

    -- debugPrint(ret)



    return ret

end



-- 接口方法，二进制转json，此方法不能使用local修饰

function dataToJson(jsonStr)

    if (not jsonStr) then

        return nil

    end



    local json = decodeJsonToTable(jsonStr)



    -- local deviceinfo = json["deviceinfo"]



    --根据设备子类型来处理协议差异

    -- local deviceSubType = deviceinfo["deviceSubType"]

    -- if (deviceSubType == 1) then

    -- end



    local binData = json["msg"]["data"]



    local bodyBytes = {}

    --包括Uart头

    local byteData = string2table(binData)



    --获取消息数据类型

    dataType = byteData[10]



    -- 补丁,增加消息校验码的校验

    if checkHeadBytes(byteData) == true then

        bodyBytes = extractBodyBytes(byteData)

    end



    -- for debug

    -- print_lua_table(bodyBytes)



    --将二进制状态解析为属性值

    -- todo: 不需要?

    -- local ret = updateGlobalPropertyValueByByte(bodyBytes)



    local retTable = {}

    --将属性转换为table

    retTable["status"], retTable["from"] = assembleJsonByByte(bodyBytes)

    -- print_lua_table(retTable["status"])



    -- 以下是 兼容补丁



    -- 处理 lua 版本

    retTable['status']['version'] = string.format("%d.%d.%d", LUA_VERSION[1], LUA_VERSION[2], LUA_VERSION[3])



    -- 兼容v1版本 错误码处理

    if  retTable['status']['error_new_code'] ~= nil then

        retTable['status']['error_code'] = retTable['status']['error_new_code']

    end



    -- 兼容旧版本，主动上报命令子类型

    if retTable['status']["u16_table"] ~= nil then

        -- 查询

        if dataType == BYTE_QUERY_REQUEST then

            retTable['query_type'] = retTable['status']["u16_table"]

            retTable['status']['query_type'] = retTable['query_type']

        -- 控制

        elseif dataType == BYTE_CONTROL_REQUEST then

            retTable['control_type'] = retTable['status']["u16_table"]

            retTable['status']['control_type'] = retTable['control_type']

        -- 上报

        elseif dataType == 0x04 then

            retTable['msg_up_type'] = retTable['status']["u16_table"]

            retTable['status']['msg_up_type'] = retTable['msg_up_type']

        end

        retTable['cmd_type'] = retTable['status']["u16_table"]

        retTable['status']['cmd_type'] = retTable['cmd_type']

    end



    if true then

        retTable['status']["u8_protocol"] = nil

        retTable['status']["u16_table"]   = nil

        retTable['status']["u8_profile"] = nil

        retTable['status']["u8_format"]  = nil

        retTable['status']["u8_reserved"] = nil

    end



    -- 对内外机版本号打补丁，变量 _iduVersion/_oduVersion 是HMI显示的版本

    patch_iduversion(retTable)

    patch_oduversion(retTable)



    -- 兼容结束



    --将table转换为json

    local ret = encodeTableToJson(retTable)



    -- for debug

    -- debugPrint(ret)



    return ret

end

