local bit = require "bit"
local VALUE_VERSION = 64
local JSON = require "cjson"
local VALUE_ON = "on"
local VALUE_OFF = "off"
local function getBit(oneByte, bitIndex)
    local bitBandList = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80}
    if bitIndex >= 0 and bitIndex <= 7 then
        if bit.band(oneByte, bitBandList[bitIndex + 1]) ==
            bitBandList[bitIndex + 1] then
            return '1'
        else
            return '0'
        end
    end
    return '2'
end
local function setBit(oneByte, bitIndex, value)
    local bitBorList = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80}
    local bitBandList = {0xFE, 0xFD, 0xFB, 0xF7, 0xEF, 0xDF, 0xBF, 0x7F}
    if bitIndex >= 0 and bitIndex <= 7 then
        if value == '1' or value == 1 then
            oneByte = bit.bor(oneByte, bitBorList[bitIndex + 1])
        elseif value == '0' or value == 0 then
            oneByte = bit.band(oneByte, bitBandList[bitIndex + 1])
        end
    end
    return oneByte
end
local function getNumber(x)
    local t = type(x)
    local rs = x
    if (t == "number") then
    elseif (t == "string") then
        rs = tonumber(x) or x
    end
    return rs
end
local function jsonArrToLuaArr(jsonArrStr)
    if JSON == nil then JSON = require "cjson" end
    local luaArray
    luaArray = JSON.decode(jsonArrStr)
    return luaArray
