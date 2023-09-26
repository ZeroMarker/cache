/// 医疗票相关信息
Class BILL.EINV.DTO.JSC.EInvInvoiceHisinfo Extends %RegisteredObject
{

/// 患者使用的卡类型，参见附录2
Property cardtype As %String(CAPTION = "卡类型", XMLNAME = "card_type");

Property cardno As %String(CAPTION = "卡号", XMLNAME = "card_no");

/// 业务发生时间，格式"yyyyMMddHHmmss"
Property biztime As %String(CAPTION = "业务发生时间");

Property placecode As %String(CAPTION = "医院业务系统的开票点编码", XMLNAME = "place_code");

Property payee As %String(CAPTION = "收款人");

/// 人员性质/医疗待遇类别/医疗人员类别	自费病人填写”自费”，医保人员按医保返回填写
Property ylmantype As %String(CAPTION = "人员性质", XMLNAME = "ylman_type");

Property unitName As %String(CAPTION = "单位全称");

Property insuranceType As %String(CAPTION = "险种类型");

Property insuredSite As %String(CAPTION = "参保地");

Property medicalLnsuranceNo As %String(CAPTION = "医保结算流水号");

Property personType As %String(CAPTION = "人群类型");

Property treatment As %String(CAPTION = "人员待遇");

Property payType As %String(CAPTION = "支付类型");

Property medicalout As %String(CAPTION = "医保结算出参", XMLNAME = "medical_out");

Property tradeinfo As BILL.EINV.DTO.JSC.EInvInvoiceTradeinfo(CAPTION = "收费信息", XMLNAME = "trade_info");

Property reimburseinfo As BILL.EINV.DTO.JSC.EInvInvoiceReimburseinfo(CAPTION = "报销信息", XMLNAME = "reimburse_info");

Property bizinfo As BILL.EINV.DTO.JSC.EInvInvoiceBizinfo(CAPTION = "就诊信息明细", XMLNAME = "biz_info");

/// med_item_list
Property meditemlist As list Of BILL.EINV.DTO.JSC.EInvInvoiceMeditemlist(CAPTION = "医疗清单明细", XMLNAME = "med_item_list");

}
