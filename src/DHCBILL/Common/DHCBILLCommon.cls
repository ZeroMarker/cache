Import SQLUser

Class DHCBILL.Common.DHCBILLCommon Extends BILL.COM.Abstract
{

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 保存子表信息关联业务表
/// Input: ETPRowID: 订单表ID, HisPrtStr: 业务表ID"!"分隔, TradeType: 业务类型
/// Return: 
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).RelationOrderToHIS("162", "328", "PE")
ClassMethod RelationOrderToHIS(ETPRowID As %String, HisPrtStr As %String, TradeType As %String) As %String
{
	set $zt="ERROR"
		 
	quit:(ETPRowID="") -1_"^"_"订单号为空，关联订单失败"
	quit:(HisPrtStr="") -1_"^"_"业务ID为空，关联订单失败"
	quit:(TradeType="") -1_"^"_"业务类型为空，关联订单失败"
	
	set ETPData=$g(^DHCBILLETP(ETPRowID))
	
	set PayModeDR=$p(ETPData,"^",45)
	quit:(PayModeDR="") -1_"^"_"订单支付方式数据错误，关联订单失败"
	
	set ExtTradeType=$p(ETPData,"^",26)   //ETP_ExtTradeType
	if (ExtTradeType="C") {
		set ETPRc=$p(ETPData,"^",1)
		set ETPRcDetail=$p(ETPData,"^",2)
		quit:(ETPRc'="00") -1_"^"_"订单"_ETPRcDetail_"，关联订单失败"
	}
	
	set rtn=0
	
	ts
	
	//更新订单表
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_Status = 'Y', ETP_HisPrtStr = :HisPrtStr
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//插子表(DHC_BillExtTradeConSub)
	set InvCount=$l(HisPrtStr,"!")
	for i=1:1:InvCount {
		set myPrtRowId=$p(HisPrtStr,"!",i)
		continue:(+myPrtRowId=0)
		set ConsultStatus=$case(ExtTradeType,"C":"N","D":"A","T":"A",:"")   //对应业务记录的状态
		if ((" D T "[(" "_ExtTradeType_" "))&&(i=InvCount)) {
			set ConsultStatus="N"
		}
		set myPayModeDR=..GetPrtPayMSubRowID(myPrtRowId, TradeType, PayModeDR)
		/*
		if (myPayModeDR="") {
			set rtn=-1_"^"_"支付方式为空"  //支付方式指针为空了是否保存？
			quit
		}
		*/
		&SQL(
			INSERT INTO DHC_BillExtTradeConSub (
				ETC_ETP_ParRef, ETC_HISPRT_DR, ETC_ConsultStatus, ETC_PRTPayMode_DR, ETC_Status,
				ETC_TradeType
			)
			VALUES (
				:ETPRowID, :myPrtRowId, :ConsultStatus, :myPayModeDR, 'N',
				:TradeType
			)
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 根据业务类型获取支付方式金额合计
/// Input: TradeType:业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,PE:体检收费,PEDeposit:体检预交金,EPDeposit:留观押金)
/// 	   HisPrtStr:业务表ID "!" 分隔, PayMode:支付方式
/// Return: 金额合计(可能负数)
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetChargeAmt("OP", )
ClassMethod GetChargeAmt(TradeType As %String, HisPrtStr As %String, PayMode As %String) As %String
{
	set PaySum=0
	quit:(PayMode="") PaySum
	
	set InvCount=$l(HisPrtStr,"!")
	
	set FmtTradeType=" "_$zcvt(TradeType,"U")_" "
	
	//挂号、门诊收费
	if (" OP REG "[FmtTradeType) {
		//DHC_INVPayMode
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set Sub=$o(^DHCINVPRTi(0,"PMDR",RowID,PayMode,"P",0))
			continue:(+Sub=0)
			set PayMData=$g(^DHCINVPRT(RowID,"P",Sub))
			continue:(PayMData="")
			set PayMAmt=$p(PayMData,"^",3)
			set PaySum=PaySum+PayMAmt
		}
	}
		
	//卡费
	if (" CARD "[FmtTradeType) {
		//DHC_CardINVPRTPayMode
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set Sub=0
			while($o(^DHCCARDINVPRT(RowID,"P",Sub))) {
				set Sub=$o(^DHCCARDINVPRT(RowID,"P",Sub))
				set PayMData=$g(^DHCCARDINVPRT(RowID,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				continue:(PayMDR'=PayMode)
				set PayMAmt=$p(PayMData,"^",3)
				set PaySum=PaySum+PayMAmt
			}
		}
	}
	
	//线上医保收费
	if (" INSU "[FmtTradeType) {
		//DHC_INVPRTInsuPaym
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set Sub=0
			while($o(^DHCINVPRTInsu(RowID,"P",Sub))) {
				set Sub=$o(^DHCINVPRTInsu(RowID,"P",Sub))
				set PayMData=$g(^DHCINVPRTInsu(RowID,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				continue:(PayMDR'=PayMode)
				set PayMAmt=$p(PayMData,"^",2)
				set PaySum=PaySum+PayMAmt
			}
		}
	}
	
	//住院收费
	if (" IP "[FmtTradeType) {
		//DHC_INVPRTZYPayMode
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set Sub=$o(^DHCINVPRTZYi(0,"PMDR",RowID,PayMode,"P",0))
			continue:(+Sub=0)
			set PayMData=$g(^DHCINVPRTZY(RowID,"P",Sub))
			continue:(PayMData="")
			set PayMAmt=$p(PayMData,"^",3)
			set PaySum=PaySum+PayMAmt
		}
	}
	
	//住院押金
	if (" DEP "[FmtTradeType) {
		//dhc_sfprintdetailpaymode
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set Sub=$o(^DHCSFPRINTDETAIL(0,"PMDR",RowID,PayMode,"P",0))
			continue:(+Sub=0)
			set PayMData=$g(^DHCSFPRINTDETAIL(RowID,"P",Sub))
			continue:(PayMData="")
			set PayMAmt=$p(PayMData,"^",3)
			set PaySum=PaySum+PayMAmt
		}
	}
	
	//门诊预交金
	if (" PRE "[FmtTradeType) {
		//DHC_AccPrePayMode
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set AccM=+RowID
			set PDSub=$p(RowID,"||",2)
			set Sub=0
			while($o(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))) {
				set Sub=$o(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))
				set PayMData=$g(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				continue:(PayMDR'=PayMode)
				set PayMAmt=$p(PayMData,"^",6)
				set PaySum=PaySum+PayMAmt
			}
		}
	}
	
	//留观押金
	if (" EPDEP "[FmtTradeType) {
		//DHC_EPPrePayMode
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set EPM=+RowID
			set PDSub=$p(RowID,"||",2)
			set Sub=0
			while($o(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))) {
				set Sub=$o(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))
				set PayMData=$g(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				continue:(PayMDR'=PayMode)
				set PayMAmt=$p(PayMData,"^",6)
				set PaySum=PaySum+PayMAmt
			}
		}
	}
	
	//体检收费
	if (" PE "[FmtTradeType) {
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set Rcp=$p(^DHCPEINVPRT(RowID),"^",4)    //DHC_PE_INVPRT.PRT_ARRCP_DR
			//AR_RcptPayMode
			set Sub=0
			while($o(^ARRCP(Rcp,"PAYM",Sub))) {
				set Sub=$o(^ARRCP(Rcp,"PAYM",Sub))
				set PayMData=$g(^ARRCP(Rcp,"PAYM",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				continue:(PayMDR'=PayMode)
				set PayMAmt=$p(PayMData,"^",3)
				set PaySum=PaySum+PayMAmt
			}
		}
	}
	
	//体检预交金
	if (" PEDEP "[FmtTradeType) {
		//DHC_PE_APAmountChange
		for i=1:1:InvCount {
			set RowID=$p(HisPrtStr,"!",i)
			continue:(+RowID=0)
			set PEAPRowID=+RowID
			set APSub=+$p(RowID,"||",2)
			set APACData=$g(^DHCPEAP(PEAPRowID,"AC",APSub))
			continue:(APACData="")
			set PayMDR=$p(APACData,"^",10)
			continue:(PayMDR'=PayMode)
			set PayMAmt=$p(APACData,"^",2)
			set PaySum=PaySum+PayMAmt
		}
	}
	
	set PaySum=$fn(PaySum,"",2)
	quit PaySum
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 根据业务类型获取支付方式金额合计(用于第三方接口计算退费金额)
/// Input:  TradeType:业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,PE:体检收费,PEDeposit:体检预交金,EPDeposit:留观押金)		
/// 		HisPrtStr:业务表ID !分隔, PayMode:支付方式
/// 		Amt:传入金额(对应出院结算退押金和门诊退账户,金额已传入金额为准)
/// Return: 金额合计
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetRefundAmt("OP","223698","223699",47,"")
ClassMethod GetRefundAmt(TradeType As %String, AbortPrtRowID As %String, NewPrtRowID As %String, PayMode As %String, Amt As %String = "")
{
	set RetAmt=0
	if (" IP DEP "[(" "_TradeType_" ")) {
		if (+Amt'=0) {
			set RetAmt=Amt
		}else {
			set HisPrtStr=AbortPrtRowID_"!"_NewPrtRowID
			set RetAmt=..GetChargeAmt(TradeType, HisPrtStr, PayMode)
		}
	}else {
		set HisPrtStr=AbortPrtRowID_"!"_NewPrtRowID
		set RetAmt=..GetChargeAmt(TradeType, HisPrtStr, PayMode)
	}
	
	set RetAmt=$fn($zabs(RetAmt),"",2)
	quit RetAmt
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Modify: ZhYW 2022-09-21
/// Descripiton: 获取业务表支付方式子表RowId
/// Input: TradeType:业务类型, HisPrtStr:业务表ID"!"分隔, PayMode:支付方式
/// Return: 支付方式表rowId
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetPrtPayMSubRowID("327","PE","47")
ClassMethod GetPrtPayMSubRowID(PrtRowId As %String, TradeType As %String, PayMId As %String) As %String
{
	set PayModeSubDR=""
	quit:((PrtRowId="")||(TradeType="")) PayModeSubDR
	
	set FmtTradeType=" "_$zcvt(TradeType,"U")_" "
	
	//挂号、门诊收费
	if (" OP REG "[FmtTradeType) {
		//DHC_INVPayMode
		set Sub=$o(^DHCINVPRTi(0,"PMDR",PrtRowId,PayMId,"P",0))
		quit:(+Sub=0) PayModeSubDR
		set PayModeSubDR=PrtRowId_"||"_Sub
		quit PayModeSubDR
	}
	
	//卡费
	if (" CARD "[FmtTradeType) {
		//DHC_CardINVPRTPayMode
		set Sub=0
		while($o(^DHCCARDINVPRT(PrtRowId,"P",Sub))) {
			set Sub=$o(^DHCCARDINVPRT(PrtRowId,"P",Sub))
			set PayMData=$g(^DHCCARDINVPRT(PrtRowId,"P",Sub))
			continue:(PayMData="")
			set PayMDR=$p(PayMData,"^",1)
			continue:(PayMDR'=PayMId)
			set PayModeSubDR=PrtRowId_"||"_Sub
		}
		quit PayModeSubDR
	}
	
	//线上医保收费
	if (" INSU "[FmtTradeType) {
		//DHC_INVPRTInsuPaym
		set Sub=0
		while($o(^DHCINVPRTInsu(PrtRowId,"P",Sub))) {
			set Sub=$o(^DHCINVPRTInsu(PrtRowId,"P",Sub))
			set PayMData=$g(^DHCINVPRTInsu(PrtRowId,"P",Sub))
			continue:(PayMData="")
			set PayMDR=$p(PayMData,"^",1)
			continue:(PayMDR'=PayMId)
			set PayModeSubDR=PrtRowId_"||"_Sub
		}
		quit PayModeSubDR
	}
	
	//住院收费
	if (" IP "[FmtTradeType) {
		//DHC_INVPRTZYPayMode
		set Sub=$o(^DHCINVPRTZYi(0,"PMDR",PrtRowId,PayMId,"P",0))
		quit:(+Sub=0) PayModeSubDR
		set PayModeSubDR=PrtRowId_"||"_Sub
		quit PayModeSubDR
	}
	
	//住院押金
	if (" DEP "[FmtTradeType) {
		//dhc_sfprintdetailpaymode
		set Sub=$o(^DHCSFPRINTDETAIL(0,"PMDR",PrtRowId,PayMId,"P",0))
		quit:(+Sub=0) PayModeSubDR
		set PayModeSubDR=PrtRowId_"||"_Sub
		quit PayModeSubDR
	}
	
	//门诊预交金
	if (" PRE "[FmtTradeType) {
		//DHC_AccPrePayMode
		set AccM=+PrtRowId
		set PDSub=$p(PrtRowId,"||",2)
		set Sub=0
		while($o(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))) {
			set Sub=$o(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))
			set PayMData=$g(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))
			continue:(PayMData="")
			set PayMDR=$p(PayMData,"^",1)
			continue:(PayMDR'=PayMId)
			set PayModeSubDR=AccM_"||"_PDSub_"||"_Sub
		}
		quit PayModeSubDR
	}
	
	//留观押金
	if (" EPDEP "[FmtTradeType) {
		//DHC_EPPrePayMode
		set EPM=$p(PrtRowId,"||",1)
		set PDSub=$p(PrtRowId,"||",2)
		set Sub=0
		while($o(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))) {
			set Sub=$o(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))
			set PayMData=$g(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))
			continue:(PayMData="")
			set PayMDR=$p(PayMData,"^",1)
			continue:(PayMDR'=PayMId)
			set PayModeSubDR=EPM_"||"_PDSub_"||"_Sub
		}
		quit PayModeSubDR
	}
	
	//体检收费
	if (" PE "[FmtTradeType) {
		//DHC_EPPrePayMode
		set Rcp=$p(^DHCPEINVPRT(PrtRowId),"^",4)    //DHC_PE_INVPRT.PRT_ARRCP_DR
		//AR_RcptPayMode
		set Sub=0
		while($o(^ARRCP(Rcp,"PAYM",Sub))) {
			set Sub=$o(^ARRCP(Rcp,"PAYM",Sub))
			set PayMData=$g(^ARRCP(Rcp,"PAYM",Sub))
			continue:(PayMData="")
			set PayMDR=$p(PayMData,"^",1)
			continue:(PayMDR'=PayMId)
			set PayModeSubDR=Rcp_"||"_Sub
		}
		quit PayModeSubDR
	}
	
	//体检预交金
	if (" PEDEP "[FmtTradeType) {
		//DHC_PE_APAmountChange
		set PayModeSubDR=PrtRowId
		quit PayModeSubDR
	}
	
	quit PayModeSubDR
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 根据支付方式ID取配置表
/// Input: PayMode: 支付方式ID
/// Return: 支付方式扩展表字段(调用标志、调用方法、调用方式、退费标志)
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(46)
ClassMethod GetCallModeByPayMode(PayMode As %String) As %String
{
	set PayModeStr=""
	set PMEHardComDR=""
	set PMEClassName=""
	set PMECallMode=""
	set PMERefundFlag=""
	if (PayMode'="") {
		set HardRowID=$o(^User.DHCCTPayModeExpI("PMEPayModeIDIndex",$zu(28,PayMode,7),0))
		if (HardRowID'="") {
			set PMEData=$g(^User.DHCCTPayModeExpD(HardRowID))
			set PMEHardComDR=$lg(PMEData,3)
			set PMEClassName=$lg(PMEData,2)
			set PMECallMode=$lg(PMEData,4)
			set PMERefundFlag=$lg(PMEData,10)
		}
	}
	set PayModeStr=+PMEHardComDR_"^"_PMEClassName_"^"_PMECallMode_"^"_PMERefundFlag
		
	quit PayModeStr
}

/// Creator: Lid
/// CreatDate: 2011-03-23
/// Descripiton: 第三方交易失败后，更新支付方式按现金结算
/// Modify: ZhYW 2020-09-28
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).UpdateCARDToCASH(4555)
ClassMethod UpdateCARDToCASH(prtRowIdStr As %String) As %String
{
	set $zt="ERROR"
    set rtn=0
    
	set toPayMId=..GetPayMDrByPayMCode("CASH")
	
    ts
    
    for i=1:1:$l(prtRowIdStr,"^") {
	    set prtRowId=$p(prtRowIdStr,"^",i)
	    continue:(+prtRowId=0)
	    set paymSub=""
	    while($o(^DHCINVPRT(prtRowId,"P",paymSub),-1)&&(rtn=0)) {
		    set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub),-1)
		    set paymSubData=$g(^DHCINVPRT(prtRowId,"P",paymSub))
		    set selfFlag=$p(paymSubData,"^",12)	//自费标志(1:自费，0/空:医保)
		    continue:(+selfFlag'=1)
		    set payMDR=$p(paymSubData,"^",1)
		    set hardComFlag=..GetCallModeByPayMode(payMDR)
		    continue:(+hardComFlag=0)
		    set paymRowId=prtRowId_"||"_paymSub
		  	&SQL(
		    	UPDATE DHC_INVPayMode
		    	SET IPM_PayMode_DR = :toPayMId
		    	WHERE %ID = :paymRowId
		    )
		    set rtn=SQLCODE
		    if (+rtn) {
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

/// Creator: Lid
/// CreatDate: 2011-03-23
/// Description: 根据支付方式代码获取支付方式RowId
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetPayMDrByPayMCode("CASH")
ClassMethod GetPayMDrByPayMCode(paymCode As %String) As %String
{
	quit:(paymCode="") ""
	set paymCode=$$ALPHAUP^SSUTIL4(paymCode)
	quit $o(^CT("CTPM",0,"Code",paymCode,0))
}

/// Description: 判断是否走新的支付平台
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetPayServicePayMode(30,43696085,"OP")
ClassMethod GetPayServicePayMode(PayMode As %String, HisPrtStr As %String, TradeType As %String) As %String
{
	set PayServiceFlag="N"
	set PayModeCode=""
	set PayServiceInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMode)
	if (PayServiceInfo'="") {
		set PMEClassName =$p(PayServiceInfo,"^",2)
		if (PMEClassName'="") {
			set PayServiceFlag="Y"
			set PayModeCode=$p(^CT("CTPM",PayMode),"^",1)
		}
	}
	
	if ((TradeType="OP")&&(PayServiceFlag'="Y")) {
		set InvCount=$l(HisPrtStr,"^")
		for i=1:1:InvCount quit:(PayServiceFlag'="N")  do
		.set myPrtRowId=$p(HisPrtStr,"^",i)
		.quit:(+myPrtRowId=0)
		.set IPMSub=0
		.for  set IPMSub=$o(^DHCINVPRT(myPrtRowId,"P",IPMSub)) quit:((IPMSub="")||(PayServiceFlag'="N"))  do
		..set IPMPayMode=$p(^DHCINVPRT(myPrtRowId,"P",IPMSub),"^",1)	
		..set PayServiceInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(IPMPayMode)
		..if (PayServiceInfo'="") do
		..set PMEClassName =$p(PayServiceInfo,"^",2)
		..if (PMEClassName'="") do
		...set PayServiceFlag="Y"
		...set PayMode=IPMPayMode
		...set PayModeCode=$p(^CT("CTPM",PayMode),"^",1)
	}
	
	quit PayServiceFlag_"^"_PayMode_"^"_PayModeCode
}

/// Description: 作废HIS订单
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).VoidExtTradeNo()
ClassMethod VoidExtTradeNo(OrderNo As %String) As %String
{
	set rtn=0
	quit:(OrderNo="") 1
	set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OrderNo,0))
	quit:(ETPRowID="") 1
	set Rc=$p(^DHCBILLETP(ETPRowID),"^",1)
	quit:(Rc="04") 0
	quit:(" 01 03 "'[(" "_Rc_" ")) 1
	
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_Rc = '04', ETP_Rc_Detail = '订单作废'
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-02-05
/// Descripiton: 获取配置的支付方式代码串
/// Input: expStr: 预留(CT_Hospital.RowId^)
/// Return: pmCodeStr:支付方式代码串
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetCallPMCodeStr("")
ClassMethod GetCallPMCodeStr(expStr As %String = "") As %String
{
	set hospId=$p(expStr,"^",1)
	
	set pmCodeStr=""
	set id=0
	while($o(^User.DHCCTPayModeExpD(id))) {
		set id=$o(^User.DHCCTPayModeExpD(id))
		set data=$g(^User.DHCCTPayModeExpD(id))
		continue:(data="")
		set hardComDR=$lg(data,3)
		continue:(+hardComDR=0)
		set pmDR=$lg(data,7)
		continue:(+pmDR=0)
		set pmCode=$p($g(^CT("CTPM",pmDR)),"^",1)
		continue:(("^"_pmCodeStr_"^")[("^"_pmCode_"^"))
		set pmCodeStr=$s((pmCodeStr=""):pmCode,1:(pmCodeStr_"^"_pmCode))
	}
	quit pmCodeStr
}

/// Creator: xiongwang
/// CreatDate: 2022-03-01
/// Descripiton: 判断订单是否可撤销
/// Input: OrgETPRowID:订单表ID
/// Return:	0:可以撤销，<>0:不可撤销
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetCanRevokeFlag(52310)
ClassMethod GetCanRevokeFlag(ETPRowID As %String) As %String
{
	set rtn=0
	quit:(+ETPRowID=0) -1_"^"_"参数错误"
	
	set ETPData=$g(^DHCBILLETP(ETPRowID))
	set ETPStatus=$p(ETPData,"^",18)
	quit:(ETPStatus="Y") -1_"^"_"HIS业务成功，不能撤销"
	
	set ExtTradeType=$p(ETPData,"^",26)
    quit:(" C "'[(" "_ExtTradeType_" ")) -1_"^"_"非支付订单，不能撤销"
	
	set TradeType=$p(ETPData,"^",25)   //ETP_TradeType
	if ((" REG OP ")[(" "_TradeType_" ")) {
		set ETCSub=0
		while($o(^DHCBILLETP(ETPRowID,"C",ETCSub))) {
			set ETCSub=$o(^DHCBILLETP(ETPRowID,"C",ETCSub))
			set ETCSubData=$g(^DHCBILLETP(ETPRowID,"C",ETCSub))
			set PrtRowId=$p(ETCSubData,"^",1)
			continue:(+PrtRowId=0)
			set PrtFlag=$p($g(^DHCINVPRT(PrtRowId)),"^",8)
			continue:(PrtFlag="TP")
			set rtn=-1_"^"_"HIS业务成功，不能撤销"
			quit
		}
	}
	quit:(+rtn) rtn
	
	set ETPRowID=0
	while($o(^DHCBILLETPi(0,"OldTradeDR",+ETPRowID,ETPRowID))) {
		set ETPRowID=$o(^DHCBILLETPi(0,"OldTradeDR",+ETPRowID,ETPRowID))
		set ETPData=$g(^DHCBILLETP(ETPRowID))
		set ETPRc=$p(ETPData,"^",1)
		if (ETPRc="00"){
			set rtn=1_"^"_"该订单已撤销成功，不能重复撤销"
			quit
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-09-15
/// Descripiton: 根据订单表RowID获取第三方支付方式ID
/// Input: ETPRowID: DHC_BillExtTradePay.RowId
/// Return: CT_PayMode.RowId
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetETPPayModeID(271)
ClassMethod GetETPPayModeID(ETPRowID As %String) As %String
{
	set PayModeDR=""
	quit:(+ETPRowID=0) PayModeDR
	set PayModeDR=$p($g(^DHCBILLETP(ETPRowID)),"^",45)   //ETP_PayMode
	quit PayModeDR
}

/// Creator: ZhYW
/// CreatDate: 2022-09-17
/// Description: 根据id获取类属性值(返回json对象)
/// Input: clsName:类名
/// Return: 
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetClsPropJsonO("User.DHCBillExtTradePay")
ClassMethod GetClsPropJsonO(clsName As %String) As %DynamicObject
{
	set json=##class(%DynamicObject).%New()
	set obj=##class(%Dictionary.CompiledClass).%OpenId(clsName, 0)
	quit:('$isObject(obj)) json
	for i=1:1:obj.Properties.Count() {
		set property=obj.Properties.GetAt(i)
		continue:(property.Cardinality'="")  //过滤父、子属性
		set name=property.Name
		continue:($e(name,1)="%")
		do json.%Set(name, "")
	}
	quit json
}

/// Creator: ZhYW
/// CreatDate: 2022-09-16
/// Descripiton: 保存交易信息
/// Input: ETPRowID:订单表ID，OutputObj:格式化后的交易返回Json对象
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).SaveExtPayInfo()
ClassMethod SaveExtPayInfo(ETPRowID As %String, OutputObj As %DynamicObject) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	ts
	
	set dataObj=##class(User.DHCBillExtTradePay).%OpenId(ETPRowID, 0)
	
	if ('$isObject(dataObj)) {
		quit -1_"^"_"创建对象失败"
	}
	if (OutputObj.ETPRc'="") {
		set dataObj.ETPRc=OutputObj.ETPRc
	}
	if (OutputObj.ETPRcDetail'="") {
		set dataObj.ETPRcDetail=OutputObj.ETPRcDetail
	}
	if (OutputObj.ETPPan'="") {
		set dataObj.ETPPan=OutputObj.ETPPan
	}
	if (OutputObj.ETPExtAmt'="") {
		set dataObj.ETPExtAmt=OutputObj.ETPExtAmt
	}
	if (OutputObj.ETPVoucherNo'="") {
		set dataObj.ETPVoucherNo=OutputObj.ETPVoucherNo
	}
	if (OutputObj.ETPInvoiceNo'="") {
		set dataObj.ETPInvoiceNo=OutputObj.ETPInvoiceNo
	}
	if (OutputObj.ETPRRN'="") {
		set dataObj.ETPRRN=OutputObj.ETPRRN
	}
	if (OutputObj.ETPAuthNo'="") {
		set dataObj.ETPAuthNo=OutputObj.ETPAuthNo
	}
	if (OutputObj.ETPTerminalNo'="") {
		set dataObj.ETPTerminalNo=OutputObj.ETPTerminalNo
	}
	if (OutputObj.ETPMerchNo'="") {
		set dataObj.ETPMerchNo=OutputObj.ETPMerchNo
	}
	if (OutputObj.ETPBatchNo'="") {
		set dataObj.ETPBatchNo=OutputObj.ETPBatchNo
	}
	if (OutputObj.ETPTellerNo'="") {
		set dataObj.ETPTellerNo=OutputObj.ETPTellerNo
	}
	if (OutputObj.ETPBankName'="") {
		set dataObj.ETPBankName=OutputObj.ETPBankName
	}
	if (OutputObj.ETPExtDate'="") {
		set dataObj.ETPExtDate=OutputObj.ETPExtDate
	}
	if (OutputObj.ETPExtTime'="") {
		set dataObj.ETPExtTime=OutputObj.ETPExtTime
	}
	if (OutputObj.ETPExpDate'="") {
		set dataObj.ETPExpDate=OutputObj.ETPExpDate
	}
	if (OutputObj.ETPAppendInfo'="") {
		set dataObj.ETPAppendInfo=OutputObj.ETPAppendInfo
	}
	if (OutputObj.ETPStatus'="") {
		set dataObj.ETPStatus=OutputObj.ETPStatus
	}
	if (OutputObj.ETPInitTradePayDR'="") {
		do dataObj.ETPInitTradePayDRSetObjectId(OutputObj.ETPInitTradePayDR)
	}
	if (OutputObj.ETPOldTradePayDR'="") {
		do dataObj.ETPOldTradePayDRSetObjectId(OutputObj.ETPOldTradePayDR)
	}
	if (OutputObj.ETPTradeDate'="") {
		set dataObj.ETPTradeDate=OutputObj.ETPTradeDate
	}
	if (OutputObj.ETPTradeTime'="") {
		set dataObj.ETPTradeTime=OutputObj.ETPTradeTime
	}
	if (OutputObj.ETPTradeAmt'="") {
		set dataObj.ETPTradeAmt=OutputObj.ETPTradeAmt
	}
	if (OutputObj.ETPTradeUserDR'="") {
		do dataObj.ETPTradeUserDRSetObjectId(OutputObj.ETPTradeUserDR)
	}
	if (OutputObj.ETPTradeType'="") {
		set dataObj.ETPTradeType=OutputObj.ETPTradeType
	}
	if (OutputObj.ETPExtTradeType'="") {
		set dataObj.ETPExtTradeType=OutputObj.ETPExtTradeType
	}
	if (OutputObj.ETPCardType'="") {
		set dataObj.ETPCardType=OutputObj.ETPCardType
	}
	if (OutputObj.ETPHospitalDR'="") {
		do dataObj.ETPHospitalDRSetObjectId(OutputObj.ETPHospitalDR)
	}
	if (OutputObj.ETPCompleteFlag'="") {
		set dataObj.ETPCompleteFlag=OutputObj.ETPCompleteFlag
	}  
	if (OutputObj.ETPCompleteReturnFlag'="") {
		set dataObj.ETPCompleteReturnFlag=OutputObj.ETPCompleteReturnFlag
	}
	if (OutputObj.ETPTradeChannel'="") {
		set dataObj.ETPTradeChannel=OutputObj.ETPTradeChannel
	}
	if (OutputObj.ETPHISTradeID'="") {
		set dataObj.ETPHISTradeID=OutputObj.ETPHISTradeID
	}
	if (OutputObj.ETPHISOldTradeID'="") {
		set dataObj.ETPHISOldTradeID=OutputObj.ETPHISOldTradeID
	}
	if (OutputObj.ETPCompleteReturnDate'="") {
		set dataObj.ETPCompleteReturnDate=OutputObj.ETPCompleteReturnDate
	}
	if (OutputObj.ETPCompleteReturnTime'="") {
		set dataObj.ETPCompleteReturnTime=OutputObj.ETPCompleteReturnTime
	}
	if (OutputObj.ETPOldExtDate'="") {
		set dataObj.ETPOldExtDate=OutputObj.ETPOldExtDate
	}
	if (OutputObj.ETPOldVoucherNo'="") {
		set dataObj.ETPOldVoucherNo=OutputObj.ETPOldVoucherNo
	}
	if (OutputObj.ETPOldRRN'="") {
		set dataObj.ETPOldRRN=OutputObj.ETPOldRRN
	}
	if (OutputObj.ETPOldBatchNo'="") {
		set dataObj.ETPOldBatchNo=OutputObj.ETPOldBatchNo
	}
	if (OutputObj.ETPPAPMIDR'="") {
		do dataObj.ETPPAPMIDRSetObjectId(OutputObj.ETPPAPMIDR)
	}
	if (OutputObj.ETPMerchName'="") {
		set dataObj.ETPMerchName=OutputObj.ETPMerchName
	}
	if (OutputObj.ETPExtCardType'="") {
		set dataObj.ETPExtCardType=OutputObj.ETPExtCardType
	}
	if (OutputObj.ETPAdm'="") {
		do dataObj.ETPAdmSetObjectId(OutputObj.ETPAdm)
	}
	if (OutputObj.ETPInsType'="") {
		do dataObj.ETPInsTypeSetObjectId(OutputObj.ETPInsType)
	}
	if (OutputObj.ETPPayMode'="") {
		do dataObj.ETPPayModeSetObjectId(OutputObj.ETPPayMode)
	}
	if (OutputObj.ETPExtTradeChannel'="") {
		set dataObj.ETPExtTradeChannel=OutputObj.ETPExtTradeChannel
	}
	if (OutputObj.ETPExtTradeNo'="") {
		set dataObj.ETPExtTradeNo=OutputObj.ETPExtTradeNo
	}
	if (OutputObj.ETPHisPrtStr'="") {
		set dataObj.ETPHisPrtStr=OutputObj.ETPHisPrtStr
	}
	if (OutputObj.ETPExtOutString'="") {
		set dataObj.ETPExtOutString=$replace(OutputObj.ETPExtOutString,"^","＾")   //这里将^转为全角＾，防止出现存储结构问题
	}
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-09-20
/// Descripiton: 生成支付订单
/// Input:  TradeType:业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,PE:体检收费,PEDeposit:体检预交金,EPDeposit:留观押金)
/// 		PayModeDR:支付方式
/// 		TradeAmt:交易金额(元)
/// 		ExpStr:扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))
/// Return:	是否成功^订单ID
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).CreatePayOrder("PRE","46","0.01","3^239^2^17275^703^^^^C")
ClassMethod CreatePayOrder(TradeType As %String, PayModeDR As %String, TradeAmt As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("CreatePayOrder")=$lb(TradeType, PayModeDR, TradeAmt, ExpStr)
	
	set HospDR=$p(ExpStr,"^",3)
	set UserId=$p(ExpStr,"^",4)
	set PatientId=$p(ExpStr,"^",5)
	set Adm=$p(ExpStr,"^",6)
	set PrtStr=$p(ExpStr,"^",7)
	
	set rtn=0
	
	ts
	
	//插入订单表
	&SQL(
		INSERT INTO DHC_BillExtTradePay (
			ETP_Rc, ETP_Rc_Detail, ETP_Status, ETP_TradeDate, ETP_TradeTime,
			ETP_TradeAmt, ETP_TradeType, ETP_TradeUser_DR, ETP_ExtTradeType, ETP_Hospital_DR,
			ETP_PAPMI_DR, ETP_Adm, ETP_PayMode, ETP_HisPrtStr
		)
		VALUES (
			'01', '待支付', 'N', CONVERT(DATE, NOW()), CONVERT(TIME, NOW()),
			:TradeAmt, :TradeType, :UserId, 'C', :HospDR,
			:PatientId, :Adm, :PayModeDR, :PrtStr
		)
	)
	set rtn=SQLCODE
	set ETPRowID=$g(%ROWID)
	if (+rtn) tro  quit rtn_"^"_$g(%msg)

	set HisTradeID=..SetTransactionId(ETPRowID, HospDR)	     //生成HIS订单号
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_HISTradeID = :HisTradeID
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc
	
	quit rtn_"^"_ETPRowID

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-09-20
/// Descripiton: 生成退费订单
/// Input:  TradeType: 业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,PE:体检收费,PEDeposit:体检预交金,EPDeposit:留观押金)
/// 		OrgETPRowID: 原收费订单
///         ExtTradeType: 交易类型
/// 		RefAmt: 退费金额(元)
/// 		ExpStr: 扩展串(科室^安全组^院区^操作员ID^业务表指针串(以!分隔,可为空))
/// Return:	是否成功^订单ID
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).CreateRefOrder("OP", 46, 500, "12^23^2^34^1!2")
ClassMethod CreateRefOrder(TradeType As %String, OrgETPRowID As %String, ExtTradeType As %String = "D", RefAmt As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	quit:(+OrgETPRowID=0) -1_"^"_"原支付订单不存在"
	
	set HospDR=$p(ExpStr,"^",3)
	set UserId=$p(ExpStr,"^",4)
	set PrtStr=$p(ExpStr,"^",5)
	
	set OrgETPData=$g(^DHCBILLETP(OrgETPRowID))
	set OldVoucherNo=$p(OrgETPData,"^",5)
	set OldRRN=$p(OrgETPData,"^",7)
	set OldBatchNo=$p(OrgETPData,"^",11)
	set OldExtDate=$p(OrgETPData,"^",14)
	set TradeChannel=$p(OrgETPData,"^",31)
	set HISOldTradeID=$p(OrgETPData,"^",32)
	set PatientId=$p(OrgETPData,"^",40)
	set Adm=$p(OrgETPData,"^",43)
	set PayModeDR=$p(OrgETPData,"^",45)
	set ExtChannel=$p(OrgETPData,"^",46)
	
	set rtn=0
	set ETPRowID=""
	
	//已经生成待退款的订单不再新生成
	if (PrtStr'="") {
		set InvCount=$l(PrtStr,"!")
		for i=1:1:InvCount {
			set PrtRowId=$p(PrtStr,"!",i)
			continue:(+PrtRowId=0)
			set myETPRowID=$o(^DHCBILLETPi(0,"TTypePRT",TradeType,"PRT",PrtRowId,0))
			continue:(+myETPRowID=0)
			set myETPData=$g(^DHCBILLETP(+myETPRowID))
			continue:(myETPData="")
		    set ETPRc=$p(myETPData,"^",1)
		    continue:(ETPRc'="03")    //过滤不是"待退款"的订单
		  	set ETPRowID=myETPRowID
		  	quit
		}
		quit:(+ETPRowID) rtn_"^"_ETPRowID    //返回已经生成待退款的订单
	}
	
	ts
	
	//插入订单表
	&SQL(
		INSERT INTO DHC_BillExtTradePay (
			ETP_Rc, ETP_Rc_Detail, ETP_Status, ETP_OldTradePay_DR, ETP_TradeDate,
			ETP_TradeTime, ETP_TradeAmt, ETP_TradeType, ETP_TradeUser_DR, ETP_ExtTradeType,
			ETP_Hospital_DR, ETP_TradeChannel, ETP_HISOldTradeID, ETP_OldExtDate, ETP_OldVoucher_No,
			ETP_OldRRN, ETP_OldBatch_No, ETP_PAPMI_DR, ETP_Adm, ETP_PayMode,
			ETP_ExtTradeChannel, ETP_HisPrtStr
		)
		VALUES (
			'03', '待退款', 'N', :OrgETPRowID, CONVERT(DATE, NOW()),
			CONVERT(TIME, NOW()), :RefAmt, :TradeType, :UserId, :ExtTradeType,
			:HospDR, :TradeChannel, :HISOldTradeID, :OldExtDate, :OldVoucherNo,
			:OldRRN, :OldBatchNo, :PatientId, :Adm, :PayModeDR,
			:ExtChannel, :PrtStr
		)
	)
	set rtn=SQLCODE
	set ETPRowID=$g(%ROWID)
	if (+rtn) tro  quit rtn_"^"_$g(%msg)

	set HisTradeID=..SetTransactionId(ETPRowID, HospDR)	   //生成HIS端订单号
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_HISTradeID = :HisTradeID
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//直接关联发票
	if (PrtStr'="") {
		set rtnValue=..RelationOrderToHIS(ETPRowID, PrtStr, TradeType)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
	
	if ($tl>0) tc
	
	quit rtn_"^"_ETPRowID
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 20122-09-20
/// Descritpion: 生成HIS的唯一交易号(20位,医院编号(4)+日期(6)+时间(4)+银行交易信息表RowId(6))
/// Input: ETPRowID:订单ID, HospDR:院区ID
/// Return: HIS的唯一交易号
/// Other: 
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).SetTransactionId(222, 2)
ClassMethod SetTransactionId(ETPRowID As %String, HospDR As %String) As %String
{
	set HospCode=##class(BILL.Util.Tools).FormatNO(+HospDR, 4)
	set CurrDate=$e($zd(+$h,8),3,*)
	set CurrTime=$tr($zt($p($h,",",2),2),":","")
	set FormatETPRowID=##class(BILL.Util.Tools).FormatNO(+ETPRowID, 6)
	set rtn=HospCode_CurrDate_CurrTime_FormatETPRowID
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-09-16
/// Descripiton: 业务类型转换为订单类型描述
/// Input: BizType:业务类型代码
/// Return: 订单类型描述
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetOrderTypeDescByBizType("OP")
ClassMethod GetOrderTypeDescByBizType(BizType As %String)
{
	set json=##class(%DynamicObject).%New()
	set json.REG="挂号"
	set json.OP="门诊收费"
	set json.IP="住院收费"
	set json.DEP="住院押金"
	set json.PRE="门诊预交金"
	set json.CARD="卡费"
	set json.INSU="线上医保收费"
	set json.PE="体检收费"
	set json.PEDEP="体检预交金"
	set json.EPDEP="留观押金"
	do json.%Close()
	set orderType=json.%Get($zcvt(BizType,"U"))
	quit $s((orderType'=""):orderType,1:"其他")   //未定义的返回"其他"
}

/// Creator: ZhYW
/// CreatDate: 2022-09-22
/// Descripiton: 根据原票和原业务类型获取收费订单ID
/// Input: TradeType:业务类型, InitPrtRowID:业务原始ID, AbortPrtRowID:业务负票ID, NewPrtRowID:业务新票ID
///        OrgTradeType:原业务类型(交叉业务时使用)
/// Return: 原收费订单ID
/// Others: 1. 出院结算退款业务:
///               InitPrtRowID:退结算支付款时为DHC_INVPRTZY.RowId，退押金时为dhc_sfprintdetail.RowId
///               AbortPrtRowID:结算发票DHC_INVPRTZY.RowId, NewPrtRowID:空
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetPendingRefData("IP","1878||1","","924","DEP")
ClassMethod GetPendingRefData(TradeType As %String, InitPrtRowID As %String, AbortPrtRowID As %String, NewPrtRowID As %String, OrgTradeType As %String = {TradeType}) As %String
{
	set ^TMP("GetPendingRefData")=$lb(TradeType, InitPrtRowID, AbortPrtRowID, NewPrtRowID, OrgTradeType)
	set AryObj=##class(%DynamicArray).%New()
	quit:(TradeType="") AryObj.%ToJSON()
	quit:(+InitPrtRowID=0) AryObj.%ToJSON()
	
	//+2023-03-02 ZhYW 如果新票收银了，则需要将原票全退(将新票按空处理)
	if (+NewPrtRowID'=0) {
		set PayETPRowId=..GetPayETPIDByPrtMode(TradeType, NewPrtRowID)
		if (PayETPRowId>0) {
			set NewPrtRowID=""
		}
	}
	
	if (+AbortPrtRowID'=0) {
		set PrtRowIdStr=AbortPrtRowID_"!"_NewPrtRowID
		set RefPrtRowId=AbortPrtRowID
	}else {
		set PrtRowIdStr=InitPrtRowID
		set RefPrtRowId=InitPrtRowID
	}
	set PayMJsonObj=..GetPrtPayMSum(TradeType, PrtRowIdStr)
	set iter=PayMJsonObj.%GetIterator()
   	while iter.%GetNext(.key, .value) {
	   	set PayMId=key
	   	set PayMAmt=value           //需退费金额
	   	continue:('(+PayMAmt<0))    //过滤不是退费的数据(正数为收，负数为退)
   		set RefundedSum=..GetPayMRefundedAmt(TradeType, RefPrtRowId, PayMId)   //已退费金额
   		set PendRefAmt=$zabs(PayMAmt)-$zabs(RefundedSum)    //待退费金额
   		continue:('(+PendRefAmt>0))   //过滤无待退费金额的
   		set OrgETPRowID=..GetOrgETPRowIDByPrtMode(OrgTradeType, InitPrtRowID, PayMId)   //退费记录对应的原支付交易
   		continue:(OrgETPRowID="")
   		set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMId)
		set PMECallMode=$p(PayCallInfo,"^",3)
   		set Json=##class(%DynamicObject).%New()
   		set Json.ETPID=OrgETPRowID
   		set Json.PayMID=PayMId
   		set Json.PendRefAmt=$fn(PendRefAmt,"",2)
   		set Json.PayCallMode=PMECallMode
   		do AryObj.%Push(Json)
   		do Json.%Close()
   	}

	quit AryObj.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2022-09-22
/// Descripiton: 根据原票和原业务类型获取收费订单ID
/// Input: TradeType:业务类型, AbortPrtRowID:业务表负票ID, NewPrtRowID:业务表新票ID
/// Return: JSON key:支付方式Id, value:支付方式金额(正式为收，负数为退)
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetPrtPayMSum("2066", "OP")
ClassMethod GetPrtPayMSum(TradeType As %String, PrtRowIDStr As %String) As %DynamicObject
{
	set FmtTradeType=" "_$zcvt(TradeType,"U")_" "
	
	kill PayMAry
	
	//挂号、门诊收费
	if (" OP REG "[FmtTradeType) {
		//DHC_INVPayMode
		for i=1:1:$l(PrtRowIDStr,"!") {
			set RowID=$p(PrtRowIDStr,"!",i)
			continue:(+RowID=0)
			set Sub=0
			while($o(^DHCINVPRT(RowID,"P",Sub))) {
				set Sub=$o(^DHCINVPRT(RowID,"P",Sub))
				set PayMData=$g(^DHCINVPRT(RowID,"P",Sub))
				continue:(PayMData="")
				set IsSelf=$p(PayMData,"^",12)
				continue:(+IsSelf'=1)     //过滤医保支付方式
				set PayMDR=$p(PayMData,"^",1)
				set PayMAmt=$p(PayMData,"^",3)
				set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
				set PayCallFlag=$p(PayCallInfo,"^",1)
				continue:(+PayCallFlag=0)
				set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
			}
		}
	}
	
	//卡费
	if (" CARD "[FmtTradeType) {
		//DHC_CardINVPRTPayMode
		for i=1:1:$l(PrtRowIDStr,"!") {
			set RowID=$p(PrtRowIDStr,"!",i)
			continue:(+RowID=0)
			set Sub=0
			while($o(^DHCCARDINVPRT(RowID,"P",Sub))) {
				set Sub=$o(^DHCCARDINVPRT(RowID,"P",Sub))
				set PayMData=$g(^DHCCARDINVPRT(RowID,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				set PayMAmt=$p(PayMData,"^",3)
				set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
				set PayCallFlag=$p(PayCallInfo,"^",1)
				continue:(+PayCallFlag=0)
				set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
			}
		}
	}
	
	//线上医保收费
	if (" INSU "[FmtTradeType) {
		//DHC_INVPRTInsuPaym
		for i=1:1:$l(PrtRowIDStr,"!") {
			set RowID=$p(PrtRowIDStr,"!",i)
			continue:(+RowID=0)
			set Sub=0
			while($o(^DHCINVPRTInsu(RowID,"P",Sub))) {
				set Sub=$o(^DHCINVPRTInsu(RowID,"P",Sub))
				set PayMData=$g(^DHCINVPRTInsu(RowID,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				set PayMAmt=$p(PayMData,"^",2)
				set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
				set PayCallFlag=$p(PayCallInfo,"^",1)
				continue:(+PayCallFlag=0)
				set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
			}
		}
	}
	
	//住院收费
	if (" IP "[FmtTradeType) {
		//DHC_INVPRTZYPayMode
		for i=1:1:$l(PrtRowIDStr,"!") {
			b ;1
			set RowID=$p(PrtRowIDStr,"!",i)
			b ;2
			continue:(+RowID=0)
			b ;3
			set Sub=0
			while($o(^DHCINVPRTZY(RowID,"P",Sub))) {
				set Sub=$o(^DHCINVPRTZY(RowID,"P",Sub))
				set PayMData=$g(^DHCINVPRTZY(RowID,"P",Sub))
				b ;333
				continue:(PayMData="")
				set transFlag=$p(PayMData,"^",10)
				b ;1111111
				continue:(transFlag="Y")
				set PayMDR=$p(PayMData,"^",1)
				set PayMAmt=$p(PayMData,"^",3)
				set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
				set PayCallFlag=$p(PayCallInfo,"^",1)
				continue:(+PayCallFlag=0)
				set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
			}
		}
	}
	
	//住院押金
	if (" DEP "[FmtTradeType) {
		//dhc_sfprintdetailpaymode
		for i=1:1:$l(PrtRowIDStr,"!") {
			set RowID=$p(PrtRowIDStr,"!",i)
			continue:(+RowID=0)
			set Sub=0
			while($o(^DHCSFPRINTDETAIL(RowID,"P",Sub))) {
				set Sub=$o(^DHCSFPRINTDETAIL(RowID,"P",Sub))
				set PayMData=$g(^DHCSFPRINTDETAIL(RowID,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				set PayMAmt=$p(PayMData,"^",3)
				set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
				set PayCallFlag=$p(PayCallInfo,"^",1)
				continue:(+PayCallFlag=0)
				set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
			}
		}
	}
	
	//门诊预交金
	if (" PRE "[FmtTradeType) {
		//DHC_AccPrePayMode
		for i=1:1:$l(PrtRowIDStr,"!") {
			set RowID=$p(PrtRowIDStr,"!",i)
			continue:(+RowID=0)
			set AccM=+RowID
			set PDSub=$p(RowID,"||",2)
			set Sub=0
			while($o(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))) {
				set Sub=$o(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))
				set PayMData=$g(^DHCACD("AccM",AccM,"AccPD",PDSub,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				set PayMAmt=$p(PayMData,"^",6)
				set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
				set PayCallFlag=$p(PayCallInfo,"^",1)
				continue:(+PayCallFlag=0)
				set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
			}
		}
	}
	
	//留观押金
	if (" EPDEP "[FmtTradeType) {
		//DHC_EPPrePayMode
		for i=1:1:$l(PrtRowIDStr,"!") {
			set RowID=$p(PrtRowIDStr,"!",i)
			continue:(+RowID=0)
			set EPM=+RowID
			set PDSub=$p(RowID,"||",2)
			set Sub=0
			while($o(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))) {
				set Sub=$o(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))
				set PayMData=$g(^DHCEPM("EPM",EPM,"EPMD",PDSub,"P",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				set PayMAmt=$p(PayMData,"^",6)
				set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
				set PayCallFlag=$p(PayCallInfo,"^",1)
				continue:(+PayCallFlag=0)
				set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
			}
		}
	}
	
	//体检收费
	if (" PE "[FmtTradeType) {
		for i=1:1:$l(PrtRowIDStr,"!") {
			set RowID=$p(PrtRowIDStr,"!",i)
			continue:(+RowID=0)
			set Rcp=$p(^DHCPEINVPRT(RowID),"^",4)    //DHC_PE_INVPRT.PRT_ARRCP_DR
			//AR_RcptPayMode
			set Sub=0
			while($o(^ARRCP(Rcp,"PAYM",Sub))) {
				set Sub=$o(^ARRCP(Rcp,"PAYM",Sub))
				set PayMData=$g(^ARRCP(Rcp,"PAYM",Sub))
				continue:(PayMData="")
				set PayMDR=$p(PayMData,"^",1)
				set PayMAmt=$p(PayMData,"^",3)
				set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
				set PayCallFlag=$p(PayCallInfo,"^",1)
				continue:(+PayCallFlag=0)
				set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
			}
		}
	}
	
	//体检预交金
	if (" PEDEP "[FmtTradeType) {
		//DHC_PE_APAmountChange
		for i=1:1:$l(PrtRowIDStr,"!") {
			set RowID=$p(PrtRowIDStr,"!",i)
			continue:(+RowID=0)
			set PEAPRowID=+RowID
			set APSub=+$p(RowID,"||",2)
			set APACData=$g(^DHCPEAP(PEAPRowID,"AC",APSub))
			continue:(APACData="")
			set PayMDR=$p(APACData,"^",10)
			set PayMAmt=$p(APACData,"^",2)
			set PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayMDR)
			set PayCallFlag=$p(PayCallInfo,"^",1)
			continue:(+PayCallFlag=0)
			set PayMAry(PayMDR)=$g(PayMAry(PayMDR))+PayMAmt
		}
	}
	
	set JsonObj=##class(%DynamicObject).%New()
	
	set PayMId=0
	while($o(PayMAry(PayMId))) {
		set PayMId=$o(PayMAry(PayMId))
		set PayMSum=$g(PayMAry(PayMId))
		set PayMSum=$fn(PayMSum,"",2)
		do JsonObj.%Set(PayMId, PayMSum)
	}
    
	quit JsonObj
}

/// Creator: ZhYW
/// CreatDate: 2022-09-22
/// Descripiton: 根据业务类型和原票获取收费订单Id
/// Input: TradeType:业务类型, PrtRowId:原收费业务Id, PayMode:支付方式Id
/// Return: 原收费订单ID
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrtMode("REG", "5023", 47)
ClassMethod GetOrgETPRowIDByPrtMode(TradeType As %String, PrtRowId As %String, PayModeId As %String) As %String
{
	set ETPRowId=""
	quit:((TradeType="")||(PrtRowId="")) ETPRowId
	
	set FmtTradeType=" "_$zcvt(TradeType,"U")_" "
	set myPrtRowId=PrtRowId

	//挂号、门诊收费
	if (" OP REG "[FmtTradeType) {
		do {
			set ETPRowId=..GetPayETPIDByPrtMode(TradeType, myPrtRowId, PayModeId)
			if (ETPRowId="") {
				set myPrtRowId=$p(^DHCINVPRT(myPrtRowId),"^",29)	 //PRT_OldINV_DR
			}
		}while((ETPRowId="")&&(myPrtRowId'=""))
		
		quit ETPRowId
	}
	
	//体检收费
	if (" PE "[FmtTradeType) {
		do {
			set ETPRowId=..GetPayETPIDByPrtMode(TradeType, myPrtRowId, PayModeId)
			if (ETPRowId="") {
				set myPrtRowId=$g(^DHCPEPRT(myPrtRowId,"RefInvID"))
			}
		}while((ETPRowId="")&&(myPrtRowId'=""))
		
		quit ETPRowId
	}
	
	set ETPRowId=..GetPayETPIDByPrtMode(TradeType, myPrtRowId, PayModeId)
	
	quit ETPRowId
}

/// Creator: ZhYW
/// CreatDate: 2022-09-22
/// Descripiton: 根据业务类型和原票获取支付订单Id
/// Table: DHC_BillExtTradeConSub
/// Input: TradeType:业务类型, PrtRowId:收费业务Id, PayMode:支付方式Id
/// Return: 支付订单ID
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetPayETPIDByPrtMode("OP", "2066", )
ClassMethod GetPayETPIDByPrtMode(TradeType As %String, PrtRowId As %String, PayModeId As %String = "") As %String
{
	set ETPRowId=""
	quit:((TradeType="")||(PrtRowId="")) ETPRowId
	
	set myETPId=0
	while($o(^DHCBILLETPi(0,"TTypePRT",TradeType,"PRT",PrtRowId,myETPId))) {
		set myETPId=$o(^DHCBILLETPi(0,"TTypePRT",TradeType,"PRT",PrtRowId,myETPId))
		set myETPData=$g(^DHCBILLETP(+myETPId))
		set myETPPayMDR=$p(myETPData,"^",45)      //ETP_PayMode
		continue:((PayModeId'="")&&(myETPPayMDR'=PayModeId))
		set myETPRc=$p(myETPData,"^",1)
		continue:(myETPRc'="00")
		set myETPExtTradeType=$p(myETPData,"^",26)
		continue:(myETPExtTradeType'="C")
		set ETPRowId=myETPId
		quit
	}
	
	quit ETPRowId
}

/// Creator: ZhYW
/// CreatDate: 2022-09-22
/// Description: 获取第三方支付已退金额
/// Input: TradeType:业务类型, PrtRowId:收费业务Id, PayMode:支付方式Id
/// Return: 
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetPayMRefundedAmt(592,"4")
ClassMethod GetPayMRefundedAmt(TradeType As %String, PrtRowId As %String, PayModeId As %String) As %String
{
	set refundedAmt=0
	quit:((TradeType="")||(PrtRowId="")) refundedAmt
	
	set myETPId=0
	while($o(^DHCBILLETPi(0,"TTypePRT",TradeType,"PRT",PrtRowId,myETPId))) {
		set myETPId=$o(^DHCBILLETPi(0,"TTypePRT",TradeType,"PRT",PrtRowId,myETPId))
		set myETPData=$g(^DHCBILLETP(myETPId))
		set myETPRc=$p(myETPData,"^",1)
		continue:(myETPRc'="00")
		set myETPExtTradeType=$p(myETPData,"^",26)
		continue:(myETPExtTradeType="C")
		set myETPPayMDR=$p(myETPData,"^",45)
		continue:(myETPPayMDR'=PayModeId)
		set tradeAmt=$p(myETPData,"^",23)    //ETP_TradeAmt
		set refundedAmt=$i(refundedAmt, tradeAmt)
	}
	quit $zabs($fn(refundedAmt,"",2))
}

/// Creator: xiongwang
/// CreatDate: 2018-03-07
/// Descripiton: 根据业务支付方式和原业务类型获取收费订单ID
/// Input: ReceipRowID: 业务支付方式, TradeType: 业务类型
/// Return: 原收费订单ID
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrtPayMode("240150||1", "OP")
ClassMethod GetOrgETPRowIDByPrtPayMode(ReceipRowID As %String, TradeType As %String) As %String
{
	set OriginalID=""
	quit:((ReceipRowID="")||(TradeType="")) OriginalID
	set OriginalID=$o(^DHCBILLETPi(0,"TTypePM",TradeType,"PayM",ReceipRowID,""))
	quit OriginalID
}

/// Creator: zhenghao
/// CreatDate: 2023-03-15
/// Descripiton: 根据原业务ID和原业务类型获取收费订单ID可退金额
/// Input: ReceipRowID: 原业务ID, TradeType: 原业务类型
/// Return: 原收费订单ID可退金额, 一个业务多笔订单的有问题
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRefAmtByPrt(1878, "DEP")
ClassMethod GetOrgETPRefAmtByPrt(ReceipRowID As %String, TradeType As %String) As %String
{
	set Sum=0
	quit:((ReceipRowID="")||(TradeType="")) Sum
	
	set OriginalID=..GetOrgETPRowIDByPrtPayMode(ReceipRowID, TradeType)
	quit:(OriginalID="") Sum
	
	set Sum=$p(^DHCBILLETP(OriginalID),"^",23)
	
	set RefETPRowID=0
	while($o(^DHCBILLETPi(0,"OldTradeDR",OriginalID,RefETPRowID))) {
		set RefETPRowID=$o(^DHCBILLETPi(0,"OldTradeDR",OriginalID,RefETPRowID))
		set RefETPData=$g(^DHCBILLETP(RefETPRowID))
		set Rc=$p(RefETPData,"^",1)
		continue:(" 00 03 "'[(" "_Rc_" "))  //？？？Lid 2023-04-18 此处把待待退款订单也按成功计算了，目的是怕如果补算，待退款订单再退款成功就出现单边了
		set refundAmt=$p(RefETPData,"^",23)
		set Sum=Sum-refundAmt
	}
	quit Sum
}

/// Creator: zhenghao	
/// CreatDate: 2023-03-15
/// Descripiton: 获取订单可退金额
/// Input: OriginalID 订单ID
/// Return: 可退金额
/// Debug: w ##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRefAmtByPrt(16250049)
ClassMethod GetETPRefAmtByID(OriginalID As %String) As %String
{
	set Sum=0
	quit:(OriginalID="") Sum
	
	set Sum=$p(^DHCBILLETP(OriginalID),"^",23)
	
	set RefETPRowID=0
	while($o(^DHCBILLETPi(0,"OldTradeDR",OriginalID,RefETPRowID))) {
		set RefETPRowID=$o(^DHCBILLETPi(0,"OldTradeDR",OriginalID,RefETPRowID))
		set RefETPData=$g(^DHCBILLETP(RefETPRowID))
		set Rc=$p(RefETPData,"^",1)
		continue:Rc=("04")    //作废的订单不算 待退费的金额算 
		set refundAmt=$p(RefETPData,"^",23)
		set Sum=Sum-refundAmt
	}
	
	quit Sum
}

}
