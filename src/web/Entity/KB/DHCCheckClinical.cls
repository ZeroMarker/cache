/// 名称:临床意义
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2020-7-28
Class web.Entity.KB.DHCCheckClinical Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCCheckClinical";

Property LABCRowId As %String;

Property LABCInstDr As %String;

Property PHINSTText As %String;

// 主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

Property LABCCliText As %String;

}
