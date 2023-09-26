Class web.DHCDocMain Extends DHCDoc.Util.RegisteredObject
{

Query FindOrderExecDet(orderId, execStDate, execEndDate) As websys.Query(ROWSPEC = "HIDDEN:%String:OrderExecId,HIDDEN:%String:TItemStatCode,CustomSelected:%String:选择^40,TExStDate:%String:要求执行时间^110,TExecState:%String:状态,TExecStateCode:%String:状态代码,TRealExecDate:%String:执行时间,THourExEnTime:%String:小时医嘱结束时间,TExecRes:%String:执行原因,TExecFreeRes:%String:免费原因,TExecUser:%String:处理人,TExecLoc:%String:处理Loc,TBillState:%String:帐单状态,TExecFreeChargeFlag:%String:免费状态,TgiveDrugQty:%String:发药数量,TcancelDrugQty:%String:退药数量,TPBOID:%String:帐单号,TApplyCancelStatus:%String:申请撤销状态,TApplyCancelStatusCode:%String:申请撤销状态,IsCanExecOrdArrear:%String:欠费执行标志,TExDateTimes:%String:要求执行次数,IsCancelArrivedOrd:%String,Notes:%String:备注^100,ExecPart:%String:检查部位^100")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMain","FindOrderExecDet","77067||4","","")
ClassMethod FindOrderExecDetExecute(ByRef qHandle As %Binary, orderId, execStDate = "", execEndDate = "") As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	
	s ^||RepidTemp("web.DHCDocMain","FindOrderExecDet","CacheTemp")=repid
	i orderId="" set qHandle = $lb(0,repid,0)  Q $$$OK
	K ^||TMP
	s ^Temp("wanghc","orderId")=orderId_","_execStDate_","_execEndDate
	s:execStDate'="" execStDate=..%ZDH(execStDate) //$zdh(execStDate,3)
	s:execEndDate'="" execEndDate=..%ZDH(execEndDate) //$zdh(execEndDate,3)
	s order = +orderId
	s ordItem = $p(orderId,"||",2)
	s pb=""
	s pb=$o(^DHCPBi(0,"OEORI",orderId,""),-1)
	S SessionLocId = %session.Data("LOGON.CTLOCID")
	S EpisodeID = $p(^OEORD(order),"^",1)
	s deptDesc=""
	
	i (order>0) &&(ordItem>0) d
	.s ordDept = $p(^OEORD(order,"I",ordItem,1),"^",3)
	.s:+ordDept>0 deptDesc = $p(^CTLOC(ordDept),"^",2)
	.s TOrderStatusDR=$p(^OEORD(order,"I",ordItem,1),"^",13)
	.s:+TOrderStatusDR>0 TItemStatCode = $p(^OEC("OSTAT",TOrderStatusDR),"^",1)
	
	s orderExecId=0
	f  s orderExecId=$O(^OEORD(order,"I",ordItem,"X",orderExecId)) q:orderExecId=""  d
	.s (TExecDate,TExecState,TExecStateCode,TExecRes,TExecFreeRes,TRealExecDate,TExecUser,TExecLoc,TBillState,TExecFreeChargeFlag,TgiveDrugQty,TcancelDrugQty,pbo,TPBOID,TExStTimeDesc)=""
	.S (TApplyCancelStatus,TApplyCancelStatusCode,ExecResDr)=""
	.s str = ^OEORD(order,"I",ordItem,"X",orderExecId)
	.s CtpcpDR = $p(str,"^",15)
	.s:(+CtpcpDR>0)&&($d(^CTPCP(CtpcpDR,1))=1) TExecUser = $p(^CTPCP(CtpcpDR,1),"^",2)
	.s TExStDate = $p(str,"^",1)			// OEORE_ExStDate
	.q:(execStDate'="")&&(TExStDate<execStDate)
	.q:(execEndDate'="")&&(TExStDate>execEndDate)
	.;s TOrderStatusDR=$p(^OEORD(order,"I",ordItem,"X",orderExecId,"BILL"),"^",1) ;OEORE_OrderStatus_DR
	.s TExecFreeChargeFlag=""
	.s:$d(^OEORD(order,"I",ordItem,"X",orderExecId,"BILL")) TExecFreeChargeFlag=$p(^OEORD(order,"I",ordItem,"X",orderExecId,"BILL"),"^",18)	;OEORE_FreeChargeFlag
	.s TExecFreeChargeFlag=$s(TExecFreeChargeFlag="Y":"免费",1:"")
	.s TExStTime = $p(str,"^",2)			// OEORE_ExStTime
	.i TExStDate'="" d
	..s TExStDate1=..%ZD(TExStDate)
	..i TExStDate1["-" s TExStDateDesc=$p(TExStDate1,"-",2,3)
	..i TExStDate1["/" s TExStDateDesc=$p(TExStDate1,"/",1,2)
	..//s TExStDateDesc = $p($zd(TExStDate,3),"-",2,3)
	.s:TExStTime'="" TExStTimeDesc =..%ZT(TExStTime,1) //..%ZT(TExStTime,2)
	.s TExecDate = $p(str,"^",19)		// OEORE_DateExecuted
	.i TExecDate'=""  d
	..s TExecDate=..%ZD(TExecDate)
	..i TExecDate["-" s TExecDate=$p(TExecDate,"-",2,3)
	..i TExecDate["/" s TExecDate=$p(TExecDate,"/",1,2)
	..//s TExecDate = $p($zd(TExecDate,3),"-",2,3)
	.s TExecTime = $p(str,"^",20)		// OEORE_TimeExecuted
	.s:TExecTime'="" TExecTime = ..%ZT(TExecTime,1) //..%ZT(TExecTime,2)
	.s THourExEnTime=$p(str,"^",36)
	.i THourExEnTime'="" d
	..s THourExEnTime=..%ZT(THourExEnTime,1)
	..s:TExStTime'="" TExStTimeDesc = ..%ZT(TExStTime,1)
	.s ExecStateDR= $p(str,"^",16)
	.i +ExecStateDR>0 s TExecState = $p(^OEC("STAT",ExecStateDR),"^",2),TExecStateCode=$p(^OEC("STAT",ExecStateDR),"^",1)	;OEC_Order_AdminStatus
	.e  s TExecState = "未执行",TExecStateCode="未执行"
	.;找申请撤销表中的状态
	.Set appId = $o(^User.DHCAPPI("IndexTypeItem"," E"," "_order_"||"_ordItem_"||"_orderExecId,""))
	.If +appId'=0 d
	..Set CurrentStatus = $lg(^User.DHCAPPD(appId),4)		
	..Set CurrentStatusDesc = $p(^OEC("APPSTAT",CurrentStatus),"^",2) 
	..Set CurrentStatusCode = $p(^OEC("APPSTAT",CurrentStatus),"^",1)
	..Set TApplyCancelStatus=CurrentStatusDesc,TApplyCancelStatusCode=CurrentStatusCode
	.;执行的原因
	.i $d(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH"))=10 d
	..s STCHSub = $o(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH",""),-1)		;OE_OrdExecStatus
	..s:STCHSub>0 ExecResDr = $p(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH",STCHSub),"^",2) ;STCH_Reason_DR
	..s:ExecResDr>0 TExecRes= $p(^OEC("ASCR",ExecResDr),"^",2)	;OEC_AdminStatusChReason->ASCR_Desc
	..i TExecRes="" s TExecRes=$p(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH",STCHSub),"^",6)
	.;免费原因
	.i $d(^OEORD(order,"I",ordItem,"X",orderExecId,"FCCH"))=10 d
	..s FCCHSub = $o(^OEORD(order,"I",ordItem,"X",orderExecId,"FCCH",""),-1)		;OE_OrdExecFreeCharge
	..s:FCCHSub>0 ExecResDr = $p(^OEORD(order,"I",ordItem,"X",orderExecId,"FCCH",FCCHSub),"^",2) ;FCCH_Reason_DR
	..s:ExecResDr>0 TExecFreeRes= $p(^OEC("ASCR",ExecResDr),"^",2)	;OEC_AdminStatusChReason->ASCR_Desc
	.;
	.s TExecLoc = deptDesc
	.s TBillState = $p(str,"^",6)
	.s TBillState=$s(TBillState="B":"计费", TBillState="P":"结算", TBillState="I":"停止后未做账单", TBillState="R":"已退费",1:"需要计费") ;TBillState="TB":"需要计费", 
	.s drugRtnInfo=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.ord.GetDispReturnQty",orderId_"||"_orderExecId)
	.s TgiveDrugQty = $p(drugRtnInfo,"^",1)
	.s TcancelDrugQty = $p(drugRtnInfo,"^",2)
	.s:+pb>0 pbo= $o(^DHCPB(0,"OEEXC",orderId_"||"_orderExecId,pb,0))
	.s:+pbo>0 TPBOID=pb_"||"_pbo
	.s IsCanExecOrdArrear = ##class(web.DHCDocMainOrderInterface).IsCanExecOrdArrear(EpisodeID,orderId_"||"_orderExecId,SessionLocId)
	.//判断是否已经治疗,已经治疗的执行记录不能撤销执行
	.s IsCancelArrivedOrd=1
	.i $d(^DHCDocCure(0,"OEORE",orderId_"||"_orderExecId)) d
	..s DCARowId=$o(^DHCDocCure(0,"OEORE",orderId_"||"_orderExecId,""))
	..i DCARowId'="" d 
	...s DCAAChildSub=$O(^DHCDocCure(0,"OEORE",orderId_"||"_orderExecId,DCARowId,""))
	...s DCAAStatus=$p(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub),"^",7)
	...i DCAAStatus="A" s IsCancelArrivedOrd=0
	.;执行备注
	.s Notes=$P(^OEORD(order,"I",ordItem,"X",orderExecId),"^",44)
	.s ExecPart=##Class(web.DHCAPPInterface).GetOrdExecDesc(orderId_"||"_orderExecId)
	.s ^||TMP(TExStDate,+TExStTime,orderExecId)=$lb(orderId_"||"_orderExecId,TItemStatCode,0,TExStDateDesc_" "_TExStTimeDesc,TExecState,TExecStateCode,TExecDate_" "_TExecTime,THourExEnTime,TExecRes,TExecFreeRes,TExecUser,TExecLoc,TBillState,TExecFreeChargeFlag,TgiveDrugQty,TcancelDrugQty,TPBOID,TApplyCancelStatus,TApplyCancelStatusCode,IsCanExecOrdArrear,"",IsCancelArrivedOrd,Notes,ExecPart)
	
	
	
			
	s sd="" f  s sd = $o(^||TMP(sd),-1) q:sd=""  d
	.;extime -> times
	.s times=1
	.s stflag = "" f  s stflag = $o(^||TMP(sd,stflag)) q:stflag=""  d
	..s execId = "" f  s execId = $o(^||TMP(sd,stflag,execId)) q:execId=""  d
	...s ^||TMP(sd,stflag,execId)=^||TMP(sd,stflag,execId)_$lb($p($listget(^||TMP(sd,stflag,execId),3)," ")_" 第"_times_"次"),times = times+1
	.;out put row
	.s st = "" f  s st = $o(^||TMP(sd,st),-1) q:st=""  d
	..s exec =""  f  s exec = $o(^||TMP(sd,st,exec),-1) q:exec=""  d
	...s ind = ind+1
	...s ^CacheTemp(repid,ind) = ^||TMP(sd,st,exec)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

Query FindOrderFee(orderId) As websys.Query(ROWSPEC = "HIDDEN:%String:FeeId,HIDDEN:%String:TCancelStatu,TTarDesc:%String:收费项名称^150,TTarCode:%String:代码^80,TQty:%String:数量^50,TPrice:%String:单价^50,TAmount:%String:金额^50,TDate:%String:记账时间,TExtralComment:%String:原因")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMain","FindOrderFee","77071||59||2")
ClassMethod FindOrderFeeExecute(ByRef qHandle As %Binary, orderId) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		i orderId="" set qHandle = $lb(0,repid,0) Q $$$OK
		;s ^Temp("wanghc","orderfee")=orderId
		s flag = $l(orderId,"||")
		i flag'=3 set qHandle = $lb(0,repid,0) Q $$$OK
		
		s (pb,pbo,pbd)=0
		//医嘱表 写法有问题
		i flag=2 d	//医嘱orditemrowid
		.s pb = $o(^DHCPBi(0,"OEORI",orderId,""),-1)
		.q:+pb'>0
		.s pbo = $o(^DHCPBi(0,"OEORI",orderId,pb,""),-1)
		.q:+pbo'>0
		e  i flag=3 d	//执行医嘱ordexecrowid
		.s pb = $O(^DHCPB(0,"OEEXC",orderId,""),-1)
		.q:+pb'>0
		.s pbo = $O(^DHCPB(0,"OEEXC",orderId,pb,""),-1)
		.q:+pbo'>0
		
		i pbo'>0 set qHandle = $lb(0,repid,0) Q $$$OK
		s TPBOrderBillStatus = $p(^DHCPB(pb,"O",pbo),"^",16)
		f  s pbd = $o(^DHCPB(pb,"O",pbo,"D",pbd)) q:pbd=""  d
		.s (TTarDesc,TTarCode,TQty,TPrice,TAmount,TDate)=""
		.s str = ^DHCPB(pb,"O",pbo,"D",pbd)
		.s tar = $p(str,"^",3)
		.q:+tar'>0
		.s TTarDesc = $p(^DHCTARI(tar),"^",2)
		.s TTarCode = $p(^DHCTARI(tar),"^",1)
		.s TQty = $p(str,"^",5)
		.s TPBDBillStatus="B"
		.i TPBOrderBillStatus="R" s TPBDBillStatus="R"
		.i TPBOrderBillStatus="P" s TPBDBillStatus="R"
		.s TPBDOriginalDR = $p(str,"^",23)
		.i +TPBDOriginalDR>0 s TPBDBillStatus="R"
		.e  i $d(^DHCPB(0,"OriginalDR",pb_"||"_pbo_"||"_pbd))=10 s TPBDBillStatus="R"
		.;e  s TPBDBillStatus="B"
		.s TExtralComment=$p(str,"^",24)
		.;s TPrice = $p(str,"^",4)
		.;s TAmount = $p(str,"^",7)
		.s TPrice = $fn($p(str,"^",4),"-")
		.s TAmount = $fn($p(str,"^",7),"-")
		.s TDate = $p(str,"^",11)
		.s:TDate'="" TDate=..%ZD(TDate)
		.s ind = ind+1
		.s ^CacheTemp(repid,ind) = $lb(pb_"||"_pbo_"||"_pbd,TPBDBillStatus,TTarDesc,TTarCode,TQty,TPrice,TAmount,TDate,TExtralComment)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

/// @params: oeore 执行医嘱rowid,
/// @params: endTime 结束时间 数字格式
/// w ##class(web.DHCDocMain).CheckUpdateHour("178||583","",2)
ClassMethod CheckUpdateHour(oeore, endTime, HospId As %String = "")
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s:HospId="" HospId=##class(DHCDoc.Common.Hospital).GetAffiliatedHospitalId("","","","",oeore)
	s HospCodeNode="HospDr_"_HospId
	s oeori = $p(oeore,"||",1)
	s oeorisub = $p(oeore,"||",2)
	s oeoresub = $p(oeore,"||",3)
	s str1 = ^OEORD(oeori,"I",oeorisub,1)
	s arcim = $p(str1,"^",2) 
	s billuom=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),8)),"^",14)      ;UOM
	s:+billuom'=0 buomcod=$p($g(^CT("UOM",billuom)),"^")
	s buomcod=$zcvt($g(buomcod),"U")
	q:(buomcod'="HOUR") "不是HOUR医嘱,不能修改时间!"
	
	s TExecStateCode=""
	s str = ^OEORD(oeori,"I",oeorisub,"X",oeoresub)
	s ExecStateDR= $p(str,"^",16)
	i +ExecStateDR>0 s TExecState = $p(^OEC("STAT",ExecStateDR),"^",2),TExecStateCode=$p(^OEC("STAT",ExecStateDR),"^",1)
	//Q:TExecStateCode'="D" "执行记录停止后才能修改时间!"
	s TItemStatCode=""
	//s itemStatDr = $p(str1,"^",13) 			;OEORI_ItemStat_DR ;OEC_OrderStatus
	//s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	//q:(TItemStatCode'="D") "医嘱未停止不能修改HOUR医嘱!"
	s OEOREBilled=$p($g(^OEORD(oeori,"I",oeorisub,"X",oeoresub)),"^",6)
	q:OEOREBilled="P" "已经结算的执行记录不能修改时间!"
	
	s TStopDate = $p(^OEORD(oeori,"I",oeorisub,3),"^",34)		;XDate
	s TStopTime = $p(^OEORD(oeori,"I",oeorisub,2),"^",15)		;XTime
 	s execstr = ^OEORD(oeori,"I",oeorisub,"X",oeoresub)
 	s TExStDate = $p(execstr,"^",1)			// OEORE_ExStDate
	s TExStTime = $p(execstr,"^",2)
	;remove--ms 00:00:01---->00:00对应的数字时间,前台只能到秒
	i TExStTime>0 S TExStTime=..%ZTH(..%ZT(TExStTime,2)) 
	//医生站设置-小时医嘱修改停止时间控制
	Set Flag = $g(^DHCDocOrderBillConfig(HospCodeNode,"Main","UpdateHourOrderEndTime"),"N") ;N表示只能修改最后一条
	if (Flag="N") {
		s NeedStopDate=""
		if (TExStDate'=TStopDate)&&(TStopDate'=""){
			s NeedStopDate=TStopDate
			
		}
		if (TExStDate'=..%SysDate())&&(TStopDate=""){
			s NeedStopDate=..%SysDate()
		}
		
		if (NeedStopDate'=""){
			Q ..%Translate("ipdoc.patinfoview.csp","要求执行日期是")_..%ZD(NeedStopDate)_..%Translate("ipdoc.patinfoview.csp","的才能修改结束时间!")
		}
	}
	
	
	;q:(TExStDate>TStopDate)&&(endTime'="") "执行记录在医嘱停止后生成!执行记录无效"
	
	;q:(Flag="N")&&(TExStDate=TStopDate)&&(TStopTime<endTime)&&(endTime'="") "结束时间不能大于医嘱停止时间"
	;q:(Flag="N")&&(TExStDate=TStopDate)&&(TExStTime>endTime)&&(endTime'="") "结束时间不能小于要求执行时间"
	
	q:(TExStTime>endTime)&&(endTime'="") "结束时间不能小于要求执行时间"
	q:(Flag="N")&&(TExStDate=TStopDate)&&(TStopTime<endTime)&&(endTime'="") "结束时间不能大于医嘱停止时间"
	
	;修改后的小时医嘱结束时间应大于当天上一条执行记录的结束时间和要求执行时间
	;修改后的小时医嘱结束时间应小于当天下一条执行记录的结束时间和要求执行时间
	s PreOEOreSub=oeoresub-1
	s NextOEOreSub=oeoresub+1
	if ($d(^OEORDi(0,"OrdItem",oeori,oeorisub,TExStDate,PreOEOreSub))) {
		s PreExStTime = $p(^OEORD(+oeori,"I",oeorisub,"X",PreOEOreSub),"^",2)
		s PreHourExEnTime=$p(^OEORD(+oeori,"I",oeorisub,"X",PreOEOreSub),"^",36) //小时医嘱结束时间
		if ((PreHourExEnTime'="")&&(PreHourExEnTime>=endTime)&&(endTime'="")) {
			Q ..%Translate("ipdoc.patinfoview.csp","结束时间应晚于该执行记录当天上一条执行记录的结束时间")_..%ZT(PreHourExEnTime,1)_"！"
		}
		if ((PreExStTime>=endTime)&&(endTime'="")) {
			Q ..%Translate("ipdoc.patinfoview.csp","结束时间应晚于该执行记录当天上一条执行记录的要求执行时间")_..%ZT(PreExStTime,1)_"！"
		}
	}
	if ($d(^OEORDi(0,"OrdItem",oeori,oeorisub,TExStDate,NextOEOreSub))) {
		s NextExStTime = $p(^OEORD(+oeori,"I",oeorisub,"X",NextOEOreSub),"^",2)
		s NextHourExEnTime=$p(^OEORD(+oeori,"I",oeorisub,"X",NextOEOreSub),"^",36) //小时医嘱结束时间
		if ((NextHourExEnTime'="")&&(NextHourExEnTime <= endTime)&&(endTime'="")) {
			Q ..%Translate("ipdoc.patinfoview.csp","结束时间应早于该执行记录当天下一条执行记录的结束时间")_..%ZT(NextHourExEnTime,1)_"！"
		}
		if ((NextExStTime <= endTime)&&(endTime'="")) {
			Q ..%Translate("ipdoc.patinfoview.csp","结束时间应早于该执行记录当天下一条执行记录的要求执行时间")_..%ZT(NextExStTime,1)_"！"
		}
	}
	q 1
}

ClassMethod CheckStopPermission(ids)
{
	s flag=1
	s oeori = ids
	s user = %session.Get("LOGON.USERID")
	s locid = %session.Get("LOGON.CTLOCID")
	s groupid = %session.Get("LOGON.GROUPID")
	s len = $l(oeori,"^")
	f i=1:1:len q:(flag=0)  d
	.s oeorirowid = $p(oeori,"^",i)
	.s flag = ##class(appcom.OEOrdItem).CheckStopPermission(oeorirowid,user,locid,groupid)
	.q:(flag=0)
	if (flag=1){
		q "1"
	}else{
		s str1 = ^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)
		s ItmMastDR=$p(str1,"^",2)
		s TOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
		q "您无权停止 "_TOrderDesc_" 医嘱!"
	}
}

/// @author: wanghc
/// @date:   2013/3/31
/// @desc:   登记是不是病区,用于区分护士登录与医生登录
/// 			是护士返回1,否刚返回0
ClassMethod isNurseLogin()
{
	s ctloctype = $P($G(^CTLOC(%session.Get("LOGON.CTLOCID"))),"^",13)
	q:ctloctype="W" 1
	q 0
}

/// 入参 oe_orditem表rowid
ClassMethod getExecDateScope(orderId As %String, execBarExecNum As %String = "")
{
	q:orderId="" "^^^"  ;2020.3.2
	Set langid=..%LanguageID()
	s order = +orderId
	s ordItem = $p(orderId,"||",2)
	q:'$d(^OEORD(order,"I",ordItem,1)) "^^"
	s EpisodeID=$P(^OEORD(order),"^",1)
	if execBarExecNum="-" s execBarExecNum=""
	if (execBarExecNum'="")&&(+execBarExecNum>=0){
		s stDate=..%SysDate()-$ZABS($P(execBarExecNum,"-",1))
		s endDate=..%SysDate()+$ZABS($P(execBarExecNum,"-",2))
	}else{
		s stDate = $p(^OEORD(order,"I",ordItem,1),"^",9), endDate=stDate
		s orderExecId=0
		f  s orderExecId=$O(^OEORD(order,"I",ordItem,"X",orderExecId)) q:orderExecId=""  d
		.s str = ^OEORD(order,"I",ordItem,"X",orderExecId)
		.s TExStDate = $p(str,"^",1)	//要求执行时间
		.i stDate="" s stDate=TExStDate
		.e  i stDate>TExStDate d
		..s stDate=TExStDate
		.i endDate="" s endDate=TExStDate
		.e  i endDate<TExStDate d
		..s endDate=TExStDate
	}
	s (instrDr,ISShortPrior)=""
	
	s space = "&nbsp"
	s orderParref=+orderId
	s oeori = $p(orderId,"||",2)
	s str1 = ^OEORD(orderParref,"I",oeori,1)
	s ItmMastDR = $p(str1,"^",2)	
	i +ItmMastDR>0 d
	.s instrDesc1="",PHFreqDesc1="",depProcNotes="",doseQty="",OEORIUnit=""
	.i $d(^OEORD(orderParref,"I",oeori,2)) d
	..s doseQty = ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(orderId) //$p(^OEORD(orderParref,"I",oeori,2),"^",1)	;用量 OEORI_DoseQty	
	..s OEORIUnitDR=$p(^OEORD(orderParref,"I",oeori,2),"^",3)
	..i OEORIUnitDR'="" s OEORIUnit=$p($g(^CT("UOM",OEORIUnitDR)),"^",2)
	..e  s OEORIUnit=""
	..s OEORIUnit=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OEORIUnit,langid)
	..s instrDr = $p(^OEORD(orderParref,"I",oeori,2),"^",7)	;用法 OEORI_Instr_DR
	..s:+instrDr'=0 instrDesc1=$p(^PHCIN(instrDr),"^",2)
	..s instrDesc1=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrDesc1,langid)
	..//s PHFreqDr = $p(^OEORD(orderParref,"I",oeori,2),"^",4)	;频次 OEORI_PHFreq_DR
	..s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(orderId,"|")
	..s PHFreqDr=$List(OrdFreqInfo,1)
	..s PHFreqDesc1=$List(OrdFreqInfo,2)	
	..//i PHFreqDr'="" d
    ..//.s PHFreqDesc1 = $p(^PHCFR(PHFreqDr),"^",3)
    ..//.s WeekFlag=$P(^PHCFR(PHFreqDr),"^",9)
    ..//.i WeekFlag="Y" s OrderFreqWeek=$p($g(^OEORD(orderParref,"I",oeori,"DHC")),"^",55),PHFreqDesc1=PHFreqDesc1_" "_$TR(OrderFreqWeek,"|","")
	.s:$d(^OEORD(orderParref,"I",oeori,"DEP"))=11 depProcNotes = ^OEORD(orderParref,"I",oeori,"DEP")	;备注 OEORI_DepProcNotes
	.s TOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	.s TOrderDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",TOrderDesc,langid)
	.s TOrderDesc=TOrderDesc_space_doseQty_OEORIUnit_space_instrDesc1_space_PHFreqDesc1_space_depProcNotes
	.s PriorityDR=$p(^OEORD(orderParref,"I",oeori,1),"^",8)
	.s ISShortPrior=##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR) 
	
	//OrdExecAppendOrdList
	s OrdExecAppendOrdList=##Class(DHCDoc.DHCDocConfig.InstrArcim).GetArcimWardInfo(EpisodeID,ItmMastDR,instrDr,"2")
	if (OrdExecAppendOrdList=""){
		s HiddenOrdExecAppendConfig="N"
	}else{
		s HiddenOrdExecAppendConfig="Y"
	}
	
	q:stDate'="" ..%ZD(stDate)_"^"_..%ZD(endDate)_"^"_TOrderDesc_"^"_HiddenOrdExecAppendConfig_"^"_ISShortPrior
	q "^^"_TOrderDesc_"^"_HiddenOrdExecAppendConfig_"^"_ISShortPrior
	q ""
}

/// 取消费用 pbdrowid
ClassMethod cancelFee(pbd, user)
{
	s obj = ##class(User.DHCPatBillDetails).%OpenId(pbd,0)
	q:'$IsObject(obj) -1_" 没找到费用明细"
	s qty = obj.PBDBillQty
	s unit = obj.PBDUnitPrice
	s disprice = obj.PBDDiscPrice
	s insprice = obj.PBDInsPrice
	s patprice = obj.PBDPatPrice
	s tari = obj.PBDTARIDR.%Id()
	s statu = "R"
	s iteminfo = -qty_"^"_unit_"^"_disprice_"^"_insprice_"^"_patprice_"^"_tari_"^"_statu
	s adm = $p(^DHCPB(+pbd),"^",2)
	s oeore = $p(^DHCPB(+pbd,"O",$p(pbd,"||",2)),"^",20)
	s err = ##class(web.DHCIPBillInsExpItm).InsOrdExcExpItm(adm,oeore,iteminfo,user)	
	q err
}

ClassMethod GetPatientBaseInfo(papmi, adm)
{
	;患者信息栏-获取患者基本信息,由基础平台组统一提供
	Quit ##class(web.PAAdm).GetPatientBaseInfo(papmi,adm)
}

/// 获得 给adm下医嘱的医生列表
/// [[rowid,desc],[rowid,desc]]
/// w ##class(web.DHCDocMain).GetDoctorList(77343)
ClassMethod GetDoctorList(adm)
{
	Set langid=..%LanguageID()
	s AllText=..%Translate("doc.surgeryord.hui.csp","全部")
	q:adm="" "[[0,'"_AllText_"']]"
	s orderParref=$o(^OEORD(0,"Adm",adm,0))
	q:+orderParref=0 "[[0,'"_AllText_"']]"
	s orderId=0,rtn=""
	f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
	.q:$d(^OEORD(orderParref,"I",orderId,1))'=1
	.s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	.q:+DoctorDr=0
	.s TDoctor = $p(^CTPCP(DoctorDr,1),"^",2)
	.Set TDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TDoctor,langid)
	.i rtn'="" d	
	..i rtn'[("["_DoctorDr_",") d
	...s rtn = rtn_",["_DoctorDr_",'"_TDoctor_"']"
	.e  d
	..s rtn = "["_DoctorDr_",'"_TDoctor_"']"
	q "[[0,'"_AllText_"'],"_rtn_"]"
}

ClassMethod GetOECStatusChReasonList() As %String
{
	s id=0,rtn=""
	f  s id=$o(^OEC("ASCR",id)) q:id=""  d
	.s text=$p(^OEC("ASCR",id),"^",2)
	.i rtn="" s rtn="["_id_",'"_text_"']"
	.e  s rtn=rtn_",["_id_",'"_text_"']"
	q "["_rtn_"]"
}

Query FindOECStatusChReason(param As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "HIDDEN:%String:ID, ASCRCode:%String:代码, ASCRDesc:%String:描述")
{
SELECT ASCR_RowId, ASCR_Code, ASCR_Desc FROM sqluser.OEC_AdminStatusChReason
 WHERE (ASCR_Code %STARTSWITH :param) OR (ASCR_Desc %STARTSWITH :param)
}

/// PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String
Query FindLocDocCurrentAdm(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "") As websys.Query(ROWSPEC = "EpisodeID:%String")
{
}

ClassMethod FindLocDocCurrentAdmExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "") As %Status
{
	//PatientNo,SurName,CurrentDept,CurrentBed,CurrentWard,CurrentDoctor,StartDate,EndDate,CurrentAdmType
	;Set ^SMLPara=PatientNo_"^"_SurName_"^"_CurrentDept_"^"_CurrentBed_"^"_CurrentWard_"^"_CurrentDoctor_"^"_StartDate_"^"_EndDate_"^"_CurrentAdmType_"^"_MedUnit
	//;
	Set LocID=%session.Get("LOGON.CTLOCID")
	Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	//
	//
	Set repid=$I(^CacheTemp)
 	Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
 	If $g(DocId)="" s qHandle=$lb(0,repid,0) Quit $$$OK
 	Set DocGrp=$P($g(^CTPCP(DocId,3)),"^",1)
	//Set DocId=$p($g(^CTPCP(DocId,1)),"^",1)
	//	
	Set CurrentAdmType="I"
	//
	Kill ^TMP("DHCDocWorkBench",$j)
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	Set Singleflag=0
	//
	If ($g(PatientNo)'="") Do
		.Set Singleflag=1
		.Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
		.Quit:$g(PAPMI)=""
		.Do OutPAPMI
	If ($g(SurName)'="")&($g(PatientNo)="") Do
		.Set Singleflag=1
		.Set name=SurName
		.Set name0=name
		.Set PAPMI=$O(^PAPERi("PAPER_PatName",SurName,""))
		.If PAPMI'="" Do OutPAPMI
		.Set Qflag="N"
		.For  Set name0=$O(^PAPERi("PAPER_PatName",name0)) Quit:(name0="")!(Qflag="Y")  Do
		..If $l(name),$e(name0,1,$l(name))'[name Set Qflag="Y" Quit
		..Set PAPMI=$O(^PAPERi("PAPER_PatName",name0,""))
		..If PAPMI="" Set Qflag="Y" Quit
		..Else  Do OutPAPMI
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit:Singleflag=1 $$$OK
	//
	//全病区病人
	If AllPatient="on"	Do 
	.Do StayInWard
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:AllPatient="on" $$$OK
	//
	//本科病人
	If ArrivedQue="on"	Do 
	.Do DeptPatList
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:ArrivedQue="on" $$$OK
	//
	//;----------------------------------------------------------------------;
	//
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	//Set CurrentDoctor=$g(CurrentDoctor),CurrentWard=$g(CurrentWard),CurrentDept=$g(CurrentDept)
	//if Singleflag=0 Do SetDefaultPara,SetDefaultDate
	//
	//Set CurrentDept=LocID 
	//if ($g(CurrentWard)="")&($g(CurrentDept)'="") Do
	//	.Set DeptLst=$L(CurrentDept,$C(1))
	//	.For I=1:1:DeptLst Do
	//	..Set DeptItem=$P(CurrentDept,$C(1),I)
	//	..Do DeptPatList
	//
	Do DocPatList
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit $$$OK
	//
OutputRow
	Do ResetVariables
	Quit:"A"'=$P(^PAADM(PAAdm),"^",20)	;不是A的不显示
	Set Count=Count+1
	Set Seq=PAAdm
	set Data=$LB(PAAdm)
 	Set ^TMP("DHCDocWorkBench",$j,Seq,Count)=Data
	Quit	
ResetVariables
	///Set (repid)=0
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode)=""
	Quit
StayInWard	
	;wanghc 2012/03/31
	Set LocEmerType=$P($G(^CTLOC(LocID)),"^",13)
	Quit:LocEmerType'="W"	
	Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocID,""))
	Quit:EmerWard=""
	Set WardItem=EmerWard
	If WardItem'="" Do WardPatList
	Quit
StayInWardLoc
	Set WardStr=""
	Set LocLink=""
	For  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
		.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
		.Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
		.;Quit:LocEmerType'="W"
		.Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
		.Quit:EmerWard=""
		.If WardStr="" Set WardStr=EmerWard
		.Else  Set WardStr=WardStr_$C(1)_EmerWard
	If WardStr'="" DO
		.Set WardLst=$L(WardStr,$C(1))
		.For I=1:1:WardLst Do
		..Set WardItem=$P(WardStr,$C(1),I)
		..Do WLDPatList
	Quit
	//
DocPatList
	Set DeptItem=LocID
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Set QuitFlag=0
	...if MedUnit="" d
	....Set PatDoc=$P($g(^PAADM(PAAdm)),"^",9)
	....if PatDoc="" Set QuitFlag=1
	....if PatDoc'=DocId Set QuitFlag=1
	...else  d
	....s AllowFlag=##class(web.DHCDocInPatientList).CheckCTLocMedUnit(PAAdm,DocId,DeptItem,MedUnit)
	....if AllowFlag'="1" Set QuitFlag=1
	...Q:QuitFlag=1
	...Do OutputRow
	Quit
	//
OutPAPMI
	If CurrentAdmType'="" Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Quit:PAAdm=""  Do
	..Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	..Quit:PAAdmStatus'="A"
	..;Quit:PAAdmStatus="P"
	..Quit:##class(web.DHCDocInPatientList).CheckAdmDate(PAAdm,StartDate,EndDate)
	..Do OutputRow
	Quit
DeptPatList
	Set DeptItem=LocID
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	if ($p(^CTLOC(LocID),"^",2)["产房")
	{
	s DeptItem="1"
	For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...s OrderRowId=$O(^OEORD(0,"Adm",PAAdm,""))
	...Q:OrderRowId=""
	...s OEItemRowId="" f  s OEItemRowId=$O(^OEORD(OrderRowId,"I",OEItemRowId)) q:OEItemRowId=""  d
	....//判断是待产医嘱,医嘱是核实并且护士执行状态为未执行
	....s ItmRowId=$p($g(^OEORD(OrderRowId,"I",OEItemRowId,1)),"^",2)
	....s ItmName=$p(^ARCIM(+ItmRowId,$P(ItmRowId,"||",2),1),"^",2)
	....Q:ItmName'["送入产房"
	....s OrderStatusDR=$p(^OEORD(OrderRowId,"I",OEItemRowId,1),"^",13)
	....s OrderStatus=""
	....if OrderStatusDR'="" s OrderStatus=$p(^OEC("OSTAT",OrderStatusDR),"^",1)
	....Q:OrderStatus'="V"
	....s OEExcID="",str=""
	....f  s OEExcID=$O(^OEORD(OrderRowId,"I",OEItemRowId,"X",OEExcID)) q:(OEExcID="")  d
	.....s ctpcpDr=$P(^OEORD(OrderRowId,"I",OEItemRowId,"X",OEExcID),"^",15)
	.....s str=str_ctpcpDr
	....if str'="" quit
	....Do OutputRow
	}else{
	//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Do OutputRow
	}
	Quit
WLDPatList
	Quit:WardItem=""
	Set RoomDr=""
	For RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	..Quit:(PatLoc'=LocID)
	..Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	..Quit:(StartDate'="")&(AdmDate<StartDate)
	..Quit:(EndDate'="")&(AdmDate>EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	.Quit:(PatLoc'=LocID)
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Quit:(StartDate'="")&(AdmDate<StartDate)
	.Quit:(EndDate'="")&(AdmDate>EndDate)
	.Do OutputRow
	Quit
	//
WardPatList
	Set RoomDr=""
	;wanghc add set 2012/4/1 For ->For  set
	For  set RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	..Quit:(StartDate'="")&(AdmDate<StartDate)
	..Quit:(EndDate'="")&(AdmDate>EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Quit:(StartDate'="")&(AdmDate<StartDate)
	.Quit:(EndDate'="")&(AdmDate>EndDate)
	.Do OutputRow
	Quit
SetDefaultPara
	If (StartDate="")&(%request.Get("WIPDateFromToday")="on") Set StartDate=..%SysDate()
	If (StartDate="")&(%request.Get("WIPDtFromOffset")'="") Set StartDate=$ZDH(%request.Get("WIPDtFromOffset"),5)
	//
	If (EndDate="")&(%request.Get("WIPDateToToday")="on") Set EndDate=..%SysDate()
	If (EndDate="")&(%request.Get("WIPDtToOffset")'="") Set EndDate=$ZDH(%request.Get("WIPDtToOffset"),5)
	//
	If $g(CurrentDept)="" Do
	.Set LocStr=%request.Get("WIPLocList")
	.Set Loclen=$L(LocStr,$C(1))
	.For I=1:1:Loclen Do
	..If CurrentDept="" Set CurrentDept=$P($P(LocStr,$C(1),I),$C(2),3)
	..Else  Set CurrentDept=CurrentDept_$C(1)_$P($P(LocStr,$C(1),I),$C(2),3)
	//
	If $g(CurrentDoctor)="" Do
	.Set DocStr=%request.Get("WIPCPList")
	.Set Doclen=$L(DocStr,$C(1))
	.For I=1:1:Doclen Do
	..Set DoctCode=$P($P(DocStr,$C(1),I),$C(2),1)
	..Quit:DoctCode=""
	..Set DocRowId=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(DoctCode),""))
	..Quit:DocRowId=""
	..If CurrentDoctor="" Set CurrentDoctor=DocRowId
	..Else  Set CurrentDoctor=CurrentDoctor_$C(1)_DocRowId
	//
	If $g(CurrentWard)="" Do
	.Set WardStr=%request.Get("WIPWardList")
	.Set Wardlen=$L(WardStr,$C(1))
	.For I=1:1:Wardlen Do
	..If CurrentWard="" Set CurrentWard=$P($P(WardStr,$C(1),I),$C(2),3)
	..Else  Set CurrentWard=CurrentWard_$C(1)_$P($P(WardStr,$C(1),I),$C(2),3)
	//
	If $g(CurrentAdmType)="" Do
	.Set AdmStr=%request.Get("WIPEpisodeTypeList")
	.If $L(AdmStr)>0 Set CurrentAdmType=$E(AdmStr,1)
	Quit
SetDefaultDate
	if StartDate="" Set StartDate=..%SysDate()-6
	If EndDate="" Set EndDate=..%SysDate()
	Quit
}

ClassMethod IsNurseBySessionLoc(LocID)
{
	s ctloctype = $P($G(^CTLOC(LocID)),"^",13)
	q:ctloctype="W" 1
	q 0
}

/// @param : Type 0--当前科室, 1-当前医生
/// d ##class(%ResultSet).RunQuery("web.DHCDocMain","FindDischgAdmProxy",0,36,69,14)
Query FindDischgAdmProxy(Type, LocID, UserID, DisDay = "7") As websys.Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String:登记号,PAPMIName:%String:姓名,PAPMIDOB:%String:出生日期,PAPMISex:%String:性别,PAAdmDate:%String:就诊日期,PAAdmTime:%String:就诊时间,PAAdmNo:%String:就诊号,PAAdmDepCodeDR:%String:就诊科室,PAAdmDocCodeDR:%String:医生,PAAdmType:%String:就诊类型,Hospital:%String:医院,PAAdmWard:%String:病区,PAAdmBed:%String:床号^50,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String:病人类型,DischargeDate:%String:出院日期,RegDoctor:%String:号别,Diagnosis:%String:诊断,ArrivedDate:%String:到达日期,ArrivedTime:%String:到达时间,LeavedDate:%String:离开日期,LeavedTime:%String:离开时间,LocSeqNo:%String:顺序号,PAAdmPriority:%String:优先级,WalkStatus:%String:状态,ConsultRoom:%String:房间,ConsultArea:%String:诊区,PAAdmReasonCode:%String,StatusCode:%String,Age:%String:年龄,PriorityCode:%String,Called:%String,RegDocDr:%String,Deposit:%String:预交金,Amount:%String:费用,Charge:%String:余额,IconProfile:%String:图表菜单,MrNo:%String:病案号,PoliticalLevel:%String:病人级别,SecretLevel:%String:病人密级,ColorDesc:%String:BGColor")
{
}

ClassMethod FindDischgAdmProxyExecute(ByRef qHandle As %Binary, Type, LocID, UserID, DisDay = "7") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s (AllPatient,ArrivedQue,MedUnit,HisPat)=""	
	s ^Tempscl("FindDischgAdmProxy")=Type_","_LocID_","_UserID_","_DisDay
	s LocIDStr=""
	Set isNurse = ..IsNurseBySessionLoc(LocID)
	if (isNurse=1){
			Set LocLink=0
			f  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
			.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
			.i LocIDStr="" s LocIDStr=LocItem
			.e  s LocIDStr=LocIDStr_"^"_LocItem
	}
	i LocIDStr="" s LocIDStr=LocID
	s:Type="" Type=0
	s:DisDay="" DisDay=7
	if (DisDay'=""){
		//出院天数
		Set nowDay = +$h
		For Day = nowDay:-1:(nowDay-DisDay){
			For i=1:1:$l(LocIDStr,"^"){
				s LocID=$p(LocIDStr,"^",i)
				Set PAAdm = $O(^PAADMi("DisDateDep",LocID,Day,""))
				while (PAAdm'=""){
					IF (Type=1){
						Set CurrDocDr = $P($g(^PAADM(PAAdm)),"^",9)
						if CurrDocDr>0{
							Set DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",CurrDocDr,""))
							if (UserID=DoctorUserDr) DO OutputRow
						}
					}ElseIf (Type=0){
						Do OutputRow
					}
					Set PAAdm = $O(^PAADMi("DisDateDep",LocID,Day,PAAdm))
				}
			}
			
		}
	}
	;输出病人列表信息
	s bedind=0 for  s bedind=$o(^||OrderByBed(bedind)) q:bedind=""  d	
	.;q:bedind'[BedNo
	.s subind="" f   s subind=$o(^||OrderByBed(bedind,subind)) q:subind=""  d
	..s ^CacheTemp(repid,ind) = ^||OrderByBed(bedind,subind)
	..s ind=ind+1
	if ($g(BedNo)="") d
	.s subind="" f   s subind=$o(^||OrderByNullBed(subind)) q:subind=""  d
	..s ^CacheTemp(repid,ind) = ^||OrderByNullBed(subind)
	..s ind=ind+1
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
ResetVariables
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,Deposit,Amount,Charge,EmployeeFunction,SecretLevel,ColorDesc)=""
	Quit

OutputRow
	Do ResetVariables
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.;Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Set PAPMIDOB="",PAPMIAge=""
	Set PAPMIAge = ##class(web.DHCDocMainOrderInterface).GetPatientAge(PatientID,PAAdm)
	s PatEncryptLevel="" ;##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s EmployeeFunction=$p(PatEncryptLevel,"^",2)
		s SecretLevel=$p(PatEncryptLevel,"^",1)
	}
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=..%ZD($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=..%ZT($P($g(^PAADM(PAAdm)),"^",7),1)
	//Add Date Check
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^CTLOC(Loc)),"^",2))
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^PAWARD(WardDr)),"^",2))
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed=""
	Set CurrentRoomId=$P($g(^PAADM(PAAdm)),"^",69)
	if CurrentRoomId'="" Set ConsultRoom = $p(^PAROOM(CurrentRoomId),"^",2)
	else  set ConsultRoom=""
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set DischargeDate= $p(##class(web.DHCDocMainOrderInterface).GetDisDateTime(PAAdm),"^") ; $P($g(^PAADM(PAAdm)),"^",17)
	Set:DischargeDate'="" DischargeDate=..%ZD(DischargeDate) //$zd(DischargeDate,3)
	
	If mradm'="" Set Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) 
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	Set Seq=EpisodeID	
	set Deposit=##class(web.UDHCJFBaseCommon).deposit(PAAdm)  //押金
	set Amount=##class(web.UDHCJFCKD).totalamount(PAAdm)      //费用
	set Charge=##class(web.DHCDocOrderCommon).GetCurrentDeposit(PAAdm)   //余额
	set IconProfile="" ;$ZCVT(..ShowIcon("MAP",EpisodeID_"^^^"_PatientID,CONTEXT),"O","HTML")	//加图表菜单
	set MrNo = ##class(web.DHCDocMainOrderInterface).IGetMrNoByEpisodeID(EpisodeID)
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,Deposit,Amount,Charge,IconProfile,MrNo,EmployeeFunction,SecretLevel,ColorDesc)
	i PAAdmBed="" s ^||OrderByNullBed(EpisodeID)=Data
	e  s ^||OrderByBed(" "_PAAdmBed,EpisodeID)=Data
	Quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMain","FindCurrentAdmProxy","0","0000000111","","","O")
Query FindCurrentAdmProxy(Type As %String = 0, PatientNo As %String = "", Name As %String = "", MedicalNo As %String = "", PAADMType As %String = "I", CardNo As %String = "", BedNo As %String = "", Ward As %String = "", DisDay = "", IllType = "", DocID As %String = "", WardGroupLinkBedStr As %String = "", HavedSeeOrdPat As %String = "") As websys.Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String:登记号,PAPMIName:%String:姓名,PAPMIDOB:%String:出生日期,PAPMISex:%String:性别,PAAdmDate:%String:就诊日期,PAAdmTime:%String:就诊时间,PAAdmNo:%String:就诊号,PAAdmDepCodeDR:%String:就诊科室,PAAdmDocCodeDR:%String:医生,PAAdmType:%String:就诊类型,Hospital:%String:医院,PAAdmWard:%String:病区,PAAdmBed:%String:床号^50,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String:病人类型,DischargeDate:%String:出院日期,RegDoctor:%String:号别,Diagnosis:%String:诊断,ArrivedDate:%String:到达日期,ArrivedTime:%String:到达时间,LeavedDate:%String:离开日期,LeavedTime:%String:离开时间,LocSeqNo:%String:顺序号,PAAdmPriority:%String:优先级,WalkStatus:%String:状态,ConsultRoom:%String:房间,ConsultArea:%String:诊区,PAAdmReasonCode:%String,StatusCode:%String,Age:%String:年龄,PriorityCode:%String,Called:%String,RegDocDr:%String,Deposit:%String:预交金,Amount:%String:费用,Charge:%String:余额,IconProfile:%String:图表菜单,MrNo:%String:病案号,PoliticalLevel:%String:病人级别,SecretLevel:%String:病人密级,ColorDesc:%String:BGColor,ResidentDays:%String:就诊天数,PAADMMotherAdmDR:%String:母亲就诊ID")
{
}

ClassMethod FindCurrentAdmProxyExecute(ByRef qHandle As %Binary, Type As %String = 0, PatientNo As %String = "", Name As %String = "", MedicalNo As %String = "", PAADMType As %String = "I", CardNo As %String = "", BedNo As %String = "", Ward As %String = "", DisDay = "", IllType = "", DocID As %String = "", WardGroupLinkBedStr As %String = "", HavedSeeOrdPat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s (AllPatient,ArrivedQue,MedUnit,HisPat)=""	
	;病危人数, 病重人数,新入院人数,一级护理
	s (CCount,SCount,FCount,FCCount,BabyNum)=0
	s LocID=%session.Get("LOGON.CTLOCID")
	s wardID=%session.Get("LOGON.WARDID") 
	s groupID=%session.Get("LOGON.GROUPID") 
	s UserID = %session.Get("LOGON.USERID")
	s LogonHospId=%session.Get("LOGON.HOSPID")
	S CONTEXT = $g(%session.Data("CONTEXT"))
	Set job = $g(%session.Data("LOGON.SSUSERLOGINID"))
	k ^Temp("PatIllTypeCountInfo",job) 
	s:Type="" Type=0
	s LocIDStr=""
    if (DisDay'=""){
	    Set isNurse = ..IsNurseBySessionLoc(LocID)
	    if (isNurse=1){
			Set LocLink=0
			f  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
			.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
			.i LocIDStr="" s LocIDStr=LocItem
			.e  s LocIDStr=LocIDStr_"^"_LocItem
	    }
	}
	i LocIDStr="" s LocIDStr=LocID
	D ##class(web.DHCDocMainOrderInterface).GetIllLevelColor(.ColorList)
	k ^||OrderByBed,^||OrderByNullBed
	if ((PatientNo="") && (Name="") && (MedicalNo="") && (CardNo="") &&(Ward="") &&(DisDay="")){
		s isNurse = ..isNurseLogin()
		if (isNurse){
			i Type=0 s AllPatient="on"		;病区
			i Type=1 s HisPat="on"			;曾转科的在院病人			
		}else{
			i Type=0 						;本人病人
			i Type=1 s ArrivedQue="on"		;本科室病人
			i Type=2 s MedUnit="on"			;本单元病人
			i Type=3 s HisPat="on"			;曾转科的在院病人
		}
		if (HisPat=""){
			#dim rs As %ResultSet
			if (isNurse){
				s rs = 	##class(%ResultSet).%New("web.DHCDocMain:FindLocDocCurrentAdm")
			}else{
				if (PAADMType="O"){
					s rs = ##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
				}else{
					s rs = ##class(%ResultSet).%New("web.DHCDocInPatientList:FindLocDocCurrentAdm")
				}
			}
			//LocID,UserID,IPAddress , AllPatient , PatientNo , SurName , StartDate  , EndDate  , ArrivedQue  , RegQue , MedUnit
			//LocID , UserID , IPAddress , AllPatient , PatientNo , SurName , StartDate , EndDate , ArrivedQue, RegQue, Consultation
			d rs.Execute("","","",AllPatient,"","","","",ArrivedQue,"",MedUnit)
			while(rs.Next()){
				s PAAdm = rs.GetDataByName("EpisodeID")
				d OutputRow
			}
			d rs.%Close()
			s rs = ""
		}else{	//;曾转科的在院病人
			s admrowid=0 f  s admrowid=$o(^PAADMi("AdmTypeCurr","I",admrowid)) q:admrowid=""  d
			.q:$p(^PAADM(admrowid),"^",20)'="A"	 ;VisitStatus
			.s PAPMI = $p(^PAADM(admrowid),"^",1)
			.S:$d(^PAPER(PAPMI,"PAT",1)) PatientNo=$P(^PAPER(PAPMI,"PAT",1),"^",1)
			.i isNurse d
			..s WardID = $O(^PAWARD(0,"WARD_LocationDR",LocID,""))
			..i $d(^PAPER(PAPMI,"PAT",1)),$$findAdmTransWard(admrowid,WardID),$p(^PAADM(admrowid),"^",70)'=WardID d
			...s PAAdm=admrowid
			...d OutputRow
			.e  i $d(^PAPER(PAPMI,"PAT",1)),$d(^PAADMi("TransLoc",admrowid,LocID)),$p(^PAADM(admrowid),"^",4)'=LocID d
			..s PAAdm=admrowid
			..d OutputRow

		}
	}else{	
		if (PatientNo'=""){
			//登记号查询
			Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
			if $g(PAPMI)="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
			Set PAAdm="", CurrentAdmType=PAADMType
			For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Quit:PAAdm=""  Do
			.d OutputRow
		}Elseif (MedicalNo'=""){
			Set PAPMI="", CurrentAdmType=PAADMType
			;Set PAPMI = ##Class(web.DHCWMRService).IGetPatientIDByMrNo(MedicalNo)
			For  Set PAPMI = $O(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(MedicalNo),PAPMI)) Q:PAPMI=""  Do
			.Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
			..d OutputRow
		}ELSEIF (Name'=""){
			Set PAPMI="", CurrentAdmType=PAADMType
			For  Set PAPMI = $O(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(Name),PAPMI)) Q:PAPMI=""  Do
			.Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
			..d OutputRow
		}ELSEIF (CardNo'=""){
			Set CFRowID="", PAPMI="", CurrentAdmType=PAADMType
			Set CFRowID = $o(^DHCCARDi("CF",0,"CardNo",$$ALPHAUP^SSUTIL4(CardNo),CFRowID))
			if (CFRowID'=""){
				Set ActiveFlag = $p(^DHCCARD("CF",CFRowID),"^",10)
				if ("N"=ActiveFlag){
					Set PAPMI = $p(^DHCCARD("CF",CFRowID),"^",4)
					Set PAAdm="" For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Q:PAAdm=""  Do
					.d OutputRow
				}
			}
		}ELSEIF (Ward'=""){
			if DisDay="" d
			.set RoomDr=0
			.for  Set RoomDr = $o(^PAADMi("CurrWard",Ward,RoomDr)) q:RoomDr=""  Do
			..set PAAdm=0
			..for  set PAAdm=$o(^PAADMi("CurrWard",Ward,RoomDr,PAAdm)) q:PAAdm=""  do
			...d OutputRow
			e  d
			.Set nowDay = +$h
			.For Day = nowDay:-1:(nowDay-DisDay) d
			..For i=1:1:$l(LocIDStr,"^") d 
			...s LocID1=$p(LocIDStr,"^",i)
			...s PAAdm=0
			...f  s PAAdm=$o(^PAADMi("DisDateDep",LocID1,Day,PAAdm)) q:PAAdm=""  d
			....Set CurrDocDr = $P($g(^PAADM(PAAdm)),"^",9)
			....Set DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",CurrDocDr,""))
			....Set TempWardDr=$P($g(^PAADM(PAAdm)),"^",70)
			....q:(UserID'=DoctorUserDr)&&(Type=1)
			....q:(TempWardDr'=Ward)&&(Ward'="")
			....DO OutputRow
		}ELSEIF (DisDay'=""){ //出院天数
		   //出院天数
			Set nowDay = +$h
			For Day = nowDay:-1:(nowDay-DisDay){
				For i=1:1:$l(LocIDStr,"^"){
					s LocID1=$p(LocIDStr,"^",i)
					Set PAAdm = $O(^PAADMi("DisDateDep",LocID1,Day,""))
					while (PAAdm'=""){
						if (Type=1){ //本科
							Set CurrDocDr = $P($g(^PAADM(PAAdm)),"^",9)
						    if CurrDocDr>0{
							    Set DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",CurrDocDr,""))
								if (UserID=DoctorUserDr) DO OutputRow
						    }
						    
						}elseif (Type=0){ //本人
						  Do OutputRow
					    }elseif (Type=2){ //本单元
						    Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
						    Set MedUnit="on"
						    Set AllowFlag=##class(web.DHCDocInPatientList).CheckCTLocMedUnit(PAAdm,DocId,LocID,MedUnit)
					        if AllowFlag="1"{
						        DO OutputRow
						    }
						}
						Set PAAdm = $O(^PAADMi("DisDateDep",LocID1,Day,PAAdm))
					}
				}
				
			}
		
		    
			/*Set nowDay = +$h
			For Day = nowDay:-1:(nowDay-DisDay){
				Set PAAdm = $O(^PAADMi("DisDateDep",LocID,Day,""))
				while (PAAdm'=""){
					Set CurrDocDr = $P($g(^PAADM(PAAdm)),"^",9)
					Set DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",CurrDocDr,""))
					IF (UserID=DoctorUserDr){
						DO OutputRow
					}
					Set PAAdm = $O(^PAADMi("DisDateDep",LocID,Day,PAAdm))
				}
				
			}*/
		}
		
	}
	;输出病人列表信息
	s bedind=0 for  s bedind=$o(^||OrderByBed(bedind)) q:bedind=""  d	
	.q:bedind'[BedNo
	.s subind="" f   s subind=$o(^||OrderByBed(bedind,subind)) q:subind=""  d
	..s ^CacheTemp(repid,ind) = ^||OrderByBed(bedind,subind)
	..s EpisodeID=$list(^||OrderByBed(bedind,subind),2)
	..s PAADMMotherAdmDR=$p(^PAADM(EpisodeID),"^",75)
	..i PAADMMotherAdmDR'="" s BabyNum=BabyNum+1
	..s ind=ind+1
	if (BedNo="") d
	.s subind="" f   s subind=$o(^||OrderByNullBed(subind)) q:subind=""  d
	..s ^CacheTemp(repid,ind) = ^||OrderByNullBed(subind)
	..s EpisodeID=$list(^||OrderByNullBed(subind),2)
	..s PAADMMotherAdmDR=$p(^PAADM(EpisodeID),"^",75)
	..i PAADMMotherAdmDR'="" s BabyNum=BabyNum+1
	..s ind=ind+1
	Set jsonObj = ##class(ext.util.JsonObject).%New()
	Set jsonStr = jsonObj.Put("FCount",FCount).Put("SCount",SCount).Put("CCount",CCount).Put("FCCount",FCCount).Put("BabyNum",BabyNum).Json()  
	Set ^Temp("PatIllTypeCountInfo",job) = jsonStr
	Do jsonObj.Clear()
	Set jsonObj = ""
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
findAdmTransWard(PAAdm,WardID)
	s find=0
	s child=0 f {
		s child=$O(^PAADM(PAAdm,"TRANS",child))
		Q:child=""
		s TransWardID=$P(^PAADM(PAAdm,"TRANS",child),"^",9)
		if TransWardID=WardID {
			s find=1
			Quit
		}
	}
	Q find
ResetVariables
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,Deposit,Amount,Charge,EmployeeFunction,SecretLevel,ColorDesc)=""
	Quit

OutputRow
	Do ResetVariables
	q:(HavedSeeOrdPat="on")&&(##class(Nur.IP.NurseExcute).ifExitNeedSeeOrder(PAAdm,wardID,LocID,groupID,"DefaultSee")'=1)
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.;Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Set PAPMIDOB="",PAPMIAge=""
	Set PAPMIAge = ##class(web.DHCDocMainOrderInterface).GetPatientAge(PatientID,PAAdm)
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s EmployeeFunction=$p(PatEncryptLevel,"^",2)
		s SecretLevel=$p(PatEncryptLevel,"^",1)
	}
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	/*s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(PAAdm)
	s PAAdmDate=$P(admDateTime,",",1)
	s PAAdmTime=$P(admDateTime,",",2)
	if (PAAdmDate=""){*/
		s PAAdmDate=$P($g(^PAADM(PAAdm)),"^",6)
		s PAAdmTime=$P($g(^PAADM(PAAdm)),"^",7)
	//}
	Set PAAdmDate=..%ZD(PAAdmDate) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=..%ZT(PAAdmTime,2)
	//Add Date Check
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^CTLOC(Loc)),"^",2))
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	q:(DocID'="")&&(DocID'=Doctor)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	q:(LogonHospId'="")&&(Hosp'=LogonHospId)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^PAWARD(WardDr)),"^",2))
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	Q:(WardGroupLinkBedStr'="")&&(($c(1)_WardGroupLinkBedStr_$c(1))'[($c(1)_BedId_$c(1)))
	;本科转出病人列表
	;显示病人在本科(或病区)时所在床号
    	/*Set HisPatWardBedId="",HisPatLocBedId="",IsSameLocFlag=0
    	s SessionWardID = $O(^PAWARD(0,"WARD_LocationDR",LocID,""))
   	 s chl="" f  s chl=$o(^PAADM(PAAdm,"TRANS",chl)) q:chl=""  d
    	.s CurrentBedDRTMP=$p(^PAADM(PAAdm,"TRANS",chl),"^",8)
    	.s TranWardDr = $p(^PAADM(PAAdm,"TRANS",chl),"^",9)
	.s TranLocDr = $p(^PAADM(PAAdm,"TRANS",chl),"^",6)
	.if isNurse&&(TranWardDr=SessionWardID) Set HisPatWardBedId = CurrentBedDRTMP
	.if 'isNurse D
	..if IsSameLocFlag&&(TranLocDr'="")&&(TranLocDr'=LocID) Set chl = $o(^PAADM(PAAdm,"TRANS",""),-1)
	..i (TranLocDr=LocID)||(TranLocDr="") set IsSameLocFlag =1
	..e  set IsSameLocFlag=0
	..Set:(IsSameLocFlag=1)&&(CurrentBedDRTMP'="") HisPatLocBedId = CurrentBedDRTMP
   
	if HisPat="on" d
	.i isNurse d
	..s BedId=HisPatWardBedId
	.e  d
	..s BedId=HisPatLocBedId*/
        if HisPat="on" set BedId=""
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed=""
	 
	Set CurrentRoomId=$P($g(^PAADM(PAAdm)),"^",69)
	if CurrentRoomId'="" Set ConsultRoom = $p(^PAROOM(CurrentRoomId),"^",2)
	else  set ConsultRoom=""
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set DischargeDate= $p(##class(web.DHCDocMainOrderInterface).GetDisDateTime(PAAdm),"^") ; $P($g(^PAADM(PAAdm)),"^",17)
	/*Set CurrDocDr = $P($g(^PAADM(PAAdm)),"^",9)
    Set DoctorUserDr=""
    if (CurrDocDr'="") Set DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",CurrDocDr,""))
	Q:(+DisDay'="0")&&(UserID=DoctorUserDr)
	s nowDay=..%SysDate()
	Q:(+DisDay'="0")&&((DischargeDate>nowDay)||(DischargeDate<(nowDay-DisDay)))*/
	Set:DischargeDate'="" DischargeDate=..%ZD(DischargeDate) //$zd(DischargeDate,3)
	
	If mradm'="" Set Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) 
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	Set Seq=EpisodeID	
	set Deposit=##class(web.UDHCJFBaseCommon).deposit(PAAdm)  //押金
	set Amount=##class(web.UDHCJFCKD).totalamount(PAAdm)      //费用
	set Charge=##class(web.DHCDocOrderCommon).GetCurrentDeposit(PAAdm)   //余额
	set IconProfile=$ZCVT(..ShowIcon("MAP",EpisodeID_"^^^"_PatientID,CONTEXT),"O","HTML")	//加图表菜单
	set MrNo = ##class(web.DHCDocMainOrderInterface).IGetMrNoByEpisodeID(EpisodeID)
	Set ColorDesc = ""
	Set DateFormat=##class(websys.Conversions).DateFormat()
	Set FIll = ($zdh(PAAdmDate,DateFormat)=..%SysDate())  ;当天入院 First day ill 
	Set SIll = ##class(web.DHCDocMainOrderInterface).IsSeriouslyIll(EpisodeID) ;病重患者
	Set CIll = ##class(web.DHCDocMainOrderInterface).IsCriticallyIll(EpisodeID) ;病危患者
	Set FCIll = ##class(web.DHCDocMainOrderInterface).IsFirstClsCare(EpisodeID)
	If (FIll){
		Set ColorDesc = ColorList("F")
		Set FCount = FCount+1
	}elseif(CIll){
		Set ColorDesc = ColorList("C")  
		Set CCount = CCount+1
	}elseif(SIll){
		Set ColorDesc = ColorList("S")   
		Set SCount = SCount+1
	}elseif(FCIll){
		//;一级护理颜色不变
		//Set ColorDesc = ColorList("FC") ;有一级护理医嘱
		//Set FCCount = FCCount+1
	}/*elseif(PAAdmStatus="D"){
		Set PAAdmBed="已出院"
		;Set ColorDesc = "#60f807" ;出院---医疗结算或最终结算,走护士站配置
	}*/
	if (PAAdmStatus="D"){
		Set PAAdmBed="已出院"
		;Set ColorDesc = "#60f807" ;出院---医疗结算或最终结算,走护士站配置
	}
	Quit:(IllType="F")&&('FIll)
	Quit:(IllType="S")&&('SIll)
	Quit:(IllType="C")&&('CIll)
	s PAADMMotherAdmDR=$p(^PAADM(EpisodeID),"^",75)
	s admInfo=##Class(web.DHCIPBillCheckAdmFee).GetAdmBedInfo(EpisodeID) 
	s ResidentDays=$p(admInfo,"^",12)
	//s ResidentDays=##Class(EMRservice.DAL.GetPaAdmDetail).ResidentDaysAdm(EpisodeID)
	i ResidentDays'="" s ResidentDays=ResidentDays_"天"
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,Deposit,Amount,Charge,IconProfile,MrNo,EmployeeFunction,SecretLevel,ColorDesc,ResidentDays,PAADMMotherAdmDR)
	i PAAdmBed="" s ^||OrderByNullBed(EpisodeID)=Data
	e  s ^||OrderByBed(" "_PAAdmBed,EpisodeID)=Data
	Quit
}

ClassMethod getPrintInfo(oeordItemID)
{
	S oeord = +oeordItemID
	s oeordsub = $p(oeordItemID,"||",2)
	s oecPriority = $p(^OEORD(oeord,"I",oeordsub,1),"^",8)
	s pageInfo="^"
	i $d(^DHCLOGSHORTORD("longord",oeordItemID)) d
	.s pageInfo = $p(^DHCLOGSHORTORD("longord",oeordItemID),"^",5,6)
	i $d(^DHCLOGSHORTORD("lsord",oeordItemID)) d
	.s pageInfo = $p(^DHCLOGSHORTORD("lsord",oeordItemID),"^",5,6)
	q pageInfo
}

ClassMethod OrderInfo(oeori)
{
	if $d(%request){
		Set qLimit = $g(%request.Data("limit",1))
		Set qStart = $g(%request.Data("start",1))
		Set ^||qCount = $g(^||qCount) + 1
		//Q:(^||qCount<=qStart) $lb()   //注释掉，会影响排序
		//Q:(^||qCount>(qStart+qLimit)) $lb()
	}
	s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopTime,TStopDoctor,str1,str2,str3,TItemStatCode,oeorioeoridr,DoctorUserDr,TStopNurse,TdeptDesc,TRecDepDesc,TPermission,TDuratDesc1,TBillUom) = ""
	s sessionUserId=%session.Data("LOGON.USERID")
	s sessionLocId=%session.Data("LOGON.CTLOCID")
	s sessionGroupId=%session.Data("LOGON.GROUPID")
	s space = "&nbsp&nbsp",tab = "" //space_space_space_space
	s orderParref=+oeori,orderId=$p(oeori,"||",2)
	s instrDesc1="",PHFreqDesc1="",depProcNotes="",doseQty=""
	s str2 = $g(^OEORD(orderParref,"I",orderId,2))
	s doseQty = $p(str2,"^",1)	;用量 OEORI_DoseQty		
	s doseUnitDr= $p(str2,"^",3)	;剂量单位 OEORI_Unit_DR
	s doseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(doseUnitDr)
	s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
	s:+instrDr'=0 instrDesc1=$p(^PHCIN(instrDr),"^",2)
	s PHFreqDr = $p(str2,"^",4)	;频次 OEORI_PHFreq_DR
	s:PHFreqDr PHFreqDesc1 = $p(^PHCFR(PHFreqDr),"^",3)
	s:PHFreqDr PHFreqCode = $p(^PHCFR(PHFreqDr),"^",1)
	s depProcNotes = ""  ;备注 OEORI_DepProcNotes
	s depProcNotesIndex = 0
	f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
	.s depProcNotes = depProcNotes_" "_^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
	s str1=^OEORD(orderParref,"I",orderId,1)
	s:$d(^OEORD(orderParref,"I",orderId,2)) str2=^OEORD(orderParref,"I",orderId,2)
	s:$d(^OEORD(orderParref,"I",orderId,3)) str3=^OEORD(orderParref,"I",orderId,3)
	;s ordDept = $p(str1,"^",3)
	s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
	s:+ordDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(ordDept)
	s:str3'="" TRecDepDR = $p(str3,"^",6)
	s:+TRecDepDR>0 TRecDepDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(TRecDepDR)
	s ItmMastDR = $p(str1,"^",2)
	s TOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	s PriorityDR = $p(str1,"^",8)
	s PriorityCode = $p(^OECPR(PriorityDR),"^",1)
	s priorityTip =  $case(PriorityCode,"OMST":$p(^OECPR(PriorityDR),"^",2),"OMCQZT":$p(^OECPR(PriorityDR),"^",2),:"")
	s TDuratDR="" 
	s:str2'="" TDuratDR = $p(str2,"^",6) 
	s:TDuratDR'="" TDuratDesc1 = $p(^PHCDU(TDuratDR),"^",3)	
	if ##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR) s TDuratDesc1=""  
	s OrdItemCallback=##class(web.DHCDocMainOrderInterface).IsCallbackOrder(orderParref,orderId)
	s OrdItemCallback=$case(OrdItemCallback,1:"<font color=red>(退回)</font>",:"")
	s OrdNurseCallback = ##class(web.DHCDocMainOrderInterface).IsNurseCallbackOrder(orderParref,orderId)
	s OrdNurseCallback = $case(+OrdNurseCallback,1:"<font color=red>(护士退回)</font>",:"")
	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(orderParref_"||"_orderId)
	s oeorioeoridr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	s TStDate=$p(str1,"^",9)
	s FirstDayTimes=$P(str1,"^",18)
	s FirstDayTimesDesc=""
	if (TStDate>=..%SysDate())&&(FirstDayTimes'="")&&(oeorioeoridr=""){
		s FirstDayTimesDesc="首日:"_FirstDayTimes
	}
	s TOrderDesc=TOrderDesc_space_doseQty_doseUOM_space_instrDesc1_space_PHFreqDesc1_space_TDuratDesc1_space_depProcNotes_space_priorityTip_space_FirstDayTimesDesc_space_OrdItemCallback_space_OrdNurseCallback_ReqPartDesc    //_space_OrdItemCallback
	i $d(^OEORD(orderParref,"I",orderId,1))=1 s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	s:+$g(DoctorDr)>0 TDoctor = $p(^CTPCP(DoctorDr,1),"^",2),DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
	
	s TStDate = ..%ZD($p(str1,"^",9)) //$zd($p(str1,"^",9),3)
	s TStTime = ..%ZT($p(str1,"^",10),2)
	
	s TStopDate = $p(^OEORD(orderParref,"I",orderId,3),"^",34)		;XDate
	s:$d(^OEORD(orderParref,"I",orderId,2)) TStopTime = $p(^OEORD(orderParref,"I",orderId,2),"^",15)		;XTime
	s TExEndDate = $p(^OEORD(orderParref,"I",orderId,9),"^",9)		;OEORI_EndDate	
	s TExEndTime = $p(^OEORD(orderParref,"I",orderId,9),"^",10) 	;OEORI_EndTime
	s TStopDate = $s(TStopDate="":TExEndDate, 1:TStopDate)			;没停止日期时,取预停日期	
	s TStopTime = $s(TStopTime="":TExEndTime, 1:TStopTime)
	
	s:TStopDate'="" TStopDate=..%ZD(TStopDate) //$zd(TStopDate,3)
	s:TStopTime'="" TStopTime=..%ZT(TStopTime,2) 
	s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
	s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	
	s userUpdateDr=$p($g(^OEORD(orderParref,"I",orderId,8)),"^",12)
	s:(+userUpdateDr>0)&&(TExEndDate'="") TStopDoctor = $p(^SSU("SSUSR",userUpdateDr),"^",2)	;预停医生
	s StopDoctorDR = $p(^OEORD(orderParref,"I",orderId,3),"^",29)
	s:+StopDoctorDR>0 TStopDoctor = $p(^CTPCP(StopDoctorDR,1),"^",2)	;重新覆盖停医嘱医生
	s TStDateHide=TStDate,TStTimeHide=TStTime
	s:+oeorioeoridr>0 TOrderDesc = tab_TOrderDesc,TStDate="",TStTime=""
	s TBillUom = ##class(web.DHCDocMainOrderInterface).GetBillUom(+ItmMastDR,$p(ItmMastDR,"||",2))
	s TStopNurse = ##class(web.DHCDocMainOrderInterface).GetXOrderNurseName(orderParref,orderId)
	s PriorityId=$p(^OEORD(orderParref,"I",orderId,1),"^",8)
	s PriorityDesc=$p(^OECPR(PriorityId),"^",2)
	s OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	s OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"<font color=red>急</font>",:"")
	s TOrderDesc = TOrderDesc_"&nbsp"_OEORINotifyClinician
	s StopPermission=..CheckStopOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s CancelPermission=..CheckCancelOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s UnusePermission = ..CheckUnuseOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	q $lb(orderParref_"||"_orderId,TItemStatCode,oeorioeoridr,PHFreqCode,TPermission,0,TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopTime,TStopDoctor,TStopNurse,TdeptDesc,TRecDepDesc,orderParref_"||"_orderId,StopPermission,CancelPermission,UnusePermission,TBillUom,"",OrderType,TStDateHide,TStTimeHide,PriorityDesc)
}

/// 拿频次与分发次数
ClassMethod GetPHFreqInfo(oeori)
{
	s rtn=""
	Set langid=..%LanguageID()
	s str2 = $g(^OEORD(+oeori,"I",$p(oeori,"||",2),2))	
	s PHFreqDr = $p(str2,"^",4)						;频次 OEORI_PHFreq_DR
	q:PHFreqDr="" rtn
	s PHFreqDesc1 = $p(^PHCFR(PHFreqDr),"^",3)
	s PHFreqDesc1=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",PHFreqDesc1,langid)
	s FreqDispTime = ##class(web.DHCDocMainOrderInterface).GetIPFreqDispTimeStr(PHFreqDr)
	s len = $l(FreqDispTime,",")	
	f i=2:1:$SYSTEM.SQL.CEILING(len/6)	{
		s $p(FreqDispTime,",",i*6-5) = "<br>"_$p(FreqDispTime,",",i*6-5)
	} 
	s FreeTimeFreqFlag=$P(^PHCFR(PHFreqDr),"^",13)
	s WeekFlag=$P(^PHCFR(PHFreqDr),"^",9)
	i (WeekFlag="Y")||(FreeTimeFreqFlag="Y") {
		s OrderFreqWeek=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",55)
		s OrderFreqFreeTimeStr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",68)
		s OrderFreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrderFreqDispTimeStr(PHFreqDr,OrderFreqWeek,OrderFreqFreeTimeStr)
		//理论上不允许出现为空的情况
		if (OrderFreqDispTimeStr'=""){
			s OrderFreqOtherInfo=##Class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(PHFreqDr,OrderFreqDispTimeStr)
			s FreqDispTime=OrderFreqOtherInfo
		}
	}
	q PHFreqDesc1_" "_FreqDispTime
}

/// 判断哪些病人能操作
/// 
/// 1 出院的
/// 2 医疗结算
/// 3 最终结算
/// 4 财务结算
/// 5 不是V7病人
/// w ##class(web.DHCDocMain).isHiddenMenu(1258,1)
ClassMethod isHiddenMenu(adm, ctloc)
{
	s statu = $p(^PAADM(adm),"^",20) ;PAADM_VisitStatus
	if statu'="A" {
		//最终结算后,调整费用,---医生可以做相关操作 
		Set flag = ##class(web.DHCDocMainOrderInterface).HiddenMenuFlag(adm)
		q:(flag="2.5") 0
		Q:statu="P" 0
		q 1
	}
	q:..isFinDischg(adm) 4
	q:..isDischg(adm) 3
	q:..isEstDisch(adm) 2
	;q:'..isV7Episode(adm) 5
	q 0
}

/// 是否医疗结算
ClassMethod isEstDisch(adm)
{
	s EstDischConfirmed=$p($g(^PAADM(adm,2)),"^",25) ;59--EstDisDate
	s EstimDischargeDate=$p($g(^PAADM(adm)),"^",59)
	q:(EstDischConfirmed="Y")&&(EstimDischargeDate<=..%SysDate()) 1
	q 0
}

/// 是否最终结算
ClassMethod isDischg(adm)
{
	s DischgDate=$p(^PAADM(adm),"^",17) ;PAADM_DischgDate
	q:DischgDate'="" 1
	q 0
}

/// 是否财务结算
ClassMethod isFinDischg(adm)
{
	s FinDischDate=	$p($g(^PAADM(adm,3)),"^",3)	;PAADM_FinDischDate
	q:FinDischDate'="" 1
	q 0
}

ClassMethod isV7Episode(adm)
{
	s isV7=$g(^PAADM(adm,"VER"))
	q:isV7="7" 1
	q 0
}

/// 执行记录能不能 停止 执行 撤销
/// 0 允许, 1 不允许
/// 医嘱子类为药物的子医嘱不能执行
ClassMethod CheckOperationPermission(oeori)
{
	i $l(oeori,"||")=3 s oeori=$p(oeori,"||",1,2)
	s oeord=+oeori
	s oeordsub = $p(oeori,"||",2)
	s itmMastDR = $p(^OEORD(oeord,"I",oeordsub,1),"^",2)
	s oeoriOeoriDR=""
	s:$d(^OEORD(oeord,"I",oeordsub,11)) oeoriOeoriDR = $p(^OEORD(oeord,"I",oeordsub,11),"^",39)
	s ItemCat = $p(^ARCIM(+itmMastDR,$p(itmMastDR,"||",2),1),"^",10)
	s type = $p(^ARC("IC",ItemCat),"^",7)
	q:(type="R")&&(oeoriOeoriDR'="") 1
	q 0
}

// w ##class(web.DHCDocMain).ShowIcon("","13^^^6","")

ClassMethod ShowIcon(code As %String, val As %String, context As %String = "", OnlyCurrentPage As %String = 0) [ ProcedureBlock = 0 ]
{
	;Set ^Wanghc("showicon",1)=$i(^Wanghc("showicon"))
	n (code,val,context,%request,%session)
	if $G(OnlyCurrentPage),$d(%request.Data("page")),$d(%request.Data("rows")){
		s page = $g(%request.Data("page",1),1)
		s rows = $g(%request.Data("rows",1),15)
		//Set ^Wanghc("showicon")=page_","_rows
		Set ^||IconRows = $I(^||IconRows)
		if ^||IconRows<(((page-1)*rows)+1) Q ""
		if ^||IconRows>(page*rows) Q ""	
	}
	Q:val="" ""
	Quit ##class(epr.CTIconProfile).ShowIcon(code,val,context)
}

/// @ params : 传入医嘱Rowid, 医嘱类型Rowid,登录用户UserID
/// @ params : 返回copy串
/// w ##Class(web.DHCDocMain).CreateCopyItem("6153||86","","17473","N")
ClassMethod CreateCopyItem(oeori As %String, InOrderPriorRowid As %String, UserID As %String = "", ExtStr As %String = "")
{
	q:oeori="" ""
	s VirtualtLongFlag=$P(ExtStr,"^",1)
	Set langid=..%LanguageID()
	s ch1 = $char(1)
	s (OrderName,OrderSeqNo,OrderDoseQty,OrderDoseUOM,OrderDoseUOMRowid)=""
	s (OrderFreq,OrderFreqRowid,OrderFreqFactor,OrderFreqInterval)=""
	s (OrderInstr,OrderInstrRowid,OrderDur,OrderDurRowid,OrderDurFactor)=""
	s (OrderPackQty,OrderPackUOM,OrderPackUOMRowid,OrderPrior,OrderPriorRowid)=""
	s (OrderType,OrderBillTypeRowId,OrderResume,DoseQtySum)=""
	;
	&sql(SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,
		OEORI_SttDat,OEORI_SttTim,Todate(OEORI_SttDat,'yyyy-mm-dd'),
		OEORI_DoseQty,OEORI_Unit_DR,OEORI_Unit_DR->CTUOM_Desc,
		OEORI_QtyPackUOM,
		OEORI_Priority_dr,OEORI_Priority_dr->OECPR_Desc,
		OEORI_Itemstat_dr,OEORI_Itemstat_dr->OSTAT_Desc,
		OEORI_PHFreq_DR,OEORI_PHFreq_DR->PHCFR_Desc1,
		OEORI_Instr_DR,OEORI_Instr_DR->PHCIN_Desc1,
		OEORI_Durat_DR,OEORI_Durat_DR->PHCDU_Desc1,
		OEORI_RecDep_DR,OEORI_RecDep_DR->CTLOC_Desc,
		OEORI_UserDepartment_DR,OEORI_UserDepartment_DR->CTLOC_Desc,
		OEORI_Doctor_DR,OEORI_Doctor_DR->CTPCP_Desc,OEORI_UserAdd,OEORI_UserAdd->SSUSR_Name,
		OEORI_Billed,OEORI_AdministerSkinTest,OEORI_BBExtCode,
		OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
		OEORI_SeqNo,OEORI_LinkNo,OEORI_LinkToOrder,OEORI_PrescNo,OEORI_LabEpisodeNo,
		OEORI_ARCOS_DR,OEORI_OEORI_DR,Todate(OEORI_Date,'yyyy-mm-dd'),
		OEORI_OrdDept_DR,OEORI_OrdDept_DR->CTLOC_Desc,OEORI_PhQtyOrd,
		OEORI_Action_DR,OEORI_Action_DR->ACT_Desc
	 INTO :OrderItemRowid,:ARCIMRowid,:OrderName,:OrderSttDate,:OrderSttTime,:StartDate,
		:OrderDoseQty,:OrderDoseUOMRowid,:OrderDoseUOM,:OrderPackQty,
		:OrderPriorRowid,:OrderPrior,:OrderStatusRowid,:OrderStatus,:OrderFreqRowid,:OrderFreq,
		:OrderInstrRowid,:OrderInstr,:OrderDurRowid,:OrderDur,
		:OrderRecDepRowid,:OrderRecDep,:OrderUserDepRowid,:OrderUserDep,
		:OrderDocRowid,:OrderDoc,:OrderUserAddRowid,:OrderUserAdd,
		:OrderBilled,:OrderSkinTest,:OrderBillTypeRowid,:OrderType,
		:OrderSeqNo,:OrderMasterSeqNo,:OrderLinkTo,:OrderPrescNo,:OrderLabEpisodeNo,
		:OrderARCOSRowid,:LinkOrderItem,:OrderDate,
		:OrderOrdDepRowid,:OrderOrdDep,:DoseQtySum,
		:OrderActionRowid,:OrderAction
	 From SQLUser.OE_OrdItem WHERE OEORI_Rowid=:oeori)
	if (InOrderPriorRowid="") s InOrderPriorRowid=OrderPriorRowid
	s OrderPackQty=##class(web.DHCDocOrderView).formateNum(OrderPackQty)
	s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(oeori)
	s OrderPackUOM=""
	i OrderPackUOMRowid'="" d
	. s OrderPackUOM=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
	. s OrderPackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderPackUOM,langid)
	s OrderDoseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderDoseUOM,langid)
 	if OrderFreqRowid'="" {
		s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2)
		s OrderFreqInterval=$P($g(^PHCFR(OrderFreqRowid)),"^",5)
 	}
 	s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	if (OrderType'="R"){
		Q:(InOrderPriorRowid=$O(^OECPR(0,"Code","OUT",0))) ""
		s OrderPackQty=DoseQtySum
	}
	if (##class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowid)=1){
		s ReqPartId=##Class(DHCDoc.OPDoc.CopyOrderItemList).GetReqPartID(oeori)
	}else{
		s ReqPartId=""
	}
 	//系统带出来的医嘱不能复制
 	if (UserID'=""){
 		s DoctorType=##class(web.SSUser).GetDefaultCareProviderType(UserID)
 		s BindSource=$P($G(^OEORD(+oeori,"I",$P(oeori,"||",2),"DHC")),"^",41)
 		if (DoctorType="DOCTOR"){	//&&(OrderType'="R")
	 		if (BindSource'="")&&(",CT,SP,BF,OMIO,CA,RPO,"'[(","_BindSource_",")){ 
		 		q ""
		 	}
	 	}
	 	s UserAddDr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),7)),"^",1)
	 	if (UserAddDr'=""){
			s AddUserType=##class(web.SSUser).GetDefaultCareProviderType(UserAddDr)
			if (AddUserType="NURSE")&&(DoctorType="DOCTOR")&&(LinkOrderItem'=""){
				q ""
			}
		}
		// if (LinkOrderItem'="")&&(OrderType'="R") q ""
 	}
 	;医嘱备注
 	s OrderResume = ""
	s depProcNotesIndex = 0
	for {
		s depProcNotesIndex=$o(^OEORD(+oeori,"I",$P(oeori,"||",2),"DEP",depProcNotesIndex)) q:depProcNotesIndex=""
		continue:(^OEORD(+oeori,"I",$P(oeori,"||",2),"DEP",depProcNotesIndex)="")
		s OrderResume = OrderResume_" "_^OEORD(+oeori,"I",$P(oeori,"||",2),"DEP",depProcNotesIndex)
	}
	s:OrderResume="" OrderResume=$p($g(^OEORD(+oeori,"I",$P(oeori,"||",2),2)),"^",8)
 	;输液滴速
	s SpeedFlowRate=$p($g(^OEORD(+oeori,"I",$P(oeori,"||",2),3)),"^",17)
	;输液滴速单位
	s FlowRateUnit=""
	s FlowRateUnitRowid=$p($g(^OEORD(+oeori,"I",$P(oeori,"||",2),6)),"^",8)
	s:FlowRateUnitRowid'="" FlowRateUnit=$P($G(^OEC("SFR",FlowRateUnitRowid)),"^",2)
	s OrderFreqTimeDoseQtyStr="",OrderFreqWeekStr=""
	if (OrderFreqRowid'="") {
		s WeekFlag=$P(^PHCFR(OrderFreqRowid),"^",9)
		//示例串 28||1$0.1!28||2$0.2!28||3$0.3
		s OrderFreqTimeDoseQtyStr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",59)
		d ##class(web.DHCDocOrderItemList).CalFreqTimeDoseQtyStr(.OrderFreqTimeDoseQtyStr)
		//示例串 4|5
		s OrderFreqWeekStr=$p($g(^OEORD(+oeori,"I",$P(oeori,"||",2),"DHC")),"^",55)
		if (WeekFlag="Y")&&(OrderFreqWeekStr'="")&&(OrderFreqRowid'="") {
			s CalOrderFreqDispTimeStr="",CalOrderFreqWeekStr=""
			d ##class(web.DHCDocOrderItemList).CalFreqWeekStr(OrderFreqRowid,OrderFreqWeekStr,.CalOrderFreqDispTimeStr,.CalOrderFreqWeekStr)
			s OrderFreqWeekStr=CalOrderFreqDispTimeStr
			s OrderFreqWeekStr=$replace(OrderFreqWeekStr,"~",$C(1))
			s OrderFreqWeekStr=$replace(OrderFreqWeekStr,"@",$C(2))
			s OrderFreq=OrderFreq_"-"_CalOrderFreqWeekStr
		}
	}
 	s ItemSpecCode=$P($G(^OEORD(+oeori,"I",$P(oeori,"||",2),"SPEC",1)),"^",1)
 	s ARCOSRowId="",ArcimARCOSRowId=""
 	s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid)
 	if (CNMedItemFlag=1) {
	 	/*if (OrderPrescNo'="") {
		 	s QUE1RowID=$o(^PAQUE1(0,"PrescNo",OrderPrescNo,""))
		 	s:QUE1RowID'="" ARCOSRowId=$p(^PAQUE1(QUE1RowID,"DHC"),"^",24)
	 	}*/
	 	s ArcimARCOSRowId=$p($g(^OEORD(+oeori,"I",$P(oeori,"||",2),3)),"^",10)
	 	s ARCOSRowId=ArcimARCOSRowId
	}
 	s OrderStage=$P($G(^OEORD(+oeori,"I",$P(oeori,"||",2),"DHC")),"^",8)
 	s OrderStageDesc=##CLass(web.DHCDocOrderCommon).GetOrderStageDesc(OrderStage)
	i OrderDurRowid'="" s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
	s OrderNotifyClinician=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),11)),"^",55)
	s ExceedReasonID=$p($G(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",33)
	if ExceedReasonID'=""  s ExceedReason=$P($G(^DHCDocExceedReason(ExceedReasonID)),"^",2)
	else  s ExceedReason=""
	
	
	
	s ItemData = ARCIMRowid_"!"_OrderSeqNo_"!"_OrderDoseQty_ch1_OrderDoseUOM_ch1_OrderDoseUOMRowid
	s ItemData = ItemData_"^"_OrderFreq_ch1_OrderFreqRowid_ch1_OrderFreqFactor_ch1_OrderFreqInterval
	s ItemData = ItemData_"^"_OrderInstr_ch1_OrderInstrRowid
	s ItemData = ItemData_"^"_OrderDur_ch1_OrderDurRowid_ch1_OrderDurFactor
	s ItemData = ItemData_"^"_OrderPackQty_ch1_OrderPackUOM_ch1_OrderPackUOMRowid
	s ItemData = ItemData_"^"_OrderPrior_ch1_InOrderPriorRowid
	s ItemData = ItemData_"^"_ARCOSRowId_"^^"	//医嘱套ID、空、医嘱子类ID
	s ItemData = ItemData_"^"_OrderResume	//备注
	
	s ItemData=ItemData_"^"	//附加说明
	s ItemData=ItemData_"^"	//抗生素
	s ItemData=ItemData_"^"_OrderNotifyClinician	//紧急标志
	s ItemData=ItemData_"^"_ArcimARCOSRowId //医嘱套项目id
	s ItemData=ItemData_"^"_ItemSpecCode	//标本	
	s ItemData=ItemData_"^"_OrderStage_ch1_OrderStageDesc	//医嘱阶段
	s ItemData=ItemData_"^"_SpeedFlowRate_$C(1)_FlowRateUnit_$C(1)_FlowRateUnitRowid //输液流速、流速单位
	s ItemData=ItemData_"^"_ReqPartId
	s ItemData=ItemData_"^"_OrderActionRowid_"^"_OrderAction_"^"_OrderSkinTest
	s ItemData=ItemData_"^" //计费组套餐明细编号
	s ItemData=ItemData_"^"_OrderFreqTimeDoseQtyStr_"^"_OrderFreqWeekStr //同频次不同剂量、周频次
	s ItemData=ItemData_"^"_ExceedReasonID_$C(1)_ExceedReason
	s ItemData=ItemData_"^"	//ViewBindSource
	s ItemData=ItemData_"^"_VirtualtLongFlag
	s ItemData = ItemData_"!"_OrderType_"!"_OrderBillTypeRowId_"!"_"Order"
	q ItemData
}

/// 检查 停止 权限
/// 同一科室的人能停止
/// 护士也能停止--医生开出的绑定其他医嘱的非医嘱单子医嘱
/// w ##class(web.DHCDocMain).CheckStopOrder("217||194","18885","8","23","","",.msg)
ClassMethod CheckStopOrder(OrderItemRowId As %String, UserRowId As %String, LocID As %String, GroupID As %String = "", ExDate = "", ExTime = "", ByRef ErrMsg As %String = "")
{
	s ^tempscl("gg")=$LB(OrderItemRowId,UserRowId,LocID,GroupID,ExDate,ExTime)
	s oeori = ++OrderItemRowId
	s oeorisub = $P(OrderItemRowId,"||",2) 
	s EpisodeID = $p(^OEORD(oeori),"^",1)
	s AdmDepId=$P($G(^PAADM(EpisodeID)),"^",4)
	s AdmType=$P($G(^PAADM(EpisodeID)),"^",2)
	s OEORIItemStateCode=##class(appcom.OEOrdItem).GetStatusCode(OrderItemRowId)
	if (OEORIItemStateCode="U") {
		s ErrMsg="已作废医嘱不能停止!"
		Q "0"
	}
	if (OEORIItemStateCode="D") {
		s ErrMsg="已停医嘱不能停止!"
		Q "0"
	}
	;调用新产品组接口判断MDT医嘱对应会诊是否已撤销 
	if (##Class(web.DHCMDTInterface).GetCsRevFlagByOeori(OrderItemRowId)=0) {
		s ErrMsg="医嘱对应会诊申请未撤销!"
		Q "0"
	}
	//非长期不能停止
	s PriorityDR = $p($g(^OEORD(oeori,"I",oeorisub,1)),"^",8)
	if ('##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)){
		 s ErrMsg="非长期医嘱不能停止"
		 q "0"
	}
	s PreStopOrderTime=..%GetConfig("PreStopOrderTime")
	if ExDate'=""{
		s ret=1,stopMsg=""
		s hdate = $zdh(ExDate,##class(websys.Conversions).DateFormat()),htime=..%ZTH(ExTime)
		if +PreStopOrderTime'=0 {
			s PreStopOrderT=PreStopOrderTime*3600+..%SysTime()
			s PreStopOrderD=PreStopOrderT\86400+..%SysDate()
			s PreStopOrderT=PreStopOrderT#86400

			if (hdate>PreStopOrderD)!((hdate=PreStopOrderD)&&(htime>PreStopOrderT)) {
				s ErrMsg=..%Translate("ipdoc.patinfoview.csp"," 停医嘱时间不能晚于")_$zd(PreStopOrderD,3)_" "_$zt(PreStopOrderT)
				q "0"
			}
		}
		;ExpectEndDate之后有执行记录已执行，不允许停止
		;这个判断改成调用appcom.OEOrdItem下的CheckIsExistExecByDateT方法
		s retStr=##class(appcom.OEOrdItem).CheckIsExistExecByDateT(OrderItemRowId,hdate,htime)
		s ret=$p(retStr,"^",1)
		s stopMsg=$p(retStr,"^",2)
		if (ret=0){
			s orderExecId=$p(retStr,"^",3)
			s str = ^OEORD(+orderExecId,"I",$p(orderExecId,"||",2),"X",$p(orderExecId,"||",3))
			s ExStDate=$p(str,"^",1)
			s ExStTime = $p(str,"^",2)
			s ExStDateStr=..%ZD(ExStDate)_" "_..%ZT(ExStTime,1)
			if (stopMsg="-15305") {
				s ErrMsg="停止时间之后的执行记录已被执行! 请先撤销执行记录" //stopMsg
			}elseif (stopMsg="-15308"){
				s ErrMsg="停止时间之后的执行记录"_ExStDateStr_"静配中心已经配液"
			}elseif (stopMsg="-15309"){
				s ErrMsg="停止时间之后的执行记录"_ExStDateStr_"已进入备药过程"
			}else{
				s ErrMsg="停止时间之后的执行记录"_ExStDateStr_"异常"
			}
			q "0"
		}
		//如果是主医嘱则需要判断子医嘱的状态
		s SubFlag=0
		s Sub=$O(^OEORDi(0,"OEORI",+OrderItemRowId,OrderItemRowId,0))
		While (Sub'="") {
			s SubRowId=+OrderItemRowId_"||"_Sub
			;已经停止的医嘱不用再处理
			s retStr=##class(appcom.OEOrdItem).CheckIsExistExecByDateT(SubRowId,hdate,htime)
			s ret=$p(retStr,"^",1)
			s stopMsg=$p(retStr,"^",2)
			if (ret=0){
				s orderExecId=$p(retStr,"^",3)
				s str = ^OEORD(+orderExecId,"I",$p(orderExecId,"||",2),"X",$p(orderExecId,"||",3))
				s ExStDate=$p(str,"^",1)
				s ExStTime = $p(str,"^",2)
				s ExStDateStr=..%ZD(ExStDate)_" "_..%ZT(ExStTime,1)
				s ArcimRowId=$p($G(^OEORD(+SubRowId,"I",$P(SubRowId,"||",2),1)),"^",2)
				s OrderName=$p(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1),"^",2)
				if (stopMsg="-15305") {
					s ErrMsg=OrderName_"停止时间之后的执行记录已被执行! 请先撤销执行记录" //stopMsg
				}elseif (stopMsg="-15308"){
					s ErrMsg=OrderName_"停止时间之后的执行记录"_ExStDateStr_"静配中心已经配液"
				}elseif (stopMsg="-15309"){
					s ErrMsg=OrderName_"停止时间之后的执行记录"_ExStDateStr_"已进入备药过程"
				}else{
					s ErrMsg=OrderName_"停止时间之后的执行记录"_ExStDateStr_"异常"
				}
				s SubFlag=1
			}
			s Sub=$O(^OEORDi(0,"OEORI",+OrderItemRowId,OrderItemRowId,Sub))
		}
		if (SubFlag=1) q 0
	}
	
	;拿下医嘱医护人员的类型 ;
	Set OrdDoctorDr = $p(^OEORD(oeori,"I",oeorisub,1),"^",11)
	s OrdInternalType=..GetCarePrvTp(OrdDoctorDr)
	;取医嘱录入人，本地化时可能存在下医嘱人和医嘱录入人不一致的情况，即护士替医生补录医嘱
	;该情况控制为双方均可操作医嘱
	Set UserAdd=$P($G(^OEORD(oeori,"I",oeorisub,1)),"^",1)
	Set AddOrdInternalType=..GetCarePrvTpByUserID(UserAdd)
	
	;当前想撤销用户的医护人员类型
	Set CTCPTInternalType=..GetCarePrvTpByUserID(UserRowId)
	s isNurse=(CTCPTInternalType="NURSE")
	s ctpcprowid=$P(^SSU("SSUSR",UserRowId),"^",14)	
	if (OrdInternalType="NURSE")&&(CTCPTInternalType="DOCTOR"){
		s oriOriDr=$p($g(^OEORD(oeori,"I",oeorisub,11)),"^",39)
		if (oriOriDr'=""){
			Q:##class(web.DHCDocMain).CheckStopOrder(oriOriDr,UserRowId,LocID,GroupID,ExDate,ExTime,.ErrMsg)=1 1 
		}
	}
	
	;start
	s ret=0,RBFlag=0
	s DoctorDr=$P($G(^OEORD(oeori,"I",oeorisub,1)),"^",11) 
	If DoctorDr="" Set RBFlag = 1 
	Set OrdDeptId = $p($g(^OEORD(oeori,"I",oeorisub,7)),"^",2)	;开单科室
	SEt CareProvDR = $p(^SSU("SSUSR",UserRowId),"^",14)
	If (+OrdDeptId<=0){
		Set RBFlag = 1 
	}elseif (((OrdInternalType=CTCPTInternalType)||(AddOrdInternalType=CTCPTInternalType)) &&
			($d(^RB("RES",0,"CTPCP",CareProvDR,OrdDeptId)))){
		Set RBFlag = 1  ;医护人员类型一致 且 [当前用户]是医嘱[开单科室]的[医护人员] ;RB_Resource--CTCareProv
		
	}elseif isNurse=1 {
		;护士可以单独停医生开出的绑定其他医嘱的非医嘱单医嘱
		s str1 = ^OEORD(oeori,"I",oeorisub,1)
		s ItmMastDR = $p(str1,"^",2)
		s mastItemCat = $p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10) ;护士站配置 子类 
		s OrderType=$p(^ARC("IC",mastItemCat),"^",7)
		s ordDept = $p($g(^OEORD(oeori,"I",oeorisub,7)),"^",2) ;OEORI_UserDepartment_DR
		s arcicOrdCatDR = $p(^ARC("IC",mastItemCat),"^",8)
		;只能操作本科室\病区的医嘱

		if $D(^CTLOC(ordDept,"LINK",0,"Loc",LocID)){
			s oriOriDr=$p($G(^OEORD(oeori,"I",oeorisub,11)),"^",39)
			;只能停子嘱(oriOriDr'="")&&----不再验证必须是子医嘱才能停tanjishan
			s OperatAuthResult=##class(DHCDoc.DHCDocConfig.StopConfig).CheckOperatAuth(OrderItemRowId,"S","")
			if (+OperatAuthResult=0){
				s ErrMsg=$P(OperatAuthResult,"^",2)
				Quit 0
			}else{
				s RBFlag = 1
			}
			/*
			if (OrderType'="R"){
				s DefOEOrdPrintSetHospId=..GetDefOEOrdPrintSetHospId(EpisodeID)
				;护士站配置
				//应先判断大类
				s NotOrdCat=##class(Nur.NIS.Service.OrderSheet.Sheet).getShieldSetting(DefOEOrdPrintSetHospId, 0)
				if ("^"_NotOrdCat_"^")[("^"_arcicOrdCatDR_"^") s RBFlag = 1
				s NotSordCat=##class(Nur.NIS.Service.OrderSheet.Sheet).getShieldSetting(DefOEOrdPrintSetHospId, 1)
				if ("^"_NotSordCat_"^")[("^"_mastItemCat_"^") s RBFlag = 1
				//if $g(^DHCOEOrdPrintSet("NotOrdCat",DefOEOrdPrintSetHospId))[("^"_arcicOrdCatDR_"^") s RBFlag = 1
				//if $g(^DHCOEOrdPrintSet("NotSordCat",DefOEOrdPrintSetHospId))[("^"_mastItemCat_"^") s RBFlag = 1
				//s arcicOrdCatDR = $p(^ARC("IC",mastItemCat),"^",8) ;护士站配置 大类
				//s:$g(^DHCOEOrdPrintSet("NotOrdCat"))[("^"_arcicOrdCatDR_"^") RBFlag = 1
			}
			*/
			/*
			///护士如有权限开立该医嘱,则也有权限停止
			if (RBFlag=0){
				s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GroupID,ItmMastDR,AdmType,AdmDepId,UserRowId,LocID,0,"")
				i OrderAuthInValid=1 s RBFlag=1
			}
			*/
		}
	}
	
	
	Quit:(RBFlag=1) 1
	s ErrMsg="没有权限,请核实,[当前用户]不是医嘱[开单科室]的[医护人员]"
	Quit 0
}

