Import SQLUser

Class web.UDHCJFYJ Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 322;

Query Getdeptype() As %SQLQuery(CONTAINID = 1, ROWSPEC = "arcdt_rowid:%Integer,arcdt_desc:%String")
{
	select arcdt_rowid,arcdt_desc from SQLUser.arc_deptype
}

Query Getpaymode() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ctpm_rowid:%Integer,ctpm_desc:%String")
{
	select ctpm_rowid,ctpm_desc from SQLUser.ct_paymode where not ctpm_code['INSU'
}

Query Getbank() As %SQLQuery(CONTAINID = 1, ROWSPEC = "cmcbm_rowid:%Integer,cmcbm_desc:%String")
{
	select cmcbm_rowid,cmcbm_desc from SQLUser.cmc_bankmas
}

ClassMethod getuser(user) As %String
{
    k P1,P2,P3       
    &sql(select ssusr_initials,ssusr_name,ssusr_group 
           into :usercode,:username,:usergroup
           from ss_user where ssusr_rowid = :user)
	s P1=$g(usercode)
	s P2=$g(username)
	s P3=$P($g(usergroup),$C(1))
	q P1_"^"_P2_"^"_P3
}

ClassMethod DepositClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = DepositExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DepositExecute(ByRef QHandle As %Binary, User As %String, Adm As %String) As %Status
{
    New repid, ind
	///do ResetVariables
 	Set repid=$I(^CacheTemp)
	 k PLIST,P3,P1
    s ind=1
    &sql(select paadm_papmi_dr->papmi_name,
                paadm_admdate,
                paadm_depcode_dr->ctloc_desc,
                paadm_currentward_dr->ward_desc,
                paadm_currentbed_dr->bed_code,
                paadm_papmi_dr->papmi_paper_dr->paper_governcardno,
                paadm_papmi_dr,
                paadm_papmi_dr->papmi_no,
                paadm_dischgdate,
                paadm_billflag
    into :name,:date,:depart,:ward,:bed,:admno,:papmi,:regno,:disdate,:billflag
    from pa_adm 
    where paadm_rowid=:Adm)
    i ($g(disdate)'="")&($p($g(billflag),$c(1))["Y")  s inpatflag="F"
    e  s inpatflag="T" 
    s P3=$g(name)_"^"_$zd($g(date),3)_"^"_$p($g(depart),"-",2)_"^"_$g(ward)_"^"_$g(bed)_"^"_$g(admno)_"^"_$g(papmi)_"^"_$g(regno)_"^"_inpatflag
    
    s prtrowid=""
    f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,prtrowid)) q:prtrowid=""  d
    .s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",1)
    .s prtdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",2)
    .s prtdate=$zd(prtdate,1)
    .s userid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",20)
    .s username=$p(^SSU("SSUSR",userid),"^",2)
    .s payamount=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
    .s rcptdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",5)
    .s paymode=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
    .s paymode=$p(^CT("CTPM",paymode),"^",2)
    .s company=$p(^DHCSFPRINTDETAIL(prtrowid),"^",12) ;支付单位
    .s depositlx=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13) ;押金类型
    .s depositlx=$p(^ARC("ARCDT",depositlx),"^",2)
    .s arpbil=$P(^ARRCP(rcptdr,"RAL",1),"^",18)
    .s bank=$p(^DHCSFPRINTDETAIL(prtrowid),"^",10) ;支付单位
    .s bank=$p(^CMC("CMCBM",bank),"^",2)           ;银行
    .s chequeno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11) ;卡号/支票号
    .s authorcode=$P(^ARRCP(rcptdr,"PAYM",1),"^",5)                                 ;信用卡号
    .///prt_rcpt_dr->ar_rcptpaymode->paym_paymode_dr->ctpm_desc,
    .///prt_rcpt_dr->ar_rcptpaymode->paym_governno,
    .///prt_deposit_dr->arcdt_desc,
    .///prt_rcpt_dr->AR_rcptalloc->arral_arpbil_dr,
    ./// prt_rcpt_dr->ar_rcptpaymode->paym_cmbank_dr->cmcbm_desc,
    .///             prt_rcpt_dr->ar_rcptpaymode->paym_cardchequeno,
    .s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
    .d OutputRow
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rcptno,prtdate,payamount,paymode,company,bank,chequeno,authorcode,prtstatus,depositlx,prtrowid,userid,rcptdr,arpbl,username)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTCode,CTDesc,CTPWD)=""
	quit
}

