Class dbo.OTFileReadLogs Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileReadLogs ]
{

Index IndexFile On (OTFileInfoDR, ReadDate, ReadTime) [ SqlName = Index_File, Type = index ];

Index IndexReadUser On (ReadUser, ReadDate, ReadTime) [ SqlName = Index_ReadUser, Type = index, Unique ];

/// Foreign Key FKOTFileInfoDR created via DDL
ForeignKey FKOTFileInfoDR(OTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_OTFileInfoDR ];

/// Foreign Key FKReadUser created via DDL
ForeignKey FKReadUser(ReadUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_ReadUser ];

/// DDL Primary Key Specification
Index PKOTFILEREADLOGS On RowID [ PrimaryKey, SqlName = PK_OT_FILEREADLOGS, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 文件  
Property OTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 阅读日期  
Property ReadDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 阅读时间  
Property ReadTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 阅读人  
Property ReadUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="OTFileReadLogsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OTFileInfoDR</Value>
</Value>
<Value name="3">
<Value>ReadDate</Value>
</Value>
<Value name="4">
<Value>ReadTime</Value>
</Value>
<Value name="5">
<Value>ReadUser</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileReadLogsD</DataLocation>
<DefaultData>OTFileReadLogsDefaultData</DefaultData>
<IdLocation>^dbo.OTFileReadLogsD</IdLocation>
<IndexLocation>^dbo.OTFileReadLogsI</IndexLocation>
<StreamLocation>^dbo.OTFileReadLogsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
