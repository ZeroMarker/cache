/// 批量补录医嘱
Class web.DHCDocNurseBatchSupplementOrd Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCDocNurseBatchSupplementOrd).GetItemCongeriesToList(""[{""""OrderARCIMRowid"""":""""2351||1"""",""""ItemDefaultRowId"""":""""""""}]"",""{""""OrderARCIMRowid"""":"""""""",""""RelocRowID"""":"""""""",""""MaterialBarcode"""":"""""""",""""rowid"""":1,""""LogonDep"""":"""""""",""""OrderOpenForAllHosp"""":""""0"""",""""SessionStr"""":""""10211^25^151^2^3^20"""",""""AnaesthesiaID"""":"""""""",""""OrderOperationCode"""":"""""""",""""OrderARCOSRowid"""":""""""""}"",""{""""Length"""":0,""""ItemOrds"""":[]}"")
ClassMethod GetItemCongeriesToList(OrdCongeriesJson As %String, BaseParamJson As %String, ItemOrdsJson As %String) As %String
{
	s ^Tempscl("GetItemCongeriesToList")="##class(web.DHCDocNurseBatchSupplementOrd).GetItemCongeriesToList("""_$REPLACE(OrdCongeriesJson,"""","""""")_""","""_$REPLACE(BaseParamJson,"""","""""")_""","""_$REPLACE(ItemOrdsJson,"""","""""")_""")"
	k OrdCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdCongeriesJson,.OrdCongeriesArr)
	k BaseParamArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(BaseParamJson,.BaseParamArr)
	k ItemOrdsArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ItemOrdsJson,.ItemOrdsArr)
	s SessionStr=BaseParamArr("SessionStr")
	s AddNo=0
	///需要增加到行上的医嘱列表
	k ItemCongeriesArr
	s OrdCounter=""
	for {
		s OrdCounter=$O(OrdCongeriesArr(OrdCounter))
		q:(OrdCounter="")
		s OrderARCIMRowid=OrdCongeriesArr(OrdCounter,"OrderARCIMRowid")
		s ParamS=$G(OrdCongeriesArr(OrdCounter,"ParamS"))
		s MaterialBarcode=$G(OrdCongeriesArr(OrdCounter,"MaterialBarcode"))
		s ITMRowId=$G(OrdCongeriesArr(OrdCounter,"ITMRowId"))	;医嘱套明细ID
		s MasterSeqNo=$G(OrdCongeriesArr(OrdCounter,"MasterSeqNo"))	;成组医嘱的行号
		///都是传成组关系，应该没有业务会直接传入关联医嘱的行号
		s CalSeqNo=$G(OrdCongeriesArr(OrdCounter,"CalSeqNo"))	;成组医嘱的计算关联号
		s RelocRowID=$G(OrdCongeriesArr(OrdCounter,"RelocRowID"))
		//初始化前台传入的医嘱明细
		k ARCOSArr
		d ..InitARCOSArr(.ARCOSArr,ParamS,SessionStr,OrderARCIMRowid)
		//初始化医嘱特殊信息
		k SubBaseParamArr
		m SubBaseParamArr=BaseParamArr
		s SubBaseParamArr("OrderARCIMRowid")=OrderARCIMRowid
		s SubBaseParamArr("RelocRowID")=RelocRowID
		s SubBaseParamArr("MaterialBarcode")=MaterialBarcode
		s SubBaseParamArr("ITMRowId")=ITMRowId
		s SubBaseParamArr("MasterSeqNo")=MasterSeqNo
		s SubBaseParamArr("CalSeqNo")=CalSeqNo
		s SubBaseParamArr("rowid")=BaseParamArr("rowid")+AddNo
		k OneItemInfoArr
		d ..GetItemToList(.SubBaseParamArr, .ItemOrdsArr, .ARCOSArr,.OneItemInfoArr)
		
		///将新增的行信息添加到ItemOrdsArr数组中，用于后续添加行的逻辑判断
		s Index=$I(ItemCongeriesArr)
		m ItemCongeriesArr(Index)=OneItemInfoArr
		d AddItemToRowArr(.AddNo,.ItemOrdsArr,.OneItemInfoArr,.BaseParamArr)
	}
	d SynGroupOrdData(.ItemCongeriesArr)
	s ItemCongeriesJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ItemCongeriesArr)
	q ItemCongeriesJson
	
	
	///将新获取的行数据添加到行数组记录里面
AddItemToRowArr(AddNo,ItemOrdsArr,OneItemInfoArr,BaseParamArr)
	n (AddNo,ItemOrdsArr,OneItemInfoArr,BaseParamArr)
	q:+$G(OneItemInfoArr("ErrCode"))<0
	s AddNo=AddNo+1
	s i=1+$O(ItemOrdsArr("ItemOrds",""),-1)
	m ItemOrdsArr("ItemOrds",i)=OneItemInfoArr("OrdListInfo")
	s ItemOrdsArr("ItemOrds",i,"OrderItemRowid")=""
	s ItemOrdsArr("ItemOrds",i,"OrderARCIMRowid")=ItemOrdsArr("ItemOrds",i,"OrderARCIMRowid")
	//后台不计算关联，这部分数据不用保证正确   --
	s ItemOrdsArr("ItemOrds",i,"rowid")=BaseParamArr("rowid")+AddNo
	s ItemOrdsArr("ItemOrds",i,"OrderSeqNo")=1+$G(ItemOrdsArr("ItemOrds",i-1,"OrderSeqNo"))
	s ItemOrdsArr("ItemOrds",i,"OrderMasterSeqNo")=""
	q
SynGroupOrdData(ItemCongeriesArr)
	n (ItemCongeriesArr)
	//给成组的医嘱设置同步设置是否呈独立行显示在界面上
	s i=0
	for {
		s i=$O(ItemCongeriesArr(i))
		q:(i="")
		s SingleRowFlag=$G(ItemCongeriesArr(i,"OrdListInfo","SingleRowFlag"))
		if (SingleRowFlag'="Y"){
			continue
		}
		s CalSeqNo=$G(ItemCongeriesArr(i,"OrdListInfo","CalSeqNo"))
		s j=0
		for {
			s j=$O(ItemCongeriesArr(j))
			q:(j="")
			if (j=i){
				continue
			}
			s SubCalSeqNo=$G(ItemCongeriesArr(j,"OrdListInfo","CalSeqNo"))
			if ($P(SubCalSeqNo,".")=$P(CalSeqNo,"."))&&(CalSeqNo'=""){
				s ItemCongeriesArr(j,"OrdListInfo","SingleRowFlag")=SingleRowFlag
			}
		}
	}
	q
}