ClassMethod DepositFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepositExecute ]
{
 // This fetch method should never have to change. 

 // repid - Report ID
 // ind   - sequence index which represents each row

 New repid,ind

 // Restore QHandle
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query Deposit(User As %String, Adm As %String) As %Query(ROWSPEC = "rcptno:%String,prtdate:%Date") [ SqlProc ]
{
}

ClassMethod getdeposit(User As %String, Adm As %String)
{
    k PLIST,P3,P1,^TMP("ZYJF",$j)
    s ind=1
    &sql(select paadm_papmi_dr->papmi_name,
                paadm_admdate,
                paadm_depcode_dr->ctloc_desc,
                paadm_currentward_dr->ward_desc,
                paadm_currentbed_dr->bed_code,
                paadm_papmi_dr->papmi_paper_dr->paper_governcardno,
                paadm_papmi_dr,
                paadm_papmi_dr->papmi_no,
                paadm_dischgdate,
                paadm_billflag
    into :name,:date,:depart,:ward,:bed,:admno,:papmi,:regno,:disdate,:billflag
    from pa_adm 
    where paadm_rowid=:Adm)
    i ($g(disdate)'="")&($p($g(billflag),$c(1))["Y")  s inpatflag="F"
    e  s inpatflag="T" 
    s P3=$g(name)_"^"_$zd($g(date),3)_"^"_$p($g(depart),"-",2)_"^"_$g(ward)_"^"_$g(bed)_"^"_$g(admno)_"^"_$g(papmi)_"^"_$g(regno)_"^"_inpatflag
    
    s prtrowid=""
    f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,prtrowid)) q:prtrowid=""  d
    .s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",1)
    .s prtdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",2)
    .s prtdate=$zd(prtdate,1)
    .s userid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",20)
    .s username=$p(^SSU("SSUSR",userid),"^",2)
    .s payamount=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
    .s rcptdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",5)
    .s paymode=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
    .s paymode=$p(^CT("CTPM",paymode),"^",2)
    .s company=$p(^DHCSFPRINTDETAIL(prtrowid),"^",12) ;支付单位
    .s depositlx=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13) ;押金类型
    .s depositlx=$p(^ARC("ARCDT",depositlx),"^",2)
    .s arpbil=$P(^ARRCP(rcptdr,"RAL",1),"^",18)
    .s bank=$p(^DHCSFPRINTDETAIL(prtrowid),"^",10) ;支付单位
    .i bank'="" s bank=$p(^CMC("CMCBM",bank),"^",2)           ;银行
    .s chequeno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11) ;卡号/支票号
    .s authorcode=$P(^ARRCP(rcptdr,"PAYM",1),"^",5)                                 ;信用卡号
    .s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
    .i prtstatus="1" s prtstatus="正常"
    .i prtstatus="2" s prtstatus="作废"
    .i prtstatus="3" s prtstatus="冲红"
    .i prtstatus="4" s prtstatus="已冲红"
    .s jkflag=$p(^DHCSFPRINTDETAIL(prtrowid),"^",23)
    .s ^TMP("ZYJF",$j,ind)=rcptno_"^"_prtdate_"^"_payamount_"^"_paymode_"^"_prtstatus_"^"_company_"^"_bank_"^"_chequeno_"^"_authorcode_"^"_depositlx_"^"_prtrowid_"^"_userid_"^"_rcptdr_"^"_arpbil_"^"_username_"^"_jkflag
	.;s ^mPLIST(Adm,ind)=rcptno_"^"_prtdate_"^"_payamount_"^"_paymode_"^"_company_"^"_bank_"^"_chequeno_"^"_authorcode_"^"_prtstatus_"^"_depositlx_"^"_prtrowid_"^"_userid_"^"_rcptdr_"^"_arpbl_"^"_username
	.s ind=ind+1
	s ind=ind-1
	q ind_"^"_$j
}

