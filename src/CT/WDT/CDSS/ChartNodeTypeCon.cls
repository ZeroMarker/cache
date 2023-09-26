/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗规则流程类型与节点类型关联表V2.0
/// Table：CT.WDT.CDSS.ChartNodeTypeCon
Class CT.WDT.CDSS.ChartNodeTypeCon Extends (%Persistent, User.Abstract)
{

/// 诊疗规则流程类型表
Property ChartTypeDR As CT.WDT.CDSS.ChartType [ Required ];

/// 诊疗规则流程节点类型表
Property NodeTypeDR As CT.WDT.CDSS.NodeType [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index ChartTypeIndex On ChartTypeDR;

Index ChartNodeTypeIndex On (ChartTypeDR, NodeTypeDR);

Storage Default
{
<Data name="ChartNodeTypeConDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChartTypeDR</Value>
</Value>
<Value name="3">
<Value>NodeTypeDR</Value>
</Value>
<Value name="4">
<Value>UseFlag</Value>
</Value>
<Value name="5">
<Value>UpdateUser</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ChartNodeTypeConD</DataLocation>
<DefaultData>ChartNodeTypeConDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ChartNodeTypeConD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ChartNodeTypeConI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ChartNodeTypeConS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
