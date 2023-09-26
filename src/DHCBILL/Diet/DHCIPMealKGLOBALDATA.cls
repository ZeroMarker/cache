/// Lid
/// 2010-08-06
/// 清数据，慎用
Class DHCBILL.Diet.DHCIPMealKGLOBALDATA Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(DHCBILL.Diet.DHCIPMealKGLOBALDATA).KillGlaoblData()
ClassMethod KillGlaoblData()
{
 ;;;;;基础数据()
 k ^DHCIPMEALUOM ;单位数据
 k ^DHCIPMEALTYPE ;餐别数据
 k ^DHCIPMEALMODALITY  ;餐类型数据
 k ^DHCIPMEALITEM  ;菜定义数据
 k ^DHCIPMEALITEMALIAS ;菜别名数据
 ;以下两个不建议删除
 ;k ^DHCTREEGROUP  ;权限分配安全组
 ;k ^DHCTREENODE   ;导航树
 ;k ^DHCIPMEALSysSkin ;系统主题数据


 ;;;;;业务数据
 k ^DHCIPMEALMENU ;菜谱数据
 k ^DHCIPMEALORDER ;医嘱数据
 k ^DHCIPMEALBILL ;账单数据
}

}
