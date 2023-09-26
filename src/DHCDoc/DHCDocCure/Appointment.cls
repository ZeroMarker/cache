/// 治疗流程--预约类
Class DHCDoc.DHCDocCure.Appointment Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  判断执行记录是否已经被预约
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus("691||2||1")
ClassMethod GetExecResultAppStatus(OEORERowId As %String, ByRef DCAARowID As %String = "") As %String
{
   n (OEORERowId,DCAARowID)
   s AppFlag=0
   q:OEORERowId="" AppFlag
   s DCARowId=$o(^DHCDocCure(0,"OEORE",OEORERowId,""))
   i DCARowId'=""  d
   .s DCAAChildSub=0
   .for  s DCAAChildSub=$o(^DHCDocCure(0,"OEORE",OEORERowId,DCARowId,DCAAChildSub)) Q:(DCAAChildSub="")!(AppFlag="1")  d
   ..s Data=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub))
   ..s DCAAStatus=$p(Data,"^",7)
   ..i (DCAAStatus="I")||(DCAAStatus="A")  s AppFlag=1
   ..s DCAARowID=DCARowId_"||"_DCAAChildSub
   q AppFlag
}

/// w ##class(DHCDoc.DHCDocCure.Appointment).GetExecCureAppStatus("295||4||1")
ClassMethod GetExecCureAppStatus(OEORERowId As %String) As %String
{
   n (OEORERowId)
   s AppFlag=""
   q:OEORERowId="" AppFlag
   s DCARowId=$o(^DHCDocCure(0,"OEORE",OEORERowId,""))
	i DCARowId'=""{
	   	s DCAAChildSub=$o(^DHCDocCure(0,"OEORE",OEORERowId,DCARowId,""),-1)
	   	i DCAAChildSub'=""{
		   	s Data=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub))
		   	s DCAAStatus=$p(Data,"^",7)
		   	s AppFlag=DCAAStatus_"^"_DCARowId_"||"_DCAAChildSub
	   	}
	}else{
		;存在预约直接执行的情况，这种没有预约记录的判断是否有有效的治疗记录
		s DCRRowId=##class(DHCDoc.DHCDocCure.Record).GetDCRRowID("",OEORERowId)
		if DCRRowId'=""{
			s DCAAStatus="A"
		   	s AppFlag=DCAAStatus_"^"_""
		}
	}
   q AppFlag
}

/// 建立预约-为多人进行预约
/// w ##class(DHCDoc.DHCDocCure.Appointment).AppInsertBroker("7396!7417!7418^1597^M^5")
ClassMethod AppInsertBroker(Para As %String, InsExpStr As %String = "") As %String
{
	n (Para,InsExpStr,%session)
	s ^tmplog("AppInsertBroker")=Para
	s DCARowId=$P(Para,"^",1)
	s RBASIdStr=$P(Para,"^",2)
	s HOSPID=$p(InsExpStr,"^",1)
	s langid=$p(InsExpStr,"^",2)
	s cspName=$p(InsExpStr,"^",3)
	s:langid="" langid=..%LanguageID()
	s:cspName="" cspName="doccure.cureapplist.hui.csp"
	s ErrorRet=""
	k ErrorAry
	Ts
	for mycount=1:1:$l(RBASIdStr,$c(1)){
		s RBASId=$P(RBASIdStr,$c(1),mycount)
		s NewPara=$p(Para,"^",1)_"^"_RBASId_"^"_$p(Para,"^",3,$l(Para,"^"))
		s ret=..AppInsertHUI(NewPara)
		if ret'=0{
			s errinfo=""
			s ApplyInfo=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(DCARowId,"",InsExpStr)
			if ApplyInfo'="" {
				s ApptSchuldeInfo=##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResApptSchuldeInfo(RBASId,langid)
				s CureAppInfo=$p(ApplyInfo,$c(1),2)
				s ArcimDesc=$p(CureAppInfo,"^")
				s PatientInfo=$p(ApplyInfo,$c(1),1)
				s PatientNo=$p(PatientInfo,"^",2)
				s PatientName=$p(PatientInfo,"^",3)
				s DDCRSLoc=$p(ApptSchuldeInfo,"^",2)   //治疗科室
				s CTCareProv=$p(ApptSchuldeInfo,"^",4)  //预约资源
				s DDCRSDate=$p(ApptSchuldeInfo,"^",5)   //预约日期
				s TimeRangeDesc=$p(ApptSchuldeInfo,"^",7)  //预约时间段
				;s err=ret
				if (ret=100) s err="有参数为空."
				else  if (ret=101) s err="停诊的排班不能预约."
				else  if (ret=1001) s err="已撤销的申请不能预约."
				else  if (ret=102) s err="此排班已经过了预约时间,不能预约."
				else  if (ret=-10031) s err="该申请单包含的项目数量已经约完."
				else  if (ret=-10032) s err="该申请单可预约数量不足."
				else  if (ret=-10033) s err="当前时段无可预约号序."
				else  if ((ret=104)||(ret=105)) s err="插入执行记录错误."
				else  if (ret=106) s err="此排班已预约完,不能再预约."
				else  if (ret=107) s err="该申请存在有效的预约未治疗的记记录,不能重复预约."
				else  if (ret=108) s err="该申请医嘱未缴费,无法进行预约."
				else  if (ret=1081) s err="该患者已出院,无法进行预约."
				else  if (ret=1082) s err="该患者就诊已退号,无法进行预约."
				else  if (ret=202) s err="该申请为直接执行治疗医嘱,不可预约."
				else  if (ret=203) s err="该申请医嘱已停止,不可预约."
				else  s err=":"_ret,ErrorAry(mycount,3)="未知错误,错误代码"
				s errinfo=PatientName_"-"_ArcimDesc_"【"_DDCRSLoc_CTCareProv_" "_DDCRSDate_TimeRangeDesc_"】"_"预约失败,失败原因"_":"_err
				s ErrorAry(mycount,1)=PatientName_"-"_ArcimDesc_"【"_DDCRSLoc_CTCareProv_" "_DDCRSDate_TimeRangeDesc_"】"
				s ErrorAry(mycount,2)=err
			}
			
			if ErrorRet="" s ErrorRet=errinfo
			else  s ErrorRet=ErrorRet_"^"_errinfo ;;<br>
			q
		}
	}
	if ErrorRet=""{
		Tc
	}else{
		Tro	
		s NewErrorRet=""
		for loop=1:1:$l(ErrorRet,"^"){
			s ErrorMsg=ErrorAry(loop,1)_..%Translate(cspName,"预约失败,失败原因",langid)
			if $d(ErrorAry(loop,3)){
				s ErrorMsg=ErrorMsg_":"_..%Translate(cspName,ErrorAry(loop,3),langid)_ErrorAry(loop,2)
			}else{
				s ErrorMsg=ErrorMsg_":"_..%Translate(cspName,ErrorAry(loop,2),langid)
			}
			if NewErrorRet="" s NewErrorRet=ErrorMsg
			else  s NewErrorRet=NewErrorRet_";<br>"_ErrorMsg
		}
		s ErrorRet=NewErrorRet	
	}
	q ErrorRet
}

ClassMethod GetDCADoseAppQty(DCARowId, LogHospID)
{
	new (DCARowId,LogHospID,%session)
	Set DCAOrderDoseQty=1
	Set DCAOEORIDR=$p($g(^DHCDocCure(DCARowId)),"^",2)
	Set AppointAllowExec=$p($g(^DHCDocCure(DCARowId)),"^",20)
	Set DHCDocCureAppDoseQty=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig(DCARowId,"CureLocAppDoseQty","",LogHospID)
	if (AppointAllowExec="Y")!(DHCDocCureAppDoseQty=1){
		Set DCAOrderDoseQty=+$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),2)),"^",1)
		if DCAOrderDoseQty=0 Set DCAOrderDoseQty=1
		Set OERQRowID=$o(^DHCOERefundQTY(0,"OEORI",DCAOEORIDR,""),-1)
		if OERQRowID'=""{
			;若开启了按单次数量预约，部分退费若剩余数量不是单次数量整数倍
			s ActiveQtyStr=##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty(DCAOEORIDR)
			s OrderQty=$p(ActiveQtyStr,"^",1)
			s ApplyAppInfo=..GetApplyAppInfo(DCARowId)
			s ApplyAppedTimes=+$p(ApplyAppInfo,"^",1)
			s ApplyNoAppTimes=+OrderQty-ApplyAppedTimes	
			if ApplyNoAppTimes<DCAOrderDoseQty{
				s DCAOrderDoseQty=ApplyNoAppTimes
			}
		}
	}
	Q DCAOrderDoseQty
}

/// w ##class(DHCDoc.DHCDocCure.Appointment).CheckAdmType()
ClassMethod CheckAdmType(Adm As %String, OrderId As %String)
{
	n (Adm,OrderId)
	s rtn=0
	s AdmType=""
	s:Adm'="" AdmType=$p($g(^PAADM(Adm)),"^",2)
	s AdmVisitStatus=$P($g(^PAADM(Adm)),"^",20)
	s OrderBilled=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),3)),"^",5)
	s OrderReadyToBill=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),12)),"^",26) ;先诊疗后付费
	s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
	if (AdmType="I"){
		if (AdmVisitStatus="D"){
			s rtn="1081"	
		}
	}else{
		if (" 1 2 "[(" "_GetStayStatusFlag_" ")) {
			if (AdmVisitStatus="D") {
				s rtn="1081"	
			}
		}else{
			if (AdmVisitStatus'="A"){
				s rtn="1082"	
			}elseif (OrderBilled'="P")&&(OrderReadyToBill'="Y"){
				s rtn="108"	
			}	
		}
	}
	Q rtn
}

