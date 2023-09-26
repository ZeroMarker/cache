/// DHCWL_MKPI.DHCWLSectionProperty
Class DHCWL.MKPI.SectionProperty Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLSectionProperty ]
{

Property Code As %String [ SqlColumnNumber = 2, SqlFieldName = SecDimPro_Code ];

Property Name As %String [ SqlColumnNumber = 3, SqlFieldName = SecDimPro_Name ];

Property Desc As %String [ SqlColumnNumber = 4, SqlFieldName = SecDimPro_Desc ];

Property ExcuteCode As %String [ SqlColumnNumber = 5, SqlFieldName = SecDimPro_ExcCode ];

Property SecDimDr As DHCWL.MKPI.Section [ SqlColumnNumber = 6, SqlFieldName = SecDimPro_DimDr ];

Property DefaultFlag As %String(MAXLEN = 2) [ SqlColumnNumber = 7, SqlFieldName = SecDimPro_DefaultFlag ];

//Property ValueDeli As %String [ SqlColumnNumber = 8, SqlFieldName = DimPro_ValueDeli ];

Index SecDimCodeI On (SecDimDr, Code As AlphaUp);

Index SecDimDefPro On (SecDimDr, DefaultFlag As AlphaUp);

ClassMethod GetIdByCode(code) As %String
{
	q:code="" ""
	if ($d(^DHCWL.MKPI.SectionPropertyD(code))) q code
	s sec=$p(code,"||",1)
	s proCode=$p(code,"||",2)
	s sec=##class(DHCWL.MKPI.Section).GetIdByCode(sec)
	q:((sec="")||(proCode="")) ""
	q $o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",sec,$SYSTEM.SQL.ALPHAUP(proCode),""))
}

Storage Default
{
<Data name="SectionPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Desc</Value>
</Value>
<Value name="5">
<Value>ExcuteCode</Value>
</Value>
<Value name="6">
<Value>SecDimDr</Value>
</Value>
<Value name="7">
<Value>DefaultFlag</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.SectionPropertyD</DataLocation>
<DefaultData>SectionPropertyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.SectionPropertyD</IdLocation>
<IndexLocation>^DHCWL.MKPI.SectionPropertyI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.SectionPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
