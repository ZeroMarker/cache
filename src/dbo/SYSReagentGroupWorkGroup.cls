///     
Class dbo.SYSReagentGroupWorkGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_ReagentGroupWorkGroup, StorageStrategy = Default ]
{

Index IndexMaster On (ReagentGroupDR, WorkGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKSYSREAGENTGROUPWORKGROUP On RowID [ PrimaryKey, SqlName = PK_SYS_REAGENTGROUPWORKGROUP, Type = index, Unique ];

/// Foreign Key FKRGReagentWorkGroupReagentGroup created via DDL
ForeignKey FKRGReagentWorkGroupReagentGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_ReagentWorkGroup_ReagentGroup ];

/// Foreign Key FKRGReagentWorkGroupWorkGroup created via DDL
ForeignKey FKRGReagentWorkGroupWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RG_ReagentWorkGroup_WorkGroup ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSReagentGroupWorkGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSReagentGroupWorkGroupD</DataLocation>
<DefaultData>SYSReagentGroupWorkGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSReagentGroupWorkGroupD</IdLocation>
<IndexLocation>^dbo.SYSReagentGroupWorkGroupI</IndexLocation>
<StreamLocation>^dbo.SYSReagentGroupWorkGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
