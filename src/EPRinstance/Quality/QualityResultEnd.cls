/// Desc:在、出院最终得分结果
/// Creator: Candyxu
/// Date:2012-07-11
Class EPRinstance.Quality.QualityResultEnd Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index IdxEpisodeID On EpisodeID;

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 质控标准
Property RuleDR As %String(TRUNCATE = 1);

/// 扣分 
Property DeScore As %String(TRUNCATE = 1);

/// 得分
Property Score As %String(TRUNCATE = 1);

/// 级别
Property Grade As %String(TRUNCATE = 1);

/// 执行时间
Property ExecuteDate As %String(TRUNCATE = 1);

/// 乙次数
Property BCount As %String(TRUNCATE = 1);

/// 丙次数
Property CCount As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualityResultEndDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeScore</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>Grade</Value>
</Value>
<Value name="5">
<Value>RuleDR</Value>
</Value>
<Value name="6">
<Value>Score</Value>
</Value>
<Value name="7">
<Value>ExecuteDate</Value>
</Value>
<Value name="8">
<Value>BCount</Value>
</Value>
<Value name="9">
<Value>CCount</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualityResultEndD</DataLocation>
<DefaultData>QualityResultEndDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRQ.QualityResultEndD</IdLocation>
<IndexLocation>^DHCEPRQ.QualityResultEndI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityResultEndS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
