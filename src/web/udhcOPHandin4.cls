Import SQLUser

Class web.udhcOPHandin4 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 475;

/// /4  宁波明州医院报表
/// /添加医保
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
	...;i PrtNO'=""  d
	...s stat=..STATtoOPCAT(PRTrowid)
	...;生成支付模式
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	....d ..ReadOPPayMode(PRTrowid)
	...e  d
	....;作废发票的支付模式设定
	....d ..ReadOPParkPayMode(PRTrowid)
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
	n (hUser, EndDate)
	;;w ##class(web.udhcOPHandin).GetDate("23298","2005-10-24")
	s stdate="",sttime=""
	&sql(select max(HIS_Rowid) into:rowid            
	     from DHC_INVPRTReports where HIS_User=:hUser)
	i rowid'="" d
	.&sql(select HIS_Date,HIS_Time into :stdate,:sttime
	      from DHC_INVPRTReports where HIS_Rowid=:rowid)
	e  d
	.&sql(select min(PRT_Rowid) into :rowid from DHC_INVPRT
	      where PRT_Date<=:EndDate and PRT_Usr=:hUser and PRT_Handin is null)
	.i rowid'="" d
	..&sql(select PRT_Date,PRT_Time into:stdate,:sttime
	       from DHC_INVPRT where PRT_Rowid=:rowid)
	i stdate="" d  s stdate=+$h
	i sttime="" d  s sttime=$p($h,",",2)
	
	;判断结束日期时间
	s myStMonth=$p($zd(stdate,3),"-",2)
	s myEnYear=$p($zd(+$h,3),"-",1)
	s myEnMonth=$p($zd(+$h,3),"-",2)
	s myEndDate=+$h
	s myEndTime=$p($h,",",2)
	
	i (+myStMonth'=+myEnMonth) d
	.;跨月的算法
	.;同时判断是否有需要结算的发票
	.s myTMPEnd=myEnYear_"-"_myEnMonth_"-01"
	.s myEndDate=$zdh(myTMPEnd,3)
	.s myEndDate=+myEndDate-1
	.s myEndTime=$zth("23:59:59")
	.;验证是否有结算，如果没有，取当前时间
	.s myCount=..CheckINVFlag(hUser,stdate,sttime,myEndDate,myEndTime)
	.i +myCount=0 d
	..;没有结算的票据,需要取得当前时间
	..s myEndDate=+$h
	..s myEndTime=$p($h,",",2)
	
	q stdate_"^"_sttime_"^"_myEndDate_"^"_myEndTime
}

