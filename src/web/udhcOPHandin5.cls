Import SQLUser

Class web.udhcOPHandin5 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 468;

/// /西安门诊日报表
/// /
/// /************************************************************
/// /利用JS文件分次把数据传出去；传到界面上，生成二维表格
/// /生成临时Global:
/// /^TMPOPTARPAYMODE($j, UserID, TECarRowID, PayModeDR)=金额
/// /把数据写到界面上；
/// /形成一个新的表结构：
/// /
/// /************************************************************
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
	...;s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	...;s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...;s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...;i PrtNO'=""  d
	...s stat=..STATtoOPCAT(PRTrowid)
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
	s stdate="",sttime=""
	&sql(select max(HIS_Rowid) into:rowid            
	     from DHC_INVPRTReports where HIS_User=:hUser)
	i rowid'="" d
	.&sql(select HIS_EndDate,HIS_EndTime into :stdate,:sttime
	      from DHC_INVPRTReports where HIS_Rowid=:rowid)
	e  d
	.&sql(select min(PRT_Rowid) into :rowid from DHC_INVPRT
	      where PRT_Date<=:EndDate and PRT_Usr=:hUser and PRT_Handin is null)
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
	;w ##class(web.udhcOPHandin5).GetHandin("","","163")
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
	s EndDate=+$h		;$zdh(EndDate,3)
	s EndTime=$p($h,",",2)			;$zth(EndTime,1)
	s sttimeinfo=..GetDate(hUser,EndDate)
	s stdate=$p(sttimeinfo,"^",1)
	s sttime=$p(sttimeinfo,"^",2)
	i (stdate'="")&(sttime'="")  d
	.s catret=..getsubcat()
	.d ..GetOECCat(hUser)
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
	...i PrtNO'=""  d
	....s snum=snum+1
	....s ^TMPOPHand($j,"INV",snum)=PrtNO
	....s ^TMPOPHand($j,"INVNO",PrtNO)=Flag			;;按照票据号码生成Global
	...s stat=..STATtoOPCAT(PRTrowid)
	...d ..SetTarTOECat(PRTrowid, hUser)
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
	....;s stat=..STATtoOPCAT(PRTrowid)
	...s paysub=0
	...f  s paysub=$o(^DHCINVPRT(PRTrowid,"P",paysub)) q:paysub=""  d
	....q:($d(^DHCINVPRT(PRTrowid,"P",paysub))=10)
	....s PayModeDR=$p($g(^DHCINVPRT(PRTrowid,"P",paysub)),"^",1)
	....s PayAmt=$p($g(^DHCINVPRT(PRTrowid,"P",paysub)),"^",3)
	....s PayMode=$p(^CT("CTPM",PayModeDR),"^",1)
	....q:'(((Flag="N")||((PrtinvDr="")&&(Flag'="N"))))
	....i PayMode="CASH" d
	.....s handcash=handcash+PayAmt
	.....s cashnum=cashnum+1
	....e  d
	.....;非现金，统筹
	.....s handcheck=handcheck+PayAmt
	.....s checknum=checknum+1
	.i snum>0  d
	..s INVNOinfo=..GetINVNOinfo(snum)
	
	;费用总额
	s FootTotSum=$fn(TotSum+AbTotSum+RefTotSum,"",2)
	
	s handinsum=$fn(PatPaySum+AbPatPaySum+RefPatPaySum,"",2)		;应上交金额
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
	s myHandPY=##class(web.UDHCOPINVPrtIF).RMBConvert(+handinsum)
	
	s ret=$ZD(stdate,4)_"^"_$zt(sttime,1)_"^"_INVNOinfo_"^"_cashnum_"^"_checknum	;0-4
	s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	s ret=ret_"^"_handcash_"^"_handcheck_"^"_sksum_"^"_tksum_"^"_jybs_"^"_CurDate	;10-15
	s ret=ret_"^"_CurTime_"^"_FootTotSum		;16-17
	s ret=ret_"^"_$fn(PayorSum,"",2)_"^"_RefundINVInfo_"^"_ParkINVInfo	;18-20
	s ret=ret_"^"_myHandPY
	
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	;验证是否能结算?
	
	;把得到的二维表传出；
	;^TMPOPTARPAYMODE($j, UserID, TECarRowID, PayModeDR)
	s myIdx=0
	s myTarRowID=0
	s myToHJ=0
	s myPatHJ=0
	s myRefCashHJ=0
	s myRefTCHJ=0
	s myRefChequeHJ=0
	s myRefSTCHJ=0
	s myRefYLHJ=0
	
	s myCashHJ=0
	s myTCHJ=0
	s myChequeHJ=0
	s mySTCHJ=0
	s myYLHJ=0
	
	B ;HAHA
	f  s myTarRowID=$o(^TMPOPTARPAYMODE($j, hUser,myTarRowID)) q:(myTarRowID="")  d
	.;支付模式
	.s myPMDR=0
	.s myTECDesc=$g(^TMPOPTARPAYMODE($j, hUser,myTarRowID))
	.s myToSum=+$g(^TMPOPTARPAYMODE($j,"PT", hUser,myTarRowID, "TP"))		;支付全额
	.s myToHJ=+myToHJ+myToSum
	.s myPatSum=+$g(^TMPOPTARPAYMODE($j,"PT",hUser,myTarRowID, "PP"))		;患者支付额
	.s myPatHJ=myPatHJ+myPatSum
	.s myRefCashSum=0
	.s myRefTCSum=0
	.s myRefChequeSum=0
	.s myRefSTCSum=0
	.s myRefYLSum=0
	.
	.s myCashSum=0
	.s myTCSum=0
	.s myChequeSum=0
	.s mySTCSum=0
	.s myYLSum=0
	.
	.
	.f  s myPMDR=$o(^TMPOPTARPAYMODE($j, hUser,myTarRowID, myPMDR)) q:(myPMDR="")  d
	..s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	..s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	..i myPMCode="CASH" d
	...;现金
	...s myCashSum=$g(myCashSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "N"))
	...s myRefCashSum=$g(myRefCashSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "A"))
	..i myPMCode="TCGZ" d
	...;统筹
	...s myTCSum=$g(myTCSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "N"))
	...s myRefTCSum=$g(myRefTCSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "A"))
	..i myPMCode="CHEQUES" d
	...;支票
	...s myChequeSum=$g(myChequeSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "N"))
	...s myRefChequeSum=$g(myRefChequeSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "A"))
	..i myPMCode="YBCITYTC" d
	...;市统筹
	...s mySTCSum=$g(mySTCSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "N"))
	...s myRefSTCSum=$g(myRefSTCSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "A"))
	..i myPMCode="UNIONPAY" d
	...;银联
	...s myYLSum=$g(myYLSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "N"))
	...s myRefYLSum=$g(myRefYLSum)+$g(^TMPOPTARPAYMODE($j, hUser, myTarRowID, myPMDR, "A"))
	.
	.
	.s myRefCashHJ=myRefCashHJ+myRefCashSum
	.s myRefTCHJ=myRefTCHJ+myRefTCSum
	.s myRefChequeHJ=myRefChequeHJ+myRefChequeSum
	.s myRefSTCHJ=myRefSTCHJ+myRefSTCSum
	.s myRefYLHJ=myRefYLHJ+myRefYLSum
	.s myCashHJ=myCashHJ+myCashSum
	.s myTCHJ=myTCHJ+myRefTCSum
	.s myChequeHJ=myChequeHJ+myChequeSum
	.s mySTCHJ=mySTCHJ+mySTCSum
	.s myYLHJ=myYLHJ+myYLSum
	.
	.s myIdx=myIdx+1
	.s myToSum=$fn(myToSum,"",2)
	.s myRefCashSum=$fn(myRefCashSum,"",2)
	.s myRefTCSum=$fn(myRefTCSum,"",2)
	.
	.s myRefChequeSum=$fn(myRefChequeSum,"",2)
	.s myRefSTCSum=$fn(myRefSTCSum,"",2)
	.s myRefYLSum=$fn(myRefYLSum,"",2)
	.
	.s myCashSum=$fn(myCashSum,"",2)
	.s myTCSum=$fn(+myTCSum,"",2)
	.s myPatSum=$fn(myPatSum,"",2)
	.s myChequeSum=$fn(myChequeSum,"",2)
	.s mySTCSum=$fn(mySTCSum,"",2)
	.s myYLSum=$fn(myYLSum,"",2)
	.
	.s ret=myIdx_"^"_myTECDesc_"^"_myToSum
	.s ret=ret_"^"_myRefCashSum_"^"_myRefTCSum_"^"_myRefChequeSum_"^"_myRefSTCSum_"^"_myRefYLSum
	.s ret=ret_"^"_myCashSum_"^"_myTCSum_"^"_myChequeSum_"^"_mySTCSum_"^"_myYLSum
	.s ret=ret_"^"_myPatSum
	.s retval=itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	.&javascript<#(retval)#>
	
	;增加合计
	s myToHJ=$fn(myToHJ,"",2)
	s myPatHJ=$fn(myPatHJ,"",2)
	s myRefCashHJ=$fn(myRefCashHJ,"",2)
	s myRefTCHJ=$fn(myRefTCHJ,"",2)
	s myRefChequeHJ=$fn(myRefChequeHJ,"",2)
	s myRefSTCHJ=$fn(myRefSTCHJ,"",2)
	s myRefYLHJ=$fn(myRefYLHJ,"",2)
	
	s myCashHJ=$fn(myCashHJ,"",2)
	s myTCHJ=$fn(myTCHJ,"",2)
	s myChequeHJ=$fn(myChequeHJ,"",2)
	s mySTCHJ=$fn(mySTCHJ,"",2)
	s myYLHJ=$fn(myYLHJ,"",2)


	s ret="^合计^"_myToHJ_"^"_myRefCashHJ_"^"_myRefTCHJ_"^"_myRefChequeHJ_"^"_myRefSTCHJ_"^"_myRefYLHJ
	s ret=ret_"^"_myCashHJ_"^"_myTCHJ_"^"_myChequeHJ_"^"_mySTCHJ_"^"_myYLHJ_"^"_myPatHJ
	s retval=itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	
	i ((+cashnum'=0)||(+checknum'=0)||(+cancelnum'=0)||(+refundnum'=0)) d
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
	;w ##class(web.udhcOPHandin).GetHandin("","","9937")
	;w ##class(web.udhcOPHandinIF).Handin("23298","^^^16/08/2006^14:10:29^16/08/2006^22:58:15^99.98^23298^0^  000000039--000000041^^^^^^99.98^0^0.00^0^0.00^0^0.00^1^-50.00^ 000000039, ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^U")
	;
	s ^TMPHandin=sUser_"%%%"_FootInfo
	
	;s $ZT="ERROR^DHCSSERR"
	
	s StDate=$zdh($p(FootInfo,"^",5),4)
	s StTime=$zth($p(FootInfo,"^",6),1)
	
	s EndDate=$zdh($p(FootInfo,"^",7),4)
	s EndTime=$zth($p(FootInfo,"^",8),1)
	
	s hdate=+$h
	s htime=$p($h,",",2)
	
	;Q:$d(^TMPOPCat($j))=0 1
	;q:$d(^TMPCatSub($j))=0 1
	
	d ..KillTmp()
	
	;把发票重新生成，门诊大类项目
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)
	
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
	
	b ;;;;;
	i myrtn=0 d
	.;门诊类别大类和子类表
	.;^TmpCatSub($j,ItmOPCat,ItmOPSubCat)
	.f  s mycat=$o(^TMPCatSub($j,mycat)) q:(mycat=""||myrtn'=0)  d
	..s mycatsub=""
	..f  s mycatsub=$o(^TMPCatSub($j,mycat,mycatsub)) q:(mycatsub=""||myrtn'=0)  d
	...s myPatpay=$g(^TMPCatSub($j,mycat,mycatsub))
	...k PLIST
	...b   
	...s PLIST(0)=HISParref
	...s PLIST(3)=mycat
	...s PLIST(4)=$fn(myPatpay,"",2)
	...s PLIST(5)=mycatsub
	...s myrtn=##class(web.UDHCINVPRTReportsSub).Insert()
	
	b	;;;;;;
	;更新票据流水表
	i myrtn=0 d
	.&sql(update DHC_INVPRT set PRT_DHCINVPRTR_DR=:HISParref,PRT_Handin='Y',PRT_HandinDate=:hdate,PRT_HandinTime=:htime
	      where (PRT_Usr=:sUser and PRT_Handin is null and 
	      ((PRT_Date>=:StDate and PRT_Date<:EndDate) or
	       (PRT_Date=:EndDate and PRT_Time<=:EndTime)) ))
	.s myrtn=SQLCODE
	
	b		;Tro
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
	k ^TMPOPTARPAYMODE($j)
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

ClassMethod STATtoOPCAT(INVPRTRowid As %String) As %String
{
	n (INVPRTRowid, UserID)
	;把一张票据转化为门诊收费大类或子类

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

ClassMethod SetTarTOECat(PRTRowID As %String, UserID As %String) As %String
{
	n (PRTRowID, UserID)
	
	s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",0))
	s myPMDR=$p($g(^DHCINVPRT(PRTRowID,"P",myPMSub)),"^",1)
	q:myPMDR=""
	
	s conRowid=0 F  S conRowid=$o(^DHCBCI(0,"INV",PRTRowID,conRowid)) Quit:conRowid=""  d
	.S Bill=$p(^DHCBCI(conRowid),"^",2)
	.q:'$D(^DHCPB(Bill))
	.S Ord="" F  S Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	..S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	...S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	...S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	...S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	...S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	...S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	...;生成核算大类
	...s myTECSubCat=$p(^DHCTARI(ItmDr),"^",16)		;TARI_EMCCate
	...q:(myTECSubCat="")
	...s myTECCat=$p($g(^DHCTarC("EC",myTECSubCat)),"^",3)
	...q:(myTECCat="")
	...;患者支付额
	...s ^TMPOPTARPAYMODE($j,"PT",UserID,myTECCat,"PP")=$g(^TMPOPTARPAYMODE($j,"PT", UserID, myTECCat,"PP"))+PatientShare
	...;支付总额
	...s ^TMPOPTARPAYMODE($j,"PT",UserID,myTECCat,"TP")=$g(^TMPOPTARPAYMODE($j,"PT", UserID, myTECCat,"TP"))+TotalAmount
	...i (+PatientShare>0) d
	....s ^TMPOPTARPAYMODE($j, UserID, myTECCat, myPMDR, "N")=$g(^TMPOPTARPAYMODE($j, UserID, myTECCat, myPMDR, "N"))+PatientShare
	...e  d
	....s ^TMPOPTARPAYMODE($j, UserID, myTECCat, myPMDR, "A")=$g(^TMPOPTARPAYMODE($j, UserID, myTECCat, myPMDR, "A"))+PatientShare
	
	q
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

ClassMethod GetOECCat(UserDR As %String) As %String
{
	////按照核算大类拆分
	;^DHCTarC("TEC",{TARTEC_RowId})
	;^TMPOPTARPAYMODE($j, UserID, TECarRowID, PayModeDR)
	n (UserDR)
	
	s myTECRowID=0
	s myCount=0
	f  s myTECRowID=$o(^DHCTarC("TEC",myTECRowID)) q:(myTECRowID="")  D
	.q:(myTECRowID="")
	.s myTECDesc=$p($g(^DHCTarC("TEC",myTECRowID)),"^",2)
	.s ^TMPOPTARPAYMODE($j, UserDR, myTECRowID)=myTECDesc
	.s myCount=$g(myCount)+1
	
	q myCount
}

ClassMethod ReadFootECCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadFootECCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod ReadFootECCatExecute(ByRef qHandle As %Binary, RepID As %String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;w ##class(%ResultSet).RunQuery("web.udhcOPHandin5","ReadFootECCat","72")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	i (RepID=""){
		
		Quit $$$OK
	}
	
	d ..KillTmp()
	
	d ResetVariablesFR
	
	s myPrtRowID=0
	s myUserDR=$p($g(^DHCOPInsFoot(RepID)),"^",8)
	
	d ..GetOECCat(myUserDR)
	
	;^DHCINVPRT(0,"Report",{PRT_DHCINVPRTR_DR},{PRT_Rowid})
	f  s myPrtRowID=$o(^DHCINVPRT(0,"Report",RepID, myPrtRowID)) q:(myPrtRowID="")  d
	.d ..SetTarTOECat(myPrtRowID,myUserDR)
	
	;把得到的二维表传出；
	;^TMPOPTARPAYMODE($j, UserID, TECarRowID, PayModeDR)
	s myIdx=0
	s myTarRowID=0
	s myToHJ=0
	s myPatHJ=0
	s myRefCashHJ=0
	s myRefTCHJ=0
	s myCashHJ=0
	s myTCHJ=0
	f  s myTarRowID=$o(^TMPOPTARPAYMODE($j, myUserDR,myTarRowID)) q:(myTarRowID="")  d
	.;支付模式
	.s myPMDR=0
	.s myTECDesc=$g(^TMPOPTARPAYMODE($j, myUserDR,myTarRowID))
	.s myToSum=+$g(^TMPOPTARPAYMODE($j,"PT", myUserDR,myTarRowID, "TP"))		;支付全额
	.s myToHJ=+myToHJ+myToSum
	.s myPatSum=+$g(^TMPOPTARPAYMODE($j,"PT",myUserDR,myTarRowID, "PP"))		;患者支付额
	.s myPatHJ=myPatHJ+myPatSum
	.s myRefCashSum=0
	.s myRefTCSum=0
	.s myCashSum=0
	.s myTCSum=0
	.f  s myPMDR=$o(^TMPOPTARPAYMODE($j, myUserDR,myTarRowID, myPMDR)) q:(myPMDR="")  d
	..s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	..s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	..i myPMCode="CASH" d
	...;现金
	...s myCashSum=$g(myCashSum)+$g(^TMPOPTARPAYMODE($j, myUserDR, myTarRowID, myPMDR, "N"))
	...s myRefCashSum=$g(myRefCashSum)+$g(^TMPOPTARPAYMODE($j, myUserDR, myTarRowID, myPMDR, "A"))
	..e  d
	...;统筹
	...s myTCSum=$g(myTCSum)+$g(^TMPOPTARPAYMODE($j, myUserDR, myTarRowID, myPMDR, "N"))
	...s myRefTCSum=$g(myRefTCSum)+$g(^TMPOPTARPAYMODE($j, myUserDR, myTarRowID, myPMDR, "A"))
	.s myRefCashHJ=myRefCashHJ+myRefCashSum
	.s myRefTCHJ=myRefTCHJ+myRefTCSum
	.s myCashHJ=myCashHJ+myCashSum
	.s myTCHJ=myTCHJ+myRefTCSum
	.s myIdx=myIdx+1
	.s myToSum=$fn(myToSum,"",2)
	.s myRefCashSum=$fn(myRefCashSum,"",2)
	.s myRefTCSum=$fn(myRefTCSum,"",2)
	.s myCashSum=$fn(myCashSum,"",2)
	.s myTCSum=$fn(+myTCSum,"",2)
	.s myPatSum=$fn(myPatSum,"",2)
	.s No=myIdx
	.d OutputFR
	.
		
	;合计
	;
	d ResetVariablesFR
	
	s myTECDesc="合计"
	s myToSum=myToHJ
	s myRefCashSum=myRefCashHJ
	s myRefTCHJ=myRefTCSum
	s myCashSum=myCashHJ
	s myTCSum=myTCHJ
	s myPatSum=myPatHJ
	
	d OutputFR

	d ..KillTmp()
	
	Quit $$$OK
ResetVariablesFR
	s (No, myTECDesc,myToSum,myRefCashSum,myRefTCSum,myCashSum, myTCSum, myPatSum)=""
	quit
OutputFR
	s Data=$lb(No, myTECDesc,myToSum,myRefCashSum,myRefTCSum,myCashSum, myTCSum, myPatSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

ClassMethod ReadFootECCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadFootECCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ReadTARECData() As %SQLQuery(CONTAINID = 1)
{
	select top 1 TARTEC_Desc,"","","","","","" from DHC_TarEC
}

/// 查询结算的费用分类
Query ReadFootECCat(RepID As %String = "") As %Query(ROWSPEC = "No:%String,TTarName:%String,TTotalSum:%String,TRefCashSum:%String,TRefTCSum:%String,TCashSum:%String,TTCSum:%String,TSum:%String")
{
}

}
