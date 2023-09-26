Class dbo.BBAssessIndex Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AssessIndex ]
{

/// Foreign Key FKBBAgreeTestItemHospital created via DDL
ForeignKey FKBBAssessIndexHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_AssessIndex_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBASSESSINDEX On RowID [ PrimaryKey, SqlName = PK_BB_BBAssessIndex, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property IndexType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBAssessIndexDefaultData">
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
<Value>IndexType</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAssessIndexD</DataLocation>
<DefaultData>BBAssessIndexDefaultData</DefaultData>
<IdLocation>^dbo.BBAssessIndexD</IdLocation>
<IndexLocation>^dbo.BBAssessIndexI</IndexLocation>
<StreamLocation>^dbo.BBAssessIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