/// w ##class(DHCDoc.DHCDocCure.Appointment).CheckBeforeAppInsert("622","937","M","12618","2")
ClassMethod CheckBeforeAppInsert(DCARowId As %String, RBASId As %String, ReqType As %String, UserDR As %String, LogHospID As %String, JSONType As %String = "", TRTimeRange As %String = "")
{
	new (DCARowId,RBASId,ReqType,UserDR,LogHospID,JSONType,%session,TRTimeRange)
	s rtn=100
	;检查基本参数
	if (DCARowId="")||(RBASId="")||(ReqType=""){
		Q rtn
	}
	s DCAOEORIDR="",Adm="",DCAStatus=""
	Set object = ##class(User.DHCDocCureApp).%OpenId(DCARowId)
	i $IsObject(object) {
		Set DCAOEORIDR=object.DCAOEORIDR.%Id()
		Set Adm=object.DCAAdmDR.%Id()
		Set DCAStatus=object.DCAStatus
		Set DCAApplyExecFlag=object.DCAApplyExec
	}
	d object.%Close()
	if DCAOEORIDR=""{
		Q rtn
	}
	
	s ArcimId=$p(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1),"^",2)
	s OrderBilled=$p(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3),"^",5)
	s PriorityDR=$p($g(^OEORD(+DCAOEORIDR,"I",+$p(DCAOEORIDR,"||",2),1)),"^",8)
	s OrderAddDeptDr="",HospID=""
	s OrderAddDeptDr=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),7)),"^",2)
	if OrderAddDeptDr'="" {
		s HospID=$p($g(^CTLOC(OrderAddDeptDr)),"^",22)	
	}
	
	;就诊类型检查
	s rtn=..CheckAdmType(Adm,DCAOEORIDR)
	Q:rtn'=0 rtn
	
	;检查医嘱信息，目前只有临时医嘱可预约
	if '##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR) {
		;Modify20221222 长期允许预约
		;s rtn="109"	
		;Q rtn
	}
	
	;检查治疗申请单信息	
	;撤销的不可预约
	if DCAStatus="C"{
		s rtn="1001"
		Q rtn
	}
	;未配置治疗医嘱项的不可预约
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,LogHospID)
	if DDCISRowid=""{
		s rtn="201"	
		Q rtn
	}
	;直接执行的不允许预约
	if (DCAApplyExecFlag="Y"){
		s rtn="202"	
		Q rtn
	}else{
		s OrderStatus="",OrderStatusCode=""
		s OrdStatusDR=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",13)
		s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
		if (OrderStatusCode'="V") && (OrderStatusCode'="E") {
			s rtn="203"	
			Q rtn
		}	
	}
	s RBCResSchData=$g(^DHCDocCureRBCResSchdule(RBASId))
	s DDCRSDate=$p(RBCResSchData,"^",4)
	s DDCRSStatus=$p(RBCResSchData,"^",9)
	s MaxNumber=$p(RBCResSchData,"^",10)
	s DDCRSTimeRangeDR=$p(RBCResSchData,"^",5)
	s DDCRSEndAppointTime=$p(RBCResSchData,"^",22)
	s StartTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",3)
	s EndTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",4)
	s EndAppointTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",7)
	if DDCRSEndAppointTime'="" s EndAppointTime=DDCRSEndAppointTime
	if EndAppointTime="" s EndAppointTime=EndTime
	;停诊的资源则不能预约
	if (DDCRSStatus'="N")
	{ 
		s rtn="101"
		Q rtn
	}
	if (DDCRSDate<+$h)||((EndAppointTime'="")&&(DDCRSDate=+$h)&&(EndAppointTime<$p($h,",",2)))
	{
		s rtn="102"
		Q rtn
	}
	;判断最大预约数是否已经预约完
	s AppedNumber=..GetRBCResSchduleAppedNum(RBASId)
	if +AppedNumber=MaxNumber
	{
		s rtn="106"
		Q rtn
	}
	;判断申请单已经预约的数量
	s DCAOrderDoseQty=..GetDCADoseAppQty(DCARowId,LogHospID)
	s ActiveQtyStr=##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty(DCAOEORIDR)
	s OrderQty=$p(ActiveQtyStr,"^",1)
	s ApplyAppInfo=..GetApplyAppInfo(DCARowId)
	s ApplyAppedTimes=+$p(ApplyAppInfo,"^",1)
	s ApplyNoAppTimes=+OrderQty-ApplyAppedTimes
	if +ApplyNoAppTimes'>0
	{
		s rtn="-10031" ;103
		Q rtn
	}
	if ApplyNoAppTimes<DCAOrderDoseQty
	{
		s rtn="-10032" ;1031
		Q rtn
	}
    if (TRTimeRange '= "") {
        s trAvailQty = ##class(DHCDoc.DHCDocCure.ScheduleTR).GetOneTRAvailQty(RBASId, TRTimeRange)
        // 当前时段无可预约号序
        if (trAvailQty = 0) {
            s rtn = "-10033"
            q rtn
        }
    }
	Q 0
}

/// 建立预约
/// w ##class(DHCDoc.DHCDocCure.Appointment).AppInsertHUI("134^163^M^18881^2")
ClassMethod AppInsertHUI(Para As %String, JSONType As %String = "") As %String
{
	n (Para,JSONType,%session)
    s ^TMP("AppInsert")=Para
	s rtn=100
	s DCARowId=$P(Para,"^",1)
	s RBASId=$P(Para,"^",2)
	s ReqType=$P(Para,"^",3)
	s UserDR=$P(Para,"^",4)
	s LogHospID=$P(Para,"^",5)
    s TRTimeRange=$P(Para,"^",6)
	s ret=..CheckBeforeAppInsert(DCARowId,RBASId,ReqType,UserDR,LogHospID,JSONType,TRTimeRange)
	if ret'=0{
		Q ##class(DHCDoc.DHCDocCure.Util).EvalJson(ret,JSONType)
	}
	s DCAOrderDoseQty=..GetDCADoseAppQty(DCARowId,LogHospID)
	s CureData=$g(^DHCDocCure(DCARowId))
	s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
	s DCAStatus=$p($g(^DHCDocCure(DCARowId)),"^",3)
	s DCAOEORIDR=$p($g(^DHCDocCure(DCARowId)),"^",2)
	s AppointAllowExec=$p($g(^DHCDocCure(DCARowId)),"^",20)
	s RBCResSchData=$g(^DHCDocCureRBCResSchdule(RBASId))
	s DDCRSLocID=$p(RBCResSchData,"^",2)
	s DDCRSDate=$p(RBCResSchData,"^",4)
	s DDCRSTimeRangeDR=$p(RBCResSchData,"^",5)
	s StartTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",3)
	s EndTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",4)
	s EndAppointTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",7)
	
	;判断排班的预约情况
	s LastDCAAChildSub="",LastDCAAChildSubF=""
	for  s LastDCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",LastDCAAChildSub),-1) q:(LastDCAAChildSub="")!(LastDCAAChildSubF'="")  d
	.s LastDCAARBASId=$p(^DHCDocCure(DCARowId,"Arrive",LastDCAAChildSub),"^",1)
	.s LastDCAARBASDate=$p($g(^DHCDocCureRBCResSchdule(LastDCAARBASId)),"^",4)
	.Q:LastDCAARBASDate'=DDCRSDate
	.s LastDCAAChildSubF=LastDCAAChildSub
	s LastOEOREDRStartTime=""
	if (LastDCAAChildSubF'=""){
		s LastDCAAOEOREDR=$p(^DHCDocCure(DCARowId,"Arrive",LastDCAAChildSubF),"^",2)
		if (LastDCAAOEOREDR'="") s LastOEOREDRStartTime=$p(^OEORD(+LastDCAAOEOREDR,"I",$p(LastDCAAOEOREDR,"||",2),"X",$p(LastDCAAOEOREDR,"||",3)),"^",2)
	    if (LastOEOREDRStartTime'="") s StartTime=LastOEOREDRStartTime+10
	}
	
    s ReportStateId=""
    s LocNeedReport=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig(DCARowId,"CureLocNeedReport",DDCRSLocID)
    if LocNeedReport="1" {
        s ReportStateId=##class(DHCDoc.DHCDocCure.CureCall).GetCurePerStateId("Report")
    }else {
        s ReportStateId=##class(DHCDoc.DHCDocCure.CureCall).GetCurePerStateId("Wait")
    }
    if ReportStateId=""{
        Q ##class(DHCDoc.DHCDocCure.Util).EvalJson("-10034",JSONType)
    }
    
    Lock +^DHCDocCureRBCResSchduleLOCK(RBASId):10
    s DDCRSSeqNoStr=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",21)
    s DDCRSTimeRangeFlag = $p($g(^DHCDocCureRBCResSchdule(RBASId,"TR")), "^", 1)
    if (DDCRSTimeRangeFlag'="Y")&&(LocNeedReport="1"){
	    ;非分时段的，走报到流程的，仍不产生序号
	    s AppSeqNo=""
	}else{
	    s AppSeqNo = ##class(DHCDoc.DHCDocCure.ScheduleTR).GetSeqNo(RBASId,TRTimeRange)
	    if (AppSeqNo = 0) {
	        Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
	        // 取号失败
	        Q ##class(DHCDoc.DHCDocCure.Util).EvalJson("-10035",JSONType)
	    } else {
	        s DDCRSSeqNoStr=$s(DDCRSSeqNoStr="" : AppSeqNo, 1 : DDCRSSeqNoStr_","_AppSeqNo)
	    }
	}
	Tstart
	s oeori = +DCAOEORIDR
	s suboeori = $p(DCAOEORIDR,"||",2)
	s (OEORERowId,OEOREChild)=""	
	if AppointAllowExec="Y"{
		s OrderExecChild=0
		for{
			s OrderExecChild=$o(^OEORD(oeori,"I",suboeori,"X",OrderExecChild)) 
			Q:(OrderExecChild="")!(OEOREChild'="")
			s findOrderExecChild=""
			s execdata=$g(^OEORD(oeori,"I",suboeori,"X",OrderExecChild))
			s OEOREStatus=$p(execdata,"^",16)
			s OEOREStatusCode=""
			s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1)
			continue:(OEOREStatusCode'="")&&(OEOREStatusCode'="C")	
			s DCAAChildSub=0
			for{
				s DCAAChildSub=$o(^DHCDocCure(0,"OEORE",DCAOEORIDR_"||"_OrderExecChild,DCARowId,DCAAChildSub))
				Q:(DCAAChildSub="")!(findOrderExecChild'="")
				s DCAAStatus=$p(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub),"^",7)
				continue:DCAAStatus="C"
				s findOrderExecChild=OrderExecChild
			}
			continue:findOrderExecChild'=""
			s OEOREChild=OrderExecChild
			s OEORERowId=DCAOEORIDR_"||"_OEOREChild
			s DCAOrderDoseQty=##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID(OEORERowId)
		}
	}else{
		s hdate = ##class(websys.Conversions).DateHtmlToLogical(DDCRSDate) //$zdh(exDate,1)
		s InsSeqNo=1
		s htime=0 f  s htime= $o(^OEORDi(0,"Date",oeori,hdate,htime)) q:htime=""  d
		.s child = 0 f  s child=$o(^OEORDi(0,"Date",oeori,hdate,htime,suboeori,child))  q:child=""  d
		..s InsSeqNo=InsSeqNo+1
		;s err=$$InsOEORE^DHCOEOrdExec(DCAOEORIDR,DDCRSDate,StartTime,DCAOrderDoseQty,"",DCAOrderDoseQty,InsSeqNo,"","","")
		s InsRtn=##class(DHCDoc.Order.Exec).InsOEORE(DCAOEORIDR,DDCRSDate,StartTime,DCAOrderDoseQty,DCAOrderDoseQty,InsSeqNo,"","","")
		s err=$p(InsRtn,"^",1)
		s OEORERowId=$p(InsRtn,"^",2)
		if err{ 
			Trollback
			s rtn="104"
			Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
			Q ##class(DHCDoc.DHCDocCure.Util).EvalJson(rtn,JSONType)
		}else{
			d ..CreatLinkOrdExec(DCAOEORIDR, DDCRSDate, StartTime, InsSeqNo,OEORERowId)
		}
	}
	if OEORERowId=""{ 
		Trollback
		s rtn="105"
		Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
		Q ##class(DHCDoc.DHCDocCure.Util).EvalJson(rtn,JSONType)
	}
	s finDCAA=0
	s DCAAChildSub=""
	for{
		s DCAAChildSub=$O(^DHCDocCure(0,"OEORE",OEORERowId,DCARowId,DCAAChildSub))
		Q:DCAAChildSub=""
		s DCAAStatus=$p(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub),"^",7)
		continue:DCAAStatus'="I"
		s finDCAA=1
	}
	if finDCAA=1 
	{
		Trollback
		s rtn="107"
		Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
		Q ##class(DHCDoc.DHCDocCure.Util).EvalJson(rtn,JSONType)
	}
	k PLIST
	s PLIST(0)=DCARowId
	s PLIST(3)=RBASId
	s PLIST(4)=OEORERowId
	s PLIST(5)=UserDR
	s PLIST(6)=+$H
	s PLIST(7)=$P($H,",",2)
	s PLIST(8)="M"
	s PLIST(9)="I"
	s PLIST(15)=AppSeqNo
	s PLIST(16)=DCAOrderDoseQty
	s PLIST(17)=ReportStateId
	&sql(insert into SQLUser.DHC_DocCureAppArrive values :PLIST())
	if SQLCODE
	{
		Trollback
		s rtn=SQLCODE
		Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
		Q ##class(DHCDoc.DHCDocCure.Util).EvalJson(rtn,JSONType)
	}
	s AppArriveID=$p(%ROWID,$c(1))
	&sql(Update SQLUser.DHC_DocCureRBCResSchdule set DDCRS_SeqNoStr=:DDCRSSeqNoStr where DDCRS_RowID=:RBASId)
	if SQLCODE
	{
		Trollback
		s rtn=SQLCODE
		Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
		Q ##class(DHCDoc.DHCDocCure.Util).EvalJson(rtn,JSONType)
	}
	d ##class(DHCDoc.DHCDocCure.Triage).UpdateTriageStatus(DCARowId,UserDR)
	if DCAStatus="F"{
		d ##class(DHCDoc.DHCDocCure.Apply).FinishCureApply(DCARowId,UserDR,"CF")
	}
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	s IsNeedBillFlag=0
	s BillAfterUpdate=##Class(web.DHCDocConfig).GetConfigNode("CheckIPDeposit")
	if (PAADMType="I") {
		i BillAfterUpdate="1" s IsNeedBillFlag=1
	}else{
		if (PAADMType="E"){
			s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
			s AdmDepDr=$p($g(^PAADM(Adm)),"^",4)
			s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
			s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmDepHospId)
			if " 1 2 "[(" "_PatCurStat_" "){
				if (BillAfterUpdate="1"){
					s IsNeedBillFlag=1
			    }elseif(StayPayMode="1"){
				    //DHC_SOPFConfig OPFC_StayChargeMode 0 现金模式 1押金模式
				    s IsNeedBillFlag=1
				}
			}
		}
	}
	i IsNeedBillFlag=1 s billrtn=##Class(web.UDHCJFBILL).BILLN(Adm,UserDR,"")
	Tcommit
	Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
	
	s Para=DCARowId_"^^"_$g(AppArriveID)_"^"_"CUREBK"_"^"_UserDR
	Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(Para)
	s rtn=0
	Q ##class(DHCDoc.DHCDocCure.Util).EvalJson(rtn,JSONType)
}

ClassMethod CreatLinkOrdExec(DCAOEORIDR, Date, Time, InsSeqNo, MainOEORERowId)
{
	Q 0
	n (DCAOEORIDR,Date,Time,InsSeqNo,MainOEORERowId,%session)
	s ChildInsRtn=""
	s OrderRowid=+DCAOEORIDR
	s itemsub=""
	for{
		s itemsub=$o(^OEORDi(0,"OEORI",OrderRowid,DCAOEORIDR,itemsub))
		q:itemsub=""
		s ChildOEORIDR=OrderRowid_"||"_itemsub
		s ChildDCARowId=$O(^DHCDocCure(0,"OEORI",ChildOEORIDR,""))
		continue:ChildDCARowId'=""
		s ind=$I(ExecList(Date, Time))
		s ExecList(Date,Time,ind)={}
		d ##class(DHCDoc.Order.Exec).GetOrdExecQtyToList(ChildOEORIDR,.ExecList)
		s ExecObj=ExecList(Date,Time,ind)
		b ;生成执行记录
		s ChildInsRtn=##class(DHCDoc.Order.Exec).InsOEORE(ChildOEORIDR,Date,Time,ExecObj.ExecQty,ExecObj.AdminQty,InsSeqNo,MainOEORERowId,"","")
	}
	Q ChildInsRtn
}

/// 取对应排班已被预约的数量
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetRBCResSchduleAppedNum("818")
ClassMethod GetRBCResSchduleAppedNum(RBASId As %String, JSONType As %String = "")
{
	n (RBASId,JSONType)
	q:RBASId="" 0
	s AppedNum=..GetRBResAppCount(RBASId)
	q ##class(DHCDoc.DHCDocCure.Util).EvalJson(AppedNum,JSONType)
}

/// 预约到达
ClassMethod AppArrive(DCAARowId As %String, UserDR As %String, LogonLocDr As %String, DateExecuted As %String = "", TimeExecuted As %String = "")
{
	n (DCAARowId,UserDR,LogonLocDr,DateExecuted,TimeExecuted,%session)
	Q:(DCAARowId="")||(UserDR="") 100
	Ts
	;预约到达需要执行对应执行记录
	s Data=$g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2)))
	s OEOREDR=$p(Data,"^",2)
	s NewStatusCode="F"
	s myrtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,NewStatusCode,UserDR,DateExecuted,TimeExecuted,"","","",LogonLocDr)
	if myrtn
    {
	    Trollback
		Quit myrtn
	}
	s StatusRowId=$O(^OEC("OSTAT",0,"Code","E",0))  
	&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=:StatusRowId Where OEORE_RowId=:OEOREDR)
    if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	}
	s PerStateId=##class(DHCDoc.DHCDocCure.CureCall).GetCurePerStateId("Complete")
	if PerStateId=""{
		Trollback
		Quit 101
	}
	k PLIST
	s PLIST(9)="A"
	s PLIST(10)=UserDR
	s PLIST(11)=+$H
	s PLIST(12)=$P($H,",",2)
	s PLIST(17)=PerStateId
	&sql(update SQLUser.DHC_DocCureAppArrive values :PLIST() where DCAA_RowId=:DCAARowId)
	if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	}
	
	
	s ret=##class(DHCDoc.DHCDocCure.CureCall).UpdateTreatCallStatus(DCAARowId,"","")
	if ret
    {
	    Trollback
		Quit ret
	}
	Tcommit
	Q 0
}

