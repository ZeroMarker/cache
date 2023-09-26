Import SQLUser

Class web.udhcOPHandin3 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 705;

/// /专门提供给大同医院用的操作员自己的日报
/// /报表是从宁波转换过来的zhaocz   2006-07-26
/// /
ClassMethod BuildOPINVItem(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String) As %String
{
	n (hUser, stdate, sttime, EndDate, EndTime)
	
	s rtn=0
	i (stdate'="")&(sttime'="")  d
	.s catret=..getsubcat()
	.s snum=0
	.f pdate=stdate:1:EndDate  q:(rtn'=0)  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:((PRTrowid="")!(rtn'=0))  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>EndTime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...q:Handin="Y"
	...;s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	...;s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...s myFairType=$p(^DHCINVPRT(PRTrowid),"^",34)		;PRT_FairType  34_
	...q:(myFairType="R")			;如果是挂号费用退出
	...;i PrtNO'=""  d
	...s stat=..STATtoOPCAT(PRTrowid)
	...;生成支付模式
	...;i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	...d ..ReadOPPayMode(PRTrowid, Flag, PrtinvDr)
	...
	...q:(rtn'=0)
	
	q rtn
}

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod GetDate(hUser As %String, EndDate As %String)
{
	;;w ##class(web.udhcOPHandin).GetDate("5","2005-10-24")
	;对于大同来说排出挂号
	s stdate="",sttime=""
	&sql(select max(HIS_Rowid) into:rowid
	     from DHC_INVPRTReports where HIS_User=:hUser and (HIS_Note3<>'R'))
	i rowid'="" d
	.&sql(select HIS_Date,HIS_Time into :stdate,:sttime
	      from DHC_INVPRTReports where HIS_Rowid=:rowid)
	e  d
	.;(PRT_inv<>"" or not PRT_inv is Null)
	.&sql(select min(PRT_Rowid) into :rowid from DHC_INVPRT
	      where PRT_Date<=:EndDate and PRT_Usr=:hUser and PRT_Handin is null and PRT_FairType<>"R")
	.i rowid'="" d
	..&sql(select PRT_Date,PRT_Time into:stdate,:sttime
	       from DHC_INVPRT where PRT_Rowid=:rowid)
	i stdate="" d  s stdate=+$h
	i sttime="" d  s sttime=$p($h,",",2)
	
	q stdate_"^"_sttime
}

