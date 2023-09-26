/// 名称:DtPortal.NH.NH02Message.NH0200FindNum
/// 描述:查询护士长今日提示信息的各个信息数量
/// 编写者：bmz
/// 编写日期: 2014-12-17
Class DtPortal.NH.NH02Message.NH0200FindNum Extends %RegisteredObject
{

/// Creator： bmz
/// CreatDate： 2014-12-03
/// Description: 查询护士长提示信息的各个信息数量
/// Input：  userCode(工号),wardId(病区ID),NotPermissionStr(权限串)  
/// Return： 
/// 服务代码 NH02.00.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0200FindNum","NH020001","411","10","")
Query NH020001(userCode As %String, wardId As %String, NotPermissionStr As %String) As DtPortal.Query(ROWSPEC = "timeoutExecNum:%String,unexcOrderNum:%String,newTransInNum:%String,newAdmissionNum:%String,unMeasTemperNum:%String,noDispensaryNum:%String,cVReportsNum:%String,tempAnomNum:%String,infeDiseNum:%String,InfectionNum:%String,allergicPatNum:%String,fallRiskNum:%String,PressUlcerRiskNum:%String,arrearsPatNum:%String,RejectSpec:%String,RefusalOfMedic:%String,painTipNum:%String,DrugWithAllreadyNum:%String,RequestReturnNum:%String,DischargeZoneNum:%String,SpeOrdNum:%String,ChangeBedNum:%String")
{
}

ClassMethod NH020001Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String, NotPermissionStr As %String) As %Status
{
	;w !,$h,!
	//New (qHandle,userCode,wardId)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:wardId="" $$$OK
	
	Set wardDesc=$p(^PAWARD(wardId),"^",2)
	If wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
	set locWarld=$p(^PAWARD(wardId),"^",5)
	Quit:locWarld="" $$$OK
	
	
	//超时执行数量(View_TimeoutPer)、未执行医嘱数量(View_NonexeTestament)、新转入患者数量(View_NewTransfer)、未测体温患者数量(View_StayTem)、未取药医嘱患者数量(View_NonMedTest)、今日危急值报告数量(View_TodayCrisisRep)
	s timeoutExecNum=0,unexcOrderNum=0,newTransInNum=0,unMeasTemperNum=0,noDispensaryNum=0,cVReportsNum=0
	//体温异常数量(View_TemAbnormal)、传染病数量(View_Infection)、院感数量(View_HosInfection)、过敏患者数量(View_Sufferers)
	s tempAnomNum=0,infeDiseNum=0,InfectionNum=0,allergicPatNum=0
	//跌倒风险数量(View_FallRisk)、压疮风险数量(View_PressulcersRisk)、欠费患者数量(View_ArrearsPat)
	s fallRiskNum=0,PressUlcerRiskNum=0,arrearsPatNum=0
	//拒收标本数量(View_SpecimenRejection)、拒发药数量(View_RefuseDispensing)
	s RejectSpec=0,RefusalOfMedic=0
	//疼痛提示(View_PainTips),已退药(View_StayDrugWithAllready),待退药(View_StayDrugWithdrawal)
	s painTipNum=0,DrugWithAllreadyNum=0,RequestReturnNum=0
	//出院带药(View_DisDurgPatNum)，特殊频次(View_SpecFreOrder)，新入院患者数量(View_NewAdmission)
	s DischargeZoneNum=0,SpeOrdNum=0,newAdmissionNum=0
	//床位变更数量(View_BedChange)
	s ChangeBedNum=0
	//待处理标本(View_PendingSpecimen),退药(View_DrugWithdrawal)
	s PendingSpecimenNum=0,AdmOfCurNum=0  //--待处理标本，退药暂时无服务,先定义
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward","",wardId)
	Quit:admIdStr="" $$$OK
	Set inNNum=$l(admIdStr,"^")
	
	s newInHosTime=##Class(DtPortal.Common.PublicService).getValueByCode("NEWINHOSTIME")  //取配置时间点
	if (newInHosTime="")||(newInHosTime'[":") s newInHosTime="0:00"
	
	s newInHosTimeValue=$zth(newInHosTime)
	
	f i=1:1:inNNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	.;欠费患者
	.i (NotPermissionStr'["^View_ArrearsPat^") d
	..s IsArrears=##class(DtPortal.Common.PaadmService).IsArrears(EpisodeId)
	..if ($p(IsArrears,"^",1)=1) s arrearsPatNum=arrearsPatNum+1 //欠费患者---用统一方法判断
	.s ifInpat=0   //新入院的标记--用于判断统计了新入院就不统计新转入
	.s admDate=$P($g(^PAADM(EpisodeId)),"^",6)
	
	.i (NotPermissionStr'["^View_NewAdmission^") d
	..i (##class(DtPortal.NH.NH02Message.NH0203NewTransIn).ifNewInHosp(EpisodeId)=1)  s newAdmissionNum=newAdmissionNum+1   
	
	.i (NotPermissionStr'["^View_NewTransfer^")&&(..ifNewTransIn(EpisodeId,wardId)=1) s newTransInNum=newTransInNum+1 //新转入
	.i (NotPermissionStr'["^View_TemAbnormal^") d
	..s tempAnomNumValue=##class(DtPortal.NH.NH02Message.NH0207TemperAnom).GetTemperatureTableData(EpisodeId)
	..i $p(tempAnomNumValue,"#",6)=1 s tempAnomNum=tempAnomNum+1    //体温异常人数
	
	.i (NotPermissionStr'["^View_Sufferers^")&&(##class(DtPortal.NH.NH02Message.NH0210AllergicPat).ifPatAlg(EpisodeId)=1) s allergicPatNum=allergicPatNum+1  //过敏
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeId,""))   //遍历医嘱
	.q:oeordId=""
	.s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime)) q:ordSttTime=""  d
	..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime,oeoriSub)) q:oeoriSub=""  d
	...s oeoreSub=0 f  s oeoreSub=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime,oeoriSub,oeoreSub)) q:oeoreSub=""  d
	....i ..ifUnexecOrder(oeordId,oeoriSub,oeoreSub,wardId)=1 d 
	.....i (NotPermissionStr'["^View_NonexeTestament^") s unexcOrderNum=unexcOrderNum+1    //今日未执行数量
	....i (NotPermissionStr'["^View_NonMedTest^")&&(##class(DtPortal.NH.NH02Message.NH0205NoDispensary).ifShouldCollectOrder(oeordId,oeoriSub,oeoreSub)'=0) s noDispensaryNum=noDispensaryNum+1  //未取药
	....i (NotPermissionStr'["^View_TimeoutPer^")&&(##class(DtPortal.NH.NH02Message.NH0201TimeoutExec).ifWrongTimeOrder(EpisodeId,oeordId,oeoriSub,oeoreSub)'=0) s timeoutExecNum=timeoutExecNum+1   //今日超时执行
	.;循环明日的医嘱，用于未取药
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeId,""))   //遍历医嘱
	.q:oeordId=""
	.s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,+$h+1,ordSttTime)) q:ordSttTime=""  d
	..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,+$h+1,ordSttTime,oeoriSub)) q:oeoriSub=""  d
	...s oeoreSub=0 f  s oeoreSub=$o(^OEORDi(0,"Date",oeordId,+$h+1,ordSttTime,oeoriSub,oeoreSub)) q:oeoreSub=""  d
	....i (NotPermissionStr'["^View_NonMedTest^")&&(##class(DtPortal.NH.NH02Message.NH0205NoDispensary).ifShouldCollectOrder(oeordId,oeoriSub,oeoreSub)'=0) d
	.....s noDispensaryNum=noDispensaryNum+1  //未取药
	
	
	//跌倒
	i (NotPermissionStr'["^View_FallRisk^"){
		s fallRiskNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0211FallRisk","NH021101",
		userCode_$c(9813)_wardId)
	}
	
	//压疮
	i (NotPermissionStr'["^View_PressulcersRisk^"){
		s PressUlcerRiskNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0212PressUlcerRisk","NH021201",
		userCode_$c(9813)_wardId)
	}
	
	//拒收标本数量
	i (NotPermissionStr'["^View_SpecimenRejection^") {
		s RejectSpec=##class(DtPortal.Common.PublicService).GetCommonMethodNum("ClassMethod","DHCLIS.DHCRejectSpecimen","GetWardRejectNum",
			wardId_$c(9813)_"")
	}
	
	//传染病报告数量
	i (NotPermissionStr'["^View_Infection^"){
		
		s infeDiseNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0208Epidemic","NH020801",
		userCode_$c(9813)_wardId)
		
	}
	
	//医院感染报告数量
	i (NotPermissionStr'["^View_HosInfection^"){
		
		s InfectionNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0209Infection","NH020901",
		userCode_$c(9813)_wardId)
		
	}
	
	//出院带药
	i (NotPermissionStr'["^View_DisDurgPatNum^"){
		s DischargeZoneNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0228DischargeZone","NH022801",
		userCode_$c(9813)_wardId)
	} 
	
	//特殊频次
	i (NotPermissionStr'["^View_SpecFreOrder^"){
		s SpeOrdNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0219SpeOrd","NH021901",
		userCode_$c(9813)_wardId)
	}
	
	
	//拒发药数量
	i (NotPermissionStr'["^View_RefuseDispensing^"){
		s RefusalOfMedic= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0216RefuOfMedic","NH021601",
		userCode_$c(9813)_wardId)
	}
	
	//未测体温患者数量
	i (NotPermissionStr'["^View_StayTem^"){
		s unMeasTemperNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0204UnmeTemp","NH020401",
		userCode_$c(9813)_wardId)	
	}
    

	//今日危急值报告数量
	i (NotPermissionStr'["^View_TodayCrisisRep^"){	
		s cVReportsNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0206CVReports","NH020601",
		userCode_$c(9813)_wardId)
	}
	
	//疼痛提示数量
	i (NotPermissionStr'["^View_PainTips^"){
		s painTipNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0221PainEvaluation","NH022101",
		userCode_$c(9813)_wardId)
	} 
	
	//待退药***************
	i (NotPermissionStr'["^View_StayDrugWithdrawal^"){
		s RequestReturnNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0233GlucInfo","NH023301",
		userCode_$c(9813)_wardId_$c(9813)_"1")
	}
	
	//已退药数量*********
	i (NotPermissionStr'["^View_StayDrugWithAllready^"){	
		s DrugWithAllreadyNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0233GlucInfo","NH023301",
		userCode_$c(9813)_wardId_$c(9813)_"2")
	}   
	
	//床位变更数量*************
	i (NotPermissionStr'["^View_BedChange^"){
		s ChangeBedNum= ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.NH.NH02Message.NH0235ChangeBed","NH023501",
		userCode_$c(9813)_wardId)	
	}
	d TodayRemiComm
  	q $$$OK
