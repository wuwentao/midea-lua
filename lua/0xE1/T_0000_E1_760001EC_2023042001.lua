local bit = require("bit")
local uptable = {}
uptable["VALUE_VERSION"] = 10
----洗碗机协议解析  明承祥/20221130
---- 1. 新增控制授权：wifi_unabled

local JSON = require("cjson")

--------------------**共性函数前移**------------------------
--按位与运算 bit_band
local function bit_band(a, b)
	--再本地调试时，改成false;上传到云端之前，改成true
	local cloud_bl = true
	local ret
	if cloud_bl then
		--美居不能用bit32，本地不能用bit
		ret = bit.band(a, b)
	else
		--美居不能用bit32，本地不能用bit
		ret = bit32.band(a, b)
	end
	return ret
end

--sum校验
local function makeSum(tmpbuf, start_pos, end_pos)
	local resVal = 0
	for si = start_pos, end_pos do
		resVal = resVal + tmpbuf[si]
	end
	resVal = bit.bnot(resVal) + 1
	resVal = bit.band(resVal, 0x00ff)
	return resVal
end

--CRC表
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

--CRC校验
local function crc8_854(dataBuf, start_pos, end_pos)
	local crc = 0
	for si = start_pos, end_pos do
		crc = crc8_854_table[bit_band(bit.bxor(crc, dataBuf[si]), 0xFF) + 1]
	end
	return crc
end

--将json字符串转换为 lua中的table
local function decodeJsonToTable(cmd)
	local tb
	if JSON == nil then
		JSON = require("cjson")
	end
	tb = JSON.decode(cmd)
	return tb
end

--将lua中的table 转换为json字符串
local function encodeTableToJson(luaTable)
	local jsonStr
	if JSON == nil then
		JSON = require("cjson")
	end
	jsonStr = JSON.encode(luaTable)
	return jsonStr
end

--十六进制 string 转 table
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

--十六进制 string 输出
local function string2hexstring(str)
	local ret = ""
	for i = 1, #str do
		ret = ret .. string.format("%02x", str:byte(i))
	end
	return ret
end
local function table2hex(cmd)
	local ret = ""
	for i = 1, #cmd do
		ret = ret .. string.format("%02x", cmd[i])
	end
	return ret
end
--table 转 string
local function table2string(cmd)
	local ret = ""
	local i
	for i = 1, #cmd do
		ret = ret .. string.char(cmd[i])
	end
	return ret
end

local function split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

--检查data的值是否超过边界
local function checkBoundary(data, min, max)
	if not data then
		data = 0
	end
	data = tonumber(data)
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

--打印 table 表
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

-----------------JSON相关key值变量-----------------
--版本号"version"
--工作状态"work_status" = "work_status"
--工作模式"mode" = "mode"
--童锁"lock" = "lock"
--剩余时间"left_time" = "left_time"
--操作"operator" = "operator"
--洗涤阶段"wash_stage" = "wash_stage"
--错误代码"error_code" = "error_code"
--温度"temperature" = "temperature"
--错误操作"wrong_operation" = "wrong_operation"
--软水盐档位"softwater" = "softwater"
--亮碟剂"bright" = "bright"
--保管开关"airswitch" = "airswitch"
--保管状态"air_status" = "air_status"
--保管设定时间"air_set_hour" = "air_set_hour"
--保管剩余时间"air_left_hour" = "air_left_hour"
--门开关"doorswitch" = "doorswitch"
--碗篮开关"basketswitch" = "basketswitch"
--DIY次数"diy_times"="diy_times"
--DIY主洗温度"diy_main_wash"="diy_main_wash"
--DIY漂洗温度"diy_piao_wash"="diy_piao_wash"
--预约设定时"order_set_hour"="order_set_hour"
--预约设定分"order_set_min"="order_set_min"
--预约剩余时"order_left_hour"="order_left_hour"
--预约剩余分"order_left_min"="order_left_min"
--工作设定时长"work_time"="work_time"
--新旧机型兼容，设备软件版本"device_version"="device_version"
--附加功能"additional"="additional"
--洗涤区域"wash_region"="wash_region"
--水位"water_level"="water_level"
--强度"water_strong_level"="water_strong_level"
--烘干功能开关"dryswitch"="dryswitch"
--净水开关"waterswitch"="waterswitch"
--缺盐开关"softwater_lack"="softwater_lack"
--缺亮碟剂开关"bright_lack"="bright_lack"
--是否为DIY程序"diy_flag"="diy_flag"
--水满标识"water_lack"="water_lack"
--消息类型"msg_type"="msg_type"
--UV灯状态"uvswitch"="uvswitch"
--高温干燥阶段"dry_step_switch"="dry_step_switch"
--湿度百分比"humidity"="humidity"
--烘干设定时间"dry_set_min"="dry_set_min"
--云洗涤指令"cmd_cloud"="cmd_cloud"
--OTA软件版本"ota_version"="ota_version"

