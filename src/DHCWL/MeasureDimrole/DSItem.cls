/// Description:         数据源条目定义表 
/// Table      :  		 DHCWL_MeasureDimrole.DSItem
/// Global     :		 ^DHCWL.MeasureDimrole.DSItemD   ^DHCWL.MeasureDimrole.DSItemI 
/// Other       :         d ##class(DHCWL.MeasureDimrole.DSItem).%BuildIndices() 
Class DHCWL.MeasureDimrole.DSItem Extends %Persistent [ SqlTableName = DSItem ]
{

/// 数据项名称
Property Name As %String [ SqlColumnNumber = 2, SqlFieldName = DsItem_Name ];

/// 描述
Property Desc As %String [ SqlColumnNumber = 3, SqlFieldName = DsItem_Desc ];

/// 统计项类型
Property ItemType As %String [ SqlColumnNumber = 4, SqlFieldName = DsItem_ItemType ];

/// 数据项类型
Property ItemDataType As %String [ SqlColumnNumber = 5, SqlFieldName = DsItem_ItemDataType ];

/// 关联数据源表
Property ItemDSDr As DHCWL.MeasureDimrole.DSource [ SqlColumnNumber = 6, SqlFieldName = DsItem_ItemDSDr ];

/// 自定义数据项表达式
Property ItemExpValue As %String [ SqlColumnNumber = 7, SqlFieldName = DsItem_ExpValue ];

/// 作废标志
Property ItemVoidFlag As %String [ SqlColumnNumber = 8, SqlFieldName = DsItem_VoidFlag ];

Index ItemType On (ItemDSDr, ItemType);

Index ItemDSDr On (ItemDSDr, Name);

Storage Default
{
<Data name="DSItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Desc</Value>
</Value>
<Value name="4">
<Value>ItemType</Value>
</Value>
<Value name="5">
<Value>ItemDataType</Value>
</Value>
<Value name="6">
<Value>ItemDSDr</Value>
</Value>
<Value name="7">
<Value>ItemExpValue</Value>
</Value>
<Value name="8">
<Value>ItemVoidFlag</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MeasureDimrole.DSItemD</DataLocation>
<DefaultData>DSItemDefaultData</DefaultData>
<IdLocation>^DHCWL.MeasureDimrole.DSItemD</IdLocation>
<IndexLocation>^DHCWL.MeasureDimrole.DSItemI</IndexLocation>
<StreamLocation>^DHCWL.MeasureDimrole.DSItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
