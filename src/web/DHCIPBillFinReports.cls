Class web.DHCIPBillFinReports Extends %RegisteredObject
{

ClassMethod QueryFinancialFeeSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFinancialFeeSumExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:yyx
/// CreateDate:2013-05-09
/// Function:出院结算汇总收入表
/// d ##class(%ResultSet).RunQuery("web.DHCIPBillFinReports","QueryFinancialFeeSum",+$h-200,+$h)
ClassMethod QueryFinancialFeeSumExecute(ByRef qHandle As %Binary, StDate, EndDate) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	k TMPWARDFEE
 	i StDate["-" s StDate=$zdh(StDate,3)
    i EndDate["-" s EndDate=$zdh(EndDate,3)
    i StDate["/" s StDate=$zdh(StDate,4)
    i EndDate["/" s EndDate=$zdh(EndDate,4)
    f AcctDate=StDate:1:EndDate d
 	.s AcctRowID=""
 	.f  s AcctRowID=$o(^DHCJFYJACOUNT(0,"DateFlag","FINANCIALACOUNT",AcctDate,AcctRowID)) q:AcctRowID=""  d
 	..s WardDr=$p(^DHCJFYJACOUNT(AcctRowID),"^",14)
 	..s DepDr=$p(^DHCJFYJACOUNT(AcctRowID),"^",15)
 	..s Sub=""
 	..f  s Sub=$o(^DHCJFFEEACOUNT(AcctRowID,"SUB",Sub)) q:Sub=""  d
 	...s ACCateRowID=$p(^DHCJFFEEACOUNT(AcctRowID,"SUB",Sub),"^",2)
 	...s AcctFee=$p(^DHCJFFEEACOUNT(AcctRowID,"SUB",Sub),"^",6)
 	...S TMPWARDFEE(DepDr,WardDr,ACCateRowID)=+$G(TMPWARDFEE(DepDr,WardDr,ACCateRowID))+AcctFee
 	
 	b 
 	s Dep=""
 	f  s Dep=$o(TMPWARDFEE(Dep)) q:Dep=""  d
 	.s Ward=""
 	.f  s Ward=$o(TMPWARDFEE(Dep,Ward)) q:Ward=""  d
 	..s Acct=""
 	..f  s Acct=$o(TMPWARDFEE(Dep,Ward,Acct)) q:Acct=""  d
 	...s WardCode=$p(^CTLOC(Ward),"^",1)
 	...s WardDesc=$p(^CTLOC(Ward),"^",2)
 	...i WardDesc["-" s WardDesc=$p(WardDesc,"-",2)
 	...s DepCode=$p(^CTLOC(Dep),"^",1)
 	...s DepDesc=$p(^CTLOC(Dep),"^",2)
 	...i DepDesc["-" s DepDesc=$p(DepDesc,"-",2)
 	...s AcctDesc=$p(^DHCTarC("TAC",Acct),"^",2)
 	...s AcctFee=+$g(TMPWARDFEE(Dep,Ward,Acct))
 	...d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DepCode,DepDesc,WardCode,WardDesc,AcctDesc,AcctFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryFinancialFeeSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFinancialFeeSumExecute ]
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

Query QueryFinancialFeeSum(StDate, EndDate) As %Query(ROWSPEC = "OrdDepCode,OrdDep:%String,OrdWardCode,OrdWard:%String,AcctDesc:%String,ACCatFee:%String")
{
}

ClassMethod QueryFinancialFeePatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFinancialFeePatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:yyx
/// CreateDate:2013-05-09
/// Function:出院结算病人明细表
/// d ##class(%ResultSet).RunQuery("web.DHCIPBillFinReports","QueryFinancialFeePat",+$h-200,+$h)
ClassMethod QueryFinancialFeePatExecute(ByRef qHandle As %Binary, StDate, EndDate) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	k TMPWARDFEE
 	i StDate["-" s StDate=$zdh(StDate,3)
    i EndDate["-" s EndDate=$zdh(EndDate,3)
    i StDate["/" s StDate=$zdh(StDate,4)
    i EndDate["/" s EndDate=$zdh(EndDate,4)
    s PrtAcountSum=0,PrtDepositSum=0
    f PrtDate=StDate:1:EndDate d
 	.s PrtRowid=""
 	.f  s PrtRowid=$o(^DHCINVPRTZY(0,"DATE",PrtDate,PrtRowid)) q:PrtRowid=""  d
 	..s PrtAdm=$p(^DHCINVPRTZY(PrtRowid),"^",4)
 	..s PapmiRowID=$p(^PAADM(PrtAdm),"^",1)
 	..s PapmiNo=$p(^PAPER(PapmiRowID,"PAT",1),"^",1)
	..s PapmiName=$p(^PAPER(PapmiRowID,"ALL"),"^",1)
	..s PrtAdmReasonDr=$p(^DHCINVPRTZY(PrtRowid),"^",9)
	..S AdmReasonDesc=$p(^PAC("ADMREA",PrtAdmReasonDr),"^",2)
	..s AdmDate=$p(^PAADM(PrtAdm),"^",6)
	..s PrtFlag=$p(^DHCINVPRTZY(PrtRowid),"^",8)
	..s PrtAcount=$p(^DHCINVPRTZY(PrtRowid),"^",6)
	..s PrtDeposit=$p(^DHCINVPRTZY(PrtRowid),"^",22)
	..s DisDate=$p(^PAADM(PrtAdm),"^",17)
	..s PBRowID=$p(^DHCINVPRTZY(PrtRowid),"^",5)
	..s PBDateTo=$p(^DHCPB(PBRowID),"^",7)
	..q:PrtFlag="A"
	..i PrtFlag="I" s DisDate=PBDateTo
	..i PrtFlag="S" d
	...s InitDr=$p(^DHCINVPRTZY(PrtRowid),"^",13)
	...s OldPBRowID=$p(^DHCINVPRTZY(InitDr),"^",5)
	...s OldPBDateTo=$p(^DHCPB(OldPBRowID),"^",7)
	...s OldPrtFlag=$p(^DHCINVPRTZY(InitDr),"^",8)
	...i OldPrtFlag="I" s DisDate=OldPBDateTo
	..s AdmDate=$zd(AdmDate,3)
	..i +DisDate'=0 s DisDate=$zd(DisDate,3)
	..s InvDate=PrtDate
	..s InvDate=$zd(InvDate,3)
	..s PrtAcountSum=PrtAcountSum++PrtAcount
	..s PrtDepositSum=PrtDepositSum++PrtDeposit
 	..d OutputRow
 	s (PapmiNo,PapmiName,AdmDate,DisDate,AdmReasonDesc)=""
 	s InvDate="合计",PrtAcount=PrtAcountSum,PrtDeposit=PrtDepositSum
 	d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(InvDate,PapmiNo,PapmiName,PrtAcount,PrtDeposit,AdmDate,DisDate,AdmReasonDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryFinancialFeePatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFinancialFeePatExecute ]
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

Query QueryFinancialFeePat(StDate, EndDate) As %Query(ROWSPEC = "TInvDate:%String,TPapmiNo:%String,TPapmiName:%String,TPrtAcount:%String,TPrtDeposit:%String,TAdmDate:%String,TDisDate:%String,TAdmReasonDesc:%String")
{
}

ClassMethod QueryDepositAcountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDepositAcountExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:yyx
/// CreateDate:2013-05-10
/// Function:病人在院预交金帐
/// d ##class(%ResultSet).RunQuery("web.DHCIPBillFinReports","QueryDepositAcount",+$h-200,+$h)
ClassMethod QueryDepositAcountExecute(ByRef qHandle As %Binary, StDate, EndDate) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	k TMPWARDFEE
 	i StDate["-" s StDate=$zdh(StDate,3)
    i EndDate["-" s EndDate=$zdh(EndDate,3)
    i StDate["/" s StDate=$zdh(StDate,4)
    i EndDate["/" s EndDate=$zdh(EndDate,4)
    s DepDFSum=0,DepJFSum=0,DepRemainSum=0,RemainSum=0
    s LastRemainOLD=..getlastremain(StDate,"YJACOUNT","")
    s PrtAcountSum=0,PrtDepositSum=0
    f AcctDate=StDate:1:EndDate d
 	.s AcctID=""
 	.f  s AcctID=$o(^DHCJFYJACOUNT(0,"DateFlag","YJACOUNT",AcctDate,AcctID)) q:AcctID=""  d
 	..s LastRemain=..getlastremain(AcctDate,"YJACOUNT","")
 	..s AcctDF=$p(^DHCJFYJACOUNT(AcctID),"^",3)
 	..s AcctJF=$p(^DHCJFYJACOUNT(AcctID),"^",2)
 	..s AcctRemain=$p(^DHCJFYJACOUNT(AcctID),"^",4)  
 	..s DepDFSum=DepDFSum+AcctDF,DepJFSum=DepJFSum+AcctJF
 	..s OutDate=$zd(AcctDate,3)
 	..s Remain=AcctRemain-LastRemain
 	..s RemainSum=RemainSum+Remain
 	..s AcctRemain=AcctDF-AcctJF
 	..d OutputRow
 	s (OutDate,CurrentRemain,LastRemain,Remain,AcctDF,AcctJF,AcctRemain)=""
 	s OutDate="合计",Remain=RemainSum+LastRemainOLD,LastRemain=LastRemainOLD,CurrentRemain=RemainSum
 	s AcctDF=DepDFSum,AcctJF=DepJFSum,AcctRemain=DepDFSum-DepJFSum
 	b 
 	d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OutDate,Remain,LastRemain,CurrentRemain,AcctDF,AcctJF,AcctRemain)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDepositAcountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDepositAcountExecute ]
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

Query QueryDepositAcount(StDate, EndDate) As %Query(ROWSPEC = "OutDate,CurrentRemain,LastRemain,RemainSum,AcctDF,AcctJF,AcctRemain")
{
}

/// 取上期余额
ClassMethod getlastremain(stdate, flag, myUserHospitalID)
{
    i stdate["/" s stdate=$zdh(stdate,4)
	s stdate=$o(^DHCJFYJACOUNT(0,"DateFlag",flag,stdate),-1)
	q:stdate="" 0
	s lastremain=0
	s rowid="0"
	f  s rowid=$o(^DHCJFYJACOUNT(0,"DateFlag",flag,stdate,rowid)) q:rowid=""  d
	.s flag1=$p(^DHCJFYJACOUNT(rowid),"^",9)
	.q:flag1'=flag
	.s HisUser=$p(^DHCJFYJACOUNT(rowid),"^",7)
	.s myHospitalID=##Class(web.UDHCHospitalGroup).GetHospitalIDByUserID(HisUser)
	.q:(myUserHospitalID'=myHospitalID)&(myUserHospitalID'="")&(myHospitalID'="")
	.s lastremain=$p(^DHCJFYJACOUNT(rowid),"^",4)
	q lastremain
}

}
