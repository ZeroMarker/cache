Import SQLUser

Class web.DHCOPBillInsuStrike Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 257;

ClassMethod DelINVPRTForYB(INVStr As %String) As %String
{
	n (INVStr)
	;w ##class(web.DHCBillCons3).DelINVPRTForYB("72")
	
	;在大同需要提供医保预结算功能
	;需要Del表DHC_INVPRT
	;b		;
	;1.更新各个帐单下的医嘱明细
	;2.删除帐单
	;3.删除票据与帐单连接表
	;4.删除发票
	;5.删除发药接口
	
	s $ZT="ERROR^SSERR"
		
	s myrtn=0
	
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
	...b		;;;;UpateReNo
	...q:(myINVType'="O")		;不是门诊发票
	...q:'((+myBegINV<=+myPRTINV)&(+myPRTINV<=+myEndINV))
	...i '(+myLastINV=(+myPRTINV+1)) d
	....;如果不是最后一张发票抱错，不能办理删除
	....s myrtn=110
	...q:(+myrtn)
	...b		;;;UpdateReceiptNO
	...s myrtn=##class(web.udhcOPBill).UpdateReceipNO(myUserDR, myPRTINV)
	...
	
	if (+myrtn=0) d
	.s mylen=$l(INVStr,"^")
	.f i=mylen:-1:1 q:(+myrtn'=0)  d
	..s myPRTRowID=$p(INVStr,"^",i)
	..q:(myPRTRowID="")
	..&sql(delete from DHC_PHARWIN where PHA_PRT_DR=:myPRTRowID)
	
	b	;Tro
	i +myrtn=0 d
	.d ..tc()
	e  d
	.trollback
	
	q myrtn
}

/// 山西大同版本
/// 更新发票表为医保
ClassMethod UpdateINVPRTYBInfo(YBInfo As %String, ExpStr) As %String
{
	n (YBInfo,  ExpStr)
	
	;门诊收费通用上传医保接口
	;rtn^DHC_InsuDivideRowID^PatShareSum^DHCINVRowID_$c(2)_PayMode_DR^12.01_$c(2)_PayMode_DR^20_$c(3)_发票2
	;33.38 
	;0^10^13.38^607_$c(2)_6^10.00_$c(2)_4^10
	;w ##class(web.DHCBillCons3).UpdateINVPRTYBInfo("0^10^13.38^607"_$c(2)_"6^10.00"_$c(2)_"4^10")
	
	s $ZT="ERROR^SSERR"
	
	s myrtn=""
	s myYBErrlog=""
	s myYBPaySum=0
	
	s ^YBInfoYYX=YBInfo
	;s myrtn=+$p(YBInfo,"^")
	;q:myrtn myrtn
	;s YBInfo=0_"^"_11537_"^"_-167_"^"_2866469_"^"_7_"^"_15_"^"_0
	s myInvlen=$l(YBInfo,$c(3))
	f i=1:1:myInvlen   d
	.s myYBInv=$p(YBInfo,$c(3),i)
	.q:myYBInv=""
	.s myINVInfo=$p(myYBInv,$c(2),1)
	.s myrtn=+$p(myINVInfo,"^",1)
	.B
	.q:myrtn   
	.;每张发票都分别提交
	.s myPRTRowID=$p(myINVInfo,"^",4)
	.;验证医保总额分解是否正确
	.s myPatShare=+$p(^DHCINVPRT(myPRTRowID),"^",16)
	.s myPatSum=$p(myINVInfo, "^",3)
	.s myCurYBPaySum=myPatShare-$g(myPatSum)
	.s myPlen=$l(myYBInv,$c(2))
	.b
	.f j=2:1:myPlen d
	..s myPMInfo=$p(myYBInv,$c(2),j)
	..q:myPMInfo=""
	..s myPMSum=$p(myPMInfo,"^",2)
	..s myPatSum=+myPatSum+myPMSum
	..b
	.s myPatShare=$fn(myPatShare,"",2)
	.s myPatSum=$fn(myPatSum,"",2)
	.b		;;;;Panduan
	.i (myPatSum'=myPatShare) d
	..s myrtn=2606					;;;医保分解金额错误
	..s ^TMPOPCHYB(+$h,$p($h,",",2),myPRTRowID)=myrtn_"^"_myYBInv
	..s myYBErrlog=$g(myYBErrlog)_$c(3)_myrtn_"^"_myPRTRowID
	.q:(myPatSum'=myPatShare)
	.b		;PatSum=PatShare
	.d ..tb()
	.;单独发票提交事务
	.s myrtn=..UpdateSingleINVYBInfo(myYBInv)
	.b		;Tro
	.i +myrtn=0 d
	..d ..tc()
	..s retval=0
	..s myYBPaySum=$g(myYBPaySum)+myCurYBPaySum
	..;w !,myrtn
	.e  d
	..trollback
	..;写入日志
	..s ^TMPOPCHYB(+$h,$p($h,",",2),myPRTRowID)=myYBInv
	..s myYBErrlog=$g(myYBErrlog)_$c(3)_myrtn_"^"_myPRTRowID
	;w !,myrtn
	i myYBErrlog'="" d
	.s myrtn=2607			;医保分解错误
	b
	q myrtn_$c(4)_myYBErrlog_$c(4)_myYBPaySum
}

ClassMethod UpdateSingleINVYBInfo(YBInv As %String) As %String
{
	n (YBInv)
	;s $ZT="ERROR^SSERR"
	
	s myrtn=0
	s myINVInfo=$p(YBInv,$c(2),1)
	s myInsRowID=$p(myINVInfo,"^",2)
	s myPRTRowID=$p(myINVInfo,"^",4)
	s myPatSum=$p(myINVInfo,"^",3)	
	;更新DHC
	k PLIST
	B ;yyc
	s myrtn=##class(web.DHCOPInvoice).SELECT(myPRTRowID)
	s PLIST(31)=myInsRowID			;PRT_InsDiv_DR
	s PLIST(32)=+PLIST(21)-myPatSum
	i +myrtn=0 d
	.s myrtn=##class(web.DHCOPInvoice).UPDATE(myPRTRowID)
	
	;更新PayMode
	i +myrtn=0 d
	.k PLIST
	.s myIPMRowID=myPRTRowID_"||1"
	.s myrtn=##class(web.UDHCINVPayMode).SELECT(myIPMRowID)
	.s myDate=PLIST(8)
	.s myTime=PLIST(9)
	.s myPayAmt=PLIST(5)
	.s PLIST(5)=myPatSum
	.;s myAccPLDR=PLIST(10)
	.i +myrtn=0 d
	..s myrtn=##class(web.UDHCINVPayMode).UPDATE(myIPMRowID)
	
	i myrtn=0 d
	.s IPMSub=1
	.f  s IPMSub=$o(^DHCINVPRT(myPRTRowID,"P",IPMSub)) q:(IPMSub="")!(myrtn'=0)  d
	..s myIPMRowID=myPRTRowID_"||"_IPMSub
	..s myrtn=##class(web.UDHCINVPayMode).DELETE(myIPMRowID)
	q:myrtn myrtn
	;如果是账户支付，应该把钱返回到账户中，
	;其他支付方式：需要提示，应该找给患者的钱数
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
	
	q myrtn
}

ClassMethod tb()
{
	TSTART  
	q
}

ClassMethod tc()
{
 	TCOMMIT 
 	q
}

ClassMethod test(YBInfo, ExpStr)
{
	s ^TTTT=YBInfo
	q YBInfo
}

ClassMethod UpAccINVPRTYBInfo(YBInfo As %String, ExpStr)
{
	
	n (YBInfo,  ExpStr)
	
	;门诊收费通用上传医保接口
	;rtn^DHC_InsuDivideRowID^PatShareSum^DHCINVRowID_$c(2)_PayMode_DR^12.01_$c(2)_PayMode_DR^20_$c(3)_发票2
	;33.38 
	;0^10^13.38^607_$c(2)_6^10.00_$c(2)_4^10
	;w ##class(web.DHCBillCons3).UpdateINVPRTYBInfo("0^10^13.38^607"_$c(2)_"6^10.00"_$c(2)_"4^10")
	s $ZT="ERROR^SSERR"

	s myrtn=""
	s myYBErrlog=""
	s myYBPaySum=0	
	s myInvlen=$l(YBInfo,$c(3))
	f i=1:1:myInvlen   d
	.s myYBInv=$p(YBInfo,$c(3),i)
	.q:myYBInv=""
	.s myINVInfo=$p(myYBInv,$c(2),1)
	.s myrtn=+$p(myINVInfo,"^",1)
	.q:myrtn   
	.;每张发票都分别提交
	.s myPRTRowID=$p(myINVInfo,"^",4)
	.b  ;验证医保总额分解是否正确
	.s myPatShare=+$p(^DHCINVPRTAP(myPRTRowID),"^",13)
	.s myPatSum=$p(myINVInfo, "^",3)
	.s myCurYBPaySum=myPatShare-$g(myPatSum)
	.s myPlen=$l(myYBInv,$c(2))
	.b
	.f j=2:1:myPlen d
	..s myPMInfo=$p(myYBInv,$c(2),j)
	..q:myPMInfo=""
	..s myPMSum=$p(myPMInfo,"^",2)
	..s myPatSum=+myPatSum+myPMSum
	.s myPatShare=$fn(myPatShare,"",2)
	.s myPatSum=$fn(myPatSum,"",2)
	.b		;;;;Panduan
	.i (myPatSum'=myPatShare) d
	..s myrtn=2606					;;;医保分解金额错误
	..s ^TMPOPCHYB(+$h,$p($h,",",2),myPRTRowID)=myrtn_"^"_myYBInv
	..s myYBErrlog=$g(myYBErrlog)_$c(3)_myrtn_"^"_myPRTRowID
	.q:(myPatSum'=myPatShare)
	.b		;PatSum=PatShare
	.d ..tb()
	.;单独发票提交事务
	.s myrtn=..UpAccSingleINVYBInfo(myYBInv)
	.b		;Tro
	.i myrtn=0  d
	..d ..tc()
	.e  d
	..trollback
	..;写入日志
	..s ^TMPOPCHYB(+$h,$p($h,",",2),myPRTRowID)=myYBInv
	..s myYBErrlog=$g(myYBErrlog)_$c(3)_myrtn_"^"_myPRTRowID
	i myYBErrlog'="" d
	.s myrtn=2607			;医保分解错误
	q myrtn_$c(4)_myYBErrlog_$c(4)_myYBPaySum
}

/// Creator :     陈曦
/// CreateDate:   2009-04-09
/// Function  :   根据医保返回的退费信息更新集中打印发票的支付方式表和卡帐户表
/// Input     :   医保返回退费信息---YBInv
/// OutPut    :  
ClassMethod UpAccSingleINVYBInfo(YBInv As %String) As %String
{
	n (YBInv)
	s $ZT="ERROR^SSERR"		
	s myrtn=0	
	s myINVInfo=$p(YBInv,$c(2),1)
	s myInsRowID=$p(myINVInfo,"^",2)
	s myPRTRowID=$p(myINVInfo,"^",4)
	s myPatSum=$p(myINVInfo,"^",3)	
	
	s myINVPayModeInfo=$p(YBInv,$c(2),2)
	s myINVPayModeInfo=$p(myINVPayModeInfo,$c(2),1)
	s myInsuSum=$p(myINVPayModeInfo,"^",2)
	
	;更新DHC
	k PLIST
	s myrtn=##class(web.UDHCAccPayINV).SELECT(myPRTRowID)
	s PLIST(20)=myInsRowID			;PRT_InsDiv_DR
	s PLIST(18)=myInsuSum
	i +myrtn=0 d
	.s myrtn=##class(web.UDHCAccPayINV).UPDATE(myPRTRowID)
	
	;更新PayMode

	i +myrtn=0 d
	.k PLIST
	.s myIPMRowID=myPRTRowID_"||1"
	.s myrtn=##class(web.UDHCAccPayINVMode).SELECT(myIPMRowID)
	.s myDate=PLIST(8)
	.s myTime=PLIST(9)
	.s myPayAmt=PLIST(5)
	.s PLIST(5)=myPatSum
	.;s myAccPLDR=PLIST(10)
	.i +myrtn=0 d
	..s myrtn=##class(web.UDHCAccPayINVMode).UPDATE(myIPMRowID)
	i myrtn=0 d
	.s IPMSub=1
	.f  s IPMSub=$o(^DHCINVPRTAP(myPRTRowID,"P",IPMSub)) q:(IPMSub="")!(myrtn'=0)  d
	..s myIPMRowID=myPRTRowID_"||"_IPMSub
	..s myrtn=##class(web.UDHCAccPayINVMode).DELETE(myIPMRowID)
	q:myrtn myrtn
	
	s myPlen=$l(YBInv,$c(2))
	
	f myIdx=2:1:myPlen  q:(+myrtn'=0)  d
	.s myPMInfo=$p(YBInv,$c(2),myIdx)
	.q:myPMInfo=""
	.k PLIST
	.s myPMDR=$p(myPMInfo,"^",1)
	.s myPMSum=$p(myPMInfo,"^",2)
	.s PLIST(0)=myPRTRowID
	.s PLIST(3)=myPMDR
	.s PLIST(5)=+$g(myPMSum)
	.s PLIST(8)=myDate
	.s PLIST(9)=myTime
	.s myrtn=##class(web.UDHCAccPayINVMode).INSERT()
	q myrtn
}

/// yyx 2009-06-11
/// 取负票的医保金额
ClassMethod GetReundInsuAmt(OldAPIRowID)
{
	s StrikInvRowID=$o(^DHCINVPRTAPi(0,"APIDR",OldAPIRowID,""))
	i $g(StrikInvRowID)'="" s StrikInsuSum=$p(^DHCINVPRTAP(StrikInvRowID),"^",17)
	s NewInvRowID=$o(^DHCINVPRTAPi(0,"OldADR",OldAPIRowID,""))
	i $g(NewInvRowID)'="" s NewInsuSum=$p(^DHCINVPRTAP(NewInvRowID),"^",17)
	s myYBPaySum=+$g(NewInsuSum)++$g(StrikInsuSum)
	q myYBPaySum
}

/// Creator :yyx
/// CreateDate:2009-04-03
/// Function  :根据发票的rowid，取红冲记录的发票rowid
/// Input     :发票号,InvNo
/// OutPut    :红冲发票rowid
ClassMethod GetStrikIDByInvNo(InvNo)
{
	s PrtRowID=$o(^DHCINVPRT(0,"INV",InvNo,""))
	i PrtRowID'="" d
	.s StrikeID=$o(^DHCINVPRT(0,"InitInvDR",PrtRowID,""))
	q $g(StrikeID)
}

/// Creator :     陈曦
/// CreateDate:   2009-04-09
/// Function  :   根据发票号，取红冲记录的发票rowid
/// Input     :   发票号,InvNo
/// OutPut    :   红冲发票rowid
ClassMethod GetStrikIDByAccInvNo(InvNo)
{
	s PrtRowID=$o(^DHCINVPRTAPi(0,"INVNo",InvNo,""),-1)
	b
	i PrtRowID'="" d
	.s StrikeID=$o(^DHCINVPRTAPi(0,"APIDR",PrtRowID,""))
	q $g(StrikeID)
}

/// Creator:yyx
/// CreateDate:2009-11-12
/// Function:  判断病人到门诊收费是否拆分发票
///           -1  非医保卡挂号
///           -2  特殊科室
///           -3  特殊诊断不调用医保接口
/// Modified by xp,2009,特殊诊断的判断改为调用医生站设置的函数
ClassMethod GetInsuDivideFlag(Adm)
{
	;w ##class(web.DHCOPBillInsuStrike).GetInsuDivideFlag("914365^")
	n RetVal
	q:$g(Adm)="" 0
	s Adm=$p(Adm,"^",1)
	s RetVal=$g(RetVal)
	S RegRowID=$O(^User.DHCRegistrationFeeI("ADM"," "_Adm,""))
    /*
    i RegRowID'="" d
    .s InsuAdm=$List(^User.DHCRegistrationFeeD(RegRowID),25)
    i $g(InsuAdm)="" s RetVal=-1 //没有进行医保登记
    q:RetVal=-1 RetVal
    */
    s AdmDepId=$p(^PAADM(Adm),"^",4)
    s DepStr=$g(^DHCDocConfig("Insure","ProcreationDep"))
    i DepStr[AdmDepId s RetVal=-2 //特殊科室
    i Adm'="" S ^TMPINSUSTRIKE(Adm)=$g(RetVal)_"^"_$g(DepStr)_"^"_$g(AdmDepId)
    q:RetVal=-2 RetVal
    ;q:RetVal=-1 RetVal    sxw modify 20100601 RetVal=-2 返回不了
    /*
    s DiagnoseStr=$g(^DHCDocConfig("Insure","ProcreationDiag"))
    s DiagnoseInfo=##class(web.UDHCJFBaseCommon).GetPatDiagnos(Adm,"PRE")
    f i=1:1:$l(DiagnoseInfo,"||") d  q:RetVal=-3
    .s OneDiagnose=$p(DiagnoseInfo,"||",i)
    .s DiagnoseCode=$p(OneDiagnose,"^",2)
    .i DiagnoseStr[DiagnoseCode,DiagnoseCode'="" s RetVal=-3
    q:RetVal=-1 RetVal
    */
    s ProcreationDiagFlag=##class(web.DHCDocOrderCommon).CheckSpecDiag(Adm,"Procreation")
	s RetVal=$case(ProcreationDiagFlag,1:-3,:RetVal)
	i Adm'="" S ^TMPINSUSTRIKE(Adm)=$g(RetVal)_"^"_$g(DepStr)_"^"_$g(AdmDepId)
    q $g(RetVal)
}

}
