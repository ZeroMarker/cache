Class dbo.BTRUTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRU_TestCode ]
{

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKRUTestCodeTestCodeType(TestCodeTypeDR) References dbo.BTRUTestCodeType(PKBTRUTestCodeType) [ SqlName = FK_RUTestCodeTestCodeType ];

/// DDL Primary Key Specification
Index PKBTRUTestCode On RowID [ PrimaryKey, SqlName = PK_BT_RUTestCode, Type = index, Unique ];

Index IndexMaster On (TestCodeSCode, VersionNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 3 ];

Property VersionNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

Property TestCodeTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

Property Sync As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 9 ];

Property TestPrinciple As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 10 ];

Property Explanation As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 11 ];

Property NormalRanges As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 12 ];

Property ClinicalSign As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 13 ];

Property Attentions As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 14 ];

Property Specimens As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 15 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BTRUTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeSCode</Value>
</Value>
<Value name="3">
<Value>VersionNo</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>TestCodeTypeDR</Value>
</Value>
<Value name="6">
<Value>EName</Value>
</Value>
<Value name="7">
<Value>Sync</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
<Value name="9">
<Value>TestPrinciple</Value>
</Value>
<Value name="10">
<Value>Explanation</Value>
</Value>
<Value name="11">
<Value>NormalRanges</Value>
</Value>
<Value name="12">
<Value>ClinicalSign</Value>
</Value>
<Value name="13">
<Value>Attentions</Value>
</Value>
<Value name="14">
<Value>Specimens</Value>
</Value>
<Value name="15">
<Value>Sequence</Value>
</Value>
<Value name="16">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRUTestCodeD</DataLocation>
<DefaultData>BTRUTestCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRUTestCodeD</IdLocation>
<IndexLocation>^dbo.BTRUTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTRUTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
