/// 医嘱
Class DHCCL.Model.OrderItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OrderItem ]
{

/// 医嘱项
Property Arcim As DHCCL.Config.Arcim [ SqlColumnNumber = 2 ];

/// 医嘱开单科室
Property OrderDept As DHCCL.Config.Location [ SqlColumnNumber = 3 ];

/// 医嘱执行科室(接收科室)
Property RecvDept As DHCCL.Config.Location [ SqlColumnNumber = 4 ];

/// 医嘱状态
Property OrderStatus As DHCCL.Code.OrderStatus [ SqlColumnNumber = 5 ];

/// 开医嘱医生
Property OrderDoctor As DHCCL.Config.CareProvider [ SqlColumnNumber = 6 ];

/// 开医嘱医生科室
Property OrderDocDept As DHCCL.Config.Location [ SqlColumnNumber = 7 ];

/// 医嘱日期
Property SttDate As %Date [ SqlColumnNumber = 8 ];

/// 医嘱时间
Property SttTime As %Time [ SqlColumnNumber = 9 ];

/// 医嘱优先级
Property Priority As DHCCL.Code.OrderPriority [ SqlColumnNumber = 10 ];

/// 医嘱频次
Property Frequency As DHCCL.Code.Frequency [ SqlColumnNumber = 11 ];

/// 医嘱用法
Property Instruction As DHCCL.Code.Instruction [ SqlColumnNumber = 12 ];

/// 医嘱单位
Property Uom As DHCCL.Config.Uom [ SqlColumnNumber = 13 ];

/// 医嘱取消日期
Property XDate As %Date [ SqlColumnNumber = 14 ];

/// 医嘱取消时间
Property XTime As %Time [ SqlColumnNumber = 15 ];

/// 医嘱取消医护人员
Property XDoctor As DHCCL.Config.CareProvider [ SqlColumnNumber = 16 ];

/// 诊疗疗程
Property Duration As DHCCL.Code.OrderDuration [ SqlColumnNumber = 17 ];

/// 医嘱主表
Property Admission As DHCCL.Model.Order [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="OrderItemDefaultData">
<Value name="1">
<Value>Arcim</Value>
</Value>
<Value name="2">
<Value>OrderDept</Value>
</Value>
<Value name="3">
<Value>RecvDept</Value>
</Value>
<Value name="4">
<Value>OrderStatus</Value>
</Value>
<Value name="5">
<Value>OrderDoctor</Value>
</Value>
<Value name="6">
<Value>OrderDocDept</Value>
</Value>
<Value name="7">
<Value>SttDate</Value>
</Value>
<Value name="8">
<Value>SttTime</Value>
</Value>
<Value name="9">
<Value>Priority</Value>
</Value>
<Value name="10">
<Value>Frequency</Value>
</Value>
<Value name="11">
<Value>Instruction</Value>
</Value>
<Value name="12">
<Value>Uom</Value>
</Value>
<Value name="13">
<Value>XDate</Value>
</Value>
<Value name="14">
<Value>XTime</Value>
</Value>
<Value name="15">
<Value>XDoctor</Value>
</Value>
<Value name="16">
<Value>Duration</Value>
</Value>
<Value name="17">
<Value>Admission</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.OrderItemD</DataLocation>
<DefaultData>OrderItemDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.OrderItemD</IdLocation>
<IndexLocation>^DHCCL.Model.OrderItemI</IndexLocation>
<StreamLocation>^DHCCL.Model.OrderItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
