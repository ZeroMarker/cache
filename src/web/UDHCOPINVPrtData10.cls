Class web.UDHCOPINVPrtData10 Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 133;

/// /厦门医院
/// /打印记帐(折扣)与患者自付金额
/// /增加急诊打印明细
ClassMethod GetOPPrtData(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String, PrtFlag As %String) As %String
{
	;;w ##class(web.UDHCOPINVPrtData).GetOPPrtData("","6157","UseID","现金","INVPrtFlag2007")
	Quit:$g(InvRowID)="" ""
	;$p(^DHCINVPRT(InvRowID),"^",
	s SelectPrtDr=InvRowID
	
	Set PatDr=$p(^DHCINVPRT(SelectPrtDr),"^",15)
	;Set PatDr=$p(^PAADM(PAADMRID),"^",1)
	Quit:$g(PatDr)="" ""
	Set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	Set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	Set Date=$p(^DHCINVPRT(SelectPrtDr),"^",5)
	s myInvNo=$p(^DHCINVPRT(SelectPrtDr),"^",14)
	Set DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Date"_$C(2)_$zd(Date,3)
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	s myINSDR=$p(^DHCINVPRT(SelectPrtDr),"^",9)
	s myINSCode=$p(^PAC("ADMREA",myINSDR),"^",1)
	
	s myTMPINVStr=""
	if myINSCode="医保" d
	.s myYBDesc=##Class(web.DHCINSUFacade).GetPrtInvPreFix(PatDr)			;
	.s myTMPINVStr="^"_"InvNo"_$c(2)_myYBDesc_myInvNo
	.Set patName3=$p(^PAPER(PatDr,"ALL"),"^",19)
	.set patname3="手册号:"_patName3
	.s myTMPINVStr=myTMPINVStr_"^"_"patname3"_$c(2)_patname3
	e  d
	.s myTMPINVStr="^"_"InvNo"_$c(2)_myInvNo
	
	s DetailStr=DetailStr_myTMPINVStr
	
	Kill ^TMP($ZN,$j)
	s myidx=""
	s INVLinkDr=""
	;获取中草药配制
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	s HerbIdx=0						;;草药费明细索引
	
	;Add an Index for RecLoc

	For  Set INVLinkDr=$o(^DHCBCI(0,"INV",SelectPrtDr,INVLinkDr)) Quit:INVLinkDr=""  Do
	.Set Bill=$p(^DHCBCI(INVLinkDr),"^",2)
	.Quit:'$D(^DHCPB(Bill))
	.Set Ord=0 For  Set Ord=$o(^DHCPB(Bill,"O",Ord)) Quit:Ord=""  Do
	..q:($d(^DHCPB(Bill,"O",Ord))=10)		;;zhao防止错误?
	..s Prescno=""
	..s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	..s Arcim=$p(^DHCPB(Bill,"O",Ord),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	..s recdepDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),3)),"^",6) ;接收科室
	..s loctype=$p(^CTLOC(recdepDR),"^",13) 
	..i loctype="" s loctype="Z"	;放在最后?
	..s ^TMP($ZN,$j,"PBID",loctype,recdepDR,Bill_"||"_Ord)=""		;;;Index
	..s ^TMP($ZN,$j,"PBO",Bill_"||"_Ord)=Bill_"^"_Ord_"^"_myPresNo_"^"_OrderType
	
	;
	s myLocType=""
	f  s myLocType=$o(^TMP($ZN,$j,"PBID",myLocType)) q:myLocType=""  d
	.s myRecDR=""
	.f  s myRecDR=$o(^TMP($ZN,$j,"PBID",myLocType,myRecDR)) q:myRecDR=""  d
	..s myPBORID=""
	..f  s myPBORID=$o(^TMP($ZN,$j,"PBID",myLocType,myRecDR,myPBORID)) q:myPBORID=""  d
	...;s OrdDr=$p(^DHCPB(Bill,"O",Ord),"^",3)
	...;b	;;
	...s Bill=+myPBORID
	...s Ord=$p(myPBORID,"||",2)
	...s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s myAcrim=$p(^DHCPB(Bill,"O",Ord),"^",3)		;
	...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	...;d AddDWin(myPresNo)
	...
	...s myOFFlag=##class(web.DHCOPConfig).ReadOESpPrtFlag(myAcrim)
	...i myOFFlag="F" d
	....d AddJFToDetails(Bill,Ord)
	...e  d
	....d AddToDetails(Bill,Ord)
	...Set Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) Quit:Itm=""  Do
	....Set ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....Set TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....Set DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....Set PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....Set PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....;b	;GetInvoicePrtDetail
	....Do AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	
	;b	;
		
	s prtTxtInfo=$$GetTxtInfo()
	;w prtTxtInfo,!
	
	s prtListInfo=""
	
	i PrtFlag="INVPrtFlag" d
	.s prtListInfo=$$GetDetails()
	
	i PrtFlag="INVPrtFlag2007" d
	.s prtListInfo=$$GetDetails2007()
	
	;w prtListInfo
	s prtTxtInfo=DetailStr_"^"_prtTxtInfo
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^TMP($ZN,$j)
	Quit "0"
	;
	;
AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	n (ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	Quit:$g(ItmDr)="" 
	Set ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	Quit:$g(ItmOPSubCat)=""
	Set ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	Quit:$g(ItmOPCat)=""
	s OPCatCode=$p(^DHCTarC("TOC",ItmOPCat),"^",1)
	Set OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	;b  ;在此解析成票据格式?ItmOPCat
	
	if $D(^TMP($ZN,$j,"CAT",OPCatCode)) DO
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",1)=OPCatDesc
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",2)=$p(^TMP($ZN,$j,"CAT",OPCatCode),"^",2)+TotalAmount
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",3)=$p(^TMP($ZN,$j,"CAT",OPCatCode),"^",3)+DiscAmount
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",4)=$p(^TMP($ZN,$j,"CAT",OPCatCode),"^",4)+PatientShare
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",5)=$p(^TMP($ZN,$j,"CAT",OPCatCode),"^",5)+PayorShare
	Else  Do
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",1)=OPCatDesc
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",2)=TotalAmount
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",3)=DiscAmount
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",4)=PatientShare
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",5)=PayorShare
	;b	;;;;
	Quit
GetTxtInfo()
	s OPCSInfo=""
	s myTxtInfo=""
	s myPatientShare=0
	s myTotSum=0
	f  s OPCSInfo=$o(^TMP($ZN,$j,"CAT",OPCSInfo)) q:OPCSInfo=""  d
	.i myTxtInfo="" d
	..s myTxtInfo=OPCSInfo_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",2),"",2)
	.e  d
	..s myTxtInfo=myTxtInfo_"^"_OPCSInfo_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",2),"",2)
	.s myPatientShare=+myPatientShare+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
	.s myTotSum=+myTotSum+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",2)
	
	;s mypayinfo="PaySum"_$C(2)_""_$fn(myPatientShare,"",2)
	s mypayinfo="PaySum"_$C(2)_""_$fn(myTotSum,"",2)
	
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myTotSum)
	s mypayinfo="PaySumPY"_$C(2)_""_myRMB
	
	i +myPatientShare'=+myTotSum d
	.s mypayinfo=mypayinfo_"^"_"PayMode"_$c(2)_PayMode_" "_$fn(myPatientShare,"",2)_" (记帐"_$fn(myTotSum-myPatientShare,"",2)_")"
	e  d
	.s mypayinfo=mypayinfo_"^"_"PayMode"_$c(2)_PayMode_" "_$fn(myPatientShare,"",2)
	
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	
	;b	;GetTxtInfo
	q myTxtInfo
AddDWin(myPresNo)
	;^DHCPHARi("PRT",{PHA_PRT_DR},{PHA_ROWID})
	;b  ;;myPresNo
	s myWinDR=""
	s myCTLoc=""
	s UseFlag=0
	q:myPresNo=""
	Q:$d(^DHCPHARi("PRT",InvRowID))=0
	f  s myWinDR=$o(^DHCPHARi("PRT",InvRowID,myWinDR)) q:myWinDR=""  d
	.;b
	.q:myPresNo'=$p($g(^DHCPHARW(myWinDR)),"^",16)
	.q:UseFlag=1
	.s myphloc=$p($g(^DHCPHARW(myWinDR)),"^",3)
	.q:myphloc=""
	.s myCTLoc=$p(^DHCPHLOC(myphloc),"^",1)
	.s myCount=+$g(^TMP($ZN,$j,"WD"))
	.f i=1:1:myCount  d
	..i $g(^TMP($ZN,$j,"WD",i))=myCTLoc  d
	...s UseFlag=1
	.;^TMP($ZN,$j,"WD")
	
	q:UseFlag=1
	q:myCTLoc=""

	s ^TMP($ZN,$j,"WD")=$g(^TMP($ZN,$j,"WD"))+1
	s Idx=$g(^TMP($ZN,$j,"WD"))
	s ^TMP($ZN,$j,"WD",Idx)=myCTLoc
	
	;s myrtn=##class(web.DHCMZYFXTYW02).GetCurrWin(myCTLoc)
	;
	;
	s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	s Idx=$g(^TMP($ZN,$j,"D"))

	s ^TMP($ZN,$j,"D",Idx)=$p(myrtn,"^",3)_"^^^^"
	quit
	;
