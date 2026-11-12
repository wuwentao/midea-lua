local bit = require("bit")
local VALUE_VERSION = 4
local BYTE_DEVICE_TYPE = 0x9B
local JSON = require("cjson")
local BYTE_PROTOCOL_HEAD = 0xAA
local BYTE_PROTOCOL_LENGTH = 0x0A
local BYTE_CONTROL_REQUEST = 0x02
local BYTE_QUERY_REQUEST = 0x03
local function makeSum(tmpbuf, msgLenByteNumber)
	local resVal = 0
	for si = 1, (msgLenByteNumber - 1) do
		resVal = resVal + tmpbuf[si]
	end
	resVal = bit.bnot(resVal)
	resVal = bit.band(resVal, 0x000000FF)
	resVal = resVal + 1
	resVal = math.fmod(resVal, 256)
	return resVal
end
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
	msgBytes[0] = BYTE_PROTOCOL_HEAD
	msgBytes[1] = msgLength - 1
	msgBytes[2] = BYTE_DEVICE_TYPE
	msgBytes[9] = type
	for i = 0, bodyLength - 1 do
		msgBytes[i + BYTE_PROTOCOL_LENGTH] = bodyBytes[i]
	end
	msgBytes[msgLength - 1] = makeSum(msgBytes, msgLength - 1)
	return msgBytes
end
local function decodeJsonToTable(jsonStr)
	return JSON.decode(jsonStr)
end
local function encodeTableToJson(luaTable)
	return JSON.encode(luaTable)
end
local function hexToTable(hex)
	local tb = {}
	local i = 1
	local j = 0
	for i = 1, #hex - 1, 2 do
		local doublebytestr = string.sub(hex, i, i + 1)
		tb[j] = doublebytestr
		j = j + 1
	end
	return tb
end
local function tableToString(tb)
	local ret = ""
	local i
	for i = 1, #tb do
		ret = ret .. string.char(tb[i])
	end
	return ret
end
local function stringToHex(str)
	local ret = ""
	for i = 1, #str do
		ret = ret .. string.format("%02x", str:byte(i))
	end
	return ret
end
local function getByteBit(bytes, bitIndex)
	local bytes_high = tonumber(string.sub(bytes, 1, 1), 16)
	local bytes_low = tonumber(string.sub(bytes, 2, 2), 16)
	if bitIndex > 3 and bitIndex < 8 then
		if bitIndex == 7 then
			if bit.band(bytes_high, 8) == 8 then
				return "1"
			end
		elseif bitIndex == 6 then
			if bit.band(bytes_high, 4) == 4 then
				return "1"
			end
		elseif bitIndex == 5 then
			if bit.band(bytes_high, 2) == 2 then
				return "1"
			end
		elseif bitIndex == 4 then
			if bit.band(bytes_high, 1) == 1 then
				return "1"
			end
		end
		return "0"
	elseif bitIndex >= 0 and bitIndex <= 3 then
		if bitIndex == 3 then
			if bit.band(bytes_low, 8) == 8 then
				return "1"
			end
		elseif bitIndex == 2 then
			if bit.band(bytes_low, 4) == 4 then
				return "1"
			end
		elseif bitIndex == 1 then
			if bit.band(bytes_low, 2) == 2 then
				return "1"
			end
		elseif bitIndex == 0 then
			if bit.band(bytes_low, 1) == 1 then
				return "1"
			end
		end
		return "0"
	end
	return "2"
end
local function workMode16(mode)
	local modeTable = {
		["microwave"] = "0100",
		["microwave_1"] = "0101",
		["microwave_2"] = "0102",
		["microwave_3"] = "0103",
		["microwave_4"] = "0104",
		["microwave_5"] = "0105",
		["microwave_steam_above_tube"] = "0200",
		["microwave_double_tube"] = "0300",
		["microwave_hot_wind_tube_fan"] = "0400",
		["microwave_hot_wind_tube_fan_1"] = "0401",
		["microwave_hot_wind_tube_fan_2"] = "0402",
		["microwave_underside_tube_hot_wind_tube_fan"] = "0500",
		["microwave_underside_tube_hot_wind_tube_fan_1"] = "0501",
		["microwave_double_tube_hot_wind_tube_fan"] = "0600",
		["microwave_steam"] = "0700",
		["microwave_steam_1"] = "0701",
		["microwave_steam_2"] = "0702",
		["microwave_above_inside_outside_tube_fan"] = "0800",
		["microwave_above_inside_outside_tube_fan_1"] = "0801",
		["unfreeze"] = "0900",
		["unfreeze_1"] = "0901",
		["unfreeze_2"] = "0902",
		["unfreeze_3"] = "0903",
		["unfreeze_4"] = "0904",
		["unfreeze_5"] = "0905",
		["unfreeze_6"] = "0906",
		["unfreeze_t"] = "0A00",
		["unfreeze_t_1"] = "0A01",
		["microwave_above_tube"] = "0B00",
		["microwave_above_tube_1"] = "0B01",
		["microwave_above_tube_2"] = "0B02",
		["microwave_above_tube_fan"] = "0C00",
		["fast_unfreeze"] = "0D00",
		["fresh_unfreeze"] = "0E00",
		["microwave_zymosis"] = "0F00",
		["pure_steam"] = "2900",
		["pure_steam_1"] = "2901",
		["pure_steam_2"] = "2902",
		["pure_steam_3"] = "2903",
		["pure_steam_4"] = "2904",
		["pure_steam_5"] = "2905",
		["pure_steam_6"] = "2906",
		["pure_steam_7"] = "2907",
		["pure_steam_8"] = "2908",
		["pure_steam_9"] = "2909",
		["pure_steam_10"] = "290A",
		["steam_above_tube"] = "2B00",
		["steam_underside_tube"] = "2C00",
		["steam_double_tube"] = "2D00",
		["steam_double_tube_1"] = "2D01",
		["steam_hot_wind_tube_fan"] = "2E00",
		["steam_hot_wind_tube_fan_1"] = "2E01",
		["steam_hot_wind_tube_fan_2"] = "2E02",
		["steam_hot_wind_tube_fan_3"] = "2E03",
		["steam_hot_wind_tube"] = "2F00",
		["steam_hot_wind_tube_1"] = "2F01",
		["steam_double_tube_fan"] = "3000",
		["steam_above_inside_outside_tube_fan"] = "3100",
		["steam_above_inside_tube_fan"] = "3200",
		["steam_above_inside_outside_tube"] = "3300",
		["above_tube"] = "5100",
		["underside_tube"] = "5200",
		["double_tube"] = "5300",
		["hot_wind_tube_fan"] = "5400",
		["pure_preheat"] = "5500",
		["pure_preheat_1"] = "5501",
		["pure_preheat_2"] = "5502",
		["above_tube_hot_wind_tube_fan"] = "5600",
		["underside_tube_hot_wind_tube_fan"] = "5700",
		["zymosis"] = "5800",
		["zymosis_1"] = "5801",
		["double_tube_hot_wind_tube_fan"] = "5900",
		["above_tube_revolve"] = "5A00",
		["underside_tube_revolve"] = "5B00",
		["double_tube_revolve"] = "5C00",
		["hot_wind_tube_fan_revolve"] = "5D00",
		["warm"] = "5E00",
		["warm_1"] = "5E01",
		["double_tube_fan"] = "5F00",
		["double_tube_fan_1"] = "5F01",
		["double_tube_fan_2"] = "5F02",
		["double_tube_fan_3"] = "5F03",
		["above_inside_tube_revolve"] = "6000",
		["above_inside_tube_fan"] = "6100",
		["above_inside_outside_tube_revolve"] = "6200",
		["above_inside_outside_tube_fan"] = "6300",
		["above_inside_underside_tube"] = "6400",
		["above_inside_underside_tube_1"] = "6401",
		["above_inside_underside_tube_fan"] = "6500",
		["above_inside_underside_tube_fan_1"] = "6501",
		["above_inside_tube"] = "6600",
		["above_inside_outside_tube"] = "6700",
		["underside_tube_fan"] = "6800",
		["above_tube_fan"] = "6900",
		["above_tube_fan_1"] = "6901",
		["above_tube_fan_2"] = "6902",
		["multiple_layer_roast"] = "6A01",
		["scale_clean"] = "7900",
		["scale_clean_1"] = "7901",
		["clean"] = "7A00",
		["clean_1"] = "7A01",
		["remove_odor"] = "7B00",
		["remove_odor_2"] = "7B02",
		["high_temperature_clean"] = "7C00",
		["dining_utensils_clean"] = "7D00",
		["auto_menu"] = "A100",
		["eco"] = "A200",
		["eco_3"] = "A203",
		["fan_unfreeze"] = "A400",
		["pastry_steam"] = "A501",
		["air_blast_humidity_control"] = "A503",
		["humidity_control_roast"] = "A504",
		["dry"] = "C400",
		["dry1"] = "C401",
		["above_tube_1"] = "5101",
		["above_tube_2"] = "5102",
		["above_tube_3"] = "5103",
		["underside_tube_1"] = "5201",
		["underside_tube_2"] = "5202",
		["double_tube_1"] = "5301",
		["double_tube_2"] = "5302",
		["double_tube_3"] = "5303",
		["double_tube_4"] = "5304",
		["double_tube_5"] = "5305",
		["double_tube_6"] = "5306",
		["double_tube_7"] = "5307",
		["double_tube_8"] = "5308",
		["hot_wind_tube_fan_1"] = "5401",
		["hot_wind_tube_fan_2"] = "5402",
		["hot_wind_tube_fan_3"] = "5403",
		["hot_wind_tube_fan_4"] = "5404",
		["hot_wind_tube_fan_5"] = "5405",
		["hot_wind_tube_fan_6"] = "5406",
		["hot_wind_tube_fan_7"] = "5407",
		["hot_wind_tube_fan_10"] = "540A",
		["double_tube_hot_wind_tube_fan_1"] = "5901",
		["double_tube_hot_wind_tube_fan_2"] = "5902",
		["double_tube_hot_wind_tube_fan_3"] = "5903",
		["double_tube_hot_wind_tube_fan_4"] = "5904",
		["double_tube_hot_wind_tube_fan_5"] = "5905",
		["double_tube_hot_wind_tube_fan_6"] = "5906",
	}
	local value = modeTable[mode]
	if value ~= nil then
		return value
	else
		return mode
	end
