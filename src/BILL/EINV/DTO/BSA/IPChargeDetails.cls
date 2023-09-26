Class BILL.EINV.DTO.BSA.IPChargeDetails Extends %RegisteredObject
{

/// 序号
Property sortNo As %String(TRUNCATE = 1, XMLNAME = "sortNo");

/// 收费项目代码
Property chargeCode As %String(TRUNCATE = 1, XMLNAME = "chargeCode");

/// 收费项目名称
Property chargeName As %String(TRUNCATE = 1, XMLNAME = "chargeName");

/// 计量单位
Property unit As %String(TRUNCATE = 1, XMLNAME = "unit");

/// 收费标准	
Property std As %String(TRUNCATE = 1, XMLNAME = "std");

/// 数量	
Property number As %String(TRUNCATE = 1, XMLNAME = "number");

/// 金额
Property amt As %String(TRUNCATE = 1, XMLNAME = "amt");

/// 自费金额
Property selfAmt As %String(TRUNCATE = 1, XMLNAME = "selfAmt");

/// 备注
Property remark As %String(TRUNCATE = 1, XMLNAME = "remark");

}
