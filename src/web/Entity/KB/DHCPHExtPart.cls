/// 名称: 检查部位字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-4
Class web.Entity.KB.DHCPHExtPart Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHExtPart";

/// PHEP_RowId
Property PHEPRowId As %String;

/// PHEP_Code
Property PHEPCode As %String;

/// PHEP_Desc
Property PHEPDesc As %String;

/// PHEP_AcitveFlag
Property PHEPAcitveFlag As %String;

/// PHEP_SysFlag
Property PHEPSysFlag As %String;

}
