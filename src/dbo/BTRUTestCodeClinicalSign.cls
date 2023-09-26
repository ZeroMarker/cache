Class dbo.BTRUTestCodeClinicalSign Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRU_TestCodeClinicalSign ]
{

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKBTRUTestCodeClinicalSignRUTestCode(RUTestCodeDR) References dbo.BTRUTestCode(PKBTRUTestCode) [ SqlName = FK_BTRUTestCodeClinicalSignRUTestCode ];

/// DDL Primary Key Specification
Index PKBTRUTestCodeClinicalSign On RowID [ PrimaryKey, SqlName = PK_BT_RUTestCodeClinicalSign, Type = index, Unique ];

Index IndexMaster On (RUTestCodeDR, ResultType) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (RUTestCodeDR, Sequence) [ SqlName = Index_Sequence, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RUTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property ResultType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 4 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTRUTestCodeClinicalSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RUTestCodeDR</Value>
</Value>
<Value name="3">
<Value>ResultType</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRUTestCodeClinicalSignD</DataLocation>
<DefaultData>BTRUTestCodeClinicalSignDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRUTestCodeClinicalSignD</IdLocation>
<IndexLocation>^dbo.BTRUTestCodeClinicalSignI</IndexLocation>
<StreamLocation>^dbo.BTRUTestCodeClinicalSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