/// 检查 撤销 权限
/// 同一科室的人 能撤销
/// 没有下医嘱人 能撤销
/// w ##Class(web.DHCDocMain).CheckCancelOrder("3267||38","10209",23,"104",.msg)
ClassMethod CheckCancelOrder(OrderItemRowId As %String, UserRowId As %String, LocID As %String, GroupID As %String = "", ByRef Msg As %String = "") As %Boolean
{
	s rtn=..CheckCancelOrdCommon("C",OrderItemRowId,UserRowId,LocID,GroupID,.Msg)
	;长期不能撤销单独判断
	if rtn{
		if ##class(DHCDoc.Order.Common).IsLongOrdItem(OrderItemRowId){
			s Msg="长期医嘱不能撤销"
			Q 0
		}
	}
	Q rtn
}

/// 检查 作废 权限
/// 下医嘱人自己 能作废
/// 没有下医嘱人 能作废
ClassMethod CheckUnuseOrder(OrderItemRowId As %String, UserRowId As %String, LocID As %String, GroupID As %String = "", ByRef Msg As %String = "") As %Boolean
{
	s ^tempCheckUnuseOrder=$LB(OrderItemRowId, UserRowId, LocID, GroupID)
	s CurLogonHosp=$p($g(^CTLOC(LocID)),"^",22)
	s NurseUnUseOrdAuth=..%GetConfig("NurseUnUseOrdAuth",CurLogonHosp)
	s CTCPTInternalType=..GetCarePrvTpByUserID(UserRowId)	;传入用户医护类型
	if (CTCPTInternalType="NURSE")&&(NurseUnUseOrdAuth=1){
		;作废需要判断本人
		s UserAdd=$P($G(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),7)),"^",1)	
		if (UserAdd'="")&&(UserRowId'=UserAdd){
			s Msg="非本人医嘱"
			Q 0
		}
	}
	s rtn=..CheckCancelOrdCommon("U",OrderItemRowId,UserRowId,LocID,GroupID,.Msg)
	
	Q rtn
}

