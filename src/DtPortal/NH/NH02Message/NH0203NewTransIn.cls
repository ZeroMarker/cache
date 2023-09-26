/// 名称:DtPortal.NH.NH02Message.NH0203NewTransIn
/// 描述：护士长今日提示信息新转入患者的信息
/// 编写者：bmz
/// 编写日期: 2014-12-04
Class DtPortal.NH.NH02Message.NH0203NewTransIn Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 名称:DtPortal.NH.NH02Message.NH0203NewTransIn
/// CreatDate： 2014-12-04
/// Description: 查询护士长今日提示信息新转入患者的信息
/// Input：  userCode         type 1-查询新入院   2-查询新转入
/// Return： 
/// 服务代码 NH02.03.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0203NewTransIn","NH020301","2156","5","0:00")
Query NH020301(userCode As %String, wardId As %String, type As %String = "") As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,tranDateTime:%String,inDeptDesc:%String")
{
}

ClassMethod NH020301Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String, type As %String = "") As %Status
{
	New (qHandle,userCode,wardId,type)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	//默认为1 查询新入院
	i type="" s type=1
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Quit:admIdStr="" $$$OK
	Set inNum=$l(admIdStr,"^")
	
	
	//新转入患者就诊Id串
	s newTransInStr=""
	//新入院患者就诊Id串
	s newInpat=""
	
	if (type=1){
		f i=1:1:inNum d
		.s PAAdm=""
		.s PAAdm=$p(admIdStr,"^",i)
		.q:PAAdm=""
		.q:(..ifNewInHosp(PAAdm))=0
		.i newInpat="" s newInpat=PAAdm
		.e  s newInpat=newInpat_"^"_PAAdm
		.s inDeptDesc="新入院"   //转入科室
		.s tranDateTime=""     //转入日期
		.d getPatInfo
	}elseif(type=2){
		
		s newInHosTime=##Class(DtPortal.Common.PublicService).getValueByCode("NEWINHOSTIME")  //取配置时间点
		if (newInHosTime="")||(newInHosTime'[":") s newInHosTime="0:00"
	
		s newInHosTimeValue=$zth(newInHosTime)
		s currDate=+$h
		s currTime=$p($h,",",2)
		
		
		f i=1:1:inNum d
		.s PAAdm=""
		.s PAAdm=$p(admIdStr,"^",i)
		.q:PAAdm=""
		.s firstInDept=""     //记录转科前的科室
		.s firstInWard=""     //记录转科前的病区
		.s secInDept=""      //记录转科后的科室
		.s secInWard=""      //记录转科后的病区
		.s secInWardDate=""  //记录转病区日期
		.;b ;12
		.s child=0
		.f  s child= $o(^PAADM(PAAdm,"TRANS",child)) q:child=""  d
		..s TransStartDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",1)
		..s TransEndDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",3)
		..s TransLocDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",6)
		..s TransWardDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",9)
		
		..i (TransLocDr'="")&(firstInDept="")&(secInDept="") s firstInDept=TransLocDr  //记录转科前的科室
		..i (TransWardDr'="")&(firstInWard="")&(secInWard="") s firstInWard=TransWardDr // 转科前病区
		..i (TransLocDr'="")&(firstInDept'="")&(firstInDept'=TransLocDr) s secInDept=TransLocDr //转科后科室
		..i (TransWardDr'="")&(firstInWard'="")&(firstInWard'=TransWardDr) d
		...s secInWard=TransWardDr //转科后病区
		...s secInWardDate=TransStartDate  //记录转入病区的日期
		..q:(secInWardDate'=+$h)&&(secInWardDate'=(+$h-1))
		..s TransStartTimeValue=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",2)
		..;i (firstInDept'="")&&(firstInWard'="")&&(secInDept'="")&&(secInWard'="") d
		..i (firstInWard'="")&&(secInWard'="") d   //修改为只判断病区的变化
		...q:wardId'=secInWard
		...i (((currTime>newInHosTimeValue)&&(secInWardDate=currDate))||((currTime<=newInHosTimeValue)&&((secInWardDate=currDate)||((secInWardDate=(currDate-1))&&(TransStartTimeValue>newInHosTimeValue))))) d
		....;i newTransInStr="" s newTransInStr=PAAdm 
		....;e  i "^"_newTransInStr_"^"'["^"_PAAdm_"^"     //重复的就诊Id不取
		....;.s newTransInStr=newTransInStr_"^"_PAAdm
		....q:("^"_newTransInStr_"^")[("^"_PAAdm_"^")     //重复的就诊Id不取
		
		....s inDeptDesc=$p(^CTLOC(firstInDept),"^",2)
		....i inDeptDesc["-" s inDeptDesc=$p(inDeptDesc,"-",2)  //来源科室
		....s TransStartTime=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",2)
		....s tranDateTime=$zd(TransStartDate,3)_"&nbsp;"_$zt(TransStartTime)
		....d getPatInfo
		....s firstInDept=secInDept
		....s secInDept=""
		....s firstInWard=secInWard
		....s secInWard=""
		....s secInWardDate=""
	}
	
	
	
	
	
	


  	q $$$OK
  	

getPatInfo
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	;b ;2
 	s bedCode=$p(patInfoStr,"^",1)
 	s name=$p(patInfoStr,"^",2)
 	s sex=$p(patInfoStr,"^",3)
 	s age=$p(patInfoStr,"^",4)
 	s medicareNo=$p(patInfoStr,"^",5)   //病案号
 	s admReason=$p(patInfoStr,"^",6)    //费用类型
 	s regNo=$p(patInfoStr,"^",7)    //登记号
 	s docDesc=$p(patInfoStr,"^",11)
	s nurseDesc=$p(patInfoStr,"^",12)
	s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm)
	s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(PAAdm)
    s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(PAAdm)
    s inDate=$p(inTimeStr,"^",1)
    s inDate=$zd(inDate,3)
    s inTime=$p(inTimeStr,"^",2)
    s inTime=$zt(inTime,2)
    s inDateTime=inDate_"&nbsp;"_inTime
 	
    i tranDateTime="" s tranDateTime=inDateTime   //新入院的患者取入院时间
	d newTransIn
	
	q

newTransIn
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,tranDateTime,inDeptDesc)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// 获取用户第一次入院的科室
/// w ##class(DtPortal.NH.NH02Message.NH0203NewTransIn).getPatFirstLocID()
ClassMethod getPatFirstLocID(admID)
{
	n (admID)
	s retLocID=""
	s quitFlag=0
	s child=0
	f  s child= $o(^PAADM(admID,"TRANS",child)) q:(child="")||(quitFlag=1)  d 
	.s TransLocDr=$p($g(^PAADM(admID,"TRANS",child)),"^",6)   //转科科室
	.i TransLocDr'="" d
	..s quitFlag=1
	..s retLocID=TransLocDr
	
	q retLocID
}

/// 判断当前在院患者是否新入院
/// w ##class(DtPortal.NH.NH02Message.NH0203NewTransIn).ifNewInHosp()
ClassMethod ifNewInHosp(admID)
{
	n (admID)
	s flag=0
	if +admID=0 q flag
	s currDate=+$h
	s currTime=$p($h,",",2)
	s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(admID)
	s admDate=$p(inDateTimeStr,"^",1)
	if admDate="" q flag
	
	q:(admDate'=+$h)&&(admDate'=(+$h-1)) flag
	s admTime=$p(inDateTimeStr,"^",2)
	if admTime="" s admTime=0
	
	s newInHosTime=##Class(DtPortal.Common.PublicService).getValueByCode("NEWINHOSTIME")  //取配置时间点
	if (newInHosTime="")||(newInHosTime'[":") s newInHosTime="0:00"
	
	s newInHosTimeValue=$zth(newInHosTime)
	
	
	if (currTime>newInHosTimeValue) {
		//当前时间大于配置时间，直接取当天的
		if (admDate=+$h) s flag=1
	}else{
		//当前时间小于配置时间，取（当天的）和（昨天的就诊时间大于配置时间的）
		if ((admDate=+$h)||((admDate=(+$h-1))&&(admTime>newInHosTimeValue))) {
			s flag=1
		}
	}
	
	
	q flag
}

}
