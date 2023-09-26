Class CT.CKB.PDSS.RuleNode Extends %Persistent [ SqlRowIdName = RN_RowID, SqlTableName = RuleNode ]
{

/// 父节点
Property RNParent As CT.CKB.PDSS.RuleNode [ SqlColumnNumber = 2, SqlFieldName = RN_Parent ];

/// (RNAction='if') 逻辑关系（And,or）
/// (RNAction='else')||(RNAction='then') 输出类型
/// 	 							console-print(控制台打印)
/// 								var-assign (变量赋值)
Property RNCondition As %String [ SqlColumnNumber = 3, SqlFieldName = RN_Condition ];

/// 类型 if / then /else
Property RNAction As %String [ SqlColumnNumber = 4, SqlFieldName = RN_Action ];

/// 组号
Property RNRule As CT.CKB.PDSS.Rule [ SqlColumnNumber = 5, SqlFieldName = RN_Rule ];

Index Parent On (RNRule As Exact, RNAction As Exact, RNParent As Exact);

Storage Default
{
<Data name="RuleNodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RNParent</Value>
</Value>
<Value name="3">
<Value>RNCondition</Value>
</Value>
<Value name="4">
<Value>RNAction</Value>
</Value>
<Value name="5">
<Value>RNRule</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.RuleNodeD</DataLocation>
<DefaultData>RuleNodeDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.RuleNodeD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.RuleNodeI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.RuleNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