/// 取消预约
/// w ##class(DHCDoc.DHCDocCure.Appointment).AppCancelBatch("145||1",5)
ClassMethod AppCancelBatch(DCAARowIdStr As %String, UserDR As %String = "", ExpStr As %String = "") As %String
{
	n (DCAARowIdStr,UserDR,ExpStr,%session)
	s ^tmplog("AppCancelBatch")=DCAARowIdStr
	s HOSPID=$p(ExpStr,"^",1)
	s langid=$p(ExpStr,"^",2)
	s cspName=$p(ExpStr,"^",3)
	s:langid="" langid=..%LanguageID()
	s:cspName="" cspName="doccure.cureapplist.hui.csp"
	s retstr=""
	s DCAARowIdStrLen=$l(DCAARowIdStr,"^")
	for count=1:1:DCAARowIdStrLen{
		s DCAARowId=$p(DCAARowIdStr,"^",count)
		s ret=..AppCancelHUI(DCAARowId,UserDR)
		s msg=""
		if ret="0" s msg=""
		else  if ret="100" s msg=..%Translate(cspName,"入参为空",langid)
		else  if ret="101" s msg=..%Translate(cspName,"预约状态不是已预约的记录不能取消",langid)
		else  s msg=ret	
		if msg'=""{	
			s Data=..GetCureAppointment(DCAARowId,ExpStr)
			s ASData=$p(Data,$c(1),1)
			s AppData=$p(Data,$c(1),2)
			s DDCRSDate=$p(ASData,"^",5)   //预约日期

			s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(+DCAARowId,"",ExpStr)
			s ArcimDesc="",PatientNo="",PatientName=""
			if (CureAppStr'=""){
				s CureAppInfo=$p(CureAppStr,$c(1),2)
				s ArcimDesc=$p(CureAppInfo,"^")
				s PatientInfo=$p(CureAppStr,$c(1),1)
				s PatientNo=$p(PatientInfo,"^",2)
				s PatientName=$p(PatientInfo,"^",3)
			}
			s msg=PatientName_" "_..%Translate(cspName,"预约日期",langid)_":"_DDCRSDate_" "_..%Translate(cspName,"取消预约失败",langid)_":"_msg
			
			if retstr="" s retstr=msg
			else  s retstr=retstr_";<br>"_msg
		}
	}
	q retstr
}

