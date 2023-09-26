/// 名称:检验标本维护 - 标本类型实体类
/// 编写者:基础平台组 - 谢海睿
/// 编写日期:2019-11-7
Class web.Entity.LAB.BTSpecimen Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTSpecimen";

Property RowID As %String;

// 代码

Property Code As %String;

// 内部名称

Property IName As %String;

// 外部名称

Property XName As %String;

// 英文缩写

Property EName As %String;

// 医院

Property HospitalDR As %String;

// HIS对照码

Property HISCode As %String;

// whone码

Property WCode As %String;

// 标本组

Property SpecimenGroupDR As %String;

// 序号

Property Sequence As %String;

// 激活

Property Active As %String;

// 采集注意事项

Property CollectPrompt As %String;

Property WhonetType As %String;

}
