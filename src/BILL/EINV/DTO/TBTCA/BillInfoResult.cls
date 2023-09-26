Class BILL.EINV.DTO.TBTCA.BillInfoResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

/// 纸质票据编码
Property BillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 纸质票据号码
Property BillNo As %String(XMLPROJECTION = "ELEMENT");

/// 开票时间
Property BillingTime As %String(XMLPROJECTION = "ELEMENT");

/// 开票日期
Property BillingDate As %String(XMLPROJECTION = "ELEMENT");

/// 金额
Property TotalAmount As %String(XMLPROJECTION = "ELEMENT");

/// 作废状态
Property CancelStatus As %String(XMLPROJECTION = "ELEMENT");

/// 冲销状态
Property ChargeOffStatus As %String(XMLPROJECTION = "ELEMENT");

/// 页码
Property PageNumber As %String(XMLPROJECTION = "ELEMENT");

/// 换开时间
Property PrintTime As %String(XMLPROJECTION = "ELEMENT");

}
