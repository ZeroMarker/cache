/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗规则字典表V2.0
/// Table：CT.WDT.CDSS.RuleDict
Class CT.WDT.CDSS.RuleDict Extends (%Persistent, User.Abstract)
{

/// 规则编码
Property RuleCode As %String [ Required ];

/// 规则概述
Property RuleDesc As %String(MAXLEN = 200) [ Required ];

/// 科室(多选用中文，连接科室id)CT.WDT.CDSS.DiseaseDeptDict
Property RuleLoc As %String;

/// 来源（多选用&%连接文献）CT.WDT.CDSS.DocuManage
Property RuleSource As %String(MAXLEN = "");

/// 规则流程类型（辅助诊疗规则/诊断预警规则/检验检查预警规则/手术并发症规则/输血合理性规则/手术合理性规则/过敏合理性规则/护理合理性规则）
Property RuleType As CT.WDT.CDSS.ChartType;

/// 批次号
Property BatchNum As %Integer;

/// 规则状态（编辑中、待审核、审核不通过、已上线、已下线）
Property RuleStatus As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 审核人员
Property AuditUser As %String;

/// 审核时间
Property AuditDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 规则来源（dhcc或者医院名称）
Property RuleProvision As %String;

Index CodeIndex On RuleCode [ Unique ];

Index DescIndex On RuleDesc;

Index TypeIndex On RuleType;

Index TypeDescIndex On (RuleType As Exact, RuleDesc As Exact);

Index DateIndex On UpdateDate;

Storage Default
{
<Data name="RuleDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleCode</Value>
</Value>
<Value name="3">
<Value>RuleDesc</Value>
</Value>
<Value name="4">
<Value>RuleLoc</Value>
</Value>
<Value name="5">
<Value>RuleSource</Value>
</Value>
<Value name="6">
<Value>RuleType</Value>
</Value>
<Value name="7">
<Value>BatchNum</Value>
</Value>
<Value name="8">
<Value>RuleStatus</Value>
</Value>
<Value name="9">
<Value>UpdateUser</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>AuditUser</Value>
</Value>
<Value name="12">
<Value>AuditDate</Value>
</Value>
<Value name="13">
<Value>Remarks</Value>
</Value>
<Value name="14">
<Value>RuleProvision</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleDictD</DataLocation>
<DefaultData>RuleDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
