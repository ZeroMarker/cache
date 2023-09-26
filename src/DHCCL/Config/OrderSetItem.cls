/// 医嘱套明细项
Class DHCCL.Config.OrderSetItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OrderSetItem ]
{

/// 医嘱项
Property Arcim As DHCCL.Config.Arcim [ Required, SqlColumnNumber = 2 ];

/// 医嘱数量
Property Qty As %Float [ Required, SqlColumnNumber = 3 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// 序号
Property SeqNo As %String [ SqlColumnNumber = 5 ];

/// 医嘱剂量
Property DoseQty As %Float [ SqlColumnNumber = 6 ];

/// 频次
Property Frequency As DHCCL.Code.Frequency [ SqlColumnNumber = 7 ];

/// 疗程
Property Duration As DHCCL.Code.OrderDuration [ SqlColumnNumber = 8 ];

/// 用法
Property Instruction As DHCCL.Code.Instruction [ SqlColumnNumber = 9 ];

/// 单位
Property Uom As DHCCL.Config.Uom [ SqlColumnNumber = 10 ];

/// 序列码
Property SerialNo As %String [ SqlColumnNumber = 11 ];

/// 接收科室
Property RecvLoc As DHCCL.Config.Location [ SqlColumnNumber = 12 ];

/// 剂量单位
Property DoseUom As DHCCL.Config.Uom [ SqlColumnNumber = 13 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 14 ];

/// 激活日期
Property ActiveDate As %Date [ SqlColumnNumber = 15 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 16 ];

/// 医嘱套
Property OrderSet As DHCCL.Config.OrderSet [ SqlColumnNumber = 17 ];

Index Arcim On Arcim;

Index Ext On ExternalID;

Index OS On OrderSet;

ForeignKey FKOrderSet(OrderSet) References DHCCL.Config.OrderSet() [ OnDelete = cascade ];

Storage Default
{
<Data name="OrderSetItemDefaultData">
<Value name="1">
<Value>Arcim</Value>
</Value>
<Value name="2">
<Value>Qty</Value>
</Value>
<Value name="3">
<Value>Active</Value>
</Value>
<Value name="4">
<Value>SeqNo</Value>
</Value>
<Value name="5">
<Value>DoseQty</Value>
</Value>
<Value name="6">
<Value>Frequency</Value>
</Value>
<Value name="7">
<Value>Duration</Value>
</Value>
<Value name="8">
<Value>Instruction</Value>
</Value>
<Value name="9">
<Value>Uom</Value>
</Value>
<Value name="10">
<Value>SerialNo</Value>
</Value>
<Value name="11">
<Value>RecvLoc</Value>
</Value>
<Value name="12">
<Value>DoseUom</Value>
</Value>
<Value name="13">
<Value>ExternalID</Value>
</Value>
<Value name="14">
<Value>ActiveDate</Value>
</Value>
<Value name="15">
<Value>ExpireDate</Value>
</Value>
<Value name="16">
<Value>OrderSet</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.OrderSetItemD</DataLocation>
<DefaultData>OrderSetItemDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.OrderSetItemD</IdLocation>
<IndexLocation>^DHCCL.Config.OrderSetItemI</IndexLocation>
<StreamLocation>^DHCCL.Config.OrderSetItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
