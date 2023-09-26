/// BDSYSModifyLog
Class dbo.BDSYSModifyLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_SYSModifyLog, StorageStrategy = Default ]
{

Index IndexMaster On (TableName, TableRowID) [ SqlName = Index_Master, Type = index ];

Index IndexTable On (TableName, AddDate) [ SqlName = Index_Table, Type = index ];

Index IndexAddDate On (AddDate, WorkGroupDR) [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

/// DDL Primary Key Specification
Index PKBDSYSModifyLog On RowID [ PrimaryKey, SqlName = PK_BD_SYSModifyLog, Type = index, Unique ];

/// Foreign Key FKPackModifyLogBDPack created via DDL
ForeignKey FKBDSYSModifyLogWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BDSYSModifyLog_WorkGroup ];

/// Foreign Key FKPackModifyLogUser created via DDL
ForeignKey FKBDSYSModifyLogUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDSYSModifyLog_User ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 输血表名  
Property TableName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 3 ];

/// 操作表ID  
Property TableRowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 操作日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 操作时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 修改项目  
Property ModifyItem As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 修改前内容  
Property PreContent As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 修改后内容  
Property AfterContent As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

/// 修改人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 修改IP  
Property ClientIP As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BDSYSModifyLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>TableRowID</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>ModifyItem</Value>
</Value>
<Value name="7">
<Value>PreContent</Value>
</Value>
<Value name="8">
<Value>AfterContent</Value>
</Value>
<Value name="9">
<Value>AddUserDR</Value>
</Value>
<Value name="10">
<Value>ClientIP</Value>
</Value>
<Value name="11">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDSYSModifyLogD</DataLocation>
<DefaultData>BDSYSModifyLogDefaultData</DefaultData>
<IdLocation>^dbo.BDSYSModifyLogD</IdLocation>
<IndexLocation>^dbo.BDSYSModifyLogI</IndexLocation>
<StreamLocation>^dbo.BDSYSModifyLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
