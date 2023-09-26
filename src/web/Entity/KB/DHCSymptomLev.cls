/// 名称: 症状分级表
/// 描述: 实体类
/// 编写者：谷雪萍
/// 编写日期: 2016-05-13
Class web.Entity.KB.DHCSymptomLev Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCSymptomLev";

Property SYLRowId As %String;

Property SYLCode As %String;

Property SYLDesc As %String;

/// 父节点
Property SYLLastRowid As %String;

/// 级别 0是根目录，1,一级，2二级,3三级
Property SYLLevel As %String;

/// 顺序
Property SYLSequence As %String;

}
