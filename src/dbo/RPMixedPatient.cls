Class dbo.RPMixedPatient Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MixedPatient, StorageStrategy = Default ]
{

Index IndexMaster On (MixedDR, CollOrder) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexCertNo On (CertNo, CertType, CollDate) [ SqlName = Index_CertNo, Type = index ];

Index PKRPMIXEDPATIENT On RowID [ PrimaryKey, SqlName = PK_RP_MIXEDPATIENT, Type = index, Unique ];

/// Foreign Key FKRPMixedPatientMixed created via DDL
ForeignKey FKRPMixedPatientMixed(MixedDR) References dbo.RPMixed(PKRPMIXED) [ SqlName = FK_RP_MixedPatientMixed ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 混检条码
Property MixedDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 采集序号
Property CollOrder As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 姓名
Property SurName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 别名
Property GivenName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 6 ];

/// 证件类型 {1：省份证，2：护照，3：军官证}
Property CertType As %Library.TinyInt [ SqlColumnNumber = 7 ];

/// 证件号码
Property CertNo As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ SqlColumnNumber = 8 ];

/// 手机号
Property MobileNo As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 地址
Property Address As %Library.String(COLLATION = "EXACT", MAXLEN = 150) [ SqlColumnNumber = 10 ];

/// 采集日期
Property CollDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 采集时间
Property CollTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="RPMixedPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MixedDR</Value>
</Value>
<Value name="3">
<Value>CollOrder</Value>
</Value>
<Value name="4">
<Value>SurName</Value>
</Value>
<Value name="5">
<Value>GivenName</Value>
</Value>
<Value name="6">
<Value>CertType</Value>
</Value>
<Value name="7">
<Value>CertNo</Value>
</Value>
<Value name="8">
<Value>MobileNo</Value>
</Value>
<Value name="9">
<Value>Address</Value>
</Value>
<Value name="10">
<Value>CollDate</Value>
</Value>
<Value name="11">
<Value>CollTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMixedPatientD</DataLocation>
<DefaultData>RPMixedPatientDefaultData</DefaultData>
<IdLocation>^dbo.RPMixedPatientD</IdLocation>
<IndexLocation>^dbo.RPMixedPatientI</IndexLocation>
<StreamLocation>^dbo.RPMixedPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
