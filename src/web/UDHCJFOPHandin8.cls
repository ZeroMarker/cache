Import SQLUser

/// 北京中医院 收费员日报
Class web.UDHCJFOPHandin8 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

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
	...s myInsTypeDR=$p($g(^DHCINVPRT(PRTrowid)),"^",9)		;PRT_InsType_DR
	...
	...;yyb 需要确认 和更改 
	...s PRTAcount=+$p($g(^DHCINVPRT(PRTrowid)),"^",1)
	...s PrtPatPay=+$p($g(^DHCINVPRT(PRTrowid)),"^",16)
	...s PrtDiscAmt=+$p($g(^DHCINVPRT(PRTrowid)),"^",7)	;PRT_DiscAmount
	...s PrtPayorAmt=+$p($g(^DHCINVPRT(PRTrowid)),"^",18)	;PRT_PayorShare
	...s PrtYBPaySum=+$p($g(^DHCINVPRT(PRTrowid)),"^",31)	;PRT_YBPaySum
	...;s PrtNO=$p($g(^DHCINVPRT(PRTrowid)),"^",14)
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...
	...s ^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetSum")=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetSum"))+$g(PRTAcount)	//+$g(myINVAcount)-$g(myINVPatSum)
	...s ^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetNum")=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetNum"))+1		;表示此发票有结帐或者折扣
	...
	...s ^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefNum")=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefNum"))+1
	...s ^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefSum")=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefSum"))+PrtDiscAmt
	...
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
	q stdate_"^"_sttime
}

