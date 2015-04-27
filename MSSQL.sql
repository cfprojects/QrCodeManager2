CREATE TABLE [dbo].[qrCode](
	[id] [varchar](12) NOT NULL,
	[url] [varchar](500) NOT NULL,
	[title] [varchar](100) NULL,
	[description] [varchar](4000) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_qrCode] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[qrLog](
	[id] [varchar](12) NOT NULL,
	[log_date] [datetime] NOT NULL,
	[ip] [varchar](50) NULL,
	[user_agent] [varchar](400) NULL
) ON [PRIMARY]

GO




