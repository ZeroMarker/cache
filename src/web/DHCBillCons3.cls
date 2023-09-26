Import SQLUser

Class web.DHCBillCons3 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 64;

ClassMethod DelINVPRTForYB(INVStr As %String, GroupDR As %String) As %String
{
	n (INVStr, GroupDR)
	;w ##class(web.DHCBillCons3).DelINVPRTForYB("460164",5)
	
	;在大同需要提供医保预结算功能 
	;需要Del表DHC_INVPRT
	;b		;
	;1.更新各个帐单下的医嘱明细
	;2.删除帐单
	;3.删除票据与帐单连接表
	;4.删除发票
	;5.删除发药接口
	s ^TMP("DelINVPRTForYB")=INVStr_"$$##"_GroupDR
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	
	;增加一个调用接口服务服务，退费
	s mymyPRTRowIDStr="0^"_INVStr
		s myServiceName="OPCRefund"
		s myConDef=##class(web.DHCEntity.CIDefine.ConditionDefine).%New()
		s myConDef.PRTRowIDStr=mymyPRTRowIDStr
		s myConDef.ServiceName="OPCRefund"
		s myConDef.SFlag=1
		s mySerInfo=##class(web.DHCBL.CI.Service).Service(myConDef)
		d myConDef.%Close()
	b	;;;
	s myPBRStr=""
	s myBCIStr=""
	s myOEStr=""
	s mylen=$l(INVStr,"^")
	f i=1:1:mylen  d
	.s myPRTRowID=$p(INVStr,"^",i)
	.q:(myPRTRowID="")
	.;验证发票状态
	.q:($d(^DHCINVPRT(myPRTRowID))=10)
	.s myHandDate=$p(^DHCINVPRT(myPRTRowID),"^", 11)
	.s:(myHandDate'="") myrtn=111			;结算过的发票不能删除
	.s myFlag=$p(^DHCINVPRT(myPRTRowID),"^", 8)
	.q:(myFlag'="N")
	.;Lid 2015-04-29 医保结算成功后HIS不能撤销
	.s ybchargeflag=##class(web.DHCBillCons11).CheckYBCharge(myPRTRowID)
	.s:(ybchargeflag=0) myrtn=112
	.s myOldPRTRowID=$p(^DHCINVPRT(myPRTRowID),"^", 29)
	.;q:(myOldPRTRowID'="")
	.;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid}) 
	.s myBCIRowID=0
	.f  s myBCIRowID=$o(^DHCBCI(0,"INV",myPRTRowID, myBCIRowID)) q:(myBCIRowID="")  d
	..s myPBRowID=$p(^DHCBCI(myBCIRowID),"^",2)
	..s myBCIStr=myBCIStr_myBCIRowID_"^"
	..q:(myPBRowID="")
	..s myPBRStr=myPBRStr_myPBRowID_"^"
	..
	
	q:(myPBRStr="")&(myBCIStr="")
	
	q:(+myrtn) myrtn
	b		;Begin  TB
	d ..tb()
	
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA
	
	s err=$$UpdateORDForYB^DHCOrdItem(myPBRStr)
	
	ZN CurrentNS
	s myrtn=+err
	
	;删除帐单
	if (+myrtn=0) d
	.s mylen=$l(myPBRStr,"^")
	.f i=1:1:mylen  q:(+myrtn'=0)  d
	..s myPBRowID=$p(myPBRStr,"^",i)
	..q:(myPBRowID="")
	..s myrtn=##class(web.UDHCJFPB).DELETE(myPBRowID)
	
	;删除连接表
	if (+myrtn=0) d
	.s mylen=$l(myBCIStr,"^")
	.f i=1:1:mylen  q:(+myrtn'=0)  d
	..s myBCIRowID=$p(myBCIStr,"^",i)
	..q:(myBCIRowID="")
	..s myrtn=##class(web.UDHCBillConINV).DELETE(myBCIRowID)
	
	;删除发票表
	if (+myrtn=0) d
	.s mylen=$l(INVStr,"^")
	.f i=mylen:-1:1 q:(+myrtn'=0)  d
	..s myPRTRowID=$p(INVStr,"^",i)
	..q:(myPRTRowID="")
	..s myPRTINV=$p(^DHCINVPRT(myPRTRowID),"^", 14)
	..s myUserDR=$p(^DHCINVPRT(myPRTRowID),"^", 21)
	..s myrtn=##class(web.DHCOPInvoice).DELETE(myPRTRowID)
	..;修复当前的发票号码
	..q:(myPRTINV="")
	..s myINVRowID=0
	..b		;;;;;
	..f  s myINVRowID=$o(^DHCINVOICE(0, "USER",myUserDR, myINVRowID))  q:(myINVRowID="")  D
	...s myBegINV=$p(^DHCINVOICE(myINVRowID),"^",1)
	...s myEndINV=$p(^DHCINVOICE(myINVRowID),"^",2)
	...s myLastINV=$p(^DHCINVOICE(myINVRowID),"^",6)
	...s myINVType=$p(^DHCINVOICE(myINVRowID),"^",8)		;"O"
	...s myPreABC=$p(^DHCINVOICE(myINVRowID),"^",16)		;
	...b		;;;;UpateReNo
	...s myNumPRTINV=$e(myPRTINV,$l(myPreABC)+1,$l(myPRTINV))
	...q:(myINVType'="O")		;不是门诊发票
	...q:'((+myBegINV<=+myNumPRTINV)&(+myNumPRTINV<=+myEndINV))
	...i '(+myLastINV=(+myNumPRTINV+1)) d
	....;如果不是最后一张发票抱错，不能办理删除
	....s myrtn=110
	...q:(+myrtn)
	...b		;;;UpdateReceiptNO
	...s myrtn=##class(web.udhcOPBill).UpdateReceipNO(myUserDR, myNumPRTINV, GroupDR)
	...
	
	if (+myrtn=0) d
	.s mylen=$l(INVStr,"^")
	.f i=mylen:-1:1 q:(+myrtn'=0)  d
	..s myPRTRowID=$p(INVStr,"^",i)
	..q:(myPRTRowID="")
	..&sql(delete from DHC_PHARWIN where PHA_PRT_DR=:myPRTRowID)
	
		;Tro
	i 
	i +myrtn=0 d
	.d ..tc()
	e  d
	.trollback
	.s ^TMP("DelINVPRTForYB","Err")=INVStr_"$$##"_GroupDR
	
	q myrtn
}

/// 山西大同版本
/// 更新发票表为医保
ClassMethod UpdateINVPRTYBInfo(YBInfo As %String) As %String
{
   
	n (YBInfo,  ExpStr)
	;门诊收费通用上传医保接口
	;rtn^DHC_InsuDivideRowID^PatShareSum^DHCINVRowID_$c(2)_PayMode_DR^12.01_$c(2)_PayMode_DR^20_$c(3)_发票2
	;33.38 
	;0^10^13.38^607_$c(2)_6^10.00_$c(2)_4^10
	;w ##class(web.DHCBillCons3).UpdateINVPRTYBInfo("0^10^13.38^607"_$c(2)_"6^10.00"_$c(2)_"4^10")
	s $ZT="ERROR^DHCSSERR"
	;s ^TMP("UpdateINVPRTYBInfo")=YBInfo
	;q 0
	s myrtn=""
	s myYBErrlog=""
	s myYBPaySum=0
	
	;s myrtn=+$p(YBInfo,"^")
	;q:myrtn myrtn
	
	s YBInvInfo=$p(YBInfo,"|",1)
	s PreDepInfo=$p(YBInfo,"|",2)
	

	s InvStr=""
	s myInvlen=$l(YBInvInfo,$c(3))
	f i=1:1:myInvlen   d
	.s myYBInv=$p(YBInvInfo,$c(3),i)
	.q:myYBInv=""
	.s myINVInfo=$p(myYBInv,$c(2),1)
	.s myrtn=+$p(myINVInfo,"^",1)
	.q:myrtn
	.;每张发票都分别提交
	.s myPRTRowID=$p(myINVInfo,"^",4)
	.i InvStr="" s InvStr=myPRTRowID
	.e  s InvStr=InvStr_"^"_myPRTRowID
	.;验证医保总额分解是否正确
	.s myPatShare=+$p(^DHCINVPRT(myPRTRowID),"^",16)
	.s myPatSum=$p(myINVInfo, "^",3)
	.s myCurYBPaySum=myPatShare-$g(myPatSum)
	.s myPlen=$l(myYBInv,$c(2))
	.f j=2:1:myPlen d
	..s myPMInfo=$p(myYBInv,$c(2),j)
	..q:myPMInfo=""
	..s myPMSum=$p(myPMInfo,"^",2)
	..s myPatSum=+myPatSum+myPMSum
	.s myPatShare=$fn(myPatShare,"",2)
	.s myPatSum=$fn(myPatSum,"",2)
	.;b		;;;;Panduan
	.i (myPatSum'=myPatShare) d
	..s myrtn=2606					;;;医保分解金额错误
	..s ^TMPOPCHYB(+$h,$p($h,",",2),myPRTRowID)=myrtn_"^"_myYBInv
	..s myYBErrlog=$g(myYBErrlog)_$c(3)_myrtn_"^"_myPRTRowID
	.q:(myPatSum'=myPatShare)
	.;b		;PatSum=PatShare
	.d ..tb()
	.;单独发票提交事务
	.s myrtn=..UpdateSingleINVYBInfo(myYBInv)
	.s myAccPLDR=$p(myrtn,"^",2)
	.s PUsr=$p($g(^DHCINVPRT(myPRTRowID)),"^",21)
	.s myrtn=$p(myrtn,"^",1)
	.b		;Tro
	.i +myrtn=0 d
	..d ..tc()
	..s myYBPaySum=$g(myYBPaySum)+myCurYBPaySum
	.e  d
	..trollback
	..;写入日志
	..s ^TMPOPCHYB(+$h,$p($h,",",2),myPRTRowID)=myYBInv
	..s myYBErrlog=$g(myYBErrlog)_$c(3)_myrtn_"^"_myPRTRowID
	
	
	i (+myrtn=0)&&(PreDepInfo'="")  d
	.s DepSum=0
	.s DepLen=$l(PreDepInfo,$c(2))
	.f i=1:1:DepLen   d
	..s DepInfo=$p(PreDepInfo,$c(2),i)
	..s DepSum=DepSum+$p(DepInfo,"^",2)
	.q:DepSum=0
	.s PrtDr=$p($p(YBInfo,$c(2),1),"^",4)
	.s PUsr=$p(^DHCINVPRT(PrtDr),"^",21)
	.s papmi=$p(^DHCINVPRT(PrtDr),"^",15)
	.s patno=$p(^PAPER(papmi,"PAT",1),"^",2)
	.s Expstr="N^"_PUsr_"^^"_patno
	.;b
	.s myrtn=##class(web.DHCOPBillManyPaymentLogic).UpdateInvPayM(InvStr,PreDepInfo,Expstr)

	
	
	i myYBErrlog'="" d
	.s myrtn=2607			;医保分解错误
	//.i $g(DepRowid)'=""   d
	//..s DLen=$p(DepRowid,"^")
	//..s PayDepAmt=0
	//..f i=1:1:DLen   q:+ren'=0   d
	//...s DepDr=$p(DepRowid,"^",i)
	//...q:+DepDr=0
	//...s PrePay=$p($g(^DHCACD("AccM",+DepDr,"AccPD",$p(DepDr,"||",2))),"^",2)
	//...s PayDepAmt=PayDepAmt+PrePay
	//...s ren=##Class(web.UDHCAccPreDeposit).DELETE(DepDr)
	//..q:(+ren'=0)||(PayDepAmt=0)
	//..s rtn=##Class(web.UDHCAccAddDeposit).UpdateAM(+DepDr,(0-PayDepAmt))
	
	q myrtn_$c(4)_myYBErrlog_$c(4)_myYBPaySum
}

ClassMethod UpdateSingleINVYBInfo(YBInv As %String) As %String
{
	n (YBInv)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	//s YBInfo=$p(YBInv,"|",1)
	s myINVInfo=$p(YBInv,$c(2),1)
	s myInsRowID=$p(myINVInfo,"^",2)
	s myPRTRowID=$p(myINVInfo,"^",4)
	s myPatSum=$p(myINVInfo,"^",3)
	
	s myFairType=$p($g(^DHCINVPRT(myPRTRowID)),"^",34)  ;prt_fairtype (F:发票，R:挂号)
	q:(myFairType="F")&&(+myInsRowID=0) 2608    ;;2015-12-24 Lid 挂号时可能传空，所以只过滤收费记录
	
	;更新DHC
	k PLIST
	s myrtn=##class(web.DHCOPInvoice).SELECT(myPRTRowID)
	
	s PLIST(31)=myInsRowID			;PRT_InsDiv_DR
	s PLIST(32)=+PLIST(21)-myPatSum
	i +myrtn=0 d
	.s myrtn=##class(web.DHCOPInvoice).UPDATE(myPRTRowID)
	
	b ;更新PayMode
	i +myrtn=0 d
	.k PLIST
	.s myIPMRowID=myPRTRowID_"||1"
	.s myrtn=##class(web.UDHCINVPayMode).SELECT(myIPMRowID)
	.s myDate=PLIST(8)
	.s myTime=PLIST(9)
	.s myPayAmt=PLIST(5)
	.s PLIST(5)=myPatSum
	.s myAccPLDR=PLIST(10)
	.i +myrtn=0 d
	..s myrtn=##class(web.UDHCINVPayMode).UPDATE(myIPMRowID)
	
	b ;如果是账户支付，应该把钱返回到账户中，
	;其他支付方式：需要提示，应该找给患者的钱数
	;如果是账户支付，应该把钱返回到账户中，
	;其他支付方式：需要提示，应该找给患者的钱数
		
	s:myAccPLDR'="" AccBal=$p(^DHCACD("AccM",+myAccPLDR),"^",8)
	
	//////////////////////////////////////////////////////
	
	
	;;;;add by zhl  090724  xiangya   S
	i (+myrtn=0)&&(myAccPLDR'="") d
	.lock ^DHCACD("AccM",+myAccPLDR)
	.s myrtn=##class(web.UDHCAccPayList).SELECT(myAccPLDR) 
	.s InitSum=PLIST(10)
	.s PLIST(10)=myPatSum
	.s ReturnMoney=InitSum-myPatSum
	.s LastLeft=PLIST(11)
	.i LastLeft=""   s PLIST(11)=AccBal-myPatSum
	.e   s PLIST(11)=PLIST(11)+ReturnMoney
	.i +myrtn=0 d
	..s myrtn=##class(web.UDHCAccPayList).UPDATE(myAccPLDR)
	..i +myrtn'=0  lock -^DHCACD("AccM",+myAccPLDR)
	.q:+myrtn'=0
	.i LastLeft=""   d
	..s myrtn=##class(web.DHCACPayList).UpdateAM(+myAccPLDR,(0-myPatSum))
	..s myrtn=$p(myrtn,"^",1)
	.e      d
	..s myrtn=##class(web.DHCACPayList).UpdateAM(+myAccPLDR,ReturnMoney)
	..s myrtn=$p(myrtn,"^",1)
	.lock -^DHCACD("AccM",+myAccPLDR)
    
    
    
    b ;;;;;;;;E  zhl
	.;表示利用门诊预交金卡支付
	.;更新原卡支付PayList
	.;下一步再做
	.
	;增加医保支付模式
	s myPlen=$l(YBInv,$c(2))
	
	f myIdx=2:1:myPlen  q:(+myrtn'=0)  d
	.s myPMInfo=$p(YBInv,$c(2),myIdx)
	.q:myPMInfo=""
	.k PLIST
	.s myPMDR=$p(myPMInfo,"^",1)
	.s myPMSum=$p(myPMInfo,"^",2)
	.s PLIST(0)=myPRTRowID
	.s PLIST(3)=myPMDR
	.s PLIST(5)=myPMSum
	.s PLIST(8)=myDate
	.s PLIST(9)=myTime
	.s myrtn=##class(web.UDHCINVPayMode).INSERT()

	q myrtn_"^"_$g(myAccPLDR)
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

ClassMethod ReadInsuListBroker(JSFunName As %String, ListName As %String, Exp As %String = "") As %String
{
	n (JSFunName,ListName,Exp)
	
	
	s Reades="",myval="",mySelFlag=1
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(Reades),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
    s myIdx=1,mySelFlag=0
	s ReasDr=""
	f  s ReasDr=$o(^PAC("ADMREA",ReasDr))   q:ReasDr=""   d
	.s InsuFlag=$p($g(^PAC("ADMREA",ReasDr)),"^",9)
	.;q:+InsuFlag=0
	.s Reades=$p($g(^PAC("ADMREA",ReasDr)),"^",2)
	.s myval=ReasDr_"^"_Reades_"^"_InsuFlag
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(Reades),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1

	q 0
}

}
