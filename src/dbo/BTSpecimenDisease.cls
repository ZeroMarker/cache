///     
Class dbo.BTSpecimenDisease Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SpecimenDisease ]
{

/// DDL Primary Key Code
Index IndexMaster On (SpeWCode, RUDiseaseDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBTSpecimenDiseaseRUDiseaseDR created via DDL
ForeignKey FKBTSpecimenDiseaseRUDiseaseDR(RUDiseaseDR) References dbo.BTRUDisease(PKBTRUDisease) [ SqlName = FK_BTSpecimenDiseaseRUDiseaseDR ];

/// DDL Primary Key Specification
Index PKBTSPECIMENDISEASE On RowID [ PrimaryKey, SqlName = PK_BT_SPECIMENDISEASE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SpeWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 3 ];

Property RUDiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTSpecimenDiseaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpeWCode</Value>
</Value>
<Value name="3">
<Value>RUDiseaseDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSpecimenDiseaseD</DataLocation>
<DefaultData>BTSpecimenDiseaseDefaultData</DefaultData>
<IdLocation>^dbo.BTSpecimenDiseaseD</IdLocation>
<IndexLocation>^dbo.BTSpecimenDiseaseI</IndexLocation>
<StreamLocation>^dbo.BTSpecimenDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
