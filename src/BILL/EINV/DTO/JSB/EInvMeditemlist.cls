/// 医疗清单明细
Class BILL.EINV.DTO.JSB.EInvMeditemlist Extends %RegisteredObject
{

Property "list_no" As %String(CAPTION = "医疗清单明细的序号");

Property "chrg_type_code" As %String(CAPTION = "费用类型编码");

Property "chrg_type_name" As %String(CAPTION = "费用类型名称");

Property "item_code" As %String(CAPTION = "编码");

Property "item_name" As %String(CAPTION = "名称");

Property unit As %String(CAPTION = "计量单位");

Property std As %String(CAPTION = "单价");

Property num As %String(CAPTION = "数量");

Property amt As %String(CAPTION = "金额");

Property "self_amt" As %String(CAPTION = "自 费 金 额 ");

Property "receivable_amt" As %String(CAPTION = "应收费用");

Property "medcare_item_type" As %String(CAPTION = "医保项目类型");

Property "med_reimburse_rate" As %String(CAPTION = "医保报销比例");

Property remark As %String(CAPTION = "备注信息");

}
