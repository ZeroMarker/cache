Import SQLUser

/// /1.定义/维护接口类型
/// /2. 定义门诊收费的接口类型规则的读写
/// /3. 获取一个接口对象 web.DHCEntity.CI.PaPatMas
/// /3.1 根据发票获取
/// /3.2 根据PaRowID获取等
Class web.DHCBL.CIDefine.TypeDefine Extends (%RegisteredObject, %XML.Adaptor, web.DHCBL.BLAbstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter EntityClassName = "web.DHCEntity.CIDefine.TypeDefine";

Parameter PersistentClassName = "User.DHCCITypeDefine";

/// 验证接收科室Rule
ClassMethod CheckRecLocRule(CTDRowID As %String, RecLocDR As %String) As %String
{
	;find return =0
	;else  <>0
	s myNoRuleFlag=1
	
	s myTDObj=##class(User.DHCCITypeDefine).%OpenId(CTDRowID)
	s myCount=myTDObj.OrdRule.Count()
	f myIdx=1:1:myCount  q:('+myNoRuleFlag)  d
	.s myTDRuleObj=myTDObj.OrdRule.GetAt(myIdx)
	.q:(myTDRuleObj.TORActiveFlag'="Y")
	.q:(myTDRuleObj.TORDateTo'="")&&(+myTDRuleObj.TORDateTo<+$h)
	.s myTime=$p($h,",",2)
	.q:(myTDRuleObj.TORTimeFrom'="")&&(myTime<myTDRuleObj.TORTimeFrom)
	.q:(myTDRuleObj.TORTimeTo'="")&&(myTime>myTDRuleObj.TORTimeTo)
	.q:(myTDRuleObj.TORRecLocDR.%Id()'=RecLocDR)
	.s myNoRuleFlag=0
	.d myTDRuleObj.%Close()
	
	d myTDObj.%Close()
	
	q myNoRuleFlag
}

ClassMethod CheckItemMastRule(CTDRowID As %String, OEORIDR As %String) As %String
{
	q 0
}

/// 一条医嘱是否在新的发票中发现的标志
/// =0  没有发现
/// <>0  发现了
ClassMethod CheckORDFindFromNewPRT(NewPRTRowID As %String, OEORIDR As %String) As %String
{
	s myrtn=0
	
	q:NewPRTRowID="" myrtn
	b		;
	s myFindFlag=0
	s myBCIRowID=0
	
	f  s myBCIRowID=$o(^DHCBCI(0,"INV", NewPRTRowID, myBCIRowID)) q:((myBCIRowID="")||(+myFindFlag))  d
	.s myPBRowID=$p(^DHCBCI(myBCIRowID),"^", 2)
	.s mySub=0
	.for  s mySub=$o(^DHCPB(myPBRowID,"O",mySub))  q:(mySub="")  d
	..q:($d(^DHCPB(myPBRowID,"O",mySub))=10)
	..s myOEORIDR=$p(^DHCPB(myPBRowID,"O",mySub), "^", 4)
	..i OEORIDR=myOEORIDR d
	...s myFindFlag=1
	
	i +myFindFlag {
		s Arcim=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1),"^",2)			;OEORI_ItmMast_DR
		s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
		s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
		i ARCOrdType="R"  d
		.;s returnqty=##class(web.UDHCOEORDOPIF).ReadOEORDRefundQty(NewPRTRowID,OEORIDR, "")
		e  d
		.;s returnqty=##class(web.UDHCOEORDOPIF).ReadOEORDRefundQty(NewPRTRowID,OEORIDR, "")
		
		;如果是部分退费
		;s myFindFlag=0
	}
	
	q myFindFlag
}

ClassMethod DTOTransObj(DTObj As %ObjectHandle) As %ObjectHandle
{
	;;w ##class(web.DHCBL.CIDefine.TypeDefine).DHCAuditSaveDataToServer(^TMPXmlData)
	i DTObj.CTDRowID="" {
		s myPObj=##class(User.DHCCITypeDefine).%New()
	}else{
		s myPObj=##class(User.DHCCITypeDefine).%OpenId(DTObj.CTDRowID)
	}
	
	s myPObj.CTDCode=DTObj.CTDCode
	s myPObj.CTDDesc=DTObj.CTDDesc
	s myPObj.CTDActiveFlag=DTObj.CTDActiveFlag
	s myDate=""
	i (DTObj.CTDDateFrom["/"){
		s myDate=$zdh(DTObj.CTDDateFrom,4)
		
	}elseif(DTObj.CTDDateFrom["-"){
		s myDate=$zdh(DTObj.CTDDateFrom,3)
	}else{
	}
	s myPObj.CTDDateFrom=myDate
	s myDate=""
	
	i (DTObj.CTDDateTo["/"){
		s myDate=$zdh(DTObj.CTDDateTo,4)
		
	}elseif(DTObj.CTDDateTo["-"){
		s myDate=$zdh(DTObj.CTDDateTo,3)
	}else{
	}
	s myPObj.CTDDateTo=myDate
	s myPObj.CTDInstruction=DTObj.CTDInstruction
	
	b	;
	;TO_DATE(59684,'MM/DD/YYYY')
	q myPObj
}

/// 根据发票RowID,得到一个对象
/// 提示：  收费时打印的新发票RowID
/// 作废和收费中  传入的是 作废的发票RowID
ClassMethod GetPatMasByPRTRowID(CTDRowID As %String, PRTRowID As %String, ByRef OutPATRef As web.DHCEntity.CI.PaPatMas) As %String
{
	;w ##class(web.DHCBL.CIDefine.TypeDefine).GetPatMasByPRTRowID(1,156)
	s myrtn=0
	
	i (CTDRowID=""){
		q -603
	}
	i (PRTRowID=""){
		q -604
	}
	
	;s myPatObj=##class(web.DHCEntity.CI.PaPatMas).%New()
	s myPatObj=OutPATRef
	s myTDObj=##class(User.DHCCITypeDefine).%OpenId(CTDRowID)
	s myPAPMIDR=$p(^DHCINVPRT(PRTRowID),"^",15)
	
	q:(myTDObj.CTDActiveFlag'="Y") -605
	q:(myTDObj.CTDDateTo'="")&&(myTDObj.CTDDateTo<+$h) -605
	
	;^DHCBCI({DHCBCI_Rowid})
	;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	s myrtn=-606
	s myOldPRTRowID=PRTRowID		;$p(^DHCINVPRT(PRTRowID),"^",29)			;PRT_OldINV_DR
	
	s myBCIRowID=0
	s myNewPRTRowID=""
	i myOldPRTRowID'="" d
	.s myNewPRTRowID=$o(^DHCINVPRT(0,"OldINV",PRTRowID,0))
	
	s myBCIRowID=0
	f  s myBCIRowID=$o(^DHCBCI(0,"INV", PRTRowID, myBCIRowID)) q:(myBCIRowID="")  d
	.s myPBRowID=$p(^DHCBCI(myBCIRowID),"^", 2)
	.s myAdmObj=..GetAdmByBPRowID(CTDRowID, myPBRowID, myNewPRTRowID)
	.q:('$IsObject(myAdmObj))
	.s myPatObj.InterfaceType=myTDObj.CTDCode
	.s myPatObj.Instruction  =myTDObj.CTDInstruction
	.s myPatObj.RowID=myPAPMIDR
	.d myPatObj.PAADMs.Insert(myAdmObj)
	.s myrtn=0
	
	s myCount=myPatObj.PAADMs.Count()
	
	d myTDObj.%Close()
	if (myCount){
		q myrtn
	}else{
		q myrtn
	}
}

/// 根据退费帐单获取Adm对象
/// NewPRTRowID  新发票的RowID
/// PBRowID   旧发票的账单
ClassMethod GetRefundAdmByBPRowID(CTDRowID As %String, PBRowID As %String, NewPRTRowID As %String) As web.DHCEntity.CI.PaAdm
{
}

/// 根据帐单获取Adm对象
/// PBRowID   当前打印发票的账单
ClassMethod GetAdmByBPRowID(CTDRowID As %String, PBRowID As %String, NewPRTRowID As %String) As web.DHCEntity.CI.PaAdm
{
	s myFindItem=0
	s myFindCount=0
	
	s myAdmObj=##class(web.DHCEntity.CI.PaAdm).%New()
	
	s myAdmDR=$p(^DHCPB(PBRowID),"^",1)
	;^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
	s mySub=0
	for  s mySub=$o(^DHCPB(PBRowID,"O",mySub))  q:(mySub="")  d
	.q:($d(^DHCPB(PBRowID,"O",mySub))=10)
	.s myOEORIDR=$p(^DHCPB(PBRowID,"O",mySub), "^", 4)
	.s myRecLocDR=$p(^OEORD(+myOEORIDR,"I",$p(myOEORIDR,"||",2), 3), "^",6)
	.s myrtn=..CheckRecLocRule(CTDRowID, myRecLocDR)
	.q:(+myrtn)
	.s myrtn=..CheckItemMastRule(CTDRowID, myOEORIDR)
	.q:(+myrtn)
	.i NewPRTRowID'="" d
	..s myrtn=..CheckORDFindFromNewPRT(NewPRTRowID, myOEORIDR)
	.q:(+myrtn)
	.s myAdmObj.RowID=myAdmDR
	.s myItmObj=##class(web.DHCEntity.CI.OrdItem).%New()
	.s myItmObj.RowID=myOEORIDR
	.d myAdmObj.OrdItems.Insert(myItmObj)
	.d myItmObj.%Close()
	.s myFindCount=+myFindCount+1
	
	i +myFindCount{
		q myAdmObj
	}else{
		q ""
	}
}

/// /获取单个的医嘱对象
/// /多个OrdItem对象组合成一个Adm对象
ClassMethod GetORDITEMByORIDR(CTDRowID As %String, OEORIDR As %String, ByRef OutORDRef As web.DHCEntity.CI.OrdItem) As %String
{
	s myrtn=0
	
	s myOEORIDR=OEORIDR
	s myRecLocDR=$p(^OEORD(+myOEORIDR,"I",$p(myOEORIDR,"||",2), 3), "^",6)
	s myrtn=..CheckRecLocRule(CTDRowID, myRecLocDR)
	q:(+myrtn) myrtn
	s myrtn=..CheckItemMastRule(CTDRowID, myOEORIDR)
	q:(+myrtn) myrtn
	;i NewPRTRowID'="" d
	;.s myrtn=..CheckORDFindFromNewPRT(NewPRTRowID, myOEORIDR)
	q:(+myrtn) myrtn
	;s myAdmObj.RowID=myAdmDR
	s myItmObj=OutORDRef
	s myItmObj.RowID=myOEORIDR
	
	q myrtn
}

/// 根据要结算的字符串，得到 Pat对象
ClassMethod GetPatMasByOEORDStr(CTDRowID As %String, OEORIStr As %String, ByRef OutPATRef As web.DHCEntity.CI.PaPatMas) As %String
{
	s myrtn=0
	
	i (CTDRowID=""){
		q -603
	}
	i (OEORIStr=""){
		q -604
	}
	
	s myPatObj=OutPATRef
	s myTDObj=##class(User.DHCCITypeDefine).%OpenId(CTDRowID)
	;s myPAPMIDR=$p(^DHCINVPRT(PRTRowID),"^",15)
	
	q:(myTDObj.CTDActiveFlag'="Y") -605
	q:(myTDObj.CTDDateTo'="")&&(myTDObj.CTDDateTo<+$h) -605
	
	s myrtn=-606
	
	s myBCIRowID=0
	s myOEORIDR=0
	s myLen=$l(OEORIStr,"^")
	
	;根据OEORD 找到ADMDR
	;如果Adm对象已经有了，就不建立Adm对象
	;否则建立一个新的 Adm对象
	;^OEORD(+myOEORIDR)
	
	f myIdx=1:1:myLen  d
	.s myFindAdmFlag=0			;
	.s myOEORIDR=$p(OEORIStr,"^", myIdx)
	.q:(myOEORIDR="")
	.s myAdmDR=$p(^OEORD(+myOEORIDR),"^", 1)
	.q:(myAdmDR="")
	.s myPAPMIDR=$p(^PAADM(+myAdmDR),"^",1)
	.q:(myPAPMIDR="")
	.;q:('$IsObject(myAdmObj))
	.s myItmObj=##class(web.DHCEntity.CI.OrdItem).%New()
	.s myrtn=..GetORDITEMByORIDR(CTDRowID, myOEORIDR, myItmObj)
	.q:(+myrtn)
	.s myPatObj.InterfaceType=myTDObj.CTDCode
	.s myPatObj.Instruction=myTDObj.CTDInstruction
	.s myPatObj.RowID=myPAPMIDR
	.s myFindAdmFlag=0
	.s myAdmCount=myPatObj.PAADMs.Count()
	.f myAdmIdx=1:1:myAdmCount  q:(+myFindAdmFlag)  d
	..s myAdmObj=myPatObj.PAADMs.GetAt(myAdmIdx)
	..q:(myAdmObj.RowID'=myAdmDR)
	..s myFindAdmFlag=1
	.i +myFindAdmFlag d
	..;发现有此Adm
	..d myAdmObj.OrdItems.Insert(myItmObj)
	.else  d
	..;没有此ADM'
	..s myAdmObj=##class(web.DHCEntity.CI.PaAdm).%New()
	..s myAdmObj.RowID=myAdmDR
	..d myAdmObj.OrdItems.Insert(myItmObj)
	..d myPatObj.PAADMs.Insert(myAdmObj)
	.s myrtn=0
	
	s myCount=myPatObj.PAADMs.Count()
	
	d myTDObj.%Close()
	
	if (myCount){
		q 0
	}else{
		q myrtn
	}
}

/// 根据PMI RowID 获取一个PatMas对象
ClassMethod GetPatMasByPMIRowID(CTDRowID As %String, PMIRowID As %String, ByRef OutPATRef As web.DHCEntity.CI.PaPatMas) As %String
{
	s myrtn=0
	
	i (CTDRowID=""){
		q -603
	}
	i (PMIRowID=""){
		q -604
	}
	
	s myPatObj=OutPATRef
	s myTDObj=##class(User.DHCCITypeDefine).%OpenId(CTDRowID)
	;s myPAPMIDR=$p(^DHCINVPRT(PRTRowID),"^",15)
	
	q:(myTDObj.CTDActiveFlag'="Y") -605
	q:(myTDObj.CTDDateTo'="")&&(myTDObj.CTDDateTo<+$h) -605
	
	s myrtn=-606
	
	;根据OEORD 找到ADMDR
	;如果Adm对象已经有了，就不建立Adm对象
	;否则建立一个新的 Adm对象
	
	s myPAPMIDR=PMIRowID			;$p(^PAADM(+myAdmDR),"^",1)
	q:(myPAPMIDR="")
	s myPatObj.InterfaceType=myTDObj.CTDCode
	s myPatObj.Instruction=myTDObj.CTDInstruction
	s myPatObj.RowID=myPAPMIDR
	
	;增加Adm, OrdItem
	s myAdmObj=##class(web.DHCEntity.CI.PaAdm).%New()
	s myItmObj=##class(web.DHCEntity.CI.OrdItem).%New()
	s myItmObj.RowID=1
	
	s myAdmObj.RowID=1
	d myAdmObj.OrdItems.Insert(myItmObj)
	
	d myPatObj.PAADMs.Insert(myAdmObj)
	
	d myItmObj.%Close()
	d myAdmObj.%Close()
	
	s myCount=1
	s myrtn=0
	
	d myTDObj.%Close()
	
	if (myCount){
		q myrtn
	}else{
		q myrtn
	}
}

Query SelectAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,CTD_Code,CTD_Desc,CTD_ActiveFlag, TO_DATE(CTD_DateFrom,'DD/MM/YYYY') As CTD_DateFrom,TO_DATE(CTD_DateTo,'DD/MM/YYYY') As CTD_DateTo ,CTD_Instruction
FROM DHC_CITypeDefine
 ORDER BY CTD_Code
}

ClassMethod SaveDataToServer(XmlData As %String) As %String
{
}

Query SelectAllForLookup() As %SQLQuery(CONTAINID = 1)
{
SELECT CTD_Desc,%ID,CTD_Code,CTD_ActiveFlag,CTD_DateFrom,CTD_DateTo 
FROM DHC_CITypeDefine
where CTD_ActiveFlag='Y'
 ORDER BY CTD_Code
}

}
