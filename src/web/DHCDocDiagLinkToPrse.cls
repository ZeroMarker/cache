Class web.DHCDocDiagLinkToPrse Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 使用就诊查询就诊对应的处方信息
Query GetAllPrescList(EpisodeID As %String, PrescNoFind As %String = "", LogOnUser As %String = "") As %Query(ROWSPEC = "prcedesc:%String,prceno:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocDiagLinkToPrse","GetAllPrescList",63,"I200226000073",10367)
ClassMethod GetAllPrescListExecute(ByRef qHandle As %Binary, EpisodeID As %String, PrescNoFind As %String = "", LogOnUser As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set langid=..%LanguageID()
   k PrescListArr
   ;显示患者所有处方
   s LogOnUser=""
   s PrescNoStr=""
   s OEOrdRowID=+$o(^OEORD(0,"Adm",+EpisodeID,0))
   if OEOrdRowID'=0  d
   .s QUERowID=""
   .f  s QUERowID=$O(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUERowID),-1) Q:QUERowID=""  d
   ..s QUENO=$P($G(^PAQUE1(QUERowID)),"^",14)
   ..Q:QUENO=""
   ..Q:((PrescNoFind'="")&&(("^"_PrescNoFind_"^")'[("^"_QUENO_"^")))
   ..s QueAddUser=$P($G(^PAQUE1(QUERowID,"DHC")),"^",3)
   ..s PrescNo=QUENO
   ..d OutPutDataByPrescNo
   for i=1:1:$l(PrescNoFind,"^"){
	   s PrescNo=$p(PrescNoFind,"^",i)
	   continue:(PrescNo="")||($d(PrescListArr(PrescNo)))
	   s QueAddUser=""
	   d OutPutDataByPrescNo
   }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutPutDataByPrescNo
   s PHPrescType=""
   s Have="0"
   s ord=0
   f  s ord=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,ord)) q:((ord="")||(Have=1))  d
   .s Stat=$P($G(^OEORD(OEOrdRowID,"I",ord,1)),"^",13) 
   .s statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
   .s statDesc=$p($g(^OEC("OSTAT",Stat)),"^",2) 
   .s statDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",statDesc,langid)
   .s statcode=$ZCVT(statcode,"U")
   .Q:((statcode="C")||(statcode="U")||(statcode="D"))
   .s OrderDate=$p($g(^OEORD(OEOrdRowID,"I",ord,3)),"^",7)
   .s OrderTime=$p($g(^OEORD(OEOrdRowID,"I",ord,1)),"^",17)
   .s:OrderDate'="" OrderDate=..%ZD(OrderDate) //$ZD(OrderDate,3)
   .s:OrderTime'="" OrderTime=..%ZT(OrderTime,2)
   .s ARCIMRowid=$p(^OEORD(OEOrdRowID,"I",ord,1),"^",2)
   .s AddUser=$p(^OEORD(OEOrdRowID,"I",ord,7),"^",1)
   .s:AddUser="" AddUser=QueAddUser
   .Q:(LogOnUser'=AddUser)&&(LogOnUser'="")
   .if AddUser'="" Set AddUser=$P($G(^SSU("SSUSR",AddUser)),"^",2)
   .s AddUser =##class(User.SSUser).GetTranByDesc("SSUSRName",AddUser,langid)
   .s ARCIMRowid=$p(^OEORD(OEOrdRowID,"I",ord,1),"^",2)
   .s PrescType=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid)
   .if (PrescType=1){s PHPrescType="【草】"}else{s PHPrescType="【西】"}
   .s PHPrescType=##class(websys.Translation).Get("dhcdocdiagnoseselect.hui.csp",PHPrescType)
   .s Have="1"
   Q:Have=0
   s PHPrescType=##class(web.DHCDocPrescript).GetPrescTypeByPrescNum(PrescNo)
   s PHPrescType=$case(PHPrescType,1:"【西药】",2:"【中成药】",3:"【草药】",5:"【精二】",:"【西药】") //处方类型
   s PHPrescType=##class(websys.Translation).Get("dhcdocdiagnoseselect.hui.csp",PHPrescType)
   s PrescTitle=##class(web.DHCOutPhCommon).GetPrescTitle(PrescNo)
   if ((PrescTitle'="普通")&&(PrescTitle'="急诊")&&(PrescTitle'="儿科")){
	   s PrescTitle=##class(websys.Translation).Get("dhcdocdiagnoseselect.hui.csp",PrescTitle)
	   s PHPrescType="【"_PrescTitle_"】"
	   }
   s BilledStr=##class(web.DHCDocPrescript).GetBilledByPrescNo(PrescNo) //计费状态
   s BilledDesc=$P(BilledStr,"^",2)
   s BilledDesc=##class(websys.Translation).Get("dhcdocdiagnoseselect.hui.csp",BilledDesc)
   s rtnxz=..getDia(PrescNo)
   s bz=""
   s:rtnxz'="" bz="<span style='color:red;font-weight:bold;font-size:20px;'>√</span>"
   s prcedesc=bz_PHPrescType_PrescNo_" "_AddUser_" "_OrderDate_" "_OrderTime_" "_BilledDesc
   s prceno=PrescNo
   s PrescListArr(prceno)=1
   Do OutputRow1
   quit
OutputRow1
	set Data=$lb(prcedesc,prceno)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllPrescListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllPrescListExecute ]
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

