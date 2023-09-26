Import SQLUser

Class web.UDHCJFDayRpt Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindDeposit(stdate, enddate, handin, Guser, jsflag, jkdr, flag) As websys.Query(ROWSPEC = "Tselect:%String,Tpatname:%String,Tregno:%String,Trcptno:%String,Tpayamt:%String,Tpaymode:%String,Tstatus:%String,Tprtdate:%String,Tprttime:%String,Thanddate:%String,Tuser:%String,Trowid:%String,Tjkuserno:%String,Tadmloc:%String,Tchequeno:%String,Tjob:%String,Tconfirmdate:%String,Tno:%String,Tzyno:%String")
{
}

ClassMethod FindDepositExecute(ByRef qHandle As %Binary, stdate, enddate, handin, Guser, jsflag, jkdr, flag) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	i (stdate="")&(jkdr="")  	Quit $$$OK
    i (Guser'="")&&($d(^TMP("DeptRpt",Guser))) k ^TMP("DeptRpt",Guser)
    ;flag=1表示收费员个人日报表
    ;flag=""表示收费员日报汇总
    ;flag=3表示财务科日报汇总
    i jsflag="N" d  ;收费员日报查询
    .s sum=0
    .f prtdate=stdate:1:enddate d
	..s prtrowid="0"
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  d 
	...s rcptno=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",1),$c(1))
	...s jkflag=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",23),$c(1))
	...s prtuser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14) 
	...s jkflag=$g(jkflag)         
	...s confirmflag=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",27),$c(1))  ;yyx
	...i $p(confirmflag,$c(1))="" s confirmflag="N"
	...;i +confirmflag=0 s confirmflag="N"
	...s prtstatus=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",8),$c(1))
	...q:((handin="N")&(jkflag="Y")&(flag="1"))
	...q:((handin="Y")&(jkflag="")&(flag="1"))
	...q:(prtuser'=Guser )&(flag="1")    
	...q:((handin="N")&(confirmflag="Y")&(flag="3"))
	...q:((handin="Y")&(confirmflag="")&(flag="3"))
	...q:((handin="Y")&(confirmflag="N")&(flag="3"))
 	...;q:(stno'="")&(endno'="")&((rcptno<stno)!(rcptno>endno))
	...s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	...q:'$d(^PAADM(admno))
	...i admno'="" s paprowid=$p(^PAADM(admno),"^",1)
	...s admloc=$p(^PAADM(admno),"^",4)
	...i admloc'="" s admloc=$p(^CTLOC(admloc),"^",2)
	...s admloc=$p(admloc,"-",2)
	...s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	...s zyno=$p(^PAPER(paprowid,"PAT",1),"^",22)
	...s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s username=$p(^SSU("SSUSR",prtuser),"^",2)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...s printdate=$zd(prtdate,3)
	...s prttime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",3)
	...s printtime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3))
	...i prtstatus="1" s prtstatus="正常"
	...i prtstatus="2" s prtstatus="作废"
	...i prtstatus="3" s prtstatus="冲红"
	...i prtstatus="4" s prtstatus="已冲红"
	...i prtstatus="5" s prtstatus="打印"
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...i prtstatus="已冲红" s prtstatus="正常"
	...i prtstatus="冲红" d
	....i rcptno="" d
	.....s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",7) 
	...s sum=$j(sum,3,2)
	...s select="1"
	...s handdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",21)
	...i handdate'="" s handdate=$zd(handdate,3)
	...s confirmdate=""
	...s confirmdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",25)
	...i confirmdate'="" s confirmdate=$zd(confirmdate,3)
	...s jkuserno=""
	...s jkuserno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",30)
    ...s chequeno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11)
	...s job=$j
    ...Do OutputRow
    .s select="合计",zyno="",papname="合计",papno="",rcptno="",payamount=sum,paydesc="",prtstatus="",printdate="",printtime="",handdate="",prtrowid="",jkuserno="",admloc="",chequeno="",job=$j,confirmdate=""
    .Do OutputRow
    i jsflag="Y" d 
    .f a=1:1:$length(jkdr,"^") d 
    ..s jkdr1=$p(jkdr,"^",a)
    ..s sum=0
    ..s prtrowid="0"
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr1,prtrowid)) q:prtrowid=""  d 
	...s rcptno=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",1),$c(1))
	...s jkflag=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",23),$c(1))
	...s jkflag=$g(jkflag)         
	...s prtstatus=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",8),$c(1))
	...s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	...q:'$d(^PAADM(admno))
	...i admno'="" s paprowid=$p(^PAADM(admno),"^",1)
	...s admloc=$p(^PAADM(admno),"^",4)
	...i admloc'="" s admloc=$p(^CTLOC(admloc),"^",2)
	...s admloc=$p(admloc,"-",2)
	...s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	...s zyno=$p(^PAPER(paprowid,"PAT",1),"^",22)
	...s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtuser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14) 
	...s username=$p(^SSU("SSUSR",prtuser),"^",2)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...s printdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",2)
	...s printdate=$zd(printdate,3)
	...s prttime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",3)
	...s printtime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3))
	...i prtstatus="1" s prtstatus="正常"
	...i prtstatus="2" s prtstatus="作废"
	...i prtstatus="3" s prtstatus="冲红"
	...i prtstatus="4" s prtstatus="已冲红"
	...i prtstatus="5" s prtstatus="打印"
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...i prtstatus'="作废" s sum=sum+payamount
	...i prtstatus="冲红" d
	....i rcptno="" d
	.....s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",7) 
	...;s sum=$j(sum,3,2)
	...s jkuserno=""
	...s jkuserno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",30)
	...s chequeno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11)
	...s confirmdate=""
	...s confirmdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",25)
	...i confirmdate'="" s confirmdate=$zd(confirmdate,3)
	...s handdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",21)
	...i handdate'="" s handdate=$zd(handdate,3)
	...;s handtime=""
	...;s handtime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",22)
	...;i handtime'="" s handtime=$zt(handtime,1)
	...s handdate=handdate
	...s select="1"
	...s job=$j
	...d OutputRow
	.s select="合计",zyno="",papname="合计",papno="",rcptno="",payamount=sum,paydesc="",prtstatus="",printdate="",printtime="",handdate="",prtrowid="",jkuserno="",admloc="",chequeno="",job=$j
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	i paydesc'=""  set ^TMP("DeptRpt",Guser,ind)=papname_"^"_papno_"^"_rcptno_"^"_$j(payamount,3,2)_"^"_paydesc_"^"_prtstatus_"^"_printdate_"^"_printtime_"^"_handdate_"^"_username_"^"_prtrowid_"^"_jkuserno_"^"_admloc_"^"_chequeno_"^"_job_"^"_confirmdate_"^"_ind_"^"_zyno
	set Data=$lb(select,papname,papno,rcptno,$j(payamount,3,2),paydesc,prtstatus,printdate,printtime,handdate,username,prtrowid,jkuserno,admloc,chequeno,job,confirmdate,ind,zyno)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query FindInvPrt(stdate, enddate, handin, Guser, jsflag, jkdr, flag) As websys.Query(ROWSPEC = "Tselect:%String,Tpatname:%String,Tregno:%String,Trcptno:%String,Ttotal:%String,Ttdeposit:%String,Txianjin:%String,Tzhipiao:%String,Thuipiao:%String,Txyk:%String,Tpayorshare:%String,Tdiscount:%String,Tpatshare:%String,Tstatus:%String,Tprtdate:%String,Tprttime:%String,Trowid:%String,Ttrcptno:%String,Tuser:%String,Tpattype:%String,Tyb:%String,Tgfjz:%String,Tsldjz:%String,Tjkuserno:%String,Tnbsb:%String,Tnbnb:%String,Tjob:%String,Tjstzply:%String,Tjsthply:%String,Tjstxykly:%String,Tno:%String,Tzyno:%String,Tqf:%String,Tjy:%String,Tqt:%String")
{
}

