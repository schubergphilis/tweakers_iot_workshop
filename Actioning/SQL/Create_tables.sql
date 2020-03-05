
/****** Object:  Table [dbo].[BeerPouring]    Script Date: 5-3-2020 16:50:12 ******/
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


