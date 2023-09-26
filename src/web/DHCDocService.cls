/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 医生站对外接口服务类       
/// Others:
Class web.DHCDocService Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 得到与本次就诊的特病类别代码
/// Table;        DHC_DiagnosCat,PA_Adm,MR_Diagnos
/// Input:        EpiosodeID:就诊指针
/// Return:       以字符"^"分隔的特病类别代码信息串 
/// Others:
ClassMethod GetEPDiagnosCat(EpisodeID As %String, SpecDCType As %String) As %String
{
	s MrAdmRowid=$P(^PAADM(EpisodeID),"^",61)
	s InsurType=$P(^PAADM(EpisodeID,1),"^",7)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ret=""
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MrAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s DiagnosRowid=obj.Data("MRDIAICDCodeDR")
	.Q:DiagnosRowid=""
	.s DiagnosCatRowid="" for  s DiagnosCatRowid=$O(^DHCDiagnosCatI("0","Diagose",DiagnosRowid,DiagnosCatRowid))  Q:DiagnosCatRowid=""  d
	..s DCBillType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",3)
	..s DCAdmType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",2)
	..s DCType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",5)
	..;特殊病类型,就诊类型,费别
	..Q:(DCType'=SpecDCType)!(DCAdmType'=AdmType)!(DCBillType'=InsurType)
	..s DCCode=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",6)
	..i ret="" s ret=DCCode
	..e  s ret=ret_"^"_DCCode
	Q ret
}

ClassMethod GetIPBKPatInfoByPatientID(PatientID As %String) As %String
{
	s IPBookID=""
	Q:PatientID="" ""
	s IPBookID=$o(^DHCDocIPBK(0,"PatientID",PatientID,0),-1)
	s ret="-1"
	Q:IPBookID="" "-1"
	Q:'$d(^DHCDocIPBK(IPBookID)) "-1"
	s str=$g(^DHCDocIPBK(IPBookID))
	s CtlocID=$p(str,"^",13) 	;科室ID
	s WardID=$p(str,"^",11) 	;病区ID
	s BedID=$p(str,"^",12) 		;床位ID
	s DocID=$p(str,"^",7) 		;医生ID
	s DiagnoseID=$p(str,"^",14) ;诊断ID
	s TemplateItemCode="IPDeposit" ;取预交金金额约定代码
	s IPDeposit=""
	s ret=CtlocID_"^"_WardID_"^"_BedID_"^"_DocID_"^"_IPDeposit
	Q:'$d(^DHCDocIPBKTI(0,"ItemCode",TemplateItemCode)) "-1"
	s ItemRowID=""
	s ItemID=$o(^DHCDocIPBKTI(0,"ItemCode",TemplateItemCode,ItemRowID))
	Q:'$d(^DHCDocIPBKD(0,"BookItem",IPBookID,ItemID)) "-1"
	s DetailID=""
	s DetailID=$o(^DHCDocIPBKD(0,"BookItem",IPBookID,ItemID,DetailID))
	i DetailID'="" {
		s IPDeposit=$p($g(^DHCDocIPBKD(DetailID)),"^",3)
	}
	s ret=IPBookID_"^"_CtlocID_"^"_WardID_"^"_BedID_"^"_DocID_"^"_IPDeposit_"^"_DiagnoseID
	Q ret
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.01
/// Description:: 得到卡号根据登记号和卡类型
/// Table;        DHC_CardRef
/// Input:        CardTypeRowid:卡类型rowid,PatientNO:登记号,PatientID:病人rowid,EpisodeID:就诊rowid
/// Return:       卡号||""
/// Others:
/// Debug:		w ##class(web.DHCDocService).GetCardNo(1,"0000000001")
ClassMethod GetCardNo(CardTypeRowid As %String, PatientNO As %String = "", PatientID As %String = "", EpisodeID As %String = "") As %String
{
	n (CardTypeRowid,PatientNO,PatientID,EpisodeID)
		
	s myCardNo=##class(web.DHCDocCommon).GetCardNo(CardTypeRowid,PatientNO,PatientID,EpisodeID)
	
	Q myCardNo
}

/// Creator:      郭荣勇
/// CreatDate:    2010.10.26
/// Description:: 医嘱信息查询接口(提供给电子病历组临床信息查询系统)
/// Table;        OE_OrdItem
/// Input:        UniqueFlag:查询唯一标识 ConditionsStr:条件表达式 ItemResultStr:结果条件串
/// Return:       记录数量
/// Others:
/// debug:		  w ##class(web.DHCDocService).GetOrdItemInfo("OrderInfo","{FromDate:2010-12-07^ToDate:2010-12-07}AND{OrdID:1566||1^Exist:1}","1566||1")
ClassMethod GetOrdItemInfo(UniqueFlag As %String, ConditionsStr As %String, ItemResultStr As %String) As %String
{
	n (UniqueFlag,ConditionsStr,ItemResultStr)
	s myCount=0
	s PatientNo=0
	for {
		s PatientNo=$O(^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo))
		Q:PatientNo=""
		s EpisodeID=0
		for {
			s EpisodeID=$O(^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID))
			Q:EpisodeID=""
			s count=..GetOrdItemByEpisodeID(UniqueFlag,EpisodeID,ConditionsStr,ItemResultStr)
			s myCount=myCount+count
		}
	}
	
	
	Q myCount
}

ClassMethod GetOrdItemByEpisodeID(UniqueFlag As %String, EpisodeID As %String, ConditionsStr As %String, ItemResultStr As %String) As %String
{
	n (UniqueFlag,EpisodeID,ConditionsStr,ItemResultStr)
	KILL ^TMPConditions($J)
	;^CacheTemp("IntegratedQuery",UniqueFlag)
	;1 解析条件表达式到global
	s myCount=0
	s ItemResultStr="^"_ItemResultStr_"^"
	s ConLen=$l(ConditionsStr,"}AND{")
	for i=1:1:ConLen {
		s ConANDTemp=$p(ConditionsStr,"}AND{",i)
		if i=1 {
			s ConANDTemp=$p(ConANDTemp,"{",2)
		}
		if i=ConLen {
			s ConANDTemp=$p(ConANDTemp,"}",1)
		}
		s ConORTempLen=$L(ConANDTemp,"}OR{")
		if ConORTempLen>1 {
			for j=1:1:ConORTempLen {
				s ConORTemp=$p(ConANDTemp,"}OR{",j)
				if ConORTemp="" continue
				s FirstCon=$p(ConORTemp,"^",1)
				s SecCon=$p(ConORTemp,"^",2)
	            s FirstConDesc=$p(FirstCon,":",1)	;条件类型
	            s FirstConValue=$p(FirstCon,":",2)	;条件值
	            s SecConDesc=$p(SecCon,":",1)		;条件结果类型
	            s SecConValue=$p(SecCon,":",2)	;条件结果值
	            ;S ^TMPConditions("OR","条件结果类型","条件类型","条件值")= 条件结果值
	            s ^TMPConditions($J,"OR",SecConDesc,FirstConDesc,FirstConValue)= SecConValue
			}
		}else{
			s FirstCon=$p(ConANDTemp,"^",1)
			s SecCon=$p(ConANDTemp,"^",2)
            s FirstConDesc=$p(FirstCon,":",1)	;条件类型
            s FirstConValue=$p(FirstCon,":",2)	;条件值
            s SecConDesc=$p(SecCon,":",1)		;条件结果类型
            s SecConValue=$p(SecCon,":",2)	;条件结果值
            ;S ^TMPConditions("AND","条件结果类型","条件类型","条件值")= 条件结果值
			s ^TMPConditions($J,"AND",SecConDesc,FirstConDesc,FirstConValue)= SecConValue
		}
	}
	;2 条件判断
	s EndDate=..%SysDate()
	s StartDate=$O(^TMPConditions($J,"AND","ToDate","FromDate",0))
	if StartDate'="" s EndDate=$g(^TMPConditions($J,"AND","ToDate","FromDate",StartDate))
	if $l(StartDate,"-")=3 s StartDate=$zdh(StartDate,3)
	if $l(EndDate,"-")=3 s EndDate=$zdh(EndDate,3)
	if StartDate="" s StartDate=..%SysDate()
	if EndDate="" s EndDate=..%SysDate()
	Q:StartDate="" myCount
	;S ^TMPConditions($J,"AND|OR","Exist","OrdID",OrdIDValue)= ExistValue
	;S ^TMPConditions($J,"AND|OR","Exist","Pharm", PharmValue)= ExistValue
	;S ^TMPConditions($J,"AND|OR","Exist","SubType", SubTypeValue)= ExistValue
	;S ^TMPConditions($J,"AND|OR","Freq","OrdID", OrdIDValue)= FreqValue
	;S ^TMPConditions($J,"AND|OR","Usage","OrdID", OrdIDValue)= UsageValue
	;S ^TMPConditions($J,"AND|OR","Dosage","OrdID", OrdIDValue)= DosageValue
	;S ^TMPConditions($J,"AND|OR","ToDate","FromDate",FromDateValue)=ToDateValue

	
	b ;3 查询
	s OrderRowid=$O(^OEORD(0,"Adm",EpisodeID,0))
	Q:OrderRowid="" myCount
	
	s ChildSub=0,CondFlag=0,findflag=0
	for {
		s ChildSub=$O(^OEORD(OrderRowid,"I",ChildSub))
		Q:ChildSub=""
		s OEItemID=OrderRowid_"||"_ChildSub
		s ordstr1=$g(^OEORD(OrderRowid,"I",ChildSub,1))
		s ordstr2=$g(^OEORD(OrderRowid,"I",ChildSub,2))
		s ordstr3=$g(^OEORD(OrderRowid,"I",ChildSub,3))
		s ordstr5=$g(^OEORD(OrderRowid,"I",ChildSub,5))
		s ordstr7=$g(^OEORD(OrderRowid,"I",ChildSub,7))
		s ordstr9=$g(^OEORD(OrderRowid,"I",ChildSub,9))
		s ordstr11=$g(^OEORD(OrderRowid,"I",ChildSub,11))
		s PapmiRowid=$p(^PAADM(EpisodeID),"^",1)
		s PatientNo=$P(^PAPER(PapmiRowid,"PAT",1),"^",1)
		s ArcimId=$p(ordstr1,"^",2)
		if ArcimId="" continue
		s ArcimCode="",ArcimDesc=""
		s ArcimCode=$p($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",1),ArcimDesc=$p($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",2)
		s OrdCreateDate=$p(ordstr3,"^",7)  ;,OrdCreateDate=$zd(OrdCreateDate,3)
		s OrdCreateTime=$p(ordstr1,"^",17) ;,OrdCreateTime=..%ZT(OrdCreateTime,2)
		s OrdStartDate=$p(ordstr1,"^",9)   ;,OrdStartDate=$zd(OrdStartDate,3)
		s OrdStartTime=$p(ordstr1,"^",10)  ;,OrdStartTime=..%ZT(OrdStartTime,2)
		if (StartDate>OrdStartDate)||((EndDate'="")&&(EndDate<OrdCreateDate)) continue

		s DoseUnit=""
		s PrescNo=$p(ordstr1,"^",14)
		s DoseQty=$p(ordstr2,"^",1),DoseUnitDR=$p(ordstr2,"^",3)
		s OrdcatDR="",SubsortDesc="",OrdcatDesc=""
		s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",10)
		s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),"^",8),SubsortDesc=$p(^ARC("IC",SubsortDR),"^",2)
		s:OrdcatDR'="" OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
		s OrdCatID=OrdcatDR,ItemCatID=OrdcatDR
		s OrderSeqNo=$p(ordstr3,"^",4)
		s:DoseUnitDR'="" DoseUnit=$p(^CT("UOM",DoseUnitDR),"^",2)
		s PriorityDR=$p(ordstr1,"^",8)
		s:$g(PriorityDR)="" Priority="",PriorityCode=""
		s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),"^",2),PriorityCode=$p(^OECPR(PriorityDR),"^",1)
		s PHFreqDr=$p(ordstr2,"^",4)
		s:($g(PHFreqDr)'="")&&($d(^PHCFR(PHFreqDr))) PHFreq=$p(^PHCFR(PHFreqDr),"^",1)
		s:$g(PHFreq)="" PHFreq=""
		s InstrDr=$p(ordstr2,"^",7)
		s:$g(InstrDr)'="" Instr=$p(^PHCIN(InstrDr),"^",2)
		s:$g(Instr)="" Instr=""
		s OrdStatusDR=$p(ordstr1,"^",13)
		s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
		s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
		s Dura=$p(ordstr2,"^",6)
		s:$g(Dura)'="" Dura=$p(^PHCDU(Dura),"^",3)
		s:$g(Dura)="" Dura=""
		s doctor=$p(ordstr1,"^",11)
		s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),"^",2)
		s:$g(doctor)="" doctor=""
		s QtyPackUOM=$p(ordstr9,"^",4)
		
		s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEItemID)
		s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
		s HaveDispensing=0,dstatus=""
		s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
		.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		.s HaveDispensing=1
		i HaveDispensing=1 d
		.i dstatus="C" s dstatus="已发"
		.i dstatus="TC" s dstatus="未发"
		.i dstatus=""  s dstatus="未打包"
		;条码号,标本
		s LabEpisodeNo=$p(ordstr3,"^",20) ;
		s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
		;停医嘱日期,停医嘱时间
		s OrdXDate=$p(ordstr3,"^",34)
		if OrdXDate'="" s OrdXDate=$zd(OrdXDate,3)
		s OrdXTime=$p(ordstr2,"^",15)
		if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
		;皮试,皮试备注,备注,
		s OrdSkinTest=$p(ordstr5,"^",2)
		s OrdAction=$p(ordstr11,"^",21)
		i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
		s OrdDepProcNotes=$g(^OEORD(OrderRowid,"I",ChildSub,"DEP",1))
		s OrdBilled=$p(ordstr3,"^",5)
		s abnorm=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",3)
		s OrdSkinTestResult=""
		i OrdSkinTest="Y" d
		.i abnorm="Y" s OrdSkinTestResult="阳性"
		.e  s OrdSkinTestResult="阴性"
		s UseAddDesc=""
		s UseAddDR=$p(ordstr7,"^",1)
		if UseAddDR'="" s UseAddDesc=$p(^SSU("SSUSR",UseAddDR),"^",2)
		s Dosage=$p(ordstr2,"^",1)
		s PHSubCat="",PHSubCatDesc=""
		s DrugFormID=$p($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
		if DrugFormID'="" s PHSubCat=$p(^PHCD(+DrugFormID,1),"^",3)
		if PHSubCat'="" s PHSubCatDesc=$P($g(^PHCC(+PHSubCat,"SC",+$p(PHSubCat,"||",2))),"^",2)
		s CondFlag=..GetConditionsRet($J,"Exist","OrdID",ArcimId,1)
		if CondFlag=1 s findflag=1
		;if CondFlag=0 quit
		s CondFlag=..GetConditionsRet($J,"Exist","Pharm",PHSubCat,1)		
		if CondFlag=1 s findflag=1
		;if CondFlag=0 quit
		s CondFlag=..GetConditionsRet($J,"Exist","SubType",SubsortDR,1)		
		if CondFlag=1 s findflag=1
		;if CondFlag=0 quit
		s CondFlag=..GetConditionsRet($J,"Freq","OrdID",ArcimId,PHFreqDr)		
		if CondFlag=1 s findflag=1
		;if CondFlag=0 quit
		s CondFlag=..GetConditionsRet($J,"Usage","OrdID",ArcimId,InstrDr)
		if CondFlag=1 s findflag=1
		;if CondFlag=0 quit
		s CondFlag=..GetConditionsRet($J,"Dosage","OrdID",ArcimId,Dosage)		
		if CondFlag=1 s findflag=1
		;if CondFlag=0 quit
		b 
			
	}
	if findflag'=1 quit myCount
	b ;Conditions Check finsh
	;符合条件表达式里的就诊重新遍历就诊下的医嘱得到输出结果的医嘱
		
	s OrderRowid=$O(^OEORD(0,"Adm",EpisodeID,0))
	Q:OrderRowid="" myCount
	s ChildSub=0
	for {
		s ChildSub=$O(^OEORD(OrderRowid,"I",ChildSub))
		Q:ChildSub=""
		s OEItemID=OrderRowid_"||"_ChildSub
		s ordstr1=$g(^OEORD(OrderRowid,"I",ChildSub,1))
		s ordstr2=$g(^OEORD(OrderRowid,"I",ChildSub,2))
		s ordstr3=$g(^OEORD(OrderRowid,"I",ChildSub,3))
		s ordstr5=$g(^OEORD(OrderRowid,"I",ChildSub,5))
		s ordstr7=$g(^OEORD(OrderRowid,"I",ChildSub,7))
		s ordstr9=$g(^OEORD(OrderRowid,"I",ChildSub,9))
		s ordstr11=$g(^OEORD(OrderRowid,"I",ChildSub,11))
		s PapmiRowid=$p(^PAADM(EpisodeID),"^",1)
		s PatientNo=$P(^PAPER(PapmiRowid,"PAT",1),"^",1)
		s ArcimId=$p(ordstr1,"^",2)
		if ArcimId="" continue
		if ItemResultStr'[("^"_ArcimId_"^") continue
		s ArcimCode="",ArcimDesc=""
		s ArcimCode=$p($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",1),ArcimDesc=$p($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",2)
		s OrdCreateDate=$p(ordstr3,"^",7)  ;,OrdCreateDate=$zd(OrdCreateDate,3)
		s OrdCreateTime=$p(ordstr1,"^",17) ;,OrdCreateTime=..%ZT(OrdCreateTime,2)
		s OrdStartDate=$p(ordstr1,"^",9)   ;,OrdStartDate=$zd(OrdStartDate,3)
		s OrdStartTime=$p(ordstr1,"^",10)  ;,OrdStartTime=..%ZT(OrdStartTime,2)
		if (StartDate>OrdStartDate)||((EndDate'="")&&(EndDate<OrdCreateDate)) continue

		s DoseUnit=""
		s PrescNo=$p(ordstr1,"^",14)
		s DoseQty=$p(ordstr2,"^",1),DoseUnitDR=$p(ordstr2,"^",3)
		s OrdcatDR="",SubsortDesc="",OrdcatDesc=""
		s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",10)
		s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),"^",8),SubsortDesc=$p(^ARC("IC",SubsortDR),"^",2)
		s:OrdcatDR'="" OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
		s OrdCatID=OrdcatDR,ItemCatID=OrdcatDR
		s OrderSeqNo=$p(ordstr3,"^",4)
		s:DoseUnitDR'="" DoseUnit=$p(^CT("UOM",DoseUnitDR),"^",2)
		s PriorityDR=$p(ordstr1,"^",8)
		s:$g(PriorityDR)="" Priority="",PriorityCode=""
		s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),"^",2),PriorityCode=$p(^OECPR(PriorityDR),"^",1)
		s PHFreqDr=$p(ordstr2,"^",4)
		s:($g(PHFreqDr)'="")&&($d(^PHCFR(PHFreqDr))) PHFreq=$p(^PHCFR(PHFreqDr),"^",1)
		s:$g(PHFreq)="" PHFreq=""
		s InstrDr=$p(ordstr2,"^",7)
		s:$g(InstrDr)'="" Instr=$p(^PHCIN(InstrDr),"^",2)
		s:$g(Instr)="" Instr=""
		s OrdStatusDR=$p(ordstr1,"^",13)
		s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
		s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
		s Dura=$p(ordstr2,"^",6)
		s:$g(Dura)'="" Dura=$p(^PHCDU(Dura),"^",3)
		s:$g(Dura)="" Dura=""
		s doctor=$p(ordstr1,"^",11)
		s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),"^",2)
		s:$g(doctor)="" doctor=""
		s QtyPackUOM=$p(ordstr9,"^",4)
		
		s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEItemID)
		s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
		s HaveDispensing=0,dstatus=""
		s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
		.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		.s HaveDispensing=1
		i HaveDispensing=1 d
		.i dstatus="C" s dstatus="已发"
		.i dstatus="TC" s dstatus="未发"
		.i dstatus=""  s dstatus="未打包"
		;条码号,标本
		s LabEpisodeNo=$p(ordstr3,"^",20) ;
		s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
		;停医嘱日期,停医嘱时间
		s OrdXDate=$p(ordstr3,"^",34)
		if OrdXDate'="" s OrdXDate=$zd(OrdXDate,3)
		s OrdXTime=$p(ordstr2,"^",15)
		if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
		;皮试,皮试备注,备注,
		s OrdSkinTest=$p(ordstr5,"^",2)
		s OrdAction=$p(ordstr11,"^",21)
		i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
		s OrdDepProcNotes=$g(^OEORD(OrderRowid,"I",ChildSub,"DEP",1))
		s OrdBilled=$p(ordstr3,"^",5)
		s abnorm=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",3)
		s OrdSkinTestResult=""
		i OrdSkinTest="Y" d
		.i abnorm="Y" s OrdSkinTestResult="阳性"
		.e  s OrdSkinTestResult="阴性"
		s UseAddDesc=""
		s UseAddDR=$p(ordstr7,"^",1)
		if UseAddDR'="" s UseAddDesc=$p(^SSU("SSUSR",UseAddDR),"^",2)
		s Dosage=$p(ordstr2,"^",1)
		s PHSubCat="",PHSubCatDesc=""
		s DrugFormID=$p($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
		if DrugFormID'="" s PHSubCat=$p(^PHCD(+DrugFormID,1),"^",3)
		if PHSubCat'="" s PHSubCatDesc=$P($g(^PHCC(+PHSubCat,"SC",+$p(PHSubCat,"||",2))),"^",2)
		s ExcInfo=..GetXOrdExecInfo(OEItemID)
		s ExcCtpcp=""
		s ExcCtpcpID=$p(ExcInfo,"^",1)
		if ExcCtpcpID'="" s ExcCtpcp=$p($g(^CTPCP(ExcCtpcpID,1)),"^",2)
		s ExcDate=$p(ExcInfo,"^",2)
		s ExcTime=$p(ExcInfo,"^",3)
		
		
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"OrdTime")=OrdCreateDate_" "_OrdCreateTime
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"ExcTime")=ExcDate_" "_ExcTime
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"OrdUser")=UseAddDR_" "_UseAddDesc
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"ExcUser")=ExcCtpcpID_" "_ExcCtpcp
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"Dosage")=DoseQty
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"Unit")=DoseUnitDR_" "_DoseUnit
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"Freq")=PHFreq_" "_PHFreq
		;s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"Period")=OrdCreateDate_" "_OrdCreateTime
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"Usage")=InstrDr_" "_Instr
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"Pharm")=PHSubCat_" "_PHSubCatDesc
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"MainType")=OrdcatDR_" "_OrdcatDesc
		s ^CacheTemp("IntegratedQuery",UniqueFlag,PatientNo,EpisodeID,"Ord",OrdCatID,ItemCatID,ArcimDesc,OEItemID,"SubType")=SubsortDR_" "_SubsortDesc
		
		s myCount=myCount+1
	}
	
	Q myCount
}