AddJFToDetails(myBill,myOrd)
	q:'$d(^DHCPB(myBill,"O",myOrd))
	
	s ArcimRowid=$p(^DHCPB(myBill,"O",myOrd),"^",3)

	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	s:ItemCatDR'="" CatDr=$p(^ARC("IC",ItemCatDR),"^",8)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	
	;增加规格
	s myINCItmDR=""
	s myINCItmDR=$o(^INCI(0,"ARCIM_DR",+ArcimRowid, 0))
	s myINCRegu=""
	s:(myINCItmDR'="") myINCRegu=$p($g(^INCI(myINCItmDR,3)),"^",9)
	
	s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimRowid)
	
	s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2) ;名称
	s:(DrugCommonDesc'="") ArcimDesc=DrugCommonDesc_myINCRegu
	
	s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	s Idx=$g(^TMP($ZN,$j,"D"))
	s ^TMP($ZN,$j,"D",Idx)=$e($p($g(ArcimDesc),"-"),1,15)_"^"_"^"_"^"_"^"
	
	;^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub}) 
	s myPBDRowID=0
	;b		;;;AddJFToDetails
	f  s myPBDRowID=$o(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID)) q:(myPBDRowID="")  d
	.s myTarRowID=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",3)	;PBD_TARI_DR
	.q:myTarRowID=""
	.s myTarDesc=$p($g(^DHCTARI(myTarRowID)),"^",2)
	.s myUnitPrice=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",4)		;PBD_UnitPrice
	.s myUnitPrice=$fn(myUnitPrice,"",4)
	.s PackUOM=""
	.s PackQty=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",5)			;PBD_BillQty
	.s OrdTotSum=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",10)			; PBD_PatientShare
	.s OrdTotSum=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",7)		;;PBD_TotalAmount
	.s OrdTotSum=$fn(OrdTotSum,"",2)
	.s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	.s Idx=$g(^TMP($ZN,$j,"D"))
	.s myYBCode=##class(web.DHCINSUFacade).GetInusTarInfo(myTarRowID)
	.;s myLen=+$l($p(myTarDesc,"-",1))
	.s ^TMP($ZN,$j,"D",Idx)="  "_myYBCode_$e($g(myTarDesc),1,15)_"^"_myUnitPrice_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum
	.
	
	q
AddToDetails(myBill,myOrd)
	;ArcimDesc_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBOrderRowid_"^"_OrderUnitPrice_"^"_OrderBillQty_"^"_OrderSum_"^"_OrderType_"^"_Prescno_"^"_ORCATDesc_"^"_ItemGroup_"^"_loctype_"^"_bill_"^"_OrdPatShare
	;i PackQty="" s PackQty=1
	q:'$d(^DHCPB(myBill,"O",myOrd))
	
	s ArcimRowid=$p(^DHCPB(myBill,"O",myOrd),"^",3)
	
	s CatDr=""
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	s:ItemCatDR'="" CatDr=$p(^ARC("IC",ItemCatDR),"^",8)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	
	;增加规格
	s myINCItmDR=""
	s myINCItmDR=$o(^INCI(0,"ARCIM_DR",+ArcimRowid, 0))
	s myINCRegu=""
	s:(myINCItmDR'="") myINCRegu=$p($g(^INCI(myINCItmDR,3)),"^",9)
	
	s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimRowid)
	
	s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2) ;名称
	s:(DrugCommonDesc'="") ArcimDesc=DrugCommonDesc_myINCRegu
	
	s ArcimDrgFrm=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",12) ;药物形态
	s DrgType=""
	s DrgDesc=""
	i ArcimDrgFrm'="" d
	.q:(CatDr=12)
	.s DrgType=$p(^PHCD(+ArcimDrgFrm,4),"^",2)
	
	i DrgType=1 d
	.s DrgDesc="#"
	
	i DrgType=2 d
	.s DrgDesc="%"
	
	i DrgType=3 d
	.s DrgDesc="*"
	
	s PackUOMRowid=$p($g(^ARCIM(+ArcimRowid,1,8)),"^",14) ;整包装单位
	;s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	s PackUOM=""
	i PackUOMRowid'=""  d
		.s PackUOM=$p(^CT("UOM",PackUOMRowid),"^",2)
	;b	;
	s Price=$p(^DHCPB(myBill,"O",myOrd),"^",7)	
	;get the factor calculate;
	s INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))		;INC_Itm->RowID
	If INCI'="" Do 
	.Set INCIUOM=$p(^INCI(INCI,1),"^",10)   ;INC_Itm->INCI_CTUOM_DR
	.Set ConFacDr=$o(^CT("CTCF",0,"UOM",PackUOMRowid,INCIUOM,""))
	.If ConFacDr="" Set ConFac=1
	.Else  Set ConFac=$P(^CT("CTCF",ConFacDr),"^",3)
	Else  Set ConFac=1
	
	s PackQty=$p(^DHCPB(myBill,"O",myOrd),"^",5)
	s refundqty=$p(^DHCPB(myBill,"O",myOrd),"^",6)			;;OE_OrdItem->OEORI_RefundQty
	;;;s refundqty=$p(^DHCPB(myBill,"O",myOrd),"^",6)
	i refundqty="" d
		.s refundqty=0
	s PackQty=+PackQty+refundqty
	
	
	s Price=$fn(Price*ConFac,"",4)
	;b	;;
	i (OrderType="R")&(PackQty="") s PackQty=1
	i ((OrderType="R")&(PackQty'="")) d
		.s PackQty=PackQty/ConFac
	s OrdPatSum=$fn($p(^DHCPB(myBill,"O",myOrd),"^",11),"",2)
	s OrdTotSum=$fn($p(^DHCPB(myBill,"O",myOrd),"^",8),"",2)
	
	
	i ((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItemCatDR_"^"))) d
	.;属于草药?
	.i HerbIdx=0 d
	..s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	..s HerbIdx=$g(^TMP($ZN,$j,"D"))
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",1)= FCHerbDesc
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",2)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",3)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",4)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",5)=+$p($g(^TMP($ZN,$j,"D",HerbIdx)),"^",5)+OrdTotSum
	;HerbIdx
	
	;b  ;Herb
	q:((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItemCatDR_"^")))	;退出
	
	s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	s Idx=$g(^TMP($ZN,$j,"D"))
	;s mylen=$l($p(ArcimDesc,"-",1))
	;b		;;;;
	s ^TMP($ZN,$j,"D",Idx)=$e(DrgDesc_$p($g(ArcimDesc),"-"),1,15)_"^"_Price_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum
	quit
	