/// 检查医嘱是否可作废或撤销的公共方法
/// OperateType:"作废"/"撤销"
ClassMethod CheckCancelOrdCommon(OperateType As %String, OrderItemRowId As %String, UserRowId As %String, LocID As %String, GroupID As %String = "", ByRef Msg As %String = "") As %Boolean
{
	s CurLogonHosp=$p($g(^CTLOC(LocID)),"^",22)
	s OrderRowId = +OrderItemRowId,OrderSub = $p(OrderItemRowId,"||",2)
	s EpisodeID = $p(^OEORD(OrderRowId),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s OnlyThisDepStop=$P($G(^CTLOC(LocID,"DHC")),"^",14)	;门诊用 医嘱只能本科室停止
	s str1 = ^OEORD(OrderRowId,"I",OrderSub,1)
	s ItmMastDR = $p(str1,"^",2)
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=##class(DHCDoc.Order.Common).GetOrdItemType(OrderItemRowId)
	s UserAdd=$P($G(^OEORD(OrderRowId,"I",OrderSub,7)),"^",1)	;开单用户
	s OrdDeptId=$p($g(^OEORD(OrderRowId,"I",OrderSub,7)),"^",2)	;开单科室
	s AddOrdInternalType=..GetCarePrvTpByUserID(UserAdd)	;开单用户医护类型
	s CTCPTInternalType=..GetCarePrvTpByUserID(UserRowId)	;传入用户医护类型
	s CareProvDR = $p(^SSU("SSUSR",UserRowId),"^",14)
	s OrdDoctorDr = $p(str1,"^",11)
	///是否上医嘱单标识
	//s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(OrderRowId,OrderSub)
	s OperateTypeDesc=""
	&SQL(SELECT OSTAT_Desc into :OperateTypeDesc from SQLUser.OEC_OrderStatus where OSTAT_Code =:OperateType)
	s OperatAuth=OperateType
	s BindSourceDesc=##Class(web.DHCDocQryOEOrder).GetBindSourceDesc(OrderItemRowId)
	s IsLinkDept=(OrdDeptId="")||($D(^CTLOC(OrdDeptId,"LINK",0,"Loc",LocID)))||(LocID=OrdDeptId)
	;科室用户权限和医护人员类型校验	绑定出来的采血医嘱护士可以停(不进行此判断)
	if (UserAdd'=""){
		//医生站设置-》基本设置-》护士处理医嘱后不能撤销(住院)
		if (CTCPTInternalType="DOCTOR")&&(..%GetConfig("NurSeeOrdNotStopAndCancel",CurLogonHosp)=1){
			// 护士处理后可以作废/撤销的子类-住院
			s AfterNurDealCanUnuseItemCat=..%GetConfig("AfterNurDealCanUnuseItemCat",CurLogonHosp)
			i ("^"_AfterNurDealCanUnuseItemCat_"^")'[("^"_ItemCatDR_"^") {
				s OEORISeeType=$p($g(^OEORD(OrderRowId,"I",OrderSub,"NUR")),"^",7)
				;医嘱护士审核后，医生不能撤销
				if ((OEORISeeType="A")||(OEORISeeType="F")){
					s Msg="护士已审核"
					Q 0
				}
			}
		}
		;护士可以单独停医生开出的绑定其他医嘱的非医嘱单医嘱
		//if (CTCPTInternalType="NURSE")&&(AddOrdInternalType="DOCTOR")&&('IsOrdBillOE){
		if (CTCPTInternalType="NURSE")&&(AddOrdInternalType="DOCTOR"){
			s OperatAuthResult=##class(DHCDoc.DHCDocConfig.StopConfig).CheckOperatAuth(OrderItemRowId,$CASE(OperatAuth,"U":"C",:OperatAuth),"")
			
			if (+OperatAuthResult=1){
				if ('IsLinkDept){
					s Msg="非本科室医嘱"
					Q 0
				}
			}else{
				s Msg=$P(OperatAuthResult,"^",2)
				Q 0
			}
		}else{
			;非本科室且不是本人
			if (CareProvDR'=""){
				if '$D(^RB("RES",0,"CTPCP",CareProvDR,OrdDeptId))&&(OrdDoctorDr'=CareProvDR)&&(AddOrdInternalType'="Pharmacist"){
					if ((PAAdmType'="I")&&(OnlyThisDepStop=1))||(PAAdmType="I"){
						s Msg="非开单科室用户"
						Q 0
					}
				}
			}
		}
	}else{
		;开单用户为空的情况,本科医师护士均可作废撤销
		if (CareProvDR'=""){
			if OrdDeptId&&'$D(^RB("RES",0,"CTPCP",CareProvDR,OrdDeptId))&&'$D(^CTLOC(OrdDeptId,"LINK",0,"Loc",LocID)){
				if ((PAAdmType'="I")&&(OnlyThisDepStop=1))||(PAAdmType="I"){
					s Msg="非科室用户"
					Q 0
				}
			}
		}
	}
	s ForceDealOrder=##class(web.DHCDocMain).ForceDealOrder(OrderItemRowId,UserRowId,LocID,OperateType)
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(EpisodeID)
	if (UserEMVirtualtLong=0)||(OrderType'="R"){
		if ##class(appcom.OEOrdItem).Executed(OrderItemRowId)&&("Y"'=ForceDealOrder){
			s Msg="执行记录已执行或结算!"
			Q 0
		}
	}
	s OEORIItemStateCode=##class(appcom.OEOrdItem).GetStatusCode(OrderItemRowId) 
	if (OEORIItemStateCode'="V") {
		//可以强制撤销的医嘱
		if ("Y"'=ForceDealOrder){
			s Msg="非核实状态的医嘱不能"_OperateTypeDesc
			Q 0
		}
	}
	s CurrentDischargeStatus = ##class(web.DHCDocMainOrderInterface).GetCurrentDischargeStatus(EpisodeID)
	if (CurrentDischargeStatus="B"){
		s DischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(ItmMastDR,CurLogonHosp)
		if DischargeOrdFlag>0{
			s DischType=$CASE(DischargeOrdFlag,1:"出院",2:"死亡")
			s Msg="您不能"_OperateTypeDesc_" "_DischType_" 医嘱！因护士已开启费用调整，您可直接处理其它医嘱。如果该患者需要继续治疗，请结束费用调整后对其做出院召回。"
			Q 0
		}
		s OrdAdmStatus=$P($G(^OEORD(OrderRowId,"I",OrderSub,"DHC")),"^",78)
		if (OrdAdmStatus'="B")&&(OperateType="U"){
			s Msg="非费用调整期间开具的医嘱,不能作废!"
			Q 0
		}
	}
	;调用新产品组接口判断MDT医嘱对应会诊是否已撤销 
	if (##Class(web.DHCMDTInterface).GetCsRevFlagByOeori(OrderItemRowId)=0) {
		s Msg="医嘱对应会诊申请未撤销!"
		Q 0
	}
	;调用手麻组接口判断是否可以取消手术申请
	s OperRtn=##class(CIS.AN.SRV.OperService).CanCancelOperation(OrderItemRowId,GroupID,UserRowId)
	if (+OperRtn<0) {
		s Msg=$P(OperRtn,"^",2)
		Q 0
	}
	;验证治疗申请是否可以撤下
	s DCARowID=$o(^DHCDocCure(0,"OEORI",OrderItemRowId,""))	
	if DCARowID'=""{
		s ApplyStatus=$p($g(^DHCDocCure(DCARowID)),"^",3)
		if (ApplyStatus'="C") {
			s myErrMsg=""
			s ret=##class(DHCDoc.DHCDocCure.Apply).CheckData(DCARowID,"C","",.myErrMsg)
			if +ret'=0{
				s Msg=myErrMsg
				Q 0
			}
		}
	}
	if (OrderType="R"){
		//已发药不能作废
		s DSPFlag=..CheckCMDSPStatus(OrderItemRowId)
		if (DSPFlag=1){
			s Msg="已发药"
			Q 0
		}
		//已进入备药过程不能作废
		s DrawingFlag=..CheckISDrawing(OrderItemRowId)
		if (DrawingFlag=1){
			s Msg="已进入备药过程"
			Q 0
		}
		//配液的医嘱不能作废
		s PIVAStatus=..CheckPIVAStatus(OrderItemRowId)
		if (PIVAStatus=1){
			s Msg="已配液"
			Q 0
		}	
	}
	;出院状态只能作废出院医嘱
	s PAAdmFlag = ##class(web.DHCDocMainOrderInterface).HiddenMenuFlag(EpisodeID)
	if PAAdmFlag>0{
		if PAAdmFlag>=3{
			s Msg="病人已出院"
			Q 0
		}
		if (PAAdmFlag=2)&&(CTCPTInternalType'="NURSE"){
			s OrderDischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(ItmMastDR,CurLogonHosp)
			if (OrderDischargeOrdFlag=0){
				s Msg="请先作废或撤销出院类医嘱"
				Q 0
			}
		}
	}
	;转科医嘱已使用 不允许作废
	s TransType=$P($G(^OEORD(OrderRowId,"I",OrderSub,"NUR")),"^",17)
	s TransUseFlag=$P($G(^OEORD(OrderRowId,"I",OrderSub,"NUR")),"^",18)
	if (TransType'="")&&(TransUseFlag="Y"){
		s Msg="转科医嘱已使用,不能"_OperateTypeDesc
		Q 0
	}
	Q 1
}

