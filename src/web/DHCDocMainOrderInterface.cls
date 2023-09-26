/// wanghc
/// 增加一个类一集合其它组的方法,以便调用
Class web.DHCDocMainOrderInterface Extends DHCDoc.Util.RegisteredObject
{

ClassMethod GetIllLevelColorJson()
{
	do ..GetIllLevelColor(.IllLevel)
	Set jsonObj = ##class(ext.util.JsonObject).%New()
	Set tmp = ""
	for {
		Set tmp = $o(IllLevel(tmp))
		Quit:tmp=""
		do jsonObj.Put(tmp,IllLevel(tmp))
	}
	Set rtn = jsonObj.Json()
	Quit rtn
}

ClassMethod GetIllLevelColor(ByRef IllLevel)
{
	Set IllLevel("F")="#27B66B"
	Set IllLevel("FC")="yellow"	
	Set IllLevel("S")="#F05AD7"
	Set IllLevel("C")="#F16D56"
	Quit ""
}

/// 病危病人 WFY1005461
ClassMethod IsCriticallyIll(EpisodeID)
{
	Quit:EpisodeID="" ""
	;Quit:EpisodeID=21 1
	Set val = ..%IsValidMethod("web.DHCSETIMAGE","IfOrddailyExistByConfig")
	Set img = 0
	if val{
		Set img = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(EpisodeID,"CRITICALLY")
	}
	Quit img
}

/// 病重病人 "WFY1005471"
ClassMethod IsSeriouslyIll(EpisodeID)
{
	Quit:EpisodeID="" ""
	;Quit:EpisodeID=13 1
	Set val = ..%IsValidMethod("web.DHCSETIMAGE","IfOrddailyExistByConfig")
	Set img = 0
	if val{
		Set img = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(EpisodeID,"SERIOUSLY")
	}
	Quit img
}

/// 一级护理病人 M13007012
ClassMethod IsFirstClsCare(EpisodeID)
{
	Quit:EpisodeID="" ""
	Set val = ..%IsValidMethod("web.DHCSETIMAGE","IfOrddailyExistByConfig")
	Set img = 0
	if val{
		Set img = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(EpisodeID,"FIRSTCLSCARE")
	}
	Quit img
}

/// 新加的方法 , 护士站配置出院日期字段
/// @return: DisDateH^DisTimeH  
ClassMethod GetDisDateTime(PAAdm)
{
	Set val = ..%IsValidMethod("web.DHCDischargeHistory","GetDischargeDateTime")
	Set rtn=""
	if (val){
		Set rtn = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",PAAdm)
	}else{
		Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
		Set DischargeTime=$P($g(^PAADM(PAAdm)),"^",18)
		Set rtn = DischargeDate_"^"_DischargeTime
	}
	Quit rtn
}

/// 2---医疗结算后---显示医生菜单(撤销出院医嘱),显示护士菜单
/// 3---护士结算后---医生菜单(费用修改时显示),护士菜单(费用修改时显示)
/// 4---财务结算后---隐藏医生菜单,隐藏护士菜单
/// 5---不是V7病人---隐藏医生菜单,隐藏护士菜单
ClassMethod HiddenMenuFlag(adm)
{
	q:##class(web.DHCDocMain).isFinDischg(adm) 4
	Set flag = ..GetCurrentDischargeStatus(adm)
	//最终结算后,调整费用,---护士可以做相关操作 
	q:(##class(web.DHCDocMain).isDischg(adm) && (flag="B")) 2.5
	q:##class(web.DHCDocMain).isDischg(adm) 3
	q:##class(web.DHCDocMain).isEstDisch(adm) 2
	;q:'##class(web.DHCDocMain).isV7Episode(adm) 5
	q 0
}

ClassMethod GetCurrentDischargeStatus(PAAdm)
{
	Set val = ..%IsValidMethod("web.DHCDischargeHistory","GetCurrentDischargeStatus")
	Set rtn=""
	if (val){
		Set rtn = ##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(PAAdm)
	}
	Quit rtn
}

/// 2015-12-04 判断医嘱项是不是医疗结算医嘱
/// @Param : ArcimRowid   医嘱项rowid
/// @return 0 ------not Discharge Arcim
///         1 ------Discharge Arcim
///         2 ------Death Arcim
ClassMethod IsDischargeArcim(ArcimRowid, HospID As %String = "")
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Quit ##Class(web.DHCDocOrderEntry).IsDischargeOrd(ArcimRowid,HospID)
}

ClassMethod GetPatientAge(PatientID, PAAdm, HospID = "")
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	Set Age=0
	s val = ..%IsValidMethod("web.DHCBillInterface","GetPapmiAge")
	if val{
		Set Age = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PAAdm,HospID)
	}else{
		Set Age = ##class(web.PAPerson).calculateAgeUnitsShow(PatientID)
	}
	Quit Age
}

