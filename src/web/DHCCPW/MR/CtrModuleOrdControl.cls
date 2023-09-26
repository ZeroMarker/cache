/// 医嘱监控模块
Class web.DHCCPW.MR.CtrModuleOrdControl Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ProcessOrderControl(repid, PathWayID)
{
	n (repid,PathWayID)	
	s objPathWay=##class(User.DHCMRClinicalPathWay).%OpenId(PathWayID)
	q:objPathWay="" -1
	d objPathWay.%Close()
	s MrAdmID=objPathWay.CPWMRADMDR
	s VerID=objPathWay.CPWPathwayDR.%Id()
	s objMrAdm=##class(web.DHCCPW.Base.MRAdm).GetObjById(MrAdmID)
	q:objMrAdm="" -2
	d objMrAdm.%Close()
	s Paadm=objMrAdm.AdmDr
	s ruleChildSub="" f  s ruleChildSub=$o(^DHCMRC("CPW",VerID,"RULE",ruleChildSub)) q:ruleChildSub=""  d
	.s ruleID=VerID_"||"_ruleChildSub
	.s objRule=##class(User.DHCMRCClinPathWaysRule).%OpenId(ruleID)
	.q:objRule=""
	.d objRule.%Close()
	.q:objRule.CPWRActiveFlag="N"
	.s:$p(objRule.CPWRExpression,$c(1),1)="A" ret=$$ExamExpressionA(repid,PathWayID,Paadm,objRule.CPWRExpression)
	.k objRule
	q 1

ExamExpressionA(repid,PathWayID,Paadm,Expression)
	n (repid,PathWayID,Paadm,Expression)
	s ItemId=$p(Expression,$c(1),2)
	s TimeStand=$p(Expression,$c(1),3) //1--入院时间  2--入径时间
	s TimeMin=$p(Expression,$c(1),4)
	s TimeMax=$p(Expression,$c(1),5)
	s TimeUnit=$p(Expression,$c(1),6) //D--天   H--时  M--分
	s QtyMin=$p(Expression,$c(1),7)
	s QtyMax=$p(Expression,$c(1),8)
	s SummaryInfo=$$GetPathWaySummary(PathWayID,TimeStand)
	s paadm=$p(SummaryInfo,"^",1)
	
	s tmpDate=$p(SummaryInfo,"^",2)
	s tmpTime=$p(SummaryInfo,"^",3)
	s FromDate=""
	s FromTime=""
	s ToDate=""
	s ToTime=""
	i TimeUnit="D"  d
	.s FromDate=tmpDate+TimeMin
	.s ToDate=tmpDate+TimeMax
	.s FromTime=0
	.s ToTime=$zth("23:59:59")
	i TimeUnit="H"  d
	.s FromDate=tmpDate
	.s ToDate=tmpDate
	.s FromTime=tmpTime+(TimeMin*3600)
	.s ToTime=tmpTime+(TimeMax*3600)
	.s FromDate=FromDate+(FromTime\86400)
	.s FromTime=FromTime-(FromTime\86400*86400)
	.s ToDate=ToDate+(ToDate\86400)
	.s ToTime=ToTime-(ToTime\86400*86400)
	i TimeUnit="M"
	.s FromTime=tmpTime+(TimeMin*60)
	.s ToTime=tmpTime+(TimeMax*60)
	.s FromDate=FromDate+(FromTime\86400)
	.s FromTime=FromTime-(FromTime\86400*86400)
	.s ToDate=ToDate+(ToDate\86400)
	.s ToTime=ToTime-(ToTime\86400*86400)
	s objItm=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(ItemId)
	q:'$IsObject(objItm) ""	// Add by zhaoyu 2013-04-28 临床路径监控-开始日期不为当天日期，不选择临床路径字典，不能查询出数据
	d objItm.%Close()
	f intCounter=1:1:objItm.CPWSIARCIM.Count()  d
	.s objCPWArcim=objItm.CPWSIARCIM.GetAt(intCounter)
	.s objArcim=##class(web.DHCCPW.Base.Arcim).GetObjById(objCPWArcim.ITMARCIMDR)
	.q:'$IsObject(objArcim)	// Add by zhaoyu 2013-04-28 临床路径监控-开始日期不为当天日期，不选择临床路径字典，不能查询出数据
	.d objArcim.%Close()
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",ItemId,intCounter,"Info")=objArcim.ARCIMRowId_"^"_objArcim.ARCIMDesc_"^"_objCPWArcim.ITMQty_"^"_QtyMin_"^"_QtyMax
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",ItemId,intCounter,"Result")=##class(web.DHCCPW.MR.CtrModuleOrdControl).QueryOrderItem(paadm,FromDate,FromTime,ToDate,ToTime,objCPWArcim.ITMARCIMDR)
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",ItemId,intCounter,"Judge")=$$JudgeARCIM(1)
	.k objArcim
	//s FromDate=ToDate //将下一个Step的起始时间设置为前一个Step的结束时间
	k objItm
	q 1
	
JudgeARCIM(param)
	;n (repid,paadm,itemRowid,intCounter)
	s info=$g(^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",ItemId,intCounter,"Info"))
	s result=$g(^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",ItemId,intCounter,"Result"))
	s tmp=""
	s $p(tmp,"^",1)=$p(result,"^",1) //判定是否完成
	s:$p(result,"^",3)>$p(info,"^",5) $p(tmp,"^",2)="more"
	s:$p(result,"^",3)<$p(info,"^",4) $p(tmp,"^",2)="less"
	s:(($p(result,"^",3)'<$p(info,"^",4))&&($p(result,"^",3)'>$p(info,"^",5))) $p(tmp,"^",2)="ok"
	s:$p(result,"^",1)=0 $p(tmp,"^",2)="not complete"
	i $p(tmp,"^",2)'="ok"  d
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"IsFired")=1 //表明已经触发
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"IsFired","Order")="" //表明触发了医嘱监控项目，回头可以通过$d来判断触发了多少个类别的监控
	q tmp

GetPathWaySummary(PathWayID,TimeStand)
	New (PathWayID,TimeStand)
	Set return=""
	Quit:PathWayID="" return
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	If $IsObject(objPathWay) {
		Set MRAdm=objPathWay.CPWMRADMDR
		Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
		Set (AdmitDate,AdmitTime,DischDate,DischTime)=""
		Set objPaadm=##Class(User.PAAdm).%OpenId(EpisodeID)
	    If $IsObject(objPaadm)
	    {
		   // Set AdmitDate=objPaadm.PAADMAdmDate
		   // Set AdmitTime=objPaadm.PAADMAdmTime
		   //upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
			Set AdmitDate=$p(AdmDateTime,"^",1)
			Set AdmitTime=$p(AdmDateTime,"^",2)
		    //Set DischDate=objPaadm.PAADMDischgDate
		    //Set DischTime=objPaadm.PAADMDischgTime
		    //Update by pylian 2016-01-21 修改出院时间取值方式
			Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
			Set DischDate=$p(DischDateTime,"^",1)
			Set DischTime=$p(DischDateTime,"^",2)
	    }
		Set CPWStatus=objPathWay.CPWStatus
		Set InDate=objPathWay.CPWInDate
		Set InTime=objPathWay.CPWInTime
		Set OutDate=objPathWay.CPWOutDate
		Set OutTime=objPathWay.CPWOutTime
		
		Set return="^^^^^^^^^"
		s $p(return,"^",1)=EpisodeID
		If TimeStand=1 {
			Set $p(return,"^",2)=AdmitDate ;$zd(AdmitDate,3)
			Set $p(return,"^",3)=AdmitTime ;$zt(AdmitTime,1)
		} Else {
			Set $p(return,"^",2)=InDate ;$zd(InDate,3)
			Set $p(return,"^",3)=InTime ;$zt(InTime,1)
		}
		Set InDays=0
		If CPWStatus="I" {
			Set InDays=+$h-InDate          //入径状态，入径天数=当前日期-入径日期
		}
		If CPWStatus="O" {
			Set InDays=DischDate-InDate    //完成状态，入径天数=出院日期-入径日期
		}
		If CPWStatus="C" {
			Set InDays=OutDate-InDate      //出径状态，入径天数=出径日期-入径日期
		}
		Set $p(return,"^",4)=InDays+1
	}
	Quit return
}