/// 可以强制撤销的医嘱，已执行的医嘱也可以直接撤销，以处理关联医技的材料、费用医嘱，被医技关联执行后无法撤销的问题
/// 本病区、下医嘱人是护士，此类型的医嘱不验证医嘱执行状态，
/// OperateType操作类型，即新的医嘱状态
/// 2023-01-31 change by tanjishan 不再校验是否上医嘱单，撤销医嘱权限与医嘱单没有必然关系
ClassMethod ForceDealOrder(OrderItemRowId As %String, UserRowId As %String, LocID As %String, OperateType As %String) As %Status
{
	if (UserRowId="")||(LocID=""){
		q "N"
	}
	s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LocID)
	if (..%GetConfig("ForceDealOrder",HospitalId)'="1"){
		q "N"
	}
	
	s OrderRowId = +OrderItemRowId,OrderSub = $p(OrderItemRowId,"||",2)
	s OEORIItemStateCode=##class(appcom.OEOrdItem).GetStatusCode(OrderItemRowId) 
	if (OEORIItemStateCode'="E")&&(OEORIItemStateCode'="V"){
		q "N"
	}
	s str1 = ^OEORD(OrderRowId,"I",OrderSub,1)
	s OrderType=##class(DHCDoc.Order.Common).GetOrdItemType(OrderItemRowId)
	s UserAdd=$P($G(^OEORD(OrderRowId,"I",OrderSub,7)),"^",1)	;开单用户
	s OrdDeptId=$p($g(^OEORD(OrderRowId,"I",OrderSub,7)),"^",2)	;开单科室
	s AddOrdInternalType=..GetCarePrvTpByUserID(UserAdd)	;开单用户医护类型
	s CTCPTInternalType=..GetCarePrvTpByUserID(UserRowId)	;传入用户医护类型
	//s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(OrderRowId,OrderSub)
	//s OperatAuth=OperateType
	//s OperatAuthResult=##class(DHCDoc.DHCDocConfig.StopConfig).CheckOperatAuth(OrderItemRowId,OperatAuth,"")
	//s BindSourceDesc=##Class(web.DHCDocQryOEOrder).GetBindSourceDesc(OrderItemRowId)
	s IsLinkDept=(OrdDeptId="")||($D(^CTLOC(OrdDeptId,"LINK",0,"Loc",LocID)))||(LocID=OrdDeptId)
	//if (IsLinkDept)||('IsOrdBillOE)&&(AddOrdInternalType="NURSE")&&(CTCPTInternalType="NURSE"){
	if (IsLinkDept)||(AddOrdInternalType="NURSE")&&(CTCPTInternalType="NURSE"){
		q "Y"
	}
	q "N"
}

