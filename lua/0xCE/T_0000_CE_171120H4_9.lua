local bit = require("bit")
local uptable = {}
local JSON = require("cjson")
local KEY_VERSION = "version"
local VALUE_VERSION = "9"
uptable["VALUE_OFF"] = "off"
uptable["VALUE_ON"] = "on"
uptable["VALUE_MODE_COOL"] = "cool"
uptable["VALUE_MODE_HEAT"] = "heat"
uptable["VALUE_MODE_AUTO"] = "auto"
uptable["VALUE_MODE_FAN"] = "fan"
uptable["LEVEL1"] = "level_1"
uptable["LEVEL2"] = "level_2"
uptable["BYTE_DEVICE_TYPE"] = 0xCE
uptable["BYTE_CONTROL_REQUEST"] = 0x02
uptable["BYTE_QUERY_STATUS_REQUEST"] = 0x03
uptable["BYTE_PROTOCOL_HEAD"] = 0xAA
uptable["BYTE_PROTOCOL_LENGTH"] = 0x0A
uptable["BYTE_BIT0"] = 0x01
uptable["BYTE_BIT1"] = 0x02
uptable["BYTE_BIT2"] = 0x04
uptable["BYTE_BIT3"] = 0x08
uptable["BYTE_BIT4"] = 0x10
uptable["BYTE_BIT5"] = 0x20
uptable["BYTE_BIT6"] = 0x40
uptable["BYTE_BIT7"] = 0x80
local msgType
local msgSubType
local mytable = {
	["power"] = 0,
	["auto_set_fuction_state"] = 0,
	["silence_function_state"] = 0,
	["silence_function_level"] = 0,
	["mode"] = 2,
	["indoor_temperature_set"] = 24,
	["indoor_temperature"] = 22,
	["error_code"] = 0,
	["daytimer_timer1en"] = 0,
	["daytimer_timer2en"] = 0,
	["daytimer_timer3en"] = 0,
	["daytimer_timer4en"] = 0,
	["daytimer_timer5en"] = 0,
	["daytimer_timer1_temp"] = 0,
	["daytimer_timer1_openhour"] = 0,
	["daytimer_timer1_openmin"] = 0,
	["daytimer_timer1_closehour"] = 0,
	["daytimer_timer1_closemin"] = 0,
	["daytimer_timer2_temp"] = 0,
	["daytimer_timer2_openhour"] = 0,
	["daytimer_timer2_openmin"] = 0,
	["daytimer_timer2_closehour"] = 0,
	["daytimer_timer2_closemin"] = 0,
	["daytimer_timer3_temp"] = 0,
	["daytimer_timer3_openhour"] = 0,
	["daytimer_timer3_openmin"] = 0,
	["daytimer_timer3_closehour"] = 0,
	["daytimer_timer3_closemin"] = 0,
	["daytimer_timer4_temp"] = 0,
	["daytimer_timer4_openhour"] = 0,
	["daytimer_timer4_openmin"] = 0,
	["daytimer_timer4_closehour"] = 0,
	["daytimer_timer4_closemin"] = 0,
	["daytimer_timer5_temp"] = 0,
	["daytimer_timer5_openhour"] = 0,
	["daytimer_timer5_openmin"] = 0,
	["daytimer_timer5_closehour"] = 0,
	["daytimer_timer5_closemin"] = 0,
	["weektimer_setday"] = 1,
	["weektimer_timer1en"] = 0,
	["weektimer_timer2en"] = 0,
	["weektimer_timer3en"] = 0,
	["weektimer_timer4en"] = 0,
	["weektimer_timer5en"] = 0,
	["weektimer_timer1_temp"] = 0,
	["weektimer_timer1_openhour"] = 0,
	["weektimer_timer1_openmin"] = 0,
	["weektimer_timer1_closehour"] = 0,
	["weektimer_timer1_closemin"] = 0,
	["weektimer_timer2_temp"] = 0,
	["weektimer_timer2_openhour"] = 0,
	["weektimer_timer2_openmin"] = 0,
	["weektimer_timer2_closehour"] = 0,
	["weektimer_timer2_closemin"] = 0,
	["weektimer_timer3_temp"] = 0,
	["weektimer_timer3_openhour"] = 0,
	["weektimer_timer3_openmin"] = 0,
	["weektimer_timer3_closehour"] = 0,
	["weektimer_timer3_closemin"] = 0,
	["weektimer_timer4_temp"] = 0,
	["weektimer_timer4_openhour"] = 0,
	["weektimer_timer4_openmin"] = 0,
	["weektimer_timer4_closehour"] = 0,
	["weektimer_timer4_closemin"] = 0,
	["weektimer_timer5_temp"] = 0,
	["weektimer_timer5_openhour"] = 0,
	["weektimer_timer5_openmin"] = 0,
	["weektimer_timer5_closehour"] = 0,
	["weektimer_timer5_closemin"] = 0,
}
local function makeSum(tmpbuf, start_pos, end_pos)
	local resVal = 0
	for si = start_pos, end_pos do
		resVal = resVal + tmpbuf[si]
	end
	resVal = bit.bnot(resVal) + 1
	resVal = bit.band(resVal, 0x00ff)
	return resVal
