Class BILL.EINV.DTO.STGLA.InvoiceDataMain Extends %RegisteredObject
{

Property ZJE As %String(CAPTION = "总金额");

Property JKFS As %String(CAPTION = "交款方式");

Property BZ As %String(CAPTION = "备注");

Property KPR As %String(CAPTION = "开票人");

Property FHR As %String(CAPTION = "复核人");

Property BZCZ As %String(CAPTION = "财政部门备注");

Property KPDW As BILL.EINV.DTO.STGLA.KPDWInfo(CAPTION = "开票单位信息");

Property JKR As BILL.EINV.DTO.STGLA.JKRInfo(CAPTION = "交款人信息");

Property EXT As BILL.EINV.DTO.STGLA.EXTInfo(CAPTION = "其他信息");

}
