/// Description：科室分科字典表
/// Table：User.DHCDSSDiseaseDeptDict
Class web.CDSSEntity.CMKB.DiseaseDeptDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DiseaseDeptDict";

/// RowId
Property RowId As %String;

/// 科室编码
Property DeptCode As %String;

/// 科室名称
Property DeptName As %String;

/// 上级节点
Property FatherCodeDR As %String;

/// 上级节点名称
Property FatherCodeDRName As %String;

/// 科室分级
Property DeptGrade As %String;

/// 科室分类
Property DeptClass As %String;

/// 使用标志(0在用，1停用)
Property UseFlag As %String;

/// 创建时间
Property CreateDate As %String;

/// 创建人员
Property CreateUserID As %String;

/// 备注
Property Remarks As %String;

/// 别名
Property DeptAlias As %String;

}
