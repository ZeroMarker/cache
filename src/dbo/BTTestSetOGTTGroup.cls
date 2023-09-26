///     
Class dbo.BTTestSetOGTTGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetOGTTGroup, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTTestSetOGTTGroup On RowID [ PrimaryKey, SqlName = PK_BT_TestSetOGTTGroup, Type = index, Unique ];

/// Foreign Key FKBTTestSetOGTTGroupBTHospital created via DDL
ForeignKey FKBTTestSetOGTTGroupBTHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BT_TestSetOGTTGroup_BT_Hospital ];

/// Foreign Key FKBTTestSetOGTTGroupBTTestSet created via DDL
ForeignKey FKBTTestSetOGTTGroupBTTestSet(MainTestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BT_TestSetOGTTGroup_BT_TestSet ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property MainTestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTTestSetOGTTGroupDefaultData">
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
<Value>MainTestSetDR</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetOGTTGroupD</DataLocation>
<DefaultData>BTTestSetOGTTGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestSetOGTTGroupD</IdLocation>
<IndexLocation>^dbo.BTTestSetOGTTGroupI</IndexLocation>
<StreamLocation>^dbo.BTTestSetOGTTGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
