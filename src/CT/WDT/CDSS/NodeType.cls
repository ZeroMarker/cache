/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗规则流程节点类型表V2.0
/// Table：CT.WDT.CDSS.NodeType
Class CT.WDT.CDSS.NodeType Extends (%Persistent, User.Abstract)
{

/// 节点类型代码
Property NodeTypeCode As %String [ Required ];

/// 节点类型描述
Property NodeTypeDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On NodeTypeCode [ Unique ];

Index DescIndex On NodeTypeDesc;

Storage Default
{
<Data name="NodeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NodeTypeCode</Value>
</Value>
<Value name="3">
<Value>NodeTypeDesc</Value>
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
<DataLocation>^CT.WDT.CDSS.NodeTypeD</DataLocation>
<DefaultData>NodeTypeDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.NodeTypeD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.NodeTypeI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.NodeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