end
local function workMode(hex, subHex)
	local modeTable = {
		["0100"] = "microwave",
		["0101"] = "microwave_1",
		["0102"] = "microwave_2",
		["0103"] = "microwave_3",
		["0104"] = "microwave_4",
		["0105"] = "microwave_5",
		["0200"] = "microwave_steam_above_tube",
		["0300"] = "microwave_double_tube",
		["0400"] = "microwave_hot_wind_tube_fan",
		["0401"] = "microwave_hot_wind_tube_fan_1",
		["0402"] = "microwave_hot_wind_tube_fan_2",
		["0500"] = "microwave_underside_tube_hot_wind_tube_fan",
		["0501"] = "microwave_underside_tube_hot_wind_tube_fan_1",
		["0600"] = "microwave_double_tube_hot_wind_tube_fan",
		["0700"] = "microwave_steam",
		["0701"] = "microwave_steam_1",
		["0702"] = "microwave_steam_2",
		["0800"] = "microwave_above_inside_outside_tube_fan",
		["0801"] = "microwave_above_inside_outside_tube_fan_1",
		["0900"] = "unfreeze",
		["0901"] = "unfreeze_1",
		["0902"] = "unfreeze_2",
		["0903"] = "unfreeze_3",
		["0904"] = "unfreeze_4",
		["0905"] = "unfreeze_5",
		["0906"] = "unfreeze_6",
		["0A00"] = "unfreeze_t",
		["0A01"] = "unfreeze_t_1",
		["0B00"] = "microwave_above_tube",
		["0B01"] = "microwave_above_tube_1",
		["0B02"] = "microwave_above_tube_2",
		["0C00"] = "microwave_above_tube_fan",
		["0D00"] = "fast_unfreeze",
		["0E00"] = "fresh_unfreeze",
		["0F00"] = "microwave_zymosis",
		["2900"] = "pure_steam",
		["2901"] = "pure_steam_1",
		["2902"] = "pure_steam_2",
		["2903"] = "pure_steam_3",
		["2904"] = "pure_steam_4",
		["2905"] = "pure_steam_5",
		["2906"] = "pure_steam_6",
		["2907"] = "pure_steam_7",
		["2908"] = "pure_steam_8",
		["2909"] = "pure_steam_9",
		["290A"] = "pure_steam_10",
		["2B00"] = "steam_above_tube",
		["2C00"] = "steam_underside_tube",
		["2D00"] = "steam_double_tube",
		["2E00"] = "steam_hot_wind_tube_fan",
		["2E01"] = "steam_hot_wind_tube_fan_1",
		["2E02"] = "steam_hot_wind_tube_fan_2",
		["2E03"] = "steam_hot_wind_tube_fan_3",
		["2F00"] = "steam_hot_wind_tube",
		["2F01"] = "steam_hot_wind_tube_1",
		["3000"] = "steam_double_tube_fan",
		["3100"] = "steam_above_inside_outside_tube_fan",
		["3200"] = "steam_above_inside_tube_fan",
		["3300"] = "steam_above_inside_outside_tube",
		["5100"] = "above_tube",
		["5200"] = "underside_tube",
		["5300"] = "double_tube",
		["5400"] = "hot_wind_tube_fan",
		["5500"] = "pure_preheat",
		["5501"] = "pure_preheat_1",
		["5502"] = "pure_preheat_2",
		["5600"] = "above_tube_hot_wind_tube_fan",
		["5700"] = "underside_tube_hot_wind_tube_fan",
		["5800"] = "zymosis",
		["5801"] = "zymosis_1",
		["5900"] = "double_tube_hot_wind_tube_fan",
		["5A00"] = "above_tube_revolve",
		["5B00"] = "underside_tube_revolve",
		["5C00"] = "double_tube_revolve",
		["5D00"] = "hot_wind_tube_fan_revolve",
		["5E00"] = "warm",
		["5E01"] = "warm_1",
		["5F00"] = "double_tube_fan",
		["5F01"] = "double_tube_fan_1",
		["5F02"] = "double_tube_fan_2",
		["5F03"] = "double_tube_fan_3",
		["6000"] = "above_inside_tube_revolve",
		["6100"] = "above_inside_tube_fan",
		["6200"] = "above_inside_outside_tube_revolve",
		["6300"] = "above_inside_outside_tube_fan",
		["6400"] = "above_inside_underside_tube",
		["6401"] = "above_inside_underside_tube_1",
		["6500"] = "above_inside_underside_tube_fan",
		["6501"] = "above_inside_underside_tube_fan_1",
		["6600"] = "above_inside_tube",
		["6700"] = "above_inside_outside_tube",
		["6800"] = "underside_tube_fan",
		["6900"] = "above_tube_fan",
		["6901"] = "above_tube_fan_1",
		["6902"] = "above_tube_fan_2",
		["6A01"] = "multiple_layer_roast",
		["7900"] = "scale_clean",
		["7901"] = "scale_clean_1",
		["7A00"] = "clean",
		["7A01"] = "clean_1",
		["7B00"] = "remove_odor",
		["7B02"] = "remove_odor_2",
		["7C00"] = "high_temperature_clean",
		["7D00"] = "dining_utensils_clean",
		["A100"] = "auto_menu",
		["A200"] = "eco",
		["A203"] = "eco_3",
		["A400"] = "fan_unfreeze",
		["A501"] = "pastry_steam",
		["A503"] = "air_blast_humidity_control",
		["A504"] = "humidity_control_roast",
		["C400"] = "dry",
		["C401"] = "dry1",
		["5101"] = "above_tube_1",
		["5102"] = "above_tube_2",
		["5103"] = "above_tube_3",
		["5201"] = "underside_tube_1",
		["5202"] = "underside_tube_2",
		["5301"] = "double_tube_1",
		["5302"] = "double_tube_2",
		["5303"] = "double_tube_3",
		["5304"] = "double_tube_4",
		["5305"] = "double_tube_5",
		["5306"] = "double_tube_6",
		["5307"] = "double_tube_7",
		["5308"] = "double_tube_8",
		["5401"] = "hot_wind_tube_fan_1",
		["5402"] = "hot_wind_tube_fan_2",
		["5403"] = "hot_wind_tube_fan_3",
		["5404"] = "hot_wind_tube_fan_4",
		["5405"] = "hot_wind_tube_fan_5",
		["5406"] = "hot_wind_tube_fan_6",
		["5407"] = "hot_wind_tube_fan_7",
		["540A"] = "hot_wind_tube_fan_10",
		["5901"] = "double_tube_hot_wind_tube_fan_1",
		["5902"] = "double_tube_hot_wind_tube_fan_2",
		["5903"] = "double_tube_hot_wind_tube_fan_3",
		["5904"] = "double_tube_hot_wind_tube_fan_4",
		["5905"] = "double_tube_hot_wind_tube_fan_5",
		["5906"] = "double_tube_hot_wind_tube_fan_6",
	}
	local value = modeTable[string.upper(hex) .. string.upper(subHex)]
	if value ~= nil then
		return value
	else
		return "ff"
	end
