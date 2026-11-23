local bit = require("bit")

----澳洲热水器协议解析
----author: Lin Jianmin、Jiuwk
----email jianmin.lin@midea.com
----date  : 2022/6/16

local JSON = require("cjson")

-----------------JSON相关key值变量-----------------
-- 版本号
local KEY_VERSION = "version"
-- 电源
local KEY_POWER = "power"
-- 模式
local KEY_MODE = "mode"
-- 错误码
local KEY_ERROR_CODE = "error_code"

----------------JSON相关value值变量----------------
-- 版本号
local VALUE_VERSION = "12"

-- bit0
local BIT0 = 0x01
-- bit1
local BIT1 = 0x02
-- bit2
local BIT2 = 0x04
-- bit3
local BIT3 = 0x08
-- bit4
local BIT4 = 0x10
-- bit5
local BIT5 = 0x20
-- bit6
local BIT6 = 0x40
-- bit7
local BIT7 = 0x80

-- 功能开
local VALUE_FUNCTION_ON = "on"
-- 功能关
local VALUE_FUNCTION_OFF = "off"
-- 静音等级
local VALUE_MUTE_LEV1 = "lve1"
local VALUE_MUTE_LEV2 = "lve2"
-- 有效
local VALUE_VALID = "valid"
-- 无效
local VALUE_INVALID = "invalid"

-- 华氏度
local VALUE_FAH = "fahrenh"
-- 摄氏度
local VALUE_CEL = "celsius"

-----------------二进制相关属性变量----------------
-- 设备
local BYTE_DEVICE_TYPE = 0xC3

-- 消息类型
local BYTE_CONTROL_REQUEST = 0x02
local BYTE_QUERYL_REQUEST = 0x03
local BYTE_AUTO_REPORT = 0x04

-- 消息子类型类型
local BYTE_CONTRL_SUBCMD = 0x01 -- 控制指令
local BYTE_RUNPARA1_SUBCMD = 0x02 -- 运行参数1
local BYTE_PERIODIC_REPORT_SUBCMD = 0x91 -- 控制自动上报指令
local BYTE_SN_SUBCMD = 0x0C
local BYTE_RUNPARA2_SUBCMD = 0x0D -- 运行参数2

-- 协议头及长度
local BYTE_PROTOCOL_HEAD = 0xAA
local BYTE_PROTOCOL_LENGTH = 0x0A

local TEMP_OFFSET = 35

-------------------定义属性变量--------------------

-- 使用table来
local myTable = {
	-- 设定模式
	["modeValue"] = 0,
	-- 度假模式
	["vacationMode"] = 0,
	-- 度假起始日期：年
	["vacadaysStartYearValue"] = 0,
	-- 度假起始日期：月
	["vacadaysStartMonthValue"] = 0,
	-- 度假起始日期：日
	["vacadaysStartDayValue"] = 0,
	-- 度假设定温度
	-- ["vacationTsValue"] = 0,
	-- 智能电网
	["smartGrid"] = 0,
	-- 设置温度TS
	["tsValue"] = 0,
	-- 水箱下部温度
	["boxBottomTemp"] = 0,

	-- 定时1开小时
	["timer1OpenHour"] = 0,
	-- 定时1开分钟
	["timer1OpenMin"] = 0,
	-- 定时1关小时
	["timer1CloseHour"] = 0,
	-- 定时1关分钟
	["timer1CloseMin"] = 0,
	-- 定时2开小时
	["timer2OpenHour"] = 0,
	-- 定时2开分钟
	["timer2OpenMin"] = 0,
	-- 定时2关小时
	["timer2CloseHour"] = 0,
	-- 定时2关分钟
	["timer2CloseMin"] = 0,
	-- 定时3开小时
	["timer3OpenHour"] = 0,
	-- 定时3开分钟
	["timer3OpenMin"] = 0,
	-- 定时3关小时
	["timer3CloseHour"] = 0,
	-- 定时3关分钟
	["timer3CloseMin"] = 0,
	-- 定时4开小时
	["timer4OpenHour"] = 0,
	-- 定时4开分钟
	["timer4OpenMin"] = 0,
	-- 定时4关小时
	["timer4CloseHour"] = 0,
	-- 定时4关分钟
	["timer4CloseMin"] = 0,
	-- 定时5开小时
	["timer5OpenHour"] = 0,
	-- 定时5开分钟
	["timer5OpenMin"] = 0,
	-- 定时5关小时
	["timer5CloseHour"] = 0,
	-- 定时5关分钟
	["timer5CloseMin"] = 0,
	-- 定时6开小时
	["timer6OpenHour"] = 0,
	-- 定时6开分钟
	["timer6OpenMin"] = 0,
	-- 定时6关小时
	["timer6CloseHour"] = 0,
	-- 定时6关分钟
	["timer6CloseMin"] = 0,
	-- 定时1设定温度
	["timer1SetTemperature"] = 0,
	-- 定时1设定模式
	["timer1ModeValue"] = 0,
	-- 定时2设定温度
	["timer2SetTemperature"] = 0,
	-- 定时2设定模式
	["timer2ModeValue"] = 0,
	-- 定时3设定温度
	["timer3SetTemperature"] = 0,
	-- 定时3设定模式
	["timer3ModeValue"] = 0,
	-- 定时4设定温度
	["timer4SetTemperature"] = 0,
	-- 定时4设定模式
	["timer4ModeValue"] = 0,
	-- 定时5设定温度
	["timer5SetTemperature"] = 0,
	-- 定时5设定模式
	["timer5ModeValue"] = 0,
	-- 定时6设定温度
	["timer6SetTemperature"] = 0,
	-- 定时6设定模式
	["timer6ModeValue"] = 0,
	-- 智能电网等级
	["smartGridLev"] = 0,
	-- 故障
	["errorCode"] = 0,
	-- 周日定时1开关
	["week0timer1Effect"] = 0,
	-- 周日定时2开关
	["week0timer2Effect"] = 0,
	-- 周日定时3开关
	["week0timer3Effect"] = 0,
	-- 周日定时4开关
	["week0timer4Effect"] = 0,
	-- 周日定时5开关
	["week0timer5Effect"] = 0,
	-- 周日定时6开关
	["week0timer6Effect"] = 0,

	-- 周日定时器1静音开关
	["week0timer1MutSet"] = 0,
	-- 周日定时器1强热开关
	["week0timer1FrcHeSet"] = 0,
	-- 周日定时器1静音等级
	["week0timer1MutLev"] = 0,
	-- 周日定时器1是否有效
	["week0timer1Valid"] = 0,
	-- 周日定时器2是否有效
	["week0timer2Valid"] = 0,
	-- 周日定时器3是否有效
	["week0timer3Valid"] = 0,
	-- 周日定时器4是否有效
	["week0timer4Valid"] = 0,
	-- 周日定时器5是否有效
	["week0timer5Valid"] = 0,
	-- 周日定时器6是否有效
	["week0timer6Valid"] = 0,

	-- 静音定时器1是否使用
	["muteTimer1Effect"] = 0,
	-- 静音定时器2是否使用
	["muteTimer2Effect"] = 0,
	-- 静音定时器3是否使用
	["muteTimer3Effect"] = 0,
	-- 静音定时器4是否使用
	["muteTimer4Effect"] = 0,
	-- 静音定时器5是否使用
	["muteTimer5Effect"] = 0,
	-- 静音定时器6是否使用
	["muteTimer6Effect"] = 0,

	-- 静音定时器1是否有效
	["muteTimer1Valid"] = 0,
	-- 静音定时器2是否有效
	["muteTimer2Valid"] = 0,
	-- 静音定时器3是否有效
	["muteTimer3Valid"] = 0,
	-- 静音定时器4是否有效
	["muteTimer4Valid"] = 0,
	-- 静音定时器5是否有效
	["muteTimer5Valid"] = 0,
	-- 静音定时器6是否有效
	["muteTimer6Valid"] = 0,

	-- 强热定时器1是否有效
	["forceHeatTimer1Valid"] = 0,
	-- 强热定时器2是否有效
	["forceHeatTimer2Valid"] = 0,
	-- 强热定时器3是否有效
	["forceHeatTimer3Valid"] = 0,
	-- 强热定时器4是否有效
	["forceHeatTimer4Valid"] = 0,
	-- 强热定时器5是否有效
	["forceHeatTimer5Valid"] = 0,
	-- 强热定时器6是否有效
	["forceHeatTimer6Valid"] = 0,
	-- 强热定时器1是否有用
	["forceHeatTimer1Effect"] = 0,
	-- 强热定时器2是否有用
	["forceHeatTimer2Effect"] = 0,
	-- 强热定时器3是否有用
	["forceHeatTimer3Effect"] = 0,
	-- 强热定时器4是否有用
	["forceHeatTimer4Effect"] = 0,
	-- 强热定时器5是否有用
	["forceHeatTimer5Effect"] = 0,
	-- 强热定时器6是否有用
	["forceHeatTimer6Effect"] = 0,
	-- 周一定时1开关
	["week1timer1Effect"] = 0,
	-- 周一定时2开关
	["week1timer2Effect"] = 0,
	-- 周一定时3开关
	["week1timer3Effect"] = 0,
	-- 周一定时4开关
	["week1timer4Effect"] = 0,
	-- 周一定时5开关
	["week1timer5Effect"] = 0,
	-- 周一定时6开关
	["week1timer6Effect"] = 0,

	-- 周一定时器1静音开关
	["week1timer1MutSet"] = 0,
	-- 周一定时器1强热开关
	["week1timer1FrcHeSet"] = 0,
	-- 周一定时器1静音等级
	["week1timer1MutLev"] = 0,
	-- 周一定时器1是否有效
	["week1timer1Valid"] = 0,
	-- 周一定时器2是否有效
	["week1timer2Valid"] = 0,
	-- 周一定时器3是否有效
	["week1timer3Valid"] = 0,
	-- 周一定时器4是否有效
	["week1timer4Valid"] = 0,
	-- 周一定时器5是否有效
	["week1timer5Valid"] = 0,
	-- 周一定时器6是否有效
	["week1timer6Valid"] = 0,

	-- 周二定时1开关
	["week2timer1Effect"] = 0,
	-- 周二定时2开关
	["week2timer2Effect"] = 0,
	-- 周二定时3开关
	["week2timer3Effect"] = 0,
	-- 周二定时4开关
	["week2timer4Effect"] = 0,
	-- 周二定时5开关
	["week2timer5Effect"] = 0,
	-- 周二定时6开关
	["week2timer6Effect"] = 0,

	-- 周二定时器1静音开关
	["week2timer1MutSet"] = 0,
	-- 周二定时器1强热开关
	["week2timer1FrcHeSet"] = 0,
	-- 周二定时器1静音等级
	["week2timer1MutLev"] = 0,
	-- 周二定时器1是否有效
	["week2timer1Valid"] = 0,
	-- 周二定时器2是否有效
	["week2timer2Valid"] = 0,
	-- 周二定时器3是否有效
	["week2timer3Valid"] = 0,
	-- 周二定时器4是否有效
	["week2timer4Valid"] = 0,
	-- 周二定时器5是否有效
	["week2timer5Valid"] = 0,
	-- 周二定时器6是否有效
	["week2timer6Valid"] = 0,

	-- 周三定时1开关
	["week3timer1Effect"] = 0,
	-- 周三定时2开关
	["week3timer2Effect"] = 0,
	-- 周三定时3开关
	["week3timer3Effect"] = 0,
	-- 周三定时4开关
	["week3timer4Effect"] = 0,
	-- 周三定时5开关
	["week3timer5Effect"] = 0,
	-- 周三定时6开关
	["week3timer6Effect"] = 0,

	-- 周三定时器1静音开关
	["week3timer1MutSet"] = 0,
	-- 周三定时器1强热开关
	["week3timer1FrcHeSet"] = 0,
	-- 周三定时器1静音等级
	["week3timer1MutLev"] = 0,
	-- 周三定时器1是否有效
	["week3timer1Valid"] = 0,
	-- 周三定时器2是否有效
	["week3timer2Valid"] = 0,
	-- 周三定时器3是否有效
	["week3timer3Valid"] = 0,
	-- 周三定时器4是否有效
	["week3timer4Valid"] = 0,
	-- 周三定时器5是否有效
	["week3timer5Valid"] = 0,
	-- 周三定时器6是否有效
	["week3timer6Valid"] = 0,

	-- 周四定时1开关
	["week4timer1Effect"] = 0,
	-- 周四定时2开关
	["week4timer2Effect"] = 0,
	-- 周四定时3开关
	["week4timer3Effect"] = 0,
	-- 周四定时4开关
	["week4timer4Effect"] = 0,
	-- 周四定时5开关
	["week4timer5Effect"] = 0,
	-- 周四定时6开关
	["week4timer6Effect"] = 0,

	-- 周四定时器1静音开关
	["week4timer1MutSet"] = 0,
	-- 周四定时器1强热开关
	["week4timer1FrcHeSet"] = 0,
	-- 周四定时器1静音等级
	["week4timer1MutLev"] = 0,
	-- 周四定时器1是否有效
	["week4timer1Valid"] = 0,
	-- 周四定时器2是否有效
	["week4timer2Valid"] = 0,
	-- 周四定时器3是否有效
	["week4timer3Valid"] = 0,
	-- 周四定时器4是否有效
	["week4timer4Valid"] = 0,
	-- 周四定时器5是否有效
	["week4timer5Valid"] = 0,
	-- 周四定时器6是否有效
	["week4timer6Valid"] = 0,

	-- 周五定时1开关
	["week5timer1Effect"] = 0,
	-- 周五定时2开关
	["week5timer2Effect"] = 0,
	-- 周五定时3开关
	["week5timer3Effect"] = 0,
	-- 周五定时4开关
	["week5timer4Effect"] = 0,
	-- 周五定时5开关
	["week5timer5Effect"] = 0,
	-- 周五定时6开关
	["week5timer6Effect"] = 0,

	-- 周五定时器1静音开关
	["week5timer1MutSet"] = 0,
	-- 周五定时器1强热开关
	["week5timer1FrcHeSet"] = 0,
	-- 周五定时器1静音等级
	["week5timer1MutLev"] = 0,
	-- 周五定时器1是否有效
	["week5timer1Valid"] = 0,
	-- 周五定时器2是否有效
	["week5timer2Valid"] = 0,
	-- 周五定时器3是否有效
	["week5timer3Valid"] = 0,
	-- 周五定时器4是否有效
	["week5timer4Valid"] = 0,
	-- 周五定时器5是否有效
	["week5timer5Valid"] = 0,
	-- 周五定时器6是否有效
	["week5timer6Valid"] = 0,

	-- 周六定时1开关
	["week6timer1Effect"] = 0,
	-- 周六定时2开关
	["week6timer2Effect"] = 0,
	-- 周六定时3开关
	["week6timer3Effect"] = 0,
	-- 周六定时4开关
	["week6timer4Effect"] = 0,
	-- 周六定时5开关
	["week6timer5Effect"] = 0,
	-- 周六定时6开关
	["week6timer6Effect"] = 0,

	-- 周六定时器1静音开关
	["week6timer1MutSet"] = 0,
	-- 周六定时器1强热开关
	["week6timer1FrcHeSet"] = 0,
	-- 周六定时器1静音等级
	["week6timer1MutLev"] = 0,
	-- 周六定时器1是否有效
	["week6timer1Valid"] = 0,
	-- 周六定时器2是否有效
	["week6timer2Valid"] = 0,
	-- 周六定时器3是否有效
	["week6timer3Valid"] = 0,
	-- 周六定时器4是否有效
	["week6timer4Valid"] = 0,
	-- 周六定时器5是否有效
	["week6timer5Valid"] = 0,
	-- 周六定时器6是否有效
	["week6timer6Valid"] = 0,

	-- 日定时1开关
	["timer1Effect"] = 0,
	-- 日定时2开关
	["timer2Effect"] = 0,
	-- 日定时3开关
	["timer3Effect"] = 0,
	-- 日定时4开关
	["timer4Effect"] = 0,
	-- 日定时5开关
	["timer5Effect"] = 0,
	-- 日定时6开关
	["timer6Effect"] = 0,

	-- 日定时1是否有效
	["timer1Valid"] = 0,
	-- 日定时2是否有效
	["timer2Valid"] = 0,
	-- 日定时3是否有效
	["timer3Valid"] = 0,
	-- 日定时4是否有效
	["timer4Valid"] = 0,
	-- 日定时5是否有效
	["timer5Valid"] = 0,
	-- 日定时6是否有效
	["timer6Valid"] = 0,

	-- 杀菌功能是否生效
	["sterilizeEffect"] = 0,
	-- 当前所接机型信息
	["typeInfo"] = 0,
	-- 消息返回类型
	["dataType"] = 0,
	-- 控制指令类型类型
	["controlType"] = 0,
	-- 查询指令类型类型
	["queryType"] = 0,
	-- 回差温度设定Tr
	["trValue"] = 0,
	-- 强制开启电热
	["openPTC"] = 0,
	-- 电加热开启环境温度TD
	["ptcTemp"] = 0,
	-- 静音
	["mute"] = 0,

	-- 日期年
	["dateYearValue"] = 0,
	-- 日期月
	["dateMonthValue"] = 0,
	-- 日期 日
	["dateDayValue"] = 0,
	-- 日期星期
	["dateWeekValue"] = 0,
	-- 日期小时
	["dateHourValue"] = 0,
	-- 日期分钟
	["dateMinuteValue"] = 0,

	["t5sMax"] = 0, -- 设定水温上限值
	["t5sMin"] = 0, -- 设定水温下限值
	["t5sDef"] = 0, -- 设定水温默认值
	["tdMax"] = 0, -- 电加热开启环境温度上限值
	["tdMin"] = 0, -- 电加热开启环境温度下限值
	["tdDef"] = 0, -- 电加热开启环境温度默认值
	["trdhMax"] = 0, -- 热水开机回差温度上限值
	["trdhMin"] = 0, -- 热水开机回差温度下限值
	["trdhDef"] = 0, -- 热水开机回差温度默认值

	["sterilizeValid"] = 0, -- 是否有杀菌功能
	["hybridValid"] = 0, -- 是否有燃气复合功能
	["solarEnergyValid"] = 0, -- 是否有太阳能控制功能
	["optBackupValid"] = 0, -- 是否有峰谷电功能
	["vacationValid"] = 0, -- 是否有休假功能
	["smartGridValid"] = 0, -- 是否有SmartGrid功能
	["muteValid"] = 0, -- 是否有静音功能
	["forceHeatValid"] = 0, -- 是否有强热功能
	["sterilizeSta"] = 0, -- 杀菌状态
	["hybridSta"] = 0, -- 燃气炉状态
	["solarEnergySta"] = 0, -- 太阳能信号状态
	["optBackupSta"] = 0, -- 谷电信号状态
	["vacationSta"] = 0, -- 休假状态
	["ibh1Sta"] = 0, -- 电加热1运行状态
	["ibh2Sta"] = 0, -- 电加热2运行状态
	["compSta"] = 0, -- 压缩机状态

	-- 外风机转速
	["oduFanSpd"] = 0,
	-- 最近一次压缩机运行时间
	["compRunTim"] = 0,
	-- 电子膨胀阀开度
	["exvDrg"] = 0,
	-- 系统压力1
	["pressureH"] = 0,
	-- 系统压力2
	["pressureL"] = 0,
	["runMode"] = 0, -- 运行模式 0：关机,1：运行,2：待机,3：除霜,4：防冻
	["compFrq"] = 0, -- 压缩机频率
	-- 累计消耗电量
	["totalKwh"] = 0,
	-- 压缩机累计运行时间
	["compTotalRunTim"] = 0,
	-- 风机累计运行时间
	["fanTotalRunTim"] = 0,
	["pumpOSta"] = 0, -- 外置水泵运行状态
	["pumpSSta"] = 0, -- 太阳能水泵运行状态
	["oduRunCmd"] = 0, -- 内机向外机发送的运行指令
	["tempUnit"] = 0, -- 温度单位
	["smartGridSta"] = 0, -- SmartGrid运行状态

	-- 内置水泵累计运行时间
	["pumpITotalRunTim"] = 0,
	-- 电加热1累计运行时间
	["ibh1TotalRunTim"] = 0,
	-- 电加热2累计运行时间
	["ibh2TotalRunTim"] = 0,
	-- TBH累计运行时间
	["tbhTotalRunTim"] = 0,
	-- AHS累计运行时间
	["ahsTotalRunTim"] = 0,
	["onlineNum"] = 0, -- 机组在线台数
	["oduMacType"] = 0, -- 外机类型
	["limitFrqCode"] = 0, -- 限频代号
	["tfTemp"] = 0, -- 压缩机模块温度Tf
	["tpTemp"] = 0, -- 压缩机排气温度Tp
	["thTemp"] = 0, -- 压缩机回气温度Th
	["waterPres"] = 0, -- 水压
	["waterFlow"] = 0, -- 水侧流量
	["capacityHp"] = 0, -- 机组能力
	["t3Temp"] = 0, -- T3温度
	["t4Temp"] = 0, -- T4温度
	["t2Temp"] = 0, -- T2温度
	["t2bTemp"] = 0, -- T2b温度
	["twinTemp"] = 0, -- Twin温度
	["twoutTemp"] = 0, -- Twout温度
	["t1Temp"] = 0, -- T1温度
	["oduCurrent"] = 0, -- 输入电流
	-- 输入电压
	["oduVoltage"] = 0,
	["dcCurrent"] = 0, -- 直流母线电流
	-- 内机软件版本：年、月、日
	["iduVersionYear"] = 0,
	["iduVersionMonth"] = 0,
	["iduVersionDay"] = 0,
	["iduVersion"] = 0, -- 外机软件版本号
	-- 外机软件版本：年、月、日
	["oduVersionYear"] = 0,
	["oduVersionMonth"] = 0,
	["oduVersionDay"] = 0,
	["oduVersion"] = 0, -- 外机软件版本号
	-- 线控器软件版本：年、月、日
	["hmiVersionYear"] = 0,
	["hmiVersionMonth"] = 0,
	["hmiVersionDay"] = 0,
	["hmiVersion"] = 0, -- 线控器软件版本号

	-- 直流母线电压
	["dcVoltage"] = 0,

	-- 定时类型
	["timerType"] = 0,
	-- 杀菌时间：时
	["sterilizeHour"] = 0,
	-- 杀菌时间：分
	["sterilizeMinute"] = 0,
	-- 杀菌设定温度
	["sterilizeTs"] = 0,
	-- 杀菌周期：天
	["sterilizeCycle"] = 0,
	-- 度假结束日期：年
	["vacadaysEndYearValue"] = 0,
	-- 度假结束日期：月
	["vacadaysEndMonthValue"] = 0,
	-- 度假结束日期：日
	["vacadaysEndDayValue"] = 0,
	-- 静音等级
	["muteLev"] = 0,
	-- 强热开关
	["forceHeat"] = 0,
	-- 峰谷电控制开关
	["optBackupEn"] = 0,
	-- 燃气复合控制开关
	["hybridEn"] = 0,
	-- 太阳能控制开关
	["solarEnergyEn"] = 0,
	-- 太阳能利用方式
	["solarUseWay"] = 0,
	-- 强制杀菌开关
	["forceSterilizeEn"] = 0,
	-- 休假控制开关
	["vacationEn"] = 0,
	-- 杀菌控制开关
	["sterilizeEn"] = 0,
	-- 热泵开启温度下限
	["heatPumpWorkTempLimit"] = 0,

	-- 静音定时器1开关
	["muteTimer1En"] = 0,
	-- 静音定时器1静音等级
	["muteTimer1Lev"] = 0,
	-- 静音定时器1开始时间：时
	["muteTimer1StartTimeHour"] = 0,
	-- 静音定时器1开始时间：分
	["muteTimer1StartTimeMin"] = 0,
	-- 静音定时器2开关
	["muteTimer2En"] = 0,
	-- 静音定时器2静音等级
	["muteTimer2Lev"] = 0,
	-- 静音定时器2开始时间：时
	["muteTimer2StartTimeHour"] = 0,
	-- 静音定时器2开始时间：分
	["muteTimer2StartTimeMin"] = 0,
	-- 静音定时器3开关
	["muteTimer3En"] = 0,
	-- 静音定时器3静音等级
	["muteTimer3Lev"] = 0,
	-- 静音定时器3开始时间：时
	["muteTimer3StartTimeHour"] = 0,
	-- 静音定时器3开始时间：分
	["muteTimer3StartTimeMin"] = 0,
	-- 静音定时器4开关
	["muteTimer4En"] = 0,
	-- 静音定时器4静音等级
	["muteTimer4Lev"] = 0,
	-- 静音定时器4开始时间：时
	["muteTimer4StartTimeHour"] = 0,
	-- 静音定时器4开始时间：分
	["muteTimer4StartTimeMin"] = 0,
	-- 静音定时器5开关
	["muteTimer5En"] = 0,
	-- 静音定时器5静音等级
	["muteTimer5Lev"] = 0,
	-- 静音定时器5开始时间：时
	["muteTimer5StartTimeHour"] = 0,
	-- 静音定时器5开始时间：分
	["muteTimer5StartTimeMin"] = 0,
	-- 静音定时器6开关
	["muteTimer6En"] = 0,
	-- 静音定时器6静音等级
	["muteTimer6Lev"] = 0,
	-- 静音定时器6开始时间：时
	["muteTimer6StartTimeHour"] = 0,
	-- 静音定时器6开始时间：分
	["muteTimer6StartTimeMin"] = 0,

	-- 强热定时器1开关
	["forceHeatTimer1En"] = 0,
	-- 强热定时器1开始时间：时
	["forceHeatTimer1StartTimeHour"] = 0,
	-- 强热定时器1开始时间：分
	["forceHeatTimer1StartTimeMin"] = 0,
	-- 强热定时器2开关
	["forceHeatTimer2En"] = 0,
	-- 强热定时器2开始时间：时
	["forceHeatTimer2StartTimeHour"] = 0,
	-- 强热定时器2开始时间：分
	["forceHeatTimer2StartTimeMin"] = 0,
	-- 强热定时器3开关
	["forceHeatTimer3En"] = 0,
	-- 强热定时器3开始时间：时
	["forceHeatTimer3StartTimeHour"] = 0,
	-- 强热定时器3开始时间：分
	["forceHeatTimer3StartTimeMin"] = 0,
	-- 强热定时器4开关
	["forceHeatTimer4En"] = 0,
	-- 强热定时器4开始时间：时
	["forceHeatTimer4StartTimeHour"] = 0,
	-- 强热定时器4开始时间：分
	["forceHeatTimer4StartTimeMin"] = 0,
	-- 强热定时器5开关
	["forceHeatTimer5En"] = 0,
	-- 强热定时器5开始时间：时
	["forceHeatTimer5StartTimeHour"] = 0,
	-- 强热定时器5开始时间：分
	["forceHeatTimer5StartTimeMin"] = 0,
	-- 强热定时器6开关
	["forceHeatTimer6En"] = 0,
	-- 强热定时器6开始时间：时
	["forceHeatTimer6StartTimeHour"] = 0,
	-- 强热定时器6开始时间：分
	["forceHeatTimer6StartTimeMin"] = 0,

	-- 周日定时器1设定模式
	["week0timer1SetMode"] = 0,
	-- 周日定时器1设定温度
	["week0timer1SetTemp"] = 0,
	-- 周日定时器1开始时间：时
	["week0timer1OpenTimeHour"] = 0,
	-- 周日定时器1开始时间：分
	["week0timer1OpenTimeMin"] = 0,
	-- 周日定时器1结束时间：时
	["week0timer1CloseTimeHour"] = 0,
	-- 周日定时器1结束时间：分
	["week0timer1CloseTimeMin"] = 0,
	-- 周日定时器2设定模式
	["week0timer2SetMode"] = 0,
	-- 周日定时器2设定温度
	["week0timer2SetTemp"] = 0,
	-- 周日定时器2开始时间：时
	["week0timer2OpenTimeHour"] = 0,
	-- 周日定时器2开始时间：分
	["week0timer2OpenTimeMin"] = 0,
	-- 周日定时器2结束时间：时
	["week0timer2CloseTimeHour"] = 0,
	-- 周日定时器2结束时间：分
	["week0timer2CloseTimeMin"] = 0,
	-- 周日定时器3设定模式
	["week0timer3SetMode"] = 0,
	-- 周日定时器3设定温度
	["week0timer3SetTemp"] = 0,
	-- 周日定时器3开始时间：时
	["week0timer3OpenTimeHour"] = 0,
	-- 周日定时器3开始时间：分
	["week0timer3OpenTimeMin"] = 0,
	-- 周日定时器3结束时间：时
	["week0timer3CloseTimeHour"] = 0,
	-- 周日定时器3结束时间：分
	["week0timer3CloseTimeMin"] = 0,
	-- 周日定时器4设定模式
	["week0timer4SetMode"] = 0,
	-- 周日定时器4设定温度
	["week0timer4SetTemp"] = 0,
	-- 周日定时器4开始时间：时
	["week0timer4OpenTimeHour"] = 0,
	-- 周日定时器4开始时间：分
	["week0timer4OpenTimeMin"] = 0,
	-- 周日定时器4结束时间：时
	["week0timer4CloseTimeHour"] = 0,
	-- 周日定时器4结束时间：分
	["week0timer4CloseTimeMin"] = 0,
	-- 周日定时器5设定模式
	["week0timer5SetMode"] = 0,
	-- 周日定时器5设定温度
	["week0timer5SetTemp"] = 0,
	-- 周日定时器5开始时间：时
	["week0timer5OpenTimeHour"] = 0,
	-- 周日定时器5开始时间：分
	["week0timer5OpenTimeMin"] = 0,
	-- 周日定时器5结束时间：时
	["week0timer5CloseTimeHour"] = 0,
	-- 周日定时器5结束时间：分
	["week0timer5CloseTimeMin"] = 0,
	-- 周日定时器6设定模式
	["week0timer6SetMode"] = 0,
	-- 周日定时器6设定温度
	["week0timer6SetTemp"] = 0,
	-- 周日定时器6开始时间：时
	["week0timer6OpenTimeHour"] = 0,
	-- 周日定时器6开始时间：分
	["week0timer6OpenTimeMin"] = 0,
	-- 周日定时器6结束时间：时
	["week0timer6CloseTimeHour"] = 0,
	-- 周日定时器6结束时间：分
	["week0timer6CloseTimeMin"] = 0,

	-- 周一定时器1设定模式
	["week1timer1SetMode"] = 0,
	-- 周一定时器1设定温度
	["week1timer1SetTemp"] = 0,
	-- 周一定时器1开始时间：时
	["week1timer1OpenTimeHour"] = 0,
	-- 周一定时器1开始时间：分
	["week1timer1OpenTimeMin"] = 0,
	-- 周一定时器1结束时间：时
	["week1timer1CloseTimeHour"] = 0,
	-- 周一定时器1结束时间：分
	["week1timer1CloseTimeMin"] = 0,
	-- 周一定时器2设定模式
	["week1timer2SetMode"] = 0,
	-- 周一定时器2设定温度
	["week1timer2SetTemp"] = 0,
	-- 周一定时器2开始时间：时
	["week1timer2OpenTimeHour"] = 0,
	-- 周一定时器2开始时间：分
	["week1timer2OpenTimeMin"] = 0,
	-- 周一定时器2结束时间：时
	["week1timer2CloseTimeHour"] = 0,
	-- 周一定时器2结束时间：分
	["week1timer2CloseTimeMin"] = 0,
	-- 周一定时器3设定模式
	["week1timer3SetMode"] = 0,
	-- 周一定时器3设定温度
	["week1timer3SetTemp"] = 0,
	-- 周一定时器3开始时间：时
	["week1timer3OpenTimeHour"] = 0,
	-- 周一定时器3开始时间：分
	["week1timer3OpenTimeMin"] = 0,
	-- 周一定时器3结束时间：时
	["week1timer3CloseTimeHour"] = 0,
	-- 周一定时器3结束时间：分
	["week1timer3CloseTimeMin"] = 0,
	-- 周一定时器4设定模式
	["week1timer4SetMode"] = 0,
	-- 周一定时器4设定温度
	["week1timer4SetTemp"] = 0,
	-- 周一定时器4开始时间：时
	["week1timer4OpenTimeHour"] = 0,
	-- 周一定时器4开始时间：分
	["week1timer4OpenTimeMin"] = 0,
	-- 周一定时器4结束时间：时
	["week1timer4CloseTimeHour"] = 0,
	-- 周一定时器4结束时间：分
	["week1timer4CloseTimeMin"] = 0,
	-- 周一定时器5设定模式
	["week1timer5SetMode"] = 0,
	-- 周一定时器5设定温度
	["week1timer5SetTemp"] = 0,
	-- 周一定时器5开始时间：时
	["week1timer5OpenTimeHour"] = 0,
	-- 周一定时器5开始时间：分
	["week1timer5OpenTimeMin"] = 0,
	-- 周一定时器5结束时间：时
	["week1timer5CloseTimeHour"] = 0,
	-- 周一定时器5结束时间：分
	["week1timer5CloseTimeMin"] = 0,
	-- 周一定时器6设定模式
	["week1timer6SetMode"] = 0,
	-- 周一定时器6设定温度
	["week1timer6SetTemp"] = 0,
	-- 周一定时器6开始时间：时
	["week1timer6OpenTimeHour"] = 0,
	-- 周一定时器6开始时间：分
	["week1timer6OpenTimeMin"] = 0,
	-- 周一定时器6结束时间：时
	["week1timer6CloseTimeHour"] = 0,
	-- 周一定时器6结束时间：分
	["week1timer6CloseTimeMin"] = 0,

	-- 周二定时器1设定模式
	["week2timer1SetMode"] = 0,
	-- 周二定时器1设定温度
	["week2timer1SetTemp"] = 0,
	-- 周二定时器1开始时间：时
	["week2timer1OpenTimeHour"] = 0,
	-- 周二定时器1开始时间：分
	["week2timer1OpenTimeMin"] = 0,
	-- 周二定时器1结束时间：时
	["week2timer1CloseTimeHour"] = 0,
	-- 周二定时器1结束时间：分
	["week2timer1CloseTimeMin"] = 0,
	-- 周二定时器2设定模式
	["week2timer2SetMode"] = 0,
	-- 周二定时器2设定温度
	["week2timer2SetTemp"] = 0,
	-- 周二定时器2开始时间：时
	["week2timer2OpenTimeHour"] = 0,
	-- 周二定时器2开始时间：分
	["week2timer2OpenTimeMin"] = 0,
	-- 周二定时器2结束时间：时
	["week2timer2CloseTimeHour"] = 0,
	-- 周二定时器2结束时间：分
	["week2timer2CloseTimeMin"] = 0,
	-- 周二定时器3设定模式
	["week2timer3SetMode"] = 0,
	-- 周二定时器3设定温度
	["week2timer3SetTemp"] = 0,
	-- 周二定时器3开始时间：时
	["week2timer3OpenTimeHour"] = 0,
	-- 周二定时器3开始时间：分
	["week2timer3OpenTimeMin"] = 0,
	-- 周二定时器3结束时间：时
	["week2timer3CloseTimeHour"] = 0,
	-- 周二定时器3结束时间：分
	["week2timer3CloseTimeMin"] = 0,
	-- 周二定时器4设定模式
	["week2timer4SetMode"] = 0,
	-- 周二定时器4设定温度
	["week2timer4SetTemp"] = 0,
	-- 周二定时器4开始时间：时
	["week2timer4OpenTimeHour"] = 0,
	-- 周二定时器4开始时间：分
	["week2timer4OpenTimeMin"] = 0,
	-- 周二定时器4结束时间：时
	["week2timer4CloseTimeHour"] = 0,
	-- 周二定时器4结束时间：分
	["week2timer4CloseTimeMin"] = 0,
	-- 周二定时器5设定模式
	["week2timer5SetMode"] = 0,
	-- 周二定时器5设定温度
	["week2timer5SetTemp"] = 0,
	-- 周二定时器5开始时间：时
	["week2timer5OpenTimeHour"] = 0,
	-- 周二定时器5开始时间：分
	["week2timer5OpenTimeMin"] = 0,
	-- 周二定时器5结束时间：时
	["week2timer5CloseTimeHour"] = 0,
	-- 周二定时器5结束时间：分
	["week2timer5CloseTimeMin"] = 0,
	-- 周二定时器6设定模式
	["week2timer6SetMode"] = 0,
	-- 周二定时器6设定温度
	["week2timer6SetTemp"] = 0,
	-- 周二定时器6开始时间：时
	["week2timer6OpenTimeHour"] = 0,
	-- 周二定时器6开始时间：分
	["week2timer6OpenTimeMin"] = 0,
	-- 周二定时器6结束时间：时
	["week2timer6CloseTimeHour"] = 0,
	-- 周二定时器6结束时间：分
	["week2timer6CloseTimeMin"] = 0,

	-- 周三定时器1设定模式
	["week3timer1SetMode"] = 0,
	-- 周三定时器1设定温度
	["week3timer1SetTemp"] = 0,
	-- 周三定时器1开始时间：时
	["week3timer1OpenTimeHour"] = 0,
	-- 周三定时器1开始时间：分
	["week3timer1OpenTimeMin"] = 0,
	-- 周三定时器1结束时间：时
	["week3timer1CloseTimeHour"] = 0,
	-- 周三定时器1结束时间：分
	["week3timer1CloseTimeMin"] = 0,
	-- 周三定时器2设定模式
	["week3timer2SetMode"] = 0,
	-- 周三定时器2设定温度
	["week3timer2SetTemp"] = 0,
	-- 周三定时器2开始时间：时
	["week3timer2OpenTimeHour"] = 0,
	-- 周三定时器2开始时间：分
	["week3timer2OpenTimeMin"] = 0,
	-- 周三定时器2结束时间：时
	["week3timer2CloseTimeHour"] = 0,
	-- 周三定时器2结束时间：分
	["week3timer2CloseTimeMin"] = 0,
	-- 周三定时器3设定模式
	["week3timer3SetMode"] = 0,
	-- 周三定时器3设定温度
	["week3timer3SetTemp"] = 0,
	-- 周三定时器3开始时间：时
	["week3timer3OpenTimeHour"] = 0,
	-- 周三定时器3开始时间：分
	["week3timer3OpenTimeMin"] = 0,
	-- 周三定时器3结束时间：时
	["week3timer3CloseTimeHour"] = 0,
	-- 周三定时器3结束时间：分
	["week3timer3CloseTimeMin"] = 0,
	-- 周三定时器4设定模式
	["week3timer4SetMode"] = 0,
	-- 周三定时器4设定温度
	["week3timer4SetTemp"] = 0,
	-- 周三定时器4开始时间：时
	["week3timer4OpenTimeHour"] = 0,
	-- 周三定时器4开始时间：分
	["week3timer4OpenTimeMin"] = 0,
	-- 周三定时器4结束时间：时
	["week3timer4CloseTimeHour"] = 0,
	-- 周三定时器4结束时间：分
	["week3timer4CloseTimeMin"] = 0,
	-- 周三定时器5设定模式
	["week3timer5SetMode"] = 0,
	-- 周三定时器5设定温度
	["week3timer5SetTemp"] = 0,
	-- 周三定时器5开始时间：时
	["week3timer5OpenTimeHour"] = 0,
	-- 周三定时器5开始时间：分
	["week3timer5OpenTimeMin"] = 0,
	-- 周三定时器5结束时间：时
	["week3timer5CloseTimeHour"] = 0,
	-- 周三定时器5结束时间：分
	["week3timer5CloseTimeMin"] = 0,
	-- 周三定时器6设定模式
	["week3timer6SetMode"] = 0,
	-- 周三定时器6设定温度
	["week3timer6SetTemp"] = 0,
	-- 周三定时器6开始时间：时
	["week3timer6OpenTimeHour"] = 0,
	-- 周三定时器6开始时间：分
	["week3timer6OpenTimeMin"] = 0,
	-- 周三定时器6结束时间：时
	["week3timer6CloseTimeHour"] = 0,
	-- 周三定时器6结束时间：分
	["week3timer6CloseTimeMin"] = 0,

	-- 周四定时器1设定模式
	["week4timer1SetMode"] = 0,
	-- 周四定时器1设定温度
	["week4timer1SetTemp"] = 0,
	-- 周四定时器1开始时间：时
	["week4timer1OpenTimeHour"] = 0,
	-- 周四定时器1开始时间：分
	["week4timer1OpenTimeMin"] = 0,
	-- 周四定时器1结束时间：时
	["week4timer1CloseTimeHour"] = 0,
	-- 周四定时器1结束时间：分
	["week4timer1CloseTimeMin"] = 0,
	-- 周四定时器2设定模式
	["week4timer2SetMode"] = 0,
	-- 周四定时器2设定温度
	["week4timer2SetTemp"] = 0,
	-- 周四定时器2开始时间：时
	["week4timer2OpenTimeHour"] = 0,
	-- 周四定时器2开始时间：分
	["week4timer2OpenTimeMin"] = 0,
	-- 周四定时器2结束时间：时
	["week4timer2CloseTimeHour"] = 0,
	-- 周四定时器2结束时间：分
	["week4timer2CloseTimeMin"] = 0,
	-- 周四定时器3设定模式
	["week4timer3SetMode"] = 0,
	-- 周四定时器3设定温度
	["week4timer3SetTemp"] = 0,
	-- 周四定时器3开始时间：时
	["week4timer3OpenTimeHour"] = 0,
	-- 周四定时器3开始时间：分
	["week4timer3OpenTimeMin"] = 0,
	-- 周四定时器3结束时间：时
	["week4timer3CloseTimeHour"] = 0,
	-- 周四定时器3结束时间：分
	["week4timer3CloseTimeMin"] = 0,
	-- 周四定时器4设定模式
	["week4timer4SetMode"] = 0,
	-- 周四定时器4设定温度
	["week4timer4SetTemp"] = 0,
	-- 周四定时器4开始时间：时
	["week4timer4OpenTimeHour"] = 0,
	-- 周四定时器4开始时间：分
	["week4timer4OpenTimeMin"] = 0,
	-- 周四定时器4结束时间：时
	["week4timer4CloseTimeHour"] = 0,
	-- 周四定时器4结束时间：分
	["week4timer4CloseTimeMin"] = 0,
	-- 周四定时器5设定模式
	["week4timer5SetMode"] = 0,
	-- 周四定时器5设定温度
	["week4timer5SetTemp"] = 0,
	-- 周四定时器5开始时间：时
	["week4timer5OpenTimeHour"] = 0,
	-- 周四定时器5开始时间：分
	["week4timer5OpenTimeMin"] = 0,
	-- 周四定时器5结束时间：时
	["week4timer5CloseTimeHour"] = 0,
	-- 周四定时器5结束时间：分
	["week4timer5CloseTimeMin"] = 0,
	-- 周四定时器6设定模式
	["week4timer6SetMode"] = 0,
	-- 周四定时器6设定温度
	["week4timer6SetTemp"] = 0,
	-- 周四定时器6开始时间：时
	["week4timer6OpenTimeHour"] = 0,
	-- 周四定时器6开始时间：分
	["week4timer6OpenTimeMin"] = 0,
	-- 周四定时器6结束时间：时
	["week4timer6CloseTimeHour"] = 0,
	-- 周四定时器6结束时间：分
	["week4timer6CloseTimeMin"] = 0,

	-- 周五定时器1设定模式
	["week5timer1SetMode"] = 0,
	-- 周五定时器1设定温度
	["week5timer1SetTemp"] = 0,
	-- 周五定时器1开始时间：时
	["week5timer1OpenTimeHour"] = 0,
	-- 周五定时器1开始时间：分
	["week5timer1OpenTimeMin"] = 0,
	-- 周五定时器1结束时间：时
	["week5timer1CloseTimeHour"] = 0,
	-- 周五定时器1结束时间：分
	["week5timer1CloseTimeMin"] = 0,
	-- 周五定时器2设定模式
	["week5timer2SetMode"] = 0,
	-- 周五定时器2设定温度
	["week5timer2SetTemp"] = 0,
	-- 周五定时器2开始时间：时
	["week5timer2OpenTimeHour"] = 0,
	-- 周五定时器2开始时间：分
	["week5timer2OpenTimeMin"] = 0,
	-- 周五定时器2结束时间：时
	["week5timer2CloseTimeHour"] = 0,
	-- 周五定时器2结束时间：分
	["week5timer2CloseTimeMin"] = 0,
	-- 周五定时器3设定模式
	["week5timer3SetMode"] = 0,
	-- 周五定时器3设定温度
	["week5timer3SetTemp"] = 0,
	-- 周五定时器3开始时间：时
	["week5timer3OpenTimeHour"] = 0,
	-- 周五定时器3开始时间：分
	["week5timer3OpenTimeMin"] = 0,
	-- 周五定时器3结束时间：时
	["week5timer3CloseTimeHour"] = 0,
	-- 周五定时器3结束时间：分
	["week5timer3CloseTimeMin"] = 0,
	-- 周五定时器4设定模式
	["week5timer4SetMode"] = 0,
	-- 周五定时器4设定温度
	["week5timer4SetTemp"] = 0,
	-- 周五定时器4开始时间：时
	["week5timer4OpenTimeHour"] = 0,
	-- 周五定时器4开始时间：分
	["week5timer4OpenTimeMin"] = 0,
	-- 周五定时器4结束时间：时
	["week5timer4CloseTimeHour"] = 0,
	-- 周五定时器4结束时间：分
	["week5timer4CloseTimeMin"] = 0,
	-- 周五定时器5设定模式
	["week5timer5SetMode"] = 0,
	-- 周五定时器5设定温度
	["week5timer5SetTemp"] = 0,
	-- 周五定时器5开始时间：时
	["week5timer5OpenTimeHour"] = 0,
	-- 周五定时器5开始时间：分
	["week5timer5OpenTimeMin"] = 0,
	-- 周五定时器5结束时间：时
	["week5timer5CloseTimeHour"] = 0,
	-- 周五定时器5结束时间：分
	["week5timer5CloseTimeMin"] = 0,
	-- 周五定时器6设定模式
	["week5timer6SetMode"] = 0,
	-- 周五定时器6设定温度
	["week5timer6SetTemp"] = 0,
	-- 周五定时器6开始时间：时
	["week5timer6OpenTimeHour"] = 0,
	-- 周五定时器6开始时间：分
	["week5timer6OpenTimeMin"] = 0,
	-- 周五定时器6结束时间：时
	["week5timer6CloseTimeHour"] = 0,
	-- 周五定时器6结束时间：分
	["week5timer6CloseTimeMin"] = 0,

	-- 周六定时器1设定模式
	["week6timer1SetMode"] = 0,
	-- 周六定时器1设定温度
	["week6timer1SetTemp"] = 0,
	-- 周六定时器1开始时间：时
	["week6timer1OpenTimeHour"] = 0,
	-- 周六定时器1开始时间：分
	["week6timer1OpenTimeMin"] = 0,
	-- 周六定时器1结束时间：时
	["week6timer1CloseTimeHour"] = 0,
	-- 周六定时器1结束时间：分
	["week6timer1CloseTimeMin"] = 0,
	-- 周六定时器2设定模式
	["week6timer2SetMode"] = 0,
	-- 周六定时器2设定温度
	["week6timer2SetTemp"] = 0,
	-- 周六定时器2开始时间：时
	["week6timer2OpenTimeHour"] = 0,
	-- 周六定时器2开始时间：分
	["week6timer2OpenTimeMin"] = 0,
	-- 周六定时器2结束时间：时
	["week6timer2CloseTimeHour"] = 0,
	-- 周六定时器2结束时间：分
	["week6timer2CloseTimeMin"] = 0,
	-- 周六定时器3设定模式
	["week6timer3SetMode"] = 0,
	-- 周六定时器3设定温度
	["week6timer3SetTemp"] = 0,
	-- 周六定时器3开始时间：时
	["week6timer3OpenTimeHour"] = 0,
	-- 周六定时器3开始时间：分
	["week6timer3OpenTimeMin"] = 0,
	-- 周六定时器3结束时间：时
	["week6timer3CloseTimeHour"] = 0,
	-- 周六定时器3结束时间：分
	["week6timer3CloseTimeMin"] = 0,
	-- 周六定时器4设定模式
	["week6timer4SetMode"] = 0,
	-- 周六定时器4设定温度
	["week6timer4SetTemp"] = 0,
	-- 周六定时器4开始时间：时
	["week6timer4OpenTimeHour"] = 0,
	-- 周六定时器4开始时间：分
	["week6timer4OpenTimeMin"] = 0,
	-- 周六定时器4结束时间：时
	["week6timer4CloseTimeHour"] = 0,
	-- 周六定时器4结束时间：分
	["week6timer4CloseTimeMin"] = 0,
	-- 周六定时器5设定模式
	["week6timer5SetMode"] = 0,
	-- 周六定时器5设定温度
	["week6timer5SetTemp"] = 0,
	-- 周六定时器5开始时间：时
	["week6timer5OpenTimeHour"] = 0,
	-- 周六定时器5开始时间：分
	["week6timer5OpenTimeMin"] = 0,
	-- 周六定时器5结束时间：时
	["week6timer5CloseTimeHour"] = 0,
	-- 周六定时器5结束时间：分
	["week6timer5CloseTimeMin"] = 0,
	-- 周六定时器6设定模式
	["week6timer6SetMode"] = 0,
	-- 周六定时器6设定温度
	["week6timer6SetTemp"] = 0,
	-- 周六定时器6开始时间：时
	["week6timer6OpenTimeHour"] = 0,
	-- 周六定时器6开始时间：分
	["week6timer6OpenTimeMin"] = 0,
	-- 周六定时器6结束时间：时
	["week6timer6CloseTimeHour"] = 0,
	-- 周六定时器6结束时间：分
	["week6timer6CloseTimeMin"] = 0,

	-- 设置年
	["setYear"] = 0,
	-- 设置月
	["setMonth"] = 0,
	-- 设置日
	["setDay"] = 0,
	-- 设置星期
	["setWeek"] = 0,
	-- 设置时
	["setHour"] = 0,
	-- 设置分
	["setMinute"] = 0,

	-- 热量
	["hpcValue"] = 0,

	-- 外机SN码
	["oduSNCode"] = "",

	-- 自动上报时间
	["setPeriodicReport"] = 15,

	["tseh_temp"] = 0x7fff,
	["treh_temp"] = 0x7fff,
	["t5u_temp"] = 0x7fff,
	["eheat_current"] = 0,
	["power_total"] = 0,
	["eheat_total_kwh"] = 0,
	["comp_total_kwh"] = 0,
	["eheat_24h_kwh"] = 0,
	["comp_24h_kwh"] = 0,
	["fg_IBHEnable"] = 1, -- 默认有效（由于氟循环默认有）
}
-------------一些公共函数------------
-- 打印 table 表
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

-- 检查取值是否超过边界
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

-- String转int
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

-- int转String
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

-- table 转 string
local function table2string(cmd)
	local ret = ""
	local i

	for i = 1, #cmd do
		ret = ret .. string.char(cmd[i])
	end

	return ret
end

-- 十六进制 string 转 table
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

-- 十六进制 string 输出
local function string2hexstring(str)
	local ret = ""

	for i = 1, #str do
		ret = ret .. string.format("%02x", str:byte(i))
	end

	return ret
end

-- table 转 json
local function encode(cmd)
	local tb

	if JSON == nil then
		JSON = require("cjson")
	end

	tb = JSON.encode(cmd)

	return tb
end

-- json 转 table
local function decode(cmd)
	local tb

	if JSON == nil then
		JSON = require("cjson")
	end

	tb = JSON.decode(cmd)

	return tb
end

-- sum校验
local function makeSum(tmpbuf, start_pos, end_pos)
	local resVal = 0
	for si = start_pos, end_pos do
		resVal = resVal + tmpbuf[si]
	end
	resVal = bit.bnot(resVal) + 1
	resVal = bit.band(resVal, 0x00ff)
	return resVal
end

-- CRC表
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

-- CRC校验
local function crc8_854(dataBuf, start_pos, end_pos)
	local crc = 0

	for si = start_pos, end_pos do
		crc = crc8_854_table[bit.band(bit.bxor(crc, dataBuf[si]), 0xFF) + 1]
	end

	return crc
end

-- String转int
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

-- int转String
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
-----------根据电控协议不同，需要改变的函数-------------

local function getTotalMsg(bodyData, cType)
	local bodyLength = #bodyData
	local msgLength = bodyLength + BYTE_PROTOCOL_LENGTH + 1
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end

	-- 构造消息部分
	msgBytes[0] = BYTE_PROTOCOL_HEAD
	msgBytes[1] = bodyLength + BYTE_PROTOCOL_LENGTH + 1
	msgBytes[2] = BYTE_DEVICE_TYPE
	msgBytes[9] = cType
	-- body
	for i = 0, bodyLength do
		msgBytes[i + BYTE_PROTOCOL_LENGTH] = bodyData[i]
	end

	msgBytes[msgLength] = makeSum(msgBytes, 1, msgLength - 1)

	local msgFinal = {}

	for i = 1, msgLength + 1 do
		msgFinal[i] = msgBytes[i - 1]
	end

	return msgFinal
end

-- 根据 json 修改属性变量
local function jsonToModel(controlJson)
	local controlCmd = controlJson

	-- 控制命令类型
	myTable["controlType"] = 0x01
	if controlCmd["control_type"] ~= nil then
		myTable["controlType"] = string2Int(controlCmd["control_type"])
	end

	-- 0x01 : 基本控制
	-- 0x02 : 预留
	-- 0x03 : 静音和强热定时控制
	-- 0x04~0x0a : 周日~周六定时控制
	-- 0x0b : 普通定时控制
	if myTable["controlType"] == 0x01 then
		-- 模式设定
		if controlCmd[KEY_MODE] ~= nil then
			if controlCmd[KEY_MODE] == "off" then
				myTable["modeValue"] = 0x00
			elseif controlCmd[KEY_MODE] == "heat" then
				myTable["modeValue"] = 0x01
			elseif controlCmd[KEY_MODE] == "dhw" then
				myTable["modeValue"] = 0x02
			elseif controlCmd[KEY_MODE] == "cool" then
				myTable["modeValue"] = 0x03
			elseif controlCmd[KEY_MODE] == "waterpump" then
				myTable["modeValue"] = 0x04
			elseif controlCmd[KEY_MODE] == "auto" then
				myTable["modeValue"] = 0x05
			end
		end

		-- 温度设定TS
		if controlCmd["set_temperature"] ~= nil then
			myTable["tsValue"] = string2Int(controlCmd["set_temperature"]) + TEMP_OFFSET
		end

		-- 电加热开启环境温度Td设定
		if controlCmd["ptc_temperature"] ~= nil then
			myTable["ptcTemp"] = string2Int(controlCmd["ptc_temperature"]) + TEMP_OFFSET
		end

		-- 热水开机回差Trdh设定
		if controlCmd["tr_temperature"] ~= nil then
			myTable["trValue"] = string2Int(controlCmd["tr_temperature"]) + TEMP_OFFSET
			-- myTable["trValue"] = checkBoundary(myTable["trValue"], 2, 6)
		end

		-- 杀菌时间：时
		if controlCmd["sterilize_hour"] ~= nil then
			myTable["sterilizeHour"] = string2Int(controlCmd["sterilize_hour"])
			-- myTable["sterilizeHour"] = checkBoundary(myTable["sterilizeHour"], 0, 23)
		end

		-- 杀菌时间：分
		if controlCmd["sterilize_min"] ~= nil then
			myTable["sterilizeMinute"] = string2Int(controlCmd["sterilize_min"])
		end

		-- 杀菌设定温度
		if controlCmd["sterilize_temperature"] ~= nil then
			myTable["sterilizeTs"] = string2Int(controlCmd["sterilize_temperature"]) + TEMP_OFFSET
		end

		-- 杀菌周期：天
		if controlCmd["sterilize_cycle"] ~= nil then
			myTable["sterilizeCycle"] = string2Int(controlCmd["sterilize_cycle"])
		end

		-- 休假开始日期：年
		if controlCmd["set_vacation_start_year"] ~= nil then
			myTable["vacadaysStartYearValue"] = string2Int(controlCmd["set_vacation_start_year"])
		end

		---休假开始日期：月
		if controlCmd["set_vacation_start_month"] ~= nil then
			myTable["vacadaysStartMonthValue"] = string2Int(controlCmd["set_vacation_start_month"])
		end

		---休假开始日期：日
		if controlCmd["set_vacation_start_day"] ~= nil then
			myTable["vacadaysStartDayValue"] = string2Int(controlCmd["set_vacation_start_day"])
		end

		-- 休假结束日期：年
		if controlCmd["set_vacation_end_year"] ~= nil then
			myTable["vacadaysEndYearValue"] = string2Int(controlCmd["set_vacation_end_year"])
		end

		---休假结束日期：月
		if controlCmd["set_vacation_end_month"] ~= nil then
			myTable["vacadaysEndMonthValue"] = string2Int(controlCmd["set_vacation_end_month"])
		end

		---休假结束日期：日
		if controlCmd["set_vacation_end_day"] ~= nil then
			myTable["vacadaysEndDayValue"] = string2Int(controlCmd["set_vacation_end_day"])
		end

		---度假模式设定
		if controlCmd["set_vacation_mode"] ~= nil then
			if controlCmd["set_vacation_mode"] == "off" then
				myTable["vacationMode"] = 0x00
			elseif controlCmd["set_vacation_mode"] == "heat" then
				myTable["vacationMode"] = 0x01
			elseif controlCmd["set_vacation_mode"] == "dhw" then
				myTable["vacationMode"] = 0x02
			elseif controlCmd["set_vacation_mode"] == "cool" then
				myTable["vacationMode"] = 0x03
			elseif controlCmd["set_vacation_mode"] == "waterpump" then
				myTable["vacationMode"] = 0x04
			elseif controlCmd["set_vacation_mode"] == "auto" then
				myTable["vacationMode"] = 0x05
			end
		end

		-- 静音等级
		if controlCmd["mute_lev"] ~= nil then
			if controlCmd["mute_lev"] == VALUE_MUTE_LEV2 then
				myTable["muteLev"] = 0x01
			elseif controlCmd["mute_lev"] == VALUE_MUTE_LEV1 then
				myTable["muteLev"] = 0x00
			end
		end

		-- 静音开关
		if controlCmd["mute_en"] ~= nil then
			if controlCmd["mute_en"] == VALUE_FUNCTION_ON then
				myTable["mute"] = 0x01
			elseif controlCmd["mute_en"] == VALUE_FUNCTION_OFF then
				myTable["mute"] = 0x00
			end
		end

		-- 强热开关
		if controlCmd["force_heat"] ~= nil then
			if controlCmd["force_heat"] == VALUE_FUNCTION_ON then
				myTable["forceHeat"] = 0x02
			elseif controlCmd["force_heat"] == VALUE_FUNCTION_OFF then
				myTable["forceHeat"] = 0x00
			end
		end

		-- SmartGrid开关
		if controlCmd["smart_grid"] ~= nil then
			if controlCmd["smart_grid"] == VALUE_FUNCTION_ON then
				myTable["smartGrid"] = 0x80
			elseif controlCmd["smart_grid"] == VALUE_FUNCTION_OFF then
				myTable["smartGrid"] = 0x00
			end
		end

		-- 峰谷电开关
		if controlCmd["opt_backup_en"] ~= nil then
			if controlCmd["opt_backup_en"] == VALUE_FUNCTION_ON then
				myTable["optBackupEn"] = 0x01
			elseif controlCmd["opt_backup_en"] == VALUE_FUNCTION_OFF then
				myTable["optBackupEn"] = 0x00
			end
		end

		-- 燃气复合开关
		if controlCmd["hybrid_en"] ~= nil then
			if controlCmd["hybrid_en"] == VALUE_FUNCTION_ON then
				myTable["hybridEn"] = 0x02
			elseif controlCmd["hybrid_en"] == VALUE_FUNCTION_OFF then
				myTable["hybridEn"] = 0x00
			end
		end

		-- 太阳能开关
		if controlCmd["solar_energy_en"] ~= nil then
			if controlCmd["solar_energy_en"] == VALUE_FUNCTION_ON then
				myTable["solarEnergyEn"] = 0x04
			elseif controlCmd["solar_energy_en"] == VALUE_FUNCTION_OFF then
				myTable["solarEnergyEn"] = 0x00
			end
		end

		-- 太阳能利用方式
		if controlCmd["solar_use_way"] ~= nil then
			if controlCmd["solar_use_way"] == VALUE_FUNCTION_ON then
				myTable["solarUseWay"] = 0x08
			elseif controlCmd["solar_use_way"] == VALUE_FUNCTION_OFF then
				myTable["solarUseWay"] = 0x00
			end
		end

		-- 强制电辅热开关
		if controlCmd["open_ptc"] ~= nil then
			if controlCmd["open_ptc"] == VALUE_FUNCTION_ON then
				myTable["openPTC"] = 0x10
			elseif controlCmd["open_ptc"] == VALUE_FUNCTION_OFF then
				myTable["openPTC"] = 0x00
			end
		end

		-- 强制杀菌开关
		if controlCmd["force_sterilize_en"] ~= nil then
			if controlCmd["force_sterilize_en"] == VALUE_FUNCTION_ON then
				myTable["forceSterilizeEn"] = 0x20
			elseif controlCmd["force_sterilize_en"] == VALUE_FUNCTION_OFF then
				myTable["forceSterilizeEn"] = 0x00
			end
		end

		-- 休假开关
		if controlCmd["vacation_en"] ~= nil then
			if controlCmd["vacation_en"] == VALUE_FUNCTION_ON then
				myTable["vacationEn"] = 0x40
			elseif controlCmd["vacation_en"] == VALUE_FUNCTION_OFF then
				myTable["vacationEn"] = 0x00
			end
		end

		-- 杀菌开关
		if controlCmd["sterilize_en"] ~= nil then
			if controlCmd["sterilize_en"] == VALUE_FUNCTION_ON then
				myTable["sterilizeEn"] = 0x80
			elseif controlCmd["sterilize_en"] == VALUE_FUNCTION_OFF then
				myTable["sterilizeEn"] = 0x00
			end
		end

		---热泵开启温度下限
		if controlCmd["heat_pump_work_temp_limit"] ~= nil then
			myTable["heatPumpWorkTempLimit"] = string2Int(controlCmd["heat_pump_work_temp_limit"]) + TEMP_OFFSET
		end

		-- 设置日期信息:年
		if controlCmd["set_year"] ~= nil then
			myTable["setYear"] = string2Int(controlCmd["set_year"])
		end

		-- 设置日期信息:月
		if controlCmd["set_month"] ~= nil then
			myTable["setMonth"] = string2Int(controlCmd["set_month"])
		end

		-- 设置日期信息:日
		if controlCmd["set_day"] ~= nil then
			myTable["setDay"] = string2Int(controlCmd["set_day"])
		end

		-- 设置日期信息:星期
		if controlCmd["set_week"] ~= nil then
			myTable["setWeek"] = string2Int(controlCmd["set_week"])
		end

		-- 设置日期信息:时
		if controlCmd["set_hour"] ~= nil then
			myTable["setHour"] = string2Int(controlCmd["set_hour"])
		end

		-- 设置日期信息:分
		if controlCmd["set_minute"] ~= nil then
			myTable["setMinute"] = string2Int(controlCmd["set_minute"])
		end
	elseif myTable["controlType"] == 0x02 then
	elseif myTable["controlType"] == 0x03 then
		-- 静音定时器1是否有效
		if controlCmd["muteTimer1_valid"] ~= nil then
			if controlCmd["muteTimer1_valid"] == VALUE_VALID then
				myTable["muteTimer1Valid"] = 0x80
			elseif controlCmd["muteTimer1_valid"] == VALUE_INVALID then
				myTable["muteTimer1Valid"] = 0x00
			end
		end
		-- 静音定时器1是否有用
		if controlCmd["muteTimer1_effect"] ~= nil then
			if controlCmd["muteTimer1_effect"] == VALUE_VALID then
				myTable["muteTimer1Effect"] = BIT1
			elseif controlCmd["muteTimer1_effect"] == VALUE_INVALID then
				myTable["muteTimer1Effect"] = 0x00
			end
		end

		-- 静音定时器1开关
		if controlCmd["muteTimer1_en"] ~= nil then
			if controlCmd["muteTimer1_en"] == VALUE_FUNCTION_ON then
				myTable["muteTimer1En"] = 0x01
			elseif controlCmd["muteTimer1_en"] == VALUE_FUNCTION_OFF then
				myTable["muteTimer1En"] = 0x00
			end
		end

		-- 静音定时器1静音等级
		if controlCmd["mute_timer1_lev"] ~= nil then
			if controlCmd["mute_timer1_lev"] == VALUE_MUTE_LEV2 then
				myTable["muteTimer1Lev"] = 0x01
			elseif controlCmd["mute_timer1_lev"] == VALUE_MUTE_LEV1 then
				myTable["muteTimer1Lev"] = 0x00
			end
		end

		-- 静音定时器1开始时间：时
		if controlCmd["muteTimer1_start_time_hour"] ~= nil then
			myTable["muteTimer1StartTimeHour"] = string2Int(controlCmd["muteTimer1_start_time_hour"])
		end

		-- 静音定时器1开始时间：分
		if controlCmd["muteTimer1_start_time_min"] ~= nil then
			myTable["muteTimer1StartTimeMin"] = string2Int(controlCmd["muteTimer1_start_time_min"])
		end

		-- 静音定时器2是否有效
		if controlCmd["muteTimer2_valid"] ~= nil then
			if controlCmd["muteTimer2_valid"] == VALUE_VALID then
				myTable["muteTimer2Valid"] = 0x80
			elseif controlCmd["muteTimer2_valid"] == VALUE_INVALID then
				myTable["muteTimer2Valid"] = 0x00
			end
		end

		-- 静音定时器2是否有用
		if controlCmd["muteTimer2_effect"] ~= nil then
			if controlCmd["muteTimer2_effect"] == VALUE_VALID then
				myTable["muteTimer2Effect"] = BIT1
			elseif controlCmd["muteTimer2_effect"] == VALUE_INVALID then
				myTable["muteTimer2Effect"] = 0x00
			end
		end

		-- 静音定时器2开关
		if controlCmd["muteTimer2_en"] ~= nil then
			if controlCmd["muteTimer2_en"] == VALUE_FUNCTION_ON then
				myTable["muteTimer2En"] = 0x01
			elseif controlCmd["muteTimer2_en"] == VALUE_FUNCTION_OFF then
				myTable["muteTimer2En"] = 0x00
			end
		end

		-- 静音定时器2静音等级
		if controlCmd["mute_timer2_lev"] ~= nil then
			if controlCmd["mute_timer2_lev"] == VALUE_MUTE_LEV2 then
				myTable["muteTimer2Lev"] = 0x01
			elseif controlCmd["mute_timer2_lev"] == VALUE_MUTE_LEV1 then
				myTable["muteTimer2Lev"] = 0x00
			end
		end

		-- 静音定时器2开始时间：时
		if controlCmd["muteTimer2_start_time_hour"] ~= nil then
			myTable["muteTimer2StartTimeHour"] = string2Int(controlCmd["muteTimer2_start_time_hour"])
		end

		-- 静音定时器2开始时间：分
		if controlCmd["muteTimer2_start_time_min"] ~= nil then
			myTable["muteTimer2StartTimeMin"] = string2Int(controlCmd["muteTimer2_start_time_min"])
		end

		-- 静音定时器3是否有效
		if controlCmd["muteTimer3_valid"] ~= nil then
			if controlCmd["muteTimer3_valid"] == VALUE_VALID then
				myTable["muteTimer3Valid"] = 0x80
			elseif controlCmd["muteTimer3_valid"] == VALUE_INVALID then
				myTable["muteTimer3Valid"] = 0x00
			end
		end

		-- 静音定时器3是否有用
		if controlCmd["muteTimer3_effect"] ~= nil then
			if controlCmd["muteTimer3_effect"] == VALUE_VALID then
				myTable["muteTimer3Effect"] = BIT1
			elseif controlCmd["muteTimer3_effect"] == VALUE_INVALID then
				myTable["muteTimer3Effect"] = 0x00
			end
		end

		-- 静音定时器3开关
		if controlCmd["muteTimer3_en"] ~= nil then
			if controlCmd["muteTimer3_en"] == VALUE_FUNCTION_ON then
				myTable["muteTimer3En"] = 0x01
			elseif controlCmd["muteTimer3_en"] == VALUE_FUNCTION_OFF then
				myTable["muteTimer3En"] = 0x00
			end
		end

		-- 静音定时器3静音等级
		if controlCmd["mute_timer3_lev"] ~= nil then
			if controlCmd["mute_timer3_lev"] == VALUE_MUTE_LEV2 then
				myTable["muteTimer3Lev"] = 0x01
			elseif controlCmd["mute_timer3_lev"] == VALUE_MUTE_LEV1 then
				myTable["muteTimer3Lev"] = 0x00
			end
		end

		-- 静音定时器3开始时间：时
		if controlCmd["muteTimer3_start_time_hour"] ~= nil then
			myTable["muteTimer3StartTimeHour"] = string2Int(controlCmd["muteTimer3_start_time_hour"])
		end

		-- 静音定时器3开始时间：分
		if controlCmd["muteTimer3_start_time_min"] ~= nil then
			myTable["muteTimer3StartTimeMin"] = string2Int(controlCmd["muteTimer3_start_time_min"])
		end

		-- 静音定时器4是否有效
		if controlCmd["muteTimer4_valid"] ~= nil then
			if controlCmd["muteTimer4_valid"] == VALUE_VALID then
				myTable["muteTimer4Valid"] = 0x80
			elseif controlCmd["muteTimer4_valid"] == VALUE_INVALID then
				myTable["muteTimer4Valid"] = 0x00
			end
		end

		-- 静音定时器4是否有用
		if controlCmd["muteTimer4_effect"] ~= nil then
			if controlCmd["muteTimer4_effect"] == VALUE_VALID then
				myTable["muteTimer4Effect"] = BIT1
			elseif controlCmd["muteTimer4_effect"] == VALUE_INVALID then
				myTable["muteTimer4Effect"] = 0x00
			end
		end

		-- 静音定时器4开关
		if controlCmd["muteTimer4_en"] ~= nil then
			if controlCmd["muteTimer4_en"] == VALUE_FUNCTION_ON then
				myTable["muteTimer4En"] = 0x01
			elseif controlCmd["muteTimer4_en"] == VALUE_FUNCTION_OFF then
				myTable["muteTimer4En"] = 0x00
			end
		end

		-- 静音定时器4静音等级
		if controlCmd["mute_timer4_lev"] ~= nil then
			if controlCmd["mute_timer4_lev"] == VALUE_MUTE_LEV2 then
				myTable["muteTimer4Lev"] = 0x01
			elseif controlCmd["mute_timer4_lev"] == VALUE_MUTE_LEV1 then
				myTable["muteTimer4Lev"] = 0x00
			end
		end

		-- 静音定时器4开始时间：时
		if controlCmd["muteTimer4_start_time_hour"] ~= nil then
			myTable["muteTimer4StartTimeHour"] = string2Int(controlCmd["muteTimer4_start_time_hour"])
		end

		-- 静音定时器4开始时间：分
		if controlCmd["muteTimer4_start_time_min"] ~= nil then
			myTable["muteTimer4StartTimeMin"] = string2Int(controlCmd["muteTimer4_start_time_min"])
		end

		-- 静音定时器5是否有效
		if controlCmd["muteTimer5_valid"] ~= nil then
			if controlCmd["muteTimer5_valid"] == VALUE_VALID then
				myTable["muteTimer5Valid"] = 0x80
			elseif controlCmd["muteTimer5_valid"] == VALUE_INVALID then
				myTable["muteTimer5Valid"] = 0x00
			end
		end

		-- 静音定时器5是否有用
		if controlCmd["muteTimer5_effect"] ~= nil then
			if controlCmd["muteTimer5_effect"] == VALUE_VALID then
				myTable["muteTimer5Effect"] = BIT1
			elseif controlCmd["muteTimer5_effect"] == VALUE_INVALID then
				myTable["muteTimer5Effect"] = 0x00
			end
		end

		-- 静音定时器5开关
		if controlCmd["muteTimer5_en"] ~= nil then
			if controlCmd["muteTimer5_en"] == VALUE_FUNCTION_ON then
				myTable["muteTimer5En"] = 0x01
			elseif controlCmd["muteTimer5_en"] == VALUE_FUNCTION_OFF then
				myTable["muteTimer5En"] = 0x00
			end
		end

		-- 静音定时器5静音等级
		if controlCmd["mute_timer5_lev"] ~= nil then
			if controlCmd["mute_timer5_lev"] == VALUE_MUTE_LEV2 then
				myTable["muteTimer5Lev"] = 0x01
			elseif controlCmd["mute_timer5_lev"] == VALUE_MUTE_LEV1 then
				myTable["muteTimer5Lev"] = 0x00
			end
		end

		-- 静音定时器5开始时间：时
		if controlCmd["muteTimer5_start_time_hour"] ~= nil then
			myTable["muteTimer5StartTimeHour"] = string2Int(controlCmd["muteTimer5_start_time_hour"])
		end

		-- 静音定时器5开始时间：分
		if controlCmd["muteTimer5_start_time_min"] ~= nil then
			myTable["muteTimer5StartTimeMin"] = string2Int(controlCmd["muteTimer5_start_time_min"])
		end

		-- 静音定时器6是否有效
		if controlCmd["muteTimer6_valid"] ~= nil then
			if controlCmd["muteTimer6_valid"] == VALUE_VALID then
				myTable["muteTimer6Valid"] = 0x80
			elseif controlCmd["muteTimer6_valid"] == VALUE_INVALID then
				myTable["muteTimer6Valid"] = 0x00
			end
		end

		-- 静音定时器6是否有用
		if controlCmd["muteTimer6_effect"] ~= nil then
			if controlCmd["muteTimer6_effect"] == VALUE_VALID then
				myTable["muteTimer6Effect"] = BIT1
			elseif controlCmd["muteTimer6_effect"] == VALUE_INVALID then
				myTable["muteTimer6Effect"] = 0x00
			end
		end

		-- 静音定时器6开关
		if controlCmd["muteTimer6_en"] ~= nil then
			if controlCmd["muteTimer6_en"] == VALUE_FUNCTION_ON then
				myTable["muteTimer6En"] = 0x01
			elseif controlCmd["muteTimer6_en"] == VALUE_FUNCTION_OFF then
				myTable["muteTimer6En"] = 0x00
			end
		end

		-- 静音定时器6静音等级
		if controlCmd["mute_timer6_lev"] ~= nil then
			if controlCmd["mute_timer6_lev"] == VALUE_MUTE_LEV2 then
				myTable["muteTimer6Lev"] = 0x01
			elseif controlCmd["mute_timer6_lev"] == VALUE_MUTE_LEV1 then
				myTable["muteTimer6Lev"] = 0x00
			end
		end

		-- 静音定时器6开始时间：时
		if controlCmd["muteTimer6_start_time_hour"] ~= nil then
			myTable["muteTimer6StartTimeHour"] = string2Int(controlCmd["muteTimer6_start_time_hour"])
		end

		-- 静音定时器6开始时间：分
		if controlCmd["muteTimer6_start_time_min"] ~= nil then
			myTable["muteTimer6StartTimeMin"] = string2Int(controlCmd["muteTimer6_start_time_min"])
		end

		-- 强热定时器1是否有效
		if controlCmd["force_heat_timer1_valid"] ~= nil then
			if controlCmd["force_heat_timer1_valid"] == VALUE_VALID then
				myTable["forceHeatTimer1Valid"] = 0x80
			elseif controlCmd["force_heat_timer1_valid"] == VALUE_INVALID then
				myTable["forceHeatTimer1Valid"] = 0x00
			end
		end

		-- 强热定时器1是否有用
		if controlCmd["force_heat_timer1_effect"] ~= nil then
			if controlCmd["force_heat_timer1_effect"] == VALUE_VALID then
				myTable["forceHeatTimer1Effect"] = BIT1
			elseif controlCmd["force_heat_timer1_effect"] == VALUE_INVALID then
				myTable["forceHeatTimer1Effect"] = 0x00
			end
		end

		-- 强热定时器1开关
		if controlCmd["force_heat_timer1_en"] ~= nil then
			if controlCmd["force_heat_timer1_en"] == VALUE_FUNCTION_ON then
				myTable["forceHeatTimer1En"] = 0x01
			elseif controlCmd["force_heat_timer1_en"] == VALUE_FUNCTION_OFF then
				myTable["forceHeatTimer1En"] = 0x00
			end
		end

		-- 强热定时器1开始时间：时
		if controlCmd["force_heat_timer1_start_time_hour"] ~= nil then
			myTable["forceHeatTimer1StartTimeHour"] = string2Int(controlCmd["force_heat_timer1_start_time_hour"])
		end

		-- 强热定时器1开始时间：分
		if controlCmd["force_heat_timer1_start_time_min"] ~= nil then
			myTable["forceHeatTimer1StartTimeMin"] = string2Int(controlCmd["force_heat_timer1_start_time_min"])
		end

		-- 强热定时器2是否有效
		if controlCmd["force_heat_timer2_valid"] ~= nil then
			if controlCmd["force_heat_timer2_valid"] == VALUE_VALID then
				myTable["forceHeatTimer2Valid"] = 0x80
			elseif controlCmd["force_heat_timer2_valid"] == VALUE_INVALID then
				myTable["forceHeatTimer2Valid"] = 0x00
			end
		end

		-- 强热定时器2是否有用
		if controlCmd["force_heat_timer2_effect"] ~= nil then
			if controlCmd["force_heat_timer2_effect"] == VALUE_VALID then
				myTable["forceHeatTimer2Effect"] = BIT1
			elseif controlCmd["force_heat_timer2_effect"] == VALUE_INVALID then
				myTable["forceHeatTimer2Effect"] = 0x00
			end
		end

		-- 强热定时器2开关
		if controlCmd["force_heat_timer2_en"] ~= nil then
			if controlCmd["force_heat_timer2_en"] == VALUE_FUNCTION_ON then
				myTable["forceHeatTimer2En"] = 0x01
			elseif controlCmd["force_heat_timer2_en"] == VALUE_FUNCTION_OFF then
				myTable["forceHeatTimer2En"] = 0x00
			end
		end

		-- 强热定时器2开始时间：时
		if controlCmd["force_heat_timer2_start_time_hour"] ~= nil then
			myTable["forceHeatTimer2StartTimeHour"] = string2Int(controlCmd["force_heat_timer2_start_time_hour"])
		end

		-- 强热定时器2开始时间：分
		if controlCmd["force_heat_timer2_start_time_min"] ~= nil then
			myTable["forceHeatTimer2StartTimeMin"] = string2Int(controlCmd["force_heat_timer2_start_time_min"])
		end

		-- 强热定时器3是否有效
		if controlCmd["force_heat_timer3_valid"] ~= nil then
			if controlCmd["force_heat_timer3_valid"] == VALUE_VALID then
				myTable["forceHeatTimer3Valid"] = 0x80
			elseif controlCmd["force_heat_timer3_valid"] == VALUE_INVALID then
				myTable["forceHeatTimer3Valid"] = 0x00
			end
		end

		-- 强热定时器3是否有用
		if controlCmd["force_heat_timer3_effect"] ~= nil then
			if controlCmd["force_heat_timer3_effect"] == VALUE_VALID then
				myTable["forceHeatTimer3Effect"] = BIT1
			elseif controlCmd["force_heat_timer3_effect"] == VALUE_INVALID then
				myTable["forceHeatTimer3Effect"] = 0x00
			end
		end

		-- 强热定时器3开关
		if controlCmd["force_heat_timer3_en"] ~= nil then
			if controlCmd["force_heat_timer3_en"] == VALUE_FUNCTION_ON then
				myTable["forceHeatTimer3En"] = 0x01
			elseif controlCmd["force_heat_timer3_en"] == VALUE_FUNCTION_OFF then
				myTable["forceHeatTimer3En"] = 0x00
			end
		end

		-- 强热定时器3开始时间：时
		if controlCmd["force_heat_timer3_start_time_hour"] ~= nil then
			myTable["forceHeatTimer3StartTimeHour"] = string2Int(controlCmd["force_heat_timer3_start_time_hour"])
		end

		-- 强热定时器3开始时间：分
		if controlCmd["force_heat_timer3_start_time_min"] ~= nil then
			myTable["forceHeatTimer3StartTimeMin"] = string2Int(controlCmd["force_heat_timer3_start_time_min"])
		end

		-- 强热定时器4是否有效
		if controlCmd["force_heat_timer4_valid"] ~= nil then
			if controlCmd["force_heat_timer4_valid"] == VALUE_VALID then
				myTable["forceHeatTimer4Valid"] = 0x80
			elseif controlCmd["force_heat_timer4_valid"] == VALUE_INVALID then
				myTable["forceHeatTimer4Valid"] = 0x00
			end
		end

		-- 强热定时器4是否有用
		if controlCmd["force_heat_timer4_effect"] ~= nil then
			if controlCmd["force_heat_timer4_effect"] == VALUE_VALID then
				myTable["forceHeatTimer4Effect"] = BIT1
			elseif controlCmd["force_heat_timer4_effect"] == VALUE_INVALID then
				myTable["forceHeatTimer4Effect"] = 0x00
			end
		end

		-- 强热定时器4开关
		if controlCmd["force_heat_timer4_en"] ~= nil then
			if controlCmd["force_heat_timer4_en"] == VALUE_FUNCTION_ON then
				myTable["forceHeatTimer4En"] = 0x01
			elseif controlCmd["force_heat_timer4_en"] == VALUE_FUNCTION_OFF then
				myTable["forceHeatTimer4En"] = 0x00
			end
		end

		-- 强热定时器4开始时间：时
		if controlCmd["force_heat_timer4_start_time_hour"] ~= nil then
			myTable["forceHeatTimer4StartTimeHour"] = string2Int(controlCmd["force_heat_timer4_start_time_hour"])
		end

		-- 强热定时器4开始时间：分
		if controlCmd["force_heat_timer4_start_time_min"] ~= nil then
			myTable["forceHeatTimer4StartTimeMin"] = string2Int(controlCmd["force_heat_timer4_start_time_min"])
		end

		-- 强热定时器5是否有效
		if controlCmd["force_heat_timer5_valid"] ~= nil then
			if controlCmd["force_heat_timer5_valid"] == VALUE_VALID then
				myTable["forceHeatTimer5Valid"] = 0x80
			elseif controlCmd["force_heat_timer5_valid"] == VALUE_INVALID then
				myTable["forceHeatTimer5Valid"] = 0x00
			end
		end

		-- 强热定时器5是否有用
		if controlCmd["force_heat_timer5_effect"] ~= nil then
			if controlCmd["force_heat_timer5_effect"] == VALUE_VALID then
				myTable["forceHeatTimer5Effect"] = BIT1
			elseif controlCmd["force_heat_timer5_effect"] == VALUE_INVALID then
				myTable["forceHeatTimer5Effect"] = 0x00
			end
		end

		-- 强热定时器5开关
		if controlCmd["force_heat_timer5_en"] ~= nil then
			if controlCmd["force_heat_timer5_en"] == VALUE_FUNCTION_ON then
				myTable["forceHeatTimer5En"] = 0x01
			elseif controlCmd["force_heat_timer5_en"] == VALUE_FUNCTION_OFF then
				myTable["forceHeatTimer5En"] = 0x00
			end
		end

		-- 强热定时器5开始时间：时
		if controlCmd["force_heat_timer5_start_time_hour"] ~= nil then
			myTable["forceHeatTimer5StartTimeHour"] = string2Int(controlCmd["force_heat_timer5_start_time_hour"])
		end

		-- 强热定时器5开始时间：分
		if controlCmd["force_heat_timer5_start_time_min"] ~= nil then
			myTable["forceHeatTimer5StartTimeMin"] = string2Int(controlCmd["force_heat_timer5_start_time_min"])
		end

		-- 强热定时器6是否有效
		if controlCmd["force_heat_timer6_valid"] ~= nil then
			if controlCmd["force_heat_timer6_valid"] == VALUE_VALID then
				myTable["forceHeatTimer6Valid"] = 0x80
			elseif controlCmd["force_heat_timer6_valid"] == VALUE_INVALID then
				myTable["forceHeatTimer6Valid"] = 0x00
			end
		end

		-- 强热定时器6是否有用
		if controlCmd["force_heat_timer6_effect"] ~= nil then
			if controlCmd["force_heat_timer6_effect"] == VALUE_VALID then
				myTable["forceHeatTimer6Effect"] = BIT1
			elseif controlCmd["force_heat_timer6_effect"] == VALUE_INVALID then
				myTable["forceHeatTimer6Effect"] = 0x00
			end
		end

		-- 强热定时器6开关
		if controlCmd["force_heat_timer6_en"] ~= nil then
			if controlCmd["force_heat_timer6_en"] == VALUE_FUNCTION_ON then
				myTable["forceHeatTimer6En"] = 0x01
			elseif controlCmd["force_heat_timer6_en"] == VALUE_FUNCTION_OFF then
				myTable["forceHeatTimer6En"] = 0x00
			end
		end

		-- 强热定时器6开始时间：时
		if controlCmd["force_heat_timer6_start_time_hour"] ~= nil then
			myTable["forceHeatTimer6StartTimeHour"] = string2Int(controlCmd["force_heat_timer6_start_time_hour"])
		end

		-- 强热定时器6开始时间：分
		if controlCmd["force_heat_timer6_start_time_min"] ~= nil then
			myTable["forceHeatTimer6StartTimeMin"] = string2Int(controlCmd["force_heat_timer6_start_time_min"])
		end
	elseif myTable["controlType"] == 0x04 then
		-- 周日定时1开关
		if controlCmd["week0_timer1_effect"] ~= nil then
			if controlCmd["week0_timer1_effect"] == VALUE_FUNCTION_ON then
				myTable["week0timer1Effect"] = 0x01
			elseif controlCmd["week0_timer1_effect"] == VALUE_FUNCTION_OFF then
				myTable["week0timer1Effect"] = 0x00
			end
		end

		-- 周日定时2开关
		if controlCmd["week0_timer2_effect"] ~= nil then
			if controlCmd["week0_timer2_effect"] == VALUE_FUNCTION_ON then
				myTable["week0timer2Effect"] = 0x02
			elseif controlCmd["week0_timer2_effect"] == VALUE_FUNCTION_OFF then
				myTable["week0timer2Effect"] = 0x00
			end
		end

		-- 周日定时3开关
		if controlCmd["week0_timer3_effect"] ~= nil then
			if controlCmd["week0_timer3_effect"] == VALUE_FUNCTION_ON then
				myTable["week0timer3Effect"] = 0x04
			elseif controlCmd["week0_timer3_effect"] == VALUE_FUNCTION_OFF then
				myTable["week0timer3Effect"] = 0x00
			end
		end

		-- 周日定时4开关
		if controlCmd["week0_timer4_effect"] ~= nil then
			if controlCmd["week0_timer4_effect"] == VALUE_FUNCTION_ON then
				myTable["week0timer4Effect"] = 0x08
			elseif controlCmd["week0_timer4_effect"] == VALUE_FUNCTION_OFF then
				myTable["week0timer4Effect"] = 0x00
			end
		end

		-- 周日定时5开关
		if controlCmd["week0_timer5_effect"] ~= nil then
			if controlCmd["week0_timer5_effect"] == VALUE_FUNCTION_ON then
				myTable["week0timer5Effect"] = 0x10
			elseif controlCmd["week0_timer5_effect"] == VALUE_FUNCTION_OFF then
				myTable["week0timer5Effect"] = 0x00
			end
		end

		-- 周日定时6开关
		if controlCmd["week0_timer6_effect"] ~= nil then
			if controlCmd["week0_timer6_effect"] == VALUE_FUNCTION_ON then
				myTable["week0timer6Effect"] = 0x20
			elseif controlCmd["week0_timer6_effect"] == VALUE_FUNCTION_OFF then
				myTable["week0timer6Effect"] = 0x00
			end
		end

		-- 周日定时1设定模式
		if controlCmd["week0_timer1_set_mode"] ~= nil then
			if controlCmd["week0_timer1_set_mode"] == "off" then
				myTable["week0timer1SetMode"] = 0x00
			elseif controlCmd["week0_timer1_set_mode"] == "heat" then
				myTable["week0timer1SetMode"] = 0x01
			elseif controlCmd["week0_timer1_set_mode"] == "dhw" then
				myTable["week0timer1SetMode"] = 0x02
			elseif controlCmd["week0_timer1_set_mode"] == "cool" then
				myTable["week0timer1SetMode"] = 0x03
			elseif controlCmd["week0_timer1_set_mode"] == "waterpump" then
				myTable["week0timer1SetMode"] = 0x04
			elseif controlCmd["week0_timer1_set_mode"] == "auto" then
				myTable["week0timer1SetMode"] = 0x05
			end
		end

		-- 周日定时1静音开关
		if controlCmd["week0_timer1_mut_set"] ~= nil then
			if controlCmd["week0_timer1_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer1MutSet"] = 0x01
			elseif controlCmd["week0_timer1_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer1MutSet"] = 0x00
			end
		end

		-- 周日定时1强热开关
		if controlCmd["week0_timer1_frc_he_set"] ~= nil then
			if controlCmd["week0_timer1_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer1FrcHeSet"] = 0x01
			elseif controlCmd["week0_timer1_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer1FrcHeSet"] = 0x00
			end
		end

		-- 周日定时1静音等级
		if controlCmd["week0_timer1_mut_lev"] ~= nil then
			if controlCmd["week0_timer1_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week0timer1MutLev"] = 0x01
			elseif controlCmd["week0_timer1_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week0timer1MutLev"] = 0x00
			end
		end

		-- 周日定时1设定温度
		if controlCmd["week0_timer1_set_temp"] ~= nil then
			myTable["week0timer1SetTemp"] = string2Int(controlCmd["week0_timer1_set_temp"])
		end

		-- 周日定时器1开始时间：时
		if controlCmd["week0_timer1_open_time_hour"] ~= nil then
			myTable["week0timer1OpenTimeHour"] = string2Int(controlCmd["week0_timer1_open_time_hour"])
		end

		-- 周日定时器1开始时间：分
		if controlCmd["week0_timer1_open_time_min"] ~= nil then
			myTable["week0timer1OpenTimeMin"] = string2Int(controlCmd["week0_timer1_open_time_min"])
		end

		-- 周日定时器1结束时间：时
		if controlCmd["week0_timer1_close_time_hour"] ~= nil then
			myTable["week0timer1CloseTimeHour"] = string2Int(controlCmd["week0_timer1_close_time_hour"])
		end

		-- 周日定时器1结束时间：分
		if controlCmd["week0_timer1_close_time_min"] ~= nil then
			myTable["week0timer1CloseTimeMin"] = string2Int(controlCmd["week0_timer1_close_time_min"])
		end

		-- 周日定时2设定模式
		if controlCmd["week0_timer2_set_mode"] ~= nil then
			if controlCmd["week0_timer2_set_mode"] == "off" then
				myTable["week0timer2SetMode"] = 0x00
			elseif controlCmd["week0_timer2_set_mode"] == "heat" then
				myTable["week0timer2SetMode"] = 0x01
			elseif controlCmd["week0_timer2_set_mode"] == "dhw" then
				myTable["week0timer2SetMode"] = 0x02
			elseif controlCmd["week0_timer2_set_mode"] == "cool" then
				myTable["week0timer2SetMode"] = 0x03
			elseif controlCmd["week0_timer2_set_mode"] == "waterpump" then
				myTable["week0timer2SetMode"] = 0x04
			elseif controlCmd["week0_timer2_set_mode"] == "auto" then
				myTable["week0timer2SetMode"] = 0x05
			end
		end

		-- 周日定时2静音开关
		if controlCmd["week0_timer2_mut_set"] ~= nil then
			if controlCmd["week0_timer2_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer2MutSet"] = 0x01
			elseif controlCmd["week0_timer2_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer2MutSet"] = 0x00
			end
		end

		-- 周日定时2强热开关
		if controlCmd["week0_timer2_frc_he_set"] ~= nil then
			if controlCmd["week0_timer2_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer2FrcHeSet"] = 0x01
			elseif controlCmd["week0_timer2_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer2FrcHeSet"] = 0x00
			end
		end

		-- 周日定时2静音等级
		if controlCmd["week0_timer2_mut_lev"] ~= nil then
			if controlCmd["week0_timer2_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week0timer2MutLev"] = 0x01
			elseif controlCmd["week0_timer2_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week0timer2MutLev"] = 0x00
			end
		end

		-- 周日定时2设定温度
		if controlCmd["week0_timer2_set_temp"] ~= nil then
			myTable["week0timer2SetTemp"] = string2Int(controlCmd["week0_timer2_set_temp"])
		end

		-- 周日定时器2开始时间：时
		if controlCmd["week0_timer2_open_time_hour"] ~= nil then
			myTable["week0timer2OpenTimeHour"] = string2Int(controlCmd["week0_timer2_open_time_hour"])
		end

		-- 周日定时器2开始时间：分
		if controlCmd["week0_timer2_open_time_min"] ~= nil then
			myTable["week0timer2OpenTimeMin"] = string2Int(controlCmd["week0_timer2_open_time_min"])
		end

		-- 周日定时器2结束时间：时
		if controlCmd["week0_timer2_close_time_hour"] ~= nil then
			myTable["week0timer2CloseTimeHour"] = string2Int(controlCmd["week0_timer2_close_time_hour"])
		end

		-- 周日定时器2结束时间：分
		if controlCmd["week0_timer2_close_time_min"] ~= nil then
			myTable["week0timer2CloseTimeMin"] = string2Int(controlCmd["week0_timer2_close_time_min"])
		end

		-- 周日定时3设定模式
		if controlCmd["week0_timer3_set_mode"] ~= nil then
			if controlCmd["week0_timer3_set_mode"] == "off" then
				myTable["week0timer3SetMode"] = 0x00
			elseif controlCmd["week0_timer3_set_mode"] == "heat" then
				myTable["week0timer3SetMode"] = 0x01
			elseif controlCmd["week0_timer3_set_mode"] == "dhw" then
				myTable["week0timer3SetMode"] = 0x02
			elseif controlCmd["week0_timer3_set_mode"] == "cool" then
				myTable["week0timer3SetMode"] = 0x03
			elseif controlCmd["week0_timer3_set_mode"] == "waterpump" then
				myTable["week0timer3SetMode"] = 0x04
			elseif controlCmd["week0_timer3_set_mode"] == "auto" then
				myTable["week0timer3SetMode"] = 0x05
			end
		end

		-- 周日定时3静音开关
		if controlCmd["week0_timer3_mut_set"] ~= nil then
			if controlCmd["week0_timer3_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer3MutSet"] = 0x01
			elseif controlCmd["week0_timer3_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer3MutSet"] = 0x00
			end
		end

		-- 周日定时3强热开关
		if controlCmd["week0_timer3_frc_he_set"] ~= nil then
			if controlCmd["week0_timer3_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer3FrcHeSet"] = 0x01
			elseif controlCmd["week0_timer3_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer3FrcHeSet"] = 0x00
			end
		end

		-- 周日定时3静音等级
		if controlCmd["week0_timer3_mut_lev"] ~= nil then
			if controlCmd["week0_timer3_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week0timer3MutLev"] = 0x01
			elseif controlCmd["week0_timer3_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week0timer3MutLev"] = 0x00
			end
		end

		-- 周日定时3设定温度
		if controlCmd["week0_timer3_set_temp"] ~= nil then
			myTable["week0timer3SetTemp"] = string2Int(controlCmd["week0_timer3_set_temp"])
		end

		-- 周日定时器3开始时间：时
		if controlCmd["week0_timer3_open_time_hour"] ~= nil then
			myTable["week0timer3OpenTimeHour"] = string2Int(controlCmd["week0_timer3_open_time_hour"])
		end

		-- 周日定时器3开始时间：分
		if controlCmd["week0_timer3_open_time_min"] ~= nil then
			myTable["week0timer3OpenTimeMin"] = string2Int(controlCmd["week0_timer3_open_time_min"])
		end

		-- 周日定时器3结束时间：时
		if controlCmd["week0_timer3_close_time_hour"] ~= nil then
			myTable["week0timer3CloseTimeHour"] = string2Int(controlCmd["week0_timer3_close_time_hour"])
		end

		-- 周日定时器3结束时间：分
		if controlCmd["week0_timer3_close_time_min"] ~= nil then
			myTable["week0timer3CloseTimeMin"] = string2Int(controlCmd["week0_timer3_close_time_min"])
		end

		-- 周日定时4设定模式
		if controlCmd["week0_timer4_set_mode"] ~= nil then
			if controlCmd["week0_timer4_set_mode"] == "off" then
				myTable["week0timer4SetMode"] = 0x00
			elseif controlCmd["week0_timer4_set_mode"] == "heat" then
				myTable["week0timer4SetMode"] = 0x01
			elseif controlCmd["week0_timer4_set_mode"] == "dhw" then
				myTable["week0timer4SetMode"] = 0x02
			elseif controlCmd["week0_timer4_set_mode"] == "cool" then
				myTable["week0timer4SetMode"] = 0x03
			elseif controlCmd["week0_timer4_set_mode"] == "waterpump" then
				myTable["week0timer4SetMode"] = 0x04
			elseif controlCmd["week0_timer4_set_mode"] == "auto" then
				myTable["week0timer4SetMode"] = 0x05
			end
		end

		-- 周日定时4静音开关
		if controlCmd["week0_timer4_mut_set"] ~= nil then
			if controlCmd["week0_timer4_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer4MutSet"] = 0x01
			elseif controlCmd["week0_timer4_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer4MutSet"] = 0x00
			end
		end

		-- 周日定时4强热开关
		if controlCmd["week0_timer4_frc_he_set"] ~= nil then
			if controlCmd["week0_timer4_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer4FrcHeSet"] = 0x01
			elseif controlCmd["week0_timer4_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer4FrcHeSet"] = 0x00
			end
		end

		-- 周日定时4静音等级
		if controlCmd["week0_timer4_mut_lev"] ~= nil then
			if controlCmd["week0_timer4_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week0timer4MutLev"] = 0x01
			elseif controlCmd["week0_timer4_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week0timer4MutLev"] = 0x00
			end
		end

		-- 周日定时4设定温度
		if controlCmd["week0_timer4_set_temp"] ~= nil then
			myTable["week0timer4SetTemp"] = string2Int(controlCmd["week0_timer4_set_temp"])
		end

		-- 周日定时器4开始时间：时
		if controlCmd["week0_timer4_open_time_hour"] ~= nil then
			myTable["week0timer4OpenTimeHour"] = string2Int(controlCmd["week0_timer4_open_time_hour"])
		end

		-- 周日定时器4开始时间：分
		if controlCmd["week0_timer4_open_time_min"] ~= nil then
			myTable["week0timer4OpenTimeMin"] = string2Int(controlCmd["week0_timer4_open_time_min"])
		end

		-- 周日定时器4结束时间：时
		if controlCmd["week0_timer4_close_time_hour"] ~= nil then
			myTable["week0timer4CloseTimeHour"] = string2Int(controlCmd["week0_timer4_close_time_hour"])
		end

		-- 周日定时器4结束时间：分
		if controlCmd["week0_timer4_close_time_min"] ~= nil then
			myTable["week0timer4CloseTimeMin"] = string2Int(controlCmd["week0_timer4_close_time_min"])
		end

		-- 周日定时5设定模式
		if controlCmd["week0_timer5_set_mode"] ~= nil then
			if controlCmd["week0_timer5_set_mode"] == "off" then
				myTable["week0timer5SetMode"] = 0x00
			elseif controlCmd["week0_timer5_set_mode"] == "heat" then
				myTable["week0timer5SetMode"] = 0x01
			elseif controlCmd["week0_timer5_set_mode"] == "dhw" then
				myTable["week0timer5SetMode"] = 0x02
			elseif controlCmd["week0_timer5_set_mode"] == "cool" then
				myTable["week0timer5SetMode"] = 0x03
			elseif controlCmd["week0_timer5_set_mode"] == "waterpump" then
				myTable["week0timer5SetMode"] = 0x04
			elseif controlCmd["week0_timer5_set_mode"] == "auto" then
				myTable["week0timer5SetMode"] = 0x05
			end
		end

		-- 周日定时5静音开关
		if controlCmd["week0_timer5_mut_set"] ~= nil then
			if controlCmd["week0_timer5_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer5MutSet"] = 0x01
			elseif controlCmd["week0_timer5_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer5MutSet"] = 0x00
			end
		end

		-- 周日定时5强热开关
		if controlCmd["week0_timer5_frc_he_set"] ~= nil then
			if controlCmd["week0_timer5_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer5FrcHeSet"] = 0x01
			elseif controlCmd["week0_timer5_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer5FrcHeSet"] = 0x00
			end
		end

		-- 周日定时5静音等级
		if controlCmd["week0_timer5_mut_lev"] ~= nil then
			if controlCmd["week0_timer5_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week0timer5MutLev"] = 0x01
			elseif controlCmd["week0_timer5_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week0timer5MutLev"] = 0x00
			end
		end

		-- 周日定时5设定温度
		if controlCmd["week0_timer5_set_temp"] ~= nil then
			myTable["week0timer5SetTemp"] = string2Int(controlCmd["week0_timer5_set_temp"])
		end

		-- 周日定时器5开始时间：时
		if controlCmd["week0_timer5_open_time_hour"] ~= nil then
			myTable["week0timer5OpenTimeHour"] = string2Int(controlCmd["week0_timer5_open_time_hour"])
		end

		-- 周日定时器5开始时间：分
		if controlCmd["week0_timer5_open_time_min"] ~= nil then
			myTable["week0timer5OpenTimeMin"] = string2Int(controlCmd["week0_timer5_open_time_min"])
		end

		-- 周日定时器5结束时间：时
		if controlCmd["week0_timer5_close_time_hour"] ~= nil then
			myTable["week0timer5CloseTimeHour"] = string2Int(controlCmd["week0_timer5_close_time_hour"])
		end

		-- 周日定时器5结束时间：分
		if controlCmd["week0_timer5_close_time_min"] ~= nil then
			myTable["week0timer5CloseTimeMin"] = string2Int(controlCmd["week0_timer5_close_time_min"])
		end

		-- 周日定时6设定模式
		if controlCmd["week0_timer6_set_mode"] ~= nil then
			if controlCmd["week0_timer6_set_mode"] == "off" then
				myTable["week0timer6SetMode"] = 0x00
			elseif controlCmd["week0_timer6_set_mode"] == "heat" then
				myTable["week0timer6SetMode"] = 0x01
			elseif controlCmd["week0_timer6_set_mode"] == "dhw" then
				myTable["week0timer6SetMode"] = 0x02
			elseif controlCmd["week0_timer6_set_mode"] == "cool" then
				myTable["week0timer6SetMode"] = 0x03
			elseif controlCmd["week0_timer6_set_mode"] == "waterpump" then
				myTable["week0timer6SetMode"] = 0x04
			elseif controlCmd["week0_timer6_set_mode"] == "auto" then
				myTable["week0timer6SetMode"] = 0x05
			end
		end

		-- 周日定时6静音开关
		if controlCmd["week0_timer6_mut_set"] ~= nil then
			if controlCmd["week0_timer6_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer6MutSet"] = 0x01
			elseif controlCmd["week0_timer6_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer6MutSet"] = 0x00
			end
		end

		-- 周日定时6强热开关
		if controlCmd["week0_timer6_frc_he_set"] ~= nil then
			if controlCmd["week0_timer6_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week0timer6FrcHeSet"] = 0x01
			elseif controlCmd["week0_timer6_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week0timer6FrcHeSet"] = 0x00
			end
		end

		-- 周日定时6静音等级
		if controlCmd["week0_timer6_mut_lev"] ~= nil then
			if controlCmd["week0_timer6_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week0timer6MutLev"] = 0x01
			elseif controlCmd["week0_timer6_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week0timer6MutLev"] = 0x00
			end
		end

		-- 周日定时6设定温度
		if controlCmd["week0_timer6_set_temp"] ~= nil then
			myTable["week0timer6SetTemp"] = string2Int(controlCmd["week0_timer6_set_temp"])
		end

		-- 周日定时器6开始时间：时
		if controlCmd["week0_timer6_open_time_hour"] ~= nil then
			myTable["week0timer6OpenTimeHour"] = string2Int(controlCmd["week0_timer6_open_time_hour"])
		end

		-- 周日定时器6开始时间：分
		if controlCmd["week0_timer6_open_time_min"] ~= nil then
			myTable["week0timer6OpenTimeMin"] = string2Int(controlCmd["week0_timer6_open_time_min"])
		end

		-- 周日定时器6结束时间：时
		if controlCmd["week0_timer6_close_time_hour"] ~= nil then
			myTable["week0timer6CloseTimeHour"] = string2Int(controlCmd["week0_timer6_close_time_hour"])
		end

		-- 周日定时器6结束时间：分
		if controlCmd["week0_timer6_close_time_min"] ~= nil then
			myTable["week0timer6CloseTimeMin"] = string2Int(controlCmd["week0_timer6_close_time_min"])
		end

		-- 周日定时1是否有效
		if controlCmd["week0_timer1_valid"] ~= nil then
			if controlCmd["week0_timer1_valid"] == VALUE_VALID then
				myTable["week0timer1Valid"] = 0x01
			elseif controlCmd["week0_timer1_valid"] == VALUE_INVALID then
				myTable["week0timer1Valid"] = 0x00
			end
		end

		-- 周日定时2是否有效
		if controlCmd["week0_timer2_valid"] ~= nil then
			if controlCmd["week0_timer2_valid"] == VALUE_VALID then
				myTable["week0timer2Valid"] = 0x02
			elseif controlCmd["week0_timer2_valid"] == VALUE_INVALID then
				myTable["week0timer2Valid"] = 0x00
			end
		end

		-- 周日定时3是否有效
		if controlCmd["week0_timer3_valid"] ~= nil then
			if controlCmd["week0_timer3_valid"] == VALUE_VALID then
				myTable["week0timer3Valid"] = 0x04
			elseif controlCmd["week0_timer3_valid"] == VALUE_INVALID then
				myTable["week0timer3Valid"] = 0x00
			end
		end

		-- 周日定时4是否有效
		if controlCmd["week0_timer4_valid"] ~= nil then
			if controlCmd["week0_timer4_valid"] == VALUE_VALID then
				myTable["week0timer4Valid"] = 0x08
			elseif controlCmd["week0_timer4_valid"] == VALUE_INVALID then
				myTable["week0timer4Valid"] = 0x00
			end
		end

		-- 周日定时5是否有效
		if controlCmd["week0_timer5_valid"] ~= nil then
			if controlCmd["week0_timer5_valid"] == VALUE_VALID then
				myTable["week0timer5Valid"] = 0x10
			elseif controlCmd["week0_timer5_valid"] == VALUE_INVALID then
				myTable["week0timer5Valid"] = 0x00
			end
		end

		-- 周日定时6是否有效
		if controlCmd["week0_timer6_valid"] ~= nil then
			if controlCmd["week0_timer6_valid"] == VALUE_VALID then
				myTable["week0timer6Valid"] = 0x20
			elseif controlCmd["week0_timer6_valid"] == VALUE_INVALID then
				myTable["week0timer6Valid"] = 0x00
			end
		end
	elseif myTable["controlType"] == 0x05 then
		-- 周一定时1开关
		if controlCmd["week1_timer1_effect"] ~= nil then
			if controlCmd["week1_timer1_effect"] == VALUE_FUNCTION_ON then
				myTable["week1timer1Effect"] = 0x01
			elseif controlCmd["week1_timer1_effect"] == VALUE_FUNCTION_OFF then
				myTable["week1timer1Effect"] = 0x00
			end
		end

		-- 周一定时2开关
		if controlCmd["week1_timer2_effect"] ~= nil then
			if controlCmd["week1_timer2_effect"] == VALUE_FUNCTION_ON then
				myTable["week1timer2Effect"] = 0x02
			elseif controlCmd["week1_timer2_effect"] == VALUE_FUNCTION_OFF then
				myTable["week1timer2Effect"] = 0x00
			end
		end

		-- 周一定时3开关
		if controlCmd["week1_timer3_effect"] ~= nil then
			if controlCmd["week1_timer3_effect"] == VALUE_FUNCTION_ON then
				myTable["week1timer3Effect"] = 0x04
			elseif controlCmd["week1_timer3_effect"] == VALUE_FUNCTION_OFF then
				myTable["week1timer3Effect"] = 0x00
			end
		end

		-- 周一定时4开关
		if controlCmd["week1_timer4_effect"] ~= nil then
			if controlCmd["week1_timer4_effect"] == VALUE_FUNCTION_ON then
				myTable["week1timer4Effect"] = 0x08
			elseif controlCmd["week1_timer4_effect"] == VALUE_FUNCTION_OFF then
				myTable["week1timer4Effect"] = 0x00
			end
		end

		-- 周一定时5开关
		if controlCmd["week1_timer5_effect"] ~= nil then
			if controlCmd["week1_timer5_effect"] == VALUE_FUNCTION_ON then
				myTable["week1timer5Effect"] = 0x10
			elseif controlCmd["week1_timer5_effect"] == VALUE_FUNCTION_OFF then
				myTable["week1timer5Effect"] = 0x00
			end
		end

		-- 周一定时6开关
		if controlCmd["week1_timer6_effect"] ~= nil then
			if controlCmd["week1_timer6_effect"] == VALUE_FUNCTION_ON then
				myTable["week1timer6Effect"] = 0x20
			elseif controlCmd["week1_timer6_effect"] == VALUE_FUNCTION_OFF then
				myTable["week1timer6Effect"] = 0x00
			end
		end

		-- 周一定时1设定模式
		if controlCmd["week1_timer1_set_mode"] ~= nil then
			if controlCmd["week1_timer1_set_mode"] == "off" then
				myTable["week1timer1SetMode"] = 0x00
			elseif controlCmd["week1_timer1_set_mode"] == "heat" then
				myTable["week1timer1SetMode"] = 0x01
			elseif controlCmd["week1_timer1_set_mode"] == "dhw" then
				myTable["week1timer1SetMode"] = 0x02
			elseif controlCmd["week1_timer1_set_mode"] == "cool" then
				myTable["week1timer1SetMode"] = 0x03
			elseif controlCmd["week1_timer1_set_mode"] == "waterpump" then
				myTable["week1timer1SetMode"] = 0x04
			elseif controlCmd["week1_timer1_set_mode"] == "auto" then
				myTable["week1timer1SetMode"] = 0x05
			end
		end

		-- 周一定时1静音开关
		if controlCmd["week1_timer1_mut_set"] ~= nil then
			if controlCmd["week1_timer1_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer1MutSet"] = 0x01
			elseif controlCmd["week1_timer1_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer1MutSet"] = 0x00
			end
		end

		-- 周一定时1强热开关
		if controlCmd["week1_timer1_frc_he_set"] ~= nil then
			if controlCmd["week1_timer1_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer1FrcHeSet"] = 0x01
			elseif controlCmd["week1_timer1_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer1FrcHeSet"] = 0x00
			end
		end

		-- 周一定时1静音等级
		if controlCmd["week1_timer1_mut_lev"] ~= nil then
			if controlCmd["week1_timer1_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week1timer1MutLev"] = 0x01
			elseif controlCmd["week1_timer1_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week1timer1MutLev"] = 0x00
			end
		end

		-- 周一定时1设定温度
		if controlCmd["week1_timer1_set_temp"] ~= nil then
			myTable["week1timer1SetTemp"] = string2Int(controlCmd["week1_timer1_set_temp"])
		end

		-- 周一定时器1开始时间：时
		if controlCmd["week1_timer1_open_time_hour"] ~= nil then
			myTable["week1timer1OpenTimeHour"] = string2Int(controlCmd["week1_timer1_open_time_hour"])
		end

		-- 周一定时器1开始时间：分
		if controlCmd["week1_timer1_open_time_min"] ~= nil then
			myTable["week1timer1OpenTimeMin"] = string2Int(controlCmd["week1_timer1_open_time_min"])
		end

		-- 周一定时器1结束时间：时
		if controlCmd["week1_timer1_close_time_hour"] ~= nil then
			myTable["week1timer1CloseTimeHour"] = string2Int(controlCmd["week1_timer1_close_time_hour"])
		end

		-- 周一定时器1结束时间：分
		if controlCmd["week1_timer1_close_time_min"] ~= nil then
			myTable["week1timer1CloseTimeMin"] = string2Int(controlCmd["week1_timer1_close_time_min"])
		end

		-- 周一定时2设定模式
		if controlCmd["week1_timer2_set_mode"] ~= nil then
			if controlCmd["week1_timer2_set_mode"] == "off" then
				myTable["week1timer2SetMode"] = 0x00
			elseif controlCmd["week1_timer2_set_mode"] == "heat" then
				myTable["week1timer2SetMode"] = 0x01
			elseif controlCmd["week1_timer2_set_mode"] == "dhw" then
				myTable["week1timer2SetMode"] = 0x02
			elseif controlCmd["week1_timer2_set_mode"] == "cool" then
				myTable["week1timer2SetMode"] = 0x03
			elseif controlCmd["week1_timer2_set_mode"] == "waterpump" then
				myTable["week1timer2SetMode"] = 0x04
			elseif controlCmd["week1_timer2_set_mode"] == "auto" then
				myTable["week1timer2SetMode"] = 0x05
			end
		end

		-- 周一定时2静音开关
		if controlCmd["week1_timer2_mut_set"] ~= nil then
			if controlCmd["week1_timer2_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer2MutSet"] = 0x01
			elseif controlCmd["week1_timer2_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer2MutSet"] = 0x00
			end
		end

		-- 周一定时2强热开关
		if controlCmd["week1_timer2_frc_he_set"] ~= nil then
			if controlCmd["week1_timer2_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer2FrcHeSet"] = 0x01
			elseif controlCmd["week1_timer2_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer2FrcHeSet"] = 0x00
			end
		end

		-- 周一定时2静音等级
		if controlCmd["week1_timer2_mut_lev"] ~= nil then
			if controlCmd["week1_timer2_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week1timer2MutLev"] = 0x01
			elseif controlCmd["week1_timer2_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week1timer2MutLev"] = 0x00
			end
		end

		-- 周一定时2设定温度
		if controlCmd["week1_timer2_set_temp"] ~= nil then
			myTable["week1timer2SetTemp"] = string2Int(controlCmd["week1_timer2_set_temp"])
		end

		-- 周一定时器2开始时间：时
		if controlCmd["week1_timer2_open_time_hour"] ~= nil then
			myTable["week1timer2OpenTimeHour"] = string2Int(controlCmd["week1_timer2_open_time_hour"])
		end

		-- 周一定时器2开始时间：分
		if controlCmd["week1_timer2_open_time_min"] ~= nil then
			myTable["week1timer2OpenTimeMin"] = string2Int(controlCmd["week1_timer2_open_time_min"])
		end

		-- 周一定时器2结束时间：时
		if controlCmd["week1_timer2_close_time_hour"] ~= nil then
			myTable["week1timer2CloseTimeHour"] = string2Int(controlCmd["week1_timer2_close_time_hour"])
		end

		-- 周一定时器2结束时间：分
		if controlCmd["week1_timer2_close_time_min"] ~= nil then
			myTable["week1timer2CloseTimeMin"] = string2Int(controlCmd["week1_timer2_close_time_min"])
		end

		-- 周一定时3设定模式
		if controlCmd["week1_timer3_set_mode"] ~= nil then
			if controlCmd["week1_timer3_set_mode"] == "off" then
				myTable["week1timer3SetMode"] = 0x00
			elseif controlCmd["week1_timer3_set_mode"] == "heat" then
				myTable["week1timer3SetMode"] = 0x01
			elseif controlCmd["week1_timer3_set_mode"] == "dhw" then
				myTable["week1timer3SetMode"] = 0x02
			elseif controlCmd["week1_timer3_set_mode"] == "cool" then
				myTable["week1timer3SetMode"] = 0x03
			elseif controlCmd["week1_timer3_set_mode"] == "waterpump" then
				myTable["week1timer3SetMode"] = 0x04
			elseif controlCmd["week1_timer3_set_mode"] == "auto" then
				myTable["week1timer3SetMode"] = 0x05
			end
		end

		-- 周一定时3静音开关
		if controlCmd["week1_timer3_mut_set"] ~= nil then
			if controlCmd["week1_timer3_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer3MutSet"] = 0x01
			elseif controlCmd["week1_timer3_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer3MutSet"] = 0x00
			end
		end

		-- 周一定时3强热开关
		if controlCmd["week1_timer3_frc_he_set"] ~= nil then
			if controlCmd["week1_timer3_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer3FrcHeSet"] = 0x01
			elseif controlCmd["week1_timer3_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer3FrcHeSet"] = 0x00
			end
		end

		-- 周一定时3静音等级
		if controlCmd["week1_timer3_mut_lev"] ~= nil then
			if controlCmd["week1_timer3_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week1timer3MutLev"] = 0x01
			elseif controlCmd["week1_timer3_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week1timer3MutLev"] = 0x00
			end
		end

		-- 周一定时3设定温度
		if controlCmd["week1_timer3_set_temp"] ~= nil then
			myTable["week1timer3SetTemp"] = string2Int(controlCmd["week1_timer3_set_temp"])
		end

		-- 周一定时器3开始时间：时
		if controlCmd["week1_timer3_open_time_hour"] ~= nil then
			myTable["week1timer3OpenTimeHour"] = string2Int(controlCmd["week1_timer3_open_time_hour"])
		end

		-- 周一定时器3开始时间：分
		if controlCmd["week1_timer3_open_time_min"] ~= nil then
			myTable["week1timer3OpenTimeMin"] = string2Int(controlCmd["week1_timer3_open_time_min"])
		end

		-- 周一定时器3结束时间：时
		if controlCmd["week1_timer3_close_time_hour"] ~= nil then
			myTable["week1timer3CloseTimeHour"] = string2Int(controlCmd["week1_timer3_close_time_hour"])
		end

		-- 周一定时器3结束时间：分
		if controlCmd["week1_timer3_close_time_min"] ~= nil then
			myTable["week1timer3CloseTimeMin"] = string2Int(controlCmd["week1_timer3_close_time_min"])
		end

		-- 周一定时4设定模式
		if controlCmd["week1_timer4_set_mode"] ~= nil then
			if controlCmd["week1_timer4_set_mode"] == "off" then
				myTable["week1timer4SetMode"] = 0x00
			elseif controlCmd["week1_timer4_set_mode"] == "heat" then
				myTable["week1timer4SetMode"] = 0x01
			elseif controlCmd["week1_timer4_set_mode"] == "dhw" then
				myTable["week1timer4SetMode"] = 0x02
			elseif controlCmd["week1_timer4_set_mode"] == "cool" then
				myTable["week1timer4SetMode"] = 0x03
			elseif controlCmd["week1_timer4_set_mode"] == "waterpump" then
				myTable["week1timer4SetMode"] = 0x04
			elseif controlCmd["week1_timer4_set_mode"] == "auto" then
				myTable["week1timer4SetMode"] = 0x05
			end
		end

		-- 周一定时4静音开关
		if controlCmd["week1_timer4_mut_set"] ~= nil then
			if controlCmd["week1_timer4_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer4MutSet"] = 0x01
			elseif controlCmd["week1_timer4_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer4MutSet"] = 0x00
			end
		end

		-- 周一定时4强热开关
		if controlCmd["week1_timer4_frc_he_set"] ~= nil then
			if controlCmd["week1_timer4_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer4FrcHeSet"] = 0x01
			elseif controlCmd["week1_timer4_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer4FrcHeSet"] = 0x00
			end
		end

		-- 周一定时4静音等级
		if controlCmd["week1_timer4_mut_lev"] ~= nil then
			if controlCmd["week1_timer4_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week1timer4MutLev"] = 0x01
			elseif controlCmd["week1_timer4_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week1timer4MutLev"] = 0x00
			end
		end

		-- 周一定时4设定温度
		if controlCmd["week1_timer4_set_temp"] ~= nil then
			myTable["week1timer4SetTemp"] = string2Int(controlCmd["week1_timer4_set_temp"])
		end

		-- 周一定时器4开始时间：时
		if controlCmd["week1_timer4_open_time_hour"] ~= nil then
			myTable["week1timer4OpenTimeHour"] = string2Int(controlCmd["week1_timer4_open_time_hour"])
		end

		-- 周一定时器4开始时间：分
		if controlCmd["week1_timer4_open_time_min"] ~= nil then
			myTable["week1timer4OpenTimeMin"] = string2Int(controlCmd["week1_timer4_open_time_min"])
		end

		-- 周一定时器4结束时间：时
		if controlCmd["week1_timer4_close_time_hour"] ~= nil then
			myTable["week1timer4CloseTimeHour"] = string2Int(controlCmd["week1_timer4_close_time_hour"])
		end

		-- 周一定时器4结束时间：分
		if controlCmd["week1_timer4_close_time_min"] ~= nil then
			myTable["week1timer4CloseTimeMin"] = string2Int(controlCmd["week1_timer4_close_time_min"])
		end

		-- 周一定时5设定模式
		if controlCmd["week1_timer5_set_mode"] ~= nil then
			if controlCmd["week1_timer5_set_mode"] == "off" then
				myTable["week1timer5SetMode"] = 0x00
			elseif controlCmd["week1_timer5_set_mode"] == "heat" then
				myTable["week1timer5SetMode"] = 0x01
			elseif controlCmd["week1_timer5_set_mode"] == "dhw" then
				myTable["week1timer5SetMode"] = 0x02
			elseif controlCmd["week1_timer5_set_mode"] == "cool" then
				myTable["week1timer5SetMode"] = 0x03
			elseif controlCmd["week1_timer5_set_mode"] == "waterpump" then
				myTable["week1timer5SetMode"] = 0x04
			elseif controlCmd["week1_timer5_set_mode"] == "auto" then
				myTable["week1timer5SetMode"] = 0x05
			end
		end

		-- 周一定时5静音开关
		if controlCmd["week1_timer5_mut_set"] ~= nil then
			if controlCmd["week1_timer5_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer5MutSet"] = 0x01
			elseif controlCmd["week1_timer5_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer5MutSet"] = 0x00
			end
		end

		-- 周一定时5强热开关
		if controlCmd["week1_timer5_frc_he_set"] ~= nil then
			if controlCmd["week1_timer5_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer5FrcHeSet"] = 0x01
			elseif controlCmd["week1_timer5_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer5FrcHeSet"] = 0x00
			end
		end

		-- 周一定时5静音等级
		if controlCmd["week1_timer5_mut_lev"] ~= nil then
			if controlCmd["week1_timer5_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week1timer5MutLev"] = 0x01
			elseif controlCmd["week1_timer5_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week1timer5MutLev"] = 0x00
			end
		end

		-- 周一定时5设定温度
		if controlCmd["week1_timer5_set_temp"] ~= nil then
			myTable["week1timer5SetTemp"] = string2Int(controlCmd["week1_timer5_set_temp"])
		end

		-- 周一定时器5开始时间：时
		if controlCmd["week1_timer5_open_time_hour"] ~= nil then
			myTable["week1timer5OpenTimeHour"] = string2Int(controlCmd["week1_timer5_open_time_hour"])
		end

		-- 周一定时器5开始时间：分
		if controlCmd["week1_timer5_open_time_min"] ~= nil then
			myTable["week1timer5OpenTimeMin"] = string2Int(controlCmd["week1_timer5_open_time_min"])
		end

		-- 周一定时器5结束时间：时
		if controlCmd["week1_timer5_close_time_hour"] ~= nil then
			myTable["week1timer5CloseTimeHour"] = string2Int(controlCmd["week1_timer5_close_time_hour"])
		end

		-- 周一定时器5结束时间：分
		if controlCmd["week1_timer5_close_time_min"] ~= nil then
			myTable["week1timer5CloseTimeMin"] = string2Int(controlCmd["week1_timer5_close_time_min"])
		end

		-- 周一定时6设定模式
		if controlCmd["week1_timer6_set_mode"] ~= nil then
			if controlCmd["week1_timer6_set_mode"] == "off" then
				myTable["week1timer6SetMode"] = 0x00
			elseif controlCmd["week1_timer6_set_mode"] == "heat" then
				myTable["week1timer6SetMode"] = 0x01
			elseif controlCmd["week1_timer6_set_mode"] == "dhw" then
				myTable["week1timer6SetMode"] = 0x02
			elseif controlCmd["week1_timer6_set_mode"] == "cool" then
				myTable["week1timer6SetMode"] = 0x03
			elseif controlCmd["week1_timer6_set_mode"] == "waterpump" then
				myTable["week1timer6SetMode"] = 0x04
			elseif controlCmd["week1_timer6_set_mode"] == "auto" then
				myTable["week1timer6SetMode"] = 0x05
			end
		end

		-- 周一定时6静音开关
		if controlCmd["week1_timer6_mut_set"] ~= nil then
			if controlCmd["week1_timer6_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer6MutSet"] = 0x01
			elseif controlCmd["week1_timer6_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer6MutSet"] = 0x00
			end
		end

		-- 周一定时6强热开关
		if controlCmd["week1_timer6_frc_he_set"] ~= nil then
			if controlCmd["week1_timer6_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week1timer6FrcHeSet"] = 0x01
			elseif controlCmd["week1_timer6_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week1timer6FrcHeSet"] = 0x00
			end
		end

		-- 周一定时6静音等级
		if controlCmd["week1_timer6_mut_lev"] ~= nil then
			if controlCmd["week1_timer6_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week1timer6MutLev"] = 0x01
			elseif controlCmd["week1_timer6_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week1timer6MutLev"] = 0x00
			end
		end

		-- 周一定时6设定温度
		if controlCmd["week1_timer6_set_temp"] ~= nil then
			myTable["week1timer6SetTemp"] = string2Int(controlCmd["week1_timer6_set_temp"])
		end

		-- 周一定时器6开始时间：时
		if controlCmd["week1_timer6_open_time_hour"] ~= nil then
			myTable["week1timer6OpenTimeHour"] = string2Int(controlCmd["week1_timer6_open_time_hour"])
		end

		-- 周一定时器6开始时间：分
		if controlCmd["week1_timer6_open_time_min"] ~= nil then
			myTable["week1timer6OpenTimeMin"] = string2Int(controlCmd["week1_timer6_open_time_min"])
		end

		-- 周一定时器6结束时间：时
		if controlCmd["week1_timer6_close_time_hour"] ~= nil then
			myTable["week1timer6CloseTimeHour"] = string2Int(controlCmd["week1_timer6_close_time_hour"])
		end

		-- 周一定时器6结束时间：分
		if controlCmd["week1_timer6_close_time_min"] ~= nil then
			myTable["week1timer6CloseTimeMin"] = string2Int(controlCmd["week1_timer6_close_time_min"])
		end

		-- 周一定时1是否有效
		if controlCmd["week1_timer1_valid"] ~= nil then
			if controlCmd["week1_timer1_valid"] == VALUE_VALID then
				myTable["week1timer1Valid"] = 0x01
			elseif controlCmd["week1_timer1_valid"] == VALUE_INVALID then
				myTable["week1timer1Valid"] = 0x00
			end
		end

		-- 周一定时2是否有效
		if controlCmd["week1_timer2_valid"] ~= nil then
			if controlCmd["week1_timer2_valid"] == VALUE_VALID then
				myTable["week1timer2Valid"] = 0x02
			elseif controlCmd["week1_timer2_valid"] == VALUE_INVALID then
				myTable["week1timer2Valid"] = 0x00
			end
		end

		-- 周一定时3是否有效
		if controlCmd["week1_timer3_valid"] ~= nil then
			if controlCmd["week1_timer3_valid"] == VALUE_VALID then
				myTable["week1timer3Valid"] = 0x04
			elseif controlCmd["week1_timer3_valid"] == VALUE_INVALID then
				myTable["week1timer3Valid"] = 0x00
			end
		end

		-- 周一定时4是否有效
		if controlCmd["week1_timer4_valid"] ~= nil then
			if controlCmd["week1_timer4_valid"] == VALUE_VALID then
				myTable["week1timer4Valid"] = 0x08
			elseif controlCmd["week1_timer4_valid"] == VALUE_INVALID then
				myTable["week1timer4Valid"] = 0x00
			end
		end

		-- 周一定时5是否有效
		if controlCmd["week1_timer5_valid"] ~= nil then
			if controlCmd["week1_timer5_valid"] == VALUE_VALID then
				myTable["week1timer5Valid"] = 0x10
			elseif controlCmd["week1_timer5_valid"] == VALUE_INVALID then
				myTable["week1timer5Valid"] = 0x00
			end
		end

		-- 周一定时6是否有效
		if controlCmd["week1_timer6_valid"] ~= nil then
			if controlCmd["week1_timer6_valid"] == VALUE_VALID then
				myTable["week1timer6Valid"] = 0x20
			elseif controlCmd["week1_timer6_valid"] == VALUE_INVALID then
				myTable["week1timer6Valid"] = 0x00
			end
		end
	elseif myTable["controlType"] == 0x06 then
		-- 周二定时1开关
		if controlCmd["week2_timer1_effect"] ~= nil then
			if controlCmd["week2_timer1_effect"] == VALUE_FUNCTION_ON then
				myTable["week2timer1Effect"] = 0x01
			elseif controlCmd["week2_timer1_effect"] == VALUE_FUNCTION_OFF then
				myTable["week2timer1Effect"] = 0x00
			end
		end

		-- 周二定时2开关
		if controlCmd["week2_timer2_effect"] ~= nil then
			if controlCmd["week2_timer2_effect"] == VALUE_FUNCTION_ON then
				myTable["week2timer2Effect"] = 0x02
			elseif controlCmd["week2_timer2_effect"] == VALUE_FUNCTION_OFF then
				myTable["week2timer2Effect"] = 0x00
			end
		end

		-- 周二定时3开关
		if controlCmd["week2_timer3_effect"] ~= nil then
			if controlCmd["week2_timer3_effect"] == VALUE_FUNCTION_ON then
				myTable["week2timer3Effect"] = 0x04
			elseif controlCmd["week2_timer3_effect"] == VALUE_FUNCTION_OFF then
				myTable["week2timer3Effect"] = 0x00
			end
		end

		-- 周二定时4开关
		if controlCmd["week2_timer4_effect"] ~= nil then
			if controlCmd["week2_timer4_effect"] == VALUE_FUNCTION_ON then
				myTable["week2timer4Effect"] = 0x08
			elseif controlCmd["week2_timer4_effect"] == VALUE_FUNCTION_OFF then
				myTable["week2timer4Effect"] = 0x00
			end
		end

		-- 周二定时5开关
		if controlCmd["week2_timer5_effect"] ~= nil then
			if controlCmd["week2_timer5_effect"] == VALUE_FUNCTION_ON then
				myTable["week2timer5Effect"] = 0x10
			elseif controlCmd["week2_timer5_effect"] == VALUE_FUNCTION_OFF then
				myTable["week2timer5Effect"] = 0x00
			end
		end

		-- 周二定时6开关
		if controlCmd["week2_timer6_effect"] ~= nil then
			if controlCmd["week2_timer6_effect"] == VALUE_FUNCTION_ON then
				myTable["week2timer6Effect"] = 0x20
			elseif controlCmd["week2_timer6_effect"] == VALUE_FUNCTION_OFF then
				myTable["week2timer6Effect"] = 0x00
			end
		end

		-- 周二定时1设定模式
		if controlCmd["week2_timer1_set_mode"] ~= nil then
			if controlCmd["week2_timer1_set_mode"] == "off" then
				myTable["week2timer1SetMode"] = 0x00
			elseif controlCmd["week2_timer1_set_mode"] == "heat" then
				myTable["week2timer1SetMode"] = 0x01
			elseif controlCmd["week2_timer1_set_mode"] == "dhw" then
				myTable["week2timer1SetMode"] = 0x02
			elseif controlCmd["week2_timer1_set_mode"] == "cool" then
				myTable["week2timer1SetMode"] = 0x03
			elseif controlCmd["week2_timer1_set_mode"] == "waterpump" then
				myTable["week2timer1SetMode"] = 0x04
			elseif controlCmd["week2_timer1_set_mode"] == "auto" then
				myTable["week2timer1SetMode"] = 0x05
			end
		end

		-- 周二定时1静音开关
		if controlCmd["week2_timer1_mut_set"] ~= nil then
			if controlCmd["week2_timer1_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer1MutSet"] = 0x01
			elseif controlCmd["week2_timer1_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer1MutSet"] = 0x00
			end
		end

		-- 周二定时1强热开关
		if controlCmd["week2_timer1_frc_he_set"] ~= nil then
			if controlCmd["week2_timer1_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer1FrcHeSet"] = 0x01
			elseif controlCmd["week2_timer1_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer1FrcHeSet"] = 0x00
			end
		end

		-- 周二定时1静音等级
		if controlCmd["week2_timer1_mut_lev"] ~= nil then
			if controlCmd["week2_timer1_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week2timer1MutLev"] = 0x01
			elseif controlCmd["week2_timer1_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week2timer1MutLev"] = 0x00
			end
		end

		-- 周二定时1设定温度
		if controlCmd["week2_timer1_set_temp"] ~= nil then
			myTable["week2timer1SetTemp"] = string2Int(controlCmd["week2_timer1_set_temp"])
		end

		-- 周二定时器1开始时间：时
		if controlCmd["week2_timer1_open_time_hour"] ~= nil then
			myTable["week2timer1OpenTimeHour"] = string2Int(controlCmd["week2_timer1_open_time_hour"])
		end

		-- 周二定时器1开始时间：分
		if controlCmd["week2_timer1_open_time_min"] ~= nil then
			myTable["week2timer1OpenTimeMin"] = string2Int(controlCmd["week2_timer1_open_time_min"])
		end

		-- 周二定时器1结束时间：时
		if controlCmd["week2_timer1_close_time_hour"] ~= nil then
			myTable["week2timer1CloseTimeHour"] = string2Int(controlCmd["week2_timer1_close_time_hour"])
		end

		-- 周二定时器1结束时间：分
		if controlCmd["week2_timer1_close_time_min"] ~= nil then
			myTable["week2timer1CloseTimeMin"] = string2Int(controlCmd["week2_timer1_close_time_min"])
		end

		-- 周二定时2设定模式
		if controlCmd["week2_timer2_set_mode"] ~= nil then
			if controlCmd["week2_timer2_set_mode"] == "off" then
				myTable["week2timer2SetMode"] = 0x00
			elseif controlCmd["week2_timer2_set_mode"] == "heat" then
				myTable["week2timer2SetMode"] = 0x01
			elseif controlCmd["week2_timer2_set_mode"] == "dhw" then
				myTable["week2timer2SetMode"] = 0x02
			elseif controlCmd["week2_timer2_set_mode"] == "cool" then
				myTable["week2timer2SetMode"] = 0x03
			elseif controlCmd["week2_timer2_set_mode"] == "waterpump" then
				myTable["week2timer2SetMode"] = 0x04
			elseif controlCmd["week2_timer2_set_mode"] == "auto" then
				myTable["week2timer2SetMode"] = 0x05
			end
		end

		-- 周二定时2静音开关
		if controlCmd["week2_timer2_mut_set"] ~= nil then
			if controlCmd["week2_timer2_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer2MutSet"] = 0x01
			elseif controlCmd["week2_timer2_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer2MutSet"] = 0x00
			end
		end

		-- 周二定时2强热开关
		if controlCmd["week2_timer2_frc_he_set"] ~= nil then
			if controlCmd["week2_timer2_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer2FrcHeSet"] = 0x01
			elseif controlCmd["week2_timer2_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer2FrcHeSet"] = 0x00
			end
		end

		-- 周二定时2静音等级
		if controlCmd["week2_timer2_mut_lev"] ~= nil then
			if controlCmd["week2_timer2_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week2timer2MutLev"] = 0x01
			elseif controlCmd["week2_timer2_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week2timer2MutLev"] = 0x00
			end
		end

		-- 周二定时2设定温度
		if controlCmd["week2_timer2_set_temp"] ~= nil then
			myTable["week2timer2SetTemp"] = string2Int(controlCmd["week2_timer2_set_temp"])
		end

		-- 周二定时器2开始时间：时
		if controlCmd["week2_timer2_open_time_hour"] ~= nil then
			myTable["week2timer2OpenTimeHour"] = string2Int(controlCmd["week2_timer2_open_time_hour"])
		end

		-- 周二定时器2开始时间：分
		if controlCmd["week2_timer2_open_time_min"] ~= nil then
			myTable["week2timer2OpenTimeMin"] = string2Int(controlCmd["week2_timer2_open_time_min"])
		end

		-- 周二定时器2结束时间：时
		if controlCmd["week2_timer2_close_time_hour"] ~= nil then
			myTable["week2timer2CloseTimeHour"] = string2Int(controlCmd["week2_timer2_close_time_hour"])
		end

		-- 周二定时器2结束时间：分
		if controlCmd["week2_timer2_close_time_min"] ~= nil then
			myTable["week2timer2CloseTimeMin"] = string2Int(controlCmd["week2_timer2_close_time_min"])
		end

		-- 周二定时3设定模式
		if controlCmd["week2_timer3_set_mode"] ~= nil then
			if controlCmd["week2_timer3_set_mode"] == "off" then
				myTable["week2timer3SetMode"] = 0x00
			elseif controlCmd["week2_timer3_set_mode"] == "heat" then
				myTable["week2timer3SetMode"] = 0x01
			elseif controlCmd["week2_timer3_set_mode"] == "dhw" then
				myTable["week2timer3SetMode"] = 0x02
			elseif controlCmd["week2_timer3_set_mode"] == "cool" then
				myTable["week2timer3SetMode"] = 0x03
			elseif controlCmd["week2_timer3_set_mode"] == "waterpump" then
				myTable["week2timer3SetMode"] = 0x04
			elseif controlCmd["week2_timer3_set_mode"] == "auto" then
				myTable["week2timer3SetMode"] = 0x05
			end
		end

		-- 周二定时3静音开关
		if controlCmd["week2_timer3_mut_set"] ~= nil then
			if controlCmd["week2_timer3_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer3MutSet"] = 0x01
			elseif controlCmd["week2_timer3_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer3MutSet"] = 0x00
			end
		end

		-- 周二定时3强热开关
		if controlCmd["week2_timer3_frc_he_set"] ~= nil then
			if controlCmd["week2_timer3_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer3FrcHeSet"] = 0x01
			elseif controlCmd["week2_timer3_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer3FrcHeSet"] = 0x00
			end
		end

		-- 周二定时3静音等级
		if controlCmd["week2_timer3_mut_lev"] ~= nil then
			if controlCmd["week2_timer3_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week2timer3MutLev"] = 0x01
			elseif controlCmd["week2_timer3_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week2timer3MutLev"] = 0x00
			end
		end

		-- 周二定时3设定温度
		if controlCmd["week2_timer3_set_temp"] ~= nil then
			myTable["week2timer3SetTemp"] = string2Int(controlCmd["week2_timer3_set_temp"])
		end

		-- 周二定时器3开始时间：时
		if controlCmd["week2_timer3_open_time_hour"] ~= nil then
			myTable["week2timer3OpenTimeHour"] = string2Int(controlCmd["week2_timer3_open_time_hour"])
		end

		-- 周二定时器3开始时间：分
		if controlCmd["week2_timer3_open_time_min"] ~= nil then
			myTable["week2timer3OpenTimeMin"] = string2Int(controlCmd["week2_timer3_open_time_min"])
		end

		-- 周二定时器3结束时间：时
		if controlCmd["week2_timer3_close_time_hour"] ~= nil then
			myTable["week2timer3CloseTimeHour"] = string2Int(controlCmd["week2_timer3_close_time_hour"])
		end

		-- 周二定时器3结束时间：分
		if controlCmd["week2_timer3_close_time_min"] ~= nil then
			myTable["week2timer3CloseTimeMin"] = string2Int(controlCmd["week2_timer3_close_time_min"])
		end

		-- 周二定时4设定模式
		if controlCmd["week2_timer4_set_mode"] ~= nil then
			if controlCmd["week2_timer4_set_mode"] == "off" then
				myTable["week2timer4SetMode"] = 0x00
			elseif controlCmd["week2_timer4_set_mode"] == "heat" then
				myTable["week2timer4SetMode"] = 0x01
			elseif controlCmd["week2_timer4_set_mode"] == "dhw" then
				myTable["week2timer4SetMode"] = 0x02
			elseif controlCmd["week2_timer4_set_mode"] == "cool" then
				myTable["week2timer4SetMode"] = 0x03
			elseif controlCmd["week2_timer4_set_mode"] == "waterpump" then
				myTable["week2timer4SetMode"] = 0x04
			elseif controlCmd["week2_timer4_set_mode"] == "auto" then
				myTable["week2timer4SetMode"] = 0x05
			end
		end

		-- 周二定时4静音开关
		if controlCmd["week2_timer4_mut_set"] ~= nil then
			if controlCmd["week2_timer4_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer4MutSet"] = 0x01
			elseif controlCmd["week2_timer4_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer4MutSet"] = 0x00
			end
		end

		-- 周二定时4强热开关
		if controlCmd["week2_timer4_frc_he_set"] ~= nil then
			if controlCmd["week2_timer4_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer4FrcHeSet"] = 0x01
			elseif controlCmd["week2_timer4_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer4FrcHeSet"] = 0x00
			end
		end

		-- 周二定时4静音等级
		if controlCmd["week2_timer4_mut_lev"] ~= nil then
			if controlCmd["week2_timer4_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week2timer4MutLev"] = 0x01
			elseif controlCmd["week2_timer4_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week2timer4MutLev"] = 0x00
			end
		end

		-- 周二定时4设定温度
		if controlCmd["week2_timer4_set_temp"] ~= nil then
			myTable["week2timer4SetTemp"] = string2Int(controlCmd["week2_timer4_set_temp"])
		end

		-- 周二定时器4开始时间：时
		if controlCmd["week2_timer4_open_time_hour"] ~= nil then
			myTable["week2timer4OpenTimeHour"] = string2Int(controlCmd["week2_timer4_open_time_hour"])
		end

		-- 周二定时器4开始时间：分
		if controlCmd["week2_timer4_open_time_min"] ~= nil then
			myTable["week2timer4OpenTimeMin"] = string2Int(controlCmd["week2_timer4_open_time_min"])
		end

		-- 周二定时器4结束时间：时
		if controlCmd["week2_timer4_close_time_hour"] ~= nil then
			myTable["week2timer4CloseTimeHour"] = string2Int(controlCmd["week2_timer4_close_time_hour"])
		end

		-- 周二定时器4结束时间：分
		if controlCmd["week2_timer4_close_time_min"] ~= nil then
			myTable["week2timer4CloseTimeMin"] = string2Int(controlCmd["week2_timer4_close_time_min"])
		end

		-- 周二定时5设定模式
		if controlCmd["week2_timer5_set_mode"] ~= nil then
			if controlCmd["week2_timer5_set_mode"] == "off" then
				myTable["week2timer5SetMode"] = 0x00
			elseif controlCmd["week2_timer5_set_mode"] == "heat" then
				myTable["week2timer5SetMode"] = 0x01
			elseif controlCmd["week2_timer5_set_mode"] == "dhw" then
				myTable["week2timer5SetMode"] = 0x02
			elseif controlCmd["week2_timer5_set_mode"] == "cool" then
				myTable["week2timer5SetMode"] = 0x03
			elseif controlCmd["week2_timer5_set_mode"] == "waterpump" then
				myTable["week2timer5SetMode"] = 0x04
			elseif controlCmd["week2_timer5_set_mode"] == "auto" then
				myTable["week2timer5SetMode"] = 0x05
			end
		end

		-- 周二定时5静音开关
		if controlCmd["week2_timer5_mut_set"] ~= nil then
			if controlCmd["week2_timer5_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer5MutSet"] = 0x01
			elseif controlCmd["week2_timer5_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer5MutSet"] = 0x00
			end
		end

		-- 周二定时5强热开关
		if controlCmd["week2_timer5_frc_he_set"] ~= nil then
			if controlCmd["week2_timer5_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer5FrcHeSet"] = 0x01
			elseif controlCmd["week2_timer5_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer5FrcHeSet"] = 0x00
			end
		end

		-- 周二定时5静音等级
		if controlCmd["week2_timer5_mut_lev"] ~= nil then
			if controlCmd["week2_timer5_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week2timer5MutLev"] = 0x01
			elseif controlCmd["week2_timer5_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week2timer5MutLev"] = 0x00
			end
		end

		-- 周二定时5设定温度
		if controlCmd["week2_timer5_set_temp"] ~= nil then
			myTable["week2timer5SetTemp"] = string2Int(controlCmd["week2_timer5_set_temp"])
		end

		-- 周二定时器5开始时间：时
		if controlCmd["week2_timer5_open_time_hour"] ~= nil then
			myTable["week2timer5OpenTimeHour"] = string2Int(controlCmd["week2_timer5_open_time_hour"])
		end

		-- 周二定时器5开始时间：分
		if controlCmd["week2_timer5_open_time_min"] ~= nil then
			myTable["week2timer5OpenTimeMin"] = string2Int(controlCmd["week2_timer5_open_time_min"])
		end

		-- 周二定时器5结束时间：时
		if controlCmd["week2_timer5_close_time_hour"] ~= nil then
			myTable["week2timer5CloseTimeHour"] = string2Int(controlCmd["week2_timer5_close_time_hour"])
		end

		-- 周二定时器5结束时间：分
		if controlCmd["week2_timer5_close_time_min"] ~= nil then
			myTable["week2timer5CloseTimeMin"] = string2Int(controlCmd["week2_timer5_close_time_min"])
		end

		-- 周二定时6设定模式
		if controlCmd["week2_timer6_set_mode"] ~= nil then
			if controlCmd["week2_timer6_set_mode"] == "off" then
				myTable["week2timer6SetMode"] = 0x00
			elseif controlCmd["week2_timer6_set_mode"] == "heat" then
				myTable["week2timer6SetMode"] = 0x01
			elseif controlCmd["week2_timer6_set_mode"] == "dhw" then
				myTable["week2timer6SetMode"] = 0x02
			elseif controlCmd["week2_timer6_set_mode"] == "cool" then
				myTable["week2timer6SetMode"] = 0x03
			elseif controlCmd["week2_timer6_set_mode"] == "waterpump" then
				myTable["week2timer6SetMode"] = 0x04
			elseif controlCmd["week2_timer6_set_mode"] == "auto" then
				myTable["week2timer6SetMode"] = 0x05
			end
		end

		-- 周二定时6静音开关
		if controlCmd["week2_timer6_mut_set"] ~= nil then
			if controlCmd["week2_timer6_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer6MutSet"] = 0x01
			elseif controlCmd["week2_timer6_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer6MutSet"] = 0x00
			end
		end

		-- 周二定时6强热开关
		if controlCmd["week2_timer6_frc_he_set"] ~= nil then
			if controlCmd["week2_timer6_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week2timer6FrcHeSet"] = 0x01
			elseif controlCmd["week2_timer6_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week2timer6FrcHeSet"] = 0x00
			end
		end

		-- 周二定时6静音等级
		if controlCmd["week2_timer6_mut_lev"] ~= nil then
			if controlCmd["week2_timer6_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week2timer6MutLev"] = 0x01
			elseif controlCmd["week2_timer6_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week2timer6MutLev"] = 0x00
			end
		end

		-- 周二定时6设定温度
		if controlCmd["week2_timer6_set_temp"] ~= nil then
			myTable["week2timer6SetTemp"] = string2Int(controlCmd["week2_timer6_set_temp"])
		end

		-- 周二定时器6开始时间：时
		if controlCmd["week2_timer6_open_time_hour"] ~= nil then
			myTable["week2timer6OpenTimeHour"] = string2Int(controlCmd["week2_timer6_open_time_hour"])
		end

		-- 周二定时器6开始时间：分
		if controlCmd["week2_timer6_open_time_min"] ~= nil then
			myTable["week2timer6OpenTimeMin"] = string2Int(controlCmd["week2_timer6_open_time_min"])
		end

		-- 周二定时器6结束时间：时
		if controlCmd["week2_timer6_close_time_hour"] ~= nil then
			myTable["week2timer6CloseTimeHour"] = string2Int(controlCmd["week2_timer6_close_time_hour"])
		end

		-- 周二定时器6结束时间：分
		if controlCmd["week2_timer6_close_time_min"] ~= nil then
			myTable["week2timer6CloseTimeMin"] = string2Int(controlCmd["week2_timer6_close_time_min"])
		end

		-- 周二定时1是否有效
		if controlCmd["week2_timer1_valid"] ~= nil then
			if controlCmd["week2_timer1_valid"] == VALUE_VALID then
				myTable["week2timer1Valid"] = 0x01
			elseif controlCmd["week2_timer1_valid"] == VALUE_INVALID then
				myTable["week2timer1Valid"] = 0x00
			end
		end

		-- 周二定时2是否有效
		if controlCmd["week2_timer2_valid"] ~= nil then
			if controlCmd["week2_timer2_valid"] == VALUE_VALID then
				myTable["week2timer2Valid"] = 0x02
			elseif controlCmd["week2_timer2_valid"] == VALUE_INVALID then
				myTable["week2timer2Valid"] = 0x00
			end
		end

		-- 周二定时3是否有效
		if controlCmd["week2_timer3_valid"] ~= nil then
			if controlCmd["week2_timer3_valid"] == VALUE_VALID then
				myTable["week2timer3Valid"] = 0x04
			elseif controlCmd["week2_timer3_valid"] == VALUE_INVALID then
				myTable["week2timer3Valid"] = 0x00
			end
		end

		-- 周二定时4是否有效
		if controlCmd["week2_timer4_valid"] ~= nil then
			if controlCmd["week2_timer4_valid"] == VALUE_VALID then
				myTable["week2timer4Valid"] = 0x08
			elseif controlCmd["week2_timer4_valid"] == VALUE_INVALID then
				myTable["week2timer4Valid"] = 0x00
			end
		end

		-- 周二定时5是否有效
		if controlCmd["week2_timer5_valid"] ~= nil then
			if controlCmd["week2_timer5_valid"] == VALUE_VALID then
				myTable["week2timer5Valid"] = 0x10
			elseif controlCmd["week2_timer5_valid"] == VALUE_INVALID then
				myTable["week2timer5Valid"] = 0x00
			end
		end

		-- 周二定时6是否有效
		if controlCmd["week2_timer6_valid"] ~= nil then
			if controlCmd["week2_timer6_valid"] == VALUE_VALID then
				myTable["week2timer6Valid"] = 0x20
			elseif controlCmd["week2_timer6_valid"] == VALUE_INVALID then
				myTable["week2timer6Valid"] = 0x00
			end
		end
	elseif myTable["controlType"] == 0x07 then
		-- 周三定时1开关
		if controlCmd["week3_timer1_effect"] ~= nil then
			if controlCmd["week3_timer1_effect"] == VALUE_FUNCTION_ON then
				myTable["week3timer1Effect"] = 0x01
			elseif controlCmd["week3_timer1_effect"] == VALUE_FUNCTION_OFF then
				myTable["week3timer1Effect"] = 0x00
			end
		end

		-- 周三定时2开关
		if controlCmd["week3_timer2_effect"] ~= nil then
			if controlCmd["week3_timer2_effect"] == VALUE_FUNCTION_ON then
				myTable["week3timer2Effect"] = 0x02
			elseif controlCmd["week3_timer2_effect"] == VALUE_FUNCTION_OFF then
				myTable["week3timer2Effect"] = 0x00
			end
		end

		-- 周三定时3开关
		if controlCmd["week3_timer3_effect"] ~= nil then
			if controlCmd["week3_timer3_effect"] == VALUE_FUNCTION_ON then
				myTable["week3timer3Effect"] = 0x04
			elseif controlCmd["week3_timer3_effect"] == VALUE_FUNCTION_OFF then
				myTable["week3timer3Effect"] = 0x00
			end
		end

		-- 周三定时4开关
		if controlCmd["week3_timer4_effect"] ~= nil then
			if controlCmd["week3_timer4_effect"] == VALUE_FUNCTION_ON then
				myTable["week3timer4Effect"] = 0x08
			elseif controlCmd["week3_timer4_effect"] == VALUE_FUNCTION_OFF then
				myTable["week3timer4Effect"] = 0x00
			end
		end

		-- 周三定时5开关
		if controlCmd["week3_timer5_effect"] ~= nil then
			if controlCmd["week3_timer5_effect"] == VALUE_FUNCTION_ON then
				myTable["week3timer5Effect"] = 0x10
			elseif controlCmd["week3_timer5_effect"] == VALUE_FUNCTION_OFF then
				myTable["week3timer5Effect"] = 0x00
			end
		end

		-- 周三定时6开关
		if controlCmd["week3_timer6_effect"] ~= nil then
			if controlCmd["week3_timer6_effect"] == VALUE_FUNCTION_ON then
				myTable["week3timer6Effect"] = 0x20
			elseif controlCmd["week3_timer6_effect"] == VALUE_FUNCTION_OFF then
				myTable["week3timer6Effect"] = 0x00
			end
		end

		-- 周三定时1设定模式
		if controlCmd["week3_timer1_set_mode"] ~= nil then
			if controlCmd["week3_timer1_set_mode"] == "off" then
				myTable["week3timer1SetMode"] = 0x00
			elseif controlCmd["week3_timer1_set_mode"] == "heat" then
				myTable["week3timer1SetMode"] = 0x01
			elseif controlCmd["week3_timer1_set_mode"] == "dhw" then
				myTable["week3timer1SetMode"] = 0x02
			elseif controlCmd["week3_timer1_set_mode"] == "cool" then
				myTable["week3timer1SetMode"] = 0x03
			elseif controlCmd["week3_timer1_set_mode"] == "waterpump" then
				myTable["week3timer1SetMode"] = 0x04
			elseif controlCmd["week3_timer1_set_mode"] == "auto" then
				myTable["week3timer1SetMode"] = 0x05
			end
		end

		-- 周三定时1静音开关
		if controlCmd["week3_timer1_mut_set"] ~= nil then
			if controlCmd["week3_timer1_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer1MutSet"] = 0x01
			elseif controlCmd["week3_timer1_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer1MutSet"] = 0x00
			end
		end

		-- 周三定时1强热开关
		if controlCmd["week3_timer1_frc_he_set"] ~= nil then
			if controlCmd["week3_timer1_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer1FrcHeSet"] = 0x01
			elseif controlCmd["week3_timer1_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer1FrcHeSet"] = 0x00
			end
		end

		-- 周三定时1静音等级
		if controlCmd["week3_timer1_mut_lev"] ~= nil then
			if controlCmd["week3_timer1_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week3timer1MutLev"] = 0x01
			elseif controlCmd["week3_timer1_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week3timer1MutLev"] = 0x00
			end
		end

		-- 周三定时1设定温度
		if controlCmd["week3_timer1_set_temp"] ~= nil then
			myTable["week3timer1SetTemp"] = string2Int(controlCmd["week3_timer1_set_temp"])
		end

		-- 周三定时器1开始时间：时
		if controlCmd["week3_timer1_open_time_hour"] ~= nil then
			myTable["week3timer1OpenTimeHour"] = string2Int(controlCmd["week3_timer1_open_time_hour"])
		end

		-- 周三定时器1开始时间：分
		if controlCmd["week3_timer1_open_time_min"] ~= nil then
			myTable["week3timer1OpenTimeMin"] = string2Int(controlCmd["week3_timer1_open_time_min"])
		end

		-- 周三定时器1结束时间：时
		if controlCmd["week3_timer1_close_time_hour"] ~= nil then
			myTable["week3timer1CloseTimeHour"] = string2Int(controlCmd["week3_timer1_close_time_hour"])
		end

		-- 周三定时器1结束时间：分
		if controlCmd["week3_timer1_close_time_min"] ~= nil then
			myTable["week3timer1CloseTimeMin"] = string2Int(controlCmd["week3_timer1_close_time_min"])
		end

		-- 周三定时2设定模式
		if controlCmd["week3_timer2_set_mode"] ~= nil then
			if controlCmd["week3_timer2_set_mode"] == "off" then
				myTable["week3timer2SetMode"] = 0x00
			elseif controlCmd["week3_timer2_set_mode"] == "heat" then
				myTable["week3timer2SetMode"] = 0x01
			elseif controlCmd["week3_timer2_set_mode"] == "dhw" then
				myTable["week3timer2SetMode"] = 0x02
			elseif controlCmd["week3_timer2_set_mode"] == "cool" then
				myTable["week3timer2SetMode"] = 0x03
			elseif controlCmd["week3_timer2_set_mode"] == "waterpump" then
				myTable["week3timer2SetMode"] = 0x04
			elseif controlCmd["week3_timer2_set_mode"] == "auto" then
				myTable["week3timer2SetMode"] = 0x05
			end
		end

		-- 周三定时2静音开关
		if controlCmd["week3_timer2_mut_set"] ~= nil then
			if controlCmd["week3_timer2_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer2MutSet"] = 0x01
			elseif controlCmd["week3_timer2_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer2MutSet"] = 0x00
			end
		end

		-- 周三定时2强热开关
		if controlCmd["week3_timer2_frc_he_set"] ~= nil then
			if controlCmd["week3_timer2_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer2FrcHeSet"] = 0x01
			elseif controlCmd["week3_timer2_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer2FrcHeSet"] = 0x00
			end
		end

		-- 周三定时2静音等级
		if controlCmd["week3_timer2_mut_lev"] ~= nil then
			if controlCmd["week3_timer2_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week3timer2MutLev"] = 0x01
			elseif controlCmd["week3_timer2_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week3timer2MutLev"] = 0x00
			end
		end

		-- 周三定时2设定温度
		if controlCmd["week3_timer2_set_temp"] ~= nil then
			myTable["week3timer2SetTemp"] = string2Int(controlCmd["week3_timer2_set_temp"])
		end

		-- 周三定时器2开始时间：时
		if controlCmd["week3_timer2_open_time_hour"] ~= nil then
			myTable["week3timer2OpenTimeHour"] = string2Int(controlCmd["week3_timer2_open_time_hour"])
		end

		-- 周三定时器2开始时间：分
		if controlCmd["week3_timer2_open_time_min"] ~= nil then
			myTable["week3timer2OpenTimeMin"] = string2Int(controlCmd["week3_timer2_open_time_min"])
		end

		-- 周三定时器2结束时间：时
		if controlCmd["week3_timer2_close_time_hour"] ~= nil then
			myTable["week3timer2CloseTimeHour"] = string2Int(controlCmd["week3_timer2_close_time_hour"])
		end

		-- 周三定时器2结束时间：分
		if controlCmd["week3_timer2_close_time_min"] ~= nil then
			myTable["week3timer2CloseTimeMin"] = string2Int(controlCmd["week3_timer2_close_time_min"])
		end

		-- 周三定时3设定模式
		if controlCmd["week3_timer3_set_mode"] ~= nil then
			if controlCmd["week3_timer3_set_mode"] == "off" then
				myTable["week3timer3SetMode"] = 0x00
			elseif controlCmd["week3_timer3_set_mode"] == "heat" then
				myTable["week3timer3SetMode"] = 0x01
			elseif controlCmd["week3_timer3_set_mode"] == "dhw" then
				myTable["week3timer3SetMode"] = 0x02
			elseif controlCmd["week3_timer3_set_mode"] == "cool" then
				myTable["week3timer3SetMode"] = 0x03
			elseif controlCmd["week3_timer3_set_mode"] == "waterpump" then
				myTable["week3timer3SetMode"] = 0x04
			elseif controlCmd["week3_timer3_set_mode"] == "auto" then
				myTable["week3timer3SetMode"] = 0x05
			end
		end

		-- 周三定时3静音开关
		if controlCmd["week3_timer3_mut_set"] ~= nil then
			if controlCmd["week3_timer3_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer3MutSet"] = 0x01
			elseif controlCmd["week3_timer3_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer3MutSet"] = 0x00
			end
		end

		-- 周三定时3强热开关
		if controlCmd["week3_timer3_frc_he_set"] ~= nil then
			if controlCmd["week3_timer3_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer3FrcHeSet"] = 0x01
			elseif controlCmd["week3_timer3_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer3FrcHeSet"] = 0x00
			end
		end

		-- 周三定时3静音等级
		if controlCmd["week3_timer3_mut_lev"] ~= nil then
			if controlCmd["week3_timer3_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week3timer3MutLev"] = 0x01
			elseif controlCmd["week3_timer3_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week3timer3MutLev"] = 0x00
			end
		end

		-- 周三定时3设定温度
		if controlCmd["week3_timer3_set_temp"] ~= nil then
			myTable["week3timer3SetTemp"] = string2Int(controlCmd["week3_timer3_set_temp"])
		end

		-- 周三定时器3开始时间：时
		if controlCmd["week3_timer3_open_time_hour"] ~= nil then
			myTable["week3timer3OpenTimeHour"] = string2Int(controlCmd["week3_timer3_open_time_hour"])
		end

		-- 周三定时器3开始时间：分
		if controlCmd["week3_timer3_open_time_min"] ~= nil then
			myTable["week3timer3OpenTimeMin"] = string2Int(controlCmd["week3_timer3_open_time_min"])
		end

		-- 周三定时器3结束时间：时
		if controlCmd["week3_timer3_close_time_hour"] ~= nil then
			myTable["week3timer3CloseTimeHour"] = string2Int(controlCmd["week3_timer3_close_time_hour"])
		end

		-- 周三定时器3结束时间：分
		if controlCmd["week3_timer3_close_time_min"] ~= nil then
			myTable["week3timer3CloseTimeMin"] = string2Int(controlCmd["week3_timer3_close_time_min"])
		end

		-- 周三定时4设定模式
		if controlCmd["week3_timer4_set_mode"] ~= nil then
			if controlCmd["week3_timer4_set_mode"] == "off" then
				myTable["week3timer4SetMode"] = 0x00
			elseif controlCmd["week3_timer4_set_mode"] == "heat" then
				myTable["week3timer4SetMode"] = 0x01
			elseif controlCmd["week3_timer4_set_mode"] == "dhw" then
				myTable["week3timer4SetMode"] = 0x02
			elseif controlCmd["week3_timer4_set_mode"] == "cool" then
				myTable["week3timer4SetMode"] = 0x03
			elseif controlCmd["week3_timer4_set_mode"] == "waterpump" then
				myTable["week3timer4SetMode"] = 0x04
			elseif controlCmd["week3_timer4_set_mode"] == "auto" then
				myTable["week3timer4SetMode"] = 0x05
			end
		end

		-- 周三定时4静音开关
		if controlCmd["week3_timer4_mut_set"] ~= nil then
			if controlCmd["week3_timer4_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer4MutSet"] = 0x01
			elseif controlCmd["week3_timer4_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer4MutSet"] = 0x00
			end
		end

		-- 周三定时4强热开关
		if controlCmd["week3_timer4_frc_he_set"] ~= nil then
			if controlCmd["week3_timer4_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer4FrcHeSet"] = 0x01
			elseif controlCmd["week3_timer4_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer4FrcHeSet"] = 0x00
			end
		end

		-- 周三定时4静音等级
		if controlCmd["week3_timer4_mut_lev"] ~= nil then
			if controlCmd["week3_timer4_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week3timer4MutLev"] = 0x01
			elseif controlCmd["week3_timer4_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week3timer4MutLev"] = 0x00
			end
		end

		-- 周三定时4设定温度
		if controlCmd["week3_timer4_set_temp"] ~= nil then
			myTable["week3timer4SetTemp"] = string2Int(controlCmd["week3_timer4_set_temp"])
		end

		-- 周三定时器4开始时间：时
		if controlCmd["week3_timer4_open_time_hour"] ~= nil then
			myTable["week3timer4OpenTimeHour"] = string2Int(controlCmd["week3_timer4_open_time_hour"])
		end

		-- 周三定时器4开始时间：分
		if controlCmd["week3_timer4_open_time_min"] ~= nil then
			myTable["week3timer4OpenTimeMin"] = string2Int(controlCmd["week3_timer4_open_time_min"])
		end

		-- 周三定时器4结束时间：时
		if controlCmd["week3_timer4_close_time_hour"] ~= nil then
			myTable["week3timer4CloseTimeHour"] = string2Int(controlCmd["week3_timer4_close_time_hour"])
		end

		-- 周三定时器4结束时间：分
		if controlCmd["week3_timer4_close_time_min"] ~= nil then
			myTable["week3timer4CloseTimeMin"] = string2Int(controlCmd["week3_timer4_close_time_min"])
		end

		-- 周三定时5设定模式
		if controlCmd["week3_timer5_set_mode"] ~= nil then
			if controlCmd["week3_timer5_set_mode"] == "off" then
				myTable["week3timer5SetMode"] = 0x00
			elseif controlCmd["week3_timer5_set_mode"] == "heat" then
				myTable["week3timer5SetMode"] = 0x01
			elseif controlCmd["week3_timer5_set_mode"] == "dhw" then
				myTable["week3timer5SetMode"] = 0x02
			elseif controlCmd["week3_timer5_set_mode"] == "cool" then
				myTable["week3timer5SetMode"] = 0x03
			elseif controlCmd["week3_timer5_set_mode"] == "waterpump" then
				myTable["week3timer5SetMode"] = 0x04
			elseif controlCmd["week3_timer5_set_mode"] == "auto" then
				myTable["week3timer5SetMode"] = 0x05
			end
		end

		-- 周三定时5静音开关
		if controlCmd["week3_timer5_mut_set"] ~= nil then
			if controlCmd["week3_timer5_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer5MutSet"] = 0x01
			elseif controlCmd["week3_timer5_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer5MutSet"] = 0x00
			end
		end

		-- 周三定时5强热开关
		if controlCmd["week3_timer5_frc_he_set"] ~= nil then
			if controlCmd["week3_timer5_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer5FrcHeSet"] = 0x01
			elseif controlCmd["week3_timer5_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer5FrcHeSet"] = 0x00
			end
		end

		-- 周三定时5静音等级
		if controlCmd["week3_timer5_mut_lev"] ~= nil then
			if controlCmd["week3_timer5_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week3timer5MutLev"] = 0x01
			elseif controlCmd["week3_timer5_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week3timer5MutLev"] = 0x00
			end
		end

		-- 周三定时5设定温度
		if controlCmd["week3_timer5_set_temp"] ~= nil then
			myTable["week3timer5SetTemp"] = string2Int(controlCmd["week3_timer5_set_temp"])
		end

		-- 周三定时器5开始时间：时
		if controlCmd["week3_timer5_open_time_hour"] ~= nil then
			myTable["week3timer5OpenTimeHour"] = string2Int(controlCmd["week3_timer5_open_time_hour"])
		end

		-- 周三定时器5开始时间：分
		if controlCmd["week3_timer5_open_time_min"] ~= nil then
			myTable["week3timer5OpenTimeMin"] = string2Int(controlCmd["week3_timer5_open_time_min"])
		end

		-- 周三定时器5结束时间：时
		if controlCmd["week3_timer5_close_time_hour"] ~= nil then
			myTable["week3timer5CloseTimeHour"] = string2Int(controlCmd["week3_timer5_close_time_hour"])
		end

		-- 周三定时器5结束时间：分
		if controlCmd["week3_timer5_close_time_min"] ~= nil then
			myTable["week3timer5CloseTimeMin"] = string2Int(controlCmd["week3_timer5_close_time_min"])
		end

		-- 周三定时6设定模式
		if controlCmd["week3_timer6_set_mode"] ~= nil then
			if controlCmd["week3_timer6_set_mode"] == "off" then
				myTable["week3timer6SetMode"] = 0x00
			elseif controlCmd["week3_timer6_set_mode"] == "heat" then
				myTable["week3timer6SetMode"] = 0x01
			elseif controlCmd["week3_timer6_set_mode"] == "dhw" then
				myTable["week3timer6SetMode"] = 0x02
			elseif controlCmd["week3_timer6_set_mode"] == "cool" then
				myTable["week3timer6SetMode"] = 0x03
			elseif controlCmd["week3_timer6_set_mode"] == "waterpump" then
				myTable["week3timer6SetMode"] = 0x04
			elseif controlCmd["week3_timer6_set_mode"] == "auto" then
				myTable["week3timer6SetMode"] = 0x05
			end
		end

		-- 周三定时6静音开关
		if controlCmd["week3_timer6_mut_set"] ~= nil then
			if controlCmd["week3_timer6_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer6MutSet"] = 0x01
			elseif controlCmd["week3_timer6_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer6MutSet"] = 0x00
			end
		end

		-- 周三定时6强热开关
		if controlCmd["week3_timer6_frc_he_set"] ~= nil then
			if controlCmd["week3_timer6_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week3timer6FrcHeSet"] = 0x01
			elseif controlCmd["week3_timer6_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week3timer6FrcHeSet"] = 0x00
			end
		end

		-- 周三定时6静音等级
		if controlCmd["week3_timer6_mut_lev"] ~= nil then
			if controlCmd["week3_timer6_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week3timer6MutLev"] = 0x01
			elseif controlCmd["week3_timer6_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week3timer6MutLev"] = 0x00
			end
		end

		-- 周三定时6设定温度
		if controlCmd["week3_timer6_set_temp"] ~= nil then
			myTable["week3timer6SetTemp"] = string2Int(controlCmd["week3_timer6_set_temp"])
		end

		-- 周三定时器6开始时间：时
		if controlCmd["week3_timer6_open_time_hour"] ~= nil then
			myTable["week3timer6OpenTimeHour"] = string2Int(controlCmd["week3_timer6_open_time_hour"])
		end

		-- 周三定时器6开始时间：分
		if controlCmd["week3_timer6_open_time_min"] ~= nil then
			myTable["week3timer6OpenTimeMin"] = string2Int(controlCmd["week3_timer6_open_time_min"])
		end

		-- 周三定时器6结束时间：时
		if controlCmd["week3_timer6_close_time_hour"] ~= nil then
			myTable["week3timer6CloseTimeHour"] = string2Int(controlCmd["week3_timer6_close_time_hour"])
		end

		-- 周三定时器6结束时间：分
		if controlCmd["week3_timer6_close_time_min"] ~= nil then
			myTable["week3timer6CloseTimeMin"] = string2Int(controlCmd["week3_timer6_close_time_min"])
		end

		-- 周三定时1是否有效
		if controlCmd["week3_timer1_valid"] ~= nil then
			if controlCmd["week3_timer1_valid"] == VALUE_VALID then
				myTable["week3timer1Valid"] = 0x01
			elseif controlCmd["week3_timer1_valid"] == VALUE_INVALID then
				myTable["week3timer1Valid"] = 0x00
			end
		end

		-- 周三定时2是否有效
		if controlCmd["week3_timer2_valid"] ~= nil then
			if controlCmd["week3_timer2_valid"] == VALUE_VALID then
				myTable["week3timer2Valid"] = 0x02
			elseif controlCmd["week3_timer2_valid"] == VALUE_INVALID then
				myTable["week3timer2Valid"] = 0x00
			end
		end

		-- 周三定时3是否有效
		if controlCmd["week3_timer3_valid"] ~= nil then
			if controlCmd["week3_timer3_valid"] == VALUE_VALID then
				myTable["week3timer3Valid"] = 0x04
			elseif controlCmd["week3_timer3_valid"] == VALUE_INVALID then
				myTable["week3timer3Valid"] = 0x00
			end
		end

		-- 周三定时4是否有效
		if controlCmd["week3_timer4_valid"] ~= nil then
			if controlCmd["week3_timer4_valid"] == VALUE_VALID then
				myTable["week3timer4Valid"] = 0x08
			elseif controlCmd["week3_timer4_valid"] == VALUE_INVALID then
				myTable["week3timer4Valid"] = 0x00
			end
		end

		-- 周三定时5是否有效
		if controlCmd["week3_timer5_valid"] ~= nil then
			if controlCmd["week3_timer5_valid"] == VALUE_VALID then
				myTable["week3timer5Valid"] = 0x10
			elseif controlCmd["week3_timer5_valid"] == VALUE_INVALID then
				myTable["week3timer5Valid"] = 0x00
			end
		end

		-- 周三定时6是否有效
		if controlCmd["week3_timer6_valid"] ~= nil then
			if controlCmd["week3_timer6_valid"] == VALUE_VALID then
				myTable["week3timer6Valid"] = 0x20
			elseif controlCmd["week3_timer6_valid"] == VALUE_INVALID then
				myTable["week3timer6Valid"] = 0x00
			end
		end
	elseif myTable["controlType"] == 0x08 then
		-- 周四定时1开关
		if controlCmd["week4_timer1_effect"] ~= nil then
			if controlCmd["week4_timer1_effect"] == VALUE_FUNCTION_ON then
				myTable["week4timer1Effect"] = 0x01
			elseif controlCmd["week4_timer1_effect"] == VALUE_FUNCTION_OFF then
				myTable["week4timer1Effect"] = 0x00
			end
		end

		-- 周四定时2开关
		if controlCmd["week4_timer2_effect"] ~= nil then
			if controlCmd["week4_timer2_effect"] == VALUE_FUNCTION_ON then
				myTable["week4timer2Effect"] = 0x02
			elseif controlCmd["week4_timer2_effect"] == VALUE_FUNCTION_OFF then
				myTable["week4timer2Effect"] = 0x00
			end
		end

		-- 周四定时3开关
		if controlCmd["week4_timer3_effect"] ~= nil then
			if controlCmd["week4_timer3_effect"] == VALUE_FUNCTION_ON then
				myTable["week4timer3Effect"] = 0x04
			elseif controlCmd["week4_timer3_effect"] == VALUE_FUNCTION_OFF then
				myTable["week4timer3Effect"] = 0x00
			end
		end

		-- 周四定时4开关
		if controlCmd["week4_timer4_effect"] ~= nil then
			if controlCmd["week4_timer4_effect"] == VALUE_FUNCTION_ON then
				myTable["week4timer4Effect"] = 0x08
			elseif controlCmd["week4_timer4_effect"] == VALUE_FUNCTION_OFF then
				myTable["week4timer4Effect"] = 0x00
			end
		end

		-- 周四定时5开关
		if controlCmd["week4_timer5_effect"] ~= nil then
			if controlCmd["week4_timer5_effect"] == VALUE_FUNCTION_ON then
				myTable["week4timer5Effect"] = 0x10
			elseif controlCmd["week4_timer5_effect"] == VALUE_FUNCTION_OFF then
				myTable["week4timer5Effect"] = 0x00
			end
		end

		-- 周四定时6开关
		if controlCmd["week4_timer6_effect"] ~= nil then
			if controlCmd["week4_timer6_effect"] == VALUE_FUNCTION_ON then
				myTable["week4timer6Effect"] = 0x20
			elseif controlCmd["week4_timer6_effect"] == VALUE_FUNCTION_OFF then
				myTable["week4timer6Effect"] = 0x00
			end
		end

		-- 周四定时1设定模式
		if controlCmd["week4_timer1_set_mode"] ~= nil then
			if controlCmd["week4_timer1_set_mode"] == "off" then
				myTable["week4timer1SetMode"] = 0x00
			elseif controlCmd["week4_timer1_set_mode"] == "heat" then
				myTable["week4timer1SetMode"] = 0x01
			elseif controlCmd["week4_timer1_set_mode"] == "dhw" then
				myTable["week4timer1SetMode"] = 0x02
			elseif controlCmd["week4_timer1_set_mode"] == "cool" then
				myTable["week4timer1SetMode"] = 0x03
			elseif controlCmd["week4_timer1_set_mode"] == "waterpump" then
				myTable["week4timer1SetMode"] = 0x04
			elseif controlCmd["week4_timer1_set_mode"] == "auto" then
				myTable["week4timer1SetMode"] = 0x05
			end
		end

		-- 周四定时1静音开关
		if controlCmd["week4_timer1_mut_set"] ~= nil then
			if controlCmd["week4_timer1_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer1MutSet"] = 0x01
			elseif controlCmd["week4_timer1_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer1MutSet"] = 0x00
			end
		end

		-- 周四定时1强热开关
		if controlCmd["week4_timer1_frc_he_set"] ~= nil then
			if controlCmd["week4_timer1_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer1FrcHeSet"] = 0x01
			elseif controlCmd["week4_timer1_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer1FrcHeSet"] = 0x00
			end
		end

		-- 周四定时1静音等级
		if controlCmd["week4_timer1_mut_lev"] ~= nil then
			if controlCmd["week4_timer1_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week4timer1MutLev"] = 0x01
			elseif controlCmd["week4_timer1_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week4timer1MutLev"] = 0x00
			end
		end

		-- 周四定时1设定温度
		if controlCmd["week4_timer1_set_temp"] ~= nil then
			myTable["week4timer1SetTemp"] = string2Int(controlCmd["week4_timer1_set_temp"])
		end

		-- 周四定时器1开始时间：时
		if controlCmd["week4_timer1_open_time_hour"] ~= nil then
			myTable["week4timer1OpenTimeHour"] = string2Int(controlCmd["week4_timer1_open_time_hour"])
		end

		-- 周四定时器1开始时间：分
		if controlCmd["week4_timer1_open_time_min"] ~= nil then
			myTable["week4timer1OpenTimeMin"] = string2Int(controlCmd["week4_timer1_open_time_min"])
		end

		-- 周四定时器1结束时间：时
		if controlCmd["week4_timer1_close_time_hour"] ~= nil then
			myTable["week4timer1CloseTimeHour"] = string2Int(controlCmd["week4_timer1_close_time_hour"])
		end

		-- 周四定时器1结束时间：分
		if controlCmd["week4_timer1_close_time_min"] ~= nil then
			myTable["week4timer1CloseTimeMin"] = string2Int(controlCmd["week4_timer1_close_time_min"])
		end

		-- 周四定时2设定模式
		if controlCmd["week4_timer2_set_mode"] ~= nil then
			if controlCmd["week4_timer2_set_mode"] == "off" then
				myTable["week4timer2SetMode"] = 0x00
			elseif controlCmd["week4_timer2_set_mode"] == "heat" then
				myTable["week4timer2SetMode"] = 0x01
			elseif controlCmd["week4_timer2_set_mode"] == "dhw" then
				myTable["week4timer2SetMode"] = 0x02
			elseif controlCmd["week4_timer2_set_mode"] == "cool" then
				myTable["week4timer2SetMode"] = 0x03
			elseif controlCmd["week4_timer2_set_mode"] == "waterpump" then
				myTable["week4timer2SetMode"] = 0x04
			elseif controlCmd["week4_timer2_set_mode"] == "auto" then
				myTable["week4timer2SetMode"] = 0x05
			end
		end

		-- 周四定时2静音开关
		if controlCmd["week4_timer2_mut_set"] ~= nil then
			if controlCmd["week4_timer2_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer2MutSet"] = 0x01
			elseif controlCmd["week4_timer2_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer2MutSet"] = 0x00
			end
		end

		-- 周四定时2强热开关
		if controlCmd["week4_timer2_frc_he_set"] ~= nil then
			if controlCmd["week4_timer2_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer2FrcHeSet"] = 0x01
			elseif controlCmd["week4_timer2_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer2FrcHeSet"] = 0x00
			end
		end

		-- 周四定时2静音等级
		if controlCmd["week4_timer2_mut_lev"] ~= nil then
			if controlCmd["week4_timer2_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week4timer2MutLev"] = 0x01
			elseif controlCmd["week4_timer2_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week4timer2MutLev"] = 0x00
			end
		end

		-- 周四定时2设定温度
		if controlCmd["week4_timer2_set_temp"] ~= nil then
			myTable["week4timer2SetTemp"] = string2Int(controlCmd["week4_timer2_set_temp"])
		end

		-- 周四定时器2开始时间：时
		if controlCmd["week4_timer2_open_time_hour"] ~= nil then
			myTable["week4timer2OpenTimeHour"] = string2Int(controlCmd["week4_timer2_open_time_hour"])
		end

		-- 周四定时器2开始时间：分
		if controlCmd["week4_timer2_open_time_min"] ~= nil then
			myTable["week4timer2OpenTimeMin"] = string2Int(controlCmd["week4_timer2_open_time_min"])
		end

		-- 周四定时器2结束时间：时
		if controlCmd["week4_timer2_close_time_hour"] ~= nil then
			myTable["week4timer2CloseTimeHour"] = string2Int(controlCmd["week4_timer2_close_time_hour"])
		end

		-- 周四定时器2结束时间：分
		if controlCmd["week4_timer2_close_time_min"] ~= nil then
			myTable["week4timer2CloseTimeMin"] = string2Int(controlCmd["week4_timer2_close_time_min"])
		end

		-- 周四定时3设定模式
		if controlCmd["week4_timer3_set_mode"] ~= nil then
			if controlCmd["week4_timer3_set_mode"] == "off" then
				myTable["week4timer3SetMode"] = 0x00
			elseif controlCmd["week4_timer3_set_mode"] == "heat" then
				myTable["week4timer3SetMode"] = 0x01
			elseif controlCmd["week4_timer3_set_mode"] == "dhw" then
				myTable["week4timer3SetMode"] = 0x02
			elseif controlCmd["week4_timer3_set_mode"] == "cool" then
				myTable["week4timer3SetMode"] = 0x03
			elseif controlCmd["week4_timer3_set_mode"] == "waterpump" then
				myTable["week4timer3SetMode"] = 0x04
			elseif controlCmd["week4_timer3_set_mode"] == "auto" then
				myTable["week4timer3SetMode"] = 0x05
			end
		end

		-- 周四定时3静音开关
		if controlCmd["week4_timer3_mut_set"] ~= nil then
			if controlCmd["week4_timer3_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer3MutSet"] = 0x01
			elseif controlCmd["week4_timer3_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer3MutSet"] = 0x00
			end
		end

		-- 周四定时3强热开关
		if controlCmd["week4_timer3_frc_he_set"] ~= nil then
			if controlCmd["week4_timer3_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer3FrcHeSet"] = 0x01
			elseif controlCmd["week4_timer3_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer3FrcHeSet"] = 0x00
			end
		end

		-- 周四定时3静音等级
		if controlCmd["week4_timer3_mut_lev"] ~= nil then
			if controlCmd["week4_timer3_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week4timer3MutLev"] = 0x01
			elseif controlCmd["week4_timer3_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week4timer3MutLev"] = 0x00
			end
		end

		-- 周四定时3设定温度
		if controlCmd["week4_timer3_set_temp"] ~= nil then
			myTable["week4timer3SetTemp"] = string2Int(controlCmd["week4_timer3_set_temp"])
		end

		-- 周四定时器3开始时间：时
		if controlCmd["week4_timer3_open_time_hour"] ~= nil then
			myTable["week4timer3OpenTimeHour"] = string2Int(controlCmd["week4_timer3_open_time_hour"])
		end

		-- 周四定时器3开始时间：分
		if controlCmd["week4_timer3_open_time_min"] ~= nil then
			myTable["week4timer3OpenTimeMin"] = string2Int(controlCmd["week4_timer3_open_time_min"])
		end

		-- 周四定时器3结束时间：时
		if controlCmd["week4_timer3_close_time_hour"] ~= nil then
			myTable["week4timer3CloseTimeHour"] = string2Int(controlCmd["week4_timer3_close_time_hour"])
		end

		-- 周四定时器3结束时间：分
		if controlCmd["week4_timer3_close_time_min"] ~= nil then
			myTable["week4timer3CloseTimeMin"] = string2Int(controlCmd["week4_timer3_close_time_min"])
		end

		-- 周四定时4设定模式
		if controlCmd["week4_timer4_set_mode"] ~= nil then
			if controlCmd["week4_timer4_set_mode"] == "off" then
				myTable["week4timer4SetMode"] = 0x00
			elseif controlCmd["week4_timer4_set_mode"] == "heat" then
				myTable["week4timer4SetMode"] = 0x01
			elseif controlCmd["week4_timer4_set_mode"] == "dhw" then
				myTable["week4timer4SetMode"] = 0x02
			elseif controlCmd["week4_timer4_set_mode"] == "cool" then
				myTable["week4timer4SetMode"] = 0x03
			elseif controlCmd["week4_timer4_set_mode"] == "waterpump" then
				myTable["week4timer4SetMode"] = 0x04
			elseif controlCmd["week4_timer4_set_mode"] == "auto" then
				myTable["week4timer4SetMode"] = 0x05
			end
		end

		-- 周四定时4静音开关
		if controlCmd["week4_timer4_mut_set"] ~= nil then
			if controlCmd["week4_timer4_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer4MutSet"] = 0x01
			elseif controlCmd["week4_timer4_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer4MutSet"] = 0x00
			end
		end

		-- 周四定时4强热开关
		if controlCmd["week4_timer4_frc_he_set"] ~= nil then
			if controlCmd["week4_timer4_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer4FrcHeSet"] = 0x01
			elseif controlCmd["week4_timer4_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer4FrcHeSet"] = 0x00
			end
		end

		-- 周四定时4静音等级
		if controlCmd["week4_timer4_mut_lev"] ~= nil then
			if controlCmd["week4_timer4_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week4timer4MutLev"] = 0x01
			elseif controlCmd["week4_timer4_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week4timer4MutLev"] = 0x00
			end
		end

		-- 周四定时4设定温度
		if controlCmd["week4_timer4_set_temp"] ~= nil then
			myTable["week4timer4SetTemp"] = string2Int(controlCmd["week4_timer4_set_temp"])
		end

		-- 周四定时器4开始时间：时
		if controlCmd["week4_timer4_open_time_hour"] ~= nil then
			myTable["week4timer4OpenTimeHour"] = string2Int(controlCmd["week4_timer4_open_time_hour"])
		end

		-- 周四定时器4开始时间：分
		if controlCmd["week4_timer4_open_time_min"] ~= nil then
			myTable["week4timer4OpenTimeMin"] = string2Int(controlCmd["week4_timer4_open_time_min"])
		end

		-- 周四定时器4结束时间：时
		if controlCmd["week4_timer4_close_time_hour"] ~= nil then
			myTable["week4timer4CloseTimeHour"] = string2Int(controlCmd["week4_timer4_close_time_hour"])
		end

		-- 周四定时器4结束时间：分
		if controlCmd["week4_timer4_close_time_min"] ~= nil then
			myTable["week4timer4CloseTimeMin"] = string2Int(controlCmd["week4_timer4_close_time_min"])
		end

		-- 周四定时5设定模式
		if controlCmd["week4_timer5_set_mode"] ~= nil then
			if controlCmd["week4_timer5_set_mode"] == "off" then
				myTable["week4timer5SetMode"] = 0x00
			elseif controlCmd["week4_timer5_set_mode"] == "heat" then
				myTable["week4timer5SetMode"] = 0x01
			elseif controlCmd["week4_timer5_set_mode"] == "dhw" then
				myTable["week4timer5SetMode"] = 0x02
			elseif controlCmd["week4_timer5_set_mode"] == "cool" then
				myTable["week4timer5SetMode"] = 0x03
			elseif controlCmd["week4_timer5_set_mode"] == "waterpump" then
				myTable["week4timer5SetMode"] = 0x04
			elseif controlCmd["week4_timer5_set_mode"] == "auto" then
				myTable["week4timer5SetMode"] = 0x05
			end
		end

		-- 周四定时5静音开关
		if controlCmd["week4_timer5_mut_set"] ~= nil then
			if controlCmd["week4_timer5_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer5MutSet"] = 0x01
			elseif controlCmd["week4_timer5_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer5MutSet"] = 0x00
			end
		end

		-- 周四定时5强热开关
		if controlCmd["week4_timer5_frc_he_set"] ~= nil then
			if controlCmd["week4_timer5_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer5FrcHeSet"] = 0x01
			elseif controlCmd["week4_timer5_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer5FrcHeSet"] = 0x00
			end
		end

		-- 周四定时5静音等级
		if controlCmd["week4_timer5_mut_lev"] ~= nil then
			if controlCmd["week4_timer5_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week4timer5MutLev"] = 0x01
			elseif controlCmd["week4_timer5_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week4timer5MutLev"] = 0x00
			end
		end

		-- 周四定时5设定温度
		if controlCmd["week4_timer5_set_temp"] ~= nil then
			myTable["week4timer5SetTemp"] = string2Int(controlCmd["week4_timer5_set_temp"])
		end

		-- 周四定时器5开始时间：时
		if controlCmd["week4_timer5_open_time_hour"] ~= nil then
			myTable["week4timer5OpenTimeHour"] = string2Int(controlCmd["week4_timer5_open_time_hour"])
		end

		-- 周四定时器5开始时间：分
		if controlCmd["week4_timer5_open_time_min"] ~= nil then
			myTable["week4timer5OpenTimeMin"] = string2Int(controlCmd["week4_timer5_open_time_min"])
		end

		-- 周四定时器5结束时间：时
		if controlCmd["week4_timer5_close_time_hour"] ~= nil then
			myTable["week4timer5CloseTimeHour"] = string2Int(controlCmd["week4_timer5_close_time_hour"])
		end

		-- 周四定时器5结束时间：分
		if controlCmd["week4_timer5_close_time_min"] ~= nil then
			myTable["week4timer5CloseTimeMin"] = string2Int(controlCmd["week4_timer5_close_time_min"])
		end

		-- 周四定时6设定模式
		if controlCmd["week4_timer6_set_mode"] ~= nil then
			if controlCmd["week4_timer6_set_mode"] == "off" then
				myTable["week4timer6SetMode"] = 0x00
			elseif controlCmd["week4_timer6_set_mode"] == "heat" then
				myTable["week4timer6SetMode"] = 0x01
			elseif controlCmd["week4_timer6_set_mode"] == "dhw" then
				myTable["week4timer6SetMode"] = 0x02
			elseif controlCmd["week4_timer6_set_mode"] == "cool" then
				myTable["week4timer6SetMode"] = 0x03
			elseif controlCmd["week4_timer6_set_mode"] == "waterpump" then
				myTable["week4timer6SetMode"] = 0x04
			elseif controlCmd["week4_timer6_set_mode"] == "auto" then
				myTable["week4timer6SetMode"] = 0x05
			end
		end

		-- 周四定时6静音开关
		if controlCmd["week4_timer6_mut_set"] ~= nil then
			if controlCmd["week4_timer6_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer6MutSet"] = 0x01
			elseif controlCmd["week4_timer6_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer6MutSet"] = 0x00
			end
		end

		-- 周四定时6强热开关
		if controlCmd["week4_timer6_frc_he_set"] ~= nil then
			if controlCmd["week4_timer6_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week4timer6FrcHeSet"] = 0x01
			elseif controlCmd["week4_timer6_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week4timer6FrcHeSet"] = 0x00
			end
		end

		-- 周四定时6静音等级
		if controlCmd["week4_timer6_mut_lev"] ~= nil then
			if controlCmd["week4_timer6_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week4timer6MutLev"] = 0x01
			elseif controlCmd["week4_timer6_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week4timer6MutLev"] = 0x00
			end
		end

		-- 周四定时6设定温度
		if controlCmd["week4_timer6_set_temp"] ~= nil then
			myTable["week4timer6SetTemp"] = string2Int(controlCmd["week4_timer6_set_temp"])
		end

		-- 周四定时器6开始时间：时
		if controlCmd["week4_timer6_open_time_hour"] ~= nil then
			myTable["week4timer6OpenTimeHour"] = string2Int(controlCmd["week4_timer6_open_time_hour"])
		end

		-- 周四定时器6开始时间：分
		if controlCmd["week4_timer6_open_time_min"] ~= nil then
			myTable["week4timer6OpenTimeMin"] = string2Int(controlCmd["week4_timer6_open_time_min"])
		end

		-- 周四定时器6结束时间：时
		if controlCmd["week4_timer6_close_time_hour"] ~= nil then
			myTable["week4timer6CloseTimeHour"] = string2Int(controlCmd["week4_timer6_close_time_hour"])
		end

		-- 周四定时器6结束时间：分
		if controlCmd["week4_timer6_close_time_min"] ~= nil then
			myTable["week4timer6CloseTimeMin"] = string2Int(controlCmd["week4_timer6_close_time_min"])
		end

		-- 周四定时1是否有效
		if controlCmd["week4_timer1_valid"] ~= nil then
			if controlCmd["week4_timer1_valid"] == VALUE_VALID then
				myTable["week4timer1Valid"] = 0x01
			elseif controlCmd["week4_timer1_valid"] == VALUE_INVALID then
				myTable["week4timer1Valid"] = 0x00
			end
		end

		-- 周四定时2是否有效
		if controlCmd["week4_timer2_valid"] ~= nil then
			if controlCmd["week4_timer2_valid"] == VALUE_VALID then
				myTable["week4timer2Valid"] = 0x02
			elseif controlCmd["week4_timer2_valid"] == VALUE_INVALID then
				myTable["week4timer2Valid"] = 0x00
			end
		end

		-- 周四定时3是否有效
		if controlCmd["week4_timer3_valid"] ~= nil then
			if controlCmd["week4_timer3_valid"] == VALUE_VALID then
				myTable["week4timer3Valid"] = 0x04
			elseif controlCmd["week4_timer3_valid"] == VALUE_INVALID then
				myTable["week4timer3Valid"] = 0x00
			end
		end

		-- 周四定时4是否有效
		if controlCmd["week4_timer4_valid"] ~= nil then
			if controlCmd["week4_timer4_valid"] == VALUE_VALID then
				myTable["week4timer4Valid"] = 0x08
			elseif controlCmd["week4_timer4_valid"] == VALUE_INVALID then
				myTable["week4timer4Valid"] = 0x00
			end
		end

		-- 周四定时5是否有效
		if controlCmd["week4_timer5_valid"] ~= nil then
			if controlCmd["week4_timer5_valid"] == VALUE_VALID then
				myTable["week4timer5Valid"] = 0x10
			elseif controlCmd["week4_timer5_valid"] == VALUE_INVALID then
				myTable["week4timer5Valid"] = 0x00
			end
		end

		-- 周四定时6是否有效
		if controlCmd["week4_timer6_valid"] ~= nil then
			if controlCmd["week4_timer6_valid"] == VALUE_VALID then
				myTable["week4timer6Valid"] = 0x20
			elseif controlCmd["week4_timer6_valid"] == VALUE_INVALID then
				myTable["week4timer6Valid"] = 0x00
			end
		end
	elseif myTable["controlType"] == 0x09 then
		-- 周五定时1开关
		if controlCmd["week5_timer1_effect"] ~= nil then
			if controlCmd["week5_timer1_effect"] == VALUE_FUNCTION_ON then
				myTable["week5timer1Effect"] = 0x01
			elseif controlCmd["week5_timer1_effect"] == VALUE_FUNCTION_OFF then
				myTable["week5timer1Effect"] = 0x00
			end
		end

		-- 周五定时2开关
		if controlCmd["week5_timer2_effect"] ~= nil then
			if controlCmd["week5_timer2_effect"] == VALUE_FUNCTION_ON then
				myTable["week5timer2Effect"] = 0x02
			elseif controlCmd["week5_timer2_effect"] == VALUE_FUNCTION_OFF then
				myTable["week5timer2Effect"] = 0x00
			end
		end

		-- 周五定时3开关
		if controlCmd["week5_timer3_effect"] ~= nil then
			if controlCmd["week5_timer3_effect"] == VALUE_FUNCTION_ON then
				myTable["week5timer3Effect"] = 0x04
			elseif controlCmd["week5_timer3_effect"] == VALUE_FUNCTION_OFF then
				myTable["week5timer3Effect"] = 0x00
			end
		end

		-- 周五定时4开关
		if controlCmd["week5_timer4_effect"] ~= nil then
			if controlCmd["week5_timer4_effect"] == VALUE_FUNCTION_ON then
				myTable["week5timer4Effect"] = 0x08
			elseif controlCmd["week5_timer4_effect"] == VALUE_FUNCTION_OFF then
				myTable["week5timer4Effect"] = 0x00
			end
		end

		-- 周五定时5开关
		if controlCmd["week5_timer5_effect"] ~= nil then
			if controlCmd["week5_timer5_effect"] == VALUE_FUNCTION_ON then
				myTable["week5timer5Effect"] = 0x10
			elseif controlCmd["week5_timer5_effect"] == VALUE_FUNCTION_OFF then
				myTable["week5timer5Effect"] = 0x00
			end
		end

		-- 周五定时6开关
		if controlCmd["week5_timer6_effect"] ~= nil then
			if controlCmd["week5_timer6_effect"] == VALUE_FUNCTION_ON then
				myTable["week5timer6Effect"] = 0x20
			elseif controlCmd["week5_timer6_effect"] == VALUE_FUNCTION_OFF then
				myTable["week5timer6Effect"] = 0x00
			end
		end

		-- 周五定时1设定模式
		if controlCmd["week5_timer1_set_mode"] ~= nil then
			if controlCmd["week5_timer1_set_mode"] == "off" then
				myTable["week5timer1SetMode"] = 0x00
			elseif controlCmd["week5_timer1_set_mode"] == "heat" then
				myTable["week5timer1SetMode"] = 0x01
			elseif controlCmd["week5_timer1_set_mode"] == "dhw" then
				myTable["week5timer1SetMode"] = 0x02
			elseif controlCmd["week5_timer1_set_mode"] == "cool" then
				myTable["week5timer1SetMode"] = 0x03
			elseif controlCmd["week5_timer1_set_mode"] == "waterpump" then
				myTable["week5timer1SetMode"] = 0x04
			elseif controlCmd["week5_timer1_set_mode"] == "auto" then
				myTable["week5timer1SetMode"] = 0x05
			end
		end

		-- 周五定时1静音开关
		if controlCmd["week5_timer1_mut_set"] ~= nil then
			if controlCmd["week5_timer1_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer1MutSet"] = 0x01
			elseif controlCmd["week5_timer1_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer1MutSet"] = 0x00
			end
		end

		-- 周五定时1强热开关
		if controlCmd["week5_timer1_frc_he_set"] ~= nil then
			if controlCmd["week5_timer1_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer1FrcHeSet"] = 0x01
			elseif controlCmd["week5_timer1_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer1FrcHeSet"] = 0x00
			end
		end

		-- 周五定时1静音等级
		if controlCmd["week5_timer1_mut_lev"] ~= nil then
			if controlCmd["week5_timer1_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week5timer1MutLev"] = 0x01
			elseif controlCmd["week5_timer1_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week5timer1MutLev"] = 0x00
			end
		end

		-- 周五定时1设定温度
		if controlCmd["week5_timer1_set_temp"] ~= nil then
			myTable["week5timer1SetTemp"] = string2Int(controlCmd["week5_timer1_set_temp"])
		end

		-- 周五定时器1开始时间：时
		if controlCmd["week5_timer1_open_time_hour"] ~= nil then
			myTable["week5timer1OpenTimeHour"] = string2Int(controlCmd["week5_timer1_open_time_hour"])
		end

		-- 周五定时器1开始时间：分
		if controlCmd["week5_timer1_open_time_min"] ~= nil then
			myTable["week5timer1OpenTimeMin"] = string2Int(controlCmd["week5_timer1_open_time_min"])
		end

		-- 周五定时器1结束时间：时
		if controlCmd["week5_timer1_close_time_hour"] ~= nil then
			myTable["week5timer1CloseTimeHour"] = string2Int(controlCmd["week5_timer1_close_time_hour"])
		end

		-- 周五定时器1结束时间：分
		if controlCmd["week5_timer1_close_time_min"] ~= nil then
			myTable["week5timer1CloseTimeMin"] = string2Int(controlCmd["week5_timer1_close_time_min"])
		end

		-- 周五定时2设定模式
		if controlCmd["week5_timer2_set_mode"] ~= nil then
			if controlCmd["week5_timer2_set_mode"] == "off" then
				myTable["week5timer2SetMode"] = 0x00
			elseif controlCmd["week5_timer2_set_mode"] == "heat" then
				myTable["week5timer2SetMode"] = 0x01
			elseif controlCmd["week5_timer2_set_mode"] == "dhw" then
				myTable["week5timer2SetMode"] = 0x02
			elseif controlCmd["week5_timer2_set_mode"] == "cool" then
				myTable["week5timer2SetMode"] = 0x03
			elseif controlCmd["week5_timer2_set_mode"] == "waterpump" then
				myTable["week5timer2SetMode"] = 0x04
			elseif controlCmd["week5_timer2_set_mode"] == "auto" then
				myTable["week5timer2SetMode"] = 0x05
			end
		end

		-- 周五定时2静音开关
		if controlCmd["week5_timer2_mut_set"] ~= nil then
			if controlCmd["week5_timer2_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer2MutSet"] = 0x01
			elseif controlCmd["week5_timer2_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer2MutSet"] = 0x00
			end
		end

		-- 周五定时2强热开关
		if controlCmd["week5_timer2_frc_he_set"] ~= nil then
			if controlCmd["week5_timer2_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer2FrcHeSet"] = 0x01
			elseif controlCmd["week5_timer2_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer2FrcHeSet"] = 0x00
			end
		end

		-- 周五定时2静音等级
		if controlCmd["week5_timer2_mut_lev"] ~= nil then
			if controlCmd["week5_timer2_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week5timer2MutLev"] = 0x01
			elseif controlCmd["week5_timer2_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week5timer2MutLev"] = 0x00
			end
		end

		-- 周五定时2设定温度
		if controlCmd["week5_timer2_set_temp"] ~= nil then
			myTable["week5timer2SetTemp"] = string2Int(controlCmd["week5_timer2_set_temp"])
		end

		-- 周五定时器2开始时间：时
		if controlCmd["week5_timer2_open_time_hour"] ~= nil then
			myTable["week5timer2OpenTimeHour"] = string2Int(controlCmd["week5_timer2_open_time_hour"])
		end

		-- 周五定时器2开始时间：分
		if controlCmd["week5_timer2_open_time_min"] ~= nil then
			myTable["week5timer2OpenTimeMin"] = string2Int(controlCmd["week5_timer2_open_time_min"])
		end

		-- 周五定时器2结束时间：时
		if controlCmd["week5_timer2_close_time_hour"] ~= nil then
			myTable["week5timer2CloseTimeHour"] = string2Int(controlCmd["week5_timer2_close_time_hour"])
		end

		-- 周五定时器2结束时间：分
		if controlCmd["week5_timer2_close_time_min"] ~= nil then
			myTable["week5timer2CloseTimeMin"] = string2Int(controlCmd["week5_timer2_close_time_min"])
		end

		-- 周五定时3设定模式
		if controlCmd["week5_timer3_set_mode"] ~= nil then
			if controlCmd["week5_timer3_set_mode"] == "off" then
				myTable["week5timer3SetMode"] = 0x00
			elseif controlCmd["week5_timer3_set_mode"] == "heat" then
				myTable["week5timer3SetMode"] = 0x01
			elseif controlCmd["week5_timer3_set_mode"] == "dhw" then
				myTable["week5timer3SetMode"] = 0x02
			elseif controlCmd["week5_timer3_set_mode"] == "cool" then
				myTable["week5timer3SetMode"] = 0x03
			elseif controlCmd["week5_timer3_set_mode"] == "waterpump" then
				myTable["week5timer3SetMode"] = 0x04
			elseif controlCmd["week5_timer3_set_mode"] == "auto" then
				myTable["week5timer3SetMode"] = 0x05
			end
		end

		-- 周五定时3静音开关
		if controlCmd["week5_timer3_mut_set"] ~= nil then
			if controlCmd["week5_timer3_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer3MutSet"] = 0x01
			elseif controlCmd["week5_timer3_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer3MutSet"] = 0x00
			end
		end

		-- 周五定时3强热开关
		if controlCmd["week5_timer3_frc_he_set"] ~= nil then
			if controlCmd["week5_timer3_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer3FrcHeSet"] = 0x01
			elseif controlCmd["week5_timer3_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer3FrcHeSet"] = 0x00
			end
		end

		-- 周五定时3静音等级
		if controlCmd["week5_timer3_mut_lev"] ~= nil then
			if controlCmd["week5_timer3_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week5timer3MutLev"] = 0x01
			elseif controlCmd["week5_timer3_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week5timer3MutLev"] = 0x00
			end
		end

		-- 周五定时3设定温度
		if controlCmd["week5_timer3_set_temp"] ~= nil then
			myTable["week5timer3SetTemp"] = string2Int(controlCmd["week5_timer3_set_temp"])
		end

		-- 周五定时器3开始时间：时
		if controlCmd["week5_timer3_open_time_hour"] ~= nil then
			myTable["week5timer3OpenTimeHour"] = string2Int(controlCmd["week5_timer3_open_time_hour"])
		end

		-- 周五定时器3开始时间：分
		if controlCmd["week5_timer3_open_time_min"] ~= nil then
			myTable["week5timer3OpenTimeMin"] = string2Int(controlCmd["week5_timer3_open_time_min"])
		end

		-- 周五定时器3结束时间：时
		if controlCmd["week5_timer3_close_time_hour"] ~= nil then
			myTable["week5timer3CloseTimeHour"] = string2Int(controlCmd["week5_timer3_close_time_hour"])
		end

		-- 周五定时器3结束时间：分
		if controlCmd["week5_timer3_close_time_min"] ~= nil then
			myTable["week5timer3CloseTimeMin"] = string2Int(controlCmd["week5_timer3_close_time_min"])
		end

		-- 周五定时4设定模式
		if controlCmd["week5_timer4_set_mode"] ~= nil then
			if controlCmd["week5_timer4_set_mode"] == "off" then
				myTable["week5timer4SetMode"] = 0x00
			elseif controlCmd["week5_timer4_set_mode"] == "heat" then
				myTable["week5timer4SetMode"] = 0x01
			elseif controlCmd["week5_timer4_set_mode"] == "dhw" then
				myTable["week5timer4SetMode"] = 0x02
			elseif controlCmd["week5_timer4_set_mode"] == "cool" then
				myTable["week5timer4SetMode"] = 0x03
			elseif controlCmd["week5_timer4_set_mode"] == "waterpump" then
				myTable["week5timer4SetMode"] = 0x04
			elseif controlCmd["week5_timer4_set_mode"] == "auto" then
				myTable["week5timer4SetMode"] = 0x05
			end
		end

		-- 周五定时4静音开关
		if controlCmd["week5_timer4_mut_set"] ~= nil then
			if controlCmd["week5_timer4_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer4MutSet"] = 0x01
			elseif controlCmd["week5_timer4_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer4MutSet"] = 0x00
			end
		end

		-- 周五定时4强热开关
		if controlCmd["week5_timer4_frc_he_set"] ~= nil then
			if controlCmd["week5_timer4_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer4FrcHeSet"] = 0x01
			elseif controlCmd["week5_timer4_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer4FrcHeSet"] = 0x00
			end
		end

		-- 周五定时4静音等级
		if controlCmd["week5_timer4_mut_lev"] ~= nil then
			if controlCmd["week5_timer4_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week5timer4MutLev"] = 0x01
			elseif controlCmd["week5_timer4_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week5timer4MutLev"] = 0x00
			end
		end

		-- 周五定时4设定温度
		if controlCmd["week5_timer4_set_temp"] ~= nil then
			myTable["week5timer4SetTemp"] = string2Int(controlCmd["week5_timer4_set_temp"])
		end

		-- 周五定时器4开始时间：时
		if controlCmd["week5_timer4_open_time_hour"] ~= nil then
			myTable["week5timer4OpenTimeHour"] = string2Int(controlCmd["week5_timer4_open_time_hour"])
		end

		-- 周五定时器4开始时间：分
		if controlCmd["week5_timer4_open_time_min"] ~= nil then
			myTable["week5timer4OpenTimeMin"] = string2Int(controlCmd["week5_timer4_open_time_min"])
		end

		-- 周五定时器4结束时间：时
		if controlCmd["week5_timer4_close_time_hour"] ~= nil then
			myTable["week5timer4CloseTimeHour"] = string2Int(controlCmd["week5_timer4_close_time_hour"])
		end

		-- 周五定时器4结束时间：分
		if controlCmd["week5_timer4_close_time_min"] ~= nil then
			myTable["week5timer4CloseTimeMin"] = string2Int(controlCmd["week5_timer4_close_time_min"])
		end

		-- 周五定时5设定模式
		if controlCmd["week5_timer5_set_mode"] ~= nil then
			if controlCmd["week5_timer5_set_mode"] == "off" then
				myTable["week5timer5SetMode"] = 0x00
			elseif controlCmd["week5_timer5_set_mode"] == "heat" then
				myTable["week5timer5SetMode"] = 0x01
			elseif controlCmd["week5_timer5_set_mode"] == "dhw" then
				myTable["week5timer5SetMode"] = 0x02
			elseif controlCmd["week5_timer5_set_mode"] == "cool" then
				myTable["week5timer5SetMode"] = 0x03
			elseif controlCmd["week5_timer5_set_mode"] == "waterpump" then
				myTable["week5timer5SetMode"] = 0x04
			elseif controlCmd["week5_timer5_set_mode"] == "auto" then
				myTable["week5timer5SetMode"] = 0x05
			end
		end

		-- 周五定时5静音开关
		if controlCmd["week5_timer5_mut_set"] ~= nil then
			if controlCmd["week5_timer5_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer5MutSet"] = 0x01
			elseif controlCmd["week5_timer5_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer5MutSet"] = 0x00
			end
		end

		-- 周五定时5强热开关
		if controlCmd["week5_timer5_frc_he_set"] ~= nil then
			if controlCmd["week5_timer5_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer5FrcHeSet"] = 0x01
			elseif controlCmd["week5_timer5_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer5FrcHeSet"] = 0x00
			end
		end

		-- 周五定时5静音等级
		if controlCmd["week5_timer5_mut_lev"] ~= nil then
			if controlCmd["week5_timer5_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week5timer5MutLev"] = 0x01
			elseif controlCmd["week5_timer5_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week5timer5MutLev"] = 0x00
			end
		end

		-- 周五定时5设定温度
		if controlCmd["week5_timer5_set_temp"] ~= nil then
			myTable["week5timer5SetTemp"] = string2Int(controlCmd["week5_timer5_set_temp"])
		end

		-- 周五定时器5开始时间：时
		if controlCmd["week5_timer5_open_time_hour"] ~= nil then
			myTable["week5timer5OpenTimeHour"] = string2Int(controlCmd["week5_timer5_open_time_hour"])
		end

		-- 周五定时器5开始时间：分
		if controlCmd["week5_timer5_open_time_min"] ~= nil then
			myTable["week5timer5OpenTimeMin"] = string2Int(controlCmd["week5_timer5_open_time_min"])
		end

		-- 周五定时器5结束时间：时
		if controlCmd["week5_timer5_close_time_hour"] ~= nil then
			myTable["week5timer5CloseTimeHour"] = string2Int(controlCmd["week5_timer5_close_time_hour"])
		end

		-- 周五定时器5结束时间：分
		if controlCmd["week5_timer5_close_time_min"] ~= nil then
			myTable["week5timer5CloseTimeMin"] = string2Int(controlCmd["week5_timer5_close_time_min"])
		end

		-- 周五定时6设定模式
		if controlCmd["week5_timer6_set_mode"] ~= nil then
			if controlCmd["week5_timer6_set_mode"] == "off" then
				myTable["week5timer6SetMode"] = 0x00
			elseif controlCmd["week5_timer6_set_mode"] == "heat" then
				myTable["week5timer6SetMode"] = 0x01
			elseif controlCmd["week5_timer6_set_mode"] == "dhw" then
				myTable["week5timer6SetMode"] = 0x02
			elseif controlCmd["week5_timer6_set_mode"] == "cool" then
				myTable["week5timer6SetMode"] = 0x03
			elseif controlCmd["week5_timer6_set_mode"] == "waterpump" then
				myTable["week5timer6SetMode"] = 0x04
			elseif controlCmd["week5_timer6_set_mode"] == "auto" then
				myTable["week5timer6SetMode"] = 0x05
			end
		end

		-- 周五定时6静音开关
		if controlCmd["week5_timer6_mut_set"] ~= nil then
			if controlCmd["week5_timer6_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer6MutSet"] = 0x01
			elseif controlCmd["week5_timer6_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer6MutSet"] = 0x00
			end
		end

		-- 周五定时6强热开关
		if controlCmd["week5_timer6_frc_he_set"] ~= nil then
			if controlCmd["week5_timer6_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week5timer6FrcHeSet"] = 0x01
			elseif controlCmd["week5_timer6_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week5timer6FrcHeSet"] = 0x00
			end
		end

		-- 周五定时6静音等级
		if controlCmd["week5_timer6_mut_lev"] ~= nil then
			if controlCmd["week5_timer6_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week5timer6MutLev"] = 0x01
			elseif controlCmd["week5_timer6_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week5timer6MutLev"] = 0x00
			end
		end

		-- 周五定时6设定温度
		if controlCmd["week5_timer6_set_temp"] ~= nil then
			myTable["week5timer6SetTemp"] = string2Int(controlCmd["week5_timer6_set_temp"])
		end

		-- 周五定时器6开始时间：时
		if controlCmd["week5_timer6_open_time_hour"] ~= nil then
			myTable["week5timer6OpenTimeHour"] = string2Int(controlCmd["week5_timer6_open_time_hour"])
		end

		-- 周五定时器6开始时间：分
		if controlCmd["week5_timer6_open_time_min"] ~= nil then
			myTable["week5timer6OpenTimeMin"] = string2Int(controlCmd["week5_timer6_open_time_min"])
		end

		-- 周五定时器6结束时间：时
		if controlCmd["week5_timer6_close_time_hour"] ~= nil then
			myTable["week5timer6CloseTimeHour"] = string2Int(controlCmd["week5_timer6_close_time_hour"])
		end

		-- 周五定时器6结束时间：分
		if controlCmd["week5_timer6_close_time_min"] ~= nil then
			myTable["week5timer6CloseTimeMin"] = string2Int(controlCmd["week5_timer6_close_time_min"])
		end

		-- 周五定时1是否有效
		if controlCmd["week5_timer1_valid"] ~= nil then
			if controlCmd["week5_timer1_valid"] == VALUE_VALID then
				myTable["week5timer1Valid"] = 0x01
			elseif controlCmd["week5_timer1_valid"] == VALUE_INVALID then
				myTable["week5timer1Valid"] = 0x00
			end
		end

		-- 周五定时2是否有效
		if controlCmd["week5_timer2_valid"] ~= nil then
			if controlCmd["week5_timer2_valid"] == VALUE_VALID then
				myTable["week5timer2Valid"] = 0x02
			elseif controlCmd["week5_timer2_valid"] == VALUE_INVALID then
				myTable["week5timer2Valid"] = 0x00
			end
		end

		-- 周五定时3是否有效
		if controlCmd["week5_timer3_valid"] ~= nil then
			if controlCmd["week5_timer3_valid"] == VALUE_VALID then
				myTable["week5timer3Valid"] = 0x04
			elseif controlCmd["week5_timer3_valid"] == VALUE_INVALID then
				myTable["week5timer3Valid"] = 0x00
			end
		end

		-- 周五定时4是否有效
		if controlCmd["week5_timer4_valid"] ~= nil then
			if controlCmd["week5_timer4_valid"] == VALUE_VALID then
				myTable["week5timer4Valid"] = 0x08
			elseif controlCmd["week5_timer4_valid"] == VALUE_INVALID then
				myTable["week5timer4Valid"] = 0x00
			end
		end

		-- 周五定时5是否有效
		if controlCmd["week5_timer5_valid"] ~= nil then
			if controlCmd["week5_timer5_valid"] == VALUE_VALID then
				myTable["week5timer5Valid"] = 0x10
			elseif controlCmd["week5_timer5_valid"] == VALUE_INVALID then
				myTable["week5timer5Valid"] = 0x00
			end
		end

		-- 周五定时6是否有效
		if controlCmd["week5_timer6_valid"] ~= nil then
			if controlCmd["week5_timer6_valid"] == VALUE_VALID then
				myTable["week5timer6Valid"] = 0x20
			elseif controlCmd["week5_timer6_valid"] == VALUE_INVALID then
				myTable["week5timer6Valid"] = 0x00
			end
		end
	elseif myTable["controlType"] == 0x0a then
		-- 周六定时1开关
		if controlCmd["week6_timer1_effect"] ~= nil then
			if controlCmd["week6_timer1_effect"] == VALUE_FUNCTION_ON then
				myTable["week6timer1Effect"] = 0x01
			elseif controlCmd["week6_timer1_effect"] == VALUE_FUNCTION_OFF then
				myTable["week6timer1Effect"] = 0x00
			end
		end

		-- 周六定时2开关
		if controlCmd["week6_timer2_effect"] ~= nil then
			if controlCmd["week6_timer2_effect"] == VALUE_FUNCTION_ON then
				myTable["week6timer2Effect"] = 0x02
			elseif controlCmd["week6_timer2_effect"] == VALUE_FUNCTION_OFF then
				myTable["week6timer2Effect"] = 0x00
			end
		end

		-- 周六定时3开关
		if controlCmd["week6_timer3_effect"] ~= nil then
			if controlCmd["week6_timer3_effect"] == VALUE_FUNCTION_ON then
				myTable["week6timer3Effect"] = 0x04
			elseif controlCmd["week6_timer3_effect"] == VALUE_FUNCTION_OFF then
				myTable["week6timer3Effect"] = 0x00
			end
		end

		-- 周六定时4开关
		if controlCmd["week6_timer4_effect"] ~= nil then
			if controlCmd["week6_timer4_effect"] == VALUE_FUNCTION_ON then
				myTable["week6timer4Effect"] = 0x08
			elseif controlCmd["week6_timer4_effect"] == VALUE_FUNCTION_OFF then
				myTable["week6timer4Effect"] = 0x00
			end
		end

		-- 周六定时5开关
		if controlCmd["week6_timer5_effect"] ~= nil then
			if controlCmd["week6_timer5_effect"] == VALUE_FUNCTION_ON then
				myTable["week6timer5Effect"] = 0x10
			elseif controlCmd["week6_timer5_effect"] == VALUE_FUNCTION_OFF then
				myTable["week6timer5Effect"] = 0x00
			end
		end

		-- 周六定时6开关
		if controlCmd["week6_timer6_effect"] ~= nil then
			if controlCmd["week6_timer6_effect"] == VALUE_FUNCTION_ON then
				myTable["week6timer6Effect"] = 0x20
			elseif controlCmd["week6_timer6_effect"] == VALUE_FUNCTION_OFF then
				myTable["week6timer6Effect"] = 0x00
			end
		end

		-- 周六定时1设定模式
		if controlCmd["week6_timer1_set_mode"] ~= nil then
			if controlCmd["week6_timer1_set_mode"] == "off" then
				myTable["week6timer1SetMode"] = 0x00
			elseif controlCmd["week6_timer1_set_mode"] == "heat" then
				myTable["week6timer1SetMode"] = 0x01
			elseif controlCmd["week6_timer1_set_mode"] == "dhw" then
				myTable["week6timer1SetMode"] = 0x02
			elseif controlCmd["week6_timer1_set_mode"] == "cool" then
				myTable["week6timer1SetMode"] = 0x03
			elseif controlCmd["week6_timer1_set_mode"] == "waterpump" then
				myTable["week6timer1SetMode"] = 0x04
			elseif controlCmd["week6_timer1_set_mode"] == "auto" then
				myTable["week6timer1SetMode"] = 0x05
			end
		end

		-- 周六定时1静音开关
		if controlCmd["week6_timer1_mut_set"] ~= nil then
			if controlCmd["week6_timer1_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer1MutSet"] = 0x01
			elseif controlCmd["week6_timer1_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer1MutSet"] = 0x00
			end
		end

		-- 周六定时1强热开关
		if controlCmd["week6_timer1_frc_he_set"] ~= nil then
			if controlCmd["week6_timer1_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer1FrcHeSet"] = 0x01
			elseif controlCmd["week6_timer1_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer1FrcHeSet"] = 0x00
			end
		end

		-- 周六定时1静音等级
		if controlCmd["week6_timer1_mut_lev"] ~= nil then
			if controlCmd["week6_timer1_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week6timer1MutLev"] = 0x01
			elseif controlCmd["week6_timer1_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week6timer1MutLev"] = 0x00
			end
		end

		-- 周六定时1设定温度
		if controlCmd["week6_timer1_set_temp"] ~= nil then
			myTable["week6timer1SetTemp"] = string2Int(controlCmd["week6_timer1_set_temp"])
		end

		-- 周六定时器1开始时间：时
		if controlCmd["week6_timer1_open_time_hour"] ~= nil then
			myTable["week6timer1OpenTimeHour"] = string2Int(controlCmd["week6_timer1_open_time_hour"])
		end

		-- 周六定时器1开始时间：分
		if controlCmd["week6_timer1_open_time_min"] ~= nil then
			myTable["week6timer1OpenTimeMin"] = string2Int(controlCmd["week6_timer1_open_time_min"])
		end

		-- 周六定时器1结束时间：时
		if controlCmd["week6_timer1_close_time_hour"] ~= nil then
			myTable["week6timer1CloseTimeHour"] = string2Int(controlCmd["week6_timer1_close_time_hour"])
		end

		-- 周六定时器1结束时间：分
		if controlCmd["week6_timer1_close_time_min"] ~= nil then
			myTable["week6timer1CloseTimeMin"] = string2Int(controlCmd["week6_timer1_close_time_min"])
		end

		-- 周六定时2设定模式
		if controlCmd["week6_timer2_set_mode"] ~= nil then
			if controlCmd["week6_timer2_set_mode"] == "off" then
				myTable["week6timer2SetMode"] = 0x00
			elseif controlCmd["week6_timer2_set_mode"] == "heat" then
				myTable["week6timer2SetMode"] = 0x01
			elseif controlCmd["week6_timer2_set_mode"] == "dhw" then
				myTable["week6timer2SetMode"] = 0x02
			elseif controlCmd["week6_timer2_set_mode"] == "cool" then
				myTable["week6timer2SetMode"] = 0x03
			elseif controlCmd["week6_timer2_set_mode"] == "waterpump" then
				myTable["week6timer2SetMode"] = 0x04
			elseif controlCmd["week6_timer2_set_mode"] == "auto" then
				myTable["week6timer2SetMode"] = 0x05
			end
		end

		-- 周六定时2静音开关
		if controlCmd["week6_timer2_mut_set"] ~= nil then
			if controlCmd["week6_timer2_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer2MutSet"] = 0x01
			elseif controlCmd["week6_timer2_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer2MutSet"] = 0x00
			end
		end

		-- 周六定时2强热开关
		if controlCmd["week6_timer2_frc_he_set"] ~= nil then
			if controlCmd["week6_timer2_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer2FrcHeSet"] = 0x01
			elseif controlCmd["week6_timer2_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer2FrcHeSet"] = 0x00
			end
		end

		-- 周六定时2静音等级
		if controlCmd["week6_timer2_mut_lev"] ~= nil then
			if controlCmd["week6_timer2_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week6timer2MutLev"] = 0x01
			elseif controlCmd["week6_timer2_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week6timer2MutLev"] = 0x00
			end
		end

		-- 周六定时2设定温度
		if controlCmd["week6_timer2_set_temp"] ~= nil then
			myTable["week6timer2SetTemp"] = string2Int(controlCmd["week6_timer2_set_temp"])
		end

		-- 周六定时器2开始时间：时
		if controlCmd["week6_timer2_open_time_hour"] ~= nil then
			myTable["week6timer2OpenTimeHour"] = string2Int(controlCmd["week6_timer2_open_time_hour"])
		end

		-- 周六定时器2开始时间：分
		if controlCmd["week6_timer2_open_time_min"] ~= nil then
			myTable["week6timer2OpenTimeMin"] = string2Int(controlCmd["week6_timer2_open_time_min"])
		end

		-- 周六定时器2结束时间：时
		if controlCmd["week6_timer2_close_time_hour"] ~= nil then
			myTable["week6timer2CloseTimeHour"] = string2Int(controlCmd["week6_timer2_close_time_hour"])
		end

		-- 周六定时器2结束时间：分
		if controlCmd["week6_timer2_close_time_min"] ~= nil then
			myTable["week6timer2CloseTimeMin"] = string2Int(controlCmd["week6_timer2_close_time_min"])
		end

		-- 周六定时3设定模式
		if controlCmd["week6_timer3_set_mode"] ~= nil then
			if controlCmd["week6_timer3_set_mode"] == "off" then
				myTable["week6timer3SetMode"] = 0x00
			elseif controlCmd["week6_timer3_set_mode"] == "heat" then
				myTable["week6timer3SetMode"] = 0x01
			elseif controlCmd["week6_timer3_set_mode"] == "dhw" then
				myTable["week6timer3SetMode"] = 0x02
			elseif controlCmd["week6_timer3_set_mode"] == "cool" then
				myTable["week6timer3SetMode"] = 0x03
			elseif controlCmd["week6_timer3_set_mode"] == "waterpump" then
				myTable["week6timer3SetMode"] = 0x04
			elseif controlCmd["week6_timer3_set_mode"] == "auto" then
				myTable["week6timer3SetMode"] = 0x05
			end
		end

		-- 周六定时3静音开关
		if controlCmd["week6_timer3_mut_set"] ~= nil then
			if controlCmd["week6_timer3_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer3MutSet"] = 0x01
			elseif controlCmd["week6_timer3_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer3MutSet"] = 0x00
			end
		end

		-- 周六定时3强热开关
		if controlCmd["week6_timer3_frc_he_set"] ~= nil then
			if controlCmd["week6_timer3_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer3FrcHeSet"] = 0x01
			elseif controlCmd["week6_timer3_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer3FrcHeSet"] = 0x00
			end
		end

		-- 周六定时3静音等级
		if controlCmd["week6_timer3_mut_lev"] ~= nil then
			if controlCmd["week6_timer3_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week6timer3MutLev"] = 0x01
			elseif controlCmd["week6_timer3_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week6timer3MutLev"] = 0x00
			end
		end

		-- 周六定时3设定温度
		if controlCmd["week6_timer3_set_temp"] ~= nil then
			myTable["week6timer3SetTemp"] = string2Int(controlCmd["week6_timer3_set_temp"])
		end

		-- 周六定时器3开始时间：时
		if controlCmd["week6_timer3_open_time_hour"] ~= nil then
			myTable["week6timer3OpenTimeHour"] = string2Int(controlCmd["week6_timer3_open_time_hour"])
		end

		-- 周六定时器3开始时间：分
		if controlCmd["week6_timer3_open_time_min"] ~= nil then
			myTable["week6timer3OpenTimeMin"] = string2Int(controlCmd["week6_timer3_open_time_min"])
		end

		-- 周六定时器3结束时间：时
		if controlCmd["week6_timer3_close_time_hour"] ~= nil then
			myTable["week6timer3CloseTimeHour"] = string2Int(controlCmd["week6_timer3_close_time_hour"])
		end

		-- 周六定时器3结束时间：分
		if controlCmd["week6_timer3_close_time_min"] ~= nil then
			myTable["week6timer3CloseTimeMin"] = string2Int(controlCmd["week6_timer3_close_time_min"])
		end

		-- 周六定时4设定模式
		if controlCmd["week6_timer4_set_mode"] ~= nil then
			if controlCmd["week6_timer4_set_mode"] == "off" then
				myTable["week6timer4SetMode"] = 0x00
			elseif controlCmd["week6_timer4_set_mode"] == "heat" then
				myTable["week6timer4SetMode"] = 0x01
			elseif controlCmd["week6_timer4_set_mode"] == "dhw" then
				myTable["week6timer4SetMode"] = 0x02
			elseif controlCmd["week6_timer4_set_mode"] == "cool" then
				myTable["week6timer4SetMode"] = 0x03
			elseif controlCmd["week6_timer4_set_mode"] == "waterpump" then
				myTable["week6timer4SetMode"] = 0x04
			elseif controlCmd["week6_timer4_set_mode"] == "auto" then
				myTable["week6timer4SetMode"] = 0x05
			end
		end

		-- 周六定时4静音开关
		if controlCmd["week6_timer4_mut_set"] ~= nil then
			if controlCmd["week6_timer4_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer4MutSet"] = 0x01
			elseif controlCmd["week6_timer4_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer4MutSet"] = 0x00
			end
		end

		-- 周六定时4强热开关
		if controlCmd["week6_timer4_frc_he_set"] ~= nil then
			if controlCmd["week6_timer4_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer4FrcHeSet"] = 0x01
			elseif controlCmd["week6_timer4_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer4FrcHeSet"] = 0x00
			end
		end

		-- 周六定时4静音等级
		if controlCmd["week6_timer4_mut_lev"] ~= nil then
			if controlCmd["week6_timer4_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week6timer4MutLev"] = 0x01
			elseif controlCmd["week6_timer4_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week6timer4MutLev"] = 0x00
			end
		end

		-- 周六定时4设定温度
		if controlCmd["week6_timer4_set_temp"] ~= nil then
			myTable["week6timer4SetTemp"] = string2Int(controlCmd["week6_timer4_set_temp"])
		end

		-- 周六定时器4开始时间：时
		if controlCmd["week6_timer4_open_time_hour"] ~= nil then
			myTable["week6timer4OpenTimeHour"] = string2Int(controlCmd["week6_timer4_open_time_hour"])
		end

		-- 周六定时器4开始时间：分
		if controlCmd["week6_timer4_open_time_min"] ~= nil then
			myTable["week6timer4OpenTimeMin"] = string2Int(controlCmd["week6_timer4_open_time_min"])
		end

		-- 周六定时器4结束时间：时
		if controlCmd["week6_timer4_close_time_hour"] ~= nil then
			myTable["week6timer4CloseTimeHour"] = string2Int(controlCmd["week6_timer4_close_time_hour"])
		end

		-- 周六定时器4结束时间：分
		if controlCmd["week6_timer4_close_time_min"] ~= nil then
			myTable["week6timer4CloseTimeMin"] = string2Int(controlCmd["week6_timer4_close_time_min"])
		end

		-- 周六定时5设定模式
		if controlCmd["week6_timer5_set_mode"] ~= nil then
			if controlCmd["week6_timer5_set_mode"] == "off" then
				myTable["week6timer5SetMode"] = 0x00
			elseif controlCmd["week6_timer5_set_mode"] == "heat" then
				myTable["week6timer5SetMode"] = 0x01
			elseif controlCmd["week6_timer5_set_mode"] == "dhw" then
				myTable["week6timer5SetMode"] = 0x02
			elseif controlCmd["week6_timer5_set_mode"] == "cool" then
				myTable["week6timer5SetMode"] = 0x03
			elseif controlCmd["week6_timer5_set_mode"] == "waterpump" then
				myTable["week6timer5SetMode"] = 0x04
			elseif controlCmd["week6_timer5_set_mode"] == "auto" then
				myTable["week6timer5SetMode"] = 0x05
			end
		end

		-- 周六定时5静音开关
		if controlCmd["week6_timer5_mut_set"] ~= nil then
			if controlCmd["week6_timer5_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer5MutSet"] = 0x01
			elseif controlCmd["week6_timer5_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer5MutSet"] = 0x00
			end
		end

		-- 周六定时5强热开关
		if controlCmd["week6_timer5_frc_he_set"] ~= nil then
			if controlCmd["week6_timer5_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer5FrcHeSet"] = 0x01
			elseif controlCmd["week6_timer5_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer5FrcHeSet"] = 0x00
			end
		end

		-- 周六定时5静音等级
		if controlCmd["week6_timer5_mut_lev"] ~= nil then
			if controlCmd["week6_timer5_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week6timer5MutLev"] = 0x01
			elseif controlCmd["week6_timer5_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week6timer5MutLev"] = 0x00
			end
		end

		-- 周六定时5设定温度
		if controlCmd["week6_timer5_set_temp"] ~= nil then
			myTable["week6timer5SetTemp"] = string2Int(controlCmd["week6_timer5_set_temp"])
		end

		-- 周六定时器5开始时间：时
		if controlCmd["week6_timer5_open_time_hour"] ~= nil then
			myTable["week6timer5OpenTimeHour"] = string2Int(controlCmd["week6_timer5_open_time_hour"])
		end

		-- 周六定时器5开始时间：分
		if controlCmd["week6_timer5_open_time_min"] ~= nil then
			myTable["week6timer5OpenTimeMin"] = string2Int(controlCmd["week6_timer5_open_time_min"])
		end

		-- 周六定时器5结束时间：时
		if controlCmd["week6_timer5_close_time_hour"] ~= nil then
			myTable["week6timer5CloseTimeHour"] = string2Int(controlCmd["week6_timer5_close_time_hour"])
		end

		-- 周六定时器5结束时间：分
		if controlCmd["week6_timer5_close_time_min"] ~= nil then
			myTable["week6timer5CloseTimeMin"] = string2Int(controlCmd["week6_timer5_close_time_min"])
		end

		-- 周六定时6设定模式
		if controlCmd["week6_timer6_set_mode"] ~= nil then
			if controlCmd["week6_timer6_set_mode"] == "off" then
				myTable["week6timer6SetMode"] = 0x00
			elseif controlCmd["week6_timer6_set_mode"] == "heat" then
				myTable["week6timer6SetMode"] = 0x01
			elseif controlCmd["week6_timer6_set_mode"] == "dhw" then
				myTable["week6timer6SetMode"] = 0x02
			elseif controlCmd["week6_timer6_set_mode"] == "cool" then
				myTable["week6timer6SetMode"] = 0x03
			elseif controlCmd["week6_timer6_set_mode"] == "waterpump" then
				myTable["week6timer6SetMode"] = 0x04
			elseif controlCmd["week6_timer6_set_mode"] == "auto" then
				myTable["week6timer6SetMode"] = 0x05
			end
		end

		-- 周六定时6静音开关
		if controlCmd["week6_timer6_mut_set"] ~= nil then
			if controlCmd["week6_timer6_mut_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer6MutSet"] = 0x01
			elseif controlCmd["week6_timer6_mut_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer6MutSet"] = 0x00
			end
		end

		-- 周六定时6强热开关
		if controlCmd["week6_timer6_frc_he_set"] ~= nil then
			if controlCmd["week6_timer6_frc_he_set"] == VALUE_FUNCTION_ON then
				myTable["week6timer6FrcHeSet"] = 0x01
			elseif controlCmd["week6_timer6_frc_he_set"] == VALUE_FUNCTION_OFF then
				myTable["week6timer6FrcHeSet"] = 0x00
			end
		end

		-- 周六定时6静音等级
		if controlCmd["week6_timer6_mut_lev"] ~= nil then
			if controlCmd["week6_timer6_mut_lev"] == VALUE_MUTE_LEV2 then
				myTable["week6timer6MutLev"] = 0x01
			elseif controlCmd["week6_timer6_mut_lev"] == VALUE_MUTE_LEV1 then
				myTable["week6timer6MutLev"] = 0x00
			end
		end

		-- 周六定时6设定温度
		if controlCmd["week6_timer6_set_temp"] ~= nil then
			myTable["week6timer6SetTemp"] = string2Int(controlCmd["week6_timer6_set_temp"])
		end

		-- 周六定时器6开始时间：时
		if controlCmd["week6_timer6_open_time_hour"] ~= nil then
			myTable["week6timer6OpenTimeHour"] = string2Int(controlCmd["week6_timer6_open_time_hour"])
		end

		-- 周六定时器6开始时间：分
		if controlCmd["week6_timer6_open_time_min"] ~= nil then
			myTable["week6timer6OpenTimeMin"] = string2Int(controlCmd["week6_timer6_open_time_min"])
		end

		-- 周六定时器6结束时间：时
		if controlCmd["week6_timer6_close_time_hour"] ~= nil then
			myTable["week6timer6CloseTimeHour"] = string2Int(controlCmd["week6_timer6_close_time_hour"])
		end

		-- 周六定时器6结束时间：分
		if controlCmd["week6_timer6_close_time_min"] ~= nil then
			myTable["week6timer6CloseTimeMin"] = string2Int(controlCmd["week6_timer6_close_time_min"])
		end

		-- 周六定时1是否有效
		if controlCmd["week6_timer1_valid"] ~= nil then
			if controlCmd["week6_timer1_valid"] == VALUE_VALID then
				myTable["week6timer1Valid"] = 0x01
			elseif controlCmd["week6_timer1_valid"] == VALUE_INVALID then
				myTable["week6timer1Valid"] = 0x00
			end
		end

		-- 周六定时2是否有效
		if controlCmd["week6_timer2_valid"] ~= nil then
			if controlCmd["week6_timer2_valid"] == VALUE_VALID then
				myTable["week6timer2Valid"] = 0x02
			elseif controlCmd["week6_timer2_valid"] == VALUE_INVALID then
				myTable["week6timer2Valid"] = 0x00
			end
		end

		-- 周六定时3是否有效
		if controlCmd["week6_timer3_valid"] ~= nil then
			if controlCmd["week6_timer3_valid"] == VALUE_VALID then
				myTable["week6timer3Valid"] = 0x04
			elseif controlCmd["week6_timer3_valid"] == VALUE_INVALID then
				myTable["week6timer3Valid"] = 0x00
			end
		end

		-- 周六定时4是否有效
		if controlCmd["week6_timer4_valid"] ~= nil then
			if controlCmd["week6_timer4_valid"] == VALUE_VALID then
				myTable["week6timer4Valid"] = 0x08
			elseif controlCmd["week6_timer4_valid"] == VALUE_INVALID then
				myTable["week6timer4Valid"] = 0x00
			end
		end

		-- 周六定时5是否有效
		if controlCmd["week6_timer5_valid"] ~= nil then
			if controlCmd["week6_timer5_valid"] == VALUE_VALID then
				myTable["week6timer5Valid"] = 0x10
			elseif controlCmd["week6_timer5_valid"] == VALUE_INVALID then
				myTable["week6timer5Valid"] = 0x00
			end
		end

		-- 周六定时6是否有效
		if controlCmd["week6_timer6_valid"] ~= nil then
			if controlCmd["week6_timer6_valid"] == VALUE_VALID then
				myTable["week6timer6Valid"] = 0x20
			elseif controlCmd["week6_timer6_valid"] == VALUE_INVALID then
				myTable["week6timer6Valid"] = 0x00
			end
		end
	elseif myTable["controlType"] == 0x0b then
		-- 定时器类型
		if controlCmd["timer_type"] ~= nil then
			if controlCmd["timer_type"] == "point" then
				myTable["timerType"] = 0x00
			elseif controlCmd["timer_type"] == "section" then
				myTable["timerType"] = 0x01
			elseif controlCmd["timer_type"] == "order" then
				myTable["timerType"] = 0x02
			end
		end

		-- 定时器1开关
		if controlCmd["timer1_effect"] ~= nil then
			if controlCmd["timer1_effect"] == VALUE_FUNCTION_ON then
				myTable["timer1Effect"] = 0x01
			elseif controlCmd["timer1_effect"] == VALUE_FUNCTION_OFF then
				myTable["timer1Effect"] = 0x00
			end
		end

		-- 定时器2开关
		if controlCmd["timer2_effect"] ~= nil then
			if controlCmd["timer2_effect"] == VALUE_FUNCTION_ON then
				myTable["timer2Effect"] = 0x02
			elseif controlCmd["timer2_effect"] == VALUE_FUNCTION_OFF then
				myTable["timer2Effect"] = 0x00
			end
		end

		-- 定时器3开关
		if controlCmd["timer3_effect"] ~= nil then
			if controlCmd["timer3_effect"] == VALUE_FUNCTION_ON then
				myTable["timer3Effect"] = 0x04
			elseif controlCmd["timer3_effect"] == VALUE_FUNCTION_OFF then
				myTable["timer3Effect"] = 0x00
			end
		end

		-- 定时器4开关
		if controlCmd["timer4_effect"] ~= nil then
			if controlCmd["timer4_effect"] == VALUE_FUNCTION_ON then
				myTable["timer4Effect"] = 0x08
			elseif controlCmd["timer4_effect"] == VALUE_FUNCTION_OFF then
				myTable["timer4Effect"] = 0x00
			end
		end

		-- 定时器5开关
		if controlCmd["timer5_effect"] ~= nil then
			if controlCmd["timer5_effect"] == VALUE_FUNCTION_ON then
				myTable["timer5Effect"] = 0x10
			elseif controlCmd["timer5_effect"] == VALUE_FUNCTION_OFF then
				myTable["timer5Effect"] = 0x00
			end
		end

		-- 定时器6开关
		if controlCmd["timer6_effect"] ~= nil then
			if controlCmd["timer6_effect"] == VALUE_FUNCTION_ON then
				myTable["timer6Effect"] = 0x20
			elseif controlCmd["timer6_effect"] == VALUE_FUNCTION_OFF then
				myTable["timer6Effect"] = 0x00
			end
		end

		-- 定时器1开始时间：时
		if controlCmd["timer1_open_time_hour"] ~= nil then
			myTable["timer1OpenHour"] = string2Int(controlCmd["timer1_open_time_hour"])
		end

		-- 定时器1开始时间：分
		if controlCmd["timer1_open_time_min"] ~= nil then
			myTable["timer1OpenMin"] = string2Int(controlCmd["timer1_open_time_min"])
		end

		-- 定时器1结束时间：时
		if controlCmd["timer1_close_time_hour"] ~= nil then
			myTable["timer1CloseHour"] = string2Int(controlCmd["timer1_close_time_hour"])
		end

		-- 定时器1结束时间：分
		if controlCmd["timer1_close_time_min"] ~= nil then
			myTable["timer1CloseMin"] = string2Int(controlCmd["timer1_close_time_min"])
		end

		-- 定时1设定温度
		if controlCmd["timer1_set_temp"] ~= nil then
			myTable["timer1SetTemperature"] = string2Int(controlCmd["timer1_set_temp"])
		end

		-- 定时1设定模式
		if controlCmd["timer1_set_mode"] ~= nil then
			if controlCmd["timer1_set_mode"] == "off" then
				myTable["timer1ModeValue"] = 0x00
			elseif controlCmd["timer1_set_mode"] == "heat" then
				myTable["timer1ModeValue"] = 0x01
			elseif controlCmd["timer1_set_mode"] == "dhw" then
				myTable["timer1ModeValue"] = 0x02
			elseif controlCmd["timer1_set_mode"] == "cool" then
				myTable["timer1ModeValue"] = 0x03
			elseif controlCmd["timer1_set_mode"] == "waterpump" then
				myTable["timer1ModeValue"] = 0x04
			elseif controlCmd["timer1_set_mode"] == "auto" then
				myTable["timer1ModeValue"] = 0x05
			end
		end

		-- 定时器2开始时间：时
		if controlCmd["timer2_open_time_hour"] ~= nil then
			myTable["timer2OpenHour"] = string2Int(controlCmd["timer2_open_time_hour"])
		end

		-- 定时器2开始时间：分
		if controlCmd["timer2_open_time_min"] ~= nil then
			myTable["timer2OpenMin"] = string2Int(controlCmd["timer2_open_time_min"])
		end

		-- 定时器2结束时间：时
		if controlCmd["timer2_close_time_hour"] ~= nil then
			myTable["timer2CloseHour"] = string2Int(controlCmd["timer2_close_time_hour"])
		end

		-- 定时器2结束时间：分
		if controlCmd["timer2_close_time_min"] ~= nil then
			myTable["timer2CloseMin"] = string2Int(controlCmd["timer2_close_time_min"])
		end

		-- 定时2设定温度
		if controlCmd["timer2_set_temp"] ~= nil then
			myTable["timer2SetTemperature"] = string2Int(controlCmd["timer2_set_temp"])
		end

		-- 定时2设定模式
		if controlCmd["timer2_set_mode"] ~= nil then
			if controlCmd["timer2_set_mode"] == "off" then
				myTable["timer2ModeValue"] = 0x00
			elseif controlCmd["timer2_set_mode"] == "heat" then
				myTable["timer2ModeValue"] = 0x01
			elseif controlCmd["timer2_set_mode"] == "dhw" then
				myTable["timer2ModeValue"] = 0x02
			elseif controlCmd["timer2_set_mode"] == "cool" then
				myTable["timer2ModeValue"] = 0x03
			elseif controlCmd["timer2_set_mode"] == "waterpump" then
				myTable["timer2ModeValue"] = 0x04
			elseif controlCmd["timer2_set_mode"] == "auto" then
				myTable["timer2ModeValue"] = 0x05
			end
		end

		-- 定时器3开始时间：时
		if controlCmd["timer3_open_time_hour"] ~= nil then
			myTable["timer3OpenHour"] = string2Int(controlCmd["timer3_open_time_hour"])
		end

		-- 定时器3开始时间：分
		if controlCmd["timer3_open_time_min"] ~= nil then
			myTable["timer3OpenMin"] = string2Int(controlCmd["timer3_open_time_min"])
		end

		-- 定时器3结束时间：时
		if controlCmd["timer3_close_time_hour"] ~= nil then
			myTable["timer3CloseHour"] = string2Int(controlCmd["timer3_close_time_hour"])
		end

		-- 定时器3结束时间：分
		if controlCmd["timer3_close_time_min"] ~= nil then
			myTable["timer3CloseMin"] = string2Int(controlCmd["timer3_close_time_min"])
		end

		-- 定时3设定温度
		if controlCmd["timer3_set_temp"] ~= nil then
			myTable["timer3SetTemperature"] = string2Int(controlCmd["timer3_set_temp"])
		end

		-- 定时3设定模式
		if controlCmd["timer3_set_mode"] ~= nil then
			if controlCmd["timer3_set_mode"] == "off" then
				myTable["timer3ModeValue"] = 0x00
			elseif controlCmd["timer3_set_mode"] == "heat" then
				myTable["timer3ModeValue"] = 0x01
			elseif controlCmd["timer3_set_mode"] == "dhw" then
				myTable["timer3ModeValue"] = 0x02
			elseif controlCmd["timer3_set_mode"] == "cool" then
				myTable["timer3ModeValue"] = 0x03
			elseif controlCmd["timer3_set_mode"] == "waterpump" then
				myTable["timer3ModeValue"] = 0x04
			elseif controlCmd["timer3_set_mode"] == "auto" then
				myTable["timer3ModeValue"] = 0x05
			end
		end

		-- 定时器4开始时间：时
		if controlCmd["timer4_open_time_hour"] ~= nil then
			myTable["timer4OpenHour"] = string2Int(controlCmd["timer4_open_time_hour"])
		end

		-- 定时器4开始时间：分
		if controlCmd["timer4_open_time_min"] ~= nil then
			myTable["timer4OpenMin"] = string2Int(controlCmd["timer4_open_time_min"])
		end

		-- 定时器4结束时间：时
		if controlCmd["timer4_close_time_hour"] ~= nil then
			myTable["timer4CloseHour"] = string2Int(controlCmd["timer4_close_time_hour"])
		end

		-- 定时器4结束时间：分
		if controlCmd["timer4_close_time_min"] ~= nil then
			myTable["timer4CloseMin"] = string2Int(controlCmd["timer4_close_time_min"])
		end

		-- 定时4设定温度
		if controlCmd["timer4_set_temp"] ~= nil then
			myTable["timer4SetTemperature"] = string2Int(controlCmd["timer4_set_temp"])
		end

		-- 定时4设定模式
		if controlCmd["timer4_set_mode"] ~= nil then
			if controlCmd["timer4_set_mode"] == "off" then
				myTable["timer4ModeValue"] = 0x00
			elseif controlCmd["timer4_set_mode"] == "heat" then
				myTable["timer4ModeValue"] = 0x01
			elseif controlCmd["timer4_set_mode"] == "dhw" then
				myTable["timer4ModeValue"] = 0x02
			elseif controlCmd["timer4_set_mode"] == "cool" then
				myTable["timer4ModeValue"] = 0x03
			elseif controlCmd["timer4_set_mode"] == "waterpump" then
				myTable["timer4ModeValue"] = 0x04
			elseif controlCmd["timer4_set_mode"] == "auto" then
				myTable["timer4ModeValue"] = 0x05
			end
		end

		-- 定时器5开始时间：时
		if controlCmd["timer5_open_time_hour"] ~= nil then
			myTable["timer5OpenHour"] = string2Int(controlCmd["timer5_open_time_hour"])
		end

		-- 定时器5开始时间：分
		if controlCmd["timer5_open_time_min"] ~= nil then
			myTable["timer5OpenMin"] = string2Int(controlCmd["timer5_open_time_min"])
		end

		-- 定时器5结束时间：时
		if controlCmd["timer5_close_time_hour"] ~= nil then
			myTable["timer5CloseHour"] = string2Int(controlCmd["timer5_close_time_hour"])
		end

		-- 定时器5结束时间：分
		if controlCmd["timer5_close_time_min"] ~= nil then
			myTable["timer5CloseMin"] = string2Int(controlCmd["timer5_close_time_min"])
		end

		-- 定时5设定温度
		if controlCmd["timer5_set_temp"] ~= nil then
			myTable["timer5SetTemperature"] = string2Int(controlCmd["timer5_set_temp"])
		end

		-- 定时5设定模式
		if controlCmd["timer5_set_mode"] ~= nil then
			if controlCmd["timer5_set_mode"] == "off" then
				myTable["timer5ModeValue"] = 0x00
			elseif controlCmd["timer5_set_mode"] == "heat" then
				myTable["timer5ModeValue"] = 0x01
			elseif controlCmd["timer5_set_mode"] == "dhw" then
				myTable["timer5ModeValue"] = 0x02
			elseif controlCmd["timer5_set_mode"] == "cool" then
				myTable["timer5ModeValue"] = 0x03
			elseif controlCmd["timer5_set_mode"] == "waterpump" then
				myTable["timer5ModeValue"] = 0x04
			elseif controlCmd["timer5_set_mode"] == "auto" then
				myTable["timer5ModeValue"] = 0x05
			end
		end

		-- 定时器6开始时间：时
		if controlCmd["timer6_open_time_hour"] ~= nil then
			myTable["timer6OpenHour"] = string2Int(controlCmd["timer6_open_time_hour"])
		end

		-- 定时器6开始时间：分
		if controlCmd["timer6_open_time_min"] ~= nil then
			myTable["timer6OpenMin"] = string2Int(controlCmd["timer6_open_time_min"])
		end

		-- 定时器6结束时间：时
		if controlCmd["timer6_close_time_hour"] ~= nil then
			myTable["timer6CloseHour"] = string2Int(controlCmd["timer6_close_time_hour"])
		end

		-- 定时器6结束时间：分
		if controlCmd["timer6_close_time_min"] ~= nil then
			myTable["timer6CloseMin"] = string2Int(controlCmd["timer6_close_time_min"])
		end

		-- 定时6设定温度
		if controlCmd["timer6_set_temp"] ~= nil then
			myTable["timer6SetTemperature"] = string2Int(controlCmd["timer6_set_temp"])
		end

		-- 定时6设定模式
		if controlCmd["timer6_set_mode"] ~= nil then
			if controlCmd["timer6_set_mode"] == "off" then
				myTable["timer6ModeValue"] = 0x00
			elseif controlCmd["timer6_set_mode"] == "heat" then
				myTable["timer6ModeValue"] = 0x01
			elseif controlCmd["timer6_set_mode"] == "dhw" then
				myTable["timer6ModeValue"] = 0x02
			elseif controlCmd["timer6_set_mode"] == "cool" then
				myTable["timer6ModeValue"] = 0x03
			elseif controlCmd["timer6_set_mode"] == "waterpump" then
				myTable["timer6ModeValue"] = 0x04
			elseif controlCmd["timer6_set_mode"] == "auto" then
				myTable["timer6ModeValue"] = 0x05
			end
		end

		-- 定时器1是否有效
		if controlCmd["timer1_valid"] ~= nil then
			if controlCmd["timer1_valid"] == VALUE_VALID then
				myTable["timer1Valid"] = 0x01
			elseif controlCmd["timer1_valid"] == VALUE_INVALID then
				myTable["timer1Valid"] = 0x00
			end
		end

		-- 定时器2是否有效
		if controlCmd["timer2_valid"] ~= nil then
			if controlCmd["timer2_valid"] == VALUE_VALID then
				myTable["timer2Valid"] = 0x02
			elseif controlCmd["timer2_valid"] == VALUE_INVALID then
				myTable["timer2Valid"] = 0x00
			end
		end

		-- 定时器3是否有效
		if controlCmd["timer3_valid"] ~= nil then
			if controlCmd["timer3_valid"] == VALUE_VALID then
				myTable["timer3Valid"] = 0x04
			elseif controlCmd["timer3_valid"] == VALUE_INVALID then
				myTable["timer3Valid"] = 0x00
			end
		end

		-- 定时器4是否有效
		if controlCmd["timer4_valid"] ~= nil then
			if controlCmd["timer4_valid"] == VALUE_VALID then
				myTable["timer4Valid"] = 0x08
			elseif controlCmd["timer4_valid"] == VALUE_INVALID then
				myTable["timer4Valid"] = 0x00
			end
		end

		-- 定时器5是否有效
		if controlCmd["timer5_valid"] ~= nil then
			if controlCmd["timer5_valid"] == VALUE_VALID then
				myTable["timer5Valid"] = 0x10
			elseif controlCmd["timer5_valid"] == VALUE_INVALID then
				myTable["timer5Valid"] = 0x00
			end
		end

		-- 定时器6是否有效
		if controlCmd["timer6_valid"] ~= nil then
			if controlCmd["timer6_valid"] == VALUE_VALID then
				myTable["timer6Valid"] = 0x20
			elseif controlCmd["timer6_valid"] == VALUE_INVALID then
				myTable["timer6Valid"] = 0x00
			end
		end
	elseif myTable["controlType"] == BYTE_PERIODIC_REPORT_SUBCMD then
		myTable["setPeriodicReport"] = string2Int(controlCmd["set_periodic_report"])
	end
end

-- 根据 bin 修改属性变量
local function binToModel(binData)
	if #binData == 0 then
		return nil
	end

	local messageBytes = {}
	for i = 0, 176 do
		messageBytes[i] = 0
	end

	for i = 0, #binData do
		messageBytes[i] = binData[i]
	end

	myTable["controlType"] = messageBytes[0]
	if myTable["dataType"] == BYTE_CONTROL_REQUEST and myTable["controlType"] == BYTE_CONTRL_SUBCMD then
		myTable["modeValue"] = messageBytes[2] -- 设定模式
		myTable["tsValue"] = messageBytes[3] -- 设置温度TS
		myTable["ptcTemp"] = messageBytes[4] -- 电加热开启环境温度Td
		myTable["trValue"] = messageBytes[5] -- 热水开机回差Trdh
		myTable["sterilizeHour"] = messageBytes[6] -- 杀菌时间：时
		myTable["sterilizeMinute"] = messageBytes[7] -- 杀菌时间：分
		myTable["sterilizeTs"] = messageBytes[8] -- 杀菌设定温度
		myTable["sterilizeCycle"] = messageBytes[9] -- 杀菌周期：天
		-- 休假开始日期：年、月、日
		myTable["vacadaysStartYearValue"] = bit.rshift(messageBytes[10], 1)
		myTable["vacadaysStartMonthValue"] =
			bit.bor(bit.lshift(bit.band(messageBytes[10], 0x01), 3), bit.rshift(bit.band(messageBytes[11], 0xe0), 5))
		myTable["vacadaysStartDayValue"] = bit.band(messageBytes[11], 0x1f)
		-- 休假结束日期：年、月、日
		myTable["vacadaysEndYearValue"] = bit.rshift(messageBytes[12], 1)
		myTable["vacadaysEndMonthValue"] =
			bit.bor(bit.lshift(bit.band(messageBytes[12], 0x01), 3), bit.rshift(bit.band(messageBytes[13], 0xe0), 5))
		myTable["vacadaysEndDayValue"] = bit.band(messageBytes[13], 0x1f)
		myTable["vacationMode"] = messageBytes[14] -- 度假模式设定
		myTable["muteLev"] = messageBytes[15] -- 静音等级
		myTable["mute"] = bit.band(messageBytes[16], 0x01) -- 静音开关
		myTable["forceHeat"] = bit.band(messageBytes[16], 0x02) -- 强热开关
		myTable["smartGrid"] = bit.band(messageBytes[16], 0x80) -- SmartGrid开关
		myTable["optBackupEn"] = bit.band(messageBytes[17], 0x01) -- 峰谷电开关
		myTable["hybridEn"] = bit.band(messageBytes[17], 0x02) -- 燃气复合开关
		myTable["solarEnergyEn"] = bit.band(messageBytes[17], 0x04) -- 太阳能控制开关
		myTable["solarUseWay"] = bit.band(messageBytes[17], 0x08) -- 太阳能利用方式
		myTable["openPTC"] = bit.band(messageBytes[17], 0x10) -- 强制电辅热开关
		myTable["forceSterilizeEn"] = bit.band(messageBytes[17], 0x20) -- 强制杀菌开关
		myTable["vacationEn"] = bit.band(messageBytes[17], 0x40) -- 休假开关
		myTable["sterilizeEn"] = bit.band(messageBytes[17], 0x80) -- 杀菌开关
		myTable["heatPumpWorkTempLimit"] = messageBytes[18] -- 热泵开启温度下限
	elseif myTable["dataType"] == BYTE_CONTROL_REQUEST and myTable["controlType"] == BYTE_RUNPARA1_SUBCMD then
		-- 预留
	elseif
		myTable["dataType"] == BYTE_CONTROL_REQUEST
		or myTable["dataType"] == BYTE_QUERYL_REQUEST
		or myTable["dataType"] == BYTE_AUTO_REPORT
	then
		myTable["queryType"] = messageBytes[0]

		if myTable["queryType"] == BYTE_CONTRL_SUBCMD then
			myTable["modeValue"] = messageBytes[2] -- 设定模式
			myTable["tsValue"] = messageBytes[3] -- 设置温度TS
			myTable["t5sMax"] = messageBytes[4] -- 设定水温上限值
			myTable["t5sMin"] = messageBytes[5] -- 设定水温下限值
			myTable["t5sDef"] = messageBytes[6] -- 设定水温默认值
			myTable["tdMax"] = messageBytes[7] -- 电加热开启环境温度上限值
			myTable["tdMin"] = messageBytes[8] -- 电加热开启环境温度下限值
			myTable["tdDef"] = messageBytes[9] -- 电加热开启环境温度默认值
			myTable["trdhMax"] = messageBytes[10] -- 热水开机回差温度上限值
			myTable["trdhMin"] = messageBytes[11] -- 热水开机回差温度下限值
			myTable["trdhDef"] = messageBytes[12] -- 热水开机回差温度默认值
			myTable["sterilizeValid"] = bit.band(messageBytes[13], 0x01) -- 是否有杀菌功能
			myTable["hybridValid"] = bit.band(messageBytes[13], 0x02) -- 是否有燃气复合功能
			myTable["solarEnergyValid"] = bit.band(messageBytes[13], 0x04) -- 是否有太阳能控制功能
			myTable["optBackupValid"] = bit.band(messageBytes[13], 0x08) -- 是否有峰谷电功能
			myTable["vacationValid"] = bit.band(messageBytes[13], 0x10) -- 是否有休假功能
			myTable["smartGridValid"] = bit.band(messageBytes[13], 0x20) -- 是否有SmartGrid功能
			myTable["muteValid"] = bit.band(messageBytes[13], 0x40) -- 是否有静音功能
			myTable["forceHeatValid"] = bit.band(messageBytes[13], 0x80) -- 是否有强热功能
			myTable["smartGridLev"] = messageBytes[14] -- SmartGrid等级
			myTable["errorCode"] = messageBytes[15] -- 故障和保护代码
			myTable["sterilizeSta"] = bit.band(messageBytes[16], 0x01) -- 杀菌状态
			myTable["hybridSta"] = bit.band(messageBytes[16], 0x02) -- 燃气炉状态
			myTable["solarEnergySta"] = bit.band(messageBytes[16], 0x04) -- 太阳能信号状态
			myTable["optBackupSta"] = bit.band(messageBytes[16], 0x08) -- 谷电信号状态
			myTable["vacationSta"] = bit.band(messageBytes[16], 0x10) -- 休假状态
			myTable["ibh1Sta"] = bit.band(messageBytes[16], 0x20) -- 电加热1运行状态
			myTable["ibh2Sta"] = bit.band(messageBytes[16], 0x40) -- 电加热2运行状态
			myTable["compSta"] = bit.band(messageBytes[16], 0x80) -- 压缩机状态
			myTable["boxBottomTemp"] = messageBytes[17] -- 水箱下部温度
			myTable["ptcTemp"] = messageBytes[18] -- 电加热开启环境温度Td
			myTable["trValue"] = messageBytes[19] -- 热水开机回差Trdh
			myTable["sterilizeHour"] = messageBytes[20] -- 杀菌时间：时
			myTable["sterilizeMinute"] = messageBytes[21] -- 杀菌时间：分
			myTable["sterilizeTs"] = messageBytes[22] -- 杀菌设定温度
			myTable["sterilizeCycle"] = messageBytes[23] -- 杀菌周期：天
			myTable["optBackupEn"] = bit.band(messageBytes[24], 0x01) -- 峰谷电开关
			myTable["hybridEn"] = bit.band(messageBytes[24], 0x02) -- 燃气复合开关
			myTable["solarEnergyEn"] = bit.band(messageBytes[24], 0x04) -- 太阳能控制开关
			myTable["solarUseWay"] = bit.band(messageBytes[24], 0x08) -- 太阳能利用方式
			myTable["openPTC"] = bit.band(messageBytes[24], 0x10) -- 强制电辅热开关
			myTable["forceSterilizeEn"] = bit.band(messageBytes[24], 0x20) -- 强制杀菌开关
			myTable["vacationEn"] = bit.band(messageBytes[24], 0x40) -- 休假开关
			myTable["sterilizeEn"] = bit.band(messageBytes[24], 0x80) -- 杀菌开关
			myTable["heatPumpWorkTempLimit"] = messageBytes[25] -- 热泵开启温度下限
			-- 休假开始日期：年、月、日
			myTable["vacadaysStartYearValue"] = bit.rshift(messageBytes[26], 1)
			myTable["vacadaysStartMonthValue"] = bit.bor(
				bit.lshift(bit.band(messageBytes[26], 0x01), 3),
				bit.rshift(bit.band(messageBytes[27], 0xe0), 5)
			)
			myTable["vacadaysStartDayValue"] = bit.band(messageBytes[27], 0x1f)
			-- 休假结束日期：年、月、日
			myTable["vacadaysEndYearValue"] = bit.rshift(messageBytes[28], 1)
			myTable["vacadaysEndMonthValue"] = bit.bor(
				bit.lshift(bit.band(messageBytes[28], 0x01), 3),
				bit.rshift(bit.band(messageBytes[29], 0xe0), 5)
			)
			myTable["vacadaysEndDayValue"] = bit.band(messageBytes[29], 0x1f)
			myTable["vacationMode"] = messageBytes[30] -- 度假模式设定
			myTable["typeInfo"] = messageBytes[31] -- 机型信息
			-- 外风机转速
			myTable["oduFanSpd"] = bit.bor(bit.lshift(messageBytes[32], 8), messageBytes[33])
			-- 最近一次压缩机运行时间
			myTable["compRunTim"] = bit.bor(bit.lshift(messageBytes[34], 8), messageBytes[35])
			-- 电子膨胀阀开度
			myTable["exvDrg"] = bit.bor(bit.lshift(messageBytes[36], 8), messageBytes[37])
			-- 系统压力1
			myTable["pressureH"] = bit.bor(bit.lshift(messageBytes[38], 8), messageBytes[39])
			-- 系统压力2
			myTable["pressureL"] = bit.bor(bit.lshift(messageBytes[40], 8), messageBytes[41])
			myTable["runMode"] = messageBytes[42] -- 运行模式
			myTable["compFrq"] = messageBytes[43] -- 压缩机频率
			-- 累计消耗电量
			myTable["totalKwh"] = bit.bor(bit.lshift(messageBytes[44], 8), messageBytes[45])
			-- 压缩机累计运行时间
			myTable["compTotalRunTim"] = bit.bor(bit.lshift(messageBytes[46], 8), messageBytes[47])
			-- 风机累计运行时间
			myTable["fanTotalRunTim"] = bit.bor(bit.lshift(messageBytes[48], 8), messageBytes[49])
			myTable["pumpOSta"] = bit.band(messageBytes[50], 0x01) -- 外置水泵运行状态
			myTable["pumpSSta"] = bit.band(messageBytes[50], 0x02) -- 太阳能水泵运行状态
			myTable["oduRunCmd"] = bit.band(messageBytes[50], 0x04) -- 内机向外机发送的运行指令
			myTable["tempUnit"] = bit.band(messageBytes[50], 0x40) -- 温度单位
			myTable["smartGridSta"] = bit.band(messageBytes[50], 0x80) -- SmartGrid运行状态
		elseif myTable["queryType"] == BYTE_RUNPARA1_SUBCMD then
			-- 内置水泵累计运行时间
			myTable["pumpITotalRunTim"] = bit.bor(bit.lshift(messageBytes[2], 8), messageBytes[3])
			-- 电加热1累计运行时间
			myTable["ibh1TotalRunTim"] = bit.bor(bit.lshift(messageBytes[4], 8), messageBytes[5])
			-- 电加热2累计运行时间
			myTable["ibh2TotalRunTim"] = bit.bor(bit.lshift(messageBytes[6], 8), messageBytes[7])
			-- TBH累计运行时间
			myTable["tbhTotalRunTim"] = bit.bor(bit.lshift(messageBytes[8], 8), messageBytes[9])
			-- AHS累计运行时间
			myTable["ahsTotalRunTim"] = bit.bor(bit.lshift(messageBytes[10], 8), messageBytes[11])
			myTable["onlineNum"] = messageBytes[12] -- 机组在线台数
			myTable["oduMacType"] = messageBytes[13] -- 外机类型
			myTable["limitFrqCode"] = messageBytes[14] -- 限频代号
			myTable["tfTemp"] = messageBytes[15] -- 压缩机模块温度Tf
			myTable["tpTemp"] = messageBytes[16] -- 压缩机排气温度Tp
			myTable["thTemp"] = messageBytes[17] -- 压缩机回气温度Th
			myTable["waterPres"] = messageBytes[18] -- 水压
			myTable["waterFlow"] = messageBytes[19] -- 水侧流量
			myTable["capacityHp"] = messageBytes[20] -- 机组能力
			myTable["t3Temp"] = messageBytes[21] -- T3温度
			myTable["t4Temp"] = messageBytes[22] -- T4温度
			myTable["t2Temp"] = messageBytes[23] -- T2温度
			myTable["t2bTemp"] = messageBytes[24] -- T2b温度
			myTable["twinTemp"] = messageBytes[25] -- Twin温度
			myTable["twoutTemp"] = messageBytes[26] -- Twout温度
			myTable["t1Temp"] = messageBytes[27] -- T1温度
			myTable["oduCurrent"] = messageBytes[28] -- 输入电流
			-- 输入电压
			myTable["oduVoltage"] = bit.bor(bit.lshift(messageBytes[29], 8), messageBytes[30])
			myTable["dcCurrent"] = messageBytes[31] -- 直流母线电流
			-- 内机软件版本：年、月、日
			myTable["iduVersionYear"] = bit.rshift(messageBytes[32], 1)
			myTable["iduVersionMonth"] = bit.bor(
				bit.lshift(bit.band(messageBytes[32], 0x01), 3),
				bit.rshift(bit.band(messageBytes[33], 0xe0), 5)
			)
			myTable["iduVersionDay"] = bit.band(messageBytes[33], 0x1f)
			myTable["iduVersion"] = messageBytes[34] -- 外机软件版本号
			-- 外机软件版本：年、月、日
			myTable["oduVersionYear"] = bit.rshift(messageBytes[35], 1)
			myTable["oduVersionMonth"] = bit.bor(
				bit.lshift(bit.band(messageBytes[35], 0x01), 3),
				bit.rshift(bit.band(messageBytes[36], 0xe0), 5)
			)
			myTable["oduVersionDay"] = bit.band(messageBytes[36], 0x1f)
			myTable["oduVersion"] = messageBytes[37] -- 外机软件版本号
			-- 线控器软件版本：年、月、日
			myTable["hmiVersionYear"] = bit.rshift(messageBytes[38], 1)
			myTable["hmiVersionMonth"] = bit.bor(
				bit.lshift(bit.band(messageBytes[38], 0x01), 3),
				bit.rshift(bit.band(messageBytes[39], 0xe0), 5)
			)
			myTable["hmiVersionDay"] = bit.band(messageBytes[39], 0x1f)
			myTable["hmiVersion"] = messageBytes[40] -- 线控器软件版本号
			myTable["muteLev"] = messageBytes[41] -- 静音等级
			myTable["mute"] = bit.band(messageBytes[42], 0x01) -- 静音开关
			myTable["forceHeat"] = bit.band(messageBytes[42], 0x02) -- 强热开关
			-- 直流母线电压
			myTable["dcVoltage"] = bit.bor(bit.lshift(messageBytes[43], 8), messageBytes[44])

			-- 热量
			myTable["hpcValue"] = bit.bor(bit.lshift(messageBytes[45], 8), messageBytes[46])
		elseif myTable["queryType"] == 0x03 or myTable["controlType"] == 0x03 then
			myTable["muteTimer1En"] = bit.band(messageBytes[2], 0x01) -- 静音定时器1开关
			myTable["muteTimer1Effect"] = bit.band(messageBytes[2], BIT1) -- 静音定时器1是否有用
			myTable["muteTimer1Valid"] = bit.band(messageBytes[2], 0x80) -- 静音定时器1是否有效
			myTable["muteTimer1Lev"] = messageBytes[3] -- 静音定时器1静音等级
			myTable["muteTimer1StartTimeHour"] = messageBytes[4] -- 静音定时器1开始时间：时
			myTable["muteTimer1StartTimeMin"] = messageBytes[5] -- 静音定时器1开始时间：分
			myTable["muteTimer2En"] = bit.band(messageBytes[6], 0x01) -- 静音定时器2开关
			myTable["muteTimer2Effect"] = bit.band(messageBytes[6], BIT1) -- 静音定时器2是否有用
			myTable["muteTimer2Valid"] = bit.band(messageBytes[6], 0x80) -- 静音定时器2是否有效
			myTable["muteTimer2Lev"] = messageBytes[7] -- 静音定时器2静音等级
			myTable["muteTimer2StartTimeHour"] = messageBytes[8] -- 静音定时器2开始时间：时
			myTable["muteTimer2StartTimeMin"] = messageBytes[9] -- 静音定时器2开始时间：分
			myTable["muteTimer3En"] = bit.band(messageBytes[10], 0x01) -- 静音定时器3开关
			myTable["muteTimer3Effect"] = bit.band(messageBytes[10], BIT1) -- 静音定时器3是否有用
			myTable["muteTimer3Valid"] = bit.band(messageBytes[10], 0x80) -- 静音定时器3是否有效
			myTable["muteTimer3Lev"] = messageBytes[11] -- 静音定时器3静音等级
			myTable["muteTimer3StartTimeHour"] = messageBytes[12] -- 静音定时器3开始时间：时
			myTable["muteTimer3StartTimeMin"] = messageBytes[13] -- 静音定时器3开始时间：分
			myTable["muteTimer4En"] = bit.band(messageBytes[14], 0x01) -- 静音定时器4开关
			myTable["muteTimer4Effect"] = bit.band(messageBytes[14], BIT1) -- 静音定时器4是否有用
			myTable["muteTimer4Valid"] = bit.band(messageBytes[14], 0x80) -- 静音定时器4是否有效
			myTable["muteTimer4Lev"] = messageBytes[15] -- 静音定时器4静音等级
			myTable["muteTimer4StartTimeHour"] = messageBytes[16] -- 静音定时器4开始时间：时
			myTable["muteTimer4StartTimeMin"] = messageBytes[17] -- 静音定时器4开始时间：分
			myTable["muteTimer5En"] = bit.band(messageBytes[18], 0x01) -- 静音定时器5开关
			myTable["muteTimer5Effect"] = bit.band(messageBytes[18], BIT1) -- 静音定时器5是否有用
			myTable["muteTimer5Valid"] = bit.band(messageBytes[18], 0x80) -- 静音定时器5是否有效
			myTable["muteTimer5Lev"] = messageBytes[19] -- 静音定时器5静音等级
			myTable["muteTimer5StartTimeHour"] = messageBytes[20] -- 静音定时器5开始时间：时
			myTable["muteTimer5StartTimeMin"] = messageBytes[21] -- 静音定时器5开始时间：分
			myTable["muteTimer6En"] = bit.band(messageBytes[22], 0x01) -- 静音定时器6开关
			myTable["muteTimer6Effect"] = bit.band(messageBytes[22], BIT1) -- 静音定时器6是否有用
			myTable["muteTimer6Valid"] = bit.band(messageBytes[22], 0x80) -- 静音定时器6是否有效
			myTable["muteTimer6Lev"] = messageBytes[23] -- 静音定时器6静音等级
			myTable["muteTimer6StartTimeHour"] = messageBytes[24] -- 静音定时器6开始时间：时
			myTable["muteTimer6StartTimeMin"] = messageBytes[25] -- 静音定时器6开始时间：分
			myTable["forceHeatTimer1En"] = bit.band(messageBytes[26], 0x01) -- 强热定时器1开关
			myTable["forceHeatTimer1Effect"] = bit.band(messageBytes[26], BIT1) -- 强热定时器1是否有用
			myTable["forceHeatTimer1Valid"] = bit.band(messageBytes[26], 0x80) -- 强热定时器1是否有效
			myTable["forceHeatTimer1StartTimeHour"] = messageBytes[27] -- 强热定时器1开始时间：时
			myTable["forceHeatTimer1StartTimeMin"] = messageBytes[28] -- 强热定时器1开始时间：分
			myTable["forceHeatTimer2En"] = bit.band(messageBytes[29], 0x01) -- 强热定时器2开关
			myTable["forceHeatTimer2Effect"] = bit.band(messageBytes[29], BIT1) -- 强热定时器2是否有用
			myTable["forceHeatTimer2Valid"] = bit.band(messageBytes[29], 0x80) -- 强热定时器2是否有效
			myTable["forceHeatTimer2StartTimeHour"] = messageBytes[30] -- 强热定时器2开始时间：时
			myTable["forceHeatTimer2StartTimeMin"] = messageBytes[31] -- 强热定时器2开始时间：分
			myTable["forceHeatTimer3En"] = bit.band(messageBytes[32], 0x01) -- 强热定时器3开关
			myTable["forceHeatTimer3Effect"] = bit.band(messageBytes[32], BIT1) -- 强热定时器3是否有用
			myTable["forceHeatTimer3Valid"] = bit.band(messageBytes[32], 0x80) -- 强热定时器3是否有效
			myTable["forceHeatTimer3StartTimeHour"] = messageBytes[33] -- 强热定时器3开始时间：时
			myTable["forceHeatTimer3StartTimeMin"] = messageBytes[34] -- 强热定时器3开始时间：分
			myTable["forceHeatTimer4En"] = bit.band(messageBytes[35], 0x01) -- 强热定时器4开关
			myTable["forceHeatTimer4Effect"] = bit.band(messageBytes[35], BIT1) -- 强热定时器4是否有用
			myTable["forceHeatTimer4Valid"] = bit.band(messageBytes[35], 0x80) -- 强热定时器4是否有效
			myTable["forceHeatTimer4StartTimeHour"] = messageBytes[36] -- 强热定时器4开始时间：时
			myTable["forceHeatTimer4StartTimeMin"] = messageBytes[37] -- 强热定时器4开始时间：分
			myTable["forceHeatTimer5En"] = bit.band(messageBytes[38], 0x01) -- 强热定时器5开关
			myTable["forceHeatTimer5Effect"] = bit.band(messageBytes[38], BIT1) -- 强热定时器5是否有用
			myTable["forceHeatTimer5Valid"] = bit.band(messageBytes[38], 0x80) -- 强热定时器5是否有效
			myTable["forceHeatTimer5StartTimeHour"] = messageBytes[39] -- 强热定时器5开始时间：时
			myTable["forceHeatTimer5StartTimeMin"] = messageBytes[40] -- 强热定时器5开始时间：分
			myTable["forceHeatTimer6En"] = bit.band(messageBytes[41], 0x01) -- 强热定时器6开关
			myTable["forceHeatTimer6Effect"] = bit.band(messageBytes[41], BIT1) -- 强热定时器6是否有用
			myTable["forceHeatTimer6Valid"] = bit.band(messageBytes[41], 0x80) -- 强热定时器6是否有效
			myTable["forceHeatTimer6StartTimeHour"] = messageBytes[42] -- 强热定时器6开始时间：时
			myTable["forceHeatTimer6StartTimeMin"] = messageBytes[43] -- 强热定时器6开始时间：分
		elseif myTable["queryType"] == 0x04 or myTable["controlType"] == 0x04 then
			myTable["week0timer1Effect"] = bit.band(messageBytes[2], 0x01) -- 周日定时1开关
			myTable["week0timer2Effect"] = bit.band(messageBytes[2], 0x02) -- 周日定时2开关
			myTable["week0timer3Effect"] = bit.band(messageBytes[2], 0x04) -- 周日定时3开关
			myTable["week0timer4Effect"] = bit.band(messageBytes[2], 0x08) -- 周日定时4开关
			myTable["week0timer5Effect"] = bit.band(messageBytes[2], 0x10) -- 周日定时5开关
			myTable["week0timer6Effect"] = bit.band(messageBytes[2], 0x20) -- 周日定时6开关

			myTable["week0timer1SetMode"] = bit.band(messageBytes[3], 0x0F) -- 周日定时器1设定模式
			myTable["week0timer1MutSet"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4) -- 周日定时器1静音开关
			myTable["week0timer1FrcHeSet"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5) -- 周日定时器1强热开关
			myTable["week0timer1MutLev"] = bit.rshift(bit.band(messageBytes[3], 0xC0), 6) -- 周日定时器1静音等级

			myTable["week0timer1SetTemp"] = messageBytes[4] -- 周日定时器1设定温度
			myTable["week0timer1OpenTimeHour"] = messageBytes[5] -- 周日定时器1开始时间：时
			myTable["week0timer1OpenTimeMin"] = messageBytes[6] -- 周日定时器1开始时间：分
			myTable["week0timer1CloseTimeHour"] = messageBytes[7] -- 周日定时器1结束时间：时
			myTable["week0timer1CloseTimeMin"] = messageBytes[8] -- 周日定时器1结束时间：分

			myTable["week0timer2SetMode"] = bit.band(messageBytes[9], 0x0F) -- 周日定时器2设定模式
			myTable["week0timer2MutSet"] = bit.rshift(bit.band(messageBytes[9], 0x10), 4) -- 周日定时器2静音开关
			myTable["week0timer2FrcHeSet"] = bit.rshift(bit.band(messageBytes[9], 0x20), 5) -- 周日定时器2强热开关
			myTable["week0timer2MutLev"] = bit.rshift(bit.band(messageBytes[9], 0xC0), 6) -- 周日定时器2静音等级

			myTable["week0timer2SetTemp"] = messageBytes[10] -- 周日定时器2设定温度
			myTable["week0timer2OpenTimeHour"] = messageBytes[11] -- 周日定时器2开始时间：时
			myTable["week0timer2OpenTimeMin"] = messageBytes[12] -- 周日定时器2开始时间：分
			myTable["week0timer2CloseTimeHour"] = messageBytes[13] -- 周日定时器2结束时间：时
			myTable["week0timer2CloseTimeMin"] = messageBytes[14] -- 周日定时器2结束时间：分

			myTable["week0timer3SetMode"] = bit.band(messageBytes[15], 0x0F) -- 周日定时器3设定模式
			myTable["week0timer3MutSet"] = bit.rshift(bit.band(messageBytes[15], 0x10), 4) -- 周日定时器3静音开关
			myTable["week0timer3FrcHeSet"] = bit.rshift(bit.band(messageBytes[15], 0x20), 5) -- 周日定时器3强热开关
			myTable["week0timer3MutLev"] = bit.rshift(bit.band(messageBytes[15], 0xC0), 6) -- 周日定时器3静音等级

			myTable["week0timer3SetTemp"] = messageBytes[16] -- 周日定时器3设定温度
			myTable["week0timer3OpenTimeHour"] = messageBytes[17] -- 周日定时器3开始时间：时
			myTable["week0timer3OpenTimeMin"] = messageBytes[18] -- 周日定时器3开始时间：分
			myTable["week0timer3CloseTimeHour"] = messageBytes[19] -- 周日定时器3结束时间：时
			myTable["week0timer3CloseTimeMin"] = messageBytes[20] -- 周日定时器3结束时间：分

			myTable["week0timer4SetMode"] = bit.band(messageBytes[21], 0x0F) -- 周日定时器4设定模式
			myTable["week0timer4MutSet"] = bit.rshift(bit.band(messageBytes[21], 0x10), 4) -- 周日定时器4静音开关
			myTable["week0timer4FrcHeSet"] = bit.rshift(bit.band(messageBytes[21], 0x20), 5) -- 周日定时器4强热开关
			myTable["week0timer4MutLev"] = bit.rshift(bit.band(messageBytes[21], 0xC0), 6) -- 周日定时器4静音等级

			myTable["week0timer4SetTemp"] = messageBytes[22] -- 周日定时器4设定温度
			myTable["week0timer4OpenTimeHour"] = messageBytes[23] -- 周日定时器4开始时间：时
			myTable["week0timer4OpenTimeMin"] = messageBytes[24] -- 周日定时器4开始时间：分
			myTable["week0timer4CloseTimeHour"] = messageBytes[25] -- 周日定时器4结束时间：时
			myTable["week0timer4CloseTimeMin"] = messageBytes[26] -- 周日定时器4结束时间：分

			myTable["week0timer5SetMode"] = bit.band(messageBytes[27], 0x0F) -- 周日定时器5设定模式
			myTable["week0timer5MutSet"] = bit.rshift(bit.band(messageBytes[27], 0x10), 4) -- 周日定时器5静音开关
			myTable["week0timer5FrcHeSet"] = bit.rshift(bit.band(messageBytes[27], 0x20), 5) -- 周日定时器5强热开关
			myTable["week0timer5MutLev"] = bit.rshift(bit.band(messageBytes[27], 0xC0), 6) -- 周日定时器5静音等级

			myTable["week0timer5SetTemp"] = messageBytes[28] -- 周日定时器5设定温度
			myTable["week0timer5OpenTimeHour"] = messageBytes[29] -- 周日定时器5开始时间：时
			myTable["week0timer5OpenTimeMin"] = messageBytes[30] -- 周日定时器5开始时间：分
			myTable["week0timer5CloseTimeHour"] = messageBytes[31] -- 周日定时器5结束时间：时
			myTable["week0timer5CloseTimeMin"] = messageBytes[32] -- 周日定时器5结束时间：分

			myTable["week0timer6SetMode"] = bit.band(messageBytes[33], 0x0F) -- 周日定时器6设定模式
			myTable["week0timer6MutSet"] = bit.rshift(bit.band(messageBytes[33], 0x10), 4) -- 周日定时器6静音开关
			myTable["week0timer6FrcHeSet"] = bit.rshift(bit.band(messageBytes[33], 0x20), 5) -- 周日定时器6强热开关
			myTable["week0timer6MutLev"] = bit.rshift(bit.band(messageBytes[33], 0xC0), 6) -- 周日定时器6静音等级

			myTable["week0timer6SetTemp"] = messageBytes[34] -- 周日定时器6设定温度
			myTable["week0timer6OpenTimeHour"] = messageBytes[35] -- 周日定时器6开始时间：时
			myTable["week0timer6OpenTimeMin"] = messageBytes[36] -- 周日定时器6开始时间：分
			myTable["week0timer6CloseTimeHour"] = messageBytes[37] -- 周日定时器6结束时间：时
			myTable["week0timer6CloseTimeMin"] = messageBytes[38] -- 周日定时器6结束时间：分

			myTable["week0timer1Valid"] = bit.band(messageBytes[39], 0x01) -- 周日定时1是否有效
			myTable["week0timer2Valid"] = bit.band(messageBytes[39], 0x02) -- 周日定时2是否有效
			myTable["week0timer3Valid"] = bit.band(messageBytes[39], 0x04) -- 周日定时3是否有效
			myTable["week0timer4Valid"] = bit.band(messageBytes[39], 0x08) -- 周日定时4是否有效
			myTable["week0timer5Valid"] = bit.band(messageBytes[39], 0x10) -- 周日定时5是否有效
			myTable["week0timer6Valid"] = bit.band(messageBytes[39], 0x20) -- 周日定时6是否有效
		elseif myTable["queryType"] == 0x05 or myTable["controlType"] == 0x05 then
			myTable["week1timer1Effect"] = bit.band(messageBytes[2], 0x01) -- 周一定时1开关
			myTable["week1timer2Effect"] = bit.band(messageBytes[2], 0x02) -- 周一定时2开关
			myTable["week1timer3Effect"] = bit.band(messageBytes[2], 0x04) -- 周一定时3开关
			myTable["week1timer4Effect"] = bit.band(messageBytes[2], 0x08) -- 周一定时4开关
			myTable["week1timer5Effect"] = bit.band(messageBytes[2], 0x10) -- 周一定时5开关
			myTable["week1timer6Effect"] = bit.band(messageBytes[2], 0x20) -- 周一定时6开关

			myTable["week1timer1SetMode"] = bit.band(messageBytes[3], 0x0F) -- 周一定时器1设定模式
			myTable["week1timer1MutSet"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4) -- 周一定时器1静音开关
			myTable["week1timer1FrcHeSet"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5) -- 周一定时器1强热开关
			myTable["week1timer1MutLev"] = bit.rshift(bit.band(messageBytes[3], 0xC0), 6) -- 周一定时器1静音等级

			myTable["week1timer1SetTemp"] = messageBytes[4] -- 周一定时器1设定温度
			myTable["week1timer1OpenTimeHour"] = messageBytes[5] -- 周一定时器1开始时间：时
			myTable["week1timer1OpenTimeMin"] = messageBytes[6] -- 周一定时器1开始时间：分
			myTable["week1timer1CloseTimeHour"] = messageBytes[7] -- 周一定时器1结束时间：时
			myTable["week1timer1CloseTimeMin"] = messageBytes[8] -- 周一定时器1结束时间：分

			myTable["week1timer2SetMode"] = bit.band(messageBytes[9], 0x0F) -- 周一定时器2设定模式
			myTable["week1timer2MutSet"] = bit.rshift(bit.band(messageBytes[9], 0x10), 4) -- 周一定时器2静音开关
			myTable["week1timer2FrcHeSet"] = bit.rshift(bit.band(messageBytes[9], 0x20), 5) -- 周一定时器2强热开关
			myTable["week1timer2MutLev"] = bit.rshift(bit.band(messageBytes[9], 0xC0), 6) -- 周一定时器2静音等级

			myTable["week1timer2SetTemp"] = messageBytes[10] -- 周一定时器2设定温度
			myTable["week1timer2OpenTimeHour"] = messageBytes[11] -- 周一定时器2开始时间：时
			myTable["week1timer2OpenTimeMin"] = messageBytes[12] -- 周一定时器2开始时间：分
			myTable["week1timer2CloseTimeHour"] = messageBytes[13] -- 周一定时器2结束时间：时
			myTable["week1timer2CloseTimeMin"] = messageBytes[14] -- 周一定时器2结束时间：分

			myTable["week1timer3SetMode"] = bit.band(messageBytes[15], 0x0F) -- 周一定时器3设定模式
			myTable["week1timer3MutSet"] = bit.rshift(bit.band(messageBytes[15], 0x10), 4) -- 周一定时器3静音开关
			myTable["week1timer3FrcHeSet"] = bit.rshift(bit.band(messageBytes[15], 0x20), 5) -- 周一定时器3强热开关
			myTable["week1timer3MutLev"] = bit.rshift(bit.band(messageBytes[15], 0xC0), 6) -- 周一定时器3静音等级

			myTable["week1timer3SetTemp"] = messageBytes[16] -- 周一定时器3设定温度
			myTable["week1timer3OpenTimeHour"] = messageBytes[17] -- 周一定时器3开始时间：时
			myTable["week1timer3OpenTimeMin"] = messageBytes[18] -- 周一定时器3开始时间：分
			myTable["week1timer3CloseTimeHour"] = messageBytes[19] -- 周一定时器3结束时间：时
			myTable["week1timer3CloseTimeMin"] = messageBytes[20] -- 周一定时器3结束时间：分

			myTable["week1timer4SetMode"] = bit.band(messageBytes[21], 0x0F) -- 周一定时器4设定模式
			myTable["week1timer4MutSet"] = bit.rshift(bit.band(messageBytes[21], 0x10), 4) -- 周一定时器4静音开关
			myTable["week1timer4FrcHeSet"] = bit.rshift(bit.band(messageBytes[21], 0x20), 5) -- 周一定时器4强热开关
			myTable["week1timer4MutLev"] = bit.rshift(bit.band(messageBytes[21], 0xC0), 6) -- 周一定时器4静音等级

			myTable["week1timer4SetTemp"] = messageBytes[22] -- 周一定时器4设定温度
			myTable["week1timer4OpenTimeHour"] = messageBytes[23] -- 周一定时器4开始时间：时
			myTable["week1timer4OpenTimeMin"] = messageBytes[24] -- 周一定时器4开始时间：分
			myTable["week1timer4CloseTimeHour"] = messageBytes[25] -- 周一定时器4结束时间：时
			myTable["week1timer4CloseTimeMin"] = messageBytes[26] -- 周一定时器4结束时间：分

			myTable["week1timer5SetMode"] = bit.band(messageBytes[27], 0x0F) -- 周一定时器5设定模式
			myTable["week1timer5MutSet"] = bit.rshift(bit.band(messageBytes[27], 0x10), 4) -- 周一定时器5静音开关
			myTable["week1timer5FrcHeSet"] = bit.rshift(bit.band(messageBytes[27], 0x20), 5) -- 周一定时器5强热开关
			myTable["week1timer5MutLev"] = bit.rshift(bit.band(messageBytes[27], 0xC0), 6) -- 周一定时器5静音等级

			myTable["week1timer5SetTemp"] = messageBytes[28] -- 周一定时器5设定温度
			myTable["week1timer5OpenTimeHour"] = messageBytes[29] -- 周一定时器5开始时间：时
			myTable["week1timer5OpenTimeMin"] = messageBytes[30] -- 周一定时器5开始时间：分
			myTable["week1timer5CloseTimeHour"] = messageBytes[31] -- 周一定时器5结束时间：时
			myTable["week1timer5CloseTimeMin"] = messageBytes[32] -- 周一定时器5结束时间：分

			myTable["week1timer6SetMode"] = bit.band(messageBytes[33], 0x0F) -- 周一定时器6设定模式
			myTable["week1timer6MutSet"] = bit.rshift(bit.band(messageBytes[33], 0x10), 4) -- 周一定时器6静音开关
			myTable["week1timer6FrcHeSet"] = bit.rshift(bit.band(messageBytes[33], 0x20), 5) -- 周一定时器6强热开关
			myTable["week1timer6MutLev"] = bit.rshift(bit.band(messageBytes[33], 0xC0), 6) -- 周一定时器6静音等级

			myTable["week1timer6SetTemp"] = messageBytes[34] -- 周一定时器6设定温度
			myTable["week1timer6OpenTimeHour"] = messageBytes[35] -- 周一定时器6开始时间：时
			myTable["week1timer6OpenTimeMin"] = messageBytes[36] -- 周一定时器6开始时间：分
			myTable["week1timer6CloseTimeHour"] = messageBytes[37] -- 周一定时器6结束时间：时
			myTable["week1timer6CloseTimeMin"] = messageBytes[38] -- 周一定时器6结束时间：分

			myTable["week1timer1Valid"] = bit.band(messageBytes[39], 0x01) -- 周一定时1是否有效
			myTable["week1timer2Valid"] = bit.band(messageBytes[39], 0x02) -- 周一定时2是否有效
			myTable["week1timer3Valid"] = bit.band(messageBytes[39], 0x04) -- 周一定时3是否有效
			myTable["week1timer4Valid"] = bit.band(messageBytes[39], 0x08) -- 周一定时4是否有效
			myTable["week1timer5Valid"] = bit.band(messageBytes[39], 0x10) -- 周一定时5是否有效
			myTable["week1timer6Valid"] = bit.band(messageBytes[39], 0x20) -- 周一定时6是否有效
		elseif myTable["queryType"] == 0x06 or myTable["controlType"] == 0x06 then
			myTable["week2timer1Effect"] = bit.band(messageBytes[2], 0x01) -- 周二定时1开关
			myTable["week2timer2Effect"] = bit.band(messageBytes[2], 0x02) -- 周二定时2开关
			myTable["week2timer3Effect"] = bit.band(messageBytes[2], 0x04) -- 周二定时3开关
			myTable["week2timer4Effect"] = bit.band(messageBytes[2], 0x08) -- 周二定时4开关
			myTable["week2timer5Effect"] = bit.band(messageBytes[2], 0x10) -- 周二定时5开关
			myTable["week2timer6Effect"] = bit.band(messageBytes[2], 0x20) -- 周二定时6开关

			myTable["week2timer1SetMode"] = bit.band(messageBytes[3], 0x0F) -- 周二定时器1设定模式
			myTable["week2timer1MutSet"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4) -- 周二定时器1静音开关
			myTable["week2timer1FrcHeSet"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5) -- 周二定时器1强热开关
			myTable["week2timer1MutLev"] = bit.rshift(bit.band(messageBytes[3], 0xC0), 6) -- 周二定时器1静音等级

			myTable["week2timer1SetTemp"] = messageBytes[4] -- 周二定时器1设定温度
			myTable["week2timer1OpenTimeHour"] = messageBytes[5] -- 周二定时器1开始时间：时
			myTable["week2timer1OpenTimeMin"] = messageBytes[6] -- 周二定时器1开始时间：分
			myTable["week2timer1CloseTimeHour"] = messageBytes[7] -- 周二定时器1结束时间：时
			myTable["week2timer1CloseTimeMin"] = messageBytes[8] -- 周二定时器1结束时间：分

			myTable["week2timer2SetMode"] = bit.band(messageBytes[9], 0x0F) -- 周二定时器2设定模式
			myTable["week2timer2MutSet"] = bit.rshift(bit.band(messageBytes[9], 0x10), 4) -- 周二定时器2静音开关
			myTable["week2timer2FrcHeSet"] = bit.rshift(bit.band(messageBytes[9], 0x20), 5) -- 周二定时器2强热开关
			myTable["week2timer2MutLev"] = bit.rshift(bit.band(messageBytes[9], 0xC0), 6) -- 周二定时器2静音等级

			myTable["week2timer2SetTemp"] = messageBytes[10] -- 周二定时器2设定温度
			myTable["week2timer2OpenTimeHour"] = messageBytes[11] -- 周二定时器2开始时间：时
			myTable["week2timer2OpenTimeMin"] = messageBytes[12] -- 周二定时器2开始时间：分
			myTable["week2timer2CloseTimeHour"] = messageBytes[13] -- 周二定时器2结束时间：时
			myTable["week2timer2CloseTimeMin"] = messageBytes[14] -- 周二定时器2结束时间：分

			myTable["week2timer3SetMode"] = bit.band(messageBytes[15], 0x0F) -- 周二定时器3设定模式
			myTable["week2timer3MutSet"] = bit.rshift(bit.band(messageBytes[15], 0x10), 4) -- 周二定时器3静音开关
			myTable["week2timer3FrcHeSet"] = bit.rshift(bit.band(messageBytes[15], 0x20), 5) -- 周二定时器3强热开关
			myTable["week2timer3MutLev"] = bit.rshift(bit.band(messageBytes[15], 0xC0), 6) -- 周二定时器3静音等级

			myTable["week2timer3SetTemp"] = messageBytes[16] -- 周二定时器3设定温度
			myTable["week2timer3OpenTimeHour"] = messageBytes[17] -- 周二定时器3开始时间：时
			myTable["week2timer3OpenTimeMin"] = messageBytes[18] -- 周二定时器3开始时间：分
			myTable["week2timer3CloseTimeHour"] = messageBytes[19] -- 周二定时器3结束时间：时
			myTable["week2timer3CloseTimeMin"] = messageBytes[20] -- 周二定时器3结束时间：分

			myTable["week2timer4SetMode"] = bit.band(messageBytes[21], 0x0F) -- 周二定时器4设定模式
			myTable["week2timer4MutSet"] = bit.rshift(bit.band(messageBytes[21], 0x10), 4) -- 周二定时器4静音开关
			myTable["week2timer4FrcHeSet"] = bit.rshift(bit.band(messageBytes[21], 0x20), 5) -- 周二定时器4强热开关
			myTable["week2timer4MutLev"] = bit.rshift(bit.band(messageBytes[21], 0xC0), 6) -- 周二定时器4静音等级

			myTable["week2timer4SetTemp"] = messageBytes[22] -- 周二定时器4设定温度
			myTable["week2timer4OpenTimeHour"] = messageBytes[23] -- 周二定时器4开始时间：时
			myTable["week2timer4OpenTimeMin"] = messageBytes[24] -- 周二定时器4开始时间：分
			myTable["week2timer4CloseTimeHour"] = messageBytes[25] -- 周二定时器4结束时间：时
			myTable["week2timer4CloseTimeMin"] = messageBytes[26] -- 周二定时器4结束时间：分

			myTable["week2timer5SetMode"] = bit.band(messageBytes[27], 0x0F) -- 周二定时器5设定模式
			myTable["week2timer5MutSet"] = bit.rshift(bit.band(messageBytes[27], 0x10), 4) -- 周二定时器5静音开关
			myTable["week2timer5FrcHeSet"] = bit.rshift(bit.band(messageBytes[27], 0x20), 5) -- 周二定时器5强热开关
			myTable["week2timer5MutLev"] = bit.rshift(bit.band(messageBytes[27], 0xC0), 6) -- 周二定时器5静音等级

			myTable["week2timer5SetTemp"] = messageBytes[28] -- 周二定时器5设定温度
			myTable["week2timer5OpenTimeHour"] = messageBytes[29] -- 周二定时器5开始时间：时
			myTable["week2timer5OpenTimeMin"] = messageBytes[30] -- 周二定时器5开始时间：分
			myTable["week2timer5CloseTimeHour"] = messageBytes[31] -- 周二定时器5结束时间：时
			myTable["week2timer5CloseTimeMin"] = messageBytes[32] -- 周二定时器5结束时间：分

			myTable["week2timer6SetMode"] = bit.band(messageBytes[33], 0x0F) -- 周二定时器6设定模式
			myTable["week2timer6MutSet"] = bit.rshift(bit.band(messageBytes[33], 0x10), 4) -- 周二定时器6静音开关
			myTable["week2timer6FrcHeSet"] = bit.rshift(bit.band(messageBytes[33], 0x20), 5) -- 周二定时器6强热开关
			myTable["week2timer6MutLev"] = bit.rshift(bit.band(messageBytes[33], 0xC0), 6) -- 周二定时器6静音等级

			myTable["week2timer6SetTemp"] = messageBytes[34] -- 周二定时器6设定温度
			myTable["week2timer6OpenTimeHour"] = messageBytes[35] -- 周二定时器6开始时间：时
			myTable["week2timer6OpenTimeMin"] = messageBytes[36] -- 周二定时器6开始时间：分
			myTable["week2timer6CloseTimeHour"] = messageBytes[37] -- 周二定时器6结束时间：时
			myTable["week2timer6CloseTimeMin"] = messageBytes[38] -- 周二定时器6结束时间：分

			myTable["week2timer1Valid"] = bit.band(messageBytes[39], 0x01) -- 周二定时1是否有效
			myTable["week2timer2Valid"] = bit.band(messageBytes[39], 0x02) -- 周二定时2是否有效
			myTable["week2timer3Valid"] = bit.band(messageBytes[39], 0x04) -- 周二定时3是否有效
			myTable["week2timer4Valid"] = bit.band(messageBytes[39], 0x08) -- 周二定时4是否有效
			myTable["week2timer5Valid"] = bit.band(messageBytes[39], 0x10) -- 周二定时5是否有效
			myTable["week2timer6Valid"] = bit.band(messageBytes[39], 0x20) -- 周二定时6是否有效
		elseif myTable["queryType"] == 0x07 or myTable["controlType"] == 0x07 then
			myTable["week3timer1Effect"] = bit.band(messageBytes[2], 0x01) -- 周三定时1开关
			myTable["week3timer2Effect"] = bit.band(messageBytes[2], 0x02) -- 周三定时2开关
			myTable["week3timer3Effect"] = bit.band(messageBytes[2], 0x04) -- 周三定时3开关
			myTable["week3timer4Effect"] = bit.band(messageBytes[2], 0x08) -- 周三定时4开关
			myTable["week3timer5Effect"] = bit.band(messageBytes[2], 0x10) -- 周三定时5开关
			myTable["week3timer6Effect"] = bit.band(messageBytes[2], 0x20) -- 周三定时6开关

			myTable["week3timer1SetMode"] = bit.band(messageBytes[3], 0x0F) -- 周三定时器1设定模式
			myTable["week3timer1MutSet"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4) -- 周三定时器1静音开关
			myTable["week3timer1FrcHeSet"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5) -- 周三定时器1强热开关
			myTable["week3timer1MutLev"] = bit.rshift(bit.band(messageBytes[3], 0xC0), 6) -- 周三定时器1静音等级

			myTable["week3timer1SetTemp"] = messageBytes[4] -- 周三定时器1设定温度
			myTable["week3timer1OpenTimeHour"] = messageBytes[5] -- 周三定时器1开始时间：时
			myTable["week3timer1OpenTimeMin"] = messageBytes[6] -- 周三定时器1开始时间：分
			myTable["week3timer1CloseTimeHour"] = messageBytes[7] -- 周三定时器1结束时间：时
			myTable["week3timer1CloseTimeMin"] = messageBytes[8] -- 周三定时器1结束时间：分

			myTable["week3timer2SetMode"] = bit.band(messageBytes[9], 0x0F) -- 周三定时器2设定模式
			myTable["week3timer2MutSet"] = bit.rshift(bit.band(messageBytes[9], 0x10), 4) -- 周三定时器2静音开关
			myTable["week3timer2FrcHeSet"] = bit.rshift(bit.band(messageBytes[9], 0x20), 5) -- 周三定时器2强热开关
			myTable["week3timer2MutLev"] = bit.rshift(bit.band(messageBytes[9], 0xC0), 6) -- 周三定时器2静音等级

			myTable["week3timer2SetTemp"] = messageBytes[10] -- 周三定时器2设定温度
			myTable["week3timer2OpenTimeHour"] = messageBytes[11] -- 周三定时器2开始时间：时
			myTable["week3timer2OpenTimeMin"] = messageBytes[12] -- 周三定时器2开始时间：分
			myTable["week3timer2CloseTimeHour"] = messageBytes[13] -- 周三定时器2结束时间：时
			myTable["week3timer2CloseTimeMin"] = messageBytes[14] -- 周三定时器2结束时间：分

			myTable["week3timer3SetMode"] = bit.band(messageBytes[15], 0x0F) -- 周三定时器3设定模式
			myTable["week3timer3MutSet"] = bit.rshift(bit.band(messageBytes[15], 0x10), 4) -- 周三定时器3静音开关
			myTable["week3timer3FrcHeSet"] = bit.rshift(bit.band(messageBytes[15], 0x20), 5) -- 周三定时器3强热开关
			myTable["week3timer3MutLev"] = bit.rshift(bit.band(messageBytes[15], 0xC0), 6) -- 周三定时器3静音等级

			myTable["week3timer3SetTemp"] = messageBytes[16] -- 周三定时器3设定温度
			myTable["week3timer3OpenTimeHour"] = messageBytes[17] -- 周三定时器3开始时间：时
			myTable["week3timer3OpenTimeMin"] = messageBytes[18] -- 周三定时器3开始时间：分
			myTable["week3timer3CloseTimeHour"] = messageBytes[19] -- 周三定时器3结束时间：时
			myTable["week3timer3CloseTimeMin"] = messageBytes[20] -- 周三定时器3结束时间：分

			myTable["week3timer4SetMode"] = bit.band(messageBytes[21], 0x0F) -- 周三定时器4设定模式
			myTable["week3timer4MutSet"] = bit.rshift(bit.band(messageBytes[21], 0x10), 4) -- 周三定时器4静音开关
			myTable["week3timer4FrcHeSet"] = bit.rshift(bit.band(messageBytes[21], 0x20), 5) -- 周三定时器4强热开关
			myTable["week3timer4MutLev"] = bit.rshift(bit.band(messageBytes[21], 0xC0), 6) -- 周三定时器4静音等级

			myTable["week3timer4SetTemp"] = messageBytes[22] -- 周三定时器4设定温度
			myTable["week3timer4OpenTimeHour"] = messageBytes[23] -- 周三定时器4开始时间：时
			myTable["week3timer4OpenTimeMin"] = messageBytes[24] -- 周三定时器4开始时间：分
			myTable["week3timer4CloseTimeHour"] = messageBytes[25] -- 周三定时器4结束时间：时
			myTable["week3timer4CloseTimeMin"] = messageBytes[26] -- 周三定时器4结束时间：分

			myTable["week3timer5SetMode"] = bit.band(messageBytes[27], 0x0F) -- 周三定时器5设定模式
			myTable["week3timer5MutSet"] = bit.rshift(bit.band(messageBytes[27], 0x10), 4) -- 周三定时器5静音开关
			myTable["week3timer5FrcHeSet"] = bit.rshift(bit.band(messageBytes[27], 0x20), 5) -- 周三定时器5强热开关
			myTable["week3timer5MutLev"] = bit.rshift(bit.band(messageBytes[27], 0xC0), 6) -- 周三定时器5静音等级

			myTable["week3timer5SetTemp"] = messageBytes[28] -- 周三定时器5设定温度
			myTable["week3timer5OpenTimeHour"] = messageBytes[29] -- 周三定时器5开始时间：时
			myTable["week3timer5OpenTimeMin"] = messageBytes[30] -- 周三定时器5开始时间：分
			myTable["week3timer5CloseTimeHour"] = messageBytes[31] -- 周三定时器5结束时间：时
			myTable["week3timer5CloseTimeMin"] = messageBytes[32] -- 周三定时器5结束时间：分

			myTable["week3timer6SetMode"] = bit.band(messageBytes[33], 0x0F) -- 周三定时器6设定模式
			myTable["week3timer6MutSet"] = bit.rshift(bit.band(messageBytes[33], 0x10), 4) -- 周三定时器6静音开关
			myTable["week3timer6FrcHeSet"] = bit.rshift(bit.band(messageBytes[33], 0x20), 5) -- 周三定时器6强热开关
			myTable["week3timer6MutLev"] = bit.rshift(bit.band(messageBytes[33], 0xC0), 6) -- 周三定时器6静音等级

			myTable["week3timer6SetTemp"] = messageBytes[34] -- 周三定时器6设定温度
			myTable["week3timer6OpenTimeHour"] = messageBytes[35] -- 周三定时器6开始时间：时
			myTable["week3timer6OpenTimeMin"] = messageBytes[36] -- 周三定时器6开始时间：分
			myTable["week3timer6CloseTimeHour"] = messageBytes[37] -- 周三定时器6结束时间：时
			myTable["week3timer6CloseTimeMin"] = messageBytes[38] -- 周三定时器6结束时间：分

			myTable["week3timer1Valid"] = bit.band(messageBytes[39], 0x01) -- 周三定时1是否有效
			myTable["week3timer2Valid"] = bit.band(messageBytes[39], 0x02) -- 周三定时2是否有效
			myTable["week3timer3Valid"] = bit.band(messageBytes[39], 0x04) -- 周三定时3是否有效
			myTable["week3timer4Valid"] = bit.band(messageBytes[39], 0x08) -- 周三定时4是否有效
			myTable["week3timer5Valid"] = bit.band(messageBytes[39], 0x10) -- 周三定时5是否有效
			myTable["week3timer6Valid"] = bit.band(messageBytes[39], 0x20) -- 周三定时6是否有效
		elseif myTable["queryType"] == 0x08 or myTable["controlType"] == 0x08 then
			myTable["week4timer1Effect"] = bit.band(messageBytes[2], 0x01) -- 周四定时1开关
			myTable["week4timer2Effect"] = bit.band(messageBytes[2], 0x02) -- 周四定时2开关
			myTable["week4timer3Effect"] = bit.band(messageBytes[2], 0x04) -- 周四定时3开关
			myTable["week4timer4Effect"] = bit.band(messageBytes[2], 0x08) -- 周四定时4开关
			myTable["week4timer5Effect"] = bit.band(messageBytes[2], 0x10) -- 周四定时5开关
			myTable["week4timer6Effect"] = bit.band(messageBytes[2], 0x20) -- 周四定时6开关

			myTable["week4timer1SetMode"] = bit.band(messageBytes[3], 0x0F) -- 周四定时器1设定模式
			myTable["week4timer1MutSet"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4) -- 周四定时器1静音开关
			myTable["week4timer1FrcHeSet"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5) -- 周四定时器1强热开关
			myTable["week4timer1MutLev"] = bit.rshift(bit.band(messageBytes[3], 0xC0), 6) -- 周四定时器1静音等级

			myTable["week4timer1SetTemp"] = messageBytes[4] -- 周四定时器1设定温度
			myTable["week4timer1OpenTimeHour"] = messageBytes[5] -- 周四定时器1开始时间：时
			myTable["week4timer1OpenTimeMin"] = messageBytes[6] -- 周四定时器1开始时间：分
			myTable["week4timer1CloseTimeHour"] = messageBytes[7] -- 周四定时器1结束时间：时
			myTable["week4timer1CloseTimeMin"] = messageBytes[8] -- 周四定时器1结束时间：分

			myTable["week4timer2SetMode"] = bit.band(messageBytes[9], 0x0F) -- 周四定时器2设定模式
			myTable["week4timer2MutSet"] = bit.rshift(bit.band(messageBytes[9], 0x10), 4) -- 周四定时器2静音开关
			myTable["week4timer2FrcHeSet"] = bit.rshift(bit.band(messageBytes[9], 0x20), 5) -- 周四定时器2强热开关
			myTable["week4timer2MutLev"] = bit.rshift(bit.band(messageBytes[9], 0xC0), 6) -- 周四定时器2静音等级

			myTable["week4timer2SetTemp"] = messageBytes[10] -- 周四定时器2设定温度
			myTable["week4timer2OpenTimeHour"] = messageBytes[11] -- 周四定时器2开始时间：时
			myTable["week4timer2OpenTimeMin"] = messageBytes[12] -- 周四定时器2开始时间：分
			myTable["week4timer2CloseTimeHour"] = messageBytes[13] -- 周四定时器2结束时间：时
			myTable["week4timer2CloseTimeMin"] = messageBytes[14] -- 周四定时器2结束时间：分

			myTable["week4timer3SetMode"] = bit.band(messageBytes[15], 0x0F) -- 周四定时器3设定模式
			myTable["week4timer3MutSet"] = bit.rshift(bit.band(messageBytes[15], 0x10), 4) -- 周四定时器3静音开关
			myTable["week4timer3FrcHeSet"] = bit.rshift(bit.band(messageBytes[15], 0x20), 5) -- 周四定时器3强热开关
			myTable["week4timer3MutLev"] = bit.rshift(bit.band(messageBytes[15], 0xC0), 6) -- 周四定时器3静音等级

			myTable["week4timer3SetTemp"] = messageBytes[16] -- 周四定时器3设定温度
			myTable["week4timer3OpenTimeHour"] = messageBytes[17] -- 周四定时器3开始时间：时
			myTable["week4timer3OpenTimeMin"] = messageBytes[18] -- 周四定时器3开始时间：分
			myTable["week4timer3CloseTimeHour"] = messageBytes[19] -- 周四定时器3结束时间：时
			myTable["week4timer3CloseTimeMin"] = messageBytes[20] -- 周四定时器3结束时间：分

			myTable["week4timer4SetMode"] = bit.band(messageBytes[21], 0x0F) -- 周四定时器4设定模式
			myTable["week4timer4MutSet"] = bit.rshift(bit.band(messageBytes[21], 0x10), 4) -- 周四定时器4静音开关
			myTable["week4timer4FrcHeSet"] = bit.rshift(bit.band(messageBytes[21], 0x20), 5) -- 周四定时器4强热开关
			myTable["week4timer4MutLev"] = bit.rshift(bit.band(messageBytes[21], 0xC0), 6) -- 周四定时器4静音等级

			myTable["week4timer4SetTemp"] = messageBytes[22] -- 周四定时器4设定温度
			myTable["week4timer4OpenTimeHour"] = messageBytes[23] -- 周四定时器4开始时间：时
			myTable["week4timer4OpenTimeMin"] = messageBytes[24] -- 周四定时器4开始时间：分
			myTable["week4timer4CloseTimeHour"] = messageBytes[25] -- 周四定时器4结束时间：时
			myTable["week4timer4CloseTimeMin"] = messageBytes[26] -- 周四定时器4结束时间：分

			myTable["week4timer5SetMode"] = bit.band(messageBytes[27], 0x0F) -- 周四定时器5设定模式
			myTable["week4timer5MutSet"] = bit.rshift(bit.band(messageBytes[27], 0x10), 4) -- 周四定时器5静音开关
			myTable["week4timer5FrcHeSet"] = bit.rshift(bit.band(messageBytes[27], 0x20), 5) -- 周四定时器5强热开关
			myTable["week4timer5MutLev"] = bit.rshift(bit.band(messageBytes[27], 0xC0), 6) -- 周四定时器5静音等级

			myTable["week4timer5SetTemp"] = messageBytes[28] -- 周四定时器5设定温度
			myTable["week4timer5OpenTimeHour"] = messageBytes[29] -- 周四定时器5开始时间：时
			myTable["week4timer5OpenTimeMin"] = messageBytes[30] -- 周四定时器5开始时间：分
			myTable["week4timer5CloseTimeHour"] = messageBytes[31] -- 周四定时器5结束时间：时
			myTable["week4timer5CloseTimeMin"] = messageBytes[32] -- 周四定时器5结束时间：分

			myTable["week4timer6SetMode"] = bit.band(messageBytes[33], 0x0F) -- 周四定时器6设定模式
			myTable["week4timer6MutSet"] = bit.rshift(bit.band(messageBytes[33], 0x10), 4) -- 周四定时器6静音开关
			myTable["week4timer6FrcHeSet"] = bit.rshift(bit.band(messageBytes[33], 0x20), 5) -- 周四定时器6强热开关
			myTable["week4timer6MutLev"] = bit.rshift(bit.band(messageBytes[33], 0xC0), 6) -- 周四定时器6静音等级

			myTable["week4timer6SetTemp"] = messageBytes[34] -- 周四定时器6设定温度
			myTable["week4timer6OpenTimeHour"] = messageBytes[35] -- 周四定时器6开始时间：时
			myTable["week4timer6OpenTimeMin"] = messageBytes[36] -- 周四定时器6开始时间：分
			myTable["week4timer6CloseTimeHour"] = messageBytes[37] -- 周四定时器6结束时间：时
			myTable["week4timer6CloseTimeMin"] = messageBytes[38] -- 周四定时器6结束时间：分

			myTable["week4timer1Valid"] = bit.band(messageBytes[39], 0x01) -- 周四定时1是否有效
			myTable["week4timer2Valid"] = bit.band(messageBytes[39], 0x02) -- 周四定时2是否有效
			myTable["week4timer3Valid"] = bit.band(messageBytes[39], 0x04) -- 周四定时3是否有效
			myTable["week4timer4Valid"] = bit.band(messageBytes[39], 0x08) -- 周四定时4是否有效
			myTable["week4timer5Valid"] = bit.band(messageBytes[39], 0x10) -- 周四定时5是否有效
			myTable["week4timer6Valid"] = bit.band(messageBytes[39], 0x20) -- 周四定时6是否有效
		elseif myTable["queryType"] == 0x09 or myTable["controlType"] == 0x09 then
			myTable["week5timer1Effect"] = bit.band(messageBytes[2], 0x01) -- 周五定时1开关
			myTable["week5timer2Effect"] = bit.band(messageBytes[2], 0x02) -- 周五定时2开关
			myTable["week5timer3Effect"] = bit.band(messageBytes[2], 0x04) -- 周五定时3开关
			myTable["week5timer4Effect"] = bit.band(messageBytes[2], 0x08) -- 周五定时4开关
			myTable["week5timer5Effect"] = bit.band(messageBytes[2], 0x10) -- 周五定时5开关
			myTable["week5timer6Effect"] = bit.band(messageBytes[2], 0x20) -- 周五定时6开关

			myTable["week5timer1SetMode"] = bit.band(messageBytes[3], 0x0F) -- 周五定时器1设定模式
			myTable["week5timer1MutSet"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4) -- 周五定时器1静音开关
			myTable["week5timer1FrcHeSet"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5) -- 周五定时器1强热开关
			myTable["week5timer1MutLev"] = bit.rshift(bit.band(messageBytes[3], 0xC0), 6) -- 周五定时器1静音等级

			myTable["week5timer1SetTemp"] = messageBytes[4] -- 周五定时器1设定温度
			myTable["week5timer1OpenTimeHour"] = messageBytes[5] -- 周五定时器1开始时间：时
			myTable["week5timer1OpenTimeMin"] = messageBytes[6] -- 周五定时器1开始时间：分
			myTable["week5timer1CloseTimeHour"] = messageBytes[7] -- 周五定时器1结束时间：时
			myTable["week5timer1CloseTimeMin"] = messageBytes[8] -- 周五定时器1结束时间：分

			myTable["week5timer2SetMode"] = bit.band(messageBytes[9], 0x0F) -- 周五定时器2设定模式
			myTable["week5timer2MutSet"] = bit.rshift(bit.band(messageBytes[9], 0x10), 4) -- 周五定时器2静音开关
			myTable["week5timer2FrcHeSet"] = bit.rshift(bit.band(messageBytes[9], 0x20), 5) -- 周五定时器2强热开关
			myTable["week5timer2MutLev"] = bit.rshift(bit.band(messageBytes[9], 0xC0), 6) -- 周五定时器2静音等级

			myTable["week5timer2SetTemp"] = messageBytes[10] -- 周五定时器2设定温度
			myTable["week5timer2OpenTimeHour"] = messageBytes[11] -- 周五定时器2开始时间：时
			myTable["week5timer2OpenTimeMin"] = messageBytes[12] -- 周五定时器2开始时间：分
			myTable["week5timer2CloseTimeHour"] = messageBytes[13] -- 周五定时器2结束时间：时
			myTable["week5timer2CloseTimeMin"] = messageBytes[14] -- 周五定时器2结束时间：分

			myTable["week5timer3SetMode"] = bit.band(messageBytes[15], 0x0F) -- 周五定时器3设定模式
			myTable["week5timer3MutSet"] = bit.rshift(bit.band(messageBytes[15], 0x10), 4) -- 周五定时器3静音开关
			myTable["week5timer3FrcHeSet"] = bit.rshift(bit.band(messageBytes[15], 0x20), 5) -- 周五定时器3强热开关
			myTable["week5timer3MutLev"] = bit.rshift(bit.band(messageBytes[15], 0xC0), 6) -- 周五定时器3静音等级

			myTable["week5timer3SetTemp"] = messageBytes[16] -- 周五定时器3设定温度
			myTable["week5timer3OpenTimeHour"] = messageBytes[17] -- 周五定时器3开始时间：时
			myTable["week5timer3OpenTimeMin"] = messageBytes[18] -- 周五定时器3开始时间：分
			myTable["week5timer3CloseTimeHour"] = messageBytes[19] -- 周五定时器3结束时间：时
			myTable["week5timer3CloseTimeMin"] = messageBytes[20] -- 周五定时器3结束时间：分

			myTable["week5timer4SetMode"] = bit.band(messageBytes[21], 0x0F) -- 周五定时器4设定模式
			myTable["week5timer4MutSet"] = bit.rshift(bit.band(messageBytes[21], 0x10), 4) -- 周五定时器4静音开关
			myTable["week5timer4FrcHeSet"] = bit.rshift(bit.band(messageBytes[21], 0x20), 5) -- 周五定时器4强热开关
			myTable["week5timer4MutLev"] = bit.rshift(bit.band(messageBytes[21], 0xC0), 6) -- 周五定时器4静音等级

			myTable["week5timer4SetTemp"] = messageBytes[22] -- 周五定时器4设定温度
			myTable["week5timer4OpenTimeHour"] = messageBytes[23] -- 周五定时器4开始时间：时
			myTable["week5timer4OpenTimeMin"] = messageBytes[24] -- 周五定时器4开始时间：分
			myTable["week5timer4CloseTimeHour"] = messageBytes[25] -- 周五定时器4结束时间：时
			myTable["week5timer4CloseTimeMin"] = messageBytes[26] -- 周五定时器4结束时间：分

			myTable["week5timer5SetMode"] = bit.band(messageBytes[27], 0x0F) -- 周五定时器5设定模式
			myTable["week5timer5MutSet"] = bit.rshift(bit.band(messageBytes[27], 0x10), 4) -- 周五定时器5静音开关
			myTable["week5timer5FrcHeSet"] = bit.rshift(bit.band(messageBytes[27], 0x20), 5) -- 周五定时器5强热开关
			myTable["week5timer5MutLev"] = bit.rshift(bit.band(messageBytes[27], 0xC0), 6) -- 周五定时器5静音等级

			myTable["week5timer5SetTemp"] = messageBytes[28] -- 周五定时器5设定温度
			myTable["week5timer5OpenTimeHour"] = messageBytes[29] -- 周五定时器5开始时间：时
			myTable["week5timer5OpenTimeMin"] = messageBytes[30] -- 周五定时器5开始时间：分
			myTable["week5timer5CloseTimeHour"] = messageBytes[31] -- 周五定时器5结束时间：时
			myTable["week5timer5CloseTimeMin"] = messageBytes[32] -- 周五定时器5结束时间：分

			myTable["week5timer6SetMode"] = bit.band(messageBytes[33], 0x0F) -- 周五定时器6设定模式
			myTable["week5timer6MutSet"] = bit.rshift(bit.band(messageBytes[33], 0x10), 4) -- 周五定时器6静音开关
			myTable["week5timer6FrcHeSet"] = bit.rshift(bit.band(messageBytes[33], 0x20), 5) -- 周五定时器6强热开关
			myTable["week5timer6MutLev"] = bit.rshift(bit.band(messageBytes[33], 0xC0), 6) -- 周五定时器6静音等级

			myTable["week5timer6SetTemp"] = messageBytes[34] -- 周五定时器6设定温度
			myTable["week5timer6OpenTimeHour"] = messageBytes[35] -- 周五定时器6开始时间：时
			myTable["week5timer6OpenTimeMin"] = messageBytes[36] -- 周五定时器6开始时间：分
			myTable["week5timer6CloseTimeHour"] = messageBytes[37] -- 周五定时器6结束时间：时
			myTable["week5timer6CloseTimeMin"] = messageBytes[38] -- 周五定时器6结束时间：分

			myTable["week5timer1Valid"] = bit.band(messageBytes[39], 0x01) -- 周五定时1是否有效
			myTable["week5timer2Valid"] = bit.band(messageBytes[39], 0x02) -- 周五定时2是否有效
			myTable["week5timer3Valid"] = bit.band(messageBytes[39], 0x04) -- 周五定时3是否有效
			myTable["week5timer4Valid"] = bit.band(messageBytes[39], 0x08) -- 周五定时4是否有效
			myTable["week5timer5Valid"] = bit.band(messageBytes[39], 0x10) -- 周五定时5是否有效
			myTable["week5timer6Valid"] = bit.band(messageBytes[39], 0x20) -- 周五定时6是否有效
		elseif myTable["queryType"] == 0x0a or myTable["controlType"] == 0x0a then
			myTable["week6timer1Effect"] = bit.band(messageBytes[2], 0x01) -- 周六定时1开关
			myTable["week6timer2Effect"] = bit.band(messageBytes[2], 0x02) -- 周六定时2开关
			myTable["week6timer3Effect"] = bit.band(messageBytes[2], 0x04) -- 周六定时3开关
			myTable["week6timer4Effect"] = bit.band(messageBytes[2], 0x08) -- 周六定时4开关
			myTable["week6timer5Effect"] = bit.band(messageBytes[2], 0x10) -- 周六定时5开关
			myTable["week6timer6Effect"] = bit.band(messageBytes[2], 0x20) -- 周六定时6开关

			myTable["week6timer1SetMode"] = bit.band(messageBytes[3], 0x0F) -- 周六定时器1设定模式
			myTable["week6timer1MutSet"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4) -- 周六定时器1静音开关
			myTable["week6timer1FrcHeSet"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5) -- 周六定时器1强热开关
			myTable["week6timer1MutLev"] = bit.rshift(bit.band(messageBytes[3], 0xC0), 6) -- 周六定时器1静音等级

			myTable["week6timer1SetTemp"] = messageBytes[4] -- 周六定时器1设定温度
			myTable["week6timer1OpenTimeHour"] = messageBytes[5] -- 周六定时器1开始时间：时
			myTable["week6timer1OpenTimeMin"] = messageBytes[6] -- 周六定时器1开始时间：分
			myTable["week6timer1CloseTimeHour"] = messageBytes[7] -- 周六定时器1结束时间：时
			myTable["week6timer1CloseTimeMin"] = messageBytes[8] -- 周六定时器1结束时间：分

			myTable["week6timer2SetMode"] = bit.band(messageBytes[9], 0x0F) -- 周六定时器2设定模式
			myTable["week6timer2MutSet"] = bit.rshift(bit.band(messageBytes[9], 0x10), 4) -- 周六定时器2静音开关
			myTable["week6timer2FrcHeSet"] = bit.rshift(bit.band(messageBytes[9], 0x20), 5) -- 周六定时器2强热开关
			myTable["week6timer2MutLev"] = bit.rshift(bit.band(messageBytes[9], 0xC0), 6) -- 周六定时器2静音等级

			myTable["week6timer2SetTemp"] = messageBytes[10] -- 周六定时器2设定温度
			myTable["week6timer2OpenTimeHour"] = messageBytes[11] -- 周六定时器2开始时间：时
			myTable["week6timer2OpenTimeMin"] = messageBytes[12] -- 周六定时器2开始时间：分
			myTable["week6timer2CloseTimeHour"] = messageBytes[13] -- 周六定时器2结束时间：时
			myTable["week6timer2CloseTimeMin"] = messageBytes[14] -- 周六定时器2结束时间：分

			myTable["week6timer3SetMode"] = bit.band(messageBytes[15], 0x0F) -- 周六定时器3设定模式
			myTable["week6timer3MutSet"] = bit.rshift(bit.band(messageBytes[15], 0x10), 4) -- 周六定时器3静音开关
			myTable["week6timer3FrcHeSet"] = bit.rshift(bit.band(messageBytes[15], 0x20), 5) -- 周六定时器3强热开关
			myTable["week6timer3MutLev"] = bit.rshift(bit.band(messageBytes[15], 0xC0), 6) -- 周六定时器3静音等级

			myTable["week6timer3SetTemp"] = messageBytes[16] -- 周六定时器3设定温度
			myTable["week6timer3OpenTimeHour"] = messageBytes[17] -- 周六定时器3开始时间：时
			myTable["week6timer3OpenTimeMin"] = messageBytes[18] -- 周六定时器3开始时间：分
			myTable["week6timer3CloseTimeHour"] = messageBytes[19] -- 周六定时器3结束时间：时
			myTable["week6timer3CloseTimeMin"] = messageBytes[20] -- 周六定时器3结束时间：分

			myTable["week6timer4SetMode"] = bit.band(messageBytes[21], 0x0F) -- 周六定时器4设定模式
			myTable["week6timer4MutSet"] = bit.rshift(bit.band(messageBytes[21], 0x10), 4) -- 周六定时器4静音开关
			myTable["week6timer4FrcHeSet"] = bit.rshift(bit.band(messageBytes[21], 0x20), 5) -- 周六定时器4强热开关
			myTable["week6timer4MutLev"] = bit.rshift(bit.band(messageBytes[21], 0xC0), 6) -- 周六定时器4静音等级

			myTable["week6timer4SetTemp"] = messageBytes[22] -- 周六定时器4设定温度
			myTable["week6timer4OpenTimeHour"] = messageBytes[23] -- 周六定时器4开始时间：时
			myTable["week6timer4OpenTimeMin"] = messageBytes[24] -- 周六定时器4开始时间：分
			myTable["week6timer4CloseTimeHour"] = messageBytes[25] -- 周六定时器4结束时间：时
			myTable["week6timer4CloseTimeMin"] = messageBytes[26] -- 周六定时器4结束时间：分

			myTable["week6timer5SetMode"] = bit.band(messageBytes[27], 0x0F) -- 周六定时器5设定模式
			myTable["week6timer5MutSet"] = bit.rshift(bit.band(messageBytes[27], 0x10), 4) -- 周六定时器5静音开关
			myTable["week6timer5FrcHeSet"] = bit.rshift(bit.band(messageBytes[27], 0x20), 5) -- 周六定时器5强热开关
			myTable["week6timer5MutLev"] = bit.rshift(bit.band(messageBytes[27], 0xC0), 6) -- 周六定时器5静音等级

			myTable["week6timer5SetTemp"] = messageBytes[28] -- 周六定时器5设定温度
			myTable["week6timer5OpenTimeHour"] = messageBytes[29] -- 周六定时器5开始时间：时
			myTable["week6timer5OpenTimeMin"] = messageBytes[30] -- 周六定时器5开始时间：分
			myTable["week6timer5CloseTimeHour"] = messageBytes[31] -- 周六定时器5结束时间：时
			myTable["week6timer5CloseTimeMin"] = messageBytes[32] -- 周六定时器5结束时间：分

			myTable["week6timer6SetMode"] = bit.band(messageBytes[33], 0x0F) -- 周六定时器6设定模式
			myTable["week6timer6MutSet"] = bit.rshift(bit.band(messageBytes[33], 0x10), 4) -- 周六定时器6静音开关
			myTable["week6timer6FrcHeSet"] = bit.rshift(bit.band(messageBytes[33], 0x20), 5) -- 周六定时器6强热开关
			myTable["week6timer6MutLev"] = bit.rshift(bit.band(messageBytes[33], 0xC0), 6) -- 周六定时器6静音等级

			myTable["week6timer6SetTemp"] = messageBytes[34] -- 周六定时器6设定温度
			myTable["week6timer6OpenTimeHour"] = messageBytes[35] -- 周六定时器6开始时间：时
			myTable["week6timer6OpenTimeMin"] = messageBytes[36] -- 周六定时器6开始时间：分
			myTable["week6timer6CloseTimeHour"] = messageBytes[37] -- 周六定时器6结束时间：时
			myTable["week6timer6CloseTimeMin"] = messageBytes[38] -- 周六定时器6结束时间：分

			myTable["week6timer1Valid"] = bit.band(messageBytes[39], 0x01) -- 周六定时1是否有效
			myTable["week6timer2Valid"] = bit.band(messageBytes[39], 0x02) -- 周六定时2是否有效
			myTable["week6timer3Valid"] = bit.band(messageBytes[39], 0x04) -- 周六定时3是否有效
			myTable["week6timer4Valid"] = bit.band(messageBytes[39], 0x08) -- 周六定时4是否有效
			myTable["week6timer5Valid"] = bit.band(messageBytes[39], 0x10) -- 周六定时5是否有效
			myTable["week6timer6Valid"] = bit.band(messageBytes[39], 0x20) -- 周六定时6是否有效
		elseif myTable["queryType"] == 0x0b or myTable["controlType"] == 0x0b then
			myTable["timerType"] = messageBytes[2] -- 定时器类型

			myTable["timer1Effect"] = bit.band(messageBytes[3], 0x01) -- 定时1开关
			myTable["timer2Effect"] = bit.band(messageBytes[3], 0x02) -- 定时2开关
			myTable["timer3Effect"] = bit.band(messageBytes[3], 0x04) -- 定时3开关
			myTable["timer4Effect"] = bit.band(messageBytes[3], 0x08) -- 定时4开关
			myTable["timer5Effect"] = bit.band(messageBytes[3], 0x10) -- 定时5开关
			myTable["timer6Effect"] = bit.band(messageBytes[3], 0x20) -- 定时6开关

			myTable["timer1OpenHour"] = messageBytes[4] -- 定时器1开始时间：时
			myTable["timer1OpenMin"] = messageBytes[5] -- 定时器1开始时间：分
			myTable["timer1CloseHour"] = messageBytes[6] -- 定时器1结束时间：时
			myTable["timer1CloseMin"] = messageBytes[7] -- 定时器1结束时间：分
			myTable["timer1SetTemperature"] = messageBytes[8] -- 定时器1设定温度
			myTable["timer1ModeValue"] = messageBytes[9] -- 定时器1设定模式

			myTable["timer2OpenHour"] = messageBytes[10] -- 定时器2开始时间：时
			myTable["timer2OpenMin"] = messageBytes[11] -- 定时器2开始时间：分
			myTable["timer2CloseHour"] = messageBytes[12] -- 定时器2结束时间：时
			myTable["timer2CloseMin"] = messageBytes[13] -- 定时器2结束时间：分
			myTable["timer2SetTemperature"] = messageBytes[14] -- 定时器2设定温度
			myTable["timer2ModeValue"] = messageBytes[15] -- 定时器2设定模式

			myTable["timer3OpenHour"] = messageBytes[16] -- 定时器3开始时间：时
			myTable["timer3OpenMin"] = messageBytes[17] -- 定时器3开始时间：分
			myTable["timer3CloseHour"] = messageBytes[18] -- 定时器3结束时间：时
			myTable["timer3CloseMin"] = messageBytes[19] -- 定时器3结束时间：分
			myTable["timer3SetTemperature"] = messageBytes[20] -- 定时器3设定温度
			myTable["timer3ModeValue"] = messageBytes[21] -- 定时器3设定模式

			myTable["timer4OpenHour"] = messageBytes[22] -- 定时器4开始时间：时
			myTable["timer4OpenMin"] = messageBytes[23] -- 定时器4开始时间：分
			myTable["timer4CloseHour"] = messageBytes[24] -- 定时器4结束时间：时
			myTable["timer4CloseMin"] = messageBytes[25] -- 定时器4结束时间：分
			myTable["timer4SetTemperature"] = messageBytes[26] -- 定时器4设定温度
			myTable["timer4ModeValue"] = messageBytes[27] -- 定时器4设定模式

			myTable["timer5OpenHour"] = messageBytes[28] -- 定时器5开始时间：时
			myTable["timer5OpenMin"] = messageBytes[29] -- 定时器5开始时间：分
			myTable["timer5CloseHour"] = messageBytes[30] -- 定时器5结束时间：时
			myTable["timer5CloseMin"] = messageBytes[31] -- 定时器5结束时间：分
			myTable["timer5SetTemperature"] = messageBytes[32] -- 定时器5设定温度
			myTable["timer5ModeValue"] = messageBytes[33] -- 定时器5设定模式

			myTable["timer6OpenHour"] = messageBytes[34] -- 定时器6开始时间：时
			myTable["timer6OpenMin"] = messageBytes[35] -- 定时器6开始时间：分
			myTable["timer6CloseHour"] = messageBytes[36] -- 定时器6结束时间：时
			myTable["timer6CloseMin"] = messageBytes[37] -- 定时器6结束时间：分
			myTable["timer6SetTemperature"] = messageBytes[38] -- 定时器6设定温度
			myTable["timer6ModeValue"] = messageBytes[39] -- 定时器6设定模式

			myTable["timer1Valid"] = bit.band(messageBytes[40], 0x01) -- 定时1是否有效
			myTable["timer2Valid"] = bit.band(messageBytes[40], 0x02) -- 定时2是否有效
			myTable["timer3Valid"] = bit.band(messageBytes[40], 0x04) -- 定时3是否有效
			myTable["timer4Valid"] = bit.band(messageBytes[40], 0x08) -- 定时4是否有效
			myTable["timer5Valid"] = bit.band(messageBytes[40], 0x10) -- 定时5是否有效
			myTable["timer6Valid"] = bit.band(messageBytes[40], 0x20) -- 定时6是否有效
		elseif myTable["queryType"] == BYTE_SN_SUBCMD then
			myTable["oduSNCode"] = "" -- SN码
			for i = 0, 32 do
				local ascii = messageBytes[2 + i]
				if
					not (ascii >= 48 and ascii <= 57)
					and not (ascii >= 65 and ascii <= 90)
					and not (ascii >= 97 and ascii <= 122)
				then
					_snLen = 0
					break
				end
				myTable["oduSNCode"] = string.format("%s%c", myTable["oduSNCode"], ascii)
			end
		elseif myTable["queryType"] == BYTE_RUNPARA2_SUBCMD then
			myTable["fg_IBHEnable"] = bit.band(messageBytes[2], BIT3) -- 杀菌状态
			myTable["tseh_temp"] = messageBytes[3] * 256 + messageBytes[4]
			myTable["treh_temp"] = messageBytes[5] * 256 + messageBytes[6]
			myTable["t5u_temp"] = messageBytes[7] * 256 + messageBytes[8]

			myTable["eheat_current"] = messageBytes[17] * 256 + messageBytes[18]
			myTable["power_total"] = messageBytes[19] * 256 + messageBytes[20]
			myTable["eheat_total_kwh"] = messageBytes[21] * 16777216
				+ messageBytes[22] * 65536
				+ messageBytes[23] * 256
				+ messageBytes[24]
			myTable["comp_total_kwh"] = messageBytes[25] * 16777216
				+ messageBytes[26] * 65536
				+ messageBytes[27] * 256
				+ messageBytes[28]
			myTable["eheat_24h_kwh"] = messageBytes[29] * 256 + messageBytes[30]
			myTable["comp_24h_kwh"] = messageBytes[41] * 256 + messageBytes[42]
		end
	end
end

-- json转二进制，可传入原状态
function jsonToData(jsonCmd)
	if #jsonCmd == 0 then
		return nil
	end

	local json = decode(jsonCmd)
	local deviceSubType = json["deviceinfo"]["deviceSubType"]

	-- 根据设备子类型来处理协议差异
	if deviceSubType == 1 then
	end

	local query = json["query"]
	local control = json["control"]
	local status = json["status"]

	-- lua table 索引从 1 开始，因此此处要重新转换一次
	local infoM = {}

	local bodyBytes = {}

	-- 当前是查询指令，构造固定的二进制即可
	if query then
		-- 构造消息 body 部分

		if (string2Int(query["query_type"]) > 0) and (string2Int(query["query_type"]) < 14) then
			-- 0x01 : 普通查询1
			-- 0x02 : 普通查询2
			-- 0x03 : 查询静音和强热定时
			-- 0x04 : 查询周日定时
			-- 0x05 : 查询周一定时
			-- 0x06 : 查询周二定时
			-- 0x07 : 查询周三定时
			-- 0x08 : 查询周四定时
			-- 0x09 : 查询周五定时
			-- 0x0A : 查询周六定时
			-- 0x0B : 查询普通定时
			-- 0x0C : 查询主机SN
			-- 0x0D : 普通查询3
			bodyBytes[0] = string2Int(query["query_type"])
		else
			-- 普通查询1
			bodyBytes[0] = 0x01
		end

		bodyBytes[1] = 0x01
		infoM = getTotalMsg(bodyBytes, BYTE_QUERYL_REQUEST)

		-- 当前是控制指令
	elseif control then
		-- 先将原始状态和控制字典转换为属性
		if status then
			jsonToModel(status)
		end

		if control then
			jsonToModel(control)
		end

		-- 根据不同的子类型来做处理
		if myTable["controlType"] == BYTE_CONTRL_SUBCMD then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			bodyBytes[2] = myTable["modeValue"] -- 设定模式
			bodyBytes[3] = myTable["tsValue"] -- 设定温度
			bodyBytes[4] = myTable["ptcTemp"] -- 电加热开启环境温度Td
			bodyBytes[5] = myTable["trValue"] -- 热水开机回差Trdh
			bodyBytes[6] = myTable["sterilizeHour"] -- 杀菌时间：时
			bodyBytes[7] = myTable["sterilizeMinute"] -- 杀菌时间：分
			bodyBytes[8] = myTable["sterilizeTs"] -- 杀菌设定温度
			bodyBytes[9] = myTable["sterilizeCycle"] -- 杀菌周期：天
			-- 休假开始日期：年、月、日
			bodyBytes[10] = bit.bor(
				bit.lshift(myTable["vacadaysStartYearValue"], 1),
				bit.rshift(bit.band(myTable["vacadaysStartMonthValue"], 0x0f), 3)
			)
			bodyBytes[11] = bit.bor(
				bit.lshift(bit.band(myTable["vacadaysStartMonthValue"], 0x07), 5),
				bit.band(myTable["vacadaysStartDayValue"], 0x1f)
			)
			-- 休假结束日期：年、月、日
			bodyBytes[12] = bit.bor(
				bit.lshift(myTable["vacadaysEndYearValue"], 1),
				bit.rshift(bit.band(myTable["vacadaysEndMonthValue"], 0x0f), 3)
			)
			bodyBytes[13] = bit.bor(
				bit.lshift(bit.band(myTable["vacadaysEndMonthValue"], 0x07), 5),
				bit.band(myTable["vacadaysEndDayValue"], 0x1f)
			)
			bodyBytes[14] = myTable["vacationMode"] -- 度假模式设定
			bodyBytes[15] = myTable["muteLev"] -- 静音等级
			-- 静音、强热、SmartGrid开关
			bodyBytes[16] = bit.bor(
				bit.band(myTable["mute"], 0x01),
				bit.bor(bit.band(myTable["forceHeat"], 0x02), bit.band(myTable["smartGrid"], 0x80))
			)
			-- 峰谷电、燃气复合、太阳能、强制电辅热、强制杀菌、休假、杀菌、开关
			bodyBytes[17] = bit.bor(
				bit.band(myTable["optBackupEn"], 0x01),
				bit.bor(
					bit.band(myTable["hybridEn"], 0x02),
					bit.bor(
						bit.band(myTable["solarEnergyEn"], 0x04),
						bit.bor(
							bit.band(myTable["solarUseWay"], 0x08),
							bit.bor(
								bit.band(myTable["openPTC"], 0x10),
								bit.bor(
									bit.band(myTable["forceSterilizeEn"], 0x20),
									bit.bor(
										bit.band(myTable["vacationEn"], 0x40),
										bit.band(myTable["sterilizeEn"], 0x80)
									)
								)
							)
						)
					)
				)
			)
			bodyBytes[18] = myTable["heatPumpWorkTempLimit"] -- 热泵开启温度下限

			-- 设置日期信息
			bodyBytes[19] = myTable["setYear"]
			bodyBytes[20] = myTable["setMonth"]
			bodyBytes[21] = myTable["setDay"]
			bodyBytes[22] = myTable["setWeek"]
			bodyBytes[23] = myTable["setHour"]
			bodyBytes[24] = myTable["setMinute"]

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x03 then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			bodyBytes[2] =
				bit.bor(bit.bor(myTable["muteTimer1En"], myTable["muteTimer1Valid"]), myTable["muteTimer1Effect"]) -- 静音定时器1开关、是否有效、是否有用
			bodyBytes[3] = myTable["muteTimer1Lev"] -- 静音定时器1静音等级
			bodyBytes[4] = myTable["muteTimer1StartTimeHour"] -- 静音定时器1开始时间：时
			bodyBytes[5] = myTable["muteTimer1StartTimeMin"] -- 静音定时器1开始时间：分
			bodyBytes[6] =
				bit.bor(bit.bor(myTable["muteTimer2En"], myTable["muteTimer2Valid"]), myTable["muteTimer2Effect"]) -- 静音定时器2开关、是否有效、是否有用
			bodyBytes[7] = myTable["muteTimer2Lev"] -- 静音定时器2静音等级
			bodyBytes[8] = myTable["muteTimer2StartTimeHour"] -- 静音定时器2开始时间：时
			bodyBytes[9] = myTable["muteTimer2StartTimeMin"] -- 静音定时器2开始时间：分
			bodyBytes[10] =
				bit.bor(bit.bor(myTable["muteTimer3En"], myTable["muteTimer3Valid"]), myTable["muteTimer3Effect"]) -- 静音定时器3开关、是否有效、是否有用
			bodyBytes[11] = myTable["muteTimer3Lev"] -- 静音定时器3静音等级
			bodyBytes[12] = myTable["muteTimer3StartTimeHour"] -- 静音定时器3开始时间：时
			bodyBytes[13] = myTable["muteTimer3StartTimeMin"] -- 静音定时器3开始时间：分
			bodyBytes[14] =
				bit.bor(bit.bor(myTable["muteTimer4En"], myTable["muteTimer4Valid"]), myTable["muteTimer4Effect"]) -- 静音定时器4开关、是否有效、是否有用
			bodyBytes[15] = myTable["muteTimer4Lev"] -- 静音定时器4静音等级
			bodyBytes[16] = myTable["muteTimer4StartTimeHour"] -- 静音定时器4开始时间：时
			bodyBytes[17] = myTable["muteTimer4StartTimeMin"] -- 静音定时器4开始时间：分
			bodyBytes[18] =
				bit.bor(bit.bor(myTable["muteTimer5En"], myTable["muteTimer5Valid"]), myTable["muteTimer5Effect"]) -- 静音定时器5开关、是否有效、是否有用
			bodyBytes[19] = myTable["muteTimer5Lev"] -- 静音定时器5静音等级
			bodyBytes[20] = myTable["muteTimer5StartTimeHour"] -- 静音定时器5开始时间：时
			bodyBytes[21] = myTable["muteTimer5StartTimeMin"] -- 静音定时器5开始时间：分
			bodyBytes[22] =
				bit.bor(bit.bor(myTable["muteTimer6En"], myTable["muteTimer6Valid"]), myTable["muteTimer6Effect"]) -- 静音定时器6开关、是否有效、是否有用
			bodyBytes[23] = myTable["muteTimer6Lev"] -- 静音定时器6静音等级
			bodyBytes[24] = myTable["muteTimer6StartTimeHour"] -- 静音定时器6开始时间：时
			bodyBytes[25] = myTable["muteTimer6StartTimeMin"] -- 静音定时器6开始时间：分
			bodyBytes[26] = bit.bor(
				bit.bor(myTable["forceHeatTimer1En"], myTable["forceHeatTimer1Valid"]),
				myTable["forceHeatTimer1Effect"]
			) -- 强热定时器1开关、是否有效、是否有用
			bodyBytes[27] = myTable["forceHeatTimer1StartTimeHour"] -- 强热定时器1开始时间：时
			bodyBytes[28] = myTable["forceHeatTimer1StartTimeMin"] -- 强热定时器1开始时间：分
			bodyBytes[29] = bit.bor(
				bit.bor(myTable["forceHeatTimer2En"], myTable["forceHeatTimer2Valid"]),
				myTable["forceHeatTimer2Effect"]
			) -- 强热定时器2开关、是否有效、是否有用
			bodyBytes[30] = myTable["forceHeatTimer2StartTimeHour"] -- 强热定时器2开始时间：时
			bodyBytes[31] = myTable["forceHeatTimer2StartTimeMin"] -- 强热定时器2开始时间：分
			bodyBytes[32] = bit.bor(
				bit.bor(myTable["forceHeatTimer3En"], myTable["forceHeatTimer3Valid"]),
				myTable["forceHeatTimer3Effect"]
			) -- 强热定时器3开关、是否有效、是否有用
			bodyBytes[33] = myTable["forceHeatTimer3StartTimeHour"] -- 强热定时器3开始时间：时
			bodyBytes[34] = myTable["forceHeatTimer3StartTimeMin"] -- 强热定时器3开始时间：分
			bodyBytes[35] = bit.bor(
				bit.bor(myTable["forceHeatTimer4En"], myTable["forceHeatTimer4Valid"]),
				myTable["forceHeatTimer4Effect"]
			) -- 强热定时器4开关、是否有效、是否有用
			bodyBytes[36] = myTable["forceHeatTimer4StartTimeHour"] -- 强热定时器4开始时间：时
			bodyBytes[37] = myTable["forceHeatTimer4StartTimeMin"] -- 强热定时器4开始时间：分
			bodyBytes[38] = bit.bor(
				bit.bor(myTable["forceHeatTimer5En"], myTable["forceHeatTimer5Valid"]),
				myTable["forceHeatTimer5Effect"]
			) -- 强热定时器5开关、是否有效、是否有用
			bodyBytes[39] = myTable["forceHeatTimer5StartTimeHour"] -- 强热定时器5开始时间：时
			bodyBytes[40] = myTable["forceHeatTimer5StartTimeMin"] -- 强热定时器5开始时间：分
			bodyBytes[41] = bit.bor(
				bit.bor(myTable["forceHeatTimer6En"], myTable["forceHeatTimer6Valid"]),
				myTable["forceHeatTimer6Effect"]
			) -- 强热定时器6开关、是否有效、是否有用
			bodyBytes[42] = myTable["forceHeatTimer6StartTimeHour"] -- 强热定时器6开始时间：时
			bodyBytes[43] = myTable["forceHeatTimer6StartTimeMin"] -- 强热定时器6开始时间：分

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x04 then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			-- 周日定时1~6是否生效
			bodyBytes[2] = bit.bor(
				bit.band(myTable["week0timer1Effect"], 0x01),
				bit.bor(
					bit.band(myTable["week0timer2Effect"], 0x02),
					bit.bor(
						bit.band(myTable["week0timer3Effect"], 0x04),
						bit.bor(
							bit.band(myTable["week0timer4Effect"], 0x08),
							bit.bor(
								bit.band(myTable["week0timer5Effect"], 0x10),
								bit.band(myTable["week0timer6Effect"], 0x20)
							)
						)
					)
				)
			)

			-- 周日定时器1设定模式、静音开关、强热开关、静音等级
			bodyBytes[3] = bit.bor(
				myTable["week0timer1SetMode"],
				bit.bor(
					bit.lshift(myTable["week0timer1MutSet"], 4),
					bit.bor(bit.lshift(myTable["week0timer1FrcHeSet"], 5), bit.lshift(myTable["week0timer1MutLev"], 6))
				)
			)

			bodyBytes[4] = myTable["week0timer1SetTemp"] -- 周日定时器1设定温度
			bodyBytes[5] = myTable["week0timer1OpenTimeHour"] -- 周日定时器1开始时间：时
			bodyBytes[6] = myTable["week0timer1OpenTimeMin"] -- 周日定时器1开始时间：分
			bodyBytes[7] = myTable["week0timer1CloseTimeHour"] -- 周日定时器1结束时间：时
			bodyBytes[8] = myTable["week0timer1CloseTimeMin"] -- 周日定时器1结束时间：分

			-- 周日定时器2设定模式、静音开关、强热开关、静音等级
			bodyBytes[9] = bit.bor(
				myTable["week0timer2SetMode"],
				bit.bor(
					bit.lshift(myTable["week0timer2MutSet"], 4),
					bit.bor(bit.lshift(myTable["week0timer2FrcHeSet"], 5), bit.lshift(myTable["week0timer2MutLev"], 6))
				)
			)

			bodyBytes[10] = myTable["week0timer2SetTemp"] -- 周日定时器2设定温度
			bodyBytes[11] = myTable["week0timer2OpenTimeHour"] -- 周日定时器2开始时间：时
			bodyBytes[12] = myTable["week0timer2OpenTimeMin"] -- 周日定时器2开始时间：分
			bodyBytes[13] = myTable["week0timer2CloseTimeHour"] -- 周日定时器2结束时间：时
			bodyBytes[14] = myTable["week0timer2CloseTimeMin"] -- 周日定时器2结束时间：分

			-- 周日定时器3设定模式、静音开关、强热开关、静音等级
			bodyBytes[15] = bit.bor(
				myTable["week0timer3SetMode"],
				bit.bor(
					bit.lshift(myTable["week0timer3MutSet"], 4),
					bit.bor(bit.lshift(myTable["week0timer3FrcHeSet"], 5), bit.lshift(myTable["week0timer3MutLev"], 6))
				)
			)

			bodyBytes[16] = myTable["week0timer3SetTemp"] -- 周日定时器3设定温度
			bodyBytes[17] = myTable["week0timer3OpenTimeHour"] -- 周日定时器3开始时间：时
			bodyBytes[18] = myTable["week0timer3OpenTimeMin"] -- 周日定时器3开始时间：分
			bodyBytes[19] = myTable["week0timer3CloseTimeHour"] -- 周日定时器3结束时间：时
			bodyBytes[20] = myTable["week0timer3CloseTimeMin"] -- 周日定时器3结束时间：分

			-- 周日定时器4设定模式、静音开关、强热开关、静音等级
			bodyBytes[21] = bit.bor(
				myTable["week0timer4SetMode"],
				bit.bor(
					bit.lshift(myTable["week0timer4MutSet"], 4),
					bit.bor(bit.lshift(myTable["week0timer4FrcHeSet"], 5), bit.lshift(myTable["week0timer4MutLev"], 6))
				)
			)

			bodyBytes[22] = myTable["week0timer4SetTemp"] -- 周日定时器4设定温度
			bodyBytes[23] = myTable["week0timer4OpenTimeHour"] -- 周日定时器4开始时间：时
			bodyBytes[24] = myTable["week0timer4OpenTimeMin"] -- 周日定时器4开始时间：分
			bodyBytes[25] = myTable["week0timer4CloseTimeHour"] -- 周日定时器4结束时间：时
			bodyBytes[26] = myTable["week0timer4CloseTimeMin"] -- 周日定时器4结束时间：分

			-- 周日定时器5设定模式、静音开关、强热开关、静音等级
			bodyBytes[27] = bit.bor(
				myTable["week0timer5SetMode"],
				bit.bor(
					bit.lshift(myTable["week0timer5MutSet"], 4),
					bit.bor(bit.lshift(myTable["week0timer5FrcHeSet"], 5), bit.lshift(myTable["week0timer5MutLev"], 6))
				)
			)

			bodyBytes[28] = myTable["week0timer5SetTemp"] -- 周日定时器5设定温度
			bodyBytes[29] = myTable["week0timer5OpenTimeHour"] -- 周日定时器5开始时间：时
			bodyBytes[30] = myTable["week0timer5OpenTimeMin"] -- 周日定时器5开始时间：分
			bodyBytes[31] = myTable["week0timer5CloseTimeHour"] -- 周日定时器5结束时间：时
			bodyBytes[32] = myTable["week0timer5CloseTimeMin"] -- 周日定时器5结束时间：分

			-- 周日定时器6设定模式、静音开关、强热开关、静音等级
			bodyBytes[33] = bit.bor(
				myTable["week0timer6SetMode"],
				bit.bor(
					bit.lshift(myTable["week0timer6MutSet"], 4),
					bit.bor(bit.lshift(myTable["week0timer6FrcHeSet"], 5), bit.lshift(myTable["week0timer6MutLev"], 6))
				)
			)

			bodyBytes[34] = myTable["week0timer6SetTemp"] -- 周日定时器6设定温度
			bodyBytes[35] = myTable["week0timer6OpenTimeHour"] -- 周日定时器6开始时间：时
			bodyBytes[36] = myTable["week0timer6OpenTimeMin"] -- 周日定时器6开始时间：分
			bodyBytes[37] = myTable["week0timer6CloseTimeHour"] -- 周日定时器6结束时间：时
			bodyBytes[38] = myTable["week0timer6CloseTimeMin"] -- 周日定时器6结束时间：分

			-- 周日定时器1~6是否有效
			bodyBytes[39] = bit.bor(
				myTable["week0timer1Valid"],
				bit.bor(
					myTable["week0timer2Valid"],
					bit.bor(
						myTable["week0timer3Valid"],
						bit.bor(
							myTable["week0timer4Valid"],
							bit.bor(myTable["week0timer5Valid"], myTable["week0timer6Valid"])
						)
					)
				)
			)

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x05 then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			-- 周一定时1~6是否生效
			bodyBytes[2] = bit.bor(
				bit.band(myTable["week1timer1Effect"], 0x01),
				bit.bor(
					bit.band(myTable["week1timer2Effect"], 0x02),
					bit.bor(
						bit.band(myTable["week1timer3Effect"], 0x04),
						bit.bor(
							bit.band(myTable["week1timer4Effect"], 0x08),
							bit.bor(
								bit.band(myTable["week1timer5Effect"], 0x10),
								bit.band(myTable["week1timer6Effect"], 0x20)
							)
						)
					)
				)
			)

			-- 周一定时器1设定模式、静音开关、强热开关、静音等级
			bodyBytes[3] = bit.bor(
				myTable["week1timer1SetMode"],
				bit.bor(
					bit.lshift(myTable["week1timer1MutSet"], 4),
					bit.bor(bit.lshift(myTable["week1timer1FrcHeSet"], 5), bit.lshift(myTable["week1timer1MutLev"], 6))
				)
			)

			bodyBytes[4] = myTable["week1timer1SetTemp"] -- 周一定时器1设定温度
			bodyBytes[5] = myTable["week1timer1OpenTimeHour"] -- 周一定时器1开始时间：时
			bodyBytes[6] = myTable["week1timer1OpenTimeMin"] -- 周一定时器1开始时间：分
			bodyBytes[7] = myTable["week1timer1CloseTimeHour"] -- 周一定时器1结束时间：时
			bodyBytes[8] = myTable["week1timer1CloseTimeMin"] -- 周一定时器1结束时间：分

			-- 周一定时器2设定模式、静音开关、强热开关、静音等级
			bodyBytes[9] = bit.bor(
				myTable["week1timer2SetMode"],
				bit.bor(
					bit.lshift(myTable["week1timer2MutSet"], 4),
					bit.bor(bit.lshift(myTable["week1timer2FrcHeSet"], 5), bit.lshift(myTable["week1timer2MutLev"], 6))
				)
			)

			bodyBytes[10] = myTable["week1timer2SetTemp"] -- 周一定时器2设定温度
			bodyBytes[11] = myTable["week1timer2OpenTimeHour"] -- 周一定时器2开始时间：时
			bodyBytes[12] = myTable["week1timer2OpenTimeMin"] -- 周一定时器2开始时间：分
			bodyBytes[13] = myTable["week1timer2CloseTimeHour"] -- 周一定时器2结束时间：时
			bodyBytes[14] = myTable["week1timer2CloseTimeMin"] -- 周一定时器2结束时间：分

			-- 周一定时器3设定模式、静音开关、强热开关、静音等级
			bodyBytes[15] = bit.bor(
				myTable["week1timer3SetMode"],
				bit.bor(
					bit.lshift(myTable["week1timer3MutSet"], 4),
					bit.bor(bit.lshift(myTable["week1timer3FrcHeSet"], 5), bit.lshift(myTable["week1timer3MutLev"], 6))
				)
			)

			bodyBytes[16] = myTable["week1timer3SetTemp"] -- 周一定时器3设定温度
			bodyBytes[17] = myTable["week1timer3OpenTimeHour"] -- 周一定时器3开始时间：时
			bodyBytes[18] = myTable["week1timer3OpenTimeMin"] -- 周一定时器3开始时间：分
			bodyBytes[19] = myTable["week1timer3CloseTimeHour"] -- 周一定时器3结束时间：时
			bodyBytes[20] = myTable["week1timer3CloseTimeMin"] -- 周一定时器3结束时间：分

			-- 周一定时器4设定模式、静音开关、强热开关、静音等级
			bodyBytes[21] = bit.bor(
				myTable["week1timer4SetMode"],
				bit.bor(
					bit.lshift(myTable["week1timer4MutSet"], 4),
					bit.bor(bit.lshift(myTable["week1timer4FrcHeSet"], 5), bit.lshift(myTable["week1timer4MutLev"], 6))
				)
			)

			bodyBytes[22] = myTable["week1timer4SetTemp"] -- 周一定时器4设定温度
			bodyBytes[23] = myTable["week1timer4OpenTimeHour"] -- 周一定时器4开始时间：时
			bodyBytes[24] = myTable["week1timer4OpenTimeMin"] -- 周一定时器4开始时间：分
			bodyBytes[25] = myTable["week1timer4CloseTimeHour"] -- 周一定时器4结束时间：时
			bodyBytes[26] = myTable["week1timer4CloseTimeMin"] -- 周一定时器4结束时间：分

			-- 周一定时器5设定模式、静音开关、强热开关、静音等级
			bodyBytes[27] = bit.bor(
				myTable["week1timer5SetMode"],
				bit.bor(
					bit.lshift(myTable["week1timer5MutSet"], 4),
					bit.bor(bit.lshift(myTable["week1timer5FrcHeSet"], 5), bit.lshift(myTable["week1timer5MutLev"], 6))
				)
			)

			bodyBytes[28] = myTable["week1timer5SetTemp"] -- 周一定时器5设定温度
			bodyBytes[29] = myTable["week1timer5OpenTimeHour"] -- 周一定时器5开始时间：时
			bodyBytes[30] = myTable["week1timer5OpenTimeMin"] -- 周一定时器5开始时间：分
			bodyBytes[31] = myTable["week1timer5CloseTimeHour"] -- 周一定时器5结束时间：时
			bodyBytes[32] = myTable["week1timer5CloseTimeMin"] -- 周一定时器5结束时间：分

			-- 周一定时器6设定模式、静音开关、强热开关、静音等级
			bodyBytes[33] = bit.bor(
				myTable["week1timer6SetMode"],
				bit.bor(
					bit.lshift(myTable["week1timer6MutSet"], 4),
					bit.bor(bit.lshift(myTable["week1timer6FrcHeSet"], 5), bit.lshift(myTable["week1timer6MutLev"], 6))
				)
			)

			bodyBytes[34] = myTable["week1timer6SetTemp"] -- 周一定时器6设定温度
			bodyBytes[35] = myTable["week1timer6OpenTimeHour"] -- 周一定时器6开始时间：时
			bodyBytes[36] = myTable["week1timer6OpenTimeMin"] -- 周一定时器6开始时间：分
			bodyBytes[37] = myTable["week1timer6CloseTimeHour"] -- 周一定时器6结束时间：时
			bodyBytes[38] = myTable["week1timer6CloseTimeMin"] -- 周一定时器6结束时间：分

			-- 周一定时器1~6是否有效
			bodyBytes[39] = bit.bor(
				myTable["week1timer1Valid"],
				bit.bor(
					myTable["week1timer2Valid"],
					bit.bor(
						myTable["week1timer3Valid"],
						bit.bor(
							myTable["week1timer4Valid"],
							bit.bor(myTable["week1timer5Valid"], myTable["week1timer6Valid"])
						)
					)
				)
			)

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x06 then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			-- 周二定时1~6是否生效
			bodyBytes[2] = bit.bor(
				bit.band(myTable["week2timer1Effect"], 0x01),
				bit.bor(
					bit.band(myTable["week2timer2Effect"], 0x02),
					bit.bor(
						bit.band(myTable["week2timer3Effect"], 0x04),
						bit.bor(
							bit.band(myTable["week2timer4Effect"], 0x08),
							bit.bor(
								bit.band(myTable["week2timer5Effect"], 0x10),
								bit.band(myTable["week2timer6Effect"], 0x20)
							)
						)
					)
				)
			)

			-- 周二定时器1设定模式、静音开关、强热开关、静音等级
			bodyBytes[3] = bit.bor(
				myTable["week2timer1SetMode"],
				bit.bor(
					bit.lshift(myTable["week2timer1MutSet"], 4),
					bit.bor(bit.lshift(myTable["week2timer1FrcHeSet"], 5), bit.lshift(myTable["week2timer1MutLev"], 6))
				)
			)

			bodyBytes[4] = myTable["week2timer1SetTemp"] -- 周二定时器1设定温度
			bodyBytes[5] = myTable["week2timer1OpenTimeHour"] -- 周二定时器1开始时间：时
			bodyBytes[6] = myTable["week2timer1OpenTimeMin"] -- 周二定时器1开始时间：分
			bodyBytes[7] = myTable["week2timer1CloseTimeHour"] -- 周二定时器1结束时间：时
			bodyBytes[8] = myTable["week2timer1CloseTimeMin"] -- 周二定时器1结束时间：分

			-- 周二定时器2设定模式、静音开关、强热开关、静音等级
			bodyBytes[9] = bit.bor(
				myTable["week2timer2SetMode"],
				bit.bor(
					bit.lshift(myTable["week2timer2MutSet"], 4),
					bit.bor(bit.lshift(myTable["week2timer2FrcHeSet"], 5), bit.lshift(myTable["week2timer2MutLev"], 6))
				)
			)

			bodyBytes[10] = myTable["week2timer2SetTemp"] -- 周二定时器2设定温度
			bodyBytes[11] = myTable["week2timer2OpenTimeHour"] -- 周二定时器2开始时间：时
			bodyBytes[12] = myTable["week2timer2OpenTimeMin"] -- 周二定时器2开始时间：分
			bodyBytes[13] = myTable["week2timer2CloseTimeHour"] -- 周二定时器2结束时间：时
			bodyBytes[14] = myTable["week2timer2CloseTimeMin"] -- 周二定时器2结束时间：分

			-- 周二定时器3设定模式、静音开关、强热开关、静音等级
			bodyBytes[15] = bit.bor(
				myTable["week2timer3SetMode"],
				bit.bor(
					bit.lshift(myTable["week2timer3MutSet"], 4),
					bit.bor(bit.lshift(myTable["week2timer3FrcHeSet"], 5), bit.lshift(myTable["week2timer3MutLev"], 6))
				)
			)

			bodyBytes[16] = myTable["week2timer3SetTemp"] -- 周二定时器3设定温度
			bodyBytes[17] = myTable["week2timer3OpenTimeHour"] -- 周二定时器3开始时间：时
			bodyBytes[18] = myTable["week2timer3OpenTimeMin"] -- 周二定时器3开始时间：分
			bodyBytes[19] = myTable["week2timer3CloseTimeHour"] -- 周二定时器3结束时间：时
			bodyBytes[20] = myTable["week2timer3CloseTimeMin"] -- 周二定时器3结束时间：分

			-- 周二定时器4设定模式、静音开关、强热开关、静音等级
			bodyBytes[21] = bit.bor(
				myTable["week2timer4SetMode"],
				bit.bor(
					bit.lshift(myTable["week2timer4MutSet"], 4),
					bit.bor(bit.lshift(myTable["week2timer4FrcHeSet"], 5), bit.lshift(myTable["week2timer4MutLev"], 6))
				)
			)

			bodyBytes[22] = myTable["week2timer4SetTemp"] -- 周二定时器4设定温度
			bodyBytes[23] = myTable["week2timer4OpenTimeHour"] -- 周二定时器4开始时间：时
			bodyBytes[24] = myTable["week2timer4OpenTimeMin"] -- 周二定时器4开始时间：分
			bodyBytes[25] = myTable["week2timer4CloseTimeHour"] -- 周二定时器4结束时间：时
			bodyBytes[26] = myTable["week2timer4CloseTimeMin"] -- 周二定时器4结束时间：分

			-- 周二定时器5设定模式、静音开关、强热开关、静音等级
			bodyBytes[27] = bit.bor(
				myTable["week2timer5SetMode"],
				bit.bor(
					bit.lshift(myTable["week2timer5MutSet"], 4),
					bit.bor(bit.lshift(myTable["week2timer5FrcHeSet"], 5), bit.lshift(myTable["week2timer5MutLev"], 6))
				)
			)

			bodyBytes[28] = myTable["week2timer5SetTemp"] -- 周二定时器5设定温度
			bodyBytes[29] = myTable["week2timer5OpenTimeHour"] -- 周二定时器5开始时间：时
			bodyBytes[30] = myTable["week2timer5OpenTimeMin"] -- 周二定时器5开始时间：分
			bodyBytes[31] = myTable["week2timer5CloseTimeHour"] -- 周二定时器5结束时间：时
			bodyBytes[32] = myTable["week2timer5CloseTimeMin"] -- 周二定时器5结束时间：分

			-- 周二定时器6设定模式、静音开关、强热开关、静音等级
			bodyBytes[33] = bit.bor(
				myTable["week2timer6SetMode"],
				bit.bor(
					bit.lshift(myTable["week2timer6MutSet"], 4),
					bit.bor(bit.lshift(myTable["week2timer6FrcHeSet"], 5), bit.lshift(myTable["week2timer6MutLev"], 6))
				)
			)

			bodyBytes[34] = myTable["week2timer6SetTemp"] -- 周二定时器6设定温度
			bodyBytes[35] = myTable["week2timer6OpenTimeHour"] -- 周二定时器6开始时间：时
			bodyBytes[36] = myTable["week2timer6OpenTimeMin"] -- 周二定时器6开始时间：分
			bodyBytes[37] = myTable["week2timer6CloseTimeHour"] -- 周二定时器6结束时间：时
			bodyBytes[38] = myTable["week2timer6CloseTimeMin"] -- 周二定时器6结束时间：分

			-- 周二定时器1~6是否有效
			bodyBytes[39] = bit.bor(
				myTable["week2timer1Valid"],
				bit.bor(
					myTable["week2timer2Valid"],
					bit.bor(
						myTable["week2timer3Valid"],
						bit.bor(
							myTable["week2timer4Valid"],
							bit.bor(myTable["week2timer5Valid"], myTable["week2timer6Valid"])
						)
					)
				)
			)

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x07 then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			-- 周三定时1~6是否生效
			bodyBytes[2] = bit.bor(
				bit.band(myTable["week3timer1Effect"], 0x01),
				bit.bor(
					bit.band(myTable["week3timer2Effect"], 0x02),
					bit.bor(
						bit.band(myTable["week3timer3Effect"], 0x04),
						bit.bor(
							bit.band(myTable["week3timer4Effect"], 0x08),
							bit.bor(
								bit.band(myTable["week3timer5Effect"], 0x10),
								bit.band(myTable["week3timer6Effect"], 0x20)
							)
						)
					)
				)
			)

			-- 周三定时器1设定模式、静音开关、强热开关、静音等级
			bodyBytes[3] = bit.bor(
				myTable["week3timer1SetMode"],
				bit.bor(
					bit.lshift(myTable["week3timer1MutSet"], 4),
					bit.bor(bit.lshift(myTable["week3timer1FrcHeSet"], 5), bit.lshift(myTable["week3timer1MutLev"], 6))
				)
			)

			bodyBytes[4] = myTable["week3timer1SetTemp"] -- 周三定时器1设定温度
			bodyBytes[5] = myTable["week3timer1OpenTimeHour"] -- 周三定时器1开始时间：时
			bodyBytes[6] = myTable["week3timer1OpenTimeMin"] -- 周三定时器1开始时间：分
			bodyBytes[7] = myTable["week3timer1CloseTimeHour"] -- 周三定时器1结束时间：时
			bodyBytes[8] = myTable["week3timer1CloseTimeMin"] -- 周三定时器1结束时间：分

			-- 周三定时器2设定模式、静音开关、强热开关、静音等级
			bodyBytes[9] = bit.bor(
				myTable["week3timer2SetMode"],
				bit.bor(
					bit.lshift(myTable["week3timer2MutSet"], 4),
					bit.bor(bit.lshift(myTable["week3timer2FrcHeSet"], 5), bit.lshift(myTable["week3timer2MutLev"], 6))
				)
			)

			bodyBytes[10] = myTable["week3timer2SetTemp"] -- 周三定时器2设定温度
			bodyBytes[11] = myTable["week3timer2OpenTimeHour"] -- 周三定时器2开始时间：时
			bodyBytes[12] = myTable["week3timer2OpenTimeMin"] -- 周三定时器2开始时间：分
			bodyBytes[13] = myTable["week3timer2CloseTimeHour"] -- 周三定时器2结束时间：时
			bodyBytes[14] = myTable["week3timer2CloseTimeMin"] -- 周三定时器2结束时间：分

			-- 周三定时器3设定模式、静音开关、强热开关、静音等级
			bodyBytes[15] = bit.bor(
				myTable["week3timer3SetMode"],
				bit.bor(
					bit.lshift(myTable["week3timer3MutSet"], 4),
					bit.bor(bit.lshift(myTable["week3timer3FrcHeSet"], 5), bit.lshift(myTable["week3timer3MutLev"], 6))
				)
			)

			bodyBytes[16] = myTable["week3timer3SetTemp"] -- 周三定时器3设定温度
			bodyBytes[17] = myTable["week3timer3OpenTimeHour"] -- 周三定时器3开始时间：时
			bodyBytes[18] = myTable["week3timer3OpenTimeMin"] -- 周三定时器3开始时间：分
			bodyBytes[19] = myTable["week3timer3CloseTimeHour"] -- 周三定时器3结束时间：时
			bodyBytes[20] = myTable["week3timer3CloseTimeMin"] -- 周三定时器3结束时间：分

			-- 周三定时器4设定模式、静音开关、强热开关、静音等级
			bodyBytes[21] = bit.bor(
				myTable["week3timer4SetMode"],
				bit.bor(
					bit.lshift(myTable["week3timer4MutSet"], 4),
					bit.bor(bit.lshift(myTable["week3timer4FrcHeSet"], 5), bit.lshift(myTable["week3timer4MutLev"], 6))
				)
			)

			bodyBytes[22] = myTable["week3timer4SetTemp"] -- 周三定时器4设定温度
			bodyBytes[23] = myTable["week3timer4OpenTimeHour"] -- 周三定时器4开始时间：时
			bodyBytes[24] = myTable["week3timer4OpenTimeMin"] -- 周三定时器4开始时间：分
			bodyBytes[25] = myTable["week3timer4CloseTimeHour"] -- 周三定时器4结束时间：时
			bodyBytes[26] = myTable["week3timer4CloseTimeMin"] -- 周三定时器4结束时间：分

			-- 周三定时器5设定模式、静音开关、强热开关、静音等级
			bodyBytes[27] = bit.bor(
				myTable["week3timer5SetMode"],
				bit.bor(
					bit.lshift(myTable["week3timer5MutSet"], 4),
					bit.bor(bit.lshift(myTable["week3timer5FrcHeSet"], 5), bit.lshift(myTable["week3timer5MutLev"], 6))
				)
			)

			bodyBytes[28] = myTable["week3timer5SetTemp"] -- 周三定时器5设定温度
			bodyBytes[29] = myTable["week3timer5OpenTimeHour"] -- 周三定时器5开始时间：时
			bodyBytes[30] = myTable["week3timer5OpenTimeMin"] -- 周三定时器5开始时间：分
			bodyBytes[31] = myTable["week3timer5CloseTimeHour"] -- 周三定时器5结束时间：时
			bodyBytes[32] = myTable["week3timer5CloseTimeMin"] -- 周三定时器5结束时间：分

			-- 周三定时器6设定模式、静音开关、强热开关、静音等级
			bodyBytes[33] = bit.bor(
				myTable["week3timer6SetMode"],
				bit.bor(
					bit.lshift(myTable["week3timer6MutSet"], 4),
					bit.bor(bit.lshift(myTable["week3timer6FrcHeSet"], 5), bit.lshift(myTable["week3timer6MutLev"], 6))
				)
			)

			bodyBytes[34] = myTable["week3timer6SetTemp"] -- 周三定时器6设定温度
			bodyBytes[35] = myTable["week3timer6OpenTimeHour"] -- 周三定时器6开始时间：时
			bodyBytes[36] = myTable["week3timer6OpenTimeMin"] -- 周三定时器6开始时间：分
			bodyBytes[37] = myTable["week3timer6CloseTimeHour"] -- 周三定时器6结束时间：时
			bodyBytes[38] = myTable["week3timer6CloseTimeMin"] -- 周三定时器6结束时间：分

			-- 周三定时器1~6是否有效
			bodyBytes[39] = bit.bor(
				myTable["week3timer1Valid"],
				bit.bor(
					myTable["week3timer2Valid"],
					bit.bor(
						myTable["week3timer3Valid"],
						bit.bor(
							myTable["week3timer4Valid"],
							bit.bor(myTable["week3timer5Valid"], myTable["week3timer6Valid"])
						)
					)
				)
			)

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x08 then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			-- 周四定时1~6是否生效
			bodyBytes[2] = bit.bor(
				bit.band(myTable["week4timer1Effect"], 0x01),
				bit.bor(
					bit.band(myTable["week4timer2Effect"], 0x02),
					bit.bor(
						bit.band(myTable["week4timer3Effect"], 0x04),
						bit.bor(
							bit.band(myTable["week4timer4Effect"], 0x08),
							bit.bor(
								bit.band(myTable["week4timer5Effect"], 0x10),
								bit.band(myTable["week4timer6Effect"], 0x20)
							)
						)
					)
				)
			)

			-- 周四定时器1设定模式、静音开关、强热开关、静音等级
			bodyBytes[3] = bit.bor(
				myTable["week4timer1SetMode"],
				bit.bor(
					bit.lshift(myTable["week4timer1MutSet"], 4),
					bit.bor(bit.lshift(myTable["week4timer1FrcHeSet"], 5), bit.lshift(myTable["week4timer1MutLev"], 6))
				)
			)

			bodyBytes[4] = myTable["week4timer1SetTemp"] -- 周四定时器1设定温度
			bodyBytes[5] = myTable["week4timer1OpenTimeHour"] -- 周四定时器1开始时间：时
			bodyBytes[6] = myTable["week4timer1OpenTimeMin"] -- 周四定时器1开始时间：分
			bodyBytes[7] = myTable["week4timer1CloseTimeHour"] -- 周四定时器1结束时间：时
			bodyBytes[8] = myTable["week4timer1CloseTimeMin"] -- 周四定时器1结束时间：分

			-- 周四定时器2设定模式、静音开关、强热开关、静音等级
			bodyBytes[9] = bit.bor(
				myTable["week4timer2SetMode"],
				bit.bor(
					bit.lshift(myTable["week4timer2MutSet"], 4),
					bit.bor(bit.lshift(myTable["week4timer2FrcHeSet"], 5), bit.lshift(myTable["week4timer2MutLev"], 6))
				)
			)

			bodyBytes[10] = myTable["week4timer2SetTemp"] -- 周四定时器2设定温度
			bodyBytes[11] = myTable["week4timer2OpenTimeHour"] -- 周四定时器2开始时间：时
			bodyBytes[12] = myTable["week4timer2OpenTimeMin"] -- 周四定时器2开始时间：分
			bodyBytes[13] = myTable["week4timer2CloseTimeHour"] -- 周四定时器2结束时间：时
			bodyBytes[14] = myTable["week4timer2CloseTimeMin"] -- 周四定时器2结束时间：分

			-- 周四定时器3设定模式、静音开关、强热开关、静音等级
			bodyBytes[15] = bit.bor(
				myTable["week4timer3SetMode"],
				bit.bor(
					bit.lshift(myTable["week4timer3MutSet"], 4),
					bit.bor(bit.lshift(myTable["week4timer3FrcHeSet"], 5), bit.lshift(myTable["week4timer3MutLev"], 6))
				)
			)

			bodyBytes[16] = myTable["week4timer3SetTemp"] -- 周四定时器3设定温度
			bodyBytes[17] = myTable["week4timer3OpenTimeHour"] -- 周四定时器3开始时间：时
			bodyBytes[18] = myTable["week4timer3OpenTimeMin"] -- 周四定时器3开始时间：分
			bodyBytes[19] = myTable["week4timer3CloseTimeHour"] -- 周四定时器3结束时间：时
			bodyBytes[20] = myTable["week4timer3CloseTimeMin"] -- 周四定时器3结束时间：分

			-- 周四定时器4设定模式、静音开关、强热开关、静音等级
			bodyBytes[21] = bit.bor(
				myTable["week4timer4SetMode"],
				bit.bor(
					bit.lshift(myTable["week4timer4MutSet"], 4),
					bit.bor(bit.lshift(myTable["week4timer4FrcHeSet"], 5), bit.lshift(myTable["week4timer4MutLev"], 6))
				)
			)

			bodyBytes[22] = myTable["week4timer4SetTemp"] -- 周四定时器4设定温度
			bodyBytes[23] = myTable["week4timer4OpenTimeHour"] -- 周四定时器4开始时间：时
			bodyBytes[24] = myTable["week4timer4OpenTimeMin"] -- 周四定时器4开始时间：分
			bodyBytes[25] = myTable["week4timer4CloseTimeHour"] -- 周四定时器4结束时间：时
			bodyBytes[26] = myTable["week4timer4CloseTimeMin"] -- 周四定时器4结束时间：分

			-- 周四定时器5设定模式、静音开关、强热开关、静音等级
			bodyBytes[27] = bit.bor(
				myTable["week4timer5SetMode"],
				bit.bor(
					bit.lshift(myTable["week4timer5MutSet"], 4),
					bit.bor(bit.lshift(myTable["week4timer5FrcHeSet"], 5), bit.lshift(myTable["week4timer5MutLev"], 6))
				)
			)

			bodyBytes[28] = myTable["week4timer5SetTemp"] -- 周四定时器5设定温度
			bodyBytes[29] = myTable["week4timer5OpenTimeHour"] -- 周四定时器5开始时间：时
			bodyBytes[30] = myTable["week4timer5OpenTimeMin"] -- 周四定时器5开始时间：分
			bodyBytes[31] = myTable["week4timer5CloseTimeHour"] -- 周四定时器5结束时间：时
			bodyBytes[32] = myTable["week4timer5CloseTimeMin"] -- 周四定时器5结束时间：分

			-- 周四定时器6设定模式、静音开关、强热开关、静音等级
			bodyBytes[33] = bit.bor(
				myTable["week4timer6SetMode"],
				bit.bor(
					bit.lshift(myTable["week4timer6MutSet"], 4),
					bit.bor(bit.lshift(myTable["week4timer6FrcHeSet"], 5), bit.lshift(myTable["week4timer6MutLev"], 6))
				)
			)

			bodyBytes[34] = myTable["week4timer6SetTemp"] -- 周四定时器6设定温度
			bodyBytes[35] = myTable["week4timer6OpenTimeHour"] -- 周四定时器6开始时间：时
			bodyBytes[36] = myTable["week4timer6OpenTimeMin"] -- 周四定时器6开始时间：分
			bodyBytes[37] = myTable["week4timer6CloseTimeHour"] -- 周四定时器6结束时间：时
			bodyBytes[38] = myTable["week4timer6CloseTimeMin"] -- 周四定时器6结束时间：分

			-- 周四定时器1~6是否有效
			bodyBytes[39] = bit.bor(
				myTable["week4timer1Valid"],
				bit.bor(
					myTable["week4timer2Valid"],
					bit.bor(
						myTable["week4timer3Valid"],
						bit.bor(
							myTable["week4timer4Valid"],
							bit.bor(myTable["week4timer5Valid"], myTable["week4timer6Valid"])
						)
					)
				)
			)

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x09 then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			-- 周五定时1~6是否生效
			bodyBytes[2] = bit.bor(
				bit.band(myTable["week5timer1Effect"], 0x01),
				bit.bor(
					bit.band(myTable["week5timer2Effect"], 0x02),
					bit.bor(
						bit.band(myTable["week5timer3Effect"], 0x04),
						bit.bor(
							bit.band(myTable["week5timer4Effect"], 0x08),
							bit.bor(
								bit.band(myTable["week5timer5Effect"], 0x10),
								bit.band(myTable["week5timer6Effect"], 0x20)
							)
						)
					)
				)
			)

			-- 周五定时器1设定模式、静音开关、强热开关、静音等级
			bodyBytes[3] = bit.bor(
				myTable["week5timer1SetMode"],
				bit.bor(
					bit.lshift(myTable["week5timer1MutSet"], 4),
					bit.bor(bit.lshift(myTable["week5timer1FrcHeSet"], 5), bit.lshift(myTable["week5timer1MutLev"], 6))
				)
			)

			bodyBytes[4] = myTable["week5timer1SetTemp"] -- 周五定时器1设定温度
			bodyBytes[5] = myTable["week5timer1OpenTimeHour"] -- 周五定时器1开始时间：时
			bodyBytes[6] = myTable["week5timer1OpenTimeMin"] -- 周五定时器1开始时间：分
			bodyBytes[7] = myTable["week5timer1CloseTimeHour"] -- 周五定时器1结束时间：时
			bodyBytes[8] = myTable["week5timer1CloseTimeMin"] -- 周五定时器1结束时间：分

			-- 周五定时器2设定模式、静音开关、强热开关、静音等级
			bodyBytes[9] = bit.bor(
				myTable["week5timer2SetMode"],
				bit.bor(
					bit.lshift(myTable["week5timer2MutSet"], 4),
					bit.bor(bit.lshift(myTable["week5timer2FrcHeSet"], 5), bit.lshift(myTable["week5timer2MutLev"], 6))
				)
			)

			bodyBytes[10] = myTable["week5timer2SetTemp"] -- 周五定时器2设定温度
			bodyBytes[11] = myTable["week5timer2OpenTimeHour"] -- 周五定时器2开始时间：时
			bodyBytes[12] = myTable["week5timer2OpenTimeMin"] -- 周五定时器2开始时间：分
			bodyBytes[13] = myTable["week5timer2CloseTimeHour"] -- 周五定时器2结束时间：时
			bodyBytes[14] = myTable["week5timer2CloseTimeMin"] -- 周五定时器2结束时间：分

			-- 周五定时器3设定模式、静音开关、强热开关、静音等级
			bodyBytes[15] = bit.bor(
				myTable["week5timer3SetMode"],
				bit.bor(
					bit.lshift(myTable["week5timer3MutSet"], 4),
					bit.bor(bit.lshift(myTable["week5timer3FrcHeSet"], 5), bit.lshift(myTable["week5timer3MutLev"], 6))
				)
			)

			bodyBytes[16] = myTable["week5timer3SetTemp"] -- 周五定时器3设定温度
			bodyBytes[17] = myTable["week5timer3OpenTimeHour"] -- 周五定时器3开始时间：时
			bodyBytes[18] = myTable["week5timer3OpenTimeMin"] -- 周五定时器3开始时间：分
			bodyBytes[19] = myTable["week5timer3CloseTimeHour"] -- 周五定时器3结束时间：时
			bodyBytes[20] = myTable["week5timer3CloseTimeMin"] -- 周五定时器3结束时间：分

			-- 周五定时器4设定模式、静音开关、强热开关、静音等级
			bodyBytes[21] = bit.bor(
				myTable["week5timer4SetMode"],
				bit.bor(
					bit.lshift(myTable["week5timer4MutSet"], 4),
					bit.bor(bit.lshift(myTable["week5timer4FrcHeSet"], 5), bit.lshift(myTable["week5timer4MutLev"], 6))
				)
			)

			bodyBytes[22] = myTable["week5timer4SetTemp"] -- 周五定时器4设定温度
			bodyBytes[23] = myTable["week5timer4OpenTimeHour"] -- 周五定时器4开始时间：时
			bodyBytes[24] = myTable["week5timer4OpenTimeMin"] -- 周五定时器4开始时间：分
			bodyBytes[25] = myTable["week5timer4CloseTimeHour"] -- 周五定时器4结束时间：时
			bodyBytes[26] = myTable["week5timer4CloseTimeMin"] -- 周五定时器4结束时间：分

			-- 周五定时器5设定模式、静音开关、强热开关、静音等级
			bodyBytes[27] = bit.bor(
				myTable["week5timer5SetMode"],
				bit.bor(
					bit.lshift(myTable["week5timer5MutSet"], 4),
					bit.bor(bit.lshift(myTable["week5timer5FrcHeSet"], 5), bit.lshift(myTable["week5timer5MutLev"], 6))
				)
			)

			bodyBytes[28] = myTable["week5timer5SetTemp"] -- 周五定时器5设定温度
			bodyBytes[29] = myTable["week5timer5OpenTimeHour"] -- 周五定时器5开始时间：时
			bodyBytes[30] = myTable["week5timer5OpenTimeMin"] -- 周五定时器5开始时间：分
			bodyBytes[31] = myTable["week5timer5CloseTimeHour"] -- 周五定时器5结束时间：时
			bodyBytes[32] = myTable["week5timer5CloseTimeMin"] -- 周五定时器5结束时间：分

			-- 周五定时器6设定模式、静音开关、强热开关、静音等级
			bodyBytes[33] = bit.bor(
				myTable["week5timer6SetMode"],
				bit.bor(
					bit.lshift(myTable["week5timer6MutSet"], 4),
					bit.bor(bit.lshift(myTable["week5timer6FrcHeSet"], 5), bit.lshift(myTable["week5timer6MutLev"], 6))
				)
			)

			bodyBytes[34] = myTable["week5timer6SetTemp"] -- 周五定时器6设定温度
			bodyBytes[35] = myTable["week5timer6OpenTimeHour"] -- 周五定时器6开始时间：时
			bodyBytes[36] = myTable["week5timer6OpenTimeMin"] -- 周五定时器6开始时间：分
			bodyBytes[37] = myTable["week5timer6CloseTimeHour"] -- 周五定时器6结束时间：时
			bodyBytes[38] = myTable["week5timer6CloseTimeMin"] -- 周五定时器6结束时间：分

			-- 周五定时器1~6是否有效
			bodyBytes[39] = bit.bor(
				myTable["week5timer1Valid"],
				bit.bor(
					myTable["week5timer2Valid"],
					bit.bor(
						myTable["week5timer3Valid"],
						bit.bor(
							myTable["week5timer4Valid"],
							bit.bor(myTable["week5timer5Valid"], myTable["week5timer6Valid"])
						)
					)
				)
			)

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x0a then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			-- 周六定时1~6是否生效
			bodyBytes[2] = bit.bor(
				bit.band(myTable["week6timer1Effect"], 0x01),
				bit.bor(
					bit.band(myTable["week6timer2Effect"], 0x02),
					bit.bor(
						bit.band(myTable["week6timer3Effect"], 0x04),
						bit.bor(
							bit.band(myTable["week6timer4Effect"], 0x08),
							bit.bor(
								bit.band(myTable["week6timer5Effect"], 0x10),
								bit.band(myTable["week6timer6Effect"], 0x20)
							)
						)
					)
				)
			)

			-- 周六定时器1设定模式、静音开关、强热开关、静音等级
			bodyBytes[3] = bit.bor(
				myTable["week6timer1SetMode"],
				bit.bor(
					bit.lshift(myTable["week6timer1MutSet"], 4),
					bit.bor(bit.lshift(myTable["week6timer1FrcHeSet"], 5), bit.lshift(myTable["week6timer1MutLev"], 6))
				)
			)

			bodyBytes[4] = myTable["week6timer1SetTemp"] -- 周六定时器1设定温度
			bodyBytes[5] = myTable["week6timer1OpenTimeHour"] -- 周六定时器1开始时间：时
			bodyBytes[6] = myTable["week6timer1OpenTimeMin"] -- 周六定时器1开始时间：分
			bodyBytes[7] = myTable["week6timer1CloseTimeHour"] -- 周六定时器1结束时间：时
			bodyBytes[8] = myTable["week6timer1CloseTimeMin"] -- 周六定时器1结束时间：分

			-- 周六定时器2设定模式、静音开关、强热开关、静音等级
			bodyBytes[9] = bit.bor(
				myTable["week6timer2SetMode"],
				bit.bor(
					bit.lshift(myTable["week6timer2MutSet"], 4),
					bit.bor(bit.lshift(myTable["week6timer2FrcHeSet"], 5), bit.lshift(myTable["week6timer2MutLev"], 6))
				)
			)

			bodyBytes[10] = myTable["week6timer2SetTemp"] -- 周六定时器2设定温度
			bodyBytes[11] = myTable["week6timer2OpenTimeHour"] -- 周六定时器2开始时间：时
			bodyBytes[12] = myTable["week6timer2OpenTimeMin"] -- 周六定时器2开始时间：分
			bodyBytes[13] = myTable["week6timer2CloseTimeHour"] -- 周六定时器2结束时间：时
			bodyBytes[14] = myTable["week6timer2CloseTimeMin"] -- 周六定时器2结束时间：分

			-- 周六定时器3设定模式、静音开关、强热开关、静音等级
			bodyBytes[15] = bit.bor(
				myTable["week6timer3SetMode"],
				bit.bor(
					bit.lshift(myTable["week6timer3MutSet"], 4),
					bit.bor(bit.lshift(myTable["week6timer3FrcHeSet"], 5), bit.lshift(myTable["week6timer3MutLev"], 6))
				)
			)

			bodyBytes[16] = myTable["week6timer3SetTemp"] -- 周六定时器3设定温度
			bodyBytes[17] = myTable["week6timer3OpenTimeHour"] -- 周六定时器3开始时间：时
			bodyBytes[18] = myTable["week6timer3OpenTimeMin"] -- 周六定时器3开始时间：分
			bodyBytes[19] = myTable["week6timer3CloseTimeHour"] -- 周六定时器3结束时间：时
			bodyBytes[20] = myTable["week6timer3CloseTimeMin"] -- 周六定时器3结束时间：分

			-- 周六定时器4设定模式、静音开关、强热开关、静音等级
			bodyBytes[21] = bit.bor(
				myTable["week6timer4SetMode"],
				bit.bor(
					bit.lshift(myTable["week6timer4MutSet"], 4),
					bit.bor(bit.lshift(myTable["week6timer4FrcHeSet"], 5), bit.lshift(myTable["week6timer4MutLev"], 6))
				)
			)

			bodyBytes[22] = myTable["week6timer4SetTemp"] -- 周六定时器4设定温度
			bodyBytes[23] = myTable["week6timer4OpenTimeHour"] -- 周六定时器4开始时间：时
			bodyBytes[24] = myTable["week6timer4OpenTimeMin"] -- 周六定时器4开始时间：分
			bodyBytes[25] = myTable["week6timer4CloseTimeHour"] -- 周六定时器4结束时间：时
			bodyBytes[26] = myTable["week6timer4CloseTimeMin"] -- 周六定时器4结束时间：分

			-- 周六定时器5设定模式、静音开关、强热开关、静音等级
			bodyBytes[27] = bit.bor(
				myTable["week6timer5SetMode"],
				bit.bor(
					bit.lshift(myTable["week6timer5MutSet"], 4),
					bit.bor(bit.lshift(myTable["week6timer5FrcHeSet"], 5), bit.lshift(myTable["week6timer5MutLev"], 6))
				)
			)

			bodyBytes[28] = myTable["week6timer5SetTemp"] -- 周六定时器5设定温度
			bodyBytes[29] = myTable["week6timer5OpenTimeHour"] -- 周六定时器5开始时间：时
			bodyBytes[30] = myTable["week6timer5OpenTimeMin"] -- 周六定时器5开始时间：分
			bodyBytes[31] = myTable["week6timer5CloseTimeHour"] -- 周六定时器5结束时间：时
			bodyBytes[32] = myTable["week6timer5CloseTimeMin"] -- 周六定时器5结束时间：分

			-- 周六定时器6设定模式、静音开关、强热开关、静音等级
			bodyBytes[33] = bit.bor(
				myTable["week6timer6SetMode"],
				bit.bor(
					bit.lshift(myTable["week6timer6MutSet"], 4),
					bit.bor(bit.lshift(myTable["week6timer6FrcHeSet"], 5), bit.lshift(myTable["week6timer6MutLev"], 6))
				)
			)

			bodyBytes[34] = myTable["week6timer6SetTemp"] -- 周六定时器6设定温度
			bodyBytes[35] = myTable["week6timer6OpenTimeHour"] -- 周六定时器6开始时间：时
			bodyBytes[36] = myTable["week6timer6OpenTimeMin"] -- 周六定时器6开始时间：分
			bodyBytes[37] = myTable["week6timer6CloseTimeHour"] -- 周六定时器6结束时间：时
			bodyBytes[38] = myTable["week6timer6CloseTimeMin"] -- 周六定时器6结束时间：分

			-- 周六定时器1~6是否有效
			bodyBytes[39] = bit.bor(
				myTable["week6timer1Valid"],
				bit.bor(
					myTable["week6timer2Valid"],
					bit.bor(
						myTable["week6timer3Valid"],
						bit.bor(
							myTable["week6timer4Valid"],
							bit.bor(myTable["week6timer5Valid"], myTable["week6timer6Valid"])
						)
					)
				)
			)

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == 0x0b then
			for i = 0, 50 do
				bodyBytes[i] = 0
			end

			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01
			bodyBytes[2] = myTable["timerType"] -- 定时器类型
			-- 定时器1~6开关
			bodyBytes[3] = bit.bor(
				bit.band(myTable["timer1Effect"], 0x01),
				bit.bor(
					bit.band(myTable["timer2Effect"], 0x02),
					bit.bor(
						bit.band(myTable["timer3Effect"], 0x04),
						bit.bor(
							bit.band(myTable["timer4Effect"], 0x08),
							bit.bor(bit.band(myTable["timer5Effect"], 0x10), bit.band(myTable["timer6Effect"], 0x20))
						)
					)
				)
			)

			bodyBytes[4] = myTable["timer1OpenHour"] -- 定时器1开始时间：时
			bodyBytes[5] = myTable["timer1OpenMin"] -- 定时器1开始时间：分
			bodyBytes[6] = myTable["timer1CloseHour"] -- 定时器1结束时间：时
			bodyBytes[7] = myTable["timer1CloseMin"] -- 定时器1结束时间：分
			bodyBytes[8] = myTable["timer1SetTemperature"] -- 定时器1设定温度
			bodyBytes[9] = myTable["timer1ModeValue"] -- 定时器1设定模式

			bodyBytes[10] = myTable["timer2OpenHour"] -- 定时器2开始时间：时
			bodyBytes[11] = myTable["timer2OpenMin"] -- 定时器2开始时间：分
			bodyBytes[12] = myTable["timer2CloseHour"] -- 定时器2结束时间：时
			bodyBytes[13] = myTable["timer2CloseMin"] -- 定时器2结束时间：分
			bodyBytes[14] = myTable["timer2SetTemperature"] -- 定时器2设定温度
			bodyBytes[15] = myTable["timer2ModeValue"] -- 定时器2设定模式

			bodyBytes[16] = myTable["timer3OpenHour"] -- 定时器3开始时间：时
			bodyBytes[17] = myTable["timer3OpenMin"] -- 定时器3开始时间：分
			bodyBytes[18] = myTable["timer3CloseHour"] -- 定时器3结束时间：时
			bodyBytes[19] = myTable["timer3CloseMin"] -- 定时器3结束时间：分
			bodyBytes[20] = myTable["timer3SetTemperature"] -- 定时器3设定温度
			bodyBytes[21] = myTable["timer3ModeValue"] -- 定时器3设定模式

			bodyBytes[22] = myTable["timer4OpenHour"] -- 定时器4开始时间：时
			bodyBytes[23] = myTable["timer4OpenMin"] -- 定时器4开始时间：分
			bodyBytes[24] = myTable["timer4CloseHour"] -- 定时器4结束时间：时
			bodyBytes[25] = myTable["timer4CloseMin"] -- 定时器4结束时间：分
			bodyBytes[26] = myTable["timer4SetTemperature"] -- 定时器4设定温度
			bodyBytes[27] = myTable["timer4ModeValue"] -- 定时器4设定模式

			bodyBytes[28] = myTable["timer5OpenHour"] -- 定时器4开始时间：时
			bodyBytes[29] = myTable["timer5OpenMin"] -- 定时器4开始时间：分
			bodyBytes[30] = myTable["timer5CloseHour"] -- 定时器5结束时间：时
			bodyBytes[31] = myTable["timer5CloseMin"] -- 定时器5结束时间：分
			bodyBytes[32] = myTable["timer5SetTemperature"] -- 定时器5设定温度
			bodyBytes[33] = myTable["timer5ModeValue"] -- 定时器5设定模式

			bodyBytes[34] = myTable["timer6OpenHour"] -- 定时器6开始时间：时
			bodyBytes[35] = myTable["timer6OpenMin"] -- 定时器6开始时间：分
			bodyBytes[36] = myTable["timer6CloseHour"] -- 定时器6结束时间：时
			bodyBytes[37] = myTable["timer6CloseMin"] -- 定时器6结束时间：分
			bodyBytes[38] = myTable["timer6SetTemperature"] -- 定时器6设定温度
			bodyBytes[39] = myTable["timer6ModeValue"] -- 定时器6设定模式

			-- 定时器1~6是否有效
			bodyBytes[40] = bit.bor(
				myTable["timer1Valid"],
				bit.bor(
					myTable["timer2Valid"],
					bit.bor(
						myTable["timer3Valid"],
						bit.bor(myTable["timer4Valid"], bit.bor(myTable["timer5Valid"], myTable["timer6Valid"]))
					)
				)
			)

			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		elseif myTable["controlType"] == BYTE_PERIODIC_REPORT_SUBCMD then
			bodyBytes[0] = myTable["controlType"]
			bodyBytes[1] = 0x01

			bodyBytes[2] = bit.band(myTable["setPeriodicReport"], 0x00FF)
			bodyBytes[3] = bit.band(bit.rshift(myTable["setPeriodicReport"], 8), 0x00FF)
			infoM = getTotalMsg(bodyBytes, BYTE_CONTROL_REQUEST)
		end
	end

	-- table 转换成 string 之后返回
	local ret = table2string(infoM)
	ret = string2hexstring(ret)

	return ret
end

-- 二进制转json
function dataToJson(jsonCmd)
	if not jsonCmd then
		return nil
	end

	local json = decode(jsonCmd)
	local deviceinfo = json["deviceinfo"]
	local deviceSubType = deviceinfo["deviceSubType"]

	-- 根据设备子类型来处理协议差异
	if deviceSubType == 1 then
	end

	local binData = json["msg"]["data"]
	local info = {}
	local msgBytes = {}
	local bodyBytes = {}
	local msgLength = 0
	local bodyLength = 0
	local msgSubType = 0 -- 消息子类型

	info = string2table(binData)

	-- 过滤协议长度不符的包
	if #info < 11 then
		return nil
	end

	for i = 1, #info do
		msgBytes[i - 1] = info[i]
	end

	msgLength = msgBytes[1]
	bodyLength = msgLength - BYTE_PROTOCOL_LENGTH - 1
	myTable["dataType"] = msgBytes[9]
	msgSubType = msgBytes[10]

	-- 检验 sum 判断消息格式是否正确
	local sumRes = makeSum(msgBytes, 1, msgLength - 1)
	if sumRes ~= msgBytes[msgLength] then
	end

	-- 将属性值转换为最终 table
	local streams = {}
	-- 版本
	streams[KEY_VERSION] = VALUE_VERSION

	-- 获取 body 部分
	for i = 0, bodyLength do
		bodyBytes[i] = msgBytes[i + BYTE_PROTOCOL_LENGTH]
	end

	-- 将二进制状态解析为属性值
	binToModel(bodyBytes)

	streams["data_type"] = myTable["dataType"]
	streams["data_sub_type"] = msgSubType

	-- 查询上报信息和主动上报信息
	if
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == BYTE_CONTRL_SUBCMD))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == BYTE_CONTRL_SUBCMD))
	then
		-- 设定模式
		if myTable["modeValue"] == 0 then
			streams[KEY_MODE] = "off"
		elseif myTable["modeValue"] == 1 then
			streams[KEY_MODE] = "heat"
		elseif myTable["modeValue"] == 2 then
			streams[KEY_MODE] = "dhw"
		elseif myTable["modeValue"] == 3 then
			streams[KEY_MODE] = "cool"
		elseif myTable["modeValue"] == 4 then
			streams[KEY_MODE] = "waterpump"
		elseif myTable["modeValue"] == 5 then
			streams[KEY_MODE] = "auto"
		end

		streams["set_temperature"] = int2String(myTable["tsValue"] - TEMP_OFFSET) -- 温度设定TS
		streams["t5s_max"] = int2String(myTable["t5sMax"] - TEMP_OFFSET) -- 设定水温上限值
		streams["t5s_min"] = int2String(myTable["t5sMin"] - TEMP_OFFSET) -- 设定水温下限值
		streams["t5s_def"] = int2String(myTable["t5sDef"] - TEMP_OFFSET) -- 设定水温默认值
		streams["td_max"] = int2String(myTable["tdMax"] - TEMP_OFFSET) -- 电加热开启环境温度上限值
		streams["td_min"] = int2String(myTable["tdMin"] - TEMP_OFFSET) -- 电加热开启环境温度下限值
		streams["td_def"] = int2String(myTable["tdDef"] - TEMP_OFFSET) -- 电加热开启环境温度默认值
		streams["trdh_max"] = int2String(myTable["trdhMax"] - TEMP_OFFSET) -- 热水开机回差温度上限值
		streams["trdh_min"] = int2String(myTable["trdhMin"] - TEMP_OFFSET) -- 热水开机回差温度下限值
		streams["trdh_def"] = int2String(myTable["trdhDef"] - TEMP_OFFSET) -- 热水开机回差温度默认值
		-- 是否有杀菌功能
		if myTable["sterilizeValid"] == 0x01 then
			streams["sterilize_valid"] = VALUE_VALID
		elseif myTable["sterilizeValid"] == 0x00 then
			streams["sterilize_valid"] = VALUE_INVALID
		end
		-- 是否有燃气复合功能
		if myTable["hybridValid"] == 0x02 then
			streams["hybrid_valid"] = VALUE_VALID
		elseif myTable["hybridValid"] == 0x00 then
			streams["hybrid_valid"] = VALUE_INVALID
		end
		-- 是否有太阳能控制功能
		if myTable["solarEnergyValid"] == 0x04 then
			streams["solar_energy_valid"] = VALUE_VALID
		elseif myTable["solarEnergyValid"] == 0x00 then
			streams["solar_energy_valid"] = VALUE_INVALID
		end
		-- 是否有峰谷电功能
		if myTable["optBackupValid"] == 0x08 then
			streams["opt_backup_valid"] = VALUE_VALID
		elseif myTable["optBackupValid"] == 0x00 then
			streams["opt_backup_valid"] = VALUE_INVALID
		end
		-- 是否有休假功能
		if myTable["vacationValid"] == 0x10 then
			streams["vacation_valid"] = VALUE_VALID
		elseif myTable["vacationValid"] == 0x00 then
			streams["vacation_valid"] = VALUE_INVALID
		end
		-- 是否有SmartGrid功能
		if myTable["smartGridValid"] == 0x20 then
			streams["smart_grid_valid"] = VALUE_VALID
		elseif myTable["smartGridValid"] == 0x00 then
			streams["smart_grid_valid"] = VALUE_INVALID
		end
		-- 是否有静音功能
		if myTable["muteValid"] == 0x40 then
			streams["mute_valid"] = VALUE_VALID
		elseif myTable["muteValid"] == 0x00 then
			streams["mute_valid"] = VALUE_INVALID
		end
		-- 是否有强热功能
		if myTable["forceHeatValid"] == 0x80 then
			streams["force_heat_valid"] = VALUE_VALID
		elseif myTable["forceHeatValid"] == 0x00 then
			streams["force_heat_valid"] = VALUE_INVALID
		end
		streams["smart_grid_lev"] = int2String(myTable["smartGridLev"]) -- SmartGrid等级
		streams["error_code"] = int2String(myTable["errorCode"]) -- 故障和保护代码

		-- 杀菌状态
		if myTable["sterilizeSta"] == 0x01 then
			streams["sterilize_sta"] = VALUE_FUNCTION_ON
		elseif myTable["sterilizeSta"] == 0x00 then
			streams["sterilize_sta"] = VALUE_FUNCTION_OFF
		end

		-- 燃气炉状态
		if myTable["hybridSta"] == 0x02 then
			streams["hybrid_sta"] = VALUE_FUNCTION_ON
		elseif myTable["hybridSta"] == 0x00 then
			streams["hybrid_sta"] = VALUE_FUNCTION_OFF
		end

		-- 太阳能信号状态
		if myTable["solarEnergySta"] == 0x04 then
			streams["solar_energy_sta"] = VALUE_FUNCTION_ON
		elseif myTable["solarEnergySta"] == 0x00 then
			streams["solar_energy_sta"] = VALUE_FUNCTION_OFF
		end

		-- 谷电信号状态
		if myTable["optBackupSta"] == 0x08 then
			streams["opt_backup_sta"] = VALUE_FUNCTION_ON
		elseif myTable["optBackupSta"] == 0x00 then
			streams["opt_backup_sta"] = VALUE_FUNCTION_OFF
		end

		-- 休假状态
		if myTable["vacationSta"] == 0x10 then
			streams["vacation_sta"] = VALUE_FUNCTION_ON
		elseif myTable["vacationSta"] == 0x00 then
			streams["vacation_sta"] = VALUE_FUNCTION_OFF
		end

		-- 电加热1运行状态
		if myTable["ibh1Sta"] == 0x20 then
			streams["ibh1_sta"] = VALUE_FUNCTION_ON
		elseif myTable["ibh1Sta"] == 0x00 then
			streams["ibh1_sta"] = VALUE_FUNCTION_OFF
		end

		-- 电加热2运行状态
		if myTable["ibh2Sta"] == 0x40 then
			streams["ibh2_sta"] = VALUE_FUNCTION_ON
		elseif myTable["ibh2Sta"] == 0x00 then
			streams["ibh2_sta"] = VALUE_FUNCTION_OFF
		end

		-- 压缩机状态
		if myTable["compSta"] == 0x80 then
			streams["comp_sta"] = VALUE_FUNCTION_ON
		elseif myTable["compSta"] == 0x00 then
			streams["comp_sta"] = VALUE_FUNCTION_OFF
		end

		streams["box_bottom_temp"] = int2String(myTable["boxBottomTemp"] - TEMP_OFFSET) -- 水箱下部温度
		streams["ptc_temperature"] = int2String(myTable["ptcTemp"] - TEMP_OFFSET) -- 电加热开启环境温度Td
		streams["tr_temperature"] = int2String(myTable["trValue"] - TEMP_OFFSET) -- 热水开机回差Trdh
		streams["sterilize_hour"] = int2String(myTable["sterilizeHour"]) -- 杀菌时间：时
		streams["sterilize_min"] = int2String(myTable["sterilizeMinute"]) -- 杀菌时间：分
		streams["sterilize_temperature"] = int2String(myTable["sterilizeTs"] - TEMP_OFFSET) -- 杀菌设定温度
		streams["sterilize_cycle"] = int2String(myTable["sterilizeCycle"]) -- 杀菌周期：天

		-- 峰谷电开关
		if myTable["optBackupEn"] == 0x01 then
			streams["opt_backup_en"] = VALUE_FUNCTION_ON
		elseif myTable["optBackupEn"] == 0x00 then
			streams["opt_backup_en"] = VALUE_FUNCTION_OFF
		end

		-- 燃气复合开关
		if myTable["hybridEn"] == 0x02 then
			streams["hybrid_en"] = VALUE_FUNCTION_ON
		elseif myTable["hybridEn"] == 0x00 then
			streams["hybrid_en"] = VALUE_FUNCTION_OFF
		end

		-- 太阳能控制开关
		if myTable["solarEnergyEn"] == 0x04 then
			streams["solar_energy_en"] = VALUE_FUNCTION_ON
		elseif myTable["solarEnergyEn"] == 0x00 then
			streams["solar_energy_en"] = VALUE_FUNCTION_OFF
		end

		-- 太阳能利用方式
		if myTable["solarUseWay"] == 0x08 then
			streams["solar_use_way"] = VALUE_FUNCTION_ON
		elseif myTable["solarUseWay"] == 0x00 then
			streams["solar_use_way"] = VALUE_FUNCTION_OFF
		end

		-- 强制电辅热开关
		if myTable["openPTC"] == 0x10 then
			streams["open_ptc"] = VALUE_FUNCTION_ON
		elseif myTable["openPTC"] == 0x00 then
			streams["open_ptc"] = VALUE_FUNCTION_OFF
		end

		-- 强制杀菌开关
		if myTable["forceSterilizeEn"] == 0x20 then
			streams["force_sterilize_en"] = VALUE_FUNCTION_ON
		elseif myTable["forceSterilizeEn"] == 0x00 then
			streams["force_sterilize_en"] = VALUE_FUNCTION_OFF
		end

		-- 休假开关
		if myTable["vacationEn"] == 0x40 then
			streams["vacation_en"] = VALUE_FUNCTION_ON
		elseif myTable["vacationEn"] == 0x00 then
			streams["vacation_en"] = VALUE_FUNCTION_OFF
		end

		-- 杀菌开关
		if myTable["sterilizeEn"] == 0x80 then
			streams["sterilize_en"] = VALUE_FUNCTION_ON
		elseif myTable["sterilizeEn"] == 0x00 then
			streams["sterilize_en"] = VALUE_FUNCTION_OFF
		end

		streams["heat_pump_work_temp_limit"] = int2String(myTable["heatPumpWorkTempLimit"] - TEMP_OFFSET) -- 热泵开启温度下限
		-- 休假开始日期：年、月、日
		streams["set_vacation_start_year"] = int2String(myTable["vacadaysStartYearValue"])
		streams["set_vacation_start_month"] = int2String(myTable["vacadaysStartMonthValue"])
		streams["set_vacation_start_day"] = int2String(myTable["vacadaysStartDayValue"])
		-- 休假结束日期：年、月、日
		streams["set_vacation_end_year"] = int2String(myTable["vacadaysEndYearValue"])
		streams["set_vacation_end_month"] = int2String(myTable["vacadaysEndMonthValue"])
		streams["set_vacation_end_day"] = int2String(myTable["vacadaysEndDayValue"])

		-- 度假模式设定
		if myTable["vacationMode"] == 0 then
			streams["set_vacation_mode"] = "off"
		elseif myTable["vacationMode"] == 1 then
			streams["set_vacation_mode"] = "heat"
		elseif myTable["vacationMode"] == 2 then
			streams["set_vacation_mode"] = "dhw"
		elseif myTable["vacationMode"] == 3 then
			streams["set_vacation_mode"] = "cool"
		elseif myTable["vacationMode"] == 4 then
			streams["set_vacation_mode"] = "waterpump"
		elseif myTable["vacationMode"] == 5 then
			streams["set_vacation_mode"] = "auto"
		end

		streams["type_info"] = int2String(myTable["typeInfo"]) -- 机型信息
		streams["odu_fan_spd"] = int2String(myTable["oduFanSpd"]) -- 外风机转速
		streams["comp_run_tim"] = int2String(myTable["compRunTim"]) -- 最近一次压缩机运行时间
		streams["exv_drg"] = int2String(myTable["exvDrg"]) -- 电子膨胀阀开度
		streams["pressure_h"] = int2String(myTable["pressureH"]) -- 系统压力1
		streams["pressure_l"] = int2String(myTable["pressureL"]) -- 系统压力2

		-- 运行模式
		if myTable["runMode"] == 0 then
			streams["run_mode"] = "off"
		elseif myTable["runMode"] == 1 then
			streams["run_mode"] = "run"
		elseif myTable["runMode"] == 2 then
			streams["run_mode"] = "standby"
		elseif myTable["runMode"] == 3 then
			streams["run_mode"] = "defrost"
		elseif myTable["runMode"] == 4 then
			streams["run_mode"] = "antifreezing"
		end

		streams["comp_frq"] = int2String(myTable["compFrq"]) -- 压缩机频率
		streams["total_kwh"] = int2String(myTable["totalKwh"]) -- 累计消耗电量
		streams["comp_total_run_tim"] = int2String(myTable["compTotalRunTim"]) -- 压缩机累计运行时间
		streams["fan_total_run_tim"] = int2String(myTable["fanTotalRunTim"]) -- 风机累计运行时间

		-- 外置水泵运行状态
		if myTable["pumpOSta"] == 0x01 then
			streams["pumpo_Sta"] = VALUE_FUNCTION_ON
		elseif myTable["pumpOSta"] == 0x00 then
			streams["pumpo_Sta"] = VALUE_FUNCTION_OFF
		end

		-- 太阳能水泵运行状态
		if myTable["pumpSSta"] == 0x02 then
			streams["pumps_sta"] = VALUE_FUNCTION_ON
		elseif myTable["pumpSSta"] == 0x00 then
			streams["pumps_sta"] = VALUE_FUNCTION_OFF
		end

		-- 内机向外机发送的运行指令
		if myTable["oduRunCmd"] == 0x04 then
			streams["odu_run_cmd"] = VALUE_FUNCTION_ON
		elseif myTable["oduRunCmd"] == 0x00 then
			streams["odu_run_cmd"] = VALUE_FUNCTION_OFF
		end

		-- 温度单位
		if myTable["tempUnit"] == 0x40 then
			streams["temp_unit"] = VALUE_FAH
		elseif myTable["tempUnit"] == 0x00 then
			streams["temp_unit"] = VALUE_CEL
		end

		-- SmartGrid运行状态
		if myTable["smartGridSta"] == 0x80 then
			streams["smart_grid_sta"] = VALUE_FUNCTION_ON
		elseif myTable["smartGridSta"] == 0x00 then
			streams["smart_grid_sta"] = VALUE_FUNCTION_OFF
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == BYTE_RUNPARA1_SUBCMD))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == BYTE_RUNPARA1_SUBCMD))
	then
		streams["pumpi_total_run_tim"] = int2String(myTable["pumpITotalRunTim"]) -- 内置水泵累计运行时间
		streams["ibh1_total_run_tim"] = int2String(myTable["ibh1TotalRunTim"]) -- 电加热1累计运行时间
		streams["ibh2_total_run_tim"] = int2String(myTable["ibh2TotalRunTim"]) -- 电加热2累计运行时间
		streams["tbh_total_run_tim"] = int2String(myTable["tbhTotalRunTim"]) -- TBH累计运行时间
		streams["ahs_total_run_tim"] = int2String(myTable["ahsTotalRunTim"]) -- AHS累计运行时间
		streams["online_num"] = int2String(myTable["onlineNum"]) -- 机组在线台数
		streams["odu_mac_type"] = int2String(myTable["oduMacType"]) -- 外机类型
		streams["limit_frq_code"] = int2String(myTable["limitFrqCode"]) -- 限频代号
		streams["tf_temp"] = int2String(myTable["tfTemp"]) -- 压缩机模块温度Tf
		streams["tp_temp"] = int2String(myTable["tpTemp"]) -- 压缩机排气温度Tp
		streams["th_temp"] = int2String(myTable["thTemp"]) -- 压缩机回气温度Th
		streams["water_pres"] = int2String(myTable["waterPres"]) -- 水压
		streams["water_flow"] = int2String(myTable["waterFlow"]) -- 水侧流量
		streams["capacity_hp"] = int2String(myTable["capacityHp"]) -- 机组能力
		streams["t3_temp"] = int2String(myTable["t3Temp"] - TEMP_OFFSET) -- T3温度
		streams["t4_temp"] = int2String(myTable["t4Temp"] - TEMP_OFFSET) -- T4温度
		streams["t2_temp"] = int2String(myTable["t2Temp"] - TEMP_OFFSET) -- T2温度
		streams["t2b_temp"] = int2String(myTable["t2bTemp"] - TEMP_OFFSET) -- T2b温度
		streams["twin_temp"] = int2String(myTable["twinTemp"] - TEMP_OFFSET) -- Twin温度
		streams["twout_temp"] = int2String(myTable["twoutTemp"] - TEMP_OFFSET) -- Twout温度
		streams["t1_temp"] = int2String(myTable["t1Temp"] - TEMP_OFFSET) -- T1温度
		streams["odu_current"] = int2String(myTable["oduCurrent"]) -- 输入电流
		streams["odu_voltage"] = int2String(myTable["oduVoltage"]) -- 输入电压
		streams["dc_current"] = int2String(myTable["dcCurrent"]) -- 直流母线电流
		streams["idu_version_year"] = int2String(myTable["iduVersionYear"]) -- 内机软件版本：年
		streams["idu_version_month"] = int2String(myTable["iduVersionMonth"]) -- 内机软件版本：月
		streams["idu_version_day"] = int2String(myTable["iduVersionDay"]) -- 内机软件版本：日
		streams["idu_version"] = int2String(myTable["iduVersion"]) -- 外机软件版本号
		streams["odu_version_year"] = int2String(myTable["oduVersionYear"]) -- 外机软件版本：年
		streams["odu_version_month"] = int2String(myTable["oduVersionMonth"]) -- 外机软件版本：月
		streams["odu_version_day"] = int2String(myTable["oduVersionDay"]) -- 外机软件版本：日
		streams["odu_version"] = int2String(myTable["oduVersion"]) -- 外机软件版本号
		streams["hmi_version_year"] = int2String(myTable["hmiVersionYear"]) -- 线控器软件版本：年
		streams["hmi_version_month"] = int2String(myTable["hmiVersionMonth"]) -- 线控器软件版本：月
		streams["hmi_version_day"] = int2String(myTable["hmiVersionDay"]) -- 线控器软件版本：日
		streams["hmi_version"] = int2String(myTable["hmiVersion"]) -- 线控器软件版本号

		-- 静音等级
		if myTable["muteLev"] == 0x01 then
			streams["mute_lev"] = VALUE_MUTE_LEV2
		elseif myTable["muteLev"] == 0x00 then
			streams["mute_lev"] = VALUE_MUTE_LEV1
		end

		-- 静音开关
		if myTable["mute"] == 0x01 then
			streams["mute_en"] = VALUE_FUNCTION_ON
		elseif myTable["mute"] == 0x00 then
			streams["mute_en"] = VALUE_FUNCTION_OFF
		end

		-- 强热开关
		if myTable["forceHeat"] == 0x02 then
			streams["force_heat"] = VALUE_FUNCTION_ON
		elseif myTable["forceHeat"] == 0x00 then
			streams["force_heat"] = VALUE_FUNCTION_OFF
		end

		streams["dc_voltage"] = int2String(myTable["dcVoltage"]) -- 直流母线电压

		streams["hpc_value"] = int2String(myTable["hpcValue"]) -- 热量
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x03))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x03))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x03))
	then
		-- 静音定时器1开关
		if myTable["muteTimer1En"] == 0x01 then
			streams["muteTimer1_en"] = VALUE_FUNCTION_ON
		elseif myTable["muteTimer1En"] == 0x00 then
			streams["muteTimer1_en"] = VALUE_FUNCTION_OFF
		end

		-- 静音定时器1是否使用
		if myTable["muteTimer1Effect"] == BIT1 then
			streams["muteTimer1_effect"] = VALUE_VALID
		elseif myTable["muteTimer1Effect"] == 0x00 then
			streams["muteTimer1_effect"] = VALUE_INVALID
		end

		-- 静音定时器1是否有效
		if myTable["muteTimer1Valid"] == 0x80 then
			streams["muteTimer1_valid"] = VALUE_VALID
		elseif myTable["muteTimer1Valid"] == 0x00 then
			streams["muteTimer1_valid"] = VALUE_INVALID
		end

		-- 静音定时器1静音等级
		if myTable["muteTimer1Lev"] == 0x01 then
			streams["mute_timer1_lev"] = VALUE_MUTE_LEV2
		elseif myTable["muteTimer1Lev"] == 0x00 then
			streams["mute_timer1_lev"] = VALUE_MUTE_LEV1
		end

		streams["muteTimer1_start_time_hour"] = int2String(myTable["muteTimer1StartTimeHour"]) -- 静音定时器1开始时间：时
		streams["muteTimer1_start_time_min"] = int2String(myTable["muteTimer1StartTimeMin"]) -- 静音定时器1开始时间：分

		-- 静音定时器2开关
		if myTable["muteTimer2En"] == 0x01 then
			streams["muteTimer2_en"] = VALUE_FUNCTION_ON
		elseif myTable["muteTimer2En"] == 0x00 then
			streams["muteTimer2_en"] = VALUE_FUNCTION_OFF
		end

		-- 静音定时器2是否使用
		if myTable["muteTimer2Effect"] == BIT1 then
			streams["muteTimer2_effect"] = VALUE_VALID
		elseif myTable["muteTimer2Effect"] == 0x00 then
			streams["muteTimer2_effect"] = VALUE_INVALID
		end

		-- 静音定时器2是否有效
		if myTable["muteTimer2Valid"] == 0x80 then
			streams["muteTimer2_valid"] = VALUE_VALID
		elseif myTable["muteTimer2Valid"] == 0x00 then
			streams["muteTimer2_valid"] = VALUE_INVALID
		end

		-- 静音定时器2静音等级
		if myTable["muteTimer2Lev"] == 0x01 then
			streams["mute_timer2_lev"] = VALUE_MUTE_LEV2
		elseif myTable["muteTimer2Lev"] == 0x00 then
			streams["mute_timer2_lev"] = VALUE_MUTE_LEV1
		end

		streams["muteTimer2_start_time_hour"] = int2String(myTable["muteTimer2StartTimeHour"]) -- 静音定时器2开始时间：时
		streams["muteTimer2_start_time_min"] = int2String(myTable["muteTimer2StartTimeMin"]) -- 静音定时器2开始时间：分

		-- 静音定时器3开关
		if myTable["muteTimer3En"] == 0x01 then
			streams["muteTimer3_en"] = VALUE_FUNCTION_ON
		elseif myTable["muteTimer3En"] == 0x00 then
			streams["muteTimer3_en"] = VALUE_FUNCTION_OFF
		end

		-- 静音定时器3是否使用
		if myTable["muteTimer3Effect"] == BIT1 then
			streams["muteTimer3_effect"] = VALUE_VALID
		elseif myTable["muteTimer3Effect"] == 0x00 then
			streams["muteTimer3_effect"] = VALUE_INVALID
		end

		-- 静音定时器3是否有效
		if myTable["muteTimer3Valid"] == 0x80 then
			streams["muteTimer3_valid"] = VALUE_VALID
		elseif myTable["muteTimer3Valid"] == 0x00 then
			streams["muteTimer3_valid"] = VALUE_INVALID
		end

		-- 静音定时器3静音等级
		if myTable["muteTimer3Lev"] == 0x01 then
			streams["mute_timer3_lev"] = VALUE_MUTE_LEV2
		elseif myTable["muteTimer3Lev"] == 0x00 then
			streams["mute_timer3_lev"] = VALUE_MUTE_LEV1
		end

		streams["muteTimer3_start_time_hour"] = int2String(myTable["muteTimer3StartTimeHour"]) -- 静音定时器3开始时间：时
		streams["muteTimer3_start_time_min"] = int2String(myTable["muteTimer3StartTimeMin"]) -- 静音定时器3开始时间：分

		-- 静音定时器4开关
		if myTable["muteTimer4En"] == 0x01 then
			streams["muteTimer4_en"] = VALUE_FUNCTION_ON
		elseif myTable["muteTimer4En"] == 0x00 then
			streams["muteTimer4_en"] = VALUE_FUNCTION_OFF
		end

		-- 静音定时器4是否使用
		if myTable["muteTimer4Effect"] == BIT1 then
			streams["muteTimer4_effect"] = VALUE_VALID
		elseif myTable["muteTimer4Effect"] == 0x00 then
			streams["muteTimer4_effect"] = VALUE_INVALID
		end

		-- 静音定时器4是否有效
		if myTable["muteTimer4Valid"] == 0x80 then
			streams["muteTimer4_valid"] = VALUE_VALID
		elseif myTable["muteTimer4Valid"] == 0x00 then
			streams["muteTimer4_valid"] = VALUE_INVALID
		end

		-- 静音定时器4静音等级
		if myTable["muteTimer4Lev"] == 0x01 then
			streams["mute_timer4_lev"] = VALUE_MUTE_LEV2
		elseif myTable["muteTimer4Lev"] == 0x00 then
			streams["mute_timer4_lev"] = VALUE_MUTE_LEV1
		end

		streams["muteTimer4_start_time_hour"] = int2String(myTable["muteTimer4StartTimeHour"]) -- 静音定时器4开始时间：时
		streams["muteTimer4_start_time_min"] = int2String(myTable["muteTimer4StartTimeMin"]) -- 静音定时器4开始时间：分

		-- 静音定时器5开关
		if myTable["muteTimer5En"] == 0x01 then
			streams["muteTimer5_en"] = VALUE_FUNCTION_ON
		elseif myTable["muteTimer5En"] == 0x00 then
			streams["muteTimer5_en"] = VALUE_FUNCTION_OFF
		end

		-- 静音定时器5是否使用
		if myTable["muteTimer5Effect"] == BIT1 then
			streams["muteTimer5_effect"] = VALUE_VALID
		elseif myTable["muteTimer5Effect"] == 0x00 then
			streams["muteTimer5_effect"] = VALUE_INVALID
		end

		-- 静音定时器5是否有效
		if myTable["muteTimer5Valid"] == 0x80 then
			streams["muteTimer5_valid"] = VALUE_VALID
		elseif myTable["muteTimer5Valid"] == 0x00 then
			streams["muteTimer5_valid"] = VALUE_INVALID
		end

		-- 静音定时器5静音等级
		if myTable["muteTimer5Lev"] == 0x01 then
			streams["mute_timer5_lev"] = VALUE_MUTE_LEV2
		elseif myTable["muteTimer5Lev"] == 0x00 then
			streams["mute_timer5_lev"] = VALUE_MUTE_LEV1
		end

		streams["muteTimer5_start_time_hour"] = int2String(myTable["muteTimer5StartTimeHour"]) -- 静音定时器5开始时间：时
		streams["muteTimer5_start_time_min"] = int2String(myTable["muteTimer5StartTimeMin"]) -- 静音定时器5开始时间：分

		-- 静音定时器6开关
		if myTable["muteTimer6En"] == 0x01 then
			streams["muteTimer6_en"] = VALUE_FUNCTION_ON
		elseif myTable["muteTimer6En"] == 0x00 then
			streams["muteTimer6_en"] = VALUE_FUNCTION_OFF
		end

		-- 静音定时器6是否使用
		if myTable["muteTimer6Effect"] == BIT1 then
			streams["muteTimer6_effect"] = VALUE_VALID
		elseif myTable["muteTimer6Effect"] == 0x00 then
			streams["muteTimer6_effect"] = VALUE_INVALID
		end

		-- 静音定时器6是否有效
		if myTable["muteTimer6Valid"] == 0x80 then
			streams["muteTimer6_valid"] = VALUE_VALID
		elseif myTable["muteTimer6Valid"] == 0x00 then
			streams["muteTimer6_valid"] = VALUE_INVALID
		end

		-- 静音定时器6静音等级
		if myTable["muteTimer6Lev"] == 0x01 then
			streams["mute_timer6_lev"] = VALUE_MUTE_LEV2
		elseif myTable["muteTimer6Lev"] == 0x00 then
			streams["mute_timer6_lev"] = VALUE_MUTE_LEV1
		end

		streams["muteTimer6_start_time_hour"] = int2String(myTable["muteTimer6StartTimeHour"]) -- 静音定时器6开始时间：时
		streams["muteTimer6_start_time_min"] = int2String(myTable["muteTimer6StartTimeMin"]) -- 静音定时器6开始时间：分

		-- 强热定时器1开关
		if myTable["forceHeatTimer1En"] == 0x01 then
			streams["force_heat_timer1_en"] = VALUE_FUNCTION_ON
		elseif myTable["forceHeatTimer1En"] == 0x00 then
			streams["force_heat_timer1_en"] = VALUE_FUNCTION_OFF
		end

		-- 强热定时器1是否有用
		if myTable["forceHeatTimer1Effect"] == BIT1 then
			streams["force_heat_timer1_effect"] = VALUE_VALID
		elseif myTable["forceHeatTimer1Effect"] == 0x00 then
			streams["force_heat_timer1_effect"] = VALUE_INVALID
		end

		-- 强热定时器1是否有效
		if myTable["forceHeatTimer1Valid"] == 0x80 then
			streams["force_heat_timer1_valid"] = VALUE_VALID
		elseif myTable["forceHeatTimer1Valid"] == 0x00 then
			streams["force_heat_timer1_valid"] = VALUE_INVALID
		end

		streams["force_heat_timer1_start_time_hour"] = int2String(myTable["forceHeatTimer1StartTimeHour"]) -- 强热定时器1开始时间：时
		streams["force_heat_timer1_start_time_min"] = int2String(myTable["forceHeatTimer1StartTimeMin"]) -- 强热定时器1开始时间：分

		-- 强热定时器2开关
		if myTable["forceHeatTimer2En"] == 0x01 then
			streams["force_heat_timer2_en"] = VALUE_FUNCTION_ON
		elseif myTable["forceHeatTimer2En"] == 0x00 then
			streams["force_heat_timer2_en"] = VALUE_FUNCTION_OFF
		end

		-- 强热定时器2是否有用
		if myTable["forceHeatTimer2Effect"] == BIT1 then
			streams["force_heat_timer2_effect"] = VALUE_VALID
		elseif myTable["forceHeatTimer2Effect"] == 0x00 then
			streams["force_heat_timer2_effect"] = VALUE_INVALID
		end

		-- 强热定时器2是否有效
		if myTable["forceHeatTimer2Valid"] == 0x80 then
			streams["force_heat_timer2_valid"] = VALUE_VALID
		elseif myTable["forceHeatTimer2Valid"] == 0x00 then
			streams["force_heat_timer2_valid"] = VALUE_INVALID
		end

		streams["force_heat_timer2_start_time_hour"] = int2String(myTable["forceHeatTimer2StartTimeHour"]) -- 强热定时器2开始时间：时
		streams["force_heat_timer2_start_time_min"] = int2String(myTable["forceHeatTimer2StartTimeMin"]) -- 强热定时器2开始时间：分

		-- 强热定时器3开关
		if myTable["forceHeatTimer3En"] == 0x01 then
			streams["force_heat_timer3_en"] = VALUE_FUNCTION_ON
		elseif myTable["forceHeatTimer3En"] == 0x00 then
			streams["force_heat_timer3_en"] = VALUE_FUNCTION_OFF
		end

		-- 强热定时器3是否有用
		if myTable["forceHeatTimer3Effect"] == BIT1 then
			streams["force_heat_timer3_effect"] = VALUE_VALID
		elseif myTable["forceHeatTimer3Effect"] == 0x00 then
			streams["force_heat_timer3_effect"] = VALUE_INVALID
		end

		-- 强热定时器3是否有效
		if myTable["forceHeatTimer3Valid"] == 0x80 then
			streams["force_heat_timer3_valid"] = VALUE_VALID
		elseif myTable["forceHeatTimer3Valid"] == 0x00 then
			streams["force_heat_timer3_valid"] = VALUE_INVALID
		end

		streams["force_heat_timer3_start_time_hour"] = int2String(myTable["forceHeatTimer3StartTimeHour"]) -- 强热定时器3开始时间：时
		streams["force_heat_timer3_start_time_min"] = int2String(myTable["forceHeatTimer3StartTimeMin"]) -- 强热定时器3开始时间：分

		-- 强热定时器4开关
		if myTable["forceHeatTimer4En"] == 0x01 then
			streams["force_heat_timer4_en"] = VALUE_FUNCTION_ON
		elseif myTable["forceHeatTimer4En"] == 0x00 then
			streams["force_heat_timer4_en"] = VALUE_FUNCTION_OFF
		end

		-- 强热定时器4是否有用
		if myTable["forceHeatTimer4Effect"] == BIT1 then
			streams["force_heat_timer4_effect"] = VALUE_VALID
		elseif myTable["forceHeatTimer4Effect"] == 0x00 then
			streams["force_heat_timer4_effect"] = VALUE_INVALID
		end

		-- 强热定时器4是否有效
		if myTable["forceHeatTimer4Valid"] == 0x80 then
			streams["force_heat_timer4_valid"] = VALUE_VALID
		elseif myTable["forceHeatTimer4Valid"] == 0x00 then
			streams["force_heat_timer4_valid"] = VALUE_INVALID
		end

		streams["force_heat_timer4_start_time_hour"] = int2String(myTable["forceHeatTimer4StartTimeHour"]) -- 强热定时器4开始时间：时
		streams["force_heat_timer4_start_time_min"] = int2String(myTable["forceHeatTimer4StartTimeMin"]) -- 强热定时器4开始时间：分

		-- 强热定时器5开关
		if myTable["forceHeatTimer5En"] == 0x01 then
			streams["force_heat_timer5_en"] = VALUE_FUNCTION_ON
		elseif myTable["forceHeatTimer5En"] == 0x00 then
			streams["force_heat_timer5_en"] = VALUE_FUNCTION_OFF
		end

		-- 强热定时器5是否有用
		if myTable["forceHeatTimer5Effect"] == BIT1 then
			streams["force_heat_timer5_effect"] = VALUE_VALID
		elseif myTable["forceHeatTimer5Effect"] == 0x00 then
			streams["force_heat_timer5_effect"] = VALUE_INVALID
		end

		-- 强热定时器5是否有效
		if myTable["forceHeatTimer5Valid"] == 0x80 then
			streams["force_heat_timer5_valid"] = VALUE_VALID
		elseif myTable["forceHeatTimer5Valid"] == 0x00 then
			streams["force_heat_timer5_valid"] = VALUE_INVALID
		end

		streams["force_heat_timer5_start_time_hour"] = int2String(myTable["forceHeatTimer5StartTimeHour"]) -- 强热定时器5开始时间：时
		streams["force_heat_timer5_start_time_min"] = int2String(myTable["forceHeatTimer5StartTimeMin"]) -- 强热定时器5开始时间：分

		-- 强热定时器6开关
		if myTable["forceHeatTimer6En"] == 0x01 then
			streams["force_heat_timer6_en"] = VALUE_FUNCTION_ON
		elseif myTable["forceHeatTimer6En"] == 0x00 then
			streams["force_heat_timer6_en"] = VALUE_FUNCTION_OFF
		end

		-- 强热定时器6是否有用
		if myTable["forceHeatTimer6Effect"] == BIT1 then
			streams["force_heat_timer6_effect"] = VALUE_VALID
		elseif myTable["forceHeatTimer6Effect"] == 0x00 then
			streams["force_heat_timer6_effect"] = VALUE_INVALID
		end

		-- 强热定时器6是否有效
		if myTable["forceHeatTimer6Valid"] == 0x80 then
			streams["force_heat_timer6_valid"] = VALUE_VALID
		elseif myTable["forceHeatTimer6Valid"] == 0x00 then
			streams["force_heat_timer6_valid"] = VALUE_INVALID
		end

		streams["force_heat_timer6_start_time_hour"] = int2String(myTable["forceHeatTimer6StartTimeHour"]) -- 强热定时器6开始时间：时
		streams["force_heat_timer6_start_time_min"] = int2String(myTable["forceHeatTimer6StartTimeMin"]) -- 强热定时器6开始时间：分
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x04))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x04))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x04))
	then
		-- 周日定时1开关
		if myTable["week0timer1Effect"] == 0x01 then
			streams["week0_timer1_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer1Effect"] == 0x00 then
			streams["week0_timer1_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时2开关
		if myTable["week0timer2Effect"] == 0x02 then
			streams["week0_timer2_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer2Effect"] == 0x00 then
			streams["week0_timer2_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时3开关
		if myTable["week0timer3Effect"] == 0x04 then
			streams["week0_timer3_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer3Effect"] == 0x00 then
			streams["week0_timer3_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时4开关
		if myTable["week0timer4Effect"] == 0x08 then
			streams["week0_timer4_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer4Effect"] == 0x00 then
			streams["week0_timer4_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时5开关
		if myTable["week0timer5Effect"] == 0x10 then
			streams["week0_timer5_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer5Effect"] == 0x00 then
			streams["week0_timer5_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时6开关
		if myTable["week0timer6Effect"] == 0x20 then
			streams["week0_timer6_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer6Effect"] == 0x00 then
			streams["week0_timer6_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时器1设定模式
		if myTable["week0timer1SetMode"] == 0 then
			streams["week0_timer1_set_mode"] = "off"
		elseif myTable["week0timer1SetMode"] == 1 then
			streams["week0_timer1_set_mode"] = "heat"
		elseif myTable["week0timer1SetMode"] == 2 then
			streams["week0_timer1_set_mode"] = "dhw"
		elseif myTable["week0timer1SetMode"] == 3 then
			streams["week0_timer1_set_mode"] = "cool"
		elseif myTable["week0timer1SetMode"] == 4 then
			streams["week0_timer1_set_mode"] = "waterpump"
		elseif myTable["week0timer1SetMode"] == 5 then
			streams["week0_timer1_set_mode"] = "auto"
		end

		-- 周日定时1静音开关
		if myTable["week0timer1MutSet"] == 0x01 then
			streams["week0_timer1_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer1MutSet"] == 0x00 then
			streams["week0_timer1_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时1强热开关
		if myTable["week0timer1FrcHeSet"] == 0x01 then
			streams["week0_timer1_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer1FrcHeSet"] == 0x00 then
			streams["week0_timer1_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时1静音等级
		if myTable["week0timer1MutLev"] == 0x01 then
			streams["week0_timer1_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week0timer1MutLev"] == 0x00 then
			streams["week0_timer1_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week0_timer1_set_temp"] = int2String(myTable["week0timer1SetTemp"]) -- 周日定时器1设定温度
		streams["week0_timer1_open_time_hour"] = int2String(myTable["week0timer1OpenTimeHour"]) -- 周日定时器1开始时间：时
		streams["week0_timer1_open_time_min"] = int2String(myTable["week0timer1OpenTimeMin"]) -- 周日定时器1开始时间：分
		streams["week0_timer1_close_time_hour"] = int2String(myTable["week0timer1CloseTimeHour"]) -- 周日定时器1结束时间：时
		streams["week0_timer1_close_time_min"] = int2String(myTable["week0timer1CloseTimeMin"]) -- 周日定时器1结束时间：分

		-- 周日定时器2设定模式
		if myTable["week0timer2SetMode"] == 0 then
			streams["week0_timer2_set_mode"] = "off"
		elseif myTable["week0timer2SetMode"] == 1 then
			streams["week0_timer2_set_mode"] = "heat"
		elseif myTable["week0timer2SetMode"] == 2 then
			streams["week0_timer2_set_mode"] = "dhw"
		elseif myTable["week0timer2SetMode"] == 3 then
			streams["week0_timer2_set_mode"] = "cool"
		elseif myTable["week0timer2SetMode"] == 4 then
			streams["week0_timer2_set_mode"] = "waterpump"
		elseif myTable["week0timer2SetMode"] == 5 then
			streams["week0_timer2_set_mode"] = "auto"
		end

		-- 周日定时2静音开关
		if myTable["week0timer2MutSet"] == 0x01 then
			streams["week0_timer2_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer2MutSet"] == 0x00 then
			streams["week0_timer2_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时2强热开关
		if myTable["week0timer2FrcHeSet"] == 0x01 then
			streams["week0_timer2_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer2FrcHeSet"] == 0x00 then
			streams["week0_timer2_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时2静音等级
		if myTable["week0timer2MutLev"] == 0x01 then
			streams["week0_timer2_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week0timer2MutLev"] == 0x00 then
			streams["week0_timer2_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week0_timer2_set_temp"] = int2String(myTable["week0timer2SetTemp"]) -- 周日定时器2设定温度
		streams["week0_timer2_open_time_hour"] = int2String(myTable["week0timer2OpenTimeHour"]) -- 周日定时器2开始时间：时
		streams["week0_timer2_open_time_min"] = int2String(myTable["week0timer2OpenTimeMin"]) -- 周日定时器2开始时间：分
		streams["week0_timer2_close_time_hour"] = int2String(myTable["week0timer2CloseTimeHour"]) -- 周日定时器2结束时间：时
		streams["week0_timer2_close_time_min"] = int2String(myTable["week0timer2CloseTimeMin"]) -- 周日定时器2结束时间：分

		-- 周日定时器3设定模式
		if myTable["week0timer3SetMode"] == 0 then
			streams["week0_timer3_set_mode"] = "off"
		elseif myTable["week0timer3SetMode"] == 1 then
			streams["week0_timer3_set_mode"] = "heat"
		elseif myTable["week0timer3SetMode"] == 2 then
			streams["week0_timer3_set_mode"] = "dhw"
		elseif myTable["week0timer3SetMode"] == 3 then
			streams["week0_timer3_set_mode"] = "cool"
		elseif myTable["week0timer3SetMode"] == 4 then
			streams["week0_timer3_set_mode"] = "waterpump"
		elseif myTable["week0timer3SetMode"] == 5 then
			streams["week0_timer3_set_mode"] = "auto"
		end

		-- 周日定时3静音开关
		if myTable["week0timer3MutSet"] == 0x01 then
			streams["week0_timer3_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer3MutSet"] == 0x00 then
			streams["week0_timer3_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时3强热开关
		if myTable["week0timer3FrcHeSet"] == 0x01 then
			streams["week0_timer3_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer3FrcHeSet"] == 0x00 then
			streams["week0_timer3_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时3静音等级
		if myTable["week0timer3MutLev"] == 0x01 then
			streams["week0_timer3_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week0timer3MutLev"] == 0x00 then
			streams["week0_timer3_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week0_timer3_set_temp"] = int2String(myTable["week0timer3SetTemp"]) -- 周日定时器3设定温度
		streams["week0_timer3_open_time_hour"] = int2String(myTable["week0timer3OpenTimeHour"]) -- 周日定时器3开始时间：时
		streams["week0_timer3_open_time_min"] = int2String(myTable["week0timer3OpenTimeMin"]) -- 周日定时器3开始时间：分
		streams["week0_timer3_close_time_hour"] = int2String(myTable["week0timer3CloseTimeHour"]) -- 周日定时器3结束时间：时
		streams["week0_timer3_close_time_min"] = int2String(myTable["week0timer3CloseTimeMin"]) -- 周日定时器3结束时间：分

		-- 周日定时器4设定模式
		if myTable["week0timer4SetMode"] == 0 then
			streams["week0_timer4_set_mode"] = "off"
		elseif myTable["week0timer4SetMode"] == 1 then
			streams["week0_timer4_set_mode"] = "heat"
		elseif myTable["week0timer4SetMode"] == 2 then
			streams["week0_timer4_set_mode"] = "dhw"
		elseif myTable["week0timer4SetMode"] == 3 then
			streams["week0_timer4_set_mode"] = "cool"
		elseif myTable["week0timer4SetMode"] == 4 then
			streams["week0_timer4_set_mode"] = "waterpump"
		elseif myTable["week0timer4SetMode"] == 5 then
			streams["week0_timer4_set_mode"] = "auto"
		end

		-- 周日定时4静音开关
		if myTable["week0timer4MutSet"] == 0x01 then
			streams["week0_timer4_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer4MutSet"] == 0x00 then
			streams["week0_timer4_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时4强热开关
		if myTable["week0timer4FrcHeSet"] == 0x01 then
			streams["week0_timer4_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer4FrcHeSet"] == 0x00 then
			streams["week0_timer4_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时4静音等级
		if myTable["week0timer4MutLev"] == 0x01 then
			streams["week0_timer4_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week0timer4MutLev"] == 0x00 then
			streams["week0_timer4_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week0_timer4_set_temp"] = int2String(myTable["week0timer4SetTemp"]) -- 周日定时器4设定温度
		streams["week0_timer4_open_time_hour"] = int2String(myTable["week0timer4OpenTimeHour"]) -- 周日定时器4开始时间：时
		streams["week0_timer4_open_time_min"] = int2String(myTable["week0timer4OpenTimeMin"]) -- 周日定时器4开始时间：分
		streams["week0_timer4_close_time_hour"] = int2String(myTable["week0timer4CloseTimeHour"]) -- 周日定时器4结束时间：时
		streams["week0_timer4_close_time_min"] = int2String(myTable["week0timer4CloseTimeMin"]) -- 周日定时器4结束时间：分

		-- 周日定时器5设定模式
		if myTable["week0timer5SetMode"] == 0 then
			streams["week0_timer5_set_mode"] = "off"
		elseif myTable["week0timer5SetMode"] == 1 then
			streams["week0_timer5_set_mode"] = "heat"
		elseif myTable["week0timer5SetMode"] == 2 then
			streams["week0_timer5_set_mode"] = "dhw"
		elseif myTable["week0timer5SetMode"] == 3 then
			streams["week0_timer5_set_mode"] = "cool"
		elseif myTable["week0timer5SetMode"] == 4 then
			streams["week0_timer5_set_mode"] = "waterpump"
		elseif myTable["week0timer5SetMode"] == 5 then
			streams["week0_timer5_set_mode"] = "auto"
		end

		-- 周日定时5静音开关
		if myTable["week0timer5MutSet"] == 0x01 then
			streams["week0_timer5_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer5MutSet"] == 0x00 then
			streams["week0_timer5_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时5强热开关
		if myTable["week0timer5FrcHeSet"] == 0x01 then
			streams["week0_timer5_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer5FrcHeSet"] == 0x00 then
			streams["week0_timer5_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时5静音等级
		if myTable["week0timer5MutLev"] == 0x01 then
			streams["week0_timer5_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week0timer5MutLev"] == 0x00 then
			streams["week0_timer5_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week0_timer5_set_temp"] = int2String(myTable["week0timer5SetTemp"]) -- 周日定时器5设定温度
		streams["week0_timer5_open_time_hour"] = int2String(myTable["week0timer5OpenTimeHour"]) -- 周日定时器5开始时间：时
		streams["week0_timer5_open_time_min"] = int2String(myTable["week0timer5OpenTimeMin"]) -- 周日定时器5开始时间：分
		streams["week0_timer5_close_time_hour"] = int2String(myTable["week0timer5CloseTimeHour"]) -- 周日定时器5结束时间：时
		streams["week0_timer5_close_time_min"] = int2String(myTable["week0timer5CloseTimeMin"]) -- 周日定时器5结束时间：分

		-- 周日定时器6设定模式
		if myTable["week0timer6SetMode"] == 0 then
			streams["week0_timer6_set_mode"] = "off"
		elseif myTable["week0timer6SetMode"] == 1 then
			streams["week0_timer6_set_mode"] = "heat"
		elseif myTable["week0timer6SetMode"] == 2 then
			streams["week0_timer6_set_mode"] = "dhw"
		elseif myTable["week0timer6SetMode"] == 3 then
			streams["week0_timer6_set_mode"] = "cool"
		elseif myTable["week0timer6SetMode"] == 4 then
			streams["week0_timer6_set_mode"] = "waterpump"
		elseif myTable["week0timer6SetMode"] == 5 then
			streams["week0_timer6_set_mode"] = "auto"
		end

		-- 周日定时6静音开关
		if myTable["week0timer6MutSet"] == 0x01 then
			streams["week0_timer6_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer6MutSet"] == 0x00 then
			streams["week0_timer6_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时6强热开关
		if myTable["week0timer6FrcHeSet"] == 0x01 then
			streams["week0_timer6_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week0timer6FrcHeSet"] == 0x00 then
			streams["week0_timer6_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周日定时6静音等级
		if myTable["week0timer6MutLev"] == 0x01 then
			streams["week0_timer6_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week0timer6MutLev"] == 0x00 then
			streams["week0_timer6_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week0_timer6_set_temp"] = int2String(myTable["week0timer6SetTemp"]) -- 周日定时器6设定温度
		streams["week0_timer6_open_time_hour"] = int2String(myTable["week0timer6OpenTimeHour"]) -- 周日定时器6开始时间：时
		streams["week0_timer6_open_time_min"] = int2String(myTable["week0timer6OpenTimeMin"]) -- 周日定时器6开始时间：分
		streams["week0_timer6_close_time_hour"] = int2String(myTable["week0timer6CloseTimeHour"]) -- 周日定时器6结束时间：时
		streams["week0_timer6_close_time_min"] = int2String(myTable["week0timer6CloseTimeMin"]) -- 周日定时器6结束时间：分

		-- 周日定时1是否有效
		if myTable["week0timer1Valid"] == 0x01 then
			streams["week0_timer1_valid"] = VALUE_VALID
		elseif myTable["week0timer1Valid"] == 0x00 then
			streams["week0_timer1_valid"] = VALUE_INVALID
		end

		-- 周日定时2是否有效
		if myTable["week0timer2Valid"] == 0x02 then
			streams["week0_timer2_valid"] = VALUE_VALID
		elseif myTable["week0timer2Valid"] == 0x00 then
			streams["week0_timer2_valid"] = VALUE_INVALID
		end

		-- 周日定时3是否有效
		if myTable["week0timer3Valid"] == 0x04 then
			streams["week0_timer3_valid"] = VALUE_VALID
		elseif myTable["week0timer3Valid"] == 0x00 then
			streams["week0_timer3_valid"] = VALUE_INVALID
		end

		-- 周日定时4是否有效
		if myTable["week0timer4Valid"] == 0x08 then
			streams["week0_timer4_valid"] = VALUE_VALID
		elseif myTable["week0timer4Valid"] == 0x00 then
			streams["week0_timer4_valid"] = VALUE_INVALID
		end

		-- 周日定时5是否有效
		if myTable["week0timer5Valid"] == 0x10 then
			streams["week0_timer5_valid"] = VALUE_VALID
		elseif myTable["week0timer5Valid"] == 0x00 then
			streams["week0_timer5_valid"] = VALUE_INVALID
		end

		-- 周日定时6是否有效
		if myTable["week0timer6Valid"] == 0x20 then
			streams["week0_timer6_valid"] = VALUE_VALID
		elseif myTable["week0timer6Valid"] == 0x00 then
			streams["week0_timer6_valid"] = VALUE_INVALID
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x05))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x05))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x05))
	then
		-- 周一定时1开关
		if myTable["week1timer1Effect"] == 0x01 then
			streams["week1_timer1_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer1Effect"] == 0x00 then
			streams["week1_timer1_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时2开关
		if myTable["week1timer2Effect"] == 0x02 then
			streams["week1_timer2_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer2Effect"] == 0x00 then
			streams["week1_timer2_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时3开关
		if myTable["week1timer3Effect"] == 0x04 then
			streams["week1_timer3_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer3Effect"] == 0x00 then
			streams["week1_timer3_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时4开关
		if myTable["week1timer4Effect"] == 0x08 then
			streams["week1_timer4_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer4Effect"] == 0x00 then
			streams["week1_timer4_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时5开关
		if myTable["week1timer5Effect"] == 0x10 then
			streams["week1_timer5_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer5Effect"] == 0x00 then
			streams["week1_timer5_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时6开关
		if myTable["week1timer6Effect"] == 0x20 then
			streams["week1_timer6_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer6Effect"] == 0x00 then
			streams["week1_timer6_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时器1设定模式
		if myTable["week1timer1SetMode"] == 0 then
			streams["week1_timer1_set_mode"] = "off"
		elseif myTable["week1timer1SetMode"] == 1 then
			streams["week1_timer1_set_mode"] = "heat"
		elseif myTable["week1timer1SetMode"] == 2 then
			streams["week1_timer1_set_mode"] = "dhw"
		elseif myTable["week1timer1SetMode"] == 3 then
			streams["week1_timer1_set_mode"] = "cool"
		elseif myTable["week1timer1SetMode"] == 4 then
			streams["week1_timer1_set_mode"] = "waterpump"
		elseif myTable["week1timer1SetMode"] == 5 then
			streams["week1_timer1_set_mode"] = "auto"
		end

		-- 周一定时1静音开关
		if myTable["week1timer1MutSet"] == 0x01 then
			streams["week1_timer1_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer1MutSet"] == 0x00 then
			streams["week1_timer1_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时1强热开关
		if myTable["week1timer1FrcHeSet"] == 0x01 then
			streams["week1_timer1_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer1FrcHeSet"] == 0x00 then
			streams["week1_timer1_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时1静音等级
		if myTable["week1timer1MutLev"] == 0x01 then
			streams["week1_timer1_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week1timer1MutLev"] == 0x00 then
			streams["week1_timer1_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week1_timer1_set_temp"] = int2String(myTable["week1timer1SetTemp"]) -- 周一定时器1设定温度
		streams["week1_timer1_open_time_hour"] = int2String(myTable["week1timer1OpenTimeHour"]) -- 周一定时器1开始时间：时
		streams["week1_timer1_open_time_min"] = int2String(myTable["week1timer1OpenTimeMin"]) -- 周一定时器1开始时间：分
		streams["week1_timer1_close_time_hour"] = int2String(myTable["week1timer1CloseTimeHour"]) -- 周一定时器1结束时间：时
		streams["week1_timer1_close_time_min"] = int2String(myTable["week1timer1CloseTimeMin"]) -- 周一定时器1结束时间：分

		-- 周一定时器2设定模式
		if myTable["week1timer2SetMode"] == 0 then
			streams["week1_timer2_set_mode"] = "off"
		elseif myTable["week1timer2SetMode"] == 1 then
			streams["week1_timer2_set_mode"] = "heat"
		elseif myTable["week1timer2SetMode"] == 2 then
			streams["week1_timer2_set_mode"] = "dhw"
		elseif myTable["week1timer2SetMode"] == 3 then
			streams["week1_timer2_set_mode"] = "cool"
		elseif myTable["week1timer2SetMode"] == 4 then
			streams["week1_timer2_set_mode"] = "waterpump"
		elseif myTable["week1timer2SetMode"] == 5 then
			streams["week1_timer2_set_mode"] = "auto"
		end

		-- 周一定时2静音开关
		if myTable["week1timer2MutSet"] == 0x01 then
			streams["week1_timer2_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer2MutSet"] == 0x00 then
			streams["week1_timer2_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时2强热开关
		if myTable["week1timer2FrcHeSet"] == 0x01 then
			streams["week1_timer2_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer2FrcHeSet"] == 0x00 then
			streams["week1_timer2_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时2静音等级
		if myTable["week1timer2MutLev"] == 0x01 then
			streams["week1_timer2_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week1timer2MutLev"] == 0x00 then
			streams["week1_timer2_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week1_timer2_set_temp"] = int2String(myTable["week1timer2SetTemp"]) -- 周一定时器2设定温度
		streams["week1_timer2_open_time_hour"] = int2String(myTable["week1timer2OpenTimeHour"]) -- 周一定时器2开始时间：时
		streams["week1_timer2_open_time_min"] = int2String(myTable["week1timer2OpenTimeMin"]) -- 周一定时器2开始时间：分
		streams["week1_timer2_close_time_hour"] = int2String(myTable["week1timer2CloseTimeHour"]) -- 周一定时器2结束时间：时
		streams["week1_timer2_close_time_min"] = int2String(myTable["week1timer2CloseTimeMin"]) -- 周一定时器2结束时间：分

		-- 周一定时器3设定模式
		if myTable["week1timer3SetMode"] == 0 then
			streams["week1_timer3_set_mode"] = "off"
		elseif myTable["week1timer3SetMode"] == 1 then
			streams["week1_timer3_set_mode"] = "heat"
		elseif myTable["week1timer3SetMode"] == 2 then
			streams["week1_timer3_set_mode"] = "dhw"
		elseif myTable["week1timer3SetMode"] == 3 then
			streams["week1_timer3_set_mode"] = "cool"
		elseif myTable["week1timer3SetMode"] == 4 then
			streams["week1_timer3_set_mode"] = "waterpump"
		elseif myTable["week1timer3SetMode"] == 5 then
			streams["week1_timer3_set_mode"] = "auto"
		end

		-- 周一定时3静音开关
		if myTable["week1timer3MutSet"] == 0x01 then
			streams["week1_timer3_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer3MutSet"] == 0x00 then
			streams["week1_timer3_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时3强热开关
		if myTable["week1timer3FrcHeSet"] == 0x01 then
			streams["week1_timer3_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer3FrcHeSet"] == 0x00 then
			streams["week1_timer3_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时3静音等级
		if myTable["week1timer3MutLev"] == 0x01 then
			streams["week1_timer3_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week1timer3MutLev"] == 0x00 then
			streams["week1_timer3_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week1_timer3_set_temp"] = int2String(myTable["week1timer3SetTemp"]) -- 周一定时器3设定温度
		streams["week1_timer3_open_time_hour"] = int2String(myTable["week1timer3OpenTimeHour"]) -- 周一定时器3开始时间：时
		streams["week1_timer3_open_time_min"] = int2String(myTable["week1timer3OpenTimeMin"]) -- 周一定时器3开始时间：分
		streams["week1_timer3_close_time_hour"] = int2String(myTable["week1timer3CloseTimeHour"]) -- 周一定时器3结束时间：时
		streams["week1_timer3_close_time_min"] = int2String(myTable["week1timer3CloseTimeMin"]) -- 周一定时器3结束时间：分

		-- 周一定时器4设定模式
		if myTable["week1timer4SetMode"] == 0 then
			streams["week1_timer4_set_mode"] = "off"
		elseif myTable["week1timer4SetMode"] == 1 then
			streams["week1_timer4_set_mode"] = "heat"
		elseif myTable["week1timer4SetMode"] == 2 then
			streams["week1_timer4_set_mode"] = "dhw"
		elseif myTable["week1timer4SetMode"] == 3 then
			streams["week1_timer4_set_mode"] = "cool"
		elseif myTable["week1timer4SetMode"] == 4 then
			streams["week1_timer4_set_mode"] = "waterpump"
		elseif myTable["week1timer4SetMode"] == 5 then
			streams["week1_timer4_set_mode"] = "auto"
		end

		-- 周一定时4静音开关
		if myTable["week1timer4MutSet"] == 0x01 then
			streams["week1_timer4_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer4MutSet"] == 0x00 then
			streams["week1_timer4_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时4强热开关
		if myTable["week1timer4FrcHeSet"] == 0x01 then
			streams["week1_timer4_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer4FrcHeSet"] == 0x00 then
			streams["week1_timer4_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时4静音等级
		if myTable["week1timer4MutLev"] == 0x01 then
			streams["week1_timer4_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week1timer4MutLev"] == 0x00 then
			streams["week1_timer4_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week1_timer4_set_temp"] = int2String(myTable["week1timer4SetTemp"]) -- 周一定时器4设定温度
		streams["week1_timer4_open_time_hour"] = int2String(myTable["week1timer4OpenTimeHour"]) -- 周一定时器4开始时间：时
		streams["week1_timer4_open_time_min"] = int2String(myTable["week1timer4OpenTimeMin"]) -- 周一定时器4开始时间：分
		streams["week1_timer4_close_time_hour"] = int2String(myTable["week1timer4CloseTimeHour"]) -- 周一定时器4结束时间：时
		streams["week1_timer4_close_time_min"] = int2String(myTable["week1timer4CloseTimeMin"]) -- 周一定时器4结束时间：分

		-- 周一定时器5设定模式
		if myTable["week1timer5SetMode"] == 0 then
			streams["week1_timer5_set_mode"] = "off"
		elseif myTable["week1timer5SetMode"] == 1 then
			streams["week1_timer5_set_mode"] = "heat"
		elseif myTable["week1timer5SetMode"] == 2 then
			streams["week1_timer5_set_mode"] = "dhw"
		elseif myTable["week1timer5SetMode"] == 3 then
			streams["week1_timer5_set_mode"] = "cool"
		elseif myTable["week1timer5SetMode"] == 4 then
			streams["week1_timer5_set_mode"] = "waterpump"
		elseif myTable["week1timer5SetMode"] == 5 then
			streams["week1_timer5_set_mode"] = "auto"
		end

		-- 周一定时5静音开关
		if myTable["week1timer5MutSet"] == 0x01 then
			streams["week1_timer5_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer5MutSet"] == 0x00 then
			streams["week1_timer5_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时5强热开关
		if myTable["week1timer5FrcHeSet"] == 0x01 then
			streams["week1_timer5_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer5FrcHeSet"] == 0x00 then
			streams["week1_timer5_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时5静音等级
		if myTable["week1timer5MutLev"] == 0x01 then
			streams["week1_timer5_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week1timer5MutLev"] == 0x00 then
			streams["week1_timer5_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week1_timer5_set_temp"] = int2String(myTable["week1timer5SetTemp"]) -- 周一定时器5设定温度
		streams["week1_timer5_open_time_hour"] = int2String(myTable["week1timer5OpenTimeHour"]) -- 周一定时器5开始时间：时
		streams["week1_timer5_open_time_min"] = int2String(myTable["week1timer5OpenTimeMin"]) -- 周一定时器5开始时间：分
		streams["week1_timer5_close_time_hour"] = int2String(myTable["week1timer5CloseTimeHour"]) -- 周一定时器5结束时间：时
		streams["week1_timer5_close_time_min"] = int2String(myTable["week1timer5CloseTimeMin"]) -- 周一定时器5结束时间：分

		-- 周一定时器6设定模式
		if myTable["week1timer6SetMode"] == 0 then
			streams["week1_timer6_set_mode"] = "off"
		elseif myTable["week1timer6SetMode"] == 1 then
			streams["week1_timer6_set_mode"] = "heat"
		elseif myTable["week1timer6SetMode"] == 2 then
			streams["week1_timer6_set_mode"] = "dhw"
		elseif myTable["week1timer6SetMode"] == 3 then
			streams["week1_timer6_set_mode"] = "cool"
		elseif myTable["week1timer6SetMode"] == 4 then
			streams["week1_timer6_set_mode"] = "waterpump"
		elseif myTable["week1timer6SetMode"] == 5 then
			streams["week1_timer6_set_mode"] = "auto"
		end

		-- 周一定时6静音开关
		if myTable["week1timer6MutSet"] == 0x01 then
			streams["week1_timer6_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer6MutSet"] == 0x00 then
			streams["week1_timer6_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时6强热开关
		if myTable["week1timer6FrcHeSet"] == 0x01 then
			streams["week1_timer6_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week1timer6FrcHeSet"] == 0x00 then
			streams["week1_timer6_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周一定时6静音等级
		if myTable["week1timer6MutLev"] == 0x01 then
			streams["week1_timer6_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week1timer6MutLev"] == 0x00 then
			streams["week1_timer6_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week1_timer6_set_temp"] = int2String(myTable["week1timer6SetTemp"]) -- 周一定时器6设定温度
		streams["week1_timer6_open_time_hour"] = int2String(myTable["week1timer6OpenTimeHour"]) -- 周一定时器6开始时间：时
		streams["week1_timer6_open_time_min"] = int2String(myTable["week1timer6OpenTimeMin"]) -- 周一定时器6开始时间：分
		streams["week1_timer6_close_time_hour"] = int2String(myTable["week1timer6CloseTimeHour"]) -- 周一定时器6结束时间：时
		streams["week1_timer6_close_time_min"] = int2String(myTable["week1timer6CloseTimeMin"]) -- 周一定时器6结束时间：分

		-- 周一定时1是否有效
		if myTable["week1timer1Valid"] == 0x01 then
			streams["week1_timer1_valid"] = VALUE_VALID
		elseif myTable["week1timer1Valid"] == 0x00 then
			streams["week1_timer1_valid"] = VALUE_INVALID
		end

		-- 周一定时2是否有效
		if myTable["week1timer2Valid"] == 0x02 then
			streams["week1_timer2_valid"] = VALUE_VALID
		elseif myTable["week1timer2Valid"] == 0x00 then
			streams["week1_timer2_valid"] = VALUE_INVALID
		end

		-- 周一定时3是否有效
		if myTable["week1timer3Valid"] == 0x04 then
			streams["week1_timer3_valid"] = VALUE_VALID
		elseif myTable["week1timer3Valid"] == 0x00 then
			streams["week1_timer3_valid"] = VALUE_INVALID
		end

		-- 周一定时4是否有效
		if myTable["week1timer4Valid"] == 0x08 then
			streams["week1_timer4_valid"] = VALUE_VALID
		elseif myTable["week1timer4Valid"] == 0x00 then
			streams["week1_timer4_valid"] = VALUE_INVALID
		end

		-- 周一定时5是否有效
		if myTable["week1timer5Valid"] == 0x10 then
			streams["week1_timer5_valid"] = VALUE_VALID
		elseif myTable["week1timer5Valid"] == 0x00 then
			streams["week1_timer5_valid"] = VALUE_INVALID
		end

		-- 周一定时6是否有效
		if myTable["week1timer6Valid"] == 0x20 then
			streams["week1_timer6_valid"] = VALUE_VALID
		elseif myTable["week1timer6Valid"] == 0x00 then
			streams["week1_timer6_valid"] = VALUE_INVALID
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x06))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x06))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x06))
	then
		-- 周二定时1开关
		if myTable["week2timer1Effect"] == 0x01 then
			streams["week2_timer1_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer1Effect"] == 0x00 then
			streams["week2_timer1_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时2开关
		if myTable["week2timer2Effect"] == 0x02 then
			streams["week2_timer2_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer2Effect"] == 0x00 then
			streams["week2_timer2_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时3开关
		if myTable["week2timer3Effect"] == 0x04 then
			streams["week2_timer3_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer3Effect"] == 0x00 then
			streams["week2_timer3_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时4开关
		if myTable["week2timer4Effect"] == 0x08 then
			streams["week2_timer4_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer4Effect"] == 0x00 then
			streams["week2_timer4_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时5开关
		if myTable["week2timer5Effect"] == 0x10 then
			streams["week2_timer5_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer5Effect"] == 0x00 then
			streams["week2_timer5_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时6开关
		if myTable["week2timer6Effect"] == 0x20 then
			streams["week2_timer6_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer6Effect"] == 0x00 then
			streams["week2_timer6_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时器1设定模式
		if myTable["week2timer1SetMode"] == 0 then
			streams["week2_timer1_set_mode"] = "off"
		elseif myTable["week2timer1SetMode"] == 1 then
			streams["week2_timer1_set_mode"] = "heat"
		elseif myTable["week2timer1SetMode"] == 2 then
			streams["week2_timer1_set_mode"] = "dhw"
		elseif myTable["week2timer1SetMode"] == 3 then
			streams["week2_timer1_set_mode"] = "cool"
		elseif myTable["week2timer1SetMode"] == 4 then
			streams["week2_timer1_set_mode"] = "waterpump"
		elseif myTable["week2timer1SetMode"] == 5 then
			streams["week2_timer1_set_mode"] = "auto"
		end

		-- 周二定时1静音开关
		if myTable["week2timer1MutSet"] == 0x01 then
			streams["week2_timer1_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer1MutSet"] == 0x00 then
			streams["week2_timer1_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时1强热开关
		if myTable["week2timer1FrcHeSet"] == 0x01 then
			streams["week2_timer1_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer1FrcHeSet"] == 0x00 then
			streams["week2_timer1_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时1静音等级
		if myTable["week2timer1MutLev"] == 0x01 then
			streams["week2_timer1_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week2timer1MutLev"] == 0x00 then
			streams["week2_timer1_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week2_timer1_set_temp"] = int2String(myTable["week2timer1SetTemp"]) -- 周二定时器1设定温度
		streams["week2_timer1_open_time_hour"] = int2String(myTable["week2timer1OpenTimeHour"]) -- 周二定时器1开始时间：时
		streams["week2_timer1_open_time_min"] = int2String(myTable["week2timer1OpenTimeMin"]) -- 周二定时器1开始时间：分
		streams["week2_timer1_close_time_hour"] = int2String(myTable["week2timer1CloseTimeHour"]) -- 周二定时器1结束时间：时
		streams["week2_timer1_close_time_min"] = int2String(myTable["week2timer1CloseTimeMin"]) -- 周二定时器1结束时间：分

		-- 周二定时器2设定模式
		if myTable["week2timer2SetMode"] == 0 then
			streams["week2_timer2_set_mode"] = "off"
		elseif myTable["week2timer2SetMode"] == 1 then
			streams["week2_timer2_set_mode"] = "heat"
		elseif myTable["week2timer2SetMode"] == 2 then
			streams["week2_timer2_set_mode"] = "dhw"
		elseif myTable["week2timer2SetMode"] == 3 then
			streams["week2_timer2_set_mode"] = "cool"
		elseif myTable["week2timer2SetMode"] == 4 then
			streams["week2_timer2_set_mode"] = "waterpump"
		elseif myTable["week2timer2SetMode"] == 5 then
			streams["week2_timer2_set_mode"] = "auto"
		end

		-- 周二定时2静音开关
		if myTable["week2timer2MutSet"] == 0x01 then
			streams["week2_timer2_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer2MutSet"] == 0x00 then
			streams["week2_timer2_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时2强热开关
		if myTable["week2timer2FrcHeSet"] == 0x01 then
			streams["week2_timer2_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer2FrcHeSet"] == 0x00 then
			streams["week2_timer2_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时2静音等级
		if myTable["week2timer2MutLev"] == 0x01 then
			streams["week2_timer2_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week2timer2MutLev"] == 0x00 then
			streams["week2_timer2_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week2_timer2_set_temp"] = int2String(myTable["week2timer2SetTemp"]) -- 周二定时器2设定温度
		streams["week2_timer2_open_time_hour"] = int2String(myTable["week2timer2OpenTimeHour"]) -- 周二定时器2开始时间：时
		streams["week2_timer2_open_time_min"] = int2String(myTable["week2timer2OpenTimeMin"]) -- 周二定时器2开始时间：分
		streams["week2_timer2_close_time_hour"] = int2String(myTable["week2timer2CloseTimeHour"]) -- 周二定时器2结束时间：时
		streams["week2_timer2_close_time_min"] = int2String(myTable["week2timer2CloseTimeMin"]) -- 周二定时器2结束时间：分

		-- 周二定时器3设定模式
		if myTable["week2timer3SetMode"] == 0 then
			streams["week2_timer3_set_mode"] = "off"
		elseif myTable["week2timer3SetMode"] == 1 then
			streams["week2_timer3_set_mode"] = "heat"
		elseif myTable["week2timer3SetMode"] == 2 then
			streams["week2_timer3_set_mode"] = "dhw"
		elseif myTable["week2timer3SetMode"] == 3 then
			streams["week2_timer3_set_mode"] = "cool"
		elseif myTable["week2timer3SetMode"] == 4 then
			streams["week2_timer3_set_mode"] = "waterpump"
		elseif myTable["week2timer3SetMode"] == 5 then
			streams["week2_timer3_set_mode"] = "auto"
		end

		-- 周二定时3静音开关
		if myTable["week2timer3MutSet"] == 0x01 then
			streams["week2_timer3_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer3MutSet"] == 0x00 then
			streams["week2_timer3_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时3强热开关
		if myTable["week2timer3FrcHeSet"] == 0x01 then
			streams["week2_timer3_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer3FrcHeSet"] == 0x00 then
			streams["week2_timer3_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时3静音等级
		if myTable["week2timer3MutLev"] == 0x01 then
			streams["week2_timer3_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week2timer3MutLev"] == 0x00 then
			streams["week2_timer3_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week2_timer3_set_temp"] = int2String(myTable["week2timer3SetTemp"]) -- 周二定时器3设定温度
		streams["week2_timer3_open_time_hour"] = int2String(myTable["week2timer3OpenTimeHour"]) -- 周二定时器3开始时间：时
		streams["week2_timer3_open_time_min"] = int2String(myTable["week2timer3OpenTimeMin"]) -- 周二定时器3开始时间：分
		streams["week2_timer3_close_time_hour"] = int2String(myTable["week2timer3CloseTimeHour"]) -- 周二定时器3结束时间：时
		streams["week2_timer3_close_time_min"] = int2String(myTable["week2timer3CloseTimeMin"]) -- 周二定时器3结束时间：分

		-- 周二定时器4设定模式
		if myTable["week2timer4SetMode"] == 0 then
			streams["week2_timer4_set_mode"] = "off"
		elseif myTable["week2timer4SetMode"] == 1 then
			streams["week2_timer4_set_mode"] = "heat"
		elseif myTable["week2timer4SetMode"] == 2 then
			streams["week2_timer4_set_mode"] = "dhw"
		elseif myTable["week2timer4SetMode"] == 3 then
			streams["week2_timer4_set_mode"] = "cool"
		elseif myTable["week2timer4SetMode"] == 4 then
			streams["week2_timer4_set_mode"] = "waterpump"
		elseif myTable["week2timer4SetMode"] == 5 then
			streams["week2_timer4_set_mode"] = "auto"
		end

		-- 周二定时4静音开关
		if myTable["week2timer4MutSet"] == 0x01 then
			streams["week2_timer4_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer4MutSet"] == 0x00 then
			streams["week2_timer4_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时4强热开关
		if myTable["week2timer4FrcHeSet"] == 0x01 then
			streams["week2_timer4_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer4FrcHeSet"] == 0x00 then
			streams["week2_timer4_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时4静音等级
		if myTable["week2timer4MutLev"] == 0x01 then
			streams["week2_timer4_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week2timer4MutLev"] == 0x00 then
			streams["week2_timer4_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week2_timer4_set_temp"] = int2String(myTable["week2timer4SetTemp"]) -- 周二定时器4设定温度
		streams["week2_timer4_open_time_hour"] = int2String(myTable["week2timer4OpenTimeHour"]) -- 周二定时器4开始时间：时
		streams["week2_timer4_open_time_min"] = int2String(myTable["week2timer4OpenTimeMin"]) -- 周二定时器4开始时间：分
		streams["week2_timer4_close_time_hour"] = int2String(myTable["week2timer4CloseTimeHour"]) -- 周二定时器4结束时间：时
		streams["week2_timer4_close_time_min"] = int2String(myTable["week2timer4CloseTimeMin"]) -- 周二定时器4结束时间：分

		-- 周二定时器5设定模式
		if myTable["week2timer5SetMode"] == 0 then
			streams["week2_timer5_set_mode"] = "off"
		elseif myTable["week2timer5SetMode"] == 1 then
			streams["week2_timer5_set_mode"] = "heat"
		elseif myTable["week2timer5SetMode"] == 2 then
			streams["week2_timer5_set_mode"] = "dhw"
		elseif myTable["week2timer5SetMode"] == 3 then
			streams["week2_timer5_set_mode"] = "cool"
		elseif myTable["week2timer5SetMode"] == 4 then
			streams["week2_timer5_set_mode"] = "waterpump"
		elseif myTable["week2timer5SetMode"] == 5 then
			streams["week2_timer5_set_mode"] = "auto"
		end

		-- 周二定时5静音开关
		if myTable["week2timer5MutSet"] == 0x01 then
			streams["week2_timer5_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer5MutSet"] == 0x00 then
			streams["week2_timer5_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时5强热开关
		if myTable["week2timer5FrcHeSet"] == 0x01 then
			streams["week2_timer5_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer5FrcHeSet"] == 0x00 then
			streams["week2_timer5_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时5静音等级
		if myTable["week2timer5MutLev"] == 0x01 then
			streams["week2_timer5_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week2timer5MutLev"] == 0x00 then
			streams["week2_timer5_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week2_timer5_set_temp"] = int2String(myTable["week2timer5SetTemp"]) -- 周二定时器5设定温度
		streams["week2_timer5_open_time_hour"] = int2String(myTable["week2timer5OpenTimeHour"]) -- 周二定时器5开始时间：时
		streams["week2_timer5_open_time_min"] = int2String(myTable["week2timer5OpenTimeMin"]) -- 周二定时器5开始时间：分
		streams["week2_timer5_close_time_hour"] = int2String(myTable["week2timer5CloseTimeHour"]) -- 周二定时器5结束时间：时
		streams["week2_timer5_close_time_min"] = int2String(myTable["week2timer5CloseTimeMin"]) -- 周二定时器5结束时间：分

		-- 周二定时器6设定模式
		if myTable["week2timer6SetMode"] == 0 then
			streams["week2_timer6_set_mode"] = "off"
		elseif myTable["week2timer6SetMode"] == 1 then
			streams["week2_timer6_set_mode"] = "heat"
		elseif myTable["week2timer6SetMode"] == 2 then
			streams["week2_timer6_set_mode"] = "dhw"
		elseif myTable["week2timer6SetMode"] == 3 then
			streams["week2_timer6_set_mode"] = "cool"
		elseif myTable["week2timer6SetMode"] == 4 then
			streams["week2_timer6_set_mode"] = "waterpump"
		elseif myTable["week2timer6SetMode"] == 5 then
			streams["week2_timer6_set_mode"] = "auto"
		end

		-- 周二定时6静音开关
		if myTable["week2timer6MutSet"] == 0x01 then
			streams["week2_timer6_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer6MutSet"] == 0x00 then
			streams["week2_timer6_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时6强热开关
		if myTable["week2timer6FrcHeSet"] == 0x01 then
			streams["week2_timer6_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week2timer6FrcHeSet"] == 0x00 then
			streams["week2_timer6_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周二定时6静音等级
		if myTable["week2timer6MutLev"] == 0x01 then
			streams["week2_timer6_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week2timer6MutLev"] == 0x00 then
			streams["week2_timer6_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week2_timer6_set_temp"] = int2String(myTable["week2timer6SetTemp"]) -- 周二定时器6设定温度
		streams["week2_timer6_open_time_hour"] = int2String(myTable["week2timer6OpenTimeHour"]) -- 周二定时器6开始时间：时
		streams["week2_timer6_open_time_min"] = int2String(myTable["week2timer6OpenTimeMin"]) -- 周二定时器6开始时间：分
		streams["week2_timer6_close_time_hour"] = int2String(myTable["week2timer6CloseTimeHour"]) -- 周二定时器6结束时间：时
		streams["week2_timer6_close_time_min"] = int2String(myTable["week2timer6CloseTimeMin"]) -- 周二定时器6结束时间：分

		-- 周二定时1是否有效
		if myTable["week2timer1Valid"] == 0x01 then
			streams["week2_timer1_valid"] = VALUE_VALID
		elseif myTable["week2timer1Valid"] == 0x00 then
			streams["week2_timer1_valid"] = VALUE_INVALID
		end

		-- 周二定时2是否有效
		if myTable["week2timer2Valid"] == 0x02 then
			streams["week2_timer2_valid"] = VALUE_VALID
		elseif myTable["week2timer2Valid"] == 0x00 then
			streams["week2_timer2_valid"] = VALUE_INVALID
		end

		-- 周二定时3是否有效
		if myTable["week2timer3Valid"] == 0x04 then
			streams["week2_timer3_valid"] = VALUE_VALID
		elseif myTable["week2timer3Valid"] == 0x00 then
			streams["week2_timer3_valid"] = VALUE_INVALID
		end

		-- 周二定时4是否有效
		if myTable["week2timer4Valid"] == 0x08 then
			streams["week2_timer4_valid"] = VALUE_VALID
		elseif myTable["week2timer4Valid"] == 0x00 then
			streams["week2_timer4_valid"] = VALUE_INVALID
		end

		-- 周二定时5是否有效
		if myTable["week2timer5Valid"] == 0x10 then
			streams["week2_timer5_valid"] = VALUE_VALID
		elseif myTable["week2timer5Valid"] == 0x00 then
			streams["week2_timer5_valid"] = VALUE_INVALID
		end

		-- 周二定时6是否有效
		if myTable["week2timer6Valid"] == 0x20 then
			streams["week2_timer6_valid"] = VALUE_VALID
		elseif myTable["week2timer6Valid"] == 0x00 then
			streams["week2_timer6_valid"] = VALUE_INVALID
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x07))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x07))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x07))
	then
		-- 周三定时1开关
		if myTable["week3timer1Effect"] == 0x01 then
			streams["week3_timer1_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer1Effect"] == 0x00 then
			streams["week3_timer1_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时2开关
		if myTable["week3timer2Effect"] == 0x02 then
			streams["week3_timer2_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer2Effect"] == 0x00 then
			streams["week3_timer2_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时3开关
		if myTable["week3timer3Effect"] == 0x04 then
			streams["week3_timer3_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer3Effect"] == 0x00 then
			streams["week3_timer3_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时4开关
		if myTable["week3timer4Effect"] == 0x08 then
			streams["week3_timer4_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer4Effect"] == 0x00 then
			streams["week3_timer4_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时5开关
		if myTable["week3timer5Effect"] == 0x10 then
			streams["week3_timer5_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer5Effect"] == 0x00 then
			streams["week3_timer5_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时6开关
		if myTable["week3timer6Effect"] == 0x20 then
			streams["week3_timer6_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer6Effect"] == 0x00 then
			streams["week3_timer6_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时器1设定模式
		if myTable["week3timer1SetMode"] == 0 then
			streams["week3_timer1_set_mode"] = "off"
		elseif myTable["week3timer1SetMode"] == 1 then
			streams["week3_timer1_set_mode"] = "heat"
		elseif myTable["week3timer1SetMode"] == 2 then
			streams["week3_timer1_set_mode"] = "dhw"
		elseif myTable["week3timer1SetMode"] == 3 then
			streams["week3_timer1_set_mode"] = "cool"
		elseif myTable["week3timer1SetMode"] == 4 then
			streams["week3_timer1_set_mode"] = "waterpump"
		elseif myTable["week3timer1SetMode"] == 5 then
			streams["week3_timer1_set_mode"] = "auto"
		end

		-- 周三定时1静音开关
		if myTable["week3timer1MutSet"] == 0x01 then
			streams["week3_timer1_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer1MutSet"] == 0x00 then
			streams["week3_timer1_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时1强热开关
		if myTable["week3timer1FrcHeSet"] == 0x01 then
			streams["week3_timer1_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer1FrcHeSet"] == 0x00 then
			streams["week3_timer1_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时1静音等级
		if myTable["week3timer1MutLev"] == 0x01 then
			streams["week3_timer1_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week3timer1MutLev"] == 0x00 then
			streams["week3_timer1_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week3_timer1_set_temp"] = int2String(myTable["week3timer1SetTemp"]) -- 周三定时器1设定温度
		streams["week3_timer1_open_time_hour"] = int2String(myTable["week3timer1OpenTimeHour"]) -- 周三定时器1开始时间：时
		streams["week3_timer1_open_time_min"] = int2String(myTable["week3timer1OpenTimeMin"]) -- 周三定时器1开始时间：分
		streams["week3_timer1_close_time_hour"] = int2String(myTable["week3timer1CloseTimeHour"]) -- 周三定时器1结束时间：时
		streams["week3_timer1_close_time_min"] = int2String(myTable["week3timer1CloseTimeMin"]) -- 周三定时器1结束时间：分

		-- 周三定时器2设定模式
		if myTable["week3timer2SetMode"] == 0 then
			streams["week3_timer2_set_mode"] = "off"
		elseif myTable["week3timer2SetMode"] == 1 then
			streams["week3_timer2_set_mode"] = "heat"
		elseif myTable["week3timer2SetMode"] == 2 then
			streams["week3_timer2_set_mode"] = "dhw"
		elseif myTable["week3timer2SetMode"] == 3 then
			streams["week3_timer2_set_mode"] = "cool"
		elseif myTable["week3timer2SetMode"] == 4 then
			streams["week3_timer2_set_mode"] = "waterpump"
		elseif myTable["week3timer2SetMode"] == 5 then
			streams["week3_timer2_set_mode"] = "auto"
		end

		-- 周三定时2静音开关
		if myTable["week3timer2MutSet"] == 0x01 then
			streams["week3_timer2_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer2MutSet"] == 0x00 then
			streams["week3_timer2_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时2强热开关
		if myTable["week3timer2FrcHeSet"] == 0x01 then
			streams["week3_timer2_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer2FrcHeSet"] == 0x00 then
			streams["week3_timer2_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时2静音等级
		if myTable["week3timer2MutLev"] == 0x01 then
			streams["week3_timer2_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week3timer2MutLev"] == 0x00 then
			streams["week3_timer2_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week3_timer2_set_temp"] = int2String(myTable["week3timer2SetTemp"]) -- 周三定时器2设定温度
		streams["week3_timer2_open_time_hour"] = int2String(myTable["week3timer2OpenTimeHour"]) -- 周三定时器2开始时间：时
		streams["week3_timer2_open_time_min"] = int2String(myTable["week3timer2OpenTimeMin"]) -- 周三定时器2开始时间：分
		streams["week3_timer2_close_time_hour"] = int2String(myTable["week3timer2CloseTimeHour"]) -- 周三定时器2结束时间：时
		streams["week3_timer2_close_time_min"] = int2String(myTable["week3timer2CloseTimeMin"]) -- 周三定时器2结束时间：分

		-- 周三定时器3设定模式
		if myTable["week3timer3SetMode"] == 0 then
			streams["week3_timer3_set_mode"] = "off"
		elseif myTable["week3timer3SetMode"] == 1 then
			streams["week3_timer3_set_mode"] = "heat"
		elseif myTable["week3timer3SetMode"] == 2 then
			streams["week3_timer3_set_mode"] = "dhw"
		elseif myTable["week3timer3SetMode"] == 3 then
			streams["week3_timer3_set_mode"] = "cool"
		elseif myTable["week3timer3SetMode"] == 4 then
			streams["week3_timer3_set_mode"] = "waterpump"
		elseif myTable["week3timer3SetMode"] == 5 then
			streams["week3_timer3_set_mode"] = "auto"
		end

		-- 周三定时3静音开关
		if myTable["week3timer3MutSet"] == 0x01 then
			streams["week3_timer3_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer3MutSet"] == 0x00 then
			streams["week3_timer3_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时3强热开关
		if myTable["week3timer3FrcHeSet"] == 0x01 then
			streams["week3_timer3_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer3FrcHeSet"] == 0x00 then
			streams["week3_timer3_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时3静音等级
		if myTable["week3timer3MutLev"] == 0x01 then
			streams["week3_timer3_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week3timer3MutLev"] == 0x00 then
			streams["week3_timer3_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week3_timer3_set_temp"] = int2String(myTable["week3timer3SetTemp"]) -- 周三定时器3设定温度
		streams["week3_timer3_open_time_hour"] = int2String(myTable["week3timer3OpenTimeHour"]) -- 周三定时器3开始时间：时
		streams["week3_timer3_open_time_min"] = int2String(myTable["week3timer3OpenTimeMin"]) -- 周三定时器3开始时间：分
		streams["week3_timer3_close_time_hour"] = int2String(myTable["week3timer3CloseTimeHour"]) -- 周三定时器3结束时间：时
		streams["week3_timer3_close_time_min"] = int2String(myTable["week3timer3CloseTimeMin"]) -- 周三定时器3结束时间：分

		-- 周三定时器4设定模式
		if myTable["week3timer4SetMode"] == 0 then
			streams["week3_timer4_set_mode"] = "off"
		elseif myTable["week3timer4SetMode"] == 1 then
			streams["week3_timer4_set_mode"] = "heat"
		elseif myTable["week3timer4SetMode"] == 2 then
			streams["week3_timer4_set_mode"] = "dhw"
		elseif myTable["week3timer4SetMode"] == 3 then
			streams["week3_timer4_set_mode"] = "cool"
		elseif myTable["week3timer4SetMode"] == 4 then
			streams["week3_timer4_set_mode"] = "waterpump"
		elseif myTable["week3timer4SetMode"] == 5 then
			streams["week3_timer4_set_mode"] = "auto"
		end

		-- 周三定时4静音开关
		if myTable["week3timer4MutSet"] == 0x01 then
			streams["week3_timer4_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer4MutSet"] == 0x00 then
			streams["week3_timer4_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时4强热开关
		if myTable["week3timer4FrcHeSet"] == 0x01 then
			streams["week3_timer4_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer4FrcHeSet"] == 0x00 then
			streams["week3_timer4_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时4静音等级
		if myTable["week3timer4MutLev"] == 0x01 then
			streams["week3_timer4_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week3timer4MutLev"] == 0x00 then
			streams["week3_timer4_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week3_timer4_set_temp"] = int2String(myTable["week3timer4SetTemp"]) -- 周三定时器4设定温度
		streams["week3_timer4_open_time_hour"] = int2String(myTable["week3timer4OpenTimeHour"]) -- 周三定时器4开始时间：时
		streams["week3_timer4_open_time_min"] = int2String(myTable["week3timer4OpenTimeMin"]) -- 周三定时器4开始时间：分
		streams["week3_timer4_close_time_hour"] = int2String(myTable["week3timer4CloseTimeHour"]) -- 周三定时器4结束时间：时
		streams["week3_timer4_close_time_min"] = int2String(myTable["week3timer4CloseTimeMin"]) -- 周三定时器4结束时间：分

		-- 周三定时器5设定模式
		if myTable["week3timer5SetMode"] == 0 then
			streams["week3_timer5_set_mode"] = "off"
		elseif myTable["week3timer5SetMode"] == 1 then
			streams["week3_timer5_set_mode"] = "heat"
		elseif myTable["week3timer5SetMode"] == 2 then
			streams["week3_timer5_set_mode"] = "dhw"
		elseif myTable["week3timer5SetMode"] == 3 then
			streams["week3_timer5_set_mode"] = "cool"
		elseif myTable["week3timer5SetMode"] == 4 then
			streams["week3_timer5_set_mode"] = "waterpump"
		elseif myTable["week3timer5SetMode"] == 5 then
			streams["week3_timer5_set_mode"] = "auto"
		end

		-- 周三定时5静音开关
		if myTable["week3timer5MutSet"] == 0x01 then
			streams["week3_timer5_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer5MutSet"] == 0x00 then
			streams["week3_timer5_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时5强热开关
		if myTable["week3timer5FrcHeSet"] == 0x01 then
			streams["week3_timer5_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer5FrcHeSet"] == 0x00 then
			streams["week3_timer5_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时5静音等级
		if myTable["week3timer5MutLev"] == 0x01 then
			streams["week3_timer5_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week3timer5MutLev"] == 0x00 then
			streams["week3_timer5_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week3_timer5_set_temp"] = int2String(myTable["week3timer5SetTemp"]) -- 周三定时器5设定温度
		streams["week3_timer5_open_time_hour"] = int2String(myTable["week3timer5OpenTimeHour"]) -- 周三定时器5开始时间：时
		streams["week3_timer5_open_time_min"] = int2String(myTable["week3timer5OpenTimeMin"]) -- 周三定时器5开始时间：分
		streams["week3_timer5_close_time_hour"] = int2String(myTable["week3timer5CloseTimeHour"]) -- 周三定时器5结束时间：时
		streams["week3_timer5_close_time_min"] = int2String(myTable["week3timer5CloseTimeMin"]) -- 周三定时器5结束时间：分

		-- 周三定时器6设定模式
		if myTable["week3timer6SetMode"] == 0 then
			streams["week3_timer6_set_mode"] = "off"
		elseif myTable["week3timer6SetMode"] == 1 then
			streams["week3_timer6_set_mode"] = "heat"
		elseif myTable["week3timer6SetMode"] == 2 then
			streams["week3_timer6_set_mode"] = "dhw"
		elseif myTable["week3timer6SetMode"] == 3 then
			streams["week3_timer6_set_mode"] = "cool"
		elseif myTable["week3timer6SetMode"] == 4 then
			streams["week3_timer6_set_mode"] = "waterpump"
		elseif myTable["week3timer6SetMode"] == 5 then
			streams["week3_timer6_set_mode"] = "auto"
		end

		-- 周三定时6静音开关
		if myTable["week3timer6MutSet"] == 0x01 then
			streams["week3_timer6_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer6MutSet"] == 0x00 then
			streams["week3_timer6_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时6强热开关
		if myTable["week3timer6FrcHeSet"] == 0x01 then
			streams["week3_timer6_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week3timer6FrcHeSet"] == 0x00 then
			streams["week3_timer6_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周三定时6静音等级
		if myTable["week3timer6MutLev"] == 0x01 then
			streams["week3_timer6_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week3timer6MutLev"] == 0x00 then
			streams["week3_timer6_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week3_timer6_set_temp"] = int2String(myTable["week3timer6SetTemp"]) -- 周三定时器6设定温度
		streams["week3_timer6_open_time_hour"] = int2String(myTable["week3timer6OpenTimeHour"]) -- 周三定时器6开始时间：时
		streams["week3_timer6_open_time_min"] = int2String(myTable["week3timer6OpenTimeMin"]) -- 周三定时器6开始时间：分
		streams["week3_timer6_close_time_hour"] = int2String(myTable["week3timer6CloseTimeHour"]) -- 周三定时器6结束时间：时
		streams["week3_timer6_close_time_min"] = int2String(myTable["week3timer6CloseTimeMin"]) -- 周三定时器6结束时间：分

		-- 周三定时1是否有效
		if myTable["week3timer1Valid"] == 0x01 then
			streams["week3_timer1_valid"] = VALUE_VALID
		elseif myTable["week3timer1Valid"] == 0x00 then
			streams["week3_timer1_valid"] = VALUE_INVALID
		end

		-- 周三定时2是否有效
		if myTable["week3timer2Valid"] == 0x02 then
			streams["week3_timer2_valid"] = VALUE_VALID
		elseif myTable["week3timer2Valid"] == 0x00 then
			streams["week3_timer2_valid"] = VALUE_INVALID
		end

		-- 周三定时3是否有效
		if myTable["week3timer3Valid"] == 0x04 then
			streams["week3_timer3_valid"] = VALUE_VALID
		elseif myTable["week3timer3Valid"] == 0x00 then
			streams["week3_timer3_valid"] = VALUE_INVALID
		end

		-- 周三定时4是否有效
		if myTable["week3timer4Valid"] == 0x08 then
			streams["week3_timer4_valid"] = VALUE_VALID
		elseif myTable["week3timer4Valid"] == 0x00 then
			streams["week3_timer4_valid"] = VALUE_INVALID
		end

		-- 周三定时5是否有效
		if myTable["week3timer5Valid"] == 0x10 then
			streams["week3_timer5_valid"] = VALUE_VALID
		elseif myTable["week3timer5Valid"] == 0x00 then
			streams["week3_timer5_valid"] = VALUE_INVALID
		end

		-- 周三定时6是否有效
		if myTable["week3timer6Valid"] == 0x20 then
			streams["week3_timer6_valid"] = VALUE_VALID
		elseif myTable["week3timer6Valid"] == 0x00 then
			streams["week3_timer6_valid"] = VALUE_INVALID
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x08))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x08))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x08))
	then
		-- 周四定时1开关
		if myTable["week4timer1Effect"] == 0x01 then
			streams["week4_timer1_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer1Effect"] == 0x00 then
			streams["week4_timer1_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时2开关
		if myTable["week4timer2Effect"] == 0x02 then
			streams["week4_timer2_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer2Effect"] == 0x00 then
			streams["week4_timer2_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时3开关
		if myTable["week4timer3Effect"] == 0x04 then
			streams["week4_timer3_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer3Effect"] == 0x00 then
			streams["week4_timer3_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时4开关
		if myTable["week4timer4Effect"] == 0x08 then
			streams["week4_timer4_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer4Effect"] == 0x00 then
			streams["week4_timer4_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时5开关
		if myTable["week4timer5Effect"] == 0x10 then
			streams["week4_timer5_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer5Effect"] == 0x00 then
			streams["week4_timer5_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时6开关
		if myTable["week4timer6Effect"] == 0x20 then
			streams["week4_timer6_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer6Effect"] == 0x00 then
			streams["week4_timer6_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时器1设定模式
		if myTable["week4timer1SetMode"] == 0 then
			streams["week4_timer1_set_mode"] = "off"
		elseif myTable["week4timer1SetMode"] == 1 then
			streams["week4_timer1_set_mode"] = "heat"
		elseif myTable["week4timer1SetMode"] == 2 then
			streams["week4_timer1_set_mode"] = "dhw"
		elseif myTable["week4timer1SetMode"] == 3 then
			streams["week4_timer1_set_mode"] = "cool"
		elseif myTable["week4timer1SetMode"] == 4 then
			streams["week4_timer1_set_mode"] = "waterpump"
		elseif myTable["week4timer1SetMode"] == 5 then
			streams["week4_timer1_set_mode"] = "auto"
		end

		-- 周四定时1静音开关
		if myTable["week4timer1MutSet"] == 0x01 then
			streams["week4_timer1_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer1MutSet"] == 0x00 then
			streams["week4_timer1_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时1强热开关
		if myTable["week4timer1FrcHeSet"] == 0x01 then
			streams["week4_timer1_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer1FrcHeSet"] == 0x00 then
			streams["week4_timer1_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时1静音等级
		if myTable["week4timer1MutLev"] == 0x01 then
			streams["week4_timer1_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week4timer1MutLev"] == 0x00 then
			streams["week4_timer1_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week4_timer1_set_temp"] = int2String(myTable["week4timer1SetTemp"]) -- 周四定时器1设定温度
		streams["week4_timer1_open_time_hour"] = int2String(myTable["week4timer1OpenTimeHour"]) -- 周四定时器1开始时间：时
		streams["week4_timer1_open_time_min"] = int2String(myTable["week4timer1OpenTimeMin"]) -- 周四定时器1开始时间：分
		streams["week4_timer1_close_time_hour"] = int2String(myTable["week4timer1CloseTimeHour"]) -- 周四定时器1结束时间：时
		streams["week4_timer1_close_time_min"] = int2String(myTable["week4timer1CloseTimeMin"]) -- 周四定时器1结束时间：分

		-- 周四定时器2设定模式
		if myTable["week4timer2SetMode"] == 0 then
			streams["week4_timer2_set_mode"] = "off"
		elseif myTable["week4timer2SetMode"] == 1 then
			streams["week4_timer2_set_mode"] = "heat"
		elseif myTable["week4timer2SetMode"] == 2 then
			streams["week4_timer2_set_mode"] = "dhw"
		elseif myTable["week4timer2SetMode"] == 3 then
			streams["week4_timer2_set_mode"] = "cool"
		elseif myTable["week4timer2SetMode"] == 4 then
			streams["week4_timer2_set_mode"] = "waterpump"
		elseif myTable["week4timer2SetMode"] == 5 then
			streams["week4_timer2_set_mode"] = "auto"
		end

		-- 周四定时2静音开关
		if myTable["week4timer2MutSet"] == 0x01 then
			streams["week4_timer2_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer2MutSet"] == 0x00 then
			streams["week4_timer2_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时2强热开关
		if myTable["week4timer2FrcHeSet"] == 0x01 then
			streams["week4_timer2_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer2FrcHeSet"] == 0x00 then
			streams["week4_timer2_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时2静音等级
		if myTable["week4timer2MutLev"] == 0x01 then
			streams["week4_timer2_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week4timer2MutLev"] == 0x00 then
			streams["week4_timer2_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week4_timer2_set_temp"] = int2String(myTable["week4timer2SetTemp"]) -- 周四定时器2设定温度
		streams["week4_timer2_open_time_hour"] = int2String(myTable["week4timer2OpenTimeHour"]) -- 周四定时器2开始时间：时
		streams["week4_timer2_open_time_min"] = int2String(myTable["week4timer2OpenTimeMin"]) -- 周四定时器2开始时间：分
		streams["week4_timer2_close_time_hour"] = int2String(myTable["week4timer2CloseTimeHour"]) -- 周四定时器2结束时间：时
		streams["week4_timer2_close_time_min"] = int2String(myTable["week4timer2CloseTimeMin"]) -- 周四定时器2结束时间：分

		-- 周四定时器3设定模式
		if myTable["week4timer3SetMode"] == 0 then
			streams["week4_timer3_set_mode"] = "off"
		elseif myTable["week4timer3SetMode"] == 1 then
			streams["week4_timer3_set_mode"] = "heat"
		elseif myTable["week4timer3SetMode"] == 2 then
			streams["week4_timer3_set_mode"] = "dhw"
		elseif myTable["week4timer3SetMode"] == 3 then
			streams["week4_timer3_set_mode"] = "cool"
		elseif myTable["week4timer3SetMode"] == 4 then
			streams["week4_timer3_set_mode"] = "waterpump"
		elseif myTable["week4timer3SetMode"] == 5 then
			streams["week4_timer3_set_mode"] = "auto"
		end

		-- 周四定时3静音开关
		if myTable["week4timer3MutSet"] == 0x01 then
			streams["week4_timer3_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer3MutSet"] == 0x00 then
			streams["week4_timer3_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时3强热开关
		if myTable["week4timer3FrcHeSet"] == 0x01 then
			streams["week4_timer3_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer3FrcHeSet"] == 0x00 then
			streams["week4_timer3_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时3静音等级
		if myTable["week4timer3MutLev"] == 0x01 then
			streams["week4_timer3_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week4timer3MutLev"] == 0x00 then
			streams["week4_timer3_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week4_timer3_set_temp"] = int2String(myTable["week4timer3SetTemp"]) -- 周四定时器3设定温度
		streams["week4_timer3_open_time_hour"] = int2String(myTable["week4timer3OpenTimeHour"]) -- 周四定时器3开始时间：时
		streams["week4_timer3_open_time_min"] = int2String(myTable["week4timer3OpenTimeMin"]) -- 周四定时器3开始时间：分
		streams["week4_timer3_close_time_hour"] = int2String(myTable["week4timer3CloseTimeHour"]) -- 周四定时器3结束时间：时
		streams["week4_timer3_close_time_min"] = int2String(myTable["week4timer3CloseTimeMin"]) -- 周四定时器3结束时间：分

		-- 周四定时器4设定模式
		if myTable["week4timer4SetMode"] == 0 then
			streams["week4_timer4_set_mode"] = "off"
		elseif myTable["week4timer4SetMode"] == 1 then
			streams["week4_timer4_set_mode"] = "heat"
		elseif myTable["week4timer4SetMode"] == 2 then
			streams["week4_timer4_set_mode"] = "dhw"
		elseif myTable["week4timer4SetMode"] == 3 then
			streams["week4_timer4_set_mode"] = "cool"
		elseif myTable["week4timer4SetMode"] == 4 then
			streams["week4_timer4_set_mode"] = "waterpump"
		elseif myTable["week4timer4SetMode"] == 5 then
			streams["week4_timer4_set_mode"] = "auto"
		end

		-- 周四定时4静音开关
		if myTable["week4timer4MutSet"] == 0x01 then
			streams["week4_timer4_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer4MutSet"] == 0x00 then
			streams["week4_timer4_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时4强热开关
		if myTable["week4timer4FrcHeSet"] == 0x01 then
			streams["week4_timer4_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer4FrcHeSet"] == 0x00 then
			streams["week4_timer4_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时4静音等级
		if myTable["week4timer4MutLev"] == 0x01 then
			streams["week4_timer4_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week4timer4MutLev"] == 0x00 then
			streams["week4_timer4_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week4_timer4_set_temp"] = int2String(myTable["week4timer4SetTemp"]) -- 周四定时器4设定温度
		streams["week4_timer4_open_time_hour"] = int2String(myTable["week4timer4OpenTimeHour"]) -- 周四定时器4开始时间：时
		streams["week4_timer4_open_time_min"] = int2String(myTable["week4timer4OpenTimeMin"]) -- 周四定时器4开始时间：分
		streams["week4_timer4_close_time_hour"] = int2String(myTable["week4timer4CloseTimeHour"]) -- 周四定时器4结束时间：时
		streams["week4_timer4_close_time_min"] = int2String(myTable["week4timer4CloseTimeMin"]) -- 周四定时器4结束时间：分

		-- 周四定时器5设定模式
		if myTable["week4timer5SetMode"] == 0 then
			streams["week4_timer5_set_mode"] = "off"
		elseif myTable["week4timer5SetMode"] == 1 then
			streams["week4_timer5_set_mode"] = "heat"
		elseif myTable["week4timer5SetMode"] == 2 then
			streams["week4_timer5_set_mode"] = "dhw"
		elseif myTable["week4timer5SetMode"] == 3 then
			streams["week4_timer5_set_mode"] = "cool"
		elseif myTable["week4timer5SetMode"] == 4 then
			streams["week4_timer5_set_mode"] = "waterpump"
		elseif myTable["week4timer5SetMode"] == 5 then
			streams["week4_timer5_set_mode"] = "auto"
		end

		-- 周四定时5静音开关
		if myTable["week4timer5MutSet"] == 0x01 then
			streams["week4_timer5_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer5MutSet"] == 0x00 then
			streams["week4_timer5_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时5强热开关
		if myTable["week4timer5FrcHeSet"] == 0x01 then
			streams["week4_timer5_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer5FrcHeSet"] == 0x00 then
			streams["week4_timer5_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时5静音等级
		if myTable["week4timer5MutLev"] == 0x01 then
			streams["week4_timer5_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week4timer5MutLev"] == 0x00 then
			streams["week4_timer5_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week4_timer5_set_temp"] = int2String(myTable["week4timer5SetTemp"]) -- 周四定时器5设定温度
		streams["week4_timer5_open_time_hour"] = int2String(myTable["week4timer5OpenTimeHour"]) -- 周四定时器5开始时间：时
		streams["week4_timer5_open_time_min"] = int2String(myTable["week4timer5OpenTimeMin"]) -- 周四定时器5开始时间：分
		streams["week4_timer5_close_time_hour"] = int2String(myTable["week4timer5CloseTimeHour"]) -- 周四定时器5结束时间：时
		streams["week4_timer5_close_time_min"] = int2String(myTable["week4timer5CloseTimeMin"]) -- 周四定时器5结束时间：分

		-- 周四定时器6设定模式
		if myTable["week4timer6SetMode"] == 0 then
			streams["week4_timer6_set_mode"] = "off"
		elseif myTable["week4timer6SetMode"] == 1 then
			streams["week4_timer6_set_mode"] = "heat"
		elseif myTable["week4timer6SetMode"] == 2 then
			streams["week4_timer6_set_mode"] = "dhw"
		elseif myTable["week4timer6SetMode"] == 3 then
			streams["week4_timer6_set_mode"] = "cool"
		elseif myTable["week4timer6SetMode"] == 4 then
			streams["week4_timer6_set_mode"] = "waterpump"
		elseif myTable["week4timer6SetMode"] == 5 then
			streams["week4_timer6_set_mode"] = "auto"
		end

		-- 周四定时6静音开关
		if myTable["week4timer6MutSet"] == 0x01 then
			streams["week4_timer6_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer6MutSet"] == 0x00 then
			streams["week4_timer6_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时6强热开关
		if myTable["week4timer6FrcHeSet"] == 0x01 then
			streams["week4_timer6_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week4timer6FrcHeSet"] == 0x00 then
			streams["week4_timer6_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周四定时6静音等级
		if myTable["week4timer6MutLev"] == 0x01 then
			streams["week4_timer6_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week4timer6MutLev"] == 0x00 then
			streams["week4_timer6_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week4_timer6_set_temp"] = int2String(myTable["week4timer6SetTemp"]) -- 周四定时器6设定温度
		streams["week4_timer6_open_time_hour"] = int2String(myTable["week4timer6OpenTimeHour"]) -- 周四定时器6开始时间：时
		streams["week4_timer6_open_time_min"] = int2String(myTable["week4timer6OpenTimeMin"]) -- 周四定时器6开始时间：分
		streams["week4_timer6_close_time_hour"] = int2String(myTable["week4timer6CloseTimeHour"]) -- 周四定时器6结束时间：时
		streams["week4_timer6_close_time_min"] = int2String(myTable["week4timer6CloseTimeMin"]) -- 周四定时器6结束时间：分

		-- 周四定时1是否有效
		if myTable["week4timer1Valid"] == 0x01 then
			streams["week4_timer1_valid"] = VALUE_VALID
		elseif myTable["week4timer1Valid"] == 0x00 then
			streams["week4_timer1_valid"] = VALUE_INVALID
		end

		-- 周四定时2是否有效
		if myTable["week4timer2Valid"] == 0x02 then
			streams["week4_timer2_valid"] = VALUE_VALID
		elseif myTable["week4timer2Valid"] == 0x00 then
			streams["week4_timer2_valid"] = VALUE_INVALID
		end

		-- 周四定时3是否有效
		if myTable["week4timer3Valid"] == 0x04 then
			streams["week4_timer3_valid"] = VALUE_VALID
		elseif myTable["week4timer3Valid"] == 0x00 then
			streams["week4_timer3_valid"] = VALUE_INVALID
		end

		-- 周四定时4是否有效
		if myTable["week4timer4Valid"] == 0x08 then
			streams["week4_timer4_valid"] = VALUE_VALID
		elseif myTable["week4timer4Valid"] == 0x00 then
			streams["week4_timer4_valid"] = VALUE_INVALID
		end

		-- 周四定时5是否有效
		if myTable["week4timer5Valid"] == 0x10 then
			streams["week4_timer5_valid"] = VALUE_VALID
		elseif myTable["week4timer5Valid"] == 0x00 then
			streams["week4_timer5_valid"] = VALUE_INVALID
		end

		-- 周四定时6是否有效
		if myTable["week4timer6Valid"] == 0x20 then
			streams["week4_timer6_valid"] = VALUE_VALID
		elseif myTable["week4timer6Valid"] == 0x00 then
			streams["week4_timer6_valid"] = VALUE_INVALID
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x09))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x09))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x09))
	then
		-- 周五定时1开关
		if myTable["week5timer1Effect"] == 0x01 then
			streams["week5_timer1_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer1Effect"] == 0x00 then
			streams["week5_timer1_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时2开关
		if myTable["week5timer2Effect"] == 0x02 then
			streams["week5_timer2_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer2Effect"] == 0x00 then
			streams["week5_timer2_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时3开关
		if myTable["week5timer3Effect"] == 0x04 then
			streams["week5_timer3_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer3Effect"] == 0x00 then
			streams["week5_timer3_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时4开关
		if myTable["week5timer4Effect"] == 0x08 then
			streams["week5_timer4_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer4Effect"] == 0x00 then
			streams["week5_timer4_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时5开关
		if myTable["week5timer5Effect"] == 0x10 then
			streams["week5_timer5_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer5Effect"] == 0x00 then
			streams["week5_timer5_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时6开关
		if myTable["week5timer6Effect"] == 0x20 then
			streams["week5_timer6_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer6Effect"] == 0x00 then
			streams["week5_timer6_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时器1设定模式
		if myTable["week5timer1SetMode"] == 0 then
			streams["week5_timer1_set_mode"] = "off"
		elseif myTable["week5timer1SetMode"] == 1 then
			streams["week5_timer1_set_mode"] = "heat"
		elseif myTable["week5timer1SetMode"] == 2 then
			streams["week5_timer1_set_mode"] = "dhw"
		elseif myTable["week5timer1SetMode"] == 3 then
			streams["week5_timer1_set_mode"] = "cool"
		elseif myTable["week5timer1SetMode"] == 4 then
			streams["week5_timer1_set_mode"] = "waterpump"
		elseif myTable["week5timer1SetMode"] == 5 then
			streams["week5_timer1_set_mode"] = "auto"
		end

		-- 周五定时1静音开关
		if myTable["week5timer1MutSet"] == 0x01 then
			streams["week5_timer1_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer1MutSet"] == 0x00 then
			streams["week5_timer1_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时1强热开关
		if myTable["week5timer1FrcHeSet"] == 0x01 then
			streams["week5_timer1_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer1FrcHeSet"] == 0x00 then
			streams["week5_timer1_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时1静音等级
		if myTable["week5timer1MutLev"] == 0x01 then
			streams["week5_timer1_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week5timer1MutLev"] == 0x00 then
			streams["week5_timer1_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week5_timer1_set_temp"] = int2String(myTable["week5timer1SetTemp"]) -- 周五定时器1设定温度
		streams["week5_timer1_open_time_hour"] = int2String(myTable["week5timer1OpenTimeHour"]) -- 周五定时器1开始时间：时
		streams["week5_timer1_open_time_min"] = int2String(myTable["week5timer1OpenTimeMin"]) -- 周五定时器1开始时间：分
		streams["week5_timer1_close_time_hour"] = int2String(myTable["week5timer1CloseTimeHour"]) -- 周五定时器1结束时间：时
		streams["week5_timer1_close_time_min"] = int2String(myTable["week5timer1CloseTimeMin"]) -- 周五定时器1结束时间：分

		-- 周五定时器2设定模式
		if myTable["week5timer2SetMode"] == 0 then
			streams["week5_timer2_set_mode"] = "off"
		elseif myTable["week5timer2SetMode"] == 1 then
			streams["week5_timer2_set_mode"] = "heat"
		elseif myTable["week5timer2SetMode"] == 2 then
			streams["week5_timer2_set_mode"] = "dhw"
		elseif myTable["week5timer2SetMode"] == 3 then
			streams["week5_timer2_set_mode"] = "cool"
		elseif myTable["week5timer2SetMode"] == 4 then
			streams["week5_timer2_set_mode"] = "waterpump"
		elseif myTable["week5timer2SetMode"] == 5 then
			streams["week5_timer2_set_mode"] = "auto"
		end

		-- 周五定时2静音开关
		if myTable["week5timer2MutSet"] == 0x01 then
			streams["week5_timer2_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer2MutSet"] == 0x00 then
			streams["week5_timer2_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时2强热开关
		if myTable["week5timer2FrcHeSet"] == 0x01 then
			streams["week5_timer2_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer2FrcHeSet"] == 0x00 then
			streams["week5_timer2_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时2静音等级
		if myTable["week5timer2MutLev"] == 0x01 then
			streams["week5_timer2_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week5timer2MutLev"] == 0x00 then
			streams["week5_timer2_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week5_timer2_set_temp"] = int2String(myTable["week5timer2SetTemp"]) -- 周五定时器2设定温度
		streams["week5_timer2_open_time_hour"] = int2String(myTable["week5timer2OpenTimeHour"]) -- 周五定时器2开始时间：时
		streams["week5_timer2_open_time_min"] = int2String(myTable["week5timer2OpenTimeMin"]) -- 周五定时器2开始时间：分
		streams["week5_timer2_close_time_hour"] = int2String(myTable["week5timer2CloseTimeHour"]) -- 周五定时器2结束时间：时
		streams["week5_timer2_close_time_min"] = int2String(myTable["week5timer2CloseTimeMin"]) -- 周五定时器2结束时间：分

		-- 周五定时器3设定模式
		if myTable["week5timer3SetMode"] == 0 then
			streams["week5_timer3_set_mode"] = "off"
		elseif myTable["week5timer3SetMode"] == 1 then
			streams["week5_timer3_set_mode"] = "heat"
		elseif myTable["week5timer3SetMode"] == 2 then
			streams["week5_timer3_set_mode"] = "dhw"
		elseif myTable["week5timer3SetMode"] == 3 then
			streams["week5_timer3_set_mode"] = "cool"
		elseif myTable["week5timer3SetMode"] == 4 then
			streams["week5_timer3_set_mode"] = "waterpump"
		elseif myTable["week5timer3SetMode"] == 5 then
			streams["week5_timer3_set_mode"] = "auto"
		end

		-- 周五定时3静音开关
		if myTable["week5timer3MutSet"] == 0x01 then
			streams["week5_timer3_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer3MutSet"] == 0x00 then
			streams["week5_timer3_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时3强热开关
		if myTable["week5timer3FrcHeSet"] == 0x01 then
			streams["week5_timer3_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer3FrcHeSet"] == 0x00 then
			streams["week5_timer3_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时3静音等级
		if myTable["week5timer3MutLev"] == 0x01 then
			streams["week5_timer3_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week5timer3MutLev"] == 0x00 then
			streams["week5_timer3_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week5_timer3_set_temp"] = int2String(myTable["week5timer3SetTemp"]) -- 周五定时器3设定温度
		streams["week5_timer3_open_time_hour"] = int2String(myTable["week5timer3OpenTimeHour"]) -- 周五定时器3开始时间：时
		streams["week5_timer3_open_time_min"] = int2String(myTable["week5timer3OpenTimeMin"]) -- 周五定时器3开始时间：分
		streams["week5_timer3_close_time_hour"] = int2String(myTable["week5timer3CloseTimeHour"]) -- 周五定时器3结束时间：时
		streams["week5_timer3_close_time_min"] = int2String(myTable["week5timer3CloseTimeMin"]) -- 周五定时器3结束时间：分

		-- 周五定时器4设定模式
		if myTable["week5timer4SetMode"] == 0 then
			streams["week5_timer4_set_mode"] = "off"
		elseif myTable["week5timer4SetMode"] == 1 then
			streams["week5_timer4_set_mode"] = "heat"
		elseif myTable["week5timer4SetMode"] == 2 then
			streams["week5_timer4_set_mode"] = "dhw"
		elseif myTable["week5timer4SetMode"] == 3 then
			streams["week5_timer4_set_mode"] = "cool"
		elseif myTable["week5timer4SetMode"] == 4 then
			streams["week5_timer4_set_mode"] = "waterpump"
		elseif myTable["week5timer4SetMode"] == 5 then
			streams["week5_timer4_set_mode"] = "auto"
		end

		-- 周五定时4静音开关
		if myTable["week5timer4MutSet"] == 0x01 then
			streams["week5_timer4_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer4MutSet"] == 0x00 then
			streams["week5_timer4_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时4强热开关
		if myTable["week5timer4FrcHeSet"] == 0x01 then
			streams["week5_timer4_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer4FrcHeSet"] == 0x00 then
			streams["week5_timer4_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时4静音等级
		if myTable["week5timer4MutLev"] == 0x01 then
			streams["week5_timer4_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week5timer4MutLev"] == 0x00 then
			streams["week5_timer4_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week5_timer4_set_temp"] = int2String(myTable["week5timer4SetTemp"]) -- 周五定时器4设定温度
		streams["week5_timer4_open_time_hour"] = int2String(myTable["week5timer4OpenTimeHour"]) -- 周五定时器4开始时间：时
		streams["week5_timer4_open_time_min"] = int2String(myTable["week5timer4OpenTimeMin"]) -- 周五定时器4开始时间：分
		streams["week5_timer4_close_time_hour"] = int2String(myTable["week5timer4CloseTimeHour"]) -- 周五定时器4结束时间：时
		streams["week5_timer4_close_time_min"] = int2String(myTable["week5timer4CloseTimeMin"]) -- 周五定时器4结束时间：分

		-- 周五定时器5设定模式
		if myTable["week5timer5SetMode"] == 0 then
			streams["week5_timer5_set_mode"] = "off"
		elseif myTable["week5timer5SetMode"] == 1 then
			streams["week5_timer5_set_mode"] = "heat"
		elseif myTable["week5timer5SetMode"] == 2 then
			streams["week5_timer5_set_mode"] = "dhw"
		elseif myTable["week5timer5SetMode"] == 3 then
			streams["week5_timer5_set_mode"] = "cool"
		elseif myTable["week5timer5SetMode"] == 4 then
			streams["week5_timer5_set_mode"] = "waterpump"
		elseif myTable["week5timer5SetMode"] == 5 then
			streams["week5_timer5_set_mode"] = "auto"
		end

		-- 周五定时5静音开关
		if myTable["week5timer5MutSet"] == 0x01 then
			streams["week5_timer5_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer5MutSet"] == 0x00 then
			streams["week5_timer5_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时5强热开关
		if myTable["week5timer5FrcHeSet"] == 0x01 then
			streams["week5_timer5_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer5FrcHeSet"] == 0x00 then
			streams["week5_timer5_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时5静音等级
		if myTable["week5timer5MutLev"] == 0x01 then
			streams["week5_timer5_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week5timer5MutLev"] == 0x00 then
			streams["week5_timer5_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week5_timer5_set_temp"] = int2String(myTable["week5timer5SetTemp"]) -- 周五定时器5设定温度
		streams["week5_timer5_open_time_hour"] = int2String(myTable["week5timer5OpenTimeHour"]) -- 周五定时器5开始时间：时
		streams["week5_timer5_open_time_min"] = int2String(myTable["week5timer5OpenTimeMin"]) -- 周五定时器5开始时间：分
		streams["week5_timer5_close_time_hour"] = int2String(myTable["week5timer5CloseTimeHour"]) -- 周五定时器5结束时间：时
		streams["week5_timer5_close_time_min"] = int2String(myTable["week5timer5CloseTimeMin"]) -- 周五定时器5结束时间：分

		-- 周五定时器6设定模式
		if myTable["week5timer6SetMode"] == 0 then
			streams["week5_timer6_set_mode"] = "off"
		elseif myTable["week5timer6SetMode"] == 1 then
			streams["week5_timer6_set_mode"] = "heat"
		elseif myTable["week5timer6SetMode"] == 2 then
			streams["week5_timer6_set_mode"] = "dhw"
		elseif myTable["week5timer6SetMode"] == 3 then
			streams["week5_timer6_set_mode"] = "cool"
		elseif myTable["week5timer6SetMode"] == 4 then
			streams["week5_timer6_set_mode"] = "waterpump"
		elseif myTable["week5timer6SetMode"] == 5 then
			streams["week5_timer6_set_mode"] = "auto"
		end

		-- 周五定时6静音开关
		if myTable["week5timer6MutSet"] == 0x01 then
			streams["week5_timer6_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer6MutSet"] == 0x00 then
			streams["week5_timer6_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时6强热开关
		if myTable["week5timer6FrcHeSet"] == 0x01 then
			streams["week5_timer6_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week5timer6FrcHeSet"] == 0x00 then
			streams["week5_timer6_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周五定时6静音等级
		if myTable["week5timer6MutLev"] == 0x01 then
			streams["week5_timer6_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week5timer6MutLev"] == 0x00 then
			streams["week5_timer6_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week5_timer6_open_time_hour"] = int2String(myTable["week5timer6OpenTimeHour"]) -- 周五定时器6开始时间：时
		streams["week5_timer6_open_time_min"] = int2String(myTable["week5timer6OpenTimeMin"]) -- 周五定时器6开始时间：分
		streams["week5_timer6_close_time_hour"] = int2String(myTable["week5timer6CloseTimeHour"]) -- 周五定时器6结束时间：时
		streams["week5_timer6_close_time_min"] = int2String(myTable["week5timer6CloseTimeMin"]) -- 周五定时器6结束时间：分

		-- 周五定时1是否有效
		if myTable["week5timer1Valid"] == 0x01 then
			streams["week5_timer1_valid"] = VALUE_VALID
		elseif myTable["week5timer1Valid"] == 0x00 then
			streams["week5_timer1_valid"] = VALUE_INVALID
		end

		-- 周五定时2是否有效
		if myTable["week5timer2Valid"] == 0x02 then
			streams["week5_timer2_valid"] = VALUE_VALID
		elseif myTable["week5timer2Valid"] == 0x00 then
			streams["week5_timer2_valid"] = VALUE_INVALID
		end

		-- 周五定时3是否有效
		if myTable["week5timer3Valid"] == 0x04 then
			streams["week5_timer3_valid"] = VALUE_VALID
		elseif myTable["week5timer3Valid"] == 0x00 then
			streams["week5_timer3_valid"] = VALUE_INVALID
		end

		-- 周五定时4是否有效
		if myTable["week5timer4Valid"] == 0x08 then
			streams["week5_timer4_valid"] = VALUE_VALID
		elseif myTable["week5timer4Valid"] == 0x00 then
			streams["week5_timer4_valid"] = VALUE_INVALID
		end

		-- 周五定时5是否有效
		if myTable["week5timer5Valid"] == 0x10 then
			streams["week5_timer5_valid"] = VALUE_VALID
		elseif myTable["week5timer5Valid"] == 0x00 then
			streams["week5_timer5_valid"] = VALUE_INVALID
		end

		-- 周五定时6是否有效
		if myTable["week5timer6Valid"] == 0x20 then
			streams["week5_timer6_valid"] = VALUE_VALID
		elseif myTable["week5timer6Valid"] == 0x00 then
			streams["week5_timer6_valid"] = VALUE_INVALID
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x0a))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x0a))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x0a))
	then
		-- 周六定时1开关
		if myTable["week6timer1Effect"] == 0x01 then
			streams["week6_timer1_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer1Effect"] == 0x00 then
			streams["week6_timer1_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时2开关
		if myTable["week6timer2Effect"] == 0x02 then
			streams["week6_timer2_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer2Effect"] == 0x00 then
			streams["week6_timer2_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时3开关
		if myTable["week6timer3Effect"] == 0x04 then
			streams["week6_timer3_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer3Effect"] == 0x00 then
			streams["week6_timer3_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时4开关
		if myTable["week6timer4Effect"] == 0x08 then
			streams["week6_timer4_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer4Effect"] == 0x00 then
			streams["week6_timer4_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时5开关
		if myTable["week6timer5Effect"] == 0x10 then
			streams["week6_timer5_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer5Effect"] == 0x00 then
			streams["week6_timer5_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时6开关
		if myTable["week6timer6Effect"] == 0x20 then
			streams["week6_timer6_effect"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer6Effect"] == 0x00 then
			streams["week6_timer6_effect"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时器1设定模式
		if myTable["week6timer1SetMode"] == 0 then
			streams["week6_timer1_set_mode"] = "off"
		elseif myTable["week6timer1SetMode"] == 1 then
			streams["week6_timer1_set_mode"] = "heat"
		elseif myTable["week6timer1SetMode"] == 2 then
			streams["week6_timer1_set_mode"] = "dhw"
		elseif myTable["week6timer1SetMode"] == 3 then
			streams["week6_timer1_set_mode"] = "cool"
		elseif myTable["week6timer1SetMode"] == 4 then
			streams["week6_timer1_set_mode"] = "waterpump"
		elseif myTable["week6timer1SetMode"] == 5 then
			streams["week6_timer1_set_mode"] = "auto"
		end

		-- 周六定时1静音开关
		if myTable["week6timer1MutSet"] == 0x01 then
			streams["week6_timer1_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer1MutSet"] == 0x00 then
			streams["week6_timer1_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时1强热开关
		if myTable["week6timer1FrcHeSet"] == 0x01 then
			streams["week6_timer1_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer1FrcHeSet"] == 0x00 then
			streams["week6_timer1_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时1静音等级
		if myTable["week6timer1MutLev"] == 0x01 then
			streams["week6_timer1_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week6timer1MutLev"] == 0x00 then
			streams["week6_timer1_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week6_timer1_set_temp"] = int2String(myTable["week6timer1SetTemp"]) -- 周六定时器1设定温度
		streams["week6_timer1_open_time_hour"] = int2String(myTable["week6timer1OpenTimeHour"]) -- 周六定时器1开始时间：时
		streams["week6_timer1_open_time_min"] = int2String(myTable["week6timer1OpenTimeMin"]) -- 周六定时器1开始时间：分
		streams["week6_timer1_close_time_hour"] = int2String(myTable["week6timer1CloseTimeHour"]) -- 周六定时器1结束时间：时
		streams["week6_timer1_close_time_min"] = int2String(myTable["week6timer1CloseTimeMin"]) -- 周六定时器1结束时间：分

		-- 周六定时器2设定模式
		if myTable["week6timer2SetMode"] == 0 then
			streams["week6_timer2_set_mode"] = "off"
		elseif myTable["week6timer2SetMode"] == 1 then
			streams["week6_timer2_set_mode"] = "heat"
		elseif myTable["week6timer2SetMode"] == 2 then
			streams["week6_timer2_set_mode"] = "dhw"
		elseif myTable["week6timer2SetMode"] == 3 then
			streams["week6_timer2_set_mode"] = "cool"
		elseif myTable["week6timer2SetMode"] == 4 then
			streams["week6_timer2_set_mode"] = "waterpump"
		elseif myTable["week6timer2SetMode"] == 5 then
			streams["week6_timer2_set_mode"] = "auto"
		end

		-- 周六定时2静音开关
		if myTable["week6timer2MutSet"] == 0x01 then
			streams["week6_timer2_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer2MutSet"] == 0x00 then
			streams["week6_timer2_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时2强热开关
		if myTable["week6timer2FrcHeSet"] == 0x01 then
			streams["week6_timer2_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer2FrcHeSet"] == 0x00 then
			streams["week6_timer2_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时2静音等级
		if myTable["week6timer2MutLev"] == 0x01 then
			streams["week6_timer2_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week6timer2MutLev"] == 0x00 then
			streams["week6_timer2_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week6_timer2_set_temp"] = int2String(myTable["week6timer2SetTemp"]) -- 周六定时器2设定温度
		streams["week6_timer2_open_time_hour"] = int2String(myTable["week6timer2OpenTimeHour"]) -- 周六定时器2开始时间：时
		streams["week6_timer2_open_time_min"] = int2String(myTable["week6timer2OpenTimeMin"]) -- 周六定时器2开始时间：分
		streams["week6_timer2_close_time_hour"] = int2String(myTable["week6timer2CloseTimeHour"]) -- 周六定时器2结束时间：时
		streams["week6_timer2_close_time_min"] = int2String(myTable["week6timer2CloseTimeMin"]) -- 周六定时器2结束时间：分

		-- 周六定时器3设定模式
		if myTable["week6timer3SetMode"] == 0 then
			streams["week6_timer3_set_mode"] = "off"
		elseif myTable["week6timer3SetMode"] == 1 then
			streams["week6_timer3_set_mode"] = "heat"
		elseif myTable["week6timer3SetMode"] == 2 then
			streams["week6_timer3_set_mode"] = "dhw"
		elseif myTable["week6timer3SetMode"] == 3 then
			streams["week6_timer3_set_mode"] = "cool"
		elseif myTable["week6timer3SetMode"] == 4 then
			streams["week6_timer3_set_mode"] = "waterpump"
		elseif myTable["week6timer3SetMode"] == 5 then
			streams["week6_timer3_set_mode"] = "auto"
		end

		-- 周六定时3静音开关
		if myTable["week6timer3MutSet"] == 0x01 then
			streams["week6_timer3_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer3MutSet"] == 0x00 then
			streams["week6_timer3_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时3强热开关
		if myTable["week6timer3FrcHeSet"] == 0x01 then
			streams["week6_timer3_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer3FrcHeSet"] == 0x00 then
			streams["week6_timer3_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时3静音等级
		if myTable["week6timer3MutLev"] == 0x01 then
			streams["week6_timer3_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week6timer3MutLev"] == 0x00 then
			streams["week6_timer3_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week6_timer3_set_temp"] = int2String(myTable["week6timer3SetTemp"]) -- 周六定时器3设定温度
		streams["week6_timer3_open_time_hour"] = int2String(myTable["week6timer3OpenTimeHour"]) -- 周六定时器3开始时间：时
		streams["week6_timer3_open_time_min"] = int2String(myTable["week6timer3OpenTimeMin"]) -- 周六定时器3开始时间：分
		streams["week6_timer3_close_time_hour"] = int2String(myTable["week6timer3CloseTimeHour"]) -- 周六定时器3结束时间：时
		streams["week6_timer3_close_time_min"] = int2String(myTable["week6timer3CloseTimeMin"]) -- 周六定时器3结束时间：分

		-- 周六定时器4设定模式
		if myTable["week6timer4SetMode"] == 0 then
			streams["week6_timer4_set_mode"] = "off"
		elseif myTable["week6timer4SetMode"] == 1 then
			streams["week6_timer4_set_mode"] = "heat"
		elseif myTable["week6timer4SetMode"] == 2 then
			streams["week6_timer4_set_mode"] = "dhw"
		elseif myTable["week6timer4SetMode"] == 3 then
			streams["week6_timer4_set_mode"] = "cool"
		elseif myTable["week6timer4SetMode"] == 4 then
			streams["week6_timer4_set_mode"] = "waterpump"
		elseif myTable["week6timer4SetMode"] == 5 then
			streams["week6_timer4_set_mode"] = "auto"
		end

		-- 周六定时4静音开关
		if myTable["week6timer4MutSet"] == 0x01 then
			streams["week6_timer4_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer4MutSet"] == 0x00 then
			streams["week6_timer4_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时4强热开关
		if myTable["week6timer4FrcHeSet"] == 0x01 then
			streams["week6_timer4_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer4FrcHeSet"] == 0x00 then
			streams["week6_timer4_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时4静音等级
		if myTable["week6timer4MutLev"] == 0x01 then
			streams["week6_timer4_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week6timer4MutLev"] == 0x00 then
			streams["week6_timer4_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week6_timer4_set_temp"] = int2String(myTable["week6timer4SetTemp"]) -- 周六定时器4设定温度
		streams["week6_timer4_open_time_hour"] = int2String(myTable["week6timer4OpenTimeHour"]) -- 周六定时器4开始时间：时
		streams["week6_timer4_open_time_min"] = int2String(myTable["week6timer4OpenTimeMin"]) -- 周六定时器4开始时间：分
		streams["week6_timer4_close_time_hour"] = int2String(myTable["week6timer4CloseTimeHour"]) -- 周六定时器4结束时间：时
		streams["week6_timer4_close_time_min"] = int2String(myTable["week6timer4CloseTimeMin"]) -- 周六定时器4结束时间：分

		-- 周六定时器5设定模式
		if myTable["week6timer5SetMode"] == 0 then
			streams["week6_timer5_set_mode"] = "off"
		elseif myTable["week6timer5SetMode"] == 1 then
			streams["week6_timer5_set_mode"] = "heat"
		elseif myTable["week6timer5SetMode"] == 2 then
			streams["week6_timer5_set_mode"] = "dhw"
		elseif myTable["week6timer5SetMode"] == 3 then
			streams["week6_timer5_set_mode"] = "cool"
		elseif myTable["week6timer5SetMode"] == 4 then
			streams["week6_timer5_set_mode"] = "waterpump"
		elseif myTable["week6timer5SetMode"] == 5 then
			streams["week6_timer5_set_mode"] = "auto"
		end

		-- 周六定时5静音开关
		if myTable["week6timer5MutSet"] == 0x01 then
			streams["week6_timer5_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer5MutSet"] == 0x00 then
			streams["week6_timer5_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时5强热开关
		if myTable["week6timer5FrcHeSet"] == 0x01 then
			streams["week6_timer5_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer5FrcHeSet"] == 0x00 then
			streams["week6_timer5_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时5静音等级
		if myTable["week6timer5MutLev"] == 0x01 then
			streams["week6_timer5_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week6timer5MutLev"] == 0x00 then
			streams["week6_timer5_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week6_timer5_set_temp"] = int2String(myTable["week6timer5SetTemp"]) -- 周六定时器5设定温度
		streams["week6_timer5_open_time_hour"] = int2String(myTable["week6timer5OpenTimeHour"]) -- 周六定时器5开始时间：时
		streams["week6_timer5_open_time_min"] = int2String(myTable["week6timer5OpenTimeMin"]) -- 周六定时器5开始时间：分
		streams["week6_timer5_close_time_hour"] = int2String(myTable["week6timer5CloseTimeHour"]) -- 周六定时器5结束时间：时
		streams["week6_timer5_close_time_min"] = int2String(myTable["week6timer5CloseTimeMin"]) -- 周六定时器5结束时间：分

		-- 周六定时器6设定模式
		if myTable["week6timer6SetMode"] == 0 then
			streams["week6_timer6_set_mode"] = "off"
		elseif myTable["week6timer6SetMode"] == 1 then
			streams["week6_timer6_set_mode"] = "heat"
		elseif myTable["week6timer6SetMode"] == 2 then
			streams["week6_timer6_set_mode"] = "dhw"
		elseif myTable["week6timer6SetMode"] == 3 then
			streams["week6_timer6_set_mode"] = "cool"
		elseif myTable["week6timer6SetMode"] == 4 then
			streams["week6_timer6_set_mode"] = "waterpump"
		elseif myTable["week6timer6SetMode"] == 5 then
			streams["week6_timer6_set_mode"] = "auto"
		end

		-- 周六定时6静音开关
		if myTable["week6timer6MutSet"] == 0x01 then
			streams["week6_timer6_mut_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer6MutSet"] == 0x00 then
			streams["week6_timer6_mut_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时6强热开关
		if myTable["week6timer6FrcHeSet"] == 0x01 then
			streams["week6_timer6_frc_he_set"] = VALUE_FUNCTION_ON
		elseif myTable["week6timer6FrcHeSet"] == 0x00 then
			streams["week6_timer6_frc_he_set"] = VALUE_FUNCTION_OFF
		end

		-- 周六定时6静音等级
		if myTable["week6timer6MutLev"] == 0x01 then
			streams["week6_timer6_mut_lev"] = VALUE_MUTE_LEV2
		elseif myTable["week6timer6MutLev"] == 0x00 then
			streams["week6_timer6_mut_lev"] = VALUE_MUTE_LEV1
		end

		streams["week6_timer6_set_temp"] = int2String(myTable["week6timer6SetTemp"]) -- 周六定时器6设定温度
		streams["week6_timer6_open_time_hour"] = int2String(myTable["week6timer6OpenTimeHour"]) -- 周六定时器6开始时间：时
		streams["week6_timer6_open_time_min"] = int2String(myTable["week6timer6OpenTimeMin"]) -- 周六定时器6开始时间：分
		streams["week6_timer6_close_time_hour"] = int2String(myTable["week6timer6CloseTimeHour"]) -- 周六定时器6结束时间：时
		streams["week6_timer6_close_time_min"] = int2String(myTable["week6timer6CloseTimeMin"]) -- 周六定时器6结束时间：分

		-- 周六定时1是否有效
		if myTable["week6timer1Valid"] == 0x01 then
			streams["week6_timer1_valid"] = VALUE_VALID
		elseif myTable["week6timer1Valid"] == 0x00 then
			streams["week6_timer1_valid"] = VALUE_INVALID
		end

		-- 周六定时2是否有效
		if myTable["week6timer2Valid"] == 0x02 then
			streams["week6_timer2_valid"] = VALUE_VALID
		elseif myTable["week6timer2Valid"] == 0x00 then
			streams["week6_timer2_valid"] = VALUE_INVALID
		end

		-- 周六定时3是否有效
		if myTable["week6timer3Valid"] == 0x04 then
			streams["week6_timer3_valid"] = VALUE_VALID
		elseif myTable["week6timer3Valid"] == 0x00 then
			streams["week6_timer3_valid"] = VALUE_INVALID
		end

		-- 周六定时4是否有效
		if myTable["week6timer4Valid"] == 0x08 then
			streams["week6_timer4_valid"] = VALUE_VALID
		elseif myTable["week6timer4Valid"] == 0x00 then
			streams["week6_timer4_valid"] = VALUE_INVALID
		end

		-- 周六定时5是否有效
		if myTable["week6timer5Valid"] == 0x10 then
			streams["week6_timer5_valid"] = VALUE_VALID
		elseif myTable["week6timer5Valid"] == 0x00 then
			streams["week6_timer5_valid"] = VALUE_INVALID
		end

		-- 周六定时6是否有效
		if myTable["week6timer6Valid"] == 0x20 then
			streams["week6_timer6_valid"] = VALUE_VALID
		elseif myTable["week6timer6Valid"] == 0x00 then
			streams["week6_timer6_valid"] = VALUE_INVALID
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) and (msgSubType == 0x0b))
		or ((myTable["dataType"] == BYTE_QUERYL_REQUEST) and (msgSubType == 0x0b))
		or ((myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == 0x0b))
	then
		-- 定时器类型
		if myTable["timerType"] == 0x00 then
			streams["timer_type"] = "point"
		elseif myTable["timerType"] == 0x01 then
			streams["timer_type"] = "section"
		elseif myTable["timerType"] == 0x02 then
			streams["timer_type"] = "order"
		end

		-- 定时器1开关
		if myTable["timer1Effect"] == 0x01 then
			streams["timer1_effect"] = VALUE_FUNCTION_ON
		elseif myTable["timer1Effect"] == 0x00 then
			streams["timer1_effect"] = VALUE_FUNCTION_OFF
		end

		-- 定时器2开关
		if myTable["timer2Effect"] == 0x02 then
			streams["timer2_effect"] = VALUE_FUNCTION_ON
		elseif myTable["timer2Effect"] == 0x00 then
			streams["timer2_effect"] = VALUE_FUNCTION_OFF
		end

		-- 定时器3开关
		if myTable["timer3Effect"] == 0x04 then
			streams["timer3_effect"] = VALUE_FUNCTION_ON
		elseif myTable["timer3Effect"] == 0x00 then
			streams["timer3_effect"] = VALUE_FUNCTION_OFF
		end

		-- 定时器4开关
		if myTable["timer4Effect"] == 0x08 then
			streams["timer4_effect"] = VALUE_FUNCTION_ON
		elseif myTable["timer4Effect"] == 0x00 then
			streams["timer4_effect"] = VALUE_FUNCTION_OFF
		end

		-- 定时器5开关
		if myTable["timer5Effect"] == 0x10 then
			streams["timer5_effect"] = VALUE_FUNCTION_ON
		elseif myTable["timer5Effect"] == 0x00 then
			streams["timer5_effect"] = VALUE_FUNCTION_OFF
		end

		-- 定时器6开关
		if myTable["timer6Effect"] == 0x20 then
			streams["timer6_effect"] = VALUE_FUNCTION_ON
		elseif myTable["timer6Effect"] == 0x00 then
			streams["timer6_effect"] = VALUE_FUNCTION_OFF
		end

		streams["timer1_open_time_hour"] = int2String(myTable["timer1OpenHour"]) -- 定时器1开始时间：时
		streams["timer1_open_time_min"] = int2String(myTable["timer1OpenMin"]) -- 定时器1开始时间：分
		streams["timer1_close_time_hour"] = int2String(myTable["timer1CloseHour"]) -- 定时器1结束时间：时
		streams["timer1_close_time_min"] = int2String(myTable["timer1CloseMin"]) -- 定时器1结束时间：分
		streams["timer1_set_temp"] = int2String(myTable["timer1SetTemperature"]) -- 定时器1设定温度

		-- 定时器1设定模式
		if myTable["timer1ModeValue"] == 0 then
			streams["timer1_set_mode"] = "off"
		elseif myTable["timer1ModeValue"] == 1 then
			streams["timer1_set_mode"] = "heat"
		elseif myTable["timer1ModeValue"] == 2 then
			streams["timer1_set_mode"] = "dhw"
		elseif myTable["timer1ModeValue"] == 3 then
			streams["timer1_set_mode"] = "cool"
		elseif myTable["timer1ModeValue"] == 4 then
			streams["timer1_set_mode"] = "waterpump"
		elseif myTable["timer1ModeValue"] == 5 then
			streams["timer1_set_mode"] = "auto"
		end

		streams["timer2_open_time_hour"] = int2String(myTable["timer2OpenHour"]) -- 定时器2开始时间：时
		streams["timer2_open_time_min"] = int2String(myTable["timer2OpenMin"]) -- 定时器2开始时间：分
		streams["timer2_close_time_hour"] = int2String(myTable["timer2CloseHour"]) -- 定时器2结束时间：时
		streams["timer2_close_time_min"] = int2String(myTable["timer2CloseMin"]) -- 定时器2结束时间：分
		streams["timer2_set_temp"] = int2String(myTable["timer2SetTemperature"]) -- 定时器2设定温度

		-- 定时器2设定模式
		if myTable["timer2ModeValue"] == 0 then
			streams["timer2_set_mode"] = "off"
		elseif myTable["timer2ModeValue"] == 1 then
			streams["timer2_set_mode"] = "heat"
		elseif myTable["timer2ModeValue"] == 2 then
			streams["timer2_set_mode"] = "dhw"
		elseif myTable["timer2ModeValue"] == 3 then
			streams["timer2_set_mode"] = "cool"
		elseif myTable["timer2ModeValue"] == 4 then
			streams["timer2_set_mode"] = "waterpump"
		elseif myTable["timer2ModeValue"] == 5 then
			streams["timer2_set_mode"] = "auto"
		end

		streams["timer3_open_time_hour"] = int2String(myTable["timer3OpenHour"]) -- 定时器3开始时间：时
		streams["timer3_open_time_min"] = int2String(myTable["timer3OpenMin"]) -- 定时器3开始时间：分
		streams["timer3_close_time_hour"] = int2String(myTable["timer3CloseHour"]) -- 定时器3结束时间：时
		streams["timer3_close_time_min"] = int2String(myTable["timer3CloseMin"]) -- 定时器3结束时间：分
		streams["timer3_set_temp"] = int2String(myTable["timer3SetTemperature"]) -- 定时器3设定温度

		-- 定时器3设定模式
		if myTable["timer3ModeValue"] == 0 then
			streams["timer3_set_mode"] = "off"
		elseif myTable["timer3ModeValue"] == 1 then
			streams["timer3_set_mode"] = "heat"
		elseif myTable["timer3ModeValue"] == 2 then
			streams["timer3_set_mode"] = "dhw"
		elseif myTable["timer3ModeValue"] == 3 then
			streams["timer3_set_mode"] = "cool"
		elseif myTable["timer3ModeValue"] == 4 then
			streams["timer3_set_mode"] = "waterpump"
		elseif myTable["timer3ModeValue"] == 5 then
			streams["timer3_set_mode"] = "auto"
		end

		streams["timer4_open_time_hour"] = int2String(myTable["timer4OpenHour"]) -- 定时器4开始时间：时
		streams["timer4_open_time_min"] = int2String(myTable["timer4OpenMin"]) -- 定时器4开始时间：分
		streams["timer4_close_time_hour"] = int2String(myTable["timer4CloseHour"]) -- 定时器4结束时间：时
		streams["timer4_close_time_min"] = int2String(myTable["timer4CloseMin"]) -- 定时器4结束时间：分
		streams["timer4_set_temp"] = int2String(myTable["timer4SetTemperature"]) -- 定时器4设定温度

		-- 定时器4设定模式
		if myTable["timer4ModeValue"] == 0 then
			streams["timer4_set_mode"] = "off"
		elseif myTable["timer4ModeValue"] == 1 then
			streams["timer4_set_mode"] = "heat"
		elseif myTable["timer4ModeValue"] == 2 then
			streams["timer4_set_mode"] = "dhw"
		elseif myTable["timer4ModeValue"] == 3 then
			streams["timer4_set_mode"] = "cool"
		elseif myTable["timer4ModeValue"] == 4 then
			streams["timer4_set_mode"] = "waterpump"
		elseif myTable["timer4ModeValue"] == 5 then
			streams["timer4_set_mode"] = "auto"
		end

		streams["timer5_open_time_hour"] = int2String(myTable["timer5OpenHour"]) -- 定时器4开始时间：时
		streams["timer5_open_time_min"] = int2String(myTable["timer5OpenMin"]) -- 定时器4开始时间：分
		streams["timer5_close_time_hour"] = int2String(myTable["timer5CloseHour"]) -- 定时器5结束时间：时
		streams["timer5_close_time_min"] = int2String(myTable["timer5CloseMin"]) -- 定时器5结束时间：分
		streams["timer5_set_temp"] = int2String(myTable["timer5SetTemperature"]) -- 定时器5设定温度

		-- 定时器5设定模式
		if myTable["timer5ModeValue"] == 0 then
			streams["timer5_set_mode"] = "off"
		elseif myTable["timer5ModeValue"] == 1 then
			streams["timer5_set_mode"] = "heat"
		elseif myTable["timer5ModeValue"] == 2 then
			streams["timer5_set_mode"] = "dhw"
		elseif myTable["timer5ModeValue"] == 3 then
			streams["timer5_set_mode"] = "cool"
		elseif myTable["timer5ModeValue"] == 4 then
			streams["timer5_set_mode"] = "waterpump"
		elseif myTable["timer5ModeValue"] == 5 then
			streams["timer5_set_mode"] = "auto"
		end

		streams["timer6_open_time_hour"] = int2String(myTable["timer6OpenHour"]) -- 定时器6开始时间：时
		streams["timer6_open_time_min"] = int2String(myTable["timer6OpenMin"]) -- 定时器6开始时间：分
		streams["timer6_close_time_hour"] = int2String(myTable["timer6CloseHour"]) -- 定时器6结束时间：时
		streams["timer6_close_time_min"] = int2String(myTable["timer6CloseMin"]) -- 定时器6结束时间：分
		streams["timer6_set_temp"] = int2String(myTable["timer6SetTemperature"]) -- 定时器6设定温度

		-- 定时器6设定模式
		if myTable["timer6ModeValue"] == 0 then
			streams["timer6_set_mode"] = "off"
		elseif myTable["timer6ModeValue"] == 1 then
			streams["timer6_set_mode"] = "heat"
		elseif myTable["timer6ModeValue"] == 2 then
			streams["timer6_set_mode"] = "dhw"
		elseif myTable["timer6ModeValue"] == 3 then
			streams["timer6_set_mode"] = "cool"
		elseif myTable["timer6ModeValue"] == 4 then
			streams["timer6_set_mode"] = "waterpump"
		elseif myTable["timer6ModeValue"] == 5 then
			streams["timer6_set_mode"] = "auto"
		end

		-- 定时器1是否有效
		if myTable["timer1Valid"] == 0x01 then
			streams["timer1_valid"] = VALUE_VALID
		elseif myTable["timer1Valid"] == 0x00 then
			streams["timer1_valid"] = VALUE_INVALID
		end

		-- 定时器2是否有效
		if myTable["timer2Valid"] == 0x02 then
			streams["timer2_valid"] = VALUE_VALID
		elseif myTable["timer2Valid"] == 0x00 then
			streams["timer2_valid"] = VALUE_INVALID
		end

		-- 定时器3是否有效
		if myTable["timer3Valid"] == 0x04 then
			streams["timer3_valid"] = VALUE_VALID
		elseif myTable["timer3Valid"] == 0x00 then
			streams["timer3_valid"] = VALUE_INVALID
		end

		-- 定时器4是否有效
		if myTable["timer4Valid"] == 0x08 then
			streams["timer4_valid"] = VALUE_VALID
		elseif myTable["timer4Valid"] == 0x00 then
			streams["timer4_valid"] = VALUE_INVALID
		end

		-- 定时器5是否有效
		if myTable["timer5Valid"] == 0x10 then
			streams["timer5_valid"] = VALUE_VALID
		elseif myTable["timer5Valid"] == 0x00 then
			streams["timer5_valid"] = VALUE_INVALID
		end

		-- 定时器6是否有效
		if myTable["timer6Valid"] == 0x20 then
			streams["timer6_valid"] = VALUE_VALID
		elseif myTable["timer6Valid"] == 0x00 then
			streams["timer6_valid"] = VALUE_INVALID
		end
	elseif (myTable["dataType"] == BYTE_CONTROL_REQUEST) and (msgSubType == BYTE_CONTRL_SUBCMD) then
		-- 设定模式
		if myTable["modeValue"] == 0 then
			streams[KEY_MODE] = "off"
		elseif myTable["modeValue"] == 1 then
			streams[KEY_MODE] = "heat"
		elseif myTable["modeValue"] == 2 then
			streams[KEY_MODE] = "dhw"
		elseif myTable["modeValue"] == 3 then
			streams[KEY_MODE] = "cool"
		elseif myTable["modeValue"] == 4 then
			streams[KEY_MODE] = "waterpump"
		elseif myTable["modeValue"] == 5 then
			streams[KEY_MODE] = "auto"
		end

		streams["set_temperature"] = int2String(myTable["tsValue"] - TEMP_OFFSET) -- 温度设定TS
		streams["ptc_temperature"] = int2String(myTable["ptcTemp"] - TEMP_OFFSET) -- 电加热开启环境温度Td设定
		streams["tr_temperature"] = int2String(myTable["trValue"] - TEMP_OFFSET) -- 热水开机回差Trdh设定
		streams["sterilize_hour"] = int2String(myTable["sterilizeHour"]) -- 杀菌时间：时
		streams["sterilize_min"] = int2String(myTable["sterilizeMinute"]) -- 杀菌时间：分
		streams["sterilize_temperature"] = int2String(myTable["sterilizeTs"] - TEMP_OFFSET) -- 杀菌设定温度
		streams["sterilize_cycle"] = int2String(myTable["sterilizeCycle"]) -- 杀菌周期：天
		streams["set_vacation_start_year"] = int2String(myTable["vacadaysStartYearValue"]) -- 休假开始日期：年
		streams["set_vacation_start_month"] = int2String(myTable["vacadaysStartMonthValue"]) -- 休假开始日期：月
		streams["set_vacation_start_day"] = int2String(myTable["vacadaysStartDayValue"]) -- 休假开始日期：日
		streams["set_vacation_end_year"] = int2String(myTable["vacadaysEndYearValue"]) -- 休假结束日期：年
		streams["set_vacation_end_month"] = int2String(myTable["vacadaysEndMonthValue"]) -- 休假结束日期：月
		streams["set_vacation_end_day"] = int2String(myTable["vacadaysEndDayValue"]) -- 休假结束日期：日

		-- 度假模式设定
		if myTable["vacationMode"] == 0 then
			streams["set_vacation_mode"] = "off"
		elseif myTable["vacationMode"] == 1 then
			streams["set_vacation_mode"] = "heat"
		elseif myTable["vacationMode"] == 2 then
			streams["set_vacation_mode"] = "dhw"
		elseif myTable["vacationMode"] == 3 then
			streams["set_vacation_mode"] = "cool"
		elseif myTable["vacationMode"] == 4 then
			streams["set_vacation_mode"] = "waterpump"
		elseif myTable["vacationMode"] == 5 then
			streams["set_vacation_mode"] = "auto"
		end

		-- 静音等级
		if myTable["muteLev"] == 0x01 then
			streams["mute_lev"] = VALUE_MUTE_LEV2
		elseif myTable["muteLev"] == 0x00 then
			streams["mute_lev"] = VALUE_MUTE_LEV1
		end

		-- 静音开关
		if myTable["mute"] == 0x01 then
			streams["mute_en"] = VALUE_FUNCTION_ON
		elseif myTable["mute"] == 0x00 then
			streams["mute_en"] = VALUE_FUNCTION_OFF
		end

		-- 强热开关
		if myTable["forceHeat"] == 0x02 then
			streams["force_heat"] = VALUE_FUNCTION_ON
		elseif myTable["forceHeat"] == 0x00 then
			streams["force_heat"] = VALUE_FUNCTION_OFF
		end

		-- SmartGrid开关
		if myTable["smartGrid"] == 0x80 then
			streams["smart_grid"] = VALUE_FUNCTION_ON
		elseif myTable["smartGrid"] == 0x00 then
			streams["smart_grid"] = VALUE_FUNCTION_OFF
		end

		-- 峰谷电开关
		if myTable["optBackupEn"] == 0x01 then
			streams["opt_backup_en"] = VALUE_FUNCTION_ON
		elseif myTable["optBackupEn"] == 0x00 then
			streams["opt_backup_en"] = VALUE_FUNCTION_OFF
		end

		-- 燃气复合开关
		if myTable["hybridEn"] == 0x02 then
			streams["hybrid_en"] = VALUE_FUNCTION_ON
		elseif myTable["hybridEn"] == 0x00 then
			streams["hybrid_en"] = VALUE_FUNCTION_OFF
		end

		-- 太阳能开关
		if myTable["solarEnergyEn"] == 0x04 then
			streams["solar_energy_en"] = VALUE_FUNCTION_ON
		elseif myTable["solarEnergyEn"] == 0x00 then
			streams["solar_energy_en"] = VALUE_FUNCTION_OFF
		end

		-- 太阳能利用方式
		if myTable["solarUseWay"] == 0x08 then
			streams["solar_use_way"] = VALUE_FUNCTION_ON
		elseif myTable["solarUseWay"] == 0x00 then
			streams["solar_use_way"] = VALUE_FUNCTION_OFF
		end

		-- 强制电辅热开关
		if myTable["openPTC"] == 0x10 then
			streams["open_ptc"] = VALUE_FUNCTION_ON
		elseif myTable["openPTC"] == 0x00 then
			streams["open_ptc"] = VALUE_FUNCTION_OFF
		end

		-- 强制杀菌开关
		if myTable["forceSterilizeEn"] == 0x20 then
			streams["force_sterilize_en"] = VALUE_FUNCTION_ON
		elseif myTable["forceSterilizeEn"] == 0x00 then
			streams["force_sterilize_en"] = VALUE_FUNCTION_OFF
		end

		-- 休假开关
		if myTable["vacationEn"] == 0x40 then
			streams["vacation_en"] = VALUE_FUNCTION_ON
		elseif myTable["vacationEn"] == 0x00 then
			streams["vacation_en"] = VALUE_FUNCTION_OFF
		end

		-- 杀菌开关
		if myTable["sterilizeEn"] == 0x80 then
			streams["sterilize_en"] = VALUE_FUNCTION_ON
		elseif myTable["sterilizeEn"] == 0x00 then
			streams["sterilize_en"] = VALUE_FUNCTION_OFF
		end

		---热泵开启温度下限
		streams["heat_pump_work_temp_limit"] = int2String(myTable["heatPumpWorkTempLimit"] - TEMP_OFFSET)
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) or (myTable["dataType"] == BYTE_QUERYL_REQUEST))
		and (msgSubType == BYTE_SN_SUBCMD)
	then
		-- 主机SN
		if myTable["oduSNCode"] == "" then
		else
			streams["odu_sn_code"] = myTable["oduSNCode"]
		end
	elseif
		((myTable["dataType"] == BYTE_AUTO_REPORT) or (myTable["dataType"] == BYTE_QUERYL_REQUEST))
		and (msgSubType == BYTE_RUNPARA2_SUBCMD)
	then
		if myTable["fg_IBHEnable"] == 0 then
			streams["fg_IBHEnable"] = "invalid"
		else
			streams["fg_IBHEnable"] = "valid"
		end
		streams["tseh_temp"] = int2String(myTable["tseh_temp"])
		streams["treh_temp"] = int2String(myTable["treh_temp"])
		streams["t5u_temp"] = int2String(myTable["t5u_temp"])
		streams["eheat_current"] = int2String(myTable["eheat_current"])
		streams["power_total"] = int2String(myTable["power_total"])
		streams["eheat_total_kwh"] = int2String(myTable["eheat_total_kwh"])
		streams["comp_total_kwh"] = int2String(myTable["comp_total_kwh"])
		streams["eheat_24h_kwh"] = int2String(myTable["eheat_24h_kwh"])
		streams["comp_24h_kwh"] = int2String(myTable["comp_24h_kwh"])
	end

	local retTable = {}
	retTable["status"] = streams

	local ret = encode(retTable)

	return ret
end