ClassMethod tran()
{
    n SQLCODE
    TSTART  s SQLCODE=$zu(34)
	q SQLCODE
     ;q 0
}

ClassMethod comSS()
{
	s SQLCODE=0
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q SQLCODE 
    ; TCOMMIT
    ; q 0
}

ClassMethod roll()
{
    
    TROLLBACK
    q 0
}

ClassMethod getrcptno(guser As %String) As %String
{
	k P1
	s rowid="",endno="",curno="",title=""
	&sql(select rcpt_rowid,rcpt_endno,rcpt_currentno,rcpt_title
	into :rowid,:endno,:curno,:title
	from SQLUser.dhc_sfreceipt 
	where rcpt_lquser=:guser and rcpt_useflag='1')
	s P1=rowid_"^"_endno_"^"_curno_"^"_title
	q P1
}

ClassMethod incre(invno) As %String
{
   //发票号自动累加1
	s lng=$l(invno)
	s ret=invno+1
	s l=$l(ret)
	f i=lng:(-1):(l+1) d
	.s ret="0"_""_ret
	q ret
}

ClassMethod judgestrike(rcptno) As %String
{
	s prtrowid="",strike=""
	&sql(select prt_rowid into:prtrowid from dhc_sfprintdetail where prt_refundrcpt=:rcptno and prt_status='3')
	q prtrowid
}

ClassMethod judgeabort(prtrowid) As %String
{
	s status=""
	&sql(select prt_status into:status from dhc_sfprintdetail where prt_rowid=:prtrowid)
	q status
}

ClassMethod cancelrcpt(prtid, userid) As %String
{
    &sql(update dhc_sfprintdetail set prt_status='2' where prt_rowid=:prtid and prt_adduserid=:userid)
    q SQLCODE
}

ClassMethod updateamt(depositid, updateuser, uamt) As %String
{
	;作废收据,退押金
	k PLIST
	s PLIST(8)=uamt
	s PLIST(49)=updateuser
	&sql(update ar_receipts set arrcp_payamount=:uamt,arrcp_adduserid=:updateuser
	     where arrcp_rowid=:depositid)
	;d update^MVBARREC(depositid)
	q:SQLCODE'=0 -1
	k PLIST
	s PLIST(5)=uamt
	s paymrowid=depositid_"||1"
	&sql(update ar_rcptpaymode set paym_amt=:uamt where paym_rowid=:paymrowid)
	;d update^MVBARRPM(depositid_"||1")
	q:SQLCODE'=0 -1
	k PLIST
	s PLIST(4)=uamt
	&sql(update ar_rcptalloc set arral_payamt=:uamt where arral_rowid=:paymrowid)
	;d update^MVBARRCA(depositid_"||1")
	q:SQLCODE'=0 -1
	q SQLCODE
}

