local bit = require "bit"
local function dLog(str) end
local SUB_TYPE_VALUE = 12
local VERSION = 9
local BYTE_PROTOCOL_HEAD = 0xAA
local BYTE_PROTOCOL_LENGTH = 0x0A
local BYTE_DEVICE_TYPE = 0xB8
local MOVEMENT_CODE = {
    none = 0x00,
    forward = 0x01,
    back = 0x02,
    left = 0x03,
    right = 0x04
}
local CLEAN_MODE_CODE = {
    none = 0x00,
    random = 0x01,
    arc = 0x02,
    edge = 0x03,
    emphases = 0x04,
    screw = 0x05,
    bed = 0x06,
    wide_screw = 0x07,
    auto = 0x08,
    area = 0x09,
    deep = 0x0a
}
local FAN_LEVEL_CODE = {off = 0x00, low = 0x01, normal = 0x02, high = 0x03}
local WATER_LEVEL_CODE = {off = 0x00, low = 0x01, normal = 0x02, high = 0x03}
local SPEAK_LEVEL_CODE = {
    none = 0x00,
    off = 0x01,
    low = 0x02,
    normal = 0x03,
    high = 0x04
}
local JSON = require("cjson")
local function bitAt(bin, ops)
    local tgt = bit.lshift(1, ops)
    if bit.band(bin, tgt) == tgt then
        return true
    else
        return false
    end
end
local function initMessageArray(len)
    local arr = {}
    for i = 0, len - 1 do arr[i] = 0 end
    arr[0] = BYTE_PROTOCOL_HEAD
    arr[1] = len
    arr[2] = BYTE_DEVICE_TYPE
    return arr
end
local function checkValidJson(j)
    local rst = true
    local deviceInfo = j["deviceinfo"]
    if not deviceInfo then return false end
    local deviceSubType = deviceInfo["deviceSubType"] or ""
    deviceSubType = tonumber(deviceSubType) or 0
    if deviceSubType ~= SUB_TYPE_VALUE then rst = false end
    return rst
end
local function makeSum(tmpBuf, endPos)
    local resVal = 0
    for i = 1, endPos do
        resVal = resVal + tmpBuf[i]
        if resVal > 0xff then resVal = bit.band(resVal, 0xff) end
    end
    if resVal == 0 then return 0 end
    resVal = 255 - resVal + 1
    return resVal
end
local function addSumAndConvertMsgToHexString(msg, len)
    msg[len] = makeSum(msg, len - 1)
    local bin = ""
    for i = 0, len do bin = bin .. string.format("%02x", msg[i]) end
    return bin
end
local function convertWeekdayToByte(weekday)
    dLog("预约日期转换 input : " .. weekday)
    local rst = 0x0
    for i = 1, 7 do
        p, _ = string.find(weekday, tostring(i))
        if p ~= nil and p > 0 then
            rst = bit.bxor(rst, bit.lshift(0x01, i - 1))
        end
    end
    rst = bit.bxor(rst, bit.lshift(0x01, 7))
    dLog("预约日期转换 output: " .. rst)
    return rst
end
local function convertYmdToBytes(ymd)
    dLog("预约年月日转换 input : " .. ymd)
    if #ymd ~= 8 then return 0, 0, 0 end
    local y = string.sub(ymd, 1, 4)
    local m = string.sub(ymd, 5, 6)
    local d = string.sub(ymd, 7, 8)
    y = (tonumber(y) or 1900) - 1900
    m = tonumber(m) or 0
    d = tonumber(d) or 0
    if y < 0 or y > 255 then y = 0 end
    if m < 1 or m > 12 then m = 1 end
    if d < 1 or d > 31 then d = 1 end
    dLog("预约年月日转换output : " .. y .. ":" .. m .. ":" .. d)
    return y, m, d
end
local function convertTimeToBytes(time)
    dLog("预约时间转换 input: " .. time)
    if #time ~= 6 then return 0, 0, 0 end
    local h = string.sub(time, 1, 2)
    local m = string.sub(time, 3, 4)
    local s = string.sub(time, 5, 6)
    h = tonumber(h) or 0
    m = tonumber(m) or 0
    s = tonumber(s) or 0
    if h < 0 or h > 23 then h = 0 end
    if m < 0 or m > 59 then m = 0 end
    if s < 0 or s > 59 then s = 0 end
    dLog("预约时间转换output: " .. h .. ":" .. m .. ":" .. s)
    return h, m, s
