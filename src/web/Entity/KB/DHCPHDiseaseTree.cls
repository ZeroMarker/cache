/// 名称：诊断逻辑推导目录表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-12
Class web.Entity.KB.DHCPHDiseaseTree Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseaseTree";

Property PDTRowId As %String;

Property PDTCode As %String;

Property PDTDesc As %String;

Property PDTLastRowid As %String;

Property PDTLevel As %String;

Property PDTActiveFlag As %String;

Property PDTSysFlag As %String;

}
