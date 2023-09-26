Import SQLUser

Class web.UDHCJFDayRptJST Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 668;

ClassMethod settdeposit(billno, prtstatus)
{
  ;出院收回预交金明细
    s str=""
	i $d(^DHCJFDepositRowID("ZYJF",billno)) d
	.s str=^DHCJFDepositRowID("ZYJF",billno)
	.f i=1:1:$l(str,"^") d
	..s yjrowid=$p(str,"^",i)
	..s arrcprowid=$p(yjrowid,"||",1)
	..s paym="0"
	..f  s paym=$o(^ARRCP(arrcprowid,"PAYM",paym)) q:paym=""  d
	...s payamt=$p(^ARRCP(arrcprowid,"PAYM",paym),"^",3)
	...s paymode=$p(^ARRCP(arrcprowid,"PAYM",paym),"^",1)
	...i prtstatus="作废" s payamt=0
	...i prtstatus="冲红" s payamt=0-payamt
	...s ^TMP("ZYJF","CYTDEPOSIT",job)=^TMP("ZYJF","CYTDEPOSIT",job)+payamt
	q
}

ClassMethod getpaymode()
{
    K ^TMP("ZYJF","CYTDEPOSIT",job)
    k ^TMP("ZYJF","CYJSPAYMODE",job,"收")
    k ^TMP("ZYJF","CYJSPAYMODE",job,"退")
	s rowid="0"
	f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
	.s paymodedesc=$p(^CT("CTPM",rowid),"^",2)
	.s ^TMP("ZYJF","CYTDEPOSIT",job,rowid)=0  
	.s ^TMP("ZYJF","CYJSPAYMODE",job,"收",paymodedesc)=0 
	.s ^TMP("ZYJF","CYJSPAYMODE",job,"退",paymodedesc)=0
	.s ^TMP("ZYJF","CYJSCHALL",job,"收",paymodedesc)=0
	.s ^TMP("ZYJF","CYJSCHALL",job,"退",paymodedesc)=0
	q
}

ClassMethod gettdepositpaymode(job)
{
    s cytxj=0,cytzp=0,cytzply=0,cythp=0,cythply=0,cytxyk=0,cytxykly=0
	s rowid=""
	f  s rowid=$o(^TMP("ZYJF","CYTDEPOSIT",job,rowid)) q:rowid=""  d
	.s paymode=$p(^CT("CTPM",rowid),"^",2)
	.s tdeposit=^TMP("ZYJF","CYTDEPOSIT",job,rowid)
	.i paymode="现金" s cytxj=tdeposit
	.i paymode="支票" s cytzp=tdeposit
	.i paymode="支票留用" s cytzply=tdeposit
	.i paymode="汇票" s cythp=tdeposit
	.i paymode="汇票留用" s cythply=tdeposit
	.i (paymode="银行卡")!(paymode="卡支付") s cytxyk=cytxyk+tdeposit
	.i paymode="银行卡留用" s cytxykly=tdeposit
	s str=cytxj_"^"_cytzp_"^"_cythp_"^"_cytxyk_"^"_cytzply_"^"_cythply_"^"_cytxykly
	q str
}

ClassMethod getvalue(job)
{
	s value=^TMP("ZYJF","PAYMODE",job)
	q value
}

