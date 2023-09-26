/// 名称: DHCWMR.IO.FromEnsSrv
/// 描述: 集成平台组提供接口服务
/// 编写者：zhufei
/// 编写日期: 2015-01-13
Class DHCWMR.IO.FromEnsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-13
/// Description:  集成平台统一接口
/// Input：       EpisodeID : 就诊号
///               KeyName : 操作关键字
/// Return：      返回String
/// w ##class(DHCWMR.IO.FromEnsSrv).DHCHisInterface(5620763,"")
ClassMethod DHCHisInterface(aEpisodeID As %String, aKeyName As %String) As %String
{
	New (aEpisodeID,aKeyName)
	Set return=##class(web.DHCENS.EnsHISService).DHCHisInterface(aEpisodeID,aKeyName)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-13
/// Description:  集成平台上传统计汇总数据
/// Input：       Date : 日期
/// Return：      返回String
/// w ##class(DHCWMR.IO.FromEnsSrv).SendToUNIBAIPDaily("")
ClassMethod SendToUNIBAIPDaily(aDate As %String) As %String
{
	New (aDate)
	Set return=##class(web.DHCENS.BLL.Empi.Method.SendToUNIBA).SendToUNIBAIPDaily(aDate)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-13
/// Description:  集成平台上传统计明细数据
/// Input：       Date : 日期
/// Return：      返回String
/// w ##class(DHCWMR.IO.FromEnsSrv).SendToUNIBAIPDetail("")
ClassMethod SendToUNIBAIPDetail(aDate As %String) As %String
{
	New (aDate)
	Set return=##class(web.DHCENS.BLL.Empi.Method.SendToUNIBA).SendToUNIBAIPDetail(aDate)
	Quit return
}

}
