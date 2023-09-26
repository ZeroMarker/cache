/// 票据查询接口对象参数
Class BILL.EINV.DTO.NNWA.EInvQueryReq Extends %RegisteredObject
{

Property invoicingPartyCode As %String(CAPTION = "开票单位代码");

Property bizCode As %String(CAPTION = "业务流水号");

Property payerPartyCode As %String(CAPTION = "交款人代码");

Property einvoiceCode As %String(CAPTION = "电子票据代码");

Property einvoiceNumber As %String(CAPTION = "电子票据号码");

}
