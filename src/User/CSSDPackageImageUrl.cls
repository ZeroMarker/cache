Class User.CSSDPackageImageUrl Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_PackageImageUrl ]
{

Property CSSDPIPacakgeDr As User.CSSDPackage [ Required, SqlColumnNumber = 2, SqlFieldName = CSSDPI_PackageDr ];

Property CSSDPIImageUrl As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDPI_ImageUrl ];

Property CSSDPIType As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDPI_Type ];

Property CSSDPIFileName As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDPI_FileName ];

Storage Default
{
<Data name="CSSDPackageImageUrlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPIPacakgeDr</Value>
</Value>
<Value name="3">
<Value>CSSDPIImageUrl</Value>
</Value>
<Value name="4">
<Value>CSSDPIType</Value>
</Value>
<Value name="5">
<Value>CSSDPIFileName</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageImageUrlD</DataLocation>
<DefaultData>CSSDPackageImageUrlDefaultData</DefaultData>
<IdLocation>^User.CSSDPackageImageUrlD</IdLocation>
<IndexLocation>^User.CSSDPackageImageUrlI</IndexLocation>
<StreamLocation>^User.CSSDPackageImageUrlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