--欧洲/澳洲
--Null			0
--Auto            1
--Intensive		2
--Universal/ Normal	 3
--Eco				4
--Delicate /Glass		5
--90min			6
--Rapid			7
--Soak			8
--1Hour/58Min		9
--3in1/ Allinone		10
--AutoHeavy		11
--Party			12
--Quiet/ Silence				13
--AutoDaily		14
--Hygiene			15
--SelfClean		16
--AutoGlass		17
--BabyCare		18
--Fruit			19

--模式

-----------------二进制相关属性变量----------------
--设备
uptable["BYTE_DEVICE_TYPE"] = 0xE1
--消息类型
uptable["BYTE_CONTROL_REQUEST"] = 0x02
uptable["BYTE_QUERY_REQUEST"] = 0x03
--协议头及长度
uptable["BYTE_PROTOCOL_HEAD"] = 0xAA
uptable["BYTE_PROTOCOL_LENGTH"] = 0x0A

----------一些公共的函数------------
--从byteData中提取body message
local function extractBodyBytes(byteData)
	local msgLength = #byteData
	local msgBytes = {}
	local bodyBytes = {}
	for i = 1, msgLength do
		msgBytes[i - 1] = byteData[i]
	end
	--去掉消息头和校验码就剩下消息体
	local bodyLength = msgLength - uptable["BYTE_PROTOCOL_LENGTH"] - 1
	--获取消息体 body 部分
	for i = 0, bodyLength - 1 do
		bodyBytes[i] = msgBytes[i + uptable["BYTE_PROTOCOL_LENGTH"]]
	end
	return bodyBytes
end
-- 1.将bodyBytes 组装上Uart头部信息和尾部校验码。
-- 2.传入的 bodyBytes 为索引从0开始。
-- 3.返回的 table 索引也从0开始。
local function assembleUart(bodyBytes, type)
	local bodyLength = #bodyBytes + 1
	if bodyLength == 0 then
		return nil
	end
	local msgLength = (bodyLength + uptable["BYTE_PROTOCOL_LENGTH"] + 1)
	local msgBytes = {}

	for i = 0, msgLength - 1 do
		msgBytes[i] = 0
	end
	--构造消息部分
	msgBytes[0] = 0xAA
	msgBytes[1] = msgLength - 1
	msgBytes[2] = 0xE1
	msgBytes[9] = type

	for i = 0, bodyLength - 1 do
		msgBytes[i + uptable["BYTE_PROTOCOL_LENGTH"]] = bodyBytes[i]
	end

	msgBytes[msgLength - 1] = makeSum(msgBytes, 1, msgLength - 2)

	--lua table 索引从 1 开始，因此此处要重新转换一次
	local msgBytesTemp = {}
	local length = #msgBytes + 1
	for i = 1, length do
		msgBytesTemp[i] = msgBytes[i - 1]
	end
	return msgBytesTemp
end

