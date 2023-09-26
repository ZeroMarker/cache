Class EPRinstance.Quality.QualityDepDisCheck Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisodeID On EpisodeID;

Index IdxEpisodeIDAction On (EpisodeID, Action);

Index IdxCreateDateCreateUser On (CreateDate, CreateUser);

Index IdxComposite On (EpisodeID, Action, IsPass, CreateUser, CreateDate, CreateTime) [ Unique ];

Property EpisodeID As %String(TRUNCATE = 1);

/// action阶段 
Property Action As %String;

/// 是否通过科室终末质控
Property IsPass As %String;

/// 终末质控员
Property CreateUser As %String;

/// 终末质控通过时间
Property CreateDate As %Date;

Property CreateTime As %Time;

/// 备注 -退回病历instanceid
Property Resume As %GlobalBinaryStream(LOCATION = "^DHCEPRQ.QualityDepDisCheckS");

Storage Default
{
<Data name="QualityDepDisCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>IsPass</Value>
</Value>
<Value name="5">
<Value>CreateUser</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>Action</Value>
</Value>
<Value name="9">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualityDepDisCheckD</DataLocation>
<DefaultData>QualityDepDisCheckDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.QualityDepDisCheckD</IdLocation>
<IndexLocation>^DHCEPRQ.QualityDepDisCheckI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityDepDisCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
