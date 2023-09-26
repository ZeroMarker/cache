/// 名称: DHCMA.CPW.IO.ToEmrNur
/// 描述: 提供病历/护理引用临床路径后台接口
/// 编写者：yankai
/// 编写日期: 2022-08-23
Class DHCMA.CPW.IO.ToEmrNur Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2022-08-23
/// Description:  判断患者是否存在入径记录及入径状态、当前阶段
/// Input：       aEpisodeID : 就诊ID
/// Return:		  返回String: 路径名称_"^"_入径天数_"^"_当前阶段_"^"_状态
/// w ##class(DHCMA.CPW.IO.ToEmrNur).GetPathInfoByAdm("1708!!1")
ClassMethod GetPathInfoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set LangID=20
	Set:$d(%session) LangID=+$g(%session.Data("LOGON.LANGID"))
	
	Set $ZT="GetPathInfoByAdmError"
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)
	Quit:xPathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
	Quit:'$IsObject(objPathway) return
	Set CPWStatus=objPathway.CPStatus
	Quit:(CPWStatus'="I")&&(CPWStatus'="O")&&(CPWStatus'="C") return 				//只返回入径/出径/完成状态
	Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请","T":"不入径",:"")
	
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
	Set CurrEpisID=objPathway.CPEpisDr.%Id()
	Set CurrEpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc
	
	Set CPWDays=0
	Set CPActDate=objPathway.CPActDate
	Set CPInDate=objPathway.CPInDate
	Set CPOutDate=objPathway.CPOutDate
	Set:CPWStatus="入径" CPWDays=+$H-CPInDate+1
	Set:CPWStatus="完成" CPWDays=CPActDate-CPInDate+1
	Set:CPWStatus="出径" CPWDays=CPOutDate-CPInDate+1
	
	Set:CPWDesc'="" CPWDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",CPWDesc,LangID)
	Set:CurrEpisDesc'="" CurrEpisDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",CurrEpisDesc,LangID)
	Set:CPWStatus'="" CPWStatus=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",CPWStatus,LangID)
	
	Set return = xPathwayID_"^"_CPWDesc_"^"_CurrEpisID_"^"_CurrEpisDesc_"^"_CPWDays_"^"_CPWStatus
	Quit return
	
GetPathInfoByAdmError
	Quit ""
}

/// Creator：     yankai
/// CreatDate：   2022-08-24
/// Description:  判断是否需显示临床路径页签
/// Input：       aEpisodeID : 就诊ID
/// Return:		  1:显示；0：不显示
/// w ##class(DHCMA.CPW.IO.ToEmrNur).IsShowCPWTab("40!!1")
ClassMethod IsShowCPWTab(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return

	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)
	Quit:xPathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set CPWStatus=objPathway.CPStatus
	Quit:(CPWStatus'="I")&&(CPWStatus'="O")&&(CPWStatus'="C") return 				//只返回入径/出径/完成状态
	
	Quit 1
}

}
