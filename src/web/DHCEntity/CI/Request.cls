/// 接口请求类
Class web.DHCEntity.CI.Request Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property Patients As list Of PaPatMas;

/// 指令: 收费,退费
/// 药品
Property Service As %String(TRUNCATE = 1);

}