ClassMethod GetHandin(itmjs As %Library.String = "", itmjsex As %Library.String = "", hUser As %String)
{
	;, EndDate As %String, EndTime As %String
	;调试代码
	;w ##class(web.udhcOPHandin3).GetHandin("","","996")
	;w ##class(web.udhcOPHandin).KillTmp()
	;^TMPHandin=5%%%
	
	d ..KillTmp()

	s ToPaySum=0		;医疗费用支付总额?
	
	s handinsum=0 ;应上交金额
	s handcash=0  ;应上交现金
	s handcheck=0 ;应上交支票
	s checknum=0  ;支票张数
	s cashnum=0   ;现金张数
	
	;费用总额变量
	s FootTotSum=0		;结算总费用
	s TotSum=0		;;总的金额	没有任何折扣之前
	s AbTotSum=0	;
	s RefTotSum=0	;
	
	;患者支付额度
	s PatPaySum=0	;患者支付金额?现金或支票?
	s PatPCash=0	;上交现金
	s PatPcheck=0	;上交支票
	s AbPatPaySum=0		;红冲?患者支付?
	s RefPatPaySum=0	;作废?患者支付?
	
	s RefundINVInfo=""		;红冲票据号码
	s ParkINVInfo=""		;作废票据号码
	
	s cancelnum=0,cancelsum=0   ;作废张数?作废金额
	s refundnum=0,refundsum=0   ;红冲张数?红冲金额
	s sksum=0,tksum=0           ;收款金额?退款金额
	s jybs=0,INVNOinfo="" 
	;s ^gwj=hUser_"^"_EndDate_"^"_EndTime                 ; 交易笔数
	s EndDate=+$h		;$zdh(EndDate,3)
	s EndTime=$p($h,",",2)			;$zth(EndTime,1)
	
	;s EndDate=+$h-1
	;s EndTime=$zt("7:48:14",3)
	
	
	s sttimeinfo=..GetDate(hUser,EndDate)
	s stdate=$p(sttimeinfo,"^",1)
	s sttime=$p(sttimeinfo,"^",2)
	i (stdate'="")&(sttime'="")  d
	.s catret=..getsubcat()
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>EndTime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...q:Handin="Y"
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...s myFairType=$p(^DHCINVPRT(PRTrowid),"^",34)		;PRT_FairType  34_
	...q:(myFairType="R")			;如果是挂号费用退出
	...i PrtNO'=""  d
	....s snum=snum+1
	....s ^TMPOPHand($j,"INV",snum)=PrtNO
	....s ^TMPOPHand($j,"INVNO",PrtNO)=Flag			;;按照票据号码生成Global
	...s stat=..STATtoOPCAT(PRTrowid)
	...;b  ;;;Debug
	...;本收款员收取的票据?
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
	....;b  ;;;;;Normal  Invoice
	....s PatPaySum=PatPaySum+$g(PrtPatPay)
	....s TotSum=TotSum+$g(PRTAcount)
	....;s handinsum=handinsum+PRTAcount
	....;s sksum=sksum+PRTAcount
	....s jybs=jybs+1
	....;
	...;本收款员作废的单据?	下面的数据都依存于原帐单?
	...i (Flag="A")&&(PrtinvDr'="")  d
	....;重新写的作废单据
	....s AbPatPaySum=AbPatPaySum+$g(PrtPatPay)
	....s AbTotSum=AbTotSum+$g(PRTAcount)
	....s ParkPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;作废票据的原票据号码?
	....s ParkINVInfo=ParkINVInfo_" "_ParkPrtNO_", "
	....s cancelnum=cancelnum+1
	....s cancelsum=cancelsum+PRTAcount
	....s tksum=tksum+PRTAcount
	....s jybs=jybs+1
	...;本收款员红冲得单据   
	...i (Flag="S")&&(PrtinvDr'="")  d
	....;重新写的红冲单据
	....s RefPatPaySum=RefPatPaySum+$g(PrtPatPay)
	....s RefTotSum=RefTotSum+$g(PRTAcount)
	....s RefundPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;红冲票据的原票据号码?
	....s RefundINVInfo=RefundINVInfo_" "_RefundPrtNO_", "
	....s refundnum=refundnum+1
	....s refundsum=refundsum+$ZABS(PRTAcount)
	....s tksum=tksum+$ZABS(PRTAcount)
	...;取支付模式 对于收费的发票
	...;i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	...d ..ReadOPPayMode(PRTrowid, Flag, PrtinvDr)
	...;s PRTARRCPDR=$p(^DHCINVPRT(PRTrowid),"^",2)
	.i snum>0  d
	..s INVNOinfo=..GetINVNOinfo(snum)
	
	s myPosNum=0
	s myPosSum=0
	s myOtherNum=0
	s myOtherSum=0
	s myPMDR=0
	s myXRYBNum=0
	s myXRYBSum=0
	s myCPPNum=0
	s myCPPSum=0
	s myGFJZNum=0
	s myGFJZSum=0
	s myTJNum=0
	s myTJSum=0
	s myHTDWNum=0
	s myHTDWSum=0
	
	f  s myPMDR=$o(^TMPOPPayMode($j,myPMDR)) q:(myPMDR="")  d
	.q:(myPMDR="YB")
	.s myAmt=+$g(^TMPOPPayMode($j,myPMDR))
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.;现金=自费患者金额 + 医保自付金额
	.i myPMCode="CASH"  d
	..s handcash=handcash+myAmt
	..s cashnum=+cashnum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.;支票
	.i myPMCode="CHEQUES" d
	..s handcheck=handcheck+myAmt
	..s checknum=+checknum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.;新荣医保  XRYB
	.i myPMCode="XRYB" d
	..s myXRYBNum=+myXRYBNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myXRYBSum=myXRYBSum+myAmt
	.;老干保健  CPP  使用医院的账户支付
	.i myPMCode="CPP" d
	..s myCPPNum=+myCPPNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myCPPSum=myCPPSum+myAmt
	.;公费记帐  GFJZ
	.i myPMCode="GFJZ" d
	..s myGFJZNum=+myGFJZNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myGFJZSum=myGFJZSum+myAmt
	.;体检  TJ
	.i myPMCode="TJ" d
	..s myTJNum=+myTJNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myTJSum=myTJSum+myAmt
	.;合同单位  HTDW
	.i myPMCode="HTDW" d
	..s myHTDWNum=+myHTDWNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myHTDWSum=myHTDWSum+myAmt
	.;i (("^CASH^POS^CHEQUES^")'[("^"_myPMCode_"^")) d
	
	s YBCash=0
	s YBCashnum=0
	s myYBNum=0
	s myYBSum=0
	
	s myPMDR=0
	f  s myPMDR=$o(^TMPOPPayMode("YB",$j,myPMDR)) q:(myPMDR="")  d
	.;医保费用特殊处理
	.s myAmt=+$g(^TMPOPPayMode("YB",$j,myPMDR))
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.;现金= 医保自付金额
	.i myPMCode="CASH"  d
	..s YBCash=YBCash+myAmt
	..s YBCashnum=+YBCashnum+$g(^TMPOPPayMode("YB",$j,myPMDR,"Num"))
	.i (myPMCode="INSU1")!(myPMCode="INSU2") d
	..s myYBNum=+myYBNum+$g(^TMPOPPayMode("YB",$j,myPMDR,"Num"))
	..s myYBSum=myYBSum+myAmt
	
	;费用总额
	s FootTotSum=$fn(TotSum+AbTotSum+RefTotSum,"",2)
	
	;s handinsum=$fn(PatPaySum+AbPatPaySum+RefPatPaySum,"",2)		;应上交金额
	;应该上缴的现金
	s handinsum=$fn(+handcash+YBCash, "",2)
	
	s tksum=$fn(AbPatPaySum+RefPatPaySum,"",2)						;总退款
	s sksum=$fn(PatPaySum,"",2)		;总收款
	
	;公费总额
	s PayorSum= $fn(FootTotSum-handinsum,"",2)
	
	s refundsum=$fn(RefPatPaySum,"",2)		;
	s cancelsum=$fn(AbPatPaySum,"",2)		;
	
	s handcash=$fn(handcash,"",2)
	s handcheck=$fn(handcheck,"",2)
	
	s CurDate=$zd(EndDate,4)		;返回当前日期
	s CurTime=$zt(EndTime,1)		;返回当前时间
	s ret=$ZD(stdate,4)_"^"_$zt(sttime,1)_"^"_INVNOinfo_"^"_cashnum_"^"_checknum	;0-4
	s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	s ret=ret_"^"_handcash_"^"_handcheck_"^"_sksum_"^"_tksum_"^"_jybs_"^"_CurDate	;10-15
	s ret=ret_"^"_CurTime_"^"_FootTotSum		;16-17
	s ret=ret_"^"_$fn(PayorSum,"",2)_"^"_RefundINVInfo_"^"_ParkINVInfo	;18-20
	s myOthPayInfo=myPosNum_"^"_$fn(myPosSum,"",2)_"^"_myOtherNum_"^"_$fn(myOtherSum,"",2)
	
	;myXRYBNum
	s myOthPayInfo=myOthPayInfo_"^"_myXRYBNum_"^"_$fn(myXRYBSum,"",2)_"^"_myCPPNum_"^"_$fn(myCPPSum,"",2)
	s myOthPayInfo=myOthPayInfo_"^"_myGFJZNum_"^"_$fn(myGFJZSum,"",2)_"^"_myTJNum_"^"_$fn(myTJSum,"",2)
	s myOthPayInfo=myOthPayInfo_"^"_myHTDWNum_"^"_$fn(myHTDWSum,"",2)_"^"_YBCashnum_"^"_$fn(YBCash,"",2)
	s myOthPayInfo=myOthPayInfo_"^"_myYBNum_"^"_$fn(myYBSum,"",2)_"^"_YBCashnum
	
	b	;
	
	s ret=ret_"^"_myOthPayInfo
	
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	s myFootFlag=0
	i ((+myXRYBNum'=0)||(+myCPPNum'=0)||(+myGFJZNum'=0)||(+myTJNum'=0)||(+myHTDWNum'=0)||(+myYBNum'=0)) d
	.s myFootFlag=1
	
	;验证是否能结算?
	i ((+myFootFlag)||(+cashnum'=0)||(+checknum'=0)||(+cancelnum'=0)||(+refundnum'=0)||(+myPosNum'=0)||(+myOtherNum'=0)) d
	.s rtn=0
	e  d
	.s rtn=1
	
	d ..KillTmp()
	
	quit rtn
}

ClassMethod GetINVNOinfo(znum As %String) As %String
{
	;w ##class(web.udhcOPHandin).GetINVNOinfo("1")
	s INVNOinfo=""
	s Count = 0,newflag=0
	s num=0 f  s num=$o(^TMPOPHand($j,"INV",num)) q:num=""  d
	.s invtmp=^TMPOPHand($j,"INV",num)
	.i (num=1)!(newflag=1)  d
	..s newflag=0
	..s startno = invtmp
	..s endno = invtmp
	..s lenReceipNo = $l(startno)
	.i $d(^TMPOPHand($j,"INV",num+1))'=0  d
	..s newinv=^TMPOPHand($j,"INV",num+1)
	..i (+newinv-1=+endno)  d
	...s endno=endno+1
	..e  d
	...s Count=Count+1
	...s endno=..FormatINVNO(endno,lenReceipNo)
	...s INVNOinfo = INVNOinfo _"  "_startno_"--"_endno_", "
	...s startno="", endno=""
	...s newflag=1
	
	i (INVNOinfo="")!(Count >= 1) d
	.s endno=..FormatINVNO(endno,lenReceipNo)
	.s INVNOinfo = INVNOinfo_"  "_startno_"--"_endno
	q INVNOinfo
}

ClassMethod GetSTATCATinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	s STATCATinfo=""
	s cat="" f  s cat=$o(^TMPOPHandsub($j,cat)) q:cat=""  d
	.s tot=^TMPOPHandsub($j,cat)
	.i STATCATinfo=""  s STATCATinfo=cat_"^"_tot
	.e  s STATCATinfo=STATCATinfo_"||"_cat_"^"_tot
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	q 0
}

ClassMethod Handin(sUser As %String, FootInfo As %String)
{
	;Sum As %String, EndDate As %String, EndTime As %String, StDate As %String, 
	;StTime As %String, Rcptno As %String, jynum As %String
	;23298%%%^^^^04/08/2006^22:53:21^08/08/2006^17:29:53^150.00^23298^4^  000000024--000000027^^^^^^100.00^3^100.00^0^0.00^0^0.00^1^-50.00^ 000000027, ^^0^0.00^^0.00^1^50.00^0.00^0^0.00^0^0.00^0^0.00^0^^^^^^^^^^^^^^^^^^^^U
	;w ##class(web.udhcOPHandin4).GetHandin("","","9937")
	;w ##class(web.udhcOPHandinIF).Handin("23298","^^^^04/08/2006^22:53:21^08/08/2006^17:29:53^150.00^23298^4^  000000024--000000027^^^^^^100.00^3^100.00^0^0.00^0^0.00^1^-50.00^ 000000027, ^^0^0.00^^0.00^1^50.00^0.00^0^0.00^0^0.00^0^0.00^0^^^^^^^^^^^^^^^^^^^^U")
	s ^TMPHandin=sUser_"%%%"_FootInfo
	
	b		;;;Handin3
	s $ZT="ERROR^DHCSSERR"
	
	s StDate=$zdh($p(FootInfo,"^",5),4)
	s StTime=$zth($p(FootInfo,"^",6),1)
	
	s EndDate=$zdh($p(FootInfo,"^",7),4)
	s EndTime=$zth($p(FootInfo,"^",8),1)
	
	s hdate=+$h
	s htime=$p($h,",",2)
	
	d ..KillTmp()
	
	;把发票重新生成，门诊大类项目
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)
	
	b		;;;Handin32
	q:(myrtn) myrtn_"^"
	
	d ..tb()

	k PLIST
	
	s mylen=$l(FootInfo,"^")
	f i=2:1:mylen  d
	.s myValue=$p(FootInfo,"^",i)
	.i myValue'="" d
	..s PLIST(i-1)=myValue
	
	k PLIST(1)
	;日期格式转换
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=$zdh(PLIST(4),4)		;HIS_StartDate
	s PLIST(5)=$zth(PLIST(5),1)		; HIS_StartTime
	s PLIST(6)=$zdh(PLIST(6),4)		;HIS_EndDate
	s PLIST(7)=$zth(PLIST(7),1)		;HIS_EndTime
	
	s StDate=PLIST(4)
	s StTime=PLIST(5)
	s EndDate=PLIST(6)
	s EndTime=PLIST(7)
	
	b		;;;b
	;结算主表
	s mycat=""
	s mycatsub=""
	s HISParref=""
	s myrtn=##class(web.UDHCINVPRTReports).Insert()
	i myrtn=0 d
	.s HISParref=PLIST(1)
	
	b ;;;;;主表
	i myrtn=0 d
	.;门诊类别大类和子类表
	.;^TmpCatSub($j,ItmOPCat,ItmOPSubCat)
	.f  s mycat=$o(^TMPCatSub($j,mycat)) q:(mycat=""||myrtn'=0)  d
	..s mycatsub=""
	..f  s mycatsub=$o(^TMPCatSub($j,mycat,mycatsub)) q:(mycatsub=""||myrtn'=0)  d
	...s myPatpay=$g(^TMPCatSub($j,mycat,mycatsub))
	...k PLIST
	...
	...s PLIST(0)=HISParref
	...s PLIST(3)=mycat
	...s PLIST(4)=$fn(myPatpay,"",2)
	...s PLIST(5)=mycatsub
	...s myrtn=##class(web.UDHCINVPRTReportsSub).Insert()
	
	;写入支付模式子表
	i myrtn=0 d
	.s myPMDR=0
	.f  s myPMDR=$o(^TMPOPPayMode($j,myPMDR)) q:((myPMDR="")||(myrtn'=0))  d
	..s myPMSum=+$g(^TMPOPPayMode($j,myPMDR))
	..s myPMNum=+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..k PLIST
	..s PLIST(0)=HISParref
	..s PLIST(3)=myPMSum
	..s PLIST(4)=myPMDR
	..s PLIST(7)=myPMNum
	..s myrtn=##class(web.UDHCINVPRTReportsPaymode).Insert()
	
	b	;;;;;;
	;更新票据流水表
	; and ((PRT_FairType<>"R") or (PRT_FairType is null))
	i myrtn=0 d
	.&sql(update DHC_INVPRT set PRT_DHCINVPRTR_DR=:HISParref,PRT_Handin='Y',PRT_HandinDate=:hdate,PRT_HandinTime=:htime
	      where (PRT_Usr=:sUser and PRT_Handin is null and 
	      ((PRT_Date>=:StDate and PRT_Date<:EndDate) or
	       (PRT_Date=:EndDate and PRT_Time<=:EndTime)) and ((PRT_FairType<>'R') or (PRT_FairType is null))))
	.s myrtn=SQLCODE
	
	b	;;;Tro
	
	i myrtn=0 d
		.d ..tc()
	e  d
		.Trollback
	
	d ..KillTmp()
	
	quit myrtn_"^"_HISParref
}

ClassMethod KillTmp()
{
	k ^TMPOPHand($j)
	k ^TMPOPHandsub($j)
	k ^TMPCatSub($j)
	k ^TMPCatSubOther($j)
	k ^TMPOPCat($j)
	k ^TMPOPPayMode($j)
	k ^TMPOPPayMode("YB", $j)
}

ClassMethod ReadOPPayMode(PRTRowID As %String = "", Flag As %String, PrtinvDr As %String) As %String
{
	n (PRTRowID, Flag, PrtinvDr)
	
	;(PRTrowid, Flag, PrtinvDr)
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	q:'$d(^DHCINVPRT(PRTRowID,"P"))
	s myPMSub=0
	s myYBFlag=0
	
	;判断当前发票中是否有医保支付
	;"INSU1")!(myPMCode=""
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.q:($d(^DHCINVPRT(PRTRowID,"P",myPMSub))=10)
	.s myTmpPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)
	.s myPMCode=$p(^CT("CTPM",myTmpPMDR),"^",1)
	.i (myPMCode="INSU2")!(myPMCode="INSU1") d
	..s myYBFlag=1
	
	s myPMSub=0	
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.q:($d(^DHCINVPRT(PRTRowID,"P",myPMSub))=10)
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.q:(myPMDR="")
	.i myYBFlag=1 d
	..;医保处理
	..s ^TMPOPPayMode("YB",$j,myPMDR)=+$g(^TMPOPPayMode("YB",$j,myPMDR))+myPMSum
	.q:(myYBFlag=1)
	.s ^TMPOPPayMode($j,myPMDR)=+$g(^TMPOPPayMode($j,myPMDR))+myPMSum
	.i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	..s ^TMPOPPayMode($j,myPMDR,"Num")=+$g(^TMPOPPayMode($j,myPMDR,"Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPPayMode($j,myPMDR,"PM")=myPMDesc
	
	;;医保发票特殊处理
	i (myYBFlag=1)&((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	.s ^TMPOPPayMode("YB",$j,myPMDR,"Num")=+$g(^TMPOPPayMode("YB",$j, myPMDR,"Num"))+1
	
	q 0
}

ClassMethod ReadUFCat(RepID As %String = "") As %String
{
	;读取门诊费用大类   RepID As %String = ""
	;w ##class(web.udhcOPHandin).ReadUFCat()
	s CatData=""
	;^DHCTarC("TOC",0,"Code",4,4)=
	;^TMPOPCat($j,ItmOPCat)
	s mycode=""
	f  s mycode=$o(^DHCTarC("TOC",0,"Code",mycode)) q:mycode=""  d
	.s myrowid=""
	.f  s myrowid=$o(^DHCTarC("TOC",0,"Code",mycode,myrowid)) q:myrowid=""  d
	..s catdesc=$p(^DHCTarC("TOC",myrowid),"^",2)
	..i CatData="" d
	...s CatData=catdesc_$c(2)_$fn(+$g(^TMPOPCat($j,myrowid)),"",2)
	..e  d
	...s CatData=CatData_"^"_catdesc_$c(2)_$fn(+$g(^TMPOPCat($j,myrowid)),"",2)
	
	quit CatData
}

ClassMethod ReadUFSubCat() As %String
{
	;读取门诊费用子类
	;w ##class(web.udhcOPHandin).ReadUFSubCat()
	s CatData=""
	;^DHCTarC("OC",0,"Code","10a",40)
	s mycode=""
	f  s mycode=$o(^DHCTarC("OC",0,"Code",mycode)) q:mycode=""  d
	.s myrowid=""
	.f  s myrowid=$o(^DHCTarC("OC",0,"Code",mycode,myrowid)) q:myrowid=""  d
	..s subcatdesc=$p(^DHCTarC("OC",myrowid),"^",2)
	..i CatData="" d
	...s CatData=subcatdesc_$c(2)_$fn(+$g(^TMPCatSubOther($j,"SubCat",myrowid)),"",2)
	..e  d
	...s CatData=CatData_"^"_subcatdesc_$c(2)_$fn(+$g(^TMPCatSubOther($j,"SubCat",myrowid)),"",2)
	
	quit CatData
}

ClassMethod STATtoOPCAT(INVPRTRowid As %String)
{
	;把一张票据转化为门诊收费大类或子类
	;
	s conRowid=0 F  S conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) Quit:conRowid=""  d
	.S Bill=$p(^DHCBCI(conRowid),"^",2)
	.q:'$D(^DHCPB(Bill))
	.S Ord="" F  S Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	..S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	...;b DHC_TarOutpatCate	  DHC_TarOC
	...S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	...S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	...S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	...S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	...S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	...S ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	...q:$g(ItmOPSubCat)=""
	...s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	...S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	...q:$g(ItmOPCat)=""
	...s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	...s totmp=+$g(^TMPOPHandsub($j,OPCatDesc))
	...s totmp=totmp+TotalAmount
	...;定义一个^TmpCatSub($j,Cat,CatSub)
	...s ^TMPCatSub($j,ItmOPCat,ItmOPSubCat)=+$g(^TMPCatSub($j,ItmOPCat,ItmOPSubCat))+TotalAmount
	...s ^TMPCatSubOther($j,"SubCat",ItmOPSubCat)=+$g(^TMPCatSubOther($j,"SubCat",ItmOPSubCat))+TotalAmount
	...s ^TMPOPHandsub($j,OPCatDesc)=totmp
	...s ^TMPOPCat($j,ItmOPCat)=+TotalAmount+$g(^TMPOPCat($j,ItmOPCat))
	q 0
}

ClassMethod UnFootINV(hUser As %String, Begdate As %String, BegTime As %String, EndDate, EndTime As %String) As %String
{
	s Begdate=$zdh(Begdate,4)
	s BegTime=$zth(BegTime,1)
	s EndDate=$zdh(EndDate,4)
	s EndTime=$zth(EndTime,1)
	
	f pdate=Begdate:1:EndDate  d
	.q:$d(^DHCINVPRT(0,"Date",pdate))=0
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d  
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..q:PRTUser'=hUser
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..q:(pdate=EndDate)&(PRTTime>EndTime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..q:Handin="Y"
	..s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	..s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	..s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	..s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	..s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	..
	
	quit 0
}

ClassMethod getsubcat() As %String
{
	;;门诊收费大类或子类?最好是子类
	s n=1
	s ret=""
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TOC",itmrowid),"^",2)
	.i $g(^TMPOPHandsub($j))="" s ^TMPOPHandsub($j)=0
	.s ^TMPOPHandsub($j,itm)=0
	.i $g(^TMPdhcsfdaily1)="" s ^TMPdhcsfdaily1=0
	.s ^TMPdhcsfdaily1(n)=itmrowid
	.i ret=""  s ret=itm
	.e  s ret=ret_"^"_itm
	.s ^TMPOPHandsub($j)=n
	.s ^TMPdhcsfdaily1=n
	.s n=n+1
	q ret
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
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