-----------根据电控协议不同，需要改变的函数-------------
--根据 json 修改属性变量
local function updateDataByJson(luaTable, bodyBytes)
	--童锁使用0x83指令
	if luaTable["lock"] ~= nil then
		bodyBytes[0] = 0x83
		if luaTable["lock"] == "on" then
			bodyBytes[1] = 0x03
		elseif luaTable["lock"] == "off" then
			bodyBytes[1] = 0x04
		end
	--暂停/继续工作,使用0x83指令
	elseif luaTable["operator"] ~= nil and luaTable["operator"] ~= "" then
		bodyBytes[0] = 0x83
		if luaTable["operator"] == "start" then
			bodyBytes[1] = 0x01
		elseif luaTable["operator"] == "pause" then
			bodyBytes[1] = 0x02
		end
	elseif luaTable["softwater"] ~= nil then
		--设置软水档位,使用0x80指令
		bodyBytes[0] = 0x80
		bodyBytes[1] = luaTable["softwater"]
	elseif luaTable["bright"] ~= nil then
		--设置亮碟档位,使用0x84指令
		bodyBytes[0] = 0x84
		bodyBytes[1] = luaTable["bright"]
	elseif luaTable["airswitch"] ~= nil then
		--设置保管开关,使用0x81指令
		bodyBytes[0] = 0x81
		bodyBytes[4] = luaTable["airswitch"]
		bodyBytes[5] = 0xff
		bodyBytes[6] = 0xff
		bodyBytes[7] = 0xff
		bodyBytes[8] = 0xff
		bodyBytes[9] = 0xff
		bodyBytes[10] = 0xff
	elseif luaTable["dryswitch"] ~= nil or luaTable["dry_set_min"] ~= nil then
		--设置烘干开关,使用0x81指令
		bodyBytes[0] = 0x81
		bodyBytes[4] = 0xff
		bodyBytes[5] = 0xff
		bodyBytes[6] = 0xff
		bodyBytes[7] = 0xff
		bodyBytes[8] = 0xff
		if luaTable["dryswitch"] == nil then
			bodyBytes[9] = 0xff
		else
			bodyBytes[9] = luaTable["dryswitch"]
		end
		if luaTable["dry_set_min"] == nil then
			bodyBytes[10] = 0xff
		else
			bodyBytes[10] = luaTable["dry_set_min"]
		end
	elseif luaTable["waterswitch"] ~= nil then
		--设置净水开关,使用0x81指令
		bodyBytes[0] = 0x81
		bodyBytes[4] = 0xff
		bodyBytes[5] = 0xff
		bodyBytes[6] = 0xff
		bodyBytes[7] = 0xff
		bodyBytes[8] = luaTable["waterswitch"]
		bodyBytes[9] = 0xff
		bodyBytes[10] = 0xff
	elseif luaTable["uvswitch"] ~= nil then
		--设置UV开关,使用0x81指令
		bodyBytes[0] = 0x81
		bodyBytes[4] = 0xff
		bodyBytes[5] = 0xff
		bodyBytes[6] = 0xff
		bodyBytes[7] = luaTable["uvswitch"]
		bodyBytes[8] = 0xff
		bodyBytes[9] = 0xff
		bodyBytes[10] = 0xff
	elseif luaTable["dry_step_switch"] ~= nil then
		--设置干燥阶段开关,使用0x81指令
		bodyBytes[0] = 0x81
		bodyBytes[4] = 0xff
		bodyBytes[5] = 0xff
		bodyBytes[6] = luaTable["dry_step_switch"]
		bodyBytes[7] = 0xff
		bodyBytes[8] = 0xff
		bodyBytes[9] = 0xff
		bodyBytes[10] = 0xff
	elseif luaTable["auto_release_switch"] ~= nil then
		--设置自动投放开关,使用0x81指令
		bodyBytes[0] = 0x81
		bodyBytes[4] = 0xff
		bodyBytes[5] = 0xff
		bodyBytes[6] = 0xff
		bodyBytes[7] = 0xff
		bodyBytes[8] = 0xff
		bodyBytes[9] = 0xff
		bodyBytes[10] = 0xff
		bodyBytes[11] = luaTable["auto_release_switch"]
	elseif luaTable["air_set_hour"] ~= nil then
		--当保管剩余时间为0时，可设置
		bodyBytes[0] = 0x86
		bodyBytes[1] = luaTable["air_set_hour"]
	elseif luaTable["diy_times"] ~= nil then
		--设置DIY洗涤程序
		local diy_times, diy_main_wash, diy_piao_wash = 0x00
		diy_times = luaTable["diy_times"]
		if luaTable["diy_main_wash"] ~= nil then
			diy_main_wash = luaTable["diy_main_wash"]
		end
		if luaTable["diy_piao_wash"] ~= nil then
			diy_piao_wash = luaTable["diy_piao_wash"]
		end
		bodyBytes[0] = 0x82
		bodyBytes[1] = diy_times
		bodyBytes[3] = diy_main_wash
		bodyBytes[5] = diy_piao_wash
	elseif luaTable["cmd_cloud"] ~= nil then
		--设置云洗涤指令
		local array = split(luaTable["cmd_cloud"], ",")
		for i = 1, #array do
			bodyBytes[i - 1] = tonumber(array[i], 16)
		end
	elseif luaTable["ctr_common"] ~= nil then
		--通用设置
		bodyBytes[0] = 0x90
		if luaTable["ctr_common"]["type"] ~= nil then
			bodyBytes[1] = luaTable["ctr_common"]["type"]
		end
		if luaTable["ctr_common"]["time_day"] ~= nil then
			bodyBytes[2] = luaTable["ctr_common"]["time_day"]
		end
		if luaTable["ctr_common"]["time_hour"] ~= nil then
			bodyBytes[3] = luaTable["ctr_common"]["time_hour"]
		end
		if luaTable["ctr_common"]["time_min"] ~= nil then
			bodyBytes[4] = luaTable["ctr_common"]["time_min"]
		end
		if luaTable["ctr_common"]["gear"] ~= nil then
			bodyBytes[5] = luaTable["ctr_common"]["gear"]
		end
		if luaTable["ctr_common"]["switch_status"] ~= nil then
			bodyBytes[6] = luaTable["ctr_common"]["switch_status"]
		end
		if luaTable["ctr_common"]["temp"] ~= nil then
			bodyBytes[7] = luaTable["ctr_common"]["temp"]
		end
		if luaTable["ctr_common"]["level"] ~= nil then
			bodyBytes[8] = luaTable["ctr_common"]["level"]
		end
		if luaTable["ctr_common"]["strong_level"] ~= nil then
			bodyBytes[9] = luaTable["ctr_common"]["strong_level"]
		end
		if luaTable["ctr_common"]["count"] ~= nil then
			bodyBytes[10] = luaTable["ctr_common"]["count"]
		end
		if luaTable["ctr_common"]["reserved1"] ~= nil then
			bodyBytes[11] = luaTable["ctr_common"]["reserved1"]
		end
		if luaTable["ctr_common"]["reserved2"] ~= nil then
			bodyBytes[12] = luaTable["ctr_common"]["reserved2"]
		end
		if luaTable["ctr_common"]["reserved3"] ~= nil then
			bodyBytes[13] = luaTable["ctr_common"]["reserved3"]
		end
		if luaTable["ctr_common"]["reserved4"] ~= nil then
			bodyBytes[14] = luaTable["ctr_common"]["reserved4"]
		end
	else
		local workStatus = 0x00
		if luaTable["work_status"] == "power_on" then
			workStatus = 0x01
		elseif luaTable["work_status"] == "power_off" then
			workStatus = 0x00
		elseif luaTable["work_status"] == "cancel" then
			workStatus = 0x01
		elseif luaTable["work_status"] == "work" then
			workStatus = 0x03
		elseif luaTable["work_status"] == "order" then
			workStatus = 0x02
		elseif luaTable["work_status"] == "cancel_order" then
			workStatus = 0x04
		end
		--模式
		local mode = 0x00
		if luaTable["mode"] == "null" then
			mode = 0x00
		elseif luaTable["mode"] == "auto" then
			mode = 0x01
		elseif luaTable["mode"] == "intensive" then
			mode = 0x02
		elseif luaTable["mode"] == "normal" then
			mode = 0x03
		elseif luaTable["mode"] == "eco" then
			mode = 0x04
		elseif luaTable["mode"] == "glass" then
			mode = 0x05
		elseif luaTable["mode"] == "90min" then
			mode = 0x06
		elseif luaTable["mode"] == "rapid" then
			mode = 0x07
		elseif luaTable["mode"] == "soak" then
			mode = 0x08
		elseif luaTable["mode"] == "1hour" then
			mode = 0x09
		elseif luaTable["mode"] == "3in1" then
			mode = 0x0a
		elseif luaTable["mode"] == "auto_heavy" then
			mode = 0x0b
		elseif luaTable["mode"] == "party" then
			mode = 0x0c
		elseif luaTable["mode"] == "quiet" then
			mode = 0x0D
		elseif luaTable["mode"] == "auto_daily" then
			mode = 0x0e
		elseif luaTable["mode"] == "hygiene" then
			mode = 0x0f
		elseif luaTable["mode"] == "self_clean" then
			mode = 0x10
		elseif luaTable["mode"] == "auto_glass" then
			mode = 0x11
		elseif luaTable["mode"] == "baby_care" then
			mode = 0x12
		elseif luaTable["mode"] == "fruit" then
			mode = 0x13
		elseif luaTable["mode"] == "45min" then
			mode = 0x14
		elseif luaTable["mode"] == "anion1" then
			mode = 0x15
		elseif luaTable["mode"] == "anion2" then
			mode = 0x16
		elseif luaTable["mode"] == "anion3" then
			mode = 0x17
		elseif luaTable["mode"] == "low_degree" then
			mode = 0x19
		elseif luaTable["mode"] == "dry_only" then
			mode = 0x1a
		elseif luaTable["mode"] == "dry_only_2h" then
			mode = 0x1b
		elseif luaTable["mode"] == "dry_only_3h" then
			mode = 0x1c
		elseif luaTable["mode"] == "dry_only_4h" then
			mode = 0x1d
		elseif luaTable["mode"] == "hot_air_1" then
			mode = 0x1e
		elseif luaTable["mode"] == "hot_air_2" then
			mode = 0x1f
		elseif luaTable["mode"] == "hot_air_3" then
			mode = 0x20
		else
			if workStatus == 0x03 then
				mode = 0x04
			end
		end

		local additional = 0x00
		if luaTable["additional"] ~= nil then
			additional = luaTable["additional"]
		end
		local wash_region = 0x00
		if luaTable["wash_region"] ~= nil then
			wash_region = luaTable["wash_region"]
		end
		local door_auto_open = 0x00
		if luaTable["door_auto_open"] ~= nil then
			door_auto_open = luaTable["door_auto_open"]
		end
		--构造消息 body 部分
		bodyBytes[0] = 0x08
		bodyBytes[1] = workStatus
		bodyBytes[2] = mode
		bodyBytes[3] = additional
		bodyBytes[4] = wash_region
		if luaTable["isDiy"] ~= nil and luaTable["isDiy"] == 1 then
			bodyBytes[5] = 0x20
		else
			bodyBytes[5] = 0x00
		end
		bodyBytes[13] = door_auto_open
		if workStatus == 0x02 then
			--预约
			local orderSetTime = 0x00
			if luaTable["order_set_hour"] ~= nil and luaTable["order_set_min"] ~= nil then
				orderSetTime = luaTable["order_set_hour"] * 60 + luaTable["order_set_min"]
			end
			bodyBytes[7] = math.modf(orderSetTime / 60)
			bodyBytes[8] = math.fmod(orderSetTime, 60)
		end
		if mode == 0x0f then
			--紫外除菌
			if luaTable["work_time"] ~= nil then
				bodyBytes[10] = luaTable["work_time"]
			end
		end
		if luaTable["water_level"] ~= nil then
			bodyBytes[11] = luaTable["water_level"]
		end
		if luaTable["water_strong_level"] ~= nil then
			bodyBytes[12] = luaTable["water_strong_level"]
		end
	end
