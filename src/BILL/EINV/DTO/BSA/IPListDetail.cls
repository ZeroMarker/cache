/// 住院明细列表对象
Class BILL.EINV.DTO.BSA.IPListDetail Extends %RegisteredObject
{

/// 明细流水号
Property listDetailNo As %String(TRUNCATE = 1, XMLNAME = "listDetailNo");

/// 收费项目代码
Property chargeCode As %String(TRUNCATE = 1, XMLNAME = "chargeCode");

/// 收费项目代码
Property chargeName As %String(TRUNCATE = 1, XMLNAME = "chargeName");

/// 处方编码
Property prescribeCode As %String(TRUNCATE = 1, XMLNAME = "prescribeCode");

/// 药品类别编码
Property listTypeCode As %String(TRUNCATE = 1, XMLNAME = "listTypeCode");

/// 药品类别名称
Property listTypeName As %String(TRUNCATE = 1, XMLNAME = "listTypeName");

/// 药品编码
Property code As %String(TRUNCATE = 1, XMLNAME = "code");

/// 药品名称
Property name As %String(TRUNCATE = 1, XMLNAME = "name");

/// 剂型
Property form As %String(TRUNCATE = 1, XMLNAME = "form");

/// 规格
Property specification As %String(TRUNCATE = 1, XMLNAME = "specification");

/// 计量单位
Property unit As %String(TRUNCATE = 1, XMLNAME = "unit");

/// 单价
Property std As %String(TRUNCATE = 1, XMLNAME = "std");

/// 数量
Property number As %String(TRUNCATE = 1, XMLNAME = "number");

/// 金额
Property amt As %String(TRUNCATE = 1, XMLNAME = "amt");

/// 自费金额
Property selfAmt As %String(TRUNCATE = 1, XMLNAME = "selfAmt");

/// 应收费用
Property receivableAmt As %String(TRUNCATE = 1, XMLNAME = "receivableAmt");

/// 医保药品分类
Property medCareItemType As %String(TRUNCATE = 1, XMLNAME = "medCareItemType");

/// 医保报销比例
Property medReimburseRate As %String(TRUNCATE = 1, XMLNAME = "medReimburseRate");

/// 备注
Property remark As %String(TRUNCATE = 1, XMLNAME = "remark");

/// 序号
Property sortNo As %String(TRUNCATE = 1, XMLNAME = "sortNo");

/// 费用类型
Property chrgtype As %String(TRUNCATE = 1, XMLNAME = "chrgtype");

}
