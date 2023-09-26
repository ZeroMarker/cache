Import SQLUser

Class web.DHCOPBillEPAddDeposit Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.DHCOPBillEPAddDeposit).NewDeposit("3198^1176^^5^^","20.00^5^^^P^^2^","1^^^^^^^20^^^^","")
ClassMethod NewDeposit(AccInfo As %String, PDInfo As %String, PDPMInfo As %String, PartRefFlag As %String = "") As %String
{
	set ^TMP("NewDeposit")=$lb(AccInfo, PDInfo, PDPMInfo, PartRefFlag)
 	set rtn=0
 	
 	set adm=$p(AccInfo,"^",1)
	set rtnValue=##class(web.DHCOPBillEPManageCLS).getCurrAcountID(adm)
	set AccRowID=$p(rtnValue,"^",2)

	//判断是否是急诊留观病人
	set rtnValue=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(adm)
	set isStay=$p(rtnValue,"^",1)
	quit:(isStay'="Y") -1_"^"_"该患者非急诊留观患者"
	
 	set $zt="ERROR"
 	ts
 	
 	if (+AccRowID=0) {
	 	set rtnValue=##class(web.DHCOPBillEPManageCLS).AddNewAccount(AccInfo)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		set AccRowID=$p(rtnValue,"^",2)
	}
 	
 	set rtnValue=..AddDeposit(AccRowID, PDInfo, PDPMInfo, PartRefFlag)
 	set rtn=$p(rtnValue,"^",1)
 	if (+rtn) tro  quit rtnValue
 	
	if ($tl>0) tc
 	
	quit rtnValue

ERROR
	quit ..AppException()
}

ClassMethod AddDeposit(AccRowID As %String, PDInfo As %String, PDPMInfo As %String, PartRefFlag As %String = "") As %String
{
	set rtn=0

	quit:('$d(^DHCEPM("EPM",AccRowID))) -1_"^"_"账户有误"

	set PayAmt=+$p(PDInfo,"^",1)
	quit:(PayAmt'>0) -1_"^"_"金额有误"

	set UserId=$p(PDInfo,"^",2)
	set BackReason=$p(PDInfo,"^",3)
	//set Password=$p(PDInfo,"^",4)
 	set PDType=$p(PDInfo,"^",5)
 	set Remark=$p(PDInfo,"^",6)
	set HospId=$p(PDInfo,"^",7)
 	set InitPDRowId=$p(PDInfo,"^",8)
 	
	quit:(PartRefFlag'="Y")&&(PDType="R")&&(+InitPDRowId=0) -1_"^"_"原押金记录为空"
	
	if (PDType="R")&&(+InitPDRowId'=0)&&(PartRefFlag="N") {
		quit:$d(^DHCEPMi("EPM",0,"InitDR",InitPDRowId)) -1_"^"_"押金已退，不能重复退"
	}

 	if (PDType="R") {
	 	set PayAmt=-PayAmt
	}
 	set leftAmt=$p(^DHCEPM("EPM",AccRowID),"^",9)
 	quit:((PDType="R")&&(leftAmt+PayAmt<0)) -1_"^"_"余额不足"
 	
	lock +^DHCEPM("EPM",AccRowID):0  else  quit "-110^留观账户被锁定（账户Id："_AccRowID_")."
	set rtnValue=..UpdateAM(AccRowID, PayAmt)
	lock -^DHCEPM("EPM",AccRowID)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set myLeft=$p(rtnValue,"^",2)
	
	//获取留观押金收据号
	set ReceiptType=##class(web.DHCOPConfig).GetPreReceiptType(HospId)
	set ReceiptsNo=""
	if (ReceiptType="") {
		set ReceiptsNo=..GetBuildPDNo(PDType, UserId, "")
	}else {
		set rtnValue=..UpdatePDReceipts(UserId, ReceiptType, HospId)
		set rtn=$p(rtnValue,"^",1)
		quit:(+rtn) rtnValue
		set ReceiptsNo=$p(rtnValue,"^",2)
	}
	
	set Status=""
	if (PDType="R") {
		//如果全退 status 插入3 原记录4
		if ((+InitPDRowId'=0)&&(PartRefFlag="N")) {
		 	set Status=3
		 	//更新原记录状态
		 	&SQL(
				UPDATE DHC_EPPreDeposit
				SET EPMD_Status = '4'
				WHERE EPMD_RowID = :InitPDRowId
			)
			set rtn=SQLCODE
			quit:(+rtn) +rtn_"^"_$g(%msg)
	 	}
	 	//如果是部分退 status插入1
	 	if ((+InitPDRowId=0)&&(PartRefFlag'="N")) {
		 	set Status=1
	 	}
	}
 	
 	set ClientIPAddress=$system.Process.ClientIPAddress()    //客户端IP
 	
	&SQL(
		INSERT INTO DHC_EPPreDeposit(
			EPMD_ParRef, EPMD_Type, EPMD_PreSum, EPMD_User_DR, EPMD_BillNum,
			EPMD_Left, EPMD_BackReason, EPMD_Hospital_DR, EPMD_Remark, EPMD_InitDep_DR,
			EPMD_Status, EPMD_Handin, EPMD_IPAddress
		)
		VALUES(
			:AccRowID, :PDType, :PayAmt, :UserId, :ReceiptsNo,
			:myLeft, :BackReason, :HospId, :Remark, :InitPDRowId,
			:Status, 'N', :ClientIPAddress
		)
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	set EMPDRowID=$g(%ROWID)
	
	set PayMSum=0
	for i=1:1:$l(PDPMInfo,$c(2)) {
		set AccPMStr=$p(PDPMInfo,$c(2),i)
		continue:(AccPMStr="")
		set PayMId=$p(AccPMStr,"^",1)
		set CMBankDR=$p(AccPMStr,"^",2)
		set ChequeNo=$p(AccPMStr,"^",3)
		set ARCCardTypeDR=$p(AccPMStr,"^",4)
		set Unit=$p(AccPMStr,"^",5)
		set ChequeDate=$p(AccPMStr,"^",6)
		set ChequeDate=##class(websys.Conversions).DateHtmlToLogical(ChequeDate)
		set PayAccNo=$p(AccPMStr,"^",7)
		set PayMAmt=$p(AccPMStr,"^",8)
		if (PDType="R") {
			set PayMAmt=-PayMAmt
		}
		set PayMSum=$i(PayMSum,PayMAmt)
		set ETPRowID=$p(AccPMStr,"^",12)
		if (PayMAmt>0) {
			set hardComFlag=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMId)
			if ((+hardComFlag'=0)&&(+ETPRowID=0)) {
				set rtn=-1_"^"_"第三方支付，订单表ID不应为空"
				quit
			}
			/*
			//+2022-07-08 ZhYW 自助机现金充值时会生成订单
			if ((+hardComFlag=0)&&(+ETPRowID'=0)) {
				set rtn=-1_"^"_"非第三方支付，订单表ID不应有值"
				quit
			}
			*/	
		}
		&SQL(
			INSERT INTO DHC_EPPrePayMode(
				EPDPM_EPMD_Parref, EPDPM_PayMode_DR, EPDPM_Card_DR, EPDPM_CardChequeNo, EPDPM_CMBank_DR,
				EPDPM_Unit, EPDPM_Amt, EPDPM_ChequeDate, EPDPM_PayAccNO, EPDPM_ETP_DR
			)
			VALUES(
				:EMPDRowID, :PayMId, :ARCCardTypeDR, :ChequeNo, :CMBankDR,
				:Unit, :PayMAmt, :ChequeDate, :PayAccNo, :ETPRowID
			)
		)
		set rtn=SQLCODE
		if (rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		//第三方支付创建关联
		if (+ETPRowID'=0) {
			set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).RelationOrderToHIS(ETPRowID, EMPDRowID, "EPDEP")
			set rtn=$p(rtnValue,"^",1)
			if (rtn) {
				set rtn=rtnValue
				quit
			}
		}
	}
	quit:(+rtn) rtn
	
	quit:(+PayMSum'=+PayAmt) -1_"^"_"金额不平"
	
	quit rtn_"^"_EMPDRowID
}

ClassMethod UpdatePDReceipts(UserID As %String, ReceiptType As %String, HospID As %String) As %String
{
	set rtnValue=..GetCurrentRecNo(UserID, HospID)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtn
	set EndInvNo=$p(rtnValue,"^",3)
	set CurInvNo=$p(rtnValue,"^",4)
	set InvTitle=$p(rtnValue,"^",5)
	set InvID=$p(rtnValue,"^",6)
	
	if (+EndInvNo=+CurInvNo) {       //如果是最后一张领取的发票? 标记为已用完
		set rtn=##class(web.UDHCAccAddDeposit).InvToFinal(InvID, CurInvNo, UserID, ReceiptType, HospID)
		quit:(+rtn) rtn
	}      
	
	if (+CurInvNo<+EndInvNo) {
		set lastnum=##class(web.UDHCJFBaseCommon).incre(CurInvNo)
		&SQL(
			UPDATE DHC_INVOICE
			SET INV_LastNum = :lastnum
			WHERE %ID = :InvID
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
	}
	
	quit rtn_"^"_InvTitle_CurInvNo
}

/// 用来更新账户
/// 与账户支付有些区别，不能把担保额作为交退
/// Input: AccRowID: 激活账户的RowID, PNum: 需要更新的钱数
ClassMethod UpdateAM(AccRowID As %String, PNum As %String) As %String
{
	set $zt="ERROR"
	
	set AccMLeft=$p(^DHCEPM("EPM",AccRowID),"^",9)
	set DepNum=0		//$p(^DHCEPM("EPM",AccRowID),"^",14)
	set CNum=AccMLeft-DepNum	 //减去下限
	set CNum=$fn(CNum,"",2)
	
	quit:((PNum<0)&&($zabs(PNum)>CNum)) 125_"^"_"留观账户余额不足"
	
	set AccMLeft=$i(AccMLeft,PNum)
	&SQL(
		UPDATE DHC_EPManager
		SET EPM_Balance = :AccMLeft
		WHERE %ID = :AccRowID
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	quit rtn_"^"_AccMLeft

ERROR
	quit ..AppException()
}

/// Debug: w ##Class(web.DHCOPBillEPAddDeposit).GetCurrentRecNo(1, 2)
ClassMethod GetCurrentRecNo(userId As %String, hospId As %String) As %String
{
	set ReceiptType=##class(web.DHCOPConfig).GetPreReceiptType(hospId)
	quit:(ReceiptType="") "0^^^^^^"
	
	set startNo="", endNo="", currNo="", invId="", title=""
	set rowId=0
	while($o(^DHCINVOICE(0,"USER",userId,rowId))) {
		set rowId=$o(^DHCINVOICE(0,"USER",userId,rowId))
		set tmp=$g(^DHCINVOICE(rowId))
		set hospDR=$p(tmp,"^",26)
		continue:(hospDR'=hospId)
		set type=$p(tmp,"^",8)
		continue:(type'=ReceiptType)
		set flag=$p(tmp,"^",7)
		continue:(flag'="Y")
		set startNo=$p(tmp,"^",1)
		set endNo=$p(tmp,"^",2)
		set currNo=$p(tmp,"^",6)
		set invId=rowId
	}
	
	set rtn=$s((invId>0):0,1:109)
    set leftNum=+endNo-currNo+1  //余票张数
    
    quit rtn_"^"_startNo_"^"_endNo_"^"_currNo_"^"_title_"^"_invId_"^"_leftNum
}

ClassMethod GetBuildPDNo(PreType As %String, UserDR As %String, ExpStr As %String) As %String
{
	set myBillNo=""
	set myPDFlag=+$g(^DHCACDP("ParaSet","PDAutoNo"))
	set myUseCode=$p(^SSU("SSUSR",UserDR),"^",1)
	if (myPDFlag=1) {
		set myBillNo=##class(web.UDHCEPPreDeposit).GetMaxBillNo(PreType, myUseCode)
	}
	quit myBillNo
}

/// 获取上缴预交金的总额
/// w ##class(web.UDHCEPAddDeposit).ReadPreDepositSum("1")
ClassMethod ReadPreDepositSum(AccRowID As %String) As %String
{
	quit:(AccRowID="") 0
	
	set myPDSum=0
	set myPDSub=0
	while($o(^DHCEPM("EPM",AccRowID,"EPMD",myPDSub))) {
		set myPDSub=$o(^DHCEPM("EPM",AccRowID,"EPMD",myPDSub))
		set myPDData=$g(^DHCEPM("EPM",AccRowID,"EPMD",myPDSub))
		continue:(myPDData="")
		set myPDNum=$p(myPDData,"^",2)
		set myPDSum=$i(myPDSum, myPDNum)
	}
	set myPDSum=$fn(myPDSum,"",2)
	quit myPDSum
}

/// Description: 留观押金明细查询
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillEPAddDeposit","GetEPDepDetail","227","5^122^49^2^20")
Query GetEPDepDetail(AccMRowID As %String, SessionStr As %String) As websys.Query(ROWSPEC = "Tdate:%String:交款日期,Ttime:%String:交款时间,Tamt:%Float:金额,Ttype:%String:交款类型,Tuser:%String:收费员,Treceiptsno:%String:收据号,Tjkdate:%String:结账日期,Tjktime:%String:结账时间,Taccleft:%Float:当时账户余额,Tpaymode:%String:支付方式,Tbankcardtype:%String:银行卡类型,Tchequeno:%String:支票号,Tbank:%String:银行,Tcompany:%String:支付单位,Tpayaccno:%String:账户号,Tchequedate:%String:支票日期,Tbackreason:%String:退款原因,Tremark:%String:备注,TInitPDDR:%String:原纪录ID,AccPreRowID:%String:押金ID")
{
}

ClassMethod GetEPDepDetailExecute(ByRef qHandle As %Binary, AccMRowID As %String, SessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (AccMRowID="")  quit $$$OK
	set ^TMP("GetEPDepDetail")=$lb(AccMRowID, SessionStr)
	
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	set myPDSum=0
	set myPDSub=0
	while($o(^DHCEPM("EPM",AccMRowID,"EPMD",myPDSub))) {
		set myPDSub=$o(^DHCEPM("EPM",AccMRowID,"EPMD",myPDSub))
		set myPDData=$g(^DHCEPM("EPM",AccMRowID,"EPMD",myPDSub))
		continue:(myPDData="")
		do GetDepDtl
	}

	do InitOutput
	set myPDDate=##class(websys.Translation).Get("", "合计", LangId)
	set myPDAmt=$fn(myPDSum,"",2)
	do OutputDepDtl

	quit $$$OK
GetDepDtl
	set myPDRowID=AccMRowID_"||"_myPDSub
	set myPDDate=$p(myPDData,"^",3)
	set myPDDate=##class(websys.Conversions).DateLogicalToHtml(myPDDate)
	set myPDTime=$p(myPDData,"^",4)
	set myPDTime=##class(websys.Conversions).TimeLogicalToHtml(myPDTime)
	set myPDAmt=$p(myPDData,"^",2)
	set myPDAmt=$fn(myPDAmt,"",2)
	set myPDSum=$i(myPDSum, myPDAmt)
	set myPDType=$p(myPDData,"^",1)    //EPMD_Type
	set myPDTypeDesc=$case(myPDType,"P":"交款","R":"退款","T":"转账",:"")
	set myPDTypeDesc=##class(websys.Translation).Get("", myPDTypeDesc, LangId)
	set myPDUserDR=$p(myPDData,"^",5)
	set myPDUser=$s((+myPDUserDR'=0):$p(^SSU("SSUSR",myPDUserDR),"^",2),1:"")
	set myPDUser=##class(User.SSUser).GetTranByDesc("SSUSRName", myPDUser, LangId)	
	set myPDBillNo=$p(myPDData,"^",6)
	set myPDFootDR=$p(myPDData,"^",7)
	set myPDFootDate=$p(myPDData,"^",10)
	set myPDFootDate=##class(websys.Conversions).DateLogicalToHtml(myPDFootDate)
	set myPDFootTime=$p(myPDData,"^",11)
	set myPDFootTime=##class(websys.Conversions).TimeLogicalToHtml(myPDFootTime)
	set myPDLeft=$p(myPDData,"^",8)
	set myPDLeft=$fn(myPDLeft,"",2)
	set myPDBackReaDR=$p(myPDData,"^",9)
	set myPDBackReason=$s((+myPDBackReaDR'=0):$p(^DHCJFYJRREASON(myPDBackReaDR),"^",2),1:"")
	set myPDBackReason=##class(User.dhcjfyjrefreason).GetTranByDesc("yjrreadesc", myPDBackReason, LangId)
	set myPDRemark=$p(myPDData,"^",15)
	set myInitDepDR=$p(myPDData,"^",19)
	set myPMSub=0
	while($o(^DHCEPM("EPM",AccMRowID,"EPMD",myPDSub,"P",myPMSub))) {
		set myPMSub=$o(^DHCEPM("EPM",AccMRowID,"EPMD",myPDSub,"P",myPMSub))
		set myPMData=$g(^DHCEPM("EPM",AccMRowID,"EPMD",myPDSub,"P",myPMSub))
		set myPayMDR=$p(myPMData,"^",1)             //EPDPM_PayMode_DR
		set myPayMDesc=$s((+myPayMDR'=0):$p($g(^CT("CTPM",myPayMDR)),"^",2),1:"")
		set myPayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", myPayMDesc, LangId)
		set myBankCardTypeDR=$p(myPMData,"^",2)		//EPDPM_Card_DR
		set myBankCardTypeDesc=$s((+myBankCardTypeDR'=0):$p($g(^ARC("CARD",myBankCardTypeDR)),"^",2),1:"")
		set myBankCardTypeDesc=##class(User.ARCBankCardType).GetTranByDesc("CARDDesc", myBankCardTypeDesc, LangId)
		set myCardChequeNo=$p(myPMData,"^",3)		//EPDPM_CardChequeNo
		set myBankDR=$p(myPMData,"^",4)		        //EPDPM_CMBank_DR
		set myBankDesc=$s((+myBankDR'=0):$p($g(^CMC("CMCBM",myBankDR)),"^",2),1:"")
		set myBankDesc=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", myBankDesc, LangId)
		set myUnitDR=$p(myPMData,"^",5)              //EPDPM_Unit
		set myUnit=$s((+myUnitDR'=0):$p($g(^CT("HCP",myUnitDR)),"^",2),1:"")
		set myUnit=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", myUnit, LangId)
		set myChequeDate=$p(myPMData,"^",7)           //EPDPM_ChequeDate
		set myChequeDate=##class(websys.Conversions).DateLogicalToHtml(myChequeDate)
		set myPayAccNo=$p(myPMData,"^",11)
	}
	do OutputDepDtl
	quit

InitOutput
	set (myPDDate,myPDTime,myPDAmt,myPDTypeDesc,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myPDRemark,myInitDepDR,myPDRowID)=""
	quit
OutputDepDtl
	set Data=$lb(myPDDate,myPDTime,myPDAmt,myPDTypeDesc,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myPDRemark,myInitDepDR,myPDRowID)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-01-22
/// Description: 查询留观押金第三方支付明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillEPAddDeposit","QryEPDETPList","1328","1","2","29")
Query QryEPDETPList(accMId As %String, paymId As %String, hospId As %String) As websys.Query(ROWSPEC = "Date:%String:交款日期,Time:%String:交款时间,Amt:%Float:金额,UserName:%String:收费员,ReceiptNo:%String:收据号,PayMRowId:%String:支付方式ID,PayMDesc:%String:支付方式,PDRowId:%String:押金ID,RefableAmt:%Float:可退金额,ETPRowId:%String:HIS订单ID,ETPPan:%String:卡号/账户号,ETPRRN:%String:支付流水号,ETPHISTradeNo:%String:HIS订单号,ETPExtTradeNo:%String:第三方订单号,IsTimeout:%String:是否超过可退时限")
{
}

ClassMethod QryEPDETPListExecute(ByRef qHandle As %Binary, accMId As %String, paymId As %String, hospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("QryEPDETPList")=$lb(accMId, paymId, hospId)
	if (accMId="")  quit $$$OK
	
	//+2022-09-20 ZhYW 获取对照的支付方式
	set myPMStr=##class(web.UDHCOPGSConfig).GetContraRefPMStr("TTPPAY.SysCfg.ZFFSDZ", hospId, paymId)
	if (("^"_myPMStr_"^")'[("^"_paymId_"^")) {  //若对照中不存在传入支付方式，将传入支付方式拼入
		set myPMStr=myPMStr_"^"_paymId
	}
	
	set myPDSub=0
	while($o(^DHCEPM("EPM",accMId,"EPMD",myPDSub))) {
		set myPDSub=$o(^DHCEPM("EPM",accMId,"EPMD",myPDSub))
		set myPDData=$g(^DHCEPM("EPM",accMId,"EPMD",myPDSub))
		continue:(myPDData="")
		set myPDRowId=accMId_"||"_myPDSub
		set myHospDR=$p(myPDData,"^",13)
		continue:(myHospDR'=hospId)
		set myPDType=$p(myPDData,"^",1)		//EPMD_Type
		continue:(myPDType'="P")            //过滤非充值记录
		set myPDDate=$p(myPDData,"^",3)
		set myPDTime=$p(myPDData,"^",4)
		set myPDDate=##class(websys.Conversions).DateLogicalToHtml(myPDDate)
		set myPDTime=##class(websys.Conversions).TimeLogicalToHtml(myPDTime)
		set myPDAmt=$p(myPDData,"^",2)
		set myPDAmt=$fn(myPDAmt,"",2)
		set myPDUserDR=$p(myPDData,"^",5)
		set myPDUserName=$s((+myPDUserDR'=0):$p(^SSU("SSUSR",myPDUserDR),"^",2),1:"")
		set myPDBillNo=$p(myPDData,"^",6)
		
		set myPMSub=$o(^DHCEPM("EPM",accMId,"EPMD",myPDSub,"P",0))
		set myPMData=$g(^DHCEPM("EPM",accMId,"EPMD",myPDSub,"P",myPMSub))
		continue:(myPMData="")
		set myPayMDR=$p(myPMData,"^",1)		//EPDPM_PayMode_DR
		continue:(("^"_myPMStr_"^")'[("^"_myPayMDR_"^"))
		set myPayMDesc=$s((+myPayMDR'=0):$p($g(^CT("CTPM",myPayMDR)),"^",2),1:"")
		
		set myPDRefableAmt=..GetEPDRefundableAmt(myPDRowId)  //可退金额
		continue:(+myPDRefableAmt=0)   //过滤已经退完的
		
		//第三方支付信息
		set myETPRowId=$p(myPMData,"^",12)		//EPDPM_ETP_DR 订单表Id
		continue:(+myETPRowId=0)
		set timeoutDays=##class(BILL.Payment.COM.Method).GetRefTimeoutDays(myPayMDR, myHospDR)  //退款超时天数
		set myExtData=$g(^DHCBILLETP(myETPRowId))
		set myExtDate=$p(myExtData,"^",14)          //ETP_Ext_Date
		set isTimeout=((+timeoutDays'=0)&&($system.SQL.DATEDIFF("dd", myExtDate, +$h)>timeoutDays))
		set myETPPan=$p(myExtData,"^",3)            //卡号/账户号
		set myETPRRN=$p(myExtData,"^",7)            //交易流水号
		set myETPHISTradeNo=$p(myExtData,"^",32)    //HIS订单号
		set myETPExtTradeNo=$p(myExtData,"^",47)    //第三方订单号
		do OutputPDETPList
	}
	
	quit $$$OK
OutputPDETPList
	set Data=$lb(myPDDate,myPDTime,myPDAmt,myPDUserName,myPDBillNo,myPayMDR,myPayMDesc,myPDRowId,myPDRefableAmt,myETPRowId,myETPPan,myETPRRN,myETPHISTradeNo,myETPExtTradeNo,isTimeout)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-01-22
/// Description: 获取第三方支付充值记录可退金额
/// Input: accPDRowId: DHC_EPPreDeposit.RowId
/// Return: 获取留观押金可退金额
/// Debug: w ##class(web.DHCOPBillEPAddDeposit).GetEPDRefundableAmt("48542||3")
ClassMethod GetEPDRefundableAmt(accPDRowId As %String) As %String
{
	set ^TMP("GetRefundAmt")=accPDRowId
	set accM=+accPDRowId
	set accPDSub=$p(accPDRowId,"||",2)
	
	set accMLeft=$p($g(^DHCEPM("EPM",accM)),"^",9)
	set accMLeft=$fn(accMLeft,"",2)
	
	set refableAmt=$p($g(^DHCEPM("EPM",accM,"EPMD",accPDSub)),"^",2)
	set myPDSub=0
	while($o(^DHCEPM("EPM",accM,"EPMD",myPDSub))) {
		set myPDSub=$o(^DHCEPM("EPM",accM,"EPMD",myPDSub))
		set myPDData=$g(^DHCEPM("EPM",accM,"EPMD",myPDSub))
		continue:(myPDData="")
		set myInitPDDR=$p(myPDData,"^",19)
		continue:(accPDRowId'=myInitPDDR)
		set myPDAmt=$p(myPDData,"^",2)
		set refableAmt=$i(refableAmt,myPDAmt)
	}
	
	set refableAmt=$s((+refableAmt>+accMLeft):accMLeft,1:refableAmt)   //跟账户余额比较，取小
	
	quit $fn(refableAmt,"",2)
}

/// Creator: ZhYW
/// CreatDate: 2022-12-16
/// Description: 急诊留观押金查询
/// Input: stDate:开始日期, endDate:结束日期, patientId:PA_PatMas.RowId, userId:SS_User.RowId, depStatus:留观押金状态, paymId:CT_PayMode.RowId, hospId:CT_Hospital.RowId
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillEPAddDeposit","QryEPDepList","2022-09-26","2022-12-16","417","","","","2","")
Query QryEPDepList(stDate As %String, endDate As %String, patientId As %String, userId As %String, depStatus As %String, paymId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TPatientNo:%String:登记号,TPatName:%String:患者姓名,TPatientID:%String:患者ID,TEpisodeID:%String:就诊ID,TPrtDate:%String:交款日期,TPrtTime:%String:交款时间,TAmt:%Float:金额,TPreType:%String:交款类型,TUserName:%String:收费员,TReceiptNo:%String:收据号,TFootDate:%String:结账日期,TFootTime:%String:结账时间,TAccLeft:%Float:当时账户余额,TPayMode:%String:支付方式,TBankCardType:%String:银行卡类型,TChequeNo:%String:支票号,TBank:%String:银行,TCompany:%String:支付单位,TPayaccno:%String:账户号,TChequeDate:%String:支票日期,TBackreason:%String:退款原因,TRemark:%String:备注,TInitPDDR:%String:原纪录ID,TPreRowID:%String:押金ID") [ SqlProc ]
{
}

ClassMethod QryEPDepListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, patientId As %String, userId As %String, depStatus As %String, paymId As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	set ^TMP("QryEPDepList")=$lb(stDate, endDate, patientId, userId, depStatus, paymId, hospId, langId)
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	kill depList
	
	if (+patientId>0) {
		set accM=0
		while($o(^DHCEPMi("EPM",0,"EPMPapmi",patientId,accM))) {
			set accM=$o(^DHCEPMi("EPM",0,"EPMPapmi",patientId,accM))
			set myPDSub=0
			while($o(^DHCEPM("EPM",accM,"EPMD",myPDSub))) {
				set myPDSub=$o(^DHCEPM("EPM",accM,"EPMD",myPDSub))
				set myPDData=$g(^DHCEPM("EPM",accM,"EPMD",myPDSub))
				continue:(myPDData="")
				do SetDepList
			}
		}
	}else {
		for date=stDate:1:endDate {
			set accM=0
			while($o(^DHCEPMi("EPM",0,"EPMDPreDate",date,accM))) {
				set accM=$o(^DHCEPMi("EPM",0,"EPMDPreDate",date,accM))
				set myPDSub=0
				while($o(^DHCEPMi("EPM",0,"EPMDPreDate",date,accM,"EPMD",myPDSub))) {
					set myPDSub=$o(^DHCEPMi("EPM",0,"EPMDPreDate",date,accM,"EPMD",myPDSub))
					set myPDData=$g(^DHCEPM("EPM",accM,"EPMD",myPDSub))
				    continue:(myPDData="")
					do SetDepList
				}
			}
		}
	}
	
	set myPDSum=0
	
	set date=""
    while($o(depList(date),-1)'="") {
	    set date=$o(depList(date),-1)
	    set time=""
	    while($o(depList(date,time),-1)'="") {
		    set time=$o(depList(date,time),-1)
		    set myPDRowID=""
		    while($o(depList(date,time,myPDRowID))'="") {
				set myPDRowID=$o(depList(date,time,myPDRowID))
				set myAccM=+myPDRowID
			    set myPDSub=$p(myPDRowID,"||",2)
			  	set myAccMData=$g(^DHCEPM("EPM",myAccM))
			    set myPDData=$g(^DHCEPM("EPM",myAccM,"EPMD",myPDSub))
				do GetDepList
			}
		}
	}
	
	if (ind>1) {
		do InitDepList
		set myRegNo=##class(websys.Translation).Get("", "合计", langId)
		set myPDAmt=$fn(myPDSum,"",2)
		do OutputDepList
	}
	
	quit $$$OK

SetDepList
	set myPDRowID=accM_"||"_myPDSub
	set myHospDR=$p(myPDData,"^",13)
    quit:(myHospDR'=hospId)
	set myUserDR=$p(myPDData,"^",5)
	quit:((userId'="")&&(userId'=myUserDR))
    set myPDAmt=$p(myPDData,"^",2)
    quit:((depStatus="P")&&(+myPDAmt<0))
    quit:((depStatus="R")&&(+myPDAmt>0))
	set myPDDate=$p(myPDData,"^",3)
    set myPDTime=$p(myPDData,"^",4)
    set depList(myPDDate,myPDTime,myPDRowID)=myPDRowID
	quit
	
GetDepList
	set myAdmDR=$p(myAccMData,"^",2)	   //EPM_Adm_DR
	set myPAPMIDR=$p(myAccMData,"^",3)	   //EPM_PAPMI_DR
    set myRegNo=$p(myAccMData,"^",4)	   //EPM_PAPMINo
    set myPatName=$s((+myPAPMIDR'=0):$p($g(^PAPER(myPAPMIDR,"ALL")),"^",1),1:"")
	set myPDDate=$p(myPDData,"^",3)
	set myPDDate=##class(websys.Conversions).DateLogicalToHtml(myPDDate)
	set myPDTime=$p(myPDData,"^",4)
	set myPDTime=##class(websys.Conversions).TimeLogicalToHtml(myPDTime)
	set myPDAmt=$p(myPDData,"^",2)
	set myPDAmt=$fn(myPDAmt,"",2)
	set myPDSum=$i(myPDSum, myPDAmt)
	set myPDType=$p(myPDData,"^",1)    //EPMD_Type
	set myPDTypeDesc=$case(myPDType,"P":"交款","R":"退款","T":"转账",:"")
	set myPDTypeDesc=##class(websys.Translation).Get("", myPDTypeDesc, langId)
	set myPDUserDR=$p(myPDData,"^",5)
	set myPDUser=$s((+myPDUserDR'=0):$p(^SSU("SSUSR",myPDUserDR),"^",2),1:"")
	set myPDUser=##class(User.SSUser).GetTranByDesc("SSUSRName", myPDUser, langId)
	set myPDBillNo=$p(myPDData,"^",6)
	set myPDFootDR=$p(myPDData,"^",7)
	set myPDFootDate=$p(myPDData,"^",10)
	set myPDFootDate=##class(websys.Conversions).DateLogicalToHtml(myPDFootDate)
	set myPDFootTime=$p(myPDData,"^",11)
	set myPDFootTime=##class(websys.Conversions).TimeLogicalToHtml(myPDFootTime)
	set myPDLeft=$p(myPDData,"^",8)
	set myPDLeft=$fn(myPDLeft,"",2)
	set myPDBackReaDR=$p(myPDData,"^",9)
	set myPDBackReason=$s((+myPDBackReaDR'=0):$p(^DHCJFYJRREASON(myPDBackReaDR),"^",2),1:"")
	set myPDBackReason=##class(User.dhcjfyjrefreason).GetTranByDesc("yjrreadesc", myPDBackReason, langId)
	set myPDRemark=$p(myPDData,"^",15)
	set myInitDepDR=$p(myPDData,"^",19)
	set myPayMIdStr=""
	set myPMSub=0
	while($o(^DHCEPM("EPM",myAccM,"EPMD",myPDSub,"P",myPMSub))) {
		set myPMSub=$o(^DHCEPM("EPM",myAccM,"EPMD",myPDSub,"P",myPMSub))
		set myPMData=$g(^DHCEPM("EPM",myAccM,"EPMD",myPDSub,"P",myPMSub))
		set myPayMDR=$p(myPMData,"^",1)             //EPDPM_PayMode_DR
		set myPayMIdStr=$s((myPayMIdStr=""):myPayMDR,1:(myPayMIdStr_"^"_myPayMDR))
		set myPayMDesc=$s((+myPayMDR'=0):$p($g(^CT("CTPM",myPayMDR)),"^",2),1:"")
		set myPayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", myPayMDesc, langId)
		set myBankCardTypeDR=$p(myPMData,"^",2)		//EPDPM_Card_DR
		set myBankCardTypeDesc=$s((+myBankCardTypeDR'=0):$p($g(^ARC("CARD",myBankCardTypeDR)),"^",2),1:"")
		set myBankCardTypeDesc=##class(User.ARCBankCardType).GetTranByDesc("CARDDesc", myBankCardTypeDesc, langId)
		set myCardChequeNo=$p(myPMData,"^",3)		//EPDPM_CardChequeNo
		set myBankDR=$p(myPMData,"^",4)		        //EPDPM_CMBank_DR
		set myBankDesc=$s((+myBankDR'=0):$p($g(^CMC("CMCBM",myBankDR)),"^",2),1:"")
		set myBankDesc=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", myBankDesc, langId)
		set myUnitDR=$p(myPMData,"^",5)              //EPDPM_Unit
		set myUnit=$s((+myUnitDR'=0):$p($g(^CT("HCP",myUnitDR)),"^",2),1:"")
		set myUnit=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", myUnit, langId)
		set myChequeDate=$p(myPMData,"^",7)           //EPDPM_ChequeDate
		set myChequeDate=##class(websys.Conversions).DateLogicalToHtml(myChequeDate)
		set myPayAccNo=$p(myPMData,"^",11)
	}
	quit:((paymId'="")&&(("^"_myPayMIdStr_"^")'[("^"_paymId_"^")))
	do OutputDepList
	quit

InitDepList
	set (myRegNo,myPatName,myPAPMIDR,myAdmDR,myPDDate,myPDTime,myPDAmt,myPDTypeDesc,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myPDRemark,myInitDepDR,myPDRowID)=""
	quit
OutputDepList
	set Data=$lb(myRegNo,myPatName,myPAPMIDR,myAdmDR,myPDDate,myPDTime,myPDAmt,myPDTypeDesc,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myPDRemark,myInitDepDR,myPDRowID)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

}