/// w ##Class(web.DHCOEOrdItemView).GetItemToList("")
/// .SubBaseParamArr, .ARCOSArr,.OneItemInfoArr
ClassMethod GetItemToList(ByRef BaseParamArr, ByRef ItemOrdsArr, ByRef ArcosArr, ByRef ItemRowDataArr) As %String [ ProcedureBlock = 0 ]
{
	n (BaseParamArr,ItemOrdsArr,ArcosArr,ItemRowDataArr,%session)
	s CallBackFunStr=""
	s OutInfo="0^^^^"
	s LogonDep=$G(BaseParamArr("LogonDep"))
	s OrderARCIMRowid=$G(BaseParamArr("OrderARCIMRowid"))
	s OrderOpenForAllHosp=$G(BaseParamArr("OrderOpenForAllHosp"))
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s MaterialBarcode=$G(BaseParamArr("MaterialBarcode"))
	s ITMRowId=$G(BaseParamArr("ITMRowId"))
	s ExpStr = MaterialBarcode_"^"_ITMRowId_"^^^"
	s EpisodeID=BaseParamArr("Adm")
	/*if (BaseParamArr("AnaesthesiaID")'="") {
		s EpisodeID=BaseParamArr("Adm")
	}*/
	///医嘱项明细信息
	s EPARCIMDetail=..GetEPARCIMDetail(EpisodeID,OrderARCIMRowid, LogonDep, OrderOpenForAllHosp, SessionStr, ExpStr)
	
	//--初始化默认数据
	k ParamArr
	d InitParamArr(.ParamArr,.BaseParamArr,.ArcosArr,EPARCIMDetail)
	//--录入限制或提示
	s OutInfo=$$BaseValidCheck(.ParamArr,.ItemOrdsArr,.BaseParamArr,.CallBackFunStr)
	q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
	//--判断重复提示
	s OutInfo=$$CheckDupOrder(.ParamArr,.ItemOrdsArr,.BaseParamArr,.CallBackFunStr)
    q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
	//--计算数量
    d SetPackQty(.ParamArr,.BaseParamArr,.ArcosArr,.CallBackFunStr)
	//--计算成组医嘱关系(复制或医嘱套会走这段程序)-放到最后应该没问题
    d SetMasterSeqNo(.ParamArr,.BaseParamArr,.ArcosArr,.CallBackFunStr)
    //---配置附加列信息
    d SetOrdOtherInfo(.ParamArr,.BaseParamArr)
    //--设置是否呈独立行显示在界面上（是否独立在行上显示由前台决定，这里只打标记）
	d SetSingleRowFlag(.ParamArr,.BaseParamArr)
	q $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
SetOrdOtherInfo(ParamArr,BaseParamArr)
	n (ParamArr,BaseParamArr)
	//手术列表附加信息
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s langid=$P(SessionStr,"^",6)
	s AnaesthesiaID=$G(BaseParamArr("AnaesthesiaID"))
	s OrderOperationCode=$G(BaseParamArr("OrderOperationCode"))
	if (AnaesthesiaID'=""){
		s OperationStr=##Class(web.DHCANAdaptor).GetOperInfoByAnaId(AnaesthesiaID,langid)
		//添加一项空数据供用户选择
		//s OperationStr=""_$C(1)_"^"_OperationStr
		s OrderOperation=""
		if (OrderOperationCode'=""){
			for i=1:1:$L(OperationStr,"^"){
				s OneOperation=$P(OperationStr,"^",i)
				if ($P(OneOperation,$C(1),2)=OrderOperationCode){
					s OrderOperation=$P(OneOperation,$C(1),1)
				}
			}
		}
		/*if (OrderOperation=""){
			s OrderOperation=$P($P(OperationStr,"^",1),$C(1),1)
			s OrderOperationCode=$P($P(OperationStr,"^",1),$C(1),2)
		}*/
		s ParamArr("AnaesthesiaID")=AnaesthesiaID
		s ParamArr("OrderOperationStr")=OperationStr
		//如果用户已在上一行置了默认，则不再覆盖
		//if (ParamArr("OrderOperation")="")&&(ParamArr("OrderOperationCode")=""){
		s ParamArr("OrderOperation")=OrderOperation
		s ParamArr("OrderOperationCode")=OrderOperationCode
		//}
	}
	Q
InitParamArr(ParamArr,BaseParamArr,ArcosArr,EPARCIMDetail)
	n (ParamArr,BaseParamArr,ArcosArr,EPARCIMDetail)
	s ParamArr("rowid")=$G(BaseParamArr("rowid"))
	s ParamArr("id")=$G(BaseParamArr("rowid"))
	s ParamArr("OrderItemRowid")=""
	s ParamArr("OrderARCIMRowid")=$G(BaseParamArr("OrderARCIMRowid"))
	s ParamArr("OrderARCOSRowid")=$g(ArcosArr("OrderARCOSRowid"))
	//s OrderItemCongeries
	s ParamArr("OrderName")=$P(EPARCIMDetail,"^",1)
	s ParamArr("OrderType")=$P(EPARCIMDetail,"^",2)
	s idefpriorstr = $P(EPARCIMDetail,"^",10)
	s ParamArr("OrderPrior")=$P(idefpriorstr,$C(1),1)
	s ParamArr("OrderPriorRowid")=$P(idefpriorstr,$C(1),2)
	s iOrderRecLocStr=$P(EPARCIMDetail,"^",9)
	s ParamArr("OrderRecLocStr")=$P(iOrderRecLocStr,$C(12),1)
	s ParamArr("OrderRecDepRowid")=$P(iOrderRecLocStr,$C(12),2)
	s ParamArr("OrderRecDep")=$P(iOrderRecLocStr,$C(12),3)
	s ItemCatRowid=$P(EPARCIMDetail,"^",3)
	s ParamArr("OrderFreqRowid")=""
	s IsHourItem=##Class(web.DHCDocOrderCommon).IsHourItem(ParamArr("OrderARCIMRowid"))
	;可选择频次的非药品子类
 	s FreqItemCat=..%GetConfig("FrequencedItemCat")
 	if ("^"_FreqItemCat_"^"[("^"_ItemCatRowid_"^"))&&(IsHourItem'="1"){
	 	s ParamArr("OrderFreqRowid")=$O(^PHCFR(0,"Desc1","ST",0))
	}
	s ParamArr("OrderDurRowid")=""
	s ParamArr("OrderInstrRowid")=""
	s ParamArr("OrderDoseQty")=""
	s ParamArr("OrderDoseUOMRowid")=""
	s ipackqtystr = $P(EPARCIMDetail,"^",8)
	s ParamArr("OrderPackQty")=$P(ipackqtystr,$C(1),1)
	s ParamArr("OrderPackUOM")=$P(ipackqtystr,$C(1),2)
	s ParamArr("OrderPackUOMRowid")=$P(ipackqtystr,$C(1),3)
	s iretPrice = $P(EPARCIMDetail,"^",7)
	s ParamArr("OrderPrice")=$P(iretPrice,$C(1),1)
	s ParamArr("OrderPHPrescType")=$P(EPARCIMDetail,"^",6)
	s ParamArr("OrderBillTypeRowid")=""
	s ParamArr("OrderSkinTest")=""
	s ParamArr("OrderDrugFormRowid")=$P(EPARCIMDetail,"^",4)
	s ParamArr("OrderStartDate")=""
	s MasterSeqNo=$G(BaseParamArr("MasterSeqNo"))
	s ParamArr("OrderMasterSeqNo")=MasterSeqNo
	s ParamArr("OrderDepProcNote")=""
	s ParamArr("OrderCoverMainIns")=""
	s ParamArr("OrderActionRowid")=""
	s ParamArr("OrderEndDate")=""
	s ParamArr("OrderLabSpecRowid")=""
	s ParamArr("OrderDIACatRowId")=""
	s ParamArr("OrderInsurCatRowId")=""
	s ParamArr("OrderFirstDayTimes")=""
	s ParamArr("OrderBodyPart")=""
	s ParamArr("OrderStageCode")=""
	s ParamArr("OrderSpeedFlowRate")=""
	s ParamArr("AnaesthesiaID")=BaseParamArr("AnaesthesiaID")
	s ParamArr("OrderLabEpisodeNo")=""
	s ParamArr("LinkedMasterOrderRowid")="",ParamArr("LinkedMasterOrderSeqNo")="",ParamArr("LinkedMasterOrderSeqNo")=""
	s ParamArr("OrderCPWStepItemRowId")=""
	s ParamArr("OrderMaterialBarcodeHiden")=$G(BaseParamArr("MaterialBarcode"))
	s ParamArr("OrderFlowRateUnit")="",ParamArr("OrderFlowRateUnitRowId")=""
	s ParamArr("OrderDate")=""
	s ParamArr("OrderNeedPIVAFlag")=""
	s ParamArr("OrderAntibApplyRowid")=""
	s ParamArr("AntUseReason")="",ParamArr("UserReasonId")=""
	s ParamArr("ShowTabStr")=""
	s ParamArr("OrderLocalInfusionQty")=""
	s ParamArr("OrderSelfOMFlag")=""
	s ParamArr("OrderOutsourcingFlag")=""
	s ParamArr("ExceedReasonID")=""
	s ParamArr("Urgent")=""
	
	//s ParamArr("OrderOperation")="" //手术名称
	//s ParamArr("OrderOperationCode")=BaseParamArr("OrderOperationCode")
	s ParamArr("AnaesthesiaID")=""
	s ParamArr("OrderOperationStr")=""
	s ParamArr("OrderOperation")=""
	s ParamArr("OrderOperationCode")=""
	
	s ParamArr("OrderFreqDispTimeStr")=""
	s ParamArr("OrderFreqFactor")="",ParamArr("OrderFreqInterval")=""
	s ParamArr("OrderDurFactor")=""
	s ParamArr("OrderPriorRemarksRowId")=""
	s ParamArr("OrderPilotProRowid")=""
	s ParamArr("OrderMonitorId")=""
	s ParamArr("OrderNurseLinkOrderRowid")=""
	s ParamArr("OrderBodyPartLabel")=""
	s ParamArr("OrderFreqTimeDoseStr")=""
	
	s ItemExpInfo=$G(BaseParamArr("ItemExpInfo"))
	s MARCIMRowid=ParamArr("OrderARCIMRowid")
	s MItemCatDR=$p(^ARCIM(+MARCIMRowid,$p(MARCIMRowid,"||",2),1),"^",10)
	;不能关联的医嘱子类
    s NotLinkItemCat=..%GetConfig("NotLinkItemCat")
 	if ("^"_NotLinkItemCat_"^")'[("^"_MItemCatDR_"^"){
	 	s ParamArr("CalSeqNo")=$G(BaseParamArr("CalSeqNo"))
    }else{
	    s ParamArr("CalSeqNo")=""
	}
	s ParamArr("OrderItemCatRowid")=$P(EPARCIMDetail,"^",3)
	s ParamArr("ItemRowid")=$P(EPARCIMDetail,"^",4)
	s ParamArr("InciRowid")=$P(EPARCIMDetail,"^",5)	
	s ParamArr("OrderSum")=$fn(ParamArr("OrderPrice")*ParamArr("OrderPackQty"),"",4)
	s iother= $P(EPARCIMDetail,"^",12)
	s OrderItemInValid=$p(iother,$C(1),1)
	s OrderAuthInValid=$p(iother,$C(1),2)
	s ParamArr("OrderItemInValid")=OrderItemInValid
	s ParamArr("OrderAuthInValid")=OrderAuthInValid
	s ParamArr("OrderItemCongeries")=""
	///护士补录医嘱设置主医嘱信息
	if ($g(BaseParamArr("LinkedMasterOrderRowid"))'=""){
		s LinkedMasterOrderRowid=BaseParamArr("LinkedMasterOrderRowid")
		s ParamArr("LinkedMasterOrderRowid")=LinkedMasterOrderRowid
		s OrderPriorRowid=$P($G(^OEORD(+LinkedMasterOrderRowid,"I",$P(LinkedMasterOrderRowid,"||",2),1)),"^",8)
		if (OrderPriorRowid=4)&&(ParamArr("OrderType")'="R"){
			s OrderPriorRowid=3
			}
		s ParamArr("OrderPrior")=$p($g(^OECPR(OrderPriorRowid)),"^",1)
		s ParamArr("OrderPriorRowid")=OrderPriorRowid
		s PHFreqDr = $p($G(^OEORD(+LinkedMasterOrderRowid,"I",$P(LinkedMasterOrderRowid,"||",2),2)),"^",4)
		s LinkedOrderSttDate=$P($G(^OEORD(+LinkedMasterOrderRowid,"I",$P(LinkedMasterOrderRowid,"||",2),1)),"^",9)
		s LinkedOrderSttTime=$P($G(^OEORD(+LinkedMasterOrderRowid,"I",$P(LinkedMasterOrderRowid,"||",2),1)),"^",10)
		s OrderSttDate=..%SysDate(),OrderSttTime=..%SysTime()
		if (LinkedOrderSttDate>OrderSttDate)||((OrderSttDate=LinkedOrderSttDate)&&(OrderSttTime<LinkedOrderSttTime)){
			s ParamArr("OrderStartDate")=..%ZD(LinkedOrderSttDate)_" "_ ..%ZT(LinkedOrderSttTime)
		}else{
			//s OrderSttDate=..%SysDate(),OrderSttTime=..%SysTime()
			//s ParamArr("OrderStartDate")=..%ZD(OrderSttDate)_" "_ ..%ZT(OrderSttTime)
			}
		if (PHFreqDr'=""){
		s ParamArr("OrderFreq")=$p($G(^PHCFR(PHFreqDr)),"^",3)
        s ParamArr("OrderFreqRowid")=PHFreqDr
        s ParamArr("OrderFreqFactor")=$p($G(^PHCFR(PHFreqDr)),"^",2)
        s ParamArr("OrderFreqInterval")=$P($g(^PHCFR(PHFreqDr)),"^",5)
        s OrderFreqWeek=$p($g(^OEORD(+LinkedMasterOrderRowid,"I",$P(LinkedMasterOrderRowid,"||",2),"DHC")),"^",55)
		s OrderFreqFreeTimeStr=$p($g(^OEORD(+LinkedMasterOrderRowid,"I",$P(LinkedMasterOrderRowid,"||",2),"DHC")),"^",68)
		s OrderFreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrderFreqDispTimeStr(PHFreqDr,OrderFreqWeek,OrderFreqFreeTimeStr)
        s ParamArr("OrderFreqDispTimeStr")=OrderFreqDispTimeStr
		}
		}
	q
BaseValidCheck(ParamArr,ItemOrdsArr,BaseParamArr,CallBackFunStr)
	n (ParamArr,ItemOrdsArr,BaseParamArr,CallBackFunStr)
	s OutInfo="0^^^^^^"
	s OrderARCIMRowid=ParamArr("OrderARCIMRowid")
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s CTLOCID=$P(SessionStr,"^",3)
	s OrderType=ParamArr("OrderType")
	s ArcimDesc=ParamArr("OrderName")
	s PriorRowid=ParamArr("OrderPriorRowid")
	s MaterialBarcode=ParamArr("OrderMaterialBarcodeHiden")
	s ARCIMRowid=ParamArr("OrderARCIMRowid")
	s OrderItemCatRowid=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",10) 
	//0单价医嘱提示
	s OrderPrice=ParamArr("OrderPrice")
	s GROUPID=$P(SessionStr,"^",2)
	s langid=$P(SessionStr,"^",6)
	s Valid=##class(web.DHCDocOrderEntry).AddControl(OrderARCIMRowid,GROUPID)
	if (Valid=1) {
		s OutInfo="-1^"_ArcimDesc_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","没有权限开此医嘱!",langid)_"^^^^"
		q OutInfo
	}
	s ItemLocAuth=##class(web.DHCBL.CT.CTLocOrderLimit).GetOrderLimtFlag(CTLOCID,OrderARCIMRowid)
	if (ItemLocAuth=1) {
		s OutInfo="-1^"_ArcimDesc_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","此医嘱已经被医嘱限制!",langid)_"^^^^"
		q OutInfo
	}
    if (+OrderPrice=0)&&(OrderPrice'="") {
	    ;不提示零价格医嘱
 		s CFNotAlertZeroPrice=..%GetConfig("NotAlertZeroPrice")
        if (CFNotAlertZeroPrice'= 1) {
            s AlertZero = 1
            s NotAlertZeroItemCatStr=..%GetConfig("NotAlertZeroItemCat")
            if (NotAlertZeroItemCatStr '= "") {
                if (("^"_NotAlertZeroItemCatStr_"^")[("^"_OrderItemCatRowid_"^")) {
	            	s AlertZero = 0
	            }
            }
            if (AlertZero=1) {
                s CallBackFunParams=ArcimDesc_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","此医嘱单价为0,您确定要开吗?",langid)
				s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Confirm",CallBackFunParams)
            }
        }
	}
	if (1=ParamArr("OrderItemInValid")){
		s OutInfo="-1^"_ArcimDesc_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","医嘱项目无效!",langid)_"^^^^"
	}
	if (0=ParamArr("OrderAuthInValid")){
		s OutInfo="-1^"_ArcimDesc_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","没有权限录入该医嘱!",langid)_"^^^^"
	}
	if (OrderType = "P") {
	    s CallBackFunParams=ArcimDesc_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","自定义价格医嘱需要填写价格!",langid)_""
		s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Alert",CallBackFunParams)
	}
	if (""=ParamArr("OrderRecLocStr")){
		s OutInfo="-1^"_ArcimDesc_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","该医嘱没有接收科室,请与信息中心联系!",langid)_"^^^^"
	}
	s IncItmHighValueFlag=##Class(web.DHCDocOrderCommon).GetIncItmHighValueFlag(OrderARCIMRowid)
    if (IncItmHighValueFlag="Y"){
	    s HighValueControl=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(CTLOCID,13)
	    s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
	    if (HighValueControl'=1){
			s OutInfo="-1^您所登录的科室没有录入高值材料的权限,请联系信息科确认!^^^^"
		}else{
			if (MaterialBarcode=""){
				s OutInfo="-1^"_ArcimDesc_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","属于高值耗材,只能通过扫条码下医嘱!",langid)_""
			}
			if (PriorCode '= "NORM") {
		        s OutInfo="-1^"_ArcimDesc_"高值材料请开临时医嘱使用!"
		        q OutInfo
			}
		}
	}
	if (OrderType = "R") {
		s CallBackFunParams=ArcimDesc_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","在此页面仅支持【取药医嘱】类型,若非取药医嘱，请使用常规“医嘱录入”功能录入",langid)_""
		s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Confirm",CallBackFunParams)
	}
	q OutInfo
CheckDupOrder(ParamArr,ItemOrdsArr,BaseParamArr,CallBackFunStr)
	n (ParamArr,ItemOrdsArr,BaseParamArr,CallBackFunStr)
	s ArcimDesc=ParamArr("OrderName")
	s ARCIMRowid=ParamArr("OrderARCIMRowid")
	s OrderItemCatRowid=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",10) 
	//非药物、死亡、高值医嘱要判断重复
    s IncItmHighValueFlag=##Class(web.DHCDocOrderCommon).GetIncItmHighValueFlag(ARCIMRowid)
    s NotAlertRepeatItemCat=..%GetConfig("NotAlertRepeatItemCat")
    s SessionStr=$G(BaseParamArr("SessionStr"))
	s langid=$P(SessionStr,"^",6)
    if (("^"_NotAlertRepeatItemCat_"^")'[("^"_OrderItemCatRowid_"^"))||(IncItmHighValueFlag="Y") {
	    s PrescCheck = $$CheckDupOrderItem(.ParamArr,.BaseParamArr,.ItemOrdsArr)
        if (+PrescCheck=1) {
            s PrescCheckPriorType=$P(PrescCheck,"^",2)
            if (IncItmHighValueFlag="Y"){
	            s OutInfo="-1^"_ParamArr("OrderMaterialBarcodeHiden")_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","条码已被使用!",langid)_"^^^^"
				q OutInfo
	        }else{
				s CallBackFunParams=PrescCheckPriorType_ArcimDesc_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","存在相同的医嘱,是否确认要增加?",langid)_""
				s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Confirm",CallBackFunParams)
			}
        }
    }
    q "0"
CheckDupOrderItem(ParamArr,BaseParamArr,ItemOrdsArr)
	n (ParamArr,BaseParamArr,ItemOrdsArr)
	s OrderPriorType=""
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s ARCIMRowid=ParamArr("OrderARCIMRowid")
	
	s CheckOrderPriorRowid=ParamArr("OrderPriorRowid")
	s USERID=$P(SessionStr,"^",1)
	s GROUPID=$P(SessionStr,"^",2)
	s CurLogonHosp=$p(SessionStr,"^",4)
	s langid=$P(SessionStr,"^",6)
	s DischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(ARCIMRowid,CurLogonHosp)
	s IncItmHighValueFlag=##Class(web.DHCDocOrderCommon).GetIncItmHighValueFlag(ParamArr("OrderARCIMRowid"))
    ;补录模式
 	s SupplementMode=..%GetConfig1("SupplementMode",GROUPID)
    if (SupplementMode=1){q "0^"_OrderPriorType}
    s NotSamePriorNeedAlertItemCat=..%GetConfig("NotSamePriorNeedAlertItemCat")
	i NotSamePriorNeedAlertItemCat'="" s NotSamePriorNeedAlertItemCat="^"_NotSamePriorNeedAlertItemCat_"^"
	s tmpAricmStr=##class(web.DHCSTMHUI.PCHCOLLSM).GetArcimByLabel(BaseParamArr("MaterialBarcode"))
    s ret=""
    s i=""
    for {
		s i=$O(ItemOrdsArr("ItemOrds",i))
		q:(i="")
		s OrderItemRowid = ItemOrdsArr("ItemOrds",i,"OrderItemRowid")
        s OrderARCIMRowid = ItemOrdsArr("ItemOrds",i,"OrderARCIMRowid")
        continue:((OrderARCIMRowid="")||(OrderItemRowid'=""))
        s OrderRowid = ItemOrdsArr("ItemOrds",i,"rowid")
        s OrderType=""
		s OrderItemCatDr=$P(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",10) 
		s:OrderItemCatDr'="" OrderType=$P(^ARC("IC",OrderItemCatDr),"^",7)
		s OrderPriorRowid =ItemOrdsArr("ItemOrds",i,"OrderPriorRowid")
		continue:(OrderItemCatDr'="")&&(NotSamePriorNeedAlertItemCat'[("^"_OrderItemCatDr_"^"))&&(CheckOrderPriorRowid'=OrderPriorRowid)
		s OrderDischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(OrderARCIMRowid,CurLogonHosp)
		if (ARCIMRowid=OrderARCIMRowid)||((OrderDischargeOrdFlag'=0)&&(DischargeOrdFlag'=0)) {
			if (IncItmHighValueFlag="Y"){
				//有可能是通过自带条码录入的医嘱,需要转成对应的高值条码判断
				s tmpOrderAricmStr=##class(web.DHCSTMHUI.PCHCOLLSM).GetArcimByLabel(ItemOrdsArr("ItemOrds",i,"OrderMaterialBarcode"))
				s OrderPriorType=$P(^OECPR(OrderPriorRowid),"^",2)
				s OrderPriorType=##class(User.OECPriority).GetTranByDesc("OECPRDesc",OrderPriorType,langid)
	            s ret="1^"_OrderPriorType
	            q
			}else{
				s OrderPriorType=$P(^OECPR(OrderPriorRowid),"^",2)
				s OrderPriorType=##class(User.OECPriority).GetTranByDesc("OECPRDesc",OrderPriorType,langid)
	            s ret="1^"_OrderPriorType
	            q
			}
         }
    }
    if (+ret=1){
		q ret 
	}
    s ret="0^"_OrderPriorType
	q ret
SetPackQty(ParamArr,BaseParamArr,ArcosArr,CallBackFunStr)
	n (ParamArr,BaseParamArr,ArcosArr,CallBackFunStr)
	s OrderPackQty=ParamArr("OrderPackQty")
    if (($D(ArcosArr("OrderPackQty")) && (ArcosArr("OrderPackQty")'= ""))) {
        s ParamArr("OrderPackQty")=ArcosArr("OrderPackQty")
        s ParamArr("OrderSum")=$fn(ParamArr("OrderPrice")*ParamArr("OrderPackQty"),"",4)
    }
	q
SetMasterSeqNo(ParamArr,BaseParamArr,ItemOrdsArr,ArcosArr,CallBackFunStr)
	n (ParamArr,BaseParamArr,ItemOrdsArr,ArcosArr,CallBackFunStr)
	s OrderMasterSeqNo=ParamArr("OrderMasterSeqNo")
	q:(OrderMasterSeqNo="")
	s OrderName=ParamArr("OrderName")
	s OrderType=ParamArr("OrderType")
	//找到主医嘱那行数据
	k MasterItemArr
	s i =""
    for{
		s i=$O(ItemOrdsArr("ItemOrds",i))
		q:(i="")
        s ListSeqNo = ItemOrdsArr("ItemOrds",i,"OrderSeqNo")
        if (OrderMasterSeqNo=ListSeqNo){
	    	m MasterItemArr=ItemOrdsArr("ItemOrds",i)
	    }
    }
    //关联医嘱基本控制
    s Rtn=$$CheckLinkOrder(.ParamArr,.MasterItemArr,BaseParamArr)
    if (+Rtn<0){
		s CallBackFunParams=$P(Rtn,"^",2)
	    s CallBackFunStr=##Class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Alert",CallBackFunParams)
        s ParamArr("OrderMasterSeqNo")=""
        q
	}
	q
CheckLinkOrder(ParamArr,MasterItemArr,BaseParamArr)
	n (ParamArr,MasterItemArr,BaseParamArr)
	s ErrCode=0
	s ErrMsg=""
	s OrderName=ParamArr("OrderName")
	s OrderType=ParamArr("OrderType")
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s langid=$P(SessionStr,"^",6)
	if ('$D(MasterItemArr))||($G(MasterItemArr("OrderARCIMRowid"))=""){
		s ErrMsg=OrderName_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","主医嘱不存在,无法关联",langid)_""
	    s ErrCode="-1"
        q ErrCode_"^"_ErrMsg
	}
    if (MasterItemArr("OrderMasterSeqNo")'=""){
		s ErrMsg=OrderName_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","选择主医嘱已经关联其他医嘱",langid)_""
	    s ErrCode="-1"
        q ErrCode_"^"_ErrMsg
	}
    if (MasterItemArr("OrderItemRowid")'=""){
		s ErrMsg=OrderName_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","已审核医嘱不能关联",langid)_"已审核医嘱不能关联"
	    s ErrCode="-1"
        q ErrCode_"^"_ErrMsg 
	}
	s MARCIMRowid=MasterItemArr("OrderARCIMRowid")
	s MItemCatDR=$p(^ARCIM(+MARCIMRowid,$p(MARCIMRowid,"||",2),1),"^",10)
	s MOrderType=$P(^ARC("IC",MItemCatDR),"^",7)
	if (OrderType'="R")||(MOrderType'="R"){
		s ErrMsg=OrderName_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","非药品医嘱不能关联",langid)_"非药品医嘱不能关联"
	    s ErrCode="-1"
        q ErrCode_"^"_ErrMsg
	}
	q ErrCode_"^"_ErrMsg
GetItemRowDataJsonObj(OutPutInfo,CallBackFunStr,ParamArr,ItemRowDataArr)
	n (OutPutInfo,CallBackFunStr,ParamArr,ItemRowDataArr)
	k ItemRowDataArr
	s ErrCode=$P(OutPutInfo,"^",1)
	s ErrMsg=$P(OutPutInfo,"^",2)
	s ItemRowDataArr("ErrCode")=ErrCode
	s ItemRowDataArr("ErrMsg")=ErrMsg
	
	s SubNodeNum=0
	for i=1:1:$Length(CallBackFunStr,$C(2)){
		s SingleCallBackFun=$P(CallBackFunStr,$C(2),i)
		if (SingleCallBackFun=""){continue}
		s CallBakFunCode=$P(SingleCallBackFun,"^",1)
		s CallBakFunParams=$P(SingleCallBackFun,"^",2)
		s SubNodeNum=SubNodeNum+1
		s ItemRowDataArr("CallBakFunS",SubNodeNum,"CallBakFunCode")=CallBakFunCode
		s ItemRowDataArr("CallBakFunS",SubNodeNum,"CallBakFunParams")=CallBakFunParams
	}
	m ItemRowDataArr("OrdListInfo")=ParamArr
	q 0
SetSingleRowFlag(ParamArr,BaseParamArr)
	n (ParamArr,BaseParamArr)
	s ParamArr("SingleRowFlag")="N"
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s LogonHosp=$p(SessionStr,"^",4)
	s EpisodeID=BaseParamArr("Adm")
 	s PHPoisonCode=$g(ParamArr("OrderPoisonCode"))
 	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
 	//抗生素独立显示
    if (PHPoisonCode [ "KSS") {
		s isExit = ##Class(DHCAnt.KSS.Common.Method).GetKJSwitchFlag(PAAdmType,LogonHosp)
		if (isExit'=1){
			s ParamArr("SingleRowFlag")="Y"
		}
	}
	//医嘱套明细维护快速例外
	s ITMRowId=$G(BaseParamArr("ITMRowId"))
	if ((+ITMRowId'="0")){
		//医嘱套嵌套按例外处理
		s BaseOrderARCOSRowid=BaseParamArr("OrderARCOSRowid")
		if (BaseOrderARCOSRowid'="")&&($p(ITMRowId,"||",1)'=BaseOrderARCOSRowid){
			 s ParamArr("SingleRowFlag")="Y"
		}else{
		    s RemoveCeler=$p($G(^ARCOS($p(ITMRowId,"||",1),"DATE",$p(ITMRowId,"||",2),"ITM",$p(ITMRowId,"||",3),"DHC")),"^",9)
		    if (RemoveCeler="Y"){
			    s ParamArr("SingleRowFlag")="Y"
			}
		}
	}
	q
}

ClassMethod GetEPARCIMDetail(EpisodeID, ArcimRowid, OrderDepRowid, OpenForAllHosp, SessionStr, ExpStr) As %String
{
	n (EpisodeID,ArcimRowid, OrderDepRowid, OpenForAllHosp, SessionStr, ExpStr, %session)
	s ^tempscl("sadfd")=EpisodeID_","_ArcimRowid_","_OrderDepRowid_","_OpenForAllHosp_","_SessionStr_","_ExpStr
	s UserRowId=$p(SessionStr,"^",1)
	s GROUPID=$p(SessionStr,"^",2)
	s CurLogonDep=$p(SessionStr,"^",3)
	s CurLogonHosp=$p(SessionStr,"^",4)
	s langid=$P(SessionStr,"^",6)
	s MaterialBarcode=$p(ExpStr,"^",1) //高值条码
	s ITMRowId=$p(ExpStr,"^",2)
	;按登录科室取接收科室设置
	s CFRecLocByLogonLoc=""
	i OrderDepRowid="" {
		i CurLogonDep'="" s CFRecLocByLogonLoc=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(CurLogonDep,1)
	    i CFRecLocByLogonLoc=1 s OrderDepRowid=CurLogonDep
	}
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	s ArcimDesc=##class(web.DHCDocOrderCommon).GetFormateOrderName(ArcimRowid)
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	//s BillUOMRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s BillUOMRowid=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,AdmType)
	s BillUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid)
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
	if (EpisodeID'="")&&(OrderDepRowid="") {
		s RecLocStr=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,ArcimRowid,OpenForAllHosp)
	}else{
		s RecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(OrderDepRowid,ArcimRowid,OpenForAllHosp)
	}
	s DefaultRecLoc=$$GetDefalocID(RecLocStr)
	s DefaultRecLocDesc=""
	s:DefaultRecLoc'="" DefaultRecLocDesc=$p(^CTLOC(DefaultRecLoc),"^",2)
	//增加对医嘱套维护接收科室设置
    if ((+ITMRowId'="0")){
	    s ARCOSOrdRecLocDR=$p($g(^ARCOS(+ITMRowId,"DATE",$p(ITMRowId,"||",2),"ITM",$p(ITMRowId,"||",3))),"^",21)
	    if (ARCOSOrdRecLocDR'=""){
		    s RecLocStr=##class(web.DHCARCOrdSets).CheckARCOSItemRecLoc(RecLocStr,ARCOSOrdRecLocDR)
		}
	}
	
	s ExpStrin="^^^^"_DefaultRecLoc_"^^"_MaterialBarcode //7
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ArcimRowid, +$h, "", "", "", "",CurLogonHosp,ExpStrin)
	
	s Price=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	if (INCIRowid'="") {
		s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ArcimRowid,INCIRowid,BillUOMRowid)
		s Price=$fn(Price*ConFac,"",4)
		s DiscPrice=$fn(DiscPrice*ConFac,"",4)
		s InsPrice=$fn(InsPrice*ConFac,"",4)
		s PatPrice=$fn(PatPrice*ConFac,"",4)
	}
	s PackQty=1,RealStockQty=""
	if (OrderType="R") {
		s DefPriorRowid=$O(^OECPR(0,"Code","ONE",0))
		s DefPriorDesc="取药医嘱"
	}else{
		s DefPriorRowid=$O(^OECPR(0,"Code","NORM",0))
		s DefPriorDesc="临时医嘱"
	}
	s DefPriorDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",DefPriorDesc,langid)
	
	;判断是否此医嘱项已经停止
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ArcimRowid)
	i OrderItemInValid="0" {
		s isOwn=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),7)),"^",13)
	    i (isOwn="N")&&(+ITMRowId="0") s OrderItemInValid=1 //非独立医嘱通过医嘱套要求能录入
	}
	;权限控制
	s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GROUPID,ArcimRowid,"","",UserRowId,CurLogonDep,"",ITMRowId)
	
	;处方类型,可以根据设置里的类别来定或者也可以根据账单单位确定
	i OrderType="R"{
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatRowid,CurLogonHosp,ArcimRowid)
		i PHPrescType="" s PHPrescType="1"
	}else{
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatRowid,CurLogonHosp,ArcimRowid)
	}
	s DefaultRecLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DefaultRecLocDesc,langid)
	s ret=ArcimDesc_"^"_OrderType_"^"_ItemCatRowid_"^"_DrgformRowid_"^"_INCIRowid_"^"_PHPrescType
	s ret=ret_"^"_Price_$C(1)_DiscPrice_$C(1)_InsPrice_$C(1)_PatPrice
	s ret=ret_"^"_PackQty_$C(1)_BillUOMDesc_$C(1)_BillUOMRowid
	s ret=ret_"^"_RecLocStr_$C(12)_DefaultRecLoc_$C(12)_DefaultRecLocDesc
	s ret=ret_"^"_DefPriorDesc_$C(1)_DefPriorRowid
	s ret=ret_"^"_RealStockQty
	s ret=ret_"^"_OrderItemInValid_$C(1)_OrderAuthInValid
	q ret
