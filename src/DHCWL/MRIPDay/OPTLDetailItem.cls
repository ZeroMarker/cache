Class DHCWL.MRIPDay.OPTLDetailItem Extends %Persistent [ SqlRowIdName = OPTLDetailItem_RowID, SqlTableName = OPTLDetailItem ]
{

Property OPTLDetailItemCode As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = OPTLDetailItem_Code ];

Index OPTLDetailItemCodeIndex On OPTLDetailItemCode [ Unique ];

/// 描述
Property OPTLDetailItemDesc As %String [ SqlFieldName = OPTLDetailItem_Desc ];

Property OPTLDetailItemType As %String [ SqlFieldName = OPTLDetailItem_Type ];

Storage Default
{
<Data name="OPTLDetailItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPTLDetailItemCode</Value>
</Value>
<Value name="3">
<Value>OPTLDetailItemDesc</Value>
</Value>
<Value name="4">
<Value>OPTLDetailItemType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.OPTLDetailItemD</DataLocation>
<DefaultData>OPTLDetailItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.OPTLDetailItemD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.OPTLDetailItemI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.OPTLDetailItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