ClassMethod CheckOperationOrder(OrderItemRowId As %String, UserRowId As %String, LocID As %String, GroupID As %String = "")
{
	s rtn = "N^N^N"
	s stop = ..CheckStopOrder(OrderItemRowId, UserRowId, LocID , GroupID)
	s cancel = ..CheckCancelOrder(OrderItemRowId, UserRowId, LocID , GroupID)
	s unnuse = ..CheckUnuseOrder(OrderItemRowId, UserRowId, LocID , GroupID)
	s:(stop=1) $p(rtn,"^",1)="Y"
	s:(cancel=1) $p(rtn,"^",2)="Y"
	s:(unnuse=1) $p(rtn,"^",3)="Y"
	q rtn
}

/// 检查是否能够添加备注
/// 1:可以
/// 其他：不可以
ClassMethod CheckAddNoteOrder(OrderItemRowId As %String, UserRowId As %String, LocID As %String, GroupID As %String = "", ByRef Msg As %String = "")
{
	s OrderRowId = +OrderItemRowId
	s OrderSub = $p(OrderItemRowId,"||",2)
	s str1 = ^OEORD(OrderRowId,"I",OrderSub,1)
	s ItmMastDR = $p(str1,"^",2)
	Set PAAdm = $p(^OEORD(OrderRowId),"^",1)
	if ($D(^Nur.DoctorOrderPrintRecordSubI("OrderId"," "_$p(OrderItemRowId,"||",1,2)))){
		s Msg="已打印医嘱单"
		q -1
	}
	;医嘱护士审核后，医生不能作废
	s OEORISeeType=""
	s OEORISeeType=$p($g(^OEORD(OrderRowId,"I",OrderSub,"NUR")),"^",7)
	s CTCPTInternalType=..GetCarePrvTpByUserID(UserRowId)
	
	if ((OEORISeeType="A")||(OEORISeeType="F"))&&(CTCPTInternalType="DOCTOR"){
		s Msg="护士已审核"
		q -2
	}
	Set PAAdmFlag = ##class(web.DHCDocMainOrderInterface).HiddenMenuFlag(PAAdm)
	if (PAAdmFlag>0)&&(PAAdmFlag'=5)&&(PAAdmFlag'=2.5){
		s Msg="已结算,结算状态:"_$CASE(PAAdmFlag,2:"医疗结算",3:"护士结算",4:"财务结算后",5:"不是V7病人",2.5:"费用调整状态",:"")
		if (PAAdmFlag=2){
			s Msg=Msg_",请撤销出院类型医嘱"	//或进入费用调整阶段
		}
		q -3
	}
	/*
	s OEORIItemStateCode=##class(appcom.OEOrdItem).GetStatusCode(OrderItemRowId) 
	if (OEORIItemStateCode'="V")&&(OEORIItemStateCode'="C")&&(OEORIItemStateCode'="I") {
		s RBFlag=0,Msg="非核实、撤销状态的医嘱不能作废"
		q RBFlag
	}
	*/
	Quit 1
}