/// Decs:  取消预约方法
/// Input: DCAARowId:治疗预约ID UserDR:操作用户 
/// 	   SpecFlag:是否调用停执行记录((appcom.OEOrdExec).UpdateStatus方法中调用传入此参数,防止相互调用陷入死循环)
/// Output:w ##class(DHCDoc.DHCDocCure.Appointment).AppCancelHUI("7||2",20518)
ClassMethod AppCancelHUI(DCAARowId As %String, UserDR As %String = "", SpecFlag As %String = "") As %String
{
	n (DCAARowId,UserDR,SpecFlag)
	s ^TMP("AppCancel")=DCAARowId_"^"_UserDR
	Q:(DCAARowId="")||(UserDR="") 100
	s DCAOEORIDR=$p($g(^DHCDocCure(+DCAARowId)),"^",2)
	s AppointAllowExec=$p($g(^DHCDocCure(+DCAARowId)),"^",20)
	;取消预约需要撤销执行对应执行记录
	s Data=$g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2)))
	s OEOREDR=$p(Data,"^",2)
	s DCAAStatus=$p(Data,"^",7)
	s DCAARBASDR=$p(Data,"^",1)
	s DCAAppSeqNo=$p(Data,"^",13)
	if DCAAStatus'="I"
    {
		Quit 101
	}
	;if (OEOREDR="") Q 100
	
	Tstart
	k PLIST
	s PLIST(9)="C"
	s PLIST(10)=UserDR
	s PLIST(11)=+$H
	s PLIST(12)=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureAppArrive values :PLIST() where DCAA_RowId=:DCAARowId)
	if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	}
	s ResRet=##class(DHCDoc.DHCDocCure.ScheduleTR).RestoreSeqNo(DCAARBASDR,DCAAppSeqNo)
	if ResRet'=0 {
		Trollback
		Quit "-1001"
	}
	;若启用预约可直接执行，则无需更新执行记录状态，因为下次预约时执行记录可能还会关联
	;若未启用，则需置停止执行，下次预约会产生新的执行记录
	if AppointAllowExec'="Y"{
		//取消预约时，先改变预约记录状态，否则停止执行记录时预约记录还是预约状态而失败
		if ((OEOREDR'="")&&(SpecFlag="")){
			s OEOREStatusRowId=$P($G(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),"X",$P(OEOREDR,"||",3))),"^",16)
			if OEOREStatusRowId'="" s OEOREStatusCode=$P($G(^OEC("STAT",OEOREStatusRowId)),"^",1)
			s BillStatus=$P($G(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),"X",$P(OEOREDR,"||",3))),"^",6)
			if (($g(OEOREStatusCode)="F")||(BillStatus="P"))
			{
				Trollback
				Q 102
			}
			s rtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,"D",UserDR,+$H,"","")
			if rtn'=0{
				Trollback
				Quit rtn
			}
		}
	}
	Tcommit
	
	s Para=+DCAARowId_"^^"_$g(DCAARowId)_"^"_"CURECBK"_"^"_UserDR
	Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(Para)
	
	Q 0
}

/// Desc:旧版取消预约方法
ClassMethod AppCancel(DCAARowId As %String, UserDR As %String = "") As %String
{
	n (DCAARowId,UserDR)
	s ^TMP("AppCancel")=DCAARowId_"^"_UserDR
	Q:(DCAARowId="")||(UserDR="") 100
	;取消预约需要撤销执行对应执行记录
	Set Data=$g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2)))
	s OEOREDR=$p(Data,"^",2)
	s DCAAStatus=$p(Data,"^",7)
	if DCAAStatus'="I"
    {
		Quit 101
	}
	Tstart
	k PLIST
	s PLIST(9)="C"
	s PLIST(10)=UserDR
	s PLIST(11)=+$H
	s PLIST(12)=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureAppArrive values :PLIST() where DCAA_RowId=:DCAARowId)
	if SQLCODE
    {
	    Trollback
		Quit SQLCODE
	}
	
	;lxz 如果医嘱不为空的时候在按照医嘱的流程进行处理
	if (OEOREDR'=""){
		s OEOREStatusRowId=$P($G(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),"X",$P(OEOREDR,"||",3))),"^",16)
		if OEOREStatusRowId'="" s OEOREStatusCode=$P($G(^OEC("STAT",OEOREStatusRowId)),"^",1)
		s BillStatus=$P($G(^OEORD(+OEOREDR,"I",$P(OEOREDR,"||",2),"X",$P(OEOREDR,"||",3))),"^",6)
		if (($g(OEOREStatusCode)="F")||(BillStatus="P"))
		{
			Q 102
		}
		
		s StatusRowId=$O(^OEC("OSTAT",0,"Code","U",0))  
		&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=:StatusRowId Where OEORE_RowId=:OEOREDR)
	    if SQLCODE
	    {
		    Trollback
			Quit SQLCODE
		} 
	}
	
	Tcommit
	Q 0
}

/// 取单个治疗申请单预约信息
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(867)
ClassMethod GetApplyAppInfo(DCARowId) As %String
{
	n (DCARowId,%session)
	Quit:DCARowId="" ""
	s AppedSum=0,ArrivedSum=0,ExecSum=0
	s DCAAChildSub=0 
	for{
		s DCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub))
		q:DCAAChildSub=""
		s Data=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub))
		continue:Data=""
		s DCAAStatus=$p(Data,"^",7)   //预约状态
		continue:(DCAAStatus'="I")&&(DCAAStatus'="A")
		s DCAAQty=+$p(Data,"^",14)
		if DCAAQty=0 s DCAAQty=1
	    s AppedSum=AppedSum+DCAAQty
	    i DCAAStatus="A" s ArrivedSum=ArrivedSum+DCAAQty
	}
	s ApplyAppointExec=$p($g(^DHCDocCure(DCARowId)),"^",20) 
	if ApplyAppointExec="Y"{
		s OrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		s OrderPar=+OrderId
		s OrderChild=$p(OrderId,"||",2)
		s OrderExecSub=0
		for{
			s OrderExecSub=$o(^OEORD(OrderPar,"I",OrderChild,"X",OrderExecSub))
			Q:OrderExecSub=""
			s OEORERowID=OrderId_"||"_OrderExecSub
			s execdata=$g(^OEORD(OrderPar,"I",OrderChild,"X",OrderExecSub))
			s OEOREStatus=$p(execdata,"^",16)
			s OEOREStatusCode=""
			s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1)
			continue:(OEOREStatusCode'="F")
			s AppointFlag=##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus(OEORERowID)
			continue:AppointFlag="1"
			set OEOREQty=##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID(OEORERowID)
			s ExecSum=ExecSum+OEOREQty
		}
	}
	q AppedSum_"^"_ArrivedSum_"^"_ExecSum
}

