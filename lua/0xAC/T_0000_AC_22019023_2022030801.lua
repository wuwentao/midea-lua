local bit = require("bit")
local JSON = require("cjson")
local keyT = {}
keyT["KEY_VERSION"] = "version"
keyT["KEY_POWER"] = "power"
keyT["KEY_PURIFIER"] = "purifier"
keyT["KEY_MODE"] = "mode"
keyT["KEY_TEMPERATURE"] = "temperature"
keyT["KEY_FANSPEED"] = "wind_speed"
keyT["KEY_SWING_LR"] = "wind_swing_lr"
keyT["KEY_SWING_LR_UNDER"] = "wind_swing_lr_under"
keyT["KEY_SWING_UD"] = "wind_swing_ud"
keyT["KEY_TIME_ON"] = "power_on_timer"
keyT["KEY_TIME_OFF"] = "power_off_timer"
keyT["KEY_CLOSE_TIME"] = "power_off_time_value"
keyT["KEY_OPEN_TIME"] = "power_on_time_value"
keyT["KEY_ECO"] = "eco"
keyT["KEY_DRY"] = "dry"
keyT["KEY_PTC"] = "ptc"
keyT["KEY_CURRENT_WORK_TIME"] = "current_work_time"
keyT["KEY_ERROR_CODE"] = "error_code"
keyT["KEY_BUZZER"] = "buzzer"
keyT["KEY_PREVENT_SUPER_COOL"] = "prevent_super_cool"
keyT["KEY_PREVENT_STRAIGHT_WIND"] = "prevent_straight_wind"
keyT["KEY_AUTO_PREVENT_STRAIGHT_WIND"] = "auto_prevent_straight_wind"
keyT["KEY_SELF_CLEAN"] = "self_clean"
keyT["KEY_NO_WIND_SENSE"] = "no_wind_sense"
keyT["KEY_CHILD_PREVENT_COLD_WIND"] = "child_prevent_cold_wind"
keyT["KEY_STRONG_WIND"] = "strong_wind"
keyT["KEY_COMFORT_POWER_SAVE"] = "comfort_power_save"
keyT["KEY_SCREEN_DISPLAY"] = "screen_display"
keyT["KEY_PREVENT_COLD"] = "prevent_cold"
keyT["KEY_LITTLE_ANGLE"] = "little_angel"
keyT["KEY_COOL_HOT_SENSE"] = "cool_hot_sense"
keyT["KEY_GENTLE_WIND_SENSE"] = "gentle_wind_sense"
keyT["KEY_SECURITY"] = "security"
keyT["KEY_SCENEID"] = "sceneId"
keyT["KEY_LSPEED"] = "targetLWindSpeed"
keyT["KEY_RSPEED"] = "targetRWindSpeed"
keyT["KEY_FRESH_AIR"] = "fresh_air"
keyT["KEY_REMOVE_ODOR"] = "remove_odor"
keyT["KEY_INNER_PURIFIER"] = "inner_purifier"
keyT["KEY_AIROPTIMIZATION"] = "airoptimization"
keyT["KEY_HUMIDIFICATION"] = "humidification"
keyT["KEY_NO_WIND_SENSE_LEFT"] = "no_wind_sense_left"
keyT["KEY_NO_WIND_SENSE_RIGHT"] = "no_wind_sense_right"
keyT["KEY_LIGHT"] = "light"
keyT["KEY_DOWN_WIND_SPEED"] = "down_wind_speed"
keyT["KEY_UP_CONTROL_WIND"] = "up_control_wind"
keyT["KEY_DOWN_CONTROL_WIND"] = "down_control_wind"
keyT["KEY_WAIT_CLEAN"] = "wait_clean"
keyT["KEY_LEFT_WIND"] = "left_wind"
keyT["KEY_RIGHT_WIND"] = "right_wind"
keyT["KEY_PURIFY_FILM"] = "purify_film"
keyT["KEY_WETFILM_STATE"] = "wetfilm_state"
keyT["KEY_ACSTRAINER_STATE"] = "acstrainer_state"
keyT["KEY_GET_WEATHER"] = "get_weather"
keyT["KEY_NEAR_SWITCH"] = "near_switch"
keyT["KEY_WATER_SUPPLY"] = "water_supply"
keyT["KEY_AIR_CONDITION_TEMP"] = "air_condition_temp"
keyT["KEY_INDOOR_TEMP"] = "indoor_temp"
keyT["KEY_OUTDOOR_TEMP"] = "outdoor_temp"
keyT["KEY_ECO_SWITCH"] = "eco_switch"
keyT["KEY_KEEP_WARM_SWITCH"] = "keep_warm_switch"
keyT["KEY_CLOSE_SCREEN"] = "close_screen"
keyT["KEY_EXCLUSIVE_MODE"] = "exclusive_mode"
keyT["KEY_FAMILY_NUMBER"] = "family_number"
keyT["KEY_WIND_BLOW_CLOSE"] = "wind_blow_close"
keyT["KEY_WISDOM_WIND"] = "wisdom_wind"
keyT["KEY_WINDOM_WIND_NEW"] = "wisdom_wind_new"
keyT["KEY_CAMERA_DIRECTION_SWITCH"] = "camera_direction_switch"
keyT["KEY_WIND_BLOW"] = "wind_blow"
keyT["KEY_WIND_CLOSE"] = "wind_close"
keyT["KEY_CLEAN_SWITCH"] = "clean_switch"
keyT["KEY_LIGHT_CLASS_SWITCH"] = "light_class_switch"
keyT["KEY_WIND_SWING_LEFT"] = "wind_swing_left"
keyT["KEY_WIND_SWING_RIGHT"] = "wind_swing_right"
keyT["KEY_WIND_SWING_UD_RIGHT"] = "wind_swing_ud_right"
keyT["KEY_WIND_SWING_UD_LEFT"] = "wind_swing_ud_left"
keyT["KEY_INTRUSION"] = "intrusion"
keyT["KEY_INTRUSION_VIDEO"] = "intrusion_video"
keyT["KEY_VOICE_CONTROL_NEW"] = "voice_control_new"
keyT["KEY_WIND_SWING_UD_ANGLE"] = "wind_swing_ud_angle"
keyT["KEY_WIND_SWING_LR_ANGLE"] = "wind_swing_lr_angle"
local keyV = {}
keyV["VALUE_VERSION"] = 40
keyV["VALUE_FUNCTION_ON"] = "on"
keyV["VALUE_FUNCTION_OFF"] = "off"
keyV["VALUE_MODE_HEAT"] = "heat"
keyV["VALUE_MODE_COOL"] = "cool"
keyV["VALUE_MODE_AUTO"] = "auto"
keyV["VALUE_MODE_DRY"] = "dry"
keyV["VALUE_MODE_FAN"] = "fan"
keyV["VALUE_INDOOR_TEMPERATURE"] = "indoor_temperature"
keyV["VALUE_OUTDOOR_TEMPERATURE"] = "outdoor_temperature"
keyV["VALUE_RUN_STATE"] = "runstate"
keyV["VALUE_RUNNING"] = "running"
keyV["VALUE_STOP"] = "stopped"
local deviceSubType = 0
local deviceSN8 = "00000000"
local keyB = {}
keyB["BYTE_DEVICE_TYPE"] = 0xAC
keyB["BYTE_CONTROL_REQUEST"] = 0x02
keyB["BYTE_QUERYL_REQUEST"] = 0x03
keyB["BYTE_PROTOCOL_HEAD"] = 0xAA
keyB["BYTE_PROTOCOL_LENGTH"] = 0x0A
keyB["BYTE_POWER_ON"] = 0x01
keyB["BYTE_POWER_OFF"] = 0x00
keyB["BYTE_MODE_AUTO"] = 0x20
keyB["BYTE_MODE_COOL"] = 0x40
keyB["BYTE_MODE_DRY"] = 0x60
keyB["BYTE_MODE_HEAT"] = 0x80
keyB["BYTE_MODE_FAN"] = 0xA0
keyB["BYTE_FANSPEED_AUTO"] = 0x66
keyB["BYTE_FANSPEED_HIGH"] = 0x50
keyB["BYTE_FANSPEED_MID"] = 0x3C
keyB["BYTE_FANSPEED_LOW"] = 0x28
keyB["BYTE_FANSPEED_MUTE"] = 0x14
keyB["BYTE_PURIFIER_ON"] = 0x20
keyB["BYTE_PURIFIER_OFF"] = 0x00
keyB["BYTE_ECO_ON"] = 0x80
keyB["BYTE_ECO_OFF"] = 0x00
keyB["BYTE_SWING_LR_ON"] = 0x03
keyB["BYTE_SWING_LR_OFF"] = 0x00
keyB["BYTE_SWING_LR_UNDER_ON"] = 0x80
keyB["BYTE_SWING_LR_UNDER_OFF"] = 0x00
keyB["BYTE_SWING_LR_UNDER_ENABLE"] = 0x80
keyB["BYTE_SWING_LR_UNDER_DISABLE"] = 0x00
keyB["BYTE_SWING_UD_ON"] = 0x0C
keyB["BYTE_SWING_UD_OFF"] = 0x00
keyB["BYTE_DRY_ON"] = 0x04
keyB["BYTE_DRY_OFF"] = 0x00
keyB["BYTE_BUZZER_ON"] = 0x40
keyB["BYTE_BUZZER_OFF"] = 0x00
keyB["BYTE_CONTROL_CMD"] = 0x40
keyB["BYTE_TIMER_METHOD_REL"] = 0x00
keyB["BYTE_TIMER_METHOD_ABS"] = 0x01
keyB["BYTE_TIMER_METHOD_DISABLE"] = 0x7F
keyB["BYTE_CLIENT_MODE_MOBILE"] = 0x02
keyB["BYTE_TIMER_SWITCH_ON"] = 0x80
keyB["BYTE_TIMER_SWITCH_OFF"] = 0x00
keyB["BYTE_CLOSE_TIMER_SWITCH_ON"] = 0x80
keyB["BYTE_CLOSE_TIMER_SWITCH_OFF"] = 0x7F
keyB["BYTE_START_TIMER_SWITCH_ON"] = 0x80
keyB["BYTE_START_TIMER_SWITCH_OFF"] = 0x7F
keyB["BYTE_PTC_ON"] = 0x08
keyB["BYTE_PTC_OFF"] = 0x00
keyB["BYTE_PREVENT_COLD_ON"] = 0x08
keyB["BYTE_PREVENT_COLD_OFF"] = 0x00
keyB["BYTE_STRONG_WIND_ON"] = 0x20
keyB["BYTE_STRONG_WIND_OFF"] = 0x00
keyB["BYTE_SLEEP_ON"] = 0x03
keyB["BYTE_SLEEP_OFF"] = 0x00
keyB["BYTE_COMFORT_POWER_SAVE_ON"] = 0x01
keyB["BYTE_COMFORT_POWER_SAVE_OFF"] = 0x00
keyB["BYTE_FRESH_AIR_ON"] = 0x02
keyB["BYTE_FRESH_AIR_OFF"] = 0x01
keyB["BYTE_REMOVE_ODOR_ON"] = 0x02
keyB["BYTE_REMOVE_ODOR_OFF"] = 0x01
keyB["BYTE_INNER_PURIFIER_ON"] = 0x02
keyB["BYTE_INNER_PURIFIER_OFF"] = 0x01
keyB["BYTE_AIROPTIMIZATION_ON"] = 0x02
keyB["BYTE_AIROPTIMIZATION_OFF"] = 0x01
keyB["BYTE_HUMIDIFICATION_ON"] = 0x02
keyB["BYTE_HUMIDIFICATION_OFF"] = 0x01
keyB["BYTE_NO_WIND_SENSE_LEFT_ON"] = 0x02
keyB["BYTE_NO_WIND_SENSE_LEFT_OFF"] = 0x01
keyB["BYTE_NO_WIND_SENSE_RIGHT_ON"] = 0x02
keyB["BYTE_NO_WIND_SENSE_RIGHT_OFF"] = 0x01
keyB["BYTE_LIGHT_ON"] = 0x02
keyB["BYTE_LIGHT_OFF"] = 0x01
keyB["BYTE_CONTROL_PROPERTY_CMD"] = 0xB0
local keyP = {}
keyP["powerValue"] = nil
keyP["modeValue"] = nil
keyP["temperature"] = nil
keyP["smallTemperature"] = nil
keyP["sceneId"] = nil
keyP["targetLWindSpeed"] = nil
keyP["targetRWindSpeed"] = nil
keyP["indoorTemperatureValue"] = 255
keyP["smallIndoorTemperatureValue"] = nil
keyP["outdoorTemperatureValue"] = 255
keyP["smallOutdoorTemperatureValue"] = nil
keyP["fanspeedValue"] = nil
keyP["closeTimerSwitch"] = nil
keyP["openTimerSwitch"] = nil
keyP["closeHour"] = nil
keyP["closeStepMintues"] = nil
keyP["closeMin"] = nil
keyP["closeTime"] = nil
keyP["openHour"] = nil
keyP["openStepMintues"] = nil
keyP["openMin"] = nil
keyP["openTime"] = nil
keyP["strongWindValue"] = nil
keyP["comfortableSleepValue"] = nil
keyP["PTCValue"] = nil
keyP["purifierValue"] = nil
keyP["ecoValue"] = nil
keyP["dryValue"] = nil
keyP["swingLRValue"] = nil
keyP["swingLRValueUnder"] = nil
keyP["swingLRUnderSwitch"] = nil
keyP["swingUDValue"] = nil
keyP["currentWorkTime"] = nil
keyP["buzzerValue"] = 0x40
keyP["errorCode"] = 0
keyP["kickQuilt"] = nil
keyP["preventCold"] = nil
keyP["comfortPowerSave"] = nil
local dataType = 0
local tempControl = 0
local cmdOrder = nil
local function init_property_value()
	tempControl = 0
	cmdOrder = nil
	keyP["propertyNumber"] = 0
	keyP["powerValue"] = nil
	keyP["modeValue"] = nil
	keyP["temperature"] = nil
	keyP["smallTemperature"] = nil
	keyP["sceneId"] = nil
	keyP["targetLWindSpeed"] = nil
	keyP["targetRWindSpeed"] = nil
	keyP["smallIndoorTemperatureValue"] = nil
	keyP["smallOutdoorTemperatureValue"] = nil
	keyP["fanspeedValue"] = nil
	keyP["swingLRValue"] = nil
	keyP["swingUDValue"] = nil
	keyP["screen_display"] = nil
	keyP["buzzerValue"] = 0x40
	keyP["dryValue"] = nil
	keyP["PTCValue"] = nil
	keyP["strongWindValue"] = nil
	keyP["propertyNumber"] = 0
	keyP["prevent_super_cool"] = nil
	keyP["prevent_straight_wind"] = nil
	keyP["auto_prevent_straight_wind"] = nil
	keyP["self_clean"] = nil
	keyP["wind_straight"] = nil
	keyP["wind_avoid"] = nil
	keyP["intelligent_wind"] = nil
	keyP["no_wind_sense"] = nil
	keyP["child_prevent_cold_wind"] = nil
	keyP["little_angel"] = nil
	keyP["cool_hot_sense"] = nil
	keyP["gentle_wind_sense"] = nil
	keyP["security"] = nil
	keyP["remove_odor"] = nil
	keyP["inner_purifier"] = nil
	keyP["humidification"] = nil
	keyP["airoptimization"] = nil
	keyP["no_wind_sense_right"] = nil
	keyP["no_wind_sense_left"] = nil
	keyP["light"] = nil
	keyP["fresh_air"] = nil
	keyP["light_bright"] = nil
	keyP["down_wind_speed"] = nil
	keyP["up_control_wind"] = nil
	keyP["up_control_wind_degree"] = nil
	keyP["down_control_wind"] = nil
	keyP["down_control_wind_degree"] = nil
	keyP["wait_clean"] = nil
	keyP["left_wind"] = nil
	keyP["right_wind"] = nil
	keyP["purify_film"] = nil
	keyP["purify_film_time"] = nil
	keyP["purify_film_total_time"] = nil
	keyP["wetfilm_state"] = nil
	keyP["wetfilm_time"] = nil
	keyP["wetfilm_state_total_time"] = nil
	keyP["acstrainer_state"] = nil
	keyP["acstrainer_state_time"] = nil
	keyP["acstrainer_state_total_time"] = nil
	keyP["get_weather"] = nil
	keyP["outdoor_pm25"] = nil
	keyP["near_switch"] = nil
	keyP["near_no_yes"] = nil
	keyP["water_supply"] = nil
	keyP["water_level"] = nil
	keyP["water_tank"] = nil
	keyP["air_condition_temp"] = nil
	keyP["air_condition_humidity"] = nil
	keyP["air_condition_clean"] = nil
	keyP["air_condition_fresh"] = nil
	keyP["indoor_temp"] = nil
	keyP["indoor_temp_decimal"] = nil
	keyP["outdoor_temp"] = nil
	keyP["outdoor_temp_decimal"] = nil
	keyP["eco_switch"] = nil
	keyP["eco_second"] = nil
	keyP["eco_min"] = nil
	keyP["eco_hour"] = nil
	keyP["keep_warm_switch"] = nil
	keyP["keep_warm_temp"] = nil
	keyP["exclusive_mode"] = nil
	keyP["close_screen"] = nil
	keyP["family_number"] = nil
	keyP["wind_blow_close"] = nil
	keyP["wisdom_wind"] = nil
	keyP["wisdom_wind_new"] = nil
	keyP["wisdom_left_distance"] = nil
	keyP["wisdom_right_distance"] = nil
	keyP["wisdom_left_set_wind"] = nil
	keyP["wisdom_right_set_wind"] = nil
	keyP["wisdom_left_down_angle"] = nil
	keyP["wisdom_right_down_angle"] = nil
	keyP["wisdom_left_up_angle"] = nil
	keyP["wisdom_right_up_angle"] = nil
	keyP["wind_close"] = nil
	keyP["wind_close_left_distance"] = nil
	keyP["wind_close_right_distance"] = nil
	keyP["wind_close_left_set_wind"] = nil
	keyP["wind_close_right_set_wind"] = nil
	keyP["wind_close_left_down_angle"] = nil
	keyP["wind_close_right_down_angle"] = nil
	keyP["wind_close_left_up_angle"] = nil
	keyP["wind_close_right_up_angle"] = nil
	keyP["wind_blow"] = nil
	keyP["wind_blow_left_distance"] = nil
	keyP["wind_blow_right_distance"] = nil
	keyP["wind_blow_left_set_wind"] = nil
	keyP["wind_blow_right_set_wind"] = nil
	keyP["wind_blow_left_down_angle"] = nil
	keyP["wind_blow_right_down_angle"] = nil
	keyP["wind_blow_left_up_angle"] = nil
	keyP["wind_blow_right_up_angle"] = nil
	keyP["camera_direction_state"] = nil
	keyP["camera_direction_switch"] = nil
	keyP["camera_direction_left"] = nil
	keyP["camera_direction_right"] = nil
	keyP["clean_switch"] = nil
	keyP["clean_running_stage"] = nil
	keyP["clean_running_time"] = nil
	keyP["clean_target_time"] = nil
	keyP["light_class_switch"] = nil
	keyP["light_class"] = nil
	keyP["wind_swing_left"] = nil
	keyP["wind_swing_right"] = nil
	keyP["wind_swing_left_degree"] = nil
	keyP["wind_swing_right_degree"] = nil
	keyP["wind_swing_ud_right"] = nil
	keyP["wind_swing_ud_left"] = nil
	keyP["wind_swing_ud_right_degree"] = nil
	keyP["wind_swing_ud_left_degree"] = nil
	keyP["wind_speed_left"] = nil
	keyP["wind_speed_right"] = nil
	keyP["wind_speed"] = nil
	keyP["strong_wind"] = nil
	keyP["intrusion"] = nil
	keyP["intrusion_video"] = nil
	keyP["voice_control_new"] = nil
	keyP["wind_swing_ud_angle"] = nil
	keyP["wind_swing_lr_angle"] = nil
	keyP["full_time"] = nil
	keyP["analysis_value"] = nil
	keyP["wind_speed_control"] = nil
	keyP["new_wind_fun_wind_mode"] = nil
	keyP["smart_clean_sw"] = nil
	keyP["sterilize_sw"] = nil
	keyP["new_wind_fun_sw"] = nil
	keyP["hum_fun_sw"] = nil
	keyP["clean_fun_sw"] = nil
	keyP["run_status"] = nil
	keyP["device_set_run_status"] = nil
	keyP["purfiy_film"] = nil
	keyP["wetfilm_fun_sw"] = nil
	keyP["diy_func"] = nil
	keyP["strong"] = nil
	keyP["elec_heat"] = nil
	keyP["acstrainer_sw"] = nil
	keyP["airoptimization_sw"] = nil
	keyP["open_close_time"] = nil
	keyP["run_current_status"] = nil
	keyP["device_current_run_status"] = nil
	keyP["current_run_mode"] = nil
	keyP["t1_temp"] = nil
	keyP["t2_temp"] = nil
	keyP["t3_temp"] = nil
	keyP["t4_temp"] = nil
	keyP["temp_out"] = nil
	keyP["tp_temp"] = nil
	keyP["temp_in"] = nil
	keyP["com_run_frequency"] = nil
	keyP["com_target_frequency"] = nil
	keyP["ya_suo_ji_dian_liu"] = nil
	keyP["shi_wai_ji_zong_dian_liu"] = nil
	keyP["shi_wai_ji_dian_ya"] = nil
	keyP["shi_nei_ji_yun_zhuan_moshi"] = nil
	keyP["left_wind_class"] = nil
	keyP["right_wind_class"] = nil
	keyP["room_i_fault_state1_0"] = nil
	keyP["room_i_fault_state1_1"] = nil
	keyP["room_i_fault_state1_2"] = nil
	keyP["room_i_fault_state1_3"] = nil
	keyP["room_i_fault_state1_4"] = nil
	keyP["room_i_fault_state1_5"] = nil
	keyP["room_i_fault_state1_6"] = nil
	keyP["room_i_fault_state1_7"] = nil
	keyP["room_i_fault_state2_0"] = nil
	keyP["room_i_fault_state2_1"] = nil
	keyP["room_i_fault_state2_2"] = nil
	keyP["room_i_fault_state2_3"] = nil
	keyP["room_i_fault_state2_4"] = nil
	keyP["room_i_fault_state2_5"] = nil
	keyP["room_i_fault_state2_6"] = nil
	keyP["room_i_fault_state2_7"] = nil
	keyP["room_i_fault_state3_0"] = nil
	keyP["room_i_fault_state3_1"] = nil
	keyP["room_i_fault_state3_2"] = nil
	keyP["room_i_fault_state3_3"] = nil
	keyP["room_i_fault_state3_4"] = nil
	keyP["room_i_fault_state3_5"] = nil
	keyP["room_i_fault_state3_6"] = nil
	keyP["room_i_fault_state3_7"] = nil
	keyP["room_i_limit_freq_state1_0"] = nil
	keyP["room_i_limit_freq_state1_1"] = nil
	keyP["room_i_limit_freq_state1_2"] = nil
	keyP["room_i_limit_freq_state1_3"] = nil
	keyP["room_i_limit_freq_state1_4"] = nil
	keyP["room_i_limit_freq_state1_5"] = nil
	keyP["room_i_limit_freq_state1_6"] = nil
	keyP["room_i_limit_freq_state1_7"] = nil
	keyP["room_i_limit_freq_state2_0"] = nil
	keyP["room_i_limit_freq_state2_1"] = nil
	keyP["room_i_limit_freq_state2_2"] = nil
	keyP["room_i_limit_freq_state2_3"] = nil
	keyP["room_i_limit_freq_state2_4"] = nil
	keyP["room_i_limit_freq_state2_5"] = nil
	keyP["room_i_limit_freq_state2_6"] = nil
	keyP["room_i_limit_freq_state2_7"] = nil
	keyP["room_i_load_state1_0"] = nil
	keyP["room_i_load_state1_1"] = nil
	keyP["room_i_load_state1_2"] = nil
	keyP["room_i_load_state1_3"] = nil
	keyP["room_i_load_state1_4"] = nil
	keyP["room_i_load_state1_5"] = nil
	keyP["room_i_load_state1_6"] = nil
	keyP["room_i_load_state1_7"] = nil
	keyP["out_door_dev_state1_0"] = nil
	keyP["out_door_dev_state1_1"] = nil
	keyP["out_door_dev_state1_2"] = nil
	keyP["out_door_dev_state1_3"] = nil
	keyP["out_door_dev_state1_4"] = nil
	keyP["out_door_dev_state1_5"] = nil
	keyP["out_door_dev_state1_6"] = nil
	keyP["out_door_dev_state1_7"] = nil
	keyP["out_door_dev_state2_0"] = nil
	keyP["out_door_dev_state2_1"] = nil
	keyP["out_door_dev_state2_2"] = nil
	keyP["out_door_dev_state2_3"] = nil
	keyP["out_door_dev_state2_4"] = nil
	keyP["out_door_dev_state2_5"] = nil
	keyP["out_door_dev_state2_6"] = nil
	keyP["out_door_dev_state2_7"] = nil
	keyP["out_door_dev_state3_0"] = nil
	keyP["out_door_dev_state3_1"] = nil
	keyP["out_door_dev_state3_2"] = nil
	keyP["out_door_dev_state3_3"] = nil
	keyP["out_door_dev_state3_4"] = nil
	keyP["out_door_dev_state3_5"] = nil
	keyP["out_door_dev_state3_6"] = nil
	keyP["out_door_dev_state3_7"] = nil
	keyP["out_door_dev_state4_0"] = nil
	keyP["out_door_dev_state4_1"] = nil
	keyP["out_door_dev_state4_2"] = nil
	keyP["out_door_dev_state4_3"] = nil
	keyP["out_door_dev_state4_4"] = nil
	keyP["out_door_dev_state4_5"] = nil
	keyP["out_door_dev_state4_6"] = nil
	keyP["out_door_dev_state4_7"] = nil
	keyP["out_door_dev_state5_0"] = nil
	keyP["out_door_dev_state5_1"] = nil
	keyP["out_door_dev_state5_2"] = nil
	keyP["out_door_dev_state5_3"] = nil
	keyP["out_door_dev_state5_4"] = nil
	keyP["out_door_dev_state5_5"] = nil
	keyP["out_door_dev_state5_6"] = nil
	keyP["out_door_dev_state5_7"] = nil
	keyP["out_door_dev_state6_0"] = nil
	keyP["out_door_dev_state6_1"] = nil
	keyP["out_door_dev_state6_2"] = nil
	keyP["out_door_dev_state6_3"] = nil
	keyP["out_door_dev_state6_4"] = nil
	keyP["out_door_dev_state6_5"] = nil
	keyP["out_door_dev_state6_6"] = nil
	keyP["out_door_dev_state6_7"] = nil
	keyP["out_door_i_fan_speed"] = nil
	keyP["out_door_ele_switch"] = nil
	keyP["out_door_back_temp"] = nil
	keyP["out_door_voltage"] = nil
	keyP["ipm_temp"] = nil
	keyP["dry_heat_time_value"] = nil
	keyP["new_wind_fun_current_value"] = nil
	keyP["clean_fun_current_value"] = nil
	keyP["hum_fun_wind_current_value"] = nil
	keyP["sterilize_run_time"] = nil
	keyP["wetfilm_time"] = nil
	keyP["purfiy_film_time"] = nil
	keyP["smart_clean_current_run_time"] = nil
	keyP["left_wind_current_class"] = nil
	keyP["right_wind_current_class"] = nil
	keyP["down_wind_set_class"] = nil
	keyP["down_wind_current_class"] = nil
	keyP["set_hum_value"] = nil
	keyP["hum_fun_wind_class"] = nil
	keyP["clean_fun_wind_class"] = nil
	keyP["new_wind_fun_class"] = nil
	keyP["sterilize_wind_class"] = nil
	keyP["product_code"] = nil
	keyP["err_code_class"] = nil
	keyP["in_display_transport"] = nil
	keyP["compressor_pos_protect"] = nil
	keyP["in_display_transit"] = nil
	keyP["right_wind_rotate_speed"] = nil
	keyP["left_wind_rotate_speed"] = nil
	keyP["timing_on_minute"] = nil
	keyP["timing_off_minute"] = nil
	keyP["local_body_sense"] = nil
	keyP["energy_save"] = nil
	keyP["restrong"] = nil
	keyP["refarce_wind"] = nil
	keyP["repower_save"] = nil
	keyP["cosy_sleep_switch"] = nil
	keyP["run_status"] = nil
	keyP["eco_func"] = nil
	keyP["dust_fun_flag"] = nil
	keyP["re_elec_heat"] = nil
	keyP["rediy_func"] = nil
	keyP["rechg_of_air"] = nil
	keyP["wisdom_eye"] = nil
	keyP["natural_wind"] = nil
	keyP["repeak_valley_mode"] = nil
	keyP["night_light"] = nil
	keyP["against_cool"] = nil
	keyP["child_kickk"] = nil
	keyP["alm_sleep"] = nil
	keyP["pmv_status"] = nil
	keyP["display_control_flag"] = nil
	keyP["control_self_cleaning_current_status"] = nil
	keyP["nonDirectWind"] = nil
	keyP["is_open8_degree_hot_current_status"] = nil
	keyP["smartfun_current_status"] = nil
	keyP["is_use_double_temp_ctrl"] = nil
	keyP["ladder_fun_sw"] = nil
	keyP["up_dn_dao_feng_tiao_stat"] = nil
	keyP["lt_rt_dao_feng_tiao_stat"] = nil
	keyP["top_dao_feng_tiao_stat"] = nil
	keyP["up_dn_dao_feng_tiao_stat_right_down"] = nil
	keyP["lt_rt_dao_feng_tiao_stat_right_left"] = nil
	keyP["hum_fun_wind_percentage"] = nil
	keyP["checked_temp_set"] = nil
	keyP["indoor_fan_runtime"] = nil
	keyP["outdoor_fan_speed"] = nil
	keyP["ele_switch_angle"] = nil
	keyP["defrosting_step"] = nil
	keyP["outdoor_dev_state7"] = nil
	keyP["outdoor_dev_state8"] = nil
	keyP["out_door485_fault"] = nil
	keyP["engine_cur_worked_time"] = nil
	keyP["engine_total_worked_time"] = nil
	keyP["limit_freq_type2"] = nil
	keyP["dev_max_voltage"] = nil
	keyP["dev_min_voltage"] = nil
	keyP["history_max_current"] = nil
	keyP["history_max_for_t4"] = nil
	keyP["history_min_for_t4"] = nil
	keyP["total_err_cnt"] = nil
	keyP["shi_wai_ya_suo_ji_ci_tong"] = nil
	keyP["shi_nei_feng_ji_ci_tong"] = nil
	keyP["d_spin_current"] = nil
	keyP["q_spin_current"] = nil
	keyP["engine_peak_current"] = nil
	keyP["pfc_peak_current"] = nil
	keyP["fan_peak_current"] = nil
	keyP["torque_adjust_angle"] = nil
	keyP["torque_adjust_value"] = nil
	keyP["ad_adjust_voltage1"] = nil
	keyP["ad_adjust_voltage2"] = nil
	keyP["d_spin_voltage"] = nil
	keyP["q_spin_voltage"] = nil
	keyP["pfc_switch_status"] = nil
	keyP["com_start_status"] = nil
	keyP["out_side_power_factor"] = nil
	keyP["out_side_power"] = nil
	keyP["up_dn_dao_feng_tiao_cool_upper_limit"] = nil
	keyP["up_dn_dao_feng_tiao_cool_lower_limit"] = nil
	keyP["up_dn_dao_feng_tiao_heat_upper_limit"] = nil
	keyP["up_dn_dao_feng_tiao_heat_lower_limit"] = nil
	keyP["up_dn_dao_feng_tiao_cur_angle"] = nil
	keyP["out_side_power_factor"] = nil
	keyP["lt_rt_dao_feng_tiao_upper_limit"] = nil
	keyP["lt_rt_dao_feng_tiao_lower_limit"] = nil
	keyP["lt_rt_dao_feng_tiao_cur_angle"] = nil
	keyP["out_door_dest_freq"] = nil
	keyP["int_door_target_wind_speed"] = nil
	keyP["top_dao_feng_tiao_upper_limit"] = nil
	keyP["top_dao_feng_tiao_lower_limit"] = nil
	keyP["top_dao_feng_tiao_cur_angle"] = nil
	keyP["down_dao_feng_tiao_cool_upper_limit"] = nil
	keyP["strong_current"] = nil
	keyP["sterilize_current_sw"] = nil
	keyP["new_wind_fun_current_sw"] = nil
	keyP["hum_fun_current_sw"] = nil
	keyP["clean_fun_current_sw"] = nil
	keyP["control_self_cleaning_current_stage"] = nil
	keyP["smart_clean_current_status"] = nil
	keyP["down_dao_feng_tiao_cool_lower_limit"] = nil
	keyP["down_dn_dao_feng_tiao_heat_upper_limit"] = nil
	keyP["down_dn_dao_feng_tiao_heat_lower_limit"] = nil
	keyP["down_dn_dao_feng_tiao_cur_angle"] = nil
	keyP["second_hum_value"] = nil
	keyP["right_control_wind_current_free"] = nil
	keyP["left_control_wind_current_free"] = nil
	keyP["up_dn_dao_feng_tiao_current_stat"] = nil
	keyP["lt_rt_dao_feng_tiao_current_stat"] = nil
	keyP["pannel_protect"] = nil
	keyP["hydropenia"] = nil
	keyP["lt_rt_dao_feng_tiao_current_stat_left"] = nil
	keyP["up_dn_dao_feng_tiao_current_stat_left"] = nil
