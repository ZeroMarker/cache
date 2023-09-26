/// 医嘱带入项同步 医生站中高危需要提醒的医嘱使用
/// 武加锋
/// 2021-03-26
Class DHCMA.VTE.CLINIC.ClcAssistantOrder Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

// 医嘱项iD

Property OrderId As %String;

// 医嘱描述

Property OrderDesc As %String;

// 医嘱类型 1基础 2物理 3药物 4手术 5检查 6检验 7会诊

Property OrderType As %String;

// 医嘱是否有效 0无效 1有效

Property OrderStatus As %String;

// 医嘱排序

Property OrderSort As %String;

// HIS医嘱中的优先级 长期医嘱S 临时医嘱NORM 暂时检验检查都是NORM

Property OrderPriority As %String;

// 医嘱组 比如肝素注射液为一组 同一类型药不同厂家（待用）

Property OrderGroup As %String;

// 医生站中高危若没有该医嘱需要提醒

Property OrderAlert As %String;

Index IndexOrderId On OrderId;

Index IndexOrderAlert On OrderAlert;

Storage Default
{
<Data name="ClcAssistantOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderId</Value>
</Value>
<Value name="3">
<Value>OrderDesc</Value>
</Value>
<Value name="4">
<Value>OrderType</Value>
</Value>
<Value name="5">
<Value>OrderStatus</Value>
</Value>
<Value name="6">
<Value>OrderSort</Value>
</Value>
<Value name="7">
<Value>OrderPriority</Value>
</Value>
<Value name="8">
<Value>OrderGroup</Value>
</Value>
<Value name="9">
<Value>OrderAlert</Value>
</Value>
</Data>
<DataLocation>^DHCMA.VTE.CLINIC.ClcAssistanOrderD</DataLocation>
<DefaultData>ClcAssistantOrderDefaultData</DefaultData>
<IdLocation>^DHCMA.VTE.CLINIC.ClcAssistanOrderD</IdLocation>
<IndexLocation>^DHCMA.VTE.CLINIC.ClcAssistanOrderI</IndexLocation>
<StreamLocation>^DHCMA.VTE.CLINIC.ClcAssistanOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
