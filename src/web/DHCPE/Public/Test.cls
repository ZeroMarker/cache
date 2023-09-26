Class web.DHCPE.Public.Test Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindDepositClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDepositExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDepositExecute(ByRef qHandle As %Binary, PrtDate, UserRowId) As %Status
{
	Set repid=$I(^CacheTemp)
	i PrtDate="" Quit $$$OK
	&js<#(PrtDate)#>
	s ^TTT=PrtDate_"^"_UserRowId
 s ind=1
 s prtrowid=0,num=0  ;dhc_sfprintdetail
 f  s prtrowid=$O(^DHCSFPRINTDETAIL(prtrowid)) quit:prtrowid=""  do

 .;i prtrowid="" q
 .s prtdate=$zd($p(^DHCSFPRINTDETAIL(prtrowid),"^",2),3)
 .s prttime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3),1)
 .s adm=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
 .q:adm=""
 .s papmi=""
 .i $d(^PAADM(adm)) s papmi=$p(^PAADM(adm),"^",1)
 .q:papmi=""
 .i $d(^PAPER(papmi,"ALL")) s papname=$p(^PAPER(papmi,"ALL"),"^",1)
 .s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
 .s payamt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
 .s num=num+1
 .;w !,$zd(prtdate,3)_"^"_$zt(prttime,1)_"^"_papname_"^"_papno_"^"_payamt
 .Do OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
	set Data=$lb(prtdate,prttime,papname,papno,payamt)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod FindDepositFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDepositExecute ]
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

ClassMethod FindUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindUserExecute(ByRef qHandle As %Binary, UserName) As %Status
{
	Set repid=$I(^CacheTemp)
	
 s ind=1
 s rowid=""
 f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
 .s username=$p(^SSU("SSUSR",rowid),"^",2)
 .q:(username'=UserName)&(UserName'="")
 .Do OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
	set Data=$lb(username,rowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod FindUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserExecute ]
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

ClassMethod GetArpbill(BillNo)
{
	s admdr =$p(^DHCPB(BillNo),"^",1)
	s papmidr=$P(^PAADM(admdr),"^",1)
	s name =$p(^PAPER(papmidr,"ALL"),"^",1)
	S ipno =$p(^PAPER(papmidr,"PAT",1),"^",1)
	S total=$p(^DHCPB(BillNo),"^",8)
	w ! ,name_"^"_ipno
	s rowid=0
	f  s rowid=$o(^ARRCP("ARPBL",BillNo,rowid)) q:rowid=""  d
	.s arrcpnumber=$p(^ARRCP(rowid),"^",2)
	.q:arrcpnumber'=""
	.s PAYMchildid=0
	.f  s PAYMchildid =$o(^ARRCP(rowid,"PAYM",PAYMchildid)) q:PAYMchildid=""  d
	..s payamount=$p(^ARRCP(rowid,"PAYM",PAYMchildid),"^",3)
	..s PAYMpaymode=$p(^ARRCP(rowid,"PAYM",PAYMchildid),"^",1)
	..s CTpaymode =$P(^CT("CTPM",PAYMpaymode),"^",2)
	..w ! ,payamount_"^"_PAYMpaymode_"^"_CTpaymode
 q
}

ClassMethod GetDepositDetail()
{
 ;取预交金明细?显示打印日期?时间?病人姓名?登记号?金额
 s prtrowid=0,num=0
 f  s prtrowid=$O(^DHCSFPRINTDETAIL(prtrowid)) quit:prtrowid=""  do
 .;i prtrowid="" q
 .s prtdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",2)
 .s prttime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",3)
 .s adm=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
 .q:adm=""
 .s papmi=""
 .i $d(^PAADM(adm)) s papmi=$p(^PAADM(adm),"^",1)
 .q:papmi=""
 .i $d(^PAPER(papmi,"ALL")) s papname=$p(^PAPER(papmi,"ALL"),"^",1)
 .s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
 .s payamt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
 .s num=num+1
 .w !,$zd(prtdate,3)_"^"_$zt(prttime,1)_"^"_papname_"^"_papno_"^"_payamt
 q
}

ClassMethod GetPatAllMsg(BillNo)
{
 ;s return=..GetPatM(BillNo)
 s return=##class(web.Test).GetPatM(BillNo)
 s ArrcpRowid=0
 f  s ArrcpRowid=$o(^ARRCP("ARPBL",BillNo,ArrcpRowid)) q:ArrcpRowid=""  d
 .s Childsub=0
 .f  s Childsub=$o(^ARRCP("ARPBL",BillNo,ArrcpRowid,Childsub)) q:Childsub=""  d
 ..s mode=$p(^ARRCP(ArrcpRowid,"RAL",Childsub),"^",9)
 ..i mode'="" s ArPayAmt=$p(^ARRCP(ArrcpRowid,"RAL",Childsub),"^",2) //预交金金额
 ..s Paymode=$p(^ARRCP(ArrcpRowid,"PAYM",Childsub),"^",1)         
 ..i Paymode'="" s mode=$p(^CT("CTPM",Paymode),"^",2)   //支付方式
 ..w !,PatName_"^"_PatIpno_"^"_PayAmount_"^"_ArPayAmt_"^"_Paymode
 ..w !
 q 0
}

ClassMethod GetPatInfoByAdmId(itmjs, AdmId)
{
	q:AdmId=""
	s papmi=$p(^PAADM(AdmId),"^",1)
	s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	s str=patname_"^"_patno
	s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
 &javascript<#(retval)#>
	q
}

ClassMethod GetPatInfoByAdmId1(AdmId)
{
	q:AdmId=""
	s papmi=$p(^PAADM(AdmId),"^",1)
	s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	s str=patname_"^"_patno
	q str
}

ClassMethod GetPatM(BillNo)
{
 s PaadmRowid=$p(^DHCPB(BillNo),"^",1)    //取PA_ADM的RowID
 s PayAmount=$p(^DHCPB(BillNo),"^",8)   //帐单总额 
 s PapatRowid=$p(^PAADM(PaadmRowid),"^",1)    //取PA_PATMas的RowID
 s PatName=$P(^PAPER(PapatRowid,"ALL"),"^",1)    //取病人姓名
 s PatIpno=$P(^PAPER(PapatRowid,"PAT",1),"^",1)  //取病人登记号
 q PatName_"^"_PatIpno
}

Query FindDeposit(PrtDate, UserRowId) As %Query(ROWSPEC = "TPrtDate:%String,TPrtTime:%String,TPatName:%String,TPatNo:%String,TPayAmt:%String")
{
}

Query FindUser(UserName) As %Query(ROWSPEC = "UserName:%String,UserRowid:%String")
{
}

}
