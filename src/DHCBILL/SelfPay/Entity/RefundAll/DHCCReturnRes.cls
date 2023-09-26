Class DHCBILL.SelfPay.Entity.RefundAll.DHCCReturnRes Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 0;

/// error  错误消息
Property error As %String(TRUNCATE = 1, XMLNAME = "error");

/// issuccess 成功标志 T F
Property issuccess As %String(TRUNCATE = 1, XMLNAME = "issuccess");

/// tradeno 流水号(同步异步)
Property tradeno As %String(TRUNCATE = 1, XMLNAME = "tradeno");

/// money 金额
Property money As %String(TRUNCATE = 1, XMLNAME = "money");

/// memo 备注
Property memo As %String(TRUNCATE = 1, XMLNAME = "memo");

/// batch_no 订单号
Property batchno As %String(TRUNCATE = 1, XMLNAME = "batchno");

/// patientid 病人Id
Property patientid As %String(TRUNCATE = 1, XMLNAME = "patientid");

/// outtradeno 异步平台订单号(His)
Property outtradeno As %String(TRUNCATE = 1, XMLNAME = "outtradeno");

/// buyeremail 异步付款账号
Property buyeremail As %String(TRUNCATE = 1, XMLNAME = "buyeremail");

/// totalfee 异步交易金额
Property totalfee As %String(TRUNCATE = 1, XMLNAME = "totalfee");

/// selleremail 异步支付宝收款账号
Property selleremail As %String(TRUNCATE = 1, XMLNAME = "selleremail");

/// gmtpayment 异步交易时间
Property gmtpayment As %String(TRUNCATE = 1, XMLNAME = "gmtpayment");

/// tradestatus 异步交易状态 T 成功
Property tradestatus As %String(TRUNCATE = 1, XMLNAME = "tradestatus");

}
