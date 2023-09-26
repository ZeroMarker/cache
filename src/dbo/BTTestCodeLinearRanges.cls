Class dbo.BTTestCodeLinearRanges Extends %Persistent [ SqlTableName = BT_TestCodeLinearRanges ]
{

Index IndexMachineParameter On (MachineParameterDR, TestCodeDR) [ SqlName = Index_MachineParameter, Type = index ];

Index IndexMaster On (TestCodeDR, OrderNo) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTESTCODELINEARRANGES On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODELINEARRANGES, Type = index, Unique ];

/// Foreign Key FKTestCodeLRTC created via DDL
ForeignKey FKTestCodeLRTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeLRTC ];

/// Foreign Key FKTestCodeLRMachine created via DDL
ForeignKey FKTestCodeLRMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_TestCodeLRMachine ];

/// Foreign Key FKTestCodeLRClinic created via DDL
ForeignKey FKTestCodeLRClinic(ClinicalConditionsDR) References dbo.BTClinicalConditions(PKBTCLINICALCONDITIONS) [ SqlName = FK_TestCodeLRClinic ];

/// Foreign Key FKTestCodeLRLoc created via DDL
ForeignKey FKTestCodeLRLoc(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_TestCodeLRLoc ];

/// Foreign Key FKTestCodeLRSex created via DDL
ForeignKey FKTestCodeLRSex(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_TestCodeLRSex ];

/// Foreign Key FKTestCodeLRSpecimen created via DDL
ForeignKey FKTestCodeLRSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_TestCodeLRSpecimen ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AgeLow As %Library.Float [ SqlColumnNumber = 4 ];

Property AgeHigh As %Library.Float [ SqlColumnNumber = 5 ];

Property ValueLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property ValueHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ClinicalConditionsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 14 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTTestCodeLinearRangesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>AgeLow</Value>
</Value>
<Value name="4">
<Value>AgeHigh</Value>
</Value>
<Value name="5">
<Value>ValueLow</Value>
</Value>
<Value name="6">
<Value>ValueHigh</Value>
</Value>
<Value name="7">
<Value>SpecimenDR</Value>
</Value>
<Value name="8">
<Value>ClinicalConditionsDR</Value>
</Value>
<Value name="9">
<Value>LocationDR</Value>
</Value>
<Value name="10">
<Value>MachineParameterDR</Value>
</Value>
<Value name="11">
<Value>SpeciesDR</Value>
</Value>
<Value name="12">
<Value>RefRanges</Value>
</Value>
<Value name="13">
<Value>OrderNo</Value>
</Value>
<Value name="14">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeLinearRangesD</DataLocation>
<DefaultData>BTTestCodeLinearRangesDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeLinearRangesD</IdLocation>
<IndexLocation>^dbo.BTTestCodeLinearRangesI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeLinearRangesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
