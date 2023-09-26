Import SQLUser

Class web.UDHCJFDayRptHF Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod NotHandinInfo()
{
	Set repid=$I(^CacheTemp)
    k ^TMP("ZYJFCWPrint","YJ",$j)
    k ^TMP("ZYJFCWPrint","FP",$j)
    s ind=1
    s num=1,yjnum=1,fpnum=1
    s hzxjsum=0,hzzpsum=0,hzcash=0,hzcheque=0,hzxyk=0,hzacount=0
    s hztyjsum=0,hzyb=0,hzyssum=0,hzxj=0,hzzp=0,hzfee=0,hzsyj=0
    s hztyj=0,hzys=0,hzjsfee=0,hzsdeposit=0,hztdeposit=0,hzxianjin=0
    s hzzhipiao=0,hzxyksum=0,hzhpsum=0
    s xinyk=0,hzxinyk=0
    s gfjz=0,sldjz=0,hp=0,hzhp=0
	s hzhuipiao=0,hzgfjz=0,hzsldjz=0,hzyb=0  ;汇总公费记账，市领导，医保
	s hzpayorsum=0
	s yklysum=0,ykly=0,qtsum=0,qt=0,yjyklysum=0,yjqtsum=0,fpyklysum=0,fpqtsum=0
	s fpyklysum=0,fpqtsum=0,fpykly=0,fpqt=0
	s jiesflag="",jiesdate="",jiestime="",jiesusname=""
	s ssnum=##class(web.UDHCJFDayRpt).FindUser("I","3")
	i ssnum=0  Set qHandle=$lb(0,repid,0) Quit $$$OK
	f i=1:1:ssnum  d
	.s userid=SSPLIST(i)
	.q:(skuserid'="")&(skuserid'=userid)
	.s username=""
	.i userid'="" s username=$p(^SSU("SSUSR",userid),"^",2)
	.;w !,"username "_username_" ^ "
	.s xjsum=0,zpsum=0,cash=0,cheque=0,xyk=0,acount=0,tyjsum=0,hpsum=0
	.s xyksum=0
	.s yssum=0,xj=0,zp=0,fee=0,syj=0,tyj=0,yb=0,sldjz=0,gfjz=0,hp=0
	.s payorsum=0,yb=0,yjykly=0,yjqt=0,fpykly=0,fpqt=0
	.s yjrow=0,fprow=0
	.s jiesflag="",jiesdate="",jiestime="",jiesusname=""
	.s datestr=##class(web.UDHCJFDayRpt).getwjdate("","")
	.i $f(datestr,"^")'=0  d
	..s stdate=$p(datestr,"^",1)
	..i stdate'=""  d
	...s stdate=$zdh(stdate,4)
	..e  d
	...s stdate=+$h
	.e  d
	..s stdate=+$h
	.s enddate=+$h
	.f prtdate=stdate:1:enddate d
	..s prtrowid="0"
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  d 
	...s jkdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",30)
	...q:jkdr'=""
	...s jkflag=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",23),$c(1))
	...s jkflag=$g(jkflag)
	...q:(jkflag="Y")
	...s adduser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
	...q:adduser'=userid
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...q:(prtstatus="2")
	...s payamount=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
	...s payamount=$p(payamount,$c(1))
	...s arrcptid=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",5),$c(1))
	...s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",1)
	...q:(arrcptid="")
	...q:($d(^ARRCP(arrcptid))=0)
	...i ((paydesc="现金")!(paydesc="Cash")) d 
	....s xjsum=xjsum+payamount
	....s hzxjsum=hzxjsum+payamount
	...e  i paydesc="支票" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="倒存支票" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="Cheque" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="汇票" d 
	....s hpsum=hpsum+payamount
	....s hzhpsum=hzhpsum+payamount
	...e  i paydesc="汇款" d 
	....s hpsum=hpsum+payamount
	....s hzhpsum=hzhpsum+payamount
	...e  i paydesc="信用卡" d
	....s xyksum=xyksum+payamount
	....s hzxyksum=hzxyksum+payamount
	...e  i paydesc="银行卡" d
	....s xyksum=xyksum+payamount
	....s hzxyksum=hzxyksum+payamount
	...e  i paydesc["留用"  d
	....s yjykly=yjykly+payamount
	....s yjyklysum=yjyklysum+payamount
	...e  d
	....s yjqt=yjqt+payamount
	....s yjqtsum=yjqtsum+payamount
	...s yjrow=yjrow+1
	...i prtstatus'="2"  d
	....s ^TMP("ZYJFCWPrint","YJ",$j,Guser,yjnum)=paymode_"^"_prtstatus_"^"_payamount_"^"_rcptno_"^"_prtrowid
	....s yjnum=yjnum+1
	..s invrowid="0"   ;取发票信息
	..f  s invrowid=$o(^DHCINVPRTZY(0,"DATE",prtdate,invrowid)) q:invrowid=""  d
	...s jkdr=$p(^DHCINVPRTZY(invrowid),"^",23)
	...s invno=$p(^DHCINVPRTZY(invrowid),"^",1)
	...q:jkdr'=""
	...s adduser=$p(^DHCINVPRTZY(invrowid),"^",7)
	...q:adduser'=userid
	...s prtstatus=$p(^DHCINVPRTZY(invrowid),"^",8)
	...q:prtstatus="A"
	...s pbrowid=$p(^DHCINVPRTZY(invrowid),"^",5)
	...s payorshare=0
	...i pbrowid'=""  d
	....s payorshare=$p(^DHCPB(pbrowid),"^",11)
	...s payorsum=payorsum+payorshare
	...s hzpayorsum=hzpayorsum+payorshare
	...s patfee=$p(^DHCINVPRTZY(invrowid),"^",6)
	...s acount=acount+patfee
	...s hzacount=hzacount+patfee
	...s patdeposit=$p(^DHCINVPRTZY(invrowid),"^",22)
	...s tyjsum=tyjsum+patdeposit
	...s hztyjsum=hztyjsum+patdeposit
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
	.......i paydesc="信用卡" s xyk=xyk+m2,hzxyk=hzxyk+m2
	.......i paydesc="银行卡" s xyk=xyk+m2,hzxyk=hzxyk+m2
	.......e  i paydesc="支票" s cheque=cheque+m2,hzcheque=hzcheque+m2
	.......e  i paydesc="倒存支票" s cheque=cheque+m2,hzcheque=hzcheque+m2  
	.......e  i paydesc="Cheque" s cheque=cheque+m2 
	.......e  i paydesc="现金" s cash=cash+m2,hzcash=hzcash+m2   ;mode=3(支付方式为支票),否则为现金方式
	.......e  i paydesc="Cash" s cash=cash+m2,hzcash=hzcash+m2
	.......e  i paydesc="汇票" s hp=hp+m2,hzhp=hzhp+m2    ;其他
	.......e  i paydesc="汇款" s hp=hp+m2,hzhp=hzhp+m2    ;其他
	.......e  i paydesc="公费记帐" s gfjz=gfjz+m2
	.......e  i paydesc="市领导记帐" s sldjz=sldjz+m2
	.......e  i paydesc["医保" s yb=yb+m2	    
	.......e  i paydesc["留用" s fpykly=fpykly+m2,fpyklysum=fpyklysum+m2
	.......e  s fpqt=fpqt+m2 ,fpqtsum=fpqtsum+m2
	.......s fpnum=fpnum+1
	...s ybstr=""
	...s ybstr=##class(web.UDHCJFDayRpt).getybinfo(invrowid, billno, prtstatus)
	...s ybbill=0
	...s ybbill=$p(ybstr,"^",2)
	...s yb=yb+ybbill
	...s fprow=fprow+1
	.s xj=xj+xjsum+cash
	.s hzxj=hzxj+xjsum+cash
	.s zp=zp+zpsum+cheque
	.s hzzp=hzzp+zpsum+cheque
	.s fee=fee+acount
	.s hzfee=hzfee+acount
	.s syj=syj+xjsum+zpsum
	.s hzsyj=hzsyj+xjsum+zpsum+hpsum
	.s tyj=tyj+tyjsum
	.s hztyj=hztyj+tyjsum
	.s jsdate=""
	.s ys=$j((xjsum+cash+zpsum+cheque+hp+hpsum+xyksum+xyk+yjykly+yjqt+fpykly+fpqt),3,2)
	.s hzys=$j((hzxjsum+hzcash+hzzpsum+hzcheque+hzhpsum+hzxyksum+hzxyk+hzhp+yjyklysum+yjqtsum+fpyklysum+fpqtsum),3,2)
	.s xianjin=$j((xjsum+cash),3,2)
	.s hzxianjin=$j((hzxjsum+hzcash),3,2)
	.s zhipiao=$j((zpsum+cheque),3,2)
	.s hzzhipiao=$j((hzzpsum+hzcheque),3,2)
	.s xinyk=$j((xyksum+xyk),3,2)
	.s hzxinyk=$j((hzxyksum+hzxyk),3,2)
	.s huipiao=$j((hpsum+hp),3,2)
	.s hzhuipiao=$j((hzhpsum+hzhp),3,2)
	.s gfjz=$j(gfjz,3,2)
	.s hzgfjz=$j((hzgfjz+gfjz),3,2)
	.s sldjz=$j(sldjz,3,2)
	.s hzsldjz=$j((hzsldjz+sldjz),3,2)
	.s yb=$j(yb,3,2)
	.s hzyb=$j((hzyb+yb),3,2)
	.s jsfee=$j(acount,3,2)  //-$j(gfjz,3,2)-$j(sldjz,3,2)
	.s hzjsfee=$j(hzacount,3,2) //-$j(gfjz,3,2)-$j(sldjz,3,2)
	.s payorsum=$j(payorsum,3,2)
	.s hzpayorsum=$j(hzpayorsum,3,2)
	.s sdeposit=$j((xjsum+zpsum+xyksum+hpsum+yjykly+yjqt),3,2)
	.s hzsdeposit=$j((hzxjsum+hzzpsum+hzxyksum+hzhpsum+yjyklysum+yjqtsum),3,2)
	.s tdeposit=$j(tyjsum,3,2)
	.s hztdeposit=$j(hztyjsum,3,2)
	.s tp="0.00"
	.s hztp="0.00"
	.s ykly=yjykly+fpykly
	.s qt=yjqt+fpqt
	.s yklysum=yjyklysum+fpyklysum
	.s qtsum=yjqtsum+fpqtsum
	.;q:(jsfee="0.00")&(sdeposit="0.00")&(tdeposit="0.00")
	.;w !,username_" , "_sdeposit
	.q:((yjrow=0)&(fprow=0))
	.s select=0
	.Do OutputRow6	  
	s jsdate="合计",username="",ys=$j(hzys,3,2),xianjin=$j(hzxianjin,3,2),zhipiao=$j(hzzhipiao,3,2),huipiao=$j(hzhuipiao,3,2),jsfee=$j(hzjsfee,3,2),sdeposit=$j(hzsdeposit,3,2),tdeposit=$j(hztdeposit,3,2),tp="0.00",jkdr="",gfjz=$j(hzgfjz,3,2),sldjz=$j(hzsldjz,3,2),yb=$j(hzyb,3,2),userid=""
	s xinyk=$j(hzxinyk,3,2),payorsum=$j(hzpayorsum,3,2),ykly=$j(yklysum,3,2),qt=$j(qtsum,3,2) 
	s jiesflag="",jiesdate="",jiestime="",jiesusname="",select=0
	Do OutputRow6
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow6
	set Data=$lb(jsdate,username,ys,xianjin,zhipiao,jsfee,sdeposit,tdeposit,tp,"0",huipiao,gfjz,sldjz,yb,userid,xinyk,payorsum,jiesflag,jiesdate,jiestime,jiesusname,$j,$j(ykly,3,2),$j(qt,3,2),select)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod HandinInfo()
{
	Set repid=$I(^CacheTemp)
    k ^TMP("ZYJFCWPrint","YJ",$j)
    k ^TMP("ZYJFCWPrint","FP",$j)
    s ind=1
    s num=1,yjnum=1,fpnum=1
    s hzxjsum=0,hzzpsum=0,hzcash=0,hzcheque=0,hzxyk=0,hzacount=0
    s hztyjsum=0,hzyb=0,hzyssum=0,hzxj=0,hzzp=0,hzfee=0,hzsyj=0
    s hztyj=0,hzys=0,hzjsfee=0,hzsdeposit=0,hztdeposit=0,hzxianjin=0
    s hzzhipiao=0,hzhpsum=0,hzxyksum=0,yjyklysum=0,yjqtsum=0
    s xinyk=0,hzxinyk=0
    s hzpayorsum=0
	s gfjz=0,sldjz=0,hp=0,hzhp=0,yjykly=0,yjqt=0
	s hzhuipiao=0,hzgfjz=0,hzsldjz=0,hzyb=0  ;汇总公费记账，市领导，医保
	s yklysum=0,ykly=0,qtsum=0,qt=0,yjyklysum=0,yjqtsum=0,fpyklysum=0,fpqtsum=0
	s fpyklysum=0,fpqtsum=0,fpykly=0,fpqt=0
	s jiesflag="",jiesdate="",jiestime="",jiesusname=""
	f jkdate=stdate:1:enddate d
	.s jkdr=""
	.f  s jkdr=$o(^DHCJFUSERJK(0,"date",jkdate,jkdr)) q:jkdr=""  d
	..q:(ReportNo'="")&(ReportNo'=jkdr)
	..s xjsum=0,zpsum=0,cash=0,cheque=0,xyk=0,acount=0,tyjsum=0,hpsum=0
	..s yssum=0,xj=0,zp=0,fee=0,syj=0,tyj=0,yb=0,sldjz=0,gfjz=0,xyksum=0
	..s payorsum=0,yb=0,yjykly=0,yjqt=0,fpykly=0,fpqt=0
	..s jiesflag="",jiesdate="",jiestime="",jiesusname=""
	..s userid=$p(^DHCJFUSERJK(jkdr),"^",5)
	..s username=""
	..i userid'="" s username=$p(^SSU("SSUSR",userid),"^",2)
	..s jiesflag=$p(^DHCJFUSERJK(jkdr),"^",6)
	..s jieuser=$p(^DHCJFUSERJK(jkdr),"^",6)
	..i jiesflag=""  s jiesflag="N"
	..q:(jiesflag="Y")
	..q:(skuserid'="")&(skuserid'=userid)
	..s jiesflag="未接收"
	..s jkdate1=$p(^DHCJFUSERJK(jkdr),"^",1)
	..s prtrowid="0"
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,prtrowid)) q:prtrowid=""  d 
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...q:(prtstatus="2")
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",1)
	...i ((paydesc="现金")!(paydesc="Cash")) d 
	....s xjsum=xjsum+payamount
	....s hzxjsum=hzxjsum+payamount
	...e  i paydesc="支票" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="倒存支票" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="Cheque" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="汇票" d 
	....s hpsum=hpsum+payamount
	....s hzhpsum=hzhpsum+payamount
	...e  i paydesc="汇款" d 
	....s hpsum=hpsum+payamount
	....s hzhpsum=hzhpsum+payamount
	...e  i paydesc="信用卡" d
	....s xyksum=xyksum+payamount
	....s hzxyksum=hzxyksum+payamount
	...e  i paydesc="银行卡" d
	....s xyksum=xyksum+payamount
	....s hzxyksum=hzxyksum+payamount
	...e  i paydesc["留用"  d
	....s yjykly=yjykly+payamount
	....s yjyklysum=yjyklysum+payamount
	...e  d
	....s yjqt=yjqt+payamount
	....s yjqtsum=yjqtsum+payamount
	...s ^TMP("ZYJFCWPrint","YJ",$j,Guser,yjnum)=paymode_"^"_prtstatus_"^"_payamount_"^"_rcptno_"^"_prtrowid
	...s yjnum=yjnum+1
	..s invrowid="0"   ;取发票信息
	..f  s invrowid=$o(^DHCINVPRTZY(0,"JK",jkdr,invrowid)) q:invrowid=""  d
	...q:($d(^DHCINVPRTZY(invrowid))=0)
	...s prtstatus=$p(^DHCINVPRTZY(invrowid),"^",8)
	...q:prtstatus="A"
	...s invno=$p(^DHCINVPRTZY(invrowid),"^",1)
	...s pbrowid=$p(^DHCINVPRTZY(invrowid),"^",5)
	...s payorshare=0
	...i pbrowid'=""  d
	....s payorshare=$p(^DHCPB(pbrowid),"^",11)
	...s payorsum=payorsum+payorshare
	...s hzpayorsum=hzpayorsum+payorshare
	...s patfee=$p(^DHCINVPRTZY(invrowid),"^",6)
	...s acount=acount+patfee
	...s hzacount=hzacount+patfee
	...s patdeposit=$p(^DHCINVPRTZY(invrowid),"^",22)
	...s tyjsum=tyjsum+patdeposit
	...s hztyjsum=hztyjsum+patdeposit
	...s billno=$p(^DHCINVPRTZY(invrowid),"^",5)
	...s arrcp=""
	...f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	....s arral="" 
	....s rcptnum=$p(^ARRCP(arrcp),"^",2)
	....f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	.....s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	.....;i type,billnum=billno,m1'=0,rcpt'="" s rcpt=rcpt_","_rcptnum
	.....;i type,billnum=billno,m1'=0,rcpt="" s rcpt=rcptnum 
	.....i type="" d
	......s paym="0"
	......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	.......s ss=^ARRCP(arrcp,"PAYM",paym)
	.......s mode=$p(ss,"^",1)
	.......i mode="" s mode="1"
	.......s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
	.......i paydesc="信用卡" s xyk=xyk+m2,hzxyk=hzxyk+m2
	.......i paydesc="银行卡" s xyk=xyk+m2,hzxyk=hzxyk+m2
	.......e  i paydesc="支票" s cheque=cheque+m2,hzcheque=hzcheque+m2
	.......e  i paydesc="倒存支票" s cheque=cheque+m2,hzcheque=hzcheque+m2  
	.......e  i paydesc="Cheque" s cheque=cheque+m2 
	.......e  i paydesc="现金" s cash=cash+m2,hzcash=hzcash+m2   ;mode=3(支付方式为支票),否则为现金方式
	.......e  i paydesc="Cash" s cash=cash+m2,hzcash=hzcash+m2
	.......e  i paydesc="汇票" s hp=hp+m2,hzhp=hzhp+m2    ;其他
	.......e  i paydesc="汇款" s hp=hp+m2,hzhp=hzhp+m2    ;其他
	.......e  i paydesc="公费记帐" s gfjz=gfjz+m2
	.......e  i paydesc="市领导记帐" s sldjz=sldjz+m2
	.......;ZMGZT
	.......e  i paydesc["医保" s yb=yb+m2
	.......e  i paydesc["留用" s fpykly=fpykly+m2,fpyklysum=fpyklysum+m2
	.......e  s fpqt=fpqt+m2 ,fpqtsum=fpqtsum+m2
	.......s ^TMP("ZYJFCWPrint","FP",$j,Guser,fpnum)=mode_"^"_prtstatus_"^"_m2_"^"_invno_"^"_invrowid
	.......s fpnum=fpnum+1    
	...s ybstr=""
	...s ybstr=##class(web.UDHCJFDayRpt).getybinfo(invrowid, billno, prtstatus)
	...s ybbill=0
	...s ybbill=$p(ybstr,"^",2)
	...s yb=yb+ybbill
	..s xj=xj+xjsum+cash
	..s hzxj=hzxj+xjsum+cash
	..s zp=zp+zpsum+cheque
	..s hzzp=hzzp+zpsum+cheque
	..s fee=fee+acount
	..s hzfee=hzfee+acount
	..s syj=syj+xjsum+zpsum
	..s hzsyj=hzsyj+xjsum+zpsum+hpsum
	..s tyj=tyj+tyjsum
	..s hztyj=hztyj+tyjsum
	..s jsdate=jkdate
	..s jsdate=$zd(jsdate,3)
	..s ys=$j((xjsum+cash+zpsum+cheque+hp+hpsum+xyksum+xyk+yjykly+yjqt+fpykly+fpqt),3,2)
	..s hzys=$j((hzxjsum+hzcash+hzzpsum+hzcheque+hzhpsum+hzxyksum+hzxyk+hzhp+yjyklysum+yjqtsum+fpyklysum+fpqtsum),3,2)
	..s xianjin=$j((xjsum+cash),3,2)
	..s hzxianjin=$j((hzxjsum+hzcash),3,2)
	..s zhipiao=$j((zpsum+cheque),3,2)
	..s hzzhipiao=$j((hzzpsum+hzcheque),3,2)
	..s huipiao=$j((hpsum+hp),3,2)
	..s hzhuipiao=$j((hzhpsum+hzhp),3,2)
	..s xinyk=$j((xyksum+xyk),3,2)
	..s hzxinyk=$j((hzxyksum+hzxyk),3,2)
	..s payorsum=$j(payorsum,3,2)
	..s hzpayorsum=$j(hzpayorsum,3,2)
	..s gfjz=$j(gfjz,3,2)
	..s hzgfjz=$j((hzgfjz+gfjz),3,2)
	..s sldjz=$j(sldjz,3,2)
	..s hzsldjz=$j((hzsldjz+sldjz),3,2)
	..s yb=$j(yb,3,2)
	..s hzyb=$j((hzyb+yb),3,2)
	..s jsfee=$j(acount,3,2)  //-$j(gfjz,3,2)-$j(sldjz,3,2)
	..s hzjsfee=$j(hzacount,3,2) //-$j(gfjz,3,2)-$j(sldjz,3,2)
	..s sdeposit=$j((xjsum+zpsum+xyksum+hpsum+yjykly+yjqt),3,2)
	..s hzsdeposit=$j((hzxjsum+hzzpsum+hzxyksum+hzhpsum+yjyklysum+yjqtsum),3,2)
	..s tdeposit=$j(tyjsum,3,2)
	..s hztdeposit=$j(hztyjsum,3,2)
	..s tp="0.00"
	..s hztp="0.00"
	..s ykly=yjykly+fpykly
	..s qt=yjqt+fpqt
	..s yklysum=yjyklysum+fpyklysum
	..s qtsum=yjqtsum+fpqtsum
	..s select=0
	..Do OutputRow3	  
	s jsdate="合计",username="",ys=$j(hzys,3,2),xianjin=$j(hzxianjin,3,2),zhipiao=$j(hzzhipiao,3,2),huipiao=$j(hzhuipiao,3,2),jsfee=$j(hzjsfee,3,2),sdeposit=$j(hzsdeposit,3,2),tdeposit=$j(hztdeposit,3,2),tp="0.00",jkdr="",gfjz=$j(hzgfjz,3,2),sldjz=$j(hzsldjz,3,2),yb=$j(hzyb,3,2),userid=""
	s xinyk=$j(hzxinyk,3,2),payorsum=$j(hzpayorsum,3,2),ykly=$j(yklysum,3,2),qt=$j(qtsum,3,2)
	s jiesflag="",jiesdate="",jiestime="",jiesusname="",select=0
	;;s ^TMP("ZYJF",$j,num)="合计"_"^"_""_"^"_$j(yssum,3,2)_"^"_$j(xj,3,2)_"^"_$j(zp,3,2)_"^"_$j(fee,3,2)_"^"_$j(syj,3,2)_"^"_$j(tyj,3,2)_"^"_""_"^"_""
    Do OutputRow3
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow3
	set Data=$lb(jsdate,username,ys,xianjin,zhipiao,jsfee,sdeposit,tdeposit,tp,jkdr,huipiao,gfjz,sldjz,yb,userid,xinyk,payorsum,jiesflag,jiesdate,jiestime,jiesusname,$j,$j(ykly,3,2),$j(qt,3,2),select)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod jieHandinInfo()
{
	Set repid=$I(^CacheTemp)
    k ^TMP("ZYJFCWPrint","YJ",$j)
    k ^TMP("ZYJFCWPrint","FP",$j)
    s ind=1
    s num=1,yjnum=1,fpnum=1
    s hzxjsum=0,hzzpsum=0,hzcash=0,hzcheque=0,hzxyk=0,hzacount=0
    s hztyjsum=0,hzyb=0,hzyssum=0,hzxj=0,hzzp=0,hzfee=0,hzsyj=0
    s hztyj=0,hzys=0,hzjsfee=0,hzsdeposit=0,hztdeposit=0,hzxianjin=0
    s hzzhipiao=0,hzhpsum=0,hzxyksum=0
    s xinyk=0,hzxinyk=0
    s hzpayorsum=0
	s gfjz=0,sldjz=0,hp=0,hzhp=0
	s hzhuipiao=0,hzgfjz=0,hzsldjz=0,hzyb=0  ;汇总公费记账，市领导，医保
	s yklysum=0,ykly=0,qtsum=0,qt=0,yjyklysum=0,yjqtsum=0,fpyklysum=0,fpqtsum=0
	s fpyklysum=0,fpqtsum=0,fpykly=0,fpqt=0
	s jiesflag="",jiesdate="",jiestime="",jiesusname=""
	f jkdate=stdate:1:enddate d
	.s jkdr=""
	.f  s jkdr=$o(^DHCJFUSERJK(0,"inceptdate",jkdate,jkdr)) q:jkdr=""  d
	..s xjsum=0,zpsum=0,cash=0,cheque=0,xyk=0,acount=0,tyjsum=0,hpsum=0
	..s yssum=0,xj=0,zp=0,fee=0,syj=0,tyj=0,yb=0,sldjz=0,gfjz=0,xyksum=0
	..s payorsum=0,yb=0,yjykly=0,yjqt=0,fpykly=0,fpqt=0
	..q:(ReportNo'="")&(ReportNo'=jkdr)
	..s jiesflag="",jiesdate="",jiestime="",jiesusname=""
	..s userid=$p(^DHCJFUSERJK(jkdr),"^",5)
	..s username=""
	..i userid'="" s username=$p(^SSU("SSUSR",userid),"^",2)
	..s jiesflag=$p(^DHCJFUSERJK(jkdr),"^",6)
	..s jieuser=$p(^DHCJFUSERJK(jkdr),"^",9)
	..i jiesflag=""  s jiesflag="N"
	..q:(skuserid'="")&(skuserid'=userid)
	..q:(jieuser'=Guser)
	..s jiesdate=$p(^DHCJFUSERJK(jkdr),"^",7)
	..i jiesdate'=""  s jiesdate=$zd(jiesdate,3)
	..s jiestime=$p(^DHCJFUSERJK(jkdr),"^",8)
	..i jiestime'=""  s jiestime=$zt(jiestime,1)
	..s jiesusname=$p(^SSU("SSUSR",jieuser),"^",2)
	..i jiesflag="Y"  d
	...s jiesflag="已接收"
	..e  d
	...s jiesflag="未接收"
	..s jkdate1=$p(^DHCJFUSERJK(jkdr),"^",1)
	..s prtrowid="0"
	..f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,prtrowid)) q:prtrowid=""  d 
	...;w !,prtrowid
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(prtrowid),"^",8)
	...s prtstatus=$p(prtstatus,$c(1))
	...q:(prtstatus="2")
	...s payamount=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
	...s payamount=$p(payamount,$c(1))
	...s rcptno=$p(^DHCSFPRINTDETAIL(prtrowid),"^",1)
	...i ((paydesc="现金")!(paydesc="Cash")) d 
	....s xjsum=xjsum+payamount
	....s hzxjsum=hzxjsum+payamount
	...e  i paydesc="支票" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="倒存支票" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="Cheque" d 
	....s zpsum=zpsum+payamount
	....s hzzpsum=hzzpsum+payamount
	...e  i paydesc="汇票" d 
	....s hpsum=hpsum+payamount
	....s hzhpsum=hzhpsum+payamount
	...e  i paydesc="汇款" d 
	....s hpsum=hpsum+payamount
	....s hzhpsum=hzhpsum+payamount
	...e  i paydesc="信用卡" d
	....s xyksum=xyksum+payamount
	....s hzxyksum=hzxyksum+payamount
	...e  i paydesc="银行卡" d
	....s xyksum=xyksum+payamount
	....s hzxyksum=hzxyksum+payamount
	...e  i paydesc["留用"  d
	....s yjykly=yjykly+payamount
	....s yjyklysum=yjyklysum+payamount
	...e  d
	....s yjqt=yjqt+payamount
	....s yjqtsum=yjqtsum+payamount
	...s ^TMP("ZYJFCWPrint","YJ",$j,Guser,yjnum)=paymode_"^"_prtstatus_"^"_payamount_"^"_rcptno_"^"_prtrowid
	...s yjnum=yjnum+1
	..s invrowid="0"   ;取发票信息
	..f  s invrowid=$o(^DHCINVPRTZY(0,"JK",jkdr,invrowid)) q:invrowid=""  d
	...s prtstatus=$p(^DHCINVPRTZY(invrowid),"^",8)
	...s invno=$p(^DHCINVPRTZY(invrowid),"^",1)
	...q:prtstatus="A"
	...s pbrowid=$p(^DHCINVPRTZY(invrowid),"^",5)
	...s payorshare=0
	...i pbrowid'=""  d
	...s payorshare=$p(^DHCPB(pbrowid),"^",11)
	...s payorsum=payorsum+payorshare
	...s hzpayorsum=hzpayorsum+payorshare
	...s patfee=$p(^DHCINVPRTZY(invrowid),"^",6)
	...s acount=acount+patfee
	...s hzacount=hzacount+patfee
	...s patdeposit=$p(^DHCINVPRTZY(invrowid),"^",22)
	...s tyjsum=tyjsum+patdeposit
	...s hztyjsum=hztyjsum+patdeposit
	...s billno=$p(^DHCINVPRTZY(invrowid),"^",5)
	...s arrcp=""
	...f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	....s arral="" 
	....s rcptnum=$p(^ARRCP(arrcp),"^",2)
	....f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	.....s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	.....;i type,billnum=billno,m1'=0,rcpt'="" s rcpt=rcpt_","_rcptnum
	.....;i type,billnum=billno,m1'=0,rcpt="" s rcpt=rcptnum 
	.....i type="" d
	......s paym="0"
	......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	.......s ss=^ARRCP(arrcp,"PAYM",paym)
	.......s mode=$p(ss,"^",1)
	.......i mode="" s mode="2"
	.......s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
	.......i paydesc="信用卡" s xyk=xyk+m2,hzxyk=hzxyk+m2
	.......i paydesc="银行卡" s xyk=xyk+m2,hzxyk=hzxyk+m2
	.......e  i paydesc="支票" s cheque=cheque+m2,hzcheque=hzcheque+m2
	.......e  i paydesc="倒存支票" s cheque=cheque+m2,hzcheque=hzcheque+m2  
	.......e  i paydesc="Cheque" s cheque=cheque+m2 
	.......e  i paydesc="现金" s cash=cash+m2,hzcash=hzcash+m2   ;mode=3(支付方式为支票),否则为现金方式
	.......e  i paydesc="Cash" s cash=cash+m2,hzcash=hzcash+m2
	.......e  i paydesc="汇票" s hp=hp+m2,hzhp=hzhp+m2    ;其他
	.......e  i paydesc="汇款" s hp=hp+m2,hzhp=hzhp+m2    ;其他
	.......e  i paydesc="公费记帐" s gfjz=gfjz+m2
	.......e  i paydesc="市领导记帐" s sldjz=sldjz+m2
	.......;ZMGZT
	.......e  i paydesc["医保" s yb=yb+m2    
	.......e  i paydesc["留用" s fpykly=fpykly+m2,fpyklysum=fpyklysum+m2
	.......e  s fpqt=fpqt+m2 ,fpqtsum=fpqtsum+m2
	.......s ^TMP("ZYJFCWPrint","FP",$j,Guser,fpnum)=mode_"^"_prtstatus_"^"_m2_"^"_invno_"^"_invrowid
	.......s fpnum=fpnum+1
	...s ybstr=""
	...s ybstr=##class(web.UDHCJFDayRpt).getybinfo(invrowid, billno, prtstatus)
	...s ybbill=0
	...s ybbill=$p(ybstr,"^",2)
	...s yb=yb+ybbill
	..s xj=xj+xjsum+cash
	..s hzxj=hzxj+xjsum+cash
	..s zp=zp+zpsum+cheque
	..s hzzp=hzzp+zpsum+cheque
	..s fee=fee+acount
	..s hzfee=hzfee+acount
	..s syj=syj+xjsum+zpsum
	..s hzsyj=hzsyj+xjsum+zpsum+hpsum
	..s tyj=tyj+tyjsum
	..s hztyj=hztyj+tyjsum
	..s jsdate=jkdate1
	..s jsdate=$zd(jsdate,3)
	..s ys=$j((xjsum+cash+zpsum+cheque+hp+hpsum+xyksum+xyk+yjykly+yjqt+fpykly+fpqt),3,2)
	..s hzys=$j((hzxjsum+hzcash+hzzpsum+hzcheque+hzhpsum+hzxyksum+hzxyk+hzhp+yjyklysum+yjqtsum+fpyklysum+fpqtsum),3,2)
	..s xianjin=$j((xjsum+cash),3,2)
	..s hzxianjin=$j((hzxjsum+hzcash),3,2)
	..s zhipiao=$j((zpsum+cheque),3,2)
	..s hzzhipiao=$j((hzzpsum+hzcheque),3,2)
	..s huipiao=$j((hpsum+hp),3,2)
	..s hzhuipiao=$j((hzhpsum+hzhp),3,2)
	..s xinyk=$j((xyksum+xyk),3,2)
	..s hzxinyk=$j((hzxyksum+hzxyk),3,2)
	..s payorsum=$j(payorsum,3,2)
	..s hzpayorsum=$j(hzpayorsum,3,2)
	..s gfjz=$j(gfjz,3,2)
	..s hzgfjz=$j((hzgfjz+gfjz),3,2)
	..s sldjz=$j(sldjz,3,2)
	..s hzsldjz=$j((hzsldjz+sldjz),3,2)
	..s yb=$j(yb,3,2)
	..s hzyb=$j((hzyb+yb),3,2)
	..s jsfee=$j(acount,3,2)  //-$j(gfjz,3,2)-$j(sldjz,3,2)
	..s hzjsfee=$j(hzacount,3,2) //-$j(gfjz,3,2)-$j(sldjz,3,2)
	..s sdeposit=$j((xjsum+zpsum+xyksum+hpsum+yjykly+yjqt),3,2)
	..s hzsdeposit=$j((hzxjsum+hzzpsum+hzxyksum+hzhpsum+yjyklysum+yjqtsum),3,2)
	..s tdeposit=$j(tyjsum,3,2)
	..s hztdeposit=$j(hztyjsum,3,2)
	..s tp="0.00"
	..s hztp="0.00"
	..s ykly=yjykly+fpykly
	..s qt=yjqt+fpqt
	..s yklysum=yjyklysum+fpyklysum
	..s qtsum=yjqtsum+fpqtsum
	..s select=0
	..Do OutputRow	  
	s jsdate="合计",username="",ys=$j(hzys,3,2),xianjin=$j(hzxianjin,3,2),zhipiao=$j(hzzhipiao,3,2),huipiao=$j(hzhuipiao,3,2),jsfee=$j(hzjsfee,3,2),sdeposit=$j(hzsdeposit,3,2),tdeposit=$j(hztdeposit,3,2),tp="0.00",jkdr="",gfjz=$j(hzgfjz,3,2),sldjz=$j(hzsldjz,3,2),yb=$j(hzyb,3,2),userid=""
	s xinyk=$j(hzxinyk,3,2),payorsum=$j(hzpayorsum,3,2),ykly=$j(yklysum,3,2),qt=$j(qtsum,3,2)
	s jiesflag="",jiesdate="",jiestime="",jiesusname="",select=""
	;s ^TMP("ZYJF",$j,num)="合计"_"^"_""_"^"_$j(yssum,3,2)_"^"_$j(xj,3,2)_"^"_$j(zp,3,2)_"^"_$j(fee,3,2)_"^"_$j(syj,3,2)_"^"_$j(tyj,3,2)_"^"_""_"^"_""
    Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	set Data=$lb(jsdate,username,ys,xianjin,zhipiao,jsfee,sdeposit,tdeposit,tp,jkdr,huipiao,gfjz,sldjz,yb,userid,xinyk,payorsum,jiesflag,jiesdate,jiestime,jiesusname,$j,$j(ykly,3,2),$j(qt,3,2),select)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod inceptdave(itmjs As %Library.String = "", itmjsex As %Library.String = "", str, guser)
{
 s str=$g(str)
 s guser=$g(guser)
 q:(str="") "1"
 q:(guser="") "2"
 s jiesdate=+$h
 s jiestime=$p($h,",",2)
 s jiesflag="Y"
 s jkdr=""
 s retcode=0
 TSTART
 i $f(str,"^")'=0  d
 .s num=$l(str,"^")
 .f i=2:1:num  d
 ..s jkdr=$p(str,"^",i)
 ..i jkdr'=""  d
 ...s jkdr=$p(jkdr,$c(1))
 ...&sql(update DHC_JFUSERJK 
         set JK_inceptuser=:guser,
             JK_inceptdate=:jiesdate,
             JK_incepttime=:jiestime,
             JK_inceptflag=:jiesflag
         where JK_rowid=:jkdr)
 ...s retcode=retcode+SQLCODE
 ...i retcode'=0  d
 ....Trollback
 i retcode=0  d
 .TCOMMIT
 q retcode
}

ClassMethod getjieshzprt(itmjs As %Library.String = "", itmjsex As %Library.String = "", str, guser)
{
	;n (str)
	q:(str="") "100"
	q:(guser="") "200"
	k ^tmp("zyyjnohz",$j,guser)
	k ^tmp("zyfpnohz",$j,guser)
	s yjsum=0,yjnum=0,yjssum=0,yjsnum=0,yjtsum=0,yjtnum=0
	s yjxjsum=0,yjxjnum=0,yjzpsum=0,yjzpnum=0
	s yjsxjsum=0,yjsxjnum=0,yjtxjsum=0,yjtxjnum=0
	s yjszpsum=0,yjszpnum=0,yjtzpsum=0,yjtzpnum=0
	s fpsum=0,fpnum=0,fpssum=0,fpsnum=0,fptsum=0,fptnum=0
	s fpxjsum=0,fpxjnum=0,fpzpsum=0,fpzpnum=0
	s fpsxjsum=0,fpsxjnum=0,fptxjsum=0,fptxjnum=0
	s fpszpsum=0,fpszpnum=0,fptzpsum=0,fptzpnum=0
	s tdeptsum=0
	s rcptnonum=1,invnonum=1
	s num=$l(str,"^")
	f ii=2:1:num  d
	.s jkdr=$p(str,"^",ii)
	.q:'$d(^DHCJFUSERJK(jkdr))
	.i $d(^DHCSFPRINTDETAIL(0,"JKDR",jkdr))=10  d
	..s yjrowid="0" 
	..f  s yjrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,yjrowid))  q:yjrowid=""  d
	...s rcptno=$p(^DHCSFPRINTDETAIL(yjrowid),"^",1)
	...s yjamt=$p(^DHCSFPRINTDETAIL(yjrowid),"^",6)
	...s prtstatus=$p(^DHCSFPRINTDETAIL(yjrowid),"^",8)
	...s paymode=$p(^DHCSFPRINTDETAIL(yjrowid),"^",9)
	...i paymode=""  d
	....s modedesc="现金"
	...e  d
	....i $d(^CT("CTPM",paymode))= 0  d
	.....s modedesc="现金"
	....e  d
	.....s modedesc=$p(^CT("CTPM",paymode),"^",2)
	...i prtstatus="1"  s status="正常"
	...i prtstatus="2"  s status="作废"
	...i prtstatus="3"  s status="冲红"
	...i prtstatus="4"  s status="正常"
	...i prtstatus="5"  s status="正常"
	...i rcptno'=""  d
	....i $d(^tmp("zyyjnohz",$j,guser,rcptnonum))=0  d
	.....s ^tmp("zyyjnohz",$j,guser,rcptnonum)=rcptno_"^"_rcptno
	....e  d
	.....s tmprcptstr=$g(^tmp("zyyjnohz",$j,guser,rcptnonum))
	.....i $f(tmprcptstr,"^")=0  d
	......s ^tmp("zyyjnohz",$j,guser,rcptnonum)=tmprcptstr_"^"_rcptno
	.....e  d
	......s tmprcpt1=$p(^tmp("zyyjnohz",$j,guser,rcptnonum),"^",1)
	......s tmprcpt2=$p(^tmp("zyyjnohz",$j,guser,rcptnonum),"^",2)
	......s tmprcpt2=+tmprcpt2
	......s rcptno2=+rcptno
	......i rcptno2'= 0 d
	.......i rcptno2-tmprcpt2=1  d
	........s ^tmp("zyyjnohz",$j,guser,rcptnonum)=tmprcpt1_"^"_rcptno
	.......e  d
	........s rcptnonum=rcptnonum+1
	........s ^tmp("zyyjnohz",$j,guser,rcptnonum)=rcptno_"^"_rcptno
	...i status'="作废"  d
	....s yjsum=yjsum+yjamt
	....s yjnum=yjnum+1
	....i status="冲红"  d
	.....s yjtsum=yjtsum-yjamt
	.....s yjtnum=yjtnum+1
	.....i modedesc="现金"  d
	......s yjtxjsum=yjtxjsum-yjamt
	......s yjtxjnum=yjtxjnum+1
	......s yjxjsum=yjxjsum+yjamt
	......s yjxjnum=yjxjnum+1
	.....e  d
	......s yjtzpsum=yjtzpsum-yjamt
	......s yjtzpnum=yjtzpnum+1
	......s yjzpsum=yjzpsum+yjamt
	......s yjzpnum=yjzpnum+1
	....e  d
	.....s yjssum=yjssum+yjamt
	.....s yjsnum=yjsnum+1
	.....i modedesc="现金"  d
	......s yjsxjsum=yjsxjsum+yjamt
	......s yjsxjnum=yjsxjnum+1
	......s yjxjsum=yjxjsum+yjamt
	......s yjxjnum=yjxjnum+1
	.....e  d
	......s yjszpsum=yjszpsum+yjamt
	......s yjszpnum=yjszpnum+1
	......s yjzpsum=yjzpsum+yjamt
	......s yjzpnum=yjzpnum+1
	.i $d(^DHCINVPRTZY(0,"JK",jkdr))=10  d
	..s fprowid="0"
	..f  s fprowid=$o(^DHCINVPRTZY(0,"JK",jkdr,fprowid))  q:fprowid=""  d
	...s billno=$p(^DHCINVPRTZY(fprowid),"^",5)
	...s prtstatus=$p(^DHCINVPRTZY(fprowid),"^",8)
	...i prtstatus="S"  d
	....s status="冲红"
	...e  i prtstatus="A" d
	....s status="作废"
	...e  d
	....s status="正常"
	...s invno=$p(^DHCINVPRTZY(fprowid),"^",1)
	...s tdeposit=$p(^DHCINVPRTZY(fprowid),"^",22)
	...s tdeptsum=tdeptsum+tdeposit
	...i invno'=""  d
	....i $d(^tmp("zyfpnohz",$j,guser,invnonum))=0  d
	.....s ^tmp("zyfpnohz",$j,guser,invnonum)=invno_"^"_invno
	....e  d
	.....s tmpinvstr=$g(^tmp("zyfpnohz",$j,guser,invnonum))
	.....i $f(tmpinvstr,"^")=0  d
	......s ^tmp("zyfpnohz",$j,guser,invnonum)=tmpinvstr_"^"_invno
	.....e  d
	......s tmpinv1=$p(^tmp("zyfpnohz",$j,guser,invnonum),"^",1)
	......s tmpinv2=$p(^tmp("zyfpnohz",$j,guser,invnonum),"^",2)
	......s tmpinv2=+tmpinv2
	......s invno2=+invno
	......i invno2'=0 d
	.......i invno2-tmpinv2=1  d
	........s ^tmp("zyfpnohz",$j,guser,invnonum)=tmpinv1_"^"_invno
	.......e  d
	........s invnonum=invnonum+1
	........s ^tmp("zyfpnohz",$j,guser,invnonum)=invno_"^"_invno
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
	.......i mode="" d
	........s paydesc="现金"
	.......e  d
	........s paydesc=$p(^CT("CTPM",mode),"^",2)
	.......s payamount=$p(ss,"^",3)
	.......i status'="作废"  d
	........s fpsum=fpsum+payamount
	........s fpnum=fpnum+1
	........i payamount>0  d
	.........s fpssum=fpssum+payamount
	.........s fpsnum=fpsnum+1
	.........i paydesc="现金" d
	..........s fpxjsum=fpxjsum+payamount
	..........s fpsxjsum=fpsxjsum+payamount
	.........e  d
	..........s fpzpsum=fpzpsum+payamount
	..........s fpszpsum=fpszpsum+payamount
	........e  d
	.........s fptsum=fptsum+payamount
	.........s fptnum=fptnum+1
	.........i paydesc="现金" d
	..........s fpxjsum=fpxjsum+payamount
	..........s fptxjsum=fptxjsum-payamount
	.........e  d
	..........s fpzpsum=fpzpsum+payamount
	..........s fptzpsum=fptzpsum-payamount
	s yjdx=##class(web.UDHCJFBaseCommon).RMBDXXZH("","",yjsum)
	s yjnoid=""
	s yjnostr=""
	f  s yjnoid=$o(^tmp("zyyjnohz",$j,guser,yjnoid))  q:yjnoid=""  d
	.s tmp1=+$p(^tmp("zyyjnohz",$j,guser,yjnoid),"^",1)
	.s tmp2=+$p(^tmp("zyyjnohz",$j,guser,yjnoid),"^",2)
	.s yjnozs=tmp2-tmp1+1
	.i yjnostr=""  d
	..s yjnostr=$g(^tmp("zyyjnohz",$j,guser,yjnoid))_"^"_yjnozs
	.e  d
	..s yjnostr=yjnostr_"##"_$g(^tmp("zyyjnohz",$j,guser,yjnoid))_"^"_yjnozs
	s yjstr=yjdx_"@@"_$j(yjsum,3,2)_"^"_$j(yjxjsum,3,2)_"^"_$j(yjzpsum,3,2)_"^"_$j(yjssum,3,2)_"^"_$j(yjtsum,3,2)_"@@"_yjnostr
	s fpdx=##class(web.UDHCJFBaseCommon).RMBDXXZH("","",fpsum)
	s fpnoid=""
	s fpnostr=""
	f  s fpnoid=$o(^tmp("zyfpnohz",$j,guser,fpnoid))  q:fpnoid=""  d
	.s tmp1=+$p(^tmp("zyfpnohz",$j,guser,fpnoid),"^",1)
	.s tmp2=+$p(^tmp("zyfpnohz",$j,guser,fpnoid),"^",2)
	.s fpnozs=tmp2-tmp1+1
	.i fpnostr=""  d
	..s fpnostr=$g(^tmp("zyfpnohz",$j,guser,fpnoid))_"^"_fpnozs
	.e  d
	..s fpnostr=fpnostr_"##"_$g(^tmp("zyfpnohz",$j,guser,fpnoid))_"^"_fpnozs
	s fpstr=fpdx_"@@"_$j(fpsum,3,2)_"^"_$j(fpxjsum,3,2)_"^"_$j(fpzpsum,3,2)_"^"_$j(fpssum,3,2)_"^"_$j(fptsum,3,2)_"@@"_fpnostr
	s str=yjstr_"!"_fpstr
	k ^tmp("zyyjnohz",$j,guser)
	k ^tmp("zyfpnohz",$j,guser)
	q str
}

}
