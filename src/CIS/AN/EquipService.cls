/// 设备维修记录
Class CIS.AN.EquipService Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = EquipService ]
{

/// 设备
Property Equip As CF.AN.DeptEquip [ Required, SqlColumnNumber = 2 ];

/// 维修日期
Property ServiceDate As %Date [ Required, SqlColumnNumber = 3 ];

/// 故障现象
Property Phenomenon As %String(MAXLEN = 500) [ SqlColumnNumber = 4 ];

/// 代码与描述
Property CodeDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 处理方法
Property ServiceMethod As %String(MAXLEN = 500) [ SqlColumnNumber = 6 ];

/// 结果
Property ServiceResult As %String(MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 维修人
Property ServiceProv As %String [ SqlColumnNumber = 8 ];

/// 报修人
Property AppProv As %String [ SqlColumnNumber = 9 ];

/// 维修时长
Property Duration As %String [ SqlColumnNumber = 10 ];

/// 维修开始日期
Property StartDate As %Date [ SqlColumnNumber = 11 ];

/// 维修开始时间
Property StartTime As %Time [ SqlColumnNumber = 12 ];

/// 维修结束日期
Property EndDate As %Date [ SqlColumnNumber = 13 ];

/// 维修结束时间
Property EndTime As %Time [ SqlColumnNumber = 14 ];

/// 最后更新人
Property UpdateUser As %String [ SqlColumnNumber = 15 ];

/// 最后更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 16 ];

/// 最后更新时间
Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 17 ];

/// 操作人科室
Property ServiceDept As %String [ SqlColumnNumber = 18 ];

/// 设备索引
Index IEquip On Equip;

/// 服务日期索引
Index ISerDate On ServiceDate;

Storage Default
{
<Data name="EquipServiceDefaultData">
<Value name="1">
<Value>Equip</Value>
</Value>
<Value name="2">
<Value>ServiceDate</Value>
</Value>
<Value name="3">
<Value>Phenomenon</Value>
</Value>
<Value name="4">
<Value>CodeDesc</Value>
</Value>
<Value name="5">
<Value>ServiceMethod</Value>
</Value>
<Value name="6">
<Value>ServiceResult</Value>
</Value>
<Value name="7">
<Value>ServiceProv</Value>
</Value>
<Value name="8">
<Value>AppProv</Value>
</Value>
<Value name="9">
<Value>Duration</Value>
</Value>
<Value name="10">
<Value>StartDate</Value>
</Value>
<Value name="11">
<Value>StartTime</Value>
</Value>
<Value name="12">
<Value>EndDate</Value>
</Value>
<Value name="13">
<Value>EndTime</Value>
</Value>
<Value name="14">
<Value>UpdateUser</Value>
</Value>
<Value name="15">
<Value>UpdateDate</Value>
</Value>
<Value name="16">
<Value>UpdateTime</Value>
</Value>
<Value name="17">
<Value>ServiceDept</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.EquipServiceD</DataLocation>
<DefaultData>EquipServiceDefaultData</DefaultData>
<IdLocation>^CIS.AN.EquipServiceD</IdLocation>
<IndexLocation>^CIS.AN.EquipServiceI</IndexLocation>
<StreamLocation>^CIS.AN.EquipServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
