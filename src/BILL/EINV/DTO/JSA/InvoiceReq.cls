Class BILL.EINV.DTO.JSA.InvoiceReq Extends %RegisteredObject
{

Property method As %String(CAPTION = "消息方法");

Property cocode As %String(CAPTION = "医疗机构编码", XMLNAME = "co_code");

Property appid As %String(CAPTION = "业务服务的编码", XMLNAME = "app_id");

Property zonecode As %String(CAPTION = "行政区划", XMLNAME = "zone_code");

Property timestamp As %String(CAPTION = "发送请求的时间");

Property version As %String(CAPTION = "版本号");

Property invoicecode As %String(CAPTION = "票据代码", XMLNAME = "invoice_code");

Property invoicenumber As %String(CAPTION = "电子票据号码", XMLNAME = "invoice_number");

Property random As %String(CAPTION = "校验码", XMLNAME = "random");

Property totalamount As %String(CAPTION = "总金额", XMLNAME = "total_amount");

Property invoicingpartycode As %String(CAPTION = "医疗机构单位代码", XMLNAME = "invoicing_party_code");

Property invoicingpartyname As %String(CAPTION = "医疗机构单位名称", XMLNAME = "invoicing_party_name");

Property recname As %String(CAPTION = "收款人全称", XMLNAME = "rec_name");

Property recacct As %String(CAPTION = "收款人账号", XMLNAME = "rec_acct");

Property recopbk As %String(CAPTION = "收款人开户行", XMLNAME = "rec_opbk");

Property payerpartytype As %String(CAPTION = "交款人类型", XMLNAME = "payer_party_type");

Property payerpartycode As %String(CAPTION = "患者身份证号码", XMLNAME = "payer_party_code");

Property payerpartyname As %String(CAPTION = "患者名称", XMLNAME = "payer_party_name");

Property payeracct As %String(CAPTION = "交款人账号", XMLNAME = "payer_acct");

Property payeropbk As %String(CAPTION = "交款人开户行", XMLNAME = "payer_opbk");

Property paymode As %String(CAPTION = "交款方式", XMLNAME = "paymode");

Property bizcode As %String(CAPTION = "业务流水号", XMLNAME = "bizcode");

Property currencytype As %String(CAPTION = "货币种类", XMLNAME = "currency_type");

Property exchangerate As %String(CAPTION = "汇率", XMLNAME = "exchange_rate");

Property remark As %String(CAPTION = "备注", XMLNAME = "remark");

Property handlingperson As %String(CAPTION = "开票人", XMLNAME = "handling_person");

Property checker As %String(CAPTION = "复核人", XMLNAME = "checker");

Property supervisorremark As %String(CAPTION = "财政部门备注", XMLNAME = "supervisor_remark");

/// 开具红票时所需字段节点
Property mainext As BILL.EINV.DTO.JSA.InvoiceRefInfo(CAPTION = "相关票据", XMLNAME = "main_ext");

/// 票面明细信息
Property detailitemlist As list Of BILL.EINV.DTO.JSA.InvoiceListDetail(CAPTION = "票面明细信息", XMLNAME = "detail_item_list");

/// 辅助明细信息
Property auxitemlist As list Of BILL.EINV.DTO.JSA.InvoiceAuxitemlist(CAPTION = "辅助明细信息", XMLNAME = "aux_item_list");

Property invoicingsealid As %String(CAPTION = "单位印章编号", XMLNAME = "invoicing_seal_id");

/// 票据开具后的寄送节点
Property recipientaddr As BILL.EINV.DTO.JSA.InvoiceAddress(CAPTION = "票据地址节点", XMLNAME = "recipient_addr");

Property attachinfo As %String(CAPTION = "附加信息", XMLNAME = "attach_info");

/// 医疗票相关信息
Property hisinfo As BILL.EINV.DTO.JSA.InvoiceHisInfo(CAPTION = "医疗票相关信息", XMLNAME = "his_info");

}
