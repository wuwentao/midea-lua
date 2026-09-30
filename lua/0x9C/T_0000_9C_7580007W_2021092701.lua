local bit = require "bit"
local VALUE_VERSION = 39
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
                cmd[19] = 0x02
                cmd[20] = 0x01
                if (ctrl.b6_smoke_detector_value == 'integrated_cooking') then
                    cmd[21] = 0x01
                elseif (ctrl.b6_smoke_detector_value == 'heavy_oilsmoke_cooking') then
                    cmd[21] = 0x02
                elseif (ctrl.b6_smoke_detector_value == 'light_oilsmoke_cooking') then
                    cmd[21] = 0x03
                elseif (ctrl.b6_smoke_detector_value == 'off') then
                    cmd[20] = 0x00
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
    if (getBit(pkg[2], 0) == "0") then
        json.total_lock = VALUE_OFF
    elseif (getBit(pkg[2], 0) == "1") then
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
        if (bit.band(pkg[16], 0x79) == 0x01) then
            json.b6_smoke_detector_value = 'integrated_cooking'
        end
        if (bit.band(pkg[16], 0x79) == 0x02) then
            json.b6_smoke_detector_value = 'heavy_oilsmoke_cooking'
        end
        if (bit.band(pkg[16], 0x79) == 0x03) then
            json.b6_smoke_detector_value = 'light_oilsmoke_cooking'
        end
        if (getBit(pkg[16], 7) == "0") then
            json.b6_smoke_detector_status = VALUE_OFF
        elseif (getBit(pkg[16], 7) == "1") then
            json.b6_smoke_detector_status = VALUE_ON
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
    return json
end
local function getE7Json(json, pkg)
    if (pkg[2] == 0x00 or pkg[2] == 0x01) then
        json.e7_work_status = "power_off"
    elseif (pkg[2] == 0x02) then
        json.e7_work_status = "working"
    elseif (pkg[2] == 0x03) then
        json.e7_work_status = "order"
    end
    if (pkg[3] == 0x00) then
        json.e7_mode = "none"
    elseif (pkg[3] == 0x01) then
        json.e7_mode = "heat_preservation"
    elseif (pkg[3] == 0x02) then
        json.e7_mode = "stew_soup"
    elseif (pkg[3] == 0x03) then
        json.e7_mode = "boiling"
    elseif (pkg[3] == 0x04) then
        json.e7_mode = "stir_frying"
    end
    if (pkg[4] ~= 0xff) then json.e7_gear = pkg[4] end
    if (pkg[5] ~= 0xff or pkg[6] ~= 0xff) then
        json.e7_efficiency = pkg[5] + pkg[6] * 256
    end
    if (pkg[7] ~= 0xff or pkg[8] ~= 0xff) then
        json.e7_work_time = pkg[7] + pkg[8] * 256
    end
    if (pkg[9] ~= 0xff or pkg[10] ~= 0xff) then
        json.e7_destination_time = pkg[9] + pkg[10] * 256
    end
    if (pkg[11] ~= 0xff or pkg[12] ~= 0xff) then
        json.e7_remaining_time = pkg[11] + pkg[12] * 256
    end
    if (pkg[13] ~= nil and pkg[13] ~= 0xff) then
        json.e7_has_pot = getBit(pkg[13], 0)
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
local function queryAllCmdToJson(json, cmd)
    local position = 12
    while (cmd[position + 1] ~= nil) do
        if (cmd[position] == 0xF0) then
            json = getTotalJson(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x01) then
            json = getB6Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x02) then
            json = getB7Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x03) then
            json = getB3Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x04) then
            json = getB2Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x05) then
            json = getE7Json(json, getPackage(position, cmd))
        elseif (cmd[position] == 0x06) then
            json = getSpJson(json, getPackage(position, cmd))
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
