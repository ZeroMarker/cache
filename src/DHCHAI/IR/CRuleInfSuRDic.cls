/// 名称: DHCHAI.IR.CRuleInfSuRDic
/// 描述: 医院感染疑似筛查项目库
/// 编写者：zhufei
/// 编写日期: 2019-05-30
Class DHCHAI.IR.CRuleInfSuRDic Extends (%Persistent, DHCHAI.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目分类
Property BTCategory As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目代码（不允许修改）
Property BTItemCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目别名（到项目可以修改）
Property BTItemDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 输入类型（字典、数值、项目等，仅供参考）
Property BTInputType As %String(MAXLEN = 100, TRUNCATE = 1);

/// [输入类型=字典]值域标签
Property BTInputDicTab As %String(MAXLEN = 100, TRUNCATE = 1);

/// [输入类型=数值、项目]筛查上限标签
Property BTInputMaxTab As %Boolean;

/// [输入类型=数值、项目]筛查下限标签
Property BTInputMinTab As %Boolean;

/// [输入类型=项目]限定天数/持续天数标签
Property BTInputDayTab As %Boolean;

/// 输入说明
Property BTInputNote As %String(MAXLEN = 1000, TRUNCATE = 1);

Storage Default
{
<Data name="CRuleInfSuRDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCategory</Value>
</Value>
<Value name="3">
<Value>BTItemCode</Value>
</Value>
<Value name="4">
<Value>BTItemDesc</Value>
</Value>
<Value name="5">
<Value>BTInputType</Value>
</Value>
<Value name="6">
<Value>BTInputDicTab</Value>
</Value>
<Value name="7">
<Value>BTInputMaxTab</Value>
</Value>
<Value name="8">
<Value>BTInputMinTab</Value>
</Value>
<Value name="9">
<Value>BTInputDayTab</Value>
</Value>
<Value name="10">
<Value>BTInputNote</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleInfSuRDicD</DataLocation>
<DefaultData>CRuleInfSuRDicDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleInfSuRDicD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleInfSuRDicI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleInfSuRDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
