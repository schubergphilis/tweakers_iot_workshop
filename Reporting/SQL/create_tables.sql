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
	[EventEnqueuedUtcTime] [datetime] NULL,
	[ConnectionDeviceId] [varchar](50) NULL,
 CONSTRAINT [PK_BierIOStat] PRIMARY KEY CLUSTERED 
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
	[duration] [int] NULL,
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
	[cooling_compressor_stop] [nchar](10) NULL,
	[cooling_fan_stop] [nchar](10) NULL,
	[c1_last_2l_timer] [nchar](10) NULL,
	[c1_time_max] [nchar](10) NULL,
	[c2_last_2l_timer] [nchar](10) NULL,
	[c2_time_max] [nchar](10) NULL,
	[c3_last_2l_timer] [nchar](10) NULL,
	[c3_time_max] [nchar](10) NULL,
	[calculated_total_volume] [nchar](10) NULL,
	[cooling_compressor_high_limit] [nchar](10) NULL,
	[cooling_compressor_low_limit] [nchar](10) NULL,
	[cooling_fan_speed] [nchar](10) NULL,
	[current_keg_volume] [nchar](10) NULL,
	[cuton_sensor] [nchar](10) NULL,
	[debug_ambient] [nchar](10) NULL,
	[debug_fan_speed_adjust] [nchar](10) NULL,
	[display_debug_information_pdebug] [nchar](10) NULL,
	[fan_pwm] [nchar](10) NULL,
	[pump_stop_work_time] [nchar](10) NULL,
	[fuzy_cc_off] [nchar](10) NULL,
	[fuzy_cc_on] [nchar](10) NULL,
	[keg_empty_waiting_time] [nchar](10) NULL,
	[keg_half_waiting_time] [nchar](10) NULL,
	[keg_locking_buf] [nchar](10) NULL,
	[keg_unlocking_buf] [nchar](10) NULL,
	[last_2l_warmup] [nchar](10) NULL,
	[light_brightnes_duty_value] [nchar](10) NULL,
	[locking1_refusals_by_current_limit_cut_off] [nchar](10) NULL,
	[locking2_refusals_by_current_limit_cut_off] [nchar](10) NULL,
	[main_frequency] [nchar](10) NULL,
	[max_ambient] [nchar](10) NULL,
	[max_air_value] [nchar](10) NULL,
	[max_air_pump_speed] [nchar](10) NULL,
	[max_rpm_pwm_fan] [nchar](10) NULL,
	[measured_sensor_pressure] [nchar](10) NULL,
	[min_ambient] [nchar](10) NULL,
	[min_air_value] [nchar](10) NULL,
	[min_rpm_pwmfan] [nchar](10) NULL,
	[minimum_cooling_running_time] [nchar](10) NULL,
	[minimum_cooling_stop_time] [nchar](10) NULL,
	[minimum_fan_running_time] [nchar](10) NULL,
	[printf_display_air] [nchar](10) NULL,
	[printf_display_final_tester_data] [nchar](10) NULL,
	[printf_display_temp] [nchar](10) NULL,
	[pump_run_work_time] [nchar](10) NULL,
	[snr] [nchar](10) NULL,
	[smart_keg_start_temperature] [nchar](10) NULL,
	[state_locking] [nchar](10) NULL,
	[tapping_cycle] [nchar](10) NULL,
	[temperature_defrost_volume] [nchar](10) NULL,
	[temperature_regulation_time] [nchar](10) NULL,
	[tests_light_brightnes_duty_value] [nchar](10) NULL,
	[third_pump_stop_work_time] [nchar](10) NULL,
	[total_count_compressor] [nchar](10) NULL,
	[total_count_defrost_coil] [nchar](10) NULL,
	[total_count_locking1] [nchar](10) NULL,
	[total_count_locking2] [nchar](10) NULL,
	[total_time_defrost_coil] [nchar](10) NULL,
	[total_time_air_pump] [nchar](10) NULL,
	[total_time_keg_light] [nchar](10) NULL,
	[unlocking1_refusals_by_current_limit_cut_off] [nchar](10) NULL,
	[unlocking2_refusals_by_current_limit_cut_off] [nchar](10) NULL,
	[EventEnqueuedUtcTime] [datetime] NULL,
	[ConnectionDeviceId] [varchar](50) NULL,
 CONSTRAINT [PK_BierRall] PRIMARY KEY CLUSTERED 
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
	[EventEnqueuedUtcTime] [datetime] NULL,
	[ConnectionDeviceId] [varchar](50) NULL,
 CONSTRAINT [PK_BierTemperature] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