ClassMethod GetAllPrescListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllPrescListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询对应处方的医嘱信息
/// d ##class(%ResultSet).RunQuery("web.DHCDocDiagLinkToPrse","FindPrseOrderList","108","I191010000010^I191011000001")
Query FindPrseOrderList(EpisodeID As %String, PrescNoStr As %String) As %Query(ROWSPEC = "orderdr:%String,OrderName:%String,statDesc:%String,UserAdd:%String,OrderDoseQty:%String,OrderDoseUOM:%String,Freq:%String,OrderDur:%String,Instruc:%String,OrderPackQty:%String,OrderPackUOM:%String,reloc:%String,OrderPrice:%String,OrderPriceAll:%String,AdmReason:%String,InsuClass:%String,poisondesc:%String,Initials:%String")
{
}

ClassMethod FindPrseOrderListExecute(ByRef qHandle As %Binary, EpisodeID As %String, PrescNoStr As %String) As %Status
{
	;s ^lxz123=EpisodeID_"^"_PrescNo
	Set repid=$I(^CacheTemp)
 	s ind=1	
 	Set langid=..%LanguageID()
 	s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
 	for i=1:1:$l(PrescNoStr,"^") d
 	.s PrescNo=$p(PrescNoStr,"^",i)
 	.s OEOrdRowID=+$o(^OEORD(0,"Adm",+EpisodeID,0))
 	.if (OEOrdRowID'="")&&(PrescNo'="")  d
 	..s QUERowID=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
	..s ord=0
	..f  s ord=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,ord)) q:(ord="")  d
	...s Stat=$P($G(^OEORD(OEOrdRowID,"I",ord,1)),"^",13) 
	...s statcode="V"
	...i Stat'="" d
	...s statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
	...s statDesc=$p($g(^OEC("OSTAT",Stat)),"^",2) ;医嘱状态
	...s statDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",statDesc,langid)
	...s statcode=$ZCVT(statcode,"U")
	...Q:((statcode="C")||(statcode="U")||(statcode="D"))
	...s OrderDate=$p($g(^OEORD(OEOrdRowID,"I",ord,3)),"^",7)
	...s OrderTime=$p($g(^OEORD(OEOrdRowID,"I",ord,1)),"^",17)
	...s ARCIMRowid=$p(^OEORD(OEOrdRowID,"I",ord,1),"^",2)
	...s AddUser=$p(^OEORD(OEOrdRowID,"I",ord,7),"^",1) 
	...s PHPrescType=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid)
    ...if ((PHPrescType=1)&&(AddUser="")&&(QUERowID'="")) d
    ....s AddUser=$P(^PAQUE1(QUERowID,"DHC"),"^",3)
    ...
	...s UserAdd="" ;下医嘱人
	...s Initials=""
	...if AddUser'="" Set UserAdd=$P($G(^SSU("SSUSR",AddUser)),"^",2) s Initials=$P($G(^SSU("SSUSR",AddUser)),"^",1)
	...s UserAdd =##class(User.SSUser).GetTranByDesc("SSUSRName",UserAdd,langid)
	...s ArcimID=$P($G(^OEORD(OEOrdRowID,"I",ord,1)),"^",2)
	...s OrderName=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",2) ;医嘱名称
	...s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
	...s ItemCatDR=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
	...s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	...s OrderDoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEOrdRowID_"||"_ord) //$P($G(^OEORD(OEOrdRowID,"I",ord,2)),"^",1) ;单次剂量
	...s OrderDoseQty=##class(web.DHCDocOrderView).formateNum(OrderDoseQty)
	...s OrderDoseUOMRowid=$P($G(^OEORD(OEOrdRowID,"I",ord,2)),"^",3)
	...s OrderDoseUOM="",WeekFlag="N"
	...s:OrderDoseUOMRowid'="" OrderDoseUOM=$P(^CT("UOM",OrderDoseUOMRowid),"^",2) ;单次剂量单位
	...s OrderDoseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderDoseUOM,langid)
	...s PackQty=$p($g(^OEORD(+OEOrdRowID,"I",ord,9)),"^",4)
	...s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OEOrdRowID_"||"_ord)
	...s OrderFreqRowid=$List(OrdFreqInfo,1)
	...s Freq=$List(OrdFreqInfo,2)
	...//s OrderFreqRowid=$P($G(^OEORD(OEOrdRowID,"I",ord,2)),"^",4) s Freq="" ;频次
	...//s:OrderFreqRowid'="" Freq=$P(^PHCFR(OrderFreqRowid),"^",3),WeekFlag=$P(^PHCFR(OrderFreqRowid),"^",9)
	...//i WeekFlag="Y" d
	...//.s OrderFreqWeek=$p($g(^OEORD(OEOrdRowID,"I",ord,"DHC")),"^",55)
	...//.s Freq=Freq_"-"_$TR(OrderFreqWeek,"|","")
	...s OrderInstrRowid=$P($G(^OEORD(OEOrdRowID,"I",ord,2)),"^",7)
	...s Instruc=""
	...s:OrderInstrRowid'="" Instruc=$p(^PHCIN(OrderInstrRowid),"^",1) ;用法
	...s Instruc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",Instruc,langid)
	...s OrderDurRowid=$P($G(^OEORD(OEOrdRowID,"I",ord,2)),"^",6) s OrderDur="" ;疗程
	...s:OrderDurRowid'="" OrderDur=$P(^PHCDU(OrderDurRowid),"^",3)
	...s OrderDur=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",OrderDur,langid)
	...s OrdPackQtyInfo=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OEOrdRowID_"||"_ord)
	...if (OrderType="R")&&(PackQty="") d
	....s OrderPackUOM=$p(OrdPackQtyInfo,"^",5)
	....s OrderPackQty=$p(OrdPackQtyInfo,"^",4) 
	...e  d
	....s OrderPackUOM=$p(OrdPackQtyInfo,"^",2)
	....s OrderPackQty=$p(OrdPackQtyInfo,"^",1) 
	...s OrderPackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderPackUOM,langid)
	...s OrderRecDepRowid=$P($G(^OEORD(OEOrdRowID,"I",ord,3)),"^",6)
	...s reloc=""
	...s:OrderRecDepRowid'="" reloc=$P($G(^CTLOC(OrderRecDepRowid)),"^",2) ;接收科室
	...s reloc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",reloc,langid)
	...//s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", "", ArcimID, OrderDate, "", "", "", "",OrderRecDepRowid,"","","")
	...//s OrderPrice=$P(retPrice,"^",1) //单价
	...s OrderPrice=##class(web.DHCDocOrderCommon).GetOEORIPrice(OEOrdRowID_"||"_ord)
	...s OrderPrice=$fn($p(OrderPrice,"^",1),"",4)
	...s ordermesage=##class(web.DHCDocOrderCommon).GetOrderMesage(OEOrdRowID_"||"_ord)
	...s OrderPriceAll=$P(ordermesage,"^",3) //总价
	...s:OrderDate'="" OrderDate=$ZD(OrderDate,3)
	...s:OrderTime'="" OrderTime=..%ZT(OrderTime,2)
	...s AdmReasonDr=$p($g(^OEORD(OEOrdRowID,"I",ord,11)),"^",18) s AdmReason="" //费别
	...s:AdmReasonDr'="" AdmReason=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	...s AdmReason=##class(User.PACAdmReason).GetTranByDesc("READesc",AdmReason,langid)
	...s InsuClass="" //医保类别
	...//s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(ArcimID,AdmReasonDr,AdmDepHospId)
	...s InsuClass=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ArcimID,AdmReasonDr,AdmDepHospId,"",6)
	...s poisondesc=""
	...s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimID)
	...s prescpoisondr=+$p($G(^PHCD(+DrgformRowid,$P(DrgformRowid,"||",2))),"^",4)
	...s:prescpoisondr'="" poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
	...s poisondesc=##class(User.PHCPoison).GetTranByDesc("PHCPODesc",poisondesc,langid)
	...s orderdr=OEOrdRowID_"||"_ord
	...Do OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(orderdr,OrderName,statDesc,UserAdd,OrderDoseQty,OrderDoseUOM,Freq,OrderDur,Instruc,OrderPackQty,OrderPackUOM,reloc,OrderPrice,OrderPriceAll,AdmReason,InsuClass,poisondesc,Initials)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPrseOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPrseOrderListExecute ]
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

