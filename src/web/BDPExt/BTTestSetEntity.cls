/// 名称:标准版检验-项目组合套（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2019-11-6
Class web.BDPExt.BTTestSetEntity Extends web.Entity.LAB.BTTestSet
{

Parameter PersistentClassName = "web.BDPExt.BTTestSetEntity";

// 医院

Property HospitalDesc As %String;

// 适合性别 

Property SpeciesDesc As %String;

// 默认标本类型

Property SpecimenDesc As %String;

// 默认容器

Property ContainerDesc As %String;

// 默认工作小组

Property WorkGroupMachineDesc As %String;

// 收费项目

Property CostItemDesc As %String;

// 采集提示 

Property CollectPromptDesc As %String;

// 取报告提示

Property ReportPromptDesc As %String;

// 医嘱所属工作组

Property WorkGroupDesc As %String;

}