GetDetails()
	s myidx=""
	s myList=""
	f  s myidx=$o(^TMP($ZN,$j,"D",myidx)) q:myidx=""  d
	.i myList="" d
	..s myList=^TMP($ZN,$j,"D",myidx)
	.e  d
	..s myList=myList_""_$c(2)_^TMP($ZN,$j,"D",myidx)
	
	q myList
GetDetails2007()
	s myMaxRows=16
	
	;  省略
	s myList=""
	s myOrdCount=+$g(^TMP($ZN,$j,"D"))
	
	f i=(myOrdCount+1):1:(myMaxRows*2)  d
	.s ^TMP($ZN,$j,"D",i)="^^^^"
	.s ^TMP($ZN,$j,"D")=i
	
	f myidx=1:1:(myMaxRows)  d
	.i myList="" d
	..s myList=^TMP($ZN,$j,"D",myidx)_"^"_^TMP($ZN,$j,"D",(myidx+(myMaxRows)))
	.e  d
	..s myList=myList_""_$c(2)_""_^TMP($ZN,$j,"D",myidx)_"^"_^TMP($ZN,$j,"D",(myidx+(myMaxRows)))
	
	q myList
}

ClassMethod GetOPINV(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
	;打印急诊发票，只打印发票的汇总，而不打印明细
	;对应的表是：DHC_AccPayINV   表
	;w ##class(web.UDHCOPINVPrtData).GetOPINV("","48","UseID","PayMode")
	Quit:$g(InvRowID)="" ""
	;$p(^DHCINVPRTAP(InvRowID),"^",
	s SelectPrtDr=InvRowID
	
	Set PatDr=$p(^DHCINVPRTAP(SelectPrtDr),"^",11)			;API_PAPMI_DR
	;Set PatDr=$p(^PAADM(PAADMRID),"^",1)
	Quit:$g(PatDr)="" ""
	Set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	Set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	Set Date=$p(^DHCINVPRTAP(SelectPrtDr),"^",3)			;API_Date
	s myInvNo=$p(^DHCINVPRTAP(SelectPrtDr),"^",6)			;API_INVNo
	Set DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Date"_$C(2)_$zd(Date,3)
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	s DetailStr=DetailStr_"^"_"PayMode"_$c(2)_PayMode
	//s DetailStr=DetailStr_"^"_"InvNo"_$c(2)_myInvNo
	
	///增加打印医保手册号码
	s myINSCode=""
	;^DHCINVPRTCAPi(0,"APINVDR",SelectPrtDr,myACPRowID)
	;SelectPrtDr
	s myACPRowID=0
	f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",SelectPrtDr,myACPRowID)) q:(myACPRowID="")  d
	.;^DHCINVPRTCAP(myACPRowID)
	.s myPRTRowID=$p(^DHCINVPRTCAP(myACPRowID),"^",1)		;ACP_INVPRT_DR
	.q:(myINSCode'="")
	.s myINSDR=$p(^DHCINVPRT(myPRTRowID),"^",9)				;DHC_INVPRT
	.s myINSCode=$p(^PAC("ADMREA",myINSDR),"^",1)
	
	s myTMPINVStr=""
	if myINSCode="医保" d
	.s myYBDesc=##Class(web.DHCINSUFacade).GetPrtInvPreFix(PatDr)			;
	.s myTMPINVStr="^"_"InvNo"_$c(2)_myYBDesc_myInvNo
	.Set patName3=$p(^PAPER(PatDr,"ALL"),"^",19)
	.set patname3="手册号:"_patName3
	.s myTMPINVStr=myTMPINVStr_"^"_"patname3"_$c(2)_patname3
	e  d
	.s myTMPINVStr="^"_"InvNo"_$c(2)_myInvNo
	
	s DetailStr=DetailStr_myTMPINVStr
	
	Kill ^TMP($ZN,$j)
	s myidx=""
	s INVLinkDr=""
	;获取中草药配制
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	s HerbIdx=0						;;草药费明细索引
	
	;Add an Index for RecLoc
	;按照分类打印发票
	
	;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID})
	s myACPRowID=0
	f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",SelectPrtDr, myACPRowID)) q:(myACPRowID="")  d
	.;^DHCINVPRTCAP({ACP_RowID})
	.q:($d(^DHCINVPRTCAP(myACPRowID))=10)
	.s myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	.f  s INVLinkDr=$o(^DHCBCI(0,"INV",myPRTRowID,INVLinkDr)) Quit:INVLinkDr=""  Do
	..Set Bill=$p(^DHCBCI(INVLinkDr),"^",2)
	..Quit:'$D(^DHCPB(Bill))
	..Set Ord=0 For  Set Ord=$o(^DHCPB(Bill,"O",Ord)) Quit:Ord=""  Do
	...q:($d(^DHCPB(Bill,"O",Ord))=10)		;;zhao防止错误?
	...s Prescno=""
	...s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s Arcim=$p(^DHCPB(Bill,"O",Ord),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	...s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	...s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	...s recdepDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),3)),"^",6) ;接收科室
	...s loctype=$p(^CTLOC(recdepDR),"^",13) 
	...i loctype="" s loctype="Z"	;放在最后?
	...s ^TMP($ZN,$j,"PBID",loctype,recdepDR,Bill_"||"_Ord)=""		;;;Index
	...s ^TMP($ZN,$j,"PBO",Bill_"||"_Ord)=Bill_"^"_Ord_"^"_myPresNo_"^"_OrderType
	
	b	;
	s myLocType=""
	f  s myLocType=$o(^TMP($ZN,$j,"PBID",myLocType)) q:myLocType=""  d
	.s myRecDR=""
	.f  s myRecDR=$o(^TMP($ZN,$j,"PBID",myLocType,myRecDR)) q:myRecDR=""  d
	..s myPBORID=""
	..f  s myPBORID=$o(^TMP($ZN,$j,"PBID",myLocType,myRecDR,myPBORID)) q:myPBORID=""  d
	...;s OrdDr=$p(^DHCPB(Bill,"O",Ord),"^",3)
	...;b	;;
	...s Bill=+myPBORID
	...s Ord=$p(myPBORID,"||",2)
	...s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s myAcrim=$p(^DHCPB(Bill,"O",Ord),"^",3)		;
	...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	...;d AddDWin(myPresNo)
	...s myOFFlag=##class(web.DHCOPConfig).ReadOESpPrtFlag(myAcrim)
	...i myOFFlag="F" d
	...e  d
	...Set Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) Quit:Itm=""  Do
	....Set ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....Set TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....Set DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....Set PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....Set PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....;b	;GetInvoicePrtDetail
	....Do AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	
	
	s prtTxtInfo=$$GetTxtInfo()
	;w prtTxtInfo,!
	;s prtListInfo=$$GetDetails()
	s prtListInfo=""
	;w prtListInfo
	s prtTxtInfo=DetailStr_"^"_prtTxtInfo
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^TMP($ZN,$j)
	Quit "0"
	;
	;
}

