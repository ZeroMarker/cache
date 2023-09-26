Class BILL.EINV.DTO.JSA.InvoiceHisInfo Extends %RegisteredObject
{

Property cardtype As %String(CAPTION = "患者使用的卡类型", XMLNAME = "card_type");

Property cardno As %String(CAPTION = "患者的卡编号", XMLNAME = "card_no");

Property biztime As %String(CAPTION = "业务发生时间", XMLNAME = "biztime");

Property placecode As %String(CAPTION = "医院业务系统的开票点编码", XMLNAME = "place_code");

Property payee As %String(CAPTION = "收款人", XMLNAME = "payee");

Property tradeinfo As BILL.EINV.DTO.JSA.InvoiceTradeInfo(CAPTION = "收费信息", XMLNAME = "trade_info");

Property reimburseinfo As BILL.EINV.DTO.JSA.InvoiceReimburseInfo(CAPTION = "报销信息", XMLNAME = "reimburse_info");

Property bizinfo As BILL.EINV.DTO.JSA.InvoiceBizInfo(CAPTION = "就诊信息明细", XMLNAME = "bizinfo");

/// 医疗清单明细
Property meditemlist As list Of BILL.EINV.DTO.JSA.InvoiceMeditemList(CAPTION = "医疗清单明细", XMLNAME = "med_item_list");

}
