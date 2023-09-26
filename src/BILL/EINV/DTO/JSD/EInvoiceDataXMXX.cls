Class BILL.EINV.DTO.JSD.EInvoiceDataXMXX Extends %RegisteredObject
{

/// 发票行性质 0正常行、1折扣行、2被折扣行
Property fphxz As %String(CAPTION = "发票行性质");

/// 商品编码(商品编码为税务总局颁发的19位税控编码)
Property spbm As %String(CAPTION = "商品编码");

/// (一般不建议使用自行编码)
Property zxbm As %String(CAPTION = "自行编码");

/// 优惠政策标识 0：不使用，1：使用
Property yhzcbs As %String(CAPTION = "优惠政策标识");

/// 零税率标识 空：非零税率， 1：免税，2：不征收，3普通零税率
Property lslbs As %String(CAPTION = "零税率标识");

/// 增值税特殊管理-如果yhzcbs为1时，此项必填
Property zzstsgl As %String(CAPTION = "增值税特殊管理");

/// 项目名称 ,必须与商品编码表一致
Property xmmc As %String(CAPTION = "项目名称");

/// 规格型号(折扣行请不要传)
Property ggxh As %String(CAPTION = "规格型号");

/// 计量单位(折扣行请不要传)
Property dw As %String(CAPTION = "计量单位");

/// 项目数量,大于0的数字
Property xmsl As %String(CAPTION = "项目数量");

/// 项目单价 ,注意：单价是含税单价,大于0的数字，小数点后六位
Property xmdj As %String(CAPTION = "项目单价");

/// 项目金额 注意：金额是含税，单位：元（2位小数）
Property xmje As %String(CAPTION = "项目金额");

/// 税率 例6%为0.06
Property sl As %String(CAPTION = "税率");

/// 税额 单位：元（2位小数）
Property se As %String(CAPTION = "税额");

}
