/// DHCWL_MKPI.DHCWLDimProperty  d ##class(DHCWL.MKPI.DimProperty).%BuildIndices()
Class DHCWL.MKPI.DimProperty Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLDimProperty ]
{

Property Code As %String [ SqlColumnNumber = 2, SqlFieldName = DimPro_Code ];

Property Name As %String [ SqlColumnNumber = 3, SqlFieldName = DimPro_Name ];

Property Desc As %String [ SqlColumnNumber = 4, SqlFieldName = DimPro_Desc ];

Property ExcuteCode As %String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = DimPro_ExcCode ];

Property DimDr As DHCWL.MKPI.MKPIDimType [ SqlColumnNumber = 6, SqlFieldName = DimPro_DimDr ];

Property DefaultFlag As %String(MAXLEN = 2) [ SqlColumnNumber = 7, SqlFieldName = DimPro_DefaultFlag ];

Property ValueDeli As %String [ SqlColumnNumber = 8, SqlFieldName = DimPro_ValueDeli ];

Index DimCodeI On (DimDr, Code As AlphaUp);

Index DimProDr On (DimDr, DefaultFlag As AlphaUp);

Storage Default
{
<Data name="DimPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DimDr</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Desc</Value>
</Value>
<Value name="6">
<Value>ExcuteCode</Value>
</Value>
<Value name="7">
<Value>DefaultFlag</Value>
</Value>
<Value name="8">
<Value>ValueDeli</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.DimPropertyD</DataLocation>
<DefaultData>DimPropertyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.DimPropertyD</IdLocation>
<IndexLocation>^DHCWL.MKPI.DimPropertyI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.DimPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
