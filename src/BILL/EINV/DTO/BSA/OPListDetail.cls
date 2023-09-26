/// 费用明细列表对象
Class BILL.EINV.DTO.BSA.OPListDetail Extends %RegisteredObject
{

Property listDetailNo As %String(CAPTION = "明细流水号");

Property chargeCode As %String(CAPTION = "收费项目代码");

Property chargeName As %String(CAPTION = "收费项目名称");

Property prescribeCode As %String(CAPTION = "处方编码");

/// 药品分类编码01，有则填写
Property listTypeCode As %String(CAPTION = "药品类别编码");

Property listTypeName As %String(CAPTION = "药品类别名称");

Property code As %String(CAPTION = "编码");

Property name As %String(CAPTION = "药品名称");

Property form As %String(CAPTION = "剂型");

Property specification As %String(CAPTION = "规格");

Property unit As %String(CAPTION = "计量单位");

Property std As %String(CAPTION = "单价");

Property number As %String(CAPTION = "数量");

Property amt As %String(CAPTION = "金额");

Property selfAmt As %String(CAPTION = "自费金额");

Property receivableAmt As %String(CAPTION = "应收费用");

Property medicalCareType As %String(CAPTION = "医保药品分类");

Property medCareItemType As %String(CAPTION = "医保项目类型");

Property medReimburseRate As %String(CAPTION = "医保报销比例");

Property remark As %String(CAPTION = "备注");

Property sortNo As %String(CAPTION = "序号");

Property chrgtype As %String(CAPTION = "费用类型");

}
