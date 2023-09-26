/// 名称: DHCHAI.DPS.SyncErrLogSrv
/// 描述: 错误日志相关服务
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.DPS.SyncErrLogSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-04-19
/// Description:  保存同步过程中的错误记录
/// Input：       aEpisodeID : 就诊ID
/// 			  aClass：执行类
/// 			  aMethod：执行方法
/// 			  aArgs：执行参数
/// Return：      日志ID
/// w ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog()
ClassMethod SaveErrLog(aEpisodeID As %String, aClass As %String, aMethod As %String, aArgs As %List) As %String
{
	New (aEpisodeID,aClass,aMethod,aArgs)
	Set return=""
	Quit:(aClass="")||(aMethod="") return
	
	Set InputStr = ""
	Set InputStr = InputStr_"^"_aEpisodeID
	Set InputStr = InputStr_"^"_aClass
	Set InputStr = InputStr_"^"_aMethod
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_+$p($h,",",2)
	Set return=##class(DHCHAI.DP.SyncErrLog).Update(InputStr,aArgs,"^")
	Quit return
}

}