ClassMethod HandinzyInfo()
{
    k ^TMP("ZYJF","RYRB",+$h)
	s ind=1
	;S stdate="60451",enddate="60461"
    s sxjsum=0,szpsum=0,shpsum=0,syhksum=0
    s txjsum=0,tzpsum=0,thpsum=0,tyhksum=0
	Set repid=$I(^CacheTemp)
	f jkdate=stdate:1:enddate d
	  .s jkdr=""
	  .s jsdate=jkdate
	  .f  s jkdr=$o(^DHCJFUSERJK(0,"date",jkdate,jkdr)) q:jkdr=""  d
	  ..s xjsum=0,zpsum=0,hpsum=0,yhksum=0
	  ..s userid=$p(^DHCJFUSERJK(jkdr),"^",5)
	  ..s username=""
	  ..i userid'="" s username=$p(^SSU("SSUSR",userid),"^",2)
	  ..s prtrowid=""
	  ..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,prtrowid)) q:prtrowid=""  d 
	  ...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	  ...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	  ...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	  ...s prtstatus=$p(prtstatus,$c(1))
	  ...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	  ...q:prtstatus="2"
	  ...i ((paydesc="现金")&(prtstatus="1")) d 
	  ....s sxjsum=sxjsum+payamount
	  ....s xjsum=xjsum+payamount
	  ...i ((paydesc="现金")&(prtstatus="3")) d 
	  ....s txjsum=txjsum-payamount
	  ....s xjsum=xjsum+payamount
	  ...i ((paydesc="支票")&(prtstatus="1")) d 
	  ....s szpsum=szpsum+payamount
	  ....s zpsum=zpsum+payamount
	  ...i ((paydesc="支票")&(prtstatus="3")) d 
	  ....s tzpsum=tzpsum-payamount
	  ....s zpsum=zpsum+payamount
	  ...i ((paydesc="汇票")&(prtstatus="1")) d 
	  ....s shpsum=shpsum+payamount
	  ....s hpsum=hpsum+payamount
	  ...i ((paydesc="汇票")&(prtstatus="3")) d 
	  ....s thpsum=thpsum-payamount
	  ....s hpsum=hpsum+payamount
	  ...i (((paydesc="银行卡")!(paydesc="信用卡"))&(prtstatus="1")) d 
	  ....s syhksum=syhksum+payamount
	  ....s yhksum=yhksum+payamount
	  ...i (((paydesc="银行卡")!(paydesc="信用卡"))&(prtstatus="3")) d 
	  ....s tyhksum=tyhksum-payamount
	  ....s yhksum=yhksum+payamount
	   
	  ..s ys="0.00",xianjin=$j(xjsum,3,2),zhipiao=$j(zpsum,3,2),huipiao=$j(hpsum,3,2),jsfee="0.00",sdeposit="0.00",tdeposit="0.00",tp="0.00",gfjz="0.00",sldjz="0.00",yb="0.00"
	  ..s xinyk=$j(yhksum,3,2),payorsum="0.00"
	  ..Do OutputRow3	  
	  s jsdate="合计",username="",ys="0.00",xianjin=$j(sxjsum+txjsum,3,2),zhipiao=$j(szpsum+tzpsum,3,2),huipiao=$j(shpsum+thpsum,3,2),jsfee="0.00",sdeposit="0.00",tdeposit="0.00",tp="0.00",jkdr="",gfjz="0.00",sldjz="0.00",yb="0.00",userid=""
	  s xinyk=$j(syhksum+tyhksum,3,2),payorsum="0.00"
	  s tyjsum=txjsum+tzpsum+thpsum+tyhksum
	 ;;s ^TMP("ZYJF",$j,num)="合计"_"^"_""_"^"_$j(yssum,3,2)_"^"_$j(xj,3,2)_"^"_$j(zp,3,2)_"^"_$j(fee,3,2)_"^"_$j(syj,3,2)_"^"_$j(tyj,3,2)_"^"_""_"^"_""
      s retvalue=sxjsum_"^"_txjsum_"^"_szpsum_"^"_tzpsum_"^"_shpsum_"^"_thpsum_"^"_syhksum_"^"_tyhksum_"^"_xianjin_"^"_zhipiao_"^"_huipiao_"^"_xinyk_"^"_tyjsum
      s ^TMP("ZYJF","RYRB",+$h)=retvalue

      Do OutputRow3
      Set qHandle=$lb(0,repid,0)
      Quit $$$OK