end
local function firePower16(firePower)
	local firePowerTable = {
		["high_power"] = 0x0A,
		["medium_high_power"] = 0x08,
		["medium_power"] = 0x05,
		["medium_low_power"] = 0x03,
		["low_power"] = 0x01,
		["fire_power_0"] = 0x00,
		["fire_power_1"] = 0x01,
		["fire_power_2"] = 0x02,
		["fire_power_3"] = 0x03,
		["fire_power_4"] = 0x04,
		["fire_power_5"] = 0x05,
		["fire_power_6"] = 0x06,
		["fire_power_7"] = 0x07,
		["fire_power_8"] = 0x08,
		["fire_power_9"] = 0x09,
		["fire_power_10"] = 0x0A,
	}
	if firePowerTable[firePower] ~= nil then
		return firePowerTable[firePower]
	else
		return 0xFF
	end
end
local function firePower(hex)
	local firePowerTable = {
		["00"] = "fire_power_0",
		["01"] = "fire_power_1",
		["02"] = "fire_power_2",
		["03"] = "fire_power_3",
		["04"] = "fire_power_4",
		["05"] = "fire_power_5",
		["06"] = "fire_power_6",
		["07"] = "fire_power_7",
		["08"] = "fire_power_8",
		["09"] = "fire_power_9",
		["0A"] = "fire_power_10",
	}
	local value = firePowerTable[string.upper(hex)]
	if value ~= nil then
		return value
	else
		return "ff"
	end
end
local function workStatus16(status)
	local statusTable = { ["save_power"] = 0x01, ["standby"] = 0x02, ["work"] = 0x03, ["pause"] = 0x06 }
	local value = statusTable[status]
	if value ~= nil then
		return value
	else
		return 0xFF
	end
end
local function workStatus(hex)
	local statusTable = {
		["01"] = "save_power",
		["02"] = "standby",
		["03"] = "work",
		["04"] = "work_finish",
		["05"] = "order",
		["06"] = "pause",
		["07"] = "pause_c",
		["08"] = "three",
		["0A"] = "self_inspection",
		["0B"] = "query_version",
		["0C"] = "demo",
		["0D"] = "ramadan",
		["0E"] = "after_checking",
		["11"] = "ota_updating",
	}
	local value = statusTable[string.upper(hex)]
	if value ~= nil then
		return value
	else
		return "ff"
	end
end
local function workend16(action)
	local workendTable = { ["auto_next"] = 0x00, ["wait_next"] = 0x01, ["user_confirm_next"] = 0x02 }
	local value = workendTable[action]
	if value ~= nil then
		return value
	else
		return 0x00
	end
end
local function powerStatus16(power)
	local powerTable = { ["on"] = 0x11, ["off"] = 0x01 }
	local value = powerTable[power]
	if value ~= nil then
		return value
	else
		return 0xFF
	end
end
local function singleCooking(control, bodyBytes)
	local b5 = 0
	if control["pre_heat"] == "on" then
		b5 = b5 + 1
	end
	if control["work_mode"] ~= nil then
		local workMode = workMode16(control["work_mode"])
		bodyBytes[6] = "0x" .. string.sub(workMode, 1, 2)
		bodyBytes[7] = "0x" .. string.sub(workMode, -2)
	else
		bodyBytes[6] = 0xFF
		bodyBytes[7] = 0xFF
	end
	if control["work_hour"] ~= nil then
		bodyBytes[8] = control["work_hour"]
	else
		bodyBytes[8] = 0xFF
	end
	if control["work_minute"] ~= nil then
		bodyBytes[9] = control["work_minute"]
	else
		bodyBytes[9] = 0xFF
	end
	if control["work_second"] ~= nil then
		bodyBytes[10] = control["work_second"]
	else
		bodyBytes[10] = 0xFF
	end
	local firePower = firePower16(control["fire_power"])
	if firePower == nil then
		bodyBytes[11] = 0xFF
	else
		bodyBytes[11] = firePower
	end
	bodyBytes[12] = 0xFF
	bodyBytes[13] = 0xFF
	bodyBytes[14] = 0xFF
	bodyBytes[15] = 0xFF
	local temperature = control["temperature"]
	if temperature ~= nil then
		local temperatureH = math.modf(temperature / (16 ^ 2))
		local temperatureL = math.fmod(temperature, (16 ^ 2))
		bodyBytes[12] = temperatureH
		bodyBytes[13] = temperatureL
	end
	if control["work_mode"] == "pastry_steam" then
		bodyBytes[12] = 0
		bodyBytes[13] = 100
	elseif control["work_mode"] == "steam_hot_wind_tube_fan_3" then
		bodyBytes[12] = 0
		bodyBytes[13] = 130
	end
	local temperature_above = control["temperature_above"]
	local temperature_underside = control["temperature_underside"]
	if temperature_above ~= nil then
		local temperatureH = math.modf(temperature_above / (16 ^ 2))
		local temperatureL = math.fmod(temperature_above, (16 ^ 2))
		bodyBytes[12] = temperatureH
		bodyBytes[13] = temperatureL
	end
	if temperature_underside ~= nil then
		local temperatureH = math.modf(temperature_underside / (16 ^ 2))
		local temperatureL = math.fmod(temperature_underside, (16 ^ 2))
		bodyBytes[14] = temperatureH
		bodyBytes[15] = temperatureL
	end
	local probeTemperature = control["probe_temperature"]
	if probeTemperature == nil then
		bodyBytes[16] = 0x00
		bodyBytes[17] = 0x00
	else
		b5 = b5 + 2
		local probeTemperatureH = math.modf(probeTemperature / (16 ^ 2))
		local probeTemperatureL = math.fmod(probeTemperature, (16 ^ 2))
		bodyBytes[16] = probeTemperatureH
		bodyBytes[17] = probeTemperatureL
	end
	local steamQuantity = control["steam_quantity"]
	local mouthfeel = control["mouthfeel"]
	if steamQuantity == nil and mouthfeel == nil then
		bodyBytes[18] = 0xFF
	else
		local b18 = 0
		if steamQuantity ~= nil then
			b18 = b18 + steamQuantity
		end
		if mouthfeel == "crisp" then
			b18 = b18 + 64
		end
		bodyBytes[18] = b18
	end
	if control["weight"] ~= nil then
		local weight = control["weight"]
		if control["weight_unit"] == "oz" then
			bodyBytes[19] = weight
		else
			bodyBytes[19] = weight / 10
		end
	elseif control["people_number"] ~= nil then
		bodyBytes[19] = control["people_number"]
	else
		bodyBytes[19] = 0xFF
	end
	bodyBytes[20] = 0xFF
	bodyBytes[21] = 0x00
	bodyBytes[22] = 0xFF
	bodyBytes[23] = 0xFF
	bodyBytes[24] = 0xFF
	bodyBytes[25] = 0x00
	bodyBytes[26] = 0x00
	bodyBytes[5] = b5
	local diyAction = control["diy_action"]
	if diyAction ~= nil then
		bodyBytes[0] = 0x0A
		bodyBytes[21] = 0x00
		bodyBytes[22] = 0x00
		bodyBytes[23] = 0x00
		if diyAction == "add" then
			bodyBytes[24] = 0x01
		elseif diyAction == "delete" then
			bodyBytes[24] = 0x02
		elseif diyAction == "update" then
			bodyBytes[24] = 0x03
		elseif diyAction == "delete_all" then
			bodyBytes[24] = 0x04
		else
			bodyBytes[24] = 0xFF
		end
		local diyCookingNum = control["diy_num"]
		if diyCookingNum ~= nil then
			bodyBytes[25] = diyCookingNum
		else
			bodyBytes[25] = 0xFF
		end
		local byteN = 26
		local diyNameCode = control["diy_name_code"]
		if diyNameCode ~= nil then
			local len = #diyNameCode
			bodyBytes[byteN] = len / 4
			local temp = len / 2
			for i = 1, temp do
				byteN = byteN + 1
				bodyBytes[byteN] = "0x" .. string.sub(diyNameCode, i * 2 - 1, i * 2)
			end
		else
			bodyBytes[byteN] = 0x00
		end
		byteN = byteN + 1
		local mealType = control["meal_type"]
		if mealType ~= nil then
			bodyBytes[byteN] = mealType
		else
			bodyBytes[byteN] = 0x00
		end
		local userId = control["user_id"]
		if userId ~= nil then
			local userIdn = tonumber(userId)
			local userIdH = math.modf(userIdn / (16 ^ 4))
			local userIdTemp = math.fmod(userIdn, (16 ^ 4))
			local userIdM = math.modf(userIdTemp / (16 ^ 2))
			local userIdL = math.fmod(userIdTemp, (16 ^ 2))
			bodyBytes[byteN + 1] = userIdH
			bodyBytes[byteN + 2] = userIdM
			bodyBytes[byteN + 3] = userIdL
		else
			bodyBytes[byteN + 1] = 0x00
			bodyBytes[byteN + 2] = 0x00
			bodyBytes[byteN + 3] = 0x00
		end
		byteN = byteN + 4
		local diyMenuId = control["diy_menu_id_code"]
		if diyMenuId ~= nil then
			local len = #diyMenuId
			local temp = len / 2
			bodyBytes[byteN] = temp
			for i = 1, temp do
				byteN = byteN + 1
				bodyBytes[byteN] = "0x" .. string.sub(diyMenuId, i * 2 - 1, i * 2)
			end
		else
			bodyBytes[byteN] = 0x00
		end
	end