end
local function handleMovementJson(json)
    local move = json["move_direction"] or "none"
    local msgLen = 20
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x22
    msg[11] = 0x02
    msg[13] = 0x01
    msg[14] = MOVEMENT_CODE[move]
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleWorkModeJson(json)
    local cleanMode = json["work_mode"] or "arc"
    local fanLevel = json["fan_level"] or "normal"
    local waterLevel = json["water_level"] or "low"
    local speakLevel = json["speak_level"] or "none"
    local msgLen = 20
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x22
    msg[11] = 0x02
    msg[13] = 0x02
    msg[15] = CLEAN_MODE_CODE[cleanMode]
    msg[16] = FAN_LEVEL_CODE[fanLevel]
    msg[18] = WATER_LEVEL_CODE[waterLevel]
    msg[19] = SPEAK_LEVEL_CODE[speakLevel]
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleChargeStopJson(json)
    local workMode = json["work_status"]
    local msgLen = 13
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x22
    if workMode == "charge" then
        msg[11] = 0x01
    elseif workMode == "stop" then
        msg[11] = 0x03
    end
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleDisturbJson(json)
    local value = json["disturb_switch"] or "off"
    local startTime = json["disturb_start_time"]
    local endTime = json["disturb_end_time"]
    local msgLen = 17
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x22
    msg[11] = 0x06
    if value == "on" then
        msg[12] = 0x01
        if #startTime ~= 5 or #endTime ~= 5 then return nil end
        local startHour = string.sub(startTime, 1, 2)
        local startMin = string.sub(startTime, 4, 5)
        local endHour = string.sub(endTime, 1, 2)
        local endMin = string.sub(endTime, 4, 5)
        msg[13] = tonumber(startHour) or 0
        msg[14] = tonumber(startMin) or 0
        msg[15] = tonumber(endHour) or 0
        msg[16] = tonumber(endMin) or 0
    end
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleVoiceVolumeJson(json)
    local value = tonumber(json["voice_level"]) or 50
    if value < 0 then
        value = 0
    elseif value > 100 then
        value = 100
    end
    local msgLen = 13
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x22
    msg[11] = 0x0a
    msg[12] = value
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleReserveCreateJson(d)
    local cnt = 1
    local msgLen = 13 + 12
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x24
    msg[11] = 0x01
    msg[12] = 0x01
    local pos = 13
    local weekdays = d["reserve_weekdays"] or ""
    local startDate = d["reserve_start_date"] or ""
    local startTime = d["reserve_start_time"] or ""
    local taskMinutes = d["reserve_task_minutes"] or "60"
    local cleanMode = d["reserve_work_mode"] or "arc"
    local fanLevel = d["reserve_fan_level"] or "normal"
    local waterLevel = d["reserve_water_level"] or "low"
    local taskId = d["reserve_task_id"]
    local weekdayByte = convertWeekdayToByte(weekdays)
    local year, month, day = convertYmdToBytes(startDate)
    local hour, min, sec = convertTimeToBytes(startTime)
    local taskMin = tonumber(taskMinutes) or 0
    if taskMin < 0 or taskMin > 120 then taskMin = 0 end
    cleanMode = CLEAN_MODE_CODE[cleanMode]
    fanLevel = FAN_LEVEL_CODE[fanLevel]
    waterLevel = WATER_LEVEL_CODE[waterLevel]
    taskId = tonumber(taskId) or i
    msg[pos] = weekdayByte
    msg[pos + 1] = year
    msg[pos + 2] = month
    msg[pos + 3] = day
    msg[pos + 4] = hour
    msg[pos + 5] = min
    msg[pos + 6] = sec
    msg[pos + 7] = taskMin
    msg[pos + 8] = cleanMode
    msg[pos + 9] = fanLevel
    msg[pos + 10] = waterLevel
    msg[pos + 11] = taskId
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleReserveUpdateJson(action, taskId)
    if action == nil or taskId == nil then return nil end
    local tid = tonumber(taskId)
    if tid == nil then return nil end
    if tid < 1 or tid > 8 then return nil end
    local msgLen = 25
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x24
    msg[11] = 0x01
    if action == "delete" then
        msg[12] = 0x02
    elseif action == "on" then
        msg[12] = 0x06
    elseif action == "off" then
        msg[12] = 0x05
    end
    msg[24] = taskId
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleReserveJson(json)
    local action = json["reserve_action"] or ""
    local taskId = json["reserve_task_id"]
    if action == "set" then
        return handleReserveCreateJson(json)
    elseif action == "delete" or action == "on" or action == "off" then
        return handleReserveUpdateJson(action, taskId)
    end
    return nil
end
local function handleResetJson(json)
    local value = json["reset_type"] or ""
    local partsReset = 0x00
    local factoryReset = 0x00
    if value == "factory_restore" then
        factoryReset = 0x01
    elseif value == "side_brush" then
        partsReset = bit.lshift(1, 0)
    elseif value == "filter_net" then
        partsReset = bit.lshift(1, 1)
    elseif value == "roll_brush" then
        partsReset = bit.lshift(1, 2)
    end
    local msgLen = 14
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x22
    msg[11] = 0x07
    msg[12] = partsReset
    msg[13] = factoryReset
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleOTAJson(json)
    local value = json["ota_mode"] or ""
    local method = 0x00
    if value == "silent" then
        method = 0x00
    elseif value == "command" then
        method = 0x01
    else
        return nil
    end
    local msgLen = 13
    local msg = initMessageArray(msgLen)
    msg[9] = 0x02
    msg[10] = 0x22
    msg[11] = 0x09
    msg[12] = method
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleSubTypeJson(json)
    local msgLen = 30
    local msg = initMessageArray(msgLen)
    msg[9] = 0xA0
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function inRange(v, min, max)
    if v < min or v > max then
        return false
    else
        return true
    end
