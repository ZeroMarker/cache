/// 名称: 病症字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-5
/// 修改日期：2016-5-19 加拼音码字段
Class web.Entity.KB.DHCPHDiseaseList Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseaseLis";

Property PHDISLRowId As %String;

Property PHDISLDiseaCode As %String;

Property PHDISLDiseaDesc As %String;

Property PHDISLActiveFlag As %String;

Property PHDISLSysFlag As %String;

//拼音码

Property PHDISLKey As %String;

//备注

Property PHDISLRemark As %String;

}