ClassMethod addamount(usr, amt, adm, dep) As %String
{
	;向表ar_receipts,ar_rcptalloc,ar_rcptpaymode插入数据
    n (usr,amt,adm,dep)
    s amt=+amt
    k PLIST(1)
    s PLIST(7)=+$h
    s PLIST(11)=0,PLIST(49)=usr,PLIST(52)=+$p(dep,"^",7),PLIST(3)=$p(dep,"^",8),PLIST(48)=$p(dep,"^",8)_"||"
    &sql(insert into ar_receipts values :PLIST())
    ;$$insert^MVBARREC()
    q:SQLCODE'=0 SQLCODE
    s id=$g(%ROWID)
    new (id,amt,dep,adm) 
    s PLIST(0)=id
    s PLIST(5)=amt,PLIST(3)=$p(dep,"^",1),PLIST(4)=$p(dep,"^",4),PLIST(21)=$p(dep,"^",2),PLIST(6)=$p(dep,"^",5),PLIST(7)=$p(dep,"^",6)
    &sql(insert into ar_rcptpaymode values :PLIST())
    ;d insert^MVBARRPM(id)
    q:SQLCODE'=0 -1
    new (id,amt,dep,adm)
    s PLIST(0)=id
    S PLIST(9)=adm,PLIST(4)=amt,PLIST(17)=$p(dep,"^",3)
	&sql(insert into ar_rcptalloc values :PLIST())
	q:SQLCODE'=0 -1
	s P4=id
	q SQLCODE_"^"_id
}

ClassMethod adddeposit(str) As %String
{
	;表dhc_sfprintdetail插入数据
    k P1,PLIST
  
    s amt=+$p(str,"^",4)
    s PLIST(2)=$p(str,"^")
    s PLIST(3)=$p($h,",")
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=$p(str,"^",2)
    s PLIST(6)=$p(str,"^",3)
    s PLIST(7)=amt   ;$p(str,"^",4)
    s PLIST(8)=$p(str,"^",5)
    s PLIST(9)="1"
    s PLIST(10)=$p(str,"^",6)
    s PLIST(11)=$p(str,"^",7)
    s PLIST(12)=$p(str,"^",8)
    s PLIST(13)=$p(str,"^",9)
    s PLIST(14)=$p(str,"^",10)
    s PLIST(15)=$p(str,"^",11)
    s PLIST(21)=$p(str,"^",11)
    s PLIST(30)=$p(str,"^",12)
    s PLIST(31)=""
    &sql(insert into dhc_sfprintdetail VALUES :PLIST())
    i 'SQLCODE  d
    . s P1=$g(%ROWID)
    e  d
    .s P1=""
    q SQLCODE_"^"_P1
}

ClassMethod refunddeposit(rcptid, prtrowid, refunduser) As %String
{
	//退押金dhc_sfprintdetail
    s retcode=0
    k P1,PLIST
    s flag="false"
    s PLIST(2)=rcptid
    s PLIST(3)=$p($h,",")
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
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
    s PLIST(11)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",10)
    s PLIST(12)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11)
    s PLIST(13)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",12)
    s PLIST(14)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13)
    s PLIST(15)=refunduser
    s PLIST(21)=refunduser
    s PLIST(30)=$p(^DHCSFPRINTDETAIL(prtrowid),"^",29)
    &sql(insert into dhc_sfprintdetail VALUES :PLIST())
    i SQLCODE=0 d
    .s P1=$o(^DHCSFPRINTDETAIL(""),-1)
    e  d
    .s P1=""
    i (SQLCODE=0)&(flag="false")  d
    .&sql(update dhc_sfprintdetail set prt_status='4' where prt_rowid=:prtrowid)
    .i SQLCODE'=0 d
    ..s retcode=-1
    q retcode
}

