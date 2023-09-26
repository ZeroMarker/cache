Import SQLUser

Class web.UDHCAccAddDeposit Extends BILL.COM.Abstract
{

/// Description: 门诊预交金充值、退款
/// Input: AccRowID:账户RowId, PDInfo: 预交金信息串, PDPMInfo: 支付方式信息
/// Debug: w ##class(web.UDHCAccAddDeposit).NewDeposit("2622","100.00^12173^^^P^^2^^29","1^^^^^^^100^^^^")
ClassMethod NewDeposit(AccRowID As %String, PDInfo As %String, PDPMInfo As %String) As %String
{
	set ^TMP("NewDeposit")=$lb(AccRowID, PDInfo, PDPMInfo)
 	set $zt="ERROR"
 	ts
 	
 	set rtnValue=..AddDeposit(AccRowID, PDInfo, PDPMInfo)
 	set rtn=$p(rtnValue,"^",1)
 	if (+rtn) tro  quit rtnValue
 	
 	if ($tl>0) tc
 	
	quit rtnValue

ERROR
	quit ..AppException()
}

ClassMethod AddDeposit(AccRowID As %String, PDInfo As %String, PDPMInfo As %String) As %String
{
 	set rtn=0

 	quit:('$d(^DHCACD("AccM",AccRowID))) -1_"^"_"账户有误"
	
	set PayAmt=+$p(PDInfo,"^",1)
	quit:(PayAmt'>0) -1_"^"_"金额有误"
	
	set UserId=$p(PDInfo,"^",2)
	set BackReason=$p(PDInfo,"^",3)
	/*
	set Password=$p(PDInfo,"^",4)
	set Password=##class(web.SSUser).Encrypt(Password)
	set pass=$p(^DHCACD("AccM",AccRowID),"^",12)
	quit:(pass'=Password) -1_"^"_"密码验证失败"
 	*/
	set PDType=$p(PDInfo,"^",5)
	set Remark=$p(PDInfo,"^",6)
 	set HospId=$p(PDInfo,"^",7)
	set InitPDRowId=$p(PDInfo,"^",8)     //原记录RowId
	set DepTypeId=$p(PDInfo,"^",9)       //2020-11-19 ZhYW 押金类型
	set AccPayInvId=$p(PDInfo,"^",10)    //DHC_AccPayINV.RowId(记录集中打印发票医保分解充回账户时记录留痕)
	set CardNo=$p(PDInfo,"^",11)         //+2023-04-21 ZhYW 充值/退款时的使用就诊卡卡号
	set CardTypeId=$p(PDInfo,"^",12)     //+2023-04-21 ZhYW 充值/退款时的使用就诊卡卡类型
	
	if (PDType="P") {
		//+tangzf 2023-02-06 单次充值上限配置
		set CfgPayAmt=..GetSinglePayCfg(HospId)
		quit:((+CfgPayAmt'=0)&&(+CfgPayAmt<PayAmt)) -1_"^"_"本次充值金额："_PayAmt_"，大于【单次充值上限】:"_CfgPayAmt
	}
	
	set DefDepTypeId=..GetAccPreDepTypeId()
	if (+DepTypeId=0) {
		set DepTypeId=DefDepTypeId
	}
	
 	if (" TR R F "[(" "_PDType_" ")) {
		set PayAmt=-PayAmt
	}
 	set leftAmt=..GetPreDepLeftAmt(AccRowID, DepTypeId)
 	quit:((" TR R F "[(" "_PDType_" "))&&(leftAmt+PayAmt<0)) -1_"^"_"余额不足"
 	
	//校验是否有未完成的退款记录
 	set rtn=..HasToRefAccPD(AccRowID)
 	quit:(+rtn) -1_"^"_"存在未完成的退款记录"
 	
	lock +^DHCACD("AccM",AccRowID):0  else  quit -110_"^"_"账户被锁定（账户Id："_AccRowID_")."
	if (PDType="TR") {
		set rtnValue=0_"^"_leftAmt           //2020-05-27
	}elseif (DepTypeId'=DefDepTypeId) {
		set rtnValue=0_"^"_(leftAmt+PayAmt)     //2020-11-20 ZhYW 非门诊预交金的不更新账户余额
	}else {
		set rtnValue=..UpdateAM(AccRowID, PayAmt)
	}
	lock -^DHCACD("AccM",AccRowID)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set myLeft=$p(rtnValue,"^",2)
	
	//获取预交金收据号
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
	
	set ClientIPAddress=$system.Process.ClientIPAddress()    //客户端IP
	
	&SQL(
		INSERT INTO DHC_AccPreDeposit(
			AccPD_ParRef, AccPD_Type, AccPD_PreSum, AccPD_User_DR, AccPD_BillNum,
			AccPD_Left, AccPD_BackReason, AccPD_DepType_DR, AccPD_Hospital_DR, AccPD_Handin,
			AccPD_InitAccPD_DR, AccPD_Remark, AccPD_IPAddress, AccPD_CardNo, AccPD_CardType_DR
		)
		VALUES(
			:AccRowID, :PDType, :PayAmt, :UserId, :ReceiptsNo,
			:myLeft, :BackReason, :DepTypeId, :HospId, 'N',
			:InitPDRowId, :Remark, :ClientIPAddress, :CardNo, :CardTypeId
		)
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	set AccPDRowID=$g(%ROWID)
	
	set PayMSum=0
	for i=1:1:$l(PDPMInfo,$c(2)) {
		set myPDPMStr=$p(PDPMInfo,$c(2),i)
		continue:(myPDPMStr="")
		set PayMId=$p(myPDPMStr,"^",1)
		set CMBankDR=$p(myPDPMStr,"^",2)
		set ChequeNo=$p(myPDPMStr,"^",3)
		set ARCCardTypeDR=$p(myPDPMStr,"^",4)
		set Unit=$p(myPDPMStr,"^",5)
		set ChequeDate=$p(myPDPMStr,"^",6)
		set ChequeDate=##class(websys.Conversions).DateHtmlToLogical(ChequeDate)
		set PayAccNo=$p(myPDPMStr,"^",7)
		set PayMAmt=$p(myPDPMStr,"^",8)
		if (" TR R F "[(" "_PDType_" ")) {
			set PayMAmt=-PayMAmt
		}
		set PayMSum=$i(PayMSum, PayMAmt)
		set ETPRowID=$p(myPDPMStr,"^",12)
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
			INSERT INTO DHC_AccPrePayMode(
				APPM_AccPD_ParRef, APPM_PayMode_DR, APPM_Card_DR, APPM_CardChequeNo, APPM_CMBank_DR,
				APPM_Unit, APPM_Amt, APPM_PayAccNO, APPM_ChequeDate, APPM_AccPayInv_DR,
				APPM_ETP_DR
			)
			VALUES(
				:AccPDRowID, :PayMId, :ARCCardTypeDR, :ChequeNo, :CMBankDR,
				:Unit, :PayMAmt, :PayAccNo, :ChequeDate, :AccPayInvId,
				:ETPRowID
			)
		)
		set rtn=SQLCODE
		if (rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		//第三方支付创建关联
		if (+ETPRowID'=0) {
			set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).RelationOrderToHIS(ETPRowID, AccPDRowID, "PRE")
			set rtn=$p(rtnValue,"^",1)
			if (rtn) {
				set rtn=rtnValue
				quit
			}
		}
	}
	quit:(+rtn) rtn
	
	quit:(+PayMSum'=+PayAmt) -1_"^"_"金额不平"

	quit rtn_"^"_AccPDRowID
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
	
	if (+EndInvNo=+CurInvNo) {    //如果是最后一张领取的发票? 标记为已用完
		set rtn=..InvToFinal(InvID, CurInvNo, UserID, ReceiptType, HospID)
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

/// Debug: w ##class(web.UDHCAccAddDeposit).InvToFinal()
ClassMethod InvToFinal(rid As %String, invno As %String, userId As %String, rcptType As %String, hospId As %String) As %String
{
	set rtn=0
	
	&SQL(
		UPDATE DHC_INVOICE
		SET INV_LastNum = :invno, INV_Finalflag = 'N'
		WHERE %ID = :rid
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)

	&SQL(
		SELECT TOP 1 %ID INTO :rowid1
		FROM DHC_INVOICE
		WHERE INV_Usr = :userId AND INV_type = :rcptType AND (INV_Finalflag = '' OR INV_Finalflag IS NULL) AND INV_hospital = :hospId
		ORDER BY %ID
	)
	if (rowid1>0) {
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

/// Description: 判断是否有未完成的退款
/// Debug: w ##class(web.UDHCAccAddDeposit).HasToRefAccPD(18) 
ClassMethod HasToRefAccPD(AccRowID As %String) As %String
{
	set rtn=0
	set PreSub=""
	while($o(^DHCACD("AccM",AccRowID,"AccPD",PreSub),-1)&&(rtn=0)) {
		set PreSub=$o(^DHCACD("AccM",AccRowID,"AccPD",PreSub),-1)
		set PreData=$g(^DHCACD("AccM",AccRowID,"AccPD",PreSub))
		continue:(PreData="")
		set PreType=$p(PreData,"^",1)
		continue:(PreType'="TR")
		set rtn=1
	}
	
	quit rtn
}

/// Description: 更新账户
/// Input: AccRowID:激活账户的RowID, PNum: 需要更新的钱数
/// Debug: w ##class(web.UDHCAccAddDeposit).UpdateAM(AccRowID, "","")
ClassMethod UpdateAM(AccRowID As %String, PNum As %String) As %String
{
	set $zt="ERROR"
	
	set PNum=$fn(PNum,"",2)
	set AccMLeft=$p(^DHCACD("AccM",AccRowID),"^",8)
	//set DepNum=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(AccRowID, "","")
	set DepNum=0
	set CNum=AccMLeft-DepNum	  //减去下限
	set CNum=$fn(CNum,"",2)
	
	quit:((PNum<0)&&($zabs(PNum)>CNum)) 125_"^"_"账户余额不足"
	
	set AccMLeft=$i(AccMLeft,PNum)
	&SQL(
		UPDATE DHC_AccManager
		SET AccM_Balance = :AccMLeft
		WHERE %ID = :AccRowID
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	quit rtn_"^"_AccMLeft
	
ERROR
	quit ..AppException()
}

/// Description: 获取门诊预交金收据走票据管理时的号段信息
/// Debug: w ##class(web.UDHCAccAddDeposit).GetCurrentRecNo(5, 2)
ClassMethod GetCurrentRecNo(userId As %String, hospId As %String) As %String
{
	set receiptType=##class(web.DHCOPConfig).GetPreReceiptType(hospId)
	quit:(receiptType="") "0^^^^^^"
	
	set startNo="", endNo="", currNo="", invId="", title=""
	set rowId=0
	while($o(^DHCINVOICE(0,"USER",userId,rowId))&&(invId="")) {
		set rowId=$o(^DHCINVOICE(0,"USER",userId,rowId))
		set tmp=$g(^DHCINVOICE(rowId))
		set hospDR=$p(tmp,"^",26)
		continue:(hospDR'=hospId)
		set type=$p(tmp,"^",8)
		continue:(type'=receiptType)
		set flag=$p(tmp,"^",7)
		continue:(flag'="Y")
		set startNo=$p(tmp,"^",1)
		set endNo=$p(tmp,"^",2)
		set currNo=$p(tmp,"^",6)
		set title=$p(tmp,"^",16)
		set invId=rowId
	}
	set rtn=$s((invId>0):0,1:109)
	//余票张数
	set leftNum=+endNo-currNo+1
    
    quit rtn_"^"_startNo_"^"_endNo_"^"_currNo_"^"_title_"^"_invId_"^"_leftNum
}

/// Description: 门诊预交金明细查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccAddDeposit","AccDepDetail","1334","2","30")
Query AccDepDetail(AccMRowID As %String, DepTypeId As %String = "", SessionStr As %String = "") As websys.Query(ROWSPEC = "Tdate:%String:交款日期,Ttime:%String:交款时间,Tamt:%Float:金额,Ttype:%String:交款类型,Tuser:%String:收费员,Treceiptsno:%String:收据号,Tjkdate:%String:结账日期,Tjktime:%String:结账时间,Taccleft:%Float:当时账户余额,Tpaymode:%String:支付方式,Tbankcardtype:%String:银行卡类型,Tchequeno:%String:卡号/支票号,Tbank:%String:银行,Tcompany:%String:支付单位,Tpayaccno:%String:账户号,Tchequedate:%String:支票日期,Tbackreason:%String:退款原因,Tremark:%String:备注,TAccPDRowID:%String,TDepType:%String")
{
}

ClassMethod AccDepDetailExecute(ByRef qHandle As %Binary, AccMRowID As %String, DepTypeId As %String = "", SessionStr As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("AccDepDetail")=$lb(AccMRowID, DepTypeId, SessionStr)
	if (AccMRowID="")  quit $$$OK
	
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	set myPDSum=0
	
	set myPDSub=0
	while($o(^DHCACD("AccM",AccMRowID,"AccPD",myPDSub))) {
		set myPDSub=$o(^DHCACD("AccM",AccMRowID,"AccPD",myPDSub))
		set myPDData=$g(^DHCACD("AccM",AccMRowID,"AccPD",myPDSub))
		continue:(myPDData="")
		set myHospDR=$p(myPDData,"^",15)
		continue:(myHospDR'=HospId)
		do GetDepDtl
	}

	do InitOutput
	set myPDDate=##class(websys.Translation).Get("", "合计", LangId)
	set myPDAmt=$fn(myPDSum,"",2)
	do OutputDepDtl

	quit $$$OK

InitOutput
	set (myPDDate,myPDTime,myPDAmt,myPDTypeDesc,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myPDRemark,myAccPDRowID,myPDDepType)=""
	quit
OutputDepDtl
	set Data=$lb(myPDDate,myPDTime,myPDAmt,myPDTypeDesc,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myPDRemark,myAccPDRowID,myPDDepType)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
GetDepDtl
	set myAccPDRowID=AccMRowID_"||"_myPDSub
	set myPDDepTypeDR=$p(myPDData,"^",10)
	quit:((DepTypeId'="")&&(DepTypeId'=myPDDepTypeDR))
	set myPDDepType=$s((+myPDDepTypeDR'=0):$p($g(^ARC("ARCDT",myPDDepTypeDR)),"^",2),1:"")
	set myPDDepType=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", myPDDepType, LangId)
	set myPDDate=$p(myPDData,"^",3)
	set myPDTime=$p(myPDData,"^",4)
	set myPDDate=##class(websys.Conversions).DateLogicalToHtml(myPDDate)
	set myPDTime=##class(websys.Conversions).TimeLogicalToHtml(myPDTime)
	set myPDAmt=$p(myPDData,"^",2)
	set myPDAmt=$fn(myPDAmt,"",2)
	set myPDSum=$i(myPDSum,myPDAmt)
	set myPDType=$p(myPDData,"^",1)		//AccPD_Type
	set myPDTypeDesc=$case(myPDType,"P":"交款","R":"退款","T":"转账","F":"账户结算退款",:"")
    set myPDTypeDesc=##class(websys.Translation).Get("", myPDTypeDesc, LangId)
    set myPDUserDR=$p(myPDData,"^",5)
	set myPDUser=$s((+myPDUserDR'=0):$p(^SSU("SSUSR",myPDUserDR),"^",2),1:"")
	set myPDUser=##class(User.SSUser).GetTranByDesc("SSUSRName", myPDUser, LangId)
	set myPDBillNo=$p(myPDData,"^",6)
	set myPDFootDR=$p(myPDData,"^",7)
	set myPDFootDate=$p(myPDData,"^",11)
	set myPDFootDate=##class(websys.Conversions).DateLogicalToHtml(myPDFootDate)
	set myPDFootTime=$p(myPDData,"^",12)
	set myPDFootTime=##class(websys.Conversions).TimeLogicalToHtml(myPDFootTime)
	set myPDLeft=$p(myPDData,"^",8)
	set myPDLeft=$fn(myPDLeft,"",2)
	set myPDBackReason=$p(myPDData,"^",9)
	set myPDRemark=$p(myPDData,"^",18)
	set myPMSub=0
	while($o(^DHCACD("AccM",AccMRowID,"AccPD",myPDSub,"P",myPMSub))) {
		set myPMSub=$o(^DHCACD("AccM",AccMRowID,"AccPD",myPDSub,"P",myPMSub))
		set myPMData=$g(^DHCACD("AccM",AccMRowID,"AccPD",myPDSub,"P",myPMSub))
		continue:(myPMData="")
		set myPayMDR=$p(myPMData,"^",1)		//APPM_PayMode_DR
		set myPayMDesc=$s((+myPayMDR'=0):$p($g(^CT("CTPM",myPayMDR)),"^",2),1:"")
		set myPayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", myPayMDesc, LangId)
		set myBankCardTypeDR=$p(myPMData,"^",2)		//APPM_Card_DR
		set myBankCardTypeDesc=$s((+myBankCardTypeDR'=0):$p($g(^ARC("CARD",myBankCardTypeDR)),"^",2),1:"")
		set myBankCardTypeDesc=##class(User.ARCBankCardType).GetTranByDesc("CARDDesc", myBankCardTypeDesc, LangId)
		set myCardChequeNo=$p(myPMData,"^",3)	   //APPM_CardChequeNo
		set myBankDR=$p(myPMData,"^",4)		       //APPM_CMBank_DR
		set myBankDesc=$s((+myBankDR'=0):$p($g(^CMC("CMCBM",myBankDR)),"^",2),1:"")
		set myBankDesc=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", myBankDesc, LangId)
		set myUnitDR=$p(myPMData,"^",5)
		set myUnit=$s((+myUnitDR'=0):$p($g(^CT("HCP",myUnitDR)),"^",2),1:"")
		set myUnit=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", myUnit, LangId)
		set myPayAccNo=$p(myPMData,"^",7)
		set myChequeDate=$p(myPMData,"^",8)
		set myChequeDate=##class(websys.Conversions).DateLogicalToHtml(myChequeDate)
	}
	do OutputDepDtl
	quit
}

/// Debug: w ##class(web.UDHCAccAddDeposit).GetBuildPDNo("R","5","")
ClassMethod GetBuildPDNo(PreType As %String, UserDR As %String, ExpStr As %String = "") As %String
{
	set myBillNo=""
	set myPDFlag=+$g(^DHCACDP("ParaSet","PDAutoNo"))	
	set myUseCode=$p(^SSU("SSUSR",UserDR),"^",1)
	if (myPDFlag=1) {
		set myBillNo=##class(web.UDHCAccPreDeposit).GetMaxBillNo(PreType, myUseCode)
	}
	quit myBillNo
}

/// Description: 获取门诊预交金充值总额
/// Debug: w ##class(web.UDHCAccAddDeposit).ReadPreDepositSum(1380)
ClassMethod ReadPreDepositSum(AccRowID As %String) As %String
{
	set myPDSum=0
	quit:(AccRowID="") myPDSum
	
	set myDepTypeId=..GetAccPreDepTypeId()
	
	set myPDSub=0
	while($o(^DHCACD("AccM",AccRowID,"AccPD",myPDSub))) {
		set myPDSub=$o(^DHCACD("AccM",AccRowID,"AccPD",myPDSub))
		set data=$g(^DHCACD("AccM",AccRowID,"AccPD",myPDSub))
		continue:(data="")
		set myPDTypeDR=$p(data,"^",10)
		continue:(myPDTypeDR'=myDepTypeId)
		set myPDNum=$p(data,"^",2)
		set myPDSum=$i(myPDSum,myPDNum)
	}
	
	quit $fn(myPDSum,"",2)
}

/// Description: 预交金查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccAddDeposit","ReadPDDetails","2022-11-28","2022-12-16","12576","","","","2","29","","")
Query ReadPDDetails(StDate As %String, EndDate As %String, PatientId As %String, AccMRowID As %String, UserId As %String, PDDFlag As %String, HospId As %String, DepTypeId As %String = "", PayMId As %String = "", LangId As %String = "") As websys.Query(ROWSPEC = "PAPMINo:%String:登记号,CardNo:%String:卡号,PatName:%String:患者姓名,Tdate:%String:缴款日期,Ttime:%String:缴款时间,Tamt:%Float:金额,Ttype:%String:缴款类型,Tuser:%String:收费员,Treceiptsno:%String:收据号,Tjkdate:%String:结算日期,Tjktime:%String:结算时间,Taccleft:%Float:当时账户余额,Tpaymode:%String:支付方式,Tbankcardtype:%String:银行卡类型,Tchequeno:%String:银行卡/支票号,Tbank:%String:银行,Tcompany:%String:支付单位,Tpayaccno:%String:支付的账号,Tchequedate:%String:支票日期,Tbackreason:%String:退款原因,Tremark:%String:备注,PDType:%String,PDDepType:%String:押金类型") [ SqlProc ]
{
}

ClassMethod ReadPDDetailsExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, PatientId As %String, AccMRowID As %String, UserId As %String, PDDFlag As %String, HospId As %String, DepTypeId As %String = "", PayMId As %String = "", LangId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("ReadPDDetails")=$lb(StDate, EndDate, PatientId, AccMRowID, UserId, PDDFlag, HospId, DepTypeId, PayMId, LangId)
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	kill depList
	
    if (+AccMRowID>0) {
	    set accM=AccMRowID
	    set dsub=0
		while($o(^DHCACD("AccM",accM,"AccPD",dsub))) {
			set dsub=$o(^DHCACD("AccM",accM,"AccPD",dsub))
			set myPDData=$g(^DHCACD("AccM",accM,"AccPD",dsub))
		    continue:(myPDData="")
		    do SetDepList
		}
	}elseif (+PatientId>0) {
	    set accM=0
		while($o(^DHCACDi("AccM",0,"PAPMI",PatientId,accM))) {
			set accM=$o(^DHCACDi("AccM",0,"PAPMI",PatientId,accM))
			set dsub=0
			while($o(^DHCACD("AccM",accM,"AccPD",dsub))) {
				set dsub=$o(^DHCACD("AccM",accM,"AccPD",dsub))
				set myPDData=$g(^DHCACD("AccM",accM,"AccPD",dsub))
			    continue:(myPDData="")
			    do SetDepList
			}
		}
	}else {
		for date=StDate:1:EndDate {
			set accM=0
			while($o(^DHCACDi("AccM",0,"APDDate",date,accM))) {
				set accM=$o(^DHCACDi("AccM",0,"APDDate",date,accM))
				set dsub=0
				while($o(^DHCACDi("AccM",0,"APDDate",date,accM,"AccPD",dsub))) {
					set dsub=$o(^DHCACDi("AccM",0,"APDDate",date,accM,"AccPD",dsub))
					set myPDData=$g(^DHCACD("AccM",accM,"AccPD",dsub))
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
				set accM=+myPDRowID
			    set dsub=$p(myPDRowID,"||",2)
			    set myAccMData=$g(^DHCACD("AccM",accM))
			    set myPDData=$g(^DHCACD("AccM",accM,"AccPD",dsub))			    
				do GetDetailRD
			}
		}
	}
	
	if (ind>1) {
		do InitDepList
		set myPAPMNo=##class(websys.Translation).Get("", "合计", LangId)
		set myPDAmt=$fn(myPDSum,"",2)
		do OutputDepList
	}
	
	quit $$$OK

SetDepList
    set myPDRowID=accM_"||"_dsub
	set myHospDR=$p(myPDData,"^",15)
    quit:(myHospDR'=HospId)
	set myUserDR=$p(myPDData,"^",5)
	quit:((UserId'="")&&(UserId'=myUserDR))
	set myPDDepTypeDR=$p(myPDData,"^",10)
	quit:((DepTypeId'="")&&(DepTypeId'=myPDDepTypeDR))
	set myPDAmt=+$p(myPDData,"^",2)
    quit:((PDDFlag="P")&&(myPDAmt<0))
    quit:((PDDFlag="R")&&(myPDAmt>0))
    set myPDDate=$p(myPDData,"^",3)
    set myPDTime=$p(myPDData,"^",4)
    set depList(myPDDate,myPDTime,myPDRowID)=myPDRowID
	quit
GetDetailRD
	set myPAPMIDR=$p(myAccMData,"^",2)		    //AccM_PAPMI_DR
	set myPAPMNo=$p(myAccMData,"^",3)		    //AccM_PAPMINo
	set myPatName=$s((+myPAPMIDR'=0):$p($g(^PAPER(myPAPMIDR,"ALL")),"^",1),1:"")
	set myCardNo=##class(web.UDHCJFBaseCommon).GetCardNoByAccMRowId(accM)
	set myPDDepTypeDR=$p(myPDData,"^",10)
	set myPDDepType=$s((+myPDDepTypeDR'=0):$p($g(^ARC("ARCDT",myPDDepTypeDR)),"^",2),1:"")
	set myPDDepType=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", myPDDepType, LangId)
	set myPDDate=$p(myPDData,"^",3)     //AccPD_PreDate
	set myPDTime=$p(myPDData,"^",4)     //AccPD_PreTime
	set myPDDate=##class(websys.Conversions).DateLogicalToHtml(myPDDate)    
	set myPDTime=##class(websys.Conversions).TimeLogicalToHtml(myPDTime)
	set myPDAmt=$p(myPDData,"^",2)
	set myPDAmt=$fn(myPDAmt,"",2)
	set myPDType=$p(myPDData,"^",1)		//AccPD_Type
	set myPDTypeDesc=$case(myPDType,"P":"交款","R":"退款","T":"转账","F":"账户结算退款",:"")
	set myPDTypeDesc=##class(websys.Translation).Get("", myPDTypeDesc, LangId)
	set myPDUserDR=$p(myPDData,"^",5) 
	set myPDUser=$s((+myPDUserDR'=0):$p(^SSU("SSUSR",myPDUserDR),"^",2),1:"")
	set myPDUser=##class(User.SSUser).GetTranByDesc("SSUSRName", myPDUser, LangId)
	set myPDBillNo=$p(myPDData,"^",6)
	set myPDFootDR=$p(myPDData,"^",7)
	set myPDFootDate=$p(myPDData,"^",11)        //AccPD_FootDate
	set myPDFootDate=##class(websys.Conversions).DateLogicalToHtml(myPDFootDate)
	set myPDFootTime=$p(myPDData,"^",12)        //AccPD_FootTime
	set myPDFootTime=##class(websys.Conversions).TimeLogicalToHtml(myPDFootTime)
	set myPDLeft=$p(myPDData,"^",8)
	set myPDLeft=$fn(myPDLeft,"",2)
	set myPDBackReason=$p(myPDData,"^",9)
	
	set myPayMIdStr=""
	set myPMSub=0
	while($o(^DHCACD("AccM",accM,"AccPD",dsub,"P",myPMSub))) {
		set myPMSub=$o(^DHCACD("AccM",accM,"AccPD",dsub,"P",myPMSub))
		set myPMData=$g(^DHCACD("AccM",accM,"AccPD",dsub,"P",myPMSub))
		continue:(myPMData="")
		set myPayMDR=$p(myPMData,"^",1)		        //APPM_PayMode_DR
		set myPayMIdStr=$s((myPayMIdStr=""):myPayMDR,1:(myPayMIdStr_"^"_myPayMDR))
		set myPayMDesc=$s((+myPayMDR'=0):$p($g(^CT("CTPM",myPayMDR)),"^",2),1:"")
		set myPayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", myPayMDesc, LangId)
		set myBankCardTypeDR=$p(myPMData,"^",2)		//APPM_Card_DR
		set myBankCardTypeDesc=$s((+myBankCardTypeDR'=0):$p($g(^ARC("CARD",myBankCardTypeDR)),"^",2),1:"")
		set myBankCardTypeDesc=##class(User.ARCBankCardType).GetTranByDesc("CARDDesc", myBankCardTypeDesc, LangId)
		set myCardChequeNo=$p(myPMData,"^",3)	   //APPM_CardChequeNo
		set myBankDR=$p(myPMData,"^",4)		       //APPM_CMBank_DR
		set myBankDesc=$s((+myBankDR'=0):$p($g(^CMC("CMCBM",myBankDR)),"^",2),1:"")
		set myBankDesc=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", myBankDesc, LangId)
		set myUnitDR=$p(myPMData,"^",5)            //APPM_Unit
		set myUnit=$s((+myUnitDR'=0):$p($g(^CT("HCP",myUnitDR)),"^",2),1:"")
		set myUnit=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", myUnit, LangId)
		set myPayAccNo=$p(myPMData,"^",7)
		set myChequeDate=$p(myPMData,"^",8)
		set myChequeDate=##class(websys.Conversions).DateLogicalToHtml(myChequeDate)
		set myRemark=$p(myPMData,"^",11)
		//2017-11-28 zhli 集中打印返回的预交金以医保基金支付的形式冲到账户里，存的是集中打印的的id
		if (myPayMDR=$o(^CT("CTPM",0,"Code","YBINSU",0))) set myRemark="导航号:"_myRemark
	}
	quit:((PayMId'="") && (("^"_myPayMIdStr_"^")'[("^"_PayMId_"^")))
	set myPDSum=$i(myPDSum,myPDAmt)
	do OutputDepList
	
	quit
	
InitDepList
	set (myPAPMNo,myCardNo,myPatName,myPDDate,myPDTime,myPDAmt,myPDTypeDesc,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myRemark,myPDType,myPDDepType)=""
	quit
OutputDepList
	set Data=$lb(myPAPMNo,myCardNo,myPatName,myPDDate,myPDTime,myPDAmt,myPDTypeDesc,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myRemark,myPDType,myPDDepType)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 提供一个按照时间的循序排序
/// Debug: w ##class(web.UDHCAccAddDeposit).SetPreDepositList("1")
ClassMethod SetPreDepositList(AccRowID As %String, langId As %String = "") As %String
{
	quit:(AccRowID="") 0
	
	set myPDSub=0
	while($o(^DHCACD("AccM",AccRowID,"AccPD",myPDSub))) {
		set myPDSub=$o(^DHCACD("AccM",AccRowID,"AccPD",myPDSub))
		set myPDData=$g(^DHCACD("AccM",AccRowID,"AccPD",myPDSub))
		continue:(myPDData="")
		set myPDRowID=AccRowID_"||"_myPDSub
		set myPDDate=$p(myPDData,"^",3)
		set myPDTime=$p(myPDData,"^",4)
		set myTMPPDDate=##class(websys.Conversions).DateLogicalToHtml(myPDDate)
		set myTMPPDTime=##class(websys.Conversions).TimeLogicalToHtml(myPDTime)
		set myPreDate=myTMPPDDate_" "_myTMPPDTime
		set myPDType=$p(myPDData,"^",1)
		set myPDTypeDesc=$case(myPDType,"P":"缴款","R":"退款","F":"结算退款",:"")
		set myPDTypeDesc=##class(websys.Translation).Get("", myPDTypeDesc, langId)
		set myPDSum=$p(myPDData,"^",2)
		set myUserDR=$p(myPDData,"^",5)
		set myUserDesc=$s((+myUserDR'=0):$p(^SSU("SSUSR",myUserDR),"^",2),1:"")
		set myUserDesc=##class(User.SSUser).GetTranByDesc("SSUSRName", myUserDesc, langId)
		set myBillNum=$p(myPDData,"^",6)
		set myPDLeft=$p(myPDData,"^",8)
		set myPDDepTypeDR=$p(myPDData,"^",10)
		set myPDDepType=$s((+myPDDepTypeDR'=0):$p($g(^ARC("ARCDT",myPDDepTypeDR)),"^",2),1:"")
		set myPDDepType=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", myPDDepType, langId)
		set mySub=$o(^TMPAccPat("Acc",$j,myPDDate,myPDTime,""),-1)
		set mySub=$i(mySub)
		set ^TMPAccPat("Acc",$j,myPDDate,myPDTime,mySub)=myPreDate_"^"_myPDTypeDesc_"^"_myPDSum_"^"_myUserDesc_"^"_myBillNum_"^"_myPDLeft_"^"_"PD"_"^"_myPDRowID_"^"_myPDDepType
	}
	
	quit 0
}

/// Description: 获取预交金汇总信息
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccAddDeposit","ReadPDState","",+$h,+$h)
Query ReadPDState(UserDR As %String, StDate As %String, EndDate As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TUserName:%String,TGetPDNum:%String,TGetPDSum:%String,TRefPDNum:%String,TRefPDSum:%String,TSum:%String")
{
}

ClassMethod ReadPDStateExecute(ByRef qHandle As %Binary, UserDR As %String, StDate As %String, EndDate As %String, HospId As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((StDate="")&&(EndDate=""))  quit $$$OK
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set pdSum=0
	
	kill ^||TMP("TPRD",$j)
	
    for pddate=StDate:1:EndDate do
    .set accid=0
    .for  set accid=$o(^DHCACDi("AccM",0,"APDDate",pddate,accid)) quit:(accid="")  do
    ..set pdsub=0
    ..for  set pdsub=$o(^DHCACDi("AccM",0,"APDDate",pddate,accid,"AccPD",pdsub)) quit:(pdsub="")  do
    ...set myPDData=$g(^DHCACD("AccM",accid,"AccPD",pdsub))
    ...quit:(myPDData="")
    ...set myHospDR=$p(myPDData,"^",15)
	...quit:(myHospDR'=HospId)
	...set myPDRowID=accid_"||"_pdsub
    ...set myPreTime=$p(myPDData,"^",4)
    ...set pdAmt=$p(myPDData,"^",2)
    ...set myUserDR=$p(myPDData,"^",5)
    ...if (pdAmt>=0) do
    ....set ^||TMP("TPRD",$j,myUserDR,"PDNum")=$i(^||TMP("TPRD",$j,myUserDR,"PDNum"))
    ....set ^||TMP("TPRD",$j,myUserDR,"PDSum")=$i(^||TMP("TPRD",$j,myUserDR,"PDSum"), pdAmt)
    ...else  do
    ....set ^||TMP("TPRD",$j,myUserDR,"RNum")=$i(^||TMP("TPRD",$j,myUserDR,"RNum"))
    ....set ^||TMP("TPRD",$j,myUserDR,"RSum")=$i(^||TMP("TPRD",$j,myUserDR,"RSum"), pdAmt)
    ...set ^||TMP("TPRD",$j,myUserDR,"T")=$i(^||TMP("TPRD",$j,myUserDR,"T"), pdAmt)
	
	do ValidateRDPS
	//收预交金
	set myTPDNum=0
	set myTPDSum=0
	//退预交金
	set myTRNum=0
	set myTRSum=0
	set myTSum=0
	set myUserDR=0
	while($o(^||TMP("TPRD",$j,myUserDR))) {
		set myUserDR=$o(^||TMP("TPRD",$j,myUserDR))
		set myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
		set myUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", myUserName, LangId)
		set myGetPDNum=+$g(^||TMP("TPRD",$j,myUserDR,"PDNum"))
		set myTPDNum=$i(myTPDNum, myGetPDNum)
		set myGetPDSum=+$g(^||TMP("TPRD",$j,myUserDR,"PDSum"))
		set myTPDSum=$i(myTPDSum, myGetPDSum)
		set myGetPDSum=$fn(myGetPDSum,"",2)
		set myRefPDNum=+$g(^||TMP("TPRD",$j,myUserDR,"RNum"))
		set myTRNum=$i(myTRNum, myRefPDNum)
		set myRefPDSum=+$g(^||TMP("TPRD",$j,myUserDR,"RSum"))
		set myTRSum=$i(myTRSum, myRefPDSum)
		set myRefPDSum=$fn(myRefPDSum,"",2)
		set mySum=+$g(^||TMP("TPRD",$j,myUserDR,"T"))
		set myTSum=$i(myTSum, mySum)
		set mySum=$fn(mySum,"",2)
		do OutputRowRDPS	
	}
	
	do ValidateRDPS
	set myUserName=##class(websys.Translation).Get("", "合计", LangId)
	set myGetPDNum=myTPDNum
	set myGetPDSum=$fn(myTPDSum,"",2)
	set myRefPDNum=myTRNum
	set myRefPDSum=$fn(myTRSum,"",2)
	set mySum=$fn(myTSum,"",2)
	do OutputRowRDPS
	
	kill ^||TMP("TPRD",$j)
	
	quit $$$OK

ValidateRDPS
	set (myUserName, myGetPDNum, myGetPDSum, myRefPDNum, myRefPDSum, mySum)=""
	quit
OutputRowRDPS
	set Data=$lb(myUserName,myGetPDNum,myGetPDSum,myRefPDNum,myRefPDSum,mySum,myUserDR)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Description: 未结算的预交金明细
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccAddDeposit","UnFootPDDetails","23310",+$h,"55749",+$h,$p($h,",",2))
Query UnFootPDDetails(UserId As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "Tdate:%String,Ttime:%String,Tamt:%String,Ttype:%String,Tuser:%String,Treceiptsno:%String,Tjkdate:%String,Tjktime:%String,Taccleft:%String,Tpaymode:%String,Tbankcardtype:%String,Tchequeno:%String,Tbank:%String,Tcompany:%String,Tpayaccno:%String,Tchequedate:%String,Tbackreason:%String,Tremark:%String,PAPMNo:%String,CardNo:%String,PAName:%String")
{
}

ClassMethod UnFootPDDetailsExecute(ByRef qHandle As %Binary, UserId As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, HospId As %String, LangId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (UserId="")  quit $$$OK

	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set pdSum=0
	
	set pddate=EndDate+1
	for  set pddate=$o(^DHCACDi("AccM",0,"User",UserId,pddate),-1) quit:((pddate="")||(pddate<StDate))  do
	.set accid=""
	.for  set accid=$o(^DHCACDi("AccM",0,"User",UserId,pddate,accid),-1) quit:(accid="")  do
	..set accMData=$g(^DHCACD("AccM",accid))
	..set myPAPMDR=$p(accMData,"^",2)		//AccM_PAPMI_DR
	..set myPAPMNo=$p(accMData,"^",3)		//AccM_PAPMINo
	..set myCardNo=$p(accMData,"^",4)		//AccM_CardNo
	..set myPAName=$s((+myPAPMDR'=0):$p($g(^PAPER(myPAPMDR,"ALL")),"^",1),1:"")
	..set dsub=0
	..for  set dsub=$o(^DHCACDi("AccM",0,"User",UserId,pddate,accid,"AccPD",dsub)) quit:(dsub="")  do
	...set myPDData=$g(^DHCACD("AccM",accid,"AccPD",dsub))
	...set myHospDR=$p(myPDData,"^",15)
	...quit:(myHospDR'=HospId)
	...set myPreTime=$p(myPDData,"^",4)
	...quit:((StDate'="")&&(pddate=StDate)&&(myPreTime<StTime))
	...quit:((EndDate'="")&&(pddate=EndDate)&&(myPreTime>EndTime))
	...do getdetailUF
	...do OutputRowUF
	
	if (ind>1) {
		do ValidateUF
		set PLIST(1)=##class(websys.Translation).Get("", "合计", LangId)
		set PLIST(3)=$fn(pdSum,"",2)
		do OutputRowUF
	}
	
	quit $$$OK
 
getdetailUF
	set myPDDate=$p(myPDData,"^",3)
	set myPDTime=$p(myPDData,"^",4)
	set myPDDate=##class(websys.Conversions).DateLogicalToHtml(myPDDate)
	set myPDTime=##class(websys.Conversions).TimeLogicalToHtml(myPDTime)
	set myPDAmt=$p(myPDData,"^",2)
	set myPDAmt=$fn(myPDAmt,"",2)
	set pdSum=$i(pdSum, myPDAmt)
	set myPDType=$p(myPDData,"^",1)     //AccPD_Type
	set myPDType=$case(myPDType,"P":"交款","R":"退款","T":"转账","F":"结算退款",:"")
	set myPDType=##class(websys.Translation).Get("", "交款", LangId)
	set myPDUserDR=$p(myPDData,"^",5)
	set myPDUser=$s((+myPDUserDR'=0):$p(^SSU("SSUSR",myPDUserDR),"^",2),1:"")
	set myPDUser=##class(User.SSUser).GetTranByDesc("SSUSRName", myPDUser, LangId)
	set myPDBillNo=$p(myPDData,"^",6)
	set myPDFootDR=$p(myPDData,"^",7)
	set myPDFootDate=$p(myPDData,"^",11)
	set myPDFootDate=##class(websys.Conversions).DateLogicalToHtml(myPDFootDate)
	set myPDFootTime=$p(myPDData,"^",12)
	set myPDFootTime=##class(websys.Conversions).TimeLogicalToHtml(myPDFootTime)	
	set myPDLeft=$p(myPDData,"^",8)
	set myPDLeft=$fn(myPDLeft,"",2)
	set myPDBackReason=$p(myPDData,"^",9)
	set psub=0
	while($o(^DHCACD("AccM",accid,"AccPD",dsub,"P",psub))) {
		set psub=$o(^DHCACD("AccM",accid,"AccPD",dsub,"P",psub))
		set myPMData=$g(^DHCACD("AccM",accid,"AccPD",dsub,"P",psub))
		set myPayMDR=$p(myPMData,"^",1)		//APPM_PayMode_DR
		set myPayMDesc=$s((+myPayMDR'=0):$p($g(^CT("CTPM",myPayMDR)),"^",2),1:"")
		set myPayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", myPayMDesc, LangId)
		set myBankCardTypeDR=$p(myPMData,"^",2)		//APPM_Card_DR
		set myBankCardTypeDesc=$s((+myBankCardTypeDR'=0):$p($g(^ARC("CARD",myBankCardTypeDR)),"^",2),1:"")
		set myBankCardTypeDesc=##class(User.ARCBankCardType).GetTranByDesc("CARDDesc", myBankCardTypeDesc, LangId)
		set myCardChequeNo=$p(myPMData,"^",3)		//APPM_CardChequeNo
		set myBankDR=$p(myPMData,"^",4)		//APPM_CMBank_DR
		set myBankDesc=$s((+myBankDR'=0):$p($g(^CMC("CMCBM",myBankDR)),"^",2),1:"")
		set myBankDesc=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", myBankDesc, LangId)
		set myUnitDR=$p(myPMData,"^",5)
		set myUnit=$s((+myUnitDR'=0):$p($g(^CT("HCP",myUnitDR)),"^",2),1:"")
		set myUnit=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", myUnit, LangId)
		set myPayAccNo=$p(myPMData,"^",7)
		set myChequeDate=$p(myPMData,"^",8)
		set myChequeDate=##class(websys.Conversions).DateLogicalToHtml(myChequeDate)
		set myRemark=$p(myPMData,"^",11)
	}
	quit

ValidateUF
	set (myPDDate,myPDTime,myPDAmt,myPDType,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myRemark,myPAPMNo,myCardNo,myPAName)=""
	quit
OutputRowUF
	set Data=$lb(myPDDate,myPDTime,myPDAmt,myPDType,myPDUser,myPDBillNo,myPDFootDate,myPDFootTime,myPDLeft,myPayMDesc,myBankCardTypeDesc,myCardChequeNo,myBankDesc,myUnit,myPayAccNo,myChequeDate,myPDBackReason,myRemark,myPAPMNo,myCardNo,myPAName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-11-19
/// Description: 获取"门诊预交金"类型Id
/// Input: 
/// Return: ARC_DepType.RowId
/// Debug: w ##class(web.UDHCAccAddDeposit).GetAccPreDepTypeId()
ClassMethod GetAccPreDepTypeId() As %String
{
	quit $o(^ARC("ARCDT",0,"Code","MZYJ",0))
}

/// Creator: ZhYW
/// CreatDate: 2020-11-19
/// Description: 根据押金类型获取余额
/// Input: accM: DHC_AccManager.RowId, depTypeId: ARC_DepType.RowId
/// Return: 押金余额
/// Debug: w ##class(web.UDHCAccAddDeposit).GetPreDepLeftAmt()
ClassMethod GetPreDepLeftAmt(accM As %String, depTypeId As %String) As %String
{
	set leftAmt=0
	quit:(+accM=0) leftAmt
	
	if (depTypeId=..GetAccPreDepTypeId()) {
		set leftAmt=$p($g(^DHCACD("AccM",accM)),"^",8)
		quit $fn(leftAmt,"",2)
	}
	
	set sub=0
	while($o(^DHCACD("AccM",accM,"AccPD",sub))) {
		set sub=$o(^DHCACD("AccM",accM,"AccPD",sub))
		set subData=$g(^DHCACD("AccM",accM,"AccPD",sub))
		continue:(subData="")
		set preDepTypeDR=$p(subData,"^",10)
		continue:(depTypeId'=preDepTypeDR)
		set payAmt=$p(subData,"^",2)
		set leftAmt=$i(leftAmt, payAmt)
	}
	
	quit $fn(leftAmt,"",2)
}

/// Creator: ZhYW
/// CreatDate: 2020-01-22
/// Description: 查询预交金第三方支付明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccAddDeposit","QryAccPDETPList","521","46","2","29")
Query QryAccPDETPList(accMId As %String, paymId As %String, hospId As %String, depTypeId As %String = "") As websys.Query(ROWSPEC = "Date:%String:交款日期,Time:%String:交款时间,Amt:%Float:金额,UserName:%String:收费员,ReceiptNo:%String:收据号,PayMRowId:%String:支付方式ID,PayMDesc:%String:支付方式,PDRowId:%String:预交金ID,RefableAmt:%Float:可退金额,ETPRowId:%String:HIS订单ID,ETPPan:%String:卡号/账户号,ETPRRN:%String:支付流水号,ETPHISTradeNo:%String:HIS订单号,ETPExtTradeNo:%String:第三方订单号,IsTimeout:%String:是否超过可退时限")
{
}

ClassMethod QryAccPDETPListExecute(ByRef qHandle As %Binary, accMId As %String, paymId As %String, hospId As %String, depTypeId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("QryAccPDETPList")=$lb(accMId, paymId, hospId, depTypeId)
	if (accMId="")  quit $$$OK
	
	//+2022-09-20 ZhYW 获取对照的支付方式
	set myPMStr=##class(web.UDHCOPGSConfig).GetContraRefPMStr("TTPPAY.SysCfg.ZFFSDZ", hospId, paymId)
	if (("^"_myPMStr_"^")'[("^"_paymId_"^")) {  //若对照中不存在传入支付方式，将传入支付方式拼入
		set myPMStr=myPMStr_"^"_paymId
	}
	
	set myPDSub=0
	while($o(^DHCACD("AccM",accMId,"AccPD",myPDSub))) {
		set myPDSub=$o(^DHCACD("AccM",accMId,"AccPD",myPDSub))
		set myPDData=$g(^DHCACD("AccM",accMId,"AccPD",myPDSub))
		continue:(myPDData="")
		set myPDRowId=accMId_"||"_myPDSub
		set myHospDR=$p(myPDData,"^",15)
		continue:(myHospDR'=hospId)
		set myPDDepTypeDR=$p(myPDData,"^",10)
		continue:((depTypeId'="")&&(myPDDepTypeDR'=depTypeId))
		set myPDType=$p(myPDData,"^",1)		//AccPD_Type
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
		
		set myPMSub=$o(^DHCACD("AccM",accMId,"AccPD",myPDSub,"P",0))
		set myPMData=$g(^DHCACD("AccM",accMId,"AccPD",myPDSub,"P",myPMSub))
		continue:(myPMData="")
		set myPayMDR=$p(myPMData,"^",1)		//APPM_PayMode_DR
		continue:(("^"_myPMStr_"^")'[("^"_myPayMDR_"^"))
		set myPayMDesc=$s((+myPayMDR'=0):$p($g(^CT("CTPM",myPayMDR)),"^",2),1:"")
		
		set myPDRefableAmt=..GetAccPDRefundableAmt(myPDRowId)  //可退金额
		continue:(+myPDRefableAmt=0)   //过滤已经退完的
		
		//第三方支付信息
		set myETPRowId=$p(myPMData,"^",12)   //APPM_ETP_DR 订单表Id
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
/// Input: accPDRowId: DHC_AccPreDeposit.RowId
/// Return: 获取预交金可退金额
/// Debug: w ##class(web.UDHCAccAddDeposit).GetAccPDRefundableAmt("48542||3")
ClassMethod GetAccPDRefundableAmt(accPDRowId As %String) As %String
{
	set ^TMP("GetRefundAmt")=accPDRowId
	set accM=+accPDRowId
	set accPDSub=$p(accPDRowId,"||",2)
	
	set accMLeft=$p($g(^DHCACD("AccM",accM)),"^",8)
	set accMLeft=$fn(accMLeft,"",2)
	
	set refableAmt=$p($g(^DHCACD("AccM",accM,"AccPD",accPDSub)),"^",2)
	set myPDSub=0
	while($o(^DHCACD("AccM",accM,"AccPD",myPDSub))) {
		set myPDSub=$o(^DHCACD("AccM",accM,"AccPD",myPDSub))
		set myPDData=$g(^DHCACD("AccM",accM,"AccPD",myPDSub))
		continue:(myPDData="")
		set myInitPDDR=$p(myPDData,"^",17)
		continue:(accPDRowId'=myInitPDDR)
		set myPDAmt=$p(myPDData,"^",2)
		set refableAmt=$i(refableAmt,myPDAmt)
	}
	
	set refableAmt=$s((+refableAmt>+accMLeft):accMLeft,1:refableAmt)   //跟账户余额比较，取小
	
	quit $fn(refableAmt,"",2)
}

/// Creator: tangzf
/// CreatDate: 2023-02-06
/// Description: 获取单次充值上限配置金额(单位:元)
/// Input: hospId: CT_Hospital.RowId
/// Return: 配置的充值上限金额
/// Others: 通用配置-门诊收费系统-门诊收预交金-单次充值上限
/// Debug: w ##class(web.UDHCAccAddDeposit).GetSinglePayCfg(2)
ClassMethod GetSinglePayCfg(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.PreDepPay.DCCZSX", "", "", hospId)
	set maxAmt=##class(%DynamicObject).%FromJSON(jsonStr).value
	quit maxAmt
}

/// Creator: WangXQ
/// CreatDate: 2023-04-12
/// Description: 根据卡类型判断该卡是否只能充值不能退款
/// Input: cardTypeId:, DHC_CardTypeDef.RowId, hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-门诊收费系统-门诊预交金退款-只能充值不能退款的卡类型
/// Debug: w ##class(web.UDHCAccAddDeposit).IsAllowedRefDepByCardType(1, 2)
ClassMethod IsAllowedRefDepByCardType(cardTypeId As %String, hospId As %String) As %String
{
	set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultByRelaCodeForQuery")
	do rset.Execute("OPCHRG.PreDepRefd.ZNCZBNTKDKLX", "", cardTypeId, hospId)
	quit rset.Next()
}

}
