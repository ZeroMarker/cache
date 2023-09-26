Class dbo.BTWGMCentralPrintGrpChild Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WGMCentralPrintGrpChild ]
{

/// Foreign Key FKBTWGMCentralPrintGrpChildTSCentralPrintGroupDR created via DDL
ForeignKey FKBTWGMCentralPrintGrpChildTSCentralPrintGroupDR(TSCentralPrintGroupDR) References dbo.BTTSCentralPrintGroup(PKBTTSCENTRALPRINTGROUP) [ SqlName = FK_BTWGMCentralPrintGrpChildTSCentralPrintGroupDR ];

/// Foreign Key FKBTTSCentralPrintGrpChildTestSetDR created via DDL
ForeignKey FKBTWGMCentralPrintGrpChildWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_BTWGMCentralPrintGrpChildWorkGroupMachineDR ];

/// DDL Primary Key Specification
Index PKBTTSCENTRALPRINTGRPCHILD On RowID [ PrimaryKey, SqlName = PK_BT_TSCENTRALPRINTGRPCHILD, Type = index, Unique ];

Index IndexMaster On (WorkGroupMachineDR, TSCentralPrintGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 打印组  
Property TSCentralPrintGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTWGMCentralPrintGrpChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TSCentralPrintGroupDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWGMCentralPrintGrpChildD</DataLocation>
<DefaultData>BTWGMCentralPrintGrpChildDefaultData</DefaultData>
<IdLocation>^dbo.BTWGMCentralPrintGrpChildD</IdLocation>
<IndexLocation>^dbo.BTWGMCentralPrintGrpChildI</IndexLocation>
<StreamLocation>^dbo.BTWGMCentralPrintGrpChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