ClassMethod GetHandin(itmjs As %Library.String = "", itmjsex As %Library.String = "", hUser As %String)
{
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
	;正常的票据 
	s myNormalNum=0
	s myNormalSum=0
	s cancelnum=0,cancelsum=0   ;作废张数?作废金额
	s refundnum=0,refundsum=0   ;红冲张数?红冲金额
	s sksum=0,tksum=0           ;收款金额?退款金额
	s (myCashSum,myCashNum,myParkCashSum,myParkCashNum,myRefundCashSum,myRefundCashNum)=0
	s (myChequeSum,myChequeNum,myParkChequeSum,myParkChequeNum,myRefundChequeSum,myRefundChequeNum)=0
	s jybs=0,INVNOinfo="" 
	s EndDate=+$h		;$zdh(EndDate,3)
	s EndTime=$p($h,",",2)			;$zth(EndTime,1)
	s sttimeinfo=..GetDate(hUser,EndDate)
	s stdate=$p(sttimeinfo,"^",1)
	s sttime=$p(sttimeinfo,"^",2)
	i (stdate'="")&(sttime'="")  d
	.s catret=..getsubcat()
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid="" 
	..f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
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
	...i Flag="N" d
	....s myNormalNum=myNormalNum+1
	....s myNormalSum=myNormalSum+PRTAcount
	...;本收款员收取的票据?
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
	....s PatPaySum=PatPaySum+$g(PrtPatPay)
	....s TotSum=TotSum+$g(PRTAcount)
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
	...s PRTARRCPDR=$p(^DHCINVPRT(PRTrowid),"^",2)
	...s myPMSub="0"
	...f  s myPMSub=$o(^DHCINVPRT(PRTrowid,"P",myPMSub)) q:myPMSub=""  d
	....s PayModeDR=$p($g(^DHCINVPRT(PRTrowid,"P",myPMSub)),"^",1)
	....s PayMode=$p(^CT("CTPM",PayModeDR),"^",2)
	....s PayAmt=$p($g(^DHCINVPRT(PRTrowid,"P",myPMSub)),"^",3)
	....i ((PayMode="现金")&&((Flag="N")||((PrtinvDr="")&&(Flag'="N"))))  d
	.....;q:Flag'="N"
	.....s handcash=handcash+PayAmt
	.....s cashnum=cashnum+1
	....i ((PayMode="支票")&&((Flag="N")||((PrtinvDr="")&&(Flag'="N"))))  d
	.....;q:Flag'="N"
	.....s handcheck=handcheck+PayAmt
	.....s checknum=checknum+1
	....;--垃圾
	....
	....i ((PayMode="现金")) d
	.....i Flag="N" d
	......s myCashSum=myCashSum+PayAmt
	......s myCashNum=myCashNum+1
	.....i ((Flag="A")&&(PrtinvDr'="")) d
	......s myParkCashSum=myParkCashSum+PayAmt
	......s myParkCashNum=myParkCashNum+1
	.....i ((Flag="S")&&(PrtinvDr'="")) d
	......s myRefundCashSum=myRefundCashSum+PayAmt
	......s myRefundCashNum=myRefundCashNum+1
	....i ((PayMode="支票")) d
	.....i Flag="N" d
	......s myChequeSum=myChequeSum+PayAmt
	......s myChequeNum=myChequeNum+1
	.....i ((Flag="A")&&(PrtinvDr'="")) d
	......s myParkChequeSum=myParkChequeSum+PayAmt
	......s myParkChequeNum=myParkChequeNum+1
	.....i ((Flag="S")&&(PrtinvDr'="")) d
	......s myRefundChequeSum=myRefundChequeSum+PayAmt
	......s myRefundChequeNum=myRefundChequeNum+1
	...;统计费别
	...s myInstype=$p($g(^DHCINVPRT(PRTrowid)),"^",9)
	...s aryFeeType(myInstype,"Amount")=+$g(aryFeeType(myInstype,"Amount"))+PRTAcount
	...s aryFeeType(myInstype,"PatShare")=+$g(aryFeeType(myInstype,"PatShare"))+PrtPatPay
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
	
	;医疗 与 药品 收入  DHC_TarOC
	;这里 ItmOPCat 是根据医院项目写死的
	s (AllDrugFee,AllMedFee)=0.00
	
	s DrugCatStr=..getStatDrugCatStr()
	f i=1:1:$l(DrugCatStr,"^") d
	.s myCatItemDr=$p(DrugCatStr,"^",i)
	.s aryDrug(myCatItemDr)=myCatItemDr
	
	s ItmOPCat=""
	f  s ItmOPCat=$o(^TMPOPCat($j,ItmOPCat)) q:ItmOPCat=""  d
	.i $g(aryDrug(ItmOPCat))'="" d
	..s AllDrugFee=$fn($g(^TMPOPCat($j,ItmOPCat))+AllDrugFee,"",2)
	.e  s AllMedFee=$fn($g(^TMPOPCat($j,ItmOPCat))+AllMedFee,"",2)
	s (AllPatFee1,AllPatFee2,AllPatFee3,AllPatFee4)=0.00
	s AllPatFee1=$fn($g(aryFeeType(9,"Amount")),"",2)
	s CurDate=$zd(EndDate,4)		;返回当前日期
	s CurTime=$zt(EndTime,1)		;返回当前时间
	s ret=$ZD(stdate,4)_"^"_$zt(sttime,1)_"^"_INVNOinfo_"^"_cashnum_"^"_checknum	;0-4
	s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	s ret=ret_"^"_handcash_"^"_handcheck_"^"_sksum_"^"_tksum_"^"_jybs_"^"_CurDate	;10-15
	s ret=ret_"^"_CurTime_"^"_FootTotSum		;16-17
	s ret=ret_"^"_$fn(PayorSum,"",2)_"^"_RefundINVInfo_"^"_ParkINVInfo	;18-20
	s ret=ret_"^"_AllDrugFee_"^"_AllMedFee ;21-22
	s ret=ret_"^"_myCashNum_"^"_myCashSum_"^"_myParkCashNum_"^"_myParkCashSum_"^"_myRefundCashNum_"^"_myRefundCashSum  ;23-28
	s ret=ret_"^"_myChequeNum_"^"_myChequeSum_"^"_myParkChequeNum_"^"_myParkChequeSum_"^"_myRefundChequeNum_"^"_myRefundChequeSum  ;29-34
	s ret=ret_"^"_myNormalNum_"^"_myNormalSum	;35--36
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	;验证是否能结算?
	i ((+cashnum'=0)||(+checknum'=0)||(+cancelnum'=0)||(+refundnum'=0)) d
	.s rtn=0
	e  d
	.s rtn=1
	
	d ..KillTmp()
	
	quit rtn
}

ClassMethod getStatDrugCatStr()
{
	;传入的药品分类RowId-没办法写死了 	
	s DrugCatStr="1^2^3"
	Quit DrugCatStr
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
	;s ^TMPHandin=sUser_"%%%"_FootInfo
	s $ZT="ERROR^SSERR"
	s StDate=$zdh($p(FootInfo,"^",1),4)
	s StTime=$zth($p(FootInfo,"^",2),1)
	s EndDate=$zdh($p(FootInfo,"^",3),4)
	s EndTime=$zth($p(FootInfo,"^",4),1)
	s hdate=+$h
	s htime=$p($h,",",2)
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
	;结算主表
	s mycat=""
	s mycatsub=""
	s HISParref=""
	s myrtn=##class(web.UDHCINVPRTReports).Insert()
	i myrtn=0 d
	.s HISParref=PLIST(1)
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
	
	;更新--DHC_INVPRTReportsInsType--新加
	;
	;
	;写入折扣或记帐表
	s myInsTypeDR=0
	f  s myInsTypeDR=$o(^TMPOPINVTALLY($j,myInsTypeDR))  q:((myInsTypeDR="")!(myrtn'=0))  d
	.s myTALLSum=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetSum"))
	.s myTALLNum=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetNum"))
	.s myTALLRefNum=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefNum"))
	.s myTALLRefSum=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefSum"))
	.;i (+myTALLSum'=0)!(+myTALLRefSum'=0) d
	..k PLIST
	..s PLIST(0)=HISParref
	..s PLIST(3)=myInsTypeDR
	..s PLIST(4)=+myTALLNum
	..s PLIST(5)=+myTALLSum
	..s PLIST(6)=+myTALLRefNum
	..s PLIST(7)=+myTALLRefSum
	..s myrtn=##class(web.UDHCINVPRTReportsInsType).Insert()
	;中医院只收现金  暂时够用
	;DHC_INVPRTReportsPaymode---待增加支付方式后 统一更新 因为 赵的表需要改
	;b	;;;;;;
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
}

ClassMethod FootHisId(TMPJID As %String, FootUserId As %String)
{
	;w ##class(web.UDHCJFOPHandin8).FootHisId(110,"156^157")
	n (TMPJID,FootUserId)
	q:$g(TMPJID)="" ""_"^"_""
	s HisIdStr=$g(^TMPRepHisRowId(TMPJID,"His_RowId"))
	s rtn=0
	d ..tb()
	k ^TMPRepHisRowId(TMPJID,"His_RowId")
	s rtn=..UpdateHisInsFoot(HisIdStr,FootUserId)
	i rtn=0 d ..tc()
	e  tro
	quit rtn_"^"_HisIdStr
}

ClassMethod UpdateHisInsFoot(HisIdStr, FootUserId)
{
	;HIS_INSFootDate HIS_INSFootTime HIS_INSFootUser
	n (HisIdStr,FootUserId)
	s FootDate=+$h	;$zd($h,3)
	s FootTime=+$p($h,",",2)	;$zt($h)
	s rtn=0
	K PLIST(1)
	S PLIST(2)=+$H,PLIST(3)=+$P($H,",",2)
	S PLIST(5)=FootUserId,PLIST(6)="Inv"
	&SQL(insert into DHCOPReceipt Values PLIST())
	i 'SQLCODE  s recid=%ROWID
	q:SQLCODE SQLCODE
	s HisId="",stdate=+$h,enddate="",Sum=0
	f i=1:1:$l(HisIdStr,"^")  d
	.s HisId=$p($g(HisIdStr),"^",i)
	.s FootFlag=$p($g(^DHCOPInsFoot(HisId)),"^",15) ;HIS_INSFootUser
	.q:FootFlag'=""	;已经结算的退出
	.i (HisId'="")&(rtn=0) d
	..&SQL(update dhc_invprtreports set HIS_INSFootDate=:FootDate,HIS_INSFootTime=:FootTime,HIS_INSFootUser=:FootUserId,HIS_ReportNote=:recid where His_rowid=:HisId)
	..s rtn=SQLCODE
	..s date=$p($g(^DHCOPInsFoot(HisId)),"^",2)
	..s:date<stdate stdate=date
	..s:date>enddate enddate=date
	q:rtn rtn
	
	&SQL(update DHCOPReceipt set OPRecStDate=:stdate,OPRecEndDate=:enddate where  OPREC_Rowid=:recid)
	
	q SQLCODE
}

ClassMethod GetUnFootUserId(StDate, EndDate)
{
	;w ##class(web.UDHCJFOPHandin8).GetUnFootUserId("23/05/2007","23/05/2007")
	;根据时间段 查找 此段时间，收费，但未作结算日报的收费员
	;由于中医院作出规定 日报后不允许作业务，收费结算处作限制
	n (StDate,EndDate) 
	i StDate ] "/" d 
	.s StDate=$zdh(StDate,4)
	.s EndDate=$zdh(EndDate,4)
    
    s UnFootUserStr=""

    k aryUnFootUser
	
	s PrtId=""
	
	f pdate=StDate:1:EndDate  d
	.f  s PrtId=$o(^DHCINVPRT(0,"Date",pdate,PrtId)) q:PrtId=""  d
	..q:$d(^DHCINVPRT(PrtId))=10
	..s flag=$p($g(^DHCINVPRT(PrtId)),"^",10) ;PRT_Handin
	..q:flag="Y" ;结算的退出
	..s FairType=$p($g(^DHCINVPRT(PrtId)),"^",34) ;PRT_FairType
	..q:FairType'="F" ;这里仅针对收费
	..s PrtUser=$p($g(^DHCINVPRT(PrtId)),"^",21)
	..s aryUnFootUser(PrtUser)=PrtUser
	
	s UserId=""
	f  s UserId=$o(aryUnFootUser(UserId)) q:UserId=""  d
	.s UserCode=$p($g(^SSU("SSUSR",UserId)),"^",1)	;SSUSR_Name
	.s UserName=$p($g(^SSU("SSUSR",UserId)),"^",2)	;SSUSR_Name
	.i UnFootUserStr="" d  
	..s UnFootUserStr=UserCode_" "_UserName
	.e  s UnFootUserStr=UnFootUserStr_"^"_UserCode_" "_UserName
	
	Quit UnFootUserStr
}

ClassMethod CheckFootHisId(StartDate, StartTime, EndDate, EndTime)
{
	;w ##class(web.UDHCJFOPHandin8).CheckFootHisId("24/05/2007","","24/05/2007","")
	n (StartDate, StartTime, EndDate, EndTime)
	s StartTime="00:00:00"
	s EndTime="23:59:59"
	i StartDate ] "/" d 
	.s StartDate=$zdh(StartDate,4)
	.s EndDate=$zdh(EndDate,4)
	.s StartTime=$zth(StartTime)
	.s EndTime=$zth(EndTime)
	
	s rtn=0	;控制有结算数据才可以结算
	s HisId=""
	f pdate=StartDate:1:EndDate d
	.q:rtn=1
	.f  s HisId=$o(^DHCOPInsFootI(0,"Date",pdate,HisId)) q:(HisId="")  d
	..q:$d(^DHCOPInsFoot(HisId))=10
	..s FootFlag=$p($g(^DHCOPInsFoot(HisId)),"^",15) ;HIS_INSFootUser
	..s:FootFlag="" rtn=1
	Quit rtn
}

ClassMethod GetBackInvFeeInfo(JSFunName, UserId, StartDate, StartTime, EndDate, EndTime, Flag)
{
 	;w ##class(web.UDHCJFOPHandin8).GetBackInvFeeInfo("",1,"17/05/2007","09:09:35","17/05/2007","15:55:28","")
	;为中医院日报结算提供退款明细  生成临时Global
	n (JSFunName,UserId,StartDate,StartTime,EndDate,EndTime,Flag)
	i StartDate [ "-" d 
	.s StartDate=$zdh(StartDate,3)
	.s EndDate=$zdh(EndDate,3)
	.s StartTime=$zth(StartTime)
	.s EndTime=$zth(EndTime)
	i StartDate [ "/" d 
	.s StartDate=$zdh(StartDate,4)
	.s EndDate=$zdh(EndDate,4)
	.s StartTime=$zth(StartTime)
	.s EndTime=$zth(EndTime)	
	s (myParkSum,myRefundSum,myParkNum,myRefundNum)=0
	s idx=0
	f pdate=StartDate:1:EndDate  d
	.s PrtId=""
	.f  s PrtId=$o(^DHCINVPRT(0,"Date",pdate,PrtId)) q:PrtId=""  d
	..s flag=$p($g(^DHCINVPRT(PrtId)),"^",8)
	..q:(flag="N") ;统计作废 和 红冲
	..s PrtAmt=$p($g(^DHCINVPRT(PrtId)),"^",1)
	..q:PrtAmt>=0  ;方便统计
	..s ParkPrtUserDr=$p($g(^DHCINVPRT(PrtId)),"^",21)
	..q:(ParkPrtUserDr'=UserId)&(UserId'="") ;过滤用户
	..s ParkPrtDate=$p($g(^DHCINVPRT(PrtId)),"^",5)
	..s ParkPrtTime=$p($g(^DHCINVPRT(PrtId)),"^",20)
	..q:(ParkPrtDate=EndDate)&(ParkPrtTime>=EndTime)
	..q:(ParkPrtDate=StartDate)&(ParkPrtTime<StartTime)
	..s PayModeDr=$p($g(^DHCINVPRT(PrtId,"P",1)),"^",1)
	..s PayModeDesc=$p($g(^CT("CTPM",PayModeDr)),"^",2)
	..s BCIId=$o(^DHCBCI(0,"INV",PrtId,"0"))
	..s AdmId=$p($g(^DHCBCI(BCIId)),"^",3)
	..s PrtAdmLocDr=$p($g(^PAADM(AdmId)),"^",4)  ;PAADM_DepCode_DR
	..s PrtAdmLoc=$p($g(^CTLOC(PrtAdmLocDr)),"^",2)
	..s:(PrtAdmLoc ] "-") PrtAdmLoc=$p(PrtAdmLoc,"-",2)
	..s PrtPapmiDR=$p($G(^DHCINVPRT(PrtId)),"^",15)
	..s PatNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	..s PatName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	..s ParkReason=""
	..s ParkReason=$p($g(^DHCINVPRT(PrtId)),"^",32)	;PRT_RefundReason
	..s PrtInitDr=$p($g(^DHCINVPRT(PrtId)),"^",13)
	..s PrtNo=$p($g(^DHCINVPRT(PrtInitDr)),"^",14)
	..s PrtUserDr=$p($g(^DHCINVPRT(PrtInitDr)),"^",21)
	..s PrtDate=$p($g(^DHCINVPRT(PrtInitDr)),"^",5)
	..s PrtTime=$p($g(^DHCINVPRT(PrtInitDr)),"^",20)
	..s PrtUserName=$p($g(^SSU("SSUSR",PrtUserDr)),"^",2)
	..s ParkPrtUserName=$p($g(^SSU("SSUSR",ParkPrtUserDr)),"^",2)
	..s idx=idx+1
	..s myList=""
	..i flag="S" d
	...s ParkReason="红冲"
	...s myRefundSum=myRefundSum+PrtAmt
	...s myRefundNum=myRefundNum+1
	..i flag="A"  d
	...s ParkReason="作废"
	...s myParkSum=myParkSum+PrtAmt
	...s myParkNum=myParkNum+1
	..s myList=PrtNo_"^"_PatName
	..s myList=myList_"^"_$fn(PrtAmt,"",2)_"^"_PayModeDesc_"^"_PrtAdmLoc
	..s myList=myList_"^"_PrtUserName_"^"_$zd(PrtDate,3)_" "_$zt(PrtTime)
	..s myList=myList_"^"_ParkPrtUserName_"^"_ParkReason
	..s rtnval=JSFunName_"('"_$ZCVT($g(myList),"O","JS")_"');"
	..;w rtnval,!
	..&javascript<#(rtnval)#>
	d
	.s myList="合计: "_"^"_"作废金额"_"^"_$fn(myParkSum,"",2)
	.s myList=myList_"^"_"笔数"_"^"_myParkNum
	.s myList=myList_"^"_"红冲金额"_"^"_$fn(myRefundSum,"",2)
	.s myList=myList_"^"_"笔数"_"^"_myRefundNum
	.s rtnval=JSFunName_"('"_$ZCVT($g(myList),"O","JS")_"');"
	.;w rtnval,!
	.&javascript<#(rtnval)#>
	Quit $$$OK
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

ClassMethod GetHandReports(JSFunName As %String = "", RepID As %String = "")
{
	n (JSFunName,RepID)
	s rtnval=""
	s HisId=$g(RepID)
	Quit:HisId="" ""
	s (stDate,stTime,endDate,endTime)=""
	s (UserCode,UserName)=""
	s InvNum=0,InvInfo=""
	s (TotalSum,PatSum,PayorSum,GetSum,BackSum)=0
	s (DrugSum,MedSum)=0
	s (NormalCashNum,ParkCashNum,RefundCashNum,NormalCashSum,ParkCashSum,RefundCashSum)=0
	s (NormalCheckNum,ParkCheckNum,RefundCheckNum,NormalCheckSum,ParkCheckSum,RefundCheckSum)=0
	s CheckSumAll=0,CheckNumAll=0
	s CashPatSum=0,CheckPatSum=0
	s DrugCatStr=..getStatDrugCatStr()
	f i=1:1:$l(DrugCatStr,"^") d
	.s myCatItemDr=$p(DrugCatStr,"^",i)
	.s aryDrug(myCatItemDr)=myCatItemDr
	s myList=""
	.s stDate=$p($g(^DHCOPInsFoot(HisId)),"^",5)
	.s stTime=$p($g(^DHCOPInsFoot(HisId)),"^",6)
	.s endDate=$p($g(^DHCOPInsFoot(HisId)),"^",3)
	.s endTime=$p($g(^DHCOPInsFoot(HisId)),"^",4)
	.s UserDr=$p($g(^DHCOPInsFoot(HisId)),"^",8)
	.s UserCode=$p($g(^SSU("SSUSR",UserDr)),"^",1)	;SSUSR_Name
	.s UserName=$p($g(^SSU("SSUSR",UserDr)),"^",2)	;SSUSR_Name
 	.s HisNum=+$p($g(^DHCOPInsFoot(HisId)),"^",9)
 	.s HisAmount=+$p($g(^DHCOPInsFoot(HisId)),"^",1)
 	.s HisPatSum=+$p($g(^DHCOPInsFoot(HisId)),"^",16)
 	.s HisCashNum=+$p($g(^DHCOPInsFoot(HisId)),"^",17)	;存的是该收费员 今天打的票据
 	.s HisCashSum=+$p($g(^DHCOPInsFoot(HisId)),"^",18)
	.s HisRefundNum=+$p($g(^DHCOPInsFoot(HisId)),"^",21)
	.s HisRefundSum=+$p($g(^DHCOPInsFoot(HisId)),"^",22)
	.s HisParkNum=+$p($g(^DHCOPInsFoot(HisId)),"^",23)
	.s HisParkSum=+$p($g(^DHCOPInsFoot(HisId)),"^",24)
	.s InvNum=HisNum+HisRefundNum	
	.s InvSum=HisCashSum
	.s InvInfo=$p($g(^DHCOPInsFoot(HisId)),"^",10)
	.s ParkInvNum=HisParkNum
	.s ParkInvSum=HisParkSum
	.s ParkInvInfo=$p($g(^DHCOPInsFoot(HisId)),"^",25)
	.s RefundInvNum=HisRefundNum
	.s RefundInvSum=HisRefundSum
	.s RefundInvInfo=$p($g(^DHCOPInsFoot(HisId)),"^",26)
	.s TotalSum=$fn(HisAmount,"",2)
	.s PatSum=$fn(HisPatSum,"",2)
	.s PayorSum=""	;		$fn(HisAmount,"",2)	;
	.s GetSum=$fn(HisCashSum,"",2)
	.s BackSum=$fn($zabs(HisParkSum+HisRefundSum),"",2)
	.;费用分类
	.s (TDrugSum,TMedSum)=0
	..s HisSub="0"
	..f  s HisSub=$o(^DHCOPInsFoot(HisId,"C",HisSub)) q:HisSub=""  d
	...s myPatCatDr=$p($g(^DHCOPInsFoot(HisId,"C",HisSub)),"^",1)
	...s myPatCatFee=$p($g(^DHCOPInsFoot(HisId,"C",HisSub)),"^",2)
	...i $g(aryDrug(myPatCatDr))'="" d
	....s TDrugSum=$fn(myPatCatFee+TDrugSum,"",2)
	...e  s TMedSum=$fn(myPatCatFee+TMedSum,"",2)
	.s DrugSum=$fn(TDrugSum,"",2)
	.s MedSum=$fn(TMedSum,"",2)
	.;支付方式  
	.s NormalCashNum=HisCashNum-HisParkNum
	.s ParkCashNum=HisParkNum
	.s RefundCashNum=HisRefundNum
	.s NormalCashSum=$fn(HisCashSum-HisParkSum,"",2)
	.s ParkCashSum=$fn(HisParkSum,"",2)
	.s RefundCashSum=$fn(HisRefundSum,"",2)
	.s CashPatSum=HisCashSum+HisParkSum+RefundInvSum
	.s CheckPatSum=0
	.;病人费别  DHC_INVPRTReportsInsType
	.s (TCatSum1,TCatSum2,TCatSum3,TCatSum4)=0
	..s ItcSub="0"
	..f  s ItcSub=$o(^DHCOPInsFoot(HisId,"IC",ItcSub)) q:ItcSub=""  d
	...s myPatInsType=$p($g(^DHCOPInsFoot(HisId,"IC",ItcSub)),"^",1)
	...s myPatAmt=+$p($g(^DHCOPInsFoot(HisId,"IC",ItcSub)),"^",3)
	...s:myPatInsType="1" TCatSum1=$fn(+myPatAmt+TCatSum1,"",2)
	...s:myPatInsType="2" TCatSum2=$fn(+myPatAmt+TCatSum2,"",2)	
	.s myList=UserDr_"^"_UserCode_"^"_UserName
	.s myList=myList_"^"_$zd(stDate)_"^"_$zt(stTime)_"^"_$zd(endDate)_"^"_$zt(endTime)
	.s myList=myList_"^"_TotalSum_"^"_PatSum_"^"_PayorSum_"^"_GetSum_"^"_BackSum
	.s myList=myList_"^"_DrugSum_"^"_MedSum
	.s myList=myList_"^"_InvNum_"^"_InvSum_"^"_InvInfo_"^"_ParkInvNum_"^"_ParkInvSum_"^"_ParkInvInfo_"^"_RefundInvNum_"^"_RefundInvSum_"^"_RefundInvInfo
	.s myList=myList_"^"_NormalCashNum_"^"_ParkCashNum_"^"_RefundCashNum_"^"_NormalCashSum_"^"_ParkCashSum_"^"_RefundCashSum
	.s myList=myList_"^"_NormalCheckNum_"^"_ParkCheckNum_"^"_RefundCheckNum_"^"_NormalCheckSum_"^"_ParkCheckSum_"^"_RefundCheckSum
	.s myList=myList_"^"_CheckSumAll_"^"_CheckNumAll
	.s myList=myList_"^"_CashPatSum_"^"_CheckPatSum
	.s rtnval=JSFunName_"('"_$ZCVT($g(myList),"O","JS")_"');"
	.&javascript<#(rtnval)#>
	Quit
}

ClassMethod ReadRepsDetails(RepID As %String = "") As %String
{
	;w ##class(web.udhcOPQUERY).ReadRepsDetails("47")
	Q:RepID="" ""
	;s rtn=##class(%ResultSet).RunQuery("web.udhcOPQUERY","INVFootRep",167)
	Set rset = ##class(%ResultSet).%New("web.udhcOPQUERY:INVFootRep")
	Set columns = rset.GetColumnCount()
	Set rs = rset.Execute(RepID)
	s myIdx=0
	s rtnval=""
	While (rset.Next()) {
		s myRowVal=""
		For mycol=1:1:columns {
			s mydata=rset.GetData(mycol)
			if ("^3^5^7^")[("^"_mycol_"^") d
				.s mydata=$zd(mydata,3)
			else  if ("^4^6^8^")[("^"_mycol_"^") d
				.s mydata=$zt(mydata,1)
			s myRowVal=$g(myRowVal)_$g(mydata)_"^"	//行集
		}
		s rtnval=$ZCVT($g(myRowVal),"O","JS")			;$g(myval)
 }
 	s HisId=RepID
 	s (GetTotal,GiveTotal,CashTotal,CheckTotal)=0.00
  	s (HisCashNum,HisCashSum,HisRefundNum,HisRefundSum,HisParkNum,HisParkSum,HisCheckSum)=0
 	.s HisNum=+$p($g(^DHCOPInsFoot(HisId)),"^",9)
 	.s HisAmount=+$p($g(^DHCOPInsFoot(HisId)),"^",1)
 	.s HisPatSum=+$p($g(^DHCOPInsFoot(HisId)),"^",16)
 	.s HisCashNum=+$p($g(^DHCOPInsFoot(HisId)),"^",17)	;存的是该收费员 今天打的票据
 	.s HisCashSum=+$p($g(^DHCOPInsFoot(HisId)),"^",18)
	.s HisRefundNum=+$p($g(^DHCOPInsFoot(HisId)),"^",21)
	.s HisRefundSum=+$p($g(^DHCOPInsFoot(HisId)),"^",22)
	.s HisParkNum=+$p($g(^DHCOPInsFoot(HisId)),"^",23)
	.s HisParkSum=+$p($g(^DHCOPInsFoot(HisId)),"^",24)
	.s HisCheckSum=+$p($g(^DHCOPInsFoot(HisId)),"^",20)
 	s GetTotal=HisCashSum	;-HisParkSum
 	s GiveTotal=HisParkSum+HisRefundSum
 	s CashTotal=HisCashSum	;-HisParkSum
 	s CheckTotal=HisCheckSum
 	s DrugCatStr=..getStatDrugCatStr()
	f i=1:1:$l(DrugCatStr,"^") d
	.s myCatItemDr=$p(DrugCatStr,"^",i)
	.s aryDrug(myCatItemDr)=myCatItemDr
 	s (DrugSum,MedSum)=0
 	.;费用分类
	.s (TDrugSum,TMedSum)=0
	..s HisSub="0"
	..f  s HisSub=$o(^DHCOPInsFoot(HisId,"C",HisSub)) q:HisSub=""  d
	...s myPatCatDr=$p($g(^DHCOPInsFoot(HisId,"C",HisSub)),"^",1)
	...s myPatCatFee=$p($g(^DHCOPInsFoot(HisId,"C",HisSub)),"^",2)
	...i $g(aryDrug(myPatCatDr))'="" d
	....s TDrugSum=$fn(myPatCatFee+TDrugSum,"",2)
	...e  s TMedSum=$fn(myPatCatFee+TMedSum,"",2)
	.s DrugSum=$fn(TDrugSum,"",2)
	.s MedSum=$fn(TMedSum,"",2)
	s (myCashSum,myCashNum,myParkCashSum,myParkCashNum,myRefundCashSum,myRefundCashNum)=0
	s (myChequeSum,myChequeNum,myParkChequeSum,myParkChequeNum,myRefundChequeSum,myRefundChequeNum)=0
	;票据明细
	s myCashSum=HisCashSum-$zabs(HisRefundSum)
	s myCashNum=HisCashNum-$zabs(HisRefundNum)
	s myParkCashSum=$zabs(HisParkSum)
	s myParkCashNum=$zabs(HisParkNum)
	s myRefundCashSum=$zabs(HisRefundSum)
	s myRefundCashNum=$zabs(HisRefundNum)
	s CashInfo=myCashNum_"^"_myCashSum_"^"_myParkCashNum_"^"_myParkCashSum_"^"_myRefundCashNum_"^"_myRefundCashSum
	s ChequeInfo=myChequeNum_"^"_myChequeSum_"^"_myParkChequeNum_"^"_myParkChequeSum_"^"_myRefundChequeNum_"^"_myRefundChequeSum
	s rtnval=rtnval_"^"_DrugSum_"^"_MedSum_"^"_GetTotal_"^"_GiveTotal_"^"_CashTotal_"^"_CheckTotal_"^"_CashInfo_"^"_ChequeInfo
	quit rtnval
}

Query QueryReports(RepID As %String = "") As %SQLQuery(CONTAINID = 1)
{
	
    select  ss_user.ssusr_name,dhc_invprtreports.* from ss_user,dhc_invprtreports where his_rowid=:RepID and his_user=ssusr_rowid
}

Query QueryReportsInsType(RepID As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM DHC_INVPRTReportsInsType where itc_rep_parref=:RepID
}

Query QueryReportsPaymode(RepID As %String) As %SQLQuery(CONTAINID = 1)
{
   SELECT * FROM DHC_INVPRTReportsPaymode where HisPay_ParRef=:RepID
}

Query QueryReportsSub(RepID As %String) As %SQLQuery(CONTAINID = 1)
{
    SELECT * FROM DHC_INVPRTReportsSub where HisSub_parref=:RepID
}

ClassMethod GetFootDate(Expr As %String)
{
   n (Expr)
   s rtn=0
   s (stDate,stTime,endDate,endTime)=""
   &sql(select min(his_rowid) into:stHisId from dhc_invprtreports where HIS_INSFootDate is null and his_date<>"")
   i stHisId'=""  d
   .s stDate=$p($g(^DHCOPInsFoot(stHisId)),"^",2)	;his_date
   .s stTime=$p($g(^DHCOPInsFoot(stHisId)),"^",7)	;his_time
   .s rtn=1
   i stDate="" s stDate=+$h
   i stTime="" s stTime=$p($h,",",2)
   Quit $zd(stDate,4)_"^"_$zt(stTime)_"^"_rtn
}

ClassMethod GetInitDate()
{
	;w ##class(web.UDHCJFOPHandin8).GetInitDate()
   s stDate=+$h
   s stTime=$p($h,",",2)
   
   Quit $zd(stDate,4)_"^"_$zt($zth("00:00:00"))
}

ClassMethod getpattype()
{
	 s pattypedr="0",pattypedes="",num=0,str=""
	 f  s pattypedr=$o(^PAC("ADMREA",pattypedr)) q:pattypedr=""  d
	 .q:'$d(^PAC("ADMREA",pattypedr))
	 .s pattypedes=$p($g(^PAC("ADMREA",pattypedr)),"^",2)
	 .s str=str_"^"_pattypedes
	 .s num=num+1
	 q str
}

ClassMethod GetFootNum(Guser)
{
	//w ##class(web.UDHCJFEPDailyHand).GetFootNum("4707")
	s gnum=$o(^TMP("MZJF","FootDetail",Guser,""),-1)
 	q gnum
}

ClassMethod GetFootData(Guser, ind)
{
	//w ##class(web.UDHCJFEPDailyHand).GetFootData("4707")
	s str=^TMP("MZJF","FootDetail",Guser,ind)
 	q str
}

ClassMethod GetCTNum(Guser)
{
	//w ##class(web.UDHCJFEPDailyHand).GetFootNum("4707")
	s gnum=$o(^TMP("MZJF","CTInvDetail",Guser,""),-1)
 	q gnum
}

ClassMethod GetCTData(Guser, ind)
{
	//w ##class(web.UDHCJFEPDailyHand).GetFootData("4707")
	s str=^TMP("MZJF","CTInvDetail",Guser,ind)
 	q str
}

/// Creator:  yyx
/// CreateDate:2010-09-02
/// Function  :收费员日报汇总的按分类汇总
/// OutPut    :分类名称_"^"_正常的总费用_"^"_作废金额_"^"_红冲金额_"^"_合计
ClassMethod GetCateFee(Guser)
{
	;w ##class(web.UDHCJFOPHandin8).GetCateFee(1)
	s OutCateStr="",PrtCateNormalSum=0,PrtCateAbortSum=0,PrtCateStrikeSum=0,PrtAllSum=0
	s CateDesc=""
	f  s CateDesc=$o(^TMP("MZJF","HZCate",Guser,CateDesc)) q:CateDesc=""  d
	.s PrtCateNormalFee=^TMP("MZJF","HZCate",Guser,CateDesc,"N")
	.s PrtCateAbortFee=^TMP("MZJF","HZCate",Guser,CateDesc,"A")
	.s PrtCateStrikeFee=^TMP("MZJF","HZCate",Guser,CateDesc,"S")
	.s PrtCateSum=PrtCateNormalFee+PrtCateAbortFee+PrtCateStrikeFee
	.s PrtCateNormalSum=PrtCateNormalSum+PrtCateNormalFee
	.s PrtCateAbortSum=PrtCateAbortSum+PrtCateAbortFee
	.s PrtCateStrikeSum=PrtCateStrikeSum+PrtCateStrikeFee
	.s PrtAllSum=PrtAllSum+PrtCateSum
	.i OutCateStr="" s OutCateStr=CateDesc_"^"_PrtCateNormalFee_"^"_PrtCateAbortFee_"^"_PrtCateStrikeFee_"^"_PrtCateSum
	.e  s OutCateStr=OutCateStr_"&"_CateDesc_"^"_PrtCateNormalFee_"^"_PrtCateAbortFee_"^"_PrtCateStrikeFee_"^"_PrtCateSum
	s OutCateStr=OutCateStr_"&"_"合计"_"^"_PrtCateNormalSum_"^"_PrtCateAbortSum_"^"_PrtCateStrikeSum_"^"_PrtAllSum
	q OutCateStr
}

ClassMethod GetHanInInfo(StDate, EndDate, CurUserId, ZType)
{
	s RepIdStr=""
	s userjzdetail=""

	s (RepId,TUserCode,TUserName,THaninDT,BegFootDT,EndFootDT)=""
	s (TInvNum,TPatShare,TAcountSum,TGetSum,TGiveSum,TDrugSum,TMedSum,TCashSum,TCashNum,TParkCashSum,TParkCashNum,TCheckSum,TCheckNum,TParkCheckSum,TParkCheckNum)=0
	s (TCatSum1,TCatSum2,TCatSum3,TCatSum4)=0
	s (TInvNumAll,TPatShareAll,TAcountSumAll,TGetSumAll,TGiveSumAll,TDrugSumAll,TMedSumAll,TCashSumAll,TCashNumAll,TParkCashSumAll,TParkCashNumAll,TCheckSumAll,TCheckNumAll,TParkCheckSumAll,TParkCheckNumAll,TCatSum1All,TCatSum2All,TCatSum3All,TCatSum4All)=0
	s (Allnormalnum,Allnormalno,Allnormalsum,Allzfnum,Allzfsum,Allhcnum,Allhcsum,Allallsum)=0
	s (ALLASum,ALLNSum,ALLSSum,ALLTSum)=0
	s zfno="",hcno="",normalno="",CTNum=1
	s (TCatSum(1),TCatSum(2),TCatSum(3),TCatSum(4),TCatSum(5),TCatSum(6))=""
	s (TCatSum(7),TCatSum(8),TCatSum(9),TCatSum(10),TCatSum(11),TCatSum(12))=""
	s (TCatSum(13),TCatSum(14),TCatSum(15),TCatSum(16),TCatSum(17),TCatSum(18))=""
	s (TCatSum(19),TCatSum(20),TCatSum(21),TCatSum(22),TCatSum(23),TCatSum(24),TCatSum(25))=""
	//add by lichao 20100514
	k ^TMP("MZJF","HZCate",CurUserId)
	k ^TMP("MZJF","CTInvDetail",CurUserId)
	k ^TMP("MZJF","FootDetail",CurUserId)
	k ^TMP("MZJF","AllHZCate",CurUserId)
	k ^TMP("DHCOPBill","BuildPayMFeeByDate",Job)
	k ^TMP("MZJF","UserHZCate",$j)   ;按收费员汇总分类
	k ^TMP("UDHCJFOPHandin8",Job)
	k ^TMP("MZJF","USEROUTCATE",$j)
	s TarOcRowID=0
    f  s TarOcRowID=$o(^DHCTarC("TOC",TarOcRowID))  q:TarOcRowID=""  d
    .s OPCatDesc=$p(^DHCTarC("TOC",TarOcRowID),"^",2)
    .s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"N")=0
    .s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"A")=0
    .s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"S")=0
     s Rowid="0"
    f  s Rowid=$o(^CT("CTPM",Rowid)) q:Rowid=""  d
    .s ^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"ALL",Rowid)=0
	s FootNum=1
	s HisId=""
	s TFootFlag=""
	f pdate=StDate:1:EndDate d
	.f  s HisId=$o(^DHCOPInsFootI(0,"Date",pdate,HisId)) q:HisId=""  d
	..q:$d(^DHCOPInsFoot(HisId))=10
	..s ReportType=$p($g(^DHCOPInsFoot(HisId)),"^",60) ;HIS_INSFootUser
	..q:ReportType="R"
	..s UserDr=$p($g(^DHCOPInsFoot(HisId)),"^",8)       ;HIS_User
	..s TarOcRowID=0
	..f  s TarOcRowID=$o(^DHCTarC("TOC",TarOcRowID))  q:TarOcRowID=""  d
    ...s OPCatDesc=$p(^DHCTarC("TOC",TarOcRowID),"^",2)
    ...s ^TMP("MZJF","UserHZCate",$j,UserDr,OPCatDesc)=0
	
	f pdate=StDate:1:EndDate d
	.f  s HisId=$o(^DHCOPInsFootI(0,"Date",pdate,HisId)) q:HisId=""  d
	..q:$d(^DHCOPInsFoot(HisId))=10
	..s ReportType=$p($g(^DHCOPInsFoot(HisId)),"^",60) ;HIS_INSFootUser
	..q:ReportType="R"
	..s FootFlag=$p($g(^DHCOPInsFoot(HisId)),"^",15) ;HIS_INSFootUser
	..s FootDr=$p($g(^DHCOPInsFoot(HisId)),"^",67)        ;HIS_ReportNote
	..s:FootFlag'="" FootFlag="Y"
	..s:FootFlag="" FootFlag="N"
	..;q:(FootFlag'=StatFlag)&&(StatFlag'="")
	..;q:(FootFlag="Y")&&(FootDr'=RecDr)
	..;q:StatFlag="" ;不查全部
	..s UserDr=$p($g(^DHCOPInsFoot(HisId)),"^",8)       ;HIS_User
	
	..s normalnum=0,normalsum=0,hcnum=0,hcsum=0,zfnum=0,zfsum=0,allsum=0
    ..k ^TMP("EPInvDailyHand/No",UserDr,"Abort","no")
    ..k ^TMP("EPInvDailyHand/No",UserDr,"Strik","no")
    ..k ^TMP("EPInvDailyHand/No",UserDr,"Normal","no")
	..s RepId=HisId
	..s userjzdetail=..BuildPayMFeeByHisRowID(HisId,ZType)

	..s TUserCode=$p($g(^SSU("SSUSR",UserDr)),"^",1)	;SSUSR_Name
	..s TUserName=$p($g(^SSU("SSUSR",UserDr)),"^",2)	;SSUSR_Name
	..s myStDate=$p($g(^DHCOPInsFoot(HisId)),"^",5)
	..s myStTime=$p($g(^DHCOPInsFoot(HisId)),"^",6)
	..s myEndDate=$p($g(^DHCOPInsFoot(HisId)),"^",3)
	..s myEndTime=$p($g(^DHCOPInsFoot(HisId)),"^",4)
	..s myHisDate=$p($g(^DHCOPInsFoot(HisId)),"^",2)
	..s myHisTime=$p($g(^DHCOPInsFoot(HisId)),"^",7)
	..s RecDate=$p($g(^DHCOPInsFoot(HisId)),"^",13)
	..s RecTime=$p($g(^DHCOPInsFoot(HisId)),"^",14)
	..s THaninDT=$zd(myHisDate,3)_" "_$zt(myHisTime)
	..s BegFootDT=$zd(myStDate,3)_" "_$zt(myStTime)
	..s EndFootDT=$zd(myEndDate,3)_" "_$zt(myEndTime)
	..s TFootFlag=$zd(RecDate,3)_" "_$zt(RecTime)
	..i RecDate="" s TFootFlag=""
	..s TInvNum=$p($g(^DHCOPInsFoot(HisId)),"^",9)
	..s TPatShare=$p($g(^DHCOPInsFoot(HisId)),"^",16)	;HIS_PatSum
	..s TAcountSum=$p($g(^DHCOPInsFoot(HisId)),"^",1)
	..s TGiveSum=$p($g(^DHCOPInsFoot(HisId)),"^",22)+$p($g(^DHCOPInsFoot(HisId)),"^",24)  ;HIS_RefundSum+HIS_ParkSum
	..s TGetSum=$p($g(^DHCOPInsFoot(HisId)),"^",18)+$p($g(^DHCOPInsFoot(HisId)),"^",20)   ;HIS_CashNum+HIS_CheckNum
	..;支付方式字表 DHC_INVPRTReportsPaymode
	..;add by lc 2008-06-10 收据张数 号段 金额 作废收据张数 作废号段 作废金额 红冲收据张数 红冲张数 红冲金额
	..;s normalnum=0,normalsum=0,hcnum=0,hcsum=0,zfnum=0,zfsum=0,allsum=0
    ..;k ^TMP("EPInvDailyHand/No",UserDr,"Abort","no")
    ..;k ^TMP("EPInvDailyHand/No",UserDr,"Strik","no")
    ..;k ^TMP("EPInvDailyHand/No",UserDr,"Normal","no")
    ..;s userjzdetail=""
	..;s userjzdetail=##class(web.DHCOPBillFoot).GetFPDetail(HisId, UserDr, Job,CurUserId,ZType)
	..;q:userjzdetail=""
	..;W !,userjzdetail
	..s normalnum=$P(userjzdetail,"^",1)
	..s normalno=$P(userjzdetail,"^",2)
	..s normalsum=$P(userjzdetail,"^",3)
	..s zfnum=$P(userjzdetail,"^",4)
	..s zfno=$P(userjzdetail,"^",5)
	..s zfsum=$P(userjzdetail,"^",6)
	..s hcnum=$P(userjzdetail,"^",7)
	..s hcno=$P(userjzdetail,"^",8)
	..s hcsum=$P(userjzdetail,"^",9)
	..s allsum=$P(userjzdetail,"^",10)
	..s Allnormalnum=Allnormalnum+normalnum
	..s Allnormalno=Allnormalno+normalno
	..s Allnormalsum=Allnormalsum+normalsum
	..s Allzfnum=Allzfnum+zfnum
	..s Allzfsum=Allzfsum+zfsum
	..s Allhcnum=Allhcnum+hcnum
	..s Allhcsum=Allhcsum+hcsum
	..s Allallsum=Allallsum+allsum
	..i RepIdStr=""  d
	...s RepIdStr=HisId
	..e  s RepIdStr=RepIdStr_"^"_HisId
	..s TInvNumAll=TInvNumAll+TInvNum 
	..s TPatShareAll=TPatShareAll+TPatShare 
	..s TAcountSumAll=TAcountSum+TAcountSumAll 
	..s TGetSumAll=TGetSumAll+TGetSum 
	..s TGiveSumAll=TGiveSumAll+TGiveSum 
	..s TDrugSumAll=TDrugSumAll+TDrugSum 
	..s TMedSumAll=TMedSumAll+TMedSum 
	..s TCashSumAll=TCashSumAll+TCashSum 
	..s TCashNumAll=TCashNumAll+TCashNum 
	..s TParkCashSumAll=TParkCashSumAll+TParkCashSum
	..s TParkCashNumAll=TParkCashNum +TParkCashNumAll
	..s TCheckSumAll=TCheckSumAll+TCheckSum 
	..s TCheckNumAll=TCheckNumAll+TCheckNum 
	..s TParkCheckSumAll= TParkCheckSumAll+TParkCheckSum
	..s TParkCheckNumAll=TParkCheckNumAll+TParkCheckNum 
	..s TCatSum1All=TCatSum1All+TCatSum1 
	..s TCatSum2All=TCatSum2All+TCatSum2 
	..s TCatSum3All=TCatSum3All+TCatSum3
	..s TCatSum4All=TCatSum4All+TCatSum4
	..d OutPutDailyRepFoot
	s ^TMPRepHisRowId(myTMPJID,"His_RowId")=RepIdStr
	s (RepId,TUserCode,TUserName,THaninDT,BegFootDT,EndFootDT,TInvNum,TPatShare,TAcountSum,TGetSum,TGiveSum,TDrugSum,TMedSum,TCashSum,TCashNum,TParkCashSum,TParkCashNum,TCheckSum,TCheckNum,TParkCheckSum,TParkCheckNum,TCatSum1,TCatSum2,TCatSum3,TCatSum4,TFootFlag)=""
	s TUserCode=""
	s TUserName="合计"
	s TInvNum=TInvNumAll
	s TPatShare=TPatShareAll 
	s TAcountSum=TAcountSumAll
	s TGetSum=TGetSumAll
	s TGiveSum=TGiveSumAll
	s TDrugSum=TDrugSumAll
	s TMedSum=TMedSumAll
	s TCashSum=TCashSumAll
	s TCashNum=TCashNumAll
	s TParkCashSum=TParkCashSumAll
	s TParkCashNum=TParkCashNumAll 
	s TCheckSum=TCheckSumAll
	s TCheckNum=TCheckNumAll
	s TParkCheckSum= TParkCheckSumAll
	s TParkCheckNum=TParkCheckNumAll
	s TFootFlag=""
	s normalnum=Allnormalnum
	s normalno=""
	s normalsum=Allnormalsum
	s zfnum=Allzfnum
	s zfno=""
	s zfsum=Allzfsum
	s hcnum=Allhcnum
	s hcno=""
	s hcsum=Allhcsum
	s allsum=Allallsum
	d OutPutDailyRepFoot
	
	;按收费员门诊费用分类输出
	s num=1,PrtUser=""
	k AllCateSum
	s AllCateStr="合计"
	s Sum=0
	f  s PrtUser=$o(^TMP("MZJF","UserHZCate",$j,PrtUser)) q:PrtUser=""  d
	.s num=num+1,UserSum=0
	.s TmpStr=PrtUser,CateStr="用户"
	.s OPCate=""
	.f  s OPCate=$o(^TMP("MZJF","UserHZCate",$j,PrtUser,OPCate)) q:OPCate=""  d
	..s CateStr=CateStr_"^"_OPCate
	..s OPCateSum=^TMP("MZJF","UserHZCate",$j,PrtUser,OPCate)
	..s UserSum=UserSum+OPCateSum
	..s TmpStr=TmpStr_"^"_OPCateSum
	..s AllCateSum(OPCate)=+$g(AllCateSum(OPCate))+OPCateSum
	.s TmpStr=TmpStr_"^"_UserSum
	.s Sum=Sum+UserSum
	.s ^TMP("MZJF","USEROUTCATE",$j,num)=TmpStr
	s ^TMP("MZJF","USEROUTCATE",$j,1)=$g(CateStr)_"^"_"小计"
	s OPCate=""
	f  s OPCate=$o(AllCateSum(OPCate)) q:OPCate=""  d
	.s AllCateStr=AllCateStr_"^"_AllCateSum(OPCate)
	s num=num+1
	s ^TMP("MZJF","USEROUTCATE",$j,num)=AllCateStr_"^"_$g(UserSum)
	
	Q
	;Set qHandle=$lb(0,repid,0)
	;Quit $$$OK
OutPutDailyRepFoot
	;;编号	收款员	收据数	应缴金额	费用总额	实际收款	笔数	实际退款	笔数	药品收入	医疗收入	现费	医保	工疗	统筹													
	s ^TMP("MZJF","FootDetail",CurUserId,FootNum)=TUserName_"^"_normalnum_"^"_normalno_"^"_normalsum_"^"_zfnum_"^"_zfsum_"^"_hcnum_"^"_hcsum_"^"_allsum
	s FootNum=FootNum+1
	set Data=$lb(RepId,TUserCode,TUserName,THaninDT,BegFootDT,EndFootDT,TInvNum,TPatShare,TAcountSum,TGetSum,TGiveSum,TDrugSum,TMedSum,TCashSum,TCashNum,TParkCashSum,TParkCashNum,TCheckSum,TCheckNum,TParkCheckSum,TParkCheckNum,TCatSum(1),TCatSum(2),TCatSum(3),TCatSum(4),TCatSum(5),TCatSum(6),TCatSum(7),TCatSum(8),TCatSum(9),TCatSum(10),TCatSum(11),TCatSum(12),TCatSum(13),TCatSum(14),TCatSum(15),TCatSum(16),TCatSum(17),TCatSum(18),TCatSum(19),TCatSum(20),TCatSum(21),TCatSum(22),TCatSum(23),TCatSum(24),TCatSum(25),myTMPJID,TFootFlag,normalnum,normalno,normalsum,zfnum,zfno,zfsum,hcnum,hcno,hcsum,allsum,Job)
	Set ^CacheTemp(repid,index)=Data
	s myPRTData=$lb(TUserCode,TUserName,TInvNum,TPatShare,TAcountSum,TGetSum,TGiveSum,TDrugSum,TMedSum,TCatSum1,TCatSum2,TCatSum3,TCatSum4)
	;s myPRTData=##class(web.DHCOPConfig).TransLBToStr(myPRTData)
	;s ^TMPOPPrintOut(myTMPJID,index)=myPRTData
	Set index=index+1
	quit
}

/// 按支付方式汇总
/// w ##class(web.UDHCJFOPHandin8).BuildPayMFeeByHisRowID(1631)
ClassMethod BuildPayMFeeByHisRowID(FootDr, ZType)
{
   
    s FUsr=$p(^DHCOPInsFoot(FootDr),"^",8)
    s Rowid="0"
    f  s Rowid=$o(^CT("CTPM",Rowid)) q:Rowid=""  d
    .s ^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"User",FootDr,Rowid)=0
	s normalnum=0,normalsum=0,hcnum=0,hcsum=0,zfnum=0,zfsum=0,allsum=0
    S PrtRowID=""
    f  s PrtRowID=$o(^DHCINVPRT(0,"Report",FootDr,PrtRowID)) q:PrtRowID=""  d
    .s amt=$p(^DHCINVPRT(PrtRowID),"^",1)
    .s flag=$p(^DHCINVPRT(PrtRowID),"^",8)
    .s invno=$p(^DHCINVPRT(PrtRowID),"^",14)
    .s prtuser=$p(^DHCINVPRT(PrtRowID),"^",21)  
    .s initinv=$p(^DHCINVPRT(PrtRowID),"^",13)
    
    .s refaccdr=""
    .i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4) 
    .i ((invno="")&&(initinv'=""))  d
    ..s RefInvNo=$p(^DHCINVPRT(initinv),"^",14)
    .i flag="A"  d
    ..i invno'=""  d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Abort",prtuser,invno)
    .i flag="S"  d
    ..i initinv'=""  d
    ...s initno=$p(^DHCINVPRT(initinv),"^",14)
    ...d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Strik",prtuser,initno)
    .i ((invno'="")&&(amt>0))  d
    ..d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","Normal",prtuser,invno)
    .s BilConInv="0"
	.f  s BilConInv=$o(^DHCBCI(0,"INV",PrtRowID,BilConInv)) q:BilConInv=""  d
	..s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	..s PBAmt=$p(^DHCPB(PatBillDr),"^",8)
	..s PatAdm=$p(^DHCBCI(BilConInv),"^",3)
	..s PaadmSession=$p(^PAADM(PatAdm,2),"^",28)  ;区分特诊，正常诊，业务诊
	..i PaadmSession'="" s PaadmSession=$p(^PAC("IPAT",PaadmSession),"^",2) 
    .;q:(PaadmSession'=ZType)&(ZType'="")
    .s allsum=+allsum+(+amt)
	.i flag="A"  d
    ..s:invno'="" zfnum=+zfnum+1
    ..s:initinv'="" zfsum=+zfsum+(+amt)
    .i flag="S"  d
    ..s:initinv'="" hcnum=+hcnum+1
    ..s:initinv'="" hcsum=+hcsum+(+amt)
    .i ((invno'="")&&(amt>0))  d
    ..s normalnum=normalnum+1
    ..s normalsum=+normalsum+(+amt)
	.q:'$D(^DHCPB(PatBillDr))
	.s Ord="" f  s Ord=$o(^DHCPB(PatBillDr,"O",Ord)) q:Ord=""  d
	..s Itm=0 f  s Itm=$o(^DHCPB(PatBillDr,"O",Ord,"D",Itm)) q:Itm=""  d
    ...s ItmDr=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",3)
	...s TotalAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",7)
	...s DiscAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",8)
	...s PayorShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",9)
	...s PatientShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",10)	
	...s ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	...q:$g(ItmOPSubCat)=""
	...s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	...s ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	...q:$g(ItmOPCat)=""
	...s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	...s ^TMP("MZJF","UserHZCate",$j,FUsr,OPCatDesc)=+$g(^TMP("MZJF","UserHZCate",$j,FUsr,OPCatDesc))++TotalAmount
	...i (amt>0)  d
	....s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"N")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"N")))
	...i ((amt<0)&&(flag="A"))  d
	....s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"A")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"A")))
	...i ((amt<0)&&(flag="S"))  d
	....s ^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"S")=+TotalAmount++($g(^TMP("MZJF","HZCate",CurUserId,OPCatDesc,"S")))
    
    .s PaySub=0
    .f  s PaySub=$o(^DHCINVPRT(PrtRowID,"P",PaySub)) q:PaySub=""  d
    ..s PayAmt=$p(^DHCINVPRT(PrtRowID,"P",PaySub),"^",3)
    ..s PayM=$p(^DHCINVPRT(PrtRowID,"P",PaySub),"^",1)
    ..s ^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"User",FootDr,PayM)=$g(^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"User",FootDr,PayM))+PayAmt
    ..s ^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"ALL",PayM)=+$g(^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"ALL",PayM))+PayAmt

    s DataStr=""
	s UsrN=$p(^SSU("SSUSR",FUsr),"^",2)
	s UserPayInfo=UsrN
	s Paym="0",Sum=0
	f  s Paym=$o(^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"User",FootDr,Paym))   q:Paym=""   d
	.s PayAmt=+$g(^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"User",FootDr,Paym))
	.s PayDesc=$p(^CT("CTPM",Paym),"^",2)
	.s Sum=Sum+PayAmt
	.s UserPayInfo=UserPayInfo_"^"_PayAmt
	s UserPayInfo=UserPayInfo_"^"_Sum
	s normalno=$g(^TMP("EPInvDailyHand/No",+prtuser,"Normal","no"))
	s Num=Num+1
	s ^TMP("UDHCJFOPHandin8",Job,Num)=UserPayInfo
	s zfno=$g(^TMP("EPInvDailyHand/No",+prtuser,"Abort","no"))
    s hcno=$g(^TMP("EPInvDailyHand/No",+prtuser,"Strik","no"))
    s normalno=$g(^TMP("EPInvDailyHand/No",+prtuser,"Normal","no"))
    k ^TMP("EPInvDailyHand/No",+prtuser,"Abort","no")
    k ^TMP("EPInvDailyHand/No",+prtuser,"Strik","no")
    k ^TMP("EPInvDailyHand/No",+prtuser,"Normal","no")
	q normalnum_"^"_normalno_"^"_normalsum_"^"_zfnum_"^"_zfno_"^"_zfsum_"^"_hcnum_"^"_hcno_"^"_hcsum_"^"_allsum
}

ClassMethod GetPayModeData(Tjob, ind)
{
    ;w ##class(web.UDHCJFOPHandin8).GetPayModeData("65","1")
	s str=^TMP("UDHCJFOPHandin8",Tjob,ind)
 	q str
}

ClassMethod GetDataNum(Tjob)
{
	;w ##class(web.UDHCJFOPHandin8).GetDataNum("65")
	s gnum=$o(^TMP("UDHCJFOPHandin8",Tjob,""),-1)
 	q gnum
}

ClassMethod GetPayModeDetail()
{
	s RowId="",DescStr=""
	f  s RowId=$o(^CT("CTPM",RowId)) q:RowId=""  d
	.s Desc=$p(^CT("CTPM",RowId),"^",2)
	.s DescStr=DescStr_"^"_Desc
	s DescStr=DescStr_"^"_"合计"
	q DescStr
}

ClassMethod FindInvDailyhzExecute(ByRef qHandle As %Binary, StDate, EndDate, Type) As %Status
{
  
	Set repid=$I(^CacheTemp)
    i (StDate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    s job=$j
   
    Set repid=$I(^CacheTemp)
	Set index=1
	s myTMPJID=$I(^TMPOPPrintOut)
	s CurUserId=$G(%session.Data("LOGON.USERID"))
	s Num=0
    s Job=$j
	k ^TMP("UDHCJFOPHandin8")
	s Invnum=1,CTNum=1
	//s HandInChecknew=HandInCheck
	d ..GetHanInInfo(StDate,EndDate,CurUserId,Type)
	s UserPayInfo="合计"
	s Paym="0",Sum=""
	f  s Paym=$o(^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"ALL",Paym))   q:Paym=""   d
    .s PayAmt=+$g(^TMP("DHCOPBill","BuildPayMFeeByDate",Job,"ALL",Paym))
	.s Sum=Sum+PayAmt
    .s UserPayInfo=UserPayInfo_"^"_PayAmt
    s Num=Num+1
    s ^TMP("UDHCJFOPHandin8",Job,Num)=UserPayInfo_"^"_Sum
  	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindInvDailyhzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvDailyhzExecute ]
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

ClassMethod FindInvDailyhzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvDailyhzExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 显示预交金明细打印日期，打印时间,病人姓名，登记号，金额，支付方式，rowid,job

Query FindInvDailyhz(StDate, EndDate, Type) As %Query(ROWSPEC = "RepId:%String,TUserCode:%String,TUserName:%String,THaninDT:%String,BegFootDT:%String,EndFootDT:%String,TInvNum:%String,TPatShare:%String,TAcountSum:%String,TGetSum:%String,TGiveSum:%String,TDrugSum:%String,TMedSum:%String,TCashSum:%String,TCashNum:%String,TParkCashSum:%String,TParkCashNum:%String,TCheckSum:%String,TCheckNum:%String,TParkCheckSum:%String,TParkCheckNum:%String,TCatSum1:%String,TCatSum2:%String,TCatSum3:%String,TCatSum4:%String,TCatSum5:%String,TCatSum6:%String,TCatSum7:%String,TCatSum8:%String,TCatSum9:%String,TCatSum10:%String,TCatSum11:%String,TCatSum12:%String,TCatSum13:%String,TCatSum14:%String,TCatSum15:%String,TCatSum16:%String,TCatSum17:%String,TCatSum18:%String,TCatSum19:%String,TCatSum20:%String,TCatSum21:%String,TCatSum22:%String,TCatSum23:%String,TCatSum24:%String,TCatSum25:%String,TTMPJID:%String,TFootFlag:%String,Tnormalnum:%String,Tnormalno:%String,Tnormalsum:%String,Tzfnum:%String,Tzfno:%String,Tzfsum:%String,Thcnum:%String,Thcno:%String,Thcsum:%String,Tallsum:%String,Tjob:%String")
{
}

ClassMethod GetUserCateNum(Tjob)
{
	s gnum=$o(^TMP("MZJF","USEROUTCATE",Tjob,""),-1)
 	q gnum
}

ClassMethod GetUserCateData(Job, ind)
{
	s str=^TMP("MZJF","USEROUTCATE",Job,ind)
 	q str
}

}
