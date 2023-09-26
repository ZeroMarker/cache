Import SQLUser

Class web.UDHCINVPRT Extends BILL.COM.Abstract
{

/// Description: 取消票据的审批
/// Debug: w ##class(web.UDHCINVPRT).CancleINVAudit("277","")
ClassMethod CancleINVAudit(PRTRowID As %String, ExpStr As %String) As %String
{
	set rtn=0
	
	&SQL(
		UPDATE DHC_INVPRT
		SET PRT_AllowRefund = NULL, PRT_AllRefundUser = NULL, PRT_AllRefundDate = NULL, PRT_AllRefundTime = NULL, PRT_RefundReason = NULL,
			PRT_RefAuditLoc_DR = NULL
		WHERE %ID = :PRTRowID
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

/// Description: 撤销新发票标志
/// Debug: w ##class(web.UDHCINVPRT).CancleNewPRTINVStatus("283")
ClassMethod CancleNewPRTINVStatus(PRTRowID As %String) As %String
{
	set $zt="ERROR"
	
	&SQL(
		UPDATE DHC_INVPRT
		SET PRT_OldINV_DR = NULL
		WHERE %ID = :PRTRowID
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn

ERROR
	quit ..AppException()
}

/// Debug: w ##class(web.UDHCINVPRT).INVPRT()
ClassMethod INVPRT(invInfo As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set userId=$p(invInfo,"^",9)
	set footUserId=$p(invInfo,"^",29)
	
	set invPrtObj=##class(User.DHCINVPRT).%New()
	set invPrtObj.PRTAcount=$p(invInfo,"^",1)
	do invPrtObj.PRTARRCPDRSetObjectId($p(invInfo,"^",2))
	set invPrtObj.PRTDate=$p(invInfo,"^",3)
	set invPrtObj.PRTFlag=$p(invInfo,"^",4)
	do invPrtObj.PRTPAPMIDRSetObjectId($p(invInfo,"^",5))
	set invPrtObj.PRTUseINVType=$p(invInfo,"^",6)
	do invPrtObj.PRTSocialStatusSetObjectId($p(invInfo,"^",7))
	set invPrtObj.PRTTime=$p(invInfo,"^",8)
	do invPrtObj.PRTUsrSetObjectId($s((+footUserId=0):userId,1:footUserId))   //+2023-03-17 ZhYW
	set invPrtObj.PRTinv=$p(invInfo,"^",10)
	set invPrtObj.PRTPayorShare=$p(invInfo,"^",11)
	set invPrtObj.PRTDiscAmount=$p(invInfo,"^",12)
	set invPrtObj.PRTPatientShare=$p(invInfo,"^",13)
	do invPrtObj.PRTInsTypeDRSetObjectId($p(invInfo,"^",14))
	do invPrtObj.PRTOldINVDRSetObjectId($p(invInfo,"^",15))
	set invPrtObj.PRTINVPrintFlag=$p(invInfo,"^",16)
	set invPrtObj.PRTFairType=$p(invInfo,"^",17)
	set invPrtObj.PRTOPPreSum=$p(invInfo,"^",18)
	set invPrtObj.PRTOPBackChange=$p(invInfo,"^",19)
	set invPrtObj.PRTOPCRoundErr=$p(invInfo,"^",20)
	set invPrtObj.PRTSubAvailHospDR=$p(invInfo,"^",21)
	do invPrtObj.PRTHospitalDRSetObjectId($p(invInfo,"^",22))
	do invPrtObj.PRTGroupDRSetObjectId($p(invInfo,"^",23))
	set invPrtObj.PRTIPAddress=$p(invInfo,"^",24)
	set invPrtObj.PRTStayFlag=$p(invInfo,"^",25)
	do invPrtObj.PRTPrePayUserDRSetObjectId($p(invInfo,"^",26))
	set invPrtObj.PRTPrePayDate=$p(invInfo,"^",27)
	set invPrtObj.PRTPrePayTime=$p(invInfo,"^",28)
	do invPrtObj.PRTRealUserDRSetObjectId(userId)
	set sc=invPrtObj.%Save()
	do invPrtObj.%Close()
	if $$$ISERR(sc) {
		set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
		quit rtn
	}
	set prtRowId=invPrtObj.%Id()
	
	quit rtn_"^"_prtRowId

ERROR
	quit ..AppException()
}

/// Description: 生成负票
/// Debug: w ##class(web.UDHCINVPRT).INVPRTCancel("283","5","")
ClassMethod INVPRTCancel(INVPRTRowid As %String, UserId As %String, sFlag As %String, CurDate As %String, CurTime As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	
	set groupId=$p(ExpStr,"^",1)
	set ctLocId=$p(ExpStr,"^",2)
	set hospId=$p(ExpStr,"^",3)
	set refundInvFlag=$p(ExpStr,"^",4)
	set printInvFlag=$p(ExpStr,"^",5)
	
	set PrtInvData=$g(^DHCINVPRT(INVPRTRowid))
	set PAPMIDR=$p(PrtInvData,"^",15)
	set myUseINVType=$p(PrtInvData,"^",17)
	set InsType=$p(PrtInvData,"^",9)
	set myFairType=$p(PrtInvData,"^",34)		   //PRT_FairType
	
	set myReceiptId="", myReceipNO="", myINVPreABC=""
    set prtInvFlag=##class(web.DHCBillConsIF).CheckPrtFlag(InsType, groupId, hospId, printInvFlag)
	if ((+prtInvFlag=0)&&(refundInvFlag="Y")) {
		&SQL(
			SELECT TOP 1 %ID, INV_LastNum, INV_title INTO :myReceiptId, :myReceipNO, :myINVPreABC
			FROM DHC_INVOICE
			WHERE INV_Usr = :UserId AND INV_Finalflag = 'Y' AND INV_type = :myUseINVType AND INV_hospital = :hospId
			ORDER BY %ID
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
		
		//更新发票发放表
		set ReceipNew=+myReceipNO+1
		set rtn=##class(web.udhcOPBill).UpdateReceipNO(UserId, ReceipNew, groupId, myFairType, InsType, hospId)
		quit:(+rtn) rtn
	}
	
	/*
	set BuissNo=""
	if (hospId'="") {
		set HospNo=$p(^CT("HOSP",hospId),"^",1)
		set BuissNo=##class(web.UDHCJFCOMMON).BuildHospInvID(HospNo, "O")
	}
    */
    
    set invPrtObj=##class(User.DHCINVPRT).%OpenId(INVPRTRowid, 0)
    do invPrtObj.%Close()
    if ('$isObject(invPrtObj)) {
	    quit -1_"^"_"创建对象失败"
	}
    set newInvPrtObj=##class(User.DHCINVPRT).%New()
    set newInvPrtObj.PRTAcount=-invPrtObj.PRTAcount
    do newInvPrtObj.PRTARRCPDRSetObjectId(invPrtObj.PRTARRCPDRGetObjectId())
    set newInvPrtObj.PRTDate=CurDate
    set newInvPrtObj.PRTFlag=sFlag
    do newInvPrtObj.PRTinitInvDRSetObjectId(INVPRTRowid)
    set newInvPrtObj.PRTinv=myINVPreABC_myReceipNO
    do newInvPrtObj.PRTPAPMIDRSetObjectId(invPrtObj.PRTPAPMIDRGetObjectId())
    set newInvPrtObj.PRTUseINVType=invPrtObj.PRTUseINVType
    set newInvPrtObj.PRTTime=CurTime
    do newInvPrtObj.PRTUsrSetObjectId(UserId)
    set newInvPrtObj.PRTINVPrintFlag=invPrtObj.PRTINVPrintFlag
    set newInvPrtObj.PRTPayorShare=-invPrtObj.PRTPayorShare
    set newInvPrtObj.PRTDiscAmount=-invPrtObj.PRTDiscAmount
    set newInvPrtObj.PRTPatientShare=-invPrtObj.PRTPatientShare
    do newInvPrtObj.PRTInsTypeDRSetObjectId(InsType)
    set newInvPrtObj.PRTYBPaySum=-invPrtObj.PRTYBPaySum
    set newInvPrtObj.PRTFairType=invPrtObj.PRTFairType
    set newInvPrtObj.PRTOPCRoundErr=-invPrtObj.PRTOPCRoundErr
    set newInvPrtObj.PRTSubAvailHospDR=invPrtObj.PRTSubAvailHospDR
    do newInvPrtObj.PRTHospitalDRSetObjectId(hospId)
    do newInvPrtObj.PRTGroupDRSetObjectId(groupId)
    set newInvPrtObj.PRTIPAddress=$system.Process.ClientIPAddress()
    set newInvPrtObj.PRTStayFlag=invPrtObj.PRTStayFlag
    do newInvPrtObj.PRTRealUserDRSetObjectId(UserId)
    set sc=newInvPrtObj.%Save()
	do newInvPrtObj.%Close()
	if $$$ISERR(sc) {
		set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
		quit rtn
	}
    set strikeRowId=newInvPrtObj.%Id()
	
	//2021-04-08 ZhYW 保存发票扩展表数据
	set payer=$p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	set payerID=$p($g(^PAPER(PAPMIDR,"ALL")),"^",9)     //身份证号
	set dto=##class(BILL.INV.DTO.Entity.PrtExt).%New()
	set dto.InvType="O"
	set dto.InvDR=strikeRowId
	set dto.BatchNo=myINVPreABC
	set dto.InvNo=myReceipNO
	set dto.PAPMIDR=PAPMIDR
	set dto.Payer=payer
	set dto.PayerIdentifier=payerID
	set dto.UserDR=UserId
	set dto.Reviewer=""
	set dto.InvoiceDR=myReceiptId
	set rtnValue=##class(BILL.INV.BL.PrtExt).Save(dto)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	
	quit rtn_"^"_strikeRowId

ERROR
	quit ..AppException()
}

/// Description: 作废原票据
/// Debug: w ##class(web.UDHCINVPRT).INVPRTPark("283","5","S")
ClassMethod INVPRTPark(INVPRTRowid As %String, UserId As %String, sFlag As %String) As %String
{
	set $zt="ERROR"
	
	&SQL(
		UPDATE DHC_INVPRT
		SET PRT_Flag=:sFlag
		WHERE %ID = :INVPRTRowid
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	
	//add  by zhl 2011-07-04 欠费发票退费时原欠费记录也作废
	set QFInvDR=$o(^DHCOPQFPatInfo(0,"InvPrt",INVPRTRowid,0))
	if (QFInvDR'="") {
		set QFFlag=$p(^DHCOPQFPatInfo(QFInvDR),"^",7)
		if (QFFlag'="Restore") {
			&SQL(
				UPDATE DHC_OPQFPatTotal
				SET QF_Status=:sFlag
				WHERE %ID = :QFInvDR
			)
			set rtn=SQLCODE
			quit:(+rtn) rtn_"^"_$g(%msg)
		}
	}
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Description: 对应的负票生成负的支付方式
/// Input: OldINVRowID: 原废单号码, ParkINVRowID: 负单号码, AccPLDR: 卡账户支付的RowID, PayModeDR: 支付方式RowID
/// Debug: w ##class(web.UDHCINVPRT).INVPRTPayModeCancel("51046","51059","693","","10033","")
ClassMethod INVPRTPayModeCancel(OldINVRowID As %String, ParkINVRowID As %String, PayRecLocDR As %String, PayModeDR As %String, UserDR As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set myCurDate=$p(ExpStr,"^",1)
	set myCurTime=$p(ExpStr,"^",2)
	set refundFlag=$p(ExpStr,"^",3)   //refundFlag(0:全退, 1:部分退, 2:作废重打)
	set MulityPMFlag=$p(ExpStr,"^",4)
	
	set PrtInvData=$g(^DHCINVPRT(ParkINVRowID))
	set InsTypeDR=$p(PrtInvData,"^",9)
	set PAPMIDR=$p(PrtInvData,"^",15)
	set PatientNo=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
	set HospId=$p(PrtInvData,"^",39)
	set GroupId=$p(PrtInvData,"^",41)    //PRT_Group_DR +2022-09-01 ZhYW
	
	set mySub=0
	while($o(^DHCINVPRT(OldINVRowID,"P",mySub))) {
		set mySub=$o(^DHCINVPRT(OldINVRowID,"P",mySub))
		set myPMData=$g(^DHCINVPRT(OldINVRowID,"P",mySub))
		continue:(myPMData="")
		set myINVPMRowID=OldINVRowID_"||"_mySub
		set myCTPMDR=$p(myPMData,"^",1)
		set myPayMAmt=$p(myPMData,"^",3)
		set myPayCard=$p(myPMData,"^",5)      //+2022-08-22 ZhYW 支付卡号
		set myAccPLDR=$p(myPMData,"^",8)
		set myAccMRowId=+myAccPLDR
		set isSelfPayM=+$p(myPMData,"^",12)	  //是否自费支付方式(1:自费, 0:医保)
		set myEPayLDR=$p(myPMData,"^",14)
		set myEPMRowId=+myEPayLDR
		set myCTPMCode=$p($g(^CT("CTPM",myCTPMDR)),"^",1)
		if (+PayModeDR'=0) {
			/*
			//2023-03-22 ZhYW 注释
			set PayModeCode=$p($g(^CT("CTPM",PayModeDR)),"^",1)  //+2022-10-11 ZhYW 传入支付方式的代码
			//2022-10-11 ZhYW 个人帐户办理结算后退费时，也只能是退现金
			if (($zcvt(PayModeCode,"U")="CASH")&&(" CPP ECPP "[(" "_myCTPMCode_" "))) {
				//如果是卡支付，强制为传入的支付模式，防止个人帐户办理结算后退费
				set myCTPMDR=PayModeDR
			}
			*/
			if ((+refundFlag'=2)&&(isSelfPayM=1)&&(MulityPMFlag'="Y")) {
				set myCTPMDR=PayModeDR       //全退或部分退费且非医保支付
			}
		}
		set myCTPMCode=$p($g(^CT("CTPM",myCTPMDR)),"^",1)
		//+2022-11-01 ZhYW 判断第三方支付的门诊收费是否允许原路退
		if ((+refundFlag'=2)&&(isSelfPayM=1)) {
			set rtnValue=..IsAllowedInitModeToRefund(myINVPMRowID, myCTPMDR)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
		}
		set myParkAccPLDR=""
		set myParkEPayLDR=""
		if ($zcvt(myCTPMCode,"U")="CPP") {
			//利用卡支付的，需要往账户中返款
			set $p(myAPLInfo,"^",1)=myAccMRowId		       //AccManRef
			set $p(myAPLInfo,"^",2)=PAPMIDR			       //PAPMIDR
			set $p(myAPLInfo,"^",3)=ParkINVRowID           //InvPrtDR
			set $p(myAPLInfo,"^",4)=PatientNo		       //PAPMINo
			set $p(myAPLInfo,"^",5)="OP"		           //业务类型
			set $p(myAPLInfo,"^",6)=UserDR		           //UserDR
			set $p(myAPLInfo,"^",7)=myCurDate	           //PayDate
			set $p(myAPLInfo,"^",8)=myCurTime	           //PayTime
			set $p(myAPLInfo,"^",9)=-myPayMAmt		       //PayNum
			set $p(myAPLInfo,"^",10)=PayRecLocDR		   //PayRecLoc_DR
			set $p(myAPLInfo,"^",11)=InsTypeDR
			set $p(myAPLInfo,"^",12)=""                    //预留字段
			set $p(myAPLInfo,"^",13)=HospId	           //2019-12-31 ZhYW
			set rtnValue=##class(web.UDHCACPayList).INSPayInfo(myAccMRowId, myAPLInfo)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
			set myParkAccPLDR=$p(rtnValue,"^",2)
		}
		if ($zcvt(myCTPMCode,"U")="ECPP") {
			//往留观账户中返款
			set $p(myAPLInfo,"^",1)=myEPMRowId
			set $p(myAPLInfo,"^",2)=PAPMIDR
			set $p(myAPLInfo,"^",3)=ParkINVRowID
			set $p(myAPLInfo,"^",4)=PatientNo
			set $p(myAPLInfo,"^",5)=""
			set $p(myAPLInfo,"^",6)=UserDR
			set $p(myAPLInfo,"^",7)=myCurDate
			set $p(myAPLInfo,"^",8)=myCurTime
			set $p(myAPLInfo,"^",9)=-myPayMAmt
			set $p(myAPLInfo,"^",10)=PayRecLocDR
			set $p(myAPLInfo,"^",11)=InsTypeDR
			set $p(myAPLInfo,"^",12)=""                 //预留字段
			set $p(myAPLInfo,"^",13)=HospId	            //2019-12-31 ZhYW
			set rtnValue=##class(web.DHCOPBillEPManageCLS).INSPayInfo(myEPMRowId, myAPLInfo)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
			set myParkEPayLDR=$p(rtnValue,"^",2)
		}
		//2022-08-22 ZhYW 退体检代金卡、体检预交金
		if (" TJYJJ TJDJK "[(" "_$zcvt(myCTPMCode,"U")_" ")) {
			set cardNo=$s(($zcvt(myCTPMCode,"U")="TJYJJ"):PatientNo,1:myPayCard)  //体检预缴金时，卡号传登记号
			set sessionStr=UserDR_"^"_GroupId_"^"_PayRecLocDR
			set rtnValue=##class(web.DHCBillCons12).UpdateAPAmount(OldINVRowID, ParkINVRowID, myCTPMCode, -myPayMAmt, cardNo, sessionStr)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
		}
		//插入负票支付方式
		set myPMObj=##class(User.DHCINVPayMode).%OpenId(myINVPMRowID, 0)
		do myPMObj.%Close()
		set myNewPMObj=##class(User.DHCINVPayMode).%New(ParkINVRowID)
		set myNewSub=myNewPMObj.IPMSub
		set myNewPMObj=myPMObj.%ConstructClone(-1)
		set myNewPMObj.IPMSub=myNewSub
		do myNewPMObj.IPMPRTParRefSetObjectId(ParkINVRowID)
		do myNewPMObj.IPMPayModeDRSetObjectId(myCTPMDR)
		set myNewPMObj.IPMAmt=-myPayMAmt
		set myNewPMObj.IPMDate=myCurDate
		set myNewPMObj.IPMTime=myCurTime
		do myNewPMObj.IPMAccPLDRSetObjectId(myParkAccPLDR)
		do myNewPMObj.IPMEPayLDRSetObjectId(myParkEPayLDR)
		do myNewPMObj.IPMETPDRSetObjectId("")
		set sc=myNewPMObj.%Save()
		do myNewPMObj.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Description: 增加门诊发票的支付信息
/// Debug: w ##class(web.UDHCINVPRT).INVPRTPayMode("1368","1^1^100^Cheque1111^1^^^03/07/2006^122222")
ClassMethod INVPRTPayMode(INVRowID As %String, PMInfo As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set invPMObj=##class(User.DHCINVPayMode).%New(INVRowID)
	do invPMObj.IPMPRTParRefSetObjectId(INVRowID)
	do invPMObj.IPMPayModeDRSetObjectId($p(PMInfo,"^",1))
	do invPMObj.IPMCMBankDRSetObjectId($p(PMInfo,"^",2))
	set invPMObj.IPMAmt=$p(PMInfo,"^",3)
	set invPMObj.IPMCardChequeNo=$p(PMInfo,"^",4)
	set invPMObj.IPMCardDR=$p(PMInfo,"^",5)
	set invPMObj.IPMDate=$p(PMInfo,"^",10)
	set invPMObj.IPMTime=$p(PMInfo,"^",11)
	do invPMObj.IPMAccPLDRSetObjectId($p(PMInfo,"^",6))
	do invPMObj.IPMUnitDRSetObjectId($p(PMInfo,"^",7))
	set invPMObj.IPMPayAccNO=$p(PMInfo,"^",9)
	set myChequDate=$p(PMInfo,"^",8)
	set myChequDate=##class(websys.Conversions).DateHtmlToLogical(myChequDate)
	set invPMObj.IPMChequeDate=myChequDate
	set invPMObj.IPMNote3=1     //是否自费支付方式标识
	do invPMObj.IPMETPDRSetObjectId($p(PMInfo,"^",12))
	set sc=invPMObj.%Save()
	do invPMObj.%Close()
	if $$$ISERR(sc) {
		set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
		quit rtn
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Description: 读取各种支付模式下支付金额
/// Debug: w ##class(web.UDHCINVPRT).ReadINVPMStr("12")
ClassMethod ReadINVPMStr(INVRowID As %String) As %String
{
	set rtn=0
	quit:(INVRowID="") rtn
	
	set myPMStr=""
	
	set Sub=""
	while($o(^DHCINVPRT(INVRowID,"P",Sub),-1)) {
		set Sub=$o(^DHCINVPRT(INVRowID,"P",Sub),-1)
		set myPMData=$g(^DHCINVPRT(INVRowID,"P",Sub))
		continue:(myPMData="")
		set myPMNote=$p(myPMData,"^",12)
		continue:(+myPMNote'=1)     //过滤医保支付方式
		set myPMDR=$p(myPMData,"^",1)
		set myPMSum=$p(myPMData,"^",3)
		set myPMStr=myPMDR_"^"_myPMSum
		quit
	}
	
	if (myPMDR="") {
		set myPMSum=$p(^DHCINVPRT(INVRowID),"^",16)
		set ctpayrid=0
		while($o(^CT("CTPM",ctpayrid))) {
			set ctpayrid=$o(^CT("CTPM",ctpayrid))
			set myPMCode=$p(^CT("CTPM",ctpayrid),"^",1)
			if (myPMCode="CASH") {
				set myPMStr=ctpayrid_"^"_myPMSum
				quit
			}
		}
	}
	
	quit myPMStr
}

/// Description: 获取发票的支付模式，如果没有支付模式取现金的rowID
/// Debug: w ##class(web.UDHCINVPRT).ReadINVPayMode(9296)
ClassMethod ReadINVPayMode(INVRowID As %String = "") As %String
{
	set PayInfo=""
	set myPMDR=""
	set Sub=""
	while($o(^DHCINVPRT(INVRowID,"P",Sub),-1)) {
		set Sub=$o(^DHCINVPRT(INVRowID,"P",Sub),-1)
		set myPMData=$g(^DHCINVPRT(INVRowID,"P",Sub))
		continue:(myPMData="")
		set myPMNote=$p(myPMData,"^",12)
		continue:(+myPMNote'=1)     //过滤医保支付方式
		set myPMDR=$p(myPMData,"^",1)
		set myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
		set myAccPLDR=$p(myPMData,"^",8)
		if (myPMCode="ECPP") {
			set myAccPLDR=$p(myPMData,"^",14)
		}
		set myBankDR=$p(myPMData,"^",2)
		set myCheqNo=$p(myPMData,"^",4)
		set PatUnit=$p(myPMData,"^",9)
		set ChequeDate=$p(myPMData,"^",11)
		if (ChequeDate'="") set ChequeDate=##class(websys.Conversions).DateLogicalToHtml(ChequeDate)
		set PayInfo=myPMDR_"^"_myBankDR_"^"_myCheqNo_"^^"_PatUnit_"^"_ChequeDate_$c(2)_myAccPLDR
	}
	
	if (myPMDR="") {
		set ctpayrid=0
		while($o(^CT("CTPM",ctpayrid))) {
			set ctpayrid=$o(^CT("CTPM",ctpayrid))
			set myPMCode=$p(^CT("CTPM",ctpayrid),"^",1)
			if (myPMCode="CASH") {
				set PayInfo=ctpayrid_"^^^^"_$c(2)_""
				quit
			}
		}
	}
	
	quit PayInfo
}

/// Description: 对于卡支付的DHC_INVPRT记录，统一进行结算
/// Debug: w ##class(web.UDHCINVPRT).UpdateFootByCard()
ClassMethod UpdateFootByCard(StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, INVRepRef As %String, HDate As %String, HTime As %String, HospId As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set myDate=StDate-1
	while($o(^DHCINVPRT(0,"Date",myDate))) {
		set myDate=$o(^DHCINVPRT(0,"Date",myDate))
		quit:(+myDate>+EndDate)     //大于结束日期时退出循环
		set myPrtRowID=0
		while($o(^DHCINVPRT(0,"Date",myDate,myPrtRowID))) {
			set myPrtRowID=$o(^DHCINVPRT(0,"Date",myDate,myPrtRowID))
			set myPrtData=$g(^DHCINVPRT(myPrtRowID))
			set myHospDR=$p(myPrtData,"^",39)
			continue:((HospId'="")&&(HospId'=myHospDR))
			set myPrtFlag=$p(myPrtData,"^",8)
			continue:(myPrtFlag="TP")
			set myHandin=$p(myPrtData,"^",10)
			continue:(myHandin="Y")
			set myTime=$p(myPrtData,"^",20)
			continue:((myDate=StDate)&&(myTime<StTime))
			continue:((myDate=EndDate)&&(myTime>EndTime))
			set myUser=$p(myPrtData,"^",21)
			set isCashier=##class(web.UDHCJFBaseCommon).CheckISCashier(myUser, myHospDR)
			continue:(+isCashier=0)               //+2017-05-31 ZhYW 收费员退出
			set myCKPRTNO=##class(web.UDHCINVPRT).CheckCPPPRTNO(myPrtRowID)
			set myPRTNo=$p(myCKPRTNO,"^",1)
			continue:(myPRTNo'="")			    //如果打印发票退出
			&SQL(
				UPDATE DHC_INVPRT
				SET PRT_DHCINVPRTR_DR = :INVRepRef, PRT_Handin = 'Y', PRT_HandinDate = :HDate, PRT_HandinTime = :HTime
				WHERE %ID = :myPrtRowID
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Description: 更新发票打印标志
/// Input: INVPrtRStr:DHC_INVPRT.RowID串
///   		APayINVRowID:DHC_AccPayInv.RowID
/// Debug: w ##class(web.UDHCINVPRT).UpdatePrtFlag()
ClassMethod UpdatePrtFlag(INVPrtRStr As %String, APayINVRowID As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	set mylen=$l(INVPrtRStr,"^")
	for i=1:1:mylen {
		set myINVRowID=$p(INVPrtRStr,"^",i)
		continue:(myINVRowID="")
		&SQL(
			UPDATE DHC_INVPRT
			SET PRT_INVPrintFlag = 'P', PRT_ACCPINV_DR = :APayINVRowID
			WHERE %ID = :myINVRowID
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

/// Description: 判断是否打印发票  卡支付，退费
/// Debug: w ##class(web.UDHCINVPRT).CheckCPPPRTNO("1219")
ClassMethod CheckCPPPRTNO(PRTRowID As %String) As %String
{
	set rtn=""
	
	quit:(PRTRowID="") "^"
	
	set myPrtData=$g(^DHCINVPRT(PRTRowID))
	quit:(myPrtData="") "^"
	
	set myFlag=$p(myPrtData,"^",8)		    //PRT_Flag
	set myPRTDR=$p(myPrtData,"^",13)		//PRT_initInv_DR
	set myPRTNO=$p(myPrtData,"^",14)		//PRT_inv
	set myCurNo=myPRTNO
	set myOldPRTNO=""
	if (myPRTDR'="") {
		set myOldPRTNO=$p(^DHCINVPRT(myPRTDR),"^",14)   //PRT_inv
		set myCurNo=myOldPRTNO
	}
	set rtn=myCurNo_"^"_myFlag
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2011-04-02
/// Description: 判断是否为医保支付方式（建议定义支付方式Code时，有个规则）
/// Input: paymId:CT_PayMode.RowId
/// Return: 0:医保支付方式，1:非医保支付
/// Debug: w ##class(web.UDHCINVPRT).CheckYBPayMode(14)
ClassMethod CheckYBPayMode(paymId As %String) As %String
{
	set rtn=1
	set payMCode=$p(^CT("CTPM",paymId),"^",1)
	if (payMCode["YB") set rtn=0       //此处根据不同医院需要修改
	if (payMCode["INSU") set rtn=0
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-05-28
/// Description: 获取发票自费支付方式，如果没有默认现金
/// Input: prtRowId:DHC_INVPRT.RowId
/// Return: 支付方式信息，多个自费方式时用$c(3)分割
/// Debug: w ##class(web.UDHCINVPRT).ReadINVPayModeNew()
ClassMethod ReadINVPayModeNew(prtRowId As %String = "") As %String
{
	set payInfo=""
	quit:(+prtRowId=0) payInfo
	
	set prtData=$g(^DHCINVPRT(prtRowId))
	set prtOPCRoundErr=+$p(prtData,"^",37)
	
	set sub=""
	while($o(^DHCINVPRT(prtRowId,"P",sub),-1)) {
		set sub=$o(^DHCINVPRT(prtRowId,"P",sub),-1)
		set myPMData=$g(^DHCINVPRT(prtRowId,"P",sub))
		continue:(myPMData="")
		set myPMDR=$p(myPMData,"^",1)
		set myPMAmt=$p(myPMData,"^",3)
		set myPMAmt=$fn(myPMAmt,"",2)
		set myPMNote=$p(myPMData,"^",12)
		continue:(+myPMNote'=1)     //过滤医保支付方式
		set myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
		set invRoundErrDetails=""
		if (myPMCode="CASH") {
			set invRoundErrInfo=##class(web.DHCBillConsIF).GetManyInvRoundErrAmt(prtRowId, (myPMAmt-prtOPCRoundErr), myPMDR)
			set invRoundErrDetails=$p(invRoundErrInfo,"^",2)
		}
		set myAccPLDR=$p(myPMData,"^",8)
		if (myPMCode="ECPP") {
			set myAccPLDR=$p(myPMData,"^",14)
		}
		set myPayCard=$s((myAccPLDR'=""):+myAccPLDR,1:"")
		set myBankDR=$p(myPMData,"^",2)
		set myCheqNo=$p(myPMData,"^",4)
		set myUnitDR=$p(myPMData,"^",9)
		set myChequeDate=$p(myPMData,"^",11)
		if (myChequeDate'="") set myChequeDate=##class(websys.Conversions).DateLogicalToHtml(myChequeDate)
		set tmpStr=myPMDR_"^"_myBankDR_"^"_myCheqNo_"^"_myPayCard_"^"_myUnitDR_"^"_myChequeDate_"^^"_myPMAmt_"^"_invRoundErrDetails_"^^"
		set payInfo=$s((payInfo=""):tmpStr,1:(payInfo_$c(3)_tmpStr))
	}
	
	if (payInfo="") {
		set ctpayrid=0
		while($o(^CT("CTPM",ctpayrid))) {
			set ctpayrid=$o(^CT("CTPM",ctpayrid))
			set myPMCode=$p(^CT("CTPM",ctpayrid),"^",1)
			if (myPMCode="CASH") {
				set payInfo=ctpayrid_"^^^^^^^^^"
				quit
			}
		}
	}
	
	quit payInfo
}

/// Creator: ZhYW
/// CreatDate: 2020-06-29
/// Description: 根据小条RowID获取支付流水RowId
/// Input: prtRowId: DHC_INVPRT.RowId
/// Return: payListId: DHC_AccPayList.RowId / DHC_EPPayList.RowId
/// Debug: w ##class(web.UDHCINVPRT).GetPayListIDByInv("3851")
ClassMethod GetPayListIDByInv(prtRowId As %String) As %String
{
	set payListId=""
	quit:(+prtRowId=0) payListId
	
	set paymSub=""
	while($o(^DHCINVPRT(prtRowId,"P",paymSub),-1)&&(payListId="")) {
		set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub),-1)
		set paymData=$g(^DHCINVPRT(prtRowId,"P",paymSub))
		continue:(paymData="")
		set myPMNote=$p(paymData,"^",12)
		continue:(+myPMNote'=1)      //过滤医保支付方式
		set myAccPLDR=$p(paymData,"^",8)
		set myEPLDR=$p(paymData,"^",14)
		set payListId=$s((myAccPLDR'=""):myAccPLDR,(myEPLDR'=""):myEPLDR,1:"")   //支付流水
	}
	
	quit payListId
}

/// Creator: ZhYW
/// CreatDate: 2022-11-01
/// Description: 判断第三方支付的门诊收费是否允许原路退
/// Input: prtPMRowId: DHC_INVPayMode.RowId, refModeId:CT_PayMode.RowId(退费支付方式Id)
/// Return: 
/// Debug: w ##class(web.UDHCINVPRT).IsAllowedInitModeToRefund("5365||1", 47)
ClassMethod IsAllowedInitModeToRefund(prtPMRowId As %String, refModeId As %String, langId As %String = "") As %String
{
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rtn=0
	quit:(+prtPMRowId=0) -1_"^"_"参数错误"
	
	set hardComFlag=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(refModeId)
	quit:(+hardComFlag=0) rtn    //非第三方支付退款
	
	set prtRowId=+prtPMRowId
	set prtPMData=$g(^DHCINVPRT(prtRowId,"P",$p(prtPMRowId,"||",2)))
	set paymId=$p(prtPMData,"^",1)
	
	set prtInvData=$g(^DHCINVPRT(prtRowId))
	set hospId=$p(prtInvData,"^",39)    //PRT_Hospital_DR
	
	//增加了"REG"类型后，DHC_INVPRT.PRT_FairType和DHC_BillExtTradePay.ETP_TradeType存在不一致的情况
	set orgETPRowId=##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrtMode("OP", prtRowId, paymId)
	if (orgETPRowId="") {
		set orgETPRowId=##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrtMode("REG", prtRowId, paymId)
	}
	if ((+orgETPRowId=0)||(paymId'=refModeId)) {
		set paymDesc=$p($g(^CT("CTPM",paymId)),"^",2)
		set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
		set refmDesc=$s((+refModeId'=0):$p($g(^CT("CTPM",refModeId)),"^",2),1:"")
		set refmDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", refmDesc, langId)
		quit -1_"^"_"原记录为"_paymDesc_"支付，不能选择"_refmDesc_"退费"     //非第三方支付
	}

	set myETPData=$g(^DHCBILLETP(orgETPRowId))
	set myExtDate=$p(myETPData,"^",14)          //ETP_Ext_Date
	set timeoutDays=##class(BILL.Payment.COM.Method).GetRefTimeoutDays(paymId, hospId)  //退款超时天数
	set isTimeout=((+timeoutDays'=0)&&($system.SQL.DATEDIFF("dd", myExtDate, +$h)>timeoutDays))
	quit:(isTimeout=1) -1_"^"_"已经超过可退时限，只能选择现金退费"
	
	quit rtn
}

}
