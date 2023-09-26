/// 名称: DHCWMR.SSService.ReviewSrv
/// 描述: 病历复核处置相关服务
/// 编写者：zhufei
/// 编写日期: 2015-01-28
Class DHCWMR.SSService.ReviewSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  病历复核通过
/// Input：       VolID : 卷ID
///               UserID : 用户ID
/// Return:		  返回String
/// w ##class(DHCWMR.SSService.ReviewSrv).ReviewPass()
ClassMethod ReviewPass(aVolID As %String, aUserID As %String) As %String
{
	New (aVolID,aUserID)
	Set return="0^参数错误"
	Quit:(aVolID="")||(aUserID="") return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Set MrTypeID=objVol.SVMainDr.SMMrType.%Id()
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Quit:EpisodeID="" return
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"RV")  //病历复核
	Quit:'$IsObject(objWFItem) return
	Set WFItemID=objWFItem.%Id()
	
	Set return="-1^当前状态不允许病历复核"
	Set flg=##class(DHCWMR.SSService.OperationSrv).CheckOperation(aVolID,WFItemID)
	Quit:(+flg)<1 return
	
	TStart
	
	Set return="-2^病历复核通过保存错误"
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	Set RecordID=aVolID
	Set flg=##class(DHCWMR.SSService.OperationSrv).Operation(RecordID,WFItemID,"",aUserID,"","",BatchNumber)
	If (+flg)<1 {
		TRollback
		Quit return
	}
	
	Set return="-3^设置电子病历复核状态错误"
	Set flg=##class(DHCWMR.IO.FromEprSrv).SetReviewInfo(EpisodeID,aUserID)
	If (+flg)<1 {
		TRollback
		Quit return
	}
	
	TCommit
	
	Set return="1^病历复核通过"
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  病历复核未通过,修改病历状态
/// Input：       VolID : 卷ID
///               UserID : 用户ID
/// Return:		  返回String
/// w ##class(DHCWMR.SSService.ReviewSrv).ReviewNotPass()
ClassMethod ReviewNotPass(aVolID As %String, aUserID As %String, aFinalAccountFlag As %String, aMRCompletionFlag As %String, aRemark As %String) As %String
{
	New (aVolID,aUserID,aFinalAccountFlag,aMRCompletionFlag,aRemark)
	Set return="0^参数错误"
	Quit:(aVolID="")||(aUserID="") return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Set MrTypeID=objVol.SVMainDr.SMMrType.%Id()
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Quit:EpisodeID="" return
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"UR")  //病历复核不通过
	Quit:'$IsObject(objWFItem) return
	Set WFItemID=objWFItem.%Id()
	
	TStart
	
	Set return="-1^病历复核不通过保存错误"
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	Set RecordID=aVolID
	Set flg=##class(DHCWMR.SSService.OperationSrv).Operation(RecordID,WFItemID,"",aUserID,"","",BatchNumber,aRemark)
	If (+flg)<1 {
		TRollback
		Quit return
	}
	
	Set return="-2^修正电子病历复核状态"
	Set flg=##class(DHCWMR.IO.FromEprSrv).SetCheckFailFlag(EpisodeID,aFinalAccountFlag,aMRCompletionFlag,aRemark)
	If (+flg)<1 {
		TRollback
		Quit return
	}
	
	TCommit
	
	Set return="1^病历复核不通过"
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  财务审核通过
/// Input：       EpisodeID : 就诊号
///               UserID : 用户ID
/// Return:		  返回String
/// w ##class(DHCWMR.SSService.ReviewSrv).FinaAuditPass()
ClassMethod FinaAuditPass(aEpisodeID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aUserID)
	Set return=0
	Quit:(aEpisodeID="")||(aUserID="") return
	Set return=##class(DHCWMR.IO.FromHisSrv).UpdateCodingFlag(aEpisodeID,aUserID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  撤销财务审核
/// Input：       EpisodeID : 就诊号
///               UserID : 用户ID
/// Return:		  返回String
/// w ##class(DHCWMR.SSService.ReviewSrv).FinaAuditNotPass()
ClassMethod FinaAuditNotPass(aEpisodeID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aUserID)
	Set return=0
	Quit:(aEpisodeID="")||(aUserID="") return
	Set return=##class(DHCWMR.IO.FromHisSrv).Cconfirm(aEpisodeID,aUserID)
	Quit return
}

}
