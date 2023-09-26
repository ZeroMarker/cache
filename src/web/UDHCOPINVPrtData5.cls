Class web.UDHCOPINVPrtData5 Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 78;

/// ////西安交大眼科医院发票打印
ClassMethod GetOPPrtData(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
	Quit:$g(InvRowID)="" ""
	;w ##class(web.UDHCOPINVPrtData5).GetOPPrtData("","5948","UseID","现金")
	s SelectPrtDr=InvRowID
	
	Set PatDr=$p(^DHCINVPRT(SelectPrtDr),"^",15)
	;Set PatDr=$p(^PAADM(PAADMRID),"^",1)
	Quit:$g(PatDr)="" ""
	Set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	Set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	Set Date=$p(^DHCINVPRT(SelectPrtDr),"^",5)
	s myInvNo=$p(^DHCINVPRT(SelectPrtDr),"^",14)
	s myUserDR=$p(^DHCINVPRT(SelectPrtDr),"^",21)
	s myUserName=""
	i myUserDR'="" d
	.s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	
	Set DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Date"_$C(2)_$zd(Date,3)
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	;s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_myUserName
	s DetailStr=DetailStr_"^"_"PayMode"_$c(2)_PayMode
	s DetailStr=DetailStr_"^"_"InvNo"_$c(2)_myInvNo
	s DetailStr=DetailStr_"^"_"Year"_$c(2)_$p($zd(Date,3),"-")
	s DetailStr=DetailStr_"^"_"Month"_$c(2)_$p($zd(Date,3),"-",2)
	s DetailStr=DetailStr_"^"_"Day"_$c(2)_$p($zd(Date,3),"-",3)
	s DetailStr=DetailStr_"^"_"YBNo"_$c(2)_""			;医保号码
	;s DetailStr=DetailStr_"^"_"PTime"_$c(2)_$zt($p($h,",",2))
	
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
	...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	...
	...;d AddDWin(myPresNo)
	...;d AddToDetails(Bill,Ord)
	...Set Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) Quit:Itm=""  Do
	....Set ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....Set TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....Set DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....Set PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....Set PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....;b	;GetInvoicePrtDetail
	....Do AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare, myRecDR)
	
	b	;
	
	s prtTxtInfo=$$GetTxtInfo(SelectPrtDr)
	
	;w prtTxtInfo,!
	;s prtListInfo=$$GetDetails()
	;w prtListInfo
	s prtTxtInfo=DetailStr_"^"_prtTxtInfo
	s ^TMPprtTxtInfo=prtTxtInfo
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^TMP($ZN,$j)
	Quit "0"
	;
	;
AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare, RecDR)
	n (ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare, RecDR)
	Quit:$g(ItmDr)="" 
	Set ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	Quit:$g(ItmOPSubCat)=""
	Set ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	Quit:$g(ItmOPCat)=""
	s OPCatCode=$p(^DHCTarC("TOC",ItmOPCat),"^",1)
	Set OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	q:(RecDR="")
	s myRecLocName=$p($g(^CTLOC(RecDR)),"^",2)
	;b  ;在此解析成票据格式?ItmOPCat
	
	if $D(^TMP($ZN,$j,"CAT",OPCatCode)) DO
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",1)=OPCatDesc
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",2)=$p(^TMP($ZN,$j,"CAT",OPCatCode),"^",2)+TotalAmount
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",3)=$p(^TMP($ZN,$j,"CAT",OPCatCode),"^",3)+DiscAmount
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",4)=$p(^TMP($ZN,$j,"CAT",OPCatCode),"^",4)+PatientShare
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",5)=$p(^TMP($ZN,$j,"CAT",OPCatCode),"^",5)+PayorShare
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",6)=myRecLocName
	Else  Do
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",1)=OPCatDesc
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",2)=TotalAmount
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",3)=DiscAmount
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",4)=PatientShare
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",5)=PayorShare
		.Set $p(^TMP($ZN,$j,"CAT",OPCatCode),"^",6)=myRecLocName
		.s ^TMP($ZN,$j,"CAT")=+$g(^TMP($ZN,$j,"CAT"))+1
		.s ^TMP($ZN,$j,"CAT",OPCatCode,"IDX")=$g(^TMP($ZN,$j,"CAT"))
	
	Quit
