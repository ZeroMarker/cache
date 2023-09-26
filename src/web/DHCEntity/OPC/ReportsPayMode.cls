Class web.DHCEntity.OPC.ReportsPayMode Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// CashPayMode
Method GetCashPayModeRowID() As %String
{
}

/// /提供一个按照 固定支付模式的
/// /1. 收费的支付模式定义  钱和票据张数和记录数量
/// /2. 作废时的支付模式定义， 钱 票据张数和记录数量
/// /3. 红冲时的支付模式定义， 钱 票据张数和记录数量
/// 银行卡支付模式
/// 银医卡
Parameter BankCardPayMode = "BANKCARD";

/// 医院账户卡支付模式
Parameter CPPPayMode = "CPP";

/// 现金支付模式
Parameter CashPayMode = "CASH";

/// 支票支付模式
Parameter ChequePayMode = "CHEQUES";

/// 其他支付模式
Parameter OtherPayMode = "^BANKCARD^CPP^CASH^CHEQUES^POS^^YBGRZH^YBJJ^";

/// POS机支付模式
Parameter POSPayMode = "POS";

/// 单位记帐
Parameter UnitPayor = "UNITACCOUNT";

/// 医保卡支付模式, 因为有多种, 需要用 
Parameter YBCardPayMode = "^YBGRZH^YBJJ^^";

/// 银行卡数量
Property BankCardNum As %String(TRUNCATE = 1);

/// 银行卡金额
Property BankCardSum As %String(TRUNCATE = 1);

/// 卡支付数量
Property CPPNum As %String(TRUNCATE = 1);

/// 卡支付金额
Property CPPSum As %String(TRUNCATE = 1);

/// 现金的数量
Property CashNum As %String(TRUNCATE = 1);

/// 现金金额
Property CashSum As %String(TRUNCATE = 1);

/// 支票支付数量
Property ChequeNum As %String(TRUNCATE = 1);

/// 支票支付金额
Property ChequeSum As %String(TRUNCATE = 1);

/// 其他支付数量
Property OtherNum As %String(TRUNCATE = 1);

/// 其他支付金额
Property OtherSum As %String(TRUNCATE = 1);

/// POS数量
Property POSNum As %String(TRUNCATE = 1);

/// POS金额
Property POSSum As %String(TRUNCATE = 1);

/// 代码，用来对比
Property SubAvailHospitlCode As %String(TRUNCATE = 1);

/// 医保支付数量   数据库中多个保存，在界面中单个显示
Property YBCardNum As %String(TRUNCATE = 1);

/// 利益体 RowID
Property SubAvailHospitlDR As %String(TRUNCATE = 1);

/// 医保支付金额   数据库中多个保存，在界面中单个显示
Property YBCardSum As %String(TRUNCATE = 1);

/// 名称
Property SubAvailHospitlDesc As %String(TRUNCATE = 1);

/// 单位记帐数量
Property UnitPayorNum As %String(TRUNCATE = 1);

