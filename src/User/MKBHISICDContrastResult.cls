/// Description： HISICD诊断结构化数据子表
/// Creator：李得原
/// Date： 2019-03-01
Class User.MKBHISICDContrastResult Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_HISICDContrastResult ]
{

Relationship MKBHISICDContrast As User.MKBHISICDContrast [ Cardinality = parent, Inverse = MKBHISICDContrastResult, SqlColumnNumber = 2 ];

/// 结构化结果ID
Property MKBHISICDConResultID As %String [ SqlFieldName = MKBHISICD_ConResultID ];

/// 结构化结果描述
Property MKBHISICDConResult As %String [ SqlFieldName = MKBHISICD_ConResult ];

/// 诊断模板ID
Property MKBHISICDConTermDr As User.MKBTerm [ SqlFieldName = MKBHISICD_ConTermDr ];

/// 补充诊断
Property MKBHISICDConSupplement As %String [ SqlFieldName = MKBHISICD_ConSupplement ];

/// 指向对应北京版
Property MKBHISICDConOther As User.MKBTerm [ SqlFieldName = MKBHISICD_ConOther ];

/// 顺序
Property MKBHISICDSequence As %String [ SqlFieldName = MKBHISICD_Sequence ];

Index MKBHISICDContrastIndex On MKBHISICDContrast As Exact;

Index ExpsIndex On (MKBHISICDConTermDr As exact, MKBHISICDConResultID As exact);

Index SeqIndex On (MKBHISICDContrast As Exact, MKBHISICDSequence As Exact);

Storage Default
{
<Data name="MKBHISICDContrastResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBHISICDConResultID</Value>
</Value>
<Value name="3">
<Value>MKBHISICDConResult</Value>
</Value>
<Value name="4">
<Value>MKBHISICDConTermDr</Value>
</Value>
<Value name="5">
<Value>MKBHISICDConSupplement</Value>
</Value>
<Value name="6">
<Value>MKBHISICDConOther</Value>
</Value>
<Value name="7">
<Value>MKBHISICDSequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MKBHISICDContrastResult")</DataLocation>
<DefaultData>MKBHISICDContrastResultDefaultData</DefaultData>
<IdLocation>^User.MKBHISICDContrastC("MKBHISICDContrastResult")</IdLocation>
<IndexLocation>^User.MKBHISICDContrastResultI</IndexLocation>
<StreamLocation>^User.MKBHISICDContrastResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