end
local function multistageCooking(n, cooking, bodyBytes, control)
	local b5 = 0
	if cooking["pre_heat"] == "on" then
		b5 = b5 + 1
	end
	local workMode = workMode16(cooking["work_mode"])
	bodyBytes[6 + (n - 1) * 16] = "0x" .. string.sub(workMode, 1, 2)
	bodyBytes[7 + (n - 1) * 16] = "0x" .. string.sub(workMode, -2)
	if cooking["work_hour"] ~= nil then
		bodyBytes[8 + (n - 1) * 16] = cooking["work_hour"]
	else
		bodyBytes[8 + (n - 1) * 16] = 0xFF
	end
	if cooking["work_minute"] ~= nil then
		bodyBytes[9 + (n - 1) * 16] = cooking["work_minute"]
	else
		bodyBytes[9 + (n - 1) * 16] = 0xFF
	end
	if cooking["work_second"] ~= nil then
		bodyBytes[10 + (n - 1) * 16] = cooking["work_second"]
	else
		bodyBytes[10 + (n - 1) * 16] = 0xFF
	end
	local firePower = firePower16(cooking["fire_power"])
	if firePower == nil then
		bodyBytes[11 + (n - 1) * 16] = 0xFF
	else
		bodyBytes[11 + (n - 1) * 16] = firePower
	end
	bodyBytes[12 + (n - 1) * 16] = 0xFF
	bodyBytes[13 + (n - 1) * 16] = 0xFF
	bodyBytes[14 + (n - 1) * 16] = 0xFF
	bodyBytes[15 + (n - 1) * 16] = 0xFF
	local temperature = cooking["temperature"]
	if temperature ~= nil then
		local temperatureH = math.modf(temperature / (16 ^ 2))
		local temperatureL = math.fmod(temperature, (16 ^ 2))
		bodyBytes[12 + (n - 1) * 16] = temperatureH
		bodyBytes[13 + (n - 1) * 16] = temperatureL
	end
	if control["work_mode"] == "pastry_steam" then
		bodyBytes[12 + (n - 1) * 16] = 0
		bodyBytes[13 + (n - 1) * 16] = 100
	elseif control["work_mode"] == "steam_hot_wind_tube_fan_3" then
		bodyBytes[12 + (n - 1) * 16] = 0
		bodyBytes[13 + (n - 1) * 16] = 130
	end
	local temperature_above = cooking["temperature_above"]
	local temperature_underside = cooking["temperature_underside"]
	if temperature_above ~= nil then
		local temperatureH = math.modf(temperature_above / (16 ^ 2))
		local temperatureL = math.fmod(temperature_above, (16 ^ 2))
		bodyBytes[12 + (n - 1) * 16] = temperatureH
		bodyBytes[13 + (n - 1) * 16] = temperatureL
	end
	if temperature_underside ~= nil then
		local temperatureH = math.modf(temperature_underside / (16 ^ 2))
		local temperatureL = math.fmod(temperature_underside, (16 ^ 2))
		bodyBytes[14 + (n - 1) * 16] = temperatureH
		bodyBytes[15 + (n - 1) * 16] = temperatureL
	end
	local probeTemperature = cooking["probe_temperature"]
	if probeTemperature == nil then
		bodyBytes[16 + (n - 1) * 16] = 0x00
		bodyBytes[17 + (n - 1) * 16] = 0x00
	else
		b5 = b5 + 2
		local probeTemperatureH = math.modf(probeTemperature / (16 ^ 2))
		local probeTemperatureL = math.fmod(probeTemperature, (16 ^ 2))
		bodyBytes[16 + (n - 1) * 16] = probeTemperatureH
		bodyBytes[17 + (n - 1) * 16] = probeTemperatureL
	end
	local steamQuantity = cooking["steam_quantity"]
	local mouthfeel = cooking["mouthfeel"]
	if steamQuantity == nil and mouthfeel == nil then
		bodyBytes[18 + (n - 1) * 16] = 0xFF
	else
		local b18 = 0
		if steamQuantity ~= nil then
			b18 = b18 + steamQuantity
		end
		if mouthfeel == "crisp" then
			b18 = b18 + 64
		end
		bodyBytes[18 + (n - 1) * 16] = b18
	end
	if cooking["weight"] ~= nil then
		local weight = cooking["weight"]
		if control["weight_unit"] == "oz" then
			bodyBytes[19 + (n - 1) * 16] = weight
		else
			bodyBytes[19 + (n - 1) * 16] = weight / 10
		end
	elseif cooking["people_number"] ~= nil then
		bodyBytes[19 + (n - 1) * 16] = cooking["people_number"]
	else
		bodyBytes[19 + (n - 1) * 16] = 0xFF
	end
	bodyBytes[20 + (n - 1) * 16] = workend16(cooking["workend"])
	bodyBytes[5 + (n - 1) * 16] = b5