ClassMethod GetOPINVDetail(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
	;打印急诊发票， 打印明细清单
	;InvRowID  表示：DHC_AccPayINV  的RowID
	; AccPRowID
	;
	;;w ##class(web.UDHCOPINVPrtData).GetOPINVDetail("","48","UseID","PayMode")
	Quit:$g(InvRowID)="" ""
	;$p(^DHCINVPRTAP(InvRowID),"^",
	s SelectPrtDr=InvRowID
	
	Set PatDr=$p(^DHCINVPRTAP(SelectPrtDr),"^",11)		;API_PAPMI_DR
	;Set PatDr=$p(^PAADM(PAADMRID),"^",1)
	Quit:$g(PatDr)="" ""
	Set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	Set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	Set Date=$p(^DHCINVPRTAP(SelectPrtDr),"^",3)		;API_Date
	s myInvNo=$p(^DHCINVPRTAP(SelectPrtDr),"^",6)		;API_INVNo
	Set DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Date"_$C(2)_$zd(Date,3)
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	s DetailStr=DetailStr_"^"_"PayMode"_$c(2)_PayMode
	s DetailStr=DetailStr_"^"_"InvNo"_$c(2)_myInvNo
	
	Kill ^TMP($ZN,$j)
	s myidx=""
	s INVLinkDr=""
	;获取中草药配制
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	s HerbIdx=0						;;草药费明细索引
	
	;Add an Index for RecLoc
	;西药，成药，草药，
	
	;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID})
	s myACPRowID=0
	f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",SelectPrtDr, myACPRowID)) q:(myACPRowID="")  d
	.;^DHCINVPRTCAP({ACP_RowID})
	.q:($d(^DHCINVPRTCAP(myACPRowID))=10)
	.s myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	.For  Set INVLinkDr=$o(^DHCBCI(0,"INV",myPRTRowID,INVLinkDr)) Quit:INVLinkDr=""  Do
	..Set Bill=$p(^DHCBCI(INVLinkDr),"^",2)
	..Quit:'$D(^DHCPB(Bill))
	..Set Ord=0 For  Set Ord=$o(^DHCPB(Bill,"O",Ord)) Quit:Ord=""  Do
	...q:($d(^DHCPB(Bill,"O",Ord))=10)		;;zhao防止错误?
	...s Prescno=""
	...s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s Arcim=$p(^DHCPB(Bill,"O",Ord),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	...s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	...s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	...s recdepDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),3)),"^",6) ;接收科室
	...s loctype=$p(^CTLOC(recdepDR),"^",13) 
	...i loctype="" s loctype="Z"	;放在最后?
	...s ^TMP($ZN,$j,"PBID",loctype,recdepDR,Bill_"||"_Ord)=""		;;;Index
	...s ^TMP($ZN,$j,"PBO",Bill_"||"_Ord)=Bill_"^"_Ord_"^"_myPresNo_"^"_OrderType
	
	;
	s myLocType=""
	f  s myLocType=$o(^TMP($ZN,$j,"PBID",myLocType)) q:myLocType=""  d
	.s myRecDR=""
	.f  s myRecDR=$o(^TMP($ZN,$j,"PBID",myLocType,myRecDR)) q:myRecDR=""  d
	..s myPBORID=""
	..f  s myPBORID=$o(^TMP($ZN,$j,"PBID",myLocType,myRecDR,myPBORID)) q:myPBORID=""  d
	...;s OrdDr=$p(^DHCPB(Bill,"O",Ord),"^",3)
	...;b	;;
	...s Bill=+myPBORID
	...s Ord=$p(myPBORID,"||",2)
	...s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s myAcrim=$p(^DHCPB(Bill,"O",Ord),"^",3)		;
	...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	...s myOFFlag=##class(web.DHCOPConfig).ReadOESpPrtFlag(myAcrim)
	...d AddJFToDetailsAPDetail(Bill,Ord)
	...Set Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) Quit:Itm=""  Do
	....Set ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....Set TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....Set DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....Set PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....Set PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....;b	;GetInvoicePrtDetail
	....;Do AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	
	
	;s prtTxtInfo=$$GetTxtInfo()
	s prtTxtInfo=""
	;w prtTxtInfo,!
	s prtListInfo=$$GetDetailsAP()
	;w prtListInfo
	s prtTxtInfo=DetailStr_"^"_prtTxtInfo
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^TMP($ZN,$j)
	Quit "0"
	;
