Class DHCBILL.SelfPay.Entity.GetBills.Respons.Item Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// MchtID 商户号
Property MchtID As %String(TRUNCATE = 1);

/// TermID 终端号
Property TermID As %String(TRUNCATE = 1);

/// TransNO 系统唯一流水号
Property TransNO As %String(TRUNCATE = 1);

/// PatientNO 门诊号
Property PatientNO As %String(TRUNCATE = 1);

/// PatientName 患者姓名
Property PatientName As %String(TRUNCATE = 1);

/// InvoiceNO 发票号
Property InvoiceNO As %String(TRUNCATE = 1);

/// OutTransNO 支付宝或微信等交易中的流水
Property OutTransNO As %String(TRUNCATE = 1);

/// BankCardNO 银行卡号
Property BankCardNO As %String(TRUNCATE = 1);

/// PosNO 银行交易号
Property PosNO As %String(TRUNCATE = 1);

/// OperCode 操作员工号
Property OperCode As %String(TRUNCATE = 1);

/// TransDate 交易时间
Property TransDate As %String(TRUNCATE = 1);

/// PayTypeID 交易类型
Property PayTypeID As %String(TRUNCATE = 1);

/// TotalFee 交易金额（元） 
Property TotalFee As %String(TRUNCATE = 1);

/// BussType  交易/退费 
Property BussType As %String(TRUNCATE = 1);

/// OutTransNoSurce 收费订单号（退费对应的正交易号）
Property OutTransNoSurce As %String(TRUNCATE = 1);

/// TermianlCode 终端编号
Property TermianlCode As %String(TRUNCATE = 1);

/// OperType  业务类型 （挂号，充值、消费、缴费）
Property OperType As %String(TRUNCATE = 1);

}