end
local function workModeControl(control, bodyBytes)
	bodyBytes[0] = 0x01
	local cloudmenuid = control["cloudmenuid"]
	if cloudmenuid ~= nil then
		local cloudmenuidn = tonumber(cloudmenuid)
		local cloudmenuidH = math.modf(cloudmenuidn / (16 ^ 4))
		local cloudmenuidTemp = math.fmod(cloudmenuidn, (16 ^ 4))
		local cloudmenuidM = math.modf(cloudmenuidTemp / (16 ^ 2))
		local cloudmenuidL = math.fmod(cloudmenuidTemp, (16 ^ 2))
		bodyBytes[1] = cloudmenuidH
		bodyBytes[2] = cloudmenuidM
		bodyBytes[3] = cloudmenuidL
	else
		bodyBytes[1] = 0x00
		bodyBytes[2] = 0x00
		bodyBytes[3] = 0x00
	end
	local totalstep
	if control["totalstep"] == nil then
		totalstep = 1
		bodyBytes[4] = 0x11
		singleCooking(control, bodyBytes)
	else
		totalstep = control["totalstep"]
		bodyBytes[4] = "0x" .. totalstep .. control["stepnum_start"]
		local cookingsStr = control["cookings"]
		local cookings = JSON.decode(cookingsStr)
		for key, value in pairs(cookings) do
			multistageCooking(value["stepnum"], value, bodyBytes, control)
		end
		bodyBytes[21 + (totalstep - 1) * 16] = 0x00
		bodyBytes[22 + (totalstep - 1) * 16] = 0xFF
		bodyBytes[23 + (totalstep - 1) * 16] = 0xFF
		bodyBytes[24 + (totalstep - 1) * 16] = 0xFF
		bodyBytes[25 + (totalstep - 1) * 16] = 0x00
		bodyBytes[26 + (totalstep - 1) * 16] = 0x00
		local diyAction = control["diy_action"]
		if diyAction ~= nil then
			bodyBytes[0] = 0x0A
			bodyBytes[21 + (totalstep - 1) * 16] = 0x00
			bodyBytes[22 + (totalstep - 1) * 16] = 0x00
			bodyBytes[23 + (totalstep - 1) * 16] = 0x00
			if diyAction == "add" then
				bodyBytes[24 + (totalstep - 1) * 16] = 0x01
			elseif diyAction == "delete" then
				bodyBytes[24 + (totalstep - 1) * 16] = 0x02
			elseif diyAction == "update" then
				bodyBytes[24 + (totalstep - 1) * 16] = 0x03
			elseif diyAction == "delete_all" then
				bodyBytes[24 + (totalstep - 1) * 16] = 0x04
			else
				bodyBytes[24 + (totalstep - 1) * 16] = 0xFF
			end
			local diyCookingNum = control["diy_num"]
			if diyCookingNum ~= nil then
				bodyBytes[25 + (totalstep - 1) * 16] = diyCookingNum
			else
				bodyBytes[25 + (totalstep - 1) * 16] = 0xFF
			end
			local byteN = 26 + (totalstep - 1) * 16
			local diyNameCode = control["diy_name_code"]
			if diyNameCode ~= nil then
				local len = #diyNameCode
				bodyBytes[byteN] = len / 4
				local temp = len / 2
				for i = 1, temp do
					byteN = byteN + 1
					bodyBytes[byteN] = "0x" .. string.sub(diyNameCode, i * 2 - 1, i * 2)
				end
			else
				bodyBytes[byteN] = 0x00
			end
			byteN = byteN + 1
			local mealType = control["meal_type"]
			if mealType ~= nil then
				bodyBytes[byteN] = mealType
			else
				bodyBytes[byteN] = 0x00
			end
			local userId = control["user_id"]
			if userId ~= nil then
				local userIdn = tonumber(userId)
				local userIdH = math.modf(userIdn / (16 ^ 4))
				local userIdTemp = math.fmod(userIdn, (16 ^ 4))
				local userIdM = math.modf(userIdTemp / (16 ^ 2))
				local userIdL = math.fmod(userIdTemp, (16 ^ 2))
				bodyBytes[byteN + 1] = userIdH
				bodyBytes[byteN + 2] = userIdM
				bodyBytes[byteN + 3] = userIdL
			else
				bodyBytes[byteN + 1] = 0x00
				bodyBytes[byteN + 2] = 0x00
				bodyBytes[byteN + 3] = 0x00
			end
			byteN = byteN + 4
			local diyMenuId = control["diy_menu_id_code"]
			if diyMenuId ~= nil then
				local len = #diyMenuId
				local temp = len / 2
				bodyBytes[byteN] = temp
				for i = 1, temp do
					byteN = byteN + 1
					bodyBytes[byteN] = "0x" .. string.sub(diyMenuId, i * 2 - 1, i * 2)
				end
			else
				bodyBytes[byteN] = 0x00
			end
		end
	end
end
local function notWorkModeControl(control, bodyBytes)
	bodyBytes[0] = 0x02
	if control["work_status"] ~= nil then
		bodyBytes[1] = workStatus16(control["work_status"])
	elseif control["power"] ~= nil then
		bodyBytes[1] = powerStatus16(control["power"])
	else
		bodyBytes[1] = 0xFF
	end
	if control["lock"] == "off" then
		bodyBytes[2] = 0x00
	elseif control["lock"] == "on" then
		bodyBytes[2] = 0x01
	else
		bodyBytes[2] = 0xFF
	end
	if control["furnace_light"] == "off" then
		bodyBytes[3] = 0x00
	elseif control["furnace_light"] == "on" then
		bodyBytes[3] = 0x01
	else
		bodyBytes[3] = 0xFF
	end
	bodyBytes[4] = 0xFF
	if control["door"] == "close" then
		bodyBytes[5] = 0x00
	elseif control["door"] == "open" then
		bodyBytes[5] = 0x01
	else
		bodyBytes[5] = 0xFF
	end
	bodyBytes[6] = 0xFF
	bodyBytes[7] = 0xFF
end
local function aiControl(control, bodyBytes)
	bodyBytes[0] = 0x09
	if control["camera_status"] == "on" then
		bodyBytes[1] = 0x01
	elseif control["camera_status"] == "off" then
		bodyBytes[1] = 0x00
	else
		bodyBytes[1] = 0xFF
	end
	if control["image_shoot"] == "single" then
		bodyBytes[2] = 0x01
	elseif control["image_shoot"] == "continuous" then
		bodyBytes[2] = 0x02
	elseif control["image_shoot"] == "continuous_pause" then
		bodyBytes[2] = 0x03
	elseif control["image_shoot"] == "food_material_recognition" then
		bodyBytes[2] = 0x04
	elseif control["image_shoot"] == "food_maturity_recognition" then
		bodyBytes[2] = 0x05
	else
		bodyBytes[2] = 0xFF
	end
	if control["live_video"] == "on" then
		bodyBytes[3] = 0x01
	elseif control["live_video"] == "off" then
		bodyBytes[3] = 0x02
	else
		bodyBytes[3] = 0xFF
	end
	bodyBytes[4] = 0xFF
	bodyBytes[5] = 0x0A
	bodyBytes[6] = 0x00
	if control["video_record"] == "start" then
		bodyBytes[7] = 0x01
	elseif control["video_record"] == "stop" then
		bodyBytes[7] = 0x02
	else
		bodyBytes[7] = 0xFF
	end
	if control["video_record_mode"] == "manual" then
		bodyBytes[8] = 0x00
	elseif control["video_record_mode"] == "auto" then
		bodyBytes[8] = 0x01
	else
		bodyBytes[8] = 0xFF
	end
	bodyBytes[9] = 0xFF
	bodyBytes[10] = 0xFF
	bodyBytes[11] = 0xFF
	bodyBytes[12] = 0xFF
end
local function intelligentComponentControl(control, bodyBytes)
	bodyBytes[0] = 0x09
	bodyBytes[1] = 0xFF
	bodyBytes[2] = 0xFF
	bodyBytes[3] = 0xFF
	bodyBytes[4] = 0xFF
	bodyBytes[5] = 0xFF
	bodyBytes[6] = 0xFF
	bodyBytes[7] = 0xFF
	bodyBytes[8] = 0xFF
	bodyBytes[9] = 0xFF
	bodyBytes[10] = 0xFF
	bodyBytes[11] = 0xFF
	bodyBytes[12] = 0xFF
	if control["dial_plate_num"] ~= nil then
		bodyBytes[13] = control["dial_plate_num"]
	else
		bodyBytes[13] = 0xFF
	end
end
local function increaseControl(control, bodyBytes)
	bodyBytes[0] = 0x03
	local hour = control["hour_increase"]
	local minute = control["minute_increase"]
	local second = control["second_increase"]
	local byteN = 2
	local paramSum = 0
	if hour ~= nil or minute ~= nil or second ~= nil then
		bodyBytes[1] = 0x02
		if hour < 0 or minute < 0 or second < 0 then
			bodyBytes[1] = 0x03
		end
		byteN = byteN + 1
		bodyBytes[byteN] = 0x01
		if hour ~= nil then
			bodyBytes[byteN + 1] = math.abs(hour)
		else
			bodyBytes[byteN + 1] = 0x00
		end
		if minute ~= nil then
			bodyBytes[byteN + 2] = math.abs(minute)
		else
			bodyBytes[byteN + 2] = 0x00
		end
		if second ~= nil then
			bodyBytes[byteN + 3] = math.abs(second)
		else
			bodyBytes[byteN + 3] = 0x00
		end
		byteN = byteN + 3
		paramSum = paramSum + 1
	end
	bodyBytes[2] = paramSum
