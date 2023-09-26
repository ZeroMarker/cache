/// 名称:DtPortal.NH.NH02NewTransIn
/// 描述:护士长今日提示超时执行
/// 编写者：bmz
/// 编写日期: 2014-12-18
Class DtPortal.NH.NH02Message.NH0201TimeoutExec Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 名称:DtPortal.NH.NH02NewTransIn
/// CreatDate： 2014-12-04
/// Description: 查询护士长今日提示超时执行的信息
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02TimeoutExec","NH020101","059","")
Query NH020101(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,excuteDate:%String,excuteTime:%String,sttDate:%String,sttTime:%String,value:%String,arcimDesc:%String,oecprDesc:%String,excuteNurse:%String")
{
}

ClassMethod NH020101Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
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
	
	//遍历所有医嘱
	/*
	f i=1:1:inNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeId,""))   //遍历医嘱
	.q:oeordId=""
	.s oeoriSub=""
	.s timeoutStr=""
	.f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
	..s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	...s timeoutStr=..ifWrongTimeOrder(EpisodeId,oeordId,oeoriSub,oeoreSub)
	...q:timeoutStr=0
	*/
	//遍历当日医嘱
	f i=1:1:inNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeId,""))   //遍历医嘱
	.q:oeordId=""
	.s ordSttDate=""
	.f ordSttDate=+$h:1:+$h d   //查询今天和明天的，长嘱不查询今天的
	..s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime)) q:ordSttTime=""  d
	...s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime,oeoriSub)) q:oeoriSub=""  d
	....s oeoreSub=0 f  s oeoreSub=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime,oeoriSub,oeoreSub)) q:oeoreSub=""  d
	.....s timeoutStr=..ifWrongTimeOrder(EpisodeId,oeordId,oeoriSub,oeoreSub)
	.....q:timeoutStr=0
	.....d getPatInfo 
	
 	;b ;1
  	q $$$OK
