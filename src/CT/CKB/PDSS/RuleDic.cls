Class CT.CKB.PDSS.RuleDic Extends %Persistent [ SqlRowIdName = RD_RowId, SqlTableName = RuleDic ]
{

/// RD_Rule 规则组号
Property RDRule As CT.CKB.PDSS.Rule [ SqlColumnNumber = 2, SqlFieldName = RD_Rule ];

/// RD_Dic 实体属性id
Property RDDic As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 3, SqlFieldName = RD_Dic ];

/// RD_Dic 实体属性父节点id
Property RDDicParent As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 4, SqlFieldName = RD_DicParent ];

Index Dic On RDDic As Exact;

Index ParentDic On RDDicParent As Exact;

Index RuleDic On (RDRule As Exact, RDDic As Exact);

Index RuleParentDic On (RDRule As Exact, RDDicParent As Exact);

Storage Default
{
<Data name="RuleDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RDRule</Value>
</Value>
<Value name="3">
<Value>RDDic</Value>
</Value>
<Value name="4">
<Value>RDDicParent</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.RuleDicD</DataLocation>
<DefaultData>RuleDicDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.RuleDicD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.RuleDicI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.RuleDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
