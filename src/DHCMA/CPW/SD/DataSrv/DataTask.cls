Class DHCMA.CPW.SD.DataSrv.DataTask Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 数据中心抽取
ClassMethod ExtractData(aFromDate, aToDate) As %String
{
}

/// 单一病例数据抽取
/// EpisodeID:2816896
/// w ##class(DHCMA.CPW.SD.DataSrv.DataTask).ExtractByAdm(1,2814486)
ClassMethod ExtractByAdm(aSYSDr As %String = "1", EpisodeID) As %String
{
	Set return=EpisodeID
	Set EpisodeID=$p(EpisodeID,"!!",1)
	Set BaseRet=##class(DHCMA.CPW.SD.DataSrv.BaseInfoSrv).GetDataByAdm(EpisodeID)
	Set return=return_"同步基本信息成功;"
	Set OperCount=##class(DHCMA.CPW.SD.DataSrv.OperationSrv).SynOperDataByAdm(EpisodeID)
	Set return=return_"[同步手术记录："_OperCount_"条;"
	Set RisCount=##class(DHCMA.CPW.SD.DataSrv.RisInfoSrv).SynRisInfo(EpisodeID)
	Set return=return_"同步检查记录："_RisCount_"条;"
	Set OrdCount=##class(DHCMA.CPW.SD.DataSrv.OrderInfoSrv).SynOrdInfo(aSYSDr,EpisodeID)
	Set return=return_"同步医嘱记录："_OrdCount_"条;"
	Set lisret=##class(DHCMA.CPW.SD.DataSrv.LisInfoSrv).SynLisInfo(EpisodeID)
	Set return=return_"同步检验数据:"_lisret_";"
	Set Feeret=##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).SynFeeByAdm(EpisodeID)
	Set return=return_"同步费用数据成功;"
	Set Nurret=##class(DHCMA.CPW.SD.DataSrv.NurInfoSrv).SynNurDataByAdm(EpisodeID)
	Set return=return_"同步生命体征数据成功;"_Nurret_"]"
	Quit return
}

}
