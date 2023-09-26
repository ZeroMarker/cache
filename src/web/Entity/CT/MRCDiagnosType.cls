/// 名称: 电子病例-诊断类型
/// 描述: 实体类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2014-12-11
Class web.Entity.CT.MRCDiagnosType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.MRCDiagnosType";

Property DTYPRowId As %String;

Property DTYPCode As %String;

Property DTYPDesc As %String;

Property DTYPNoSendToCoding As %String;

/// zrf 2022-12-26 就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
Property DTYPClinicType As %String;

/// Date From
Property DTYPDateFrom As %String;

/// Date To
Property DTYPDateTo As %String;

/// 就诊类型 门诊
Property DTYPClinicTypeO As %String;

/// 就诊类型 急诊
Property DTYPClinicTypeE As %String;

/// 就诊类型 住院
Property DTYPClinicTypeI As %String;

/// 就诊类型 体检
Property DTYPClinicTypeH As %String;

/// 就诊类型 新生儿
Property DTYPClinicTypeN As %String;

}
