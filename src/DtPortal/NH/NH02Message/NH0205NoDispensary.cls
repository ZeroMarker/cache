/// 名称:DtPortal.NH.NH02Message.NH0205NoDispensary
/// 描述:护士长今日提示未取药
/// 编写者：bmz
/// 编写日期: 2014-12-19
Class DtPortal.NH.NH02Message.NH0205NoDispensary Extends %RegisteredObject
{

/// 名称:DtPortal.NH.NH02Message.NH0205NoDispensary
/// CreatDate： 2014-12-15
/// Description: 查询护士长今日提示未取药的信息
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.05.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0205NoDispensary","NH020501","2156",1)
Query NH020501(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,arcimDesc:%String,oecprDesc:%String,sttDate:%String,sttTime:%String,doseQtyUnit:%String,phcfrCode:%String,phcinDesc:%String,oeoreId:%String")
{
}

ClassMethod NH020501Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	//New (qHandle,userCode,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	s noDispensaryNum=0  ;ceshi
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Quit:admIdStr="" $$$OK
	Set inNNum=$l(admIdStr,"^")
	
	f i=1:1:inNNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeId,""))   //遍历医嘱
	.q:oeordId=""
	.s ordSttDate=""
	.f ordSttDate=+$h:1:+$h+1 d   //查询今天和明天的，长嘱不查询今天的
	..s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime)) q:ordSttTime=""  d
	...s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime,oeoriSub)) q:oeoriSub=""  d
	....s oeoreSub=0 f  s oeoreSub=$o(^OEORDi(0,"Date",oeordId,ordSttDate,ordSttTime,oeoriSub,oeoreSub)) q:oeoreSub=""  d
	.....s flag=0
	.....s flag=##class(DtPortal.NH.NH02Message.NH0205NoDispensary).ifShouldCollectOrder(oeordId,oeoriSub,oeoreSub)
	.....i flag'=0  d 
	......s noDispensaryNum=noDispensaryNum+1  //未取药
	......s oeoreId=flag
	......d getPatInfo
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
	s doseQtyUnit=$p(arcimStr,"^",2)  //剂量
	s oecprDesc=$p(arcimStr,"^",3)    //优先级--临时、长期
	//s phcfrCode=$p(arcimStr,"^",4)	  //频次
	s phcfrCode=##class(DtPortal.Common.PublicService).GetOeoriFreq(oeoreId)
	s phcinDesc=$p(arcimStr,"^",5)		//用药途径
	
	//要求执行时间   
	i oeoreSub'="" d
	.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)   //keep duplicate
    .s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)  //keep duplicate
    e  d
	.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)   //keep duplicate
    .s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)  //keep duplicate
    
	/*
	s ordStatDesc=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
	s ordStatId=$o(^OEC("OSTAT",0,"Code",ordStatDesc,""))
	;s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	;s ordStatDesc=""
	i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
	s updateDateTime=""
	s updateDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    s updateTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    s updateDateTime=##Class(web.DHCCLCom).FormatDate(updateDate)_" "_##Class(web.DHCCLCom).FormatTime(updateTime)
	s sttDateTime=""
	i oeoreSub'="" d
	.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)   //keep duplicate
    .s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)  //keep duplicate
    e  d
	.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)   //keep duplicate
    .s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)  //keep duplicate
    s sttDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
	s execCtcpDesc=""
	s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	i oeoreSub'="" d
	.s oreStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)
	.i $p(oreStr,"^",15)'="" d
    ..s execCtcpDesc=$p($g(^CTPCP($p(oreStr,"^",15),1)),"^",2)
    s execXUserDesc=""
    s xOrdExecStr=""
    i $g(ordStatDesc)="D" s xOrdExecStr=##Class(web.DHCNurCom).GetXOrdExecInfo(oeoreId)
	i $p(xOrdExecStr,"^")'="" d //ypz 070207
	.s execXUserId=$p(xOrdExecStr,"^")
    .i execXUserId'="" s execXUserDesc=$p($g(^SSU("SSUSR",execXUserId)),"^",2)
 	s ctcpDesc=""
   	s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    i ctcpId'="" s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
	s dispenStat=##Class(web.DHCCLCom).GetDispensingStat(oeoreId)
	i dispenStat="C" s dispenStat="已发"
	i dispenStat="TC" s dispenStat="未发"
	i dispenStat="P" s dispenStat="未发"
	i dispenStat="PC" s dispenStat="部分发"
	s reclocDesc=""
	s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    i reclocId'="" s reclocDesc=$p($p($g(^CTLOC(reclocId)),"^",2),"-",2)
	s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
	s PrescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
	*/
	d NoDispensary
	;b ;2
	q
	
 
  
NoDispensary
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,arcimDesc,oecprDesc,sttDate,sttTime,doseQtyUnit,phcfrCode,phcinDesc,oeoreId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： bmz
/// CreatDate： 2014-12-18
/// Description: 判断未领药(非今日长嘱)---参考##class(Nur.DHCADTDischarge).getUnCollarOrder
/// Input： oeordId,oeoriSub,oeoreSub 
/// Return： flag 0-无 医嘱执行记录id-有
/// w ##class(DtPortal.NH.NH02Message.NH0205NoDispensary).ifShouldCollectOrder("","","")
ClassMethod ifShouldCollectOrder(oeordId As %String, oeoriSub As %String = "", oeoreSub As %String = "") As %String
{

	q:(oeordId="")||(oeoriSub="")||(oeoreSub="") 0
	s flag=0
	s UnNeedOrdSubCatStr=$G(^DHCCLSet("Disch","UnNeedOrdSubCat"))
	    s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	    q:reclocId="" 0
	    q:$p(^CTLOC(reclocId),"^",13)'="D" 0
	    s UnNeedExecLocOrd=##class(web.DHCADTDischarge).UnNeedExecLocOrd(oeoreId)
	    q:UnNeedExecLocOrd=1 0
		s UnNeedOrdSubCat=##Class(web.DHCCLCom).GetOrdSubCatId(oeoreId)
	    q:(UnNeedOrdSubCatStr'="")&(("^"_UnNeedOrdSubCatStr_"^")[("^"_UnNeedOrdSubCat_"^")) 0
	    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
        q:ordStatCode'="V" 0
        s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
    	i execStatusId'="" s execStat=$p($g(^OEC("STAT",execStatusId)),"^",1)
        q:$g(execStat)="D" 0
        s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
        q:(oecprCode="OM")!(oecprCode="OMST")!(oecprCode="OMCQZT")!(oecprCode="OMLSZT") 0    // 增加过滤掉嘱托类医嘱
        q:($g(^DHCCLSet("Disch","TakeDisDrug"))'="Y")&(oecprCode="OUT") 0    //ypz 070605
        s oeoreDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
        q:(oeoreDate=+$h)&(oecprCode="S") 0     //i (oeoriDate=+$h)&(oecprDesc["长期") q
        s dispenStat=##Class(web.DHCCLCom).GetDispensingStat(oeoreId)
	    q:(dispenStat="C")!(dispenStat="") 0  //已发药 和 部分已发药的 不提示未领药
	    
		s flag=oeoreId   //
	q flag
}

}
