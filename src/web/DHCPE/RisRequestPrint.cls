Class web.DHCPE.RisRequestPrint Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：	  xy 
/// CreatDate：	  20220815
/// Description:  获取病理申请单ID
/// Input:        Oeori(医嘱ID)
/// Return：      病理申请单ID
/// Debug: w ##class(web.DHCPE.RisRequestPrint).GetPisAppID()
ClassMethod GetPisAppID(Oeori)
{
	 q:Oeori="" ""
	 s PisID=$o(^DHCAPPPM(0,"OrdItem",Oeori,"")) /// 申请单ID
	 q PisID
}

/// Creator：     xy 
/// CreatDate：   20220815
/// Description:  获取检查项目注意事项
/// Input:        itmmastid(医嘱项ID),HospID(院区ID)
/// Return：      检查项目的注意事项
/// Debug: w ##class(web.DHCPE.RisRequestPrint).GetRisNoteListArr("3934||1","2")
ClassMethod GetRisNoteListArr(itmmastid As %String, HospID As %String)
{
	n (itmmastid, HospID)
	;优先取【RIS预约平台配置】-【注意事项与医嘱项目设置】,若未配置或配置的模板注意事项为空,取检查树-检查注意事项
	s TempText="",ItemTemp=""
	s memoRowid=$o(^DHCRBAppi("Memo-ItMast",itmmastid,0))
	if (memoRowid'="") {
		s memoTmplRowid=$p(^DHCRBApp("Memo",memoRowid),"^",4)
		if (memoTmplRowid'="") {
			s ItemTemp=$p($g(^DHCRBCApp("Memo-Template",memoTmplRowid)),"^",2)
			s TempText=$p($g(^DHCRBCApp("Memo-Template",memoTmplRowid)),"^",3)
			//s TempText=$replace(TempText,$c(10),"<br>")
			s TempText=$replace(TempText,$c(10),"")
		}
	}
	
	if (TempText'="") {
		s ListData=ItemTemp_"^"_TempText
	}else {
		s ArcNoID=""
		F  s ArcNoID=$o(^DHCAPARCNO(0,"ARC",itmmastid,ArcNoID)) Q:ArcNoID=""  D
		.s ItemTempID=$p(^DHCAPARCNO(ArcNoID),"^",2)  /// 注意事项ID
		.s ItemTemp=$p(^DHCAPITMTE(ItemTempID),"^",2) /// 注意事项
		.Q:$p(^DHCAPITMTE(ItemTempID),"^",3)'="Y"     /// 不可用退出
		.Q:$p(^DHCAPITMTE(ItemTempID),"^",4)'=HospID  /// 登录医院判断
		.s CH=""
		.F  s CH=$o(^DHCAPITMTE(ItemTempID,"D",CH)) Q:CH=""  D
		..s TempText=$p(^DHCAPITMTE(ItemTempID,"D",CH),"^",1)
		..s ListData=ItemTemp_"^"_TempText
		
	
	}
	q TempText
}