GetDefalocID(RecLocStr)
	s DeLocID=""
	s RecLocCount=$L(RecLocStr,$C(2))
	F iLoc=1:1:RecLocCount {
		S LoopRecLocStr=$P(RecLocStr,$C(2),iLoc)
		s ReclocRowId=$P(LoopRecLocStr,$C(1),1)
		if iLoc=1 s DeLocID=ReclocRowId
		s Defaut=$P(LoopRecLocStr,$C(1),3)
		if (Defaut="Y") s DeLocID=ReclocRowId
		
	}
	Q DeLocID
}

/// 初始化医嘱套或复制医嘱对象，注意不能随便初始化ARCOSArr，后面计算会判断$D(ARCOSArr)
ClassMethod InitARCOSArr(ByRef ARCOSArr, ParamS As %String, SessionStr As %String, OrderARCIMRowid As %String) As %String
{
	s CTLOCID=$P(SessionStr,"^",3)
 	s ItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
    s (OrderARCOSRowid,ARCOSSubCatRowid)= ""
    s (OrderFreq,OrderFreqRowid,OrderFreqFactor,OrderFreqInterval)=""
    s (OrderInstr,OrderInstrRowid,OrderAntibApplyRowid,UserReasonId)=""
    //从医嘱套里传入的参数,取医嘱套信息
    if (ParamS '= "") {
	    s ispecordersetstr = $P(ParamS, "^", 7)
	    s OrderARCOSRowid = ispecordersetstr
        s ispecpackqtystr = $P(ParamS, "^", 5)
        s SpecOrderPackQty = $P(ispecpackqtystr, $C(1), 1)
        s SpecOrderPackUOM = $P(ispecpackqtystr, $C(1), 2)
        s SpecOrderPackUOMRowid = $P(ispecpackqtystr, $C(1), 3)
		s ARCOSArr("OrderPackQty")=SpecOrderPackQty
		s ARCOSArr("OrderARCOSRowid")=OrderARCOSRowid
		s ARCOSArr("POrderRecDepRowid")=""
		s ARCOSArr("SpecOrderPackUOM")=SpecOrderPackUOM
		s ARCOSArr("SpecOrderPackUOMRowid")=SpecOrderPackUOMRowid
    }
    q
}

