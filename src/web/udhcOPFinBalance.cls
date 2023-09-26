Class web.udhcOPFinBalance Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 246;

/// /Version=0北京积水潭医院
/// /还是针对于DHC_INVPRTReports表
ClassMethod GetUFDataForFin(hUser As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String) As %String
{
	;w ##class(web.udhcOPFinBalanceIF).GetUFDataForFin(23298,60638,60321,60641,59303)
	;w ##class(web.udhcOPFinBalanceIF).GetUFDataForFin("1","60446","76603","60641","61583")
	;专门为财务结算界面提供, 操作员没有办理过结算的数据生成一个TMP
	;只在积水潭医院使用
	;其他的地方不能使用；
	;^TMPUserFootData($j)
	n (hUser, StDate, StTime, EndDate, EndTime)
	s myrtn=0
	
	;^DHCINVPRT(0,"Date",{PRT_Date},{PRT_Rowid})
	;门诊操作员打印发票Index
	;^DHCINVPRT(0,"UserDate",{PRT_Usr},{PRT_Date},{PRT_Rowid})
	;增加一个Index   User  Date  操作员打印发票日期
	
	;要求按照日期循环验证   等待
	s myCount=0
	s mystdate=0
	s mysttime=0
	s myenddate=0
	s myendtime=0
	
	s myDateInfo=##class(web.udhcOPHandin0).GetDate(hUser,+$h)
	s StDate=$p(myDateInfo,"^",1)
	s StTime=$p(myDateInfo,"^",2)
	s mysttime=StTime
	
	i (+StDate<+$h) d
	.s myCount=0
	.s mypdate=""
	.f mypdate=StDate:1:EndDate   d
	..s myCount=##class(web.udhcOPHandin0).CheckINVFlag(hUser, mypdate, myenddate)
	..b		;myCount
	..i +myCount'=0  d
	...;如果当天存在要要结算数据, 把结束时间定为明天的0分
	...i mypdate=EndDate d
	....s myenddate=EndDate
	....s myendtime=EndTime
	...e  d
	....s myenddate=mypdate+1
	....s myendtime=0
	...s myUFInfo=..ReadOperUnFootData(hUser, mypdate, mysttime, myenddate, myendtime,"")
	...;把开始时间 变成前一次的结束时间
	...s mysttime=myendtime
	...b	;DDD
	...s ^TMPUserFootData($j,mypdate)=myUFInfo
	
	q myrtn
}

