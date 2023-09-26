Class BILL.EINV.DTO.TBTCA.EInvInfoMsgResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "Voucher";

/// 电子票据代码
Property EbillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据号码
Property EbillNo As %String(XMLPROJECTION = "ELEMENT");

/// 校验码
Property RandomNumber As %String(XMLPROJECTION = "ELEMENT");

/// 结算号
Property InsuranceSettleNo As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据作废状态
Property EbillCancelStatus As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据作废时间
Property EbillCancelTime As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据冲销状态
Property EbillChargeOffStatus As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据冲销时间
Property EbillChargeOffTime As %String(XMLPROJECTION = "ELEMENT");

/// 红票票据编码
Property CancelEbillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 红票票据号码
Property CancelEbillNo As %String(XMLPROJECTION = "ELEMENT");

/// 电票生成时间
Property EbillingTime As %String(XMLPROJECTION = "ELEMENT");

Property BillInfos As list Of BILL.EINV.DTO.TBTCA.BillInfosResult(XMLPROJECTION = "ELEMENT");

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

}
