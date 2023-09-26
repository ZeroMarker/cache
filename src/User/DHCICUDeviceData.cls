Class User.DHCICUDeviceData Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ICU_DeviceData, StorageStrategy = Storage ]
{

// IcuaId

Property IcuaId As User.DHCICUArrange [ SqlFieldName = IcuaId ];

// 设备Id

Property EquipId As %String [ SqlFieldName = EquipId ];

// 项目码表ID

Property RecordItemId As User.DHCICUCRecordItem [ SqlFieldName = RecordItemId ];

// 数据日期

Property StartDate As %Date [ SqlFieldName = StartDate ];

// 数据时间

Property StartTime As %Time [ SqlFieldName = StartTime ];

// 数值

Property Num As %Float [ SqlFieldName = Num ];

// 文本

Property Text As %String [ SqlFieldName = Text ];

// 更新日期

Property UpdateDate As %Date [ SqlFieldName = UpdateDate ];

// 更新时间

Property UpdateTime As %Time [ SqlFieldName = UpdateTime ];

// IcuaId索引

//Index IcuaId On (IcuaId As Plus, StartDate As Exact, StartTime As Plus);

// EquipId索引

//Index EquipId On (EquipId As Plus, StartDate As Exact, StartTime As Plus);

// IcuaId索引

Index IcuaId On (IcuaId As Plus, RecordItemId As Plus, StartDate As Exact, StartTime As Plus);

// EquipId索引

Index EquipId On (EquipId As Exact, StartDate As Exact, StartTime As Plus, RecordItemId As Plus);

Index DateTime On (StartDate As Plus, StartTime As Plus);

Storage Storage
{
<Data name="DHCICUDeviceDataClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUDeviceDataDefaultData">
<Value name="1">
<Value>EquipId</Value>
</Value>
<Value name="2">
<Value>IcuaId</Value>
</Value>
<Value name="3">
<Value>RecordItemId</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>Num</Value>
</Value>
<Value name="7">
<Value>Text</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
</Data>
<Data name="DHCICUDeviceDataDefaultData1">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>RecordItemId</Value>
</Value>
</Data>
<DataLocation>^DHCICUDeviceData</DataLocation>
<DefaultData>DHCICUDeviceDataDefaultData1</DefaultData>
<IdLocation>^DHCICUDeviceData</IdLocation>
<IndexLocation>^DHCICUDeviceData(0)</IndexLocation>
<SqlRowIdProperty>RowId</SqlRowIdProperty>
<StreamLocation>^DHCICUDeviceData</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