end
local function binToModel(dataType, bodyLength, binData)
	local messageBytes = {}
	messageBytes = binData
	for i = 0, bodyLength - 1 do
		messageBytes[i] = binData[1 + i]
	end
	if
		(msgType == 0x02 and msgSubType == 0x01)
		or ((msgType == 0x03) and (msgSubType == 0x01))
		or (msgType == 0x04)
	then
		mytable["power"] = bit.band(messageBytes[0], 0x01)
		mytable["auto_set_fuction_state"] = bit.band(messageBytes[0], 0x02)
		mytable["silence_function_state"] = bit.band(messageBytes[0], 0x04)
		mytable["mode"] = messageBytes[1]
		mytable["silence_function_level"] = messageBytes[2]
		mytable["indoor_temperature_set"] = messageBytes[3]
		if messageBytes[4] >= 128 then
			mytable["indoor_temperature"] = -(256 - messageBytes[4])
		else
			mytable["indoor_temperature"] = messageBytes[4]
		end
		mytable["error_code"] = messageBytes[5]
		mytable["runmodeunderautocontrol"] = messageBytes[6]
	elseif (msgType == 0x03 or msgType == 0x02) and (msgSubType == 0x02) then
		mytable["daytimer_timer1en"] = bit.band(messageBytes[0], 0x01)
		mytable["daytimer_timer2en"] = bit.rshift(bit.band(messageBytes[0], 0x02), 1)
		mytable["daytimer_timer3en"] = bit.rshift(bit.band(messageBytes[0], 0x04), 2)
		mytable["daytimer_timer4en"] = bit.rshift(bit.band(messageBytes[0], 0x08), 3)
		mytable["daytimer_timer5en"] = bit.rshift(bit.band(messageBytes[0], 0x10), 4)
		mytable["daytimer_timer1_temp"] = messageBytes[1]
		mytable["daytimer_timer1_openhour"] = messageBytes[2]
		mytable["daytimer_timer1_openmin"] = messageBytes[3]
		mytable["daytimer_timer1_closehour"] = messageBytes[4]
		mytable["daytimer_timer1_closemin"] = messageBytes[5]
		mytable["daytimer_timer2_temp"] = messageBytes[6]
		mytable["daytimer_timer2_openhour"] = messageBytes[7]
		mytable["daytimer_timer2_openmin"] = messageBytes[8]
		mytable["daytimer_timer2_closehour"] = messageBytes[9]
		mytable["daytimer_timer2_closemin"] = messageBytes[10]
		mytable["daytimer_timer3_temp"] = messageBytes[11]
		mytable["daytimer_timer3_openhour"] = messageBytes[12]
		mytable["daytimer_timer3_openmin"] = messageBytes[13]
		mytable["daytimer_timer3_closehour"] = messageBytes[14]
		mytable["daytimer_timer3_closemin"] = messageBytes[15]
		mytable["daytimer_timer4_temp"] = messageBytes[16]
		mytable["daytimer_timer4_openhour"] = messageBytes[17]
		mytable["daytimer_timer4_openmin"] = messageBytes[18]
		mytable["daytimer_timer4_closehour"] = messageBytes[19]
		mytable["daytimer_timer4_closemin"] = messageBytes[20]
		mytable["daytimer_timer5_temp"] = messageBytes[21]
		mytable["daytimer_timer5_openhour"] = messageBytes[22]
		mytable["daytimer_timer5_openmin"] = messageBytes[23]
		mytable["daytimer_timer5_closehour"] = messageBytes[24]
		mytable["daytimer_timer5_closemin"] = messageBytes[25]
	elseif (msgType == 0x03 or msgType == 0x02) and (msgSubType == 0x03) then
		if bit.band(messageBytes[0], 0x01) == 0x01 then
			mytable["queryweekday"] = 1
		elseif bit.band(messageBytes[0], 0x02) == 0x02 then
			mytable["queryweekday"] = 2
		elseif bit.band(messageBytes[0], 0x04) == 0x04 then
			mytable["queryweekday"] = 3
		elseif bit.band(messageBytes[0], 0x08) == 0x08 then
			mytable["queryweekday"] = 4
		elseif bit.band(messageBytes[0], 0x10) == 0x10 then
			mytable["queryweekday"] = 5
		elseif bit.band(messageBytes[0], 0x20) == 0x20 then
			mytable["queryweekday"] = 6
		elseif bit.band(messageBytes[0], 0x40) == 0x40 then
			mytable["queryweekday"] = 7
		end
		mytable["weektimer_timer1en"] = bit.band(messageBytes[1], 0x01)
		mytable["weektimer_timer2en"] = bit.rshift(bit.band(messageBytes[1], 0x02), 1)
		mytable["weektimer_timer3en"] = bit.rshift(bit.band(messageBytes[1], 0x04), 2)
		mytable["weektimer_timer4en"] = bit.rshift(bit.band(messageBytes[1], 0x08), 3)
		mytable["weektimer_timer5en"] = bit.rshift(bit.band(messageBytes[1], 0x10), 4)
		mytable["weektimer_timer1_temp"] = messageBytes[2]
		mytable["weektimer_timer1_openhour"] = messageBytes[3]
		mytable["weektimer_timer1_openmin"] = messageBytes[4]
		mytable["weektimer_timer1_closehour"] = messageBytes[5]
		mytable["weektimer_timer1_closemin"] = messageBytes[6]
		mytable["weektimer_timer2_temp"] = messageBytes[7]
		mytable["weektimer_timer2_openhour"] = messageBytes[8]
		mytable["weektimer_timer2_openmin"] = messageBytes[9]
		mytable["weektimer_timer2_closehour"] = messageBytes[10]
		mytable["weektimer_timer2_closemin"] = messageBytes[11]
		mytable["weektimer_timer3_temp"] = messageBytes[12]
		mytable["weektimer_timer3_openhour"] = messageBytes[13]
		mytable["weektimer_timer3_openmin"] = messageBytes[14]
		mytable["weektimer_timer3_closehour"] = messageBytes[15]
		mytable["weektimer_timer3_closemin"] = messageBytes[16]
		mytable["weektimer_timer4_temp"] = messageBytes[17]
		mytable["weektimer_timer4_openhour"] = messageBytes[18]
		mytable["weektimer_timer4_openmin"] = messageBytes[19]
		mytable["weektimer_timer4_closehour"] = messageBytes[20]
		mytable["weektimer_timer4_closemin"] = messageBytes[21]
		mytable["weektimer_timer5_temp"] = messageBytes[22]
		mytable["weektimer_timer5_openhour"] = messageBytes[23]
		mytable["weektimer_timer5_openmin"] = messageBytes[24]
		mytable["weektimer_timer5_closehour"] = messageBytes[25]
		mytable["weektimer_timer5_closemin"] = messageBytes[26]
	end
end
local function getTotalMsg(bodyData, cType)
	local bodyLength = #bodyData
	local msgLength = bodyLength + uptable["BYTE_PROTOCOL_LENGTH"] + 1
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = uptable["BYTE_PROTOCOL_HEAD"]
	msgBytes[1] = bodyLength + uptable["BYTE_PROTOCOL_LENGTH"] + 1
	msgBytes[2] = uptable["BYTE_DEVICE_TYPE"]
	msgBytes[9] = cType
	for i = 0, bodyLength do
		msgBytes[i + uptable["BYTE_PROTOCOL_LENGTH"]] = bodyData[i]
	end
	msgBytes[msgLength] = makeSum(msgBytes, 1, msgLength - 1)
	local msgFinal = {}
	for i = 1, msgLength + 1 do
		msgFinal[i] = msgBytes[i - 1]
	end
	return msgFinal
