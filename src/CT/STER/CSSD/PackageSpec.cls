Class CT.STER.CSSD.PackageSpec Extends (%Persistent, User.Abstract) [ SqlTableName = PackageSpec ]
{

/// 规格编码
Property PSSpecCode As %Library.String(COLLATION = "Exact", TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PS_SpecCode ];

/// 规格描述
Property PSSpecDesc As %Library.String(COLLATION = "Exact", TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PS_SpecDesc ];

/// 是否可用
Property PSSpecUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = PS_SpecUseFlag ];

Index SpecCodeIndex On PSSpecCode As Exact;

Index SpecDescIndex On PSSpecDesc As Exact;

Storage Default
{
<Data name="PackageSpecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PSSpecCode</Value>
</Value>
<Value name="3">
<Value>PSSpecDesc</Value>
</Value>
<Value name="4">
<Value>PSSpecUseFlag</Value>
</Value>
</Data>
<DataLocation>^CT.STER.CSSD.PackageSpecD</DataLocation>
<DefaultData>PackageSpecDefaultData</DefaultData>
<IdLocation>^CT.STER.CSSD.PackageSpecD</IdLocation>
<IndexLocation>^CT.STER.CSSD.PackageSpecI</IndexLocation>
<StreamLocation>^CT.STER.CSSD.PackageSpecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
