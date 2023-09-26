Class web.DHCDocOPOrdInfo Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Modify:增加入参:SelOrderList，根据传入的医嘱ID获取本身及关联医嘱的信息
ClassMethod GetOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", UserID As %String, BillType As %String = "", OrdComStatus As %String = "", SelOrderTypeList As %String = "", SelOrderList As %String = "") As %Status
{
	s ^tmptan("GetOrdByAdm")=EpisodeID_","_UserID_","_BillType_","_OrdComStatus
	///d ##class(%ResultSet).RunQuery("web.DHCDocOPOrdInfo","GetOrdByAdm",929,"","","Y")
	///d ##class(%ResultSet).RunQuery("web.DHCDocOPOrdInfo","GetOrdByAdm","1244","4634","","Y")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if SelOrderList'=""{
		s SelOrderList=..GetMulGroupOrd(SelOrderList)
	}
	k CatType
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.SubCatContral.ReOrdSubCatList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s Rowid=rset.Data("Rowid")
			s Desc=rset.Data("Desc")
			s Code=rset.Data("Code")
			
			s CatList=..%GetConfig1("DHCDocReSetOrdSubCat",Rowid)
			s CatType(Desc)=CatList
			s CatType(Desc,"Code")=Code
		}
	}
	
	k ^TMPOrdTypeByAdm(EpisodeID," "_UserID)
	k OrdList
	Set rset=##Class(%ResultSet).%New("web.DHCDocQryOEOrder.GetOrdByAdm")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(EpisodeID,UserID,"","","","","","","","","","",OrdComStatus)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			////OrdCreateDate:OrdCreateTime:OrdStartDate:OrdStartTime:ArcimDesc:
			///DoseQty:DoseUnit:Priority:PHFreq:Instr:
			///Doctor:OrdStatus:Dura:OEItemID:PatientID:
			///QtyPackUOM:PackUOMDesc:PrescNo:dstatus:LabEpisodeNo:
			///OrdLabSpec:OrdXDate:OrdXTime:OrdSkinTest:OrdAction
			///:OrdDepProcNotes:OrdBilled:OrdSkinTestResult:OrderPackQty:OrderPrescNo
			///:Pqty:ArcPrice:ReLoc:LabNo:userDep:
			///UserAdd:XUser:EndDate:EndTime:CoverMainInsur:
			///BillType:DspConfirmQty:ActiveQty:ActiveQtySum:MaterialBarCode:
			///OrderType:OrderSum:OrderPrintFlag:ReLocID:UserAddID:
			///DoctorID:PHFreqDesc:OEItemDR:ARCIMRowId:ordcatno:SeqNo:
			s OEItemID=rset.Data("OEItemID")
			continue:(SelOrderList'="")&&(("^"_SelOrderList_"^")'[("^"_OEItemID_"^"))
			s Desc=rset.Data("ArcimDesc")
			s Desc=$replace(Desc,"/","")
			s DoseQty=rset.Data("DoseQty")
			s DoseUnit=rset.Data("DoseUnit")
			s PHFreq=rset.Data("PHFreq")
			s Instr=rset.Data("Instr")
			s OrderPackQty=rset.Data("OrderPackQty")
			s PackUOMDesc=rset.Data("PackUOMDesc")
			;判断判断是数字打头的情况
			if +$E(PackUOMDesc,1)=$E(PackUOMDesc,1) s PackUOMDesc="("_PackUOMDesc_")"
			s PrescNo=rset.Data("PrescNo")
			s OrdBilled=rset.Data("OrdBilled")
			s PackQty=""
			s:(OrderPackQty'="") PackQty=OrderPackQty_PackUOMDesc
			s Pqty=rset.Data("Pqty")
			s Price=$j(rset.Data("ArcPrice"),"",2)
			s ReLoc=rset.Data("ReLoc")
			s OrderSum=rset.Data("ActiveQtySum")
			//w OrderSum,!
			s ARCIMRowId=rset.Data("ARCIMRowId")
			s OEItemID=rset.Data("OEItemID")
			s ActiveQty=rset.Data("Pqty")_""_PackUOMDesc  //rset.Data("ActiveQty")
			s Dura=rset.Data("Dura")
			s PHFreq=rset.Data("PHFreq")
			s DrugActiveQty=rset.Data("ActiveQty")
			s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",10)
			s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
			//s OrderTypeDr=$P(^ARC("IC",ItemCatRowid),"^",8)
			//s OrderTypeDesc=$P(^OEC("ORCAT",OrderTypeDr),"^",2)
			s OrderTypeDesc="Other"
			s OrderTypeCode=99
			s tmpDesc=""
			for {
				s tmpDesc=$O(CatType(tmpDesc))
				q:tmpDesc=""
				if ("^"_CatType(tmpDesc)_"^")[("^"_ItemCatRowid_"^"){
					s OrderTypeDesc=tmpDesc
					s OrderTypeCode=+CatType(tmpDesc,"Code")
					q
				}
			}
			s AdmReason=rset.Data("BillType")
			s MaterialBarCode=rset.Data("MaterialBarCode")
			s LabNo=rset.Data("LabNo")
			s OrdLabSpec=rset.Data("OrdLabSpec")
			s OrdSkinTest=rset.Data("OrdSkinTest")
			s OrdAction=rset.Data("OrdAction")
			s OrdSkinTestResult=rset.Data("OrdSkinTestResult")
			s OrdDepProcNotes=rset.Data("OrdDepProcNotes")
		    s OEDStatus=rset.Data("dstatus")
		    
			s Doctor=rset.Data("Doctor")
			s OrdStatus=rset.Data("OrdStatus")
			s OrdStartDate=rset.Data("OrdStartDate")_" "_rset.Data("OrdStartTime")
			s UserDep=rset.Data("userDep")
			s ReportLinkInfo=""
			s VisitNumberTestSetDR=$P($G(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),3)),"^",35)
			//检验报告信息
 			if (VisitNumberTestSetDR'=""){
				s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
				s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),3)
				i $l(VisitNumberDR) {
					s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
					i $l(WorkGroupMachineDR){
						s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
						s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
						i $l(OrderNo) {
							s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
							s Status=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)
							if (Status="3"){
								//1登记，2初审，3审核，4复查，5取消审核，6作废，O其他
								s ReportLinkInfo="L!"_ReportDR
							}
							
						}
					}
				}
	 		}
	 		//检查报告信息
	 		s PACSReportStatusInfo=##Class(RISService.TrakRISService).GetRisRPTStatusByOEORowid(OEItemID)
	 		if (PACSReportStatusInfo["发布") {
		 		s RisReportStudyNo=$P(PACSReportStatusInfo,"^",1)
		 		s ReportLinkInfo="Ris!"_OEItemID_"!"_RisReportStudyNo
		 	}
	 		
 			s Priority=rset.Data("Priority")
 			s OrdXDate=rset.Data("OrdXDate")
 			s OrdXTime=rset.Data("OrdXTime")
 			s OrderUsableDays=rset.Data("OrderUsableDays")
 			s OrderNotifyClinician=rset.Data("OrderNotifyClinician")
 			s OrdSpeedFlowRate=rset.Data("OrdSpeedFlowRate")
 			s OrderFlowRateUnitdesc=rset.Data("OrderFlowRateUnitdesc")
 			s OrderNeedPIVAFlag=rset.Data("OrderNeedPIVAFlag")
 			s OrderLocalInfusionQty=rset.Data("OrderLocalInfusionQty")
 			s ExceedReasonDesc=rset.Data("ExceedReasonDesc")
 			s OrderStage=rset.Data("OrderStage")
 			s OrderPilotPro=rset.Data("OrderPilotPro")
 			s OrderOperation=rset.Data("OrderOperation")
 			s OrderDIACat=rset.Data("OrderDIACat")
 			s SeqNo=rset.Data("SeqNo")
 			s OrderViewFlag=rset.Data("OrderViewFlag")
 			s IsCNMedItem=rset.Data("IsCNMedItem")
 			s BindSource=rset.Data("BindSource")
 			s OrderChronicDiagCode=rset.Data("OrderChronicDiagCode")
 			s ARCOSRowId=rset.Data("ARCOSRowId")
 			s ArcimARCOSRowId=rset.Data("ArcimARCOSRowId")
 			s XUser=rset.Data("XUser")
 			s SignFlag=rset.Data("SignFlag")
 			;判断判断是数字打头的情况
			if +$E(DoseUnit,1)=$E(DoseUnit,1) s DoseUnit="("_DoseUnit_")"
			//if (DoseUnit'="") s DoseQty=DoseQty_DoseUnit 
			s CoverMainInsur=rset.Data("CoverMainInsur")
			s InsuNationCode=rset.Data("InsuNationCode")
			s InsuNationName=rset.Data("InsuNationName")
			s OrdSerialNum=rset.Data("OrdSerialNum")
			s OrdSpecDiagnosForm=rset.Data("OrdSpecDiagnosForm")
			s OrdSpecLocDiagCatCode=rset.Data("OrdSpecLocDiagCatCode")
			s Data=$LB(OrderSum,Price,Desc,DoseQty_DoseUnit,Dura,PHFreq,ActiveQty,ReLoc,PrescNo,OrdBilled,OEItemID,DrugActiveQty,AdmReason,MaterialBarCode,LabNo,OrdLabSpec,OrdSkinTest,OrdAction,OrdSkinTestResult,OrdDepProcNotes,OEDStatus,PackQty,Instr,Doctor,OrdStatus,OrdStartDate,UserDep,ReportLinkInfo,Priority,OrdXDate,OrdXTime,OrderUsableDays,OrderNotifyClinician,OrdSpeedFlowRate,OrderFlowRateUnitdesc,OrderNeedPIVAFlag,OrderLocalInfusionQty,ExceedReasonDesc,OrderStage,OrderPilotPro,OrderOperation,OrderDIACat,SeqNo,OrderViewFlag,IsCNMedItem,BindSource,OrderChronicDiagCode,ARCOSRowId,ArcimARCOSRowId,XUser,SignFlag,CoverMainInsur,InsuNationCode,InsuNationName,"",OrdSerialNum,OrdSpecDiagnosForm,OrdSpecLocDiagCatCode)
			///OrderSum:%String,Price:%String,Desc:%String,DoseQty:%String,Dura:%String,PHFreq:%String,ActiveQty:%String,ReLoc:%String,PrescNo:%String,OrdBilled:%String
			//OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,Doctor,OrdStatus,Dura,OEItemID,PatientID,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OrderPackQty,OrderPrescNo,Pqty,ArcPrice,ReLoc,LabNo,userDep,UserAdd,XUser,EndDate,EndTime,CoverMainInsur,BillType,DspConfirmQty,ActiveQty,ActiveQtySum,MaterialBarCode,OrderType,OrderSum,OrderPrintFlag,ReLocID,UserAddID,DoctorID,PHFreqDesc,OEItemDR,ARCIMRowId,ordcatno,SeqNo
			///先做统计数据，再做continue
 			s OrdList(OrderTypeCode,"Ord",OEItemID)=Data
			s OrdList(OrderTypeCode,"Desc")=OrderTypeDesc
			s PatTotleSum=$G(PatTotleSum)+OrderSum
			if (OrdBilled="已收费"){
				s PatPayedSum=$G(PatPayedSum)+OrderSum
			}
			continue:(BillType'="")&&(OrdBilled'=BillType)
 			if (SelOrderTypeList'=""){
				if ("_"_SelOrderTypeList_"_")'[("_"_OrderTypeCode_"_"){
					continue
				}
			}
			d OutputRow
			
		}
		d rset.Close()
	}
	
	s OrderTypeCode=""
	for {
		s OrderTypeCode=$O(OrdList(OrderTypeCode))
		q:OrderTypeCode=""
		s OrderTypeDesc=$G(OrdList(OrderTypeCode,"Desc"))
		s TotalSum=0
		s OEOrdRowID=0
		for {
			s OEOrdRowID=$O(OrdList(OrderTypeCode,"Ord",OEOrdRowID))
			q:OEOrdRowID=""
			s Data=OrdList(OrderTypeCode,"Ord",OEOrdRowID)
			
			s OneSum=$List(Data,1)
			s TotalSum=TotalSum+OneSum
			//i (TotalSum[".")&&($p(TotalSum,".",1)="") s TotalSum="0"_TotalSum
		}
		i PatTotleSum'=0 s Proport=$fn(TotalSum/PatTotleSum,"",2)*100_"%"
		e  s Proport=0
		/*
		s Data=$lb("","","","","","","","","")
		s $list(Data,1)=$j(TotalSum,"",2)
		s $list(Data,3)=Proport
		s $list(Data,10)=OrderTypeDesc
		d OutputRow
		*/
		s ^TMPOrdTypeByAdm(EpisodeID," "_UserID,"OrderTypeCode",OrderTypeCode)=OrderTypeDesc_"^"_$j(TotalSum,"",2)_"^"_Proport
	}
	s ^TMPOrdTypeByAdm(EpisodeID," "_UserID,"PatTotleSum")=$G(PatTotleSum)
	s ^TMPOrdTypeByAdm(EpisodeID," "_UserID,"PatPayedSum")=$G(PatPayedSum)
	
	
	
	Set qHandle=$lb(0,repid,0)
 	quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetMulGroupOrd(rowList)
{
	s MulGroupOrdStr=""
	for loop=1:1:$l(rowList,"^"){
		s row=$p(rowList,"^",1)
		s mainRowId=$p($g(^OEORD(+row,"I",$p(row,"||",2),11)),"^",39)
		s:mainRowId="" mainRowId=row
		if MulGroupOrdStr=""{
			s MulGroupOrdStr=mainRowId
		}else{
			s MulGroupOrdStr=MulGroupOrdStr_"^"_mainRowId	
		}
		s sub="" for{
			s sub=$o(^OEORDi(0,"OEORI",+row,mainRowId,sub))  q:sub=""
	 		s arcim=$p($g(^OEORD(+row,"I",sub,1)),"^",2)
	 		continue:arcim=""
	 		s ordRowID=+row_"||"_sub
	 		s MulGroupOrdStr=MulGroupOrdStr_"^"_ordRowID
		}
	}	
	Q MulGroupOrdStr
}