end
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
local function checkBoundary(data, min, max)
	if not data then
		data = 0
	end
	data = tonumber(data)
	if data == nil then
		data = 0
	end
	if (data >= min) and (data <= max) then
		return data
	else
		if data < min then
			return min
		else
			return max
		end
	end
end
local function string2Int(data)
	if not data then
		data = tonumber("0")
	end
	data = tonumber(data)
	if data == nil then
		data = 0
	end
	return data
end
local function int2String(data)
	if not data then
		data = tostring(0)
	end
	data = tostring(data)
	if data == nil then
		data = "0"
	end
	return data
end
local function table2string(cmd)
	local ret = ""
	local i
	for i = 1, #cmd do
		ret = ret .. string.char(cmd[i])
	end
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
	for i = 1, #str do
		ret = ret .. string.format("%02x", str:byte(i))
	end
	return ret
end
local function encode(cmd)
	local tb
	if JSON == nil then
		JSON = require("cjson")
	end
	tb = JSON.encode(cmd)
	return tb
end
local function decode(cmd)
	local tb
	if JSON == nil then
		JSON = require("cjson")
	end
	tb = JSON.decode(cmd)
	return tb
end
local function jsonToModel(jsonCmd)
	local controlcmd = jsonCmd
	mytable["controltype"] = 0x01
	if controlcmd["control_type"] ~= nil then
		mytable["controltype"] = string2Int(controlcmd["control_type"])
	end
	if mytable["controltype"] == 0x01 then
		if controlcmd["power"] == uptable["VALUE_ON"] then
			mytable["power"] = uptable["BYTE_BIT0"]
		elseif controlcmd["power"] == uptable["VALUE_OFF"] then
			mytable["power"] = 0
		end
		if controlcmd["auto_set_fuction_state"] == uptable["VALUE_ON"] then
			mytable["auto_set_fuction_state"] = uptable["BYTE_BIT1"]
		elseif controlcmd["auto_set_fuction_state"] == uptable["VALUE_OFF"] then
			mytable["auto_set_fuction_state"] = 0
		end
		if controlcmd["silence_function_state"] == uptable["VALUE_ON"] then
			mytable["silence_function_state"] = uptable["BYTE_BIT2"]
		elseif controlcmd["silence_function_state"] == uptable["VALUE_OFF"] then
			mytable["silence_function_state"] = 0
		end
		if controlcmd["mode"] == uptable["VALUE_MODE_AUTO"] then
			mytable["mode"] = 4
		elseif controlcmd["mode"] == uptable["VALUE_MODE_COOL"] then
			mytable["mode"] = 1
		elseif controlcmd["mode"] == uptable["VALUE_MODE_HEAT"] then
			mytable["mode"] = 2
		elseif controlcmd["mode"] == uptable["VALUE_MODE_FAN"] then
			mytable["mode"] = 3
		end
		if controlcmd["silence_function_level"] ~= nil then
			if controlcmd["silence_function_level"] == uptable["LEVEL1"] then
				mytable["silence_function_level"] = 0
			else
				mytable["silence_function_level"] = 1
			end
		end
		if controlcmd["indoor_temperature_set"] ~= nil then
			mytable["indoor_temperature_set"] = string2Int(controlcmd["indoor_temperature_set"])
		end
	elseif mytable["controltype"] == 0x02 then
		if controlcmd["daytimer_timer1en"] == uptable["VALUE_ON"] then
			mytable["daytimer_timer1en"] = uptable["BYTE_BIT0"]
		elseif controlcmd["daytimer_timer1en"] == uptable["VALUE_OFF"] then
			mytable["daytimer_timer1en"] = 0
		end
		if controlcmd["daytimer_timer2en"] == uptable["VALUE_ON"] then
			mytable["daytimer_timer2en"] = uptable["BYTE_BIT1"]
		elseif controlcmd["daytimer_timer2en"] == uptable["VALUE_OFF"] then
			mytable["daytimer_timer2en"] = 0
		end
		if controlcmd["daytimer_timer3en"] == uptable["VALUE_ON"] then
			mytable["daytimer_timer3en"] = uptable["BYTE_BIT2"]
		elseif controlcmd["daytimer_timer3en"] == uptable["VALUE_OFF"] then
			mytable["daytimer_timer3en"] = 0
		end
		if controlcmd["daytimer_timer4en"] == uptable["VALUE_ON"] then
			mytable["daytimer_timer4en"] = uptable["BYTE_BIT3"]
		elseif controlcmd["daytimer_timer4en"] == uptable["VALUE_OFF"] then
			mytable["daytimer_timer4en"] = 0
		end
		if controlcmd["daytimer_timer5en"] == uptable["VALUE_ON"] then
			mytable["daytimer_timer5en"] = uptable["BYTE_BIT4"]
		elseif controlcmd["daytimer_timer5en"] == uptable["VALUE_OFF"] then
			mytable["daytimer_timer5en"] = 0
		end
		if controlcmd["daytimer_timer1_temp"] ~= nil then
			mytable["daytimer_timer1_temp"] = string2Int(controlcmd["daytimer_timer1_temp"])
		end
		if controlcmd["daytimer_timer1_openhour"] ~= nil then
			mytable["daytimer_timer1_openhour"] = string2Int(controlcmd["daytimer_timer1_openhour"])
		end
		if controlcmd["daytimer_timer1_openmin"] ~= nil then
			mytable["daytimer_timer1_openmin"] = string2Int(controlcmd["daytimer_timer1_openmin"])
		end
		if controlcmd["daytimer_timer1_closehour"] ~= nil then
			mytable["daytimer_timer1_closehour"] = string2Int(controlcmd["daytimer_timer1_closehour"])
		end
		if controlcmd["daytimer_timer1_closemin"] ~= nil then
			mytable["daytimer_timer1_closemin"] = string2Int(controlcmd["daytimer_timer1_closemin"])
		end
		if controlcmd["daytimer_timer2_temp"] ~= nil then
			mytable["daytimer_timer2_temp"] = string2Int(controlcmd["daytimer_timer2_temp"])
		end
		if controlcmd["daytimer_timer2_openhour"] ~= nil then
			mytable["daytimer_timer2_openhour"] = string2Int(controlcmd["daytimer_timer2_openhour"])
		end
		if controlcmd["daytimer_timer2_openmin"] ~= nil then
			mytable["daytimer_timer2_openmin"] = string2Int(controlcmd["daytimer_timer2_openmin"])
		end
		if controlcmd["daytimer_timer2_closehour"] ~= nil then
			mytable["daytimer_timer2_closehour"] = string2Int(controlcmd["daytimer_timer2_closehour"])
		end
		if controlcmd["daytimer_timer2_closemin"] ~= nil then
			mytable["daytimer_timer2_closemin"] = string2Int(controlcmd["daytimer_timer2_closemin"])
		end
		if controlcmd["daytimer_timer3_temp"] ~= nil then
			mytable["daytimer_timer3_temp"] = string2Int(controlcmd["daytimer_timer3_temp"])
		end
		if controlcmd["daytimer_timer3_openhour"] ~= nil then
			mytable["daytimer_timer3_openhour"] = string2Int(controlcmd["daytimer_timer3_openhour"])
		end
		if controlcmd["daytimer_timer3_openmin"] ~= nil then
			mytable["daytimer_timer3_openmin"] = string2Int(controlcmd["daytimer_timer3_openmin"])
		end
		if controlcmd["daytimer_timer3_closehour"] ~= nil then
			mytable["daytimer_timer3_closehour"] = string2Int(controlcmd["daytimer_timer3_closehour"])
		end
		if controlcmd["daytimer_timer3_closemin"] ~= nil then
			mytable["daytimer_timer3_closemin"] = string2Int(controlcmd["daytimer_timer3_closemin"])
		end
		if controlcmd["daytimer_timer4_temp"] ~= nil then
			mytable["daytimer_timer4_temp"] = string2Int(controlcmd["daytimer_timer4_temp"])
		end
		if controlcmd["daytimer_timer4_openhour"] ~= nil then
			mytable["daytimer_timer4_openhour"] = string2Int(controlcmd["daytimer_timer4_openhour"])
		end
		if controlcmd["daytimer_timer4_openmin"] ~= nil then
			mytable["daytimer_timer4_openmin"] = string2Int(controlcmd["daytimer_timer4_openmin"])
		end
		if controlcmd["daytimer_timer4_closehour"] ~= nil then
			mytable["daytimer_timer4_closehour"] = string2Int(controlcmd["daytimer_timer4_closehour"])
		end
		if controlcmd["daytimer_timer4_closemin"] ~= nil then
			mytable["daytimer_timer4_closemin"] = string2Int(controlcmd["daytimer_timer4_closemin"])
		end
		if controlcmd["daytimer_timer5_temp"] ~= nil then
			mytable["daytimer_timer5_temp"] = string2Int(controlcmd["daytimer_timer5_temp"])
		end
		if controlcmd["daytimer_timer5_openhour"] ~= nil then
			mytable["daytimer_timer5_openhour"] = string2Int(controlcmd["daytimer_timer5_openhour"])
		end
		if controlcmd["daytimer_timer5_openmin"] ~= nil then
			mytable["daytimer_timer5_openmin"] = string2Int(controlcmd["daytimer_timer5_openmin"])
		end
		if controlcmd["daytimer_timer5_closehour"] ~= nil then
			mytable["daytimer_timer5_closehour"] = string2Int(controlcmd["daytimer_timer5_closehour"])
		end
		if controlcmd["daytimer_timer5_closemin"] ~= nil then
			mytable["daytimer_timer5_closemin"] = string2Int(controlcmd["daytimer_timer5_closemin"])
		end
	elseif mytable["controltype"] == 0x03 then
		if controlcmd["weektimer_setday"] ~= nil then
			mytable["weektimer_setday"] = string2Int(controlcmd["weektimer_setday"])
			if (mytable["weektimer_setday"] > 0) and (mytable["weektimer_setday"] < 8) then
				mytable["weektimer_setday"] = mytable["weektimer_setday"] - 1
			else
				mytable["weektimer_setday"] = 7
			end
		end
		if controlcmd["weektimer_timer1en"] == uptable["VALUE_ON"] then
			mytable["weektimer_timer1en"] = uptable["BYTE_BIT0"]
		elseif controlcmd["weektimer_timer1en"] == uptable["VALUE_OFF"] then
			mytable["weektimer_timer1en"] = 0
		end
		if controlcmd["weektimer_timer2en"] == uptable["VALUE_ON"] then
			mytable["weektimer_timer2en"] = uptable["BYTE_BIT1"]
		elseif controlcmd["weektimer_timer2en"] == uptable["VALUE_OFF"] then
			mytable["weektimer_timer2en"] = 0
		end
		if controlcmd["weektimer_timer3en"] == uptable["VALUE_ON"] then
			mytable["weektimer_timer3en"] = uptable["BYTE_BIT2"]
		elseif controlcmd["weektimer_timer3en"] == uptable["VALUE_OFF"] then
			mytable["weektimer_timer3en"] = 0
		end
		if controlcmd["weektimer_timer4en"] == uptable["VALUE_ON"] then
			mytable["weektimer_timer4en"] = uptable["BYTE_BIT3"]
		elseif controlcmd["weektimer_timer4en"] == uptable["VALUE_OFF"] then
			mytable["weektimer_timer4en"] = 0
		end
		if controlcmd["weektimer_timer5en"] == uptable["VALUE_ON"] then
			mytable["weektimer_timer5en"] = uptable["BYTE_BIT4"]
		elseif controlcmd["weektimer_timer5en"] == uptable["VALUE_OFF"] then
			mytable["weektimer_timer5en"] = 0
		end
		if controlcmd["weektimer_timer1_temp"] ~= nil then
			mytable["weektimer_timer1_temp"] = string2Int(controlcmd["weektimer_timer1_temp"])
		end
		if controlcmd["weektimer_timer1_openhour"] ~= nil then
			mytable["weektimer_timer1_openhour"] = string2Int(controlcmd["weektimer_timer1_openhour"])
		end
		if controlcmd["weektimer_timer1_openmin"] ~= nil then
			mytable["weektimer_timer1_openmin"] = string2Int(controlcmd["weektimer_timer1_openmin"])
		end
		if controlcmd["weektimer_timer1_closehour"] ~= nil then
			mytable["weektimer_timer1_closehour"] = string2Int(controlcmd["weektimer_timer1_closehour"])
		end
		if controlcmd["weektimer_timer1_closemin"] ~= nil then
			mytable["weektimer_timer1_closemin"] = string2Int(controlcmd["weektimer_timer1_closemin"])
		end
		if controlcmd["weektimer_timer2_temp"] ~= nil then
			mytable["weektimer_timer2_temp"] = string2Int(controlcmd["weektimer_timer2_temp"])
		end
		if controlcmd["weektimer_timer2_openhour"] ~= nil then
			mytable["weektimer_timer2_openhour"] = string2Int(controlcmd["weektimer_timer2_openhour"])
		end
		if controlcmd["weektimer_timer2_openmin"] ~= nil then
			mytable["weektimer_timer2_openmin"] = string2Int(controlcmd["weektimer_timer2_openmin"])
		end
		if controlcmd["weektimer_timer2_closehour"] ~= nil then
			mytable["weektimer_timer2_closehour"] = string2Int(controlcmd["weektimer_timer2_closehour"])
		end
		if controlcmd["weektimer_timer2_closemin"] ~= nil then
			mytable["weektimer_timer2_closemin"] = string2Int(controlcmd["weektimer_timer2_closemin"])
		end
		if controlcmd["weektimer_timer3_temp"] ~= nil then
			mytable["weektimer_timer3_temp"] = string2Int(controlcmd["weektimer_timer3_temp"])
		end
		if controlcmd["weektimer_timer3_openhour"] ~= nil then
			mytable["weektimer_timer3_openhour"] = string2Int(controlcmd["weektimer_timer3_openhour"])
		end
		if controlcmd["weektimer_timer3_openmin"] ~= nil then
			mytable["weektimer_timer3_openmin"] = string2Int(controlcmd["weektimer_timer3_openmin"])
		end
		if controlcmd["weektimer_timer3_closehour"] ~= nil then
			mytable["weektimer_timer3_closehour"] = string2Int(controlcmd["weektimer_timer3_closehour"])
		end
		if controlcmd["weektimer_timer3_closemin"] ~= nil then
			mytable["weektimer_timer3_closemin"] = string2Int(controlcmd["weektimer_timer3_closemin"])
		end
		if controlcmd["weektimer_timer4_temp"] ~= nil then
			mytable["weektimer_timer4_temp"] = string2Int(controlcmd["weektimer_timer4_temp"])
		end
		if controlcmd["weektimer_timer4_openhour"] ~= nil then
			mytable["weektimer_timer4_openhour"] = string2Int(controlcmd["weektimer_timer4_openhour"])
		end
		if controlcmd["weektimer_timer4_openmin"] ~= nil then
			mytable["weektimer_timer4_openmin"] = string2Int(controlcmd["weektimer_timer4_openmin"])
		end
		if controlcmd["weektimer_timer4_closehour"] ~= nil then
			mytable["weektimer_timer4_closehour"] = string2Int(controlcmd["weektimer_timer4_closehour"])
		end
		if controlcmd["weektimer_timer4_closemin"] ~= nil then
			mytable["weektimer_timer4_closemin"] = string2Int(controlcmd["weektimer_timer4_closemin"])
		end
		if controlcmd["weektimer_timer5_temp"] ~= nil then
			mytable["weektimer_timer5_temp"] = string2Int(controlcmd["weektimer_timer5_temp"])
		end
		if controlcmd["weektimer_timer5_openhour"] ~= nil then
			mytable["weektimer_timer5_openhour"] = string2Int(controlcmd["weektimer_timer5_openhour"])
		end
		if controlcmd["weektimer_timer5_openmin"] ~= nil then
			mytable["weektimer_timer5_openmin"] = string2Int(controlcmd["weektimer_timer5_openmin"])
		end
		if controlcmd["weektimer_timer5_closehour"] ~= nil then
			mytable["weektimer_timer5_closehour"] = string2Int(controlcmd["weektimer_timer5_closehour"])
		end
		if controlcmd["weektimer_timer5_closemin"] ~= nil then
			mytable["weektimer_timer5_closemin"] = string2Int(controlcmd["weektimer_timer5_closemin"])
		end
	end