end
local function jsonToCmd(json, cmd)
    local query = json["query"]
    local ctrl = json["control"]
    if (ctrl) then
        cmd[10] = 0x02
        cmd[11] = 0x01
        if (ctrl.type == 'total') then
            cmd[12] = 0xF0
            cmd[13] = 0xff
            cmd[14] = 0xff
            if (ctrl.total_power == 'off') then
                cmd[14] = 0x01
            elseif (ctrl.total_power == 'on') then
                cmd[14] = 0x02
            end
            cmd[15] = 0xff
            if (ctrl.total_lock == 'off') then
                cmd[15] = 0x00
            elseif (ctrl.total_lock == 'on') then
                cmd[15] = 0x01
            end
            cmd[16] = 0xff
            cmd[17] = 0xff
            cmd[18] = 0xff
            cmd[19] = 0xff
            if (ctrl.ai_voice_microphone == 'on') then
                cmd[18] = 0x00
            elseif (ctrl.ai_voice_microphone == 'off') then
                cmd[18] = 0x01
            end
            if (ctrl.ai_voice_volume ~= nil) then
                cmd[19] = getNumber(ctrl.ai_voice_volume)
            end
        elseif (ctrl.type == 'b6') then
            cmd[12] = 0x01
            cmd[13] = 0x01
            cmd[14] = 0xff
            cmd[15] = 0xff
            if (ctrl.b6_power == 'on' or ctrl.b6_work_status == "working") then
                cmd[14] = 0x02
                cmd[15] = 0x02
            elseif (ctrl.b6_power == 'off' or ctrl.b6_work_status == "power_off" or
                ctrl.b6_steaming == 'off') then
                cmd[14] = 0x01
            elseif (ctrl.b6_power == 'delay_off' or ctrl.b6_work_status ==
                "power_off_delay") then
                cmd[14] = 0x03
            elseif (ctrl.b6_steaming == 'on' or ctrl.b6_work_status ==
                "hotclean") then
                cmd[14] = 0x04
            elseif (ctrl.b6_work_status == 'vvvf_gear') then
                cmd[14] = 0x08
            elseif (ctrl.b6_work_status == 'mute_gear') then
                cmd[14] = 0x09
            elseif (ctrl.b6_work_status == 'ai_dry_clean') then
                cmd[14] = 0x0a
            elseif (ctrl.b6_work_status == 'air_duct_detection') then
                cmd[14] = 0x0d
            end
            if (ctrl.b6_gear ~= nil) then
                cmd[14] = 0x02
                cmd[15] = getNumber(ctrl.b6_gear)
                if (cmd[15] == 0x00) then cmd[14] = 0x01 end
            end
            cmd[16] = 0xff
            cmd[17] = 0xff
            cmd[18] = 0xff
            if (ctrl.b6_light) then
                if (ctrl.b6_light == 'on') then
                    cmd[18] = 0x64
                    if (ctrl.b6_lightness) then
                        local lightness = getNumber(ctrl.b6_lightness)
                        if (lightness ~= 0x00) then
                            cmd[18] = lightness
                        end
                    end
                elseif (ctrl.b6_light == 'off') then
                    cmd[18] = 0x00
                end
            end
            cmd[19] = 0xff
            cmd[20] = 0xff
            cmd[21] = 0xff
            cmd[22] = 0xff
            if (ctrl.b6_setting == "gesture") then
                cmd[19] = 0x01
                cmd[20] = 0x01
                if (ctrl.b6_gesture_value == 'power') then
                    cmd[21] = 0x01
                elseif (ctrl.b6_gesture_value == 'wind') then
                    cmd[21] = 0x02
                elseif (ctrl.b6_gesture_value == 'light') then
                    cmd[21] = 0x03
                elseif (ctrl.b6_gesture_value == 'off') then
                    cmd[20] = 0x00
                end
            elseif (ctrl.b6_setting == "smoke_detector") then
                cmd[23] = 0x04
                cmd[24] = 0xff
                cmd[25] = 0xff
                if (ctrl.b6_smoke_detector == VALUE_ON) then
                    cmd[24] = 0x01
                elseif (ctrl.b6_smoke_detector == VALUE_OFF) then
                    cmd[24] = 0x00
                end
                if (ctrl.b6_smoke_detector_value and
                    getNumber(ctrl.b6_smoke_detector_value) == 0) then
                    cmd[23] = 0x04
                    cmd[24] = 0x00
                    cmd[25] = 0xff
                elseif (ctrl.b6_smoke_detector_value and
                    getNumber(ctrl.b6_smoke_detector_value) ~= 0) then
                    cmd[23] = 0x04
                    cmd[24] = 0x01
                    cmd[25] = getNumber(ctrl.b6_smoke_detector_value)
                end
            elseif (ctrl.b6_setting == "infrared") then
                cmd[19] = 0x03
                md[20] = 0x01
                if (ctrl.b6_infrared_value == 'power') then
                    cmd[21] = 0x01
                elseif (ctrl.b6_infrared_value == 'wind') then
                    cmd[21] = 0x02
                elseif (ctrl.b6_infrared_value == 'off') then
                    cmd[20] = 0x00
                end
            elseif (ctrl.b6_setting == "TVOC") then
                cmd[19] = 0x04
                if (ctrl.b6_TVOC == "on") then
                    cmd[20] = 0x01
                elseif (ctrl.b6_TVOC == "off") then
                    cmd[20] = 0x00
                end
            elseif (ctrl.b6_setting == "smoke_stove_linkage") then
                cmd[19] = 0x05
                cmd[20] = 0xff
                cmd[21] = 0xff
                cmd[22] = 0xff
                if (ctrl.b6_smoke_stove_linkage == VALUE_ON) then
                    cmd[20] = 0x01
                elseif (ctrl.b6_smoke_stove_linkage == VALUE_OFF) then
                    cmd[20] = 0x00
                end
                if (ctrl.b6_smoke_stove_linkage_gear and
                    getNumber(ctrl.b6_smoke_stove_linkage_gear) == 0) then
                    cmd[20] = 0x00
                    cmd[21] = 0xff
                elseif (ctrl.b6_smoke_stove_linkage_gear and
                    getNumber(ctrl.b6_smoke_stove_linkage_gear) ~= 0) then
                    cmd[20] = 0x01
                    cmd[21] = getNumber(ctrl.b6_smoke_stove_linkage_gear)
                end
                if (ctrl.b6_smoke_stove_linkage_gear_fix == 'positive') then
                    cmd[22] = 0x00
                elseif (ctrl.b6_smoke_stove_linkage_gear_fix == 'negative') then
                    cmd[22] = 0x01
                end
            elseif (ctrl.b6_setting == "delay_gear_linkage") then
                cmd[19] = 0x06
                cmd[20] = 0xff
                cmd[21] = 0xff
                if (ctrl.b6_delay_gear_linkage == VALUE_ON) then
                    cmd[20] = 0x01
                elseif (ctrl.b6_delay_gear_linkage == VALUE_OFF) then
                    cmd[20] = 0x00
                end
                if (ctrl.b6_delay_gear_linkage_gear and
                    getNumber(ctrl.b6_delay_gear_linkage_gear) == 0) then
                    cmd[20] = 0x00
                    cmd[21] = 0xff
                elseif (ctrl.b6_delay_gear_linkage_gear and
                    getNumber(ctrl.b6_delay_gear_linkage_gear) ~= 0) then
                    cmd[20] = 0x01
                    cmd[21] = getNumber(ctrl.b6_delay_gear_linkage_gear)
                end
            elseif (ctrl.b6_setting == "power_on_light") then
                cmd[19] = 0x07
                cmd[20] = 0xff
                if (ctrl.b6_power_on_light == VALUE_ON) then
                    cmd[20] = 0x01
                elseif (ctrl.b6_power_on_light == VALUE_OFF) then
                    cmd[20] = 0x00
                end
            elseif (ctrl.b6_setting == "delay_time") then
                cmd[19] = 0x08
                cmd[20] = 0xff
                cmd[21] = 0xff
                if (ctrl.b6_delay_time == VALUE_ON) then
                    cmd[20] = 0x01
                elseif (ctrl.b6_delay_time == VALUE_OFF) then
                    cmd[20] = 0x00
                end
                if (ctrl.b6_delay_time_value) then
                    cmd[21] = getNumber(ctrl.b6_delay_time_value)
                end
            elseif (ctrl.b6_setting == "lock") then
                cmd[19] = 0x09
                cmd[20] = 0xff
                if (ctrl.b6_lock == VALUE_ON) then
                    cmd[20] = 0x01
                elseif (ctrl.b6_lock == VALUE_OFF) then
                    cmd[20] = 0x00
                end
            end
            if (ctrl.b6_gesture_sensitivity) then
                cmd[19] = 0x01
                cmd[22] = getNumber(ctrl.b6_gesture_sensitivity)
            end
        elseif (ctrl.type == 'b7') then
            cmd[12] = 0x02
            cmd[13] = 0xff
            if (ctrl.b7_work_burner_control ~= nil) then
                cmd[13] = getNumber(ctrl.b7_work_burner_control)
            end
            cmd[14] = 0xff
            if (ctrl.b7_function_control ~= nil) then
                cmd[14] = getNumber(ctrl.b7_function_control)
            end
            cmd[15] = 0xff
            cmd[16] = 0xff
            cmd[17] = 0xff
            cmd[18] = 0xff
            cmd[19] = 0xff
            if (cmd[14] == 2) then
                if (cmd[13] == 1 and ctrl.b7_left_gear ~= nil) then
                    cmd[15] = getNumber(ctrl.b7_left_gear)
                elseif (cmd[13] == 2 and ctrl.b7_right_gear ~= nil) then
                    cmd[15] = getNumber(ctrl.b7_right_gear)
                end
                if (cmd[15] == 0x00) then cmd[14] = 0x01 end
                if (cmd[13] == 1 and ctrl.b7_left_destination_time ~= nil) then
                    local seconds = getNumber(ctrl.b7_left_destination_time)
                    if (seconds < 256 * 256) then
                        cmd[16] = seconds % 256
                        cmd[17] = (seconds - cmd[16]) / 256
                    end
                elseif (cmd[13] == 2 and ctrl.b7_right_destination_time ~= nil) then
                    local seconds = getNumber(ctrl.b7_right_destination_time)
                    if (seconds < 256 * 256) then
                        cmd[16] = seconds % 256
                        cmd[17] = (seconds - cmd[16]) / 256
                    end
                end
            elseif (cmd[14] == 3) then
                cmd[18] = 0x00
                cmd[19] = 0x00
                if (cmd[13] == 1 and ctrl.b7_left_destination_temp ~= nil) then
                    local temp = getNumber(ctrl.b7_left_destination_temp)
                    if (temp < 256 * 256) then
                        cmd[18] = temp % 256
                        cmd[19] = (temp - cmd[18]) / 256
                    end
                elseif (cmd[13] == 2 and ctrl.b7_right_destination_temp ~= nil) then
                    local temp = getNumber(ctrl.b7_right_destination_temp)
                    if (temp < 256 * 256) then
                        cmd[18] = temp % 256
                        cmd[19] = (temp - cmd[18]) / 256
                    end
                end
            end
        elseif (ctrl.type == 'b3') then
            cmd[12] = 0x03
            cmd[13] = 0xff
            if (ctrl.b3_work_cabinet_control ~= nil) then
                cmd[13] = getNumber(ctrl.b3_work_cabinet_control)
            end
            cmd[14] = 0xff
            if (ctrl.b3_function_control ~= nil) then
                cmd[14] = getNumber(ctrl.b3_function_control)
            end
            cmd[15] = 0xff
            cmd[16] = 0xff
            if (ctrl.b3_work_destination_time ~= nil) then
                local seconds = getNumber(ctrl.b3_work_destination_time)
                if (seconds < 256 * 256) then
                    cmd[15] = seconds % 256
                    cmd[16] = (seconds - cmd[15]) / 256
                end
            end
            cmd[17] = 0xff
            if (ctrl.b3_destination_temp ~= nil) then
                cmd[17] = getNumber(ctrl.b3_destination_temp)
                if (cmd[17] > 0xff) then cmd[17] = 0xfe end
            end
        elseif (ctrl.type == 'b2') then
            cmd[12] = 0x04
            cmd[13] = 0x01
            if (ctrl.b2_work_cabinet_control ~= nil) then
                cmd[13] = getNumber(ctrl.b2_work_cabinet_control)
            end
            if (ctrl.b2_cloudrecipe ~= nil or ctrl.b2_cloudrecipe_code ~= nil) then
                cmd[11] = 0x02
                cmd[14] = 0
                cmd[15] = 0
                if (ctrl.b2_cloudrecipe_code ~= nil) then
                    local id = getNumber(ctrl.b2_cloudrecipe_code)
                    if (id < 256 * 256) then
                        cmd[15] = id % 256
                        cmd[14] = (id - cmd[15]) / 256
                    end
                end
                cmd[16] = 0
                if (ctrl.b2_has_preheated == '1') then
                    setBit(cmd[16], 0, 1)
                end
                if (ctrl.b2_has_probing_pin == '1') then
                    setBit(cmd[16], 1, 1)
                end
                cmd[17] = 1
                if (ctrl.b2_cloudrecipe_paragraph) then
                    cmd[17] = getNumber(ctrl.b2_cloudrecipe_paragraph)
                end
                local i = 1
                while (i <= cmd[17]) do
                    cmd[18 + (i - 1) * 10] = 0xff
                    cmd[19 + (i - 1) * 10] = 0xff
                    cmd[20 + (i - 1) * 10] = 0xff
                    cmd[21 + (i - 1) * 10] = 0xff
                    cmd[22 + (i - 1) * 10] = 0xff
                    cmd[23 + (i - 1) * 10] = 0xff
                    cmd[24 + (i - 1) * 10] = 0xff
                    cmd[25 + (i - 1) * 10] = 0xff
                    cmd[26 + (i - 1) * 10] = 0xff
                    cmd[27 + (i - 1) * 10] = 0xff
                    if (ctrl['b2_cloudrecipe_work_mode_' .. i] ~= nil) then
                        cmd[18 + (i - 1) * 10] = getNumber(
                                                     ctrl['b2_cloudrecipe_work_mode_' ..
                                                         i])
                    end
                    if (ctrl['b2_cloudrecipe_target_time_' .. i] ~= nil) then
                        local seconds = getNumber(
                                            ctrl['b2_cloudrecipe_target_time_' ..
                                                i])
                        if (seconds < 256 * 256) then
                            cmd[19 + (i - 1) * 10] = seconds % 256
                            cmd[20 + (i - 1) * 10] = (seconds -
                                                         cmd[19 + (i - 1) * 10]) /
                                                         256
                        end
                    end
                    if (ctrl['b2_cloudrecipe_temperature_' .. i] ~= nil) then
                        local temperature = getNumber(
                                                ctrl['b2_cloudrecipe_temperature_' ..
                                                    i])
                        if (temperature < 256 * 256) then
                            cmd[21 + (i - 1) * 10] = temperature % 256
                            cmd[22 + (i - 1) * 10] = (temperature -
                                                         cmd[21 + (i - 1) * 10]) /
                                                         256
                        end
                    end
                    if (ctrl['b2_cloudrecipe_second_temperature_' .. i] ~= nil) then
                        local secondtemperature = getNumber(
                                                      ctrl['b2_cloudrecipe_second_temperature_' ..
                                                          i])
                        if (secondtemperature < 256 * 256) then
                            cmd[23 + (i - 1) * 10] = secondtemperature % 256
                            cmd[24 + (i - 1) * 10] =
                                (secondtemperature - cmd[23 + (i - 1) * 10]) /
                                    256
                        end
                    end
                    if (ctrl['b2_cloudrecipe_weight_' .. i] ~= nil) then
                        cmd[25 + (i - 1) * 10] = getNumber(
                                                     ctrl['b2_cloudrecipe_weight_' ..
                                                         i]) / 10
                    elseif (ctrl['b2_cloudrecipe_forpeople_' .. i] ~= nil) then
                        cmd[25 + (i - 1) * 10] = getNumber(
                                                     ctrl['b2_cloudrecipe_forpeople_' ..
                                                         i])
                    elseif (ctrl['b2_cloudrecipe_steamgear_' .. i] ~= nil) then
                        cmd[25 + (i - 1) * 10] = getNumber(
                                                     ctrl['b2_cloudrecipe_steamgear_' ..
                                                         i])
                    end
                    if (ctrl['b2_cloudrecipe_ending_acion_' .. i] ~= nil) then
                        cmd[26 + (i - 1) * 10] = getNumber(
                                                     ctrl['b2_cloudrecipe_ending_acion_' ..
                                                         i])
                    end
                    i = i + 1
                end
            else
                cmd[14] = 0xff
                if (ctrl.b2_work_status == 'power_off') then
                    cmd[14] = 0x01
                elseif (ctrl.b2_work_status == 'working') then
                    cmd[14] = 0x02
                elseif (ctrl.b2_work_status == 'pause') then
                    cmd[14] = 0x03
                elseif (ctrl.b2_work_status == 'order') then
                    cmd[14] = 0x04
                elseif (ctrl.b2_work_status == 'dry') then
                    cmd[14] = 0x05
                elseif (ctrl.b2_work_status == 'auto') then
                    cmd[14] = 0x06
                end
                cmd[15] = 0xff
                if (ctrl.b2_work_func ~= nil) then
                    cmd[15] = getNumber(ctrl.b2_work_func)
                end
                cmd[16] = 0xff
                if (ctrl.b2_work_menu ~= nil) then
                    cmd[16] = getNumber(ctrl.b2_work_menu)
                end
                if (ctrl.b2_recipe_code ~= nil) then
                    cmd[16] = getNumber(ctrl.b2_recipe_code)
                end
                cmd[17] = 0xff
                cmd[18] = 0xff
                if (ctrl.b2_work_destination_time ~= nil) then
                    local seconds = getNumber(ctrl.b2_work_destination_time)
                    if (seconds < 256 * 256) then
                        cmd[17] = seconds % 256
                        cmd[18] = (seconds - cmd[17]) / 256
                    end
                end
                cmd[19] = 0xff
                cmd[20] = 0xff
                if (ctrl.b2_destination_temp ~= nil) then
                    local temperature = getNumber(ctrl.b2_destination_temp)
                    if (temperature < 256 * 256) then
                        cmd[19] = temperature % 256
                        cmd[20] = (temperature - cmd[19]) / 256
                    end
                end
                cmd[21] = 0xff
                cmd[22] = 0xff
                if (ctrl.b2_order_destination_time ~= nil) then
                    local minutes = getNumber(ctrl.b2_order_destination_time)
                    if (minutes < 256 * 256) then
                        cmd[21] = minutes % 256
                        cmd[22] = (minutes - cmd[21]) / 256
                    end
                end
                cmd[23] = 0xff
                if (ctrl.b2_work_sub_menu ~= nil) then
                    cmd[23] = getNumber(ctrl.b2_work_sub_menu)
                end
                cmd[24] = 0xff
                if (ctrl.b2_menu_number ~= nil) then
                    cmd[24] = getNumber(ctrl.b2_menu_number)
                end
                cmd[25] = 0xff
                cmd[26] = 0xff
                if (ctrl.b2_menu_weight ~= nil) then
                    local weight = getNumber(ctrl.b2_menu_weight)
                    if (weight < 256 * 256) then
                        cmd[25] = weight % 256
                        cmd[26] = (weight - cmd[25]) / 256
                    end
                end
                cmd[27] = 0xFF
                if (ctrl.b2_light ~= nil) then
                    if (ctrl.b2_light == 'on') then
                        cmd[27] = 0x01
                    elseif (ctrl.b2_light == 'off') then
                        cmd[27] = 0x00
                    end
                end
                cmd[28] = 0xff
                if (ctrl.b2_lock == 'on') then
                    cmd[28] = 0x01
                elseif (ctrl.b2_lock == 'off') then
                    cmd[28] = 0x00
                end
            end
        elseif (ctrl.type == 'e7') then
            cmd[12] = 0x05
            cmd[13] = 0x01
            cmd[14] = 0xff
            cmd[15] = 0xff
            if (ctrl.e7_work_burner_control ~= nil) then
                cmd[13] = getNumber(ctrl.e7_work_burner_control)
            end
            if (ctrl.e7_work_status == 'power_off') then
                cmd[14] = 0x01
                cmd[15] = 0x00
            elseif (ctrl.e7_work_status == 'working') then
                cmd[14] = 0x02
            elseif (ctrl.e7_work_status == 'order') then
                cmd[14] = 0x03
            end
            if (ctrl.e7_mode == 'none') then
                cmd[15] = 0x00
            elseif (ctrl.e7_mode == 'heat_preservation') then
                cmd[15] = 0x01
            elseif (ctrl.e7_mode == 'stew_soup') then
                cmd[15] = 0x02
            elseif (ctrl.e7_mode == 'boiling') then
                cmd[15] = 0x03
            elseif (ctrl.e7_mode == 'stir_frying') then
                cmd[15] = 0x04
            end
            cmd[16] = 0xFF
            if (ctrl.e7_gear ~= nil) then
                cmd[16] = getNumber(ctrl.e7_gear)
            end
            cmd[17] = 0xFF
            cmd[18] = 0xFF
            if (ctrl.e7_destination_time ~= nil) then
                local seconds = getNumber(ctrl.e7_destination_time)
                if (seconds < 256 * 256) then
                    cmd[17] = seconds % 256
                    cmd[18] = (seconds - cmd[17]) / 256
                end
            end
            cmd[19] = 0xFF
            if (ctrl.e7_bridge_link == 'off') then
                cmd[19] = 0x00
            elseif (ctrl.e7_bridge_link == 'on') then
                cmd[19] = 0x01
            end
        elseif (ctrl.type == 'sp') then
            cmd[12] = 0x06
            local fn = ctrl.sp_func
            if (fn == 'fandrying') then
                cmd[13] = 1
            elseif (fn == 'heatingdisk') then
                cmd[13] = 2
            elseif (fn == 'uvc') then
                cmd[13] = 3
            elseif (fn ~= nil) then
                cmd[13] = getNumber(fn)
            else
                fn = 0
                cmd[13] = 0x00
            end
            local st = ctrl['sp_' .. fn .. '_status']
            if (st == 'on') then
                cmd[14] = 1
            elseif (st == 'off') then
                cmd[14] = 0
            elseif (st == 'order') then
                cmd[14] = 2
            elseif (st == 'setting') then
                cmd[14] = 3
            else
                cmd[14] = 0xff
            end
            cmd[15] = 0xff
            cmd[16] = 0xff
            if (ctrl['sp_' .. fn .. '_destination_time'] ~= nil) then
                local seconds = getNumber(ctrl['sp_' .. fn ..
                                              '_destination_time'])
                if (seconds < 256 * 256) then
                    cmd[15] = seconds % 256
                    cmd[16] = (seconds - cmd[15]) / 256
                end
            end
            cmd[17] = 0xff
            if (ctrl['sp_' .. fn .. '_temperature'] ~= nil) then
                cmd[17] = getNumber(ctrl['sp_' .. fn .. '_temperature'])
            end
            cmd[18] = 0xff
            cmd[19] = 0xff
            if (ctrl['sp_' .. fn .. '_order_destination_time']) then
                local ordertime = getNumber(ctrl['sp_' .. fn ..
                                                '_order_destination_time'])
                if (ordertime < 256 * 256) then
                    cmd[18] = ordertime % 256
                    cmd[19] = (ordertime - cmd[18]) / 256
                end
            end
            cmd[20] = 0xff
            cmd[21] = 0xff
            cmd[22] = 0xff
            cmd[23] = 0xff
            cmd[24] = 0xff
            if (ctrl['sp_' .. fn .. '_setting_type'] ~= nil) then
                cmd[20] = getNumber(ctrl['sp_' .. fn .. '_setting_type'])
                cmd[21] = getNumber(ctrl['sp_' .. fn .. '_setting_value'])
            end
            if (ctrl['sp_' .. fn .. '_setting_linkage'] ~= nil) then
                cmd[20] = 1
                if (ctrl['sp_' .. fn .. '_setting_linkage'] == 'on') then
                    cmd[21] = 1
                end
                if (ctrl['sp_' .. fn .. '_setting_linkage'] == 'off') then
                    cmd[21] = 0
                end
            end
            if (ctrl['sp_' .. fn .. '_setting_automode'] ~= nil) then
                cmd[20] = 2
                if (ctrl['sp_' .. fn .. '_setting_automode'] == 'on') then
                    cmd[21] = 1
                end
                if (ctrl['sp_' .. fn .. '_setting_automode'] == 'off') then
                    cmd[21] = 0
                end
                if (ctrl['sp_' .. fn .. '_setting_automode_day'] ~= nil) then
                    cmd[22] = getNumber(ctrl['sp_' .. fn ..
                                            '_setting_automode_day'])
                end
                if (ctrl['sp_' .. fn .. '_setting_automode_starthour'] ~= nil) then
                    cmd[23] = getNumber(ctrl['sp_' .. fn ..
                                            '_setting_automode_starthour'])
                end
                if (ctrl['sp_' .. fn .. '_setting_automode_startminute'] ~= nil) then
                    cmd[24] = getNumber(ctrl['sp_' .. fn ..
                                            '_setting_automode_startminute'])
                end
            end
        elseif (ctrl.type == 'ac') then
            cmd[12] = 0x08
            cmd[13] = 0x01
            cmd[14] = 0xFF
            cmd[15] = 0xFF
            if (ctrl.ac_work_status == 'power_off') then
                cmd[14] = 0x01
                cmd[15] = 0x00
            elseif (ctrl.ac_work_status == 'working') then
                cmd[14] = 0x02
            elseif (ctrl.ac_work_status == 'order') then
                cmd[14] = 0x03
            elseif (ctrl.ac_work_status == 'reservation') then
                cmd[14] = 0x04
            elseif (ctrl.ac_work_status == 'reservation_and_order') then
                cmd[14] = 0x05
            elseif (ctrl.ac_work_status == 'setting') then
                cmd[14] = 0x08
            end
            if (ctrl.ac_mode == 'none') then
                cmd[15] = 0x00
            elseif (ctrl.ac_mode == 'refrigeration') then
                cmd[15] = 0x01
            elseif (ctrl.ac_mode == 'air_supply') then
                cmd[15] = 0x02
            elseif (ctrl.ac_mode == 'dehumidification') then
                cmd[15] = 0x03
            elseif (ctrl.ac_mode == 'net_flavour') then
                cmd[15] = 0x04
            end
            cmd[16] = 0xFF
            if (ctrl.ac_gear ~= nil) then
                cmd[16] = getNumber(ctrl.ac_gear)
            end
            cmd[17] = 0xFF
            cmd[18] = 0xFF
            if (ctrl.ac_destination_time ~= nil) then
                local seconds = getNumber(ctrl.ac_destination_time)
                if (seconds < 256 * 256) then
                    cmd[17] = seconds % 256
                    cmd[18] = (seconds - cmd[17]) / 256
                end
            end
            cmd[19] = 0xFF
            cmd[20] = 0xFF
            if (ctrl.ac_destination_temp ~= nil) then
                local temperature = getNumber(ctrl.ac_destination_temp)
                if (temperature < 256 * 256) then
                    cmd[19] = temperature % 256
                    cmd[20] = (temperature - cmd[19]) / 256
                end
            end
            cmd[21] = 0xFF
            cmd[22] = 0xFF
            if (ctrl.ac_order_destination_time ~= nil) then
                local minutes = getNumber(ctrl.ac_order_destination_time)
                if (minutes < 256 * 256) then
                    cmd[21] = minutes % 256
                    cmd[22] = (minutes - cmd[21]) / 256
                end
            end
            cmd[23] = 0xFF
            if (ctrl.ac_swing == 'off') then
                cmd[23] = 0x00
            elseif (ctrl.ac_swing == 'on') then
                cmd[23] = 0x01
            end
            cmd[24] = 0xFF
            if (ctrl.ac_air_direction == 'off') then
                cmd[24] = 0x00
            elseif (ctrl.ac_air_direction == 'on') then
                cmd[24] = 0x01
            end
            cmd[25] = 0xFF
            if (ctrl.ac_swing_gear ~= nil) then
                cmd[25] = getNumber(ctrl.ac_swing_gear)
            end
            cmd[26] = 0xFF
            if (ctrl.ac_swing_min_angle ~= nil) then
                cmd[26] = getNumber(ctrl.ac_swing_min_angle)
            end
            cmd[27] = 0xFF
            if (ctrl.ac_swing_max_anangle ~= nil) then
                cmd[27] = getNumber(ctrl.ac_swing_max_angle)
            end
            cmd[28] = 0xFF
            if (ctrl.ac_air_direction_gear ~= nil) then
                cmd[28] = getNumber(ctrl.ac_air_direction_gear)
            end
            cmd[29] = 0xFF
            if (ctrl.ac_air_direction_min_angle ~= nil) then
                cmd[29] = getNumber(ctrl.ac_air_direction_min_angle)
            end
            cmd[30] = 0xFF
            if (ctrl.ac_air_direction_max_anangle ~= nil) then
                cmd[30] = getNumber(ctrl.ac_air_direction_max_angle)
            end
        elseif (ctrl.type == 'bf') then
            cmd[12] = 0x09
            if (ctrl.bf_diy_btn_type ~= nil) then
                cmd[11] = 0x0A
                cmd[13] = 0xFF
                cmd[14] = 0xFF
                cmd[15] = 0xFF
                cmd[16] = 0xFF
                cmd[17] = 0xFF
                cmd[18] = 0xFF
                cmd[19] = 0xFF
                if (ctrl.bf_diy_btn_type == 'add') then
                    cmd[19] = 0x01
                elseif (ctrl.bf_diy_btn_type == 'del') then
                    cmd[19] = 0x02
                elseif (ctrl.bf_diy_btn_type == 'update') then
                    cmd[19] = 0x03
                elseif (ctrl.bf_diy_btn_type == 'del_all') then
                    cmd[19] = 0x04
                end
                cmd[20] = 0xFF
                if (ctrl.bf_diy_btn_id ~= nil) then
                    cmd[20] = ctrl.bf_diy_btn_id
                end
                cmd[21] = 0xFF
                cmd[22] = 0xFF
                cmd[23] = 0xFF
                cmd[24] = 0xFF
                cmd[25] = 0xFF
                cmd[26] = 0xFF
                cmd[27] = 0xFF
                cmd[28] = 0xFF
                cmd[29] = 0xFF
                cmd[30] = 0xFF
                cmd[31] = 0xFF
                cmd[32] = 0xFF
                cmd[33] = 0xFF
                cmd[34] = 0xFF
                cmd[35] = 0xFF
                cmd[36] = 0xFF
                cmd[37] = 0xFF
                if (ctrl.bf_diy_btn_name ~= nil) then
                    local diyNameCode = ctrl.bf_diy_btn_name
                    if (diyNameCode ~= nil) then
                        local len = #diyNameCode
                        cmd[21] = len / 4
                        local temp = len / 2
                        for i = 1, temp do
                            cmd[21 + i] = "0x" ..
                                              string.sub(diyNameCode, i * 2 - 1,
                                                         i * 2)
                        end
                    end
                end
                cmd[38] = 0xFF
                local sign = 38
                if (ctrl.bf_mode_multi_number ~= nil) then
                    cmd[38] = "0x" .. getNumber(ctrl.bf_mode_multi_number) ..
                                  "1"
                    if (ctrl.bf_recipe_code == nil) then
                        local multi = getNumber(ctrl.bf_mode_multi_number)
                        if (multi == 0) then multi = 1 end
                        sign = sign + multi * 16
                        for i = 1, multi do
                            cmd[39 + (i - 1) * 16] = 0
                            local key = "bf_mode_multi" .. i
                            if (ctrl[key].preheat ~= nil and ctrl[key].preheat ==
                                'on') then
                                cmd[39 + (i - 1) * 16] = setBit(
                                                             cmd[39 + (i - 1) *
                                                                 16], 0, 1)
                            end
                            if (ctrl[key].probe ~= nil and ctrl[key].probe ==
                                'on') then
                                cmd[39 + (i - 1) * 16] = setBit(
                                                             cmd[39 + (i - 1) *
                                                                 16], 1, 1)
                            end
                            if (ctrl[key].order ~= nil and ctrl[key].order ==
                                'on') then
                                cmd[39 + (i - 1) * 16] = setBit(
                                                             cmd[39 + (i - 1) *
                                                                 16], 2, 1)
                            end
                            if (ctrl[key].turntable ~= nil and
                                ctrl[key].turntable == 'on') then
                                cmd[39 + (i - 1) * 16] = setBit(
                                                             cmd[39 + (i - 1) *
                                                                 16], 3, 1)
                            end
                            if (ctrl[key].hotwind ~= nil and ctrl[key].hotwind ==
                                'on') then
                                cmd[39 + (i - 1) * 16] = setBit(
                                                             cmd[39 + (i - 1) *
                                                                 16], 4, 1)
                            end
                            if (ctrl[key].cavity ~= nil) then
                                local cavity = {}
                                if (ctrl[key].cavity == 'all') then
                                    cavity = {0, 0}
                                elseif (ctrl[key].cavity == 'repair') then
                                    cavity = {0, 1}
                                elseif (ctrl[key].cavity == 'partition') then
                                    cavity = {1, 0}
                                end
                                for i = 1, #cavity do
                                    cmd[39 + (i - 1) * 16] = setBit(cmd[39 +
                                                                        (i - 1) *
                                                                        16],
                                                                    i + 4,
                                                                    cavity[i])
                                end
                            end
                            if (ctrl[key].stair ~= nil and ctrl[key].stair ==
                                'down') then
                                cmd[39 + (i - 1) * 16] = setBit(
                                                             cmd[39 + (i - 1) *
                                                                 16], 7, 1)
                            end
                            cmd[40 + (i - 1) * 16] = 0xFF
                            cmd[41 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].mode ~= nil) then
                                local mode = getNumber(ctrl[key].mode)
                                if (mode < 256 * 256) then
                                    cmd[41 + (i - 1) * 16] = mode % 256
                                    cmd[40 + (i - 1) * 16] = (mode -
                                                                 cmd[41 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                end
                            end
                            cmd[42 + (i - 1) * 16] = 0
                            cmd[43 + (i - 1) * 16] = 0
                            cmd[44 + (i - 1) * 16] = 0
                            if (ctrl[key].time ~= nil) then
                                local time = getNumber(ctrl[key].time)
                                if (time < 256 * 256) then
                                    cmd[44 + (i - 1) * 16] = time % 256
                                    cmd[43 + (i - 1) * 16] = (time -
                                                                 cmd[44 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                elseif (time < 256 * 256 * 256 and time > 256 *
                                    256) then
                                    local remainder = time % (256 * 256)
                                    cmd[44 + (i - 1) * 16] = time % 256
                                    cmd[43 + (i - 1) * 16] = (remainder -
                                                                 cmd[44 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                    cmd[42 + (i - 1) * 16] =
                                        (time - remainder) / (256 * 256)
                                end
                            end
                            cmd[45 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].fire ~= nil) then
                                cmd[45 + (i - 1) * 16] = getNumber(ctrl[key]
                                                                       .fire)
                            end
                            cmd[46 + (i - 1) * 16] = 0xFF
                            cmd[47 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].temp_up ~= nil) then
                                local temp = getNumber(ctrl[key].temp_up)
                                if (temp < 256 * 256) then
                                    cmd[47 + (i - 1) * 16] = temp % 256
                                    cmd[46 + (i - 1) * 16] = (temp -
                                                                 cmd[47 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                end
                            end
                            cmd[48 + (i - 1) * 16] = 0xFF
                            cmd[49 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].temp_down ~= nil) then
                                local temp = getNumber(ctrl[key].temp_down)
                                if (temp < 256 * 256) then
                                    cmd[49 + (i - 1) * 16] = temp % 256
                                    cmd[48 + (i - 1) * 16] = (temp -
                                                                 cmd[49 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                end
                            end
                            cmd[50 + (i - 1) * 16] = 0xFF
                            cmd[51 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].probe_temp ~= nil) then
                                local temp = getNumber(ctrl[key].probe_temp)
                                if (temp < 256 * 256) then
                                    cmd[51 + (i - 1) * 16] = temp % 256
                                    cmd[50 + (i - 1) * 16] = (temp -
                                                                 cmd[51 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                end
                            end
                            cmd[52 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].steam ~= nil) then
                                cmd[52 + (i - 1) * 16] = getNumber(ctrl[key]
                                                                       .steam)
                            end
                            cmd[53 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].mount ~= nil) then
                                local mount = ctrl[key].mount
                                if (cmd[18] ~= 0xFF and cmd[18] ~= 0x04) then
                                    local multiple = 0
                                    if (ctrl.bf_weight_multiple ==
                                        'one_of_ten_thousand') then
                                        multiple = 0.0001
                                    elseif (ctrl.bf_weight_multiple ==
                                        'one_of_thousand') then
                                        multiple = 0.001
                                    elseif (ctrl.bf_weight_multiple ==
                                        'one_of_hundred') then
                                        multiple = 0.01
                                    elseif (ctrl.bf_weight_multiple ==
                                        'one_of_ten') then
                                        multiple = 0.1
                                    elseif (ctrl.bf_weight_multiple == 'ten') then
                                        multiple = 10
                                    elseif (ctrl.bf_weight_multiple == 'hundred') then
                                        multiple = 100
                                    end
                                    cmd[53 + (i - 1) * 16] = mount /
                                                                 (10 * multiple)
                                elseif (cmd[19] == 0x04) then
                                    cmd[53 + (i - 1) * 16] = getNumber(mount)
                                end
                            end
                            cmd[54 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].end_next ~= nil) then
                                cmd[54 + (i - 1) * 16] = getNumber(ctrl[key]
                                                                       .end_next)
                            end
                        end
                    end
                end
            else
                cmd[13] = 0x01
                if (ctrl.bf_work_cabinet_control ~= nil and
                    ctrl.bf_work_cabinet_control == '0') then
                    cmd[13] = 0x00
                end
                cmd[14] = 0xFF
                if (ctrl.bf_control == 'start') then
                    cmd[14] = 0x01
                elseif (ctrl.bf_control == 'control') then
                    cmd[14] = 0x02
                elseif (ctrl.bf_control == 'change') then
                    cmd[14] = 0x03
                elseif (ctrl.bf_control == 'diy_btn') then
                    cmd[14] = 0x04
                end
                cmd[15] = 0xff
                if (ctrl.bf_work_status == 'power_off') then
                    cmd[15] = 0x01
                elseif (ctrl.bf_work_status == 'cancel') then
                    cmd[15] = 0x02
                elseif (ctrl.bf_work_status == 'continue') then
                    cmd[15] = 0x03
                elseif (ctrl.bf_work_status == 'pause') then
                    cmd[15] = 0x06
                elseif (ctrl.bf_work_status == 'check_version') then
                    cmd[15] = 0x0B
                elseif (ctrl.bf_work_status == 'demo') then
                    cmd[15] = 0x0C
                elseif (ctrl.bf_work_status == 'sabbath') then
                    cmd[15] = 0x0D
                elseif (ctrl.bf_work_status == 'detection') then
                    cmd[15] = 0x0E
                elseif (ctrl.bf_work_status == 'working') then
                    cmd[15] = 0x11
                end
                cmd[16] = 0xFF
                cmd[17] = 0xFF
                cmd[18] = 0xFF
                if (ctrl.bf_recipe_code ~= nil) then
                    cmd[16] = 0
                    cmd[17] = 0
                    cmd[18] = 0
                    local id = getNumber(ctrl.bf_recipe_code)
                    if (id < 256 * 256) then
                        cmd[18] = id % 256
                        cmd[17] = (id - cmd[18]) / 256
                    elseif (id < 256 * 256 * 256 and id > 256 * 256) then
                        local remainder = id % (256 * 256)
                        cmd[18] = id % 256
                        cmd[17] = (remainder - cmd[18]) / 256
                        cmd[16] = (id - remainder) / (256 * 256)
                    end
                end
                cmd[19] = 0x00
                if (ctrl.bf_weight_multiple ~= nil) then
                    if (ctrl.bf_weight_multiple == 'one_of_ten_thousand') then
                        cmd[19] = setBit(cmd[19], 0, 1)
                    elseif (ctrl.bf_weight_multiple == 'one_of_thousand') then
                        cmd[19] = setBit(cmd[19], 1, 1)
                    elseif (ctrl.bf_weight_multiple == 'one_of_hundred') then
                        cmd[19] = setBit(cmd[19], 2, 1)
                    elseif (ctrl.bf_weight_multiple == 'one_of_ten') then
                        cmd[19] = setBit(cmd[19], 3, 1)
                    elseif (ctrl.bf_weight_multiple == 'ten') then
                        cmd[19] = setBit(cmd[19], 4, 1)
                    elseif (ctrl.bf_weight_multiple == 'hundred') then
                        cmd[19] = setBit(cmd[19], 5, 1)
                    end
                end
                cmd[20] = 0x00
                if (ctrl.bf_weight_unit ~= nil) then
                    if (ctrl.bf_weight_unit == 'g') then
                        cmd[20] = 0x00
                    elseif (ctrl.bf_weight_unit == 'kg') then
                        cmd[20] = 0x01
                    elseif (ctrl.bf_weight_unit == 'ounce') then
                        cmd[20] = 0x02
                    elseif (ctrl.bf_weight_unit == 'pound') then
                        cmd[20] = 0x03
                    elseif (ctrl.bf_weight_unit == 'other') then
                        cmd[20] = 0x04
                    end
                end
                cmd[21] = 0xFF
                if (ctrl.bf_lock ~= nil) then
                    if (ctrl.bf_lock == 'on') then
                        cmd[21] = 0x01
                    else
                        cmd[21] = 0x00
                    end
                end
                cmd[22] = 0xFF
                if (ctrl.bf_light ~= nil) then
                    if (ctrl.bf_light == 'on') then
                        cmd[22] = 0x01
                    else
                        cmd[22] = 0x00
                    end
                end
                cmd[23] = 0xFF
                if (ctrl.bf_door ~= nil) then
                    if (ctrl.bf_door == 'on') then
                        cmd[23] = 0x01
                    else
                        cmd[23] = 0x00
                    end
                end
                cmd[24] = 0xFF
                if (ctrl.bf_hotwind ~= nil) then
                    if (ctrl.bf_hotwind == 'on') then
                        cmd[24] = 0x01
                    else
                        cmd[24] = 0x00
                    end
                end
                cmd[25] = 0xFF
                if (ctrl.bf_weight_unit_fix ~= nil) then
                    if (ctrl.bf_weight_unit_fix == 'g') then
                        cmd[25] = 0x00
                    elseif (ctrl.bf_weight_unit_fix == 'kg') then
                        cmd[25] = 0x01
                    elseif (ctrl.bf_weight_unit_fix == 'ounce') then
                        cmd[25] = 0x02
                    elseif (ctrl.bf_weight_unit_fix == 'pound') then
                        cmd[25] = 0x03
                    end
                end
                cmd[26] = 0xFF
                if (ctrl.bf_tips_mark ~= nil) then
                    if (ctrl.bf_tips_mark == 'door_open') then
                        cmd[26] = 0x01
                    elseif (ctrl.bf_tips_mark == 'change_attachments') then
                        cmd[26] = 0x02
                    elseif (ctrl.bf_tips_mark == 'change_containers') then
                        cmd[26] = 0x03
                    elseif (ctrl.bf_tips_mark == 'apply') then
                        cmd[26] = 0x04
                    elseif (ctrl.bf_tips_mark == 'feed') then
                        cmd[26] = 0x05
                    elseif (ctrl.bf_tips_mark == 'stir') then
                        cmd[26] = 0x06
                    end
                end
                cmd[27] = 0xFF
                if (ctrl.bf_quick_btn_set_key ~= nil) then
                    if (ctrl.bf_quick_btn_set_key == 'microwave') then
                        cmd[27] = 0x09
                    elseif (ctrl.bf_quick_btn_set_key == 'steam') then
                        cmd[27] = 0x0A
                    elseif (ctrl.bf_quick_btn_set_key == 'bake') then
                        cmd[27] = 0x0B
                    end
                end
                cmd[28] = 0xFF
                cmd[29] = 0xFF
                if (ctrl.bf_quick_btn_set_id ~= nil) then
                    local id = ctrl.bf_quick_btn_set_id
                    if (id < 256 * 256) then
                        cmd[29] = id % 256
                        cmd[28] = (id - cmd[29]) / 256
                    end
                end
                cmd[30] = 0xFF
                cmd[31] = 0xFF
                cmd[32] = 0xFF
                if (ctrl.bf_quick_btn_set_time ~= nil) then
                    cmd[30] = 0
                    cmd[31] = 0
                    cmd[32] = 0
                    local time = getNumber(ctrl.bf_quick_btn_set_time)
                    if (time < 256 * 256) then
                        cmd[32] = time % 256
                        cmd[31] = (time - cmd[32]) / 256
                    elseif (time < 256 * 256 * 256 and time > 256 * 256) then
                        local remainder = time % (256 * 256)
                        cmd[32] = time % 256
                        cmd[31] = (remainder - cmd[32]) / 256
                        cmd[30] = (time - remainder) / (256 * 256)
                    end
                end
                cmd[33] = 0xFF
                cmd[34] = 0xFF
                if (ctrl.bf_quick_btn_set ~= nil) then
                    local set = ctrl.bf_quick_btn_set
                    if (set < 256 * 256) then
                        cmd[34] = set % 256
                        cmd[33] = (set - cmd[34]) / 256
                    end
                end
                cmd[35] = 0xFF
                local sign = 35
                if (ctrl.bf_mode_multi_number ~= nil) then
                    cmd[35] = getNumber(ctrl.bf_mode_multi_number)
                    if (ctrl.bf_recipe_code == nil) then
                        local multi = getNumber(ctrl.bf_mode_multi_number)
                        if (multi == 0) then multi = 1 end
                        sign = sign + multi * 16
                        for i = 1, multi do
                            cmd[36 + (i - 1) * 16] = 0
                            local key = "bf_mode_multi" .. i
                            if (ctrl[key].preheat ~= nil and ctrl[key].preheat ==
                                'on') then
                                cmd[36 + (i - 1) * 16] = setBit(
                                                             cmd[36 + (i - 1) *
                                                                 16], 0, 1)
                            end
                            if (ctrl[key].probe ~= nil and ctrl[key].probe ==
                                'on') then
                                cmd[36 + (i - 1) * 16] = setBit(
                                                             cmd[36 + (i - 1) *
                                                                 16], 1, 1)
                            end
                            if (ctrl[key].order ~= nil and ctrl[key].order ==
                                'on') then
                                cmd[36 + (i - 1) * 16] = setBit(
                                                             cmd[36 + (i - 1) *
                                                                 16], 2, 1)
                            end
                            if (ctrl[key].turntable ~= nil and
                                ctrl[key].turntable == 'on') then
                                cmd[36 + (i - 1) * 16] = setBit(
                                                             cmd[36 + (i - 1) *
                                                                 16], 3, 1)
                            end
                            if (ctrl[key].hotwind ~= nil and ctrl[key].hotwind ==
                                'on') then
                                cmd[36 + (i - 1) * 16] = setBit(
                                                             cmd[36 + (i - 1) *
                                                                 16], 4, 1)
                            end
                            if (ctrl[key].cavity ~= nil) then
                                local cavity = {}
                                if (ctrl[key].cavity == 'all') then
                                    cavity = {0, 0}
                                elseif (ctrl[key].cavity == 'repair') then
                                    cavity = {0, 1}
                                elseif (ctrl[key].cavity == 'partition') then
                                    cavity = {1, 0}
                                end
                                for i = 1, #cavity do
                                    cmd[36 + (i - 1) * 16] = setBit(cmd[36 +
                                                                        (i - 1) *
                                                                        16],
                                                                    i + 4,
                                                                    cavity[i])
                                end
                            end
                            if (ctrl[key].stair ~= nil and ctrl[key].stair ==
                                'down') then
                                cmd[36 + (i - 1) * 16] = setBit(
                                                             cmd[36 + (i - 1) *
                                                                 16], 7, 1)
                            end
                            cmd[37 + (i - 1) * 16] = 0xFF
                            cmd[38 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].mode ~= nil) then
                                local mode = getNumber(ctrl[key].mode)
                                if (mode < 256 * 256) then
                                    cmd[38 + (i - 1) * 16] = mode % 256
                                    cmd[37 + (i - 1) * 16] = (mode -
                                                                 cmd[38 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                end
                            end
                            cmd[39 + (i - 1) * 16] = 0
                            cmd[40 + (i - 1) * 16] = 0
                            cmd[41 + (i - 1) * 16] = 0
                            if (ctrl[key].time ~= nil) then
                                local time = getNumber(ctrl[key].time)
                                if (time < 256 * 256) then
                                    cmd[41 + (i - 1) * 16] = time % 256
                                    cmd[40 + (i - 1) * 16] = (time -
                                                                 cmd[41 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                elseif (time < 256 * 256 * 256 and time > 256 *
                                    256) then
                                    local remainder = time % (256 * 256)
                                    cmd[41 + (i - 1) * 16] = time % 256
                                    cmd[40 + (i - 1) * 16] = (remainder -
                                                                 cmd[41 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                    cmd[39 + (i - 1) * 16] =
                                        (time - remainder) / (256 * 256)
                                end
                            end
                            cmd[42 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].fire ~= nil) then
                                cmd[42 + (i - 1) * 16] = getNumber(ctrl[key]
                                                                       .fire)
                            end
                            cmd[43 + (i - 1) * 16] = 0xFF
                            cmd[44 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].temp_up ~= nil) then
                                local temp = getNumber(ctrl[key].temp_up)
                                if (temp < 256 * 256) then
                                    cmd[44 + (i - 1) * 16] = temp % 256
                                    cmd[43 + (i - 1) * 16] = (temp -
                                                                 cmd[44 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                end
                            end
                            cmd[45 + (i - 1) * 16] = 0xFF
                            cmd[46 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].temp_down ~= nil) then
                                local temp = getNumber(ctrl[key].temp_down)
                                if (temp < 256 * 256) then
                                    cmd[46 + (i - 1) * 16] = temp % 256
                                    cmd[45 + (i - 1) * 16] = (temp -
                                                                 cmd[46 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                end
                            end
                            cmd[47 + (i - 1) * 16] = 0xFF
                            cmd[48 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].probe_temp ~= nil) then
                                local temp = getNumber(ctrl[key].probe_temp)
                                if (temp < 256 * 256) then
                                    cmd[48 + (i - 1) * 16] = temp % 256
                                    cmd[47 + (i - 1) * 16] = (temp -
                                                                 cmd[48 +
                                                                     (i - 1) *
                                                                     16]) / 256
                                end
                            end
                            cmd[49 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].steam ~= nil) then
                                cmd[49 + (i - 1) * 16] = getNumber(ctrl[key]
                                                                       .steam)
                            end
                            cmd[50 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].mount ~= nil) then
                                local mount = ctrl[key].mount
                                if (cmd[19] ~= 0xFF and cmd[19] ~= 0x04 and
                                    cmd[19] ~= 0x00) then
                                    local multiple = 0
                                    if (ctrl.bf_weight_multiple ==
                                        'one_of_ten_thousand') then
                                        multiple = 0.0001
                                    elseif (ctrl.bf_weight_multiple ==
                                        'one_of_thousand') then
                                        multiple = 0.001
                                    elseif (ctrl.bf_weight_multiple ==
                                        'one_of_hundred') then
                                        multiple = 0.01
                                    elseif (ctrl.bf_weight_multiple ==
                                        'one_of_ten') then
                                        multiple = 0.1
                                    elseif (ctrl.bf_weight_multiple == 'ten') then
                                        multiple = 10
                                    elseif (ctrl.bf_weight_multiple == 'hundred') then
                                        multiple = 100
                                    end
                                    cmd[50 + (i - 1) * 16] = mount /
                                                                 (10 * multiple)
                                elseif (cmd[19] == 0x04 or cmd[19] == 0x00) then
                                    cmd[50 + (i - 1) * 16] = getNumber(mount)
                                end
                            end
                            cmd[51 + (i - 1) * 16] = 0xFF
                            if (ctrl[key].end_next ~= nil) then
                                cmd[51 + (i - 1) * 16] = getNumber(ctrl[key]
                                                                       .end_next)
                            end
                        end
                    end
                end
            end
        end
    elseif (query) then
        cmd[10] = 0x03
        if (query.tips) then
            cmd[11] = 0x02
        else
            cmd[11] = 0x01
        end
    end
    return cmd
end
local function getPackage(position, cmd)
    local pkg = {}
    local i = 1
    while (i <= cmd[position + 1]) do
        pkg[i] = cmd[position + 1 + i]
        i = i + 1
    end
    return pkg
end
local function getB6SmokeDitectJson(json, pkg) return json end
local function getB6AirDuctJson(json, pkg)
    if (pkg[1] ~= 0xff or pkg[2] ~= 0xff) then
        json.b6_air_duct_detection_time = pkg[1] * 256 + pkg[2]
    end
    if (pkg[3] ~= 0xff) then json.b6_air_duct_detection_score = pkg[3] end
    if (pkg[4] ~= 0xff) then json.b6_air_duct_detection_windage = pkg[4] end
    if (pkg[5] ~= 0xff) then json.b6_air_duct_detection_state = pkg[5] end
    return json
end
local function getB6Inverter(json, pkg)
    if (pkg[1] ~= 0xff and pkg[2] ~= 0xff) then
        json.b6_inverter_wind_flow = pkg[1] + pkg[2] * 256
    end
    if (pkg[3] ~= 0xff) then json.b6_inverter_windage = pkg[3] end
    if (pkg[4] ~= 0xff and pkg[5] ~= 0xff) then
        json.b6_inverter_wind_presssure = pkg[4] + pkg[5] * 256
    end
    if (pkg[6] ~= 0xff and pkg[7] ~= 0xff) then
        json.b6_inverter_voltage = pkg[6] + pkg[7] * 256
    end
    if (pkg[8] ~= 0xff and pkg[9] ~= 0xff) then
        json.b6_inverter_motor_speed = pkg[8] + pkg[9] * 256
    end
    if (pkg[10] ~= 0xff and pkg[11] ~= 0xff) then
        json.b6_inverter_q_axis_current = pkg[10] + pkg[11] * 256
    end
    if (pkg[12] ~= 0xff) then json.b6_inverter_start_time = pkg[12] end
    if (pkg[13] ~= 0xff) then json.b6_inverter_efficiency = pkg[13] end
    if (pkg[14] ~= 0xff and pkg[15] ~= 0xff) then
        json.b6_inverter_capacity = pkg[14] + pkg[15] * 256
    end
    if (pkg[16] ~= 0xff) then json.b6_inverter_temperature = pkg[16] end
    if (pkg[17] ~= 0xff) then json.b6_inverter_ac_frequency = pkg[17] end
    if (pkg[18] ~= 0xff and pkg[19] ~= 0xff) then
        json.b6_inverter_work_gear = pkg[18] + pkg[19] * 256
    end
    if (pkg[20] ~= 0xff) then
        json.b6_inverter_back_electromotive_force = pkg[20]
    end
    if (pkg[21] ~= 0xff) then
        json.b6_inverter_temperature_limit_sign = pkg[21]
    end
    if (pkg[22] ~= 0xff and pkg[23] ~= 0xff) then
        json.b6_inverter_motor_compensation_angle = pkg[22] + pkg[23] * 256
    end
    return json
end
local function getB6Dynamic(json, cmd)
    local position = 23
    local result = {}
    while (cmd[position + 1] ~= nil) do
        if (cmd[position] == 0x05) then
            json = getB6SmokeDitectJson(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x03) then
            json = getB6AirDuctJson(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x06) then
            json = getB6Inverter(json, getPackage(position, cmd))
        end
        position = position + cmd[position + 1] + 2
    end
    result.json = json
    result.position = position
    return result
end
local function getTotalJson(json, pkg)
    if (pkg[1] == 0x00 or pkg[1] == 0x01) then
        json.total_power = VALUE_OFF
    elseif (pkg[1] == 0x02) then
        json.total_power = VALUE_ON
    elseif (pkg[1] == 0x03 or pkg[1] == 0x04 or pkg[1] == 0x06) then
        json.total_power = VALUE_OFF
    elseif (pkg[1] == 0x05) then
        json.total_power = 'delay_off'
    end
    if (pkg[2] ~= 0xff and getBit(pkg[2], 0) == "0") then
        json.total_lock = VALUE_OFF
    elseif (pkg[2] ~= 0xff and getBit(pkg[2], 0) == "1") then
        json.total_lock = VALUE_ON
    end
    json.total_speak = VALUE_OFF
    json.total_gesture = VALUE_OFF
    json.total_ir = VALUE_OFF
    json.total_water_shortage = "0"
    if (pkg[4] ~= 0xff) then
        if (getBit(pkg[4], 0) == "1") then json.total_ir = VALUE_ON end
        if (getBit(pkg[4], 1) == "1") then json.total_speak = VALUE_ON end
        if (getBit(pkg[4], 2) == "1") then json.total_gesture = VALUE_ON end
        json.total_water_shortage = getBit(pkg[4], 3)
    end
    if (pkg[5] ~= 0xff) then json.total_firewall_temp = pkg[5] end
    if (pkg[6] ~= 0xff) then json.total_shelving_unit_temp = pkg[6] end
    json.total_error_type = 0
    json.total_error_code = 0
    if (pkg[7] ~= 0xff) then json.total_error_type = pkg[7] end
    if (pkg[8] ~= 0xff) then json.total_error_code = pkg[8] end
    json.total_tips_type = 0
    json.total_tips_code = 0
    if (pkg[9] ~= nil and pkg[9] ~= 0xff) then json.total_tips_type = pkg[9] end
    if (pkg[10] ~= nil and pkg[10] ~= 0xff) then
        json.total_tips_code = pkg[10]
    end
    if (pkg[12] ~= nil and pkg[12] ~= 0xff) then
        if (pkg[12] ~= nil and pkg[12] ~= 0xff) then
            if (bit.band(pkg[12], 0x07) == 0x00) then
                json.b6_smoke_stove_linkage_gear = 0
            end
            if (bit.band(pkg[12], 0x07) == 0x01) then
                json.b6_smoke_stove_linkage_gear = 1
            end
            if (bit.band(pkg[12], 0x07) == 0x02) then
                json.b6_smoke_stove_linkage_gear = 2
            end
            if (bit.band(pkg[12], 0x07) == 0x03) then
                json.b6_smoke_stove_linkage_gear = 3
            end
            json.b6_smoke_stove_linkage_flowin = 'no'
            if (getBit(pkg[12], 4) == "0") then
                json.b6_smoke_stove_linkage_flowin = 'no'
            elseif (getBit(pkg[12], 4) == "1") then
                json.b6_smoke_stove_linkage_flowin = 'yes'
            end
            json.b6_smoke_stove_linkage_gear_fix = 'positive'
            if (getBit(pkg[12], 5) == "0") then
                json.b6_smoke_stove_linkage_gear_fix = 'positive'
            elseif (getBit(pkg[12], 5) == "1") then
                json.b6_smoke_stove_linkage_gear_fix = 'negative'
            end
            json.b6_power_on_light = VALUE_ON
            if (getBit(pkg[12], 6) == "0") then
                json.b6_power_on_light = VALUE_OFF
            elseif (getBit(pkg[12], 6) == "1") then
                json.b6_power_on_light = VALUE_ON
            end
            if (getBit(pkg[12], 7) == "0") then
                json.b6_smoke_stove_linkage = VALUE_OFF
            elseif (getBit(pkg[12], 7) == "1") then
                json.b6_smoke_stove_linkage = VALUE_ON
            end
        end
    end
    if (pkg[13] ~= nil and pkg[13] ~= 0xff) then
        if (pkg[13] ~= nil and pkg[13] ~= 0xff) then
            if (bit.band(pkg[13], 0x07) == 0x01) then
                json.b6_delay_gear_linkage_gear = 1
            end
            if (bit.band(pkg[13], 0x07) == 0x02) then
                json.b6_delay_gear_linkage_gear = 2
            end
            if (bit.band(pkg[13], 0x07) == 0x03) then
                json.b6_delay_gear_linkage_gear = 3
            end
            if (getBit(pkg[13], 7) == "0") then
                json.b6_delay_gear_linkage = VALUE_OFF
            elseif (getBit(pkg[13], 7) == "1") then
                json.b6_delay_gear_linkage = VALUE_ON
            end
        end
    end
    if (pkg[14] ~= nil and pkg[14] ~= 0xff) then
        if (pkg[14] ~= nil and pkg[14] ~= 0xff) then
            json.b6_delay_time_value = getNumber(bit.band(pkg[14], 0x7F))
            if (getBit(pkg[14], 7) == "0") then
                json.b6_delay_time = VALUE_OFF
            elseif (getBit(pkg[14], 7) == "1") then
                json.b6_delay_time = VALUE_ON
            end
        end
    end
    if (pkg[15] ~= nil and pkg[15] ~= 0xff) then
        if (bit.band(pkg[15], 0x0F) == 0x01) then
            json.total_lock_on_type = "local"
        end
        if (bit.band(pkg[15], 0x0F) == 0x02) then
            json.total_lock_on_type = "app"
        end
        if (bit.band(pkg[15], 0x7F) == 0x10) then
            json.total_lock_off_type = "local"
        end
        if (bit.band(pkg[15], 0x7F) == 0x10) then
            json.total_lock_off_type = "app"
        end
    end
    if (pkg[16] ~= nil and pkg[16] ~= 0xff) then
        if (pkg[16] == 0x00) then
            json.ai_voice_microphone = VALUE_ON
        elseif (pkg[16] == 0x01) then
            json.ai_voice_microphone = VALUE_OFF
        end
    end
    if (pkg[17] ~= nil and pkg[17] ~= 0xff) then
        json.ai_voice_volume = pkg[17]
    end
    if (pkg[18] ~= nil and pkg[18] ~= 0xff) then
        if (pkg[18] == 0x00) then
            json.ai_voice_status = "on"
        elseif (pkg[18] == 0x01) then
            json.ai_voice_status = "off"
        elseif (pkg[18] == 0x02) then
            json.ai_voice_status = "connecting"
        end
    end
    if (pkg[19] ~= nil and pkg[19] ~= 0xff) then
        if (pkg[19] == 0x00) then
            json.ai_voice_microphone_status = "success"
        elseif (pkg[19] == 0x01) then
            json.ai_voice_microphone_status = "failure"
        end
    end
    if (pkg[20] ~= nil and pkg[20] ~= 0xff) then
        if (pkg[20] == 0x00) then
            json.ai_voice_volume_status = "success"
        elseif (pkg[20] == 0x01) then
            json.ai_voice_volume_status = "failure"
        end
    end
    if (pkg[21] ~= nil and pkg[22] ~= nil and pkg[21] ~= 0xff and pkg[22] ~=
        0xff) then json.electronic_version = pkg[21] .. '.' .. pkg[22] end
    return json
end
local function getB6Json(json, pkg)
    if (pkg[2] ~= 0xff) then
        json.b6_steaming = "off"
        json.b6_power = VALUE_ON
        if (pkg[2] == 0x00) then
            json.b6_power = VALUE_OFF
            json.b6_work_status = "initial"
        elseif (pkg[2] == 0x01) then
            json.b6_power = VALUE_OFF
            json.b6_work_status = "power_off"
        elseif (pkg[2] == 0x02) then
            json.b6_work_status = "working"
        elseif (pkg[2] == 0x03) then
            json.b6_power = "delay_off"
            json.b6_work_status = "power_off_delay"
        elseif (pkg[2] == 0x04) then
            json.b6_steaming = "on"
            json.b6_steaming_stage = 1
            json.b6_work_status = "hotclean"
        elseif (pkg[2] == 0x0C) then
            json.b6_steaming = "on"
            json.b6_steaming_stage = 2
            json.b6_work_status = "hotclean"
        elseif (pkg[2] == 0x05) then
            json.b6_power = VALUE_OFF
            json.b6_work_status = "error"
        elseif (pkg[2] == 0x06) then
            json.b6_work_status = "clean"
        elseif (pkg[2] == 0x07) then
            json.b6_power = VALUE_OFF
            json.b6_work_status = "check"
        elseif (pkg[2] == 0x08) then
            json.b6_work_status = "vvvf_gear"
        elseif (pkg[2] == 0x09) then
            json.b6_work_status = "mute_gear"
        elseif (pkg[2] == 0x0a) then
            json.b6_work_status = "ai_dry_clean"
        elseif (pkg[2] == 0x0b) then
            json.b6_work_status = "clean_finish"
        elseif (pkg[2] == 0x0d) then
            json.b6_work_status = "air_duct_detection"
        elseif (pkg[2] == 0x0e) then
            json.b6_work_status = "standby"
        end
    end
    if (pkg[3] ~= 0xff) then json.b6_gear = pkg[3] end
    if (pkg[4] ~= 0xff or pkg[5] ~= 0xff) then
        json.b6_destination_time = pkg[4] + pkg[5] * 256
    end
    if (pkg[6] ~= 0xff or pkg[7] ~= 0xff) then
        json.b6_remaining_time = pkg[6] + pkg[7] * 256
    end
    if (pkg[8] ~= 0xff or pkg[9] ~= 0xff) then
        json.b6_air_volume = pkg[8] + pkg[9] * 256
    end
    if (pkg[10] ~= 0xff) then
        if (pkg[10] == 0x00) then
            json.b6_light = VALUE_OFF
        else
            json.b6_light = VALUE_ON
            json.b6_lightness = pkg[10]
        end
    end
    if (getBit(pkg[11], 0) == "0") then
        json.b6_hotclean_tips = 0
    elseif (getBit(pkg[11], 0) == "1") then
        json.b6_hotclean_tips = 1
    end
    if (getBit(pkg[11], 1) == "0") then
        json.b6_lock = VALUE_OFF
    elseif (getBit(pkg[11], 1) == "1") then
        json.b6_lock = VALUE_ON
    end
    if (pkg[12] ~= nil and pkg[13] ~= nil and pkg[12] ~= 0xff) then
        json.b6_wind_pressure = pkg[12] + pkg[13] * 256
    end
    if (pkg[14] ~= nil and pkg[14] ~= 0xff) then
        json.b6_last_hotclean_hour = pkg[14]
    end
    if (pkg[15] ~= nil and pkg[15] ~= 0xff) then
        if (bit.band(pkg[15], 0x0f) == 0x01) then
            json.b6_gesture_value = 'power'
        end
        if (bit.band(pkg[15], 0x0f) == 0x02) then
            json.b6_gesture_value = 'wind'
        end
        if (bit.band(pkg[15], 0x0f) == 0x03) then
            json.b6_gesture_value = 'light'
        end
        if (bit.band(pkg[15], 0x70) == 0x10) then
            json.b6_gesture_sensitivity = '1'
        end
        if (bit.band(pkg[15], 0x70) == 0x20) then
            json.b6_gesture_sensitivity = '2'
        end
        if (bit.band(pkg[15], 0x70) == 0x30) then
            json.b6_gesture_sensitivity = '3'
        end
        if (getBit(pkg[15], 7) == "0") then
            json.b6_gesture_status = VALUE_OFF
        elseif (getBit(pkg[15], 7) == "1") then
            json.b6_gesture_status = VALUE_ON
        end
    end
    if (pkg[16] ~= nil and pkg[16] ~= 0xff) then
        if (bit.band(pkg[16], 0x7F) == 0x01) then
            json.b6_smoke_detector_value = 1
        end
        if (bit.band(pkg[16], 0x7F) == 0x02) then
            json.b6_smoke_detector_value = 2
        end
        if (bit.band(pkg[16], 0x7F) == 0x03) then
            json.b6_smoke_detector_value = 3
        end
        if (bit.band(pkg[16], 0x7F) == 0x04) then
            json.b6_smoke_detector_value = 4
        end
        if (bit.band(pkg[16], 0x7F) == 0x05) then
            json.b6_smoke_detector_value = 5
        end
        if (bit.band(pkg[16], 0x7F) == 0x06) then
            json.b6_smoke_detector_value = 6
        end
        if (bit.band(pkg[16], 0x7F) == 0x07) then
            json.b6_smoke_detector_value = 7
        end
        if (getBit(pkg[16], 7) == "0") then
            json.b6_smoke_detector = VALUE_OFF
        elseif (getBit(pkg[16], 7) == "1") then
            json.b6_smoke_detector = VALUE_ON
        end
    end
    if (pkg[17] ~= nil and pkg[17] ~= 0xff) then
        if (bit.band(pkg[17], 0x79) == 0x01) then
            json.b6_infrared_value = 'power'
        end
        if (bit.band(pkg[17], 0x79) == 0x02) then
            json.b6_infrared_value = 'wind'
        end
        if (getBit(pkg[17], 7) == "0") then
            json.b6_infrared_status = VALUE_OFF
        elseif (getBit(pkg[17], 7) == "1") then
            json.b6_infrared_status = VALUE_ON
        end
    end
    if (pkg[18] ~= nil and pkg[18] ~= 0xff) then
        if (bit.band(pkg[18], 0x79) == 0x01) then
            json.b6_TVOC_value = '优'
        end
        if (bit.band(pkg[18], 0x79) == 0x02) then
            json.b6_TVOC_value = '良'
        end
        if (bit.band(pkg[18], 0x79) == 0x03) then
            json.b6_TVOC_value = '中'
        end
        if (getBit(pkg[18], 7) == "0") then
            json.b6_TVOC_status = VALUE_OFF
        elseif (getBit(pkg[18], 7) == "1") then
            json.b6_TVOC_status = VALUE_ON
        end
    end
    if (pkg[19] ~= 0xff) then json.b6_smoke_potency = pkg[19] end
    if (pkg[20] ~= nil and pkg[20] ~= 0xff) then
        if (bit.band(pkg[20], 0x0F) == 0x01) then
            json.b6_power_on_type = "local"
        end
        if (bit.band(pkg[20], 0x0F) == 0x02) then
            json.b6_power_on_type = "app"
        end
        if (bit.band(pkg[20], 0x0F) == 0x03) then
            json.b6_power_on_type = "gesture"
        end
        if (bit.band(pkg[20], 0x0F) == 0x05) then
            json.b6_power_on_type = "linkage"
        end
        if (bit.band(pkg[20], 0x70) == 0x10) then
            json.b6_power_off_type = "local"
        end
        if (bit.band(pkg[20], 0x70) == 0x20) then
            json.b6_power_off_type = "app"
        end
        if (bit.band(pkg[20], 0x70) == 0x30) then
            json.b6_power_off_type = "gesture"
        end
        if (bit.band(pkg[20], 0x70) == 0x50) then
            json.b6_power_off_type = "linkage"
        end
        if (bit.band(pkg[20], 0x70) == 0x70) then
            json.b6_power_off_type = "delay"
        end
    end
    if (pkg[21] ~= nil and pkg[21] ~= 0xff) then
        if (bit.band(pkg[21], 0x0F) == 0x01) then
            json.b6_light_on_type = "local"
        end
        if (bit.band(pkg[21], 0x0F) == 0x02) then
            json.b6_light_on_type = "app"
        end
        if (bit.band(pkg[21], 0x0F) == 0x03) then
            json.b6_light_on_type = "gesture"
        end
        if (bit.band(pkg[21], 0x70) == 0x10) then
            json.b6_light_off_type = "local"
        end
        if (bit.band(pkg[21], 0x70) == 0x20) then
            json.b6_light_off_type = "app"
        end
        if (bit.band(pkg[21], 0x70) == 0x30) then
            json.b6_light_off_type = "gesture"
        end
        if (bit.band(pkg[21], 0x70) == 0x40) then
            json.b6_light_off_type = "error"
        end
    end
    if (pkg[22] ~= nil and pkg[22] ~= 0xff) then
        if (bit.band(pkg[22], 0x7F) == 0x01) then
            json.b6_gear_control_type = "local"
        end
        if (bit.band(pkg[22], 0x7F) == 0x02) then
            json.b6_gear_control_type = "app"
        end
        if (bit.band(pkg[22], 0x7F) == 0x03) then
            json.b6_gear_control_type = "gesture"
        end
        if (bit.band(pkg[22], 0x7F) == 0x05) then
            json.b6_gear_control_type = "linkage"
        end
        if (bit.band(pkg[22], 0x7F) == 0x06) then
            json.b6_gear_control_type = "smoke_detector"
        end
    end
    local result = getB6Dynamic(json, pkg)
    local position = result.position
    json = result.json
    if (pkg[position] ~= nil and pkg[position] ~= 0xff) then
        if (bit.band(pkg[position], 0x0F) == 0x01) then
            json.b6_lock_on_type = "local"
        end
        if (bit.band(pkg[position], 0x0F) == 0x02) then
            json.b6_lock_on_type = "app"
        end
        if (bit.band(pkg[position], 0x7F) == 0x10) then
            json.b6_lock_off_type = "local"
        end
        if (bit.band(pkg[position], 0x7F) == 0x10) then
            json.b6_lock_off_type = "app"
        end
    end
    return json
end
local function getB7Json(json, pkg)
    local prefix = 'b7_left_'
    if (pkg[1] == 2) then prefix = 'b7_right_' end
    if (pkg[2] == 0x00 or pkg[2] == 0x01) then
        json[prefix .. 'status'] = "power_off"
    elseif (pkg[2] == 0x02) then
        json[prefix .. 'status'] = "working"
    elseif (pkg[2] == 0x03) then
        json[prefix .. 'status'] = "ai"
    end
    if (pkg[3] ~= 0xff) then json[prefix .. 'gear'] = pkg[3] end
    if (pkg[4] ~= 0xff or pkg[5] ~= 0xff) then
        json[prefix .. 'destination_time'] = pkg[4] + pkg[5] * 256
    end
    if (pkg[6] ~= 0xff or pkg[7] ~= 0xff) then
        json[prefix .. 'remaining_time'] = pkg[6] + pkg[7] * 256
        if (json[prefix .. 'remaining_time'] > 0) then
            json[prefix .. 'status'] = "power_off_delay"
        end
    end
    if (pkg[8] ~= 0xff or pkg[9] ~= 0xff) then
        json[prefix .. 'destination_temp'] = pkg[8] + pkg[9] * 256
    end
    if (pkg[10] ~= 0xff or pkg[11] ~= 0xff) then
        json[prefix .. 'current_temp'] = pkg[10] + pkg[11] * 256
    end
    if (pkg[12] ~= 0xff or pkg[13] ~= 0xff) then
        json[prefix .. 'work_time'] = pkg[12] + pkg[13] * 256
    end
    if (pkg[14] ~= 0xff) then
        json[prefix .. 'has_pot'] = getBit(pkg[14], 0)
        json[prefix .. 'has_fire'] = getBit(pkg[14], 1)
        json[prefix .. 'gas_leakage'] = getBit(pkg[14], 2)
        json[prefix .. 'dry_burning'] = getBit(pkg[14], 3)
        json[prefix .. 'dry_burning_invalid'] = getBit(pkg[14], 4)
    end
    if (pkg[15] ~= nil and pkg[15] ~= 0xff) then
        if (bit.band(pkg[15], 0x7F) == 0x01) then
            json[prefix .. 'power_off_type'] = "local"
        end
        if (bit.band(pkg[15], 0x7F) == 0x02) then
            json[prefix .. 'power_off_type'] = "app"
        end
        if (bit.band(pkg[15], 0x7F) == 0x03) then
            json[prefix .. 'power_off_type'] = "delay"
        end
        if (bit.band(pkg[15], 0x7F) == 0x04) then
            json[prefix .. 'power_off_type'] = "error"
        end
        if (bit.band(pkg[15], 0x7F) == 0x05) then
            json[prefix .. 'power_off_type'] = "ecu"
        end
    end
    return json
end
local function getB3Json(json, pkg)
    local prefix = 'b3_upstair_'
    if (pkg[1] == 2) then prefix = 'b3_downstair_' end
    if (pkg[2] == 0x00 or pkg[2] == 0x01) then
        json[prefix .. 'status'] = "power_off"
    elseif (pkg[2] == 0x02) then
        json[prefix .. 'status'] = "uperization"
    elseif (pkg[2] == 0x03) then
        json[prefix .. 'status'] = "uperization_pause"
    elseif (pkg[2] == 0x04) then
        json[prefix .. 'status'] = "drying"
    elseif (pkg[2] == 0x05) then
        json[prefix .. 'status'] = "drying_pause"
    elseif (pkg[2] == 0x06) then
        json[prefix .. 'status'] = "ion_drying"
    elseif (pkg[2] == 0x07) then
        json[prefix .. 'status'] = "ion_drying_pause"
    elseif (pkg[2] == 0x08) then
        json[prefix .. 'status'] = "warm_drink"
    elseif (pkg[2] == 0x09) then
        json[prefix .. 'status'] = "warm_drink_pause"
    end
    if (pkg[3] ~= 0xff or pkg[4] ~= 0xff) then
        json[prefix .. 'destination_time'] = pkg[3] + pkg[4] * 256
    end
    if (pkg[5] ~= 0xff or pkg[6] ~= 0xff) then
        json[prefix .. 'remaining_time'] = pkg[5] + pkg[6] * 256
    end
    if (pkg[7] ~= 0xff) then
        json[prefix .. 'sensor'] = pkg[7]
        json[prefix .. 'door_lock'] = getBit(pkg[7], 0)
        if (getBit(pkg[7], 1) == "0") then
            json[prefix .. 'door'] = "close"
        elseif (getBit(pkg[7], 1) == "1") then
            json[prefix .. 'door'] = "open"
        end
        json[prefix .. 'infrared'] = getBit(pkg[7], 2)
        json[prefix .. 'ultraviolet'] = getBit(pkg[7], 3)
    end
    if (pkg[8] ~= 0xff or pkg[8] ~= nil) then
        json[prefix .. 'destination_temp'] = pkg[8]
    end
    if (pkg[9] ~= 0xff or pkg[9] ~= nil) then
        json[prefix .. 'current_temp'] = pkg[9]
    end
    if (pkg[10] ~= nil and pkg[10] ~= 0xff) then
        if (bit.band(pkg[10], 0x0F) == 0x01) then
            json.b3_disinfect_on_type = "local"
        end
        if (bit.band(pkg[10], 0x0F) == 0x02) then
            json.b3_disinfect_on_type = "app"
        end
        if (bit.band(pkg[10], 0x70) == 0x10) then
            json.b3_disinfect_off_type = "local"
        end
        if (bit.band(pkg[10], 0x70) == 0x20) then
            json.b3_disinfect_off_type = "app"
        end
    end
    if (pkg[11] ~= nil and pkg[11] ~= 0xff) then
        if (bit.band(pkg[11], 0x0F) == 0x01) then
            json.b3_thermotank_on_type = "local"
        end
        if (bit.band(pkg[11], 0x0F) == 0x02) then
            json.b3_thermotank_on_type = "app"
        end
        if (bit.band(pkg[11], 0x70) == 0x10) then
            json.b3_thermotank_off_type = "local"
        end
        if (bit.band(pkg[11], 0x70) == 0x20) then
            json.b3_thermotank_off_type = "app"
        end
    end
    return json
end
local function getB2Json(json, pkg)
    local prefix = 'b2_upstair_'
    if (pkg[1] == 2) then prefix = 'b2_downstair_' end
    if (pkg[2] == 0x00 or pkg[2] == 0x01) then
        json[prefix .. 'work_status'] = "power_off"
    elseif (pkg[2] == 0x02) then
        json[prefix .. 'work_status'] = "working"
    elseif (pkg[2] == 0x03) then
        json[prefix .. 'work_status'] = "pause"
    elseif (pkg[2] == 0x04) then
        json[prefix .. 'work_status'] = "order"
    elseif (pkg[2] == 0x05) then
        json[prefix .. 'work_status'] = "drying"
    elseif (pkg[2] == 0x06) then
        json[prefix .. 'work_status'] = "auto"
    elseif (pkg[2] == 0x07) then
        json[prefix .. 'work_status'] = "finish"
    elseif (pkg[2] == 0x08) then
        json[prefix .. 'work_status'] = "standby"
    end
    if (pkg[3] ~= 0xff) then json[prefix .. 'work_func'] = pkg[3] end
    if (pkg[4] ~= 0xff) then json[prefix .. 'work_menu'] = pkg[4] end
    if (pkg[5] ~= 0xff or pkg[6] ~= 0xff) then
        json[prefix .. 'work_destination_time'] = pkg[5] + pkg[6] * 256
    end
    if (pkg[7] ~= 0xff or pkg[8] ~= 0xff) then
        json[prefix .. 'work_remaining_time'] = pkg[7] + pkg[8] * 256
    end
    if (pkg[9] ~= 0xff or pkg[10] ~= 0xff) then
        json[prefix .. 'destination_temp'] = pkg[9] + pkg[10] * 256
    end
    if (pkg[11] ~= 0xff or pkg[12] ~= 0xff) then
        json[prefix .. 'current_temp'] = pkg[11] + pkg[12] * 256
    end
    if (pkg[13] ~= 0xff or pkg[14] ~= 0xff) then
        json[prefix .. 'order_destination_time'] = pkg[13] + pkg[14] * 256
    end
    if (pkg[15] ~= 0xff or pkg[16] ~= 0xff) then
        json[prefix .. 'order_remaining_time'] = pkg[15] + pkg[16] * 256
    end
    if (pkg[17] ~= 0xff and pkg[17] ~= nil) then
        if (getBit(pkg[17], 0) == "0") then
            json[prefix .. 'door'] = "close"
        elseif (getBit(pkg[17], 0) == "1") then
            json[prefix .. 'door'] = "open"
        end
        if (getBit(pkg[17], 7) == "0") then
            json[prefix .. 'light'] = "off"
        elseif (getBit(pkg[17], 7) == "1") then
            json[prefix .. 'light'] = "on"
        end
    end
    if (pkg[18] ~= 0xff and pkg[18] ~= nil) then
        if (getBit(pkg[18], 0) == "0") then
            json[prefix .. 'lock'] = "off"
        elseif (getBit(pkg[18], 0) == "1") then
            json[prefix .. 'lock'] = "on"
        end
        if (getBit(pkg[18], 1) == "0") then
            json[prefix .. 'preheating'] = "none"
        elseif (getBit(pkg[18], 1) == "1" and getBit(pkg[18], 2) == "0") then
            json[prefix .. 'preheating'] = "preheating"
        elseif (getBit(pkg[18], 2) == "1") then
            json[prefix .. 'preheating'] = "finish"
        end
        json[prefix .. 'water_shortage'] = getBit(pkg[18], 3)
        json[prefix .. 'clean_tips'] = getBit(pkg[18], 4)
        json[prefix .. 'must_clean_tips'] = getBit(pkg[18], 5)
        json[prefix .. 'fresh_water'] = getBit(pkg[18], 6)
    end
    json[prefix .. 'recipe_code'] = -1
    if (pkg[19] ~= nil and pkg[20] ~= nil and
        (pkg[19] ~= 0xff or pkg[20] ~= 0xff)) then
        json[prefix .. 'recipe_code'] = pkg[19] + pkg[20] * 256
    end
    if (pkg[21] ~= 0xff and pkg[21] ~= nil) then
        json[prefix .. 'recipe_total_steps'] = pkg[21]
    end
    if (pkg[22] ~= 0xff and pkg[22] ~= nil) then
        json[prefix .. 'recipe_current_step'] = pkg[22]
    end
    if (pkg[23] ~= 0xff and pkg[23] ~= nil) then
        json[prefix .. 'recipe_current_mode'] = pkg[23]
    end
    if (pkg[24] ~= 0xff and pkg[24] ~= nil) then
        json[prefix .. 'recipe_after'] = pkg[24]
    end
    if (pkg[25] ~= nil and pkg[25] ~= 0xff) then
        if (bit.band(pkg[25], 0x0F) == 0x01) then
            json[prefix .. 'power_on_type'] = "local"
        end
        if (bit.band(pkg[25], 0x0F) == 0x02) then
            json[prefix .. 'power_on_type'] = "app"
        end
        if (bit.band(pkg[25], 0x0F) == 0x05) then
            json[prefix .. 'power_on_type'] = "order"
        end
        if (bit.band(pkg[25], 0xF0) == 0x10) then
            json[prefix .. 'power_off_type'] = "local"
        end
        if (bit.band(pkg[25], 0xF0) == 0x20) then
            json[prefix .. 'power_off_type'] = "app"
        end
        if (bit.band(pkg[25], 0xF0) == 0x30) then
            json[prefix .. 'power_off_type'] = "wifi"
        end
        if (bit.band(pkg[25], 0xF0) == 0x50) then
            json[prefix .. 'power_off_type'] = "error"
        end
        if (bit.band(pkg[25], 0xF0) == 0x70) then
            json[prefix .. 'power_off_type'] = "auto"
        end
    end
    if (pkg[26] ~= nil and pkg[26] ~= 0xff) then
        if (bit.band(pkg[26], 0x0F) == 0x01) then
            json[prefix .. 'light_on_type'] = "local"
        end
        if (bit.band(pkg[26], 0x0F) == 0x02) then
            json[prefix .. 'light_on_type'] = "app"
        end
        if (bit.band(pkg[26], 0xF0) == 0x10) then
            json[prefix .. 'light_off_type'] = "local"
        end
        if (bit.band(pkg[26], 0xF0) == 0x20) then
            json[prefix .. 'light_off_type'] = "app"
        end
    end
    if (pkg[27] ~= nil and pkg[27] ~= 0xff) then
        if (bit.band(pkg[27], 0x0F) == 0x01) then
            json[prefix .. 'recipe_on_type'] = "local"
        end
        if (bit.band(pkg[27], 0x0F) == 0x02) then
            json[prefix .. 'recipe_on_type'] = "app"
        end
        if (bit.band(pkg[27], 0x0F) == 0x05) then
            json[prefix .. 'recipe_on_type'] = "order"
        end
        if (bit.band(pkg[27], 0xF0) == 0x10) then
            json[prefix .. 'recipe_on_type'] = "local"
        end
        if (bit.band(pkg[27], 0xF0) == 0x20) then
            json[prefix .. 'recipe_on_type'] = "app"
        end
        if (bit.band(pkg[27], 0xF0) == 0x30) then
            json[prefix .. 'recipe_on_type'] = "wifi"
        end
        if (bit.band(pkg[27], 0xF0) == 0x50) then
            json[prefix .. 'recipe_on_type'] = "error"
        end
        if (bit.band(pkg[27], 0xF0) == 0x70) then
            json[prefix .. 'recipe_on_type'] = "auto"
        end
    end
    return json
end
local function getE7Json(json, pkg)
    local prefix = 'e7_left_'
    if (pkg[1] == 1) then
        prefix = 'e7_left_'
    elseif (pkg[1] == 2) then
        prefix = 'e7_right_'
    elseif (pkg[1] == 3) then
        prefix = 'e7_left_top_'
    elseif (pkg[1] == 4) then
        prefix = 'e7_left_bottom_'
    elseif (pkg[1] == 5) then
        prefix = 'e7_right_top_'
    elseif (pkg[1] == 6) then
        prefix = 'e7_right_bottom_'
    else
        prefix = 'e7_' .. pkg[1] .. '_'
    end
    if (pkg[2] == 0x00 or pkg[2] == 0x01) then
        json[prefix .. 'work_status'] = "power_off"
    elseif (pkg[2] == 0x02) then
        json[prefix .. 'work_status'] = "working"
    elseif (pkg[2] == 0x03) then
        json[prefix .. 'work_status'] = "order"
    end
    if (pkg[3] == 0x00) then
        json[prefix .. 'mode'] = "none"
    elseif (pkg[3] == 0x01) then
        json[prefix .. 'mode'] = "heat_preservation"
    elseif (pkg[3] == 0x02) then
        json[prefix .. 'mode'] = "stew_soup"
    elseif (pkg[3] == 0x03) then
        json[prefix .. 'mode'] = "boiling"
    elseif (pkg[3] == 0x04) then
        json[prefix .. 'mode'] = "stir_frying"
    end
    if (pkg[4] ~= 0xff) then json[prefix .. 'gear'] = pkg[4] end
    if (pkg[5] ~= 0xff or pkg[6] ~= 0xff) then
        json[prefix .. 'efficiency'] = pkg[5] + pkg[6] * 256
    end
    if (pkg[7] ~= 0xff or pkg[8] ~= 0xff) then
        json[prefix .. 'work_time'] = pkg[7] + pkg[8] * 256
    end
    if (pkg[9] ~= 0xff or pkg[10] ~= 0xff) then
        json[prefix .. 'destination_time'] = pkg[9] + pkg[10] * 256
    end
    if (pkg[11] ~= 0xff or pkg[12] ~= 0xff) then
        json[prefix .. 'remaining_time'] = pkg[11] + pkg[12] * 256
    end
    if (pkg[13] ~= nil and pkg[13] ~= 0xff) then
        json[prefix .. 'has_pot'] = getBit(pkg[13], 0)
    end
    if (pkg[14] ~= nil and pkg[14] ~= 0xff) then
        if (pkg[14] == 0x00) then
            json[prefix .. 'bridge_link'] = VALUE_OFF
        elseif (pkg[14] == 0x01) then
            json[prefix .. 'bridge_link'] = VALUE_ON
        end
    end
    return json
end
local function getSpJson(json, pkg)
    local prefix = 'sp_0_'
    if (pkg[1] == 1) then
        prefix = 'sp_fandrying_'
    elseif (pkg[1] == 2) then
        prefix = 'sp_heatingdisk_'
    elseif (pkg[1] == 3) then
        prefix = 'sp_uvc_'
    else
        prefix = 'sp_' .. pkg[1] .. '_'
    end
    if (pkg[2] == 0x00) then
        json[prefix .. 'status'] = "off"
    elseif (pkg[2] == 0x01) then
        json[prefix .. 'status'] = "on"
    elseif (pkg[2] == 0x02) then
        json[prefix .. 'status'] = "order"
    elseif (pkg[2] == 0x04) then
        json[prefix .. 'status'] = "pause"
    elseif (pkg[2] == 0x05) then
        json[prefix .. 'status'] = "preheat"
    end
    if (pkg[3] ~= 0xff or pkg[4] ~= 0xff) then
        json[prefix .. 'destination_time'] = pkg[3] + pkg[4] * 256
    end
    if (pkg[5] ~= 0xff or pkg[6] ~= 0xff) then
        json[prefix .. 'remaining_time'] = pkg[5] + pkg[6] * 256
    end
    if (pkg[7] ~= 0xff) then json[prefix .. 'temperature'] = pkg[7] end
    if (pkg[8] ~= 0xff or pkg[9] ~= 0xff) then
        json[prefix .. 'order_destination_time'] = pkg[8] + pkg[9] * 256
    end
    if (pkg[10] ~= 0xff or pkg[11] ~= 0xff) then
        json[prefix .. 'order_remaining_time'] = pkg[10] + pkg[11] * 256
    end
    if (pkg[12] ~= nil) then
        local linkage = getBit(pkg[12], 0);
        if (linkage == '0') then
            json[prefix .. 'setting_linkage'] = 'off'
        elseif (linkage == '1') then
            json[prefix .. 'setting_linkage'] = 'on'
        end
        local automode = getBit(pkg[12], 1);
        if (automode == '0') then
            json[prefix .. 'setting_automode'] = 'off'
        elseif (automode == '1') then
            json[prefix .. 'setting_automode'] = 'on'
        end
        local door = getBit(pkg[12], 2);
        if (door == '0') then
            json[prefix .. 'door'] = 'close'
        elseif (door == '1') then
            json[prefix .. 'door'] = 'open'
        end
        local synchron = getBit(pkg[12], 3);
        if (synchron == '0') then
            json[prefix .. 'setting_sync'] = 'off'
        elseif (synchron == '1') then
            json[prefix .. 'setting_sync'] = 'on'
        end
        local synchron = getBit(pkg[12], 4);
        if (synchron == '0') then
            json[prefix .. 'setting_linkcooker'] = 'off'
        elseif (synchron == '1') then
            json[prefix .. 'setting_linkcooker'] = 'on'
        end
    end
    if (pkg[13] ~= nil and pkg[13] ~= 0xff) then
        json[prefix .. 'setting_automode_day'] = pkg[13]
    end
    if (pkg[14] ~= nil and pkg[14] ~= 0xff) then
        json[prefix .. 'setting_automode_starthour'] = pkg[14]
    end
    if (pkg[15] ~= nil and pkg[15] ~= 0xff) then
        json[prefix .. 'setting_automode_startminute'] = pkg[15]
    end
    return json
end
local function getACJson(json, pkg)
    if (pkg[2] == 0x00 or pkg[2] == 0x01) then
        json.ac_work_status = "power_off"
    elseif (pkg[2] == 0x02) then
        json.ac_work_status = "working"
    elseif (pkg[2] == 0x03) then
        json.ac_work_status = "order"
    elseif (pkg[2] == 0x04) then
        json.ac_work_status = "reservation"
    elseif (pkg[2] == 0x06) then
        json.ac_work_status = "reservation_and_order_reserving"
    elseif (pkg[2] == 0x07) then
        json.ac_work_status = "reservation_and_order_ordering"
    end
    if (pkg[3] == 0x00) then
        json.ac_mode = "none"
    elseif (pkg[3] == 0x01) then
        json.ac_mode = "refrigeration"
    elseif (pkg[3] == 0x02) then
        json.ac_mode = "air_supply"
    elseif (pkg[3] == 0x03) then
        json.ac_mode = "dehumidification"
    elseif (pkg[3] == 0x04) then
        json.ac_mode = "net_flavour"
    end
    if (pkg[4] ~= 0xff) then json.ac_gear = pkg[4] end
    if (pkg[5] ~= 0xff or pkg[6] ~= 0xff) then
        json.ac_destination_time = pkg[5] + pkg[6] * 256
    end
    if (pkg[7] ~= 0xff or pkg[8] ~= 0xff) then
        json.ac_remaining_time = pkg[7] + pkg[8] * 256
    end
    if (pkg[9] ~= 0xff or pkg[10] ~= 0xff) then
        json.ac_destination_temp = pkg[9] + pkg[10] * 256
    end
    if (pkg[11] ~= 0xff or pkg[12] ~= 0xff) then
        json.ac_current_temp = pkg[11] + pkg[12] * 256
    end
    if (pkg[13] ~= 0xff or pkg[14] ~= 0xff) then
        json.ac_order_destination_time = pkg[13] + pkg[14] * 256
    end
    if (pkg[15] ~= 0xff or pkg[16] ~= 0xff) then
        json.ac_order_remaining_time = pkg[15] + pkg[16] * 256
    end
    if (getBit(pkg[17], 0) == "0") then
        json.ac_swing = "off"
    elseif (getBit(pkg[17], 0) == "1") then
        json.ac_swing = "on"
    end
    if (getBit(pkg[17], 1) == "0") then
        json.ac_air_direction = "off"
    elseif (getBit(pkg[17], 1) == "1") then
        json.ac_air_direction = "on"
    end
    if (getBit(pkg[17], 3) == "0") then
        json.ac_draining_pump = "off"
    elseif (getBit(pkg[17], 3) == "1") then
        json.ac_draining_pump = "on"
    end
    if (getBit(pkg[17], 4) == "0") then
        json.ac_cooling_fan = "off"
    elseif (getBit(pkg[17], 4) == "1") then
        json.ac_cooling_fan = "on"
    end
    json.ac_water_full = getBit(pkg[18], 3)
    json.ac_over_temperature = getBit(pkg[18], 4)
    json.ac_low_temperature = getBit(pkg[18], 5)
    if (pkg[19] ~= nil and pkg[19] ~= 0xff or pkg[20] ~= 0xff) then
        json.ac_ambient_temperature = pkg[19] + pkg[20] * 256
    end
    if (pkg[21] ~= nil and pkg[21] ~= 0xff) then json.ac_swing_gear = pkg[21] end
    if (pkg[22] ~= nil and pkg[22] ~= 0xff) then
        json.ac_swing_min_angle = pkg[22]
    end
    if (pkg[23] ~= nil and pkg[23] ~= 0xff) then
        json.ac_swing_max_anangle = pkg[23]
    end
    if (pkg[24] ~= nil and pkg[24] ~= 0xff) then
        json.ac_air_direction_gear = pkg[24]
    end
    if (pkg[25] ~= nil and pkg[25] ~= 0xff) then
        json.ac_air_direction_min_angle = pkg[25]
    end
    if (pkg[26] ~= nil and pkg[26] ~= 0xff) then
        json.ac_air_direction_max_anangle = pkg[26]
    end
    if (pkg[33] ~= nil and pkg[33] ~= 0xff) then
        if (bit.band(pkg[33], 0x0F) == 0x01) then
            json[prefix .. 'power_on_type'] = "local"
        end
        if (bit.band(pkg[33], 0x0F) == 0x02) then
            json[prefix .. 'power_on_type'] = "app"
        end
        if (bit.band(pkg[33], 0xF0) == 0x10) then
            json[prefix .. 'power_off_type'] = "local"
        end
        if (bit.band(pkg[33], 0xF0) == 0x20) then
            json[prefix .. 'power_off_type'] = "app"
        end
        if (bit.band(pkg[33], 0xF0) == 0x30) then
            json[prefix .. 'power_off_type'] = "wifi"
        end
        if (bit.band(pkg[33], 0xF0) == 0x50) then
            json[prefix .. 'power_off_type'] = "error"
        end
    end
    if (pkg[34] ~= nil and pkg[34] ~= 0xff) then
        if (bit.band(pkg[34], 0x0F) == 0x01) then
            json[prefix .. 'power_on_type'] = "local"
        end
        if (bit.band(pkg[34], 0x0F) == 0x02) then
            json[prefix .. 'power_on_type'] = "app"
        end
    end
    return json
end
local function getBFJson(json, pkg)
    if (pkg[1] == 0x00) then
        json.bf_control_back = 'success'
    elseif (pkg[1] == 0x01) then
        json.bf_control_back = 'status_notsupport'
    elseif (pkg[1] == 0x02) then
        json.bf_control_back = 'func_notsupport'
    elseif (pkg[1] == 0x03) then
        json.bf_control_back = 'value_notsupport'
    end
    if (pkg[2] ~= 0xFF and pkg[3] ~= 0xFF and pkg[4] ~= 0xFF) then
        json.bf_recipe_code = pkg[2] * 256 * 256 + pkg[3] * 256 + pkg[4]
    end
    if (pkg[5] ~= 0xFF) then
        json.bf_step_total = bit.band(pkg[5], 0x0F)
        json.bf_step_current = bit.band(pkg[5], 0xF0)
    end
    if (pkg[6] ~= 0xFF) then
        if (getBit(pkg[6], 0) == '1') then
            json.bf_preheat = true
        else
            json.bf_preheat = false
        end
        if (getBit(pkg[6], 1) == '1') then
            json.bf_probe = true
        else
            json.bf_probe = false
        end
        if (getBit(pkg[6], 2) == '1') then
            json.bf_order = true
        else
            json.bf_order = false
        end
        if (getBit(pkg[6], 3) == '1') then
            json.bf_turntable = true
        else
            json.bf_turntable = false
        end
        if (getBit(pkg[6], 4) == '1') then
            json.bf_hotwind = true
        else
            json.bf_hotwind = false
        end
        if (getBit(pkg[6], 7) == '1') then
            json.bf_cavity = 'down'
        else
            json.bf_cavity = 'up'
        end
    end
    if (pkg[7] ~= 0xFF and pkg[8] ~= 0xFF) then
        json.bf_mode = pkg[7] * 256 + pkg[8]
    end
    if (pkg[9] ~= 0xFF and pkg[10] ~= 0xFF and pkg[11] ~= 0xFF) then
        json.bf_working_time = pkg[9] * 256 * 256 + pkg[10] * 256 + pkg[11]
    end
    if (pkg[12] ~= 0xFF) then json.bf_fire = pkg[12] end
    if (pkg[13] ~= 0xFF and pkg[14] ~= 0xFF) then
        json.bf_temp_up_set = pkg[13] * 256 + pkg[14]
    end
    if (pkg[15] ~= 0xFF and pkg[16] ~= 0xFF) then
        json.bf_temp_down_set = pkg[15] * 256 + pkg[16]
    end
    if (pkg[17] ~= 0xFF and pkg[18] ~= 0xFF) then
        json.bf_temp_probe_set = pkg[17] * 256 + pkg[18]
    end
    if (pkg[19] ~= 0xFF) then json.bf_steam = pkg[19] end
    if (pkg[21] ~= 0xFF) then json.bf_end_next = pkg[21] end
    if (pkg[22] ~= 0xFF and pkg[23] ~= 0xFF and pkg[24] ~= 0xFF) then
        json.bf_remaining_time = pkg[22] * 256 * 256 + pkg[23] * 256 + pkg[24]
    end
    if (pkg[25] ~= 0xFF and pkg[26] ~= 0xFF) then
        json.bf_temp_up = pkg[25] * 256 + pkg[26]
    end
    if (pkg[27] ~= 0xFF and pkg[28] ~= 0xFF) then
        json.bf_temp_down = pkg[27] * 256 + pkg[28]
    end
    if (pkg[29] ~= 0xFF and pkg[30] ~= 0xFF) then
        json.bf_temp_probe = pkg[29] * 256 + pkg[30]
    end
    if (pkg[31] == 0x01) then
        json.bf_work_status = "power_off"
    elseif (pkg[31] == 0x02) then
        json.bf_work_status = "open"
    elseif (pkg[31] == 0x03) then
        json.bf_work_status = "working"
    elseif (pkg[31] == 0x04) then
        json.bf_work_status = "done"
    elseif (pkg[31] == 0x05) then
        json.bf_work_status = "order"
    elseif (pkg[31] == 0x06) then
        json.bf_work_status = "pause"
    elseif (pkg[31] == 0x07) then
        json.bf_work_status = "pause_temporarily"
    elseif (pkg[31] == 0x08) then
        json.bf_work_status = "love_three_seconds"
    elseif (pkg[31] == 0x09) then
        json.bf_work_status = "cloudmenu_setting"
    elseif (pkg[31] == 0x0A) then
        json.bf_work_status = "self_check"
    elseif (pkg[31] == 0x0B) then
        json.bf_work_status = "check_version"
    elseif (pkg[31] == 0x0C) then
        json.bf_work_status = "demo"
    elseif (pkg[31] == 0x0E) then
        json.bf_work_status = "after_sale"
    elseif (pkg[31] == 0x0F) then
        json.bf_work_status = "keep"
    end
    if (getBit(pkg[32], 0) == '1') then
        json.bf_lock = 'on'
    else
        json.bf_lock = 'off'
    end
    if (getBit(pkg[32], 1) == '1') then
        json.bf_door = 'on'
    else
        json.bf_door = 'off'
    end
    if (getBit(pkg[32], 2) == '1') then
        json.bf_water_box = 'on'
    else
        json.bf_water_box = 'off'
    end
    if (getBit(pkg[32], 3) == '1') then
        json.bf_water_shortage = 'on'
    else
        json.bf_water_shortage = 'off'
    end
    if (getBit(pkg[32], 4) == '1') then
        json.bf_water_change = 'on'
    else
        json.bf_water_change = 'off'
    end
    if (getBit(pkg[32], 5) == '1') then
        json.bf_preheat = 'on'
    else
        json.bf_preheat = 'off'
    end
    if (getBit(pkg[32], 6) == '1') then
        json.bf_preheat_done = 'on'
    else
        json.bf_preheat_done = 'off'
    end
    if (getBit(pkg[32], 7) == '1') then
        json.bf_error = 'on'
    else
        json.bf_error = 'off'
    end
    if (getBit(pkg[33], 0) == '1') then
        json.bf_flip = 'on'
    else
        json.bf_flip = 'off'
    end
    if (getBit(pkg[33], 1) == '1') then
        json.bf_sensor = 'on'
    else
        json.bf_sensor = 'off'
    end
    if (getBit(pkg[33], 2) == '1') then
        json.bf_light = 'on'
    else
        json.bf_light = 'off'
    end
    if (getBit(pkg[33], 3) == '1') then
        json.bf_hightemp_lock = 'on'
    else
        json.bf_hightemp_lock = 'off'
    end
    if (getBit(pkg[33], 4) == '1') then
        json.bf_hightemp_error = 'on'
    else
        json.bf_hightemp_error = 'off'
    end
    if (getBit(pkg[33], 5) == '1') then
        json.bf_hightemp_over = 'on'
    else
        json.bf_hightemp_over = 'off'
    end
    if (getBit(pkg[33], 6) == '1') then
        json.bf_probe_meat = 'on'
    else
        json.bf_probe_meat = 'off'
    end
    if (getBit(pkg[34], 0) == '1') then
        json.bf_order_time_isabsolute = 'on'
    else
        json.bf_order_time_isabsolute = 'off'
    end
    if (getBit(pkg[34], 1) == '1') then
        json.bf_voice_module = 'on'
    else
        json.bf_voice_module = 'off'
    end
    if (getBit(pkg[34], 2) == '1') then
        json.bf_voice_identify = 'on'
    else
        json.bf_voice_identify = 'off'
    end
    if (getBit(pkg[34], 3) == '1') then
        json.bf_voice_identify = 'on'
    else
        json.bf_voice_identify = 'off'
    end
    if (getBit(pkg[34], 4) == '1') then
        json.bf_temp_fahrenheit = 'on'
    else
        json.bf_temp_fahrenheit = 'off'
    end
    if (getBit(pkg[34], 5) == '1') then
        json.bf_sabbath = 'on'
    else
        json.bf_sabbath = 'off'
    end
    if (getBit(pkg[34], 7) == '1') then
        json.bf_off_fromapp = 'on'
    else
        json.bf_off_fromapp = 'off'
    end
    if (getBit(pkg[35], 0) == '1') then
        json.bf_stove_1 = 'on'
    else
        json.bf_stove_1 = 'off'
    end
    if (getBit(pkg[35], 1) == '1') then
        json.bf_stove_2 = 'on'
    else
        json.bf_stove_2 = 'off'
    end
    if (getBit(pkg[35], 2) == '1') then
        json.bf_stove_3 = 'on'
    else
        json.bf_stove_3 = 'off'
    end
    if (getBit(pkg[35], 3) == '1') then
        json.bf_stove_4 = 'on'
    else
        json.bf_stove_4 = 'off'
    end
    if (getBit(pkg[35], 4) == '1') then
        json.bf_stove_5 = 'on'
    else
        json.bf_stove_5 = 'off'
    end
    if (getBit(pkg[35], 5) == '1') then
        json.bf_hotwind = 'on'
    else
        json.bf_hotwind = 'off'
    end
    if (getBit(pkg[35], 6) == '1') then
        json.bf_wintersummertime = 'on'
    else
        json.bf_wintersummertime = 'off'
    end
    if (getBit(pkg[35], 7) == '1') then
        json.bf_upload_interval = 'on'
    else
        json.bf_upload_interval = 'off'
    end
    if (getBit(pkg[36], 0) == '1') then
        json.bf_hydrops_full = 'on'
    else
        json.bf_hydrops_full = 'off'
    end
    if (getBit(pkg[36], 1) == '1') then
        json.bf_radiating = 'on'
    else
        json.bf_radiating = 'off'
    end
    if (getBit(pkg[36], 2) == '1') then
        json.bf_turntable_reset = 'on'
    else
        json.bf_turntable_reset = 'off'
    end
    if (getBit(pkg[36], 3) == '1') then
        json.bf_overheat = 'on'
    else
        json.bf_overheat = 'off'
    end
    if (getBit(pkg[36], 4) == '1') then
        json.bf_overheat = 'normal'
    else
        json.bf_overheat = 'dehumidification'
    end
    if (getBit(pkg[36], 5) == '1') then
        json.bf_overheat = 'normal'
    else
        json.bf_overheat = 'dehumidification'
    end
    if (getBit(pkg[36], 6) == '1') then
        json.bf_repair_cook = 'on'
    else
        json.bf_repair_cook = 'off'
    end
    if (getBit(pkg[36], 7) == '1') then
        json.bf_scalehandling_remind = 'on'
    else
        json.bf_scalehandling_remind = 'off'
    end
    if (pkg[37] ~= 0xFF) then
        if (bit.band(pkg[37], 0x3F) == 0x01) then
            json.bf_tips_mark = "door_open"
        elseif (bit.band(pkg[37], 0x3F) == 0x02) then
            json.bf_tips_mark = "change_attachments"
        elseif (bit.band(pkg[37], 0x3F) == 0x02) then
            json.bf_tips_mark = "change_containers"
        elseif (bit.band(pkg[37], 0x3F) == 0x04) then
            json.bf_tips_mark = "apply"
        elseif (bit.band(pkg[37], 0x3F) == 0x05) then
            json.bf_tips_mark = "feed"
        elseif (bit.band(pkg[37], 0x3F) == 0x06) then
            json.bf_tips_mark = "stir"
        elseif (bit.band(pkg[37], 0x3F) == 0x07) then
            json.bf_tips_mark = "recipe_tips"
        end
        if (getBit(pkg[37], 6) == '1') then
            json.bf_time_synchronization = 'on'
        else
            json.bf_time_synchronization = 'off'
        end
        if (getBit(pkg[37], 7) == '1') then
            json.bf_on_smart = 'on'
        else
            json.bf_on_smart = 'off'
        end
    end
    local multi = 1
    if (pkg[38] ~= 0xFF) then
        if (getBit(pkg[38], 0) == '1') then
            json.bf_weight_multiple = "one_of_ten_thousand"
            multi = 0.0001
        elseif (getBit(pkg[38], 1) == '1') then
            json.bf_weight_multiple = "one_of_thousand"
            multi = 0.001
        elseif (getBit(pkg[38], 2) == '1') then
            json.bf_weight_multiple = "one_of_hundred"
            multi = 0.01
        elseif (getBit(pkg[38], 3) == '1') then
            json.bf_weight_multiple = "one_of_ten"
            multi = 0.1
        elseif (getBit(pkg[38], 4) == '1') then
            json.bf_weight_multiple = "ten"
            multi = 10
        elseif (getBit(pkg[38], 5) == '1') then
            json.bf_weight_multiple = "hundred"
            multi = 100
        end
    end
    if (pkg[20] ~= 0xFF or pkg[38] ~= 0xFF) then
        if (pkg[38] == 0x04) then
            json.bf_weight_mount = pkg[20]
        else
            json.bf_weight_mount = pkg[20] * 10 * multi
        end
    end
    if (pkg[39] ~= 0xFF) then
        if (pkg[39] == 0x00) then
            json.bf_weight_unit = "g"
        elseif (pkg[39] == 0x01) then
            json.bf_weight_unit = "kg"
        elseif (pkg[39] == 0x02) then
            json.bf_weight_unit = "ounce"
        elseif (pkg[39] == 0x03) then
            json.bf_weight_unit = "pound"
        elseif (pkg[39] == 0x04) then
            json.bf_weight_unit = "other"
        end
    end
    if (pkg[41] ~= 0xFF and pkg[42] ~= 0xFF) then
        json.bf_quick_btn_microwave_id = pkg[41] * 256 + pkg[42]
    end
    if (pkg[43] ~= 0xFF and pkg[44] ~= 0xFF and pkg[45] ~= 0xFF) then
        json.bf_quick_btn_microwave_time =
            pkg[43] * 256 * 256 + pkg[44] * 256 + pkg[45]
    end
    if (pkg[46] ~= 0xFF and pkg[47] ~= 0xFF) then
        json.bf_quick_btn_microwave_set = pkg[46] * 256 + pkg[47]
    end
    if (pkg[49] ~= 0xFF and pkg[50] ~= 0xFF) then
        json.bf_quick_btn_steam_id = pkg[49] * 256 + pkg[50]
    end
    if (pkg[51] ~= 0xFF and pkg[52] ~= 0xFF and pkg[53] ~= 0xFF) then
        json.bf_quick_btn_steam_time = pkg[51] * 256 * 256 + pkg[52] * 256 +
                                           pkg[53]
    end
    if (pkg[54] ~= 0xFF and pkg[55] ~= 0xFF) then
        json.bf_quick_btn_steam_set = pkg[54] * 256 + pkg[55]
    end
    if (pkg[57] ~= 0xFF and pkg[58] ~= 0xFF) then
        json.bf_quick_btn_bake_id = pkg[57] * 256 + pkg[58]
    end
    if (pkg[59] ~= 0xFF and pkg[60] ~= 0xFF and pkg[61] ~= 0xFF) then
        json.bf_quick_btn_bake_time = pkg[59] * 256 * 256 + pkg[60] * 256 +
                                          pkg[61]
    end
    if (pkg[62] ~= 0xFF and pkg[63] ~= 0xFF) then
        json.bf_quick_btn_bake_set = pkg[62] * 256 + pkg[63]
    end
    return json
end
local function queryAllCmdToJson(json, cmd)
    local position = 12
    while (cmd[position + 1] ~= nil) do
        if (cmd[position] == 0xF0 and cmd[position + 2] ~= nil) then
            json = getTotalJson(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x01 and cmd[position + 2] ~= nil) then
            json = getB6Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x02 and cmd[position + 2] ~= nil) then
            json = getB7Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x03 and cmd[position + 2] ~= nil) then
            json = getB3Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x04 and cmd[position + 2] ~= nil) then
            json = getB2Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x05 and cmd[position + 2] ~= nil) then
            json = getE7Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x06 and cmd[position + 2] ~= nil) then
            json = getSpJson(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x08 and cmd[position + 2] ~= nil) then
            json = getACJson(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x09 and cmd[position + 2] ~= nil) then
            json = getBFJson(json, getPackage(position, cmd))
        end
        position = position + cmd[position + 1] + 2
    end
    return json
end
local function queryErrorCmdToJson(json, cmd)
    json.error_list = {}
    local i = 1
    while (cmd[12] ~= 0xFF and i <= cmd[12]) do
        json.error_list[i] = cmd[12 + i]
        i = i + 1
    end
    return json
end
local function cmdToJson(json, cmd)
    json["version"] = VALUE_VERSION
    if (cmd[10] == 0x02) then
        if (cmd[11] == 0x01) then
            if (cmd[12] == 0xf0) then
                if (cmd[14] == 0x01) then
                    json.total_power = 'off'
                elseif (cmd[14] == 0x02) then
                    json.total_power = 'on'
                end
                if (getBit(cmd[15], 0) == "0") then
                    json.total_lock = VALUE_OFF
                elseif (getBit(cmd[15], 0) == "1") then
                    json.total_lock = VALUE_ON
                end
                if (getBit(cmd[17], 0) == "0") then
                    json.total_ir = VALUE_OFF
                elseif (getBit(cmd[17], 0) == "1") then
                    json.total_ir = VALUE_ON
                end
                if (getBit(cmd[17], 1) == "0") then
                    json.total_speak = VALUE_OFF
                elseif (getBit(cmd[17], 1) == "1") then
                    json.total_speak = VALUE_ON
                end
                if (getBit(cmd[17], 2) == "0") then
                    json.total_gesture = VALUE_OFF
                elseif (getBit(cmd[17], 2) == "1") then
                    json.total_gesture = VALUE_ON
                end
            elseif (cmd[12] == 0x01) then
                if (cmd[14] == 0x01) then
                    json.b6_power = VALUE_OFF
                    json.b6_work_status = "power_off"
                elseif (cmd[14] == 0x02) then
                    json.b6_power = VALUE_ON
                    json.b6_work_status = "working"
                elseif (cmd[14] == 0x03) then
                    json.b6_power = 'delay_off'
                    json.b6_work_status = "power_off_delay"
                elseif (cmd[14] == 0x04) then
                    json.b6_steaming = VALUE_ON
                    json.b6_work_status = "hotclean"
                elseif (cmd[14] == 0x08) then
                    json.b6_power = VALUE_ON
                    json.b6_work_status = "vvvf_gear"
                elseif (cmd[14] == 0x09) then
                    json.b6_power = VALUE_ON
                    json.b6_work_status = "mute_gear"
                elseif (cmd[14] == 0x0a) then
                    json.b6_power = VALUE_ON
                    json.b6_work_status = "ai_dry_clean"
                elseif (cmd[14] == 0x0d) then
                    json.b6_power = VALUE_ON
                    json.b6_work_status = "air_duct_detection"
                end
                if (cmd[15] ~= 0xFF) then json.b6_gear = cmd[15] end
                if (cmd[18] == 0x00) then
                    json.b6_light = 'off'
                else
                    json.b6_light = 'on'
                    json.b6_lightness = cmd[18]
                end
                if (cmd[19] == 0x00) then
                    json.b6_fan_drying = 'off'
                elseif (cmd[19] == 0x01) then
                    json.b6_fan_drying = 'on'
                end
                if (cmd[20] == 0x00) then
                    json.b6_heating_disk = 'off'
                elseif (cmd[20] == 0x01) then
                    json.b6_heating_disk = 'on'
                end
            elseif (cmd[12] == 0x02) then
                local prefix = 'b7_left_'
                if (cmd[13] == 2) then prefix = 'b7_right_' end
                if (cmd[14] == 0x01) then
                    json[prefix .. 'status'] = "power_off"
                elseif (cmd[14] == 0x02) then
                    json[prefix .. 'status'] = "working"
                elseif (cmd[14] == 0x03) then
                    json[prefix .. 'status'] = "power_off_delay"
                elseif (cmd[14] == 0x04) then
                    json[prefix .. 'status'] = "ai"
                end
                if (cmd[15] ~= 0xff) then
                    json[prefix .. 'gear'] = cmd[15]
                end
                if (cmd[16] ~= 0xff and cmd[17] ~= 0xff) then
                    json[prefix .. 'destination_time'] = cmd[16] + cmd[17] * 256
                    json[prefix .. 'remaining_time'] = json[prefix ..
                                                           'destination_time']
                    if (json[prefix .. 'remaining_time'] > 0) then
                        json[prefix .. 'status'] = "power_off_delay"
                    end
                end
                if (cmd[18] ~= 0xff and cmd[19] ~= 0xff) then
                    json[prefix .. 'destination_temp'] = cmd[18] + cmd[19] * 256
                end
            elseif (cmd[12] == 0x03) then
                local prefix = 'b3_upstair_'
                if (cmd[13] == 2) then prefix = 'b3_downstair_' end
                if (cmd[14] == 0x01) then
                    json[prefix .. 'status'] = "power_off"
                elseif (cmd[14] == 0x02) then
                    json[prefix .. 'status'] = "uperization"
                elseif (cmd[14] == 0x04) then
                    json[prefix .. 'status'] = "drying"
                elseif (cmd[14] == 0x06) then
                    json[prefix .. 'status'] = "ion_drying"
                elseif (cmd[14] == 0x08) then
                    json[prefix .. 'status'] = "warm_drink"
                end
            elseif (cmd[12] == 0x04) then
                local prefix = 'b2_upstair_'
                if (cmd[13] == 2) then prefix = 'b2_downstair_' end
                if (cmd[14] == 0x01) then
                    json[prefix .. 'work_status'] = "power_off"
                elseif (cmd[14] == 0x02) then
                    json[prefix .. 'work_status'] = "working"
                elseif (cmd[14] == 0x04) then
                    json[prefix .. 'work_status'] = "order"
                end
                if (cmd[15] ~= 0xff) then
                    json[prefix .. 'work_func'] = cmd[15]
                end
                if (cmd[16] ~= 0xff) then
                    json[prefix .. 'work_menu'] = cmd[16]
                end
                if (cmd[17] ~= 0xff) then
                    json[prefix .. 'work_destination_time'] =
                        cmd[17] + cmd[18] * 256
                    json[prefix .. 'work_remaining_time'] = json[prefix ..
                                                                'work_destination_time']
                end
                if (cmd[19] ~= 0xff) then
                    json[prefix .. 'destination_temp'] = cmd[19] + cmd[20] * 256
                end
                if (cmd[21] ~= 0xff) then
                    json[prefix .. 'order_destination_time'] =
                        cmd[21] + cmd[22] * 256
                    json[prefix .. 'order_remaining_time'] = json[prefix ..
                                                                 'order_destination_time']
                end
            elseif (cmd[12] == 0x05) then
                if (cmd[14] == 0x00 or cmd[14] == 0x01) then
                    json.e7_work_status = "power_off"
                elseif (cmd[14] == 0x02) then
                    json.e7_work_status = "working"
                elseif (cmd[14] == 0x03) then
                    json.e7_work_status = "order"
                end
                if (cmd[15] == 0x00) then
                    json.e7_mode = "none"
                elseif (cmd[15] == 0x01) then
                    json.e7_mode = "heat_preservation"
                elseif (cmd[15] == 0x02) then
                    json.e7_mode = "stew_soup"
                elseif (cmd[15] == 0x03) then
                    json.e7_mode = "boiling"
                elseif (cmd[15] == 0x04) then
                    json.e7_mode = "stir_frying"
                end
                if (cmd[16] ~= 0xff) then json.e7_gear = cmd[16] end
                if (cmd[17] ~= 0xff or cmd[18] ~= 0xff) then
                    json.e7_destination_time = cmd[17] + cmd[18] * 256
                    json.e7_remaining_time = json.e7_destination_time
                end
            elseif (cmd[12] == 0x08) then
                if (cmd[14] == 0x01) then
                    json.ac_work_status = "power_off"
                elseif (cmd[14] == 0x02) then
                    json.ac_work_status = "working"
                elseif (cmd[14] == 0x03) then
                    json.ac_work_status = "order"
                elseif (cmd[14] == 0x04) then
                    json.ac_work_status = "reservation"
                elseif (cmd[14] == 0x05) then
                    json.ac_work_status = "reservation_and_order"
                elseif (cmd[14] == 0x08) then
                    json.ac_work_status = "setting"
                end
                if (cmd[15] == 0x00) then
                    json.ac_mode = "none"
                elseif (cmd[15] == 0x01) then
                    json.ac_mode = "refrigeration"
                elseif (cmd[15] == 0x02) then
                    json.ac_mode = "air_supply"
                elseif (cmd[15] == 0x03) then
                    json.ac_mode = "dehumidification"
                elseif (cmd[15] == 0x04) then
                    json.ac_mode = "net_flavour"
                end
                if (cmd[16] ~= 0xff) then json.ac_gear = cmd[16] end
                if (cmd[17] ~= 0xff or cmd[18] ~= 0xff) then
                    json.ac_destination_time = cmd[17] + cmd[18] * 256
                    json.ac_remaining_time = json.ac_destination_time
                end
                if (cmd[19] ~= 0xff or cmd[20] ~= 0xff) then
                    json.ac_destination_temp = cmd[19] + cmd[20] * 256
                    json.ac_remaining_temp = json.ac_destination_temp
                end
                if (cmd[21] ~= 0xff or cmd[22] ~= 0xff) then
                    json.ac_order_destination_time = cmd[21] + cmd[22] * 256
                    json.ac_order_remaining_time =
                        json.ac_order_destination_time
                end
                if (cmd[23] ~= 0xff) then json.ac_swing = cmd[23] end
                if (cmd[24] ~= 0xff) then
                    json.ac_air_direction = cmd[24]
                end
                if (cmd[25] ~= 0xff) then
                    json.ac_swing_gear = cmd[25]
                end
                if (cmd[26] ~= 0xff) then
                    json.ac_swing_min_angle = cmd[26]
                end
                if (cmd[27] ~= 0xff) then
                    json.ac_swing_max_anangle = cmd[27]
                end
                if (cmd[28] ~= 0xff) then
                    json.ac_air_direction_gear = cmd[28]
                end
                if (cmd[29] ~= 0xff) then
                    json.ac_air_direction_min_angle = cmd[29]
                end
                if (cmd[30] ~= 0xff) then
                    json.ac_air_direction_max_anangle = cmd[30]
                end
            elseif (cmd[12] == 0x09) then
                if (cmd[13] ~= 0x00) then
                    json.bf_stair = 'up'
                elseif (cmd[13] ~= 0x01) then
                    json.bf_stair = 'down'
                end
                if (cmd[15] ~= 0x01) then
                    json.bf_work_status = 'power_off'
                elseif (cmd[15] ~= 0x02) then
                    json.bf_work_status = 'cancel'
                elseif (cmd[15] ~= 0x03) then
                    json.bf_work_status = 'continue'
                elseif (cmd[15] ~= 0x06) then
                    json.bf_work_status = 'pause'
                elseif (cmd[15] ~= 0x11) then
                    json.bf_work_status = 'working'
                end
                if (cmd[16] ~= 0xFF and cmd[17] ~= 0xFF and cmd[16] ~= 0xFF) then
                    json.bf_recipe_code =
                        cmd[16] * 256 * 256 + cmd[17] * 256 + cmd[18]
                end
                if (cmd[19] ~= 0xFF) then
                    if (getBit(cmd[19], 0) == '1') then
                        json.bf_weight_multiple = 'one_of_ten_thousand'
                    elseif (getBit(cmd[19], 1) == '1') then
                        json.bf_weight_multiple = 'one_of_thousand'
                    elseif (getBit(cmd[19], 2) == '1') then
                        json.bf_weight_multiple = 'one_of_hundred'
                    elseif (getBit(cmd[19], 3) == '1') then
                        json.bf_weight_multiple = 'one_of_ten'
                    elseif (getBit(cmd[19], 4) == '1') then
                        json.bf_weight_multiple = 'ten'
                    elseif (getBit(cmd[19], 5) == '1') then
                        json.bf_weight_multiple = 'hundred'
                    end
                end
                if (cmd[20] ~= 0xFF) then
                    if (cmd[20] ~= 0x00) then
                        json.bf_weight_unit = 'g'
                    elseif (cmd[20] ~= 0x01) then
                        json.bf_weight_unit = 'kg'
                    elseif (cmd[20] ~= 0x02) then
                        json.bf_weight_unit = 'ounce'
                    elseif (cmd[20] ~= 0x03) then
                        json.bf_weight_unit = 'pound'
                    elseif (cmd[20] ~= 0x04) then
                        json.bf_weight_unit = 'other'
                    end
                end
                if (cmd[21] ~= 0xFF) then
                    if (cmd[21] ~= 0x01) then
                        json.bf_lock = 'on'
                    else
                        json.bf_lock = 'off'
                    end
                end
                if (cmd[22] ~= 0xFF) then
                    if (cmd[22] ~= 0x01) then
                        json.bf_light = 'on'
                    else
                        json.bf_light = 'off'
                    end
                end
                if (cmd[23] ~= 0xFF) then
                    if (cmd[23] ~= 0x01) then
                        json.bf_door = 'on'
                    else
                        json.bf_door = 'off'
                    end
                end
                if (cmd[24] ~= 0xFF) then
                    if (cmd[24] ~= 0x01) then
                        json.bf_hotwind = 'on'
                    else
                        json.bf_hotwind = 'off'
                    end
                end
            end
        end
    elseif (cmd[10] == 0x03) then
        if (cmd[11] == 0x01) then
            json = queryAllCmdToJson(json, cmd)
        elseif (cmd[11] == 0x02) then
            json = queryErrorCmdToJson(json, cmd)
        end
    elseif (cmd[10] == 0x04) then
        if (cmd[11] == 0x01) then
            json = queryAllCmdToJson(json, cmd)
        elseif (cmd[11] == 0x02) then
            json = queryErrorCmdToJson(json, cmd)
        end
    end
    return json
end
local function makeSum(tmpbuf, start_pos, end_pos)
    local resVal = 0
    for si = start_pos, end_pos do resVal = resVal + tmpbuf[si] end
    resVal = bit.bnot(resVal) + 1
    resVal = bit.band(resVal, 0x00ff)
    return resVal
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
local function table2string(cmd)
    local ret = ""
    local i
    for i = 1, #cmd do ret = ret .. string.char(cmd[i]) end
    return ret
end
function jsonToData(jsonCmdStr)
    if (#jsonCmdStr == 0) then return nil end
    local result
    if JSON == nil then JSON = require "cjson" end
    result = JSON.decode(jsonCmdStr)
    if result == nil then return end
    local msgBytes = {0xAA, 0x00, 0x9C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
    msgBytes = jsonToCmd(result, msgBytes)
    local len = #msgBytes
    msgBytes[2] = len
    msgBytes[len + 1] = makeSum(msgBytes, 2, len)
    local ret = table2string(msgBytes)
    ret = string2hexstring(ret)
    return ret
end
function dataToJson(jsonStr)
    if (not jsonStr) then return nil end
    local result
    if JSON == nil then JSON = require "cjson" end
    result = JSON.decode(jsonStr)
    if result == nil then return end
    local binData = result["msg"]["data"]
    local ret = {}
    ret["status"] = {}
    local bodyBytes = string2table(binData)
    ret["status"] = cmdToJson(ret["status"], bodyBytes)
    local ret = JSON.encode(ret)
    return ret
end
