/// Creator:谷雪萍
/// CreatDate:2018-05-19
/// Description：医用知识库术语扩展属性明细表
/// Table：User.MKBTermExtendProVal
Class web.Entity.MKB.MKBTermExtendProVal Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBTermExtendProVal";

Property MKBTEPVRowId As %String;

Property MKBTEPVDetailDr As %String;

Property MKBTEPVExtendDr As %String;

Property MKBTEPVValue As %String;

}