ClassMethod ReadOperUnFootData(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, GroupDR As %String) As %String
{
	n (hUser, stdate, sttime, EndDate, EndTime, GroupDR)
	;复制  udhcHandin0类中的函数  GetHandin函数
	;w ##class(web.udhcOPFinBalance).ReadOperUnFootData("1",+$h-500,0,+$h,0,"")
	
	d ##class(web.udhcOPHandin0).KillTmp()
	
	;生成TMP  Global
	
	;
	s myINVInfo=##class(web.udhcOPHandin0FQ).SetINVRepInfo(stdate,sttime,EndDate,EndTime, hUser, GroupDR)
	b	;;;myINVInfo
	
	;增加卡支付门诊发票的结算
	s myIPRepInfo=##class(web.udhcOPHandin0FQ).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, hUser, GroupDR)
	b	;myIPRepInfo
	
	s myIPRepInfo1=myIPRepInfo
	s myIPRtn=$p(myIPRepInfo1,$c(3),1)
	s myIPRepInfo=$p(myIPRepInfo1,$c(3),2)
	s myIPCPPRepInfo=$p(myIPRepInfo1,$c(3),3)
	
	;##class(web.udhcOPHandin1)
	s myAPIRepInfo=##class(web.udhcOPHandin0FQ).GetAPIRepInfo(stdate,sttime,EndDate,EndTime, hUser, myIPCPPRepInfo, GroupDR)
	
	b ;myAPIRepInfo
	s myAPRtn=$p(myAPIRepInfo,$c(3),1)
	s myAPIRepInfo=$p(myAPIRepInfo,$c(3),2)
	
	;##class(web.udhcOPHandin1)
	s myPDInfo=##class(web.udhcOPHandin0FQ).GetPRDRepINfo(stdate,sttime,EndDate,EndTime, hUser, GroupDR)
	b	;PRD
	s myPDRtn=$p(myPDInfo,$c(3),1)
	s myPDInfo=$p(myPDInfo,$c(3),2)
	
	;s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	;s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	
	;myIPRepInfo=原来输出方式
	;myAPIRepInfo=交钱金额$(4)发票信息$c(4)作废票据信息$(4)红冲票据信息
	
	s myrtn=1
	i ((myINVInfo'="")!(+myIPRtn=0)!(+myAPRtn=1)!(+myPDRtn>0))  d
	.s myrtn=0
	
	;;*************************************************************
	;;*************************************************************
	;;下面是：现金支付和卡支付的汇合处
	;;*************************************************************
	;;*************************************************************
	
	s myCashSum=0
	
	s myAPIInfo=$p(myAPIRepInfo,$c(3))
	s myAPIInfo1=$p(myAPIInfo,$c(4),1)
	s myAPIInfo2=$p(myAPIInfo,$c(4),2)
	s myAPIInfo3=$p(myAPIInfo,$c(4),3)
	s myAPIInfo4=$p(myAPIInfo,$c(4),4)
	
	;票据金额
	s myPRTTolSum=+$p(myIPRepInfo,"^",18)			;现金收费的票据金额+支票和其他的费用总和
	
	;***************************************************************************************
	;卡支付的票据金额
	;***************************************************************************************
	;DHC_INVPRT
	s myPRTAccSum=0
	;s myPRTAccSum=+$p(myIPCPPRepInfo,"^",2)			;DHC_INVPRT表中卡支付myCPPSum
	;s myPRTAccSum=+myPRTAccSum+$p(myIPCPPRepInfo,"^",4)			;红冲
	;s myPRTAccSum=+myPRTAccSum+$p(myIPCPPRepInfo,"^",6)			;作废
	
	;DHC_AccPayINV
	s myAccTolSum=+$p(myAPIInfo2,"^",1)					;卡支付中收费票据金额
	s myAccTolSum=+myAccTolSum+$p(myAPIInfo3,"^",1)		;卡支付中退费票据金额
	s myAccTolSum=+myAccTolSum+$p(myAPIInfo4,"^",1)		;卡支付中红冲票据金额
	
	s myTolSum=+myPRTTolSum+myAccTolSum+myPRTAccSum
	
	;卡支付返回值
	;s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum
	;s myNINfo=myNINfo_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	;s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	;s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	;s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	;s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum
	
	;现金支付返回值
	;s ret=$ZD(stdate,4)_"^"_$zt(sttime,1)_"^"_INVNOinfo_"^"_cashnum_"^"_checknum	;0-4
	;s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	;s ret=ret_"^"_handcash_"^"_handcheck_"^"_sksum_"^"_tksum_"^"_jybs_"^"_CurDate	;10-15
	;s ret=ret_"^"_CurTime_"^"_FootTotSum		;16-17
	;s ret=ret_"^"_$fn(PayorSum,"",2)_"^"_RefundINVInfo_"^"_ParkINVInfo	;18-20
	;s myOthPayInfo=myCPPNum_"^"_$fn(myCPPSum,"",2)_"^"_myOtherNum_"^"_$fn(myOtherSum,"",2)  ;21--24
	
	;其中现金
	;s myCashSum=+myCashSum+$p(myIPRepInfo,"^",11)
	s myCashSum=+$p(myIPRepInfo,"^",11)
	;把门诊收费中的退费钱数加到现金中		；与原来的分解有些差异；把收来的钱分解
	;退现金
	;Refhandcash_"^"_Refhandcheck_"^"_myRefCPPSum_"^"_myRefBankCardSum_"^"_myRefOtherSum		;27--31
	s myCashSum=+myCashSum+$p(myIPRepInfo,"^",28)
	
	s myCashSum=+myCashSum+$p(myAPIInfo3,"^",7)
	s myCashSum=+myCashSum+$p(myAPIInfo4,"^",7)
	
	s myCashSum=+myCashSum+$p(myPDInfo,"^",5)
	
	;银行卡支付总额
	s myBankInSum=0
	s myBankInSum=+myBankInSum+$p(myIPRepInfo,"^",31)
	
	;其中支票
	s myCheckSum=0
	s myCheckSum=+$p(myIPRepInfo,"^",12)
	;退支票
	s myCheckSum=+myCheckSum+$p(myIPRepInfo,"^",29)
	s myCheckSum=+myCheckSum+$p(myPDInfo,"^",6)
	
	;其中其他支付方式
	s myOtherSum=0
	s myOtherSum=+$p(myIPRepInfo,"^",25)
	s myOtherSum=+myOtherSum+$p(myIPRepInfo,"^",32)
	s myOtherSum=+myOtherSum+$p(myPDInfo,"^",7)
	
	;实际收款
	s mySKSum=0
	s mySKSum=$p(myIPRepInfo,"^",13)
	s mySKSum=+mySKSum+$p(myPDInfo,"^",2)
	
	;实际退款
	s myTKSum=0
	s myTKSum=$p(myIPRepInfo,"^",14)
	s myTKSum=+myTKSum + $p(myAPIInfo3,"^",7)			;卡支付退款时退现金总额
	s myTKSum=+myTKSum+$p(myAPIInfo4,"^",7)				;卡支付红冲时退现金总额
	s myTKSum=+myTKSum+$p(myPDInfo,"^",4)
	
	;实际上缴金额：
	;现金收款+(-医保退款+退费或红冲时的款项)
	;退费或红冲时的款项=-退费时退现金总额+退费时回收医保支付
	;                   -红冲时退现金总额+红冲时回收医保支付
	;这个钱都累加到实际上缴额
	;现金收款
	s myPRTPatSum=+$p(myIPRepInfo,"^",10)
	
	;集中打印发票时的收退款
	;医保退款
	;在DHC_AccPayINV表的YBPaySum字段，操作员退款为正，收款为负
	;都是-
	s myAccPatSum=-$p(myAPIInfo2,"^",5)
	s myYBPaySum=-$p(myAPIInfo2,"^",5)
	
	;退费时回收医保支付
	s myAccPatSum=+myAccPatSum-$p(myAPIInfo3,"^",5)
	s myYBPaySum=myYBPaySum-$p(myAPIInfo3,"^",5)
	;退款时退现金总额
	s myAccPatSum=+myAccPatSum+$p(myAPIInfo3,"^",7)
	
	;红冲时回收医保支付
	s myAccPatSum=+myAccPatSum-$p(myAPIInfo4,"^",5)
	s myYBPaySum=myYBPaySum-$p(myAPIInfo4,"^",5)
	;红冲时退现金总额
	s myAccPatSum=+myAccPatSum+$p(myAPIInfo4,"^",7)
	
	;预交金额
	s myPDPatSum=+$p(myPDInfo,"^",2)+$p(myPDInfo,"^",4)
	
	;实际上缴额
	s myPatSum=+myPRTPatSum+myAccPatSum+myPDPatSum
	
	;数值类型转换
	s myTolSum=$fn(myTolSum,"",2)
	
	s myPatSum=$fn(myPatSum,"",2)
	
	s myYBPaySum=$fn(myYBPaySum,"",2)
	s mySKSum=$fn(mySKSum,"",2)
	s myTKSum=$fn(myTKSum,"",2)
	s myCashSum=$fn(myCashSum,"",2)
	s myCheckSum=$fn(myCheckSum,"",2)
	s myOtherSum=$fn(myOtherSum,"",2)
	s myYBPaySum=$fn(myYBPaySum,"",2)
	s myBankInSum=$fn(myBankInSum,"",2)
	
	;s myCPPInfo=myAPNum_"^"_myAPSum_"^"_myAPRefNum_"^"_myAPRefSum_"^"_myAPParkNum_"^"_myAPParkSum_RefPRTInfo_ParkPRTInfo
	;增加DHC_INVPRT打印发票的卡支付汇总金额  这个代表医院收入
	s myCPPPRTINVSum=+$p(myIPCPPRepInfo,"^",2)
	s myCPPPRTINVSum=+myCPPPRTINVSum+$p(myIPCPPRepInfo,"^",4)
	s myCPPPRTINVSum=+myCPPPRTINVSum+$p(myIPCPPRepInfo,"^",6)
	
	;b	;实际上缴额
	;主要信息包括：上缴金额信息+总的发票信息
	;+日期段信息;
	s myMInfo=myINVInfo_"^"_stdate_"^"_sttime_"^"_EndDate_"^"_EndTime		;0-4
	s myMInfo=myMInfo_"^"_myTolSum_"^"_myPatSum_"^"_mySKSum_"^"_myTKSum_"^"_myCashSum_"^"_myCheckSum	;5--10
	s myMInfo=myMInfo_"^"_myOtherSum_"^"_myYBPaySum		;11-12
	s myMInfo=myMInfo_"^"_myBankInSum
	
	b		;myMInfo
	s mystr=myMInfo_$c(3)_myIPRepInfo_$c(3)_myAPIRepInfo_$c(3)_myPDInfo_$c(3)_myIPCPPRepInfo_$c(3)_myCPPPRTINVSum
	
	d ##class(web.udhcOPHandin0).KillTmp()
	
	q mystr
}

ClassMethod GetFDataJS(JSFunName As %String, BDate As %String = "", BTime As %String = "", EDate As %String = "", ETime As %String = "") As %String
{
	n (JSFunName,BDate, BTime, EDate, ETime)
	
	;w ##class(web.udhcOPFinBalance).GetFDataJS("","2005-11-28","16:58:05","2006-03-30","08:41:58")
	
	d ##class(web.udhcOPFinBalance).GetFinFootData(BDate, BTime, EDate, ETime)
	
	s myIdx=0
	s TCashSum=0
	s TCheckSum=0
	s TBankSum=0
	s TToSum=0
	
	i $d(^TMPOPFOper($j))'=0  d
	.s myUserDR=""
	.f  s myUserDR=$o(^TMPOPFOper($j,myUserDR)) q:(myUserDR="")  d
	..s myIdx=+myIdx+1
	..s myUserName=$g(^TMPOPFOper($j,myUserDR))
	..s myCashSum=+$g(^TMPOPFOper($j,myUserDR,"Cash"))
	..s myCashSum=$fn(myCashSum,"",2)
	..s myCheckSum=+$g(^TMPOPFOper($j,myUserDR,"Check"))
	..s myCheckSum=$fn(myCheckSum,"",2)
	..s myBankSum=+$g(^TMPOPFOper($j,myUserDR,"Bank"))
	..s myBankSum=$fn(myBankSum,"",2)
	..s myToSum=+$g(^TMPOPFOper($j,myUserDR,"Sum"))
	..s myToSum=$fn(myToSum,"",2)
	..s TCashSum=TCashSum+myCashSum
	..s TCheckSum=TCheckSum+myCheckSum
	..s TBankSum=TBankSum+myBankSum
	..s TToSum=TToSum+myToSum
	..s myval=myIdx_"^"_myUserName_"^"_myCashSum_"^"_myCheckSum_"^"_myBankSum_"^"_myToSum
	..s rtnval=JSFunName_"('"_$ZCVT($g(myval),"O","JS")_"');"
	..;s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.;合计
	.s myval="^合计^"_TCashSum_"^"_TCheckSum_"^"_TBankSum_"^"_TToSum
	.s rtnval=JSFunName_"('"_$ZCVT($g(myval),"O","JS")_"');"
	.&javascript<#(rtnval)#>
	
	k ^TMPOPFOper($j)
}

ClassMethod GetFinFootData(BDate As %String = "", BTime As %String = "", EDate As %String = "", ETime As %String = "") As %String
{
	;财务报表结算，只有一个开始和结算日期时间
	;w ##class(web.udhcOPFinBalance).GetFinFootData("2005-11-28","16:58:05","2006-03-30","08:41:58")
	n (BDate, BTime, EDate, ETime)
	
	k ^TMPOPFOper($j)
	
	s BDate=$zdh(BDate,4)
	;s BTime=$zth(BTime)
	s EDate=$zdh(EDate,4)
	;s ETime=$zth(ETime)
	s myDate=BDate-1
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EDate))  d
	.s myHisRowID=""
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	..;q:((myDate=BDate)&&(myTime<BTime))
	..;q:((myDate=EDate)&&(myTime>ETime))
	..s myINSFDate=$p(^DHCOPInsFoot(myHisRowID),"^",13)
	..;q:(myINSFDate'="")
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..s ^TMPOPFOper($j,myUserDR)=myUserName
	..s myCashSum=$p(^DHCOPInsFoot(myHisRowID),"^",18)
	..s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",22)
	..s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",24)
	..s ^TMPOPFOper($j,myUserDR,"Cash")=+$g(^TMPOPFOper($j,myUserDR,"Cash"))+myCashSum
	..s myCheckSum=$p(^DHCOPInsFoot(myHisRowID),"^",20)
	..s ^TMPOPFOper($j,myUserDR,"Check")=+$g(^TMPOPFOper($j,myUserDR,"Check"))+myCheckSum
	..s ^TMPOPFOper($j,myUserDR,"Bank")=0.00
	..s ^TMPOPFOper($j,myUserDR,"Sum")=$g(^TMPOPFOper($j,myUserDR,"Sum"))+myCashSum+myCheckSum
	..
	
	q 0
}

/// w ##class(web.udhcOPFinBalance).GetOtherInfo("29/09/2005","12/04/2006","")
ClassMethod GetOtherInfo(BDate As %String, EDate As %String, TSum As %String) As %String
{
	s BDate=$zdh(BDate,4)
	s BDate=$zd(BDate,3)
	
	s EDate=$zdh(EDate,4)
	s EDate=$zd(EDate,3)
	
	s DateRange=BDate_"至"_EDate
	
	s RMB=##class(web.UDHCJFBaseCommon).RMBDXXZH(TSum)
	s myCurDate=$zd(+$h,3)
	
	q DateRange_"^"_RMB_"^"_myCurDate
}

ClassMethod GetDate() As %String
{
	;得到最小日期，和当前日期
	;w ##class(web.udhcOPFinBalance).GetDate()
	n (dd)
	s BDate=""
	s BTime=""
	s EDate=""
	s ETime=""
	s myDate=""
	s myHisRowID=""
	
	;dfdsfsdfds
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	s myDate=$o(^DHCOPInsFootI(0,"INSFDate",""),-1)
	;w $o(^DHCOPInsFootI(0,"Date",""),-1)
	i myDate'="" d
	.s BDate=myDate
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"INSFDate",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s BTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	.s BDate=$zd(BDate,3)
	.s BTime=$zt(BTime)
	
	; ^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	i myHisRowID="" d
	.s myDate=$o(^DHCOPInsFootI(0,"Date",""))	;最早日期
	.s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,""))
	.s BDate=myDate
	.s BTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	.s BDate=$zd(BDate,3)
	.s BTime=$zt(BTime)
	
	i myHisRowID="" d 
	.s BDate=$zd(+$h,3)
	.s BTime="00:00:00"
	s EDate=$zd(+$h,3)
	s ETime=$zt($p($h,",",2))
	q BDate_"^"_BTime_"^"_EDate_"^"_ETime
}

