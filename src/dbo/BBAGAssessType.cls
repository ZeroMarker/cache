///     
Class dbo.BBAGAssessType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AGAssessType, StorageStrategy = Default ]
{

/// Foreign Key FKAGAssessTypeHospital created via DDL
ForeignKey FKAGAssessTypeHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_AGAssessType_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBAGASSESSTYPE On RowID [ PrimaryKey, SqlName = PK_BB_AGASSESSTYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property AGType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBAGAssessTypeDefaultData">
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
<Value>AGType</Value>
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
<DataLocation>^dbo.BBAGAssessTypeD</DataLocation>
<DefaultData>BBAGAssessTypeDefaultData</DefaultData>
<IdLocation>^dbo.BBAGAssessTypeD</IdLocation>
<IndexLocation>^dbo.BBAGAssessTypeI</IndexLocation>
<StreamLocation>^dbo.BBAGAssessTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
