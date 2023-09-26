Class DHCExternalService.RegInterface.Entity.SelfReg.List.daily Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 专家编码
Property DrId As %String(TRUNCATE = 1);

/// 专家姓名
Property DrName As %String(TRUNCATE = 1);

/// 挂很级别
Property DrLevel As %String(TRUNCATE = 1);

/// 挂号金额
Property DrMoney As %String(TRUNCATE = 1);

/// 预约人数
Property YNum As %String(TRUNCATE = 1);

/// 总人数
Property TotalNum As %String(TRUNCATE = 1);

}
