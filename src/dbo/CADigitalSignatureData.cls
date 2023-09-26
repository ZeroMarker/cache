Class dbo.CADigitalSignatureData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = CA_DigitalSignatureData, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberCarryUser created via DDL
ForeignKey FKDigitalSignatureDataAddUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_DigitalSignatureDataAddUser ];

Index IndexType On (Type, AddDate) [ SqlName = Index_Type, Type = index ];

Index IndexAddDate On (AddDate, Type, DataRowID) [ SqlName = Index_AddDate, Type = index ];

Index IndexDataRowID On (Type, DataRowID) [ SqlName = Index_DataRowID, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property SignData As %Library.String(COLLATION = "Exact", MAXLEN = 10000) [ SqlColumnNumber = 8 ];

Property SignTimeStamp As %Library.String(COLLATION = "Exact", MAXLEN = 999999) [ SqlColumnNumber = 9 ];

Property Cert As %Library.String(COLLATION = "Exact", MAXLEN = 999999) [ SqlColumnNumber = 10 ];

Property CertID As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 11 ];

Property PubKeyEncryptData As %Library.String(COLLATION = "Exact", MAXLEN = 999999) [ SqlColumnNumber = 12 ];

Property OrgData As %Library.String(COLLATION = "Exact", MAXLEN = 999999) [ SqlColumnNumber = 13 ];

Property DataRowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = 0) [ SqlColumnNumber = 14 ];

Property IsValid As %Library.Boolean [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="CADigitalSignatureDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>UserDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>SignDate</Value>
</Value>
<Value name="7">
<Value>SignTimeStamp</Value>
</Value>
<Value name="8">
<Value>Cert</Value>
</Value>
<Value name="9">
<Value>CertID</Value>
</Value>
<Value name="10">
<Value>PubKeyEncryptData</Value>
</Value>
<Value name="11">
<Value>OrgData</Value>
</Value>
<Value name="12">
<Value>DataRowID</Value>
</Value>
<Value name="13">
<Value>SignData</Value>
</Value>
<Value name="14">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dbo.CADigitalSignatureDataD</DataLocation>
<DefaultData>CADigitalSignatureDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.CADigitalSignatureDataD</IdLocation>
<IndexLocation>^dbo.CADigitalSignatureDataI</IndexLocation>
<StreamLocation>^dbo.CADigitalSignatureDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
