Class dbo.BTMCLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_Link, StorageStrategy = Default ]
{

Index IndexMaster On (Code, WorkGroupMachineDR, SpecimenDR) [ SqlName = Index_Master, Type = index ];

Index IndexWorkGroupMachineDR On (WorkGroupMachineDR, SpecimenDR, Code) [ SqlName = Index_WorkGroupMachineDR, Type = index, Unique ];

/// Foreign Key FKVisitNumberReportWorkGroup created via DDL
ForeignKey FKVisitNumberReportWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_VisitNumberReportWorkGroup ];

/// Foreign Key FKVisitNumberSpecType created via DDL
ForeignKey FKVisitNumberSpecType(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_VisitNumberSpecType ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMCLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCLinkD</DataLocation>
<DefaultData>BTMCLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTMCLinkD</IdLocation>
<IndexLocation>^dbo.BTMCLinkI</IndexLocation>
<StreamLocation>^dbo.BTMCLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