ClassMethod FindInvPrtExecute(ByRef qHandle As %Binary, stdate, enddate, handin, Guser, jsflag, jkdr, flag) As %Status
{
	s yjstr=""
   	k ^TMP("ZYJF","FLFEE",$j)      ;打印出院分类费用
   	k ^TMP("ZYJF","CYTDEPOSIT",$j) ;出院收回预交金明细
   	k ^TMP("ZYJF","CYJSCH",$j)  ;记录冲红的多退少补的金额
   	k ^TMP("ZYJF","CYJSPAYMODE",$j)
   	s job=$j
   	S flfee=""
   	k ^mPLIST
	Set repid=$I(^CacheTemp)
    i (stdate="")&(jkdr="")  Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1,chnum=0
    d ..getacctcate()
    s catenum=..getIPcate()
	d ##class(web.UDHCJFDayRptJST).getpaymode()
    f i=1:1:$g(^tmpincate($j)) d
	.s itmipfee($p(^tmpincate($j,i),"^",1))=0
	;取住院发票分类金额
    s num=0,bynum=1,yjnum=0
    s nbsbtot=0,nbnbtot=0
    f i=1:1:18 d
	.s patfee(i)=0
    i jsflag="N" d
	.k P6,P7,P8,P9
	.f aa=stdate:1:enddate d
	..s prtrowid="0" 
	..f  s prtrowid=$o(^DHCINVPRTZY(0,"DATE",aa,prtrowid)) q:prtrowid=""  d
	...s s=^DHCINVPRTZY(prtrowid)
	...s confirmflag=$p($p(s,"^",10),$c(1))  ;yyx
	...s prtuser=$p($p(s,"^",7) ,$c(1))
	...s invno=$p(s,"^",1)
	...s oldrowid=$p(s,"^",13)
	...s prtdate=$p(s,"^",2)
	...s jkflag=$p($p(s,"^",14),$c(1))
	...s prtstatus=$p($p(s,"^",8),$c(1))  
	...i prtstatus="A"  d
	....s prtstatus="作废"
	...i prtstatus="S"  d
	....s prtstatus="冲红"
	...i (prtstatus="N")!(prtstatus="I")  d
	....s prtstatus="正常"
	...s deposit=$p(s,"^",22)
	...q:((handin="N")&(jkflag="Y")&(Guser'="")&(flag="1"))
	...q:((handin="Y")&(jkflag="")&(Guser'="")&(flag="1"))
	...q:(prtuser'=Guser)&(flag="1")       
	...q:((handin="N")&(confirmflag="Y")&(flag="3"))
	...q:((handin="Y")&(confirmflag="N")&(flag="3"))
	...q:((handin="Y")&(confirmflag="")&(flag="3"))
	...s username=$p(^SSU("SSUSR",prtuser),"^",2)
	...s admno=$p(s,"^",4)
	...q:'$d(^PAADM(admno))
	...i admno'="" d  s paprowid=$p(^PAADM(admno),"^",1)
	...i admno'="" d  s admreason=$p(^PAADM(admno,1),"^",7)
	...i admreason="" s admreasondesc="自费病人"
	...e  s admreasondesc=$p(^PAC("ADMREA",admreason),"^",2)
	...i admreasondesc="自费"  s admreasondesc="自费病人"
	...s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	...s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	...s zyno=$p(^PAPER(paprowid,"PAT",1),"^",22)
	...s dep=$p(^PAADM(admno),"^",4)
    ...s depart=$p(^CTLOC(dep),"^",2)
    ...s ward1=$p(^PAADM(admno),"^",70)
    ...s ward=""
    ...i ward1'="" s ward=$p(^PAWARD(ward1),"^",2)
    ...s depart=$p(depart,"-",2)
    ...s ward=$p(ward,"-",2)
	...s billno=$p(s,"^",5) 
	...s prtdate=$zd(prtdate,3)
	...s printtime=$p(s,"^",3)  ;yyx
	...s prttime=$zt($p(s,"^",3))
	...s acount=$p(s,"^",6)
	...s oldpay=0-acount
	...s handindate=$p(s,"^",15)
	...s handtime=$p(s,"^",16)
	...s jkuserno=$p(s,"^",23)
	...s chinitial=$p(s,"^",13)
	...i prtstatus="冲红" d
	....d ##class(web.UDHCJFDayRptJST).gethcdetail(prtrowid)
	....i invno="" d
	.....s invno=$p(^DHCINVPRTZY(oldrowid),"^",1)
	...i (chinitial'="")&(prtstatus="冲红") d
	....d ..getchinfo(admno,prtrowid)
	...i handindate s hdat=$zd(handindate,3) 
	...i handtime s handtime=$zt(handtime,3)
	...s arpbl=+$p(s,"^",5) ;current bill number
	...q:'$d(^DHCPB(arpbl)) 
	...;d ..getacctfee(arpbl,userid)    ;按会计分类费用	
	...i ((prtstatus'="作废")&(Guser'="")) d ##class(web.UDHCJFDayRptJST).getonebillfee(arpbl) ;按住院费用大类
	...i prtstatus'="作废"  d
	....s patfee(1)=patfee(1)+acount
	....s patfee(2)=patfee(2)+deposit
	....;&js<alert(#(arpbl)#+"^"+#(prtstatus)#)>
	....d ##class(web.UDHCJFDayRptJST).settdeposit(arpbl,prtstatus)
	...d ..getbillinfo(arpbl,prtstatus,admreasondesc)
    ...;i gfjz'=0 s prtstatus="欠费"
    ...s ybsum=$j(ybsum,3,2)
	...s nbsbsum=$j(nbsbsum,3,2)
    ...s nbnbsum=$j(nbnbsum,3,2)
	...s select="1"	
	...s ybsum=yb
	...Do OutputRow2
    .s select="",papname="合计",papno="",invno="",acount=patfee(1),deposit=patfee(2),cash=patfee(3),cheque=patfee(4),hp=patfee(5),xyk=patfee(6),payorshare="",discount="",patshare="",prtstatus="",prtdate="",prtrowid="",rcpt="",username="",admreasondesc="",jkuserno="",prttime="",zyno=""
    .s payorshare=patfee(7),discount=patfee(8),patshare=patfee(9),ybsum=patfee(10),gfjz=patfee(11),sldjz=patfee(12),nbsbsum=$j(nbsbtot,3,2),nbnbsum=$j(nbnbtot,3,2),zply=$j(patfee(13),3,2),hply=$j(patfee(14),3,2),xykly=$j(patfee(15),3,2),qf=patfee(16),jy=patfee(17),qt=patfee(18)
    .Do OutputRow2
    
    i jsflag="Y" d
    .f num=1:1:$length(jkdr,"^") d 
    ..s jkdr1=$p(jkdr,"^",num)
    ..s prtrowid="0" 
	..f  s prtrowid=$o(^DHCINVPRTZY(0,"JK",jkdr1,prtrowid)) q:prtrowid=""  d
	...s s=^DHCINVPRTZY(prtrowid)
	...s prtuser=$p($p(s,"^",7) ,$c(1))
	...s invno=$p(s,"^",1)
	...s prtdate=$p(s,"^",2)
	...s jkflag=$p(s,"^",14)
	...s prtstatus=$p(s,"^",8)  
	...i prtstatus="A" s prtstatus="作废"
	...i prtstatus="S" s prtstatus="冲红"
	...i (prtstatus="N")!(prtstatus="I")  d
	....s prtstatus="正常"
	...s oldrowid=$p(s,"^",13)
	...s deposit=$p(s,"^",22)
	...s username=$p(^SSU("SSUSR",prtuser),"^",2)
	...s admno=$p(s,"^",4)
	...q:'$d(^PAADM(admno))
	...i admno'="" d  s paprowid=$p(^PAADM(admno),"^",1)
	...i admno'="" d  s admreason=$p(^PAADM(admno,1),"^",7)
    ...i admreason="" s admreasondesc="自费病人"
	...e  s admreasondesc=$p(^PAC("ADMREA",admreason),"^",2)
	...;q:pattype'=admreasondesc   ;病人类型
	...i admreasondesc="自费"  s admreasondesc="自费病人"
	...s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	...s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	...s zyno=$p(^PAPER(paprowid,"PAT",1),"^",22)
	...s dep=$p(^PAADM(admno),"^",4)
    ...s depart=$p(^CTLOC(dep),"^",2)
    ...s ward1=$p(^PAADM(admno),"^",70)
    ...s ward=""
    ...i ward1'="" s ward=$p(^PAWARD(ward1),"^",2)
    ...s depart=$p(depart,"-",2)
    ...s ward=$p(ward,"-",2)
	...s billno=$p(s,"^",5) 
	...s prtdate=$p(s,"^",2)
	...s prtdate=$zd(prtdate,3) 
	...s prttime=$zt($p(s,"^",3))
	...s acount=$p(s,"^",6)
	...s handindate=$p(s,"^",15)
	...s handtime=$p(s,"^",16)
	...s jkuserno=""
	...s jkuserno=$p(s,"^",23)
	...s chinitial=$p(s,"^",13)
	...s oldpay=0-acount
	...i prtstatus="冲红" d
	....d ##class(web.UDHCJFDayRptJST).gethcdetail(prtrowid)
	....i invno="" d
	.....s invno=$p(^DHCINVPRTZY(oldrowid),"^",1)
	...i (chinitial'="")&(prtstatus="冲红") d
	....d ..getchinfo(admno,prtrowid)
	...i handindate s hdat=$zd(handindate,3) 
	...i handtime s handtime=$zt(handtime,3)
	...s arpbl=+$p(s,"^",5) ;current bill number
	...;d ..getacctfee(arpbl,userid)    ;按会计分类费用
	...i ((prtstatus'="作废")&(Guser'="")) d ##class(web.UDHCJFDayRptJST).getonebillfee(arpbl) ;按住院费用大类
	...i prtstatus'="作废" d
	....s patfee(1)=patfee(1)+acount,patfee(2)=patfee(2)+deposit
	....d ##class(web.UDHCJFDayRptJST).settdeposit(arpbl,prtstatus)
	...;i ((prtstatus="N")!(prtstatus="I")) s prtstatus="正常"
	...d ..getbillinfo(arpbl,prtstatus,admreasondesc)
	...s ybsum=$j(ybsum,3,2) 
    ...s nbsbsum=$j(nbsbsum,3,2)
    ...s nbnbsum=$j(nbnbsum,3,2)
    ...s select="1"   
	...Do OutputRow2
	.s select="",papname="合计",papno="",invno="",acount=patfee(1),deposit=patfee(2),cash=patfee(3),cheque=patfee(4),hp=patfee(5),xyk=patfee(6),payorshare="",discount="",patshare="",prtstatus="",prtdate="",prtrowid="",rcpt="",username="",admreasondesc="",jkuserno="",zyno=""
    .s payorshare=patfee(7),discount=patfee(8),patshare=patfee(9),ybsum=patfee(10),gfjz=patfee(11),sldjz=patfee(12),nbsbsum=$j(nbsbtot,3,2),nbnbsum=$j(nbnbtot,3,2),zply=$j(patfee(13),3,2),hply=$j(patfee(14),3,2),xykly=$j(patfee(15),3,2),qf=patfee(16),jy=patfee(17),qt=patfee(18)
    .Do OutputRow2
    f i=1:1:$g(^tmpincate($j)) d
	.s flfee=flfee_"!"_$p(^tmpincate($j,i),"^",2)_"^"_$j(itmipfee($p(^tmpincate($j,i),"^",1)),3,2)
   	s ^TMP("ZYJF","DEPOSIT",$j)=yjstr
    s ^TMP("ZYJF","FLFEE",$j)=flfee
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(select,papname,papno,invno,$j(acount,3,2),$j(deposit,3,2),$j(cash,3,2),$j(cheque,3,2),$j(hp,3,2),$j(xyk,3,2),$j(payorshare,3,2),"",$j(patshare,3,2),prtstatus,prtdate,prttime,prtrowid,rcpt,username,admreasondesc,$j(ybsum,3,2),$j(gfjz,3,2),$j(sldjz,3,2),jkuserno,nbsbsum,nbnbsum,job,$j(zply,3,2),$j(hply,3,2),$j(xykly,3,2),ind,zyno,$j(qf,3,2),$j(jy,3,2),$j(qt,3,2))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
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

ClassMethod getbillinfo(billno, prtstatus, admreasondesc)
{
    ;取结算病人相关账单和付费明细      
	s rcpt=""
	s cheque=0,cash=0,xyk=0,patshare=0,hp=0,qt=0,yb=0,ybsum=0,zply=0,hply=0,xykly=0
	s nbsbsum=0,nbnbsum=0,qf=0,jy=0,qt=0
	s gfjz=0,sldjz=0
	s discount=+$p(^DHCPB(billno),"^",9)
	s payorshare=+$p(^DHCPB(billno),"^",11) ;公费记账金额
	s patshare=+$p(^DHCPB(billno),"^",12) ;自付金额
	s arrcp="",ybstr=""
	f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	.s arral="" 
	.s arrcptnumber=$p(^ARRCP(arrcp),"^",2)  ;yyx
	.f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	..s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	..i type,billnum=billno,m1'=0,prtstatus'="作废" d 
	...q:'$d(^DHCSFPRINTDETAIL(0,"RcptDR",arrcp))
	...s yjrowid=$o(^DHCSFPRINTDETAIL(0,"RcptDR",arrcp,""))
	...s yjnum=yjnum+1
	...s rcptnum=$p(^DHCSFPRINTDETAIL(yjrowid),"^",1)
	...;s yjstr=yjstr_"^"_yjrowid
	...i rcpt'="" s rcpt=rcpt_","_rcptnum
	...i rcpt="" s rcpt=rcptnum
	..i type="" d
	...s paym="0"
	...f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	....s ss=^ARRCP(arrcp,"PAYM",paym)
	....s mode=$p(ss,"^",1)
	....i mode="" s mode="19"
	....s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
	....i prtstatus'="作废"  d
	.....i (m2>0)&(chinitial="") s ^TMP("ZYJF","CYJSPAYMODE",$j,"收",paydesc)=^TMP("ZYJF","CYJSPAYMODE",$j,"收",paydesc)+m2
	.....i (m2<0)&(chinitial="") s ^TMP("ZYJF","CYJSPAYMODE",$j,"退",paydesc)=^TMP("ZYJF","CYJSPAYMODE",$j,"退",paydesc)+m2
	.....i paydesc="银行卡" s xyk=xyk+m2
	.....e  i paydesc="银行卡留用" s xykly=xykly+m2
	.....e  i paydesc="支票" s cheque=cheque+m2
	.....e  i paydesc="支票留用" s zply=zply+m2
	.....e  i paydesc="倒存支票" s cheque=cheque+m2
	.....e  i paydesc="现金" s cash=cash+m2   ;mode=3(支付方式为支票),否则为现金方式
	.....e  i paydesc="汇票" s hp=hp+m2    ;其他
	.....e  i paydesc="汇票留用" s hply=hply+m2
	.....;e  i paydesc="医保基金支付" s yb=yb+m2    ;by wuqk
	.....;e  i paydesc="公疗支付" s yb=yb+m2    ;by wuqk
	.....;e  i paydesc="工伤支付" s yb=yb+m2    ;by wuqk
	.....e  i paydesc="公费记帐" s gfjz=gfjz+m2
	.....e  i paydesc="市领导记帐" s sldjz=sldjz+m2
	.....;insert by cx
	.....e  i (paydesc["医保")&(paydesc'="医保卡划款")  s yb=yb+m2
	.....e  i paydesc="欠费"  s qf=qf+m2
	.....e  i paydesc="结存"  s jy=jy+m2
	.....e  s qt=qt+m2	 
	...i (prtstatus'="作废")  d
	....s patfee(3)=patfee(3)+cash
	....s patfee(4)=patfee(4)+cheque
	....s patfee(5)=patfee(5)+hp
	....s patfee(6)=patfee(6)+xyk
	....s patfee(7)=patfee(7)+payorshare
	....s patfee(8)=patfee(8)+discount
	....s patfee(10)=patfee(10)+yb
	....s patfee(11)=patfee(11)+gfjz
    ....s patfee(12)=patfee(12)+sldjz 	
    ....s patfee(13)=patfee(13)+zply
    ....s patfee(14)=patfee(14)+hply
    ....s patfee(15)=patfee(15)+xykly
    ....s patfee(16)=patfee(16)+qf
    ....s patfee(17)=patfee(17)+jy
    ....s patfee(18)=patfee(18)+qt
	...i ((prtstatus'="作废")&(admreasondesc'="医保"))  d
	....s patfee(9)=patfee(9)+patshare
	
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

/// Lid
/// 2009-05-19
/// 获取押金和发票号段信息.
ClassMethod GetDepNOAndInvNOInfobak(Guser, job)
{
	;w ##class(web.UDHCJFDayRpt).GetDepNOAndInvNOInfo("5","4260")
	
	s rtn=""
	s (DepNOInfo,DepNum,StrikeDepNOInfo,StrikeDepNum,AbortDepNOInfo,AbortDepNum)="" 
	s (InvNOInfo,InvNum,StrikeInvNOInfo,StrikeInvNum,AbortInvNOInfo,AbortInvNum)=""
	
	s DepNOInfo=##class(UDHCJFBaseCommon).GetDEPNOinfo(Guser,"DepositNo",job)
	i $D(^TMP("ZYJF","DepositNo",Guser,job)) d
	.s DepNum=$o(^TMP("ZYJF","DepositNo",Guser,job,""),-1)
	;s stNO=+$TR($p(DepNOInfo,"--",1)," "),endNO=+$TR($p(DepNOInfo,"--",2)," ")
	;s DepNum=endNO-stNO+1
	
	i $d(^TMP("ZYJF","StrikeDepNo",Guser,job)) d
	.s StrikeDepNOInfo=^TMP("ZYJF","StrikeDepNo",Guser,job)
	.s StrikeDepNum=$L(StrikeDepNOInfo,",")
	
	i $d(^TMP("ZYJF","AbortDepNo",Guser,job)) d
	.s AbortDepNOInfo=^TMP("ZYJF","AbortDepNo",Guser,job)
	.s AbortDepNum=$L(AbortDepNOInfo,",")
	
	
	s InvNOInfo=##class(UDHCJFBaseCommon).GetINVNOinfo(Guser,"InvNo",job)
	i $D(^TMP("ZYJF","InvNo",Guser,job)) d
	.s InvNum=$o(^TMP("ZYJF","InvNo",Guser,job,""),-1)
	;s stNO=+$TR($p(InvNOInfo,"--",1)," "),endNO=+$TR($p(InvNOInfo,"--",2)," ")
	;s InvNum=endNO-stNO+1
	
	i $d(^TMP("ZYJF","StrikeInvNo",Guser,job)) d
	.s StrikeInvNOInfo=^TMP("ZYJF","StrikeInvNo",Guser,job)
	.s StrikeInvNum=$L(StrikeInvNOInfo,",")
	
	i $d(^TMP("ZYJF","AbortInvNo",Guser,job)) d
	.s AbortInvNOInfo=^TMP("ZYJF","AbortInvNo",Guser,job)
	.s AbortInvNum=$L(AbortInvNOInfo,",")
	
	s rtn=DepNOInfo_"^"_DepNum_"^"_StrikeDepNOInfo_"^"_StrikeDepNum_"^"_AbortDepNOInfo_"^"_AbortDepNum
	s rtn=rtn_"^"_InvNOInfo_"^"_InvNum_"^"_StrikeInvNOInfo_"^"_StrikeInvNum_"^"_AbortInvNOInfo_"^"_AbortInvNum
	q rtn
}

/// Lid
/// 2009-05-19
/// 获取押金和发票号段信息.
/// w ##class(web.UDHCJFDayRpt).GetDepNOAndInvNOInfo("1","164")
ClassMethod GetDepNOAndInvNOInfo(Guser, job)
{
	n (Guser, job)
	s rtn=""
	s (DepNOInfo,DepNum,StrikeDepNOInfo,StrikeDepNum,AbortDepNOInfo,AbortDepNum)="" 
	s (InvNOInfo,InvNum,StrikeInvNOInfo,StrikeInvNum,AbortInvNOInfo,AbortInvNum)=""
	
	s DepNOInfo=##class(UDHCJFBaseCommon).GetINVNOinfo(Guser,"DepositNo",job)
	s DepNOInfo=$TR(DepNOInfo," ")
	s Count=$L(DepNOInfo,",")
	f i=1:1:Count d
	.s stNO=$p($p(DepNOInfo,",",i),"--",1),endNO=$p($p(DepNOInfo,",",i),"--",2)
	.i endNO'="" s DepNum=$g(DepNum)+endNO-stNO+1
	i $d(^TMP("ZYJF","StrikeDepNo",Guser,job)) d
	.s StrikeDepNOInfo=^TMP("ZYJF","StrikeDepNo",Guser,job)
	.s StrikeDepNum=$L(StrikeDepNOInfo,",")
	
	i $d(^TMP("ZYJF","AbortDepNo",Guser,job)) d
	.s AbortDepNOInfo=^TMP("ZYJF","AbortDepNo",Guser,job)
	.s AbortDepNum=$L(AbortDepNOInfo,",")

	s InvNOInfo=##class(UDHCJFBaseCommon).GetINVNOinfo(Guser,"InvNo",job)
	s InvNOInfo=$TR(InvNOInfo," ")
	s Count=$L(InvNOInfo,",")

	f i=1:1:Count d
	.s stNO=$p($p(InvNOInfo,",",i),"--",1),endNO=$p($p(InvNOInfo,",",i),"--",2)
	.i endNO'=""  s InvNum=$g(InvNum)+$e(endNO,3,$l(endNO))-$e(stNO,3,$l(stNO))+1
	
	i $d(^TMP("ZYJF","StrikeInvNo",Guser,job)) d
	.s StrikeInvNOInfo=^TMP("ZYJF","StrikeInvNo",Guser,job)
	.s StrikeInvNum=$L(StrikeInvNOInfo,",")
	
	i $d(^TMP("ZYJF","AbortInvNo",Guser,job)) d
	.s AbortInvNOInfo=^TMP("ZYJF","AbortInvNo",Guser,job)
	.s AbortInvNum=$L(AbortInvNOInfo,",")

	s rtn=DepNOInfo_"^"_DepNum_"^"_StrikeDepNOInfo_"^"_StrikeDepNum_"^"_AbortDepNOInfo_"^"_AbortDepNum
	s rtn=rtn_"^"_InvNOInfo_"^"_InvNum_"^"_StrikeInvNOInfo_"^"_StrikeInvNum_"^"_AbortInvNOInfo_"^"_AbortInvNum
	q rtn
}

ClassMethod InsertUserJk(itmjs As %Library.String = "", itmjsex As %Library.String = "", str, yjrowid, fprowid)
{
	s ^insert=str_"%"_yjrowid_"%"_fprowid
	s jkdate=+$h
	s jktime=$p($h,",",2)
	s stdate=$p(str,"^",1)
	s enddate=$p(str,"^",2)
	s user=$p(str,"^",3)
	s job=$p(str,"^",4)
	s JKSttime=$p(str,"^",5)
	i JKSttime'="" s JKSttime=##class(websys.Conversions).TimeHtmlToLogical(JKSttime)
	s JKEndTime=$p(str,"^",6)
	i JKEndTime'="" s JKEndTime=##class(websys.Conversions).TimeHtmlToLogical(JKEndTime,1)
	
    S stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
    s enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
    
    ;Lid 2009-05-20 获取押金，发票号段信息
    s rtn=..GetDepNOAndInvNOInfo(user,job)
    s DepNOInfo=$p(rtn,"^",1),DepNum=$p(rtn,"^",2),StrikeDepNOInfo=$p(rtn,"^",3),StrikeDepNum=$p(rtn,"^",4),AbortDepNOInfo=$p(rtn,"^",5),AbortDepNum=$p(rtn,"^",6)
    s InvNOInfo=$p(rtn,"^",7),InvNum=$p(rtn,"^",8),StrikeInvNOInfo=$p(rtn,"^",9),StrikeInvNum=$p(rtn,"^",10),AbortInvNOInfo=$p(rtn,"^",11),AbortInvNum=$p(rtn,"^",12)
    
    s SQLCODE=0
    s err=0
    ;测试结算报表不成功用
    s $ZT="ERROR^DHCSSERR"  d ..tb()	
	k PLIST
	s PLIST(2)=jkdate
	s PLIST(3)=jktime
	s PLIST(4)=stdate
	s PLIST(5)=enddate
	s PLIST(6)=user
	s PLIST(11)="Single"
	s PLIST(12)=JKSttime
	s PLIST(13)=JKEndTime
	;Lid 2009-05-20 向dhc_jfuserjk表中插入号段信息
	s PLIST(14)=DepNOInfo
	s PLIST(15)=StrikeDepNOInfo
	s PLIST(16)=AbortDepNOInfo
	s PLIST(17)=DepNum
	s PLIST(18)=StrikeDepNum
	s PLIST(19)=AbortDepNum
	s PLIST(20)=InvNOInfo
	s PLIST(21)=StrikeInvNOInfo
	s PLIST(22)=AbortInvNOInfo
	s PLIST(23)=InvNum
	s PLIST(24)=StrikeInvNum
	s PLIST(25)=AbortInvNum
	;end
	&sql(insert into dhc_jfuserjk values :PLIST()) 
	
	i SQLCODE'=0 Trollback
	q:(SQLCODE'=0) SQLCODE_"^a"
	s jkrowid=$g(%ROWID)	

	s err=0
	i (yjrowid'="")&(SQLCODE=0) d
	.s err=..yjupdate(jkdate,jktime,yjrowid,jkrowid)
	.i err'=0 Trollback

	q:(err'=0) err_"^b"
	i (fprowid'="")&(SQLCODE=0)&(err=0) d
	.s err=..fpupdate(jkdate,jktime,fprowid,jkrowid)
	.i err'=0 Trollback
	
	q:(err'=0) err_"^c"
	d ..tc()
	q err_"^"_jkrowid
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

ClassMethod getcyjs(job, paymode)
{
    d ..putchinfo(job)
   ;出院结算是的收退
    s samt=0,tamt=0,chsamt=0,chtamt=0
    s samt=^TMP("ZYJF","CYJSPAYMODE",job,"收",paymode)
    s tamt=^TMP("ZYJF","CYJSPAYMODE",job,"退",paymode)
    s chsamt=^TMP("ZYJF","CYJSCHALL",job,"收",paymode)
    s chtamt=^TMP("ZYJF","CYJSCHALL",job,"退",paymode)
    s tamt=0-tamt,chtamt=0-chtamt
    q samt_"^"_tamt_"^"_chsamt_"^"_chtamt
}

ClassMethod getpaymode()
{
	s paymodestr=""
	s rowid="0"
	f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
	.s paymodedesc=$p(^CT("CTPM",rowid),"^",2)
    .i paymodestr'="" s paymodestr=paymodestr_"^"_paymodedesc
    .e  s paymodestr=paymodedesc
    q paymodestr
}

ClassMethod getchinfo(admno, prtrowid)
{
  ;在冲账合计中的数据
   ;k ^TMP("ZYJF","CYJSCH",$j,admno)
   s arpbl=$p(^DHCINVPRTZY(prtrowid),"^",5)
   s arrcp=""
   s prtjkdate=$p(^DHCINVPRTZY(prtrowid),"^",15)
   s prtjktime=$p(^DHCINVPRTZY(prtrowid),"^",16)
   s prtjkflag=$p(^DHCINVPRTZY(prtrowid),"^",14)
   f  s arrcp=$o(^ARRCP("ARPBL",arpbl,arrcp)) q:arrcp=""  d
   .s paym="0"
   .f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
   ..s ss=^ARRCP(arrcp,"PAYM",paym)
   ..s mode=$p(ss,"^",1)
   ..i mode="" s mode="2"
   ..s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
   ..i $d(^TMP("ZYJF","CYJSCH",$j,admno,paydesc)) d
   ...s ^TMP("ZYJF","CYJSCH",$j,admno,paydesc)=^TMP("ZYJF","CYJSCH",$j,admno,paydesc)+m2
   ..e  d
   ...s ^TMP("ZYJF","CYJSCH",$j,admno,paydesc)=0
   ...s ^TMP("ZYJF","CYJSCH",$j,admno,paydesc)=^TMP("ZYJF","CYJSCH",$j,admno,paydesc)+m2
   s prtflag=""
   f  s prtrowid=$o(^DHCINVPRTZY(0,"ADM",admno,prtrowid)) q:(prtrowid="")!(prtflag="N")  d
   .s prtdate=$p(^DHCINVPRTZY(prtrowid),"^",2)
   .s initial=$p(^DHCINVPRTZY(prtrowid),"^",13)
   .s prtflag=$p(^DHCINVPRTZY(prtrowid),"^",8)
   .i prtflag="I" s prtflag="N"
   .s prtjkdate1=$p(^DHCINVPRTZY(prtrowid),"^",15)
   .s prtjktime1=$p(^DHCINVPRTZY(prtrowid),"^",16)
   .s prtjkflag1=$p(^DHCINVPRTZY(prtrowid),"^",14)
   .q:(prtjkflag'=prtjkflag1)
   .q:(prtjkdate'=prtjkdate1)
   .q:(prtjkdate=prtjkdate1)&(prtjktime'=prtjktime1)
   .q:prtflag="A"
   .q:initial=""
   .s arpbl=$p(^DHCINVPRTZY(prtrowid),"^",5)
   .s arrcp=""
   .f  s arrcp=$o(^ARRCP("ARPBL",arpbl,arrcp)) q:arrcp=""  d
   ..s rcptnumber=$p(^ARRCP(arrcp),"^",2)
   ..q:rcptnumber=""
   ..s paym="0"
   ..f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
   ...s ss=^ARRCP(arrcp,"PAYM",paym)
   ...s mode=$p(ss,"^",1)
   ...i mode="" s mode="2"
   ...s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
   ...i $d(^TMP("ZYJF","CYJSCH",$j,admno,paydesc)) d
   ....s ^TMP("ZYJF","CYJSCH",$j,admno,paydesc)=^TMP("ZYJF","CYJSCH",$j,admno,paydesc)+m2
   ...e  d
   ....s ^TMP("ZYJF","CYJSCH",$j,admno,paydesc)=0
   ....s ^TMP("ZYJF","CYJSCH",$j,admno,paydesc)=^TMP("ZYJF","CYJSCH",$j,admno,paydesc)+m2
  q 0
}

ClassMethod putchinfo(job)
{
   ;取冲红的金额,收费员日报表中对应冲账合计
   k ^TMP("ZYJF","CYJSCHALL",job,"收") ;保存冲红补收的金额
   k ^TMP("ZYJF","CYJSCHALL",job,"退") ;保存冲红退的金额
   s rowid="0"
   f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
	.s paymodedesc=$p(^CT("CTPM",rowid),"^",2)
    .s ^TMP("ZYJF","CYJSCHALL",job,"收",paymodedesc)=0
    .s ^TMP("ZYJF","CYJSCHALL",job,"退",paymodedesc)=0
    s adm=""
	f  s adm=$o(^TMP("ZYJF","CYJSCH",job,adm)) q:adm=""  d
	.s paydesc=""
	.f  s paydesc=$o(^TMP("ZYJF","CYJSCH",job,adm,paydesc)) q:paydesc=""  d
	..s amt=^TMP("ZYJF","CYJSCH",job,adm,paydesc)
	..i amt>0 d
	...s ^TMP("ZYJF","CYJSCHALL",job,"收",paydesc)=^TMP("ZYJF","CYJSCHALL",job,"收",paydesc)+amt
	..e  d
	...s ^TMP("ZYJF","CYJSCHALL",job,"退",paydesc)=^TMP("ZYJF","CYJSCHALL",job,"退",paydesc)+amt
   q
}

ClassMethod HandinInfo()
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//Start Lid 2009-03-21 初始化信息
	k ^TMP("ZYJF","DailyHZPayM",job)
	k ^TMP("ZYJF","DeptRpt",Guser,job)
	k ^TMP("ZYJF","DepositNo",Guser,job)
	k ^TMP("ZYJF","BLDepositNo",Guser,job)
	k ^TMP("ZYJF","FLFEE",job)      ;打印出院分类费用
	k ^TMP("ZYJF","FLFEE","Total",job)
	k ^TMP("ZYJF","CYTDEPOSIT",job) ;出院收回预交金明细
	k ^TMP("ZYJF","CYJSCH",job)  ;记录冲红的多退少补的金额
	k ^TMP("ZYJF","CYJSPAYMODE",job)
	k ^TMP("ZYJF","AdmReason",job)
	k ^TMP("ZYJF","FindInvPrt",Guser,job)
	k ^TMP("ZYJF","InvNo",Guser,job)
	k ^TMP("ZYJF","StrikeInvNo",Guser,job)
	k ^TMP("ZYJF","AbortInvNo",Guser,job)
	d ##class(web.UDHCJFDayRptJST).getpaymode() ;初始化支付方式	
	S flfee=""     
	s num=1,yjnum=1,fpnum=1,Depositind=1,BLDepositind=1,invnum=1,oldInvno=""
	s hzsdepamt=0,hztdepamt=0,hzacount=0,hzpatdiscount=0,hzpatpayorshare=0,hzpatsharefee=0


	;s discount=+$p(^DHCPB(billno),"^",9)  ;;折扣金额
	;s payorshare=+$p(^DHCPB(billno),"^",11) ;公费记账金额
	;s patshare=+$p(^DHCPB(billno),"^",12) ;自付金额
				
	d ##class(web.UDHCJFDayRptJST).getpaymode()      ;初始化支付模式

	s flfee=""     
	d ##class(web.UDHCJFDailyHand).InitIPCate("TAC")
	f i=1:1:$g(^tmpipcate($j)) d                    
	.s itmcatefee($p(^tmpipcate($j,i),"^",1))=0

	;取住院发票分类金额
	f i=1:1:16  d
	.s paym(i)=0.00
	s payid="0"
	s j=0
	f  s payid=$o(^CT("CTPM",payid))  q:payid=""  d
	.s paydes=$p($g(^CT("CTPM",payid)),"^",2)
	.q:$tr(paydes," ")=""
	.s paycd=$p($g(^CT("CTPM",payid)),"^",2)
	.s ^TMP("ZYJF","DailyHand",Guser,job,payid)=0 

	f i=1:1:18 d
	.s patfee(i)=0
	//End
	s jkdate=stdate
	f jkdate=jkdate:1:enddate d
	.s jkdr=""
	.f  s jkdr=$o(^DHCJFUSERJK(0,"date",jkdate,jkdr)) q:jkdr=""  d
	..s sdepamt=0,tdepamt=0,acount=0,patdiscount=0,patpayorshare=0,patsharefee=0
	..s userid=$p(^DHCJFUSERJK(jkdr),"^",5)
	..q:(skuserid'="")&(skuserid'=userid)
	..s username="",jsdate=""
	..s jsdate=$zd(jkdate,3)
	..i userid'="" s username=$p(^SSU("SSUSR",userid),"^",2)
	..s prtrowid=""
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,prtrowid)) q:prtrowid=""  d 
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...;Start  Lid 2009-06-04 获取预交金信息
	...s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",1)
	...s deptypedr="",deptypedesc=""
	...s deptypedr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",13)
	...i deptypedr'=""  d
	....i $d(^ARC("ARCDT",deptypedr))'=0  d
	.....s deptypedesc=$p(^ARC("ARCDT",deptypedr),"^",2)
	...s rcptno=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",1),$c(1))
	...s jkflag=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",23),$c(1))
	...s jkflag=$g(jkflag)         
	...s prtstatus=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",8),$c(1))
	...s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	...q:'$d(^PAADM(admno))
	...i admno'="" s paprowid=$p(^PAADM(admno),"^",1)
	...s admlocDr=$p(^PAADM(admno),"^",4)
	...i admlocDr'="" s admloc=$p(^CTLOC(admlocDr),"^",2),locCode=$p(^CTLOC(admlocDr),"^",1)
	...s admloc=$p(admloc,"-",2)
	...s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	...s zyno=$p(^PAPER(paprowid,"PAT",1),"^",22)
	...s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtuser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
	...s refundrcpt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",7) 
	...s username=$p(^SSU("SSUSR",prtuser),"^",2)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...s printdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",2)
	...s printdate=$zd(printdate,3)
	...s prttime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",3)
	...s printtime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3))
	...i prtstatus="1" s prtstatus="正常"
	...i prtstatus="2" s prtstatus="作废"
	...i prtstatus="3" s prtstatus="冲红"
	...i prtstatus="4" s prtstatus="已冲红"
	...i prtstatus="5" s prtstatus="打印"
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...i prtstatus="冲红" d
	....i rcptno="" d
	.....s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",7) 
	...s jkuserno=""
	...s jkuserno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",30)
	...s chequeno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",11)
	...s confirmdate=""
	...s confirmdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",25)
	...i confirmdate'="" s confirmdate=$zd(confirmdate,3)
	...s handdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",21)
	...i handdate'="" s handdate=$zd(handdate,3)
	...s handdate=handdate
	...i paydesc'=""  s ^TMP("ZYJF","DeptRpt",Guser,job,yjnum)=papname_"^"_papno_"^"_rcptno_"^"_$j(payamount,3,2)_"^"_paydesc_"^"_prtstatus_"^"_printdate_"^"_printtime_"^"_handdate_"^"_username_"^"_prtrowid_"^"_jkuserno_"^"_admloc_"^"_""_"^"_job_"^"_""_"^"_yjnum_"^"_zyno_"^"_deptypedesc_"^"_deptypedr_"^"_refundrcpt
	...i deptypedesc="住院押金"  d
	....i rcptno'=""  d
	.....s ^TMP("ZYJF","DepositNo",Guser,job,Depositind)=rcptno ;记录收据号
	.....s Depositind=Depositind+1
	...i deptypedesc="病历押金"  d
	....i (rcptno'="")&&(prtstatus'="冲红")&&(prtstatus'="作废")  d
	.....s ^TMP("ZYJF","BLDepositNo",Guser,job,BLDepositind)=rcptno
	.....s BLDepositind=BLDepositind+1
	...s yjnum=yjnum+1
	...;End
	...q:prtstatus="作废"
	...s sdepamt=sdepamt+payamount         //每个收款员的收押金金额
	...s hzsdepamt=hzsdepamt+payamount     //所以收款员的收押金金额
	...i '$d(^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc)) s ^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc)=payamount
	...e  s ^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc)=^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc)+payamount
	...i '$d(^TMP("ZYJF","DailyHZPayM",job,paydesc)) s ^TMP("ZYJF","DailyHZPayM",job,paydesc)=payamount
	...e  s ^TMP("ZYJF","DailyHZPayM",job,paydesc)=^TMP("ZYJF","DailyHZPayM",job,paydesc)+payamount 
	..;取发票信息
	..s invrowid="" 
	..f  s invrowid=$o(^DHCINVPRTZY(0,"JK",jkdr,invrowid)) q:invrowid=""  d
	...s prtstatus=$p(^DHCINVPRTZY(invrowid),"^",8)
	...s pbrowid=$p(^DHCINVPRTZY(invrowid),"^",5)
	...s payorshare=0
	...i pbrowid'=""  d
	...s patfee=$p(^DHCINVPRTZY(invrowid),"^",6) ;病人费用
	...s patdeposit=$p(^DHCINVPRTZY(invrowid),"^",22)
	...s billno=$p(^DHCINVPRTZY(invrowid),"^",5)
	...d GetInvPrtInfo(invrowid)
	...s ^TMP("ZYJF","FindInvPrt",Guser,job,fpnum)=invrowid_"^"_invno_"^"_$j(patfee,3,2)_"^"_$g(jkflag)_"^"_$g(prtstatus)_"^"_$g(prtuser)_"^"_$g(billno)_"^"_$g(admno)_"^"_$g(arrcdr)_"^"_deposit_"^"_$g(prtcom2)
	...i invno'=""  d
	....q:oldInvno=invno
	....s ^TMP("ZYJF","InvNo",Guser,job,invnum)=invno
	....s invnum=invnum+1
	....s oldInvno=invno
	...s fpnum=fpnum+1
	...q:prtstatus="作废"
	...s patdiscount=patdiscount+discount         ;折扣金额
	...s hzpatdiscount=hzpatdiscount+discount 
	...s patpayorshare=patpayorshare+payorshare   ;记账金额
	...s hzpatpayorshare=hzpatpayorshare+payorshare
	...s patsharefee=patsharefee+patshare         ;自付金额
	...s hzpatsharefee=hzpatsharefee+patshare
	...s acount=acount+patfee                 //每个收款员所收病人费用合计
	...s hzacount=hzacount+patfee
	...s tdepamt=tdepamt+patdeposit         //每个收款员的冲退押金金额
	...s hztdepamt=hztdepamt+patdeposit     //所以收款员的冲退押金金额
	...s arrcp=""
	...f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	....s arral="" 
	....s rcptnum=$p(^ARRCP(arrcp),"^",2)
	....f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	.....s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	.....i type="" d
	......s paym="0"
	......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	.......s ss=^ARRCP(arrcp,"PAYM",paym)
	.......s mode=$p(ss,"^",1)
	.......s:mode="" mode="19"
	.......s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
	.......i '$d(^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc)) s ^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc)=m2
	.......e  s ^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc)=^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc)+m2
	.......i '$d(^TMP("ZYJF","DailyHZPayM",job,paydesc)) s ^TMP("ZYJF","DailyHZPayM",job,paydesc)=m2
	.......e  s ^TMP("ZYJF","DailyHZPayM",job,paydesc)=^TMP("ZYJF","DailyHZPayM",job,paydesc)+m2 
	..s n=0
	..s paydr="0"
	..f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(n>16)  d
	...s paydesc=$p(^CT("CTPM",paydr),"^",2)
	...s n=n+1
	...s paym(n)=+$g(^TMP("ZYJF","DailyHZPayM",job,jkdr,paydesc))
	..Do OutputRow3	
	s n=0
	s paydr="0"
	f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(n>16)  d
	.s paydesc=$p(^CT("CTPM",paydr),"^",2)
	.s n=n+1
	.s paym(n)=+$g(^TMP("ZYJF","DailyHZPayM",job,paydesc)) 
	s jsdate="合计",username="",userid="",sdepamt=hzsdepamt,tdepamt=hztdepamt,acount=hzacount,patdiscount=hzpatdiscount,patpayorshare=hzpatpayorshare,patsharefee=hzpatsharefee,select=0
	Do OutputRow3

	///获取会计/住院分类
	f i=1:1:$g(^tmpipcate($j)) d
	.s flfee=flfee_"!"_$p(^tmpipcate($j,i),"^",2)_"^"_$j(itmcatefee(+$p(^tmpipcate($j,i),"^",1)),3,2)
	s ^TMP("ZYJF","FLFEE",job)=flfee
	  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
    set Data=$lb(select,jsdate,username,userid,sdepamt,tdepamt,acount,patdiscount,patpayorshare,patsharefee,$j,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
	
GetInvPrtInfo(prtrowid)
   	s s=^DHCINVPRTZY(prtrowid)
	s prtuser=$p($p(s,"^",7) ,$c(1))
	s invno=$p(s,"^",1)
	s prtdate=$p(s,"^",2)
	s jkflag=$p(s,"^",14)
	s prtstatus=$p(s,"^",8)
	s prtcom2=$p(s,"^",25)  
	i prtstatus="A" s prtstatus="作废"
	i prtstatus="S" s prtstatus="冲红"
	i (prtstatus="N")!(prtstatus="I")  d
	s prtstatus="正常"
	s oldrowid=$p(s,"^",13)
	s deposit=$p(s,"^",22)
	s username=$p(^SSU("SSUSR",prtuser),"^",2)
	s admno=$p(s,"^",4)
	q:'$d(^PAADM(admno))
	i admno'="" d  s paprowid=$p(^PAADM(admno),"^",1)
	i admno'="" d  s admreason=$p(^PAADM(admno,1),"^",7)
    i admreason="" s admreasondesc="自费病人"
	e  s admreasondesc=$p(^PAC("ADMREA",admreason),"^",2)
	;q:pattype'=admreasondesc   ;病人类型
	i admreasondesc="自费"  s admreasondesc="自费病人"
	s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	s zyno=$p(^PAPER(paprowid,"PAT",1),"^",22)
	s dep=$p(^PAADM(admno),"^",4)
    s depart=$p(^CTLOC(dep),"^",2)
    s locCode=$p(^CTLOC(dep),"^",1)
    s ward1=$p(^PAADM(admno),"^",70)
    s ward=""
    i ward1'="" s ward=$p($g(^PAWARD(ward1)),"^",2)
    s depart=$p(depart,"-",2)
    s ward=$p(ward,"-",2)
	s billno=$p(s,"^",5) 
	s prtdate=$p(s,"^",2)
	s prtdate=$zd(prtdate,3) 
	s prttime=$zt($p(s,"^",3))
	s ctdeposit=deposit-acount
	s handindate=$p(s,"^",15)
	s handtime=$p(s,"^",16)
	s jkuserno=""
	s jkuserno=$p(s,"^",23)
	s chinitial=$p(s,"^",13)
	s oldpay=0-acount
	;s ybamount=..getybamout(billno)
	i prtstatus="冲红" d
	.d ##class(web.UDHCJFDayRptJST).gethcdetail(prtrowid)
	.i invno="" d
	..s invno=$p(^DHCINVPRTZY(oldrowid),"^",1)
	i (chinitial'="")&(prtstatus="冲红") d
	.d ##class(web.UDHCJFDailyHand).getchinfo(admno,prtrowid)
	i handindate s hdat=$zd(handindate,3) 
	i handtime s handtime=$zt(handtime,3)
	s arpbl=+$p(s,"^",5) ;current bill number
	i ((prtstatus'="作废")&(Guser'="")) d ##class(web.UDHCJFDailyHand).getacctfee(arpbl,"AC",.itmcatefee)    ;按会计分类费用
    i prtstatus'="作废" d
	.s patfee(1)=patfee(1)+acount,patfee(2)=patfee(2)+deposit
	.d ##class(web.UDHCJFDayRptJST).settdeposit(arpbl,prtstatus)
	d ##class(web.UDHCJFDailyHand).getbillinfo1(arpbl,prtstatus,admreason,deposit,prtuser)
}

ClassMethod NotHandinInfo()
{
	Set repid=$I(^CacheTemp)
    s ind=1
    s num=1
	s ssnum=..FindUser("I","3")
	i ssnum=0  Set qHandle=$lb(0,repid,0) Quit $$$OK
	k ^TMP("ZYJF","DailyHZPayM",job)
	s jsdate=""
	s hzsdepamt=0,hztdepamt=0,hzacount=0,hzpatdiscount=0,hzpatpayorshare=0,hzpatsharefee=0
	f i=1:1:ssnum  d
	.s userid=SSPLIST(i)
	.q:(skuserid'="")&(skuserid'=userid)
	.s username=""
	.i userid'="" s username=$p(^SSU("SSUSR",userid),"^",2)
	.s payorsum=0,yb=0
	.s sdepamt=0,tdepamt=0,acount=0,patdiscount=0,patpayorshare=0,patsharefee=0
	.s enddate=+$h
	.s prtdate=stdate
	.f prtdate=stdate:1:enddate d
	..;取押金信息
	..s prtrowid=""
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  d 
	...s jkdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",30)
	...q:jkdr'=""
	...s adduser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
	...q:adduser'=userid
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...q:prtstatus="2"   ;做废状态退出
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...s sdepamt=sdepamt+payamount         //每个收款员的收押金金额
	...s hzsdepamt=hzsdepamt+payamount     //所以收款员的收押金金额
	...i '$d(^TMP("ZYJF","DailyHZPayM",job,userid,paydesc)) s ^TMP("ZYJF","DailyHZPayM",job,userid,paydesc)=payamount
	...e  s ^TMP("ZYJF","DailyHZPayM",job,userid,paydesc)=^TMP("ZYJF","DailyHZPayM",job,userid,paydesc)+payamount
	...i '$d(^TMP("ZYJF","DailyHZPayM",job,paydesc)) s ^TMP("ZYJF","DailyHZPayM",job,paydesc)=payamount
	...e  s ^TMP("ZYJF","DailyHZPayM",job,paydesc)=^TMP("ZYJF","DailyHZPayM",job,paydesc)+payamount 
	..;取发票信息
	..s invrowid=""   ;取发票信息
	..f  s invrowid=$o(^DHCINVPRTZY(0,"DATE",prtdate,invrowid)) q:invrowid=""  d
	...s jkdr=$p(^DHCINVPRTZY(invrowid),"^",23)
	...q:jkdr'=""
	...s adduser=$p(^DHCINVPRTZY(invrowid),"^",7)
	...q:adduser'=userid
	...s prtstatus=$p(^DHCINVPRTZY(invrowid),"^",8)
	...q:prtstatus="A"
	...s pbrowid=$p(^DHCINVPRTZY(invrowid),"^",5)
	...s discount=0,payorshare=0,patshare=0
	...i pbrowid'=""  d
	....s discount=+$p(^DHCPB(pbrowid),"^",9)  ;;折扣金额
	....s payorshare=+$p(^DHCPB(pbrowid),"^",11) ;公费记账金额
	....s patshare=+$p(^DHCPB(pbrowid),"^",12) ;自付金额
	...s patdiscount=patdiscount+discount         ;折扣金额
	...s hzpatdiscount=hzpatdiscount+discount 
	...s patpayorshare=patpayorshare+payorshare   ;记账金额
	...s hzpatpayorshare=hzpatpayorshare+payorshare
	...s patsharefee=patsharefee+patshare         ;自付金额
	...s hzpatsharefee=hzpatsharefee+patshare
	...s patfee=$p(^DHCINVPRTZY(invrowid),"^",6)
	...s acount=acount+patfee                 //每个收款员所收病人费用合计
	...s hzacount=hzacount+patfee
	...s patdeposit=$p(^DHCINVPRTZY(invrowid),"^",22)
	...s tdepamt=tdepamt+patdeposit         //每个收款员的冲退押金金额
	...s hztdepamt=hztdepamt+patdeposit     //所以收款员的冲退押金金额
	...s billno=$p(^DHCINVPRTZY(invrowid),"^",5)
	...s arrcp=""
	...f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	....s arral="" 
	....s rcptnum=$p(^ARRCP(arrcp),"^",2)
	....f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	.....s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	.....i type="" d
	......s paym="0"
	......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	.......s ss=^ARRCP(arrcp,"PAYM",paym)
	.......s mode=$p(ss,"^",1)
	.......i mode="" s mode="19"
	.......s m2=$p(ss,"^",3)
	.......s paydesc=$p(^CT("CTPM",mode),"^",2)
	.......i '$d(^TMP("ZYJF","DailyHZPayM",job,userid,paydesc)) s ^TMP("ZYJF","DailyHZPayM",job,userid,paydesc)=m2
	.......e  s ^TMP("ZYJF","DailyHZPayM",job,userid,paydesc)=^TMP("ZYJF","DailyHZPayM",job,userid,paydesc)+m2
	.......i '$d(^TMP("ZYJF","DailyHZPayM",job,paydesc)) s ^TMP("ZYJF","DailyHZPayM",job,paydesc)=m2
	.......e  s ^TMP("ZYJF","DailyHZPayM",job,paydesc)=^TMP("ZYJF","DailyHZPayM",job,paydesc)+m2 
    .s n=0
	.s paydr="0"
	.f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(n>16)  d
	..s paydesc=$p(^CT("CTPM",paydr),"^",2)
	..s n=n+1
	..s paym(n)=+$g(^TMP("ZYJF","DailyHZPayM",job,userid,paydesc))
	.s select=0
	.Do OutputRow6	
	s n=0
	s paydr="0"
	f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(n>16)  d
	.s paydesc=$p(^CT("CTPM",paydr),"^",2)
	.s n=n+1
	.s paym(n)=+$g(^TMP("ZYJF","DailyHZPayM",job,paydesc)) 
	
	s jsdate="合计",username="",userid="",sdepamt=hzsdepamt,tdepamt=hztdepamt,acount=hzacount,patdiscount=hzpatdiscount,patpayorshare=hzpatpayorshare,patsharefee=hzpatsharefee,select=0
	Do OutputRow6
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow6
    set Data=$lb(select,jsdate,username,userid,sdepamt,tdepamt,acount,patdiscount,patpayorshare,patsharefee,$j,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

/// w ##class(web.UDHCJFDayRpt).FindUser("I","3")
ClassMethod FindUser(grp, type)
{
	s ssnum=0
	s rowid=""
    s rowid=$o(^DHCJFRcptGroupSet(0,"Type",grp,type,""))
    
    i rowid'="" d
    .s sub=0
    .f  s sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) q:sub=""  d
    ..s usrrowid=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",4)
    ..s ssnum=ssnum+1
    ..s SSPLIST(ssnum)=usrrowid
    ..;s SSPLIST=ssnum
    ..;s usrgrp=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",3)
    ..;i $d(^SSU("SSUSR",usrrowid)) s usrname=$p(^SSU("SSUSR",usrrowid),"^",2)
    ..;i $d(^SSU("SSGRP",usrgrp)) s usrgrp=$p(^SSU("SSGRP",usrgrp),"^",1)
    ..
	q ssnum
}

Query FindJsHz(stdate, enddate, ReportNo, Handin, nothandin, accept, notaccept, skuserid, job) As websys.Query(ROWSPEC = "Tselect,Tjsdate,Tusername,Tuserid,Tsdepamt,Ttdepamt,Tacount,Tpatdiscount,Tpatpayorshare,Tpatsharefee,Tjob,Tpaym1,Tpaym2,Tpaym3,Tpaym4,Tpaym5,Tpaym6,Tpaym7,Tpaym8,Tpaym9,Tpaym10,Tpaym11,Tpaym12,Tpaym13,Tpaym14,Tpaym15,Tpaym16")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFDayRpt","FindJsHz","61514","61520","","","on","","","")
ClassMethod FindJsHzExecute(ByRef qHandle As %Binary, stdate, enddate, ReportNo, Handin, nothandin, accept, notaccept, skuserid, job) As %Status
{
	//取结算汇总信息
    s Guser=$g(%session.Data("LOGON.USERID"))
    i (job="") s job=$j
    i skuserid="0"  s skuserid=""
    i (Handin="on")&(nothandin="")  d
    .s jsflag="Y"
    e  d 
    .s jsflag="N"
    i (accept="on")&(notaccept="")  d
    .s acceptflag="Y"
    e  d
    .s acceptflag="N"
    
    i (ReportNo="")&(Handin="on")  d  s rtn=..HandinInfo()
	i (ReportNo="")&(Handin'="on")  d  s rtn=..NotHandinInfo()
	
	q rtn
}

ClassMethod getstdate(guser)
{
	s rowid=$o(^DHCJFUSERJK(0,"user",guser,""),-1)
	s enddate=+$h
	i rowid'=""  d
	.s enddate=$p(^DHCJFUSERJK(rowid),"^",4)
	e  d
	.s yjrowid="",fprowid=""
	.s yjnumber=0,fpnumber=0
	.s yjenddate=0,fpenddate=0
	.f  s yjrowid=$o(^DHCSFPRINTDETAIL(0,"AddUser",guser,yjrowid),-1)  q:(yjrowid="")!(yjnumber'=0)  d
	..s jkflag=$p(^DHCSFPRINTDETAIL(yjrowid),"^",23)
	..i jkflag="Y"  d
	...s yjnumber=1
	..e  d
	...s yjenddate=$p(^DHCSFPRINTDETAIL(yjrowid),"^",2)
	...s yjnumber=0
	.f  s fprowid=$o(^DHCINVPRTZY(0,"USER",guser,fprowid),-1)  q:(fprowid="")!(fpnumber'=0)  d
	..s handin=$p(^DHCINVPRTZY(fprowid),"^",14)
	..i handin="Y"  d
	...s fpnumber=1
	..e  d
	...s fpenddate=$p(^DHCINVPRTZY(fprowid),"^",2)
	...s fpnumber=0
	.i yjenddate=0  s yjenddate=+$h
	.i fpenddate=0  s fpenddate=+$h
	.i yjenddate'>fpenddate d
	..s enddate=yjenddate
	.e  d
	..s enddate=fpenddate
	i enddate<+$h s enddate=enddate
	s enddate=$zd(enddate,4)
	q enddate
}

/// 取结算汇总信息
Query FindJsHis(stdate, enddate, guser) As websys.Query(ROWSPEC = "Tjsdate:%String,Tjstime:%String,Tstdate:%String,Tenddate:%String,RowId:%String")
{
}

ClassMethod FindJsHisExecute(ByRef qHandle As %Binary, stdate, enddate, guser) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s num=1
	f jkdate=stdate:1:enddate d
	.s jkdr=""
	.f  s jkdr=$o(^DHCJFUSERJK(0,"date",jkdate,jkdr)) q:jkdr=""  d
	..s jkuser=$p(^DHCJFUSERJK(jkdr),"^",5)
	..q:jkuser'=guser
	..s jsdate=$p(^DHCJFUSERJK(jkdr),"^",1)
	..i jsdate'="" s jsdate=$zd(jsdate,3)
	..s jstime=$p(^DHCJFUSERJK(jkdr),"^",2)
	..i jstime'="" s jstime=$zt(jstime,1)
	..s stdate=$p(^DHCJFUSERJK(jkdr),"^",3)
	..i stdate'="" s stdate=$zd(stdate,3)
	..s enddate=$p(^DHCJFUSERJK(jkdr),"^",4)
	..i enddate'="" s enddate=$zd(enddate,3)
	..Do OutputRow4
    
    Quit $$$OK
OutputRow4
	set Data=$lb(jsdate,jstime,stdate,enddate,jkdr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod hiscount(itmjs As %Library.String = "", itmjsex As %Library.String = "", stdate, enddate, guser)
{
    s a=0
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	f jkdate=stdate:1:enddate d
	.s jkdr=""
	.f  s jkdr=$o(^DHCJFUSERJK(0,"date",jkdate,jkdr)) q:jkdr=""  d
	..b
	..s jkuser=$p(^DHCJFUSERJK(jkdr),"^",5)
	..q:jkuser'=guser
	..s a=a+1
	s P1=a
	q P1
}

ClassMethod getpatmx(itmjs As %Library.String = "", itmjsex As %Library.String = "", prtrowid)
{
	k PLIST
	s num=1
	s admdr=$p(^DHCINVPRTZY(prtrowid),"^",4)
	s billno=$p(^DHCINVPRTZY(prtrowid),"^",5)
	s locdr=$p(^PAADM(admdr),"^",4)
	s locname=""
	i locdr'=""  s locname=$p(^CTLOC(locdr),"^",2)
	s tmpstr=..getinpatcate(billno)  
	q locname_"##"_tmpstr
}

ClassMethod geticfee(bill)
{
	;根据账单号取收费项目的住院费用dhc_patientbill,dhc_ARPBLorder,dhc_ARPBLdetails
	s ordsub=""
	s incate=""
	s test=0
	s test1=0
	s disamount=0,payshare=0,patshare=0,totalamount=0
	k P1,P2
	k mPLIST,PLIST,patPLIST
	k ^TMPCACHE("PB",$j)
	k ^TMP("ZYJF",$j)
	f i=1:1:$g(^tmpincate($j)) d
	.s itmfee(i)=0
	f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:ordsub=""  d
	.q:ordsub=0
	.s oerowid=$p(^DHCPB(bill,"O",ordsub),"^",4)
	.q:'$d(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2)))
	.s detsub="0"
	.f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:detsub=""  d
	..s taritem=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",3)     ;收费项目
	..s unitprice=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",4)   ;单价
	..s qty=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",5)         ;数量
	..s totalamount=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",7) ;总额
	..i taritem'="" s inpatcate=$p(^DHCTARI(taritem),"^",14)     ;住院费用子分类         
	..s patcatdesc=$p(^DHCTarC("IC",inpatcate),"^",2)            ;insert 2006.02.28 by cx
	..s icate=$p(^DHCTarC("IC",inpatcate),"^",3)                 ;住院费用大类
	..f i=1:1:$g(^tmpincate($j)) d
	...i $p(icate,$c(1))=$p($p(^tmpincate($j,i),"^",1),$c(1)) d
	....s itmfee(i)=totalamount+itmfee(i)
	...e  s test=totalamount
	s tmpstr=""
	f i=1:1:$g(^tmpincate($j)) d
	.s mPLIST(i)=$p(^tmpincate($j,i),"^",2)_"^"_$j(itmfee(i),3,2)
	.s PLIST(i)=$p(^tmpincate($j,i),"^",2)_"^"_$j(itmfee(i),3,2)
	.s ^TMP("ZYJF",$j,i)=PLIST(i)
	.s tmpstr=tmpstr_"&"_PLIST(i)
	s P1=$g(^tmpincate($j))	     
	q tmpstr
}

/// 根据账单号取收费项目的住院费用dhc_patientbill,dhc_ARPBLorder,dhc_ARPBLdetails
ClassMethod getIPfee(bill)
{
	s ordsub=""
	s incate=""
	s test=0
	s test1=0
	s disamount=0,payshare=0,patshare=0,totalamount=0
	k P1,P2
	f i=1:1:$g(ipcPLIST) d
	.s itmfee(i)=0
	f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:ordsub=""  d
	.q:ordsub=0
	.s oerowid=$p(^DHCPB(bill,"O",ordsub),"^",4)
	.q:'$d(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2)))
	.s detsub="0"
	.f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:detsub=""  d
	..s taritem=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",3)     ;收费项目
	..s unitprice=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",4)   ;单价
	..s qty=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",5)         ;数量
	..s totalamount=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",7) ;总额
	..i (taritem'="") s inpatcate=$p(^DHCTARI(taritem),"^",14)     ;住院费用子分类         
	..s patcatdesc=$p(^DHCTarC("IC",inpatcate),"^",2)            ;insert 2006.02.28 by cx
	..s icate=$p(^DHCTarC("IC",inpatcate),"^",3)                 ;住院费用大类
	..i $g(tmpPLIST(icate)) s itmfee(tmpPLIST(icate))=itmfee(tmpPLIST(icate))+totalamount

	q ""
}

/// 取住院分类DHC_TARIC 
ClassMethod getIPcate()
{
	k P9,ipcPLIST,tmpPLIST
	s n=1
	s rowid="0"
	f  s rowid=$o(^DHCTarC("TIC",rowid))  q:rowid=""  d
	.i $g(^tmpincate($j))="" s ^tmpincate($j)=0
	.s icdesc=$p(^DHCTarC("TIC",rowid),"^",2)
	.s ^tmpincate($j,n)=$p(rowid,$c(1))_"^"_icdesc
	.;s mPLIST(n)=$p(rowid,$c(1))_"^"_icdesc
	.s ipcPLIST(n)=rowid_"^"_icdesc,ipcPLIST=n
	.s tmpPLIST(rowid)=n
	.s ^tmpincate($j)=n
	.s n=n+1
	s P9=n-1
	q P9
}

ClassMethod getinpatcate0(bill)
{
	;取住院分类DHC_TARAC 
	k ^tmpincate($j),P9,mPLIST
	s n=1
	s rowid="0"
	f  s rowid=$o(^DHCTarC("TIC",rowid))  q:rowid=""  d
	.i $g(^tmpincate($j))="" s ^tmpincate($j)=0
	.s icdesc=$p(^DHCTarC("TIC",rowid),"^",2)
	.s ^tmpincate($j,n)=$p(rowid,$c(1))_"^"_icdesc
	.s mPLIST(n)=$p(rowid,$c(1))_"^"_icdesc
	.s ^tmpincate($j)=n
	.s n=n+1
	s P9=n-1
	s tmpstr=..geticfee(bill)
	k ^tmpincate($j)
	k ^tmpinpatcate($j)
	q tmpstr
}

ClassMethod getinpatcate(billno)
{
	s str=..getinpatcate0(billno)  
	q str
}

Query Findrcptdetail(rcptno) As websys.Query(ROWSPEC = "Tpaymode:%String,Tmodeid:%String,Tamt:%String,Tprtdate:%String,Tprttime:%String,Tuser:%String,Trowid:%String")
{
}

ClassMethod FindrcptdetailExecute(ByRef qHandle As %Binary, rcptno) As %Status
{
   //取结算汇总信息
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
	s rcptno=$g(rcptno)
	i (rcptno="") Quit $$$OK
	
	s rcptno=$$ALPHAUP^SSUTIL4(rcptno)
	s inv=$o(^DHCINVPRTZY(0,"INV",rcptno,""))
	i ((inv="")||'($d(^DHCINVPRTZY(inv)))) Set qHandle=$lb(0,repid,0)  Quit $$$OK
	s flag=$p($g(^DHCINVPRTZY(inv)),"^",8)
	s adm=$p($g(^DHCINVPRTZY(inv)),"^",4)
	s prtdate=$p($g(^DHCINVPRTZY(inv)),"^",2)
	s:prtdate'="" prtdate=$zd(prtdate,3)
	s prttime=$p($g(^DHCINVPRTZY(inv)),"^",3)
	s:prttime'="" prttime=$zt(prttime)
	s user=$p($g(^DHCINVPRTZY(inv)),"^",7)
	s:user'="" user=$p($g(^SSU("SSUSR",user)),"^",2)
	;s:adm'="" pmi=$p($g(^PAADM(adm)),"^",1)
	
	i flag'["N"   Set qHandle=$lb(0,repid,0)  Quit $$$OK
	s rcptid=$o(^ARRCP(0,"Number",rcptno,""))
	
	s payid=0
	f  s payid=$o(^ARRCP(rcptid,"PAYM",payid)) q:payid=""  d
	.s modeid=$p($g(^ARRCP(rcptid,"PAYM",payid)),"^",1)
	.s:modeid'="" pmode=$p($g(^CT("CTPM",modeid)),"^",2)
	.s amt=$p($g(^ARRCP(rcptid,"PAYM",payid)),"^",3)
	.s rowid=rcptid_"||"_payid
	.Do OutputRow11
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow11
	set Data=$lb(pmode,modeid,amt,prtdate,prttime,user,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod uppaymode(rowid As %Integer, val As %String) As %Integer
{
	s rowid=$g(rowid)
	s val=$g(val)
	q:((rowid="")!(val="")) 0
	; s prepym=$p($p($g(^ARRCP(+rowid,"PAYM",$p(rowid,"||",2))),"^",1),$c(1))
	s pmode=$p(val,"^",1)
	s amt=$p(val,"^",2)
	s user=$p(val,"^",3)
	&sql(update SQLUser.ar_rcptpaymode set PAYM_PayMode_DR=:pmode  where  PAYM_RowId=:rowid )

	q SQLCODE
}

ClassMethod rcptinfo(rcptno) As %Integer
{
	s rcptno=$g(rcptno)
	s str=""	       
	q:(rcptno="") 0
	s str=""
	s dept="",adm="",bill="",inv=""
	s:rcptno'="" rcptno=$$ALPHAUP^SSUTIL4(rcptno)
	s:rcptno'="" inv=$o(^DHCINVPRTZY(0,"INV",rcptno,""))
	i inv'=""  d
	.i $d(^DHCINVPRTZY(inv))'=0   d
	..s dept=$p($g(^DHCINVPRTZY(inv)),"^",22)
	..s adm=$p($g(^DHCINVPRTZY(inv)),"^",4)
	..s bill=$p($g(^DHCINVPRTZY(inv)),"^",5)
	i adm'=""   d
	.i $d(^PAADM(adm))'=0  d
	..s pami=$p($p($g(^PAADM(adm)),"^",1),$c(1))
	..i pami'=""  d
	...i $d(^PAPER(pami))'=0  d
	....s name=$p($g(^PAPER(pami,"ALL")),"^",1)
	i bill'=""  d
	.i $d(^DHCPB(bill))'=0  d
	..s fee=$p($g(^DHCPB(bill)),"^",8)
	s str=$g(name)_"^"_$g(fee)_"^"_$g(dept)_"^"_$g(inv)_"^"_$g(adm)
	q str
}

ClassMethod InsertUserJkNew(str, yjrowid, fprowid)
{
	s jkdate=+$h
	s jktime=$p($h,",",2)
	s stdate=$p(str,"^",1)
	s enddate=$p(str,"^",2)
	s user=$p(str,"^",3)
	s job=$p(str,"^",4)
   
    s err=0
    ;测试结算报表不成功用
    s $ZT="ERROR^DHCSSERR"  d ..tb()	
	k PLIST
	s PLIST(2)=jkdate
	s PLIST(3)=jktime
	s PLIST(4)=stdate
	s PLIST(5)=enddate
	s PLIST(6)=user
	s PLIST(11)="Single"
	&sql(insert into dhc_jfuserjk values :PLIST())
	S err=SQLCODE
	i err'=0 Trollback
	q:(err'=0) err
	s jkrowid=$g(%ROWID)	
	i ((yjrowid'="")&(err=0)) d
	.s err=..yjupdate(jkdate,jktime,yjrowid,jkrowid)
	.i err'=0 Trollback
	q:(err'=0) err
	i ((fprowid'="")&(err=0)) d
	.s err=..fpupdate(jkdate,jktime,fprowid,jkrowid)
	.i err'=0 Trollback
	q:(err'=0) err
	d ..tc()
	q err_"^"_jkrowid
}

/// 判断所选日期是否大于当前日期
/// zhangli
/// 17.5.31
/// 大于：返回1；否则返回0
/// w ##class("web.UDHCJFDayRpt").IFDYCurdate("2017-6-1")
ClassMethod IFDYCurdate(date)
{
	s rtn=0
	i date["-" s date=$zdh(date,3)
	i date["/" s date=$zdh(date,4)
	
	i date>(+$h) s rtn=1
	
	q rtn
}

}
