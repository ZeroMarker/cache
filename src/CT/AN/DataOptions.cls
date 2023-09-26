/// 数据选项
Class CT.AN.DataOptions Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DataOptions ]
{

/// 选项代码
Property Code As %String [ SqlColumnNumber = 2 ];

/// 选项名称
Property Description As %String [ SqlColumnNumber = 3 ];

/// 选项类型
Property OptsType As %String [ Required, SqlColumnNumber = 4 ];

/// 默认单位
Property Uom As %String [ SqlColumnNumber = 5 ];

/// 医嘱项ID
Property ArcimID As %String [ SqlColumnNumber = 6 ];

/// 数据项
Property DataItem As CT.AN.DataItem [ SqlColumnNumber = 7 ];

/// 选项类型索引
Index IOptsType On OptsType;

Storage Default
{
<Data name="DataOptionsDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>OptsType</Value>
</Value>
<Value name="4">
<Value>Uom</Value>
</Value>
<Value name="5">
<Value>ArcimID</Value>
</Value>
<Value name="6">
<Value>DataItem</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DataOptionsD</DataLocation>
<DefaultData>DataOptionsDefaultData</DefaultData>
<IdLocation>^CT.AN.DataOptionsD</IdLocation>
<IndexLocation>^CT.AN.DataOptionsI</IndexLocation>
<StreamLocation>^CT.AN.DataOptionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