end
local function handleAppTimeJson(json)
    local msgLen = 18
    local msg = initMessageArray(msgLen)
    local year = tonumber(json["year"] or "0")
    local month = tonumber(json["month"] or "1")
    local day = tonumber(json["day"] or "1")
    local week = tonumber(json["week"] or "0")
    local hour = tonumber(json["hour"] or "0")
    local minute = tonumber(json["minute"] or "0")
    local second = tonumber(json["second"] or "0")
    if (inRange(year, 2000, 2099) and inRange(month, 1, 12) and
        inRange(day, 1, 31) and inRange(week, 0, 6) and inRange(hour, 0, 23) and
        inRange(minute, 0, 59) and inRange(second, 0, 59)) == false then
        return nil
    end
    msg[9] = 0x02
    msg[10] = 0x23
    msg[11] = year - 2000
    msg[12] = month
    msg[13] = day
    msg[14] = week
    msg[15] = hour
    msg[16] = minute
    msg[17] = second
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
local function handleControlJson(json)
    local workStatus = json["work_status"] or ""
    local movement = json["move_direction"] or ""
    if workStatus == "work" then
        if movement ~= nil and movement ~= "none" then
            return handleMovementJson(json)
        else
            return handleWorkModeJson(json)
        end
    elseif workStatus == "reserve" then
        return handleReserveJson(json)
    elseif workStatus == "charge" or workStatus == "stop" then
        return handleChargeStopJson(json)
    elseif workStatus == "disturb" then
        return handleDisturbJson(json)
    elseif workStatus == "voice" then
        return handleVoiceVolumeJson(json)
    elseif workStatus == "reset" then
        return handleResetJson(json)
    elseif workStatus == "ota" then
        return handleOTAJson(json)
    elseif workStatus == "sub" then
        return handleSubTypeJson(json)
    elseif workStatus == "time" then
        return handleAppTimeJson(json)
    end
    return nil
end
local function handleQueryJson(json)
    local value = json["query_type"] or "work"
    local msgLen = 12
    local msg = initMessageArray(msgLen)
    msg[9] = 0x03
    if value == "work" then
        msg[10] = 0x32
        msg[11] = 0x01
    elseif value == "disturb" then
        msg[10] = 0x32
        msg[11] = 0x05
    elseif value == "reserve" then
        msg[10] = 0x34
        msg[11] = 0x01
    elseif value == "parts" then
        msg[10] = 0x35
        msg[11] = 0x01
    end
    return addSumAndConvertMsgToHexString(msg, msgLen)
end
function jsonToData(jsonStr)
    if #jsonStr == 0 then return nil end
    local j = JSON.decode(jsonStr)
    if checkValidJson(j) == false then return nil end
    if j["control"] ~= nil then
        return handleControlJson(j["control"])
    elseif j["query"] ~= nil then
        return handleQueryJson(j["query"])
    end
    return nil
