/// Description:  护士长欠费患者服务
/// Creator：     bmz
/// CreatDate:    2015-1-8
Class DtPortal.NH.NH02Message.NH0213ArrearsPat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///   Creator：     bmz
///   CreatDate：   2014-12-4
///   Description:  查询护士长欠费患者的详细信息
///   服务代码：    NH02.13.01
///   Input：       UserCode    :  护士长工号   wardId--病区ID
///   Return：      病人详细信息
///   do ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0213ArrearsPat","NH021301","hs01","30")
Query NH021301(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,TotalCost:%String,Balance:%String")
{
}

ClassMethod NH021301Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	New (qHandle,userCode,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Quit:admIdStr="" $$$OK
	Set inNum=$l(admIdStr,"^")
	
	f i=1:1:inNum d
	.s PAAdm=""
	.s PAAdm=$p(admIdStr,"^",i)
	.q:PAAdm=""
	.;欠费判断走公共方法
	.s IsArrears=##class(DtPortal.Common.PaadmService).IsArrears(PAAdm)
	.q:$p(IsArrears,"^",1)'=1
	.s TotalCost=$p(IsArrears,"^",2)  //总费用 
	.s Balance=$p(IsArrears,"^",3)	//余额
	.;w !,arrPatStr
	.d getPatInfo

	
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
 	s docDesc=$p(patInfoStr,"^",11)
	s nurseDesc=$p(patInfoStr,"^",12)
	s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm)
	s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(PAAdm)
    s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(PAAdm)
    s inDate=$p(inTimeStr,"^",1)
    s dae=inDate
   
    s inDate=$zd(inDate,3)
    s inTime=$p(inTimeStr,"^",2)
    s inTime=$zt(inTime,2)
    s inDateTime=""
    i (dae'="") s inDateTime=inDate_"&nbsp;"_inTime
 	
	d NH021301
	
	q

NH021301
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,TotalCost,Balance)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
