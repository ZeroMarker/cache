Import SQLUser

Class web.UDHCJFUpdReceipt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 89;

ClassMethod FindDepositExecute(ByRef qHandle As %Binary, stdate, enddate, Guser) As %Status
{
   
	Set repid=$I(^CacheTemp)
    i (stdate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    
    s ind=1
    s jsflag="N"
    i jsflag="N" d  ;收费员日报查询
    .s sum=0
    .f prtdate=stdate:1:enddate d
	..s prtrowid="0"
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  d 
	...s rcptno=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",1),$c(1))
	...s jkflag=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",23),$c(1))
	...s jkflag=$g(jkflag)         
	...s prtstatus=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",8),$c(1))
	...;q:(handin="N")&(jkflag="Y")
	...;q:(handin="Y")&(jkflag="")
	...;q:(stno'="")&(endno'="")&((rcptno<stno)!(rcptno>endno))
	...s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	...q:'$d(^PAADM(admno))
	...i admno'="" s paprowid=$p(^PAADM(admno),"^",1)
	...s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	...s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtuser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14) 
	...s username=$p(^SSU("SSUSR",prtuser),"^",2)
	...q:(prtuser'=Guser )&(Guser'="")       
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...s printdate=$zd(prtdate,3)
	...s printtime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3))
	...i prtstatus="1" s prtstatus="正常"
	...i prtstatus="2" s prtstatus="作废"
	...i prtstatus="3" s prtstatus="冲红"
	...i prtstatus="4" s prtstatus="已冲红"
	...i prtstatus="5" s prtstatus="打印"
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...i prtstatus="已冲红" s prtstatus="正常"
	...i prtstatus'="作废" s sum=sum+payamount
	...s sum=$j(sum,3,2)
	...s select="1"
	...s handdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",21)
	...i handdate'="" s handdate=$zd(handdate,3)
    ...Do OutputRow
    
    .s select="合计",papname="合计",papno="",rcptno="",payamount=sum,paydesc="",prtstatus="",printdate="",printtime="",handdate="",prtrowid=""
    .Do OutputRow
    Set qHandle=$lb(0,repid,0) 	
    Quit $$$OK
OutputRow
	set Data=$lb(select,papname,papno,rcptno,$j(payamount,3,2),paydesc,prtstatus,printdate,printtime,handdate,username,prtrowid)
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

ClassMethod FindDepositClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDepositExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindDeposit(stdate, enddate, Guser) As %Query(ROWSPEC = "Tselect:%String,Tpatname:%String,Tregno:%String,Trcptno:%String,Tpayamt:%String,Tpaymode:%String,Tstatus:%String,Tprtdate:%String,Tprttime:%String,Thanddate:%String,Tuser:%String,Trowid:%String")
{
}

