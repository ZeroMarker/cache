Class DHCEPRFS.INST.EMRAuthorization Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//就诊号

Property EpisodeID As %String [ Required ];

//操作日期

Property ActDate As %Date [ Required ];

//操作时间

Property ActTime As %Time [ Required ];

//申请操作员

Property ApplyUserID As %String [ Required ];

//授权操作员

Property AuthorizeUserID As %String [ Required ];

//开始日期

Property StartDate As %Date [ Required ];

//开始时间

Property StartTime As %Time [ Required ];

//截止日期

Property EndDate As %Date [ Required ];

//截止时间

Property EndTime As %Time [ Required ];

//自动提交标志

Property AutoCommitFlag As %String(TRUNCATE = 1) [ Required ];

//结束标志

Property FinishFlag As %String(TRUNCATE = 1) [ Required ];

//处理日期

Property ProcessDate As %Date;

//处理时间

Property ProcessTime As %Time;

Index IdxFinishFlag On FinishFlag;

Index IdxEpisodeID On EpisodeID;

Storage Default
{
<Data name="EMRAuthorizationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ActDate</Value>
</Value>
<Value name="4">
<Value>ActTime</Value>
</Value>
<Value name="5">
<Value>ActUserID</Value>
</Value>
<Value name="6">
<Value>StartDate</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
<Value name="8">
<Value>AutoCommitFlag</Value>
</Value>
<Value name="9">
<Value>FinishFlag</Value>
</Value>
<Value name="10">
<Value>ProcessDate</Value>
</Value>
<Value name="11">
<Value>ProcessTime</Value>
</Value>
<Value name="12">
<Value>ApplyUserID</Value>
</Value>
<Value name="13">
<Value>AuthorizeUserID</Value>
</Value>
<Value name="14">
<Value>StartTime</Value>
</Value>
<Value name="15">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.EMRAuthorD</DataLocation>
<DefaultData>EMRAuthorizationDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.EMRAuthorD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.EMRAuthorI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.EMRAuthorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