end
local function setControl(control, bodyBytes)
	bodyBytes[0] = 0x03
	bodyBytes[1] = 0x01
	local byteN = 2
	local paramSum = 0
	if control["steam_set"] ~= nil then
		byteN = byteN + 1
		bodyBytes[byteN] = 0x00
		byteN = byteN + 1
		paramSum = paramSum + 1
		bodyBytes[byteN] = tonumber(control["steam_set"])
	end
	local mouthfeel = control["mouthfeel_set"]
	if mouthfeel ~= nil then
		byteN = byteN + 1
		bodyBytes[byteN] = 0x00
		byteN = byteN + 1
		paramSum = paramSum + 1
		if mouthfeel == "crisp" then
			bodyBytes[byteN] = 0x40
		else
			bodyBytes[byteN] = 0x00
		end
	end
	if control["hour_set"] ~= nil or control["minute_set"] ~= nil or control["second_set"] ~= nil then
		byteN = byteN + 1
		bodyBytes[byteN] = 0x01
		if control["hour_set"] ~= nil then
			bodyBytes[byteN + 1] = tonumber(control["hour_set"])
		else
			bodyBytes[byteN + 1] = 0x00
		end
		if control["minute_set"] ~= nil then
			bodyBytes[byteN + 2] = tonumber(control["minute_set"])
		else
			bodyBytes[byteN + 2] = 0x00
		end
		if control["second_set"] ~= nil then
			bodyBytes[byteN + 3] = tonumber(control["second_set"])
		else
			bodyBytes[byteN + 3] = 0x00
		end
		byteN = byteN + 3
		paramSum = paramSum + 1
	end
	if control["fire_power_set"] ~= nil then
		byteN = byteN + 1
		bodyBytes[byteN] = 0x02
		byteN = byteN + 1
		paramSum = paramSum + 1
		bodyBytes[byteN] = firePower16(control["fire_power_set"])
	end
	local temperature = control["temp_set"]
	if temperature ~= nil then
		local temperatureH = math.modf(temperature / (16 ^ 2))
		local temperatureL = math.fmod(temperature, (16 ^ 2))
		byteN = byteN + 1
		bodyBytes[byteN] = 0x03
		bodyBytes[byteN + 1] = 0x00
		bodyBytes[byteN + 2] = temperatureH
		bodyBytes[byteN + 3] = temperatureL
		byteN = byteN + 3
		paramSum = paramSum + 1
	end
	local probeTemperature = control["probe_temp_set"]
	if probeTemperature ~= nil then
		local temperatureH = math.modf(probeTemperature / (16 ^ 2))
		local temperatureL = math.fmod(probeTemperature, (16 ^ 2))
		byteN = byteN + 1
		bodyBytes[byteN] = 0x04
		bodyBytes[byteN + 1] = 0x00
		bodyBytes[byteN + 2] = temperatureH
		bodyBytes[byteN + 3] = temperatureL
		byteN = byteN + 3
		paramSum = paramSum + 1
	end
	local temperature_above = control["temp_above_set"]
	if temperature_above ~= nil then
		local temperatureH = math.modf(temperature_above / (16 ^ 2))
		local temperatureL = math.fmod(temperature_above, (16 ^ 2))
		byteN = byteN + 1
		bodyBytes[byteN] = 0x05
		bodyBytes[byteN + 1] = 0x00
		bodyBytes[byteN + 2] = 0x00
		bodyBytes[byteN + 3] = 0x00
		bodyBytes[byteN + 4] = temperatureH
		bodyBytes[byteN + 5] = temperatureL
		byteN = byteN + 5
		paramSum = paramSum + 1
	end
	local temperature_underside = control["temp_underside_set"]
	if temperature_underside ~= nil then
		local temperatureH = math.modf(temperature_underside / (16 ^ 2))
		local temperatureL = math.fmod(temperature_underside, (16 ^ 2))
		byteN = byteN + 1
		bodyBytes[byteN] = 0x05
		bodyBytes[byteN + 1] = 0x00
		bodyBytes[byteN + 2] = 0x00
		bodyBytes[byteN + 3] = 0x01
		bodyBytes[byteN + 4] = temperatureH
		bodyBytes[byteN + 5] = temperatureL
		byteN = byteN + 5
		paramSum = paramSum + 1
	end
	bodyBytes[2] = paramSum
end
local function cameraOtaControl(control, bodyBytes)
	bodyBytes[0] = 0x65
	bodyBytes[1] = 0x00
	bodyBytes[2] = 0x02
	bodyBytes[3] = 0x02
	if control["camera_ota"] == "download" then
		bodyBytes[4] = 0x01
	elseif control["camera_ota"] == "install" then
		bodyBytes[4] = 0x02
	elseif control["camera_ota"] == "cancel" then
		bodyBytes[4] = 0x03
	end
end
function jsonToData(jsonCmdStr)
	if #jsonCmdStr == 0 then
		return nil
	end
	local msgBytes
	local json = decodeJsonToTable(jsonCmdStr)
	local query = json["query"]
	local control = json["control"]
	if control then
		local bodyBytes = {}
		if control["work_mode"] ~= nil or control["cookings"] ~= nil or control["diy_action"] ~= nil then
			workModeControl(control, bodyBytes)
		elseif
			control["work_status"] ~= nil
			or control["lock"] ~= nil
			or control["furnace_light"] ~= nil
			or control["power"] ~= nil
		then
			notWorkModeControl(control, bodyBytes)
		elseif control["dial_plate_num"] ~= nil then
			intelligentComponentControl(control, bodyBytes)
		elseif
			control["camera_status"] ~= nil
			or control["image_shoot"] ~= nil
			or control["live_video"] ~= nil
			or control["video_record"] ~= nil
			or control["video_record_mode"] ~= nil
		then
			aiControl(control, bodyBytes)
		elseif
			control["hour_increase"] ~= nil
			or control["minute_increase"] ~= nil
			or control["second_increase"] ~= nil
		then
			increaseControl(control, bodyBytes)
		elseif
			control["hour_set"] ~= nil
			or control["minute_set"] ~= nil
			or control["second_set"] ~= nil
			or control["temp_set"] ~= nil
			or control["steam_set"] ~= nil
			or control["fire_power_set"] ~= nil
			or control["temp_above_set"] ~= nil
			or control["temp_underside_set"] ~= nil
			or control["mouthfeel_set"] ~= nil
		then
			setControl(control, bodyBytes)
		elseif control["camera_ota"] ~= nil then
			cameraOtaControl(control, bodyBytes)
		end
		msgBytes = assembleUart(bodyBytes, BYTE_CONTROL_REQUEST)
	elseif query then
		local bodyLength = 1
		local bodyBytes = {}
		if query["query_type"] == "camera_ota" then
			bodyBytes[0] = 0x65
			bodyBytes[1] = 0x00
			bodyBytes[2] = 0x02
		else
			bodyBytes[0] = 0x01
		end
		for i = 1, bodyLength - 1 do
			bodyBytes[i] = 0x00
		end
		msgBytes = assembleUart(bodyBytes, BYTE_QUERY_REQUEST)
	end
	local infoM = {}
	local length = #msgBytes + 1
	for i = 1, length do
		infoM[i] = msgBytes[i - 1]
	end
	local ret = tableToString(infoM)
	return stringToHex(ret)
end
local function executeMessage(hex)
	local executeTable = {
		["00"] = "ok",
		["01"] = "status_nonsupport",
		["02"] = "function_nonsupport",
		["03"] = "param_range_error",
		["04"] = "save_power_nonsupport",
		["05"] = "device_fault",
		["06"] = "door_open",
		["07"] = "working_control_nonsupport",
		["08"] = "lack_water",
		["09"] = "lack_box",
		["0A"] = "change_water_notice",
		["0B"] = "high_temperature_nonsupport",
		["0C"] = "remote_control_closed",
	}
	local value = executeTable[string.upper(hex)]
	if value ~= nil then
		return value
	else
		return "unknown"
	end
