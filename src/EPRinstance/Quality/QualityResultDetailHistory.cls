/// Desc:		质控自动任务触犯条目明细历史表
/// Creator:		Candy
/// CreateDate:	2014-10-10
Class EPRinstance.Quality.QualityResultDetailHistory Extends (%Persistent, %XML.Adaptor)
{

Relationship TheResultHistory As EPRinstance.Quality.QualityResultHistory [ Cardinality = parent, Inverse = DetailsHistory ];

Property People As EPRinstance.Quality.QualityResultPeople;

Property EpisodeID As %String(TRUNCATE = 1);

/// Quality entry reference
Property EntryDR As %String(TRUNCATE = 1);

Property ExamCount As %String(TRUNCATE = 1);

/// Current score for <EntryDR>
Property EntryScore As %String(TRUNCATE = 1);

Property EntryGrade As %String(TRUNCATE = 1);

/// Trigger date
Property TriggerDate As %String(TRUNCATE = 1);

/// Whether active or not
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Notes
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0);

Storage Default
{
<Data name="QualityResultDetailHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>People</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>EntryDR</Value>
</Value>
<Value name="5">
<Value>ExamCount</Value>
</Value>
<Value name="6">
<Value>EntryScore</Value>
</Value>
<Value name="7">
<Value>EntryGrade</Value>
</Value>
<Value name="8">
<Value>TriggerDate</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DetailsHistory")</DataLocation>
<DefaultData>QualityResultDetailHistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DetailsHistory")</IdLocation>
<IndexLocation>^DHCEPRQ.QualityResultDetailHisI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityResultDetailHisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