OutputRow3
	set Data=$lb(jsdate,username,ys,xianjin,zhipiao,jsfee,sdeposit,tdeposit,tp,jkdr,huipiao,gfjz,sldjz,yb,userid,xinyk,payorsum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod HandincyInfo()
{
	Set repid=$I(^CacheTemp)
    K ^TMP("ZYJF","CYRB",+$h)
    s ind=1
    s num=1
   	;S stdate="60451",enddate="60461"
    s sxjsum=0,szpsum=0,shpsum=0,syhksum=0
    s txjsum=0,tzpsum=0,thpsum=0,tyhksum=0
    s tyjsum=0
	f jkdate=stdate:1:enddate d
	  .s jkdr=""
	  .f  s jkdr=$o(^DHCJFUSERJK(0,"date",jkdate,jkdr)) q:jkdr=""  d
	  ..;s jsdate=jkdate
	  ..s xjsum=0,zpsum=0,hpsum=0,yhksum=0
	  ..s yssum=0,xj=0,zp=0,fee=0,syj=0,tyj=0,yb=0,sldjz=0,gfjz=0,xyksum=0
	  ..s payorsum=0,yb=0
	  ..s userid=$p(^DHCJFUSERJK(jkdr),"^",5)
	  ..s username=""
	  ..i userid'="" s username=$p(^SSU("SSUSR",userid),"^",2)
	  ..s invrowid=""   ;取发票信息
	  ..f  s invrowid=$o(^DHCINVPRTZY(0,"JK",jkdr,invrowid)) q:invrowid=""  d
	  ...s prtstatus=$p(^DHCINVPRTZY(invrowid),"^",8)
	  ...q:prtstatus="A"
	  ...s patdeposit=$p(^DHCINVPRTZY(invrowid),"^",22)
	  ...s tyjsum=tyjsum+patdeposit
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
	  .......i mode="" s mode="2"
	  .......s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
	  .......i m2>0 d
	  ........i paydesc="现金" s sxjsum=sxjsum+m2,xjsum=xjsum+m2
	  ........i paydesc="支票" s szpsum=szpsum+m2,zpsum=zpsum+m2
	  ........i paydesc="汇票" s shpsum=shpsum+m2,hpsum=hpsum+m2
	  ........i (paydesc="银行卡")!(paydesc="信用卡") s syhksum=syhksum+m2,yhksum=yhksum+m2
	  .......i m2<0 d
	  ........i paydesc="现金" s txjsum=txjsum-m2,xjsum=xjsum+m2
	  ........i paydesc="支票" s tzpsum=tzpsum-m2,zpsum=zpsum+m2
	  ........i paydesc="汇票" s thpsum=thpsum-m2,hpsum=hpsum+m2
	  ........i (paydesc="银行卡")!(paydesc="信用卡") s tyhksum=tyhksum-m2,yhksum=yhksum+m2
	  ..s ys="0.00",xianjin=$j(xjsum,3,2),zhipiao=$j(zpsum,3,2),huipiao=$j(hpsum,3,2),jsfee="0.00",sdeposit="0.00",tdeposit=$j(patdeposit,3,2),tp="0.00",gfjz="0.00",sldjz="0.00",yb="0.00"
	  ..s xinyk=$j(yhksum,3,2),payorsum="0.00"
	  ..Do OutputRow4	  
	  s jsdate="合计",username="",ys="0.00",xianjin=$j(sxjsum-txjsum,3,2),zhipiao=$j(szpsum-tzpsum,3,2),huipiao=$j(shpsum-thpsum,3,2),jsfee="0.00",sdeposit="0.00",tdeposit=$j(tyjsum,3,2),tp="0.00",jkdr="",gfjz="0.00",sldjz="0.00",yb="0.00",userid=""
	  s xinyk=$j(syhksum+-tyhksum,3,2),payorsum="0.00"
      s retvalue=sxjsum_"^"_txjsum_"^"_szpsum_"^"_tzpsum_"^"_shpsum_"^"_thpsum_"^"_syhksum_"^"_tyhksum_"^"_xianjin_"^"_zhipiao_"^"_huipiao_"^"_xinyk_"^"_tyjsum
      s ^TMP("ZYJF","CYRB",+$h)=retvalue
      Do OutputRow4
      Set qHandle=$lb(0,repid,0)
     Quit $$$OK
OutputRow4
	set Data=$lb(jsdate,username,ys,xianjin,zhipiao,jsfee,sdeposit,tdeposit,tp,jkdr,huipiao,gfjz,sldjz,yb,userid,xinyk,payorsum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod getallbillfee(bill)
{
    d ##class(web.UDHCJFDayRpt).getIPcate()
    f i=1:1:$g(^tmpincate($j)) d
	.s itmipfee($p(^itmincate($j,i),"^",1))=0
	;yyx取住院发票分类金额
}

ClassMethod getonebillfee(bill, itmipfee, itmipfeeYB)
{
 ;根据账单号取收费项目的住院费用dhc_patientbill,dhc_ARPBLorder,dhc_ARPBLdetails
       s itmipfee=$g(itmipfee)
	   s ordsub=""
	   s incate=""
	   s test=0
	   s test1=0
	   s disamount=0,payshare=0,patshare=0,totalamount=0
	   k P1,P2
	   k mPLIST
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
	      ..q:(taritem="")
	      ..s inpatcate=$p(^DHCTARI(taritem),"^",14)     ;住院费用子分类         
	      ..q:(inpatcate="")
	      ..s patcatdesc=$p(^DHCTarC("IC",inpatcate),"^",2)            ;insert 2006.02.28 by cx
	      ..;s icate=$p(^DHCTarC("IC",inpatcate),"^",3) 
	      ..;q:(icate="")
	      ..;s itmipfee(icate)=itmipfee(icate)+totalamount
	      ..s admReasonDr=$p(^DHCPB(bill),"^",4)
	      ..s nationalCode=+$p(^PAC("ADMREA",admReasonDr),"^",5)
	      ..i nationalCode>0 d
	      ...s itmipfeeYB(inpatcate)=itmipfeeYB(inpatcate)+totalamount
	      ..e  d
	      ...s itmipfee(inpatcate)=+$g(itmipfee(inpatcate))+totalamount  ;Wanghc 改成住院子类
	     s P1=$g(^tmpincate($j))	     	     
	   q
}

ClassMethod getyjstr(prtrowid)
{
   s yjstr=""
	s billno=$p(^DHCINVPRTZY(prtrowid),"^",5)
	s prtstatus=$p(^DHCINVPRTZY(prtrowid),"^",8)
	q:prtstatus="A"
	i $d(^DHCJFDepositRowID("ZYJF",billno)) d
	.s yjstr=^DHCJFDepositRowID("ZYJF",billno)
	i yjstr'="" d
	.s retstr=prtstatus_"^"_yjstr
	e  d
	.s retstr=""
	
	q retstr
}

ClassMethod getcytdeposit(arrcp, fpstatus)
{
   
    k mPLIST
    s rcptrowid=$p(arrcp,"||",1)
    s arpbl=$p(^ARRCP(rcptrowid,"RAL",1),"^",18)
    s amt=$p(^ARRCP(rcptrowid,"RAL",1),"^",2)
    q:+amt=0 ""
    q:arpbl="" ""
    s fprowid=$o(^DHCINVPRTZY(0,"AR",arpbl,""))
    s fpdate=$zd($p(^DHCINVPRTZY(fprowid),"^",2),3)
    s fptime=$zt($p(^DHCINVPRTZY(fprowid),"^",3),1)
    s prtrowid=$o(^DHCSFPRINTDETAIL(0,"RcptDR",rcptrowid,""))
	q:prtrowid="" ""
	s rcptno=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",1),$c(1))
	s jkflag=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",23),$c(1))
	s jkflag=$g(jkflag)         
	s prtstatus=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",8),$c(1))
	s admno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
	q:'$d(^PAADM(admno)) ""
	i admno'="" s paprowid=$p(^PAADM(admno),"^",1)
	s admloc=$p(^PAADM(admno),"^",4)
	i admloc'="" s admloc=$p(^CTLOC(admloc),"^",2)
	s admloc=$p(admloc,"-",2)
	s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	s zyno=$p(^PAPER(paprowid,"ALL"),"^",22)
	s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	s paydesc=$p(^CT("CTPM",paymode),"^",2)
	s prtuser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14) 
	s username=$p(^SSU("SSUSR",prtuser),"^",2)
	s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	s prtstatus=$p(prtstatus,$c(1))
	s printdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",2)
	s printdate=$zd(printdate,3)
	s prttime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",3)
	s printtime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3))
	i prtstatus="1" s prtstatus="正常"
	i prtstatus="2" s prtstatus="作废"
	i prtstatus="3" s prtstatus="冲红"
	i prtstatus="4" s prtstatus="已冲红"
	i prtstatus="5" s prtstatus="打印"
	s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	i fpstatus="S" s payamount=0-payamount
	i prtstatus="冲红" d
	.i rcptno="" d
	..s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",7) 
	;s sum=$j(sum,3,2)
	s jkuserno=""
	s jkuserno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",30)
	s chequeno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",15)
	s prtdate=printdate_" "_printtime
	s shdate=fpdate_" "_fptime
	;i prtstatus'="作废" s prtstatus=""
	s mPLIST=admloc_"^"_papname_"^"_zyno_"^"_papno_"^"_$j(payamount,3,2)_"^"_paydesc_"^"_rcptno_"^"_chequeno_"^"_shdate_"^"_prtstatus  ;_"^"_prtdate_"^"_username
	q mPLIST
}

