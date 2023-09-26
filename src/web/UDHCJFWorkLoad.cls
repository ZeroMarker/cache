Class web.UDHCJFWorkLoad Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindWorkLoad(stdate As %String, enddate As %String, grp As %String) As websys.Query(ROWSPEC = "Tuser:%String,Tadmitnum:%String,Tdischnum:%String,Tdepositnum:%String,Tdepositsum:%String,Trcptnum:%String,Trcptsum:%String,Tallnum:%String,Tallsum:%String,Tcancelnum:%String,Tpay1:%String,Tpay2:%String,Tpay3:%String,Tpay4:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFWorkLoad","FindWorkLoad","60720","60730","3")
ClassMethod FindWorkLoadExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, grp As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (grp="")  quit $$$OK

    k ^TMP("ZYYJUser")
    k ^tmp("ZYYJUserDeposit")
    k ^tmp("ZYYJDepositnum")
    
    s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
    i (stdate="")  s stdate=+$h
    i (enddate="")  s enddate=+$h
    
    f m=1:1:10  d
    .s depositall(m)=0
    s m=0,number=1
    s admitallnum=0,depallsum=0,depallnum=0,dischallnum=0,rcptallnum=0,rcptallsum=0
    s cancelnum=0,cancelallnum=0

    s rowid=$o(^DHCJFRcptGroupSet(0,"Type","I",grp,""))
    i (rowid'="") d
    .s sub=0
    .f  s sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) q:(sub="")  d
    ..s usrrowid=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",4)
    ..s usrgrp=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",3)
    ..s depositstr=..GetDeposit(usrrowid, stdate, enddate)
    ..s depositnum=$p(depositstr,"^",1)
    ..;q:depositnum=0         ;如果没有押金记录，q出去 2008-02-13
    ..s usrname=$p($g(^SSU("SSUSR",usrrowid)),"^",2)
    ..s m=m+1
    ..s admitnum=..GetPatNum(usrrowid, stdate, enddate)
    ..s admitallnum=admitallnum+admitnum
    ..s number=number+1      ;记录有多少条数据
    ..s depositsum=$p(depositstr,"^",2)
    ..f m=1:1:4  d
 	...s deposit(m)=paym(m)
 	...s depositall(m)=depositall(m)+deposit(m)
    ..s depallsum=depallsum+depositsum
    ..s depallnum=depallnum+depositnum
    ..s patfeestr=..GetDisch(usrrowid, stdate, enddate)
    ..s dischnum=$p(patfeestr,"^",1)
    ..s rcptnum=$p(patfeestr,"^",2)
    ..s rcptsum=$p(patfeestr,"^",3)
    ..s dischallnum=dischallnum+dischnum
    ..s rcptallnum=rcptallnum+rcptnum
    ..s rcptallsum=rcptallsum+rcptsum
    ..s cancelnum=..GetCancel(usrrowid, stdate, enddate)
    ..s cancelallnum=cancelallnum+cancelnum
    ..q:(depositnum=0)&(depositsum=0)&(dischnum=0)&(rcptnum=0)&(rcptsum=0)&(cancelnum=0)&(admitnum=0)&(dischnum=0)
    ..d OutputRow
    
    set usrname="合计"
    s admitnum=admitallnum
    s dischnum=dischallnum
    s depositnum=depallnum
    s depositsum=depallsum
    s rcptnum=rcptallnum
    s rcptsum=rcptallsum
    s cancelnum=cancelallnum
    f m=1:1:4  d
    .s deposit(m)=depositall(m)
    s ^tmp("ZYYJDepositnum",1)=number
    d OutputRow

	quit $$$OK
