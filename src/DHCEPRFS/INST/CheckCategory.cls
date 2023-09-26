Class DHCEPRFS.INST.CheckCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 规则列表ID
Property RuleListID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 质控类别次序号
Property Sequence As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 质控类别编码
Property CategoryCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 质控类别名称
Property CategoryName As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 质控类别描述
Property CategoryDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 是否必需
Property IsNeeded As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 类型 -- EPR:电子病历 RIS:检查 LIS:检验 EKG:电生理
Property Type As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 类名
Property ClassName As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 方法名
Property MethodName As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// 是否有效
Property IsValid As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 是否显示全部子项目 - Y:显示全部 N:只显示结果为1的项目
Property ShowItemsStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

Index IdxRuleListID On RuleListID;

Index IdxCategoryCode On (RuleListID, CategoryCode);

Storage Default
{
<Data name="CheckCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleListID</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>CategoryCode</Value>
</Value>
<Value name="5">
<Value>CategoryName</Value>
</Value>
<Value name="6">
<Value>CategoryDesc</Value>
</Value>
<Value name="7">
<Value>IsNeeded</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>ClassName</Value>
</Value>
<Value name="10">
<Value>MethodName</Value>
</Value>
<Value name="11">
<Value>IsValid</Value>
</Value>
<Value name="12">
<Value>ShowItemsStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CheckCategoryD</DataLocation>
<DefaultData>CheckCategoryDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.CheckCategoryD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CheckCategoryI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CheckCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