end
local WORK_STATUS_CODE = {
    charge = 0x01,
    work = 0x02,
    stop = 0x03,
    charging_on_dock = 0x04,
    reserve_task_finished = 0x05,
    charge_finish = 0x06,
    charging_with_wire = 0x07
}
local CONTROL_TYPE_CODE = {none = 0x00, manual = 0x01, auto = 0x02}
local CLEAN_FUNCTION_MODE = {dust_box = 0x01, water_tanker = 0x02}
local ERR_INFRA_RED_LOW_CODE = {
    none = 0x07,
    none = 0x06,
    infra_red_low_right_back_fall = 0x05,
    infra_red_low_left_back_fall = 0x04,
    infra_red_low_right_hanging = 0x03,
    infra_red_low_left_hanging = 0x02,
    infra_red_low_right_collision = 0x01,
    infra_red_low_left_collision = 0x00,
    infra_red_low_center_collision = 0x08
}
local ERR_INFRA_RED_HIGH_CODE = {
    infra_red_high_left_front_obstacle = 0x07,
    infra_red_high_right_front_obstacle = 0x06,
    infra_red_high_front_obstacle = 0x05,
    infra_red_high_left_obstacle = 0x04,
    infra_red_high_right_obstacle = 0x03,
    infra_red_high_right_fall = 0x02,
    infra_red_high_front_fall = 0x01,
    infra_red_high_left_fall = 0x00
}
local ERR_FAILURE_LOW_CODE = {
    failure_low_no_dust_box = 0x07,
    failure_low_dust_box_full = 0x06,
    failure_low_water_tank_overload = 0x05,
    failure_low_fan = 0x04,
    failure_low_right_side_brush = 0x03,
    failure_low_left_side_brush = 0x02,
    failure_low_right_wheel_overload = 0x01,
    failure_low_left_wheel_overload = 0x00
}
local ERR_FAILURE_MID_CODE = {
    failure_mid_front_collision_switch = 0x07,
    failure_mid_roll_brush = 0x06,
    failure_mid_right_back_fall_sensor = 0x05,
    failure_mid_left_back_fall_sensor = 0x04,
    failure_mid_right_back_hanging_sensor = 0x03,
    failure_mid_left_back_hanging_sensor = 0x02,
    failure_mid_right_collision_switch = 0x01,
    failure_mid_left_collision_switch = 0x00
}
local ERR_FAILURE_HIGH_CODE = {
    failure_high_left_front_infra_red = 0x07,
    failure_high_right_front_infra_red = 0x06,
    failure_high_front_infra_red = 0x05,
    failure_high_left_infra_red = 0x04,
    failure_high_right_infra_red = 0x03,
    failure_high_right_drop_sensor = 0x02,
    failure_high_front_drop_sensor = 0x01,
    failure_high_left_drop_sensor = 0x00
}
local ERR_USER_LOW_CODE = {
    user_low_no_dust_box = 0x07,
    user_low_dust_box_full = 0x06,
    user_low_no_water_tank = 0x05,
    user_low_water_pump = 0x04,
    user_low_no_water = 0x03,
    user_low_charging_switch_off = 0x02,
    user_low_charge_error = 0x01,
    user_low_network_failure = 0x00
}
local ERR_USER_MID_CODE = {
    none = 0x07,
    none = 0x06,
    none = 0x05,
    none = 0x04,
    none = 0x03,
    user_mid_less_battery = 0x02,
    user_mid_camera = 0x01,
    user_mid_engine = 0x00
}
local QUERY_STATUS_SUM_CODE = {
    user_fault_sign = 0x07,
    user_cmd_up_down_sign = 0x06,
    none = 0x05,
    none = 0x04,
    none = 0x03,
    user_voice_switch = 0x02,
    user_wifi_light_sign = 0x01,
    user_uv_light_sign = 0x00
}
local STATUS_SUM_CODE = {
    user_fault_sign = 0x07,
    user_cmd_up_down_sign = 0x06,
    user_connect_net_sign = 0x05,
    none = 0x04,
    none = 0x03,
    user_voice_switch = 0x02,
    user_wifi_light_sign = 0x01,
    user_uv_light_sign = 0x00
}
local USER_LOW_CODE = {
    low_no_dust_box = 0x07,
    low_dust_box_full = 0x06,
    none = 0x05,
    system_can_upgrade = 0x04,
    low_no_water = 0x03,
    low_charging_switch_off = 0x02,
    low_panel_stuck = 0x01,
    low_wheel_hang = 0x00
}
local USER_MID_CODE = {
    none = 0x07,
    roller_fault_sign = 0x06,
    right_brush_fault_sign = 0x05,
    left_brush_fault_sign = 0x04,
    motor_fault_sign = 0x03,
    right_wheel_overload = 0x02,
    left_wheel_overload = 0x01,
    fall_down_sign = 0x00
}
local function getCodeStr(dict, value)
    for k, v in pairs(dict) do if v == value then return k end end
    return "none"
end
local function convertWorkdaysFromByte(weekdayByte)
    local rst = ""
    for i = 1, 7 do
        if bit.band(weekdayByte, bit.lshift(0x01, i - 1)) > 0 then
            rst = rst .. tostring(i)
        end
    end
    return rst
end
local function convertStringToInt(data)
    local strCnt = #data
    local byteCnt = strCnt / 2
    local rst = {}
    rst[0] = 0xaa
    for i = 1, byteCnt - 1 do
        local currStr = string.sub(data, i * 2 + 1, i * 2 + 2)
        local value = tonumber(currStr, 16) or 0
        rst[i] = value
    end
    return rst
end
local function wrapTableToJson(_, table)
    local out = {}
    table["version"] = VERSION
    table["sub_type_value"] = SUB_TYPE_VALUE
    out["status"] = table
    return JSON.encode(out)
end
local function decodeWorkBin(bin)
    local workMode = bin[11]
    local controlMode = bin[13]
    local moveDirection = bin[14]
    local cleanMode = bin[15]
    local fanLevel = bin[16]
    local waterLevel = bin[18]
    local speakLevel = bin[19]
    local control = {}
    if workMode == 0x02 then
        control["work_status"] = "work"
        if controlMode == 0x02 then
            control["work_mode"] = getCodeStr(CLEAN_MODE_CODE, cleanMode)
        elseif controlMode == 0x01 then
            control["move_direction"] = getCodeStr(MOVEMENT_CODE, moveDirection)
        end
        control["fan_level"] = getCodeStr(FAN_LEVEL_CODE, fanLevel)
        control["water_level"] = getCodeStr(WATER_LEVEL_CODE, waterLevel)
        control["speak_level"] = getCodeStr(SPEAK_LEVEL_CODE, speakLevel)
    end
    return wrapTableToJson("status", control)
