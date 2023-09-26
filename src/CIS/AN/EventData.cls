/// 麻醉记录事件数据
Class CIS.AN.EventData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = EventData ]
{

/// 麻醉记录数据
Property AnaData As CIS.AN.AnaData [ Required, SqlColumnNumber = 2 ];

/// 事件明细项
Property EventDetailItem As CT.AN.EventOptions [ Required, SqlColumnNumber = 3 ];

/// 明细数据
Property DataValue As %String(MAXLEN = 500) [ SqlColumnNumber = 4 ];

/// 数据单位
Property DataUnit As %String [ SqlColumnNumber = 5 ];

/// 自动生成时绑定的收费记录明细
Property ChargeDetail As CIS.AN.ChargeDetail [ SqlColumnNumber = 6 ];

/// 麻醉记录数据索引
Index IAnaData On AnaData;

/// 麻醉记录数据外键约束
ForeignKey FKAnaData(AnaData) References CIS.AN.AnaData() [ OnDelete = cascade ];

Storage Default
{
<Data name="EventDataDefaultData">
<Value name="1">
<Value>AnaData</Value>
</Value>
<Value name="2">
<Value>EventDetailItem</Value>
</Value>
<Value name="3">
<Value>DataValue</Value>
</Value>
<Value name="4">
<Value>DataUnit</Value>
</Value>
<Value name="5">
<Value>ChargeDetail</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.EventDataD</DataLocation>
<DefaultData>EventDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.EventDataD</IdLocation>
<IndexLocation>^CIS.AN.EventDataI</IndexLocation>
<StreamLocation>^CIS.AN.EventDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
