/// Creator:高姗姗
/// CreatDate:2021-09-03
/// Description：CDSS知识库术语注册扩展属性实体类
/// Table：CT.WDT.CDSS.TermBaseExtendPro
Class web.CDSSEntity.CMKB.TermBaseExtendPro Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TermBaseExtendPro";

Property MKBTBEPRowId As %String;

Property MKBTBEPParRef As %String;

Property MKBTBEPName As %String;

Property MKBTBEPType As %String;

Property MKBTBEPConfig As %String;

Property MKBTBEPSequence As %String;

}