ClassMethod GetConditionsRet(Job, SecConDesc, FirstConDesc, FirstConValue, CompareValue) As %String
{
	n (Job,SecConDesc,FirstConDesc,FirstConValue,CompareValue)
	;S ^TMPConditions($J,"AND|OR","Exist","OrdID",OrdIDValue)= ExistValue
	;S ^TMPConditions($J,"AND|OR","Exist","Pharm", PharmValue)= ExistValue
	;S ^TMPConditions($J,"AND|OR","Exist","SubType", SubTypeValue)= ExistValue
	;S ^TMPConditions($J,"AND|OR","Freq","OrdID", OrdIDValue)= FreqValue
	;S ^TMPConditions($J,"AND|OR","Usage","OrdID", OrdIDValue)= UsageValue
	;S ^TMPConditions($J,"AND|OR","Dosage","OrdID", OrdIDValue)= DosageValue
	;S ^TMPConditions($J,"AND|OR","ToDate","FromDate",FromDateValue)=ToDateValue
	s myrtn=0
	s ConExistFlag=0
	s ConMode=""
	for {
		s ConMode=$o(^TMPConditions(Job,ConMode))
		Q:ConMode=""
		s ItemValue=""
		for {
			s ItemValue=$O(^TMPConditions(Job,ConMode,SecConDesc,FirstConDesc,ItemValue))
			Q:ItemValue=""
			s ItemData=$g(^TMPConditions(Job,ConMode,SecConDesc,FirstConDesc,ItemValue))
			if (ItemData=CompareValue) {
				s myrtn=1
			}
			Q:myrtn=1
		}
		Q:myrtn=1
		
		if $d(^TMPConditions(Job,ConMode,SecConDesc,FirstConDesc)) {
			s ConExistFlag=1
		}
	}
	
	if (ConExistFlag=0)&&(myrtn=0) s myrtn=2
	
	
	Q myrtn
}

ClassMethod GetXOrdExecInfoNew(oeoriId) As %String
{
    n (oeoriId)
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId'="" d
	.s execXUserId=$p(^DHCORDItem(dhcoriId),"^",6),execXDate=$p(^DHCORDItem(dhcoriId),"^",7),execXTime=$p(^DHCORDItem(dhcoriId),"^",8)
	q $g(execXUserId)_"^"_$g(execXDate)_"^"_$g(execXTime)
}

ClassMethod GetXOrdExecInfo(oeoriId) As %String
{
	n (oeoriId)
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	s execCpcpId="",execDate="",execTime=""
	s oeoreSub=""
 	f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(execDate="")  d
	.q:'$d(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))
	.s execDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",19)   		//执行日期
	.s execTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",20)   		//执行日期
	.s execCpcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)      //执行人
	.s statId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)			//执行状态
	
	q $g(execCpcpId)_"^"_$g(execDate)_"^"_$g(execTime)
}

/// Creator:      郭荣勇
/// CreatDate:    2010.11.26
/// Description:: 转科复制转出科医嘱到转入科接口
/// Table;        OE_OrdItem
/// Input:        EpiosodeID:就诊指针 OrdItemStr:医嘱串(格式:"1||1^1||2^1||3^1||4"),User:操作用户Rowid,TargetDep;目标科室,TargetWard:目标病区,TargetDoc:目标医生,IntoTime:转入时间
/// Return:       以字符"^"分隔的信息串(格式:ARCIMRowid_"*"_oeitm_"*"_"V"_"*"_CPWStepItemRowId^ARCIMRowid_"*"_oeitm_"*"_"V"_"*"_CPWStepItemRowId) 
/// Others:		  现在使用医院:徐州, 已经停用
/// 测试:泌尿外科转到急诊ICU,aspl-阿司匹林,操作人:2177-孙延玲,急诊ICU科,急诊ICU病区,医生:刘申修,入科时间
/// w ##class(web.DHCDocService).CopyTransDepOrder(162,"159||6",36,7,38,2,..%SysTime())
ClassMethod CopyTransDepOrder(EpiosodeID, OrdItemStr, User, TargetDep, TargetWard, TargetDoc, IntoTime)
{
	n (EpiosodeID,OrdItemStr,User,TargetDep,TargetWard,TargetDoc,IntoTime)
	
	;1.停转出科室医嘱
	;2.复制转出科室医嘱到转入科室
	
	s myErr=0
	
	s $ZTrap="ERROR^DHCSSERR"
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpiosodeID)
	TS
	if IntoTime[":" s IntoTime=..%ZTH(IntoTime,1)
	
	s OrdListStr=""
	s Len=$l(OrdItemStr,"^")
	for i=1:1:Len {
		s OrdItem=$p(OrdItemStr,"^",i)
		if OrdItem="" continue
		s Ord=+$p(OrdItem,"||",1),Sub=+$p(OrdItem,"||",2)
		s OrderARCIMRowid="", OrderType="", OrderPriorRowid=""
		s OrderStartDate="", OrderStartTime="", OrderPackQty=""
		s OrderPrice="", OrderRecDepRowid="", BillTypeRowid=""
		s OrderDrugFormRowid="", OrderDepProcNotes="", OrderDoseQty=""
		s OrderDoseUOMRowid="", OrderQtySum="", OrderFreqRowid=""
		s OrderDurRowid="", OrderInstrRowid="", PHPrescType=""
		s OrderMasterSeqNo="", OrderSeqNo="", OrderSkinTest=""
		s OrderPhSpecInstr="", OrderCoverMainIns="", OrderActionRowid=""
		s OrderARCOSRowid="",OrderEndDate="",OrderEndTime=""
		s OrderLabSpecRowid="",OrderMultiDate="",OrderNotifyClinician=""
		s OrderDIACatRowId="",OrderInsurCatRowId="",OrderFirstDayTimes=""
		s OrderInsurSignSymptomCode="",OrderStageCode="",OrderSpeedFlowRate=""
		s AnaesthesiaID="",OrderLabEpisodeNo="",VerifiedOrderMasterRowid=""
		s OrderNutritionDrugFlag="",OrderMaterialBarCode="",OrderCPWStepItemRowId=""
		s OrderInsurApproveType="",OrderNeedPIVAFlag=""
		
 &SQL(SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,
        OEORI_SttDat,OEORI_SttTim,OEORI_SttDat,
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
        OEORI_ARCOS_DR,OEORI_BBExtCode,OEORI_OEORI_DR,OEORI_PhSpecInstr,OEORI_Price,
        OEORI_CoverMainIns,OEORI_Action_DR,OEORI_Action_DR->ACT_Desc,OEORI_NotifyClinician,
        OEORI_DRGOrder,OEORI_BBExtCode,OEORI_SpeedFlowRate,OEORI_LabEpisodeNo,OEORI_Qty,OEORI_Anaest_DR
 INTO :OrderItemRowid,:OrderARCIMRowid,:OrderName,:OrderSttDate,:OrderSttTime,:StartDate,
        :OrderDoseQty,:OrderDoseUOMRowid,:OrderDoseUOM,:OrderPackQty,
        :OrderPriorRowid,:OrderPrior,:OrderStatusRowid,:OrderStatus,:OrderFreqRowid,:OrderFreq,
        :OrderInstrRowid,:OrderInstr,:OrderDurRowid,:OrderDur,
        :OrderRecDepRowid,:OrderRecDep,:OrderUserDepRowid,:OrderUserDep,
        :OrderDocRowid,:OrderDoc,:OrderUserAddRowid,:OrderUserAdd,
        :OrderBilled,:OrderSkinTest,:OrderBillTypeRowid,:OrderType,
        :OrderSeqNo,:OrderMasterSeqNo,:OrderLinkTo,:OrderPrescNo,:OrderLabEpisodeNo,
        :OrderARCOSRowid,:OrderBillTypeRowid,:LinkOrderItem,:OrderPhSpecInstr,:OrderPrice,
        :OrderCoverMainIns,:OrderActionRowid,:OrderAction,:OrderNotifyClinician,
        :OrderDIACatRowId,:InsType,:OrderSpeedFlowRate,:OrderLabEpisodeNo,:OrderFirstDayTimes,:AnaesthesiaID
 From SQLUser.OE_OrdItem WHERE OEORI_Rowid=:OrdItem)
		
		if OrderType'="R" continue
		s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrdItem)
		s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderPackUOMRowid)
		s OrderMasterSeqNo=""
		s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
		s OrderDepProcNotes=$g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DEP",1))
		s subcat=$p($g(^ARCIM(+OrderARCIMRowid,1,1)),"^",10)
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(subcat,AdmHospitalId,OrderARCIMRowid)
		if LinkOrderItem'="" s OrderMasterSeqNo=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),3)),"^",4)
		s OrderEndDate=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),9)),"^",9)
		s OrderEndTime=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),9)),"^",10)
		s OrderInsurCatRowId=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",3)
		s OrderStageCode=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",8)
		s OrderNutritionDrugFlag=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",12)
		s OrderNeedPIVAFlag=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",16)
		;s OrderInsurSignSymptomCode=$$GetOrderItemDSYM(oeitm,InsurSignSymptomCode)
		s OrderMaterialBarCode=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",14)
		if OrderSttTime="" s OrderSttTime=..%SysTime()
		if (OrderSttTime'>IntoTime) s OrderSttTime=IntoTime+1
		if (OrderSttDate'="")&(OrderSttDate'["/") s OrderSttDate=$zd(OrderSttDate,4)
		if (OrderSttTime'="")&(OrderSttTime'[":") s OrderSttTime=..%ZT(OrderSttTime,1)
		if (OrderEndDate'="")&(OrderEndDate'["/") s OrderEndDate=$zd(OrderEndDate,4)
		if (OrderEndTime'="")&(OrderEndTime'[":") s OrderEndTime=..%ZT(OrderEndTime,1)
		s OrderFirstDayTimes=""
		
		
		;OrderQtySum,OrderMasterSeqNo,OrderSeqNo,OrderEndDate,OrderEndTime,OrderLabSpecRowid,OrderMultiDate
		;OrderInsurSignSymptomCode,OrderStageCode
		;VerifiedOrderMasterRowid,OrderMaterialBarCode,OrderCPWStepItemRowId
		;OrderInsurApproveType
		s ItemStr=OrderARCIMRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderSttDate_"^"_OrderSttTime
		s ItemStr=ItemStr_"^"_OrderPackQty_"^"_OrderPrice_"^"_OrderRecDepRowid_"^"_OrderBillTypeRowid
		s ItemStr=ItemStr_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid
		s ItemStr=ItemStr_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid
		s ItemStr=ItemStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest
		s ItemStr=ItemStr_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns_"^"_OrderActionRowid_"^"_OrderARCOSRowid
		s ItemStr=ItemStr_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid_"^"_OrderMultiDate
		s ItemStr=ItemStr_"^"_OrderNotifyClinician_"^"_OrderDIACatRowId_"^"_OrderInsurCatRowId_"^"_OrderFirstDayTimes
		s ItemStr=ItemStr_"^"_OrderInsurSignSymptomCode_"^"_OrderStageCode_"^"_OrderSpeedFlowRate_"^"_AnaesthesiaID
		s ItemStr=ItemStr_"^"_OrderLabEpisodeNo_"^"_VerifiedOrderMasterRowid_"^"_OrderNutritionDrugFlag_"^"_OrderMaterialBarCode
		s ItemStr=ItemStr_"^"_"^"_OrderCPWStepItemRowId_"^"_OrderInsurApproveType_"^"_OrderNeedPIVAFlag
        
        if OrdListStr="" s OrdListStr=ItemStr
        else  s OrdListStr=OrdListStr_$C(1)_ItemStr
		/*//完全复制---start	
		s ItmObj=##class(User.OEOrdItem).%OpenId(OrdItem)
		if $IsObject(ItmObj) {
			
			s CloneObj=ItmObj.%ConstructClone(0)
			s ParRefID=ItmObj.OEORIOEORDParRefGetObjectId()
			d ItemObj.%Close()
			
			s NewObj=##class(User.OEOrdItem).%New(ParRefID)
			
			d CloneObj.OEORIOEORDParRefSetObjectId(ParRefID)
			s CloneObj.OEORIChildsub=NewObj.OEORIChildsub
			s StatusRowId=$O(^OEC("OSTAT",0,"Code","V",0))
			d CloneObj.%Save()
			
			
		}
		//完全复制---end*/
	}
	b ;SaveOrderItems   start
	s myErr=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpiosodeID,OrdListStr,User,TargetDep,TargetDoc)
	b ;SaveOrderItems finsh
	if myErr="100" {
		TRO
		Q myErr_"^"_"医嘱复制保存时失败."
	}
	s RetSaveOrdStr=myErr
	
	b ;stop start
	s myErr=0
	s Len=$l(OrdItemStr,"^")
	for i=1:1:Len {
		s OrdItem=$p(OrdItemStr,"^",i)
		if OrdItem="" continue
		s Ord=+$p(OrdItem,"||",1),Sub=+$p(OrdItem,"||",2)
		s ArcimRowid=$P($g(^OEORD(Ord,"I",Sub,1)),"^",2)
		s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1)),"^",2)
		s myErr=##class(web.DHCOEOrdItem).Stop(OrdItem,User)
		s Ord=+$p(OrdItem,"||",1),Sub=+$p(OrdItem,"||",2)
		if myErr=0 {
			s OrdXTime=$P($g(^OEORD(Ord,"I",Sub,2)),"^",15)
			if (IntoTime'="")&(OrdXTime'<IntoTime) {
				s OrdXTime=IntoTime-1
				&SQL(Update SQLUser.OE_OrdItem set OEORI_Xtime=:CurrTime where OEORI_rowid=:OrdItem)
				s myErr=SQLCODE
			}
		}
		if myErr {
			s ErrDesc=ArcimDesc_" ,停止失败."
			break
		}
	}
	b ;StopOrder finsh
	if myErr'=0 {
		TRO
		Q myErr_"^"_ErrDesc
	}
	
	TC
	
	
	Q myErr_"!"_RetSaveOrdStr
}

