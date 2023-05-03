-- Lab - Creating a table with partitions

drop table [logdata]

CREATE TABLE [logdata]
(
    [Id] [int] NULL,
	[Correlationid] [varchar](200) NULL,
	[Operationname] [varchar](200) NULL,
	[Status] [varchar](100) NULL,
	[Eventcategory] [varchar](100) NULL,
	[Level] [varchar](100) NULL,
	[Time] [datetime] NULL,
	[Subscription] [varchar](200) NULL,
	[Eventinitiatedby] [varchar](1000) NULL,
	[Resourcetype] [varchar](1000) NULL,
	[Resourcegroup] [varchar](1000) NULL
)

COPY INTO logdata FROM 'https://datalakealladio1.blob.core.windows.net/datacontainer/cleaned/Log-3.csv'
WITH
(
FIRSTROW=2
)

-- Let's first inspect our table to see the range of dates
SELECT FORMAT(Time,'yyyy-MM-dd') AS dt,COUNT(*) FROM logdata
GROUP BY FORMAT(Time,'yyyy-MM-dd')

-- Let's create a new table with partitions
CREATE TABLE [logdata]
(
    [Id] [int] NULL,
	[Correlationid] [varchar](200) NULL,
	[Operationname] [varchar](200) NULL,
	[Status] [varchar](100) NULL,
	[Eventcategory] [varchar](100) NULL,
	[Level] [varchar](100) NULL,
	[Time] [datetime] NULL,
	[Subscription] [varchar](200) NULL,
	[Eventinitiatedby] [varchar](1000) NULL,
	[Resourcetype] [varchar](1000) NULL,
	[Resourcegroup] [varchar](1000) NULL
)
WITH
(
PARTITION ( [Time] RANGE RIGHT FOR VALUES
            ('2021-04-01','2021-05-01','2021-06-01')

   )  
)

-- Copy data into the table
COPY INTO logdata FROM 'https://datalakealladio1.blob.core.windows.net/datacontainer/cleaned/Log-3.csv'
WITH
(
FIRSTROW=2
)

-- View the partitions
SELECT  QUOTENAME(s.[name])+'.'+QUOTENAME(t.[name]) as Table_name
,       i.[name] as Index_name
,       p.partition_number as Partition_nmbr
,       p.[rows] as Row_count
,       p.[data_compression_desc] as Data_Compression_desc
FROM    sys.partitions p
JOIN    sys.tables     t    ON    p.[object_id]   = t.[object_id]
JOIN    sys.schemas    s    ON    t.[schema_id]   = s.[schema_id]
JOIN    sys.indexes    i    ON    p.[object_id]   = i.[object_Id]
                            AND   p.[index_Id]    = i.[index_Id]
WHERE t.[name] = 'logdata'