/// 取治疗申请单单条预约信息
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment("1||4")
ClassMethod GetCureAppointment(DCAARowId, ExpStr As %String = "") As %String
{
	n (DCAARowId,ExpStr,%session)
	Quit:DCAARowId="" ""
	s HospID=$p(ExpStr,"^",1)
	s langid=$p(ExpStr,"^",2)
	s cspName=$p(ExpStr,"^",3)
	s:cspName="" cspName="doccure.emr.cureapplist.hui.csp"
	if ($d(%session)){
		s langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s Data=$g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2)))
	s DCAARBASDR=$p(Data,"^",1)  //资源排班ID
	s ASData=##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResApptSchuldeInfo(DCAARBASDR,langid)
	s OEOREDR=$p(Data,"^",2)  //执行表关联
	s ReqUserDR=$p(Data,"^",3)  //预约操作人
	s ReqUser=""
	s:ReqUserDR'="" ReqUser=$p($g(^SSU("SSUSR",ReqUserDR)),"^",2)
	s ReqUser =##class(User.SSUser).GetTranByDesc("SSUSRName",ReqUser,langid)
	s ReqDate=$p(Data,"^",4)  //预约操作日期
	;s:ReqDate'="" ReqDate=$zd(ReqDate,1)
	s ReqDate=##class(websys.Conversions).DateLogicalToHtml(ReqDate)
	s ReqTime=$p(Data,"^",5)  //预约操作时间
	s:ReqTime'="" ReqTime=$zt(ReqTime,1)
	s ReqType=$p(Data,"^",6)  //预约方式
	s ReqType=$case(ReqType,"A":"自动","M":"手动",:"")
	s DCAAStatus=$p(Data,"^",7)  //预约状态
	s DCAAStatus=$case(DCAAStatus,
	"I":##class(websys.Translation).Get(cspName,"已预约"),
	"A":##class(websys.Translation).Get(cspName,"已治疗"),
	"C":##class(websys.Translation).Get(cspName,"取消预约"),
	:"")
	s LastUpdateUser=""
	s LastUpdateUserDR=$p(Data,"^",8)  //更新人
	s:LastUpdateUserDR'="" LastUpdateUser=$p($g(^SSU("SSUSR",LastUpdateUserDR)),"^",2)
	s LastUpdateUser =##class(User.SSUser).GetTranByDesc("SSUSRName",LastUpdateUser,langid)
	s LastUpdateDate=$p(Data,"^",9)  //更新日期
	s LastUpdateDate=##class(websys.Conversions).DateLogicalToHtml(LastUpdateDate)
	s LastUpdateTime=$p(Data,"^",10)  //更新时间
	s:LastUpdateTime'="" LastUpdateTime=$zt(LastUpdateTime,2)
	s CurDate=$zd(+$h,3)
	s CurTime=$zt($p($h,",",2),2)
	s CurDateTime=CurDate_" "_CurTime
	s CallStatus=$p(Data,"^",12)  //预约方式
	s CallStatus="",CallStatusCode=""
	s CallStateDr=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",15)
	if CallStateDr'="" {
		s CallStatusCode=$p(^DHCDocCurePS(CallStateDr),"^",1)
		s CallStatus=$p(^DHCDocCurePS(CallStateDr),"^",4)
		s CallStatus =##class(User.DHCDocCurePerState).GetTranByDesc("DDCPSShowName",CallStatus,langid)
		if (CallStatus=""){
			s CallStatus=$p(^DHCDocCurePS(CallStateDr),"^",2)
			s CallStatus =##class(User.DHCDocCurePerState).GetTranByDesc("DDCPSDesc",CallStatus,langid)
		}
	}
	s DCAAppSeqNo=$p(Data,"^",13)  //排队序号
	s DCAAppQty=$p(Data,"^",14)
	s AppData=DCAARBASDR_"^"_OEOREDR_"^"_ReqUserDR_"^"_$g(ReqUser)_"^"_ReqDate_"^"_ReqTime_"^"_ReqType_"^"_DCAAStatus_"^"_LastUpdateUserDR_"^"_$g(LastUpdateUser)_"^"_LastUpdateDate_"^"_LastUpdateTime_"^"_CurDateTime_"^"_CallStatus
	s AppData=AppData_"^"_DCAAppSeqNo_"^"_DCAAppQty_"^"_CallStatusCode
	q ASData_$c(1)_AppData
}

/// 查询预约记录
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Appointment","FindAppointmentList","24","")
Query FindAppointmentList(DCARowId As %String, QueryState As %String = "", ResSchduleId As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "Rowid:%String,LocDesc:%String,ResourceDesc:%String,DDCRSDate:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String,PatOther:%String,CureApplyNo:%String,DCASeqNo:%String,DCAAQty:%String,PatientNo:%String,PatientName:%String,ArcimDesc:%String,DCAARBASDR:%String,OrderQty:%String,Job:%String")
{
}

