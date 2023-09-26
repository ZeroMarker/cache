/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：评分表评分规则表
/// Table：CT.WDT.CDSS.AssScoringRules
Class CT.WDT.CDSS.AssScoringRules Extends (%Persistent, User.Abstract) [ SqlTableName = AssScoringRules ]
{

Relationship MKBASRParRef As CT.WDT.CDSS.AssBase [ Cardinality = parent, Inverse = ChildRules, Required, SqlFieldName = MKBASR_ParRef ];

/// 代码
Property MKBASRCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBASR_Code ];

/// 展示名
Property MKBASRDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBASR_Desc ];

/// 最小值
Property MKBASRMinValue As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBASR_MinValue ];

/// 最大值
Property MKBASRMaxValue As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBASR_MaxValue ];

/// 等级
Property MKBASRRank As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBASR_Rank ];

/// 代码索引
Index CodeIndex On (MKBASRParRef As Exact, MKBASRCode);

/// 描述索引
Index DescIndex On (MKBASRParRef As Exact, MKBASRDesc);

/// 父指针索引
Index ParIndex On MKBASRParRef As Exact;

Storage Default
{
<Data name="AssScoringRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBASRCode</Value>
</Value>
<Value name="3">
<Value>MKBASRDesc</Value>
</Value>
<Value name="4">
<Value>MKBASRMinValue</Value>
</Value>
<Value name="5">
<Value>MKBASRMaxValue</Value>
</Value>
<Value name="6">
<Value>MKBASRRank</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildRules")</DataLocation>
<DefaultData>AssScoringRulesDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssBaseC("ChildRules")</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssScoringRulesI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssScoringRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
