/// 门诊病案调阅申请单
Class DHCWMR.SS.RsRquest Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号
Property RREpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案类型
Property RRMrType As DHCWMR.SS.MrType;

/// 病案号
Property RRMrNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案卷
Property RRVolumeDr As DHCWMR.SS.Volume;

/// 申请状态（R申请、A响应、U作废）
Property RRReqStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 申请类型
Property RRReqType As DHCWMR.SS.Dictionary;

/// 申请日期
Property RRReqDate As %Date;

/// 申请科室（指向CT_Loc）
Property RRReqLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 申请时间
Property RRReqTime As %Time;

/// 申请人（指向SS_User）
Property RRReqUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标记
Property RRMarker As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property RRUpdateDate As %Date;

/// 更新时间
Property RRUpdateTime As %Time;

/// 更新人（指向SS_User）
Property RRUpdateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 申请日期 +卷索引
Index IndexRepDateVolumeDr On (RRReqDate, RRVolumeDr);

/// 申请人 +卷索引
Index IndexReqUserVolumeDr On (RRReqUser, RRVolumeDr);

/// Creator：     liyi
/// CreatDate：   2015-03-30
/// Description:  根据ID更新申请状态
/// Table：       DHCWMR.SS.RsRquest
/// Input：       Id : DHCWMR.SS.RsRquest.ID
/// 				  aInputStr:申请状态^更新人
/// 				  aSeparate:分隔符
/// Return：      返回Object
/// w ##class(DHCWMR.SS.RsRquest).UpdateReqStatus(1)
ClassMethod UpdateReqStatus(aId As %String, aInputStr As %String, aSeparate As %String) As DHCWMR.SS.RsRquest
{
	new (aId,aInputStr,aSeparate)
	Set return=0
	Quit:(aId="") return
	
	Set ReqStatus = $p(aInputStr,aSeparate,1)
	Set UpdateUser   = $p(aInputStr,aSeparate,2)
	
	Set obj=##class(DHCWMR.SS.RsRquest).%OpenId(aId)
	Quit:'$IsObject(obj) return
	
	Set obj.RRReqStatus = ReqStatus
	Set obj.RRUpdateDate = +$h
	Set obj.RRUpdateTime = +$p($h,",",2)
	Set obj.RRUpdateUser = UpdateUser
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-03-30
/// Description:  根据ID更新标记
/// Table：       DHCWMR.SS.RsRquest
/// Input：       Id : DHCWMR.SS.RsRquest.ID
/// 			  aMarker:标记
/// Return：      返回Object
/// w ##class(DHCWMR.SS.RsRquest).UpdateMark(1)
ClassMethod UpdateMarker(aId As %String, aMarker As %String) As DHCWMR.SS.RsRquest
{
	new (aId,aMarker)
	Set return=0
	Quit:(aId="") return
	
	Set obj=##class(DHCWMR.SS.RsRquest).%OpenId(aId)
	Quit:'$IsObject(obj) return
	
	Set obj.RRMarker = aMarker
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-03-30
/// Description:  根据ID取门诊病案调阅申请单
/// Table：       DHCWMR.SS.RsRquest
/// Input：       Id : DHCWMR.SS.RsRquest.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.RsRquest).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.RsRquest
{
	new (aId)
	quit:'##class(DHCWMR.SS.RsRquest).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.RsRquest).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-03-30
/// Description:  提交门诊病案调阅申请单
/// Table：       DHCWMR.SS.RsRquest
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.RsRquest).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ID      	= $p(aInputStr,aSeparate,1)
	set VolumeID    = $p(aInputStr,aSeparate,2)
	set ReqStatus   = $p(aInputStr,aSeparate,3)
	set ReqTypeID   = $p(aInputStr,aSeparate,4)
	set ReqDate  	= $p(aInputStr,aSeparate,5)
	set:ReqDate["-" ReqDate=$zdh(ReqDate,3)
	set:ReqDate="" ReqDate=+$h
	set ReqLoc      = $p(aInputStr,aSeparate,6)
	set ReqTime  	= $p(aInputStr,aSeparate,7)
	set:ReqTime[":" ReqTime=$zth(ReqTime,1)
	set:ReqTime="" ReqTime=$p($h,",",2)
	set ReqUser  	= $p(aInputStr,aSeparate,8)
	
	quit:(VolumeID="")||(ReqStatus="") return
	/*
	//一天只允许申请一次
	set return=-100
	quit:($d(^DHCWMR.SS.RsRquestI("IndexRepDateVolumeDr",ReqDate,VolumeID))) return
	Set return = 0
	*/
	if ID="" {
		Set obj=##class(DHCWMR.SS.RsRquest).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.RsRquest).%OpenId(ID)
	}
	
	set objVolume=##class(DHCWMR.SS.Volume).GetObjById(VolumeID)
	quit:'$IsObject(objVolume) return
	
	set objReqType=##class(DHCWMR.SS.Dictionary).GetObjById(ReqTypeID)
	quit:'$IsObject(objReqType) return
	
	set obj.RRVolumeDr    = objVolume
	set obj.RRReqStatus   = ReqStatus
	set obj.RRReqType     = objReqType
	set obj.RRReqDate     = ReqDate
	set obj.RRReqLoc  	  = ReqLoc
	set obj.RRReqTime  	  = ReqTime
	set obj.RRReqUser     = ReqUser
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     liyi
/// CreatDate：   2015-03-30
/// Description:  删除门诊病案调阅申请单
/// Table：       DHCWMR.SS.RsRquest
/// Input：       Id : DHCWMR.SS.RsRquest.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.RsRquest).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RRVolumeDr</Value>
</Value>
<Value name="3">
<Value>RRReqStatus</Value>
</Value>
<Value name="4">
<Value>RRReqType</Value>
</Value>
<Value name="5">
<Value>RRRepDate</Value>
</Value>
<Value name="6">
<Value>RRRepTime</Value>
</Value>
<Value name="7">
<Value>RRRepUser</Value>
</Value>
<Value name="8">
<Value>RRRepLoc</Value>
</Value>
<Value name="9">
<Value>RRUpdateDate</Value>
</Value>
<Value name="10">
<Value>RRUpdateTime</Value>
</Value>
<Value name="11">
<Value>RRUpdateUser</Value>
</Value>
<Value name="12">
<Value>RRReqDate</Value>
</Value>
<Value name="13">
<Value>RRReqLoc</Value>
</Value>
<Value name="14">
<Value>RRReqTime</Value>
</Value>
<Value name="15">
<Value>RRReqUser</Value>
</Value>
<Value name="16">
<Value>RRMarker</Value>
</Value>
<Value name="17">
<Value>RREpisodeID</Value>
</Value>
<Value name="18">
<Value>RRMrType</Value>
</Value>
<Value name="19">
<Value>RRMrNo</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.RsRquestD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.RsRquestD</IdLocation>
<IndexLocation>^DHCWMR.SS.RsRquestI</IndexLocation>
<StreamLocation>^DHCWMR.SS.RsRquestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