end
local function totalState(jsonTable, megBodys)
	jsonTable["execute"] = executeMessage(megBodys[11])
	jsonTable["cloudmenuid"] = tonumber(megBodys[12], 16) * (16 ^ 4)
		+ tonumber(megBodys[13], 16) * (16 ^ 2)
		+ tonumber(megBodys[14], 16)
	jsonTable["totalstep"] = math.modf(tonumber(megBodys[15], 16) / 16)
	jsonTable["stepnum"] = math.fmod(tonumber(megBodys[15], 16), 16)
	jsonTable["work_mode"] = workMode(megBodys[17], megBodys[18])
	if string.lower(megBodys[19]) ~= "ff" then
		jsonTable["hour_set"] = tonumber(megBodys[19], 16)
	end
	if string.lower(megBodys[20]) ~= "ff" then
		jsonTable["minute_set"] = tonumber(megBodys[20], 16)
	end
	if string.lower(megBodys[21]) ~= "ff" then
		jsonTable["second_set"] = tonumber(megBodys[21], 16)
	end
	jsonTable["fire_power"] = firePower(megBodys[22])
	jsonTable["temperature_above"] = tonumber(megBodys[23] .. megBodys[24], 16)
	jsonTable["temperature_underside"] = tonumber(megBodys[25] .. megBodys[26], 16)
	jsonTable["temperature"] = tonumber(megBodys[23] .. megBodys[24], 16)
	jsonTable["steam_quantity"] = "ff"
	jsonTable["mouthfeel"] = "ff"
	if string.lower(megBodys[29]) ~= "ff" then
		local b29 = megBodys[29]
		local bit0 = getByteBit(b29, 0)
		local bit1 = getByteBit(b29, 1)
		local bit2 = getByteBit(b29, 2)
		local bit3 = getByteBit(b29, 3)
		local bit6 = getByteBit(b29, 6)
		local steamQuantity = 0
		if bit0 == "1" then
			steamQuantity = steamQuantity + 1
		end
		if bit1 == "1" then
			steamQuantity = steamQuantity + 2
		end
		if bit2 == "1" then
			steamQuantity = steamQuantity + 4
		end
		if bit3 == "1" then
			steamQuantity = steamQuantity + 8
		end
		jsonTable["steam_quantity"] = steamQuantity
		local mouthfeel = "fresh"
		if bit6 == "1" then
			mouthfeel = "crisp"
		end
		jsonTable["mouthfeel"] = mouthfeel
	end
	jsonTable["weight"] = 0
	jsonTable["people_number"] = 0
	if string.lower(megBodys[30]) ~= "ff" then
		local weight = tonumber(megBodys[30], 16) * 10
		if weight >= 100 then
			jsonTable["weight"] = weight
		end
		local peopleNumber = tonumber(megBodys[30], 16)
		if peopleNumber < 10 then
			jsonTable["people_number"] = peopleNumber
		end
	end
	if string.lower(megBodys[32]) ~= "ff" then
		jsonTable["work_hour"] = tonumber(megBodys[32], 16)
	else
		jsonTable["work_hour"] = 0
	end
	if string.lower(megBodys[33]) ~= "ff" then
		jsonTable["work_minute"] = tonumber(megBodys[33], 16)
	else
		jsonTable["work_minute"] = 0
	end
	if string.lower(megBodys[34]) ~= "ff" then
		jsonTable["work_second"] = tonumber(megBodys[34], 16)
	else
		jsonTable["work_second"] = 0
	end
	if string.lower(megBodys[35]) ~= "ff" and string.lower(megBodys[36]) ~= "ff" then
		jsonTable["cur_temperature"] = tonumber(megBodys[35] .. megBodys[36], 16)
		jsonTable["cur_temperature_above"] = tonumber(megBodys[35] .. megBodys[36], 16)
	else
		jsonTable["cur_temperature"] = 0
		jsonTable["cur_temperature_above"] = 0
	end
	if string.lower(megBodys[37]) ~= "ff" and string.lower(megBodys[38]) ~= "ff" then
		jsonTable["cur_temperature_underside"] = tonumber(megBodys[37] .. megBodys[38], 16)
	else
		jsonTable["cur_temperature_underside"] = 0
	end
	jsonTable["work_status"] = workStatus(megBodys[41])
	local b42 = megBodys[42]
	local b43 = megBodys[43]
	local lock = getByteBit(b42, 0)
	local door = getByteBit(b42, 1)
	local water_box = getByteBit(b42, 2)
	local water_state = getByteBit(b42, 3)
	local change_water = getByteBit(b42, 4)
	local preheat = getByteBit(b42, 5)
	local preheat_end = getByteBit(b42, 6)
	local error_code = getByteBit(b42, 7)
	local flip_side = getByteBit(b43, 0)
	local reaction = getByteBit(b43, 1)
	local furnace_light = getByteBit(b43, 2)
	local high_temperature_work = getByteBit(b43, 4)
	if lock == "1" then
		jsonTable["lock"] = "on"
	elseif lock == "0" then
		jsonTable["lock"] = "off"
	end
	if door == "1" then
		jsonTable["door_open"] = "on"
	elseif door == "0" then
		jsonTable["door_open"] = "off"
	end
	if water_box == "1" then
		jsonTable["lack_box"] = 1
	else
		jsonTable["lack_box"] = 0
	end
	if water_state == "1" then
		jsonTable["lack_water"] = 1
	else
		jsonTable["lack_water"] = 0
	end
	if change_water == "1" then
		jsonTable["change_water"] = 1
	else
		jsonTable["change_water"] = 0
	end
	jsonTable["pre_heat"] = "off"
	if preheat_end == "1" then
		jsonTable["pre_heat"] = "end"
	elseif preheat == "1" then
		jsonTable["pre_heat"] = "work"
	end
	if flip_side == "1" then
		jsonTable["flip_side"] = 1
	else
		jsonTable["flip_side"] = 0
	end
	if error_code == "1" then
		jsonTable["error_code"] = 1
	else
		jsonTable["error_code"] = 0
	end
	if reaction == "1" then
		jsonTable["reaction"] = 1
	else
		jsonTable["reaction"] = 0
	end
	if furnace_light == "1" then
		jsonTable["furnace_light"] = "on"
	else
		jsonTable["furnace_light"] = "off"
	end
	if high_temperature_work == "1" then
		jsonTable["high_temperature_work"] = 1
	else
		jsonTable["high_temperature_work"] = 0
	end
	local b44 = megBodys[44]
	local app_control = getByteBit(b44, 7)
	if app_control == "1" then
		jsonTable["app_control"] = 1
	else
		jsonTable["app_control"] = 0
	end
	local num = 1
	local errorValues = {}
	local b49 = megBodys[49]
	if string.lower(b49) ~= "ff" and tonumber(b49, 16) > 0 then
		local errorCount = tonumber(b49, 16)
		num = errorCount
		for i = 1, errorCount do
			errorValues[i] = string.upper(megBodys[50 + 2 * (i - 1)] .. megBodys[51 + 2 * (i - 1)])
		end
	else
		errorValues[1] = ""
	end
	jsonTable["error_values"] = errorValues
	jsonTable["spread_sauce"] = 0
	jsonTable["add_sauce"] = 0
	jsonTable["stir"] = 0
	jsonTable["recipe_general_prompt"] = 0
	local b52 = megBodys[52 + 2 * (num - 1)]
	if b52 ~= nil then
		local bit0 = getByteBit(b52, 0)
		local bit1 = getByteBit(b52, 1)
		local bit2 = getByteBit(b52, 2)
		local bit3 = getByteBit(b52, 3)
		local bit4 = getByteBit(b52, 4)
		local bit5 = getByteBit(b52, 5)
		if bit5 == "0" and bit4 == "0" and bit3 == "0" and bit2 == "1" and bit1 == "0" and bit0 == "0" then
			jsonTable["spread_sauce"] = 1
		end
		if bit5 == "0" and bit4 == "0" and bit3 == "0" and bit2 == "1" and bit1 == "0" and bit0 == "1" then
			jsonTable["add_sauce"] = 1
		end
		if bit5 == "0" and bit4 == "0" and bit3 == "0" and bit2 == "1" and bit1 == "1" and bit0 == "0" then
			jsonTable["stir"] = 1
		end
		if bit5 == "0" and bit4 == "0" and bit3 == "0" and bit2 == "1" and bit1 == "1" and bit0 == "1" then
			jsonTable["recipe_general_prompt"] = 1
		end
	end
	jsonTable["cbs_version"] = "V0.0.0"
	local b57 = megBodys[57 + 2 * (num - 1)]
	local b58 = megBodys[58 + 2 * (num - 1)]
	local b59 = megBodys[59 + 2 * (num - 1)]
	if b57 ~= nil and b58 ~= nil and b59 ~= nil then
		local cbs_version = "V" .. tonumber(b57, 16) .. "." .. tonumber(b58, 16) .. "." .. tonumber(b59, 16)
		jsonTable["cbs_version"] = cbs_version
	end
	jsonTable["clean_scale"] = 0
	jsonTable["ota"] = 0
	local b66 = megBodys[66 + 2 * (num - 1)]
	if b66 ~= nil then
		local clean_scale = getByteBit(b66, 6)
		if clean_scale == "1" then
			jsonTable["clean_scale"] = 1
		end
		local ota = getByteBit(b66, 7)
		if ota == "1" then
			jsonTable["ota"] = 1
		end
	end
	jsonTable["clean_sink_ponding"] = 0
	jsonTable["dissipate_heat"] = "off"
	jsonTable["drain_humidity_control"] = 0
	jsonTable["replenish_humidity_control"] = 0
	jsonTable["supplementary_cooking"] = 0
	local b68 = megBodys[68 + 2 * (num - 1)]
	if b68 ~= nil then
		local clean_sink_ponding = getByteBit(b68, 0)
		if clean_sink_ponding == "1" then
			jsonTable["clean_sink_ponding"] = 1
		end
		local dissipate_heat = getByteBit(b68, 1)
		if dissipate_heat == "1" then
			jsonTable["dissipate_heat"] = "work"
		end
		local drain_humidity_control = getByteBit(b68, 4)
		if drain_humidity_control == "1" then
			jsonTable["drain_humidity_control"] = 1
		end
		local replenish_humidity_control = getByteBit(b68, 5)
		if replenish_humidity_control == "1" then
			jsonTable["replenish_humidity_control"] = 1
		end
		local supplementary_cooking = getByteBit(b68, 6)
		if supplementary_cooking == "1" then
			jsonTable["supplementary_cooking"] = 1
		end
	end
	jsonTable["camera_status"] = "off"
	jsonTable["image_shoot_status"] = "off"
	jsonTable["food_material_recognition"] = "off"
	jsonTable["food_maturity_recognition"] = "off"
	jsonTable["live_video_status"] = "off"
	jsonTable["video_record_status"] = "off"
	jsonTable["video_record_mode"] = "manual"
	jsonTable["camera_ota_status"] = "off"
	local b67 = megBodys[67 + 2 * (num - 1)]
	if b67 ~= nil then
		local cameraStatus = getByteBit(b67, 0)
		local imageShootStatus = getByteBit(b67, 1)
		local liveVideoStatus = getByteBit(b67, 2)
		local cameraOtaStatus = getByteBit(b67, 3)
		local videoRecordStatus = getByteBit(b67, 4)
		local foodMaturityRecognition = getByteBit(b67, 5)
		local foodMaterialRecognition = getByteBit(b67, 6)
		local videoRecordMode = getByteBit(b67, 7)
		if cameraStatus == "1" then
			jsonTable["camera_status"] = "on"
		end
		if imageShootStatus == "1" then
			jsonTable["image_shoot_status"] = "on"
		end
		if foodMaterialRecognition == "1" then
			jsonTable["food_material_recognition"] = "on"
		end
		if foodMaturityRecognition == "1" then
			jsonTable["food_maturity_recognition"] = "on"
		end
		if liveVideoStatus == "1" then
			jsonTable["live_video_status"] = "on"
		end
		if videoRecordStatus == "1" then
			jsonTable["video_record_status"] = "on"
		end
		if videoRecordMode == "1" then
			jsonTable["video_record_mode"] = "auto"
		end
		if cameraOtaStatus == "1" then
			jsonTable["camera_ota_status"] = "work"
		end
	end
	local b73 = megBodys[73 + 2 * (num - 1)]
	local b74 = megBodys[74 + 2 * (num - 1)]
	local b75 = megBodys[75 + 2 * (num - 1)]
	local b76 = megBodys[76 + 2 * (num - 1)]
	local b77 = megBodys[77 + 2 * (num - 1)]
	local b78 = megBodys[78 + 2 * (num - 1)]
	jsonTable["cook_id_timestamp"] = "ff"
	if
		b73 ~= nil
		and string.lower(b73) ~= "ff"
		and b74 ~= nil
		and string.lower(b74) ~= "ff"
		and b75 ~= nil
		and string.lower(b75) ~= "ff"
		and b76 ~= nil
		and string.lower(b76) ~= "ff"
		and b77 ~= nil
		and string.lower(b77) ~= "ff"
		and b78 ~= nil
		and string.lower(b78) ~= "ff"
	then
		local year = tonumber(b73, 16)
		if year < 10 then
			year = "200" .. year
		elseif year < 100 then
			year = "20" .. year
		end
		local month = tonumber(b74, 16)
		if month < 10 then
			month = "0" .. month
		end
		local day = tonumber(b75, 16)
		if day < 10 then
			day = "0" .. day
		end
		local hour = tonumber(b76, 16)
		if hour < 10 then
			hour = "0" .. hour
		end
		local minute = tonumber(b77, 16)
		if minute < 10 then
			minute = "0" .. minute
		end
		local second = tonumber(b78, 16)
		if second < 10 then
			second = "0" .. second
		end
		local timestamp = year .. month .. day .. hour .. minute .. second
		if timestamp == "20000000000000" then
			jsonTable["cook_id_timestamp"] = "ff"
		else
			jsonTable["cook_id_timestamp"] = timestamp
		end
	end
	if jsonTable["work_status"] == "save_power" or jsonTable["work_status"] == "standby" then
		jsonTable["cloudmenuid"] = 0
		jsonTable["totalstep"] = 0
		jsonTable["stepnum"] = 0
		jsonTable["hour_set"] = 0
		jsonTable["minute_set"] = 0
		jsonTable["second_set"] = 0
		jsonTable["temperature"] = 0
		jsonTable["temperature_above"] = 0
		jsonTable["temperature_underside"] = 0
		jsonTable["work_mode"] = "ff"
		jsonTable["fire_power"] = "ff"
		jsonTable["steam_quantity"] = 0
		jsonTable["mouthfeel"] = "ff"
		jsonTable["weight"] = 0
		jsonTable["people_number"] = 0
		jsonTable["pre_heat"] = "off"
		jsonTable["flip_side"] = 0
		jsonTable["spread_sauce"] = 0
		jsonTable["add_sauce"] = 0
		jsonTable["stir"] = 0
		jsonTable["drain_humidity_control"] = 0
		jsonTable["replenish_humidity_control"] = 0
		jsonTable["supplementary_cooking"] = 0
	end
