Class CKB.PDSS.RuleText Extends (%Persistent, User.Abstract) [ SqlRowIdName = RM_RowId, SqlTableName = RuleText ]
{

/// 属性
Property RMCode As %String(MAXLEN = 9999) [ SqlColumnNumber = 2, SqlFieldName = RM_Code ];

/// 值
Property RMDesc As %String(MAXLEN = 9999) [ SqlColumnNumber = 3, SqlFieldName = RM_Desc ];

/// 组号
Property RMGroupNo As %String(MAXLEN = 9999) [ SqlColumnNumber = 4, SqlFieldName = RM_GroupNo ];

/// 模板ID
Property RMTemp As %String(MAXLEN = 9999) [ SqlColumnNumber = 5, SqlFieldName = RM_Temp ];

/// 提交标识0:保存，1：提交
Property RMFlag As %String [ SqlColumnNumber = 6, SqlFieldName = RM_Flag ];

/// 规则ID RM_Rule_Dr
Property RMRuleDr As CT.CKB.PDSS.Rule [ SqlColumnNumber = 7, SqlFieldName = RM_Rule_Dr ];

Index GroupNo On RMGroupNo As Exact;

Index GroCode On (RMGroupNo As Exact, RMTemp As Exact, RMCode As Exact);

Index TempGro On (RMTemp As Exact, RMGroupNo As Exact);

Storage Default
{
<Data name="RuleTextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RMCode</Value>
</Value>
<Value name="3">
<Value>RMDesc</Value>
</Value>
<Value name="4">
<Value>RMGroupNo</Value>
</Value>
<Value name="5">
<Value>RMTemp</Value>
</Value>
<Value name="6">
<Value>RMFlag</Value>
</Value>
<Value name="7">
<Value>RMRuleDr</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.RuleTextD</DataLocation>
<DefaultData>RuleTextDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.RuleTextD</IdLocation>
<IndexLocation>^CKB.PDSS.RuleTextI</IndexLocation>
<StreamLocation>^CKB.PDSS.RuleTextS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
