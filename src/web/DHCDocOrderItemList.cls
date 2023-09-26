Class web.DHCDocOrderItemList Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 判断是否绑定产生的医嘱
/// w ##class(web.DHCDocOrderItemList).IsLinkOrderItemInstr(LinkOrderItem,ARCIMRowid)
ClassMethod IsLinkOrderItemInstr(LinkOrderItem, ARCIMRowid)
{
	 n (LinkOrderItem,ARCIMRowid,%session)
	 Quit:LinkOrderItem="" 0
	 s MasterInstrDr=$p($g(^OEORD(+LinkOrderItem,"I",$p(LinkOrderItem,"||",2),2)),"^",7)
	 if MasterInstrDr'="" {
		Set HosId=""
		if $d(%session){
			Set HosId=%session.Get("LOGON.HOSPID")	
		}
		if HosId'="" Set MasterInstrDr=MasterInstrDr_"||"_HosId
		s MasterInstrLinkStr=$g(^DHCDocConfig("InstrArcim",MasterInstrDr))
	 	if (MasterInstrLinkStr[ARCIMRowid) Quit 1
	 	
	 	s MasterInstrLinkStr=$g(^DHCDocConfig("InstrIPArcim",MasterInstrDr))
	 	if (MasterInstrLinkStr[ARCIMRowid) Quit 1
	 }
	 
	 Quit 0
}

/// w ##class(web.DHCDocOrderItemList).GetOrdDoseQty("1721",136)
ClassMethod GetOrdDoseQty(PHCDRowId, UomRowId)
{
	Quit:(PHCDRowId="")||(UomRowId="") 0
	set ret="",find=0
	s ChildSub=$p(PHCDRowId,"||",2)
	s leq=0 for{
		s leq=$o(^PHCD(+PHCDRowId,"DF",ChildSub,"EQ",leq)) q:(leq="")||(find=1)
	  	s eqrec=^PHCD(+PHCDRowId,"DF",ChildSub,"EQ",leq)
	  	s FormDoseUOMRowid=$p(eqrec,"^")
	  	continue:(UomRowId'=FormDoseUOMRowid)
	  	s eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
	  	s find=1,ret=eqdefaultqty
	}
	i ret="" {
	  	s FormDoseUOMRowid=$p($g(^PHCD(+PHCDRowId,"DF",ChildSub,2)),"^",4)
		s FormDoseQty=$p($g(^PHCD(+PHCDRowId,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
		i UomRowId=FormDoseUOMRowid s ret=FormDoseQty,find=1
	}
	
	Quit ret
}

/// w ##class(web.DHCDocOrderItemList).GetPAADMIDStr("0000000023","","","","")
ClassMethod GetPAADMIDStr(Patientno, SttDate, EndDate, Outpatient, Inpatient, CTLOCRowId As %String = "", LogonHospID As %String = "") As %String
{
	set Admstr="",admNum=0,AllFlag=0
	/*if SttDate["-" set SttDate=$zdh(SttDate,3)
	if SttDate["/" set SttDate=$zdh(SttDate,4)
	if EndDate["-" set EndDate=$zdh(EndDate,3)
	if EndDate["/" set EndDate=$zdh(EndDate,4)*/
	i SttDate'="" s SttDate=..%ZDH(SttDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	if (Outpatient="Y")&&(Inpatient="Y") set AllFlag=1
	if (Outpatient="N")&&(Inpatient="N") set AllFlag=1

	if Patientno'="" {
		set Papmidr=$o(^PAPERi("PAPMI_PatNo",Patientno,""))
		Q:Papmidr="" ""
		set Paadmtype="" for{
			set Paadmtype=$o(^PAPERdr(Papmidr,"ADM",Paadmtype),-1) Quit:(Paadmtype="")
			continue:((Inpatient="Y")&&(Paadmtype'="I")&&(AllFlag=0))
			continue:((Outpatient="Y")&&(Paadmtype="I")&&(AllFlag=0))
			set PaadmId="" for{
				set PaadmId=$o(^PAPERdr(Papmidr,"ADM",Paadmtype,PaadmId),-1) Quit:(PaadmId="")
				set Paadmdate=$p(^PAADM(PaadmId),"^",6)
				continue:(Paadmdate<SttDate)&&(SttDate'="")&&(Paadmtype'="I")
				continue:(Paadmdate>EndDate)&&(EndDate'="")&&(Paadmtype'="I")
				set Depcodedr=$p(^PAADM(PaadmId),"^",4)
				continue:(CTLOCRowId'="")&&(CTLOCRowId'=Depcodedr)
				s CTLocHospDr=$p(^CTLOC(Depcodedr),"^",22)
	            continue:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
				set Doccodedr=$p(^PAADM(PaadmId),"^",9)
				continue:(Doccodedr="")
				//continue:(DocNameID'="")&&(DocNameID'=Doccodedr)
				;set Depdesc=$p(^CTLOC(Depcodedr),"^",2)
				;if Depdesc["-" set Depdesc=$p(Depdesc,"-",2)
				;set DocDesc=$p(^CTPCP(Doccodedr,1),"^",2)
				;set Patname=$p($g(^PAPER(Papmidr,"ALL")),"^",1)
				;set Patientno=$p(^PAPER(Papmidr,"PAT",1),"^",1)
				set admNum=admNum+1
				if Admstr="" set Admstr=PaadmId //_$c(2)_Patname_Patientno_" "_Depdesc_" "_DocDesc_" "_$zd(Paadmdate,3)
				else  set Admstr=Admstr_"^"_PaadmId //_$c(2)_Patname_Patientno_" "_Depdesc_" "_DocDesc_" "_$zd(Paadmdate,3)
			}
		}
	}else{
		if SttDate="" set SttDate=..%SysDate()
		if EndDate="" set EndDate=..%SysDate()
		
		for Admdate=SttDate:1:EndDate {
			set PaadmId="" for{
				set PaadmId=$o(^PAADMi("PAADM_AdmDate",Admdate,PaadmId)) Quit:PaadmId=""
				set Paadmtype=$p(^PAADM(PaadmId),"^",2)
				continue:((Paadmtype'="O")&&(Paadmtype'="E"))
				continue:((Inpatient="Y")&&(Paadmtype'="I")&&(AllFlag=0))
				continue:((Outpatient="Y")&&(Paadmtype="I")&&(AllFlag=0))
				set Depcodedr=$p(^PAADM(PaadmId),"^",4)
				continue:(CTLOCRowId'="")&&(CTLOCRowId'=Depcodedr)
				s CTLocHospDr=$p(^CTLOC(Depcodedr),"^",22)
	            continue:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
				set Doccodedr=$p(^PAADM(PaadmId),"^",9)
				continue:(DocNameID'="")&&(DocNameID'=Doccodedr)
				;set Depdesc=$p(^CTLOC(Depcodedr),"^",2)
				;if Depdesc["-" set Depdesc=$p(Depdesc,"-",2)
				;set DocDesc=$p(^CTPCP(Doccodedr,1),"^",2)
				;set Papmidr=$p(^PAADM(PaadmId),"^",1)
				;set Patname=$p($g(^PAPER(Papmidr,"ALL")),"^",1)
				;set Patientno=$p(^PAPER(Papmidr,"PAT",1),"^",1)
				if Admstr="" set Admstr=PaadmId //_$c(2)_Patname_Patientno_" "_Depdesc_" "_DocDesc_" "_$zd(Admdate,3)
				else  set Admstr=Admstr_"^"_PaadmId //_$c(2)_Patname_Patientno_" "_Depdesc_" "_DocDesc_" "_$zd(Admdate,3)
			}
		}
	}
	Quit Admstr
}

ClassMethod GetPAADMInfo(PaadmId) As %String
{
	set AdmInfo=""
	Quit:PaadmId="" ""
	set Paadmdate=$p(^PAADM(PaadmId),"^",6)
	set Depcodedr=$p(^PAADM(PaadmId),"^",4)
	set Depdesc=$p($g(^CTLOC(Depcodedr)),"^",2)
	if Depdesc["-" set Depdesc=$p(Depdesc,"-",2)
	set Doccodedr=$p(^PAADM(PaadmId),"^",9)
	set DocDesc=$p(^CTPCP(Doccodedr,1),"^",2)
	set Papmidr=$p(^PAADM(PaadmId),"^",1)
	set Patname=$p($g(^PAPER(Papmidr,"ALL")),"^",1)
	set Patientno=$p(^PAPER(Papmidr,"PAT",1),"^",1)
	set AdmInfo=Patname_" "_Patientno_" "_Depdesc_" "_DocDesc_" "_..%ZD(Paadmdate) //$zd(Paadmdate,3)
	Quit AdmInfo
}

ClassMethod GetPAPMINo(PaadmId) As %String
{
	Quit:PaadmId="" ""
	set Papmidr=$p(^PAADM(PaadmId),"^",1)
	set Patname=$p($g(^PAPER(Papmidr,"ALL")),"^",1)
	set Patientno=$p($g(^PAPER(Papmidr,"PAT",1)),"^",1)
	
	Quit Patientno
}

/// w ##class(web.DHCDocOrderItemList).CheckOrderUserPoison("225")
ClassMethod CheckOrderUserPoison(UserId) As %String
{
	Quit:UserId="" ""
	set CareProvDR=$p($g(^SSU("SSUSR",UserId)),"^",14)
	Quit:CareProvDR="" ""
	set Anaesthetist=$p($g(^CTPCP(CareProvDR,2)),"^",19)
	Quit:Anaesthetist="Y" 1
	Quit 0
}

ClassMethod GetKFStartTime(FreqRowid) As %String
{
	Quit:FreqRowid="" ""
	set twelveTime=..%ZTH("12:00",1)
	set nowTime=..%SysTime()
	set flag=0,ret=""
	if twelveTime>nowTime set ret=twelveTime+1
	/*
	set DTchl=0
	for {
		set DTchl=$o(^PHCFR(FreqRowid,"DT",DTchl)) q:(DTchl="")||(flag=1)
		set DTtime=^PHCFR(FreqRowid,"DT",DTchl)
		if DTtime>nowTime set flag=1
		if DTtime=twelveTime set ret=twelveTime+1
	}
	*/
	Quit:ret="" ""
	Quit ..%ZT(ret,1)
}

ClassMethod GetPATType(CtlocId) As %String
{
	Quit:CtlocId="" "O"
	Quit:$d(^PAC("ADMLOC",0,"AdmType","O",CtlocId)) "O"
	Quit:$d(^PAC("ADMLOC",0,"AdmType","E",CtlocId)) "E"
	Quit:$d(^PAC("ADMLOC",0,"AdmType","I",CtlocId)) "I"
	Quit "I"
}

ClassMethod GetOrderPrior(PriorCode) As %String
{
	Quit:PriorCode="" "^"
	set PriorRowid=$O(^OECPR(0,"Code",PriorCode,0))
	Quit:PriorRowid="" "^"
	Quit PriorRowid_"^"_$p(^OECPR(PriorRowid),"^",2)
}

ClassMethod GetARCIMDesc(PrefType, PrefId) As %String
{
	Quit:PrefId="" ""
	set PrefName=""
	if PrefType="ARCIM" set PrefName=$p($g(^ARCIM(+PrefId,1,1)),"^",2)
	if PrefType="ARCOS" set PrefName=$p($g(^ARCOS(+PrefId)),"^",2)
	Quit PrefName
}

ClassMethod GetDefaultARCIMFreq(ArcimRowid) As %String
{
	Quit:ArcimRowid="" ""
	s ret=""
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	i DrgformRowid'="" {
	  	s PHCDRowid=$P(DrgformRowid,"||",1)
	  	s ChildSub=$P(DrgformRowid,"||",2)	  
	  	s FormFreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)
	  	i FormFreqRowid'="" {
		  	s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		  	s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		  	s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		  	s ret=FormFreqRowid_"^"_FormFreqDesc
	  	}	  	
	}
	Quit ret
}

/// 判断病人有无皮试结果 0:有结果1:无结果 空代表无皮试医嘱
/// w ##class(web.DHCDocOrderItemList).GetARCIMSkinTestResult(177)
ClassMethod GetARCIMSkinTestResult(EpisodeID) As %String
{
	Quit:EpisodeID="" ""
	s OrdId=$o(^OEORD(0,"Adm",EpisodeID,""))
	Quit:OrdId="" ""
	s StDate=..%SysDate(),ret=""
	While (StDate'="") {
		s Childsub=""
		for {
			s Childsub=$o(^OEORDi(0,"StDt",StDate,OrdId,Childsub),-1) q:Childsub=""
			continue:'$d(^OEORD(OrdId,"I",Childsub,5))
			s AdministerSkinTest=$p(^OEORD(OrdId,"I",Childsub,5),"^",2)
			continue:AdministerSkinTest'="Y"
			s Abnormal=$p(^OEORD(OrdId,"I",Childsub,11),"^",3)
			i Abnormal="Y" s ret=0
			e  s ret=1
			q
		}
		i StDate+3=..%SysDate() {
			s StDate=""
		}else{
			s StDate=StDate-1
		}	  	
	}
	Quit ret
}

ClassMethod GetMRADMInfoByID(PatientID, mradm) As %String
{
	Quit:((PatientID="")||(mradm="")) ""
	set PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
 	//if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
 	//else  s PatientSex=""
 	//s PatientDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
 	//s AgeDesc=##class(web.DHCDTHealthCommon).GetAgeDesc(PatientDOB,+$H)
 	;set PatientAge=##class(web.PAPerson).calculateAgeUnitsShow(PatientID)
	set PatientAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"")
 	set RetStr="",DiagnosStr=""
	set Childsub=0
	for {
		set Childsub=$o(^MR(mradm,"DIA",Childsub)) quit:Childsub=""
		if DiagnosStr="" set DiagnosStr=mradm_"||"_Childsub
		else  set DiagnosStr=DiagnosStr_$c(2)_mradm_"||"_Childsub
	}
	set RetStr=PatientSexDr_"^"_PatientAge_"^^"_DiagnosStr
	Quit RetStr
}

ClassMethod CheckDispensing(ArcimRowid, RecDepRowid) As %String
{
	set ret=""
	Quit:(ArcimRowid="")||(RecDepRowid="") ret
	set INCIRowid=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))
	Quit:INCIRowid="" ret
	if $d(^DHCWHSYPHALOC("LOC",RecDepRowid,"INCI",INCIRowid)) do
	.set ret=^DHCWHSYPHALOC("LOC",RecDepRowid,"INCI",INCIRowid)
	
	Quit ret
}

ClassMethod CheckCurrentDateTime(OrdStDate, CurrDate = "") As %String
{
	Quit:OrdStDate="" "0"
	if OrdStDate["-" set OrdStDate=$zdh(OrdStDate,3)
	if OrdStDate["/" set OrdStDate=$zdh(OrdStDate,4)
	if CurrDate'="" {
		if CurrDate["-" set CurrDate=$zdh(CurrDate,3)
		if CurrDate["/" set CurrDate=$zdh(CurrDate,4)
	}else{set CurrDate=..%SysDate()}
	Quit:(OrdStDate-CurrDate)<0 "-1"
	Quit OrdStDate-CurrDate
}

Query LookUpPrior(EpisodeID As %String, PriorCode As %String) As %Query(ROWSPEC = "Desc:%String,RowId:%String")
{
}

Query FindAdmOrderItems(EpisodeID As %String, GroupRowId As %String, PriorID As %String, CTLOCRowId As %String, DocNameID As %String, Drug As %String, notDrug As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderFreq:%String,OrderInstr:%String,OrderDur:%String,OrderPrice:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderSkinTest:%String,OrderRecDep:%String,OrderUserDep:%String,OrderOrdDep:%String,OrderSum:%String,OrderPrescNo:%String,OrderDepProcNote:%String,OrderDoc:%String,OrderUserAdd:%String,OrderDate:%String,OrderSeqNo:%String,OrderMasterSeqNo:%String,OrderLinkTo:%String,OrderLabEpisodeNo:%String,OrderItemRowid:%String,OrderARCIMRowid:%String,OrderSttDate:%String,OrderDoseUOMRowid:%String,OrderFreqRowid:%String,OrderPriorRowid:%String,OrderInstrRowid:%String,OrderDurRowid:%String,OrderPackUOMRowid:%String,OrderRecDepRowid:%String,OrderUserDepRowid:%String,OrderOrdDepRowid:%String,OrderStatusRowid:%String,OrderBaseUOMRowid:%String,OrderDocRowid:%String,OrderUserAddRowid:%String,OrderARCOSRowid:%String,OrderDrugFormRowid:%String,OrderMaxDurRowid:%String,OrderType:%String,OrderBillType:%String,OrderFreqFactor:%String,OrderFreqInterval:%String,OrderDurFactor:%String,LinkOrderItem:%String,EpisodeID:%String,OrderBillTypeRowId:%String,OrderItemInValid:%String,OrderStage:%String,OrderStageDesc:%String,TOrderEndDate:%String,TOrderEndTime:%String,OrderPackQtyHidden:%String,OrderPackUOMRowidHidden:%String,OrderPackUOMHidden:%String,OrderActionRowid:%String,OrderAction:%String,OrderNotifyClinician:%String,OrdSpeedFlowRate:%String,OrderFlowRateUnit:%String,OrderFlowRateUnitdesc:%String,OrderFreqTimeDoseQtyStr:%String,OrderFreqDispTimeStr:%String,ExceedReasonID:%String,ExceedReason:%String")
{
}

ClassMethod FindAdmOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmOrderItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmOrderItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, GroupRowId As %String = "", PriorID As %String, CTLOCRowId As %String, DocNameID As %String, Drug As %String, notDrug As %String) As %Status
{
 	;d ##class(%ResultSet).RunQuery("web.DHCDocOrderItemList","FindAdmOrderItems",315,29,5,"","","","")
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	set ^jasontr("list")=EpisodeID_","_GroupRowId_","_PriorID_","_CTLOCRowId_","_DocNameID_","_Drug_","_notDrug
 	if EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	set PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",LabEpisodeNo=""
 	s LogonHospDr=%session.Get("LOGON.HOSPID")
 	set UseCNMedEntry=..%GetConfig("UseCNMedEntry",LogonHospDr)
 	set PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
 	set PatType=$P(^PAADM(EpisodeID,1),"^",6)  //PAADM_Epissubtype_DR
	if GroupRowId="" s GroupRowId=%session.Get("LOGON.GROUPID")
	set NoDisplayItemCat=..%GetConfig("NoDisplayItemCat",LogonHospDr)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s LogonUserID=%session.Get("LOGON.USERID")
	s LogonDoctorType=##class(web.SSUser).GetDefaultCareProviderType(LogonUserID)
	Set langid=..%LanguageID()
	do ResetVariables
	;如果没有选择类别条件则都查出
	s CheckFlag=1
	i (Drug="on")&&(notDrug="on") s CheckFlag=0
	i (Drug'="on")&&(notDrug'="on") s CheckFlag=0
	&SQL(DECLARE OrdCur0 CURSOR FOR
		 SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,
			OEORI_SttDat,OEORI_SttTim,
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
			OEORI_ARCOS_DR,OEORI_BBExtCode,OEORI_OEORI_DR,OEORI_Date,
			OEORI_OrdDept_DR,OEORI_OrdDept_DR->CTLOC_Desc,OEORI_XDate,OEORI_XTime,
			OEORI_Action_DR,OEORI_Action_DR->ACT_Desc
		 INTO :OrderItemRowid,:ARCIMRowid,:OrderName,:OrderSttDate,:OrderSttTime,
			:OrderDoseQty,:OrderDoseUOMRowid,:OrderDoseUOM,:OrderPackQty,
			:OrderPriorRowid,:OrderPrior,:OrderStatusRowid,:OrderStatus,:OrderFreqRowid,:OrderFreq,
			:OrderInstrRowid,:OrderInstr,:OrderDurRowid,:OrderDur,
			:OrderRecDepRowid,:OrderRecDep,:OrderUserDepRowid,:OrderUserDep,
			:OrderDocRowid,:OrderDoc,:OrderUserAddRowid,:OrderUserAdd,
			:OrderBilled,:OrderSkinTest,:OrderBillTypeRowid,:OrderType,
			:OrderSeqNo,:OrderMasterSeqNo,:OrderLinkTo,:OrderPrescNo,:OrderLabEpisodeNo,
			:OrderARCOSRowid,:OrderBillTypeRowid,:LinkOrderItem,:OrderDate,
			:OrderOrdDepRowid,:OrderOrdDep,:TOrderEndDate,:TOrderEndTime,
			:OrderActionRowid,:OrderAction
		 From SQLUser.OE_OrdItem 
		 WHERE OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and (OEORI_ItemStat_DR->OSTAT_Code<>'I')
		 Order By OEORI_SttDat desc)
	 &SQL(OPEN OrdCur0)
	 For  &SQL(FETCH OrdCur0) QUIT:SQLCODE  do
	 	. s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OrderItemRowid)
	 	. s OrderFreq=$List(OrdFreqInfo,2),OrderFreq=$REPLACE(OrderFreq,"^","-")
	 	. s OrderDoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OrderItemRowid)
	 	. s OrderFreqTimeDoseQtyStr=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",59)
	 	. s OrderFreqTimeDoseQtyStr=$replace(OrderFreqTimeDoseQtyStr,"||","_")
	 	. s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrderItemRowid)
		. s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderPackUOMRowid)
	    . s OrderPackQtyHidden=OrderPackQty
	    . s OrderPackUOMRowidHidden=OrderPackUOMRowid
	    . s OrderPackUOMHidden=OrderPackUOM
	    . s OrderSttDate=..%ZD(OrderSttDate)
	    . s StartDate=..%ZD(OrderSttDate)
	    . s OrderDate=..%ZD(OrderDate)
		. s TOrderEndDate=..%ZD(TOrderEndDate)
		. s TOrderEndTime=##Class(websys.Conversions).TimeLogicalToHtml(TOrderEndTime)
		. s OrderSttTime=##Class(websys.Conversions).TimeLogicalToHtml(OrderSttTime)
		. Q:((PriorID'="")&(PriorID'=OrderPriorRowid))
		. ;Q:((SttDate'="")&(OrderSttDate<SttDate)&(PAADMType="I"))
		. ;Q:((EndDate'="")&(OrderSttDate>EndDate)&(PAADMType="I"))
		. ;Q:(GOrderNameID'=ARCIMRowid)&&(GOrderNameID'="")
		. Q:(CTLOCRowId'="")&&(OrderUserDepRowid'=CTLOCRowId)
		. Q:(DocNameID'="")&&(DocNameID'=OrderDocRowid)
		. q:((Drug="on")&&(OrderType'="R")&&(CheckFlag=1))
		. q:((notDrug="on")&&(OrderType="R")&&(CheckFlag=1))		
		. ;非医生录入的医嘱退出
	    . s CarPrvTpDR=$p($g(^CTPCP(+$g(OrderDocRowid),1)),"^",4)
	    . s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	    . Q:(PAADMType'="I")&&(DoctorType'="DOCTOR")
	    . Q:(LogonDoctorType="DOCTOR")&&(DoctorType="NURSE") //登录用户为医生,非医生录入的医嘱退出
	    . s OrderBindSource=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",41)
	    . Q:(LogonDoctorType="DOCTOR")&&(OrderBindSource'="") //登录用户为医生，自动插入的医嘱不展示
	    . s IsLinkOrderItemInstr=##class(web.DHCDocOrderItemList).IsLinkOrderItemInstr($g(LinkOrderItem),ARCIMRowid)
		. Q:(IsLinkOrderItemInstr=1)
		. ;检验自动绑定上的医嘱不显示
		. s LinkLabNo=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",22)
		. Q:LinkLabNo'=""
		. s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
		. Q:(NoDisplayItemCat'="")&(subcat'="")&(("^"_NoDisplayItemCat_"^")[("^"_subcat_"^"))
		. s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(subcat,LogonHospDr,ARCIMRowid)
		. ;使用草药录入程序
		. Q:(PHPrescType="3")&(UseCNMedEntry="1")
		. s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
		. s orcatdesc=""
		. i orcat'="" s orcatdesc=$p($g(^OEC("ORCAT",orcat)),"^",2)
		. s RecDepDesc=$p(OrderRecDep,"-",2)
		. i RecDepDesc'="" s OrderRecDep=RecDepDesc
		. ;协议单位
		. s ProtocolPackUOMDR=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",13)
		. if ProtocolPackUOMDR'=""  d
		..s OrderPackUOMRowid=ProtocolPackUOMDR
		..s OrderPackUOMRowidHidden=OrderPackUOMRowid
		..s OrderPackUOM=$P($G(^CT("UOM",OrderPackUOMRowid)),"^",2)
		..s OrderPackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderPackUOM,langid)
		..s OrderPackUOMHidden=OrderPackUOM
		. s ExpStr=OrderItemRowid_"^"_""_"^"_EpisodeID_"^"_OrderRecDepRowid
		. s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,OrderRecDepRowid,PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
		. s OrderPrice=$P(retPrice,"^",1)
		. s DiscPrice=$P(retPrice,"^",2)
		. s InsPrice=$P(retPrice,"^",3)
		. s PatPrice=$P(retPrice,"^",4)
		. s OrderPrice=$fn($P(retPrice,"^",1),"",4)
		. if +OrderPackQty=0  d
		. .s Str=##class(web.DHCDocOrderCommon).GetOrderMesage(OrderItemRowid)
		. .s OrderPackQty=$P(Str,"^",4)
		. s OrderSum=OrderPackQty*OrderPrice
		. i OrderBillTypeRowid="" s OrderBillType="自费"
		. e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
		. s OrderBillType=##class(User.PACAdmReason).GetTranByDesc("READesc",OrderBillType,langid)
		. s OrderDoseQty=$TR(OrderDoseQty," ","")
		. i OrderType'="R" d
		. . s DoseqtySum=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1)),"^",12)
		. . s OrderPackQty=DoseqtySum
		. //s OrderPackUOM=$p(OrderPackUOM,"(",1)
		. s OrderSum=OrderPackQty*OrderPrice
		. s OrderSum=$fn(OrderSum,"",4)
		. s OrderDepProcNote=$g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DEP",1))
		. s OrderDepProcNote=##class(web.DHCDocUtil).EvalJSON(OrderDepProcNote)
		. ;s Spec=..GetLabSpec(Rowid)
		. s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
		. s OrderFreqFactor="1",OrderFreqInterval="",OrderDurFactor="1",OrderFreqDispTimeStr="",OrderFreqWeekStr=""
		. if OrderFreqRowid'="" d
		..s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2)
		..s OrderFreqInterval=$P($g(^PHCFR(OrderFreqRowid)),"^",5)
		..s OrderFreqWeek=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",55)
		..s OrderFreqFreeTimeStr=$p($g(^OEORD(+OrderItemRowid,"I",$P(OrderItemRowid,"||",2),"DHC")),"^",68)
		..s OrderFreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrderFreqDispTimeStr(OrderFreqRowid,OrderFreqWeek,OrderFreqFreeTimeStr)
		..s OrderFreqDispTimeStr=$REPLACE(OrderFreqDispTimeStr,$C(1),"~")
		..s OrderFreqDispTimeStr=$REPLACE(OrderFreqDispTimeStr,$C(2),"@")
		..s OrderFreqDispTimeStr=##class(web.DHCDocUtil).EvalJSON(OrderFreqDispTimeStr)
		..//d ##class(web.DHCDocOrderItemList).CalFreqWeekStr(OrderFreqRowid,OrderFreqWeek,.OrderFreqDispTimeStr,.OrderFreqWeekStr)
		.i OrderDurRowid'="" s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
		.s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
		.if OrderItemInValid=0  d
		..s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValOrdcat(GroupRowId,orcat)
		.s OrderLinkTo=LinkOrderItem  ;OrderLinkTo不清楚具体 是做什么用的。输出关联的医嘱ID
		. s OrderStage=$p($G(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",8)
	    . s OrderStageDesc=$CASE(OrderStage,"SZ":"术中","SQ":"术前","SH":"术后","CZ":"产中","":"")
	    . s OrderStageDesc=##class(websys.Translation).Get("doc.ordcopy.hui.csp",OrderStageDesc)
	    . s OrderNotifyClinician=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),11)),"^",55) //加急
	    . s OrdSpeedFlowRate=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),3)),"^",17) //输液流速
		. s OrderFlowRateUnit=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),6)),"^",8) //流速单位
		. s OrderFlowRateUnitdesc=""
		. i OrderFlowRateUnit'="" s OrderFlowRateUnitdesc=$p($g(^OEC("SFR",OrderFlowRateUnit)),"^",2)
		. s ExceedReason=""
		. s ExceedReasonID=$p($G(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",33)
		. if ExceedReasonID'=""  s ExceedReason=$P($G(^DHCDocExceedReason(ExceedReasonID)),"^",2)
		. s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
	 	. s OrderPrior=##class(User.OECPriority).GetTranByDesc("OECPRDesc",OrderPrior,langid)
	 	. s OrderStatus=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",OrderStatus,langid)
	 	. s OrderFreq=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",OrderFreq,langid)
	 	. s OrderInstr=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",OrderInstr,langid)
	 	. s OrderDur=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",OrderDur,langid)
	 	. s OrderRecDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrderRecDep,langid)
	 	. s OrderUserDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrderUserDep,langid)
	 	. s OrderDoc=##class(User.SSUser).GetTranByDesc("SSUSRName",OrderDoc,langid)
	 	. s OrderUserAdd=##class(User.SSUser).GetTranByDesc("SSUSRName",OrderUserAdd,langid)
	 	. s OrderDoseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderDoseUOM,langid)
		. s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,OrderStage,OrderStageDesc,TOrderEndDate,TOrderEndTime,OrderPackQtyHidden,OrderPackUOMRowidHidden,OrderPackUOMHidden,OrderActionRowid,OrderAction,OrderNotifyClinician,OrdSpeedFlowRate,OrderFlowRateUnit,OrderFlowRateUnitdesc,OrderFreqTimeDoseQtyStr,OrderFreqDispTimeStr,ExceedReasonID,ExceedReason)
		.;
		. s OrderItemRowidchild=$P(OrderItemRowid,"||",2)
		. s LinkOrderItemchild=$P(LinkOrderItem,"||",2)
		. i LinkOrderItem="" s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",OrderItemRowidchild)=Data1
		. e  d
		. .if '$D(^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemchild)) d
		. . .s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemchild)=""
		. .s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemchild,"sub",OrderItemRowidchild)=Data1
		&SQL(CLOSE OrdCur0)
	 	;i (Drug'="on")&&(Lab'="on")&&(Exam'="on")&&(Cure'="on") s CheckFlag=0
		;
		s SeqNo=0
		s adm=0 for  s adm=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm)) q:adm=""  d
		.s mas=0 for  s mas=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas)) q:mas=""  d
		.. s s1=^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas)
		.. ;q:s1="" //有可能主子医嘱类型不同
		.. ;q:((Lab'="on")&&($List(s1,47)="L")&&(CheckFlag=1))
		.. ;q:((Exam'="on")&&($List(s1,47)="E")&&(CheckFlag=1))
		.. ;q:((Cure'="on")&&($List(s1,47)="N")&&(CheckFlag=1))
		.. i s1'="" d 
		.. .s SeqNo=SeqNo+1
		.. .s $List(s1,24)=SeqNo
		.. .s Data=s1
		.. .d OutputRow
		.. s SubSeqCount=0
		.. s sub=0  for  s sub=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas,"sub",sub)) q:sub=""  d
		.. . s s2=^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas,"sub",sub)
		.. . i s1="" d
		.. . . s SeqNo= SeqNo+1
		.. . . s $List(s2,24)=SeqNo
		.. . . s Data=s2
		.. . . d OutputRow
		.. . e  d
		.. . . s SubSeqCount=SubSeqCount+1
		.. . . s SubSeqNo=SeqNo_"."_SubSeqCount
		.. . . s $List(s2,24)=SubSeqNo
		.. . . s Data=s2
		.. . . d OutputRow
	 K ^CacheTemp("DHCAdmOrdItem",$j,"adm")
	 Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
	 
OutputRow
	;set Data=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderLinkto,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	set (OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,OrderFreqTimeDoseQtyStr,OrderFreqDispTimeStr)=""
	Quit
}

ClassMethod FindAdmOrderItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmOrderItemsExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderItemList","LookUpPrior","")
ClassMethod LookUpPriorExecute(ByRef qHandle As %Binary, EpisodeID As %String, PriorCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	If (EpisodeID'="") Set EpisodeType=$p(^PAADM(EpisodeID),"^",2)
	else  do
	.Set CTLOCID=%session.Data("LOGON.CTLOCID")
	.Set EpisodeType=..GetPATType(CTLOCID)
	//
	s rowid=0 f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
	.s code=$p($g(^OECPR(rowid)),"^",1)
	.s priority=$p($g(^OECPR(rowid)),"^",3)
	.;为0就不显示?因为有些医嘱类型有些医院用不上
	.Q:priority=0
	.Q:((EpisodeType="O")||(EpisodeType="E"))&&((code="OMST")||(code="S")||(code="OUT")||(code="STAT")||(code="PRN")||(code="ONE"))
	.s desc=$p($g(^OECPR(rowid)),"^",2)
	.Q:(PriorCode'="")&&(code'[$zcvt(PriorCode,"U"))&&(desc'[PriorCode)
	.s Priority=$p($g(^OECPR(rowid)),"^",3)
	.i Priority="" s Priority=1
	.Do OutputRow1
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK

OutputRow1
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpPriorExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		Kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CalFreqTimeDoseQtyStr(ByRef OrderFreqTimeDoseQtyStr As %String) As %String
{
	s OrderFreqTimeDoseQtyStr=$replace(OrderFreqTimeDoseQtyStr,"||","_")
	s OrderFreqTimeDoseQtyStr=$replace(OrderFreqTimeDoseQtyStr,"!",$C(2))
	Q 0
}

ClassMethod CalFreqWeekStr(OrderFreqRowid As %String, OrderFreqWeekStr As %String, ByRef CalOrderFreqDispTimeStr As %String, ByRef CalOrderFreqWeekStr As %String) As %String
{
	Q:(OrderFreqWeekStr="")||(OrderFreqRowid="") ""
	s CalOrderFreqDispTimeStr="",CalOrderFreqWeekStr=""
	//示例串 4|5
	s WeekFlag=$P(^PHCFR(OrderFreqRowid),"^",9)
	if (WeekFlag="Y")&&(OrderFreqWeekStr'="") {
		s OrderFreqTimeList=""
		s childsub=0
		for {
			s childsub=$O(^PHCFR(OrderFreqRowid,"DT",childsub))
			q:(childsub="")
			s time=$p(^PHCFR(OrderFreqRowid,"DT",childsub),"^",1)
			if (OrderFreqTimeList=""){
				s OrderFreqTimeList=..%ZT(time)
			}else{
				s OrderFreqTimeList=OrderFreqTimeList_","_..%ZT(time)
			}
		}
		for i=1:1:$l(OrderFreqWeekStr,"|") {
			for j=1:1:$l(OrderFreqTimeList,",") {
				s CalOrderFreqWeekStr=CalOrderFreqWeekStr_$p(OrderFreqWeekStr,"|",i)
				s OneFreqWeekStr=$p(OrderFreqTimeList,",",j)_"@"_$p(OrderFreqWeekStr,"|",i)
				if (CalOrderFreqDispTimeStr=""){
					s CalOrderFreqDispTimeStr=OneFreqWeekStr
				}else{
					s CalOrderFreqDispTimeStr=CalOrderFreqDispTimeStr_"~"_OneFreqWeekStr
				}
			}
		}
		//s OrderFreqWeekStr=CalOrderFreqDispTimeStr
		//s OrderFreq=OrderFreq_"-"_CalOrderFreqWeekStr
	}
	Q 0
}

}