ClassMethod SetUserUnSaveData(UserId As %String, CtlocId As %String, UnSaveInc As %String, UnsaveData As %String, AdmStr As %String) As %String
{
	q:(UserId="")||(CtlocId="")||(+UnSaveInc=0)
	i UnsaveData="",AdmStr="" {
		k ^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId,+UnSaveInc)
	}else{
		s ^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId,+UnSaveInc)=UnsaveData_"^"_+$h_"^"_..%SysTime()_"^"_AdmStr
	}
}

ClassMethod GetUserUnSaveData(UserId As %String, CtlocId As %String, UnSaveInc As %String) As %String
{
	q:'$d(^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId,+UnSaveInc)) ""
	s Data=$g(^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId,+UnSaveInc))
	Q $g(Data)
}

ClassMethod GetUserUnSaveCount(UserId As %String, CtlocId As %String) As %String
{
	s UnSaveCount=0
	q:'$d(^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId)) UnSaveCount
	s Count=0
	for {
		s Count=$O(^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId,Count))
		q:Count=""
		i UnSaveCount<Count {
			s UnSaveCount=Count
		}else{
			s UnSaveCount=UnSaveCount+1
		}
	}
	//判断是否超出数据保留时长
	s Data=$g(^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId,UnSaveCount))
	Q:$l(Data,"^")=1 UnSaveCount  // 兼容未存储缓存时间的历史数据
	s UnSaveOrdDataKeepTime=..%GetConfig("UnSaveOrdDataKeepTime")
	if (UnSaveOrdDataKeepTime'=""){
		s Data=$g(^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId,UnSaveCount))
		s SavedDate=$p(Data,"^",2)
		s SavedTime=$p(Data,"^",3)
		s DifferTime=(+$h-SavedDate-1)*24+((..%SysTime()+86400-SavedTime)/3600)
		i DifferTime>UnSaveOrdDataKeepTime {
			// 超出保留时长后清除缓存数据
			k ^DHCDOCNURSEUNSAVEDATANEW(UserId,CtlocId,UnSaveCount)
			s UnSaveCount=0
		}
	}
	q UnSaveCount
}

