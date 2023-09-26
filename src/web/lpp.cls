Import SQLUser

Class web.lpp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 309;

ClassMethod FindInv(PaPmi)
{
    
     s Adm=""
     f  s Adm=$O(^PAPERdr(PaPmi,"ADM","O",Adm))  q:Adm=""  d
	 .s BCIRowid=""
	 .f  s BCIRowid=$O(^DHCBCI(0,"ADM",Adm,BCIRowid))  q:BCIRowid=""  d
	 ..s InvDr=$P(^DHCBCI(BCIRowid),"^",1)
	 ..s PatBillDR=$P(^DHCBCI(BCIRowid),"^",2)
	 ..//发票号
	 ..s InvNo=$P(^DHCINVPRT(InvDr),"^",14) 
	 ..//发票金额     
	 ..s InvAcount=$P(^DHCINVPRT(InvDr),"^",1)
	 ..//发票状态
	 ..s InvFlag=$P(^DHCINVPRT(InvDr),"^",8)
	 ..s PrtFlag="直接"
	 ..//集中打印发票
	 ..i InvNo="" d 
	 ...s PrtFlag="集中" 
	 ...s AccInvDr=$P(^DHCINVPRT(InvDr),"^",4)
	 ...q:AccInvDr=""
     ...s InvNo=$P(^DHCINVPRTAP($G(AccInvDr)),"^",6)
     ...s InvAcount=$P(^DHCINVPRTAP($G(AccInvDr)),"^",1)
     ...s InvFlag=$P(^DHCINVPRTAP($G(AccInvDr)),"^",2) 
     ..//处方号
     ..s PBORowid=0
     ..f  s PBORowid=$O(^DHCPB(PatBillDR,"O",PBORowid))  q:PBORowid=""  d
     ...s OEORI=$P(^DHCPB(PatBillDR,"O",PBORowid),"^",4)
     ...s OEORD=+OEORI
     ...s OEORD1=$P(OEORI,"||",2)
     ...s PrescNo=$P(^OEORD(OEORD,"I",1,OEORD1),"^",14) 
     ...I PrescNo="" S PrescNo="KONG"
     ...w !,InvNo_"^"_PrescNo  	
	q
}

ClassMethod FindAcc(AccFoot, FootUserDr)
{
	//d ##class(web.lpp).FindAcc("63","631")
	
	s AccFootSub=0
	f  s AccFootSub=$O(^DHCACD("AccPF",AccFoot,"PF",AccFootSub)) q:$g(AccFootSub)=""  d
	.s AccMan=$P(^DHCACD("AccPF",AccFoot,"PF",AccFootSub),"^",1)
	.s AccPD=0
	.f  s AccPD=$O(^DHCACD("AccM",AccMan,"AccPD",AccPD)) q:AccPD=""  d
	..s FootUser=$P(^DHCACD("AccM",AccMan,"AccPD",AccPD),"^",13) 
	..q:FootUser'=FootUserDr
	..s BillNum=$P(^DHCACD("AccM",AccMan,"AccPD",AccPD),"^",6) 
	..//s FootDr=$P(^DHCACD("AccM",AccMan,"AccPD",AccPD),"^",7)
	..w !,BillNum_"^^"_AccMan_"||"_AccPD
	
	
	q
}

ClassMethod up39()
{
	//d ##class(web.lpp).up39()
 s srowid="",sinv="",snewinv="",i=0
 k ^TMPfdd("XModDHCInvprt")
 &sql(declare curx cursor for select prt_rowid,prt_inv into :srowid,:sinv from dhc_invprt where prt_inv like '%6392008%')
 &sql(open curx)
 f  &sql(fetch curx) q:SQLCODE  d
 .s srowid=$g(srowid),sinv=$g(sinv)
 .s snewinv=2008_""_$p(sinv,"6392008",2)
 .&sql(update dhc_invprt set prt_inv=:snewinv  where prt_rowid=:srowid)
 .s i=i+1
 .s ^TMPfdd("XModDHCInvprt",i)=srowid_"^"_sinv_"^"_snewinv
 &sql(close curx)
 q i
}

ClassMethod FindRec(StDate, EndDate)
{
 //Find DHC_AccPDFootLog Receive List
 f Date=StDate:1:EndDate d
 .s AccPDFL=""
 .f  s AccPDFL=$O(^DHCACD("AccPDFL",AccPDFL))  q:AccPDFL=""  d
 ..s RecDate=$P(^DHCACD("AccPDFL",AccPDFL),"^",8)
 ..q:RecDate'=Date
 ..s RecTime=$P(^DHCACD("AccPDFL",AccPDFL),"^",9)
 .s ^TMPWLAccRec(num)=RecTime
 q RecDate_"^"_RecTime
}

}
