/// Creator:谷雪萍
/// CreatDate:2018-03-26
/// Description：医用知识库术语属性明细表
/// Table：User.MKBTermProperty
Class web.Entity.MKB.MKBTermProDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBTermProDetail";

Property MKBTPDRowId As %String;

Property MKBTPDCode As %String;

Property MKBTPDDesc As %String;

Property MKBTPDProDR As %String;

Property MKBTPDLastLevel As %String;

Property MKBTPDLevel As %String;

Property MKBTPDRemark As %String;

Property MKBTPDActiveFlag As %String;

Property MKBTPDExtend As %String;

Property MKBTPDSequence As %String;

Property MKBTPDPYCode As %String;

}
