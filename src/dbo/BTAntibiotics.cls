///     
Class dbo.BTAntibiotics Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Antibiotics, StorageStrategy = Default ]
{

/// Foreign Key FKAntibioticsGroup created via DDLAntibioticsClassDR
ForeignKey FKAntibioticsGroup(AntibioticsGroupDR) References dbo.BTAntibioticsGroup(PKBTAntibioticsGroup) [ SqlName = FK_AntibioticsGroup ];

/// Foreign Key FKAntibioticsClass created via DDL
ForeignKey FKAntibioticsClass(AntibioticsClassDR) References dbo.BTAntibioticsClass(PKBTAntibioticsClass) [ SqlName = FK_AntibioticsClass ];

/// Foreign Key FKAntibioticsKindDR created via DDL
ForeignKey FKAntibioticsKindDR(AntibioticsKindDR) References dbo.BTAntibioticsKind(PKBTANTIBIOTICSKIND) [ SqlName = FK_AntibioticsKind ];

Index IndexAntibioticsClass On AntibioticsClassDR [ SqlName = Index_AntibioticsClass, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexWCode On WCode [ SqlName = Index_WCode, Type = index ];

Index IndexAntibioticsKind On AntibioticsKindDR [ SqlName = Index_AntibioticsKind, Type = index ];

Index IndexLISCode On LISCode [ SqlName = Index_LISCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTANTIBIOTICS On RowID [ PrimaryKey, SqlName = PK_BT_ANTIBIOTICS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property SName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property WCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property WhoND As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Property WhoNM As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

Property WhoNE As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 10 ];

Property Potency As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

Property Dosage1 As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

Property Surem1 As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 13 ];

Property Urine1 As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 14 ];

Property Dosage2 As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 15 ];

Property Surem2 As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 16 ];

Property Urine2 As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 17 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 19 ];

Property AntibioticsClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property AntibioticsKindDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property AntibioticsGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property FitMethod As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 23 ];

Property LISCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 24 ];

Property IsCLSI As %Library.Boolean [ SqlColumnNumber = 25 ];

Storage Default
{
<Data name="BTAntibioticsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>EName</Value>
</Value>
<Value name="5">
<Value>SName</Value>
</Value>
<Value name="6">
<Value>WCode</Value>
</Value>
<Value name="7">
<Value>WhoND</Value>
</Value>
<Value name="8">
<Value>WhoNM</Value>
</Value>
<Value name="9">
<Value>WhoNE</Value>
</Value>
<Value name="10">
<Value>Potency</Value>
</Value>
<Value name="11">
<Value>Dosage1</Value>
</Value>
<Value name="12">
<Value>Surem1</Value>
</Value>
<Value name="13">
<Value>Urine1</Value>
</Value>
<Value name="14">
<Value>Dosage2</Value>
</Value>
<Value name="15">
<Value>Surem2</Value>
</Value>
<Value name="16">
<Value>Urine2</Value>
</Value>
<Value name="17">
<Value>Sequence</Value>
</Value>
<Value name="18">
<Value>Active</Value>
</Value>
<Value name="19">
<Value>AntibioticsClassDR</Value>
</Value>
<Value name="20">
<Value>AntibioticsKindDR</Value>
</Value>
<Value name="21">
<Value>AntibioticsGroupDR</Value>
</Value>
<Value name="22">
<Value>FitMethod</Value>
</Value>
<Value name="23">
<Value>LISCode</Value>
</Value>
<Value name="24">
<Value>IsCLSI</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAntibioticsD</DataLocation>
<DefaultData>BTAntibioticsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTAntibioticsD</IdLocation>
<IndexLocation>^dbo.BTAntibioticsI</IndexLocation>
<StreamLocation>^dbo.BTAntibioticsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
