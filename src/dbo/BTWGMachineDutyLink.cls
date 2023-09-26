/// 值班小组维护关联
Class dbo.BTWGMachineDutyLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WGMachineDutyLink ]
{

/// Foreign Key FKRPDrugCombinationResultDR created via DDL
ForeignKey FKBTWGMachineDutyLinkWGMDutyDR(WGMDutyDR) References dbo.BTWGMachineDuty(PKBTWGMachineDuty) [ SqlName = FK_BTWGMachineDutyLinkWGMDutyDR ];

ForeignKey FKBTWGMachineDutyLinkWGMachineDR(WGMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_BTWGMachineDutyLinkWGMachineDR ];

Index IndexMaster On (WGMDutyDR, WGMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key PKRPDrugCombination
Index PKBTWGMachineDutyLink On RowID [ PrimaryKey, SqlName = PK_BT_WGMachineDutyLink, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 值班小组表
Property WGMDutyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作小组
Property WGMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTWGMachineDutyLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WGMDutyDR</Value>
</Value>
<Value name="3">
<Value>WGMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWGMachineDutyLinkD</DataLocation>
<DefaultData>BTWGMachineDutyLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTWGMachineDutyLinkD</IdLocation>
<IndexLocation>^dbo.BTWGMachineDutyLinkI</IndexLocation>
<StreamLocation>^dbo.BTWGMachineDutyLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
