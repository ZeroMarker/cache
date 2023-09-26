Class dbo.BTRUTestCodeDisease Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRU_TestCodeDisease ]
{

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKRUTestCodeDiseaseRUTestCode(RUTestCodeDR) References dbo.BTRUTestCode(PKBTRUTestCode) [ SqlName = FK_RUTestCodeDiseaseRUTestCode ];

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKRUTestCodeDiseaseRUDisease(RUDiseaseDR) References dbo.BTRUDisease(PKBTRUDisease) [ SqlName = FK_RUTestCodeDiseaseRUDisease ];

/// DDL Primary Key Specification
Index PKBTRUTestCodeDisease On RowID [ PrimaryKey, SqlName = PK_BT_RUTestCodeDisease, Type = index, Unique ];

Index IndexMaster On (RUTestCodeDR, RUDiseaseDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RUTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property RUDiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTRUTestCodeDiseaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RUTestCodeDR</Value>
</Value>
<Value name="3">
<Value>RUDiseaseDR</Value>
</Value>
<Value name="4">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRUTestCodeDiseaseD</DataLocation>
<DefaultData>BTRUTestCodeDiseaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRUTestCodeDiseaseD</IdLocation>
<IndexLocation>^dbo.BTRUTestCodeDiseaseI</IndexLocation>
<StreamLocation>^dbo.BTRUTestCodeDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
