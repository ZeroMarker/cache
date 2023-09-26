Import SQLUser

Class web.DHCDocOrderVirtualLong Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// creator:nikang
/// date:20160114
/// desc:存储虚拟长期医嘱信息
/// w ##class(web.DHCDocOrderVirtualLong).InsertVirtualtLong(303,"419||1*279||30*V*^","11841","203")
ClassMethod InsertVirtualtLong(Adm As %String, ByRef OrderStr As %String, User As %String, Loc As %String) As %String
{
	S ^tmpnk("InsertVirtualtLong")=Adm_"!!!"_OrderStr
	s err=0
	s $ZT="InsertVirtualtLongErr"
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	s AdmLoc=$p(^PAADM(Adm),"^",4)
	s AdmHospDr=$P(^CTLOC(AdmLoc),"^",22)
	
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(Adm)
	q:(UserEMVirtualtLong=0)
	
	s VLRowidStr=""
	s VLOrdStr=""
	f k=1:1:$l(OrderStr,"^")-1 {
		s ArcimRowId=$p($p(OrderStr,"^",k),"*",1)
		i ArcimRowId="" continue
		s OrderItemRowId=$p($p(OrderStr,"^",k),"*",2)
		i OrderItemRowId="" continue
		s OrderVirtualtLong=""
		s OrderVirtualtLong=..GetVirtualtLongFlag(OrderItemRowId)
		;$g(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),"VIRLONG"))
		i OrderVirtualtLong'="Y" continue
		s OrderItemStatDR="",OrderItemStatDR="",OrderItemDoctorDR="",OrderItemSttDate="",OrderItemSttTime=""
		s OrderItemDate="",OrderItemTime="",OrderItemXDate="",OrderItemXTime="",OrderItemXCTCPDR=""
		s OrderLinkItemRowId=""
		s OrderRowid=+OrderItemRowId
		s itemsub=$P(OrderItemRowId,"||",2)
		s BindSource=$P($G(^OEORD(OrderRowid,"I",itemsub,"DHC")),"^",41)
		// 在滚动程序中屏蔽绑定功能，以后带出的医嘱则无法按照实时配置做校验
		// 如果在这里屏蔽绑定的医嘱，滚动程序需要修改为标准下医嘱程序，由标准接口自动带出医嘱，但如果中途配置发生变化，长期显示的绑定医嘱会与临时显示的绑定医嘱不一致。
		//continue:(BindSource'="")
		s OrderItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
		s statcode=""
		s:OrderItemStatDR'="" statcode=$p($g(^OEC("OSTAT",OrderItemStatDR)),"^",1)
		;continue:($g(statcode)'="V")&&($g(statcode)'="E")
		s OrderItemSttDate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
		s OrderItemSttTime=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",10)
		s OrderItemDate=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",7)
		s OrderItemTime=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",17)
		s OrderLinkItemRowId=$p($g(^OEORD(OrderRowid,"I",itemsub,11)),"^",39)
		S OrderItemDoctorDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",11)
		s myobj=##class(User.DHCDocOrderVirtualtLong).%New()
		d myobj.ORDVLOrdItemDRSetObjectId(OrderItemRowId)
		d myobj.ORDVLStatDRSetObjectId(OrderItemStatDR)
		d myobj.ORDVLDoctorDRSetObjectId(OrderItemDoctorDR)
		s myobj.ORDVLSttDate=OrderItemSttDate 
		s myobj.ORDVLSttTime=OrderItemSttTime
		s myobj.ORDVLDate=OrderItemDate
		s myobj.ORDVLTime=OrderItemTime
		s myobj.ORDVLLastUpdateDate=..%SysDate()
		s myobj.ORDVLLastUpdateTime=..%SysTime()
		d myobj.ORDVLOrdLinkItemDRSetObjectId(OrderLinkItemRowId)
		Set sc = myobj.%Save()
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set err = "-101"
		}
		s VLRowid=myobj.%Id()
		d myobj.%Close()
		if (VLRowidStr=""){
			s VLRowidStr=VLRowid
		}else{
			s VLRowidStr=VLRowidStr_"^"_VLRowid
		}
		if (VLOrdStr=""){
			s VLOrdStr=OrderItemRowId
		}else{
			s VLOrdStr=VLOrdStr_"^"_OrderItemRowId
		}
	}
	///医生站设置-常规设置-急诊虚拟长期-药品自动生成第二日医嘱
	s EMVirtualtLongDrugCreatNextDayOrder=..%GetConfig("EMVirtualtLongDrugCreatNextDayOrder",AdmHospDr)
	if (EMVirtualtLongDrugCreatNextDayOrder=1) {
		s NeedCreatNextDayOrderList=""
		for i=1:1:$Length(VLOrdStr,"^") {
			s OneOrd=$P(VLOrdStr,"^",i)
			continue:(OneOrd="")
			s LinkOrderItem=$p($g(^OEORD(+OneOrd,"I",$P(OneOrd,"||",2),11)),"^",39)
			s CheckOneOrd=OneOrd
			if (LinkOrderItem'=""){
				s CheckOneOrd=LinkOrderItem
			}
			s ArcimId=$p($g(^OEORD(+CheckOneOrd,"I",$P(CheckOneOrd,"||",2),1)),"^",2)
			s ItemCatRowid=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
			s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
			s OneOrdSttDate=$p($g(^OEORD(+CheckOneOrd,"I",$P(CheckOneOrd,"||",2),1)),"^",9)
			continue:(OrderType'="R")&&(OneOrdSttDate=..%SysDate())
			continue:OneOrdSttDate>+$h
			continue:($$NeedCreateExec^DHCDocEmergRollOrder(OneOrd,+$H+1)'=1)
			if (NeedCreatNextDayOrderList=""){
				s NeedCreatNextDayOrderList=OneOrd
			}else{
				s NeedCreatNextDayOrderList=NeedCreatNextDayOrderList_"^"_OneOrd
			}
		}
		
		s Ret=##Class(web.DHCDocOrderVirtualLong).CreatVirtualtLongOrd(NeedCreatNextDayOrderList,+$H+1)
		if (Ret'=""){
			s OrderStr=OrderStr_"^"_Ret
		}
	}
	///医生站设置-药房设置-急诊虚拟长期医嘱自动计算插入取药医嘱
	d ##Class(web.DHCDocOrderVirtualLong).AutoInsertOneOrdByOMST(Adm,.OrderStr)
	
	Q 0
InsertVirtualtLongErr
	b ;err
	Quit 0
}

/// /根据虚拟长期医嘱串，生成某一天的医嘱
/// /tanjishan 2020-02-22
/// w ##Class(web.DHCDocOrderVirtualLong).CreatVirtualtLongOrd("2154||114^2154||115^2154||116",65703)
ClassMethod CreatVirtualtLongOrd(itmRowIdStr As %String, today As %String) As %String
{
	k OrdListArr
	s CreatOrdStr=""
	s Len=$L(itmRowIdStr,"^")
	for i=1:1:Len {
		s itmRowId=$p(itmRowIdStr,"^",i)
		s OrdItemStr=..GetVirtualtLongOrdStr(itmRowId,today)
		continue:(+OrdItemStr<0)
		
		s OEORIDR=$P($G(^OEORD(+itmRowId,"I",$P(itmRowId,"||",2),11)),"^",39)
		if (OEORIDR'=""){
			s User=$P($G(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),7)),"^",1)
			s Loc=$P($G(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),7)),"^",2)
			
			s OrdListArr(Loc,User,OEORIDR,"Sub",itmRowId)=OrdItemStr
		}else{
			s User=$P($G(^OEORD(+itmRowId,"I",$P(itmRowId,"||",2),7)),"^",1)
			s Loc=$P($G(^OEORD(+itmRowId,"I",$P(itmRowId,"||",2),7)),"^",2)
			s OrdListArr(Loc,User,itmRowId)=OrdItemStr
		}
	}
	s Loc=""
	for {
		s Loc=$O(OrdListArr(Loc))
		q:(Loc="")
		s User=""
		for {
			s User=$O(OrdListArr(Loc,User))
			q:(User="")
			d CreatOneUserOrd
		}
	}
	
	q CreatOrdStr
CreatOneUserOrd
	s OrdItemStr=""
	s SeqNo=0
	s itmRowId=""
	for {
		s itmRowId=$O(OrdListArr(Loc,User,itmRowId))
		q:(itmRowId="")
		s EpisodeID=$P(^OEORD(+itmRowId),"^",1)
		s SeqNo=SeqNo+1
		s OrdItem=$G(OrdListArr(Loc,User,itmRowId))
		
		i OrdItem="" {
			s OrdItem=..GetVirtualtLongOrdStr(itmRowId,today)
		}
		continue:(+OrdItemStr<0)
		
		Set $p(OrdItem,"^",19)=""
		Set $p(OrdItem,"^",20)=SeqNo
		if (OrdItemStr=""){
			s OrdItemStr=OrdItem
		}else{
			s OrdItemStr=OrdItemStr_$c(1)_OrdItem
		}
		s MasterSeqNo=SeqNo
		s SubitmRowId=""
		for {
			s SubitmRowId=$O(OrdListArr(Loc,User,itmRowId,"Sub",SubitmRowId))
			q:(SubitmRowId="")
			s OrdItem=$G(OrdListArr(Loc,User,itmRowId,"Sub",SubitmRowId))
			s SeqNo=SeqNo+1
			Set $p(OrdItem,"^",19)=MasterSeqNo
			Set $p(OrdItem,"^",20)=SeqNo
			s OrdItemStr=OrdItemStr_$c(1)_OrdItem
		}
	}
	q:(OrdItemStr="") -200
	q:(EpisodeID="") -201
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(User)

	
	//s Ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpisodeID,OrdItemStr, User, Loc, DoctorID, "^^^^^^^Y")
	s Ret=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID,OrdItemStr, User, Loc, DoctorID, "^^^^^^^Y")
	if (Ret=0)||(Ret=100) {
	}else{
		if (CreatOrdStr=""){
			s CreatOrdStr=Ret
		}else{
			s CreatOrdStr=CreatOrdStr_"^"_Ret
		}
	}
	
	q
}