/*
ClassMethod ProcessStepItemOrderControl(repid, paadm, StepItemID, SummaryInfo)
{
	n (repid, paadm, StepItemID, SummaryInfo)
	s VerID=$p(StepItemID,"||",1)
	s EpID=$p(StepItemID,"||",2)
	s StepID=$p(StepItemID,"||",3)
	s InPathDate=$p(SummaryInfo,"^",1)
	s:InPathDate["-" InPathDate=$zdh(InPathDate,3)
	s FromDate=InPathDate //设置开始日期的初始值
	
	s StepID=VerID_"||"_EpID_"||"_StepID
	s objStep=##class(User.DHCMRCClinPathWaysEpStep).%OpenId(StepID)
	q:'$IsObject(objStep) 0
	d objStep.%Close()
	s ToDate=FromDate+objStep.CPWSDay
	
	s objItm=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(StepItemID)
	d objItm.%Close()
	f intCounter=1:1:objItm.CPWSIARCIM.Count()  d
	.s objCPWArcim=objItm.CPWSIARCIM.GetAt(intCounter)
	.s objArcim=##class(web.DHCCPW.Base.Arcim).GetObjById(objCPWArcim.ITMARCIMDR)
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",StepItemID,intCounter,"Info")=objArcim.ARCIMRowId_"^"_objArcim.ARCIMDesc_"^"_objCPWArcim.ITMQty
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",StepItemID,intCounter,"Result")=##class(web.DHCCPW.MR.CtrModuleOrdControl).QueryOrderItem(paadm,FromDate,ToDate,objCPWArcim.ITMARCIMDR)
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",StepItemID,intCounter,"Judge")=$$JudgeARCIM(1)
	//s FromDate=ToDate //将下一个Step的起始时间设置为前一个Step的结束时间
	k objStep
	k objItm
	q 1
JudgeARCIM(param)
	;n (repid,paadm,itemRowid,intCounter)
	s info=$g(^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",StepItemID,intCounter,"Info"))
	s result=$g(^CacheTemp("CPWControl",repid,"paadm",paadm,"ARCIM",StepItemID,intCounter,"Result"))
	s tmp=""
	s $p(tmp,"^",1)=$p(result,"^",1) //判定是否完成
	s:$p(result,"^",3)>$p(info,"^",3) $p(tmp,"^",2)="more"
	s:$p(result,"^",3)<$p(info,"^",3) $p(tmp,"^",2)="less"
	s:$p(result,"^",3)=$p(info,"^",3) $p(tmp,"^",2)="ok"
	s:$p(result,"^",1)=0 $p(tmp,"^",2)="not complete"
	i $p(tmp,"^",2)'="ok"  d
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"IsFired")=1 //表明已经触发
	.s ^CacheTemp("CPWControl",repid,"paadm",paadm,"IsFired","OrderControl")="" //表明触发了医嘱监控项目，回头可以通过$d来判断触发了多少个类别的监控
	q tmp
}
*/
/// 查询某个时间段的医嘱项目
ClassMethod QueryOrderItem(paadm, FromDate, FromTime, ToDate, ToTime, ArcimID)
{
		n (paadm, FromDate, FromTime, ToDate, ToTime, ArcimID)
		s ret=""
		s:FromDate["-" FromDate=$zdh(FromDate,3)
		s:FromDate["/" FromDate=$zdh(FromDate,4)
		s:ToDate["-" FromDate=$zdh(ToDate,3)
		s:ToDate["/" FromDate=$zdh(ToDate,4)	
		s:ArcimID'["||" ArcimID=ArcimID_"||1"
		s ret="0^0^0^0" //返回值   是否完成^时间^数量
		s OrderID="" f  s OrderID=$o(^OEORD(0,"Adm",paadm,OrderID)) q:OrderID=""  d
		.s tmpDate="" f  s tmpDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,tmpDate)) q:tmpDate=""  d
		..q:((tmpDate<FromDate)||(tmpDate>ToDate))
		..s childSub="" f  s childSub=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,tmpDate,childSub)) q:childSub=""  d
		...s orderItemID=OrderID_"||"_childSub
		...s orderTime=..GetOrderDateTime(orderItemID)
		...s objOdrItm=##class(web.DHCCPW.Base.OrdItem).GetObjById(orderItemID)
		...;b
		...q:objOdrItm=""
		...d objOdrItm.%Close()
		...s flag=""
		...q:((objOdrItm.OEORISttTim<FromTime)&&(objOdrItm.OEORISttTim>ToTime))
		...//如果必须是执行状态的医嘱，请把一下1句取消注释
		...;s:objOdrItm.OSTATCode'="E" flag=1
		...;----------------------------------------------
		...k:flag=1 objOdrItm
		...q:flag=1
		...s $p(ret,"^",1)=1 //代表在指定时间内有医嘱项目
		...s $p(ret,"^",2)="0"
		...s $p(ret,"^",3)=$p(ret,"^",3)+objOdrItm.OEORIDoseQty
		...s $p(ret,"^",4)=objOdrItm.OEORIUnitDR
		...;w objOdrItm.OEORIDoseQty,!
		...k objOdrItm

		q ret
}

/// 根据设置取医嘱时间
ClassMethod GetOrderDateTime(OrderItemID)
{
	n (OrderItemID)
	s DateSetting=""
	s objBC=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("CPWOrderDateTimeType")
	if $IsObject(objBC) {
		s DateSetting=objBC.BCValue
	}
	i ((DateSetting=1)||(DateSetting=0))  d  //医嘱的StartDate
	.s objOdrItm=##class(web.DHCCPW.Base.OrdItem).GetObjById(OrderItemID)
	.q:objOdrItm=""
	.d objOdrItm.%Close()
	.s Date=objOdrItm.OEORISttDat
	.s Time=objOdrItm.OEORISttTim
	.k objOdrItm
	i ((DateSetting=2))  d   //执行日期
	.s OrderID=$p(OrderItemID,"||",1)
	.s itmChild=$p(OrderItemID,"||",2)
	.s execChild="" f  s execChild=$o(^OEORD(OrderID,"I",itmChild,"X",execChild)) q:execChild=""  d
	..s execData=$g(^OEORD(OrderID,"I",itmChild,"X",execChild))	
	..s Date=$p(execData,"^",1)
	..s Time=$p(execData,"^",2)
	quit $g(Date)_","_$g(Time)
}

}