end
function jsonToData(jsonCmd)
	if #jsonCmd == 0 then
		return nil
	end
	local infoM = {}
	local bodyBytes = {}
	local json = decode(jsonCmd)
	local deviceSubType = json["deviceinfo"]["deviceSubType"]
	if deviceSubType == 1 then
	end
	local query = json["query"]
	local control = json["control"]
	local status = json["status"]
	if query then
		mytable["queryType"] = 0x01
		if query["query_type"] ~= nil then
			mytable["queryType"] = string2Int(query["query_type"])
		end
		mytable["weekdayquery"] = 0x01
		if query["weekday_query"] ~= nil then
			mytable["weekdayquery"] = string2Int(query["weekday_query"])
		end
		if mytable["queryType"] == 0x01 then
			bodyBytes[0] = 0x01
		elseif mytable["queryType"] == 0x02 then
			bodyBytes[0] = 0x02
		elseif mytable["queryType"] == 0x03 then
			bodyBytes[0] = 0x03
			if mytable["weekdayquery"] == 0x01 then
				bodyBytes[1] = uptable["BYTE_BIT0"]
			elseif mytable["weekdayquery"] == 0x02 then
				bodyBytes[1] = uptable["BYTE_BIT1"]
			elseif mytable["weekdayquery"] == 0x03 then
				bodyBytes[1] = uptable["BYTE_BIT2"]
			elseif mytable["weekdayquery"] == 0x04 then
				bodyBytes[1] = uptable["BYTE_BIT3"]
			elseif mytable["weekdayquery"] == 0x05 then
				bodyBytes[1] = uptable["BYTE_BIT4"]
			elseif mytable["weekdayquery"] == 0x06 then
				bodyBytes[1] = uptable["BYTE_BIT5"]
			elseif mytable["weekdayquery"] == 0x07 then
				bodyBytes[1] = uptable["BYTE_BIT6"]
			end
		end
		infoM = getTotalMsg(bodyBytes, uptable["BYTE_QUERY_STATUS_REQUEST"])
	elseif control then
		if status then
			jsonToModel(status)
		end
		if control then
			jsonToModel(control)
		end
		for i = 0, 4 do
			bodyBytes[i] = 0
		end
		if mytable["controltype"] == 0x01 then
			bodyBytes[0] = 0x01
			bodyBytes[1] =
				bit.bor(bit.bor(mytable["power"], mytable["auto_set_fuction_state"]), mytable["silence_function_state"])
			bodyBytes[2] = mytable["mode"]
			bodyBytes[3] = mytable["silence_function_level"]
			bodyBytes[4] = mytable["indoor_temperature_set"]
		elseif mytable["controltype"] == 0x02 then
			bodyBytes[0] = 0x02
			bodyBytes[1] = bit.bor(
				bit.bor(
					bit.bor(
						bit.bor(mytable["daytimer_timer1en"], mytable["daytimer_timer2en"]),
						mytable["daytimer_timer3en"]
					),
					mytable["daytimer_timer4en"]
				),
				mytable["daytimer_timer5en"]
			)
			bodyBytes[2] = mytable["daytimer_timer1_temp"]
			bodyBytes[3] = mytable["daytimer_timer1_openhour"]
			bodyBytes[4] = mytable["daytimer_timer1_openmin"]
			bodyBytes[5] = mytable["daytimer_timer1_closehour"]
			bodyBytes[6] = mytable["daytimer_timer1_closemin"]
			bodyBytes[7] = mytable["daytimer_timer2_temp"]
			bodyBytes[8] = mytable["daytimer_timer2_openhour"]
			bodyBytes[9] = mytable["daytimer_timer2_openmin"]
			bodyBytes[10] = mytable["daytimer_timer2_closehour"]
			bodyBytes[11] = mytable["daytimer_timer2_closemin"]
			bodyBytes[12] = mytable["daytimer_timer3_temp"]
			bodyBytes[13] = mytable["daytimer_timer3_openhour"]
			bodyBytes[14] = mytable["daytimer_timer3_openmin"]
			bodyBytes[15] = mytable["daytimer_timer3_closehour"]
			bodyBytes[16] = mytable["daytimer_timer3_closemin"]
			bodyBytes[17] = mytable["daytimer_timer4_temp"]
			bodyBytes[18] = mytable["daytimer_timer4_openhour"]
			bodyBytes[19] = mytable["daytimer_timer4_openmin"]
			bodyBytes[20] = mytable["daytimer_timer4_closehour"]
			bodyBytes[21] = mytable["daytimer_timer4_closemin"]
			bodyBytes[22] = mytable["daytimer_timer5_temp"]
			bodyBytes[23] = mytable["daytimer_timer5_openhour"]
			bodyBytes[24] = mytable["daytimer_timer5_openmin"]
			bodyBytes[25] = mytable["daytimer_timer5_closehour"]
			bodyBytes[26] = mytable["daytimer_timer5_closemin"]
		elseif mytable["controltype"] == 0x03 then
			bodyBytes[0] = 0x03
			bodyBytes[1] = bit.lshift(1, mytable["weektimer_setday"])
			bodyBytes[2] = bit.bor(
				bit.bor(
					bit.bor(
						bit.bor(mytable["weektimer_timer1en"], mytable["weektimer_timer2en"]),
						mytable["weektimer_timer3en"]
					),
					mytable["weektimer_timer4en"]
				),
				mytable["weektimer_timer5en"]
			)
			bodyBytes[3] = mytable["weektimer_timer1_temp"]
			bodyBytes[4] = mytable["weektimer_timer1_openhour"]
			bodyBytes[5] = mytable["weektimer_timer1_openmin"]
			bodyBytes[6] = mytable["weektimer_timer1_closehour"]
			bodyBytes[7] = mytable["weektimer_timer1_closemin"]
			bodyBytes[8] = mytable["weektimer_timer2_temp"]
			bodyBytes[9] = mytable["weektimer_timer2_openhour"]
			bodyBytes[10] = mytable["weektimer_timer2_openmin"]
			bodyBytes[11] = mytable["weektimer_timer2_closehour"]
			bodyBytes[12] = mytable["weektimer_timer2_closemin"]
			bodyBytes[13] = mytable["weektimer_timer3_temp"]
			bodyBytes[14] = mytable["weektimer_timer3_openhour"]
			bodyBytes[15] = mytable["weektimer_timer3_openmin"]
			bodyBytes[16] = mytable["weektimer_timer3_closehour"]
			bodyBytes[17] = mytable["weektimer_timer3_closemin"]
			bodyBytes[18] = mytable["weektimer_timer4_temp"]
			bodyBytes[19] = mytable["weektimer_timer4_openhour"]
			bodyBytes[20] = mytable["weektimer_timer4_openmin"]
			bodyBytes[21] = mytable["weektimer_timer4_closehour"]
			bodyBytes[22] = mytable["weektimer_timer4_closemin"]
			bodyBytes[23] = mytable["weektimer_timer5_temp"]
			bodyBytes[24] = mytable["weektimer_timer5_openhour"]
			bodyBytes[25] = mytable["weektimer_timer5_openmin"]
			bodyBytes[26] = mytable["weektimer_timer5_closehour"]
			bodyBytes[27] = mytable["weektimer_timer5_closemin"]
		end
		infoM = getTotalMsg(bodyBytes, uptable["BYTE_CONTROL_REQUEST"])
	end
	local ret = table2string(infoM)
	ret = string2hexstring(ret)
	return ret
