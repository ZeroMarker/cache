/// Creator:高姗姗
/// CreatDate:2018-03-28
/// Description：医用知识库术语注册扩展属性实体类
/// Table：User.MKBTermBaseExtendPro
Class web.Entity.MKB.MKBTermBaseExtendPro Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBTermBaseExtendPro";

Property MKBTBEPRowId As %String;

Property MKBTBEPParRef As %String;

Property MKBTBEPName As %String;

Property MKBTBEPType As %String;

Property MKBTBEPConfig As %String;

Property MKBTBEPSequence As %String;

}
