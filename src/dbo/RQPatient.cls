/// 申请患者信息
Class dbo.RQPatient Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RQ_Patient, StorageStrategy = Default ]
{

/// Foreign Key FKPatientABO created via DDL
ForeignKey FKPatientABO(AboDR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_PatientABO ];

/// Foreign Key FKPatientRH created via DDL
ForeignKey FKPatientRH(RhDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_PatientRH ];

/// Foreign Key FKPatientSex created via DDL
ForeignKey FKPatientSex(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_PatientSex ];

Index IndexIDNumber On IDNumber [ SqlName = Index_IDNumber, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRQPATIENT On RowID [ PrimaryKey, SqlName = PK_RQ_PATIENT, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 姓名  
Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 别名  
Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 出生日期  
Property BirthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 出生时间  
Property BirthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// ABO血型  
Property AboDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// RH血型  
Property RhDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 手机号  
Property MobileNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 11 ];

/// 座机号  
Property PhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 12 ];

/// email  
Property EMail As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 13 ];

/// 地址  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 14 ];

/// 邮编  
Property PostCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

/// 身份证号  
Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="RQPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegNo</Value>
</Value>
<Value name="3">
<Value>SurName</Value>
</Value>
<Value name="4">
<Value>GivenName</Value>
</Value>
<Value name="5">
<Value>SpeciesDR</Value>
</Value>
<Value name="6">
<Value>BirthDate</Value>
</Value>
<Value name="7">
<Value>BirthTime</Value>
</Value>
<Value name="8">
<Value>AboDR</Value>
</Value>
<Value name="9">
<Value>RhDR</Value>
</Value>
<Value name="10">
<Value>MobileNo</Value>
</Value>
<Value name="11">
<Value>PhoneNo</Value>
</Value>
<Value name="12">
<Value>EMail</Value>
</Value>
<Value name="13">
<Value>Address</Value>
</Value>
<Value name="14">
<Value>PostCode</Value>
</Value>
<Value name="15">
<Value>IDNumber</Value>
</Value>
</Data>
<DataLocation>^dbo.RQPatientD</DataLocation>
<DefaultData>RQPatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RQPatientD</IdLocation>
<IndexLocation>^dbo.RQPatientI</IndexLocation>
<StreamLocation>^dbo.RQPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