end
local function cameraOta(jsonTable, megBodys)
	jsonTable["ota_status_hardware"] = "camera"
	local b13 = megBodys[13]
	local b14 = megBodys[14]
	local b15 = megBodys[15]
	jsonTable["camera_version"] = "V0.0.0"
	if b13 ~= nil and b14 ~= nil and b15 ~= nil then
		local camera_version = "V" .. tonumber(b13, 16) .. "." .. tonumber(b14, 16) .. "." .. tonumber(b15, 16)
		jsonTable["camera_version"] = camera_version
	end
	jsonTable["download_progress"] = tonumber(megBodys[20], 16)
	jsonTable["ota_status"] = "ff"
	if megBodys[22] == "01" then
		jsonTable["ota_status"] = "installing"
	elseif megBodys[22] == "02" then
		jsonTable["ota_status"] = "install_success"
	elseif megBodys[22] == "03" then
		jsonTable["ota_status"] = "install_failure"
	elseif megBodys[21] == "01" then
		jsonTable["ota_status"] = "downloading"
	elseif megBodys[21] == "02" then
		jsonTable["ota_status"] = "download_success"
	elseif megBodys[21] == "03" then
		jsonTable["ota_status"] = "download_failure"
	end
end
local function deviceToCloud(megBodys)
	local jsonTable = {}
	jsonTable["version"] = VALUE_VERSION
	jsonTable["report_type"] = megBodys[9]
	if megBodys[9] == "02" then
		totalState(jsonTable, megBodys)
	elseif megBodys[9] == "03" or megBodys[9] == "04" then
		if megBodys[10] == "01" then
			totalState(jsonTable, megBodys)
		elseif megBodys[10] == "65" and megBodys[11] == "00" and megBodys[12] == "02" then
			cameraOta(jsonTable, megBodys)
		end
	end
	return jsonTable
end
function dataToJson(jsonStr)
	if not jsonStr then
		return nil
	end
	local json = decodeJsonToTable(jsonStr)
	local binData = json["msg"]["data"]
	local status = json["status"]
	local retTable = {}
	retTable["status"] = {}
	local bodyBytes = hexToTable(binData)
	retTable["status"] = deviceToCloud(bodyBytes)
	local ret = encodeTableToJson(retTable)
	return ret
end