AddJFToDetailsAPDetail(myBill,myOrd)
	;西药费    100
	;阿莫西林    100
	q:'$d(^DHCPB(myBill,"O",myOrd))
	
	s ArcimRowid=$p(^DHCPB(myBill,"O",myOrd),"^",3)
	
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	s:ItemCatDR'="" CatDr=$p(^ARC("IC",ItemCatDR),"^",8)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType

	;增加规格
	s myINCItmDR=""
	s myINCItmDR=$o(^INCI(0,"ARCIM_DR", +ArcimRowid, 0))
	s myINCRegu=""
	s:(myINCItmDR'="") myINCRegu=$p($g(^INCI(myINCItmDR,3)),"^",9)
	
	;加入通用名称
	s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimRowid)
	
	s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2) ;名称
	s:(DrugCommonDesc'="") ArcimDesc=DrugCommonDesc_myINCRegu
	
	;s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	;s Idx=$g(^TMP($ZN,$j,"D"))
	;s ^TMP($ZN,$j,"D",Idx)=$e($p($g(ArcimDesc),"-"),1,15)_"^"_"^"_"^"_"^"
	
	;^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub}) 
	s myPBDRowID=0
	;b		;;;AddJFToDetails
	f  s myPBDRowID=$o(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID)) q:(myPBDRowID="")  d
	.s myTarRowID=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",3)	;PBD_TARI_DR
	.q:myTarRowID=""
	.s myTarDesc=$p($g(^DHCTARI(myTarRowID)),"^",2)
	.s ItmDr=myTarRowID
	.Quit:$g(ItmDr)="" 
	.Set ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	.Quit:$g(ItmOPSubCat)=""
	.Set ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	.Quit:$g(ItmOPCat)=""
	.s OPCatCode=$p(^DHCTarC("TOC",ItmOPCat),"^",1)
	.Set OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	.s myUnitPrice=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",4)		;PBD_UnitPrice
	.s myUnitPrice=$fn(myUnitPrice,"",4)
	.s PackUOM=""
	.s PackQty=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",5)			;PBD_BillQty
	.s OrdTotSum=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",10)			; PBD_PatientShare
	.s OrdTotSum=$fn(OrdTotSum,"",2)
	.i '$d(^TMP($ZN,$j,"D",ItmOPCat)) d
	..s ^TMP($ZN,$j,"D",ItmOPCat)=OPCatDesc_"^^^^"_OrdTotSum
	.e  d
	..s $p(^TMP($ZN,$j,"D",ItmOPCat),"^",5)=+$p(^TMP($ZN,$j,"D",ItmOPCat),"^",5)+OrdTotSum
	.s ^TMP($ZN,$j,ItmOPCat,"C")=$g(^TMP($ZN,$j,ItmOPCat,"C"))+1
	.s Idx=$g(^TMP($ZN,$j,ItmOPCat,"C"))
	.s ^TMP($ZN,$j,"D",ItmOPCat,Idx)=""_$e($g(myTarDesc),1,15)_"^"_myUnitPrice_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum
	.
	
	q
