/// Creator:高姗姗
/// CreatDate:2018-03-27
/// Description：医用知识库术语注册属性实体类
/// Table：User.MKBTermBaseProperty
Class web.Entity.MKB.MKBTermBaseProperty Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBTermBaseProperty";

Property MKBTBPRowId As %String;

Property MKBTBPCode As %String;

Property MKBTBPDesc As %String;

Property MKBTBPType As %String;

Property MKBTBPBaseDr As %String;

Property MKBTBPConfig As %String;

Property MKBTBPName As %String;

Property MKBTBPFlag As %String;

Property MKBTBPSequence As %String;

Property MKBTBPDefinedNode As %String;

Property MKBTBPIsShowInLeft As %String;

Property MKBTBPCodeRules As %String;

/// 医为百科展示方式2020-06-20
Property MKBTBPWikiShow As %String;

}
