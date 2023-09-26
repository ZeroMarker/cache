Class web.UDHCOPINVPrtData1 Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.UDHCOPINVPrtData1).GetOPPrtData("","6160","UseID","PayMode","118")
ClassMethod GetOPPrtData(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String, GroupDR As %String) As %String
{
	;;打印回执联的发票
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
	s myPayDiscSum=+$p(^DHCINVPRT(SelectPrtDr),"^",14)
	s myPatPaySum=+$p(^DHCINVPRT(SelectPrtDr),"^",14)
	Set DetailStr="PatName"_$C(2)_PatName_"^"_"RegNo"_$C(2)_PatNo_"^"_"Date"_$C(2)_$zd(Date,3)
	s DetailStr=DetailStr_"^"_"OpenID"_$c(2)_UseID
	s DetailStr=DetailStr_"^"_"PayMode"_$c(2)_PayMode
	s DetailStr=DetailStr_"^"_"InvNo"_$c(2)_myInvNo
	s DetailStr=DetailStr_"^"_"AdmDate"_$c(2)_$zd(Date,3)
	
	;s DetailStr=DetailStr_"^"_"PTime"_$c(2)_$zt($p($h,",",2))
	
	Kill ^||TMP($ZN,$j)
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
	..s ^||TMP($ZN,$j,"PBID",loctype,recdepDR,Bill_"||"_Ord)=""		;;;Index
	..s ^||TMP($ZN,$j,"PBO",Bill_"||"_Ord)=Bill_"^"_Ord_"^"_myPresNo_"^"_OrderType
	
	s myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(GroupDR)
	s myOrdItemFlag=$p(myBCInfo,"^",12)		;=1 时能够拆分
	s myOECStr=$p(myBCInfo,"^",13)			;医嘱大类的
	
	;
	s myLocType=""
	f  s myLocType=$o(^||TMP($ZN,$j,"PBID",myLocType)) q:myLocType=""  d
	.s myRecDR=""
	.f  s myRecDR=$o(^||TMP($ZN,$j,"PBID",myLocType,myRecDR)) q:myRecDR=""  d
	..s myPBORID=""
	..f  s myPBORID=$o(^||TMP($ZN,$j,"PBID",myLocType,myRecDR,myPBORID)) q:myPBORID=""  d
	...;s OrdDr=$p(^DHCPB(Bill,"O",Ord),"^",3)
	...s Bill=+myPBORID
	...s Ord=$p(myPBORID,"||",2)
	...s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s Arcim=$p(^DHCPB(Bill,"O",Ord),"^",3)
	...s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	...s myOECatRowID=$p(^ARC("IC",ItemCatDR),"^",8)		;ARC_ItemCat->ARCIC_OrdCat_DR
	...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	...;d AddDWin(myPresNo, SelectPrtDr)
	...d AddToDetails(Bill, Ord)
	...Set Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) Quit:Itm=""  Do
	....Set ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....Set TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....Set DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....Set PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....Set PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....;b	;GetInvoicePrtDetail
	....s myTMPOrdItem="Item"
	....i ((+myOrdItemFlag=1)&(($c(2)_myOECStr_$c(2))[($c(2)_myOECatRowID_$c(2)))) d
	.....s myTMPOrdItem=myPBORID
	....Do AddToPLIST(ItmDr,myRecDR,TotalAmount,DiscAmount,PatientShare,PayorShare, myPresNo, SelectPrtDr, myTMPOrdItem)
		
	;s prtTxtInfo=$$GetTxtInfo(PatName,myInvNo)
	s prtTxtInfo=$$GetTxtInfoForItem(PatName,myInvNo, InvRowID)
	
	s prtListInfo=$$GetDetails()
	;s prtListInfo=""
	s prtTxtInfo=DetailStr_"^"_prtTxtInfo
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^||TMP($ZN,$j)
	Quit "0"
	;
	;
AddToPLIST(ItmDr, RecLocDR, TotalAmount,DiscAmount,PatientShare,PayorShare, PresNo, INVPRTRowID, ItemSFlag)
	n (ItmDr,RecLocDR, TotalAmount,DiscAmount,PatientShare,PayorShare, PresNo, INVPRTRowID, ItemSFlag)
	Quit:$g(ItmDr)="" 
	Set ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	s ItmSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	Quit:$g(ItmOPSubCat)=""
	Set ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	Quit:$g(ItmOPCat)=""
	s OPCatCode=$p(^DHCTarC("TOC",ItmOPCat),"^",1)
	Set OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	s RecLocDesc=""
	i RecLocDR'="" s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
	i $l(RecLocDesc,"-")>1 s RecLocDesc=$p(RecLocDesc,"-",2)
	;在此解析成票据格式?ItmOPCat
	;Add Loc
	if $D(^||TMP($ZN,$j,"CAT",OPCatCode)) Do
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",1)=OPCatDesc
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",2)=$p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",2)+TotalAmount
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",3)=$p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",3)+DiscAmount
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",4)=$p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",4)+PatientShare
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",5)=$p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",5)+PayorShare
	.;Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",5)=RecLocDesc
	Else  Do
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",1)=OPCatDesc
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",2)=TotalAmount
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",3)=DiscAmount
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",4)=PatientShare
	.Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",5)=PayorShare
	.;Set $p(^||TMP($ZN,$j,"CAT",OPCatCode),"^",5)=RecLocDesc
	;

	s $p(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR),"^",1)=ItmSubCatDesc
	s $p(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR),"^",2)=RecLocDesc
	s $p(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR),"^",3)=+$p($g(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR)),"^",3)+TotalAmount
	s $p(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR),"^",4)=+$p($g(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR)),"^",4)+DiscAmount
	s $p(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR),"^",5)=+$p($g(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR)),"^",5)+PatientShare
	s $p(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR),"^",6)=+$p($g(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR)),"^",6)+PayorShare	
	s $p(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR),"^",7)=PresNo
	s $p(^||TMP($ZN,$j,"SubRec",ItmOPSubCat,RecLocDR),"^",8)=INVPRTRowID
	
	;按照项目定义TMP
	;s ^||TMP($ZN, $j, "RecSubItem",ItmOPSubCat,RecLocDR, ItemSFlag)=""
	s $p(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag),"^",1)=ItmSubCatDesc
	s $p(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag),"^",2)=RecLocDesc
	s $p(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag),"^",3)=+$p($g(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag)),"^",3)+TotalAmount
	s $p(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag),"^",4)=+$p($g(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR, ItemSFlag)),"^",4)+DiscAmount
	s $p(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag),"^",5)=+$p($g(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR, ItemSFlag)),"^",5)+PatientShare
	s $p(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag),"^",6)=+$p($g(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR, ItemSFlag)),"^",6)+PayorShare	
	s $p(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag),"^",7)=PresNo
	s $p(^||TMP($ZN,$j,"RecSubItem",ItmOPSubCat,RecLocDR,ItemSFlag),"^",8)=INVPRTRowID
	
	Quit