/// Description: 获取检查申请单信息
/// debug: w ##class(web.DHCPE.RisRequestPrint).GetRisRequestInfo(5522,"")
ClassMethod GetRisRequestInfo(PADM, CRMOrder, Type As %String = "PreIADM")
{
	q:PADM="" ""
	
	if (Type="IADM") d
	.s PADM=$P($g(^DHCPEIADM(PADM)),"^",4)
	.i CRMOrder'="" d
	..s CRMOrder=$O(^DHCPECRMO(0,"OEORI",CRMOrder,0))
	..s CRMOrder=$P($g(^DHCPECRMO(CRMOrder)),"^",2)
	
	if (Type="PAADM") d
	.s PADM=$O(^DHCPEIADM(0,"PAADM",PADM,0))
	.s PADM=$P($g(^DHCPEIADM(PADM)),"^",4)
	.i CRMOrder'="" d
	..s CRMOrder=$O(^DHCPECRMO(0,"OEORI",CRMOrder,0))
	..s CRMOrder=$P($g(^DHCPECRMO(CRMOrder)),"^",2)
	
	s LocID=$P($g(^DHCPEPreIADM(PADM)),"^",26) //就诊科室
	s gID=$P($g(^DHCPEPreIADM(PADM)),"^",2)
	s HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID)
	
	s OrderStr=""
	i CRMOrder'="" d
	.s stat=$P($g(^DHCPEPreIADM(+CRMOrder,"ORDITEM",$P(CRMOrder,"||",2))),"^",16)
	.q:stat'="1"
	.s arcimID=$P($g(^DHCPEPreIADM(+CRMOrder,"ORDITEM",$P(CRMOrder,"||",2))),"^",1)
	.s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",CRMOrder,0))
	.q:CRMORowId=""
	.s OEOrdItemID=$p($g(^DHCPECRMO(CRMORowId)),"^",1) 
	.q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEOrdItemID))  //谢绝检查
	.;q:(gID'="")&&($G(^DHCPECTDataEx("DHCPEStationOrder","GroupPrint",arcimID))'="1")
	.;s tempName=$g(^DHCPECTDataEx("DHCPEStationOrder","TempName",arcimID))
	.s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcimID,LocID)
	.q:OrderID=""
	.s OrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,OrderID,0))
	.s tempName=$lg($g(^CF.PE.StationOrderSetD(OrderSetID)),18)  //检查申请单名称
	.q:tempName=""
	.s recLocID=$P($g(^DHCPEPreIADM(+CRMOrder,"ORDITEM",$P(CRMOrder,"||",2))),"^",17)
	.i recLocID'="" s recLoc=$P(^CTLOC(recLocID),"^",2),CTLocAddress=$g(^CTLOC(recLocID,"ADDR",1))
	.i $L(recLoc,"-")>1 s recLoc=$P(recLoc,"-",2)
	.s arcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(arcimID,"A",LocID)
	.s docName=$P($g(^DHCPEPreIADM(+CRMOrder,"ORDITEM",$P(CRMOrder,"||",2))),"^",11)
	.i docName'="" s docName=$P($g(^SSU("SSUSR",docName)),"^",2)
	.s price=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(CRMOrder,"","")
	
	.s RisNoteArr=##class(web.DHCPE.RisRequestPrint).GetRisNoteListArr(arcimID,HospID) //获取医嘱项的注意事项
	.;s RisNoteArr1=$p(RisNoteArr,"<br>",1)
	.;s RisNoteArr2=$p(RisNoteArr,"<br>",2)
	.;s RisNoteArr3=$p(RisNoteArr,"<br>",3)
	.;s RisNoteArr4=$p(RisNoteArr,"<br>",4)
	.s RisNoteArr1=$e(RisNoteArr,1,48)
	.s RisNoteArr2=$e(RisNoteArr,49,97)
	.s RisNoteArr3=$e(RisNoteArr,98,146)
	.s RisNoteArr4=$e(RisNoteArr,147,200)
	.s OrderStr=tempName_"^"_arcimDesc_"(总"_price_"元)"_"^"_recLoc_"^"_arcimDesc_"(总"_price_"元)"_"^"_docName_"^"_CTLocAddress_"^"_RisNoteArr1_"^"_RisNoteArr2_"^"_RisNoteArr3_"^"_RisNoteArr4
	
	e  d
	.k ^TempDHCPERisRequest(PADM)
	.s sub="" 
	.f  s sub=$O(^DHCPEPreIADM(PADM,"ORDITEM",sub)) q:sub=""  d
	..s stat=$P($g(^DHCPEPreIADM(PADM,"ORDITEM",sub)),"^",16)
	..q:stat'="1"
	..s arcimID=$P($g(^DHCPEPreIADM(PADM,"ORDITEM",sub)),"^",1)
	..;q:(gID'="")&&($G(^DHCPECTDataEx("DHCPEStationOrder","GroupPrint",arcimID))'="1")
	..;s tempName=$G(^DHCPECTDataEx("DHCPEStationOrder","TempName",arcimID))
	..s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcimID,LocID)
	..q:OrderID=""
	..s OrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,OrderID,0))
	..s tempName=$lg($g(^CF.PE.StationOrderSetD(OrderSetID)),18)  //检查申请单名称
	..q:tempName=""
	..;s PrintType=+$G(^DHCPECTDataEx("DHCPEStationOrder","RequestPrintType",arcimID)) //是否合并打印
	..s PrintType=$lg($g(^CF.PE.StationOrderSetD(OrderSetID)),42)  //是否合并打印
	..s recLocID=$P($g(^DHCPEPreIADM(PADM,"ORDITEM",sub)),"^",17)
	..i recLocID'="" s recLoc=$P($g(^CTLOC(recLocID)),"^",2),CTLocAddress=$g(^CTLOC(recLocID,"ADDR",1))
	..i $L(recLoc,"-")>1 s recLoc=$P(recLoc,"-",2)
	..s arcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(arcimID,"A",LocID)
	..s docName=$P($g(^DHCPEPreIADM(PADM,"ORDITEM",sub)),"^",11)
	..i docName'="" s docName=$P($g(^SSU("SSUSR",docName)),"^",2)
	..s price=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PADM_"||"_sub,"","")
	..s RisNoteArr=##class(web.DHCPE.RisRequestPrint).GetRisNoteListArr(arcimID,HospID) //获取医嘱项的注意事项
	..;s RisNoteArr1=$p(RisNoteArr,"<br>",1)
	..;s RisNoteArr2=$p(RisNoteArr,"<br>",2)
	..;s RisNoteArr3=$p(RisNoteArr,"<br>",3)
	..;s RisNoteArr4=$p(RisNoteArr,"<br>",4)
	..s RisNoteArr1=$e(RisNoteArr,1,48)
	..s RisNoteArr2=$e(RisNoteArr,49,97)
	..s RisNoteArr3=$e(RisNoteArr,98,146)
	..s RisNoteArr4=$e(RisNoteArr,147,200)
	..s ^TempDHCPERisRequest(PADM,recLoc,tempName,PrintType,arcimID)=tempName_"^"_arcimDesc_"^^"_"^"_recLoc_"^"_arcimDesc_"(总"_price_"元)"_"^"_docName_"^"_price_"元"_"^"_CTLocAddress_"^"_RisNoteArr1_"^"_RisNoteArr2_"^"_RisNoteArr3_"^"_RisNoteArr4
	.s recLoc=0
	.f  s recLoc=$O(^TempDHCPERisRequest(PADM,recLoc)) q:recLoc=""  d
	..s tempName=""
	..f  s tempName=$O(^TempDHCPERisRequest(PADM,recLoc,tempName)) q:tempName=""  d
	...s PrintType=""
	...f  s PrintType=$O(^TempDHCPERisRequest(PADM,recLoc,tempName,PrintType)) q:PrintType=""  d
	....s oneOrder=""
	....s i=3
	....s arcimID=""
	....f  s arcimID=$O(^TempDHCPERisRequest(PADM,recLoc,tempName,PrintType,arcimID)) q:arcimID=""  d
	.....s OneInfo=$G(^TempDHCPERisRequest(PADM,recLoc,tempName,PrintType,arcimID))
	.....i PrintType="N" d  //不合并打印
	......i OrderStr="" d
	.......s OrderStr=OneInfo
	......e  d
	.......s OrderStr=OrderStr_$C(2)_OneInfo
	.....e  d //合并打印
	......i oneOrder="" d
	.......s oneOrder=OneInfo
	......e  d
	.......s $P(oneOrder,"^",i)=$P(OneInfo,"^",2)
	.......s i=i+1
	....i PrintType="Y" d
	.....i OrderStr="" d
	......s OrderStr=oneOrder
	.....e  d
	......s OrderStr=OrderStr_$C(2)_oneOrder
	q:OrderStr="" ""
	s patientInfo=..GetPatientInfo(PADM)
	
	//s patientParInfo="RegNo"_"^"_"CardNo"_"^"_"Name"_"^"_"Sex"_"^"_"Age"_"^"_"InLoc"_"^"_"patType"_"^"_"address"_"^"_"TelNo"_"^"_"AppDate"_"^"_"HopeDate"_"^"_"Code"_"^"_"Married"_"^"_"Componey"_"^"_"Vocation"_"^"_"Nation"_"^"_"PEFlag"
	//s ParInfo=patientParInfo_"^"_"purpose"_"^PEArcDesc2^PEArcDesc3^PEArcDesc4^PEArcDesc5"_"^"_"RecLoc"_"^"_"ordNameAndPrice"_"^"_"AppDoc"_"^"_"PEPrice"
	//RegNo_"^"_CardNo_"^"_Name_"^"_Sex_"^"_Age_"^"_InLoc_"^"_patType_"^"_address_"^"_TelNo_"^"_AppDate_"^"_HopeDate_"^"_Code_"^"_Married_"^"_Componey_"^"_Vocation_"^"_Nation_"^"_"体检"
	s patientParInfo="PatNo"_"^"_"CardNo"_"^"_"PatName"_"^"_"PatSex"_"^"_"PatAge"_"^"_"PatLoc"_"^"_"BillType"_"^"_"address"_"^"_"TelNo"_"^"_"arReqTime"_"^"_"HopeDate"_"^"_"Code"_"^"_"Married"_"^"_"Componey"_"^"_"Vocation"_"^"_"Nation"_"^"_"PEFlag"_"^"_"hopName"_"^"_"Barcode"
	s ParInfo=patientParInfo_"^ArcItemArr1^ArcItemArr2^ArcItemArr3"_"^"_"arRepExLoc"_"^"_"ordNameAndPrice"_"^"_"arUserCode"_"^"_"PEPrice"_"^"_"arRepExLocAdrr"_"^"_"NoteListArr1^NoteListArr2^NoteListArr3^NoteListArr4"
	
	s rStr=ParInfo_$C(1)_patientInfo_$C(1)_OrderStr
	q rStr
}

