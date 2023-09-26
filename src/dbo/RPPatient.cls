Class dbo.RPPatient Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_Patient, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberSpecies created via DDL
ForeignKey FKRPPatientSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_RPPatientSpecies ];

Index IndexMaster On RegNo [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKRPPATIENT On RowID [ PrimaryKey, SqlName = PK_RP_PATIENT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 姓名  
Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 别名  
Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 出生日期  
Property BirthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 出生时间  
Property BirthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// A,B,O,AB,不确定：I
Property ABO As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 9 ];

/// P,N,不确定：I
Property RH As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 10 ];

/// Rh表型
Property Phenotype As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 11 ];

/// ABO亚型
Property ABOSubGroup As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 12 ];

/// 手机号
Property MobileNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 13 ];

/// 地址
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 14 ];

/// 邮编
Property PostCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

/// 身份证号
Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// 最后更细日期  
Property LastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 最后更新时间  
Property LastTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="RPPatientDefaultData">
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
<Value>ABO</Value>
</Value>
<Value name="9">
<Value>RH</Value>
</Value>
<Value name="10">
<Value>Phenotype</Value>
</Value>
<Value name="11">
<Value>ABOSubGroup</Value>
</Value>
<Value name="12">
<Value>MobileNo</Value>
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
<Value name="16">
<Value>LastDate</Value>
</Value>
<Value name="17">
<Value>LastTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPPatientD</DataLocation>
<DefaultData>RPPatientDefaultData</DefaultData>
<IdLocation>^dbo.RPPatientD</IdLocation>
<IndexLocation>^dbo.RPPatientI</IndexLocation>
<StreamLocation>^dbo.RPPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
