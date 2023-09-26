Class DHCBILL.ScanPay.Entity.HC.ScanTradeOutput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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
Property ETPRc As %String(TRUNCATE = 1, XMLNAME = "payStatus");

/// ResultContent	对错误/异常的详细描述信息
Property ETPRcdetail As %String(TRUNCATE = 1, XMLNAME = "payStatusDesc");

Property ETPPan As %String(TRUNCATE = 1);

Property ETPTramt As %String(TRUNCATE = 1, XMLNAME = "payAmount");

Property ETPmersystrace As %String(TRUNCATE = 1);

Property ETPinvoiceno As %String(TRUNCATE = 1);

Property ETPRRN As %String(TRUNCATE = 1, XMLNAME = "psOrdNum");

Property ETPAuthno As %String(TRUNCATE = 1);

Property ETPTid As %String(TRUNCATE = 1);

Property ETPmchid As %String(TRUNCATE = 1);

Property ETPbatchno As %String(TRUNCATE = 1);

Property ETPtellerno As %String(TRUNCATE = 1);

Property ETPBankname As %String(TRUNCATE = 1);

Property ETPtxndate As %String(TRUNCATE = 1, XMLNAME = "payTime");

Property ETPtxntime As %String(TRUNCATE = 1);

Property ETPexpdate As %String(TRUNCATE = 1);

Property ETPappendinfo As %String(TRUNCATE = 1);

Property ETPStatus As %String(TRUNCATE = 1);

Property ETPBankTradePayDR As %String(TRUNCATE = 1);

Property ETPOldBankTradePayDR As %String(TRUNCATE = 1);

Property ETPTradeDate As %String(TRUNCATE = 1);

Property ETPTradeTime As %String(TRUNCATE = 1);

Property ETPTradeAmt As %String(TRUNCATE = 1);

Property ETPTradeUserDR As %String(TRUNCATE = 1);

Property ETPTradeType As %String(TRUNCATE = 1);

Property ETPBankTradeType As %String(TRUNCATE = 1);

Property ETPCardType As %String(TRUNCATE = 1);

Property ETPHospitalDr As %String(TRUNCATE = 1);

Property ETPCompleteFlag As %String(TRUNCATE = 1);

Property ETPCompleteReturnFlag As %String(TRUNCATE = 1);

Property ETPTradeChannel As %String(TRUNCATE = 1, XMLNAME = "payMode");

Property ETPHISTradeID As %String(TRUNCATE = 1, XMLNAME = "hisOrdNum");

Property ETPHISOldTradeID As %String(TRUNCATE = 1);

Property ETPCompleteReturnDate As %String(TRUNCATE = 1);

Property ETPCompleteReturnTime As %String(TRUNCATE = 1);

Property ETPoldtxndate As %String(TRUNCATE = 1);

Property ETPoldmersystrace As %String(TRUNCATE = 1);

Property ETPoldRRN As %String(TRUNCATE = 1);

Property ETPoldbatchno As %String(TRUNCATE = 1);

Property ETPpapmidr As %String(TRUNCATE = 1);

Property ETPmchName As %String(TRUNCATE = 1);

Property ETPBankCardType As %String(TRUNCATE = 1);

Property ETPAdm As %String(TRUNCATE = 1);

Property ETPInsType As %String(TRUNCATE = 1);

Property ETPPayMode As %String(TRUNCATE = 1);

Property ETPExtTradeChannel As %String(TRUNCATE = 1);

Property ETPExtTradeNo As %String(TRUNCATE = 1, XMLNAME = "agOrdNum");

Property ETPHisPrtStr As %String(TRUNCATE = 1);

}
