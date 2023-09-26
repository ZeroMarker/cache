Class DHCExternalService.RegInterface.Entity.SelfReg.OPRegReturnRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 预约机构
Property ExtOrgCode As %String(TRUNCATE = 1);

/// 客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// 终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 挂号ID
Property AdmNo As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 银行卡号
Property BankNo As %String(TRUNCATE = 1);

/// 银行流水号
Property BankTradeNo As %String(TRUNCATE = 1);

/// 退费退货标志TF：退费--TH：退货
Property RefundType As %String(TRUNCATE = 1);

/// 第三方订单号
Property PayOrderId As %String(TRUNCATE = 1);

}
