///     
Class dbo.BTMCMedium Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_Medium, StorageStrategy = Default ]
{

/// Foreign Key FKMCMediumHospital created via DDL
ForeignKey FKMCMediumHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_MC_Medium_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTMCMEDIUM On RowID [ PrimaryKey, SqlName = PK_BTMC_MEDIUM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property Condition As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property Label As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ InitialExpression = 1, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTMCMediumDefaultData">
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
<Value>Condition</Value>
</Value>
<Value name="5">
<Value>Label</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCMediumD</DataLocation>
<DefaultData>BTMCMediumDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMCMediumD</IdLocation>
<IndexLocation>^dbo.BTMCMediumI</IndexLocation>
<StreamLocation>^dbo.BTMCMediumS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
