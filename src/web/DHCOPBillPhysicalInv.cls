Import SQLUser

/// Creator:Lid
/// CreatDate:2015-08-17
/// Desc:体检收费、退费业务逻辑
Class web.DHCOPBillPhysicalInv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：Lid
/// CreatDate:2015-08-17
/// Desc:收费接口，供体检组调用
/// 	Input:	invAmt:发票金额
/// 			payInfo:支付方式信息，多个支付方式时用$c(2)隔(格式：支付方式表指针^支付金额^银行表指针(CMC_BankMas)^支票号^银行卡类型指针(ARC_BankCardType)^合同单指针^支票日期^支票对方账户号码^账户支付明细表指针)
/// 			papmi:pa_patmas表rowid
/// 			billStr:账单rowid串（格式：账单rowid_$c(2)_账单rowid_$c(2)_...）
/// 			receipNO:发票号
/// 			instype:结算费别
/// 			sFlag:收费退费标志(0:收费，1:退费)
/// 			oldInvDr:原发票rowid
/// 			prtDate:发票日期,为了保证体检发票表的日期和收费发票表的日期一致，如果传空，取$h
/// 			prtTime:发票时间
/// 			expStr:扩展信息(格式："安全组^登录科室^账户rowid^是否走发票(Y:走发票，N:不走发票)^费用类型(F:收费,R:过号,H:体检)^预收额^找零^分币误差^收费员^医院指针^收费员电脑IP地址")
/// 	Return:	标志(0:成功,非0：不成功)^发票rowid
/// 	Debug:w ##class(web.DHCOPBillPhysicalInv).ISaveInv()
ClassMethod ISaveInv(papmi, billStr, payInfo, receipNO, instype, sFlag, oldInvDr, prtDate, prtTime, expStr)
{
	new (papmi,billStr,payInfo,receipNO,instype,sFlag,oldInvDr,prtDate,prtTime,expStr)
	;
	set $ZT="ERROR^DHCSSERR"
	set rtn=0
	;
	set:prtDate="" prtDate=+$h
	set:prtTime="" prtTime=$p($h,",",2)
	;
	set groupDr=$p(expStr,"^",1)
	set ctLocDr=$p(expStr,"^",2)
	set accMDr=$p(expStr,"^",3)
	set requirINVFlag=$p(expStr,"^",4)
	set fariType=$p(expStr,"^",5)
	set preSum=$p(expStr,"^",6)
	set backChange=$p(expStr,"^",7)
	set roundErr=$p(expStr,"^",8)
	set guser=$p(expStr,"^",9)
	set hospitalDr=$p(expStr,"^",10)
	set IPAdress=$p(expStr,"^",11)
	;
	;计算票据金额
	set (totsum,discsum,paysum,patsum)=0
	set mylen=$l(billStr,$c(2))
	for i=1:1:mylen quit:rtn'=0  do
	.set mybillnoRid=$p(billStr,$c(2),i)		;循环取出账单RowID
	.set myPaADMRowid=$p($g(^DHCPB(mybillnoRid)),"^",1)		;DHC_PatientBill->PB_Adm_Dr
	.;获取此票据金额
	.set totsum=+totsum+$p($g(^DHCPB(mybillnoRid)),"^",8)
	.set discsum=+discsum+$p($g(^DHCPB(mybillnoRid)),"^",9)
	.set paysum=+paysum+$p($g(^DHCPB(mybillnoRid)),"^",11)
	.set patsum=+patsum+$p($g(^DHCPB(mybillnoRid)),"^",12)
	;
	set prtFlag="N"	    //默认发票状态是正常(N:正常,A:作废,S:红冲,TP:预结算)
	;
	if (receipNO'="") do
	.set myPFlag="P"
	else  do
	.set myPFlag="N"
	;
	set myUseINVType="O"
	;
	do ..tb()
	;
	set prtRowID=""
	if (+rtn=0) {
		;报表发票表 dhc_invprt
		kill PLIST
		set PLIST(2)=totsum			;PRT_Acount
		set PLIST(3)=""			;PRT_ARRCP_DR
		set PLIST(4)=prtDate			;PRT_Date
		set PLIST(6)=prtFlag			;PRT_Flag
		set PLIST(12)=papmi			;PRT_PAPMI_DR
		set PLIST(13)=myUseINVType		;PRT_PatType
		set PLIST(16)=""			;PRT_SocialStatus
		set PLIST(14)=prtTime			;PRT_Time
		set PLIST(15)=guser			;PRT_Usr
		set PLIST(11)=receipNO			;PRT_inv
		set PLIST(19)=paysum			;PRT_PayorShare
		set PLIST(20)=discsum			;PRT_DiscAmount
		set PLIST(21)=patsum			;PRT_PatientShare
		set PLIST(22)=instype			;PRT_InsType_DR
		set PLIST(30)=oldInvDr			;PRT_OldINV_DR
		set PLIST(17)=myPFlag			;PRT_INVPrintFlag
		set PLIST(35)=fariType			;PRT_FairType
		set PLIST(36)=preSum			; PRT_OPPreSum
		set PLIST(37)=backChange			;PRT_OPBackChange
		set PLIST(38)=roundErr			;PRT_OPCRoundErr
		set PLIST(39)=""			;PRT_SubAvailHosp
		set PLIST(40)=hospitalDr          ;prt_hosptital_dr
		set PLIST(42)=groupDr          ;prt_Group_dr
		set PLIST(44)=IPAdress          ;PRT_IPAdress
		set PLIST(45)=""          ;PRTStayFlag
		set myrtn=##class(web.DHCOPInvoice).INSERT()
		set rtn=$p(myrtn,"^",1)
		set prtRowID=$p(myrtn,"^",2)	
	}
	;
	if (+rtn=0) {
		;保存支付方式表 dhc_invpaymode 
		set payMLen=$l(payInfo,$c(2))
		for m=1:1:payMLen do  quit:(+rtn'=0)
		.set myPayMInfo=$p(payInfo,$c(2),m)
		.quit:(myPayMInfo="")
		.set prtParRef=prtRowID
		.set payMDr=$p(myPayMInfo,"^",1)
		.set payMAmt=$p(myPayMInfo,"^",2)
		.set bankMasDr=$p(myPayMInfo,"^",3)
		.set chequeNO=$p(myPayMInfo,"^",4)
		.set bankCardTypeDr=$p(myPayMInfo,"^",5)
		.set unitDr=$p(myPayMInfo,"^",6)
		.set chequeDate=$p(myPayMInfo,"^",7)
		.set payAccNO=$p(myPayMInfo,"^",8)
		.set accMPLDr=$p(myPayMInfo,"^",9)
		.kill PLIST
		.set PLIST(0)=prtParRef     ;IPM_PRT_ParRef
		.set PLIST(3)=payMDr		;IPM_PayMode_DR
		.set PLIST(4)=bankMasDr		;IPM_CMBank_DR
		.set PLIST(5)=payMAmt		;IPM_Amt
		.set PLIST(6)=chequeNO		;IPM_CardChequeNo
		.set PLIST(7)=bankCardTypeDr		;IPM_Card_DR
		.set PLIST(8)=prtDate					;IPM_Date
		.set PLIST(9)=prtTime			;IPM_Time
		.;为了卡消费对应的外键
		.set PLIST(10)=accMPLDr		;IPM_AccPL_DR
		.set PLIST(11)=unitDr		;IPM_Unit
		.set PLIST(12)=payAccNO		;IPM_PayAccNO
		.if (chequeDate["/") d  
		..set chequeDate=$zdh(chequeDate,4)
		.else  do
		..set chequeDate=""
		.set PLIST(13)=chequeDate		;IPM_ChequeDate	
		.;非医保支付方式标志
		.if (PLIST(3)'="") set payMFlag=##class(web.UDHCINVPRT).CheckYBPayMode(PLIST(3))
		.if +$g(payMFlag)>0 do
		..set PLIST(14)=1   	
		.set myrtn=##class(web.UDHCINVPayMode).INSERT()	
		.set rtn=$p(myrtn,"^",1)
	}
	;
	if (+rtn=0) {
		;保存发票表与帐单表的关系 dhc_billconinv
		set mylen=$l(billStr,$c(2))
		for i=1:1:mylen quit:(rtn'=0)  do
		.set mybillnoRid=$p(billStr,$c(2),i)		;循环取出新账单RowID
		.quit:(+mybillnoRid=0)
		.set myPaADMRowid=$p($g(^DHCPB(mybillnoRid)),"^",1)		;DHC_PatientBill->PB_Adm_Dr
		.&sql(insert into DHC_BillConINV (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR) values (:myPaADMRowid,:prtRowID,:mybillnoRid))
		.set rtn=SQLCODE
		.quit:rtn
	}
	
	if rtn=0 {
		do ..tc()	
	}else{
		TRollBack
	}
	;
	quit rtn_"^"_prtRowID
}

/// Creator：Lid
/// CreatDate:2015-08-17
/// Desc:接口，供体检组调用
/// 	Input:	prtRowID:退费发票rowid
/// 			billStr:负账单rowid串（格式：账单rowid_$c(2)_账单rowid_$c(2)_...）
/// 			invFlag:发票状态(N:正常,A:作废,S:红冲,TP:预结算)
/// 			payInfo:支付方式信息，多个支付方式时用$c(2)隔(格式：支付方式表指针^支付金额^银行表指针(CMC_BankMas)^支票号^银行卡类型指针(ARC_BankCardType)^合同单指针^支票日期^支票对方账户号码^账户支付明细表指针)
/// 			receiptNo:发票号,负票不走发票时传空
/// 			prtDate:发票日期,为了保证体检发票表的日期和收费发票表的日期一致，如果传空，取$h
/// 			prtTime:发票时间
/// 			expStr:安全组^登录科室^收费员^医院指针^IP地址
/// 	Return: 标志(0:成功,非0：不成功)^负发票rowid
/// 	Debug:w ##class(web.DHCOPBillPhysicalInv).ISaveInv()
ClassMethod IRefundInv(prtRowID, billStr, invFlag, payInfo, receiptNo, prtDate, prtTime, expStr)
{
	new (prtRowID,billStr,invFlag,payInfo,receiptNo,prtDate,prtTime,expStr)
	set $ZT="ERROR^DHCSSERR"
	set rtn=0
	set groupDr=$p(expStr,"^",1)
	set ctLocDr=$p(expStr,"^",2)
	set guser=$p(expStr,"^",3)
	set hospitalDr=$p(expStr,"^",4)
	set IPAdress=$p(expStr,"^",5)
	;
	do ..tb()
	;
	set strikePrtRowID=""
	if (+rtn=0) {
		;更新原来的票据状态
		set rtn=##class(web.DHCOPInvoice).SELECT(prtRowID)
		quit:rtn rtn
		set PLIST(6)=invFlag			;PRT_Flag
		set rtn=##class(web.DHCOPInvoice).UPDATE(prtRowID)
	}
	if (+rtn=0) {
		set canelExpStr=""
		set parkvalue=##class(web.UDHCINVPRT).INVPRTCancel(prtRowID, guser, invFlag, prtDate, prtTime,$g(receiptNo),canelExpStr)
		set rtn=$p(parkvalue,"^",1)
		set strikePrtRowID=$p(parkvalue,"^",2)	
	}
	if (+rtn=0) {
		;保存发票表与帐单表的关系 dhc_billconinv
		set mylen=$l(billStr,$c(2))
		for i=1:1:mylen quit:(rtn'=0)  do
		.set mybillnoRid=$p(billStr,$c(2),i)		;循环取出新账单RowID
		.quit:(+mybillnoRid=0)
		.set myPaADMRowid=$p($g(^DHCPB(mybillnoRid)),"^",1)		;DHC_PatientBill->PB_Adm_Dr
		.&sql(insert into DHC_BillConINV (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR) values (:myPaADMRowid,:strikePrtRowID,:mybillnoRid))
		.set rtn=SQLCODE	
	}
	if (+rtn=0) {
		;保存支付方式表 dhc_invpaymode 
		set payMLen=$l(payInfo,$c(2))
		for m=1:1:payMLen do  quit:(+rtn'=0)
		.set myPayMInfo=$p(payInfo,$c(2),m)
		.quit:(myPayMInfo="")
		.set prtParRef=strikePrtRowID
		.set payMDr=$p(myPayMInfo,"^",1)
		.set payMAmt=$p(myPayMInfo,"^",2)
		.set bankMasDr=$p(myPayMInfo,"^",3)
		.set chequeNO=$p(myPayMInfo,"^",4)
		.set bankCardTypeDr=$p(myPayMInfo,"^",5)
		.set unitDr=$p(myPayMInfo,"^",6)
		.set chequeDate=$p(myPayMInfo,"^",7)
		.set payAccNO=$p(myPayMInfo,"^",8)
		.set accMPLDr=$p(myPayMInfo,"^",9)
		.kill PLIST
		.set PLIST(0)=prtParRef     ;IPM_PRT_ParRef
		.set PLIST(3)=payMDr		;IPM_PayMode_DR
		.set PLIST(4)=bankMasDr		;IPM_CMBank_DR
		.set PLIST(5)=payMAmt		;IPM_Amt
		.set PLIST(6)=chequeNO		;IPM_CardChequeNo
		.set PLIST(7)=bankCardTypeDr		;IPM_Card_DR
		.set PLIST(8)=prtDate				;IPM_Date
		.set PLIST(9)=prtTime			;IPM_Time
		.;为了卡消费对应的外键
		.set PLIST(10)=accMPLDr		;IPM_AccPL_DR
		.set PLIST(11)=unitDr		;IPM_Unit
		.set PLIST(12)=payAccNO		;IPM_PayAccNO
		.if (chequeDate["/") d  
		..set chequeDate=$zdh(chequeDate,4)
		.else  do
		..set chequeDate=""
		.set PLIST(13)=chequeDate		;IPM_ChequeDate	
		.;非医保支付方式标志
		.if (PLIST(3)'="") set payMFlag=##class(web.UDHCINVPRT).CheckYBPayMode(PLIST(3))
		.if +$g(payMFlag)>0 do
		..set PLIST(14)=1   	
		.set myrtn=##class(web.UDHCINVPayMode).INSERT()	
		.set rtn=$p(myrtn,"^",1)
	}
	;
	
	if (rtn=0) {
		do ..tc()	
	}else{
		TRollBack
	}
	;
	quit rtn_"^"_strikePrtRowID
}

/// 测试收费
/// w ##class(web.DHCOPBillPhysicalInv).ISaveInvTest()
ClassMethod ISaveInvTest(job)
{
	new (job)
	set papmi=1111
	set billStr=223044_$c(2)_223045
	set payInfo="1^999^2^zph00001^^11^^^11||1"_$c(2)_"2^1000^4^zph00002^^12^^^11||2"
	set receipNO="100000001"
	set instype=1
	set sFlag=0
	set oldInvDr=""
	set prtDate=+$h
	set prtTime=$p($h,",",2)
	set expStr="5^8^^Y^H^1500^400^^1^2^"
	set rtn=##class(web.DHCOPBillPhysicalInv).ISaveInv(papmi,billStr,payInfo,receipNO,instype,sFlag,oldInvDr,prtDate,prtTime,expStr)		
	quit rtn
}

/// 测试退费
/// w ##class(web.DHCOPBillPhysicalInv).IRefundInvTest()
ClassMethod IRefundInvTest(job)
{
	new (job)
	set prtRowID=194715
	set billStr=223044_$c(2)_223045
	set invFlag="A"
	set payInfo="1^-999^2^zph00001^^11^^^11||3"_$c(2)_"2^-1000^4^zph00002^^12^^^11||4"
	set receiptNo=""
	set prtDate=+$h
	set prtTime=$p($h,",",2)
	set expStr="5^8^1^2^"
	set rtn=##class(web.DHCOPBillPhysicalInv).IRefundInv(prtRowID,billStr,invFlag,payInfo,receiptNo,prtDate,prtTime,expStr)
	quit rtn
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
