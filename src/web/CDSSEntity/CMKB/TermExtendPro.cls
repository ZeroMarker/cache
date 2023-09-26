/// Creator:丁亚男
/// CreatDate:2018-03-31
/// Description：医用知识库术语注册扩展属性实体类
/// Table：web.CDSSEntity.CMKB.TermExtendPro
Class web.CDSSEntity.CMKB.TermExtendPro Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TermExtendPro";

Property MKBTEPRowId As %String;

Property MKBTEPParRef As %String;

Property MKBTEPName As %String;

Property MKBTEPType As %String;

Property MKBTEPConfig As %String;

Property MKBTEPSequence As %String;

}
