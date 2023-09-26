/// 名称:病人管理-患者来源
/// 描述:患者来源实体类
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-4-3
Class web.Entity.CT.PACPatientSource Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACPatientSource";

/// id
Property PSRowId As %String;

/// 代码
Property PSCode As %String;

/// 描述
Property PSDesc As %String;

/// 开始日期
Property PSDateFrom As %String;

/// 结束日期
Property PSDateTo As %String;

}
