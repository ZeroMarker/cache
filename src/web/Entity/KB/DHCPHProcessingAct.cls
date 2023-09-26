/// 名称:炮制作用
/// 描述: 实体类
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2017-3-27
Class web.Entity.KB.DHCPHProcessingAct Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHProcessingAct";

Property PACTRowId As %String;

Property PACTCode As %String;

Property PACTText As %String;

Property PACTOrdNum As %String;

Property PACTInstDr As %String;

Property PHINSTText As %String;

//主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

}
