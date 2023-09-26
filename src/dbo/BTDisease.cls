///     
Class dbo.BTDisease Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Disease, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (CodeClass, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexRUDiseaseDR On RUDiseaseDR [ SqlName = Index_RUDiseaseDR, Type = index ];

Index IndexDiseaseTypeDR On DiseaseTypeDR [ SqlName = Index_DiseaseTypeDR, Type = index ];

/// DDL Primary Key Specification
Index PKBTDISEASE On RowID [ PrimaryKey, SqlName = PK_BT_DISEASE, Type = index, Unique ];

/// Foreign Key FKDisease created via DDL
ForeignKey FKDisease(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_Disease ];

/// Foreign Key FKDiseaseType created via DDL
ForeignKey FKDiseaseType(DiseaseTypeDR) References dbo.BTDiseaseType(PKBTDiseaseType) [ SqlName = FK_DiseaseType ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property CodeClass As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 5 ];

Property LName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7 ];

Property Serious As %Library.Boolean [ SqlColumnNumber = 8 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property AgeLow As %Library.Float [ SqlColumnNumber = 10 ];

Property AgeHigh As %Library.Float [ SqlColumnNumber = 11 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 13 ];

Property RUDiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property DiseaseTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTDiseaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CodeClass</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>LName</Value>
</Value>
<Value name="6">
<Value>EName</Value>
</Value>
<Value name="7">
<Value>Serious</Value>
</Value>
<Value name="8">
<Value>SpeciesDR</Value>
</Value>
<Value name="9">
<Value>AgeLow</Value>
</Value>
<Value name="10">
<Value>AgeHigh</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
<Value name="12">
<Value>Active</Value>
</Value>
<Value name="13">
<Value>RUDiseaseDR</Value>
</Value>
<Value name="14">
<Value>DiseaseTypeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDiseaseD</DataLocation>
<DefaultData>BTDiseaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTDiseaseD</IdLocation>
<IndexLocation>^dbo.BTDiseaseI</IndexLocation>
<StreamLocation>^dbo.BTDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
