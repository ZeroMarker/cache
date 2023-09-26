Class web.DHCOPBillFoot Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod FindFootDetailExecute(ByRef qHandle As %Binary, StDate As %String, EdDate As %String, HandInFlag As %String, FootInFlag As %String, RepID As %String, TypeDr As %String, DocType As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s GuserGroup=$g(GuserGroup)
    //i StDate=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    s CurUserId=$G(%session.Data("LOGON.USERID"))
    k ^DHCOPBill("FootDetail",CurUserId)
    k ^TMP("ZYJF","FootInv",CurUserId)
    k ^DHCOPBill("FootCate",CurUserId)
    k ^DHCOPBill("FootNormalCate",CurUserId)
    k ^DHCOPBill("FootAbortCate",CurUserId)
    k ^DHCOPBill("FootStrikeCate",CurUserId)
    s DetailNum=1,FootInvNum=1
    s ind=1
    if HandInFlag="on"  d
    .i RepID'=""  d
    ..f RepDate=StDate:1:EdDate  d
	...s RepID="0"
	...f  s RepID=$o(^DHCOPInsFootI(0,"Date",RepDate,RepID)) q:RepID=""  d
	....s FootUser=$p(^DHCOPInsFoot(RepID),"^",15)
	....q:((FootUser="")&&(FootInFlag="on"))
	....q:((FootUser'="")&&(FootInFlag'="on"))
	....s PrtRowid="0"
	....f  s PrtRowid=$o(^DHCINVPRT(0,"Report",RepID,PrtRowid)) q:PrtRowid=""  d
	.....d GetInvDetail(PrtRowid,HandInFlag)
	.e  d
	..s FootUser=$p(^DHCOPInsFoot(RepID),"^",15)
	..q:((FootUser="")&&(FootInFlag="on"))
	..q:((FootUser'="")&&(FootInFlag'="on"))
	..s PrtRowid="0"
	..f  s PrtRowid=$o(^DHCINVPRT(0,"Report",RepID,PrtRowid)) q:PrtRowid=""  d
	...d GetInvDetail(PrtRowid,HandInFlag)
	if HandInFlag'="on"  d
	.f PrtDate=StDate:1:EdDate  d
	.s PrtRowid="0"
	.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",RepID,PrtRowid)) q:PrtRowid=""  d
	..d GetInvDetail(PrtRowid,HandInFlag)
GetInvDetail(PrtRowid,HandInFlag)
	s invInfo=$g(^DHCINVPRT(PrtRowid))
    s prtfairtype=$p(invInfo,"^",34)
    s amt=$p(invInfo,"^",1)
    s prtuser=$p(invInfo,"^",21)
    s prtdate=$p(invInfo,"^",5)
    s handin=$p(invInfo,"^",10)
    q:((HandInFlag="on")&&(handin'="Y"))
    q:((HandInFlag'="on")&&(handin="Y"))
    s:prtdate'="" prtdate=$zd(prtdate,3)
    s prttime=$p(invInfo,"^",20)
    s:prttime'="" prttime=$zt(prttime)
    s flag=$p(invInfo,"^",8)
    i flag="N"  s flag="正常"
    i flag="A"  s flag="作废"
    i flag="S"  s flag="红冲"
    s invno=""
    s invno=$p(invInfo,"^",14)  
    i ((flag'="红冲")&&(invno'=""))  d
    .i ^TMP("ZYJF","FootInv",CurUserId,FootInvNum)=invno
    .s FootInvNum=FootInvNum+1
    s initinv=$p(invInfo,"^",13)
    i initinv'=""  s initinv=$p(^DHCINVPRT(initinv),"^",14)
    //s ^DHCOPBill("FootDetail",CurUserId,prtuser,DetailNum)=""
    s DetailNum=DetailNum+1
    s BilConInv="0"
	f  s BilConInv=$o(^DHCBCI(0,"INV",PrtRowid,BilConInv)) q:BilConInv=""  d
	.s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	.s PBAmt=$p(^DHCPB(PatBillDr),"^",8)
	.s PatAdm=$p(^DHCBCI(BilConInv),"^",3) 
	.q:'$D(^DHCPB(PatBillDr))
	.s Ord="" f  s Ord=$o(^DHCPB(PatBillDr,"O",Ord)) q:Ord=""  d
	..s Itm=0 f  s Itm=$o(^DHCPB(PatBillDr,"O",Ord,"D",Itm)) q:Itm=""  d
	...s ItmDr=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",3)
	...s TotalAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",7)
	...s DiscAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",8)
	...s PayorShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",9)
	...s PatientShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",10)	
	...s ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	...q:$g(ItmOPSubCat)=""
	...s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	...S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	...q:$g(ItmOPCat)=""
	...s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	...s ^DHCOPBill("FootCate",CurUserId,OPCatDesc)=+TotalAmount++($g(^DHCOPBill("FootCate",CurUserId,OPCatDesc)))
    ...i (amt>0)  s ^DHCOPBill("FootNormalCate",CurUserId,OPCatDesc)=+TotalAmount++($g(^DHCOPBill("FootNormalCate",CurUserId,OPCatDesc)))
    ...i ((flag'="红冲")&&(amt<0))  s ^DHCOPBill("FootAbortCate",CurUserId,OPCatDesc)=+TotalAmount++($g(^DHCOPBill("FootAbortCate",CurUserId,OPCatDesc)))
    ...i ((flag="红冲")&&(amt<0))  s ^DHCOPBill("FootStrikeCate",CurUserId,OPCatDesc)=+TotalAmount++($g(^DHCOPBill("FootStrikeCate",CurUserId,OPCatDesc)))
    Do OutputRow  
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(paymode,paymdr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFootDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFootDetailExecute ]
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
	Quit $$$OK
}

ClassMethod FindFootDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFootDetailExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindFootDetail(StDate As %String, EdDate As %String, HandInFlag As %String, FootInFlag As %String, RepID As %String, TypeDr As %String, DocType As %String) As %Query(ROWSPEC = "paymode:%String,rowid:%String")
{
}

ClassMethod GetDaiylDetailByDate(StDate, EndDate, GuserId)
{
	//w ##class(web.DHCOPBillDaiylDetail).GetDaiylDetailByDate("13/07/2008","16/07/2008","1")
	k ^DHCOPBill("FootCate",GuserId)
	k ^DHCOPBill("HZRepPayMode",GuserId)
	k ^DHCOPBill("HZAllRepCate",GuserId)
	k ^DHCOPBill("HZInsuRepCate",GuserId)
	k ^DHCOPBill("HZAllRepPayMode",GuserId)
	k ^DHCOPBill("HZInsuRepPayMode",GuserId)
	q:((StDate="")||(EndDate="")) "0"
	s CTSum=0
	i StDate["/"  s StDate=$zdh(StDate,4)
	i EndDate["/"  s EndDate=$zdh(EndDate,4)
	f RepDate=StDate:1:EndDate  d
	.s RepID="0"
	.f  s RepID=$o(^DHCOPInsFootI(0,"Date",RepDate,RepID)) q:RepID=""  d
	..s PrtRowid="0"
	..f  s PrtRowid=$o(^DHCINVPRT(0,"Report",RepID,PrtRowid)) q:PrtRowid=""  d
	...s invInfo=$g(^DHCINVPRT(PrtRowid))
    ...s prtfairtype=$p(invInfo,"^",34)
    ...s amt=$p(invInfo,"^",1)
    ...s prtdate=$p(invInfo,"^",5)
    ...s:prtdate'="" prtdate=$zd(prtdate,3)
    ...s prttime=$p(invInfo,"^",20)
    ...s:prttime'="" prttime=$zt(prttime)
    ...s flag=$p(invInfo,"^",8)
    ...i flag="N"  s flag="正常"
    ...i flag="A"  s flag="作废"
    ...i flag="S"  s flag="红冲"
    ...i amt<0  s CTSum=CTSum+amt
    ...s invno=$p(invInfo,"^",14)  
    ...s initinv=$p(invInfo,"^",13)
    ...i initinv'=""  s initinv=$p(^DHCINVPRT(initinv),"^",4)
    ...s BilConInv="0"
	...f  s BilConInv=$o(^DHCBCI(0,"INV",PrtRowid,BilConInv)) q:BilConInv=""  d
	....s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	....s PBAmt=$p(^DHCPB(PatBillDr),"^",8)
	....s PatAdm=$p(^DHCBCI(BilConInv),"^",3) 
	....s AdmReason=""
	....s AdmReasonId=$p(^PAADM(PatAdm,1),"^",7)
	....i (AdmReasonId'="")  d
	.....s AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2)
	.....s AdmSource=$p(^PAC("ADMREA",AdmReasonId),"^",9)
	....s PaySub="0"
	....f  s PaySub=$o(^DHCINVPRT(PrtRowid,"P",PaySub)) q:PaySub=""  d
	.....s PayModeDr=$p(^DHCINVPRT(PrtRowid,"P",PaySub),"^",1)
	.....i $d(^CT("CTPM",PayModeDr))  s PayDesc=$p(^CT("CTPM",PayModeDr),"^",2)
	.....e  s PayDesc="现金"
	.....s PayModeAmt=$p(^DHCINVPRT(PrtRowid,"P",PaySub),"^",3)
	.....s ^DHCOPBill("HZRepPayMode",GuserId,AdmReason,PayDesc)=+PayModeAmt+(+$g(^DHCOPBill("HZRepPayMode",GuserId,AdmReason,PayDesc)))
	.....s ^DHCOPBill("HZAllRepPayMode",GuserId,PayDesc)=+PayModeAmt++($g(^DHCOPBill("HZAllRepPayMode",GuserId,PayDesc)))
	.....i +AdmSource>0  s ^DHCOPBill("HZInsuRepPayMode",GuserId,PayDesc)=+PayModeAmt++($g(^DHCOPBill("HZInsuRepPayMode",GuserId,PayDesc)))
	....q:'$D(^DHCPB(PatBillDr))
	....s Ord="" f  s Ord=$o(^DHCPB(PatBillDr,"O",Ord)) q:Ord=""  d
	.....s Itm=0 f  s Itm=$o(^DHCPB(PatBillDr,"O",Ord,"D",Itm)) q:Itm=""  d
	......s ItmDr=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",3)
	......s TotalAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",7)
	......s DiscAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",8)
	......s PayorShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",9)
	......s PatientShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",10)	
	......s ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	......q:$g(ItmOPSubCat)=""
	......s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	......S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	......q:$g(ItmOPCat)=""
	......s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	......s ^DHCOPBill("HZRepCate",GuserId,AdmReason,OPCatDesc)=+TotalAmount++($g(^DHCOPBill("HZRepCate",GuserId,AdmReason,OPCatDesc)))
	......s ^DHCOPBill("HZAllRepCate",GuserId,OPCatDesc)=+TotalAmount++($g(^DHCOPBill("HZAllRepCate",GuserId,OPCatDesc)))
	......i +AdmSource>0  s ^DHCOPBill("HZInsuRepCate",GuserId,OPCatDesc)=+TotalAmount++($g(^DHCOPBill("HZInsuRepCate",GuserId,OPCatDesc)))
	q
}

ClassMethod GetINVNOinfoMZ(Guser, INVFlag) As %String
{
	s INVNOinfo="",endno="",AllNum=0
	s Count = 0,newflag=0
	s num="0" f  s num=$o(^TMP("ZYJF",INVFlag,Guser,num)) q:num=""  d
	.s AllNum=AllNum+1
	.s invtmp=^TMP("ZYJF",INVFlag,Guser,num)
	.i (num=1)!(newflag=1)  d
	..s newflag=0
	..s startno=invtmp
	..s endno=invtmp
	..s lenReceipNo = $l(startno)
	.i $d(^TMP("ZYJF",INVFlag,Guser,num+1))'=0  d
	..s newinv=^TMP("ZYJF",INVFlag,Guser,num+1)
	..i (+newinv-1=+endno)  d
	...s endno=endno+1
	..e  d
	...s Count=Count+1
	...s endno=..FormatINVNO(endno,lenReceipNo)
	...s INVNOinfo=INVNOinfo _"  "_startno_"--"_endno_", "
	...s startno="", endno=""
	...s newflag=1
	i (INVNOinfo="")!(Count >= 1) d
	.q:endno="" 
	.s endno=..FormatINVNO(endno,lenReceipNo)
	.s INVNOinfo = INVNOinfo_"  "_startno_"--"_endno
	q INVNOinfo
}

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod GetFPDetail(JkDr, UserDr, job, CurUserId, ZType)
{
	s zfno="",hcno="",normalno="",prtuser=""
	s normalnum=0,normalsum=0,hcnum=0,hcsum=0,zfnum=0,zfsum=0,allsum=0
	s refaccdr=""
    s RowId="",CTNum=0
   
    s ind=1
    f  s RowId=$o(^DHCINVPRT(0,"Report",JkDr,RowId)) q:RowId=""  d
    .s BilConInv="0"
	.f  s BilConInv=$o(^DHCBCI(0,"INV",RowId,BilConInv)) q:BilConInv=""  d
	..s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	..s PBAmt=$p(^DHCPB(PatBillDr),"^",8)
	..s PatAdm=$p(^DHCBCI(BilConInv),"^",3)
	..s PaadmSession=$p(^PAADM(PatAdm,2),"^",28)  ;区分特诊，正常诊，业务诊
	..i PaadmSession'="" s PaadmSession=$p(^PAC("IPAT",PaadmSession),"^",2) 
    .q:(PaadmSession'=ZType)&(ZType'="")
    .s invInfo=$g(^DHCINVPRT(RowId))
    .s prtfairtype=$p(invInfo,"^",34)
    .;q:prtfairtype'="F"
    .s prtaccdr=""
    .s prtaccdr=$p(invInfo,"^",4)
    .q:prtaccdr'=""
    .s prinvptrflag=$p(invInfo,"^",3)
    .q:prinvptrflag'="P"
    .s prtuser=$p(invInfo,"^",21)
    .q:(UserDr'="")&&(UserDr'=prtuser)
    .s amt=$p(invInfo,"^",1)
    .s allsum=+allsum+(+amt)
    .s papmi=$p($p(invInfo,"^",15),$c(1))
    .s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    .s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    .s prtdate=$p(invInfo,"^",5)
    .s:prtdate'="" prtdate=$zd(prtdate,3)
    .s prttime=$p(invInfo,"^",20)
    .s:prttime'="" prttime=$zt(prttime)
    .s flag=$p(invInfo,"^",8)
    .s invno=$p(invInfo,"^",14)  
    .s initinv=$p(invInfo,"^",13)
    .s refaccdr=""
    .i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4)
    .q:refaccdr'=""
    .s ind=ind+1
    .s refaccdr=""
    .i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4)
    .q:refaccdr'="" 
    .i ((invno="")&&(initinv'=""))  d
    ..s RefInvNo=$p(^DHCINVPRT(initinv),"^",14)
    .i flag="A"  d
    ..s:invno'="" zfnum=+zfnum+1
    ..s:initinv'="" zfsum=+zfsum+(+amt)
    ..i invno'=""  d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Abort",prtuser,invno)
    .i flag="S"  d
    ..s:initinv'="" hcnum=+hcnum+1
    ..s:initinv'="" hcsum=+hcsum+(+amt)
    ..i initinv'=""  d
    ...s initno=$p(^DHCINVPRT(initinv),"^",14)
    ...d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Strik",prtuser,initno)
    .i ((invno'="")&&(amt>0))  d
    ..d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Normal",prtuser,invno)
    ..s normalnum=normalnum+1
    ..s normalsum=+normalsum+(+amt)
    .i amt<0  d
    ..s ^TMP("MZJF","CTInvDetail",CurUserId,CTNum)=PatName_"^"_PatNo_"^"_RefInvNo_"^"_amt_"^"_prtdate
    ..s CTNum=CTNum+1
    .;q:(PaadmSession'=ZType)&(ZType'="")
    .s BilConInv="0"
	.f  s BilConInv=$o(^DHCBCI(0,"INV",RowId,BilConInv)) q:BilConInv=""  d
	..s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	..s PatAdm=$p(^DHCBCI(BilConInv),"^",3) 
	..q:'$D(^DHCPB(PatBillDr))
	..s Ord="" f  s Ord=$o(^DHCPB(PatBillDr,"O",Ord)) q:Ord=""  d
	...s Itm=0 f  s Itm=$o(^DHCPB(PatBillDr,"O",Ord,"D",Itm)) q:Itm=""  d
	....s ItmDr=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",3)
	....s TotalAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",7)
	....s DiscAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",8)
	....s PayorShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",9)
	....s PatientShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",10)	
	....s ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	....q:$g(ItmOPSubCat)=""
	....s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	....s ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	....q:$g(ItmOPCat)=""
	....s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	....i (amt>0)  d
	.....s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"N")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"N")))
	.....;s ^TMP("MZJF","HZCate",CurUserId,"N",OPCatDesc)=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"N",OPCatDesc)))
	.....;s ^TMP("MZJF","HZCate",CurUserId,"N","合计")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"N","合计")))
	....i ((amt<0)&&(flag="A"))  d
	.....s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"A")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"A")))
	.....;s ^TMP("MZJF","HZCate",CurUserId,"A",OPCatDesc)=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"A",OPCatDesc)))
	.....;s ^TMP("MZJF","HZCate",CurUserId,"A","合计")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"A","合计")))
	....i ((amt<0)&&(flag="S"))  d
	.....s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"S")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"S")))
	.....;s ^TMP("MZJF","HZCate",CurUserId,"S",OPCatDesc)=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,OPCatDesc)))
	.....;s ^TMP("MZJF","HZCate",CurUserId,"S","合计")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"合计")))
	....;s ^TMP("MZJF","AllHZCate",CurUserId,OPCatDesc)=+TotalAmount++($g(^TMP("MZJF","AllHZCate",CurUserId,OPCatDesc)))
    ....;s ^TMP("MZJF","AllHZCate",CurUserId,"合计")=+TotalAmount++($g(^TMP("MZJF","AllHZCate",CurUserId,"合计")))
    s accrowid=""
    f  s accrowid=$o(^DHCINVPRTAPi(0,"INVRep",JkDr,accrowid)) q:accrowid=""  d
    .s handdr=$p(^DHCINVPRTAP(accrowid),"^",20)
    .s invno=$p(^DHCINVPRTAP(accrowid),"^",6)
    .s ind=ind+1
    .s prtuser=$p(^DHCINVPRTAP(accrowid),"^",5)
    .q:((UserDr'="")&(UserDr'=prtuser))
    .s flag=$p(^DHCINVPRTAP(accrowid),"^",2)
    .s amt=$p(^DHCINVPRTAP(accrowid),"^",1)
    .s initinv=$p(^DHCINVPRTAP(accrowid),"^",10)
    .i flag="A"  d
    ..s:invno'="" zfnum=+zfnum+1
    ..s:initinv'="" zfsum=+zfsum+(+amt)
    ..i invno'=""  d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Abort",prtuser,invno)
    .i flag="S"  d
    ..s:initinv'="" hcnum=+hcnum+1
    ..s:initinv'="" hcsum=+hcsum+(+amt)
    ..i initinv'=""  d
    ...s initno=$p(^DHCINVPRTAP(initinv),"^",6)
    ...d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Strik",prtuser,initno)
    .i ((invno'="")&&(amt>0))  d
    ..s normalnum=normalnum+1
    ..s normalsum=+normalsum+(+amt)
    ..d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Normal",prtuser,invno)
    .s allsum=+allsum+(+amt)
    s zfno=$g(^TMP("EPInvDailyHand/No",+prtuser,"Abort","no"))
    s hcno=$g(^TMP("EPInvDailyHand/No",+prtuser,"Strik","no"))
    s normalno=$g(^TMP("EPInvDailyHand/No",+prtuser,"Normal","no"))
    k ^TMP("EPInvDailyHand/No",+prtuser,"Abort","no")
    k ^TMP("EPInvDailyHand/No",+prtuser,"Strik","no")
    k ^TMP("EPInvDailyHand/No",+prtuser,"Normal","no")
    q normalnum_"^"_normalno_"^"_normalsum_"^"_zfnum_"^"_zfno_"^"_zfsum_"^"_hcnum_"^"_hcno_"^"_hcsum_"^"_allsum
}

ClassMethod GetUNHandFPDetail(RowId, UserDr, job, CurUserId, CTNum)
{
	s zfno="",hcno="",normalno="",prtuser=""
	s normalnum=0,normalsum=0,hcnum=0,hcsum=0,zfnum=0,zfsum=0,allsum=0
	s refaccdr="",RefInvNo="",invno=""
    s ind=1
    s invInfo=$g(^DHCINVPRT(RowId))
    s prtfairtype=$p(invInfo,"^",34)
    s prtaccdr=""
    s prtaccdr=$p(invInfo,"^",4)
    s prinvptrflag=$p(invInfo,"^",3)
    s prtuser=$p(invInfo,"^",21)
    s amt=$p(invInfo,"^",1)
    s papmi=$p($p(invInfo,"^",15),$c(1))
    s PatName="",PatNo=""
    s PatName="",PatNo=""
    i papmi'=""  d
    .i $d(^PAPER(papmi,"ALL"))  s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    .i $d(^PAPER(papmi,"PAT",1))  s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    s prtdate=$p(invInfo,"^",5)
    s:prtdate'="" prtdate=$zd(prtdate,3)
    s prttime=$p(invInfo,"^",20)
    s:prttime'="" prttime=$zt(prttime)
    s flag=$p(invInfo,"^",8)
    s invno=$p(invInfo,"^",14)  
    s initinv=$p(invInfo,"^",13)
    s refaccdr=""
    i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4)
    q:refaccdr'=""
    s ind=ind+1
    s refaccdr=""
    i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4)
    q:refaccdr'="" 
    i ((invno="")&&(initinv'=""))  d
    .s RefInvNo=$p(^DHCINVPRT(initinv),"^",14)
    i flag="A"  d
    .s:invno'="" zfnum=+zfnum+1
    .s:initinv'="" zfsum=+zfsum+(+amt)
    .i invno'=""  d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Abort",prtuser,invno)
    i flag="S"  d
    .s:initinv'="" hcnum=+hcnum+1
    .s:initinv'="" hcsum=+hcsum+(+amt)
    .i amt<0  d
    ..s initno=$p(^DHCINVPRT(initinv),"^",14)
    ..d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Strik",prtuser,initno)
    i ((invno'="")&&(amt>0))  d
    .d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Normal",prtuser,invno)
    .s normalnum=normalnum+1
    .s normalsum=+normalsum+(+amt)
    s allsum=+allsum+(+amt)
    i amt<0  d
    .i $d(^TMP("MZJF","CTInvDetail",CurUserId))  d
    ..s CTNum=$o(^TMP("MZJF","CTInvDetail",CurUserId,""),-1)
    ..s CTNum=+CTNum+1
    ..s ^TMP("MZJF","CTInvDetail",CurUserId,CTNum)=PatName_"^"_PatNo_"^"_RefInvNo_"^"_amt_"^"_prtdate
    .e  d
    ..s ^TMP("MZJF","CTInvDetail",CurUserId,1)=PatName_"^"_PatNo_"^"_RefInvNo_"^"_amt_"^"_prtdate
    i $d(^DHCIPBill("PatInvDetail",+prtuser))  d
    .s Invnum=$o(^DHCIPBill("PatInvDetail",+prtuser,""),-1)
    .s Invnum=+Invnum+1
    .s ^DHCIPBill("PatInvDetail",+prtuser,Invnum)=invno_"^"_RefInvNo_"^"_amt_"^"_flag
    e  d
    .s ^DHCIPBill("PatInvDetail",+prtuser,1)=invno_"^"_RefInvNo_"^"_amt_"^"_flag
    s BilConInv="0"
	f  s BilConInv=$o(^DHCBCI(0,"INV",RowId,BilConInv)) q:BilConInv=""  d
	.s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	.s PatAdm=$p(^DHCBCI(BilConInv),"^",3) 
	.s Admi=" "_PatAdm,SessionTypeCode=""
	.S I=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	.i I'="" d
	..s ASRowId=$List(^User.DHCRegistrationFeeD(I),18)
	..s SessionTypeDr=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC")),"^",6)
	..s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1)
	..s Week=0
	..s Week=$ZD(ASDate,10)
	..i SessionTypeDr'=""  s SessionTypeCode=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	..i SessionTypeCode=""  s SessionTypeCode="正常诊"
	..i SessionTypeCode["特诊"  d
	...s SessionTypeCode="特诊"
	..e  d
	...i ((Week="0")||(Week="6"))  d
	....s SessionTypeCode="业余诊"
	.q:'$D(^DHCPB(PatBillDr))
	.s Ord="" f  s Ord=$o(^DHCPB(PatBillDr,"O",Ord)) q:Ord=""  d
	..s Itm=0 f  s Itm=$o(^DHCPB(PatBillDr,"O",Ord,"D",Itm)) q:Itm=""  d
	...s ItmDr=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",3)
	...s TotalAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",7)
	...s DiscAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",8)
	...s PayorShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",9)
	...s PatientShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",10)	
	...s ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	...q:$g(ItmOPSubCat)=""
	...s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	...s ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	...q:$g(ItmOPCat)=""
	...s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	...i (amt>0)  d
	....s ^TMP("MZJF","HZCate",CurUserId,"N",OPCatDesc)=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"N",OPCatDesc)))
	....s ^TMP("MZJF","HZCate",CurUserId,"N","合计")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"N","合计")))
	...i ((amt<0)&&(flag="A"))  d
	....s ^TMP("MZJF","HZCate",CurUserId,"A",OPCatDesc)=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"A",OPCatDesc)))
	....s ^TMP("MZJF","HZCate",CurUserId,"A","合计")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"A","合计")))
	...i ((amt<0)&&(flag="S"))  d
	....s ^TMP("MZJF","HZCate",CurUserId,"S",OPCatDesc)=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,OPCatDesc)))
	....s ^TMP("MZJF","HZCate",CurUserId,"S","合计")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,"合计")))
	...s ^TMP("MZJF","AllHZCate",CurUserId,OPCatDesc)=+TotalAmount++($g(^TMP("MZJF","AllHZCate",CurUserId,OPCatDesc)))
    ....s ^TMP("MZJF","AllHZCate",CurUserId,"合计")=+TotalAmount++($g(^TMP("MZJF","AllHZCate",CurUserId,"合计")))
    q
}

Query ZType() As %Query(ROWSPEC = "Type:%String,TypeId:%String")
{
}

ClassMethod ZTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ZTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ZTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s IPatRowID=0
	f  s IPatRowID=$o(^PAC("IPAT",IPatRowID)) q:IPatRowID=""  d
	.s IPatDesc=$p(^PAC("IPAT",IPatRowID),"^",2)
	.d OutputRow3	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(IPatDesc,IPatRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ZTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ZTypeExecute ]
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

}
