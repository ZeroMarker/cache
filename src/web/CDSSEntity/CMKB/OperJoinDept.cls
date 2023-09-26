/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description：中医方剂字典关联中药字典表
/// Table：User.DHCDSSTCMPreJoinMed
Class web.CDSSEntity.CMKB.OperJoinDept Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.OperJoinDept";

/// RowId
Property RowId As %String;

/// 手术 指向手术字典
Property OperationDR As %String;

/// 科室 指向科室字典
Property DiseaseDeptDR As %String;

/// 手术分级[一级/二级/三级/四级]
Property OperationGrade As %String;

/// 手术分类[一类/二类/三类/四类]
Property OperationCategory As %String;

}
