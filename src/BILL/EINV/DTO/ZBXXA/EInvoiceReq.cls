/// 中博信息开票接口入参
Class BILL.EINV.DTO.ZBXXA.EInvoiceReq Extends %RegisteredObject
{

Property REQUESTID As %String(CAPTION = "开具请求流水号", XMLNAME = "REQUEST_ID");

Property BizCode As %String(CAPTION = "业务流水号");

Property InvoiceType As %String(CAPTION = "票据类型");

Property ArrearsMarking As %String(CAPTION = "欠费标识");

Property InvoicingPartyCode As %String(CAPTION = "开票单位代码");

Property InvoicingPartyName As %String(CAPTION = "开票单位名称");

Property PlaceCode As %String(CAPTION = "开票点编码");

Property PayerPartyTyp As %String(CAPTION = "交款人类型");

Property PayerPartyCode As %String(CAPTION = "交款人代码");

Property PayerPartyName As %String(CAPTION = "交款人名称");

Property TotalAmount As %String(CAPTION = "总金额");

Property Remark As %String(CAPTION = "备注");

Property HandlingPerson As %String(CAPTION = "收款人");

Property Checker As %String(CAPTION = "复核人");

Property SmsPhone As %String(CAPTION = "票据接收手机号码");

Property SmsEmail As %String(CAPTION = "票据接收邮箱");

Property Details As list Of BILL.EINV.DTO.ZBXXA.EInvDetails(CAPTION = "票面明细信息");

Property AuxDetails As list Of BILL.EINV.DTO.ZBXXA.EInvAuxDetails(CAPTION = "辅助明细项目");

/// 票面其他信息OtherInfo
Property OtherInfo As BILL.EINV.DTO.ZBXXA.EInvOtherInfo(CAPTION = "票面其他信息");

}
