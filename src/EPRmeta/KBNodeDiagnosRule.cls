/// Description:	知识库关联病种附加规则
Class EPRmeta.KBNodeDiagnosRule Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxKBNodeDiagnosID On KBNodeDiagnosID;

Index IdxUnique On (KBNodeDiagnosID, DiagnosRuleID, DiagnosRuleCode) [ Unique ];

/// RowID of the table KBNodeDiagnos
Property KBNodeDiagnosID As %String(TRUNCATE = 1);

/// RowID of the table StdDictionary
Property DiagnosRuleID As %String(TRUNCATE = 1);

/// The StdDictionary item code
Property DiagnosRuleCode As %String(TRUNCATE = 1);

/// The StdDictionary item desc
Property DiagnosRuleDesc As %String(TRUNCATE = 1);

Storage Default
{
<Data name="KBNodeDiagnosRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KBNodeDiagnosID</Value>
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
<DataLocation>^DHCEPRM.KBNodeDiagnosRuleD</DataLocation>
<DefaultData>KBNodeDiagnosRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.KBNodeDiagnosRuleD</IdLocation>
<IndexLocation>^DHCEPRM.KBNodeDiagnosRuleI</IndexLocation>
<StreamLocation>^DHCEPRM.KBNodeDiagnosRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