end

--根据传入的二进制字符串解析出的状态JSON对象
local function updateJsonByData(binData)
	--包括Uart头
	local byteData = string2table(binData)
	local bodyBytes = extractBodyBytes(byteData)

	local retTable = {}
	local streams = {}
	--版本
	streams["version"] = uptable["VALUE_VERSION"]
	streams["cmd"] = binData

	--获取消息数据类型
	local dataType = byteData[10]
	streams["msg_type"] = dataType
	if dataType ~= 0x02 and dataType ~= 0x03 and dataType ~= 0x04 then
		retTable["status"] = streams
		return encodeTableToJson(retTable)
	end

	--消息数据子类型如果为1：则为水电数据上报，应用端不关注。
	if byteData[11] == 0x01 then
		retTable["status"] = streams
		return encodeTableToJson(retTable)
	end

	--工作状态
	local workStatus = bodyBytes[1]
	if workStatus == 0x00 then
		streams["work_status"] = "power_off"
	elseif workStatus == 0x01 then
		streams["work_status"] = "cancel"
	elseif workStatus == 0x03 then
		streams["work_status"] = "work"
	elseif workStatus == 0x02 then
		streams["work_status"] = "order"
	elseif workStatus == 0x04 then
		streams["work_status"] = "error"
	elseif workStatus == 0x05 then
		streams["work_status"] = uptable["VALUE_WORK_STATUS_SOFT_GEAR"]
	else
	end
	--模式
	local mode = bodyBytes[2]
	if mode == 0x00 then
		streams["mode"] = "null"
	elseif mode == 0x01 then
		streams["mode"] = "auto"
	elseif mode == 0x02 then
		streams["mode"] = "intensive"
	elseif mode == 0x03 then
		streams["mode"] = "normal"
	elseif mode == 0x04 then
		streams["mode"] = "eco"
	elseif mode == 0x05 then
		streams["mode"] = "glass"
	elseif mode == 0x06 then
		streams["mode"] = "90min"
	elseif mode == 0x07 then
		streams["mode"] = "rapid"
	elseif mode == 0x08 then
		streams["mode"] = "soak"
	elseif mode == 0x09 then
		streams["mode"] = "1hour"
	elseif mode == 0x0a then
		streams["mode"] = "3in1"
	elseif mode == 0x0b then
		streams["mode"] = "auto_heavy"
	elseif mode == 0x0c then
		streams["mode"] = "party"
	elseif mode == 0x0D then
		streams["mode"] = "quiet"
	elseif mode == 0x0e then
		streams["mode"] = "auto_daily"
	elseif mode == 0x0f then
		streams["mode"] = "hygiene"
	elseif mode == 0x10 then
		streams["mode"] = "self_clean"
	elseif mode == 0x11 then
		streams["mode"] = "auto_glass"
	elseif mode == 0x12 then
		streams["mode"] = "baby_care"
	elseif mode == 0x13 then
		streams["mode"] = "fruit"
	elseif mode == 0x14 then
		streams["mode"] = "45min"
	elseif mode == 0x15 then
		streams["mode"] = "anion1"
	elseif mode == 0x16 then
		streams["mode"] = "anion2"
	elseif mode == 0x17 then
		streams["mode"] = "anion3"
	elseif mode == 0x19 then
		streams["mode"] = "low_degree"
	elseif mode == 0x1a then
		streams["mode"] = "dry_only"
	elseif mode == 0x1b then
		streams["mode"] = "dry_only_2h"
	elseif mode == 0x1c then
		streams["mode"] = "dry_only_3h"
	elseif mode == 0x1d then
		streams["mode"] = "dry_only_4h"
	elseif mode == 0x1e then
		streams["mode"] = "hot_air_1"
	elseif mode == 0x1f then
		streams["mode"] = "hot_air_2"
	elseif mode == 0x20 then
		streams["mode"] = "hot_air_3"
	else
		streams["mode"] = "invalid"
	end

	--附加功能
	local additional = bodyBytes[3]
	if additional ~= nil then
		streams["additional"] = additional
	end

	--解析标识位
	--缺亮碟剂
	local lackbright = (bit_band(bodyBytes[5], 0x02) == 0x02)
	if lackbright then
		streams["bright_lack"] = 1
	else
		streams["bright_lack"] = 0
	end
	--缺盐
	local lacksoftwater = (bit_band(bodyBytes[5], 0x04) == 0x04)
	if lacksoftwater then
		streams["softwater_lack"] = 1
	else
		streams["softwater_lack"] = 0
	end
	--是否为DIY程序
	local diyflag = (bit_band(bodyBytes[4], 0x08) == 0x08)
	if diyflag then
		streams["diy_flag"] = 1
	else
		streams["diy_flag"] = 0
	end
	--是否带有自动开门 俄罗斯新增
	local doorautoflag = (bit_band(bodyBytes[4], 0x40) == 0x40)
	if doorautoflag then
		streams["door_auto_open"] = 1
	else
		streams["door_auto_open"] = 0
	end
	--童锁/解锁/暂停/继续 byte[5]
	local lock = bit_band(bodyBytes[5], 0x10)
	if lock == 0x10 then
		streams["lock"] = "on"
	else
		streams["lock"] = "off"
	end
	local operator = bit_band(bodyBytes[5], 0x08)
	if operator == 0x08 then
		streams["operator"] = "start"
	elseif workStatus == 0x03 then
		streams["operator"] = "pause"
	elseif workStatus == 0x02 then
		streams["operator"] = "pause"
	else
		streams["operator"] = ""
	end
	--工作剩余时间
	local leftTime = bodyBytes[6]
	if bodyBytes[32] ~= nil then
		local leftTimeHigh = bodyBytes[32]
		streams["left_time"] = leftTimeHigh * 256 + leftTime
	else
		streams["left_time"] = leftTime
	end
	--洗涤阶段
	local washStage = bodyBytes[9]
	streams["wash_stage"] = washStage
	--错误码
	local errorCode = bodyBytes[10]
	streams["error_code"] = errorCode
	--实时温度
	local temperature = bodyBytes[11]
	streams["temperature"] = temperature
	--软水盐档位
	local softwater = bodyBytes[13]
	streams["softwater"] = softwater
	--错误原因
	local wrongOperation = bodyBytes[16]
	streams["wrong_operation"] = wrongOperation
	--保管 开/关/设定时间/剩余时间
	local airswitch = (bit_band(bodyBytes[5], 0x20) == 0x20)
	local airStatus = (bit_band(bodyBytes[5], 0x40) == 0x40)
	local airSetTime = bodyBytes[17]
	local airLeftTime = bodyBytes[18]
	if airswitch then
		streams["airswitch"] = 1
	else
		streams["airswitch"] = 0
	end
	if airStatus then
		streams["air_status"] = 1
	else
		streams["air_status"] = 0
	end
	streams["air_set_hour"] = airSetTime
	streams["air_left_hour"] = airLeftTime
	--门开状态
	local doorswitch = (bit_band(bodyBytes[5], 0x01) == 0x01)
	if doorswitch then
		streams["doorswitch"] = 1
	else
		streams["doorswitch"] = 0
	end

	--烘干开关使能
	local dryswitch = (bit_band(bodyBytes[4], 0x10) == 0x10)
	--烘干状态
	local drystatus = (bit_band(bodyBytes[4], 0x20) == 0x20)
	if drystatus then
		streams["dryswitch"] = 2
	elseif dryswitch then
		streams["dryswitch"] = 1
	else
		streams["dryswitch"] = 0
	end

	--净水开关
	local waterswitch = (bit_band(bodyBytes[4], 0x04) == 0x04)
	if waterswitch then
		streams["waterswitch"] = 1
	else
		streams["waterswitch"] = 0
	end

	--预约设置
	if workStatus == 0x02 then
		local orderSetTime = bodyBytes[19] * 60 + bodyBytes[20]
		local orderLeftTime = bodyBytes[7] * 60 + bodyBytes[8]
		streams["order_set_hour"] = math.modf(orderSetTime / 60)
		streams["order_set_min"] = math.fmod(orderSetTime, 60)
		streams["order_left_hour"] = math.modf(orderLeftTime / 60)
		streams["order_left_min"] = math.fmod(orderLeftTime, 60)
	else
		--DIY设置
		streams["diy_times"] = bodyBytes[19]
		streams["diy_main_wash"] = bodyBytes[21]
		streams["diy_piao_wash"] = bodyBytes[23]
	end
	--亮碟剂档位
	if bodyBytes[24] ~= nil then
		streams["bright"] = bodyBytes[24]
	end
	--设备软件版本用在C2M项目上
	if bodyBytes[28] ~= nil then
		streams["device_version"] = bodyBytes[28]
	end

	--水位和强度
	if bodyBytes[31] ~= nil then
		streams["water_level"] = bodyBytes[30]
		streams["water_strong_level"] = bodyBytes[31]
	end

	--水满标识
	local water_lack = (bit_band(bodyBytes[5], 0x80) == 0x80)
	if water_lack then
		streams["water_lack"] = 1
	else
		streams["water_lack"] = 0
	end

	--干燥阶段开关
	local dry_step_switch = (bit_band(bodyBytes[4], 0x01) == 0x01)
	if dry_step_switch then
		streams["dry_step_switch"] = 0
	else
		streams["dry_step_switch"] = 1
	end

	--UV灯开关
	local uvswitch = (bit_band(bodyBytes[4], 0x02) == 0x02)
	if uvswitch then
		streams["uvswitch"] = 1
	else
		streams["uvswitch"] = 0
	end

	--湿度百分比
	if bodyBytes[33] ~= nil then
		streams["humidity"] = bodyBytes[33]
	end

	--烘干设定时间
	if bodyBytes[34] ~= nil then
		streams["dry_set_min"] = bodyBytes[34]
	end

	--洗涤区域
	if bodyBytes[35] ~= nil then
		streams["wash_region"] = bodyBytes[35]
	end

	--OTA软件版本
	if bodyBytes[36] ~= nil then
		streams["ota_version"] = bodyBytes[36]
	end

	--WIFI不可控状态
	if bodyBytes[37] ~= nil then
		local wifiUnabled = (bit_band(bodyBytes[37], 0x02) == 0x02)
		streams["wifi_unabled"] = wifiUnabled

		local releaseswitch = (bit_band(bodyBytes[37], 0x04) == 0x04)
		if releaseswitch then
			streams["auto_release_switch"] = 1
		else
			streams["auto_release_switch"] = 0
		end
	end

	--负离子档位
	if bodyBytes[42] ~= nil then
		streams["ion_level"] = bodyBytes[42]
	end

	--负离子时间（小时）
	if bodyBytes[43] ~= nil then
		streams["ion_time_hour"] = bodyBytes[43]
	end

	--负离子时间（分钟）
	if bodyBytes[44] ~= nil then
		streams["ion_time_min"] = bodyBytes[44]
	end

	--负离子状态
	if bodyBytes[45] ~= nil then
		streams["ion_status"] = bodyBytes[45]
	end

	retTable["status"] = streams
	return encodeTableToJson(retTable)
