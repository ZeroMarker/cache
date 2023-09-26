/// 手术通用药物数据表
Class CIS.AN.OperDrugData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperDrugData ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 药品名称(可以是输入的名称)
Property DrugItem As %String [ Required, SqlColumnNumber = 3 ];

/// 药品名称选择项
Property DataOption As CT.AN.DataOptions [ SqlColumnNumber = 4 ];

/// 药品数量
Property Qty As %Float [ SqlColumnNumber = 5 ];

/// 数量单位
Property Uom As CT.AN.Uom [ SqlColumnNumber = 6 ];

/// 更新用户
Property UpdateUser As %String [ SqlColumnNumber = 7 ];

/// 更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8 ];

/// 更新时间
Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9 ];

/// 药物数据关联的元素ID(一个页面可能有多处需要添加药品数据)
Property ElementID As %String [ SqlColumnNumber = 10 ];

/// 手术麻醉记录表单索引
Index IRecordSheet On RecordSheet;

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="OperDrugDataDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>DrugItem</Value>
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
<DataLocation>^CIS.AN.OperDrugDataD</DataLocation>
<DefaultData>OperDrugDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperDrugDataD</IdLocation>
<IndexLocation>^CIS.AN.OperDrugDataI</IndexLocation>
<StreamLocation>^CIS.AN.OperDrugDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