/// 获得停医嘱护士
ClassMethod GetXOrderNurseName(oeordId, oeordSub) As %String
{
		s NurseName = ""
		s val = ..%IsValidMethod("web.DHCLCNUREXCUTE","GetXOrdInfo")
		if val{
			s str = ##class(web.DHCLCNUREXCUTE).GetXOrdInfo(oeordId,oeordSub)
			s user = $p(str,"^",1)
			if user>0 {
				s NurseName = $p(^SSU("SSUSR",user),"^",2)
			}
		}
		q NurseName
}

/// 获得皮试结果
/// ,Y,N---空,阳性+,阴性-
ClassMethod GetSkinAbnorm(order, ordItem)
{
		s skintest="",abnorm=""
    	s skintest=$p($g(^OEORD(order,"I",ordItem,5)),"^",2)
    	//if (skintest="Y") {
    		s abnorm=$p($g(^OEORD(order,"I",ordItem,11)),"^",3)
    	//}
    	q abnorm
}

/// 获得医嘱项单位
ClassMethod GetBillUom(arcim, sub)
{
	q:'$d(^ARCIM(arcim,sub,8)) ""
	Set langid=..%LanguageID()
	s buomcod=""
	s billuom=$p($g(^ARCIM(arcim,sub,8)),"^",14)
	s:+billuom'=0 buomcod=$p($g(^CT("UOM",billuom)),"^")
	s buomcod=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",buomcod,langid)
	s buomcod=$zcvt($g(buomcod),"U")
	q buomcod
}

