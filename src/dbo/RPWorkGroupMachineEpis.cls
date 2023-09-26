/// 工作小组流水号
Class dbo.RPWorkGroupMachineEpis Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_WorkGroupMachineEpis, StorageStrategy = Default ]
{

/// Foreign Key FKWorkGroupMachineEpis created via DDL
ForeignKey FKWorkGroupMachineEpis(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WorkGroupMachineEpis ];

Index IndexMaster On (WorkGroupMachineDR, AddDate) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPWORKGROUPMACHINEEPIS On RowID [ PrimaryKey, SqlName = PK_RP_WORKGROUPMACHINEEPIS, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 最近流水号  
Property EpisNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="RPWorkGroupMachineEpisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>EpisNo</Value>
</Value>
</Data>
<DataLocation>^dbo.RPWorkGroupMachineEpisD</DataLocation>
<DefaultData>RPWorkGroupMachineEpisDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPWorkGroupMachineEpisD</IdLocation>
<IndexLocation>^dbo.RPWorkGroupMachineEpisI</IndexLocation>
<StreamLocation>^dbo.RPWorkGroupMachineEpisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
