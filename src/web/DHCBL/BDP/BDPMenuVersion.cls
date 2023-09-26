/// 名称: 菜单版本定义
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2021-08-31
Class web.DHCBL.BDP.BDPMenuVersion Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2021-08-31
/// Description：获取菜单版本号
/// Table：User.BDPMenu
/// Input：id
/// w ##class(web.DHCBL.BDP.BDPMenuVersion).GetMenuVersion"1")
ClassMethod GetMenuVersion(id As %String) As %String
{
	n (id)
	s $ZT="ERROR"
	s str="" 
	s ShortcutKey=$LISTGET($G(^User.BDPMenuD(id)),9)
	if ShortcutKey'=""
	{
		s xstr="s VersionSuffix="_ShortcutKey
		x xstr
		q VersionSuffix
	}
	q str
ERROR
	Q ""
}

}
