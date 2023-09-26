Class CKB.PDSS.RuleDetail Extends (%Persistent, User.Abstract) [ SqlRowIdName = RD_RowID, SqlTableName = RuleDetail ]
{

// Property RDGroupNo As User.DHCCKBRuleMaintain [ SqlFieldName = RD_GroupNo ];

/// 主表组号
Property RDGroupNo As %String [ SqlFieldName = RD_GroupNo ];

/// 子表组号
Property RDSubGroupNo As %String [ SqlFieldName = RD_SubGroupNo ];

/// 属性
Property RDCode As %String [ SqlFieldName = RD_Code ];

/// 属性值
Property RDDesc As %String [ SqlFieldName = RD_Desc ];

Index GroupNo On (RDGroupNo As Exact, RDSubGroupNo As Exact);

Storage Default
{
<Data name="RuleDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RDGroupNo</Value>
</Value>
<Value name="3">
<Value>RDSubGroupNo</Value>
</Value>
<Value name="4">
<Value>RDCode</Value>
</Value>
<Value name="5">
<Value>RDDesc</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.RuleDetailD</DataLocation>
<DefaultData>RuleDetailDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.RuleDetailD</IdLocation>
<IndexLocation>^CKB.PDSS.RuleDetailI</IndexLocation>
<StreamLocation>^CKB.PDSS.RuleDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
