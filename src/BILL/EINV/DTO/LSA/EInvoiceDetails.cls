/// 广州乐税信息科技有限公司(乐税)--直连开票入参明细对象
Class BILL.EINV.DTO.LSA.EInvoiceDetails Extends %RegisteredObject
{

/// 明细行流水号（唯一）,对应NC字段：发票表体ID	
Property dtsGuid As %String(CAPTION = "明细行流水号");

Property goodsName As %String(CAPTION = "商品名称");

Property number As %String(CAPTION = "数量");

Property withoutTaxPrice As %String(CAPTION = "不含税单价");

Property amountWithoutTax As %String(CAPTION = "不含税金额");

Property taxAmount As %String(CAPTION = "税额");

/// O：可选参数
Property standard As %String(CAPTION = "规格型号");

Property unit As %String(CAPTION = "单位");

Property rate As %String(CAPTION = "税率");

Property taxTypeCode As %String(CAPTION = "税收分类编码");

/// 是否享受优惠（0：不享受；1：享受）  默认为不享受 地产板块开具补开营业税发票时需传值1
Property discountFlag As %String(CAPTION = "是否享受优惠");

/// 优惠政策类型 地产板块开具补开营业税发票时需传值：不征税
Property discountType As %String(CAPTION = "优惠政策类型");

Property rowIndex As %String(CAPTION = "行序");

/// 零税率标志 空串:非零税率,0出口退税,1免税,2不征收,3普通零税率},地产板块开具补开营业税发票时需传值2
Property taxZeroRate As %String(CAPTION = "零税率标志");

/// N
Property taxPrice As %String(CAPTION = "含税单价");

Property amountWithTax As %String(CAPTION = "含税金额");

Property discountNote As %String(CAPTION = "优惠政策说明");

/// 折扣标记 默认0，标记为折扣时值1
Property discountFlage As %String(CAPTION = "折扣标记");

Property discountAmountWithoutTax As %String(CAPTION = "折扣金额(不含税)");

Property discountRate As %String(CAPTION = "折扣率");

Property discountTaxAmount As %String(CAPTION = "折扣税额");

}