end
local function decodeChargeStopBin(bin)
    local workMode = bin[11]
    local control = {}
    if workMode == 0x01 then
        control["work_status"] = "charge"
    elseif workMode == 0x03 then
        control["work_status"] = "stop"
    end
    return wrapTableToJson("status", control)
end
local function decodeDisturbBin(bin)
    local value = bin[12]
    local startHour = bin[13]
    local startMin = bin[14]
    local endHour = bin[15]
    local endMin = bin[16]
    local startTime = string.format("%02d:%02d", startHour, startMin)
    local endTime = string.format("%02d:%02d", endHour, endMin)
    local control = {}
    control["work_status"] = "disturb"
    if value == 0x01 then
        control["value"] = "on"
        control["start_time"] = startTime
        control["end_time"] = endTime
    else
        control["value"] = "off"
    end
    return wrapTableToJson("status", control)
end
local function decodeReserveBin(bin)
    local action = bin[12]
    local msgLen = bin[1]
    local reserveCnt = (msgLen - 13) / 12
    local firstTaskId = bin[24]
    local control = {}
    control["work_status"] = "reserve"
    if action == 0x01 then
        control["action"] = "set"
        local data = {}
        for reserveIndex = 0, reserveCnt - 1 do
            local outIdx = reserveIndex + 1
            data[outIdx] = {}
            local pos = 13 + reserveIndex * 12
            local weekdayByte = bin[pos]
            local hour = bin[pos + 4]
            local min = bin[pos + 5]
            local sec = bin[pos + 6]
            local taskMin = bin[pos + 7]
            local cleanMode = bin[pos + 8]
            local fanLevel = bin[pos + 9]
            local waterLevel = bin[pos + 10]
            local taskId = bin[pos + 11]
            local switch = bin[pos + 12]
            if msgLen == pos + 12 then switch = 0 end
            data[outIdx]["reserve_weekdays"] =
                convertWorkdaysFromByte(weekdayByte)
            data[outIdx]["reserve_start_time"] =
                string.format("%02d%02d%02d", hour, min, sec)
            data[outIdx]["reserve_task_minutes"] = tostring(taskMin)
            data[outIdx]["reserve_work_mode"] =
                getCodeStr(CLEAN_MODE_CODE, cleanMode)
            data[outIdx]["reserve_fan_level"] =
                getCodeStr(FAN_LEVEL_CODE, fanLevel)
            data[outIdx]["reserve_water_level"] =
                getCodeStr(WATER_LEVEL_CODE, waterLevel)
            data[outIdx]["reserve_task_id"] = tostring(taskId)
            data[outIdx]["reserve_switch"] = switch == 0 and "on" or "off"
        end
        control["data"] = data
    elseif action == 0x02 then
        control["action"] = "delete"
        control["task_id"] = firstTaskId
    elseif action == 0x05 then
        control["action"] = "off"
        control["task_id"] = firstTaskId
    elseif action == 0x06 then
        control["action"] = "on"
        control["task_id"] = firstTaskId
    end
    return wrapTableToJson("status", control)
end
local function decodeTimeBin(bin)
    local year = bin[11]
    local month = bin[12]
    local day = bin[13]
    local week = bin[14]
    local hour = bin[15]
    local minute = bin[16]
    local second = bin[17]
    local control = {}
    control["work_status"] = "time"
    control["year"] = tostring(year + 2000)
    control["month"] = tostring(month)
    control["day"] = tostring(day)
    control["week"] = tostring(week)
    control["hour"] = tostring(hour)
    control["minute"] = tostring(minute)
    control["second"] = tostring(second)
    return wrapTableToJson("status", control)
end
local function decodeVoiceVolumeBin(bin)
    local action = bin[12]
    local control = {}
    control["work_status"] = "voice"
    control["value_level"] = tostring(action)
    return wrapTableToJson("status", control)
end
local function decodeResetBin(bin)
    local parts = bin[12]
    local factoryReset = bin[13]
    local control = {}
    control["work_status"] = "reset"
    if factoryReset == 0x01 then
        control["reset_type"] = "factory_restore"
    elseif parts == bit.lshift(1, 0) then
        control["reset_type"] = "side_brush"
    elseif parts == bit.lshift(1, 1) then
        control["reset_type"] = "filter_net"
    elseif parts == bit.lshift(1, 2) then
        control["reset_type"] = "roll_brush"
    end
    return wrapTableToJson("status", control)
end
local function decodeOTABin(bin)
    local control = {}
    local mod = bin[12]
    if mod == 0x01 then
        control["ota_mode"] = "command"
        control["ota_result"] = "succeed"
    elseif mod == 0x00 then
        control["ota_mode"] = "silent"
        control["ota_result"] = "failed"
    end
    return wrapTableToJson("status", control)