ClassMethod getflfee(job)
{
	s feestr=^TMP("ZYJF","FLFEE",job)
	q feestr
}

ClassMethod getryhz(prtdate)
{
	 s prtdate=$zdh(prtdate,3)
     s str=^TMP("ZYJF","RYRB",prtdate)
     q str
}

ClassMethod getcyhz(prtdate)
{
	s prtdate=$zdh(prtdate,3)
     s str=^TMP("ZYJF","CYRB",prtdate)
     q str
}

ClassMethod getlastdate(guser)
{
    k P1
    s P1=""
    s jkdate="",jktime=""
	s jkrowid=$o(^DHCJFUSERJK(0,"user",guser,""),-1)
	i jkrowid'="" d
	.s jkdate=$p(^DHCJFUSERJK(jkrowid),"^",1)
	.s jktime=$p(^DHCJFUSERJK(jkrowid),"^",2)
	.s P1=$zd(jkdate,3)_"^"_$zt(jktime,1)_"^"_jkrowid
	q P1
}

ClassMethod cancel(guser, jkdr, jkdate, flag)
{
   s retcode=0
      
   Tstart
   i flag="YJ" d
	.s yjnum=0
	.&sql(select count(*) into :yjnum from dhc_sfprintdetail where prt_jk_dr=:jkdr and prt_jkuser=:guser )
	.i yjnum>0  d
	..&sql(update dhc_sfprintdetail set prt_jkflag="",prt_jkdate=null where prt_jk_dr=:jkdr and prt_jkuser=:guser)
	..s retcode=retcode+SQLCODE
	..i retcode=0 d
	...s rowid="" f  s rowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,rowid)) q:rowid=""  d
	....s $p(^DHCSFPRINTDETAIL(rowid),"^",30)=""
	...k ^DHCSFPRINTDETAIL(0,"JKDR",jkdr)
	..i retcode=0 d
	...&sql(delete from dhc_jfuserjk where jk_rowid=:jkdr)
	...s retcode=retcode+SQLCODE
	
   i flag="FP" d
   .s fpnum=0  
   .&sql(select count(*) into :fpnum from dhc_invprtzy where prt_jk_dr=:jkdr and prt_usr=:guser )
   .i fpnum>0  d
   ..&sql(update dhc_invprtzy set prt_handin='N' where prt_jk_dr=:jkdr and prt_usr=:guser)
   ..s retcode=retcode+SQLCODE
   ..i retcode=0  d
   ...s rowid="" f  s rowid=$o(^DHCINVPRTZY(0,"JK",jkdr,rowid)) q:rowid=""  d
   ....s $p(^DHCINVPRTZY(rowid),"^",23)=""
   ...k ^DHCINVPRTZY(0,"JK",jkdr)
   ..i retcode=0  d
   ...&sql(delete from dhc_jfuserjk where jk_rowid=:jkdr)
   ...s retcode=retcode+SQLCODE
   i flag=""  d
   .s yjnum=0
   .&sql(select count(*) into :yjnum from dhc_sfprintdetail where prt_jk_dr=:jkdr and prt_jkuser=:guser )
   .i yjnum>0  d
   ..&sql(update dhc_sfprintdetail set prt_jkflag="",prt_jkdate=null where prt_jk_dr=:jkdr and prt_jkuser=:guser)
   ..s retcode=retcode+SQLCODE
   ..i retcode=0  d
   ...s rowid="" f  s rowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,rowid)) q:rowid=""  d
   ....s $p(^DHCSFPRINTDETAIL(rowid),"^",30)=""
   ...k ^DHCSFPRINTDETAIL(0,"JKDR",jkdr)
   .s fpnum=0  
   .&sql(select count(*) into :fpnum from dhc_invprtzy where prt_jk_dr=:jkdr and prt_usr=:guser )
   .i fpnum>0  d
   ..&sql(update dhc_invprtzy set prt_handin='N',prt_handdate=null where prt_jk_dr=:jkdr and prt_usr=:guser)
   ..s retcode=retcode+SQLCODE
   ..i retcode=0  d
   ...s rowid="" f  s rowid=$o(^DHCINVPRTZY(0,"JK",jkdr,rowid)) q:rowid=""  d
   ....s $p(^DHCINVPRTZY(rowid),"^",23)=""
   ...k ^DHCINVPRTZY(0,"JK",jkdr)
   .i retcode=0  d
   .&sql(delete from dhc_jfuserjk where jk_rowid=:jkdr)
   .s retcode=retcode+SQLCODE 
   i retcode=0 d
   .Tcommit
   e  d 
   .Trollback
   q retcode
}

