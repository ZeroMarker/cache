/// 发票费用明细信息对象
Class BILL.EINV.DTO.COM.InvItmDetailInfo Extends %RegisteredObject
{

Property DetailNo As %String(CAPTION = "明细流水号");

Property CateCode As %String(CAPTION = "分类编码");

Property CateDesc As %String(CAPTION = "分类名称");

Property PresNo As %String(CAPTION = "处方编码");

Property DrugTypeCode As %String(CAPTION = "药品类别编码");

Property DrugTypeDesc As %String(CAPTION = "药品类别名称");

Property TarCode As %String(CAPTION = "项目编码");

Property TarDesc As %String(CAPTION = "项目名称");

Property Form As %String(CAPTION = "剂型");

Property FormCode As %String(CAPTION = "剂型编码");

Property Spec As %String(CAPTION = "规格");

Property Unit As %String(CAPTION = "计量单位");

Property Price As %String(CAPTION = "单价");

Property Qty As %String(CAPTION = "数量");

Property Amt As %String(CAPTION = "金额");

Property SelfAmt As %String(CAPTION = "自费金额");

Property RecAmt As %String(CAPTION = "应收费用");

/// 1：无自负-甲   2：有自负-乙   3：全自负-丙
Property Insutjdm As %String(CAPTION = "医保药品分类");

Property Insuxmlb As %String(CAPTION = "医保项目类型");

Property InsuScale As %String(CAPTION = "医保报销比例");

Property Remark As %String(CAPTION = "备注");

Property SortNo As %String(CAPTION = "序号");

Property ChrgType As %String(CAPTION = "费用类型");

}