end
local function decodeControlData(bin)
    local msgSubType = bin[10]
    local workMode = bin[11]
    if msgSubType == 0x22 then
        if workMode == 0x02 then
            return decodeWorkBin(bin)
        elseif workMode == 0x01 or workMode == 0x03 then
            return decodeChargeStopBin(bin)
        elseif workMode == 0x06 then
            return decodeDisturbBin(bin)
        elseif workMode == 0x07 then
            return decodeResetBin(bin)
        elseif workMode == 0x09 then
            return decodeOTABin(bin)
        elseif workMode == 0x0a then
            return decodeVoiceVolumeBin(bin)
        end
    elseif msgSubType == 0x23 then
        return decodeTimeBin(bin)
    elseif msgSubType == 0x24 then
        return decodeReserveBin(bin)
    end
    return bin
end
local function decodeQueryWorkStatusBin(bin)
    local workStatus = bin[12]
    local controlType = bin[14]
    local movement = bin[15]
    local cleanMode = bin[16]
    local fanLevel = bin[17]
    local area = bin[18]
    local waterLevel = bin[19]
    local voiceVolume = bin[20]
    local reserveWeekday = bin[21]
    local batteryRatio = bin[22]
    local workMin = bin[23]
    local errUserSum = bin[24] or 0
    local errUserLow = bin[25] or 0
    local errUserMid = bin[26] or 0
    local mop = bin[27] or 0
    local query = {}
    query["query_type"] = "work"
    if controlType == nil then return wrapTableToJson("status", query) end
    for i = 0, 7 do
        local keySum = getCodeStr(QUERY_STATUS_SUM_CODE, i)
        local valueSum = bitAt(errUserSum, i)
        if keySum ~= nil and keySum ~= "none" then
            query[keySum] = valueSum == true and "yes" or "no"
        end
        local keyLow = getCodeStr(USER_LOW_CODE, i)
        local valueLow = bitAt(errUserLow, i)
        if keyLow ~= nil and keyLow ~= "none" then
            query[keyLow] = valueLow == true and "yes" or "no"
        end
        local keyMid = getCodeStr(USER_MID_CODE, i)
        local valueMid = bitAt(errUserMid, i)
        if keyMid ~= nil and keyMid ~= "none" then
            query[keyMid] = valueMid == true and "yes" or "no"
        end
    end
    query["work_status"] = getCodeStr(WORK_STATUS_CODE, workStatus)
    query["control_type"] = getCodeStr(CONTROL_TYPE_CODE, controlType)
    query["move_direction"] = getCodeStr(MOVEMENT_CODE, movement)
    query["work_mode"] = getCodeStr(CLEAN_MODE_CODE, cleanMode)
    query["fan_level"] = getCodeStr(FAN_LEVEL_CODE, fanLevel)
    query["area"] = tostring(area)
    query["water_level"] = getCodeStr(WATER_LEVEL_CODE, waterLevel)
    query["voice_level"] = tostring(voiceVolume)
    if reserveWeekday == 0 then
        query["have_reserve_task"] = "0"
    else
        query["have_reserve_task"] = "1"
    end
    query["battery_percent"] = tostring(batteryRatio)
    query["work_time"] = tostring(workMin)
    query["mop"] = mop == 0x1 and "yes" or "no"
    return wrapTableToJson("status", query)
end
local function decodeQueryDisturbBin(bin)
    local setStatus = bin[12] or 0
    local startHour = bin[13] or 0
    local startMin = bin[14] or 0
    local endHour = bin[15] or 0
    local endMin = bin[16] or 0
    if bin[1] == 12 then
        local query = {}
        query["query"] = "disturb"
        return wrapTableToJson("query", query)
    end
    local query = {}
    query["query_type"] = "disturb"
    if setStatus == 0x00 then
        query["set_status"] = "off"
    else
        query["set_status"] = "on"
        query["start_time"] = string.format("%02d:%02d", startHour, startMin)
        query["end_time"] = string.format("%02d:%02d", endHour, endMin)
    end
    return wrapTableToJson("status", query)
end
local function decodeQueryObserverBin(bin)
    if bin[1] == 0x0c then
        local query = {}
        query["query"] = "reserve"
        return wrapTableToJson("query", query)
    end
    local reserveCnt = (bin[01] - 13) / 9
    local query = {}
    query["query_type"] = "reserve"
    local data = {}
    if reserveCnt > 0 then
        for i = 0, reserveCnt - 1 do
            local pos = 13 + 9 * i
            local weekdayByte = bin[pos]
            local hour = bin[pos + 1]
            local min = bin[pos + 2]
            local taskMin = bin[pos + 3]
            local cleanMode = bin[pos + 4]
            local fanLevel = bin[pos + 5]
            local waterLevel = bin[pos + 6]
            local taskId = bin[pos + 7]
            local isOpen = bin[pos + 8]
            data[i + 1] = {}
            data[i + 1]["weekdays"] = convertWorkdaysFromByte(weekdayByte)
            data[i + 1]["start_time"] = string.format("%02d%02d", hour, min)
            data[i + 1]["task_minutes"] = tostring(taskMin)
            data[i + 1]["work_mode"] = getCodeStr(CLEAN_MODE_CODE, cleanMode)
            data[i + 1]["fan_level"] = getCodeStr(FAN_LEVEL_CODE, fanLevel)
            data[i + 1]["water_level"] =
                getCodeStr(WATER_LEVEL_CODE, waterLevel)
            data[i + 1]["task_id"] = tostring(taskId)
            data[i + 1]["open_status"] = isOpen == 0x00 and "on" or "off"
        end
    end
    query["data"] = data
    return wrapTableToJson("status", query)
