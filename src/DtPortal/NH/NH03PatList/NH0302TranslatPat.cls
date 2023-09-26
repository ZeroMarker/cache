/// DtPortal.NH.NH03PatList.NH0302TranslatPat
/// 描述:护士长转科患者
/// 编写者：程鹏
/// 编写日期: 2018-11-22
Class DtPortal.NH.NH03PatList.NH0302TranslatPat Extends %RegisteredObject
{

/// 名称:DtPortal.NH.NH03AdmitList
/// CreatDate： 2014-12-04
/// Description: 查询护士长患者列表转科患者的信息----只取护士长默认病区的
/// Input：  UserCode,Type 1-转入  2-转出  ,date-- yyyy-mm-dd   
/// Return： 
/// 服务代码 NH03.02.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH03PatList.NH0302TranslatPat","NH030201TranslatPat","2156","2","1")
Query NH030201TranslatPat(UserCode As %String, Type As %String, WardId As %String, StartDate As %String, EndDate As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inTime:%String,currLoc:%String,firstLoc:%String,secLoc:%String,tranDate:%String,tranTime:%String,inDateTime")
{
}

ClassMethod NH030201TranslatPatExecute(ByRef qHandle As %Binary, UserCode As %String, Type As %String, WardId As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK
	
	s Today=+$h
	if StartDate["-"  Set StartDate=$zdh(StartDate,3)
	if EndDate["-" Set EndDate=$zdh(EndDate,3)
	if StartDate="" Set StartDate=Today
	if EndDate=""  Set EndDate=Today
	
	for TraDate=StartDate:1:EndDate d
	.s TRANSStartTime=""
	.f  s TRANSStartTime=$o(^PAADMi("TransDateTime",TraDate,TRANSStartTime)) q:TRANSStartTime=""  d
	..s PAAdm=""
	..f  s PAAdm=$o(^PAADMi("TransDateTime",TraDate,TRANSStartTime,PAAdm)) q:PAAdm=""  d
	...s child=""
	...s PaadmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...q:PaadmVisitStatus'="A"   //出院病人退出---非在院病人
	...s FindTodayTransferInfo($j,PAAdm)=1		//把有转科的病人存入数组中，用于一个就诊号只存一次
	
	//转入
	if (Type=1){
		s PAAdm="" 
		f  s PAAdm=$o(FindTodayTransferInfo($j,PAAdm)) q:PAAdm=""  d
		.s firstInDept=""     //记录转科前的科室
		.s firstInWard=""     //记录转科前的病区
		.s secInDept=""      //记录转科后的科室
		.s secInWard=""      //记录转科后的病区
		.s child=0
		.f  s child= $o(^PAADM(PAAdm,"TRANS",child)) q:child=""  d
		..s TransStartDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",1)
		..s TransEndDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",3)
		..s TransTime=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",2)
		..s TransEndTime=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",4)
		..s TransLocDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",6)
		..s TransWardDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",9)
		..;q:TransLocDr=""
		..i (TransLocDr'="")&(firstInDept="")&(secInDept="") s firstInDept=TransLocDr  //记录转科前的科室
		..i (TransWardDr'="")&(firstInWard="")&(secInWard="") s firstInWard=TransWardDr // 转科前病区
		..i (TransLocDr'="")&(firstInDept'="")&(firstInDept'=TransLocDr) s secInDept=TransLocDr //转科后科室
		..i (TransWardDr'="")&(firstInWard'="")&(firstInWard'=TransWardDr) s secInWard=TransWardDr //转科后科室
		..s flag=0
		..i (firstInDept'="")&&(firstInWard'="")&&(secInDept'="")&&(secInWard'="") d
		...s flag=1
		...q:(TransStartDate<StartDate)
		...q:(TransEndDate'="")&(TransEndDate>EndDate)    //转科结束时间
		...q:(secInWard'="")&(WardId'=secInWard)  		 //转入查询，非本病区退出
		...d getPatInfo
		..i flag=1 d
		...s firstInDept=secInDept
		...s secInDept=""
		...s firstInWard=secInWard
		...s secInWard=""
	}
	
	if (Type=2){
	s PAAdm="" 
	f  s PAAdm=$o(FindTodayTransferInfo($j,PAAdm)) q:PAAdm=""  d
	.s firstInDept=""     //记录转科前的科室
	.s firstInWard=""     //记录转科前的病区
	.s secInDept=""      //记录转科后的科室
	.s secInWard=""      //记录转科后的病区
	.s child=0
	.f  s child= $o(^PAADM(PAAdm,"TRANS",child)) q:child=""  d
	..s TransStartDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",1)
	..s TransEndDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",3)
	..s TransEndTime=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",4)
	..s TransTime=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",2)
	..s TransLocDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",6)
	..s TransWardDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",9)
	..;q:TransLocDr=""
	..i (TransLocDr'="")&(firstInDept="")&(secInDept="") s firstInDept=TransLocDr  //记录转科前的科室
	..i (TransWardDr'="")&(firstInWard="")&(firstInWard="") s firstInWard=TransWardDr // 转科前病区
	..i (TransLocDr'="")&(firstInDept'="")&(firstInDept'=TransLocDr) s secInDept=TransLocDr //转科后科室
	..i (TransWardDr'="")&(firstInWard'="")&(firstInWard'=TransWardDr) s secInWard=TransWardDr //转科后科室
	..s flag=0
	..i (firstInDept'="")&&(firstInWard'="")&&(secInDept'="")&&(secInWard'="") d
	...s flag=1
	...q:(TransStartDate<StartDate)
	...q:(TransEndDate'="")&(TransEndDate>EndDate)    //转科结束时间
	...q:(firstInWard'="")&(WardId'=firstInWard)  		 //转出查询，非本病区退出
	...d getPatInfo
	..i flag=1 d
	...s firstInDept=secInDept
	...s secInDept=""
	...s firstInWard=secInWard
	...s secInWard=""

	}

  	q $$$OK
  	
getPatInfo
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
 	s bedCode=$p(patInfoStr,"^",1)
 	s name=$p(patInfoStr,"^",2)
 	s sex=$p(patInfoStr,"^",3)
 	s age=$p(patInfoStr,"^",4)
 	s medicareNo=$p(patInfoStr,"^",5)   //病案号
 	s admReason=$p(patInfoStr,"^",6)    //费用类型
 	s regNo=$p(patInfoStr,"^",7)    //登记号
 	
	s docDesc="",nurseDesc="",diagnoseDesc="",inDay="",inTime=""
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
    
    s currLoc=$p(^PAADM(PAAdm),"^",4)						//当前科室
    i currLoc'="" s currLoc=$p(^CTLOC(currLoc),"^",2)
    i currLoc["-" s currLoc=$p(currLoc,"-",2)
    
    s firstLoc=$p(^CTLOC(firstInDept),"^",2)				//转科前科室
    i firstLoc["-" s firstLoc=$p(firstLoc,"-",2)
    
    s secLoc=$p(^CTLOC(secInDept),"^",2)				//转科后科室
    i secLoc["-" s secLoc=$p(secLoc,"-",2)
    
    s tranDate=$zd(TransStartDate,3)
    s tranTime=$zt(TransTime,2)
    
    /*
    i TransEndDate="" d
    .s tranDate=$zd(TransStartDate,3)
    .s tranTime=$zt(TransTime,2)
    e  d
    .s tranDate=$zd(TransEndDate,3)
    .s tranTime=$zt(TransEndTime,2)
    */
	d TranslatList
	
	q  	
  	
 	
  	
  	
 
TranslatList
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inTime,currLoc,firstLoc,secLoc,tranDate,tranTime,inDateTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