GetDetailsAP()
	b		;;AP
	s myidx=""
	s myList=""
	s myIOPCatDR=0
	f  s myIOPCatDR=$o(^TMP($ZN,$j,"D",myIOPCatDR))  q:(myIOPCatDR="")  d
	.s myidx=0
	.i myList="" d
	..s myList=^TMP($ZN,$j,"D",myIOPCatDR)
	.e  d
	..s myList=myList_""_$c(2)_^TMP($ZN,$j,"D",myIOPCatDR)
	.f  s myidx=$o(^TMP($ZN,$j,"D",myIOPCatDR,myidx)) q:myidx=""  d
	..i myList="" d
	...s myList=^TMP($ZN,$j,"D",myIOPCatDR,myidx)
	..e  d
	...s myList=myList_""_$c(2)_^TMP($ZN,$j,"D",myIOPCatDR,myidx)
	
	q myList
}

ClassMethod GetOPAccPayList(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
	;w ##class(web.UDHCOPINVPrtData1).GetOPAccPayList("","1842","UserID","PayMode")
	
	Quit:$g(InvRowID)="" ""
	;$p(^DHCINVPRT(InvRowID),"^",
	s SelectPrtDr=InvRowID
	
	Set PatDr=$p(^DHCINVPRT(SelectPrtDr),"^",15)
	;Set PatDr=$p(^PAADM(PAADMRID),"^",1)
	Quit:$g(PatDr)="" ""
	Set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	Set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	Set Date=$p(^DHCINVPRT(SelectPrtDr),"^",5)
	;s myInvNo=$p(^DHCINVPRT(SelectPrtDr),"^",14)
	s myPayDiscSum=+$p(^DHCINVPRT(SelectPrtDr),"^",14)
	s myPatPaySum=+$p(^DHCINVPRT(SelectPrtDr),"^",14)
	
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	s myAccRowID=""
	s myPLRowID=""
	s myAccPaySum=0.00
	s mySub=0
	f  s mySub=$o(^DHCINVPRT(SelectPrtDr,"P",mySub))  q:((mySub="")!(myAccRowID'=""))  d
	.q:($d(^DHCINVPRT(SelectPrtDr,"P",mySub))=10)
	.s myAccRowID=$p(^DHCINVPRT(SelectPrtDr,"P",mySub),"^",8)
	.s myPLRowID=myAccRowID
	.s:(myAccRowID'="") myAccRowID=+$g(myAccRowID)
	.s myAccPaySum=$p(^DHCINVPRT(SelectPrtDr,"P",mySub),"^",3)
	
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	s myBalance=$p(^DHCACD("AccM",+myPLRowID,"AccPL",$p(myPLRowID,"||",2)),"^",9)
	;myAccRowID
	
	s myPayLocDesc=""
	s myPayLocDR=$p(^DHCACD("AccM",+myPLRowID,"AccPL",$p(myPLRowID,"||",2)),"^",10)
	s:(myPayLocDR'="") myPayLocDesc=$p($g(^CTLOC(myPayLocDR)),"^",2)
	
	s CardNo=$p(^DHCACD("AccM",myAccRowID),"^",4)
	
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myAccPaySum)
	
	
	Set DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Datetime"_$C(2)_$zd(Date,3)
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	s DetailStr=DetailStr_"^"_"PayMode"_$c(2)_PayMode
	s DetailStr=DetailStr_"^"_"CardNo"_$c(2)_CardNo
	s DetailStr=DetailStr_"^"_"Balance"_$c(2)_myBalance
	s DetailStr=DetailStr_"^"_"PaySumYMB"_$c(2)_myRMB
	s DetailStr=DetailStr_"^"_"PaySum"_$c(2)_myAccPaySum
	s DetailStr=DetailStr_"^"_"Guser"_$c(2)_UseID
	s DetailStr=DetailStr_"^"_"PayLoc"_$c(2)_myPayLocDesc
	
	;s DetailStr=DetailStr_"^"_"InvNo"_$c(2)_myInvNo
	
	Kill ^TMP($ZN,$j)
	
	s rtn=0
	s myAccPRowID=""
	s rtn=##class(web.UDHCOPINVPrtData1).SetINVPrtPLISTData(InvRowID)
	
	;s prtTxtInfo=$$GetTxtInfoForList(PatName)
	;w prtTxtInfo,!
	s prtListInfo=$$GetDetailsForList()
	;w prtListInfo
	s prtTxtInfo=DetailStr			;_"^"_prtTxtInfo
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^TMP($ZN,$j)
	Quit rtn
GetTxtInfoForList(PatName)
	n (PatName,InvNo)
	
	s OPCSInfo=""
	s myTxtInfo=""
	s myPatientShare=0
	s myTSum=0
	f  s OPCSInfo=$o(^TMP($ZN,$j,"CAT",OPCSInfo)) q:OPCSInfo=""  d
	.i myTxtInfo="" d
	..s myTxtInfo=OPCSInfo_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.e  d
	..s myTxtInfo=myTxtInfo_"^"_OPCSInfo_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.s myPatientShare=+myPatientShare+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
	.s myTSum=+myTSum+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",2)
	
	s mypayinfo="PaySum"_$C(2)_""_$fn(myTSum,"",2)
	
	s mypayinfo=mypayinfo_"^"_"PayDiscSum"_$c(2)_$fn(+myTSum-myPatientShare,"",2)
	s mypayinfo=mypayinfo_"^"_"PatPaySum"_$c(2)_$fn(myPatientShare,"",2)
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myPatientShare)
	s mypayinfo="PatPaySumPY"_$C(2)_""_myRMB
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	
	;打印回执联；
	;PatName  Item   Rloc   CurColFee    PaySum   Date   InvNo
	s myIdx=0
	s myRtnUnit=""
	s myCurDate=$zd(+$h,3)
	
	i $d(^TMP($ZN,$j,"SubRec")) d
	.s mySubCatDR=""
	.q
	.f  s mySubCatDR=$o(^TMP($ZN,$j,"SubRec", mySubCatDR)) q:(mySubCatDR="")  d
	..s myRecLocDR=""
	..f  s myRecLocDR=$o(^TMP($ZN,$j,"SubRec", mySubCatDR, myRecLocDR)) q:(myRecLocDR="")  d
	...s myIdx=+myIdx+1
	...i myRtnUnit="" d
	....s myRtnUnit="Item"_myIdx_$c(2)_$p(^TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",1)
	...e  d
	....s myRtnUnit=myRtnUnit_"^Item"_myIdx_$c(2)_$p(^TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",1)
	...s myRtnUnit=myRtnUnit_"^PatName"_myIdx_$c(2)_PatName
	...s myRtnUnit=myRtnUnit_"^Rloc"_myIdx_$c(2)_$p(^TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",2)
	...s mySubFee=$p(^TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",3)
	...s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(mySubFee)
	...s myRtnUnit=myRtnUnit_"^CurColFee"_myIdx_$c(2)_$p(^TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",3)
	...s myRtnUnit=myRtnUnit_"^PaySum"_myIdx_$c(2)_myRMB
	...s myRtnUnit=myRtnUnit_"^Date"_myIdx_$c(2)_myCurDate
	...s myRtnUnit=myRtnUnit_"^InvNo"_myIdx_$c(2)_InvNo
	
	s myTxtInfo=myTxtInfo_"^"_myRtnUnit
	
	b	;GetTxtInfo
	q myTxtInfo
GetDetailsForList()
	n (ab)
	
	s myidx=""
	s myList=""
	s myList="项目名称          规格  数量    金额"
	f  s myidx=$o(^TMP($ZN,$j,"D",myidx)) q:myidx=""  d
	.s myStr=""
	.i myList="" d
	..s myStr=$p(^TMP($ZN,$j,"D",myidx),"^",1)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",3)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",4)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",5)
	..s myList=myStr
	.e  d
	..s myStr=$p(^TMP($ZN,$j,"D",myidx),"^",1)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",3)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",4)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",5)
	..s myList=myList_""_$c(2)_myStr
	..;s myStr=""
	..;s myList=myList_""_$c(2)_myStr
	q myList
GetDetailsForListOld()
	n (ab)
	
	s myidx=""
	s myList=""
	s myList="项目名称"
	s myList=myList_$c(2)_"     规格  数量    金额"
	f  s myidx=$o(^TMP($ZN,$j,"D",myidx)) q:myidx=""  d
	.s myStr=""
	.i myList="" d
	..s myList=$p(^TMP($ZN,$j,"D",myidx),"^",1)
	..;
	..s myStr="   "_$p(^TMP($ZN,$j,"D",myidx),"^",3)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",4)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",5)
	..s myList=myList_""_$c(2)_myStr
	.e  d
	..s myList=myList_""_$c(2)_$p(^TMP($ZN,$j,"D",myidx),"^",1)
	..s myStr="   "_$p(^TMP($ZN,$j,"D",myidx),"^",3)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",4)
	..s myStr=myStr_"   "_$p(^TMP($ZN,$j,"D",myidx),"^",5)
	..s myList=myList_""_$c(2)_myStr
	..;s myStr=""
	..;s myList=myList_""_$c(2)_myStr
	q myList
}

}