ClassMethod FindPrseOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPrseOrderListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocDiagLinkToPrse","GetDiaQuery","3","1")
Query GetDiaQuery(Adm As %String, Type As %String) As %Query(ROWSPEC = "desc:%String,diaid:%String")
{
}

ClassMethod GetDiaQueryExecute(ByRef qHandle As %Binary, Adm As %String, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s diastr=##class(web.DHCDocDiagLinkToPrse).GetAdmICDList(Adm)
 	if (Type=1){
	 	s dia=$P(diastr,$C(1),1)
	}elseif(Type=2){
		s dia=$P(diastr,$C(1),2)
	}else{
		s dia=diastr
	}
	for i=1:1:$l(dia,$C(1)) {
		s oneDia=$p(dia,$C(1),i)
		for k=1:1:$L(oneDia,"!") {
			s one=$P(oneDia,"!",k)
		 	continue:one=""
		 	s desc=$P(one,"^",1)
		 	s diaid=$P(one,"^",2)
			Do OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(desc,diaid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDiaQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiaQueryExecute ]
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

ClassMethod GetDiaQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiaQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取所选就诊的所有ICD诊断
/// w ##class(web.DHCDocDiagLinkToPrse).GetAdmICDList(3)
ClassMethod GetAdmICDList(Adm) As %String
{
	Q:Adm="" ""
	s MradmRowid=$P(^PAADM(Adm),"^",61)
	k temp1
	k temp2
	s num=0
	s MrICDSub=0  f  s MrICDSub=$o(^MR(MradmRowid,"DIA",MrICDSub)) q:MrICDSub=""  d
	.s DiagType=##class(DHCDoc.Diagnos.Common).GetDiagnosCat(MradmRowid_"||"_MrICDSub,"N")
	.if DiagType="西医" d
	..s temp1($I(temp1))=MradmRowid_"||"_MrICDSub
	.else  if DiagType="中医" d
	..s temp2($I(temp2),"Main")=MradmRowid_"||"_MrICDSub
	.else  if DiagType="证型" d
	..s sub23=$I(temp2(num,"Main",0))
	..s num=$O(temp2(""),-1)
	..i num>0 s temp2(num,"Main",$I(temp2(num,"Main",0)))=MradmRowid_"||"_MrICDSub
	
	;找到主诊断
	s xydia=""
	s sub1=0
	f  s sub1=$O(temp1(sub1)) Q:sub1=""  d
	.s merowid=$G(temp1(sub1))
	.Q:merowid=""
	.s desc=$$getdiadesc(merowid)
	.Q:desc=""
	.if xydia=""  d
	..s xydia=desc_"^"_merowid
	.else  d
	..s xydia=xydia_"!"_desc_"^"_merowid
	s zydia=""
	s sub2=0
	f  s sub2=$O(temp2(sub2)) Q:sub2=""  d
	.s merowid=$G(temp2(sub2,"Main"))
	.s mdesc=$$getdiadesc(merowid)
	.Q:mdesc=""
	.s qtdesc=""
	.s qtid=""
	.s sub3=0
	.f  s sub3=$O(temp2(sub2,"Main",sub3)) Q:sub3=""  d
	..s merowidbz=$G(temp2(sub2,"Main",sub3))
	..s otherdesc=$$getdiadesc(merowidbz)
	..Q:otherdesc=""
	..if qtdesc=""  d
	...s qtdesc=otherdesc
	...s qtid=merowidbz
	..else  d
	...s qtdesc=qtdesc_","_otherdesc
	...s qtid=qtid_"$"_merowidbz
	.if qtdesc'=""  d
	..s qtdesc="("_qtdesc_")"
	.s mdesc=mdesc_qtdesc
	.if qtid'=""  d
	..s merowid=merowid_"$"_qtid
	.
	.if zydia=""  d
	..s zydia=mdesc_"^"_merowid
	.else  d
	..s zydia=zydia_"!"_mdesc_"^"_merowid
	Q xydia_$C(1)_zydia
	
getdiadesc(merowid)
	Q ##class(DHCDoc.Diagnos.Common).GetDiagDesc(merowid,"Y")
}

/// 插入诊断信息
ClassMethod Insert(PrescNoStr, DiagIdStr, UserDr) As %String
{
	s Active="Y"
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	s NotValue="N"
	s err=0
	s rtn=..CheckUpdateBefore(PrescNoStr,DiagIdStr)
	if rtn'="" q rtn
	TS
	for i=1:1:$l(PrescNoStr,"^"){
		s PrescNum=$p(PrescNoStr,"^",i)
		&sql(Update SQLUSER.DHCDocDiagLinkToPrse set Active=:NotValue where PrescNum=:PrescNum)
		if (SQLCODE<0) s err=SQLCODE Q
		&sql(insert into SQLUSER.DHCDocDiagLinkToPrse
	        (PrescNum,DiagList,IsertDate,IsertTime,IsertUser,Active) values(:PrescNum,:DiagIdStr,:NowDate,:NowTime,:UserDr,:Active)
        )
        if (SQLCODE<0) s err=SQLCODE Q
	}
	i err TRo  Q err
	TC
	Q 0
}

/// 获取处方对应的诊断信息
/// 西医诊断ID1^西医诊断ID1...$C(1)中医诊断ID1_"$"_..^中医诊断ID1_"$"_..
/// w ##class(web.DHCDocDiagLinkToPrse).getDia("I210918000005")
ClassMethod getDia(PrescNoStr) As %String
{
	Q:PrescNoStr="" ""
	s diagData=""
	s activeflag="Y"
	for i=1:1:$l(PrescNoStr,"^"){
		s PrescNum=$p(PrescNoStr,"^",i)
		&SQL(select DiagList into :DiagList from SQLUSER.DHCDocDiagLinkToPrse where PrescNum=:PrescNum and Active=:activeflag)
		continue:SQLCODE=100
		i diagData="" s diagData=DiagList
		else  s diagData=diagData_"^"_DiagList
	}
	s rtnDia=""
	;验证如果诊断删除只返回有效地诊断
	f i=1:1:$L(diagData,"^")  d
	.s onediastr=$P(diagData,"^",i)
	.Q:onediastr=""
	.s onediaid=""
	.f k=1:1:$l(onediastr,"$") d
	..s diaid=$P(onediastr,"$",k)
	..Q:diaid=""
	..Q:'$D(^MR(+diaid,"DIA",$P(diaid,"||",2)))
	..i onediaid="" s onediaid=diaid
	..e  s onediaid=onediaid_"$"_diaid
	.if rtnDia="" s rtnDia=onediaid
	.else  s rtnDia=rtnDia_"^"_onediaid
	q rtnDia
}

/// 判断处方对应的诊断是否需要选择诊断
/// 入参:AdmDr 就诊ID PrescNum 处方号
/// return: 0 不需要进行处方诊断的选择  1 需要进行处方诊断的选择
/// 
ClassMethod PrescNumDiaCheck(AdmDr, PrescNum) As %String
{
	s diartn=..GetAdmICDList(AdmDr)
	s xyzd=$P(diartn,$C(1),1)
	s zydia=$P(diartn,$C(1),2)
	s diaxynum=0
	if xyzd'=""  d
	.s diaxynum=$L(xyzd,"!")
	s diazynum=0
	if zydia'=""  d
	.s diazynum=$L(zydia,"!")
	s numall=diaxynum+diazynum
	
	;当前患者有效诊断小于10条不需要进行处方诊断选择
	Q:numall<10 0 
	
	;没有处方信息的只判断就诊
	Q:PrescNum="" 1
	
	;判断处方已经选择的诊断
	s rtn=..getDia(PrescNum) 
	Q:rtn="" 1
	s xys=$P(rtn,$C(1),1)
	s zys=$P(rtn,$C(1),2)
	
	;西药处方判断是否选择了对应的西医诊断
	s PHPrescType=##class(web.DHCDocPrescript).GetPrescTypeByPrescNum(PrescNum)
	if (PHPrescType'=3){
		Q:xys="" 1 ;没有选择有效地西药诊断
	}
	
	;草药未有有效地中医诊断
	if (PHPrescType=3){
		Q:zys="" 1 ;没有选择有效地其他诊断
	}
	
	;没有选择的进行判断
	Q:((xys="")&&(zys="")) 1
	
	q 0
}

/// 根据患者就诊获取所有需要选择诊断的处方
/// w ##class(web.DHCDocDiagLinkToPrse).getAllCheckDiaPrce(108,10209,"309||1*103||1061*V^10051||1*103||1062*V^309||1*103||1063*V^10051||1*103||1064*V^")
ClassMethod getAllCheckDiaPrce(AdmDr, LogOnUser, OEOrdItemIDs As %String = "") As %String
{
	s ^tempscl("getAllCheckDiaPrce")=AdmDr_","_LogOnUser_","_OEOrdItemIDs
	s PrescNoStr=""
	if (OEOrdItemIDs'=""){
	   s OrderLen=$L(OEOrdItemIDs,"^")
	   f i=1:1:OrderLen 
	   {
		   s OneOrderStr=$P(OEOrdItemIDs,"^",i)
		   s OrderIDGet=$P(OneOrderStr,"*",2)
		   continue:OrderIDGet=""
		   s PrescNo=$P($G(^OEORD(+OrderIDGet,"I",$p(OrderIDGet,"||",2),1)),"^",14) 
		   continue:PrescNo=""
		   s AddUser=$P($G(^OEORD(+OrderIDGet,"I",$p(OrderIDGet,"||",2),7)),"^",1) 
		   continue:(LogOnUser'=AddUser)&&(LogOnUser'="")
		   continue:(..IsPrescNoNeedLinkDiag(PrescNo)=0)
		   if PrescNoStr=""  s PrescNoStr=PrescNo
   		   else  i ("^"_PrescNoStr_"^")'[("^"_PrescNo_"^") s PrescNoStr=PrescNoStr_"^"_PrescNo
	   }
	   Q PrescNoStr
   }
   s OEOrdRowID=+$o(^OEORD(0,"Adm",+AdmDr,0))
   if OEOrdRowID'=0  d
   .s QUERowID=""
   .f  s QUERowID=$O(^PAQUE1(0,"QUE1_PAADM_DR",AdmDr,QUERowID),-1) Q:QUERowID=""  d
   ..s QUENO=$P($G(^PAQUE1(QUERowID)),"^",14)
   ..Q:QUENO=""
   ..s QueAddUser=$P($G(^PAQUE1(QUERowID,"DHC")),"^",3)
   ..s PrescNo=QUENO
   ..s PHPrescType=""
   ..s Have="0"
   ..s ord=0
   ..f  s ord=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,ord)) q:((ord="")||(Have=1))  d
   ...s Stat=$P($G(^OEORD(OEOrdRowID,"I",ord,1)),"^",13) 
   ...s statcode="V"
   ...
   ...i Stat'="" d
   ...s statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
   ...s statDesc=$p($g(^OEC("OSTAT",Stat)),"^",2) 
   ...s statcode=$ZCVT(statcode,"U")
   ...Q:((statcode="C")||(statcode="U")||(statcode="D"))
   ...s OrderDate=$p($g(^OEORD(OEOrdRowID,"I",ord,3)),"^",7)
   ...s OrderTime=$p($g(^OEORD(OEOrdRowID,"I",ord,1)),"^",17)
   ...s:OrderDate'="" OrderDate=$ZD(OrderDate,3)
   ...s:OrderTime'="" OrderTime=..%ZT(OrderTime,2)
   ...s ARCIMRowid=$p(^OEORD(OEOrdRowID,"I",ord,1),"^",2)
   ...s AddUser=$p(^OEORD(OEOrdRowID,"I",ord,7),"^",1)
   ...s:AddUser="" AddUser=QueAddUser
   ...Q:(LogOnUser'=AddUser)&&(LogOnUser'="")
   ...Q:(..IsOrdNeedLinkDiag(OEOrdRowID_"||"_ord)=0)
   ...if AddUser'="" Set AddUser=$P($G(^SSU("SSUSR",AddUser)),"^",2)
   ...s ARCIMRowid=$p(^OEORD(OEOrdRowID,"I",ord,1),"^",2)
   ...s PrescType=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid)
   ...if (PrescType=1){s PHPrescType="【草】"}else{s PHPrescType="【西】"}
   ...
   ...s Have="1"
   ..Q:Have=0
   ..s rtnflag=..PrescNumDiaCheck(AdmDr,PrescNo)
   ..Q:rtnflag'=1
   ..if PrescNoStr=""  s PrescNoStr=PrescNo
   ..else  s PrescNoStr=PrescNoStr_"^"_PrescNo
   q PrescNoStr
}

