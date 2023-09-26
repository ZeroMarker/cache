Class dbo.BTRUAntibiotics Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRU_Antibiotics ]
{

/// Foreign Key FKAntibioticsClass created via DDL
ForeignKey FKAntibioticsClass(AntibioticsClassDR) References dbo.BTAntibioticsClass(PKBTAntibioticsClass) [ SqlName = FK_AntibioticsClass ];

/// Foreign Key FKAntibioticsKindDR created via DDL
ForeignKey FKAntibioticsKindDR(AntibioticsKindDR) References dbo.BTAntibioticsKind(PKBTANTIBIOTICSKIND) [ SqlName = FK_AntibioticsKind ];

Index IndexAntibioticsClass On AntibioticsClassDR [ SqlName = Index_AntibioticsClass, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexWCode On WCode [ SqlName = Index_WCode, Type = index ];

/// DDL Primary Key Specification
Index PKBTRUANTIBIOTICS On RowID [ PrimaryKey, SqlName = PK_BT_ANTIBIOTICS, Type = index, Unique ];

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

Storage Default
{
<Data name="BTRUAntibioticsDefaultData">
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
</Data>
<DataLocation>^dbo.BTRUAntibioticsD</DataLocation>
<DefaultData>BTRUAntibioticsDefaultData</DefaultData>
<IdLocation>^dbo.BTRUAntibioticsD</IdLocation>
<IndexLocation>^dbo.BTRUAntibioticsI</IndexLocation>
<StreamLocation>^dbo.BTRUAntibioticsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
