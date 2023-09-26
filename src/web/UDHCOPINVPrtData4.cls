Class web.UDHCOPINVPrtData4 Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 78;

/// ////宁波明州医院发票打印
ClassMethod GetOPPrtData(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
	;打印计费项明细的类方法
	Quit:$g(InvRowID)="" ""
	;
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
	
	;s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_myUserName
	s DetailStr=DetailStr_"^"_"PayMode"_$c(2)_PayMode
	s DetailStr=DetailStr_"^"_"InvNo"_$c(2)_myInvNo
	s DetailStr=DetailStr_"^"_"Year"_$c(2)_$p($zd(Date,3),"-")
	s DetailStr=DetailStr_"^"_"Month"_$c(2)_$p($zd(Date,3),"-",2)
	s DetailStr=DetailStr_"^"_"Day"_$c(2)_$p($zd(Date,3),"-",3)
	s DetailStr=DetailStr_"^"_"YBNo"_$c(2)_""			;医保号码
	;s DetailStr=DetailStr_"^"_"PTime"_$c(2)_$zt($p($h,",",2))

	;;医保支付信息
	s YBInfo=""
	s myINSDivDR=$p(^DHCINVPRT(SelectPrtDr),"^",30)			;
	i myINSDivDR'="" d
	.;调用医保信息接口
	.s myYBRtn=##Class(web.DHCINSUFacade).GetInsuDivideInf(myINSDivDR)
	.s YBYLTCNO=$p($g(myYBRtn),"^",1)
	.s YBInfo="YBYLTCNO"_$c(2)_YBYLTCNO
	.s YBInfo=YBInfo_"^"_"YBGRZFGD"_$c(2)_"个人自费"
	.s YBInfo=YBInfo_"^"_"YBGRZFUGD"_$c(2)_"个人自付"
	.s YBInfo=YBInfo_"^"_"YBGRZIFUGD"_$c(2)_"个人自负"
	.s YBInfo=YBInfo_"^"_"YBGRCDGD"_$c(2)_"个人承担"
	.s YBInfo=YBInfo_"^"_"YBDNGZGD"_$c(2)_"当年个帐"
	.s YBInfo=YBInfo_"^"_"YBTCJJGD"_$c(2)_"统筹基金"
	.s YBInfo=YBInfo_"^"_"YBLNGZGD"_$c(2)_"历年个帐"
	.s YBInfo=YBInfo_"^"_"YBGWYBZGD"_$c(2)_"公务员补助"
	.s YBInfo=YBInfo_"^"_"YBDNGZYEGD"_$c(2)_"当年个帐余额"
	.s YBInfo=YBInfo_"^"_"YBZFLJGD"_$c(2)_"自负累计"
	.s YBInfo=YBInfo_"^"_"YBLNGZYEGD"_$c(2)_"历年个帐余额"
	.s YBInfo=YBInfo_"^"_"YBEJYYGD"_$c(2)_"三级 医院"
	.;金额。。。。
	.s YBGRZFSum=$p($g(myYBRtn),"^",2)
	.s YBGRZFUSum=$p($g(myYBRtn),"^",3)
	.s YBGRZIFUSum=$p($g(myYBRtn),"^",4)
	.s YBGRCDSum=$p($g(myYBRtn),"^",5)
	.s YBDNGZSum=$p($g(myYBRtn),"^",6)
	.s YBTCJJSum=$p($g(myYBRtn),"^",7)
	.s YBLNGZSum=$p($g(myYBRtn),"^",8)
	.s YBGWYBZSum=$p($g(myYBRtn),"^",9)
	.s YBDNGZYESum=$p($g(myYBRtn),"^",10)
	.s YBZFLJSum=$p($g(myYBRtn),"^",11)
	.s YBLNGZYESum=$p($g(myYBRtn),"^",12)
	.s YBEJYYSum=$p($g(myYBRtn),"^",13)
	.
	.s YBInfo=YBInfo_"^"_"YBGRZFSum"_$c(2)_$fn(YBGRZFSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBGRZFUSum"_$c(2)_$fn(YBGRZFUSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBGRZIFUSum"_$c(2)_$fn(YBGRZIFUSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBGRCDSum"_$c(2)_$fn(YBGRCDSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBDNGZSum"_$c(2)_$fn(YBDNGZSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBTCJJSum"_$c(2)_$fn(YBTCJJSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBLNGZSum"_$c(2)_$fn(YBLNGZSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBGWYBZSum"_$c(2)_$fn(YBGWYBZSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBDNGZYESum"_$c(2)_$fn(YBDNGZYESum,"",2)
	.s YBInfo=YBInfo_"^"_"YBZFLJSum"_$c(2)_$fn(YBZFLJSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBLNGZYESum"_$c(2)_$fn(YBLNGZYESum,"",2)
	.s YBInfo=YBInfo_"^"_"YBEJYYSum"_$c(2)_YBEJYYSum
	.
	.s DetailStr=DetailStr_"^"_YBInfo
	
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
	...d AddDWin(myPresNo)
	...;d AddToDetails(Bill,Ord)
	...d AddJFToDetails(Bill,Ord)
	...Set Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) Quit:Itm=""  Do
	....Set ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....Set TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....Set DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....Set PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....Set PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....;b	;GetInvoicePrtDetail
	....Do AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	
	
	s prtTxtInfo=$$GetTxtInfo(SelectPrtDr)
	;w prtTxtInfo,!
	s prtListInfo=$$GetDetails()
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
	.i myTxtInfo="" d
	..s myTxtInfo=myMTip_myIndex_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.e  d
	..s myTxtInfo=myTxtInfo_"^"_myMTip_myIndex_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.s myTxtInfo=myTxtInfo_"^"_myFBTip_myIndex_$c(2)_$p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",1)
	.s myPatientShare=+myPatientShare+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
	
	s myYBPaySum=+$p(^DHCINVPRT(myPRTRowID),"^",31)
	s Selfpay=+myPatientShare-myYBPaySum
	
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myPatientShare)
	s myRMBselfpay=##class(web.UDHCOPINVPrtIF).RMBConvert(Selfpay)
	s mypayinfo="PaySum"_$C(2)_myRMB_" "_$fn(myPatientShare,"",2)
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s mypayinfo="PaySumPY"_$C(2)_""_myRMB
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s myTxtInfo=myTxtInfo_"^"_"ListPaySum"_$c(2)_""_$fn(myPatientShare,"",2)
	s myTxtInfo=myTxtInfo_"^"_"CashSum"_$c(2)_myRMBselfpay_" "_$fn(Selfpay,"",2)
	b	;GetTxtInfo
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
	
	s myrtn=##class(web.DHCMZYFXTYW02).GetCurrWin(myCTLoc)
	;
	;
	s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	s Idx=$g(^TMP($ZN,$j,"D"))
	
	i Idx<23 d
	.s ^TMP($ZN,$j,"D",Idx)=$p(myrtn,"^",3)_"^^^^"
	e  d
	.s ^TMP($ZN,$j,"D",23)="略....^^^^"
	
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
	.;;;s $p(^TMP($ZN,$j,"D",HerbIdx),"^",2)=""去掉单价
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",2)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",3)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",4)=+$p($g(^TMP($ZN,$j,"D",HerbIdx)),"^",4)+OrdTotSum
	;HerbIdx
	
	;b  ;Herb
	q:((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItemCatDR_"^")))	;退出
	
	;_Price_"^"
	i +$g(^TMP($ZN,$j,"D"))<23 d
	.s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	.s Idx=$g(^TMP($ZN,$j,"D"))
	.s ^TMP($ZN,$j,"D",Idx)=$e(DrgDesc_$p($g(ArcimDesc),"-"),1,19)_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum
	e  d
	.s ^TMP($ZN,$j,"D",23)="略....^^^^"
	
	quit
AddJFToDetails(myBill,myOrd)
	q:'$d(^DHCPB(myBill,"O",myOrd))
	
	s ArcimRowid=$p(^DHCPB(myBill,"O",myOrd),"^",3)

	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	s:ItemCatDR'="" CatDr=$p(^ARC("IC",ItemCatDR),"^",8)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2) ;名称
	
	;s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	;s Idx=$g(^TMP($ZN,$j,"D"))
	;s ^TMP($ZN,$j,"D",Idx)=$e($p($g(ArcimDesc),"-"),1,19)_"^"_"^"_"^"_"^"
	
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
	.s myUOMId=$p($g(^DHCTARI(myTarRowID)),"^",3)
	.i myUOMId'="" d
	..s PackUOM=$p($g(^CT("UOM",myUOMId)),"^",2)		;CTUOM_Desc
	.s PackQty=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",5)			;PBD_BillQty
	.s OrdTotSum=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",10)			; PBD_PatientShare
	.s OrdTotSum=$fn(OrdTotSum,"",2)
	.i +$g(^TMP($ZN,$j,"D"))<23 d
	..s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	..s Idx=$g(^TMP($ZN,$j,"D"))
	..;s myLen=+$l($p(myTarDesc,"-",1))
	..;$e(DrgDesc_$p($g(ArcimDesc),"-"),1,19)_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum
	..s ^TMP($ZN,$j,"D",Idx)=$e($g(myTarDesc),1,19)_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum
	.e  d
	..s ^TMP($ZN,$j,"D",23)="略...^^^^"
	
	q
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

ClassMethod GetOPPrtDataOrd(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
	;打印医嘱项明细
	Quit:$g(InvRowID)="" ""
	;
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
	
	;s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_myUserName
	s DetailStr=DetailStr_"^"_"PayMode"_$c(2)_PayMode
	s DetailStr=DetailStr_"^"_"InvNo"_$c(2)_myInvNo
	s DetailStr=DetailStr_"^"_"Year"_$c(2)_$p($zd(Date,3),"-")
	s DetailStr=DetailStr_"^"_"Month"_$c(2)_$p($zd(Date,3),"-",2)
	s DetailStr=DetailStr_"^"_"Day"_$c(2)_$p($zd(Date,3),"-",3)
	s DetailStr=DetailStr_"^"_"YBNo"_$c(2)_""			;医保号码
	;s DetailStr=DetailStr_"^"_"PTime"_$c(2)_$zt($p($h,",",2))

	;;医保支付信息
	s YBInfo=""
	s myINSDivDR=$p(^DHCINVPRT(SelectPrtDr),"^",30)			;
	i myINSDivDR'="" d
	.;调用医保信息接口
	.s myYBRtn=##Class(web.DHCINSUFacade).GetInsuDivideInf(myINSDivDR)
	.s YBYLTCNO=$p($g(myYBRtn),"^",1)
	.s YBInfo="YBYLTCNO"_$c(2)_YBYLTCNO
	.s YBInfo=YBInfo_"^"_"YBGRZFGD"_$c(2)_"个人自费"
	.s YBInfo=YBInfo_"^"_"YBGRZFUGD"_$c(2)_"个人自付"
	.s YBInfo=YBInfo_"^"_"YBGRZIFUGD"_$c(2)_"个人自负"
	.s YBInfo=YBInfo_"^"_"YBGRCDGD"_$c(2)_"个人承担"
	.s YBInfo=YBInfo_"^"_"YBDNGZGD"_$c(2)_"当年个帐"
	.s YBInfo=YBInfo_"^"_"YBTCJJGD"_$c(2)_"统筹基金"
	.s YBInfo=YBInfo_"^"_"YBLNGZGD"_$c(2)_"历年个帐"
	.s YBInfo=YBInfo_"^"_"YBGWYBZGD"_$c(2)_"公务员补助"
	.s YBInfo=YBInfo_"^"_"YBDNGZYEGD"_$c(2)_"当年个帐余额"
	.s YBInfo=YBInfo_"^"_"YBZFLJGD"_$c(2)_"自负累计"
	.s YBInfo=YBInfo_"^"_"YBLNGZYEGD"_$c(2)_"历年个帐余额"
	.s YBInfo=YBInfo_"^"_"YBEJYYGD"_$c(2)_"三级 医院"
	.;金额。。。。
	.s YBGRZFSum=$p($g(myYBRtn),"^",2)
	.s YBGRZFUSum=$p($g(myYBRtn),"^",3)
	.s YBGRZIFUSum=$p($g(myYBRtn),"^",4)
	.s YBGRCDSum=$p($g(myYBRtn),"^",5)
	.s YBDNGZSum=$p($g(myYBRtn),"^",6)
	.s YBTCJJSum=$p($g(myYBRtn),"^",7)
	.s YBLNGZSum=$p($g(myYBRtn),"^",8)
	.s YBGWYBZSum=$p($g(myYBRtn),"^",9)
	.s YBDNGZYESum=$p($g(myYBRtn),"^",10)
	.s YBZFLJSum=$p($g(myYBRtn),"^",11)
	.s YBLNGZYESum=$p($g(myYBRtn),"^",12)
	.s YBEJYYSum=$p($g(myYBRtn),"^",13)
	.
	.s YBInfo=YBInfo_"^"_"YBGRZFSum"_$c(2)_$fn(YBGRZFSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBGRZFUSum"_$c(2)_$fn(YBGRZFUSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBGRZIFUSum"_$c(2)_$fn(YBGRZIFUSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBGRCDSum"_$c(2)_$fn(YBGRCDSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBDNGZSum"_$c(2)_$fn(YBDNGZSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBTCJJSum"_$c(2)_$fn(YBTCJJSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBLNGZSum"_$c(2)_$fn(YBLNGZSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBGWYBZSum"_$c(2)_$fn(YBGWYBZSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBDNGZYESum"_$c(2)_$fn(YBDNGZYESum,"",2)
	.s YBInfo=YBInfo_"^"_"YBZFLJSum"_$c(2)_$fn(YBZFLJSum,"",2)
	.s YBInfo=YBInfo_"^"_"YBLNGZYESum"_$c(2)_$fn(YBLNGZYESum,"",2)
	.s YBInfo=YBInfo_"^"_"YBEJYYSum"_$c(2)_YBEJYYSum
	.
	.s DetailStr=DetailStr_"^"_YBInfo
	
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
	...d AddDWin(myPresNo)
	...d AddToDetails(Bill,Ord)
	...Set Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) Quit:Itm=""  Do
	....Set ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....Set TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....Set DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....Set PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....Set PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....;b	;GetInvoicePrtDetail
	....Do AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	
	b	;
	
	s prtTxtInfo=$$GetTxtInfo(SelectPrtDr)
	;w prtTxtInfo,!
	s prtListInfo=$$GetDetails()
	;w prtListInfo
	s prtTxtInfo=DetailStr_"^"_prtTxtInfo
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^TMP($ZN,$j)
	Quit "0"
	;
	;
AddToPLISTOrd(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
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
		.s ^TMP($ZN,$j,"CAT")=+$g(^TMP($ZN,$j,"CAT"))+1
		.s ^TMP($ZN,$j,"CAT",OPCatCode,"IDX")=$g(^TMP($ZN,$j,"CAT"))
	
	Quit
GetTxtInfoOrd(myPRTRowID)
	s OPCSInfo=""
	s myTxtInfo=""
	s myPatientShare=0
	s myIndex=0
	s myMTip="FBSum"
	s myFBTip="FB"
	f  s OPCSInfo=$o(^TMP($ZN,$j,"CAT",OPCSInfo)) q:OPCSInfo=""  d
	.s myIndex=myIndex+1
	.i myTxtInfo="" d
	..s myTxtInfo=myMTip_myIndex_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.e  d
	..s myTxtInfo=myTxtInfo_"^"_myMTip_myIndex_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.s myTxtInfo=myTxtInfo_"^"_myFBTip_myIndex_$c(2)_$p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",1)
	.s myPatientShare=+myPatientShare+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
	
	s myYBPaySum=+$p(^DHCINVPRT(myPRTRowID),"^",31)
	s Selfpay=+myPatientShare-myYBPaySum
	
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myPatientShare)
	s myRMBselfpay=##class(web.UDHCOPINVPrtIF).RMBConvert(Selfpay)
	s mypayinfo="PaySum"_$C(2)_myRMB_" "_$fn(myPatientShare,"",2)
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s mypayinfo="PaySumPY"_$C(2)_""_myRMB
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s myTxtInfo=myTxtInfo_"^"_"ListPaySum"_$c(2)_""_$fn(myPatientShare,"",2)
	s myTxtInfo=myTxtInfo_"^"_"CashSum"_$c(2)_myRMBselfpay_" "_$fn(Selfpay,"",2)
	b	;GetTxtInfo
	q myTxtInfo
AddDWinOrd(myPresNo)
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
	
	s myrtn=##class(web.DHCMZYFXTYW02).GetCurrWin(myCTLoc)
	;
	;
	s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	s Idx=$g(^TMP($ZN,$j,"D"))

	s ^TMP($ZN,$j,"D",Idx)=$p(myrtn,"^",3)_"^^^^"
	quit
	;
AddToDetailsOrd(myBill,myOrd)
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
	
GetDetailsOrd()
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

/// ////宁波明州医院发票打印
ClassMethod GetOPPrtDataOld(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
	;;w ##class(web.UDHCOPINVPrtIF).GetOPPrtData("", "INVPRT","51439","10534","","")
	;;w ##class(web.UDHCOPINVPrtData4).GetOPPrtData("","51439","UseID","PayMode")
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
	s myUserDR=$p(^DHCINVPRT(SelectPrtDr),"^",21)
	s myUserName=""
	i myUserDR'="" d
	.s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	
	Set DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Date"_$C(2)_$zd(Date,3)
	
	;s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_myUserName
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
	...;d AddDWin(myPresNo)
	...d AddToDetails(Bill,Ord)
	...Set Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) Quit:Itm=""  Do
	....Set ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....Set TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....Set DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....Set PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....Set PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....;b	;GetInvoicePrtDetail
	....Do AddToPLIST(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	
	b	;
	
	s prtTxtInfo=$$GetTxtInfo(SelectPrtDr)
	;w prtTxtInfo,!
	s prtListInfo=$$GetDetails()
	;w prtListInfo
	s prtTxtInfo=DetailStr_"^"_prtTxtInfo
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^TMP($ZN,$j)
	Quit "0"
	;
	;
AddToPLISTOld(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
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
		.s ^TMP($ZN,$j,"CAT")=+$g(^TMP($ZN,$j,"CAT"))+1
		.s ^TMP($ZN,$j,"CAT",OPCatCode,"IDX")=$g(^TMP($ZN,$j,"CAT"))
	
	Quit
GetTxtInfoOld()
	s OPCSInfo=""
	s myTxtInfo=""
	s myPatientShare=0
	s myIndex=0
	s myMTip="FBSum"
	s myFBTip="FB"
	f  s OPCSInfo=$o(^TMP($ZN,$j,"CAT",OPCSInfo)) q:OPCSInfo=""  d
	.s myIndex=myIndex+1
	.i myTxtInfo="" d
	..s myTxtInfo=myMTip_myIndex_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.e  d
	..s myTxtInfo=myTxtInfo_"^"_myMTip_myIndex_$C(2)_$fn($p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.s myTxtInfo=myTxtInfo_"^"_myFBTip_myIndex_$c(2)_$p($g(^TMP($ZN,$j,"CAT",OPCSInfo)),"^",1)
	.s myPatientShare=+myPatientShare+$p(^TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
	
	s mypayinfo="PaySum"_$C(2)_""_$fn(myPatientShare,"",2)
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myPatientShare)
	s mypayinfo="PaySumPY"_$C(2)_""_myRMB
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s myTxtInfo=myTxtInfo_"^"_"ListPaySum"_$c(2)_""_$fn(myPatientShare,"",2)
	s myTxtInfo=myTxtInfo_"^"_"CashSum"_$c(2)_""_$fn(myPatientShare,"",2)
	b	;GetTxtInfo
	q myTxtInfo
AddDWinOld(myPresNo)
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
AddToDetailsOld(myBill,myOrd)
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
	.;;;s $p(^TMP($ZN,$j,"D",HerbIdx),"^",2)=""去掉单价
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",2)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",3)=""
	.s $p(^TMP($ZN,$j,"D",HerbIdx),"^",4)=+$p($g(^TMP($ZN,$j,"D",HerbIdx)),"^",5)+OrdTotSum
	;HerbIdx
	
	;b  ;Herb
	q:((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItemCatDR_"^")))	;退出
	
	s ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
	s Idx=$g(^TMP($ZN,$j,"D"))
	
	;_Price_"^"
	s ^TMP($ZN,$j,"D",Idx)=$e(DrgDesc_$p($g(ArcimDesc),"-"),1,19)_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum
	quit
	
GetDetailsOld()
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
