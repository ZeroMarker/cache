/// 名称: DHCCPW.MR.FORM.EstimateSrv
/// 描述: 表单步骤时间调整相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-30
Class DHCCPW.MR.FORM.EstimateSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		zhufei
/// CreatDate:		2015-06-30
/// Description:	取步骤对应开始时间+结束时间
/// Table:        	User.DHCMRClinicalPathWayEstimate
/// Input:        	PathWayID ：出入径ID
///                 StepID ：步骤ID
/// Return:       	$lb(EstEpStepDR,xIsCurrStep,xStartDate,xStartTime,xEndDate,xEndTime,xEstTime,EstCompStepList,xIsOverStep)
/// w ##class(DHCCPW.MR.FORM.EstimateSrv).GetEstimateByStep(21,"79||1||1")
ClassMethod GetEstimateByStep(aPathWayID As %String, aStepID As %String) As %String
{
	New (aPathWayID,aStepID)
	Set return=""
	Quit:(aPathWayID="")||(aStepID="") return
	
	Set EstTimeList=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
	Quit:EstTimeList="" return
	Set EstTimesCnt=$listlength(EstTimeList)
	For EstTimesInd=1:1:EstTimesCnt {
		Set stepEstTime=$list(EstTimeList,EstTimesInd)
		Set StepID=$list(stepEstTime,1)
		Continue:aStepID'=StepID
		Set return=stepEstTime
	}
	
	Quit return
}

}
