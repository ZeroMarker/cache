Class dbo.RPMachineConclusion Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachineConclusion, StorageStrategy = Default ]
{

Index IndexEpisodeNo On (AssayNo, ReceiveDate) [ SqlName = Index_EpisodeNo, Type = index ];

Index IndexMachine On (MachineParameterDR, EpisodeNo, ReceiveDate) [ SqlName = Index_Machine, Type = index ];

Index IndexMaster On (WorkGroupMachineDR, ReceiveDate, AssayNo) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPMACHINERESULT On RowID [ PrimaryKey, SqlName = PK_RP_MACHINERESULT, Type = index, Unique ];

/// Foreign Key FKMachineResultMi created via DDL
ForeignKey FKMachineResultMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineResultMi ];

/// Foreign Key FKMachineResultWg created via DDL
ForeignKey FKMachineResultWg(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachineResultWg ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 6 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 8 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Property ResultFlag As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPMachineConclusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>ReceiveDate</Value>
</Value>
<Value name="4">
<Value>ReceiveTime</Value>
</Value>
<Value name="5">
<Value>AssayNo</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>ResultDate</Value>
</Value>
<Value name="8">
<Value>ResultTime</Value>
</Value>
<Value name="9">
<Value>MachineParameterDR</Value>
</Value>
<Value name="10">
<Value>EpisodeNo</Value>
</Value>
<Value name="11">
<Value>ResultFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachineConclusionD</DataLocation>
<DefaultData>RPMachineConclusionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPMachineConclusionD</IdLocation>
<IndexLocation>^dbo.RPMachineConclusionI</IndexLocation>
<StreamLocation>^dbo.RPMachineConclusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