ClassMethod FindInvPrtExecute(ByRef qHandle As %Binary, stdate, enddate, Guser) As %Status
{
	Set repid=$I(^CacheTemp)
    i stdate="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
   ; i ((jkdr="")&(jkflag="Y")) Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    s jsflag="N"
    d ..getacctcate()
    s num=0,bynum=1,yjnum=0
	f i=1:1:11 d
	.s patfee(i)=0
    i jsflag="N" d
	.k P6,P7,P8,P9
	.f aa=stdate:1:enddate d
	..s prtrowid="0" 
	..f  s prtrowid=$o(^DHCINVPRTZY(0,"DATE",aa,prtrowid)) q:prtrowid=""  d
	...s s=^DHCINVPRTZY(prtrowid)
	...s prtuser=$p($p(s,"^",7) ,$c(1))
	...s invno=$p(s,"^",1)
	...s prtdate=$p(s,"^",2)
	...s jkflag=$p($p(s,"^",14),$c(1))
	...s prtstatus=$p($p(s,"^",8),$c(1))  
	...i prtstatus="A" s prtstatus="作废"
	...i prtstatus="S" s prtstatus="冲红"
	...;i prtstatus="冲红" d  ;如果是冲红的数据则发票号取原来的发票号
	....;s initinv=$p($p(s,"^",13) ,$c(1))
	....;i initinv'="" s invno=$p(^DHCINVPRTZY(initinv),"^",1)
	...s deposit=$p(s,"^",22)
	...i (prtstatus="N")!(prtstatus="I") s prtstatus="正常"
	...;q:(handin="N")&(jkflag="Y")
	...;q:(handin="Y")&(jkflag="")
	...;q:((invno<stinv)!(invno>endinv))
	...s username=$p(^SSU("SSUSR",prtuser),"^",2)
	...q:(prtuser'=Guser)&(Guser'="")
	...s admno=$p(s,"^",4)
	...q:'$d(^PAADM(admno))
	...i admno'="" d  s paprowid=$p(^PAADM(admno),"^",1)
	...i admno'="" d  s admreason=$p(^PAADM(admno,1),"^",7)
	...i admreason="" s admreasondesc="自费"
	...e  s admreasondesc=$p(^PAC("ADMREA",admreason),"^",2)
	...;q:pattype'=admreasondesc   ;病人类型
	...s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	...s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	...s billno=$p(s,"^",5) 
	...s prtdate=$zd(prtdate,3)
	...s prttime=$zt($p(s,"^",3))
	...s acount=$p(s,"^",6)
	...s handindate=$p(s,"^",15)
	...s handtime=$p(s,"^",16)
	...i handindate s hdat=$zd(handindate,3) 
	...i handtime s handtime=$zt(handtime,3)
	...s arpbl=+$p(s,"^",5) ;current bill number
	...q:'$d(^DHCPB(arpbl)) 
	...;d ..getacctfee(arpbl,userid)    ;按会计分类费用	
	...i prtstatus'="作废" s patfee(1)=patfee(1)+acount
	...i prtstatus'="作废" s patfee(2)=patfee(2)+deposit
	...i (prtstatus="N") s prtstatus="正常"
	...i (prtstatus="I") s prtstatus="正常"
	...d ..getbillinfo(arpbl,prtstatus)
    ...s ybsum=$j(ybsum,3,2)
	...s select="1"
	...Do OutputRow2
    .s select="",papname="合计",papno="",invno="",acount=patfee(1),deposit=patfee(2),cash=patfee(3),cheque=patfee(4),hp=patfee(5),xyk=patfee(6),payorshare="",discount="",patshare="",prtstatus="",prtdate="",prtrowid="",rcpt="",username="",admreasondesc=""
    .s payorshare=patfee(7),discount=patfee(8),patshare=patfee(9),ybsum=patfee(10)
    .Do OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(select,papname,papno,invno,$j(acount,3,2),$j(deposit,3,2),$j(cash,3,2),$j(cheque,3,2),$j(hp,3,2),$j(xyk,3,2),$j(payorshare,3,2),"",$j(patshare,3,2),prtstatus,prtdate,prttime,prtrowid,rcpt,username,admreasondesc,$j(ybsum,3,2))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindInvPrtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvPrtExecute ]
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

ClassMethod FindInvPrtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvPrtExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindInvPrt(stdate, enddate, Guser) As %Query(ROWSPEC = "Tselect:%String,Tpatname:%String,Tregno:%String,Trcptno:%String,Ttotal:%String,Ttdeposit:%String,Txianjin:%String,Tzhipiao:%String,Thuipiao:%String,Txyk:%String,Tpayorshare:%String,Tdiscount:%String,Tpatshare:%String,Tstatus:%String,Tprtdate:%String,Tprttime:%String,Trowid:%String,Ttrcptno:%String,Tuser:%String,Tpattype:%String,Tyb:%String")
{
}

ClassMethod getacctcate()
{
 k ^tmpacctcate
 K PLIST
 s n=1
 s rowid="0"
 f  s rowid=$o(^DHCTarC("TAC",rowid))  q:rowid=""  d
 .i $g(^tmpacctcate)="" s ^tmpacctcate=0
 .s acctdesc=$p($p(^DHCTarC("TAC",rowid),"^",2),$c(1))
 .s ^tmpacctcate(n)=$p(rowid,$c(1))_"^"_acctdesc
 .s ^tmpacctcate=n
 .s PLIST(n)=acctdesc
 .s n=n+1	     
 q
}

