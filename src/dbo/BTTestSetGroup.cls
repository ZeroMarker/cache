///     
Class dbo.BTTestSetGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetGroup, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = IndexCode, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = IndexSeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBTTestSetGroup On RowID [ PrimaryKey, SqlName = PK_BT_TestSetGroup, Type = index, Unique ];

/// Foreign Key FKTestSetGroupHosp created via DDL
ForeignKey FKTestSetGroupHosp(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TestSetGroupHosp ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTTestSetGroupDefaultData">
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
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetGroupD</DataLocation>
<DefaultData>BTTestSetGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestSetGroupD</IdLocation>
<IndexLocation>^dbo.BTTestSetGroupI</IndexLocation>
<StreamLocation>^dbo.BTTestSetGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