GetTxtInfo(myPRTRowID)
	
	s OPCSInfo=""
	s myTxtInfo=""
	s myPatientShare=0
	s myIndex=0
	s myMTip="FBSum"
	s myFBTip="FB"
	f  s OPCSInfo=$o(^TMP($ZN,$j,"CAT",OPCSInfo)) q:OPCSInfo=""  d
	.s myIndex=myIndex+1
	.s myCatDesc=$p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",1)
	.s myPatientShare=+myPatientShare+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
	.s myLocName=$p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",6)
	
	i ($p(myLocName,"-",2)'="") d
	.s myLocName=$p(myLocName,"-",2)
	
	s myPMDR=$o(PRTRowID)
	
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myPatientShare)
	
	s myPMSub=$o(^DHCINVPRT(myPRTRowID,"P",0))
	s myPMDR=$p($g(^DHCINVPRT(myPRTRowID,"P",myPMSub)),"^",1)
	s myPMCoed=$p($g(^CT("CTPM",myPMDR)),"^",1)
	
	if myPMCoed'="CASH" d
	.s mypayinfo="PayTc"_$C(2)_""_$fn(myPatientShare,"",2)
	e  d
	.;现金支付模式
	.s mypayinfo="PaySum"_$C(2)_""_$fn(myPatientShare,"",2)
	
	s myTxtInfo=mypayinfo
	s mypayinfo="PaySumPY"_$C(2)_""_myRMB
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s myTxtInfo=myTxtInfo_"^"_"RecDep"_$c(2)_myLocName
	s myTxtInfo=myTxtInfo_"^"_"ItemName"_$C(2)_""_myCatDesc
	
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
AddToDetails(myBill,myOrd)
	;ArcimDesc_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBOrderRowid_"^"_OrderUnitPrice_"^"_OrderBillQty_"^"_OrderSum_"^"_OrderType_"^"_Prescno_"^"_ORCATDesc_"^"_ItemGroup_"^"_loctype_"^"_bill_"^"_OrdPatShare
	;i PackQty="" s PackQty=1
	q:'$d(^DHCPB(myBill,"O",myOrd))
	
	s ArcimRowid=$p(^DHCPB(myBill,"O",myOrd),"^",3)
	
	s CatDr=""
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	s:ItemCatDR'="" CatDr=$p(^ARC("IC",ItemCatDR),"^",8)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2) ;名称
	s ArcimDrgFrm=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",12) ;药物形态
	s DrgType=""
	s DrgDesc=""
	i ArcimDrgFrm'="" d
	.q:(CatDr=12)
	.;s DrgType=$p(^PHCD(+ArcimDrgFrm,4),"^",2)
	
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
	.;;;s $p(^TMP($ZN,$j,"D",HerbIdx),"^",2)=""去掉单价
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",2)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",3)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",4)=+$p($g(^TMP($ZN,$j,"D",HerbIdx)),"^",4)+OrdTotSum
	;HerbIdx
	
	;b  ;Herb
	q:((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItemCatDR_"^")))	;退出
	
	s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	s Idx=$g(^TMP($ZN,$j,"D"))
	
	;_Price_"^"
	s ^TMP($ZN,$j,"D",Idx)=$e(DrgDesc_$p($g(ArcimDesc),"-"),1,19)_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum
	quit
	
GetDetails()
	s myidx=""
	s myList=""
	f  s myidx=$o(^TMP($ZN,$j,"D",myidx)) q:myidx=""  d
	.i myList="" d
	..s myList=^TMP($ZN,$j,"D",myidx)
	.e  d
	..s myList=myList_""_$c(2)_^TMP($ZN,$j,"D",myidx)
	;s myList=myList_""_$c(2)_"备注:   # 无自付;   & 有自付;   * 全自付;^^^^"
	q myList
}

}
