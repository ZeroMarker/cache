/// 仪器抗生素结果
Class dbo.RPMachineResultAnt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachineResultAnt, StorageStrategy = Default ]
{

/// Foreign Key FKMachineResultAnt created via DDL
ForeignKey FKMachineResultAnt(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_MachineResultAnt ];

/// Foreign Key FKMachineResultAntMi created via DDL
ForeignKey FKMachineResultAntMi(MachineResultDR) References dbo.RPMachineResult(PKRPMACHINERESULT) [ SqlName = FK_MachineResultAntMi ];

/// Foreign Key FKMachineResultAntRes created via DDL
ForeignKey FKMachineResultAntRes(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_MachineResultAntRes ];

/// Foreign Key FKAntibioticsClassDR created via DDLAntibioticsClassDR
ForeignKey FKAntibioticsClassDR(AntibioticsClassDR) References dbo.BTAntibioticsClass(PKBTAntibioticsClass) [ SqlName = PK_BTAntibioticsClass ];

Index IndexMaster On (MachineResultDR, AntibioticsDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPMACHINERESULTANT On RowID [ PrimaryKey, SqlName = PK_RP_MACHINERESULTANT, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器结果  
Property MachineResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 药敏结果  
Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// MICResult  
Property MICResult As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// MmResult  
Property MmResult As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

///       
Property IRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

///       
Property SRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

///       
Property RRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

///       
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

///       
Property AntibioticsClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

///       
Property ExpertRuleID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="RPMachineResultAntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineResultDR</Value>
</Value>
<Value name="3">
<Value>AntibioticsDR</Value>
</Value>
<Value name="4">
<Value>SensitivityDR</Value>
</Value>
<Value name="5">
<Value>MICResult</Value>
</Value>
<Value name="6">
<Value>MmResult</Value>
</Value>
<Value name="7">
<Value>IRanges</Value>
</Value>
<Value name="8">
<Value>SRanges</Value>
</Value>
<Value name="9">
<Value>RRanges</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>AntibioticsClassDR</Value>
</Value>
<Value name="12">
<Value>ExpertRuleID</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachineResultAntD</DataLocation>
<DefaultData>RPMachineResultAntDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPMachineResultAntD</IdLocation>
<IndexLocation>^dbo.RPMachineResultAntI</IndexLocation>
<StreamLocation>^dbo.RPMachineResultAntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