ClassMethod getacctfee(bill, userid)
{
 ;根据账单号取收费项目的会计分类   友谊
	s ordsub=""
	s acctcate=""
	f i=1:1:$g(^tmpacctcate) d
	.s itmfee(i)=0
	f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:ordsub=""  d
	.s oerowid=$p(^DHCPB(+bill,"O",ordsub),"^",4)   ;YYX增加?判断医嘱不存在?则过滤掉
	.q:oerowid=""
	.q:'$d(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2)))
	.s detsub="0"
	.f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:detsub=""  d
	..s taritem=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",3)     ;收费项目
	..s unitprice=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",4)   ;单价
	..s qty=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",5)         ;数量
	..s totalamount=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",7) ;总额
	..i taritem'="" s subcate=$p(^DHCTARI(taritem),"^",5)        ;会计子分类
	..s acctcate=$p(^DHCTarC("AC",subcate),"^",3)                ;会计大类
	..f i=1:1:$g(^tmpacctcate) d
	...i $p(acctcate,$c(1))=$p($p(^tmpacctcate(i),"^",1),$c(1)) d
	....s itmfee(i)=totalamount+itmfee(i)
	s sum=0
	s byPLIST(bynum)=""
	f i=1:1:$g(^tmpacctcate) d
	.s byPLIST(bynum)=byPLIST(bynum)_"^"_itmfee(i)
	.s sum=sum+itmfee(i)
	s byPLIST(bynum)="结算"_"^"_prtrowid_"^"_byPLIST(bynum)_"^"_prtstatus_"^"_sum
	s bynum=bynum+1
 Q
}

