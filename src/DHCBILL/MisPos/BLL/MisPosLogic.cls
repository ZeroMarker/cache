Import SQLUser

/// Creator：zfb
/// CreatDate: 2018-03-12
/// Description: MisPos业务处理类
Class DHCBILL.MisPos.BLL.MisPosLogic Extends BILL.COM.Abstract
{

/// Creator：xiongwang
/// CreatDate：2018-03-12
/// Descripiton: 生成订单
/// Input:		tradeType:业务类型(OP,IP,DEP,PRE,CARD,INSU)
/// 			PayModeDR:支付方式(T_PayMode.RowID)
/// 			TradeAmt:交易金额
/// 	 		PosConfig:银行配置信息(银行类型[如比如建行联迪-LD,农行创识-CS]^终端号)
/// 	 		ExpStr:扩展(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
/// Return:		是否成功^订单ID^描述
/// Debug: w ##class(DHCBILL.MisPos.BLL.MisPosLogic).CreatePayOrder("OP",47,"2702.42","POSCS^000123","303^238^2^4632^262^^223671!223672!223673!223674!223675!223676!223677!223678!223679")
ClassMethod CreatePayOrder(TradeType As %String, PayModeDR As %String, TradeAmt As %String, PosConfig As %String, ExpStr As %String)
{
	set $zt="ERROR"
	
	set HospDR=$p(ExpStr,"^",3)
	set Guser=$p(ExpStr,"^",4)
	set PatientId=$p(ExpStr,"^",5)
	set Adm=$p(ExpStr,"^",6)
	set PrtStr=$p(ExpStr,"^",7)      //HIS业务表指针
	
	set TradeChannel=$p(PosConfig,"^",1)
	set TerminalNo=$p(PosConfig,"^",2)
	
	set rtn=0
	
	ts
	
	//创建支付订单
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).CreatePayOrder(TradeType, PayModeDR, TradeAmt, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set ETPRowID=$p(rtnValue,"^",2)
	
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_Terminal_No = :TerminalNo, ETP_TradeChannel = :TradeChannel
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc
	
	quit rtn_"^"_ETPRowID
	
ERROR
	quit ..AppException()
}

/// Creator: xiongwang
/// CreatDate: 2018-03-07
/// Descripiton: 生成退费订单
/// Input:	OrgETPRowID:原收费订单
/// 		TradeType:业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,CANCEL:冲销)
/// 		PayMode:退费方式
/// 		RefAmt:退费金额(元)
/// 	 	PosConfig:银行配置信息(银行类型[如比如建行联迪-LD,农行创识-CS]^终端号)
/// 		ExpStr:扩展串(科室^安全组^院区^操作员ID^业务表指针串(以!分隔,可为空))
/// Return:	是否成功^订单ID^描述  OrgETPRowID,tradeType,payMode,tradeAmt,posConfig,expStr
/// Debug: w ##class(DHCBILL.MisPos.BLL.MisPosLogic).CreateRefOrder("52","OP","31","0.17","T","POSJH^11781045","823^344^3^3881^5814827^^43696679!")
ClassMethod CreateRefOrder(OrgETPRowID As %String, TradeType As %String, PayMode As %String, RefAmt As %String, BankTradeType As %String, PosConfig As %String, ExpStr As %String)
{
	set $zt="ERROR"
	quit:(OrgETPRowID="") -1_"^"_"原支付订单不存在"
	
	set HospDR=$p(ExpStr,"^",3)
	set Guser=$p(ExpStr,"^",4)
	set PrtStr=$p(ExpStr,"^",5)
	
	set TradeChannel=$p(PosConfig,"^",1)
	set TerminalNo=$p(PosConfig,"^",2)

	set rtn=0
	
	ts
	
	//创建订单
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).CreateRefOrder(TradeType, OrgETPRowID, RefAmt, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set ETPRowID=$p(rtnValue,"^",2)
	
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_Terminal_No = :TerminalNo, ETP_ExtTradeType = :BankTradeType, ETP_TradeChannel = :TradeChannel
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn_"^"_ETPRowID

ERROR
	quit ..AppException()
}

/// Creator: xiongwang
/// CreatDate: 2018-03-12
/// Descripiton: 根据订单RowID组织参数
/// Input: ETPRowID：订单ID, ExpStr：扩展信息
/// Debug：w ##class(DHCBILL.MisPos.BLL.MisPosLogic).GetMisPosInput(4,"")
ClassMethod GetMisPosInput(ETPRowID As %String, ExpStr As %String = "")
{
	set $zt="ERROR"
	
	set rtnValue=""
	quit:(ETPRowID="") rtnValue
	set TradeChannel=$p(^DHCBILLETP(ETPRowID),"^",31)
	if (TradeChannel="POSLD") {
		//建行联迪的数据入参整理（根据项目实际银行修改）
		set rtnValue=##class(DHCBILL.MisPos.Adapter.LDMisPos).GetMisPosInput(ETPRowID, ExpStr)
	}elseif (TradeChannel="POSCS") {
		//农行创识的数据入参整理（根据项目实际银行修改）
		set rtnValue=##class(DHCBILL.MisPos.Adapter.CSMisPos).GetMisPosInput(ETPRowID, ExpStr)
	}elseif(TradeChannel="POSJH"){
		//中行聚合支付
		set rtnValue=##class(DHCBILL.MisPos.Adapter.JHMisPos).GetMisPosInput(ETPRowID, ExpStr)
	}elseif(TradeChannel="POSYLSW"){
		//银联商务
		set rtnValue=##class(DHCBILL.MisPos.Adapter.YLSWMisPos).GetMisPosInput(ETPRowID, ExpStr)
	}
	
	quit rtnValue
	
ERROR
	quit ..AppException()
}

/// Creator：xiongwang
/// CreatDate: 2018-03-12
/// Descripiton: 根据订单RowID组织参数
/// Input: bankTradeType:银行交易类型
/// 	   PosConfig:银行配置信息(银行类型[如比如建行联迪-LD,农行创识-CS]^终端号)
///        ExpStr:扩展信息
/// Debug： w ##class(DHCBILL.MisPos.BLL.MisPosLogic).GetMisPosInputInfo("OP",74.40,"LD","C",47,"303^238^2^4632^262^^223491^^C")
ClassMethod GetOtherServicePara(BankTradeType As %String, PosConfig As %String, ExpStr As %String = "")
{
	set $zt="ERROR"
	
	set TradeChannel=$p(PosConfig,"^",1)
	set TerminalNo=$p(PosConfig,"^",2)
	set rtnValue=""
	if (TradeChannel="POSLD") {
		//建行联迪的数据入参整理（根据项目实际银行修改）
		set rtnValue=##class(DHCBILL.MisPos.Adapter.LDMisPos).GetOtherServicePara(BankTradeType, TerminalNo, ExpStr)
	}elseif (TradeChannel="POSCS") {
		//农行创识的数据入参整理（根据项目实际银行修改）
		set rtnValue=##class(DHCBILL.MisPos.Adapter.CSMisPos).GetOtherServicePara(BankTradeType, TerminalNo, ExpStr)
	}elseif(TradeChannel="POSYLSW") {
		//银联商务
		set rtnValue=##class(DHCBILL.MisPos.Adapter.YLSWMisPos).GetOtherServicePara(BankTradeType, TerminalNo, ExpStr)
	}
	
	quit rtnValue

ERROR
	quit ..AppException()
}

/// Creator: xiongwang
/// CreatDate: 2018-03-12
/// Descripiton: 保存银行的交易数据
/// Input: ETPRowID:交易表的rowid
///        BankData:银行交易返回串
///        ExpStr:扩展信息
/// Return: 0:成功，非0:失败
/// 	    ETPRowID 交易表rowid
/// 	    posInputInfo 组织的pos交易入参串 SaveMisPosData
/// Debug: w ##class(DHCBILL.MisPos.BLL.MisPosLogic).SaveMisPosData(10,"4|00|6222621066668888123|2376582|270242|888888888888|2025|20180506|123410|交易成功|555555555555555|12345678|888888888888|")
ClassMethod SaveMisPosData(ETPRowID As %String, BankData As %String, ExpStr As %String = "")
{
	set $zt="ERROR"
	
	//1、先保存日志
	do ##class(DHCBILL.MisPos.BLL.MisPosLogic).SaveLog(ETPRowID, BankData)
	set TradeChannel=$p(^DHCBILLETP(ETPRowID),"^",31)
	if (TradeChannel="") set TradeChannel=$p(ExpStr,"^",1)
	set rtnValue=-1004_"^"
	//整理银行返回数据,返回给his进行保存
	if (TradeChannel="POSLD"){
		//例：建行-联迪
		set rtnValue=##class(DHCBILL.MisPos.Adapter.LDMisPos).GetOutBankData(ETPRowID, BankData)
	}elseif(TradeChannel="POSCS"){
		//例：农行-创识
		set rtnValue=##class(DHCBILL.MisPos.Adapter.CSMisPos).GetOutBankData(ETPRowID, BankData)
	}elseif(TradeChannel="POSJH"){
		//中行聚合支付
		set rtnValue=##class(DHCBILL.MisPos.Adapter.JHMisPos).GetOutBankData(ETPRowID, BankData)
	}elseif((TradeChannel="POSYLSW")||(TradeChannel["MLZZ")){
		//银联商务
		set rtnValue=##class(DHCBILL.MisPos.Adapter.YLSWMisPos).GetOutBankData(ETPRowID, BankData)
	}
	quit rtnValue

ERROR
	quit ..AppException()
}

/// Creator: xiongwang
/// CreatDate: 2018-04-30
/// Descripiton: 保存交易日志
/// Input: ETPRowID:订单表ID, BankData:保存POS交易返回原始数据
/// Return: 0:成功
/// Debug: w ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveLog()
ClassMethod SaveLog(ETPRowID As %String, BankData As %String) As %String
{
	set $zt="ERROR"
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_ExtOutString = REPLACE(:BankData,"^","＾")
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn

ERROR
	quit ..AppException()
}

/// 汉字按两个字符来算
ClassMethod SetStr(Str)
{
	set NewStr=""
	for i=1:1:$l(Str) do
	.set CurrentWord=$e(Str,i)
	.set ascii=$ascii(CurrentWord)
	.if ((ascii>=19968)&&(ascii<=40869)) do
	..if (NewStr="") set NewStr=CurrentWord_" "
	..else  set NewStr=NewStr_CurrentWord_" "
	.else  do
	..if (NewStr="") set NewStr=CurrentWord
	..else  set NewStr=NewStr_CurrentWord
	quit NewStr
}

/// Creator：xiongwang
/// CreatDate: 2018-05-05
/// Descripiton: 退费时验证交易类型(D/T)
/// Input: OrgETPRowID:需退费原记录对应交易表rowid
/// 	  PosConfig:银行配置信息(银行类型[如比如建行联迪-LD,农行创识-CS]^终端号)
/// Return: rtn D:退费,T:退货
/// Debug: w ##class(DHCBILL.MisPos.BLL.MisPosLogic).CheckRefundTradeType("52","POSJH^11781045")
ClassMethod CheckRefundTradeType(OrgETPRowID As %String, PosConfig As %String)
{
	set rtnValue=""
	set TradeChannel=$p(PosConfig,"^",1)
	set TerminalID=$p(PosConfig,"^",2)
	quit:(+OrgETPRowID=0) -1_"^"_"参数错误"
	
	set OrgETPData=$g(^DHCBILLETP(OrgETPRowID))
	set OldTxtDate=$p(OrgETPData,"^",14)		 //ETP_Ext_Date 银行交易日期
	set OldTradeChannel=$p(OrgETPData,"^",31)	 //ETP_TradeChannel 交易途径/渠道(POSLD POSXL ScanPay)
	set OldUserDR=$p(OrgETPData,"^",24)
	set OldUserName=$p($g(^SSU("SSUSR",OldUserDR)),"^",2)
	quit:(OldTradeChannel'=TradeChannel) -2003_"^"_OldUserName
	set OldTerminalID=$p(OrgETPData,"^",9)
	//set CasheTxtDate=$zdh(TxtDate,8)
	set CasheTxtDate=OldTxtDate
	set PayModeDR=$p(OrgETPData,"^",45)
	set PayMCode=$s((+PayModeDR'=0):$p($g(^CT("CTPM",PayModeDR)),"^",1),1:"")
	if (CasheTxtDate=+$h) {
		if (OldTerminalID=TerminalID)&&($zcvt(PayMCode,"U")'["ALI")&&($zcvt(PayMCode,"U")'["WECHAT") {
			set rtnValue="D"
		}else{
			set rtnValue="T"
		}
	}else{
		set rtnValue="T"
	}
	quit rtnValue
}

ClassMethod VerifyBankData(TradeChannel As %String, BankInput As %String, BankData As %String) As %String
{
	//整理银行返回数据,返回给his进行保存
	if (TradeChannel="POSLD"){
		//例：建行-联迪
		set rtnValue=##class(DHCBILL.MisPos.Adapter.LDMisPos).VerifyBankData(BankInput, BankData)
	}elseif(TradeChannel="POSCS"){
		//例：农行-创识
		set rtnValue=##class(DHCBILL.MisPos.Adapter.CSMisPos).VerifyBankData(BankInput, BankData)
	}elseif(TradeChannel="POSJH"){
		//中行聚合支付
		set rtnValue=##class(DHCBILL.MisPos.Adapter.JHMisPos).VerifyBankData(BankInput, BankData)
	}
	quit rtnValue
}

/// Creator: xiongwang
/// CreatDate: 2018-03-07
/// Descripiton: 生成冲正接口订单
/// Input: OrgETPRowID: 原收费订单
///        PosConfig: 银行配置信息(银行类型[如比如建行联迪-LD,农行创识-CS]^终端号)
///        ExpStr: 扩展串(科室^安全组^院区^操作员ID)
/// Debug: w ##class(DHCBILL.MisPos.BLL.MisPosLogic).CreatCorrectOrder(5,"POSCS^000123","186^19^2^4046")
ClassMethod CreatCorrectOrder(OrgETPRowID As %String, PosConfig As %String, ExpStr As %String) As %String
{
	quit:(+OrgETPRowID=0) -1_"^"_"参数错误"
	
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).GetCanRevokeFlag(OrgETPRowID)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue   //+2023-05-08 ZhYW 冲正前增加校验
	
	set ETPData=$g(^DHCBILLETP(OrgETPRowID))
	//退费金额=原交易金额
	set RefAmt=$p(ETPData,"^",4)
	//冲正订单类型为：CANCEL
	set TradeType="CANCEL"
	set BankTradeType="D"	//默认撤销
	set PayModeDR=$p(ETPData,"^",45)
	set rtnValue=..CreateRefOrder(OrgETPRowID, TradeType, PayModeDR, RefAmt, BankTradeType, PosConfig, ExpStr)
	quit rtnValue
}

}
