Import sqluser

Class web.UDHCJFDeposit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindDeposit(Adm As %String, deposittype As %String) As websys.Query(ROWSPEC = "Trcptno:%String,Tprtdate:%String,Tprttime:%String,Tpayamt:%String,Tpaymode:%String,Tprtstatus:%String,Trcptrowid:%String,Tarpbl:%String,Tadduser:%String,Tauthno:%String,Tcompany:%String,Tbank:%String,TAdm:%String,Tprtrowid:%String,Tjkflag:%String,select:%Library.Boolean,Tpaystatus:%String,Tbbackflag:%String,Tbbackdate:%String,Tbbacktime:%String,Tbbackuser:%String,Trefreason:%String,Tcardno:%String,Tcomment:%String,Tno:%String,TDepositType:%String,Trefrcptno:%String,TAutoFlag:%String,TReRcptNo:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFDeposit","FindDeposit","21", "住院押金")
ClassMethod FindDepositExecute(ByRef qHandle As %Binary, Adm As %String, deposittype As %String) As %Status
{
	set repid=$I(^CacheTemp)
 	set ind=1
 	set qHandle=$lb(0,repid,0)
 	if (Adm="")  quit $$$OK
	
	if (deposittype="") do
 	.set deposittype=..GetDefaultDepType("")

	s bbackflag="",bbackdate="",bbacktime="",bbackuser="",refreason="",sum=0

 	s rowid=""
 	f  s rowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,rowid),-1) q:(rowid="")  d
 	.s tmp=$g(^DHCSFPRINTDETAIL(rowid))
 	.q:(tmp="")
	.//zhho 第三方支付补打发票
 	.s reRcptNo=""
 	.i ($d(^DHCRcptInvi(0,"RcpNo",rowid))) d
	..s invrcp=""
	..f  s invrcp=$o(^DHCRcptInvi(0,"RcpNo",rowid,invrcp)) q:((invrcp="")||(reRcptNo'=""))  d
	...s flag=$p(^DHCRcptInv(invrcp),"^",2)
	...q:(flag="A")
	...s reRcptNo=$p(^DHCRcptInv(invrcp),"^",6)
	.//
 	.s Type=$p(tmp,"^",13),Type=$p(^ARC("ARCDT",Type),"^",2)
	.q:((deposittype'="")&&(Type'=deposittype))
 	.s rcptno=$p(tmp,"^",1)
 	.s title=$p(tmp,"^",29)
 	.s rcptno=title_rcptno
 	.s prtdate=$p(tmp,"^",2)
 	.s prtdate=##class(websys.Conversions).DateLogicalToHtml(prtdate)
 	.s prttime=$p(tmp,"^",3)
 	.s prttime=##class(websys.Conversions).TimeLogicalToHtml(prttime,1)
 	.s payamt=$p(tmp,"^",6)
 	.s paymode=$p(tmp,"^",9)
 	.i (paymode'="") d
 	..s paymode=$p(^CT("CTPM",paymode),"^",2)
 	.s prtstatus=$p(tmp,"^",8)
 	.i (prtstatus'="2") s sum=sum+payamt
 	.i (prtstatus="1") s prtstatus="正常"
 	.i (prtstatus="2") s prtstatus="作废"
 	.i (prtstatus="3") s prtstatus="冲红"
 	.i (prtstatus="4") s prtstatus="已冲红"
 	.i (prtstatus="5") s prtstatus="打印"
 	.s cardno=$p(tmp,"^",11)   ;票号
 	.s company=$p(tmp,"^",12)
 	.s bank=$p(tmp,"^",10)
 	.s bankdesc="", bankdesc1=""
 	.i ((bank'="")&&($d(^CMC("CMCBM",bank)))) d
 	..s bankdesc1=$p(^CMC("CMCBM",bank),"^",2)
 	.s banksub=$p(tmp,"^",35)
 	.s bankdesc=bankdesc1_" "_banksub
 	.s adduser=$p(tmp,"^",14)
 	.s comment=$p(tmp,"^",33)
 	.s autoFlag=""
	.i (adduser'="") d
 	..s group=$p(^SSU("SSUSR",adduser),"^",5)
 	..s adduser=$p($g(^SSU("SSUSR",adduser)),"^",2)
 	..i (group="284") s autoFlag="Y"  //第三方支付，根据安全组区分是否需补打标识
 	.s rcptdr=$p(tmp,"^",5)
 	.s arpbl="", authno=""
 	.i (rcptdr'="") d
 	..s arpbl=$p(^ARRCP(rcptdr,"RAL",1),"^",18)
	..s authno=$p(^ARRCP(rcptdr,"PAYM",1),"^",5)
	.s jkflag=$p(tmp,"^",23)
	.s select="1"
	.s paystatus=""
	.i (arpbl'="")  d
	..s paystatus="已结"
	.s bbackflag="", bbackdate="", bbacktime="", bbackuser=""
	.s bbackdr=$o(^DHCJFBankBack(0,"Yjrowid",rowid,""),-1)
	.i (bbackdr'="")  d
	..s bbackflag1=$p(^DHCJFBankBack(bbackdr),"^",4)
	..i (bbackflag1="0")  d
	...s bbackflag="到帐"
	..e  d
	...s bbackflag="未到帐"
	..s bbackdate=$p(^DHCJFBankBack(bbackdr),"^",6)
	..i (bbackdate'="")  s bbackdate=##class(websys.Conversions).DateLogicalToHtml(bbackdate)
	..s bbacktime=$p(^DHCJFBankBack(bbackdr),"^",7)
	..i (bbacktime'="")  s bbacktime=##class(websys.Conversions).TimeLogicalToHtml(bbacktime,1)
	..s bbackuser1=$p(^DHCJFBankBack(bbackdr),"^",5)
	..i ((bbackuser1'="")&&($d(^SSU("SSUSR",bbackuser1))))  d
	...s bbackuser=$p(^SSU("SSUSR",bbackuser1),"^",2)
	.s yjrefdr=$p(tmp,"^",31)
	.s refreason=""
	.i ((yjrefdr'="")&&($d(^DHCJFYJRREASON(yjrefdr))))  d
	..s refreason=$p(^DHCJFYJRREASON(yjrefdr),"^",2)
	.s retrcptno=$p(tmp,"^",7)
	.d OutputRow
	
	s rcptno="合计",prtdate="",prttime="",payamt=$j(sum,3,2),paymode=""
	s prtstatus="",rcptdr="",arpbl="",adduser="",cardno="",company="",bankdesc=""
	s Adm="",rowid="",jkflag="",select="",paystatus="",bbackflag=""
	s bbackdate="",bbacktime="",bbackuser="",refreason="",authno="",comment=""
	s Type=""
	d OutputRow
    set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow
	set Data=$lb(rcptno,prtdate,prttime,$j(payamt,3,2),paymode,prtstatus,rcptdr,arpbl,adduser,authno,company,bankdesc,Adm,rowid,jkflag,select,paystatus,bbackflag,bbackdate,bbacktime,bbackuser,refreason,cardno,comment,ind,Type,retrcptno,autoFlag,reRcptNo)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query FindDepositType() As websys.Query(ROWSPEC = "depname:%String,rowid:%String")
{
}

ClassMethod FindDepositTypeExecute(ByRef qHandle As %Binary) As %Status
{
    set repid=$I(^CacheTemp)
    set ind=1
    s rowid="0"
    f  s rowid=$o(^ARC("ARCDT",rowid)) q:rowid=""  d
    .s depname=$p(^ARC("ARCDT",rowid),"^",2)
    .d OutputRow1
    set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow1
	set Data=$lb(depname,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query FindPayMode() As websys.Query(ROWSPEC = "paymode:%String,rowid:%String")
{
}

ClassMethod FindPayModeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s rowid="0"
    f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
    .s paymode=$p(^CT("CTPM",rowid),"^",2)
    .q:paymode="卡支付"
    .q:paymode="工伤支付"
    .q:paymode="公疗支付"
    .q:paymode="医保基金支付"
    .d OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(paymode,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query FindBank() As websys.Query(ROWSPEC = "bank:%String,rowid:%String")
{
}

ClassMethod FindBankExecute(ByRef qHandle As %Binary) As %Status
{
    set repid=$I(^CacheTemp)
    set ind=1
    set today=+$h
    set rowid="0"
    for  set rowid=$o(^CMC("CMCBM",rowid)) quit:(rowid="")  do
	.set bankInfo=$g(^CMC("CMCBM",rowid))
	.quit:(bankInfo="")
	.set dateFrom=$p(bankInfo,"^",5)
	.set dateTo=$p(bankInfo,"^",6)
	.quit:((dateFrom'="")&&(dateFrom>today))
	.quit:((dateTo'="")&&(dateTo<today))   //+2018-01-16 ZhYW 过滤不在有效期的
    .set desc=$p(bankInfo,"^",2)
    .do OutputRow3
    
    set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow3
	set Data=$lb(desc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 向表ar_receipts,ar_rcptalloc,ar_rcptpaymode,dhc_sfprintdetail插入数据
ClassMethod InsertDeposit(itmjs As %Library.String = "", itmjsex As %Library.String = "", dep As %String) As %String
{
	n (itmjs, itmjsex, dep)
    s deptype=$p(dep,"^",1)
    s payamt=$p(dep,"^",2)
    s paymode=$p(dep,"^",3)
    s company=$p(dep,"^",4)
    s bank=$p(dep,"^",5)
    s cardno=$p(dep,"^",6)
    s authno=$p(dep,"^",7)
    s adm=$p(dep,"^",8)
    s curno=$p(dep,"^",9)
    s gloc=$p(dep,"^",10)
    s userid=$p(dep,"^",11)
    s endno=$p(dep,"^",12)
    s title=$p(dep,"^",13)
    s banksub=$p(dep,"^",14)
    s comment=$p(dep,"^",15)
    s password=$p(dep,"^",16)
    s rcptrowid=$p(dep,"^",17)
    s transfer=$p(dep,"^",18)     ;中途结算转过来的押金
    s hospital=$p(dep,"^",19)
    s rcptrowid=$g(rcptrowid)
    s currdept=""
    s currward=""
	s papmi=$p(^PAADM(adm),"^",1)
	s currdept=$p(^PAADM(adm),"^",4)
	s currward=$p(^PAADM(adm),"^",70)
    s VisitStatus=$p(^PAADM(adm),"^",20)
	q:(VisitStatus="C") "-1"
	
	s Rcptuseflag=$p(^DHCSFRECEIPT(rcptrowid),"^",7)
	q:(Rcptuseflag'="1") "-2"
    s Rcptcurrentno=$p(^DHCSFRECEIPT(rcptrowid),"^",5)
    q:(Rcptcurrentno'=curno) "-3"

	l +^DHCSFRECEIPT(rcptrowid):3   //+2018-06-07 ZhYW
	i ($d(^DHCSFPRINTDETAIL(0,"RcptNo",curno))'=0) {
		l -^DHCSFRECEIPT(rcptrowid)
		q "-4"
	}
	l -^DHCSFRECEIPT(rcptrowid)

    d ..tb()
    s payamt=+payamt
    k PLIST(1)
    s PLIST(7)=+$h
    s PLIST(11)=0,PLIST(49)=userid,PLIST(52)=papmi,PLIST(3)=gloc,PLIST(48)=gloc_"||"
    &SQL(INSERT INTO ar_receipts VALUES :PLIST())
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    s id=$g(%ROWID)
    k PLIST
    s PLIST(0)=id
    s PLIST(5)=payamt,PLIST(3)=paymode,PLIST(4)=bank,PLIST(21)=company,PLIST(6)=cardno,PLIST(7)=authno
    &SQL(INSERT INTO ar_rcptpaymode VALUES :PLIST())
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    K PLIST
    s PLIST(0)=id
    S PLIST(9)=adm,PLIST(4)=payamt,PLIST(17)=deptype
	&SQL(INSERT INTO ar_rcptalloc VALUES :PLIST())
	i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE
	k PLSIT(1)
	s PLIST(2)=curno
    s PLIST(3)=$p($h,",")
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=adm
    s PLIST(6)=id
    s PLIST(7)=payamt
    s PLIST(8)=""
    s PLIST(9)="1"
    s PLIST(10)=paymode
    s PLIST(11)=bank
    s PLIST(12)=cardno
    s PLIST(13)=company
    s PLIST(14)=deptype
    s PLIST(15)=userid
    s PLIST(21)=userid
    s PLIST(22)="N"
    s PLIST(30)=""
    s PLIST(30)=title
    s PLIST(33)=""
    s PLIST(34)=comment
    s PLIST(35)=password
    s PLIST(36)=banksub
    s PLIST(37)=currward
    s PLIST(38)=currdept    
    s PLIST(39)="N"
    s PLIST(40)=transfer
    s PLIST(45)=hospital
    &SQL(INSERT INTO dhc_sfprintdetail VALUES :PLIST())
    s prtrowid=$g(%ROWID)
    i (SQLCODE'=0) Trollback
    q:(SQLCODE'=0) SQLCODE
    s deptypedesc=$p(^ARC("ARCDT",deptype),"^",2)
    s retcode=..Ok(curno, endno, userid, rcptrowid)
    
    i (transfer="Y") {
	    s InvRowID=$o(^DHCINVPRTZY(0,"ADM",adm,""),-1)
	    i (+InvRowID'=0) {
		    &SQL(UPDATE DHC_INVPRTZY SET prt_comment2='Y' WHERE PRT_Rowid=:InvRowID)
		    s retcode=SQLCODE
		}
	}
    i (retcode'=0) Trollback
	q:(retcode'=0) retcode
    
	d ..tc()
	
	s retval=itmjs_"('"_$ZCVT(retcode_"^"_prtrowid_"^"_id,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
    &javascript<#(retval)#>

	q retcode
}

ClassMethod GetRcptNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", Guser As %String) As %String
{
	k P1
	s rowid="",endno="",curno="",title=""
	;&sql(select rcpt_rowid,rcpt_endno,rcpt_currentno,rcpt_title
	;into :rowid,:endno,:curno,:title
	;from SQLUser.dhc_sfreceipt 
	;where rcpt_lquser=:Guser and rcpt_useflag="1" and rcpt_loc="InPatient")
	s rcptrowid=0
	f  s rcptrowid=$o(^DHCSFRECEIPT(rcptrowid)) q:rcptrowid=""  d
	.s useflag=$p(^DHCSFRECEIPT(rcptrowid),"^",7)
	.q:useflag'="1"
	.s lquser=$p(^DHCSFRECEIPT(rcptrowid),"^",8)
	.q:Guser'=lquser
	.s loc=$p(^DHCSFRECEIPT(rcptrowid),"^",15)
	.q:loc'="I"
	.s endno=$p(^DHCSFRECEIPT(rcptrowid),"^",4)
	.s curno=$p(^DHCSFRECEIPT(rcptrowid),"^",5)
	.s title=$p(^DHCSFRECEIPT(rcptrowid),"^",9)
	.s rowid=rcptrowid
	s str=rowid_"^"_endno_"^"_curno_"^"_title
	s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
    &javascript<#(retval)#>
	q str
}

ClassMethod RefundDeposit(itmjs As %Library.String = "", itmjsex As %Library.String = "", rcptno, endno, prtrowid, refunduser, rcptrowid, rcptflag, refreaid, receiptrowid, moderowid, expstr As %String = "") As %String
{
	//退押金dhc_sfprintdetail
	
	//wangjian 2018-10-15 加入session信息
	s LogonGroup=$p(expstr,"^",1)
	s LogonLoc=$p(expstr,"^",2)
	s LogonHosp=$p(expstr,"^",3)
	;s IPAdress=$p(expstr,"^",4)
	
    d ..tb()
    s retcode=0
    k P1,PLIST
    
    s flag="false"
    s depttype=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13)
    s transfer=$p(^DHCSFPRINTDETAIL(prtrowid),"^",39)
    s depttypedesc=""
    i depttype'=""  d
    .i $d(^ARC("ARCDT",depttype))'=0  d 
    ..s depttypedesc=$p(^ARC("ARCDT",depttype),"^",2)    
    i depttypedesc="住院押金"  d
    .s PLIST(2)=rcptno
    e  d
    .s PLIST(2)=""
    .s rcptflag="N"
    s PLIST(3)=$p($h,",")
    s PLIST(4)=$p($h,",",2)
    s admdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
    s currdept=""
    s currward=""
    i admdr'=""  d
    .s currdept=$p(^PAADM(admdr),"^",4)
    .s currward=$p(^PAADM(admdr),"^",70)
    
    s PLIST(5)=admdr
    s PLIST(6)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",5)
    i $p(^DHCSFPRINTDETAIL(prtrowid),"^",6)<0  d
    .s flag="true"    ;重复打印
    .s PLIST(7)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
    .s PLIST(8)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",7)
    e  d
    .s PLIST(7)="-"_$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
    .s PLIST(8)=$p(^DHCSFPRINTDETAIL(prtrowid),"^")
    s PLIST(9)="3"
    s PLIST(10)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
    i moderowid'=""  d
    .s PLIST(10)=moderowid
    s PLIST(11)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",10)
    s PLIST(12)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11)
    s PLIST(13)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",12)
    s PLIST(14)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13)
    s PLIST(15)=refunduser
    s PLIST(21)=refunduser
    s PLIST(30)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",29)
    s refreaid=$g(refreaid)
    s refreaid=$p(refreaid,$c(1))
    i refreaid'=""  d
    .s PLIST(32)=refreaid
    s PLIST(34)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",33)
    s PLIST(35)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",34)
    s PLIST(36)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",35)
    S PLIST(22)="N"
    s PLIST(37)=currward
    s PLIST(38)=currdept 
    s PLIST(39)="N"
    s PLIST(40)=transfer
	s PLIST(44)=prtrowid     //+2018-03-20 ZhYW 指向原票据RowId
	s PLIST(45)=LogonHosp //wangjian 2018-10-15
    &sql(insert into dhc_sfprintdetail VALUES :PLIST())
    s newrowid=$g(%ROWID)
    i SQLCODE=0 d
    .s P1=$o(^DHCSFPRINTDETAIL(""),-1)
    e  d
    .s P1=""
    .Trollback
    i (SQLCODE=0)&(flag="false")  d
    .&sql(update dhc_sfprintdetail set prt_status='4' where prt_rowid=:prtrowid)
    .i SQLCODE'=0 d
    ..s retcode=-1
    ..Trollback
  
    s retcode=..UpdateAmt(rcptrowid,refunduser,"0")
    i retcode'=0 Trollback
    i rcptflag="Y" d   ;走收据号时,更新收据表
    .s retcode=..Ok(rcptno,endno,refunduser,receiptrowid)
    .i retcode'=0 Trollback
    
    d ..tc()
    s retval=itmjs_"('"_$ZCVT(retcode_"^"_newrowid,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(retcode,"O","JS")_"');"
    &javascript<#(retval)#>
   
    q retcode
}

ClassMethod AbortDeposit(itmjs As %Library.String = "", itmjsex As %Library.String = "", prtid, rcptrowid, Abortuser, refreaid As %Library.String = "") As %String
{
    d ..tb()
    s retcode=0
    s CurDate=+$h,CurTime=$p($h,",",2)
    s tmp=$g(^DHCSFPRINTDETAIL(prtid))
    s addUserId=$p(tmp,"^",14)
    q:addUserId'=Abortuser -111
    
    &sql(update dhc_sfprintdetail set prt_status='2',prt_abortdate=:CurDate,prt_aborttime=:CurTime,prt_yjrefreason_dr=:refreaid where prt_rowid=:prtid and prt_adduserid=:Abortuser) // DingSH 20170215 增加退押金原因
  
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    
    
    i SQLCODE=0 d
    .s retcode=..UpdateAmt(rcptrowid,Abortuser,"0")

    i retcode'=0 Trollback
    q:retcode'=0 retcode
    i $d(^DHCJFQFTOTAL(0,"PRTDR",prtid)) d
    .s qfrowid=$o(^DHCJFQFTOTAL(0,"PRTDR",prtid,""))
    .&sql(update dhc_jfqftotal set qf_status='A' where qf_rowid=:qfrowid )
    .s retcode=retcode+SQLCODE
    .i SQLCODE'=0 Trollback

    q:retcode'=0 retcode
    d ..tc()
    s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(retcode,"O","JS")_"');"
    &javascript<#(retval)#>
    q SQLCODE
}

ClassMethod UpdateAmt(rcptrowid, updateuser, uamt) As %String
{
	;作废收据,退押金
	k PLIST
	s PLIST(8)=uamt
	s PLIST(49)=updateuser
	&sql(update ar_receipts set arrcp_payamount=:uamt,arrcp_adduserid=:updateuser
	     where arrcp_rowid=:rcptrowid)
	s retcode=retcode+SQLCODE
	k PLIST
	s PLIST(5)=uamt
	s paymrowid=rcptrowid_"||1"
	&sql(update ar_rcptpaymode set paym_amt=:uamt where paym_rowid=:paymrowid)
	s retcode=retcode+SQLCODE
	k PLIST
	s PLIST(4)=uamt
	&sql(update ar_rcptalloc set arral_payamt=:uamt where arral_rowid=:paymrowid)
    s retcode=retcode+SQLCODE
	q retcode
}

ClassMethod incre(itmjs As %Library.String = "", itmjsex As %Library.String = "", invno As %String) As %String
{
	;发票号自动累加1
	s lng=$l(invno)
	s ret=invno+1
	s l=$l(ret)
	f i=lng:(-1):(l+1) d
	.s ret="0"_""_ret
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    &javascript<#(retval)#>
	q ret
}

ClassMethod Ok(rcptno, endno, userid, rcptrowid)
{
	s rcptrowid=$g(rcptrowid)
 	q:(rcptrowid="") "-1"
	i rcptno=endno d 
    .s endflag="0"
    e  d
    .s rcptno=..incre("","",rcptno)
    .s endflag="1"
    s retcode=0
    s retcode1=0
    s rcptid=""
    s startno=""
    i endflag="1"  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno 
          where rcpt_rowid=:rcptrowid)
    .s retcode=retcode+SQLCODE
    e  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno,
          Rcpt_useflag='2'
          where rcpt_rowid=:rcptrowid)
    .s retcode=retcode+SQLCODE	
	.&sql(select nvl(rcpt_rowid,""),Rcpt_startno 
	      into :rcptid,:startno
	      from dhc_sfreceipt 
	     where (rcpt_useflag is null or rcpt_useflag="") and Rcpt_lquser=:userid)
	.i (rcptid'="")&(SQLCODE=0)  d
	..&sql(update dhc_sfreceipt set Rcpt_currentno=:startno,
	              Rcpt_useflag='1'
	        where Rcpt_rowid=:rcptid)
	..s retcode=retcode+SQLCODE
	.e  d
	..s retcode1=retcode1+SQLCODE
	q retcode
}

ClassMethod tb()
{
	;n SQLCODE
	;TSTART  s SQLCODE=$zu(34)
	TSTART
	q
}

ClassMethod tc()
{
	;n SQLCODE
	;i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	i $$intp^%qartp TCOMMIT
	q
}

/// insert by cx 2005.08.02
/// w ##class(web.UDHCJFDeposit).getpatinfo("", "", "511")
ClassMethod getpatinfo(itmjs As %String = "", itmjsex As %String = "", Adm As %String) As %String
{
	s ^TMP("getpatinfo")=$lb(itmjs, itmjsex, Adm)
    s papmi=$p(^PAADM(Adm),"^",1)
	s name=$p(^PAPER(papmi,"ALL"),"^",1)
	s PersonID=$p(^PAPER(papmi,"ALL"),"^",9)
    s Mobile=$p($g(^PAPER(papmi,"PER",4)),"^",21)
    s dep=$p(^PAADM(Adm),"^",4)
    s depart=$p(^CTLOC(dep),"^",2)
    s ward1=$p(^PAADM(Adm),"^",70)
    s ward=""
    i (ward1'="") s ward=$p(^PAWARD(ward1),"^",2)
    s bed=##class(web.DHCBillCommon).GetPatBedCode(Adm)
    s admno=$p(^PAPER(papmi,"PER",4),"^",4)
    s regno=$p(^PAPER(papmi,"PAT",1),"^",1)
    s billflag=""
  	s address=$g(^PAPER(papmi,"PER","ADD",1))
    s patbah=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmi, "I", "", "")	;病案号
    s admreason=$p(^PAADM(Adm,1),"^",7)
    i (admreason'="") s admreason=$p(^PAC("ADMREA",admreason),"^",2)
    i ($g(disdate)'="")&&($p($g(billflag),$c(1))["Y")  s inpatflag="F"
    e  s inpatflag="T"
    i (depart["-") s depart=$p(depart,"-",2)
    i (ward["-") s ward=$p(ward,"-",2)
	;增加病人的总费用
    s feesum=0
	s pbid="0"
    f  s pbid=$o(^DHCPB(0,"ADM",Adm,pbid))  q:(pbid="")  d
    .s pbflag=$p(^DHCPB(pbid),"^",16)
    .q:(pbflag="P")
    .s pbamt=$p(^DHCPB(pbid),"^",8)
    .s feesum=feesum+pbamt
    s feesum=$fn(feesum,"",2)
    
	s AdmInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(Adm) 
	s admdate=$p(AdmInOutDateInfo,"^",1)	
	s dischdate=$p(AdmInOutDateInfo,"^",2) 
	;add by lml 2015-01-15 增加病人密级和级别
    s PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
    s EncryptLevel=$p(PatEncryptLevel,"^",1)
    s PatLevel=$p(PatEncryptLevel,"^",2)
    s PatLevelCode=$p(PatEncryptLevel,"^",3)
    ;
    s retcode=$g(name)_"^"_admdate_"^"_$g(depart)_"^"_$g(ward)_"^"_$g(bed)_"^"_$g(admno)_"^"_$g(papmi)_"^"_$g(regno)_"^"_inpatflag_"^"_$g(address)_"^"_$g(patbah)_"^"_admreason_"^"_dischdate_"^"_feesum    //cx 05.04.28 modify old is $p($g(depart),"-",2)
    s retcode=retcode_"^"_EncryptLevel_"^"_PatLevel_"^"_PatLevelCode_"^"_$g(Mobile)_"^"_$g(PersonID)
    ;s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
    ;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(retcode,"O","JS")_"');"
    ;&javascript<#(retval)#>
    q retcode
}

/// w ##class(web.UDHCJFDeposit).getyjdetail("", "", 14907)
ClassMethod getyjdetail(itmjs As %Library.String = "", itmjsex As %Library.String = "", prtrowid As %Library.String = "")
{
    k P1 
    q:$g(prtrowid)="" ""
    s flag=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8) 
    q:flag=2 ""
    s patbah=""
   	s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	s admtime=$p(^PAADM(admno),"^",7)
	s patinfo=..getpatinfo("", "", admno)
	s patname=$p(patinfo,"^",1)
	s admdate=$p(patinfo,"^",2)
	s admtime=$zt(admtime,1)
	;s admdate=admdate_" "_admtime
	s patno=$p(patinfo,"^",8)
	s patdep=$p(patinfo,"^",3)
	s patbed=$p(patinfo,"^",5)
	s patbah=$p(patinfo,"^",11)
	s admreason=$p(patinfo,"^",12)
	s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",1)
	s payamt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
	s payamt=$j(payamt,3,2)
	s amtdx=##class(web.UDHCJFBaseCommon).RMBDXXZH(payamt)
	s bank=$p(^DHCSFPRINTDETAIL(prtrowid),"^",10)
	i (bank'="") s bank=$p(^CMC("CMCBM",bank),"^",2)
	s banksub=$p(^DHCSFPRINTDETAIL(prtrowid),"^",34)
 	s bankdesc=bank_" "_banksub
	s cardno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11)
	s company=$p(^DHCSFPRINTDETAIL(prtrowid),"^",12)
	s paymDR=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
	s paymode=""
	i (paymDR'="") d
	.s paymode=$p(^CT("CTPM",paymDR),"^",2)
	s authno=""
	s rcptdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",5)
	i (rcptdr'="") s authno=$p(^ARRCP(rcptdr,"PAYM",1),"^",5)
	s password=$p(^DHCSFPRINTDETAIL(prtrowid),"^",34)
	i (password="Y") s password="密码支票" 
	//s P1=patname_"^"_patno_"^"_patdep_"^"_payamt_"^"_paymode_"^"_amtdx_"^"_patbed
	s comment=$p(^DHCSFPRINTDETAIL(prtrowid),"^",33)
	s patward=$p(patinfo,"^",4)
	s prtdate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	i (prtdate["-") d
	.s prtyear=$p(prtdate,"-",1)
	.s prtmonth=$p(prtdate,"-",2)
	.s prtday=$p(prtdate,"-",3)
	i (prtdate["/") d
	.s prtyear=$p(prtdate,"/",3)
	.s prtmonth=$p(prtdate,"/",2)
	.s prtday=$p(prtdate,"/",1)
	s prttime=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2),1)
	s prtadduser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
	s depttypedr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13)
	s depttypedesc=""
	i (depttypedr'="")  d
	.i $d(^ARC("ARCDT",depttypedr))'=0  d
	..s depttypedesc=$p(^ARC("ARCDT",depttypedr),"^",2)
	s depttypedesc=$p(depttypedesc,$c(1)) 
	s username=""
	i (prtadduser'="") d
	.s username=$p(^SSU("SSUSR",prtadduser),"^",2)
	.s prtadduser=$p(^SSU("SSUSR",prtadduser),"^",1)    ;工号
	//+2018-06-07 ZhYW 退款原因
	s refReasonDR=$p(^DHCSFPRINTDETAIL(prtrowid),"^",31)
	s refReason=""
	i (+refReasonDR'=0) d
	.s refReason=$p($g(^DHCJFYJRREASON(refReasonDR)),"^",2)
	
	s P1=patname_"^"_patno_"^"_patdep_"^"_payamt_"^"_paymode_"^"_amtdx_"^"_patbed_"^"_""_"^"_patbah_"^"_patward_"^"_admdate_"^"_bankdesc_"^"_company_"^"_cardno_"^"_rcptno_"^"_admreason_"^"_authno_"^"_password_"^"_prtdate_"^"_comment
	s P1=P1_"^"_prtyear_"^"_prtmonth_"^"_prtday_"^"_prttime_"^"_username_"^"_depttypedesc_"^"_prtadduser_"^"_refReason
	
	;add by lml 2015-01-27 增加打印日志
	s myCondition="{prtrowid:"""_prtrowid_"""}"
	s myContent="{prtrowid:"""_prtrowid_""",rcptno:"""_rcptno_"""}"
	s mypapmi=$p(patinfo,"^",7)
 	s mySecretCodeStr=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(mypapmi,"")
 	s mySecretCode=$p(mySecretCodeStr,"^",3)
	s mylog=##class(web.DHCEventLog).EventLog("UDHCJFDeposit.printYJ",myCondition,myContent,mySecretCode)
	;end
	q P1
}

ClassMethod GetDeptypeId(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
 	&sql(select arcdt_rowid into:depid from arc_deptype where arcdt_desc='住院押金')
	q depid
}

ClassMethod GetModeId(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select ctpm_rowid into:modeid from ct_paymode where ctpm_desc='现金')
 	q modeid
}

ClassMethod GetPrtStatus(prtrowid)
{
	s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	s prtstatus=$p(prtstatus,$c(1))
	q prtstatus
}

ClassMethod GetInsu(Adm)
{
  s admreason=$p(^PAADM(Adm,1),"^",7)
  i admreason="" s admreasondesc="自费"
  e  s admreasondesc=$p(^PAC("ADMREA",admreason),"^",2)
  s Adm=" "_Adm
  s flag="1"
  i admreasondesc="医保病人" d
  .i $d(^User.INSUAdmInfoI("IndexOfAdm",Adm)) d
  ..s flag="1"
  .e  s flag=""
  q flag
}

Query FindDeptrefrea() As websys.Query(ROWSPEC = "rreaname:%String,rrearowid:%String")
{
}

ClassMethod FindDeptrefreaExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    set ind=1
    s rowid="0"
    f  s rowid=$o(^DHCJFYJRREASON(rowid)) q:rowid=""  d
    .s depname=$p(^DHCJFYJRREASON(rowid),"^",2)
    .s dependdate=$p(^DHCJFYJRREASON(rowid),"^",4)
    .s stdate=$p(^DHCJFYJRREASON(rowid),"^",3)
    .q:((stdate="")||(stdate>+$h))
    .q:((dependdate'="")&(dependdate<=+$h))
    .d OutputRow4
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(depname,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBillFlag(Adm)
{
	//判断病人是否办理财务结算，如果办了财务结算，则不能交押金
	s BillFlag=""
	s BillFlag=$p(^PAADM(Adm),"^",45)
	//yyx 2009-11-26 如果做了财务结算，还有未结算的金额不为0的账单则允许交押金
	s PBRowID=""
	f  s PBRowID=$o(^DHCPB(0,"ADM",Adm,PBRowID)) q:(PBRowID="")!($g(PayFlag)'="P")  d
	.s TotalAmt=$p(^DHCPB(PBRowID),"^",8)
	.q:TotalAmt=0
	.s PayFlag=$p(^DHCPB(PBRowID),"^",16)
	
	i ($g(PayFlag)'="")&($g(PayFlag)'="P") d  
	.s BillFlag="N" 
	q $g(BillFlag)
}

/// w ##class(web.UDHCJFinfro).getadm("","",a)
ClassMethod getadm(itmjs As %Library.String = "", itmjsex As %Library.String = "", papno)
{
	s str=""
	i (papno'="") s papno=$g(papno)
	s papno=##class(web.UDHCJFBaseCommon).regnocon(papno)
	s name="",ward="",bed="",admreason=""
	s admid=""
	s papmi=""
	s admnum=0
	s str=""
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",papno,papmi)) q:papmi=""  d
	.s name="",ward="",bed=""	
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm),-1) q:(Adm="")!(admnum=1)  d  	
	..s visitstatus=$p(^PAADM(Adm),"^",20)
	..q:visitstatus'="A"
	..s admid=Adm
	..s admnum=admnum+1
	..s str=papno_"^"_Adm
    i (admid="")  d
    .s str=""
    q str
}

/// w ##class(web.UDHCJFinfro).getinfro("","",a)
ClassMethod getinfro(itmjs As %Library.String = "", itmjsex As %Library.String = "", Adm, digcode)
{
	set Adm=$p(Adm,$c(1))
	set str="",address="",zyno="",foreign="",admdate="",foreignphone=""
	set warddesc="",deptdesc="",bedno="",diagnos=""
	set papmi=$p($p($g(^PAADM(Adm)),"^",1),$c(1))
	set admdate=$p(^PAADM(Adm),"^",6)
	set admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
	set admreason=$p($p($g(^PAADM(Adm,1)),"^",7),$c(1))
	set deptid=$p(^PAADM(Adm),"^",4)
	if (deptid'="")  do
	.set deptdesc=$p($g(^CTLOC(deptid)),"^",2)
	.if ($f(deptdesc,"-")'=0)  do
	..set deptdesc=$p(deptdesc,"-",2)
	
	set wardid=$p(^PAADM(Adm),"^",70)
	if (wardid'="")  do
	.set warddesc=$p($g(^PAWARD(wardid)),"^",2)
	.if ($f(warddesc,"-")'=0)  do
	..set warddesc=$p(warddesc,"-",2)
	set bedno=##class(web.DHCBillCommon).GetPatBedCode(Adm)
	set admreasondesc=""
	if (admreason'="") set admreasondesc=$p(^PAC("ADMREA",admreason),"^",2)
	;insert by cx 2007.07.23 增加查询患者诊断
	set digcode=$g(digcode)
	//+2015-3-16 hujunbin 取诊断
	//取诊断的顺序主诊断M->初步诊断PRE->入院诊断C008
	set mradmdr=$p(^PAADM(Adm),"^",61)
	set diagnos=##class(web.UDHCJFBaseCommon).GetMRDiagnosDesc(mradmdr, "", "", "/")
	
	if (papmi'="")  do
	.set name=$p(^PAPER(papmi,"ALL"),"^",1)
	.set papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	.;add by lml 2015-01-15 增加病人密级和级别
	.set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	.set EncryptLevel=$p(PatEncryptLevel,"^",1)
	.set PatLevel=$p(PatEncryptLevel,"^",2)
	.;end
	.;set zyno=$p($g(^PAPER(papmi,"PAT",1)),"^",22)  ;病案号
	.set zyno=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmi, "I", "", "")	;病案号
	.set address=$g(^PAPER(papmi,"PER","ADD",1))
	.set foreign=$p($g(^PAPER(papmi,"PER",2)),"^",13)
	.set foreignphone=$p($g(^PAPER(papmi,"ALL")),"^",4)
	.set workaddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)   ;工作单位
	.set str=papno_"^"_name_"^"_admreasondesc_"^"_address_"^"_zyno_"^"_admdate_"^"_foreign_"^"_foreignphone_"^"_workaddress_"^"_deptdesc_"^"_warddesc_"^"_bedno_"^"_diagnos
	.set str=str_"^"_EncryptLevel_"^"_PatLevel
	
	set retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
	if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
	&javascript<#(retval)#>
	quit 1
}

ClassMethod getabortyjdetail(itmjs As %Library.String = "", itmjsex As %Library.String = "", prtrowid As %Library.String = "")
{
	k P1
    s deptypedr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13)
    q:(deptypedr="") "deptypeerr"
    q:('$d(^ARC("ARCDT",deptypedr))) "deptypeerr"
    s deptype=$p(^ARC("ARCDT",deptypedr),"^",2)
    s deptype=deptypedr_"@"_deptype
    s payamt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
	s paymodedr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
	q:(paymodedr="") "modeerr"
	q:('$d(^CT("CTPM",paymodedr))) "modeerr"
	i paymodedr'="" d
	.s paymode=$p(^CT("CTPM",paymodedr),"^",2)
	s paymode=paymodedr_"@"_paymode
	s bankdr="",bank=""
	s bankdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",10)
	i bankdr'=""  d
	.s bank=$p(^CMC("CMCBM",bankdr),"^",2)
	s bank=bankdr_"@"_bank
	s banksub=$p(^DHCSFPRINTDETAIL(prtrowid),"^",35)
 	s cardno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11)
	s company=$p(^DHCSFPRINTDETAIL(prtrowid),"^",12)
	s password=$p(^DHCSFPRINTDETAIL(prtrowid),"^",34)
	s comment=$p(^DHCSFPRINTDETAIL(prtrowid),"^",33)
	s authno=""
	s rcptdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",5)
	i rcptdr'="" s authno=$p(^ARRCP(rcptdr,"PAYM",1),"^",5)
	s adduserid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
		
	s P1=deptype_"^"_payamt_"^"_paymode_"^"_bank_"^"_banksub_"^"_company_"^"_authno_"^"_cardno_"^"_password_"^"_comment_"^"_adduserid
	q P1
}

ClassMethod AbortCHDeposit(itmjs As %Library.String = "", itmjsex As %Library.String = "", prtid, Abortuser, rcptno, endno, rcptflag, receiptrowid) As %String
{
    d ..tb()
    s retcode=0,str="",prtrowid=""
    k PLIST
    s PLIST(2)=rcptno
    s PLIST(3)=$p($h,",")
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=$p(^DHCSFPRINTDETAIL(prtid),"^",4)
    s PLIST(6)=$p(^DHCSFPRINTDETAIL(prtid),"^",5)
    s PLIST(7)=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
    s PLIST(8)=$p(^DHCSFPRINTDETAIL(prtid),"^",7)
    s PLIST(9)="3"
    s PLIST(10)=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
    s PLIST(11)=$p(^DHCSFPRINTDETAIL(prtid),"^",10)
    s PLIST(12)=$p(^DHCSFPRINTDETAIL(prtid),"^",11)
    s PLIST(13)=$p(^DHCSFPRINTDETAIL(prtid),"^",12)
    s PLIST(14)=$p(^DHCSFPRINTDETAIL(prtid),"^",13)
    s PLIST(15)=$p(^DHCSFPRINTDETAIL(prtid),"^",14)
    s PLIST(21)=$p(^DHCSFPRINTDETAIL(prtid),"^",20)
    s PLIST(30)=$p(^DHCSFPRINTDETAIL(prtid),"^",29)
    s refreaid=$g(refreaid)
    s refreaid=$p(refreaid,$c(1))
    i refreaid'=""  d
    .s PLIST(32)=refreaid
    s PLIST(34)=$p(^DHCSFPRINTDETAIL(prtid),"^",33)
    s PLIST(35)=$p(^DHCSFPRINTDETAIL(prtid),"^",34)
    s PLIST(36)=$p(^DHCSFPRINTDETAIL(prtid),"^",35)
    i PLIST(15)'=Abortuser  s retcode=1
    i retcode=0  d
    .&sql(update dhc_sfprintdetail set prt_status='2' where prt_rowid=:prtid and prt_adduserid=:Abortuser)
    .i SQLCODE'=0  d
    ..Trollback
    .e  d
    ..s retcode=retcode+SQLCODE
    i retcode=0  d
    .&sql(insert into dhc_sfprintdetail VALUES :PLIST())
    .i (SQLCODE'=0)  d
    ..Trollback
    .e  d
    ..s retcode=retcode+SQLCODE
    ..s prtrowid=$g(%ROWID)
    i (retcode=0)  d
    .i (rcptflag="Y") d   ;走收据号时,更新收据表
    ..s retcode2=..Ok(rcptno,endno,Abortuser,receiptrowid)
    ..s retcode=retcode+retcode2
    ..i retcode'=0 Trollback
    i (retcode=0)  d
    .d ..tc()
    s str=retcode_"^"_prtrowid
    s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
    &javascript<#(retval)#>
    q
}

Query FindPayModeGroupId(GuserGroup As %String) As websys.Query(ROWSPEC = "paymode:%String,rowid:%String:ID,RPFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFDeposit","FindPayModeGroupId","21")
ClassMethod FindPayModeGroupIdExecute(ByRef qHandle As %Binary, GuserGroup As %String) As %Status
{
    set repid=$I(^CacheTemp)
 	set ind=1
 	set qHandle=$lb(0,repid,0)
    if (GuserGroup="")  quit $$$OK
    set GSRowID=$o(^DHCOPGSi("GS",0,"GSDR",GuserGroup,0))
    if (GSRowID="") quit $$$OK
    
	set curDate=+$h
	
	set PMSub="0"
    for  set PMSub=$o(^DHCOPGS("GS",GSRowID,"PM",PMSub))  quit:(PMSub="")  do
    .set frmDate=$p(^DHCOPGS("GS",GSRowID,"PM",PMSub),"^",2)
    .set toDate=$p(^DHCOPGS("GS",GSRowID,"PM",PMSub),"^",3)
    .quit:((frmDate'="")&&(curDate>frmDate))
    .quit:((toDate'="")&&(curDate<toDate))
    .set paymDR=$p(^DHCOPGS("GS",GSRowID,"PM",PMSub),"^",1)
	.set paymDR=$p(paymDR,$c(1))
    .quit:((paymDR="")||('$d(^CT("CTPM",paymDR))))
    .set paymode=$p(^CT("CTPM",paymDR),"^",2)
 	.set paymRPFlag=$p(^DHCOPGS("GS",GSRowID,"PM",PMSub),"^",6)
    .do OutputRow5
    
    set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow5
	set Data=$lb(paymode,paymDR,paymRPFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetDefaultDepType(UserGrp)
{
    if $g(UserGrp)="" set UserGrp=$g(%session.Data("LOGON.GROUPID"))
    set deptypename=""
	set rowid="0"
    for  set rowid=$o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",UserGrp,rowid)) quit:(rowid="")  do
    .set Default=$p(^DHCJFSSGRPDEPTYPECONFIG(rowid),"^",3)
    .quit:(Default="N")
    .set deptyperowid=$p(^DHCJFSSGRPDEPTYPECONFIG(rowid),"^",2)
    .set deptypename=$p(^ARC("ARCDT",deptyperowid),"^",2)
    
    quit deptypename
}

/// Creator：         李超
/// CreatDate：       2009.2.7
/// Description：     对补打押金收据进行记录
ClassMethod InsertRepGloble(PrtRowid, PrtUser)
{
	s rtn=-1
	s RepNum=0,NewNum=0,StNum=1
	s CurDate=+$h,CurTime=$p($h,",",2)
	i $d(^DHCSFPRINTDETAIL("PRINT",PrtRowid))  d
	.s RepNum=$o(^DHCSFPRINTDETAIL("PRINT",PrtRowid,""),-1)
	.s NewNum=RepNum+1
	.s ^DHCSFPRINTDETAIL("PRINT",PrtRowid,NewNum)=CurDate_"^"_CurTime_"^"_PrtUser_"^"_NewNum
	.s rtn=0
	e  d
	.s ^DHCSFPRINTDETAIL("PRINT",PrtRowid,StNum)=CurDate_"^"_CurTime_"^"_PrtUser_"^"_StNum
	.s rtn=0
    q rtn
}

ClassMethod GetDepositPYM(EpisodeID)
{
   n (EpisodeID)
   s EpisodeID=$g(EpisodeID)
   q:(EpisodeID="") ""
   s ARRCPDR="",depAmt=0                        ;table - AR_RcptAlloc
   s DepositDR="0"
   k ^TMP("DHCIPBILLDepositPAYM",$j,EpisodeID)
   f  s DepositDR=$o(^DHCSFPRINTDETAIL(0,"adm",EpisodeID,DepositDR))  q:(DepositDR="")  d
   .s ARRCPDR=$p(^DHCSFPRINTDETAIL(DepositDR),"^",5)
   .q:(ARRCPDR="")
   .s PrtStatus=$p(^DHCSFPRINTDETAIL(DepositDR),"^",8)
   .q:(PrtStatus="2")
   .s DepositTypeDR=$p(^DHCSFPRINTDETAIL(DepositDR),"^",13)
   .q:(DepositTypeDR="")
   .s DepositType=$p(^ARC("ARCDT",DepositTypeDR),"^",2)
   .q:DepositType'["住院押金"
   .s ARRALDR="0",ARRCPAmt=0
   .f  s ARRALDR=$o(^ARRCP(ARRCPDR,"RAL",ARRALDR))  q:(ARRALDR="")  d
   ..q:+$p(^ARRCP(ARRCPDR,"RAL",ARRALDR),"^",18)'=0
   ..s Amt=+$p(^ARRCP(ARRCPDR,"RAL",ARRALDR),"^",2)  
   ..s ARRCPAmt=ARRCPAmt+Amt
   .q:(+ARRCPAmt=0)
   .s PAYMDr=$p(^DHCSFPRINTDETAIL(DepositDR),"^",9)
   .s PAYMDesc=""
   .i PAYMDr'=""  d
   ..s PAYMDesc=$p(^CT("CTPM",PAYMDr),"^",2)
   ..s ^TMP("DHCIPBILLDepositPAYM",$j,EpisodeID,PAYMDesc)=""  
   s PAYMDescStr="" 
   s PAYMDesc="" 
   f   s PAYMDesc=$o(^TMP("DHCIPBILLDepositPAYM",$j,EpisodeID,PAYMDesc))  q:(PAYMDesc="")  d
   .i PAYMDescStr=""  d
   ..s PAYMDescStr=PAYMDesc
   .e  d
   ..s PAYMDescStr=PAYMDescStr_"^"_PAYMDesc   
   k ^TMP("DHCIPBILLDepositPAYM",$j,EpisodeID)
   q PAYMDescStr
}

ClassMethod getyjinfo(prtrowid As %Library.String = "")
{
    k P1  
    q:$g(prtrowid)="" "^^"
	s prtuser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
	s username="",userinitnals=""
	i prtuser'="" d
	.s username=$p(^SSU("SSUSR",prtuser),"^",2)
	.s userinitnals=$p(^SSU("SSUSR",prtuser),"^",1)
	s P1=prtuser_"^"_username_"^"_userinitnals
	q P1
}

/// Creator: ZhYW
/// CreatDate: 2018-05-18
/// Description: 取押金数量
/// Input:
/// Output:
/// Debug: w ##class(web.UDHCJFDeposit).GetDepositNum()
ClassMethod GetDepositNum(episodeId As %String, depType As %String) As %String
{
	new (episodeId, depType)
	set depNum=0
	quit:(+episodeId=0) depNum
	if (depType="") do
 	.set depType=..GetDefaultDepType("")
	
 	set rowid=0
 	for  set rowid=$o(^DHCSFPRINTDETAIL(0,"adm",episodeId,rowid)) quit:(rowid="")  do
 	.set depInfo=$g(^DHCSFPRINTDETAIL(rowid))
 	.quit:(depInfo="")
 	.set typeDR=$p(depInfo,"^",13)
 	.set type=""
 	.if (+typeDR'=0) set type=$p(^ARC("ARCDT",typeDR),"^",2)
	.quit:((depType'="")&&(depType'=type))
	.set prtStatus=$p(depInfo,"^",8)
	.quit:(prtStatus=2)
 	.set depNum=$i(depNum)
	
	quit depNum
}

}