Method PutPayMode(PayModeCode As %String, PaySum As %String, PayNum As %String) As %String
{
	i (PayModeCode=..#CashPayMode){
		s ..CashSum=+..CashSum + PaySum
		s ..CashNum=+..CashNum + PayNum
	}elseif (PayModeCode=..#ChequePayMode){
		s ..ChequeSum=+..ChequeSum + PaySum
		s ..ChequeNum=+..ChequeNum + PayNum
	}elseif (PayModeCode=..#BankCardPayMode){
		s ..BankCardNum=+..BankCardNum+PayNum
		s ..BankCardSum = +..BankCardSum+PaySum
	}elseif (PayModeCode=..#CPPPayMode){
		s ..CPPNum=+..CPPNum + PayNum
		s ..CPPSum =+..CPPSum + PaySum
	}elseif (PayModeCode=..#POSPayMode){
		s ..POSNum=+..POSNum+PayNum
		s ..POSSum=+..POSSum+PaySum
	}elseif ((PayModeCode)=..#UnitPayor){
		s ..UnitPayorNum=+..UnitPayorNum+PayNum
		s ..UnitPayorSum=+..UnitPayorSum+PaySum
	}elseif (("^"_PayModeCode_"^")[..#YBCardPayMode){
		s ..YBCardNum=+..YBCardNum+PayNum
		s ..YBCardSum=+..YBCardSum+PaySum
	}elseif (("^"_PayModeCode_"^")[..#OtherPayMode){
		s ..OtherNum=+..OtherNum+PayNum
		s ..OtherSum=+..OtherSum+PaySum
	}else{
		s ..OtherNum=+..OtherNum+PayNum
		s ..OtherSum=+..OtherSum+PaySum
	}
}

/// 单位记帐金额
Property UnitPayorSum As %String(TRUNCATE = 1);

/// 获取支付模式串
Method GetPayModeCharactor() As %String
{
	s mystr=""
	s mystr=..CashNum_"^"_..CashSum
	s mystr=mystr_"^"_..ChequeNum_"^"_..ChequeSum
	s mystr=mystr_"^"_..BankCardNum_"^"_..BankCardSum
	s mystr=mystr_"^"_..CPPNum_"^"_..CPPSum
	s mystr=mystr_"^"_..POSNum_"^"_..POSSum
	s mystr=mystr_"^"_..YBCardNum_"^"_..YBCardSum
	s mystr=mystr_"^"_..OtherNum_"^"_..OtherSum
	s mystr=mystr_"^"_..UnitPayorNum_"^"_..UnitPayorSum
	;.........
	;s mystr=mystr_"^"
	
	q mystr
}

Method CalculateSelf(OperSign As %String, OperatedObj As %ObjectHandle) As %Status
{
	i (OperSign="+"){
		s ..CashSum=+..CashSum + OperatedObj.CashSum
		s ..CashNum=+..CashNum + OperatedObj.CashNum
		s ..ChequeSum=+..ChequeSum + OperatedObj.ChequeSum
		s ..ChequeNum=+..ChequeNum + OperatedObj.ChequeNum
		s ..BankCardNum=+..BankCardNum+OperatedObj.BankCardNum
		s ..BankCardSum = +..BankCardSum+OperatedObj.BankCardSum
		s ..CPPNum=+..CPPNum + OperatedObj.CPPNum
		s ..CPPSum =+..CPPSum + OperatedObj.CPPSum
		s ..POSNum=+..POSNum+OperatedObj.POSNum
		s ..POSSum=+..POSSum+OperatedObj.POSSum
		s ..YBCardNum=+..YBCardNum+OperatedObj.YBCardNum
		s ..YBCardSum=+..YBCardSum+OperatedObj.YBCardSum
		s ..OtherNum=+..OtherNum+ OperatedObj.OtherNum
		s ..OtherSum=+..OtherSum+ OperatedObj.OtherSum
		s ..UnitPayorNum=+..UnitPayorNum+ OperatedObj.UnitPayorNum
		s ..UnitPayorSum=+..UnitPayorSum+ OperatedObj.UnitPayorSum
		
	}elseif((OperSign="-")){
		s ..CashSum=+..CashSum - OperatedObj.CashSum
		s ..CashNum=+..CashNum - OperatedObj.CashNum
		s ..ChequeSum=+..ChequeSum - OperatedObj.ChequeSum
		s ..ChequeNum=+..ChequeNum - OperatedObj.ChequeNum
		s ..BankCardNum=+..BankCardNum-OperatedObj.BankCardNum
		s ..BankCardSum = +..BankCardSum-OperatedObj.BankCardSum
		s ..CPPNum=+..CPPNum - OperatedObj.CPPNum
		s ..CPPSum =+..CPPSum - OperatedObj.CPPSum
		s ..POSNum=+..POSNum - OperatedObj.POSNum
		s ..POSSum=+..POSSum - OperatedObj.POSSum
		s ..YBCardNum=+..YBCardNum - OperatedObj.YBCardNum
		s ..YBCardSum=+..YBCardSum - OperatedObj.YBCardSum
		s ..OtherNum=+..OtherNum - OperatedObj.OtherNum
		s ..OtherSum=+..OtherSum - OperatedObj.OtherSum
		s ..UnitPayorNum=+..UnitPayorNum- OperatedObj.UnitPayorNum
		s ..UnitPayorSum=+..UnitPayorSum- OperatedObj.UnitPayorSum
	}
	
	q $$$OK
}

}
