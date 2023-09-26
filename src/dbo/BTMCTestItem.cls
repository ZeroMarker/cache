///     
Class dbo.BTMCTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_TestItem, StorageStrategy = Default ]
{

/// Foreign Key FKMCTestItemHospital created via DDL
ForeignKey FKMCTestItemHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_MC_TestItem_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTMCTESTITEM On RowID [ PrimaryKey, SqlName = PK_BTMC_TESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 5 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property ResultType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property UpperLimit As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property LowerLimit As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Property ValueList As %Library.String(COLLATION = "Exact", MAXLEN = 400) [ SqlColumnNumber = 12 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property Active As %Library.Boolean [ InitialExpression = 1, SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTMCTestItemDefaultData">
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
<Value>Unit</Value>
</Value>
<Value name="6">
<Value>ResultType</Value>
</Value>
<Value name="7">
<Value>UpperLimit</Value>
</Value>
<Value name="8">
<Value>LowerLimit</Value>
</Value>
<Value name="9">
<Value>RefRanges</Value>
</Value>
<Value name="10">
<Value>HospitalDR</Value>
</Value>
<Value name="11">
<Value>ValueList</Value>
</Value>
<Value name="12">
<Value>Sequence</Value>
</Value>
<Value name="13">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCTestItemD</DataLocation>
<DefaultData>BTMCTestItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMCTestItemD</IdLocation>
<IndexLocation>^dbo.BTMCTestItemI</IndexLocation>
<StreamLocation>^dbo.BTMCTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