/// Debug: w ##class(web.DHCPE.RisRequestPrint).GetPatientInfo(29)
ClassMethod GetPatientInfo(PADM)
{
	s ibaseInfoID=$P($g(^DHCPEPreIADM(PADM)),"^",1)
	q:ibaseInfoID="" ""
	s LocID=$P($g(^DHCPEPreIADM(PADM)),"^",26) //就诊科室
	
	S HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID)
	S hopName=$P($g(^CT("HOSP",HospID) ),"^",2)
	s RegNo=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",1)
	s CardNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(RegNo,"R",LocID)
	s Name=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",2)
	s Sex=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",3)
	i Sex'="" s Sex=$p($g(^CT("SEX",Sex)),"^",2)
	s Age=""
	S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	i PAPMIRowId'="" s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,LocID)
	s InLoc=$P($g(^DHCPEPreIADM(PADM)),"^",26)
	s InLoc=$P($g(^CTLOC(InLoc)),"^",2)
	i $L(InLoc,"-")>1 s InLoc=$P(InLoc,"-",2)
	s patType="自费"
	s address=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",14)
	s TelNo=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",8)
	i TelNo="" s TelNo=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",6)
	i TelNo="" s TelNo=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",7)
	s AppDate=$ZD($H,3)
	s HopeDate=$ZD($H,3)
	s Code=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",13)
	
	s Married=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",17)
	i Married'="" s Married=$P($G(^CT("MAR",Married)),"^",2)
	s Componey=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",12)
	s Vocation=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",10)
	s Nation=$P($g(^DHCPEPreIBI(ibaseInfoID)),"^",15)
	
	s info=RegNo_"^"_CardNo_"^"_Name_"^"_Sex_"^"_Age_"^"_InLoc_"^"_patType_"^"_address_"^"_TelNo_"^"_AppDate_"^"_HopeDate_"^"_Code_"^"_Married_"^"_Componey_"^"_Vocation_"^"_Nation_"^"_"体检"_"^"_hopName_"^"_RegNo
	q info
}

ClassMethod PISPrintFlag(PAADM)
{
	;w ##class(web.DHCPE.RisRequestPrint).PISPrintFlag("274070")
	;0不打印  1打印
	s VIPLevel="2"
	s Flag=0
	s ARCIM="21130||1"
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	s Level=$P(^DHCPEPreIADM(PIADM),"^",18)
	//q:VIPLevel'=Level Flag
	s OEORD=$O(^OEORD(0,"Adm",PAADM,0))
	q:OEORD="" Flag
	;^OEORDi(0,"ARCIM",OEORD,ARCIM,STTDat,Sub)
	s STTDat=""
	f  s STTDat=$O(^OEORDi(0,"ARCIM",OEORD,ARCIM,STTDat)) q:(STTDat="")||(Flag=1)  d
	.s Sub=0
	.f  s Sub=$O(^OEORDi(0,"ARCIM",OEORD,ARCIM,STTDat,Sub)) q:(Sub="")||(Flag=1)  d
	..s Stat=$p($G(^OEORD(OEORD,"I",Sub,1)),"^",13)
	..q:Stat'=1
	..s Flag=1
	;s ^sxt("fff")=Flag
	q Flag
}

}
