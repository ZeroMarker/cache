/// 采集数据
Class CIS.AN.CollectedData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = CollectedData ]
{

/// 采集设备
Property Equip As CF.AN.DeptEquip [ Required, SqlColumnNumber = 2 ];

/// 数据通道号
Property ChannelNo As %String [ Required, SqlColumnNumber = 3 ];

/// 数据值
Property DataValue As %String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// 数据的采集日期
Property CollectDate As %Date [ SqlColumnNumber = 5 ];

/// 数据的采集时间
Property CollectTime As %Time [ SqlColumnNumber = 6 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8 ];

/// 设备、采集日期、采集时间索引
Index IEquipDT On (Equip, CollectDate, CollectTime);

/// 设备、通道号、采集日期、采集时间索引
Index IChannelDT On (Equip, ChannelNo, CollectDate, CollectTime);

Storage Default
{
<Data name="CollectedDataDefaultData">
<Value name="1">
<Value>Equip</Value>
</Value>
<Value name="2">
<Value>ChannelNo</Value>
</Value>
<Value name="3">
<Value>DataValue</Value>
</Value>
<Value name="4">
<Value>CollectDate</Value>
</Value>
<Value name="5">
<Value>CollectTime</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.CollectedDataD</DataLocation>
<DefaultData>CollectedDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.CollectedDataD</IdLocation>
<IndexLocation>^CIS.AN.CollectedDataI</IndexLocation>
<StreamLocation>^CIS.AN.CollectedDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
