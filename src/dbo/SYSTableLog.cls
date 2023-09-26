/// 系统表日志
Class dbo.SYSTableLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_TableLog, StorageStrategy = Default ]
{

/// Foreign Key FKSystemTableLog created via DDL
ForeignKey FKSystemTableLog(TableDR) References dbo.SYSTable(PKSYSTABLE) [ SqlName = FK_SystemTableLog ];

/// Foreign Key FKSystemTableLogUser created via DDL
ForeignKey FKSystemTableLogUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_SystemTableLogUser ];

Index IndexAction On (Action, AddDate, TableDR) [ SqlName = Index_Action, Type = index ];

Index IndexDateTime On (TableDR, AddDate, AddTime) [ SqlName = Index_DateTime, Type = index ];

Index IndexRecordID On (TableDR, RecordID, AddDate, AddTime) [ SqlName = Index_RecordID, Type = index ];

Index IndexUser On (AddUserDR, AddDate, TableDR) [ SqlName = Index_User, Type = index ];

/// DDL Primary Key Specification
Index PKSYSTABLELOG On RowID [ PrimaryKey, SqlName = PK_SYS_TABLELOG, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

/// 表  
Property TableDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 操作  {I:插入,U:更新,D:删除}
Property Action As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

/// 操作数据  
Property ActData As %Library.String(COLLATION = "Exact", MAXLEN = 30000) [ SqlColumnNumber = 7 ];

/// 用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 记录号  
Property RecordID As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 9 ];

/// IP  
Property ClientIPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="SYSTableLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>Action</Value>
</Value>
<Value name="6">
<Value>ActData</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>RecordID</Value>
</Value>
<Value name="9">
<Value>ClientIPAddress</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSTableLogD</DataLocation>
<DefaultData>SYSTableLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSTableLogD</IdLocation>
<IndexLocation>^dbo.SYSTableLogI</IndexLocation>
<StreamLocation>^dbo.SYSTableLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
