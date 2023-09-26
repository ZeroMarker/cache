/// HIs 开票信息
Class BILL.EINV.DTO.JSB.EInvHisInfo Extends %RegisteredObject
{

Property "card_type" As %String(CAPTION = "患者使用的卡类型");

Property "card_no" As %String(CAPTION = "患者的卡编号");

/// 业务发生时间 ,格 式 ：yyyyMMddHHmmss
Property biztime As %String(CAPTION = "业务发生时间");

Property "place_code" As %String(CAPTION = "医院业务系统的开票点编码");

Property payee As %String(CAPTION = "收款人");

Property "trade_info" As BILL.EINV.DTO.JSB.EInvTradeInfo(CAPTION = "收费信息");

Property "reimburse_info" As BILL.EINV.DTO.JSB.EInvReimburseInfo(CAPTION = "报销信息");

Property bizinfo As BILL.EINV.DTO.JSB.EInvBizinfo(CAPTION = "就诊信息明细");

Property "med_item_list" As list Of BILL.EINV.DTO.JSB.EInvMeditemlist(CAPTION = "医疗清单明细");

}