TodayRemiComm
    s Data=$lb(timeoutExecNum,unexcOrderNum,newTransInNum,newAdmissionNum,unMeasTemperNum,noDispensaryNum,cVReportsNum,tempAnomNum,infeDiseNum,InfectionNum,allergicPatNum,fallRiskNum,PressUlcerRiskNum,arrearsPatNum,RejectSpec,RefusalOfMedic,painTipNum,DrugWithAllreadyNum,RequestReturnNum,DischargeZoneNum,SpeOrdNum,ChangeBedNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

// 判断未执行oeordId_"||"_oeoriSub_"||"_oeoreSub

/// Creator： bmz
/// CreatDate： 2014-12-18
/// Description: 判断未执行医嘱---参考##class(web.DHCADTDischarge).GetUnexecOrder(adm,userId)
/// Input： oeordId,oeoriSub,oeoreSub,  wardId 
/// Return： flag 1-有 2-无
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH03NursePatientList","findNursePatientList","059","2")
ClassMethod ifUnexecOrder(oeordId As %String, oeoriSub As %String = "", oeoreSub As %String = "", wardId As %String = "") As %String
{
	q:(oeordId="")||(oeoriSub="")||(oeoreSub="")||(wardId="") 0
	
	//关联医嘱数量不统计
	s relationMainOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39) //关联主医嘱ID
	q:relationMainOrd'="" 0
	
	s flag=0
	s UnNeedOrdSubCatStr=$G(^DHCCLSet("Disch","UnNeedOrdSubCat"))
		
	    s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	    s UnNeedExecLocOrd=##class(web.DHCADTDischarge).UnNeedExecLocOrd(oeoreId)
	    q:UnNeedExecLocOrd=1 0
		s UnNeedOrdSubCat=##Class(web.DHCCLCom).GetOrdSubCatId(oeoreId)
	    q:(UnNeedOrdSubCatStr'="")&(("^"_UnNeedOrdSubCatStr_"^")[("^"_UnNeedOrdSubCat_"^")) 0
	    s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeoreId)
	    q:orcatId="" 0
	    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoreId)
        s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoreId)
	    q:("^"_$g(^DHCCLSet("Exec","UnNeedExecCat"))_"^")[("^"_orcatId_"^") 0
	    s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    	q:userAddId="" 0
    	s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    	q:ctcpId="" 0
    	s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
		q:ctcptId="" 0
    	s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    	q:ctcptInternalType'="DOCTOR" 0
        s curDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardId,"DOCTOR","",oeoreId)
        q:curDocFlag'="Y" 0
    	i ##Class(web.DHCNurCom).IfExecOrder(oeoreId)=1 q 0
    	//判断是否处理，处理过的才显示到未执行
    	//s val=$p(^OEORD(oeordId,"I",oeoriSub,"NUR"),"^",7)
    	s val=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",7)
    	i val'="A" q 0
		s flag=1
	q flag
}

