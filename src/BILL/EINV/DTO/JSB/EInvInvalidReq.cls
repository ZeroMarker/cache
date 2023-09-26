/// 票据冲红接口
Class BILL.EINV.DTO.JSB.EInvInvalidReq Extends %RegisteredObject
{

Property method As %String(CAPTION = "方法名");

Property "channel_code" As %String(CAPTION = "渠道编码");

Property "org_code" As %String(CAPTION = "机构编码");

/// 请求时间，格式：yyyyMMddHHmmss
Property timestamp As %String(CAPTION = "请求时间");

/// MD5(method+timestamp+ 分  配   的accessKey)
Property sign As %String(CAPTION = "秘钥");

Property "total_amount" As %String(CAPTION = "开票金额");

Property "rec_name" As %String(CAPTION = "收款人全称");

Property "rec_acct" As %String(CAPTION = "收款人账号");

Property "rec_opbk" As %String(CAPTION = "收款人开户行");

/// 交款人类型  1:个人 2:单位
Property "payer_party_type" As %String(CAPTION = "交款人类型");

Property "payer_party_code" As %String(CAPTION = "交款人代码");

/// 交款人代码，单位一般为组织机构代码；个人一般为身份证号
Property "payer_party_name" As %String(CAPTION = "交款人名称");

Property "payer_acct" As %String(CAPTION = "交款人账号");

Property "payer_opbk" As %String(CAPTION = "交款人开户行");

Property paymode As %String(CAPTION = "交款方式");

/// 医疗系统的业务流水号，如一笔业务数据需要开具 N 张电子票据，则 N 张电子票对应该值保持一致
Property bizcode As %String(CAPTION = "业务流水号");

Property "currency_type" As %String(CAPTION = "货币种类");

Property "exchange_rate" As %String(CAPTION = "汇率");

Property remark As %String(CAPTION = "备注");

Property "handling_person" As %String(CAPTION = "开票人");

Property checker As %String(CAPTION = "复核人");

Property "supervisor_remark" As %String(CAPTION = "财政部门备注");

Property "main_ext" As BILL.EINV.DTO.JSB.EInvMainInfo(CAPTION = "相关票据");

Property "detail_item_list" As BILL.EINV.DTO.JSB.EInvDetailList(CAPTION = "票面明细信息");

Property "aux_item_list" As %String(CAPTION = "辅助明细信息");

Property "recipient_addr" As BILL.EINV.DTO.JSB.EInvDetailListAux(CAPTION = "票据开具后的寄送\通知目的");

/// 附加信息，在业务上有特殊要求的在此协商 增 加 扩 展 参 数 ， 格 式 一 般 约 定 为JsonArray 格式的字符串。
Property "attach_info" As %String(CAPTION = "附加信息");

}