/// Creator:      郭荣勇
/// CreatDate:    2010.10.08
/// Description:  查询住院用药记录
/// Table:        ARC_ItmMast,ARC_ALIAS
/// Debug:		  d ##class(%ResultSet).RunQuery("web.DHCDocService","IPUseDrugRecord",197)
/// Other:       住院电子病历上传接口
ClassMethod IPUseDrugRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPUseDrugRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod IPUseDrugRecordExecute(ByRef qHandle As %Binary, EpisodeID As %Library.String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	 s OrderRowid=$O(^OEORD(0,"Adm",EpisodeID,0))
	 if OrderRowid="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s num=0
	 s ChildSub=0
	 for {
		s ChildSub=$O(^OEORD(OrderRowid,"I",ChildSub))
		Q:ChildSub=""
		s OEORIDR=OrderRowid_"||"_ChildSub
		s ordstr1=$g(^OEORD(OrderRowid,"I",ChildSub,1))
		s ordstr2=$g(^OEORD(OrderRowid,"I",ChildSub,2))
		s ordstr3=$g(^OEORD(OrderRowid,"I",ChildSub,3))
		s ordstr5=$g(^OEORD(OrderRowid,"I",ChildSub,5))
		s ordstr7=$g(^OEORD(OrderRowid,"I",ChildSub,7))
		s ordstr9=$g(^OEORD(OrderRowid,"I",ChildSub,9))
		s ordstr11=$g(^OEORD(OrderRowid,"I",ChildSub,11))
		s oeordr=$p(OEORIDR,"||",1)
		s oeorsub=$p(OEORIDR,"||",2)
		s admdr=$p(^OEORD(oeordr),"^",1)
		s papmidr=$p(^PAADM(admdr),"^",1)
		s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(admdr)
		s ErrMsg=""
		s Medicareno=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admdr,AdmType,.ErrMsg) ;病历号
		S OPNo=$p(^PAPER(papmidr,"PAT",1),"^",2) 	;OP （登记号）	//
		S IPNo=$p(^PAPER(papmidr,"PAT",1),"^",1) 	;IP （登记号）	//
		S PrescNo=$p(^OEORD(oeordr,"I",oeorsub,1),"^",14)	//处方号
		s ArcimId=$p(ordstr1,"^",2)
		if ArcimId="" continue
		s ArcimCode="",ArcimDesc=""
		s ArcimCode=$p($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",1),ArcimDesc=$p($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",2)
		S serialno=""
		s inci=##class(web.DHCDocOrderEntry).GetINCI($p(ArcimId,"||"))
		if inci="" continue
		S inccode=$p(^INCI(inci,1),"^",1)	;药物代码
		s incdesc=$p(^INCI(inci,1),"^",2)	;药物名称 
		s phcformStr=$$GetForm(inci)	;药物剂型
		s phcformcode=$p(phcformStr,"^",1)
		s phcformdesc=$p(phcformStr,"^",2)
		S Manf=$$GetManfNameByInci(inci)	//厂家
		S Spec=$$GetSpec(inci)		//规格
		s phfreqdr=$p(^OEORD(oeordr,"I",oeorsub,2),"^",4)
		s phfreqfac=$p(^PHCFR(phfreqdr),"^",2)	;药物使用-频率 
		S phcduration=""
		s phcdudr=$p(^OEORD(oeordr,"I",oeorsub,2),"^",6)  ;用药疗程
		I phcdudr'="" D
		.I $D(^PHCDU(phcdudr)) D
		..s phcduration=$p(^PHCDU(phcdudr),"^",3)	;用药天数
		s oeunit=$p(^OEORD(oeordr,"I",oeorsub,2),"^",3)
		S oeunitdesc=""
		I oeunit'="" D
		.s oeunitdesc=$p($G(^CT("UOM",oeunit)),"^",2)	;药物使用-剂量单位
		s dosqty=$p(^OEORD(oeordr,"I",oeorsub,2),"^",1)	;药物使用-次剂量
		s dostotal=phfreqfac*dosqty*phcduration	;药物使用-总剂量 
		s instrdr=$p(^OEORD(oeordr,"I",oeorsub,2),"^",7)
		s instrdesc=$p(^PHCIN(instrdr),"^",2)	;药物使用-途径
		S USAGE=""								//药物用法
		s sttdat=$p(^OEORD(oeordr,"I",oeorsub,1),"^",9)
		s stttim=$p(^OEORD(oeordr,"I",oeorsub,1),"^",10)
		s sttdt=$zd(sttdat,3)
		s xdat=$p(^OEORD(oeordr,"I",oeorsub,3),"^",34)
		s xtim=$p(^OEORD(oeordr,"I",oeorsub,2),"^",15)
		s xdt="1840-12-31"
		s:(xdat'="1840-12-31")&(xdat'="") xdt=$zd(xdat,3)  //	;用药停止日期时间 
		s arcimdr=$p(^INCI(inci,1),"^",3)
		s arcsub=$p(arcimdr,"||",1)
		s arcver=$p(arcimdr,"||",2)
		s arcitmcatdr=$p(^ARCIM(arcsub,arcver,1),"^",10)
		S ArcItmCatCode=$p($G(^ARC("IC",arcitmcatdr)),"^",1)	;药物类型代码 （医嘱大类）
		s arcitmcatdesc=$p($G(^ARC("IC",arcitmcatdr)),"^",2)	;药物类型 （医嘱大类） 
		s insertdt=$zd(+$h,3)	;添加时间
		s Data=$lb(OEORIDR,IPNo,Medicareno,"",arcitmcatdesc,incdesc,inccode,phcformcode,phcformdesc,phcduration,phfreqfac,oeunitdesc,dosqty,dostotal,instrdesc,sttdt,xdt,"",ArcimDesc,Manf)
		s num=num+1
		d OutputRow2
	 }
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
GetInciByOrditm(orditmRowid)
   n (orditmRowid) 
   s ord=+orditmRowid
   s chl=$p(orditmRowid,"||",2)
   s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                 
   s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
   q inci
GetForm(inci)
   ;剂型名称
   n (inci)
   s phcformcode="",phcformdesc=""
   &sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_PHCF_DR->phcf_Code,inci_arcim_dr->arcim_phcdf_dr->phcdf_PHCF_DR->phcf_desc 
   into :phcformcode,:phcformdesc
   from SQLUser.INC_Itm where inci_rowid=:inci)
   q $g(phcformcode)_"^"_$g(phcform)
GetSpec(inci="")
	;根据库存项代码取得规格 -07-11-02
	;inci : rowid of INC_Itm
	n (inci)
	q:$g(inci)="" ""
	s spec=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) q:add="" ""
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	q spec
GetManfNameByInci(itmid)
    ;得到厂家
    n (itmid)
    &sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_phmnf_dr->phmnf_name
    into :manf from SQLUser.INC_Itm where inci_RowID = :itmid)
    q $g(manf)
}

ClassMethod IPUseDrugRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPUseDrugRecordExecute ]
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

/// Creator:      郭荣勇
/// CreatDate:    2010.10.20
/// Description:  查询病人诊断信息
/// Table:        MR_Diagnos
/// Debug:		  d ##class(%ResultSet).RunQuery("web.DHCDocService","DiagnosisRecord",197)
/// Other:       住院电子病历上传接口
ClassMethod DiagnosisRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosisRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DiagnosisRecordExecute(ByRef qHandle As %Binary, EpisodeID As %Library.String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	 if EpisodeID="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	 if MRAdmRowid="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	 s AdmNo=$p($g(^PAADM(EpisodeID)),"^",81)
	 s PapmiRowid=$p(^PAADM(EpisodeID),"^",1)
	 s OPNo="",IPNo=""
	 if PapmiRowid'="" {
		 S OPNo=$p(^PAPER(PapmiRowid,"PAT",1),"^",2)
		 S IPNo=$p(^PAPER(PapmiRowid,"PAT",1),"^",1)
	 }
	 if AdmType="I" s PutAdmType=1
	 else  s PutAdmType=2
	 
	 s MRDiagnosStr="",myRtnDiagnosStr="",FindFlag=0
	 s num=0
	 s ChildSub=0
	 for {
		s ChildSub=$O(^MR(MRAdmRowid,"DIA",ChildSub))
		Q:ChildSub=""
		s MRRowid=MRAdmRowid_"||"_ChildSub
		s ICDCodeDR=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)
		s MRDIADate=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",7)
		s MRDIATime=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",8)
		;s MRDIAActive=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)
		s MRCIDDesc="",ICD9CMCode=""
		if ICDCodeDR'="" {
			s MRCIDDesc=$p($g(^MRC("ID",ICDCodeDR)),"^",2)
			s ICD9CMCode=$p($g(^MRC("ID",ICDCodeDR)),"^",4)
			s BillFlag3=$p($g(^MRC("ID",ICDCodeDR)),"^",15)
		}
		
		s MRCDiagTypCode="",MRCDiagTypDesc=""
		s TYPChildSub=0
		for {
			s TYPChildSub=$O(^MR(MRRowid,"DIA",ChildSub,"TYP",TYPChildSub))
			Q:TYPChildSub=""
			s MRCDiagTypID=$p($g(^MR(MRRowid,"DIA",ChildSub,"TYP",TYPChildSub)),"^",1)
			if MRCDiagTypID'="" {
				s MRCDiagTypCode=$p($g(^MRC("DTYP",MRCDiagTypID)),"^",1)
				s MRCDiagTypDesc=$p($g(^MRC("DTYP",MRCDiagTypID)),"^",2)
			}
			
			if (AdmType="I")||(AdmType="E") {
				if (MRCDiagTypCode="M")||(MRCDiagTypCode="DIS") {
					s FindFlag=1
					do OutputRow1
				}
			}else{
			}
		}
		
		if MRDiagnosStr="" s MRDiagnosStr=MRRowid_$C(1)_MRCDiagTypDesc_$C(1)_MRDIADate_$C(1)_MRCIDDesc_$C(1)_ICD9CMCode
		else  s MRDiagnosStr=MRDiagnosStr_"^"_MRRowid_$C(1)_MRCDiagTypDesc_$C(1)_MRDIADate_$C(1)_MRCIDDesc_$C(1)_ICD9CMCode
	 }
	 
	 if FindFlag=0 {
		 for i=1:1:$l(MRDiagnosStr,"^") {
			 s DiagStr=$p(MRDiagnosStr,"^",i)
			 if (i=1){
			 	s MRCDiagTypCode="M"
			 	s MRCDiagTypDesc="主诊断"
			 }else{
				 s MRCDiagTypCode="PRE"
				 S MRCDiagTypDesc="Pre Admission"
			 }
			 s MRRowid=$p(DiagStr,$c(1),1)
			 ;s MRCDiagTypDesc=$p(DiagStr,$c(1),2)
			 s MRDIADate=$p(DiagStr,$c(1),3)
			 s MRCIDDesc=$p(DiagStr,$c(1),4)
			 s ICD9CMCode=$p(DiagStr,$c(1),5)
			 do OutputRow1
		 }
	 }
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    s num=num+1
    s Data=$lb(MRRowid,IPNo,PutAdmType,"衢州市人民医院",MRDIADate,"","","",MRCIDDesc,ICD9CMCode,"","","")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod DiagnosisRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosisRecordExecute ]
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

Query DiagnosisRecord(EpisodeID As %Library.String) As %Query(ROWSPEC = "OEORIDR,IPNo,Medicareno,BZZYLBDM,arcitmcatdesc,incdesc,inccode,phcformcode,phcformdesc,phcduration,phfreqfac,oeunitdesc,dosqty,dostotal,instrdesc,sttdt,xdt,BZYWFZY,ArcimDesc,Manf")
{
}

Query IPUseDrugRecord(EpisodeID As %Library.String) As %Query(ROWSPEC = "OEORIDR,IPNo,Medicareno,BZZYLBDM,arcitmcatdesc,incdesc,inccode,phcformcode,phcformdesc,phcduration,phfreqfac,oeunitdesc,dosqty,dostotal,instrdesc,sttdt,xdt,BZYWFZY,ArcimDesc,Manf")
{
}

/// Creator:       郭荣勇
/// CreatDate:     2011.10.27
/// Description::  下医嘱接口接口(待扩展)
/// Input:		   Adm:就诊Rowid,OrdItemStr:需插入医嘱串,User:录入用户,Loc:开医嘱科室,DocUserId:下医嘱医生用户ID
/// OrdItemStr     =OrdItem_$c(1)_OrdItem1_$c(1)_OrdItem2
/// OrdItem:       ArcimRowid(医嘱项Rowid)^PackQty(医嘱数量)^RecLoc(接收科室)^OEPrice(医嘱价格)^specimen(标本/)^AdmReason(费别/)^SttDat(医嘱开始日期/)^OSRID(医嘱套Rowid)  
/// Output: 	   0^oeitmrowid_"*"_"V"_$c(2)_oeitmrowid_"*"_"V" ^分割第一位为0为正确,其他 错误
/// debug:		   w ##class(web.DHCDocService).InsertOrderItem(Adm,OrdItemStr,User,Loc,DocUserId)
/// Modifier:		徐鹏
/// ModifyDate:		2012.04.24
/// Modify:			调用统一插入医嘱的程序,该程序包括了生成执行记录、发药记录
ClassMethod InsertOrderItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, DocUserId As %String) As %String
{
	s ^DHCXPTest("DHCDocInterface","InsertOrderItem")=Adm_","_OrdItemStr_","_User_","_Loc_","_DocUserId
	Quit:$g(OrdItemStr)="" 0
	Quit:$g(Adm)="" 0
	Set admloc=$p(^PAADM(Adm),"^",4)
	Set admtype=$p($g(^PAADM(Adm)),"^",2)
	Set admreason=$p($g(^PAADM(Adm,1)),"^",7)
	Set Doc=$p($g(^SSU("SSUSR",DocUserId)),"^",9)
	if Doc="" Set Doc=$p($g(^SSU("SSUSR",DocUserId)),"^",14)
	s OnceFreqRowid=$o(^PHCFR(0,"Code","ONCE",0))
	;
	Set ord=$o(^OEORD(0,"Adm",Adm,""))
	If ord="" Do
	.Kill PLIST
	.Set PLIST(2)=Adm
	.Set err=$$insert^MVBOEORD()
	.If err=0 Set ord=PLIST(1)
	Quit:ord="" 0
	;
	;s $ZT="ERROR"
	Set Err=$$LOCK^SSLOCK("OE_Order",ord,User,$g(Machine))
	;
	;insert into OE_OrdEnt  zhaocz
	k PLIST
	;s PLIST(3)=""
	;s err=$$insert^MVBOEENT(ord)
	Set RowidStr=""
	Set OrdItemCount=$L(OrdItemStr,$c(1))
	For i=1:1:OrdItemCount	Do
	.Set OrdItem=$p(OrdItemStr,$c(1),i)
	.Quit:OrdItem=""
	.Set arcim=$p(OrdItem,"^",1)
	.Quit:arcim=""
	.q:'$d(^ARCIM(+arcim,$P(arcim,"||",2),1))
	.Set recloc=$p(OrdItem,"^",3)
	.Quit:recloc=""
	.Set qty=$p(OrdItem,"^",2)
	.if +qty=0 Set qty=1
	.Set oeprice=$p(OrdItem,"^",4)
	.Set specimen=$p(OrdItem,"^",5)
	.Set ordcat=$p(^ARCIM(+arcim,1,1),"^",10)
	.Set ordtype=$p(^ARC("IC",ordcat),"^",7)	;DRUG|R,LABTRAK|L,PRICE|P,NORMAL|N
	.Set arcimdesc=$p(^ARCIM(+arcim,1,1),"^",2)
	.Set ordstatus=$o(^OEC("OSTAT",0,"Code","V",""))
	.If ordstatus="" Set ordstatus=$o(^OEC("OSTAT",0))
	.Set priority=$o(^OECPR(0,"Code","NORM",""))
	.If priority="" Set priority=$o(^OECPR(0))
	.Set doctor=""
	.If $g(DocUserId)'="" Set doctor=$p(^SSU("SSUSR",DocUserId),"^",9)
	.if doctor="" Set doctor=$p(^SSU("SSUSR",User),"^",14)
	.Set AdmReason=$p(OrdItem,"^",6)
	.if AdmReason="" s AdmReason=admreason
	.Set SttDate=$p(OrdItem,"^",7)
	.if $l(SttDate,"/")=3 Set SttDate=$zdh(SttDate,4)
	.if $l(SttDate,"-")=3 Set SttDate=$zdh(SttDate,3)
	.if SttDate="" Set SttDate=..%SysDate()
	.Set ARCOSRowid=$p(OrdItem,"^",8)
	.Set OrdNotes=$p(OrdItem,"^",9)
	.
	.;
	.KILL PLIST
	.Do SetCommonPLIST
	.If ordtype="R" Do SetDrugPLIST
	.If ordtype="P" Do SetPricePLIST
	.i $g(PLIST(25))="" Set PLIST(25)=OnceFreqRowid
	.//Set err=$$insert^MVBOEIT0(ord,"Y")
	.//Set oeitm=%ROWID
	.s RtnStr=##class(appcom.OEOrdItem).Insert(ord,"",.PLIST)
	.s err=$P(RtnStr,"^",1)
	.s oeitm=$P(RtnStr,"^",2)
	.Quit:err
	.;
	.Set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11),"^",18)=AdmReason
	.i RowidStr="" s RowidStr=oeitm_"*"_"V"
	.e  s RowidStr=RowidStr_$c(2)_oeitm_"*"_"V"
	.;
	.Quit:$g(LABDATA)="" 
	.If ordtype="L" Set specimen=$$GetSpecimen(arcim,LABDATA) 
	.If (ordtype="L")&($g(specimen)'="") s err=$$SetLabSpecimen^DHCOEOrdItem(oeitm,specimen,Container,Convolumn)
	.Quit:err                                       //
	;
	if ('$$practice^DHCDocOrderCommonNew(Doc)) {
		d ##class(DHCDoc.Interface.Inside.Service).GenPresno(Adm,User,"") 
	}
	Set err=$$LOCKCLR^SSLOCK("OE_Order",ord)
	Quit 0_"^"_RowidStr
SetCommonPLIST
	s PLIST(3)=""  ;entrid				;OEORI_OrdEnt_DR
	Set PLIST(4)=arcim
	Set PLIST(6)=admloc		 	 ;OEORI_OrdDept_DR
	Set PLIST(10)=ordstatus		 ;OEORI_ItemStat_DR
	Set PLIST(14)=doctor		 ;OEORI_Doctor_DR
	Set PLIST(17)=SttDate			 ;SttDate
	Set PLIST(18)=..%SysTime()	 ;SttTime
	Set PLIST(23)=priority		 ;OEC_Priority
	Set PLIST(29)=qty			 ;PhyQtyOrd			
	Set Price=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim,+$H,"","","",oeprice,"","")
	Set PLIST(46)=$p(Price,"^",1)
	Set PLIST(53)=OrdNotes
	Set PLIST(55)="Y"			 ;CoverMainIns
	Set PLIST(56)="N"			 ;Portable Equviment
	Set PLIST(57)="N"			 ;SkinTest
	Set PLIST(75)=recloc
	Set SeqNo=$o(^OEORDi(0,"StDtSeqNo",ord,+$H,""),-1)
	Set SeqNo=+SeqNo+1
	Set PLIST(77)=SeqNo
	Set PLIST(86)=ARCOSRowid
	Set PLIST(120)=$g(User)	 	 ;UserAdd
	Set PLIST(121)=$g(Loc) 	 	 ;User Dept
	Set PLIST(141)=$g(User)	     ;User Update
	Set PLIST(161)=admloc		 ;OEORI_AdmLoc_Dr
	
	Quit
	;
