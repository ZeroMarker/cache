/// 医疗清单明细
Class BILL.EINV.DTO.JSC.EInvInvoiceMeditemlist Extends %RegisteredObject
{

Property listno As %String(CAPTION = "医疗清单明细的序号", XMLNAME = "list_no");

Property chrgtypecode As %String(CAPTION = "费用类型编码", XMLNAME = "chrg_type_code");

/// 费用类型名称,例如：床位费、检查费
Property chrgtypename As %String(CAPTION = "费用类型名称", XMLNAME = "chrg_type_name");

/// 编码，例如药品编码，有的话如实填写
Property itemcode As %String(CAPTION = "编码", XMLNAME = "item_code");

/// 药品名称/剂型,如药品名称，器材名称等，当 med_item_list节点存在时必填
Property itemname As %String(CAPTION = "名称", XMLNAME = "item_name");

Property unit As %String(CAPTION = "计量单位");

Property std As %String(CAPTION = "单价");

Property num As %String(CAPTION = "数量");

Property amt As %String(CAPTION = "金额");

/// 自费金额，如果无自费，填0，当 med_item_list节点存在时必填
Property selfamt As %String(CAPTION = "自费金额", XMLNAME = "self_amt");

Property receivableamt As %String(CAPTION = "应收费用", XMLNAME = "receivable_amt");

Property medcareitemtype As %String(CAPTION = "医保项目类型", XMLNAME = "medcare_item_type");

Property medreimburserate As %String(CAPTION = "医保报销比例", XMLNAME = "med_reimburse_rate");

Property remark As %String(CAPTION = "备注信息");

Property itemgg As %String(CAPTION = "项目规格", XMLNAME = "item_gg");

Property zfrate As %String(CAPTION = "自付比例");

Property zfsx As %String(CAPTION = "支付上限");

Property zfje As %String(CAPTION = "自付金额");

Property zlje As %String(CAPTION = "自理金额");

Property recipeNum As %String(CAPTION = "处方号/医嘱号");

Property recipeSerialNum As %String(CAPTION = "处方流水号/医嘱流水号");

Property recipeDate As %String(CAPTION = "费用日期");

/// 自费病人传当地职工或居民医保中代码，如果没有对应关系请填'QZF'
Property centreChargeCode As %String(CAPTION = "医保收费项目编码");

Property medicareFeeitemName As %String(CAPTION = "医保收费项目名称");

Property formulation As %String(CAPTION = "药品剂型");

Property deptNum As %String(CAPTION = "科室编码");

Property deptName As %String(CAPTION = "科室名称");

Property doctorCode As %String(CAPTION = "处方/医嘱医生编码");

Property doctorName As %String(CAPTION = "处方/医嘱医生姓名");

Property updateBy As %String(CAPTION = "经办人");

Property execDeptName As %String(CAPTION = "执行科室名称");

/// 1甲类 2乙类 3自费 4置换（国产） 5适当放宽 6五免 7比例自付 8置换（进口） 9晶体 99大类（其他）
Property itemLevel As %String(CAPTION = "收费项目等级编码");

Property itemId As %String(CAPTION = "费用明细ID");

Property orderType As %String(CAPTION = "医嘱类别");

Property billNum As %String(CAPTION = "结算流水号");

}
