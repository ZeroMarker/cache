/// DHCWL_MRIPDay.Rpt  d ##class(DHCWL.MRIPDay.CustomItem).%BuildIndices()
Class DHCWL.MRIPDay.CustomItem Extends %Persistent [ SqlRowIdName = CustomItem_RowID, SqlTableName = CustomItem ]
{

Property CustomItemOPTLItemDR As OPTLItem [ Required, SqlColumnNumber = 2, SqlFieldName = CustomItem_OPTLItemDR ];

Index CustomItemOPTLItemDRIndex On CustomItemOPTLItemDR;

Property CustomItemItemType As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CustomItem_ItemType ];

Property CustomItemCustomFun As %String(MAXLEN = 150) [ SqlColumnNumber = 4, SqlFieldName = CustomItem_CustomFun ];

Index CustomItemOPTLItemDRTypeIndex On (CustomItemOPTLItemDR, CustomItemItemType);

Storage Default
{
<Data name="CustomItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CustomItemOPTLItemDR</Value>
</Value>
<Value name="3">
<Value>CustomItemItemType</Value>
</Value>
<Value name="4">
<Value>CustomItemCustomFun</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.CustomItemD</DataLocation>
<DefaultData>CustomItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.CustomItemD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.CustomItemI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.CustomItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