getPatInfo
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
 	s bedCode=$p(patInfoStr,"^",1)
 	s name=$p(patInfoStr,"^",2)
 	s sex=$p(patInfoStr,"^",3)
 	s age=$p(patInfoStr,"^",4)
 	s medicareNo=$p(patInfoStr,"^",5)   //病案号
 	s admReason=$p(patInfoStr,"^",6)    //费用类型
 	s regNo=$p(patInfoStr,"^",7)    //登记号
 	s docDesc=$p(patInfoStr,"^",11)
	s nurseDesc=$p(patInfoStr,"^",12)
	s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
	s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)
    s inDate=$p(inTimeStr,"^",1)
    s inDate=$zd(inDate,3)
    s inTime=$p(inTimeStr,"^",2)
    s inTime=$zt(inTime,2)
    s inDateTime=inDate_"&nbsp;"_inTime
    
    s arcimStr=##Class(web.DHCNurCom).GetArcim(oeoreId)
	s arcimDesc=$p(arcimStr,"^")
	s oecprDesc=$p(arcimStr,"^",3)    //优先级--临时、长期。。。
	s excuteCtpcpDr=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)
	i excuteCtpcpDr'="" s excuteNurse=$p(^CTPCP(excuteCtpcpDr,1),"^",2)
	e  s excuteNurse=""
    s excuteDate=$zd($p(timeoutStr,"^",1),3)
	s excuteTime=$zt($p(timeoutStr,"^",2))
	s sttDate=$zd($p(timeoutStr,"^",3),3)
	s sttTime=$zt($p(timeoutStr,"^",4))
	s val=$p(timeoutStr,"^",5)
	s val1=val
	i val<0 s val=-val
    s value=""
    s value1=val\3600
    i value1'=0 s value=value1_"h"
    s value2=(val-(value1*3600))\60
    i ((value1=0)&&(value2'=0))||(value1'=0) s value=value_value2_"m"
    s value3=(val-(value1*3600)-(value2*60))#60
    s value=value_value3_"s"
    i val1<0 s value="-"_value
    
	d TimeoutExec
	
	q
TimeoutExec
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,excuteDate,excuteTime,sttDate,sttTime,value,arcimDesc,oecprDesc,excuteNurse)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： bmz
/// CreatDate： 2014-12-18
/// Description: 判断超时执行---参考w ##class(Nur.DHCADTDischarge).getIfExistWrongTimeOrder(adm)
/// Input： admId,oeordId,oeoriSub,oeoreSub 
/// Return： flag 1-有 2-无
/// w ##class(DtPortal.NH.NH02TimeoutExec).ifWrongTimeOrder(1476,"1405","1","1")
ClassMethod ifWrongTimeOrder(admId As %String, oeordId As %String, oeoriSub As %String = "", oeoreSub As %String = "") As %String
{
	//s ^bmz(admId,oeordId,oeoriSub,oeoreSub)=1
	q:(oeordId="")&(oeoriSub="")&(oeoreSub="") 0
	s flag=0
	
	s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	
	
	//%Library.ClassDefinition()
	//SET a = ##class(%Library.ClassDefinition).%OpenId("Nur.DHCADTDischarge")
	//if(%Library.ClassDefinition){}
	;s abnormalType="Disch"
	s abnormalType="all"    //新库更改了这个节点，需要修改  ----20150504
	//s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s ifClass = ##class(%Dictionary.ClassDefinition).%OpenId("Nur.DHCADTDischarge",0)
	i ifClass'="" d
	.s id="",abnormalID=""
	.f  s id=$o(^DHCDishChargeSet(abnormalType,"AbnormalStat",id)) q:id=""  d
	..s desc=$p(^DHCDishChargeSet(abnormalType,"AbnormalStat",id),"^",1)
	..q:desc'="执行时间错误"
	..s abnormalID=id
	q:(ifClass'="")&&(abnormalID="") 0
	
	i ifClass'="" d
	.s ignoreStr = ##class(Nur.DHCADTDischarge).getIgnoreOeoreStr(admId)   //判不不需要过滤的医嘱
	.s unNeedAlertOrd=##class(Nur.DHCADTDischarge).ifUnNeedOrd(abnormalID,abnormalType,oeoreId) //不提示的医嘱
	e  d
	.s UnNeedExecLocOrd=##class(web.DHCADTDischarge).UnNeedExecLocOrd(oeoreId)  //不需要判断的科室
	.s UnNeedOrdSubCatStr=$G(^DHCCLSet("Disch","UnNeedOrdSubCat"))      //过滤的子医嘱
	.s UnNeedOrdSubCat=##Class(web.DHCCLCom).GetOrdSubCatId(oeoreId)
	
	q:(ifClass'="")&&(ignoreStr[("^"_oeoreId_abnormalType_abnormalID_"^")) 0
	q:(ifClass'="")&&(unNeedAlertOrd=1) 0
	//老库--
	q:(ifClass="")&&(UnNeedExecLocOrd=1) 0
	q:(ifClass="")&&($g(UnNeedOrdSubCatStr)'="")&(("^"_$g(UnNeedOrdSubCatStr)_"^")[("^"_$g(UnNeedOrdSubCat)_"^")) 0
	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
    q:ordStatCode'="V" 0
	

	
	s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16) //执行状态
	s execStatusCode=""
    i execStatusId'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1)
    q:execStatusCode'="F" 0
    s priCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
    s timeRange=^DHCDishChargeSet(abnormalType,"TimeRange",priCode)   //维护--直接设置global，用于老项目
    q:timeRange="" 0
    s excuteDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",19)
    s excuteTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",20)
    s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
    s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)
    s value=(excuteDate-sttDate)*86400+excuteTime-sttTime
    ;b ;1
    q:(value<=(timeRange*60))&&(value>0) 0
	;s flag=1
	s flag=excuteDate_"^"_excuteTime_"^"_sttDate_"^"_sttTime_"^"_value
	q flag
}

}