ClassMethod CheckISDrawing(Orderitem As %String) As %String
{
	s ret=0
	Q:Orderitem="" ret
	s OEOREChildsub=0
	for {
		s OEOREChildsub=$o(^OEORD(+Orderitem,"I",$p(Orderitem,"||",2),"X",OEOREChildsub)) Q:OEOREChildsub=""
		s ret=##class(PHA.FACE.OUT.Method).IsOeoreDrawing(Orderitem_"||"_OEOREChildsub)=1
		Q:ret=1
	}
	Q ret
}

/// 1:已发药，0：未发药或不需要校验是否发药
ClassMethod CheckCMDSPStatus(Orderitem As %String) As %String
{
	s ret=0
	q:Orderitem="" ret
	;发药后不可撤销或作废的子类
	s IssuedNotCancelItemCat=..%GetConfig("IssuedNotCancelItemCat")
	i IssuedNotCancelItemCat=0 s IssuedNotCancelItemCat=""
	s ArcimId=$p(^OEORD(+Orderitem,"I",$p(Orderitem,"||",2),1),"^",2)
	s ItemCatRowid=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",10)
	s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ArcimId)
	s DSPRowId="0" 
	s DSPRowId=$O(^DHCOEDISQTY(0,"OEORI",Orderitem,DSPRowId))
	q:DSPRowId="" ret
	s adm = $p(^OEORD(+Orderitem),"^",1)
	s AdmType=$p(^PAADM(adm),"^",2)
	s dspStat=$P($G(^DHCOEDISQTY(DSPRowId)),"^",7)
	if dspStat="C" {
		s ret=1
		
		if (CNMedItemFlag="1")&&(AdmType="I"){
			;草药调用药房组接口判断处方对应的可退标志Y 可退 其他 不可退
			s PrescNo=$p(^OEORD(+Orderitem,"I",$p(Orderitem,"||",2),1),"^",14)
			s AgreeRetFlag= ##class(PHA.FACE.OUT.Com).CheckIfRetFlag(PrescNo) //##class(PHA.FACE.OUT.Method).CheckIfRetFlag
			if (AgreeRetFlag="") s ret=0
  		}
    }
    Q:(CNMedItemFlag="1")&&(AdmType="I") ret
    if (ret=1){
	    i (("^"_IssuedNotCancelItemCat_"^")[("^"_ItemCatRowid_"^")) {
			q ret
		}
	}
	Q 0
	;q ret
}