ClassMethod KillTMP()
{
	k ^TMPOPRepFinItem($j)
	k ^TMPFIOUT($j)
}

ClassMethod OPFinFoot(BDate As %String, EndDate As %String) As %String
{
}

ClassMethod ReadFinCOLSubRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadFinCOLSubRepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadOPFinRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadOPFinRepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadFinCOLSubRepExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, GroupDR As %String, UserDR As %String, QueryMode As %String, HISRowID As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance","ReadFinCOLSubRep","","","","","HISRep","16")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s ^TMPDFDDF=$lb(StDate, EndDate, GroupDR, UserDR, QueryMode, HISRowID)
	
	d ..KillTMP()
	
	;在此Query中生成不同方向的TMP Global
	;按照时间分为：
	;1.收付实现方式
	;2.权责发生制
	;3.按照操作员结算的HISRowID查询
	
	s myCPPSum=0
	
	;1权责发生
	i QueryMode="QZ" d
	.d ..BuildFinCOLSubByQZFS(StDate, EndDate, GroupDR, UserDR)
	
	;2收付实现
	i QueryMode="SF" d
	.d ..BuildFinCOLSubBySFSX(StDate, EndDate, GroupDR, UserDR)
	
	;3直接查询一个HISRowID  支持操作员的打印功能；
	i QueryMode="HISRep" d
	.q:(HISRowID="")
	.s ^TMPHISRowID=HISRowID_"^"_QueryMode
	.d ..BuildFinCOLSubByRepRowID(HISRowID)
	
	s ^TMPFIOUT($j,1)="一 门诊收费合计"
	s ^TMPFIOUT($j,2)="		1 现金"
	s ^TMPFIOUT($j,3)="   2 支票"
	s ^TMPFIOUT($j,4)="	  3 银行卡"
	s ^TMPFIOUT($j,5)="	  4 汇票"
	s ^TMPFIOUT($j,6)="   5 其他"
	
	s ^TMPFIOUT($j,7)="二 门诊记账合计"
	s ^TMPFIOUT($j,8)="   1 SARS医保"
	s ^TMPFIOUT($j,9)="   2 SARS非医保"
	s ^TMPFIOUT($j,10)="   3 医保特病"
	s ^TMPFIOUT($j,11)="   4 其他"
	
	s ^TMPFIOUT($j,12)="三 急诊预收款合计"
	s ^TMPFIOUT($j,13)="   1 现金"
	s ^TMPFIOUT($j,14)="   2 支票"
	s ^TMPFIOUT($j,15)="   3 银行卡"
	s ^TMPFIOUT($j,16)="   4 汇票"
	s ^TMPFIOUT($j,17)="   5 其他"

	s ^TMPFIOUT($j,18)="四急诊结帐退款合计"
	s ^TMPFIOUT($j,19)="   1 现金"
	s ^TMPFIOUT($j,20)="   2 支票"
	s ^TMPFIOUT($j,21)="   3 银行卡"
	s ^TMPFIOUT($j,22)="   4 汇票"
	s ^TMPFIOUT($j,23)="   5 其他"
	
	s ^TMPFIOUT($j,24)="五 急诊暂记帐合计"
	s ^TMPFIOUT($j,25)="   1 一般暂记帐"
	s ^TMPFIOUT($j,26)="   2 其他"
	s ^TMPFIOUT($j,27)="五 冲账应付款合计"
	s ^TMPFIOUT($j,28)="	1 冲账现金"
	s ^TMPFIOUT($j,29)="	2 冲账支票"
	s ^TMPFIOUT($j,30)="	3 冲账银行卡"
	s ^TMPFIOUT($j,31)="	4 冲账汇票"
	s ^TMPFIOUT($j,32)="	5 冲账其他"
	s ^TMPFIOUT($j,33)="六 急诊卡记账合计"
	
	s ^TMPFIOUT($j,27,"Get")=$fn(myCPPSum,"",2)
	
	;输出
	s myPMDR=0
	s myPMDR=$o(^TMPOPRepFinItem($j,"PM",myPMDR))
	while (myPMDR'=""){
		;门诊收费合计
		s ^TMPFIOUT($j,1,"Ref")=+$g(^TMPFIOUT($j,1,"Ref"))+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum"))
		s ^TMPFIOUT($j,1,"Get")=+$g(^TMPFIOUT($j,1,"Get"))+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum"))
		
		;急诊预收款合计
		s ^TMPFIOUT($j,12,"Ref")=+$g(^TMPFIOUT($j,12,"Ref"))+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum"))
		s ^TMPFIOUT($j,12,"Get")=+$g(^TMPFIOUT($j,12,"Get"))+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum"))
		;^TMPOPPayMode($j,myPMDR,"PRD","FBackSum")
		;急诊结帐退款合计
		s ^TMPFIOUT($j,18,"Ref")=+$g(^TMPFIOUT($j,18,"Ref"))+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","RefSum"))
		
		;冲账应付款合计
		s ^TMPFIOUT($j,27,"Ref")=+$g(^TMPFIOUT($j,27,"Ref"))+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum"))
		
		;^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum")
		s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
		if (myPMCode="CASH"){
			s ^TMPFIOUT($j,2,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum"))
			s ^TMPFIOUT($j,2,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum"))
			s ^TMPFIOUT($j,13,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum"))
			s ^TMPFIOUT($j,13,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum"))
			s ^TMPFIOUT($j,19,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","RefSum"))
			s ^TMPFIOUT($j,28,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum"))
		}elseif(myPMCode="CHEQUES"){
			s ^TMPFIOUT($j,3,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum"))
			s ^TMPFIOUT($j,3,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum"))
			s ^TMPFIOUT($j,14,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum"))
			s ^TMPFIOUT($j,14,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum"))
			s ^TMPFIOUT($j,20,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","RefSum"))
			s ^TMPFIOUT($j,29,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum"))
		}elseif(myPMCode="BANK"){
			s ^TMPFIOUT($j,4,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum"))
			s ^TMPFIOUT($j,4,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum"))
			s ^TMPFIOUT($j,15,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum"))
			s ^TMPFIOUT($j,15,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum"))
			s ^TMPFIOUT($j,21,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","RefSum"))
			s ^TMPFIOUT($j,30,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum"))
		}elseif(myPMCode="HUIPIAO"){
			s ^TMPFIOUT($j,5,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum"))
			s ^TMPFIOUT($j,5,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum"))
			s ^TMPFIOUT($j,16,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum"))
			s ^TMPFIOUT($j,16,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum"))
			s ^TMPFIOUT($j,22,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","RefSum"))
			s ^TMPFIOUT($j,31,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum"))
		}else{
			s ^TMPFIOUT($j,6,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum"))
			s ^TMPFIOUT($j,6,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum"))
			s ^TMPFIOUT($j,17,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum"))
			s ^TMPFIOUT($j,17,"Get")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum"))
			s ^TMPFIOUT($j,23,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","RefSum"))
			s ^TMPFIOUT($j,32,"Ref")=$g(^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum"))
		}
		
		s myPMDR=$o(^TMPOPRepFinItem($j,"PM",myPMDR))
	}
	
	s myINSDR=0
	s myINSDR=$o(^TMPOPRepFinItem($j,"INS",myINSDR))
	s myINSSum=0
	while (myINSDR'=""){
		s ^TMPFIOUT($j,7,"Ref")=+$g(^TMPFIOUT($j,7,"Ref"))+$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","RefSum"))
		s ^TMPFIOUT($j,7,"Get")=+$g(^TMPFIOUT($j,7,"Get"))+$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","GetSum"))
		s myINSSum=+myINSSum+$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","RefSum"))+$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","GetSum"))
		
		s myInsCode=$p(^PAC("ADMREA",myINSDR),"^",1)
		if (myInsCode="医保SARS"){
			s ^TMPFIOUT($j,8,"Ref")=$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","RefSum"))
			s ^TMPFIOUT($j,8,"Get")=$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","GetSum"))
		}elseif(myInsCode="SARS非医保"){
			s ^TMPFIOUT($j,9,"Ref")=$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","RefSum"))
			s ^TMPFIOUT($j,9,"Get")=$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","GetSum"))
		}else{
			s ^TMPFIOUT($j,11,"Ref")=$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","RefSum"))
			s ^TMPFIOUT($j,11,"Get")=$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","GetSum"))
		}
		s myINSDR=$o(^TMPOPRepFinItem($j,"INS",myINSDR))
	}
	
	s ^TMPFIOUT($j,33,"Get")=+$g(^TMPOPRepFinItem($j,"ACC","CurSum"))
	
	d ResetVariablesFI
	s myIndx=0
	f  s myIndx=$o(^TMPFIOUT($j,myIndx)) q:(myIndx="")  d
	.s No=myIndx
	.s myFinRefSum=-$Fn(($g(^TMPFIOUT($j,myIndx,"Ref"))),"",2)
	.s myFinItem=$g(^TMPFIOUT($j,myIndx))
	.s myFinGetSum=$Fn($g(^TMPFIOUT($j,myIndx,"Get")),"",2)
	.d OutputFI
	
	;合计
	;现金
	s myCashSum=$g(^TMPFIOUT($j,2,"Ref"))+$g(^TMPFIOUT($j,2,"Get"))
	;+$g(^TMPFIOUT($j,13,"Ref"))
	s myCashSum=myCashSum+$g(^TMPFIOUT($j,13,"Get"))
	s myCashSum=myCashSum+$g(^TMPFIOUT($j,19,"Ref"))
	;支票
	s myCheckSum=$g(^TMPFIOUT($j,3,"Ref"))+$g(^TMPFIOUT($j,3,"Get"))
	;+$g(^TMPFIOUT($j,14,"Ref"))
	s myCheckSum=myCheckSum+$g(^TMPFIOUT($j,14,"Get"))
	s myCheckSum=myCheckSum+$g(^TMPFIOUT($j,20,"Ref"))
	;银行卡
	s myBankSum=$g(^TMPFIOUT($j,4,"Ref"))+$g(^TMPFIOUT($j,4,"Get"))
	;+$g(^TMPFIOUT($j,15,"Ref"))
	s myBankSum=+myBankSum+$g(^TMPFIOUT($j,15,"Get"))
	s myBankSum=+myBankSum+$g(^TMPFIOUT($j,21,"Ref"))
	d ResetVariablesFI
	
	s myFinRefSum="累计交现金:"_$fn(myCashSum,"",2)
	s myFinItem="累计交支票:"_$fn(myCheckSum,"",2)
	s myFinGetSum="累计交银行卡:"_$fn(myBankSum,"",2)
	s No=""
	d OutputFI
	;汇票
	s myHPSum=$g(^TMPFIOUT($j,5,"Ref"))+$g(^TMPFIOUT($j,5,"Get"))
	;+$g(^TMPFIOUT($j,16,"Ref"))
	s myHPSum=+myHPSum+$g(^TMPFIOUT($j,16,"Get"))
	s myHPSum=+myHPSum+$g(^TMPFIOUT($j,22,"Ref"))
	;其他
	s myOtherSum=$g(^TMPFIOUT($j,6,"Ref"))+$g(^TMPFIOUT($j,6,"Get"))
	;+$g(^TMPFIOUT($j,17,"Ref"))
	s myOtherSum=+myOtherSum+$g(^TMPFIOUT($j,17,"Get"))
	s myOtherSum=+myOtherSum+$g(^TMPFIOUT($j,23,"Ref"))
	;
	d ResetVariablesFI
	s myFinRefSum="累计交汇票:"_$fn(myHPSum,"",2)
	s myFinItem="累计其他:"_$fn(myOtherSum,"",2)
	s myFinGetSum="累计门诊暂记账"_$fn(myINSSum,"",2)
	s No=""
	d OutputFI
	
	;预交金余额
	;急诊暂记账余额
	s myAccCurLeftSum=+$g(^TMPOPRepFinItem($j,"ACC","LeftSum"))
	s myQFLeftSum=+$g(^TMPOPRepFinItem($j,"ACCQF","LeftSum"))
	d ResetVariablesFI
	s myFinRefSum="预交金余额:"_$fn(myAccCurLeftSum,"",2)
	s myFinItem=""
	s myFinGetSum="急诊暂记账余额"_$fn(myQFLeftSum,"",2)
	s No=""
	
	d OutputFI
	
	d ..KillTMP()
	
	Quit $$$OK
ResetVariablesFI
	s (No,myFinRefSum,myFinItem,myFinGetSum)=""
	quit
OutputFI
	s Data=$lb(No,myFinRefSum,myFinItem,myFinGetSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod BuildFinCOLSubByQZFS(StDate As %String, EndDate As %String, GroupDR As %String, UserDR As %String) As %String
{
	;按照权责发生来完成  患者交钱
	n (StDate, EndDate, GroupDR, UserDR)
	s myrtn=0
	
	;w ##class(web.udhcOPFinBalance).BuildFinCOLSubByQZFS(60447,+$h,"","")
	
	d ..KillTMP()
	
	;按照流水账来查询
	
	d ##class(web.udhcOPHandin0).KillTmp()
	
	;w ##class(web.udhcOPHandin0FQ).BuildOPINVItem("",+$h-200,0,+$h,0,"")
	;积水潭医院按照天来结算
	s myrtn=##class(web.udhcOPHandin0FQ).BuildOPHZInfo(UserDR, StDate, 0, EndDate+1, 0, GroupDR)
	;生成TMP
	
	;红冲发票
	;^TMPOPINVSTRIK($j,myPMDR,"Strik","GetSum")
	;^TMPOPINVSTRIK($j,myPMDR,"Strik","RefSum")
	;票据的折扣额=Sars
	;^TMPOPINVTALLY($j,myInsTypeDR,"TALL",
	;现金支付收
	;^TMPOPPayMode($j,myPMDR)
	;现金收付退
	;^TMPOPParkPayMode($j,myPMDR)
	;账户结算回收预交金金额
	;^TMPOPPayMode($j,myPMDR,"PRD","FBackSum")
	;预交金收
	;^TMPOPPayMode($j,myPMDR,"PRD","GSum")
	;结算交退预交金
	;^TMPOPPayMode($j,myPMDR,"PRD","RefSum")
	;红冲票据张数
	;^TMPOPINVSTRIK($j,myPMDR,"Strik","RefNum")
	;红冲+作废
	;^TMPOPParkPayMode($j,myPMDR,"Num")
	
	;生成TMPCOLSUBPM
	k ^TMPCOLSUBPM($j)
	s myPMDR=0
	f  s myPMDR=$o(^TMPOPPayMode($j,myPMDR))  q:(myPMDR="")  d
	.s ^TMPCOLSUBPM($j,"PM",myPMDR)=myPMDR

	f  s myPMDR=$o(^TMPOPParkPayMode($j,myPMDR))  q:(myPMDR="")  d
	.s ^TMPCOLSUBPM($j,"PM",myPMDR)=myPMDR
	
	f  s myPMDR=$o(^TMPOPINVSTRIK($j,myPMDR))  q:(myPMDR="")  d
	.s ^TMPCOLSUBPM($j,"PM",myPMDR)=myPMDR
	
	s myINSDR=0
	f  s myINSDR=$o(^TMPOPINVTALLY($j,myINSDR)) q:(myINSDR="")  d
	.s ^TMPCOLSUBPM($j,"INS",myINSDR)=myINSDR
	
	s myStrikNum=0
	s myParkINVNum=0
	
	s myPMDR=0
	f  s myPMDR=$o(^TMPCOLSUBPM($j,"PM",myPMDR))  q:(myPMDR="")  d
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.q:(myPMCode="CPP")		;排出卡支付因为这张方式不能计算
	.s myGetSum=+$g(^TMPOPPayMode($j,myPMDR))
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum"))+myGetSum
	.s myRefSum=+$g(^TMPOPParkPayMode($j,myPMDR))
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum"))+myRefSum
	.s myPRDSum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GSum"))
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum"))+myPRDSum
	.s myPRDRefSum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefSum"))
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","RefSum")=+$g(^TMPOPRepFinItem($j,"PM", myPMDR,"PRD","RefSum"))+myPRDRefSum
	.s myBPreSum=-$g(^TMPOPPayMode($j,myPMDR,"PRD","FBackSum"))
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum")=+$g(^TMPOPRepFinItem($j,"PM", myPMDR,"PRD","FBackSum"))+myBPreSum
	.s myStrikRefSum=+$g(^TMPOPINVSTRIK($j,myPMDR,"Strik","RefSum"))
	.s myStrikGetSum=+$g(^TMPOPINVSTRIK($j,myPMDR,"Strik","GetSum"))
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum"))+myStrikRefSum+myStrikGetSum
	.s myStrikNum=myStrikNum+$g(^TMPOPINVSTRIK($j,myPMDR,"Strik","RefNum"))
	.s myParkINVNum=+myParkINVNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	
	s ^TMPOPRepFinItem($j,"INV","Abort")=+myParkINVNum-myStrikNum
	s ^TMPOPRepFinItem($j,"INV","Strik")=+myParkINVNum
	
	;循环记帐表  Sars患者记录
	;^TMPCOLSUBPM($j,"INS",myINSDR)
	s myINSDR=0
	
	f  s myINSDR=$o(^TMPCOLSUBPM($j,"INS",myINSDR)) q:(myINSDR="")  d
	.s myGetSum=+$g(^TMPOPINVTALLY($j,myINSDR,"TALL","GetSum"))
	.s ^TMPOPRepFinItem($j,"INS",myINSDR,"INS","GetSum")=+$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","GetSum"))+myGetSum
	.s myRefSum=+$g(^TMPOPINVTALLY($j,myINSDR,"TALL","RefSum"))
	.s ^TMPOPRepFinItem($j,"INS",myINSDR,"INS","RefSum")=+$g(^TMPOPRepFinItem($j,"INS",myINSDR,"INS","RefSum"))+myRefSum
	.
	
	;取得账户余额和急诊暂记账余额(或叫账户透支的额度)
	;对于欠款，就找最后一次的，原因：在前面都计算好了
	s mydate=0
	
	;^DHCACDi("AccPF",0,"HSDateF",{AccPF_HSDate},{AccPF_RowID})
	;表示作账的日期
	i ((GroupDR="")&(UserDR="")) d
	.f mydate=StDate:1:EndDate  d
	..s myAPFRowID=0
	..f  s myAPFRowID=$o(^DHCACDi("AccPF",0,"HSDateF",mydate,myAPFRowID))  q:(myAPFRowID="")  d
	...q:($d(^DHCACD("AccPF",myAPFRowID))=10)
	...;起初值
	...i '$d(^TMPOPRepFinItem($j,"ACC","BeginSum")) d
	....s myBeginSum=+$p(^DHCACD("AccPF",myAPFRowID),"^",6)		;AccPF_PreLeftSum
	....s ^TMPOPRepFinItem($j,"ACC","BeginSum")=+myBeginSum
	...s myAccCurSum=+$p(^DHCACD("AccPF",myAPFRowID),"^",8)		;AccPF_CardPaySum
	...s ^TMPOPRepFinItem($j,"ACC","CurSum")=+$g(^TMPOPRepFinItem($j,"ACC","CurSum"))+myAccCurSum
	...s myAccLeftSum=+$p(^DHCACD("AccPF",myAPFRowID),"^",9)		;AccPF_LeftSum
	...s ^TMPOPRepFinItem($j,"ACC","LeftSum")=myAccLeftSum
	...s myCurQFSum=+$p(^DHCACD("AccPF",myAPFRowID),"^",14)		;AccPF_CurQFSum
	...s ^TMPOPRepFinItem($j,"ACCQF","CurSum")=+myCurQFSum
	...s myLeftQFSum=+$p(^DHCACD("AccPF",myAPFRowID),"^",15)		;AccPF_CurLeftQFSum
	...s ^TMPOPRepFinItem($j,"ACCQF","LeftSum")=+myLeftQFSum
	
	k ^TMPCOLSUBPM($j)
	
	d ##class(web.udhcOPHandin0).KillTmp()
	
	q myrtn
}

ClassMethod BuildFinCOLSubByRepRowID(HISRowID As %String) As %String
{
	n (HISRowID)
	
	s myHISRowID=HISRowID
	s myCPPSum=0
	
	q:($d(^DHCOPInsFoot(myHISRowID))=10)
	;q:((myUserDR'=UserDR)&(UserDR'=""))
	;q:((myGroupDR'=GroupDR)&(GroupDR'=""))
	s myCPPSum=+myCPPSum+$p(^DHCOPInsFoot(myHISRowID),"^",59)		;HIS_AccPaySum
	;循环支付模式表
	s myPaySub=0
	f  s myPaySub=$o(^DHCOPInsFoot(myHISRowID,"P",myPaySub)) q:(myPaySub="")  d
	.q:($d(^DHCOPInsFoot(myHISRowID,"P",myPaySub))=10)
	.s myPMDR=$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",2)
	.q:(myPMDR="")
	.s myGetSum=+$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",1)
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","GetSum"))+myGetSum
	.s myRefSum=+$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",4)
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"INV","RefSum"))+myRefSum
	.s myPRDSum=+$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",7)
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","GetSum"))+myPRDSum
	.s myPRDRefSum=+$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",9)
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","RefSum")=+$g(^TMPOPRepFinItem($j,"PM", myPMDR,"PRD","RefSum"))+myPRDRefSum
	.s myStrikRefSum=+$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",10)
	.s myStrikGetSum=+$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",12)
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"STK","RefSum"))+myStrikRefSum+myStrikGetSum
	.;循环办理结算时回收预交金
	.s myPRDBackSum=-$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",14)
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackSum"))+myPRDBackSum
	.s myPRDBackNum=+$p(^DHCOPInsFoot(myHISRowID,"P",myPaySub),"^",15)
	.s ^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackNum")=+$g(^TMPOPRepFinItem($j,"PM",myPMDR,"PRD","FBackNum"))+myPRDBackNum
	b
	;循环记帐表
	s myINSSub=0
	f  s myINSSub=$o(^DHCOPInsFoot(myHISRowID,"IC",myINSSub)) q:(myINSSub="")  d
	.s myINSTypeDR=$p(^DHCOPInsFoot(myHISRowID,"IC",myINSSub),"^",1)
	.q:(myINSTypeDR="")
	.s myGetSum=+$p(^DHCOPInsFoot(myHISRowID,"IC",myINSSub),"^",3)
	.s ^TMPOPRepFinItem($j,"INS",myINSTypeDR,"INS","GetSum")=+$g(^TMPOPRepFinItem($j,"INS",myINSTypeDR,"INS","GetSum"))+myGetSum
	.s myRefSum=+$p(^DHCOPInsFoot(myHISRowID,"IC",myINSSub),"^",5)
	.s ^TMPOPRepFinItem($j,"INS",myINSTypeDR,"INS","RefSum")=+$g(^TMPOPRepFinItem($j,"INS",myINSTypeDR,"INS","RefSum"))+myRefSum
	
	q 0
}

ClassMethod BuildFinCOLSubBySFSX(StDate As %String, EndDate As %String, GroupDR As %String, UserDR As %String) As %String
{
	;按照收付实现完成   操作员作日报
	n (StDate, EndDate, GroupDR, UserDR)
	
	;w ##class(web.udhcOPFinBalance).BuildFinCOLSubBySFSX("60298","60663","","")
	s myrtn=0
	s ^TMPTTTTT=$lb(StDate, EndDate, GroupDR, UserDR)
	d ..KillTMP()
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	f mydate=StDate:1:EndDate  d
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"Date",mydate,myHISRowID)) q:(myHISRowID="")  d
	..q:($d(^DHCOPInsFoot(myHISRowID))=10)
	..s myUserDR=$p(^DHCOPInsFoot(myHISRowID),"^",8)		;HIS_User
	..q:(myUserDR="")
	..s myGroupDR=$p(^SSU("SSUSR",myUserDR),"^",5)
	..q:((myUserDR'=UserDR)&(UserDR'=""))
	..q:((myGroupDR'=GroupDR)&(GroupDR'=""))
	..d ..BuildFinCOLSubByRepRowID(myHISRowID)
	..;s myCPPSum=+myCPPSum+$p(^DHCOPInsFoot(myHISRowID),"^",59)		;HIS_AccPaySum
	
	q myrtn
}

ClassMethod ReadFinCOLRepINVInfo(StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, GroupDR As %String, UserDR As %String, FinMode As %String) As %String
{
	;按照不同的模式读取票据信息
	;w ##class(web.udhcOPHandin0FQ).ReadOPINVHZInfo("",60446,0,60447,0,"")
	n (StDate, StTime, EndDate, EndTime, GroupDR, UserDR)
	s myrtn=""
	
	q myrtn
}

ClassMethod ReadOPFinRepExecute(ByRef qHandle As %Binary, BDate As %String = "", EDate As %String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	
	;小条号码，患者姓名，患者的登记号码，结算人员，支付日期，支付时间，支付金额，账户余额，支付位置，
	;对应的发票状态，打印发票状态,患者RowID，PLRowID, INVPRTRowID,结算人员RowID
	
	d OutputFR
	
	Quit $$$OK
ResetVariablesFR
	s (No,UserDR,UserName,CashSum,ChequesSum,BankSum,TSum)=""
	quit
OutputFR
	s Data=$lb(No,UserDR,UserName,CashSum,ChequesSum,BankSum,TSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod ReadFinCOLSubRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadFinCOLSubRepExecute ]
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

ClassMethod ReadINVRepsSubInfo(RepRowID As %String) As %String
{
	;元素名称1_^_值1_$c(2)_元素名称2^值2
	;w ##class(web.udhcOPFinBalance).ReadINVRepsSubInfo()
	n (RepRowID)
	s myRepInfo=""
	
	q:(RepRowID="") ""
	;^DHCOPInsFoot(RepRowID,"IC",mySub)
	s mySARSNum=""
	s mySARSSum=""
	s mySARSRefNum=""
	s mySARSRefSum=""
	
	s mySub=0
	f  s mySub=$o(^DHCOPInsFoot(RepRowID,"IC",mySub))  q:(mySub="")  d
	.s myInsTypeDR=$p(^DHCOPInsFoot(RepRowID,"IC",mySub),"^",1)
	.s myInsCode=$p(^PAC("ADMREA",myInsTypeDR),"^",1)
	.i ((myInsCode="医保SARS")!(myInsCode="SARS非医保")) d
	..s mySARSNum=+mySARSNum+$p(^DHCOPInsFoot(RepRowID,"IC",mySub),"^",2)
	..s mySARSSum=+mySARSSum+$p(^DHCOPInsFoot(RepRowID,"IC",mySub),"^",3)
	..s mySARSRefNum=+mySARSRefNum+$p(^DHCOPInsFoot(RepRowID,"IC",mySub),"^",4)
	..s mySARSRefSum=+mySARSRefSum+$p(^DHCOPInsFoot(RepRowID,"IC",mySub),"^",5)
	
	s myRepInfo="SARSNum^"_+mySARSNum
	s myRepInfo=myRepInfo_$c(2)_"SARSSum^"_$fn(mySARSSum,"",2)
	s myRepInfo=myRepInfo_$c(2)_"SARSRefNum^"_(+mySARSRefNum)
	s myRepInfo=myRepInfo_$c(2)_"SARSRefSum^"_$fn(mySARSRefSum,"",2)
	
	q myRepInfo
}

ClassMethod ReadOPFinRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadOPFinRepExecute ]
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

ClassMethod ReadUSEOperDataAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUSEOperDataAllExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadUserWorkRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUserWorkRepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadUSEOperDataAllExecute(ByRef qHandle As %Binary, TMPGID As %String, INSUserDR As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String, EndTime As %String, UserName As %String, GRPRowID As %String) As %Status
{
	;此类分类查询操作员的工作列表;  供财务人员使用
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance","ReadUSEOperDataAll","", "",+$h-100,"",+$h,"","","")
	
	;s ^TMP111=GRPRowID
	s:StDate="" StDate=+$h
	s:StTime="" StTime=$p($h,",",2)
	s:EndDate="" EndDate=+$h
	s:EndTime="" EndTime=$p($h,",",2)
	
	i TMPGID'="" d
	.k ^TMPOPPrintOut(TMPGID)
	
	s myTMPGID=$i(^TMPOPPrintOut)
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	d ResetVariablesIFD
	
	s myINVTSum=0
	s myHandTSum=0
	s myRefTSum=0
	s myGetTSum=0
	s myRTNum=0
	s WorkSumPre=0   ;lgl+预交金工作量
	b
	;此Query按照
	s myDate=StDate-1
	;f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:(myDate="")  d
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	k ^TMPUSROperData($j)
	;1.按照患者缴费时间查询
	;2.按照操作员日报时间;
	;3.按照财务接收时间
	s myDTMode="2"
	
	if (+myDTMode=2) d
	.;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	.f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:(myDate="")  d
	..s myHisRID=0
	..q:(EndDate<myDate)
	..f  s myHisRID=$o(^DHCOPInsFootI(0,"Date",myDate, myHisRID))  q:(myHisRID="")  d
	...s myUDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",8)				;HIS_User
	...q:((INSUserDR'=myUDR)&&(INSUserDR'=""))
	...s myTime=$p($g(^DHCOPInsFoot(myHisRID)),"^",7)				;HIS_Time
	...q:((myDate=StDate)&&(myTime<+StTime)&&(StTime'=""))
	...q:((myDate=EndDate)&&(myTime>+EndTime)&&(EndTime'=""))
	...
	...s ^TMPUSROperData($j,myHisRID)=myHisRID
	
	i (+myDTMode=3) d
	.f  s myDate=$o(^DHCOPInsFootI(0,"INSFDate",myDate)) q:(myDate="")  d
	..s myHisRID=0
	..q:(EndDate<myDate)
	..f  s myHisRID=$o(^DHCOPInsFootI(0,"INSFDate",myDate, myHisRID))  q:(myHisRID="")  d
	...s myUDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)				;HIS_INSFootUser
	...q:((INSUserDR'=myUDR)&&(INSUserDR'=""))
	...s myTime=$p($g(^DHCOPInsFoot(myHisRID)),"^",14)				;HIS_INSFootTime
	...q:((myDate=StDate)&&(myTime<+StTime)&&(StTime'=""))
	...q:((myDate=EndDate)&&(myTime>+EndTime)&&(EndTime'=""))
	...
	...s ^TMPUSROperData($j,myHisRID)=myHisRID
	
	s myHisRID=0
	f  s myHisRID=$o(^TMPUSROperData($j, myHisRID))  q:(myHisRID="")  d
	.s myUDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)				;HIS_INSFootUser
	.q:((INSUserDR'=myUDR)&&(INSUserDR'=""))
	.s myOperDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",8)				;HIS_User
	.s myUserName=$p($g(^SSU("SSUSR",myOperDR)),"^",2)
	.s myUserCode=$p($g(^SSU("SSUSR",myOperDR)),"^",1)
	.s myTime=$p($g(^DHCOPInsFoot(myHisRID)),"^",14)				;HIS_INSFootTime
	.q:((myDate=StDate)&&(myTime<+StTime)&&(StTime'=""))
	.q:((myDate=EndDate)&&(myTime>+EndTime)&&(EndTime'=""))
	.s myFootUserDR=$p($g(^DHCOPInsFoot(myHisRID)),"^",15)
	.s myGRPRowID=$p($g(^SSU("SSUSR",myOperDR)),"^",5)			;SSUserGroup
	.q:((GRPRowID'="")&(GRPRowID'=myGRPRowID))
	.q:((UserName'="")&(UserName'=myUserCode))
	.s INSFootUser=$p(^SSU("SSUSR",myFootUserDR),"^",2)  ;lgl+ 取后台结算人
	.s RepID=myHisRID
	.s FootDate=$zd(myDate,3)
	.s FootTime=$zt(myTime)
	.s INVSum=$p($g(^DHCOPInsFoot(myHisRID)),"^",1)
	.s INVSum=$fn(INVSum,"",2)
	.s myINVTSum=+myINVTSum+INVSum
	.s HandSum=$p($g(^DHCOPInsFoot(myHisRID)),"^",16)
	.s HandSum=$fn(HandSum,"",2)
	.s myGetPDSum=+$p($g(^DHCOPInsFoot(myHisRID)),"^",52)
	.s myGetTSum=+myGetTSum+myGetPDSum
	.s myRefPDSum=+$p($g(^DHCOPInsFoot(myHisRID)),"^",54)
	.s myRefTSum=+myRefTSum+myRefPDSum
	.s myHandTSum=+myHandTSum+HandSum
	.s myBegD=$p($g(^DHCOPInsFoot(myHisRID)),"^",5)
	.s myBegT=$p($g(^DHCOPInsFoot(myHisRID)),"^",6)
	.s BegFootDT=$zd(myBegD,3)_" "_$zt(myBegT)
	.s myEndD=$p($g(^DHCOPInsFoot(myHisRID)),"^",3)
	.s myEndT=$p($g(^DHCOPInsFoot(myHisRID)),"^",4)
	.s EndFootDT=$zd(myEndD,3)_" "_$zt(myEndT)
	.;在结算卡支付账目时的记录应该排除在外
	.s myCardPaySum=$p($g(^DHCOPInsFoot(myHisRID)),"^",59)
	.s myRcptNO=$p($g(^DHCOPInsFoot(myHisRID)),"^",10)			;HIS_RcptNO
	.s myReceiptNum=$p($g(^DHCOPInsFoot(myHisRID)),"^",9)		;HIS_Num
	.s myRTNum=myRTNum+myReceiptNum
	.s myFFlag=$p($g(^DHCOPInsFoot(myHisRID)),"^",60)		;HIS_FootFlag
	.q:(myFFlag="S")			;系统自动结算的退出
	.s myGetPDSum=$fn(myGetPDSum,"",2) 
	.s myRefPDSum=$fn(myRefPDSum,"",2)
	.s No=+No+1
	.d OutputIFD
	
	;合计
	;s (No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT)=""
	d ResetVariablesIFD
	
	s myUserName="合计"
	s INVSum=$fn(myINVTSum,"",2)
	s HandSum=$fn(myHandTSum,"",2)
	s myGetPDSum=$fn(myGetTSum,"",2)
	s myRefPDSum=$fn(myRefTSum,"",2)
	s myReceiptNum=$fn(myRTNum,"",1)
	
	d OutputIFD
	b	;ddd
	k ^TMPUSROperData($j)
	
	Quit $$$OK
ResetVariablesIFD
	s (No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUserName, myRcptNO, myReceiptNum, myOperDR,INSFootUser,WorkSumPre)=""    ;lgl+INSFootUser
	quit
OutputIFD
	s Data=$lb(No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT, myGetPDSum, myRefPDSum, myUserName, myRcptNO, myReceiptNum, myOperDR,INSFootUser,WorkSumPre, myTMPGID)
	Set ^CacheTemp(repid,index)=Data
	s myTMPData=No_"^"_RepID_"^"_FootDate_"^"_FootTime_"^"_INVSum_"^"_HandSum_"^"_BegFootDT_"^"_EndFootDT_"^"_myGetPDSum_"^"_myRefPDSum_"^"_myUserName_"^"_myRcptNO_"^"_myReceiptNum_"^"_myOperDR_"^"_INSFootUser_"^"_WorkSumPre_"^"_myTMPGID
	s ^TMPOPPrintOut(myTMPGID,index)=myTMPData
	Set index=index+1
	quit
}

Query ReadOPFinRep(BDate As %String = "", EDate As %String = "") As %Query(ROWSPEC = "No:%String:序号,UserDR:%String,UserName:%String,CashSum:%String,ChequesSum:%String,BankSum:%String,TSum:%String")
{
}

ClassMethod ReadUSEOperDataAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadUSEOperDataAllExecute ]
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

ClassMethod ReadUserWorkRepExecute(ByRef qHandle As %Binary, BDate As %String = "", EDate As %String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	k ^TMPOPFOper($j)
	
	d ResetVariablesWSR
	
	i (BDate="")||(EDate="") {
		d ResetVariablesWSR
		d OutputWSR
		Quit $$$OK
	}
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance","ReadUserWorkRep","","")
	
	;No,UserDR,UserName,CashSum,ChequesSum,BankSum,TSum
	s myDate=BDate-1
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EDate))  d
	.s myHisRowID=""
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	..s myINSFDate=$p(^DHCOPInsFoot(myHisRowID),"^",13)
	..;q:(myINSFDate'="")
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..s ^TMPOPFOper($j,myUserDR)=myUserName
	..s myCashSum=$p(^DHCOPInsFoot(myHisRowID),"^",18)					;收费钱数
	..s myCheckSum=$p(^DHCOPInsFoot(myHisRowID),"^",20)					;收支票钱数
	..s ^TMPOPFOper($j,myUserDR,"INVSum")=+$g(^TMPOPFOper($j,myUserDR,"INVSum"))+myCashSum+myCheckSum
	..
	..s myCashNum=+$p(^DHCOPInsFoot(myHisRowID),"^",17)
	..s myCheckNum=+$p(^DHCOPInsFoot(myHisRowID),"^",19)
	..s ^TMPOPFOper($j,myUserDR,"INVNum")=+$g(^TMPOPFOper($j,myUserDR,"INVNum"))+myCashNum+myCheckNum
	..
	..s myRefSum=+$p(^DHCOPInsFoot(myHisRowID),"^",22)		;红冲钱数
	..s myParkSum=+$p(^DHCOPInsFoot(myHisRowID),"^",24)		;退费钱数
	..s ^TMPOPFOper($j,myUserDR,"ParkSum")=+$g(^TMPOPFOper($j,myUserDR,"ParkSum")) + myRefSum + myParkSum
	..
	..s myRefSum=+$p(^DHCOPInsFoot(myHisRowID),"^",21)		;红冲
	..s myParkSum=+$p(^DHCOPInsFoot(myHisRowID),"^",23)		;退费
	..s ^TMPOPFOper($j,myUserDR,"ParkNum")=+$g(^TMPOPFOper($j,myUserDR,"ParkNum"))+myRefSum+myParkSum
	..
	..
	
	s myUserID=""
	s myIdx=0
	s myTNum=0
	s myTSum=0
	s myParkTNum=0
	s myParkTSum=0
	
	;积水潭医院显示的列
	;收费笔数, 收费金额, 退费笔数, 退费金额, 红冲笔数, 红冲金额, 作废笔数, 作废金额, 卡结算次数, 卡结算金额
	f  s myUserID=$o(^TMPOPFOper($j, myUserID))  q:(myUserID="")  d
	.s myIdx=myIdx+1
	.s No=myIdx
	.s UserDR=myUserID
	.s UserName=$g(^TMPOPFOper($j, myUserID))
	.s INVNum=+$g(^TMPOPFOper($j, myUserID,"INVNum"))
	.s myTNum=myTNum+INVNum
	.s INVSum=+$g(^TMPOPFOper($j, myUserID,"INVSum"))
	.s myTSum=myTSum+INVSum
	.s ParkNum=+$g(^TMPOPFOper($j, myUserID,"ParkNum"))
	.s myParkTNum=myParkTNum+ParkNum
	.s ParkSum=+$g(^TMPOPFOper($j, myUserID,"ParkSum"))
	.s myParkTSum=myParkTSum+ParkSum
	.d OutputWSR
	
	;合计
	s No=""
	s UserDR=""
	s UserName="合计:"
	s INVNum=myTNum
	s INVSum=myTSum
	s ParkNum=myParkTNum
	s ParkSum=myParkTSum
	d OutputWSR
	
	Quit $$$OK
ResetVariablesWSR
	s (No,UserDR,UserName,INVNum,INVSum,ParkNum,ParkSum)=""
	quit
OutputWSR
	s ParkSum=$zabs(ParkSum)
	s Data=$lb(No, UserName, UserDR, INVNum, INVSum, (ParkNum), ParkSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod ReadUserWorkRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadUserWorkRepExecute ]
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

Query ReadFinCOLSubRep(StDate As %String, EndDate As %String, GroupDR As %String, UserDR As %String, QueryMode As %String, HISRowID As %String) As %Query(ROWSPEC = "No:%String,FinRefSum:%String,FinItem:%String,FinGetSum:%String")
{
}

Query ReadUSEOperDataAll(TMPGID As %String, INSUserDR As %String = "", StDate As %String = "", StTime As %String = "", EndDate As %String, EndTime As %String, UserName As %String, GRPRowID As %String) As %Query(ROWSPEC = "No:%String,RepID:%String,FootDate:%String,FootTime:%String,INVSum:%String,HandSum:%String,BegFootDT:%String,EndFootDT:%String, GetPDSum:%String, RefPDSum:%String, UserName:%String, RcptNO:%String, ReceiptNum:%String, sUser:%String,INSFootUser:%String,WorkSumPre:%String,TMPGID:%String")
{
}

Query ReadUserWorkRep(BDate As %String = "", EDate As %String = "") As %Query(ROWSPEC = "No:%String,UserName:%String,UserRowID:%String,INVNum:%String,INVSum:%String,ParkNum:%String,ParkSum:%String")
{
}

}
