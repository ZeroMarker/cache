Class User.CSSDPackageItem Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_PackageItem ]
{

Property CSSDPIQty As %Numeric [ SqlColumnNumber = 4, SqlFieldName = CSSDPI_Qty ];

Property CSSDPIRowid As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDPI_Rowid ];

Property CSSDPIUomDR As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CSSDPI_Uom_DR ];

Property CSSDPIItmDR As User.CSSDItem [ SqlColumnNumber = 7, SqlFieldName = CSSDPI_Itm_DR ];

Property CSSDPIPackage As User.CSSDPackage [ SqlColumnNumber = 8, SqlFieldName = CSSDPI_Package_DR ];

Property CSSDPISORT As %Integer [ SqlColumnNumber = 9, SqlFieldName = CSSDPI_SORT ];

Index CSSDPIPackageIndex On CSSDPIPackage As Exact;

Index CSSDPIRowidIndex On CSSDPIRowid As Exact;

Index CSSDPIItmDRIndex On CSSDPIItmDR As Exact;

Index CSSDPIPackageItmIndex On (CSSDPIPackage As Exact, CSSDPIItmDR As Exact);

Storage Default
{
<Data name="CSSDPackageItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2"/>
<Value name="3"/>
<Value name="4">
<Value>CSSDPIQty</Value>
</Value>
<Value name="5">
<Value>CSSDPIRowid</Value>
</Value>
<Value name="6">
<Value>CSSDPIUomDR</Value>
</Value>
<Value name="7">
<Value>CSSDPIItmDR</Value>
</Value>
<Value name="8">
<Value>CSSDPIPackage</Value>
</Value>
<Value name="9">
<Value>CSSDPISORT</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageItemD</DataLocation>
<DefaultData>CSSDPackageItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackageItemD</IdLocation>
<IndexLocation>^User.CSSDPackageItemI</IndexLocation>
<StreamLocation>^User.CSSDPackageItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
