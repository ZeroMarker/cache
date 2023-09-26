Class User.MKBOperationResult Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_OperationResult ]
{

Relationship MKBOperationContrast As User.MKBOperationContrast [ Cardinality = parent, Inverse = MKBOperationResult, SqlColumnNumber = 2 ];

/// 结构化结果ID
Property MKBOperationConResultID As %String(MAXLEN = "") [ SqlFieldName = MKBOper_ConResultID ];

/// 结构化结果描述
Property MKBOperationConResult As %String(MAXLEN = "") [ SqlFieldName = MKBOper_ConResult ];

/// 诊断模板ID
Property MKBOperationConTermDr As User.MKBTerm [ SqlFieldName = MKBOper_ConTermDr ];

/// 补充诊断
Property MKBOperationConSupplement As %String [ SqlFieldName = MKBOper_ConSupplement ];

/// 指向对应北京版
Property MKBOperationConOther As User.MKBTerm [ SqlFieldName = MKBOper_ConOther ];

/// 顺序
Property MKBOperationSequence As %String [ SqlFieldName = MKBOper_Sequence ];

Index MKBOperationContrastIndex On MKBOperationContrast As Exact;

Index SeqIndex On (MKBOperationContrast As Exact, MKBOperationSequence As Exact);

Index SortIndex On (MKBOperationConTermDr As Exact, MKBOperationConResultID As Exact);

Index TermIndex On (MKBOperationConTermDr As Exact, MKBOperationContrast As Exact);

Storage Default
{
<Data name="MKBOperationResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBOperationConResultID</Value>
</Value>
<Value name="3">
<Value>MKBOperationConResult</Value>
</Value>
<Value name="4">
<Value>MKBOperationConTermDr</Value>
</Value>
<Value name="5">
<Value>MKBOperationConSupplement</Value>
</Value>
<Value name="6">
<Value>MKBOperationConOther</Value>
</Value>
<Value name="7">
<Value>MKBOperationSequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MKBOperationResult")</DataLocation>
<DefaultData>MKBOperationResultDefaultData</DefaultData>
<IdLocation>^User.MKBOperationContrastC("MKBOperationResult")</IdLocation>
<IndexLocation>^User.MKBOperationResultI</IndexLocation>
<StreamLocation>^User.MKBOperationResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