end
local function decodeQueryParts(bin)
    if bin[1] == 0x0c then
        local query = {}
        query["query"] = "parts"
        return wrapTableToJson("query", query)
    end
    local sideBrushRestTime = bit.lshift(bin[13], 8) + bin[12]
    local sideBrushLifeTime = bit.lshift(bin[15], 8) + bin[14]
    local filterNetRestTime = bit.lshift(bin[17], 8) + bin[16]
    local filterNetLifeTime = bit.lshift(bin[19], 8) + bin[18]
    local rollBrushRestTime = bit.lshift(bin[21], 8) + bin[20]
    local rollBrushLifeTime = bit.lshift(bin[23], 8) + bin[22]
    local query = {}
    query["side_brush_rest_time"] = tostring(sideBrushRestTime)
    query["side_brush_life_time"] = tostring(sideBrushLifeTime)
    query["filt_brNet_rest_time"] = tostring(filterNetRestTime)
    query["filt_brNet_life_time"] = tostring(filterNetLifeTime)
    query["roll_brush_rest_time"] = tostring(rollBrushRestTime)
    query["roll_brush_life_time"] = tostring(rollBrushLifeTime)
    return wrapTableToJson("status", query)
end
local function decodeQueryData(bin)
    local msgSubType = bin[10]
    local statusType = bin[11]
    if msgSubType == 0x32 then
        if statusType == 0x01 then
            return decodeQueryWorkStatusBin(bin)
        elseif statusType == 0x05 then
            return decodeQueryDisturbBin(bin)
        end
    elseif msgSubType == 0x34 then
        if statusType == 0x01 then return decodeQueryObserverBin(bin) end
    elseif msgSubType == 0x35 then
        return decodeQueryParts(bin)
    end
    return ""
end
local function decodeRunStatusData(bin)
    local msgSubType = bin[10]
    if msgSubType == 0x42 then end
    local workStatus = bin[11]
    local controlType = bin[13]
    local movement = bin[14]
    local cleanMode = bin[15]
    local fanLevel = bin[16]
    local area = bin[17]
    local waterLevel = bin[18]
    local voiceVolume = bin[19]
    local reserveWeekday = bin[20]
    local batteryRatio = bin[21]
    local workMin = bin[22]
    local statusSummaryLow = bin[23]
    local errUserLow = bin[24]
    local errUserMid = bin[25]
    local mop = bin[26]
    local query = {}
    query["version"] = VERSION
    query["work_status"] = getCodeStr(WORK_STATUS_CODE, workStatus)
    for i = 0, 7 do
        local key = getCodeStr(STATUS_SUM_CODE, i)
        local value = bitAt(statusSummaryLow, i)
        if key ~= nil and key ~= "none" then
            query[key] = value == true and "yes" or "no"
        end
        key = getCodeStr(USER_LOW_CODE, i)
        value = bitAt(errUserLow, i)
        if key ~= nil and key ~= "none" then
            query[key] = value == true and "yes" or "no"
        end
        key = getCodeStr(USER_MID_CODE, i)
        value = bitAt(errUserMid, i)
        if key ~= nil and key ~= "none" then
            query[key] = value == true and "yes" or "no"
        end
    end
    query["control_type"] = getCodeStr(CONTROL_TYPE_CODE, controlType)
    query["move_direction"] = getCodeStr(MOVEMENT_CODE, movement)
    query["work_mode"] = getCodeStr(CLEAN_MODE_CODE, cleanMode)
    query["fan_level"] = getCodeStr(FAN_LEVEL_CODE, fanLevel)
    query["area"] = tostring(area)
    query["water_level"] = getCodeStr(WATER_LEVEL_CODE, waterLevel)
    query["voice_level"] = tostring(voiceVolume)
    query["have_reserve_task"] = reserveWeekday == 0 and "yes" or "no"
    query["battery_percent"] = tostring(batteryRatio)
    query["work_time"] = tostring(workMin)
    query["mop"] = mop == 0x1 and "yes" or "no"
    return wrapTableToJson("status", query)
