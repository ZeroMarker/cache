/// 名称: DHCHAI.DP.LabVisitNumber
/// 描述: 检验标本（检验号为唯一索引）
/// 编写者：zhufei
/// 编写日期: 2017-05-11
Class DHCHAI.DP.LabVisitNumber Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property LabEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 检验号/标本号
Property LabEpisodeNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 标本
Property LabSpecimen As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 申请科室|送检科室
Property LabLocDr As DHCHAI.BT.Location;

/// 采集日期
Property LabCollDate As %Date;

/// 采集时间
Property LabCollTime As %Time;

/// 采集者（ID|Code|Desc）
Property LabCollUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接收日期
Property LabRecDate As %Date;

/// 接收时间
Property LabRecTime As %Time;

/// 接收者（ID|Code|Desc）
Property LabRecUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property LabSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property LabXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property LabIsActive As %Boolean [ Required ];

/// 更新日期
Property LabUpdateDate As %Date [ Required ];

/// 更新时间
Property LabUpdateTime As %Time [ Required ];

/// 申请病区|送检病区  //add 2018-07-09
Property LabWardDr As DHCHAI.BT.Location;

/// 医嘱备注 add 20230424
Property LabReqNotes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码+记录索引码索引
Index IndexSCodeXCode On (LabSCode As Exact, LabXCode As Exact);

/// 就诊记录索引
Index IndexEpisodeDr On LabEpisodeDr;

/// 检验条码索引
Index IndexLabEpisodeNo On LabEpisodeNo As Exact;

/// 接收日期时间索引
Index IndexRecDateTime On (LabSCode, LabRecDate, LabRecTime);

/// 接收日期时间索引
Index IndexEpisodeDrRecDate On (LabEpisodeDr, LabSCode, LabRecDate);

/// 更新日期 索引
Index IndexEpisUpdateDate On (LabEpisodeDr, LabUpdateDate);

/// 标本 索引
Index IndexSpecimen On LabSpecimen;

/// Creator：     zhufei
/// CreatDate：   2018-03-26
/// Description:  根据ID作废送检记录
/// Table：       DHCHAI.DP.LabVisitNumber
/// Input：       id:    DHCHAI.DP.LabVisitNumber.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitNumber).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.LabVisitNumber).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.LabIsActive   = 0
	Set obj.LabUpdateDate = +$h
	Set obj.LabUpdateDate = $p($h,",",2)
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-11
/// Description:  根据ID取检验医嘱
/// Table：       DHCHAI.DP.LabVisitNumber
/// Input：       ID:    DHCHAI.DP.LabVisitNumber.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitNumber).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabVisitNumber
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabVisitNumber).%ExistsId(+id) return
	Set obj=##Class(DHCHAI.DP.LabVisitNumber).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-19