ClassMethod GetPatNameByAdm(admId As %String) As %String
{
	Q:(admId="")!(+admId=0) ""
	s PatientID=$p(^PAADM(admId),"^",1)
	Q:PatientID="" ""
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
	Q PatName
}

/// 获取已补录医嘱列表
Query GetNurseBatchOrdList(AdmStr As %String = "", SttDate As %String = "", EndDate As %String = "", LocId As %String = "") As %Query(ROWSPEC = "OEORIRowId:%String,ItmMastDR:%String,OrderName:%String,PackQty:%String,BillUOMRowid:%String,BillUOMDesc:%String,MaterialBarCode:%String,ReLocID:%String,ReLoc:%String,TDoctor:%String,TStDate:%String,TOeoriOeori:%String")
{
}

ClassMethod GetNurseBatchOrdListExecute(ByRef qHandle As %Binary, AdmStr As %String = "", SttDate As %String = "", EndDate As %String = "", LocId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocNurseBatchSupplementOrd","GetNurseBatchOrdList",2121,"2020-09-29","2020-09-29",115)
	Set langid=..%LanguageID()
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Q:(AdmStr="") $$$OK
    i SttDate'="" s SttDate=..%ZDH(SttDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
    k plist1
    for i=1:1:$l(AdmStr,"!"){
	    s admStr=$p(AdmStr,"!",i)
	    s adm=$p(admStr,$C(1),1)
	    s OEORDRowId=0
	    for {
		    s OEORDRowId=$o(^OEORD(0,"Adm",adm,OEORDRowId)) Q:OEORDRowId=""
		    s OEORIChildsub=0
		    for {
			    s OEORIChildsub=$o(^OEORDi(0,"NurseBatchAdd","Y",OEORDRowId,OEORIChildsub)) Q:OEORIChildsub=""
			    s StatusCode=##class(appcom.OEOrdItem).GetStatusCode(OEORDRowId_"||"_OEORIChildsub)
			    continue:StatusCode'="V"
			    s OEORIUserDepartmentDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",2)
			    continue:OEORIUserDepartmentDR'=LocId
			    s str1=^OEORD(OEORDRowId,"I",OEORIChildsub,1)
			    s TStDate=$p(str1,"^",9)
				continue:(SttDate'="")&&(TStDate<SttDate)
				continue:(EndDate'="")&&(TStDate>EndDate)
			    s ordstr3=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,3))
			    s ItmMastDR = $p(str1,"^",2)
				s OrderName=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
				s PackQty=$p($g(^OEORD(+OEORDRowId,"I",OEORIChildsub,1)),"^",12)
				s PackQty=##class(web.DHCDocOrderView).formateNum(PackQty)
				s BillUOMRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),8)),"^",14),BillUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid)
				s MaterialBarCode=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,"DHC")),"^",14)
				s ReLocID=$p(ordstr3,"^",6)
				If ReLocID'="" Set ReLoc=$P($G(^CTLOC(ReLocID)),"^",2)
				else  s ReLoc=""
				s TDoctor=""
				i $d(^OEORD(OEORDRowId,"I",OEORIChildsub,1))=1 s DoctorDr=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",11)
				s:+$g(DoctorDr)>0 TDoctor = $p(^CTPCP(DoctorDr,1),"^",2)
				s TStTime = $p(str1,"^",10)
				s times=TStDate*24*3600+TStTime
				s groupdr = $p(^OEORD(OEORDRowId,"I",OEORIChildsub,11),"^",39)
				if (groupdr'="")&&('$d(^OEORDi(0,"NurseBatchAdd","Y",+groupdr,$p(groupdr,"||",2)))) s groupdr=""
				s TSttdate=..%ZD(TStDate)_" "_..%ZT(TStTime,1)
				i groupdr'="" s TSttdate=""
				; renyx 增加翻译
				s BillUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",BillUOMDesc,langid)
				s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
				Set TDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TDoctor,langid)
				s ReLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ReLoc,langid)
				s rslist=$lb(OEORDRowId_"||"_OEORIChildsub,ItmMastDR,OrderName,PackQty,BillUOMRowid,BillUOMDesc,MaterialBarCode,ReLocID,ReLoc,TDoctor,TSttdate,groupdr)
				i +groupdr>0 {
					s plist1(+groupdr,times,$p(groupdr,"||",2),"Sub", OEORIChildsub) = rslist
				}else {
					s plist1(OEORDRowId,times,OEORIChildsub) = rslist
				}
			}
		}
	}
	b //455
	s orderParref=0
	for {
		s orderParref = $o(plist1(orderParref)) Q:orderParref=""
		s adm=$p(^OEORD(orderParref),"^",1)
		s PatientID=$p(^PAADM(adm),"^",1)
		s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
		s ^CacheTemp(repid,ind) = $lb(orderParref,"",PatName,"","","","","","","","")
		Set ind=ind+1
		s time=""
		for {
			Set time=$o(plist1(orderParref,time),-1) Q:time=""
			s parref=0 
			for {
				s parref=$o(plist1(orderParref,time,parref)) Q:parref=""
				s ^CacheTemp(repid,ind) = $g(plist1(orderParref,time,parref))
				Set ind=ind+1
				s sub=0 
				for {
					s sub = $o(plist1(orderParref,time,parref,"Sub",sub)) Q:sub=""
					s ^CacheTemp(repid,ind) = plist1(orderParref,time,parref,"Sub",sub)
					Set ind=ind+1
				}
			}  
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetNurseBatchOrdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurseBatchOrdListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNurseBatchOrdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurseBatchOrdListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 批量补录患者跟医嘱无关的录入限制验证
/// 空 允许录入 非空 限制录入
/// w ##class(web.DHCDocNurseBatchSupplementOrd).ChkOrdEntryLimit("120!159!482")
ClassMethod ChkOrdEntryLimit(AdmStr As %String = "", ChkExpStr As %String = "") As %String
{
	n (AdmStr,ChkExpStr,%session)
	s NotAdmTypeLimit=$p(ChkExpStr,"^",1)
	s warning=""
	Q:AdmStr="" warning
	;住院有主管医生才能录医嘱
	s CFIPNeedDoctor=..%GetConfig("IPNeedDoctor")
	s LogonUserId=%session.Data("LOGON.USERID")
	s DocID=$P(^SSU("SSUSR",LogonUserId),"^",14)
	Set langid=..%LanguageID()
	for o=1:1:$l(AdmStr,"!"){
		Q:warning'=""
	    s admStr=$p(AdmStr,"!",o)
	    s adm=$p(admStr,$C(1),1)
	    s PatientID=$p($g(^PAADM(adm)),"^",1)
	    s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	    s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(adm)
	    s PAADMBedDR=$p($g(^PAADM(adm)),"^",73)
	    ;获取患者当前出院状态,调用护理组接口
		s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(adm)
		s VisitStatus=$p($g(^PAADM(adm)),"^",20)
	    if (PAAdmType="I")&&(PAADMBedDR="")&(CurrentDischargeStatus'="B")&(VisitStatus'="P") {
		    s warning=PatName_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","未分配床位,不允许开医嘱!")_""
		    Q
		}
		s PAADMDocDR=$p($g(^PAADM(adm)),"^",9)
		i (PAAdmType="I")&&(PAADMDocDR="")&&(CFIPNeedDoctor=1)&(VisitStatus'="P") {
			s warning=PatName_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","未分配床位,不允许开医嘱!")_""
			Q
		}
		s OrderUnabled=##class(web.DHCDocOrderCommon).CheckOrderUnabled(adm)
		if OrderUnabled=1 {
			s warning=PatName_" "_..%Translate("ipdoc.nursebatchsupplementord.hui.csp","正在结算中,不允许再开医嘱!")_""
			Q
		}
		s FinFlag=$p($g(^PAADM(adm)),"^",45)
		if FinFlag="Y" {
			s warning=PatName_ ..%Translate("ipdoc.nursebatchsupplementord.hui.csp","已结算出院,不允许再开医嘱!")_""
			Q
		}
		if ((VisitStatus="D")!(VisitStatus="C"))&(DocID'="")&(CurrentDischargeStatus'="B") {
			s warning=PatName_ ..%Translate("ipdoc.nursebatchsupplementord.hui.csp","已做最终结算,不允许医护人员再开医嘱!")_""
			Q
		}
		//s LockMsg=##class(web.DHCDocViewDataInit).GetLock(adm,LogonUserId)
		s orderrow=$o(^OEORD(0,"Adm",+adm,""))
		s warning=##class(web.DHCDocOrderCommon).OrderLock(orderrow,..%SessionStr(),"Check","")
		if (warning'="") {
			s warning=PatName_" "_warning
			Q
		}
		s warning=##Class(web.DHCDocViewDataInit).GetOrdEntryWarning(adm,"N","",NotAdmTypeLimit)
		//s orderrow=$o(^OEORD(0,"Adm",adm,""))
		//s warning=##class(web.DHCDocOrderCommon).OrderEntryLock(orderrow,%session.SessionId,%session.Get("LOGON.USERID"),%session.Get("LOGON.CTLOCID"))
		if (warning'="") s warning=PatName_" "_warning
	}
	Q warning
}

/// w ##class(web.DHCDocNurseBatchSupplementOrd).InsertContinuousOrder("196"_$c(1)_"207||60#207||68!290"_$c(1)_"282||55#282||72","2188||1^M^3^2019-07-15^11:25:05^1^34.5000^151^^^^^^1^^^^^^1^^^^^^^^^^^^^^^^^^^^^^^^^^2019-07-15^11:25:05^^^^^^^^97^^^^^^^^^^N^1^^0^^^Y"_$c(1)_"2363||1^M^3^2019-07-15^11:25:05^1^0.5200^151^^^^^^1^^^^^^2^^^^^^^^^^^^^^^^^^^^^^^^^^2019-07-15^11:25:05^^^^^^^^4^^^^^^^^^^N^2^^0^^^Y",10211,151,3,1)
ClassMethod InsertContinuousOrder(AdmStr As %String, OrdItemStr As %String, UserAddRowid As %String, UserAddDepRowid As %String, DoctorRowid As %String, ExpStr As %String) As %String
{
	s ^tempscl("InsertContinuousOrder")=AdmStr_","_OrdItemStr_","_UserAddRowid_","_UserAddDepRowid_","_DoctorRowid_","_ExpStr
	s NotAdmTypeLimit=$p(ExpStr,"^",9)
	s warning=..ChkOrdEntryLimit(AdmStr,NotAdmTypeLimit)
	Q:warning'="" warning
	;插入过程如果出现错误,全部回滚
	s TroFlag=0
	TS
	s Admcount=$L(AdmStr,"!")
	For iAdm=1:1:Admcount {
		s AdmInfo=$p(AdmStr,"!",iAdm)
		s Adm=$p(AdmInfo,$C(1),1)
 		s DischargeDateTime=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",Adm)
 		s DischargeDate=$p(DischargeDateTime,"^",1)
		i DischargeDate'="" {
			s FormateDischargeDate=..%ZD(DischargeDate)
		}
		s DischargeTime=$p(DischargeDateTime,"^",2)
		i DischargeTime'="" {
			s FormateDischargeTime=..%ZT(DischargeTime-1,1)
		}
		s LinkMasOrdStr=$p(AdmInfo,$C(1),2)
		if (LinkMasOrdStr'="") {
			s NewOrdItemStr=""
			for i=1:1:$l(LinkMasOrdStr,"#") {
				s LinkMasOrdRowId=$p(LinkMasOrdStr,"#",i)
				s LinkMasPriorRowid=$p($g(^OEORD(+LinkMasOrdRowId,"I",$p(LinkMasOrdRowId,"||",2),1)),"^",8)
				for j=1:1:$l(OrdItemStr,$C(1)) {
					s OrderItem=$p(OrdItemStr,$C(1),j)
					s $p(OrderItem,"^",39)=LinkMasOrdRowId
					s OrderType=$p(OrderItem,"^",2)
					s PriorRowid=##class(web.DHCOEOrdAppendItem).GetAppendItemPrior(OrderType,LinkMasPriorRowid)
					s $p(OrderItem,"^",3)=PriorRowid
					s startdate=..%ZDH($p(OrderItem,"^",4))
					s starttime=..%ZTH($p(OrderItem,"^",5))
					if (DischargeDate'="")&&((startdate>DischargeDate)||((startdate=DischargeDate)&&(starttime>DischargeTime))) {
						s $p(OrderItem,"^",4)=FormateDischargeDate
						s $p(OrderItem,"^",5)=FormateDischargeTime
						s $p(OrderItem,"^",46)=FormateDischargeDate
						s $p(OrderItem,"^",47)=FormateDischargeTime
					}
					if (NewOrdItemStr="") s NewOrdItemStr=OrderItem
					else  s NewOrdItemStr=NewOrdItemStr_$C(1)_OrderItem
				}
			}
			s AddOrdItemStr= NewOrdItemStr
		}else{
			if (DischargeDate'="") {
				s NewOrdItemStr=""
				for j=1:1:$l(OrdItemStr,$C(1)) {
					s OrderItem=$p(OrdItemStr,$C(1),j)
					s startdate=..%ZDH($p(OrderItem,"^",4))
					s starttime=..%ZTH($p(OrderItem,"^",5))
					if ((startdate>DischargeDate)||((startdate=DischargeDate)&&(starttime>DischargeTime))) {
						s $p(OrderItem,"^",4)=FormateDischargeDate
						s $p(OrderItem,"^",5)=FormateDischargeTime
						s $p(OrderItem,"^",46)=FormateDischargeDate
						s $p(OrderItem,"^",47)=FormateDischargeTime
					}
					if (NewOrdItemStr="") s NewOrdItemStr=OrderItem
					else  s NewOrdItemStr=NewOrdItemStr_$C(1)_OrderItem
				}
				s AddOrdItemStr=NewOrdItemStr
			}else{
				s AddOrdItemStr=OrdItemStr
			}
		}
		Set Ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(Adm,AddOrdItemStr,UserAddRowid,UserAddDepRowid,DoctorRowid,ExpStr,..%SessionStr())
		if (Ret=0)!(Ret=100) {
			s TroFlag=1
			Quit
		}
	}
	i TroFlag=0 {
		TC
	}else{
		TRO
	}
	Q:Ret["*" "0"
	QUIT Ret
}

/// w ##class(web.DHCDocNurseBatchSupplementOrd).InitPatOrderViewGlobal("1313||41^1313||43^1214||236","","")
/// Notes: 传入参数优先级 OEOrdItemIDs>OEOrdItemID>EpisodeID
/// Modify:增加入参NotLinkMaster 20210329
/// 	   NotLinkMaster Y:即使传入了OEOrdItemIDs或OEOrdItemID也不需要进行医嘱关联，仅仅作为补录医嘱，当前进治疗工作站会传
ClassMethod InitPatOrderViewGlobal(OEOrdItemIDs As %String, OEOrdItemID As %String, EpisodeID As %String, NotLinkMaster As %String = "") As %String
{
	k TempAdmOrdArr($j),TempAdmPatNameArr($j)
	if (OEOrdItemIDs'="") {
		for i=1:1:$l(OEOrdItemIDs,"^") {
			s OrdId=$p(OEOrdItemIDs,"^",i)
			continue:OrdId=""
			s AdmId=$p(^OEORD(+OrdId),"^",1)
			continue:AdmId=""
			s patname=##class(web.DHCDocNurseBatchSupplementOrd).GetPatNameByAdm(AdmId)
			if '($d(TempAdmOrdArr($j,AdmId))) {
				s TempAdmOrdArr($j,AdmId)=OrdId
				s TempAdmPatNameArr($j,AdmId)=patname
			}else{
				s TempAdmOrdArr($j,AdmId)=$g(TempAdmOrdArr($j,AdmId))_"#"_OrdId
			}
		}
	}elseif (OEOrdItemID'=""){
		s AdmId=$p(^OEORD(+OEOrdItemID),"^",1)
		s patname=##class(web.DHCDocNurseBatchSupplementOrd).GetPatNameByAdm(AdmId)
		s TempAdmOrdArr($j,AdmId)=OEOrdItemID
		s TempAdmPatNameArr($j,AdmId)=patname
	}elseif (EpisodeID'="") {
		s patname=##class(web.DHCDocNurseBatchSupplementOrd).GetPatNameByAdm(EpisodeID)
		s TempAdmOrdArr($j,EpisodeID)=""
		s TempAdmPatNameArr($j,EpisodeID)=patname
	}
	s JsonObj=[]
	s oneAdmId=0
	for {
		s oneAdmId=$o(TempAdmOrdArr($j,oneAdmId)) Q:oneAdmId=""
		s PatName=$g(TempAdmPatNameArr($j,oneAdmId))
		s LinkMasOrdStr=$g(TempAdmOrdArr($j,oneAdmId))
		if NotLinkMaster="Y" s LinkMasOrdStr=""
		s JsonData={}
		do JsonData.%Set("id",oneAdmId)
		do JsonData.%Set("text",PatName)
		do JsonData.%Set("LinkedMasterOrderRowid",LinkMasOrdStr)
		do JsonObj.%Push(JsonData,"")
	}
	k TempAdmOrdArr($j),TempAdmPatNameArr($j)
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	s JsonInfo=$replace(JsonInfo,"""","'")
	q JsonInfo
}

ClassMethod GetLinkMasterOrdList(LinkedMasterOrderStr As %String) As %String
{
	s JsonObj=[]
	Set langid=..%LanguageID()
	for i=1:1:$l(LinkedMasterOrderStr,"#") {
		s OrderId=$p(LinkedMasterOrderStr,"#",i)
		s OrderArcimDr=$p(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1),"^",2)
		s OrdName=$p(^ARCIM(+OrderArcimDr,$p(OrderArcimDr,"||",2),1),"^",2)
		s OrdName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrdName,langid)
		s JsonData={}
		do JsonData.%Set("OrderId",OrderId)
		do JsonData.%Set("OrdName",OrdName)
		do JsonObj.%Push(JsonData,"")
	}
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	s JsonInfo=$replace(JsonInfo,"""","'")
	q JsonInfo
}

ClassMethod GetCardBillNeedInfo(EpisodeID As %String) As %String
{
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s PatDefCardInfo=##class(web.DHCOPAdmReg).GetValidAccMNoCardNo(PatientID)
	s PatDefCardNo=$p(PatDefCardInfo,"^",1)
	s CardBillCardTypeValue=$p(PatDefCardInfo,"^",2,$l(PatDefCardInfo,"^"))
	s BillTypeID=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	Q PatientID_$C(1)_PatDefCardNo_$C(1)_CardBillCardTypeValue_$C(1)_BillTypeID_$C(1)_PAAdmType
}

Query GetNurseBatchLinkOrder(LinkedMasterOrderRowid As %String = "", EpisodeID As %String) As %Query(ROWSPEC = "rowid:%String ,id:%String,OrderMasterSeqNo:%String,OrderName :%String,OrderPackQty :%String,OrderPackUOM :%String,OrderMaterialBarcodeHiden :%String,OrderPrice:%String,OrderSum:%String,OrderRecDep:%String,OrderOperation:%String,OrderRowID:%String,OrderOperationStr:%String,CalSeqNo:%String")
{
}

ClassMethod GetNurseBatchLinkOrderExecute(ByRef qHandle As %Binary, LinkedMasterOrderRowid As %String = "", EpisodeID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocNurseBatchSupplementOrd","GetNurseBatchLinkOrder","89||164",99)
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Q:(LinkedMasterOrderRowid="") $$$OK
    q:+LinkedMasterOrderRowid=0 $$$OK
    Set langid=..%LanguageID()
    if (EpisodeID=""){
	    s EpisodeID=$P(^OEORD(+LinkedMasterOrderRowid),"^",1)
	    }
    s OEORDSubRowID=""
    for {
	    s OEORDSubRowID=$O(^OEORDi(0,"OEORI",+LinkedMasterOrderRowid,LinkedMasterOrderRowid,OEORDSubRowID))
	    q:OEORDSubRowID=""
	    s rowid=ind
	    s OrderRowID=+LinkedMasterOrderRowid_"||"_OEORDSubRowID
	    s BindSource=$P($g(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,"DHC")),"^",41)
	    s isNurse=0
	    s DoctorDr=$p(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,1),"^",11)
		s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
		s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
		s:CTCPTInternalType="NURSE" isNurse=1
		if ((BindSource="")&&(isNurse=0)) continue 
	    s OEORIItemStateCode=##class(appcom.OEOrdItem).GetStatusCode(OrderRowID) 
		if (OEORIItemStateCode'="V")&&(OEORIItemStateCode'="C")&&(OEORIItemStateCode'="I") continue
	    s id=ind ;$p(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,3),"^",4)
	    s OrderMasterSeqNo=""
	    s ArcimDr=$p(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,1),"^",2)
		s OrderName=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1)),"^",2)
		s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
	    s OrdPackQtyInfo=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OrderRowID)
		;s OrderPackQty=$p($g(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,9)),"^",4) ;$p(OrdPackQtyInfo,"^",1)
		s OrderPackQty=$p($g(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,1)),"^",12)
		if (OrderPackQty="") s OrderPackQty=$p(OrdPackQtyInfo,"^",1)
		s OrderPackUOM=$p(OrdPackQtyInfo,"^",2)
		s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(+LinkedMasterOrderRowid_"||"_OEORDSubRowID)
		i BillingUOMDR'="" d
		.s OrderPackUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
		s OrderPackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderPackUOM,langid)
		s OrderMaterialBarcodeHiden=$p($G(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,"DHC")),"^",14)
		s PatType=$P(^PAADM(EpisodeID,1),"^",6)  
		s InsType="1"
		s OrderSttDate=$p(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,1),"^",9)
		s PriorRowid=$P($G(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,1)),"^",8)
		s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
		s InstrRowid=$P($G(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,2)),"^",7)
		s LinkTo=$P($G(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,3)),"^",1)
		s OEPrice=""
		s OrderRecDepRowid= $p($G(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,3)),"^",6)
		s PatType=$P(^PAADM(EpisodeID,1),"^",6)
		s InsType=##class(web.UDHCJFBILL).GetPatTypeByRecLoc(PatType,OrderRecDepRowid)
		s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
		s ExpStrin=PAADMRegConDisDR_"^"_OrderRowID_"^^"_EpisodeID_"^"_OrderRecDepRowid_"^"_""_"^"_""
		s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ArcimDr, +$h, "", "", "", "","",ExpStrin)
		b ;0934
		s OrderPrice=$P(retPrice,"^",1)
		s DiscPrice=$P(retPrice,"^",2)
		s OrderSum=OrderPackQty*OrderPrice
		s OrderPrice=$fn(OrderPrice,"",2)
		s OrderSum=$fn(OrderSum,"",2)
		s OrderRecDep = ##class(web.DHCDocOrderCommon).GetLocDesc(OrderRecDepRowid)
		s OrderRecDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrderRecDep,langid)
		s OrderOperation=""
		s OrderOperationCode=$p($g(^OEORD(+LinkedMasterOrderRowid,"I",OEORDSubRowID,4)),"^",10)
		if ((OrderOperationCode'="")&&(+OrderOperationCode'="0")) {
	        s curOperId=$P(^OR(EpisodeID,"ANA",$p(OrderOperationCode,"||",2),"OP",$p(OrderOperationCode,"||",3)),"^",6)       ;ANAOP_Type_DR；手术名称
	        if $D(^ORC("OPER",curOperId)) s OrderOperation=$P(^ORC("OPER",curOperId),"^",2) //手术
		}
		s OrderOperationStr=""
		s CalSeqNo=""
		s Data=$lb(rowid,id,OrderMasterSeqNo,OrderName,OrderPackQty,OrderPackUOM,OrderMaterialBarcodeHiden,OrderPrice,OrderSum,OrderRecDep,OrderOperation,OrderRowID,OrderOperationStr,CalSeqNo)
		s ^CacheTemp(repid,ind) = Data
		Set ind=ind+1
	    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetNurseBatchLinkOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurseBatchLinkOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNurseBatchLinkOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurseBatchLinkOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取用户是否有删除当前医嘱的权限，并返回优先级最高的删除权限