ClassMethod FindAppointmentListExecute(ByRef qHandle As %Binary, DCARowId As %String, QueryState As %String = "", ResSchduleId As %String = "", ExpStr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^TMP("FindAppointmentList")=DCARowId_","_QueryState
	if (DCARowId="")&&(ResSchduleId=""){
		Set qHandle=$lb(0,repid,0) Quit $$$OK
	}
	
	s Job=$J
	s UserId=$p(ExpStr,"^",1)
	s HospId=$p(ExpStr,"^",2)
	s langid=$p(ExpStr,"^",3)
	s cspName=$p(ExpStr,"^",4)
	s gExpStr=$p(ExpStr,"^",2,4)
	s:UserId="" UserId=%session.Get("LOGON.USERID")	
	s:langid="" UserId=%session.Get("LOGON.LANGID")	
	s:cspName="" cspName="doccure.cureapplist.hui.csp"
	k ^TMPFindAppointmentList("DHCDOCCURE",UserId)
	if DCARowId'=""{
		s DCAAChildSub=0 
		for{
			s DCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)) q:DCAAChildSub=""
			d ListFindAppointment
		}
	}else{
		s DCARowId=0
		for{
			s DCARowId=$o(^DHCDocCure(0,"RBAS",ResSchduleId,DCARowId))
			Q:DCARowId=""
			s DCAAChildSub=0 
			for{
				s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",ResSchduleId,DCARowId,DCAAChildSub))
				Q:DCAAChildSub=""
				d ListFindAppointment
			}
		}
	}
	s Sub1=0
	for{
		s Sub1=$O(ListFindAppointment(Sub1)) Q:Sub1=""
		s Sub2=0
		for{
			s Sub2=$O(ListFindAppointment(Sub1,Sub2)) Q:Sub2=""
			s DCAARowId=Sub2
			d OutputRowApplyAppointment
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ListFindAppointment
	s DCAARowId=DCARowId_"||"_DCAAChildSub
	s Statu=$P(^DHCDocCure(+DCARowId,"Arrive",DCAAChildSub),"^",7)
	if ((QueryState="")||((QueryState'="")&&(QueryState[Statu))){
		s Sub=$Case(Statu,"I":1,"A":2,"C":3,:4)  //排序查看预约记录
		s ListFindAppointment(Sub,DCAARowId)=1
	}
	Q
OutputRowApplyAppointment
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+DCAARowId)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientID=$p(PatientInfo,"^",1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s AdmRowID=$p(CureAppInfo,"^",16)
	s OrderQty=$p(CureAppInfo,"^",3)
	s BillingUOM=$p(CureAppInfo,"^",4)
	if OrderQty'=""{
		s OrderQty=OrderQty_""_BillingUOM
	}
	s CureApplyNo=$p(CureAppInfo,"^",31) 
	s Adm=$p($g(^DHCDocCure(+DCAARowId)),"^",1)
	s AdmType="",AdmDep=""
	if Adm'=""{
		s AdmType=$p($g(^PAADM(Adm)),"^",2)
		s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
		s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
		s AdmDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmDep,langid) 
	}
	s Data=..GetCureAppointment(DCAARowId,gExpStr)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	s CTCareProv=$p(ASData,"^",4)  //预约资源
	s DDCRSDate=$p(ASData,"^",5)   //预约日期
	s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	s StartTime=$p(ASData,"^",8)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	;------预约信息--------
	s DCAARBASDR=$p(AppData,"^",1)
	s OEOREDR=$p(AppData,"^",2)
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	s CallStatus=$p(AppData,"^",14)
	s DCASeqNo=$p(AppData,"^",15)
	s DCAAQty=$p(AppData,"^",16)
	s CallStatusCode=$p(AppData,"^",17)
	s AdmTypeDesc=##class(DHCDoc.Common.Translate).GetTransAdmType(Adm,cspName,langid)
	s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel_" | "_AdmType_"("_AdmDep_")"
	s Data=$lb(DCAARowId,DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate,PatOther,CureApplyNo,DCASeqNo,DCAAQty,PatientNo,PatientName,ArcimDesc,DCAARBASDR,OrderQty,Job)
 	
 	s ^TMPFindAppointmentList("DHCDOCCURE",UserId,Job,ind)=CureApplyNo_"^"_PatientNo_"^"_PatientName_"^"_ArcimDesc_"^"_OrderQty_"^"_DCAAQty_"^"_DCASeqNo_"^"_DCAAStatus
 	s ^TMPFindAppointmentList("DHCDOCCURE",UserId,Job,"num")=ind
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

ClassMethod FindAppointmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAppointmentListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAppointmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppointmentListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 治疗工作台工作列表
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Appointment","FindCurrentAppointmentList",182,1905,"05/12/2017","05/12/2017","","","")
Query FindCurrentAppointmentList(LocId As %String, UserId As %String, StartDate As %String, EndDate As %String, PatientID As %String = "", ServiceGroupId As %String = "", QueryStatus As %String = "", DHCDocApplyNo As %String = "") As %Query(ROWSPEC = "Rowid:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,LocDesc:%String,ResourceDesc:%String,DDCRSDate:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String,DHCDocApplyNoGet:%String")
{
}

ClassMethod FindCurrentAppointmentListExecute(ByRef qHandle As %Binary, LocId As %String, UserId As %String, StartDate As %String, EndDate As %String, PatientID As %String = "", ServiceGroupId As %String = "", QueryStatus As %String = "", DHCDocApplyNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^TMP("FindCurrentAppointmentList")=LocId_","_UserId_","_StartDate_","_EndDate_","_PatientID_","_ServiceGroupId_","_QueryStatus
	if (LocId="")||(UserId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	if StartDate="" s StartDate=+$h
	else  s StartDate=$zdh(StartDate,1)
	if EndDate="" s EndDate=+$h
	else  s EndDate=$zdh(EndDate,1)
	
	;lxz 如果治疗科室高压氧排班室设备则无法显示 显示可使将要做的全部项目
	s FindResRowId=""
	s DoctorId=##class(web.SSUser).GetDefaultCareProvider(UserId)
	if DoctorId'=""  d
	.;s FindResRowId=$o(^RB("RES",0,"CTPCP",DoctorId,LocId,""))
	
	
	;if DoctorId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;if ResRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;lxz 如果申请单不为空按照申请单进行查询
	if DHCDocApplyNo'=""  d
	.s DCARowId=0 
	.for  s DCARowId=$o(^DHCDocCure(0,"DCANO",DHCDocApplyNo,DCARowId)) q:DCARowId=""  d
	..s OrdReLocId=$P(^DHCDocCure(DCARowId),"^",13)
	..Q:(OrdReLocId'=LocId)&&(OrdReLocId'="") ;lxz 如果接收科室不为空按照接收科室进行查询
	..s DCAAChildSub=0
	..f  s DCAAChildSub=$O(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)) Q:DCAAChildSub=""  d
	...s DCAARowId=DCARowId_"||"_DCAAChildSub
	...s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
	...q:(QueryStatus'="")&&(DCAAStatus'=QueryStatus)
	...d OutputRowCurrentAppointmentList
	else  d
	.for ASDate=StartDate:1:EndDate  d
	..s ResRowId=0
	..f  s ResRowId=$O(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId)) Q:ResRowId=""  d
	...Q:(FindResRowId'="")&&(FindResRowId'=ResRowId)
	...s RSRowId="" for  s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId,ASDate,RSRowId)) q:RSRowId=""  d
	....s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
	....Q:DDCRSStatus'="N"
	....s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",8)
	....Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
	....s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId))  Q:DCARowId=""  d
	.....s OrdReLocId=$P(^DHCDocCure(DCARowId),"^",13)
	.....Q:(OrdReLocId'="")&&(OrdReLocId'=LocId) ;lxz 如果接收科室不为空按照接收科室进行查询
	.....s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
	.....s:Adm'="" PapmiDr=$p($g(^PAADM(Adm)),"^",1),AdmType=$p($g(^PAADM(Adm)),"^",2)
	.....s:Adm'="" AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	.....s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	.....Q:(PatientID'="")&&(PatientID'=PapmiDr)
	.....s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
	......s DCAARowId=DCARowId_"||"_DCAAChildSub
	......s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
	......q:(QueryStatus'="")&&(DCAAStatus'=QueryStatus)
	......d OutputRowCurrentAppointmentList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCurrentAppointmentList
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s DHCDocApplyNoGet=$p(CureAppInfo,"^",20) ;预约单号
	s Data=..GetCureAppointment(DCAARowId)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	s CTCareProv=$p(ASData,"^",4)  //预约资源
	s DDCRSDate=$p(ASData,"^",5)   //预约日期
	s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	s StartTime=$p(ASData,"^",8)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	;------预约信息--------
	s OEOREDR=$p(AppData,"^",2)
	;门诊未收费的医嘱不能做治疗
	s:OEOREDR'="" billed=$p(^OEORD(+OEOREDR,"I",$p(OEOREDR,"||",2),3),"^",5)
	q:(OEOREDR'="")&&(AdmType'="I")&&($G(billed)'="P")
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	set Data=$lb(DCAARowId,$g(PatientNo),$g(PatientName),$g(PatientSex),$g(PatientAge),$g(PatientTel),$g(AdmType),$g(AdmDep),$g(ArcimDesc),DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate,DHCDocApplyNoGet)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCurrentAppointmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurrentAppointmentListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCurrentAppointmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurrentAppointmentListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRBResAppCount(ARBASDR As %String)
{
	s Appcount=0
	Q:ARBASDR="" Appcount
	s DDCRSLocDR=$p($g(^DHCDocCureRBCResSchdule(ARBASDR)),"^",2)  //排班科室ID
	s DDCRSLocHosp=$p(^CTLOC(DDCRSLocDR),"^",22)
	s CureAppVersion=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureAppVersion",DDCRSLocHosp)	
	if CureAppVersion="V1"{
		s DCAARowId=""
		f  s DCAARowId=$o(^DHCDocCure(0,"RBAS",ARBASDR,DCAARowId)) q:DCAARowId=""  d
		.s DCAAChildSub=""
		.f  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",ARBASDR,DCAARowId,DCAAChildSub)) q:DCAAChildSub=""  d
		..s DCAAStatus=$p(^DHCDocCure(DCAARowId,"Arrive",DCAAChildSub),"^",7)
		..Q:DCAAStatus="C"
		..s Appcount=Appcount+1
	}else{
		s Appcount=##class(DHCDoc.DHCDocCure.AppointmentV2).GetRBResAppCount(ARBASDR)	
	}
	q Appcount
}

/// w ##class(DHCDoc.DHCDocCure.Appointment).GetAllCureAppointment(184)
ClassMethod GetAllCureAppointment(DCARowId, DCAARowIdStr As %String = "")
{
	n (DCARowId,DCAARowIdStr)
	Quit:DCARowId="" ""
	s mylist="",mystr=""
	s count=0
	if DCAARowIdStr s DCAARowIdStr="^"_DCAARowIdStr_"^"
	s DCAAChild=0
	for  s DCAAChild=$o(^DHCDocCure(+DCARowId,"Arrive",DCAAChild)) q:DCAAChild=""  d
	.s DCAARowId="^"_DCARowId_"||"_DCAAChild_"^"
	.Q:(DCAARowIdStr'="")&&(DCAARowIdStr'[DCAARowId)
	.Set Data=$g(^DHCDocCure(+DCARowId,"Arrive",DCAAChild))	
	.s DCAAStatus=$p(Data,"^",7)  //预约状态
	.q:DCAAStatus="C"
	.s DCAASeqNo=$p(Data,"^",13)  //预约状态
	.s DCAARBASDR=$p(Data,"^",1)  //资源排班ID
	.q:'$d(^DHCDocCureRBCResSchdule(DCAARBASDR))
	.s DocCureASData=$g(^DHCDocCureRBCResSchdule(DCAARBASDR))
	.s ASDate=$p(DocCureASData,"^",4)  //出诊日期
	.s DDCRSTimeRangeDR=$p(DocCureASData,"^",5)  //排程出诊时段
	.s ASStartTime=$p(DocCureASData,"^",6)  //开始时间
	.s ASEndTime=$p(DocCureASData,"^",7)  //结束时间
	.s DDCRSLocDR=$p(DocCureASData,"^",2)  //排班科室ID
	.s DDCRSResSourceDR=$p(DocCureASData,"^",3)  //排班资源ID
	.s DDCRSLoc="",CTCareProv=""
	.i DDCRSLocDR'=""  d
	..s DDCRSLoc=$P($G(^CTLOC(DDCRSLocDR)),"^",2)
	..i $P(DDCRSLoc,"-",2)'="" s DDCRSLoc=$P(DDCRSLoc,"-",2)
	.i DDCRSResSourceDR'=""  d
	..s CTCareProvDr=$P($G(^RB("RES",DDCRSResSourceDR)),"^",2)
	..i CTCareProvDr'=""  d
	...s CTCareProv=$p($g(^CTPCP(CTCareProvDr,1)),"^",2)
	...i $P(CTCareProv,"-",2)'="" s CTCareProv=$P(CTCareProv,"-",2)
	.s TimeRangeInfo=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTimeRangeInfo(DCAARBASDR,DCAASeqNo)
	.s PrintData=TimeRangeInfo_" "_DDCRSLoc_" "_CTCareProv
	.i mylist="" s mylist=PrintData
	.e  s mylist=mylist_"^"_PrintData
	.;以下为一行打印两条记录
	/*.s count=count+1
	.if count#2=1 d
	..s mystr=PrintData
	.e  d
	..s mystr=mystr_";  "_PrintData
	..i mylist="" s mylist=mystr
	..e  s mylist=mylist_"^"_mystr
	..s mystr=""
	i (count#2=1)&&(mystr'="") d
	.s mylist=mylist_"^"_mystr*/
	q mylist
}

ClassMethod GetCureAppPrtInfo(DCARowId, DCAARowIdStr As %String = "")
{
	s JsonObj={}
	if DCARowId'=""{
		s DCAInfo=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
		if DCAInfo'=""{
			s DCAAppInfo=..GetAllCureAppointment(DCARowId, DCAARowIdStr)
			s JsonObj.DCAInfo=DCAInfo
			s JsonObj.DCAAppInfo=DCAAppInfo
		}
	}
	Q JsonObj.%ToJSON()
}

ClassMethod OnTrigger(parref As %String, type As %String) As %Status
{
	s ^tmpnk("OnTrigger")=parref_"^"_type
	s $zt="AppArriveErr"
	s rtn=1
	s ParObj=##class(User.DHCDocCureAppArrive).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		if type="TAfterIns" {
			s Status=ParObj.DCAAStatus
			s UpUserID=ParObj.DCAAReqUserDRGetObjectId()
			s param=parref_"^"_Status_"^"_UpUserID
			s rtn=..InsertDHCStatus(param)
			i rtn=0 s rtn=1
			else  s rtn="ERROR"_rtn
		}
		if type="TAfterUpd" {
			s NewStatus=""
			i $g(%e(9)) {
				s OldStatus=$g(%e(9))
				s NewStatus=$g(%d(9))
			}else{
				s OldStatus=""
				s NewStatus=ParObj.DCAAStatus
			}
			i OldStatus'=NewStatus { 
				s Status=NewStatus ;ParObj.DCAAStatus
				s UpUserID=ParObj.DCAALastUpdateUserDRGetObjectId()
				s param=parref_"^"_Status_"^"_UpUserID
				s rtn=..InsertDHCStatus(param)
				i rtn=0 s rtn=1
				else  s rtn="ERROR"_rtn
			}
		}
	}

	Q rtn
AppArriveErr
	Q 0
}

ClassMethod InsertDHCStatus(insertinfo)
{
 s DCAASParRef=$p(insertinfo,"^",1)
 i DCAASParRef="" Q -1
 s DCAASStatus=$p(insertinfo,"^",2)
 s DCAASUpUserID=$p(insertinfo,"^",3)
 s DCAASDate=$P($H,",",1)
 s DCAASTime=$P($H,",",2)
 TStart
   &sql(insert into sqluser.DHC_DocCureAppArriveStatus(DCAAS_ParRef,DCAAS_Date,DCAAS_Time,DCAAS_Status,DCAAS_UpUserID) 
   values(:DCAASParRef,:DCAASDate,:DCAASTime,:DCAASStatus,:DCAASUpUserID))
   ;b ;DHCQueueStatus
   i SQLCODE=0 D
	.TCommit  
   e  d
	.Trollback
   q SQLCODE
}

