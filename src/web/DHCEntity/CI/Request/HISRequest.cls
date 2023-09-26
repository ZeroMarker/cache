/// 门诊收费往: Ensumble发的接口
Class web.DHCEntity.CI.Request.HISRequest Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property Patients As web.DHCEntity.CI.PaPatMas;

/// 指令: 收费,退费
/// 药品
Property Service As %String(TRUNCATE = 1);

}
