/// DHCWL.MRIPDay.OPTLItem  d ##class(DHCWL.MRIPDay.OPTLItem).%BuildIndices()
Class DHCWL.MRIPDay.OPTLItem Extends %Persistent [ SqlRowIdName = OPTLItem_RowID, SqlTableName = OPTLItem ]
{

Property OPTLItemCode As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = OPTLItem_Code ];

Property OPTLItemDesc As %String [ SqlColumnNumber = 3, SqlFieldName = OPTLItem_Desc ];

Property OPTLItemType As %String [ SqlColumnNumber = 4, SqlFieldName = OPTLItem_Type ];

Index OPTLItemCodeIndex On OPTLItemCode [ Unique ];

Storage Default
{
<Data name="OPTLItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPTLItemCode</Value>
</Value>
<Value name="3">
<Value>OPTLItemDesc</Value>
</Value>
<Value name="4">
<Value>OPTLItemType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.OPTLItemD</DataLocation>
<DefaultData>OPTLItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.OPTLItemD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.OPTLItemI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.OPTLItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