AddToRtnUnit(ItmDr,TotalAmount,DiscAmount,PatientShare,PayorShare)
	
	quit
GetTxtInfoForItem(PatName,InvNo, InvRowID)
	;提供给打印发票的单个计费项的
	n (PatName,InvNo, InvRowID)
	
	s OPCSInfo=""
	s myTxtInfo=""
	s myPatientShare=0
	s myTSum=0
	
	f  s OPCSInfo=$o(^||TMP($ZN,$j,"CAT",OPCSInfo)) q:OPCSInfo=""  d
	.i myTxtInfo="" d
	..s myTxtInfo=OPCSInfo_$C(2)_$fn($p($g(^||TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.e  d
	..s myTxtInfo=myTxtInfo_"^"_OPCSInfo_$C(2)_$fn($p($g(^||TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.s myPatientShare=+myPatientShare+$p(^||TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
	.s myTSum=+myTSum+$p(^||TMP($ZN,$j,"CAT",OPCSInfo),"^",2)
	
	
	s mypayinfo="PaySum"_$C(2)_""_$fn(myTSum,"",2)
	s myRoundSum=+$p(^DHCINVPRT(InvRowID),"^",37)
	
	s mypayinfo=mypayinfo_"^"_"PayDiscSum"_$c(2)_$fn(+myTSum-myPatientShare,"",2)
	s mypayinfo=mypayinfo_"^"_"PatPaySum"_$c(2)_$fn(myPatientShare+myRoundSum,"",2)
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myPatientShare+myRoundSum)
	s mypayinfo="PatPaySumPY"_$C(2)_""_myRMB
	s myTxtInfo=myTxtInfo_"^"_mypayinfo
	
	;b		;;打印回执联；
	;打印回执联；
	;PatName  Item   Rloc   CurColFee    PaySum   Date   InvNo
	s myIdx=0
	s myRtnUnit=""
	s myCurDate=$zd(+$h,3)
	i $d(^||TMP($ZN,$j,"RecSubItem")) d
	.s mySubCatDR=""
	.f  s mySubCatDR=$o(^||TMP($ZN,$j,"RecSubItem", mySubCatDR)) q:(mySubCatDR="")  d
	..s myRecLocDR=""
	..f  s myRecLocDR=$o(^||TMP($ZN,$j,"RecSubItem", mySubCatDR, myRecLocDR)) q:(myRecLocDR="")  d
	...s myItemFlagDR=""
	...f  s myItemFlagDR=$o(^||TMP($ZN,$j,"RecSubItem", mySubCatDR, myRecLocDR, myItemFlagDR)) q:(myItemFlagDR="")  d
	....s myIdx=+myIdx+1
	....i myRtnUnit="" d
	.....s myRtnUnit="Item"_myIdx_$c(2)_$p(^||TMP($ZN,$j,"RecSubItem",mySubCatDR,myRecLocDR,myItemFlagDR),"^",1)
	....e  d
	.....s myRtnUnit=myRtnUnit_"^Item"_myIdx_$c(2)_$p(^||TMP($ZN,$j,"RecSubItem",mySubCatDR,myRecLocDR, myItemFlagDR),"^",1)
	....s myRtnUnit=myRtnUnit_"^PatName"_myIdx_$c(2)_PatName
	....s myRtnUnit=myRtnUnit_"^Rloc"_myIdx_$c(2)_$p(^||TMP($ZN,$j,"RecSubItem",mySubCatDR,myRecLocDR, myItemFlagDR),"^",2)
	....s mySubFee=$p(^||TMP($ZN,$j,"RecSubItem",mySubCatDR,myRecLocDR, myItemFlagDR),"^",3)
	....s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(mySubFee)
	....s myRtnUnit=myRtnUnit_"^CurColFee"_myIdx_$c(2)_$p(^||TMP($ZN,$j,"RecSubItem",mySubCatDR,myRecLocDR, myItemFlagDR),"^",3)
	....s myRtnUnit=myRtnUnit_"^PaySum"_myIdx_$c(2)_myRMB
	....s myRtnUnit=myRtnUnit_"^Date"_myIdx_$c(2)_myCurDate
	....s myRtnUnit=myRtnUnit_"^InvNo"_myIdx_$c(2)_InvNo
	....s myPresNo=$p($g(^||TMP($ZN,$j,"RecSubItem",mySubCatDR,myRecLocDR, myItemFlagDR)),"^",7)
	....s myInvRowID=$p($g(^||TMP($ZN,$j,"RecSubItem",mySubCatDR,myRecLocDR, myItemFlagDR)),"^",8)
	....s myPHWin=$$AddDWin(myPresNo, myInvRowID)
	....s myRtnUnit=myRtnUnit_"^PHWin"_myIdx_$c(2)_myPHWin
	
	s myTxtInfo=myTxtInfo_"^"_myRtnUnit
	
	q myTxtInfo

GetTxtInfo(PatName,InvNo)
	n (PatName,InvNo)
	
	s OPCSInfo=""
	s myTxtInfo=""
	s myPatientShare=0
	s myTSum=0
	f  s OPCSInfo=$o(^||TMP($ZN,$j,"CAT",OPCSInfo)) q:OPCSInfo=""  d
	.i myTxtInfo="" d
	..s myTxtInfo=OPCSInfo_$C(2)_$fn($p($g(^||TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.e  d
	..s myTxtInfo=myTxtInfo_"^"_OPCSInfo_$C(2)_$fn($p($g(^||TMP($ZN,$j,"CAT",OPCSInfo)),"^",4),"",2)
	.s myPatientShare=+myPatientShare+$p(^||TMP($ZN,$j,"CAT",OPCSInfo),"^",4)
	.s myTSum=+myTSum+$p(^||TMP($ZN,$j,"CAT",OPCSInfo),"^",2)
	
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
	i $d(^||TMP($ZN,$j,"SubRec")) d
	.s mySubCatDR=""
	.f  s mySubCatDR=$o(^||TMP($ZN,$j,"SubRec", mySubCatDR)) q:(mySubCatDR="")  d
	..s myRecLocDR=""
	..f  s myRecLocDR=$o(^||TMP($ZN,$j,"SubRec", mySubCatDR, myRecLocDR)) q:(myRecLocDR="")  d
	...s myIdx=+myIdx+1
	...i myRtnUnit="" d
	....s myRtnUnit="Item"_myIdx_$c(2)_$p(^||TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",1)
	...e  d
	....s myRtnUnit=myRtnUnit_"^Item"_myIdx_$c(2)_$p(^||TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",1)
	...s myRtnUnit=myRtnUnit_"^PatName"_myIdx_$c(2)_PatName
	...s myRtnUnit=myRtnUnit_"^Rloc"_myIdx_$c(2)_$p(^||TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",2)
	...s mySubFee=$p(^||TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",3)
	...s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(mySubFee)
	...s myRtnUnit=myRtnUnit_"^CurColFee"_myIdx_$c(2)_$p(^||TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR),"^",3)
	...s myRtnUnit=myRtnUnit_"^PaySum"_myIdx_$c(2)_myRMB
	...s myRtnUnit=myRtnUnit_"^Date"_myIdx_$c(2)_myCurDate
	...s myRtnUnit=myRtnUnit_"^InvNo"_myIdx_$c(2)_InvNo
	...s myPresNo=$p($g(^||TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR)),"^",7)
	...s myInvRowID=$p($g(^||TMP($ZN,$j,"SubRec",mySubCatDR,myRecLocDR)),"^",8)
	...s myPHWin=$$AddDWin(myPresNo, myInvRowID)
	...s myRtnUnit=myRtnUnit_"^PHWin"_myIdx_$c(2)_myPHWin
	
	s myTxtInfo=myTxtInfo_"^"_myRtnUnit
	
	q myTxtInfo
AddDWin(myPresNo,InvRowID)
	n (myPresNo, InvRowID)
	
	s myWinDR=""
	s myCTLoc=""
	s UseFlag=0
	q:myPresNo="" ""
	Q:$d(^DHCPHARi("PRT",InvRowID))=0 ""
	f  s myWinDR=$o(^DHCPHARi("PRT",InvRowID,myWinDR)) q:myWinDR=""  d
	.q:myPresNo'=$p($g(^DHCPHARW(myWinDR)),"^",16)
	.q:UseFlag=1
	.s myphloc=$p($g(^DHCPHARW(myWinDR)),"^",3)
	.q:myphloc=""
	.s myCTLoc=$p(^DHCPHLOC(myphloc),"^",1)
	.s myCount=+$g(^||TMP($ZN,$j,"WD"))
	.f i=1:1:myCount  d
	..i $g(^||TMP($ZN,$j,"WD",i))=myCTLoc  d
	...s UseFlag=1
	
	q:UseFlag=1 ""
	q:myCTLoc="" ""
	
	s ^||TMP($ZN,$j,"WD")=$g(^||TMP($ZN,$j,"WD"))+1
	s Idx=$g(^||TMP($ZN,$j,"WD"))
	s ^||TMP($ZN,$j,"WD",Idx)=myCTLoc
	
	s ^||TMP($ZN,$j,"D")=$g(^||TMP($ZN,$j,"D"))+1
	s Idx=$g(^||TMP($ZN,$j,"D"))

	s ^||TMP($ZN,$j,"D",Idx)=$p(myrtn,"^",3)_"^^^^"
	
	quit $p(myrtn,"^",3)

AddToDetails(myBill, myOrd)
	n (myBill, myOrd)
	
	s PBOData=$g(^DHCPB(myBill,"O",myOrd))
	q:(PBOData="")
	
	s Arcim=$p(PBOData,"^",3)
	s OEIMDR=$p(PBOData,"^",4)
	s myOEDate=$p(PBOData,"^",12)	;PBO_OrderDate
	s:(myOEDate'="") myOEDate=$zd(myOEDate,3)
	
	s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	s ArcimDesc=$p($g(^ARCIM(+Arcim,1,1)),"^",2) ;名称
	
	s DrgDesc=""
	
	s PackUOM=##class(web.DHCBillCommon).GetPackUom(Arcim, OEIMDR)

	s Price=$p(PBOData,"^",7)	
	
	s ConFac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEIMDR)
	s PackQty=$p(PBOData,"^",5)
	s refundqty=$p(PBOData,"^",6)
	s PackQty=PackQty+refundqty
	q:(+PackQty=0)
	s PackQty=PackQty/ConFac
	s Price=$fn(Price*ConFac,"",4)
	
	s OrdPatSum=$fn($p(PBOData,"^",11),"",2)
	s OrdTotSum=$fn($p(PBOData,"^",8),"",2)
	
	i ((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItemCatDR_"^"))) d
	.;属于草药?
	.i HerbIdx=0 d
	..s ^||TMP($ZN,$j,"D")=$g(^||TMP($ZN,$j,"D"))+1
	..s HerbIdx=$g(^||TMP($ZN,$j,"D"))
	.s $p(^||TMP($ZN,$j,"D",HerbIdx),"^",1)=FCHerbDesc
	.s $p(^||TMP($ZN,$j,"D",HerbIdx),"^",2)=""
	.s $p(^||TMP($ZN,$j,"D",HerbIdx),"^",3)=""
	.s $p(^||TMP($ZN,$j,"D",HerbIdx),"^",4)=""
	.s $p(^||TMP($ZN,$j,"D",HerbIdx),"^",5)=+$p($g(^||TMP($ZN,$j,"D",HerbIdx)),"^",5)+OrdTotSum
	.s $p(^||TMP($ZN,$j,"D",HerbIdx),"^",6)=""
	;HerbIdx
	
	q:((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItemCatDR_"^")))
	
	s ^||TMP($ZN,$j,"D")=$g(^||TMP($ZN,$j,"D"))+1
	s Idx=$g(^||TMP($ZN,$j,"D"))
	
	s ^||TMP($ZN,$j,"D",Idx)=$e(DrgDesc_$p($g(ArcimDesc),"-"),1,19)_"^"_Price_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum_"^"_myOEDate
	quit
	
GetDetails()
	s myidx=""
	s myList=""
	f  s myidx=$o(^||TMP($ZN,$j,"D",myidx)) q:myidx=""  d
	.i myList="" d
	..s myList=^||TMP($ZN,$j,"D",myidx)
	.e  d
	..s myList=myList_""_$c(2)_^||TMP($ZN,$j,"D",myidx)
	;s myList=myList_""_$c(2)_"备注:   # 无自付;   & 有自付;   * 全自付;^^^^"
	q myList
}

/// 设置一张发票的^TMP
/// w ##class(web.UDHCOPINVPrtData1).SetINVPrtPLISTData("1363")
ClassMethod SetINVPrtPLISTData(InvRowID As %String) As %String
{
	n (InvRowID)
	s SelectPrtDr=InvRowID
	;获取中草药配制
	s myHospDR=$p(^DHCINVPRT(SelectPrtDr),"^",39)
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig(myHospDR)
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	
	;Add an Index for RecLoc
	s INVLinkDr=0
	f  s INVLinkDr=$o(^DHCBCI(0,"INV",SelectPrtDr,INVLinkDr)) q:(INVLinkDr="")  d
	.s Bill=$p(^DHCBCI(INVLinkDr),"^",2)
	.q:'$d(^DHCPB(Bill))
	.s Ord=0
	.f  s Ord=$o(^DHCPB(Bill,"O",Ord)) q:(Ord="")  d
	..q:($d(^DHCPB(Bill,"O",Ord))=10)		;;zhao防止错误?
	..s Prescno=""
	..s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	..s Arcim=$p(^DHCPB(Bill,"O",Ord),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	..s recdepDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),3)),"^",6) ;接收科室
	..s loctype=$p(^CTLOC(recdepDR),"^",13) 
	..i (loctype="") s loctype="Z"	;放在最后?
	..;增加一个小票节点
	..s ^||TMP($ZN,$j,InvRowID,"PBID",loctype,recdepDR,Bill_"||"_Ord)=""
	..s ^||TMP($ZN,$j,InvRowID,"PBO",Bill_"||"_Ord)=Bill_"^"_Ord_"^"_myPresNo_"^"_OrderType
		
	s myLocType=""
	f  s myLocType=$o(^||TMP($ZN,$j,InvRowID,"PBID",myLocType)) q:(myLocType="")  d
	.s myRecDR=""
	.f  s myRecDR=$o(^||TMP($ZN,$j,InvRowID,"PBID",myLocType,myRecDR)) q:(myRecDR="")  d
	..s myPBORID=""
	..f  s myPBORID=$o(^||TMP($ZN,$j,InvRowID,"PBID",myLocType,myRecDR,myPBORID)) q:(myPBORID="")  d
	...;s OrdDr=$p(^DHCPB(Bill,"O",Ord),"^",3)
	...s Bill=+myPBORID
	...s Ord=$p(myPBORID,"||",2)
	...s OEIMDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
	...;d AddDWin(myPresNo, InvRowID)
	...d AddToDetails(Bill, Ord)
	...s Itm=0 
	...f  s Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:(Itm="")  d
	....s ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....s TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....s DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....s PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....s PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)
	....s myOrdSDR=myPBORID
	....d AddToPLIST(ItmDr, myRecDR, TotalAmount, DiscAmount, PatientShare, PayorShare, myPresNo, InvRowID, myOrdSDR)
	
	q rtn
}

/// Creator: fuh
/// CreatDate: 2019-11-22
/// Modify: ZhYW
/// Description: 获取门诊收据证明打印信息
/// Input: InvRowID:发票id, PRTFlag:类型
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCOPINVPrtData1","HospOPPatPrt","22","API")
Query HospOPPatPrt(InvRowID As %String, PRTFlag As %String) As websys.Query(ROWSPEC = "PatName:%String,InvNo:%String,InvDate:%String,InvTime:%String,CateDesc1:%String,CateAmt1:%Float,CateDesc2:%String,CateAmt2:%Float,CateDesc3:%String,CateAmt3:%Float") [ SqlProc ]
{
}

ClassMethod HospOPPatPrtExecute(ByRef qHandle As %Binary, InvRowID As %String, PRTFlag As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("HospOPPatPrt")=$lb(InvRowID, PRTFlag)
	kill ^||TMP($ZN,$j)

	if (InvRowID="") quit $$$OK
		
	if (PRTFlag="PRT") do
	.//DHC_INVPRT
	.set invDate=$p($g(^DHCINVPRT(InvRowID)),"^",5)
	.set invDate=$zd(invDate,3)
	.set invTime=$p($g(^DHCINVPRT(InvRowID)),"^",20)
	.set invTime=$zt(invTime,1)
	.set papmi=$p($g(^DHCINVPRT(InvRowID)),"^",15)
	.set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	.set invNo=$p($g(^DHCINVPRT(InvRowID)),"^",14)
	.do ..SetINVPrtPLISTData(InvRowID)
	else  do
	.//DHC_AccPayINV
	.set invDate=$p(^DHCINVPRTAP(InvRowID),"^",3)
	.set invDate=$zd(invDate,3)
	.set invTime=$p(^DHCINVPRTAP(InvRowID),"^",4)
	.set invTime=$zt(invTime,1)
	.set papmi=$p(^DHCINVPRTAP(InvRowID),"^",11)
	.set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	.set invNo=$p(^DHCINVPRTAP(InvRowID),"^",6)
	.set myACPRowID=0
	.for  set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",InvRowID,myACPRowID)) quit:(myACPRowID="")  do
	..set myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	..quit:(myPRTRowID="")
	..do ..SetINVPrtPLISTData(myPRTRowID)
	
	set cateColNum=3   //分栏数
	set maxCateDR=$o(^||TMP($ZN,$j,"CAT",""),-1)
	set num=0
	set idx=0
	for  set idx=$o(^||TMP($ZN,$j,"CAT",idx)) quit:(idx="")  do
	.set cateDesc=$p($g(^||TMP($ZN,$j,"CAT",idx)),"^",1)
	.set amt=$p($g(^||TMP($ZN,$j,"CAT",idx)),"^",4)
	.set amt=$fn(amt,"",2)
	.set num=$i(num)
	.set mod=num#cateColNum
	.set cateDescAry($case(mod, 0:cateColNum, :mod))=cateDesc
	.set cateFeeAry($case(mod, 0:cateColNum, :mod))=amt
	.if ((mod=0)||(idx=maxCateDR)) do
	..do OutputCateFee
	..do InitCateFee
	
	kill ^||TMP($ZN,$j)
	
	quit $$$OK
	
InitCateFee
	kill cateDescAry
	kill cateFeeAry
	quit
OutputCateFee
	set Data=$lb(patName,invNo,invDate,invTime,cateDescAry(1),cateFeeAry(1),cateDescAry(2),cateFeeAry(2),cateDescAry(3),cateFeeAry(3))
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: fuh
/// CreatDate: 2019-11-22
/// Modify: ZhYW
/// Description: 获取门诊收据证明打印信息
/// Input: InvRowID:发票id, PRTFlag:类型
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCOPINVPrtData1","HospOPPatPrtList","7774","PRT")
Query HospOPPatPrtList(InvRowID As %String, PRTFlag As %String) As websys.Query(ROWSPEC = "ItmDesc:%String,ItmPrice:%String,PackQty:%String,PackUOM:%String,ItmTotalAmt:%Float") [ SqlProc ]
{
}

ClassMethod HospOPPatPrtListExecute(ByRef qHandle As %Binary, InvRowID As %String, PRTFlag As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    set ^TMP("HospOPPatPrtList")=$lb(InvRowID, PRTFlag)
	if (InvRowID="") quit $$$OK

	kill ^||TMP($ZN,$j)

	if (PRTFlag="PRT") do
	.//DHC_INVPRT
	.do ..GetPrtFeeDetail(InvRowID)
	else  do
	.//DHC_AccPayINV
	.set myACPRowID=0
	.for  set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",InvRowID,myACPRowID)) quit:(myACPRowID="")  do
	..set myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	..quit:(myPRTRowID="")
	..do ..GetPrtFeeDetail(myPRTRowID)
	
	set idx="0"
	for  set idx=$o(^||TMP($ZN,$j,"D",idx)) quit:(idx="")  do
	.set ItmDesc=$p($g(^||TMP($ZN,$j,"D",idx)),"^",1)
	.set ItmPrice=$p($g(^||TMP($ZN,$j,"D",idx)),"^",2)
	.set ItmPrice=$fn(ItmPrice,"",4)
	.set PackQty=$p($g(^||TMP($ZN,$j,"D",idx)),"^",3)
	.set PackQty=$fn(PackQty,"N")
	.set PackUOM=$p($g(^||TMP($ZN,$j,"D",idx)),"^",4)
	.set ItmTotalAmt=$p($g(^||TMP($ZN,$j,"D",idx)),"^",5)
	.set ItmTotalAmt=$fn(ItmTotalAmt,"",2)
	.do OutputOrdList
    
    kill ^||TMP($ZN,$j)
    
	quit $$$OK
OutputOrdList
	set Data=$lb(ItmDesc,ItmPrice,PackQty,PackUOM,ItmTotalAmt)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

ClassMethod GetPrtFeeDetail(prtRowId As %String)
{
	new (prtRowId)
	
	set idx=0
	
	//DHC_BillConINV
	set billConInvId="0"			
	for  set billConInvId=$o(^DHCBCI(0,"INV",prtRowId,billConInvId)) quit:(billConInvId="")  do
	.quit:($d(^DHCBCI(billConInvId))=10)
	.set pb=$p($g(^DHCBCI(billConInvId)),"^",2)			//DHCBCI_PatBillDR
	.set pbo="0"
	.for  set pbo=$o(^DHCPB(pb,"O",pbo)) quit:(pbo="")  do
	..quit:($d(^DHCPB(pb,"O",pbo))=10)
	..do AddItmToDetails(pb, pbo)
	
	quit
AddItmToDetails(pb, pbo)
	set pboInfo=$g(^DHCPB(pb,"O",pbo))
	quit:(pboInfo="")
	set OEIMDR=$p(pboInfo,"^",4)
	
	set pbd=0
	for  set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd)) quit:(pbd="")  do
	.set pbdInfo=$g(^DHCPB(pb,"O",pbo,"D",pbd))
	.quit:(pbdInfo="")
	.set myTarRowID=$p(pbdInfo,"^",3)	        //PBD_TARI_DR
	.quit:(myTarRowID="")
	.set myTarDesc=$p($g(^DHCTARI(myTarRowID)),"^",2)
	.set myUnitPrice=$p(pbdInfo,"^",4)		    //PBD_UnitPrice
	.set myUnitPrice=$fn(myUnitPrice,"",4)
	.set PackQty=$p(pbdInfo,"^",5)			    //PBD_BillQty
	.quit:(+PackQty=0)
	.//set OrdTotSum=$p(pbdInfo,"^",7)		    //PBD_TotalAmount
	.set OrdTotSum=$p(pbdInfo,"^",10)			//PBD_PatientShare
	.set OrdTotSum=$fn(OrdTotSum,"",2)
	.set PackUOMDR=$p($g(^DHCTARI(myTarRowID)),"^",3)
	.set PackUOM=$s((+PackUOMDR'=0):$p($g(^CT("UOM",PackUOMDR)),"^",2),1:"")
	.set dspbDR=$p(pbdInfo,"^",27)
	.if (dspbDR'="") do
	..set dspbInfo=$g(^DHCOEDISQTY(+dspbDR,"I",$p(dspbDR,"||",2)))
	..quit:(dspbInfo="")
	..set inci=$p(dspbInfo,"^",5)
	..set myTarDesc=$s((+inci'=0):$p(^INCI(inci,1),"^",2),1:myTarDesc)
	..set baseUomDR=$s((+inci'=0):$p(^INCI(inci,1),"^",10),1:"")    //库存项基本单位
	..set outUomDR=$s((+inci'=0):$p(^INCI(inci,1),"^",12),1:"")     //门诊药品取门诊发药单位
	..set dispUomDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),"DHC")),"^",13)     //协议包装单位
	..set uomDR=""
	..if (dispUomDR'="") do
	...set uomDR=dispUomDR
	..else  do
	...if (outUomDR'="") do
	....set uomDR=outUomDR
	...else  do
	....set uomDR=baseUomDR
	..set PackUOM=$s((+uomDR'=0):$p($g(^CT("UOM",uomDR)),"^",2),1:"")
	..set ConFac=##class(PHA.FACE.OUT.Com).UOMFac(uomDR, baseUomDR)
	..set PackQty=PackQty/ConFac
	.set ^||TMP($ZN,$j,"D",$i(idx))=myTarDesc_"^"_myUnitPrice_"^"_PackQty_"^"_PackUOM_"^"_OrdTotSum
	
	quit
}

}
