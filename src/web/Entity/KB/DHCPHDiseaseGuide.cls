/// 名称：确诊病症指南
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-4-19
Class web.Entity.KB.DHCPHDiseaseGuide Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseaseGuide";

Property PDGRowId As %String;

Property PDGDisDr As %String;

Property PDGLabelDr As %String;

Property PDGId As %String;

Property PDGText As %String;

Property PDGSysFlag As %String;

}