end
local function decodeSumData(bin)
    local msgSubType = bin[10]
    local sumType = bin[11]
    if msgSubType == 0x66 and sumType == 0x01 then
        local sideBrushRestTime = bit.lshift(bin[13], 8) + bin[12]
        local sideBrushLifeTime = bit.lshift(bin[15], 8) + bin[14]
        local filterNetRestTime = bit.lshift(bin[17], 8) + bin[16]
        local filterNetLifeTime = bit.lshift(bin[19], 8) + bin[18]
        local rollBrushRestTime = bit.lshift(bin[21], 8) + bin[20]
        local rollBrushLifeTime = bit.lshift(bin[23], 8) + bin[22]
        local query = {}
        query["side_brush_rest_time"] = tostring(sideBrushRestTime)
        query["side_brush_life_time"] = tostring(sideBrushLifeTime)
        query["filt_brNet_rest_time"] = tostring(filterNetRestTime)
        query["filt_brNet_life_time"] = tostring(filterNetLifeTime)
        query["roll_brush_rest_time"] = tostring(rollBrushRestTime)
        query["roll_brush_life_time"] = tostring(rollBrushLifeTime)
        return wrapTableToJson("status", query)
    end
    if msgSubType == 0x66 and sumType == 0x03 then
        local area = bin[12]
        local workMin = bin[13]
        local cleanMode = bin[14]
        local query = {}
        query["area"] = tostring(area)
        query["work_mode"] = getCodeStr(CLEAN_MODE_CODE, cleanMode)
        query["work_time"] = tostring(workMin)
        return wrapTableToJson("status", query)
    end
    return nil
end
local function decodeErrorReport(bin)
    local msgSubType = bin[10]
    local infra_red_low = bin[11] or 0
    local infra_red_high = bin[12] or 0
    local failure_low = bin[13] or 0
    local failure_mid = bin[14] or 0
    local failure_high = bin[15] or 0
    local user_info_low = bin[16] or 0
    local user_info_mid = bin[17] or 0
    local e = {}
    if msgSubType == 0xA1 then
        for i = 0, 7 do
            local key = getCodeStr(ERR_INFRA_RED_LOW_CODE, i)
            local value = bitAt(infra_red_low, i)
            if key ~= nil and key ~= "none" then
                e[key] = value == true and "yes" or "no"
            end
            key = getCodeStr(ERR_INFRA_RED_HIGH_CODE, i)
            value = bitAt(infra_red_high, i)
            if key ~= nil and key ~= "none" then
                e[key] = value == true and "yes" or "no"
            end
            key = getCodeStr(ERR_FAILURE_LOW_CODE, i)
            value = bitAt(failure_low, i)
            if key ~= nil and key ~= "none" then
                e[key] = value == true and "yes" or "no"
            end
            key = getCodeStr(ERR_FAILURE_MID_CODE, i)
            value = bitAt(failure_mid, i)
            if key ~= nil and key ~= "none" then
                e[key] = value == true and "yes" or "no"
            end
            key = getCodeStr(ERR_FAILURE_HIGH_CODE, i)
            value = bitAt(failure_high, i)
            if key ~= nil and key ~= "none" then
                e[key] = value == true and "yes" or "no"
            end
            key = getCodeStr(ERR_USER_LOW_CODE, i)
            value = bitAt(user_info_low, i)
            if key ~= nil and key ~= "none" then
                e[key] = value == true and "yes" or "no"
            end
            key = getCodeStr(ERR_USER_MID_CODE, i)
            value = bitAt(user_info_mid, i)
            if key ~= nil and key ~= "none" then
                e[key] = value == true and "yes" or "no"
            end
        end
        if bitAt(infra_red_low, 0) and bitAt(infra_red_low, 1) then
            e["infra_red_low_right_collision"] = nil
            e["infra_red_low_left_collision"] = nil
            e["infra_red_low_center_collision"] = "yes"
        end
    end
    return wrapTableToJson("status", e)
end
local function checkJsonData(j)
    local msg = j["msg"]
    if not msg then return false end
    local data = msg["data"]
    if not data then return false end
    return rst
end
local function checkBinSum(bin)
    local msgLen = bin[1]
    if msgLen > #bin then
        dLog("msgLen no valid")
        return false
    end
    if bin[0] ~= 0xaa then rst = false end
    if bin[2] ~= 0xb8 then rst = false end
    local realSum = makeSum(bin, msgLen - 1)
    if bin[msgLen] ~= realSum then
        dLog("check sum valid")
        return false
    end
    return true
end
function dataToJson(jsonStr)
    if #jsonStr == 0 then return nil end
    local j = JSON.decode(jsonStr)
    if checkValidJson(j) == false then return nil end
    local data = j["msg"]["data"]
    data = string.gsub(data, ",", "")
    local bin = convertStringToInt(data)
    if checkBinSum(bin) == false or checkJsonData(bin) then return nil end
    local msgType = bin[9]
    if msgType == 0x02 then
        return decodeControlData(bin)
    elseif msgType == 0x03 then
        return decodeQueryData(bin)
    elseif msgType == 0x04 then
        return decodeRunStatusData(bin)
    elseif msgType == 0x06 then
        return decodeSumData(bin)
    elseif msgType == 0x0A then
        return decodeErrorReport(bin)
    end
    return nil
end