/// 判断处方是否需要关联诊断
/// 1 需要 0 不需要
ClassMethod IsPrescNoNeedLinkDiag(PrescNo As %String) As %String
{
	s rtn=0
	s OEORDRowId=0
	for {
		s OEORDRowId=$o(^OEORD(0,"PrescNo",PrescNo,OEORDRowId)) Q:(OEORDRowId="")||(rtn=1)
		s OEORIChildsub=0
		for {
			s OEORIChildsub=$o(^OEORD(0,"PrescNo",PrescNo,OEORDRowId,OEORIChildsub)) Q:(OEORIChildsub="")||(rtn=1)
			s rtn=..IsOrdNeedLinkDiag(OEORDRowId_"||"_OEORIChildsub)
		}
	}
	Q rtn
}

/// 判断医嘱是否需要关联诊断
/// 1 需要 0 不需要
ClassMethod IsOrdNeedLinkDiag(OEORIRowId As %String) As %String
{
	s HospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_HospId
	s EpisodeID=$p(^OEORD(+OEORIRowId),"^",1)
	s StayStatus=0
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (AdmType="E") {
		s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	}
	s SplitPrescTypeDetails=##Class(web.DHCDocPrescript).GetSplitPrescTypeDetails(EpisodeID,"",OEORIRowId)
	Q:SplitPrescTypeDetails="" 0
	s PrescCode=$p(SplitPrescTypeDetails,"^",1)
	Q:PrescCode="" 0
	s PrescNoLinkDiag=$G(^DHCDocConfig(HospCodeNode,"SplitPrescType",PrescCode,"PrescNoLinkDiag"))
	s OPLinkDiag=$p(PrescNoLinkDiag,"^",1)
	s EPLinkDiag=$p(PrescNoLinkDiag,"^",2)
	s IPOneAndOutLinkDiag=$p(PrescNoLinkDiag,"^",3)
	s IPNotOneAndOutLinkDiag=$p(PrescNoLinkDiag,"^",4)
	Q:(OPLinkDiag=1)&&((AdmType="O")||((AdmType="E")&&(" 1 2 "'[(" "_StayStatus_" ")))) 1
	Q:(EPLinkDiag=1)&&((AdmType="E")&&(" 1 2 "[(" "_StayStatus_" "))) 1
	s PriorityDR=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",8)
	s PriorityCode=$P(^OECPR(PriorityDR),"^",1)
	Q:((PriorityCode="ONE")||(PriorityCode="OUT"))&&(IPOneAndOutLinkDiag=1)&&(AdmType="I") 1
	Q:((PriorityCode'="ONE")&&(PriorityCode'="OUT"))&&(IPNotOneAndOutLinkDiag=1)&&(AdmType="I") 1
	Q 0
}

/// 判断是不是处方内的诊断
/// input 就诊ID,处方号,诊断ID 
/// Y 是处方诊断 N 不是处方诊断
/// 
ClassMethod IsSelectDia(AdmDr, PrescNum, diaDr) As %String
{
	
	Q:PrescNum="" "Y"
	s rtn=..getDia(PrescNum)
	Q:rtn="" "Y"
	s xys=$P(rtn,$C(1),1)
	s zys=$P(rtn,$C(1),2)
	s rtn="N" 
	if xys'=""  d
	.if ("^"_xys_"^")[("^"_diaDr_"^")  d
	..s rtn="Y"
	q:rtn="Y" rtn
	if zys'=""  d
	.for ione=1:1:$L(zys,"^")  d
	..s onedia=$P(zys,"^",ione)
	..Q:onedia=""
	..if ("$"_onedia_"$")[("$"_diaDr_"$")  d
	...s rtn="Y"
	q rtn
}

/// 处方打印获取处方关联诊断
/// 入参：PrescNo 处方号、MRAdmRowid (mr_adm 表ID)、DelimStr 分隔符、Type 类型
/// w ##class(web.DHCDocDiagLinkToPrse).GetMRDiagnosDesc("I210918000005",",")
ClassMethod GetMRDiagnosDesc(PrescNo As %String, DelimStr As %String, Type As %String = "") As %String
{
	Q:PrescNo="" ""
	s OrdId=$o(^OEORD(0,"PrescNo",PrescNo,""))
	s AdmDr=$p(^OEORD(OrdId),"^",1)
	s MRAdmRowid=$p(^PAADM(AdmDr),"^",61)
	Q:MRAdmRowid="" ""
	s PrescNoLinkDiagStr=""
	s PrescNoNeedLinkFlag=..IsPrescNoNeedLinkDiag(PrescNo)
	//需要关联诊断,取诊断关联表
	if (PrescNoNeedLinkFlag=1) {
		s PrescNoLinkDiagStr=##class(web.DHCDocDiagLinkToPrse).getDia(PrescNo)
		Q:PrescNoLinkDiagStr="" ""
		s PrescNoLinkDiagStr=$tr(PrescNoLinkDiagStr,"$","^")
	}
	k TempArr("GetMRDiagnosDesc",$j)
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.Q:(PrescNoNeedLinkFlag=1)&&(("^"_PrescNoLinkDiagStr_"^")'[("^"_Rowid_"^"))
	.s DiagnosCat=##class(DHCDoc.Interface.Inside.ServiceDiag).GetDiagnosCat(Rowid)
	.q:(Type="GC")&&(DiagnosCat="西医")  				;中医诊断
	.q:(Type="GX")&&(DiagnosCat'="西医")  				;西医诊断
	.q:(Type="ZX")&&(DiagnosCat'="证型")  				;证型 
	
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.s:DiagnosNumber="" DiagnosNumber=9999
	.s TempArr("GetMRDiagnosDesc",$j,DiagnosNumber,$P(Rowid,"||",2))=Rowid
	d obj.Close()
	s DiagnosNumber=0  f  {
		s DiagnosNumber=$O(TempArr("GetMRDiagnosDesc",$j,DiagnosNumber)) 
		Q:DiagnosNumber=""  d
		s Temprowid=0 f {
			s Temprowid=$O(TempArr("GetMRDiagnosDesc",$j,DiagnosNumber,Temprowid))
			q:Temprowid=""
			s Rowid=$G(TempArr("GetMRDiagnosDesc",$j,DiagnosNumber,Temprowid))
			//w !,Rowid
			s DiagnosCat=##class(DHCDoc.Interface.Inside.ServiceDiag).GetDiagnosCat(Rowid)
			s Desc=##class(DHCDoc.Interface.Inside.ServiceDiag).GetDiagDesc(Rowid,"Y")
			i retval="" d
			.s retval=Desc
			e  d
			.s retval=$s(DiagnosCat="证型":retval_" "_Desc,1:retval_DelimStr_Desc)
		}
	}
	k TempArr("GetMRDiagnosDesc",$j)
	
	Q retval
}

/// w ##class("web.DHCDocDiagLinkToPrse").CheckUpdateBefore("O201030000003","2807||1^2807||2")
ClassMethod CheckUpdateBefore(PrescNoStr, DiagIdStr) As %String
{
	s msg=""
	s DiagIdStrLength=$L(DiagIdStr,"^")
	for i=1:1:$l(PrescNoStr,"^"){
		s PrescNo=$p(PrescNoStr,"^",i)
		continue:PrescNo=""
		s OEOrdRowID=$o(^OEORD(0,"PrescNo",PrescNo,0))
		continue:OEOrdRowID=""
		s EpisodeID=$p(^OEORD(+OEOrdRowID),"^",1)
		s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
		s PrescCode=##class(web.DHCDocPrescript).GetPrescTypeByPrescNo(PrescNo,AdmHospitalId)
		continue:PrescCode=""
		s HospCodeNode="HospDr_"_AdmHospitalId
		s PrescNoLinkDiag=$G(^DHCDocConfig(HospCodeNode,"SplitPrescType",PrescCode,"PrescNoLinkDiag"))
		s PrescNoLimitDiag=$P(PrescNoLinkDiag,"^",5)
		if (PrescNoLimitDiag="")  s PrescNoLimitDiag=999
		if (DiagIdStrLength>PrescNoLimitDiag){
			s msg=..%Translate("dhcdocdiagnoseselect.hui.csp","关联诊断超过最大限制")_PrescNoLimitDiag_..%Translate("dhcdocdiagnoseselect.hui.csp","个")
		}
	}
	Q msg
}

/// 返回N 表示存在未关联的诊断处方界面保留 Y 即不存在关闭界面
ClassMethod CheckSaveAfterCloseDia(PrescNoStr) As %String
{
	s CloseDiaFlag="Y"
	for i=1:1:$l(PrescNoStr,"^") d
	.q:CloseDiaFlag="N"
 	.s PrescNo=$p(PrescNoStr,"^",i)
 	.s ID=""
 	.q:PrescNo="" 
 	.s ID=$O(^User.DHCDocDiagLinkToPrseI("Presc",PrescNo,""))
 	.i ID="" s CloseDiaFlag="N"
 	q CloseDiaFlag
}

}
