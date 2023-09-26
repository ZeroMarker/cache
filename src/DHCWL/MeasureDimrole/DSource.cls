/// Description:         数据源定义表
/// Table      :  		 DHCWL_MeasureDimrole.DSource
/// Global     :		 ^DHCWL.MeasureDimrole.DSourceD   ^DHCWL.MeasureDimrole.DSourceI
Class DHCWL.MeasureDimrole.DSource Extends %Persistent [ SqlTableName = DSource ]
{

/// 包名
Property DsPackName As %String [ SqlColumnNumber = 2, SqlFieldName = Ds_PackName ];

/// 表名
Property DsTableName As %String [ SqlColumnNumber = 3, SqlFieldName = Ds_TableName ];

/// 描述
Property DsDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Ds_Desc ];

/// 作废标志
Property DsVoidFlag As %String [ SqlColumnNumber = 5, SqlFieldName = Ds_VoidFlag ];

Index DSTableName On DsTableName;

Index DSPackTable On (DsPackName, DsTableName);

Storage Default
{
<Data name="DSourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DsPackName</Value>
</Value>
<Value name="3">
<Value>DsTableName</Value>
</Value>
<Value name="4">
<Value>DsDesc</Value>
</Value>
<Value name="5">
<Value>DsVoidFlag</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MeasureDimrole.DSourceD</DataLocation>
<DefaultData>DSourceDefaultData</DefaultData>
<IdLocation>^DHCWL.MeasureDimrole.DSourceD</IdLocation>
<IndexLocation>^DHCWL.MeasureDimrole.DSourceI</IndexLocation>
<StreamLocation>^DHCWL.MeasureDimrole.DSourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
