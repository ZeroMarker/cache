Class DHCBILL.ScanPay.Entity.HC.ScanRefOutput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Property His端名称   XMLNAME  第三方属性名
Parameter XMLSEQUENCE = 0;

// =0 XML属性不按照顺序解析；=1 XML元素和类的属性顺序必须一致，否则解析时将被忽略。

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

// =1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

// =0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

/// ResultCode	交易结果,错误代码表0000：成功
Property IBPRc As %String(TRUNCATE = 1, XMLNAME = "refundStatus");

/// ResultContent	对错误/异常的详细描述信息
Property IBPRcdetail As %String(TRUNCATE = 1, XMLNAME = "refundStatusDes");

Property IBPPan As %String(TRUNCATE = 1);

Property IBPTramt As %String(TRUNCATE = 1, XMLNAME = "refundAmount");

Property IBPmersystrace As %String(TRUNCATE = 1);

Property IBPinvoiceno As %String(TRUNCATE = 1);

Property IBPRRN As %String(TRUNCATE = 1, XMLNAME = "psRefundOrdNum");

Property IBPAuthno As %String(TRUNCATE = 1);

Property IBPTid As %String(TRUNCATE = 1);

Property IBPmchid As %String(TRUNCATE = 1);

Property IBPbatchno As %String(TRUNCATE = 1);

Property IBPtellerno As %String(TRUNCATE = 1);

Property IBPBankname As %String(TRUNCATE = 1);

Property IBPtxndate As %String(TRUNCATE = 1, XMLNAME = "refundTime");

Property IBPtxntime As %String(TRUNCATE = 1);

Property IBPexpdate As %String(TRUNCATE = 1);

Property IBPappendinfo As %String(TRUNCATE = 1);

Property IBPStatus As %String(TRUNCATE = 1);

Property IBPBankTradePayDR As %String(TRUNCATE = 1);

Property IBPOldBankTradePayDR As %String(TRUNCATE = 1);

Property IBPTradeDate As %String(TRUNCATE = 1);

Property IBPTradeTime As %String(TRUNCATE = 1);

Property IBPTradeAmt As %String(TRUNCATE = 1);

Property IBPTradeUserDR As %String(TRUNCATE = 1);

Property IBPTradeType As %String(TRUNCATE = 1);

Property IBPBankTradeType As %String(TRUNCATE = 1);

Property IBPCardType As %String(TRUNCATE = 1);

Property IBPHospitalDr As %String(TRUNCATE = 1);

Property IBPCompleteFlag As %String(TRUNCATE = 1);

Property IBPCompleteReturnFlag As %String(TRUNCATE = 1);

Property IBPTradeChannel As %String(TRUNCATE = 1, XMLNAME = "payMode");

Property IBPHISTradeID As %String(TRUNCATE = 1, XMLNAME = "hisRefundOrdNum");

Property IBPHISOldTradeID As %String(TRUNCATE = 1);

Property IBPCompleteReturnDate As %String(TRUNCATE = 1);

Property IBPCompleteReturnTime As %String(TRUNCATE = 1);

Property IBPoldtxndate As %String(TRUNCATE = 1);

Property IBPoldmersystrace As %String(TRUNCATE = 1);

Property IBPoldRRN As %String(TRUNCATE = 1);

Property IBPoldbatchno As %String(TRUNCATE = 1);

Property IBPpapmidr As %String(TRUNCATE = 1);

Property IBPmchName As %String(TRUNCATE = 1);

Property IBPBankCardType As %String(TRUNCATE = 1);

Property IBPAdm As %String(TRUNCATE = 1);

Property IBPInsType As %String(TRUNCATE = 1);

Property IBPPayMode As %String(TRUNCATE = 1);

Property IBPExtTradeChannel As %String(TRUNCATE = 1);

Property IBPExtTradeNo As %String(TRUNCATE = 1, XMLNAME = "agOrdNum");

Property IBPHisPrtStr As %String(TRUNCATE = 1);

}
