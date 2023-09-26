/// 名称: DHCMA.CPW.OPCPS.PathwayVisitSrv
/// 描述: 门诊临床路径入径急诊记录服务类
/// 编写者：yankai
/// 编写日期: 2019-06-30
Class DHCMA.CPW.OPCPS.PathwayVisitSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2019-06-28
/// Description:  获取某次就诊最新入径状态
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       aEpisodeID,aFormID
/// Return：      Status或空
/// w ##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).GetPathStatus()
ClassMethod GetPathStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	
	Set xEpisID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,""),-1)
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisID(aEpisodeID,xEpisID,"")
	Quit:'$IsObject(objVisit) return
	Set return=objVisit.CPStatus
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-07-22
/// Description:  检查当前就诊入径情况
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       aEpisodeID,aPathwayID,aPathMastID
/// Return：      1或0
/// w ##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).CheckIsInPath("202")
ClassMethod CheckIsInPath(aEpisodeID As %String, aPathwayID As %String = "", aPathMastID As %String = "") As %String
{
	New (aEpisodeID,aPathwayID,aPathMastID)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	
	Set flg=0,xEpisID=""
	For {
		Set xEpisID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,xEpisID),-1)
		Quit:flg=1
		Quit:xEpisID=""
		
		Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisID(aEpisodeID,xEpisID,"I")
		Continue:'$IsObject(objVisit)
		Continue:objVisit.CPPathwayDr.CPStatus'="I"
		Set:(aPathwayID="")&&(aPathMastID="") flg=1								//只有就诊号检查
		Set xPathwayID=objVisit.CPPathwayDr.%Id()
		Set:(aPathwayID'="")&&(xPathwayID=aPathwayID) flg=1						//指定出入径记录检查
		Set xMastID=objVisit.CPPathwayDr.CPFormDr.FormPathDr.%Id()
		Set:(aPathMastID'="")&&(xMastID=aPathMastID) flg=1						//指定路径字典检查			
	}
	
	Set return=flg
	Quit return
}

/// Creator：     dengshaopeng
/// CreatDate：   2019-10-23
/// Description:  检查当前就诊挂号是否有效
/// Input：       aEpisodeID
/// Return：      1或0
/// w ##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).CheckIsNowDayVisit("202")
ClassMethod CheckIsNowDayVisit(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=-1
	Quit:(aEpisodeID="") return
	/*
	Set:aEpisodeID["!!" aEpisodeID=$p(aEpisodeID,"!!",1)
	Set VisitDate = $p($g(^PAADM(aEpisodeID)),"^",6)
	Set NowDate =+$H
	Set:NowDate=VisitDate return=1
	*/
	Set return=##class(DHCMA.CPW.IO.FromDoc).GetOPVisitIsVaild(aEpisodeID)

	Quit +return
}

/// Creator：     dengshaopeng
/// CreatDate：   2019-10-23
/// Description:  获取当前就诊科室内的所有门诊路径信息
/// Table：       DHCMA.CPW.CP.PathwayVisit、
/// Input：       aEpisodeID
/// Return：      
/// w ##Class(DHCMA.CPW.OPCPS.PathwayVisitSrv).GetLocPathInfo("107297!!1","44!!1")
ClassMethod GetLocPathInfo(aEpisodeID As %String, aLocID As %String) As %String
{
	New (aEpisodeID,aLocID,%session)
	Set return=""
	Quit:(aEpisodeID="")||(aLocID="") return
	
	Set LangID=20
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
	}
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	Set:aLocID'["!!" aLocID=aLocID_"!!"_SYSDr
	
	Set rs=##Class(%ResultSet).%New("DHCMA.CPW.BTS.PathLocSrv:QryPathByLoc")
  	Set sc=rs.Execute(aLocID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	
    While (rs.Next()){
		Set MastID = rs.Data("MastID")    	// 路径主表ID
		Set PathDesc = rs.Data("BTDesc")
		Set:PathDesc'="" PathDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",PathDesc,LangID)
		Set IsActive = rs.Data("BTIsActive") 
		Set AdmType  = rs.Data("BTAdmType")
		Continue:AdmType'="O"
		
		Set FormStr=##Class(DHCMA.CPW.BTS.PathFormSrv).GetHistoryFormInfo(aEpisodeID,MastID)
		Set:FormStr="" FormStr= ##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(MastID,1)
		Set FormID = $p(FormStr,"^",1)
		Continue:FormID=""																		//无可用版本不显示
		Set Version = $p(FormStr,"^",2)
		Set Visit = $p(FormStr,"^",3)
		Continue:(Visit="")&&(IsActive="否")					//对于无效路径，如该病人有未完成历史入径则显示
		Set return=return_","_FormID_"^"_PathDesc_"("_Version_")"_"^"_Visit
    }
    
    Set:return'="" return=$e(return,2,$l(return))
    Quit return
}

}
