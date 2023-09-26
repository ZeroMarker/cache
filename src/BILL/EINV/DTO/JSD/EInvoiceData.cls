Class BILL.EINV.DTO.JSD.EInvoiceData Extends %RegisteredObject
{

Property dataresources As %String(CAPTION = "数据源，固定参数 “API”", XMLNAME = "data_resources");

Property nsrsbh As %String(CAPTION = "销售方纳税人识别号");

/// 业务单据号；必须是唯一的（不能超过45位）
Property ordernum As %String(CAPTION = "业务单据号", XMLNAME = "order_num");

/// 税收编码版本号，参数“32.0”，具体值请询问提供商
Property bmbbbh As %String(CAPTION = "税收编码版本号", XMLNAME = "bmb_bbh");

/// 税控盘号（使用税控盒子必填，API接口填空字符串即可）
Property skph As %String(CAPTION = "税控盘号");

/// 征税方式 0：普通征税 1: 减按计增 2：差额征税
Property zsfs As %String(CAPTION = "征税方式");

/// 特殊票种标识:“00”=正常票种,“02”=农产品收购
Property tspz As %String(CAPTION = "特殊票种标识");

Property xsfnsrsbh As %String(CAPTION = "销售方纳税人识别号", XMLNAME = "xsf_nsrsbh");

Property xsfmc As %String(CAPTION = "销售方名称", XMLNAME = "xsf_mc");

Property xsfdzdh As %String(CAPTION = "销售方地址、电话", XMLNAME = "xsf_dzdh");

Property xsfyhzh As %String(CAPTION = "销售方开户行名称与银行账号", XMLNAME = "xsf_yhzh");

/// 购买方纳税人识别号(税务总局规定企业用户为必填项)
Property gmfnsrsbh As %String(CAPTION = "购买方纳税人识别号", XMLNAME = "gmf_nsrsbh");

Property gmfmc As %String(CAPTION = "购买方名称", XMLNAME = "gmf_mc");

Property gmfdzdh As %String(CAPTION = "购买方地址、电话", XMLNAME = "gmf_dzdh");

Property gmfyhzh As %String(CAPTION = "购买方开户行名称与银行账号", XMLNAME = "gmf_yhzh");

Property kpr As %String(CAPTION = "开票人(长度20)");

Property skr As %String(CAPTION = "收款人(长度16)");

Property fhr As %String(CAPTION = "复核人(长度16)");

Property yfpdm As %String(CAPTION = "原发票代码", XMLNAME = "yfp_dm");

Property yfphm As %String(CAPTION = "原发票号码", XMLNAME = "yfp_hm");

/// 价税合计;单位：元（2位小数） 价税合计=合计金额(不含税)+合计税额 注意：
/// 不能使用商品的单价、数量、税率、税额来进行累加，最后四舍五入，只能是总合计金额+合计税额
Property jshj As %String(CAPTION = "价税合计");

/// 合计金额 注意：不含税，单位：元(2位小数)
Property hjje As %String(CAPTION = "合计金额");

/// 合计税额单位：元（2位小数）
Property hjse As %String(CAPTION = "合计税额单位");

/// 扣除额小数点后2位，当ZSFS为2时扣除额为必填项
Property kce As %String(CAPTION = "扣除额");

/// 备注长度应减去”对应正数发票代码:XXXXXXXXXXXX号码:YYYYYYYY\n”字样长度，长度剩余140
Property bz As %String(CAPTION = "备注");

Property jffphone As %String(CAPTION = "手机号", XMLNAME = "jff_phone");

Property jffemail As %String(CAPTION = "电子邮件", XMLNAME = "jff_email");

Property noticeurl As %String(CAPTION = "回传开票(待使用)", XMLNAME = "notice_url");

Property commonfpkjxmxx As list Of BILL.EINV.DTO.JSD.EInvoiceDataXMXX(CAPTION = "商品明细", XMLNAME = "common_fpkj_xmxx");

}
