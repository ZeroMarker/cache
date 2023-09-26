/// 名称: DHCWMR.SSService.ReviseSrv
/// 描述: 病案卷状态修订相关服务
/// 编写者：zhufei
/// 编写日期: 2015-01-30
Class DHCWMR.SSService.ReviseSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  修订卷状态标记
/// Input：       StatusID : 卷状态ID
///               ReviseCode : 修订标记(U作废、B回置)
///               UserID : 修订人
/// Return:		  返回String
/// w ##class(DHCWMR.SSService.ReviseSrv).ReviseUpdate("98||2","",9)
ClassMethod ReviseUpdate(aStatusID As %String, aReviseCode As %String, aUserID As %String) As %String
{
	New (aStatusID,aReviseCode,aUserID)
	Set return=0
	Quit:(aStatusID="")||(aUserID="") return
	
	Set return=-1
	Set flg=##class(DHCWMR.SS.VolStatus).ReviseUpdate(aStatusID,aReviseCode,"",aUserID)
	Quit:(+flg)<1 return
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  修订卷状态
/// Input：       VolID : 卷ID
///               WorkItemID : 操作项目ID
///               UserID : 修订人
/// Return:		  返回String
/// w ##class(DHCWMR.SSService.ReviseSrv).ReviseInsert(98,3,9)
ClassMethod ReviseInsert(aVolID As %String, aWorkItemID As %String, aUserID As %String) As %String
{
	New (aVolID,aWorkItemID,aUserID)
	Set return="0^参数错误"
	Quit:(aVolID="")||(aWorkItemID="")||(aUserID="") return
	
	Set return="-1^病案卷无效"
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return  //卷无效
	Set objMain=objVol.SVMainDr
	Quit:'$IsObject(objMain) return
	Quit:objMain.SMIsActive'=1 return    //病案无效
	Quit:'$IsObject(objMain.SMMrType) return
	Set MrTypeID=objVol.SVMainDr.SMMrType.%Id()
	Set MainID=objMain.%Id()
	
	Set return="-2^工作流项目无效"
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(MrTypeID,aWorkItemID)
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()
	Set WFIType=objWFItem.WFIType
	Set WFISubFlow=objWFItem.WFISubFlow
	Set WFISysOpera=objWFItem.WFISysOpera
	Set WFIPostStep=objWFItem.WFIPostStep
	
	Set return="-3^当前状态不允许修订"
	Quit:WFIPostStep="" return
	
	Set BatchNumber=##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	
	TStart
	
	Set return="-4^保存病案操作失败"
	Set InputStr=""
	Set InputStr=InputStr_"^"_MrTypeID
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_aUserID
	Set InputStr=InputStr_"^"_""  //操作日期
	Set InputStr=InputStr_"^"_""  //操作时间
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BatchNumber
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 return
	Set OperationID=+flg
	
	Set return="-5^保存病案卷操作记录失败"
	Set InputStr=aVolID
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_aUserID
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BatchNumber
	Set InputStr=InputStr_"^"_"R"           //修正标记
	Set InputStr=InputStr_"^"_+$h           //修正日期
	Set InputStr=InputStr_"^"_$p($h,",",2)  //修正时间
	Set InputStr=InputStr_"^"_aUserID       //修正人
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 return
	
	Set return="-6^处理病案卷主表状态失败"
	Set InputStr=aVolID
	Set InputStr=InputStr_"^"_MainID
	Set InputStr=InputStr_"^"_WorkItemID
	Set InputStr=InputStr_"^"_WFIPostStep
	Set InputStr=InputStr_"^"_objVol.SVIsLend
	Set InputStr=InputStr_"^"_objVol.SVIsCopy
	Set InputStr=InputStr_"^"_objVol.SVIsStore
	Set InputStr=InputStr_"^"_objVol.SVQCLock
	Set InputStr=InputStr_"^"_objVol.SVDischDate
	Set InputStr=InputStr_"^"_objVol.SVBackDate
	Set InputStr=InputStr_"^"_objVol.SVIPTimes
	Set InputStr=InputStr_"^"_objVol.SVBuildDate
	Set InputStr=InputStr_"^"_objVol.SVBuildTime
	Set InputStr=InputStr_"^"_objVol.SVIsActive
	Set InputStr=InputStr_"^"_objVol.SVResume
	Set InputStr=InputStr_"^"_objVol.SVBarcode
	Set InputStr=InputStr_"^"_objVol.SVIsExPaper
	Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 return
	
	TCommit
	
	Set return="1^修订卷状态成功"
	Quit return
}

}