/// 滚动虚拟长期医嘱
/// itmRowId原始医嘱id，today需要生成的医嘱日期
/// 2020.02.20 tanjishan
/// w ##Class(web.DHCDocOrderVirtualLong).GetVirtualtLongOrdStr("30||432",+$H+1)
ClassMethod GetVirtualtLongOrdStr(itmRowId As %String, today As %String) As %String
{
	s ord=+itmRowId,itm=$P(itmRowId,"||",2)
	s EpisodeID=$P(^OEORD(ord),"^",1)
	s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
	s AdmHospDr=$P(^CTLOC(AdmLoc),"^",22)
	&SQL(select * INTO PLIST() from SQLUser.OE_OrdItem where OEORI_RowId=:itmRowId)
	q:(SQLCODE'=0) -100
	&SQL(select * INTO DHCPLIST() from SQLUser.OE_OrdItemExt where OEORI_RowId=:itmRowId)
	q:(SQLCODE'=0) -100
	s IPLongOrderStartTime=..%GetConfig("IPLongOrderStartTime",AdmHospDr)
	;按照执行记录当天首次分发时间取当天医嘱的开始时间
	;d ##class(DHCDoc.Order.Exec).GetGenTimeList(itmRowId,today,.ExecList)
	d NeedCreateExec^DHCDocEmergRollOrder(itmRowId,today,.ExecList)
	Q:'$D(ExecList(today)) -100
	s IPLongOrderStartTime=$O(ExecList(today,""))
	set entrid=PLIST(3)			         ;OEORI_OrdEnt_DR
	Set ARCIMRowid=PLIST(4)
	Set admloc=PLIST(6)		 	         ;OEORI_OrdDept_DR
	Set StatusRowid=PLIST(10)	         ;OEORI_ItemStat_DR
	Set Doc=PLIST(14)   		         ;OEORI_Doctor_DR
	Set SttDate=PLIST(17)		         ;SttDate
	Set SttTime=IPLongOrderStartTime	;..%ZT(PLIST(18))   	         ;SttTime
	Set PriorRowid=PLIST(23)	         ;OEC_Priority
	Set FreqRowid=PLIST(25)
	Set InstrRowid=PLIST(27)
	Set DoseUOMRowid=PLIST(28)
	Set DoseQtySum=PLIST(29)	 ;PhyQtyOrd	
	Set DurRowid=PLIST(35)	
	Set PhSpecInstr=PLIST(43)
	Set oeprice=PLIST(46)
	Set FirstDayTimes=PLIST(50)          ;OEORI_Qty
	Set DepProcNotes=$ListGet(PLIST(53),1)
	Set OrderCoverMainIns=PLIST(55)		 ;CoverMainIns
	Set SkinTest=PLIST(57)		         ;SkinTest
	Set SpeedFlowRate=PLIST(72)			 ;输液低速
	Set RecDepRowid=PLIST(75)
	Set OrderSeqNo=PLIST(77)
	Set DoseQty=PLIST(85)                ;DoseQty
	Set ARCOSRowid=PLIST(86)             ;ARCOS
	Set LabEpisodeNo=PLIST(88)           ;LabEpisodeNo
	Set AnaesthesiaID=PLIST(106)     ;OEORI_Anaest_DR
	Set OperationCode=PLIST(107)     ;OEORI_AnaOper_DR
	Set User=PLIST(120)	 	         ;User Add
	Set DIACatRowId=PLIST(119) 
	Set Loc=PLIST(121) 	 	         ;User Dept

	Set EpLoc=PLIST(161)		         ;OEORI_AdmLoc_Dr
	Set entrid=PLIST(139)
	Set PackQty=PLIST(154)		 ;OEORI_QtyPackUOM
	Set EndDate=PLIST(159)		         ;End Date
	Set EndTime=PLIST(160)		         ;End Time
	;Set OrderFillterNo=PLIST(163)		 ;OEORI_FillerNo
	Set ActionRowid=PLIST(209)           ;Action
	Set OrderDate=PLIST(81)
	Set OrderTime=..%ZT(PLIST(90))
	Set OrderFlowRateUnit=PLIST(125)
	Set AdmReason=PLIST(206)  
	Set OEORIOEORIDR=PLIST(230)  
	Set NotifyClinician=PLIST(248)

	;医嘱扩展表属性字段值
	Set ExecuteDateStr=DHCPLIST(3)				;OEORIExecuteDateStr
	Set PilotProRowId=DHCPLIST(12)				;OEORI_PEProject_DR
	Set OrderNeedPIVAFlag=DHCPLIST(18)			;OEORINeedPIVAFlag	
	Set OrderPackUOMRowid=DHCPLIST(15)  			;OEORIPackUOM
	Set InsurCatRowId=DHCPLIST(5)				;OEORIInsurCatDR
	Set OrderStageCode=DHCPLIST(10)				;OEORIStage
	Set OrderNutritionDrugFlag=DHCPLIST(14)		;OEORINutritionDrugFlag
	Set MaterialBarCode=DHCPLIST(16)				;OEORIMaterialNo
	Set AntUseReason=DHCPLIST(20)				;OEORITarget
	Set OrderBySelfOMFlag=DHCPLIST(35)			;OEORISelfOMFlag
	Set ExceedReasonID=DHCPLIST(68)				;OEORIExceedReasonDR
	Set OrderLocalInfusionQty=DHCPLIST(23)		;OEORILocalInfusionQty
	Set OrderOutsourcingFlag=DHCPLIST(74)		;OEORIOutsourcingFlag
	Set OEORIBindSource=DHCPLIST(78)		        ;OEORIBindSource 医嘱绑定来源
	Set ApplyArcId=DHCPLIST(79)		        	;OEORIAppReportDR
	Set ZSKMonitorLogId=DHCPLIST(81)		    ;OEORIMonitorLogId
	Set OrderFreqWeekStr=DHCPLIST(92)			;OEORI_FreqWeek
	Set OrderVirtualtLong=DHCPLIST(94)			;OEORI_VirtualtLong
	Set OrderPkgOrderNo=DHCPLIST(95)				;OEORI_PkgOrderNo
	Set OrderOpenForAllHosp=DHCPLIST(96)			;OEORI_OpenForAllHosp
	Set OrderFreqTimeDoseStr=DHCPLIST(97)
	Set OrderNurseBatchAdd=DHCPLIST(98)
	Set ImportByContingences=DHCPLIST(102)
	Set OEORIDspBatch=DHCPLIST(103)
	Set OEORIImportINCI=DHCPLIST(104)
	Set OrderFreqFreeTimeStr=DHCPLIST(108)
	
	s startdate=..%ZD(today)
	s OrderDate=..%ZD(today)
	
	s OrderAntibApplyRowid=""
	//s MRCPWString=##class(web.DHCCPW.MR.ClinicalPathWays).GetActiveCPWByadm(EpisodeID)
	//s MRCPWRowId=$p(MRCPWString,"^",1)
	
	s CPWStepItemRowId=""
	//8.4之后的版本，医嘱绑定放在了审核医嘱之前，故注释此过滤条件
	//Q:(OEORIBindSource'="") "-102"		///自动绑定的医嘱不能生成
	Q:(ApplyArcId'="") "-103"			///检查检验申请单不能生成
	Q:(DIACatRowId'="") "-104"			///治疗医嘱不生成
	q:(MaterialBarCode'="") "-105"		///高值条码不能生成
	q:(CPWStepItemRowId'="") "-106"		///临床路径不能生成
	
	s AllCount=0
	if (FreqRowid'=""){
		s FreeTimeFreqFlag=$P(^PHCFR(FreqRowid),"^",13)
		#; s child=0  
		#; for {
		#; 	s child=$O(^PHCFR(FreqRowid,"DT",child))
		#; 	Q:child=""
		#; 	s dttime=$P(^PHCFR(FreqRowid,"DT",child),"^",1)
		#; 	if (FreeTimeFreqFlag="Y"){
		#; 		continue:(("|"_OrderFreqFreeTimeStr_"|")'[("|"_dttime_"|"))
		#; 	}
		#; 	s AllCount=AllCount+1
		#; }
		s dttime=""
		for {
			s dttime=$O(ExecList(today,dttime))
			q:(dttime="")
			s AllCount=AllCount+1
		}
		///对于有频次的医嘱，如果虚拟长期首次医嘱填写了首日次数，那滚动出来的医嘱首日次数自动补全，并且按照首日次数重新计算数量
		if (FirstDayTimes'=AllCount) {
			s FirstDayTimes=AllCount
			if ((PackQty'="")){
				d SetPackQty
				s DoseQtySum=CalPackQtyArr("OrderBaseQtySum")
				s PackQty=CalPackQtyArr("OrderPackQty")
			}
		}
	}
	
	//1
	Set ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s DrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	s OrdItem=ARCIMRowid_"^"_OrderType_"^"_PriorRowid_"^"_startdate_"^"_SttTime
	s OrdItem=OrdItem_"^"_PackQty_"^"_oeprice_"^"_RecDepRowid_"^"_AdmReason_"^"_DrugFormRowid
	//11
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,AdmHospDr,ARCIMRowid)
	s MasterSeqNo=""
	s OrderSeqNo=""
	s OrdItem=OrdItem_"^"_DepProcNotes_"^"_DoseQty_"^"_DoseUOMRowid_"^"_DoseQtySum_"^"_FreqRowid
	s OrdItem=OrdItem_"^"_DurRowid_"^"_InstrRowid_"^"_PHPrescType_"^"_MasterSeqNo_"^"_OrderSeqNo
	//21
	s OrdItem=OrdItem_"^"_SkinTest_"^"_PhSpecInstr_"^"_OrderCoverMainIns_"^"_ActionRowid_"^"_ARCOSRowid
	s OrdItem=OrdItem_"^"_EndDate_"^"_EndTime_"^^"_ExecuteDateStr_"^"_NotifyClinician
	//31
	;适应症串
	s InsurSignSymptomCode=""
	s DSRowID=""
	for {
		s DSRowID=$O(^OEORD(+itmRowId,"I",$P(itmRowId,"||",2),"DSYM",DSRowID))
		q:(DSRowID="")
		s DSYMCode=$P($G(^OEORD(+itmRowId,"I",$P(itmRowId,"||",2),"DSYM",DSRowID)),"^",2)
		continue:(DSYMCode="")
		if (InsurSignSymptomCode=""){
			s InsurSignSymptomCode=DSYMCode
		}else{
			s InsurSignSymptomCode=InsurSignSymptomCode_$C(2)_DSYMCode
		}
	}
	
	s OrdItem=OrdItem_"^"_DIACatRowId_"^"_InsurCatRowId_"^"_FirstDayTimes_"^"_InsurSignSymptomCode_"^"_OrderStageCode
	s OrdItem=OrdItem_"^"_SpeedFlowRate_"^"_AnaesthesiaID_"^"_LabEpisodeNo_"^"_"^"_OrderNutritionDrugFlag
 	//41
 	s InsurApproveType=""
	s OrdItem=OrdItem_"^"_MaterialBarCode_"^^"_CPWStepItemRowId_"^"_InsurApproveType_"^"_OrderFlowRateUnit
	s OrdItem=OrdItem_"^"_OrderDate_"^"_OrderTime_"^"_OrderNeedPIVAFlag_"^"_OrderAntibApplyRowid_"^"_AntUseReason
 	//51
 	s UseReasonId=$O(^DAUP("OEORI",itmRowId,""))
	s OrdItem=OrdItem_"^"_UseReasonId_"^"_OrderLocalInfusionQty_"^"_OrderBySelfOMFlag_"^"_ExceedReasonID_"^"_OrderPackUOMRowid
	s OrdItem=OrdItem_"^"_PilotProRowId_"^"_OrderOutsourcingFlag_"^"_OEORIBindSource_"^"_ApplyArcId_"^"_DIACatRowId
	//61
	Set OrderOpenForAllHosp=$case(OrderOpenForAllHosp,"Y":"1",:"0")
	s OrderPracticePre=""
	s OrdItem=OrdItem_"^"_OperationCode_"^"_ZSKMonitorLogId_"^"_"^^"
	s OrdItem=OrdItem_"^"_"^"_OrderFreqWeekStr_"^"_OrderOpenForAllHosp_"^"_OrderPracticePre_"^"_OrderFreqTimeDoseStr
	//71
	s OrderFillterNo=itmRowId
	s OrdItem=OrdItem_"^"_"^"_"^"_"^"_OrderPkgOrderNo_"^"
	s OrdItem=OrdItem_"^"_"^"_"^"_"^"_"^"_OrderFillterNo_"^^^"_OrderFreqFreeTimeStr	
	
	q OrdItem
	//参考web.DHCOEOrdItemView中的SetPackQty
SetPackQty
	s OrderFreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrderFreqDispTimeStr(FreqRowid,OrderFreqWeekStr,OrderFreqFreeTimeStr)
	s OrderFreqDispTimeStr=$TR(OrderFreqDispTimeStr,$C(1),$C(13))
	s HOSPID=$P(^CTLOC(Loc),"^",22)
	s SessionStr=User_"^^"_Loc_"^"_HOSPID
	
	k OrdParamArr
	s OrdParamArr("EpisodeID")=EpisodeID
	s OrdParamArr("OrderPriorRowid")=PriorRowid
	s OrdParamArr("OrderARCIMRowid")=ARCIMRowid
	s OrdParamArr("OrderDoseQty")=DoseQty
	s OrdParamArr("OrderDoseUOMRowid")=DoseUOMRowid
	s OrdParamArr("OrderFreqRowid")=FreqRowid
	s OrdParamArr("OrderDurRowid")=DurRowid
	s OrdParamArr("OrderPackQty")=PackQty
	s OrdParamArr("OrderPackUOMRowid")=OrderPackUOMRowid
	s OrdParamArr("OrderStartDate")=startdate
	s OrdParamArr("OrderMultiDate")=""
	s OrdParamArr("OrderPrice")=oeprice
	s OrdParamArr("LinkedMasterOrderPriorRowid")=""
	s OrdParamArr("OrderFreqDispTimeStr")=OrderFreqDispTimeStr
	s OrdParamArr("OrderFirstDayTimes")=FirstDayTimes
	s OrdParamArr("IsNotChangeFirstDayTimeFlag")="Y"
	s OrdParamArr("IsNotNeedChangeFlag")="N"
	s OrdParamArr("OrderFreqTimeDoseStr")=OrderFreqTimeDoseStr
	
	s OrdParamArr("OrderRecDepRowid")=RecDepRowid
	s OrdParamArr("SessionStr")=SessionStr
	s OrderMasterARCIMRowid=""
	if (OEORIOEORIDR'=""){
		s OrderMasterARCIMRowid=$P(^OEORD(+OEORIOEORIDR,"I",$P(OEORIOEORIDR,"||",2),1),"^",2)
	}
	s OrdParamArr("OrderMasterARCIMRowid")=OrderMasterARCIMRowid
	
	s OrdParamJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.OrdParamArr)
	s CalPackQtyJson=##Class(web.DHCOEOrdItemView).CalPackQty(OrdParamJson)
	k CalPackQtyArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(CalPackQtyJson,.CalPackQtyArr)
	q
}

/// tanjishan 20200222
/// desc:虚拟长期自动生成相关取药医嘱
/// 参考  ##Class(web.DHCDocOrderVirtualLong).AutoInsertOneOrdByOMST(303,"419||1*279||33*V*^")
/// w ##class(web.DHCDocOrderVirtualLong).DeleteVirtualtLong()
ClassMethod AutoInsertOneOrdByOMST(EpisodeID As %String, ByRef InsertRet As %String) As %String
{
	s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	q:(PAADMType'="E") "0"
	s AdmLoc=$p(^PAADM(EpisodeID),"^",4)
	s AdmHospDr=$P(^CTLOC(AdmLoc),"^",22)
	s UserEMVirtualtLong=..%GetConfig("UserEMVirtualtLong",AdmHospDr)
	q:(UserEMVirtualtLong=0) 0
	
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	s OMPriorRowID=""	;$O(^OECPR(0,"Code","OM",0))
	s OMSTPriorRowID=""	;$O(^OECPR(0,"Code","OMST",0))
	s OMCQZTPriorRowID=$O(^OECPR(0,"Code","OMCQZT",0))
	s OMLSZTPriorRowID=$O(^OECPR(0,"Code","OMLSZT",0))
	s PriorIDList=OMPriorRowID_"^"_OMSTPriorRowID_"^"_OMCQZTPriorRowID_"^"_OMLSZTPriorRowID
	//q:(OMSTPriorRowID="") ""
	//先找到可能需要绑定取药医嘱的医嘱列表
	k OrdList,OrdRecLocList
	/*if (InsertRet'=""){
		//下医嘱直接绑定
		For i=1:1:$L(InsertRet,"^") {
	  		Set OrdItemArry=$P(InsertRet,"^",i)
	  		Set OrdId=$P(OrdItemArry,"*",2)
	  		continue:(OrdId="")
	  		s SubChild=$P(OrdId,"||",2)
	  		s PriorRowid=$p($g(^OEORD(+OrdId,"I",SubChild,1)),"^",8)
			continue:(("^"_PriorIDList_"^")'[("^"_PriorRowid_"^"))
	  		d GetAutoOMSTOrdList
		}
	}else{*/
		//有可能存在当天审核多次相同医嘱
		//滚医嘱时判断绑定
		for i=1:1:$L(PriorIDList,"^"){
			s NeedPriorRowID=$P(PriorIDList,"^",i)
			continue:(NeedPriorRowID="")
			s SubChild=0
			for {
				s SubChild=$O(^OEORDi(0,"Priority",OrderRowid,NeedPriorRowID,SubChild))
				q:(SubChild="")
				d GetAutoOMSTOrdList
			}
		}
	//}
	//判断当前取药医嘱是否满足自备药长期的用药量
	s ArcimRowid=0
	for {
		s ArcimRowid=$O(OrdList(ArcimRowid))
		q:(ArcimRowid="")
		s OrdList=$G(OrdList(ArcimRowid))
		//先获取已绑定的取药医嘱的总量
		s OneTotalQty=0
		s BindSttDat=0
		for {
			s BindSttDat=$O(^OEORDi(0,"ARCIM",OrderRowid,ArcimRowid,BindSttDat))
			q:BindSttDat=""
			s BindSubChild=0
			for {
				s BindSubChild=$O(^OEORDi(0,"ARCIM",OrderRowid,ArcimRowid,BindSttDat,BindSubChild))
				q:BindSubChild=""
				s PriorRowid=$p($g(^OEORD(OrderRowid,"I",BindSubChild,1)),"^",8)
				s PriorCode=$P(^OECPR(PriorRowid),"^",1)
				continue:(PriorCode'="ONE")
				s StatusDR=$p($g(^OEORD(OrderRowid,"I",BindSubChild,1)),"^",13)
				s StatusCode=$p($g(^OEC("OSTAT",StatusDR)),"^",1)
				continue:("VE")'[StatusCode
				//医生手工录入的取药医嘱应该也要算到计算量里面去
				//s BindSource=$P($G(^OEORD(OrderRowid,"I",BindSubChild,"DHC")),"^",41)
				//continue:(BindSource'="OMIO")
				s DSPRowId=0
				for {
					s DSPRowId=$O(^DHCOEDISQTY(0,"OEORI",OrderRowid_"||"_BindSubChild,DSPRowId))
					q:(DSPRowId="")
					s myTotalQty=$P(^DHCOEDISQTY(DSPRowId),"^",2)
					s myStatus=$p(^DHCOEDISQTY(DSPRowId),"^",7)
					s myConfirmQty=0
					if (myStatus="R"){
						s myConfirmQty=$p(^DHCOEDISQTY(DSPRowId),"^",11)
					}
					s OneTotalQty=OneTotalQty+myTotalQty-myConfirmQty
				}
			}
		}
		//在获取当前嘱托药长期用药的实际使用量
		s OMSTTotalQty=0
		for i=1:1:$L(OrdList,"^"){
			s OMSTOrderItemRowId=$P(OrdList,"^",i)
			continue:(OMSTOrderItemRowId="")
			//从执行记录出发，控制用药
			s xSub=0
			for {
				s xSub=$O(^OEORD(OrderRowid,"I",$P(OMSTOrderItemRowId,"||",2),"X",xSub))
				q:(xSub="")
				s XStatusDr=$P(^OEORD(OrderRowid,"I",$P(OMSTOrderItemRowId,"||",2),"X",xSub),"^",16)
				if (XStatusDr'=""){
					s XStatusCode=$P($G(^OEC("STAT",XStatusDr)),"^",1)
					continue:("D"[XStatusCode)
				}
				s DSPRowId=0
				for {
					s DSPRowId=$O(^DHCOEDISQTY(0,"OEORE",OMSTOrderItemRowId_"||"_xSub,DSPRowId))
					q:(DSPRowId="")
					s myTotalQty=$P(^DHCOEDISQTY(DSPRowId),"^",2)
					s myStatus=$p(^DHCOEDISQTY(DSPRowId),"^",7)
					s myConfirmQty=0
					if (myStatus="R"){
						s myConfirmQty=$p(^DHCOEDISQTY(DSPRowId),"^",11)
					}
					s OMSTTotalQty=OMSTTotalQty+myTotalQty-myConfirmQty
				}
			}
			
		}
		s OrdList(ArcimRowid,"QtyInfo")=OneTotalQty_"^"_OMSTTotalQty
	}
	///根据实际差距用量，补充取药医嘱
	s OnePriorRowID=$O(^OECPR(0,"Code","ONE",0))
	s MasterSeqNo=0
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	s InserOrdStr=""
	s ArcimRowid=0
	for {
		s ArcimRowid=$O(OrdList(ArcimRowid))
		q:(ArcimRowid="")
		s OrderItemRowId=$P(OrdList(ArcimRowid),"^",$L(OrdList(ArcimRowid),"^"))
		continue:(OrderItemRowId="")
		s SubOrd=$P(OrderItemRowId,"||",2)
		s UserAdd=$p($g(^OEORD(OrderRowid,"I",SubOrd,7)),"^",1)
		s UserDepartId=$p($g(^OEORD(OrderRowid,"I",SubOrd,7)),"^",2)
		s DocDr=$p($g(^OEORD(OrderRowid,"I",SubOrd,1)),"^",11)
		s OneTotalQty=$P($G(OrdList(ArcimRowid,"QtyInfo")),"^",1)
		s OMSTTotalQty=$P($G(OrdList(ArcimRowid,"QtyInfo")),"^",2)
		s NeddQty=OMSTTotalQty-OneTotalQty
		continue:(NeddQty<=0)
		//s ArcimBillUOMRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14)
		s ArcimBillUOMRowid=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,PAADMType)
		//s NeedPackQty=1
		s convFac=##class(appcom.OEDispensing).convFac(ArcimRowid,ArcimBillUOMRowid)
		s NeedPackQty=(NeddQty\convFac)+$CASE((NeddQty#convFac),0:0,:1)	
		
			
		Set ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
		Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		Set startdate=""
		Set starttime=""
		Set oeprice=""
		if ($L(OrdRecLocList(ArcimRowid),"^")=1) {
			Set RecDepRowid=OrdRecLocList(ArcimRowid)
		}else{
			Set RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(EpisodeID,ArcimRowid)
		}
		Set AdmReason=$p($g(^OEORD(OrderRowid,"I",SubOrd,11)),"^",18)
		Set DrugFormRowid=""
		Set DepProcNotes=""
		Set DoseQty=""
		Set DoseUOMRowid=""
		Set FreqRowid=""
		Set DurRowid=""
		Set InstrRowid=""
		Set PHPrescType=""
		Set SkinTest=""
		Set PhSpecInstr=""
		Set OrderCoverMainIns=$p($g(^OEORD(OrderRowid,"I",SubOrd,3)),"^",3)
		Set ActionRowid=""
		Set ARCOSRowid=""
		Set EndDate=""
		Set EndTime=""
		Set ExecuteDateStr=""
		Set NotifyClinician=""
		Set DIACatRowId=""
		Set InsurCatRowId=""	
		;Set PackQty=1
		;Set DoseQtySum=1
		Set PackQty=NeedPackQty
		Set DoseQtySum=NeedPackQty
		Set OrderSeqNo="1"
		Set MasterSeqNo=""
		Set AppendOrdItem=ArcimRowid_"^"_OrderType_"^"_OnePriorRowID_"^"_startdate_"^"_starttime_"^"_PackQty_"^"_oeprice
  		Set AppendOrdItem=AppendOrdItem_"^"_RecDepRowid_"^"_AdmReason_"^"_DrugFormRowid_"^"_DepProcNotes
  		Set AppendOrdItem=AppendOrdItem_"^"_DoseQty_"^"_DoseUOMRowid_"^"_DoseQtySum_"^"_FreqRowid_"^"_DurRowid_"^"_InstrRowid
  		Set AppendOrdItem=AppendOrdItem_"^"_PHPrescType_"^"_MasterSeqNo_"^"_OrderSeqNo_"^"_SkinTest_"^"_PhSpecInstr_"^"_OrderCoverMainIns
  		Set AppendOrdItem=AppendOrdItem_"^"_ActionRowid_"^"_ARCOSRowid
  		Set $p(AppendOrdItem,"^",55)=ArcimBillUOMRowid
  		Set $P(AppendOrdItem,"^",58)="VLIO"
		Set Ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpisodeID,AppendOrdItem, UserAdd, UserDepartId, DocDr, "^^^^^^^Y")
		;Set Ret=$$InsertMultiple^DHCDocOrderCommon(EpisodeID,AppendOrdItem,UserAdd,UserDepartId,DocDr,LABDATA)
		;-----
		If (Ret'=0)&&(Ret'=100){
			i (InserOrdStr=""){
				s InserOrdStr=Ret
			}else{
				s InserOrdStr=InserOrdStr_"^"_Ret
			}	
		}
	}
	i (InserOrdStr'=""){
		i (InsertRet'=""){
			s InsertRet=InserOrdStr
		}else{
			s InsertRet=InsertRet_"^"_InserOrdStr
		}	
	}
	q InserOrdStr
	
	
GetAutoOMSTOrdList
	s StatusDR=$p($g(^OEORD(OrderRowid,"I",SubChild,1)),"^",13)
	s StatusCode=$p($g(^OEC("OSTAT",StatusDR)),"^",1)
	q:("VE")'[StatusCode
	s ArcimRowid=$P($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",2)
	q:(ArcimRowid="")
	s VirLong=..GetVirtualtLongFlag(OrderRowid_"||"_SubChild)
	s FillerNo=$p(^OEORD(OrderRowid,"I",SubChild,9),"^",12)
	//只遍历虚拟长期医嘱及其生成的临时医嘱
	q:(VirLong'="Y")&&(FillerNo="")
	s OrdDeptDR=$P($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",3)
	s RecLocRowId=$P(^OEORD(OrderRowid,"I",SubChild,3),"^",6)
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	//只要启用虚拟长期医嘱，嘱托类医嘱都按照自动插入取药医嘱处理
	//s EMAutoCreatONEOrd=##Class(DHCDoc.DHCDocConfig.PHReclocAbout).GetPHRecLocAboutFieldValue(RecLocRowId,ItemCatDR,2)
	//q:(EMAutoCreatONEOrd'=1)
	s RecDepRowid=$P($G(^OEORD(OrderRowid,"I",SubChild,3)),"^",6)
	if ($D(OrdList(ArcimRowid))){
		s OrdList(ArcimRowid)=OrdList(ArcimRowid)_"^"_OrderRowid_"||"_SubChild
		if (("^"_OrdRecLocList(ArcimRowid)_"^")'[("^"_RecDepRowid_"^")){
			s OrdRecLocList(ArcimRowid)=OrdRecLocList(ArcimRowid)_"^"_RecDepRowid
		}
	}else{
		s OrdList(ArcimRowid)=OrderRowid_"||"_SubChild
		s OrdRecLocList(ArcimRowid)=RecDepRowid
	}
	q
}

/// creator:nikang
/// date:20160115
/// 20200221 tanjishan---弃用
/// desc:删除虚拟长期医嘱信息
/// w ##class(web.DHCDocOrderVirtualLong).DeleteVirtualtLong("10969356||30")
ClassMethod DeleteVirtualtLong(OrdItemStr As %String) As %String
{
	S ^tmpnk("DeleteVirtualtLong")=OrdItemStr
	s Err=0
	s $ZT="DeleteVirtualtLongErr"
	s Len=$l(OrdItemStr,"^")
	Ts
	f i=1:1:Len q:Err'=0  d
	.s OeoriRowid=$p(OrdItemStr,"^",i)
	.s OrderRowid=$p(OeoriRowid,"||",1)
	.s SubChild=$p(OeoriRowid,"||",2)
	.s ORDVLRowid=$o(^DHCDocORDVLi(0,"OrdItemDR",OeoriRowid,""))
	.q:ORDVLRowid=""
	.q:'$d(^DHCDocORDVL(ORDVLRowid))
	.s OeoriStatusDR=$p($g(^DHCDocORDVL(ORDVLRowid)),"^",2)
	.s OeoriStatusCode=$p($g(^OEC("OSTAT",OeoriStatusDR)),"^",1)
	.q:OeoriStatusCode'="I"
	.&sql(delete from SQLUser.DHCDoc_OrderVirtualtLong where ORDVL_RowID=:ORDVLRowid)
	.;i (SQLCODE'=0)&&(SQLCODE'=100) s Err=SQLCODE TrollBack  q
	.s LinkOeoriRowid=""
	.f  s LinkOeoriRowid=$o(^DHCDocORDVLi(0,"ORDLINKDR",OeoriRowid,LinkOeoriRowid)) q:((LinkOeoriRowid="")||(Err'=0))  d
	..s LinkORDVLRowid=0
	..f  s LinkORDVLRowid=$o(^DHCDocORDVLi(0,"ORDLINKDR",OeoriRowid,LinkOeoriRowid,LinkORDVLRowid)) q:((LinkORDVLRowid="")||(Err'=0))  d
	...q:LinkORDVLRowid=""
	...q:'$d(^DHCDocORDVL(LinkORDVLRowid))
	...s LinkOeoriStatusDR=$p($g(^DHCDocORDVL(LinkORDVLRowid)),"^",2)
	...s LinkOeoriStatusCode=$p($g(^OEC("OSTAT",LinkOeoriStatusDR)),"^",1)
	...q:LinkOeoriStatusCode'="I"
	...&sql(delete from SQLUser.DHCDoc_OrderVirtualtLong where ORDVL_RowID=:LinkORDVLRowid)
	...i (SQLCODE'=0)&&(SQLCODE'=100) s Err=SQLCODE q
	i Err'=0  TrollBack
	e  TC
	Q Err
DeleteVirtualtLongErr
	Quit 0
}

/// creator:nikang
/// date:20160115
/// desc:审核、停止医嘱时更新虚拟长期医嘱状态
/// 20200221 tanjishan---弃用
/// w ##class(web.DHCDocOrderVirtualLong).UpdateVirtualtLong("10969356||41&&& ^10969356||42&&&10969356||41","D")
/// w ##class(web.DHCDocOrderVirtualLong).UpdateVirtualtLong("32752||1*10756241||1542*V*^2156||1*10756241||1543*V*^8563||1*10756241||1544*V*","V")
ClassMethod UpdateVirtualtLong(OrdItemStr As %String, Status As %String, XDate As %String = "", XTime As %String = "", XUser As %String = "") As %String
{
	S ^tmpnk("UpdateVirtualtLong")=OrdItemStr_"^"_Status_"^"_XDate_"^"_XTime_"^"_XUser
	s myrtn=0
	s $ZT="UpdateVirtualtLongErr"
	if (Status="V"){
		f i=1:1:$l(OrdItemStr,"^") {
			q:myrtn'=0
			s ArcimRowId=$p($p(OrdItemStr,"^",i),"*",1)
			i ArcimRowId="" continue
			s OrderItemRowId=$p($p(OrdItemStr,"^",i),"*",2)
			i OrderItemRowId="" continue
			s ORDVLRowid=$o(^DHCDocORDVLi(0,"OrdItemDR",OrderItemRowId,""))
			continue:ORDVLRowid=""
			continue:'$d(^DHCDocORDVL(ORDVLRowid))
			s OrderItemStatDR="",OrderItemStatDR="",OrderItemDoctorDR=""
			s OrderItemDate="",OrderItemTime="",OrderItemXDate="",OrderItemXTime="",OrderItemXCTCPDR=""
			s OrderRowid=+OrderItemRowId
			s itemsub=$P(OrderItemRowId,"||",2)
			s ORDVLStatDR=$p($g(^DHCDocORDVL(ORDVLRowid)),"^",2)
			s statcode=""
			s:ORDVLStatDR'="" statcode=$p($g(^OEC("OSTAT",ORDVLStatDR)),"^",1)
			continue:(statcode'="I")
			;审核的时候传进来的如果是成组的也会包含进来
			s myrtn=$$UpdateVirtualtLong(OrderRowid,itemsub,ORDVLRowid)
		}	
		q myrtn
	}else{
		f i=1:1:$l(OrdItemStr,"^") {
			s XDocId=""
			If XUser'="" Set XDocId=$p($g(^SSU("SSUSR",XUser)),"^",14)
			s:XDocId="" myrtn="-110"
			q:myrtn'="0"
			s ORDVLRowid=$p(OrdItemStr,"^",i)
			continue:ORDVLRowid=""
			continue:'$d(^DHCDocORDVL(ORDVLRowid))
			s ORDVLStatDR=$p($g(^DHCDocORDVL(ORDVLRowid)),"^",2)
			s statcode=""
			s:ORDVLStatDR'="" statcode=$p($g(^OEC("OSTAT",ORDVLStatDR)),"^",1)
			;continue:(statcode'="V")&&(statcode'="E")
			s myrtn=$$StopVirtualtLong(ORDVLRowid,XDate,XTime,XDocId)
		}
		q myrtn
	}
UpdateVirtualtLongErr
	Quit 0
UpdateVirtualtLong(OrderRowid,itemsub,ORDVLRowid)
	TS
	s err=0
	s OrderItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	s OrderItemDate=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",7)
	s OrderItemTime=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",17)
	S OrderItemDoctorDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",11)
	s myobj=##class(User.DHCDocOrderVirtualtLong).%OpenId(ORDVLRowid)
	d myobj.ORDVLStatDRSetObjectId(OrderItemStatDR)
	d myobj.ORDVLDoctorDRSetObjectId(OrderItemDoctorDR)
	s myobj.ORDVLDate=OrderItemDate
	s myobj.ORDVLTime=OrderItemTime
	s myobj.ORDVLLastUpdateDate=..%SysDate()
	s myobj.ORDVLLastUpdateTime=..%SysTime()
	Set sc = myobj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set err = "-101"
	}
	d myobj.%Close()
	i err'=0  TrollBack
	e  TC
	q err
StopVirtualtLong(ORDVLRowid,XDate,XTime,XUser)
	s err=0
	Ts
	i XDate["/" s XDate=$zdh(XDate,4)
	i XDate["-" s XDate=$zdh(XDate,3)
	if XDate="" s XDate=..%SysDate()
	s:XTime'="" XTime=..%ZTH(XTime,2)
	s:XTime="" XTime=..%SysTime()
	s XStatDR=$o(^OEC("OSTAT",0,"Code","D",""))
	s myobj=##class(User.DHCDocOrderVirtualtLong).%OpenId(ORDVLRowid)
	d myobj.ORDVLStatDRSetObjectId(XStatDR)
	s myobj.ORDVLXDate=XDate
	s myobj.ORDVLXTime=XTime
	s myobj.ORDVLLastUpdateDate=..%SysDate()
	s myobj.ORDVLLastUpdateTime=..%SysTime()
	d myobj.ORDVLXCTCPDRSetObjectId(XUser)
	Set sc = myobj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set err = "-102"
	}
	d myobj.%Close()
	i err'=0  TrollBack
	e  TC
	q err
}

/// /// 20200221 tanjishan---弃用
/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderVirtualLong","GetVirLongOrd","144","","","","234","5","")
ClassMethod GetVirLongOrdExecute(ByRef qHandle As %Binary, Adm, StartDate As %String, EndDate As %String, CheckStop As %String = "", LogUser As %String = "", LogonLoc = "", CheckOther As %String = "", CheckAll As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    d ResetVariables5
    s ^tmpnk("GetVirLongOrdExecute")=Adm_"^"_StartDate_"^"_EndDate_"^"_CheckStop_"^"_LogUser_"^"_LogonLoc_"^"_CheckOther_"^"_CheckAll
    s adm=Adm
    k ^OrdList($j)
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s:LogonLoc="" LogonLoc=%session.Get("LOGON.CTLOCID")
	s:LogUser="" LogUser=%session.Get("LOGON.USERID")
	s myJob=$j
	K ^TMPGetVirLongOrd("VirLongOrd",LogUser)
	if CheckAll="ON"{
		;取本医疗小组下所有就诊病人ID,接口待提供
		s AdmStr=""	
	}else{
		s AdmStr=Adm	
	}
	if AdmStr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	for myloop=1:1:$l(AdmStr,"^") d
	.s adm=$p(AdmStr,"^",myloop)
	.s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d 
	..s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	...s ORDVLID=$o(^DHCDocORDVLi(0,"OrdItemDR",Oew_"||"_OrdSub,""))
	...q:(ORDVLID="")
	...q:('$d(^DHCDocORDVL(ORDVLID)))
	...s OrdDep=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",3)
	...q:OrdDep=""
	...s odt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7),otim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	... ;OEORI_Priority_DR->OEC_Priority     
	...s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	...i PriorDR="" q //ypz
	...s PriorityCode=$P(^OECPR(PriorDR),"^",1)
	...s PriorityDesc=$P(^OECPR(PriorDR),"^",2)
	...//03-27 修改缺少嘱托长期限定OMCQZT
	...q:(PriorityCode="S")||(PriorityCode="OMST")||(PriorityCode="OMCQZT")
	...s SchLoc=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",2)
	...s SchLoc=$p(SchLoc,$c(1))
	...q:(LogonLoc'="")&&(LogonLoc'=SchLoc)&&(CheckOther'="ON")
	...s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	...s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	...s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	...s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	...q:user=""
	...q:'$D(^SSU("SSUSR",user))
	...s DoctorDr=$P($g(^SSU("SSUSR",user)),"^",14)
	...q:DoctorDr="" 
	...s Notes=""
	...s truedoc=0
	...s DocLoc="" 
	...; //---------------医嘱备注------------------
	...f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	....s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	...i $G(Notes)="" s Notes=""
	...i DoctorDr'=""  s Doctor=$P($g(^CTPCP(DoctorDr,1)),"^",2) ;write doctor oeori_doctor_dr
	...e  s Doctor=""
	...s SchLoc=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",2) // + 屏蔽科室修改，取开医嘱科室 090310
	...s SchLoc=$p(SchLoc,$c(1))
    ...s DateEx="",TimeEx="" ,CPTEx=""
	...s cl=0 s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))
	...i cl=""  s cl=1
	...i $D(^OEORD(Oew,"I",OrdSub,"X",cl))  d
	....s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",19) i DateEx'="" s DateEx=$ZD(DateEx,3)  ;nursing execute
	....s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",20)  i TimeEx'=""  s TimeEx=..%ZT(TimeEx,2)
	....s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",15)
	....i CPTExDR'="" s CPTEx=$P($G(^CTPCP(CPTExDR,1)),"^",2)  
	....e  d
	.....s StopStr=##class(web.DHCLONGTIMEORD).SingNur(Oew,OrdSub)
	.....if StopStr'="" d
	......s DateEx=$P(StopStr,"|",1),TimeEx=$P(StopStr,"|",2),CPTEx=$P(StopStr,"|",3)
	...s str=""
	...;s str=##class(web.DHCTEMPOERPRINTDOC).PRX(Oew,OrdSub)
	...if str'="" d
	....s ExDoctor=$P(str,"|",3)
	....s ExDate=$P(str,"|",1)
	....s ExTime=$P(str,"|",2)
	...e  d
	....s ExDoctor=""
	....s ExDate=""
	....s ExTime=""
	...; //------------------------
	...s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	...s ARCIMRowid=$P(ArcimDR,"||",1)
	...s ARCIMSub=$P(ArcimDR,"||",2) 
	...if ARCIMRowid=0 s ^Tempzong11111=ArcimDR
	...s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(Oew_"||"_OrdSub)
	...s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderPackUOMRowid)
	...s pacunit=OrderPackUOM
	...s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	...q:(ItemCatDR="")
	...s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	...s CatDR="^"_OrdCatDR_"^"
	...s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	...s OrdCat="^"_OrdCat_"^"
	...s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name
	...s ARCIMDesc=ARCIMD 
	...s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	...//03-27 修改下边一句PhGener方法直接取desc描述
	...if OrdTyp="R"  s ARCIMDesc=##class(web.DHCLONGTIMEORD).PhGener(ARCIMRowid,ARCIMSub)
	...i ARCIMDesc["自定义嘱托"  s ARCIMDesc=$G(Notes)_"(嘱托)",Notes=""
	...s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	...if PHFreqDR'=""  d
	....s PHCFRDesc1=$P($g(^PHCFR(PHFreqDR)),"^",3) //新加入
	....s PHCFRFactor=$P($G(^PHCFR(PHFreqDR)),"^",2)
	....s ItemFreqInterval=$P($g(^PHCFR(PHFreqDR)),"^",5)
	...i (PHFreqDR'="") d
	....if $D(^PHCFR(PHFreqDR)) s PHFreq=$p($P(^PHCFR(PHFreqDR),"^",1),"(")
	....e  s PHFreq=""
	...e  s PHFreq=""  ;table       PHC_Freq
	...i PHFreq["X" d
    ....s lenPHF=$l(PHFreq)
    ....s PHFreq=$E(PHFreq,2,lenPHF)
    ...s OrderBillTypeRowid=$P($G(^OEORD(Oew,"I",OrdSub,11)),"^",18) //新加
	...s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	...i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	...e  s UOM="" 
	...s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	...if (DoseQty'="")&($P(DoseQty,"."))="" s DoseQty="0"_DoseQty
	...;药品需要把基本单位转换成等效单位
	...s DoseEqQty=""
	...if OrdTyp="R"  d
	....s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid_"||"_1)
	....s DoseEqQty=##class(web.DHCDocOrderEntry).CalEqDose(UOMDR,DrgformRowid,DoseQty)
	...if ((DoseEqQty[".")&&($P(DoseEqQty,".")="")) s DoseEqQty=0_DoseEqQty
	...s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	...s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	...i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",3)  
	...e   s Meth=""
	...s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
	...s PHCDUFactor="",During=""
	...i DurDR'="" d
	....s PHCDUFactor=$P(^PHCDU(DurDR),"^",2)
	....s During=$P(^PHCDU(DurDR),"^",3)
	...s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	...s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
	...s OrdStatDR=$p(^DHCDocORDVL(ORDVLID),"^",2)
	...i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1),OrdStatDesc=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	...e  s OrdStat="",OrdStatDesc=""  ;ord status
	...s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	...s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
    ...if SeqNo'="" d
    ....s tmpSeqNo=$P(SeqNo,"||",2) ,ARCIMDesc="______"_ARCIMDesc
    ...e  s tmpSeqNo=OrdSub
    ...s Seq1=tmpSeqNo
    ...s PackNum=""
	...s PadmTyp=$P(^PAADM(adm),"^",2)
	...s PackNum=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	...s RefundQty=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",23)
	...s numstr="",QtyStr=""
	...if $G(PackNum)'="" s PackStr=$G(PackNum)_""_$G(pacunit)
	...if $G(PhQtyOrd)'="" s QtyStr=$G(PhQtyOrd)_" "_$G(UOM)
	...if $G(PackStr)'="" s numstr=$G(PackStr)
	...e  s numstr=$G(QtyStr)
	...if PackNum="" s numstr=""
	...s xCtcpDesc="" //ypz 070802
	...s XSDate=$p(^DHCDocORDVL(ORDVLID),"^",8)
	...i XSDate'=""  s XSDate=..%ZD(XSDate) ;$ZD(XSDate,3)
	...s XSTime=$p(^DHCDocORDVL(ORDVLID),"^",9)
	...i XSTime'=""  s XSTime=..%ZT(XSTime,2)
	...s xCtcpId=$p(^DHCDocORDVL(ORDVLID),"^",10)
	...i xCtcpId'="" s xCtcpDesc=" "_$p($g(^CTPCP(xCtcpId,1)),"^",2)
	...i OrdStat="D" s Cancel="---DC"_xCtcpDesc ;Doctor //ypz 070802
	...e  s Cancel=""
    ...;s i=i+1
    ...; //------------------医嘱描述-------------------------医嘱(皮试标记)(医嘱属性)单次剂量 频次  用法   停止标记
    ...s skintest="",abnorm=""
    ...s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2) 
    ...if (skintest="Y")&(OrdStat'="D") d
    ....s skinnote=##class(web.DHCTEMPOERPRINTDOC).skinnote(Oew,OrdSub) //w !,OrdSub
    ....s abnorm=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",3)
    ....if abnorm="Y" s ARCIMDesc=ARCIMDesc_"(+)"_skinnote  //070815
    ....if abnorm="N"  s ARCIMDesc=ARCIMDesc_"(-)"_skinnote
    ...;if SeqNo'=""  s ARCIMDesc="_____"_ARCIMDesc
	...if (PriorityCode="OM")  s ARCIMDesc=ARCIMDesc_"(自备)" 
	...if PriorityCode="ONE"  s ARCIMDesc=ARCIMDesc_"(取药)"
	...i PriorityCode="OUT" d  // 药名+正包装数/剂量 用法，频次  d
	....s ARCIMDesc=ARCIMDesc_"(带药)"
	....s ARCIMDesc=ARCIMDesc_" "_$G(numstr)
	...e  i PriorityCode="ONE" d  
	....s ARCIMDesc=ARCIMDesc_" "_$G(numstr)
	...e  if PriorityCode="NORM" d
	....i DoseEqQty'=""  s ARCIMDesc=ARCIMDesc_" "_DoseEqQty_" "_$G(Meth)
	....e  s ARCIMDesc=ARCIMDesc_" "_DoseQty_""_UOM_" "_$G(Meth) 
	...s ARCIMDesc=ARCIMDesc_"  "_$G(Cancel)_$G(Notes)
	...;//--------------------------end ---------------------
	...s OrdDate=..%ZD(OrdDate) ;
	...s ^OrdList($j,adm,OrdDate,OrdTime,Oew,OrdSub)=OrdDate_"|"_..%ZT(OrdTime,2)_"|"_$G(Doctor)_"|"_ARCIMDesc_"|"_$G(ExDoctor)_"|"_$G(TimeEx)_"|"_$G(CPTEx)_"|"_$G(DateEx)_"|"_$G(OrdStatDesc)_"|"_$G(OrdStat)_"|"_$G(xCtcpDesc)_"|"_$G(XSDate)_"|"_$G(XSTime)_"|"_$G(ORDVLID)_"|"_$G(PHCFRDesc1)_"|"_$G(Notes)
	...if StTime="" s StTime=OrdTime
	...//---------------------------------------复制医嘱所需要的相关信
	...i OrdTyp="R" s OrderQty=$g(PackNum)
	...e  s OrderQty=$G(PhQtyOrd)
	...s OrderDepProcNote=$g(^OEORD(+Oew,"I",OrdSub,"DEP",1))
	...s OrderBodyPartLabel=""
	...s OrderSkinTest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",1)
	...s OrderActionRowid=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",21)
	...s OrderAction=""
	...s:OrderActionRowid'="" OrderAction=$P(^OEC("ACT",OrderActionRowid),"^",2)
	...s Str=ArcimDR_"!"_Seq2_"!"_$G(DoseQty)_$C(1)_$g(UOM)_$C(1)_UOMDR    //(Oew,OrdSub)
	...s Str=Str_"^"_$G(PHCFRDesc1)_$C(1)_PHFreqDR_$C(1)_$G(PHCFRFactor)_$C(1)_$G(ItemFreqInterval)
	...s Str=Str_"^"_$G(Meth)_$C(1)_MethDR
	...s Str=Str_"^"_$G(During)_$C(1)_DurDR_$C(1)_PHCDUFactor
	...s Str=Str_"^"_OrderQty_$C(1)_OrderPackUOM_$C(1)_OrderPackUOMRowid
	...s Str=Str_"^"_$G(PriorityDesc)_$C(1)_PriorDR
	...s Str=Str_"^"
	...;s Str=Str_"^^^^"
	...s Str=Str_"^^"_""_"^"_OrderDepProcNote_"^"_""_"^"_""
	...s Str=Str_"^^^^^^"_OrderBodyPartLabel
	...s Str=Str_"^"_OrderActionRowid_"^"_OrderAction_"^"_OrderSkinTest
	...s Str=Str_"!"_OrdTyp_"!"_OrderBillTypeRowid_"!"_"Order"
	...s ^OrdList($j,adm,OrdDate,OrdTime,Oew,OrdSub,1)=Str
	s expcount=0
	s OrdDate=""  f  s OrdDate=$O(^OrdList($j,adm,OrdDate))  q:OrdDate=""  d
	.s tim="" f  s tim=$O(^OrdList($j,adm,OrdDate,tim))  q:tim=""  d
	..s Seq1=""  f  s Seq1=$O(^OrdList($j,adm,OrdDate,tim,Seq1)) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s ORW="", DisposNurDr="",DisposNur="",DisposDate="",DisposTime="",TimeEx="",DateEx="",CPTEx=""
	....s OerdDate=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",1)
	....s OerdTime=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",2)
	....s Doctor=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",3)
	....s ARCIMDesc=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",4)
	....s ExDoctor=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",5)
	....s TimeEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",6)
	....s DateEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",8)
	....s CPTEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",7)
	....s OrdStatDescr=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",9)
	....s OrdStatCode=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",10)
	....q:OrdStatCode="U"
	....q:((CheckStop'="ON"))&&(OrdStatCode="D")
	....s xCtcpDesc=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",11)
	....s XSDate=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",12)
	....s XSTime=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",13)
	....s ORDVLRowID=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",14)
	....s OrdFreq=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",15)
	....s OrdNotes=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",16)
	....s LinkOrderItem=$p($g(^OEORD(Seq1,"I",Seq2,11)),"^",39)
	....s OrderItemRowid=Seq1_"||"_Seq2
	....i CPTEx="" s DateEx="",TimeEx=""
	....i xCtcpDesc="" s XSDate="",XSTime=""
	....s OrderMessage=$G(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2,1))
	....s OrderMessage=$tr(OrderMessage,$c(1),"#")
 	....set OerdDate1=OerdDate_" "_OerdTime
	....set DateEx=DateEx_" "_TimeEx
	....set XSDate=XSDate_" "_XSTime
	....s SeqNo=""
	....s expcount=expcount+1
	....Set ^TMPGetVirLongOrd("VirLongOrd",LogUser,myJob,expcount)=OerdDate1_"^"_ARCIMDesc_"^"_Doctor_"^"_xCtcpDesc_"^"_XSDate_"^"_OrdFreq_"^"_OrdNotes_"^"_ORDVLRowID
	....Set ^TMPGetVirLongOrd("VirLongOrd",LogUser,myJob,0)=expcount
	....set Data1=$lb(OerdDate1,OerdTime,ARCIMDesc,Doctor,DateEx,TimeEx,CPTEx,OrdStatDescr,OrdStatCode,xCtcpDesc,XSDate,OrderMessage,SeqNo,ORDVLRowID,OrdFreq,OrdNotes,myJob,LinkOrderItem,OrderItemRowid)
 	....s LinkOrderItem=$p($g(^OEORD(Seq1,"I",Seq2,11)),"^",39)  s OrderItemRowid=Seq1_"||"_Seq2
	....i LinkOrderItem="" s ^CacheTemp("DHCFindOrdItem",$j,"master",OerdDate,OrderItemRowid)=Data1
	....e  d
	.....if '$D(^CacheTemp("DHCFindOrdItem",$j,"master",OerdDate,LinkOrderItem)) d
	......s ^CacheTemp("DHCFindOrdItem",$j,"master",OerdDate,LinkOrderItem)=""
	.....s ^CacheTemp("DHCFindOrdItem",$j,"master",OerdDate,LinkOrderItem,"sub",OrderItemRowid)=Data1
	b ;1
	s SeqNo=0
	s OrdDate=0 for  s OrdDate=$O(^CacheTemp("DHCFindOrdItem",$j,"master",OrdDate)) q:OrdDate=""  d
	.s mas=0 for  s mas=$O(^CacheTemp("DHCFindOrdItem",$j,"master",OrdDate,mas)) q:mas=""  d
	.. s s1=^CacheTemp("DHCFindOrdItem",$j,"master",OrdDate,mas)
	.. i s1'="" d 
	.. .s SeqNo=SeqNo+1
	.. .s $List(s1,13)=SeqNo
	.. .s Data=s1
	.. .d OutPut
	.. s SubSeqCount=0
	.. s sub=0  for  s sub=$O(^CacheTemp("DHCFindOrdItem",$j,"master",OrdDate,mas,"sub",sub)) q:sub=""  d
	.. . s s2=^CacheTemp("DHCFindOrdItem",$j,"master",OrdDate,mas,"sub",sub)
	.. . i s1="" d
	.. . . s SeqNo= SeqNo+1
	.. . . s $List(s2,13)=SeqNo
	.. . . s Data=s2
	.. . . d OutPut
	.. . e  d
	.. . . s SubSeqCount=SubSeqCount+1
	.. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	.. . . s $List(s2,13)=SubSeqNo
	.. . . s Data=s2
	.. . . d OutPut
	
	k ^CacheTemp("DHCFindOrdItem",$j)
 	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutPut
 	;set Data=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes)
 	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
ResetVariables5
 	set (OerdDate1,OerdDate,OerdTime,ARCIMDesc,Doctor,DateEx,TimeEx,CPTEx,OrdStatDescr,OrdStatCode,xCtcpDesc,XSDate,OrderMessage,SeqNo,ORDVLRowID,OrdFreq,OrdNotes,myJob,LinkOrderItem,OrderItemRowid)=""
 	Quit
}

ClassMethod GetPrintPatInfo(EpisodeID As %String) As %String
{
	q:'$d(^PAADM(+EpisodeID)) ""
	s rtn=""
	s PatName="",LocDesc="",PatNo=""
	s LocID=$p(^PAADM(+EpisodeID),"^",4)
	s:LocID'="" LocDesc=$p($G(^CTLOC(LocID)),"^",2)
	s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	s PatID=$p(^PAADM(+EpisodeID),"^",1)
	s:PatID'="" PatName=$p($g(^PAPER(PatID,"ALL")),"^",1)
	s:PatID'="" PatNo=$p($g(^PAPER(PatID,"PAT",1)),"^",2)
	s rtn=PatName_"^"_LocDesc_"^"_PatNo
	q rtn
}

Query GetVirLongOrd(Adm As %String, StartDate As %String, EndDate As %String, CheckStop As %String = "", LogUser As %String = "", LogonLoc = "", CheckOther As %String = "", CheckAll As %String = "") As %Query(ROWSPEC = "OerdDate,OerdTime,ARCIMDesc,Doctor,DateEx,TimeEx,CPTEx,OrdStat,OrdStatCode,XCpt,XSDate,OrderMessage,SeqNo,ORDVLRowID,OrdFreq,OrdNotes,myJob,LinkOrderItem,OrderItemRowid")
{
}

ClassMethod GetVirLongOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVirLongOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetVirtualtLongFlag(OrderItemRowid)
{
	s OrderVirtualtLongFlag="N"
	s OrderVirtualtLongFlag=$p($G(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",57)
	Q OrderVirtualtLongFlag
}

Query FindEMPatOrder(EpisodeID, SessionStr, stloc, nursebill, scope, inputOrderDesc, PriorType, SortType, CatType) As websys.Query(ROWSPEC = "OrderId:%String,TItemStatCode:%String,TOeoriOeori:%String,TStDate:%String,TOrderDesc:%String,TDoctor:%String,TStopDate:%String,TStopDoctor:%String,TStopNurse:%String,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,GroupSign:%String:组符号,OrderType:%String,Priority:%String:医嘱类型,ORDVLRowID:%String,TItemStatDesc:%String:状态,ColorFlag:%String,TBillUom:%String,TStDateHide:%String,StopPermission:%String,TPriorityCode:%String,TPHFreqCode:%String,TOEORIAddDate:%String,TOEORISeeInfo:%String,TOrderName:%String,DoseQtyInfo:%String,InstrDesc:%String,FreqDesc:%String,TDuratDesc:%String,OrderPackQty:%String,SumQty:%String,OrderViewFlag:%String,PopoverHtml:%String,ZSQUrl:%String,IsCNMedItem:%String,DoctorUserDr:%String,StopDoctorUserDr:%String")
{
}

/// CreatDate:    2020.02.05
/// Description:  查找本次就诊的所有医嘱
/// Input:        EpisodeID:就诊指针, stloc:科室检索条件,nursebill:医嘱单型,scope:范围,inputOrderDesc:描述,PriorType:医嘱优先级,SortType:排序方式,CatType:分类
/// CategoryID:	  大类指针, SubsortID:子类指针
/// Return:       
/// Others:d ##class(%ResultSet).RunQuery("web.DHCDocOrderVirtualLong","FindEMPatOrder",16,77346,"",1,1,ALL)
ClassMethod FindEMPatOrderExecute(ByRef qHandle As %Binary, EpisodeID, SessionStr, stloc, nursebill, scope, inputOrderDesc, PriorType, SortType, CatType) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	s USERID=$P(SessionStr,"^",1)
	s GROUPID=$P(SessionStr,"^",2)
	s currLocId=$P(SessionStr,"^",3)
	
	i +EpisodeID'>0 set qHandle = $lb(0,repid,0) Q $$$OK
	s space = "&nbsp&nbsp",tab = space_space_space_space
	s orderParref=$o(^OEORD(0,"Adm",EpisodeID,0))
	i orderParref=""  set qHandle = $lb(0,repid,0) Q $$$OK	
	if SortType="DT"{
		Set SortByTime=1
	}else{
		Set SortByTime=0	
	}
	
	s orderId = 0 f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
	.s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopDoctor,str1,TItemStatCode,oeorioeoridr,addUserDR,TStopNurse) = ""
	.q:'$d(^OEORD(orderParref,"I",orderId,1))
	.;所有滚出来的医嘱，定义为执行记录，不在这里显示
	.s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	.s FillerNo=$p(^OEORD(+orderParref,"I",orderId,9),"^",12)
	.s MainFillerNo=""
	.s:groupdr'="" MainFillerNo=$p(^OEORD(+groupdr,"I",$P(groupdr,"||",2),9),"^",12)
	.q:(FillerNo'="")||(MainFillerNo'="")
	.s str1 = ^OEORD(orderParref,"I",orderId,1)
	.s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
	.q:((","_currLocId_",")'[(","_ordDept_","))&&((stloc=1))		;当前科室或病区
	.q:((","_currLocId_",")[(","_ordDept_","))&&((stloc=2))		;其它科室
	.//	stloc=3  时										;全部科室
	.s DoctorDr=$p(str1,"^",11)
	.s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
	.;q:(+doctor'=0)&&(doctor'=DoctorDr)
	.s PriorityDR = $p(str1,"^",8)
	.s ItmMastDR = $p(str1,"^",2)
	.Q:ItmMastDR=""
	.q:'$d(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2)))		
	.q:PriorityDR=""
	.
	.q:+ItmMastDR'>0
	.s ItemCatRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",10)
	.s OrderCatType=$P(^ARC("IC",ItemCatRowid),"^",7)
	.q:'(##Class(web.DHCDocInPatPortalCommon).MatchAliasOrd(orderParref_"||"_orderId,inputOrderDesc))
	.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	.q:'..LongOrderScope(scope,orderParref,orderId)
	.s OrdSubCateGoryStr=""
	.i CatType["||" s OrdSubCateGoryStr=##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdSubCateGoryStr(CatType)
	.Q:(("^"_OrdSubCateGoryStr_"^")'[("^"_ItemCatRowid_"^"))&&(CatType["||")
	.s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	.Q:(CatType="ALLNotDurg")&&(OrderType="R") //全部非药品
	.Q:(CatType="ALLLabAndService")&&(OrderType'="L")&&(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ItmMastDR)'="1") //全部检验检查
	.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
	.q:(nursebill="Nurse")&&('##class(web.DHCDocMainOrderInterface).IsNurseAdd(orderParref,orderId))  //护嘱单
	.s PrescNo=$p($g(^OEORD(+orderParref,"I",orderId,1)),"^",14)
	.
	.Q:(PrescNo'="")&&(##Class(web.DHCDocPrescript).IsPrescType(PrescNo)="1")&&(groupdr'="") //草药处方控制只显示一条主医嘱信息,处方明细在泡芙提示里面显示
	.s VirLong=..GetVirtualtLongFlag(orderParref_"||"_orderId)
	.;;"ALL" "S" "OM"
	.Q:(PriorType="S")&&(VirLong'="Y")
	.Q:(PriorType="OM")&&(VirLong="Y")
	.s EMStayFlag=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",17)
	.;q:(EMStayFlag'=1)
	.s rslist = ..OrderInfo(orderParref_"||"_orderId,"Summ")
	.s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	.i +groupdr>0 d //处理护士补录今天以前的长期医嘱
	..s StartDate=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",9)
	..s StartTime=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",10)
	.e  d
	..s StartDate=$p(str1,"^",9)
	..s StartTime=$p(str1,"^",10)
	.s times=StartDate*24*3600+StartTime
	.//i (PriorType="ALL") d 
	.i groupdr="" d
	..s groupdr=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",54)
	..if (+groupdr'="0")&&('$d(plist(+groupdr,times,$p(groupdr,"||",2)))) s groupdr=""
	.i groupdr s $list(rslist,4)=""
	
	.i +groupdr>0 d
	..i '$d(plist(+groupdr,times,$p(groupdr,"||",2))),((CatType["||")||(CatType="ALLNotDurg")||(CatType="ALLLabAndService")) s OrderInfo=..OrderInfo(groupdr,"Summ") s $list(OrderInfo,17)=1 s plist(+groupdr,times,$p(groupdr,"||",2))=OrderInfo
	..s plist(+groupdr,times,$p(groupdr,"||",2),"Sub", orderId) = rslist
	.e  d
	..s plist(orderParref,times,orderId) = rslist
	d ##Class(web.DHCDocInPatPortalCommon).OutputGroupOrderTime(repid,ind,.plist,SortByTime)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

ClassMethod OrderInfo(oeori, DataType) As %String
{
	if $d(%request){
		Set qLimit = $g(%request.Data("limit",1))
		Set qStart = $g(%request.Data("start",1))
		Set ^||qCount = $g(^||qCount) + 1
	}
	s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopTime,TStopDoctor,str1,str2,str3,TItemStatCode,oeorioeoridr,DoctorUserDr,TStopNurse,TdeptDesc,TRecDepDesc,TPermission,TDuratDesc1,TBillUom) = ""
	s sessionUserId=%session.Data("LOGON.USERID")
	s sessionLocId=%session.Data("LOGON.CTLOCID")
	s sessionGroupId=%session.Data("LOGON.GROUPID")
	Set langid=..%LanguageID()
	s sessionHospId=%session.Get("LOGON.HOSPID")
	
	s space = "&nbsp&nbsp",tab = "" //space_space_space_space
	s orderParref=+oeori,orderId=$p(oeori,"||",2)
	s EpisodeID=$P(^OEORD(orderParref),"^",1)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s instrDesc1="",PHFreqDesc1="",depProcNotes="",doseQty=""
	s str2 = $g(^OEORD(orderParref,"I",orderId,2))
	s doseQty = ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(oeori) //$p(str2,"^",1)	;用量 OEORI_DoseQty
	if (doseQty["-") s doseQty="("_doseQty_")"		
	s doseUnitDr= $p(str2,"^",3)	;剂量单位 OEORI_Unit_DR
	s doseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(doseUnitDr)
	s DoseQtyInfo=doseQty_doseUOM
	s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
	s:+instrDr'=0 instrDesc1=$p(^PHCIN(instrDr),"^",2)
	s instrDesc1=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrDesc1,langid)
	/*s PHFreqDr = $p(str2,"^",4)	;频次 OEORI_PHFreq_DR
	s PHFreqCode=""
	if (PHFreqDr'=""){
		s PHFreqDesc1 = $p($G(^PHCFR(PHFreqDr)),"^",3)
		s PHFreqCode = $p($G(^PHCFR(PHFreqDr)),"^",1)
		s WeekFlag=$P(^PHCFR(PHFreqDr),"^",9)
		i WeekFlag="Y" {
			s OrderFreqWeek=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",55)
			s PHFreqDesc1=PHFreqDesc1_"-"_$TR(OrderFreqWeek,"|","")
			s PHFreqCode=PHFreqCode_" "_$TR(OrderFreqWeek,"|","")
		}
	}*/
	s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(oeori,"^")
	s PHFreqDr=$List(OrdFreqInfo,1)
	s PHFreqDesc1=$List(OrdFreqInfo,2)
	s PHFreqCode=$List(OrdFreqInfo,5)
	s PHFreqDesc1=$REPLACE(PHFreqDesc1,"^","-")
	s PHFreqCode=$REPLACE(PHFreqDesc1,"^"," ")
	
	s depProcNotes = ""  ;备注 OEORI_DepProcNotes
	s depProcNotesIndex = 0
	f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
	.q:(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)="")
	.s depProcNotes = depProcNotes_space_^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
	
	s str1=^OEORD(orderParref,"I",orderId,1)
	s:$d(^OEORD(orderParref,"I",orderId,2)) str2=^OEORD(orderParref,"I",orderId,2)
	s:$d(^OEORD(orderParref,"I",orderId,3)) str3=^OEORD(orderParref,"I",orderId,3)
	;s ordDept = $p(str1,"^",3)
	s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
	s:+ordDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(ordDept)
	s:str3'="" TRecDepDR = $p(str3,"^",6)
	s:+TRecDepDR>0 TRecDepDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(TRecDepDR)
	s ItmMastDR = $p(str1,"^",2)
	s OrderName=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
	s PhSpecInstr=$p($g(^OEORD(orderParref,"I",orderId,2)),"^",8) //草药备注
	if (PhSpecInstr'="") s OrderName=OrderName_"【"_PhSpecInstr_"】"
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	s PriorityDR = $p(str1,"^",8)
	s TPriorityCode=$p(^OECPR(PriorityDR),"^",1) //医嘱类型Code
	s PriorityDesc=$p(^OECPR(PriorityDR),"^",2)
	s PriorityDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorityDesc,langid)
	s priorityTip =  $case(TPriorityCode,"OMST":$p(^OECPR(PriorityDR),"^",2),"OMCQZT":$p(^OECPR(PriorityDR),"^",2),:"")
	
	s VirLong=..GetVirtualtLongFlag(oeori)
	i (VirLong="Y")&&(DataType="Summ") {
		i TPriorityCode["ZT"{
			s TPriorityCode="OMCQZT"
		}elseif (TPriorityCode["OM"){
			s TPriorityCode="OMST"
		}else{
			s TPriorityCode="S"
		}
		s POEType=$p(^OECPR(+$O(^OECPR(0,"Code",TPriorityCode,0))),"^",2)
		s POEType=##class(User.OECPriority).GetTranByDesc("OECPRDesc",POEType,langid)
	}else{
		s POEType=PriorityDesc
	}

	s TDuratDR="" 
	s:str2'="" TDuratDR = $p(str2,"^",6) 
	s:TDuratDR'="" TDuratDesc1 = $p(^PHCDU(TDuratDR),"^",3)	
	s TDuratDesc1=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",TDuratDesc1,langid)
	s OrdItemCallback=##class(web.DHCDocMainOrderInterface).IsCallbackOrder(orderParref,orderId)
	s OrdItemCallback=$case(OrdItemCallback,1:"<font color=red>("_..%Translate("doc.virlongorder.hui.csp","退回")_")</font>",:"")
	s OrdNurseCallbackret = ##class(web.DHCDocMainOrderInterface).IsNurseCallbackOrder(orderParref,orderId)
	//s OrdNurseCallback = $case(+OrdNurseCallback,1:"<font color=red>(护士退回:"_$P(OrdNurseCallback,"^",2)_")</font>",:"")
	if (+OrdNurseCallbackret=1){
		s OrdNurseCallback="<font color=red>("_$P(OrdNurseCallbackret,"^",3)_..%Translate("doc.virlongorder.hui.csp","退回")
		if $P(OrdNurseCallbackret,"^",2)'=""{
			s OrdNurseCallback=OrdNurseCallback_":"_$P(OrdNurseCallbackret,"^",2)
		}
		s OrdNurseCallback=OrdNurseCallback_")</font>"
	}else{
		s OrdNurseCallback=""
	}
	
	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(orderParref_"||"_orderId)
	s oeorioeoridr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	s TStDate=$p(str1,"^",9)
	s FirstDayTimes=$P(str1,"^",18)
	s FirstDayTimesDesc=""
	if (VirLong="Y")&&(FirstDayTimes'="")&&(oeorioeoridr=""){ //(TStDate>=..%SysDate())&&(FirstDayTimes'="")&&(oeorioeoridr=""){
		s FirstDayTimesDesc=..%Translate("doc.virlongorder.hui.csp","首日:")_FirstDayTimes
	}
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s PrescNotes=""
	s PrescCookMode=""
	s ARCOSName=""
	i (oeorioeoridr="") d
	.s PrescNo=$p(^OEORD(+orderParref,"I",orderId,1),"^",14)
	.s PrescRowid=""
	.i PrescNo'="" s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,""))
	.i PrescRowid'="" d
	..s PrescCookModeDr=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",15)
	..i PrescCookModeDr'="" s PrescCookMode=$p($g(^DHCDocConfig("CookMode",PrescCookModeDr)),"^",2)
	..s PrescNotes=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",21)
	
	..s ARCOSRowId=$p($g(^PAQUE1(PrescRowid,"DHC")),"^",24)
	..i ARCOSRowId'="" s ARCOSName=$P($g(^ARCOS(ARCOSRowId)),"^",2)
	
    i depProcNotes="" s depProcNotes=PrescNotes
    s TBillUom = ##class(web.DHCDocMainOrderInterface).GetBillUom(+ItmMastDR,$p(ItmMastDR,"||",2))
    s TBillUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",TBillUom,langid)
    s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ItmMastDR)
	if (CheckCHNFlag="Y") {
		s Phcdf=$P($g(^ARCIM(+ItmMastDR,$P(ItmMastDR,"||",2),1)),"^",12)
		if Phcdf'="" s BillUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4),TBillUom=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid)
	}
    //药品临时医嘱显示总数量
    s SumQty=""
    s OrdPackQtyInfo=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(oeori)
	s PackUOMDesc=$p(OrdPackQtyInfo,"^",2)
	s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
	s OrderPackQty=$p(OrdPackQtyInfo,"^",1) 
	if (+OrderPackQty'=0){
		s OrderPackQty=OrderPackQty_PackUOMDesc
	}else{
		s OrderPackQty=""
	}
	s SumQty=OrderPackQty //_PackUOMDesc
    
    if ((VirLong="Y")&&(DataType="Summ")){
	    ;整包装数量(医嘱录入界面数量)
		//s OrderPackQty=$p(OrdPackQtyInfo,"^",1)
		s OrderPackQty=$p($g(^OEORD(orderParref,"I",orderId,9)),"^",4)
		if (CheckCHNFlag'="Y") {
			s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(orderParref_"||"_orderId)
			s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
		}else{
			s PackUOMDesc=TBillUom
		}
	    if (+OrderPackQty'=0){
			s OrderPackQty=OrderPackQty_PackUOMDesc
	    }
	}
	;输液滴速
	s SpeedFlowRate=$p($g(^OEORD(orderParref,"I",orderId,3)),"^",17)
	;输液滴速单位
	s FlowRateUnit=""
	s FlowRateUnitDR=$p($g(^OEORD(orderParref,"I",orderId,6)),"^",8)
	s:FlowRateUnitDR'="" FlowRateUnit=$P($G(^OEC("SFR",FlowRateUnitDR)),"^",2)
	s FlowRateUnit=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",FlowRateUnit,langid)
	s SpeedFlowStr=""
	s:SpeedFlowRate'="" SpeedFlowStr=..%Translate("doc.virlongorder.hui.csp","滴速:")_SpeedFlowRate_FlowRateUnit
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ItmMastDR,""))
	if (DARCIMRowid'=""){
		//自定义描述医嘱
		s CustomDescOrd=$P(^DHCItmMast(DARCIMRowid),"^",24)
		if (depProcNotes'="")&&(CustomDescOrd="Y"){
			s OrderName=""
		}
	}
	s TOrderDesc=OrdNurseCallback_space_OrderName_space_DoseQtyInfo_space_instrDesc1_space_PHFreqDesc1 //_space_TDuratDesc1
	if '##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR) {
		s TOrderDesc=TOrderDesc_space_TDuratDesc1
	}
	i PrescCookMode'="" s TOrderDesc=TOrderDesc_space_PrescCookMode
	i SumQty'="",VirLong'="Y" {
		s BloodReqFormNo=##CLASS(DHCLIS.DHCBloodInterface).GetReqFormNo(orderParref_"||"_orderId)
		i $p(BloodReqFormNo,"^")="-1" s TOrderDesc=TOrderDesc_space_..%Translate("doc.virlongorder.hui.csp","共:")_SumQty
	}
	if (ARCOSName'="")&&(oeorioeoridr=""){
		s TOrderDesc=TOrderDesc_space_ARCOSName
	}
	s TOrderDesc=TOrderDesc_space_FirstDayTimesDesc_space_depProcNotes_space_priorityTip_space_OrdItemCallback_space_ReqPartDesc_space_SpeedFlowStr   //_space_OrdItemCallback
	s TOrderName=OrdNurseCallback_space_OrderName_space_PrescCookMode_space_FirstDayTimesDesc_space_depProcNotes_space_OrdItemCallback_space_ReqPartDesc_space_SpeedFlowStr
	s TOrderDesc=$$ChekcNUll(TOrderDesc,space)
	s TOrderName=$$ChekcNUll(TOrderName,space)
	i $d(^OEORD(orderParref,"I",orderId,1))=1 s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	s:+$g(DoctorDr)>0 TDoctor = $p(^CTPCP(DoctorDr,1),"^",2),DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
	Set TDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TDoctor,langid)
	///虚拟长期医嘱记录id
	s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",oeori,0))
	if (ORDVLRowID="")&&(oeorioeoridr'=""){
		//自动绑定的医嘱没有长期医嘱记录表，但是状态需要跟随主医嘱处理
		s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",oeorioeoridr,0))
	}
	if (ORDVLRowID'="")&&(DataType="Summ"){
		
		s itemStatDr=$P(^DHCDocORDVL(ORDVLRowID),"^",2)
		s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
		s StopDoctorDR = $P(^DHCDocORDVL(ORDVLRowID),"^",10)
		
		s TStDate=$p(^DHCDocORDVL(ORDVLRowID),"^",5)
		s TStTime=$p(^DHCDocORDVL(ORDVLRowID),"^",6)
		s StopDoctorDR = $P(^DHCDocORDVL(ORDVLRowID),"^",10)
		if (TItemStatCode="D"){
			s TStopDate = $p(^DHCDocORDVL(ORDVLRowID),"^",8)		;ORDVL_XDate
			s TStopTime = $p(^DHCDocORDVL(ORDVLRowID),"^",9) 		;ORDVL_XTime
		}else{
			s TStopDate="",TStopTime=""
		}
		s TExEndDate = $p(^DHCDocORDVL(ORDVLRowID),"^",14)			;ORDVL_EndDate
		s TExEndTime = $p(^DHCDocORDVL(ORDVLRowID),"^",15) 			;ORDVL_EndTime
	}else{
		s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus	
		s StopDoctorDR = $p(^OEORD(orderParref,"I",orderId,3),"^",29)
		
		s TStDate=$p(str1,"^",9)
		s TStTime=$p(str1,"^",10)
		s TStopDate = $p(^OEORD(orderParref,"I",orderId,3),"^",34)		;XDate
		s:$d(^OEORD(orderParref,"I",orderId,2)) TStopTime = $p(^OEORD(orderParref,"I",orderId,2),"^",15)		;XTime
		s TExEndDate = $p(^OEORD(orderParref,"I",orderId,9),"^",9)		;OEORI_EndDate	
		s TExEndTime = $p(^OEORD(orderParref,"I",orderId,9),"^",10) 	;OEORI_EndTime
	}
	s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",oeori,0))
	s TStDate = ..%ZD(TStDate) //$zd($p(str1,"^",9),3)
	s TStTime = ..%ZT(TStTime,1)
	s TStopDate = $s(TStopDate="":TExEndDate, 1:TStopDate)			;没停止日期时,取预停日期	
	s TStopTime = $s(TStopTime="":TExEndTime, 1:TStopTime)
	
	s:TStopDate'="" TStopDate=..%ZD(TStopDate) //$zd(TStopDate,3)
	s:TStopTime'="" TStopTime=..%ZT(TStopTime,2) 
	s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	s userUpdateDr=$p($g(^OEORD(orderParref,"I",orderId,8)),"^",12)
	s:(+userUpdateDr>0)&&(TExEndDate'="") TStopDoctor = $p(^SSU("SSUSR",userUpdateDr),"^",2)	;预停医生
	s:+StopDoctorDR>0 TStopDoctor = $p(^CTPCP(StopDoctorDR,1),"^",2)	;重新覆盖停医嘱医生
	Set TStopDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TStopDoctor,langid)
	s StopDoctorUserDr=""
	s:+StopDoctorDR>0 StopDoctorUserDr = $O(^SSU("SSUSR",0,"CTPCP",StopDoctorDR,0))
	s TStDateHide=TStDate,TStTimeHide=TStTime
	if (+oeorioeoridr>0){
		s TOrderDesc = tab_TOrderDesc,TOrderName = tab_TOrderName,TStDate="",TStTime=""
	}
	s OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	s prescNo=$p(^OEORD(+orderParref,"I",orderId,1),"^",14)
	if (prescNo'="")&&(##Class(web.DHCDocPrescript).IsPrescType(prescNo)=1){
		s OEORINotifyClinician=##class(web.DHCSTPCHCOLLS).GetEmy(prescNo)
	}
	s OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"<font color=red>"_..%Translate("doc.virlongorder.hui.csp","急")_"</font>",:"")
	s:+itemStatDr>0 TItemStatDesc = $p(^OEC("OSTAT",itemStatDr),"^",2)
	s TItemStatDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",TItemStatDesc,langid)
	s TOrderDesc = OEORINotifyClinician_"&nbsp"_TOrderDesc
	s TOrderName = OEORINotifyClinician_"&nbsp"_TOrderName
	s SkinInfo=##Class(web.DHCDocInPatPortalCommon).GetSkinInfo(oeori,sessionHospId,langid)
	if (SkinInfo'=""){
		s TOrderDesc = SkinInfo_"&nbsp"_TOrderDesc
		s TOrderName = SkinInfo_"&nbsp"_TOrderName
	}
	s DCARowId=$o(^DHCDocCure(0,"OEORI",oeori,""))
	if (+DCARowId>0){
		s Status=$p($g(^DHCDocCure(DCARowId)),"^",3)
		if Status="C"{
			s TOrderDesc="<font color=red>"_..%Translate("doc.virlongorder.hui.csp","(治疗站取消)")_"</font>"_"&nbsp"_TOrderDesc
			s TOrderName="<font color=red>"_..%Translate("doc.virlongorder.hui.csp","(治疗站取消)")_"</font>"_"&nbsp"_TOrderName
		}
	}
	;需要展示的医嘱状态 停止 撤销 作废 未审核
	/*
	if ((TItemStatCode="C")||(TItemStatCode="U")||(TItemStatCode="D")||(TItemStatCode="I"))   d
	.s STChildSub=$o(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",""),-1)
	.if (STChildSub'="") d
	..s STReasonDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",STChildSub)),"^",7)
	..i STReasonDR'="" s STReasonComtent=$p($g(^OEC("ASCR",STReasonDR)),"^",2)
	..e  s STReasonComtent=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",STChildSub)),"^",8)
	..i STReasonComtent'="" s TItemStatDesc=TItemStatDesc_"("_STReasonComtent_")"
	.s TOrderDesc = "<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderDesc
	.s TOrderName = "<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderName
	*/
	s ValARCItem=##Class(web.DHCDocOrderEntry).ValARCItem(ItmMastDR)
	if (ValARCItem=1){
		s TOrderDesc = "<font color=red>"_..%Translate("doc.virlongorder.hui.csp","(医嘱项已停用)")_"</font>"_TOrderDesc
		s TOrderName = "<font color=red>"_..%Translate("doc.virlongorder.hui.csp","(医嘱项已停用)")_"</font>"_TOrderName
	}
	s OrderStage=$p($G(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",8)
	s OrderStage=$CASE(OrderStage,"SZ":"术中","SQ":"术前","SH":"术后","CZ":"产中","":"")
	s OrderStage=..%Translate("doc.virlongorder.hui.csp",OrderStage)
	i OrderStage'=""{
		s TOrderDesc = TOrderDesc_"&nbsp"_OrderStage	
		s TOrderName = TOrderName_"&nbsp"_OrderStage	
	}
	s DischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(ItmMastDR,sessionHospId)
	if (DischargeOrdFlag=2){
		s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
		s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	    i DeceasedDate'="" {
		    s DeceasedDate=..%ZD(DeceasedDate)
		    i DeceasedTime'="" s DeceasedTime=..%ZT(DeceasedTime,2)
			s TOrderDesc = TOrderDesc_"&nbsp"_..%Translate("doc.virlongorder.hui.csp","死亡时间:")_DeceasedDate_" "_DeceasedTime	
			s TOrderName = TOrderName_"&nbsp"_..%Translate("doc.virlongorder.hui.csp","死亡时间:")_DeceasedDate_" "_DeceasedTime
	    }
	}
		
	s OEORIDate=..%ZD($p(str3,"^",7))
	s OEORITime=..%ZT($p(str1,"^",17),1)
	s OEORIAddDate=OEORIDate_" "_OEORITime
	s StopPermission=##class(web.DHCDocMain).CheckStopOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s TOrderDesc=##class(web.DHCDocUtil).EvalJSON(TOrderDesc)
	s OEORISeeDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",5) //获取处理日期
	s OEORISeeInfo=""
	if (OEORISeeDate'=""){
		s OEORISeeUser=""
		s OEORISeeType=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",7)
		s OEORISeeRemark=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",8)
		s OEORISeeUserDR=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",4)
		i OEORISeeUserDR'="" s OEORISeeUser=$p(^SSU("SSUSR",OEORISeeUserDR),"^",2)
		s OEORISeeType=$case(OEORISeeType,"F":"完成","A":"接受","R":"拒绝",:"")
		s OEORISeeType=..%Translate("doc.virlongorder.hui.csp",OEORISeeType)
		s OEORISeeInfo=OEORISeeUser_":"_OEORISeeType
		if (OEORISeeRemark'=""){
			s OEORISeeInfo=OEORISeeInfo_","_OEORISeeRemark
		}
	}
	s OrderViewFlag=##Class(web.DHCDocInPatPortalCommon).GetOrderViewFlag(ItmMastDR,oeori)
	s IsCMPresType=0
	s PrescNo=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",14)
	if PrescNo'=""{ //草药处方泡芙显示
		s IsCMPresType = ##Class(web.DHCDocPrescript).IsPrescType(PrescNo)
	}
	s PopoverHtml=""
	if (IsCMPresType=1){
		//获取医嘱泡芙提示信息
		s PopoverHtml=##class(web.DHCOEOrdItem).GetOrderPopoverInfo(oeori,TOrderDesc)
	}
	s ZSQUrl=##class(web.DHCDocService).GetLinkMesageZSQ(ItmMastDR,oeori_"^^^")
	s ZSQUrl=$P(ZSQUrl,"^",3)
	s IsCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(ItmMastDR)
	q $lb(orderParref_"||"_orderId,TItemStatCode,oeorioeoridr,TStDate_" "_TStTime,TOrderDesc,TDoctor,TStopDate_" "_TStopTime,TStopDoctor,TStopNurse,TdeptDesc,TRecDepDesc,orderParref_"||"_orderId,"",OrderType,POEType,ORDVLRowID,TItemStatDesc,0,TBillUom,TStDateHide_" "_TStTimeHide,StopPermission,TPriorityCode,PHFreqCode,OEORIAddDate,OEORISeeInfo,TOrderName,DoseQtyInfo,instrDesc1,PHFreqDesc1,TDuratDesc1,OrderPackQty,SumQty,OrderViewFlag,PopoverHtml,ZSQUrl,IsCNMedItem,DoctorUserDr,StopDoctorUserDr)
ChekcNUll(indesc,inspace)
	s artnstr=""
	for icnull=1:1:$L(indesc,inspace)
	{
		s subdesc=$P(indesc,inspace,icnull)
		continue:subdesc=""
		if artnstr="" s artnstr=subdesc
		else  s artnstr=artnstr_inspace_subdesc
	}
	Q:artnstr="" indesc
	q artnstr
}

/// @param: scopeId 	1 全部   非作废, 
/// 					3 当前   为所有未停医嘱和停止时间迟于当前系统时间的医嘱 
/// 					5 已停止
/// 修改可参考##class(web.DHCDocMainOrderInterface).LongOrderScope()
ClassMethod LongOrderScope(scope, orderParref, orderId) As %String
{
	s oeorioeoridr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	///虚拟长期医嘱记录id
	s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",orderParref_"||"_orderId,0))
	s VirLong=..GetVirtualtLongFlag(orderParref_"||"_orderId)
	if (ORDVLRowID="")&&(oeorioeoridr'=""){
		//自动绑定的医嘱没有长期医嘱记录表，但是状态需要跟随主医嘱处理
		s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",oeorioeoridr,0))
	}
	if (ORDVLRowID=""){
		s itemStatDr = $p(^OEORD(orderParref,"I",orderId,1),"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus	
		
		s StartDate=$p(^OEORD(orderParref,"I",orderId,1),"^",9)
		s TStopDate = $p(^OEORD(orderParref,"I",orderId,3),"^",34)		;XDate
		s TStopTime = $p($G(^OEORD(orderParref,"I",orderId,2)),"^",15)		;XTime
		
	}else{
		s itemStatDr=$P(^DHCDocORDVL(ORDVLRowID),"^",2)
		
		s StartDate=$p(^DHCDocORDVL(ORDVLRowID),"^",5)
		s StTime=$p(^DHCDocORDVL(ORDVLRowID),"^",6)
		s TStopDate = $p(^DHCDocORDVL(ORDVLRowID),"^",8)		;ORDVL_XDate
		s TStopTime = $p(^DHCDocORDVL(ORDVLRowID),"^",9) 		;ORDVL_XTime
		
	}
	s:+itemStatDr>0 itemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	q:(scope=1)&&(itemStatCode="U") 0			//全部时不显示作废的
	q:(scope=3)&&((itemStatCode'="V")&&(itemStatCode'="D")&&(itemStatCode'="E")) 0
	q:(scope=3)&&((itemStatCode="D")&&((TStopDate=..%SysDate())&&(TStopTime<..%SysTime())||(ORDVLRowID=""))) 0		//当前 当天停止 不是核实的
	q:(scope=3)&&((itemStatCode="D")&&(TStopDate<+$H)) 0
	q:(scope=5)&&((itemStatCode'="D")&&(itemStatCode'="C")) 0
	s PriorityDR=$p(^OEORD(orderParref,"I",orderId,1),"^",8)
	if (VirLong="Y"){
		s IsLongPrior=1
	}
	///scope=6   今日有效。开始日期为当天的核实或执行状态的医嘱，核实或执行状态的长期医嘱,停止日期为当天的长期医嘱
	q:(scope=6)&&((IsLongPrior'=1)&&(((itemStatCode'="V")&&(itemStatCode'="E"))||(StartDate<(+$h)))) 0
	q:(scope=6)&&((IsLongPrior=1)&&((((itemStatCode="D")||(itemStatCode="C"))&&(TStopDate<+$H))||(itemStatCode="U"))) 0
	q:(scope=7)&&((IsLongPrior'=1)&&(((itemStatCode'="V")&&(itemStatCode'="E"))||(StartDate<(+$h-2)))) 0
	q:(scope=7)&&((IsLongPrior=1)&&(((itemStatCode="D")||(itemStatCode="C"))&&(TStopDate<(+$H-2)))||(itemStatCode="U")) 0
	s OEORISeeDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",5) //获取处理日期
	
	q 1
}

Query FindOrdItem(oeori) As websys.Query(ROWSPEC = "OrderId:%String,TItemStatCode:%String,TOeoriOeori:%String,TStDate:%String,TOrderDesc:%String,TDoctor:%String,TStopDate:%String,TStopDoctor:%String,TStopNurse:%String,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,GroupSign:%String:组符号,OrderType:%String,Priority:%String:医嘱类型,ORDVLRowID:%String,TItemStatDesc:%String:状态,ColorFlag:%String,TBillUom:%String,TStDateHide:%String,StopPermission:%String,TPriorityCode:%String,TPHFreqCode:%String,TOEORIAddDate:%String,TOEORISeeInfo:%String,TOrderName:%String,DoseQtyInfo:%String,InstrDesc:%String,FreqDesc:%String,TDuratDesc:%String,OrderPackQty:%String,SumQty:%String,OrderViewFlag:%String,PopoverHtml:%String,ZSQUrl:%String,IsCNMedItem:%String")
{
}

/// CreatDate:    2020.02.05
/// Description:  查找医嘱关联的所有医嘱
/// Return:       
/// Others:d ##class(%ResultSet).RunQuery("web.DHCDocOrderVirtualLong","FindOrdItem","284||48")
ClassMethod FindOrdItemExecute(ByRef qHandle As %Binary, oeori) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	i (oeori="") set qHandle = $lb(0,repid,0) Q $$$OK
	i (oeori'["||") set qHandle = $lb(0,repid,0) Q $$$OK
	s oeorioeoridr = $p(^OEORD(+oeori,"I",$P(oeori,"||",2),11),"^",39)
	if (oeorioeoridr'=""){
		s oeori=oeorioeoridr
	}
	s FillerNo=$p(^OEORD(+oeori,"I",$P(oeori,"||",2),9),"^",12)
	if (FillerNo'=""){
		s oeori=FillerNo
	}
	s ID=oeori
	d GetOrderInfo
	s Sub=0
	for {
		s Sub=$O(^OEORDi(0,"OEORI",+oeori,oeori,Sub))
		q:(Sub="")
		s ID=+oeori_"||"_Sub
		d GetOrderInfo
	}
	s Sub = 0 
	for {
		s Sub=$O(^OEORD(+oeori,"I",Sub))
		q:(Sub="")
		s FillerNo=$p($G(^OEORD(+oeori,"I",Sub,9)),"^",12)
		if (FillerNo'=oeori){
			continue
		}
		s ID=+oeori_"||"_Sub
		d GetOrderInfo
		s FillerSub=0
		for {
			s FillerSub=$O(^OEORDi(0,"OEORI",+oeori,+oeori_"||"_Sub,FillerSub))
			q:(FillerSub="")
			s ID=+oeori_"||"_FillerSub
			d GetOrderInfo
		}
	}
	d ##Class(web.DHCDocInPatPortalCommon).OutputGroupOrderTime(repid,ind,.plist,"1")
	set qHandle = $lb(0,repid,0)
	Q $$$OK
GetOrderInfo
	s rslist = ..OrderInfo(ID,"Detail")
	s groupdr = $p(^OEORD(+ID,"I",$P(ID,"||",2),11),"^",39)
	i +groupdr>0 d //处理护士补录今天以前的长期医嘱
	.s StartDate=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",9)
	.s StartTime=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",10)
	e  d
	.s StartDate=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",9)
	.s StartTime=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",10)
	s times=StartDate*24*3600+StartTime
	//i (PriorType="ALL") d 
	i groupdr="" d
	.s groupdr=$p($g(^OEORD(+ID,"I",$P(ID,"||",2),"DHC")),"^",54)
	.if (+groupdr'="0")&&('$d(plist(+groupdr,times,$p(groupdr,"||",2)))) s groupdr=""
	i groupdr s $list(rslist,4)=""

	i +groupdr>0 d
	.i '$d(plist(+groupdr,times,$p(groupdr,"||",2))),((CatType["||")||(CatType="ALLNotDurg")||(CatType="ALLLabAndService")) s OrderInfo=..OrderInfo(groupdr,"Detail") s $list(OrderInfo,17)=1 s plist(+groupdr,times,$p(groupdr,"||",2))=OrderInfo
	.s plist(+groupdr,times,$p(groupdr,"||",2),"Sub", ID) = rslist
	e  d
	.s plist(+ID,times,$P(ID,"||",2)) = rslist
	q
}

/// Creator:      tanjishan
/// CreatDate:    2020.03.09
/// Description:  急诊停止医嘱权限控制
ClassMethod CheckStopOrder(OrderItemRowId As %String, UserRowId As %String, LocID As %String, GroupID As %String = "", ExDate = "", ExTime = "", ByRef ErrMsg As %String = "", ByRef StopExecStr As %String = "", IncludeStopDateOrd As %String = "")
{
	s ^tempscl("CheckStopOrder")=OrderItemRowId_","_UserRowId_","_LocID_","_GroupID_","_ExDate_","_ExTime
	s StopOrdStr=""
	s:ExDate'="" ExDate=..%ZDH(ExDate),CheckExDate=ExDate
	e  s CheckExDate=..%SysDate() //ExDate=..%SysDate()
	i ExTime'="" s ExTime=..%ZTH(ExTime),CheckExTime=ExTime
	e  s CheckExTime=..%SysTime() //ExTime=..%SysTime()
	///虚拟长期医嘱记录id
	s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",OrderItemRowId,0))
	if (ORDVLRowID'=""){
		s itemStatDr=$P(^DHCDocORDVL(ORDVLRowID),"^",2)
		s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
		if (TItemStatCode="D"){
			s ErrMsg="医嘱已停止!"
			Q 0
		}
		s SubSttDate = CheckExDate-1 //ExDate-1
		for {
			s SubSttDate=$O(^OEORDi(0,"StDtTm1",+OrderItemRowId,SubSttDate))
			q:(SubSttDate="")
			s SubStTtim=""
			for {
				s SubStTtim=$O(^OEORDi(0,"StDtTm1",+OrderItemRowId,SubSttDate,SubStTtim))
				q:(SubStTtim="")
				s Sub=0
				for {
					s Sub=$O(^OEORDi(0,"StDtTm1",+OrderItemRowId,SubSttDate,SubStTtim,Sub))
					q:(Sub="")
					s FillerNo=$p($G(^OEORD(+OrderItemRowId,"I",Sub,9)),"^",12)
					if (FillerNo'=OrderItemRowId){
						continue
					}
					s OEORIItemStateCode=##class(appcom.OEOrdItem).GetStatusCode(+OrderItemRowId_"||"_Sub) 
					continue:(OEORIItemStateCode="D")||(OEORIItemStateCode="C")
					s PHFreqDr = $p(^OEORD(+OrderItemRowId,"I",Sub,2),"^",4)
					//只验证有频次的医嘱，其他医嘱手工退费处理
					if (SubSttDate=ExDate)&&(PHFreqDr'="")&&(IncludeStopDateOrd="N"){
						//选择停止的当天的医嘱记录，根据用户选择的时间，判断是停医嘱还是停执行记录
						s iStopAllFlag="Y"
						s iStopExecStr=""
						s ExecId=0
						for {
							s ExecId=$O(^OEORD(+OrderItemRowId,"I",Sub,"X",ExecId))
							q:(ExecId="")
							s ExecRowID=+OrderItemRowId_"||"_Sub_"||"_ExecId
							s ExStDate=$P(^OEORD(+OrderItemRowId,"I",Sub,"X",ExecId),"^",1)
							s ExStTime=$P(^OEORD(+OrderItemRowId,"I",Sub,"X",ExecId),"^",2)
							s StatusCode=""
							s StatusRowId=$P(^OEORD(+OrderItemRowId,"I",Sub,"X",ExecId),"^",16)
							if StatusRowId'="" s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
							continue:(StatusCode="D")
							
							//if (ExStDate<ExDate)||((ExStDate=ExDate)&&(ExStTime<ExTime)){
							if (ExStDate<CheckExDate)||((ExStDate=CheckExDate)&&(ExStTime<CheckExTime)){	
								s iStopAllFlag="N"
							}else{
								if (iStopExecStr=""){
									s iStopExecStr=ExecRowID
								}else{
									s iStopExecStr=iStopExecStr_"^"_ExecRowID
								}
							}
						}
						//如果是需要全停执行记录，则直接停医嘱
						if (iStopAllFlag="Y"){
							if (StopOrdStr=""){
								s StopOrdStr=+OrderItemRowId_"||"_Sub
							}else{
								s StopOrdStr=StopOrdStr_"^"_+OrderItemRowId_"||"_Sub
							}
						}else{
							if (StopExecStr=""){
								s StopExecStr=ExecRowID
							}else{
								s StopExecStr=StopExecStr_"^"_ExecRowID
							}
						}
					}else{
						if (StopOrdStr=""){
							s StopOrdStr=+OrderItemRowId_"||"_Sub
						}else{
							s StopOrdStr=StopOrdStr_"^"_+OrderItemRowId_"||"_Sub
						}
					}
				}
			}
		}
	}else{
		if (StopOrdStr=""){
			s StopOrdStr=OrderItemRowId
		}else{
			s StopOrdStr=StopOrdStr_"^"_OrderItemRowId
		}
	}
	s ItmMastDR=$p(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),1),"^",2)
	s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
	s StartDate=$p(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),1),"^",9)
	s StartTime=$p(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),1),"^",10)
	s OEORIDate=$p($g(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),3)),"^",7)
	s OEORITime=$p($g(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),1)),"^",17)
	if (ExDate'="")&&(ExTime'="") {
		/*if (StartDate>ExDate)||((StartDate=ExDate)&&(StartTime>ExTime)){
			s ErrMsg="停止时间不能小于医嘱开始时间："_..%ZD(StartDate)_" "_..%ZT(StartTime,1)_"！"
			Q 0
		}*/
		if (OEORIDate>ExDate)||((OEORIDate=ExDate)&&(OEORITime>ExTime)){
			s ErrMsg="停止时间不能小于开医嘱时间："_..%ZD(OEORIDate)_" "_..%ZT(OEORITime,1)_"！"
			Q 0
		}
		s PreStopOrderTime=..%GetConfig("PreStopOrderTime")
		if +PreStopOrderTime'=0 {
			s PreStopOrderT=PreStopOrderTime*3600+..%SysTime()
			s PreStopOrderD=PreStopOrderT\86400+..%SysDate()
			s PreStopOrderT=PreStopOrderT#86400

			if (ExDate>PreStopOrderD)!((ExDate=PreStopOrderD)&&(ExTime>PreStopOrderT)) {
				s ErrMsg=..%Translate("ipdoc.patinfoview.csp"," 停医嘱时间不能晚于")_$zd(PreStopOrderD,3)_" "_$zt(PreStopOrderT)
				q "0"
			}
		}
	}
	q:(StopOrdStr="")&&(StopExecStr="") 1
	s i=1
	while (i<=$l(StopOrdStr,"^"))&&(ErrMsg="") {
		s oeorirowid=$p(StopOrdStr,"^",i)
		if (oeorirowid'=""){
			s str1 = ^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)
			s ItmMastDR=$p(str1,"^",2)
			s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
			s oneErrMsg=""
			s flag = ##class(web.DHCDocMain).CheckCancelOrder(oeorirowid,UserRowId, LocID, GroupID,.oneErrMsg)
			if (+flag'=1){
				s ErrMsg=oneErrMsg
				Q
			}
		}
		s i=i+1
	}
	if (ErrMsg'=""){
		q 0
	}
	s i=1
	while (i<=$l(StopExecStr,"^"))&&(ErrMsg="") {
		s OEORERowId=$p(StopExecStr,"^",i)
		if (OEORERowId'=""){
			s ItmMastDR=$p(^OEORD(+OEORERowId,"I",$p(OEORERowId,"||",2),1),"^",2)
			s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
			s ExStDate=$P(^OEORD(+OEORERowId,"I",$p(OEORERowId,"||",2),"X",$p(OEORERowId,"||",3)),"^",1)
			s ExStTime=$P(^OEORD(+OEORERowId,"I",$p(OEORERowId,"||",2),"X",$p(OEORERowId,"||",3)),"^",2)
			s ExStDateStr=..%ZD(ExStDate)_" "_..%ZT(ExStTime,1)
			s err=##Class(appcom.OEOrdExec).CheckUpdateStatus(OEORERowId,"D",UserRowId,"N")
			s RunExecMsg=##Class(web.DHCDocInPatPortalCommon).GetMsg(err)
			if (RunExecMsg'="0"){
				s ErrMsg=ExStDateStr_" "_ARCIMDesc_" 执行记录无法自动停止!"_RunExecMsg
				Q
			}
		}
		s i=i+1
	}
	if (ErrMsg'=""){
		q 0
	}
	q 1
}

/// Creator:      tanjishan
/// CreatDate:    2020.02.10
/// Description:  急诊停止医嘱处理
/// Table:        OE_OrdItem,OE_OrdExec,DHCDoc_OrderVirtualtLong
/// Input:        OrdItmRowId:医嘱Rowid,UserRowId:用户指针,PWFlag:是否密码验证,PinNum:明文密码
/// Return: 
/// OutPut:		  Err:程序执行返回值代码,标识成功与否
/// Others:       w ##class(web.DHCDocOrderVirtualLong).StopOrder("16||6&2020-02-11&15:16:27^&2020-02-11&15:16:27",10209,1,"Y") 
ClassMethod StopOrder(OrdList As %String = "", UserID As %String = "", PinNum As %String, PWFlag As %String = "Y", IncludeStopDateOrd As %String = "N", ExpStr As %String = "", ByRef ErrMsg As %String = "") As %String
{
	s ^tan("StopOrder")=OrdList_","_UserID_","_PinNum_","_PWFlag
	if (OrdList=""){
		s ErrMsg=..%GetErrCodeMsg("-100070")
		q "-100070" //-100
	}
	;密码验证
	s err=0
 	if PWFlag="Y" s err=##Class(web.DHCOEOrdItem).PinNumberValid(UserID,PinNum)
	if err'=0 {
		s ErrMsg=..%GetErrCodeMsg("-100029")
		Q "-100029" //err
	}
	
	s adm=""
	s ORDVLStr=""
	s StopOrdStr=""
	s len=$l(OrdList,"^")
	for i=1:1:len {
		s OrderItemStr=$p(OrdList,"^",i)
		s OrItemID=$p(OrderItemStr,"&",1)    //不能改医嘱ID为第一位的位置
		continue:OrItemID=""
		s StartDate=$p(OrderItemStr,"&",2)
		s StartTime=$p(OrderItemStr,"&",3)
		
		s:adm="" adm=$p(^OEORD(+OrItemID),"^",1)
		///虚拟长期医嘱记录id
		s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",OrItemID,0))
		if (ORDVLRowID'=""){
			if (ORDVLStr=""){
				s ORDVLStr=OrderItemStr
			}else{
				s ORDVLStr=ORDVLStr_"^"_OrderItemStr
			}
		}else{
			if (StopOrdStr=""){
				s StopOrdStr=OrderItemStr
			}else{
				s StopOrdStr=StopOrdStr_"^"_OrderItemStr
			}
		}
	}
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
	TS
	s OrderItemStatDR=$O(^OEC("OSTAT",0,"Code","D",0))
	if (ORDVLStr'=""){
		s len=$L(ORDVLStr,"^")
		for i=1:1:len {
			s OrderItemStr=$p(ORDVLStr,"^",i)
			s OrItemID=$p(OrderItemStr,"&",1)
			continue:OrItemID=""
			s EndDate=$p(OrderItemStr,"&",2)
			s EndTime=$p(OrderItemStr,"&",3)
			s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",OrItemID,0))
			continue:ORDVLRowID=""
			i EndDate'="" s EndDate=..%ZDH(EndDate)
			e  s EndDate=..%SysDate()
			
			i EndTime'="" s EndTime=..%ZTH(EndTime)
			e  s EndTime=..%SysDate()
			
			if EndDate>..%SysDate() {
				;预停
				s myobj=##class(User.DHCDocOrderVirtualtLong).%OpenId(ORDVLRowID)
				s myobj.ORDVLEndDate=EndDate
				s myobj.ORDVLEndTime=EndTime
				d myobj.ORDVLDoctorDRSetObjectId(DoctorID)
				Set sc = myobj.%Save()
				if ($System.Status.IsError(sc)){
					q
				}
			}else {
				s myobj=##class(User.DHCDocOrderVirtualtLong).%OpenId(ORDVLRowID)
				d myobj.ORDVLStatDRSetObjectId(OrderItemStatDR)
				d myobj.ORDVLDoctorDRSetObjectId(DoctorID)
				s myobj.ORDVLXDate=EndDate
				s myobj.ORDVLXTime=EndTime
				s myobj.ORDVLLastUpdateDate=..%SysDate()
				s myobj.ORDVLLastUpdateTime=..%SysTime()
				Set sc = myobj.%Save()
				if ($System.Status.IsError(sc)){
					q
				}
				s SubSttDate = EndDate-1
				for {
					s SubSttDate=$O(^OEORDi(0,"StDtTm1",+OrItemID,SubSttDate))
					q:(SubSttDate="")
					if (IncludeStopDateOrd="N")&&(SubSttDate<=EndDate){
						continue
					}
					s SubStTtim=""
					for {
						s SubStTtim=$O(^OEORDi(0,"StDtTm1",+OrItemID,SubSttDate,SubStTtim))
						q:(SubStTtim="")
						s Sub=0
						for {
							s Sub=$O(^OEORDi(0,"StDtTm1",+OrItemID,SubSttDate,SubStTtim,Sub))
							q:(Sub="")
							s FillerNo=$p($G(^OEORD(+OrItemID,"I",Sub,9)),"^",12)
							if (FillerNo'=OrItemID)&&((+OrItemID_"||"_Sub)'=OrItemID){
								continue
							}
							if (StopOrdStr=""){
								s StopOrdStr=+OrItemID_"||"_Sub_"&"_$p(OrderItemStr,"&",2,$L(OrderItemStr,"&"))
							}else{
								s StopOrdStr=StopOrdStr_"^"_+OrItemID_"||"_Sub_"&"_$p(OrderItemStr,"&",2,$L(OrderItemStr,"&"))
							}
							
						}
					}
				}
			}
		}
		if ($System.Status.IsError(sc)){
			TRO
			s ErrMsg=..%GetErrCodeMsg(err)
			Q "-100069" //-15501
		}
	}
	s err=0
	if (StopOrdStr'=""){
		s err=##class(web.UDHCStopOrderLook).StopOrder("","",StopOrdStr,UserID,"","N","",.ErrMsg)
	}
	if (+err'=0){
		Tro
	}else{
		TC
	}
	q err
}

/// EpisodeID:就诊id，UserID：登录用户id，STDateN：停止日期，系统格式，STTimeN：停止时间，前台通用格式
/// output:0-成功，非0-失败及失败说明
/// w ##Class(web.DHCDocOrderVirtualLong).StopAllVirtualtLong(118,10209,"","")
ClassMethod StopAllVirtualtLong(EpisodeID As %String, UserID As %String, STDateN As %String, STTimeN As %String) As %String
{
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(EpisodeID)
	q:(UserEMVirtualtLong=0) 0
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	q:(OrderRowid="") 0
	i STDateN'="" s STDateN=..%ZDH(STDateN)
	e  s STDateN=..%SysDate()
	
	i STTimeN'="" s STTimeN=..%ZTH(STTimeN)
	e  s STTimeN=..%SysDate()
	s StopAllOrdRowID=""
	K DocVirtualtLongList
	s SubChild=0
	for {
		s SubChild=$O(^OEORD(OrderRowid,"I",SubChild))
		q:(SubChild="")
		s OrItemID=OrderRowid_"||"_SubChild
		s ArcimRowId=$P($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",2)
		i ArcimRowId="" continue
		s statcode="V"
		s TtemStat=$P($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",13)
		i TtemStat'="" d
		.s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
		if (statcode="V"){
			s ARCIMExtInfo=##class(DHCDoc.DHCDocConfig.ARCIMExt).getARCIMConfig(ArcimRowId)
			s StopAfterLongOrder=$P(ARCIMExtInfo,"^",3)
			if (StopAfterLongOrder="1"){
				s StopAllOrdRowID=OrItemID
			}
		}
		s LinkOrderItem=$p($g(^OEORD(OrderRowid,"I",SubChild,11)),"^",39)
		//continue:(LinkOrderItem'="")
		s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",OrItemID,0))
		continue:ORDVLRowID=""
		
		
		s ORDVLStatDR=$P(^DHCDocORDVL(ORDVLRowID),"^",2)
		s ORDVLEndDate=$P(^DHCDocORDVL(ORDVLRowID),"^",3)
		s ORDVLSttDate=$P(^DHCDocORDVL(ORDVLRowID),"^",5)
		s ORDVLStatCode=$p(^OEC("OSTAT",ORDVLStatDR),"^",1)   
		//已停医嘱若停医嘱时间小于STDateN,需处理.否则不处理
		continue:(ORDVLStatCode="D")&&((ORDVLEndDate<=STDateN))
		//是否自动停止停止时间当日的医嘱
		
		s IncludeStopDateOrd="N"
		if (ORDVLSttDate>STDateN){
			s IncludeStopDateOrd="Y"
		}
		s DocVirtualtLongList(ORDVLRowID)=IncludeStopDateOrd
		
	}
	s ORDVLRowID=""
	for {
		s ORDVLRowID=$O(DocVirtualtLongList(ORDVLRowID))
		q:(ORDVLRowID="")
		s IncludeStopDateOrd=DocVirtualtLongList(ORDVLRowID)
		s OrdItemDR=$P(^DHCDocORDVL(ORDVLRowID),"^",1)
		s OrdList=OrdItemDR_"&"_..%ZD(STDateN)_" "_..%ZT(STTimeN,1)
		s ret=##class(web.DHCDocOrderVirtualLong).StopOrder(OrdList,UserID,"","N",IncludeStopDateOrd) 
		i ret=0 {
			//被全排斥停止的医嘱需要加标志,供医嘱浏览使用
			s $P(^OEORD(+OrdItemDR,"I",$P(OrdItemDR,"||",2),"DHC"),"^",61)=StopAllOrdRowID
		}
	}
	q 0
}

/// 用于急诊留观患者单独撤销执行记录，若仅撤销了该医嘱的全部执行记录时，直接将医嘱停止掉
/// w ##Class(web.DHCDocOrderVirtualLong).CancelOrdExec("974||37||3^974||37||2^974||37||1",11841,203,104,1)
ClassMethod CancelOrdExec(OrderExecStr As %String, UserID As %String, LogonLocDr As %String, GroupDr As %String, pinNum As %String, ExpStr As %String, ByRef ErrMsg As %String = "") As %String
{
	//s ^tempscl("CancelOrdExec")=OrderExecStr_","_UserID_","_LogonLocDr_","_GroupDr_","_pinNum
	s stopMsg="0",AlertCode=0
	k OrdListArr
	s EpisodeID=$p(^OEORD(+OrderExecStr),"^",1)
	for i=1:1:$l(OrderExecStr,"^"){
		s OrderExecRowID=$P(OrderExecStr,"^",i)
		continue:(OrderExecRowID="")
		
		s StatusRowId=$P(^OEORD(+OrderExecRowID,"I",$p(OrderExecRowID,"||",2),"X",$p(OrderExecRowID,"||",3)),"^",16)
		s StatusCode=$s(StatusRowId'="":$P($G(^OEC("STAT",StatusRowId)),"^",1),1:"")
		if (StatusCode="F"){
			s stopMsg="-200"
			q
		}
		s OrdListArr($P(OrderExecRowID,"||",1,2),OrderExecRowID)=""
	}
	if (stopMsg'="0"){
		s stopMsg=##class(web.DHCDocInPatPortalCommon).GetMsg(stopMsg)
		s ErrMsg=stopMsg
		q stopMsg
	}
	
	s StopOEOrdStr=""
	s OEOrdRowID=""
	for {
		s OEOrdRowID=$O(OrdListArr(OEOrdRowID))
		q:(OEOrdRowID="")
		s SelAllExecFlag="Y"
		s Sub=0 
		f {
			s Sub=$O(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),"X",Sub))
			Q:Sub=""
			s StatusRowId=$P(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),"X",Sub),"^",16)
			s StatusCode=$s(StatusRowId'="":$P($G(^OEC("STAT",StatusRowId)),"^",1),1:"")
			if (StatusCode="D") Continue
			if '$D(OrdListArr(OEOrdRowID,OEOrdRowID_"||"_Sub)){
				s SelAllExecFlag="N"
			}
		}
		s SttDate=$p($G(^OEORD(+OEOrdRowID,"I",$p(OEOrdRowID,"||",2),1)),"^",9)
		s SttTime=$p($G(^OEORD(+OEOrdRowID,"I",$p(OEOrdRowID,"||",2),1)),"^",10)
		s SttDateStr=..%ZD(SttDate)_" "_..%ZT(SttTime,1)
		if (SelAllExecFlag="Y"){
			if (StopOEOrdStr=""){
				s StopOEOrdStr=OEOrdRowID_$C(1)_SttDateStr
			}else{
				s StopOEOrdStr=StopOEOrdStr_"^"_OEOrdRowID_$C(1)_SttDateStr
			}
			k OrdListArr(OEOrdRowID)
		}
		
	}
	s CurrDate=..%ZD(+$H)
	s CurrTime=..%ZT(..%SysTime(),1)
	s OrdExpStr=UserID_"^"_LogonLocDr_"^"_GroupDr
	s ExecExpStr=UserID_"^"_LogonLocDr_"^"_GroupDr
	
	//判断是否能够通过执行记录进行部分退操作
	s OEOrdRowID=""
	for {
		s OEOrdRowID=$O(OrdListArr(OEOrdRowID))
		q:(OEOrdRowID="")
		s ARCIMRowId=$p(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),1),"^",2)
		s ItemCatRowid=$p(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		s ItemServiceFlag =##Class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowId)
		if ((ItemServiceFlag = "1")) {
			s stopMsg="-314"
			q
		}
		s PackQty=$p($G(^OEORD(+OEOrdRowID,"I",$p(OEOrdRowID,"||",2),9)),"^",4)
		if (PackQty'="")&&(OrderType="R"){
			s stopMsg="-212"
			q
		}
		
		s child=0  
		F {
			s child=$O(^OEORDi(0,"OEORI",+OEOrdRowID,OEOrdRowID,child))
			q:(child="")
			s ARCIMRowId=$p(^OEORD(+OEOrdRowID,"I",child,1),"^",2)
			s ItemCatRowid=$p(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1),"^",10)
			s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
			s PackQty=$p($G(^OEORD(+OEOrdRowID,"I",child,9)),"^",4)
			if (PackQty'="")&&(OrderType="R"){
				s stopMsg="-212"
				q
			}
		}
		if (stopMsg'="0"){
			q
		}
		
	}
	if (stopMsg'="0"){
		s stopMsg=##class(web.DHCDocInPatPortalCommon).GetMsg(stopMsg)
		s ErrMsg=stopMsg
		q stopMsg
	}
	TS
	if (StopOEOrdStr'=""){
		s stopMsg=##class(web.DHCDocInPatPortalCommon).MulOrdDealWithCom(StopOEOrdStr,CurrDate,CurrTime,"C",pinNum,OrdExpStr,.ErrMsg)
		s AlertCode=$p(stopMsg,"^",1)
	}
	if (AlertCode="0")&&($D(OrdListArr)){
		s OEOrdRowID=""
		for {
			s OEOrdRowID=$O(OrdListArr(OEOrdRowID))
			q:(OEOrdRowID="")||(stopMsg'="0")
			s AppReportDR=$p($g(^OEORD(+OEOrdRowID,"I",+$p(OEOrdRowID,"||",2),"DHC")),"^",42)
			s OEORERowId=0 
			f {
				s OEORERowId=$O(OrdListArr(OEOrdRowID,OEORERowId))
				Q:OEORERowId=""
				
				//	
				
				s ret=##class(appcom.OEOrdExec).UpdateStatus(OEORERowId,"D",UserID,+$H,..%SysTime(),"","","","","N","",.ErrMsg)
				//找到对应的子医嘱执行记录
				s SeqNo=$p(^OEORD(+OEORERowId,"I",$P(OEORERowId,"||",2),"X",$P(OEORERowId,"||",3)),"^",34)
				s StDate=$p(^OEORD(+OEORERowId,"I",$P(OEORERowId,"||",2),"X",$P(OEORERowId,"||",3)),"^",1)
				
				if (AppReportDR="")&&(ErrMsg=""){
					s child=0 F {
						s child=$O(^OEORDi(0,"OEORI",+OEOrdRowID,OEOrdRowID,child))
						Q:(child="")||(stopMsg'="0")
						s ExecSub=$O(^OEORDi(0,"Vol",+OEOrdRowID,StDate,SeqNo,child,0))
						if (ExecSub="") continue
						s LinkOEORE=$P($G(^OEORD(+OEOrdRowID,"I",child,"X",ExecSub,"BILL")),"^",3)
						if (LinkOEORE'="") continue
						s SubOEORERowId=(+OEOrdRowID)_"||"_child_"||"_ExecSub
						s ret=##class(appcom.OEOrdExec).UpdateStatus(SubOEORERowId,"D",UserID,+$H,..%SysTime(),"","","","","N","",.ErrMsg)
					}
				}
				if (ErrMsg'=""){
					s stopMsg=ErrMsg
					Q
				}
			}
		}
	}
	if (+stopMsg="0"){
		TC
		d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserID,"")
	}else{
		TRO
	}
	Q stopMsg
}

/// tanjishan
/// 2020-03-09
/// 判断该患者能否使用虚拟长期功能
/// w ##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong()
ClassMethod GetUserEMVirtualtLong(EpisodeID As %String) As %String
{
	Q:EpisodeID="" 0
	s AdmLoc=$p(^PAADM(EpisodeID),"^",4)
	s AdmHospDr=$P(^CTLOC(AdmLoc),"^",22)
	;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
	s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	//0现金模式；1押金模式
	s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmHospDr)
	s UserEMVirtualtLong=..%GetConfig("UserEMVirtualtLong",AdmHospDr)
	if (UserEMVirtualtLong=1)&&(GetStayStatusFlag=1)&&(StayPayMode=1){
		s UserEMVirtualtLong=1
	}else{
		s UserEMVirtualtLong=0
	}
	q UserEMVirtualtLong
}

Query FindOrderExec(OrdList As %String) As websys.Query(ROWSPEC = "OrderExecId:%String,TItemStatCode:%String,TExStDate:%String,TExecState:%String,TExecStateCode,TRealExecDate:%String,TBillState:%String,ExecPart:%String,TgiveDrugQty:%String,TcancelDrugQty:%String,TExecUser")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderVirtualLong","FindOrderExec","253||37^253||38^253||39^253||40^253||41^253||42")
ClassMethod FindOrderExecExecute(ByRef qHandle As %Binary, OrdList As %String) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	//s NeedQueryOrdList=""
	for i=1:1:$Length(OrdList,"^") {
		s OEOrdRowID=$P($P(OrdList,"^",i),$C(1))
		continue:(OEOrdRowID="")
		s OrdLinkRowId=$p($g(^OEORD(+OEOrdRowID,"I",$p(OEOrdRowID,"||",2),11)),"^",39)
		if (OrdLinkRowId'=""){
			s AddOEOrdRowID=OrdLinkRowId
		}else{
			s AddOEOrdRowID=OEOrdRowID
		}
		/*continue:(("^"_NeedQueryOrdList_"^")[("^"_AddOEOrdRowID_"^"))
		if (NeedQueryOrdList=""){
			s NeedQueryOrdList=AddOEOrdRowID
		}else{
			s NeedQueryOrdList=NeedQueryOrdList_"^"_AddOEOrdRowID
		}*/
		s OrdSub=$p(AddOEOrdRowID,"||",2)
		s SortNum=$e("0000000000000000000",1,6-$l(OrdSub))_OrdSub
		s NeedQueryOrdList(SortNum)=AddOEOrdRowID
	}
	if ('$d(NeedQueryOrdList)) {
		set qHandle = $lb(0,repid,0)
		Q $$$OK
	}
	s SortNum=""
	for {
		s SortNum=$o(NeedQueryOrdList(SortNum),-1) Q:SortNum=""
		s OEOrdRowID=$g(NeedQueryOrdList(SortNum))
		continue:(OEOrdRowID="")
		s ExecDateStr=##Class(web.DHCDocMain).getExecDateScope(OEOrdRowID)
		s ExecStartDate=$P(ExecDateStr,"^",1)
		s ExecEndDate=$P(ExecDateStr,"^",2)
		Set rsObj=##Class(%ResultSet).%New("web.DHCDocInPatPortalCommon:FindOrderExecDet")
		If rsObj.QueryIsValid() {
			 Set Status=rsObj.Execute(OEOrdRowID,ExecStartDate,ExecEndDate)
			 If 'Status Quit
			 While rsObj.Next() {
				s OrderExecId=rsObj.GetDataByName("OrderExecId")
				
				s TItemStatCode=rsObj.GetDataByName("TItemStatCode")
				s TExStDate=rsObj.GetDataByName("TExStDate")			//要求执行时间
				s TExecState=rsObj.GetDataByName("TExecState")			//状态
				s TExecStateCode=rsObj.GetDataByName("TExecStateCode")
				s TRealExecDate=rsObj.GetDataByName("TRealExecDate")	//执行时间
				s TBillState=rsObj.GetDataByName("TBillState")			//帐单状态	
				s ExecPart=rsObj.GetDataByName("ExecPart")				//检查部位
				s TgiveDrugQty=rsObj.GetDataByName("TgiveDrugQty")		//发药数量
				s TcancelDrugQty=rsObj.GetDataByName("TcancelDrugQty")	//退药数量
				s TExecUser=rsObj.GetDataByName("TExecUser")
				d OutPutDataExec
			 }
			 d rsObj.%Close()
		}
	}
	set qHandle = $lb(0,repid,0)
	Q $$$OK
OutPutDataExec
	Set ind=ind+1
	s Data=$LB(OrderExecId,TItemStatCode,TExStDate,TExecState,TExecStateCode,TRealExecDate,TBillState,ExecPart,TgiveDrugQty,TcancelDrugQty,TExecUser)
	Set ^CacheTemp(repid,ind)=Data
	
 	quit
}

/// 获取临时医嘱拆分整包装发药标志
/// w ##Class(web.DHCDocOrderVirtualLong).GetNormSplitPackQtyFlag()
ClassMethod GetNormSplitPackQtyFlag(EpisodeID As %String, RecLocRowid As %String, ItemCatDr As %String) As %String
{
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(EpisodeID)
	;医生站设置-药房设置-临时医嘱拆分整包装发药(仅在急诊留观押金的虚拟长期模式下有效)
    s NormSplitPackQty=##Class(DHCDoc.DHCDocConfig.PHReclocAbout).GetPHRecLocAboutFieldValue(RecLocRowid,ItemCatDr,1)
    if (UserEMVirtualtLong'=1){
		s NormSplitPackQty=0
	}
	q NormSplitPackQty
}

/// 获取临时医嘱可拆分整包装发药的科室列表
ClassMethod GetNormSplitPackQtyPHRecLocList(EpisodeID As %String, ItemCatDr As %String) As %String
{
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(EpisodeID)
	s NormSplitPackQtyPHRecLocList=##Class(DHCDoc.DHCDocConfig.PHReclocAbout).GetPHRecLocListByField(ItemCatDr,1)
    if (UserEMVirtualtLong'=1){
		s NormSplitPackQtyPHRecLocList=""
	}
	q NormSplitPackQtyPHRecLocList
}

}
