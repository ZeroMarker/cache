/// 名称: DHCCPW.MR.BASE.PaadmSrv
/// 描述: 就诊表相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-30
Class DHCCPW.MR.BASE.PaadmSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCCPW.MR.BASE.PaadmSrv).GetEpisodeID(4939742)
ClassMethod GetEpisodeID(argMRAdm As %String) As %String
{
	New (argMRAdm)
	Set return=$p($g(^MR(+argMRAdm,"PRO",1)),"^",9)
	Quit return
}

/// w ##class(DHCCPW.MR.BASE.PaadmSrv).GetMRAdm(4939148)
ClassMethod GetMRAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=$p($g(^PAADM(+argEpisodeID)),"^",61)
	Quit return
}

}