SetDrugPLIST
	;for Outpatient ,Default value used
	Set drg=$p(^ARCIM(+arcim,1,1),"^",12)
	Quit:drg=""
	Set defaultfreq=$p(^PHCD(+drg,"DF",$p(drg,"||",2),1),"^",4)
	If defaultfreq="" Set defaultfreq=$o(^PHCFR(0))
	Set defaultinstr=$p(^PHCD(+drg,"DF",$p(drg,"||",2),1),"^",5)
	If defaultinstr=""	Set defaultinstr=$o(^PHCIN(0))
	Set defaultdura=$p(^PHCD(+drg,"DF",$p(drg,"||",2),1),"^",8)
	If defaultdura="" Set defaultdura=$o(^PHCDU(0))
	Set defaultuom=$p(^PHCD(+drg,"DF",$p(drg,"||",2),2),"^",4)		;Base UOM
	;
	Set PLIST(25)=defaultfreq			;PHC_Freq		bid
	Set PLIST(27)=defaultinstr			;PHC_Instruc	
	Set PLIST(28)=defaultuom			;CT_UOM	OEORI_Unit_DR mg
	;Set PLIST(29)=qty*$$Conv(arcim)		;				
	Set PLIST(35)=defaultdura			;PHC_Duration
	Set PLIST(85)=1						;Dosage Qty
	Set PLIST(154)=qty					;PackingUom Qty
	Quit
SetPricePLIST
	Set PLIST(45)=arcimdesc				;OEORI_BillDesc
	Set PLIST(79)=oeprice				;OEORI_Price
	Set PLIST(46)=oeprice*qty			;OEORI_UnitCost
	Quit
SetLabSpecimen(Par,specimen,Container,Convolumn)
	n (Par,specimen,Container,Convolumn)
	Quit:$g(Par)="" 0
	Quit:$g(specimen)="" 0
	KILL PLIST
	Set PLIST(3)=specimen
	Set PLIST(14)=Container
	Set PLIST(15)=Convolumn	
	;s ^TmpLab11=Container_":::"_Convolumn
	s err=$$insert(Par)
	s ordspcrid=PLIST(1)
	s OERid=$p(ordspcrid,"||")
	s OESubrid=$p(ordspcrid,"||",2)
	s OESpecRid=$p(ordspcrid,"||",3)
	s $p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",11)=Container
	s $p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",12)=Convolumn	
	Quit 0	;
	;
GetTestCode(arcim)
	;
	Quit:$g(arcim)="" ""
	Quit:'$d(^ARCIM(+arcim,1,"EXT")) ""
	Set Ext=$o(^ARCIM(+arcim,1,"EXT",0))
	Quit:$g(Ext)="" ""
	Set ExtCode=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",4)
	Quit ExtCode
	;