end
function dataToJson(jsonCmd)
	if not jsonCmd then
		return nil
	end
	local json = decode(jsonCmd)
	local deviceinfo = json["deviceinfo"]
	local deviceSubType = deviceinfo["deviceSubtype"]
	if deviceSubType == 1 then
	end
	local status = json["status"]
	if status then
		jsonToModel(status)
	end
	local binData = json["msg"]["data"]
	local info = {}
	local msgBytes = { 0 }
	local bodyBytes = {}
	local msgLength = 0
	local bodyLength = 0
	info = string2table(binData)
	dataType = info[10]
	for i = 1, #info do
		msgBytes[i - 1] = info[i]
	end
	msgLength = msgBytes[1]
	bodyLength = msgLength - uptable["BYTE_PROTOCOL_LENGTH"] - 1
	msgType = msgBytes[9]
	msgSubType = msgBytes[10]
	for i = 0, bodyLength do
		bodyBytes[i] = msgBytes[i + uptable["BYTE_PROTOCOL_LENGTH"]]
	end
	binToModel(dataType, bodyLength, bodyBytes)
	local streams = {}
	streams[KEY_VERSION] = VALUE_VERSION
	if
		(msgType == 0x02 and msgSubType == 0x01)
		or ((msgType == 0x03) and (msgSubType == 0x01))
		or (msgType == 0x04)
	then
		if mytable["power"] == uptable["BYTE_BIT0"] then
			streams["power"] = uptable["VALUE_ON"]
		else
			streams["power"] = uptable["VALUE_OFF"]
		end
		if mytable["auto_set_fuction_state"] == uptable["BYTE_BIT1"] then
			streams["auto_set_fuction_state"] = uptable["VALUE_ON"]
		else
			streams["auto_set_fuction_state"] = uptable["VALUE_OFF"]
		end
		if mytable["silence_function_state"] == uptable["BYTE_BIT2"] then
			streams["silence_function_state"] = uptable["VALUE_ON"]
		else
			streams["silence_function_state"] = uptable["VALUE_OFF"]
		end
		if mytable["mode"] == 1 then
			streams["mode"] = uptable["VALUE_MODE_COOL"]
		elseif mytable["mode"] == 2 then
			streams["mode"] = uptable["VALUE_MODE_HEAT"]
		elseif mytable["mode"] == 3 then
			streams["mode"] = uptable["VALUE_MODE_FAN"]
		elseif mytable["mode"] == 4 then
			streams["mode"] = uptable["VALUE_MODE_AUTO"]
		end
		if mytable["silence_function_level"] == 0x00 then
			streams["silence_function_level"] = uptable["LEVEL1"]
		elseif mytable["silence_function_level"] == 0x01 then
			streams["silence_function_level"] = uptable["LEVEL2"]
		end
		streams["indoor_temperature_set"] = int2String(mytable["indoor_temperature_set"])
		streams["indoor_temperature"] = int2String(mytable["indoor_temperature"])
		streams["error_code"] = int2String(mytable["error_code"])
		streams["runmodeunderautocontrol"] = int2String(mytable["runmodeunderautocontrol"])
	elseif (msgType == 0x02 and msgSubType == 0x02) or (msgType == 0x03 and msgSubType == 0x02) then
		if mytable["daytimer_timer1en"] == 0x01 then
			streams["daytimer_timer1en"] = uptable["VALUE_ON"]
		else
			streams["daytimer_timer1en"] = uptable["VALUE_OFF"]
		end
		if mytable["daytimer_timer2en"] == 0x01 then
			streams["daytimer_timer2en"] = uptable["VALUE_ON"]
		else
			streams["daytimer_timer2en"] = uptable["VALUE_OFF"]
		end
		if mytable["daytimer_timer3en"] == 0x01 then
			streams["daytimer_timer3en"] = uptable["VALUE_ON"]
		else
			streams["daytimer_timer3en"] = uptable["VALUE_OFF"]
		end
		if mytable["daytimer_timer4en"] == 0x01 then
			streams["daytimer_timer4en"] = uptable["VALUE_ON"]
		else
			streams["daytimer_timer4en"] = uptable["VALUE_OFF"]
		end
		if mytable["daytimer_timer5en"] == 0x01 then
			streams["daytimer_timer5en"] = uptable["VALUE_ON"]
		else
			streams["daytimer_timer5en"] = uptable["VALUE_OFF"]
		end
		streams["daytimer_timer1_temp"] = int2String(mytable["daytimer_timer1_temp"])
		streams["daytimer_timer1_openhour"] = int2String(mytable["daytimer_timer1_openhour"])
		streams["daytimer_timer1_openmin"] = int2String(mytable["daytimer_timer1_openmin"])
		streams["daytimer_timer1_closehour"] = int2String(mytable["daytimer_timer1_closehour"])
		streams["daytimer_timer1_closemin"] = int2String(mytable["daytimer_timer1_closemin"])
		streams["daytimer_timer2_temp"] = int2String(mytable["daytimer_timer2_temp"])
		streams["daytimer_timer2_openhour"] = int2String(mytable["daytimer_timer2_openhour"])
		streams["daytimer_timer2_openmin"] = int2String(mytable["daytimer_timer2_openmin"])
		streams["daytimer_timer2_closehour"] = int2String(mytable["daytimer_timer2_closehour"])
		streams["daytimer_timer2_closemin"] = int2String(mytable["daytimer_timer2_closemin"])
		streams["daytimer_timer3_temp"] = int2String(mytable["daytimer_timer3_temp"])
		streams["daytimer_timer3_openhour"] = int2String(mytable["daytimer_timer3_openhour"])
		streams["daytimer_timer3_openmin"] = int2String(mytable["daytimer_timer3_openmin"])
		streams["daytimer_timer3_closehour"] = int2String(mytable["daytimer_timer3_closehour"])
		streams["daytimer_timer3_closemin"] = int2String(mytable["daytimer_timer3_closemin"])
		streams["daytimer_timer4_temp"] = int2String(mytable["daytimer_timer4_temp"])
		streams["daytimer_timer4_openhour"] = int2String(mytable["daytimer_timer4_openhour"])
		streams["daytimer_timer4_openmin"] = int2String(mytable["daytimer_timer4_openmin"])
		streams["daytimer_timer4_closehour"] = int2String(mytable["daytimer_timer4_closehour"])
		streams["daytimer_timer4_closemin"] = int2String(mytable["daytimer_timer4_closemin"])
		streams["daytimer_timer5_temp"] = int2String(mytable["daytimer_timer5_temp"])
		streams["daytimer_timer5_openhour"] = int2String(mytable["daytimer_timer5_openhour"])
		streams["daytimer_timer5_openmin"] = int2String(mytable["daytimer_timer5_openmin"])
		streams["daytimer_timer5_closehour"] = int2String(mytable["daytimer_timer5_closehour"])
		streams["daytimer_timer5_closemin"] = int2String(mytable["daytimer_timer5_closemin"])
	elseif (msgType == 0x02 and msgSubType == 0x03) or (msgType == 0x03 and msgSubType == 0x03) then
		streams["queryweekday"] = int2String(mytable["queryweekday"])
		if mytable["weektimer_timer1en"] == 0x01 then
			streams["weektimer_timer1en"] = uptable["VALUE_ON"]
		else
			streams["weektimer_timer1en"] = uptable["VALUE_OFF"]
		end
		if mytable["weektimer_timer2en"] == 0x01 then
			streams["weektimer_timer2en"] = uptable["VALUE_ON"]
		else
			streams["weektimer_timer2en"] = uptable["VALUE_OFF"]
		end
		if mytable["weektimer_timer3en"] == 0x01 then
			streams["weektimer_timer3en"] = uptable["VALUE_ON"]
		else
			streams["weektimer_timer3en"] = uptable["VALUE_OFF"]
		end
		if mytable["weektimer_timer4en"] == 0x01 then
			streams["weektimer_timer4en"] = uptable["VALUE_ON"]
		else
			streams["weektimer_timer4en"] = uptable["VALUE_OFF"]
		end
		if mytable["weektimer_timer5en"] == 0x01 then
			streams["weektimer_timer5en"] = uptable["VALUE_ON"]
		else
			streams["weektimer_timer5en"] = uptable["VALUE_OFF"]
		end
		streams["weektimer_timer1_temp"] = int2String(mytable["weektimer_timer1_temp"])
		streams["weektimer_timer1_openhour"] = int2String(mytable["weektimer_timer1_openhour"])
		streams["weektimer_timer1_openmin"] = int2String(mytable["weektimer_timer1_openmin"])
		streams["weektimer_timer1_closehour"] = int2String(mytable["weektimer_timer1_closehour"])
		streams["weektimer_timer1_closemin"] = int2String(mytable["weektimer_timer1_closemin"])
		streams["weektimer_timer2_temp"] = int2String(mytable["weektimer_timer2_temp"])
		streams["weektimer_timer2_openhour"] = int2String(mytable["weektimer_timer2_openhour"])
		streams["weektimer_timer2_openmin"] = int2String(mytable["weektimer_timer2_openmin"])
		streams["weektimer_timer2_closehour"] = int2String(mytable["weektimer_timer2_closehour"])
		streams["weektimer_timer2_closemin"] = int2String(mytable["weektimer_timer2_closemin"])
		streams["weektimer_timer3_temp"] = int2String(mytable["weektimer_timer3_temp"])
		streams["weektimer_timer3_openhour"] = int2String(mytable["weektimer_timer3_openhour"])
		streams["weektimer_timer3_openmin"] = int2String(mytable["weektimer_timer3_openmin"])
		streams["weektimer_timer3_closehour"] = int2String(mytable["weektimer_timer3_closehour"])
		streams["weektimer_timer3_closemin"] = int2String(mytable["weektimer_timer3_closemin"])
		streams["weektimer_timer4_temp"] = int2String(mytable["weektimer_timer4_temp"])
		streams["weektimer_timer4_openhour"] = int2String(mytable["weektimer_timer4_openhour"])
		streams["weektimer_timer4_openmin"] = int2String(mytable["weektimer_timer4_openmin"])
		streams["weektimer_timer4_closehour"] = int2String(mytable["weektimer_timer4_closehour"])
		streams["weektimer_timer4_closemin"] = int2String(mytable["weektimer_timer4_closemin"])
		streams["weektimer_timer5_temp"] = int2String(mytable["weektimer_timer5_temp"])
		streams["weektimer_timer5_openhour"] = int2String(mytable["weektimer_timer5_openhour"])
		streams["weektimer_timer5_openmin"] = int2String(mytable["weektimer_timer5_openmin"])
		streams["weektimer_timer5_closehour"] = int2String(mytable["weektimer_timer5_closehour"])
		streams["weektimer_timer5_closemin"] = int2String(mytable["weektimer_timer5_closemin"])
	end
	local retTable = {}
	retTable["status"] = streams
	local ret = encode(retTable)
	return ret
