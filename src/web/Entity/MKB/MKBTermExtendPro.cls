/// Creator:丁亚男
/// CreatDate:2018-03-31
/// Description：医用知识库术语注册扩展属性实体类
/// Table：User.MKBTermBaseExtendPro
Class web.Entity.MKB.MKBTermExtendPro Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBTermExtendPro";

Property MKBTEPRowId As %String;

Property MKBTEPParRef As %String;

Property MKBTEPName As %String;

Property MKBTEPType As %String;

Property MKBTEPConfig As %String;

Property MKBTEPSequence As %String;

}
