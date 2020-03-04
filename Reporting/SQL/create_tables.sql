/****** Object:  Table [dbo].[BeerIOStat]    Script Date: 14-2-2020 16:42:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BeerIOStat](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[air_pump] [varchar](50) NULL,
	[air_pump_speed] [decimal](18, 0) NULL,
	[cooling_comp] [varchar](50) NULL,
	[cooling_fan_hs] [decimal](18, 0) NULL,
	[cooling_fan_ls] [decimal](18, 0) NULL,
	[cooling_fan_run] [varchar](50) NULL,
	[defrost_coil] [varchar](50) NULL,
	[keg_locking_led] [varchar](50) NULL,
	[locking1_detect_sw] [varchar](50) NULL,
	[locking1_open_sw] [varchar](50) NULL,
	[locking2_detect_sw] [varchar](50) NULL,
	[locking2_open_sw] [varchar](50) NULL,
	[motor1] [varchar](50) NULL,
	[motor2] [varchar](50) NULL,
	[temp_gauge_alert] [varchar](50) NULL,
	[temp_gauge_backlight] [varchar](50) NULL,
	[volume_gauge_alert] [varchar](50) NULL,
	[volume_gauge_backlight] [varchar](50) NULL,
	[time] [datetime] NULL,
	[device_name] [varchar](50) NULL,
 CONSTRAINT [PK_BeerIOStat] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[BeerPouring]    Script Date: 14-2-2020 16:42:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BeerPouring](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[state] [varchar](50) NULL,
	[status] [varchar](50) NULL,
	[duration] [decimal](16, 2) NULL,
	[time] [datetime] NULL,
	[device_name] [varchar](50) NULL,
 CONSTRAINT [PK_BeerPouring] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[BeerRall]    Script Date: 14-2-2020 16:42:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BeerRall](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[cooling_compressor_stop] [varchar](500) NULL,
	[cooling_fan_stop] [varchar](500) NULL,
	[c1_last_2l_timer] [varchar](500) NULL,
	[c1_time_max] [varchar](500) NULL,
	[c2_last_2l_timer] [varchar](500) NULL,
	[c2_time_max] [varchar](500) NULL,
	[c3_last_2l_timer] [varchar](500) NULL,
	[c3_time_max] [varchar](500) NULL,
	[calculated_total_volume] [varchar](500) NULL,
	[cooling_compressor_high_limit] [varchar](500) NULL,
	[cooling_compressor_low_limit] [varchar](500) NULL,
	[cooling_fan_speed] [varchar](500) NULL,
	[current_keg_volume] [varchar](500) NULL,
	[cuton_sensor] [varchar](500) NULL,
	[debug_ambient] [varchar](500) NULL,
	[debug_fan_speed_adjust] [varchar](500) NULL,
	[display_debug_information_pdebug] [varchar](500) NULL,
	[fan_pwm] [varchar](500) NULL,
	[pump_stop_work_time] [varchar](500) NULL,
	[fuzy_cc_off] [varchar](500) NULL,
	[fuzy_cc_on] [varchar](500) NULL,
	[keg_empty_waiting_time] [varchar](500) NULL,
	[keg_half_waiting_time] [varchar](500) NULL,
	[keg_locking_buf] [varchar](500) NULL,
	[keg_unlocking_buf] [varchar](500) NULL,
	[last_2l_warmup] [varchar](500) NULL,
	[light_brightnes_duty_value] [varchar](500) NULL,
	[locking1_refusals_by_current_limit_cut_off] [varchar](500) NULL,
	[locking2_refusals_by_current_limit_cut_off] [varchar](500) NULL,
	[main_frequency] [varchar](500) NULL,
	[max_ambient] [varchar](500) NULL,
	[max_air_value] [varchar](500) NULL,
	[max_air_pump_speed] [varchar](500) NULL,
	[max_rpm_pwm_fan] [varchar](500) NULL,
	[measured_sensor_pressure] [varchar](500) NULL,
	[min_ambient] [varchar](500) NULL,
	[min_air_value] [varchar](500) NULL,
	[min_rpm_pwmfan] [varchar](500) NULL,
	[minimum_cooling_running_time] [varchar](500) NULL,
	[minimum_cooling_stop_time] [varchar](500) NULL,
	[minimum_fan_running_time] [varchar](500) NULL,
	[printf_display_air] [varchar](500) NULL,
	[printf_display_final_tester_data] [varchar](500) NULL,
	[printf_display_temp] [varchar](500) NULL,
	[pump_run_work_time] [varchar](500) NULL,
	[snr] [varchar](500) NULL,
	[smart_keg_start_temperature] [varchar](500) NULL,
	[state_locking] [varchar](500) NULL,
	[tapping_cycle] [varchar](500) NULL,
	[temperature_defrost_volume] [varchar](500) NULL,
	[temperature_regulation_time] [varchar](500) NULL,
	[tests_light_brightnes_duty_value] [varchar](500) NULL,
	[third_pump_stop_work_time] [varchar](500) NULL,
	[total_count_compressor] [varchar](500) NULL,
	[total_count_defrost_coil] [varchar](500) NULL,
	[total_count_locking1] [varchar](500) NULL,
	[total_count_locking2] [varchar](500) NULL,
	[total_time_defrost_coil] [varchar](500) NULL,
	[total_time_air_pump] [varchar](500) NULL,
	[total_time_keg_light] [varchar](500) NULL,
	[unlocking1_refusals_by_current_limit_cut_off] [varchar](500) NULL,
	[unlocking2_refusals_by_current_limit_cut_off] [varchar](500) NULL,
	[time] [datetime] NULL,
	[device_name] [varchar](50) NULL,
 CONSTRAINT [PK_BeerRall] PRIMARY KEY CLUSTERED 
 (
	[MessageID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[BeerTemperature]    Script Date: 14-2-2020 16:42:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BeerTemperature](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[amb_temperature] [decimal](10, 2) NULL,
	[air_pressure] [decimal](10, 2) NULL,
	[bowl_temperature] [decimal](10, 2) NULL,
	[keg_temperature] [decimal](10, 2) NULL,
	[keg_volume] [decimal](10, 2) NULL,
	[time] [datetime] NULL,
	[device_name] [varchar](50) NULL,
 CONSTRAINT [PK_BeerTemperature] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


