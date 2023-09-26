/// Description： ICD诊断结构化数据子表
/// Creator：李得原
/// Date： 2019-01-16
Class User.MKBICDContrastResult Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_ICDContrastResult ]
{

Relationship MKBICDContrast As User.MKBICDContrast [ Cardinality = parent, Inverse = MKBICDContrastResult, SqlColumnNumber = 2 ];

/// 结构化结果ID
Property MKBICDConResultID As %String(MAXLEN = "") [ SqlFieldName = MKBICD_ConResultID ];

/// 结构化结果描述
Property MKBICDConResult As %String(MAXLEN = "") [ SqlFieldName = MKBICD_ConResult ];

/// 诊断模板ID
Property MKBICDConTermDr As User.MKBTerm [ SqlFieldName = MKBICD_ConTermDr ];

/// 补充诊断
Property MKBICDConSupplement As %String [ SqlFieldName = MKBICD_ConSupplement ];

/// 指向对应北京版
Property MKBICDConOther As User.MKBTerm [ SqlFieldName = MKBICD_ConOther ];

/// 顺序
Property MKBICDSequence As %String [ SqlFieldName = MKBICD_Sequence ];

Index MKBICDContrastIndex On MKBICDContrast As Exact;

Index SeqIndex On (MKBICDContrast As Exact, MKBICDSequence As Exact);

Index SortIndex On (MKBICDConTermDr As Exact, MKBICDConResultID As Exact);

Index TermIndex On (MKBICDConTermDr As Exact, MKBICDContrast As Exact);

Storage Default
{
<Data name="MKBICDContrastResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBICDConResultID</Value>
</Value>
<Value name="3">
<Value>MKBICDConResult</Value>
</Value>
<Value name="4">
<Value>MKBICDConTermDr</Value>
</Value>
<Value name="5">
<Value>MKBICDConSupplement</Value>
</Value>
<Value name="6">
<Value>MKBICDConOther</Value>
</Value>
<Value name="7">
<Value>MKBICDSequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MKBICDContrastResult")</DataLocation>
<DefaultData>MKBICDContrastResultDefaultData</DefaultData>
<IdLocation>^User.MKBICDContrastC("MKBICDContrastResult")</IdLocation>
<IndexLocation>^User.MKBICDContrastResultI</IndexLocation>
<StreamLocation>^User.MKBICDContrastResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
