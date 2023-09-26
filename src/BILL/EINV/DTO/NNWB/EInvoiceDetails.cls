/// 开票明细对象组织参数
Class BILL.EINV.DTO.NNWB.EInvoiceDetails Extends %RegisteredObject
{

/// goodsName	String	Y	电脑	90商品名称（如invoiceLineProperty =1，则此商品行为折扣行，折扣行不允许多行 折扣，折扣行必须紧邻被折扣行，商品名 称必须与被折扣行一致）
Property goodsName As %String(CAPTION = " 商品名称");

/// goodsCode	String	N10905110🡪000001900000商品编码（商品税收分类编码开发者自行填写）
Property goodsCode As %String(CAPTION = " 商品编码");

/// selfCode	String	N1🡪000542600000000020	自行编码（可不填）
Property selfCode As %String(CAPTION = " 自行编码");

/// withTaxFlag	String	Y	1	1	单价含税标志：0:不含税,1:含税
Property withTaxFlag As %String(CAPTION = " 单价含税标志");

/// price	String	N	1	16单价，当单价(price)为空时，数量(num)也必须为空；(price)为空时，含税金额(ta xIncludedAmount)、不含税金额(taxEx cludedAmount)、税额(tax)都不能为空
Property price As %String(CAPTION = " 单价");

/// num	String	N	1	16	数量（开具红票时数量为负数）
Property num As %String(CAPTION = " 数量");

/// unit	String	N	台	20	单位
Property unit As %String(CAPTION = " 单位");

/// specType	String	N	y460	40	规格型号
Property specType As %String(CAPTION = " 规格型号");

/// tax	String	N	0.12	税额，[不含税金额] * [税率] = [税额]；税额允许误差为 0.06。红票为负。不含税金16	额、税额、含税金额任何一个不传时，会根据传入的单价，数量进行计算，可能和实际数值存在误差，建议都传入
Property tax As %String(CAPTION = " 税额");

/// taxRate	String	Y	0.1🡪	10	税率，注：纸票清单红票存在为null的情况
Property taxRate As %String(CAPTION = " 税率");

/// taxExcludedAmount	String	N	0.88 不含税金额。红票为负。不含税金额、税额、含税金额任何一个不传时，会根据传16入的单价，数量进行计算，可能和实际数值存在误差，建议都传入
Property taxExcludedAmount As %String(CAPTION = " 不含税金额");

/// taxIncludedAmount	String	N	1	16	含税金额，[不含税金额] + [税额] = [含税金额]，红票为负。不含税金额、税额、含税金额任何一个不传时，会根据传入的单价，数量进行计算，可能和实际数值存在误差，建议都传入
Property taxIncludedAmount As %String(CAPTION = " 含税金额");

/// invoiceLineProperty	String	N	0	1	发票行性质：0,正常行;1,折扣行;2,被折扣行
Property invoiceLineProperty As %String(CAPTION = " 发票行性质");

/// favouredPolicyFlag	String	N	0	1	优惠政策标识：0,不使用;1,使用增值税特殊管理（优惠政策名称）,当favo
Property favouredPolicyFlag As %String(CAPTION = " 优惠政策标识");

/// favouredPolicyName	String	N	0	50uredPolicyFlag为1时，此项必填扣除额，差额征收时填写，目前只支持填写一项。  注意：当传0、空或字段不传时
Property favouredPolicyName As %String(CAPTION = " 扣除额");

/// 零税率标识：空,非零税率;1,免税;2,不征税;🡪,普通零税率；1、当税率为：0%，且增值税特殊管理：为“免税”， 零税率标识	
/// 0	1	：需传“1” 2、当税率为：0%，且增值税特殊管理：为"不征税" 零税率标识：需传“2”  🡪、当税率为：0%，且增值税特殊管理：为空 零税率标识：需传“🡪”
Property zeroRateFlag As %String(CAPTION = " 零税率标识");

}
