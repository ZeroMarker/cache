/// 名称: DHCMA.Util.EPx.EpisQueue
/// 描述: 就诊队列表
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPx.EpisQueue Extends (%Persistent, User.Abstract, DHCMA.Util.EP.EpisQueue) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property SYSDr As DHCMA.Util.BT.SYSTEM [ Required ];

/// 字典指针
Property SYSOID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 系统+就诊号+状态 索引
Index IdxofTypeEpisID On (EQType, EQEpisID) [ Unique ];

/// 系统+类型+状态 索引
Index IdxofTypeStatus On (EQType, EQStatus);

/// w ##class(DHCMA.Util.EPx.EpisQueue).FetchTask("Disch")
ClassMethod FetchTask(aType As %String) As DHCMA.Util.EPx.EpisQueue
{
	New (aType)
	Set return=""
	Quit:(aType="") return
	
	Set $ZT="FetchTaskErr"
	
	Set xID=0,IsError=0
	For {
		Quit:(return'="")||(IsError>0)
		Set xID=$o(^DHCMA.Util.EPx.EpisQueueI("IdxofTypeStatus"," "_$zcvt(aType,"U"),0,xID))
		Quit:xID=""
		
		Set obj=##class(DHCMA.Util.EPx.EpisQueue).%OpenId(xID)
		Continue:'$IsObject(obj)
		
		Set obj.EQStatus    = 1
		Set obj.EQActDate   = +$h
		Set obj.EQActTime   = $p($h,",",2)
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set IsError=1
	   		Quit
	   	}
		If obj'="" Do obj.%Close()
		
		Set return=obj
	}
	Quit return
	
FetchTaskErr
	Quit ""
}

/// w ##class(DHCMA.Util.EPx.EpisQueue).CreateTask("Disch^11111!!1")
ClassMethod CreateTask(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set Type     = $p(aInputStr,"^",1)
	Set EpisID   = $p(aInputStr,"^",2)
	Set EpisInfo = $p(aInputStr,"^",3)
	Quit:(Type="")||(EpisID="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(EpisID)
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(EpisID)
	Quit:(objSYS="")||(SYSOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.EpisQueueI("IdxofTypeEpisID"," "_$zcvt(Type,"U")," "_$zcvt(EpisID,"U"),0))
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.EpisQueue).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.EpisQueue).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EQType      = Type
	Set obj.EQEpisID    = EpisID
	Set obj.EQEpisInfo  = EpisInfo
	Set obj.EQStatus    = 0
	Set obj.EQActDate   = +$h
	Set obj.EQActTime   = $p($h,",",2)
	Set obj.SYSDr       = objSYS
	Set obj.SYSOID      = SYSOID
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
   	} Else {
	   	Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="EpisQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EQType</Value>
</Value>
<Value name="3">
<Value>EQEpisID</Value>
</Value>
<Value name="4">
<Value>EQEpisInfo</Value>
</Value>
<Value name="5">
<Value>EQStatus</Value>
</Value>
<Value name="6">
<Value>EQActDate</Value>
</Value>
<Value name="7">
<Value>EQActTime</Value>
</Value>
<Value name="8">
<Value>SYSDr</Value>
</Value>
<Value name="9">
<Value>SYSOID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EPx.EpisQueueD</DataLocation>
<DefaultData>EpisQueueDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.EpisQueueD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.EpisQueueI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.EpisQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