end
init_property_value()
local noWindSencePre = nil
local propertyPre = nil
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
local function makeSum(tmpbuf, start_pos, end_pos)
	local resVal = 0
	for si = start_pos, end_pos do
		resVal = resVal + tmpbuf[si]
		if resVal > 0xff then
			resVal = bit.band(resVal, 0xff)
		end
	end
	resVal = bit.band(255 - resVal + 1, 0xff)
	return resVal
end
local function splitStrByChar(str, sepChar)
	local splitList = {}
	local pattern = "[^" .. sepChar .. "]+"
	string.gsub(str, pattern, function(w)
		table.insert(splitList, w)
	end)
	return splitList
end
local function values(t)
	local i = 0
	return function()
		i = i + 1
		return t[i]
	end
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
local function jsonToModel(jsonCmd, jsonType)
	local streams = jsonCmd
	if
		jsonType == "control"
		and (
			(streams[keyT["KEY_POWER"]] ~= nil)
			or (streams[keyT["KEY_MODE"]] ~= nil)
			or (streams[keyT["KEY_TEMPERATURE"]] ~= nil)
			or (streams[keyT["KEY_FANSPEED"]] ~= nil)
			or (streams["targetLWindSpeed"] ~= nil)
			or (streams["targetRWindSpeed"] ~= nil)
			or (streams["sceneId"] ~= nil)
			or (streams["wind_speed_left"] ~= nil)
			or (streams["wind_speed_right"] ~= nil)
		)
	then
		keyP["propertyNumber"] = 1
		tempControl = 1
	end
	if streams[keyT["KEY_POWER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["powerValue"] = keyB["BYTE_POWER_ON"]
		keyP["fanspeedValue"] = keyB["BYTE_FANSPEED_AUTO"]
	elseif streams[keyT["KEY_POWER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["powerValue"] = keyB["BYTE_POWER_OFF"]
		keyP["fanspeedValue"] = keyB["BYTE_FANSPEED_AUTO"]
	end
	if streams[keyT["KEY_BUZZER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["buzzerValue"] = keyB["BYTE_BUZZER_ON"]
	elseif jsonType == "control" and streams[keyT["KEY_BUZZER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["buzzerValue"] = keyB["BYTE_BUZZER_OFF"]
	end
	if streams[keyT["KEY_PURIFIER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["purifierValue"] = keyB["BYTE_PURIFIER_ON"]
	elseif streams[keyT["KEY_PURIFIER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["purifierValue"] = keyB["BYTE_PURIFIER_OFF"]
	end
	if streams[keyT["KEY_ECO"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["ecoValue"] = keyB["BYTE_ECO_ON"]
	elseif streams[keyT["KEY_ECO"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["ecoValue"] = keyB["BYTE_ECO_OFF"]
	end
	if jsonType == "control" and streams[keyT["KEY_DRY"]] ~= nil then
		if propertyPre == nil then
			keyP["propertyNumber"] = keyP["propertyNumber"] + 1
			propertyPre = streams[keyT["KEY_DRY"]]
		end
		if streams[keyT["KEY_DRY"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["dryValue"] = 0x01
		elseif streams[keyT["KEY_DRY"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["dryValue"] = 0x00
		end
	end
	if streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_HEAT"] then
		keyP["modeValue"] = keyB["BYTE_MODE_HEAT"]
		keyP["PTCValue"] = keyB["BYTE_PTC_ON"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_COOL"] then
		keyP["modeValue"] = keyB["BYTE_MODE_COOL"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_AUTO"] then
		keyP["modeValue"] = keyB["BYTE_MODE_AUTO"]
		keyP["PTCValue"] = keyB["BYTE_PTC_ON"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_DRY"] then
		keyP["modeValue"] = keyB["BYTE_MODE_DRY"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_FAN"] then
		keyP["modeValue"] = keyB["BYTE_MODE_FAN"]
	end
	if streams["wind_speed_left"] ~= nil then
		keyP["wind_speed_left"] = checkBoundary(streams["wind_speed_left"], 1, 102)
	end
	if streams["wind_speed_right"] ~= nil then
		keyP["wind_speed_right"] = checkBoundary(streams["wind_speed_right"], 1, 102)
	end
	if jsonType == "control" and streams["wind_speed"] ~= nil then
		keyP["wind_speed_control"] = checkBoundary(streams["wind_speed"], 1, 102)
	end
	if jsonType == "status" and streams["wind_speed"] ~= nil then
		keyP["wind_speed"] = checkBoundary(streams["wind_speed"], 1, 102)
	end
	if jsonType == "control" and streams[keyT["KEY_SWING_UD"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["swingUDValue"] = keyB["BYTE_SWING_UD_ON"]
		keyP["propertyNumber"] = keyP["propertyNumber"] + 2
	elseif jsonType == "control" and streams[keyT["KEY_SWING_UD"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["swingUDValue"] = keyB["BYTE_SWING_UD_OFF"]
		keyP["propertyNumber"] = keyP["propertyNumber"] + 2
	end
	if jsonType == "control" and streams[keyT["KEY_SWING_LR"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["swingLRValue"] = keyB["BYTE_SWING_LR_ON"]
		keyP["propertyNumber"] = keyP["propertyNumber"] + 2
	elseif jsonType == "control" and streams[keyT["KEY_SWING_LR"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["swingLRValue"] = keyB["BYTE_SWING_LR_OFF"]
		keyP["propertyNumber"] = keyP["propertyNumber"] + 2
	end
	if streams[keyT["KEY_SWING_LR_UNDER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["swingLRUnderSwitch"] = keyB["BYTE_SWING_LR_UNDER_ENABLE"]
		keyP["swingLRValueUnder"] = keyB["BYTE_SWING_LR_UNDER_ON"]
	elseif streams[keyT["KEY_SWING_LR_UNDER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["swingLRUnderSwitch"] = keyB["BYTE_SWING_LR_UNDER_ENABLE"]
		keyP["swingLRValueUnder"] = keyB["BYTE_SWING_LR_UNDER_OFF"]
	end
	if streams[keyT["KEY_TIME_ON"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["openTimerSwitch"] = keyB["BYTE_START_TIMER_SWITCH_ON"]
	elseif streams[keyT["KEY_TIME_ON"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["openTimerSwitch"] = keyB["BYTE_START_TIMER_SWITCH_OFF"]
	end
	if streams[keyT["KEY_TIME_OFF"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["closeTimerSwitch"] = keyB["BYTE_CLOSE_TIMER_SWITCH_ON"]
	elseif streams[keyT["KEY_TIME_OFF"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["closeTimerSwitch"] = keyB["BYTE_CLOSE_TIMER_SWITCH_OFF"]
	end
	if streams[keyT["KEY_CLOSE_TIME"]] ~= nil then
		keyP["closeTime"] = streams[keyT["KEY_CLOSE_TIME"]]
	end
	if streams[keyT["KEY_OPEN_TIME"]] ~= nil then
		keyP["openTime"] = streams[keyT["KEY_OPEN_TIME"]]
	end
	if jsonType == "control" and streams[keyT["KEY_PTC"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_PTC"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["PTCValue"] = 0x01
		elseif streams[keyT["KEY_PTC"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["PTCValue"] = 0x00
		end
	end
	if streams[keyT["KEY_PREVENT_COLD"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["preventCold"] = keyB["BYTE_PREVENT_COLD_ON"]
	elseif streams[keyT["KEY_ECO"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["preventCold"] = keyB["BYTE_PREVENT_COLD_OFF"]
	end
	if jsonType == "control" and streams[keyT["KEY_STRONG_WIND"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_STRONG_WIND"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["strong_wind"] = 0x01
		elseif streams[keyT["KEY_STRONG_WIND"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["strong_wind"] = 0x00
		end
	end
	if streams[keyT["KEY_TEMPERATURE"]] ~= nil then
		keyP["temperature"] = checkBoundary(streams[keyT["KEY_TEMPERATURE"]], 16, 30)
	end
	if streams["small_temperature"] ~= nil then
		keyP["smallTemperature"] = checkBoundary(streams["small_temperature"], 0, 0.5)
		if keyP["smallTemperature"] == 0.5 then
			keyP["smallTemperature"] = 0x01
		else
			keyP["smallTemperature"] = 0x00
		end
	end
	if streams[keyT["KEY_COMFORT_POWER_SAVE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["comfortPowerSave"] = keyB["BYTE_COMFORT_POWER_SAVE_ON"]
	elseif streams[keyT["KEY_COMFORT_POWER_SAVE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["comfortPowerSave"] = keyB["BYTE_COMFORT_POWER_SAVE_OFF"]
	end
	if jsonType == "control" and streams[keyT["KEY_PREVENT_SUPER_COOL"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_PREVENT_SUPER_COOL"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["prevent_super_cool"] = 0x01
		elseif streams[keyT["KEY_PREVENT_SUPER_COOL"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["prevent_super_cool"] = 0x00
		end
	end
	if jsonType == "control" and streams[keyT["KEY_PREVENT_STRAIGHT_WIND"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["prevent_straight_wind"] = checkBoundary(streams[keyT["KEY_PREVENT_STRAIGHT_WIND"]], 0, 2)
	end
	if jsonType == "control" and streams[keyT["KEY_AUTO_PREVENT_STRAIGHT_WIND"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_AUTO_PREVENT_STRAIGHT_WIND"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["auto_prevent_straight_wind"] = 0x01
		elseif streams[keyT["KEY_AUTO_PREVENT_STRAIGHT_WIND"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["auto_prevent_straight_wind"] = 0x00
		end
	end
	if jsonType == "control" and streams[keyT["KEY_SELF_CLEAN"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_SELF_CLEAN"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["self_clean"] = 0x02
		elseif streams[keyT["KEY_SELF_CLEAN"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["self_clean"] = 0x01
		end
	end
	if jsonType == "control" and streams[keyT["KEY_NO_WIND_SENSE"]] ~= nil then
		if deviceSN8 == "12035" then
			keyP["propertyNumber"] = keyP["propertyNumber"] + 1
			keyP["no_wind_sense"] = checkBoundary(streams[keyT["KEY_NO_WIND_SENSE"]], 0, 5)
		else
			if noWindSencePre == nil then
				noWindSencePre = checkBoundary(streams[keyT["KEY_NO_WIND_SENSE"]], 0, 5)
				keyP["propertyNumber"] = keyP["propertyNumber"] + 1
				keyP["no_wind_sense"] = checkBoundary(streams[keyT["KEY_NO_WIND_SENSE"]], 0, 5)
			else
				keyP["no_wind_sense"] = checkBoundary(streams[keyT["KEY_NO_WIND_SENSE"]], 0, 5)
				if noWindSencePre == 2 then
					if streams[keyT["KEY_NO_WIND_SENSE"]] == 3 then
						keyP["no_wind_sense"] = 1
					end
				end
				if noWindSencePre == 3 then
					if streams[keyT["KEY_NO_WIND_SENSE"]] == 2 then
						keyP["no_wind_sense"] = 1
					end
				end
				if noWindSencePre == 1 then
					if streams[keyT["KEY_NO_WIND_SENSE"]] == 5 then
						keyP["no_wind_sense"] = 2
					end
				end
				if noWindSencePre == 1 then
					if streams[keyT["KEY_NO_WIND_SENSE"]] == 4 then
						keyP["no_wind_sense"] = 3
					end
				end
				if noWindSencePre == 2 then
					if streams[keyT["KEY_NO_WIND_SENSE"]] == 4 then
						keyP["no_wind_sense"] = 0
					end
				end
				if noWindSencePre == 3 then
					if streams[keyT["KEY_NO_WIND_SENSE"]] == 5 then
						keyP["no_wind_sense"] = 0
					end
				end
			end
		end
	end
	if jsonType == "control" and streams[keyT["KEY_CHILD_PREVENT_COLD_WIND"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_CHILD_PREVENT_COLD_WIND"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["child_prevent_cold_wind"] = 0x01
		elseif streams[keyT["KEY_CHILD_PREVENT_COLD_WIND"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["child_prevent_cold_wind"] = 0x00
		end
	end
	if jsonType == "control" and streams[keyT["KEY_LITTLE_ANGLE"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_LITTLE_ANGLE"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["little_angel"] = 0x01
		elseif streams[keyT["KEY_LITTLE_ANGLE"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["little_angel"] = 0x00
		end
	end
	if jsonType == "control" and streams[keyT["KEY_COOL_HOT_SENSE"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_COOL_HOT_SENSE"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["cool_hot_sense"] = 0x01
		elseif streams[keyT["KEY_COOL_HOT_SENSE"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["cool_hot_sense"] = 0x00
		end
	end
	if jsonType == "control" and streams[keyT["KEY_GENTLE_WIND_SENSE"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_GENTLE_WIND_SENSE"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["gentle_wind_sense"] = 0x03
		elseif streams[keyT["KEY_GENTLE_WIND_SENSE"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["gentle_wind_sense"] = 0x01
		end
	end
	if jsonType == "control" and streams[keyT["KEY_SECURITY"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_SECURITY"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["security"] = 0x01
		elseif streams[keyT["KEY_SECURITY"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["security"] = 0x00
		end
	end
	if jsonType == "control" and streams[keyT["KEY_SCREEN_DISPLAY"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams[keyT["KEY_SCREEN_DISPLAY"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["screen_display"] = 0x64
		elseif streams[keyT["KEY_SCREEN_DISPLAY"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["screen_display"] = 0x00
		end
	end
	if streams["sceneId"] ~= nil then
		keyP["sceneId"] = streams["sceneId"]
	end
	if streams["targetLWindSpeed"] ~= nil then
		keyP["targetLWindSpeed"] = streams["targetLWindSpeed"]
	end
	if streams["targetRWindSpeed"] ~= nil then
		keyP["targetRWindSpeed"] = streams["targetRWindSpeed"]
	end
	if jsonType == "control" and streams["fresh_air"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["fresh_air"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["fresh_air"] = keyB["BYTE_FRESH_AIR_ON"]
		elseif streams["fresh_air"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["fresh_air"] = keyB["BYTE_FRESH_AIR_OFF"]
		else
			keyP["fresh_air"] = 0x00
		end
	end
	if streams["fresh_air_fan_speed"] ~= nil then
		keyP["fresh_air_fan_speed"] = streams["fresh_air_fan_speed"]
	end
	if streams["fresh_air_mode"] ~= nil then
		keyP["fresh_air_mode"] = streams["fresh_air_mode"]
	end
	if streams["fresh_air_mode_2"] ~= nil then
		keyP["fresh_air_mode_2"] = streams["fresh_air_mode_2"]
	end
	if streams["fresh_air_on_co2"] ~= nil then
		keyP["fresh_air_on_co2"] = streams["fresh_air_on_co2"]
	end
	if streams["fresh_air_off_co2"] ~= nil then
		keyP["fresh_air_off_co2"] = streams["fresh_air_off_co2"]
	end
	if streams["fresh_air_current_co2"] ~= nil then
		keyP["fresh_air_current_co2"] = streams["fresh_air_current_co2"]
	end
	if jsonType == "control" and streams["remove_odor"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["remove_odor"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["remove_odor"] = keyB["BYTE_REMOVE_ODOR_ON"]
		elseif streams["remove_odor"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["remove_odor"] = keyB["BYTE_REMOVE_ODOR_OFF"]
		else
			keyP["remove_odor"] = 0x00
		end
	end
	if streams["remove_odor_fan_speed"] ~= nil then
		keyP["remove_odor_fan_speed"] = streams["remove_odor_fan_speed"]
	end
	if streams["remove_odor_mode"] ~= nil then
		keyP["remove_odor_mode"] = streams["remove_odor_mode"]
	end
	if streams["remove_odor_time"] ~= nil then
		keyP["remove_odor_time"] = streams["remove_odor_time"]
	end
	if streams["remove_odor_operating_time"] ~= nil then
		keyP["remove_odor_operating_time"] = streams["remove_odor_operating_time"]
	end
	if jsonType == "control" and streams["inner_purifier"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["inner_purifier"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["inner_purifier"] = keyB["BYTE_INNER_PURIFIER_ON"]
		elseif streams["inner_purifier"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["inner_purifier"] = keyB["BYTE_INNER_PURIFIER_OFF"]
		else
			keyP["inner_purifier"] = 0x00
		end
	end
	if streams["inner_purifier_fan_speed"] ~= nil then
		keyP["inner_purifier_fan_speed"] = streams["inner_purifier_fan_speed"]
	end
	if streams["inner_purifier_mode"] ~= nil then
		keyP["inner_purifier_mode"] = streams["inner_purifier_mode"]
	end
	if streams["inner_purifier_on_pm"] ~= nil then
		keyP["inner_purifier_on_pm"] = streams["inner_purifier_on_pm"]
	end
	if streams["inner_purifier_off_pm"] ~= nil then
		keyP["inner_purifier_off_pm"] = streams["inner_purifier_off_pm"]
	end
	if streams["inner_purifier_current_pm"] ~= nil then
		keyP["inner_purifier_current_pm"] = streams["inner_purifier_current_pm"]
	end
	if jsonType == "control" and streams["airoptimization"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["airoptimization"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["airoptimization"] = keyB["BYTE_AIROPTIMIZATION_ON"]
		elseif streams["airoptimization"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["airoptimization"] = keyB["BYTE_AIROPTIMIZATION_OFF"]
		else
			keyP["airoptimization"] = 0x00
		end
	end
	if jsonType == "control" and streams["no_wind_sense_left"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["no_wind_sense_left"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["no_wind_sense_left"] = keyB["BYTE_NO_WIND_SENSE_LEFT_ON"]
		elseif streams["no_wind_sense_left"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["no_wind_sense_left"] = keyB["BYTE_NO_WIND_SENSE_LEFT_OFF"]
		else
			keyP["no_wind_sense_left"] = 0x00
		end
	end
	if streams["left_profile"] ~= nil then
		keyP["left_profile"] = streams["left_profile"]
	end
	if jsonType == "control" and streams["no_wind_sense_right"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["no_wind_sense_right"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["no_wind_sense_right"] = keyB["BYTE_NO_WIND_SENSE_RIGHT_ON"]
		elseif streams["no_wind_sense_right"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["no_wind_sense_right"] = keyB["BYTE_NO_WIND_SENSE_RIGHT_OFF"]
		else
			keyP["no_wind_sense_right"] = 0x00
		end
	end
	if streams["right_profile"] ~= nil then
		keyP["right_profile"] = streams["right_profile"]
	end
	if jsonType == "control" and streams["humidification"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["humidification"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["humidification"] = keyB["BYTE_HUMIDIFICATION_ON"]
		elseif streams["humidification"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["humidification"] = keyB["BYTE_HUMIDIFICATION_OFF"]
		else
			keyP["humidification"] = 0x00
		end
	end
	if streams["humidification_fan_speed"] ~= nil then
		keyP["humidification_fan_speed"] = streams["humidification_fan_speed"]
	end
	if streams["humidification_mode"] ~= nil then
		keyP["humidification_mode"] = streams["humidification_mode"]
	end
	if streams["humidification_auto_on"] ~= nil then
		keyP["humidification_auto_on"] = streams["humidification_auto_on"]
	end
	if streams["humidification_auto_off"] ~= nil then
		keyP["humidification_auto_off"] = streams["humidification_auto_off"]
	end
	if streams["humidification_manual"] ~= nil then
		keyP["humidification_manual"] = streams["humidification_manual"]
	end
	if streams["humidification_current"] ~= nil then
		keyP["humidification_current"] = streams["humidification_current"]
	end
	if jsonType == "control" and streams["light"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["light"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["light"] = keyB["BYTE_LIGHT_ON"]
		elseif streams["light"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["light"] = keyB["BYTE_LIGHT_OFF"]
			keyP["light_bright"] = 0x00
		else
			keyP["light"] = 0x00
		end
	end
	if streams["light_bright"] ~= nil then
		if streams["light"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["light_bright"] = 0x00
		else
			keyP["light_bright"] = streams["light_bright"]
		end
		keyP["light_air_level"] = streams["light_air_level"]
	end
	if jsonType == "control" and streams["down_wind_speed"] ~= nil then
		if propertyPre == nil then
			keyP["propertyNumber"] = keyP["propertyNumber"] + 4
			propertyPre = 1
		else
			keyP["propertyNumber"] = keyP["propertyNumber"] + 3
		end
		keyP["humidification_fan_speed"] = streams["down_wind_speed"]
		keyP["inner_purifier_fan_speed"] = streams["down_wind_speed"]
		keyP["fresh_air_fan_speed"] = streams["down_wind_speed"]
		keyP["remove_odor_fan_speed"] = streams["down_wind_speed"]
	end
	if jsonType == "control" and streams["up_control_wind"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["up_control_wind"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["up_control_wind"] = 0x02
		elseif streams["up_control_wind"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["up_control_wind"] = 0x01
		else
			keyP["up_control_wind"] = 0x00
		end
	end
	if streams["up_control_wind_degree"] ~= nil then
		keyP["up_control_wind_degree"] = streams["up_control_wind_degree"]
	end
	if jsonType == "control" and streams["down_control_wind"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["up_control_wind"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["down_control_wind"] = 0x02
		elseif streams["up_control_wind"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["down_control_wind"] = 0x01
		else
			keyP["down_control_wind"] = 0x00
		end
	end
	if streams["down_control_wind_degree"] ~= nil then
		keyP["down_control_wind_degree"] = streams["down_control_wind_degree"]
	end
	if jsonType == "control" and streams["wait_clean"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		if streams["wait_clean"] == keyV["VALUE_FUNCTION_ON"] then
			keyP["wait_clean"] = 0x01
		elseif streams["wait_clean"] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["wait_clean"] = 0x00
		else
			keyP["wait_clean"] = 0x00
		end
	end
	if jsonType == "control" and streams["left_wind"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["left_wind"] = streams["left_wind"]
	end
	if streams["right_wind"] ~= nil then
		keyP["right_wind"] = streams["right_wind"]
	end
	if jsonType == "control" and streams["purify_film"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["purify_film"] = checkBoundary(streams["purify_film"], 0, 3)
	end
	if streams["purify_film_time"] ~= nil then
		keyP["purify_film_time"] = streams["purify_film_time"]
	end
	if jsonType == "control" and streams["wetfilm_state"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wetfilm_state"] = checkBoundary(streams["wetfilm_state"], 0, 3)
	end
	if streams["wetfilm_state_time"] ~= nil then
		keyP["wetfilm_state_time"] = streams["wetfilm_state_time"]
	end
	if jsonType == "control" and streams["acstrainer_state"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["acstrainer_state"] = checkBoundary(streams["acstrainer_state"], 0, 3)
	end
	if streams["acstrainer_state_time"] ~= nil then
		keyP["acstrainer_state_time"] = streams["acstrainer_state_time"]
	end
	if jsonType == "control" and streams["get_weather"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["get_weather"] = checkBoundary(streams["get_weather"], 0, 1)
	end
	if streams["outdoor_pm25"] ~= nil then
		keyP["outdoor_pm25"] = streams["outdoor_pm25"]
	end
	if jsonType == "control" and streams["near_switch"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["near_switch"] = checkBoundary(streams["near_switch"], 0, 2)
	end
	if streams["near_no_yes"] ~= nil then
		keyP["near_no_yes"] = streams["near_no_yes"]
	end
	if jsonType == "control" and streams["water_supply"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["water_supply"] = streams["water_supply"]
	end
	if streams["water_level"] ~= nil then
		keyP["water_level"] = streams["water_level"]
	end
	if streams["water_tank"] ~= nil then
		keyP["water_tank"] = streams["water_tank"]
	end
	if
		jsonType == "control"
		and (
			streams["air_condition_temp"] ~= nil
			or streams["air_condition_humidity"] ~= nil
			or streams["air_condition_clean"] ~= nil
			or streams["air_condition_fresh"] ~= nil
		)
	then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
	end
	if streams["air_condition_humidity"] ~= nil then
		keyP["air_condition_humidity"] = streams["air_condition_humidity"]
	end
	if streams["air_condition_temp"] ~= nil then
		keyP["air_condition_temp"] = streams["air_condition_temp"]
	end
	if streams["air_condition_clean"] ~= nil then
		keyP["air_condition_clean"] = streams["air_condition_clean"]
	end
	if streams["air_condition_fresh"] ~= nil then
		keyP["air_condition_fresh"] = streams["air_condition_fresh"]
	end
	if jsonType == "control" and streams["indoor_temp"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["indoor_temp"] = streams["indoor_temp"] * 2 + 50
	end
	if streams["indoor_temp_decimal"] ~= nil then
		keyP["indoor_temp_decimal"] = streams["indoor_temp_decimal"] * 10
	end
	if jsonType == "control" and streams["outdoor_temp"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["outdoor_temp"] = streams["outdoor_temp"] * 2 + 50
	end
	if streams["outdoor_temp_decimal"] ~= nil then
		keyP["outdoor_temp_decimal"] = streams["outdoor_temp_decimal"] * 10
	end
	if jsonType == "control" and streams["eco_switch"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["eco_switch"] = streams["eco_switch"]
	end
	if streams["eco_second"] ~= nil then
		keyP["eco_hour"] = streams["eco_hour"]
	end
	if streams["eco_min"] ~= nil then
		keyP["eco_min"] = streams["eco_min"]
	end
	if streams["eco_second"] ~= nil then
		keyP["eco_second"] = streams["eco_second"]
	end
	if jsonType == "control" and streams["keep_warm_switch"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["keep_warm_switch"] = streams["keep_warm_switch"]
	end
	if streams["keep_warm_temp"] ~= nil then
		keyP["keep_warm_temp"] = streams["keep_warm_temp"]
	end
	if jsonType == "control" and streams["close_screen"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["close_screen"] = streams["close_screen"]
	end
	if jsonType == "control" and streams["exclusive_mode"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["exclusive_mode"] = streams["exclusive_mode"]
	end
	if jsonType == "control" and streams["family_number"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["family_number"] = streams["family_number"]
	end
	if jsonType == "control" and streams["wind_blow_close"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_blow_close"] = streams["wind_blow_close"]
	end
	if jsonType == "control" and streams["wisdom_wind"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wisdom_wind"] = streams["wisdom_wind"]
	end
	if jsonType == "control" and streams["wisdom_wind_new"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wisdom_wind_new"] = streams["wisdom_wind_new"]
	end
	if streams["wisdom_left_distance"] ~= nil then
		keyP["wisdom_left_distance"] = streams["wisdom_left_distance"]
	end
	if streams["wisdom_right_distance"] ~= nil then
		keyP["wisdom_right_distance"] = streams["wisdom_right_distance"]
	end
	if streams["wisdom_left_set_wind"] ~= nil then
		keyP["wisdom_left_set_wind"] = streams["wisdom_left_set_wind"]
	end
	if streams["wisdom_right_set_wind"] ~= nil then
		keyP["wisdom_right_set_wind"] = streams["wisdom_right_set_wind"]
	end
	if streams["wisdom_left_down_angle"] ~= nil then
		keyP["wisdom_left_down_angle"] = streams["wisdom_left_down_angle"]
	end
	if streams["wisdom_right_down_angle"] ~= nil then
		keyP["wisdom_right_down_angle"] = streams["wisdom_right_down_angle"]
	end
	if streams["wisdom_left_up_angle"] ~= nil then
		keyP["wisdom_left_up_angle"] = streams["wisdom_left_up_angle"]
	end
	if streams["wisdom_right_up_angle"] ~= nil then
		keyP["wisdom_right_up_angle"] = streams["wisdom_right_up_angle"]
	end
	if jsonType == "control" and streams["wind_blow"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_blow"] = streams["wind_blow"]
	end
	if streams["wind_blow_left_distance"] ~= nil then
		keyP["wind_blow_left_distance"] = streams["wind_blow_left_distance"]
	end
	if streams["wind_blow_right_distance"] ~= nil then
		keyP["wind_blow_right_distance"] = streams["wind_blow_right_distance"]
	end
	if streams["wind_blow_left_set_wind"] ~= nil then
		keyP["wind_blow_left_set_wind"] = streams["wind_blow_left_set_wind"]
	end
	if streams["wind_blow_right_set_wind"] ~= nil then
		keyP["wind_blow_right_set_wind"] = streams["wind_blow_right_set_wind"]
	end
	if streams["wind_blow_left_down_angle"] ~= nil then
		keyP["wind_blow_left_down_angle"] = streams["wind_blow_left_down_angle"]
	end
	if streams["wind_blow_right_down_angle"] ~= nil then
		keyP["wind_blow_right_down_angle"] = streams["wind_blow_right_down_angle"]
	end
	if streams["wind_blow_left_up_angle"] ~= nil then
		keyP["wind_blow_left_up_angle"] = streams["wind_blow_left_up_angle"]
	end
	if streams["wind_blow_right_up_angle"] ~= nil then
		keyP["wind_blow_right_up_angle"] = streams["wind_blow_right_up_angle"]
	end
	if jsonType == "control" and streams["wind_close"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_close"] = streams["wind_close"]
	end
	if streams["wind_close_left_distance"] ~= nil then
		keyP["wind_close_left_distance"] = streams["wind_close_left_distance"]
	end
	if streams["wind_close_right_distance"] ~= nil then
		keyP["wind_close_right_distance"] = streams["wind_close_right_distance"]
	end
	if streams["wind_close_left_set_wind"] ~= nil then
		keyP["wind_close_left_set_wind"] = streams["wind_close_left_set_wind"]
	end
	if streams["wind_close_right_set_wind"] ~= nil then
		keyP["wind_close_right_set_wind"] = streams["wind_close_right_set_wind"]
	end
	if streams["wind_close_left_down_angle"] ~= nil then
		keyP["wind_close_left_down_angle"] = streams["wind_close_left_down_angle"]
	end
	if streams["wind_close_right_down_angle"] ~= nil then
		keyP["wind_close_right_down_angle"] = streams["wind_close_right_down_angle"]
	end
	if streams["wind_close_left_up_angle"] ~= nil then
		keyP["wind_close_left_up_angle"] = streams["wind_close_left_up_angle"]
	end
	if streams["wind_close_right_up_angle"] ~= nil then
		keyP["wind_close_right_up_angle"] = streams["wind_close_right_up_angle"]
	end
	if jsonType == "control" and streams["camera_direction_switch"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["camera_direction_switch"] = streams["camera_direction_switch"]
	end
	if streams["camera_direction_state"] ~= nil then
		keyP["camera_direction_state"] = streams["camera_direction_state"]
	end
	if streams["camera_direction_left"] ~= nil then
		keyP["camera_direction_left"] = streams["camera_direction_left"]
	end
	if streams["camera_direction_right"] ~= nil then
		keyP["camera_direction_right"] = streams["camera_direction_right"]
	end
	if jsonType == "control" and streams["clean_switch"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["clean_switch"] = streams["clean_switch"]
	end
	if streams["clean_running_stage"] ~= nil then
		keyP["clean_running_stage"] = streams["clean_running_stage"]
	end
	if streams["clean_running_time"] ~= nil then
		keyP["clean_running_time"] = streams["clean_running_time"]
	end
	if streams["clean_target_time"] ~= nil then
		keyP["clean_target_time"] = streams["clean_target_time"]
	end
	if jsonType == "control" and streams["light_class_switch"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["light_class_switch"] = streams["light_class_switch"]
	end
	if streams["light_class"] ~= nil then
		keyP["light_class"] = streams["light_class"]
	end
	if jsonType == "control" and streams["wind_swing_left"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_swing_left"] = streams["wind_swing_left"]
	end
	if streams["wind_swing_left_degree"] ~= nil then
		keyP["wind_swing_left_degree"] = streams["wind_swing_left_degree"]
	end
	if jsonType == "control" and streams["wind_swing_right"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_swing_right"] = streams["wind_swing_right"]
	end
	if streams["wind_swing_right_degree"] ~= nil then
		keyP["wind_swing_right_degree"] = streams["wind_swing_right_degree"]
	end
	if jsonType == "control" and streams["wind_swing_ud_right"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_swing_ud_right"] = streams["wind_swing_ud_right"]
	end
	if streams["wind_swing_ud_right_degree"] ~= nil then
		keyP["wind_swing_ud_right_degree"] = streams["wind_swing_ud_right_degree"]
	end
	if jsonType == "control" and streams["wind_swing_ud_left"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_swing_ud_left"] = streams["wind_swing_ud_left"]
	end
	if streams["wind_swing_ud_left_degree"] ~= nil then
		keyP["wind_swing_ud_left_degree"] = streams["wind_swing_ud_left_degree"]
	end
	if jsonType == "control" and streams["intrusion"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["intrusion"] = streams["intrusion"]
	end
	if jsonType == "control" and streams["intrusion_video"] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["intrusion_video"] = streams["intrusion_video"]
	end
	if jsonType == "control" and streams[keyT["KEY_VOICE_CONTROL_NEW"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["voice_control_new"] = checkBoundary(streams[keyT["KEY_VOICE_CONTROL_NEW"]], 0, 3)
	end
	if jsonType == "control" and streams[keyT["KEY_WIND_SWING_UD_ANGLE"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_swing_ud_angle"] = streams["wind_swing_ud_angle"]
	end
	if jsonType == "control" and streams[keyT["KEY_WIND_SWING_LR_ANGLE"]] ~= nil then
		keyP["propertyNumber"] = keyP["propertyNumber"] + 1
		keyP["wind_swing_lr_angle"] = streams["wind_swing_lr_angle"]
	end
	if jsonType == "control" and streams["cmdOrder"] ~= nil then
		cmdOrder = streams["cmdOrder"]
	end
	if
		(
			(streams[keyT["KEY_MODE"]] ~= nil and streams[keyT["KEY_MODE"]] == "smart_dry")
			or (streams["power_on_timer"] ~= nil)
			or (streams["power_off_timer"] ~= nil)
			or (streams["comfort_sleep"] ~= nil)
		) and (jsonType == "control")
	then
		keyP["propertyNumber"] = 0
	end
	if jsonType == "status" then
		keyP["propertyNumber"] = 0
	end
end
local function binToModel(binData)
	local messageBytes = binData
	keyP["analysis_value"] = nil
	if (dataType == 0x03 and messageBytes[0] == 0xC1) or (dataType == 0x05 and messageBytes[0] == 0xC1) then
		if messageBytes[1] == 0x01 then
			keyP["analysis_value"] =
				"new_wind_fun_wind_mode,smart_clean_sw,sterilize_sw,new_wind_fun_sw,hum_fun_sw,clean_fun_sw,clean_fun_sw,run_status,device_set_run_status,purfiy_film,wetfilm_fun_sw,diy_func,strong,elec_heat,acstrainer_sw,airoptimization_sw,open_close_time,run_current_status,device_current_run_status,temp_out,tp_temp,temp_in,com_run_frequency,com_target_frequency,ya_suo_ji_dian_liu,shi_wai_ji_zong_dian_liu,shi_wai_ji_dian_ya,shi_nei_ji_yun_zhuan_moshi,left_wind_class,right_wind_class,room_i_fault_state1_0,room_i_fault_state1_1,room_i_fault_state1_2,room_i_fault_state1_3,room_i_fault_state1_4,room_i_fault_state1_5,room_i_fault_state1_6,room_i_fault_state1_7,room_i_fault_state2_0,room_i_fault_state2_1,room_i_fault_state2_2,room_i_fault_state2_3,room_i_fault_state2_4,room_i_fault_state2_5,room_i_fault_state2_6,room_i_fault_state2_7,room_i_fault_state3_0,room_i_fault_state3_1,room_i_fault_state3_2,room_i_fault_state3_3,room_i_fault_state3_4,room_i_fault_state3_5,room_i_fault_state3_6,room_i_fault_state3_7,room_i_limit_freq_state1_0,room_i_limit_freq_state1_1,room_i_limit_freq_state1_2,room_i_limit_freq_state1_3,room_i_limit_freq_state1_4,room_i_limit_freq_state1_5,room_i_limit_freq_state1_6,room_i_limit_freq_state1_7room_i_limit_freq_state2_0,room_i_limit_freq_state2_1,room_i_limit_freq_state2_2,room_i_limit_freq_state2_3,room_i_limit_freq_state2_4,room_i_limit_freq_state2_5,room_i_limit_freq_state2_6,room_i_limit_freq_state2_7,room_i_load_state1_0,room_i_load_state1_1,room_i_load_state1_2,room_i_load_state1_3,room_i_load_state1_4,room_i_load_state1_5,room_i_load_state1_6,room_i_load_state1_7,out_door_dev_state1_0,out_door_dev_state1_1,out_door_dev_state1_2,out_door_dev_state1_3,out_door_dev_state1_4,out_door_dev_state1_5,out_door_dev_state1_6,out_door_dev_state1_7,out_door_dev_state2_0,out_door_dev_state2_1,out_door_dev_state2_2,out_door_dev_state2_3,out_door_dev_state2_4,out_door_dev_state2_5,out_door_dev_state2_6,out_door_dev_state2_7,out_door_dev_state3_0,out_door_dev_state3_1,out_door_dev_state3_2,out_door_dev_state3_3,out_door_dev_state3_4,out_door_dev_state3_5,out_door_dev_state3_6,out_door_dev_state3_7,out_door_dev_state4_0,out_door_dev_state4_1,out_door_dev_state4_2,out_door_dev_state4_3,out_door_dev_state4_4,out_door_dev_state4_5,out_door_dev_state4_6,out_door_dev_state4_7,out_door_dev_state5_0,out_door_dev_state5_1,out_door_dev_state5_2,out_door_dev_state5_3,out_door_dev_state5_4,out_door_dev_state5_5,out_door_dev_state5_6,out_door_dev_state5_7,out_door_dev_state6_0,out_door_dev_state6_1,out_door_dev_state6_2,out_door_dev_state6_3,out_door_dev_state6_4,out_door_dev_state6_5,out_door_dev_state6_6,out_door_dev_state6_7,out_door_i_fan_speed,out_door_ele_switch,out_door_back_temp,out_door_voltage,ipm_temp,dry_heat_time_value,new_wind_fun_current_value,clean_fun_current_value,hum_fun_wind_current_value,sterilize_run_time,wetfilm_time,purfiy_film_time,smart_clean_current_run_time,right_wind_rotate_speed,left_wind_rotate_speed,left_wind_current_class,right_wind_current_class,down_wind_set_class,down_wind_current_class,set_hum_value,hum_fun_wind_class,clean_fun_wind_class,new_wind_fun_class,sterilize_wind_class,product_code,err_code_class,in_display_transport,compressor_pos_protect,in_display_transit,run_current_status"
			keyP["new_wind_fun_wind_mode"] = bit.rshift(bit.band(messageBytes[2], 0x80), 7)
			keyP["smart_clean_sw"] = bit.rshift(bit.band(messageBytes[2], 0x40), 6)
			keyP["sterilize_sw"] = bit.rshift(bit.band(messageBytes[2], 0x20), 5)
			keyP["new_wind_fun_sw"] = bit.rshift(bit.band(messageBytes[2], 0x10), 4)
			keyP["hum_fun_sw"] = bit.rshift(bit.band(messageBytes[2], 0x08), 3)
			keyP["clean_fun_sw"] = bit.rshift(bit.band(messageBytes[2], 0x04), 2)
			keyP["run_status"] = bit.rshift(bit.band(messageBytes[2], 0x02), 1)
			keyP["device_set_run_status"] = bit.band(messageBytes[2], 0x01)
			keyP["purfiy_film"] = bit.band(messageBytes[3], 0x01)
			keyP["wetfilm_fun_sw"] = bit.rshift(bit.band(messageBytes[3], 0x02), 1)
			keyP["diy_func"] = bit.rshift(bit.band(messageBytes[3], 0x04), 2)
			keyP["strong"] = bit.rshift(bit.band(messageBytes[3], 0x08), 3)
			keyP["elec_heat"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4)
			keyP["acstrainer_sw"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5)
			keyP["airoptimization_sw"] = bit.rshift(bit.band(messageBytes[3], 0x40), 6)
			keyP["open_close_time"] = bit.rshift(bit.band(messageBytes[3], 0x80), 7)
			keyP["run_current_status"] = bit.band(messageBytes[4], 0x01)
			keyP["device_current_run_status"] = bit.rshift(bit.band(messageBytes[4], 0x02), 1)
			keyP["current_run_mode"] = messageBytes[6]
			if messageBytes[10] >= 128 then
				if messageBytes[10] == 255 and messageBytes[9] == 255 then
					keyP["t1_temp"] = 255
				else
					keyP["t1_temp"] = (((messageBytes[10] * 256 + messageBytes[9]) - 65535) - 1) * 0.01
				end
				keyP["analysis_value"] = keyP["analysis_value"] .. ",t1_temp"
			else
				keyP["t1_temp"] = (messageBytes[10] * 256 + messageBytes[9]) * 0.01
				keyP["analysis_value"] = keyP["analysis_value"] .. ",t1_temp"
			end
			if messageBytes[12] >= 128 then
				if messageBytes[12] == 255 and messageBytes[11] == 255 then
					keyP["t2_temp"] = 255
				else
					keyP["t2_temp"] = ((messageBytes[12] * 256 + messageBytes[11]) - 65535 + 1) * 0.01
				end
				keyP["analysis_value"] = keyP["analysis_value"] .. ",t2_temp"
			else
				keyP["t2_temp"] = (messageBytes[12] * 256 + messageBytes[11]) * 0.01
				keyP["analysis_value"] = keyP["analysis_value"] .. ",t2_temp"
			end
			if messageBytes[14] >= 128 then
				if messageBytes[14] == 255 and messageBytes[13] == 255 then
					keyP["t3_temp"] = 255
				else
					keyP["t3_temp"] = ((messageBytes[14] * 256 + messageBytes[13]) - 65535 + 1) * 0.01
				end
				keyP["analysis_value"] = keyP["analysis_value"] .. ",t3_temp"
			else
				keyP["t3_temp"] = (messageBytes[14] * 256 + messageBytes[13]) * 0.01
				keyP["analysis_value"] = keyP["analysis_value"] .. ",t3_temp"
			end
			if messageBytes[16] >= 128 then
				if messageBytes[16] == 255 and messageBytes[15] == 255 then
					keyP["t4_temp"] = 255
				else
					keyP["t4_temp"] = ((messageBytes[16] * 256 + messageBytes[15]) - 65535 + 1) * 0.01
				end
				keyP["analysis_value"] = keyP["analysis_value"] .. ",t4_temp"
			else
				keyP["t4_temp"] = (messageBytes[16] * 256 + messageBytes[15]) * 0.01
				keyP["analysis_value"] = keyP["analysis_value"] .. ",t4_temp"
			end
			keyP["temp_out"] = keyP["t4_temp"]
			keyP["tp_temp"] = messageBytes[17]
			keyP["temp_in"] = keyP["tp_temp"]
			keyP["com_run_frequency"] = messageBytes[18]
			keyP["com_target_frequency"] = messageBytes[19]
			keyP["ya_suo_ji_dian_liu"] = messageBytes[20]
			keyP["shi_wai_ji_zong_dian_liu"] = messageBytes[21] * 4
			keyP["shi_wai_ji_dian_ya"] = messageBytes[22]
			keyP["shi_nei_ji_yun_zhuan_moshi"] = messageBytes[23]
			keyP["left_wind_class"] = messageBytes[24]
			keyP["right_wind_class"] = messageBytes[25]
			keyP["room_i_fault_state1_0"] = bit.band(messageBytes[26], 0x01)
			keyP["room_i_fault_state1_1"] = bit.rshift(bit.band(messageBytes[26], 0x02), 1)
			keyP["room_i_fault_state1_2"] = bit.rshift(bit.band(messageBytes[26], 0x04), 2)
			keyP["room_i_fault_state1_3"] = bit.rshift(bit.band(messageBytes[26], 0x08), 3)
			keyP["room_i_fault_state1_4"] = bit.rshift(bit.band(messageBytes[26], 0x10), 4)
			keyP["room_i_fault_state1_5"] = bit.rshift(bit.band(messageBytes[26], 0x20), 5)
			keyP["room_i_fault_state1_6"] = bit.rshift(bit.band(messageBytes[26], 0x40), 6)
			keyP["room_i_fault_state1_7"] = bit.rshift(bit.band(messageBytes[26], 0x80), 7)
			keyP["room_i_fault_state2_0"] = bit.band(messageBytes[27], 0x01)
			keyP["room_i_fault_state2_1"] = bit.rshift(bit.band(messageBytes[27], 0x02), 1)
			keyP["room_i_fault_state2_2"] = bit.rshift(bit.band(messageBytes[27], 0x04), 2)
			keyP["room_i_fault_state2_3"] = bit.rshift(bit.band(messageBytes[27], 0x08), 3)
			keyP["room_i_fault_state2_4"] = bit.rshift(bit.band(messageBytes[27], 0x10), 4)
			keyP["room_i_fault_state2_5"] = bit.rshift(bit.band(messageBytes[27], 0x20), 5)
			keyP["room_i_fault_state2_6"] = bit.rshift(bit.band(messageBytes[27], 0x40), 6)
			keyP["room_i_fault_state2_7"] = bit.rshift(bit.band(messageBytes[27], 0x80), 7)
			keyP["room_i_fault_state3_0"] = bit.band(messageBytes[28], 0x01)
			keyP["room_i_fault_state3_1"] = bit.rshift(bit.band(messageBytes[28], 0x02), 1)
			keyP["room_i_fault_state3_2"] = bit.rshift(bit.band(messageBytes[28], 0x04), 2)
			keyP["room_i_fault_state3_3"] = bit.rshift(bit.band(messageBytes[28], 0x08), 3)
			keyP["room_i_fault_state3_4"] = bit.rshift(bit.band(messageBytes[28], 0x10), 4)
			keyP["room_i_fault_state3_5"] = bit.rshift(bit.band(messageBytes[28], 0x20), 5)
			keyP["room_i_fault_state3_6"] = bit.rshift(bit.band(messageBytes[28], 0x40), 6)
			keyP["room_i_fault_state3_7"] = bit.rshift(bit.band(messageBytes[28], 0x80), 7)
			keyP["room_i_limit_freq_state1_0"] = bit.band(messageBytes[29], 0x01)
			keyP["room_i_limit_freq_state1_1"] = bit.rshift(bit.band(messageBytes[29], 0x02), 1)
			keyP["room_i_limit_freq_state1_2"] = bit.rshift(bit.band(messageBytes[29], 0x04), 2)
			keyP["room_i_limit_freq_state1_3"] = bit.rshift(bit.band(messageBytes[29], 0x08), 3)
			keyP["room_i_limit_freq_state1_4"] = bit.rshift(bit.band(messageBytes[29], 0x10), 4)
			keyP["room_i_limit_freq_state1_5"] = bit.rshift(bit.band(messageBytes[29], 0x20), 5)
			keyP["room_i_limit_freq_state1_6"] = bit.rshift(bit.band(messageBytes[29], 0x40), 6)
			keyP["room_i_limit_freq_state1_7"] = bit.rshift(bit.band(messageBytes[29], 0x80), 7)
			keyP["room_i_limit_freq_state2_0"] = bit.band(messageBytes[30], 0x01)
			keyP["room_i_limit_freq_state2_1"] = bit.rshift(bit.band(messageBytes[30], 0x02), 1)
			keyP["room_i_limit_freq_state2_2"] = bit.rshift(bit.band(messageBytes[30], 0x04), 2)
			keyP["room_i_limit_freq_state2_3"] = bit.rshift(bit.band(messageBytes[30], 0x08), 3)
			keyP["room_i_limit_freq_state2_4"] = bit.rshift(bit.band(messageBytes[30], 0x10), 4)
			keyP["room_i_limit_freq_state2_5"] = bit.rshift(bit.band(messageBytes[30], 0x20), 5)
			keyP["room_i_limit_freq_state2_6"] = bit.rshift(bit.band(messageBytes[30], 0x40), 6)
			keyP["room_i_limit_freq_state2_7"] = bit.rshift(bit.band(messageBytes[30], 0x80), 7)
			keyP["room_i_load_state1_0"] = bit.band(messageBytes[32], 0x01)
			keyP["room_i_load_state1_1"] = bit.rshift(bit.band(messageBytes[32], 0x02), 1)
			keyP["room_i_load_state1_2"] = bit.rshift(bit.band(messageBytes[32], 0x04), 2)
			keyP["room_i_load_state1_3"] = bit.rshift(bit.band(messageBytes[32], 0x08), 3)
			keyP["room_i_load_state1_4"] = bit.rshift(bit.band(messageBytes[32], 0x10), 4)
			keyP["room_i_load_state1_5"] = bit.rshift(bit.band(messageBytes[32], 0x20), 5)
			keyP["room_i_load_state1_6"] = bit.rshift(bit.band(messageBytes[32], 0x40), 6)
			keyP["room_i_load_state1_7"] = bit.rshift(bit.band(messageBytes[32], 0x80), 7)
			keyP["out_door_dev_state1_0"] = bit.band(messageBytes[35], 0x01)
			keyP["out_door_dev_state1_1"] = bit.rshift(bit.band(messageBytes[35], 0x02), 1)
			keyP["out_door_dev_state1_2"] = bit.rshift(bit.band(messageBytes[35], 0x04), 2)
			keyP["out_door_dev_state1_3"] = bit.rshift(bit.band(messageBytes[35], 0x08), 3)
			keyP["out_door_dev_state1_4"] = bit.rshift(bit.band(messageBytes[35], 0x10), 4)
			keyP["out_door_dev_state1_5"] = bit.rshift(bit.band(messageBytes[35], 0x20), 5)
			keyP["out_door_dev_state1_6"] = bit.rshift(bit.band(messageBytes[35], 0x40), 6)
			keyP["out_door_dev_state1_7"] = bit.rshift(bit.band(messageBytes[35], 0x80), 7)
			keyP["out_door_dev_state2_0"] = bit.band(messageBytes[36], 0x01)
			keyP["out_door_dev_state2_1"] = bit.rshift(bit.band(messageBytes[36], 0x02), 1)
			keyP["out_door_dev_state2_2"] = bit.rshift(bit.band(messageBytes[36], 0x04), 2)
			keyP["out_door_dev_state2_3"] = bit.rshift(bit.band(messageBytes[36], 0x08), 3)
			keyP["out_door_dev_state2_4"] = bit.rshift(bit.band(messageBytes[36], 0x10), 4)
			keyP["out_door_dev_state2_5"] = bit.rshift(bit.band(messageBytes[36], 0x20), 5)
			keyP["out_door_dev_state2_6"] = bit.rshift(bit.band(messageBytes[36], 0x40), 6)
			keyP["out_door_dev_state2_7"] = bit.rshift(bit.band(messageBytes[36], 0x80), 7)
			keyP["out_door_dev_state3_0"] = bit.band(messageBytes[37], 0x01)
			keyP["out_door_dev_state3_1"] = bit.rshift(bit.band(messageBytes[37], 0x02), 1)
			keyP["out_door_dev_state3_2"] = bit.rshift(bit.band(messageBytes[37], 0x04), 2)
			keyP["out_door_dev_state3_3"] = bit.rshift(bit.band(messageBytes[37], 0x08), 3)
			keyP["out_door_dev_state3_4"] = bit.rshift(bit.band(messageBytes[37], 0x10), 4)
			keyP["out_door_dev_state3_5"] = bit.rshift(bit.band(messageBytes[37], 0x20), 5)
			keyP["out_door_dev_state3_6"] = bit.rshift(bit.band(messageBytes[37], 0x40), 6)
			keyP["out_door_dev_state3_7"] = bit.rshift(bit.band(messageBytes[37], 0x80), 7)
			keyP["out_door_dev_state4_0"] = bit.band(messageBytes[38], 0x01)
			keyP["out_door_dev_state4_1"] = bit.rshift(bit.band(messageBytes[38], 0x02), 1)
			keyP["out_door_dev_state4_2"] = bit.rshift(bit.band(messageBytes[38], 0x04), 2)
			keyP["out_door_dev_state4_3"] = bit.rshift(bit.band(messageBytes[38], 0x08), 3)
			keyP["out_door_dev_state4_4"] = bit.rshift(bit.band(messageBytes[38], 0x10), 4)
			keyP["out_door_dev_state4_5"] = bit.rshift(bit.band(messageBytes[38], 0x20), 5)
			keyP["out_door_dev_state4_6"] = bit.rshift(bit.band(messageBytes[38], 0x40), 6)
			keyP["out_door_dev_state4_7"] = bit.rshift(bit.band(messageBytes[38], 0x80), 7)
			keyP["out_door_dev_state5_0"] = bit.band(messageBytes[39], 0x01)
			keyP["out_door_dev_state5_1"] = bit.rshift(bit.band(messageBytes[39], 0x02), 1)
			keyP["out_door_dev_state5_2"] = bit.rshift(bit.band(messageBytes[39], 0x04), 2)
			keyP["out_door_dev_state5_3"] = bit.rshift(bit.band(messageBytes[39], 0x08), 3)
			keyP["out_door_dev_state5_4"] = bit.rshift(bit.band(messageBytes[39], 0x10), 4)
			keyP["out_door_dev_state5_5"] = bit.rshift(bit.band(messageBytes[39], 0x20), 5)
			keyP["out_door_dev_state5_6"] = bit.rshift(bit.band(messageBytes[39], 0x40), 6)
			keyP["out_door_dev_state5_7"] = bit.rshift(bit.band(messageBytes[39], 0x80), 7)
			keyP["out_door_dev_state6_0"] = bit.band(messageBytes[40], 0x01)
			keyP["out_door_dev_state6_1"] = bit.rshift(bit.band(messageBytes[40], 0x02), 1)
			keyP["out_door_dev_state6_2"] = bit.rshift(bit.band(messageBytes[40], 0x04), 2)
			keyP["out_door_dev_state6_3"] = bit.rshift(bit.band(messageBytes[40], 0x08), 3)
			keyP["out_door_dev_state6_4"] = bit.rshift(bit.band(messageBytes[40], 0x10), 4)
			keyP["out_door_dev_state6_5"] = bit.rshift(bit.band(messageBytes[40], 0x20), 5)
			keyP["out_door_dev_state6_6"] = bit.rshift(bit.band(messageBytes[40], 0x40), 6)
			keyP["out_door_dev_state6_7"] = bit.rshift(bit.band(messageBytes[40], 0x80), 7)
			keyP["out_door_i_fan_speed"] = messageBytes[41] * 8
			keyP["out_door_ele_switch"] = messageBytes[42] * 8
			keyP["out_door_back_temp"] = messageBytes[43]
			keyP["out_door_voltage"] = messageBytes[44]
			keyP["ipm_temp"] = messageBytes[45]
			keyP["dry_heat_time_value"] = messageBytes[53] + messageBytes[54] * 256
			keyP["new_wind_fun_current_value"] = messageBytes[55] + messageBytes[56] * 256
			keyP["clean_fun_current_value"] = messageBytes[57] + messageBytes[58] * 256
			keyP["hum_fun_wind_current_value"] = messageBytes[59]
			keyP["sterilize_run_time"] = messageBytes[60] + messageBytes[61] * 256
			keyP["wetfilm_time"] = messageBytes[62] + messageBytes[63] * 256
			keyP["purfiy_film_time"] = messageBytes[64] + messageBytes[65] * 256
			keyP["smart_clean_current_run_time"] = messageBytes[66]
			keyP["right_wind_rotate_speed"] = messageBytes[68]
			keyP["left_wind_rotate_speed"] = messageBytes[69]
			keyP["left_wind_current_class"] = messageBytes[70]
			keyP["right_wind_current_class"] = messageBytes[71]
			keyP["down_wind_set_class"] = messageBytes[72]
			keyP["down_wind_current_class"] = messageBytes[73]
			keyP["set_hum_value"] = messageBytes[74]
			keyP["hum_fun_wind_class"] = keyP["down_wind_set_class"]
			keyP["clean_fun_wind_class"] = keyP["down_wind_set_class"]
			keyP["new_wind_fun_class"] = keyP["down_wind_set_class"]
			keyP["sterilize_wind_class"] = keyP["down_wind_set_class"]
			keyP["product_code"] = messageBytes[75] + messageBytes[76] * 256
			keyP["err_code_class"] = messageBytes[77]
			keyP["in_display_transport"] = bit.band(messageBytes[78], 0x01)
			keyP["compressor_pos_protect"] = bit.rshift(bit.band(messageBytes[78], 0x02), 1)
			keyP["in_display_transit"] = bit.rshift(bit.band(messageBytes[78], 0x04), 2)
		elseif messageBytes[1] == 0x02 then
			keyP["analysis_value"] =
				"timing_on_minute,timing_off_minute,local_body_sense,energy_save,restrong,refarce_wind,repower_save,cosy_sleep_switch,run_status,eco_func,dust_fun_flag,re_elec_heat,rediy_func,rechg_of_air,rechg_of_air,wisdom_eye,natural_wind,repeak_valley_mode,night_light,against_cool,child_kickk,alm_sleep,pmv_status,display_control_flag,control_self_cleaning_current_status,nonDirectWind,is_open8_degree_hot_current_status,smartfun_current_status,is_use_double_temp_ctrl,ladder_fun_sw,ladder_fun_sw,ladder_fun_sw,up_dn_dao_feng_tiao_stat,lt_rt_dao_feng_tiao_stat,top_dao_feng_tiao_stat,up_dn_dao_feng_tiao_stat_right_down,lt_rt_dao_feng_tiao_stat_right_left,hum_fun_wind_percentage,checked_temp_set,indoor_fan_runtime,outdoor_fan_speed,ele_switch_angle,defrosting_step,outdoor_dev_state7,outdoor_dev_state8,out_door485_fault,engine_cur_worked_time,engine_total_worked_time,limit_freq_type2,dev_max_voltage,dev_min_voltage,history_max_current,history_max_for_t4,history_min_for_t4,total_err_cnt,shi_wai_ya_suo_ji_ci_tong,shi_nei_feng_ji_ci_tong,d_spin_current,q_spin_current,engine_peak_current,pfc_peak_current,fan_peak_current,torque_adjust_angle,torque_adjust_value,ad_adjust_voltage1,ad_adjust_voltage2,d_spin_voltage,q_spin_voltage,pfc_switch_status,com_start_status,out_side_power_factor,out_side_power,up_dn_dao_feng_tiao_cool_upper_limit,up_dn_dao_feng_tiao_cool_lower_limit,up_dn_dao_feng_tiao_heat_upper_limit,up_dn_dao_feng_tiao_heat_lower_limit,up_dn_dao_feng_tiao_cur_angle,out_side_power_factor,lt_rt_dao_feng_tiao_upper_limit,lt_rt_dao_feng_tiao_lower_limit,lt_rt_dao_feng_tiao_cur_angle,out_door_dest_freq,int_door_target_wind_speed,top_dao_feng_tiao_upper_limit,top_dao_feng_tiao_lower_limit,top_dao_feng_tiao_cur_angle,down_dao_feng_tiao_cool_upper_limit"
			keyP["timing_on_minute"] = messageBytes[2] + messageBytes[3] * 256
			keyP["timing_off_minute"] = messageBytes[4] + messageBytes[5] * 256
			keyP["local_body_sense"] = bit.rshift(bit.band(messageBytes[6], 0x80), 7)
			keyP["energy_save"] = bit.rshift(bit.band(messageBytes[6], 0x40), 6)
			keyP["restrong"] = bit.rshift(bit.band(messageBytes[6], 0x20), 5)
			keyP["refarce_wind"] = bit.rshift(bit.band(messageBytes[6], 0x10), 4)
			keyP["repower_save"] = bit.rshift(bit.band(messageBytes[6], 0x08), 3)
			keyP["cosy_sleep_switch"] = bit.rshift(bit.band(messageBytes[6], 0x04), 2)
			keyP["run_status"] = bit.rshift(bit.band(messageBytes[6], 0x02), 1)
			keyP["eco_func"] = bit.band(messageBytes[6], 0x01)
			keyP["dust_fun_flag"] = bit.rshift(bit.band(messageBytes[7], 0x80), 7)
			keyP["re_elec_heat"] = bit.rshift(bit.band(messageBytes[7], 0x40), 6)
			keyP["rediy_func"] = bit.rshift(bit.band(messageBytes[7], 0x20), 5)
			keyP["rechg_of_air"] = bit.rshift(bit.band(messageBytes[7], 0x10), 4)
			keyP["wisdom_eye"] = bit.rshift(bit.band(messageBytes[7], 0x08), 3)
			keyP["natural_wind"] = bit.rshift(bit.band(messageBytes[7], 0x04), 2)
			keyP["repeak_valley_mode"] = bit.rshift(bit.band(messageBytes[7], 0x02), 1)
			keyP["night_light"] = bit.band(messageBytes[7], 0x01)
			keyP["against_cool"] = bit.rshift(bit.band(messageBytes[8], 0x80), 7)
			keyP["child_kickk"] = bit.rshift(bit.band(messageBytes[8], 0x40), 6)
			keyP["alm_sleep"] = bit.rshift(bit.band(messageBytes[8], 0x20), 5)
			keyP["pmv_status"] = bit.rshift(bit.band(messageBytes[8], 0x10), 4)
			keyP["display_control_flag"] = bit.rshift(bit.band(messageBytes[8], 0x08), 3)
			keyP["control_self_cleaning_current_status"] = bit.rshift(bit.band(messageBytes[8], 0x04), 2)
			keyP["nonDirectWind"] = bit.rshift(bit.band(messageBytes[8], 0x02), 1)
			keyP["is_open8_degree_hot_current_status"] = bit.band(messageBytes[8], 0x01)
			keyP["smartfun_current_status"] = bit.rshift(bit.band(messageBytes[9], 0xe0), 5)
			keyP["is_use_double_temp_ctrl"] = bit.rshift(bit.band(messageBytes[9], 0x10), 4)
			keyP["ladder_fun_sw"] = bit.rshift(bit.band(messageBytes[9], 0x20), 5)
			keyP["up_dn_dao_feng_tiao_stat"] = bit.rshift(bit.band(messageBytes[9], 0x08), 3)
			keyP["lt_rt_dao_feng_tiao_stat"] = bit.rshift(bit.band(messageBytes[9], 0x04), 2)
			keyP["top_dao_feng_tiao_stat"] = bit.rshift(bit.band(messageBytes[9], 0x02), 1)
			keyP["up_dn_dao_feng_tiao_stat_right_down"] = bit.rshift(bit.band(messageBytes[10], 0x02), 1)
			keyP["lt_rt_dao_feng_tiao_stat_right_left"] = bit.band(messageBytes[10], 0x01)
			keyP["hum_fun_wind_percentage"] = messageBytes[11]
			keyP["checked_temp_set"] = (messageBytes[12] - 30) * 0.5
			keyP["indoor_fan_runtime"] = messageBytes[13] + messageBytes[14] * 256
			keyP["outdoor_fan_speed"] = messageBytes[15] * 8
			keyP["ele_switch_angle"] = messageBytes[16] * 8
			keyP["defrosting_step"] = messageBytes[17]
			keyP["outdoor_dev_state7"] = messageBytes[18]
			keyP["outdoor_dev_state8"] = bit.band(messageBytes[19], 0x02)
			keyP["out_door485_fault"] = bit.band(messageBytes[19], 0x01)
			keyP["engine_cur_worked_time"] = messageBytes[20]
			keyP["engine_total_worked_time"] = messageBytes[21] + messageBytes[22] * 256
			keyP["limit_freq_type2"] = messageBytes[23]
			keyP["dev_max_voltage"] = messageBytes[24]
			keyP["dev_min_voltage"] = messageBytes[25]
			keyP["history_max_current"] = messageBytes[26]
			keyP["history_max_for_t4"] = messageBytes[27]
			keyP["history_min_for_t4"] = messageBytes[28]
			keyP["total_err_cnt"] = messageBytes[29]
			keyP["shi_wai_ya_suo_ji_ci_tong"] = messageBytes[30] * 8
			keyP["shi_nei_feng_ji_ci_tong"] = messageBytes[31] * 8
			keyP["d_spin_current"] = messageBytes[32]
			keyP["q_spin_current"] = messageBytes[33]
			keyP["engine_peak_current"] = messageBytes[34]
			keyP["pfc_peak_current"] = messageBytes[35]
			keyP["fan_peak_current"] = messageBytes[36]
			keyP["torque_adjust_angle"] = messageBytes[37] + messageBytes[38] * 256
			keyP["torque_adjust_value"] = messageBytes[39]
			keyP["ad_adjust_voltage1"] = messageBytes[40]
			keyP["ad_adjust_voltage2"] = messageBytes[41]
			keyP["d_spin_voltage"] = messageBytes[42]
			keyP["q_spin_voltage"] = messageBytes[43]
			keyP["pfc_switch_status"] = messageBytes[44]
			keyP["com_start_status"] = messageBytes[45]
			keyP["out_side_power_factor"] = messageBytes[46]
			keyP["out_side_power"] = messageBytes[47] + messageBytes[48] * 256
			keyP["up_dn_dao_feng_tiao_cool_upper_limit"] = messageBytes[49]
			keyP["up_dn_dao_feng_tiao_cool_lower_limit"] = messageBytes[50]
			keyP["up_dn_dao_feng_tiao_heat_upper_limit"] = messageBytes[51]
			keyP["up_dn_dao_feng_tiao_heat_lower_limit"] = messageBytes[52]
			keyP["up_dn_dao_feng_tiao_cur_angle"] = messageBytes[46]
			keyP["out_side_power_factor"] = messageBytes[53]
			keyP["lt_rt_dao_feng_tiao_upper_limit"] = messageBytes[54]
			keyP["lt_rt_dao_feng_tiao_lower_limit"] = messageBytes[55]
			keyP["lt_rt_dao_feng_tiao_cur_angle"] = messageBytes[56]
			keyP["out_door_dest_freq"] = messageBytes[57]
			keyP["int_door_target_wind_speed"] = messageBytes[58]
			keyP["top_dao_feng_tiao_upper_limit"] = messageBytes[59]
			keyP["top_dao_feng_tiao_lower_limit"] = messageBytes[60]
			keyP["top_dao_feng_tiao_cur_angle"] = messageBytes[61]
			keyP["down_dao_feng_tiao_cool_upper_limit"] = messageBytes[62]
			if #messageBytes > 61 then
				keyP["analysis_value"] = keyP["analysis_value"]
					.. ",down_dao_feng_tiao_cool_lower_limit,down_dao_feng_tiao_cool_lower_limit,down_dn_dao_feng_tiao_heat_upper_limit,down_dn_dao_feng_tiao_heat_lower_limit,down_dn_dao_feng_tiao_cur_angle,second_hum_value,strong_current,sterilize_current_sw,new_wind_fun_current_sw,hum_fun_current_sw,clean_fun_current_sw,control_self_cleaning_current_stage,smart_clean_current_status,right_control_wind_current_free,left_control_wind_current_free,up_dn_dao_feng_tiao_current_stat,lt_rt_dao_feng_tiao_current_stat,pannel_protect,hydropenia,lt_rt_dao_feng_tiao_current_stat_left,up_dn_dao_feng_tiao_current_stat_left"
				keyP["down_dao_feng_tiao_cool_lower_limit"] = messageBytes[63]
				keyP["down_dn_dao_feng_tiao_heat_upper_limit"] = messageBytes[64]
				keyP["down_dn_dao_feng_tiao_heat_lower_limit"] = messageBytes[65]
				keyP["down_dn_dao_feng_tiao_cur_angle"] = messageBytes[66]
				keyP["second_hum_value"] = messageBytes[67]
				keyP["strong_current"] = bit.rshift(bit.band(messageBytes[68], 0x80), 7)
				keyP["sterilize_current_sw"] = bit.rshift(bit.band(messageBytes[68], 0x40), 6)
				keyP["new_wind_fun_current_sw"] = bit.rshift(bit.band(messageBytes[68], 0x20), 5)
				keyP["hum_fun_current_sw"] = bit.rshift(bit.band(messageBytes[68], 0x10), 4)
				keyP["clean_fun_current_sw"] = bit.rshift(bit.band(messageBytes[68], 0x08), 3)
				keyP["control_self_cleaning_current_stage"] = bit.band(messageBytes[68], 0x07)
				keyP["smart_clean_current_status"] = bit.band(messageBytes[68], 0x07)
				keyP["right_control_wind_current_free"] = bit.rshift(bit.band(messageBytes[69], 0x80), 7)
				keyP["left_control_wind_current_free"] = bit.rshift(bit.band(messageBytes[69], 0x40), 6)
				keyP["up_dn_dao_feng_tiao_current_stat"] = bit.rshift(bit.band(messageBytes[69], 0x20), 5)
				keyP["lt_rt_dao_feng_tiao_current_stat"] = bit.rshift(bit.band(messageBytes[69], 0x10), 4)
				keyP["pannel_protect"] = bit.rshift(bit.band(messageBytes[69], 0x08), 3)
				keyP["hydropenia"] = bit.rshift(bit.band(messageBytes[69], 0x04), 2)
				keyP["lt_rt_dao_feng_tiao_current_stat_left"] = bit.rshift(bit.band(messageBytes[69], 0x02), 1)
				keyP["up_dn_dao_feng_tiao_current_stat_left"] = bit.band(messageBytes[69], 0x01)
			end
		end
	end
	if
		(dataType == 0x02 and messageBytes[0] == 0xC0)
		or (dataType == 0x03 and messageBytes[0] == 0xC0)
		or (dataType == 0x05 and messageBytes[0] == 0xA0)
	then
		if #binData < 21 then
			return nil
		end
		keyP["analysis_value"] =
			"power,mode,temperature,wind_speed,power_on_timer,power_off_timer,power_off_time_value,power_on_time_value,ptc,eco,dry,wind_swing_lr,wind_swing_lr_under,wind_swing_ud,kick_quilt,prevent_cold,small_temperature,purifier"
		keyP["powerValue"] = bit.band(messageBytes[1], 0x01)
		keyP["modeValue"] = bit.band(messageBytes[2], 0xE0)
		if dataType == 0x05 then
			if
				deviceSN8 == "11447"
				or deviceSN8 == "11451"
				or deviceSN8 == "11453"
				or deviceSN8 == "11455"
				or deviceSN8 == "11457"
				or deviceSN8 == "11459"
				or deviceSN8 == "11525"
				or deviceSN8 == "11527"
				or deviceSN8 == "11533"
				or deviceSN8 == "11535"
			then
				keyP["temperature"] = bit.rshift(bit.band(messageBytes[1], 0x7C), 2) + 0x0C
				keyP["smallTemperature"] = bit.rshift(bit.band(messageBytes[1], 0x02), 1)
			else
				keyP["temperature"] = bit.rshift(bit.band(messageBytes[1], 0x3E), 1) + 0x0C
				keyP["smallTemperature"] = bit.rshift(bit.band(messageBytes[1], 0x40), 6)
			end
		else
			keyP["temperature"] = bit.band(messageBytes[2], 0x0F) + 0x10
			keyP["smallTemperature"] = bit.rshift(bit.band(messageBytes[2], 0x10), 4)
		end
		keyP["fanspeedValue"] = bit.band(messageBytes[3], 0x7F)
		if bit.band(messageBytes[4], keyB["BYTE_START_TIMER_SWITCH_ON"]) == keyB["BYTE_START_TIMER_SWITCH_ON"] then
			keyP["openTimerSwitch"] = keyB["BYTE_START_TIMER_SWITCH_ON"]
		else
			keyP["openTimerSwitch"] = keyB["BYTE_START_TIMER_SWITCH_OFF"]
		end
		if bit.band(messageBytes[5], keyB["BYTE_CLOSE_TIMER_SWITCH_ON"]) == keyB["BYTE_CLOSE_TIMER_SWITCH_ON"] then
			keyP["closeTimerSwitch"] = keyB["BYTE_CLOSE_TIMER_SWITCH_ON"]
		else
			keyP["closeTimerSwitch"] = keyB["BYTE_CLOSE_TIMER_SWITCH_OFF"]
		end
		keyP["closeHour"] = bit.rshift(bit.band(messageBytes[5], 0x7F), 2)
		keyP["closeStepMintues"] = bit.band(messageBytes[5], 0x03)
		keyP["closeMin"] = 15 - bit.band(messageBytes[6], 0x0f)
		keyP["closeTime"] = keyP["closeHour"] * 60 + keyP["closeStepMintues"] * 15 + keyP["closeMin"]
		keyP["openHour"] = bit.rshift(bit.band(messageBytes[4], 0x7F), 2)
		keyP["openStepMintues"] = bit.band(messageBytes[4], 0x03)
		keyP["openMin"] = 15 - bit.rshift(bit.band(messageBytes[6], 0xf0), 4)
		keyP["openTime"] = keyP["openHour"] * 60 + keyP["openStepMintues"] * 15 + keyP["openMin"]
		keyP["strongWindValue"] = bit.band(messageBytes[8], 0x20)
		keyP["comfortableSleepValue"] = bit.band(messageBytes[8], 0x03)
		keyP["PTCValue"] = bit.band(messageBytes[9], 0x18)
		keyP["purifierValue"] = bit.band(messageBytes[9], 0x20)
		keyP["ecoValue"] = bit.lshift(bit.band(messageBytes[9], 0x10), 3)
		keyP["dryValue"] = bit.band(messageBytes[9], 0x04)
		keyP["swingLRValue"] = bit.band(messageBytes[7], 0x03)
		keyP["swingLRUnderSwitch"] = bit.band(messageBytes[19], 0x80)
		keyP["swingLRValueUnder"] = bit.band(messageBytes[20], 0x80)
		keyP["swingUDValue"] = bit.band(messageBytes[7], 0x0C)
		if dataType == 0x02 or dataType == 0x03 then
			if (messageBytes[11] ~= 0) and (messageBytes[11] ~= 0xFF) then
				keyP["indoorTemperatureValue"] = (messageBytes[11] - 50) / 2
				keyP["smallIndoorTemperatureValue"] = bit.band(messageBytes[15], 0xF)
				keyP["analysis_value"] = keyP["analysis_value"] .. ",indoor_temperature"
			end
			if (messageBytes[12] ~= 0) and (messageBytes[12] ~= 0xFF) then
				keyP["outdoorTemperatureValue"] = (messageBytes[12] - 50) / 2
				keyP["smallOutdoorTemperatureValue"] = bit.rshift(messageBytes[15], 4)
				keyP["analysis_value"] = keyP["analysis_value"] .. ",outdoor_temperature"
			end
		end
		keyP["errorCode"] = messageBytes[16]
		keyP["kickQuilt"] = bit.rshift(bit.band(messageBytes[10], 0x04), 2)
		keyP["preventCold"] = bit.rshift(bit.band(messageBytes[10], 0x08), 3)
		if #binData >= 22 then
			keyP["comfortPowerSave"] = bit.band(messageBytes[22], 0x01)
			keyP["analysis_value"] = keyP["analysis_value"] .. ",comfort_power_save"
		end
	end
	if (dataType == 0x04 and messageBytes[0] == 0xA1) then
		keyP["currentWorkTime"] = bit.bor(
			(bit.band(bit.lshift(messageBytes[9], 8), 0xFF00)),
			(bit.band(messageBytes[10], 0x00FF))
		) * 60 * 24 + messageBytes[11] * 60 + messageBytes[12]
		keyP["analysis_value"] = "current_work_time"
		if messageBytes[13] ~= 0x00 and messageBytes[13] ~= 0xff then
			keyP["indoorTemperatureValue"] = (messageBytes[13] - 50) / 2
			keyP["smallIndoorTemperatureValue"] = bit.band(messageBytes[18], 0xF)
			keyP["analysis_value"] = keyP["analysis_value"] .. ",indoor_temperature"
		end
		if messageBytes[14] ~= 0x00 and messageBytes[14] ~= 0xff then
			keyP["outdoorTemperatureValue"] = (messageBytes[14] - 50) / 2
			keyP["smallOutdoorTemperatureValue"] = bit.rshift(messageBytes[18], 4)
			keyP["analysis_value"] = keyP["analysis_value"] .. ",outdoor_temperature"
		end
	end
	if dataType == 0x05 and messageBytes[0] == 0xB5 then
		if #binData < 7 then
			keyP["propertyNumber"] = 1
			return nil
		end
		keyP["propertyNumber"] = messageBytes[1]
		keyP["analysis_value"] = ""
		local cursor = 2
		for i = 1, keyP["propertyNumber"] do
			if
				messageBytes[cursor + 0] == 0x31
				and messageBytes[cursor + 1] == 0x02
				and messageBytes[cursor + 11] == 0x32
				and messageBytes[cursor + 12] == 0x02
				and messageBytes[cursor + 24] == 0x33
				and messageBytes[cursor + 25] == 0x02
			then
				keyP["down_wind_speed"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "down_wind_speed,"
			end
			if messageBytes[cursor + 0] == 0x46 and messageBytes[cursor + 1] == 0x00 then
				keyP["prevent_super_cool"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "prevent_super_cool,"
			end
			if messageBytes[cursor + 0] == 0x42 and messageBytes[cursor + 1] == 0x00 then
				keyP["prevent_straight_wind"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "prevent_straight_wind,"
			end
			if messageBytes[cursor + 0] == 0x26 and messageBytes[cursor + 1] == 0x02 then
				keyP["airoptimization"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "airoptimization,"
			end
			if messageBytes[cursor + 0] == 0x27 and messageBytes[cursor + 1] == 0x02 then
				keyP["self_clean"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "self_clean,"
			end
			if messageBytes[cursor + 0] == 0x3A and messageBytes[cursor + 1] == 0x00 then
				keyP["child_prevent_cold_wind"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "child_prevent_cold_wind,"
			end
			if messageBytes[cursor + 0] == 0x17 and messageBytes[cursor + 1] == 0x00 then
				keyP["screen_display"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "screen_display,"
			end
			if messageBytes[cursor + 0] == 0x18 and messageBytes[cursor + 1] == 0x00 then
				keyP["no_wind_sense"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "no_wind_sense,"
			end
			if messageBytes[cursor + 0] == 0x1B and messageBytes[cursor + 1] == 0x02 then
				keyP["little_angel"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "little_angel,"
			end
			if messageBytes[cursor + 0] == 0x21 and messageBytes[cursor + 1] == 0x00 then
				keyP["cool_hot_sense"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "cool_hot_sense,"
			end
			if messageBytes[cursor + 0] == 0x29 and messageBytes[cursor + 1] == 0x00 then
				keyP["security"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "security,"
			end
			if messageBytes[cursor + 0] == 0x43 and messageBytes[cursor + 1] == 0x00 then
				if messageBytes[cursor + 3] == 0x01 then
					keyP["gentle_wind_sense"] = 0x01
					keyP["prevent_straight_wind"] = 0x01
					keyP["no_wind_sense"] = 0x00
					keyP["analysis_value"] = keyP["analysis_value"]
						.. "gentle_wind_sense,prevent_straight_wind,no_wind_sense,"
				end
				if messageBytes[cursor + 3] == 0x02 then
					keyP["prevent_straight_wind"] = 0x02
					keyP["analysis_value"] = keyP["analysis_value"] .. "prevent_straight_wind,"
				end
				if messageBytes[cursor + 3] == 0x03 then
					keyP["gentle_wind_sense"] = 0x03
					keyP["analysis_value"] = keyP["analysis_value"] .. "gentle_wind_sense,"
				end
				if messageBytes[cursor + 3] == 0x04 then
					keyP["no_wind_sense"] = 0x01
					keyP["analysis_value"] = keyP["analysis_value"] .. "no_wind_sense,"
				end
			end
			if messageBytes[cursor + 0] == 0x3C and messageBytes[cursor + 1] == 0x02 then
				if messageBytes[cursor + 2] == 0x09 then
					keyP["full_time"] = messageBytes[cursor + 11]
				end
				keyP["powerValue"] = messageBytes[cursor + 3] - 1
				keyP["modeValue"] = messageBytes[cursor + 4]
				if messageBytes[cursor + 4] == 1 then
					keyP["modeValue"] = keyB["BYTE_MODE_AUTO"]
				elseif messageBytes[cursor + 4] == 2 then
					keyP["modeValue"] = keyB["BYTE_MODE_COOL"]
				elseif messageBytes[cursor + 4] == 3 then
					keyP["modeValue"] = keyB["BYTE_MODE_DRY"]
				elseif messageBytes[cursor + 4] == 4 then
					keyP["modeValue"] = keyB["BYTE_MODE_HEAT"]
				elseif messageBytes[cursor + 4] == 5 then
					keyP["modeValue"] = keyB["BYTE_MODE_FAN"]
				end
				keyP["wind_speed_left"] = messageBytes[cursor + 5]
				keyP["fanspeedValue"] = messageBytes[cursor + 5]
				keyP["wind_speed_right"] = messageBytes[cursor + 6]
				keyP["temperature"], keyP["smallTemperature"] = math.modf(messageBytes[cursor + 7] / 2)
				if keyP["smallTemperature"] == 0.5 then
					keyP["smallTemperature"] = 0x01
				else
					keyP["smallTemperature"] = 0x00
				end
				keyP["sceneId"] = messageBytes[cursor + 8]
				keyP["targetLWindSpeed"] = messageBytes[cursor + 9]
				keyP["targetRWindSpeed"] = messageBytes[cursor + 10]
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "power,mode,wind_speed_left,wind_speed_right,temperature,small_temperature,sceneId,targetLWindSpeed,targetRWindSpeed,"
			end
			if messageBytes[cursor + 0] == 0x29 and messageBytes[cursor + 1] == 0x02 then
				keyP["wind_swing_left"] = messageBytes[cursor + 3]
				keyP["wind_swing_left_degree"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wind_swing_left,wind_swing_left_degree,"
			end
			if messageBytes[cursor + 0] == 0x2A and messageBytes[cursor + 1] == 0x02 then
				keyP["wind_swing_right"] = messageBytes[cursor + 3]
				keyP["wind_swing_right_degree"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wind_swing_right,wind_swing_right_degree,"
			end
			if messageBytes[cursor + 0] == 0x33 and messageBytes[cursor + 1] == 0x02 then
				keyP["fresh_air"] = messageBytes[cursor + 3]
				keyP["fresh_air_fan_speed"] = messageBytes[cursor + 4]
				keyP["fresh_air_mode"] = messageBytes[cursor + 5]
				keyP["fresh_air_mode_2"] = messageBytes[cursor + 6]
				keyP["fresh_air_on_co2"] = bit.bor(bit.lshift(messageBytes[cursor + 8], 8), messageBytes[cursor + 7])
				keyP["fresh_air_off_co2"] = bit.bor(bit.lshift(messageBytes[cursor + 10], 8), messageBytes[cursor + 9])
				keyP["fresh_air_current_co2"] =
					bit.bor(bit.lshift(messageBytes[cursor + 12], 8), messageBytes[cursor + 11])
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "fresh_air,fresh_air_fan_speed,fresh_air_mode,fresh_air_mode_2,fresh_air_on_co2,fresh_air_off_co2,fresh_air_current_co2,"
			end
			if messageBytes[cursor + 0] == 0x31 and messageBytes[cursor + 1] == 0x02 then
				keyP["remove_odor"] = messageBytes[cursor + 3]
				keyP["remove_odor_fan_speed"] = messageBytes[cursor + 4]
				keyP["remove_odor_mode"] = messageBytes[cursor + 5]
				keyP["remove_odor_time"] = bit.bor(bit.lshift(messageBytes[cursor + 7], 8), messageBytes[cursor + 6])
				keyP["remove_odor_operating_time"] =
					bit.bor(bit.lshift(messageBytes[cursor + 9], 8), messageBytes[cursor + 8])
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "remove_odor,remove_odor_fan_speed,remove_odor_mode,remove_odor_time,remove_odor_operating_time,"
			end
			if messageBytes[cursor + 0] == 0x32 and messageBytes[cursor + 1] == 0x02 then
				keyP["inner_purifier"] = messageBytes[cursor + 3]
				keyP["inner_purifier_fan_speed"] = messageBytes[cursor + 4]
				keyP["inner_purifier_mode"] = messageBytes[cursor + 5]
				keyP["inner_purifier_on_pm"] =
					bit.bor(bit.lshift(messageBytes[cursor + 7], 8), messageBytes[cursor + 6])
				keyP["inner_purifier_off_pm"] =
					bit.bor(bit.lshift(messageBytes[cursor + 9], 8), messageBytes[cursor + 8])
				keyP["inner_purifier_current_pm"] =
					bit.bor(bit.lshift(messageBytes[cursor + 11], 8), messageBytes[cursor + 10])
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "inner_purifier,inner_purifier_fan_speed,inner_purifier_mode,inner_purifier_on_pm,inner_purifier_off_pm,inner_purifier_current_pm,"
			end
			if messageBytes[cursor + 0] == 0x35 and messageBytes[cursor + 1] == 0x02 then
				keyP["humidification"] = messageBytes[cursor + 3]
				keyP["humidification_fan_speed"] = messageBytes[cursor + 4]
				keyP["humidification_mode"] = messageBytes[cursor + 5]
				keyP["humidification_auto_on"] = messageBytes[cursor + 6]
				keyP["humidification_auto_off"] = messageBytes[cursor + 7]
				keyP["humidification_manual"] = messageBytes[cursor + 8]
				keyP["humidification_current"] = messageBytes[cursor + 9]
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "humidification,humidification_fan_speed,humidification_mode,humidification_auto_on,humidification_auto_off,humidification_manual,humidification_current,"
			end
			if messageBytes[cursor + 0] == 0x2D and messageBytes[cursor + 1] == 0x02 then
				keyP["no_wind_sense_left"] = messageBytes[cursor + 3]
				keyP["left_profile"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "no_wind_sense_left,left_profile,"
			end
			if messageBytes[cursor + 0] == 0x2E and messageBytes[cursor + 1] == 0x02 then
				keyP["no_wind_sense_right"] = messageBytes[cursor + 3]
				keyP["right_profile"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "no_wind_sense_right,right_profile,"
			end
			if messageBytes[cursor + 0] == 0x30 and messageBytes[cursor + 1] == 0x02 then
				keyP["light"] = messageBytes[cursor + 3]
				keyP["light_bright"] = messageBytes[cursor + 4]
				keyP["light_air_level"] = messageBytes[cursor + 5]
				keyP["analysis_value"] = keyP["analysis_value"] .. "light,light_bright,light_air_level,"
			end
			if messageBytes[cursor + 0] == 0x3A and messageBytes[cursor + 1] == 0x02 then
				keyP["wind_swing_ud_right"] = messageBytes[cursor + 3]
				keyP["wind_swing_ud_right_degree"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wind_swing_ud_right,wind_swing_ud_right_degree,"
			end
			if messageBytes[cursor + 0] == 0x3B and messageBytes[cursor + 1] == 0x02 then
				keyP["wind_swing_ud_left"] = messageBytes[cursor + 3]
				keyP["wind_swing_ud_left_degree"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wind_swing_ud_left,wind_swing_ud_left_degree,"
			end
			if messageBytes[cursor + 0] == 0x10 and messageBytes[cursor + 1] == 0x00 then
				keyP["dryValue"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "dry,"
			end
			if messageBytes[cursor + 0] == 0x0F and messageBytes[cursor + 1] == 0x00 then
				keyP["PTCValue"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "ptc,"
			end
			if messageBytes[cursor + 0] == 0x44 and messageBytes[cursor + 1] == 0x02 then
				keyP["strong_wind"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "strong_wind,"
			end
			if messageBytes[cursor + 0] == 0x2B and messageBytes[cursor + 1] == 0x02 then
				keyP["up_control_wind"] = messageBytes[cursor + 3]
				keyP["up_control_wind_degree"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "up_control_wind,up_control_wind_degree,"
			end
			if messageBytes[cursor + 0] == 0x2C and messageBytes[cursor + 1] == 0x02 then
				keyP["down_control_wind"] = messageBytes[cursor + 3]
				keyP["down_control_wind_degree"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "down_control_wind,down_control_wind_degree,"
			end
			if messageBytes[cursor + 0] == 0x46 and messageBytes[cursor + 1] == 0x02 then
				keyP["wait_clean"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wait_clean,"
			end
			if messageBytes[cursor + 0] == 0x36 and messageBytes[cursor + 1] == 0x02 then
				keyP["left_wind"] = messageBytes[cursor + 3]
				keyP["right_wind"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "left_wind,right_wind,"
			end
			if messageBytes[cursor + 0] == 0x28 and messageBytes[cursor + 1] == 0x02 then
				keyP["purify_film"] = messageBytes[cursor + 3]
				keyP["purify_film_time"] =
					bit.bor(messageBytes[cursor + 4], bit.bor(bit.lshift(messageBytes[cursor + 5], 8)))
				keyP["purify_film_total_time"] =
					bit.bor(messageBytes[cursor + 6], bit.bor(bit.lshift(messageBytes[cursor + 7], 8)))
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "purify_film,purify_film_time,purify_film_total_time,"
			end
			if messageBytes[cursor + 0] == 0x34 and messageBytes[cursor + 1] == 0x02 then
				keyP["wetfilm_state"] = messageBytes[cursor + 3]
				keyP["wetfilm_state_time"] =
					bit.bor(messageBytes[cursor + 4], bit.bor(bit.lshift(messageBytes[cursor + 5], 8)))
				keyP["wetfilm_state_total_time"] =
					bit.bor(messageBytes[cursor + 6], bit.bor(bit.lshift(messageBytes[cursor + 7], 8)))
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "wetfilm_state,wetfilm_state_time,wetfilm_state_total_time,"
			end
			if messageBytes[cursor + 0] == 0x38 and messageBytes[cursor + 1] == 0x02 then
				keyP["acstrainer_state"] = messageBytes[cursor + 3]
				keyP["acstrainer_state_time"] =
					bit.bor(messageBytes[cursor + 4], bit.bor(bit.lshift(messageBytes[cursor + 5], 8)))
				keyP["acstrainer_state_total_time"] =
					bit.bor(messageBytes[cursor + 6], bit.bor(bit.lshift(messageBytes[cursor + 7], 8)))
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "acstrainer_state,acstrainer_state_time,acstrainer_state_total_time,"
			end
			if messageBytes[cursor + 0] == 0x37 and messageBytes[cursor + 1] == 0x02 then
				keyP["get_weather"] = messageBytes[cursor + 3]
				keyP["outdoor_pm25"] =
					bit.bor(messageBytes[cursor + 4], bit.bor(bit.lshift(messageBytes[cursor + 5], 8)))
				keyP["analysis_value"] = keyP["analysis_value"] .. "get_weather,outdoor_pm25,"
			end
			if messageBytes[cursor + 0] == 0x39 and messageBytes[cursor + 1] == 0x02 then
				keyP["near_switch"] = messageBytes[cursor + 3]
				keyP["near_no_yes"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "near_switch,near_no_yes,"
			end
			if messageBytes[cursor + 0] == 0x3E and messageBytes[cursor + 1] == 0x02 then
				keyP["water_supply"] = messageBytes[cursor + 3]
				keyP["water_level"] = messageBytes[cursor + 4]
				keyP["water_tank"] = messageBytes[cursor + 5]
				keyP["analysis_value"] = keyP["analysis_value"] .. "water_supply,water_level,water_tank,"
			end
			if messageBytes[cursor + 0] == 0x3F and messageBytes[cursor + 1] == 0x02 then
				keyP["air_condition_temp"] = messageBytes[cursor + 4]
				keyP["air_condition_humidity"] = messageBytes[cursor + 5]
				keyP["air_condition_clean"] = messageBytes[cursor + 6]
				keyP["air_condition_fresh"] = messageBytes[cursor + 7]
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "air_condition_temp,air_condition_humidity,air_condition_clean,air_condition_fresh,"
			end
			if messageBytes[cursor + 0] == 0x04 and messageBytes[cursor + 1] == 0x00 then
				keyP["indoor_temp"] = messageBytes[cursor + 3]
				keyP["indoor_temp_decimal"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "indoor_temp,indoor_temp_decimal,"
			end
			if messageBytes[cursor + 0] == 0x05 and messageBytes[cursor + 1] == 0x00 then
				keyP["outdoor_temp"] = messageBytes[cursor + 3]
				keyP["outdoor_temp_decimal"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "outdoor_temp,outdoor_temp_decimal,"
			end
			if messageBytes[cursor + 0] == 0x1E and messageBytes[cursor + 1] == 0x00 then
				keyP["eco_switch"] = messageBytes[cursor + 3]
				keyP["eco_second"] = messageBytes[cursor + 4]
				keyP["eco_min"] = messageBytes[cursor + 5]
				keyP["eco_hour"] = messageBytes[cursor + 6]
				keyP["analysis_value"] = keyP["analysis_value"] .. "eco_switch,eco_second,eco_min,eco_hour,"
			end
			if messageBytes[cursor + 0] == 0x22 and messageBytes[cursor + 1] == 0x00 then
				keyP["keep_warm_switch"] = messageBytes[cursor + 3]
				keyP["keep_warm_temp"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "keep_warm_switch,keep_warm_temp,"
			end
			if messageBytes[cursor + 0] == 0x01 and messageBytes[cursor + 1] == 0x00 then
				keyP["close_screen"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "close_screen,"
			end
			if messageBytes[cursor + 0] == 0x45 and messageBytes[cursor + 1] == 0x00 then
				keyP["exclusive_mode"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "exclusive_mode,"
			end
			if messageBytes[cursor + 0] == 0x44 and messageBytes[cursor + 1] == 0x00 then
				keyP["family_number"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "family_number,"
			end
			if messageBytes[cursor + 0] == 0x32 and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_blow_close"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wind_blow_close,"
			end
			if messageBytes[cursor + 0] == 0x33 and messageBytes[cursor + 1] == 0x00 then
				keyP["wisdom_wind"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wisdom_wind,"
			end
			if messageBytes[cursor + 0] == 0x53 and messageBytes[cursor + 1] == 0x00 then
				keyP["wisdom_wind_new"] = messageBytes[cursor + 3]
				keyP["wisdom_left_distance"] = messageBytes[cursor + 4]
				keyP["wisdom_right_distance"] = messageBytes[cursor + 5]
				keyP["wisdom_left_set_wind"] = messageBytes[cursor + 6]
				keyP["wisdom_right_set_wind"] = messageBytes[cursor + 7]
				keyP["wisdom_left_down_angle"] =
					bit.bor(messageBytes[cursor + 8], bit.bor(bit.lshift(messageBytes[cursor + 9], 8)))
				keyP["wisdom_right_down_angle"] =
					bit.bor(messageBytes[cursor + 10], bit.bor(bit.lshift(messageBytes[cursor + 11], 8)))
				keyP["wisdom_left_up_angle"] =
					bit.bor(messageBytes[cursor + 12], bit.bor(bit.lshift(messageBytes[cursor + 13], 8)))
				keyP["wisdom_right_up_angle"] =
					bit.bor(messageBytes[cursor + 14], bit.bor(bit.lshift(messageBytes[cursor + 15], 8)))
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "wisdom_wind_new,wisdom_left_distance,wisdom_right_distance,wisdom_left_set_wind,wisdom_right_set_wind,wisdom_left_down_angle,wisdom_right_down_angle,wisdom_left_up_angle,wisdom_right_up_angle,"
			end
			if messageBytes[cursor + 0] == 0x54 and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_blow"] = messageBytes[cursor + 3]
				keyP["wind_blow_left_distance"] = messageBytes[cursor + 4]
				keyP["wind_blow_right_distance"] = messageBytes[cursor + 5]
				keyP["wind_blow_left_down_angle"] =
					bit.bor(messageBytes[cursor + 6], bit.bor(bit.lshift(messageBytes[cursor + 7], 8)))
				keyP["wind_blow_right_down_angle"] =
					bit.bor(messageBytes[cursor + 8], bit.bor(bit.lshift(messageBytes[cursor + 9], 8)))
				keyP["wind_blow_left_up_angle"] =
					bit.bor(messageBytes[cursor + 10], bit.bor(bit.lshift(messageBytes[cursor + 11], 8)))
				keyP["wind_blow_right_up_angle"] =
					bit.bor(messageBytes[cursor + 12], bit.bor(bit.lshift(messageBytes[cursor + 13], 8)))
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "wind_blow,wind_blow_left_distance,wind_blow_right_distance,wind_blow_left_down_angle,wind_blow_right_down_angle,wind_blow_left_up_angle,wind_blow_right_up_angle,"
			end
			if messageBytes[cursor + 0] == 0x55 and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_close"] = messageBytes[cursor + 3]
				keyP["wind_close_left_distance"] = messageBytes[cursor + 4]
				keyP["wind_close_right_distance"] = messageBytes[cursor + 5]
				keyP["wind_close_left_down_angle"] =
					bit.bor(messageBytes[cursor + 6], bit.bor(bit.lshift(messageBytes[cursor + 7], 8)))
				keyP["wind_close_right_down_angle"] =
					bit.bor(messageBytes[cursor + 8], bit.bor(bit.lshift(messageBytes[cursor + 9], 8)))
				keyP["wind_close_left_up_angle"] =
					bit.bor(messageBytes[cursor + 10], bit.bor(bit.lshift(messageBytes[cursor + 11], 8)))
				keyP["wind_close_right_up_angle"] =
					bit.bor(messageBytes[cursor + 12], bit.bor(bit.lshift(messageBytes[cursor + 13], 8)))
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "wind_close,wind_close_left_distance,wind_close_right_distance,wind_close_left_down_angle,wind_close_right_down_angle,wind_close_left_up_angle,wind_close_right_up_angle,"
			end
			if messageBytes[cursor + 0] == 0x56 and messageBytes[cursor + 1] == 0x00 then
				keyP["camera_direction_state"] = messageBytes[cursor + 3]
				keyP["camera_direction_switch"] = messageBytes[cursor + 4]
				keyP["camera_direction_left"] =
					bit.bor(messageBytes[cursor + 5], bit.bor(bit.lshift(messageBytes[cursor + 6], 8)))
				keyP["camera_direction_right"] =
					bit.bor(messageBytes[cursor + 7], bit.bor(bit.lshift(messageBytes[cursor + 8], 8)))
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "camera_direction_state,camera_direction_switch,camera_direction_left,camera_direction_right,"
			end
			if messageBytes[cursor + 0] == 0x27 and messageBytes[cursor + 1] == 0x02 then
				keyP["clean_switch"] = messageBytes[cursor + 3]
				keyP["clean_running_stage"] = messageBytes[cursor + 4]
				keyP["clean_running_time"] = messageBytes[cursor + 5]
				keyP["clean_target_time"] = messageBytes[cursor + 6]
				keyP["analysis_value"] = keyP["analysis_value"]
					.. "clean_switch,clean_running_stage,clean_running_time,clean_target_time,"
			end
			if messageBytes[cursor + 0] == 0x23 and messageBytes[cursor + 1] == 0x02 then
				keyP["light_class_switch"] = messageBytes[cursor + 3]
				keyP["light_class"] = messageBytes[cursor + 4]
				keyP["analysis_value"] = keyP["analysis_value"] .. "light_class_switch,light_class,"
			end
			if messageBytes[cursor + 0] == 0x2c and messageBytes[cursor + 1] == 0x00 then
				keyP["intrusion"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "intrusion,"
			end
			if messageBytes[cursor + 0] == 0x2d and messageBytes[cursor + 1] == 0x00 then
				keyP["intrusion_video"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "intrusion_video,"
			end
			if messageBytes[cursor + 0] == 0x20 and messageBytes[cursor + 1] == 0x00 then
				keyP["voice_control_new"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "voice_control_new,"
			end
			if messageBytes[cursor + 0] == 0x09 and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_swing_ud_angle"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wind_swing_ud_angle,"
			end
			if messageBytes[cursor + 0] == 0x0A and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_swing_lr_angle"] = messageBytes[cursor + 3]
				keyP["analysis_value"] = keyP["analysis_value"] .. "wind_swing_lr_angle,"
			end
			cursor = cursor + messageBytes[cursor + 2] + 3
		end
		if #keyP["analysis_value"] > 1 then
			keyP["analysis_value"] = string.sub(keyP["analysis_value"], 1, -2)
		end
	end
	if (dataType == 0x02 and messageBytes[0] == 0xB0) or (dataType == 0x03 and messageBytes[0] == 0xB1) then
		if #binData < 7 then
			keyP["propertyNumber"] = 1
			return nil
		end
		keyP["propertyNumber"] = messageBytes[1]
		local cursor = 2
		for i = 1, keyP["propertyNumber"] do
			if
				messageBytes[cursor + 0] == 0x31
				and messageBytes[cursor + 1] == 0x02
				and messageBytes[cursor + 11] == 0x32
				and messageBytes[cursor + 12] == 0x02
				and messageBytes[cursor + 24] == 0x33
				and messageBytes[cursor + 25] == 0x02
			then
				keyP["down_wind_speed"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x46 and messageBytes[cursor + 1] == 0x00 then
				keyP["prevent_super_cool"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x42 and messageBytes[cursor + 1] == 0x00 then
				keyP["prevent_straight_wind"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x26 and messageBytes[cursor + 1] == 0x02 then
				keyP["airoptimization"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x27 and messageBytes[cursor + 1] == 0x02 then
				keyP["self_clean"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x3A and messageBytes[cursor + 1] == 0x00 then
				keyP["child_prevent_cold_wind"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x17 and messageBytes[cursor + 1] == 0x00 then
				keyP["screen_display"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x18 and messageBytes[cursor + 1] == 0x00 then
				keyP["no_wind_sense"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x1B and messageBytes[cursor + 1] == 0x02 then
				keyP["little_angel"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x21 and messageBytes[cursor + 1] == 0x00 then
				keyP["cool_hot_sense"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x29 and messageBytes[cursor + 1] == 0x00 then
				keyP["security"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x43 and messageBytes[cursor + 1] == 0x00 then
				if messageBytes[cursor + 4] == 0x01 then
					keyP["gentle_wind_sense"] = 0x01
					keyP["prevent_straight_wind"] = 0x01
					keyP["no_wind_sense"] = 0x00
				end
				if messageBytes[cursor + 4] == 0x02 then
					keyP["prevent_straight_wind"] = 0x02
				end
				if messageBytes[cursor + 4] == 0x03 then
					keyP["gentle_wind_sense"] = 0x03
				end
				if messageBytes[cursor + 4] == 0x04 then
					keyP["no_wind_sense"] = 0x01
				end
			end
			if messageBytes[cursor + 0] == 0x3C and messageBytes[cursor + 1] == 0x02 then
				if messageBytes[cursor + 3] == 0x09 then
					keyP["full_time"] = messageBytes[cursor + 12]
				end
				keyP["powerValue"] = messageBytes[cursor + 4] - 1
				keyP["modeValue"] = messageBytes[cursor + 5]
				if messageBytes[cursor + 5] == 1 then
					keyP["modeValue"] = keyB["BYTE_MODE_AUTO"]
				elseif messageBytes[cursor + 5] == 2 then
					keyP["modeValue"] = keyB["BYTE_MODE_COOL"]
				elseif messageBytes[cursor + 5] == 3 then
					keyP["modeValue"] = keyB["BYTE_MODE_DRY"]
				elseif messageBytes[cursor + 5] == 4 then
					keyP["modeValue"] = keyB["BYTE_MODE_HEAT"]
				elseif messageBytes[cursor + 5] == 5 then
					keyP["modeValue"] = keyB["BYTE_MODE_FAN"]
				end
				keyP["wind_speed_left"] = messageBytes[cursor + 6]
				keyP["fanspeedValue"] = messageBytes[cursor + 6]
				keyP["wind_speed_right"] = messageBytes[cursor + 7]
				keyP["temperature"], keyP["smallTemperature"] = math.modf(messageBytes[cursor + 8] / 2)
				if keyP["smallTemperature"] == 0.5 then
					keyP["smallTemperature"] = 0x01
				else
					keyP["smallTemperature"] = 0x00
				end
				keyP["sceneId"] = messageBytes[cursor + 9]
				keyP["targetLWindSpeed"] = messageBytes[cursor + 10]
				keyP["targetRWindSpeed"] = messageBytes[cursor + 11]
			end
			if messageBytes[cursor + 0] == 0x29 and messageBytes[cursor + 1] == 0x02 then
				keyP["wind_swing_left"] = messageBytes[cursor + 4]
				keyP["wind_swing_left_degree"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x2A and messageBytes[cursor + 1] == 0x02 then
				keyP["wind_swing_right"] = messageBytes[cursor + 4]
				keyP["wind_swing_right_degree"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x33 and messageBytes[cursor + 1] == 0x02 then
				keyP["fresh_air"] = messageBytes[cursor + 4]
				keyP["fresh_air_fan_speed"] = messageBytes[cursor + 5]
				keyP["fresh_air_mode"] = messageBytes[cursor + 6]
				keyP["fresh_air_mode_2"] = messageBytes[cursor + 7]
				keyP["fresh_air_on_co2"] = bit.bor(bit.lshift(messageBytes[cursor + 9], 8), messageBytes[cursor + 8])
				keyP["fresh_air_off_co2"] = bit.bor(bit.lshift(messageBytes[cursor + 11], 8), messageBytes[cursor + 10])
				keyP["fresh_air_current_co2"] =
					bit.bor(bit.lshift(messageBytes[cursor + 13], 8), messageBytes[cursor + 12])
			end
			if messageBytes[cursor + 0] == 0x31 and messageBytes[cursor + 1] == 0x02 then
				keyP["remove_odor"] = messageBytes[cursor + 4]
				keyP["remove_odor_fan_speed"] = messageBytes[cursor + 5]
				keyP["remove_odor_mode"] = messageBytes[cursor + 6]
				keyP["remove_odor_time"] = bit.bor(bit.lshift(messageBytes[cursor + 8], 8), messageBytes[cursor + 7])
				keyP["remove_odor_operating_time"] =
					bit.bor(bit.lshift(messageBytes[cursor + 10], 8), messageBytes[cursor + 9])
			end
			if messageBytes[cursor + 0] == 0x32 and messageBytes[cursor + 1] == 0x02 then
				keyP["inner_purifier"] = messageBytes[cursor + 4]
				keyP["inner_purifier_fan_speed"] = messageBytes[cursor + 5]
				keyP["inner_purifier_mode"] = messageBytes[cursor + 6]
				keyP["inner_purifier_on_pm"] =
					bit.bor(bit.lshift(messageBytes[cursor + 8], 8), messageBytes[cursor + 7])
				keyP["inner_purifier_off_pm"] =
					bit.bor(bit.lshift(messageBytes[cursor + 10], 8), messageBytes[cursor + 9])
				keyP["inner_purifier_current_pm"] =
					bit.bor(bit.lshift(messageBytes[cursor + 12], 8), messageBytes[cursor + 11])
			end
			if messageBytes[cursor + 0] == 0x35 and messageBytes[cursor + 1] == 0x02 then
				keyP["humidification"] = messageBytes[cursor + 4]
				keyP["humidification_fan_speed"] = messageBytes[cursor + 5]
				keyP["humidification_mode"] = messageBytes[cursor + 6]
				keyP["humidification_auto_on"] = messageBytes[cursor + 7]
				keyP["humidification_auto_off"] = messageBytes[cursor + 8]
				keyP["humidification_manual"] = messageBytes[cursor + 9]
				keyP["humidification_current"] = messageBytes[cursor + 10]
			end
			if messageBytes[cursor + 0] == 0x2D and messageBytes[cursor + 1] == 0x02 then
				keyP["no_wind_sense_left"] = messageBytes[cursor + 4]
				keyP["left_profile"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x2E and messageBytes[cursor + 1] == 0x02 then
				keyP["no_wind_sense_right"] = messageBytes[cursor + 4]
				keyP["right_profile"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x30 and messageBytes[cursor + 1] == 0x02 then
				keyP["light"] = messageBytes[cursor + 4]
				keyP["light_bright"] = messageBytes[cursor + 5]
				keyP["light_air_level"] = messageBytes[cursor + 6]
			end
			if messageBytes[cursor + 0] == 0x3A and messageBytes[cursor + 1] == 0x02 then
				keyP["wind_swing_ud_right"] = messageBytes[cursor + 4]
				keyP["wind_swing_ud_right_degree"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x3B and messageBytes[cursor + 1] == 0x02 then
				keyP["wind_swing_ud_left"] = messageBytes[cursor + 4]
				keyP["wind_swing_ud_left_degree"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x10 and messageBytes[cursor + 1] == 0x00 then
				keyP["dryValue"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x0F and messageBytes[cursor + 1] == 0x00 then
				keyP["PTCValue"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x44 and messageBytes[cursor + 1] == 0x02 then
				keyP["strong_wind"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x2B and messageBytes[cursor + 1] == 0x02 then
				keyP["up_control_wind"] = messageBytes[cursor + 4]
				keyP["up_control_wind_degree"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x2C and messageBytes[cursor + 1] == 0x02 then
				keyP["down_control_wind"] = messageBytes[cursor + 4]
				keyP["down_control_wind_degree"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x46 and messageBytes[cursor + 1] == 0x02 then
				keyP["wait_clean"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x36 and messageBytes[cursor + 1] == 0x02 then
				keyP["left_wind"] = messageBytes[cursor + 4]
				keyP["right_wind"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x28 and messageBytes[cursor + 1] == 0x02 then
				keyP["purify_film"] = messageBytes[cursor + 4]
				keyP["purify_film_time"] =
					bit.bor(messageBytes[cursor + 5], bit.bor(bit.lshift(messageBytes[cursor + 6], 8)))
				keyP["purify_film_total_time"] =
					bit.bor(messageBytes[cursor + 7], bit.bor(bit.lshift(messageBytes[cursor + 8], 8)))
			end
			if messageBytes[cursor + 0] == 0x34 and messageBytes[cursor + 1] == 0x02 then
				keyP["wetfilm_state"] = messageBytes[cursor + 4]
				keyP["wetfilm_state_time"] =
					bit.bor(messageBytes[cursor + 5], bit.bor(bit.lshift(messageBytes[cursor + 6], 8)))
				keyP["wetfilm_state_total_time"] =
					bit.bor(messageBytes[cursor + 7], bit.bor(bit.lshift(messageBytes[cursor + 8], 8)))
			end
			if messageBytes[cursor + 0] == 0x38 and messageBytes[cursor + 1] == 0x02 then
				keyP["acstrainer_state"] = messageBytes[cursor + 4]
				keyP["acstrainer_state_time"] =
					bit.bor(messageBytes[cursor + 5], bit.bor(bit.lshift(messageBytes[cursor + 6], 8)))
				keyP["acstrainer_state_total_time"] =
					bit.bor(messageBytes[cursor + 7], bit.bor(bit.lshift(messageBytes[cursor + 8], 8)))
			end
			if messageBytes[cursor + 0] == 0x37 and messageBytes[cursor + 1] == 0x02 then
				keyP["get_weather"] = messageBytes[cursor + 4]
				keyP["outdoor_pm25"] =
					bit.bor(messageBytes[cursor + 5], bit.bor(bit.lshift(messageBytes[cursor + 6], 8)))
			end
			if messageBytes[cursor + 0] == 0x39 and messageBytes[cursor + 1] == 0x02 then
				keyP["near_switch"] = messageBytes[cursor + 4]
				keyP["near_no_yes"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x3E and messageBytes[cursor + 1] == 0x02 then
				keyP["water_supply"] = messageBytes[cursor + 4]
				keyP["water_level"] = messageBytes[cursor + 5]
				keyP["water_tank"] = messageBytes[cursor + 6]
			end
			if messageBytes[cursor + 0] == 0x3F and messageBytes[cursor + 1] == 0x02 then
				keyP["air_condition_temp"] = messageBytes[cursor + 5]
				keyP["air_condition_humidity"] = messageBytes[cursor + 6]
				keyP["air_condition_clean"] = messageBytes[cursor + 7]
				keyP["air_condition_fresh"] = messageBytes[cursor + 8]
			end
			if messageBytes[cursor + 0] == 0x04 and messageBytes[cursor + 1] == 0x00 then
				keyP["indoor_temp"] = messageBytes[cursor + 4]
				keyP["indoor_temp_decimal"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x05 and messageBytes[cursor + 1] == 0x00 then
				keyP["outdoor_temp"] = messageBytes[cursor + 4]
				keyP["outdoor_temp_decimal"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x1E and messageBytes[cursor + 1] == 0x00 then
				keyP["eco_switch"] = messageBytes[cursor + 4]
				keyP["eco_second"] = messageBytes[cursor + 5]
				keyP["eco_min"] = messageBytes[cursor + 6]
				keyP["eco_hour"] = messageBytes[cursor + 7]
			end
			if messageBytes[cursor + 0] == 0x22 and messageBytes[cursor + 1] == 0x00 then
				keyP["keep_warm_switch"] = messageBytes[cursor + 4]
				keyP["keep_warm_temp"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x01 and messageBytes[cursor + 1] == 0x00 then
				keyP["close_screen"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x45 and messageBytes[cursor + 1] == 0x00 then
				keyP["exclusive_mode"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x44 and messageBytes[cursor + 1] == 0x00 then
				keyP["family_number"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x32 and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_blow_close"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x33 and messageBytes[cursor + 1] == 0x00 then
				keyP["wisdom_wind"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x53 and messageBytes[cursor + 1] == 0x00 then
				keyP["wisdom_wind_new"] = messageBytes[cursor + 4]
				keyP["wisdom_left_distance"] = messageBytes[cursor + 5]
				keyP["wisdom_right_distance"] = messageBytes[cursor + 6]
				keyP["wisdom_left_set_wind"] = messageBytes[cursor + 7]
				keyP["wisdom_right_set_wind"] = messageBytes[cursor + 8]
				keyP["wisdom_left_down_angle"] =
					bit.bor(messageBytes[cursor + 9], bit.bor(bit.lshift(messageBytes[cursor + 10], 8)))
				keyP["wisdom_right_down_angle"] =
					bit.bor(messageBytes[cursor + 11], bit.bor(bit.lshift(messageBytes[cursor + 12], 8)))
				keyP["wisdom_left_up_angle"] =
					bit.bor(messageBytes[cursor + 13], bit.bor(bit.lshift(messageBytes[cursor + 14], 8)))
				keyP["wisdom_right_up_angle"] =
					bit.bor(messageBytes[cursor + 15], bit.bor(bit.lshift(messageBytes[cursor + 16], 8)))
			end
			if messageBytes[cursor + 0] == 0x54 and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_blow"] = messageBytes[cursor + 4]
				keyP["wind_blow_left_distance"] = messageBytes[cursor + 5]
				keyP["wind_blow_right_distance"] = messageBytes[cursor + 6]
				keyP["wind_blow_left_down_angle"] =
					bit.bor(messageBytes[cursor + 7], bit.bor(bit.lshift(messageBytes[cursor + 8], 8)))
				keyP["wind_blow_right_down_angle"] =
					bit.bor(messageBytes[cursor + 9], bit.bor(bit.lshift(messageBytes[cursor + 10], 8)))
				keyP["wind_blow_left_up_angle"] =
					bit.bor(messageBytes[cursor + 11], bit.bor(bit.lshift(messageBytes[cursor + 12], 8)))
				keyP["wind_blow_right_up_angle"] =
					bit.bor(messageBytes[cursor + 13], bit.bor(bit.lshift(messageBytes[cursor + 14], 8)))
			end
			if messageBytes[cursor + 0] == 0x55 and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_close"] = messageBytes[cursor + 4]
				keyP["wind_close_left_distance"] = messageBytes[cursor + 5]
				keyP["wind_close_right_distance"] = messageBytes[cursor + 6]
				keyP["wind_close_left_down_angle"] =
					bit.bor(messageBytes[cursor + 7], bit.bor(bit.lshift(messageBytes[cursor + 8], 8)))
				keyP["wind_close_right_down_angle"] =
					bit.bor(messageBytes[cursor + 9], bit.bor(bit.lshift(messageBytes[cursor + 10], 8)))
				keyP["wind_close_left_up_angle"] =
					bit.bor(messageBytes[cursor + 11], bit.bor(bit.lshift(messageBytes[cursor + 12], 8)))
				keyP["wind_close_right_up_angle"] =
					bit.bor(messageBytes[cursor + 13], bit.bor(bit.lshift(messageBytes[cursor + 14], 8)))
			end
			if messageBytes[cursor + 0] == 0x56 and messageBytes[cursor + 1] == 0x00 then
				keyP["camera_direction_state"] = messageBytes[cursor + 4]
				keyP["camera_direction_switch"] = messageBytes[cursor + 5]
				keyP["camera_direction_left"] =
					bit.bor(messageBytes[cursor + 6], bit.bor(bit.lshift(messageBytes[cursor + 7], 8)))
				keyP["camera_direction_right"] =
					bit.bor(messageBytes[cursor + 8], bit.bor(bit.lshift(messageBytes[cursor + 9], 8)))
			end
			if messageBytes[cursor + 0] == 0x27 and messageBytes[cursor + 1] == 0x02 then
				keyP["clean_switch"] = messageBytes[cursor + 4]
				keyP["clean_running_stage"] = messageBytes[cursor + 5]
				keyP["clean_running_time"] = messageBytes[cursor + 6]
				keyP["clean_target_time"] = messageBytes[cursor + 7]
			end
			if messageBytes[cursor + 0] == 0x23 and messageBytes[cursor + 1] == 0x02 then
				keyP["light_class_switch"] = messageBytes[cursor + 4]
				keyP["light_class"] = messageBytes[cursor + 5]
			end
			if messageBytes[cursor + 0] == 0x2c and messageBytes[cursor + 1] == 0x00 then
				keyP["intrusion"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x2d and messageBytes[cursor + 1] == 0x00 then
				keyP["intrusion_video"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x20 and messageBytes[cursor + 1] == 0x00 then
				keyP["voice_control_new"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x09 and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_swing_ud_angle"] = messageBytes[cursor + 4]
			end
			if messageBytes[cursor + 0] == 0x0A and messageBytes[cursor + 1] == 0x00 then
				keyP["wind_swing_lr_angle"] = messageBytes[cursor + 4]
			end
			cursor = cursor + messageBytes[cursor + 3] + 4
		end
	end
end
local function getTotalMsg(bodyData, cType)
	local bodyLength = #bodyData
	local msgLength = bodyLength + keyB["BYTE_PROTOCOL_LENGTH"] + 1
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = keyB["BYTE_PROTOCOL_HEAD"]
	msgBytes[1] = bodyLength + keyB["BYTE_PROTOCOL_LENGTH"] + 1
	msgBytes[2] = keyB["BYTE_DEVICE_TYPE"]
	if keyP["propertyNumber"] > 0 then
		msgBytes[8] = 0x02
	end
	msgBytes[9] = cType
	for i = 0, bodyLength do
		msgBytes[i + keyB["BYTE_PROTOCOL_LENGTH"]] = bodyData[i]
	end
	msgBytes[msgLength] = makeSum(msgBytes, 1, msgLength - 1)
	local msgFinal = {}
	for i = 1, msgLength + 1 do
		msgFinal[i] = msgBytes[i - 1]
	end
	return msgFinal
end
local function getStatusMsg(cType)
	local msgLength = 13
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = keyB["BYTE_PROTOCOL_HEAD"]
	msgBytes[1] = 13
	msgBytes[2] = keyB["BYTE_DEVICE_TYPE"]
	msgBytes[8] = 0x02
	msgBytes[9] = 0x03
	msgBytes[10] = 0xC1
	msgBytes[11] = cType
	msgBytes[12] = crc8_854(msgBytes, 10, 11)
	msgBytes[msgLength] = makeSum(msgBytes, 1, msgLength - 1)
	local msgFinal = {}
	for i = 1, msgLength + 1 do
		msgFinal[i] = msgBytes[i - 1]
	end
	return msgFinal
end
local function handle_property_control(control, bodyBytes, cursor)
	local count = 0
	local property_number = 0
	if keyP["buzzerValue"] ~= nil and property_number > 0 then
		property_number = property_number + 1
		bodyBytes[cursor + 0] = 0x1A
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x01
		bodyBytes[cursor + 3] = 0x00
		if keyP["buzzerValue"] == 0x40 then
			bodyBytes[cursor + 3] = 0x01
		end
	end
	return count
end
local function handle_camera_direction_switch(control, bodyBytes, cursor)
	if control["camera_direction_switch"] ~= nil then
		bodyBytes[cursor + 0] = 0x56
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x06
		bodyBytes[cursor + 3] = keyP["camera_direction_state"]
		bodyBytes[cursor + 4] = keyP["camera_direction_switch"]
		bodyBytes[cursor + 5] = bit.band(keyP["camera_direction_left"], 0xff)
		bodyBytes[cursor + 6] = bit.band(bit.rshift(keyP["camera_direction_left"], 8), 0xff)
		bodyBytes[cursor + 7] = bit.band(keyP["camera_direction_right"], 0xff)
		bodyBytes[cursor + 8] = bit.band(bit.rshift(keyP["camera_direction_right"], 8), 0xff)
		cursor = cursor + 9
	end
	return bodyBytes, cursor
end
local function handle_exclusive_mode(control, bodyBytes, cursor)
	if control["exclusive_mode"] ~= nil then
		bodyBytes[cursor + 0] = 0x45
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x01
		bodyBytes[cursor + 3] = keyP["exclusive_mode"]
		cursor = cursor + 4
	end
	return bodyBytes, cursor
end
local function handle_wind_blow_close(control, bodyBytes, cursor)
	if control["wind_blow_close"] ~= nil then
		bodyBytes[cursor + 0] = 0x32
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x01
		bodyBytes[cursor + 3] = keyP["wind_blow_close"]
		cursor = cursor + 4
	end
	return bodyBytes, cursor
end
local function handle_wisdom_wind(control, bodyBytes, cursor)
	if control["wisdom_wind"] ~= nil then
		bodyBytes[cursor + 0] = 0x33
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x01
		bodyBytes[cursor + 3] = keyP["wisdom_wind"]
		cursor = cursor + 4
	end
	return bodyBytes, cursor
end
local function handle_wisdom_wind_new(control, bodyBytes, cursor)
	if control["wisdom_wind_new"] ~= nil then
		bodyBytes[cursor + 0] = 0x53
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x0D
		bodyBytes[cursor + 3] = keyP["wisdom_wind_new"]
		bodyBytes[cursor + 4] = keyP["wisdom_left_distance"]
		bodyBytes[cursor + 5] = keyP["wisdom_right_distance"]
		bodyBytes[cursor + 6] = keyP["wisdom_left_set_wind"]
		bodyBytes[cursor + 7] = keyP["wisdom_right_set_wind"]
		bodyBytes[cursor + 8] = bit.band(keyP["wisdom_left_down_angle"], 0xff)
		bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["wisdom_left_down_angle"], 8), 0xff)
		bodyBytes[cursor + 10] = bit.band(keyP["wisdom_right_down_angle"], 0xff)
		bodyBytes[cursor + 11] = bit.band(bit.rshift(keyP["wisdom_right_down_angle"], 8), 0xff)
		bodyBytes[cursor + 12] = bit.band(keyP["wisdom_left_up_angle"], 0xff)
		bodyBytes[cursor + 13] = bit.band(bit.rshift(keyP["wisdom_left_up_angle"], 8), 0xff)
		bodyBytes[cursor + 14] = bit.band(keyP["wisdom_right_up_angle"], 0xff)
		bodyBytes[cursor + 15] = bit.band(bit.rshift(keyP["wisdom_right_up_angle"], 8), 0xff)
		cursor = cursor + 16
	end
	return bodyBytes, cursor
end
local function handle_wind_blow(control, bodyBytes, cursor)
	if control["wind_blow"] ~= nil then
		bodyBytes[cursor + 0] = 0x54
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x0B
		bodyBytes[cursor + 3] = keyP["wind_blow"]
		bodyBytes[cursor + 4] = keyP["wind_blow_left_distance"]
		bodyBytes[cursor + 5] = keyP["wind_blow_right_distance"]
		bodyBytes[cursor + 6] = bit.band(keyP["wind_blow_left_down_angle"], 0xff)
		bodyBytes[cursor + 7] = bit.band(bit.rshift(keyP["wind_blow_left_down_angle"], 8), 0xff)
		bodyBytes[cursor + 8] = bit.band(keyP["wind_blow_right_down_angle"], 0xff)
		bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["wind_blow_right_down_angle"], 8), 0xff)
		bodyBytes[cursor + 10] = bit.band(keyP["wind_blow_left_up_angle"], 0xff)
		bodyBytes[cursor + 11] = bit.band(bit.rshift(keyP["wind_blow_left_up_angle"], 8), 0xff)
		bodyBytes[cursor + 12] = bit.band(keyP["wind_blow_right_up_angle"], 0xff)
		bodyBytes[cursor + 13] = bit.band(bit.rshift(keyP["wind_blow_right_up_angle"], 8), 0xff)
		cursor = cursor + 14
	end
	return bodyBytes, cursor
end
local function handle_wind_close(control, bodyBytes, cursor)
	if control["wind_close"] ~= nil then
		bodyBytes[cursor + 0] = 0x55
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x0B
		bodyBytes[cursor + 3] = keyP["wind_close"]
		bodyBytes[cursor + 4] = keyP["wind_close_left_distance"]
		bodyBytes[cursor + 5] = keyP["wind_close_right_distance"]
		bodyBytes[cursor + 6] = bit.band(keyP["wind_close_left_down_angle"], 0xff)
		bodyBytes[cursor + 7] = bit.band(bit.rshift(keyP["wind_close_left_down_angle"], 8), 0xff)
		bodyBytes[cursor + 8] = bit.band(keyP["wind_close_right_down_angle"], 0xff)
		bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["wind_close_right_down_angle"], 8), 0xff)
		bodyBytes[cursor + 10] = bit.band(keyP["wind_close_left_up_angle"], 0xff)
		bodyBytes[cursor + 11] = bit.band(bit.rshift(keyP["wind_close_left_up_angle"], 8), 0xff)
		bodyBytes[cursor + 12] = bit.band(keyP["wind_close_right_up_angle"], 0xff)
		bodyBytes[cursor + 13] = bit.band(bit.rshift(keyP["wind_close_right_up_angle"], 8), 0xff)
		cursor = cursor + 14
	end
	return bodyBytes, cursor
end
local function handle_left_wind(control, bodyBytes, cursor)
	if control["left_wind"] ~= nil or control["right_wind"] ~= nil then
		bodyBytes[cursor + 0] = 0x36
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x02
		bodyBytes[cursor + 3] = keyP["left_wind"]
		bodyBytes[cursor + 4] = keyP["right_wind"]
		cursor = cursor + 5
	end
	return bodyBytes, cursor
end
local function handle_one_key_ac(control, bodyBytes, cursor)
	if
		tempControl == 1
		and (
			keyP["powerValue"] ~= nil
			or keyP["modeValue"] ~= nil
			or keyP["wind_speed_left"] ~= nil
			or keyP["wind_speed_right"] ~= nil
			or keyP["temperature"] ~= nil
			or keyP["sceneId"] ~= nil
			or keyP["targetLWindSpeed"] ~= nil
			or keyP["targetRWindSpeed"] ~= nil
			or keyP["wind_speed"] ~= nil
		)
	then
		bodyBytes[cursor + 0] = 0x3C
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x08
		bodyBytes[cursor + 3] = keyP["powerValue"] + 1
		bodyBytes[cursor + 4] = keyP["modeValue"]
		if keyP["modeValue"] == keyB["BYTE_MODE_HEAT"] then
			bodyBytes[cursor + 4] = 0x04
		elseif keyP["modeValue"] == keyB["BYTE_MODE_COOL"] then
			bodyBytes[cursor + 4] = 0x02
		elseif keyP["modeValue"] == keyB["BYTE_MODE_AUTO"] then
			bodyBytes[cursor + 4] = 0x01
		elseif keyP["modeValue"] == keyB["BYTE_MODE_COOL"] then
			bodyBytes[cursor + 4] = 0x02
		elseif keyP["modeValue"] == keyB["BYTE_MODE_DRY"] then
			bodyBytes[cursor + 4] = 0x03
		elseif keyP["modeValue"] == keyB["BYTE_MODE_FAN"] then
			bodyBytes[cursor + 4] = 0x05
		end
		if keyP["wind_speed_control"] ~= nil then
			bodyBytes[cursor + 5] = keyP["wind_speed_control"]
			bodyBytes[cursor + 6] = keyP["wind_speed_control"]
		else
			bodyBytes[cursor + 5] = keyP["wind_speed_left"]
			bodyBytes[cursor + 6] = keyP["wind_speed_right"]
		end
		if keyP["smallTemperature"] == 0x01 then
			bodyBytes[cursor + 7] = (keyP["temperature"] + 0.5) * 2
		else
			bodyBytes[cursor + 7] = keyP["temperature"] * 2
		end
		bodyBytes[cursor + 8] = keyP["sceneId"]
		bodyBytes[cursor + 9] = keyP["targetLWindSpeed"]
		bodyBytes[cursor + 10] = keyP["targetRWindSpeed"]
		cursor = cursor + 11
	end
	return bodyBytes, cursor
end
local function handle_airoptimization(control, bodyBytes, cursor)
	if keyP["airoptimization"] ~= nil then
		bodyBytes[cursor + 0] = 0x26
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x01
		bodyBytes[cursor + 3] = keyP["airoptimization"]
		cursor = cursor + 4
	end
	return bodyBytes, cursor
end
local function handle_humidification(control, bodyBytes, cursor)
	if keyP["humidification"] ~= nil or keyP["down_wind_speed"] ~= nil then
		bodyBytes[cursor + 0] = 0x35
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x07
		bodyBytes[cursor + 3] = keyP["humidification"]
		bodyBytes[cursor + 4] = keyP["humidification_fan_speed"]
		bodyBytes[cursor + 5] = keyP["humidification_mode"]
		bodyBytes[cursor + 6] = keyP["humidification_auto_on"]
		bodyBytes[cursor + 7] = keyP["humidification_auto_off"]
		bodyBytes[cursor + 8] = keyP["humidification_manual"]
		bodyBytes[cursor + 9] = keyP["humidification_current"]
		cursor = cursor + 10
	end
	return bodyBytes, cursor
end
local function handle_inner_purifier(control, bodyBytes, cursor)
	if keyP["inner_purifier"] ~= nil or keyP["down_wind_speed"] ~= nil then
		bodyBytes[cursor + 0] = 0x32
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x09
		bodyBytes[cursor + 3] = keyP["inner_purifier"]
		bodyBytes[cursor + 4] = keyP["inner_purifier_fan_speed"]
		bodyBytes[cursor + 5] = keyP["inner_purifier_mode"]
		bodyBytes[cursor + 6] = bit.band(keyP["inner_purifier_on_pm"], 0xff)
		bodyBytes[cursor + 7] = bit.band(bit.rshift(keyP["inner_purifier_on_pm"], 8), 0xff)
		bodyBytes[cursor + 8] = bit.band(keyP["inner_purifier_off_pm"], 0xff)
		bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["inner_purifier_off_pm"], 8), 0xff)
		bodyBytes[cursor + 10] = bit.band(keyP["inner_purifier_current_pm"], 0xff)
		bodyBytes[cursor + 11] = bit.band(bit.rshift(keyP["inner_purifier_current_pm"], 8), 0xff)
		cursor = cursor + 12
	end
	return bodyBytes, cursor
end
local function handle_fresh_air(control, bodyBytes, cursor)
	if keyP["fresh_air"] ~= nil or keyP["down_wind_speed"] ~= nil then
		bodyBytes[cursor + 0] = 0x33
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x0A
		bodyBytes[cursor + 3] = keyP["fresh_air"]
		bodyBytes[cursor + 4] = keyP["fresh_air_fan_speed"]
		bodyBytes[cursor + 5] = keyP["fresh_air_mode"]
		bodyBytes[cursor + 6] = keyP["fresh_air_mode_2"]
		bodyBytes[cursor + 7] = bit.band(keyP["fresh_air_on_co2"], 0xff)
		bodyBytes[cursor + 8] = bit.band(bit.rshift(keyP["fresh_air_on_co2"], 8), 0xff)
		bodyBytes[cursor + 9] = bit.band(keyP["fresh_air_off_co2"], 0xff)
		bodyBytes[cursor + 10] = bit.band(bit.rshift(keyP["fresh_air_off_co2"], 8), 0xff)
		bodyBytes[cursor + 11] = bit.band(keyP["fresh_air_current_co2"], 0xff)
		bodyBytes[cursor + 12] = bit.band(bit.rshift(keyP["fresh_air_current_co2"], 8), 0xff)
		cursor = cursor + 13
	end
	return bodyBytes, cursor
end
local function handle_wind_swing_left(control, bodyBytes, cursor)
	if control["wind_swing_left"] ~= nil then
		bodyBytes[cursor + 0] = 0x29
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x02
		bodyBytes[cursor + 3] = keyP["wind_swing_left"]
		bodyBytes[cursor + 4] = keyP["wind_swing_left_degree"]
		cursor = cursor + 5
	end
	return bodyBytes, cursor
end
local function handle_wind_swing_ud_left(control, bodyBytes, cursor)
	if control["wind_swing_ud_left"] ~= nil then
		bodyBytes[cursor + 0] = 0x3B
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x02
		bodyBytes[cursor + 3] = keyP["wind_swing_ud_left"]
		bodyBytes[cursor + 4] = keyP["wind_swing_ud_left_degree"]
		cursor = cursor + 5
	end
	return bodyBytes, cursor
end
local function handle_wind_swing_ud_right(control, bodyBytes, cursor)
	if control["wind_swing_ud_right"] ~= nil then
		bodyBytes[cursor + 0] = 0x3A
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x02
		bodyBytes[cursor + 3] = keyP["wind_swing_ud_right"]
		bodyBytes[cursor + 4] = keyP["wind_swing_ud_right_degree"]
		cursor = cursor + 5
	end
	return bodyBytes, cursor
end
local function handle_remove_odor(control, bodyBytes, cursor)
	if keyP["remove_odor"] ~= nil or keyP["down_wind_speed"] ~= nil then
		bodyBytes[cursor + 0] = 0x31
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x07
		bodyBytes[cursor + 3] = keyP["remove_odor"]
		bodyBytes[cursor + 4] = keyP["remove_odor_fan_speed"]
		bodyBytes[cursor + 5] = keyP["remove_odor_mode"]
		bodyBytes[cursor + 6] = bit.band(keyP["remove_odor_time"], 0xff)
		bodyBytes[cursor + 7] = bit.band(bit.rshift(keyP["remove_odor_time"], 8), 0xff)
		bodyBytes[cursor + 8] = bit.band(keyP["remove_odor_operating_time"], 0xff)
		bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["remove_odor_operating_time"], 8), 0xff)
		cursor = cursor + 10
	end
	return bodyBytes, cursor
end
local function handle_clean_switch(control, bodyBytes, cursor)
	if control["clean_switch"] ~= nil then
		bodyBytes[cursor + 0] = 0x27
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x04
		bodyBytes[cursor + 3] = keyP["clean_switch"]
		bodyBytes[cursor + 4] = keyP["clean_running_stage"]
		bodyBytes[cursor + 5] = keyP["clean_running_time"]
		bodyBytes[cursor + 6] = keyP["clean_target_time"]
		cursor = cursor + 7
	end
	return bodyBytes, cursor
end
local function handle_dry(control, bodyBytes, cursor)
	if keyP["dryValue"] ~= nil then
		bodyBytes[cursor + 0] = 0x10
		bodyBytes[cursor + 1] = 0x00
		bodyBytes[cursor + 2] = 0x01
		bodyBytes[cursor + 3] = keyP["dryValue"]
		cursor = cursor + 4
	end
	return bodyBytes, cursor
end
local function handle_wait_clean(control, bodyBytes, cursor)
	if control["wait_clean"] ~= nil then
		bodyBytes[cursor + 0] = 0x46
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x01
		bodyBytes[cursor + 3] = keyP["wait_clean"]
		cursor = cursor + 4
	end
	return bodyBytes, cursor
end
local function handle_no_wind_sense_left(control, bodyBytes, cursor)
	if keyP["no_wind_sense_left"] ~= nil then
		bodyBytes[cursor + 0] = 0x2D
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x02
		bodyBytes[cursor + 3] = keyP["no_wind_sense_left"]
		bodyBytes[cursor + 4] = keyP["left_profile"]
		cursor = cursor + 5
	end
	return bodyBytes, cursor
end
local function handle_no_wind_sense_right(control, bodyBytes, cursor)
	if keyP["no_wind_sense_right"] ~= nil then
		bodyBytes[cursor + 0] = 0x2E
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x02
		bodyBytes[cursor + 3] = keyP["no_wind_sense_right"]
		bodyBytes[cursor + 4] = keyP["right_profile"]
		cursor = cursor + 5
	end
	return bodyBytes, cursor
end
local function handle_wind_swing_right(control, bodyBytes, cursor)
	if control["wind_swing_right"] ~= nil then
		bodyBytes[cursor + 0] = 0x2A
		bodyBytes[cursor + 1] = 0x02
		bodyBytes[cursor + 2] = 0x02
		bodyBytes[cursor + 3] = keyP["wind_swing_right"]
		bodyBytes[cursor + 4] = keyP["wind_swing_right_degree"]
		cursor = cursor + 5
	end
	return bodyBytes, cursor
end
function jsonToData(jsonCmd)
	if #jsonCmd == 0 then
		return nil
	end
	init_property_value()
	local infoM = {}
	local bodyBytes = {}
	local json = decode(jsonCmd)
	deviceSubType = json["deviceinfo"]["deviceSubType"]
	local deviceSN = json["deviceinfo"]["deviceSN"]
	if deviceSN ~= nil then
		deviceSN8 = string.sub(deviceSN, 4, 8)
	end
	local query = json["query"]
	local control = json["control"]
	local status = json["status"]
	if query then
		local queryType = nil
		if type(query) == "table" then
			queryType = query["query_type"]
		end
		if
			queryType == "purifier"
			or queryType == "buzzer"
			or queryType == "power_on_timer"
			or queryType == "power_off_timer"
			or queryType == "power_on_time_value"
			or queryType == "power_off_time_value"
			or queryType == "indoor_temperature"
			or queryType == "outdoor_temperature"
			or queryType == "eco"
			or queryType == "kick_quilt"
			or queryType == "prevent_cold"
			or queryType == "screen_display"
			or queryType == "current_work_time"
			or queryType == "comfort_power_save"
		then
			for i = 0, 21 do
				bodyBytes[i] = 0
			end
			bodyBytes[0] = 0x41
			bodyBytes[1] = 0x81
			bodyBytes[3] = 0xFF
			math.randomseed(tostring(os.time() * #bodyBytes):reverse():sub(1, 7))
			math.random()
			bodyBytes[20] = 2
			bodyBytes[21] = crc8_854(bodyBytes, 0, 20)
			infoM = getTotalMsg(bodyBytes, keyB["BYTE_QUERYL_REQUEST"])
		elseif queryType == "c1_status" then
			infoM = getStatusMsg(0x01)
		elseif queryType == "c1_status_two" then
			infoM = getStatusMsg(0x02)
		else
			bodyBytes[0] = 0xB1
			local propertyNum = 0
			local queryList = {}
			if queryType ~= nil then
				if string.match(queryType, ",") == "," then
					queryList = splitStrByChar(queryType, ",")
				else
					table.insert(queryList, queryType)
				end
			else
				table.insert(queryList, "full")
			end
			for v in values(queryList) do
				queryType = v
				if
					queryType == "full"
					or queryType == "mode"
					or queryType == "temperature"
					or queryType == "small_temperature"
					or queryType == "power"
					or queryType == "wind_speed_left"
					or queryType == "wind_speed_right"
				then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x3C
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_swing_lr" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x29
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					bodyBytes[1 + propertyNum * 2 + 3] = 0x2A
					bodyBytes[1 + propertyNum * 2 + 4] = 0x02
					propertyNum = propertyNum + 2
				end
				if queryType == "wind_swing_ud" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x3A
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					bodyBytes[1 + propertyNum * 2 + 3] = 0x3B
					bodyBytes[1 + propertyNum * 2 + 4] = 0x02
					propertyNum = propertyNum + 2
				end
				if queryType == "no_wind_sense" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x2D
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					bodyBytes[1 + propertyNum * 2 + 3] = 0x2E
					bodyBytes[1 + propertyNum * 2 + 4] = 0x02
					propertyNum = propertyNum + 2
				end
				if queryType == "cool_hot_sense" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x21
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "nobody_energy_save" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x30
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "self_clean" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x27
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "child_prevent_cold_wind" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x3A
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "error_code_query" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x3F
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "mode_query" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x41
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "prevent_straight_wind" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x42
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "prevent_super_cool" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x46
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "high_temperature_monitor" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x47
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "rate_select" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x48
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "airoptimization" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x26
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "fresh_air" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x33
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "remove_odor" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x31
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "inner_purifier" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x32
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "humidification" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x35
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "no_wind_sense_left" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x2D
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "no_wind_sense_right" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x2E
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "light" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x30
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "down_wind_speed" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x31
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					bodyBytes[1 + propertyNum * 2 + 3] = 0x32
					bodyBytes[1 + propertyNum * 2 + 4] = 0x02
					bodyBytes[1 + propertyNum * 2 + 5] = 0x33
					bodyBytes[1 + propertyNum * 2 + 6] = 0x02
					bodyBytes[1 + propertyNum * 2 + 7] = 0x35
					bodyBytes[1 + propertyNum * 2 + 8] = 0x02
					propertyNum = propertyNum + 4
				end
				if queryType == "dry" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x10
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "ptc" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x0F
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "strong_wind" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x44
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "up_control_wind" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x2B
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "down_control_wind" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x2C
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "wait_clean" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x46
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "left_wind" or queryType == "right_wind" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x36
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "purify_film" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x28
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "wetfilm_state" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x34
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "acstrainer_state" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x38
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "get_weather" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x37
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "water_supply" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x3E
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "air_condition_temp" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x3F
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "indoor_temp" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x04
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "outdoor_temp" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x05
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "eco_state" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x1E
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "keep_warm_switch" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x22
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "close_screen" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x01
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "exclusive_mode" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x45
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "family_number" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x44
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_blow_close" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x32
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "wisdom_wind" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x33
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "wisdom_wind_new" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x53
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_blow" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x54
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_close" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x55
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "clean_switch" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x27
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "light_class_switch" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x23
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_swing_left" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x29
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_swing_right" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x2A
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_swing_ud_right" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x3A
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_swing_ud_left" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x3B
					bodyBytes[1 + propertyNum * 2 + 2] = 0x02
					propertyNum = propertyNum + 1
				end
				if queryType == "camera_direction_switch" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x56
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "intrusion" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x2C
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "intrusion_video" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x2D
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "voice_control_new" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x20
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_swing_ud_angle" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x09
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "wind_swing_lr_angle" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x0A
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
				if queryType == "gentle_wind_sense" then
					bodyBytes[1 + propertyNum * 2 + 1] = 0x43
					bodyBytes[1 + propertyNum * 2 + 2] = 0x00
					propertyNum = propertyNum + 1
				end
			end
			bodyBytes[1] = propertyNum
			math.randomseed(tostring(os.time() * #bodyBytes):reverse():sub(1, 7))
			math.random()
			bodyBytes[1 + propertyNum * 2 + 1] = 3
			bodyBytes[1 + propertyNum * 2 + 2] = crc8_854(bodyBytes, 0, 1 + propertyNum * 2 + 1)
			infoM = getTotalMsg(bodyBytes, keyB["BYTE_QUERYL_REQUEST"])
		end
	elseif control then
		if status then
			jsonToModel(status, "status")
		end
		if control then
			local retStr = "aa23ac0000000000000341c100ff02ff020200000000000000000000000000000003c95c"
			if
				(control[keyT["KEY_SCREEN_DISPLAY"]] ~= nil)
				and (deviceSN8 ~= "12035")
				and (deviceSN8 ~= "50939")
				and (deviceSN8 ~= "51001")
				and (deviceSN8 ~= "Z1304")
			then
				return retStr
			end
			jsonToModel(control, "control")
		end
		if keyP["propertyNumber"] == 0 then
			for i = 0, 25 do
				bodyBytes[i] = 0
			end
			bodyBytes[0] = keyB["BYTE_CONTROL_CMD"]
			if keyP["buzzerValue"] ~= nil then
				bodyBytes[1] = bit.bor(
					bit.bor(keyP["powerValue"], keyB["BYTE_CLIENT_MODE_MOBILE"]),
					bit.bor(keyB["BYTE_TIMER_METHOD_REL"], keyP["buzzerValue"])
				)
			else
				bodyBytes[1] = bit.bor(
					bit.bor(keyP["powerValue"], keyB["BYTE_CLIENT_MODE_MOBILE"]),
					bit.bor(keyB["BYTE_TIMER_METHOD_REL"], 0x40)
				)
			end
			bodyBytes[2] = bit.bor(
				bit.bor(bit.band(keyP["modeValue"], 0xE0), bit.band(0x0F, (keyP["temperature"] - 0x10))),
				bit.lshift(bit.band(keyP["smallTemperature"], 0x01), 4)
			)
			bodyBytes[3] = bit.bor(keyP["fanspeedValue"], keyB["BYTE_TIMER_SWITCH_ON"])
			if keyP["closeTime"] == nil then
				keyP["closeTime"] = 0
			end
			keyP["closeHour"] = math.floor(keyP["closeTime"] / 60)
			keyP["closeStepMintues"] = math.floor((keyP["closeTime"] % 60) / 15)
			keyP["closeMin"] = math.floor(((keyP["closeTime"] % 60) % 15))
			if keyP["openTime"] == nil then
				keyP["openTime"] = 0
			end
			keyP["openHour"] = math.floor(keyP["openTime"] / 60)
			keyP["openStepMintues"] = math.floor((keyP["openTime"] % 60) / 15)
			keyP["openMin"] = math.floor(((keyP["openTime"] % 60) % 15))
			if keyP["openTimerSwitch"] == keyB["BYTE_START_TIMER_SWITCH_ON"] then
				bodyBytes[4] =
					bit.bor(bit.bor(keyP["openTimerSwitch"], bit.lshift(keyP["openHour"], 2)), keyP["openStepMintues"])
			elseif keyP["openTimerSwitch"] == keyB["BYTE_START_TIMER_SWITCH_OFF"] then
				bodyBytes[4] = 0x7F
			end
			if keyP["closeTimerSwitch"] == keyB["BYTE_CLOSE_TIMER_SWITCH_ON"] then
				bodyBytes[5] = bit.bor(
					bit.bor(keyP["closeTimerSwitch"], bit.lshift(keyP["closeHour"], 2)),
					keyP["closeStepMintues"]
				)
			elseif keyP["closeTimerSwitch"] == keyB["BYTE_CLOSE_TIMER_SWITCH_OFF"] then
				bodyBytes[5] = 0x7F
			end
			bodyBytes[6] = bit.bor(bit.lshift((15 - keyP["openMin"]), 4), (15 - keyP["closeMin"]))
			bodyBytes[7] = bit.bor(bit.bor(keyP["swingLRValue"], keyP["swingUDValue"]), 0x30)
			bodyBytes[8] = bit.bor(keyP["strongWindValue"], keyP["comfortableSleepValue"])
			bodyBytes[9] =
				bit.bor(bit.bor(keyP["purifierValue"], keyP["ecoValue"]), bit.bor(keyP["dryValue"], keyP["PTCValue"]))
			if (keyP["PTCValue"] ~= nil) and (keyP["PTCValue"] == keyB["BYTE_PTC_ON"]) then
				bodyBytes[9] = bit.bor(bodyBytes[9], 0x10)
			end
			bodyBytes[10] = bit.bor(keyP["preventCold"], bodyBytes[10])
			bodyBytes[19] = bit.bor(keyP["swingLRUnderSwitch"], bodyBytes[19])
			bodyBytes[20] = bit.bor(keyP["swingLRValueUnder"], bodyBytes[20])
			if keyP["comfortPowerSave"] == keyB["BYTE_COMFORT_POWER_SAVE_ON"] then
				bodyBytes[22] = 0x01
			elseif keyP["comfortPowerSave"] == keyB["BYTE_COMFORT_POWER_SAVE_OFF"] then
				bodyBytes[22] = 0x00
			end
			math.randomseed(tostring(os.time() * (bodyBytes[2] + bodyBytes[1] + bodyBytes[3])):reverse():sub(1, 7))
			math.random()
			bodyBytes[24] = 4
			bodyBytes[25] = crc8_854(bodyBytes, 0, 24)
		else
			bodyBytes[0] = keyB["BYTE_CONTROL_PROPERTY_CMD"]
			bodyBytes[1] = keyP["propertyNumber"] + 1
			local cursor = 2
			ret = handle_property_control(control, bodyBytes, cursor)
			if ret == 0 then
				if keyP["swingLRValue"] ~= nil then
					bodyBytes[cursor + 0] = 0x29
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = 0x01
					if keyP["swingLRValue"] == keyB["BYTE_SWING_LR_ON"] then
						bodyBytes[cursor + 3] = 0x02
					end
					bodyBytes[cursor + 4] = 0x00
					cursor = cursor + 5
					bodyBytes[cursor + 0] = 0x2A
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = 0x01
					if keyP["swingLRValue"] == keyB["BYTE_SWING_LR_ON"] then
						bodyBytes[cursor + 3] = 0x02
					end
					bodyBytes[cursor + 4] = 0x00
					cursor = cursor + 5
				end
				if keyP["swingUDValue"] ~= nil then
					bodyBytes[cursor + 0] = 0x3A
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = 0x01
					if keyP["swingUDValue"] == keyB["BYTE_SWING_UD_ON"] then
						bodyBytes[cursor + 3] = 0x02
					end
					bodyBytes[cursor + 4] = 0x00
					cursor = cursor + 5
					bodyBytes[cursor + 0] = 0x3B
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = 0x01
					if keyP["swingUDValue"] == keyB["BYTE_SWING_UD_ON"] then
						bodyBytes[cursor + 3] = 0x02
					end
					bodyBytes[cursor + 4] = 0x00
					cursor = cursor + 5
				end
				if keyP["prevent_super_cool"] ~= nil then
					bodyBytes[cursor + 0] = 0x46
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["prevent_super_cool"]
					cursor = cursor + 4
				end
				if keyP["prevent_straight_wind"] ~= nil then
					if deviceSN8 == "12035" then
						bodyBytes[cursor + 0] = 0x43
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x01
						bodyBytes[cursor + 3] = 0x00
						if keyP["prevent_straight_wind"] == 2 then
							bodyBytes[cursor + 3] = 0x02
						elseif keyP["prevent_straight_wind"] == 1 then
							bodyBytes[cursor + 3] = 0x01
						end
						cursor = cursor + 4
					else
						bodyBytes[cursor + 0] = 0x42
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x01
						bodyBytes[cursor + 3] = keyP["prevent_straight_wind"]
						cursor = cursor + 4
					end
				end
				if keyP["self_clean"] ~= nil then
					bodyBytes[cursor + 0] = 0x27
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x04
					bodyBytes[cursor + 3] = keyP["self_clean"]
					bodyBytes[cursor + 4] = 0xFF
					bodyBytes[cursor + 5] = 0xFF
					bodyBytes[cursor + 6] = 0xFF
					cursor = cursor + 7
				end
				if keyP["no_wind_sense"] ~= nil then
					if deviceSN8 == "12035" then
						bodyBytes[cursor + 0] = 0x43
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x01
						bodyBytes[cursor + 3] = 0x00
						if keyP["no_wind_sense"] == 1 then
							bodyBytes[cursor + 3] = 0x04
						elseif keyP["no_wind_sense"] == 0 then
							bodyBytes[cursor + 3] = 0x01
						end
						cursor = cursor + 4
					else
						bodyBytes[cursor + 0] = 0x43
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x01
						if keyP["no_wind_sense"] == 1 then
							bodyBytes[cursor + 3] = 0x04
						elseif keyP["no_wind_sense"] == 0 then
							bodyBytes[cursor + 3] = 0x01
						end
						cursor = cursor + 4
					end
				end
				if keyP["child_prevent_cold_wind"] ~= nil then
					bodyBytes[cursor + 0] = 0x3A
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["child_prevent_cold_wind"]
					cursor = cursor + 4
				end
				if keyP["little_angel"] ~= nil then
					bodyBytes[cursor + 0] = 0x1B
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["little_angel"]
					cursor = cursor + 4
				end
				if keyP["cool_hot_sense"] ~= nil then
					bodyBytes[cursor + 0] = 0x21
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x08
					bodyBytes[cursor + 3] = keyP["cool_hot_sense"]
					bodyBytes[cursor + 4] = 0x00
					bodyBytes[cursor + 5] = 0x00
					bodyBytes[cursor + 6] = 0x00
					bodyBytes[cursor + 7] = 0x00
					bodyBytes[cursor + 8] = 0x00
					bodyBytes[cursor + 9] = 0x00
					bodyBytes[cursor + 10] = 0x00
					cursor = cursor + 11
				end
				if keyP["gentle_wind_sense"] ~= nil then
					bodyBytes[cursor + 0] = 0x43
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["gentle_wind_sense"]
					cursor = cursor + 4
				end
				if keyP["security"] ~= nil then
					bodyBytes[cursor + 0] = 0x29
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["security"]
					cursor = cursor + 4
				end
				if keyP["screen_display"] ~= nil then
					bodyBytes[cursor + 0] = 0x17
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["screen_display"]
					cursor = cursor + 4
				end
				if keyP["buzzerValue"] ~= nil then
					bodyBytes[cursor + 0] = 0x1A
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = 0x00
					if keyP["buzzerValue"] == 0x40 then
						bodyBytes[cursor + 3] = 0x01
					end
					cursor = cursor + 4
				end
				if keyP["strong_wind"] ~= nil then
					bodyBytes[cursor + 0] = 0x44
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["strong_wind"]
					cursor = cursor + 4
				end
				if keyP["light"] ~= nil then
					bodyBytes[cursor + 0] = 0x30
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x03
					bodyBytes[cursor + 3] = keyP["light"]
					bodyBytes[cursor + 4] = keyP["light_bright"]
					bodyBytes[cursor + 5] = keyP["light_air_level"]
					cursor = cursor + 6
				end
				if control["ptc"] ~= nil then
					bodyBytes[cursor + 0] = 0x0F
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["PTCValue"]
					cursor = cursor + 4
				end
				if control["up_control_wind"] ~= nil then
					bodyBytes[cursor + 0] = 0x2B
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = keyP["up_control_wind"]
					bodyBytes[cursor + 4] = keyP["up_control_wind_degree"]
					cursor = cursor + 5
				end
				if control["down_control_wind"] ~= nil then
					bodyBytes[cursor + 0] = 0x2C
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = keyP["down_control_wind"]
					bodyBytes[cursor + 4] = keyP["down_control_wind_degree"]
					cursor = cursor + 5
				end
				if control["purify_film"] ~= nil then
					bodyBytes[cursor + 0] = 0x28
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x03
					bodyBytes[cursor + 3] = keyP["purify_film"]
					bodyBytes[cursor + 4] = bit.band(keyP["purify_film_time"], 0xff)
					bodyBytes[cursor + 5] = bit.band(bit.rshift(keyP["purify_film_time"], 8), 0xff)
					cursor = cursor + 6
				end
				if control["wetfilm_state"] ~= nil then
					bodyBytes[cursor + 0] = 0x34
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x03
					bodyBytes[cursor + 3] = keyP["wetfilm_state"]
					bodyBytes[cursor + 4] = bit.band(keyP["wetfilm_state_time"], 0xff)
					bodyBytes[cursor + 5] = bit.band(bit.rshift(keyP["wetfilm_state_time"], 8), 0xff)
					cursor = cursor + 6
				end
				if control["acstrainer_state"] ~= nil then
					bodyBytes[cursor + 0] = 0x38
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x03
					bodyBytes[cursor + 3] = keyP["acstrainer_state"]
					bodyBytes[cursor + 4] = bit.band(keyP["acstrainer_state_time"], 0xff)
					bodyBytes[cursor + 5] = bit.band(bit.rshift(keyP["acstrainer_state_time"], 8), 0xff)
					cursor = cursor + 6
				end
				if control["get_weather"] ~= nil then
					bodyBytes[cursor + 0] = 0x37
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x03
					bodyBytes[cursor + 3] = keyP["get_weather"]
					bodyBytes[cursor + 4] = bit.band(keyP["outdoor_pm25"], 0xff)
					bodyBytes[cursor + 5] = bit.band(bit.rshift(keyP["outdoor_pm25"], 8), 0xff)
					cursor = cursor + 6
				end
				if control["near_switch"] ~= nil then
					bodyBytes[cursor + 0] = 0x39
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = keyP["near_switch"]
					bodyBytes[cursor + 4] = keyP["near_no_yes"]
					cursor = cursor + 5
				end
				if control["water_supply"] ~= nil then
					bodyBytes[cursor + 0] = 0x3E
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x03
					bodyBytes[cursor + 3] = keyP["water_supply"]
					bodyBytes[cursor + 4] = keyP["water_level"]
					bodyBytes[cursor + 5] = keyP["water_tank"]
					cursor = cursor + 6
				end
				if control["air_condition_temp"] ~= nil then
					bodyBytes[cursor + 0] = 0x3F
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x05
					bodyBytes[cursor + 3] = 0x01
					bodyBytes[cursor + 4] = keyP["air_condition_temp"]
					bodyBytes[cursor + 5] = keyP["air_condition_humidity"]
					bodyBytes[cursor + 6] = keyP["air_condition_clean"]
					bodyBytes[cursor + 7] = keyP["air_condition_fresh"]
					cursor = cursor + 8
				end
				if control["indoor_temp"] ~= nil then
					bodyBytes[cursor + 0] = 0x04
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = keyP["indoor_temp"]
					bodyBytes[cursor + 4] = keyP["indoor_temp_decimal"]
					cursor = cursor + 5
				end
				if control["outdoor_temp"] ~= nil then
					bodyBytes[cursor + 0] = 0x05
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = keyP["outdoor_temp"]
					bodyBytes[cursor + 4] = keyP["outdoor_temp_decimal"]
					cursor = cursor + 5
				end
				if control["eco_switch"] ~= nil then
					bodyBytes[cursor + 0] = 0x1E
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x04
					bodyBytes[cursor + 3] = keyP["eco_switch"]
					bodyBytes[cursor + 4] = keyP["eco_second"]
					bodyBytes[cursor + 5] = keyP["eco_min"]
					bodyBytes[cursor + 6] = keyP["eco_hour"]
					cursor = cursor + 7
				end
				if control["keep_warm_switch"] ~= nil then
					bodyBytes[cursor + 0] = 0x22
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = keyP["keep_warm_switch"]
					bodyBytes[cursor + 4] = keyP["keep_warm_temp"]
					cursor = cursor + 5
				end
				if control["close_screen"] ~= nil then
					bodyBytes[cursor + 0] = 0x01
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["close_screen"]
					cursor = cursor + 4
				end
				if control["exclusive_mode"] ~= nil then
					bodyBytes[cursor + 0] = 0x45
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["exclusive_mode"]
					cursor = cursor + 4
				end
				if control["family_number"] ~= nil then
					bodyBytes[cursor + 0] = 0x44
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["family_number"]
					cursor = cursor + 4
				end
				if control["light_class_switch"] ~= nil then
					bodyBytes[cursor + 0] = 0x23
					bodyBytes[cursor + 1] = 0x02
					bodyBytes[cursor + 2] = 0x02
					bodyBytes[cursor + 3] = keyP["light_class_switch"]
					bodyBytes[cursor + 4] = keyP["light_class"]
					cursor = cursor + 5
				end
				if control["intrusion"] ~= nil then
					bodyBytes[cursor + 0] = 0x2C
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["intrusion"]
					cursor = cursor + 4
				end
				if control["intrusion_video"] ~= nil then
					bodyBytes[cursor + 0] = 0x2D
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["intrusion_video"]
					cursor = cursor + 4
				end
				if keyP["voice_control_new"] ~= nil then
					bodyBytes[cursor + 0] = 0x20
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x14
					bodyBytes[cursor + 3] = keyP["voice_control_new"]
					bodyBytes[cursor + 4] = 0xFF
					bodyBytes[cursor + 5] = 0xFF
					bodyBytes[cursor + 6] = 0xFF
					bodyBytes[cursor + 7] = 0xFF
					bodyBytes[cursor + 8] = 0xFF
					bodyBytes[cursor + 9] = 0xFF
					bodyBytes[cursor + 10] = 0xFF
					bodyBytes[cursor + 11] = 0xFF
					bodyBytes[cursor + 12] = 0xFF
					bodyBytes[cursor + 13] = 0xFF
					bodyBytes[cursor + 14] = 0xFF
					bodyBytes[cursor + 15] = 0xFF
					bodyBytes[cursor + 16] = 0xFF
					bodyBytes[cursor + 17] = 0xFF
					bodyBytes[cursor + 18] = 0xFF
					bodyBytes[cursor + 19] = 0xFF
					bodyBytes[cursor + 20] = 0xFF
					bodyBytes[cursor + 21] = 0xFF
					bodyBytes[cursor + 22] = 0xFF
					cursor = cursor + 23
				end
				if keyP["wind_swing_ud_angle"] ~= nil then
					bodyBytes[cursor + 0] = 0x09
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["wind_swing_ud_angle"]
					cursor = cursor + 4
				end
				if keyP["wind_swing_lr_angle"] ~= nil then
					bodyBytes[cursor + 0] = 0x0A
					bodyBytes[cursor + 1] = 0x00
					bodyBytes[cursor + 2] = 0x01
					bodyBytes[cursor + 3] = keyP["wind_swing_lr_angle"]
					cursor = cursor + 4
				end
				if cmdOrder == "controlExclusiveMode" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlWindBlowClose" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlWisdomWind" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlWisdomWindNew" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlWindClose" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlWindBlow" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlWisdomWindFeeling" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlWisdomWindFeelingNew" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif order == "controlIntrusion" then
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "switchOneKeyCombination" then
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlWaitClean" then
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
				elseif cmdOrder == "controlTotalNoWindSense" then
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
				elseif cmdOrder == "controlRightNoWindSense" then
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
				elseif cmdOrder == "controlLeftNoWindSense" then
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
				elseif cmdOrder == "controlTotalPowerOff" then
					bodyBytes, cursor = handle_airoptimization(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_clean_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_remove_odor(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_inner_purifier(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_fresh_air(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_humidification(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wait_clean(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_swing_ud_left(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_no_wind_sense_right(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_dry(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_camera_direction_switch(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind_new(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_left_wind(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wind_blow_close(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_exclusive_mode(control, bodyBytes, cursor)
					bodyBytes, cursor = handle_wisdom_wind(control, bodyBytes, cursor)
				else
					bodyBytes, cursor = handle_one_key_ac(control, bodyBytes, cursor)
					if keyP["airoptimization"] ~= nil then
						bodyBytes[cursor + 0] = 0x26
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x01
						bodyBytes[cursor + 3] = keyP["airoptimization"]
						cursor = cursor + 4
					end
					if control["wind_swing_ud_left"] ~= nil then
						bodyBytes[cursor + 0] = 0x3B
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x02
						bodyBytes[cursor + 3] = keyP["wind_swing_ud_left"]
						bodyBytes[cursor + 4] = keyP["wind_swing_ud_left_degree"]
						cursor = cursor + 5
					end
					if control["wind_swing_ud_right"] ~= nil then
						bodyBytes[cursor + 0] = 0x3A
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x02
						bodyBytes[cursor + 3] = keyP["wind_swing_ud_right"]
						bodyBytes[cursor + 4] = keyP["wind_swing_ud_right_degree"]
						cursor = cursor + 5
					end
					if control["wind_swing_left"] ~= nil then
						bodyBytes[cursor + 0] = 0x29
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x02
						bodyBytes[cursor + 3] = keyP["wind_swing_left"]
						bodyBytes[cursor + 4] = keyP["wind_swing_left_degree"]
						cursor = cursor + 5
					end
					if control["camera_direction_switch"] ~= nil then
						bodyBytes[cursor + 0] = 0x56
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x06
						bodyBytes[cursor + 3] = keyP["camera_direction_state"]
						bodyBytes[cursor + 4] = keyP["camera_direction_switch"]
						bodyBytes[cursor + 5] = bit.band(keyP["camera_direction_left"], 0xff)
						bodyBytes[cursor + 6] = bit.band(bit.rshift(keyP["camera_direction_left"], 8), 0xff)
						bodyBytes[cursor + 7] = bit.band(keyP["camera_direction_right"], 0xff)
						bodyBytes[cursor + 8] = bit.band(bit.rshift(keyP["camera_direction_right"], 8), 0xff)
						cursor = cursor + 9
					end
					if control["wind_blow_close"] ~= nil then
						bodyBytes[cursor + 0] = 0x32
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x01
						bodyBytes[cursor + 3] = keyP["wind_blow_close"]
						cursor = cursor + 4
					end
					if control["wisdom_wind"] ~= nil then
						bodyBytes[cursor + 0] = 0x33
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x01
						bodyBytes[cursor + 3] = keyP["wisdom_wind"]
						cursor = cursor + 4
					end
					if control["wisdom_wind_new"] ~= nil then
						bodyBytes[cursor + 0] = 0x53
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x0D
						bodyBytes[cursor + 3] = keyP["wisdom_wind_new"]
						bodyBytes[cursor + 4] = keyP["wisdom_left_distance"]
						bodyBytes[cursor + 5] = keyP["wisdom_right_distance"]
						bodyBytes[cursor + 6] = keyP["wisdom_left_set_wind"]
						bodyBytes[cursor + 7] = keyP["wisdom_right_set_wind"]
						bodyBytes[cursor + 8] = bit.band(keyP["wisdom_left_down_angle"], 0xff)
						bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["wisdom_left_down_angle"], 8), 0xff)
						bodyBytes[cursor + 10] = bit.band(keyP["wisdom_right_down_angle"], 0xff)
						bodyBytes[cursor + 11] = bit.band(bit.rshift(keyP["wisdom_right_down_angle"], 8), 0xff)
						bodyBytes[cursor + 12] = bit.band(keyP["wisdom_left_up_angle"], 0xff)
						bodyBytes[cursor + 13] = bit.band(bit.rshift(keyP["wisdom_left_up_angle"], 8), 0xff)
						bodyBytes[cursor + 14] = bit.band(keyP["wisdom_right_up_angle"], 0xff)
						bodyBytes[cursor + 15] = bit.band(bit.rshift(keyP["wisdom_right_up_angle"], 8), 0xff)
						cursor = cursor + 16
					end
					if control["wind_blow"] ~= nil then
						bodyBytes[cursor + 0] = 0x54
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x0B
						bodyBytes[cursor + 3] = keyP["wind_blow"]
						bodyBytes[cursor + 4] = keyP["wind_blow_left_distance"]
						bodyBytes[cursor + 5] = keyP["wind_blow_right_distance"]
						bodyBytes[cursor + 6] = bit.band(keyP["wind_blow_left_down_angle"], 0xff)
						bodyBytes[cursor + 7] = bit.band(bit.rshift(keyP["wind_blow_left_down_angle"], 8), 0xff)
						bodyBytes[cursor + 8] = bit.band(keyP["wind_blow_right_down_angle"], 0xff)
						bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["wind_blow_right_down_angle"], 8), 0xff)
						bodyBytes[cursor + 10] = bit.band(keyP["wind_blow_left_up_angle"], 0xff)
						bodyBytes[cursor + 11] = bit.band(bit.rshift(keyP["wind_blow_left_up_angle"], 8), 0xff)
						bodyBytes[cursor + 12] = bit.band(keyP["wind_blow_right_up_angle"], 0xff)
						bodyBytes[cursor + 13] = bit.band(bit.rshift(keyP["wind_blow_right_up_angle"], 8), 0xff)
						cursor = cursor + 14
					end
					if control["wind_close"] ~= nil then
						bodyBytes[cursor + 0] = 0x55
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x0B
						bodyBytes[cursor + 3] = keyP["wind_close"]
						bodyBytes[cursor + 4] = keyP["wind_close_left_distance"]
						bodyBytes[cursor + 5] = keyP["wind_close_right_distance"]
						bodyBytes[cursor + 6] = bit.band(keyP["wind_close_left_down_angle"], 0xff)
						bodyBytes[cursor + 7] = bit.band(bit.rshift(keyP["wind_close_left_down_angle"], 8), 0xff)
						bodyBytes[cursor + 8] = bit.band(keyP["wind_close_right_down_angle"], 0xff)
						bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["wind_close_right_down_angle"], 8), 0xff)
						bodyBytes[cursor + 10] = bit.band(keyP["wind_close_left_up_angle"], 0xff)
						bodyBytes[cursor + 11] = bit.band(bit.rshift(keyP["wind_close_left_up_angle"], 8), 0xff)
						bodyBytes[cursor + 12] = bit.band(keyP["wind_close_right_up_angle"], 0xff)
						bodyBytes[cursor + 13] = bit.band(bit.rshift(keyP["wind_close_right_up_angle"], 8), 0xff)
						cursor = cursor + 14
					end
					if control["left_wind"] ~= nil or control["right_wind"] ~= nil then
						bodyBytes[cursor + 0] = 0x36
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x02
						bodyBytes[cursor + 3] = keyP["left_wind"]
						bodyBytes[cursor + 4] = keyP["right_wind"]
						cursor = cursor + 5
					end
					if keyP["inner_purifier"] ~= nil or keyP["down_wind_speed"] ~= nil then
						bodyBytes[cursor + 0] = 0x32
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x09
						bodyBytes[cursor + 3] = keyP["inner_purifier"]
						bodyBytes[cursor + 4] = keyP["inner_purifier_fan_speed"]
						bodyBytes[cursor + 5] = keyP["inner_purifier_mode"]
						bodyBytes[cursor + 6] = bit.band(keyP["inner_purifier_on_pm"], 0xff)
						bodyBytes[cursor + 7] = bit.band(bit.rshift(keyP["inner_purifier_on_pm"], 8), 0xff)
						bodyBytes[cursor + 8] = bit.band(keyP["inner_purifier_off_pm"], 0xff)
						bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["inner_purifier_off_pm"], 8), 0xff)
						bodyBytes[cursor + 10] = bit.band(keyP["inner_purifier_current_pm"], 0xff)
						bodyBytes[cursor + 11] = bit.band(bit.rshift(keyP["inner_purifier_current_pm"], 8), 0xff)
						cursor = cursor + 12
					end
					if keyP["fresh_air"] ~= nil or keyP["down_wind_speed"] ~= nil then
						bodyBytes[cursor + 0] = 0x33
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x0A
						bodyBytes[cursor + 3] = keyP["fresh_air"]
						bodyBytes[cursor + 4] = keyP["fresh_air_fan_speed"]
						bodyBytes[cursor + 5] = keyP["fresh_air_mode"]
						bodyBytes[cursor + 6] = keyP["fresh_air_mode_2"]
						bodyBytes[cursor + 7] = bit.band(keyP["fresh_air_on_co2"], 0xff)
						bodyBytes[cursor + 8] = bit.band(bit.rshift(keyP["fresh_air_on_co2"], 8), 0xff)
						bodyBytes[cursor + 9] = bit.band(keyP["fresh_air_off_co2"], 0xff)
						bodyBytes[cursor + 10] = bit.band(bit.rshift(keyP["fresh_air_off_co2"], 8), 0xff)
						bodyBytes[cursor + 11] = bit.band(keyP["fresh_air_current_co2"], 0xff)
						bodyBytes[cursor + 12] = bit.band(bit.rshift(keyP["fresh_air_current_co2"], 8), 0xff)
						cursor = cursor + 13
					end
					if keyP["humidification"] ~= nil or keyP["down_wind_speed"] ~= nil then
						bodyBytes[cursor + 0] = 0x35
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x07
						bodyBytes[cursor + 3] = keyP["humidification"]
						bodyBytes[cursor + 4] = keyP["humidification_fan_speed"]
						bodyBytes[cursor + 5] = keyP["humidification_mode"]
						bodyBytes[cursor + 6] = keyP["humidification_auto_on"]
						bodyBytes[cursor + 7] = keyP["humidification_auto_off"]
						bodyBytes[cursor + 8] = keyP["humidification_manual"]
						bodyBytes[cursor + 9] = keyP["humidification_current"]
						cursor = cursor + 10
					end
					if keyP["remove_odor"] ~= nil or keyP["down_wind_speed"] ~= nil then
						bodyBytes[cursor + 0] = 0x31
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x07
						bodyBytes[cursor + 3] = keyP["remove_odor"]
						bodyBytes[cursor + 4] = keyP["remove_odor_fan_speed"]
						bodyBytes[cursor + 5] = keyP["remove_odor_mode"]
						bodyBytes[cursor + 6] = bit.band(keyP["remove_odor_time"], 0xff)
						bodyBytes[cursor + 7] = bit.band(bit.rshift(keyP["remove_odor_time"], 8), 0xff)
						bodyBytes[cursor + 8] = bit.band(keyP["remove_odor_operating_time"], 0xff)
						bodyBytes[cursor + 9] = bit.band(bit.rshift(keyP["remove_odor_operating_time"], 8), 0xff)
						cursor = cursor + 10
					end
					if control["clean_switch"] ~= nil then
						bodyBytes[cursor + 0] = 0x27
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x04
						bodyBytes[cursor + 3] = keyP["clean_switch"]
						bodyBytes[cursor + 4] = keyP["clean_running_stage"]
						bodyBytes[cursor + 5] = keyP["clean_running_time"]
						bodyBytes[cursor + 6] = keyP["clean_target_time"]
						cursor = cursor + 7
					end
					if keyP["dryValue"] ~= nil then
						bodyBytes[cursor + 0] = 0x10
						bodyBytes[cursor + 1] = 0x00
						bodyBytes[cursor + 2] = 0x01
						bodyBytes[cursor + 3] = keyP["dryValue"]
						cursor = cursor + 4
					end
					if control["wait_clean"] ~= nil then
						bodyBytes[cursor + 0] = 0x46
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x01
						bodyBytes[cursor + 3] = keyP["wait_clean"]
						cursor = cursor + 4
					end
					if keyP["no_wind_sense_left"] ~= nil then
						bodyBytes[cursor + 0] = 0x2D
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x02
						bodyBytes[cursor + 3] = keyP["no_wind_sense_left"]
						bodyBytes[cursor + 4] = keyP["left_profile"]
						cursor = cursor + 5
					end
					if keyP["no_wind_sense_right"] ~= nil then
						bodyBytes[cursor + 0] = 0x2E
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x02
						bodyBytes[cursor + 3] = keyP["no_wind_sense_right"]
						bodyBytes[cursor + 4] = keyP["right_profile"]
						cursor = cursor + 5
					end
					if control["wind_swing_right"] ~= nil then
						bodyBytes[cursor + 0] = 0x2A
						bodyBytes[cursor + 1] = 0x02
						bodyBytes[cursor + 2] = 0x02
						bodyBytes[cursor + 3] = keyP["wind_swing_right"]
						bodyBytes[cursor + 4] = keyP["wind_swing_right_degree"]
						cursor = cursor + 5
					end
				end
				math.randomseed(tostring(os.time() * #bodyBytes):reverse():sub(1, 7))
				math.random()
				bodyBytes[cursor] = 5
				bodyBytes[cursor + 1] = crc8_854(bodyBytes, 0, cursor)
			end
		end
		infoM = getTotalMsg(bodyBytes, keyB["BYTE_CONTROL_REQUEST"])
	end
	init_property_value()
	noWindSencePre = nil
	propertyPre = nil
	local ret = table2string(infoM)
	ret = string2hexstring(ret)
	return ret
end
function dataToJson(jsonCmd)
	if not jsonCmd then
		return nil
	end
	init_property_value()
	local json = decode(jsonCmd)
	local deviceinfo = json["deviceinfo"]
	deviceSubType = deviceinfo["deviceSubType"]
	local deviceSN = json["deviceinfo"]["deviceSN"]
	if deviceSN ~= nil then
		deviceSN8 = string.sub(deviceSN, 4, 8)
	end
	local status = json["status"]
	if status then
		jsonToModel(status, "status")
	end
	local binData = json["msg"]["data"]
	local info = {}
	local msgBytes = {}
	local bodyBytes = {}
	local msgLength = 0
	local bodyLength = 0
	info = string2table(binData)
	dataType = info[10]
	for i = 1, #info do
		msgBytes[i - 1] = info[i]
	end
	msgLength = msgBytes[1]
	bodyLength = msgLength - keyB["BYTE_PROTOCOL_LENGTH"] - 1
	for i = 0, bodyLength do
		bodyBytes[i] = msgBytes[i + keyB["BYTE_PROTOCOL_LENGTH"]]
	end
	binToModel(bodyBytes)
	local streams = {}
	streams[keyT["KEY_VERSION"]] = keyV["VALUE_VERSION"]
	if keyP["powerValue"] ~= nil then
		if keyP["powerValue"] == keyB["BYTE_POWER_ON"] then
			streams[keyT["KEY_POWER"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["powerValue"] == keyB["BYTE_POWER_OFF"] then
			streams[keyT["KEY_POWER"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["modeValue"] ~= nil then
		if keyP["modeValue"] == keyB["BYTE_MODE_HEAT"] then
			streams[keyT["KEY_MODE"]] = keyV["VALUE_MODE_HEAT"]
		elseif keyP["modeValue"] == keyB["BYTE_MODE_COOL"] then
			streams[keyT["KEY_MODE"]] = keyV["VALUE_MODE_COOL"]
		elseif keyP["modeValue"] == keyB["BYTE_MODE_AUTO"] then
			streams[keyT["KEY_MODE"]] = keyV["VALUE_MODE_AUTO"]
		elseif keyP["modeValue"] == keyB["BYTE_MODE_DRY"] then
			streams[keyT["KEY_MODE"]] = keyV["VALUE_MODE_DRY"]
		elseif keyP["modeValue"] == keyB["BYTE_MODE_FAN"] then
			streams[keyT["KEY_MODE"]] = keyV["VALUE_MODE_FAN"]
		end
	end
	if keyP["purifierValue"] ~= nil then
		if keyP["purifierValue"] == keyB["BYTE_PURIFIER_ON"] then
			streams[keyT["KEY_PURIFIER"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["purifierValue"] == keyB["BYTE_PURIFIER_OFF"] then
			streams[keyT["KEY_PURIFIER"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["ecoValue"] ~= nil then
		if keyP["ecoValue"] == keyB["BYTE_ECO_ON"] then
			streams[keyT["KEY_ECO"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["ecoValue"] == keyB["BYTE_ECO_OFF"] then
			streams[keyT["KEY_ECO"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["dryValue"] ~= nil then
		if keyP["dryValue"] == 0x01 or keyP["dryValue"] == 0x04 then
			streams[keyT["KEY_DRY"]] = keyV["VALUE_FUNCTION_ON"]
		else
			streams[keyT["KEY_DRY"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["wind_speed_left"] ~= nil then
		streams["wind_speed_left"] = keyP["wind_speed_left"]
	end
	if keyP["wind_speed_right"] ~= nil then
		streams["wind_speed_right"] = keyP["wind_speed_right"]
	end
	if keyP["fanspeedValue"] ~= nil then
		if keyP["fanspeedValue"] == 101 then
			keyP["fanspeedValue"] = 102
		end
		streams[keyT["KEY_FANSPEED"]] = keyP["fanspeedValue"]
	end
	if keyP["outdoorTemperatureValue"] ~= nil and keyP["smallOutdoorTemperatureValue"] ~= nil then
		streams[keyV["VALUE_OUTDOOR_TEMPERATURE"]] = keyP["outdoorTemperatureValue"]
			+ keyP["smallOutdoorTemperatureValue"] / 10
	end
	if (keyP["indoorTemperatureValue"] ~= nil) and (keyP["smallIndoorTemperatureValue"] ~= nil) then
		streams[keyV["VALUE_INDOOR_TEMPERATURE"]] = keyP["indoorTemperatureValue"]
			+ keyP["smallIndoorTemperatureValue"] / 10
	end
	if keyP["swingUDValue"] ~= nil then
		if keyP["swingUDValue"] == keyB["BYTE_SWING_UD_ON"] then
			streams[keyT["KEY_SWING_UD"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["swingUDValue"] == keyB["BYTE_SWING_UD_OFF"] then
			streams[keyT["KEY_SWING_UD"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["swingLRValue"] ~= nil then
		if keyP["swingLRValue"] == keyB["BYTE_SWING_LR_ON"] then
			streams[keyT["KEY_SWING_LR"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["swingLRValue"] == keyB["BYTE_SWING_LR_OFF"] then
			streams[keyT["KEY_SWING_LR"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["swingLRUnderSwitch"] == keyB["BYTE_SWING_LR_UNDER_ENABLE"] then
			if keyP["swingLRValueUnder"] == keyB["BYTE_SWING_LR_UNDER_ON"] then
				streams[keyT["KEY_SWING_LR_UNDER"]] = keyV["VALUE_FUNCTION_ON"]
			elseif keyP["swingLRValueUnder"] == keyB["BYTE_SWING_LR_UNDER_OFF"] then
				streams[keyT["KEY_SWING_LR_UNDER"]] = keyV["VALUE_FUNCTION_OFF"]
			end
		else
			streams[keyT["KEY_SWING_LR_UNDER"]] = streams[keyT["KEY_SWING_LR"]]
		end
	end
	if keyP["PTCValue"] ~= nil then
		if keyP["PTCValue"] == 0x01 or keyP["PTCValue"] == 0x08 then
			streams[keyT["KEY_PTC"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["PTCValue"] == 0x00 then
			streams[keyT["KEY_PTC"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["openTimerSwitch"] ~= nil then
		if keyP["openTimerSwitch"] == keyB["BYTE_START_TIMER_SWITCH_ON"] then
			streams[keyT["KEY_TIME_ON"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["openTimerSwitch"] == keyB["BYTE_START_TIMER_SWITCH_OFF"] then
			streams[keyT["KEY_TIME_ON"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["closeTimerSwitch"] ~= nil then
		if keyP["closeTimerSwitch"] == keyB["BYTE_CLOSE_TIMER_SWITCH_ON"] then
			streams[keyT["KEY_TIME_OFF"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["closeTimerSwitch"] == keyB["BYTE_CLOSE_TIMER_SWITCH_OFF"] then
			streams[keyT["KEY_TIME_OFF"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["closeTimerSwitch"] ~= nil then
		if keyP["closeTimerSwitch"] == keyB["BYTE_CLOSE_TIMER_SWITCH_OFF"] then
			streams[keyT["KEY_CLOSE_TIME"]] = 0
		else
			streams[keyT["KEY_CLOSE_TIME"]] = keyP["closeTime"]
		end
	end
	if keyP["openTimerSwitch"] ~= nil then
		if keyP["openTimerSwitch"] == keyB["BYTE_START_TIMER_SWITCH_OFF"] then
			streams[keyT["KEY_OPEN_TIME"]] = 0
		else
			streams[keyT["KEY_OPEN_TIME"]] = keyP["openTime"]
		end
	end
	if keyP["currentWorkTime"] ~= nil then
		streams[keyT["KEY_CURRENT_WORK_TIME"]] = keyP["currentWorkTime"]
	end
	if keyP["strong_wind"] ~= nil then
		if keyP["strong_wind"] == 0x01 or keyP["strong_wind"] == 0x20 then
			streams[keyT["KEY_STRONG_WIND"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["strong_wind"] == 0x00 then
			streams[keyT["KEY_STRONG_WIND"]] = keyV["VALUE_FUNCTION_OFF"]
		end
	end
	if keyP["temperature"] ~= nil then
		streams[keyT["KEY_TEMPERATURE"]] = keyP["temperature"]
	end
	if keyP["smallTemperature"] ~= nil then
		if keyP["smallTemperature"] == 0x01 then
			streams["small_temperature"] = 0.5
		else
			streams["small_temperature"] = 0
		end
	end
	streams[keyT["KEY_ERROR_CODE"]] = keyP["errorCode"]
	if keyP["kickQuilt"] ~= nil then
		if keyP["kickQuilt"] == 0x00 then
			streams["kick_quilt"] = "off"
		elseif keyP["kickQuilt"] == 0x01 then
			streams["kick_quilt"] = "on"
		end
	end
	if keyP["comfortPowerSave"] ~= nil then
		if keyP["comfortPowerSave"] == 0x00 then
			streams["comfort_power_save"] = "off"
		elseif keyP["comfortPowerSave"] == 0x01 then
			streams["comfort_power_save"] = "on"
		end
	end
	if keyP["no_wind_sense"] ~= nil then
		streams["no_wind_sense"] = keyP["no_wind_sense"]
	end
	if keyP["preventCold"] ~= nil then
		if keyP["preventCold"] == 0x00 then
			streams["prevent_cold"] = "off"
		elseif keyP["preventCold"] == 0x01 then
			streams["prevent_cold"] = "on"
		end
	end
	if keyP["current_run_mode"] ~= nil then
		streams["current_run_mode"] = keyP["current_run_mode"]
	end
	if keyP["prevent_super_cool"] ~= nil then
		if keyP["prevent_super_cool"] == 0x00 then
			streams["prevent_super_cool"] = "off"
		elseif keyP["prevent_super_cool"] == 0x01 then
			streams["prevent_super_cool"] = "on"
		end
	end
	if keyP["prevent_straight_wind"] ~= nil then
		streams["prevent_straight_wind"] = keyP["prevent_straight_wind"]
	end
	if keyP["airoptimization"] ~= nil then
		if keyP["airoptimization"] == 0x01 then
			streams["airoptimization"] = "off"
		elseif keyP["airoptimization"] == 0x02 then
			streams["airoptimization"] = "on"
		end
	end
	if keyP["self_clean"] ~= nil then
		if keyP["self_clean"] == 0x01 then
			streams["self_clean"] = "off"
		elseif keyP["self_clean"] == 0x02 then
			streams["self_clean"] = "on"
		end
	end
	if keyP["child_prevent_cold_wind"] ~= nil then
		if keyP["child_prevent_cold_wind"] == 0x00 then
			streams["child_prevent_cold_wind"] = "off"
		elseif keyP["child_prevent_cold_wind"] == 0x01 then
			streams["child_prevent_cold_wind"] = "on"
		end
	end
	if keyP["no_wind_sense"] ~= nil then
		streams["no_wind_sense"] = keyP["no_wind_sense"]
	end
	if keyP["little_angel"] ~= nil then
		if keyP["little_angel"] == 0x00 then
			streams["little_angel"] = "off"
		elseif keyP["little_angel"] == 0x01 then
			streams["little_angel"] = "on"
		end
	end
	if keyP["cool_hot_sense"] ~= nil then
		if keyP["cool_hot_sense"] == 0x00 then
			streams["cool_hot_sense"] = "off"
		elseif keyP["cool_hot_sense"] == 0x01 then
			streams["cool_hot_sense"] = "on"
		end
	end
	if keyP["gentle_wind_sense"] ~= nil then
		if keyP["gentle_wind_sense"] == 0x01 then
			streams["gentle_wind_sense"] = "off"
		elseif keyP["gentle_wind_sense"] == 0x03 then
			streams["gentle_wind_sense"] = "on"
		end
	end
	if keyP["screen_display"] ~= nil then
		if keyP["screen_display"] == 0x64 then
			streams["screen_display"] = "on"
		elseif keyP["screen_display"] == 0x00 then
			streams["screen_display"] = "off"
		end
	end
	if keyP["security"] ~= nil then
		if keyP["security"] == 0x00 then
			streams["security"] = "off"
		elseif keyP["security"] == 0x01 then
			streams["security"] = "on"
		end
	end
	if keyP["sceneId"] ~= nil then
		streams["sceneId"] = keyP["sceneId"]
	end
	if keyP["targetLWindSpeed"] ~= nil then
		streams["targetLWindSpeed"] = keyP["targetLWindSpeed"]
	end
	if keyP["targetRWindSpeed"] ~= nil then
		streams["targetRWindSpeed"] = keyP["targetRWindSpeed"]
	end
	if keyP["fresh_air"] ~= nil then
		if keyP["fresh_air"] == 0x01 then
			streams["fresh_air"] = "off"
		elseif keyP["fresh_air"] == 0x02 then
			streams["fresh_air"] = "on"
		end
		streams["fresh_air_fan_speed"] = keyP["fresh_air_fan_speed"]
		streams["fresh_air_mode"] = keyP["fresh_air_mode"]
		streams["fresh_air_mode_2"] = keyP["fresh_air_mode_2"]
		streams["fresh_air_on_co2"] = keyP["fresh_air_on_co2"]
		streams["fresh_air_off_co2"] = keyP["fresh_air_off_co2"]
		streams["fresh_air_current_co2"] = keyP["fresh_air_current_co2"]
	end
	if keyP["remove_odor"] ~= nil then
		if keyP["remove_odor"] == 0x01 then
			streams["remove_odor"] = "off"
		elseif keyP["remove_odor"] == 0x02 then
			streams["remove_odor"] = "on"
		end
		streams["remove_odor_fan_speed"] = keyP["remove_odor_fan_speed"]
		streams["remove_odor_mode"] = keyP["remove_odor_mode"]
		streams["remove_odor_time"] = keyP["remove_odor_time"]
		streams["remove_odor_operating_time"] = keyP["remove_odor_operating_time"]
	end
	if keyP["inner_purifier"] ~= nil then
		if keyP["inner_purifier"] == 0x01 then
			streams["inner_purifier"] = "off"
		elseif keyP["inner_purifier"] == 0x02 then
			streams["inner_purifier"] = "on"
		end
		streams["inner_purifier_fan_speed"] = keyP["inner_purifier_fan_speed"]
		streams["inner_purifier_mode"] = keyP["inner_purifier_mode"]
		streams["inner_purifier_on_pm"] = keyP["inner_purifier_on_pm"]
		streams["inner_purifier_off_pm"] = keyP["inner_purifier_off_pm"]
		streams["inner_purifier_current_pm"] = keyP["inner_purifier_current_pm"]
	end
	if keyP["humidification"] ~= nil then
		if keyP["humidification"] == 0x01 then
			streams["humidification"] = "off"
		elseif keyP["humidification"] == 0x02 then
			streams["humidification"] = "on"
		end
		streams["humidification_fan_speed"] = keyP["humidification_fan_speed"]
		streams["humidification_mode"] = keyP["humidification_mode"]
		streams["humidification_auto_on"] = keyP["humidification_auto_on"]
		streams["humidification_auto_off"] = keyP["humidification_auto_off"]
		streams["humidification_manual"] = keyP["humidification_manual"]
		streams["humidification_current"] = keyP["humidification_current"]
	end
	if keyP["no_wind_sense_left"] ~= nil then
		if keyP["no_wind_sense_left"] == 0x01 then
			streams["no_wind_sense_left"] = "off"
		elseif keyP["no_wind_sense_left"] == 0x02 then
			streams["no_wind_sense_left"] = "on"
		end
		streams["left_profile"] = keyP["left_profile"]
	end
	if keyP["no_wind_sense_right"] ~= nil then
		if keyP["no_wind_sense_right"] == 0x01 then
			streams["no_wind_sense_right"] = "off"
		elseif keyP["no_wind_sense_right"] == 0x02 then
			streams["no_wind_sense_right"] = "on"
		end
		streams["right_profile"] = keyP["right_profile"]
	end
	if keyP["light"] ~= nil then
		if keyP["light"] == 0x01 then
			streams["light"] = "off"
		elseif keyP["light"] == 0x02 then
			streams["light"] = "on"
		end
		streams["light_bright"] = keyP["light_bright"]
		streams["light_air_level"] = keyP["light_air_level"]
	end
	if keyP["down_wind_speed"] ~= nil then
		streams["down_wind_speed"] = keyP["down_wind_speed"]
	end
	if keyP["up_control_wind"] ~= nil then
		if keyP["up_control_wind"] == 0x01 then
			streams["up_control_wind"] = "off"
		elseif keyP["up_control_wind"] == 0x02 then
			streams["up_control_wind"] = "on"
		end
		streams["up_control_wind_degree"] = keyP["up_control_wind_degree"]
	end
	if keyP["down_control_wind"] ~= nil then
		if keyP["down_control_wind"] == 0x01 then
			streams["down_control_wind"] = "off"
		elseif keyP["down_control_wind"] == 0x02 then
			streams["down_control_wind"] = "on"
		end
		streams["down_control_wind_degree"] = keyP["down_control_wind_degree"]
	end
	if keyP["wait_clean"] ~= nil then
		if keyP["wait_clean"] == 0x00 then
			streams["wait_clean"] = "off"
		elseif keyP["wait_clean"] == 0x01 then
			streams["wait_clean"] = "on"
		end
	end
	if keyP["left_wind"] ~= nil then
		streams["left_wind"] = keyP["left_wind"]
	end
	if keyP["right_wind"] ~= nil then
		streams["right_wind"] = keyP["right_wind"]
	end
	if keyP["purify_film"] ~= nil then
		streams["purify_film"] = keyP["purify_film"]
	end
	if keyP["purify_film_time"] ~= nil then
		streams["purify_film_time"] = keyP["purify_film_time"]
	end
	if keyP["purify_film_total_time"] ~= nil then
		streams["purify_film_total_time"] = keyP["purify_film_total_time"]
	end
	if keyP["wetfilm_state"] ~= nil then
		streams["wetfilm_state"] = keyP["wetfilm_state"]
	end
	if keyP["wetfilm_state_time"] ~= nil then
		streams["wetfilm_state_time"] = keyP["wetfilm_state_time"]
	end
	if keyP["wetfilm_state_total_time"] ~= nil then
		streams["wetfilm_state_total_time"] = keyP["wetfilm_state_total_time"]
	end
	if keyP["acstrainer_state"] ~= nil then
		streams["acstrainer_state"] = keyP["acstrainer_state"]
	end
	if keyP["acstrainer_state_time"] ~= nil then
		streams["acstrainer_state_time"] = keyP["acstrainer_state_time"]
	end
	if keyP["acstrainer_state_total_time"] ~= nil then
		streams["acstrainer_state_total_time"] = keyP["acstrainer_state_total_time"]
	end
	if keyP["get_weather"] ~= nil then
		streams["get_weather"] = keyP["get_weather"]
	end
	if keyP["outdoor_pm25"] ~= nil then
		streams["outdoor_pm25"] = keyP["outdoor_pm25"]
	end
	if keyP["near_switch"] ~= nil then
		streams["near_switch"] = keyP["near_switch"]
	end
	if keyP["near_no_yes"] ~= nil then
		streams["near_no_yes"] = keyP["near_no_yes"]
	end
	if keyP["water_supply"] ~= nil then
		streams["water_supply"] = keyP["water_supply"]
	end
	if keyP["water_level"] ~= nil then
		streams["water_level"] = keyP["water_level"]
	end
	if keyP["water_tank"] ~= nil then
		streams["water_tank"] = keyP["water_tank"]
	end
	if keyP["air_condition_temp"] ~= nil then
		streams["air_condition_temp"] = keyP["air_condition_temp"]
	end
	if keyP["air_condition_humidity"] ~= nil then
		streams["air_condition_humidity"] = keyP["air_condition_humidity"]
	end
	if keyP["air_condition_clean"] ~= nil then
		streams["air_condition_clean"] = keyP["air_condition_clean"]
	end
	if keyP["air_condition_fresh"] ~= nil then
		streams["air_condition_fresh"] = keyP["air_condition_fresh"]
	end
	if keyP["indoor_temp"] ~= nil then
		streams["indoor_temp"] = keyP["indoor_temp"]
	end
	if keyP["indoor_temp_decimal"] ~= nil then
		streams["indoor_temp_decimal"] = keyP["indoor_temp_decimal"]
	end
	if keyP["outdoor_temp"] ~= nil then
		streams["outdoor_temp"] = keyP["outdoor_temp"]
	end
	if keyP["outdoor_temp_decimal"] ~= nil then
		streams["outdoor_temp_decimal"] = keyP["outdoor_temp_decimal"]
	end
	if keyP["eco_switch"] ~= nil then
		streams["eco_switch"] = keyP["eco_switch"]
	end
	if keyP["eco_second"] ~= nil then
		streams["eco_second"] = keyP["eco_second"]
	end
	if keyP["eco_min"] ~= nil then
		streams["eco_min"] = keyP["eco_min"]
	end
	if keyP["eco_hour"] ~= nil then
		streams["eco_hour"] = keyP["eco_hour"]
	end
	if keyP["keep_warm_switch"] ~= nil then
		streams["keep_warm_switch"] = keyP["keep_warm_switch"]
	end
	if keyP["keep_warm_temp"] ~= nil then
		streams["keep_warm_temp"] = keyP["keep_warm_temp"]
	end
	if keyP["close_screen"] ~= nil then
		streams["close_screen"] = keyP["close_screen"]
	end
	if keyP["exclusive_mode"] ~= nil then
		streams["exclusive_mode"] = keyP["exclusive_mode"]
	end
	if keyP["family_number"] ~= nil then
		streams["family_number"] = keyP["family_number"]
	end
	if keyP["wind_blow_close"] ~= nil then
		streams["wind_blow_close"] = keyP["wind_blow_close"]
	end
	if keyP["wisdom_wind"] ~= nil then
		streams["wisdom_wind"] = keyP["wisdom_wind"]
	end
	if keyP["wisdom_wind_new"] ~= nil then
		streams["wisdom_wind_new"] = keyP["wisdom_wind_new"]
		streams["wisdom_left_distance"] = keyP["wisdom_left_distance"]
		streams["wisdom_right_distance"] = keyP["wisdom_right_distance"]
		streams["wisdom_left_set_wind"] = keyP["wisdom_left_set_wind"]
		streams["wisdom_right_set_wind"] = keyP["wisdom_right_set_wind"]
		streams["wisdom_left_down_angle"] = keyP["wisdom_left_down_angle"]
		streams["wisdom_right_down_angle"] = keyP["wisdom_right_down_angle"]
		streams["wisdom_left_up_angle"] = keyP["wisdom_left_up_angle"]
		streams["wisdom_right_up_angle"] = keyP["wisdom_right_up_angle"]
	end
	if keyP["wind_blow"] ~= nil then
		streams["wind_blow"] = keyP["wind_blow"]
		streams["wind_blow_left_distance"] = keyP["wind_blow_left_distance"]
		streams["wind_blow_right_distance"] = keyP["wind_blow_right_distance"]
		streams["wind_blow_left_down_angle"] = keyP["wind_blow_left_down_angle"]
		streams["wind_blow_right_down_angle"] = keyP["wind_blow_right_down_angle"]
		streams["wind_blow_left_up_angle"] = keyP["wind_blow_left_up_angle"]
		streams["wind_blow_right_up_angle"] = keyP["wind_blow_right_up_angle"]
	end
	if keyP["wind_close"] ~= nil then
		streams["wind_close"] = keyP["wind_close"]
		streams["wind_close_left_distance"] = keyP["wind_close_left_distance"]
		streams["wind_close_right_distance"] = keyP["wind_close_right_distance"]
		streams["wind_close_left_down_angle"] = keyP["wind_close_left_down_angle"]
		streams["wind_close_right_down_angle"] = keyP["wind_close_right_down_angle"]
		streams["wind_close_left_up_angle"] = keyP["wind_close_left_up_angle"]
		streams["wind_close_right_up_angle"] = keyP["wind_close_right_up_angle"]
	end
	if keyP["camera_direction_state"] ~= nil then
		streams["camera_direction_state"] = keyP["camera_direction_state"]
	end
	if keyP["camera_direction_switch"] ~= nil then
		streams["camera_direction_switch"] = keyP["camera_direction_switch"]
	end
	if keyP["camera_direction_left"] ~= nil then
		streams["camera_direction_left"] = keyP["camera_direction_left"]
	end
	if keyP["camera_direction_right"] ~= nil then
		streams["camera_direction_right"] = keyP["camera_direction_right"]
	end
	if keyP["clean_switch"] ~= nil then
		streams["clean_switch"] = keyP["clean_switch"]
		streams["clean_running_stage"] = keyP["clean_running_stage"]
		streams["clean_running_time"] = keyP["clean_running_time"]
		streams["clean_target_time"] = keyP["clean_target_time"]
	end
	if keyP["light_class_switch"] ~= nil then
		streams["light_class_switch"] = keyP["light_class_switch"]
		streams["light_class"] = keyP["light_class"]
	end
	if keyP["wind_swing_left"] ~= nil then
		streams["wind_swing_left"] = keyP["wind_swing_left"]
		streams["wind_swing_left_degree"] = keyP["wind_swing_left_degree"]
	end
	if keyP["wind_swing_right"] ~= nil then
		streams["wind_swing_right"] = keyP["wind_swing_right"]
		streams["wind_swing_right_degree"] = keyP["wind_swing_right_degree"]
	end
	if keyP["wind_swing_ud_right"] ~= nil then
		streams["wind_swing_ud_right"] = keyP["wind_swing_ud_right"]
		streams["wind_swing_ud_right_degree"] = keyP["wind_swing_ud_right_degree"]
	end
	if keyP["wind_swing_ud_left"] ~= nil then
		streams["wind_swing_ud_left"] = keyP["wind_swing_ud_left"]
		streams["wind_swing_ud_left_degree"] = keyP["wind_swing_ud_left_degree"]
	end
	if keyP["intrusion"] ~= nil then
		streams["intrusion"] = keyP["intrusion"]
	end
	if keyP["intrusion_video"] ~= nil then
		streams["intrusion_video"] = keyP["intrusion_video"]
	end
	if keyP["voice_control_new"] ~= nil then
		streams["voice_control_new"] = keyP["voice_control_new"]
	end
	if keyP["wind_swing_lr_angle"] ~= nil then
		streams["wind_swing_lr_angle"] = keyP["wind_swing_lr_angle"]
	end
	if keyP["wind_swing_ud_angle"] ~= nil then
		streams["wind_swing_ud_angle"] = keyP["wind_swing_ud_angle"]
	end
	if keyP["analysis_value"] ~= nil then
		streams["analysis_value"] = keyP["analysis_value"]
	end
	streams["new_wind_fun_wind_mode"] = keyP["new_wind_fun_wind_mode"]
	streams["smart_clean_sw"] = keyP["smart_clean_sw"]
	streams["sterilize_sw"] = keyP["sterilize_sw"]
	streams["new_wind_fun_sw"] = keyP["new_wind_fun_sw"]
	streams["hum_fun_sw"] = keyP["hum_fun_sw"]
	streams["clean_fun_sw"] = keyP["clean_fun_sw"]
	streams["run_status"] = keyP["run_status"]
	streams["device_set_run_status"] = keyP["device_set_run_status"]
	streams["wetfilm_fun_sw"] = keyP["wetfilm_fun_sw"]
	streams["purfiy_film"] = keyP["purfiy_film"]
	streams["acstrainer_sw"] = keyP["acstrainer_sw"]
	streams["elec_heat"] = keyP["elec_heat"]
	streams["strong"] = keyP["strong"]
	streams["diy_func"] = keyP["diy_func"]
	streams["open_close_time"] = keyP["open_close_time"]
	streams["currentRunMode"] = keyP["currentRunMode"]
	streams["run_current_status"] = keyP["run_current_status"]
	streams["device_current_run_status"] = keyP["device_current_run_status"]
	streams["t1_temp"] = keyP["t1_temp"]
	streams["t2_temp"] = keyP["t2_temp"]
	streams["t3_temp"] = keyP["t3_temp"]
	streams["t4_temp"] = keyP["t4_temp"]
	streams["temp_out"] = keyP["temp_out"]
	streams["tp_temp"] = keyP["tp_temp"]
	streams["temp_in"] = keyP["temp_in"]
	streams["com_run_frequency"] = keyP["com_run_frequency"]
	streams["com_target_frequency"] = keyP["com_target_frequency"]
	streams["ya_suo_ji_dian_liu"] = keyP["ya_suo_ji_dian_liu"]
	streams["shi_wai_ji_zong_dian_liu"] = keyP["shi_wai_ji_zong_dian_liu"]
	streams["shi_wai_ji_dian_ya"] = keyP["shi_wai_ji_dian_ya"]
	streams["shi_nei_ji_yun_zhuan_moshi"] = keyP["shi_nei_ji_yun_zhuan_moshi"]
	streams["left_wind_class"] = keyP["left_wind_class"]
	streams["right_wind_class"] = keyP["right_wind_class"]
	streams["room_i_fault_state1_0"] = keyP["room_i_fault_state1_0"]
	streams["room_i_fault_state1_1"] = keyP["room_i_fault_state1_1"]
	streams["room_i_fault_state1_2"] = keyP["room_i_fault_state1_2"]
	streams["room_i_fault_state1_3"] = keyP["room_i_fault_state1_3"]
	streams["room_i_fault_state1_4"] = keyP["room_i_fault_state1_4"]
	streams["room_i_fault_state1_5"] = keyP["room_i_fault_state1_5"]
	streams["room_i_fault_state1_6"] = keyP["room_i_fault_state1_6"]
	streams["room_i_fault_state1_7"] = keyP["room_i_fault_state1_7"]
	streams["room_i_fault_state2_0"] = keyP["room_i_fault_state2_0"]
	streams["room_i_fault_state2_1"] = keyP["room_i_fault_state2_1"]
	streams["room_i_fault_state2_2"] = keyP["room_i_fault_state2_2"]
	streams["room_i_fault_state2_3"] = keyP["room_i_fault_state2_3"]
	streams["room_i_fault_state2_4"] = keyP["room_i_fault_state2_4"]
	streams["room_i_fault_state2_5"] = keyP["room_i_fault_state2_5"]
	streams["room_i_fault_state2_6"] = keyP["room_i_fault_state2_6"]
	streams["room_i_fault_state2_7"] = keyP["room_i_fault_state2_7"]
	streams["room_i_fault_state3_0"] = keyP["room_i_fault_state3_0"]
	streams["room_i_fault_state3_1"] = keyP["room_i_fault_state3_1"]
	streams["room_i_fault_state3_2"] = keyP["room_i_fault_state3_2"]
	streams["room_i_fault_state3_3"] = keyP["room_i_fault_state3_3"]
	streams["room_i_fault_state3_4"] = keyP["room_i_fault_state3_4"]
	streams["room_i_fault_state3_5"] = keyP["room_i_fault_state3_5"]
	streams["room_i_fault_state3_6"] = keyP["room_i_fault_state3_6"]
	streams["room_i_fault_state3_7"] = keyP["room_i_fault_state3_7"]
	streams["room_i_limit_freq_state1_0"] = keyP["room_i_limit_freq_state1_0"]
	streams["room_i_limit_freq_state1_1"] = keyP["room_i_limit_freq_state1_1"]
	streams["room_i_limit_freq_state1_2"] = keyP["room_i_limit_freq_state1_2"]
	streams["room_i_limit_freq_state1_3"] = keyP["room_i_limit_freq_state1_3"]
	streams["room_i_limit_freq_state1_4"] = keyP["room_i_limit_freq_state1_4"]
	streams["room_i_limit_freq_state1_5"] = keyP["room_i_limit_freq_state1_5"]
	streams["room_i_limit_freq_state1_6"] = keyP["room_i_limit_freq_state1_6"]
	streams["room_i_limit_freq_state1_7"] = keyP["room_i_limit_freq_state1_7"]
	streams["room_i_limit_freq_state2_0"] = keyP["room_i_limit_freq_state2_0"]
	streams["room_i_limit_freq_state2_1"] = keyP["room_i_limit_freq_state2_1"]
	streams["room_i_limit_freq_state2_2"] = keyP["room_i_limit_freq_state2_2"]
	streams["room_i_limit_freq_state2_3"] = keyP["room_i_limit_freq_state2_3"]
	streams["room_i_limit_freq_state2_4"] = keyP["room_i_limit_freq_state2_4"]
	streams["room_i_limit_freq_state2_5"] = keyP["room_i_limit_freq_state2_5"]
	streams["room_i_limit_freq_state2_6"] = keyP["room_i_limit_freq_state2_6"]
	streams["room_i_limit_freq_state2_7"] = keyP["room_i_limit_freq_state2_7"]
	streams["room_i_load_state1_0"] = keyP["room_i_load_state1_0"]
	streams["room_i_load_state1_1"] = keyP["room_i_load_state1_1"]
	streams["room_i_load_state1_2"] = keyP["room_i_load_state1_2"]
	streams["room_i_load_state1_3"] = keyP["room_i_load_state1_3"]
	streams["room_i_load_state1_4"] = keyP["room_i_load_state1_4"]
	streams["room_i_load_state1_5"] = keyP["room_i_load_state1_5"]
	streams["room_i_load_state1_6"] = keyP["room_i_load_state1_6"]
	streams["room_i_load_state1_7"] = keyP["room_i_load_state1_7"]
	streams["temp_out_valid"] = keyP["temp_out_valid"]
	streams["out_door_dev_state1_0"] = keyP["out_door_dev_state1_0"]
	streams["out_door_dev_state1_1"] = keyP["out_door_dev_state1_1"]
	streams["out_door_dev_state1_2"] = keyP["out_door_dev_state1_2"]
	streams["out_door_dev_state1_3"] = keyP["out_door_dev_state1_3"]
	streams["out_door_dev_state1_4"] = keyP["out_door_dev_state1_4"]
	streams["out_door_dev_state1_5"] = keyP["out_door_dev_state1_5"]
	streams["out_door_dev_state1_6"] = keyP["out_door_dev_state1_6"]
	streams["out_door_dev_state1_7"] = keyP["out_door_dev_state1_7"]
	streams["out_door_dev_state2_0"] = keyP["out_door_dev_state2_0"]
	streams["out_door_dev_state2_1"] = keyP["out_door_dev_state2_1"]
	streams["out_door_dev_state2_2"] = keyP["out_door_dev_state2_2"]
	streams["out_door_dev_state2_3"] = keyP["out_door_dev_state2_3"]
	streams["out_door_dev_state2_4"] = keyP["out_door_dev_state2_4"]
	streams["out_door_dev_state2_5"] = keyP["out_door_dev_state2_5"]
	streams["out_door_dev_state2_6"] = keyP["out_door_dev_state2_6"]
	streams["out_door_dev_state2_7"] = keyP["out_door_dev_state2_7"]
	streams["out_door_dev_state3_0"] = keyP["out_door_dev_state3_0"]
	streams["out_door_dev_state3_1"] = keyP["out_door_dev_state3_1"]
	streams["out_door_dev_state3_2"] = keyP["out_door_dev_state3_2"]
	streams["out_door_dev_state3_3"] = keyP["out_door_dev_state3_3"]
	streams["out_door_dev_state3_4"] = keyP["out_door_dev_state3_4"]
	streams["out_door_dev_state3_5"] = keyP["out_door_dev_state3_5"]
	streams["out_door_dev_state3_6"] = keyP["out_door_dev_state3_6"]
	streams["out_door_dev_state3_7"] = keyP["out_door_dev_state3_7"]
	streams["out_door_dev_state4_0"] = keyP["out_door_dev_state4_0"]
	streams["out_door_dev_state4_1"] = keyP["out_door_dev_state4_1"]
	streams["out_door_dev_state4_2"] = keyP["out_door_dev_state4_2"]
	streams["out_door_dev_state4_3"] = keyP["out_door_dev_state4_3"]
	streams["out_door_dev_state4_4"] = keyP["out_door_dev_state4_4"]
	streams["out_door_dev_state4_5"] = keyP["out_door_dev_state4_5"]
	streams["out_door_dev_state4_6"] = keyP["out_door_dev_state4_6"]
	streams["out_door_dev_state4_7"] = keyP["out_door_dev_state4_7"]
	streams["out_door_dev_state5_0"] = keyP["out_door_dev_state5_0"]
	streams["out_door_dev_state5_1"] = keyP["out_door_dev_state5_1"]
	streams["out_door_dev_state5_2"] = keyP["out_door_dev_state5_2"]
	streams["out_door_dev_state5_3"] = keyP["out_door_dev_state5_3"]
	streams["out_door_dev_state5_4"] = keyP["out_door_dev_state5_4"]
	streams["out_door_dev_state5_5"] = keyP["out_door_dev_state5_5"]
	streams["out_door_dev_state5_6"] = keyP["out_door_dev_state5_6"]
	streams["out_door_dev_state5_7"] = keyP["out_door_dev_state5_7"]
	streams["out_door_dev_state6_0"] = keyP["out_door_dev_state6_0"]
	streams["out_door_dev_state6_1"] = keyP["out_door_dev_state6_1"]
	streams["out_door_dev_state6_2"] = keyP["out_door_dev_state6_2"]
	streams["out_door_dev_state6_3"] = keyP["out_door_dev_state6_3"]
	streams["out_door_dev_state6_4"] = keyP["out_door_dev_state6_4"]
	streams["out_door_dev_state6_5"] = keyP["out_door_dev_state6_5"]
	streams["out_door_dev_state6_6"] = keyP["out_door_dev_state6_6"]
	streams["out_door_dev_state6_7"] = keyP["out_door_dev_state6_7"]
	streams["out_door_i_fan_speed"] = keyP["out_door_i_fan_speed"]
	streams["out_door_ele_switch"] = keyP["out_door_ele_switch"]
	streams["out_door_back_temp"] = keyP["out_door_back_temp"]
	streams["out_door_voltage"] = keyP["out_door_voltage"]
	streams["ipm_temp"] = keyP["ipm_temp"]
	streams["dry_heat_time_value"] = keyP["dry_heat_time_value"]
	streams["new_wind_fun_current_value"] = keyP["new_wind_fun_current_value"]
	streams["clean_fun_current_value"] = keyP["clean_fun_current_value"]
	streams["hum_fun_wind_current_value"] = keyP["hum_fun_wind_current_value"]
	streams["sterilize_run_time"] = keyP["sterilize_run_time"]
	streams["wetfilm_time"] = keyP["wetfilm_time"]
	streams["purfiy_film_time"] = keyP["purfiy_film_time"]
	streams["smart_clean_current_run_time"] = keyP["smart_clean_current_run_time"]
	streams["right_wind_rotate_speed"] = keyP["right_wind_rotate_speed"]
	streams["left_wind_rotate_speed"] = keyP["left_wind_rotate_speed"]
	streams["left_wind_current_class"] = keyP["left_wind_current_class"]
	streams["right_wind_current_class"] = keyP["right_wind_current_class"]
	streams["down_wind_set_class"] = keyP["down_wind_set_class"]
	streams["down_wind_current_class"] = keyP["down_wind_current_class"]
	streams["set_hum_value"] = keyP["set_hum_value"]
	streams["hum_fun_wind_class"] = keyP["hum_fun_wind_class"]
	streams["clean_fun_wind_class"] = keyP["clean_fun_wind_class"]
	streams["new_wind_fun_class"] = keyP["new_wind_fun_class"]
	streams["sterilize_wind_class"] = keyP["sterilize_wind_class"]
	streams["product_code"] = keyP["product_code"]
	streams["err_code_class"] = keyP["err_code_class"]
	streams["in_display_transport"] = keyP["in_display_transport"]
	streams["compressor_pos_protect"] = keyP["compressor_pos_protect"]
	streams["in_display_transit"] = keyP["in_display_transit"]
	streams["timing_on_minute"] = keyP["timing_on_minute"]
	streams["timing_off_minute"] = keyP["timing_off_minute"]
	streams["local_body_sense"] = keyP["local_body_sense"]
	streams["energy_save"] = keyP["energy_save"]
	streams["restrong"] = keyP["restrong"]
	streams["refarce_wind"] = keyP["refarce_wind"]
	streams["repower_save"] = keyP["repower_save"]
	streams["cosy_sleep_switch"] = keyP["cosy_sleep_switch"]
	streams["eco_func"] = keyP["eco_func"]
	streams["dust_fun_flag"] = keyP["dust_fun_flag"]
	streams["re_elec_heat"] = keyP["re_elec_heat"]
	streams["rediy_func"] = keyP["rediy_func"]
	streams["rechg_of_air"] = keyP["rechg_of_air"]
	streams["wisdom_eye"] = keyP["wisdom_eye"]
	streams["natural_wind"] = keyP["natural_wind"]
	streams["repeak_valley_mode"] = keyP["repeak_valley_mode"]
	streams["night_light"] = keyP["night_light"]
	streams["against_cool"] = keyP["against_cool"]
	streams["child_kickk"] = keyP["child_kickk"]
	streams["alm_sleep"] = keyP["alm_sleep"]
	streams["pmv_status"] = keyP["pmv_status"]
	streams["display_control_flag"] = keyP["display_control_flag"]
	streams["control_self_cleaning_current_status"] = keyP["control_self_cleaning_current_status"]
	streams["nonDirectWind"] = keyP["nonDirectWind"]
	streams["is_open8_degree_hot_current_status"] = keyP["is_open8_degree_hot_current_status"]
	streams["smartfun_current_status"] = keyP["smartfun_current_status"]
	streams["is_use_double_temp_ctrl"] = keyP["is_use_double_temp_ctrl"]
	streams["ladder_fun_sw"] = keyP["ladder_fun_sw"]
	streams["up_dn_dao_feng_tiao_stat"] = keyP["up_dn_dao_feng_tiao_stat"]
	streams["lt_rt_dao_feng_tiao_stat"] = keyP["lt_rt_dao_feng_tiao_stat"]
	streams["top_dao_feng_tiao_stat"] = keyP["top_dao_feng_tiao_stat"]
	streams["up_dn_dao_feng_tiao_stat_right_down"] = keyP["up_dn_dao_feng_tiao_stat_right_down"]
	streams["lt_rt_dao_feng_tiao_stat_right_left"] = keyP["lt_rt_dao_feng_tiao_stat_right_left"]
	streams["hum_fun_wind_percentage"] = keyP["hum_fun_wind_percentage"]
	streams["checked_temp_set"] = keyP["checked_temp_set"]
	streams["indoor_fan_runtime"] = keyP["indoor_fan_runtime"]
	streams["outdoor_fan_speed"] = keyP["outdoor_fan_speed"]
	streams["ele_switch_angle"] = keyP["ele_switch_angle"]
	streams["defrosting_step"] = keyP["defrosting_step"]
	streams["outdoor_dev_state7"] = keyP["outdoor_dev_state7"]
	streams["outdoor_dev_state8"] = keyP["outdoor_dev_state8"]
	streams["out_door485_fault"] = keyP["out_door485_fault"]
	streams["engine_cur_worked_time"] = keyP["engine_cur_worked_time"]
	streams["engine_total_worked_time"] = keyP["engine_total_worked_time"]
	streams["limit_freq_type2"] = keyP["limit_freq_type2"]
	streams["dev_max_voltage"] = keyP["dev_max_voltage"]
	streams["dev_min_voltage"] = keyP["dev_min_voltage"]
	streams["history_max_current"] = keyP["history_max_current"]
	streams["history_max_for_t4"] = keyP["history_max_for_t4"]
	streams["history_min_for_t4"] = keyP["history_min_for_t4"]
	streams["total_err_cnt"] = keyP["total_err_cnt"]
	streams["shi_wai_ya_suo_ji_ci_tong"] = keyP["shi_wai_ya_suo_ji_ci_tong"]
	streams["shi_nei_feng_ji_ci_tong"] = keyP["shi_nei_feng_ji_ci_tong"]
	streams["d_spin_current"] = keyP["d_spin_current"]
	streams["q_spin_current"] = keyP["q_spin_current"]
	streams["engine_peak_current"] = keyP["engine_peak_current"]
	streams["pfc_peak_current"] = keyP["pfc_peak_current"]
	streams["fan_peak_current"] = keyP["fan_peak_current"]
	streams["torque_adjust_angle"] = keyP["torque_adjust_angle"]
	streams["torque_adjust_value"] = keyP["torque_adjust_value"]
	streams["ad_adjust_voltage1"] = keyP["ad_adjust_voltage1"]
	streams["ad_adjust_voltage2"] = keyP["ad_adjust_voltage2"]
	streams["d_spin_voltage"] = keyP["d_spin_voltage"]
	streams["q_spin_voltage"] = keyP["q_spin_voltage"]
	streams["pfc_switch_status"] = keyP["pfc_switch_status"]
	streams["com_start_status"] = keyP["com_start_status"]
	streams["out_side_power_factor"] = keyP["out_side_power_factor"]
	streams["out_side_power"] = keyP["out_side_power"]
	streams["up_dn_dao_feng_tiao_cool_upper_limit"] = keyP["up_dn_dao_feng_tiao_cool_upper_limit"]
	streams["up_dn_dao_feng_tiao_cool_lower_limit"] = keyP["up_dn_dao_feng_tiao_cool_lower_limit"]
	streams["up_dn_dao_feng_tiao_heat_upper_limit"] = keyP["up_dn_dao_feng_tiao_heat_upper_limit"]
	streams["up_dn_dao_feng_tiao_heat_lower_limit"] = keyP["up_dn_dao_feng_tiao_heat_lower_limit"]
	streams["up_dn_dao_feng_tiao_cur_angle"] = keyP["up_dn_dao_feng_tiao_cur_angle"]
	streams["lt_rt_dao_feng_tiao_upper_limit"] = keyP["lt_rt_dao_feng_tiao_upper_limit"]
	streams["lt_rt_dao_feng_tiao_lower_limit"] = keyP["lt_rt_dao_feng_tiao_lower_limit"]
	streams["lt_rt_dao_feng_tiao_cur_angle"] = keyP["lt_rt_dao_feng_tiao_cur_angle"]
	streams["out_door_dest_freq"] = keyP["out_door_dest_freq"]
	streams["int_door_target_wind_speed"] = keyP["int_door_target_wind_speed"]
	streams["top_dao_feng_tiao_upper_limit"] = keyP["top_dao_feng_tiao_upper_limit"]
	streams["top_dao_feng_tiao_lower_limit"] = keyP["top_dao_feng_tiao_lower_limit"]
	streams["top_dao_feng_tiao_cur_angle"] = keyP["top_dao_feng_tiao_cur_angle"]
	streams["down_dao_feng_tiao_cool_upper_limit"] = keyP["down_dao_feng_tiao_cool_upper_limit"]
	streams["down_dao_feng_tiao_cool_lower_limit"] = keyP["down_dao_feng_tiao_cool_lower_limit"]
	streams["down_dn_dao_feng_tiao_heat_upper_limit"] = keyP["down_dn_dao_feng_tiao_heat_upper_limit"]
	streams["down_dn_dao_feng_tiao_heat_lower_limit"] = keyP["down_dn_dao_feng_tiao_heat_lower_limit"]
	streams["down_dn_dao_feng_tiao_cur_angle"] = keyP["down_dn_dao_feng_tiao_cur_angle"]
	streams["second_hum_value"] = keyP["second_hum_value"]
	streams["strong_current"] = keyP["strong_current"]
	streams["sterilize_current_sw"] = keyP["sterilize_current_sw"]
	streams["new_wind_fun_current_sw"] = keyP["new_wind_fun_current_sw"]
	streams["hum_fun_current_sw"] = keyP["hum_fun_current_sw"]
	streams["clean_fun_current_sw"] = keyP["clean_fun_current_sw"]
	streams["control_self_cleaning_current_stage"] = keyP["control_self_cleaning_current_stage"]
	streams["smart_clean_current_status"] = keyP["smart_clean_current_status"]
	streams["right_control_wind_current_free"] = keyP["right_control_wind_current_free"]
	streams["left_control_wind_current_free"] = keyP["left_control_wind_current_free"]
	streams["up_dn_dao_feng_tiao_current_stat"] = keyP["up_dn_dao_feng_tiao_current_stat"]
	streams["lt_rt_dao_feng_tiao_current_stat"] = keyP["lt_rt_dao_feng_tiao_current_stat"]
	streams["pannel_protect"] = keyP["pannel_protect"]
	streams["hydropenia"] = keyP["hydropenia"]
	streams["lt_rt_dao_feng_tiao_current_stat_left"] = keyP["lt_rt_dao_feng_tiao_current_stat_left"]
	streams["up_dn_dao_feng_tiao_current_stat_left"] = keyP["up_dn_dao_feng_tiao_current_stat_left"]
	if keyP["full_time"] ~= nil then
		streams["full_time"] = keyP["full_time"]
	end
	init_property_value()
	tempControl = 0
	cmdOrder = 0
	keyP["propertyNumber"] = 0
	keyP["powerValue"] = nil
	keyP["modeValue"] = nil
	keyP["temperature"] = nil
	keyP["smallTemperature"] = nil
	keyP["sceneId"] = nil
	keyP["targetLWindSpeed"] = nil
	keyP["targetRWindSpeed"] = nil
	keyP["smallIndoorTemperatureValue"] = nil
	keyP["smallOutdoorTemperatureValue"] = nil
	keyP["fanspeedValue"] = nil
	keyP["swingLRValue"] = nil
	keyP["swingUDValue"] = nil
	keyP["prevent_super_cool"] = nil
	keyP["prevent_straight_wind"] = nil
	keyP["auto_prevent_straight_wind"] = nil
	keyP["wind_straight"] = nil
	keyP["wind_avoid"] = nil
	keyP["intelligent_wind"] = nil
	keyP["self_clean"] = nil
	keyP["no_wind_sense"] = nil
	keyP["child_prevent_cold_wind"] = nil
	keyP["little_angel"] = nil
	keyP["cool_hot_sense"] = nil
	keyP["gentle_wind_sense"] = nil
	keyP["screen_display"] = nil
	keyP["security"] = nil
	keyP["PTCValue"] = nil
	keyP["dryValue"] = nil
	keyP["strongWindValue"] = nil
	keyP["voice_control_new"] = nil
	keyP["remove_odor"] = nil
	keyP["inner_purifier"] = nil
	keyP["humidification"] = nil
	keyP["airoptimization"] = nil
	keyP["no_wind_sense_right"] = nil
	keyP["no_wind_sense_left"] = nil
	keyP["light"] = nil
	keyP["fresh_air"] = nil
	keyP["light_bright"] = nil
	keyP["down_wind_speed"] = nil
	keyP["up_control_wind"] = nil
	keyP["up_control_wind_degree"] = nil
	keyP["down_control_wind"] = nil
	keyP["down_control_wind_degree"] = nil
	keyP["wait_clean"] = nil
	keyP["left_wind"] = nil
	keyP["right_wind"] = nil
	keyP["purify_film"] = nil
	keyP["purify_film_time"] = nil
	keyP["purify_film_total_time"] = nil
	keyP["wetfilm_state"] = nil
	keyP["wetfilm_state_time"] = nil
	keyP["wetfilm_state_total_time"] = nil
	keyP["acstrainer_state"] = nil
	keyP["acstrainer_state_time"] = nil
	keyP["acstrainer_state_total_time"] = nil
	keyP["get_weather"] = nil
	keyP["outdoor_pm25"] = nil
	keyP["near_switch"] = nil
	keyP["near_no_yes"] = nil
	keyP["water_supply"] = nil
	keyP["water_level"] = nil
	keyP["water_tank"] = nil
	keyP["air_condition_temp"] = nil
	keyP["air_condition_humidity"] = nil
	keyP["air_condition_clean"] = nil
	keyP["air_condition_fresh"] = nil
	keyP["indoor_temp"] = nil
	keyP["indoor_temp_decimal"] = nil
	keyP["outdoor_temp"] = nil
	keyP["outdoor_temp_decimal"] = nil
	keyP["eco_switch"] = nil
	keyP["eco_second"] = nil
	keyP["eco_min"] = nil
	keyP["eco_hour"] = nil
	keyP["keep_warm_switch"] = nil
	keyP["keep_warm_temp"] = nil
	keyP["exclusive_mode"] = nil
	keyP["close_screen"] = nil
	keyP["family_number"] = nil
	keyP["wind_blow_close"] = nil
	keyP["wisdom_wind"] = nil
	keyP["wisdom_wind_new"] = nil
	keyP["wisdom_left_distance"] = nil
	keyP["wisdom_right_distance"] = nil
	keyP["wisdom_left_set_wind"] = nil
	keyP["wisdom_right_set_wind"] = nil
	keyP["wisdom_left_down_angle"] = nil
	keyP["wisdom_right_down_angle"] = nil
	keyP["wisdom_left_up_angle"] = nil
	keyP["wisdom_right_up_angle"] = nil
	keyP["wind_close"] = nil
	keyP["wind_close_left_distance"] = nil
	keyP["wind_close_right_distance"] = nil
	keyP["wind_close_left_down_angle"] = nil
	keyP["wind_close_right_down_angle"] = nil
	keyP["wind_close_left_up_angle"] = nil
	keyP["wind_close_right_up_angle"] = nil
	keyP["wind_blow"] = nil
	keyP["wind_blow_left_distance"] = nil
	keyP["wind_blow_right_distance"] = nil
	keyP["wind_blow_left_down_angle"] = nil
	keyP["wind_blow_right_down_angle"] = nil
	keyP["wind_blow_left_up_angle"] = nil
	keyP["wind_blow_right_up_angle"] = nil
	keyP["camera_direction_state"] = nil
	keyP["camera_direction_switch"] = nil
	keyP["camera_direction_left"] = nil
	keyP["camera_direction_right"] = nil
	keyP["clean_switch"] = nil
	keyP["clean_running_stage"] = nil
	keyP["clean_running_time"] = nil
	keyP["clean_target_time"] = nil
	keyP["wind_swing_left"] = nil
	keyP["wind_swing_left_degree"] = nil
	keyP["wind_swing_right"] = nil
	keyP["wind_swing_right_degree"] = nil
	keyP["wind_swing_ud_right"] = nil
	keyP["wind_swing_ud_right_degree"] = nil
	keyP["wind_swing_ud_left"] = nil
	keyP["wind_swing_ud_left_degree"] = nil
	keyP["wind_speed_left"] = nil
	keyP["wind_speed_right"] = nil
	keyP["strong_wind"] = nil
	keyP["intrusion"] = nil
	keyP["intrusion_video"] = nil
	keyP["right_control_wind_current_free"] = nil
	keyP["left_control_wind_current_free"] = nil
	keyP["up_dn_dao_feng_tiao_current_stat"] = nil
	keyP["lt_rt_dao_feng_tiao_current_stat"] = nil
	keyP["pannel_protect"] = nil
	keyP["hydropenia"] = nil
	keyP["lt_rt_dao_feng_tiao_current_stat_left"] = nil
	keyP["up_dn_dao_feng_tiao_current_stat_left"] = nil
	keyP["wind_swing_ud_angle"] = nil
	keyP["wind_swing_lr_angle"] = nil
	keyP["full_time"] = nil
	keyP["hum_fun_wind_percentage"] = nil
	keyP["current_run_mode"] = nil
	local retTable = {}
	retTable["status"] = streams
	local ret = encode(retTable)
	return ret
end
