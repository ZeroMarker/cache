Class BILL.EINV.DTO.JSC.EInvInvoiceCom Extends %RegisteredObject
{

Property HOSID As %String(CAPTION = "医疗机构", XMLNAME = "HOS_ID");

Property appid As %String(CAPTION = "业务服务的编码", XMLNAME = "app_id");

Property Rcptno As %String(CAPTION = "HIS自己的发票号码", XMLNAME = "Rcpt_no");

/// 收费类型（1 门诊 2住院）
Property Sftype As %String(CAPTION = "收费类型", XMLNAME = "Sftype");

Property totalamount As %String(CAPTION = "总金额", XMLNAME = "total_amount");

Property payerpartytype As %String(CAPTION = "交款人类型", XMLNAME = "payer_party_type");

Property payerpartycode As %String(CAPTION = "患者身份证号码", XMLNAME = "payer_party_code");

Property payerpartyname As %String(CAPTION = "患者名称", XMLNAME = "payer_party_name");

Property recname As %String(CAPTION = "收款人全称", XMLNAME = "rec_name");

Property recacct As %String(CAPTION = "收款人账号", XMLNAME = "rec_acct");

Property recopbk As %String(CAPTION = "收款人开户行", XMLNAME = "rec_opbk");

Property payeracct As %String(CAPTION = "交款人账号", XMLNAME = "payer_acct");

Property payeropbk As %String(CAPTION = "交款人开户行", XMLNAME = "payer_opbk");

Property paymode As %String(CAPTION = "交款方式", XMLNAME = "paymode");

Property bizcode As %String(CAPTION = "医疗系统的业务流水号", XMLNAME = "bizcode");

Property currencytype As %String(CAPTION = "货币种类", XMLNAME = "currency_type");

Property exchangerate As %String(CAPTION = "汇率", XMLNAME = "exchange_rate");

Property remark As %String(CAPTION = "备注", XMLNAME = "remark");

Property handlingperson As %String(CAPTION = "开票人", XMLNAME = "handling_person");

Property checker As %String(CAPTION = "复核人", XMLNAME = "checker");

Property supervisorremark As %String(CAPTION = "财政部门备注", XMLNAME = "supervisor_remark");

/// 交款人类型 :1:个人  2:单位
Property mainext As BILL.EINV.DTO.JSC.EInvInvoiceMainext(CAPTION = "相关票据", XMLNAME = "main_ext");

Property detailitemlist As BILL.EINV.DTO.JSC.EInvInvoiceDetailitemlist(CAPTION = "票面明细信息", XMLNAME = "detail_item_list");

Property auxitemlist As %String(CAPTION = "辅助明细信息", XMLNAME = "aux_item_list");

Property recipientaddr As BILL.EINV.DTO.JSC.EInvInvoiceRecipientaddr(CAPTION = "票据开具后的寄送\通知目的", XMLNAME = "recipient_addr");

/// 附加信息，在业务上有特殊要求的在此协商增加扩展参数，格式一般约定为JSON ARRAY格式的字符串
Property attachinfo As %String(CAPTION = "附加信息", XMLNAME = "attach_info");

Property hisinfo As BILL.EINV.DTO.JSC.EInvInvoiceHisinfo(CAPTION = "医疗票相关信息", XMLNAME = "his_info");

}