ClassMethod cancelHz(guser, jkdr, jkdate, flag)
{
   s SQLCODE=0
   Tstart
   i $d(^DHCSFPRINTDETAIL(0,"COM1",jkdr)) d
   .&sql(update dhc_sfprintdetail set prt_confirmflag='N',prt_comment1="" where prt_comment1=:jkdr )
   .i SQLCODE'=0 Trollback
   .i SQLCODE'=0 q:SQLCODE
   i $d(^DHCINVPRTZY(0,"COM1",jkdr)) d
   .&sql(update dhc_invprtzy set prt_approval='N',prt_comment1="" where prt_comment1=:jkdr)
   .i SQLCODE'=0 Trollback
   .i SQLCODE'=0 q:SQLCODE
   &sql(delete from dhc_jfuserjk where jk_rowid=:jkdr)
   i SQLCODE'=0 Trollback
   q:SQLCODE'=0 SQLCODE
   Tcommit
   q SQLCODE
}

ClassMethod InsertUserHz(itmjs As %Library.String = "", itmjsex As %Library.String = "", str, yjrowid, fprowid)
{
	s jkdate=+$h
	s jktime=$p($h,",",2)
	s stdate=$p(str,"^",1)
	s enddate=$p(str,"^",2)
	s user=$p(str,"^",3)
    S stdate=$zdh(stdate,4)
    s enddate=$zdh(enddate,4)
    &js<alert(#(stdate)#)>
    s err=0
    d ##class(web.UDHCJFDayRpt).tb()
	&sql(insert into dhc_jfuserjk(jk_date,jk_time,jk_stdate,jk_enddate,jk_user,jk_flag)
	values (:jkdate,:jktime,:stdate,:enddate,:user,'All'))
	i SQLCODE'=0 Trollback
	s jkrowid=$g(%ROWID)	
	i yjrowid'="" d
	.s err=..yjupdate(jkdate,jktime,yjrowid,jkrowid,user,stdate,enddate)
	.i err'=0 Trollback
	i fprowid'="" d
	.s err=..fpupdate(jkdate,jktime,fprowid,jkrowid,user,stdate,enddate)
	.i err'=0 Trollback
	d ##class(web.UDHCJFDayRpt).tc()
	q err_"^"_jkrowid
}

ClassMethod yjupdate(jkdate, jktime, yjrowid, jkdr, user, stdate, enddate)
{
   ;s num=$l(yjrowid,"^")
   ;s return=0   
   ;f i=1:1:num d
	.;s rowid=$p(yjrowid,"^",i)	
   &sql(update dhc_sfprintdetail set prt_confirmdate=:jkdate,prt_confirmtime=:jktime,prt_confirmuser=:user,prt_confirmflag='Y',prt_comment1=:jkdr
	     where prt_printdate>=:stdate and prt_printdate<=:enddate)
	;s return=return+SQLCODE
	q SQLCODE
}

ClassMethod fpupdate(jkdate, jktime, fprowid, jkdr, user, stdate, enddate)
{
     ;更新发票表
	 ;s num=$l(fprowid,"^")
     ;s return=0     
     ;f i=1:1:num d
	  .;s rowid=$p(fprowid,"^",i)
	 &sql(update dhc_invprtzy set prt_aprouser=:user,prt_aprodate=:jkdate,prt_approval='Y',prt_comment1=:jkdr
	       where prt_date>=:stdate and prt_date<=:enddate)
	 ;s return=return+SQLCODE	 
	 q SQLCODE
}

ClassMethod getstdate(guser)
{
    s enddate=""
    i $d(^DHCJFUSERJK(0,"user",guser))'=0  d
    .s rowid="" f  s rowid=$o(^DHCJFUSERJK(0,"user",guser,rowid),-1) q:(rowid="")!(enddate'="")  d
	..s flag=$p(^DHCJFUSERJK(rowid),"^",10)
	..i flag="All" d
	...s enddate=$p(^DHCJFUSERJK(rowid),"^",4)
	...s enddate=enddate+1
	..e  d
	...s enddate=##class(web.UDHCJFDayRpt).getstdate(guser)
	...s enddate=$zdh(enddate,4)
	e  d
	.s enddate=##class(web.UDHCJFDayRpt).getstdate(guser)
	.s enddate=$zdh(enddate,4)
	i enddate>+$h s enddate=+$h
	i enddate'="" s enddate=$zd(enddate,4)
	q enddate
}

ClassMethod gettyj(prtrowid)
{
    q:prtrowid=""
	s oldrcpt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",7)
	i oldrcpt'="" s oldrowid=$o(^DHCSFPRINTDETAIL(0,"RcptNo",oldrcpt,""))
	s rcptno=$p(^DHCSFPRINTDETAIL(oldrowid),"^",1)
	s olddate=$p(^DHCSFPRINTDETAIL(oldrowid),"^",2)
	s oldtime=$p(^DHCSFPRINTDETAIL(oldrowid),"^",3)
	s oldcardno=$p(^DHCSFPRINTDETAIL(oldrowid),"^",11)
	s payamt=$p(^DHCSFPRINTDETAIL(oldrowid),"^",6)
	s olddate=$zd(olddate,3)
	s oldtime=$zt(oldtime,1)
	s prtdate=olddate
	s str="原交款时间:"_olddate_","_"收据号:"_rcptno_","_"票号:"_oldcardno_","_"金额: "_payamt
	q str
}

ClassMethod gethcdetail(prtrowid)
{
    ;yyx2007-03-28
    ;取某段时间内的冲红的明细
    ;姓名，住院号，登记号，病房，上次结算金额，本次结算金额，冲账金额，操作员
	
	s zcrowid="",newpay=0
    f  s zcrowid=$o(^DHCINVPRTZY(0,"InitInv",prtrowid,zcrowid)) q:zcrowid=""  d
	.s status=$p(^DHCINVPRTZY(zcrowid),"^",8)
	.q:status="A"
	.s newarpbl=$p(^DHCINVPRTZY(zcrowid),"^",5)
	.s retval=##Class(web.DHCINSUFacade).GetCashFromInsuDivideByBillDr(newarpbl,"N")
    .s newybcash=$p(retval,"^",2)
	.s oldinvid=$p(^DHCINVPRTZY(prtrowid),"^",13)
	.s oldpbl=$p(^DHCINVPRTZY(oldinvid),"^",5)
	.s oldretval=##Class(web.DHCINSUFacade).GetCashFromInsuDivideByBillDr(oldpbl,"N")
    .s oldybcash=$p(oldretval,"^",2)
    .i $g(retval)'="" d
	..s newpay=newybcash
    ..s oldpay=oldybcash
    ..s chpay=newybcash-oldybcash
	.e  d
	..s newpay=$p(^DHCINVPRTZY(zcrowid),"^",6)  ;
    ..s chpay=newpay-oldpay
	.s str=papname_"^"_zyno_"^"_papno_"^"_depart_"^"_ward_"^"_$j(oldpay,3,2)_"^"_$j(newpay,3,2)_"^"_$j(chpay,3,2)_"^"_username
	.s chnum=chnum+1
	.s ^TMP("ZYJF","CHDETAIL",job,chnum)=str
	q
}

ClassMethod gethcdetail2(prtrowid)
{
    ;yyx2007-03-28
    ;取某段时间内的冲红的明细
    ;姓名，住院号，登记号，病房，上次结算金额，本次结算金额，冲账金额，操作员
	s zcrowid="",newpay=0
    s prtoldid=$p(^DHCINVPRTZY(prtrowid),"^",13)
    q:(prtoldid="")
    q:($d(^DHCINVPRTZY(prtoldid))=0)
    s newpay=$p(^DHCINVPRTZY(prtoldid),"^",6)
    s chpay=newpay-oldpay 
    s str=papname_"^"_zyno_"^"_papno_"^"_depart_"^"_ward_"^"_$j(oldpay,3,2)_"^"_$j(newpay,3,2)_"^"_$j(chpay,3,2)_"^"_username
    s chnum=chnum+1
    s ^TMP("ZYJF","CHDETAIL",job,chnum)=str
    q
}

ClassMethod gethcdetail1(prtrowid)
{
    ;yyx2007-03-28
    ;取某段时间内的冲红的明细
    ;姓名，住院号，登记号，病房，上次结算金额，本次结算金额，冲账金额，操作员
	s zcrowid="",newpay=0
    f  s zcrowid=$o(^DHCINVPRTZY(0,"InitInv",prtrowid,zcrowid)) q:zcrowid=""  d
	.s status=$p(^DHCINVPRTZY(zcrowid),"^",8)
	.q:status="A"
	.s newpay=$p(^DHCINVPRTZY(zcrowid),"^",6)  ;
    .s chpay=newpay-oldpay
	.s str=papname_"^"_zyno_"^"_papno_"^"_depart_"^"_ward_"^"_$j(oldpay,3,2)_"^"_$j(newpay,3,2)_"^"_$j(chpay,3,2)_"^"_username
	.s chnum=chnum+1
	.s ^TMP("ZYJF","CHDETAIL",$j,chnum)=str
	
	q
}

ClassMethod PrintHcNum(job)
{
   s allnum=$o(^TMP("ZYJF","CHDETAIL",job,""),-1) 
   q allnum
}

ClassMethod PrintHcDetail(job, num)
{
   s prtstr=^TMP("ZYJF","CHDETAIL",job,num)
    q prtstr
}

}
