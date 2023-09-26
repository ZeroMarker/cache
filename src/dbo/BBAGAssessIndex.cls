///     
Class dbo.BBAGAssessIndex Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AGAssessIndex, StorageStrategy = Default ]
{

/// Foreign Key FKAGAssessIndexHospital created via DDL
ForeignKey FKAGAssessIndexHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_AGAssessIndex_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBAGASSESSINDEX On RowID [ PrimaryKey, SqlName = PK_BB_AGASSESSINDEX, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBAGAssessIndexDefaultData">
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
<DataLocation>^dbo.BBAGAssessIndexD</DataLocation>
<DefaultData>BBAGAssessIndexDefaultData</DefaultData>
<IdLocation>^dbo.BBAGAssessIndexD</IdLocation>
<IndexLocation>^dbo.BBAGAssessIndexI</IndexLocation>
<StreamLocation>^dbo.BBAGAssessIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