GetTestSetSpecimen(TestCode,LabData)
	Quit:$g(TestCode)="" ""
	Set SourNS=$ZNSPACE
	zn LabData
	;^TTAB("TS",{CT_TestSet.CTTS_Code},1,{CTTSS_Specimen_DR})
	Set FirstSpecimen=$o(^TTAB("TS",TestCode,1,""))
	Set Specimendr=""
	s Convolumn=""
	Set Defaultflag="N"
	For  Set Specimendr=$o(^TTAB("TS",TestCode,1,Specimendr)) Q:(Specimendr="")!(Defaultflag="Y")  Do
	.Set Container=$o(^TTAB("TS",TestCode,1,Specimendr,""))
	.i Container="" d
	..Set Specimenflag=$p(^TTAB("TS",TestCode,1,Specimendr),"/",1)
	..If Specimenflag="Y" Set FirstSpecimen=Specimendr,Defaultflag="Y"
	.e  d
	..Set Specimenflag=$g(^TTAB("TS",TestCode,1,Specimendr,Container))
	..If Specimenflag="1" Set FirstSpecimen=Specimendr,Defaultflag="Y"
	..s Convolumn=$p($g(^TTAB("TS",TestCode,"SC",Container,Specimendr)),"\",1)
	zn SourNS
	;Container,Convolumn
	Quit FirstSpecimen
	;
GetSpecimen(arcim,LabData)
	Set TestCode=$$GetTestCode(arcim)
	Quit $$GetTestSetSpecimen(TestCode,LabData)

insert(par)        ;
 s par=$g(par)
 k PLIST(1),PLIST(2) s PLIST(0)=par,PLIST(3)=$tr(PLIST(3),"|")
 &sql( INSERT INTO SQLUser.OE_OrdSpecimen
         VALUES :PLIST())
 ;
 ; Now retrieve everything back to return to client
 ; %ROWID is returned from INSERT
 i 'SQLCODE q $$select(%ROWID)
 ;
 q SQLCODE
	
select(RowID)   ;
 k PLIST
 &sql( SELECT *
         INTO :PLIST()
         FROM SQLUser.OE_OrdSpecimen
         WHERE SPEC_RowId=:RowID)
 ;i 'SQLCODE,$g(curspar)="ITS",$g(PLIST(3))'="" s PLIST(1)=PLIST(3),PLIST(3)=PLIST(3)_"|||"_$g(^TMP("MVB1",$j,1,PLIST(3)))
 s PLIST=$o(PLIST(""),-1)
 q SQLCODE
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.27
/// Description:: 下医嘱接口接口
/// Table;        OE_Order,OE_OrdItem OE_OrdExec,DHC_OEDispensing
/// Input:        UniqueFlag:查询唯一标识 ConditionsStr:条件表达式 ItemResultStr:结果条件串
/// Return:       记录数量
/// Others:
/// debug:		  w ##class(web.DHCDocService).InsertOrderItem(XMLStr)
/// XMLStr: <root>
/// 				<EpisodeID>1</EpisodeID><UserID>1</UserID><LocID>1</LocID><DocID>1</DocID>
///         	<ListData>
/// 					<Item>
/// 						<PropertyName>1||1<PropertyName>
/// 					</Item>
/// 					<Item>
/// 						<PropertyName>1||2<PropertyName>
/// 					</Item>
/// 					<Item>
/// 						<PropertyName>1||3<PropertyName>
/// 					</Item>
/// 				</ListData>
/// 			</root>
ClassMethod InsertOEItem(XMLStr As %GlobalBinaryStream) As %String
{
}

/// Creator:      郭荣勇
/// CreatDate:    2010.12.27
/// Description:: 停医嘱接口
/// Table;        OE_Order,OE_OrdItem OE_OrdExec,DHC_OEDispensing,ARC_ItmMast
/// Input:        NeedStopItemStr:结果条件串,节点为OE_OrdItemRowid
/// Return:       记录数量
/// Others:		  NeedStopItemStr:"1||1^1||2^1||3"
/// debug:		  w ##class(web.DHCDocService).StopOrderItem(NeedStopItemStr)
ClassMethod StopOrderItem(NeedStopItemStr As %String, UserRowId As %String) As %String
{
	n (NeedStopItemStr,UserRowId)
	s $ZT="ERROR^DHCSSERR"
	;s CacheVersion=$SYSTEM.OBJ.Version()
	
	s EpisodeID=""
	for i=1:1:$l(NeedStopItemStr,"^") {
		s OrdItmRowId=$P(NeedStopItemStr,"^",i)
		if OrdItmRowId="" continue
		s EpisodeID=$p($g(^OEORD(+OrdItmRowId)),"^",1)
		
		s CLSObj=##class(%Dictionary.ClassDefinition).%OpenId("web.DHCOEOrdItem")
		if $IsObject(CLSObj) {
			if $d(^oddDEF(CLSObj.%Id(),"m","Stop")) {
				;BS新版本
				s StopRtn=##class(web.DHCOEOrdItem).Stop(OrdItmRowId,UserRowId)
				i +StopRtn=0 {
					s StopRtn=##class(web.UDHCStopOrderLook).Collect(OrdItmRowId,UserRowId)
				}
			}else{
				;BS老版本
				/*
				Set Config=##Class(websys.Configuration).%OpenId(1)
				Set MEDDATA=Config.DataNamespace
				Set LABDATA=Config.LabDataNamespace
				Set CurrentNS=$ZNSPACE
				ZN MEDDATA		
				s StopRtn=$$discon^SMLPrescLook(OrdItmRowId,UserRowId,UserPin)
				ZN CurrentNS
				*/
				
			}
		}else{
			;CS版本
			/*
			Set Config=##Class(websys.Configuration).%OpenId(1)
			Set MEDDATA=Config.DataNamespace
			Set LABDATA=Config.LabDataNamespace
			Set CurrentNS=$ZNSPACE
			ZN MEDDATA		
			s StopRtn=$$discon^SMLPrescLook(OrdItmRowId,UserRowId,UserPin)
			ZN CurrentNS
			*/
		}
		Q:StopRtn
	}
	s StopRtn=##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserRowId,"")
	
	Q StopRtn
}

ClassMethod GetDirectInfo(EpisodeID As %String, CMFlag As %String, Currentflag As %String, User As %String, PrintFlag As %String) As %String
{
   ;w ##class(web.DHCDocService).GetDirectInfo(1092,"N","",3879,"")
   s ^TMP("GetDirectInfo")=EpisodeID_","_CMFlag_","_Currentflag_","_User_","_PrintFlag
   k ^CacheTemp("DHCDirectOrdItem",$j)
   q:EpisodeID="" ""
   s SaveOrdItemStr=""
   i CMFlag="Y" s SaveOrdItemStr=$G(^TMP("SaveOrdItemStr",EpisodeID,User,"CM"))
   e  s SaveOrdItemStr=$G(^TMP("SaveOrdItemStr",EpisodeID,User,"C"))
   q:(Currentflag="1")&&(SaveOrdItemStr="") ""
   i SaveOrdItemStr'=""  s SaveOrdItemStr="^"_SaveOrdItemStr_"^"
   s PAPMI=$p($g(^PAADM(EpisodeID)),"^",1)
   s AdmLocDesc=""
   s AdmDep=$p($g(^PAADM(EpisodeID)),"^",4)
   i AdmDep'=""  s AdmLocDesc=$p($g(^CTLOC(AdmDep)),"^",2)
   i (AdmLocDesc'="")&&($l(AdmLocDesc,"-")>1)  s AdmLocDesc=$p(AdmLocDesc,"-",2)
   s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
   i AdmDate'="" s AdmDate=$zd(AdmDate,3)
   s AdmInfo=AdmLocDesc_"^"_AdmDate
   s retPatInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PAPMI)
   Q:retPatInfo="" ""
   s CMSubCategory=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
   if CMSubCategory'="" s CMSubCategory="^"_CMSubCategory_"^"
   ;登记号^卡号^姓名^年龄^性别^病人类型
   s PatInfo=$p(retPatInfo,"^",2)_"^"_$p(retPatInfo,"^",30)_"^"_$p(retPatInfo,"^",3)_"^"_$p(retPatInfo,"^",5)_"^"_$p(retPatInfo,"^",4)_"^"_$p(retPatInfo,"^",7)
  
    s ord="" s ord=$o(^OEORD(0,"Adm",EpisodeID,ord)) q:ord="" -1	
    s chl=0 f  s chl=$o(^OEORD(ord,"I",chl)) q:chl=""  d          ;
	.q:'$d(^OEORD(ord,"I",chl))
	.q:(Currentflag="1")&&(SaveOrdItemStr'[("^"_ord_"||"_chl_"^"))
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.s doctor=$p(^OEORD(ord,"I",chl,1),"^",11)
	.s DocID=$p($g(^SSU("SSUSR",User)),"^",14)
	.q:(DocID'="")&&(DocID'=doctor)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),"^",2)
	.s:$g(doctor)="" doctor=""
	.s OrdStatus=$p($g(^OEORD(ord,"I",chl,1)),"^",13)
	.s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
	.s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
	.s Billed=$p($g(^OEORD(ord,"I",chl,3)),"^",5)
	.Q:Billed="P"      ;已经收费则退出
	.Q:(OrdStatus="I") ;未激活
	.Q:(OrdStatus="E") ;执行
	.Q:(OrdStatus="U") ;未核实
	.Q:(OrdStatus="D")
	.s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	.s SubCategory=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1)),"^",10)
	.s OrdcatDesc="",OrdcatDR=""
	.s:SubCategory'="" OrdcatDR=$p(^ARC("IC",SubCategory),"^",8)
	.s:OrdcatDR'="" OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
	.q:(OrdcatDesc["材料")||(OrdcatDesc["诊疗费")
	.Q:(CMSubCategory'[("^"_SubCategory_"^"))&&(CMFlag="Y")
	.Q:(CMSubCategory[("^"_SubCategory_"^"))&&(CMFlag="N")
	.s ArcimType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
	.q:ArcimType'="Other"
	.s OrdInfo=..GetOrdByOrdId(ord_"||"_chl)
	.s OrdRecDep=$p(OrdInfo,"^",6)
	.i OrdRecDep="" s OrdRecDep=0
	.s ^CacheTemp("DHCDirectOrdItem",$j,OrdRecDep,ord_"||"_chl)=OrdInfo
	s NeedSureOrderStr="",NeedChargeOrderStr=""
    s rtype=""  for  s rtype=$O(^CacheTemp("DHCDirectOrdItem",$j,rtype)) q:rtype=""  d
    .s orditem=""  for  s orditem=$O(^CacheTemp("DHCDirectOrdItem",$j,rtype,orditem)) q:orditem=""  d
    ..s s1=^CacheTemp("DHCDirectOrdItem",$j,rtype,orditem)
    ..i $p(s1,"^",4)="Y"  d
	...i NeedSureOrderStr="" s NeedSureOrderStr=s1
	...e  s NeedSureOrderStr=NeedSureOrderStr_$c(1)_s1
	..e  d
	...i NeedChargeOrderStr="" s NeedChargeOrderStr=s1
	...e  s NeedChargeOrderStr=NeedChargeOrderStr_$c(1)_s1
	b ;
	q:(NeedSureOrderStr="")&&(NeedChargeOrderStr="") ""
	s AllOrderStr=PatInfo_$c(4)_AdmInfo_$c(4)_$zd(+$h,3)_"  "_..%ZT(..%SysTime(),1)_"^"_doctor_$c(4)_NeedChargeOrderStr_$c(4)_NeedSureOrderStr
	
   i Currentflag="1"  d
   .i CMFlag="Y"  d
   ..k ^TMP("SaveOrdItemStr",EpisodeID,User,"CM")
   .e  k ^TMP("SaveOrdItemStr",EpisodeID,User,"C")
   q AllOrderStr
}

ClassMethod GetDirectInfoOld(EpisodeID As %String, CMFlag As %String, Currentflag As %String, User As %String, PrintFlag As %String) As %String
{
   ;w ##class(web.DHCDocService).GetDirectInfo(412,"Y","","6","")
   s ^TMP("GetDirectInfo")=EpisodeID_","_CMFlag_","_Currentflag_","_User_","_PrintFlag
   k ^CacheTemp("DHCDirectOrdItem",$j)
   q:EpisodeID="" ""
   s SaveOrdItemStr="",AdmDepDesc="",AdmDate=""
   i CMFlag="Y" s SaveOrdItemStr=$G(^TMP("SaveOrdItemStr",EpisodeID,User,"CM"))
   e  s SaveOrdItemStr=$G(^TMP("SaveOrdItemStr",EpisodeID,User,"C"))
   q:(Currentflag="1")&&(SaveOrdItemStr="") ""
   i SaveOrdItemStr'=""  s SaveOrdItemStr="^"_SaveOrdItemStr_"^"
   s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
   s:AdmDepDr'="" AdmDepDesc=$p($g(^CTLOC(AdmDepDr)),"^",2)
   s:AdmDepDr'="" AdmDate=$p($g(^CTLOC(AdmDepDr)),"^",6)
   i AdmDate'=""  s AdmDate=$zd(AdmDate,3)
   s AdmInfo=AdmDepDesc_"^"_AdmDate
   s PAPMI=$p($g(^PAADM(EpisodeID)),"^",1)
   s retPatInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PAPMI)
   Q:retPatInfo="" ""
   s CMSubCategory=..%GetConfig("CNMedItemCat")
   if CMSubCategory'="" s CMSubCategory="^"_CMSubCategory_"^"
   ;登记号^卡号^姓名^年龄^性别^病人类型
   s PatInfo=$p(retPatInfo,"^",2)_"^"_$p(retPatInfo,"^",30)_"^"_$p(retPatInfo,"^",3)_"^"_$p(retPatInfo,"^",5)_"^"_$p(retPatInfo,"^",4)_"^"_$p(retPatInfo,"^",7)
   s ord="" s ord=$o(^OEORD(0,"Adm",EpisodeID,ord)) q:ord="" -1	
   s chl=0 f  s chl=$o(^OEORD(ord,"I",chl)) q:chl=""  d          ;
	.q:'$d(^OEORD(ord,"I",chl))
	.q:(Currentflag="1")&&(SaveOrdItemStr'[("^"_ord_"||"_chl_"^"))
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.s doctor=$p(^OEORD(ord,"I",chl,1),"^",11)
	.s DocID=$p($g(^SSU("SSUSR",User)),"^",14)
	.q:(DocID'="")&&(DocID'=doctor)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),"^",2)
	.s:$g(doctor)="" doctor=""
	.s OrdStatus=$p($g(^OEORD(ord,"I",chl,1)),"^",13)
	.s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
	.s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
	.Q:(OrdStatus="I") ;未激活
	.Q:(OrdStatus="E") ;执行
	.Q:(OrdStatus="U") ;未核实
	.Q:(OrdStatus="D")
	.s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	.s SubCategory=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1)),"^",10)
	.s OrdcatDesc="",OrdcatDR=""
	.s:SubCategory'="" OrdcatDR=$p(^ARC("IC",SubCategory),"^",8)
	.s:OrdcatDR'="" OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
	.q:(OrdcatDesc["材料")||(OrdcatDesc["诊疗费")
	.Q:(CMSubCategory'[("^"_SubCategory_"^"))&&(CMFlag="Y")
	.Q:(CMSubCategory[("^"_SubCategory_"^"))&&(CMFlag="N")
	.s ArcimType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
	.q:ArcimType'="Other"
	.s ArcTpDr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	.s ArcType=$p(^ARC("IC",ArcTpDr),"^",7)
	.;Q:(ArcType="R")&&(CMFlag'="Y") 
	.s RecDepDR=$p($g(^OEORD(ord,"I",chl,3)),"^",6)  ;接收科室
	.Q:RecDepDR=""
	.s OrdInfo=..GetOrdByOrdId(ord_"||"_chl)         
	.s LinkOrderItem=$p($G(^OEORD(ord,"I",chl,11)),"^",39)
	.i LinkOrderItem="" s ^CacheTemp("DHCDirectOrdItem",$j,RecDepDR,"master",ord_"||"_chl)=OrdInfo
	.e  d
	..if '$D(^CacheTemp("DHCDirectOrdItem",$j,RecDepDR,"master",LinkOrderItem)) d
	...s ^CacheTemp("DHCDirectOrdItem",$j,RecDepDR,"master",LinkOrderItem)=""
	..s ^CacheTemp("DHCDirectOrdItem",$j,RecDepDR,"master",LinkOrderItem,"sub",ord_"||"_chl)=OrdInfo
	s AllOrderStr=""
	s reloc=""  for  s reloc=$O(^CacheTemp("DHCDirectOrdItem",$j,reloc)) q:reloc=""  d
	.;接收科室地址
	.s relocDesc=$p(^CTLOC(reloc),"^",2)
	.i relocDesc["-" s relocDesc=$p(relocDesc,"-",2)
	.s relocAddress=$p($g(^CTLOC(reloc,"ADDR","1")),"^",1)  ;科室的物理地址
	.s reLocSum=0,reLocSumP=0,reLocSumB=0,OrderStr=""
	.s mas=0 for  s mas=$O(^CacheTemp("DHCDirectOrdItem",$j,reloc,"master",mas)) q:mas=""  d
	..s s1=^CacheTemp("DHCDirectOrdItem",$j,reloc,"master",mas)
	..s BillStatus=$p($g(^OEORD(+mas,"I",$p(mas,"||",2),3)),"^",5)  ;记费壮态
	..Q:(PrintFlag="N")&&(BillStatus="P")   //只打印未收费的医嘱
	..i BillStatus="P" s reLocSumP=reLocSumP+$P(s1,"^",5)
	..e  s reLocSumB=reLocSumB+$P(s1,"^",5)
	..s reLocSum=reLocSum+$P(s1,"^",5)
	..s SubOrderStr=""
	..s sub=0  for  s sub=$O(^CacheTemp("DHCDirectOrdItem",$j,reloc,"master",mas,"sub",sub)) q:sub=""  d
	...s s2=^CacheTemp("DHCDirectOrdItem",$j,reloc,"master",mas,"sub",sub)
	...s BillStatus=$p($g(^OEORD(+sub,"I",$p(sub,"||",2),3)),"^",5)  ;记费壮态
	...Q:(PrintFlag="N")&&(BillStatus="P")   //只打印未收费的医嘱
	...i BillStatus="P" s reLocSumP=reLocSumP+$P(s2,"^",5)
	...e  s reLocSumB=reLocSumB+$P(s2,"^",5)
	...s reLocSum=reLocSum+$P(s2,"^",5)
	...i SubOrderStr="" s SubOrderStr="|__"_s2 
	...e  s SubOrderStr=SubOrderStr_$c(3)_"|__"_s2 
	..i '$D(^CacheTemp("DHCDirectOrdItem",$j,reloc,"master",mas,"sub")) d
	...i (s1'="")  d
	....i OrderStr="" s OrderStr=s1
	....e  s OrderStr=OrderStr_$c(3)_s1
	..e  d
	...s GroupOrder=""
	...i s1'=""  s GroupOrder=s1
	...i (SubOrderStr'="")  d
	....i GroupOrder="" s GroupOrder=SubOrderStr   e  s GroupOrder=s1_$c(3)_SubOrderStr
	...i OrderStr="" s OrderStr=GroupOrder
	...e  s OrderStr=OrderStr_$c(3)_GroupOrder
	.s relocOrderStr=""
	.i CMFlag="Y" s OrderStr="中药^^^^^^^"
	.i OrderStr'="" s relocOrderStr=relocDesc_"^"_relocAddress_"^合计:"_$fn(reLocSum,"",2)_"  已收:"_$fn(reLocSumP,"",2)_"  未收:"_$fn(reLocSumB,"",2)_$c(2)_OrderStr
	.q:relocOrderStr=""
	.i AllOrderStr="" s AllOrderStr=relocOrderStr
	.e  s AllOrderStr=AllOrderStr_$c(1)_relocOrderStr
	if AllOrderStr'=""  s AllOrderStr=PatInfo_$c(4)_AdmInfo_$c(4)_$zd(+$h,3)_"  "_..%ZT(..%SysTime(),1)_"^"_doctor_$c(4)_AllOrderStr
	/*
	;取药品处方
	if (CMFlag'="Y")
	{
	Set rset=##class(%ResultSet).%New("web.DHCOEOrdItem:GetPrescriptions")
	do rset.Execute(EpisodeID)
	 While (rset.Next()) 
	{   S Flag="N"
		s PrescNo=rset.Data("PrescNo")
		s PrescWin=..GetPrescWin(PrescNo)
		Set Ret=##class(%ResultSet).%New("web.UDHCPrescript:GetPrescItems")
		do Ret.Execute(EpisodeID,PrescNo)
		s reLocSum=0,reLocSumP=0,reLocSumB=0,OrderStr="",RecDesc="",RecAddress=""
	    While (Ret.Next()&&(Flag'="Y")) 
	    {   
		 	s Rowid=Ret.Data("Rowid")
		 	b ;5
		 	i (Currentflag="1")&&(SaveOrdItemStr'[("^"_Rowid_"^"))  s Flag="Y"
		 	Q:Flag="Y"
		 	s doctor=$p(^OEORD(+Rowid,"I",$P(Rowid,"||",2),1),"^",11)
			s DocID=$p($g(^SSU("SSUSR",User)),"^",14)
			i (DocID'="")&&(DocID'=doctor)  s Flag="Y"
			s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),"^",2)
	        s:$g(doctor)="" doctor=""
			q:Flag="Y"
		 	s RecDep=$p($g(^OEORD(+Rowid,"I",$P(Rowid,"||",2),3)),"^",6)  ;接收科室
		 	s RecDesc=$p(^CTLOC(RecDep),"^",2)
			i RecDesc["-" s RecDesc=$p(RecDesc,"-",2)
			s RecAddress=$p($g(^CTLOC(RecDep,"ADDR","1")),"^",1)  ;科室的物理地址
		 	s OrdInfo=..GetOrdByOrdId(Rowid)
	 		s BillStatus=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),3)),"^",5)  ;记费壮态
	    	Q:(PrintFlag="N")&&(BillStatus="P")   //只打印未收费的医嘱
			q:Flag="Y"
			i BillStatus="P" s reLocSumP=reLocSumP+$P(OrdInfo,"^",5)
			e  s reLocSumB=reLocSumB+$P(OrdInfo,"^",5)
			s reLocSum=reLocSum+$P(OrdInfo,"^",5)
			i OrderStr="" s OrderStr=OrdInfo   
			e  s OrderStr=OrderStr_$c(3)_OrdInfo
			
		i RecDesc'=""  s RecDesc=RecDesc_" "_PrescWin
	 	}
	 	
	  I Flag'="Y" 
	  { 
	    s relocOrderStr=PatInfo_"^"_RecDesc_"^"_RecAddress_"^"_$zd(+$h,3)_"  "_..%ZT(..%SysTime(),1)_"^"_doctor_"^合计:"_$fn(reLocSum,"",2)_"  已收:"_$fn(reLocSumP,"",2)_"  未收:"_$fn(reLocSumB,"",2)_$c(2)_OrderStr
   	    i AllOrderStr="" s AllOrderStr=relocOrderStr
	    e  s AllOrderStr=AllOrderStr_$c(1)_relocOrderStr  
	    s relocOrderStr=""
	  }	  
   	}
	}*/
   i Currentflag="1"  d
   .i CMFlag="Y"  d
   ..k ^TMP("SaveOrdItemStr",EpisodeID,User,"CM")
   .e  k ^TMP("SaveOrdItemStr",EpisodeID,User,"C")
   q AllOrderStr
}

ClassMethod GetPrescWin(presc)
{
	s pha="",retwin="",retwindesc=""
	f  s pha=$o(^DHCPHARW(pha)) q:pha=""  d
	.s phapresc=""
	.s phapresc=$p(^DHCPHARW(pha),"^",16)
	.q:phapresc'=presc
	.s phaphl="",phaphw=""
	.s phaphl=+$p(^DHCPHARW(pha),"^",3)
	.s phaphw=+$p(^DHCPHARW(pha),"^",4)
	.s retwin=phaphw
   i retwin'="" s retwindesc=$p(^DHCPHWIN(retwin),"^",1)
 q retwindesc
}

ClassMethod GetOrdByOrdId(OrdId As %String) As %String
{
	
	;w ##class(web.DHCDocService).GetOrdByOrdId("")
   /// 通过医嘱ID获取医嘱信息
	s del="^",RetStr=""
	q:($g(OrdId)="") RetStr
	s OrdId1=$p(OrdId,"||",1),OrdId2=$p(OrdId,"||",2)
	q:'$d(^OEORD(OrdId1,"I",OrdId2)) RetStr
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime=""
	s ArcimDesc="",OrdLoc="",RecDep="",AdmLoc="",BillStatus="",OeoriDr="",PrescNo=""
	s StopDoctorCode="",AdmLocCode="",DoctorCode="",OrdLocCode=""
	s StopDate="",StopTime="",StopDoctor=""
	s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	s ArcimId=$p(ordstr1,del,2)
	s ArcimId1=$p(ArcimId,"||",1)
	s ArcimId2=$p(ArcimId,"||",2)
	s Spec=""     ;药品规格
	s ArcimDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	s OrderName=ArcimDesc
	s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(ArcimId)
	i GenericName'="" d
	.s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(ArcimId1)
	.i InciRowid'="" s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	.;s OrderName=GenericName
	s ItemCatDR=$p(^ARCIM(ArcimId1,ArcimId2,1),"^",10)
	s ItemCatDesc=""
	i ItemCatDR'="" s ItemCatDesc=$p($g(^ARC("IC",ItemCatDR)),"^",2)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s OrderMsg=$G(^ARCIM(ArcimId1,ArcimId2,"OEM",1))  ;医嘱提示
	s OrderMsg=$TR(OrderMsg,$C(13),"")
	s OrderMsg=$TR(OrderMsg,$C(10),"")
	s SeqNo=$p(ordstr3,del,4)
	S SeqNo=$g(SeqNo)
	s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=..%ZT(OrdStartTime,2)
	s BillStatus=$p(ordstr3,del,5)  ;记费壮态
	i BillStatus="P" s BillStatus="已收费"
	e  s BillStatus="未收费"
	s RecDep=$p(ordstr3,del,6)  ;接收科室
	s:RecDep'="" RecDepCode=$p(^CTLOC(RecDep),del,1),RecDep=$p(^CTLOC(RecDep),del,2)
	s PatNo=$p(ordstr3,del,9) ;病人登记号
	s DoseQty=$p(ordstr2,del,1),DoseUnit=$p(ordstr2,del,3) ;剂量单位
	S:DoseQty="NaN" DoseQty=""
	s:DoseUnit'="" DoseUnit=$p(^CT("UOM",DoseUnit),del,2)
	s PackQty=$p($g(ordstr9),del,4)         ;整包装数量
	s DoseqtySum=$p(ordstr1,del,12)
	i (OrderType'="R") s PackQty=DoseqtySum
	i (OrderType="R")&(PackQty="") s PackQty=1
	s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrdId)
	s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
	s PHFreq=$p(ordstr2,del,4)            
	s:$g(PHFreq)'="" PHFreq=$p(^PHCFR(PHFreq),del,4)  ;频次
	s:$g(PHFreq)="" PHFreq=""
	s Instr=$p(ordstr2,del,7)
	s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,2)     ;用法
	s:$g(Instr)="" Instr=""
	s Dura=$p(ordstr2,del,6)
	s:$g(Dura)'="" Dura=$p(^PHCDU(Dura),del,3)
	s:$g(Dura)="" Dura=""
	s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("", "", ArcimId, +$h, "", "", "", "")
	s Price=$P(retPrice,"^",1)
	s Sum=Price*PackQty
	s doctor=$p(ordstr1,del,11)     ;OEORI_Doctor_DR
	s:$g(doctor)'="" DoctorCode=$p(^CTPCP(doctor,1),"^",1),doctor=$p(^CTPCP(doctor,1),"^",2)
	s:$g(doctor)="" doctor=""
	s AdmLoc=$p(ordstr9,del,2)
	s:AdmLoc'="" AdmLocCode=$p(^CTLOC(AdmLoc),"^",1),AdmLoc=$p(^CTLOC(AdmLoc),"^",2)
	i +DoseQty'=0  s DoseInfo=DoseQty_" "_DoseUnit_"/次"
	e  s DoseInfo=""
	;划价信息;价格为0的在划价中体现
	s AutoInputFee="N",AppLocation=""
	s DIBPRowid=0
	s DIBPRowid=$O(^DHCRBCItemBookProperTypei(ArcimId,DIBPRowid))
	i DIBPRowid'="" {
		s AutoInputFee=$p($g(^DHCRBCItemBookProperty(DIBPRowid)),"^",3)
		s AppLocation=$p($g(^DHCRBCItemBookProperty(DIBPRowid)),"^",7)
	}
	i (Sum=0)&&(ItemCatDesc'="变态反应科治疗") s AutoInputFee="Y"
	s OrdNo=""
	;i ItemCatDR=163  s OrdNo=OrdId
	s UseRemark=""
	i PHFreq'=""  s UseRemark=PHFreq
	i (Instr'="")   d
	.i UseRemark=""  s UseRemark=Instr
	.e  s UseRemark=UseRemark_"__"_Instr
	i (DoseInfo'="")   d
	.i UseRemark=""  s UseRemark=DoseInfo
	.e  s UseRemark=UseRemark_"__"_DoseInfo
	;名称^规格^数量^单价^金额^是否收费^频次  用法  疗程 单次剂量^注意事项
	//S RetStr=OrderName_del_Spec_del_PackQty_del_$fn(Price,"",2)_del_$fn(Sum,"",2)_del_BillStatus_del_UseRemark_"   "_OrdNo_del_OrderMsg //_del_doctor_del_OrdLoc
	S RetStr=OrderName_del_PackQty_del_PackUOMDesc_del_AutoInputFee_del_AppLocation_del_RecDep
	q RetStr
}

/// Creator:      周志强
/// CreatDate:    20011.11.09
/// Description:: 得到用户或者科室自定义常用诊断
/// Table;        User.DHCMRDiagnosMaster
/// Input:        UserID:用户指针,LocationID:科室指针
/// Return:       常用诊断页签指针,描述,顺序号
/// Others:		  d ##class(%ResultSet).RunQuery("web.DHCDocService","FindDiagoseTab","105")
Query FindDiagoseTab(UserID As %String, LocationID As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "RowId:%String,Desc:%String,Sequence:%String")
{
}

ClassMethod FindDiagoseTabExecute(ByRef qHandle As %Binary, UserID As %String, LocationID As %String = "") As %Status
{
	n repid
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s DHCDIAINDEX="" for {
		s DHCDIAINDEX=$O(^DHCDIAMAS("USER",UserID,DHCDIAINDEX))
		Q:DHCDIAINDEX=""
		
		s RowId="" for {
			Set RowId=$O(^DHCDIAMAS("USER",UserID,DHCDIAINDEX,RowId))
			Q:RowId=""
			Set Desc=$P(^DHCDIAMAS(RowId),"^",2)
			Set ^CacheTemp(repid,ind)=$lb(RowId,Desc,DHCDIAINDEX)
			Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindDiagoseTabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HisMRDiagRepExecute ]
{
	n repid
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 k ^CacheTemp(repid)
	}Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDiagoseTabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HisMRDiagRepExecute ]
{
	n repid
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:      周志强
/// CreatDate:    20011.11.09
/// Description:: 得到常用诊断页签下的诊断数据
/// Table;        User.DHCMRDiagnosMaster,User.MRCICDDx,User.DHCMRDiagnosICD
/// Input:        TabRowId:常用诊断页签指针
/// Return:       诊断代码指针,诊断描述,组号,组内序号
/// Others:		  d ##class(%ResultSet).RunQuery("web.DHCDocService","FindDiagoseTabDetail","25")
Query FindDiagoseTabDetail(Param1 As %String) As %Query(ROWSPEC = "ICDRowId:%String,ICDDesc:%String,GroupIndex:%String,GroupItemIndex:%String")
{
}

ClassMethod FindDiagoseTabDetailExecute(ByRef qHandle As %Binary, TabRowId As %String) As %Status
{
	n repid
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	Set GroupIndex=""  for {
		Set GroupIndex=$O(^DHCDIAICD("MASTER",TabRowId,GroupIndex))
		Quit:GroupIndex=""
    	Set GroupItemIndex="" for {
	    	s GroupItemIndex=$O(^DHCDIAICD("MASTER",TabRowId,GroupIndex,GroupItemIndex)) 
	    	Quit:GroupItemIndex=""  d
    		Set RowId="" for {
	    		Set RowId=$O(^DHCDIAICD("MASTER",TabRowId,GroupIndex,GroupItemIndex,RowId))
	    		Quit:RowId=""
    			Set MRCICDDR=$P($g(^DHCDIAICD(RowId)),"^",3)
    			Continue:MRCICDDR=""
				Set MRCICDDesc=$P($G(^MRC("ID",MRCICDDR)),"^",2)
				Set ^CacheTemp(repid,ind)=$lb(MRCICDDR,MRCICDDesc,GroupIndex,GroupItemIndex)
				Set ind=ind+1
    		}
    	}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindDiagoseTabDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDiagoseTabDetailExecute ]
{
	n repid
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDiagoseTabDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDiagoseTabDetailExecute ]
{
	n repid
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 k ^CacheTemp(repid)
	}Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 批量建卡 可以根据身份证号和姓名一致的方式绑定病人其他卡 guobaoping 
/// w ##class(web.DHCDocService).NewCardClass("")
ClassMethod NewCardClass(Input As %String = "") As %String
{
        ;s Input="<NewCardInfo><CardTypeRowID>1</CardTypeRowID><CardNo>6217582600000011723</CardNo><Name>白金生</Name><Sex>男</Sex><Birth>1956-12-23</Birth><TelHome>18761960795</TelHome><Address>广西北海市幸福小区幸福苑2幢102号</Address><IDCardNo>410203195612220063</IDCardNo><PatType>1</PatType><BindFlag>1</BindFlag><UserDR>5</UserDR></NewCardInfo>"
        n (Input)
        s ^TMP("NewCardClass")=Input
        Q:(Input="") ""
		s CardNo="",Name="",Sex="",Birth="",TelHome="",Address="",IDCardNo="",PatType="",myPatientID=""
        s myAMPObj=##class(web.DHCEntity.PCA.NewCardInfo).%New()
		d myAMPObj.XMLNodeDeserialize(.myAMPObj, "NewCardInfo",Input)
		s CardTypeRowID=myAMPObj.CardTypeRowID
		s CardNo=myAMPObj.CardNo
		s IDCardNo=myAMPObj.IDCardNo
		s BindFlag=myAMPObj.BindFlag
		;1.判断该卡是否已经被使用
		s ret=##class(web.DHCBL.CARD.UCardRefInfo).ReadPatValidateInfoByCardNo(CardNo,"",CardTypeRowID)
		s retcode=$p(ret,"^")
		Q:retcode'="0" retcode
		;2.绑定标记BindFlag为"1"时要做绑定操作
		i BindFlag="1"  d
		.s ret=..GetAvailCardNoByIDCardNo(IDCardNo,Name)
		.s PAPMIDR=$p(ret,"^",3)
		.s:PAPMIDR'="" myAMPObj.PAPMIRowID=PAPMIDR
		;3.建卡
		s ret=..CreateCard(myAMPObj)
		s retcode=$p(ret,$c(1))
		d myAMPObj.%Close()
		q retcode
}

/// 根据身份证号获取病人有效卡 guobaoping 
/// w ##class(web.UDHCAccManageCLSIF).CreateCard("440921198402207135",3)
ClassMethod CreateCard(myobj As web.DHCEntity.PCA.NewCardInfo) As %String
{
		n (myobj)
		q:'$IsObject(myobj) ""
		s myCardTypeDR=myobj.CardTypeRowID
		b ;1.设置
		s ConfigInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).ReadDefaultCardTypeConfigByDR(myCardTypeDR)
		b ;2.病人信息
			s obj=##class(web.DHCEntity.PCA.PATMAS).%New()
			s obj.Address=myobj.Address
			s obj.Birth=myobj.Birth
			s obj.CredType=1 //身份证
			s obj.CredNo=myobj.IDCardNo
			;s obj.Company=myobj.Company
			s obj.IDCardNo1=myobj.IDCardNo
			s obj.Name=myobj.Name
			s obj.PatType=myobj.PatType
			s obj.Sex=myobj.Sex
			s obj.TelHome=myobj.TelHome
			s obj.UserDR=myobj.UserDR
			s obj.PAPMIRowID=myobj.PAPMIRowID
			s status=obj.XMLExportToString(.PaPatInfo)	
			If ($system.Status.IsError(status)) {
				s PaPatInfo=""
			}
		;3.卡类型设置	
			s obj=##class(web.DHCEntity.PCA.CardRef).%New()
			s obj.CardNo=myobj.CardNo
			s obj.CardTypeDefine=myobj.CardTypeRowID
			s obj.UserDR=myobj.UserDR
			s status=obj.XMLExportToString(.CardInfo)	
			If ($system.Status.IsError(status)) {
			s CardInfo=""
			}
		;4.卡账户信息
			s obj=##class(web.DHCEntity.PCA.AccManager).%New()
			s obj.CardNo=myobj.CardNo
			s obj.UserDR=myobj.UserDR
			s status=obj.XMLExportToString(.AccInfo)	
			If ($system.Status.IsError(status)) {
			s AccInfo=""
			}
		;5.预交金信息
			s obj=##class(web.DHCEntity.PCA.AccPreDeposit).%New()
			s obj.UserDR=myobj.UserDR
			s status=obj.XMLExportToString(.DepositInfo)	
			If ($system.Status.IsError(status)) {
			s DepositInfo=""
			}
		;6.卡发票信息	
			s obj=##class(web.DHCEntity.PCA.CardINVPRT).%New()
			s obj.UserDR=myobj.UserDR
			s status=obj.XMLExportToString(.CardINVInfo)	
			If ($system.Status.IsError(status)) {
			s CardINVInfo=""
			}
	s SepcialInfo="^000000"
    s ExpStr=""
    b ;savepca 
    s Ret=##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)   
    Q Ret
}

/// w ##class(web.DHCDocService).GetAvailCardNoByIDCardNo("440623751107593")
ClassMethod GetAvailCardNoByIDCardNo(IDCardNo As %String = "", Name As %String = "") As %String
{
	;旧数据只在病人信息上有身份证号码,所以如果碰到老病人,返回该卡的信息
	q:IDCardNo="" ""
	n (IDCardNo,Name)
	s myPAID=$ZConvert(IDCardNo,"U")
	i $l(myPAID)=15{
		s myPAID15=$ZConvert(myPAID_"Z", "U")
		s myPAID18=$e(myPAID,1,6)_"19"_$e(myPAID,7,15)_" "
		s myPAID18=$ZConvert(myPAID18_"Z","U")		
		}elseif($l(myPAID)=18){
		s myPAID18=$ZConvert(myPAID_"Z", "U")
		s myPAID15=$e(myPAID,1,6)_$e(myPAID,9,17)
		s myPAID15=$ZConvert(myPAID15_"Z","U")
		}else
		{
		s myPAID18="ZX"
		s myPAID15="ZX"
		}
		b ;分成  15 位和 18位区别
		k PatArr
		s CardID=""
		s CredNo=IDCardNo
		s myPAID=$ZConvert(CredNo, "U")
		;验证证件类型和证件号码
		s myPAPMIDR=0 f  s myPAPMIDR=$o(^PAPERi("DVA",myPAID,myPAPMIDR))  q:(myPAPMIDR="")!(CardID'="")  d
		.q:'$d(^PAPER(myPAPMIDR))
		.s:'$d(PatArr(myPAPMIDR)) PatArr(myPAPMIDR)=""
		.;同一证件类型才成
		.s myCredTypeDR=$p(^PAPER(myPAPMIDR,"PAT",3),"^",7)	;CardType_DR
		.s:myCredTypeDR'="" CredType=$p(^PAC("CARD",myCredTypeDR),"^",2)
		.i $g(CredType)["身份证" d
		..s myCardTypeDR=""  f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:myCardTypeDR=""  d
		...s myCardRowID="" f  s myCardRowID=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR,myCardRowID),-1) q:(myCardRowID="")!(CardID'="")  d
		....q:'$d(^DHCCARD("CF",myCardRowID))
		....s myAFlag=$p(^DHCCARD("CF",myCardRowID),"^", 10)			;CF_ActiveFlag
		....q:(myAFlag'="N")
		....s CardID=myCardRowID
		if (CardID="")
		{ 
		s myPAPMIDR=0 f  s myPAPMIDR=$o(^PAPERi("PAPMI_ICPPBC",myPAID18,myPAPMIDR))  q:((myPAPMIDR="")!(CardID'=""))  d
		.q:'$d(^PAPER(myPAPMIDR))
		.s:'$d(PatArr(myPAPMIDR)) PatArr(myPAPMIDR)=""
		.s myCardTypeDR=""  f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:myCardTypeDR=""  d
		..s myCardRowID=0 f  s myCardRowID=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR,myCardRowID),-1) q:(myCardRowID="")!(CardID'="")  d
		...q:'$d(^DHCCARD("CF",myCardRowID))
		...s myAFlag=$p(^DHCCARD("CF",myCardRowID),"^", 10)			;CF_ActiveFlag
		...q:(myAFlag'="N")	
		...s CardID=myCardRowID
		}
		b ;18 
		if CardID="" 
		{
			s myPAPMIDR=0 f  s myPAPMIDR=$o(^PAPERi("PAPMI_ICPPBC",myPAID15,myPAPMIDR))  q:((myPAPMIDR="")!(CardID'=""))  d
			.q:'$d(^PAPER(myPAPMIDR))
			.s:'$d(PatArr(myPAPMIDR)) PatArr(myPAPMIDR)=""
			.s myCardTypeDR=""  f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:myCardTypeDR=""  d
			..s myCardRowID="" f  s myCardRowID=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR,myCardRowID),-1) q:(myCardRowID="")!(CardID'="")  d
			...q:'$d(^DHCCARD("CF",myCardRowID))
			...s myAFlag=$p(^DHCCARD("CF",myCardRowID),"^", 10)			;CF_ActiveFlag
			...q:(myAFlag'="N")
			...s CardID=myCardRowID
		}
		b ;15
		if CardID=""
		{
			s PatId=$o(PatArr(""),-1)
			s CardNo=""
		}else{
			s CardNo=$p(^DHCCARD("CF",CardID),"^", 2)
		    s PatId=$p(^DHCCARD("CF",CardID),"^", 4)
		    
		}
		if PatId'=""  D
		.s PatNo=##Class(web.PAPatMas).GetRegistration(PatId)
		.s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	    .s myIDCardNo=$p($g(^PAPER(PatId,"ALL")),"^",9)
		.s OldIDCardNo=..GetIDCardNoByPatientID(PatId)
		.b ;旧的病人信息里如果有15位的身份证号码,需要把身份证号码更新成18位的
		.i ((OldIDCardNo'=IDCardNo)||(myIDCardNo'=IDCardNo))&&(PatName=Name) d  
		..s CredType=$P($G(^PAPER(PatId,"PAT",3)),"^",7)
		..i (CredType=1)||(CredType="")  d
		...Set patmas = ##class(User.PAPatMas).%OpenId(PatId)
		...d patmas.PAPMICardTypeDRSetObjectId(1) 
	    ...s patmas.PAPMIDVAnumber=IDCardNo   ;证件号码  有索引
		...S sc = patmas.%Save()
		...d patmas.%Close()
		..d ##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(PatId,IDCardNo)
		else  s PatNo=""
	q CardID_"^"_CardNo_"^"_PatId_"^"_PatNo
}

/// w ##class(web.DHCDocService).GetIDCardNoByPatientID(1)
ClassMethod GetIDCardNoByPatientID(PatientID As %String = "") As %String
{
	n (PatientID)
	q:(PatientID="")||('$D(^PAPER(PatientID))) ""
	s CredType=$P($G(^PAPER(PatientID,"PAT",3)),"^",7)
	s IDCardNo=""
	s IDCardNo=$P($G(^PAPER(PatientID,"PAT",3)),"^",6)
	q:IDCardNo'="" IDCardNo
	s IDCardNo=$P($G(^PAPER(PatientID,"ALL")),"^",9)   ;身份证
	q IDCardNo
}

/// 获取建卡的错误代码,并返回错误信息
ClassMethod GetNewCardErrMsg(ErrCode As %String = "") As %String
{
	n (ErrCode)
	s ErrMsg =$select(
				 ErrCode="-100":"病人信息保存失败",
				 ErrCode="-104":"病人信息保存失败",
				 ErrCode="-200":"卡信息保存失败",
				 ErrCode="-201":"卡状态信息保存失败",
				 ErrCode="-302":"此病人已经有正常的卡了,不能发卡",
				 ErrCode="-303":"卡号不能为空",
				 ErrCode="-304":"此卡号已经存在,不能发卡",
				 ErrCode="-340":"此卡要求预先生成登记号码，但是没有生成错误",
				 ErrCode="-341":"此卡号已经存在,不能发卡",
				 ErrCode="-350":"此卡已经使用,不能重复发卡",
				 ErrCode="-351":"此卡已经被挂失,不能使用",
				 ErrCode="-352":"此卡已经被作废，不能使用",
				 ErrCode="-356":"此卡数据被预先生成错误",
				 ErrCode="-357":"卡数据没有预先生成",
				 ErrCode="-358":"此卡已经对应登记号了，不能在办理",
				 ErrCode="-359":"发卡时，此卡已经有对应的登记号了，不能在新增",
				 ErrCode="-364":"一个患者只能有一张同类卡",
				 ErrCode="-365":"此证件号码已经存在,请办理其他卡或办理补卡",
				 ErrCode="-366":"请选择卡类型",	 
				 ErrCode="-367":"证件号码不能为空",
				 ErrCode="-368":"同一个证件类型的证件号码被发现，唯一标示卡被发现",
				 ErrCode="-369":"办理卡绑定时? 获取患者信息错误",
				 ErrCode="-370":"卡号位数和卡类型设置不一致",
				 ErrCode="-371":"卡前缀不一致",
				 1:"错误代码为"_ErrCode)
 q ErrMsg
}

/// Creator:      郭荣勇
/// CreatDate:    2010.11.26
/// Description:: 复制门诊就诊医嘱到住院
/// Table;        OE_OrdItem
/// Input:        OPEpiosodeID:门诊就诊指针 IPEpiosodeID:住院就诊指针,接收科室,操作用户,登录科室,登录医生
/// Return:       0 成功
/// Others:		  
/// w ##class(web.DHCDocService).CopyOPAdmOrder(162,187,23,1234)
ClassMethod CopyOPAdmOrder(OPEpiosodeID, IPEpiosodeID, RecDep, User, TargetDep, TargetDoc = "")
{
	;1.得到门诊检验,检查医嘱
	;2.根据门诊医嘱组织需要插入到住院的医嘱
	;3.插入住院医嘱
	;4.更新部分字段
	
	Q:OPEpiosodeID="" "-1^"
	Q:IPEpiosodeID="" "-1^"
	Q:RecDep="" "-1^"
	Q:User="" "-1^"
	i TargetDoc="" s TargetDoc=$p(^SSU("SSUSR",User),"^",14)
	
	s OPOrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(OPEpiosodeID)
	q:OPOrderRowid="" 0
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(IPEpiosodeID)
	s OPitemsub=0
	for {
		s OPitemsub=$o(^OEORD(OPOrderRowid,"I",OPitemsub)) q:OPitemsub=""
		s itemstat=$p($g(^OEORD(OPOrderRowid,"I",OPitemsub,1)),"^",13)
		i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		continue:(statcode'="E")
		;检验,检查
		s itemrowid=$p($g(^OEORD(OPOrderRowid,"I",OPitemsub,1)),"^",2)
		s arctpdr=$p(^ARCIM($p(itemrowid,"||",1),$p(itemrowid,"||",2),1),"^",10)
		s OrderType=$p(^ARC("IC",arctpdr),"^",7)
		s ServerMaterial=$p($g(^ARCIM(+itemrowid,$p(itemrowid,"||",2),7)),"^",6)
		if (ServerMaterial="Service")||(ServerMaterial="S") s ServerMaterial="S"
		continue:(ServerMaterial'="S")&&(OrderType'="L")
		s OrdItem=OPOrderRowid_"||"_OPitemsub
		if OrdItem="" continue
		s Ord=+$p(OrdItem,"||",1),Sub=+$p(OrdItem,"||",2)
		s OrderARCIMRowid="", OrderType="", OrderPriorRowid=""
		s OrderStartDate="", OrderStartTime="", OrderPackQty=""
		s OrderPrice="", OrderRecDepRowid="", BillTypeRowid=""
		s OrderDrugFormRowid="", OrderDepProcNotes="", OrderDoseQty=""
		s OrderDoseUOMRowid="", OrderQtySum="", OrderFreqRowid=""
		s OrderDurRowid="", OrderInstrRowid="", PHPrescType=""
		s OrderMasterSeqNo="", OrderSeqNo="", OrderSkinTest=""
		s OrderPhSpecInstr="", OrderCoverMainIns="", OrderActionRowid=""
		s OrderARCOSRowid="",OrderEndDate="",OrderEndTime=""
		s OrderLabSpecRowid="",OrderMultiDate="",OrderNotifyClinician=""
		s OrderDIACatRowId="",OrderInsurCatRowId="",OrderFirstDayTimes=""
		s OrderInsurSignSymptomCode="",OrderStageCode="",OrderSpeedFlowRate=""
		s AnaesthesiaID="",OrderLabEpisodeNo="",VerifiedOrderMasterRowid=""
		s OrderNutritionDrugFlag="",OrderMaterialBarCode="",OrderCPWStepItemRowId=""
		s OrderInsurApproveType="",OrderNeedPIVAFlag=""
		
 &SQL(SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,
        OEORI_SttDat,OEORI_SttTim,OEORI_SttDat,
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
        OEORI_ARCOS_DR,OEORI_BBExtCode,OEORI_OEORI_DR,OEORI_PhSpecInstr,OEORI_Price,
        OEORI_CoverMainIns,OEORI_Action_DR,OEORI_Action_DR->ACT_Desc,OEORI_NotifyClinician,
        OEORI_DRGOrder,OEORI_BBExtCode,OEORI_SpeedFlowRate,OEORI_LabEpisodeNo,OEORI_Qty,OEORI_Anaest_DR
 INTO :OrderItemRowid,:OrderARCIMRowid,:OrderName,:OrderSttDate,:OrderSttTime,:StartDate,
        :OrderDoseQty,:OrderDoseUOMRowid,:OrderDoseUOM,:OrderPackQty,
        :OrderPriorRowid,:OrderPrior,:OrderStatusRowid,:OrderStatus,:OrderFreqRowid,:OrderFreq,
        :OrderInstrRowid,:OrderInstr,:OrderDurRowid,:OrderDur,
        :OrderRecDepRowid,:OrderRecDep,:OrderUserDepRowid,:OrderUserDep,
        :OrderDocRowid,:OrderDoc,:OrderUserAddRowid,:OrderUserAdd,
        :OrderBilled,:OrderSkinTest,:OrderBillTypeRowid,:OrderType,
        :OrderSeqNo,:OrderMasterSeqNo,:OrderLinkTo,:OrderPrescNo,:OrderLabEpisodeNo,
        :OrderARCOSRowid,:OrderBillTypeRowid,:LinkOrderItem,:OrderPhSpecInstr,:OrderPrice,
        :OrderCoverMainIns,:OrderActionRowid,:OrderAction,:OrderNotifyClinician,
        :OrderDIACatRowId,:InsType,:OrderSpeedFlowRate,:OrderLabEpisodeNo,:OrderFirstDayTimes,:AnaesthesiaID
 From SQLUser.OE_OrdItem WHERE OEORI_Rowid=:OrdItem)
 		s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrdItem)
		s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderPackUOMRowid)
		s OrderMasterSeqNo=""
		s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
		s OrderDepProcNotes=$g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DEP",1))
		s subcat=$p($g(^ARCIM(+OrderARCIMRowid,1,1)),"^",10)
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(subcat,AdmHospitalId,OrderARCIMRowid)
		if LinkOrderItem'="" s OrderMasterSeqNo=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),3)),"^",4)
		s OrderEndDate=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),9)),"^",9)
		s OrderEndTime=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),9)),"^",10)
		s OrderInsurCatRowId=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",3)
		s OrderStageCode=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",8)
		s OrderNutritionDrugFlag=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",12)
		s OrderNeedPIVAFlag=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",16)
		;s OrderInsurSignSymptomCode=$$GetOrderItemDSYM(oeitm,InsurSignSymptomCode)
		s OrderMaterialBarCode=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",14)
		if OrderSttTime="" s OrderSttTime=..%SysTime()
		if (OrderSttDate'="")&(OrderSttDate'["/") s OrderSttDate=$zd(OrderSttDate,4)
		if (OrderSttTime'="")&(OrderSttTime'[":") s OrderSttTime=..%ZT(OrderSttTime,1)
		if (OrderEndDate'="")&(OrderEndDate'["/") s OrderEndDate=$zd(OrderEndDate,4)
		if (OrderEndTime'="")&(OrderEndTime'[":") s OrderEndTime=..%ZT(OrderEndTime,1)
		s OrderFirstDayTimes=""
		
		
		;OrderQtySum,OrderMasterSeqNo,OrderSeqNo,OrderEndDate,OrderEndTime,OrderLabSpecRowid,OrderMultiDate
		;OrderInsurSignSymptomCode,OrderStageCode
		;VerifiedOrderMasterRowid,OrderMaterialBarCode,OrderCPWStepItemRowId
		;OrderInsurApproveType
		s ItemStr=OrderARCIMRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderSttDate_"^"_OrderSttTime
		s ItemStr=ItemStr_"^"_OrderPackQty_"^"_OrderPrice_"^"_OrderRecDepRowid_"^"_OrderBillTypeRowid
		s ItemStr=ItemStr_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid
		s ItemStr=ItemStr_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid
		s ItemStr=ItemStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest
		s ItemStr=ItemStr_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns_"^"_OrderActionRowid_"^"_OrderARCOSRowid
		s ItemStr=ItemStr_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid_"^"_OrderMultiDate
		s ItemStr=ItemStr_"^"_OrderNotifyClinician_"^"_OrderDIACatRowId_"^"_OrderInsurCatRowId_"^"_OrderFirstDayTimes
		s ItemStr=ItemStr_"^"_OrderInsurSignSymptomCode_"^"_OrderStageCode_"^"_OrderSpeedFlowRate_"^"_AnaesthesiaID
		s ItemStr=ItemStr_"^"_OrderLabEpisodeNo_"^"_VerifiedOrderMasterRowid_"^"_OrderNutritionDrugFlag_"^"_OrderMaterialBarCode
		s ItemStr=ItemStr_"^"_"^"_OrderCPWStepItemRowId_"^"_OrderInsurApproveType_"^"_OrderNeedPIVAFlag
        
        if OrdListStr="" s OrdListStr=ItemStr
        else  s OrdListStr=OrdListStr_$C(1)_ItemStr
	}
	
	TS
	b ;SaveOrderItems   start
	s myErr=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(IPEpiosodeID,OrdListStr,User,TargetDep,TargetDoc)
	b ;SaveOrderItems finsh
	if myErr="100" {
		TRO
		Q myErr_"^"_"医嘱复制保存时失败."
	}
	s RetSaveOrdStr=myErr
	
	;更新部分字段
	s myErr=0
	f k=1:1:$l(RetSaveOrdStr,"^")-1 {
		s newOrdIdDR=$p($p(RetSaveOrdStr,"^",k),"*",2)
		i newOrdIdDR="" continue
		&sql(Update SQLUser.OE_OrdItem set OEORI_RecDep_DR=:RecDep WHERE OEORI_RowId=:newOrdIdDR)
		i 'SQLCODE {
			&sql(Update SQLUser.OE_OrdExec set OEORE_Order_Status_DR=1 WHERE OEORE_OEORI_ParRef=:newOrdIdDR)
			i 'SQLCODE {
				&sql(Update SQLUser.OE_OrdExecExt set OEORE_OrderStatus_DR=6 WHERE OEORE_OEORI_ParRef=:newOrdIdDR)
			}
		}
		i 'SQLCODE {
			;得到执行日期和执行时间
			s STDate=$p(^OEORD(+newOrdIdDR,"I",$P(newOrdIdDR,"||",2),1),"^",9)
			s STTime=$p(^OEORD(+newOrdIdDR,"I",$P(newOrdIdDR,"||",2),1),"^",10)
			&sql(Insert into SQLUser.OE_OrdStatus(ST_ParRef,ST_Date,ST_Time,ST_Status_DR,ST_User_DR) values(:newOrdIdDR,:STDate,:STTime,6,:User))
		}
		s myErr=SQLCODE
	}
	
	if myErr'=0 {
		TRO
		Q myErr_"^"_ErrDesc
	}
	
	TC
	
	
	Q myErr_"!"_RetSaveOrdStr
}

/// 插入过敏记录接口  药学项过敏
/// 入参:PatientID: 病人ID
///      ArcimId: 医嘱项ID
///      User: 用户ID
///      Comments: 备注内容
/// w ##class(web.DHCDocService).InsertPAAllergy(PatientID,ArcimId,User,Comments)
ClassMethod InsertPAAllergy(PatientID As %String, ArcimId As %String, User As %String, Comments As %String = "") As %String
{
	s ^TMP("InsertPAAllergy")=PatientID_","_ArcimId_","_User_","_Comments
	Q:(PatientID="")||(ArcimId="")||(User="") 100
	Q:'$D(^PAPER(PatientID)) 100
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimId)
	Q:DrgformRowid="" 0
	s CTPCPId=##class(web.SSUser).GetDefaultCareProvider(User)
	Q:CTPCPId="" 101
	s MRCAllType=$o(^MRC("AT",0,"MRCAA_Desc","药品",""))
	s UpdateDate=..%SysDate()
	s UpdateTime=..%SysTime()
	s Comments=$lb(Comments)
	&sql(insert into SQLUser.PA_Allergy(ALG_PAPMI_ParRef,ALG_CTPCP_DR,ALG_PHCDM_DR,ALG_MRCAllType_DR,ALG_Status,ALG_LastUpdateDate,ALG_LastUpdateTime,ALG_UpdateUser_DR,ALG_Comments,ALG_OnsetDate)
	 values(:PatientID,:CTPCPId,:DrgformRowid,:MRCAllType,"A",:UpdateDate,:UpdateTime,:User,:Comments,:UpdateDate))
	if SQLCODE'=0  Q SQLCODE
	s AllergyRowId=%ROWID
	s ALGExternalID=$p(AllergyRowId,"||")_"ALG"_$p(AllergyRowId,"||",2)
	&sql(update SQLUser.PA_Allergy set ALG_ExternalID=:ALGExternalID where ALG_RowID=:AllergyRowId)
	Q SQLCODE
}

/// creater lxz
/// 调用知识库
/// Input-------------------------
/// AdmID:就诊ID 		
/// ActiveType   C"判断校验"  Q"查询"  A"诊断对应医嘱提示"
/// OrdIDStr 	医嘱 RowIDStr RowID1_$C(2)_RowID2 生医嘱后调用用ID
/// OrdMesage	医嘱生成前传入验证信息 多条OrdMesage1_$C(2)_OrdMesag2
/// 			OrdMesage=ArcimID_"^"_InstrucDr_"^"_FreqID_"^"_DousQty_"^"_DousUomDr_"^"_PackQty_"^"_PackUomDr_"^"_DuraID_"^"_SeqNum_"^"_标本_"^"_部位_"^"_接收科室
/// 			医嘱项ID_"^"_用法ID_"^"_频次ID_"^"_单次计量_"^"_单次计量单位_"^"_整包装数量_"^"_整包装单位_"^"_疗程ID_"^"_关联号_"^"_标本_"^"_部位_"^"_接收科室
/// UserInfo    UserID_"^"_LocID_"^"_GroupID ----------用户ID_"^"_登录科室ID_"^"_安全组ID				
/// outPut------------------------
/// Rtn 	   是否验通过(0,1,空)
/// ControlLev 管制级别(0,1,空)
/// Mesage	  提示信息 (1是! 2是@ 3是/A 4是/B 5是/B 6是/$ 7是/n) 返回格式分级
/// 
/// w ##class(web.DHCDocService).CheckLibPha(AdmID,OrderID,Type,ActiveType,OrdIDStr,OrdMesage)
ClassMethod CheckLibPha(AdmID As %String, ActiveType As %String, OrdIDStr As %String, OrdMesage As %String, UserInfo As %String) As %String
{
	s ^lxz("CheckLibPha")=AdmID_","_ActiveType_","_OrdIDStr_","_OrdMesage_","_UserInfo
	s $ZT="CheckLibPha"
	s:ActiveType="" ActiveType="Q"
	s LibLabel=ActiveType
	s Input=AdmID_"!"_OrdMesage_"!"_OrdIDStr
	s ReturnStr=""  ;返回信息
	d ##class(web.DHCSTPHCMPASS).CheckLibPha(.ReturnStr,LibLabel,Input,UserInfo)
	//(1是! 2是@ 3是$c(13) 4是$c(2) 5是/* 6是/$ 7是/n) 返回格式分级
	s ReturnStr=$tr(ReturnStr,$C(13),"/A")
	s ReturnStr=$tr(ReturnStr,$C(2),"/B")
	s Rtn=$P(ReturnStr,"^",1)
	s ControlLev=$P(ReturnStr,"^",2)
	s Mesage=$P(ReturnStr,"^",3) 
	s ReturnStr=Rtn_"^"_ControlLev_"^"_Mesage
	Q ReturnStr
CheckLibPha
	Q "^^^"
}

/// 知识库获取药典提示所用参数
/// w ##class(web.DHCDocService).GetDurgArcimMesage("213||1")
ClassMethod GetDurgArcimMesage(ArcimRowid As %String) As %String
{
	s RtnStr=""
	s DrgGCode=""
	s PhcfCode=""
	s ArcimCode=""
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	i DrgFormRowid'="" d
	.s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.s DfSub=$p(DrgFormRowid,"||",2)
	.i DrgMastRowid'="" d
	..s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	..i $g(DrgGdr)'="" s DrgGCode=$p($g(^PHCGE("GE",DrgGdr)),"^",1) ;通用名Code
	..S PhcfDr=$P(^PHCD(DrgMastRowid,"DF",DfSub,1),"^",1)
	..if PhcfDr'="" s PhcfCode=$P(^PHCF(PhcfDr),"^",1) ;剂型Cod
	..s ArcimCode=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",1) //商品代码用的是医嘱项的代码
	s RtnStr=DrgGCode_"^"_PhcfCode_"^"_ArcimCode
    q RtnStr
}

/// 获取已经生成的医嘱ID串
/// w ##class(web.DHCDocService).GetAdmOrdStr(794)
ClassMethod GetAdmOrdStr(AdmID As %String) As %String
{
	s OrderStr=""
	s OEORDRowId=$O(^OEORD(0,"Adm",AdmID,0))
	Q:OEORDRowId="" ""
	s Child=0
	f  s Child=$O(^OEORD(OEORDRowId,"I",Child)) Q:Child=""  d
	.s ArcimID=$P($G(^OEORD(OEORDRowId,"I",Child,1)),"^",2)
	.q:ArcimID=""
	.s statcode="V"
	.s TtemStat=$P($G(^OEORD(OEORDRowId,"I",Child,1)),"^",13) ;OEORI_Billed
	.i TtemStat'="" d
	..s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	.Q:statcode'="V"
	.s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	.s OrderType=""
	.if ItemCatDr'="" d
	..s OrderType=$P(^ARC("IC",ItemCatDr),"^",7) 
	.s ServiceFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimID)
	.Q:(ServiceFlag'="1")&&(OrderType'="R")&&(OrderType'="L")
	.if OrderStr="" d
	..s OrderStr=OEORDRowId_"||"_Child
	.else  d
	..s OrderStr=OrderStr_$C(2)_OEORDRowId_"||"_Child
	q OrderStr
}

/// web.DHCDocService.GetNbspStr
/// w ##class(web.DHCDocService).GetNbspStr(3,2)
ClassMethod GetNbspStr(NumJoin As %String, SubStr As %String) As %String
{
	s strnbsp=""
	Q:+NumJoin=0 ""
	f NumJoin1=1:1:NumJoin
	{
		s strnbsp=strnbsp_SubStr
	}
	q strnbsp
}

/// Creator:      郭荣勇
/// CreatDate:    2015.08.17
/// Description:  查找本次就诊的所有医嘱,提供给其他产品组查询医嘱调用(电子病历)
/// Table:        OEC_OrderCategory,OE_Order,OE_OrdItem,PA_Adm,PA_PatMas
/// Input:        EpisodeID:就诊指针, SearchStartDate:开始日期,SearchEndDate:截止日期,CategoryID:医嘱大类ID,SubsortID:医嘱子类ID,LongOrd:长期医嘱标识(on或空),ShortOrd:临时医嘱标识(on或空),OutOrd:出院带药医嘱标识(on或空),OrdStat:可显示的医嘱状态(为空不判断 或 格式如:" E V I ")
/// CategoryID:	  大类指针, SubsortID:子类指针
/// Return:       OrdCreateDate:创建日期,OrdCreateTime:创建时间,OrdStartDate:开始日期,OrdStartTime:开始时间,ArcimDesc:医嘱描述,DoseQty:单次剂量,DoseUnit:单次剂量单位,Priority:医嘱优先级,PHFreq:频次,Instr:用法,Doctor:下医嘱医生,OrdStatus:医嘱状态,Dura:疗程,OEItemID:医嘱Rowid,PatientID:病人Rowid,SeqNo:序号,QtyPackUOM:整包装数量,PackUOMDesc:包装单位,PrescNo:处方号,dstatus:发药状态,LabEpisodeNo:检验号,OrdLabSpec:检验标本,OrdXDate:停止日期,OrdXTime:停止时间,OrdSkinTest:皮试标识,OrdAction:皮试备注,OrdDepProcNotes:医嘱备注,OrdBilled:计费标识,OrdSkinTestResult:皮试结果,OrderPackQty:整包装数量,OrderPrescNo:处方号,Pqty:基本单位总数量,ArcPrice:单价,ReLoc:接收科室,LabNo:检验号,userDep:下医嘱用户,UserAdd:创建用户,XUser:停止医生,EndDate:预停日期,EndTime:预停时间,CoverMainInsur:是否医保,BillType:费别,DspConfirmQty:退药数量,ActiveQty:有效发药数量,ActiveQtySum:有效发药数量价格,MaterialBarCode:高值条码"   
/// Others:       
ClassMethod GetOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "", OrdStat As %String = "") As %Status
{
	s ^tmpgry("GetOrdByAdm")=EpisodeID_"^"_SearchStartDate_"^"_SearchEndDate_"^"_CategoryID_"^"_SubsortID_"^"_LongOrd_"^"_ShortOrd
	///d ##class(%ResultSet).RunQuery("web.DHCDocService","GetOrdByAdm","201764","61325","61325","","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (SearchStartDate'="")&&(SearchEndDate'="")&&((SearchEndDate-SearchStartDate)>365) Quit
	
	s RetNum=$$GetOrdItem(repid,EpisodeID,SearchStartDate,SearchEndDate,CategoryID,SubsortID,"",LongOrd,ShortOrd,OutOrd,OrdStat)
	s i=0
	s SeqNo=1
	s SubSeqCount=1
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
	.s Data=^CacheTempFHQ(repid,i)
	.s OEItemID=$list(Data,14)
	.s OEItemIDChildsub=+$P($list(Data,14),"||",2)
	.i $d(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11)) s LinkOrderItemChildsub=$P($p(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11),"^",39),"||",2)
	.if $G(LinkOrderItemChildsub)="" d
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",OEItemIDChildsub)=Data
	.e  d
	..if '$D(^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub)) d
	...s ^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub)=""
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub,"sub",OEItemIDChildsub)=Data
	
	s SeqNo=0
	s mas=0 for  s mas=$O(^CacheTemp("DHCFindOrdItem",$j,"master",mas)) q:mas=""  d
	. s s1=^CacheTemp("DHCFindOrdItem",$j,"master",mas)
	. s PSeq=$p(mas,"||",2)
	. i s1'="" d 
	. .s SeqNo=SeqNo+1
	. .s $List(s1,16)=SeqNo
	. .s Data=s1
	. .d OutputRow
	. s SubSeqCount=0
	. s sub=0  for  s sub=$O(^CacheTemp("DHCFindOrdItem",$j,"master",mas,"sub",sub)) q:sub=""  d
	. . s s2=^CacheTemp("DHCFindOrdItem",$j,"master",mas,"sub",sub)
	. . i s1="" d
	. . . s SeqNo= SeqNo+1
	. . . s $List(s2,16)=SeqNo
	. . . s Data=s2
	. . . d OutputRow
	. . e  d
	. . . s PSeq=$p(sub,"||",2)
	. . . s SubSeqCount=SubSeqCount+1
	. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	. . . s $List(s2,16)=SubSeqNo
	. . . s Data=s2
	. . . d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	k ^CacheTemp("DHCFindOrdItem",$j,"master")
 quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
GetOrdItem(repid,AdmId,SearchStartDate,SearchEndDate,CategoryID,SubsortID,ArcId,LongOrd,ShortOrd,OutOrd,OrdStat)
	s del="^",AdmType="",RetNum=0
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)
    s PAADMRegConDisDR=$P($G(^PAADM(AdmId,"DHC")),"^",25)
	q:OrdId1=""
	s OrdId2=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s OEItemID=OrdId1_"||"_OrdId2
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	.s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	.s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	.s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
	.s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	.s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	.s ArcimId=$p(ordstr1,del,2)
	.q:((ArcId'="")&(ArcimId'=ArcId))
	.s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	.q:ArcStr=""
	.s EpissubtypeId=$P($g(^PAADM(AdmId,1)),"^",6)
	.s AdmReasonId=$P($g(^PAADM(AdmId,1)),"^",7)
	.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	.s drgformId=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",12)
	.;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	.s arctype=$p(^ARC("IC",arctpdr),"^",7)
	.s Pqty=""
	.i ($g(arctype)="R") d
	..s oeori=OrdId1_"||"_OrdId2
	..s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
	..q:dis=""
	..q:'$d(^DHCOEDISQTY(dis))
	..s Pqty=$p(^DHCOEDISQTY(dis),"^",2)
	.e  d
	..s Pqty=$p(^OEORD(OrdId1,"I",OrdId2,1),"^",12)
	.s BaseUOMDesc=""
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	.i INCIRowid'="" d
	..; INCI_CTUOM_DR  库存基本单位
	..s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	..s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	.i $g(Pqty)'="" s Pqty=Pqty_""_BaseUOMDesc
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=$zd(OrdCreateDate,3)
	.s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=..%ZT(OrdCreateTime,2)
	.s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=..%ZT(OrdStartTime,2)
	.s OrderPrescNo=$p(ordstr1,del,14)
	.s DoseqtySum=$p(ordstr1,del,12)
	.s OrderPackQty=$p(ordstr9,del,4)
	.;非药品
	.i arctype'="R" d
	..s DoseqtySum=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",12)
	..s OrderPackQty=DoseqtySum
	.;如果整包装数量是空也不能把单次计量直接赋值
	.;i OrderPackQty=""  d
	.;.s OrderPackQty=DoseqtySum
	.s QtyPackUOM=$p(ordstr9,del,4)
	.s ReLoc=""
	.s ReLocID=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",6)
	.If ReLocID'="" Set ReLoc=$P($P($G(^CTLOC(ReLocID)),"^",2),"-",2)
	.s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrdId1_"||"_OrdId2)
	.s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
	.i OrderPackQty'="" d
	..i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	..;包含基础单位和整包装代为的价格转换
	..s ExpStr=OrdId1_"||"_OrdId2_"^^"_AdmId_"^"_ReLocID
	..s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", "","",PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
	.else  d
	..;只是基本单位的价格
	..s ExpStr=PAADMRegConDisDR_"^"_OrdId1_"||"_OrdId2_"^^"_AdmId_"^"_ReLocID
	..s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", "","",ExpStr)
	.s ArcPrice=$j($p(ArcPrice,"^",1),3,4)
	.s PrescNo=$p(ordstr1,del,14)
	.s DoseQty=$p(ordstr2,del,1)
	.s DoseUnitID=$p(ordstr2,del,3)
	.//guorongyong start 2008-11-25
	.s OrdcatDR=""
	.s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),del,10)
	.s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),del,8)
	.Q:(SubsortID'="")&&(SubsortID'=SubsortDR)
	.Q:(CategoryID'="")&&(CategoryID'=OrdcatDR)
	.Q:(SearchStartDate'="")&&(SearchEndDate'="")&&(($zdh(OrdStartDate,3)<SearchStartDate)||($zdh(OrdStartDate,3)>SearchEndDate))
	.s OrderSeqNo=$p(ordstr3,del,4)
	.//end
	.s DoseUnit=""
	.s:DoseUnitID'="" DoseUnit=$p(^CT("UOM",DoseUnitID),del,2)
	.s PriorityDR=$p(ordstr1,del,8)
	.s:$g(PriorityDR)="" Priority="",PriorityCode=""
	.s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)
	.;w !,Priority_"^"_PriorityCode
	.Q:(LongOrd="on")&&(ShortOrd'="on")&&(OutOrd'="on")&&(PriorityCode'="S")
	.Q:(ShortOrd="on")&&(LongOrd'="on")&&(OutOrd'="on")&&(PriorityCode'="NORM")
	.Q:(OutOrd="on")&&(ShortOrd'="on")&&(LongOrd'="on")&&(PriorityCode'="OUT")
	.s PHFreq=""
	.s PHFreqDR=$p(ordstr2,del,4)
	.s:($g(PHFreqDR)'="")&&($d(^PHCFR(PHFreqDR))) PHFreq=$p(^PHCFR(PHFreqDR),del,1)
	.s:$g(PHFreq)="" PHFreq=""
	.s Instr=$p(ordstr2,del,7)
	.s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,2)
	.s:$g(Instr)="" Instr=""
	.s OrdStatusDR=$p(ordstr1,del,13)
	.s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	.s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	.Q:(OrdStat'="")&&(OrdStat'[(" "_OrdStatusCode_" "))
	.s DuraDR=$p(ordstr2,del,6)
	.s:$g(DuraDR)'="" Dura=$p(^PHCDU(DuraDR),del,3)
	.s:$g(Dura)="" Dura=""
	.s doctor=$p(ordstr1,del,11)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),del,2)
	.s:$g(doctor)="" doctor=""
	.s HaveDispensing=0,dstatus="",TotalQty=0
	.//存储退药数量,发药数量
	.s DspConfirmQty=0,ConfirmQty=0 
	.s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
	..s TotalQty=$p(^DHCOEDISQTY(dis),"^",2)
	..s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	..s HaveDispensing=1
	..//发药或退药数量
	..s dconfirmqty=$p(^DHCOEDISQTY(dis),"^",11)
	..i dstatus="R" d 
	...//退药数量
	...s DspConfirmQty=DspConfirmQty+dconfirmqty
	..i dstatus="C" d
	...s ConfirmQty=ConfirmQty+dconfirmqty
	.i HaveDispensing=1 d
	..i dstatus="C" s dstatus="已发"
	..i dstatus="TC" s dstatus="未发"
	..i dstatus=""  s dstatus="未打包"
	..i (DspConfirmQty'=0) d
	...i DspConfirmQty=ConfirmQty s dstatus="已退药"
	...i DspConfirmQty<ConfirmQty s dstatus="部分退药"
	.;条码号,标本
	.s LabEpisodeNo=$p(ordstr3,del,20) ;
	.s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
	.;停医嘱日期,停医嘱时间
	.s OrdXDate=$p(ordstr3,del,34)
	.if OrdXDate'="" s OrdXDate=$zd(OrdXDate,3)
	.s OrdXTime=$p(ordstr2,del,15)
	.if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
	.;皮试,皮试备注,备注,
	.s OrdSkinTest=$p(ordstr5,del,2)
	.s OrdAction=$p(ordstr11,del,21)
	.i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
	.s OrdDepProcNotes=$g(^OEORD(OrdId1,"I",OrdId2,"DEP",1))
	.i OrdDepProcNotes=""  s OrdDepProcNotes=$p($g(^OEORD(OrdId1,"I",OrdId2,2)),"^",8)
	.s OrdBilled=$p(ordstr3,"^",5)
	.i OrdBilled="P" s OrdBilled="已收费"
	.i OrdBilled="B" s OrdBilled="已账单"
	.i OrdBilled="TB" s OrdBilled="未账单"
	.i OrdBilled="I"  s OrdBilled="待退费"
	.s abnorm=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",3)
	.s OrdSkinTestResult=""
	.i OrdSkinTest="Y" d
	..i abnorm="Y" s OrdSkinTestResult="阳性"
	..i abnorm="N" s OrdSkinTestResult="阴性"
	.;
	.S RetNum=RetNum+1
	.s OrdRowid=OrdId1_"||"_OrdId2
	.s LabNo=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",20)
	.s UserDepart="",UserDepartType=""
	.s UserDepartId=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",2)
	.If UserDepartId'=""  d
	..Set UserDepart=$P($P($G(^CTLOC(UserDepartId)),"^",2),"-",2)
	..Set UserDepartType=$P($G(^CTLOC(UserDepartId)),"^",13)
	.;Q:(UserDepartId="")&((onlydoc="Y")||(onlyNurse="Y")||(onlyloc'=""))
	.;Q:(onlydoc="Y")&(UserDepartType="W")
	.;Q:(onlyNurse="Y")&(UserDepartType="E")
	.;Q:(onlyloc'="")&(onlyloc'=UserDepartId)
	.
	.s UserAdd=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",1)
	.If UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
	.s XUser=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",29)
	.if XUser'="" Set XUser=$P($G(^CTPCP(XUser,1)),"^",2)
	.s EndDate=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",9)
	.s EndTime=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",10)
	.If EndDate'="" Set EndDate=$ZD(EndDate,3)
	.If EndTime'="" Set EndTime=..%ZT(EndTime,1)
	.s CoverMainInsur=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",3)
	.s BillTypeRowid=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",18)
	.s BillType=""
	.If BillTypeRowid'=""  Set BillType=$P($G(^PAC("ADMREA",BillTypeRowid)),"^",2)
	.s OrderType=""
	.if arctpdr'="" s OrderType=$P(^ARC("IC",arctpdr),"^",7)
	.s OrderSum=OrderPackQty*ArcPrice
	.s ActiveQty="",ActiveQtySum=""
	.i (OrderType="R") d
	..;如果没有填数量则自动计算数量
	..i +OrderPackQty=0  d
	...s OrdMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(OrdId1_"||"_OrdId2)
	...;s OrderPackQty=TotalQty
	...;s OrderSum=TotalQty*ArcPrice
	...;s ActiveQty=ConfirmQty-DspConfirmQty 
	...;s ActiveQtySum=ActiveQty*ArcPrice	;有效价格
	...;s ActiveQtySum=$fn(ActiveQtySum,"",2)
	...;s ActiveQty=ActiveQty_BaseUOMDesc	;有效数量
	...s ActiveQtySum=$fn($P(OrdMesage,"^",11),"",2)
	...s ActiveQty=$P(OrdMesage,"^",12)
	...s OrderPackQty=ActiveQty
	...s Pqty=ActiveQty
	..e  d
	...;有整包装数量,按整包装计算有效数量的价格
	...s ActiveQty=ConfirmQty-DspConfirmQty
	...s ActiveQtySum=OrderPackQty*ArcPrice	;有效价格
	...s ActiveQtySum=$fn(ActiveQtySum,"",2)
	...s ActiveQty=ActiveQty_BaseUOMDesc	;有效数量
	.s:(+ActiveQtySum<=0) ActiveQtySum=OrderSum ;有效价格没有按照开医嘱价格计算
	.i DspConfirmQty'=0 d
	..//加上基本单位
	..s DspConfirmQty=DspConfirmQty_BaseUOMDesc
	.s MaterialBarCode=$p($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",14) ;高值条码
	.;--------
	.S RetNum=RetNum+1
	.S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OrderPackQty,OrderPrescNo,Pqty,ArcPrice,ReLoc,LabNo,UserDepart,UserAdd,XUser,EndDate,EndTime,CoverMainInsur,BillType,DspConfirmQty,ActiveQty,ActiveQtySum,MaterialBarCode)
	.;W OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,PHFreq,Instr,doctor,!
	q RetNum
}

ClassMethod GetOrdByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod GetOrdByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

Query GetOrdByAdm(EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "", OrdStat As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,OEItemID:%String,PatientID:%String,SeqNo:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String,dstatus:%String,LabEpisodeNo:%String,OrdLabSpec:%String,OrdXDate:%String,OrdXTime:%String,OrdSkinTest:%String,OrdAction:%String,OrdDepProcNotes:%String,OrdBilled:%String,OrdSkinTestResult:%String,OrderPackQty:%String,OrderPrescNo:%String,Pqty:%String,ArcPrice:%String,ReLoc:%String,LabNo:%String,userDep:%String,UserAdd:%String,XUser:%String,EndDate:%String,EndTime:%String,CoverMainInsur:%String,BillType:%String,DspConfirmQty:%String,ActiveQty:%String,ActiveQtySum:%String,MaterialBarCode:%String")
{
}

/// 知识库获取药典提示所用参数
/// w ##class(web.DHCDocService).GetLabArcimMesage("9693||1")
ClassMethod GetLabArcimMesage(arcim As %String) As %String
{
	Quit:$g(arcim)="" ""
	Quit:'$d(^ARCIM(+arcim,1,"EXT")) ""
	Set Ext=$o(^ARCIM(+arcim,1,"EXT",0))
	Quit:$g(Ext)="" ""
	Set ExtCode=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",4)
	Quit ExtCode
}

ClassMethod SettempContentIndex(tempContentIndex As %String, UserID As %String, Count As %String, SplitItemStr As %String) As %String
{
	s ^tempContentIndex("ZSK",UserID,tempContentIndex,Count)=SplitItemStr
	Q tempContentIndex
}

/// tanjishan 
/// 2019-06-14
/// 获取知识库药品说明书链接地址
/// Input:OrderARCIMRowid:医嘱项ID	ExtStr:OrdRowid^OrderLabSpecRowid^OrderBodyPartID
/// out:0^Msg^URL
/// Modify:20230207 nk
/// 			旧版知识库的链接，标版停用。药品说明书使用新产品组合理用药，检查检验等将使用基础数据平台
/// 			goTo-GetLinkMesageYDTS
ClassMethod GetLinkMesageZSQ(OrderARCIMRowid As %String, ExtStr As %String) As %String
{
	s OrdRowid=$P(ExtStr,"^",1)
	s OrderLabSpecRowid=$P(ExtStr,"^",2)
	//老版的部位串,我们存储到了备注信息上
	s OrderBodyPartID=$P(ExtStr,"^",3)
	if (OrdRowid'=""){
		s ProcNotes=$G(^OEORD(+OrdRowid,"I",$P(OrdRowid,"||",2),"DEP",1))
		s OrderBodyPartDesc=$P(ProcNotes,",",$L(ProcNotes,","))
		s:OrderBodyPartDesc'="" OrderBodyPartID=$O(^DHCPHPACON(0,"HisCode",OrderBodyPartDesc,0))
		s OrderLabSpecRowid=$$GetOELabSpecimen^DHCDocOrderCommonNew(OrdRowid)
	}
	if (OrderARCIMRowid="")||('$D(^ARCIM(+OrderARCIMRowid,+$p(OrderARCIMRowid,"||",2),1))){
		q "-1^无效的医嘱项"
	}
	s Url=""
	s ARCItemCode=##Class(web.DHCDocOrderEntry).GetARCItemCode(OrderARCIMRowid)
	s ARCItemSubCatDesc=##Class(web.DHCDocOrderEntry).GetARCItemSubCatDesc(OrderARCIMRowid)
	s ItemCatDR=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	if (OrderType="R"){
		s DurgMesage=##Class(web.DHCDocService).GetDurgArcimMesage(OrderARCIMRowid)
		s RDrgGCode = $P(DurgMesage,"^",1)
		s RPhcfCode = $P(DurgMesage,"^",2)
		s RArcimCode= $P(DurgMesage,"^",3)
		s Url = "dhc.bdp.kb.dhcdrugbrowser.csp?GenCode="_RDrgGCode_"&PointerCode="_RPhcfCode_"&ProCode="_RArcimCode
	}elseif (OrderType="N"){
		s Url = "dhc.bdp.kb.dhctreatbrowser.csp?GenCode="_ARCItemCode_"&PointerCode="
	}elseif (OrderType="L"){
		s ExtCode = ##Class(web.DHCDocService).GetLabArcimMesage(OrderARCIMRowid)
		s Url = "dhc.bdp.kb.dhclabbrowser.csp?GenCode="_ExtCode_"&PointerCode="_OrderLabSpecRowid
	}elseif (ARCItemSubCatDesc["放射"){
        if (OrderBodyPartID = "") {
            //q "-1^未查询到该放射说明书"
        }
        if (OrderBodyPartID'="")&&($length(OrderBodyPartID)= 1) s OrderBodyPartID = "0"_OrderBodyPartID
        //dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_RADIBrowser&
        s Url = "dhc.bdp.kb.dhcradibrowser.csp?GenCode="_ARCItemCode_"&PointerCode="_OrderBodyPartID
	}elseif (ARCItemSubCatDesc["超声"){
		if (OrderBodyPartID = "") {
			//q "-1^未查询到该超声说明书"
		}
		if (OrderBodyPartID'="")&&($length(OrderBodyPartID)= 1) s OrderBodyPartID = "0"_OrderBodyPartID
		//dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ULTRBrowser&
		s Url = "dhc.bdp.kb.dhcultrbrowser.csp?GenCode="_ARCItemCode_"&PointerCode="_OrderBodyPartID
	}elseif (ARCItemSubCatDesc["内镜") {
		s ExtCode = ##Class(web.DHCDocService).GetLabArcimMesage(OrderARCIMRowid)
		if (OrderBodyPartID = "") s OrderBodyPartID = "06" //默认胃 
		if ($length(OrderBodyPartID)= 1) s OrderBodyPartID = "0"_OrderBodyPartID
		//dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_GASTBrowser&
		s Url = "dhc.bdp.kb.dhcgastbrowser.csp?GenCode="_ExtCode_"&PointerCode="_OrderBodyPartID
    } elseif (ARCItemSubCatDesc["心电") {
        if (OrderBodyPartID = "") s OrderBodyPartID = "04" //默认心脏
        if ($length(OrderBodyPartID)= 1) s OrderBodyPartID = "0"_OrderBodyPartID
        //dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ELECTBrowser&
        s Url = "dhc.bdp.kb.dhcelectbrowser.csp?GenCode="_ARCItemCode_"&PointerCode="_OrderBodyPartID
    }
	if (Url=""){
		q "-100^未找到相应的知识库信息"
	}
	
	q "0^^"_Url
}

/// Creator:	nk
/// CreateDate:	2023-02-07
/// Desc:		获取医嘱说明书链接地址
/// 			药品说明书使用新产品组合理用药，检查检验等将使用基础数据平台
/// Input:		OrderARCIMRowid:医嘱项ID	ExtStr:OrdRowid^OrderLabSpecRowid^OrderBodyPartID
/// Output:		0^Msg^URL
/// Debug:
ClassMethod GetLinkMesageYDTS(OrderARCIMRowid As %String, ExtStr As %String) As %String
{
	s OrdRowid=$P(ExtStr,"^",1)
	s OrderLabSpecRowid=$P(ExtStr,"^",2)
	//老版的部位串,我们存储到了备注信息上
	s OrderBodyPartID=$P(ExtStr,"^",3)
	if (OrderARCIMRowid="")||('$D(^ARCIM(+OrderARCIMRowid,+$p(OrderARCIMRowid,"||",2),1))){
		q "-1^无效的医嘱项"
	}
	s Url=""
	s ItemCatDR=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	if (OrderType="R"){
		;药品说明书使用新产品组合理用药
		s ArcimInfo=##Class(web.DHCDocHLYYInterface).GetArcimInfo(OrderARCIMRowid)
		s ArcimCode = $P(ArcimInfo,"^",1)
		s ArcimDesc = $P(ArcimInfo,"^",2)
		s Url = "dhcckb.pdss.instruction.csp?IncId=&IncCode="_ArcimCode_"&IncDesc="_ArcimDesc
	}else{
		;检查检验等将使用基础数据平台新版知识库链接，暂未提供
		q "-100^未找到相应的说明书信息"	
	}
	q "0^^"_Url
}

/// creator:郭荣勇
/// date:2015-12-10
/// desc:获取就诊是否到达
/// input:PA_Adm
/// output:接诊日期^接诊标识 或 空,接诊日期:YYYY-MM-DD ,接诊标识:Y/N
/// other: 医保组调用
/// 		w ##class(web.DHCDocService).GetAdmIsArrive(11)
ClassMethod GetAdmIsArrive(AdmID As %String) As %String
{
	n (AdmID)
	s ret=""
	Q:AdmID="" ret
	;默认未接诊
	s ret="^N"
	s QueRowid=##class(web.DHCDocOutPatientList).GetQueRowidByMore(AdmID,"")
	i QueRowid'="" {
		s oref=##Class(User.DHCQueue).%OpenId(QueRowid)
		s QueStatus=oref.QueStateDr.PersName
		s QueDate=oref.QueDate
		i QueDate'="" s QueDate=$zd(QueDate,3)
		i QueStatus="到达" {
			s $p(ret,"^",1)=QueDate
			s $p(ret,"^",2)="Y"
		}
	}
	
	Q ret
}

}
