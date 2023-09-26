/// Desc:		质控自动任务触犯条目结果历史表
/// Creator:		Candy
/// CreateDate:	2014-10-10
Class EPRinstance.Quality.QualityResultHistory Extends (%Persistent, %XML.Adaptor)
{

Relationship DetailsHistory As EPRinstance.Quality.QualityResultDetailHistory [ Cardinality = children, Inverse = TheResultHistory ];

/// Represent current visit for one patient
Property EpisodeID As %String(TRUNCATE = 1);

/// Quality rule reference
Property RuleDR As %String(TRUNCATE = 1);

/// 实际得分
Property ActualScore As %String(TRUNCATE = 1);

/// 实际扣分
Property ActualDeScore As %String(TRUNCATE = 1);

/// Represent the grade of current EPR
Property GradeDR As %String(TRUNCATE = 1);

/// User reference, represent who will take responsibility
Property SignUserDR As %String(TRUNCATE = 1);

/// 检查时间 (出院为出院时间加7天)
Property ExamineDate As %String(TRUNCATE = 1);

/// Examine time
Property ExamineTime As %String(TRUNCATE = 1);

/// Execute date, system format
Property ExecuteDate As %String(TRUNCATE = 1);

/// Execute time
Property ExecuteTime As %String(TRUNCATE = 1);

/// Is active for this result
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Resume, mainly for manual examine to write reasons
Property ResumeText As %Library.String(COLLATION = "Exact", TRUNCATE = 0);

/// 实际级别
Property ActualGrade As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualityResultHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RuleDR</Value>
</Value>
<Value name="4">
<Value>ActualScore</Value>
</Value>
<Value name="5">
<Value>ActualDeScore</Value>
</Value>
<Value name="6">
<Value>GradeDR</Value>
</Value>
<Value name="7">
<Value>SignUserDR</Value>
</Value>
<Value name="8">
<Value>ExamineDate</Value>
</Value>
<Value name="9">
<Value>ExamineTime</Value>
</Value>
<Value name="10">
<Value>ExecuteDate</Value>
</Value>
<Value name="11">
<Value>ExecuteTime</Value>
</Value>
<Value name="12">
<Value>IsActive</Value>
</Value>
<Value name="13">
<Value>ResumeText</Value>
</Value>
<Value name="14">
<Value>ActualGrade</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualityResultHisD</DataLocation>
<DefaultData>QualityResultHistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRQ.QualityResultHisD</IdLocation>
<IndexLocation>^DHCEPRQ.QualityResultHisI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityResultHisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
