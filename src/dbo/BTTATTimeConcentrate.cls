///     
Class dbo.BTTATTimeConcentrate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTimeConcentrate, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTTATTIMECONCENTRATE On RowID [ PrimaryKey, SqlName = PK_BT_TATTIMECONCENTRATE, Type = index, Unique ];

/// Foreign Key FKTATConcentrateHospital created via DDL
ForeignKey FKTATConcentrateHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TATConcentrateHospital ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTTATTimeConcentrateDefaultData">
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
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTimeConcentrateD</DataLocation>
<DefaultData>BTTATTimeConcentrateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTATTimeConcentrateD</IdLocation>
<IndexLocation>^dbo.BTTATTimeConcentrateI</IndexLocation>
<StreamLocation>^dbo.BTTATTimeConcentrateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
