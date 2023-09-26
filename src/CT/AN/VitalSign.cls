/// 表单生命体征项目
Class CT.AN.VitalSign Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = VitalSign ]
{

/// 数据项
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 2 ];

/// 最大值
Property MaxValue As %Float [ SqlColumnNumber = 3 ];

/// 最小值
Property MinValue As %Float [ SqlColumnNumber = 4 ];

/// 警戒阈值(大)
Property WarningMax As %Float [ SqlColumnNumber = 5 ];

/// 警戒阈值(小)
Property WarningMin As %Float [ SqlColumnNumber = 6 ];

/// 图例
Property Legend As CT.AN.Legend [ SqlColumnNumber = 7 ];

/// 颜色
Property Color As %String [ SqlColumnNumber = 8 ];

/// 通道号
Property ChannelNo As %String [ SqlColumnNumber = 9 ];

/// 同步间隔  单位为标准间隔(页面单列)
Property SyncInterval As %Integer [ SqlColumnNumber = 10 ];

/// 是否连接各点
Property ConnectPoints As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 11 ];

/// 开始事件
Property StartEvent As CT.AN.DataItem [ SqlColumnNumber = 12 ];

/// 结束事件
Property EndEvent As CT.AN.DataItem [ SqlColumnNumber = 13 ];

/// 是否在开始事件和结束事件范围显示
Property EventDisplay As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 14 ];

/// 数据项索引
Index IDataItem On DataItem;

/// 数据项外键约束
ForeignKey FKDataItem(DataItem) References CT.AN.DataItem() [ OnDelete = cascade ];

Storage Default
{
<Data name="VitalSignDefaultData">
<Value name="1">
<Value>DataItem</Value>
</Value>
<Value name="2">
<Value>MaxValue</Value>
</Value>
<Value name="3">
<Value>MinValue</Value>
</Value>
<Value name="4">
<Value>WarningMax</Value>
</Value>
<Value name="5">
<Value>WarningMin</Value>
</Value>
<Value name="6">
<Value>Legend</Value>
</Value>
<Value name="7">
<Value>Color</Value>
</Value>
<Value name="8">
<Value>ChannelNo</Value>
</Value>
<Value name="9">
<Value>SyncInterval</Value>
</Value>
<Value name="10">
<Value>ConnectPoints</Value>
</Value>
<Value name="11">
<Value>StartEvent</Value>
</Value>
<Value name="12">
<Value>EndEvent</Value>
</Value>
<Value name="13">
<Value>EventDisplay</Value>
</Value>
</Data>
<DataLocation>^CT.AN.VitalSignD</DataLocation>
<DefaultData>VitalSignDefaultData</DefaultData>
<IdLocation>^CT.AN.VitalSignD</IdLocation>
<IndexLocation>^CT.AN.VitalSignI</IndexLocation>
<StreamLocation>^CT.AN.VitalSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
