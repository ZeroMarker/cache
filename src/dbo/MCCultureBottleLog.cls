/// 血培养瓶日志
Class dbo.MCCultureBottleLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MC_CultureBottleLog ]
{

/// Foreign Key FKMCCultureBottleLogAddUserDR created via DDL
ForeignKey FKMCCultureBottleLogAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MCCultureBottleLogAddUserDR ];

/// Foreign Key FKMCCultureBottleLogWorkGroupDR created via DDL
ForeignKey FKMCCultureBottleLogWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_MCCultureBottleLogWorkGroupDR ];

/// DDL Primary Key Specification
Index PKMCCULTUREBOTTLELOG On RowID [ PrimaryKey, SqlName = PK_MC_CULTUREBOTTLELOG, Type = index, Unique ];

Index IndexMaster On (BotBarcode, OpType, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexAddDate On (WorkGroupDR, AddDate, OpType) [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 瓶身条码号  
Property BotBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 3 ];

/// 操作  {C:创建,I:入库,O:领用,U:使用,D:删除}
Property OpType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

/// 操作日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 操作时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 操作用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 操作IP  
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 操作说明  
Property OperateNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="MCCultureBottleLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BotBarcode</Value>
</Value>
<Value name="3">
<Value>OpType</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>WorkGroupDR</Value>
</Value>
<Value name="8">
<Value>IPAddress</Value>
</Value>
<Value name="9">
<Value>OperateNotes</Value>
</Value>
</Data>
<DataLocation>^dbo.MCCultureBottleLogD</DataLocation>
<DefaultData>MCCultureBottleLogDefaultData</DefaultData>
<IdLocation>^dbo.MCCultureBottleLogD</IdLocation>
<IndexLocation>^dbo.MCCultureBottleLogI</IndexLocation>
<StreamLocation>^dbo.MCCultureBottleLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
