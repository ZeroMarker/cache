Class web.UDHCJFPrtSubFee Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 165;

ClassMethod getinpatsubcate(bill)
{
	     s bill=$g(bill)
	     q:(bill="") ""
	     k ^tmpincate($j),P9,mPLIST
	     ;insert by cx 2007.14.11
	     q:($d(^DHCPB(bill))=0) ""
	     s admid=$p(^DHCPB(bill),"^",1)
	     q:(admid="") ""
	     q:($d(^PAADM(admid))=0) ""
	     s patinfo=..getdeposit(bill,admid)
	     s tmpstr=""
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
	     q patinfo_"##"_tmpstr
}

ClassMethod geticfee(bill)
{
	   s ordsub=""
	   s incate=""
	   s test=0
	   k P1,P2
	   k mPLIST,PLIST,babyPLIST
	   k ^TMPCACHE("PB",$j)
	   k ^TMP("ZYJF",$j)
	   ;取婴儿费用和母亲费用是否结算的标志
	   s Conf=$o(^DHCTarC("CF",""))
	   s newbornflag=$p(^DHCTarC("CF",Conf),"^",5)
	   s newbornflag=$g(newbornflag)
	   ;取账单的总费用,折扣费用,记账,自付
	   s err=##class(UDHCJFPB).SELECT(bill)
	   i $d(PLIST) m ARPBL=PLIST
	   ;取病人入院日期，出院日期
	   s admdate=$ZD(ARPBL(3),3)
	   s disdate=$zd(ARPBL(8),3)
	   s disamount=+ARPBL(10)  ;折扣金额
	   s payshare=+ARPBL(12)  ;记账金额
	   s patshare=+ARPBL(13)  ;自费金额
	   s totalamount=+ARPBL(9)  ;总金额
	   s total=totalamount
	   i patshare<0  d
	   .s patshare0=$p(patshare,"-",2)
	   .s patshareUP=##class(UDHCJFYJ).RMBDXXZH(patshare0)
	   .s patshareUP="负"_patshareUP
	   e  d
	   .s patshareUP=##class(UDHCJFYJ).RMBDXXZH(patshare)
	   i totalamount<0  d
	   .s totalamount0=$p(totalamount,"-",2)
	   .s totalamountUP=##class(UDHCJFYJ).RMBDXXZH(totalamount0)
	   .s totalamountUP="负"_totalamountUP
	   e  d
	   .s totalamountUP=##class(UDHCJFYJ).RMBDXXZH(totalamount)
	   s P2=$j(disamount,3,2)_"^"_$j(payshare,3,2)_"^"_$j(patshare,3,2)_"^"_patshareUP_"^"_totalamount_"^"_totalamountUP
	   s ^TMP("ZYJF",$j,"PAY")=P2
	   f i=1:1:$g(^tmpincate($j)) d
	   .s itmfee(i)=0
	   .s itmfee1(i)=0
	   f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:ordsub=""  d
	   .q:ordsub=0
	   .s oerowid=$p(^DHCPB(bill,"O",ordsub),"^",4)
	   .;q:'$d(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2)))
	   .;insert by cx 2008.01.16
	   .s oeorderid=$p(oerowid,"||",1)
	   .s oeordadm=$p(^OEORD(oeorderid),"^",1)
	   .s oeordmotadm=$p(^PAADM(oeordadm),"^",75)
	   .s oeordmotadm=$g(oeordmotadm)
	   .s detsub="0"
	   .f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:detsub=""  d
	   ..s taritem=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",3)     ;收费项目
	   ..s unitprice=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",4)   ;单价
	   ..s qty=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",5)         ;数量
	   ..s totalamount=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",7) ;总额
	   ..i taritem'="" s inpatcate=$p(^DHCTARI(taritem),"^",14)     ;住院费用子分类         
	   ..s icate=$p(^DHCTarC("IC",inpatcate),"^",3)                 ;住院费用大类
	   ..f i=1:1:$g(^tmpincate($j)) d
	   ...i $p(icate,$c(1))=$p($p(^tmpincate($j,i),"^",1),$c(1)) d
	   ....i (newbornflag="Y")&(oeordmotadm'="")  d
	   .....s itmfee1(i)=totalamount+itmfee1(i)
 	   ....e  d
 	   .....s itmfee(i)=totalamount+itmfee(i)
	   ...e  s test=totalamount
	   s tmpstr="",tmpstr1=""
	   f i=1:1:$g(^tmpincate($j)) d
	   .s mPLIST(i)=$p(^tmpincate($j,i),"^",1)_"^"_$p(^tmpincate($j,i),"^",2)_"^"_$j(itmfee(i),3,2)
	   .s PLIST(i)=$p(^tmpincate($j,i),"^",1)_"^"_$p(^tmpincate($j,i),"^",2)_"^"_$j(itmfee(i),3,2)
	   .;i $j(itmfee(i),3,2)'="0.00" d
	   .s babyPLIST(i)=$p(^tmpincate($j,i),"^",1)_"^"_$p(^tmpincate($j,i),"^",2)_"^"_$j(itmfee1(i),3,2)
	   .s ^TMP("ZYJF",$j,i)=PLIST(i)
	   .s tmpstr=tmpstr_"&"_PLIST(i)
	   .s tmpstr1=tmpstr1_"&"_babyPLIST(i)
	   s P1=$g(^tmpincate($j))
	   s tmpstr=tmpstr_"@"_$j(total,3,2)_"@"_totalamountUP_"@"_admdate_"@"_disdate
	   q tmpstr_"!"_tmpstr1
}

ClassMethod getdeposit(billno, admdr)
{
	   k P1,P2
	   s deposit=0,cash=0,cheque=0,hp=0,xyk=0,qf=0,ykly=0
	   s cheque1=0,hp1=0,xyk1=0
	   s initcheque=0,inithp=0,initxyk=0
	   s jsdate=""
	   s invrowid=""
	   s keshi="",zhuyno="",sex=""  ;淮安情况附加的?取科室?住院号?性别
	   s paidflag=$p(^DHCPB(billno),"^",16)
	   i paidflag="B"  d
	   .s x1=""                        ;table - AR_RcptAlloc
	   .f  s x1=$o(^ARRCP("Adm_DR",admdr,x1)) q:x1=""  d
	   ..s x2="" 
	   ..f  s x2=$o(^ARRCP("Adm_DR",admdr,x1,x2)) q:x2=""  d
	   ...q:+$p(^ARRCP(x1,"RAL",x2),"^",9)=0
	   ...q:+$p(^ARRCP(x1,"RAL",x2),"^",18)'=0
	   ...s deposit1=$p(^ARRCP(x1,"RAL",x2),"^",2)
	   ...s deposit=deposit+deposit1 
	   e  d
	   .s invrowid=$o(^DHCINVPRTZY(0,"AR",billno,""),-1)
	   .i invrowid'=""  s deposit=$p(^DHCINVPRTZY(invrowid),"^",22)
	   .i invrowid'=""  d
	   ..s initrowid=$p(^DHCINVPRTZY(invrowid),"^",13)
	   ..i initrowid'=""  d
	   ...s initcheque=0,inithp=0,initxyk=0
	   ...s initflag=$p(^DHCINVPRTZY(initrowid),"^",8)
	   ...s initbillno=$p(^DHCINVPRTZY(initrowid),"^",5)
	   ...i initflag="S"  d
	   ....s initarrcp=""
	   ....f  s initarrcp=$o(^ARRCP("ARPBL",initbillno,initarrcp)) q:initarrcp=""  d
	   .....s initarral=""
	   .....f  s initarral=$o(^ARRCP("ARPBL",initbillno,initarrcp,initarral)) q:initarral=""  d
	   ......s inittype=$p(^ARRCP(initarrcp,"RAL",initarral),"^",9)
	   ......i inittype=""  d
	   .......s initpaym="0"
	   .......f  s initpaym=$o(^ARRCP(initarrcp,"PAYM",initpaym)) q:initpaym=""  d
	   ........s initss=^ARRCP(initarrcp,"PAYM",initpaym)
	   ........s initmode=$p(initss,"^",1)
	   ........i initmode=""  s initmode="2"
	   ........s initm2=$p(initss,"^",3),initpaydesc=$p(^CT("CTPM",initmode),"^",2)
	   ........i initpaydesc="支票" d
	   .........s initcheque=initcheque+initm2
	   ........i initpaydesc="汇票" d
	   .........s inithp=inithp+initm2    ;其他
	   ........i initpaydesc="银行卡" d
       .........s initxyk=initxyk+initm2
       .;w !,initcheque
       .s arrcp=""
	   .f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	   ..s arral="" 
	   ..f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	   ...i invrowid=""  d
	   ....s rcptnum=$p(^ARRCP(arrcp),"^",2)
	   ....i rcptnum=""  d
	   .....s deposit1=$p(^ARRCP(arrcp,"RAL",arral),"^",2)
	   .....s deposit=deposit+deposit1
	   ...s jsdate=$p(^ARRCP(arrcp),"^",3)
	   ...i jsdate'="" s jsdate=$zd(jsdate,3)
	   ...s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",24)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	   ...i type,billnum=billno,chflag="N" s deposit=deposit+m1
	   ...i type="" d
	   ....s paym="0"
	   ....f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	   .....s ss=^ARRCP(arrcp,"PAYM",paym)
	   .....s mode=$p(ss,"^",1)
	   .....i mode="" s mode="2"
	   .....s m2=$p(ss,"^",3),paydesc=$p(^CT("CTPM",mode),"^",2)
	   .....i paydesc="现金" s cash=cash+m2   ;mode=3(支付方式为支票),否则为现金方式
	   .....i paydesc="支票" d
	   ......i m2>0  d
	   .......s cheque=cheque+m2
	   ......e  d
	   .......s cheque1=cheque1+m2 
	   .....i paydesc="汇票" d
	   ......i m2>0 d
	   .......s hp=hp+m2    ;其他
	   ......e  d
	   .......s hp1=hp1+m2
       .....i paydesc="银行卡" d
       ......i m2>0 d
       .......s xyk=xyk+m2
       ......e  d
       .......s xyk1=xyk1+m2
       .....i paydesc["留用" s ykly=ykly+m2
	   .....;e  i paydesc="倒存支票" s cheque=cheque+m2
	   .....;e  i paydesc="公费记帐" s cash=cash+m2
	   .....;e  i paydesc="市领导记帐" s cash=cash+m2
	   .....e  i paydesc="欠费" s qf=qf+m2
	   i initcheque<0  d
	   .s tmpcheque=cheque
	   .s cheque=0-initcheque
	   .s tmpcheque=initcheque+tmpcheque
	   .i tmpcheque>0  d
	   ..s cheque=cheque+tmpcheque
	   .e  d
	   ..s cheque1=tmpcheque
	   
	   i initcheque>0  d
	   .s cheque=initcheque
	   .s tmpcheque=cheque1+initcheque
	   .;s cheque1=cheque1+initcheque
	   .i tmpcheque<0  d
	   ..s cheque1=cheque-tmpcheque
	   ..s cheque=0
	   .e  d
	   ..s cheque1=initcheque
	   ..s cheque=tmpcheque
	   i inithp<0  d
	   .s tmphp=hp
	   .s hp=hp-inithp
	   .s tmphp=inithp+tmphp
	   .i tmphp>0  d
	   ..s hp=hp+tmphp
	   .e  d
	   ..s hp1=tmphp
	   i inithp>0  d
	   .s hp=inithp
	   .s tmphp=hp1+inithp
	   .;s hp1=hp1+inithp
	   .i tmphp<0  d
	   ..s hp1=hp-tmphp
	   ..s hp=0
	   .e  d
	   ..s hp1=inithp
	   ..s hp=tmphp
	   i initxyk<0  d
	   .s tmpxyk=xyk
	   .s xyk=xyk-initxyk
	   .s tmpxyk=initxyk+tmpxyk
	   .i tmpxyk>0  d
	   ..s xyk=xyk+tmpxyk
	   .e  d
	   ..s xyk1=tmpxyk
	   i initxyk>0  d
	   .s xyk=initxyk
	   .s tmpxyk=xyk1+initxyk
	   .;s xyk1=xyk1+initxyk
	   .i tmpxyk<0  d
	   ..s xyk1=xyk-tmpxyk
	   ..s xyk=0
	   .e  d
	   ..s xyk1=initxyk
	   ..s xyk=tmpxyk
	   s P1=$j(cash,3,2)_"^"_$j(cheque,3,2)_"^"_$j(hp,3,2)_"^"_$j(xyk,3,2)_"^"_$j(deposit,3,2)
	   s billdatefrom=$p(^DHCPB(billno),"^",6),billdateto=$p(^DHCPB(billno),"^",7)
	   i admdr'=""  d 
	   .s paprowid=$p(^PAADM(admdr),"^",1)
	   .s admdate=$p(^PAADM(admdr),"^",6)
	   .s disdate=$p(^PAADM(admdr),"^",17)
	   .s zhuyno=$p(^PAADM(admdr),"^",81)
	   i $d(^DHCINVPRTZY(0,"AR",billno)) d
	   .s prtrowid=$o(^DHCINVPRTZY(0,"AR",billno,""))
	   ;s disdate=billdateto
	   ;i disdate="" s disdate=$p(^PAADM(admdr),"^",17)
	   s disdate=$p(^PAADM(admdr),"^",17)
	   i disdate=""  s disdate=billdateto
	   i disdate="" s disdate=+$h
	   i paprowid'="" s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	   s papname=$p(^PAPER(paprowid,"ALL"),"^",1)
	   s zyno=""
	   i $d(^PAPER(paprowid,"PAT",1)) s zyno=$p(^PAPER(paprowid,"PAT",1),"^",22)   ;病案号
	   i $d(^PAPER(paprowid,"ALL")) s sfz=$p(^PAPER(paprowid,"ALL"),"^",9) ;身份证
	   s sex=$p(^PAPER(paprowid,"ALL"),"^",7),papcompany=""
	   i $d(^PAPER(paprowid,"PER","ADD",1))  s papcompany=^PAPER(paprowid,"PER","ADD",1)            ; lrl
	   s zycount=0
	   s PAADMRowID=""
	   f  s PAADMRowID=$o(^PAPERdr(paprowid,"ADM","I",PAADMRowID)) q:PAADMRowID=""  d
	   .q:'$d(^PAADM(PAADMRowID))
	   .s admdata1=$p(^PAADM(PAADMRowID),"^",6)
	   .if $p($zd(admdata1,3),"-",1)=$p($zd($p($h,",",1),3),"-",1) s zycount=zycount+1
	   if sex'="" s sex=$p(^CT("SEX",sex),"^",2)
	   s roomrowid=""
	   if $d(^PAADM(admdr))'=0 d
	   .s roomrowid=$p(^PAADM(admdr),"^",69)
	   .s ward=$p(^PAADM(admdr),"^",70)
	   .s warddesc=""
	   .i $d(^PAWARD(ward)) s warddesc=$p(^PAWARD(ward),"^",2),warddesc=$p(warddesc,"-",2)
	   .s loc=$p(^PAADM(admdr),"^",4)
	   .i loc'="" s loc=$p(^CTLOC(loc),"^",2)
	   .s loc=$p(loc,"-",2)
	   .s admreason=""
	   .s admreasonid=$p(^PAADM(admdr,1),"^",7)
	   .i admreasonid'="" d
	   ..i $d(^PAC("ADMREA",admreasonid)) s admreason=$p(^PAC("ADMREA",admreasonid),"^",2)
	   .e  d
	   ..s admreason="自费"
	   s ROOMDesc=""
	   if roomrowid'="" d 
	   .if $d(^PAROOM(roomrowid))'=0 d
	   ..s ROOMDesc=$p(^PAROOM(roomrowid),"^",2)
	   s BEDCode=""
	   s bedrowid=""
	   if admdr'="" d
	   .s bedrowid=$p(^PAADM(admdr),"^",73)
	   if bedrowid'="" d
	   .s BEDCode=$p(^PAWARD($p(bedrowid,"||",1),"BED",$p(bedrowid,"||",2)),"^",1)
	   s bedno=""
	   if ROOMDesc'="" d
	   .s bedno=ROOMDesc_"-"_BEDCode
	   i admreason="自费"  s admreason="自费病人"
	   s days=disdate-billdatefrom
	   i days=0 s days=1
	   ;s P1=$j(cash,3,2)_"^"_$j(cheque,3,2)_"^"_$j(hp,3,2)_"^"_$j(xyk,3,2)_"^"_$j(deposit,3,2)
	   s P2=papname_"^"_bedno_"^"_loc_"^"_$zd(billdatefrom,3)_"^"_$zd(disdate,3)_"^"_days_"^"_papno_"^"_sex_"^"_zycount_"^"_papcompany_"^"_admreason_"^"_jsdate_"^"_$j(qf,3,2)_"^"_zyno_"^"_ykly_"^"_$zd(+$h,3)_"^"_warddesc_"^"_sfz   //yyx增加最后节点 2006-11-08
	   s P2=P2_"^"_$j(cheque1,3,2)_"^"_$j(hp1,3,2)_"^"_$j(xyk1,3,2)  ;insert by cx 2007.05.15 将收、退支票、银行卡、汇票分开
	   q P1_"^"_P2
}

}
