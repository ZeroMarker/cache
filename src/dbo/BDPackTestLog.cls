/// 血袋检测日志表
Class dbo.BDPackTestLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackTestLog, StorageStrategy = Default ]
{

/// Foreign Key FKBDPBDPackTestLogPack created via DDL
ForeignKey FKBDPackTestLogPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PacakTestLog_Pack ];

/// Foreign Key FKBDPackTestLogAddUser created via DDL
ForeignKey FKBDPackTestLogAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PackTestLog_AddUser ];

/// Foreign Key FKBDPackTestLogWorkGroup created via DDL
ForeignKey FKBDPackTestLogWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_PackTestLog_WorkGroup ];

Index IndexMaster On (PackDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroup On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexUser On (AddUserDR, AddDate) [ SqlName = Index_User, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKTESTLOG On RowID [ PrimaryKey, SqlName = PK_BD_PACKTESTLOG, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 操作日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 操作时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 操作人
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 操作类型   操作类型{1：登记，2：审核，3：取消审核，4：结果保存，5：删除}
Property AddType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 7 ];

/// 操作说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 检测ID  
Property PackTestID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDPackTestLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>AddType</Value>
</Value>
<Value name="7">
<Value>操作说明</Value>
</Value>
<Value name="8">
<Value>PackTestID</Value>
</Value>
<Value name="9">
<Value>WorkGroupDR</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackTestLogD</DataLocation>
<DefaultData>BDPackTestLogDefaultData</DefaultData>
<IdLocation>^dbo.BDPackTestLogD</IdLocation>
<IndexLocation>^dbo.BDPackTestLogI</IndexLocation>
<StreamLocation>^dbo.BDPackTestLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