/// flag^type 
/// 	0:有权限删除，其他：无权限删除并返回无权限理由
/// 	U：作废，S：停止，C：撤销
ClassMethod GetDealWithType(OrderID As %String, SessionStr As %String) As %String [ ProcedureBlock = 1 ]
{
	s PriorRowid=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1),"^",8)
	s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)

	s ExpStr=$P(SessionStr,"^",1)_"^"_$P(SessionStr,"^",3)_"^"_$P(SessionStr,"^",2)
	s type="U"
	s UnuseOrderAuth=##Class(web.DHCDocInPatPortalCommon).CheckMulOrdDealPermission(OrderID,"","",type,ExpStr)
	//优先执行作废
	if (UnuseOrderAuth=0){

	}elseif (ISLongOrderPrior=1){
		s type="S"
		//长期做停止操作
		s StopOrderAuth=##Class(web.DHCDocInPatPortalCommon).CheckMulOrdDealPermission(OrderID,"","",type,ExpStr)
		if (StopOrderAuth'=0){
			return StopOrderAuth
		}
	}else{
		s type="C"
		//临时做撤销操作
		s CancelOrderAuth=##Class(web.DHCDocInPatPortalCommon).CheckMulOrdDealPermission(OrderID,"","",type,ExpStr)
		if (CancelOrderAuth'=0){
			return CancelOrderAuth
		}
	}


	return "0^"_type
}

}
