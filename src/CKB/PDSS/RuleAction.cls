Class CKB.PDSS.RuleAction Extends (%Persistent, User.Abstract) [ SqlRowIdName = RA_RowId, SqlTableName = RuleAction ]
{

/// 输出类型 / then /else
Property RAAction As %String [ SqlColumnNumber = 2, SqlFieldName = RA_Action ];

/// 规则组号
Property RARuleId As %String [ SqlColumnNumber = 3, SqlFieldName = RA_RuleId ];

/// 输出类型 / console-print(控制台打印) / var-assign (变量赋值)
Property RAOutType As %String [ SqlColumnNumber = 4, SqlFieldName = RA_OutType ];

/// 输出变量id
Property RAVarValue As User.DHCCKBCommonDiction [ SqlColumnNumber = 5, SqlFieldName = RA_VarValue ];

/// 输出文本内容
Property RAValueContent As %String [ SqlColumnNumber = 6, SqlFieldName = RA_ValueContent ];

Index RuleActionType On (RARuleId As Exact, RAAction As Exact, RAOutType As Exact);

Storage Default
{
<Data name="RuleActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RAAction</Value>
</Value>
<Value name="3">
<Value>RARuleId</Value>
</Value>
<Value name="4">
<Value>RAOutType</Value>
</Value>
<Value name="5">
<Value>RAVarValue</Value>
</Value>
<Value name="6">
<Value>RAValueContent</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.RuleActionD</DataLocation>
<DefaultData>RuleActionDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.RuleActionD</IdLocation>
<IndexLocation>^CKB.PDSS.RuleActionI</IndexLocation>
<StreamLocation>^CKB.PDSS.RuleActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
