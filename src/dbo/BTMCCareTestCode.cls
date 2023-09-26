///     
Class dbo.BTMCCareTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_CareTestCode ]
{

/// Foreign Key FKBTMCCareTestCodeTestCodeDR created via DDL
ForeignKey FKBTMCCareTestCodeTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTMCCareTestCodeTestCodeDR ];

Index IndexSequence On (Sequence, TestCodeDR) [ SqlName = Index_Sequence, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMCCARETESTCODE On RowID [ PrimaryKey, SqlName = PK_BTMC_CARETESTCODE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTMCCareTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCCareTestCodeD</DataLocation>
<DefaultData>BTMCCareTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.BTMCCareTestCodeD</IdLocation>
<IndexLocation>^dbo.BTMCCareTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTMCCareTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
