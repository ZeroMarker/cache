Import SQLUser

Class web.UDHCJFOPHandinReg11 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 25;

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod GetDate(hUser As %String, EndDate As %String)
{
	;;w ##class(web.UDHCJFOPHandinReg11).GetDate("8",+$h)
	s stdate="",sttime=""
	s myAPRowID=""
	s myPrtDate=""
	s myPrtTime=""
		
	q:hUser="" "^^^"
	
	s hisid="",rowid=""
	f  s hisid=$o(^DHCOPInsFootI(0,"User",hUser,hisid),-1) q:(hisid="")!(rowid'="")  d
	.s prttype=$p($g(^DHCOPInsFoot(hisid)),"^",60)
	.q:prttype'="R"
	.s rowid=hisid
	
	i rowid'="" d
	.s stdate=$p($g(^DHCOPInsFoot(rowid)),"^",3)
	.s sttime=$p($g(^DHCOPInsFoot(rowid)),"^",4)
	.
	e  d
	.s id=""
	.f  s id=$o(^DHCINVPRT(0,"User",hUser,id)) q:(id="")!(rowid'="")  d
	..s prttype=$p($g(^DHCINVPRT(id)),"^",34)
	..q:prttype'="R"
	..s handin=$p($g(^DHCINVPRT(id)),"^",10)
	..q:handin'=""
	..s rowid=id
	.
	.i rowid'="" d
	..
	..s stdate=$p($g(^DHCINVPRT(rowid)),"^",5)
	..s sttime=$p($g(^DHCINVPRT(rowid)),"^",20)
	.
	
	i stdate="" d  s stdate=+$h-8
	i sttime="" d  s sttime=$p($h,",",2)
	
		
	;增加返回结束日期
	s myEndDate=+$h
	s myEndTime=+$p($h,",",2)
	
	q stdate_"^"_sttime_"^"_myEndDate_"^"_myEndTime
}

ClassMethod GetHandin(itmjs As %Library.String = "", itmjsex As %Library.String = "", hUser As %String) As %String
{
	n (itmjs, itmjsex, hUser)
	;w ##Class(web.UDHCJFOPHandinReg11).GetHandin("","",639)
	
	d ..KillTmp()
	
	s EndDate=+$h		;
	s EndTime=$p($h,",",2)			;
	s sttimeinfo=..GetDate(hUser,EndDate)
	s stdate=$p(sttimeinfo,"^",1)
	s sttime=$p(sttimeinfo,"^",2)
	s EndDate=$p(sttimeinfo,"^",3)
	s EndTime=$p(sttimeinfo,"^",4)
	;
	
	
	s myIPRepInfo=..GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	s myrtn=1
	i myIPRepInfo'="" s myrtn=0
	
	s mystr=myIPRepInfo
	
	s retval=itmjs_"('"_$ZCVT(mystr,"O","JS")_"');"
	&javascript<#(retval)#>
	
	d ..KillTmp()
		
	q myrtn
}

ClassMethod Handin(sUser As %String, FootInfo As %String)
{
	
	;w ##class(web.UDHCJFOPHandinReg11).Handin("2",FootInfo)
	s ^tempscl("Handin")=sUser_","_FootInfo
	n (sUser, FootInfo,%session)
	;s $ZT="ERROR^SSERR"
	s HospId=2 //%session.Data("LOGON.HOSPID")
	s StDate=##class(websys.Conversions).DateHtmlToLogical($p(FootInfo,"^",1)) //$zdh($p(FootInfo,"^",1),4)
	s StTime=$zth($p(FootInfo,"^",2),1)
	
	s EndDate=##class(websys.Conversions).DateHtmlToLogical($p(FootInfo,"^",3)) //$zdh($p(FootInfo,"^",3),4)
	s EndTime=$zth($p(FootInfo,"^",4),1)
	
	s hdate=+$h
	s htime=$p($h,",",2)
	
	d ..KillTmp()
	
	d ..tb()
	
	k PLIST
	;
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=StDate		;HIS_StartDate
	s PLIST(5)=StTime		; HIS_StartTime
	s PLIST(6)=EndDate		;HIS_EndDate
	s PLIST(7)=EndTime   	;HIS_EndTime
	s PLIST(8)=+$p(FootInfo,"^",5)      ;结算总金额  HIS_Amount
	s PLIST(9)=sUser
	s PLIST(19)=+$p(FootInfo,"^",6)     ;现金金额  HIS_CashSum
	s PLIST(29)=+$p(FootInfo,"^",7)     ;其它金额  HIS_OterPaySum
	s PLIST(17)=+$p(FootInfo,"^",8)     ;收款金额  HIS_PatSum
	s PLIST(23)=+$p(FootInfo,"^",9)     ;退款金额  HIS_RefundSum
	s PLIST(10)=+$p(FootInfo,"^",10)    ;收据张数  His_Num
	s PLIST(22)=+$p(FootInfo,"^",11)    ;退款收据张数  HIS_RefundNum
	s PLIST(11)=$p(FootInfo,"^",12)     ;收据号段  HIS_RcptNO
	s PLIST(61)="R"
	//s PLIST(62)=+$p(FootInfo,"^",13)    ;初诊挂号数  HIS_Note4
	//s PLIST(63)=+$p(FootInfo,"^",14)    ;复诊挂号数  HIS_Note5
	//s PLIST(52)=+$p(FootInfo,"^",15)    ;开药挂号数  HIS_PRDGetNum
	s PLIST(52)=+$p(FootInfo,"^",16)    ;挂号总数    HIS_Note7
	s PLIST(54)=+$p(FootInfo,"^",17)    ;退号数      HIS_Note6
	s PLIST(66)=+$p(FootInfo,"^",18)    ;挂号总金额  HIS_Note8
	s PLIST(27)=$p(FootInfo,"^",21)    ;退款收据    HIS_RefundINVInfo
	s StDate=PLIST(4)
	s StTime=PLIST(5)
	s EndDate=PLIST(6)
	s EndTime=PLIST(7)
	
	b //34
	;结算主表
	
	s HISParref=""
	s myrtn=##class(web.UDHCINVPRTReports).Insert()
	b //45
	i myrtn=0 d
	.s HISParref=PLIST(1)
	.//s Len=$l(FootInfo,"^")
	.//s HospId=$p(FootInfo,"^",Len)
	.if ($p(^DHCOPInsFoot(HISParref),"^",66)="") s $p(^DHCOPInsFoot(HISParref),"^",66)=HospId
		;;;;;;
	;更新票据流水表
	i myrtn=0 d
	. 
	.s myrtn=..UpdateFootForUserNoCard(sUser, StDate, StTime, EndDate, EndTime, HISParref, hdate, htime)
	
	
	
	i myrtn=0 d
		.d ..tc()
	e  d
		.Trollback
	
	d ..KillTmp()
	
	quit myrtn_"^"_HISParref
}

ClassMethod UpdateFootForUserNoCard(UserDR As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, INVRepRef As %String, HDate As %String, HTime As %String) As %String
{
	;
	n (UserDR, StDate, StTime, EndDate, EndTime, INVRepRef, HDate, HTime)
	s $ZT="ERROR^SSERR"
	s myrtn=0
	
	s myDate=StDate-1
	f  s myDate=$o(^DHCINVPRT(0,"Date",myDate)) q:((myDate="")!(myrtn'=0)!(+myDate>+EndDate))  d
	.s myPrtRowID=0
	.f  s myPrtRowID=$o(^DHCINVPRT(0,"Date",myDate,myPrtRowID)) q:((myPrtRowID="")||(myrtn'=0))  d
	..s PrtFairType=$p(^DHCINVPRT(myPrtRowID),"^",34)
	..q:PrtFairType'="R"
	..s myTime=$p(^DHCINVPRT(myPrtRowID),"^",20)
	..s myPRTNo=$p(^DHCINVPRT(myPrtRowID),"^",14)		;PRT_inv
	..s myUser=$p(^DHCINVPRT(myPrtRowID),"^",21)
	..s myHandin=$p(^DHCINVPRT(myPrtRowID),"^",10)
	..q:(UserDR'=myUser)
	..q:((myDate=StDate)&&(myTime<StTime)&&(myHandin="Y"))
	..q:((myDate=EndDate)&&(myTime>=EndTime))
	..
	..s myrtn=##class(web.DHCOPInvoice).SELECT(myPrtRowID)
	..q:myrtn
	..s PLIST(7)="Y"
	..s PLIST(8)=HDate		; PRT_HandinDate
	..s PLIST(9)=HTime		;PRT_HandinTime
	..s PLIST(5)=INVRepRef
	..s myrtn=##class(web.DHCOPInvoice).UPDATE(myPrtRowID)
	..q:myrtn
	
	q myrtn
}

ClassMethod KillTmp()
{
	k ^TMPOPHand($j)
	k ^TMPOPHandsub($j)
	k ^TMPCatSub($j)
	k ^TMPCatSubOther($j)
	k ^TMPOPCat($j)
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	k ^TMPOPACCHand($j)
	k ^TMPOPPayMode($j)
	k ^TMPOPParkPayMode($j)
	k ^TMPOPINVTALLY($j)
	k ^TMPOPINVSTRIK($j)
	k ^TMPOPPayMode($j)
	k ^TMPOPRepInstype($j)
}

/// w ##class(web.UDHCJFOPHandinReg11).GetINVPRTRepInfo(64866,36220,64866,36238,7)
ClassMethod GetINVPRTRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String) As %String
{
	n (stdate,sttime,EndDate,EndTime, hUser)
	kill ^TMP("ZYJF","INVPRTRep",hUser,$j)
	kill ^TMP("ZYJF","INVPRTRepREFUND",hUser,$j)
	s rtn=""
	q:stdate="" rtn
	q:sttime="" rtn
	s num=0
	s rcptstr=""
	s (AmtSum,CashAmt,OtherAmt,Pamt,Ramt,ReceiptsNum,RefundNum,FirstAdmTot,FurtherAdmTot,DrugAdmTot,AdmTot,RefundAdmTot,AdmAmtSum)=0
	s ADMStr=""
	s ReAdmStr=""
	s RefundNoStr=""
	i (stdate'="")&&(sttime'="")  d
	.
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&&(PRTTime>=EndTime)
	...q:(pdate=stdate)&&(PRTTime<sttime)
	...b //13
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...//q:Handin="Y"   //地坛收费已经结算
	...s PRTFairType=$p(^DHCINVPRT(PRTrowid),"^",34)
	...q:PRTFairType'="R"
	...s num=num+1
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	...s PRTAcount=PrtPatPay
	...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...s BCIrowid=$o(^DHCBCI(0,"INV",PRTrowid,""))
	...s Adm=$p(^DHCBCI(BCIrowid),"^",3)
	...s AdmStatus=$P(^PAADM(Adm),"^",20)
	...s FirstOrReadmis=$p($g(^PAADM(Adm)),"^",72)
	...s OldINVDr=$p(^DHCINVPRT(PRTrowid),"^",29)
	...s AmtSum=AmtSum+PRTAcount ;结算总金额
	...s IPMsub=0
	...f  s IPMsub=$o(^DHCINVPRT(PRTrowid,"P",IPMsub)) q:IPMsub=""  d
	....s PayModeDr=$p(^DHCINVPRT(PRTrowid,"P",IPMsub),"^",1)
	....s Amt=+$p(^DHCINVPRT(PRTrowid,"P",IPMsub),"^",3)
	....s GrpCode="CASH" ;现金金额、其他金额
	....i PayModeDr'="" s GrpCode=$p($g(^CT("CTPM",PayModeDr)),"^",1)
	....i GrpCode="CASH" d
	.....s CashAmt=CashAmt+Amt
	....e  d
	.....s OtherAmt=OtherAmt+Amt
	...if (PRTAcount>0)  d
	....;收款金额-退款金额=结算金额 注：收款金额不加作废重打发票金额
	....s Pamt=Pamt+PRTAcount ;收款金额
	....i PrtNO'="" s ReceiptsNum=ReceiptsNum+1 ;收据张数
	....;查找有效的挂号
	....if (Flag="N") d
	.....if OldINVDr'=""  d
	......s BCIrowidOld=$o(^DHCBCI(0,"INV",OldINVDr,""))
	......s AdmValueGet=$p(^DHCBCI(BCIrowidOld),"^",3)
	......s AdmStatusReGet=$P(^PAADM(AdmValueGet),"^",20)
	.....e  d
	......s AdmStatusReGet=AdmStatus
	......s AdmValueGet=Adm
	.....i AdmStatusReGet'="C"  d
	......s FlagSamAdm=0
	......if (ADMStr'="")&&(("^"_ADMStr_"^")[("^"_AdmValueGet_"^")) s FlagSamAdm=1
	......if FlagSamAdm=0  d
	.......s AdmTot=AdmTot+1 ;挂号总数—部分退费的作废重大的不计算在内
	.......i FirstOrReadmis="F" s FirstAdmTot=FirstAdmTot+1
	.......i FirstOrReadmis="R" s FurtherAdmTot=FurtherAdmTot+1
    .......if ADMStr=""  s ADMStr=AdmValueGet
	.......else  s ADMStr=ADMStr_"^"_AdmValueGet
	...if (Flag'="N")  d
	....if (PRTAcount<0)  d
	.....;退款金额
	.....s Ramt=Ramt+PRTAcount
	.....s RefundPrtNo=$p(^DHCINVPRT(PrtinvDr),"^",14) //PrtNO 退票据找原来的
	.....i RefundPrtNo'="" s RefundNum=RefundNum+1 ;退款票据张数
	.....//i RefundNoStr="" s RefundNoStr=RefundPrtNo
	.....//e  s RefundNoStr=RefundNoStr_","_RefundPrtNo
	.....i RefundPrtNo'="" s ^TMP("ZYJF","INVPRTRepREFUND",hUser,$j,RefundPrtNo)=""
	.....;负票查看退号统计
	.....s BCIrowidRe=$o(^DHCBCI(0,"INV",PrtinvDr,""))
	.....s AdmRe=$p(^DHCBCI(BCIrowidRe),"^",3)
	.....s AdmStatusReGet=$P(^PAADM(AdmRe),"^",20)
	.....s ReAdmFlag=0
	.....if AdmStatusReGet="C"  d
	......if (ReAdmStr'="")&&(("^"_ReAdmStr_"^")[("^"_AdmRe_"^")) s ReAdmFlag=1
	......if ReAdmFlag=0  d
	.......s RefundAdmTot=RefundAdmTot+1
	.......if ReAdmStr="" s ReAdmStr=AdmRe
	.......else  s ReAdmStr=ReAdmStr_"^"_AdmRe
	...i PrtNO'="" d
	....//s rcptstr=..getrcptstr(rcptstr,PrtNO)          ;因为收费和挂号是同一个用户，取消号段
	....set ^TMP("ZYJF","INVPRTRep",hUser,$j,PrtNO)=""
	//开始日期，开始时间，结束日期，结束时间，
	//结算总金额，现金金额，其他金额，收款金额，退款金额
	//收款票据张数,退款票据张数，收款票段
	//初诊挂号数，复诊挂号数，开药挂号数，挂号总数，退号数，挂号总金额
	s rcptstr=##class(web.UDHCJFBaseCommon).GetINVNOinfo(hUser,"INVPRTRep",$j)
	s RefundNoStr=##class(web.UDHCJFBaseCommon).GetINVNOinfo(hUser,"INVPRTRepREFUND",$j)
	kill ^TMP("ZYJF","INVPRTRep",hUser,$j)
	kill ^TMP("ZYJF","INVPRTRepREFUND",hUser,$j)
	s AdmAmtSum=AmtSum
	s rtn=##class(websys.Conversions).DateLogicalToHtml(stdate)_"^"_$zt(sttime)_"^"_##class(websys.Conversions).DateLogicalToHtml(EndDate)_"^"_$zt(EndTime)
	s rtn=rtn_"^"_$j(AmtSum,3,2)_"^"_$j(CashAmt,3,2)_"^"_$j(OtherAmt,3,2)_"^"_$j(Pamt,3,2)_"^"_$j(Ramt,3,2)
	s rtn=rtn_"^"_ReceiptsNum_"^"_RefundNum_"^"_rcptstr
	s rtn=rtn_"^"_FirstAdmTot_"^"_FurtherAdmTot_"^"_DrugAdmTot_"^"_AdmTot_"^"_RefundAdmTot_"^"_$j(AdmAmtSum,3,2)
	s rtn=rtn_"^"_##class(websys.Conversions).DateLogicalToHtml(+$h)_"^"_$zt($p($H,",",2))_"^"_RefundNoStr
	q rtn
}

ClassMethod getrcptstr(rcptstr As %Library.String = "", receiptsno As %Library.String = "") As %String
{
   n (rcptstr,receiptsno)
   s p="-",m=","
   q:receiptsno="" rcptstr
   q:rcptstr="" receiptsno
   s mlen=$l(rcptstr,m)
   ;
   i mlen=1 d
   .s plen=$l(rcptstr,p)
   .i plen=1 d
   ..s endno=rcptstr,tmpstr1=rcptstr
   ..
   .e  d
   ..s endno=$p(rcptstr,p,plen),tmpstr1=$p(rcptstr,p,1,plen-1)
   e  d
   .s tmpendstr=$p(rcptstr,m,mlen)
   .s plen=$l(tmpendstr,p)
   .i plen=1 d
   ..s endno=tmpendstr,tmpstr1=rcptstr
   .e  d
   ..s endno=$p(tmpendstr,p,plen)
   ..s plen=$l(rcptstr,p)
   ..s tmpstr1=$p(rcptstr,p,1,plen-1)
   b //4
   i (+receiptsno)-(+endno)=1  s rcptstr=tmpstr1_p_receiptsno q rcptstr
   s rcptstr=rcptstr_","_receiptsno
   q rcptstr
}

ClassMethod GetRegHandinHis(RepID) As %String
{
	n (RepID)
	s rtn=""
	s RepID=$g(RepID)
	q:RepID="" rtn
	q:'$d(^DHCOPInsFoot(RepID)) rtn
	s tmpStr=$g(^DHCOPInsFoot(RepID))
	s stdate=$p(tmpStr,"^",5)
	s sttime=$p(tmpStr,"^",6)
	s EndDate=$p(tmpStr,"^",3)
	s EndTime=$p(tmpStr,"^",4)
	s AmtSum=$p(tmpStr,"^",1)
	s CashAmt=$p(tmpStr,"^",18)
	s OtherAmt=$p(tmpStr,"^",28)
	s Pamt=$p(tmpStr,"^",16)
	s Ramt=$p(tmpStr,"^",22)
	s ReceiptsNum=$p(tmpStr,"^",9)
	s RefundNum=$p(tmpStr,"^",21)
	s rcptstr=$p(tmpStr,"^",10)
	s FirstAdmTot=$p(tmpStr,"^",61)
	s FurtherAdmTot=$p(tmpStr,"^",62)
	s DrugAdmTot=$p(tmpStr,"^",51)
	s AdmTot=$p(tmpStr,"^",51) 
	s RefundAdmTot=$p(tmpStr,"^",53)   
	s AdmAmtSum=$p(tmpStr,"^",65)
	s HandinDate=$p(tmpStr,"^",2)
	s HandinTime=$p(tmpStr,"^",7)
	s RefundNoStr=$p(tmpStr,"^",26)
	s AdmAmtSum=AmtSum
	s rtn=##class(websys.Conversions).DateLogicalToHtml(stdate)_"^"_$zt(sttime)_"^"_##class(websys.Conversions).DateLogicalToHtml(EndDate)_"^"_$zt(EndTime)
	s rtn=rtn_"^"_$j(AmtSum,3,2)_"^"_$j(CashAmt,3,2)_"^"_$j(OtherAmt,3,2)_"^"_$j(Pamt,3,2)_"^"_$j(Ramt,3,2)
	s rtn=rtn_"^"_ReceiptsNum_"^"_RefundNum_"^"_rcptstr
	s rtn=rtn_"^"_FirstAdmTot_"^"_FurtherAdmTot_"^"_DrugAdmTot_"^"_AdmTot_"^"_RefundAdmTot_"^"_$j(AdmAmtSum,3,2)
	s rtn=rtn_"^"_##class(websys.Conversions).DateLogicalToHtml(HandinDate)_"^"_$zt(HandinTime)_"^"_RefundNoStr
	q rtn
}

Query QueryHandinRegList(StDate As %String, EndDate As %String) As %Query(ROWSPEC = "TID:%String,TUserCode:%String,TUserName:%String,TFirstAdmTot:%String,TFurtherAdmTot:%String,TDrugAdmTot:%String,TAdmTot:%String,TRefundAdmTot:%String,TAdmAmtSum:%String")
{
}

ClassMethod QueryHandinRegListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHandinRegListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryHandinRegListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHandinRegListExecute ]
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

ClassMethod QueryHandinRegListExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String) As %Status
{
	//
	
	Set repid=$I(^CacheTemp)
	Set index=1
	s (ID,UserCode,UserName,FirstAdmTot,FurtherAdmTot,DrugAdmTot,AdmTot,RefundAdmTot,AdmAmtSum)=""
	
	i $g(StDate)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i $g(EndDate)="" s EndDate=+$H
	i StDate'="" s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s fDate=StDate-1
	f  s fDate=$o(^DHCOPInsFootI(0,"Date",fDate)) q:(fDate="")!(fDate>EndDate)  d
	.s rowid=""
	.f  s rowid=$o(^DHCOPInsFootI(0,"Date",fDate,rowid)) q:rowid=""  d
	..s prttype=$p($g(^DHCOPInsFoot(rowid)),"^",60)
	..q:prttype'="R"
	..s ID=rowid
	..s UserID=$p($g(^DHCOPInsFoot(rowid)),"^",8)
	..s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	..s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	..s FirstAdmTot=$p($g(^DHCOPInsFoot(rowid)),"^",61)
	..s FurtherAdmTot=$p($g(^DHCOPInsFoot(rowid)),"^",62)
	..;s RefundAdmTot=$p($g(^DHCOPInsFoot(rowid)),"^",63)
	..;s AdmTot=$p($g(^DHCOPInsFoot(rowid)),"^",64)
	..s RefundAdmTot=$p($g(^DHCOPInsFoot(rowid)),"^",21) 
	..s AdmTot=$p($g(^DHCOPInsFoot(rowid)),"^",51)   
	..s AdmAmtSum=$j(+$p($g(^DHCOPInsFoot(rowid)),"^",1),3,2) //65
	..s DrugAdmTot=$p($g(^DHCOPInsFoot(rowid)),"^",51)
	..d OutPutDailyRepFoot
	.
	.
	
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutDailyRepFoot
	
	set Data=$lb(ID,UserCode,UserName,FirstAdmTot,FurtherAdmTot,DrugAdmTot,AdmTot,RefundAdmTot,AdmAmtSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

Query QueryHandinRegHis(StDate As %String, EndDate As %String, UserID As %String) As %Query(ROWSPEC = "TID:%String,THandInDate:%String,THandInTime:%String,TAmount:%String,TRegTotal:%String")
{
}

ClassMethod QueryHandinRegHisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHandinRegHisExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryHandinRegHisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHandinRegHisExecute ]
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

ClassMethod QueryHandinRegHisExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, UserID As %String) As %Status
{
	//
	
	Set repid=$I(^CacheTemp)
	Set index=1
	s (ID,HandInDate,HandInTime,Amount,RegTotal)=""
	
	i $g(StDate)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i $g(EndDate)="" s EndDate=+$H
	i StDate'="" s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s fDate=StDate-1
	f  s fDate=$o(^DHCOPInsFootI(0,"Date",fDate)) q:(fDate="")!(fDate>EndDate)  d
	.s rowid=""
	.f  s rowid=$o(^DHCOPInsFootI(0,"Date",fDate,rowid)) q:rowid=""  d
	..s prttype=$p($g(^DHCOPInsFoot(rowid)),"^",60)
	..q:prttype'="R"
	..s ID=rowid
	..s myUserID=$p($g(^DHCOPInsFoot(rowid)),"^",8)
	..q:UserID'=myUserID
	..s HandInDate=$p($g(^DHCOPInsFoot(rowid)),"^",2) //$zd($p($g(^DHCOPInsFoot(rowid)),"^",2),4)
	..s HandInDate=##class(websys.Conversions).DateLogicalToHtml(HandInDate)
	..s HandInTime=$zt($p($g(^DHCOPInsFoot(rowid)),"^",7))
	..;s RegTotal=$p($g(^DHCOPInsFoot(rowid)),"^",64)
	..s RegTotal=$p($g(^DHCOPInsFoot(rowid)),"^",51)
	..s Amount=$j(+$p($g(^DHCOPInsFoot(rowid)),"^",1),3,2) //65
	..
	..d OutPutDailyRepFootHis
	.
	.

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutDailyRepFootHis
	
	set Data=$lb(ID,HandInDate,HandInTime,Amount,RegTotal)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
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
