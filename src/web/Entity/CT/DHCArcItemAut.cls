/// / Function:限制用药
///  Creator: sunfengchao
///  CreateDate:2018-06-11
Class web.Entity.CT.DHCArcItemAut Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCArcItemAut";

Property ParRef As %String;

/// AUT_ARCIMSubscript 
Property AUTARCIMSubscript As %String;

/// AUT_ARCIMVersion
Property AUTARCIMVersion As %String;

/// AUT_Childsub
Property AUTRowID As %String;

/// AUT_Relation
Property AUTRelation As %String;

/// AUT_Type
Property AUTType As %String;

/// AUT_Operate
Property AUTOperate As %String;

/// AUT_Pointer
Property AUTPointer As %String;

/// 操作人
Property AUTAddUserDr As %String;

/// 操作日期
Property AUTDate As %String;

/// 操作时间
Property AUTTime As %String;

}
