/// 设备使用记录
Class CIS.AN.EquipRecord Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = EquipRecord ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 设备
Property Equip As CF.AN.DeptEquip [ Required, SqlColumnNumber = 3 ];

/// 设备使用开始日期
Property StartDate As %Date [ SqlColumnNumber = 4 ];

/// 设备使用开始时间
Property StartTime As %Time [ SqlColumnNumber = 5 ];

/// 设备使用结束日期
Property EndDate As %Date [ SqlColumnNumber = 6 ];

/// 设备使用结束时间
Property EndTime As %Time [ SqlColumnNumber = 7 ];

/// 设备状态（正常、故障）
Property Status As %String [ SqlColumnNumber = 8 ];

/// 最后更新用户ID
Property UpdateUser As %String [ SqlColumnNumber = 9 ];

/// 最后更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10 ];

/// 最后更新时间
Property UpdateTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 11 ];

/// 设备使用时长
Property Duration As %Float [ SqlColumnNumber = 12 ];

Index Sheet On RecordSheet;

Index Equip On Equip;

ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="EquipRecordDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>Equip</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>StartTime</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>UpdateUser</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
<Value name="11">
<Value>Duration</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.EquipRecordD</DataLocation>
<DefaultData>EquipRecordDefaultData</DefaultData>
<IdLocation>^CIS.AN.EquipRecordD</IdLocation>
<IndexLocation>^CIS.AN.EquipRecordI</IndexLocation>
<StreamLocation>^CIS.AN.EquipRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
