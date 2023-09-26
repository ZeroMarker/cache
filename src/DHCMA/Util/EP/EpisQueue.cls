/// 就诊队列表
Class DHCMA.Util.EP.EpisQueue Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 队列类型（允许自定义、默认:在院Admit,出院Disch,提交病历Emr,编目完成Coding）
Property EQType As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 队列就诊ID
Property EQEpisID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 队列就诊信息
Property EQEpisInfo As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 队列状态（完成1，未完成0）
Property EQStatus As %Boolean;

/// 队列日期
Property EQActDate As %Date;

/// 队列时间
Property EQActTime As %Time;

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据Type取就诊队列信息
/// Table：       DHCMA.Util.EPx.EpisQueue
/// Input：       aInputStr   : Type_"^"_EpisID_"!!"_SYSDr_"^"_EpisInfo
///               ---Type     : 队列类型
///               ---EpisID   : PA_Adm.ID
///               ---SYSDr    : DHCMA.Util.BT.SYSTEM.ID
///               ---EpisInfo : 附加信息
/// Return：      返回String   return>0:成功
/// w ##class(DHCMA.Util.EP.EpisQueue).CreateTask()
ClassMethod CreateTask(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=##class(DHCMA.Util.EPx.EpisQueue).CreateTask(aInputStr)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据Type取就诊队列信息
/// Table：       DHCMA.Util.EPx.EpisQueue
/// Input：       aType  : 队列类型
/// Return：      返回obj
/// w ##class(DHCMA.Util.EP.EpisQueue).FetchTask("Disch")
ClassMethod FetchTask(aType As %String) As DHCMA.Util.EP.EpisQueue
{
	New (aType)
	
	Set objTmp=##class(DHCMA.Util.EPx.EpisQueue).FetchTask(aType)
	Quit:'$IsObject(objTmp) ""
	
	Set obj=##class(DHCMA.Util.EP.EpisQueue).%New()
	Set obj.EQType      = objTmp.EQType
	Set obj.EQEpisID    = objTmp.EQEpisID
	Set obj.EQEpisInfo  = objTmp.EQEpisInfo
	Set obj.EQStatus    = objTmp.EQStatus
	Set obj.EQActDate   = objTmp.EQActDate
	Set obj.EQActTime   = objTmp.EQActTime
	If obj'="" Do obj.%Close()
	Quit obj
}

Storage Default
{
<Data name="EpisQueueState">
<Value name="1">
<Value>EQType</Value>
</Value>
<Value name="2">
<Value>EQEpisID</Value>
</Value>
<Value name="3">
<Value>EQEpisInfo</Value>
</Value>
<Value name="4">
<Value>EQStatus</Value>
</Value>
<Value name="5">
<Value>EQActDate</Value>
</Value>
<Value name="6">
<Value>EQActTime</Value>
</Value>
</Data>
<State>EpisQueueState</State>
<StreamLocation>^DHCMA.Util.EP.EpisQueueS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
