/// 阳性归档小组
Class dbo.BTArchiveWGM Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ArchiveWGM ]
{

/// Foreign Key FKArcWorkGroupMachine created via DDL
ForeignKey FKArcWorkGroupMachine(ArcWorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_ArcWorkGroupMachine ];

/// Foreign Key FKRepWorkGroupMachine created via DDL
ForeignKey FKRepWorkGroupMachine(RepWorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RepWorkGroupMachine ];

Index IndexMaster On (ArcWorkGroupMachineDR, RepWorkGroupMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTARCHIVEWG On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEQC, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 归档小组  
Property ArcWorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 报告小组  
Property RepWorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTArchiveWGMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArcWorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>RepWorkGroupMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTArchiveWGMD</DataLocation>
<DefaultData>BTArchiveWGMDefaultData</DefaultData>
<IdLocation>^dbo.BTArchiveWGMD</IdLocation>
<IndexLocation>^dbo.BTArchiveWGMI</IndexLocation>
<StreamLocation>^dbo.BTArchiveWGMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