/// 查询预约记录
/// Type="work" 根据预约记录ID查询待治疗的预约记录，治疗处理-治疗添加使用
/// Type=""     根据治疗申请ID查询待预约记录，治疗预约-治疗预约列表使用
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Appointment","FindAppointmentListHUI","2")
Query FindAppointmentListHUI(DCARowId As %String, QueryState As %String, Type As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "Rowid:%String,LocDesc:%String,ResourceDesc:%String,DDCRSDate:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String,ArcimDesc:%String,PatientNo:%String,PatientName:%String,DCASeqNo:%String,DCRRowId:%String,DCRUpdateStatus:%String,DCRTitle,DCRCreateUser,DCRCreateDate,DCRUpdateUser,DCRUpdateDate,DCRIsPicture,DCRIsAssess,DCAssRowId,OEOREDR")
{
}

ClassMethod FindAppointmentListHUIExecute(ByRef qHandle As %Binary, DCARowIdStr As %String, QueryState As %String, Type As %String = "", ExpStr As %String = "") As %Status
{
	s ind=1
	s ^TMP("FindAppointmentList")=DCARowIdStr_","_QueryState_","_Type_","_ExpStr
	if DCARowIdStr="" Quit $$$OK
	s HospID=$p(ExpStr,"^",1)
	s langid=$p(ExpStr,"^",2)
	s cspName=$p(ExpStr,"^",3)
	s:cspName="" cspName="doccure.emr.cureapplist.hui.csp"
	
	s DCARowIdLen=$l(DCARowIdStr,"!")
	if (Type=""){
		for mycount=1:1:DCARowIdLen{
			s DCARowId=$P(DCARowIdStr,"!",mycount)
			s DCAAChildSub=0 for  s DCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)) q:DCAAChildSub=""  d
			.s DCAARowId=DCARowId_"||"_DCAAChildSub
			.s DCAAStatus=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",7)
			.Q:(QueryState'="")&&(QueryState'[DCAAStatus)
			.d OutputRowApplyAppointmentHUI
		}
	}else{
		for mycount=1:1:DCARowIdLen{
			s DCAARowId=$P(DCARowIdStr,"!",mycount)
			continue:DCAARowId=""
			s DCARowId=+DCAARowId
			s DCAAChildSub=$p(DCARowId,"||",2)
			s DCAAStatus=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",7)
			continue:(QueryState'="")&&(QueryState'[DCAAStatus)
			d OutputRowApplyAppointmentHUI
		}	
	}
	Quit $$$OK
OutputRowApplyAppointmentHUI
	s Data=..GetCureAppointment(DCAARowId,ExpStr)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	s CTCareProv=$p(ASData,"^",4)  //预约资源
	s DDCRSDate=$p(ASData,"^",5)   //预约日期
	s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	s StartTime=$p(ASData,"^",8)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	;------预约信息--------
	s OEOREDR=$p(AppData,"^",2)
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s DCASeqNo=$p(AppData,"^",15)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(+DCAARowId,HospID,ExpStr)
	s ArcimDesc="",PatientNo="",PatientName=""
	if (CureAppStr'=""){
		s CureAppInfo=$p(CureAppStr,$c(1),2)
		s ArcimDesc=$p(CureAppInfo,"^")
		s PatientInfo=$p(CureAppStr,$c(1),1)
		s PatientNo=$p(PatientInfo,"^",2)
		s PatientName=$p(PatientInfo,"^",3)
	}
	s DCRRowId=##class(DHCDoc.DHCDocCure.Record).GetDCRRowID(DCAARowId,"")
	s (DCRContent,DCRCureDate,DCRResponse,DCREffect,DCRUpdateStatus)=""
	s (DCRTitle,DCRCreateUser,DCRCreateDate,DCRIsPicture,DCRUpdateUser,DCRUpdateDate)=""
	if DCRRowId'=""{
		s RecordStr=##class(DHCDoc.DHCDocCure.Record).GetCureRecord(DCRRowId)
		s DCRContent=$p(RecordStr,"^",4)
		s DCRCureDate=$p(RecordStr,"^",12)
		s DCRResponse=$p(RecordStr,"^",13)
		s DCREffect=$p(RecordStr,"^",14)
		s DCRUpdateStatus=$p(RecordStr,"^",17)
		s DCRTitle=$p(RecordStr,"^",3)
		s DCRCreateUser=$p(RecordStr,"^",6)
		s DCRCreateDate=$p(RecordStr,"^",7)
		s DCRUpdateUser=$p(RecordStr,"^",9)
		s DCRUpdateDate=$p(RecordStr,"^",10)
		s DCRIsPicture=$p(RecordStr,"^",11)
		;s DCRIsPicture=$case(DCRIsPicture,"Y":"查看图片","N":"",:"")
		s DCRIsPicture=$case(DCRIsPicture,
		"Y":##class(websys.Translation).Get(cspName,"查看图片"),
		:"")
	}
	s DCAssRowId="" ;##class(DHCDoc.DHCDocCure.Assessment).GetDCAssRowID(+DCAARowId,OEOREDR)
	s DCRIsAssess=##class(websys.Translation).Get(cspName,"否")
	if DCAssRowId'=""{
		s DCRIsAssess=##class(websys.Translation).Get(cspName,"是")
	}
	s Data=$lb(DCAARowId,DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate,ArcimDesc,PatientNo,PatientName,DCASeqNo,DCRRowId,DCRUpdateStatus,
	DCRTitle,DCRCreateUser,DCRCreateDate,DCRUpdateUser,DCRUpdateDate,DCRIsPicture,DCRIsAssess,DCAssRowId,OEOREDR)
 	s DCAAStatusCode=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",7)  //预约状态
	s DCAAStatusCode=$case(DCAAStatusCode,"I":"01","A":"02","C":"03",:"04")
 	s qHandle(DCAAStatusCode,DCAARowId,$I(ind))=Data
 	quit
}

ClassMethod FindAppointmentListHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppointmentListHUIExecute ]
{
	s code=$O(qHandle(""))
	if code'=""{
		s RowId=$O(qHandle(code,""))
		if RowId'=""{
			s ind=$O(qHandle(code,RowId,""))
			if ind'=""{
				s Row=qHandle(code,RowId,ind)
				k qHandle(code,RowId,ind)
				Quit $$$OK
			}
		}
	}
	s AtEnd=1
	Quit $$$OK
}

/// 治疗工作台工作列表
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Appointment","FindCurrentAppointmentListHUI","174","12618","2021-01-14","2021-01-18","","","1","","","","","","Y")
Query FindCurrentAppointmentListHUI(LocId As %String, UserId As %String, StartDate As %String, EndDate As %String, QPatientID As %String = "", ServiceGroupId As %String = "", QueryStatus As %String = "", QApplyNo As %String = "", QPatMedNo As %String = "", CheckAdmType As %String = "", queryArcim As %String = "", queryOrderLoc As %String = "", allocFlag As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "Rowid:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,LocDesc:%String,ResourceDesc:%String,DDCRSDate:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String,OEOREDR:%String,ServiceGroupDR:%String,CallStatus:%String,PatOther:%String,CureApplyNo:%String,DCASeqNo:%String,AdmRowID:%String,DCAAQty:%String,PatientID:%String,CallStatusCode:%String")
{
}

ClassMethod FindCurrentAppointmentListHUIExecute(ByRef qHandle As %Binary, LocId As %String, UserId As %String, StartDate As %String, EndDate As %String, QPatientID As %String = "", ServiceGroupId As %String = "", QueryStatus As %String = "", QApplyNo As %String = "", QPatMedNo As %String = "", CheckAdmType As %String = "", queryArcim As %String = "", queryOrderLoc As %String = "", allocFlag As %String = "", ExpStr As %String = "") As %Status
{
	s ^TMP("FindCurrentAppointmentList")=$lb(LocId,UserId,StartDate,EndDate,QPatientID,ServiceGroupId,QueryStatus,QApplyNo,QPatMedNo,CheckAdmType,queryArcim,queryOrderLoc,allocFlag,ExpStr)
	if (LocId="")||(UserId="") Quit $$$OK
	if StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) ;$zdh(StartDate,DateFormat)
	else  s StartDate=+$h
	if EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) ;$zdh(EndDate,DateFormat)
	else  s EndDate=+$h
	s DoctorId=##class(web.SSUser).GetDefaultCareProvider(UserId)
	if DoctorId="" Quit $$$OK
	s CareProcType=""
	s CareProcTypeDr=$p(^CTPCP(DoctorId,1),"^",4)
	s:CareProcTypeDr'="" CareProcType=$p(^CT("CPT",CareProcTypeDr),"^",4)
	s (QPatName,LogUserID,LogHospID,LogLangID,cspName,queryOrderDoc)=""
	if ExpStr'=""{
		s QPatName=$zcvt($p(ExpStr,"^",1),"U")
		s LogUserID=$p(ExpStr,"^",2)
		s LogHospID=$p(ExpStr,"^",3)
		s LogLangID=$p(ExpStr,"^",4)
		s cspName=$p(ExpStr,"^",5)
		s queryOrderDoc=$p(ExpStr,"^",6)
	}
	s GCAExpStr=LogHospID_"^"_LogLangID_"^"_cspName
	s HospID=$p(^CTLOC(LocId),"^",22)	
	
	b ;治疗基础设置，治疗工作台是否只能查看预约到本人的预约记录
	s DHCDocCureWorkQrySelf=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocWorkQrySelf",LocId,HospID)
	;+(##class(web.DHCDocConfig).GetConfigNode("DHCDocCureWorkQrySelf"))
	if (DHCDocCureWorkQrySelf=1){
		s ResRowId=$o(^RB("RES",0,"CTPCP",DoctorId,LocId,""))
		if ResRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
		for ASDate=StartDate:1:EndDate  d
		.s RSRowId="" for  s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId,ASDate,RSRowId)) q:RSRowId=""  d
		..s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
		..;Q:DDCRSStatus'="N"
		..s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",8)
		..Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
		..s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId))  Q:DCARowId=""  d
		...s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
		...s QuitFlag=$$CheckQuit()
		...Q:QuitFlag=1
		...s DCARtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
		...Q:DCARtn="" 
		...s:Adm'="" AdmDepId=$p($g(^PAADM(Adm)),"^",4)
		...s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
		...s AdmDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmDep,LogLangID)
		...s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
		....s DCAARowId=DCARowId_"||"_DCAAChildSub
		....s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
		....q:DCAAStatus="C"
		....s QuitFlag=$$CheckPerStatus()
		....Q:QuitFlag=1
		....d OutputRowCurrentAppListHUI
	}else{
		s LogLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LocId)
		for loop=1:1:$l(LogLocIDStr,"^") d
		.s LocId=$p(LogLocIDStr,"^",loop)
		.s ResRowId="" for  s ResRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId)) q:ResRowId=""  d
		..for ASDate=StartDate:1:EndDate  d
		...s RSRowId="" for  s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId,ASDate,RSRowId)) q:RSRowId=""  d
		....s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
		....;Q:DDCRSStatus'="N"
		....s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",8)
		....Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
		....s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId))  Q:DCARowId=""  d
		.....s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
		.....s QuitFlag=$$CheckQuit()
		.....Q:QuitFlag=1
		.....s DCARtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
		.....Q:DCARtn="" 
		.....s:Adm'="" AdmDepId=$p($g(^PAADM(Adm)),"^",4)
		.....s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
		.....s AdmDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmDep,LogLangID)
		.....s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
		......s DCAARowId=DCARowId_"||"_DCAAChildSub
		......s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
		......q:DCAAStatus="C"
		......s QuitFlag=$$CheckPerStatus()
		......Q:QuitFlag=1
		......d OutputRowCurrentAppListHUI	
	}
	Quit $$$OK