// 判断未执行oeordId_"||"_oeoriSub_"||"_oeoreSub

/// Creator： bmz
/// CreatDate： 2014-12-18
/// Description: 判断是否是当天新转入改病区的病人
/// Input： PAAdm,  wardId 
/// Return： flag 1-有 2-无
/// w ##class(DtPortal.NH.NH02Message.NH0200FindNum).ifNewTransIn("","")
ClassMethod ifNewTransIn(PAAdm As %String, wardId As %String = "") As %String
{
	i (PAAdm=0)||(wardId=0) q 0
	s flag=0
	
	
	s newInHosTime=##Class(DtPortal.Common.PublicService).getValueByCode("NEWINHOSTIME")  //取配置时间点
	if (newInHosTime="")||(newInHosTime'[":") s newInHosTime="0:00"

	s newInHosTimeValue=$zth(newInHosTime)
	s currDate=+$h
	s currTime=$p($h,",",2)
	
	s firstInDept=""     //记录转科前的科室
	s firstInWard=""     //记录转科前的病区
	s secInDept=""      //记录转科后的科室
	s secInWard=""      //记录转科后的病区
	s secInWardDate=""  //记录转病区日期
	;b ;12
	s child=0
	f  s child= $o(^PAADM(PAAdm,"TRANS",child)) q:child=""  d
	.s TransStartDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",1)
	.s TransEndDate=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",3)
	.s TransLocDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",6)
	.s TransWardDr=$p($g(^PAADM(PAAdm,"TRANS",child)),"^",9)
	
	.i (TransLocDr'="")&(firstInDept="")&(secInDept="") s firstInDept=TransLocDr  //记录转科前的科室
	.i (TransWardDr'="")&(firstInWard="")&(secInWard="") s firstInWard=TransWardDr // 转科前病区
	.i (TransLocDr'="")&(firstInDept'="")&(firstInDept'=TransLocDr) s secInDept=TransLocDr //转科后科室
	.i (TransWardDr'="")&(firstInWard'="")&(firstInWard'=TransWardDr) d
	..s secInWard=TransWardDr //转科后病区
	..s secInWardDate=TransStartDate  //记录转入病区的日期
	.q:(secInWardDate'=+$h)&&(secInWardDate'=(+$h-1))
	.i (firstInDept'="")&&(firstInWard'="")&&(secInDept'="")&&(secInWard'="")&&(secInWardDate=+$h)&&(wardId=secInWard) d
	..i (((currTime>newInHosTimeValue)&&(secInWardDate=currDate))||((currTime<=newInHosTimeValue)&&((secInWardDate=currDate)||((secInWardDate=(currDate-1))&&(TransStartTimeValue>newInHosTimeValue))))) d
	...s flag=1
	q flag
}

}
