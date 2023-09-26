Class EPRinstance.Quality.QualitySpotCheckDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCreateDate On CreateDate;

Index IdxCreateDateCreateUser On (CreateDate, CreateUser);

Index IdxSpotCheck On TheSpotCheck;

Relationship TheSpotCheck As EPRinstance.Quality.QualitySpotCheck [ Cardinality = parent, Inverse = Details ];

Property EpisodeID As %String(TRUNCATE = 1);

Property CreateUser As %String(TRUNCATE = 1);

Property UserGroupID As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

/// 手工质控操作类型
Property Action As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualitySpotCheckDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>CreateUser</Value>
</Value>
<Value name="4">
<Value>UserGroupID</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>Action</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Details")</DataLocation>
<DefaultData>^DHCEPRQ.QualitySpotCheckDetailD</DefaultData>
<IdLocation>^DHCEPRQ.QualitySpotCheckDetailD</IdLocation>
<IndexLocation>^DHCEPRQ.QualitySpotCheckDetailI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualitySpotCheckDetails</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