ClassMethod CheckINVFlag(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String) As %String
{
	n (hUser,stdate,sttime,EndDate,EndTime)
	
	s myCount=0
	
	f pdate=stdate:1:EndDate  d
	.q:$d(^DHCINVPRT(0,"Date",pdate))=0
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..q:PRTUser'=hUser
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..q:(pdate=EndDate)&(PRTTime>EndTime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..q:Handin="Y"
	..s myCount=+myCount+1
	
	q myCount
}

ClassMethod GetHandin(itmjs As %Library.String = "", itmjsex As %Library.String = "", hUser As %String)
{
	;, EndDate As %String, EndTime As %String
	;调试代码
	;w ##class(web.udhcOPHandin).GetHandin("","","10137")
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
	s sttimeinfo=..GetDate(hUser,EndDate)
	
	s stdate=$p(sttimeinfo,"^",1)
	s sttime=$p(sttimeinfo,"^",2)
	s EndDate=$p(sttimeinfo,"^",3)
	s EndTime=$p(sttimeinfo,"^",4)
	
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
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	....d ..ReadOPPayMode(PRTrowid)
	...e  d
	....d ..ReadOPParkPayMode(PRTrowid)
	.i snum>0  d
	..s INVNOinfo=..GetINVNOinfo(snum)
	
	;增加其他的支付模式
	s myPosNum=0
	s myPosSum=0
	s myOtherNum=0
	s myOtherSum=0
	s myJZNum=0
	s myJZSum=0
	s myYBTCSum=0
	
	;退费钱数, 
	s myRefCashNum=0
	s myRefCashSum=0
	s myRefCheckNum=0
	s myRefCheckSum=0
	s myRefPOSNum=0
	s myRefPOSSum=0
	s myRefJZNum=0
	s myRefJZSum=0
	s myRefYBSum=0
	s myRefOtherNum=0
	s myRefOtherSum=0
	
	s myPMDR=0
	s myFFlag=0		;结算标志
	
	;收费
	f  s myPMDR=$o(^TMPOPPayMode($j,myPMDR)) q:(myPMDR="")  d
	.s myFFlag=1
	.s myAmt=+$g(^TMPOPPayMode($j,myPMDR))
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.;现金
	.i (myPMCode="CASH")  d
	..s handcash=handcash+myAmt
	..s cashnum=+cashnum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.i ((myPMCode="CASHA")!(myPMCode="CASHB")!(myPMCode="CASHC")!(myPMCode="CASHD")) d
	..s handcash=handcash+myAmt
	.;支票
	.i myPMCode="CHEQUES" d
	..s handcheck=handcheck+myAmt
	..s checknum=+checknum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.;信用卡
	.i myPMCode="POS" d
	..s myPosNum=+myPosNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myPosSum=myPosSum+myAmt
	.;记帐支付
	.i myPMCode="JIZHANG" d
	..s myJZNum=+myJZNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myJZSum=+$g(myJZSum)+myAmt
	.;医保支付
	.i ((myPMCode="GBJJZF")!(myPMCode="TCZF")!(myPMCode="JZZF")!(myPMCode="SHJZZF")!(myPMCode="DNGZ")!(myPMCode="LNGZ")) d
	..s myYBTCSum=+$g(myYBTCSum)+myAmt
	.i (("^CASH^POS^CHEQUES^JIZHANG^GBJJZF^TCZF^JZZF^SHJZZF^CASHA^CASHB^CASHC^CASHD^DNGZ^LNGZ^")'[("^"_myPMCode_"^")) d
	.. s myOtherNum=myOtherNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.. s myOtherSum=myOtherSum+myAmt
	
	;退款金额统计
	f  s myPMDR=$o(^TMPOPParkPayMode($j,myPMDR)) q:(myPMDR="")  d
	.s myFFlag=1
	.s myAmt=+$g(^TMPOPParkPayMode($j,myPMDR))
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.;现金
	.i myPMCode="CASH"  d
	..s myRefCashSum=myRefCashSum+myAmt
	..s myRefCashNum=+myRefCashNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	.i ((myPMCode="CASHA")!(myPMCode="CASHB")!(myPMCode="CASHC")!(myPMCode="CASHD")) d
	..s myRefCashSum=myRefCashSum+myAmt
	.;支票
	.i myPMCode="CHEQUES" d
	..s myRefCheckSum=myRefCheckSum+myAmt
	..s myRefCheckNum=+myRefCheckNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	.;信用卡
	.i myPMCode="POS" d
	..s myRefPOSNum=+myRefPOSNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	..s myRefPOSSum=myRefPOSSum+myAmt
	.;记帐支付
	.i myPMCode="JIZHANG" d
	..s myRefJZNum=+myRefJZNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	..s myRefJZSum=+$g(myRefJZSum)+myAmt
	.;医保支付
	.i ((myPMCode="GBJJZF")!(myPMCode="TCZF")!(myPMCode="JZZF")!(myPMCode="SHJZZF")!(myPMCode="DNGZ")!(myPMCode="LNGZ")) d
	..s myRefYBSum=+$g(myRefYBSum)+myAmt
	.i (("^CASH^POS^CHEQUES^JIZHANG^GBJJZF^TCZF^JZZF^SHJZZF^CASHA^CASHB^CASHC^CASHD^DNGZ^LNGZ^")'[("^"_myPMCode_"^")) d
	.. s myRefOtherNum=myRefOtherNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	.. s myRefOtherSum=myRefOtherSum+myAmt
	
	;费用总额
	s FootTotSum=$fn(TotSum+AbTotSum+RefTotSum,"",2)
	
	s handinsum=$fn(PatPaySum+AbPatPaySum+RefPatPaySum,"",2)		;应上交金额
	s handinsum=+handinsum-$g(myTCashSum)								;实际上缴额-医保
	s handinsum=$fn(handinsum,"",2)
	
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
	
	;s handinsum=handcash+handcheck+myRefCashSum+myRefCheckSum
	
	s ret=$ZD(stdate,4)_"^"_$zt(sttime,1)_"^"_INVNOinfo_"^"_cashnum_"^"_checknum	;0-4
	s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	s ret=ret_"^"_handcash_"^"_handcheck_"^"_sksum_"^"_tksum_"^"_jybs_"^"_CurDate	;10-15
	s ret=ret_"^"_CurTime_"^"_FootTotSum		;16-17
	s ret=ret_"^"_$fn(PayorSum,"",2)_"^"_RefundINVInfo_"^"_ParkINVInfo	;18-20
	s myOthPayInfo=myPosNum_"^"_$fn(myPosSum,"",2)_"^"_myOtherNum_"^"_$fn(myOtherSum,"",2)
	s ret=ret_"^"_myOthPayInfo
	
	s ret=ret_"^"_myJZNum_"^"_$fn(myJZSum,"",2)_"^"_$fn(myYBTCSum,"",2)_"^"_myRefCashNum_"^"_$fn(myRefCashSum,"",2)
	s ret=ret_"^"_myRefCheckNum_"^"_$fn(myRefCheckSum,"",2)_"^"_myRefPOSNum_"^"_$fn(myRefPOSSum,"",2)
	s ret=ret_"^"_myRefJZNum_"^"_$fn(myRefJZSum,"",2)_"^"_$fn(myRefYBSum,"",2)_"^"_myRefOtherNum_"^"_$fn(myRefOtherSum,"",2)
	
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	;验证是否能结算?
	
	i ((+myFFlag=1)||(+cashnum'=0)||(+checknum'=0)||(+cancelnum'=0)||(+refundnum'=0)||(+myPosNum'=0)||(+myOtherNum'=0)) d
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
	;w ##class(web.udhcOPHandin4).GetHandin("","","9937")
	;w ##class(web.udhcOPHandin4).Handin("5","20/10/2005^15:13:48^24/10/2005^23:08:44^55.00^5^  00000337--00000341^55.00^4^81.00^1^42.00^1^-47.00^1^-21.00^ 00000337^ 00000315")
	;w ##class(web.udhcOPHandin4).Handin("10137","10/05/2006^22:48:54^11/05/2006^16:30:05^343.85^4^  0000079--0000085^343.85^2^352.60^2^145.50^0^0.00^3^-335.85^0000079,  0000081,  0000084, ^^1^16.00^2^165.60")
	s ^TMPHandin=sUser_"%%%"_FootInfo
	
	s $ZT="ERROR^DHCSSERR"
	
	s StDate=$zdh($p(FootInfo,"^",1),4)
	s StTime=$zth($p(FootInfo,"^",2),1)
	
	s EndDate=$zdh($p(FootInfo,"^",3),4)
	s EndTime=$zth($p(FootInfo,"^",4),1)
	
	;s hdate=+$h
	s hdate=EndDate
	;s htime=$p($h,",",2)
	s htime=EndTime
	;Q:$d(^TMPOPCat($j))=0 1
	;q:$d(^TMPCatSub($j))=0 1
	
	d ..KillTmp()
	
	;把发票重新生成，门诊大类项目
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)
	
	q:(myrtn) myrtn_"^"
	
	d ..tb()
	
	k PLIST
	
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=$zdh($p(FootInfo,"^",1),4)		;HIS_StartDate
	s PLIST(5)=$zth($p(FootInfo,"^",2),1)		; HIS_StartTime
	s PLIST(6)=$zdh($p(FootInfo,"^",3),4)		;HIS_EndDate
	s PLIST(7)=$zth($p(FootInfo,"^",4),1)		;HIS_EndTime
	s PLIST(8)=$p(FootInfo,"^",5)		;HIS_Amount应收额
	s PLIST(9)=sUser					;HIS_User
	s PLIST(10)=$p(FootInfo,"^",6)		;His_Num	打印票据数量
	s PLIST(11)=$p(FootInfo,"^",7)		;HIS_RcptNO
	;s PLIST(12)=""		;HIS_Confirm
	;s PLIST(13)=""		;HIS_Collect
	;s PLIST(14)=""		;HIS_INSFootDate
	;s PLIST(15)=""		;HIS_INSFootTime
	;s PLIST(16)=$p(FootInfo,"^",1)		;HIS_INSFootUser
	s PLIST(17)=$p(FootInfo,"^",8)		;HIS_PatSum
	s PLIST(18)=$p(FootInfo,"^",9)		;HIS_CashNum
	s PLIST(19)=$p(FootInfo,"^",10)		;HIS_CashSum
	s PLIST(20)=$p(FootInfo,"^",11)		;HIS_CheckNum
	s PLIST(21)=$p(FootInfo,"^",12)		;HIS_CheckSum
	s PLIST(22)=$p(FootInfo,"^",13)		;HIS_RefundNum
	s PLIST(23)=$p(FootInfo,"^",14)		;HIS_RefundSum
	s PLIST(24)=$p(FootInfo,"^",15)		;HIS_ParkNum
	s PLIST(25)=$p(FootInfo,"^",16)		;HIS_ParkSum
	s PLIST(26)=$p(FootInfo,"^",17)		;HIS_ParkINVInfo
	s PLIST(27)=$p(FootInfo,"^",18)		;HIS_RefundINVInfo

	s PLIST(28)=$p(FootInfo,"^",21)		;HIS_OterPayNum
	s PLIST(29)=$p(FootInfo,"^",22)		;HIS_OterPaySum
	
	s PLIST(45)=$p(FootInfo,"^",19)		;HIS_PosNum
	s PLIST(46)=$p(FootInfo,"^",20)		;HIS_PosSum
	
	;JZNum
	s PLIST(52)=$p(FootInfo,"^",23)		;HIS_PRDGetNum
	;JZSum
	s PLIST(53)=$p(FootInfo,"^",24)		;HIS_PRDGetSum
	;YBTCSum
	s PLIST(31)=$p(FootInfo,"^",25)		;HIS_YBSum
	
	s PLIST(61)="U"		;HIS_Note3
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
	;^TMPOPParkPayMode($j,myPMDR,"PM")
	s myPMDR=0
	f  s myPMDR=$o(^TMPOPParkPayMode($j,myPMDR))  q:(myPMDR="")  d
	.s myParkSum=+$g(^TMPOPParkPayMode($j,myPMDR))
	.s ^TMPOPPayMode($j,myPMDR,"PKSum")=+$g(^TMPOPPayMode($j,myPMDR,"PKSum"))+myParkSum
	.s myParkNum=+$g(^TMPOPParkPayMode($j,myPMDR, "Num"))
	.s ^TMPOPPayMode($j,myPMDR,"PKNum")=+$g(^TMPOPPayMode($j,myPMDR,"PKNum"))+myParkNum
	
	i myrtn=0 d
	.s myPMDR=0
	.f  s myPMDR=$o(^TMPOPPayMode($j,myPMDR)) q:((myPMDR="")||(myrtn'=0))  d
	..s myPMSum=+$g(^TMPOPPayMode($j,myPMDR))
	..s myPMNum=+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myParkSum=+$g(^TMPOPPayMode($j,myPMDR, "PKSum"))
	..s myParkNum=+$g(^TMPOPPayMode($j,myPMDR, "PKNum"))
	..k PLIST
	..s PLIST(0)=HISParref
	..s PLIST(3)=myPMSum
	..s PLIST(4)=myPMDR
	..s PLIST(5)=myParkNum				;HisPay_Refund
	..s PLIST(6)=myParkSum				;HisPay_Refundsum
	..s PLIST(7)=myPMNum
	..s myrtn=##class(web.UDHCINVPRTReportsPaymode).Insert()
	
	b	;;;;;;
	;更新票据流水表
	i myrtn=0 d
	.&sql(update DHC_INVPRT set PRT_DHCINVPRTR_DR=:HISParref,PRT_Handin='Y',PRT_HandinDate=:hdate,PRT_HandinTime=:htime
	      where (PRT_Usr=:sUser and PRT_Handin is null and 
	      ((PRT_Date>=:StDate and PRT_Date<:EndDate) or
	       (PRT_Date=:EndDate and PRT_Time<=:EndTime)) ))
	.s myrtn=SQLCODE
	
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
	k ^TMPOPParkPayMode($j)
}

ClassMethod ReadFootParkPayInfo(HISRowID As %String) As %String
{
	n (HISRowID)
	
	s myParkInfo=""
	
	q:(HISRowID="") "0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0"
	s myPCashNum=0
	s myPCashSum=0
	s myPCheckNum=0
	s myPCheckSum=0
	s myPPOSNum=0
	s myPPOSSum=0
	s myPJZNum=0
	s myPJZSum=0
	s myPYBSum=0
	s myPOtherNum=0
	s myPOtherSum=0
	
	;^DHCOPInsFoot({DHC_INVPRTReports.HIS_Rowid},"P",Sub)
	s mySub=0
	f  s mySub=$o(^DHCOPInsFoot(HISRowID,"P",mySub))  q:(mySub="")  d
	.s myPMDR=$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",2)			;HisPay_Paymode
	.s myPNum=$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",3)			;HisPay_Refund
	.s myPSum=$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",4)			;HisPay_Refundsum
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.;现金
	.i myPMCode="CASH"  d
	..s myPCashNum=+myPCashNum+myPNum
	..s myPCashSum=+myPCashSum+myPSum
	.i ((myPMCode="CASHA")!(myPMCode="CASHB")!(myPMCode="CASHC")!(myPMCode="CASHD")) d
	..s myPCashSum=myPCashSum+myPSum
	.;支票
	.i myPMCode="CHEQUES" d
	..s myPCheckSum=myPCheckSum+myPSum
	..s myPCheckNum=+myPCheckNum+myPNum
	.;信用卡
	.i myPMCode="POS" d
	..s myPPOSNum=+myPPOSNum+myPNum
	..s myPPOSSum=myPPOSSum+myPSum
	.;记帐支付
	.i myPMCode="JIZHANG" d
	..s myPJZNum=+myPJZNum+myPNum
	..s myPJZSum=+$g(myPJZSum)+myPSum
	.;医保支付
	.i ((myPMCode="GBJJZF")!(myPMCode="TCZF")!(myPMCode="JZZF")!(myPMCode="SHJZZF")!(myPMCode="DNGZ")!(myPMCode="LNGZ")) d
	..s myPYBSum=+$g(myPYBSum)+myPSum
	.i (("^CASH^POS^CHEQUES^JIZHANG^GBJJZF^TCZF^JZZF^SHJZZF^CASHA^CASHB^CASHC^CASHD^DNGZ^LNGZ^")'[("^"_myPMCode_"^")) d
	.. s myPOtherNum=myPOtherNum+myPNum
	.. s myPOtherSum=myPOtherSum+myPSum
	.
	
	s myParkInfo=myPCashNum_"^"_$fn(myPCashSum,"",2)_"^"_myPCheckNum_"^"_$fn(myPCheckSum,"",2)_"^"_myPPOSNum
	s myParkInfo=myParkInfo_"^"_$fn(myPPOSSum,"",2)_"^"_myPJZNum_"^"_$fn(myPJZSum,"",2)_"^"_$fn(myPYBSum,"",2)
	s myParkInfo=myParkInfo_"^"_myPOtherNum_"^"_$fn(myPOtherSum,"",2)
	
	q myParkInfo
}

ClassMethod ReadOPParkPayMode(PRTRowID As %String = "") As %String
{
	n (PRTRowID)
	
	q:'$d(^DHCINVPRT(PRTRowID,"P"))
	s myPMSub=0
	
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.q:(myPMDR="")
	.s ^TMPOPParkPayMode($j,myPMDR)=+$g(^TMPOPParkPayMode($j,myPMDR))+myPMSum
	.s ^TMPOPParkPayMode($j,myPMDR,"Num")=+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPParkPayMode($j,myPMDR,"PM")=myPMDesc
	
	q 0
}

ClassMethod ReadOPPayMode(PRTRowID As %String = "") As %String
{
	n (PRTRowID)
	
	;POS  信用卡
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	q:'$d(^DHCINVPRT(PRTRowID,"P"))
	s myPMSub=0
	
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.q:(myPMDR="")
	.s ^TMPOPPayMode($j,myPMDR)=+$g(^TMPOPPayMode($j,myPMDR))+myPMSum
	.s ^TMPOPPayMode($j,myPMDR,"Num")=+$g(^TMPOPPayMode($j,myPMDR,"Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPPayMode($j,myPMDR,"PM")=myPMDesc
	
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
