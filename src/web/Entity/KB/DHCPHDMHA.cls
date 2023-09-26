/// 名称:注意事项
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.Entity.KB.DHCPHDMHA Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDMHA";

Property PDAIRowId As %String;

Property PDAICode As %String;

Property PDAIText As %String;

Property PDAIOrdNum As %String;

Property PDAIInstDr As %String;

/// PHINST_Text不良反应/注意事项
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
