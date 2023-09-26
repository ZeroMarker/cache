/// 医嘱信息
Class DWR.ORD.MSG.OrderItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "OrderItem";

/// 医嘱ID
Property OrdItemID As %String(TRUNCATE = 1);

/// 医嘱序号
Property SeqNo As %String(TRUNCATE = 1);

/// 医嘱项分类
Property ItemCat As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医嘱项名称
Property ItemDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 下医嘱医生
Property OrderDoctor As %String(TRUNCATE = 1);

/// 下医嘱日期		(YYYY-MM-DD)
Property OrderDate As %String(TRUNCATE = 1);

/// 下医嘱时间       (HH:MM)
Property OrderTime As %String(TRUNCATE = 1);

/// 停医嘱医生
Property StopOrderDoctor As %String(TRUNCATE = 1);

/// 停医嘱日期		(YYYY-MM-DD)
Property StopOrderDate As %String(TRUNCATE = 1);

/// 停医嘱时间       (HH:MM)
Property StopOrderTime As %String(TRUNCATE = 1);

/// 医嘱状态
Property ItemStatus As %String(TRUNCATE = 1);

/// 要求执行日期	(YYYY-MM-DD)
Property StartDate As %String(TRUNCATE = 1);

/// 要求执行时间	(HH:MM)		
Property StartTime As %String(TRUNCATE = 1);

/// 医嘱优先级
Property Priority As %String(TRUNCATE = 1);

/// 剂量
Property DoseQty As %String(TRUNCATE = 1);

/// 剂量单位
Property DoseUom As %String(TRUNCATE = 1);

/// 频率
Property Frequency As %String(TRUNCATE = 1);

/// 用法
Property Instruction As %String(TRUNCATE = 1);

/// 疗程
Property Duration As %String(TRUNCATE = 1);

/// 数量
Property Qty As %String(TRUNCATE = 1);

/// 单位
Property Uom As %String(TRUNCATE = 1);

/// 接收科室
Property RecLoc As %String(TRUNCATE = 1);

/// 备注
Property Remarks As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="OrderItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DoseQty</Value>
</Value>
<Value name="3">
<Value>DoseUom</Value>
</Value>
<Value name="4">
<Value>Duration</Value>
</Value>
<Value name="5">
<Value>Frequency</Value>
</Value>
<Value name="6">
<Value>Instruction</Value>
</Value>
<Value name="7">
<Value>ItemDesc</Value>
</Value>
<Value name="8">
<Value>ItemStatus</Value>
</Value>
<Value name="9">
<Value>OrdItemID</Value>
</Value>
<Value name="10">
<Value>OrderDate</Value>
</Value>
<Value name="11">
<Value>OrderDoctor</Value>
</Value>
<Value name="12">
<Value>OrderTime</Value>
</Value>
<Value name="13">
<Value>Priority</Value>
</Value>
<Value name="14">
<Value>Qty</Value>
</Value>
<Value name="15">
<Value>RecLoc</Value>
</Value>
<Value name="16">
<Value>Remarks</Value>
</Value>
<Value name="17">
<Value>SeqNo</Value>
</Value>
<Value name="18">
<Value>StartDate</Value>
</Value>
<Value name="19">
<Value>StartTime</Value>
</Value>
<Value name="20">
<Value>Uom</Value>
</Value>
<Value name="21">
<Value>ItemCat</Value>
</Value>
</Data>
<DataLocation>^DWR.ORD.MSG.OrderItemD</DataLocation>
<DefaultData>OrderItemDefaultData</DefaultData>
<IdLocation>^DWR.ORD.MSG.OrderItemD</IdLocation>
<IndexLocation>^DWR.ORD.MSG.OrderItemI</IndexLocation>
<StreamLocation>^DWR.ORD.MSG.OrderItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
