/// 手术物品
Class CIS.AN.SurgicalItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SurgicalItem ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 物品名称
Property ItemName As %String [ SqlColumnNumber = 3 ];

/// 名称选项
Property DataOption As CT.AN.DataOptions [ SqlColumnNumber = 4 ];

/// 物品数量
Property Qty As %String [ SqlColumnNumber = 5 ];

/// 物品单位
Property Uom As %String [ SqlColumnNumber = 6 ];

/// 更新用户
Property UpdateUser As %String [ SqlColumnNumber = 7 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 8 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 9 ];

/// 关联的元素ID
Property ElementID As %String [ SqlColumnNumber = 10 ];

/// 手术麻醉记录表单索引
Index ISheet On RecordSheet;

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="SurgicalItemDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>ItemName</Value>
</Value>
<Value name="3">
<Value>DataOption</Value>
</Value>
<Value name="4">
<Value>Qty</Value>
</Value>
<Value name="5">
<Value>Uom</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>ElementID</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SurgicalItemD</DataLocation>
<DefaultData>SurgicalItemDefaultData</DefaultData>
<IdLocation>^CIS.AN.SurgicalItemD</IdLocation>
<IndexLocation>^CIS.AN.SurgicalItemI</IndexLocation>
<StreamLocation>^CIS.AN.SurgicalItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
