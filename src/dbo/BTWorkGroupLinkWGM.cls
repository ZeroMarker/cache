Class dbo.BTWorkGroupLinkWGM Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupLinkWGM, StorageStrategy = Default ]
{

/// Foreign Key FKWorkGroupLinkWG created via DDL
ForeignKey FKWorkGroupLinkWG(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupLinkWG ];

/// Foreign Key FKMachineWorkGroup created via DDL
ForeignKey FKWorkGroupLinkWGM(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WorkGroupLinkWGM ];

Index IndexMaster On (WorkGroupDR, AdaptType, WorkGroupMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (WorkGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTWORKGROUPLINKWGM On RowID [ PrimaryKey, SqlName = PK_BT_WORKGROUPLINKWGM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AdaptType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTWorkGroupLinkWGMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>AdaptType</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupLinkWGMD</DataLocation>
<DefaultData>BTWorkGroupLinkWGMDefaultData</DefaultData>
<IdLocation>^dbo.BTWorkGroupLinkWGMD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupLinkWGMI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupLinkWGMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
