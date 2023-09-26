Class BILL.EINV.DTO.JSA.InvoiceMeditemList Extends %RegisteredObject
{

Property listno As %String(CAPTION = "医疗清单明细的序号", XMLNAME = "list_no");

Property chrgtypecode As %String(CAPTION = "费用类型编码", XMLNAME = "chrg_type_code");

Property chrgtypename As %String(CAPTION = "费用类型名称", XMLNAME = "chrg_type_name");

Property itemcode As %String(CAPTION = "药品编码", XMLNAME = "item_code");

Property itemname As %String(CAPTION = "药品名称", XMLNAME = "item_name");

Property unit As %String(CAPTION = "计量单位", XMLNAME = "unit");

Property std As %String(CAPTION = "单价", XMLNAME = "std");

Property num As %String(CAPTION = "数量", XMLNAME = "num");

Property amt As %String(CAPTION = "金额", XMLNAME = "amt");

Property selfamt As %String(CAPTION = "自费金额", XMLNAME = "self_amt");

Property receivableamt As %String(CAPTION = "应收费用", XMLNAME = "receivable_amt");

Property medcareitemtype As %String(CAPTION = "医保项目类型", XMLNAME = "medcare_item_type");

Property medreimburserate As %String(CAPTION = "医保报销比例", XMLNAME = "med_reimburse_rate");

Property remark As %String(CAPTION = "备注信息", XMLNAME = "remark");

}
