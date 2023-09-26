Import SQLUser

Class web.UDHCJFOPHandin Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod Handin(sUser As %String, FootInfo As %String)
{
    ;s ^TMPHandin=sUser_"%%%"_FootInfo
	
	s $ZT="ERROR^DHCSSERR"
	
	s StDate=$zdh($p(FootInfo,"^",1),4)
	s StTime=$zth($p(FootInfo,"^",2),1)
	
	s EndDate=$zdh($p(FootInfo,"^",3),4)
	s EndTime=$zth($p(FootInfo,"^",4),1)
	
	s hdate=+$h
	s htime=$p($h,",",2)
	
	;Q:$d(^TMPOPCat($j))=0 1
	;q:$d(^TMPCatSub($j))=0 1
	
	d ..KillTmp()
	
	;把发票重新生成，门诊大类项目
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)
	s myrtn0=$p(myrtn,"^",1)
	q:(myrtn0) myrtn0_"^"
	
	
	
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

ClassMethod BuildOPINVItem(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String) As %String
{
	n (hUser, stdate, sttime, EndDate, EndTime)
	s (INVNOinfo,RefundINVInfo,ParkINVInfo)=""
	s (snum,TotSum,PatPaySum,refundnum,RefTotSum,RefPatPaySum,cancelnum,AbTotSum,AbPatPaySum)=0
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
	...;q:(pdate=EndDate)&(PRTTime>EndTime)
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
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
	....s PatPaySum=PatPaySum+$g(PrtPatPay)
	....s TotSum=TotSum+$g(PRTAcount)
	...i (Flag="A")&&(PrtinvDr'="")  d
	....s AbPatPaySum=AbPatPaySum+$g(PrtPatPay)
	....s AbTotSum=AbTotSum+$g(PRTAcount)
	....s ParkPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;作废票据的原票据号码?
	....s ParkINVInfo=ParkINVInfo_" "_ParkPrtNO_", "
	....s cancelnum=cancelnum+1
	...i (Flag="S")&&(PrtinvDr'="")  d
	....s RefPatPaySum=RefPatPaySum+$g(PrtPatPay)
	....s RefTotSum=RefTotSum+$g(PRTAcount)
	....s RefundPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;红冲票据的原票据号码?
	....s RefundINVInfo=RefundINVInfo_" "_RefundPrtNO_", "
	....s refundnum=refundnum+1
	...s stat=..STATtoOPCAT(PRTrowid)
	...q:(rtn'=0)
	.i snum>0  d
	..s INVNOinfo=..GetINVNOinfo(snum)
	

	s rtn=rtn_"^"_INVNOinfo_"^"_snum_"^"_TotSum_"^"_PatPaySum_"^"_RefundINVInfo_"^"_refundnum_"^"_RefTotSum_"^"_RefPatPaySum_"^"_ParkINVInfo
	s rtn=rtn_"^"_cancelnum_"^"_AbTotSum_"^"_AbPatPaySum
	q rtn
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

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

}