/// oeorditem rowid
/// @desc:   判断上不上医嘱单
/// 优先级走appcom下的类方法 q:(nursebill="N")&&($g(^DHCOEOrdPrintSet("L","OrdTyp"))'[("^"_PriorityCode_"^")) 0 ;护士站配置-长嘱类型
ClassMethod IsOrdBillOE(orderParref, orderId)
{
	s str1 = ^OEORD(orderParref,"I",orderId,1)
	s ItmMastDR = $p(str1,"^",2)
	s episodId=$p(^OEORD(orderParref),"^",1)
	s AdminDateTime = ##class(web.DHCDischargeHistory).GetAdminDateTime(episodId)
	s startDate=$zd(+AdminDateTime,3)
	s startTime=..%ZT($p(AdminDateTime,"^",2))
	s startDateTime=$zdh(startDate,3)*100000+..%ZTH(startTime)
 	s endDateTime=""
	s orderCreateDate=$p(^OEORD(orderParref,"I",orderId,3),"^",7)  //下医嘱日期
 	s orderCreateTime=$p(^OEORD(orderParref,"I",orderId,1),"^",17)
 	s orderInsertDate=$p(^OEORD(orderParref,"I",orderId,1),"^",19)  //插医嘱日期 儿童用
 	s orderInsertTime=$p(^OEORD(orderParref,"I",orderId,1),"^",20)
 	i (orderInsertDate'="")&&(orderInsertTime'="") {
	 	s orderCreateDateTime=orderCreateDate*100000+orderCreateTime
	 	q:orderCreateDateTime<=startDateTime 0
	 	q:(endDateTime'="")&(orderCreateDateTime>endDateTime) 0
 	}
 	s ReformTimes=$o(^Nur.DoctorOrderPrintRecordSubI("OrderId"," "_orderParref_"||"_orderId,""))
	//屏蔽医嘱状态
	s ordStateDr=$P($G(^OEORD(orderParref,"I",orderId,1)),"^",13) //医嘱状态
	q:((ordStateDr="2")!(ordStateDr=""))&(ReformTimes="") 0
	
	s priorDr=$P($G(^OEORD(orderParref,"I",orderId,1)),"^",8)   //医嘱优先级 
	i priorDr'="" s priorDesc=$P(^OECPR(priorDr),"^",2)  
	q:priorDr="" 0
	s priorDesc="^"_priorDesc_"^"
	
	//临时医嘱显示长期产后护理,为了实现临时医嘱单产后换页
	s DeliverArcimDR=$G(^DHCOEOrdPrintSet("DeliverOrderArcimDr"))
	q:(##class(appcom.OEOrdItem).ISShortOrderPrior(priorDr))&&(^DHCOEOrdPrintSet("OrdTyp")'[priorDesc)&(ItmMastDR'=DeliverArcimDR) 0
	
	//长期显示临时术后医嘱,为了分页  
	s OperArcimDR=$G(^DHCOEOrdPrintSet("OperOrderArcimDr"))
	q:(##class(appcom.OEOrdItem).ISLongOrderPrior(priorDr))&&(^DHCOEOrdPrintSet("L","OrdTyp")'[priorDesc)&(ItmMastDR'=OperArcimDR)&(ItmMastDR'=DeliverArcimDR)
	
	//屏蔽科室
	s schLoc=$P($G(^OEORD(orderParref,"I",orderId,7)),"^",2)
	s schLoc=$p(schLoc,$c(1))
	s schLoc="^"_$G(schLoc)_"^"
	s lsNotLoc=$G(^DHCOEOrdPrintSet("NotLoc"))
	q:($G(^DHCOEOrdPrintSet("NotLoc"))[schLoc)&((lsNotLoc'="^^")!(lsNotLoc'=""))&(ReformTimes="") 0
	
	//屏蔽医护人员
	s doctorDr=$P($G(^OEORD(orderParref,"I",orderId,1)),"^",11)
	if doctorDr'="" s cpTypDR=$P($g(^CTPCP(doctorDr,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:$g(cpTypDR)="" 0
	q:'$D(^CT("CPT",cpTypDR)) 0
	s cpTyp=""
	i $G(cpTypDR)'="" s cpTyp=$P($g(^CT("CPT",cpTypDR)),"^",4)  ;CT_CarPrvTp
	q:cpTyp'="DOCTOR" 0
 	//按子类和大类屏蔽医嘱
 	s itemCatDr=$P($G(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",10)
 	s ordCatDr=$P(^ARC("IC",itemCatDr),"^",8)    
	s ordCat=$P(^OEC("ORCAT",ordCatDr),"^",1)    
	s ordCatDrStr="^"_ordCatDr_"^"
	//大类
	q:($G(^DHCOEOrdPrintSet("NotOrdCat"))[ordCatDrStr&($G(^DHCOEOrdPrintSet("NotOrdCat"))'=""))&(ReformTimes="") 0
	s ItemCatDrStr="^"_itemCatDr_"^" 
	//子类
	q:($G(^DHCOEOrdPrintSet("NotSordCat"))[ItemCatDrStr&($G(^DHCOEOrdPrintSet("NotSordCat"))'=""))&(ReformTimes="") 0
	//撤销医嘱是否上医嘱单
	s ordStateDr=$P($G(^OEORD(orderParref,"I",orderId,1)),"^",13) //医嘱状态
	s orderState=$p(^OEC("OSTAT",ordStateDr),"^",1)
	q:(orderState="C")&($G(^DHCOEOrdPrintSet("ifstop"))'="true") 0
	
	//下医嘱医生
 	s addUserDr=$P($G(^OEORD(orderParref,"I",orderId,7)),"^",1)
	q:addUserDr="" 0
	q 1
	/*s str1 = ^OEORD(orderParref,"I",orderId,1)
	s DoctorDr=$p(str1,"^",11)
	s ItmMastDR = $p(str1,"^",2)
	s CTCPTInternalType=""
	i DoctorDr>0{
		s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
		s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
	}
	q:((CTCPTInternalType="NURSE")&&($g(^DHCOEOrdPrintSet("ifnur"))'="true")) 0	;护士站配置-护嘱可不可见
	s mastItemCat = $p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)			
	q:($g(^DHCOEOrdPrintSet("NotSordCat"))[("^"_mastItemCat_"^")) 0	;护士站配置 子类	
	s arcicOrdCatDR = $p(^ARC("IC",mastItemCat),"^",8)							
	q:($g(^DHCOEOrdPrintSet("NotOrdCat"))[("^"_arcicOrdCatDR_"^")) 0 	;护士站配置 大类
	q 1*/
}

ClassMethod IsNurseAdd(orderParref As %String, orderId As %String) As %String
{
	s str1 = ^OEORD(orderParref,"I",orderId,1)
	Set OrdInternalType=""
	Set OrdDoctorDr = $p(str1,"^",11)
	if OrdDoctorDr {
		Set OrdCTPCPCarPrvTpDR = $p(^CTPCP(OrdDoctorDr,1),"^",4)
		If OrdCTPCPCarPrvTpDR>0 {
			Set OrdInternalType = $p(^CT("CPT",OrdCTPCPCarPrvTpDR),"^",4)
		}
	}
	Q:OrdInternalType="NURSE" 1
	Q 0
}

/// @param: scopeId 	1 全部   非作废, 
/// 					2 作废   为不打印的医嘱U 
/// 					3 当前   为所有未停医嘱和停止时间迟于当前系统时间的医嘱 
/// 					4 待审核 I未激活 
/// 					5 已停止 D
ClassMethod LongOrderScope(scope, itemStatCode, orderParref, orderId, ifDeliveryRoom As %String = "")
{
	q:(scope=1)&&(itemStatCode="U") 0			//全部时不显示作废的
	q:(scope=2)&&(itemStatCode'="U") 0	//只显示作废
	s TStopDate = $p(^OEORD(orderParref,"I",orderId,3),"^",34)		;XDate
	s StartDate=$p(^OEORD(orderParref,"I",orderId,1),"^",9)
	s:$d(^OEORD(orderParref,"I",orderId,2)) TStopTime = $p(^OEORD(orderParref,"I",orderId,2),"^",15)		;XTime
	q:(scope=3)&&((itemStatCode'="V")&&(itemStatCode'="D")&&(itemStatCode'="E")) 0
	q:(scope=3)&&((itemStatCode="D")&&(TStopDate=..%SysDate())&&(TStopTime<..%SysTime())) 0		//当前 当天停止 不是核实的
	q:(scope=3)&&((itemStatCode="D")&&(TStopDate<+$H)) 0
	q:(scope=4)&&((itemStatCode'="I")) 0
	q:(scope=5)&&((itemStatCode'="D")&&(itemStatCode'="C")) 0
	s PriorityDR=$p(^OEORD(orderParref,"I",orderId,1),"^",8)
	s IsLongPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	///scope=6   今日有效。开始日期为当天的核实或执行状态的医嘱，核实或执行状态的长期医嘱,停止日期为当天的长期医嘱
	q:(scope=6)&&((IsLongPrior'=1)&&(((itemStatCode'="V")&&(itemStatCode'="E"))||(StartDate<(+$h)))) 0
	q:(scope=6)&&((IsLongPrior=1)&&((((itemStatCode="D")||(itemStatCode="C"))&&(TStopDate<+$H))||(itemStatCode="U"))) 0
	q:(scope=7)&&((IsLongPrior'=1)&&(((itemStatCode'="V")&&(itemStatCode'="E"))||(StartDate<(+$h-2)))) 0
	q:(scope=7)&&((IsLongPrior=1)&&(((itemStatCode="D")||(itemStatCode="C"))&&(TStopDate<(+$H-2)))||(itemStatCode="U")) 0
	s OEORISeeDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",5) //获取处理日期
	;8 待处理 9 已处理
	if (scope=8)||(scope=9){
		;调用护士站接口判断医嘱是否需要处理
		if (scope=8) {
			s PAADMRowID=$p(^OEORD(+orderParref),"^",1)
			s wardID=$P($g(^PAADM(PAADMRowID)),"^",70)
			s ifOrdNeedSee=##class(Nur.NIS.Service.OrderExcute.Execute).ifOrdNeedSee(+orderParref, orderId,wardID)
			Q:ifOrdNeedSee="N" 0
		}
		;获取医嘱处置状态(同护士执行-需处理-处置状态调用)
		s OrdDisposeStatCode=##class(Nur.NIS.Service.Base.Order).GetOrderDisposeStatCode(+orderParref,orderId)
		;NeedToDeal:需处理医嘱 NeedToStop:需处理停止  AlreadyDeal:已处理 AlreadyStop:已处理停止
		Q:(scope=8)&&(OrdDisposeStatCode'="NeedToDeal")&&(OrdDisposeStatCode'="NeedToStop") 0
		Q:(scope=9)&&(OrdDisposeStatCode'="AlreadyDeal")&&(OrdDisposeStatCode'="AlreadyStop") 0
	}
	//待处理
	/*if (scope=8){
		if (ifDeliveryRoom=1) {
			s OrderStage=$p($G(^OEORD(+orderParref,"I",orderId,"DHC")),"^",8)
			Q:OrderStage'="CZ" 0 //产房默认显示医嘱阶段"产中"的待处理医嘱
		}
		if (itemStatCode="D")||(itemStatCode="C"){
			s OEORIDisconDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",2)	
			q:OEORIDisconDate'="" 0
		}else{
			q:itemStatCode="U" 0 //作废医嘱不显示在待处理页面
			q:OEORISeeDate'="" 0
		}
		//过滤护士单独补录和医生医嘱没有绑定关系的医嘱
		s LinkOrderItemRowId=$p($g(^OEORD(orderParref,"I",orderId,11)),"^",39)
		s UserAddDr=$p($g(^OEORD(orderParref,"I",orderId,7)),"^",1)
		if (UserAddDr'=""){
			s AddUserType=##class(web.SSUser).GetDefaultCareProviderType(UserAddDr)
			if (AddUserType="NURSE")&&(LinkOrderItemRowId=""){
				Q 0
			}
			if (LinkOrderItemRowId'="") {
				s MasterUserAddDr=$p($g(^OEORD(+LinkOrderItemRowId,"I",$p(LinkOrderItemRowId,"||",2),7)),"^",1)
				s MasterAddUserType=##class(web.SSUser).GetDefaultCareProviderType(MasterUserAddDr)
				if (AddUserType="NURSE")&&(MasterAddUserType="NURSE") {
					Q 0
				}
			}
			
		}
	}
	//已处理
	if (scope=9){
		if (itemStatCode="D")||(itemStatCode="C"){
			s OEORIDisconDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",2)	
			q:OEORIDisconDate="" 0
		}else{
			q:itemStatCode="U" 1
			q:OEORISeeDate="" 0
		}
	}*/
	//驳回
	if (scope=10){
		s IsCallbackOrder=##class(web.DHCDocMainOrderInterface).IsCallbackOrder(orderParref,orderId)
		s IsNurseCallbackOrder = ##class(web.DHCDocMainOrderInterface).IsNurseCallbackOrder(orderParref,orderId)
		if ((IsCallbackOrder=1)||(+IsNurseCallbackOrder=1)){
			if (itemStatCode="V"){
				q 1
			}
		}
		q 0
	}
	//被全排斥操作停止的长期医嘱
	if (scope=11){
		Q:$P($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",61)="" 0
	}
	q 1
}

/// @param: scopeId 1 全部   非作废, 
/// 					2 作废   为不打印的医嘱U 
/// 					3 当前   为所有未停医嘱和停止时间迟于当前系统时间的医嘱 
/// 					4 待审核 I未激活 
/// 						5 已停止 C撤销
ClassMethod ShortOrderScope(scope, itemStatCode)
{
	
	q:(scope=1)&&(itemStatCode="U") 0	//全部时不显示作废的
	q:(scope=2)&&(itemStatCode'="U") 0	//只显示作废
	q:(scope=3)&&((itemStatCode'="V")&&(itemStatCode'="E")) 0	//当前是指已核实或已执行
	q:(scope=4)&&((itemStatCode'="I")) 0
	q:(scope=5)&&((itemStatCode'="C")&&(itemStatCode'="D")) 0
	q 1
}

/// @param: {PA_Adm->PAADM_RowId} EpisodeID 
/// @param: {Byref} status   error info
ClassMethod IGetMrNoByEpisodeID(EpisodeID, ByRef Status As %String)
{
	s MrNo=""
	s val = ..%IsValidMethod("DHCWMR.IO.OutService","IGetMrNoByEpisodeID")
	if (val){
		s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		s ErrMsg=""
		s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
		s Status=ErrMsg	
	}else{
		s papmi=$p(^PAADM(EpisodeID),"^",1)
		s:$d(^PAPER(papmi,"PAT",1)) MrNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmi,"",$g(%session.Data("LOGON.HOSPID")))
	}
	set:+MrNo'>0 MrNo=""
	q MrNo
}

ClassMethod GetIPFreqDispTimeStr(PHFreqDr)
{
	s FreqDispTime=""
	s val = ..%IsValidMethod("web.DHCDocOrderCommon","GetIPFreqDispTimeStr")
	if val{
		s FreqDispTime = ##class(web.DHCDocOrderCommon).GetIPFreqDispTimeStr(PHFreqDr)
	}else{
		q:PHFreqDr="" ""
		s weekflag=$P($g(^PHCFR(+$g(PHCFRrow),"DHC")),"^",1)
		s ret=""
		if weekflag=1 {
			s childsub=0  f  s childsub=$O(^PHCFR(PHFreqDr,"OPDT",childsub)) Q:childsub=""  d
			.s time=$p(^PHCFR(PHFreqDr,"OPDT",childsub),"^",1)
			.s timestr=..%ZT(time,2)
			.s week=$p(^PHCFR(PHFreqDr,"OPDT",childsub),"^",2)
			.s DispTime=timestr_" "_$p($g(^CT("DOW",1,week)),"^",1)
			.i ret="" s ret=DispTime
			.e  s ret=ret_","_DispTime
		}else{
			s childsub=0  f  s childsub=$O(^PHCFR(PHFreqDr,"DT",childsub)) Q:childsub=""  d
			.s time=$p(^PHCFR(PHFreqDr,"DT",childsub),"^",1)
			.s timestr=..%ZT(time,2)
			.s DispTime=timestr
			.i ret="" s ret=DispTime
			.e  s ret=ret_","_DispTime
		}
		Q ret
	}
	q FreqDispTime
}

/// 是不是 检验检查 退回医嘱
ClassMethod IsCallbackOrder(orderParref, orderId)
{
	s OrdItemCallback=0
	s str1 = ^OEORD(orderParref,"I",orderId,1)
	s STChildsub = $o(^OEORD(orderParref,"I",orderId,"ST",""),-1) 	;OE_OrdStatus
	s itemStatDr = $p(str1,"^",13) ,ItemStatCode=""				;OEORI_ItemStat_DR ;OEC_OrderStatus
	s:+itemStatDr>0 ItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	/*if (ItemStatCode="V"){
		s STChildsub = $o(^OEORD(orderParref,"I",orderId,"ST",STChildsub),-1) ;OE_OrdStatus
		if (STChildsub>0){
			s secondToLastStatusDr = $p(^OEORD(orderParref,"I",orderId,"ST",STChildsub),"^",3)
			s secondToLastStatusCode = $p(^OEC("OSTAT",secondToLastStatusDr),"^",1)
			i ("E"=secondToLastStatusCode){
				s OrdItemCallback = 1
			}
		}
	}*/
	s DataList=[]
	s DymObj={}
	s DymObj.OEOrdItemID =orderParref_"||"_orderId
	s DymObj.ExamID =""
	d DataList.%Push(DymObj)
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s RetSteam = ##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatusLog",Steam)
	s RetString = RetSteam.Read()
	s RetArr =[]
	s RetArr = RetArr.%FromJSON(RetString)
	s reti=0,booktime=""
	for{
		s RetObj = RetArr.%Get(reti)
		if (RetObj){
			if (RetArr.%Get(reti)."Status"="REJECT"){
				s OrdItemCallback = 1
				}
		}else{
			q
			}
		s reti=reti+1
	}

	q OrdItemCallback
}

/// 是不是护士退回
ClassMethod IsNurseCallbackOrder(orderParref, orderId)
{
	s OrdItemCallback=0,CallbackRemark = "",OEORISeeUser=""
	Set langid=..%LanguageID()
	q:0=$d(^OEORD(orderParref,"I",orderId,"NUR")) "0^"
	s SeeType = $p(^OEORD(orderParref,"I",orderId,"NUR"),"^",7)		;User.OEOrdItemExt-> OEORISeeType
	s SeeRemark = $p(^OEORD(orderParref,"I",orderId,"NUR"),"^",8)	;User.OEOrdItemExt-> OEORISeeRemark
	s OEORISeeUserDR=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",4)
	If SeeType="R"{
		s OrdItemCallback = 1
		s CallbackRemark = SeeRemark
		i OEORISeeUserDR'="" s OEORISeeUser=$p(^SSU("SSUSR",OEORISeeUserDR),"^",2)
		s OEORISeeUser =##class(User.SSUser).GetTranByDesc("SSUSRName",OEORISeeUser,langid)
	}
	q OrdItemCallback_"^"_CallbackRemark_"^"_OEORISeeUser
}

ClassMethod GetRegNoLen()
{
	s len=10
	s PATCFid=$o(^CF("PATCF",""))	
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	q len
}

ClassMethod ChartItemChange()
{
	d ##Class(websys.Lock).LockClearSession(%session.SessionId)
	q 1
}

/// Input:执行记录id
/// Output:发药数量^退药数量
ClassMethod GetDispReturnQty(OrdExeRowid)
{
	s val = ..%IsValidMethod("web.DHCSTCOMMONSRV","GetDispReturnQty")
	if val{
		QUIT ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.ord.GetDispReturnQty",OrdExeRowid) 
	}
	Q "^"
}

/// @param:  EpisodeID      就诊id
/// @param:  OEOreID 		执行记录id
/// @param:  SessionLocId   登录科室id
/// 读计费的完全控制配置,决定是不是能执行医嘱
/// @Return : 1表示能执行. 
///         FeeNotEnough : 费用不足,不能执行
///         SkinAbnorm   : 皮试医嘱结果为阳性
///         DrugSubOrder : 药品子医嘱不允许执行
/// 		PlacerNo     : 检验的医嘱,未扫条码也不允许执行
/// w ##class(web.DHCDocMainOrderInterface).IsCanExecOrdArrear("","178||238||1",114,"2020-09-24","15:10:54")
ClassMethod IsCanExecOrdArrear(EpisodeID, OEOreID, SessionLocId, execDate As %String = "", execTime As %String = "", ByRef ErrMsg As %String = "")
{
	/*s checkLocDeposit=##Class(web.UDHCJFARREARSMANAGE).CheckLoc(SessionLocId)
	if checkLocDeposit=0 {
	    s feeRetStr=""
	    s phOrdQty=$p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),"X",$p(OEOreID,"||",3))),"^",5)
	    s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, OEOreID_$c(2)_phOrdQty,"NE")
	    ;"费用不足,不能执行!"
	    i ($p(feeRetStr,"^",5)="C")&($p(feeRetStr,"^",7)="N") {
		    Quit "FeeNotEnough "
	    }
	}*/
	s ^Tempscl("IsCanExecOrdArrear")=EpisodeID_","_OEOreID_","_SessionLocId_","_execDate_","_execTime 
	Set langid=..%LanguageID()
	;判断医嘱子类为药物的子医嘱不能执行
	if (##class(web.DHCDocMain).CheckOperationPermission(OEOreID)=1) {
		s ErrMsg=..%GetErrCodeMsg("-100079")
		Q "-100079"
	}
	s skintest=$p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),5)),"^",2)
	s abnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(+OEOreID,$p(OEOreID,"||",2))
	if (skintest="Y")&&(abnorm'="N"){
		s RunExecMsg=..%GetErrCodeMsg("-100076")
		s flag = "-100076"
	}	
	s CureAppRowId=##class(DHCDoc.DHCDocCure.OutInterface).GetCureApplyByOrd($p(OEOreID,"||",1,2))
	if CureAppRowId'=""{
		s ErrMsg=..%GetErrCodeMsg("-100067")
		Quit "-100067"
	}
	if (EpisodeID=""){
		s EpisodeID=$p(^OEORD(+OEOreID),"^",1)
		s str = $g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),"X",$p(OEOreID,"||",3)))
		s ExecStateDR= $p(str,"^",16)
	    i +ExecStateDR>0 s ExecState = $p(^OEC("STAT",ExecStateDR),"^",2),ExecStateCode=$p(^OEC("STAT",ExecStateDR),"^",1)	
	    e  s ExecState = "未执行",ExecStateCode="未执行"
	    if (ExecState '= "未执行")&&(ExecStateCode '= "C") {
		    s ErrMsg=..%GetErrCodeMsg("-100051")
		    Q "-100051" //NotCF
		}
	    if (ExecStateCode= "U") {
		    s ErrMsg=..%GetErrCodeMsg(ExecStateCode)
		    Q ExecStateCode
		}
	    if (ExecStateCode= "P") {
		    s ErrMsg=..%GetErrCodeMsg(ExecStateCode)
		    Q ExecStateCode
		}
	    if (ExecStateCode= "I") {
		    s ErrMsg=..%GetErrCodeMsg(ExecStateCode)
		    Q ExecStateCode
		}
	}
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s str = ^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),"X",$p(OEOreID,"||",3))
	s ExStDate=$p(str,"^",1)
	s ExStTime = $p(str,"^",2)
	s PreErrMsg=..%Translate("ipdoc.patinfoview.csp","执行记录",langid)_"："_..%ZD(ExStDate)_" "_..%ZT(ExStTime,1)_" "
	;调护士站配置 是否需要打印后才能执行
    s prtFlag=$p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),"X",$p(OEOreID,"||",3),"NUR")),"^",1)
	if (prtFlag'["P")&&("Y"=##class(Nur.NIS.Service.OrderExcute.OrderInfo).GetLabOrdExecNeedPrintedFlag(OEOreID)){
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100080")
		Quit "-100080"
	}
	s TExEndDate = $p(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),9),"^",9) ;OEORI_EndDate 
	s TExEndTime = $p(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),9),"^",10) ;OEORI_EndTime
	//有预停日期时间，则要求执行日期时间不能大于预停日期时间
	if (TExEndDate'="")&&((TExEndDate<ExStDate)||((TExEndDate=ExStDate)&&(TExEndTime<=ExStTime))){
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100074")_..%ZD(TExEndDate)_" "_..%ZT(TExEndTime,1)
		Q "-100074"
	}	
	s SeeType = $p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),"NUR")),"^",7)		
	if (SeeType="R"){
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100062")
		Q "-100062" //NurReject
	}
	//和护士站判断一致
	s ErrCode=..CheckFeeControl(OEOreID)
	if +ErrCode'=0{
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100056")
		Q "-100056"
	}
	/*
	s orderDep=$p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),1)),"^",3)
	s phOrdQty=$p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),"X",$p(OEOreID,"||",3))),"^",5)
	s checkLocDeposit=##Class(web.UDHCJFARREARSMANAGE).CheckLoc(orderDep)
	s feeRetStr=""
	i checkLocDeposit=0 s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, OEOreID_$c(2)_phOrdQty,"NE")
	if (($p(feeRetStr,"^",5)="C")!($p(feeRetStr,"^",5)="W"))&($p(feeRetStr,"^",7)="N") {
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100056")
		Q "-100056" //FeeNotEnough
	}
	s feeflag="1"             
    i (($p(feeRetStr,"^",5)="C")!($p(feeRetStr,"^",5)="W"))&($p(feeRetStr,"^",7)="Y") {
	    s arcimId=$p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),1)),"^",2)
	    s feeflag=##Class(web.UDHCJFARREARSMANAGE).CheckOrderE(EpisodeID,$p(feeRetStr,"^",3), arcimId) 
	} 
    if feeflag="0" {
	    s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100056")
		Q "-100056" //FeeNotEnough
	}
	*/
	
	Set OrderId = +OEOreID
	Set OrdItemId = $p(OEOreID,"||",2)
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(OEOreID)
    s prtFlag=$p($g(^OEORD(OrderId,"I",OrdItemId,"X",$p(OEOreID,"||",3),"NUR")),"^",1)
	if (arcicOrderType="L")&&(prtFlag'["P") {
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100063")
		Q "-100063" //LabOrdNotPrintBar
	}
	
	Set SkinRtn = ##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(OrderId,OrdItemId)
	If (SkinRtn="Y"){
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100057")
		Quit "-100057" //SkinAbnorm
	}
	Set DrugRtn = ##class(web.DHCDocMain).CheckOperationPermission(OrderId_"||"_OrdItemId)
	If (DrugRtn=1){
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100058")
		Quit "-100058" //DrugSubOrder
	}
	s admVisitStatus=$p(^PAADM(EpisodeID),"^",20)
	Set SeeOrdRtn = ##class(web.DHCLCNUREXCUTE).GetSeeOrdInfo(OrderId,OrdItemId)
	If (SeeOrdRtn="^^")&&(AdmType="I")&&(admVisitStatus'="P"){
		s wardID=$P($g(^PAADM(EpisodeID)),"^",70)
		s ifOrdNeedSee=##class(Nur.NIS.Service.OrderExcute.Execute).ifOrdNeedSee(OrderId, OrdItemId,wardID)
		if (ifOrdNeedSee="Y"){
			s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100059")
			Quit "-100059" //NotSeeOrd
		}
	}
	;2020-07-10 V8.4版本去掉此控制，下一版本考虑护士站重新封装
	/*;非皮试且非自备药和嘱托的药品医嘱判断药房是否审核,药品未审核,不能执行
	s skintest=$p($g(^OEORD(OrderId,"I",OrdItemId,5)),"^",2)
	s OrdPriorityDR=$p(^OEORD(OrderId,"I",OrdItemId,1),"^",8)
	s PriorCode=$p($g(^OECPR(OrdPriorityDR)),"^")
	if (skintest'="Y")&&(PriorCode'="OM")&&(PriorCode'="OMST")&&(PriorCode'="OMCQZT")&&(PriorCode'="OMLSZT"){
		Set IPMonitorResult=##class(web.DHCSTINTERFACE).GetOrdIPMonitorResult(OrderId_"||"_OrdItemId)
		if (IPMonitorResult="N"){
			s ErrMsg=..%GetErrCodeMsg("-100061")
			Quit "-100061" //NotIPMonitorRtn
		}
	}*/
	if (execDate '="")&&(execTime '=""){
		s execDate=..%ZDH(execDate)
		s execTime=..%ZTH(execTime)
		;要求执行日期是当天,且执行时间小于要求执行时间,走护理组配置是否可执行
		/*
		配置已失效
		s limitExecTime=$p($g(^DHCNURSET("EXEC","LIMIT","TIMELIMIT")),"^",1)
		s limitBeforeMinutes=+$p($g(^DHCNURSET("EXEC","LIMIT","BEFORETIMELIMIT")),"^",1) //可提前执行多少分钟
		s limitBeforeSeconds=limitBeforeMinutes*60
		i (limitExecTime="true")&(((execDate<ExStDate)!((execDate=ExStDate)&(execTime+limitBeforeSeconds<ExStTime)))){
			s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100075")_" "_..%ZT(ExStTime,1)
			Q "-100075"
		}*/
		s DischargeDateTime=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",EpisodeID)
		s DischargeDate=$p(DischargeDateTime,"^",1)
		s DischargeTime=$p(DischargeDateTime,"^",2)
		if (DischargeDate'=""){
			if (execDate>DischargeDate)||((execDate=DischargeDate)&&(execTime>DischargeTime)) {
				s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100065")_":"_..%ZD(DischargeDate)_" "_..%ZT(DischargeTime,1)
				Q "-100065" //ExceedDischargeDate
			}
		}
		s OEORIDate=$p($g(^OEORD(OrderId,"I",OrdItemId,3)),"^",7)
		s OEORITime=$p($g(^OEORD(OrderId,"I",OrdItemId,1)),"^",17)
		if (execDate<OEORIDate)||((execDate=OEORIDate)&&(execTime<OEORITime)) {
			s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100066")_":"_..%ZD(OEORIDate)_" "_..%ZT(OEORITime,1)
			Q "-100066" //ExceedOEORIDate
		}
	}
	Set arcim=$p($g(^OEORD(OrderId,"I",OrdItemId,1)),"^",2)
	Set ItemCatRowId=$p($g(^ARCIM(+arcim,1,1)),"^",10)	
	Set OrderType=$P(^ARC("IC",ItemCatRowId),"^",7)
	If OrderType="L" { ;Lab
		Set PlacerNo = $p($G(^OEORD(OrderId,"I",OrdItemId,3)),"^",36)
		If (PlacerNo=""){
			Quit "PlacerNo"
		}
	}
	
	Quit 1
}

ClassMethod CheckFeeControl(OEOreID As %String)
{
	s EpisodeID=$p(^OEORD(+OEOreID),"^",1)
	s str = ^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),"X",$p(OEOreID,"||",3))
	s orderDep=$p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),1)),"^",3)
	s phOrdQty=$p($g(str),"^",5)
	s checkLocDeposit=##Class(web.UDHCJFARREARSMANAGE).CheckLoc(orderDep)
	s feeRetStr=""
	i checkLocDeposit=0 s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, OEOreID_$c(2)_phOrdQty,"NE")
	if (($p(feeRetStr,"^",5)="C")!($p(feeRetStr,"^",5)="W"))&($p(feeRetStr,"^",7)="N") {
		Q "-100056"
	}
	s feeflag="1"             
    i (($p(feeRetStr,"^",5)="C")!($p(feeRetStr,"^",5)="W"))&($p(feeRetStr,"^",7)="Y") {
	    s arcimId=$p($g(^OEORD(+OEOreID,"I",$p(OEOreID,"||",2),1)),"^",2)
	    s feeflag=##Class(web.UDHCJFARREARSMANAGE).CheckOrderE(EpisodeID,$p(feeRetStr,"^",3), arcimId) 
	} 
    if feeflag="0" {
		Q "-100056"
	}
	Q 0
}

}
