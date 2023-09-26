/// 值班小组维护
Class dbo.BTWGMachineDuty Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WGMachineDuty ]
{

/// Foreign Key FKBTWGMachineDutyWorkGroupDR created via DDL
ForeignKey FKBTWGMachineDutyWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTWGMachineDutyWorkGroupDR ];

Index IndexMaster On (Code, WorkGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroup On WorkGroupDR [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key PKRPDrugCombination
Index PKBTWGMachineDuty On RowID [ PrimaryKey, SqlName = PK_BT_WGMachineDuty, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 显示序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTWGMachineDutyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWGMachineDutyD</DataLocation>
<DefaultData>BTWGMachineDutyDefaultData</DefaultData>
<IdLocation>^dbo.BTWGMachineDutyD</IdLocation>
<IndexLocation>^dbo.BTWGMachineDutyI</IndexLocation>
<StreamLocation>^dbo.BTWGMachineDutyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
