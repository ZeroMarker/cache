Import SQLUser

Class web.UDHCJFDayRptHX Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 7;

ClassMethod gethzprt(itmjs As %Library.String = "", itmjsex As %Library.String = "", job, guser, reprotstr)
{
	;n (str)
	q:(job="") "100"
	q:(guser="") "200"
	k ^TMP("ZYJFCWPrint","chyj",job)
	k ^TMP("ZYJF","yj",job)
	k ^TMP("ZYJF","zyfp",job)
	k ^TMP("ZYJF","chfp",job)
	k ^TMP("ZYJF","chfpjs",job)
	k ^TMP("ZYJFCWPrint","JkDate",job)
	k ^TMP("ZYJF","CHFlag",job)
	s reportstr=reportstr_"^"
	s rowid="0"
	f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
	.s paymodedesc=$p(^CT("CTPM",rowid),"^",2)
	.s ^TMP("ZYJF","yj",job,"收",paymodedesc)=0  
	.s ^TMP("ZYJF","yj",job,"退",paymodedesc)=0
	.s ^TMP("ZYJF","zyfp",job,"收",paymodedesc)=0
	.s ^TMP("ZYJF","zyfp",job,"退",paymodedesc)=0
	.s ^TMP("ZYJF","chfp",job,"收",paymodedesc)=0
	.s ^TMP("ZYJF","chfp",job,"退",paymodedesc)=0
	s ^TMP("ZYJF","yj",job,"收","其它")=0  
	s ^TMP("ZYJF","yj",job,"退","其它")=0
	s ^TMP("ZYJF","zyfp",job,"收","其它")=0
	s ^TMP("ZYJF","zyfp",job,"退","其它")=0
	s ^TMP("ZYJF","chfp",job,"其它")=0
	s ^TMP("ZYJF","chfp",job,"收","其它")=0
	s ^TMP("ZYJF","chfp",job,"退","其它")=0
	s str=""
	
	s yjnum=""
	f  s yjnum=$o(^TMP("ZYJFCWPrint","YJ",job,guser,yjnum))  q:(yjnum="")  d
	.s jkdr=""
	.s mode=$p(^TMP("ZYJFCWPrint","YJ",job,guser,yjnum),"^",1)
	.s prtstatus=$p(^TMP("ZYJFCWPrint","YJ",job,guser,yjnum),"^",2)
	.q:(prtstatus="2")
	.s yjamt=$p(^TMP("ZYJFCWPrint","YJ",job,guser,yjnum),"^",3)
	.s prtrowid=$p(^TMP("ZYJFCWPrint","YJ",job,guser,yjnum),"^",5)
	.s jkdr=$p(^DHCSFPRINTDETAIL(prtrowid),"^",30)
	.s jkdr="^"_jkdr_"^"
	.q:(reportstr'[jkdr)
	.i mode=""  s modedesc="其他"
	.i mode'="" d
	..i ($d(^CT("CTPM",mode))'=0)&($d(^CT("CTPM",mode))'=10)  d
	...s modedesc=$p(^CT("CTPM",mode),"^",2)
	..e  d
	...s modedesc="其他"
	.i yjamt>0  d
	..s ^TMP("ZYJF","yj",job,"收",modedesc)=$g(^TMP("ZYJF","yj",job,"收",modedesc))+yjamt
	.e  d
	..s ^TMP("ZYJF","yj",job,"退",modedesc)=$g(^TMP("ZYJF","yj",job,"退",modedesc))-yjamt	
	s fpnum=""
	s feetotal=0
	f  s fpnum=$o(^TMP("ZYJFCWPrint","FP",job,guser,fpnum))  q:(fpnum="")  d
	.s jkdr=""
	.s mode=$p(^TMP("ZYJFCWPrint","FP",job,guser,fpnum),"^",1)
	.s prtstatus=$p(^TMP("ZYJFCWPrint","FP",job,guser,fpnum),"^",2)
	.q:(prtstatus="A")
	.s fpamt=$p(^TMP("ZYJFCWPrint","FP",job,guser,fpnum),"^",3)
	.s prtrowid=$p(^TMP("ZYJFCWPrint","FP",job,guser,fpnum),"^",5)
	.s jkdr=$p(^DHCINVPRTZY(prtrowid),"^",23)
	.s jkdr="^"_jkdr_"^"
	.q:(reportstr'[jkdr)
	.s cintiniv=$p(^DHCINVPRTZY(prtrowid),"^",13)
	.s admno=$p(^DHCINVPRTZY(prtrowid),"^",4)
	.s billno=$p(^DHCINVPRTZY(prtrowid),"^",5)
	.s feeamt=0
	.s feeamt=$p(^DHCINVPRTZY(prtrowid),"^",6)
	.s feetotal=feetotal+feeamt
	.s ^TMP("ZYJFCWPrint","chyj",job,guser,prtrowid)=billno
	.i mode=""  s modedesc="其他"
	.i mode'="" d
	..i ($d(^CT("CTPM",mode))'=0)&($d(^CT("CTPM",mode))'=10)  d
	...s modedesc=$p(^CT("CTPM",mode),"^",2)
	..e  d
	...s modedesc="其他"
	.i prtstatus="I"  s prtstatus="N"
	.i ((fpamt>0)&(cintiniv=""))  d
	..i $d(^TMP("ZYJF","zyfp",job,"收",modedesc))=0  d
	...s ^TMP("ZYJF","zyfp",job,"收",modedesc)=fpamt
	..e  d
	...s ^TMP("ZYJF","zyfp",job,"收",modedesc)=$g(^TMP("ZYJF","zyfp",job,"收",modedesc))+fpamt
	.i ((fpamt<0)&(cintiniv=""))  d
	..i $d(^TMP("ZYJF","zyfp",job,"退",modedesc))=0  d
	...s ^TMP("ZYJF","zyfp",job,"退",modedesc)=0-fpamt
	..e  d
	...s ^TMP("ZYJF","zyfp",job,"退",modedesc)=$g(^TMP("ZYJF","zyfp",job,"退",modedesc))-fpamt 
	.i ((prtstatus="S")&(cintiniv'=""))  d
	..i $d(^TMP("ZYJF","CHFlag",job,admno,prtrowid))=0  d
	...s ^TMP("ZYJF","CHFlag",job,admno,prtrowid)=prtrowid
	...d ..getchinfo(admno,prtrowid,job,mode)
		
	;押金
	s syjsum=0,tyjsum=0,syjxjsum=0,tyjxjsum=0,syjzpsum=0,tyjzpsum=0
	s syjxyksum=0,tyjxyksum=0,syjybksum=0,tyjybksum=0,syjlysum=0,tyjlysum=0
	s syjqtsum=0,tyjqtsum=0
	s modestr=""
	f  s modestr=$o(^TMP("ZYJF","yj",job,"收",modestr))  q:(modestr="")  d
	.s syjsum=syjsum+$g(^TMP("ZYJF","yj",job,"收",modestr))
	.i modestr="现金"  d
	..s syjxjsum=syjxjsum+$g(^TMP("ZYJF","yj",job,"收",modestr))
	.e  i modestr="支票"  d 
	..s syjzpsum=syjzpsum+$g(^TMP("ZYJF","yj",job,"收",modestr))
	.e  i modestr="信用卡"  d
	..s syjxyksum=syjxyksum+$g(^TMP("ZYJF","yj",job,"收",modestr))
	.e  i modestr="银行卡"  d
	..s syjxyksum=syjxyksum+$g(^TMP("ZYJF","yj",job,"收",modestr))
	.e  i modestr="医保卡划款"  d
	..s syjybksum=syjybksum+$g(^TMP("ZYJF","yj",job,"收",modestr))
	.e  i modestr["留用"  d
	..s syjlysum=syjlysum+$g(^TMP("ZYJF","yj",job,"收",modestr))
	.e  d
	..s syjqtsum=syjqtsum+$g(^TMP("ZYJF","yj",job,"收",modestr))
	s modestr=""
	f  s modestr=$o(^TMP("ZYJF","yj",job,"退",modestr))  q:(modestr="")  d
	.s tyjsum=tyjsum+$g(^TMP("ZYJF","yj",job,"退",modestr))
	.i modestr="现金"  d
	..s tyjxjsum=tyjxjsum+$g(^TMP("ZYJF","yj",job,"退",modestr))
	.e  i modestr="支票"  d 
	..s tyjzpsum=tyjzpsum+$g(^TMP("ZYJF","yj",job,"退",modestr))
	.e  i modestr="信用卡"  d
	..s tyjxyksum=tyjxyksum+$g(^TMP("ZYJF","yj",job,"退",modestr))
	.e  i modestr="银行卡"  d
	..s tyjxyksum=tyjxyksum+$g(^TMP("ZYJF","yj",job,"退",modestr))
	.e  i modestr="医保卡划款"  d
	..s tyjybksum=tyjybksum+$g(^TMP("ZYJF","yj",job,"退",modestr))
	.e  i modestr["留用"  d
	..s tyjlysum=tyjlysum+$g(^TMP("ZYJF","yj",job,"退",modestr))
	.e  d
	..s tyjqtsum=tyjqtsum+$g(^TMP("ZYJF","yj",job,"退",modestr))
	
	;发票
	s sfpsum=0,tfpsum=0,sfpxjsum=0,tfpxjsum=0,sfpzpsum=0,tfpzpsum=0
	s sfpxyksum=0,tfpxyksum=0,sfpybksum=0,tfpybksum=0,sfplysum=0,tfplysum=0
	s sfpqtsum=0,tfpqtsum=0,sfptcsum=0,tfptcsum=0,sfpqfsum=0,tfpqfsum=0
	s sfpjcsum=0,tfpjcsum=0
	
	s modestr=""
	f  s modestr=$o(^TMP("ZYJF","zyfp",job,"收",modestr))  q:(modestr="")  d
	.s sfpsum=sfpsum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.i modestr="现金"  d
	..s sfpxjsum=sfpxjsum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  i modestr="支票"  d
	..s sfpzpsum=sfpzpsum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  i modestr="信用卡"  d
	..s sfpxyksum=sfpxyksum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  i modestr="银行卡"  d
	..s sfpxyksum=sfpxyksum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  i modestr="医保卡划款"  d
	..s sfpybksum=sfpybksum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  i (modestr["医保")&(modestr'="医保卡划款")  d
	..s sfptcsum=sfptcsum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  i modestr["留用"  d
	..s sfplysum=sfplysum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  i modestr="欠费"  d
	..s sfpqfsum=sfpqfsum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  i modestr="结存"  d
	..s sfpjcsum=sfpjcsum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	.e  d
	..s sfpqtsum=sfpqtsum+$g(^TMP("ZYJF","zyfp",job,"收",modestr))
	s modestr=""
	f  s modestr=$o(^TMP("ZYJF","zyfp",job,"退",modestr))  q:(modestr="")  d
	.s tfpsum=tfpsum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.i modestr="现金"  d
	..s tfpxjsum=tfpxjsum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  i modestr="支票"  d
	..s tfpzpsum=tfpzpsum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  i modestr="信用卡"  d
	..s tfpxyksum=tfpxyksum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  i modestr="银行卡"  d
	..s tfpxyksum=tfpxyksum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  i modestr="医保卡划款"  d
	..s tfpybksum=tfpybksum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  i (modestr["医保")&(modestr'="医保卡划款")  d
	..s tfptcsum=tfptcsum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  i modestr["留用"  d
	..s tfplysum=tfplysum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  i modestr="欠费"  d
	..s tfpqfsum=tfpqfsum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  i modestr="结存"  d
	..s tfpjcsum=tfpjcsum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	.e  d
	..s tfpqtsum=tfpqtsum+$g(^TMP("ZYJF","zyfp",job,"退",modestr))
	
	;冲红
	s schsum=0,tchsum=0,schxjsum=0,tchxjsum=0,schzpsum=0,tchzpsum=0
	s schxyksum=0,tchxyksum=0,schybksum=0,tchybksum=0,schlysum=0,tchlysum=0
	s schqtsum=0,tchqtsum=0,schtcsum=0,tchtcsum=0,schqfsum=0,tchqfsum=0
	s schjcsum=0,tchjcsum=0
	d ..putchinfo(job)
	s modestr=""
	f  s modestr=$o(^TMP("ZYJF","chfp",job,"收",modestr))  q:(modestr="")  d
	.s chamt=0
	.s chamt=+$g(^TMP("ZYJF","chfp",job,"收",modestr))
	.s schsum=schsum+chamt	
	.i modestr="现金"  d
	..s schxjsum=schxjsum+chamt
	.e  i modestr="支票"  d
	..s schzpsum=schzpsum+chamt
	.e  i modestr="信用卡"  d
	..s schxyksum=schxyksum+chamt
	.e  i modestr="银行卡"  d
	..s schxyksum=schxyksum+chamt
	.e  i modestr="医保卡划款"  d
	..s schybksum=schybksum+chamt
	.e  i ((modestr["医保")&(modestr'="医保卡划款"))  d
	..s schtcsum=schtcsum+chamt
	.e  i modestr["留用"  d
	..s schlysum=schlysum+chamt
	.e  i modestr="欠费"  d
	..s schqfsum=schqfsum+chamt
	.e  i modestr="结存"  d
	..s schjcsum=schjcsum+chamt
	.e  d
	..s schqtsum=schqtsum+chamt
	s modestr=""
	f  s modestr=$o(^TMP("ZYJF","chfp",job,"退",modestr))  q:(modestr="")  d
	.s chamt=0
	.s chamt=+$g(^TMP("ZYJF","chfp",job,"退",modestr))	
	.s tchsum=tchsum+chamt
	.i modestr="现金"  d
	..s tchxjsum=tchxjsum+chamt
	.e  i modestr="支票"  d
	..s tchzpsum=tchzpsum+chamt
	.e  i modestr="信用卡"  d
	..s tchxyksum=tchxyksum+chamt
	.e  i modestr="银行卡"  d
	..s tchxyksum=tchxyksum+chamt
	.e  i modestr="医保卡划款"  d
	..s tchybksum=tchybksum+chamt
	.e  i ((modestr["医保")&(modestr'="医保卡划款"))  d
	..s tchtcsum=tchtcsum+chamt
	.e  i modestr["留用"  d
	..s tchlysum=tchlysum+chamt
	.e  i modestr="欠费"  d
	..s tchqfsum=tchqfsum+chamt
	.e  i modestr="结存"  d
	..s tchjcsum=tchjcsum+chamt
	.e  d
	..s tchqtsum=tchqtsum+chamt
	  
	;冲红押金
	s tdepsum=0,tdepxjsum=0,tdepzpsum=0,tdepxyksum=0,tdepybksum=0,tdeplysum=0,tdepqtsum=0
	s invid=""
	f  s invid=$o(^TMP("ZYJFCWPrint","chyj",job,guser,invid))  q:invid=""  d
	.s jkdr=""
	.s prtstatus=$p(^DHCINVPRTZY(invid),"^",8)
	.s jkdr=$p(^DHCINVPRTZY(invid),"^",23)
	.s jkdr="^"_jkdr_"^"
	.q:(reportstr'[jkdr)
	.s billno=$p(^DHCINVPRTZY(invid),"^",5)
	.q:(prtstatus="A")
	.s aralstr=$g(^DHCJFDepositRowID("ZYJF",billno))
	.i aralstr'=""  d
	..s aralnum=$l(aralstr,"^")
	..i aralnum'=0  d
	...f i=1:1:aralnum  d
	....s aralid=$p(aralstr,"^",i)
	....s aralid1=$p(aralid,"||",1)
	....s paymid=""
	....f  s paymid=$o(^ARRCP(aralid1,"PAYM",paymid))  q:(paymid="")  d
	.....s mode=$p(^ARRCP(aralid1,"PAYM",paymid),"^",1)
	.....s amt=$p(^ARRCP(aralid1,"PAYM",paymid),"^",3)
	.....i mode=""  s modedesc="其他"
	.....i mode'="" d
	......i ($d(^CT("CTPM",mode))'=0)&($d(^CT("CTPM",mode))'=10)  d
	.......s modedesc=$p(^CT("CTPM",mode),"^",2)
	......e  d
	.......s modedesc="其他"
 	.....i prtstatus="S"  d
 	......s tdepsum=tdepsum-amt
 	......i modedesc="现金"  d
 	.......s tdepxjsum=tdepxjsum-amt
 	......e  i modedesc="支票"  d
 	.......s tdepzpsum=tdepzpsum-amt
 	......e  i modedesc="信用卡"  d
 	.......s tdepxyksum=tdepxyksum-amt
 	......e  i modedesc="银行卡"  d
 	.......s tdepxyksum=tdepxyksum-amt
 	......e  i modedesc="医保卡划款"  d
 	.......s tdepybksum=tdepybksum-amt
 	......e  i modedesc["留用"  d
 	.......s tdeplysum=tdeplysum-amt
 	......e  d
 	.......s tdepqtsum=tdepqtsum-amt
 	.....e  d
 	......s tdepsum=tdepsum+amt
 	......i modedesc="现金"  d
 	.......s tdepxjsum=tdepxjsum+amt
 	......e  i modedesc="支票"  d
 	.......s tdepzpsum=tdepzpsum+amt
 	......e  i modedesc="信用卡"  d
 	.......s tdepxyksum=tdepxyksum+amt
 	......e  i modedesc="银行卡"  d
 	.......s tdepxyksum=tdepxyksum+amt
 	......e  i modedesc="医保卡划款"  d
 	.......s tdepybksum=tdepybksum+amt
 	......e  i modedesc["留用"  d
 	.......s tdeplysum=tdeplysum+amt
 	......e  d
 	.......s tdepqtsum=tdepqtsum+amt 
	
	s xjsum=0,zpsum=0,xyksum=0,ybksum=0,yklysum=0,qtsum=0,tcsum=0,qfsum=0,jcsum=0
	s xjsum=syjxjsum-tyjxjsum+sfpxjsum-tfpxjsum+schxjsum-tchxjsum
	s zpsum=syjzpsum-tyjzpsum+sfpzpsum-tfpzpsum+schzpsum-tchzpsum
	s xyksum=syjxyksum-tyjxyksum+sfpxyksum-tfpxyksum+schxyksum-tchxyksum
	s yklysum=syjlysum-tyjlysum+sfplysum-tfplysum+schlysum-tchlysum
	s ybksum=syjybksum-tyjybksum+sfpybksum-tfpybksum+schybksum-tchybksum
	s qtsum=syjqtsum-tyjqtsum+sfpqtsum-tfpqtsum+schqtsum-tchqtsum
	s qfsum=sfpqfsum-tfpqfsum+schqfsum-tchqfsum
	s jcsum=sfpjcsum-tfpjcsum+schjcsum-tchjcsum
	
	s lrpstrnum=$length(reportstr,"^")
	s lrpstrnum=lrpstrnum-1
	f i=2:1:lrpstrnum  d
	.s jkdr=$p(reportstr,"^",i)
	.s jkdate1=$p(^DHCJFUSERJK(jkdr),"^",1)
	.s ^TMP("ZYJFCWPrint","JkDate",job,jkdate1)=jkdate1
	s jkdate1=""
	s jkstdate=$o(^TMP("ZYJFCWPrint","JkDate",job,jkdate1))
	i jkstdate'=""  s jkstdate=$zd(jkstdate,4)
	s jkenddate=$o(^TMP("ZYJFCWPrint","JkDate",job,jkdate1),-1)
	i jkenddate'=""  s jkenddate=$zd(jkenddate,4)
	s str=$j(tdepsum,3,2)_"^"_$j(tyjsum,3,2)_"^"_$j(syjsum,3,2)_"^"_$j(tdepxjsum,3,2)_"^"_$j(tyjxjsum,3,2)_"^"_$j(syjxjsum,3,2)   //5
	s str=str_"^"_$j(tdepxyksum,3,2)_"^"_$j(tyjxyksum,3,2)_"^"_$j(syjxyksum,3,2)_"^"_$j(tdepzpsum,3,2)_"^"_$j(tyjzpsum,3,2)_"^"_$j(syjzpsum,3,2)  //11
	s str=str_"^"_$j(tdepybksum,3,2)_"^"_$j(tyjybksum,3,2)_"^"_$j(syjybksum,3,2)_"^"_$j(tdeplysum,3,2)_"^"_$j(tyjlysum,3,2)_"^"_$j(syjlysum,3,2)  //17
	s str=str_"^"_$j(tdepqtsum,3,2)_"^"_$j(tyjqtsum,3,2)_"^"_$j(syjqtsum,3,2)_"^"_$j(tfpsum,3,2)_"^"_$j(sfpsum,3,2)_"^"_$j(tfpxjsum,3,2)_"^"_$j(sfpxjsum,3,2)  //24	
	s str=str_"^"_$j(tfpxyksum,3,2)_"^"_$j(sfpxyksum,3,2)_"^"_$j(tfpzpsum,3,2)_"^"_$j(sfpzpsum,3,2)_"^"_$j(tfpybksum,3,2)_"^"_$j(sfpybksum,3,2)   //30	
	s str=str_"^"_$j(tfptcsum,3,2)_"^"_$j(sfptcsum,3,2)_"^"_$j(tfplysum,3,2)_"^"_$j(sfplysum,3,2)_"^"_$j(tfpqfsum,3,2)_"^"_$j(sfpqfsum,3,2)     //36	
	s str=str_"^"_$j(tfpjcsum,3,2)_"^"_$j(sfpjcsum,3,2)_"^"_$j(tfpqtsum,3,2)_"^"_$j(sfpqtsum,3,2)_"^"_$j(tchsum,3,2)_"^"_$j(schsum,3,2)_"^"_$j(tchxjsum,3,2)  //43	
	s str=str_"^"_$j(schxjsum,3,2)_"^"_$j(tchxyksum,3,2)_"^"_$j(schxyksum,3,2)_"^"_$j(tchzpsum,3,2)_"^"_$j(schzpsum,3,2)    //48	
	s str=str_"^"_$j(tchybksum,3,2)_"^"_$j(schybksum,3,2)_"^"_$j(tchtcsum,3,2)_"^"_$j(schtcsum,3,2)_"^"_$j(tchlysum,3,2)_"^"_$j(schlysum,3,2)  //54	
	s str=str_"^"_$j(tchqfsum,3,2)_"^"_$j(schqfsum,3,2)_"^"_$j(tchjcsum,3,2)_"^"_$j(schjcsum,3,2)_"^"_$j(tchqtsum,3,2)_"^"_$j(schqtsum,3,2)   //60	
	s str=str_"^"_$j(xjsum,3,2)_"^"_$j(xyksum,3,2)_"^"_$j(zpsum,3,2)_"^"_$j(ybksum,3,2)_"^"_$j(tcsum,3,2)_"^"_$j(yklysum,3,2)_"^"_$j(qfsum,3,2)_"^"_$j(jcsum,3,2)_"^"_$j(qtsum,3,2)    //69   
	s str=str_"^"_feetotal_"&"_jkstdate_"^"_jkenddate
	k ^TMP("ZYJFCWPrint","chyj",job)
	k ^TMP("ZYJF","yj",job)
	k ^TMP("ZYJF","zyfp",job)
	k ^TMP("ZYJF","chfp",job)
    k ^TMP("ZYJF","chfpjs",job)
    k ^TMP("ZYJFCWPrint","JkDate",job)
    k ^TMP("ZYJF","CHFlag",job)
    q str
}

ClassMethod getinceptreport(itmjs As %Library.String = "", itmjsex As %Library.String = "", userid, jkidstr)
{
  s userid=$g(userid)
  s jkidstr=$g(jkidstr)
  q:(userid="") "1^^^^"
  q:(jkidstr="") "2^^^^"
  s jkidstr=jkidstr_"^"
  s num=$length(jkidstr,"^")
  s num=num-1
  s errnum=0, errnum1=0, errnum2=0,errnum3=0
  f i=2:1:num  d
  .s jkrowid=$p(jkidstr,"^",i)
  .i jkrowid=""  d
  ..s errnum=errnum+1
  .e  d
  ..i ($d(^DHCJFUSERJK(jkrowid))=0)!($d(^DHCJFUSERJK(jkrowid))=10)  d
  ...s errnum=errnum+1
  ..e  d
  ...s jkuser=$p(^DHCJFUSERJK(jkrowid),"^",5)
  ...s inceptflag=$p(^DHCJFUSERJK(jkrowid),"^",6)
  ...i jkuser'=userid  d
  ....s errnum1=errnum1+1
  ...i inceptflag="Y"  d
  ....s errnum2=errnum2+1
  ...s rowid=jkrowid
  ...f  s rowid=$o(^DHCJFUSERJK(0,"user",userid,rowid),-1)  q:(rowid="")!(errnum3=1)  d
  ....s inceptflag=$p(^DHCJFUSERJK(rowid),"^",6)
  ....i i=2  d
  .....s inceptflag=$p(^DHCJFUSERJK(rowid),"^",6)
  .....i inceptflag'="Y"  d
  ......s errnum3=errnum3+1
  ....e  d
  .....s rowid1="^"_rowid_"^"
  .....i (inceptflag'="Y")&(jkidstr'[rowid1)  d
  ......s errnum3=errnum3+1
  q "0^"_errnum_"^"_errnum1_"^"_errnum2_"^"_errnum3
}

ClassMethod getchinfo(admno, prtrowid, job, mode)
{
  ;在冲账合计中的数据
   s arpbl=$p(^DHCINVPRTZY(prtrowid),"^",5)
   s arrcp=""
   s prtjkdate=$p(^DHCINVPRTZY(prtrowid),"^",15)
   s prtjktime=$p(^DHCINVPRTZY(prtrowid),"^",16)
   s prtjkflag=$p(^DHCINVPRTZY(prtrowid),"^",14)
   f  s arrcp=$o(^ARRCP("ARPBL",arpbl,arrcp)) q:arrcp=""  d
   .s paym="0"
   .f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
   ..s ss=^ARRCP(arrcp,"PAYM",paym)
   ..s mode1=$p(ss,"^",1)
   ..;q:(mode'=mode1)
   ..s m2=$p(ss,"^",3)
   ..i mode1'=""  d
   ...s paydesc=$p(^CT("CTPM",mode1),"^",2)
   ..e  d
   ...s paydesc="其它"
   ..i $d(^TMP("ZYJF","chfpjs",job,admno,paydesc))'=0 d
   ...s ^TMP("ZYJF","chfpjs",job,admno,paydesc)=^TMP("ZYJF","chfpjs",job,admno,paydesc)+m2
   ..e  d
   ...s ^TMP("ZYJF","chfpjs",job,admno,paydesc)=0
   ...s ^TMP("ZYJF","chfpjs",job,admno,paydesc)=^TMP("ZYJF","chfpjs",job,admno,paydesc)+m2
   s prtflag=""
   f  s prtrowid=$o(^DHCINVPRTZY(0,"ADM",admno,prtrowid)) q:(prtrowid="")!(prtflag="N")  d
   .s prtdate=$p(^DHCINVPRTZY(prtrowid),"^",2)
   .s initial=$p(^DHCINVPRTZY(prtrowid),"^",13)
   .s prtflag=$p(^DHCINVPRTZY(prtrowid),"^",8)
   .i prtflag="I"  s prtflag="N"
   .s prtjkdate1=$p(^DHCINVPRTZY(prtrowid),"^",15)
   .s prtjktime1=$p(^DHCINVPRTZY(prtrowid),"^",16)
   .s prtjkflag1=$p(^DHCINVPRTZY(prtrowid),"^",14)
   .q:(prtjkflag'=prtjkflag1)
   .q:(prtjkdate'=prtjkdate1)
   .q:((prtjkdate=prtjkdate1)&(prtjktime'=prtjktime1))
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
   ...s mode1=$p(ss,"^",1)
   ...s m2=$p(ss,"^",3)
   ...i mode1'=""  d
   ....s paydesc=$p(^CT("CTPM",mode1),"^",2)
   ...e  d
   ....s paydesc="其它"
   ...;q:(mode'=mode1)
   ...i $d(^TMP("ZYJF","chfpjs",job,admno,paydesc))'=0 d
   ....s ^TMP("ZYJF","chfpjs",job,admno,paydesc)=^TMP("ZYJF","chfpjs",job,admno,paydesc)+m2
   ...e  d
   ....s ^TMP("ZYJF","chfpjs",job,admno,paydesc)=0
   ....s ^TMP("ZYJF","chfpjs",job,admno,paydesc)=^TMP("ZYJF","chfpjs",job,admno,paydesc)+m2
   
   q 0
}

ClassMethod putchinfo(job)
{
   ;取冲红的金额,收费员日报表中对应冲账合计
    s adm=""
	f  s adm=$o(^TMP("ZYJF","chfpjs",job,adm)) q:adm=""  d
	.s paydesc=""
	.f  s paydesc=$o(^TMP("ZYJF","chfpjs",job,adm,paydesc)) q:paydesc=""  d
	..s amt=^TMP("ZYJF","chfpjs",job,adm,paydesc)
	..i amt>0 d
	...s ^TMP("ZYJF","chfp",job,"收",paydesc)=^TMP("ZYJF","chfp",job,"收",paydesc)+amt
	..e  d
	...s ^TMP("ZYJF","chfp",job,"退",paydesc)=^TMP("ZYJF","chfp",job,"退",paydesc)-amt
   q
}

}
