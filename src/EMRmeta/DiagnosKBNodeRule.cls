/// 名称:	EMRmeta.DiagnosKBNodeRule
/// 描述:	病种知识库关联附加规则
/// 编写者：yejian
/// 编写日期: 2016-7-19
Class EMRmeta.DiagnosKBNodeRule Extends %Persistent
{

Index IdxDiagnosKBNodeID On DiagnosKBNodeID;

Index IdxUnique On (DiagnosKBNodeID, DiagnosRuleID, DiagnosRuleCode) [ Unique ];

/// RowID of the table EMRmeta.DiagnosKBNode
Property DiagnosKBNodeID As %String(TRUNCATE = 1);

/// RowID of the table StdDictionary
Property DiagnosRuleID As %String(TRUNCATE = 1);

/// The StdDictionary item code
Property DiagnosRuleCode As %String(TRUNCATE = 1);

/// The StdDictionary item desc
Property DiagnosRuleDesc As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DiagnosKBNodeRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiagnosKBNodeID</Value>
</Value>
<Value name="3">
<Value>DiagnosRuleID</Value>
</Value>
<Value name="4">
<Value>DiagnosRuleCode</Value>
</Value>
<Value name="5">
<Value>DiagnosRuleDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagnosKBNodeRuleD</DataLocation>
<DefaultData>DiagnosKBNodeRuleDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagnosKBNodeRuleD</IdLocation>
<IndexLocation>^DHCEMRM.DiagnosKBNodeRuleI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagnosKBNodeRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
