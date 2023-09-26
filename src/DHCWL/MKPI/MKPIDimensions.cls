/// DHCWL_MKPI.DHCWLMKPIDim d ##class(DHCWL.MKPI.MKPIDimensions).%BuildIndices()
Class DHCWL.MKPI.MKPIDimensions Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLMKPIDim ]
{

Property MKPIDimCode As %String [ SqlColumnNumber = 2, SqlFieldName = MKPIDim_Code ];

Property MKPIDr As DHCWL.MKPI.MKPI [ SqlColumnNumber = 3, SqlFieldName = MKPI_Dr ];

Property MKPIDimDes As %String [ SqlColumnNumber = 4, SqlFieldName = MKPIDim_Des ];

Property MKPIDimDimDr As DHCWL.MKPI.MKPIDimType [ SqlColumnNumber = 5, SqlFieldName = MKPIDim_DimDr ];

Property MKPIDimOrder As %Integer [ SqlColumnNumber = 6, SqlFieldName = MKPIDim_Order ];

Property MKPIDimDeli As %String [ SqlColumnNumber = 7, SqlFieldName = MKPIDim_Deli ];

Index MKPIDimCodeI On (MKPIDr, MKPIDimCode As AlphaUp);

Index MKPIDimKPII On (MKPIDr, MKPIDimDimDr);

Index DimAndOrderI On (MKPIDimDimDr, MKPIDimOrder);

Index KPIOrderI On (MKPIDr, MKPIDimOrder);

Storage Default
{
<Data name="MKPIDimensionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKPIDimCode</Value>
</Value>
<Value name="3">
<Value>MKPIDr</Value>
</Value>
<Value name="4">
<Value>MKPIDimDes</Value>
</Value>
<Value name="5">
<Value>MKPIDimDimDr</Value>
</Value>
<Value name="6">
<Value>MKPIDimOrder</Value>
</Value>
<Value name="7">
<Value>MKPIDimDeli</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MKPIDimensionsD</DataLocation>
<DefaultData>MKPIDimensionsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MKPIDimensionsD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MKPIDimensionsI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MKPIDimensionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