ClassMethod getpatinfo(Adm)
{
	
	k P3
	&sql(select paadm_papmi_dr->papmi_name,
                paadm_admdate,
                paadm_depcode_dr->ctloc_desc,
                paadm_currentward_dr->ward_desc,
                paadm_currentbed_dr->bed_code,
                paadm_papmi_dr->papmi_paper_dr->paper_governcardno,
                paadm_papmi_dr,
                paadm_papmi_dr->papmi_no,
                paadm_dischgdate,
                paadm_billflag,
                paadm_papmi_dr->papmi_paper_dr->paper_stnameline1
    into :name,:date,:depart,:ward,:bed,:admno,:papmi,:regno,:disdate,:billflag,:address
    from pa_adm 
    where paadm_rowid=:Adm)
    i ($g(disdate)'="")&($p($g(billflag),$c(1))["Y")  s inpatflag="F"
    e  s inpatflag="T" 
    s P3=$g(name)_"^"_$zd($g(date),3)_"^"_$g(depart)_"^"_$g(ward)_"^"_$g(bed)_"^"_$g(admno)_"^"_$g(papmi)_"^"_$g(regno)_"^"_inpatflag_"^"_address    //cx 05.04.28 modify old is $p($g(depart),"-",2)
    q P3
}

/// w ##class(web.UDHCJFYJ).RMBDXXZH(0.07)
ClassMethod RMBDXXZH(numstr As %String) As %String
{
	n (numstr)
	s numstr=$tr(numstr," ","")
	s i=0,lendec=0,lenint=0
	S a="",b="",c="",d="",bbak="",bs=""
	s flagzf=""
	s numstr=+numstr
	i (numstr<0)  d
	.s numstr=$p(numstr,"-",2)
	.s flagzf=1
	i $p(numstr,".",1)=""  s numstr="0"_numstr
	s lenint=$l($p(numstr,".",1))
	q:(lenint>13) "-1^金额过大"
	s lendec=2
	i $p(numstr,".",2)="00" s lendec=0  
	s dxint(13)="",dxdec(2)="",sz(13)=""
	s dxstr="万|仟|佰|拾|亿|仟|佰|拾|万|仟|佰|拾|元"
	s szstr="零|壹|贰|叁|肆|伍|陆|柒|捌|玖"
	s lendxstr=$l(dxstr,"|")+1
	s lenszstr=$l(szstr,"|")+1
	f i=1:1:lendxstr d
	.s dxint(i)=$p(dxstr,"|",lendxstr-i)
	.s sz(i)=" "
	.i (i<11)  s sz(i)=$p(szstr,"|",i)  
	s dxdec(1)="角",dxdec(2)="分",dxstr=" "
	;**整数部分**
	f i=1:1:lenint d
	.s a=$e($e(numstr,1,lenint),i,i)
	.s b=sz(a+1)
	.s c=dxint(lenint-i+1)
	.s d=" "
	.i (dxstr'=" ")  s d=$e(dxstr,$l(dxstr)-1,($l(dxstr)-1)+2-1)  
	.i (a="0")  s b="",bs="零"
	.i (b="零")&((d="零")!(b=bbak)!(c="元")!(c="万")!(c="亿"))  s b=""
	.i (a="0")&(c'="元")&(c'="万")&(c'="亿") s c=""
	.i (dxstr["亿")&($p(dxstr,"亿",2)="")&(c'="元")&(a=0) s c=""
	.i (dxstr["万")&($p(dxstr,"万",2)="")&(c'="元")&(a=0) s c=""
	.i ((c="元")!(c="万")!(c="亿"))&(d="零")&(a="0")  d 
	..s dxstr=$e(dxstr,1,1+($l(dxstr)-2)-1)
	.s d=$e(dxstr,$l(dxstr)-1,($l(dxstr)-1)+2-1)
	.i (c="元")&(d="万")&(c="万")&(d="亿")  s c=""
	.i (bs="零")&(a'=0)&(a'="") s b=bs_b,bs=""
	.s dxstr=dxstr_b_c,bbak=b
	;
	;**小数部分**
	i ($p(numstr,".",2)=0)!(lendec=0)!($p(numstr,".",2)="")  s dxstr=dxstr_"整" 
	i ($p(numstr,".",2)>0)  d
	.f i=1:1:lendec d
	..s a=$e($p(numstr,".",2),i,i)
	..s b=sz(a+1)
	..i ((a="0")&&(dxdec(i)="分"))  s b=""
	..i (a="0")  s dxstr=dxstr_b
	..i (a'="0")  s dxstr=dxstr_b_dxdec(i)
	
	//+2018-06-07 ZhYW
	s dxstr=$tr(dxstr, " ", "")
	i (+numstr<0.1) d
	.s dxstr=$e(dxstr,3,$l(dxstr))
	e  i (+numstr<1)  d
	.s dxstr=$e(dxstr,2,$l(dxstr))
	
	i (flagzf=1)  d
	.s dxstr="负"_dxstr
	.s fudxstr=$p(dxstr," ",1)
	.s dxstrsum=$p(dxstr," ",2)
	.s dxstr=fudxstr_dxstrsum
	e  s dxstr=dxstr
	
	q dxstr
}

ClassMethod ok(prtid, rcptno, endflag, userid, useflag)
{
    s retcode=0
    s rcptid=""
    s startno=""
    i endflag="1"  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno 
          where Rcpt_useflag='1' and Rcpt_lquser=:userid)
    .s retcode=retcode+SQLCODE
    e  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno,
          Rcpt_useflag='2'
          where Rcpt_useflag='1' and Rcpt_lquser=:userid)
    .s retcode=retcode+SQLCODE
	.w !,"c"_"^"_retcode
	.w !,rcptid
	.&sql(select nvl(rcpt_rowid,""),Rcpt_startno 
	      into :rcptid,:startno
	      from dhc_sfreceipt 
	     where (rcpt_useflag is null or rcpt_useflag="") and Rcpt_lquser=:userid)
	.i rcptid'=""  d
	..&sql(update dhc_sfreceipt set Rcpt_currentno=:startno,
	              Rcpt_useflag='1'
	        where Rcpt_rowid=:rcptid)
	..s retcode=retcode+SQLCODE
	
	q retcode
}

ClassMethod cancel(prtid, rcptno, endflag, userid) As %String
{
   s retcode=0
   s rcptid=""
   &sql(update dhc_sfprintdetail set prt_status='2' where prt_rowid=:prtid)
   s retcode=retcode+SQLCODE
   i endflag="1"  d
   .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno 
          where Rcpt_useflag='1' and Rcpt_lquser=:userid)
   .s retcode=retcode+SQLCODE
   e  d
   .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno,
         Rcpt_useflag='2'
	     where Rcpt_useflag='1' and Rcpt_lquser=:userid)
   .s retcode=retcode+SQLCODE
   .&sql(select nvl(rcpt_rowid,""),Rcpt_startno into :rcptid,:startno from dhc_sfreceipt 
         where (rcpt_useflag is null or rcpt_useflag="") and Rcpt_lquser=:userid)
   .i rcptid'=""  d
   ..&sql(update dhc_sfreceipt set Rcpt_currentno=:startno,
            Rcpt_useflag='1'
	        where Rcpt_rowid=:rcptid)
   ..s retcode=retcode+SQLCODE
   q retcode
}

ClassMethod getrcptstatus(rcptno)
{
	s prtrowid=""
	&sql(select prt_rowid into:prtrowid from dhc_sfprintdetail where prt_refundrcpt=:rcptno and prt_status<>'2')
	q prtrowid
}

ClassMethod getyjdetail(prtrowid)
{
   //打印负的押金记录
    k P1  
	s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	s patinfo=..getpatinfo(admno)
	s patname=$p(patinfo,"^",1)
	s patno=$p(patinfo,"^",8)
	s patdep=$p(patinfo,"^",3)
	s patbed=$p(patinfo,"^",5)
	s payamt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
	s amtdx=..RMBDXXZH(payamt)
	s payamt=0-payamt
	s amtdx="负"_amtdx
	s paymode=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
	i paymode'="" d
	.s paymode=$p(^CT("CTPM",paymode),"^",2)
	s P1=patname_"^"_patno_"^"_patdep_"^"_payamt_"^"_paymode_"^"_amtdx_"^"_patbed
	q P1
}

}