/// w ##Class(web.DHCDocOPOrdInfo).GetOrdCalInfoByAdm(1415,"")
/// 获取计算类型的值
ClassMethod GetOrdCalInfoByAdm(EpisodeID As %String, UserID As %String) As %String
{
	s ^tan("GetOrdCalInfoByAdm")=EpisodeID_","_UserID
	s OrdTypeList=[]
	//总费用
	s PatTotleSum=$G(^TMPOrdTypeByAdm(EpisodeID," "_UserID,"PatTotleSum"))
	s PatTotleSum=$fn(PatTotleSum,"",2)
	//已缴费
	s PatPayedSum=$G(^TMPOrdTypeByAdm(EpisodeID," "_UserID,"PatPayedSum"))
	//未缴费
	s PatUnPayedSum=PatTotleSum-PatPayedSum
	//余额
	s CurrentDeposit=##class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)
	s OrderTypeDesc=##class(websys.Translation).Get("oeorder.opbillinfo.csp","全部")
	s JsonData={}
	do JsonData.%Set("text",OrderTypeDesc_"("_PatTotleSum_")")
	do JsonData.%Set("id","All")
	do JsonData.%Set("Proport","100%")
	do JsonData.%Set("selected",1)
	do OrdTypeList.%Push(JsonData,"")
	s OrderTypeCode=""
	for {
		s OrderTypeCode=$O(^TMPOrdTypeByAdm(EpisodeID," "_UserID,"OrderTypeCode",OrderTypeCode))
		q:OrderTypeCode=""
		s OrderTypeDesc=$P(^TMPOrdTypeByAdm(EpisodeID," "_UserID,"OrderTypeCode",OrderTypeCode),"^",1)
		s TotalSum=$P(^TMPOrdTypeByAdm(EpisodeID," "_UserID,"OrderTypeCode",OrderTypeCode),"^",2)
		s Proport=$P(^TMPOrdTypeByAdm(EpisodeID," "_UserID,"OrderTypeCode",OrderTypeCode),"^",3)
		s OrderTypeDesc=##class(websys.Translation).Get("oeorder.opbillinfo.csp",OrderTypeDesc)
		s JsonData={}
		do JsonData.%Set("text",OrderTypeDesc_"("_TotalSum_")")
		do JsonData.%Set("id",OrderTypeCode)
		do JsonData.%Set("Proport",Proport)
		do OrdTypeList.%Push(JsonData,"")
	}
	
	s InfoDisplay=[]
	
	s JsonData={}
	do JsonData.%Set("text",##class(websys.Translation).Get("oeorder.opbillinfo.csp","总费用")_":"_$fn(+PatTotleSum,"",2))
	do JsonData.%Set("id","PatTotleSum")
	do JsonData.%Set("selected",1)
	do InfoDisplay.%Push(JsonData,"")
	s JsonData={}
	do JsonData.%Set("text",##class(websys.Translation).Get("oeorder.opbillinfo.csp","已缴费")_":"_$fn(+PatPayedSum,"",2))
	do JsonData.%Set("id","PatPayedSum")
	do JsonData.%Set("selected",1)
	do InfoDisplay.%Push(JsonData,"")
	s JsonData={}
	do JsonData.%Set("text",##class(websys.Translation).Get("oeorder.opbillinfo.csp","未缴费")_":"_$fn(+PatUnPayedSum,"",2))
	do JsonData.%Set("id","PatUnPayedSum")
	do JsonData.%Set("selected",1)
	do InfoDisplay.%Push(JsonData,"")
	s JsonData={}
	do JsonData.%Set("text",##class(websys.Translation).Get("oeorder.opbillinfo.csp","余额")_":"_CurrentDeposit)
	do JsonData.%Set("id","CurrentDeposit")
	do JsonData.%Set("selected",1)
	do InfoDisplay.%Push(JsonData,"")
	
	s JsonObj={}
	d JsonObj.%Set("OrdTypeList",OrdTypeList)
	d JsonObj.%Set("AdmInfo",InfoDisplay)

	
	
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	
	k ^TMPOrdTypeByAdm(EpisodeID," "_UserID)
	q JsonStr
}

ClassMethod GetOrdByAdmClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetOrdByAdmFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetOrdByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
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

Query GetOrdByAdm(EpisodeID As %String = "", UserID As %String = "", BillType As %String = "", OrdComStatus As %String = "", SelOrderTypeList As %String = "", SelOrderList As %String = "") As %Query(ROWSPEC = "OrderSum:%String:总价,Price:%String:单价,Desc:%String:医嘱名称,DoseQty:%String:单次剂量,Dura:%String:疗程,PHFreq:%String:频次,ActiveQty:%String,ReLoc:%String:接收科室,PrescNo:%String:处方号,OrdBilled:%String:计费状态,OEItemID:%String:编号,DrugActiveQty:%String:实发数量,AdmReason:%String:费别,MaterialBarCode:%String:高值条码,LabNo:%String:检验号,OrdLabSpec:%String:标本,OrdSkinTest:%String:皮试,OrdAction:%String:皮试备注,OrdSkinTestResult:%String:皮试结果,OrdDepProcNotes:%String:备注,OEDStatus:%String:发药状态,PackQty:%String:数量,Instr:%String:用法,Doctor:%String:医师,OrdStatus:%String:医嘱状态,OrdStartDate:%String:开始时间,UserDep:%String:科室,ReportLinkInfo:%String,Priority:%String:优先级,OrdXDate:%String:停止日期,OrdXTime:%String:停止时间,OrderUsableDays:%String:可用天数,OrderNotifyClinician:%String:加急,OrdSpeedFlowRate:%String:输液流速,OrderFlowRateUnitdesc:%String:流速单位,OrderNeedPIVAFlag:%String:需要配液,OrderLocalInfusionQty:%String:输液次数,ExceedReasonDesc:%String:疗程超量原因,OrderStage:%String:医嘱阶段,OrderPilotPro:%String:药理项目,OrderOperation:%String:手术列表,OrderDIACat:%String:诊断类别,SeqNo:%String:组号,OrderViewFlag:%String,IsCNMedItem:%String,BindSource:%String:绑定来源,OrderChronicDiagCode:%String:慢病病种,ARCOSRowId:%String,ArcimARCOSRowId:%String,StopDoc:%String,SignFlag:%String,CoverMainInsur:%String:医保,InsuNationCode:%String:国家医保编码,InsuNationName:%String:国家医保名称,ExeDetails:%String:执行情况,OrdSerialNum:%String:医嘱流水号,OrdSpecDiagnosForm:%String:专科表单,OrdSpecLocDiagCatCode:%String:专科表单代码")
{
}

}
