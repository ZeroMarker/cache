/// 名称: web.DHCCPW.IO.Service
/// 描述: 临床路径对外接口服务
/// 编写者：zhufei
/// 编写日期: 2015-11-11
Class web.DHCCPW.IO.Service Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-11-11
/// Description:  取临床路径状态接口
/// Input：       EpisodeID : 就诊号
/// Return:		  返回String
/// w ##class(web.DHCCPW.IO.Service).GetCPWStatus(50)
ClassMethod GetCPWStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aEpisodeID)
	Quit:MRAdm="" return
	
	Set CPWStatus=""
	Set xPathWayID=0
	For {
		Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
		Quit:xPathWayID=""
		
		Set obj=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(xPathWayID)
		Continue:'$IsObject(obj)
		Set CPWStatus=obj.CPWStatus
		Quit:CPWStatus="I"
	}
	Set return=$s(CPWStatus="I":"入径",CPWStatus="O":"出径",CPWStatus="C":"完成",1:"")
	Quit return
}

/// Creator：     mxp
/// CreatDate：   2017-10-25
/// Description:  取临床路径信息接口(To医生站)
/// Input：       EpisodeID : 就诊号
/// Return:		  返回String: 路径名称_$c(1)_入径天数_$c(1)_当前阶段_$c(1)_状态
/// w ##class(web.DHCCPW.IO.Service).GetCPWInfoByPaadm(50)
ClassMethod GetCPWInfoByPaadm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aEpisodeID)
	Quit:MRAdm="" return
	
	Set (PathWayDesc,CPWStatus,InPathDays)=""
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	Quit:PathWayID="" return
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Quit:'$IsObject(objPathWay) return
	If $IsObject(objPathWay.CPWPathwayDR)
	{
		Set PathWayDesc=objPathWay.CPWPathwayDR.CPWDesc
	}
	Set CPWStatus=objPathWay.CPWStatus
	Set InPathDate=objPathWay.CPWInDate
	Set OutPathDate=objPathWay.CPWOutDate
	Set:CPWStatus="I" InPathDays=+$h-InPathDate
	Set:CPWStatus="C" InPathDays=OutPathDate-InPathDate
	
	Set CurrEpStepDR="",CurrStepDesc="",OverEpStepDR=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(PathWayID)
	If EstTimeLS'="" {
		Set EstTimesCnt=$listlength(EstTimeLS)
		For EstTimesInd=1:1:EstTimesCnt {
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Set:$list(objEstTime,2)=1 CurrEpStepDR=EstEpStepDR
			Set:$list(objEstTime,9)=1 OverEpStepDR=EstEpStepDR
		}
	}
	Set:CurrEpStepDR="" CurrEpStepDR=OverEpStepDR
	Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(CurrEpStepDR)
	If $IsObject(objStep)
	{
		Set CurrStepDesc=objStep.CPWSDesc
	}
	
	Set:CPWStatus="O" InPathDays="",CurrStepDesc=""	
	Set CPWStatus=$s(CPWStatus="I":"入径",CPWStatus="O":"出径",CPWStatus="C":"完成",1:"")
	
	Set return=PathWayDesc_$c(1)_InPathDays_$c(1)_CurrStepDesc_$c(1)_CPWStatus
	
	Quit return
}

}
