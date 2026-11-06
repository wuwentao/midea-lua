local bit = require("bit")
local JSON = require("cjson")
local keyT = {}
keyT["KEY_VERSION"] = "version"
keyT["KEY_POWER"] = "power"
keyT["KEY_STANDBY_CLEAN"] = "standby_clean"
keyT["KEY_BUZZER"] = "buzzer"
keyT["KEY_NOWINDSENSE"] = "no_wind_sense"
keyT["KEY_DRY"] = "dry"
keyT["KEY_STRONG_WIND"] = "strong_wind"
keyT["KEY_MANUL_NEWWIND"] = "manul_fresh_air"
keyT["KEY_AUTO_NEWWIND"] = "fresh_air"
keyT["KEY_SWING_LR"] = "wind_swing_lr"
keyT["KEY_SWING_UD"] = "wind_swing_ud"
keyT["KEY_FORCE_COOL_MODE"] = "force_cool"
keyT["KEY_FORCE_AUTO_MODE"] = "force_auto"
keyT["KEY_PTC"] = "ptc"
keyT["KEY_PTC_DEPENDT4"] = "ptc_dependT4"
keyT["KEY_COOL_HOT_SENSE"] = "cool_hot_sense"
keyT["KEY_PREVENT_COLD"] = "prevent_cold"
keyT["KEY_WIND_STRAIGHT"] = "wind_straight"
keyT["KEY_WIND_AVOID"] = "wind_avoid"
keyT["KEY_DISINFECT"] = "disinfect"
keyT["KEY_ELEC_DUST_REMOVE"] = "elec_dust_remove"
keyT["KEY_SELFCLEAN"] = "self_clean"
keyT["KEY_ENERGY_SAVE"] = "energy_save"
keyT["KEY_AIR_OPTIMIZATION"] = "airoptimization"
keyT["KEY_NOBODY_ENERGY_SAVE"] = "nobody_energy_save"
keyT["KEY_AUTO_PURIFY"] = "inner_purifier"
keyT["KEY_MANUL_PURIFY"] = "manu_inner_purifier"
keyT["KEY_NO_WIND_SENSE_MODE"] = "no_wind_sense_mode"
keyT["KEY_RUN_TEST"] = "run_test"
keyT["KEY_FAST_CHECK"] = "fast_check"
keyT["KEY_AUTO_HUMI"] = "auto_humi"
keyT["KEY_MANUL_HUMI"] = "manul_humi"
keyT["KEY_WIND_STRENGTH"] = "wind_strength"
keyT["KEY_NEW_WIND_MACHINE"] = "new_wind_machine"
keyT["KEY_NEW_WIND_MACHINE_LINK"] = "new_wind_machine_link"
keyT["KEY_PROJECT_EVACUATE"] = "project_evacuate"
keyT["KEY_FOLLOW_BODY_SENSE"] = "follow_body_sense"
keyT["KEY_EXHAUST_STRENGTH"] = "exhaust_strength"
keyT["KEY_MODE"] = "mode"
keyT["KEY_TEMPERATURE"] = "temperature"
keyT["KEY_FANSPEED"] = "wind_speed"
keyT["KEY_DEHUMIDITY"] = "dehumidity"
keyT["KEY_PM25"] = "inner_purifier_on_pm"
keyT["KEY_CO2"] = "fresh_air_on_co2"
keyT["KEY_HUMIDITY"] = "humidity"
keyT["KEY_NEWWIND_MODE"] = "fresh_air_mode"
keyT["KEY_NEWWIND_FANSPEED"] = "fresh_air_fan_speed"
keyT["KEY_WATER_MODEL_POWER"] = "water_model_power"
keyT["KEY_WATER_MODEL_POWER_SAVE"] = "water_model_power_save"
keyT["KEY_WATER_MODEL_CLEAN"] = "water_model_clean"
keyT["KEY_WATER_MODEL_CLEAN_TIME"] = "water_model_clean_time"
keyT["KEY_WATER_MODEL_TEMPERATURE_AUTO"] = "water_model_temperature_auto"
keyT["KEY_WATER_MODEL_PTC"] = "water_model_ptc"
keyT["KEY_WATER_MODEL_GO_OUT"] = "water_model_go_out"
keyT["KEY_WATER_MODEL_TEMPERATURE_SET"] = "water_model_temperature_set"
keyT["KEY_WATER_MODEL_MODE_CLASH"] = "water_model_mode_clash"
keyT["KEY_HAS_HUIFENG"] = "has_huifeng"
keyT["KEY_HAS_CHUFENG"] = "has_chufeng"
keyT["KEY_HAS_WIND_LR"] = "has_wind_lr"
keyT["KEY_HAS_NO_WIND_SENSE"] = "has_no_wind_sense"
keyT["KEY_HAS_XINFENG"] = "has_xinfeng"
keyT["KEY_HAS_HUMIDIFER"] = "has_humidifer"
keyT["KEY_HAS_WATER_MODEL"] = "has_water_model"
keyT["KEY_AIR_OPTIMIZATION_TEMPERATURE"] = "airoptimization_temperature"
keyT["KEY_AIR_OPTIMIZATION_HUMIDITY"] = "airoptimization_humidity"
keyT["KEY_AIR_OPTIMIZATION_WIND"] = "airoptimization_speed"
keyT["KEY_SCREEN_DISPLAY"] = "screen_display"
keyT["KEY_FANSPEED_REAL"] = "wind_speed_real"
keyT["KEY_INDOOR_TEMPERATURE"] = "indoor_temperature"
keyT["KEY_OUTDOOR_TEMPERATURE"] = "outdoor_temperature"
keyT["KEY_INDOOR_PM24"] = "indoor_pm25"
keyT["KEY_INDOOR_CO2"] = "indoor_co2"
keyT["KEY_INDOOR_TVOC"] = "indoor_tvoc"
keyT["KEY_INDOOR_HUMIDITY"] = "indoor_humidity"
keyT["KEY_MODE_CLASH"] = "mode_clash"
keyT["KEY_FILTER_TIME"] = "filter_time"
keyT["KEY_PURIFY_FILTER_TIME"] = "purify_filter_time"
keyT["KEY_FRESH_FILTER_TIME"] = "fresh_filter_time"
keyT["KEY_FILTER_TIME_RESET"] = "filter_time_reset"
keyT["KEY_PURIFY_FILTER_TIME_RESET"] = "purify_filter_time_reset"
keyT["KEY_FRESH_FILTER_TIME_RESET"] = "fresh_filter_time_reset"
keyT["KEY_SELF_CLEAN_STATE"] = "self_clean_state"
keyT["KEY_SELF_CLEAN_RUN_TIME"] = "self_clean_run_time"
keyT["KEY_FRESH_LEVEL"] = "fresh_level"
keyT["KEY_PURIFIER_LEVEL"] = "purifier_level"
keyT["KEY_HUMIDITY_LEVEL"] = "humidity_level"
keyT["KEY_TEMPERATURE_LEVEL"] = "temperature_level"
keyT["KEY_TOVC_LEVEL"] = "tvoc_level"
keyT["KEY_TOTAL_AIR_LEVEL"] = "total_air_level"
keyT["KEY_FRESH_AIR_MACHINE_NUMBER"] = "fresh_air_machine_number"
keyT["KEY_HUMIDITY_MACHINE_NUMBER"] = "humidity_machine_number"
keyT["KEY_RETURN_AIR_PANEL_SELECT"] = "return_air_panel_select"
keyT["KEY_AIR_PANEL_SELECT"] = "air_panel_select"
keyT["KEY_NO_WIND_SENSE_SELECT"] = "no_wind_sense_select"
keyT["KEY_WIND_LEFT_RIGHT_SELECT"] = "wind_left_right_select"
keyT["KEY_POWER_OFF_TIMER"] = "power_off_timer"
keyT["KEY_POWER_ON_TIMER"] = "power_on_timer"
keyT["KEY_CLOSE_TIME"] = "power_off_time_value"
keyT["KEY_OPEN_TIME"] = "power_on_time_value"
keyT["KEY_COMFORT_SLEEP"] = "comfort_sleep"
keyT["KEY_COMFORT_SLEEP_CURVE"] = "comfort_sleep_curve"
local keyV = {}
keyV["VALUE_VERSION"] = 76
keyV["VALUE_FUNCTION_ON"] = "on"
keyV["VALUE_FUNCTION_OFF"] = "off"
keyV["VALUE_MODE_HEAT"] = "heat"
keyV["VALUE_MODE_COOL"] = "cool"
keyV["VALUE_MODE_AUTO"] = "auto"
keyV["VALUE_MODE_DRY"] = "dry"
keyV["VALUE_MODE_FAN"] = "fan"
keyV["VALUE_MODE_STANDBY"] = "standby"
keyV["VALUE_MODE_DRYCONSTANT"] = "dryconstant"
keyV["VALUE_MODE_DRYAUTO"] = "dryauto"
local deviceSubType = 0
local deviceSN8 = "00000000"
local keyB = {}
keyB["BYTE_DEVICE_TYPE"] = 0xAC
keyB["BYTE_CONTROL_REQUEST"] = 0x20
keyB["BYTE_CONTROL_RESET_REQUEST"] = 0xAB
keyB["BYTE_QUERYL_REQUEST"] = 0x11
keyB["BYTE_QUERY_RUN_REQUEST"] = 0x10
keyB["BYTE_QUERY_WATER_RUN_REQUEST"] = 0x12
keyB["BYTE_QUERY_OUT_RUN_REQUEST"] = 0x30
keyB["BYTE_PROTOCOL_HEAD"] = 0xAA
keyB["BYTE_PROTOCOL_LENGTH"] = 0x06
keyB["BYTE_COMMON_ON"] = 0x01
keyB["BYTE_COMMON_OFF"] = 0x00
keyB["BYTE_POWER_ON"] = 0x01
keyB["BYTE_POWER_OFF"] = 0x00
keyB["BYTE_MODE_AUTO"] = 0x02
keyB["BYTE_MODE_COOL"] = 0x00
keyB["BYTE_MODE_DRY"] = 0x01
keyB["BYTE_MODE_HEAT"] = 0x03
keyB["BYTE_MODE_FAN"] = 0x04
keyB["BYTE_MODE_STANDBY"] = 0x05
keyB["BYTE_MODE_DRYCONSTANT"] = 0x06
keyB["BYTE_MODE_DRYAUTO"] = 0x07
keyB["BYTE_FANSPEED_AUTO"] = 0x66
keyB["BYTE_FANSPEED_HIGH"] = 0x50
keyB["BYTE_FANSPEED_MID"] = 0x3C
keyB["BYTE_FANSPEED_LOW"] = 0x28
keyB["BYTE_FANSPEED_MUTE"] = 0x14
keyB["BYTE_CONTROL_CMD"] = 0x40
local keyP = {}
local comfortByte = nil
local radarStatus = {
	["sense_target"] = 0,
	["sense_distance"] = 0,
	["target1_distance"] = 0,
	["target1_angle"] = 0,
	["target2_distance"] = 0,
	["target2_angle"] = 0,
	["target3_distance"] = 0,
	["target3_angle"] = 0,
	["target4_distance"] = 0,
	["target4_angle"] = 0,
	["target5_distance"] = 0,
	["target5_angle"] = 0,
	["target1_area_tag"] = 0,
	["target2_area_tag"] = 0,
	["target3_area_tag"] = 0,
	["target4_area_tag"] = 0,
	["target5_area_tag"] = 0,
	["guide_strip_lr_close"] = 0,
	["smart_wind_current_status"] = 0,
	["radar_number"] = 0,
	["radar_infomation_dimension"] = 0,
}
local c004Status = {
	["care_mode_switch"] = 0,
	["child_old_care_mode_switch"] = 0,
	["has_child_care_mode_temp"] = 0,
	["has_child_care_mode_limit"] = 0,
	["has_child_care_mode_gentle_wind"] = 0,
	["has_child_care_mode_prevent_straight_wind"] = 0,
	["has_child_care_mode_no_wind_sense"] = 0,
	["child_care_mode_ban_mode_select"] = 0,
	["child_care_mode_temp_min"] = 0,
	["child_care_mode_temp_max"] = 0,
	["child_care_mode_gentle_wind_min"] = 0,
	["child_care_mode_gentle_wind_max"] = 0,
	["has_old_care_mode_temp"] = 0,
	["has_old_care_mode_limit"] = 0,
	["has_old_care_mode_gentle_wind"] = 0,
	["has_old_care_mode_prevent_straight_wind"] = 0,
	["has_old_care_mode_no_wind_sense"] = 0,
	["old_care_mode_ban_mode_select"] = 0,
	["old_care_mode_temp_min"] = 0,
	["old_care_mode_temp_max"] = 0,
	["old_care_mode_gentle_wind_min"] = 0,
	["old_care_mode_gentle_wind_max"] = 0,
}
local function init_keyP()
	keyP["powerValue"] = 0
	keyP["standby_clean"] = 0
	keyP["buzzerValue"] = 0
	keyP["no_wind_sense"] = 0
	keyP["dryValue"] = 0
	keyP["strongWindValue"] = 0
	keyP["manulNewWind"] = 0
	keyP["autoNewWind"] = 0
	keyP["swingLeftUDValue"] = 0
	keyP["swingRightUDValue"] = 0
	keyP["swingUpLRValue"] = 0
	keyP["swingDownLRValue"] = 0
	keyP["forceCoolMode"] = 0
	keyP["forceAutoMode"] = 0
	keyP["PTCValue"] = 0
	keyP["PTCDependT4Value"] = 0
	keyP["cool_hot_sense"] = 0
	keyP["preventCold"] = 0
	keyP["wind_straight"] = 0
	keyP["wind_avoid"] = 0
	keyP["disinfect"] = 0
	keyP["elecDustRemove"] = 0
	keyP["self_clean"] = 0
	keyP["energySaveValue"] = 0
	keyP["air_optimization"] = 0
	keyP["nobody_energy_save"] = 0
	keyP["autoPurify"] = 0
	keyP["manuPurify"] = 0
	keyP["no_wind_sense_mode"] = 0
	keyP["run_test"] = 0
	keyP["fast_check"] = 0
	keyP["autoHumi"] = 0
	keyP["manuHumi"] = 0
	keyP["wind_strength"] = 0
	keyP["new_wind_machine"] = 0
	keyP["new_wind_machine_link"] = 0
	keyP["project_evacuate"] = 0
	keyP["follow_body_sense"] = 0
	keyP["exhaust_strength"] = 0
	keyP["modeValue"] = 0
	keyP["temperature"] = 0
	keyP["small_temperature"] = 0
	keyP["fanspeedValue"] = 0
	keyP["deHumidityValue"] = 0
	keyP["pm25LowValue"] = 0
	keyP["pm25HighValue"] = 0
	keyP["co2LowValue"] = 0
	keyP["co2HighValue"] = 0
	keyP["humidityValue"] = 0
	keyP["newWindModeValue"] = 0
	keyP["newWindSpeedValue"] = 0
	keyP["water_model_power"] = 0
	keyP["water_model_power_save"] = 0
	keyP["water_model_clean"] = 0
	keyP["water_model_clean_time"] = 0
	keyP["water_model_temperature_auto"] = 0
	keyP["water_model_ptc"] = 0
	keyP["water_model_go_out"] = 0
	keyP["water_model_temperature_set"] = 0
	keyP["water_model_mode_clash"] = 0
	keyP["air_optimization_temperature"] = 0
	keyP["air_optimization_humidity"] = 0
	keyP["air_optimization_wind"] = 0
	keyP["fanspeedRealValue"] = 0
	keyP["indoorTemperature"] = 0
	keyP["indoorPm25"] = 0
	keyP["indoorCo2"] = 0
	keyP["indoorTvoc"] = 0
	keyP["indoorHumidity"] = 0
	keyP["modeClashValue"] = 0
	keyP["filterTime"] = 0
	keyP["purifyFilterTime"] = 0
	keyP["freshFilterTime"] = 0
	keyP["filterTimeReset"] = 0
	keyP["purifyFilterTimeReset"] = 0
	keyP["freshFilterTimeReset"] = 0
	keyP["selfCleanState"] = 0
	keyP["selfCleanRunTime"] = 0
	keyP["freshLevel"] = 0
	keyP["purifierLevel"] = 0
	keyP["humidityLevel"] = 0
	keyP["temperatureLevel"] = 0
	keyP["tvocLevel"] = 0
	keyP["totalAirLevel"] = 0
	keyP["returnAirPanelSelect"] = 0
	keyP["airPanelSelect"] = 0
	keyP["noWindSenseSelect"] = 0
	keyP["windLeftRightSelect"] = 0
	keyP["has_purifier"] = 0
	keyP["humidifier_water_tank"] = 0
	keyP["auto_piping"] = 0
	keyP["force_drainage"] = 0
	keyP["prevent_condensation"] = 0
	keyP["water_tank_load"] = 0
	keyP["humidifier_over_flow_protect"] = 0
	keyP["heat_water_tank_protect"] = 0
	keyP["voltage_protect"] = 0
	keyP["ptc_protect"] = 0
	keyP["electric_leakage_protect"] = 0
	keyP["machine_electric_protect"] = 0
	keyP["relay_bonding_fault"] = 0
	keyP["humidifier_freezing_protect"] = 0
	keyP["error_linking_fault"] = 0
	keyP["zero_point_fault"] = 0
	keyP["humidity_sensor_lock"] = 0
	keyP["drain_valve_leakage"] = 0
	keyP["hydrate_valve_leakage"] = 0
	keyP["linking_humidifier_address"] = 0
	keyP["humidifier_temp_low"] = 0
	keyP["humidifier_temp_high"] = 0
	keyP["humidity_drainage"] = 0
	keyP["humidity_drainage_flag"] = 0
	keyP["humidity_sensor_fault"] = 0
	keyP["humidifier_communicate_fault"] = 0
	keyP["pm_sensor_chosen"] = 0
	keyP["co2_sensor_chosen"] = 0
	keyP["tvoc_sensor_chosen"] = 0
	keyP["pyroelectricity_sensor_chosen"] = 0
	keyP["thermopile_sensor_chosen"] = 0
	keyP["timer_enable"] = 0
	keyP["outdoorTemperature"] = 0
	keyP["freshAirMachineNumber"] = 0
	keyP["humidityMachineNumber"] = 0
	keyP["errorCode"] = 0
	keyP["indoor_e"] = 0
	keyP["indoor_e_parameter"] = 0
	keyP["in_out_transport"] = 0
	keyP["indoor_communication_lost"] = 0
	keyP["indoor_fan_lose_speed"] = 0
	keyP["indoor_new_wind_device"] = 0
	keyP["outdoor_new_wind_device"] = 0
	keyP["outdoor_e"] = 0
	keyP["sensor_t3"] = 0
	keyP["sensor_t4"] = 0
	keyP["sensor_tp"] = 0
	keyP["sensor_outdoor_ipm_temp"] = 0
	keyP["sensor_refrigerant_pipe_temp"] = 0
	keyP["sensor_cold_temp"] = 0
	keyP["sensor_inhale_temp"] = 0
	keyP["sensor_spray_enthalpy_enter_temp"] = 0
	keyP["sensor_spray_enthalpy_out_temp"] = 0
	keyP["sensor_high_pressure"] = 0
	keyP["sensor_low_pressure"] = 0
	keyP["sensor_t1"] = 0
	keyP["sensor_t2"] = 0
	keyP["new_wind_temp_sensor"] = 0
	keyP["wire_controller_temp_sensor"] = 0
	keyP["sensor_t2a_indoor"] = 0
	keyP["sensor_t2b_indoor"] = 0
	keyP["sensor_t2c_indoor"] = 0
	keyP["sensor_t2d_indoor"] = 0
	keyP["outdoor_fan_lose_speed"] = 0
	keyP["four_way_valve_crossing"] = 0
	keyP["wire_controller_indoor_transport"] = 0
	keyP["indoor_smart_eye_transport"] = 0
	keyP["indoor_pyroelectric_sensor"] = 0
	keyP["indoor_return_panel_transport"] = 0
	keyP["indoor_outlet_panel_transport"] = 0
	keyP["refrigerant_leakage"] = 0
	keyP["indoor_water_alarm"] = 0
	keyP["indoor_smart_eye"] = 0
	keyP["ammeter"] = 0
	keyP["in_out_ability_mismatch"] = 0
	keyP["outdoor_ipm"] = 0
	keyP["voltage_protect_low"] = 0
	keyP["voltage_protect_high"] = 0
	keyP["out_voltage_project"] = 0
	keyP["voltage_protect"] = 0
	keyP["compressor_temp_protect"] = 0
	keyP["out_main_drive_transport"] = 0
	keyP["compressor_current_circuit"] = 0
	keyP["compressor_start"] = 0
	keyP["phase_lost_protect"] = 0
	keyP["compressor_zero_protect"] = 0
	keyP["out_341_sync"] = 0
	keyP["compressor_lose_speed_protect"] = 0
	keyP["compressor_over_current"] = 0
	keyP["compressor_position_protect"] = 0
	keyP["compressor_high_temp_protect"] = 0
	keyP["out_current_protect"] = 0
	keyP["prevent_cold_wind_protect"] = 0
	keyP["water_full_protect"] = 0
	keyP["four_way_valve_crossing_protect"] = 0
	keyP["pfc_switch_stop"] = 0
	keyP["system_pressure_high_protect"] = 0
	keyP["system_pressure_low_protect"] = 0
	keyP["system_pressure_low_error"] = 0
	keyP["system_pressure_high_error"] = 0
	keyP["system_pressure_protect"] = 0
	keyP["evaporator_temp_high_protect"] = 0
	keyP["evaporator_temp_low_protect"] = 0
	keyP["new_wind_pm_high_protect"] = 0
	keyP["new_wind_out_temp_high_protect"] = 0
	keyP["new_wind_out_temp_low_protect"] = 0
	keyP["new_wind_anti_condensation_protect"] = 0
	keyP["new_wind_low_anti_condensation_protect"] = 0
	keyP["grid_protect"] = 0
	keyP["refrigerant_tube_condensation"] = 0
	keyP["indoor_hum_sensor"] = 0
	keyP["new_wind_hum_sensor"] = 0
	keyP["pm2_5_sensor"] = 0
	keyP["co2_sensor"] = 0
	keyP["tvoc_sensor"] = 0
	keyP["new_wind_pm2_5_sensor"] = 0
	keyP["evaporator_temp_fre_limit"] = 0
	keyP["new_wind_pm_high"] = 0
	keyP["new_wind_out_low_temp"] = 0
	keyP["condenser_high_temp_fre_limit"] = 0
	keyP["exhaust_high_temp_fre_limit"] = 0
	keyP["voltage_fre_limit"] = 0
	keyP["current_fre_limit"] = 0
	keyP["pfc_fre_limit"] = 0
	keyP["system_pressure_high_fre_limit"] = 0
	keyP["system_pressure_low_fre_limit"] = 0
	keyP["mode_conflict"] = 0
	keyP["new_wind_transport"] = 0
	keyP["outdoor_exhaust_high_temp_fault"] = 0
	keyP["refrigerant_tube_condensation_fault"] = 0
	keyP["system_pressure_low_pressure_fault"] = 0
	keyP["indoor_e_water_heat"] = 0
	keyP["indoor_e_parameter_water_heat"] = 0
	keyP["in_out_transport_water_heat"] = 0
	keyP["tr_out_fault"] = 0
	keyP["tr_in_fault"] = 0
	keyP["dc_pump_stall_protection"] = 0
	keyP["water_switch_protection"] = 0
	keyP["water_switch_fault"] = 0
	keyP["tw_in_fault"] = 0
	keyP["tw_out_fault"] = 0
	keyP["tw1_fault"] = 0
	keyP["tw1b_fault"] = 0
	keyP["standby_anti_freezing_fault"] = 0
	keyP["temp_sensor_drop_fault"] = 0
	keyP["water_templow_protection"] = 0
	keyP["standby_anti_freezing_protection"] = 0
	keyP["humidity_enabling"] = 0
	keyP["power_on_timer"] = 0
	keyP["power_off_timer"] = 0
	keyP["sn8_string"] = "00000000"
	keyP["sn8_flag"] = 0
	keyP["power_on_time_value"] = 0
	keyP["power_off_time_value"] = 0
	keyP["humidifier_indoor_transport"] = 0
	keyP["humidifier_water_sensor_fault"] = 0
	keyP["humidifier_sensor_fault"] = 0
	keyP["comfortableSleepValue"] = 0
	keyP["up_down_wind_direction"] = 0
	keyP["left_right_wind_direction"] = 0
	keyP["comfortableSleepTime"] = 0x08
	keyP["cold_fault"] = 0
	keyP["stop_warm"] = 0
	keyP["has_stop_warm"] = 0
	keyP["water_mode"] = 0
	keyP["water_full_fault"] = 0
	keyP["week1_timer1"] = 0
	keyP["week1_timer2"] = 0
	keyP["week1_timer3"] = 0
	keyP["week1_timer4"] = 0
	keyP["week1_timer5"] = 0
	keyP["week2_timer1"] = 0
	keyP["week2_timer2"] = 0
	keyP["week2_timer3"] = 0
	keyP["week2_timer4"] = 0
	keyP["week2_timer5"] = 0
	keyP["week3_timer1"] = 0
	keyP["week3_timer2"] = 0
	keyP["week3_timer3"] = 0
	keyP["week3_timer4"] = 0
	keyP["week3_timer5"] = 0
	keyP["week4_timer1"] = 0
	keyP["week4_timer2"] = 0
	keyP["week4_timer3"] = 0
	keyP["week4_timer4"] = 0
	keyP["week4_timer5"] = 0
	keyP["week5_timer1"] = 0
	keyP["week5_timer2"] = 0
	keyP["week5_timer3"] = 0
	keyP["week5_timer4"] = 0
	keyP["week5_timer5"] = 0
	keyP["week6_timer1"] = 0
	keyP["week6_timer2"] = 0
	keyP["week6_timer3"] = 0
	keyP["week6_timer4"] = 0
	keyP["week6_timer5"] = 0
	keyP["week0_timer1"] = 0
	keyP["week0_timer2"] = 0
	keyP["week0_timer3"] = 0
	keyP["week0_timer4"] = 0
	keyP["week0_timer5"] = 0
	keyP["week1_timer1_open_hour"] = 0
	keyP["week1_timer1_open_min"] = 0
	keyP["week1_timer1_close_hour"] = 0
	keyP["week1_timer1_close_min"] = 0
	keyP["week1_timer1_temperature"] = 0
	keyP["week1_timer2_open_hour"] = 0
	keyP["week1_timer2_open_min"] = 0
	keyP["week1_timer2_close_hour"] = 0
	keyP["week1_timer2_close_min"] = 0
	keyP["week1_timer2_temperature"] = 0
	keyP["week1_timer3_open_hour"] = 0
	keyP["week1_timer3_open_min"] = 0
	keyP["week1_timer3_close_hour"] = 0
	keyP["week1_timer3_close_min"] = 0
	keyP["week1_timer3_temperature"] = 0
	keyP["week1_timer4_open_hour"] = 0
	keyP["week1_timer4_open_min"] = 0
	keyP["week1_timer4_close_hour"] = 0
	keyP["week1_timer4_close_min"] = 0
	keyP["week1_timer4_temperature"] = 0
	keyP["week1_timer5_open_hour"] = 0
	keyP["week1_timer5_open_min"] = 0
	keyP["week1_timer5_close_hour"] = 0
	keyP["week1_timer5_close_min"] = 0
	keyP["week1_timer5_temperature"] = 0
	keyP["week2_timer1_open_hour"] = 0
	keyP["week2_timer1_open_min"] = 0
	keyP["week2_timer1_close_hour"] = 0
	keyP["week2_timer1_close_min"] = 0
	keyP["week2_timer1_temperature"] = 0
	keyP["week2_timer2_open_hour"] = 0
	keyP["week2_timer2_open_min"] = 0
	keyP["week2_timer2_close_hour"] = 0
	keyP["week2_timer2_close_min"] = 0
	keyP["week2_timer2_temperature"] = 0
	keyP["week2_timer3_open_hour"] = 0
	keyP["week2_timer3_open_min"] = 0
	keyP["week2_timer3_close_hour"] = 0
	keyP["week2_timer3_close_min"] = 0
	keyP["week2_timer3_temperature"] = 0
	keyP["week2_timer4_open_hour"] = 0
	keyP["week2_timer4_open_min"] = 0
	keyP["week2_timer4_close_hour"] = 0
	keyP["week2_timer4_close_min"] = 0
	keyP["week2_timer4_temperature"] = 0
	keyP["week2_timer5_open_hour"] = 0
	keyP["week2_timer5_open_min"] = 0
	keyP["week2_timer5_close_hour"] = 0
	keyP["week2_timer5_close_min"] = 0
	keyP["week2_timer5_temperature"] = 0
	keyP["week3_timer1_open_hour"] = 0
	keyP["week3_timer1_open_min"] = 0
	keyP["week3_timer1_close_hour"] = 0
	keyP["week3_timer1_close_min"] = 0
	keyP["week3_timer1_temperature"] = 0
	keyP["week3_timer2_open_hour"] = 0
	keyP["week3_timer2_open_min"] = 0
	keyP["week3_timer2_close_hour"] = 0
	keyP["week3_timer2_close_min"] = 0
	keyP["week3_timer2_temperature"] = 0
	keyP["week3_timer3_open_hour"] = 0
	keyP["week3_timer3_open_min"] = 0
	keyP["week3_timer3_close_hour"] = 0
	keyP["week3_timer3_close_min"] = 0
	keyP["week3_timer3_temperature"] = 0
	keyP["week3_timer4_open_hour"] = 0
	keyP["week3_timer4_open_min"] = 0
	keyP["week3_timer4_close_hour"] = 0
	keyP["week3_timer4_close_min"] = 0
	keyP["week3_timer4_temperature"] = 0
	keyP["week3_timer5_open_hour"] = 0
	keyP["week3_timer5_open_min"] = 0
	keyP["week3_timer5_close_hour"] = 0
	keyP["week3_timer5_close_min"] = 0
	keyP["week3_timer5_temperature"] = 0
	keyP["week4_timer1_open_hour"] = 0
	keyP["week4_timer1_open_min"] = 0
	keyP["week4_timer1_close_hour"] = 0
	keyP["week4_timer1_close_min"] = 0
	keyP["week4_timer1_temperature"] = 0
	keyP["week4_timer2_open_hour"] = 0
	keyP["week4_timer2_open_min"] = 0
	keyP["week4_timer2_close_hour"] = 0
	keyP["week4_timer2_close_min"] = 0
	keyP["week4_timer2_temperature"] = 0
	keyP["week4_timer3_open_hour"] = 0
	keyP["week4_timer3_open_min"] = 0
	keyP["week4_timer3_close_hour"] = 0
	keyP["week4_timer3_close_min"] = 0
	keyP["week4_timer3_temperature"] = 0
	keyP["week4_timer4_open_hour"] = 0
	keyP["week4_timer4_open_min"] = 0
	keyP["week4_timer4_close_hour"] = 0
	keyP["week4_timer4_close_min"] = 0
	keyP["week4_timer4_temperature"] = 0
	keyP["week4_timer5_open_hour"] = 0
	keyP["week4_timer5_open_min"] = 0
	keyP["week4_timer5_close_hour"] = 0
	keyP["week4_timer5_close_min"] = 0
	keyP["week4_timer5_temperature"] = 0
	keyP["week5_timer1_open_hour"] = 0
	keyP["week5_timer1_open_min"] = 0
	keyP["week5_timer1_close_hour"] = 0
	keyP["week5_timer1_close_min"] = 0
	keyP["week5_timer1_temperature"] = 0
	keyP["week5_timer2_open_hour"] = 0
	keyP["week5_timer2_open_min"] = 0
	keyP["week5_timer2_close_hour"] = 0
	keyP["week5_timer2_close_min"] = 0
	keyP["week5_timer2_temperature"] = 0
	keyP["week5_timer3_open_hour"] = 0
	keyP["week5_timer3_open_min"] = 0
	keyP["week5_timer3_close_hour"] = 0
	keyP["week5_timer3_close_min"] = 0
	keyP["week5_timer3_temperature"] = 0
	keyP["week5_timer4_open_hour"] = 0
	keyP["week5_timer4_open_min"] = 0
	keyP["week5_timer4_close_hour"] = 0
	keyP["week5_timer4_close_min"] = 0
	keyP["week5_timer4_temperature"] = 0
	keyP["week5_timer5_open_hour"] = 0
	keyP["week5_timer5_open_min"] = 0
	keyP["week5_timer5_close_hour"] = 0
	keyP["week5_timer5_close_min"] = 0
	keyP["week5_timer5_temperature"] = 0
	keyP["week6_timer1_open_hour"] = 0
	keyP["week6_timer1_open_min"] = 0
	keyP["week6_timer1_close_hour"] = 0
	keyP["week6_timer1_close_min"] = 0
	keyP["week6_timer1_temperature"] = 0
	keyP["week6_timer2_open_hour"] = 0
	keyP["week6_timer2_open_min"] = 0
	keyP["week6_timer2_close_hour"] = 0
	keyP["week6_timer2_close_min"] = 0
	keyP["week6_timer2_temperature"] = 0
	keyP["week6_timer3_open_hour"] = 0
	keyP["week6_timer3_open_min"] = 0
	keyP["week6_timer3_close_hour"] = 0
	keyP["week6_timer3_close_min"] = 0
	keyP["week6_timer3_temperature"] = 0
	keyP["week6_timer4_open_hour"] = 0
	keyP["week6_timer4_open_min"] = 0
	keyP["week6_timer4_close_hour"] = 0
	keyP["week6_timer4_close_min"] = 0
	keyP["week6_timer4_temperature"] = 0
	keyP["week6_timer5_open_hour"] = 0
	keyP["week6_timer5_open_min"] = 0
	keyP["week6_timer5_close_hour"] = 0
	keyP["week6_timer5_close_min"] = 0
	keyP["week6_timer5_temperature"] = 0
	keyP["week0_timer1_open_hour"] = 0
	keyP["week0_timer1_open_min"] = 0
	keyP["week0_timer1_close_hour"] = 0
	keyP["week0_timer1_close_min"] = 0
	keyP["week0_timer1_temperature"] = 0
	keyP["week0_timer2_open_hour"] = 0
	keyP["week0_timer2_open_min"] = 0
	keyP["week0_timer2_close_hour"] = 0
	keyP["week0_timer2_close_min"] = 0
	keyP["week0_timer2_temperature"] = 0
	keyP["week0_timer3_open_hour"] = 0
	keyP["week0_timer3_open_min"] = 0
	keyP["week0_timer3_close_hour"] = 0
	keyP["week0_timer3_close_min"] = 0
	keyP["week0_timer3_temperature"] = 0
	keyP["week0_timer4_open_hour"] = 0
	keyP["week0_timer4_open_min"] = 0
	keyP["week0_timer4_close_hour"] = 0
	keyP["week0_timer4_close_min"] = 0
	keyP["week0_timer4_temperature"] = 0
	keyP["week0_timer5_open_hour"] = 0
	keyP["week0_timer5_open_min"] = 0
	keyP["week0_timer5_close_hour"] = 0
	keyP["week0_timer5_close_min"] = 0
	keyP["week0_timer5_temperature"] = 0
	keyP["week0_duplicate_timer_on_1"] = 0
	keyP["week0_duplicate_timer_off_2"] = 0
	keyP["week1_duplicate_timer_on_1"] = 0
	keyP["week1_duplicate_timer_off_2"] = 0
	keyP["week2_duplicate_timer_on_1"] = 0
	keyP["week2_duplicate_timer_off_2"] = 0
	keyP["week3_duplicate_timer_on_1"] = 0
	keyP["week3_duplicate_timer_off_2"] = 0
	keyP["week4_duplicate_timer_on_1"] = 0
	keyP["week4_duplicate_timer_off_2"] = 0
	keyP["week5_duplicate_timer_on_1"] = 0
	keyP["week5_duplicate_timer_off_2"] = 0
	keyP["week6_duplicate_timer_on_1"] = 0
	keyP["week6_duplicate_timer_off_2"] = 0
	keyP["timer_control"] = 0
	keyP["in_outdoor_fault"] = 0
	keyP["t2w_fault"] = 0
	keyP["water_model_flag"] = 0
	keyP["colmo_in_machine"] = 0
	keyP["eco"] = 0
	keyP["prevent_super_cool"] = 0
	keyP["has_eco"] = 0
	keyP["has_prevent_super_cool"] = 0
	keyP["ptc_status"] = 0
	keyP["has_xinfeng"] = 1
	keyP["has_huifeng"] = 1
	keyP["has_chufeng"] = 1
	keyP["has_water_model"] = 1
	keyP["fresh_air_remove_odor"] = 0
	keyP["dry_type"] = 0
	keyP["auto_inner_cycle"] = 0
	keyP["anion_status"] = 0
	keyP["has_inner_cycle"] = 0
	keyP["has_remove_odor"] = 0
	keyP["inner_cycle_mode"] = 0
	keyP["inner_cycle_switch"] = 0
	keyP["water_model_prevent_cold_protect"] = 0
	keyP["wire_controller_indoor_transport_ten"] = 0
	keyP["total_time_switch"] = 0
	keyP["airoptimization_or_total_time"] = 0
	keyP["total_time_support"] = 0
	keyP["remove_arofene"] = 0
	keyP["has_remove_arofene"] = 0
	keyP["total_elec"] = 0
	keyP["voice_control"] = 0
	keyP["voice_control_speaking"] = 0
	keyP["has_voice_control"] = 0
	keyP["machine_type"] = 0
	keyP["has_common_remove_odor"] = 0
	keyP["has_fresh_air_link"] = 0
	keyP["fengguan_remove_odor"] = 0
	keyP["support_magic_cube"] = 0
	keyP["has_ptc"] = 0
	keyP["timer_announcement"] = 0
	keyP["new_home_remove_arofene"] = 0
	keyP["new_home_remove_arofene_exit"] = 0
	keyP["shortest_remove_odor_time"] = 0
	keyP["longest_remove_odor_time"] = 0
	keyP["has_water_model_timer"] = 0
	keyP["has_weekly_timer_water"] = 0
	keyP["has_new_home_remove_arofene"] = 0
	keyP["has_new_home_remove_arofene_water"] = 0
	keyP["remove_odor_run_time"] = 0
	keyP["smart_humi_control"] = 0
	keyP["control_flag"] = 0
	keyP["smart_humi_control_algorithm"] = 0
	keyP["has_smart_humi_control"] = 0
	keyP["fresh_air_intake_wind"] = 0
	keyP["fresh_air_exhaust_wind"] = 0
	keyP["fengguan_has_water_timer_right"] = 0
	keyP["out_mode"] = 0
	keyP["new_wind_humidity"] = 0
	keyP["new_wind_outdoor_temperature"] = 0
	keyP["energy_new_wind"] = 0
	keyP["new_wind_model_intake_switch"] = 0
	keyP["new_wind_model_exhaust_switch"] = 0
	keyP["new_wind_model_mute"] = 0
	keyP["tube_protect"] = 0
	keyP["new_wind_model_on_timer"] = 0
	keyP["new_wind_model_off_timer"] = 0
	keyP["new_wind_model_intake_wind"] = 0
	keyP["new_wind_model_exhaust_wind"] = 0
	keyP["new_wind_model_on_timer_value"] = 0
	keyP["new_wind_model_off_timer_value"] = 0
	keyP["has_weekly_timer"] = 0
	keyP["has_personality_dry"] = 0
	keyP["has_comfort_dry"] = 0
	keyP["has_new_wind_purifier"] = 0
	keyP["has_exhaust_wind"] = 0
	keyP["has_tube_protect"] = 0
	keyP["new_wind_model_wind_machine_fault"] = 0
	keyP["new_wind_model_anti_condensation_protect"] = 0
	keyP["new_wind_model_temp_low_protect"] = 0
	keyP["new_wind_model_temp_high_protect"] = 0
	keyP["new_wind_model_hum_sensor"] = 0
	keyP["new_wind_model_temp_sensor"] = 0
	keyP["new_wind_model_e_fault"] = 0
	keyP["new_wind_model_param_fault"] = 0
	keyP["new_wind_model_timer_effect"] = 0
	keyP["new_wind_model_fresh_filter"] = 0
	keyP["energy_need"] = 0
	keyP["temp_compensation"] = 0
	keyP["indoor_outdoor_fault"] = 0
	keyP["new_wind_indoor_fault"] = 0
	keyP["indoor_lack_fault"] = 0
	keyP["no_wind_swing_ud"] = 0
	keyP["control_c006"] = 0
	keyP["product_type"] = 0
	keyP["indoor_machine_one_speed"] = 0
	keyP["indoor_machine_two_speed"] = 0
	keyP["indoor_elec_expansion_valve_one"] = 0
	keyP["indoor_elec_expansion_valve_two"] = 0
	keyP["in_water_pump_force"] = 0
	keyP["out_water_pump_force"] = 0
	keyP["energy_need_c0"] = 0
	keyP["ptc_support_force"] = 0
	keyP["indoor_lr_wind_angle"] = 0
	keyP["indoor_ud_wind_angle"] = 0
	keyP["fengguan_one_speed_enable"] = 0
	keyP["fengguan_two_speed_enable"] = 0
	keyP["new_wind_two_speed_enable"] = 0
	keyP["new_wind_one_speed_enable"] = 0
	keyP["new_wind_model_gate"] = 0
	keyP["remove_odor_c0"] = 0
	keyP["force_wind_machine_one_speed"] = 0
	keyP["force_wind_machine_two_speed"] = 0
	keyP["force_expansion_valve_one_speed"] = 0
	keyP["force_expansion_valve_two_speed"] = 0
	keyP["in_water_pump"] = 0
	keyP["out_water_pump"] = 0
	keyP["ptc_support"] = 0
	keyP["indoor_energy_need"] = 0
	keyP["wind_swing_lr_c0"] = 0
	keyP["wind_swing_ud_c0"] = 0
	keyP["fengguan_indoor_one_speed_level"] = 0
	keyP["fengguan_indoor_two_speed_level"] = 0
	keyP["female_care"] = 0
	keyP["has_female_care"] = 0
	keyP["target_machine_info"] = 0
	keyP["machine_level"] = 0
	keyP["has_heater"] = 0
	keyP["has_shunt_valve"] = 0
	keyP["heater_heating_switch"] = 0
	keyP["fg_timer_number"] = 0
	keyP["fg_timer1_week0_effect"] = 0
	keyP["fg_timer1_week1_effect"] = 0
	keyP["fg_timer1_week2_effect"] = 0
	keyP["fg_timer1_week3_effect"] = 0
	keyP["fg_timer1_week4_effect"] = 0
	keyP["fg_timer1_week5_effect"] = 0
	keyP["fg_timer1_week6_effect"] = 0
	keyP["fg_timer1_select"] = 0
	keyP["fg_timer1_wind_speed"] = 0
	keyP["fg_timer1_power"] = 0
	keyP["fg_timer1_mode"] = 0
	keyP["fg_timer1_temperature"] = 0
	keyP["fg_timer1_hour"] = 0
	keyP["fg_timer1_min"] = 0
	keyP["fg_timer2_week0_effect"] = 0
	keyP["fg_timer2_week1_effect"] = 0
	keyP["fg_timer2_week2_effect"] = 0
	keyP["fg_timer2_week3_effect"] = 0
	keyP["fg_timer2_week4_effect"] = 0
	keyP["fg_timer2_week5_effect"] = 0
	keyP["fg_timer2_week6_effect"] = 0
	keyP["fg_timer2_select"] = 0
	keyP["fg_timer2_wind_speed"] = 0
	keyP["fg_timer2_power"] = 0
	keyP["fg_timer2_mode"] = 0
	keyP["fg_timer2_temperature"] = 0
	keyP["fg_timer2_hour"] = 0
	keyP["fg_timer2_min"] = 0
	keyP["has_fg_timer"] = 0
	keyP["radar_install_status"] = 0
	keyP["radar_monitor_people_status_report"] = 0
	keyP["nobody_off_status"] = 0
	keyP["pack_id"] = 0
	keyP["machine_address"] = 0xff
	keyP["c0_control_result"] = 0
	keyP["airoptimization_unsupport"] = 0
	keyP["stop_warm_support"] = 0
	keyP["water_temp_linkage_support"] = 0
	keyP["water_temp_linkage_switch"] = 0
	keyP["water_model_dry"] = 0
	keyP["smart_water_model"] = 0
	keyP["water_model_force_temp"] = 0
	keyP["tw1_in_water_temp"] = 0
	keyP["tw1_out_water_temp"] = 0
	keyP["water_model_machine_level"] = 0
	keyP["t2_temp"] = 0
	keyP["t2b_temp"] = 0
	keyP["tw_out_water_temp"] = 0
	keyP["smart_hybird_status"] = 0
	keyP["double_engine_heat_status"] = 0
	keyP["water_model_temperature_set_12"] = 0
	keyP["power_enable"] = 0
	keyP["mute"] = 0
	keyP["mute_enable"] = 0
	keyP["no_wind_sense_enable"] = 0
	keyP["dry_enable"] = 0
	keyP["follow_body_sense_enable"] = 0
	keyP["cool_hot_sense_enable"] = 0
	keyP["wind_swing_lr_enable"] = 0
	keyP["wind_swing_ud_enable"] = 0
	keyP["ptc_enable"] = 0
	keyP["ptc_dependT4_enable"] = 0
	keyP["wind_straight_enable"] = 0
	keyP["wind_avoid_enable"] = 0
	keyP["disinfect_enable"] = 0
	keyP["energy_save_enable"] = 0
	keyP["nobody_energy_save_enable"] = 0
	keyP["inner_purifier_enable"] = 0
	keyP["manu_inner_purifier_enable"] = 0
	keyP["auto_humi_enable"] = 0
	keyP["manul_humi_enable"] = 0
	keyP["new_wind_machine_enable"] = 0
	keyP["new_wind_machine_link_enable"] = 0
	keyP["fresh_air_remove_odor_enable"] = 0
	keyP["stop_warm_enable"] = 0
	keyP["eco_enable"] = 0
	keyP["prevent_super_cool_enable"] = 0
	keyP["new_wind_model_mute_enable"] = 0
	keyP["new_wind_model_exhaust_switch_enable"] = 0
	keyP["new_wind_model_intake_switch_enable"] = 0
	keyP["tube_protect_enable"] = 0
	keyP["quick_fry_enable"] = 0
	keyP["quick_fry"] = 0
	keyP["prepare_food_enable"] = 0
	keyP["prepare_food"] = 0
	keyP["mode_enable"] = 0
	keyP["temperature_enable"] = 0
	keyP["wind_speed_enable"] = 0
	keyP["humidity_enable"] = 0
	keyP["dehumidity_enable"] = 0
	keyP["power_on_timer_enable"] = 0
	keyP["power_off_timer_enable"] = 0
	keyP["new_wind_model_on_timer_enable"] = 0
	keyP["new_wind_model_off_timer_enable"] = 0
	keyP["comfort_sleep_enable"] = 0
	keyP["buzzer_enable"] = 0
	keyP["voice_control_enable"] = 0
	keyP["water_model_power_enable"] = 0
	keyP["water_model_clean_enable"] = 0
	keyP["water_model_power_save_enable"] = 0
	keyP["water_model_temperature_auto_enable"] = 0
	keyP["water_model_ptc_enable"] = 0
	keyP["water_model_go_out_enable"] = 0
	keyP["left_right_wind_direction_enable"] = 0
	keyP["up_down_wind_direction_enable"] = 0
	keyP["water_model_temperature_set_enable"] = 0
	keyP["water_mode_enable"] = 0
	keyP["fresh_air_mode_enable"] = 0
	keyP["fresh_air_fan_speed_enable"] = 0
	keyP["single_control"] = 0
	keyP["has_prepare_food"] = 0
	keyP["has_quick_fry"] = 0
	keyP["has_wind_swing_lr"] = 0
	keyP["has_wind_swing_ud"] = 0
	keyP["has_ptc"] = 0
	keyP["has_strong_wind"] = 0
	keyP["defrosting_display"] = 0
	keyP["new_wind_machine_enable"] = 0
	keyP["new_wind_machine_exhaust_switch_enable"] = 0
	keyP["new_wind_machine_exhaust_switch"] = 0
	keyP["new_wind_machine_intake_switch_enable"] = 0
	keyP["new_wind_machine_intake_switch"] = 0
	keyP["fresh_air_exhaust_fan_speed"] = 0
	keyP["fresh_air_exhaust_fan_speed_enable"] = 0
	keyP["fresh_air_intake_fan_speed"] = 0
	keyP["fresh_air_intake_fan_speed_enable"] = 0
	keyP["has_fresh_air_exhaust_fan_speed"] = 0
	keyP["has_fresh_air_intake_fan_speed"] = 0
	keyP["has_fresh_air_mode"] = 0
	keyP["has_new_wind_machine_exhaust_switch"] = 0
	keyP["has_new_wind_machine_intake_switch"] = 0
	keyP["has_fresh_air_remove_odor"] = 0
	keyP["has_new_wind_machine"] = 0
	keyP["new_wind_machine_type"] = 0
	keyP["has_fengguan_mini_new_wind"] = 0
	keyP["has_mini_new_wind"] = 0
	keyP["fengguan_type"] = 0
	keyP["network_sn"] = nil
	keyP["save_energy_mode_effective_countdown"] = 0
	keyP["nobody_off_switch"] = 0
	keyP["save_energy_mode_effective_countdown_setting_enable"] = 0
	keyP["nobody_off_switch_setting_enable"] = 0
	keyP["nobody_off_time_setting_enable"] = 0
	keyP["nobody_off_time"] = 0
	keyP["follow_body_sense_enable"] = 0
	keyP["has_follow_body_sense"] = 0
	keyP["double_engine_heat"] = 0
	keyP["has_double_engine_heat"] = 0
	keyP["double_engine_heat_enable"] = 0
	keyP["smart_hybird"] = 0
	keyP["has_smart_hybird"] = 0
	keyP["smart_hybird_enable"] = 0
	keyP["smart_hybird_pause"] = 0
	keyP["c003_protocol_support"] = 0
	keyP["c003_protocol_inner_support"] = 0
	keyP["new_wind_machine_operating_mode"] = 0
	keyP["special_machine_type"] = 0
	keyP["has_water_model_temperature_set"] = 0
	keyP["has_water_mode"] = 0
	keyP["no_wind_swing_ud_support"] = 0
	keyP["humidity_switch_fault"] = 0
	keyP["inner_machine_type"] = 0
	keyP["independent_strong_support"] = 0
	keyP["keep_warm"] = 0
	keyP["has_keep_warm"] = 0
	keyP["fast_heat"] = 0
	keyP["has_fast_heat"] = 0
	keyP["ventilator"] = 0
	keyP["ventilator_level"] = 0
	keyP["has_ventilator"] = 0
	keyP["fast_heat_angle"] = 0
	keyP["has_fast_heat_angle"] = 0
	keyP["close_huanqi_time"] = 0
	keyP["has_close_huanqi_time"] = 0
	keyP["target_temp_up"] = 0
	keyP["target_temp_down"] = 0
	keyP["huanqi_fault"] = 0
	keyP["remote_switch"] = 0
	keyP["has_prevent_straight_wind"] = 0
	keyP["prevent_straight_wind"] = 0
	keyP["prevent_straight_wind_enable"] = 0
	keyP["has_independent_swing"] = 0
	keyP["independent_swing_enable"] = 0
	keyP["up_swing"] = 0
	keyP["down_swing"] = 0
	keyP["left_swing"] = 0
	keyP["right_swing"] = 0
	keyP["up_swing_angle"] = 0
	keyP["down_swing_angle"] = 0
	keyP["left_swing_angle"] = 0
	keyP["right_swing_angle"] = 0
	keyP["mode_select"] = 0
	keyP["has_dryconstant"] = 0
	keyP["has_smart_dry"] = 0
	keyP["has_dryauto"] = 0
	keyP["has_individual_dry"] = 0
	keyP["has_heat"] = 0
	keyP["has_dry"] = 0
	keyP["has_cool"] = 0
	keyP["has_auto"] = 0
	keyP["has_smart_mode"] = 0
	keyP["has_new_wind_huanqi"] = 0
	keyP["has_new_wind_humidity"] = 0
	keyP["has_new_wind_dehumidity"] = 0
	keyP["has_self_clean"] = 0
	keyP["has_fan"] = 0
	keyP["has_heat_change"] = 0
	keyP["has_slow_wind"] = 0
	keyP["has_fast_wind"] = 0
	keyP["has_slow_exhaust_wind"] = 0
	keyP["has_fast_exhaust_wind"] = 0
	keyP["has_strong_mode"] = 0
	keyP["has_holiday_mode"] = 0
	keyP["target_address"] = 0
	keyP["has_purifier_odor"] = 0
	keyP["purifier_odor_filter_time"] = 0
	keyP["purifier_odor_filter_reset"] = 0
	keyP["c002_dry_type_support"] = 0
	keyP["dry_type_control"] = 0
	keyP["ieco_switch"] = 0
	keyP["ieco_indoor_wind_speed_level"] = 0
	keyP["ieco_target_rate"] = 0
	keyP["has_passive_remove_odor_model"] = 0
	keyP["ieco_strong_wind"] = 0
	keyP["ieco_enable"] = 0
	keyP["has_ieco"] = 0
	keyP["has_mode_memory"] = 0
	keyP["mode_memory_enable"] = 0
	keyP["has_ptc_memory"] = 0
	keyP["run_mode"] = 0
	keyP["auto_mode_dry_support"] = 0
	keyP["auto_mode_wind_support"] = 0
	keyP["smart_frequency_conversion"] = 0
	keyP["ai_humidity_control"] = 0
	keyP["ptc_mode"] = 1
	keyP["down_vertical_wind_direction"] = 0
	keyP["down_horizontal_wind_direction"] = 0
	keyP["down_wind_swing_lr"] = 0
	keyP["down_wind_swing_ud"] = 0
	keyP["down_wind_switch"] = 0
	keyP["side_wind_switch"] = 0
	keyP["has_ptc_mode"] = 0
	keyP["has_4c_query"] = 0
	keyP["has_ai_humidity_control"] = 0
	keyP["ai_humidity_control_enable"] = 0
	keyP["has_down_wind_switch"] = 0
	keyP["has_side_wind_switch"] = 0
	keyP["has_down_wind_swing_lr"] = 0
	keyP["has_down_wind_swing_ud"] = 0
	keyP["has_15_query"] = 0
	keyP["radar_sensor_fault"] = 0
	keyP["buzzer_off_status"] = 0
	keyP["has_indoor_humidity_sensor"] = 0
	keyP["has_51_query"] = 0
	keyP["self_clean_version"] = 0
	keyP["has_wind_avoid"] = 0
	keyP["has_wind_straight"] = 0
	keyP["no_nobody_energy_save_support"] = 0
	keyP["no_cool_hot_sense_support"] = 0
	keyP["buzzer_control"] = 0
	keyP["request_smart_frequency_conversion_status"] = 0
	keyP["smart_frequency_conversion_status"] = 0
	keyP["power_tip_light_switch"] = 0
	keyP["has_power_tip_light_switch"] = 0
	keyP["has_elec_query"] = 0
	keyP["sense_target"] = 0
	keyP["sense_distance"] = 0
	keyP["target1_distance"] = 0
	keyP["target1_angle"] = 0
	keyP["target2_distance"] = 0
	keyP["target2_angle"] = 0
	keyP["target3_distance"] = 0
	keyP["target3_angle"] = 0
	keyP["target4_distance"] = 0
	keyP["target4_angle"] = 0
	keyP["target5_distance"] = 0
	keyP["target5_angle"] = 0
	keyP["target1_area_tag"] = 0
	keyP["target2_area_tag"] = 0
	keyP["target3_area_tag"] = 0
	keyP["target4_area_tag"] = 0
	keyP["target5_area_tag"] = 0
	keyP["guide_strip_lr_close"] = 0
	keyP["smart_wind_sensitivity"] = 0
	keyP["smart_wind"] = 0
	keyP["human_close_gentle_wind"] = 0
	keyP["smart_wind_current_status"] = 0
	keyP["remote_receive_switch"] = 0
	keyP["power_off_mode_enable_switch"] = 0
	keyP["has_remote_receive_switch"] = 0
	keyP["has_power_off_mode_enable_switch"] = 0
	keyP["care_mode_switch"] = 0
	keyP["child_old_care_mode_switch"] = 0
	keyP["has_care_mode_temp"] = 0
	keyP["has_care_mode_limit"] = 0
	keyP["has_care_mode_gentle_wind"] = 0
	keyP["has_care_mode_prevent_straight_wind"] = 0
	keyP["has_care_mode_no_wind_sense"] = 0
	keyP["care_mode_ban_mode_select"] = 0
	keyP["care_mode_temp_min"] = 0
	keyP["care_mode_temp_max"] = 0
	keyP["care_mode_gentle_wind_min"] = 0
	keyP["care_mode_gentle_wind_max"] = 0
	keyP["has_child_care_mode_temp"] = 0
	keyP["has_child_care_mode_limit"] = 0
	keyP["has_child_care_mode_gentle_wind"] = 0
	keyP["has_child_care_mode_prevent_straight_wind"] = 0
	keyP["has_child_care_mode_no_wind_sense"] = 0
	keyP["child_care_mode_ban_mode_select"] = 0
	keyP["child_care_mode_temp_min"] = 0
	keyP["child_care_mode_temp_max"] = 0
	keyP["child_care_mode_gentle_wind_min"] = 0
	keyP["child_care_mode_gentle_wind_max"] = 0
	keyP["has_old_care_mode_temp"] = 0
	keyP["has_old_care_mode_limit"] = 0
	keyP["has_old_care_mode_gentle_wind"] = 0
	keyP["has_old_care_mode_prevent_straight_wind"] = 0
	keyP["has_old_care_mode_no_wind_sense"] = 0
	keyP["old_care_mode_ban_mode_select"] = 0
	keyP["old_care_mode_temp_min"] = 0
	keyP["old_care_mode_temp_max"] = 0
	keyP["old_care_mode_gentle_wind_min"] = 0
	keyP["old_care_mode_gentle_wind_max"] = 0
	keyP["has_care_mode"] = 0
	keyP["eh3a_fault"] = 0
	keyP["eh3b_fault"] = 0
	keyP["has_prevent_wrong_tip_function"] = 0
	keyP["has_31_query"] = 0
	keyP["has_c004_control"] = 0
	keyP["ai_energy_save"] = 0
	keyP["ai_energy_save_func"] = 0
	keyP["has_support_self_clean_func"] = 0
	keyP["nobody_power_off_reduce_time_switch"] = 0
	keyP["has_nobody_power_off_reduce_time_switch"] = 0
	keyP["f8_control"] = 0
	keyP["f8_temperature"] = 0
	keyP["f8_humidity"] = 0
	keyP["f8_tvoc"] = 0
	keyP["f8_pm25_value"] = 0
	keyP["f8_co2_value"] = 0
	keyP["f8_arofene"] = 0
	keyP["sensor_status"] = 0
	keyP["timestamp"] = 0
	keyP["offset"] = 0
	keyP["binding_status"] = 0
	keyP["mac_value"] = 0
	keyP["magic_cube_sn"] = 0
	keyP["has_sn"] = 0
	keyP["binding_type"] = 0
end
local function timer_init()
	keyP["week1_timer1"] = 0
	keyP["week1_timer2"] = 0
	keyP["week1_timer3"] = 0
	keyP["week1_timer4"] = 0
	keyP["week1_timer5"] = 0
	keyP["week2_timer1"] = 0
	keyP["week2_timer2"] = 0
	keyP["week2_timer3"] = 0
	keyP["week2_timer4"] = 0
	keyP["week2_timer5"] = 0
	keyP["week3_timer1"] = 0
	keyP["week3_timer2"] = 0
	keyP["week3_timer3"] = 0
	keyP["week3_timer4"] = 0
	keyP["week3_timer5"] = 0
	keyP["week4_timer1"] = 0
	keyP["week4_timer2"] = 0
	keyP["week4_timer3"] = 0
	keyP["week4_timer4"] = 0
	keyP["week4_timer5"] = 0
	keyP["week5_timer1"] = 0
	keyP["week5_timer2"] = 0
	keyP["week5_timer3"] = 0
	keyP["week5_timer4"] = 0
	keyP["week5_timer5"] = 0
	keyP["week6_timer1"] = 0
	keyP["week6_timer2"] = 0
	keyP["week6_timer3"] = 0
	keyP["week6_timer4"] = 0
	keyP["week6_timer5"] = 0
	keyP["week0_timer1"] = 0
	keyP["week0_timer2"] = 0
	keyP["week0_timer3"] = 0
	keyP["week0_timer4"] = 0
	keyP["week0_timer5"] = 0
	keyP["week1_timer1_open_hour"] = 0
	keyP["week1_timer1_open_min"] = 0
	keyP["week1_timer1_close_hour"] = 0
	keyP["week1_timer1_close_min"] = 0
	keyP["week1_timer1_temperature"] = -25
	keyP["week1_timer2_open_hour"] = 0
	keyP["week1_timer2_open_min"] = 0
	keyP["week1_timer2_close_hour"] = 0
	keyP["week1_timer2_close_min"] = 0
	keyP["week1_timer2_temperature"] = -25
	keyP["week1_timer3_open_hour"] = 0
	keyP["week1_timer3_open_min"] = 0
	keyP["week1_timer3_close_hour"] = 0
	keyP["week1_timer3_close_min"] = 0
	keyP["week1_timer3_temperature"] = -25
	keyP["week1_timer4_open_hour"] = 0
	keyP["week1_timer4_open_min"] = 0
	keyP["week1_timer4_close_hour"] = 0
	keyP["week1_timer4_close_min"] = 0
	keyP["week1_timer4_temperature"] = -25
	keyP["week1_timer5_open_hour"] = 0
	keyP["week1_timer5_open_min"] = 0
	keyP["week1_timer5_close_hour"] = 0
	keyP["week1_timer5_close_min"] = 0
	keyP["week1_timer5_temperature"] = -25
	keyP["week2_timer1_open_hour"] = 0
	keyP["week2_timer1_open_min"] = 0
	keyP["week2_timer1_close_hour"] = 0
	keyP["week2_timer1_close_min"] = 0
	keyP["week2_timer1_temperature"] = -25
	keyP["week2_timer2_open_hour"] = 0
	keyP["week2_timer2_open_min"] = 0
	keyP["week2_timer2_close_hour"] = 0
	keyP["week2_timer2_close_min"] = 0
	keyP["week2_timer2_temperature"] = -25
	keyP["week2_timer3_open_hour"] = 0
	keyP["week2_timer3_open_min"] = 0
	keyP["week2_timer3_close_hour"] = 0
	keyP["week2_timer3_close_min"] = 0
	keyP["week2_timer3_temperature"] = -25
	keyP["week2_timer4_open_hour"] = 0
	keyP["week2_timer4_open_min"] = 0
	keyP["week2_timer4_close_hour"] = 0
	keyP["week2_timer4_close_min"] = 0
	keyP["week2_timer4_temperature"] = -25
	keyP["week2_timer5_open_hour"] = 0
	keyP["week2_timer5_open_min"] = 0
	keyP["week2_timer5_close_hour"] = 0
	keyP["week2_timer5_close_min"] = 0
	keyP["week2_timer5_temperature"] = -25
	keyP["week3_timer1_open_hour"] = 0
	keyP["week3_timer1_open_min"] = 0
	keyP["week3_timer1_close_hour"] = 0
	keyP["week3_timer1_close_min"] = 0
	keyP["week3_timer1_temperature"] = -25
	keyP["week3_timer2_open_hour"] = 0
	keyP["week3_timer2_open_min"] = 0
	keyP["week3_timer2_close_hour"] = 0
	keyP["week3_timer2_close_min"] = 0
	keyP["week3_timer2_temperature"] = -25
	keyP["week3_timer3_open_hour"] = 0
	keyP["week3_timer3_open_min"] = 0
	keyP["week3_timer3_close_hour"] = 0
	keyP["week3_timer3_close_min"] = 0
	keyP["week3_timer3_temperature"] = -25
	keyP["week3_timer4_open_hour"] = 0
	keyP["week3_timer4_open_min"] = 0
	keyP["week3_timer4_close_hour"] = 0
	keyP["week3_timer4_close_min"] = 0
	keyP["week3_timer4_temperature"] = -25
	keyP["week3_timer5_open_hour"] = 0
	keyP["week3_timer5_open_min"] = 0
	keyP["week3_timer5_close_hour"] = 0
	keyP["week3_timer5_close_min"] = 0
	keyP["week3_timer5_temperature"] = -25
	keyP["week4_timer1_open_hour"] = 0
	keyP["week4_timer1_open_min"] = 0
	keyP["week4_timer1_close_hour"] = 0
	keyP["week4_timer1_close_min"] = 0
	keyP["week4_timer1_temperature"] = -25
	keyP["week4_timer2_open_hour"] = 0
	keyP["week4_timer2_open_min"] = 0
	keyP["week4_timer2_close_hour"] = 0
	keyP["week4_timer2_close_min"] = 0
	keyP["week4_timer2_temperature"] = -25
	keyP["week4_timer3_open_hour"] = 0
	keyP["week4_timer3_open_min"] = 0
	keyP["week4_timer3_close_hour"] = 0
	keyP["week4_timer3_close_min"] = 0
	keyP["week4_timer3_temperature"] = -25
	keyP["week4_timer4_open_hour"] = 0
	keyP["week4_timer4_open_min"] = 0
	keyP["week4_timer4_close_hour"] = 0
	keyP["week4_timer4_close_min"] = 0
	keyP["week4_timer4_temperature"] = -25
	keyP["week4_timer5_open_hour"] = 0
	keyP["week4_timer5_open_min"] = 0
	keyP["week4_timer5_close_hour"] = 0
	keyP["week4_timer5_close_min"] = 0
	keyP["week4_timer5_temperature"] = -25
	keyP["week5_timer1_open_hour"] = 0
	keyP["week5_timer1_open_min"] = 0
	keyP["week5_timer1_close_hour"] = 0
	keyP["week5_timer1_close_min"] = 0
	keyP["week5_timer1_temperature"] = -25
	keyP["week5_timer2_open_hour"] = 0
	keyP["week5_timer2_open_min"] = 0
	keyP["week5_timer2_close_hour"] = 0
	keyP["week5_timer2_close_min"] = 0
	keyP["week5_timer2_temperature"] = -25
	keyP["week5_timer3_open_hour"] = 0
	keyP["week5_timer3_open_min"] = 0
	keyP["week5_timer3_close_hour"] = 0
	keyP["week5_timer3_close_min"] = 0
	keyP["week5_timer3_temperature"] = -25
	keyP["week5_timer4_open_hour"] = 0
	keyP["week5_timer4_open_min"] = 0
	keyP["week5_timer4_close_hour"] = 0
	keyP["week5_timer4_close_min"] = 0
	keyP["week5_timer4_temperature"] = -25
	keyP["week5_timer5_open_hour"] = 0
	keyP["week5_timer5_open_min"] = 0
	keyP["week5_timer5_close_hour"] = 0
	keyP["week5_timer5_close_min"] = 0
	keyP["week5_timer5_temperature"] = -25
	keyP["week6_timer1_open_hour"] = 0
	keyP["week6_timer1_open_min"] = 0
	keyP["week6_timer1_close_hour"] = 0
	keyP["week6_timer1_close_min"] = 0
	keyP["week6_timer1_temperature"] = -25
	keyP["week6_timer2_open_hour"] = 0
	keyP["week6_timer2_open_min"] = 0
	keyP["week6_timer2_close_hour"] = 0
	keyP["week6_timer2_close_min"] = 0
	keyP["week6_timer2_temperature"] = -25
	keyP["week6_timer3_open_hour"] = 0
	keyP["week6_timer3_open_min"] = 0
	keyP["week6_timer3_close_hour"] = 0
	keyP["week6_timer3_close_min"] = 0
	keyP["week6_timer3_temperature"] = -25
	keyP["week6_timer4_open_hour"] = 0
	keyP["week6_timer4_open_min"] = 0
	keyP["week6_timer4_close_hour"] = 0
	keyP["week6_timer4_close_min"] = 0
	keyP["week6_timer4_temperature"] = -25
	keyP["week6_timer5_open_hour"] = 0
	keyP["week6_timer5_open_min"] = 0
	keyP["week6_timer5_close_hour"] = 0
	keyP["week6_timer5_close_min"] = 0
	keyP["week6_timer5_temperature"] = -25
	keyP["week0_timer1_open_hour"] = 0
	keyP["week0_timer1_open_min"] = 0
	keyP["week0_timer1_close_hour"] = 0
	keyP["week0_timer1_close_min"] = 0
	keyP["week0_timer1_temperature"] = -25
	keyP["week0_timer2_open_hour"] = 0
	keyP["week0_timer2_open_min"] = 0
	keyP["week0_timer2_close_hour"] = 0
	keyP["week0_timer2_close_min"] = 0
	keyP["week0_timer2_temperature"] = -25
	keyP["week0_timer3_open_hour"] = 0
	keyP["week0_timer3_open_min"] = 0
	keyP["week0_timer3_close_hour"] = 0
	keyP["week0_timer3_close_min"] = 0
	keyP["week0_timer3_temperature"] = -25
	keyP["week0_timer4_open_hour"] = 0
	keyP["week0_timer4_open_min"] = 0
	keyP["week0_timer4_close_hour"] = 0
	keyP["week0_timer4_close_min"] = 0
	keyP["week0_timer4_temperature"] = -25
	keyP["week0_timer5_open_hour"] = 0
	keyP["week0_timer5_open_min"] = 0
	keyP["week0_timer5_close_hour"] = 0
	keyP["week0_timer5_close_min"] = 0
	keyP["week0_timer5_temperature"] = -25
	keyP["week0_duplicate_timer_on_1"] = 0
	keyP["week0_duplicate_timer_off_2"] = 0
	keyP["week1_duplicate_timer_on_1"] = 0
	keyP["week1_duplicate_timer_off_2"] = 0
	keyP["week2_duplicate_timer_on_1"] = 0
	keyP["week2_duplicate_timer_off_2"] = 0
	keyP["week3_duplicate_timer_on_1"] = 0
	keyP["week3_duplicate_timer_off_2"] = 0
	keyP["week4_duplicate_timer_on_1"] = 0
	keyP["week4_duplicate_timer_off_2"] = 0
	keyP["week5_duplicate_timer_on_1"] = 0
	keyP["week5_duplicate_timer_off_2"] = 0
	keyP["week6_duplicate_timer_on_1"] = 0
	keyP["week6_duplicate_timer_off_2"] = 0
end
local function radar_init()
	for k, v in pairs(radarStatus) do
		local group2 = k .. "_" .. "2"
		keyP[k] = 0
		keyP[group2] = 0
	end
end
init_keyP()
radar_init()
local dataType = 0
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
		print("i======", i)
		print("cmd====", cmd[i])
		ret = ret .. string.char(cmd[i])
	end
	return ret
end
local function string2tableSingle(hexstr)
	local tb = {}
	local i = 1
	for i = 1, #hexstr do
		local doublebytestr = string.sub(hexstr, i, i)
		tb[i] = doublebytestr
	end
	return tb
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
local function numstring2table(hexstr)
	local tb = {}
	local i = 1
	local j = 1
	for i = 1, #hexstr - 1, 2 do
		local doublebytestr = string.sub(hexstr, i, i + 1)
		tb[j] = doublebytestr
		j = j + 1
	end
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
local function JsonToModel(jsonCmd, jsonType)
	local streams = jsonCmd
	if streams[keyT["KEY_POWER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["powerValue"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_POWER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["powerValue"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_STANDBY_CLEAN"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["standby_clean"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_STANDBY_SELFCLEAN"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["standby_clean"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_BUZZER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["buzzerValue"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_BUZZER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["buzzerValue"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_NOWINDSENSE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["no_wind_sense"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_NOWINDSENSE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["no_wind_sense"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_DRY"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["dryValue"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_DRY"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["dryValue"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_STRONG_WIND"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["strongWindValue"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_STRONG_WIND"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["strongWindValue"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_MANUL_NEWWIND"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["manulNewWind"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_MANUL_NEWWIND"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["manulNewWind"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_AUTO_NEWWIND"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["autoNewWind"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_AUTO_NEWWIND"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["autoNewWind"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_SWING_UD"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["swingLeftUDValue"] = keyB["BYTE_COMMON_ON"]
		keyP["swingRightUDValue"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_SWING_UD"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["swingLeftUDValue"] = keyB["BYTE_COMMON_OFF"]
		keyP["swingRightUDValue"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_SWING_LR"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["swingUpLRValue"] = keyB["BYTE_COMMON_ON"]
		keyP["swingDownLRValue"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_SWING_LR"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["swingUpLRValue"] = keyB["BYTE_COMMON_OFF"]
		keyP["swingDownLRValue"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_FORCE_COOL_MODE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["forceCoolMode"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_FORCE_COOL_MODE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["forceCoolMode"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_FORCE_AUTO_MODE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["forceAutoMode"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_FORCE_AUTO_MODE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["forceAutoMode"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_PTC"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["PTCValue"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_PTC"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["PTCValue"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_PTC_DEPENDT4"]] == keyV["VALUE_FUNCTION_ON"] and jsonType == "control" then
		keyP["PTCDependT4Value"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_PTC_DEPENDT4"]] == keyV["VALUE_FUNCTION_OFF"] and jsonType == "control" then
		keyP["PTCDependT4Value"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams["smart_humi_control"] ~= nil and jsonType == "control" then
		keyP["smart_humi_control"] = streams["smart_humi_control"]
		keyP["control_flag"] = 4
	end
	if streams[keyT["KEY_COOL_HOT_SENSE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["cool_hot_sense"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_COOL_HOT_SENSE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["cool_hot_sense"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_PREVENT_COLD"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["preventCold"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_PREVENT_COLD"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["preventCold"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WIND_STRAIGHT"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["wind_straight"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_WIND_STRAIGHT"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["wind_straight"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WIND_AVOID"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["wind_avoid"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_WIND_AVOID"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["wind_avoid"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_DISINFECT"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["disinfect"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_DISINFECT"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["disinfect"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_ELEC_DUST_REMOVE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["elecDustRemove"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_ELEC_DUST_REMOVE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["elecDustRemove"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_SELFCLEAN"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["self_clean"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_SELFCLEAN"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["self_clean"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_ENERGY_SAVE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["energySaveValue"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_ENERGY_SAVE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["energySaveValue"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_AIR_OPTIMIZATION"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["air_optimization"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_AIR_OPTIMIZATION"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["air_optimization"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_NOBODY_ENERGY_SAVE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["nobody_energy_save"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_NOBODY_ENERGY_SAVE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["nobody_energy_save"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_AUTO_PURIFY"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["autoPurify"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_AUTO_PURIFY"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["autoPurify"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_MANUL_PURIFY"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["manulPurify"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_MANUL_PURIFY"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["manulPurify"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_NO_WIND_SENSE_MODE"]] ~= nil then
		keyP["no_wind_sense_mode"] = checkBoundary(streams[keyT["KEY_NO_WIND_SENSE_MODE"]], 0, 2)
	end
	if streams[keyT["KEY_RUN_TEST"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["run_test"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_RUN_TEST"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["run_test"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_FAST_CHECK"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["fast_check"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_FAST_CHECK"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["fast_check"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_AUTO_HUMI"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["autoHumi"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_AUTO_HUMI"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["autoHumi"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_MANUL_HUMI"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["manuHumi"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_MANUL_HUMI"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["manuHumi"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WIND_STRENGTH"]] ~= nil then
		keyP["wind_strength"] = checkBoundary(streams[keyT["KEY_WIND_STRENGTH"]], 0, 1)
	end
	if streams[keyT["KEY_NEW_WIND_MACHINE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["new_wind_machine"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_NEW_WIND_MACHINE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["new_wind_machine"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_NEW_WIND_MACHINE_LINK"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["new_wind_machine_link"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_NEW_WIND_MACHINE_LINK"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["new_wind_machine_link"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_PROJECT_EVACUATE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["project_evacuate"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_PROJECT_EVACUATE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["project_evacuate"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_FOLLOW_BODY_SENSE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["follow_body_sense"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_FOLLOW_BODY_SENSE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["follow_body_sense"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_EXHAUST_STRENGTH"]] ~= nil then
		keyP["exhaust_strength"] = checkBoundary(streams[keyT["KEY_EXHAUST_STRENGTH"]], 0, 1)
	end
	if streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_HEAT"] then
		keyP["modeValue"] = keyB["BYTE_MODE_HEAT"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_COOL"] then
		keyP["modeValue"] = keyB["BYTE_MODE_COOL"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_AUTO"] then
		keyP["modeValue"] = keyB["BYTE_MODE_AUTO"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_DRY"] then
		keyP["modeValue"] = keyB["BYTE_MODE_DRY"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_FAN"] then
		keyP["modeValue"] = keyB["BYTE_MODE_FAN"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_STANDBY"] then
		keyP["modeValue"] = keyB["BYTE_MODE_STANDBY"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_DRYCONSTANT"] then
		keyP["modeValue"] = keyB["BYTE_MODE_DRYCONSTANT"]
	elseif streams[keyT["KEY_MODE"]] == keyV["VALUE_MODE_DRYAUTO"] then
		keyP["modeValue"] = keyB["BYTE_MODE_DRYAUTO"]
	end
	if streams[keyT["KEY_TEMPERATURE"]] ~= nil then
		keyP["temperature"] = streams[keyT["KEY_TEMPERATURE"]]
	end
	if streams["small_temperature"] ~= nil then
		keyP["small_temperature"] = checkBoundary(streams["small_temperature"], 0, 0.5)
	end
	if streams[keyT["KEY_FANSPEED"]] ~= nil then
		keyP["fanspeedValue"] = checkBoundary(streams[keyT["KEY_FANSPEED"]], 1, 103)
	end
	if streams[keyT["KEY_DEHUMIDITY"]] ~= nil then
		keyP["dehumidityValue"] = checkBoundary(streams[keyT["KEY_DEHUMIDITY"]], 1, 100)
	end
	if streams[keyT["KEY_HUMIDITY"]] ~= nil then
		keyP["humidityValue"] = checkBoundary(streams[keyT["KEY_HUMIDITY"]], 1, 100)
	end
	if streams[keyT["KEY_PM25"]] ~= nil then
		keyP["pm25LowValue"] = math.floor(streams[keyT["KEY_PM25"]] % 256)
		keyP["pm25HighValue"] = math.floor(streams[keyT["KEY_PM25"]] / 256)
	end
	if streams[keyT["KEY_CO2"]] ~= nil then
		keyP["co2LowValue"] = math.floor(streams[keyT["KEY_CO2"]] % 256)
		keyP["co2HighValue"] = math.floor(streams[keyT["KEY_CO2"]] / 256)
	end
	if streams[keyT["KEY_NEWWIND_MODE"]] ~= nil then
		keyP["newWindModeValue"] = checkBoundary(streams[keyT["KEY_NEWWIND_MODE"]], 0, 20)
	end
	if streams[keyT["KEY_NEWWIND_FANSPEED"]] ~= nil then
		keyP["newWindSpeedValue"] = checkBoundary(streams[keyT["KEY_NEWWIND_FANSPEED"]], 1, 103)
	end
	if streams[keyT["KEY_AIR_OPTIMIZATION_TEMPERATURE"]] ~= nil then
		keyP["air_optimization_temperature"] = checkBoundary(streams[keyT["KEY_AIR_OPTIMIZATION_TEMPERATURE"]], 16, 30)
	end
	if streams[keyT["KEY_AIR_OPTIMIZATION_HUMIDITY"]] ~= nil then
		keyP["air_optimization_humidity"] = checkBoundary(streams[keyT["KEY_AIR_OPTIMIZATION_HUMIDITY"]], 1, 100)
	end
	if streams[keyT["KEY_AIR_OPTIMIZATION_WIND"]] ~= nil then
		keyP["air_optimization_wind"] = checkBoundary(streams[keyT["KEY_AIR_OPTIMIZATION_WIND"]], 1, 102)
	end
	if streams[keyT["KEY_WATER_MODEL_POWER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["water_model_power"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_WATER_MODEL_POWER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["water_model_power"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WATER_MODEL_POWER"]] == keyV["VALUE_FUNCTION_ON"] and jsonType == "control" then
		keyP["water_model_flag"] = keyP["water_model_flag"] + 1
	end
	if streams[keyT["KEY_WATER_MODEL_POWER_SAVE"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["water_model_power_save"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_WATER_MODEL_POWER_SAVE"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["water_model_power_save"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WATER_MODEL_CLEAN"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["water_model_clean"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_WATER_MODEL_CLEAN"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["water_model_clean"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WATER_MODEL_CLEAN"]] == keyV["VALUE_FUNCTION_ON"] and jsonType == "control" then
		keyP["water_model_flag"] = keyP["water_model_flag"] + 1
	end
	if streams[keyT["KEY_WATER_MODEL_TEMPERATURE_AUTO"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["water_model_temperature_auto"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_WATER_MODEL_TEMPERATURE_AUTO"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["water_model_temperature_auto"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WATER_MODEL_PTC"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["water_model_ptc"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_WATER_MODEL_PTC"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["water_model_ptc"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WATER_MODEL_GO_OUT"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["water_model_go_out"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_WATER_MODEL_GO_OUT"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["water_model_go_out"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_WATER_MODEL_TEMPERATURE_SET"]] ~= nil then
		keyP["water_model_temperature_set"] = checkBoundary(streams[keyT["KEY_WATER_MODEL_TEMPERATURE_SET"]], 25, 60)
	end
	if streams[keyT["KEY_SCREEN_DISPLAY"]] ~= nil then
		if propertyPre == nil then
			keyP["propertyNumber"] = keyP["propertyNumber"] + 1
			propertyPre = streams[keyT["KEY_SCREEN_DISPLAY"]]
		end
		if streams[keyT["KEY_SCREEN_DISPLAY"]] == keyV["VALUE_FUNCTION_ON"] then
			keyP["screen_display"] = 0x64
		elseif streams[keyT["KEY_SCREEN_DISPLAY"]] == keyV["VALUE_FUNCTION_OFF"] then
			keyP["screen_display"] = 0x00
		end
	end
	if streams[keyT["KEY_FILTER_TIME_RESET"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["filterTimeReset"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_FILTER_TIME_RESET"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["filterTimeReset"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_PURIFY_FILTER_TIME_RESET"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["purifyFilterTimeReset"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_PURIFY_FILTER_TIME_RESET"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["purifyFilterTimeReset"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams[keyT["KEY_FRESH_FILTER_TIME_RESET"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["freshFilterTimeReset"] = keyB["BYTE_COMMON_ON"]
	elseif streams[keyT["KEY_FRESH_FILTER_TIME_RESET"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["freshFilterTimeReset"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams["humidity_drainage"] == 0x01 then
		keyP["humidity_drainage"] = 0x01
	elseif streams["humidity_drainage"] == 0x00 then
		keyP["humidity_drainage"] = 0x00
	end
	if jsonType == "control" and streams["humidity_drainage"] ~= nil then
		keyP["humidity_drainage_flag"] = 1
	end
	if streams["purifier_odor_filter_reset"] == 0x01 then
		keyP["purifier_odor_filter_reset"] = 0x01
	elseif streams["purifier_odor_filter_reset"] == 0x00 then
		keyP["purifier_odor_filter_reset"] = 0x00
	end
	if jsonType == "control" and streams["purifier_odor_filter_reset"] ~= nil then
		keyP["humidity_drainage_flag"] = 1
	end
	if streams[keyT["KEY_POWER_ON_TIMER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["power_on_timer"] = 0x01
	elseif streams[keyT["KEY_POWER_ON_TIMER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["power_on_timer"] = 0x00
	end
	if streams[keyT["KEY_POWER_OFF_TIMER"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["power_off_timer"] = 0x01
	elseif streams[keyT["KEY_POWER_OFF_TIMER"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["power_off_timer"] = 0x00
	end
	if streams[keyT["KEY_CLOSE_TIME"]] ~= nil then
		keyP["power_off_time_value"] = streams[keyT["KEY_CLOSE_TIME"]]
	end
	if streams[keyT["KEY_OPEN_TIME"]] ~= nil then
		keyP["power_on_time_value"] = streams[keyT["KEY_OPEN_TIME"]]
	end
	if
		jsonType == "control"
		and (streams[keyT["KEY_POWER_ON_TIMER"]] ~= nil or streams[keyT["KEY_POWER_OFF_TIMER"]] ~= nil)
	then
		keyP["timer_enable"] = 1
	else
		keyP["timer_enable"] = 0
	end
	if streams[keyT["KEY_COMFORT_SLEEP_CURVE"]] ~= nil then
		streams[keyT["KEY_COMFORT_SLEEP_CURVE"]] = string.gsub(streams[keyT["KEY_COMFORT_SLEEP_CURVE"]], ",", "")
		comfortByte = numstring2table(streams[keyT["KEY_COMFORT_SLEEP_CURVE"]])
	end
	if streams[keyT["KEY_COMFORT_SLEEP"]] == keyV["VALUE_FUNCTION_ON"] then
		keyP["comfortableSleepValue"] = 0x30
		keyP["comfortableSleepTime"] = 0x08
	elseif streams[keyT["KEY_COMFORT_SLEEP"]] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["comfortableSleepValue"] = 0x00
		keyP["comfortableSleepTime"] = 0x00
	end
	if streams["up_down_wind_direction"] ~= nil then
		keyP["up_down_wind_direction"] = streams["up_down_wind_direction"]
	end
	if streams["left_right_wind_direction"] ~= nil then
		keyP["left_right_wind_direction"] = streams["left_right_wind_direction"]
	end
	if streams["stop_warm"] == keyV["VALUE_FUNCTION_ON"] then
		keyP["stop_warm"] = keyB["BYTE_COMMON_ON"]
	elseif streams["stop_warm"] == keyV["VALUE_FUNCTION_OFF"] then
		keyP["stop_warm"] = keyB["BYTE_COMMON_OFF"]
	end
	if streams["water_mode"] ~= nil then
		keyP["water_mode"] = streams["water_mode"]
	end
	if streams["sn8_string"] == "00000001" then
		if jsonType == "control" then
			keyP["sn8_flag"] = 1
		end
	end
	if streams["week1_timer1"] ~= nil then
		keyP["week1_timer1"] = streams["week1_timer1"]
	end
	if streams["week1_timer2"] ~= nil then
		keyP["week1_timer2"] = streams["week1_timer2"]
	end
	if streams["week1_timer3"] ~= nil then
		keyP["week1_timer3"] = streams["week1_timer3"]
	end
	if streams["week1_timer4"] ~= nil then
		keyP["week1_timer4"] = streams["week1_timer4"]
	end
	if streams["week1_timer5"] ~= nil then
		keyP["week1_timer5"] = streams["week1_timer5"]
	end
	if streams["week2_timer1"] ~= nil then
		keyP["week2_timer1"] = streams["week2_timer1"]
	end
	if streams["week2_timer2"] ~= nil then
		keyP["week2_timer2"] = streams["week2_timer2"]
	end
	if streams["week2_timer3"] ~= nil then
		keyP["week2_timer3"] = streams["week2_timer3"]
	end
	if streams["week2_timer4"] ~= nil then
		keyP["week2_timer4"] = streams["week2_timer4"]
	end
	if streams["week2_timer5"] ~= nil then
		keyP["week2_timer5"] = streams["week2_timer5"]
	end
	if streams["week3_timer1"] ~= nil then
		keyP["week3_timer1"] = streams["week3_timer1"]
	end
	if streams["week3_timer2"] ~= nil then
		keyP["week3_timer2"] = streams["week3_timer2"]
	end
	if streams["week3_timer3"] ~= nil then
		keyP["week3_timer3"] = streams["week3_timer3"]
	end
	if streams["week3_timer4"] ~= nil then
		keyP["week3_timer4"] = streams["week3_timer4"]
	end
	if streams["week3_timer5"] ~= nil then
		keyP["week3_timer5"] = streams["week3_timer5"]
	end
	if streams["week4_timer1"] ~= nil then
		keyP["week4_timer1"] = streams["week4_timer1"]
	end
	if streams["week4_timer2"] ~= nil then
		keyP["week4_timer2"] = streams["week4_timer2"]
	end
	if streams["week4_timer3"] ~= nil then
		keyP["week4_timer3"] = streams["week4_timer3"]
	end
	if streams["week4_timer4"] ~= nil then
		keyP["week4_timer4"] = streams["week4_timer4"]
	end
	if streams["week4_timer5"] ~= nil then
		keyP["week4_timer5"] = streams["week4_timer5"]
	end
	if streams["week5_timer1"] ~= nil then
		keyP["week5_timer1"] = streams["week5_timer1"]
	end
	if streams["week5_timer2"] ~= nil then
		keyP["week5_timer2"] = streams["week5_timer2"]
	end
	if streams["week5_timer3"] ~= nil then
		keyP["week5_timer3"] = streams["week5_timer3"]
	end
	if streams["week5_timer4"] ~= nil then
		keyP["week5_timer4"] = streams["week5_timer4"]
	end
	if streams["week5_timer5"] ~= nil then
		keyP["week5_timer5"] = streams["week5_timer5"]
	end
	if streams["week6_timer1"] ~= nil then
		keyP["week6_timer1"] = streams["week6_timer1"]
	end
	if streams["week6_timer2"] ~= nil then
		keyP["week6_timer2"] = streams["week6_timer2"]
	end
	if streams["week6_timer3"] ~= nil then
		keyP["week6_timer3"] = streams["week6_timer3"]
	end
	if streams["week6_timer4"] ~= nil then
		keyP["week6_timer4"] = streams["week6_timer4"]
	end
	if streams["week6_timer5"] ~= nil then
		keyP["week6_timer5"] = streams["week6_timer5"]
	end
	if streams["week0_timer1"] ~= nil then
		keyP["week0_timer1"] = streams["week0_timer1"]
	end
	if streams["week0_timer2"] ~= nil then
		keyP["week0_timer2"] = streams["week0_timer2"]
	end
	if streams["week0_timer3"] ~= nil then
		keyP["week0_timer3"] = streams["week0_timer3"]
	end
	if streams["week0_timer4"] ~= nil then
		keyP["week0_timer4"] = streams["week0_timer4"]
	end
	if streams["week0_timer5"] ~= nil then
		keyP["week0_timer5"] = streams["week0_timer5"]
	end
	if streams["week1_timer1_open_hour"] ~= nil then
		keyP["week1_timer1_open_hour"] = streams["week1_timer1_open_hour"]
	end
	if streams["week1_timer1_open_min"] ~= nil then
		keyP["week1_timer1_open_min"] = streams["week1_timer1_open_min"]
	end
	if streams["week1_timer1_close_hour"] ~= nil then
		keyP["week1_timer1_close_hour"] = streams["week1_timer1_close_hour"]
	end
	if streams["week1_timer1_close_min"] ~= nil then
		keyP["week1_timer1_close_min"] = streams["week1_timer1_close_min"]
	end
	if streams["week1_timer1_temperature"] ~= nil then
		keyP["week1_timer1_temperature"] = streams["week1_timer1_temperature"]
	end
	if streams["week1_timer2_open_hour"] ~= nil then
		keyP["week1_timer2_open_hour"] = streams["week1_timer2_open_hour"]
	end
	if streams["week1_timer2_open_min"] ~= nil then
		keyP["week1_timer2_open_min"] = streams["week1_timer2_open_min"]
	end
	if streams["week1_timer2_close_hour"] ~= nil then
		keyP["week1_timer2_close_hour"] = streams["week1_timer2_close_hour"]
	end
	if streams["week1_timer2_close_min"] ~= nil then
		keyP["week1_timer2_close_min"] = streams["week1_timer2_close_min"]
	end
	if streams["week1_timer2_temperature"] ~= nil then
		keyP["week1_timer2_temperature"] = streams["week1_timer2_temperature"]
	end
	if streams["week1_timer3_open_hour"] ~= nil then
		keyP["week1_timer3_open_hour"] = streams["week1_timer3_open_hour"]
	end
	if streams["week1_timer3_open_min"] ~= nil then
		keyP["week1_timer3_open_min"] = streams["week1_timer3_open_min"]
	end
	if streams["week1_timer3_close_hour"] ~= nil then
		keyP["week1_timer3_close_hour"] = streams["week1_timer3_close_hour"]
	end
	if streams["week1_timer3_close_min"] ~= nil then
		keyP["week1_timer3_close_min"] = streams["week1_timer3_close_min"]
	end
	if streams["week1_timer3_temperature"] ~= nil then
		keyP["week1_timer3_temperature"] = streams["week1_timer3_temperature"]
	end
	if streams["week1_timer4_open_hour"] ~= nil then
		keyP["week1_timer4_open_hour"] = streams["week1_timer4_open_hour"]
	end
	if streams["week1_timer4_open_min"] ~= nil then
		keyP["week1_timer4_open_min"] = streams["week1_timer4_open_min"]
	end
	if streams["week1_timer4_close_hour"] ~= nil then
		keyP["week1_timer4_close_hour"] = streams["week1_timer4_close_hour"]
	end
	if streams["week1_timer4_close_min"] ~= nil then
		keyP["week1_timer4_close_min"] = streams["week1_timer4_close_min"]
	end
	if streams["week1_timer4_temperature"] ~= nil then
		keyP["week1_timer4_temperature"] = streams["week1_timer4_temperature"]
	end
	if streams["week1_timer5_open_hour"] ~= nil then
		keyP["week1_timer5_open_hour"] = streams["week1_timer5_open_hour"]
	end
	if streams["week1_timer5_open_min"] ~= nil then
		keyP["week1_timer5_open_min"] = streams["week1_timer5_open_min"]
	end
	if streams["week1_timer5_close_hour"] ~= nil then
		keyP["week1_timer5_close_hour"] = streams["week1_timer5_close_hour"]
	end
	if streams["week1_timer5_close_min"] ~= nil then
		keyP["week1_timer5_close_min"] = streams["week1_timer5_close_min"]
	end
	if streams["week1_timer5_temperature"] ~= nil then
		keyP["week1_timer5_temperature"] = streams["week1_timer5_temperature"]
	end
	if streams["week2_timer1_open_hour"] ~= nil then
		keyP["week2_timer1_open_hour"] = streams["week2_timer1_open_hour"]
	end
	if streams["week2_timer1_open_min"] ~= nil then
		keyP["week2_timer1_open_min"] = streams["week2_timer1_open_min"]
	end
	if streams["week2_timer1_close_hour"] ~= nil then
		keyP["week2_timer1_close_hour"] = streams["week2_timer1_close_hour"]
	end
	if streams["week2_timer1_close_min"] ~= nil then
		keyP["week2_timer1_close_min"] = streams["week2_timer1_close_min"]
	end
	if streams["week2_timer1_temperature"] ~= nil then
		keyP["week2_timer1_temperature"] = streams["week2_timer1_temperature"]
	end
	if streams["week2_timer2_open_hour"] ~= nil then
		keyP["week2_timer2_open_hour"] = streams["week2_timer2_open_hour"]
	end
	if streams["week2_timer2_open_min"] ~= nil then
		keyP["week2_timer2_open_min"] = streams["week2_timer2_open_min"]
	end
	if streams["week2_timer2_close_hour"] ~= nil then
		keyP["week2_timer2_close_hour"] = streams["week2_timer2_close_hour"]
	end
	if streams["week2_timer2_close_min"] ~= nil then
		keyP["week2_timer2_close_min"] = streams["week2_timer2_close_min"]
	end
	if streams["week2_timer2_temperature"] ~= nil then
		keyP["week2_timer2_temperature"] = streams["week2_timer2_temperature"]
	end
	if streams["week2_timer3_open_hour"] ~= nil then
		keyP["week2_timer3_open_hour"] = streams["week2_timer3_open_hour"]
	end
	if streams["week2_timer3_open_min"] ~= nil then
		keyP["week2_timer3_open_min"] = streams["week2_timer3_open_min"]
	end
	if streams["week2_timer3_close_hour"] ~= nil then
		keyP["week2_timer3_close_hour"] = streams["week2_timer3_close_hour"]
	end
	if streams["week2_timer3_close_min"] ~= nil then
		keyP["week2_timer3_close_min"] = streams["week2_timer3_close_min"]
	end
	if streams["week2_timer3_temperature"] ~= nil then
		keyP["week2_timer3_temperature"] = streams["week2_timer3_temperature"]
	end
	if streams["week2_timer4_open_hour"] ~= nil then
		keyP["week2_timer4_open_hour"] = streams["week2_timer4_open_hour"]
	end
	if streams["week2_timer4_open_min"] ~= nil then
		keyP["week2_timer4_open_min"] = streams["week2_timer4_open_min"]
	end
	if streams["week2_timer4_close_hour"] ~= nil then
		keyP["week2_timer4_close_hour"] = streams["week2_timer4_close_hour"]
	end
	if streams["week2_timer4_close_min"] ~= nil then
		keyP["week2_timer4_close_min"] = streams["week2_timer4_close_min"]
	end
	if streams["week2_timer4_temperature"] ~= nil then
		keyP["week2_timer4_temperature"] = streams["week2_timer4_temperature"]
	end
	if streams["week2_timer5_open_hour"] ~= nil then
		keyP["week2_timer5_open_hour"] = streams["week2_timer5_open_hour"]
	end
	if streams["week2_timer5_open_min"] ~= nil then
		keyP["week2_timer5_open_min"] = streams["week2_timer5_open_min"]
	end
	if streams["week2_timer5_close_hour"] ~= nil then
		keyP["week2_timer5_close_hour"] = streams["week2_timer5_close_hour"]
	end
	if streams["week2_timer5_close_min"] ~= nil then
		keyP["week2_timer5_close_min"] = streams["week2_timer5_close_min"]
	end
	if streams["week2_timer5_temperature"] ~= nil then
		keyP["week2_timer5_temperature"] = streams["week2_timer5_temperature"]
	end
	if streams["week3_timer1_open_hour"] ~= nil then
		keyP["week3_timer1_open_hour"] = streams["week3_timer1_open_hour"]
	end
	if streams["week3_timer1_open_min"] ~= nil then
		keyP["week3_timer1_open_min"] = streams["week3_timer1_open_min"]
	end
	if streams["week3_timer1_close_hour"] ~= nil then
		keyP["week3_timer1_close_hour"] = streams["week3_timer1_close_hour"]
	end
	if streams["week3_timer1_close_min"] ~= nil then
		keyP["week3_timer1_close_min"] = streams["week3_timer1_close_min"]
	end
	if streams["week3_timer1_temperature"] ~= nil then
		keyP["week3_timer1_temperature"] = streams["week3_timer1_temperature"]
	end
	if streams["week3_timer2_open_hour"] ~= nil then
		keyP["week3_timer2_open_hour"] = streams["week3_timer2_open_hour"]
	end
	if streams["week3_timer2_open_min"] ~= nil then
		keyP["week3_timer2_open_min"] = streams["week3_timer2_open_min"]
	end
	if streams["week3_timer2_close_hour"] ~= nil then
		keyP["week3_timer2_close_hour"] = streams["week3_timer2_close_hour"]
	end
	if streams["week3_timer2_close_min"] ~= nil then
		keyP["week3_timer2_close_min"] = streams["week3_timer2_close_min"]
	end
	if streams["week3_timer2_temperature"] ~= nil then
		keyP["week3_timer2_temperature"] = streams["week3_timer2_temperature"]
	end
	if streams["week3_timer3_open_hour"] ~= nil then
		keyP["week3_timer3_open_hour"] = streams["week3_timer3_open_hour"]
	end
	if streams["week3_timer3_open_min"] ~= nil then
		keyP["week3_timer3_open_min"] = streams["week3_timer3_open_min"]
	end
	if streams["week3_timer3_close_hour"] ~= nil then
		keyP["week3_timer3_close_hour"] = streams["week3_timer3_close_hour"]
	end
	if streams["week3_timer3_close_min"] ~= nil then
		keyP["week3_timer3_close_min"] = streams["week3_timer3_close_min"]
	end
	if streams["week3_timer3_temperature"] ~= nil then
		keyP["week3_timer3_temperature"] = streams["week3_timer3_temperature"]
	end
	if streams["week3_timer4_open_hour"] ~= nil then
		keyP["week3_timer4_open_hour"] = streams["week3_timer4_open_hour"]
	end
	if streams["week3_timer4_open_min"] ~= nil then
		keyP["week3_timer4_open_min"] = streams["week3_timer4_open_min"]
	end
	if streams["week3_timer4_close_hour"] ~= nil then
		keyP["week3_timer4_close_hour"] = streams["week3_timer4_close_hour"]
	end
	if streams["week3_timer4_close_min"] ~= nil then
		keyP["week3_timer4_close_min"] = streams["week3_timer4_close_min"]
	end
	if streams["week3_timer4_temperature"] ~= nil then
		keyP["week3_timer4_temperature"] = streams["week3_timer4_temperature"]
	end
	if streams["week3_timer5_open_hour"] ~= nil then
		keyP["week3_timer5_open_hour"] = streams["week3_timer5_open_hour"]
	end
	if streams["week3_timer5_open_min"] ~= nil then
		keyP["week3_timer5_open_min"] = streams["week3_timer5_open_min"]
	end
	if streams["week3_timer5_close_hour"] ~= nil then
		keyP["week3_timer5_close_hour"] = streams["week3_timer5_close_hour"]
	end
	if streams["week3_timer5_close_min"] ~= nil then
		keyP["week3_timer5_close_min"] = streams["week3_timer5_close_min"]
	end
	if streams["week3_timer5_temperature"] ~= nil then
		keyP["week3_timer5_temperature"] = streams["week3_timer5_temperature"]
	end
	if streams["week4_timer1_open_hour"] ~= nil then
		keyP["week4_timer1_open_hour"] = streams["week4_timer1_open_hour"]
	end
	if streams["week4_timer1_open_min"] ~= nil then
		keyP["week4_timer1_open_min"] = streams["week4_timer1_open_min"]
	end
	if streams["week4_timer1_close_hour"] ~= nil then
		keyP["week4_timer1_close_hour"] = streams["week4_timer1_close_hour"]
	end
	if streams["week4_timer1_close_min"] ~= nil then
		keyP["week4_timer1_close_min"] = streams["week4_timer1_close_min"]
	end
	if streams["week4_timer1_temperature"] ~= nil then
		keyP["week4_timer1_temperature"] = streams["week4_timer1_temperature"]
	end
	if streams["week4_timer2_open_hour"] ~= nil then
		keyP["week4_timer2_open_hour"] = streams["week4_timer2_open_hour"]
	end
	if streams["week4_timer2_open_min"] ~= nil then
		keyP["week4_timer2_open_min"] = streams["week4_timer2_open_min"]
	end
	if streams["week4_timer2_close_hour"] ~= nil then
		keyP["week4_timer2_close_hour"] = streams["week4_timer2_close_hour"]
	end
	if streams["week4_timer2_close_min"] ~= nil then
		keyP["week4_timer2_close_min"] = streams["week4_timer2_close_min"]
	end
	if streams["week4_timer2_temperature"] ~= nil then
		keyP["week4_timer2_temperature"] = streams["week4_timer2_temperature"]
	end
	if streams["week4_timer3_open_hour"] ~= nil then
		keyP["week4_timer3_open_hour"] = streams["week4_timer3_open_hour"]
	end
	if streams["week4_timer3_open_min"] ~= nil then
		keyP["week4_timer3_open_min"] = streams["week4_timer3_open_min"]
	end
	if streams["week4_timer3_close_hour"] ~= nil then
		keyP["week4_timer3_close_hour"] = streams["week4_timer3_close_hour"]
	end
	if streams["week4_timer3_close_min"] ~= nil then
		keyP["week4_timer3_close_min"] = streams["week4_timer3_close_min"]
	end
	if streams["week4_timer3_temperature"] ~= nil then
		keyP["week4_timer3_temperature"] = streams["week4_timer3_temperature"]
	end
	if streams["week4_timer4_open_hour"] ~= nil then
		keyP["week4_timer4_open_hour"] = streams["week4_timer4_open_hour"]
	end
	if streams["week4_timer4_open_min"] ~= nil then
		keyP["week4_timer4_open_min"] = streams["week4_timer4_open_min"]
	end
	if streams["week4_timer4_close_hour"] ~= nil then
		keyP["week4_timer4_close_hour"] = streams["week4_timer4_close_hour"]
	end
	if streams["week4_timer4_close_min"] ~= nil then
		keyP["week4_timer4_close_min"] = streams["week4_timer4_close_min"]
	end
	if streams["week4_timer4_temperature"] ~= nil then
		keyP["week4_timer4_temperature"] = streams["week4_timer4_temperature"]
	end
	if streams["week4_timer5_open_hour"] ~= nil then
		keyP["week4_timer5_open_hour"] = streams["week4_timer5_open_hour"]
	end
	if streams["week4_timer5_open_min"] ~= nil then
		keyP["week4_timer5_open_min"] = streams["week4_timer5_open_min"]
	end
	if streams["week4_timer5_close_hour"] ~= nil then
		keyP["week4_timer5_close_hour"] = streams["week4_timer5_close_hour"]
	end
	if streams["week4_timer5_close_min"] ~= nil then
		keyP["week4_timer5_close_min"] = streams["week4_timer5_close_min"]
	end
	if streams["week4_timer5_temperature"] ~= nil then
		keyP["week4_timer5_temperature"] = streams["week4_timer5_temperature"]
	end
	if streams["week5_timer1_open_hour"] ~= nil then
		keyP["week5_timer1_open_hour"] = streams["week5_timer1_open_hour"]
	end
	if streams["week5_timer1_open_min"] ~= nil then
		keyP["week5_timer1_open_min"] = streams["week5_timer1_open_min"]
	end
	if streams["week5_timer1_close_hour"] ~= nil then
		keyP["week5_timer1_close_hour"] = streams["week5_timer1_close_hour"]
	end
	if streams["week5_timer1_close_min"] ~= nil then
		keyP["week5_timer1_close_min"] = streams["week5_timer1_close_min"]
	end
	if streams["week5_timer1_temperature"] ~= nil then
		keyP["week5_timer1_temperature"] = streams["week5_timer1_temperature"]
	end
	if streams["week5_timer2_open_hour"] ~= nil then
		keyP["week5_timer2_open_hour"] = streams["week5_timer2_open_hour"]
	end
	if streams["week5_timer2_open_min"] ~= nil then
		keyP["week5_timer2_open_min"] = streams["week5_timer2_open_min"]
	end
	if streams["week5_timer2_close_hour"] ~= nil then
		keyP["week5_timer2_close_hour"] = streams["week5_timer2_close_hour"]
	end
	if streams["week5_timer2_close_min"] ~= nil then
		keyP["week5_timer2_close_min"] = streams["week5_timer2_close_min"]
	end
	if streams["week5_timer2_temperature"] ~= nil then
		keyP["week5_timer2_temperature"] = streams["week5_timer2_temperature"]
	end
	if streams["week5_timer3_open_hour"] ~= nil then
		keyP["week5_timer3_open_hour"] = streams["week5_timer3_open_hour"]
	end
	if streams["week5_timer3_open_min"] ~= nil then
		keyP["week5_timer3_open_min"] = streams["week5_timer3_open_min"]
	end
	if streams["week5_timer3_close_hour"] ~= nil then
		keyP["week5_timer3_close_hour"] = streams["week5_timer3_close_hour"]
	end
	if streams["week5_timer3_close_min"] ~= nil then
		keyP["week5_timer3_close_min"] = streams["week5_timer3_close_min"]
	end
	if streams["week5_timer3_temperature"] ~= nil then
		keyP["week5_timer3_temperature"] = streams["week5_timer3_temperature"]
	end
	if streams["week5_timer4_open_hour"] ~= nil then
		keyP["week5_timer4_open_hour"] = streams["week5_timer4_open_hour"]
	end
	if streams["week5_timer4_open_min"] ~= nil then
		keyP["week5_timer4_open_min"] = streams["week5_timer4_open_min"]
	end
	if streams["week5_timer4_close_hour"] ~= nil then
		keyP["week5_timer4_close_hour"] = streams["week5_timer4_close_hour"]
	end
	if streams["week5_timer4_close_min"] ~= nil then
		keyP["week5_timer4_close_min"] = streams["week5_timer4_close_min"]
	end
	if streams["week5_timer4_temperature"] ~= nil then
		keyP["week5_timer4_temperature"] = streams["week5_timer4_temperature"]
	end
	if streams["week5_timer5_open_hour"] ~= nil then
		keyP["week5_timer5_open_hour"] = streams["week5_timer5_open_hour"]
	end
	if streams["week5_timer5_open_min"] ~= nil then
		keyP["week5_timer5_open_min"] = streams["week5_timer5_open_min"]
	end
	if streams["week5_timer5_close_hour"] ~= nil then
		keyP["week5_timer5_close_hour"] = streams["week5_timer5_close_hour"]
	end
	if streams["week5_timer5_close_min"] ~= nil then
		keyP["week5_timer5_close_min"] = streams["week5_timer5_close_min"]
	end
	if streams["week5_timer5_temperature"] ~= nil then
		keyP["week5_timer5_temperature"] = streams["week5_timer5_temperature"]
	end
	if streams["week6_timer1_open_hour"] ~= nil then
		keyP["week6_timer1_open_hour"] = streams["week6_timer1_open_hour"]
	end
	if streams["week6_timer1_open_min"] ~= nil then
		keyP["week6_timer1_open_min"] = streams["week6_timer1_open_min"]
	end
	if streams["week6_timer1_close_hour"] ~= nil then
		keyP["week6_timer1_close_hour"] = streams["week6_timer1_close_hour"]
	end
	if streams["week6_timer1_close_min"] ~= nil then
		keyP["week6_timer1_close_min"] = streams["week6_timer1_close_min"]
	end
	if streams["week6_timer1_temperature"] ~= nil then
		keyP["week6_timer1_temperature"] = streams["week6_timer1_temperature"]
	end
	if streams["week6_timer2_open_hour"] ~= nil then
		keyP["week6_timer2_open_hour"] = streams["week6_timer2_open_hour"]
	end
	if streams["week6_timer2_open_min"] ~= nil then
		keyP["week6_timer2_open_min"] = streams["week6_timer2_open_min"]
	end
	if streams["week6_timer2_close_hour"] ~= nil then
		keyP["week6_timer2_close_hour"] = streams["week6_timer2_close_hour"]
	end
	if streams["week6_timer2_close_min"] ~= nil then
		keyP["week6_timer2_close_min"] = streams["week6_timer2_close_min"]
	end
	if streams["week6_timer2_temperature"] ~= nil then
		keyP["week6_timer2_temperature"] = streams["week6_timer2_temperature"]
	end
	if streams["week6_timer3_open_hour"] ~= nil then
		keyP["week6_timer3_open_hour"] = streams["week6_timer3_open_hour"]
	end
	if streams["week6_timer3_open_min"] ~= nil then
		keyP["week6_timer3_open_min"] = streams["week6_timer3_open_min"]
	end
	if streams["week6_timer3_close_hour"] ~= nil then
		keyP["week6_timer3_close_hour"] = streams["week6_timer3_close_hour"]
	end
	if streams["week6_timer3_close_min"] ~= nil then
		keyP["week6_timer3_close_min"] = streams["week6_timer3_close_min"]
	end
	if streams["week6_timer3_temperature"] ~= nil then
		keyP["week6_timer3_temperature"] = streams["week6_timer3_temperature"]
	end
	if streams["week6_timer4_open_hour"] ~= nil then
		keyP["week6_timer4_open_hour"] = streams["week6_timer4_open_hour"]
	end
	if streams["week6_timer4_open_min"] ~= nil then
		keyP["week6_timer4_open_min"] = streams["week6_timer4_open_min"]
	end
	if streams["week6_timer4_close_hour"] ~= nil then
		keyP["week6_timer4_close_hour"] = streams["week6_timer4_close_hour"]
	end
	if streams["week6_timer4_close_min"] ~= nil then
		keyP["week6_timer4_close_min"] = streams["week6_timer4_close_min"]
	end
	if streams["week6_timer4_temperature"] ~= nil then
		keyP["week6_timer4_temperature"] = streams["week6_timer4_temperature"]
	end
	if streams["week6_timer5_open_hour"] ~= nil then
		keyP["week6_timer5_open_hour"] = streams["week6_timer5_open_hour"]
	end
	if streams["week6_timer5_open_min"] ~= nil then
		keyP["week6_timer5_open_min"] = streams["week6_timer5_open_min"]
	end
	if streams["week6_timer5_close_hour"] ~= nil then
		keyP["week6_timer5_close_hour"] = streams["week6_timer5_close_hour"]
	end
	if streams["week6_timer5_close_min"] ~= nil then
		keyP["week6_timer5_close_min"] = streams["week6_timer5_close_min"]
	end
	if streams["week6_timer5_temperature"] ~= nil then
		keyP["week6_timer5_temperature"] = streams["week6_timer5_temperature"]
	end
	if streams["week0_timer1_open_hour"] ~= nil then
		keyP["week0_timer1_open_hour"] = streams["week0_timer1_open_hour"]
	end
	if streams["week0_timer1_open_min"] ~= nil then
		keyP["week0_timer1_open_min"] = streams["week0_timer1_open_min"]
	end
	if streams["week0_timer1_close_hour"] ~= nil then
		keyP["week0_timer1_close_hour"] = streams["week0_timer1_close_hour"]
	end
	if streams["week0_timer1_close_min"] ~= nil then
		keyP["week0_timer1_close_min"] = streams["week0_timer1_close_min"]
	end
	if streams["week0_timer1_temperature"] ~= nil then
		keyP["week0_timer1_temperature"] = streams["week0_timer1_temperature"]
	end
	if streams["week0_timer2_open_hour"] ~= nil then
		keyP["week0_timer2_open_hour"] = streams["week0_timer2_open_hour"]
	end
	if streams["week0_timer2_open_min"] ~= nil then
		keyP["week0_timer2_open_min"] = streams["week0_timer2_open_min"]
	end
	if streams["week0_timer2_close_hour"] ~= nil then
		keyP["week0_timer2_close_hour"] = streams["week0_timer2_close_hour"]
	end
	if streams["week0_timer2_close_min"] ~= nil then
		keyP["week0_timer2_close_min"] = streams["week0_timer2_close_min"]
	end
	if streams["week0_timer2_temperature"] ~= nil then
		keyP["week0_timer2_temperature"] = streams["week0_timer2_temperature"]
	end
	if streams["week0_timer3_open_hour"] ~= nil then
		keyP["week0_timer3_open_hour"] = streams["week0_timer3_open_hour"]
	end
	if streams["week0_timer3_open_min"] ~= nil then
		keyP["week0_timer3_open_min"] = streams["week0_timer3_open_min"]
	end
	if streams["week0_timer3_close_hour"] ~= nil then
		keyP["week0_timer3_close_hour"] = streams["week0_timer3_close_hour"]
	end
	if streams["week0_timer3_close_min"] ~= nil then
		keyP["week0_timer3_close_min"] = streams["week0_timer3_close_min"]
	end
	if streams["week0_timer3_temperature"] ~= nil then
		keyP["week0_timer3_temperature"] = streams["week0_timer3_temperature"]
	end
	if streams["week0_timer4_open_hour"] ~= nil then
		keyP["week0_timer4_open_hour"] = streams["week0_timer4_open_hour"]
	end
	if streams["week0_timer4_open_min"] ~= nil then
		keyP["week0_timer4_open_min"] = streams["week0_timer4_open_min"]
	end
	if streams["week0_timer4_close_hour"] ~= nil then
		keyP["week0_timer4_close_hour"] = streams["week0_timer4_close_hour"]
	end
	if streams["week0_timer4_close_min"] ~= nil then
		keyP["week0_timer4_close_min"] = streams["week0_timer4_close_min"]
	end
	if streams["week0_timer4_temperature"] ~= nil then
		keyP["week0_timer4_temperature"] = streams["week0_timer4_temperature"]
	end
	if streams["week0_timer5_open_hour"] ~= nil then
		keyP["week0_timer5_open_hour"] = streams["week0_timer5_open_hour"]
	end
	if streams["week0_timer5_open_min"] ~= nil then
		keyP["week0_timer5_open_min"] = streams["week0_timer5_open_min"]
	end
	if streams["week0_timer5_close_hour"] ~= nil then
		keyP["week0_timer5_close_hour"] = streams["week0_timer5_close_hour"]
	end
	if streams["week0_timer5_close_min"] ~= nil then
		keyP["week0_timer5_close_min"] = streams["week0_timer5_close_min"]
	end
	if streams["week0_timer5_temperature"] ~= nil then
		keyP["week0_timer5_temperature"] = streams["week0_timer5_temperature"]
	end
	if streams["week0_duplicate_timer_on_1"] ~= nil then
		keyP["week0_duplicate_timer_on_1"] = streams["week0_duplicate_timer_on_1"]
	end
	if streams["week0_duplicate_timer_off_2"] ~= nil then
		keyP["week0_duplicate_timer_off_2"] = streams["week0_duplicate_timer_off_2"]
	end
	if streams["week1_duplicate_timer_on_1"] ~= nil then
		keyP["week1_duplicate_timer_on_1"] = streams["week1_duplicate_timer_on_1"]
	end
	if streams["week1_duplicate_timer_off_2"] ~= nil then
		keyP["week1_duplicate_timer_off_2"] = streams["week1_duplicate_timer_off_2"]
	end
	if streams["week2_duplicate_timer_on_1"] ~= nil then
		keyP["week2_duplicate_timer_on_1"] = streams["week2_duplicate_timer_on_1"]
	end
	if streams["week2_duplicate_timer_off_2"] ~= nil then
		keyP["week2_duplicate_timer_off_2"] = streams["week2_duplicate_timer_off_2"]
	end
	if streams["week3_duplicate_timer_on_1"] ~= nil then
		keyP["week3_duplicate_timer_on_1"] = streams["week3_duplicate_timer_on_1"]
	end
	if streams["week3_duplicate_timer_off_2"] ~= nil then
		keyP["week3_duplicate_timer_off_2"] = streams["week3_duplicate_timer_off_2"]
	end
	if streams["week4_duplicate_timer_on_1"] ~= nil then
		keyP["week4_duplicate_timer_on_1"] = streams["week4_duplicate_timer_on_1"]
	end
	if streams["week4_duplicate_timer_off_2"] ~= nil then
		keyP["week4_duplicate_timer_off_2"] = streams["week4_duplicate_timer_off_2"]
	end
	if streams["week5_duplicate_timer_on_1"] ~= nil then
		keyP["week5_duplicate_timer_on_1"] = streams["week5_duplicate_timer_on_1"]
	end
	if streams["week5_duplicate_timer_off_2"] ~= nil then
		keyP["week5_duplicate_timer_off_2"] = streams["week5_duplicate_timer_off_2"]
	end
	if streams["week6_duplicate_timer_on_1"] ~= nil then
		keyP["week6_duplicate_timer_on_1"] = streams["week6_duplicate_timer_on_1"]
	end
	if streams["week6_duplicate_timer_off_2"] ~= nil then
		keyP["week6_duplicate_timer_off_2"] = streams["week6_duplicate_timer_off_2"]
	end
	if streams["timer_control"] ~= nil then
		keyP["timer_control"] = 1
	end
	if streams["eco"] ~= nil then
		keyP["eco"] = streams["eco"]
	end
	if streams["prevent_super_cool"] ~= nil then
		keyP["prevent_super_cool"] = streams["prevent_super_cool"]
	end
	if streams["fresh_air_remove_odor"] ~= nil then
		keyP["fresh_air_remove_odor"] = streams["fresh_air_remove_odor"]
	end
	if streams["inner_cycle_switch"] ~= nil then
		keyP["inner_cycle_switch"] = streams["inner_cycle_switch"]
	end
	if streams["inner_cycle_mode"] ~= nil then
		keyP["inner_cycle_mode"] = streams["inner_cycle_mode"]
	end
	if streams["total_time_switch"] ~= nil then
		keyP["total_time_switch"] = streams["total_time_switch"]
	end
	if streams["airoptimization_or_total_time"] ~= nil then
		keyP["airoptimization_or_total_time"] = streams["airoptimization_or_total_time"]
	end
	if streams["total_time_support"] ~= nil then
		keyP["total_time_support"] = streams["total_time_support"]
	end
	if streams["remove_arofene"] ~= nil then
		keyP["remove_arofene"] = streams["remove_arofene"]
	end
	if streams["voice_control"] ~= nil then
		if streams["voice_control"] == "on" then
			keyP["voice_control"] = 1
		elseif streams["voice_control"] == "off" then
			keyP["voice_control"] = 0
		else
			keyP["voice_control"] = streams["voice_control"]
		end
	end
	if streams["voice_control_speaking"] ~= nil then
		keyP["voice_control_speaking"] = streams["voice_control_speaking"]
	end
	if streams["fengguan_remove_odor"] ~= nil then
		keyP["fengguan_remove_odor"] = streams["fengguan_remove_odor"]
	end
	if streams["support_magic_cube"] ~= nil then
		keyP["support_magic_cube"] = streams["support_magic_cube"]
	end
	if streams["timer_announcement"] ~= nil then
		keyP["timer_announcement"] = streams["timer_announcement"]
	end
	if streams["new_home_remove_arofene"] ~= nil then
		keyP["new_home_remove_arofene"] = streams["new_home_remove_arofene"]
	end
	if streams["new_home_remove_arofene_exit"] ~= nil then
		keyP["new_home_remove_arofene_exit"] = streams["new_home_remove_arofene_exit"]
	end
	if streams["shortest_remove_odor_time"] ~= nil then
		keyP["shortest_remove_odor_time"] = streams["shortest_remove_odor_time"]
	end
	if streams["longest_remove_odor_time"] ~= nil then
		keyP["longest_remove_odor_time"] = streams["longest_remove_odor_time"]
	end
	if streams["smart_humi_control_algorithm"] ~= nil and jsonType == "control" then
		keyP["smart_humi_control_algorithm"] = streams["smart_humi_control_algorithm"]
	end
	if streams["fresh_air_exhaust_wind"] ~= nil then
		keyP["fresh_air_exhaust_wind"] = streams["fresh_air_exhaust_wind"]
	end
	if streams["fresh_air_intake_wind"] ~= nil then
		keyP["fresh_air_intake_wind"] = streams["fresh_air_intake_wind"]
	end
	if streams["energy_new_wind"] ~= nil then
		keyP["energy_new_wind"] = streams["energy_new_wind"]
	end
	if streams["new_wind_model_intake_switch"] ~= nil then
		keyP["new_wind_model_intake_switch"] = streams["new_wind_model_intake_switch"]
	end
	if streams["new_wind_model_exhaust_switch"] ~= nil then
		keyP["new_wind_model_exhaust_switch"] = streams["new_wind_model_exhaust_switch"]
	end
	if streams["new_wind_model_mute"] ~= nil then
		keyP["new_wind_model_mute"] = streams["new_wind_model_mute"]
	end
	if streams["tube_protect"] ~= nil then
		keyP["tube_protect"] = streams["tube_protect"]
	end
	if streams["new_wind_model_on_timer"] ~= nil then
		keyP["new_wind_model_on_timer"] = streams["new_wind_model_on_timer"]
	end
	if streams["new_wind_model_on_timer"] ~= nil then
		keyP["new_wind_model_on_timer"] = streams["new_wind_model_on_timer"]
	end
	if streams["new_wind_model_on_timer"] ~= nil then
		keyP["new_wind_model_on_timer"] = streams["new_wind_model_on_timer"]
	end
	if streams["new_wind_model_off_timer"] ~= nil then
		keyP["new_wind_model_off_timer"] = streams["new_wind_model_off_timer"]
	end
	if streams["new_wind_model_intake_wind"] ~= nil then
		keyP["new_wind_model_intake_wind"] = streams["new_wind_model_intake_wind"]
	end
	if streams["new_wind_model_exhaust_wind"] ~= nil then
		keyP["new_wind_model_exhaust_wind"] = streams["new_wind_model_exhaust_wind"]
	end
	if streams["new_wind_model_on_timer_value"] ~= nil then
		keyP["new_wind_model_on_timer_value"] = streams["new_wind_model_on_timer_value"]
	end
	if streams["new_wind_model_off_timer_value"] ~= nil then
		keyP["new_wind_model_off_timer_value"] = streams["new_wind_model_off_timer_value"]
	end
	if streams["new_wind_model_timer_effect"] ~= nil and jsonType == "control" then
		keyP["new_wind_model_timer_effect"] = streams["new_wind_model_timer_effect"]
	end
	if streams["female_care"] ~= nil then
		keyP["female_care"] = streams["female_care"]
	end
	if streams["control_c006"] ~= nil and jsonType == "control" then
		keyP["control_c006"] = 1
	end
	if streams["product_type"] ~= nil then
		keyP["product_type"] = streams["product_type"]
	end
	if streams["indoor_machine_one_speed"] ~= nil then
		keyP["indoor_machine_one_speed"] = streams["indoor_machine_one_speed"]
	end
	if streams["indoor_machine_two_speed"] ~= nil then
		keyP["indoor_machine_two_speed"] = streams["indoor_machine_two_speed"]
	end
	if streams["indoor_elec_expansion_valve_one"] ~= nil then
		keyP["indoor_elec_expansion_valve_one"] = streams["indoor_elec_expansion_valve_one"]
	end
	if streams["indoor_elec_expansion_valve_two"] ~= nil then
		keyP["indoor_elec_expansion_valve_two"] = streams["indoor_elec_expansion_valve_two"]
	end
	if streams["in_water_pump_force"] ~= nil then
		keyP["in_water_pump_force"] = streams["in_water_pump_force"]
	end
	if streams["out_water_pump_force"] ~= nil then
		keyP["out_water_pump_force"] = streams["out_water_pump_force"]
	end
	if streams["energy_need_c0"] ~= nil then
		keyP["energy_need_c0"] = streams["energy_need_c0"]
	end
	if streams["ptc_support_force"] ~= nil then
		keyP["ptc_support_force"] = streams["ptc_support_force"]
	end
	if streams["indoor_lr_wind_angle"] ~= nil then
		keyP["indoor_lr_wind_angle"] = streams["indoor_lr_wind_angle"]
	end
	if streams["indoor_ud_wind_angle"] ~= nil then
		keyP["indoor_ud_wind_angle"] = streams["indoor_ud_wind_angle"]
	end
	if streams["fengguan_one_speed_enable"] ~= nil then
		keyP["fengguan_one_speed_enable"] = streams["fengguan_one_speed_enable"]
	end
	if streams["fengguan_two_speed_enable"] ~= nil then
		keyP["fengguan_two_speed_enable"] = streams["fengguan_two_speed_enable"]
	end
	if streams["new_wind_two_speed_enable"] ~= nil then
		keyP["new_wind_two_speed_enable"] = streams["new_wind_two_speed_enable"]
	end
	if streams["new_wind_one_speed_enable"] ~= nil then
		keyP["new_wind_one_speed_enable"] = streams["new_wind_one_speed_enable"]
	end
	if streams["new_wind_model_gate"] ~= nil then
		keyP["new_wind_model_gate"] = streams["new_wind_model_gate"]
	end
	if streams["remove_odor_c0"] ~= nil then
		keyP["remove_odor_c0"] = streams["remove_odor_c0"]
	end
	if streams["force_wind_machine_one_speed"] ~= nil then
		keyP["force_wind_machine_one_speed"] = streams["force_wind_machine_one_speed"]
	end
	if streams["force_wind_machine_two_speed"] ~= nil then
		keyP["force_wind_machine_two_speed"] = streams["force_wind_machine_two_speed"]
	end
	if streams["force_expansion_valve_one_speed"] ~= nil then
		keyP["force_expansion_valve_one_speed"] = streams["force_expansion_valve_one_speed"]
	end
	if streams["force_expansion_valve_two_speed"] ~= nil then
		keyP["force_expansion_valve_two_speed"] = streams["force_expansion_valve_two_speed"]
	end
	if streams["in_water_pump"] ~= nil then
		keyP["in_water_pump"] = streams["in_water_pump"]
	end
	if streams["out_water_pump"] ~= nil then
		keyP["out_water_pump"] = streams["out_water_pump"]
	end
	if streams["ptc_support"] ~= nil then
		keyP["ptc_support"] = streams["ptc_support"]
	end
	if streams["indoor_energy_need"] ~= nil then
		keyP["indoor_energy_need"] = streams["indoor_energy_need"]
	end
	if streams["wind_swing_lr_c0"] ~= nil then
		keyP["wind_swing_lr_c0"] = streams["wind_swing_lr_c0"]
	end
	if streams["wind_swing_ud_c0"] ~= nil then
		keyP["wind_swing_ud_c0"] = streams["wind_swing_ud_c0"]
	end
	if streams["fengguan_indoor_one_speed_level"] ~= nil then
		keyP["fengguan_indoor_one_speed_level"] = streams["fengguan_indoor_one_speed_level"]
	end
	if streams["fengguan_indoor_two_speed_level"] ~= nil then
		keyP["fengguan_indoor_two_speed_level"] = streams["fengguan_indoor_two_speed_level"]
	end
	if streams["has_heater"] ~= nil then
		keyP["has_heater"] = streams["has_heater"]
	end
	if streams["has_shunt_valve"] ~= nil then
		keyP["has_shunt_valve"] = streams["has_shunt_valve"]
	end
	if streams["heater_heating_switch"] ~= nil then
		keyP["heater_heating_switch"] = streams["heater_heating_switch"]
	end
	if streams["machine_address"] ~= nil then
		keyP["machine_address"] = streams["machine_address"]
	end
	if streams["pack_id"] ~= nil then
		keyP["pack_id"] = streams["pack_id"]
	end
	if streams["fg_timer_number"] ~= nil and jsonType == "control" then
		keyP["fg_timer_number"] = streams["fg_timer_number"]
	end
	if streams["fg_timer1_week0_effect"] ~= nil then
		keyP["fg_timer1_week0_effect"] = streams["fg_timer1_week0_effect"]
	end
	if streams["fg_timer1_week1_effect"] ~= nil then
		keyP["fg_timer1_week1_effect"] = streams["fg_timer1_week1_effect"]
	end
	if streams["fg_timer1_week2_effect"] ~= nil then
		keyP["fg_timer1_week2_effect"] = streams["fg_timer1_week2_effect"]
	end
	if streams["fg_timer1_week3_effect"] ~= nil then
		keyP["fg_timer1_week3_effect"] = streams["fg_timer1_week3_effect"]
	end
	if streams["fg_timer1_week4_effect"] ~= nil then
		keyP["fg_timer1_week4_effect"] = streams["fg_timer1_week4_effect"]
	end
	if streams["fg_timer1_week4_effect"] ~= nil then
		keyP["fg_timer1_week4_effect"] = streams["fg_timer1_week4_effect"]
	end
	if streams["fg_timer1_week5_effect"] ~= nil then
		keyP["fg_timer1_week5_effect"] = streams["fg_timer1_week5_effect"]
	end
	if streams["fg_timer1_week6_effect"] ~= nil then
		keyP["fg_timer1_week6_effect"] = streams["fg_timer1_week6_effect"]
	end
	if streams["fg_timer1_select"] ~= nil then
		keyP["fg_timer1_select"] = streams["fg_timer1_select"]
	end
	if streams["fg_timer1_wind_speed"] ~= nil then
		keyP["fg_timer1_wind_speed"] = streams["fg_timer1_wind_speed"]
	end
	if streams["fg_timer1_power"] ~= nil then
		keyP["fg_timer1_power"] = streams["fg_timer1_power"]
	end
	if streams["fg_timer1_mode"] ~= nil then
		keyP["fg_timer1_mode"] = streams["fg_timer1_mode"]
	end
	if streams["fg_timer1_hour"] ~= nil then
		keyP["fg_timer1_hour"] = streams["fg_timer1_hour"]
	end
	if streams["fg_timer1_min"] ~= nil then
		keyP["fg_timer1_min"] = streams["fg_timer1_min"]
	end
	if streams["fg_timer1_temperature"] ~= nil then
		keyP["fg_timer1_temperature"] = streams["fg_timer1_temperature"]
	end
	if streams["fg_timer2_week0_effect"] ~= nil then
		keyP["fg_timer2_week0_effect"] = streams["fg_timer2_week0_effect"]
	end
	if streams["fg_timer2_week1_effect"] ~= nil then
		keyP["fg_timer2_week1_effect"] = streams["fg_timer2_week1_effect"]
	end
	if streams["fg_timer2_week2_effect"] ~= nil then
		keyP["fg_timer2_week2_effect"] = streams["fg_timer2_week2_effect"]
	end
	if streams["fg_timer2_week3_effect"] ~= nil then
		keyP["fg_timer2_week3_effect"] = streams["fg_timer2_week3_effect"]
	end
	if streams["fg_timer2_week4_effect"] ~= nil then
		keyP["fg_timer2_week4_effect"] = streams["fg_timer2_week4_effect"]
	end
	if streams["fg_timer2_week4_effect"] ~= nil then
		keyP["fg_timer2_week4_effect"] = streams["fg_timer2_week4_effect"]
	end
	if streams["fg_timer2_week5_effect"] ~= nil then
		keyP["fg_timer2_week5_effect"] = streams["fg_timer2_week5_effect"]
	end
	if streams["fg_timer2_week6_effect"] ~= nil then
		keyP["fg_timer2_week6_effect"] = streams["fg_timer2_week6_effect"]
	end
	if streams["fg_timer2_select"] ~= nil then
		keyP["fg_timer2_select"] = streams["fg_timer2_select"]
	end
	if streams["fg_timer2_wind_speed"] ~= nil then
		keyP["fg_timer2_wind_speed"] = streams["fg_timer2_wind_speed"]
	end
	if streams["fg_timer2_power"] ~= nil then
		keyP["fg_timer2_power"] = streams["fg_timer2_power"]
	end
	if streams["fg_timer2_mode"] ~= nil then
		keyP["fg_timer2_mode"] = streams["fg_timer2_mode"]
	end
	if streams["fg_timer2_hour"] ~= nil then
		keyP["fg_timer2_hour"] = streams["fg_timer2_hour"]
	end
	if streams["fg_timer2_min"] ~= nil then
		keyP["fg_timer2_min"] = streams["fg_timer2_min"]
	end
	if streams["fg_timer2_temperature"] ~= nil then
		keyP["fg_timer2_temperature"] = streams["fg_timer2_temperature"]
	end
	if streams["stop_warm_support"] ~= nil then
		keyP["stop_warm_support"] = streams["stop_warm_support"]
	end
	if streams["water_temp_linkage_support"] ~= nil then
		keyP["water_temp_linkage_support"] = streams["water_temp_linkage_support"]
	end
	if streams["water_temp_linkage_switch"] ~= nil then
		keyP["water_temp_linkage_switch"] = streams["water_temp_linkage_switch"]
	end
	if streams["water_model_dry"] ~= nil then
		keyP["water_model_dry"] = streams["water_model_dry"]
	end
	if streams["water_model_force_temp"] ~= nil then
		keyP["water_model_force_temp"] = streams["water_model_force_temp"]
	end
	if streams["smart_water_model"] ~= nil then
		keyP["smart_water_model"] = streams["smart_water_model"]
	end
	if streams["single_control"] ~= nil then
		keyP["single_control"] = streams["single_control"]
	end
	if streams["new_wind_single_control"] ~= nil then
		keyP["new_wind_single_control"] = streams["new_wind_single_control"]
	end
	if streams["new_wind_machine_type"] ~= nil then
		keyP["new_wind_machine_type"] = streams["new_wind_machine_type"]
	end
	if streams["network_sn"] ~= nil then
		keyP["network_sn"] = streams["network_sn"]
	end
	if streams["save_energy_mode_effective_countdown"] ~= nil then
		keyP["save_energy_mode_effective_countdown"] = streams["save_energy_mode_effective_countdown"]
		if jsonType == "control" then
			keyP["save_energy_mode_effective_countdown_setting_enable"] = 1
		end
	end
	if streams["nobody_off_switch"] ~= nil then
		keyP["nobody_off_switch"] = streams["nobody_off_switch"]
		if jsonType == "control" then
			keyP["nobody_off_switch_setting_enable"] = 1
		end
	end
	if streams["nobody_off_time"] ~= nil then
		keyP["nobody_off_time"] = streams["nobody_off_time"]
		if jsonType == "control" then
			keyP["nobody_off_time_setting_enable"] = 1
		end
	end
	if streams["follow_body_sense_enable"] ~= nil and jsonType == "control" then
		keyP["follow_body_sense_enable"] = streams["follow_body_sense_enable"]
	end
	if streams["double_engine_heat"] ~= nil then
		keyP["double_engine_heat"] = streams["double_engine_heat"]
	end
	if streams["double_engine_heat_enable"] ~= nil then
		keyP["double_engine_heat_enable"] = streams["double_engine_heat_enable"]
	end
	if streams["smart_hybird"] ~= nil then
		keyP["smart_hybird"] = streams["smart_hybird"]
	end
	if streams["smart_hybird_enable"] ~= nil then
		keyP["smart_hybird_enable"] = streams["smart_hybird_enable"]
	end
	if streams["smart_hybird_pause"] ~= nil then
		keyP["smart_hybird_pause"] = streams["smart_hybird_pause"]
	end
	if streams["fresh_air_exhaust_fan_speed"] ~= nil then
		keyP["fresh_air_exhaust_fan_speed"] = streams["fresh_air_exhaust_fan_speed"]
	end
	if streams["fresh_air_intake_fan_speed"] ~= nil then
		keyP["fresh_air_intake_fan_speed"] = streams["fresh_air_intake_fan_speed"]
	end
	if streams["keep_warm"] ~= nil then
		keyP["keep_warm"] = streams["keep_warm"]
	end
	if streams["ventilator"] ~= nil then
		keyP["ventilator"] = streams["ventilator"]
	end
	if streams["fast_heat"] ~= nil then
		keyP["fast_heat"] = streams["fast_heat"]
	end
	if streams["fast_heat_angle"] ~= nil then
		keyP["fast_heat_angle"] = streams["fast_heat_angle"]
	end
	if streams["close_huanqi_time"] ~= nil then
		keyP["close_huanqi_time"] = streams["close_huanqi_time"]
	end
	if streams["ventilator_level"] ~= nil then
		keyP["ventilator_level"] = streams["ventilator_level"]
	end
	if streams["remote_switch"] ~= nil then
		keyP["remote_switch"] = streams["remote_switch"]
	end
	if streams["prevent_straight_wind"] ~= nil then
		keyP["prevent_straight_wind"] = streams["prevent_straight_wind"]
	end
	if streams["prevent_straight_wind_enable"] ~= nil then
		keyP["prevent_straight_wind_enable"] = streams["prevent_straight_wind_enable"]
	end
	if streams["independent_swing_enable"] ~= nil then
		keyP["independent_swing_enable"] = streams["independent_swing_enable"]
	end
	if streams["up_swing"] ~= nil then
		keyP["up_swing"] = streams["up_swing"]
	end
	if streams["down_swing"] ~= nil then
		keyP["down_swing"] = streams["down_swing"]
	end
	if streams["left_swing"] ~= nil then
		keyP["left_swing"] = streams["left_swing"]
	end
	if streams["right_swing"] ~= nil then
		keyP["right_swing"] = streams["right_swing"]
	end
	if streams["up_swing_angle"] ~= nil then
		keyP["up_swing_angle"] = streams["up_swing_angle"]
	end
	if streams["down_swing_angle"] ~= nil then
		keyP["down_swing_angle"] = streams["down_swing_angle"]
	end
	if streams["left_swing_angle"] ~= nil then
		keyP["left_swing_angle"] = streams["left_swing_angle"]
	end
	if streams["right_swing_angle"] ~= nil then
		keyP["right_swing_angle"] = streams["right_swing_angle"]
	end
	if streams["target_address"] ~= nil then
		keyP["target_address"] = streams["target_address"]
	end
	if streams["dry_type"] ~= nil then
		keyP["dry_type"] = streams["dry_type"]
		if jsonType == "control" then
			keyP["dry_type_control"] = 1
		end
	end
	if streams["c002_dry_type_support"] ~= nil then
		keyP["c002_dry_type_support"] = streams["c002_dry_type_support"]
	end
	if streams["ieco_switch"] ~= nil then
		keyP["ieco_switch"] = streams["ieco_switch"]
	end
	if streams["ieco_enable"] ~= nil then
		keyP["ieco_enable"] = streams["ieco_enable"]
	end
	if streams["ieco_indoor_wind_speed_level"] ~= nil then
		keyP["ieco_indoor_wind_speed_level"] = streams["ieco_indoor_wind_speed_level"]
	end
	if streams["ieco_target_rate"] ~= nil then
		keyP["ieco_target_rate"] = streams["ieco_target_rate"]
	end
	if streams["ieco_strong_wind"] ~= nil then
		keyP["ieco_strong_wind"] = streams["ieco_strong_wind"]
	end
	if streams["mode_memory_enable"] ~= nil then
		keyP["mode_memory_enable"] = streams["mode_memory_enable"]
	end
	if streams["smart_frequency_conversion"] ~= nil then
		keyP["smart_frequency_conversion"] = streams["smart_frequency_conversion"]
	end
	if streams["ai_humidity_control"] ~= nil then
		keyP["ai_humidity_control"] = streams["ai_humidity_control"]
	end
	if streams["ptc_mode"] ~= nil then
		keyP["ptc_mode"] = streams["ptc_mode"]
	end
	if streams["down_horizontal_wind_direction"] ~= nil then
		keyP["down_horizontal_wind_direction"] = streams["down_horizontal_wind_direction"]
	end
	if streams["down_wind_swing_lr"] ~= nil then
		keyP["down_wind_swing_lr"] = streams["down_wind_swing_lr"]
	end
	if streams["down_wind_swing_ud"] ~= nil then
		keyP["down_wind_swing_ud"] = streams["down_wind_swing_ud"]
	end
	if streams["down_wind_switch"] ~= nil then
		keyP["down_wind_switch"] = streams["down_wind_switch"]
	end
	if streams["side_wind_switch"] ~= nil then
		keyP["side_wind_switch"] = streams["side_wind_switch"]
	end
	if streams["buzzer_off_status"] ~= nil then
		keyP["buzzer_off_status"] = streams["buzzer_off_status"]
	end
	if streams["buzzer_control"] ~= nil then
		keyP["buzzer_control"] = streams["buzzer_control"]
	end
	if streams["power_tip_light_switch"] ~= nil then
		keyP["power_tip_light_switch"] = streams["power_tip_light_switch"]
	end
	if streams["smart_wind"] ~= nil then
		keyP["smart_wind"] = streams["smart_wind"]
	end
	if streams["human_close_gentle_wind"] ~= nil then
		keyP["human_close_gentle_wind"] = streams["human_close_gentle_wind"]
	end
	if streams["smart_wind_sensitivity"] ~= nil then
		keyP["smart_wind_sensitivity"] = streams["smart_wind_sensitivity"]
	end
	if streams["remote_receive_switch"] ~= nil then
		keyP["remote_receive_switch"] = streams["remote_receive_switch"]
	end
	if streams["power_off_mode_enable_switch"] ~= nil then
		keyP["power_off_mode_enable_switch"] = streams["power_off_mode_enable_switch"]
	end
	if streams["has_care_mode"] ~= nil then
		keyP["has_care_mode"] = streams["has_care_mode"]
	end
	if streams["f8_control"] ~= nil then
		keyP["f8_control"] = streams["f8_control"]
	end
	if streams["f8_temperature"] ~= nil then
		keyP["f8_temperature"] = streams["f8_temperature"]
	end
	if streams["f8_humidity"] ~= nil then
		keyP["f8_humidity"] = streams["f8_humidity"]
	end
	if streams["f8_tvoc"] ~= nil then
		keyP["f8_tvoc"] = streams["f8_tvoc"]
	end
	if streams["f8_pm25_value"] ~= nil then
		keyP["f8_pm25_value"] = streams["f8_pm25_value"]
	end
	if streams["f8_co2_value"] ~= nil then
		keyP["f8_co2_value"] = streams["f8_co2_value"]
	end
	if streams["f8_arofene"] ~= nil then
		keyP["f8_arofene"] = streams["f8_arofene"]
	end
	if streams["sensor_status"] ~= nil then
		keyP["sensor_status"] = streams["sensor_status"]
	end
	if streams["timestamp"] ~= nil then
		keyP["timestamp"] = streams["timestamp"]
	end
	if streams["offset"] ~= nil then
		keyP["offset"] = streams["offset"]
	end
	if streams["binding_status"] ~= nil then
		keyP["binding_status"] = streams["binding_status"]
	end
	if streams["binding_type"] ~= nil then
		keyP["binding_type"] = streams["binding_type"]
	end
	if streams["mac_value"] ~= nil then
		keyP["mac_value"] = streams["mac_value"]
	end
	if streams["magic_cube_sn"] ~= nil then
		keyP["magic_cube_sn"] = streams["magic_cube_sn"]
	end
	if streams["has_sn"] ~= nil then
		keyP["has_sn"] = streams["has_sn"]
	end
end
local function binToModel(binData)
	local messageBytes = binData
	if dataType == 0x20 or dataType == 0x11 or dataType == 0xF1 then
		if #binData < 15 then
			return nil
		end
		keyP["powerValue"] = bit.band(messageBytes[0], 0x01)
		keyP["standby_clean"] = bit.rshift(bit.band(messageBytes[0], 0x02), 1)
		keyP["no_wind_sense"] = bit.rshift(bit.band(messageBytes[0], 0x08), 3)
		keyP["dryValue"] = bit.rshift(bit.band(messageBytes[0], 0x10), 4)
		keyP["strongWindValue"] = bit.rshift(bit.band(messageBytes[0], 0x20), 5)
		keyP["manulNewWind"] = bit.rshift(bit.band(messageBytes[0], 0x40), 6)
		keyP["autoNewWind"] = bit.rshift(bit.band(messageBytes[0], 0x80), 7)
		keyP["swingLeftUDValue"] = bit.band(messageBytes[1], 0x01)
		keyP["swingRightUDValue"] = bit.rshift(bit.band(messageBytes[1], 0x02), 1)
		keyP["swingUpLRValue"] = bit.rshift(bit.band(messageBytes[1], 0x04), 2)
		keyP["swingDownLRValue"] = bit.rshift(bit.band(messageBytes[1], 0x08), 3)
		keyP["forceCoolMode"] = bit.rshift(bit.band(messageBytes[1], 0x10), 4)
		keyP["forceAutoMode"] = bit.rshift(bit.band(messageBytes[1], 0x20), 5)
		keyP["PTCValue"] = bit.rshift(bit.band(messageBytes[1], 0x40), 6)
		keyP["PTCDependT4Value"] = bit.rshift(bit.band(messageBytes[1], 0x80), 7)
		keyP["cool_hot_sense"] = bit.band(messageBytes[2], 0x01)
		keyP["preventCold"] = bit.rshift(bit.band(messageBytes[2], 0x02), 1)
		keyP["wind_straight"] = bit.rshift(bit.band(messageBytes[2], 0x04), 2)
		keyP["wind_avoid"] = bit.rshift(bit.band(messageBytes[2], 0x08), 3)
		keyP["disinfect"] = bit.rshift(bit.band(messageBytes[2], 0x10), 4)
		keyP["elecDustRemove"] = bit.rshift(bit.band(messageBytes[2], 0x20), 5)
		keyP["self_clean"] = bit.rshift(bit.band(messageBytes[2], 0x40), 6)
		keyP["energySaveValue"] = bit.rshift(bit.band(messageBytes[2], 0x80), 7)
		keyP["air_optimization"] = bit.band(messageBytes[3], 0x01)
		keyP["nobody_energy_save"] = bit.rshift(bit.band(messageBytes[3], 0x02), 1)
		keyP["autoPurify"] = bit.rshift(bit.band(messageBytes[3], 0x04), 2)
		keyP["manuPurify"] = bit.rshift(bit.band(messageBytes[3], 0x08), 3)
		keyP["no_wind_sense_mode"] = bit.rshift(bit.band(messageBytes[3], 0x30), 4)
		keyP["run_test"] = bit.rshift(bit.band(messageBytes[3], 0x40), 6)
		keyP["fast_check"] = bit.rshift(bit.band(messageBytes[3], 0x80), 7)
		keyP["autoHumi"] = bit.band(messageBytes[4], 0x01)
		keyP["manuHumi"] = bit.rshift(bit.band(messageBytes[4], 0x02), 1)
		keyP["wind_strength"] = bit.rshift(bit.band(messageBytes[4], 0x04), 2)
		keyP["new_wind_machine"] = bit.rshift(bit.band(messageBytes[4], 0x08), 3)
		keyP["new_wind_machine_link"] = bit.rshift(bit.band(messageBytes[4], 0x10), 4)
		keyP["project_evacuate"] = bit.rshift(bit.band(messageBytes[4], 0x20), 5)
		keyP["follow_body_sense"] = bit.rshift(bit.band(messageBytes[4], 0x40), 6)
		keyP["exhaust_strength"] = bit.rshift(bit.band(messageBytes[4], 0x80), 7)
		keyP["modeValue"] = messageBytes[5]
		keyP["temperature"], keyP["small_temperature"] = math.modf((messageBytes[6] - 30) / 2)
		keyP["fanspeedValue"] = messageBytes[7]
		keyP["deHumidityValue"] = messageBytes[8]
		keyP["pm25LowValue"] = messageBytes[9]
		keyP["pm25HighValue"] = messageBytes[10]
		keyP["co2LowValue"] = messageBytes[11]
		keyP["co2HighValue"] = messageBytes[12]
		keyP["humidityValue"] = messageBytes[13]
		keyP["newWindModeValue"] = messageBytes[15]
		keyP["newWindSpeedValue"] = messageBytes[16]
		keyP["water_model_power"] = bit.band(messageBytes[17], 0x01)
		keyP["water_model_power_save"] = bit.rshift(bit.band(messageBytes[17], 0x02), 1)
		keyP["water_model_clean"] = bit.rshift(bit.band(messageBytes[17], 0x04), 2)
		keyP["water_model_temperature_auto"] = bit.rshift(bit.band(messageBytes[17], 0x08), 3)
		keyP["water_model_ptc"] = bit.rshift(bit.band(messageBytes[17], 0x10), 4)
		keyP["water_model_go_out"] = bit.rshift(bit.band(messageBytes[17], 0x80), 7)
		keyP["water_mode"] = messageBytes[18]
		keyP["water_model_temperature_set"] = (messageBytes[19] - 50) / 2
		keyP["has_huifeng"] = bit.band(messageBytes[20], 0x01)
		keyP["has_chufeng"] = bit.rshift(bit.band(messageBytes[20], 0x02), 1)
		keyP["has_wind_lr"] = bit.rshift(bit.band(messageBytes[20], 0x04), 2)
		keyP["has_no_wind_sense"] = bit.rshift(bit.band(messageBytes[20], 0x08), 3)
		keyP["has_xinfeng"] = bit.rshift(bit.band(messageBytes[20], 0x10), 4)
		keyP["has_humidifer"] = bit.rshift(bit.band(messageBytes[20], 0x20), 5)
		keyP["has_water_model"] = bit.rshift(bit.band(messageBytes[20], 0x40), 6)
		keyP["fengguan_has_water_timer_right"] = bit.rshift(bit.band(messageBytes[20], 0x80), 7)
		keyP["air_optimization_temperature"] = (messageBytes[21] - 30) / 2
		keyP["air_optimization_humidity"] = messageBytes[22]
		keyP["air_optimization_wind"] = messageBytes[23]
		if #binData > 26 then
			keyP["comfortableSleepValue"] = bit.band(messageBytes[25], 0x30)
			keyP["power_on_timer"] = bit.band(messageBytes[25], 0x01)
			keyP["power_off_timer"] = bit.rshift(bit.band(messageBytes[25], 0x02), 1)
			keyP["timer_enable"] = bit.rshift(bit.band(messageBytes[25], 0x04), 2)
			keyP["stop_warm"] = bit.rshift(bit.band(messageBytes[25], 0x08), 3)
			keyP["eco"] = bit.rshift(bit.band(messageBytes[25], 0x40), 6)
			keyP["prevent_super_cool"] = bit.rshift(bit.band(messageBytes[25], 0x80), 7)
			keyP["power_on_time_value"] = bit.bor(bit.lshift(bit.band(messageBytes[28], 0x0F), 8), messageBytes[26])
			keyP["power_off_time_value"] = bit.bor(bit.lshift(bit.band(messageBytes[28], 0xF0), 4), messageBytes[27])
			keyP["up_down_wind_direction"] = bit.band(messageBytes[29], 0x0F)
			keyP["left_right_wind_direction"] = bit.rshift(bit.band(messageBytes[29], 0xF0), 4)
		end
		if #binData > 35 then
			keyP["fresh_air_remove_odor"] = bit.rshift(bit.band(messageBytes[36], 0x80), 7)
		end
		if #binData > 36 then
			keyP["total_time_support"] = bit.rshift(bit.band(messageBytes[37], 0x04), 2)
			keyP["airoptimization_or_total_time"] = bit.rshift(bit.band(messageBytes[37], 0x08), 3)
			keyP["total_time_switch"] = bit.rshift(bit.band(messageBytes[37], 0x10), 4)
			keyP["dry_type"] = bit.band(messageBytes[37], 0x03)
			keyP["inner_cycle_mode"] = bit.rshift(bit.band(messageBytes[37], 0x04), 2)
			keyP["inner_cycle_switch"] = bit.rshift(bit.band(messageBytes[37], 0x08), 3)
			keyP["remove_arofene"] = bit.rshift(bit.band(messageBytes[37], 0x20), 5)
			keyP["voice_control"] = bit.rshift(bit.band(messageBytes[37], 0x40), 6)
			keyP["voice_control_speaking"] = bit.rshift(bit.band(messageBytes[37], 0x80), 7)
		end
		if #binData > 37 then
			keyP["fengguan_remove_odor"] = bit.band(messageBytes[38], 0x01)
			keyP["support_magic_cube"] = bit.rshift(bit.band(messageBytes[38], 0x02), 1)
			keyP["new_home_remove_arofene"] = bit.rshift(bit.band(messageBytes[38], 0x38), 3)
			keyP["energy_new_wind"] = bit.rshift(bit.band(messageBytes[38], 0x40), 6)
			keyP["smart_humi_control_algorithm"] = bit.rshift(bit.band(messageBytes[38], 0x80), 7)
		end
		if #binData > 39 then
			keyP["shortest_remove_odor_time"] = messageBytes[39] + messageBytes[40] * 256
		end
		if #binData > 41 then
			keyP["longest_remove_odor_time"] = messageBytes[41] + messageBytes[42] * 256
		end
		if #binData > 42 then
			keyP["fresh_air_intake_wind"] = messageBytes[43]
		end
		if #binData > 43 then
			keyP["fresh_air_exhaust_wind"] = messageBytes[44]
		end
		if #binData > 44 then
			keyP["new_wind_model_intake_switch"] = bit.band(messageBytes[45], 0x01)
			keyP["new_wind_model_exhaust_switch"] = bit.rshift(bit.band(messageBytes[45], 0x02), 1)
			keyP["new_wind_model_mute"] = bit.rshift(bit.band(messageBytes[45], 0x04), 2)
			keyP["tube_protect"] = bit.rshift(bit.band(messageBytes[45], 0x08), 3)
			keyP["new_wind_model_on_timer"] = bit.rshift(bit.band(messageBytes[45], 0x10), 4)
			keyP["new_wind_model_off_timer"] = bit.rshift(bit.band(messageBytes[45], 0x20), 5)
			keyP["new_wind_model_timer_effect"] = bit.rshift(bit.band(messageBytes[45], 0x40), 6)
			keyP["female_care"] = bit.rshift(bit.band(messageBytes[45], 0x80), 7)
		end
		if #binData > 45 then
			keyP["new_wind_model_intake_wind"] = messageBytes[46]
		end
		if #binData > 46 then
			keyP["new_wind_model_exhaust_wind"] = messageBytes[47]
		end
		if #binData > 49 then
			keyP["new_wind_model_on_timer_value"] =
				bit.bor(bit.lshift(bit.band(messageBytes[50], 0x0F), 8), messageBytes[48])
			keyP["new_wind_model_off_timer_value"] =
				bit.bor(bit.lshift(bit.band(messageBytes[50], 0xF0), 4), messageBytes[49])
		end
		if #binData > 51 then
			keyP["has_heater"] = bit.band(messageBytes[52], 0x01)
			keyP["has_shunt_valve"] = bit.rshift(bit.band(messageBytes[52], 0x02), 1)
			keyP["heater_heating_switch"] = bit.rshift(bit.band(messageBytes[52], 0x04), 2)
			keyP["stop_warm_support"] = bit.rshift(bit.band(messageBytes[52], 0x08), 3)
			keyP["water_temp_linkage_support"] = bit.rshift(bit.band(messageBytes[52], 0x10), 4)
			keyP["water_temp_linkage_switch"] = bit.rshift(bit.band(messageBytes[52], 0x20), 5)
			keyP["water_model_dry"] = bit.rshift(bit.band(messageBytes[52], 0x40), 6)
			keyP["airoptimization_unsupport"] = bit.rshift(bit.band(messageBytes[52], 0x80), 7)
		end
		if #binData > 52 then
			keyP["water_model_force_temp"] = bit.band(messageBytes[53], 0x7F)
			keyP["smart_water_model"] = bit.rshift(bit.band(messageBytes[53], 0x80), 7)
		end
		if #binData > 53 then
			keyP["single_control"] = bit.band(messageBytes[54], 0x01)
			keyP["single_select"] = bit.rshift(bit.band(messageBytes[54], 0x02), 1)
			keyP["single_status"] = bit.rshift(bit.band(messageBytes[54], 0x04), 2)
			keyP["new_wind_single_control"] = bit.rshift(bit.band(messageBytes[54], 0x08), 3)
			keyP["has_quick_fry"] = bit.rshift(bit.band(messageBytes[54], 0x10), 4)
			keyP["quick_fry"] = bit.rshift(bit.band(messageBytes[54], 0x20), 5)
			keyP["has_prepare_food"] = bit.rshift(bit.band(messageBytes[54], 0x40), 6)
			keyP["prepare_food"] = bit.rshift(bit.band(messageBytes[54], 0x80), 7)
		end
		if #binData > 54 then
			keyP["new_wind_machine_intake_switch"] = bit.rshift(bit.band(messageBytes[55], 0x20), 5)
			keyP["new_wind_machine_exhaust_switch"] = bit.rshift(bit.band(messageBytes[55], 0x40), 6)
			keyP["has_follow_body_sense"] = bit.rshift(bit.band(messageBytes[55], 0x80), 7)
		end
		if #binData > 56 then
			keyP["save_energy_mode_effective_countdown"] =
				bit.bor(bit.lshift(bit.band(messageBytes[56], 0x7F), 4), bit.band(messageBytes[55], 0x0F))
			keyP["nobody_off_switch"] = bit.rshift(bit.band(messageBytes[55], 0x10), 4)
			keyP["nobody_off_time"] = bit.rshift(bit.band(messageBytes[57], 0XFC), 2)
		end
		if #binData > 57 then
			keyP["has_fast_heat"] = bit.band(messageBytes[58], 0x01)
			keyP["fast_heat"] = bit.rshift(bit.band(messageBytes[58], 0x02), 1)
			keyP["has_keep_warm"] = bit.rshift(bit.band(messageBytes[58], 0x04), 2)
			keyP["keep_warm"] = bit.rshift(bit.band(messageBytes[58], 0x08), 3)
			keyP["has_ventilator"] = bit.rshift(bit.band(messageBytes[58], 0x10), 4)
			keyP["ventilator"] = bit.rshift(bit.band(messageBytes[58], 0x20), 5)
			keyP["no_nobody_energy_save_support"] = bit.rshift(bit.band(messageBytes[58], 0x40), 6)
			keyP["no_cool_hot_sense_support"] = bit.rshift(bit.band(messageBytes[58], 0x80), 7)
		end
		if #binData > 58 then
			keyP["fast_heat_angle"] = bit.band(messageBytes[59], 0x7F)
			keyP["has_fast_heat_angle"] = bit.rshift(bit.band(messageBytes[59], 0x80), 7)
		end
		if #binData > 59 then
			keyP["fengguan_type"] = messageBytes[60]
		end
		if #binData > 60 then
			keyP["new_wind_machine_type"] = messageBytes[61]
		end
		if #binData > 61 then
			keyP["fresh_air_intake_fan_speed"] = bit.band(messageBytes[62], 0x7F)
			keyP["has_new_wind_machine_intake_switch"] = bit.rshift(bit.band(messageBytes[62], 0x80), 7)
		end
		if #binData > 62 then
			keyP["fresh_air_exhaust_fan_speed"] = bit.band(messageBytes[63], 0x7F)
			keyP["has_new_wind_machine_exhaust_switch"] = bit.rshift(bit.band(messageBytes[63], 0x80), 7)
		end
		if #binData > 63 then
			keyP["quick_prepare_food_angle"] = bit.band(messageBytes[64], 0x7F)
			keyP["has_quick_prepare_food_angle"] = bit.rshift(bit.band(messageBytes[64], 0x80), 7)
		end
		if #binData > 64 then
			keyP["double_engine_heat"] = bit.band(messageBytes[65], 0x01)
			keyP["has_double_engine_heat"] = bit.rshift(bit.band(messageBytes[65], 0x02), 1)
			keyP["smart_hybird"] = bit.rshift(bit.band(messageBytes[65], 0x04), 2)
			keyP["has_smart_hybird"] = bit.rshift(bit.band(messageBytes[65], 0x08), 3)
			keyP["smart_hybird_pause"] = bit.rshift(bit.band(messageBytes[65], 0x10), 4)
			keyP["c003_protocol_support"] = bit.rshift(bit.band(messageBytes[65], 0x20), 5)
			keyP["c003_protocol_inner_support"] = bit.rshift(bit.band(messageBytes[65], 0x40), 6)
			keyP["no_wind_swing_ud_support"] = bit.rshift(bit.band(messageBytes[65], 0x80), 7)
		end
		if #binData > 65 then
			keyP["independent_strong_support"] = bit.band(messageBytes[66], 0x01)
			keyP["ventilator_level"] = bit.rshift(bit.band(messageBytes[66], 0xFE), 1)
		end
		if #binData > 66 then
			keyP["close_huanqi_time"] = bit.band(messageBytes[67], 0x7F)
			keyP["has_close_huanqi_time"] = bit.rshift(bit.band(messageBytes[67], 0x80), 7)
		end
		if #binData > 67 then
			keyP["target_temp_down"] = bit.band(messageBytes[68], 0x0F)
			if keyP["target_temp_down"] ~= 0 then
				keyP["target_temp_down"] = keyP["target_temp_down"] + 7
			end
			keyP["target_temp_up"] = bit.rshift(bit.band(messageBytes[68], 0xF0), 4)
			if keyP["target_temp_up"] ~= 0 then
				keyP["target_temp_up"] = keyP["target_temp_up"] + 21
			end
		end
		if #binData > 68 then
			keyP["remote_switch"] = bit.band(messageBytes[69], 0x01)
			keyP["has_prevent_straight_wind"] = bit.rshift(bit.band(messageBytes[69], 0x02), 1)
			keyP["prevent_straight_wind"] = bit.rshift(bit.band(messageBytes[69], 0x04), 2)
			keyP["has_independent_swing"] = bit.rshift(bit.band(messageBytes[69], 0x08), 3)
			keyP["up_swing"] = bit.rshift(bit.band(messageBytes[69], 0x10), 4)
			keyP["right_swing"] = bit.rshift(bit.band(messageBytes[69], 0x20), 5)
			keyP["down_swing"] = bit.rshift(bit.band(messageBytes[69], 0x40), 6)
			keyP["left_swing"] = bit.rshift(bit.band(messageBytes[69], 0x80), 7)
		end
		if #binData > 69 then
			keyP["up_swing_angle"] = bit.band(messageBytes[70], 0x0F)
			keyP["right_swing_angle"] = bit.rshift(bit.band(messageBytes[70], 0xF0), 4)
		end
		if #binData > 70 then
			keyP["down_swing_angle"] = bit.band(messageBytes[71], 0x0F)
			keyP["left_swing_angle"] = bit.rshift(bit.band(messageBytes[71], 0xF0), 4)
		end
		if #binData > 71 then
			keyP["mode_select"] = bit.band(messageBytes[72], 0x01)
			keyP["has_dryconstant"] = bit.rshift(bit.band(messageBytes[72], 0x02), 1)
			keyP["has_smart_dry"] = bit.rshift(bit.band(messageBytes[72], 0x04), 2)
			keyP["has_individual_dry"] = bit.rshift(bit.band(messageBytes[72], 0x08), 3)
			keyP["has_heat"] = bit.rshift(bit.band(messageBytes[72], 0x10), 4)
			keyP["has_dry"] = bit.rshift(bit.band(messageBytes[72], 0x20), 5)
			keyP["has_cool"] = bit.rshift(bit.band(messageBytes[72], 0x40), 6)
			keyP["has_auto"] = bit.rshift(bit.band(messageBytes[72], 0x80), 7)
		end
		if #binData > 72 then
			keyP["has_smart_mode"] = bit.band(messageBytes[73], 0x01)
			keyP["has_new_wind_huanqi"] = bit.rshift(bit.band(messageBytes[73], 0x02), 1)
			keyP["has_new_wind_humidity"] = bit.rshift(bit.band(messageBytes[73], 0x04), 2)
			keyP["has_new_wind_dehumidity"] = bit.rshift(bit.band(messageBytes[73], 0x08), 3)
			keyP["has_self_clean"] = bit.rshift(bit.band(messageBytes[73], 0x10), 4)
			keyP["has_dryauto"] = bit.rshift(bit.band(messageBytes[73], 0x20), 5)
			keyP["has_fan"] = bit.rshift(bit.band(messageBytes[73], 0x40), 6)
		end
		if #binData > 73 then
			keyP["has_heat_change"] = bit.band(messageBytes[74], 0x01)
			keyP["has_inner_cycle"] = bit.rshift(bit.band(messageBytes[74], 0x02), 1)
			keyP["has_slow_wind"] = bit.rshift(bit.band(messageBytes[74], 0x04), 2)
			keyP["has_fast_wind"] = bit.rshift(bit.band(messageBytes[74], 0x08), 3)
			keyP["has_slow_exhaust_wind"] = bit.rshift(bit.band(messageBytes[74], 0x10), 4)
			keyP["has_fast_exhaust_wind"] = bit.rshift(bit.band(messageBytes[74], 0x20), 5)
			keyP["has_strong_mode"] = bit.rshift(bit.band(messageBytes[74], 0x40), 6)
			keyP["has_holiday_mode"] = bit.rshift(bit.band(messageBytes[74], 0x80), 7)
		end
		if #binData > 75 then
			keyP["has_purifier_odor"] = bit.band(messageBytes[76], 0x01)
			keyP["c002_dry_type_support"] = bit.rshift(bit.band(messageBytes[76], 0x02), 1)
			keyP["has_ieco"] = bit.rshift(bit.band(messageBytes[76], 0x04), 2)
			keyP["has_passive_remove_odor_model"] = bit.rshift(bit.band(messageBytes[76], 0x10), 4)
			keyP["ieco_switch"] = bit.rshift(bit.band(messageBytes[76], 0x20), 5)
			keyP["auto_mode_wind_support"] = bit.rshift(bit.band(messageBytes[76], 0x40), 6)
			keyP["auto_mode_dry_support"] = bit.rshift(bit.band(messageBytes[76], 0x80), 7)
		end
		if #binData > 79 then
			keyP["has_ptc_memory"] = bit.band(messageBytes[80], 0x01)
			keyP["has_mode_memory"] = bit.rshift(bit.band(messageBytes[80], 0x02), 1)
			keyP["has_ai_humidity_control"] = bit.rshift(bit.band(messageBytes[80], 0x08), 3)
			keyP["has_down_wind_switch"] = bit.rshift(bit.band(messageBytes[80], 0x10), 4)
			keyP["has_side_wind_switch"] = bit.rshift(bit.band(messageBytes[80], 0x20), 5)
		end
		if #binData > 80 then
			keyP["down_wind_swing_ud"] = bit.band(messageBytes[82], 0x01)
			keyP["down_wind_swing_lr"] = bit.rshift(bit.band(messageBytes[82], 0x02), 1)
			keyP["smart_frequency_conversion"] = bit.rshift(bit.band(messageBytes[81], 0x04), 2)
			keyP["ai_humidity_control"] = bit.rshift(bit.band(messageBytes[81], 0x08), 3)
			keyP["down_wind_switch"] = bit.rshift(bit.band(messageBytes[81], 0x10), 4)
			keyP["side_wind_switch"] = bit.rshift(bit.band(messageBytes[81], 0x20), 5)
			keyP["ptc_mode"] = bit.rshift(bit.band(messageBytes[81], 0x40), 6)
			keyP["has_4c_query"] = bit.rshift(bit.band(messageBytes[81], 0x80), 7)
		end
		if #binData > 81 then
			keyP["has_down_wind_swing_ud"] = bit.band(messageBytes[82], 0x01)
			keyP["has_down_wind_swing_lr"] = bit.rshift(bit.band(messageBytes[82], 0x02), 1)
			keyP["buzzer_control"] = bit.rshift(bit.band(messageBytes[82], 0x04), 2)
			keyP["buzzer_off_status"] = bit.rshift(bit.band(messageBytes[82], 0x08), 3)
			keyP["power_tip_light_switch"] = bit.rshift(bit.band(messageBytes[82], 0x10), 4)
			keyP["ai_energy_save"] = bit.rshift(bit.band(messageBytes[82], 0x20), 5)
			keyP["has_51_query"] = bit.rshift(bit.band(messageBytes[82], 0x40), 6)
			keyP["has_15_query"] = bit.rshift(bit.band(messageBytes[82], 0x80), 7)
		end
		if #binData > 83 then
			keyP["human_close_gentle_wind"] = bit.band(messageBytes[84], 0x01)
			keyP["smart_wind"] = bit.rshift(bit.band(messageBytes[84], 0x02), 1)
			keyP["power_off_mode_enable_switch"] = bit.rshift(bit.band(messageBytes[84], 0x04), 2)
			keyP["remote_receive_switch"] = bit.rshift(bit.band(messageBytes[84], 0x08), 3)
			keyP["has_care_mode"] = bit.rshift(bit.band(messageBytes[84], 0x10), 4)
			keyP["nobody_power_off_reduce_time_switch"] = bit.rshift(bit.band(messageBytes[84], 0x20), 5)
			keyP["has_31_query"] = bit.rshift(bit.band(messageBytes[84], 0x40), 6)
			keyP["has_c004_control"] = bit.rshift(bit.band(messageBytes[84], 0x80), 7)
		end
		if #binData > 84 then
			keyP["smart_wind_sensitivity"] = messageBytes[85]
		end
	end
	if dataType == 0x4C then
		keyP["has_ptc_mode"] = bit.rshift(bit.band(messageBytes[4], 0x10), 4)
		keyP["has_buzzer"] = bit.rshift(bit.band(messageBytes[4], 0x40), 6)
		keyP["has_heat_eco"] = bit.rshift(bit.band(messageBytes[4], 0x80), 7)
		if #binData > 8 then
			keyP["has_indoor_humidity_sensor"] = bit.band(messageBytes[9], 0x01)
			keyP["has_wind_straight"] = bit.rshift(bit.band(messageBytes[9], 0x02), 1)
			keyP["has_wind_avoid"] = bit.rshift(bit.band(messageBytes[9], 0x04), 2)
			keyP["request_smart_frequency_conversion_status"] = bit.rshift(bit.band(messageBytes[9], 0x08), 3)
			keyP["smart_frequency_conversion_status"] = bit.rshift(bit.band(messageBytes[9], 0xF0), 4)
		end
		if #binData > 9 then
			keyP["has_self_clean_func"] = bit.band(messageBytes[10], 0x01)
			keyP["has_power_tip_light_switch"] = bit.rshift(bit.band(messageBytes[10], 0x02), 1)
			keyP["has_support_self_clean_func"] = bit.rshift(bit.band(messageBytes[10], 0x04), 2)
			keyP["has_power_off_mode_enable_switch"] = bit.rshift(bit.band(messageBytes[10], 0x08), 3)
			keyP["has_remote_receive_switch"] = bit.rshift(bit.band(messageBytes[10], 0x10), 4)
			keyP["has_nobody_power_off_reduce_time_switch"] = bit.rshift(bit.band(messageBytes[10], 0x40), 6)
		end
	end
	if dataType == 0x15 then
		if messageBytes[2] == 0x03 then
			keyP["radar_sensor_fault"] = bit.rshift(bit.band(messageBytes[11], 0x02), 1)
			keyP["eh3a_fault"] = bit.rshift(bit.band(messageBytes[11], 0x20), 5)
			keyP["eh3b_fault"] = bit.rshift(bit.band(messageBytes[11], 0x40), 6)
			if #binData > 55 then
				keyP["radar_number"] = messageBytes[27]
				keyP["sense_target"] = messageBytes[28]
				keyP["sense_distance"] = messageBytes[29]
				keyP["target1_distance"] = messageBytes[35]
				keyP["target1_angle"] = messageBytes[36]
				keyP["target2_distance"] = messageBytes[37]
				keyP["target2_angle"] = messageBytes[38]
				keyP["target3_distance"] = messageBytes[39]
				keyP["target3_angle"] = messageBytes[40]
				keyP["target4_distance"] = messageBytes[41]
				keyP["target4_angle"] = messageBytes[42]
				keyP["target5_distance"] = messageBytes[43]
				keyP["target5_angle"] = messageBytes[44]
				keyP["target1_area_tag"] = messageBytes[45]
				keyP["target2_area_tag"] = messageBytes[46]
				keyP["target3_area_tag"] = messageBytes[47]
				keyP["target4_area_tag"] = messageBytes[48]
				keyP["target5_area_tag"] = messageBytes[49]
				keyP["guide_strip_lr_close"] = bit.band(messageBytes[50], 0x03)
				keyP["radar_infomation_dimension"] = bit.rshift(bit.band(messageBytes[50], 0x1C), 2)
			end
		end
	end
	if dataType == 0x51 then
		if messageBytes[0] == 0x03 then
			keyP["self_clean_version"] = bit.rshift(bit.band(messageBytes[3], 0xF0), 4)
			if #binData > 5 then
				keyP["has_prevent_wrong_tip_function"] = bit.band(messageBytes[6], 0x01)
				keyP["has_elec_query"] = bit.rshift(bit.band(messageBytes[6], 0x02), 1)
			end
		end
	end
	if dataType == 0x10 then
		if #binData < 15 then
			return nil
		end
		keyP["fanspeedRealValue"] = messageBytes[5]
		keyP["run_mode"] = messageBytes[4]
		if bit.band(messageBytes[8], 0x80) == 0x80 then
			keyP["indoorTemperature"] = (0 - bit.band(bit.bnot(messageBytes[8] * 256 + messageBytes[7]) + 1, 0xffff))
				/ 100
		else
			keyP["indoorTemperature"] = (messageBytes[7] + messageBytes[8] * 256) / 100
		end
		if bit.band(messageBytes[10], 0x80) == 0x80 then
			keyP["t2_temp"] = (0 - bit.band(bit.bnot(messageBytes[10] * 256 + messageBytes[9]) + 1, 0xffff)) / 100
		else
			keyP["t2_temp"] = (messageBytes[9] + messageBytes[10] * 256) / 100
		end
		if bit.band(messageBytes[12], 0x80) == 0x80 then
			keyP["t2b_temp"] = (0 - bit.band(bit.bnot(messageBytes[12] * 256 + messageBytes[11]) + 1, 0xffff)) / 100
		else
			keyP["t2b_temp"] = (messageBytes[11] + messageBytes[12] * 256) / 100
		end
		keyP["energy_need"] = messageBytes[13]
		keyP["in_out_transport"] = bit.rshift(bit.band(messageBytes[15], 0x08), 3)
		keyP["modeClashValue"] = bit.rshift(bit.band(messageBytes[17], 0x04), 2)
		keyP["refrigerant_leakage_fault"] = bit.rshift(bit.band(messageBytes[17], 0x08), 3)
		keyP["ptc_status"] = bit.band(messageBytes[19], 0x01)
		keyP["water_full_fault"] = bit.rshift(bit.band(messageBytes[22], 0x20), 5)
		keyP["indoorPm25"] = (messageBytes[24] + messageBytes[25] * 256)
		keyP["indoorTvoc"] = (messageBytes[26] + messageBytes[27] * 256)
		keyP["indoorCo2"] = (messageBytes[28] + messageBytes[29] * 256)
		keyP["indoorHumidity"] = messageBytes[30]
		keyP["temp_compensation"] = (messageBytes[31] - 30) / 2
		keyP["filterTime"] = messageBytes[32]
		keyP["humidity_enabling"] = bit.rshift(bit.band(messageBytes[33], 0x08), 3)
		keyP["purifyFilterTime"] = messageBytes[34]
		keyP["freshFilterTime"] = messageBytes[63]
		keyP["returnAirPanelSelect"] = bit.band(messageBytes[64], 0x01)
		keyP["airPanelSelect"] = bit.rshift(bit.band(messageBytes[64], 0x02), 1)
		keyP["windLeftRightSelect"] = bit.rshift(bit.band(messageBytes[64], 0x04), 2)
		keyP["noWindSenseSelect"] = bit.rshift(bit.band(messageBytes[64], 0x08), 3)
		keyP["has_stop_warm"] = bit.rshift(bit.band(messageBytes[64], 0x10), 4)
		keyP["has_purifier"] = bit.rshift(bit.band(messageBytes[64], 0x20), 5)
		keyP["selfCleanState"] = messageBytes[71]
		keyP["selfCleanRunTime"] = messageBytes[72]
		keyP["humidifier_water_tank"] = bit.band(messageBytes[73], 0x0F)
		keyP["auto_piping"] = bit.rshift(bit.band(messageBytes[73], 0x10), 4)
		keyP["force_drainage"] = bit.rshift(bit.band(messageBytes[73], 0x20), 5)
		keyP["prevent_condensation"] = bit.rshift(bit.band(messageBytes[73], 0x40), 6)
		keyP["water_tank_load"] = bit.rshift(bit.band(messageBytes[73], 0x80), 7)
		keyP["humidifier_over_flow_protect"] = bit.band(messageBytes[74], 0x01)
		keyP["heat_water_tank_protect"] = bit.rshift(bit.band(messageBytes[74], 0x02), 1)
		keyP["voltage_protect"] = bit.rshift(bit.band(messageBytes[74], 0x04), 2)
		keyP["ptc_protect"] = bit.rshift(bit.band(messageBytes[74], 0x08), 3)
		keyP["electric_leakage_protect"] = bit.rshift(bit.band(messageBytes[74], 0x10), 4)
		keyP["machine_electric_protect"] = bit.rshift(bit.band(messageBytes[74], 0x20), 5)
		keyP["relay_bonding_fault"] = bit.rshift(bit.band(messageBytes[74], 0x40), 6)
		keyP["humidifier_freezing_protect"] = bit.rshift(bit.band(messageBytes[74], 0x80), 7)
		keyP["error_linking_fault"] = bit.band(messageBytes[75], 0x01)
		keyP["zero_point_fault"] = bit.rshift(bit.band(messageBytes[75], 0x02), 1)
		keyP["humidity_sensor_lock"] = bit.rshift(bit.band(messageBytes[75], 0x04), 2)
		keyP["drain_valve_leakage"] = bit.rshift(bit.band(messageBytes[75], 0x08), 3)
		keyP["hydrate_valve_leakage"] = bit.rshift(bit.band(messageBytes[75], 0x10), 4)
		keyP["humidity_sensor_fault"] = bit.rshift(bit.band(messageBytes[75], 0x20), 5)
		keyP["humidifier_communicate_fault"] = bit.rshift(bit.band(messageBytes[75], 0x40), 6)
		keyP["humidifier_water_sensor_fault"] = bit.rshift(bit.band(messageBytes[75], 0x80), 7)
		keyP["linking_humidifier_address"] = messageBytes[76]
		keyP["humidifier_temp_low"] = messageBytes[77]
		keyP["humidifier_temp_high"] = messageBytes[78]
		keyP["pm_sensor_chosen"] = bit.band(messageBytes[79], 0x01)
		keyP["co2_sensor_chosen"] = bit.rshift(bit.band(messageBytes[79], 0x02), 1)
		keyP["tvoc_sensor_chosen"] = bit.rshift(bit.band(messageBytes[79], 0x04), 2)
		keyP["pyroelectricity_sensor_chosen"] = bit.rshift(bit.band(messageBytes[79], 0x08), 3)
		keyP["thermopile_sensor_chosen"] = bit.rshift(bit.band(messageBytes[79], 0x10), 4)
		keyP["colmo_in_machine"] = bit.rshift(bit.band(messageBytes[79], 0x40), 6)
		keyP["temperatureLevel"] = bit.band(messageBytes[86], 0x03)
		keyP["humidityLevel"] = bit.rshift(bit.band(messageBytes[86], 0x0C), 2)
		keyP["purifierLevel"] = bit.rshift(bit.band(messageBytes[86], 0x30), 4)
		keyP["freshLevel"] = bit.rshift(bit.band(messageBytes[86], 0xC0), 6)
		keyP["tvocLevel"] = bit.band(messageBytes[87], 0x03)
		keyP["totalAirLevel"] = bit.rshift(bit.band(messageBytes[87], 0x0C), 2)
		keyP["has_inner_cycle"] = bit.rshift(bit.band(messageBytes[87], 0x10), 4)
		keyP["has_remove_odor"] = bit.rshift(bit.band(messageBytes[87], 0x20), 5)
		keyP["anion_status"] = bit.rshift(bit.band(messageBytes[87], 0x40), 6)
		keyP["auto_inner_cycle"] = bit.rshift(bit.band(messageBytes[87], 0x80), 7)
		keyP["total_elec"] = messageBytes[46]
			+ bit.lshift(messageBytes[47], 8)
			+ bit.lshift(messageBytes[48], 16)
			+ bit.lshift(messageBytes[49], 24)
		keyP["inner_machine_type"] = messageBytes[45]
		if #binData > 57 then
			keyP["new_wind_machine_operating_mode"] = bit.band(messageBytes[58], 0x0F)
			keyP["special_machine_type"] = bit.rshift(bit.band(messageBytes[58], 0x7F), 4)
		end
		if #binData > 89 then
			keyP["has_remove_arofene"] = bit.band(messageBytes[90], 0x01)
			keyP["has_eco"] = bit.rshift(bit.band(messageBytes[90], 0x02), 1)
			keyP["has_prevent_super_cool"] = bit.rshift(bit.band(messageBytes[90], 0x04), 2)
			keyP["has_voice_control"] = bit.rshift(bit.band(messageBytes[90], 0x08), 3)
			keyP["has_fresh_air_link"] = bit.rshift(bit.band(messageBytes[90], 0x10), 4)
			keyP["has_common_remove_odor"] = bit.rshift(bit.band(messageBytes[90], 0x20), 5)
			keyP["has_ptc"] = bit.rshift(bit.band(messageBytes[90], 0x40), 6)
		end
		if #binData > 90 then
			keyP["has_personality_dry"] = bit.band(messageBytes[91], 0x01)
			keyP["has_weekly_timer"] = bit.rshift(bit.band(messageBytes[91], 0x02), 1)
			keyP["has_new_home_remove_arofene"] = bit.rshift(bit.band(messageBytes[91], 0x04), 2)
			keyP["has_smart_humi_control"] = bit.rshift(bit.band(messageBytes[91], 0x08), 3)
			keyP["has_comfort_dry"] = bit.rshift(bit.band(messageBytes[91], 0x10), 4)
			keyP["has_new_wind_purifier"] = bit.rshift(bit.band(messageBytes[91], 0x20), 5)
			keyP["has_exhaust_wind"] = bit.rshift(bit.band(messageBytes[91], 0x40), 6)
			keyP["has_tube_protect"] = bit.rshift(bit.band(messageBytes[91], 0x80), 7)
		end
		if #binData > 92 then
			keyP["remove_odor_run_time"] = (messageBytes[92] + messageBytes[93] * 256)
		end
		if #binData > 93 then
			keyP["new_wind_model_wind_machine_fault"] = bit.band(messageBytes[94], 0x01)
			keyP["new_wind_model_anti_condensation_protect"] = bit.rshift(bit.band(messageBytes[94], 0x02), 1)
			keyP["new_wind_model_temp_low_protect"] = bit.rshift(bit.band(messageBytes[94], 0x04), 2)
			keyP["new_wind_model_temp_high_protect"] = bit.rshift(bit.band(messageBytes[94], 0x08), 3)
			keyP["new_wind_model_hum_sensor"] = bit.rshift(bit.band(messageBytes[94], 0x10), 4)
			keyP["new_wind_model_temp_sensor"] = bit.rshift(bit.band(messageBytes[94], 0x20), 5)
			keyP["new_wind_model_e_fault"] = bit.rshift(bit.band(messageBytes[94], 0x40), 6)
			keyP["new_wind_model_param_fault"] = bit.rshift(bit.band(messageBytes[94], 0x80), 7)
		end
		if #binData > 94 then
			keyP["new_wind_model_fresh_filter"] = messageBytes[95]
		end
		if #binData > 95 then
			keyP["has_fg_timer"] = bit.band(messageBytes[96], 0x01)
			keyP["radar_install_status"] = bit.rshift(bit.band(messageBytes[96], 0x02), 1)
			keyP["radar_monitor_people_status_report"] = bit.rshift(bit.band(messageBytes[96], 0x04), 2)
			keyP["nobody_off_status"] = bit.rshift(bit.band(messageBytes[96], 0x08), 3)
			keyP["huanqi_fault"] = bit.rshift(bit.band(messageBytes[96], 0x10), 4)
			keyP["double_engine_heat_status"] = bit.rshift(bit.band(messageBytes[96], 0x20), 5)
			keyP["smart_hybird_status"] = bit.rshift(bit.band(messageBytes[96], 0x40), 6)
			keyP["humidity_switch_fault"] = bit.rshift(bit.band(messageBytes[96], 0x80), 7)
		end
		if #binData > 106 then
			keyP["target_machine_info"] = messageBytes[106]
			keyP["machine_level"] = messageBytes[107]
			if keyP["target_machine_info"] == 0x01 then
				if #binData > 107 then
					keyP["has_female_care"] = bit.band(messageBytes[108], 0x01)
					keyP["has_fengguan_mini_new_wind"] = bit.rshift(bit.band(messageBytes[108], 0x02), 1)
				end
				if #binData > 110 then
					keyP["purifier_odor_filter_time"] = messageBytes[111]
				end
			end
			if keyP["target_machine_info"] == 0x02 then
				keyP["defrosting_display"] = bit.rshift(bit.band(messageBytes[108], 0x04), 2)
				keyP["has_mini_new_wind"] = bit.band(messageBytes[108], 0x01)
			end
		end
		if messageBytes[80] == 0x31 then
			keyP["sn8_string"] = "00000001"
		else
			keyP["sn8_string"] = "00000000"
		end
		keyP["machine_type"] = messageBytes[80]
		if bit.band(messageBytes[62], 0x80) == 0x80 then
			keyP["new_wind_outdoor_temperature"] = (
				0 - bit.band(bit.bnot(messageBytes[62] * 256 + messageBytes[61]) + 1, 0xffff)
			) / 100
		else
			keyP["new_wind_outdoor_temperature"] = (messageBytes[61] + messageBytes[62] * 256) / 100
		end
		keyP["new_wind_humidity"] = messageBytes[23]
		keyP["wire_controller_indoor_transport_ten"] = bit.band(messageBytes[15], 0x01)
		keyP["indoor_return_panel_transport"] = bit.rshift(bit.band(messageBytes[15], 0x02), 1)
		keyP["indoor_outlet_panel_transport"] = bit.rshift(bit.band(messageBytes[15], 0x04), 2)
		keyP["indoor_pyroelectric_sensor"] = bit.rshift(bit.band(messageBytes[15], 0x40), 6)
		keyP["tvoc_sensor"] = bit.band(messageBytes[16], 0x01)
		keyP["sensor_t1"] = bit.rshift(bit.band(messageBytes[16], 0x02), 1)
		keyP["sensor_t2"] = bit.rshift(bit.band(messageBytes[16], 0x04), 2)
		keyP["sensor_t2b_indoor"] = bit.rshift(bit.band(messageBytes[16], 0x08), 3)
		keyP["indoor_fan_lose_speed"] = bit.rshift(bit.band(messageBytes[16], 0x10), 4)
		keyP["indoor_hum_sensor"] = bit.rshift(bit.band(messageBytes[16], 0x20), 5)
		keyP["indoor_e"] = bit.rshift(bit.band(messageBytes[16], 0x40), 6)
		keyP["indoor_e_parameter"] = bit.rshift(bit.band(messageBytes[16], 0x80), 7)
		keyP["ammeter"] = bit.band(messageBytes[17], 0x01)
		keyP["co2_sensor"] = bit.rshift(bit.band(messageBytes[17], 0x02), 1)
		keyP["mode_conflict"] = bit.rshift(bit.band(messageBytes[17], 0x04), 2)
		keyP["prevent_cold_wind_protect"] = bit.rshift(bit.band(messageBytes[17], 0x10), 4)
		keyP["sensor_t2c_indoor"] = bit.rshift(bit.band(messageBytes[17], 0x20), 5)
		keyP["sensor_t2d_indoor"] = bit.rshift(bit.band(messageBytes[17], 0x40), 6)
		keyP["sensor_t2a_indoor"] = bit.rshift(bit.band(messageBytes[17], 0x80), 7)
		keyP["evaporator_temp_high_protect"] = bit.rshift(bit.band(messageBytes[18], 0x04), 2)
		keyP["evaporator_temp_fre_limit"] = bit.rshift(bit.band(messageBytes[18], 0x08), 3)
		keyP["new_wind_anti_condensation_protect"] = bit.rshift(bit.band(messageBytes[18], 0x10), 4)
		keyP["new_wind_out_temp_low_protect"] = bit.rshift(bit.band(messageBytes[18], 0x20), 5)
		keyP["new_wind_out_temp_high_protect"] = bit.rshift(bit.band(messageBytes[18], 0x40), 6)
		keyP["new_wind_pm_high_protect"] = bit.rshift(bit.band(messageBytes[18], 0x80), 7)
		keyP["new_wind_out_low_temp"] = bit.band(messageBytes[21], 0x01)
		keyP["new_wind_low_anti_condensation_protect"] = bit.rshift(bit.band(messageBytes[21], 0x02), 1)
		keyP["new_wind_pm_high"] = bit.rshift(bit.band(messageBytes[21], 0x04), 2)
		keyP["indoor_smart_eye"] = bit.rshift(bit.band(messageBytes[21], 0x08), 3)
		keyP["new_wind_temp_sensor"] = bit.rshift(bit.band(messageBytes[21], 0x10), 4)
		keyP["new_wind_hum_sensor"] = bit.rshift(bit.band(messageBytes[21], 0x20), 5)
		keyP["new_wind_pm2_5_sensor"] = bit.rshift(bit.band(messageBytes[21], 0x40), 6)
		keyP["indoor_new_wind_device"] = bit.band(messageBytes[22], 0x01)
		keyP["outdoor_new_wind_device"] = bit.rshift(bit.band(messageBytes[22], 0x02), 1)
		keyP["water_full_protect"] = bit.rshift(bit.band(messageBytes[22], 0x40), 6)
	end
	if dataType == 0x12 then
		if #binData < 15 then
			return nil
		end
		keyP["water_model_mode_clash"] = bit.rshift(bit.band(messageBytes[4], 0x02), 1)
		keyP["water_model_clean_time"] = messageBytes[30]
		keyP["tr_out_fault"] = bit.rshift(bit.band(messageBytes[1], 0x02), 1)
		keyP["tr_in_fault"] = bit.rshift(bit.band(messageBytes[1], 0x04), 2)
		keyP["standby_anti_freezing_fault"] = bit.rshift(bit.band(messageBytes[1], 0x10), 4)
		keyP["dc_pump_stall_protection"] = bit.band(messageBytes[2], 0x01)
		keyP["water_switch_fault"] = bit.rshift(bit.band(messageBytes[2], 0x06), 1)
		keyP["tw_in_fault"] = bit.rshift(bit.band(messageBytes[2], 0x08), 3)
		keyP["tw_out_fault"] = bit.rshift(bit.band(messageBytes[2], 0x10), 4)
		keyP["tw1_fault"] = bit.rshift(bit.band(messageBytes[2], 0x20), 5)
		keyP["indoor_e_water_heat"] = bit.rshift(bit.band(messageBytes[2], 0x40), 6)
		keyP["indoor_e_parameter_water_heat"] = bit.rshift(bit.band(messageBytes[2], 0x80), 7)
		keyP["tw1b_fault"] = bit.band(messageBytes[3], 0x01)
		keyP["temp_sensor_drop_fault"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5)
		keyP["water_templow_protection"] = bit.rshift(bit.band(messageBytes[3], 0x40), 6)
		keyP["wire_controller_indoor_transport"] = bit.band(messageBytes[1], 0x01)
		keyP["in_outdoor_fault"] = bit.rshift(bit.band(messageBytes[1], 0x08), 3)
		keyP["t2w_fault"] = bit.rshift(bit.band(messageBytes[1], 0x80), 7)
		keyP["standby_anti_freezing_protection"] = bit.rshift(bit.band(messageBytes[3], 0x80), 7)
		if bit.band(messageBytes[7], 0x80) == 0x80 then
			keyP["tw1_in_water_temp"] = (0 - bit.band(bit.bnot(messageBytes[7] * 256 + messageBytes[6]) + 1, 0xffff))
				/ 100
		else
			keyP["tw1_in_water_temp"] = (messageBytes[6] + messageBytes[7] * 256) / 100
		end
		if bit.band(messageBytes[9], 0x80) == 0x80 then
			keyP["tw1_out_water_temp"] = (0 - bit.band(bit.bnot(messageBytes[9] * 256 + messageBytes[8]) + 1, 0xffff))
				/ 100
		else
			keyP["tw1_out_water_temp"] = (messageBytes[8] + messageBytes[9] * 256) / 100
		end
		if bit.band(messageBytes[19], 0x80) == 0x80 then
			keyP["tw_out_water_temp"] = (0 - bit.band(bit.bnot(messageBytes[19] * 256 + messageBytes[18]) + 1, 0xffff))
				/ 100
		else
			keyP["tw_out_water_temp"] = (messageBytes[18] + messageBytes[19] * 256) / 100
		end
		if #binData > 25 then
			keyP["water_model_temperature_set_12"] = messageBytes[26]
		end
		if #binData > 35 then
			keyP["has_voice_control"] = bit.band(messageBytes[35], 0x01)
		end
		if #binData > 52 then
			keyP["water_model_machine_level"] = messageBytes[53]
		end
		if #binData > 75 then
			keyP["has_water_model_timer"] = bit.band(messageBytes[75], 0x01)
			keyP["has_weekly_timer_water"] = bit.rshift(bit.band(messageBytes[75], 0x02), 1)
			keyP["has_new_home_remove_arofene_water"] = bit.rshift(bit.band(messageBytes[75], 0x04), 2)
			keyP["has_smart_humi_control"] = bit.rshift(bit.band(messageBytes[75], 0x08), 3)
			keyP["remove_odor_run_time"] = (messageBytes[76] + messageBytes[77] * 256)
		end
	end
	if dataType == 0x30 then
		if #binData < 15 then
			return nil
		end
		if bit.band(messageBytes[6], 0x80) == 0x80 then
			keyP["outdoorTemperature"] = (0 - bit.band(bit.bnot(messageBytes[6] * 256 + messageBytes[5]) + 1, 0xffff))
				/ 100
		else
			keyP["outdoorTemperature"] = (messageBytes[5] + messageBytes[6] * 256) / 100
		end
		keyP["freshAirMachineNumber"] = messageBytes[73]
		keyP["humidityMachineNumber"] = messageBytes[74]
		keyP["out_mode"] = messageBytes[16]
		keyP["outdoor_e"] = bit.band(messageBytes[19], 0x01)
		keyP["sensor_t3"] = bit.rshift(bit.band(messageBytes[19], 0x02), 1)
		keyP["sensor_t4"] = bit.rshift(bit.band(messageBytes[19], 0x04), 2)
		keyP["sensor_tp"] = bit.rshift(bit.band(messageBytes[19], 0x08), 3)
		keyP["sensor_refrigerant_pipe_temp"] = bit.rshift(bit.band(messageBytes[19], 0x10), 4)
		keyP["out_voltage_project"] = bit.rshift(bit.band(messageBytes[19], 0x20), 5)
		keyP["outdoor_fan_lose_speed"] = bit.rshift(bit.band(messageBytes[19], 0x40), 6)
		keyP["compressor_temp_protect"] = bit.rshift(bit.band(messageBytes[19], 0x80), 7)
		keyP["out_main_drive_transport"] = bit.band(messageBytes[20], 0x01)
		keyP["compressor_current_circuit"] = bit.rshift(bit.band(messageBytes[20], 0x02), 1)
		keyP["compressor_start"] = bit.rshift(bit.band(messageBytes[20], 0x04), 2)
		keyP["phase_lost_protect"] = bit.rshift(bit.band(messageBytes[20], 0x08), 3)
		keyP["compressor_zero_protect"] = bit.rshift(bit.band(messageBytes[20], 0x10), 4)
		keyP["out_341_sync"] = bit.rshift(bit.band(messageBytes[20], 0x20), 5)
		keyP["compressor_lose_speed_protect"] = bit.rshift(bit.band(messageBytes[20], 0x40), 6)
		keyP["compressor_position_protect"] = bit.rshift(bit.band(messageBytes[20], 0x80), 7)
		keyP["compressor_over_current"] = bit.rshift(bit.band(messageBytes[21], 0x02), 1)
		keyP["outdoor_ipm"] = bit.rshift(bit.band(messageBytes[21], 0x04), 2)
		keyP["out_current_protect"] = bit.rshift(bit.band(messageBytes[21], 0x40), 6)
		keyP["refrigerant_tube_condensation"] = bit.rshift(bit.band(messageBytes[21], 0x80), 7)
		keyP["exhaust_high_temp_fre_limit"] = bit.band(messageBytes[22], 0x01)
		keyP["compressor_high_temp_protect"] = bit.rshift(bit.band(messageBytes[22], 0x02), 1)
		keyP["condenser_high_temp_fre_limit"] = bit.rshift(bit.band(messageBytes[22], 0x04), 2)
		keyP["grid_protect"] = bit.rshift(bit.band(messageBytes[22], 0x08), 3)
		keyP["system_pressure_high_fre_limit"] = bit.rshift(bit.band(messageBytes[22], 0x10), 4)
		keyP["system_pressure_high_protect"] = bit.rshift(bit.band(messageBytes[22], 0x20), 5)
		keyP["system_pressure_low_fre_limit"] = bit.rshift(bit.band(messageBytes[22], 0x40), 6)
		keyP["system_pressure_low_protect"] = bit.rshift(bit.band(messageBytes[22], 0x80), 7)
		keyP["voltage_fre_limit"] = bit.band(messageBytes[23], 0x01)
		keyP["current_fre_limit"] = bit.rshift(bit.band(messageBytes[23], 0x02), 1)
		keyP["pfc_switch_stop"] = bit.rshift(bit.band(messageBytes[23], 0x04), 2)
		keyP["pfc_fre_limit"] = bit.rshift(bit.band(messageBytes[23], 0x08), 3)
		keyP["in_out_ability_mismatch"] = bit.rshift(bit.band(messageBytes[23], 0x20), 5)
		keyP["sensor_high_pressure"] = bit.rshift(bit.band(messageBytes[25], 0x02), 1)
		keyP["sensor_low_pressure"] = bit.rshift(bit.band(messageBytes[25], 0x04), 2)
		keyP["sensor_inhale_temp"] = bit.rshift(bit.band(messageBytes[25], 0x08), 3)
		keyP["sensor_cold_temp"] = bit.rshift(bit.band(messageBytes[25], 0x10), 4)
		keyP["sensor_refrigerant_pipe_temp"] = bit.rshift(bit.band(messageBytes[25], 0x20), 5)
		keyP["indoor_communication_lost"] = bit.rshift(bit.band(messageBytes[25], 0x40), 6)
		keyP["new_wind_transport"] = bit.rshift(bit.band(messageBytes[25], 0x80), 7)
		keyP["four_way_valve_crossing_protect"] = bit.band(messageBytes[26], 0x01)
		keyP["four_way_valve_crossing"] = bit.rshift(bit.band(messageBytes[26], 0x02), 1)
		keyP["system_pressure_protect"] = bit.rshift(bit.band(messageBytes[26], 0x10), 4)
		keyP["sensor_spray_enthalpy_enter_temp"] = bit.rshift(bit.band(messageBytes[26], 0x20), 5)
		keyP["sensor_spray_enthalpy_out_temp"] = bit.rshift(bit.band(messageBytes[26], 0x40), 6)
		keyP["water_model_prevent_cold_protect"] = bit.rshift(bit.band(messageBytes[26], 0x80), 7)
		keyP["cold_fault"] = bit.rshift(bit.band(messageBytes[24], 0x08), 3)
	end
	if dataType == 0x31 then
		keyP["care_mode_switch"] = bit.band(messageBytes[0], 0x01)
		keyP["child_old_care_mode_switch"] = bit.rshift(bit.band(messageBytes[0], 0x06), 1)
		keyP["has_child_care_mode_temp"] = bit.band(messageBytes[1], 0x01)
		keyP["has_child_care_mode_gentle_wind"] = bit.rshift(bit.band(messageBytes[1], 0x02), 1)
		keyP["has_child_care_mode_prevent_straight_wind"] = bit.rshift(bit.band(messageBytes[1], 0x04), 2)
		keyP["has_child_care_mode_no_wind_sense"] = bit.rshift(bit.band(messageBytes[1], 0x08), 3)
		keyP["has_child_care_mode_limit"] = bit.rshift(bit.band(messageBytes[1], 0x10), 4)
		keyP["child_care_mode_ban_mode_select"] = bit.rshift(bit.band(messageBytes[1], 0x20), 5)
		keyP["child_care_mode_temp_min"] = (messageBytes[2] - 30) / 2
		keyP["child_care_mode_temp_max"] = (messageBytes[3] - 30) / 2
		keyP["child_care_mode_gentle_wind_min"] = messageBytes[4]
		keyP["child_care_mode_gentle_wind_max"] = messageBytes[5]
		keyP["has_old_care_mode_temp"] = bit.band(messageBytes[6], 0x01)
		keyP["has_old_care_mode_gentle_wind"] = bit.rshift(bit.band(messageBytes[6], 0x02), 1)
		keyP["has_old_care_mode_prevent_straight_wind"] = bit.rshift(bit.band(messageBytes[6], 0x04), 2)
		keyP["has_old_care_mode_no_wind_sense"] = bit.rshift(bit.band(messageBytes[6], 0x08), 3)
		keyP["has_old_care_mode_limit"] = bit.rshift(bit.band(messageBytes[6], 0x10), 4)
		keyP["old_care_mode_ban_mode_select"] = bit.rshift(bit.band(messageBytes[6], 0x20), 5)
		keyP["old_care_mode_temp_min"] = (messageBytes[7] - 30) / 2
		keyP["old_care_mode_temp_max"] = (messageBytes[8] - 30) / 2
		keyP["old_care_mode_gentle_wind_min"] = messageBytes[9]
		keyP["old_care_mode_gentle_wind_max"] = messageBytes[10]
	end
	if dataType == 0xC0 then
		keyP["c0_control_result"] = messageBytes[4]
		if messageBytes[3] == 0x02 then
			local cursor = 5
			keyP["has_power"] = bit.band(messageBytes[cursor + 1], 0x01)
			keyP["powerValue"] = bit.band(messageBytes[cursor + 2], 0x01)
			keyP["has_strong_wind"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x02), 1)
			keyP["strongWindValue"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x02), 1)
			keyP["no_wind_sense"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x04), 2)
			keyP["dryValue"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x08), 3)
			keyP["follow_body_sense"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x10), 4)
			keyP["cool_hot_sense"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x20), 5)
			keyP["swingLeftUDValue"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x40), 6)
			keyP["has_wind_swing_ud"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x40), 6)
			keyP["swingUpLRValue"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x80), 7)
			keyP["has_wind_swing_lr"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x80), 7)
			keyP["has_ptc"] = bit.band(messageBytes[cursor + 3], 0x01)
			keyP["PTCValue"] = bit.band(messageBytes[cursor + 4], 0x01)
			keyP["PTCDependT4Value"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x02), 1)
			keyP["wind_straight"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x04), 2)
			keyP["wind_avoid"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x08), 3)
			keyP["fengguan_remove_odor"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x10), 4)
			keyP["has_common_remove_odor"] = bit.rshift(bit.band(messageBytes[cursor + 3], 0x10), 4)
			keyP["self_clean"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x20), 5)
			keyP["energySaveValue"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x40), 6)
			keyP["nobody_energy_save"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x80), 7)
			keyP["manuPurify"] = bit.band(messageBytes[cursor + 6], 0x01)
			keyP["has_manu_purify"] = bit.band(messageBytes[cursor + 5], 0x01)
			keyP["autoPurify"] = bit.rshift(bit.band(messageBytes[cursor + 6], 0x02), 1)
			keyP["has_auto_purify"] = bit.rshift(bit.band(messageBytes[cursor + 5], 0x02), 1)
			keyP["autoHumi"] = bit.rshift(bit.band(messageBytes[cursor + 6], 0x04), 2)
			keyP["has_auto_humi"] = bit.rshift(bit.band(messageBytes[cursor + 5], 0x04), 2)
			keyP["manuHumi"] = bit.rshift(bit.band(messageBytes[cursor + 6], 0x08), 3)
			keyP["has_manu_humi"] = bit.rshift(bit.band(messageBytes[cursor + 5], 0x04), 2)
			keyP["new_wind_machine"] = bit.rshift(bit.band(messageBytes[cursor + 6], 0x10), 4)
			keyP["new_wind_machine_link"] = bit.rshift(bit.band(messageBytes[cursor + 6], 0x20), 5)
			keyP["stop_warm"] = bit.rshift(bit.band(messageBytes[cursor + 6], 0x80), 7)
			keyP["eco"] = bit.band(messageBytes[cursor + 8], 0x01)
			keyP["has_eco"] = bit.band(messageBytes[cursor + 7], 0x01)
			keyP["prevent_super_cool"] = bit.rshift(bit.band(messageBytes[cursor + 8], 0x02), 1)
			keyP["has_prevent_super_cool"] = bit.rshift(bit.band(messageBytes[cursor + 7], 0x02), 1)
			keyP["new_wind_model_intake_switch"] = bit.rshift(bit.band(messageBytes[cursor + 8], 0x04), 2)
			keyP["new_wind_model_exhaust_switch"] = bit.rshift(bit.band(messageBytes[cursor + 8], 0x08), 3)
			keyP["new_wind_model_mute"] = bit.rshift(bit.band(messageBytes[cursor + 8], 0x10), 4)
			keyP["tube_protect"] = bit.rshift(bit.band(messageBytes[cursor + 8], 0x20), 5)
			keyP["prepare_food"] = bit.rshift(bit.band(messageBytes[cursor + 8], 0x40), 6)
			keyP["has_prepare_food"] = bit.rshift(bit.band(messageBytes[cursor + 7], 0x40), 6)
			keyP["quick_fry"] = bit.rshift(bit.band(messageBytes[cursor + 8], 0x80), 7)
			keyP["has_quick_fry"] = bit.rshift(bit.band(messageBytes[cursor + 7], 0x80), 7)
			keyP["power_on_timer"] = bit.band(messageBytes[cursor + 15], 0x01)
			keyP["has_power_on_timer"] = bit.band(messageBytes[cursor + 14], 0x01)
			keyP["power_off_timer"] = bit.rshift(bit.band(messageBytes[cursor + 15], 0x02), 1)
			keyP["has_power_off_timer"] = bit.rshift(bit.band(messageBytes[cursor + 14], 0x02), 1)
			keyP["new_wind_model_on_timer"] = bit.rshift(bit.band(messageBytes[cursor + 15], 0x04), 2)
			keyP["has_new_wind_model_on_timer"] = bit.rshift(bit.band(messageBytes[cursor + 14], 0x04), 2)
			keyP["new_wind_model_off_timer"] = bit.rshift(bit.band(messageBytes[cursor + 15], 0x08), 3)
			keyP["has_new_wind_model_off_timer"] = bit.rshift(bit.band(messageBytes[cursor + 14], 0x08), 3)
			keyP["comfortableSleepValue"] = bit.rshift(bit.band(messageBytes[cursor + 15], 0x10), 4)
			if keyP["comfortableSleepValue"] == 1 then
				keyP["comfortableSleepValue"] = 0x30
			end
			keyP["has_comfort_sleep"] = bit.rshift(bit.band(messageBytes[cursor + 14], 0x10), 4)
			keyP["buzzerValue"] = bit.rshift(bit.band(messageBytes[cursor + 15], 0x20), 5)
			keyP["fresh_air_remove_odor"] = bit.rshift(bit.band(messageBytes[cursor + 15], 0x40), 6)
			keyP["has_remove_odor"] = bit.rshift(bit.band(messageBytes[cursor + 14], 0x40), 6)
			keyP["voice_control"] = bit.rshift(bit.band(messageBytes[cursor + 15], 0x80), 7)
			keyP["water_model_power"] = bit.band(messageBytes[cursor + 29], 0x01)
			keyP["water_model_power_save"] = bit.rshift(bit.band(messageBytes[cursor + 29], 0x02), 1)
			keyP["water_model_clean"] = bit.rshift(bit.band(messageBytes[cursor + 29], 0x04), 2)
			keyP["water_model_temperature_auto"] = bit.rshift(bit.band(messageBytes[cursor + 29], 0x08), 3)
			keyP["water_model_ptc"] = bit.rshift(bit.band(messageBytes[cursor + 29], 0x10), 4)
			keyP["water_model_go_out"] = bit.rshift(bit.band(messageBytes[cursor + 29], 0x20), 5)
			keyP["has_water_model_temperature_set"] = bit.rshift(bit.band(messageBytes[cursor + 30], 0x40), 6)
			keyP["has_water_mode"] = bit.rshift(bit.band(messageBytes[cursor + 30], 0x80), 7)
			keyP["modeValue"] = bit.band(messageBytes[cursor + 9], 0x7F)
			local tempValue = bit.band(messageBytes[cursor + 10], 0x7F)
			keyP["temperature"], keyP["small_temperature"] = math.modf((tempValue - 30) / 2)
			keyP["fanspeedValue"] = bit.band(messageBytes[cursor + 11], 0x7F)
			keyP["deHumidityValue"] = bit.band(messageBytes[cursor + 12], 0x7F)
			keyP["humidityValue"] = bit.band(messageBytes[cursor + 13], 0x7F)
			keyP["power_on_time_value"] =
				bit.bor(bit.lshift(bit.band(messageBytes[cursor + 18], 0x0F), 8), messageBytes[cursor + 16])
			keyP["power_off_time_value"] =
				bit.bor(bit.lshift(bit.band(messageBytes[cursor + 18], 0xF0), 4), messageBytes[cursor + 17])
			keyP["new_wind_model_on_timer_value"] =
				bit.bor(bit.lshift(bit.band(messageBytes[cursor + 19], 0x0F), 8), messageBytes[cursor + 21])
			keyP["new_wind_model_off_timer_value"] =
				bit.bor(bit.lshift(bit.band(messageBytes[cursor + 20], 0xF0), 4), messageBytes[cursor + 21])
			keyP["water_mode"] = bit.band(messageBytes[cursor + 30], 0x3F)
			keyP["water_model_temperature_set"] = (messageBytes[cursor + 31] - 50) / 2
			keyP["up_down_wind_direction"] = bit.band(messageBytes[cursor + 32], 0x0F)
			keyP["left_right_wind_direction"] = bit.rshift(bit.band(messageBytes[cursor + 32], 0xF0), 4)
			keyP["fresh_air_mode"] = bit.band(messageBytes[cursor + 33], 0x1F)
			keyP["has_fresh_air_mode"] = bit.rshift(bit.band(messageBytes[cursor + 33], 0x80), 7)
			keyP["wind_strength"] = bit.rshift(bit.band(messageBytes[cursor + 33], 0x20), 5)
			keyP["exhaust_strength"] = bit.rshift(bit.band(messageBytes[cursor + 33], 0x40), 6)
			keyP["fresh_air_fan_speed"] = bit.band(messageBytes[cursor + 34], 0x7F)
			keyP["has_fresh_air_fan_speed"] = bit.rshift(bit.band(messageBytes[cursor + 34], 0x80), 7)
			keyP["quick_prepare_food_angle"] = bit.band(messageBytes[cursor + 35], 0x7F)
			keyP["has_quick_prepare_food_angle"] = bit.rshift(bit.band(messageBytes[cursor + 35], 0x80), 7)
			keyP["dry_type"] = bit.band(messageBytes[cursor + 36], 0x03)
			keyP["fengguan_type"] = messageBytes[cursor + 37]
			keyP["fresh_air_intake_wind"] = messageBytes[cursor + 44]
			keyP["fresh_air_exhaust_wind"] = messageBytes[cursor + 45]
			keyP["has_new_wind_machine_intake_switch"] = bit.band(messageBytes[cursor + 46], 0x01)
			keyP["new_wind_machine_intake_switch"] = bit.band(messageBytes[cursor + 47], 0x01)
			keyP["has_new_wind_machine_exhaust_switch"] = bit.rshift(bit.band(messageBytes[cursor + 46], 0x02), 1)
			keyP["new_wind_machine_exhaust_switch"] = bit.rshift(bit.band(messageBytes[cursor + 47], 0x02), 1)
			keyP["has_heater_heating_switch"] = bit.rshift(bit.band(messageBytes[cursor + 46], 0x80), 7)
			keyP["heater_heating_switch"] = bit.rshift(bit.band(messageBytes[cursor + 47], 0x80), 7)
			keyP["has_airoptimization_or_total_time"] = bit.rshift(bit.band(messageBytes[cursor + 46], 0x40), 6)
			keyP["airoptimization_or_total_time"] = bit.rshift(bit.band(messageBytes[cursor + 47], 0x40), 6)
			keyP["fresh_air_intake_fan_speed"] = bit.band(messageBytes[cursor + 48], 0x7F)
			keyP["has_fresh_air_intake_fan_speed"] = bit.rshift(bit.band(messageBytes[cursor + 48], 0x80), 7)
			keyP["fresh_air_exhaust_fan_speed"] = bit.band(messageBytes[cursor + 49], 0x7F)
			keyP["has_fresh_air_exhaust_fan_speed"] = bit.rshift(bit.band(messageBytes[cursor + 49], 0x80), 7)
			keyP["water_model_force_temp"] = messageBytes[cursor + 54]
			keyP["new_wind_model_intake_wind"] = bit.band(messageBytes[cursor + 55], 0x7F)
			if #binData > 55 then
				keyP["new_wind_model_exhaust_wind"] = bit.band(messageBytes[cursor + 56], 0x7F)
			end
		end
		if messageBytes[3] == 0x03 then
			local cursor = 5
			keyP["new_wind_machine_type"] = messageBytes[cursor + 1]
			keyP["has_new_wind_machine"] = bit.band(messageBytes[cursor + 3], 0x01)
			keyP["new_wind_machine"] = bit.band(messageBytes[cursor + 4], 0x01)
			keyP["has_fresh_air_remove_odor"] = bit.rshift(bit.band(messageBytes[cursor + 3], 0x02), 1)
			keyP["fresh_air_remove_odor"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x02), 1)
			keyP["has_new_wind_machine_intake_switch"] = bit.rshift(bit.band(messageBytes[cursor + 3], 0x04), 2)
			keyP["new_wind_machine_intake_switch"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x04), 2)
			keyP["has_new_wind_machine_exhaust_switch"] = bit.rshift(bit.band(messageBytes[cursor + 3], 0x08), 3)
			keyP["new_wind_machine_exhaust_switch"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x08), 3)
			keyP["power_on_timer"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x10), 4)
			keyP["power_off_timer"] = bit.rshift(bit.band(messageBytes[cursor + 4], 0x20), 5)
			keyP["fresh_air_mode"] = bit.band(messageBytes[cursor + 5], 0x1F)
			keyP["wind_strength"] = bit.rshift(bit.band(messageBytes[cursor + 5], 0x20), 5)
			keyP["exhaust_strength"] = bit.rshift(bit.band(messageBytes[cursor + 5], 0x40), 6)
			keyP["has_fresh_air_mode"] = bit.rshift(bit.band(messageBytes[cursor + 5], 0x80), 7)
			keyP["fresh_air_intake_fan_speed"] = bit.band(messageBytes[cursor + 6], 0x7F)
			keyP["has_fresh_air_intake_fan_speed"] = bit.rshift(bit.band(messageBytes[cursor + 6], 0x80), 7)
			keyP["fresh_air_exhaust_fan_speed"] = bit.band(messageBytes[cursor + 7], 0x7F)
			keyP["has_fresh_air_exhaust_fan_speed"] = bit.rshift(bit.band(messageBytes[cursor + 7], 0x80), 7)
			keyP["power_on_time_value"] =
				bit.bor(bit.lshift(bit.band(messageBytes[cursor + 10], 0x0F), 8), messageBytes[cursor + 8])
			keyP["power_off_time_value"] =
				bit.bor(bit.lshift(bit.band(messageBytes[cursor + 10], 0xF0), 4), messageBytes[cursor + 9])
		end
		if messageBytes[2] == 0x06 then
			local cursor = 4
			keyP["indoor_machine_one_speed"] = bit.band(messageBytes[cursor + 1], 0x01)
			keyP["indoor_machine_two_speed"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x02), 1)
			keyP["indoor_elec_expansion_valve_one"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x04), 2)
			keyP["indoor_elec_expansion_valve_two"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x08), 3)
			keyP["in_water_pump_force"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x10), 4)
			keyP["out_water_pump_force"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x20), 5)
			keyP["ptc_support_force"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x40), 6)
			keyP["energy_need_c0"] = bit.rshift(bit.band(messageBytes[cursor + 1], 0x80), 7)
			keyP["indoor_lr_wind_angle"] = bit.band(messageBytes[cursor + 2], 0x01)
			keyP["indoor_ud_wind_angle"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x02), 1)
			keyP["fengguan_one_speed_enable"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x04), 2)
			keyP["fengguan_two_speed_enable"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x08), 3)
			keyP["new_wind_two_speed_enable"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x10), 4)
			keyP["new_wind_one_speed_enable"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x20), 5)
			keyP["new_wind_model_gate"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x40), 6)
			keyP["remove_odor_c0"] = bit.rshift(bit.band(messageBytes[cursor + 2], 0x80), 7)
			keyP["force_wind_machine_one_speed"] = messageBytes[cursor + 5] * 256 + messageBytes[cursor + 4]
			keyP["force_wind_machine_two_speed"] = messageBytes[cursor + 7] * 256 + messageBytes[cursor + 6]
			keyP["force_expansion_valve_one_speed"] = messageBytes[cursor + 9] * 256 + messageBytes[cursor + 8]
			keyP["force_expansion_valve_two_speed"] = messageBytes[cursor + 11] * 256 + messageBytes[cursor + 10]
			keyP["in_water_pump"] = bit.band(messageBytes[cursor + 12], 0x01)
			keyP["out_water_pump"] = bit.rshift(bit.band(messageBytes[cursor + 12], 0x02), 1)
			keyP["ptc_support"] = bit.rshift(bit.band(messageBytes[cursor + 12], 0x04), 2)
			keyP["wind_swing_lr_c0"] = messageBytes[cursor + 13]
			keyP["wind_swing_ud_c0"] = messageBytes[cursor + 14]
			keyP["indoor_energy_need"] = messageBytes[cursor + 15]
			keyP["fengguan_indoor_one_speed_level"] = messageBytes[cursor + 16]
			keyP["fengguan_indoor_two_speed_level"] = messageBytes[cursor + 17]
		end
	end
	if dataType == 0x14 then
		keyP["fg_timer_number"] = messageBytes[0]
		keyP["fg_timer1_week0_effect"] = bit.band(messageBytes[1], 0x01)
		keyP["fg_timer1_week1_effect"] = bit.rshift(bit.band(messageBytes[1], 0x02), 1)
		keyP["fg_timer1_week2_effect"] = bit.rshift(bit.band(messageBytes[1], 0x04), 2)
		keyP["fg_timer1_week3_effect"] = bit.rshift(bit.band(messageBytes[1], 0x08), 3)
		keyP["fg_timer1_week4_effect"] = bit.rshift(bit.band(messageBytes[1], 0x10), 4)
		keyP["fg_timer1_week5_effect"] = bit.rshift(bit.band(messageBytes[1], 0x20), 5)
		keyP["fg_timer1_week6_effect"] = bit.rshift(bit.band(messageBytes[1], 0x40), 6)
		keyP["fg_timer1_select"] = bit.rshift(bit.band(messageBytes[1], 0x80), 7)
		keyP["fg_timer1_wind_speed"] = bit.band(messageBytes[2], 0x7F)
		keyP["fg_timer1_power"] = bit.rshift(bit.band(messageBytes[2], 0x80), 7)
		keyP["fg_timer1_mode"] = bit.band(messageBytes[3], 0x3F)
		keyP["fg_timer1_temperature"] = bit.band(messageBytes[4], 0x3F)
		keyP["fg_timer1_hour"] = bit.band(messageBytes[5], 0x1F)
		keyP["fg_timer1_min"] = bit.band(messageBytes[6], 0x3F)
		keyP["fg_timer2_week0_effect"] = bit.band(messageBytes[7], 0x01)
		keyP["fg_timer2_week1_effect"] = bit.rshift(bit.band(messageBytes[7], 0x02), 1)
		keyP["fg_timer2_week2_effect"] = bit.rshift(bit.band(messageBytes[7], 0x04), 2)
		keyP["fg_timer2_week3_effect"] = bit.rshift(bit.band(messageBytes[7], 0x08), 3)
		keyP["fg_timer2_week4_effect"] = bit.rshift(bit.band(messageBytes[7], 0x10), 4)
		keyP["fg_timer2_week5_effect"] = bit.rshift(bit.band(messageBytes[7], 0x20), 5)
		keyP["fg_timer2_week6_effect"] = bit.rshift(bit.band(messageBytes[7], 0x40), 6)
		keyP["fg_timer2_select"] = bit.rshift(bit.band(messageBytes[7], 0x80), 7)
		keyP["fg_timer2_wind_speed"] = bit.band(messageBytes[8], 0x7F)
		keyP["fg_timer2_power"] = bit.rshift(bit.band(messageBytes[8], 0x80), 7)
		keyP["fg_timer2_mode"] = bit.band(messageBytes[9], 0x3F)
		keyP["fg_timer2_temperature"] = bit.band(messageBytes[10], 0x3F)
		keyP["fg_timer2_hour"] = bit.band(messageBytes[11], 0x1F)
		keyP["fg_timer2_min"] = bit.band(messageBytes[12], 0x3F)
	end
	if dataType == 0x13 or dataType == 0x21 then
		if #binData < 15 then
			return nil
		end
		keyP["week0_duplicate_timer_on_1"] = bit.rshift(bit.band(messageBytes[0], 0x20), 5)
		keyP["week0_duplicate_timer_off_2"] = bit.rshift(bit.band(messageBytes[0], 0x40), 6)
		keyP["week1_duplicate_timer_on_1"] = bit.rshift(bit.band(messageBytes[1], 0x20), 5)
		keyP["week1_duplicate_timer_off_2"] = bit.rshift(bit.band(messageBytes[1], 0x40), 6)
		keyP["week2_duplicate_timer_on_1"] = bit.rshift(bit.band(messageBytes[2], 0x20), 5)
		keyP["week2_duplicate_timer_off_2"] = bit.rshift(bit.band(messageBytes[2], 0x40), 6)
		keyP["week3_duplicate_timer_on_1"] = bit.rshift(bit.band(messageBytes[3], 0x20), 5)
		keyP["week3_duplicate_timer_off_2"] = bit.rshift(bit.band(messageBytes[3], 0x40), 6)
		keyP["week4_duplicate_timer_on_1"] = bit.rshift(bit.band(messageBytes[4], 0x20), 5)
		keyP["week4_duplicate_timer_off_2"] = bit.rshift(bit.band(messageBytes[4], 0x40), 6)
		keyP["week5_duplicate_timer_on_1"] = bit.rshift(bit.band(messageBytes[5], 0x20), 5)
		keyP["week5_duplicate_timer_off_2"] = bit.rshift(bit.band(messageBytes[5], 0x40), 6)
		keyP["week6_duplicate_timer_on_1"] = bit.rshift(bit.band(messageBytes[6], 0x20), 5)
		keyP["week6_duplicate_timer_off_2"] = bit.rshift(bit.band(messageBytes[6], 0x40), 6)
		keyP["week0_timer1"] = bit.band(messageBytes[0], 0x01)
		keyP["week0_timer2"] = bit.rshift(bit.band(messageBytes[0], 0x02), 1)
		keyP["week0_timer3"] = bit.rshift(bit.band(messageBytes[0], 0x04), 2)
		keyP["week0_timer4"] = bit.rshift(bit.band(messageBytes[0], 0x08), 3)
		keyP["week0_timer5"] = bit.rshift(bit.band(messageBytes[0], 0x10), 4)
		keyP["week1_timer1"] = bit.band(messageBytes[1], 0x01)
		keyP["week1_timer2"] = bit.rshift(bit.band(messageBytes[1], 0x02), 1)
		keyP["week1_timer3"] = bit.rshift(bit.band(messageBytes[1], 0x04), 2)
		keyP["week1_timer4"] = bit.rshift(bit.band(messageBytes[1], 0x08), 3)
		keyP["week1_timer5"] = bit.rshift(bit.band(messageBytes[1], 0x10), 4)
		keyP["week2_timer1"] = bit.band(messageBytes[2], 0x01)
		keyP["week2_timer2"] = bit.rshift(bit.band(messageBytes[2], 0x02), 1)
		keyP["week2_timer3"] = bit.rshift(bit.band(messageBytes[2], 0x04), 2)
		keyP["week2_timer4"] = bit.rshift(bit.band(messageBytes[2], 0x08), 3)
		keyP["week2_timer5"] = bit.rshift(bit.band(messageBytes[2], 0x10), 4)
		keyP["week3_timer1"] = bit.band(messageBytes[3], 0x01)
		keyP["week3_timer2"] = bit.rshift(bit.band(messageBytes[3], 0x02), 1)
		keyP["week3_timer3"] = bit.rshift(bit.band(messageBytes[3], 0x04), 2)
		keyP["week3_timer4"] = bit.rshift(bit.band(messageBytes[3], 0x08), 3)
		keyP["week3_timer5"] = bit.rshift(bit.band(messageBytes[3], 0x10), 4)
		keyP["week4_timer1"] = bit.band(messageBytes[4], 0x01)
		keyP["week4_timer2"] = bit.rshift(bit.band(messageBytes[4], 0x02), 1)
		keyP["week4_timer3"] = bit.rshift(bit.band(messageBytes[4], 0x04), 2)
		keyP["week4_timer4"] = bit.rshift(bit.band(messageBytes[4], 0x08), 3)
		keyP["week4_timer5"] = bit.rshift(bit.band(messageBytes[4], 0x10), 4)
		keyP["week5_timer1"] = bit.band(messageBytes[5], 0x01)
		keyP["week5_timer2"] = bit.rshift(bit.band(messageBytes[5], 0x02), 1)
		keyP["week5_timer3"] = bit.rshift(bit.band(messageBytes[5], 0x04), 2)
		keyP["week5_timer4"] = bit.rshift(bit.band(messageBytes[5], 0x08), 3)
		keyP["week5_timer5"] = bit.rshift(bit.band(messageBytes[5], 0x10), 4)
		keyP["week6_timer1"] = bit.band(messageBytes[6], 0x01)
		keyP["week6_timer2"] = bit.rshift(bit.band(messageBytes[6], 0x02), 1)
		keyP["week6_timer3"] = bit.rshift(bit.band(messageBytes[6], 0x04), 2)
		keyP["week6_timer4"] = bit.rshift(bit.band(messageBytes[6], 0x08), 3)
		keyP["week6_timer5"] = bit.rshift(bit.band(messageBytes[6], 0x10), 4)
		keyP["week0_timer1_open_hour"] = messageBytes[7]
		keyP["week0_timer1_open_min"] = messageBytes[8]
		keyP["week0_timer1_close_hour"] = messageBytes[9]
		keyP["week0_timer1_close_min"] = messageBytes[10]
		keyP["week0_timer1_temperature"] = (messageBytes[11] - 50) / 2
		keyP["week0_timer2_open_hour"] = messageBytes[12]
		keyP["week0_timer2_open_min"] = messageBytes[13]
		keyP["week0_timer2_close_hour"] = messageBytes[14]
		keyP["week0_timer2_close_min"] = messageBytes[15]
		keyP["week0_timer2_temperature"] = (messageBytes[16] - 50) / 2
		keyP["week0_timer3_open_hour"] = messageBytes[17]
		keyP["week0_timer3_open_min"] = messageBytes[18]
		keyP["week0_timer3_close_hour"] = messageBytes[19]
		keyP["week0_timer3_close_min"] = messageBytes[20]
		keyP["week0_timer3_temperature"] = (messageBytes[21] - 50) / 2
		keyP["week0_timer4_open_hour"] = messageBytes[22]
		keyP["week0_timer4_open_min"] = messageBytes[23]
		keyP["week0_timer4_close_hour"] = messageBytes[24]
		keyP["week0_timer4_close_min"] = messageBytes[25]
		keyP["week0_timer4_temperature"] = (messageBytes[26] - 50) / 2
		keyP["week0_timer5_open_hour"] = messageBytes[27]
		keyP["week0_timer5_open_min"] = messageBytes[28]
		keyP["week0_timer5_close_hour"] = messageBytes[29]
		keyP["week0_timer5_close_min"] = messageBytes[30]
		keyP["week0_timer5_temperature"] = (messageBytes[31] - 50) / 2
		keyP["week1_timer1_open_hour"] = messageBytes[32]
		keyP["week1_timer1_open_min"] = messageBytes[33]
		keyP["week1_timer1_close_hour"] = messageBytes[34]
		keyP["week1_timer1_close_min"] = messageBytes[35]
		keyP["week1_timer1_temperature"] = (messageBytes[36] - 50) / 2
		keyP["week1_timer2_open_hour"] = messageBytes[37]
		keyP["week1_timer2_open_min"] = messageBytes[38]
		keyP["week1_timer2_close_hour"] = messageBytes[39]
		keyP["week1_timer2_close_min"] = messageBytes[40]
		keyP["week1_timer2_temperature"] = (messageBytes[41] - 50) / 2
		keyP["week1_timer3_open_hour"] = messageBytes[42]
		keyP["week1_timer3_open_min"] = messageBytes[43]
		keyP["week1_timer3_close_hour"] = messageBytes[44]
		keyP["week1_timer3_close_min"] = messageBytes[45]
		keyP["week1_timer3_temperature"] = (messageBytes[46] - 50) / 2
		keyP["week1_timer4_open_hour"] = messageBytes[47]
		keyP["week1_timer4_open_min"] = messageBytes[48]
		keyP["week1_timer4_close_hour"] = messageBytes[49]
		keyP["week1_timer4_close_min"] = messageBytes[50]
		keyP["week1_timer4_temperature"] = (messageBytes[51] - 50) / 2
		keyP["week1_timer5_open_hour"] = messageBytes[52]
		keyP["week1_timer5_open_min"] = messageBytes[53]
		keyP["week1_timer5_close_hour"] = messageBytes[54]
		keyP["week1_timer5_close_min"] = messageBytes[55]
		keyP["week1_timer5_temperature"] = (messageBytes[56] - 50) / 2
		keyP["week2_timer1_open_hour"] = messageBytes[57]
		keyP["week2_timer1_open_min"] = messageBytes[58]
		keyP["week2_timer1_close_hour"] = messageBytes[59]
		keyP["week2_timer1_close_min"] = messageBytes[60]
		keyP["week2_timer1_temperature"] = (messageBytes[61] - 50) / 2
		keyP["week2_timer2_open_hour"] = messageBytes[62]
		keyP["week2_timer2_open_min"] = messageBytes[63]
		keyP["week2_timer2_close_hour"] = messageBytes[64]
		keyP["week2_timer2_close_min"] = messageBytes[65]
		keyP["week2_timer2_temperature"] = (messageBytes[66] - 50) / 2
		keyP["week2_timer3_open_hour"] = messageBytes[67]
		keyP["week2_timer3_open_min"] = messageBytes[68]
		keyP["week2_timer3_close_hour"] = messageBytes[69]
		keyP["week2_timer3_close_min"] = messageBytes[70]
		keyP["week2_timer3_temperature"] = (messageBytes[71] - 50) / 2
		keyP["week2_timer4_open_hour"] = messageBytes[72]
		keyP["week2_timer4_open_min"] = messageBytes[73]
		keyP["week2_timer4_close_hour"] = messageBytes[74]
		keyP["week2_timer4_close_min"] = messageBytes[75]
		keyP["week2_timer4_temperature"] = (messageBytes[76] - 50) / 2
		keyP["week2_timer5_open_hour"] = messageBytes[77]
		keyP["week2_timer5_open_min"] = messageBytes[78]
		keyP["week2_timer5_close_hour"] = messageBytes[79]
		keyP["week2_timer5_close_min"] = messageBytes[80]
		keyP["week2_timer5_temperature"] = (messageBytes[81] - 50) / 2
		keyP["week3_timer1_open_hour"] = messageBytes[82]
		keyP["week3_timer1_open_min"] = messageBytes[83]
		keyP["week3_timer1_close_hour"] = messageBytes[84]
		keyP["week3_timer1_close_min"] = messageBytes[85]
		keyP["week3_timer1_temperature"] = (messageBytes[86] - 50) / 2
		keyP["week3_timer2_open_hour"] = messageBytes[87]
		keyP["week3_timer2_open_min"] = messageBytes[88]
		keyP["week3_timer2_close_hour"] = messageBytes[89]
		keyP["week3_timer2_close_min"] = messageBytes[90]
		keyP["week3_timer2_temperature"] = (messageBytes[91] - 50) / 2
		keyP["week3_timer3_open_hour"] = messageBytes[92]
		keyP["week3_timer3_open_min"] = messageBytes[93]
		keyP["week3_timer3_close_hour"] = messageBytes[94]
		keyP["week3_timer3_close_min"] = messageBytes[95]
		keyP["week3_timer3_temperature"] = (messageBytes[96] - 50) / 2
		keyP["week3_timer4_open_hour"] = messageBytes[97]
		keyP["week3_timer4_open_min"] = messageBytes[98]
		keyP["week3_timer4_close_hour"] = messageBytes[99]
		keyP["week3_timer4_close_min"] = messageBytes[100]
		keyP["week3_timer4_temperature"] = (messageBytes[101] - 50) / 2
		keyP["week3_timer5_open_hour"] = messageBytes[102]
		keyP["week3_timer5_open_min"] = messageBytes[103]
		keyP["week3_timer5_close_hour"] = messageBytes[104]
		keyP["week3_timer5_close_min"] = messageBytes[105]
		keyP["week3_timer5_temperature"] = (messageBytes[106] - 50) / 2
		keyP["week4_timer1_open_hour"] = messageBytes[107]
		keyP["week4_timer1_open_min"] = messageBytes[108]
		keyP["week4_timer1_close_hour"] = messageBytes[109]
		keyP["week4_timer1_close_min"] = messageBytes[110]
		keyP["week4_timer1_temperature"] = (messageBytes[111] - 50) / 2
		keyP["week4_timer2_open_hour"] = messageBytes[112]
		keyP["week4_timer2_open_min"] = messageBytes[113]
		keyP["week4_timer2_close_hour"] = messageBytes[114]
		keyP["week4_timer2_close_min"] = messageBytes[115]
		keyP["week4_timer2_temperature"] = (messageBytes[116] - 50) / 2
		keyP["week4_timer3_open_hour"] = messageBytes[117]
		keyP["week4_timer3_open_min"] = messageBytes[118]
		keyP["week4_timer3_close_hour"] = messageBytes[119]
		keyP["week4_timer3_close_min"] = messageBytes[120]
		keyP["week4_timer3_temperature"] = (messageBytes[121] - 50) / 2
		keyP["week4_timer4_open_hour"] = messageBytes[122]
		keyP["week4_timer4_open_min"] = messageBytes[123]
		keyP["week4_timer4_close_hour"] = messageBytes[124]
		keyP["week4_timer4_close_min"] = messageBytes[125]
		keyP["week4_timer4_temperature"] = (messageBytes[126] - 50) / 2
		keyP["week4_timer5_open_hour"] = messageBytes[127]
		keyP["week4_timer5_open_min"] = messageBytes[128]
		keyP["week4_timer5_close_hour"] = messageBytes[129]
		keyP["week4_timer5_close_min"] = messageBytes[130]
		keyP["week4_timer5_temperature"] = (messageBytes[131] - 50) / 2
		keyP["week5_timer1_open_hour"] = messageBytes[132]
		keyP["week5_timer1_open_min"] = messageBytes[133]
		keyP["week5_timer1_close_hour"] = messageBytes[134]
		keyP["week5_timer1_close_min"] = messageBytes[135]
		keyP["week5_timer1_temperature"] = (messageBytes[136] - 50) / 2
		keyP["week5_timer2_open_hour"] = messageBytes[137]
		keyP["week5_timer2_open_min"] = messageBytes[138]
		keyP["week5_timer2_close_hour"] = messageBytes[139]
		keyP["week5_timer2_close_min"] = messageBytes[140]
		keyP["week5_timer2_temperature"] = (messageBytes[141] - 50) / 2
		keyP["week5_timer3_open_hour"] = messageBytes[142]
		keyP["week5_timer3_open_min"] = messageBytes[143]
		keyP["week5_timer3_close_hour"] = messageBytes[144]
		keyP["week5_timer3_close_min"] = messageBytes[145]
		keyP["week5_timer3_temperature"] = (messageBytes[146] - 50) / 2
		keyP["week5_timer4_open_hour"] = messageBytes[147]
		keyP["week5_timer4_open_min"] = messageBytes[148]
		keyP["week5_timer4_close_hour"] = messageBytes[149]
		keyP["week5_timer4_close_min"] = messageBytes[150]
		keyP["week5_timer4_temperature"] = (messageBytes[151] - 50) / 2
		keyP["week5_timer5_open_hour"] = messageBytes[152]
		keyP["week5_timer5_open_min"] = messageBytes[153]
		keyP["week5_timer5_close_hour"] = messageBytes[154]
		keyP["week5_timer5_close_min"] = messageBytes[155]
		keyP["week5_timer5_temperature"] = (messageBytes[156] - 50) / 2
		keyP["week6_timer1_open_hour"] = messageBytes[157]
		keyP["week6_timer1_open_min"] = messageBytes[158]
		keyP["week6_timer1_close_hour"] = messageBytes[159]
		keyP["week6_timer1_close_min"] = messageBytes[160]
		keyP["week6_timer1_temperature"] = (messageBytes[161] - 50) / 2
		keyP["week6_timer2_open_hour"] = messageBytes[162]
		keyP["week6_timer2_open_min"] = messageBytes[163]
		keyP["week6_timer2_close_hour"] = messageBytes[164]
		keyP["week6_timer2_close_min"] = messageBytes[165]
		keyP["week6_timer2_temperature"] = (messageBytes[166] - 50) / 2
		keyP["week6_timer3_open_hour"] = messageBytes[167]
		keyP["week6_timer3_open_min"] = messageBytes[168]
		keyP["week6_timer3_close_hour"] = messageBytes[169]
		keyP["week6_timer3_close_min"] = messageBytes[170]
		keyP["week6_timer3_temperature"] = (messageBytes[171] - 50) / 2
		keyP["week6_timer4_open_hour"] = messageBytes[172]
		keyP["week6_timer4_open_min"] = messageBytes[173]
		keyP["week6_timer4_close_hour"] = messageBytes[174]
		keyP["week6_timer4_close_min"] = messageBytes[175]
		keyP["week6_timer4_temperature"] = (messageBytes[176] - 50) / 2
		keyP["week6_timer5_open_hour"] = messageBytes[177]
		keyP["week6_timer5_open_min"] = messageBytes[178]
		keyP["week6_timer5_close_hour"] = messageBytes[179]
		keyP["week6_timer5_close_min"] = messageBytes[180]
		keyP["week6_timer5_temperature"] = (messageBytes[181] - 50) / 2
	end
end
local function getAcMsg(bodyData, cType)
	local bodyLength = #bodyData
	local msgLength = bodyLength + 0x0A + 1
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = 0xAA
	msgBytes[1] = bodyLength + 0x0A + 1
	msgBytes[2] = 0xAC
	msgBytes[8] = 0x02
	if
		cType == keyB["BYTE_QUERYL_REQUEST"]
		or cType == keyB["BYTE_QUERY_RUN_REQUEST"]
		or cType == keyB["BYTE_QUERY_OUT_RUN_REQUEST"]
		or cType == keyB["BYTE_QUERY_WATER_RUN_REQUEST"]
		or cType == 0x13
		or cType == 0x14
		or cType == 0x15
		or cType == 0x4C
		or cType == 0x51
	then
		msgBytes[9] = 0x03
	else
		msgBytes[9] = 0x02
	end
	for i = 0, bodyLength do
		msgBytes[i + 0x0A] = bodyData[i]
	end
	msgBytes[msgLength] = makeSum(msgBytes, 1, msgLength - 1)
	local msgFinal = {}
	for i = 1, msgLength + 1 do
		msgFinal[i] = msgBytes[i - 1]
	end
	return msgFinal
end
local function getAcMsgQuery(bodyData, cType)
	local bodyLength = #bodyData
	local msgLength = bodyLength + 0x0A + 1
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = 0xAA
	msgBytes[1] = bodyLength + 0x0A + 1
	msgBytes[2] = 0xAC
	msgBytes[8] = 0x02
	msgBytes[9] = 0x03
	for i = 0, bodyLength do
		msgBytes[i + 0x0A] = bodyData[i]
	end
	msgBytes[msgLength] = makeSum(msgBytes, 1, msgLength - 1)
	local msgFinal = {}
	for i = 1, msgLength + 1 do
		msgFinal[i] = msgBytes[i - 1]
	end
	return msgFinal
end
local function getAcMsgNetwork(bodyData)
	local bodyLength = #bodyData
	local msgLength = bodyLength + 0x0A + 1
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = 0xAA
	msgBytes[1] = bodyLength + 0x0A + 1
	msgBytes[2] = 0xAC
	msgBytes[8] = 0x00
	msgBytes[9] = 0x25
	for i = 0, bodyLength do
		msgBytes[i + 0x0A] = bodyData[i]
	end
	msgBytes[msgLength] = makeSum(msgBytes, 1, msgLength - 1)
	local msgFinal = {}
	for i = 1, msgLength + 1 do
		msgFinal[i] = msgBytes[i - 1]
	end
	return msgFinal
end
local function get15Msg(bodyData, cType)
	local bodyLength = 0
	if bodyData ~= nil then
		bodyLength = #bodyData
	end
	local msgLength = bodyLength + keyB["BYTE_PROTOCOL_LENGTH"] + 2
	if bodyData == nil then
		msgLength = 8
	end
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = keyB["BYTE_PROTOCOL_HEAD"]
	msgBytes[1] = msgLength + 1
	msgBytes[2] = 0x00
	msgBytes[3] = 0xFF
	msgBytes[4] = 0xFF
	msgBytes[5] = cType
	if bodyData ~= nil then
		for i = 0, bodyLength do
			msgBytes[i + keyB["BYTE_PROTOCOL_LENGTH"]] = bodyData[i]
		end
	end
	msgBytes[6] = 2
	msgBytes[msgLength - 1] = crc8_854(msgBytes, 0, msgLength - 2)
	msgBytes[msgLength] = makeSum(msgBytes, 0, msgLength - 1)
	return getAcMsg(msgBytes, cType)
end
local function getTotalMsg(bodyData, cType)
	local bodyLength = 0
	if bodyData ~= nil then
		bodyLength = #bodyData
	end
	local msgLength = bodyLength + keyB["BYTE_PROTOCOL_LENGTH"] + 2
	if bodyData == nil then
		msgLength = 7
	end
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = keyB["BYTE_PROTOCOL_HEAD"]
	msgBytes[1] = msgLength + 1
	msgBytes[2] = 0x00
	msgBytes[3] = 0xFF
	msgBytes[4] = 0xFF
	msgBytes[5] = cType
	if bodyData ~= nil then
		for i = 0, bodyLength do
			msgBytes[i + keyB["BYTE_PROTOCOL_LENGTH"]] = bodyData[i]
		end
	end
	msgBytes[msgLength - 1] = crc8_854(msgBytes, 0, msgLength - 2)
	msgBytes[msgLength] = makeSum(msgBytes, 0, msgLength - 1)
	return getAcMsg(msgBytes, cType)
end
local function byte_to_key_one_bit(has_key, has_value, key, val)
	keyP[has_key] = nil
	keyP[key] = nil
	if has_value == 0x00 then
		keyP[has_key] = 0
	else
		keyP[has_key] = 1
		keyP[key] = val
	end
end
local function getTotalMsgC006(bodyData, cType)
	local bodyLength = 0
	if bodyData ~= nil then
		bodyLength = #bodyData
	end
	local msgLength = bodyLength + keyB["BYTE_PROTOCOL_LENGTH"] + 2
	if bodyData == nil then
		msgLength = 7
	end
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = keyB["BYTE_PROTOCOL_HEAD"]
	msgBytes[1] = msgLength + 1
	msgBytes[2] = 0x00
	msgBytes[3] = keyP["machine_address"]
	msgBytes[4] = 0xFF
	msgBytes[5] = cType
	if bodyData ~= nil then
		for i = 0, bodyLength do
			msgBytes[i + keyB["BYTE_PROTOCOL_LENGTH"]] = bodyData[i]
		end
	end
	msgBytes[msgLength - 1] = crc8_854(msgBytes, 0, msgLength - 2)
	msgBytes[msgLength] = makeSum(msgBytes, 0, msgLength - 1)
	return getAcMsg(msgBytes, cType)
end
local function getTotalMsgC002(bodyData, cType)
	local bodyLength = 0
	if bodyData ~= nil then
		bodyLength = #bodyData
	end
	local msgLength = bodyLength + keyB["BYTE_PROTOCOL_LENGTH"] + 2
	if bodyData == nil then
		msgLength = 7
	end
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = keyB["BYTE_PROTOCOL_HEAD"]
	msgBytes[1] = msgLength + 1
	msgBytes[2] = 0x00
	msgBytes[3] = keyP["machine_address"]
	msgBytes[4] = 0xFF
	msgBytes[5] = cType
	if bodyData ~= nil then
		for i = 0, bodyLength do
			msgBytes[i + keyB["BYTE_PROTOCOL_LENGTH"]] = bodyData[i]
		end
	end
	msgBytes[msgLength - 1] = crc8_854(msgBytes, 0, msgLength - 2)
	msgBytes[msgLength] = makeSum(msgBytes, 0, msgLength - 1)
	return getAcMsgQuery(msgBytes, cType)
end
local function getTotalMsgNew(bodyData, cType, pType)
	local bodyLength = 0
	if bodyData ~= nil then
		bodyLength = #bodyData
	end
	local msgLength = bodyLength + keyB["BYTE_PROTOCOL_LENGTH"] + 2
	if bodyData == nil then
		msgLength = 8
	end
	local msgBytes = {}
	for i = 0, msgLength do
		msgBytes[i] = 0
	end
	msgBytes[0] = keyB["BYTE_PROTOCOL_HEAD"]
	msgBytes[1] = msgLength + 1
	msgBytes[2] = 0x00
	msgBytes[3] = 0xFF
	msgBytes[4] = 0xFF
	msgBytes[5] = cType
	msgBytes[6] = pType
	if bodyData ~= nil then
		for i = 0, bodyLength do
			msgBytes[i + keyB["BYTE_PROTOCOL_LENGTH"]] = bodyData[i]
		end
	end
	msgBytes[msgLength - 1] = crc8_854(msgBytes, 0, msgLength - 2)
	msgBytes[msgLength] = makeSum(msgBytes, 0, msgLength - 1)
	return getAcMsg(msgBytes, cType)
end
local gC004OnOffConfig = {
	["has_child_care_mode_temp_enable"] = { 2, 0, 3, 0 },
	["has_child_care_mode_gentle_wind_enable"] = { 2, 1, 3, 1 },
	["has_child_care_mode_prevent_straight_wind_enable"] = { 2, 2, 3, 2 },
	["has_child_care_mode_no_wind_sense_enable"] = { 2, 3, 3, 3 },
	["has_child_care_mode_limit_enable"] = { 2, 4, 3, 4 },
	["child_care_mode_ban_mode_select_enable"] = { 2, 5, 3, 5 },
	["has_old_care_mode_temp_enable"] = { 8, 0, 9, 0 },
	["has_old_care_mode_gentle_wind_enable"] = { 8, 1, 9, 1 },
	["has_old_care_mode_prevent_straight_wind_enable"] = { 8, 2, 9, 2 },
	["has_old_care_mode_no_wind_sense_enable"] = { 8, 3, 9, 3 },
	["has_old_care_mode_limit_enable"] = { 8, 4, 9, 4 },
	["old_care_mode_ban_mode_select_enable"] = { 8, 5, 9, 5 },
}
local gC002OnOffConfigTemp = {
	["power_enable"] = { 0, 0, 1, 0 },
	["strong_wind_enable"] = { 0, 1, 1, 1 },
	["no_wind_sense_enable"] = { 0, 2, 1, 2 },
	["dry_enable"] = { 0, 3, 1, 3 },
	["follow_body_sense_enable"] = { 0, 4, 1, 4 },
	["cool_hot_sense_enable"] = { 0, 5, 1, 5 },
	["wind_swing_ud_enable"] = { 0, 6, 1, 6 },
	["wind_swing_lr_enable"] = { 0, 7, 1, 7 },
	["ptc_enable"] = { 2, 0, 3, 0 },
	["remove_arofene_enable"] = { 2, 1, 3, 1 },
	["wind_straight_enable"] = { 2, 2, 3, 2 },
	["wind_avoid_enable"] = { 2, 3, 3, 3 },
	["fengguan_remove_odor_enable"] = { 2, 4, 3, 4 },
	["self_clean_enable"] = { 2, 5, 3, 5 },
	["energy_save_enable"] = { 2, 6, 3, 6 },
	["nobody_energy_save_enable"] = { 2, 7, 3, 7 },
	["inner_purifier_enable"] = { 4, 1, 5, 1 },
	["manu_inner_purifier_enable"] = { 4, 0, 5, 0 },
	["auto_humi_enable"] = { 4, 2, 5, 2 },
	["manul_humi_enable"] = { 4, 3, 5, 3 },
	["new_wind_machine_enable"] = { 4, 4, 5, 4 },
	["new_wind_machine_link_enable"] = { 4, 5, 5, 5 },
	["ventilator_enable"] = { 4, 6, 5, 6 },
	["stop_warm_enable"] = { 4, 7, 5, 7 },
	["eco_enable"] = { 6, 0, 7, 0 },
	["prevent_super_cool_enable"] = { 6, 1, 7, 1 },
	["new_wind_model_intake_switch_enable"] = { 6, 2, 7, 2 },
	["new_wind_model_exhaust_switch_enable"] = { 6, 3, 7, 3 },
	["new_wind_model_mute_enable"] = { 6, 4, 7, 4 },
	["tube_protect_enable"] = { 6, 5, 7, 5 },
	["prepare_food_enable"] = { 6, 6, 7, 6 },
	["quick_fry_enable"] = { 6, 7, 7, 7 },
	["power_on_timer_enable"] = { 13, 0, 14, 0 },
	["power_off_timer_enable"] = { 13, 1, 14, 1 },
	["new_wind_model_on_timer_enable"] = { 13, 2, 14, 2 },
	["new_wind_model_off_timer_enable"] = { 13, 3, 14, 3 },
	["comfort_sleep_enable"] = { 13, 4, 14, 4 },
	["buzzer_enable"] = { 13, 5, 14, 5 },
	["fresh_air_remove_odor_enable"] = { 13, 6, 14, 6 },
	["voice_control_enable"] = { 13, 7, 14, 7 },
	["water_model_power_enable"] = { 27, 0, 28, 0 },
	["water_model_power_save_enable"] = { 27, 1, 28, 1 },
	["water_model_clean_enable"] = { 27, 2, 28, 2 },
	["water_model_temperature_auto_enable"] = { 27, 3, 28, 3 },
	["water_model_ptc_enable"] = { 27, 4, 28, 4 },
	["water_model_go_out_enable"] = { 27, 5, 28, 5 },
	["total_time_switch_enable"] = { 37, 4, 38, 4 },
	["female_care_enable"] = { 37, 5, 38, 5 },
	["energy_new_wind_enable"] = { 37, 6, 38, 6 },
	["smart_humi_control_algorithm_enable"] = { 37, 7, 38, 7 },
	["new_wind_machine_intake_switch_enable"] = { 45, 0, 46, 0 },
	["new_wind_machine_exhaust_switch_enable"] = { 45, 1, 46, 1 },
	["airoptimization_or_total_time_enable"] = { 45, 6, 46, 6 },
	["heater_heating_switch_enable"] = { 45, 7, 46, 7 },
	["water_temp_linkage_switch_enable"] = { 49, 0, 50, 0 },
	["airoptimization_enable"] = { 49, 1, 50, 1 },
	["double_engine_heat_enable"] = { 49, 2, 50, 2 },
	["smart_hybird_enable"] = { 49, 3, 50, 3 },
	["timer_announcement_enable"] = { 49, 4, 50, 4 },
	["smart_water_model_enable"] = { 49, 5, 50, 5 },
	["smart_hybird_pause_enable"] = { 49, 7, 50, 7 },
	["fast_heat_enable"] = { 61, 0, 62, 0 },
	["keep_warm_enable"] = { 61, 1, 62, 1 },
	["side_wind_switch_enable"] = { 61, 3, 62, 3 },
	["down_wind_switch_enable"] = { 61, 4, 62, 4 },
	["down_wind_swing_ud_enable"] = { 61, 5, 62, 5 },
	["down_wind_swing_lr_enable"] = { 61, 6, 62, 6 },
	["ptc_mode_enable"] = { 73, 0, 74, 0 },
	["ai_humidity_control_enable"] = { 73, 1, 74, 1 },
	["smart_frequency_conversion_enable"] = { 73, 2, 74, 2 },
	["buzzer_control_enable"] = { 73, 3, 74, 3 },
	["buzzer_off_status_enable"] = { 73, 4, 74, 4 },
	["ieco_strong_wind_enable"] = { 73, 5, 74, 5 },
	["power_tip_light_switch_enable"] = { 73, 6, 74, 6 },
	["smart_wind_enable"] = { 73, 7, 74, 7 },
	["human_close_gentle_wind_enable"] = { 75, 0, 76, 0 },
	["power_off_mode_enable_switch_enable"] = { 75, 1, 76, 1 },
	["remote_receive_switch_enable"] = { 75, 2, 76, 2 },
	["ai_energy_save_enable"] = { 75, 3, 76, 3 },
	["nobody_power_off_reduce_time_switch_enable"] = { 75, 4, 76, 4 },
}
local function c003_jsonToData(control, status)
	local bodyBytes = {}
	local funcValue = nil
	local enableList = {}
	for i = 0, 30 do
		bodyBytes[i] = 0
	end
	bodyBytes[0] = keyP["pack_id"]
	bodyBytes[1] = 1
	bodyBytes[2] = 1
	bodyBytes[3] = 0
	bodyBytes[4] = 0
	bodyBytes[5] = 0
	bodyBytes[6] = 0
	bodyBytes[7] = 0
	bodyBytes[8] = 0
	bodyBytes[9] = 0
	bodyBytes[10] = 0
	bodyBytes[11] = 0x01
	bodyBytes[12] = 0xC0
	bodyBytes[13] = 0x03
	bodyBytes[14] = 0x13
	local cursor = 15
	for k, v in pairs(control) do
		local enableName = k .. "_enable"
		enableList[enableName] = 1
	end
	for k, v in pairs(enableList) do
		control[k] = 1
	end
	for k, v in pairs(gC003OnOffConfig) do
		if control[k] then
			local pByteIndex = v[1] + cursor
			local fByteIndex = v[3] + cursor
			local funcName = string.sub(k, 0, #k - 7)
			print("keyValue ==== ", funcName)
			set_bit(bodyBytes, pByteIndex, v[2], 1)
			if control[funcName] == "on" or control[funcName] == 1 or control[funcName] == "1" then
				set_bit(bodyBytes, fByteIndex, v[4], 1)
			else
				set_bit(bodyBytes, fByteIndex, v[4], 0)
			end
		end
	end
	bodyBytes[cursor + 0] = keyP["new_wind_machine_type"]
	if control["fresh_air_mode_enable"] ~= nil and control["fresh_air_mode"] ~= nil then
		bodyBytes[cursor + 4] = bit.bor(control["fresh_air_mode"], bodyBytes[cursor + 4])
		bodyBytes[cursor + 4] = bit.bor(bit.lshift(control["fresh_air_mode_enable"], 7), bodyBytes[cursor + 4])
	end
	if control["wind_strength"] ~= nil then
		bodyBytes[cursor + 4] = bit.bor(bit.lshift(control["wind_strength"], 5), bodyBytes[cursor + 4])
		bodyBytes[cursor + 4] = bit.bor(bit.lshift(control["wind_strength_enable"], 7), bodyBytes[cursor + 4])
	end
	if control["exhaust_strength"] ~= nil then
		bodyBytes[cursor + 4] = bit.bor(bit.lshift(control["exhaust_strength"], 6), bodyBytes[cursor + 4])
		bodyBytes[cursor + 4] = bit.bor(bit.lshift(control["exhaust_strength_enable"], 7), bodyBytes[cursor + 4])
	end
	if control["fresh_air_intake_fan_speed_enable"] ~= nil and control["fresh_air_intake_fan_speed"] ~= nil then
		bodyBytes[cursor + 5] = bit.bor(control["fresh_air_intake_fan_speed"], bodyBytes[cursor + 5])
		bodyBytes[cursor + 5] =
			bit.bor(bit.lshift(control["fresh_air_intake_fan_speed_enable"], 7), bodyBytes[cursor + 5])
	end
	if control["fresh_air_exhaust_fan_speed_enable"] ~= nil and control["fresh_air_exhaust_fan_speed"] ~= nil then
		bodyBytes[cursor + 6] = bit.bor(control["fresh_air_exhaust_fan_speed"], bodyBytes[cursor + 6])
		bodyBytes[cursor + 6] =
			bit.bor(bit.lshift(control["fresh_air_exhaust_fan_speed_enable"], 7), bodyBytes[cursor + 6])
	end
	if control["power_on_timer_enable"] ~= nil and control["power_on_time_value"] ~= nil then
		bodyBytes[cursor + 7] = bit.band(control["power_on_time_value"], 0xFF)
		bodyBytes[cursor + 9] = bit.bor(bit.rshift(control["power_on_time_value"], 8), bodyBytes[cursor + 9])
	end
	if control["power_off_timer_enable"] ~= nil and control["power_off_time_value"] ~= nil then
		bodyBytes[cursor + 8] = bit.band(control["power_off_time_value"], 0xFF)
		bodyBytes[cursor + 9] = bit.bor(bit.lshift(bit.rshift(control["power_off_time_value"], 8), 4), bodyBytes[9])
	end
	if control["fresh_air_fan_speed_enable"] ~= nil and control["fresh_air_fan_speed"] ~= nil then
		bodyBytes[cursor + 1] = bit.band(control["fresh_air_fan_speed"], 0x7F)
		bodyBytes[cursor + 1] = bit.bor(bit.lshift(control["fresh_air_fan_speed_enable"], 7), bodyBytes[cursor + 1])
	end
	bodyBytes[30] = makeSum(bodyBytes, 12, 29)
	return bodyBytes
end
local function c004_jsonToData(control, status)
	print("enter c004=====")
	local bodyBytes = {}
	local funcValue = nil
	local enableList = {}
	for i = 0, 40 do
		bodyBytes[i] = 0
	end
	bodyBytes[0] = keyP["pack_id"]
	bodyBytes[1] = 1
	bodyBytes[2] = 1
	bodyBytes[3] = 0
	bodyBytes[4] = 0
	bodyBytes[5] = 0
	bodyBytes[6] = 0
	bodyBytes[7] = 0
	bodyBytes[8] = 0
	bodyBytes[9] = 0
	bodyBytes[10] = 0
	bodyBytes[11] = 0x01
	bodyBytes[12] = 0xC0
	bodyBytes[13] = 0x04
	bodyBytes[14] = 0x1d
	local cursor = 15
	for k, v in pairs(control) do
		local enableName = k .. "_enable"
		enableList[enableName] = 1
	end
	for k, v in pairs(enableList) do
		control[k] = 1
	end
	for k, v in pairs(gC004OnOffConfig) do
		if control[k] then
			local pByteIndex = v[1] + cursor
			local fByteIndex = v[3] + cursor
			local funcName = string.sub(k, 0, #k - 7)
			print("keyValue ==== ", funcName)
			set_bit(bodyBytes, pByteIndex, v[2], 1)
			if control[funcName] == "on" or control[funcName] == 1 or control[funcName] == "1" then
				set_bit(bodyBytes, fByteIndex, v[4], 1)
			else
				set_bit(bodyBytes, fByteIndex, v[4], 0)
			end
		end
	end
	if control["child_old_care_mode_switch_enable"] ~= nil and control["child_old_care_mode_switch"] ~= nil then
		bodyBytes[cursor + 1] = bit.bor(bit.lshift(control["child_old_care_mode_switch"], 1), bodyBytes[cursor + 1])
		bodyBytes[cursor + 0] =
			bit.bor(bit.lshift(control["child_old_care_mode_switch_enable"], 1), bodyBytes[cursor + 0])
	end
	if control["child_care_mode_temp_min_enable"] ~= nil and control["child_care_mode_temp_min"] ~= nil then
		bodyBytes[cursor + 4] = bit.bor((control["child_care_mode_temp_min"] * 2 + 30), bodyBytes[cursor + 4])
		bodyBytes[cursor + 4] =
			bit.bor(bit.lshift(control["child_care_mode_temp_min_enable"], 7), bodyBytes[cursor + 4])
	end
	if control["child_care_mode_temp_max_enable"] ~= nil and control["child_care_mode_temp_max"] ~= nil then
		bodyBytes[cursor + 5] = bit.bor((control["child_care_mode_temp_max"] * 2 + 30), bodyBytes[cursor + 5])
		bodyBytes[cursor + 5] =
			bit.bor(bit.lshift(control["child_care_mode_temp_max_enable"], 7), bodyBytes[cursor + 5])
	end
	if
		control["child_care_mode_gentle_wind_min_enable"] ~= nil
		and control["child_care_mode_gentle_wind_min"] ~= nil
	then
		bodyBytes[cursor + 6] = bit.bor(control["child_care_mode_gentle_wind_min"], bodyBytes[cursor + 6])
		bodyBytes[cursor + 6] =
			bit.bor(bit.lshift(control["child_care_mode_gentle_wind_min_enable"], 7), bodyBytes[cursor + 6])
	end
	if
		control["child_care_mode_gentle_wind_max_enable"] ~= nil
		and control["child_care_mode_gentle_wind_max"] ~= nil
	then
		bodyBytes[cursor + 7] = bit.bor(control["child_care_mode_gentle_wind_max"], bodyBytes[cursor + 7])
		bodyBytes[cursor + 7] =
			bit.bor(bit.lshift(control["child_care_mode_gentle_wind_max_enable"], 7), bodyBytes[cursor + 7])
	end
	if control["old_care_mode_temp_min_enable"] ~= nil and control["old_care_mode_temp_min"] ~= nil then
		bodyBytes[cursor + 10] = bit.bor((control["old_care_mode_temp_min"] * 2 + 30), bodyBytes[cursor + 10])
		bodyBytes[cursor + 10] =
			bit.bor(bit.lshift(control["old_care_mode_temp_min_enable"], 7), bodyBytes[cursor + 10])
	end
	if control["old_care_mode_temp_max_enable"] ~= nil and control["old_care_mode_temp_max"] ~= nil then
		bodyBytes[cursor + 11] = bit.bor((control["old_care_mode_temp_max"] * 2 + 30), bodyBytes[cursor + 11])
		bodyBytes[cursor + 11] =
			bit.bor(bit.lshift(control["old_care_mode_temp_max_enable"], 7), bodyBytes[cursor + 11])
	end
	if control["old_care_mode_gentle_wind_min_enable"] ~= nil and control["old_care_mode_gentle_wind_min"] ~= nil then
		bodyBytes[cursor + 12] = bit.bor(control["old_care_mode_gentle_wind_min"], bodyBytes[cursor + 12])
		bodyBytes[cursor + 12] =
			bit.bor(bit.lshift(control["old_care_mode_gentle_wind_min_enable"], 7), bodyBytes[cursor + 12])
	end
	if control["old_care_mode_gentle_wind_max_enable"] ~= nil and control["old_care_mode_gentle_wind_max"] ~= nil then
		bodyBytes[cursor + 13] = bit.bor(control["old_care_mode_gentle_wind_max"], bodyBytes[cursor + 13])
		bodyBytes[cursor + 13] =
			bit.bor(bit.lshift(control["old_care_mode_gentle_wind_max_enable"], 13), bodyBytes[cursor + 7])
	end
	bodyBytes[40] = makeSum(bodyBytes, 12, 39)
	return bodyBytes
end
local function c002_jsonToDataTemp(control, status)
	local bodyBytes = {}
	local funcValue = nil
	local enableList = {}
	for i = 0, 96 do
		bodyBytes[i] = 0
	end
	bodyBytes[0] = keyP["pack_id"]
	bodyBytes[1] = 1
	bodyBytes[2] = 1
	bodyBytes[3] = 0
	bodyBytes[4] = 0
	bodyBytes[5] = 0
	bodyBytes[6] = 0
	bodyBytes[7] = 0
	bodyBytes[8] = 0
	bodyBytes[9] = 0
	bodyBytes[10] = 0
	bodyBytes[11] = 0x01
	bodyBytes[12] = 0xC0
	bodyBytes[13] = 0x02
	bodyBytes[14] = 0x55
	local cursor = 15
	for k, v in pairs(control) do
		local enableName = k .. "_enable"
		enableList[enableName] = 1
	end
	for k, v in pairs(enableList) do
		control[k] = 1
	end
	for k, v in pairs(gC002OnOffConfigTemp) do
		if control[k] then
			local pByteIndex = v[1] + cursor
			local fByteIndex = v[3] + cursor
			local funcName = string.sub(k, 0, #k - 7)
			print("keyValue ==== ", funcName)
			set_bit(bodyBytes, pByteIndex, v[2], 1)
			if control[funcName] == "on" or control[funcName] == 1 or control[funcName] == "1" then
				set_bit(bodyBytes, fByteIndex, v[4], 1)
			else
				set_bit(bodyBytes, fByteIndex, v[4], 0)
			end
		end
	end
	if control["mode_enable"] ~= nil and control["mode"] ~= nil then
		bodyBytes[cursor + 8] = bit.bor(keyP["modeValue"], bodyBytes[cursor + 8])
		bodyBytes[cursor + 8] = bit.bor(bit.lshift(control["mode_enable"], 7), bodyBytes[cursor + 8])
	end
	if control["temperature_enable"] ~= nil and control["temperature"] ~= nil then
		if control["small_temperature"] == nil then
			if status["small_temperature"] ~= nil then
				control["small_temperature"] = status["small_temperature"]
			else
				control["small_temperature"] = 0
			end
		end
		bodyBytes[cursor + 9] = (control["temperature"] + control["small_temperature"]) * 2 + 30
		bodyBytes[cursor + 9] = bit.bor(bit.lshift(control["temperature_enable"], 7), bodyBytes[cursor + 9])
	end
	if control["wind_speed_enable"] ~= nil and control["wind_speed"] ~= nil then
		bodyBytes[cursor + 10] = bit.bor(control["wind_speed"], bodyBytes[cursor + 10])
		bodyBytes[cursor + 10] = bit.bor(bit.lshift(control["wind_speed_enable"], 7), bodyBytes[cursor + 10])
	end
	if control["dehumidity_enable"] ~= nil and control["dehumidity"] ~= nil then
		bodyBytes[cursor + 11] = bit.bor(control["dehumidity"], bodyBytes[cursor + 11])
		bodyBytes[cursor + 11] = bit.bor(bit.lshift(control["dehumidity_enable"], 7), bodyBytes[cursor + 11])
	end
	if control["humidity_enable"] ~= nil and control["humidity"] ~= nil then
		bodyBytes[cursor + 12] = bit.bor(control["humidity"], bodyBytes[cursor + 12])
		bodyBytes[cursor + 12] = bit.bor(bit.lshift(control["humidity_enable"], 7), bodyBytes[cursor + 12])
	end
	if control["power_on_timer_enable"] ~= nil and control["power_on_time_value"] ~= nil then
		bodyBytes[cursor + 15] = bit.band(control["power_on_time_value"], 0xFF)
		bodyBytes[cursor + 17] = bit.bor(bit.rshift(control["power_on_time_value"], 8), bodyBytes[cursor + 17])
	end
	if control["power_off_timer_enable"] ~= nil and control["power_off_time_value"] ~= nil then
		bodyBytes[cursor + 16] = bit.band(control["power_off_time_value"], 0xFF)
		bodyBytes[cursor + 17] =
			bit.bor(bit.lshift(bit.rshift(control["power_off_time_value"], 8), 4), bodyBytes[cursor + 17])
	end
	if control["new_wind_model_on_timer_enable"] ~= nil and control["new_wind_model_on_timer_value"] ~= nil then
		bodyBytes[cursor + 18] = bit.band(control["new_wind_model_on_timer_value"], 0xFF)
		bodyBytes[cursor + 20] =
			bit.bor(bit.rshift(control["new_wind_model_on_timer_value"], 8), bodyBytes[cursor + 20])
	end
	if control["new_wind_model_off_timer_enable"] ~= nil and control["new_wind_model_off_timer_value"] ~= nil then
		bodyBytes[cursor + 19] = bit.band(control["new_wind_model_off_timer_value"], 0xFF)
		bodyBytes[cursor + 20] =
			bit.bor(bit.lshift(bit.rshift(control["new_wind_model_off_timer_value"], 8), 4), bodyBytes[cursor + 20])
	end
	if keyP["comfortableSleepValue"] == 0x30 and comfortByte ~= nil then
		bodyBytes[cursor + 21] = bit.bor(
			checkBoundary(comfortByte[1], 16, 30) - 16,
			bit.lshift((checkBoundary(comfortByte[2], 16, 30) - 16), 4)
		)
		bodyBytes[cursor + 22] = bit.bor(
			checkBoundary(comfortByte[3], 16, 30) - 16,
			bit.lshift((checkBoundary(comfortByte[4], 16, 30) - 16), 4)
		)
		bodyBytes[cursor + 23] =
			bit.bor(checkBoundary(comfortByte[5], 16, 30) - 16, bit.lshift((comfortByte[6] - 16), 4))
		bodyBytes[cursor + 24] =
			bit.bor(checkBoundary(comfortByte[7], 16, 30) - 16, bit.lshift((comfortByte[8] - 16), 4))
		bodyBytes[cursor + 25] =
			bit.bor(checkBoundary(comfortByte[9], 16, 30) - 16, bit.lshift((comfortByte[10] - 16), 4))
	end
	if control["water_model_temperature_set_enable"] ~= nil and control["water_model_temperature_set"] ~= nil then
		bodyBytes[cursor + 30] = bit.bor((control["water_model_temperature_set"] * 2 + 50), bodyBytes[cursor + 30])
		bodyBytes[cursor + 29] =
			bit.bor(bit.lshift(control["water_model_temperature_set_enable"], 6), bodyBytes[cursor + 29])
	end
	if control["water_mode_enable"] ~= nil and control["water_mode"] ~= nil then
		bodyBytes[cursor + 29] = bit.bor(control["water_mode"], bodyBytes[cursor + 29])
		bodyBytes[cursor + 29] = bit.bor(bit.lshift(control["water_mode_enable"], 7), bodyBytes[cursor + 29])
	end
	if control["left_right_wind_direction_enable"] ~= nil and control["left_right_wind_direction"] ~= nil then
		bodyBytes[cursor + 31] = bit.bor(bit.lshift(control["left_right_wind_direction"], 4), bodyBytes[cursor + 31])
		bodyBytes[cursor + 27] =
			bit.bor(bit.lshift(control["left_right_wind_direction_enable"], 7), bodyBytes[cursor + 27])
	end
	if control["up_down_wind_direction_enable"] ~= nil and control["up_down_wind_direction"] ~= nil then
		bodyBytes[cursor + 31] = bit.bor(control["up_down_wind_direction"], bodyBytes[cursor + 31])
		bodyBytes[cursor + 27] =
			bit.bor(bit.lshift(control["up_down_wind_direction_enable"], 6), bodyBytes[cursor + 27])
	end
	if control["fresh_air_mode_enable"] ~= nil and control["fresh_air_mode"] ~= nil then
		bodyBytes[cursor + 32] = bit.bor(control["fresh_air_mode"], bodyBytes[cursor + 32])
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(control["fresh_air_mode_enable"], 7), bodyBytes[cursor + 32])
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(keyP["exhaust_strength"], 6), bodyBytes[cursor + 32])
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(keyP["wind_strength"], 5), bodyBytes[cursor + 32])
	end
	if control["wind_strength"] ~= nil then
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(control["wind_strength"], 5), bodyBytes[cursor + 32])
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(control["wind_strength_enable"], 7), bodyBytes[cursor + 32])
	end
	if control["exhaust_strength"] ~= nil then
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(control["exhaust_strength"], 6), bodyBytes[cursor + 32])
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(control["exhaust_strength_enable"], 7), bodyBytes[cursor + 32])
	end
	if control["fresh_air_fan_speed_enable"] ~= nil and control["fresh_air_fan_speed"] ~= nil then
		bodyBytes[cursor + 33] = bit.bor(control["fresh_air_fan_speed"], bodyBytes[cursor + 33])
		bodyBytes[cursor + 33] = bit.bor(bit.lshift(control["fresh_air_fan_speed_enable"], 7), bodyBytes[cursor + 33])
	end
	if control["quick_prepare_food_angle_enable"] ~= nil and control["quick_prepare_food_angle"] ~= nil then
		bodyBytes[cursor + 34] = bit.bor(control["quick_prepare_food_angle"], bodyBytes[cursor + 34])
		bodyBytes[cursor + 34] =
			bit.bor(bit.lshift(control["quick_prepare_food_angle_enable"], 7), bodyBytes[cursor + 34])
	end
	if control["dry_type"] ~= nil then
		bodyBytes[cursor + 61] = bit.bor(bit.lshift(control["dry_type_enable"], 2), bodyBytes[cursor + 61])
		bodyBytes[cursor + 35] = bit.bor(bodyBytes[cursor + 35], control["dry_type"])
	end
	if control["comfort_sleep"] ~= nil and control["comfort_sleep"] == "on" then
		bodyBytes[cursor + 35] = bit.bor(bodyBytes[cursor + 35], 0x80)
	end
	if control["fengguan_type"] ~= nil then
		bodyBytes[cursor + 36] = control["fengguan_type"]
	end
	if control["new_home_remove_arofene"] ~= nil and control["new_home_remove_arofene_enable"] ~= nil then
		bodyBytes[cursor + 38] = bit.bor(control["new_home_remove_arofene"], bodyBytes[cursor + 38])
		bodyBytes[cursor + 38] =
			bit.bor(bit.lshift(control["new_home_remove_arofene_enable"], 3), bodyBytes[cursor + 38])
	end
	if control["shortest_remove_odor_time_enable"] ~= nil and control["shortest_remove_odor_time"] ~= nil then
		bodyBytes[cursor + 39] = bit.band(control["shortest_remove_odor_time"], 0xFF)
		bodyBytes[cursor + 40] = bit.band(bit.rshift(control["shortest_remove_odor_time"], 8), 0xFF)
		bodyBytes[cursor + 45] =
			bit.bor(bit.lshift(control["shortest_remove_odor_time_enable"], 2), bodyBytes[cursor + 45])
	end
	if control["longest_remove_odor_time_enable"] ~= nil and control["longest_remove_odor_time"] ~= nil then
		bodyBytes[cursor + 41] = bit.band(control["longest_remove_odor_time"], 0xFF)
		bodyBytes[cursor + 42] = bit.band(bit.rshift(control["longest_remove_odor_time"], 8), 0xFF)
		bodyBytes[cursor + 45] =
			bit.bor(bit.lshift(control["longest_remove_odor_time_enable"], 3), bodyBytes[cursor + 45])
	end
	if control["fresh_air_intake_wind_enable"] ~= nil and control["fresh_air_intake_wind"] ~= nil then
		bodyBytes[cursor + 43] = bit.bor(control["fresh_air_intake_wind"], bodyBytes[cursor + 43])
		bodyBytes[cursor + 45] = bit.bor(bit.lshift(control["fresh_air_intake_wind_enable"], 4), bodyBytes[cursor + 45])
	end
	if control["fresh_air_exhaust_wind_enable"] ~= nil and control["fresh_air_exhaust_wind"] ~= nil then
		bodyBytes[cursor + 44] = bit.bor(control["fresh_air_exhaust_wind"], bodyBytes[cursor + 44])
		bodyBytes[cursor + 45] =
			bit.bor(bit.lshift(control["fresh_air_exhaust_wind_enable"], 5), bodyBytes[cursor + 45])
	end
	if control["fresh_air_intake_fan_speed_enable"] ~= nil and control["fresh_air_intake_fan_speed"] ~= nil then
		bodyBytes[cursor + 47] = bit.bor(control["fresh_air_intake_fan_speed"], bodyBytes[cursor + 47])
		bodyBytes[cursor + 47] =
			bit.bor(bit.lshift(control["fresh_air_intake_fan_speed_enable"], 7), bodyBytes[cursor + 47])
	end
	if control["fresh_air_exhaust_fan_speed_enable"] ~= nil and control["fresh_air_exhaust_fan_speed"] ~= nil then
		bodyBytes[cursor + 48] = bit.bor(control["fresh_air_exhaust_fan_speed"], bodyBytes[cursor + 48])
		bodyBytes[cursor + 48] =
			bit.bor(bit.lshift(control["fresh_air_exhaust_fan_speed_enable"], 7), bodyBytes[cursor + 48])
	end
	if control["water_model_force_temp_enable"] ~= nil and control["water_model_force_temp"] ~= nil then
		bodyBytes[cursor + 54] = bit.bor(control["water_model_force_temp"], bodyBytes[cursor + 54])
		bodyBytes[cursor + 49] =
			bit.bor(bit.lshift(control["water_model_force_temp_enable"], 6), bodyBytes[cursor + 49])
	end
	if control["airoptimization_temperature_enable"] ~= nil and control["airoptimization_temperature"] ~= nil then
		bodyBytes[cursor + 51] = bit.bor((control["airoptimization_temperature"] * 2 + 30), bodyBytes[cursor + 51])
		bodyBytes[cursor + 51] =
			bit.bor(bit.lshift(control["airoptimization_temperature_enable"], 7), bodyBytes[cursor + 51])
	end
	if control["airoptimization_speed_enable"] ~= nil and control["airoptimization_speed"] ~= nil then
		bodyBytes[cursor + 52] = bit.bor(control["airoptimization_speed"], bodyBytes[cursor + 52])
		bodyBytes[cursor + 52] = bit.bor(bit.lshift(control["airoptimization_speed_enable"], 7), bodyBytes[cursor + 52])
	end
	if control["airoptimization_humidity_enable"] ~= nil and control["airoptimization_humidity"] ~= nil then
		bodyBytes[cursor + 53] = bit.bor(control["airoptimization_humidity"], bodyBytes[cursor + 53])
		bodyBytes[cursor + 53] =
			bit.bor(bit.lshift(control["airoptimization_humidity_enable"], 7), bodyBytes[cursor + 53])
	end
	if control["new_wind_model_intake_wind_enable"] ~= nil and control["new_wind_model_intake_wind"] ~= nil then
		bodyBytes[cursor + 55] = bit.bor(control["new_wind_model_intake_wind"], bodyBytes[cursor + 55])
		bodyBytes[cursor + 55] =
			bit.bor(bit.lshift(control["new_wind_model_intake_wind_enable"], 7), bodyBytes[cursor + 55])
	end
	if control["new_wind_model_exhaust_wind_enable"] ~= nil and control["new_wind_model_exhaust_wind"] ~= nil then
		bodyBytes[cursor + 56] = bit.bor(control["new_wind_model_exhaust_wind"], bodyBytes[cursor + 56])
		bodyBytes[cursor + 56] =
			bit.bor(bit.lshift(control["new_wind_model_exhaust_wind_enable"], 7), bodyBytes[cursor + 56])
	end
	if control["inner_purifier_on_pm_enable"] ~= nil and control["inner_purifier_on_pm"] ~= nil then
		bodyBytes[cursor + 57] = bit.bor(math.floor(control["inner_purifier_on_pm"] / 256), bodyBytes[cursor + 57])
		bodyBytes[cursor + 58] = bit.bor(math.floor(control["inner_purifier_on_pm"] % 256), bodyBytes[cursor + 58])
		bodyBytes[cursor + 57] = bit.bor(bit.lshift(control["inner_purifier_on_pm_enable"], 7), bodyBytes[cursor + 57])
	end
	if control["fresh_air_on_co2_enable"] ~= nil and control["fresh_air_on_co2"] ~= nil then
		bodyBytes[cursor + 59] = bit.bor(math.floor(control["fresh_air_on_co2"] / 256), bodyBytes[cursor + 59])
		bodyBytes[cursor + 60] = bit.bor(math.floor(control["fresh_air_on_co2"] % 256), bodyBytes[cursor + 60])
		bodyBytes[cursor + 59] = bit.bor(bit.lshift(control["fresh_air_on_co2_enable"], 7), bodyBytes[cursor + 59])
	end
	if control["fast_heat_angle_enable"] ~= nil and control["fast_heat_angle"] ~= nil then
		bodyBytes[cursor + 63] = bit.bor(control["fast_heat_angle"], bodyBytes[cursor + 63])
		bodyBytes[cursor + 63] = bit.bor(bit.lshift(control["fast_heat_angle_enable"], 7), bodyBytes[cursor + 63])
	end
	if control["close_huanqi_time_enable"] ~= nil and control["close_huanqi_time"] ~= nil then
		bodyBytes[cursor + 64] = bit.bor(control["close_huanqi_time"], bodyBytes[cursor + 64])
		bodyBytes[cursor + 64] = bit.bor(bit.lshift(control["close_huanqi_time_enable"], 7), bodyBytes[cursor + 64])
	end
	if control["ventilator_level_enable"] ~= nil and control["ventilator_level"] ~= nil then
		bodyBytes[cursor + 65] = bit.bor(control["ventilator_level"], bodyBytes[cursor + 65])
		bodyBytes[cursor + 65] = bit.bor(bit.lshift(control["ventilator_level_enable"], 7), bodyBytes[cursor + 65])
	end
	if control["ieco_indoor_wind_speed_level_enable"] ~= nil and control["ieco_indoor_wind_speed_level"] ~= nil then
		bodyBytes[cursor + 66] = bit.bor(control["ieco_indoor_wind_speed_level"], bodyBytes[cursor + 66])
		bodyBytes[cursor + 66] =
			bit.bor(bit.lshift(control["ieco_indoor_wind_speed_level_enable"], 7), bodyBytes[cursor + 66])
	end
	if control["ieco_target_rate_enable"] ~= nil and control["ieco_target_rate"] ~= nil then
		bodyBytes[cursor + 68] = bit.band(control["ieco_target_rate"], 0xFF)
		bodyBytes[cursor + 67] = bit.band(bit.rshift(control["ieco_target_rate"], 8), 0xFF)
		bodyBytes[cursor + 67] = bit.bor(bit.lshift(control["ieco_target_rate_enable"], 7), bodyBytes[cursor + 67])
	end
	if control["down_horizontal_wind_direction_enable"] ~= nil and control["down_horizontal_wind_direction"] ~= nil then
		bodyBytes[cursor + 69] = bit.bor(control["down_horizontal_wind_direction"], 0x0F)
		bodyBytes[cursor + 46] =
			bit.bor(bit.lshift(control["down_horizontal_wind_direction_enable"], 2), bodyBytes[cursor + 46])
	end
	if control["down_vertical_wind_direction_enable"] ~= nil and control["down_vertical_wind_direction"] ~= nil then
		bodyBytes[cursor + 69] = bit.bor(bit.lshift(control["down_vertical_wind_direction"], 4), 0xF0)
		bodyBytes[cursor + 46] =
			bit.bor(bit.lshift(control["down_vertical_wind_direction_enable"], 3), bodyBytes[cursor + 46])
	end
	if control["nobody_off_time_enable"] ~= nil and control["nobody_off_time"] ~= nil then
		bodyBytes[cursor + 70] = bit.bor(control["nobody_off_time"], bodyBytes[cursor + 70])
		bodyBytes[cursor + 70] = bit.bor(bit.lshift(control["nobody_off_time_enable"], 6), bodyBytes[cursor + 70])
	end
	if
		control["save_energy_mode_effective_countdown_enable"] ~= nil
		and control["save_energy_mode_effective_countdown"] ~= nil
	then
		bodyBytes[cursor + 72] = bit.band(control["save_energy_mode_effective_countdown"], 0x07)
		bodyBytes[cursor + 71] = bit.band(bit.rshift(control["save_energy_mode_effective_countdown"], 3), 0xFF)
		bodyBytes[cursor + 70] =
			bit.bor(bit.lshift(control["save_energy_mode_effective_countdown_enable"], 7), bodyBytes[cursor + 70])
	end
	if
		control["smart_frequency_conversion_status_enable"] ~= nil
		and control["smart_frequency_conversion_status"] ~= nil
	then
		bodyBytes[cursor + 72] =
			bit.bor(bit.lshift(control["smart_frequency_conversion_status_enable"], 7), bodyBytes[cursor + 72])
		bodyBytes[cursor + 72] =
			bit.bor(bit.band(bit.lshift(control["smart_frequency_conversion_status"], 3), 0x78), bodyBytes[cursor + 72])
	end
	if control["smart_wind_sensitivity_enable"] ~= nil and control["smart_wind_sensitivity"] ~= nil then
		bodyBytes[cursor + 62] =
			bit.bor(bit.lshift(control["smart_wind_sensitivity_enable"], 2), bodyBytes[cursor + 62])
		bodyBytes[cursor + 77] = bit.bor(control["smart_wind_sensitivity"], bodyBytes[cursor + 77])
	end
	if control["ai_energy_save_func_enable"] ~= nil and control["ai_energy_save_func"] ~= nil then
		bodyBytes[cursor + 78] = bit.band(bit.lshift(control["ai_energy_save_func"], 3), 0x78)
		bodyBytes[cursor + 78] = bit.bor(bit.lshift(control["ai_energy_save_func_enable"], 7), bodyBytes[cursor + 78])
	end
	bodyBytes[96] = makeSum(bodyBytes, 12, 95)
	return bodyBytes
end
local gC002OnOffConfig = {
	["power_enable"] = { pbyIndex = 0, pbitIndex = 0, fbyIndex = 1, fbitIndex = 0 },
	["mute_enable"] = { pbyIndex = 0, pbitIndex = 1, fbyIndex = 1, fbitIndex = 1 },
	["no_wind_sense_enable"] = { pbyIndex = 0, pbitIndex = 2, fbyIndex = 1, fbitIndex = 2 },
	["dry_enable"] = { pbyIndex = 0, pbitIndex = 3, fbyIndex = 1, fbitIndex = 3 },
	["follow_body_sense_enable"] = { pbyIndex = 0, pbitIndex = 4, fbyIndex = 1, fbitIndex = 4 },
	["cool_hot_sense_enable"] = { pbyIndex = 0, pbitIndex = 5, fbyIndex = 1, fbitIndex = 5 },
	["wind_swing_ud_enable"] = { pbyIndex = 0, pbitIndex = 6, fbyIndex = 1, fbitIndex = 6 },
	["wind_swing_lr_enable"] = { pbyIndex = 0, pbitIndex = 7, fbyIndex = 1, fbitIndex = 7 },
	["ptc_enable"] = { pbyIndex = 2, pbitIndex = 0, fbyIndex = 3, fbitIndex = 0 },
	["ptc_dependT4_enable"] = { pbyIndex = 2, pbitIndex = 1, fbyIndex = 3, fbitIndex = 1 },
	["wind_straight_enable"] = { pbyIndex = 2, pbitIndex = 2, fbyIndex = 3, fbitIndex = 2 },
	["wind_avoid_enable"] = { pbyIndex = 2, pbitIndex = 3, fbyIndex = 3, fbitIndex = 3 },
	["fengguan_remove_odor_enable"] = { pbyIndex = 2, pbitIndex = 4, fbyIndex = 3, fbitIndex = 4 },
	["self_clean_enable"] = { pbyIndex = 2, pbitIndex = 5, fbyIndex = 3, fbitIndex = 5 },
	["energy_save_enable"] = { pbyIndex = 2, pbitIndex = 6, fbyIndex = 3, fbitIndex = 6 },
	["nobody_energy_save_enable"] = { pbyIndex = 2, pbitIndex = 7, fbyIndex = 3, fbitIndex = 7 },
	["inner_purifier_enable"] = { pbyIndex = 4, pbitIndex = 0, fbyIndex = 5, fbitIndex = 0 },
	["manu_inner_purifier_enable"] = { pbyIndex = 4, pbitIndex = 1, fbyIndex = 5, fbitIndex = 1 },
	["auto_humi_enable"] = { pbyIndex = 4, pbitIndex = 2, fbyIndex = 5, fbitIndex = 2 },
	["manul_humi_enable"] = { pbyIndex = 4, pbitIndex = 3, fbyIndex = 5, fbitIndex = 3 },
	["new_wind_machine_enable"] = { pbyIndex = 4, pbitIndex = 4, fbyIndex = 5, fbitIndex = 4 },
	["new_wind_machine_link_enable"] = { pbyIndex = 4, pbitIndex = 5, fbyIndex = 5, fbitIndex = 5 },
	["fresh_air_remove_odor_enable"] = { pbyIndex = 4, pbitIndex = 6, fbyIndex = 5, fbitIndex = 6 },
	["stop_warm_enable"] = { pbyIndex = 4, pbitIndex = 7, fbyIndex = 5, fbitIndex = 7 },
	["eco_enable"] = { pbyIndex = 6, pbitIndex = 0, fbyIndex = 7, fbitIndex = 0 },
	["prevent_super_cool_enable"] = { pbyIndex = 6, pbitIndex = 1, fbyIndex = 7, fbitIndex = 1 },
	["new_wind_model_intake_switch_enable"] = { pbyIndex = 6, pbitIndex = 2, fbyIndex = 7, fbitIndex = 2 },
	["new_wind_model_exhaust_switch_enable"] = { pbyIndex = 6, pbitIndex = 3, fbyIndex = 7, fbitIndex = 3 },
	["new_wind_model_mute_enable"] = { pbyIndex = 6, pbitIndex = 4, fbyIndex = 7, fbitIndex = 4 },
	["tube_protect_enable"] = { pbyIndex = 6, pbitIndex = 5, fbyIndex = 7, fbitIndex = 5 },
	["prepare_food_enable"] = { pbyIndex = 6, pbitIndex = 6, fbyIndex = 7, fbitIndex = 6 },
	["quick_fry_enable"] = { pbyIndex = 6, pbitIndex = 7, fbyIndex = 7, fbitIndex = 7 },
	["power_on_timer_enable"] = { pbyIndex = 13, pbitIndex = 0, fbyIndex = 14, fbitIndex = 0 },
	["power_off_timer_enable"] = { pbyIndex = 13, pbitIndex = 1, fbyIndex = 14, fbitIndex = 1 },
	["new_wind_model_on_timer_enable"] = { pbyIndex = 13, pbitIndex = 2, fbyIndex = 14, fbitIndex = 2 },
	["new_wind_model_off_timer_enable"] = { pbyIndex = 13, pbitIndex = 3, fbyIndex = 14, fbitIndex = 3 },
	["comfort_sleep_enable"] = { pbyIndex = 13, pbitIndex = 4, fbyIndex = 14, fbitIndex = 4 },
	["buzzer_enable"] = { pbyIndex = 13, pbitIndex = 5, fbyIndex = 14, fbitIndex = 5 },
	["fresh_air_remove_odor_enable"] = { pbyIndex = 13, pbitIndex = 6, fbyIndex = 14, fbitIndex = 6 },
	["voice_control_enable"] = { pbyIndex = 13, pbitIndex = 7, fbyIndex = 14, fbitIndex = 7 },
	["water_model_power_enable"] = { pbyIndex = 27, pbitIndex = 0, fbyIndex = 28, fbitIndex = 0 },
	["water_model_power_save_enable"] = { pbyIndex = 27, pbitIndex = 1, fbyIndex = 28, fbitIndex = 1 },
	["water_model_clean_enable"] = { pbyIndex = 27, pbitIndex = 2, fbyIndex = 28, fbitIndex = 2 },
	["water_model_temperature_auto_enable"] = { pbyIndex = 27, pbitIndex = 3, fbyIndex = 28, fbitIndex = 3 },
	["water_model_ptc_enable"] = { pbyIndex = 27, pbitIndex = 4, fbyIndex = 28, fbitIndex = 4 },
	["water_model_go_out_enable"] = { pbyIndex = 27, pbitIndex = 5, fbyIndex = 28, fbitIndex = 5 },
}
local function c002_jsonToData(control, status)
	local bodyBytes = {}
	local funcValue = nil
	for i = 0, 74 do
		bodyBytes[i] = 0
	end
	bodyBytes[0] = keyP["pack_id"]
	bodyBytes[1] = 1
	bodyBytes[2] = 1
	bodyBytes[3] = 0
	bodyBytes[4] = 0
	bodyBytes[5] = 0
	bodyBytes[6] = 0
	bodyBytes[7] = 0
	bodyBytes[8] = 0
	bodyBytes[9] = 0
	bodyBytes[10] = 0
	bodyBytes[11] = 0x01
	bodyBytes[12] = 0xC0
	bodyBytes[13] = 0x02
	bodyBytes[14] = 0x3C
	local cursor = 15
	for k, v in pairs(gC002OnOffConfigTemp) do
		if control[k] then
			local pByteIndex = v.pbyIndex + cursor
			local fByteIndex = v.fbyIndex + cursor
			local funcName = string.sub(k, 0, #k - 7)
			print("keyValue ==== ", funcName)
			set_bit(bodyBytes, pByteIndex, v.pbitIndex, 1)
			if control[funcName] == "on" or control[funcName] == 1 or control[funcName] == "1" then
				set_bit(bodyBytes, fByteIndex, v.fbitIndex, 1)
			else
				set_bit(bodyBytes, fByteIndex, v.fbitIndex, 0)
			end
		end
	end
	if control["mode_enable"] ~= nil and control["mode"] ~= nil then
		bodyBytes[cursor + 8] = bit.bor(control["mode"], bodyBytes[cursor + 8])
		bodyBytes[cursor + 8] = bit.bor(bit.lshift(control["mode_enable"], 7), bodyBytes[cursor + 8])
	end
	if control["temperature_enable"] ~= nil and control["temperature"] ~= nil then
		bodyBytes[cursor + 9] = (control["temperature"] + control["small_temperature"]) * 2 + 30
		bodyBytes[cursor + 9] = bit.bor(bit.lshift(control["temperature_enable"], 7), bodyBytes[cursor + 9])
	end
	if control["wind_speed_enable"] ~= nil and control["wind_speed"] ~= nil then
		bodyBytes[cursor + 10] = bit.bor(control["wind_speed"], bodyBytes[cursor + 10])
		bodyBytes[cursor + 10] = bit.bor(bit.lshift(control["wind_speed_enable"], 7), bodyBytes[cursor + 10])
	end
	if control["dehumidity_enable"] ~= nil and control["dehumidity"] ~= nil then
		bodyBytes[cursor + 11] = bit.bor(control["dehumidity"], bodyBytes[cursor + 11])
		bodyBytes[cursor + 11] = bit.bor(bit.lshift(control["dehumidity_enable"], 7), bodyBytes[cursor + 11])
	end
	if control["humidity_enable"] ~= nil and control["humidity"] ~= nil then
		bodyBytes[cursor + 12] = bit.bor(control["humidity"], bodyBytes[cursor + 12])
		bodyBytes[cursor + 12] = bit.bor(bit.lshift(control["humidity_enable"], 7), bodyBytes[cursor + 12])
	end
	if control["power_on_timer_enable"] ~= nil and control["power_on_time_value"] ~= nil then
		bodyBytes[cursor + 15] = bit.band(control["power_on_time_value"], 0xFF)
		bodyBytes[cursor + 17] = bit.bor(bit.rshift(control["power_on_time_value"], 8), bodyBytes[cursor + 17])
	end
	if control["power_off_timer_enable"] ~= nil and control["power_off_time_value"] ~= nil then
		bodyBytes[cursor + 16] = bit.band(control["power_off_time_value"], 0xFF)
		bodyBytes[cursor + 17] = bit.bor(bit.lshift(bit.rshift(control["power_off_time_value"], 8), 4), bodyBytes[17])
	end
	if control["new_wind_model_on_timer_enable"] ~= nil and control["new_wind_model_on_timer_value"] ~= nil then
		bodyBytes[cursor + 18] = bit.band(control["power_on_time_value"], 0xFF)
		bodyBytes[cursor + 20] = bit.bor(bit.rshift(control["power_on_time_value"], 8), bodyBytes[cursor + 20])
	end
	if control["new_wind_model_off_timer_enable"] ~= nil and control["new_wind_model_off_timer_value"] ~= nil then
		bodyBytes[cursor + 19] = bit.band(control["power_off_time_value"], 0xFF)
		bodyBytes[cursor + 20] = bit.bor(bit.lshift(bit.rshift(control["power_off_time_value"], 8), 4), bodyBytes[20])
	end
	if keyP["comfortableSleepValue"] == 0x30 and comfortByte ~= nil then
		bodyBytes[cursor + 21] = bit.bor(
			checkBoundary(comfortByte[1], 16, 30) - 16,
			bit.lshift((checkBoundary(comfortByte[2], 16, 30) - 16), 4)
		)
		bodyBytes[cursor + 22] = bit.bor(
			checkBoundary(comfortByte[3], 16, 30) - 16,
			bit.lshift((checkBoundary(comfortByte[4], 16, 30) - 16), 4)
		)
		bodyBytes[cursor + 23] =
			bit.bor(checkBoundary(comfortByte[5], 16, 30) - 16, bit.lshift((comfortByte[6] - 16), 4))
		bodyBytes[cursor + 24] =
			bit.bor(checkBoundary(comfortByte[7], 16, 30) - 16, bit.lshift((comfortByte[8] - 16), 4))
		bodyBytes[cursor + 25] =
			bit.bor(checkBoundary(comfortByte[9], 16, 30) - 16, bit.lshift((comfortByte[10] - 16), 4))
	end
	if control["water_model_temperature_set_enable"] ~= nil and control["water_model_temperature_set"] ~= nil then
		bodyBytes[cursor + 30] = bit.bor(control["dehumidity"], bodyBytes[cursor + 30])
		bodyBytes[cursor + 29] =
			bit.bor(bit.lshift(control["water_model_temperature_set_enable"], 7), bodyBytes[cursor + 29])
	end
	if control["water_mode_enable"] ~= nil and control["water_mode"] ~= nil then
		bodyBytes[cursor + 29] = bit.bor(control["water_mode"], bodyBytes[cursor + 29])
		bodyBytes[cursor + 29] = bit.bor(bit.lshift(control["water_mode_enable"], 6), bodyBytes[cursor + 29])
	end
	if control["left_right_wind_direction_enable"] ~= nil and control["left_right_wind_direction"] ~= nil then
		bodyBytes[cursor + 31] = bit.bor(bit.lshift(control["left_right_wind_direction"], 4), bodyBytes[cursor + 31])
		bodyBytes[cursor + 27] =
			bit.bor(bit.lshift(control["left_right_wind_direction_enable"], 7), bodyBytes[cursor + 27])
	end
	if control["up_down_wind_direction_enable"] ~= nil and control["up_down_wind_direction"] ~= nil then
		bodyBytes[cursor + 31] = bit.bor(control["up_down_wind_direction"], bodyBytes[cursor + 31])
		bodyBytes[cursor + 27] =
			bit.bor(bit.lshift(control["up_down_wind_direction_enable"], 6), bodyBytes[cursor + 27])
	end
	if control["fresh_air_mode_enable"] ~= nil and control["fresh_air_mode"] ~= nil then
		bodyBytes[cursor + 32] = bit.bor(control["fresh_air_mode"], bodyBytes[cursor + 32])
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(control["fresh_air_mode_enable"], 7), bodyBytes[cursor + 32])
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(keyP["exhaust_strength"], 6), bodyBytes[cursor + 32])
		bodyBytes[cursor + 32] = bit.bor(bit.lshift(keyP["wind_strength"], 5), bodyBytes[cursor + 32])
	end
	if control["fresh_air_fan_speed_enable"] ~= nil and control["fresh_air_fan_speed"] ~= nil then
		bodyBytes[cursor + 33] = bit.bor(control["fresh_air_fan_speed"], bodyBytes[cursor + 33])
		bodyBytes[cursor + 33] = bit.bor(bit.lshift(control["fresh_air_fan_speed_enable"], 7), bodyBytes[cursor + 33])
	end
	if control["quick_prepare_food_angle_enable"] ~= nil and control["quick_prepare_food_angle"] ~= nil then
		bodyBytes[cursor + 34] = bit.bor(control["quick_prepare_food_angle"], bodyBytes[cursor + 34])
		bodyBytes[cursor + 34] =
			bit.bor(bit.lshift(control["quick_prepare_food_angle_enable"], 7), bodyBytes[cursor + 34])
	end
	bodyBytes[74] = makeSum(bodyBytes, 12, 74)
	return bodyBytes
end
function set_bit(bodyBytes, byteIndex, bitIndex, keyValue)
	bodyBytes[byteIndex] = bit.bor(bit.lshift(keyValue, bitIndex), bodyBytes[byteIndex])
end
function jsonToData(jsonCmd)
	if #jsonCmd == 0 then
		return nil
	end
	local infoM = {}
	local json = decode(jsonCmd)
	deviceSubType = json["deviceinfo"]["deviceSubType"]
	local deviceSN = json["deviceinfo"]["deviceSN"]
	if deviceSN ~= nil then
		deviceSN8 = string.sub(deviceSN, 4, 8)
	end
	local query = json["query"]
	local control = json["control"]
	local status = json["status"]
	keyP["timer_control"] = 0
	keyP["water_model_flag"] = 0
	keyP["PTCDependT4Value"] = 0
	keyP["humidity_drainage_flag"] = 0
	keyP["control_flag"] = 0
	keyP["smart_humi_control_algorithm"] = 0
	keyP["fresh_air_exhaust_wind"] = 0
	keyP["fresh_air_intake_wind"] = 0
	keyP["fg_timer_control"] = 0
	keyP["control_c006"] = 0
	keyP["fg_timer_number"] = 0
	keyP["single_control"] = 0
	keyP["new_wind_single_control"] = 0
	keyP["network_sn"] = nil
	keyP["c002_dry_type_support"] = 0
	keyP["dry_type_control"] = 0
	keyP["f8_control"] = 0
	keyP["control_c004"] = 0
	if query then
		local queryType = nil
		if type(query) == "table" then
			queryType = query["query_type"]
		end
		if queryType == "run_status" then
			infoM = getTotalMsgNew(nil, keyB["BYTE_QUERY_RUN_REQUEST"], 0x01)
		elseif queryType == "run_status_2" then
			infoM = getTotalMsgNew(nil, keyB["BYTE_QUERY_RUN_REQUEST"], 0x02)
		elseif queryType == "out_run_status" then
			infoM = getTotalMsg(nil, keyB["BYTE_QUERY_OUT_RUN_REQUEST"])
		elseif queryType == "water_model_run_status" then
			infoM = getTotalMsg(nil, keyB["BYTE_QUERY_WATER_RUN_REQUEST"])
		elseif queryType == "timer_query" then
			infoM = getTotalMsg(nil, 0x13)
		elseif queryType == "fg_timer_query" then
			infoM = getTotalMsg(nil, 0x14)
		elseif queryType == "4c_query" then
			infoM = getTotalMsg(nil, 0x4c)
		elseif queryType == "15_query" then
			infoM = getTotalMsg(nil, 0x15)
		elseif queryType == "15_query_2" then
			infoM = get15Msg(nil, 0x15)
		elseif queryType == "51_query" then
			infoM = getTotalMsg(nil, 0x51)
		elseif queryType == "31_query" then
			infoM = getTotalMsg(nil, 0x31)
		elseif queryType == "c002_query" or queryType == "c006_query" or queryType == "c003_query" then
			local bodyBytes = {}
			for i = 0, 3 do
				bodyBytes[i] = 0
			end
			bodyBytes[0] = keyP["pack_id"]
			bodyBytes[1] = 0x01
			bodyBytes[2] = 0xC0
			if queryType == "c002_query" then
				bodyBytes[3] = 0x02
			elseif queryType == "c006_query" then
				bodyBytes[3] = 0x06
			elseif queryType == "c003_query" then
				bodyBytes[3] = 0x03
			end
			infoM = getTotalMsgC002(bodyBytes, 0xC0)
		else
			infoM = getTotalMsg(nil, keyB["BYTE_QUERYL_REQUEST"])
		end
	elseif control then
		if status then
			JsonToModel(status, "status")
		end
		if control then
			JsonToModel(control, "control")
		end
		if keyP["dry_type_control"] == 1 then
			if keyP["c002_dry_type_support"] == 1 then
				keyP["single_control"] = 1
			else
				keyP["single_control"] = 0
			end
		end
		for k, v in pairs(c004Status) do
			if control[k] then
				keyP["control_c004"] = 1
			end
		end
		if
			keyP["filterTimeReset"] == 0x01
			or keyP["purifyFilterTimeReset"] == 0x01
			or keyP["freshFilterTimeReset"] == 0x01
		then
			local bodyBytes = {}
			for i = 0, 1 do
				bodyBytes[i] = 0
			end
			bodyBytes[0] = bit.bor(bit.lshift(keyP["filterTimeReset"], 6), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["purifyFilterTimeReset"], 7), bodyBytes[0])
			bodyBytes[1] = bit.bor(keyP["freshFilterTimeReset"], bodyBytes[1])
			infoM = getTotalMsg(bodyBytes, keyB["BYTE_CONTROL_RESET_REQUEST"])
			keyP["filterTimeReset"] = 0
			keyP["purifyFilterTimeReset"] = 0
			keyP["freshFilterTimeReset"] = 0
			local ret = table2string(infoM)
			ret = string2hexstring(ret)
			return ret
		end
		if keyP["network_sn"] ~= nil then
			dataList = string2tableSingle(keyP["network_sn"])
			local bodyBytes = {}
			bodyBytes[0] = 0x0C
			bodyBytes[1] = 0x00
			bodyBytes[2] = 0x20
			for i = 1, #dataList do
				bodyBytes[2 + i] = string.byte(dataList[i])
			end
			infoM = getAcMsgNetwork(bodyBytes)
			local ret = table2string(infoM)
			ret = string2hexstring(ret)
			return ret
		end
		local bodyBytes = {}
		for i = 0, 89 do
			bodyBytes[i] = 0
		end
		if keyP["humidity_drainage_flag"] == 1 then
			bodyBytes[1] = bit.bor(bit.lshift(keyP["humidity_drainage"], 5), bodyBytes[1])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["purifier_odor_filter_reset"], 2), bodyBytes[2])
			infoM = getTotalMsg(bodyBytes, 0xAB)
		elseif keyP["f8_control"] ~= 0 then
			print("f8_contro000000")
			if keyP["f8_control"] == 1 then
				local dataMsg = keyP["timestamp"]
				local dataList = {}
				if string.match(dataMsg, ",") == "," then
					dataList = splitStrByChar(dataMsg, ",")
				else
					table.insert(dataList, dataMsg)
				end
				bodyBytes[0] = 0x11
				bodyBytes[1] = 0x01
				bodyBytes[2] = 0x1A
				bodyBytes[3] = bit.band(bit.rshift(keyP["f8_temperature"], 8), 0xff)
				bodyBytes[4] = bit.band(keyP["f8_temperature"], 0xff)
				bodyBytes[5] = bit.band(bit.rshift(keyP["f8_humidity"], 8), 0xff)
				bodyBytes[6] = bit.band(keyP["f8_humidity"], 0xff)
				bodyBytes[7] = bit.band(bit.rshift(keyP["f8_tvoc"], 8), 0xff)
				bodyBytes[8] = bit.band(keyP["f8_tvoc"], 0xff)
				bodyBytes[9] = bit.band(bit.rshift(keyP["f8_pm25_value"], 8), 0xff)
				bodyBytes[10] = bit.band(keyP["f8_pm25_value"], 0xff)
				bodyBytes[11] = bit.band(bit.rshift(keyP["f8_co2_value"], 8), 0xff)
				bodyBytes[12] = bit.band(keyP["f8_co2_value"], 0xff)
				bodyBytes[13] = bit.band(bit.rshift(keyP["f8_arofene"], 8), 0xff)
				bodyBytes[14] = bit.band(keyP["f8_arofene"], 0xff)
				bodyBytes[15] = bit.band(bit.rshift(keyP["sensor_status"], 8), 0xff)
				bodyBytes[16] = bit.band(keyP["sensor_status"], 0xff)
				bodyBytes[17] = tonumber(dataList[1], 10)
				bodyBytes[18] = tonumber(dataList[2], 10)
				bodyBytes[19] = tonumber(dataList[3], 10)
				bodyBytes[20] = tonumber(dataList[4], 10)
				bodyBytes[21] = tonumber(dataList[5], 10)
				bodyBytes[22] = tonumber(dataList[6], 10)
				bodyBytes[23] = tonumber(dataList[7], 10)
				bodyBytes[24] = tonumber(dataList[8], 10)
				bodyBytes[25] = bit.band(bit.rshift(keyP["offset"], 24), 0xff)
				bodyBytes[26] = bit.band(bit.rshift(keyP["offset"], 16), 0xff)
				bodyBytes[27] = bit.band(bit.rshift(keyP["offset"], 8), 0xff)
				bodyBytes[28] = bit.band(keyP["offset"], 0xff)
				infoM = getTotalMsg(bodyBytes, 0xF8)
			end
			if keyP["f8_control"] == 4 then
				local dataMsg = keyP["mac_value"]
				local dataList = {}
				if string.match(dataMsg, ",") == "," then
					dataList = splitStrByChar(dataMsg, ",")
				else
					table.insert(dataList, dataMsg)
				end
				bodyBytes[0] = 0x11
				bodyBytes[1] = 0x04
				bodyBytes[2] = 0x29
				bodyBytes[3] = keyP["binding_status"]
				bodyBytes[4] = keyP["binding_type"]
				bodyBytes[5] = tonumber(dataList[1], 16)
				bodyBytes[6] = tonumber(dataList[2], 16)
				bodyBytes[7] = tonumber(dataList[3], 16)
				bodyBytes[8] = tonumber(dataList[4], 16)
				bodyBytes[9] = tonumber(dataList[5], 16)
				bodyBytes[10] = tonumber(dataList[6], 16)
				bodyBytes[11] = keyP["has_sn"]
				for i = 0, 31 do
					bodyBytes[12 + i] = string.byte(keyP["magic_cube_sn"], i + 1)
				end
				infoM = getTotalMsg(bodyBytes, 0xF8)
			end
			if keyP["f8_control"] == 5 then
				bodyBytes[0] = 0x11
				bodyBytes[1] = 0x05
				bodyBytes[2] = 0x0C
				for i = 0, 12 do
					bodyBytes[3 + i] = 0
				end
				infoM = getTotalMsg(bodyBytes, 0xF8)
			end
		elseif keyP["control_flag"] == 4 then
			bodyBytes[0] = 0x01
			bodyBytes[1] = 0x04
			bodyBytes[2] = 0x00
			bodyBytes[3] = 0x01
			bodyBytes[4] = keyP["smart_humi_control"]
			infoM = getTotalMsg(bodyBytes, 0xF1)
		elseif keyP["control_c006"] == 1 then
			local bodyBytes = {}
			for i = 0, 33 do
				bodyBytes[i] = 0
			end
			bodyBytes[0] = keyP["pack_id"]
			bodyBytes[1] = 1
			bodyBytes[2] = 1
			bodyBytes[3] = 0
			bodyBytes[4] = 0
			bodyBytes[5] = 0
			bodyBytes[6] = 0
			bodyBytes[7] = 0
			bodyBytes[8] = 0
			bodyBytes[9] = 0
			bodyBytes[10] = 0
			bodyBytes[11] = 0x01
			bodyBytes[12] = 0xC0
			bodyBytes[13] = 0x06
			bodyBytes[14] = 0x16
			bodyBytes[15] = 1
			bodyBytes[16] = bit.bor(keyP["indoor_machine_one_speed"], bodyBytes[5])
			bodyBytes[16] = bit.bor(bit.lshift(keyP["indoor_machine_two_speed"], 1), bodyBytes[5])
			bodyBytes[16] = bit.bor(bit.lshift(keyP["indoor_elec_expansion_valve_one"], 2), bodyBytes[16])
			bodyBytes[16] = bit.bor(bit.lshift(keyP["indoor_elec_expansion_valve_two"], 3), bodyBytes[16])
			bodyBytes[16] = bit.bor(bit.lshift(keyP["in_water_pump_force"], 4), bodyBytes[16])
			bodyBytes[16] = bit.bor(bit.lshift(keyP["out_water_pump_force"], 5), bodyBytes[16])
			bodyBytes[16] = bit.bor(bit.lshift(keyP["ptc_support_force"], 6), bodyBytes[16])
			bodyBytes[16] = bit.bor(bit.lshift(keyP["energy_need_c0"], 7), bodyBytes[16])
			bodyBytes[17] = bit.bor(keyP["indoor_lr_wind_angle"], bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["indoor_ud_wind_angle"], 1), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["fengguan_one_speed_enable"], 2), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["fengguan_two_speed_enable"], 3), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["new_wind_two_speed_enable"], 4), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["new_wind_one_speed_enable"], 5), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["new_wind_model_gate"], 6), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["remove_odor_c0"], 7), bodyBytes[17])
			bodyBytes[19] = bit.band(keyP["force_wind_machine_one_speed"], 0xFF)
			bodyBytes[20] = bit.band(bit.rshift(keyP["force_wind_machine_one_speed"], 8), 0xFF)
			bodyBytes[21] = bit.band(keyP["force_wind_machine_two_speed"], 0xFF)
			bodyBytes[22] = bit.band(bit.rshift(keyP["force_wind_machine_two_speed"], 8), 0xFF)
			bodyBytes[23] = bit.band(keyP["force_expansion_valve_one_speed"], 0xFF)
			bodyBytes[24] = bit.band(bit.rshift(keyP["force_expansion_valve_one_speed"], 8), 0xFF)
			bodyBytes[25] = bit.band(keyP["force_expansion_valve_two_speed"], 0xFF)
			bodyBytes[26] = bit.band(bit.rshift(keyP["force_expansion_valve_two_speed"], 8), 0xFF)
			bodyBytes[27] = bit.bor(keyP["in_water_pump"], bodyBytes[27])
			bodyBytes[27] = bit.bor(bit.lshift(keyP["out_water_pump"], 1), bodyBytes[27])
			bodyBytes[27] = bit.bor(bit.lshift(keyP["ptc_support"], 2), bodyBytes[27])
			bodyBytes[28] = keyP["wind_swing_lr_c0"]
			bodyBytes[29] = keyP["wind_swing_ud_c0"]
			bodyBytes[30] = keyP["indoor_energy_need"]
			bodyBytes[31] = keyP["fengguan_indoor_one_speed_level"]
			bodyBytes[32] = keyP["fengguan_indoor_two_speed_level"]
			bodyBytes[33] = makeSum(bodyBytes, 11, 32)
			infoM = getTotalMsgC006(bodyBytes, 0xC0)
		elseif keyP["fg_timer_number"] ~= 0 then
			local bodyBytes = {}
			for i = 0, 12 do
				bodyBytes[i] = 0
			end
			bodyBytes[0] = keyP["fg_timer_number"]
			bodyBytes[1] = bit.bor(keyP["fg_timer1_week0_effect"], bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["fg_timer1_week1_effect"], 1), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["fg_timer1_week2_effect"], 2), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["fg_timer1_week3_effect"], 3), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["fg_timer1_week4_effect"], 4), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["fg_timer1_week5_effect"], 5), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["fg_timer1_week6_effect"], 6), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["fg_timer1_select"], 7), bodyBytes[1])
			bodyBytes[2] = bit.bor(keyP["fg_timer1_wind_speed"], bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["fg_timer1_power"], 7), bodyBytes[2])
			bodyBytes[3] = bit.bor(keyP["fg_timer1_mode"], bodyBytes[3])
			bodyBytes[4] = bit.bor((keyP["fg_timer1_temperature"] * 2), bodyBytes[4])
			bodyBytes[5] = bit.bor(keyP["fg_timer1_hour"], bodyBytes[5])
			bodyBytes[6] = bit.bor(keyP["fg_timer1_min"], bodyBytes[6])
			bodyBytes[7] = bit.bor(keyP["fg_timer2_week0_effect"], bodyBytes[7])
			bodyBytes[7] = bit.bor(bit.lshift(keyP["fg_timer2_week1_effect"], 1), bodyBytes[7])
			bodyBytes[7] = bit.bor(bit.lshift(keyP["fg_timer2_week2_effect"], 2), bodyBytes[7])
			bodyBytes[7] = bit.bor(bit.lshift(keyP["fg_timer2_week3_effect"], 3), bodyBytes[7])
			bodyBytes[7] = bit.bor(bit.lshift(keyP["fg_timer2_week4_effect"], 4), bodyBytes[7])
			bodyBytes[7] = bit.bor(bit.lshift(keyP["fg_timer2_week5_effect"], 5), bodyBytes[7])
			bodyBytes[7] = bit.bor(bit.lshift(keyP["fg_timer2_week6_effect"], 6), bodyBytes[7])
			bodyBytes[7] = bit.bor(bit.lshift(keyP["fg_timer2_select"], 7), bodyBytes[7])
			bodyBytes[8] = bit.bor(keyP["fg_timer2_wind_speed"], bodyBytes[8])
			bodyBytes[8] = bit.bor(bit.lshift(keyP["fg_timer2_power"], 7), bodyBytes[8])
			bodyBytes[9] = bit.bor(keyP["fg_timer2_mode"], bodyBytes[9])
			bodyBytes[10] = bit.bor((keyP["fg_timer2_temperature"] * 2), bodyBytes[10])
			bodyBytes[11] = bit.bor(keyP["fg_timer2_hour"], bodyBytes[11])
			bodyBytes[12] = bit.bor(keyP["fg_timer2_min"], bodyBytes[12])
			infoM = getTotalMsg(bodyBytes, 0x22)
		elseif keyP["timer_control"] == 1 then
			for i = 0, 181 do
				bodyBytes[i] = 0
			end
			bodyBytes[0] = bit.bor(keyP["week0_timer1"], bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["week0_timer2"], 1), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["week0_timer3"], 2), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["week0_timer4"], 3), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["week0_timer5"], 4), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["week0_duplicate_timer_on_1"], 5), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["week0_duplicate_timer_off_2"], 6), bodyBytes[0])
			bodyBytes[1] = bit.bor(keyP["week1_timer1"], bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["week1_timer2"], 1), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["week1_timer3"], 2), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["week1_timer4"], 3), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["week1_timer5"], 4), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["week1_duplicate_timer_on_1"], 5), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["week1_duplicate_timer_off_2"], 6), bodyBytes[1])
			bodyBytes[2] = bit.bor(keyP["week2_timer1"], bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["week2_timer2"], 1), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["week2_timer3"], 2), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["week2_timer4"], 3), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["week2_timer5"], 4), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["week2_duplicate_timer_on_1"], 5), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["week2_duplicate_timer_off_2"], 6), bodyBytes[2])
			bodyBytes[3] = bit.bor(keyP["week3_timer1"], bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["week3_timer2"], 1), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["week3_timer3"], 2), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["week3_timer4"], 3), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["week3_timer5"], 4), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["week3_duplicate_timer_on_1"], 5), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["week3_duplicate_timer_off_2"], 6), bodyBytes[3])
			bodyBytes[4] = bit.bor(keyP["week4_timer1"], bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["week4_timer2"], 1), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["week4_timer3"], 2), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["week4_timer4"], 3), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["week4_timer5"], 4), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["week4_duplicate_timer_on_1"], 5), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["week4_duplicate_timer_off_2"], 6), bodyBytes[4])
			bodyBytes[5] = bit.bor(keyP["week5_timer1"], bodyBytes[5])
			bodyBytes[5] = bit.bor(bit.lshift(keyP["week5_timer2"], 1), bodyBytes[5])
			bodyBytes[5] = bit.bor(bit.lshift(keyP["week5_timer3"], 2), bodyBytes[5])
			bodyBytes[5] = bit.bor(bit.lshift(keyP["week5_timer4"], 3), bodyBytes[5])
			bodyBytes[5] = bit.bor(bit.lshift(keyP["week5_timer5"], 4), bodyBytes[5])
			bodyBytes[5] = bit.bor(bit.lshift(keyP["week5_duplicate_timer_on_1"], 5), bodyBytes[5])
			bodyBytes[5] = bit.bor(bit.lshift(keyP["week5_duplicate_timer_off_2"], 6), bodyBytes[5])
			bodyBytes[6] = bit.bor(keyP["week6_timer1"], bodyBytes[6])
			bodyBytes[6] = bit.bor(bit.lshift(keyP["week6_timer2"], 1), bodyBytes[6])
			bodyBytes[6] = bit.bor(bit.lshift(keyP["week6_timer3"], 2), bodyBytes[6])
			bodyBytes[6] = bit.bor(bit.lshift(keyP["week6_timer4"], 3), bodyBytes[6])
			bodyBytes[6] = bit.bor(bit.lshift(keyP["week6_timer5"], 4), bodyBytes[6])
			bodyBytes[6] = bit.bor(bit.lshift(keyP["week6_duplicate_timer_on_1"], 5), bodyBytes[6])
			bodyBytes[6] = bit.bor(bit.lshift(keyP["week6_duplicate_timer_off_2"], 6), bodyBytes[6])
			bodyBytes[7] = keyP["week0_timer1_open_hour"]
			bodyBytes[8] = keyP["week0_timer1_open_min"]
			bodyBytes[9] = keyP["week0_timer1_close_hour"]
			bodyBytes[10] = keyP["week0_timer1_close_min"]
			bodyBytes[11] = keyP["week0_timer1_temperature"] * 2 + 50
			bodyBytes[12] = keyP["week0_timer2_open_hour"]
			bodyBytes[13] = keyP["week0_timer2_open_min"]
			bodyBytes[14] = keyP["week0_timer2_close_hour"]
			bodyBytes[15] = keyP["week0_timer2_close_min"]
			bodyBytes[16] = keyP["week0_timer2_temperature"] * 2 + 50
			bodyBytes[17] = keyP["week0_timer3_open_hour"]
			bodyBytes[18] = keyP["week0_timer3_open_min"]
			bodyBytes[19] = keyP["week0_timer3_close_hour"]
			bodyBytes[20] = keyP["week0_timer3_close_min"]
			bodyBytes[21] = keyP["week0_timer3_temperature"] * 2 + 50
			bodyBytes[22] = keyP["week0_timer4_open_hour"]
			bodyBytes[23] = keyP["week0_timer4_open_min"]
			bodyBytes[24] = keyP["week0_timer4_close_hour"]
			bodyBytes[25] = keyP["week0_timer4_close_min"]
			bodyBytes[26] = keyP["week0_timer4_temperature"] * 2 + 50
			bodyBytes[27] = keyP["week0_timer5_open_hour"]
			bodyBytes[28] = keyP["week0_timer5_open_min"]
			bodyBytes[29] = keyP["week0_timer5_close_hour"]
			bodyBytes[30] = keyP["week0_timer5_close_min"]
			bodyBytes[31] = keyP["week0_timer5_temperature"] * 2 + 50
			bodyBytes[32] = keyP["week1_timer1_open_hour"]
			bodyBytes[33] = keyP["week1_timer1_open_min"]
			bodyBytes[34] = keyP["week1_timer1_close_hour"]
			bodyBytes[35] = keyP["week1_timer1_close_min"]
			bodyBytes[36] = keyP["week1_timer1_temperature"] * 2 + 50
			bodyBytes[37] = keyP["week1_timer2_open_hour"]
			bodyBytes[38] = keyP["week1_timer2_open_min"]
			bodyBytes[39] = keyP["week1_timer2_close_hour"]
			bodyBytes[40] = keyP["week1_timer2_close_min"]
			bodyBytes[41] = keyP["week1_timer2_temperature"] * 2 + 50
			bodyBytes[42] = keyP["week1_timer3_open_hour"]
			bodyBytes[43] = keyP["week1_timer3_open_min"]
			bodyBytes[44] = keyP["week1_timer3_close_hour"]
			bodyBytes[45] = keyP["week1_timer3_close_min"]
			bodyBytes[46] = keyP["week1_timer3_temperature"] * 2 + 50
			bodyBytes[47] = keyP["week1_timer4_open_hour"]
			bodyBytes[48] = keyP["week1_timer4_open_min"]
			bodyBytes[49] = keyP["week1_timer4_close_hour"]
			bodyBytes[50] = keyP["week1_timer4_close_min"]
			bodyBytes[51] = keyP["week1_timer4_temperature"] * 2 + 50
			bodyBytes[52] = keyP["week1_timer5_open_hour"]
			bodyBytes[53] = keyP["week1_timer5_open_min"]
			bodyBytes[54] = keyP["week1_timer5_close_hour"]
			bodyBytes[55] = keyP["week1_timer5_close_min"]
			bodyBytes[56] = keyP["week1_timer5_temperature"] * 2 + 50
			bodyBytes[57] = keyP["week2_timer1_open_hour"]
			bodyBytes[58] = keyP["week2_timer1_open_min"]
			bodyBytes[59] = keyP["week2_timer1_close_hour"]
			bodyBytes[60] = keyP["week2_timer1_close_min"]
			bodyBytes[61] = keyP["week2_timer1_temperature"] * 2 + 50
			bodyBytes[62] = keyP["week2_timer2_open_hour"]
			bodyBytes[63] = keyP["week2_timer2_open_min"]
			bodyBytes[64] = keyP["week2_timer2_close_hour"]
			bodyBytes[65] = keyP["week2_timer2_close_min"]
			bodyBytes[66] = keyP["week2_timer2_temperature"] * 2 + 50
			bodyBytes[67] = keyP["week2_timer3_open_hour"]
			bodyBytes[68] = keyP["week2_timer3_open_min"]
			bodyBytes[69] = keyP["week2_timer3_close_hour"]
			bodyBytes[70] = keyP["week2_timer3_close_min"]
			bodyBytes[71] = keyP["week2_timer3_temperature"] * 2 + 50
			bodyBytes[72] = keyP["week2_timer4_open_hour"]
			bodyBytes[73] = keyP["week2_timer4_open_min"]
			bodyBytes[74] = keyP["week2_timer4_close_hour"]
			bodyBytes[75] = keyP["week2_timer4_close_min"]
			bodyBytes[76] = keyP["week2_timer4_temperature"] * 2 + 50
			bodyBytes[77] = keyP["week2_timer5_open_hour"]
			bodyBytes[78] = keyP["week2_timer5_open_min"]
			bodyBytes[79] = keyP["week2_timer5_close_hour"]
			bodyBytes[80] = keyP["week2_timer5_close_min"]
			bodyBytes[81] = keyP["week2_timer5_temperature"] * 2 + 50
			bodyBytes[82] = keyP["week3_timer1_open_hour"]
			bodyBytes[83] = keyP["week3_timer1_open_min"]
			bodyBytes[84] = keyP["week3_timer1_close_hour"]
			bodyBytes[85] = keyP["week3_timer1_close_min"]
			bodyBytes[86] = keyP["week3_timer1_temperature"] * 2 + 50
			bodyBytes[87] = keyP["week3_timer2_open_hour"]
			bodyBytes[88] = keyP["week3_timer2_open_min"]
			bodyBytes[89] = keyP["week3_timer2_close_hour"]
			bodyBytes[90] = keyP["week3_timer2_close_min"]
			bodyBytes[91] = keyP["week3_timer2_temperature"] * 2 + 50
			bodyBytes[92] = keyP["week3_timer3_open_hour"]
			bodyBytes[93] = keyP["week3_timer3_open_min"]
			bodyBytes[94] = keyP["week3_timer3_close_hour"]
			bodyBytes[95] = keyP["week3_timer3_close_min"]
			bodyBytes[96] = keyP["week3_timer3_temperature"] * 2 + 50
			bodyBytes[97] = keyP["week3_timer4_open_hour"]
			bodyBytes[98] = keyP["week3_timer4_open_min"]
			bodyBytes[99] = keyP["week3_timer4_close_hour"]
			bodyBytes[100] = keyP["week3_timer4_close_min"]
			bodyBytes[101] = keyP["week3_timer4_temperature"] * 2 + 50
			bodyBytes[102] = keyP["week3_timer5_open_hour"]
			bodyBytes[103] = keyP["week3_timer5_open_min"]
			bodyBytes[104] = keyP["week3_timer5_close_hour"]
			bodyBytes[105] = keyP["week3_timer5_close_min"]
			bodyBytes[106] = keyP["week3_timer5_temperature"] * 2 + 50
			bodyBytes[107] = keyP["week4_timer1_open_hour"]
			bodyBytes[108] = keyP["week4_timer1_open_min"]
			bodyBytes[109] = keyP["week4_timer1_close_hour"]
			bodyBytes[110] = keyP["week4_timer1_close_min"]
			bodyBytes[111] = keyP["week4_timer1_temperature"] * 2 + 50
			bodyBytes[112] = keyP["week4_timer2_open_hour"]
			bodyBytes[113] = keyP["week4_timer2_open_min"]
			bodyBytes[114] = keyP["week4_timer2_close_hour"]
			bodyBytes[115] = keyP["week4_timer2_close_min"]
			bodyBytes[116] = keyP["week4_timer2_temperature"] * 2 + 50
			bodyBytes[117] = keyP["week4_timer3_open_hour"]
			bodyBytes[118] = keyP["week4_timer3_open_min"]
			bodyBytes[119] = keyP["week4_timer3_close_hour"]
			bodyBytes[120] = keyP["week4_timer3_close_min"]
			bodyBytes[121] = keyP["week4_timer3_temperature"] * 2 + 50
			bodyBytes[122] = keyP["week4_timer4_open_hour"]
			bodyBytes[123] = keyP["week4_timer4_open_min"]
			bodyBytes[124] = keyP["week4_timer4_close_hour"]
			bodyBytes[125] = keyP["week4_timer4_close_min"]
			bodyBytes[126] = keyP["week4_timer4_temperature"] * 2 + 50
			bodyBytes[127] = keyP["week4_timer5_open_hour"]
			bodyBytes[128] = keyP["week4_timer5_open_min"]
			bodyBytes[129] = keyP["week4_timer5_close_hour"]
			bodyBytes[130] = keyP["week4_timer5_close_min"]
			bodyBytes[131] = keyP["week4_timer5_temperature"] * 2 + 50
			bodyBytes[132] = keyP["week5_timer1_open_hour"]
			bodyBytes[133] = keyP["week5_timer1_open_min"]
			bodyBytes[134] = keyP["week5_timer1_close_hour"]
			bodyBytes[135] = keyP["week5_timer1_close_min"]
			bodyBytes[136] = keyP["week5_timer1_temperature"] * 2 + 50
			bodyBytes[137] = keyP["week5_timer2_open_hour"]
			bodyBytes[138] = keyP["week5_timer2_open_min"]
			bodyBytes[139] = keyP["week5_timer2_close_hour"]
			bodyBytes[140] = keyP["week5_timer2_close_min"]
			bodyBytes[141] = keyP["week5_timer2_temperature"] * 2 + 50
			bodyBytes[142] = keyP["week5_timer3_open_hour"]
			bodyBytes[143] = keyP["week5_timer3_open_min"]
			bodyBytes[144] = keyP["week5_timer3_close_hour"]
			bodyBytes[145] = keyP["week5_timer3_close_min"]
			bodyBytes[146] = keyP["week5_timer3_temperature"] * 2 + 50
			bodyBytes[147] = keyP["week5_timer4_open_hour"]
			bodyBytes[148] = keyP["week5_timer4_open_min"]
			bodyBytes[149] = keyP["week5_timer4_close_hour"]
			bodyBytes[150] = keyP["week5_timer4_close_min"]
			bodyBytes[151] = keyP["week5_timer4_temperature"] * 2 + 50
			bodyBytes[152] = keyP["week5_timer5_open_hour"]
			bodyBytes[153] = keyP["week5_timer5_open_min"]
			bodyBytes[154] = keyP["week5_timer5_close_hour"]
			bodyBytes[155] = keyP["week5_timer5_close_min"]
			bodyBytes[156] = keyP["week5_timer5_temperature"] * 2 + 50
			bodyBytes[157] = keyP["week6_timer1_open_hour"]
			bodyBytes[158] = keyP["week6_timer1_open_min"]
			bodyBytes[159] = keyP["week6_timer1_close_hour"]
			bodyBytes[160] = keyP["week6_timer1_close_min"]
			bodyBytes[161] = keyP["week6_timer1_temperature"] * 2 + 50
			bodyBytes[162] = keyP["week6_timer2_open_hour"]
			bodyBytes[163] = keyP["week6_timer2_open_min"]
			bodyBytes[164] = keyP["week6_timer2_close_hour"]
			bodyBytes[165] = keyP["week6_timer2_close_min"]
			bodyBytes[166] = keyP["week6_timer2_temperature"] * 2 + 50
			bodyBytes[167] = keyP["week6_timer3_open_hour"]
			bodyBytes[168] = keyP["week6_timer3_open_min"]
			bodyBytes[169] = keyP["week6_timer3_close_hour"]
			bodyBytes[170] = keyP["week6_timer3_close_min"]
			bodyBytes[171] = keyP["week6_timer3_temperature"] * 2 + 50
			bodyBytes[172] = keyP["week6_timer4_open_hour"]
			bodyBytes[173] = keyP["week6_timer4_open_min"]
			bodyBytes[174] = keyP["week6_timer4_close_hour"]
			bodyBytes[175] = keyP["week6_timer4_close_min"]
			bodyBytes[176] = keyP["week6_timer4_temperature"] * 2 + 50
			bodyBytes[177] = keyP["week6_timer5_open_hour"]
			bodyBytes[178] = keyP["week6_timer5_open_min"]
			bodyBytes[179] = keyP["week6_timer5_close_hour"]
			bodyBytes[180] = keyP["week6_timer5_close_min"]
			bodyBytes[181] = keyP["week6_timer5_temperature"] * 2 + 50
			infoM = getTotalMsg(bodyBytes, 0x21)
		elseif keyP["single_control"] == 1 then
			local bodyBytes = {}
			bodyBytes = c002_jsonToDataTemp(control, status)
			infoM = getTotalMsgC006(bodyBytes, 0xC0)
			local ret = table2string(infoM)
			ret = string2hexstring(ret)
			return ret
		elseif keyP["new_wind_single_control"] == 1 then
			local bodyBytes = {}
			print("进新风机控制")
			bodyBytes = c003_jsonToData(control, status)
			infoM = getTotalMsgC006(bodyBytes, 0xC0)
			local ret = table2string(infoM)
			ret = string2hexstring(ret)
			return ret
		elseif keyP["has_care_mode"] == 1 and keyP["control_c004"] == 1 then
			local bodyBytes = {}
			bodyBytes = c004_jsonToData(control, status)
			infoM = getTotalMsgC006(bodyBytes, 0xC0)
			local ret = table2string(infoM)
			ret = string2hexstring(ret)
			return ret
		else
			bodyBytes[0] = bit.bor(keyP["powerValue"], bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["standby_clean"], 1), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["no_wind_sense"], 3), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["dryValue"], 4), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["strongWindValue"], 5), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["manulNewWind"], 6), bodyBytes[0])
			bodyBytes[0] = bit.bor(bit.lshift(keyP["autoNewWind"], 7), bodyBytes[0])
			bodyBytes[1] = bit.bor(keyP["swingLeftUDValue"], bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["swingRightUDValue"], 1), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["swingUpLRValue"], 2), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["swingDownLRValue"], 3), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["forceCoolMode"], 4), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["forceAutoMode"], 5), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["PTCValue"], 6), bodyBytes[1])
			bodyBytes[1] = bit.bor(bit.lshift(keyP["PTCDependT4Value"], 7), bodyBytes[1])
			bodyBytes[2] = bit.bor(keyP["cool_hot_sense"], bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["preventCold"], 1), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["wind_straight"], 2), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["wind_avoid"], 3), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["disinfect"], 4), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["elecDustRemove"], 5), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["self_clean"], 6), bodyBytes[2])
			bodyBytes[2] = bit.bor(bit.lshift(keyP["energySaveValue"], 7), bodyBytes[2])
			bodyBytes[3] = bit.bor(keyP["air_optimization"], bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["nobody_energy_save"], 1), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["autoPurify"], 2), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["manuPurify"], 3), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["no_wind_sense_mode"], 4), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["run_test"], 6), bodyBytes[3])
			bodyBytes[3] = bit.bor(bit.lshift(keyP["fast_check"], 7), bodyBytes[3])
			bodyBytes[4] = bit.bor(keyP["autoHumi"], bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["manuHumi"], 1), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["wind_strength"], 2), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["new_wind_machine"], 3), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["new_wind_machine_link"], 4), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["project_evacuate"], 5), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["follow_body_sense"], 6), bodyBytes[4])
			bodyBytes[4] = bit.bor(bit.lshift(keyP["exhaust_strength"], 7), bodyBytes[4])
			bodyBytes[5] = keyP["modeValue"]
			bodyBytes[6] = (keyP["temperature"] + keyP["small_temperature"]) * 2 + 30
			bodyBytes[7] = keyP["fanspeedValue"]
			bodyBytes[8] = keyP["dehumidityValue"]
			bodyBytes[9] = keyP["pm25LowValue"]
			bodyBytes[10] = keyP["pm25HighValue"]
			bodyBytes[11] = keyP["co2LowValue"]
			bodyBytes[12] = keyP["co2HighValue"]
			bodyBytes[13] = keyP["humidityValue"]
			bodyBytes[15] = keyP["newWindModeValue"]
			bodyBytes[16] = keyP["newWindSpeedValue"]
			bodyBytes[17] = bit.bor(keyP["water_model_power"], bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["water_model_power_save"], 1), bodyBytes[17])
			if keyP["water_model_clean"] == 1 and keyP["water_model_power"] == 1 and keyP["water_model_flag"] == 2 then
				keyP["water_model_clean"] = 0
			end
			bodyBytes[17] = bit.bor(bit.lshift(keyP["water_model_clean"], 2), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["water_model_temperature_auto"], 3), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["water_model_ptc"], 4), bodyBytes[17])
			bodyBytes[17] = bit.bor(bit.lshift(keyP["water_model_go_out"], 7), bodyBytes[17])
			bodyBytes[18] = keyP["water_mode"]
			bodyBytes[19] = keyP["water_model_temperature_set"] * 2 + 50
			bodyBytes[20] = 0
			bodyBytes[21] = keyP["air_optimization_temperature"] * 2 + 30
			bodyBytes[22] = keyP["air_optimization_humidity"]
			bodyBytes[23] = keyP["air_optimization_wind"]
			bodyBytes[25] = keyP["comfortableSleepValue"]
			bodyBytes[25] = bit.bor(bit.lshift(keyP["stop_warm"], 3), bodyBytes[25])
			bodyBytes[25] = bit.bor(bit.lshift(keyP["eco"], 6), bodyBytes[25])
			bodyBytes[25] = bit.bor(bit.lshift(keyP["prevent_super_cool"], 7), bodyBytes[25])
			bodyBytes[25] = bit.bor(keyP["power_on_timer"], bodyBytes[25])
			bodyBytes[25] = bit.bor(bit.lshift(keyP["power_off_timer"], 1), bodyBytes[25])
			bodyBytes[25] = bit.bor(bit.lshift(keyP["timer_enable"], 2), bodyBytes[25])
			bodyBytes[26] = bit.band(keyP["power_on_time_value"], 0xFF)
			bodyBytes[27] = bit.band(keyP["power_off_time_value"], 0xFF)
			bodyBytes[28] = bit.bor(bit.rshift(keyP["power_on_time_value"], 8), bodyBytes[28])
			bodyBytes[28] = bit.bor(bit.lshift(bit.rshift(keyP["power_off_time_value"], 8), 4), bodyBytes[28])
			bodyBytes[29] = bit.bor(keyP["up_down_wind_direction"], bodyBytes[29])
			bodyBytes[29] = bit.bor(bit.lshift(keyP["left_right_wind_direction"], 4), bodyBytes[29])
			bodyBytes[36] = 0x08
			bodyBytes[36] = bit.bor(bit.lshift(keyP["fresh_air_remove_odor"], 7), bodyBytes[36])
			bodyBytes[37] = bit.bor(keyP["dry_type"], bodyBytes[37])
			bodyBytes[37] = bit.bor(bit.lshift(keyP["total_time_support"], 2), bodyBytes[37])
			bodyBytes[37] = bit.bor(bit.lshift(keyP["airoptimization_or_total_time"], 3), bodyBytes[37])
			bodyBytes[37] = bit.bor(bit.lshift(keyP["total_time_switch"], 4), bodyBytes[37])
			bodyBytes[37] = bit.bor(bit.lshift(keyP["remove_arofene"], 5), bodyBytes[37])
			bodyBytes[37] = bit.bor(bit.lshift(keyP["voice_control"], 6), bodyBytes[37])
			bodyBytes[37] = bit.bor(bit.lshift(keyP["voice_control_speaking"], 7), bodyBytes[37])
			bodyBytes[38] = bit.bor(keyP["fengguan_remove_odor"], bodyBytes[38])
			bodyBytes[38] = bit.bor(bit.lshift(keyP["support_magic_cube"], 1), bodyBytes[38])
			bodyBytes[38] = bit.bor(bit.lshift(keyP["timer_announcement"], 2), bodyBytes[38])
			bodyBytes[38] = bit.bor(bit.lshift(keyP["new_home_remove_arofene"], 3), bodyBytes[38])
			bodyBytes[38] = bit.bor(bit.lshift(keyP["new_home_remove_arofene_exit"], 4), bodyBytes[38])
			bodyBytes[38] = bit.bor(bit.lshift(keyP["energy_new_wind"], 6), bodyBytes[38])
			bodyBytes[38] = bit.bor(bit.lshift(keyP["smart_humi_control_algorithm"], 7), bodyBytes[38])
			bodyBytes[39] = bit.band(keyP["shortest_remove_odor_time"], 0xFF)
			bodyBytes[40] = bit.band(bit.rshift(keyP["shortest_remove_odor_time"], 8), 0xFF)
			bodyBytes[41] = bit.band(keyP["longest_remove_odor_time"], 0xFF)
			bodyBytes[42] = bit.band(bit.rshift(keyP["longest_remove_odor_time"], 8), 0xFF)
			bodyBytes[43] = keyP["fresh_air_intake_wind"]
			bodyBytes[44] = keyP["fresh_air_exhaust_wind"]
			bodyBytes[45] = bit.bor(keyP["new_wind_model_intake_switch"], bodyBytes[45])
			bodyBytes[45] = bit.bor(bit.lshift(keyP["new_wind_model_exhaust_switch"], 1), bodyBytes[45])
			bodyBytes[45] = bit.bor(bit.lshift(keyP["new_wind_model_mute"], 2), bodyBytes[45])
			bodyBytes[45] = bit.bor(bit.lshift(keyP["tube_protect"], 3), bodyBytes[45])
			bodyBytes[45] = bit.bor(bit.lshift(keyP["new_wind_model_on_timer"], 4), bodyBytes[45])
			bodyBytes[45] = bit.bor(bit.lshift(keyP["new_wind_model_off_timer"], 5), bodyBytes[45])
			bodyBytes[45] = bit.bor(bit.lshift(keyP["new_wind_model_timer_effect"], 6), bodyBytes[45])
			bodyBytes[45] = bit.bor(bit.lshift(keyP["female_care"], 7), bodyBytes[45])
			bodyBytes[46] = keyP["new_wind_model_intake_wind"]
			bodyBytes[47] = keyP["new_wind_model_exhaust_wind"]
			bodyBytes[48] = bit.band(keyP["new_wind_model_on_timer_value"], 0xFF)
			bodyBytes[49] = bit.band(keyP["new_wind_model_off_timer_value"], 0xFF)
			bodyBytes[50] = bit.bor(bit.rshift(keyP["new_wind_model_on_timer_value"], 8), bodyBytes[50])
			bodyBytes[50] = bit.bor(bit.lshift(bit.rshift(keyP["new_wind_model_off_timer_value"], 8), 4), bodyBytes[50])
			if keyP["comfortableSleepValue"] == 0x30 and comfortByte ~= nil then
				bodyBytes[30] = bit.bor(
					checkBoundary(comfortByte[1], 16, 30) - 16,
					bit.lshift((checkBoundary(comfortByte[2], 16, 30) - 16), 4)
				)
				bodyBytes[31] = bit.bor(
					checkBoundary(comfortByte[3], 16, 30) - 16,
					bit.lshift((checkBoundary(comfortByte[4], 16, 30) - 16), 4)
				)
				bodyBytes[32] =
					bit.bor(checkBoundary(comfortByte[5], 16, 30) - 16, bit.lshift((comfortByte[6] - 16), 4))
				bodyBytes[33] =
					bit.bor(checkBoundary(comfortByte[7], 16, 30) - 16, bit.lshift((comfortByte[8] - 16), 4))
				bodyBytes[34] =
					bit.bor(checkBoundary(comfortByte[9], 16, 30) - 16, bit.lshift((comfortByte[10] - 16), 4))
			end
			bodyBytes[51] = keyP["pack_id"]
			bodyBytes[52] = bit.bor(keyP["has_heater"], bodyBytes[52])
			bodyBytes[52] = bit.bor(bit.lshift(keyP["has_shunt_valve"], 1), bodyBytes[52])
			bodyBytes[52] = bit.bor(bit.lshift(keyP["heater_heating_switch"], 2), bodyBytes[52])
			bodyBytes[52] = bit.bor(bit.lshift(keyP["stop_warm_support"], 3), bodyBytes[52])
			bodyBytes[52] = bit.bor(bit.lshift(keyP["water_temp_linkage_support"], 4), bodyBytes[52])
			bodyBytes[52] = bit.bor(bit.lshift(keyP["water_temp_linkage_switch"], 5), bodyBytes[52])
			bodyBytes[52] = bit.bor(bit.lshift(keyP["water_model_dry"], 6), bodyBytes[52])
			bodyBytes[53] = bit.bor(keyP["water_model_force_temp"], bodyBytes[53])
			bodyBytes[53] = bit.bor(bit.lshift(keyP["smart_water_model"], 7), bodyBytes[53])
			bodyBytes[55] = bit.band(keyP["save_energy_mode_effective_countdown"], 0x0F)
			bodyBytes[55] = bit.bor(bit.lshift(keyP["nobody_off_switch"], 4), bodyBytes[55])
			bodyBytes[56] = bit.band(bit.rshift(keyP["save_energy_mode_effective_countdown"], 4), 0x7F)
			bodyBytes[56] =
				bit.bor(bit.lshift(keyP["save_energy_mode_effective_countdown_setting_enable"], 7), bodyBytes[56])
			bodyBytes[57] = bit.bor(keyP["nobody_off_switch_setting_enable"], bodyBytes[57])
			bodyBytes[57] = bit.bor(bit.lshift(keyP["nobody_off_time_setting_enable"], 1), bodyBytes[57])
			bodyBytes[57] = bit.bor(bit.lshift(keyP["nobody_off_time"], 2), bodyBytes[57])
			bodyBytes[55] = bit.bor(bit.lshift(keyP["follow_body_sense_enable"], 7), bodyBytes[55])
			bodyBytes[62] = bit.bor(keyP["fresh_air_intake_fan_speed"], bodyBytes[62])
			bodyBytes[63] = bit.bor(keyP["fresh_air_exhaust_fan_speed"], bodyBytes[63])
			bodyBytes[65] = bit.bor(keyP["double_engine_heat"], bodyBytes[65])
			bodyBytes[65] = bit.bor(bit.lshift(keyP["double_engine_heat_enable"], 1), bodyBytes[65])
			bodyBytes[65] = bit.bor(bit.lshift(keyP["smart_hybird"], 2), bodyBytes[65])
			bodyBytes[65] = bit.bor(bit.lshift(keyP["smart_hybird_enable"], 3), bodyBytes[65])
			bodyBytes[65] = bit.bor(bit.lshift(keyP["smart_hybird_pause"], 4), bodyBytes[65])
			bodyBytes[69] = bit.bor(keyP["remote_switch"], bodyBytes[69])
			bodyBytes[69] = bit.bor(bit.lshift(keyP["prevent_straight_wind_enable"], 1), bodyBytes[69])
			bodyBytes[69] = bit.bor(bit.lshift(keyP["prevent_straight_wind"], 2), bodyBytes[69])
			bodyBytes[69] = bit.bor(bit.lshift(keyP["independent_swing_enable"], 3), bodyBytes[69])
			bodyBytes[69] = bit.bor(bit.lshift(keyP["up_swing"], 4), bodyBytes[69])
			bodyBytes[69] = bit.bor(bit.lshift(keyP["right_swing"], 5), bodyBytes[69])
			bodyBytes[69] = bit.bor(bit.lshift(keyP["down_swing"], 6), bodyBytes[69])
			bodyBytes[69] = bit.bor(bit.lshift(keyP["left_swing"], 7), bodyBytes[69])
			bodyBytes[70] = bit.bor(keyP["up_swing_angle"], bodyBytes[70])
			bodyBytes[70] = bit.bor(bit.lshift(keyP["right_swing_angle"], 4), bodyBytes[70])
			bodyBytes[71] = bit.bor(keyP["down_swing_angle"], bodyBytes[71])
			bodyBytes[71] = bit.bor(bit.lshift(keyP["left_swing_angle"], 4), bodyBytes[71])
			bodyBytes[76] = bit.bor(bit.lshift(keyP["ieco_enable"], 2), bodyBytes[76])
			bodyBytes[76] = bit.bor(bit.lshift(keyP["ieco_switch"], 5), bodyBytes[76])
			bodyBytes[76] = bit.bor(bit.lshift(keyP["ieco_strong_wind"], 3), bodyBytes[76])
			bodyBytes[77] = bit.bor(keyP["ieco_indoor_wind_speed_level"], bodyBytes[77])
			bodyBytes[79] = bit.band(keyP["ieco_target_rate"], 0xFF)
			bodyBytes[78] = bit.band(bit.rshift(keyP["ieco_target_rate"], 8), 0xFF)
			bodyBytes[80] = bit.bor(bit.lshift(keyP["mode_memory_enable"], 1), bodyBytes[80])
			bodyBytes[81] = bit.bor(bit.lshift(keyP["smart_frequency_conversion"], 2), bodyBytes[81])
			bodyBytes[81] = bit.bor(bit.lshift(keyP["ai_humidity_control"], 3), bodyBytes[81])
			bodyBytes[81] = bit.bor(bit.lshift(keyP["ptc_mode"], 6), bodyBytes[81])
			bodyBytes[82] = bit.bor(bit.lshift(keyP["power_tip_light_switch"], 4), bodyBytes[82])
			bodyBytes[84] = bit.bor(keyP["human_close_gentle_wind"], bodyBytes[84])
			bodyBytes[84] = bit.bor(bit.lshift(keyP["smart_wind"], 1), bodyBytes[84])
			bodyBytes[84] = bit.bor(bit.lshift(keyP["power_off_mode_enable_switch"], 2), bodyBytes[84])
			bodyBytes[84] = bit.bor(bit.lshift(keyP["remote_receive_switch"], 3), bodyBytes[84])
			bodyBytes[85] = bit.bor(keyP["smart_wind_sensitivity"], bodyBytes[85])
			infoM = getTotalMsg(bodyBytes, keyB["BYTE_CONTROL_REQUEST"])
		end
	end
	local ret = table2string(infoM)
	ret = string2hexstring(ret)
	return ret
end
function dataToJson(jsonCmd)
	if not jsonCmd then
		return nil
	end
	init_keyP()
	radar_init()
	local json = decode(jsonCmd)
	local deviceinfo = json["deviceinfo"]
	deviceSubType = deviceinfo["deviceSubType"]
	local deviceSN = json["deviceinfo"]["deviceSN"]
	if deviceSN ~= nil then
		deviceSN8 = string.sub(deviceSN, 4, 8)
	end
	local status = json["status"]
	if status then
		JsonToModel(status, "status")
	end
	local binData = json["msg"]["data"]
	local info = {}
	local acInfo = {}
	local msgBytes = {}
	local bodyBytes = {}
	local msgLength = 0
	local bodyLength = 0
	acInfo = string2table(binData)
	local infoLenth = 0
	infoLenth = acInfo[2] - 10 - 2
	for k = 1, infoLenth do
		info[k] = acInfo[k + 10]
	end
	for i = 1, #info do
		msgBytes[i - 1] = info[i]
	end
	dataType = info[6]
	msgLength = msgBytes[1]
	bodyLength = msgLength - keyB["BYTE_PROTOCOL_LENGTH"] - 1
	for i = 0, bodyLength do
		bodyBytes[i] = msgBytes[i + keyB["BYTE_PROTOCOL_LENGTH"]]
	end
	binToModel(bodyBytes)
	local streams = {}
	streams[keyT["KEY_VERSION"]] = keyV["VALUE_VERSION"]
	streams["protocol_type"] = "jz"
	if
		dataType == 0x20
		or dataType == 0x11
		or dataType == 0xF1
		or (dataType == 0xC0 and (bodyBytes[3] == 0x02 or bodyBytes[3] == 0x03))
	then
		if keyP["powerValue"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_POWER"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["powerValue"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_POWER"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["standby_clean"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_STANDBY_CLEAN"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["standby_clean"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_STANDBY_CLEAN"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["no_wind_sense"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_NOWINDSENSE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["no_wind_sense"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_NOWINDSENSE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["dryValue"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_DRY"]] = keyV["VALUE_FUNCTION_ON"]
		else
			streams[keyT["KEY_DRY"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["strongWindValue"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_STRONG_WIND"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["strongWindValue"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_STRONG_WIND"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["manulNewWind"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_MANUL_NEWWIND"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["manulNewWind"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_MANUL_NEWWIND"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["autoNewWind"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_AUTO_NEWWIND"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["autoNewWind"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_AUTO_NEWWIND"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["swingLeftUDValue"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_SWING_UD"]] = keyV["VALUE_FUNCTION_OFF"]
		else
			streams[keyT["KEY_SWING_UD"]] = keyV["VALUE_FUNCTION_ON"]
		end
		if keyP["swingUpLRValue"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_SWING_LR"]] = keyV["VALUE_FUNCTION_OFF"]
		else
			streams[keyT["KEY_SWING_LR"]] = keyV["VALUE_FUNCTION_ON"]
		end
		if keyP["forceCoolMode"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_FORCE_COOL_MODE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["forceCoolMode"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_FORCE_COOL_MODE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["forceAutoMode"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_FORCE_AUTO_MODE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["forceAutoMode"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_FORCE_AUTO_MODE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["PTCValue"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_PTC"]] = keyV["VALUE_FUNCTION_ON"]
		else
			streams[keyT["KEY_PTC"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["cool_hot_sense"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_COOL_HOT_SENSE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["cool_hot_sense"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_COOL_HOT_SENSE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["preventCold"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_PREVENT_COLD"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["preventCold"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_PREVENT_COLD"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["wind_straight"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WIND_STRAIGHT"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["wind_straight"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WIND_STRAIGHT"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["wind_avoid"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WIND_AVOID"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["wind_avoid"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WIND_AVOID"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["disinfect"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_DISINFECT"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["disinfect"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_DISINFECT"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["elecDustRemove"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_ELEC_DUST_REMOVE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["elecDustRemove"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_ELEC_DUST_REMOVE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["self_clean"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_SELFCLEAN"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["self_clean"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_SELFCLEAN"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["energySaveValue"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_ENERGY_SAVE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["energySaveValue"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_ENERGY_SAVE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["air_optimization"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_AIR_OPTIMIZATION"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["air_optimization"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_AIR_OPTIMIZATION"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["nobody_energy_save"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_NOBODY_ENERGY_SAVE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["nobody_energy_save"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_NOBODY_ENERGY_SAVE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["autoPurify"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_AUTO_PURIFY"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["autoPurify"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_AUTO_PURIFY"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["manuPurify"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_MANUL_PURIFY"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["manuPurify"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_MANUL_PURIFY"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["no_wind_sense_mode"] ~= nil then
			streams[keyT["KEY_NO_WIND_SENSE_MODE"]] = keyP["no_wind_sense_mode"]
		end
		if keyP["run_test"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_RUN_TEST"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["run_test"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_RUN_TEST"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["fast_check"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_FAST_CHECK"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["fast_check"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_FAST_CHECK"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["autoHumi"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_AUTO_HUMI"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["autoHumi"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_AUTO_HUMI"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["manuHumi"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_MANUL_HUMI"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["manuHumi"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_MANUL_HUMI"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["wind_strength"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WIND_STRENGTH"]] = 0x01
		elseif keyP["wind_strength"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WIND_STRENGTH"]] = 0x00
		end
		if keyP["new_wind_machine"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_NEW_WIND_MACHINE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["new_wind_machine"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_NEW_WIND_MACHINE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["new_wind_machine_link"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_NEW_WIND_MACHINE_LINK"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["new_wind_machine_link"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_NEW_WIND_MACHINE_LINK"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["project_evacuate"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_PROJECT_EVACUATE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["project_evacuate"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_PROJECT_EVACUATE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["follow_body_sense"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_FOLLOW_BODY_SENSE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["follow_body_sense"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_FOLLOW_BODY_SENSE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["exhaust_strength"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_EXHAUST_STRENGTH"]] = 0x01
		elseif keyP["exhaust_strength"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_EXHAUST_STRENGTH"]] = 0x00
		end
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
		elseif keyP["modeValue"] == keyB["BYTE_MODE_STANDBY"] then
			streams[keyT["KEY_MODE"]] = keyV["VALUE_MODE_STANDBY"]
		elseif keyP["modeValue"] == keyB["BYTE_MODE_DRYCONSTANT"] then
			streams[keyT["KEY_MODE"]] = keyV["VALUE_MODE_DRYCONSTANT"]
		elseif keyP["modeValue"] == keyB["BYTE_MODE_DRYAUTO"] then
			streams[keyT["KEY_MODE"]] = keyV["VALUE_MODE_DRYAUTO"]
		end
		streams[keyT["KEY_TEMPERATURE"]] = keyP["temperature"]
		streams["small_temperature"] = keyP["small_temperature"]
		streams[keyT["KEY_FANSPEED"]] = keyP["fanspeedValue"]
		streams[keyT["KEY_DEHUMIDITY"]] = keyP["deHumidityValue"]
		streams[keyT["KEY_PM25"]] = keyP["pm25HighValue"] * 256 + keyP["pm25LowValue"]
		streams[keyT["KEY_CO2"]] = keyP["co2HighValue"] * 256 + keyP["co2LowValue"]
		streams[keyT["KEY_HUMIDITY"]] = keyP["humidityValue"]
		streams[keyT["KEY_NEWWIND_MODE"]] = keyP["newWindModeValue"]
		streams[keyT["KEY_NEWWIND_FANSPEED"]] = keyP["newWindSpeedValue"]
		if keyP["comfortableSleepValue"] ~= nil then
			if keyP["comfortableSleepValue"] == 0x00 then
				streams["comfort_sleep"] = "off"
			elseif keyP["comfortableSleepValue"] == 0x30 then
				streams["comfort_sleep"] = "on"
			end
		end
		if keyP["water_model_power"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WATER_MODEL_POWER"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["water_model_power"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WATER_MODEL_POWER"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["water_model_power_save"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WATER_MODEL_POWER_SAVE"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["water_model_power_save"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WATER_MODEL_POWER_SAVE"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["water_model_clean"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WATER_MODEL_CLEAN"]] = keyV["VALUE_FUNCTION_ON"]
			keyP["water_model_flag"] = keyP["water_model_flag"] + 1
			print("hello2")
		elseif keyP["water_model_clean"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WATER_MODEL_CLEAN"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["water_model_temperature_auto"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WATER_MODEL_TEMPERATURE_AUTO"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["water_model_temperature_auto"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WATER_MODEL_TEMPERATURE_AUTO"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["water_model_ptc"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WATER_MODEL_PTC"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["water_model_ptc"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WATER_MODEL_PTC"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["water_model_go_out"] == keyB["BYTE_COMMON_ON"] then
			streams[keyT["KEY_WATER_MODEL_GO_OUT"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["water_model_go_out"] == keyB["BYTE_COMMON_OFF"] then
			streams[keyT["KEY_WATER_MODEL_GO_OUT"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		streams[keyT["KEY_WATER_MODEL_TEMPERATURE_SET"]] = keyP["water_model_temperature_set"]
		streams[keyT["KEY_HAS_HUIFENG"]] = keyP["has_huifeng"]
		streams[keyT["KEY_HAS_CHUFENG"]] = keyP["has_chufeng"]
		streams[keyT["KEY_HAS_WIND_LR"]] = keyP["has_wind_lr"]
		streams[keyT["KEY_HAS_NO_WIND_SENSE"]] = keyP["has_no_wind_sense"]
		streams[keyT["KEY_HAS_XINFENG"]] = keyP["has_xinfeng"]
		streams[keyT["KEY_HAS_HUMIDIFER"]] = keyP["has_humidifer"]
		streams[keyT["KEY_HAS_WATER_MODEL"]] = keyP["has_water_model"]
		streams[keyT["KEY_AIR_OPTIMIZATION_TEMPERATURE"]] = keyP["air_optimization_temperature"]
		streams[keyT["KEY_AIR_OPTIMIZATION_HUMIDITY"]] = keyP["air_optimization_humidity"]
		streams[keyT["KEY_AIR_OPTIMIZATION_WIND"]] = keyP["air_optimization_wind"]
		if keyP["power_on_timer"] == 0x01 then
			streams[keyT["KEY_POWER_ON_TIMER"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["power_on_timer"] == 0x00 then
			streams[keyT["KEY_POWER_ON_TIMER"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		if keyP["power_off_timer"] == 0x01 then
			streams[keyT["KEY_POWER_OFF_TIMER"]] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["power_off_timer"] == 0x00 then
			streams[keyT["KEY_POWER_OFF_TIMER"]] = keyV["VALUE_FUNCTION_OFF"]
		end
		streams["timer_enable"] = keyP["timer_enable"]
		streams[keyT["KEY_OPEN_TIME"]] = keyP["power_on_time_value"]
		streams[keyT["KEY_CLOSE_TIME"]] = keyP["power_off_time_value"]
		streams["left_right_wind_direction"] = keyP["left_right_wind_direction"]
		streams["up_down_wind_direction"] = keyP["up_down_wind_direction"]
		if keyP["stop_warm"] == 0x01 then
			streams["stop_warm"] = keyV["VALUE_FUNCTION_ON"]
		elseif keyP["stop_warm"] == 0x00 then
			streams["stop_warm"] = keyV["VALUE_FUNCTION_OFF"]
		end
		streams["water_mode"] = keyP["water_mode"]
		streams["eco"] = keyP["eco"]
		streams["prevent_super_cool"] = keyP["prevent_super_cool"]
		streams["fresh_air_remove_odor"] = keyP["fresh_air_remove_odor"]
		streams["dry_type"] = keyP["dry_type"]
		streams["inner_cycle_mode"] = keyP["inner_cycle_mode"]
		streams["inner_cycle_switch"] = keyP["inner_cycle_switch"]
		streams["airoptimization_or_total_time"] = keyP["airoptimization_or_total_time"]
		streams["total_time_switch"] = keyP["total_time_switch"]
		streams["total_time_support"] = keyP["total_time_support"]
		streams["remove_arofene"] = keyP["remove_arofene"]
		streams["voice_control"] = keyP["voice_control"]
		streams["voice_control_speaking"] = keyP["voice_control_speaking"]
		streams["fengguan_remove_odor"] = keyP["fengguan_remove_odor"]
		streams["support_magic_cube"] = keyP["support_magic_cube"]
		streams["new_home_remove_arofene"] = keyP["new_home_remove_arofene"]
		streams["new_home_remove_arofene_exit"] = keyP["new_home_remove_arofene_exit"]
		streams["shortest_remove_odor_time"] = keyP["shortest_remove_odor_time"]
		streams["longest_remove_odor_time"] = keyP["longest_remove_odor_time"]
		streams["smart_humi_control_algorithm"] = keyP["smart_humi_control_algorithm"]
		streams["fresh_air_exhaust_wind"] = keyP["fresh_air_exhaust_wind"]
		streams["fresh_air_intake_wind"] = keyP["fresh_air_intake_wind"]
		streams["fengguan_has_water_timer_right"] = keyP["fengguan_has_water_timer_right"]
		streams["new_wind_model_timer_effect"] = keyP["new_wind_model_timer_effect"]
		streams["new_wind_model_intake_switch"] = keyP["new_wind_model_intake_switch"]
		streams["new_wind_model_exhaust_switch"] = keyP["new_wind_model_exhaust_switch"]
		streams["new_wind_model_mute"] = keyP["new_wind_model_mute"]
		streams["tube_protect"] = keyP["tube_protect"]
		streams["new_wind_model_on_timer"] = keyP["new_wind_model_on_timer"]
		streams["new_wind_model_off_timer"] = keyP["new_wind_model_off_timer"]
		streams["new_wind_model_intake_wind"] = keyP["new_wind_model_intake_wind"]
		streams["new_wind_model_exhaust_wind"] = keyP["new_wind_model_exhaust_wind"]
		streams["new_wind_model_on_timer_value"] = keyP["new_wind_model_on_timer_value"]
		streams["new_wind_model_off_timer_value"] = keyP["new_wind_model_off_timer_value"]
		streams["energy_new_wind"] = keyP["energy_new_wind"]
		streams["female_care"] = keyP["female_care"]
		streams["has_heater"] = keyP["has_heater"]
		streams["has_shunt_valve"] = keyP["has_shunt_valve"]
		streams["heater_heating_switch"] = keyP["heater_heating_switch"]
		streams["airoptimization_unsupport"] = keyP["airoptimization_unsupport"]
		streams["stop_warm_support"] = keyP["stop_warm_support"]
		streams["water_temp_linkage_support"] = keyP["water_temp_linkage_support"]
		streams["water_temp_linkage_switch"] = keyP["water_temp_linkage_switch"]
		streams["water_model_dry"] = keyP["water_model_dry"]
		streams["water_model_force_temp"] = keyP["water_model_force_temp"]
		streams["smart_water_model"] = keyP["smart_water_model"]
		streams["save_energy_mode_effective_countdown"] = keyP["save_energy_mode_effective_countdown"]
		streams["nobody_off_switch"] = keyP["nobody_off_switch"]
		streams["nobody_off_time"] = keyP["nobody_off_time"]
		streams["has_quick_prepare_food_angle"] = keyP["has_quick_prepare_food_angle"]
		streams["has_prepare_food"] = keyP["has_prepare_food"]
		streams["has_quick_fry"] = keyP["has_quick_fry"]
		streams["prepare_food"] = keyP["prepare_food"]
		streams["quick_fry"] = keyP["quick_fry"]
		streams["new_wind_machine_exhaust_switch"] = keyP["new_wind_machine_exhaust_switch"]
		streams["new_wind_machine_intake_switch"] = keyP["new_wind_machine_intake_switch"]
		streams["fresh_air_exhaust_fan_speed"] = keyP["fresh_air_exhaust_fan_speed"]
		streams["fresh_air_intake_fan_speed"] = keyP["fresh_air_intake_fan_speed"]
		streams["has_new_wind_machine_exhaust_switch"] = keyP["has_new_wind_machine_exhaust_switch"]
		streams["has_new_wind_machine_intake_switch"] = keyP["has_new_wind_machine_intake_switch"]
		streams["new_wind_machine_type"] = keyP["new_wind_machine_type"]
		streams["fengguan_type"] = keyP["fengguan_type"]
		streams["quick_prepare_food_angle"] = keyP["quick_prepare_food_angle"]
		streams["has_follow_body_sense"] = keyP["has_follow_body_sense"]
		streams["double_engine_heat"] = keyP["double_engine_heat"]
		streams["has_double_engine_heat"] = keyP["has_double_engine_heat"]
		streams["smart_hybird"] = keyP["smart_hybird"]
		streams["has_smart_hybird"] = keyP["has_smart_hybird"]
		streams["smart_hybird_pause"] = keyP["smart_hybird_pause"]
		streams["c003_protocol_support"] = keyP["c003_protocol_support"]
		streams["c003_protocol_inner_support"] = keyP["c003_protocol_inner_support"]
		streams["no_wind_swing_ud_support"] = keyP["no_wind_swing_ud_support"]
		streams["independent_strong_support"] = keyP["independent_strong_support"]
		streams["keep_warm"] = keyP["keep_warm"]
		streams["has_keep_warm"] = keyP["has_keep_warm"]
		streams["fast_heat"] = keyP["fast_heat"]
		streams["has_fast_heat"] = keyP["has_fast_heat"]
		streams["ventilator"] = keyP["ventilator"]
		streams["ventilator_level"] = keyP["ventilator_level"]
		streams["has_ventilator"] = keyP["has_ventilator"]
		streams["fast_heat_angle"] = keyP["fast_heat_angle"]
		streams["has_fast_heat_angle"] = keyP["has_fast_heat_angle"]
		streams["close_huanqi_time"] = keyP["close_huanqi_time"]
		streams["has_close_huanqi_time"] = keyP["has_close_huanqi_time"]
		streams["close_huanqi_time_angle"] = keyP["close_huanqi_time_angle"]
		streams["target_temp_down"] = keyP["target_temp_down"]
		streams["target_temp_up"] = keyP["target_temp_up"]
		streams["mute"] = keyP["mute"]
		streams["remote_switch"] = keyP["remote_switch"]
		streams["has_prevent_straight_wind"] = keyP["has_prevent_straight_wind"]
		streams["prevent_straight_wind"] = keyP["prevent_straight_wind"]
		streams["has_independent_swing"] = keyP["has_independent_swing"]
		streams["up_swing"] = keyP["up_swing"]
		streams["down_swing"] = keyP["down_swing"]
		streams["left_swing"] = keyP["left_swing"]
		streams["right_swing"] = keyP["right_swing"]
		streams["up_swing_angle"] = keyP["up_swing_angle"]
		streams["down_swing_angle"] = keyP["down_swing_angle"]
		streams["left_swing_angle"] = keyP["left_swing_angle"]
		streams["right_swing_angle"] = keyP["right_swing_angle"]
		streams["mode_select"] = keyP["mode_select"]
		streams["has_dryconstant"] = keyP["has_dryconstant"]
		streams["has_smart_dry"] = keyP["has_smart_dry"]
		streams["has_dryauto"] = keyP["has_dryauto"]
		streams["has_individual_dry"] = keyP["has_individual_dry"]
		streams["has_heat"] = keyP["has_heat"]
		streams["has_dry"] = keyP["has_dry"]
		streams["has_cool"] = keyP["has_cool"]
		streams["has_auto"] = keyP["has_auto"]
		streams["has_smart_mode"] = keyP["has_smart_mode"]
		streams["has_new_wind_huanqi"] = keyP["has_new_wind_huanqi"]
		streams["has_new_wind_humidity"] = keyP["has_new_wind_humidity"]
		streams["has_new_wind_dehumidity"] = keyP["has_new_wind_dehumidity"]
		streams["has_self_clean"] = keyP["has_self_clean"]
		streams["has_fan"] = keyP["has_fan"]
		streams["has_heat_change"] = keyP["has_heat_change"]
		streams["has_slow_wind"] = keyP["has_slow_wind"]
		streams["has_fast_wind"] = keyP["has_fast_wind"]
		streams["has_slow_exhaust_wind"] = keyP["has_slow_exhaust_wind"]
		streams["has_fast_exhaust_wind"] = keyP["has_fast_exhaust_wind"]
		streams["has_strong_mode"] = keyP["has_strong_mode"]
		streams["has_holiday_mode"] = keyP["has_holiday_mode"]
		streams["has_purifier_odor"] = keyP["has_purifier_odor"]
		streams["c002_dry_type_support"] = keyP["c002_dry_type_support"]
		streams["has_passive_remove_odor_model"] = keyP["has_passive_remove_odor_model"]
		streams["has_ieco"] = keyP["has_ieco"]
		streams["auto_mode_dry_support"] = keyP["auto_mode_dry_support"]
		streams["auto_mode_wind_support"] = keyP["auto_mode_wind_support"]
		streams["has_mode_memory"] = keyP["has_mode_memory"]
		streams["has_ptc_memory"] = keyP["has_ptc_memory"]
		streams["smart_frequency_conversion"] = keyP["smart_frequency_conversion"]
		streams["ai_humidity_control"] = keyP["ai_humidity_control"]
		streams["ptc_mode"] = keyP["ptc_mode"]
		streams["down_horizontal_wind_direction"] = keyP["down_horizontal_wind_direction"]
		streams["down_vertical_wind_direction"] = keyP["down_vertical_wind_direction"]
		streams["down_wind_swing_lr"] = keyP["down_wind_swing_lr"]
		streams["down_wind_swing_ud"] = keyP["down_wind_swing_ud"]
		streams["down_wind_switch"] = keyP["down_wind_switch"]
		streams["side_wind_switch"] = keyP["side_wind_switch"]
		streams["has_4c_query"] = keyP["has_4c_query"]
		streams["has_ai_humidity_control"] = keyP["has_ai_humidity_control"]
		streams["has_down_wind_swing_lr"] = keyP["has_down_wind_swing_lr"]
		streams["has_down_wind_swing_ud"] = keyP["has_down_wind_swing_ud"]
		streams["has_down_wind_switch"] = keyP["has_down_wind_switch"]
		streams["has_side_wind_switch"] = keyP["has_side_wind_switch"]
		streams["has_15_query"] = keyP["has_15_query"]
		streams["buzzer_control"] = keyP["buzzer_control"]
		streams["buzzer_off_status"] = keyP["buzzer_off_status"]
		streams["ieco_switch"] = keyP["ieco_switch"]
		streams["has_51_query"] = keyP["has_51_query"]
		streams["power_tip_light_switch"] = keyP["power_tip_light_switch"]
		streams["smart_wind"] = keyP["smart_wind"]
		streams["human_close_gentle_wind"] = keyP["human_close_gentle_wind"]
		streams["smart_wind_sensitivity"] = keyP["smart_wind_sensitivity"]
		streams["power_off_mode_enable_switch"] = keyP["power_off_mode_enable_switch"]
		streams["remote_receive_switch"] = keyP["remote_receive_switch"]
		streams["has_care_mode"] = keyP["has_care_mode"]
		streams["has_31_query"] = keyP["has_31_query"]
		streams["has_c004_control"] = keyP["has_c004_control"]
		streams["no_cool_hot_sense_support"] = keyP["no_cool_hot_sense_support"]
		streams["no_nobody_energy_save_support"] = keyP["no_nobody_energy_save_support"]
		streams["ai_energy_save"] = keyP["ai_energy_save"]
		streams["nobody_power_off_reduce_time_switch"] = keyP["nobody_power_off_reduce_time_switch"]
		if dataType == 0xC0 then
			streams["prepare_food"] = keyP["prepare_food"]
			streams["quick_fry"] = keyP["quick_fry"]
			streams["quick_prepare_food_angle"] = keyP["quick_prepare_food_angle"]
			streams["new_wind_machine_exhaust_switch"] = keyP["new_wind_machine_exhaust_switch"]
			streams["new_wind_machine_intake_switch"] = keyP["new_wind_machine_intake_switch"]
			streams["fresh_air_exhaust_fan_speed"] = keyP["fresh_air_exhaust_fan_speed"]
			streams["fresh_air_intake_fan_speed"] = keyP["fresh_air_intake_fan_speed"]
			streams["new_wind_machine_type"] = keyP["new_wind_machine_type"]
			streams["fresh_air_mode"] = keyP["fresh_air_mode"]
			streams["fresh_air_fan_speed"] = keyP["fresh_air_fan_speed"]
			streams["fengguan_type"] = keyP["fengguan_type"]
			streams["fresh_air_fan_speed"] = keyP["fresh_air_fan_speed"]
			streams["double_engine_heat"] = keyP["double_engine_heat"]
			streams["smart_hybird"] = keyP["smart_hybird"]
			streams["timer_announcement"] = keyP["timer_announcement"]
			streams["water_model_force_temp"] = keyP["water_model_force_temp"]
			streams["has_water_model_temperature_set"] = keyP["has_water_model_temperature_set"]
			streams["has_water_mode"] = keyP["has_water_mode"]
		end
		if dataType == 0x11 then
			streams["single_control"] = keyP["single_control"]
			streams["single_select"] = keyP["single_select"]
			streams["single_status"] = keyP["single_status"]
			streams["new_wind_single_control"] = keyP["new_wind_single_control"]
		end
	end
	if dataType == 0x10 then
		streams["run_mode"] = keyP["run_mode"]
		streams[keyT["KEY_FANSPEED_REAL"]] = keyP["fanspeedRealValue"]
		streams[keyT["KEY_INDOOR_TEMPERATURE"]] = keyP["indoorTemperature"]
		streams[keyT["KEY_INDOOR_PM24"]] = keyP["indoorPm25"]
		streams[keyT["KEY_INDOOR_CO2"]] = keyP["indoorCo2"]
		streams[keyT["KEY_INDOOR_TVOC"]] = keyP["indoorTvoc"]
		streams[keyT["KEY_INDOOR_HUMIDITY"]] = keyP["indoorHumidity"]
		streams["humidity_enabling"] = keyP["humidity_enabling"]
		streams[keyT["KEY_MODE_CLASH"]] = keyP["modeClashValue"]
		streams["refrigerant_leakage_fault"] = keyP["refrigerant_leakage_fault"]
		streams[keyT["KEY_FILTER_TIME"]] = keyP["filterTime"]
		streams[keyT["KEY_PURIFY_FILTER_TIME"]] = keyP["purifyFilterTime"]
		streams[keyT["KEY_FRESH_FILTER_TIME"]] = keyP["freshFilterTime"]
		streams[keyT["KEY_SELF_CLEAN_STATE"]] = keyP["selfCleanState"]
		streams[keyT["KEY_SELF_CLEAN_RUN_TIME"]] = keyP["selfCleanRunTime"]
		streams[keyT["KEY_FRESH_LEVEL"]] = keyP["freshLevel"]
		streams[keyT["KEY_PURIFIER_LEVEL"]] = keyP["purifierLevel"]
		streams[keyT["KEY_HUMIDITY_LEVEL"]] = keyP["humidityLevel"]
		streams[keyT["KEY_TEMPERATURE_LEVEL"]] = keyP["temperatureLevel"]
		streams[keyT["KEY_TOVC_LEVEL"]] = keyP["tvocLevel"]
		streams[keyT["KEY_TOTAL_AIR_LEVEL"]] = keyP["totalAirLevel"]
		streams[keyT["KEY_RETURN_AIR_PANEL_SELECT"]] = keyP["returnAirPanelSelect"]
		streams[keyT["KEY_AIR_PANEL_SELECT"]] = keyP["airPanelSelect"]
		streams[keyT["KEY_NO_WIND_SENSE_SELECT"]] = keyP["noWindSenseSelect"]
		streams[keyT["KEY_WIND_LEFT_RIGHT_SELECT"]] = keyP["windLeftRightSelect"]
		streams["sn8_string"] = keyP["sn8_string"]
		streams["has_purifier"] = keyP["has_purifier"]
		streams["humidifier_water_tank"] = keyP["humidifier_water_tank"]
		streams["auto_piping"] = keyP["auto_piping"]
		streams["force_drainage"] = keyP["force_drainage"]
		streams["prevent_condensation"] = keyP["prevent_condensation"]
		streams["water_tank_load"] = keyP["water_tank_load"]
		streams["humidifier_over_flow_protect"] = keyP["humidifier_over_flow_protect"]
		streams["heat_water_tank_protect"] = keyP["heat_water_tank_protect"]
		streams["voltage_protect"] = keyP["voltage_protect"]
		streams["ptc_protect"] = keyP["ptc_protect"]
		streams["electric_leakage_protect"] = keyP["electric_leakage_protect"]
		streams["machine_electric_protect"] = keyP["machine_electric_protect"]
		streams["relay_bonding_fault"] = keyP["relay_bonding_fault"]
		streams["humidifier_freezing_protect"] = keyP["humidifier_freezing_protect"]
		streams["error_linking_fault"] = keyP["error_linking_fault"]
		streams["zero_point_fault"] = keyP["zero_point_fault"]
		streams["humidity_sensor_lock"] = keyP["humidity_sensor_lock"]
		streams["drain_valve_leakage"] = keyP["drain_valve_leakage"]
		streams["hydrate_valve_leakage"] = keyP["hydrate_valve_leakage"]
		streams["linking_humidifier_address"] = keyP["linking_humidifier_address"]
		streams["humidifier_temp_low"] = keyP["humidifier_temp_low"]
		streams["humidifier_temp_high"] = keyP["humidifier_temp_high"]
		streams["humidity_sensor_fault"] = keyP["humidity_sensor_fault"]
		streams["humidifier_communicate_fault"] = keyP["humidifier_communicate_fault"]
		streams["humidifier_water_sensor_fault"] = keyP["humidifier_water_sensor_fault"]
		streams["pm_sensor_chosen"] = keyP["pm_sensor_chosen"]
		streams["co2_sensor_chosen"] = keyP["co2_sensor_chosen"]
		streams["tvoc_sensor_chosen"] = keyP["tvoc_sensor_chosen"]
		streams["pyroelectricity_sensor_chosen"] = keyP["pyroelectricity_sensor_chosen"]
		streams["thermopile_sensor_chosen"] = keyP["thermopile_sensor_chosen"]
		streams["colmo_in_machine"] = keyP["colmo_in_machine"]
		streams["has_eco"] = keyP["has_eco"]
		streams["has_prevent_super_cool"] = keyP["has_prevent_super_cool"]
		streams["ptc_status"] = keyP["ptc_status"]
		streams["has_remove_arofene"] = keyP["has_remove_arofene"]
		streams["has_voice_control"] = keyP["has_voice_control"]
		streams["machine_type"] = keyP["machine_type"]
		streams["has_common_remove_odor"] = keyP["has_common_remove_odor"]
		streams["has_fresh_air_link"] = keyP["has_fresh_air_link"]
		streams["has_ptc"] = keyP["has_ptc"]
		streams["has_weekly_timer"] = keyP["has_weekly_timer"]
		streams["has_new_home_remove_arofene"] = keyP["has_new_home_remove_arofene"]
		streams["remove_odor_run_time"] = keyP["remove_odor_run_time"]
		streams["has_smart_humi_control"] = keyP["has_smart_humi_control"]
		streams["new_wind_humidity"] = keyP["new_wind_humidity"]
		streams["new_wind_outdoor_temperature"] = keyP["new_wind_outdoor_temperature"]
		streams["has_personality_dry"] = keyP["has_personality_dry"]
		streams["has_comfort_dry"] = keyP["has_comfort_dry"]
		streams["has_new_wind_purifier"] = keyP["has_new_wind_purifier"]
		streams["has_exhaust_wind"] = keyP["has_exhaust_wind"]
		streams["has_tube_protect"] = keyP["has_tube_protect"]
		streams["target_machine_info"] = keyP["target_machine_info"]
		streams["has_fg_timer"] = keyP["has_fg_timer"]
		streams["smart_hybird_status"] = keyP["smart_hybird_status"]
		streams["double_engine_heat_status"] = keyP["double_engine_heat_status"]
		streams["radar_install_status"] = keyP["radar_install_status"]
		streams["radar_monitor_people_status_report"] = keyP["radar_monitor_people_status_report"]
		streams["nobody_off_status"] = keyP["nobody_off_status"]
		streams["machine_level"] = keyP["machine_level"]
		if keyP["target_machine_info"] ~= nil then
			if keyP["target_machine_info"] == 0x01 then
				streams["has_female_care"] = keyP["has_female_care"]
				streams["has_fengguan_mini_new_wind"] = keyP["has_fengguan_mini_new_wind"]
			end
			if keyP["target_machine_info"] == 0x02 then
				streams["defrosting_display"] = keyP["defrosting_display"]
				streams["has_mini_new_wind"] = keyP["has_mini_new_wind"]
			end
		end
		streams["new_wind_machine_operating_mode"] = keyP["new_wind_machine_operating_mode"]
		streams["special_machine_type"] = keyP["special_machine_type"]
		streams["purifier_odor_filter_time"] = keyP["purifier_odor_filter_time"]
		streams["indoor_return_panel_transport"] = keyP["indoor_return_panel_transport"]
		streams["indoor_outlet_panel_transport"] = keyP["indoor_outlet_panel_transport"]
		streams["indoor_pyroelectric_sensor"] = keyP["indoor_pyroelectric_sensor"]
		streams["tvoc_sensor"] = keyP["tvoc_sensor"]
		streams["sensor_t1"] = keyP["sensor_t1"]
		streams["sensor_t2"] = keyP["sensor_t2"]
		streams["sensor_t2b_indoor"] = keyP["sensor_t2b_indoor"]
		streams["indoor_fan_lose_speed"] = keyP["indoor_fan_lose_speed"]
		streams["indoor_hum_sensor"] = keyP["indoor_hum_sensor"]
		streams["indoor_e"] = keyP["indoor_e"]
		streams["indoor_e_parameter"] = keyP["indoor_e_parameter"]
		streams["ammeter"] = keyP["ammeter"]
		streams["co2_sensor"] = keyP["co2_sensor"]
		streams["mode_conflict"] = keyP["mode_conflict"]
		streams["prevent_cold_wind_protect"] = keyP["prevent_cold_wind_protect"]
		streams["sensor_t2c_indoor"] = keyP["sensor_t2c_indoor"]
		streams["sensor_t2d_indoor"] = keyP["sensor_t2d_indoor"]
		streams["sensor_t2a_indoor"] = keyP["sensor_t2a_indoor"]
		streams["evaporator_temp_high_protect"] = keyP["evaporator_temp_high_protect"]
		streams["evaporator_temp_fre_limit"] = keyP["evaporator_temp_fre_limit"]
		streams["new_wind_anti_condensation_protect"] = keyP["new_wind_anti_condensation_protect"]
		streams["new_wind_out_temp_low_protect"] = keyP["new_wind_out_temp_low_protect"]
		streams["new_wind_out_temp_high_protect"] = keyP["new_wind_out_temp_high_protect"]
		streams["new_wind_pm_high_protect"] = keyP["new_wind_pm_high_protect"]
		streams["new_wind_out_low_temp"] = keyP["new_wind_out_low_temp"]
		streams["new_wind_low_anti_condensation_protect"] = keyP["new_wind_low_anti_condensation_protect"]
		streams["new_wind_pm_high"] = keyP["new_wind_pm_high"]
		streams["indoor_smart_eye"] = keyP["indoor_smart_eye"]
		streams["new_wind_temp_sensor"] = keyP["new_wind_temp_sensor"]
		streams["new_wind_hum_sensor"] = keyP["new_wind_hum_sensor"]
		streams["new_wind_pm2_5_sensor"] = keyP["new_wind_pm2_5_sensor"]
		streams["indoor_new_wind_device"] = keyP["indoor_new_wind_device"]
		streams["outdoor_new_wind_device"] = keyP["outdoor_new_wind_device"]
		streams["water_full_protect"] = keyP["water_full_protect"]
		streams["in_out_transport"] = keyP["in_out_transport"]
		streams["has_stop_warm"] = keyP["has_stop_warm"]
		streams["water_full_fault"] = keyP["water_full_fault"]
		streams["auto_inner_cycle"] = keyP["auto_inner_cycle"]
		streams["anion_status"] = keyP["anion_status"]
		streams["has_inner_cycle"] = keyP["has_inner_cycle"]
		streams["has_remove_odor"] = keyP["has_remove_odor"]
		streams["wire_controller_indoor_transport_ten"] = keyP["wire_controller_indoor_transport_ten"]
		streams["total_elec"] = keyP["total_elec"]
		streams["new_wind_model_wind_machine_fault"] = keyP["new_wind_model_wind_machine_fault"]
		streams["new_wind_model_anti_condensation_protect"] = keyP["new_wind_model_anti_condensation_protect"]
		streams["new_wind_model_temp_low_protect"] = keyP["new_wind_model_temp_low_protect"]
		streams["new_wind_model_temp_high_protect"] = keyP["new_wind_model_temp_high_protect"]
		streams["new_wind_model_hum_sensor"] = keyP["new_wind_model_hum_sensor"]
		streams["new_wind_model_temp_sensor"] = keyP["new_wind_model_temp_sensor"]
		streams["new_wind_model_e_fault"] = keyP["new_wind_model_e_fault"]
		streams["new_wind_model_param_fault"] = keyP["new_wind_model_param_fault"]
		streams["new_wind_model_timer_effect"] = keyP["new_wind_model_timer_effect"]
		streams["new_wind_model_fresh_filter"] = keyP["new_wind_model_fresh_filter"]
		streams["energy_need"] = keyP["energy_need"]
		streams["temp_compensation"] = keyP["temp_compensation"]
		streams["no_wind_swing_ud"] = keyP["no_wind_swing_ud"]
		streams["t2_temp"] = keyP["t2_temp"]
		streams["t2b_temp"] = keyP["t2b_temp"]
		streams["inner_machine_type"] = keyP["inner_machine_type"]
		streams["humidity_switch_fault"] = keyP["humidity_switch_fault"]
		streams["huanqi_fault"] = keyP["huanqi_fault"]
	end
	if dataType == 0x12 then
		streams[keyT["KEY_WATER_MODEL_CLEAN_TIME"]] = keyP["water_model_clean_time"]
		streams["water_model_mode_clash"] = keyP["water_model_mode_clash"]
		streams["tr_out_fault"] = keyP["tr_out_fault"]
		streams["tr_in_fault"] = keyP["tr_in_fault"]
		streams["standby_anti_freezing_protection"] = keyP["standby_anti_freezing_protection"]
		streams["dc_pump_stall_protection"] = keyP["dc_pump_stall_protection"]
		streams["water_switch_fault"] = keyP["water_switch_fault"]
		streams["tw_in_fault"] = keyP["tw_in_fault"]
		streams["tw_out_fault"] = keyP["tw_out_fault"]
		streams["tw1_fault"] = keyP["tw1_fault"]
		streams["indoor_e_water_heat"] = keyP["indoor_e_water_heat"]
		streams["indoor_e_parameter_water_heat"] = keyP["indoor_e_parameter_water_heat"]
		streams["tw1b_fault"] = keyP["tw1b_fault"]
		streams["temp_sensor_drop_fault"] = keyP["temp_sensor_drop_fault"]
		streams["water_templow_protection"] = keyP["water_templow_protection"]
		streams["standby_anti_freezing_fault"] = keyP["standby_anti_freezing_fault"]
		streams["in_outdoor_fault"] = keyP["in_outdoor_fault"]
		streams["t2w_fault"] = keyP["t2w_fault"]
		streams["wire_controller_indoor_transport"] = keyP["wire_controller_indoor_transport"]
		streams["has_voice_control"] = keyP["has_voice_control"]
		streams["has_water_model_timer"] = keyP["has_water_model_timer"]
		streams["has_weekly_timer_water"] = keyP["has_weekly_timer_water"]
		streams["has_new_home_remove_arofene_water"] = keyP["has_new_home_remove_arofene_water"]
		streams["remove_odor_run_time"] = keyP["remove_odor_run_time"]
		streams["tw1_in_water_temp"] = keyP["tw1_in_water_temp"]
		streams["tw1_out_water_temp"] = keyP["tw1_out_water_temp"]
		streams["water_model_machine_level"] = keyP["water_model_machine_level"]
		streams["tw_out_water_temp"] = keyP["tw_out_water_temp"]
		streams["water_model_temperature_set_12"] = keyP["water_model_temperature_set_12"]
	end
	if dataType == 0x30 then
		streams[keyT["KEY_OUTDOOR_TEMPERATURE"]] = keyP["outdoorTemperature"]
		streams[keyT["KEY_FRESH_AIR_MACHINE_NUMBER"]] = keyP["freshAirMachineNumber"]
		streams[keyT["KEY_HUMIDITY_MACHINE_NUMBER"]] = keyP["humidityMachineNumber"]
		streams["outdoor_e"] = keyP["outdoor_e"]
		streams["sensor_t3"] = keyP["sensor_t3"]
		streams["sensor_t4"] = keyP["sensor_t4"]
		streams["sensor_tp"] = keyP["sensor_tp"]
		streams["sensor_refrigerant_pipe_temp"] = keyP["sensor_refrigerant_pipe_temp"]
		streams["out_voltage_project"] = keyP["out_voltage_project"]
		streams["compressor_temp_protect"] = keyP["compressor_temp_protect"]
		streams["out_main_drive_transport"] = keyP["out_main_drive_transport"]
		streams["compressor_current_circuit"] = keyP["compressor_current_circuit"]
		streams["compressor_start"] = keyP["compressor_start"]
		streams["phase_lost_protect"] = keyP["phase_lost_protect"]
		streams["compressor_zero_protect"] = keyP["compressor_zero_protect"]
		streams["out_341_sync"] = keyP["out_341_sync"]
		streams["compressor_lose_speed_protect"] = keyP["compressor_lose_speed_protect"]
		streams["compressor_position_protect"] = keyP["compressor_position_protect"]
		streams["compressor_over_current"] = keyP["compressor_over_current"]
		streams["outdoor_ipm"] = keyP["outdoor_ipm"]
		streams["out_current_protect"] = keyP["out_current_protect"]
		streams["refrigerant_tube_condensation"] = keyP["refrigerant_tube_condensation"]
		streams["exhaust_high_temp_fre_limit"] = keyP["exhaust_high_temp_fre_limit"]
		streams["compressor_high_temp_protect"] = keyP["compressor_high_temp_protect"]
		streams["condenser_high_temp_fre_limit"] = keyP["condenser_high_temp_fre_limit"]
		streams["grid_protect"] = keyP["grid_protect"]
		streams["system_pressure_high_fre_limit"] = keyP["system_pressure_high_fre_limit"]
		streams["system_pressure_high_protect"] = keyP["system_pressure_high_protect"]
		streams["system_pressure_low_fre_limit"] = keyP["system_pressure_low_fre_limit"]
		streams["system_pressure_low_protect"] = keyP["system_pressure_low_protect"]
		streams["voltage_fre_limit"] = keyP["voltage_fre_limit"]
		streams["current_fre_limit"] = keyP["current_fre_limit"]
		streams["pfc_switch_stop"] = keyP["pfc_switch_stop"]
		streams["pfc_fre_limit"] = keyP["pfc_fre_limit"]
		streams["sensor_high_pressure"] = keyP["sensor_high_pressure"]
		streams["sensor_low_pressure"] = keyP["sensor_low_pressure"]
		streams["sensor_inhale_temp"] = keyP["sensor_inhale_temp"]
		streams["sensor_cold_temp"] = keyP["sensor_cold_temp"]
		streams["sensor_refrigerant_pipe_temp"] = keyP["sensor_refrigerant_pipe_temp"]
		streams["new_wind_transport"] = keyP["new_wind_transport"]
		streams["four_way_valve_crossing_protect"] = keyP["four_way_valve_crossing_protect"]
		streams["four_way_valve_crossing"] = keyP["four_way_valve_crossing"]
		streams["system_pressure_protect"] = keyP["system_pressure_protect"]
		streams["sensor_spray_enthalpy_enter_temp"] = keyP["sensor_spray_enthalpy_enter_temp"]
		streams["sensor_spray_enthalpy_out_temp"] = keyP["sensor_spray_enthalpy_out_temp"]
		streams["indoor_communication_lost"] = keyP["indoor_communication_lost"]
		streams["cold_fault"] = keyP["cold_fault"]
		streams["in_out_ability_mismatch"] = keyP["in_out_ability_mismatch"]
		streams["outdoor_fan_lose_speed"] = keyP["outdoor_fan_lose_speed"]
		streams["water_model_prevent_cold_protect"] = keyP["water_model_prevent_cold_protect"]
		streams["out_mode"] = keyP["out_mode"]
	end
	if dataType == 0x14 then
		streams["fg_timer_number"] = keyP["fg_timer_number"]
		streams["fg_timer1_week0_effect"] = keyP["fg_timer1_week0_effect"]
		streams["fg_timer1_week1_effect"] = keyP["fg_timer1_week1_effect"]
		streams["fg_timer1_week2_effect"] = keyP["fg_timer1_week2_effect"]
		streams["fg_timer1_week3_effect"] = keyP["fg_timer1_week3_effect"]
		streams["fg_timer1_week4_effect"] = keyP["fg_timer1_week4_effect"]
		streams["fg_timer1_week5_effect"] = keyP["fg_timer1_week5_effect"]
		streams["fg_timer1_week6_effect"] = keyP["fg_timer1_week6_effect"]
		streams["fg_timer1_select"] = keyP["fg_timer1_select"]
		streams["fg_timer1_wind_speed"] = keyP["fg_timer1_wind_speed"]
		streams["fg_timer1_power"] = keyP["fg_timer1_power"]
		streams["fg_timer1_mode"] = keyP["fg_timer1_mode"]
		streams["fg_timer1_temperature"] = keyP["fg_timer1_temperature"] / 2
		streams["fg_timer1_hour"] = keyP["fg_timer1_hour"]
		streams["fg_timer1_min"] = keyP["fg_timer1_min"]
		streams["fg_timer2_week0_effect"] = keyP["fg_timer2_week0_effect"]
		streams["fg_timer2_week1_effect"] = keyP["fg_timer2_week1_effect"]
		streams["fg_timer2_week2_effect"] = keyP["fg_timer2_week2_effect"]
		streams["fg_timer2_week3_effect"] = keyP["fg_timer2_week3_effect"]
		streams["fg_timer2_week4_effect"] = keyP["fg_timer2_week4_effect"]
		streams["fg_timer2_week5_effect"] = keyP["fg_timer2_week5_effect"]
		streams["fg_timer2_week6_effect"] = keyP["fg_timer2_week6_effect"]
		streams["fg_timer2_select"] = keyP["fg_timer2_select"]
		streams["fg_timer2_wind_speed"] = keyP["fg_timer2_wind_speed"]
		streams["fg_timer2_power"] = keyP["fg_timer2_power"]
		streams["fg_timer2_mode"] = keyP["fg_timer2_mode"]
		streams["fg_timer2_temperature"] = keyP["fg_timer2_temperature"] / 2
		streams["fg_timer2_hour"] = keyP["fg_timer2_hour"]
		streams["fg_timer2_min"] = keyP["fg_timer2_min"]
	end
	if dataType == 0x21 or dataType == 0x13 then
		streams["week0_timer1"] = keyP["week0_timer1"]
		streams["week0_timer2"] = keyP["week0_timer2"]
		streams["week0_timer3"] = keyP["week0_timer3"]
		streams["week0_timer4"] = keyP["week0_timer4"]
		streams["week0_timer5"] = keyP["week0_timer5"]
		streams["week1_timer1"] = keyP["week1_timer1"]
		streams["week1_timer2"] = keyP["week1_timer2"]
		streams["week1_timer3"] = keyP["week1_timer3"]
		streams["week1_timer4"] = keyP["week1_timer4"]
		streams["week1_timer5"] = keyP["week1_timer5"]
		streams["week2_timer1"] = keyP["week2_timer1"]
		streams["week2_timer2"] = keyP["week2_timer2"]
		streams["week2_timer3"] = keyP["week2_timer3"]
		streams["week2_timer4"] = keyP["week2_timer4"]
		streams["week2_timer5"] = keyP["week2_timer5"]
		streams["week3_timer1"] = keyP["week3_timer1"]
		streams["week3_timer2"] = keyP["week3_timer2"]
		streams["week3_timer3"] = keyP["week3_timer3"]
		streams["week3_timer4"] = keyP["week3_timer4"]
		streams["week3_timer5"] = keyP["week3_timer5"]
		streams["week4_timer1"] = keyP["week4_timer1"]
		streams["week4_timer2"] = keyP["week4_timer2"]
		streams["week4_timer3"] = keyP["week4_timer3"]
		streams["week4_timer4"] = keyP["week4_timer4"]
		streams["week4_timer5"] = keyP["week4_timer5"]
		streams["week5_timer1"] = keyP["week5_timer1"]
		streams["week5_timer2"] = keyP["week5_timer2"]
		streams["week5_timer3"] = keyP["week5_timer3"]
		streams["week5_timer4"] = keyP["week5_timer4"]
		streams["week5_timer5"] = keyP["week5_timer5"]
		streams["week6_timer1"] = keyP["week6_timer1"]
		streams["week6_timer2"] = keyP["week6_timer2"]
		streams["week6_timer3"] = keyP["week6_timer3"]
		streams["week6_timer4"] = keyP["week6_timer4"]
		streams["week6_timer5"] = keyP["week6_timer5"]
		streams["week0_timer1_close_hour"] = keyP["week0_timer1_close_hour"]
		streams["week0_timer1_close_min"] = keyP["week0_timer1_close_min"]
		streams["week0_timer1_open_hour"] = keyP["week0_timer1_open_hour"]
		streams["week0_timer1_open_min"] = keyP["week0_timer1_open_min"]
		streams["week0_timer1_temperature"] = keyP["week0_timer1_temperature"]
		streams["week0_timer2_close_hour"] = keyP["week0_timer2_close_hour"]
		streams["week0_timer2_close_min"] = keyP["week0_timer2_close_min"]
		streams["week0_timer2_open_hour"] = keyP["week0_timer2_open_hour"]
		streams["week0_timer2_open_min"] = keyP["week0_timer2_open_min"]
		streams["week0_timer2_temperature"] = keyP["week0_timer2_temperature"]
		streams["week0_timer3_close_hour"] = keyP["week0_timer3_close_hour"]
		streams["week0_timer3_close_min"] = keyP["week0_timer3_close_min"]
		streams["week0_timer3_open_hour"] = keyP["week0_timer3_open_hour"]
		streams["week0_timer3_open_min"] = keyP["week0_timer3_open_min"]
		streams["week0_timer3_temperature"] = keyP["week0_timer3_temperature"]
		streams["week0_timer4_close_hour"] = keyP["week0_timer4_close_hour"]
		streams["week0_timer4_close_min"] = keyP["week0_timer4_close_min"]
		streams["week0_timer4_open_hour"] = keyP["week0_timer4_open_hour"]
		streams["week0_timer4_open_min"] = keyP["week0_timer4_open_min"]
		streams["week0_timer4_temperature"] = keyP["week0_timer4_temperature"]
		streams["week0_timer5_close_hour"] = keyP["week0_timer5_close_hour"]
		streams["week0_timer5_close_min"] = keyP["week0_timer5_close_min"]
		streams["week0_timer5_open_hour"] = keyP["week0_timer5_open_hour"]
		streams["week0_timer5_open_min"] = keyP["week0_timer5_open_min"]
		streams["week0_timer5_temperature"] = keyP["week0_timer5_temperature"]
		streams["week1_timer1_close_hour"] = keyP["week1_timer1_close_hour"]
		streams["week1_timer1_close_min"] = keyP["week1_timer1_close_min"]
		streams["week1_timer1_open_hour"] = keyP["week1_timer1_open_hour"]
		streams["week1_timer1_open_min"] = keyP["week1_timer1_open_min"]
		streams["week1_timer1_temperature"] = keyP["week1_timer1_temperature"]
		streams["week1_timer2_close_hour"] = keyP["week1_timer2_close_hour"]
		streams["week1_timer2_close_min"] = keyP["week1_timer2_close_min"]
		streams["week1_timer2_open_hour"] = keyP["week1_timer2_open_hour"]
		streams["week1_timer2_open_min"] = keyP["week1_timer2_open_min"]
		streams["week1_timer2_temperature"] = keyP["week1_timer2_temperature"]
		streams["week1_timer3_close_hour"] = keyP["week1_timer3_close_hour"]
		streams["week1_timer3_close_min"] = keyP["week1_timer3_close_min"]
		streams["week1_timer3_open_hour"] = keyP["week1_timer3_open_hour"]
		streams["week1_timer3_open_min"] = keyP["week1_timer3_open_min"]
		streams["week1_timer3_temperature"] = keyP["week1_timer3_temperature"]
		streams["week1_timer4_close_hour"] = keyP["week1_timer4_close_hour"]
		streams["week1_timer4_close_min"] = keyP["week1_timer4_close_min"]
		streams["week1_timer4_open_hour"] = keyP["week1_timer4_open_hour"]
		streams["week1_timer4_open_min"] = keyP["week1_timer4_open_min"]
		streams["week1_timer4_temperature"] = keyP["week1_timer4_temperature"]
		streams["week1_timer5_close_hour"] = keyP["week1_timer5_close_hour"]
		streams["week1_timer5_close_min"] = keyP["week1_timer5_close_min"]
		streams["week1_timer5_open_hour"] = keyP["week1_timer5_open_hour"]
		streams["week1_timer5_open_min"] = keyP["week1_timer5_open_min"]
		streams["week1_timer5_temperature"] = keyP["week1_timer5_temperature"]
		streams["week2_timer1_close_hour"] = keyP["week2_timer1_close_hour"]
		streams["week2_timer1_close_min"] = keyP["week2_timer1_close_min"]
		streams["week2_timer1_open_hour"] = keyP["week2_timer1_open_hour"]
		streams["week2_timer1_open_min"] = keyP["week2_timer1_open_min"]
		streams["week2_timer1_temperature"] = keyP["week2_timer1_temperature"]
		streams["week2_timer2_close_hour"] = keyP["week2_timer2_close_hour"]
		streams["week2_timer2_close_min"] = keyP["week2_timer2_close_min"]
		streams["week2_timer2_open_hour"] = keyP["week2_timer2_open_hour"]
		streams["week2_timer2_open_min"] = keyP["week2_timer2_open_min"]
		streams["week2_timer2_temperature"] = keyP["week2_timer2_temperature"]
		streams["week2_timer3_close_hour"] = keyP["week2_timer3_close_hour"]
		streams["week2_timer3_close_min"] = keyP["week2_timer3_close_min"]
		streams["week2_timer3_open_hour"] = keyP["week2_timer3_open_hour"]
		streams["week2_timer3_open_min"] = keyP["week2_timer3_open_min"]
		streams["week2_timer3_temperature"] = keyP["week2_timer3_temperature"]
		streams["week2_timer4_close_hour"] = keyP["week2_timer4_close_hour"]
		streams["week2_timer4_close_min"] = keyP["week2_timer4_close_min"]
		streams["week2_timer4_open_hour"] = keyP["week2_timer4_open_hour"]
		streams["week2_timer4_open_min"] = keyP["week2_timer4_open_min"]
		streams["week2_timer4_temperature"] = keyP["week2_timer4_temperature"]
		streams["week2_timer5_close_hour"] = keyP["week2_timer5_close_hour"]
		streams["week2_timer5_close_min"] = keyP["week2_timer5_close_min"]
		streams["week2_timer5_open_hour"] = keyP["week2_timer5_open_hour"]
		streams["week2_timer5_open_min"] = keyP["week2_timer5_open_min"]
		streams["week2_timer5_temperature"] = keyP["week2_timer5_temperature"]
		streams["week3_timer1_close_hour"] = keyP["week3_timer1_close_hour"]
		streams["week3_timer1_close_min"] = keyP["week3_timer1_close_min"]
		streams["week3_timer1_open_hour"] = keyP["week3_timer1_open_hour"]
		streams["week3_timer1_open_min"] = keyP["week3_timer1_open_min"]
		streams["week3_timer1_temperature"] = keyP["week3_timer1_temperature"]
		streams["week3_timer2_close_hour"] = keyP["week3_timer2_close_hour"]
		streams["week3_timer2_close_min"] = keyP["week3_timer2_close_min"]
		streams["week3_timer2_open_hour"] = keyP["week3_timer2_open_hour"]
		streams["week3_timer2_open_min"] = keyP["week3_timer2_open_min"]
		streams["week3_timer2_temperature"] = keyP["week3_timer2_temperature"]
		streams["week3_timer3_close_hour"] = keyP["week3_timer3_close_hour"]
		streams["week3_timer3_close_min"] = keyP["week3_timer3_close_min"]
		streams["week3_timer3_open_hour"] = keyP["week3_timer3_open_hour"]
		streams["week3_timer3_open_min"] = keyP["week3_timer3_open_min"]
		streams["week3_timer3_temperature"] = keyP["week3_timer3_temperature"]
		streams["week3_timer4_close_hour"] = keyP["week3_timer4_close_hour"]
		streams["week3_timer4_close_min"] = keyP["week3_timer4_close_min"]
		streams["week3_timer4_open_hour"] = keyP["week3_timer4_open_hour"]
		streams["week3_timer4_open_min"] = keyP["week3_timer4_open_min"]
		streams["week3_timer4_temperature"] = keyP["week3_timer4_temperature"]
		streams["week3_timer5_close_hour"] = keyP["week3_timer5_close_hour"]
		streams["week3_timer5_close_min"] = keyP["week3_timer5_close_min"]
		streams["week3_timer5_open_hour"] = keyP["week3_timer5_open_hour"]
		streams["week3_timer5_open_min"] = keyP["week3_timer5_open_min"]
		streams["week3_timer5_temperature"] = keyP["week3_timer5_temperature"]
		streams["week4_timer1_close_hour"] = keyP["week4_timer1_close_hour"]
		streams["week4_timer1_close_min"] = keyP["week4_timer1_close_min"]
		streams["week4_timer1_open_hour"] = keyP["week4_timer1_open_hour"]
		streams["week4_timer1_open_min"] = keyP["week4_timer1_open_min"]
		streams["week4_timer1_temperature"] = keyP["week4_timer1_temperature"]
		streams["week4_timer2_close_hour"] = keyP["week4_timer2_close_hour"]
		streams["week4_timer2_close_min"] = keyP["week4_timer2_close_min"]
		streams["week4_timer2_open_hour"] = keyP["week4_timer2_open_hour"]
		streams["week4_timer2_open_min"] = keyP["week4_timer2_open_min"]
		streams["week4_timer2_temperature"] = keyP["week4_timer2_temperature"]
		streams["week4_timer3_close_hour"] = keyP["week4_timer3_close_hour"]
		streams["week4_timer3_close_min"] = keyP["week4_timer3_close_min"]
		streams["week4_timer3_open_hour"] = keyP["week4_timer3_open_hour"]
		streams["week4_timer3_open_min"] = keyP["week4_timer3_open_min"]
		streams["week4_timer3_temperature"] = keyP["week4_timer3_temperature"]
		streams["week4_timer4_close_hour"] = keyP["week4_timer4_close_hour"]
		streams["week4_timer4_close_min"] = keyP["week4_timer4_close_min"]
		streams["week4_timer4_open_hour"] = keyP["week4_timer4_open_hour"]
		streams["week4_timer4_open_min"] = keyP["week4_timer4_open_min"]
		streams["week4_timer4_temperature"] = keyP["week4_timer4_temperature"]
		streams["week4_timer5_close_hour"] = keyP["week4_timer5_close_hour"]
		streams["week4_timer5_close_min"] = keyP["week4_timer5_close_min"]
		streams["week4_timer5_open_hour"] = keyP["week4_timer5_open_hour"]
		streams["week4_timer5_open_min"] = keyP["week4_timer5_open_min"]
		streams["week4_timer5_temperature"] = keyP["week4_timer5_temperature"]
		streams["week5_timer1_close_hour"] = keyP["week5_timer1_close_hour"]
		streams["week5_timer1_close_min"] = keyP["week5_timer1_close_min"]
		streams["week5_timer1_open_hour"] = keyP["week5_timer1_open_hour"]
		streams["week5_timer1_open_min"] = keyP["week5_timer1_open_min"]
		streams["week5_timer1_temperature"] = keyP["week5_timer1_temperature"]
		streams["week5_timer2_close_hour"] = keyP["week5_timer2_close_hour"]
		streams["week5_timer2_close_min"] = keyP["week5_timer2_close_min"]
		streams["week5_timer2_open_hour"] = keyP["week5_timer2_open_hour"]
		streams["week5_timer2_open_min"] = keyP["week5_timer2_open_min"]
		streams["week5_timer2_temperature"] = keyP["week5_timer2_temperature"]
		streams["week5_timer3_close_hour"] = keyP["week5_timer3_close_hour"]
		streams["week5_timer3_close_min"] = keyP["week5_timer3_close_min"]
		streams["week5_timer3_open_hour"] = keyP["week5_timer3_open_hour"]
		streams["week5_timer3_open_min"] = keyP["week5_timer3_open_min"]
		streams["week5_timer3_temperature"] = keyP["week5_timer3_temperature"]
		streams["week5_timer4_close_hour"] = keyP["week5_timer4_close_hour"]
		streams["week5_timer4_close_min"] = keyP["week5_timer4_close_min"]
		streams["week5_timer4_open_hour"] = keyP["week5_timer4_open_hour"]
		streams["week5_timer4_open_min"] = keyP["week5_timer4_open_min"]
		streams["week5_timer4_temperature"] = keyP["week5_timer4_temperature"]
		streams["week5_timer5_close_hour"] = keyP["week5_timer5_close_hour"]
		streams["week5_timer5_close_min"] = keyP["week5_timer5_close_min"]
		streams["week5_timer5_open_hour"] = keyP["week5_timer5_open_hour"]
		streams["week5_timer5_open_min"] = keyP["week5_timer5_open_min"]
		streams["week5_timer5_temperature"] = keyP["week5_timer5_temperature"]
		streams["week6_timer1_close_hour"] = keyP["week6_timer1_close_hour"]
		streams["week6_timer1_close_min"] = keyP["week6_timer1_close_min"]
		streams["week6_timer1_open_hour"] = keyP["week6_timer1_open_hour"]
		streams["week6_timer1_open_min"] = keyP["week6_timer1_open_min"]
		streams["week6_timer1_temperature"] = keyP["week6_timer1_temperature"]
		streams["week6_timer2_close_hour"] = keyP["week6_timer2_close_hour"]
		streams["week6_timer2_close_min"] = keyP["week6_timer2_close_min"]
		streams["week6_timer2_open_hour"] = keyP["week6_timer2_open_hour"]
		streams["week6_timer2_open_min"] = keyP["week6_timer2_open_min"]
		streams["week6_timer2_temperature"] = keyP["week6_timer2_temperature"]
		streams["week6_timer3_close_hour"] = keyP["week6_timer3_close_hour"]
		streams["week6_timer3_close_min"] = keyP["week6_timer3_close_min"]
		streams["week6_timer3_open_hour"] = keyP["week6_timer3_open_hour"]
		streams["week6_timer3_open_min"] = keyP["week6_timer3_open_min"]
		streams["week6_timer3_temperature"] = keyP["week6_timer3_temperature"]
		streams["week6_timer4_close_hour"] = keyP["week6_timer4_close_hour"]
		streams["week6_timer4_close_min"] = keyP["week6_timer4_close_min"]
		streams["week6_timer4_open_hour"] = keyP["week6_timer4_open_hour"]
		streams["week6_timer4_open_min"] = keyP["week6_timer4_open_min"]
		streams["week6_timer4_temperature"] = keyP["week6_timer4_temperature"]
		streams["week6_timer5_close_hour"] = keyP["week6_timer5_close_hour"]
		streams["week6_timer5_close_min"] = keyP["week6_timer5_close_min"]
		streams["week6_timer5_open_hour"] = keyP["week6_timer5_open_hour"]
		streams["week6_timer5_open_min"] = keyP["week6_timer5_open_min"]
		streams["week6_timer5_temperature"] = keyP["week6_timer5_temperature"]
		streams["week0_duplicate_timer_on_1"] = keyP["week0_duplicate_timer_on_1"]
		streams["week0_duplicate_timer_off_2"] = keyP["week0_duplicate_timer_off_2"]
		streams["week1_duplicate_timer_on_1"] = keyP["week1_duplicate_timer_on_1"]
		streams["week1_duplicate_timer_off_2"] = keyP["week1_duplicate_timer_off_2"]
		streams["week2_duplicate_timer_on_1"] = keyP["week2_duplicate_timer_on_1"]
		streams["week2_duplicate_timer_off_2"] = keyP["week2_duplicate_timer_off_2"]
		streams["week3_duplicate_timer_on_1"] = keyP["week3_duplicate_timer_on_1"]
		streams["week3_duplicate_timer_off_2"] = keyP["week3_duplicate_timer_off_2"]
		streams["week4_duplicate_timer_on_1"] = keyP["week4_duplicate_timer_on_1"]
		streams["week4_duplicate_timer_off_2"] = keyP["week4_duplicate_timer_off_2"]
		streams["week5_duplicate_timer_on_1"] = keyP["week5_duplicate_timer_on_1"]
		streams["week5_duplicate_timer_off_2"] = keyP["week5_duplicate_timer_off_2"]
		streams["week6_duplicate_timer_on_1"] = keyP["week6_duplicate_timer_on_1"]
		streams["week6_duplicate_timer_off_2"] = keyP["week6_duplicate_timer_off_2"]
		streams["out_mode"] = keyP["out_mode"]
	end
	if dataType == 0xC0 then
		streams["c0_control_result"] = keyP["c0_control_result"]
		streams["indoor_machine_one_speed"] = keyP["indoor_machine_one_speed"]
		streams["indoor_machine_two_speed"] = keyP["indoor_machine_two_speed"]
		streams["indoor_elec_expansion_valve_one"] = keyP["indoor_elec_expansion_valve_one"]
		streams["indoor_elec_expansion_valve_two"] = keyP["indoor_elec_expansion_valve_two"]
		streams["in_water_pump_force"] = keyP["in_water_pump_force"]
		streams["out_water_pump_force"] = keyP["out_water_pump_force"]
		streams["ptc_support_force"] = keyP["ptc_support_force"]
		streams["energy_need_c0"] = keyP["energy_need_c0"]
		streams["indoor_lr_wind_angle"] = keyP["indoor_lr_wind_angle"]
		streams["out_mode"] = keyP["out_mode"]
	end
	if dataType == 0x4C then
		streams["has_ptc_mode"] = keyP["has_ptc_mode"]
		streams["has_buzzer"] = keyP["has_buzzer"]
		streams["has_heat_eco"] = keyP["has_heat_eco"]
		streams["has_indoor_humidity_sensor"] = keyP["has_indoor_humidity_sensor"]
		streams["has_wind_avoid"] = keyP["has_wind_avoid"]
		streams["has_wind_straight"] = keyP["has_wind_straight"]
		streams["request_smart_frequency_conversion_status"] = keyP["request_smart_frequency_conversion_status"]
		streams["smart_frequency_conversion_status"] = keyP["smart_frequency_conversion_status"]
		streams["has_power_tip_light_switch"] = keyP["has_power_tip_light_switch"]
		streams["has_self_clean_func"] = keyP["has_self_clean_func"]
		streams["has_power_off_mode_enable_switch"] = keyP["has_power_off_mode_enable_switch"]
		streams["has_remote_receive_switch"] = keyP["has_remote_receive_switch"]
		streams["has_support_self_clean_func"] = keyP["has_support_self_clean_func"]
		streams["has_nobody_power_off_reduce_time_switch"] = keyP["has_nobody_power_off_reduce_time_switch"]
	end
	if dataType == 0x15 then
		streams["radar_sensor_fault"] = keyP["radar_sensor_fault"]
		streams["eh3a_fault"] = keyP["eh3a_fault"]
		streams["eh3b_fault"] = keyP["eh3b_fault"]
		local radarTex = ""
		if keyP["radar_number"] ~= 1 and keyP["radar_number"] ~= 0 then
			radarTex = keyP["radar_number"]
			for k, v in pairs(radarStatus) do
				if keyP[k] then
					local temp = k .. "_" .. radarTex
					streams[temp] = keyP[k]
				end
			end
		else
			for k, v in pairs(radarStatus) do
				streams[k] = keyP[k]
			end
		end
	end
	if dataType == 0x51 then
		streams["self_clean_version"] = keyP["self_clean_version"]
		streams["has_elec_query"] = keyP["has_elec_query"]
		streams["has_prevent_wrong_tip_function"] = keyP["has_prevent_wrong_tip_function"]
	end
	if dataType == 0x31 then
		streams["care_mode_switch"] = keyP["care_mode_switch"]
		streams["child_care_mode_switch"] = keyP["child_care_mode_switch"]
		streams["old_care_mode_switch"] = keyP["old_care_mode_switch"]
		streams["has_care_mode_temp"] = keyP["has_care_mode_temp"]
		streams["has_care_mode_limit"] = keyP["has_care_mode_limit"]
		streams["has_care_mode_gentle_wind"] = keyP["has_care_mode_gentle_wind"]
		streams["has_care_mode_prevent_straight_wind"] = keyP["has_care_mode_prevent_straight_wind"]
		streams["has_care_mode_no_wind_sense"] = keyP["has_care_mode_no_wind_sense"]
		streams["care_mode_ban_mode_select"] = keyP["care_mode_ban_mode_select"]
		streams["care_mode_temp_min"] = keyP["care_mode_temp_min"]
		streams["care_mode_temp_max"] = keyP["care_mode_temp_max"]
		streams["care_mode_gentle_wind_min"] = keyP["care_mode_gentle_wind_min"]
		streams["care_mode_gentle_wind_max"] = keyP["care_mode_gentle_wind_max"]
		streams["has_child_care_mode_temp"] = keyP["has_child_care_mode_temp"]
		streams["has_child_care_mode_limit"] = keyP["has_child_care_mode_limit"]
		streams["has_child_care_mode_gentle_wind"] = keyP["has_child_care_mode_gentle_wind"]
		streams["has_child_care_mode_prevent_straight_wind"] = keyP["has_child_care_mode_prevent_straight_wind"]
		streams["has_child_care_mode_no_wind_sense"] = keyP["has_child_care_mode_no_wind_sense"]
		streams["child_care_mode_ban_mode_select"] = keyP["child_care_mode_ban_mode_select"]
		streams["child_care_mode_temp_min"] = keyP["child_care_mode_temp_min"]
		streams["child_care_mode_temp_max"] = keyP["child_care_mode_temp_max"]
		streams["child_care_mode_gentle_wind_min"] = keyP["child_care_mode_gentle_wind_min"]
		streams["child_care_mode_gentle_wind_max"] = keyP["child_care_mode_gentle_wind_max"]
		streams["has_old_care_mode_temp"] = keyP["has_old_care_mode_temp"]
		streams["has_old_care_mode_limit"] = keyP["has_old_care_mode_limit"]
		streams["has_old_care_mode_gentle_wind"] = keyP["has_old_care_mode_gentle_wind"]
		streams["has_old_care_mode_prevent_straight_wind"] = keyP["has_old_care_mode_prevent_straight_wind"]
		streams["has_old_care_mode_no_wind_sense"] = keyP["has_old_care_mode_no_wind_sense"]
		streams["old_care_mode_ban_mode_select"] = keyP["old_care_mode_ban_mode_select"]
		streams["old_care_mode_temp_min"] = keyP["old_care_mode_temp_min"]
		streams["old_care_mode_temp_max"] = keyP["old_care_mode_temp_max"]
		streams["old_care_mode_gentle_wind_min"] = keyP["old_care_mode_gentle_wind_min"]
		streams["old_care_mode_gentle_wind_max"] = keyP["old_care_mode_gentle_wind_max"]
		streams["child_old_care_mode_switch"] = keyP["child_old_care_mode_switch"]
	end
	local retTable = {}
	retTable["status"] = streams
	local ret = encode(retTable)
	return ret
end
