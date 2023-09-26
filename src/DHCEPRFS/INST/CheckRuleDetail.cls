/// Desc: 完整性校验子表
Class DHCEPRFS.INST.CheckRuleDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 规则列表ID
Property ListRowID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档病历项目表ID
Property MRItemID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 归档病历项目编码
Property MRItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 归档病历项目名称
Property MRItemName As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 病历项描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 是否为必须提交的项目
Property IsNeeded As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 类名
Property ClassName As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 方法名
Property MethodName As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 是否有效
Property IsValid As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Index IdxListRowID On ListRowID;

Storage Default
{
<Data name="CheckRuleDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ListRowID</Value>
</Value>
<Value name="3">
<Value>MRItemID</Value>
</Value>
<Value name="4">
<Value>MRItemCode</Value>
</Value>
<Value name="5">
<Value>MRItemName</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>IsNeeded</Value>
</Value>
<Value name="8">
<Value>ClassName</Value>
</Value>
<Value name="9">
<Value>MethodName</Value>
</Value>
<Value name="10">
<Value>Enable</Value>
</Value>
<Value name="11">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CheckRuleDetailD</DataLocation>
<DefaultData>CheckRuleDetailDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.CheckRuleDetailD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CheckRuleDetailI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CheckRuleDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