ClassMethod CheckPIVAStatus(Orderitem As %String) As %String
{
	s ret=0
	q:Orderitem="" ret
	s ItmMastDR = $P(^OEORD(+Orderitem,"I",$p(Orderitem,"||",2),1),"^",2)
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	q:(OrderType'="R") ret
	
	//配液不允许停止
	s RecDepDR=$P($G(^OEORD(+Orderitem,"I",$p(Orderitem,"||",2),3)),"^",6)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(RecDepDR)
	s NotAllowStopWhenPIVASDispensing=##Class(web.DHCDocConfig).GetConfigNode3("IPDosingRecLoc",RecDepDR,"NotAllowStopWhenPIVASDispensing",HospitalId)
	q:(NotAllowStopWhenPIVASDispensing'="1") ret
	
	s xSub=0
	for {
		s xSub=$O(^OEORD(+Orderitem,"I",$p(Orderitem,"||",2),"X",xSub))
		q:(xSub="")
		
		s ExecId=$P(Orderitem,"||",1,2)_"||"_xSub
		if (##class(PHA.FACE.OUT.Com).IfOeoreHas60(ExecId)="Y"){
			s ret=1
		}
	}
	q ret
}

ClassMethod HandSetConfig()
{
	
	;医嘱单配置
	s ^DHCDocOrderBillConfig("Main","PatientListWidth") = "300" ;左边病人列表的宽度
	s ^DHCDocOrderBillConfig("Main","FeeListWidth") = "380"			;右费用列表的宽度
	s ^DHCDocOrderBillConfig("Main","FeeListHeight") = "280"        ;右费用列表的高度
 	
 	;s ^DHCDocFeeConfig("CanCancelFee")="^21^22"				;只有某些收费项才能取消费用
}

ClassMethod GetExecFeeCollapseConfig() As %String
{
	q $s($g(^DHCDocOrderBillConfig("Main","ExecAndFeeListCollapse"))="on":"true",1:"false")
}

/// 收起否? on收起 ,默认展开
ClassMethod GetPatListCollapseConfig() As %String
{
	
	q $s($g(^DHCDocOrderBillConfig("Main","PatListCollapse"))="on":"true",1:"false")
}

ClassMethod GetUseProgressBarConfig() As %String
{
	q $s($g(^DHCDocOrderBillConfig("Main","IsUseProgressBar"))="":"false",1:"true")
}

ClassMethod GetDefaultPatListType()
{
	q $g(^DHCDocOrderBillConfig("Main","PatListType"),0)
}

/// WangQingyong 支持判断医嘱项或医嘱套
ClassMethod MatchAlias(ItmMastDR, inputOrderDesc) As %Boolean
{
	s inputOrderDesc=$$ALPHAUP^SSUTIL4(inputOrderDesc)
	Q:inputOrderDesc="" 1
	s flag=0
	if ItmMastDR["||"{
		s ItemDesc=$p($G(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",2)
		s IndexType="ARCIM"
	}else{
		s ItemDesc=$P($G(^ARCOS(+ItmMastDR)),"^",2)
		s IndexType="ARCOS"
	}
	Q:$$ALPHAUP^SSUTIL4(ItemDesc)[inputOrderDesc 1
	s flag=0
	s aliasRowid="" for{
		s aliasRowid=$o(^ARC("ALIAS",0,IndexType,ItmMastDR,aliasRowid)) q:aliasRowid=""
		s aliasText=$p(^ARC("ALIAS",aliasRowid),"^",6)
		if $zcvt(aliasText,"U")[inputOrderDesc{
			s flag=1
			Q
		}
	}
	q flag
}

/// wanghc 20130503
/// @param: {OE_Order->OEORD_RowId} OrderId
/// @param: {OE_OrdItem->OEORI_RowId} OrdItemId
/// @return: 医嘱的发药数量与单位
/// @debug:  w ##class(web.DHCDocMain).GetQtyAndUom(48,11)
ClassMethod GetQtyAndUom(OrderId, OrdItemId)
{
	set DrgQtyUom = ""
	Set str2 = $g(^OEORD(OrderId,"I",OrdItemId,2))
	Set str1 = $g(^OEORD(OrderId,"I",OrdItemId,1))
	set orderPackQty=$p($g(^OEORD(OrderId,"I",OrdItemId,9)),"^",4)	;整包装数量 OEORI_QtyPackUOM
	Set orderPhQtyOrd=$p(str1,"^",12)  ;检查-治疗数量 OEORI_PHQTYORD
	set doseQty = $p(str2,"^",1)				;用量 OEORI_DoseQty
	set doseUnitDr= $p(str2,"^",3)				;剂量单位 OEORI_Unit_DR 
	set ItmMastDR = $p(^OEORD(OrderId,"I",OrdItemId,1),"^",2)
	//set ARCIMBillingUOMDr=$P($G(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),8)),"^",14)
	set ARCIMBillingUOMDr=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrderId_"||"_OrdItemId)
	set PriorityDR = $p(str1,"^",8)
	
	;检查-治疗数量 OEORI_PHQTYORD
	if orderPhQtyOrd'="" d
	.s OrderPhQtyUOM=""
	.i ARCIMBillingUOMDr'="" s OrderPhQtyUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ARCIMBillingUOMDr) 
	.s DrgQtyUom = orderPhQtyOrd_OrderPhQtyUOM
		
	if doseQty'="" d
	.s DrgformRowid = $p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",12) ;PHC_DrgForm
	.i DrgformRowid>0 d
	..s order2PackQty = $system.SQL.CEILING(##class(web.DHCDocOrderEntry).CalDose(doseUnitDr,DrgformRowid,doseQty))
	..s bsUOMph = $p(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),2),"^",4)
	..s bsUOMphDesc = ##class(web.DHCDocOrderCommon).GetUOMDesc(bsUOMph)
	..s DrgQtyUom = order2PackQty_bsUOMphDesc
	
	;临时--药品-----医嘱是不是
	if ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR){
		if orderPackQty'="" {
			s OrderPackUOM=""
			i ARCIMBillingUOMDr'="" s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ARCIMBillingUOMDr) 
			s DrgQtyUom = orderPackQty_OrderPackUOM
		}
	}
	q DrgQtyUom
}

ClassMethod InsertOEORIdepProcNotes(OEORI, OrderNotes)
{
	S orderParref = +OEORI
	S orderId = $P(OEORI,"||",2)
	q:OrderNotes="" 0
	Set len = $l(OrderNotes,$c(13,10))
	k ^OEORD(orderParref,"I",orderId,"DEP")
	for j=1:1:len d
	.Set ^OEORD(orderParref,"I",orderId,"DEP",j)=$p(OrderNotes,$c(13,10),j)
	Set ^OEORD(orderParref,"I",orderId,"DEP",0)=len
	q 0
}

ClassMethod GetOEORIdepProcNotes(OEORI)
{
	q:OEORI="" ""
	S orderParref = +OEORI
	S orderId = $P(OEORI,"||",2)
	s proc=0,str=""
	f  s proc = $o(^OEORD(orderParref,"I",orderId,"DEP",proc)) q:proc=""  d
	.if str="" s str=^OEORD(orderParref,"I",orderId,"DEP",proc)
	.else  set str=str_$c(13,10)_^OEORD(orderParref,"I",orderId,"DEP",proc)
	q str
}

ClassMethod CheckConflictExec(oeori)
{
	//w ##class(web.DHCDocMain).CheckConflictExec("325517||104||1")
	s oeord=+oeori
	s oeordsub = $p(oeori,"||",2)
	s itmMastDR = $p(^OEORD(oeord,"I",oeordsub,1),"^",2)
	s ConflictItems=##class(web.DHCDocConfig).GetConflict(itmMastDR)
	Q:ConflictItems="" ""
	Set ExDate=$p(^OEORD(oeord,"I",oeordsub,"X",$p(oeori,"||",3)),"^",1)  //要标执行时间
	Set OrderRowid=oeord
	//判断该医嘱执行记录有没有互斥的
	Set FindOrdSub=""
	Set ExStTime=0
	Set itemsub=0
	for  Set itemsub=$o(^OEORD(oeord,"I",itemsub)) Quit:(itemsub="")||(FindOrdSub'="")  do
	.Quit:itemsub=oeordsub
	.s sttdate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	.s OrdPriorityDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",8)              ;医嘱优先级
	.q:OrdPriorityDR=""
	.s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(OrdPriorityDR)
	.q:ISLongOrderPrior'=1
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.;Q:(statcode'="V")
	
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.i itemrowid'="" d
	..i ("^"_ConflictItems_"^")[("^"_itemrowid_"^") d
	...Set ExecId=0
	...For  Set ExecId=$o(^OEORD(oeord,"I",itemsub,"X",ExecId)) Quit:(ExecId="")||(FindOrdSub'="")  do
	....Set ExStDate=$p(^OEORD(oeord,"I",itemsub,"X",ExecId),"^",1)
	....Quit:ExStDate'=ExDate
	....Set ExecStatus=$p(^OEORD(OrderRowid,"I",itemsub,"X",ExecId),"^",16) 
	....Quit:ExecStatus=""
	....Set ExecStatusCode=$p(^OEC("STAT",ExecStatus),"^",1)
	....if ExecStatusCode="F" do
	.....Set FindOrdSub=itemsub
	if FindOrdSub'="" {
		Set OrderId=oeori_"||"_FindOrdSub
		Set ArcimId=$p(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1),"^",2)
		Set ArcimDesc=$p(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",2)
		s rtn="物价科提醒:存在今日的互斥医嘱【"_ArcimDesc_"】,请注意费用问题!"
		Quit rtn
	}
	q ""
}

ClassMethod GetARCIMDesc(oeori)
{
	s str1 = ^OEORD(+oeori,"I",$p(oeori,"||",2),1)
	s ItmMastDR=$p(str1,"^",2)
	s TOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	Q TOrderDesc
}

/// 如果医嘱在最后一次进入调整费用前录入的不能进行作废操作2，之后录入的可以进行作废操作1。
/// retuen 1 在范围内 2 在范围外 -1错误
ClassMethod CanUnuseOrderFromTime(Adm, oeori)
{
	 s InsertDate=$P(^OEORD(+oeori,"I",$P(oeori,"||",2),1),"^",19)
	 s InsertTime=$P(^OEORD(+oeori,"I",$P(oeori,"||",2),1),"^",20)
	 s ID=$O(^DHCDischargeHistory(Adm,"History",""),-1)
	 s TZDate=""
	 s TZTime=""
	 s sub=""
	 s sub=$o(^DHCDischargeHistory(Adm,"History",sub),-1)
	 i (sub'=0)&(sub'="") d
	 .s type=$p($g(^DHCDischargeHistory(Adm,"History",sub)),"^",4)
	 .s TZDate=$p($g(^DHCDischargeHistory(Adm,"History",sub)),"^",1)
	 .s TZTime=$p($g(^DHCDischargeHistory(Adm,"History",sub)),"^",2)
	 if ($g(type)'="B"){
		 q "-1"
	 }
	 ;录入日期小于进入费用调整日期在 费用调整范围外 2 
	 if ((InsertDate<TZDate)||((InsertDate=TZDate)&&(InsertTime<=TZTime))){q 2}
	 else{q 1}
}

ClassMethod GetNURPRNExec(group As %String) As %String
{
	s menucode = "NURPRNExec"
	s obj = ##class(websys.ExtMenu).EMCodeMenuOpen(menucode)
	s execMenuJson = obj.GetMenusJson(group)
	d obj.%Close()
	s obj=""
	i execMenuJson="" s execMenuJson="{}"
	Q execMenuJson
}

/// 获得医嘱重分类
/// [[rowid,desc],[rowid,desc]]
/// w ##class(web.DHCDocMain).GetOrdCatList(77343)
ClassMethod GetOrdCatList()
{
	s rtn=""
	s ModuleId=0,FindRowID=""
	f  s ModuleId=$o(^DHCDocCT("Module",ModuleId)) q:(ModuleId="")||(FindRowID'="")  d
	.s ModuleDesc=$g(^DHCDocCT("Module",ModuleId))
	.i ModuleDesc="医嘱重分类" s FindRowID=ModuleId
	Quit:FindRowID="" "[[ALL,'全部']]"
	s CTDefine=0
	f  s CTDefine=$o(^DHCDocCTi(0,"Define","ModuleDR",FindRowID,CTDefine)) q:CTDefine=""  d
	.s DefineDataID=0
	.f  s DefineDataID=$o(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID)) q:DefineDataID=""  d
	..s DefineDataDesc=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",2)
	..s DefineDataFrom=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",3)
	..q:(DefineDataFrom'="")&&(DefineDataFrom>+$h)
	..s DefineDataTo=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",4)
	..q:(DefineDataTo'="")&&(DefineDataTo<=..%SysDate())
	..s OrderCatTypeId=CTDefine_"||"_DefineDataID
	..s OrderCatType=DefineDataDesc
	..i rtn="" d
	...s rtn = "['"_OrderCatTypeId_"','"_OrderCatType_"']"
	..e  d
	...i rtn'[("['"_OrderCatTypeId_"',") d
	....s rtn = rtn_",['"_OrderCatTypeId_"','"_OrderCatType_"']"
	q "[['ALL','全部'],"_rtn_"]"
}

/// 病人入院日期w ##class(web.DHCDocMain).AdmDate(69608)
ClassMethod AdmDate(adm)
{
	Quit:adm="" ""
	//s Rtn =""
	//s Rtn=$ZD($P($g(^PAADM(adm)),"^",6),3)
	s rtn=##class(web.DHCDischargeHistory).GetAdminDateTime(adm)  //##class(web.DHCMGNurComm).PACInPatDateBed(adm)
	s date=..%ZD($P(rtn,"^",1))
	Q date
	//if rtn'=""  s Rtn=$P(rtn,"^",1)
	//q Rtn
}

/// 病人入院天数
ClassMethod AdmLong(adm)
{
	Quit:adm="" ""
	s Rtn ="",Now=""
	s Now=..%SysDate()
	s Date=$P($g(^PAADM(adm)),"^",6)
	s rtn=##class(web.DHCMGNurComm).PACInPatDateBed(adm)
	;if rtn'="" s Date=$P(rtn,"^",1)
	Set DischargeDate=$P($g(^PAADM(adm)),"^",17)
	if (DischargeDate'="")  s Rtn=DischargeDate-Date
	e  s Rtn=Now-Date
	q Rtn
}

/// creater lxz
/// desc 监测是否有执行记录生成
/// Input OEOrdID 医嘱ID ,执行记录日期
/// OutPut 1 存在异常 0不存在异常
/// w ##class(web.DHCDocMain).CheckExecHave("71||104",+$H)
ClassMethod CheckExecHave(OEOrdID, Date)
{
	s $ZT="ErrorCheckExecHave"
	s FindNull="0"
	s FreqDr=$p($g(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),2)),"^",4)
 	s SttDate=$p($g(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),1)),"^",9)
 	s Enddate=$p($g(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),9)),"^",9)
 	s ArcimID=$P($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),1)),"^",2)
 	s FirstDayTimes=$p($g(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),1)),"^",18)
 	s OEORIUserDepDR=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),7)),"^",2)
 	s OEORIRecLocID=$p($g(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),3)),"^",6)
	if (OEORIUserDepDR'=""){
		s OEORIUserHospDr=$p($g(^CTLOC(OEORIUserDepDR)),"^",22)
	}else{
		s EpisodeID=$P(^OEORD(+OEOrdID),"^",1)
		s AdmLocDr=$P(^PAADM(EpisodeID),"^",4)
		s OEORIUserHospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	}
 	s PriorityCode=""
 	s PriorityDR=$P($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),1)),"^",8)
 	s:PriorityDR'="" PriorityCode=$P($G(^OECPR(PriorityDR)),"^",1)
 	;非长期医嘱类型的只验证开始日期的医嘱
 	i (PriorityCode'="OMST")&(PriorityCode'="S")&(PriorityCode'="OMCQZT") s Date=SttDate
 	
 	s OrderName=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",2)  ;
	s statcode="V"
	s TtemStat=$P($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),1)),"^",13) ;OEORI_Billed
	i TtemStat'="" d
	.s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	;对不需要产生执行记录的情况固定进行验证
	;医嘱无效和实习生审核的
	Q:(statcode="U")||(statcode="D")||(statcode="C")||(statcode="I") FindNull
	s OrderDate=$p($g(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),3)),"^",7)
	;验证日期小于开始日期
 	Q:Date<SttDate FindNull ;开始日期之前的数据不验证执行记录
 	;开医嘱当日首日次数为0
 	Q:(Date=SttDate)&&(+FirstDayTimes=0) FindNull ;监测日期是开始日期的按照首日次数判定 //&&(OrderDate=SttDate)
 	;PRN医嘱 需要时不产生执行
 	s FreqCode=$S(FreqDr'="":$P($g(^PHCFR(+FreqDr)),"^",1),1:"")
 	Q:$ZCVT(FreqCode,"U")="PRN" FindNull
 	;走治疗申请单的临时治疗项目不生成执行记录,长期继续产生执行记录)
 	
 	;配置了预约允许直接执行，则全部生成执行记录
	;s DHCDocCureAppointAllowExec=+(..%GetConfig("DHCDocCureAppointAllowExec",OEORIUserHospDr))
	s DHCDocCureAppointAllowExec=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocAppAllowExec",OEORIRecLocID)
	if DHCDocCureAppointAllowExec=0{
		Q:##class(DHCDoc.DHCDocCure.Service).CureItemIsGenExe(OEOrdID)=1 FindNull
	}
 	//Q:$$CureItemIsGenExe^DHCOEOrdExec(OEOrdID)=1 FindNull
 	
 	s OtherDesc=""
 	s NeedCreateExecFlag=##class(DHCDoc.Order.Exec).NeedGenFlag(OEOrdID,Date)
 	if NeedCreateExecFlag=1  d
 	.;应该产生执行记录的验证是否产生
 	.s FindNull="1"
	.s ExecID=0
	.f  s ExecID=$O(^OEORDi(0,"OrdItem",+OEOrdID,$P(OEOrdID,"||",2),Date,ExecID)) Q:ExecID=""  d
	..s FindNull="0"
	b //9012
	if (FindNull="1")
	{
		s Rtn=$$FindArcimActive(ArcimID,Date)
 		if ('Rtn){s OtherDesc="医嘱项目截止"}
 		
	}
	q FindNull_"^"_OtherDesc
FindArcimActive(Arcim,CDate)
	Q:Arcim="" 0
	s DateFrom=$p($g(^ARCIM(+Arcim,1,1)),"^",13)
	s DateTo=$p($g(^ARCIM(+Arcim,1,7)),"^",1)
	Q:(DateFrom>CDate)&&(DateFrom'="") 0
	Q:(DateTo<CDate)&&(DateTo'="") 0
	q 1
ErrorCheckExecHave
	q 0
}

/*
MissExecList的两种返回数据形式，如果能够确定缺失的执行时间则返回时间，若无法确定时间则只返回缺失数量
s MissExecList("ExecTime",Date1,Time1)=""
s MissExecList("ExecTime",Date2,Time2)=""
s MissExecList("ExecTime",Date3,Time3)=""

s MissExecList("MissCount")=3
*/
/// creater tanjishan
/// 获取医嘱缺失执行记录详情
/// Input OEOrdID 医嘱ID 
/// OutPut 1 存在异常 0不存在异常
/// w ##class(web.DHCDocMain).CheckExecValidity("1902||33", .MissExecList)
/// WangQingyong 修改为新的执行记录生成方法统一判断
ClassMethod CheckExecValidity(OEOrdID As %String, ByRef MissExecList) [ ProcedureBlock = 0 ]
{
	n (OEOrdID,MissExecList)
	k MissExecList
	s TtemStat=$P($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),1)),"^",13)
	s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	;医嘱无效和实习生审核的
	Q:(statcode="U")||(statcode="C")||(statcode="I") 0
	;治疗项目预约时产生则不需要生成
	Q:##class(DHCDoc.Order.Exec).GetCureAppGenFlag(OEOrdID) 0
	;PRN医嘱不需要产生
	Q:##class(appcom.OEOrdItem).ISPRNOrder(OEOrdID) 0
	;s EndDate=$p($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),9)),"^",9)	
	s EndDate=$p($G(^OEORD(+OEOrdID,"I",$p(OEOrdID,"||",2),3)),"^",34)	
	s GenDate=$CASE(EndDate,"":+$H,:EndDate)
	;获取指定时间范围执行时间列表，有停止日期就按停止日期算,没有按今天
	d ##class(DHCDoc.Order.Exec).GetGenTimeList(OEOrdID,GenDate,.ExecList)
	d ##class(DHCDoc.Order.Exec).GetOrdExecQtyToList(OEOrdID,.ExecList)
	s CheckRet=0
	s Date="" for{
		s Date=$O(ExecList(Date)) Q:Date=""
		s Time="" for{
			s Time=$O(ExecList(Date,Time)) Q:Time=""
			if '$D(^OEORDi(0,"Date",+OEOrdID,Date,Time,$p(OEOrdID,"||",2))){
				s CheckRet=1
				s MissExecList("ExecTime",Date,Time)=""
			}
		}
	}
	Q CheckRet
}

/// 获取护理系统配置-医嘱单设置默认医院组(该页面屏蔽医嘱大类/屏蔽医嘱子类设置后，护士可单独停医嘱开立的非药品子医嘱)
ClassMethod GetDefOEOrdPrintSetHospId(Adm As %String) As %String
{
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	s DefOEOrdPrintSetHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("Nur_IP_DHCOEOrdPrintSet",AdmHospitalId) 
	Q DefOEOrdPrintSetHospId
}

ClassMethod GetCarePrvTpByUserID(UserID)
{
	s CareProvID=##class(web.SSUser).GetDefaultCareProvider(UserID)
	Q ..GetCarePrvTp(CareProvID)
}

ClassMethod GetCarePrvTp(CareProvID)
{
	Q:CareProvID="" ""
	s CarPrvTpDR=$p($g(^CTPCP(CareProvID,1)),"^",4)
	Q:CarPrvTpDR="" ""
	Q $P($G(^CT("CPT",CarPrvTpDR)),"^",4)
}

}