CheckPerStatus()
	s QuitFlag=0
	if allocFlag="Y"{
		s CallStatusDr=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",15)
		s CallStatus=""
		s:CallStatusDr'="" CallStatus=$p(^DHCDocCurePS(CallStatusDr),"^",1)
		if (QueryStatus'="")&&(CallStatusDr'=""){
			s QueryStatusCode=$p(^DHCDocCurePS(QueryStatus),"^",1)
			if QueryStatusCode="Wait" s QueryStatusCode=QueryStatusCode_"^Call^WaitCall"
			if ("^"_QueryStatusCode_"^")'[("^"_CallStatus_"^"){
				s QuitFlag=1
			}	
		}	
	}else{
		if (QueryStatus'="")&&(QueryStatus'=DCAAStatus){
			s QuitFlag=1	
			Q QuitFlag	
		}
		s CallStatusDr=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",15)
		if CallStatusDr=""{
			s QuitFlag=1	
			Q QuitFlag	
		}
		s CallStatus=$p(^DHCDocCurePS(CallStatusDr),"^",1)
		if CallStatus="Report"{
			s QuitFlag=1	
			Q QuitFlag
		}
	}
	Q QuitFlag
CheckQuit()
	s QuitFlag=0
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s PapmiDr=$p($g(^PAADM(Adm)),"^",1)
	if (QPatientID'="")&&(QPatientID'=PapmiDr){
		s QuitFlag=1
		Q QuitFlag
	}
	s AdmType=$P(^PAADM(Adm),"^",2)
	if (((CheckAdmType="I")&&(AdmType'=CheckAdmType))!((CheckAdmType="O")&&(AdmType="I"))){
		s QuitFlag=1
		Q QuitFlag
	}
	s PapmiName=$zcvt($P(^PAPER(PapmiDr,"ALL"),"^",1),"U")
	s PapmiName2=$zcvt($P(^PAPER(PapmiDr,"ALL"),"^",2),"U")
	if (QPatName'="")&&(PapmiName'[QPatName)&&(PapmiName2'[QPatName){
		s QuitFlag=1
		Q QuitFlag
	}
	s PatientMedicare=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiDr,AdmType,"")
	if (QPatMedNo'="")&&(PatientMedicare'=QPatMedNo){
		s QuitFlag=1
		Q QuitFlag
	}
	
	s CureApplyNo=$p($g(^DHCDocCure(DCARowId)),"^",18)
	if (QApplyNo'="")&&(CureApplyNo'=QApplyNo){
		s QuitFlag=1
		Q QuitFlag
	}
	s OrderId=$p(^DHCDocCure(DCARowId),"^",2)
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	if (queryArcim'="")&&(queryArcim'=ArcimId){
		s QuitFlag=1
		Q QuitFlag
	}
	s OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	if (queryOrderLoc'="")&&(queryOrderLoc'=OrderAddDeptDr){
		s QuitFlag=1
		Q QuitFlag
	}
	s OrderAddDocDr=""
	s OrderAddUserDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",1)
	if OrderAddUserDr'=""{
		s OrderAddDocDr=$p($g(^SSU("SSUSR",OrderAddUserDr)),"^",14)
	}
	if (queryOrderDoc'="")&&(OrderAddDocDr'=queryOrderDoc){
		s QuitFlag=1
		Q QuitFlag
	}
	if (##class(DHCDoc.DHCDocCure.Config).CheckCureCfgLimit(OrderId,ArcimId,UserId,HospID)="0"){
		s QuitFlag=1
		Q QuitFlag
	}
	Q QuitFlag
OutputRowCurrentAppListHUI
	s PatientInfo=$p(DCARtn,$c(1),1)
	s PatientID=$p(PatientInfo,"^",1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(DCARtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s AdmRowID=$p(CureAppInfo,"^",16)
	s CureApplyNo=$p(CureAppInfo,"^",31) 
	s Data=..GetCureAppointment(DCAARowId,GCAExpStr)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)
	s CTCareProv=$p(ASData,"^",4)
	s DDCRSDate=$p(ASData,"^",5)
	s TimeRangeDesc=$p(ASData,"^",7)
	s StartTime=$p(ASData,"^",8)
	s SortStartTime=$zth(StartTime,3)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11) 
	s DDCRSStatus=$p(ASData,"^",12)
	;------预约信息--------
	s OEOREDR=$p(AppData,"^",2)
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	s CallStatus=$p(AppData,"^",14)
	s DCASeqNo=$p(AppData,"^",15)
	s DCAAQty=$p(AppData,"^",16)
	s CallStatusCode=$p(AppData,"^",17)
	s AdmTypeDesc=##class(DHCDoc.Common.Translate).GetTransAdmType(AdmRowID,cspName,LogLangID)
	s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel_" | "_AdmTypeDesc_"("_AdmDep_")"
	s Data=$lb(DCAARowId,$g(PatientNo),$g(PatientName),$g(PatientSex),$g(PatientAge),$g(PatientTel),$g(AdmTypeDesc),$g(AdmDep),$g(ArcimDesc),DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate,OEOREDR,ServiceGroupDR,CallStatus,PatOther,CureApplyNo,DCASeqNo,AdmRowID,DCAAQty,PatientID,CallStatusCode)
 	
 	s SortCallStatus=$case(CallStatusCode,"Call":"A","WaitCall":"B","Wait":"C","Pass":"D",:"Z")
 	s SorSeqNo=DCASeqNo
 	if $L(SorSeqNo)'<3 Set SorSeqNo=$E(SorSeqNo,1,3) 
	else  if $L(SorSeqNo)=2 Set SorSeqNo="0"_SorSeqNo
	else  if $L(SorSeqNo)=1 Set SorSeqNo="00"_SorSeqNo
	else  if $L(SorSeqNo)=0 Set SorSeqNo="999"
 	s SortableStr=SortCallStatus_SorSeqNo
 	s qHandle(ASDate,SortStartTime,SortableStr,DCAARowId,$I(ind))=Data
 	quit
}

ClassMethod FindCurrentAppointmentListHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurrentAppointmentListHUIExecute ]
{
	s date=$O(qHandle(""))
	if date'=""{
		s time=$O(qHandle(date,""))
		if time'=""{
			s SeqNo=$O(qHandle(date,time,""))
			if SeqNo'=""{
				s RowId=$O(qHandle(date,time,SeqNo,""))
				if RowId'=""{
					s ind=$O(qHandle(date,time,SeqNo,RowId,""))
					if ind'=""{
						s Row=qHandle(date,time,SeqNo,RowId,ind)
						k qHandle(date,time,SeqNo,RowId,ind)
						Quit $$$OK
					}
				}
			}
		}
	}
	s AtEnd=1
	Quit $$$OK
}

/// Desc:获取剩余可预约数量
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetAppointLeftCount(210,2)
ClassMethod GetAppointLeftCount(DCARowId As %String, HospID As %String = "") As %String
{
	n (DCARowId,HospID,%session)
	s ApplyNoAppTimes=##class(DHCDoc.DHCDocCure.Apply).GetApplyNoAppTimes(DCARowId)
	Q:ApplyNoAppTimes=0 ApplyNoAppTimes
	s PAAdm=$p($g(^DHCDocCure(DCARowId)),"^",1)
	s OrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
	s OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	s HospID=$p($g(^CTLOC(OrderAddDeptDr)),"^",22)	
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	s PriorFlag=##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR) 
	s AppointAllowExec=$p($g(^DHCDocCure(DCARowId)),"^",20)
	s AdmType=$P(^PAADM(PAAdm),"^",2)
	if (AdmType="I")&&(PriorFlag="1")&&(AppointAllowExec="Y"){
		s ApplyNoAppTimes=1
	}else{
		s DCAOrderDoseQty=..GetDCADoseAppQty(DCARowId,HospID)
		s ApplyNoAppTimes=ApplyNoAppTimes\DCAOrderDoseQty
	}
	q ApplyNoAppTimes
}

}
