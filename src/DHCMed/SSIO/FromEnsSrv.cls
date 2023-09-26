/// 名称: DHCMed.SSIO.FromEnsSrv
/// 描述: 集成平台组提供接口服务
/// 编写者：zhufei
/// 编写日期: 2015-10-15
Class DHCMed.SSIO.FromEnsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-10-15
/// Description:  集成平台统一接口
/// Input：       ProCode : 产品代码
///               ReportID : 报告ID
///               Status : 状态
///               EpisodeID : 就诊号
/// 产品代码说明：S00000018:传染病报告(状态: 1上报、2审核、3退回、4删除、5取消审核)
///               S00000040:传染病筛查(状态：1确诊、2排除、4上报)
///               S00000019:医院感染报告(状态：1上报、2审核、3退回、4删除 、5取消审核、6未读消息、7确定未报)
///               S00000041:疑似病例筛查(状态：1排除、2疑似、3确诊、4上报)
///               S00000023:特殊患者发消息(状态：1新增、2回复)
///               S00000038:特殊患者标记关闭
/// Return：      返回String
/// w ##class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("","","","")
ClassMethod DHCHisInterface(aProCode As %String, aReportID As %String, aStatus As %String, aEpisodeID As %String) As %String
{
	New (aProCode,aReportID,aStatus,aEpisodeID)
	Set return=0
	Set $ZT="DHCHisInterfaceErr"
	Set return=##class(web.DHCENS.EnsHISService).DHCHisInterface(aProCode,aReportID,aStatus,aEpisodeID)
	Quit return
DHCHisInterfaceErr
	Quit return
}

}