/// Description:  根据索引码取检验医嘱
/// Table：       DHCHAI.DP.LabVisitNumber
/// Input：       aSCode:DHCHAI.DP.LabVisitNumber.LabSCode
/// 				  aXCode:DHCHAI.DP.LabVisitNumber.LabXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitNumber).GetObjByXCode("LIS02","")
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.LabVisitNumber
{
	New (aSCode,aXCode)
	Set return=""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id = $o(^DHCHAI.DP.LabVisitNumberI("IndexSCodeXCode",aSCode,aXCode,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-11
/// Description:  更新检验医嘱
/// Table：       DHCHAI.DP.LabVisitNumber
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitNumber).Update("^296^1610100002^血型(输血科)^HY1066^^^^^|^64201^51666^00741|高华英^LIS01^39997^64504^81936")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set EpisodeDr	= $p(InStr,aSeparete,2)
	Set EpisodeNo	= $p(InStr,aSeparete,3)
	Set Specimen	= $p(InStr,aSeparete,4)
	Set:Specimen="" Specimen ="未维护标本"
	Set LocDr		= $p(InStr,aSeparete,5)
	Set CollDate	= $p(InStr,aSeparete,6)
	Set CollTime	= $p(InStr,aSeparete,7)
	Set CollUser	= $p(InStr,aSeparete,8)
	Set RecDate		= $p(InStr,aSeparete,9)
	Set RecTime		= $p(InStr,aSeparete,10)
	Set RecUser		= $p(InStr,aSeparete,11)
	Set SCode		= $p(InStr,aSeparete,12)
	Set XCode		= $p(InStr,aSeparete,13)
	Set IsActive    = +$p(InStr,aSeparete,14)
	Set UpdateDate	= $p(InStr,aSeparete,15)
	Set UpdateTime	= $p(InStr,aSeparete,16)
	Set:CollDate["-" CollDate = $zdh(CollDate,3)
	Set:CollTime[":" CollTime = $zth(CollTime,1)
	Set:RecDate["-" RecDate = $zdh(RecDate,3)
	Set:RecTime[":" RecTime = $zth(RecTime,1)
	Set WardDr		= $p(InStr,aSeparete,17)
	Set ReqNotes    = $p(InStr,aSeparete,18)
	
	Quit:(EpisodeDr="")||(EpisodeNo="") return
	Quit:(SCode="")||(XCode="") return
	
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
		
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.LabVisitNumberI("IndexSCodeXCode",SCode,XCode,"")) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabVisitNumber).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabVisitNumber).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabEpisodeDr	= objAdm
	Set obj.LabEpisodeNo	= EpisodeNo
	Set obj.LabSpecimen		= Specimen
	Set obj.LabLocDr		= objLoc
	Set obj.LabCollDate		= CollDate
	Set obj.LabCollTime		= CollTime
	Set obj.LabCollUser		= CollUser
	Set obj.LabRecDate		= RecDate
	Set obj.LabRecTime		= RecTime
	Set obj.LabRecUser		= RecUser
	Set obj.LabSCode		= SCode
	Set obj.LabXCode		= XCode
	Set obj.LabIsActive     = IsActive
	Set obj.LabUpdateDate	= +$h
	Set obj.LabUpdateTime	= $p($h,",",2)
	Set obj.LabWardDr       = objWard 
	Set obj.LabReqNotes     = ReqNotes
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-11
/// Description:  删除检验医嘱
/// Table：       DHCHAI.DP.LabVisitNumber
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabVisitNumber).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="LabVisitNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabEpisodeDr</Value>
</Value>
<Value name="3">
<Value>LabEpisodeNo</Value>
</Value>
<Value name="4">
<Value>LabOrdTSDesc</Value>
</Value>
<Value name="5">
<Value>LabOrdTSCode</Value>
</Value>
<Value name="6">
<Value>LabSpecimen</Value>
</Value>
<Value name="7">
<Value>LabLocDr</Value>
</Value>
<Value name="8">
<Value>LabCollDate</Value>
</Value>
<Value name="9">
<Value>LabCollTime</Value>
</Value>
<Value name="10">
<Value>LabCollUser</Value>
</Value>
<Value name="11">
<Value>LabRecDate</Value>
</Value>
<Value name="12">
<Value>LabRecTime</Value>
</Value>
<Value name="13">
<Value>LabRecUser</Value>
</Value>
<Value name="14">
<Value>LabSCode</Value>
</Value>
<Value name="15">
<Value>LabXCode</Value>
</Value>
<Value name="16">
<Value>LabUpdateDate</Value>
</Value>
<Value name="17">
<Value>LabUpdateTime</Value>
</Value>
<Value name="18">
<Value>LabIsActive</Value>
</Value>
<Value name="19">
<Value>LabWardDr</Value>
</Value>
<Value name="20">
<Value>LabReqNotes</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabVisitNumberD</DataLocation>
<DefaultData>LabVisitNumberDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabVisitNumberD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabVisitNumberI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabVisitNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