end
local crc8_854_table = {
	0,
	94,
	188,
	226,
	97,
	63,
	221,
	131,
	194,
	156,
	126,
	32,
	163,
	253,
	31,
	65,
	157,
	195,
	33,
	127,
	252,
	162,
	64,
	30,
	95,
	1,
	227,
	189,
	62,
	96,
	130,
	220,
	35,
	125,
	159,
	193,
	66,
	28,
	254,
	160,
	225,
	191,
	93,
	3,
	128,
	222,
	60,
	98,
	190,
	224,
	2,
	92,
	223,
	129,
	99,
	61,
	124,
	34,
	192,
	158,
	29,
	67,
	161,
	255,
	70,
	24,
	250,
	164,
	39,
	121,
	155,
	197,
	132,
	218,
	56,
	102,
	229,
	187,
	89,
	7,
	219,
	133,
	103,
	57,
	186,
	228,
	6,
	88,
	25,
	71,
	165,
	251,
	120,
	38,
	196,
	154,
	101,
	59,
	217,
	135,
	4,
	90,
	184,
	230,
	167,
	249,
	27,
	69,
	198,
	152,
	122,
	36,
	248,
	166,
	68,
	26,
	153,
	199,
	37,
	123,
	58,
	100,
	134,
	216,
	91,
	5,
	231,
	185,
	140,
	210,
	48,
	110,
	237,
	179,
	81,
	15,
	78,
	16,
	242,
	172,
	47,
	113,
	147,
	205,
	17,
	79,
	173,
	243,
	112,
	46,
	204,
	146,
	211,
	141,
	111,
	49,
	178,
	236,
	14,
	80,
	175,
	241,
	19,
	77,
	206,
	144,
	114,
	44,
	109,
	51,
	209,
	143,
	12,
	82,
	176,
	238,
	50,
	108,
	142,
	208,
	83,
	13,
	239,
	177,
	240,
	174,
	76,
	18,
	145,
	207,
	45,
	115,
	202,
	148,
	118,
	40,
	171,
	245,
	23,
	73,
	8,
	86,
	180,
	234,
	105,
	55,
	213,
	139,
	87,
	9,
	235,
	181,
	54,
	104,
	138,
	212,
	149,
	203,
	41,
	119,
	244,
	170,
	72,
	22,
	233,
	183,
	85,
	11,
	136,
	214,
	52,
	106,
	43,
	117,
	151,
	201,
	74,
	20,
	246,
	168,
	116,
	42,
	200,
	150,
	21,
	75,
	169,
	247,
	182,
	232,
	10,
	84,
	215,
	137,
	107,
	53,
}
local function crc8_854(dataBuf, start_pos, end_pos)
	local crc = 0
	for si = start_pos, end_pos do
		crc = crc8_854_table[bit.band(bit.bxor(crc, dataBuf[si]), 0xFF) + 1]
	end
	return crc
end
