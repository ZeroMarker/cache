Class DHCWL.MRIPDay.KPIItem Extends %Persistent [ SqlRowIdName = KPIItem_RowID, SqlTableName = KPIItem ]
{

Property KPIItemOPTLItemDR As OPTLItem [ Required, SqlColumnNumber = 2, SqlFieldName = KPIItem_OPTLItemDR ];

Property KPIItemKPIDR As DHCWL.MKPI.MKPI [ SqlColumnNumber = 3, SqlFieldName = KPIItem_KPIDR ];

Property KPIItemKPICode As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 4, SqlFieldName = KPIItem_KPICode ];

Property KPIItemItemType As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = KPIItem_ItemType ];

Property KPIItemDimCode As %String [ SqlColumnNumber = 6, SqlFieldName = KPIItem_DimCode ];

Property KPIItemDetailType As %String [ SqlColumnNumber = 7, SqlFieldName = KPIItem_DetailType ];

Property KPIItemDateSec As %String [ SqlColumnNumber = 8, SqlFieldName = KPIItem_DateSec ];

Index KPIItemKPIDRIndex On KPIItemKPIDR;

Index KPIItemOPTLItemDRIndex On KPIItemOPTLItemDR;

Index KPIItemKPICodeIndex On KPIItemKPICode;

Index KPIItemOPTLItemTypeIndex On (KPIItemOPTLItemDR, KPIItemItemType);

Storage Default
{
<Data name="KPIItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KPIItemOPTLItemDR</Value>
</Value>
<Value name="3">
<Value>KPIItemKPIDR</Value>
</Value>
<Value name="4">
<Value>KPIItemKPICode</Value>
</Value>
<Value name="5">
<Value>KPIItemItemType</Value>
</Value>
<Value name="6">
<Value>KPIItemDimCode</Value>
</Value>
<Value name="7">
<Value>KPIItemDetailType</Value>
</Value>
<Value name="8">
<Value>KPIItemDateSec</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.KPIItemD</DataLocation>
<DefaultData>KPIItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.KPIItemD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.KPIItemI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.KPIItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
