/// 门诊监控服务
/// 20160205bmz
Class DtPortal.OD.OD01OutpatientMonitor Extends %RegisteredObject
{

/// 名称:DtPortal.OD.OD01OutpatientMonitor
/// CreatDate： 20160205
/// Description:查询所有号别类型
/// Input：          
/// Return： 
/// 服务代码 OD01.04.01
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD01OutpatientMonitor","findRegisterType")
Query findRegisterType(hospID As %String = "") As DtPortal.Query(ROWSPEC = "registerType:%String,registerTypeId:%String")
{
}

ClassMethod findRegisterTypeExecute(ByRef qHandle As %Binary, hospID As %String = "") As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s flag=0
	
	//d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCSessionType","GetList","","","","")
	
	set qdf=##class(%Dictionary.QueryDefinition).%OpenId("web.DHCBL.CT.RBCSessionType||GetList",0)
	if ($IsObject(qdf)&&(hospID'="")){
		set obj=##class(%ResultSet).%New("web.DHCBL.CT.RBCSessionType:GetList")
		d obj.Execute("","","","",hospID)
		//SESSRowId,SESSCode,SESSDesc,SESSSessionTypeDR,SESSNumberOfDays,SESSEnableByDefault,SESSDateFrom,SESSDateTo
		f  Quit:'obj.Next()  d              
		.s SESSRowId=obj.Data("SESSRowId")
		.s SESSCode=obj.Data("SESSCode")  
		.s SESSDesc=obj.Data("SESSDesc")  
		.s SESSSessionTypeDR=obj.Data("SESSSessionTypeDR")  
		.s SESSDateFrom=obj.Data("SESSDateFrom")  
		.s SESSDateTo=obj.Data("SESSDateTo")  
		.q:(SESSDateFrom'="")&&(SESSDateFrom>+$h)
		.q:(SESSDateTo'="")&&(SESSDateTo<+$h)
		.s SESSId=SESSRowId
		.s flag=1
		.d findRegisterType
		
	
	} else {
		s id=0
		f  s id=$o(^RBC("SESS",id)) q:id=""  d
		.s SESSDesc=$p(^RBC("SESS",id),"^",2)
		.;s SESSCode=$p(^RBC("SESS",id),"^",1)
		.s SESSDateFrom=$p(^RBC("SESS",id),"^",6)
		.s SESSDateTo=$p(^RBC("SESS",id),"^",7)
		.q:(SESSDateFrom'="")&&(SESSDateFrom>+$h)
		.q:(SESSDateTo'="")&&(SESSDateTo<+$h)
		.s SESSId=id
		.//s money=##class(DtPortal.OD.OD01OutpatientMonitor).getCostBySess(SESSId)
		.//s SESSDesc=SESSDesc_"("_money_"元)"
		.s flag=1
		.d findRegisterType
	}
	
	
	if (flag=1){
		//其他
		s SESSDesc="其它"
		s SESSId="9999"
		d findRegisterType
	}

	
	q $$$OK
	

  
findRegisterType
    s Data=$lb(SESSDesc,SESSId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// w ##class(DtPortal.OD.OD01OutpatientMonitor).getCostBySess(1)
ClassMethod getCostBySess(SESSId)
{

	s ArcimIdStr="",cost=0
	i SESSId'="" {
		s Child=0 f  s Child=$O(^RBC("SESS",SESSId,"SER",Child)) q:(Child="")  d
		.s ArcimId=$p($G(^RBC("SESS",SESSId,"SER",Child)),"^",1)
		.Q:+ArcimId=0
		.i ArcimIdStr="" s ArcimIdStr=ArcimId
		.e  s ArcimIdStr=ArcimIdStr_"^"_ArcimId
		.s costStr=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimId,+$h,"","","","","","^^^^^^")
		.w !,costStr
		.s cost=cost+$p(costStr,"^",1)
	}
	
	q cost
}

/// 名称:DtPortal.OD.OD01OutpatientMonitor
/// CreatDate： 20160205
/// Description:查询各个大科室门诊号源汇总信息
/// Input：          
/// Return： 
/// 服务代码 OD01.04.02
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD01OutpatientMonitor","findBigDeptRegisterInfo","19901#47^48^52^51^58^69^76^73^223^260^279*19902#59^60*19908#63^57*20001#50^54*20006#67^159*20011#44^45^46*20015#66^65^64*20020#49^53*20021#55^56*382316#")
Query findBigDeptRegisterInfo(bigDeptInfo As %String = "") As DtPortal.Query(ROWSPEC = "bigDeptId,totalRegist,remainTotalRegist,otherRegistStr,finishNum,waitNum:%String,onTimeRate:%String,noRegisterNum:%String")
{
}

ClassMethod findBigDeptRegisterInfoExecute(ByRef qHandle As %Binary, bigDeptInfo As %String = "") As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//全院的号源信息
	s totalRegistAll=0,remainTotalRegistAll=0,finishNumAll=0,waitNumAll=0,noRegisterNumAll=0
	s LocOnScheduleDocSumAll=0,LocDocSumAll=0
	i bigDeptInfo="" q $$$OK
	s length=$l(bigDeptInfo,"*")
	
	s timeRangeIdStr=..getTimeRangeIdStr()
	;s timeRangeIdStr=1
	i timeRangeIdStr="" q $$$OK
	s timeNum=$l(timeRangeIdStr,"^")   //时间id串
	
	s locStrAll=""  //累加所有科室id串
	
	f i=1:1:length d
	.s pamaInfo=$p(bigDeptInfo,"*",i)
	.s bigDeptId=$p(pamaInfo,"#",1)
	.q:+bigDeptId=0
	.s locStr=$p(pamaInfo,"#",2)
	.i locStrAll="" s locStrAll=locStr
	.e  s locStrAll=locStrAll_"^"_locStr
	.s locLen=$l(locStr,"^")
	.s totalRegist=0,remainTotalRegist=0,finishNum=0,waitNum=0,noRegisterNum=0
	.s LocOnScheduleDocSum=0,LocDocSum=0
	.f j=1:1:locLen d
	..s locId=$p(locStr,"^",j)
	..q:locId=""
	..w !,locId 
	
	..f t=1:1:timeNum d
	...s TimeRangeRowID=$p(timeRangeIdStr,"^",t)
	...;w !,TimeRangeRowID
	
	...s RESRowId=""  f  s RESRowId=$o(^RB("RES",0,"CTLOC",locId,RESRowId)) q:RESRowId=""  d
    ....;s ASChildSub=0  f  s ASChildSub=$o(^RBAS(RESRowId,ASChildSub)) q:ASChildSub=""  d
    
    ....s ASSessStartTime=0 f  s ASSessStartTime=$o(^RBAS(RESRowId,0,"DateSTime",+$h,ASSessStartTime)) q:ASSessStartTime=""  d
    .....s ASChildSub=0 f  s ASChildSub=$o(^RBAS(RESRowId,0,"DateSTime",+$h,ASSessStartTime,ASChildSub)) q:ASChildSub=""  d
    
    
    ......s ASDate=$p($g(^RBAS(RESRowId,ASChildSub)),"^",1)
    ......;b ;1
    ......q:ASDate'=+$h
    ......;b ;2
    ......s ASTimeRangeDR=$p(^RBAS(RESRowId,ASChildSub,"DHC"),"^",17)
    ......q:ASTimeRangeDR'=TimeRangeRowID
    ......s ASLoad=+$p($g(^RBAS(RESRowId,ASChildSub)),"^",8)
    ......s AddLoad=+$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",3)
    ......s totalRegist=totalRegist+ASLoad+AddLoad
    ......s totalRegistAll=totalRegistAll+ASLoad+AddLoad   //统计全院的总号源
    ......s QueueNO=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",4)
    ......s retnum=##class(web.DHCRBResourceRule).GetRegisterNum(QueueNO)
	......s RegisterNum=$P(retnum,"^",1)
	......s remainRegist=(ASLoad+AddLoad)-RegisterNum
	......s remainTotalRegist=remainTotalRegist+remainRegist  
	......s remainTotalRegistAll=remainTotalRegistAll+remainRegist   //统计全院的剩余号源
	...//准时出诊率计算标准:(根据号别取医生号别对照里面医生最早登录时间,对比登录时间和开诊时间，取正常开诊的号别数量)/科室当天出诊的号别数量

	...s LocOnScheduleDocSum=LocOnScheduleDocSum+..GetLocOnScheduleDocSum(locId,TimeRangeRowID,+$h,+$h)
	...s LocDocSum=LocDocSum+..GetLocDocSum(locId,TimeRangeRowID,+$h,+$h)
	
	...s LocOnScheduleDocSumAll=LocOnScheduleDocSumAll+..GetLocOnScheduleDocSum(locId,TimeRangeRowID,+$h,+$h)
	...s LocDocSumAll=LocDocSumAll+..GetLocDocSum(locId,TimeRangeRowID,+$h,+$h)

	...s RegAndWaitNum=..GetRegAndWaitNum(locId,TimeRangeRowID)
	...s finishNum=finishNum+$p(RegAndWaitNum,"^",1)
	...s finishNumAll=finishNumAll+$p(RegAndWaitNum,"^",1)  //统计全院的完成人数
	...s waitNum=waitNum+$p(RegAndWaitNum,"^",2)   
	...s waitNumAll=waitNumAll+$p(RegAndWaitNum,"^",2)  //统计全院的等待人数
	...s noRegisterNum=noRegisterNum+$p(RegAndWaitNum,"^",3)  //未报到人数
	...s noRegisterNumAll=noRegisterNumAll+$p(RegAndWaitNum,"^",3)  //全院的未报到人数
	.s depOpenRate=0
	.i LocDocSum'=0 s depOpenRate=$fn(LocOnScheduleDocSum/LocDocSum,"",2)
	.s depOpenRate=depOpenRate*100_"%"    //准时开诊率
	.s otherRegistStr=..getOtherRegistStr(locStr,timeRangeIdStr)
	.d findBigDeptRegisterInfo
	
	//取全院的信息（所有的传参累加）
	s bigDeptId="all"
	s depOpenRate=0
	i LocDocSumAll'=0 s depOpenRate=$fn(LocOnScheduleDocSumAll/LocDocSumAll,"",2)
	s depOpenRate=depOpenRate*100_"%"    //准时开诊率
	s totalRegist=totalRegistAll
	s remainTotalRegist=remainTotalRegistAll
	s finishNum=finishNumAll
	s waitNum=waitNumAll
	s noRegisterNum=noRegisterNumAll   //未报到人数
	s otherRegistStr=..getOtherRegistStr(locStrAll,timeRangeIdStr)
	d findBigDeptRegisterInfo
	
	
	q $$$OK
	

  
findBigDeptRegisterInfo
    s Data=$lb(bigDeptId,totalRegist,remainTotalRegist,otherRegistStr,finishNum,waitNum,depOpenRate,noRegisterNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// 名称:DtPortal.OD.OD01OutpatientMonitor
/// CreatDate： 20160217
/// Description:按小科室串查询门诊号源的各个号源信息
/// Input：          
/// Return： 
/// 服务代码 OD01.04.03
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD01OutpatientMonitor","findLocStrRegisterDetail","89^105^80^45^46^68^70^69^61^26^62^94^71^22^25")
Query findLocStrRegisterDetail(locIdStr As %String = "") As DtPortal.Query(ROWSPEC = "timeType:%String,visitsType:%String,registerTypeId:%String,totalRegist:%String,havaPatNum:%String,waitPatNum:%String,surplusPatNum:%String,locHisId:%String,locDesc:%String,avgTime:%String,ifLate:%String,noRegisterNum:%String,firstLogTime")
{
}

ClassMethod findLocStrRegisterDetailExecute(ByRef qHandle As %Binary, locIdStr As %String = "") As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s timeRangeIdStr=..getTimeRangeIdStr()   //时间段过滤
	;s timeRangeIdStr=1
	i timeRangeIdStr="" q $$$OK
	
	i locIdStr="" q $$$OK
	s length=$l(locIdStr,"^")
	k ^TempLocStrRegisterDetail($j)
	
	
	f i=1:1:length d
	.s LocID=$p(locIdStr,"^",i)
	.s RESRowId=0  f  s RESRowId=$o(^RB("RES",0,"CTLOC",LocID,RESRowId)) q:RESRowId=""  d
    ..;s ASChildSub=0  f  s ASChildSub=$o(^RBAS(RESRowId,ASChildSub)) q:ASChildSub=""  d
    
    ..s ASSessStartTime=0 f  s ASSessStartTime=$o(^RBAS(RESRowId,0,"DateSTime",+$h,ASSessStartTime)) q:ASSessStartTime=""  d
    ...s ASChildSub=0 f  s ASChildSub=$o(^RBAS(RESRowId,0,"DateSTime",+$h,ASSessStartTime,ASChildSub)) q:ASChildSub=""  d
    ....s ASDate=$p($g(^RBAS(RESRowId,ASChildSub)),"^",1)
    
    ....q:ASDate'=+$h
    ....;q:ASDate'=65111
    
    ....s ASTimeRangeDR=$p(^RBAS(RESRowId,ASChildSub,"DHC"),"^",17)
    ....q:(("^"_timeRangeIdStr_"^")'[("^"_ASTimeRangeDR_"^"))  //过滤时间段
    ....s status=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
    ....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)	
	....Q:(status="S")||(status="TR")||(status="PS")
	....Set IrregularFlag=$p(^RBAS(RESRowId,ASChildSub),"^",13)
	....Quit:IrregularFlag="A"
    ....;b ;出诊级别
	....s SessionTypeDr=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",6)
	....i SessionTypeDr="" s SessionTypeDr="9999"
	....;w !,RESRowId_"||"_ASChildSub
	....s ^TempLocStrRegisterDetail($j,LocID,SessionTypeDr,RESRowId_"||"_ASChildSub)=ASTimeRangeDR
	
	
	;s ASTimeRangeDR=$p(timeRangeIdStr,"^",1)
	;s locId=0 f  s locId=$o(^TempLocStrRegisterDetail($j,locId)) q:locId=""  d
	
	f i=1:1:length d
	.s locId=$p(locIdStr,"^",i)
	.q:'$d(^TempLocStrRegisterDetail($j,locId))
	.s SessionTypeDr=0 f  s SessionTypeDr=$o(^TempLocStrRegisterDetail($j,locId,SessionTypeDr)) q:SessionTypeDr=""  d
	..i (SessionTypeDr'="")&&(SessionTypeDr'="9999") s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	..e  s SessionTypeDesc="其他"
	..s OneRBASRowid="" f  s OneRBASRowid=$o(^TempLocStrRegisterDetail($j,locId,SessionTypeDr,OneRBASRowid)) q:OneRBASRowid=""  d
	...s OneQueMarkDr=$p(^RB("RES",+OneRBASRowid),"^",2)
	...q:OneQueMarkDr=""
	...s docDesc=$p(^CTPCP(OneQueMarkDr,1),"^",2)
	...s QueueInfo=..GetQueueInfo(OneRBASRowid,locId)
	...s remainProfessorRegist=$p(QueueInfo,"^",2)    //剩余号源
	...s totalRegist=$p(QueueInfo,"^",1)  //总号源
	...;s waitNum=$p(QueueInfo,"^",3)    //等候人数
	...s visitlevelId=SessionTypeDr   //号别id
	...s visitlevelName=SessionTypeDesc   //号别描述
	...s visitsType=$p(^RB("RES",+OneRBASRowid),"^",17)
	
	...s visitsType=docDesc
	...;w !,locId_"***"_OneRBASRowid_"***"_docDesc
	...;诊室
 	...s RoomID=$p($G(^RBAS(+OneRBASRowid,$p(OneRBASRowid,"||",2),"DHC")),"^",5)
 	...s ASTimeRangeDR=$p(^RBAS(+OneRBASRowid,$p(OneRBASRowid,"||",2),"DHC"),"^",17)
 	...s TimeType=$p($G(^DHCTimeRange(ASTimeRangeDR)),"^",2)    //午别
 	...s TRStartTime=$p($G(^DHCTimeRange(ASTimeRangeDR)),"^",3)   //号别最早时间
 	...s Locid=$p(^RB("RES",+OneRBASRowid),"^",1)
 	...q:Locid=""
 	...s locDesc=$p(^CTLOC(Locid),"^",2)
 	...i locDesc["-" s locDesc=$p(locDesc,"-",2)
 	...s clinicName=""
 	...i RoomID'="" Set clinicName=$p($g(^CTLOC(RoomID)),"^",2)
 	...set RoomName1=$P(clinicName,"-",2)
    ...if RoomName1'="" set clinicName=RoomName1
    ...;s AdmInfo=..GetAdmInfo(OneQueMarkDr)
    ...s startDiagTime=..GetDocFisrtLogTime(Locid,OneQueMarkDr,+$h) //$p(AdmInfo,"^",1)
    ...s DocFisrtLogTime=startDiagTime
    ...;s finishNum=$p(AdmInfo,"^",2)   //完成就诊人数
    ...s TimeRangeRowID=^TempLocStrRegisterDetail($j,locId,SessionTypeDr,OneRBASRowid)
    ...s RegAndWaitNum=..GetRegAndWaitNumByCPId(OneQueMarkDr,TimeRangeRowID,Locid)
    ...s finishNum=$p(RegAndWaitNum,"^",1)
    ...s waitNum=$p(RegAndWaitNum,"^",2)    //等候人数
    ...s noRegisterNum=$p(RegAndWaitNum,"^",3)    //需要报道人数
    ...s SeparateTime=$p($h,",",2)-startDiagTime  ;($zth(startDiagTime,1))
    ...i +startDiagTime'=0 s startDiagTime=$zt(startDiagTime,1)
    ...e  s startDiagTime=""
    ...s averageDiagTime="" //$p($zt(SeparateTime,1),":",1,2)
    ...i finishNum'=0 d
    ....s averageSeconds=SeparateTime\finishNum
    ....s Minute=averageSeconds\60
    ....s Seconds=averageSeconds-(Minute*60)
    ....s averageDiagTime=Minute_":"_Seconds
    ...s currRegist=..GetCurrentAdm(OneQueMarkDr)
    ...s ifArrive=""  //是否迟到
    ...i (TRStartTime>=DocFisrtLogTime)&&(DocFisrtLogTime'=0) s ifArrive="否"
    ...e   s ifArrive="是"    //$zt(DocFisrtLogTime,1)
    ...s firstLogTime=""
    ...i DocFisrtLogTime'="" s firstLogTime=$zt(DocFisrtLogTime)
    ...d findLocStrRegisterDetail
    
    k ^TempLocStrRegisterDetail($j)
    
	q $$$OK
	
	
  
findLocStrRegisterDetail
    s Data=$lb(TimeRangeRowID,visitsType,visitlevelId,totalRegist,finishNum,waitNum,remainProfessorRegist,locId,locDesc,averageDiagTime,ifArrive,noRegisterNum,firstLogTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// 按科室id串查询各个号源的信息
/// w ##class(DtPortal.OD.OD01OutpatientMonitor).getOtherRegistStr(49,1)
ClassMethod getOtherRegistStr(locIDStr As %String, timeRangeIdStr As %String) As %String
{
	
	k ^TempTotalRegist($j)
	k ^TempRemainTotalRegist($j)
	
	s num=$l(locIDStr,"^")
	f i=1:1:num d
	.s LocID=$p(locIDStr,"^",i)
	.q:LocID=""
    .s RESRowId=0  f  s RESRowId=$o(^RB("RES",0,"CTLOC",LocID,RESRowId)) q:RESRowId=""  d
    ..;s ASChildSub=0  f  s ASChildSub=$o(^RBAS(RESRowId,ASChildSub)) q:ASChildSub=""  d
    
    ..s ASSessStartTime=0 f  s ASSessStartTime=$o(^RBAS(RESRowId,0,"DateSTime",+$h,ASSessStartTime)) q:ASSessStartTime=""  d
    ...s ASChildSub=0 f  s ASChildSub=$o(^RBAS(RESRowId,0,"DateSTime",+$h,ASSessStartTime,ASChildSub)) q:ASChildSub=""  d
    
    
    ....s remainTotalRegist=0
    ....s ASDate=$p($g(^RBAS(RESRowId,ASChildSub)),"^",1)
    ....q:ASDate'=+$h
    ....s status=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
    ....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)	
	....Q:(status="S")||(status="TR")||(status="PS")
	....Set IrregularFlag=$p(^RBAS(RESRowId,ASChildSub),"^",13)
	....Quit:IrregularFlag="A"
    ....;出诊级别
	....s SessionTypeDr=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",6)
	....i SessionTypeDr="" s SessionTypeDr="9999"
	....//i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
    ....s ASLoad=+$p($g(^RBAS(RESRowId,ASChildSub)),"^",8)
    ....s ASTimeRangeDR=+$p($g(^RBAS(RESRowId,ASChildSub,"DHC")),"^",17)
    
    ....q:(("^"_timeRangeIdStr_"^")'[("^"_ASTimeRangeDR_"^"))&&(timeRangeIdStr'="")
    ....s AddLoad=+$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",3)
    ....s QueueNO=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",4)
    ....s retnum=##class(web.DHCRBResourceRule).GetRegisterNum(QueueNO)
	....s RegisterNum=$P(retnum,"^",1)
	....s remainRegist=(ASLoad+AddLoad)-RegisterNum
	....s ^TempTotalRegist($j,SessionTypeDr)=(+$g(^TempTotalRegist($j,SessionTypeDr)))+ASLoad+AddLoad
	....s ^TempRemainTotalRegist($j,SessionTypeDr)=(+$g(^TempRemainTotalRegist($j,SessionTypeDr)))+remainRegist

	s otherRegistStr=""
	s SessionTypeDr=0 f  s SessionTypeDr=$o(^TempRemainTotalRegist($j,SessionTypeDr)) q:SessionTypeDr=""  d
	.i (SessionTypeDr'="")&&(SessionTypeDr'="9999") s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	.e  s SessionTypeDesc="其他"
	.s totalRegist=$g(^TempTotalRegist($j,SessionTypeDr))   //总号源
	.s remainTotalRegist=$g(^TempRemainTotalRegist($j,SessionTypeDr))   //剩余号源
	.i otherRegistStr="" s otherRegistStr=SessionTypeDesc_"|"_remainTotalRegist_"|"_totalRegist_"|"_SessionTypeDr
	.e  s otherRegistStr=otherRegistStr_"^"_SessionTypeDesc_"|"_remainTotalRegist_"|"_totalRegist_"|"_SessionTypeDr
	k ^TempRemainTotalRegist($j)
	k ^TempTotalRegist($j)
	
    q otherRegistStr
}

/// 查询当前时段的id串
/// w ##class(DtPortal.OD.OD01OutpatientMonitor).getTimeRangeIdStr()
ClassMethod getTimeRangeIdStr() As %String
{
	s timeRangeIdStr=""
	s id=0
	For  s id=$o(^DHCTimeRange(id)) q:id=""  d
	.s name=$P(^DHCTimeRange(id),"^",2)  
	.s TRValidStartDate=$P(^DHCTimeRange(id),"^",7)  
	.s TRValidEndDate=$P(^DHCTimeRange(id),"^",8)
	.q:(TRValidStartDate'="")&&(TRValidStartDate>+$h)  
	.q:(TRValidEndDate'="")&&(TRValidEndDate<=+$h)
	.s startTime=$P(^DHCTimeRange(id),"^",3)
	.s endTime=$P(^DHCTimeRange(id),"^",4)
	.s currTime=$p($h,",",2)
	.;只取一个标记字段出来
	.i (currTime>startTime)&&(currTime<endTime) d
	..i timeRangeIdStr="" s timeRangeIdStr=id
	..e  s timeRangeIdStr=timeRangeIdStr_"^"_id
	
    q timeRangeIdStr
}

// 根据科室ID得到已就诊人数及等候人数以及未报到人数

ClassMethod GetRegAndWaitNum(LocID As %String, TimeRangeRowID As %String) As %String
{
	q:LocID="" "0^0"
	s RegNum=0,WaitNum=0,noRegisterNum=0
	s QueRowId=0  f  s QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",+$h,LocID,QueRowId)) q:QueRowId=""  d
	.s QuePaadmDr=$list(^User.DHCQueueD(QueRowId),11)
	.s RegistrationFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_QuePaadmDr,""))
	.q:RegistrationFeeId="" 
	.s RBASDr=$list(^User.DHCRegistrationFeeD(RegistrationFeeId),18)
	.s ASDate1=$p($g(^RBAS(+RBASDr,$p(RBASDr,"||",2))),"^",1)
	.q:ASDate1'=+$h
	.s ASTimeRangeDR1=$p(^RBAS(+RBASDr,$p(RBASDr,"||",2),"DHC"),"^",17)
    .q:(TimeRangeRowID'="")&&(ASTimeRangeDR1'=TimeRangeRowID)
	.s QueStateDr=$list(^User.DHCQueueD(QueRowId),14)
	.s QueStateCode=$list(^User.DHCPerStateD(QueStateDr),4)
	.i QueStateCode="到达" s RegNum=RegNum+1
	.i (QueStateCode="等候")||(QueStateCode="复诊")||(QueStateCode="过号") s WaitNum=WaitNum+1
	.i (QueStateCode="报到")||(QueStateCode="未分配") s noRegisterNum=noRegisterNum+1
	q (+RegNum)_"^"_(+WaitNum)_"^"_(+noRegisterNum)
}

// 根据号源ID得到已就诊人数及等候人数以及未报到人数

// 

ClassMethod GetRegAndWaitNumByCPId(CTPCPRowId As %String, TimeRangeRowID As %String, locId As %String = "") As %String
{
	q:CTPCPRowId="" "0^0^0"
	s RegNum=0,WaitNum=0,noRegisterNum=0,allRegNum=0
	s QueRowId=0 f  s QueRowId=$o(^User.DHCQueueI("QueMarkDrIndex",+$h,CTPCPRowId,QueRowId)) q:(QueRowId="")  d
	.s QuePaadmDr=$list(^User.DHCQueueD(QueRowId),11)
	.s RegistrationFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_QuePaadmDr,""))
	.q:RegistrationFeeId="" 
	.s RBASDr=$list(^User.DHCRegistrationFeeD(RegistrationFeeId),18)
	.s ASDate1=$p($g(^RBAS(+RBASDr,$p(RBASDr,"||",2))),"^",1)
	.q:ASDate1'=+$h
	.s ASTimeRangeDR1=$p(^RBAS(+RBASDr,$p(RBASDr,"||",2),"DHC"),"^",17)
    .q:(TimeRangeRowID'="")&&(ASTimeRangeDR1'=TimeRangeRowID)
    .s patLocId=$list(^User.DHCQueueD(QueRowId),4)
	.q:(+locId'=0)&&(+patLocId'=0)&&(patLocId'=locId)
	.s QueStateDr=$list(^User.DHCQueueD(QueRowId),14)
	.s QueStateCode=$list(^User.DHCPerStateD(QueStateDr),4)
	.i QueStateCode="到达" s RegNum=RegNum+1
	.i (QueStateCode="等候")||(QueStateCode="复诊")||(QueStateCode="过号") s WaitNum=WaitNum+1
	.i (QueStateCode="报到")||(QueStateCode="未分配") s noRegisterNum=noRegisterNum+1
	.s allRegNum=allRegNum+1
	q (+RegNum)_"^"_(+WaitNum)_"^"_(+noRegisterNum)_"^"_(+allRegNum)
}

// w ##class(DtPortal.OD.OD01OutpatientMonitor).GetQueueInfo()

ClassMethod GetQueueInfo(RBASStr As %String, locId As %String = "") As %String
{
	s totalRegist=0,remainTotalRegist=0,WaitNum=0,RegNum=0,WaitNum22=0
	q:RBASStr="" totalRegist_"^"_remainTotalRegist_"^"_WaitNum
	For i=1:1:$l(RBASStr,"^") d
	.s RBASRowID=$p(RBASStr,"^",i)
	.s ASLoad=+$p($g(^RBAS(+RBASRowID,$p(RBASRowID,"||",2))),"^",8)
    .s AddLoad=+$P($G(^RBAS(+RBASRowID,$p(RBASRowID,"||",2),"DHC")),"^",3)
    .s totalRegist=totalRegist+ASLoad+AddLoad
    .s QueueNO=$P($G(^RBAS(+RBASRowID,$p(RBASRowID,"||",2),"DHC")),"^",4)
    .s retnum=##class(web.DHCRBResourceRule).GetRegisterNum(QueueNO)
	.s RegisterNum=$P(retnum,"^",1)
	
	
	.s CTPCPRowId=$p(^RB("RES",+RBASRowID),"^",2)
	.q:CTPCPRowId="" 
	.s remainRegist=(ASLoad+AddLoad)-RegisterNum
	.s remainTotalRegist=remainTotalRegist+remainRegist

	q totalRegist_"^"_remainTotalRegist
}

// 得到当前就诊号数

ClassMethod GetCurrentAdm(AdmDocCode As %String)
{
	Set AdmDate=+$h
	Set QueueRowid=0
	Set Time=0
	Set CurrentAdm=0
	for  Set QueueRowid=$o(^User.DHCQueueI("QueMarkDrIndex",AdmDate,AdmDocCode,QueueRowid)) Quit:QueueRowid=""  do
	.Set StatusDr=$list(^User.DHCQueueD(QueueRowid),14)
	.Set StatusDrCode=$list(^User.DHCPerStateD(StatusDr),4)
	.Quit:StatusDrCode'="到达"
	.Set StateTime=$list(^User.DHCQueueD(QueueRowid),17)
	.Set QueNo=$list(^User.DHCQueueD(QueueRowid),10)
	.if Time<StateTime do
	..Set CurrentAdm=QueNo
	..Set Time=StateTime 
	Quit CurrentAdm
}

// 根据科室ID 出诊时段取该科室出诊号别在医生号别对照里面医生登录系统的最早时间早于出诊开始时间的数量

// w ..GetLocOnScheduleDocSum(49,"",+$h,+$h)

ClassMethod GetLocOnScheduleDocSum(LocID As %String, TimeRangeId As %String, SttDate As %String, EndDate As %String) As %String
{
	i SttDate["-" s SttDate=$zdh(SttDate,3)
	i SttDate["/" s SttDate=$zdh(SttDate,4)
	i SttDate="" s SttDate=+$h
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	i EndDate="" s EndDate=+$h
	s OnScheduleDocSum=0
	s RESRowId=0  f  s RESRowId=$o(^RB("RES",0,"CTLOC",LocID,RESRowId)) q:RESRowId=""  d
	.For ASDate=SttDate:1:EndDate d
    ..s ASSessStartTime=0 f  s ASSessStartTime=$o(^RBAS(RESRowId,0,"DateSTime",ASDate,ASSessStartTime)) q:ASSessStartTime=""  d
    ...s ASChildSub=0 f  s ASChildSub=$o(^RBAS(RESRowId,0,"DateSTime",ASDate,ASSessStartTime,ASChildSub)) q:ASChildSub=""  d
    ....s ASTimeRangeDR=$p($g(^RBAS(RESRowId,ASChildSub,"DHC")),"^",17)
    ....q:(TimeRangeId'="")&&(ASTimeRangeDR'=TimeRangeId)
    ....s status=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
    ....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
    ....Q:(status="S")||(status="TR")||(status="PS")
    ....s RESCTPCPDR=$p(^RB("RES",RESRowId),"^",2)
    ....q:RESCTPCPDR="" 
    ....s DocFisrtLogTime=..GetDocFisrtLogTime(LocID,RESCTPCPDR,ASDate)
    ....s TRStartTime=$p(^DHCTimeRange(ASTimeRangeDR),"^",3)
    ....i (TRStartTime>=DocFisrtLogTime)&&(DocFisrtLogTime'=0) s OnScheduleDocSum=OnScheduleDocSum+1
    q OnScheduleDocSum
}

// 根据科室ID 出诊时段取该科室出诊的号别数量

// w ##class(DtPortal.OD.OD01OutpatientMonitor).GetLocDocSum(49,"",+$h,+$h)

ClassMethod GetLocDocSum(LocID As %String, TimeRangeId As %String, SttDate As %String, EndDate As %String) As %String
{
	i SttDate["-" s SttDate=$zdh(SttDate,3)
	i SttDate["/" s SttDate=$zdh(SttDate,4)
	i SttDate="" s SttDate=+$h
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	i EndDate="" s EndDate=+$h
	s DocSum=0
	s RESRowId=0  f  s RESRowId=$o(^RB("RES",0,"CTLOC",LocID,RESRowId)) q:RESRowId=""  d
	.For ASDate=SttDate:1:EndDate d
    ..s ASSessStartTime=0 f  s ASSessStartTime=$o(^RBAS(RESRowId,0,"DateSTime",ASDate,ASSessStartTime)) q:ASSessStartTime=""  d
    ...s ASChildSub=0 f  s ASChildSub=$o(^RBAS(RESRowId,0,"DateSTime",ASDate,ASSessStartTime,ASChildSub)) q:ASChildSub=""  d
    ....s ASTimeRangeDR=$p($g(^RBAS(RESRowId,ASChildSub,"DHC")),"^",17)
    ....q:(TimeRangeId'="")&&(ASTimeRangeDR'=TimeRangeId)
    ....s status=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
    ....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
    ....Q:(status="S")||(status="TR")||(status="PS")
    ....s DocSum=DocSum+1
    q DocSum
}

// 根据号别 出诊日期取号别对应医生最早登录时间

// w ..GetDocFisrtLogTime(49,1568,+$h)

ClassMethod GetDocFisrtLogTime(LocID As %String, MarkDr As %String, Date As %String) As %String
{
	s MarkDrLogOnTime=0
	s DHCMarkDocId=0 f  s DHCMarkDocId=$o(^User.DHCMarkDocI("MarkddepDrIndex",LocID,DHCMarkDocId)) q:DHCMarkDocId=""  d
	.s MarkdMarkDr=$list(^User.DHCMarkDocD(DHCMarkDocId),3)
	.q:MarkdMarkDr'=MarkDr
    .s MarkdDocDr=$list(^User.DHCMarkDocD(DHCMarkDocId),2)
	.s CTPCPCode=$p($g(^CTPCP(MarkdDocDr,1)),"^",1)
	.//w MarkdDocDr,!
	.s Guser1=$$ALPHAUP^SSUTIL4(CTPCPCode)
	.s UserRowid=""
	.i Guser1'=""  d
	..s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",Guser1,"")) 
	.q:UserRowid=""
	.s Logid="",LogonTime=0
    .f  s Logid=$o(^SST("LOG",0,"Date",Date,UserRowid,Logid))  q:(Logid="")||(LogonTime'=0)  d
    ..s LogonLoc = $p($g(^SST("LOG",Logid)),"^",7)
    ..q:LogonLoc'=LocID
    ..s LogonTime=$p($g(^SST("LOG",Logid)),"^",4)
    .//w LogonTime,!
    .if ((MarkDrLogOnTime>LogonTime)||(MarkDrLogOnTime=0))&&(LogonTime'=0) s MarkDrLogOnTime=LogonTime
    q MarkDrLogOnTime
}

ClassMethod findQueueInfo() As %String
{

	q:CTPCPRowId="" "0^0^0"
	
	
	s RegNum=0,WaitNum=0,noRegisterNum=0
	s QueRowId=0 f  s QueRowId=$o(^User.DHCQueueI("QueMarkDrIndex",+$h,CTPCPRowId,QueRowId)) q:(QueRowId="")  d
	.s QuePaadmDr=$list(^User.DHCQueueD(QueRowId),11)
	.s RegistrationFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_QuePaadmDr,""))
	.q:RegistrationFeeId="" 
	.s RBASDr=$list(^User.DHCRegistrationFeeD(RegistrationFeeId),18)
	.s ASDate1=$p($g(^RBAS(+RBASDr,$p(RBASDr,"||",2))),"^",1)
	.q:ASDate1'=+$h
	.s ASTimeRangeDR1=$p(^RBAS(+RBASDr,$p(RBASDr,"||",2),"DHC"),"^",17)
    .q:ASTimeRangeDR1'=TimeRangeRowID
    .s patLocId=$list(^User.DHCQueueD(QueRowId),4)
	.q:(+locId'=0)&&(+patLocId'=0)&&(patLocId'=locId)
	.s QueStateDr=$list(^User.DHCQueueD(QueRowId),14)
	.s QueStateCode=$list(^User.DHCPerStateD(QueStateDr),4)
	.i QueStateCode="到达" s RegNum=RegNum+1
	.i (QueStateCode="等候")||(QueStateCode="复诊")||(QueStateCode="过号") s WaitNum=WaitNum+1
	.i (QueStateCode="报到")||(QueStateCode="未分配") s noRegisterNum=noRegisterNum+1
	q (+RegNum)_"^"_(+WaitNum)_"^"_(+noRegisterNum)
}

/// 名称:DtPortal.OD.OD01OutpatientMonitor
/// CreatDate： 20201117
/// Description:获取当天的号源信息
/// Input：          
/// Return： 
/// 服务代码 
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD01OutpatientMonitor","findRegisterInfoByDay","2020-6-5")
Query findRegisterInfoByDay(date As %String = "") As DtPortal.Query(ROWSPEC = "QueRowId,QuePaadmDr,paadmType,findDate,timeRangeDesc,patLocId,CTPCPRowId,userCode,currStateDesc,currStateTime,statusInfo,hospId,QueNo,appMethod,userStr")
{
}

ClassMethod findRegisterInfoByDayExecute(ByRef qHandle As %Binary, date As %String = "") As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	
	if date="" set date=+$h
	else  set date=$zdh(date,3)
	
	set CTPCPRowId=0
	for {
		set CTPCPRowId=$o(^User.DHCQueueI("QueMarkDrIndex",date,CTPCPRowId))
		q:CTPCPRowId=""
		set QueRowId=0
		for{
			s QueRowId=$o(^User.DHCQueueI("QueMarkDrIndex",date,CTPCPRowId,QueRowId))
			q:QueRowId=""
			//根据CTPCPRowId查询出医生code！！！
			set userID=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId,"0"))
			//w !,^SSU("SSUSR",userID)
			s userCode=""
			if (+userID'=0){
				s userCode=$p($g(^SSU("SSUSR",userID)),"^",1)
			}
			s QuePaadmDr=$list(^User.DHCQueueD(QueRowId),11)
			continue:QuePaadmDr=""
			s paadmType=$p($g(^PAADM(QuePaadmDr)),"^",2)
			
			s RegistrationFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_QuePaadmDr,""))
			q:RegistrationFeeId="" 
			s RBASDr=$list(^User.DHCRegistrationFeeD(RegistrationFeeId),18)
			s ASDate1=$p($g(^RBAS(+RBASDr,$p(RBASDr,"||",2))),"^",1)
			continue:ASDate1'=date
			s ASTimeRangeDR1=$p(^RBAS(+RBASDr,$p(RBASDr,"||",2),"DHC"),"^",17)
			continue:ASTimeRangeDR1=""
			s timeRangeDesc=$p($g(^DHCTimeRange(ASTimeRangeDR1)),"^",2)
		    s patLocId=$list(^User.DHCQueueD(QueRowId),4)
			s QueStateDr=$list(^User.DHCQueueD(QueRowId),14)
			s currStateDesc=$list(^User.DHCPerStateD(QueStateDr),4)
			s currStateTime=$list(^User.DHCQueueD(QueRowId),17)
			s QueNo=$list(^User.DHCQueueD(QueRowId),10)  //号数
			//不抽取是时间范围，默认10分钟
			s noTime=600
			//当前状态时间在10分钟以外不抽取
			s currTime=$p($h,",",2)
			s limitTimeValue=currTime-currStateTime
			if limitTimeValue<0 s limitTimeValue=limitTimeValue+86400
			if (limitTimeValue>noTime){
				//continue
			}
			
			if currStateTime'="" set currStateTime=$zt(currStateTime)
			set queueStatusSub=0,statusInfo=""
			set ifExit=0
			for{
				set queueStatusSub=$o(^DHCQueueStatus(QueRowId,queueStatusSub))
				q:queueStatusSub=""
				set StatusSub=$p($g(^DHCQueueStatus(QueRowId,queueStatusSub)),"^",4)
				s StatusSubDesc=$list(^User.DHCPerStateD(StatusSub),4)
				s StatusSubDate=$p($g(^DHCQueueStatus(QueRowId,queueStatusSub)),"^",1)
				if StatusSubDate'="" set StatusSubDate=$zd(StatusSubDate,3)
				s StatusSubTime=$p($g(^DHCQueueStatus(QueRowId,queueStatusSub)),"^",2)
				if StatusSubTime'="" set StatusSubTime=$zt(StatusSubTime)
				;b ;02
				if (statusInfo=""){
					s statusInfo=StatusSubDesc_"^"_StatusSubDate_"^"_StatusSubTime
				}else{
					s statusInfo=statusInfo_"#"_StatusSubDesc_"^"_StatusSubDate_"^"_StatusSubTime
				}
				if (StatusSubDesc="退号"){
					s ifExit=1
				}
				;w !,statusInfo
			}
			//退号的不统计
			//continue:ifExit=1
			s findDate=$zd(date,3)
			s hospId=""
			s appMethod=##class(DtPortal.OD.OD01OutpatientMonitor).getAppType(QuePaadmDr)
			s userStr=##class(DtPortal.Common.PublicService).GetUserStrByUsercode(userCode)
			s Data=$lb(QueRowId,QuePaadmDr,paadmType,findDate,timeRangeDesc,patLocId,CTPCPRowId,userCode,currStateDesc,currStateTime,statusInfo,hospId,QueNo,appMethod,userStr)
			s ^||CacheTemp(repid,ind)=Data	
			s ind=ind+1
		}
	}
	
	
	
	q $$$OK
}

/// 获取本次门诊就诊的预约方式
/// w ##class(DtPortal.OD.OD01OutpatientMonitor).getAppType("1")
ClassMethod getAppType(AdmRowid As %String) As %String
{
	s return=""
	s RESRowId=0 
	for{
		s RESRowId=$o(^RBAS("PAADM_DR",AdmRowid,RESRowId))
		q:RESRowId=""
		s ASChildSub=0
		for{
			s ASChildSub=$o(^RBAS("PAADM_DR",AdmRowid,RESRowId,ASChildSub))
			q:ASChildSub=""
			s APPTChildSub=0
			for{
				s APPTChildSub=$o(^RBAS("PAADM_DR",AdmRowid,RESRowId,ASChildSub,APPTChildSub))
				q:APPTChildSub=""
				s AppID=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",12)
				s APTMCode=$P(^RBC("APTM",AppID),"^",1)
				s APTMDesc=$P(^RBC("APTM",AppID),"^",2)
				s return=APTMDesc
			}
		}
	}
	q return
}

/// OD01.05.01今日门诊数据
/// zw ##class(DtPortal.OD.OD01OutpatientMonitor).OD010501("")
ClassMethod OD010501(hospID As %String) As %Status
{
	Set $ZT="OD010501Error"
	Set ret = ##class(DtPortal.OutPut).%New()
	set status=1,data="",errMSG=""
	set Date=+$h
	
	k ^||tempOD010501("isExDoc")
	//总出诊，停诊，替诊,已就诊人数，等候人数，未报到人数，总挂号人数
	set allVisitDocNum=0,sVisitDocNum=0,rVisitDocNum=0,regNum=0,waitNum=0,noRegisterNum=0,allRegNum=0,regNumRate=0
	set ResRowId=0
	for
	{
		set ResRowId=$o(^RBAS(ResRowId)) 
		quit:ResRowId=""
		
		
		set locID=$P($G(^RB("RES",ResRowId)),"^",1)
		if locID="" continue
		
		//过滤急诊
		s depType=##class(DtPortal.Common.PublicService).getDeptType(locID)
		continue:depType="E"
		
		//过滤院区
		set hospIDTemp=$P($G(^CTLOC(locID)),"^",22)			//科室所属院区
		continue:((hospID'="")&&(hospIDTemp'=hospID))			//过滤院区
		
		
		set RbScRowId=""
		for
		{
			set RbScRowId=$o(^RBAS(ResRowId,0,"DateSTime",Date,RbScRowId)) 
			quit:RbScRowId=""
			set ctpcpID=$p(^RB("RES",ResRowId),"^",2)
			continue:ctpcpID=""
			continue:$d(^||tempOD010501("isExDoc",ctpcpID))
			s ^||tempOD010501("isExDoc",ctpcpID)=""
			set RbScRowIdsub=""
			for
			{
				set RbScRowIdsub=$o(^RBAS(ResRowId,0,"DateSTime",Date,RbScRowId,RbScRowIdsub)) 
				quit:RbScRowIdsub=""
				
				set ASStatusDr=$p(^RBAS(ResRowId,RbScRowIdsub,"DHC"),"^",10) 		//排班状态
				set statsCode=$p(^DHCRBCASStatus(ASStatusDr),"^",1)
				set statsDesc=$p(^DHCRBCASStatus(ASStatusDr),"^",2)
				
				
				if ((statsCode="N")||(statsCode="R")||(statsCode="A")||(statsCode="AR")){	//正常、替诊、加诊、补诊
					s allVisitDocNum=allVisitDocNum+1
					if (statsCode="R"){
						s rVisitDocNum=rVisitDocNum+1
					}
					set TimeRangeRowID=$p(^RBAS(ResRowId,RbScRowIdsub,"DHC"),"^",17) 
					
					
					set regInfo=..GetRegAndWaitNumByCPId(ctpcpID,"","")
					//w !,regInfo
					set regNum=regNum+$p(regInfo,"^",1)	//到达状态，算已就诊
					set waitNum=waitNum+$p(regInfo,"^",2)	//等候状态，算等候人数
					set noRegisterNum=noRegisterNum+$p(regInfo,"^",3)		//未报到人数
					set allRegNum=allRegNum+$p(regInfo,"^",4)	
					
				}elseif(statsCode="S"){
					s sVisitDocNum=sVisitDocNum+1
				}
				
				//w !,statsDesc
			}
		}
	}
	
	if (+allRegNum'=0){
		s regNumRate=$fn(regNum*100/allRegNum,"",2)
	}
	
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	d jsonObj.Put("allVisitDocNum",allVisitDocNum)
	d jsonObj.Put("sVisitDocNum",sVisitDocNum)
	d jsonObj.Put("rVisitDocNum",rVisitDocNum)
	d jsonObj.Put("regNum",regNum)
	d jsonObj.Put("waitNum",waitNum)
	d jsonObj.Put("noRegisterNum",noRegisterNum)
	d jsonObj.Put("allRegNum",allRegNum)
	d jsonObj.Put("regNumRate",regNumRate)
	Set ret.status = 1
	Set ret.errMSG = ""
	Set ret.data = "["_jsonObj.Json()_"]"
	q ret
OD010501Error
	Set $ZT=""
	Set ret.status = -1
	Set ret.errMSG = $ze
	Set ret.data = ""
	Quit ret
}

/// 名称:DtPortal.OD.OD01OutpatientMonitor
/// CreatDate： 20160205
/// Description:门诊待就诊
/// Input：          
/// Return： 
/// 服务代码 OD01.05.02
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD01OutpatientMonitor","OD010502","")
Query OD010502(hospID As %String) As DtPortal.Query(ROWSPEC = "locID:%String,locDesc:%String,num:%String")
{
}

ClassMethod OD010502Execute(ByRef qHandle As %Binary, hospID As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	k ^||TEMPOD010502
	set ResRowId=0,Date=+$h,waitNum=0
	for
	{
		set ResRowId=$o(^RBAS(ResRowId)) 
		quit:ResRowId=""
		
		set locID=$P($G(^RB("RES",ResRowId)),"^",1)
		if locID="" continue
		//过滤急诊
		s depType=##class(DtPortal.Common.PublicService).getDeptType(locID)
		continue:depType="E"
		//过滤院区
		set hospIDTemp=$P($G(^CTLOC(locID)),"^",22)			//科室所属院区
		continue:((hospID'="")&&(hospIDTemp'=hospID))			//过滤院区
		s waitNum=0
		set RbScRowId=""
		for
		{
			set RbScRowId=$o(^RBAS(ResRowId,0,"DateSTime",Date,RbScRowId)) 
			quit:RbScRowId=""
			set ctpcpID=$p(^RB("RES",ResRowId),"^",2)
			continue:$d(^||TEMPOD010502("isExDoc",ctpcpID))
			s ^||TEMPOD010502("isExDoc",ctpcpID)=""
			set RbScRowIdsub=""
			for
			{
				set RbScRowIdsub=$o(^RBAS(ResRowId,0,"DateSTime",Date,RbScRowId,RbScRowIdsub)) 
				quit:RbScRowIdsub=""
				set ASStatusDr=$p(^RBAS(ResRowId,RbScRowIdsub,"DHC"),"^",10) 		//排班状态
				set statsCode=$p(^DHCRBCASStatus(ASStatusDr),"^",1)
				set statsDesc=$p(^DHCRBCASStatus(ASStatusDr),"^",2)
				if ((statsCode="N")||(statsCode="R")||(statsCode="A")||(statsCode="AR")){	//正常、替诊、加诊、补诊
					
					
					set regInfo=..GetRegAndWaitNumByCPId(ctpcpID,"","")  //(+RegNum)_"^"_(+WaitNum)_"^"_(+noRegisterNum)
					//set regNum=regNum+$p(regInfo,"^",1)	//到达状态，算已就诊
					set waitNum=waitNum+$p(regInfo,"^",2)	//等候状态，算等候人数
					//set noRegisterNum=noRegisterNum+$p(regInfo,"^",3)		//未报到人数
					//set allRegNum=allRegNum+$p(regInfo,"^",4)	
					
					
				}

			}
		}
		set ^||TEMPOD010502("loc",locID)=$g(^||TEMPOD010502("loc",locID))+waitNum
	}
	
	set locID=0
	for {
		set locID=$o(^||TEMPOD010502("loc",locID))
		q:locID=""
		set num=^||TEMPOD010502("loc",locID)
		continue:+num=0
		set ^||TEMPOD010502("numloc",num,locID)=""
	}
	
	s limitNum=0
	
	set num=""
	for {
		set num=$o(^||TEMPOD010502("numloc",num),-1)
		q:num=""
		set locID=0
		for{
			set locID=$o(^||TEMPOD010502("numloc",num,locID))
			q:locID=""
			s limitNum=limitNum+1
			continue:limitNum>10	//只取前10个
			s locDesc=$p($g(^CTLOC(locID)),"^",2)
			i locDesc["-" s locDesc=$p(locDesc,"-",2)
			d OD010502
		}
		
	}
	
	k ^||TEMPOD010502
	
	q $$$OK
	

  
OD010502
    s Data=$lb(locID,locDesc,num)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