OutputRow
    set allnum=depositnum+rcptnum
    set allsum=depositsum+rcptsum
	set Data=$lb(usrname,admitnum,dischnum,depositnum,$j(depositsum,3,2),rcptnum,$j(rcptsum,3,2),allnum,$j(allsum,3,2),cancelnum,$j(deposit(1),3,2),$j(deposit(2),3,2),$j(deposit(3),3,2),$j(deposit(4),3,2))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetPatNum(user, stdate, enddate) As %String
{
	s num=0
	f admitdate=stdate:1:enddate d
	.s admrowid=""
	.f  s admrowid=$o(^PAADMi("PAADM_AdmDate",admitdate,admrowid)) q:admrowid=""  d
	..s type=$p(^PAADM(admrowid),"^",2)
	..q:(type'="I")
	..s visitstatus=$p(^PAADM(admrowid),"^",20)
	..q:(visitstatus="C")
	..s createuser=$p(^PAADM(admrowid),"^",43)
	..q:(createuser'=user)
	..s num=num+1
	
	q num
}

ClassMethod GetDeposit(user, stdate, enddate) As %String
{
    s num=0,sum=0             ;总金额
    s deppaystr=""
    k ^TMP("ZYYJUser",user)
	f jkdate=stdate:1:enddate  d
	.s jkrowid=""
	.f  s jkrowid=$o(^DHCJFUSERJK(0,"date",jkdate,jkrowid)) q:jkrowid=""  d
	..s prtrowid=""
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkrowid,prtrowid)) q:prtrowid=""   d
	...s prtuser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s payamt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
	...s paymode=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
	...i (paymode'="") s paymodedesc=$p(^CT("CTPM",paymode),"^",2)
	...q:(prtuser'=user)
	...s num=num+1
	...q:prtstatus="2"
	...s sum=sum+payamt
	...i '$d(^TMP("ZYYJUser",prtuser,paymode))  d
	....s ^TMP("ZYYJUser",prtuser,paymode)=payamt
	...e  d
	....s ^TMP("ZYYJUser",prtuser,paymode)=^TMP("ZYYJUser",prtuser,paymode)+payamt
	
	s payrowid="0"                       ;动态取各种支付方式的金额  2008-02-13
	f  s payrowid=$o(^CT("CTPM",payrowid))  q:(payrowid="")!(payrowid>4)  d
	.s paym(payrowid)=0.00
	.i '$d(^TMP("ZYYJUser",user,payrowid))  d
	..s paym(payrowid)=0.00
	.e  d
	..s paym(payrowid)=^TMP("ZYYJUser",user,payrowid)
	.i (deppaystr="")  d
	..s deppaystr=paym(payrowid)
	.e  d
	..s deppaystr=deppaystr_"^"_paym(payrowid)

	q num_"^"_sum_"^"_deppaystr
}

ClassMethod GetDisch(user, stdate, enddate) As %String
{
	s discnum=0,rcptnum=0,rcptsum=0  //出院结算人数，发票张数，发票总额
	f jkdate=stdate:1:enddate  d
	.s jkrowid=""
	.f  s jkrowid=$o(^DHCJFUSERJK(0,"date",jkdate,jkrowid)) q:jkrowid=""  d
	..s prtrowid=""
	..f  s prtrowid=$o(^DHCINVPRTZY(0,"JK",jkrowid,prtrowid)) q:prtrowid=""  d
	...s prtuser=$p(^DHCINVPRTZY(prtrowid),"^",7)
	...s acount=$p(^DHCINVPRTZY(prtrowid),"^",6)
	...s prtflag=$p(^DHCINVPRTZY(prtrowid),"^",8)	
	...q:(prtuser'=user)
	...s rcptnum=rcptnum+1
	...q:(prtflag="A")
	...s discnum=discnum+1
	...s rcptsum=rcptsum+acount

	q discnum_"^"_rcptnum_"^"_rcptsum
}

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", ind)
{
	s str=$g(^tmp("ZYYJUserDeposit",ind))
	q str
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	s num=$g(^tmp("ZYYJDepositnum",1)) 
	q num
}

ClassMethod GetCancel(user, stdate, enddate) As %String
{
	s num=0
	f admitdate=stdate:1:enddate d
	.s admrowid=""
	.f  s admrowid=$o(^PAADMi("UpdDate",admitdate,admrowid)) q:(admrowid="")  d
	..s type=$p(^PAADM(admrowid),"^",2)
	..q:(type'="I")
	..s visitstatus=$p(^PAADM(admrowid),"^",20)
	..q:(visitstatus'="C")
	..s updateuser=$p(^PAADM(admrowid,1),"^",44)
	..q:(updateuser'=user)
	..s num=num+1
	
	q num
}

ClassMethod getpaymode()
{
	 ;;add 2008-02-13 by lc 取支付方式
	 s paymodedr=0,paymodestr="",num=0
	 f  s paymodedr=$o(^CT("CTPM",paymodedr)) q:(paymodedr="")  d
	 .q:'$d(^CT("CTPM",paymodedr))
	 .s paymodedes=$p($g(^CT("CTPM",paymodedr)),"^",2)
	 .i (paymodestr="")  d
	 ..s paymodestr=paymodedes
	 .e  d
	 ..s paymodestr=paymodestr_"^"_paymodedes
	 .s num=num+1
	 
	 q paymodestr
}

}
