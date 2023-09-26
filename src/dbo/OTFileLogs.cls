/// 文件日志
Class dbo.OTFileLogs Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileLogs ]
{

Index IndexUpdateDate On (OTFileInfoDR, UpdateDate, UpdateTime) [ SqlName = Index_UpdateDate, Type = index ];

/// Foreign Key FKUpdateUser created via DDL
ForeignKey FKUpdateUser(UpdateUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_UpdateUser ];

/// Foreign Key FKOTFileInfoDR created via DDL
ForeignKey FKOTFileInfoDR(OTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_OTFileInfoDR ];

/// DDL Primary Key Specification
Index PKOTFILEPERMISSION On RowID [ PrimaryKey, SqlName = PK_OT_FILEPERMISSION, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 文件  
Property OTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 更新日期  
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 更新时间  
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 更新人  
Property UpdateUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 7 ];

/// 文件名  
Property FilePath As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 8 ];

/// 老名称  
Property OldName As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 9 ];

/// 新名称  
Property NewName As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 10 ];

/// 老关键字  
Property OldKeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 11 ];

/// 新关键字  
Property NewKeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 12 ];

/// 老文件编号  
Property OldFileCode As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 13 ];

/// 新文件编号  
Property NewFileCode As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 14 ];

/// 老文件主题  
Property OldFileSubject As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 15 ];

/// 新文件主题  
Property NewFileSubject As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 16 ];

/// 老文件类型  
Property OldOTFileTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 新文件类型  
Property NewOTFileTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 老允许格式  
Property OldAllowSuffix As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 19 ];

/// 新允许格式  
Property NewAllowSuffix As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 20 ];

/// 文件序列号  
Property FileLicense As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 21 ];

/// 操作类型  
Property OperationType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 22 ];

Storage Default
{
<Data name="OTFileLogsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OTFileInfoDR</Value>
</Value>
<Value name="3">
<Value>UpdateDate</Value>
</Value>
<Value name="4">
<Value>UpdateTime</Value>
</Value>
<Value name="5">
<Value>UpdateUser</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>FilePath</Value>
</Value>
<Value name="8">
<Value>OldName</Value>
</Value>
<Value name="9">
<Value>NewName</Value>
</Value>
<Value name="10">
<Value>OldKeyWord</Value>
</Value>
<Value name="11">
<Value>NewKeyWord</Value>
</Value>
<Value name="12">
<Value>OldFileCode</Value>
</Value>
<Value name="13">
<Value>NewFileCode</Value>
</Value>
<Value name="14">
<Value>OldFileSubject</Value>
</Value>
<Value name="15">
<Value>NewFileSubject</Value>
</Value>
<Value name="16">
<Value>OldOTFileTypeDR</Value>
</Value>
<Value name="17">
<Value>NewOTFileTypeDR</Value>
</Value>
<Value name="18">
<Value>OldAllowSuffix</Value>
</Value>
<Value name="19">
<Value>NewAllowSuffix</Value>
</Value>
<Value name="20">
<Value>FileLicense</Value>
</Value>
<Value name="21">
<Value>OperationType</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileLogsD</DataLocation>
<DefaultData>OTFileLogsDefaultData</DefaultData>
<IdLocation>^dbo.OTFileLogsD</IdLocation>
<IndexLocation>^dbo.OTFileLogsI</IndexLocation>
<StreamLocation>^dbo.OTFileLogsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
