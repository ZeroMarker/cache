Import SQLUser

Class web.UDHCJFPAY Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.UDHCJFPAY).paybill0("8696&1322&1&-278.00&4&192.168.101.95&1722.00&2000.00&N","1^^^^^-100.00^N^N^"_$c(2)_"2^^11^^^-178.00^N^N^","17275^241^2^2^20")
ClassMethod paybill0(payStr As %String, paymStr As %String, sessionStr As %String) As %String
{
  	set ^TMP("paybill0")=$lb(payStr, paymStr, sessionStr)
  	set billId=$p(payStr,"&",1)
  	set depRowIdStr=$p(payStr,"&",2)
  	set allDepFlag=$p(payStr,"&",3)
  	set payedAmt=$p(payStr,"&",4)   //应收应退金额
  	set adm=$p(payStr,"&",5)
  	set computerName=$p(payStr,"&",6)
  	set PatFee=$p(payStr,"&",7)
    set payDepSum=$p(payStr,"&",8)
    set multiInvFlag=$p(payStr,"&",9)
    
    set userId=$p(sessionStr,"^",1)
	
    set admLastStatus=..GetAdmLastStatus(adm)
    quit:(admLastStatus="B") -1_"^"_"患者正在进行费用调整，不能结算"
    
    set rtn=..JudgePatFee(billId, PatFee, payedAmt, allDepFlag, payDepSum, paymStr, sessionStr)
    quit:(+rtn) rtn
	
	//+2022-10-09 ZhYW 增加对就诊加锁
	set lockErr=##class(DHCDoc.Util.System).LOCK("PA_Adm", adm, userId, computerName)
	quit:(+lockErr'=-1) -110_"^"_"就诊："_adm_"被锁定"
	
 	set rtnValue=..PayBill(billId, paymStr, depRowIdStr, payDepSum, multiInvFlag, sessionStr)
 	
 	do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
 	
 	quit rtnValue
}

ClassMethod PayBill(billId As %String, paymStr As %String, depRowIdStr As %String, deposit As %String, multiInvFlag As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)

	set rtn=0
	
	ts
	
	set adm=$p($g(^DHCPB(+billId)),"^",1)
	
	//更新账单
	set rtn=..UpdatePatBill(billId, userId)
	if (+rtn) tro  quit rtn
	
	//保存DHC_JFPatIPSubCatFee
    set rtn=..InsIPSubCatFee(billId)
    if (+rtn) tro  quit rtn
        
    //+2022-04-11 ZhYW 将有效的担保记录置结束日期
    set rtn=##class(web.UDHCJFZYDB).FinishAdmWarrants(adm)
    if (+rtn) tro  quit rtn
    
    //如果是封账账单，则删除封账标记
    set rtn=##class(web.DHCIPBillPBCloseAcount).DelCloseAcount(billId)
    if (+rtn) tro  quit rtn
    
    //保存发票
    set rtnValue=..SaveInv(billId, deposit, multiInvFlag, sessionStr)
    set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set prtRowId=$p(rtnValue,"^",2)
	
	//插入DHC_INVPRTZYPayMode表记录
	set rtn=..SavePayMode(prtRowId, paymStr, userId)
	if (+rtn) tro  quit rtn
	
	//更新发票号
	set rtn=..UpdateInvPrtInvNo(prtRowId, sessionStr)
	if (+rtn) quit rtn

	//保存DHC_INVPRTZYConDep
	set rtn=..SaveInvConDep(prtRowId, depRowIdStr, userId)
	if (+rtn) tro  quit rtn
	
	//验证结算是否平衡
    set rtn=..IsChargeBalance(prtRowId)
    if (+rtn) tro  quit rtn
	
	//已做最终结算且没有未结算账单时更新就诊表PAADM_BillFlag
	set prtFlag=$p($g(^DHCINVPRTZY(prtRowId)),"^",8)
	if (prtFlag="N") {
		set rtn=..UpdateAdmBilled(adm, "Y", hospId)
		if (+rtn) tro  quit rtn
	}

	if ($tl>0) tc
	
	//平台接口调用
	set settlementInfo=adm_"^"_prtRowId_"^"_billId
	job ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDFINANCIALSETTLEMENTINFO", settlementInfo)

	quit rtn_"^"_prtRowId

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-12-22
/// Description: 更新押金并记录冲退押金
/// Input: billId: DHC_PatientBill.RowId, userId:SS_User.RowId
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFPAY).UpdatePatBill()
ClassMethod UpdatePatBill(billId As %String, userId As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	
	&SQL(
		UPDATE DHC_PatientBill AS PB
		SET PB_AmountPaid = PB.PB_TotalAmount, PB_AmountToPay = PB.PB_TotalAmount, PB_PayedFlag = 'P',
			PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :userId
		WHERE %ID = :billId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	
	set rtn=..updateitms(billId)
	quit rtn
ERROR
	quit ..AppException()
}

/// Description: 收费结算，将医嘱执行表的记录，账单表的记录修改成Paid
/// Debug: w ##class(web.UDHCJFPAY).updateitms()
ClassMethod updateitms(pb As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	set noLock=##class(web.UDHCJFBaseCommon).IsNoLockTable("", pb, "")
	
	set pbo=0
	while($o(^DHCPB(pb,"O",pbo))&&(+rtn=0)) {
		set pbo=$o(^DHCPB(pb,"O",pbo))
		set pboData=$g(^DHCPB(pb,"O",pbo))
		continue:(pboData="")
		set pboRowId=pb_"||"_pbo
		set oeitm=$p(pboData,"^",4)
		if (noLock'="NoLock") {
			&SQL(
				UPDATE OE_OrdItem
				SET OEORI_Billed = 'P'
				WHERE %ID = :oeitm
			)
		}else {
			&SQL(
				UPDATE %NOLOCK %NOCHECK OE_OrdItem
				SET OEORI_Billed = 'P'
				WHERE %ID = :oeitm
			)
		}
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set oeore=$p(pboData,"^",20)   //执行记录RowId
		continue:(oeore="")
		continue:('$d(^OEORD($p(oeore,"||",1),"I",$p(oeore,"||",2),"X",$p(oeore,"||",3))))
		set billStatus=$p($g(^OEORD($p(oeore,"||",1),"I",$p(oeore,"||",2),"X",$p(oeore,"||",3))),"^",6)
		if (noLock'="NoLock") {
			&SQL(
				UPDATE OE_OrdExec
				SET OEORE_Billed = 'P'
				WHERE %ID = :oeore
			)
		}else {
			&SQL(
				UPDATE %NOLOCK %NOCHECK OE_OrdExec
				SET OEORE_Billed = 'P'
				WHERE %ID = :oeore
			)
		}
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		if (billStatus'="P") {
			if (noLock'="NoLock") {
				&SQL(
					UPDATE DHC_PatBillOrder
					SET PBO_BillStatus = :billStatus
					WHERE %ID = :pboRowId
				)
			}else {
				&SQL(
					UPDATE %NOLOCK %NOCHECK DHC_PatBillOrder
					SET PBO_BillStatus = :billStatus
					WHERE %ID = :pboRowId
				)
			}
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		set billPoint=##class(BILL.IP.COM.Method).GetBillPoint(oeitm)
		set priceDate=$p($g(^OEORD($p(oeore,"||",1),"I",$p(oeore,"||",2),"X",$p(oeore,"||",3))),"^",47)
		set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
		set itm=0
		while($o(^DHCPB(pb,"O",pbo,"D",itm))&&(+rtn=0)) {
			set itm=$o(^DHCPB(pb,"O",pbo,"D",itm))
			set pbdData=$g(^DHCPB(pb,"O",pbo,"D",itm))
			set $p(^DHCPB(pb,"O",pbo,"D",itm),"^",14)="P"
			set price=$p(pbdData,"^",4)
			set dspbDR=$p(pbdData,"^",27)
			//加入检查申请单的计费状态的更新，由B更新为P
			if (isAppRepFlag="Y") {
				set rtn=##class(web.UDHCJFBILLIP).UpdateAppRepTarItmBillStatus(oeitm, "B", "P", oeore)
				quit:(+rtn)
			}
			//调用药房组接口更新打包子表价格
			if ((+dspbDR'=0)&&(billPoint="OD")) {
				set rtnValue=##class(PHA.FACE.OUT.Com).UpdateDspbPrice(dspbDR, price, priceDate, 2)
				set rtn=$p(rtnValue,"^",1)
				if (+rtn) {
					set rtn=+rtn_"^"_"药房组接口[PHA.FACE.OUT.Com||UpdateDspbPrice("_$lts($lb(dspbDR, price, priceDate, 2))_")]失败:"_rtnValue
					quit
				}
			}
		}
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

/// 作废发票
ClassMethod Abort0(val As %String)
{
 	set curno=$p(val,"^",1)
 	set newno=$p(val,"^",2)
 	set billId=$p(val,"^",3)
 	set userId=$p(val,"^",4)
    
    quit:(curno="") -1_"^"_"参数错误"
    
    set prt=$o(^DHCINVPRTZY(0,"INV",curno,""))
    set handin=$p(^DHCINVPRTZY(prt),"^",14)
    quit:(handin="Y") -1_"^"_"收费员已经结算，不能作废"
    
    set olduser=$p(^DHCINVPRTZY(prt),"^",7)
    quit:(olduser'=userId) -1_"^"_"不是该收款员打印的发票，不能作废"
    
    set newprtrowid=$o(^DHCINVPRTZY(0,"InitInv",prt,""))
    quit:(newprtrowid'="") -1_"^"_"该发票已经取消结算，不能作废"
    
    set prtflag=$p(^DHCINVPRTZY(prt),"^",8)
    quit:(prtflag="S") -1_"^"_"该发票已经红冲，不能作废"
    
    set rtn=..Abort(curno, newno, billId, userId)
    
    quit rtn
}

ClassMethod Abort(curno, newno, billId, userId)
{
	set $zt="ERROR"
	
	set rtn=0
	quit:((curno="")&&(newno="")) -1_"^"_"参数错误"
	
	ts

	if (curno'="") {
		set prt=$o(^DHCINVPRTZY(0,"INV",curno,""))
		if (+prt=0) tro  quit -1_"^"_"发票号不存在"
		&SQL(
			UPDATE DHC_INVPRTZY
			SET PRT_Flag = 'A', PRT_AbortDate = CONVERT(DATE, NOW()), PRT_AbortTime = CONVERT(TIME, NOW())
			WHERE %ID = :prt
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
		set arrcp=$p($g(^DHCINVPRTZY(prt)),"^",17)
		if (+arrcp'=0) {
			&SQL(
				UPDATE AR_Receipts
				SET ARRCP_Number = NULL
				WHERE %ID = :arrcp
			)
			set rtn=SQLCODE
			if (+rtn) tro  quit rtn_"^"_$g(%msg)
		}
	}else {
		//如果是未打印发票之前作废
		set pbData=$g(^DHCPB(billId))
		set adm=$p(pbData,"^",1)
		set insTypeDR=$p(pbData,"^",4)
		set amount=$p(pbData,"^",8)
		&SQL(
			INSERT INTO DHC_INVPRTZY (
				PRT_inv, PRT_Date, PRT_Time, PRT_Adm, PRT_ARPBL,
				PRT_Acount, PRT_Usr, PRT_Flag, PRT_PatType, PRT_Approval
			)
			VALUES (
				:newno, CONVERT(DATE, NOW()), CONVERT(TIME, NOW()), :adm, :billId,
				:amount, :userId, 'A', :insTypeDR, 'N'
			)
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2020-06-06
/// Description: 保存发票
/// Input: billId:DHC_PatientBill.RowId, deposit:结算押金金额, multiInvFlag:打印多张发票标识, sessionStr:操作员Id^安全组Id^科室Id^医院Id
/// Return: 
/// Debug: w ##class(web.UDHCJFPAY).SaveInv("3630","N","10207^241^237^2")
ClassMethod SaveInv(billId As %String, deposit As %String, multiInvFlag As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"

	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set pbData=$g(^DHCPB(billId))
	set adm=$p(pbData,"^",1)
	set insTypeDR=$p(pbData,"^",4)
	set pbDateFrom=$p(pbData,"^",6)
	set pbDateTo=$p(pbData,"^",7)
	set amount=$p(pbData,"^",8)
	set patientId=$p($g(^PAADM(adm)),"^",1)
	set visitStatus=$p($g(^PAADM(adm)),"^",20)
	
	set rtn=0
	
	//控制收费界面打印收据按钮,此账单已经打印的发票被冲掉了,不能生成新发票记录
	set OldInvDR=$o(^DHCINVPRTZY(0,"AR",billId,""),-1)
	quit:((OldInvDR'="")&&($d(^DHCINVPRTZY(0,"InitInv",OldInvDR)))) -1_"^"_"发票已取消结算"
	
	//增加保存住院医保结算ID
	set insuDivDR=""
	set nationalCode=$p($g(^PAC("ADMREA",insTypeDR)),"^",5)
	if (+nationalCode>0) {
		set insuInfo=##class(web.DHCINSUPort).CheckINSUDivFlag("", billId, "", "N", "N")
		set insuFlag=$p(insuInfo,"!",1)
		set insuStr=$p(insuInfo,"!",2)
		if (insuFlag="Y") {
			set insuDivDR=$p(insuStr,"^",2)
		}
		quit:(+insuDivDR=0) -1_"^"_"医保未结算"
	}
	
	set notPayedNum=..GetNotPayedNum(adm)
	set prtFlag=$s((((visitStatus="D")&&(notPayedNum=0))):"N",1:"I")
	
	set amountToPay=##class(web.UDHCJFQFDEAL).getqfamountbill(billId)   //欠费金额
	set clientIPAddress=$system.Process.ClientIPAddress()
	
	&SQL(
		INSERT INTO DHC_INVPRTZY (
			PRT_Adm, PRT_ARPBL, PRT_Acount, PRT_Usr,
			PRT_Flag, PRT_PatType, PRT_Approval, PRT_Handin, PRT_PAPMI_DR,
			PRT_Deposit, PRT_MultiInvFlag, PRT_DiscretOutstAmt, PRT_DateFrom, PRT_DateTo,
			PRT_InsDiv_DR, PRT_Hospital_DR, PRT_IPAddress
		)
		VALUES (
			:adm, :billId, :amount, :userId,
			:prtFlag, :insTypeDR, 'N', 'N', :patientId,
			:deposit, :multiInvFlag, :amountToPay, :pbDateFrom, :pbDateTo,
			:insuDivDR, :hospId, :clientIPAddress
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	set prtRowId=$g(%ROWID)
		
	quit rtn_"^"_prtRowId

ERROR
	quit ..AppException()
}

/// Description: 付款支付方式明细插入
ClassMethod SavePayMode(prtRowId As %String, paymStr As %String, userId As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	set count=$l(paymStr,$c(2))
	for i=1:1:count {
		set myPMStr=$p(paymStr,$c(2),i)
		set paymId=$p(myPMStr,"^",1)
		continue:(+paymId=0)
		set bankId=$p(myPMStr,"^",2)
		set chequeNo=$p(myPMStr,"^",3)
		set unitId=$p(myPMStr,"^",4)         //公费单位
		set payAccNo=$p(myPMStr,"^",5)       //账户号
		set paymAmt=+$p(myPMStr,"^",6)
		set transFlag=$p(myPMStr,"^",7)
		set insuFlag=$p(myPMStr,"^",8)      //医保支付方式标识
		set ETPRowId=$p(myPMStr,"^",9)
		if (paymAmt>0) {
			set hardComFlag=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(paymId)
			if ((+hardComFlag'=0)&&(+ETPRowId=0)) {
				set rtn=-1_"^"_"第三方支付，订单表ID不应为空"
				quit
			}
			if ((+hardComFlag=0)&&(+ETPRowId'=0)) {
				set rtn=-1_"^"_"非第三方支付，订单表ID不应有值"
				quit
			}
		}
		&SQL(
			INSERT INTO DHC_INVPRTZYPayMode (
				IPM_PRT_ParRef, IPM_PayMode_DR, IPM_Bank_DR, IPM_Amt, IPM_CardChequeNo,
				IPM_PayAccNo, IPM_TransFlag, IPM_Unit_DR, IPM_InsuFlag, IPM_ETP_DR,
				IPM_OptUser_DR
			)
			VALUES (
				:prtRowId, :paymId, :bankId, :paymAmt, :chequeNo,
				:payAccNo, :transFlag, :unitId, :insuFlag, :ETPRowId,
				:userId
			)
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		if (+ETPRowId'=0) {
			set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).RelationOrderToHIS(ETPRowId, prtRowId, "IP")
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
		}
		set rtnValue=..InsertQFTotal(paymId, paymAmt, prtRowId, userId)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
	}
	quit:(+rtn) rtn
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-12-22
/// Description: 更新押金并记录冲退押金
/// Input: prtRowId: DHC_INVPRTZY.RowId, depRowIdStr:dhc_sfprintdetail.RowId串(多个之间用^分隔), userId:SS_User.RowId
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFPAY).SaveInvConDep()
ClassMethod SaveInvConDep(prtRowId As %String, depRowIdStr As %String, userId As %String) As %String
{
	set $zt="ERROR"
	
    set rtn=0
    quit:(+prtRowId=0) -1_"^"_"参数错误"
    
    set adm=$p($g(^DHCINVPRTZY(prtRowId)),"^",4)
    
    set count=$l(depRowIdStr,"^")
	for i=1:1:count {
		set depRowId=$p(depRowIdStr,"^",i)
		continue:(depRowId="")
		set depStatus=$p($g(^DHCSFPRINTDETAIL(depRowId)),"^",8)
		//更新押金参与结算状态为已结算
		set rtn=..UpdtDepPayedFlag(depRowId, "Y")
		quit:(+rtn)
		//记录冲退押金
		&SQL(
			INSERT INTO DHC_INVPRTZYConDep (
				ICD_Adm_DR, ICD_Inv_DR, ICD_Dep_DR, ICD_DepStatus, ICD_OptUser_DR
			)
			VALUES (
				:adm, :prtRowId, :depRowId, :depStatus, :userId
			)
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-12-22
/// Description: 更新发票号
/// Input: prtRowId:DHC_INVPRTZY.RowId, sessionStr:收费员^安全组^登陆科室^院区
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFPAY).UpdateInvPrtInvNo()
ClassMethod UpdateInvPrtInvNo(prtRowId As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set rtn=0
	quit:(+prtRowId=0) -1_"^"_"参数错误"
	
	set prtData=$g(^DHCINVPRTZY(prtRowId))
	set insTypeId=$p(prtData,"^",9)
	set patientId=$p(prtData,"^",18)
	set isMultiInv=$p(prtData,"^",24)        //是否打印多张发票
	set printInvFlag=$s((isMultiInv="Y"):"N",1:"Y")         //打印多张发票时不需要打印发票
	
	set receiptId=""    //当前号段RowId
	set invNo=""
	set endNo=""
	set title=""
	set printFlag=..CheckPrtFlag(insTypeId, groupId, hospId, printInvFlag)
	//根据安全组配置需打印发票时再根据支付方式二次判断
	if (printFlag=0) {
		set printFlag=..CheckPrtFlagByGSPM(prtRowId, sessionStr)
	}
	if (printFlag=0) {
		set receiptNoStr=..ReadReceiptNO(userId, insTypeId, hospId)
		set rtn=$p(receiptNoStr,"^",1)
		quit:(+rtn) rtn_"^"_"没有可用发票"
		set invNo=$p(receiptNoStr,"^",2)
		set receiptId=$p(receiptNoStr,"^",3)
		set endNo=$p(receiptNoStr,"^",4)
		set title=$p(receiptNoStr,"^",5)
	}
	set receiptNo=title_invNo
	
	if (receiptNo'="") {
		set rtn=..CheckInvIsRepeat(receiptNo, hospId)    //判断待插入的发票号是否被使用
		quit:(+rtn) rtn
	}
	
	set invPrintFlag=$case(printFlag,0:"P",:"N")   //发票打印标识
	
	&SQL(
		UPDATE DHC_INVPRTZY
		SET PRT_inv = :receiptNo, PRT_INVPrintFlag = :invPrintFlag
		WHERE %ID = :prtRowId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	if (invPrintFlag="P") {
		//更新发票发放表
		set rtn=##class(BILL.IP.COM.Method).UpdateInvoice(receiptId, userId, insTypeId, hospId)
		if (+rtn) quit rtn
	}
	
	//2021-04-08 ZhYW 保存发票扩展表数据
	set payer=$p($g(^PAPER(patientId,"ALL")),"^",1)
	set payerID=$p($g(^PAPER(patientId,"ALL")),"^",9)    //身份证号
	set dto=##class(BILL.INV.DTO.Entity.PrtExt).%New()
	set dto.InvType="I"
	set dto.InvDR=prtRowId
	set dto.BatchNo=title
	set dto.InvNo=invNo
	set dto.PAPMIDR=patientId
	set dto.Payer=payer
	set dto.PayerIdentifier=payerID
	set dto.UserDR=userId
	set dto.Reviewer=""
	set dto.InvoiceDR=receiptId
	set rtn=##class(BILL.INV.BL.PrtExt).Save(dto)
	if (+rtn) quit rtn
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Debug: w ##class(web.UDHCJFPAY).GetUnAbortPrtInvByBill(21319)
ClassMethod GetUnAbortPrtInvByBill(bill As %String) As %String
{
	set prtRowId=""
	quit:(+bill=0) prtRowId
	
	set inv=""
	while($o(^DHCINVPRTZY(0,"AR",bill,inv),-1)) {
		set inv=$o(^DHCINVPRTZY(0,"AR",bill,inv),-1)
		set prtFlag=$p(^DHCINVPRTZY(inv),"^",8)
		continue:(prtFlag="A")
		set prtRowId=inv
		quit
	}
	
	quit prtRowId
}

/// Creator: 杨艳秀
/// CreatDate: 2008-10-10
/// Description: 根据账单号合并收费项目子类的金额，并在结算时把子类的金额保存到表DHC_JFPatIPSubCatFee
/// Table: DHC_PatBillDetails, DHC_JFPatIPSubCatFee
/// Input: DHC_PatientBill.PB_RowId
/// Modify: Lid 2014-06-19 添加参数NoLock，用于判断是否插入时是否锁表
/// Debug: w ##class(web.UDHCJFPAY).InsIPSubCatFee(18667)
ClassMethod InsIPSubCatFee(BillNo As %String, NoLock As %String = "") As %String
{
	set $zt="ERROR"
	
	set rtn=0
	kill ItmCateAry
	set PBO=0
	while($o(^DHCPB(BillNo,"O",PBO))) {
		set PBO=$o(^DHCPB(BillNo,"O",PBO))
		set PBD=0
		while($o(^DHCPB(BillNo,"O",PBO,"D",PBD))) {
			set PBD=$o(^DHCPB(BillNo,"O",PBO,"D",PBD))
			set PBDData=$g(^DHCPB(BillNo,"O",PBO,"D",PBD))
			continue:(PBDData="")
			set TarItmDR=$p(PBDData,"^",3)         //PBD_TARI_DR
			set TotalAmt=$p(PBDData,"^",7)         //PBD_TotalAmount
			set DiscAmt=$p(PBDData,"^",8)          //PBD_DiscAmount
			set PayorAmt=$p(PBDData,"^",9)         //PBD_PayorShare
			set PatShareAmt=$p(PBDData,"^",10)     //PBD_PatientShare
			set TarItmData=$g(^DHCTARI(TarItmDR))
			//住院费用子分类
			set TarIPSub=$p(TarItmData,"^",14)
			set $li(ItmCateAry("IC",TarIPSub),1)=$lg($g(ItmCateAry("IC",TarIPSub)),1)+TotalAmt
			set $li(ItmCateAry("IC",TarIPSub),2)=$lg($g(ItmCateAry("IC",TarIPSub)),2)+DiscAmt
			set $li(ItmCateAry("IC",TarIPSub),3)=$lg($g(ItmCateAry("IC",TarIPSub)),3)+PayorAmt
			set $li(ItmCateAry("IC",TarIPSub),4)=$lg($g(ItmCateAry("IC",TarIPSub)),4)+PatShareAmt
			//会计子分类
			set TarACSub=$p(TarItmData,"^",5)
			set $li(ItmCateAry("AC",TarACSub),1)=$lg($g(ItmCateAry("AC",TarACSub)),1)+TotalAmt
			set $li(ItmCateAry("AC",TarACSub),2)=$lg($g(ItmCateAry("AC",TarACSub)),2)+DiscAmt
			set $li(ItmCateAry("AC",TarACSub),3)=$lg($g(ItmCateAry("AC",TarACSub)),3)+PayorAmt
			set $li(ItmCateAry("AC",TarACSub),4)=$lg($g(ItmCateAry("AC",TarACSub)),4)+PatShareAmt
		}
	}
	
	ts
	
	set CateFlag=""
	while(($o(ItmCateAry(CateFlag))'="")) {
		set CateFlag=$o(ItmCateAry(CateFlag))
		set CateSub=0
		while($o(ItmCateAry(CateFlag,CateSub))) {
			set CateSub=$o(ItmCateAry(CateFlag,CateSub))
			set CateFeeStr=$g(ItmCateAry(CateFlag,CateSub))
			set TotalAmt=$lg(CateFeeStr,1)
			set DiscAmt=$lg(CateFeeStr,2)
			set PayorAmt=$lg(CateFeeStr,3)
			set PatShareAmt=$lg(CateFeeStr,4)
			if (NoLock'="NoLock") {
				&SQL(
					INSERT INTO DHC_JFPatIPSubCatFee (
						IPSubCat_DHCPB_DR, IPSubCat_DR, IPSubCat_TotalAmt, IPSubCat_Type, IPSubCat_DiscAmt,
						IPSubCat_PayOrAmt, IPSubCat_PatShareAmt
					)
					VALUES (
						:BillNo, :CateSub, :TotalAmt, :CateFlag, :DiscAmt,
						:PayorAmt, :PatShareAmt
					)
				)
			}else {
				&SQL(
					INSERT %NOLOCK %NOCHECK INTO DHC_JFPatIPSubCatFee (
						IPSubCat_DHCPB_DR, IPSubCat_DR, IPSubCat_TotalAmt, IPSubCat_Type, IPSubCat_DiscAmt,
						IPSubCat_PayOrAmt, IPSubCat_PatShareAmt
					)
					VALUES (
						:BillNo, :CateSub, :TotalAmt, :CateFlag, :DiscAmt,
						:PayorAmt, :PatShareAmt
					)
				)
			}
			set rtn=SQLCODE
			if (rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: 杨艳秀
/// CreatDate: 2009-02-10
/// Description: 根据病人的AdmRowId,取病人的收费类别PAC_AdmReason.RowId，和PAC_AdmReason.REA_NationCode
/// Table: PAC_AdmReason
/// Input: PA_Adm.RowId
/// Debug: w ##class(web.UDHCJFPAY).GetAdmReaNationCode()
ClassMethod GetAdmReaNationCode(EpisodeID As %String) As %String
{
	set AdmReaRowId=$p(^PAADM(EpisodeID,1),"^",7)
	if (AdmReaRowId'="") {
		set AdmReaData=$g(^PAC("ADMREA",AdmReaRowId))
		set NationCode=$p(AdmReaData,"^",5)
		set AdmReaCode=$p(AdmReaData,"^",1)
		set AdmReaDesc=$p(AdmReaData,"^",2)
	}
	quit $g(AdmReaRowId)_"^"_+$g(NationCode)_"^"_$g(AdmReaCode)_"^"_$g(AdmReaDesc)
}

/// Debug: w ##class(web.UDHCJFPAY).GetBillReaNationCode()
ClassMethod GetBillReaNationCode(BillNo As %String) As %String
{
	set AdmReaRowId=$p(^DHCPB(BillNo),"^",4)
	if (AdmReaRowId'="") {
		set AdmReaData=$g(^PAC("ADMREA",AdmReaRowId))
		set NationCode=$p(AdmReaData,"^",5)
		set AdmReaCode=$p(AdmReaData,"^",1)
		set AdmReaDesc=$p(AdmReaData,"^",2)
	}
	quit $g(AdmReaRowId)_"^"_+$g(NationCode)_"^"_$g(AdmReaCode)_"^"_$g(AdmReaDesc)
}

/// Creator: 杨艳秀
/// CreatDate: 2008-02-04
/// Description: 判断三张账单表的金额是否相等，如果DHC_PatBillDetails和父表不一致，则更新父表的金额
/// Table: DHC_PatientBill, DHC_PatBillOrder, DHC_PatBillDetails
/// Input: DHC_PatientBill.RowId
/// Debug: w ##class(web.UDHCJFPAY).UpdatePatFee(2127)
ClassMethod UpdatePatFee(PBRowID As %String) As %String
{
	set $zt="ERROR"
	
	set PBData=$g(^DHCPB(PBRowID))
	set PBAmt=$p(PBData,"^",8)
	set PBAmt=$fn(PBAmt,"",2)
	set PBDiscAmt=$p(PBData,"^",9)
	set PBDiscAmt=$fn(PBDiscAmt,"",2)
	set PBPayorAmt=$p(PBData,"^",11)
	set PBPayorAmt=$fn(PBPayorAmt,"",2)
	set PBPatShareAmt=$p(PBData,"^",12)
	set PBPatShareAmt=$fn(PBPatShareAmt,"",2)
	
	set PBOSum=0
	set (PBDSum, PBDDiscSum, PBDPayorSum, PBDPatShareSum)=0
	set PBO=0
	while($o(^DHCPB(PBRowID,"O",PBO))) {
		set PBO=$o(^DHCPB(PBRowID,"O",PBO))
		set PBOData=$g(^DHCPB(PBRowID,"O",PBO))
		continue:(PBOData="")
		set PBOAmt=$p(PBOData,"^",8)
		set PBOAmt=$fn(PBOAmt,"",2)
		set PBOSum=$i(PPBOSum, PBOAmt)
		set PBD=0
		while($o(^DHCPB(PBRowID,"O",PBO,"D",PBD))) {
			set PBD=$o(^DHCPB(PBRowID,"O",PBO,"D",PBD))
			set PBDData=$g(^DHCPB(PBRowID,"O",PBO,"D",PBD))
			continue:(PBDData="")
			set PBDAmt=$p(PBDData,"^",7)
			set PBDAmt=$fn(PBDAmt,"",2)
			set PBDDiscAmt=$p(PBDData,"^",8)
			set PBDDiscAmt=$fn(PBDDiscAmt,"",2)
			set PBDPayorAmt=$p(PBDData,"^",9)
			set PBDPayorAmt=$fn(PBDPayorAmt,"",2)
			set PBDShareAmt=$p(PBDData,"^",10)
			set PBDShareAmt=$fn(PBDShareAmt,"",2)
			set PBDSum=$i(PBDSum,PBDAmt)
			set PBDPatShareSum=$i(PBDPatShareSum,PBDShareAmt)
			set PBDDiscSum=$i(PBDDiscSum,PBDDiscAmt)
			set PBDPayorSum=$i(PBDPayorSum,PBDPayorAmt)
		}
	}
	
	set AmtErr=PBDSum-PBAmt
	set AmtErr=$zabs(AmtErr)
	set AmtErr1=PBPatShareAmt-PBDPatShareSum
	set AmtErr2=PBDiscAmt-PBDDiscSum
	set AmtErr3=PBPayorAmt-PBDPayorSum
	if $zabs(AmtErr)<$zabs(AmtErr1) set AmtErr=$zabs(AmtErr1)
	if $zabs(AmtErr)<$zabs(AmtErr2) set AmtErr=$zabs(AmtErr2)
	if $zabs(AmtErr)<$zabs(AmtErr3) set AmtErr=$zabs(AmtErr3)
	
	set rtn=0
	if ((+AmtErr'=0)&&(+AmtErr<0.02)) {    //大于0.02不找平，防止出问题
		&SQL(
			UPDATE DHC_PatientBill
    		SET PB_TotalAmount = :PBDSum, PB_DiscAmount = :PBDDiscSum,
    		    PB_PayorShare = :PBDPayorSum, PB_PatientShare = :PBDPatShareSum
    		WHERE %ID = :PBRowID
    	)
  		set rtn=SQLCODE
  		if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    quit rtn

ERROR
	quit ..AppException()
}

/// Creator: 杨艳秀
/// CreatDate: 2009-07-17
/// Description: 保存欠费结算病人的信息
/// Table: DHC_JFqftotal
/// Input: 欠费信息
/// Return: 0:成功, <>0:失败
ClassMethod InsertQFTotal(paymId As %String, payAmt As %String, prtRowId As %String, userId As %String) As %String
{
	set $zt="ERROR"

   	set rtn=0
	quit:(+payAmt=0) rtn
	
	set prtData=$g(^DHCINVPRTZY(prtRowId))
	set adm=$p(prtData,"^",4)
	set billId=$p(prtData,"^",5)
	set hospId=$p(prtData,"^",35)
	
	set paymCode=$p(^CT("CTPM",paymId),"^",1)
	set QFFlag=$case(paymCode,"QF":"Q","JC":"C",:"")  //欠费 结存 
	quit:(QFFlag="") rtn
	
	&SQL(
		INSERT INTO DHC_JFQFTotal (
			QF_Adm, QF_Amount, QF_Flag, QF_AddUser, QF_Status,
			QF_Prt_dr, QF_Pb_dr, QF_HandIn, QF_Hosp_DR
		)
		VALUES (
			:adm, :payAmt, :QFFlag, :userId, 'N',
			:prtRowId, :billId, 'N', :hospId
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
    
	quit rtn

ERROR
	quit ..AppException()
}

/// Description: 用于结算打印发票，生成发票记录前，判断是否尚有未结算账单
/// Debug: w ##class(web.UDHCJFPAY).GetNotPayedNum(1406)
ClassMethod GetNotPayedNum(Adm As %String) As %String
{
	set NoPayedNum=0
	set PBRowID=0
	while($o(^DHCPB(0,"ADM",Adm,PBRowID))) {
		set PBRowID=$o(^DHCPB(0,"ADM",Adm,PBRowID))
		set PBData=$g(^DHCPB(PBRowID))
		set PayedFlag=$p(PBData,"^",16)
  		set CloseAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(PBRowID)
 		continue:((PayedFlag="P")&&(CloseAcountFlag'="Y"))
		set NoPayedNum=$i(NoPayedNum)
	}
	quit NoPayedNum
}

/// Debug: w ##class(web.UDHCJFPAY).GetInvTypeByAdmRea(1, "O", 2)
ClassMethod GetInvTypeByAdmRea(InsType As %String, AppType As %String, HospId As %String) As %String
{
	set InvInsType=""
    quit:(InsType="") InvInsType
    
    set DefHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_AdmReaInvType", HospId)
    
    set SARERowid=0
    while($o(^DHCSOPADMRExpi(0,"ADMR",InsType,SARERowid))) {
	    set SARERowid=$o(^DHCSOPADMRExpi(0,"ADMR",InsType,SARERowid))
		set SAREData=$g(^DHCSOPADMRExp(SARERowid))
		set SAREHospDR=$p(SAREData,"^",8)
		continue:(SAREHospDR'=DefHospId)
		set SAREAppType=$p(SAREData,"^",3)   //SARE_Note1
		continue:(AppType'=SAREAppType)
		set SAREUseType=$p(SAREData,"^",2)   //SARE_UseFareType
		set InvInsType=SAREUseType
		quit
	}
	
	quit InvInsType
}

/// Debug: w ##class(web.UDHCJFPAY).UpdateReceiptNO()
ClassMethod UpdateReceiptNO(receiptId As %String, invno As %String, userId As %String, insTypeId As %String, hospId As %String) As %String
{
	set rtn=0
	set invType=..GetInvTypeByAdmRea(insTypeId, "I", hospId)   //wangjian 按配置取当前费别的发票类型
	if (invType="") set invType="I"
	
	&SQL(
		UPDATE DHC_INVOICE
		SET INV_LastNum = :invno, INV_Finalflag = 'N'
		WHERE %ID = :receiptId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	
	&SQL(
		SELECT TOP 1 %ID INTO :rowid1
		FROM DHC_INVOICE
		WHERE (INV_Finalflag = '' OR INV_Finalflag IS NULL) AND INV_Usr = :userId AND INV_type = :invType AND INV_hospital = :hospId
		ORDER BY %ID
	)
	if (+rowid1>0) {
		&SQL(
			UPDATE DHC_INVOICE
			SET INV_Finalflag = 'Y'
			WHERE %ID = :rowid1
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
	}
	
	quit rtn
}

/// Creator: 杨艳秀
/// CreatDate: 2009-02-16
/// Description: 1、判断实际账单金额与界面金额是否一致，不一致则不允许结算；
///              2、判断账单三张表的金额是否一致，若不在误差范围内则不允许结算;
///              3、判断要结算的预交金与实际要结算的预交金是否一致
/// Input: BillNo:DHC_PatientBill.RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFPAY).JudgePatFee()
ClassMethod JudgePatFee(BillNo As %String, PatFee As %String, RightSum As %String, AllDepFlag As %String, PayDepSum As %String, PaymStr As %String, SessionStr As %String) As %String
{
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CtLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)

	set rtn=0
	
	set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(BillNo)
	quit:(+prtRowId'=0) -1_"^"_"账单已经结算，不能重复结算"
	
	set BillData=$g(^DHCPB(BillNo))
	set Adm=$p(BillData,"^",1)
	//+2022-10-09 ZhYW 根据配置控制未出院患者不能结算
	set VisitStatus=$p(^PAADM(Adm),"^",20)
	if (VisitStatus="A") {
		set allowedIntPay=..IsAllowedIntPay(HospId)
		quit:(+allowedIntPay=0) -1_"^"_"患者未出院，不能结算"
	}
	
	//modify chenxi 2011-03-21 根据住院业务参数表里配置的预交金支付方式为支票时是否能参与预算
    //set DepositSum=##class(web.UDHCJFBaseCommon).deposit(Adm)
    set DepositSum=##class(web.UDHCJFBaseCommon).depositBankBack(Adm)
    if (((+PayDepSum'=+DepositSum)&&(AllDepFlag=1))) {
	    quit -1_"^"_"要结算的押金金额与实际的押金金额不符"
	}
	
	set rtnValue=##class(web.UDHCJFBILL).BILLN(Adm, UserId)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
    
  	set rtn=..IsBillBalance(BillNo)
  	quit:(+rtn) rtn
  	
	set PatFee=$fn(PatFee,"",2)
	set PBPatShareAmt=$p(BillData,"^",12)
	set PBPatShareAmt=$fn(PBPatShareAmt,"",2)
	quit:(+PatFee'=+PBPatShareAmt) -1_"^"_"界面金额与实际账单金额不相等，界面金额："_PatFee_"，实际账单金额："_PBPatShareAmt
	
	set paymSum=0
	set insuPaymSum=0
	for i=1:1:$l(PaymStr,$c(2)) {
		set singlePay=$p(PaymStr,$c(2),i)
		set paymAmt=$p(singlePay,"^",6)
		set insuFlag=$p(singlePay,"^",8)
		set paymSum=$i(paymSum,paymAmt)
		continue:(insuFlag'="Y")
		set insuPaymSum=$i(insuPaymSum,paymAmt)
	}
	set paymSum=$fn(paymSum,"",2)
	set insuPaymSum=$fn(insuPaymSum,"",2)
	set PayDepSum=$fn(PayDepSum,"",2)
    quit:(+paymSum'=+(PatFee-PayDepSum)) -1_"^"_"支付金额与实际要支付的金额不相等，支付金额："_paymSum_"，实际要支付的金额："_(PatFee-PayDepSum)
    
    //wangjian 2019-04-03 增加医保验证
	set insuTotalAmt=PatFee
	set insuSelfAmt=PatFee
    set insTypeDR=$p(BillData,"^",4)
	set nationalCode=$p(^PAC("ADMREA",insTypeDR),"^",5)
    if (+nationalCode>0) {
	    set insuInfo=##class(web.DHCINSUPort).GetDivideByPBDr("", BillNo)
		if (insuInfo'="") {
			set divInfo=$p(insuInfo,"!^",2)
			set insuTotalAmt=$p(divInfo,"^",7)         //医保总金额
			set insuTotalAmt=$fn(insuTotalAmt,"",2)
			set insuSelfAmt=$p(divInfo,"^",15)         //医保自付(医保现金)
			set insuSelfAmt=$fn(insuSelfAmt,"",2)
		}
	}
	quit:(+insuTotalAmt'=+PatFee) -1_"^"_"医保总金额与HIS金额不相等，医保总金额："_insuTotalAmt_"，HIS金额："_PatFee

	set insuPayAmt=insuTotalAmt-insuSelfAmt      //医保支付金额
	set insuPayAmt=$fn(insuPayAmt,"",2)
	
	//1 验证 多退少补<->(医保自付-押金)
	set RightSum=$fn(RightSum,"",2)
	quit:(+RightSum'=+(insuSelfAmt-PayDepSum)) -1_"^"_"应收应退金额不正确"
	
	//2 验证医保支付方式=医保支付总额
	quit:(+insuPaymSum'=+insuPayAmt) -1_"^"_"医保支付方式之和与医保支付总额不相等，医保支付方式之和："_insuPaymSum_"，医保支付总额："_insuPayAmt

    quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-12-22
/// Description: 验证结算是否平衡
/// Input: prtRowId:DHC_INVPRTZY.RowId
/// Return: 0:平，<>0:不平
/// Debug: w ##class(web.UDHCJFPAY).IsChargeBalance(22624)
ClassMethod IsChargeBalance(prtRowId As %String) As %String
{
	quit:(+prtRowId=0) -1_"^"_"参数错误"
	
	set prtData=$g(^DHCINVPRTZY(prtRowId))
	set pb=$p(prtData,"^",5)
	set deposit=$p(prtData,"^",22)    //押金金额
	set deposit=$fn(deposit,"",2)
	set patShareAmt=$p($g(^DHCPB(pb)),"^",12)   //账单自付金额
	set patShareAmt=$fn(patShareAmt,"",2)
	
	set paymSum=0     //支付方式金额合计
	set paymSub=0
	while($o(^DHCINVPRTZY(prtRowId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRTZY(prtRowId,"P",paymSub))
		set paymSubData=$g(^DHCINVPRTZY(prtRowId,"P",paymSub))
		continue:(paymSubData="")
		set paymAmt=$p(paymSubData,"^",3)
		set paymSum=$i(paymSum, paymAmt)
	}
	set paymSum=$fn(paymSum,"",2)
	
	//+2022-12-22 ZhYW 获取发票关联结算的押金
	set chgDeposit=0
	set conId=0
	while($o(^DHCINVPRTZYCONDEPi(0,"Inv",prtRowId,conId))) {
		set conId=$o(^DHCINVPRTZYCONDEPi(0,"Inv",prtRowId,conId))
		set conData=$g(^DHCINVPRTZYCONDEP(conId))
		continue:(conData="")
		set depRowId=$p(conData,"^",3)
		continue:(depRowId="")
		set depAmt=$p($g(^DHCSFPRINTDETAIL(depRowId)),"^",6)
		set chgDeposit=$i(chgDeposit, depAmt)
	}
	set chgDeposit=$fn(chgDeposit,"",2)
	
	quit:(+$fn(chgDeposit,"",2)'=+deposit) -1_"^"_"收费员选择的押金与后台计算的押金不相等"
	quit:((paymSum+deposit)'=+patShareAmt) -1_"^"_"支付方式金额，账单金额，结算押金不平"
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2018-09-20
/// Description: 判断该就诊下的账单是否被拆分
/// Input: episodeId:PA_Adm.RowId
/// Return: splitFlag ("N":未拆分, "Y":拆分)
/// Debug: w ##class(web.UDHCJFPAY).CheckBillIsSplitByAdm(4071)
ClassMethod CheckBillIsSplitByAdm(episodeId As %String) As %String
{
	set splitFlag="N"
	quit:(+episodeId=0) splitFlag
	
	set notPayedNum=..GetNotPayedNum(episodeId)
	
	//获取该就诊下已结算账单数量(被取消的账单不计入)
	set payedNum=0
	set pb=0
	while($o(^DHCPB(0,"ADM",episodeId,pb))) {
		set pb=$o(^DHCPB(0,"ADM",episodeId,pb))
		set pbData=$g(^DHCPB(pb))
		set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(pb)
		continue:(prtRowId="")   //过滤未结算账单
	    set refundFlag=$p(pbData,"^",17)
	    continue:(refundFlag'="")         //过滤取消结算的
	    set payedNum=$i(payedNum)
	}

    //1.未结账单>1时,表示有拆分
    //2.已结账单>1时,表示有拆分
    //3.未结账单>0,且已结账单>0时,表示有拆分
	if ((+notPayedNum>1)||(+payedNum>1)||((+notPayedNum>0)&&(payedNum>0))) {
 		set splitFlag="Y"
	}
	
	quit splitFlag
}

/// Creator: ZhYW
/// CreatDate: 2019-09-04
/// Desctiption: 取收费员当前可用住院发票信息
/// Input: 
/// Return: rtn_"^"_receiptNo_"^"_receiptId_"^"_endNo_"^"_title_"^"_leftNum
/// Debug: w ##class(web.UDHCJFPAY).ReadReceiptNO(10207, 1)
ClassMethod ReadReceiptNO(userId As %String, insTypeId As %String, hospId As %String) As %String
{
	set receiptNo=""
	set receiptId=""
	set endNo=""
	set title=""
	set leftNum=0
	set rtn=108
	quit:(userId="") rtn	//没有发票
	
	set myINVType=..GetInvTypeByAdmRea(+insTypeId, "I", hospId)
	if (myINVType="") set myINVType="I"

	set myINVRowID=0
	while($o(^DHCINVOICE(0,"USER",userId,myINVRowID))) {
		set myINVRowID=$o(^DHCINVOICE(0,"USER",userId,myINVRowID))
		set myInvData=$g(^DHCINVOICE(myINVRowID))
		set myHospDR=$p(myInvData,"^",26)
		continue:(myHospDR'=hospId)
		set myFinalFlag=$p(myInvData,"^",7)
		continue:(myFinalFlag'="Y")
		set myType=$p(myInvData,"^",8)
		continue:(myType'=myINVType)
		set myReceiptNo=$p(myInvData,"^",6)
		set myEndno=$p(myInvData,"^",2)
		set myBegNo=$p(myInvData,"^",1)
		continue:(+myReceiptNo<+myBegNo)
		continue:(+myReceiptNo>+myEndno)
		set title=$p(myInvData,"^",16)
		set receiptNo=myReceiptNo
		set endNo=myEndno
		set receiptId=myINVRowID
		set leftNum=+endNo-receiptNo+1
		set rtn=0
		quit
	}
	
	set minTipRcptNum=##class(web.DHCBillCommon).GetParamConfigFlag("MinTipRcptNum")
	set tipFlag=$s((leftNum<minTipRcptNum):1, 1:0)  //余票数小于设置值时，界面给予提示(1:提示, 0:不提示)
	
	quit rtn_"^"_receiptNo_"^"_receiptId_"^"_endNo_"^"_title_"^"_leftNum_"^"_tipFlag
}

/// Description: 获取就诊的状态
/// Debug: w ##class(web.UDHCJFPAY).GetAdmLastStatus()
ClassMethod GetAdmLastStatus(adm As %String)
{
	set sub=$o(^DHCDischargeHistory(adm,"History",""),-1)
	set admLastStatus=$s((sub'=""):$p($g(^DHCDischargeHistory(adm,"History",sub)),"^",4),1:"")
	quit admLastStatus
}

/// Creator: ZhYW
/// CreatDate: 2020-06-06
/// Description: 判断是否打印票据
/// Input: insTypeId:PAC_AdmReason.RowId,
///        groupId:SS_Group.RowId,
///        hospId:CT_Hospital.RowId,
///        printInvFlag:(N/Y:此参数优先级最高,为N时不打印,Y时再根据其他配置判断是否打印)
/// Return: =0:打印, =1:不打印
/// Debug: w ##class(web.UDHCJFPAY).CheckPrtFlag("1","240","2","Y")
ClassMethod CheckPrtFlag(insTypeId As %String, groupId As %String, hospId As %String, printInvFlag As %String) As %String
{
	set ^TMP("CheckPrtFlag")=$lb(insTypeId, groupId, hospId, printInvFlag)
	quit:(printInvFlag'="Y") 1
	
	if (+insTypeId'=0) {
		set reaIPInvPrtFlag=$p($g(^PAC("ADMREA",insTypeId)),"^",17)
		quit:(+reaIPInvPrtFlag'=0) 1   //该费别不打印发票
	}
	
	//增加条件判断是否需要打印发票?还是直接打印一个小条?由配置来定
	set rtnValue=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupId, hospId)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtn
	set myGUPrt=$p(rtnValue,"^",5)
	//判断患者类型打印票据前提下, 此安全组中是否打印发票
	set prtFlag=$case(+myGUPrt,1:0,:1)
	
	quit prtFlag
}

/// Creator: ZhYW
/// CreatDate: 2021-05-13
/// Description: 根据结算支付方式判断是否打印发票
///              当且仅当所有支付方式都配置不打印发票时，这张发票不打印
/// Input: prtRowId:DHC_INVPRTZY.RowId, sessionStr:操作员Id^安全组Id^科室Id^医院Id
/// Return: prtFlag(=0:打印, =1:不打印)
/// Debug: w ##class(web.UDHCJFPAY).CheckPrtFlagByGSPM()
ClassMethod CheckPrtFlagByGSPM(prtRowId As %String, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(groupId, hospId)
	quit:(+myGSRowID=0) 0
	
	set hasSelfPaym=0
	set flag=1
	set paymSub=""
	while($o(^DHCINVPRTZY(prtRowId,"P",paymSub),-1)&&(flag=1)) {
		set paymSub=$o(^DHCINVPRTZY(prtRowId,"P",paymSub),-1)
		set paymData=$g(^DHCINVPRTZY(prtRowId,"P",paymSub))
		continue:(paymData="")
		set paymDR=$p(paymData,"^",1)
		set insuFlag=$p(paymData,"^",9)
		continue:(insuFlag="Y")    //过滤医保支付方式
		set hasSelfPaym=1
		set myGSPMRowID=$o(^DHCOPGSi("GS",0,"CTPMDR",paymDR,myGSRowID,"PM",0))
		if (+myGSPMRowID=0) {
			set flag=0
			quit
		}
		set myGSPMINVPrtFlag=$p($g(^DHCOPGS("GS",myGSRowID,"PM",myGSPMRowID)),"^",5)
		if (myGSPMINVPrtFlag="Y") {
			set flag=0
			quit
		}
	}
	
	set prtFlag=((hasSelfPaym=1)&&(flag=1))
	
	quit prtFlag
}

/// Creator: ZhYW
/// CreatDate: 2020-06-06
/// Description: 判断是否欠费结算
/// Input: billId:DHC_PatientBill.RowId
/// Return: =1:欠费结算, =0:非欠费结算
/// Debug: w ##class(web.UDHCJFPAY).IsQFCharge(356)
ClassMethod IsQFCharge(billId As %String) As %String
{
	set rowId=$o(^DHCJFQFTOTAL(0,"Pbdr",billId,0))
	set flag=$s((rowId'=""):$p($g(^DHCJFQFTOTAL(rowId)),"^",5),1:"")
	quit (flag="Q")
}

/// Creator: ZhYW
/// CreatDate: 2020-12-25
/// Description: 结算/取消结算时修改就诊表财务结算状态
/// Input: adm:PA_Adm.RowId, flag: 是否财务结算("Y"/"N"), expStr:CT_Hospital.RowId^
/// Return: =0:更新成功, <>0:更新失败
/// Debug: w ##class(web.UDHCJFPAY).UpdateAdmBilled(356)
ClassMethod UpdateAdmBilled(adm As %String, flag As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	set hospId=$p(expStr,"^",1)
	
	set rtn=0
	ts
	
	set rtn=##class(web.UDHCJFPAY).UpdateAdmBillFlag(adm, flag)
	if (+rtn) tro  quit rtn
	
	set conf=##class(web.DHCBillCommon).GetTarParaId(hospId)
	set newBornToMother=$s((+conf'=0):$p($g(^DHCTarC("CF",conf)),"^",5),1:"")
	if (newBornToMother="Y") {
		set babyAdm=0
		while($o(^PAADMi("Mother",adm,babyAdm))&&(rtn=0)) {
			set babyAdm=$o(^PAADMi("Mother",adm,babyAdm))
			set rtn=..UpdateAdmBillFlag(babyAdm, flag)
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2020-12-25
/// Description: 修改就诊表财务结算状态
/// Input: adm:PA_Adm.RowId, flag: 是否财务结算("Y"/"N")
/// Return: =0:更新成功, <>0:更新失败
/// Debug: w ##class(web.UDHCJFPAY).UpdateAdmBillFlag(356)
ClassMethod UpdateAdmBillFlag(adm As %String, flag As %String) As %String
{
	quit:(+adm=0) -1_"^"_"参数错误"
	&SQL(
		UPDATE PA_Adm
		SET PAADM_BillFlag = :flag
		WHERE %ID = :adm
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2021-01-29
/// Description: 校验账单是否平衡
/// Input: bill:DHC_PatientBill.RowId
/// Return: =0:平, <>0:不平
/// Debug: w ##class(web.UDHCJFPAY).IsBillBalance(356)
ClassMethod IsBillBalance(bill As %String) As %String
{
	set rtn=0
	quit:(+bill=0) rtn
	set pbData=$g(^DHCPB(bill))
	set pbAmt=$p(pbData,"^",8)
	set pbAmt=$fn(pbAmt,"",2)
	set pbDiscAmt=$p(pbData,"^",9)
	set pbDiscAmt=$fn(pbDiscAmt,"",2)
	set pbPayOrAmt=$p(pbData,"^",11)
	set pbPayOrAmt=$fn(pbPayOrAmt,"",2)
	set pbPatAmt=$p(pbData,"^",12)
	set pbPatAmt=$fn(pbPatAmt,"",2)
	set (pboSum, pboDiscSum, pboPayOrSum, pboPatSum)=0
	set pbo=0
	while($o(^DHCPB(bill,"O",pbo))&&(rtn=0)) {
		set pbo=$o(^DHCPB(bill,"O",pbo))
		set pboData=$g(^DHCPB(bill,"O",pbo))
		continue:(pboData="")
		set pboAmt=$p(pboData,"^",8)
		set pboAmt=$fn(pboAmt,"",2)
		set pboSum=$i(pboSum,pboAmt)
		set pboDiscAmt=$p(pboData,"^",9)
		set pboDiscAmt=$fn(pboDiscAmt,"",2)
		set pboDiscSum=$i(pboDiscSum,pboDiscAmt)
		set pboPayOrAmt=$p(pboData,"^",10)
		set pboPayOrAmt=$fn(pboPayOrAmt,"",2)
		set pboPayOrSum=$i(pboPayOrSum,pboPayOrAmt)
		set pboPatAmt=$p(pboData,"^",11)
		set pboPatAmt=$fn(pboPatAmt,"",2)
		set pboPatSum=$i(pboPatSum,pboPatAmt)
		set (pbdSum, pbdDiscSum, pbdPayOrSum, pbdPatSum)=0
		set pbd=0
		while($o(^DHCPB(bill,"O",pbo,"D",pbd))&&(rtn=0)) {
			set pbd=$o(^DHCPB(bill,"O",pbo,"D",pbd))
			set pbdData=$g(^DHCPB(bill,"O",pbo,"D",pbd))
			continue:(pbdData="")
			set pbdAmt=$p(pbdData,"^",7)
			set pbdAmt=$fn(pbdAmt,"",2)
			set pbdSum=$i(pbdSum,pbdAmt)
			set pbdDiscAmt=$p(pbdData,"^",8)
			set pbdDiscAmt=$fn(pbdDiscAmt,"",2)
			set pbdDiscSum=$i(pbdDiscSum,pbdDiscAmt)
			set pbdPayOrAmt=$p(pbdData,"^",9)
			set pbdPayOrAmt=$fn(pbdPayOrAmt,"",2)
			set pbdPayOrSum=$i(pbdPayOrSum,pbdPayOrAmt)
			set pbdPatAmt=$p(pbdData,"^",10)
			set pbdPatAmt=$fn(pbdPatAmt,"",2)
			set pbdPatSum=$i(pbdPatSum,pbdPatAmt)
		}
		if ((+pboAmt'=+pbdSum)||(+pboDiscAmt'=+pbdDiscSum)||(+pboPayOrAmt'=+pbdPayOrSum)||(+pboPatAmt'=+pbdPatSum)) {
			set rtn=-1_"^"_"账单表金额不平"
			quit
		}
	}
	quit:(+rtn) rtn
	
	if ((+pbAmt'=+pboSum)||(+pbDiscAmt'=+pboDiscSum)||(+pbPayOrAmt'=+pboPayOrSum)||(+pbPatAmt'=+pboPatSum)) {
		set rtn=-1_"^"_"账单表金额不平"
	}

    quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-03-15
/// Description: 判断待插入的发票号是否被使用
/// Input: receiptNo:发票号, hospId:CT_Hospital.RowId,
/// Return: =0:否, <>0:是
/// Debug: w ##class(web.UDHCJFPAY).CheckInvIsRepeat("000001","2")
ClassMethod CheckInvIsRepeat(receiptNo As %String, hospId As %String) As %String
{
	set rtn=0
	quit:(receiptNo="") rtn
	
	set prtRowId=0
	while($o(^DHCINVPRTZY(0,"INV",receiptNo,prtRowId))) {
		set prtRowId=$o(^DHCINVPRTZY(0,"INV",receiptNo,prtRowId))
		set prtData=$g(^DHCINVPRTZY(prtRowId))
		set hospDR=$p(prtData,"^",35)
		continue:(hospDR'=hospId)
		set rtn=-1_"^"_"发票号"_receiptNo_"已被使用"
		quit
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-10-09
/// Description: 是否允许中途结算
/// Input: hospId:CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.UDHCJFPAY).IsAllowedIntPay(2)
ClassMethod IsAllowedIntPay(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPChrg.SFYXZTJS", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2023-03-24
/// Description: 修改押金表参与结算状态
/// Input: depRowId:dhc_sfprintdetail.RowId, isPayed:是否参与结算状态(N:否,Y:是)
/// Return: =0:更新成功, <>0:更新失败
/// Debug: w ##class(web.UDHCJFPAY).UpdtDepPayedFlag(356, "Y")
ClassMethod UpdtDepPayedFlag(depRowId As %String, isPayed As %String) As %String
{
	quit:(+depRowId=0) -1_"^"_"参数错误"
	&SQL(
		UPDATE dhc_sfprintdetail
		SET prt_paidflag = :isPayed
		WHERE %ID = :depRowId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

}