ClassMethod getbillinfo(billno, prtstatus)
{
 ;取结算病人相关账单和付费明细      
	s rcpt=""
	s cheque=0,cash=0,xyk=0,patshare=0,hp=0,qt=0,yb=0,ybsum=0
	s discount=+$p(^DHCPB(billno),"^",9)
	s payorshare=+$p(^DHCPB(billno),"^",11) ;公费记账金额
	s patshare=+$p(^DHCPB(billno),"^",12) ;自付金额
	s arrcp=""
	f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	.s arral="" 
	.s rcptnum=$p(^ARRCP(arrcp),"^",2)
	.f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	..s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	..;i type,billnum=billno s deposit=deposit+m1
	..i type,billnum=billno,m1'=0,prtstatus'="作废" d 
	...s yjrowid=$o(^DHCSFPRINTDETAIL(0,"RcptDR",arrcp,""))
	...s yjnum=yjnum+1
	...s rcptnum=$p(^DHCSFPRINTDETAIL(yjrowid),"^",1)
	..i type,billnum=billno,m1'=0,rcpt'="" s rcpt=rcpt_","_rcptnum
	..i type,billnum=billno,m1'=0,rcpt="" s rcpt=rcptnum 
	..i type="" d
	...s paym="0"
	...f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	....s ss=^ARRCP(arrcp,"PAYM",paym)
	....s mode=$p(ss,"^",1)
	....i mode="" s mode="2"
	....s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
	....i paydesc="信用卡" s xyk=xyk+m2
	....e  i paydesc="支票" s cheque=cheque+m2 
	....e  i paydesc="现金" s cash=cash+m2   ;mode=3(支付方式为支票),否则为现金方式
	....e  i paydesc="汇票" s hp=hp+m2    ;其他
	....e  i paydesc["医保" s yb=yb+m2    ;by wuqk 
	...i (prtstatus'="作废") s patfee(3)=patfee(3)+cash
	...i (prtstatus'="作废") s patfee(4)=patfee(4)+cheque
	...i (prtstatus'="作废") s patfee(5)=patfee(5)+hp
	...i (prtstatus'="作废") s patfee(6)=patfee(6)+xyk
	...i (prtstatus'="作废") s patfee(7)=patfee(7)+payorshare
	...i (prtstatus'="作废") s patfee(8)=patfee(8)+discount
	...i (prtstatus'="作废") s patfee(9)=patfee(9)+patshare
	...i (prtstatus'="作废") s patfee(10)=patfee(10)+yb
	...i (prtstatus'="作废") s ybsum=ybsum+yb     ;by wuqk 

	...;$j(hp,3,2),$j(xyk,3,2),$j(payorshare,3,2),"0.00",$j(patshare
	...;e  i paydesc="统筹" s payorshare=payorshare+m2,tcsum=tcsum+m2
	...;e  i paydesc="大额" s patshare=yb+m2,desum=desum+m2
	q
}

ClassMethod getdeposit(stdate, enddate, handin, stno, endno, userid) As %String
{
	k P9,^TMP("ZYJF",$j)
	s num=0
	s stdate=$zdh(stdate,3)
	s enddate=$zdh(enddate,3)
	f prtdate=stdate:1:enddate d
	.s prtrowid="0"
	.f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  d 
	..s rcptno=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",1),$c(1))
	..s jkflag=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",23),$c(1))
	..s jkflag=$g(jkflag)         
	..s prtstatus=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",8),$c(1))
	..q:(handin="N")&(jkflag="Y")
	..q:(handin="Y")&(jkflag="")
	..q:(stno'="")&(endno'="")&((rcptno<stno)!(rcptno>endno))
	..s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	..q:'$d(^PAADM(admno))
	..i admno'="" s paprowid=$p(^PAADM(admno),"^",1)
	..s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	..s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	..s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	..s paydesc=$p(^CT("CTPM",paymode),"^",2)
	..s prtuser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14) 
	..s username=$p(^SSU("SSUSR",prtuser),"^",2)
	..q:(prtuser'=userid )&(userid'="")       
	..s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	..s prtstatus=$p(prtstatus,$c(1))
	..s printdate=$zd(prtdate,3)
	..s printtime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3))
	..i prtstatus="1" s prtstatus="正常"
	..i prtstatus="2" s prtstatus="作废"
	..i prtstatus="3" s prtstatus="冲红"
	..i prtstatus="4" s prtstatus="已冲红"
	..i prtstatus="5" s prtstatus="打印"
	..s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	..i prtstatus="已冲红" s prtstatus="正常"
	..s tmpstr="结算"_"^"_papname_"^"_papno_"^"_rcptno_"^"_$j(payamount,3,2)_"^"_paydesc_"^"_prtstatus_"^"_printdate_"^"_printtime_"^"_""_"^"_username_"^"_prtrowid
	..s num=num+1
	..s ^TMP("ZYJF",$j,num)=tmpstr
	s P9=num        
	q num_"^"_$j
}

ClassMethod InsertUserJk(itmjs As %Library.String = "", itmjsex As %Library.String = "", str, yjrowid, fprowid)
{
	s jkdate=+$h
	s jktime=$p($h,",",2)
	s stdate=$p(str,"^",1)
	s enddate=$p(str,"^",2)
	s user=$p(str,"^",3)
    S stdate=$zdh(stdate,4)
    s enddate=$zdh(enddate,4)
    s err=0
	d ..tb()
	&sql(insert into dhc_jfuserjk(jk_date,jk_time,jk_stdate,jk_enddate,jk_user)
	values (:jkdate,:jktime,:stdate,:enddate,:user))
	
	i SQLCODE'=0 Trollback
	s jkrowid=$g(%ROWID)
	i yjrowid'="" d
	.s err=..yjupdate(jkdate,jktime,yjrowid,jkrowid)
	.i err'=0 Trollback
	i fprowid'="" d
	.s err=..fpupdate(jkdate,jktime,fprowid,jkrowid)
	.i err'=0 Trollback
	d ..tc()
	q err
}

ClassMethod yjupdate(jkdate, jktime, yjrowid, jkdr)
{
   s num=$l(yjrowid,"^")
   s return=0
   f i=1:1:num d
	.s rowid=$p(yjrowid,"^",i)
	.&sql(update dhc_sfprintdetail set prt_jkflag='Y',prt_jkdate=:jkdate,prt_jktime=:jktime,prt_jk_dr=:jkdr
	     where prt_rowid=:rowid)
	.s return=return+SQLCODE
	q return
}

ClassMethod fpupdate(jkdate, jktime, fprowid, jkdr)
{
     ;更新发票表
	 s num=$l(fprowid,"^")
     s return=0
     f i=1:1:num d
	  .s rowid=$p(fprowid,"^",i)
	  .&sql(update dhc_invprtzy set prt_handin='Y',prt_handdate=:jkdate,prt_handtime=:jktime,prt_jk_dr=:jkdr
	       where prt_rowid=:rowid)
	  .s return=return+SQLCODE
	  q return
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
 n SQLCODE
 i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
 q
}

ClassMethod getstdate(guser)
{
	s rowid=$o(^DHCJFUSERJK(guser,""),-1)
	s enddate=+$h
	i rowid'="" s enddate=$p(^DHCJFUSERJK(rowid),"^",4)
	i enddate<+$h s enddate=enddate+1
	s enddate=$zd(enddate,4)
	q enddate
}

ClassMethod Updatercpt(prtrowid, newrcptno) As %String
{
	&sql(update dhc_sfprintdetail set prt_rcptno=:newrcptno where prt_rowid=:prtrowid)
	q SQLCODE
}

ClassMethod Updateinv(prtrowid, newrcptno) As %String
{
	&sql(update dhc_invprtzy set prt_inv=:newrcptno where prt_rowid=:prtrowid)
	q SQLCODE
}

}
