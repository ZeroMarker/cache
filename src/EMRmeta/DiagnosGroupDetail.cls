/// 名称: 病种分组关联表
/// 描述: 病种分组关联表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRmeta.DiagnosGroupDetail Extends %Persistent
{

Index IdxGroupID On GroupID;

Index IdxCode On (GroupID, DiagnosCode) [ Unique ];

Index IdxSeq On (GroupID, Sequence, DiagnosCode);

/// 病种分组ID
Property GroupID As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种代码
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 顺序((病种分组下顺序))
Property Sequence As %Integer;

Storage Default
{
<Data name="DiagnosGroupDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupCode</Value>
</Value>
<Value name="3">
<Value>DiagnosCode</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>GroupID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagnosGroupDetailD</DataLocation>
<DefaultData>DiagnosGroupDetailDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagnosGroupDetailD</IdLocation>
<IndexLocation>^DHCEMRM.DiagnosGroupDetailI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagnosGroupDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
