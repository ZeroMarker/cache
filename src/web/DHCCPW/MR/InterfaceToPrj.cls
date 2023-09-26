/// 名称: web.DHCCPW.MR.InterfaceToPrj
/// 描述: 临床路径To项目数据接口(如果不需要，方法代码注释掉)
/// 编写者：zhufei
/// 编写日期: 2012-03-21
Class web.DHCCPW.MR.InterfaceToPrj Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCCPW.MR.InterfaceToPrj).InPathWayToHIS(EpisodeID^PathWayID)
ClassMethod InPathWayToHIS(aArgument As %String) As %String
{
	New (aArgument)
	//Set return=##Class(web.DHCCPW.HTSrv.PathWaySrv).InPathWayToHIS(aArgument)
	Set return=1
	Quit return
}

/// w ##Class(web.DHCCPW.MR.InterfaceToPrj).ClosePathWayToHIS()
ClassMethod ClosePathWayToHIS(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	//Set return=##Class(web.DHCCPW.HTSrv.PathWaySrv).ClosePathWayToHIS(aEpisodeID)
	Set return=1
	Quit return
}

/// w ##Class(web.DHCCPW.MR.InterfaceToPrj).GetAdmCateFees()
ClassMethod GetAdmCateFees(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	//Set return=##class(web.DHCCPW.HTSrv.CommonSrv).GetAdmCateFees(aEpisodeID)
	Set return=""
	Quit return
}

/// w ##Class(web.DHCCPW.MR.InterfaceToPrj).CheckArcimConsistency()
ClassMethod CheckArcimConsistency(aArcimID As %String) As %String
{
	New (aArcimID)
	//Set return=##Class(web.DHCCPW.HTSrv.OEOrderSrv).CheckArcimConsistency(aArcimID)
	Set return=""
	Quit return
}

/// w ##Class(web.DHCCPW.MR.InterfaceToPrj).getOEOrdExec()
ClassMethod getOEOrdExec(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	//Set ZYH=##class(web.DHCCPW.HTSrv.CommonSrv).ChangeAdmToIPNo(+aEpisodeID)
	//Set return=##Class(web.DHCCPW.HTSrv.OEOrdExecSrv).getOEOrdExec(ZYH)
	Set return=""
	Quit return
}

/// w ##Class(web.DHCCPW.MR.InterfaceToPrj).ChangeAdmToIPNo()
ClassMethod ChangeAdmToIPNo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	//Set return=##class(web.DHCCPW.HTSrv.CommonSrv).ChangeAdmToIPNo(+aEpisodeID)
	Set return=""
	Quit return
}

/// w ##Class(web.DHCCPW.MR.InterfaceToPrj).GetArcimIDByYZDM()
ClassMethod GetArcimIDByYZDM(aYPDM As %String, aYPGG As %String) As %String
{
	New (aYPDM,aYPGG)
	//Set return=##Class(web.DHCCPW.HTSrv.CommonSrv).GetArcimIDByYZDM(aYPDM,aYPGG)
	Set return=""
	Quit return
}

/// w ##Class(web.DHCCPW.MR.InterfaceToPrj).GetDataByPaadm()
ClassMethod GetDataByPaadm(aPaadm As %String, aType As %String) As %String
{
	New (aPaadm,aType)
	//Set return=##Class(web.DHCCPW.HTSrv.AnalysisBatHTZZ).GetDataByPaadm(aPaadm,aType)
	Set return=""
	Quit return
}

}