end

--json转二进制，可传入原状态
function jsonToData(jsonCmdStr)
	if #jsonCmdStr == 0 then
		return nil
	end
	local json = decodeJsonToTable(jsonCmdStr)
	local query = json["query"]
	local control = json["control"]
	local status = json["status"]
	--当前是查询指令，构造固定的二进制即可
	local msgBytes = {}
	if control then
		local bodyLength = 38
		local bodyBytes = {}
		for i = 0, bodyLength - 1 do
			bodyBytes[i] = 0
		end
		--将用户控制 转换为属性
		updateDataByJson(control, bodyBytes)
		msgBytes = assembleUart(bodyBytes, 0x02)
	elseif query then
		--构造消息 body 部分

		local bodyLength = 1
		local bodyBytes = {}
		for i = 0, bodyLength - 1 do
			bodyBytes[i] = 0
		end
		msgBytes = assembleUart(bodyBytes, 0x03)
	end
	return table2hex(msgBytes)
end

--二进制转json
function dataToJson(jsonStr)
	if not jsonStr then
		return nil
	end
	local json = decodeJsonToTable(jsonStr)
	--根据设备子类型来处理协议差异
	local deviceinfo = json["deviceinfo"]
	local deviceSubType = deviceinfo["deviceSubType"]
	if deviceSubType == 1 then
	end

	local binData = json["msg"]["data"]
	local ret = updateJsonByData(binData)
	return ret
end
