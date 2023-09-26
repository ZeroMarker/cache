/// 名称:DHCMed.NINFService.BC.HistoryData
/// 描述: 疑似病例筛查  历史数据处理
/// 编写者：zhufei
/// 编写日期: 2014-03-04
Class DHCMed.NINFService.BC.HistoryData Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 从DHCMed.CC.Summary、DHCMed.CC.CtlFeedback到DHCMed.NINF.BC.CasesX、DHCMed.NINF.BC.Cases
/// Do ##Class(DHCMed.NINFService.BC.HistoryData).ProcSummaryData("INTCCS")
ClassMethod ProcSummaryData(aConfigCode As %String)
{
	New (aConfigCode)
	Set return=""
	Quit:aConfigCode="" return
	
	//^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm","INTCCS",63004,158557,545)
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aConfigCode)
	Quit:'$IsObject(objConfig) return
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	Set xActDate=0
	For {
		Set xActDate=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm","INTCCS",xActDate))
		Quit:xActDate=""
		Set xEpisodeID=0
		For {
			Set xEpisodeID=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm","INTCCS",xActDate,xEpisodeID))
			Quit:xEpisodeID=""
			Set xCasesXID=0
			For {
				Set xCasesXID=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm","INTCCS",xActDate,xEpisodeID,xCasesXID))
				Quit:xCasesXID=""
				
				Set objCasesX=##class(DHCMed.NINF.BC.CasesX).GetObjById(xCasesXID)
				Continue:'$IsObject(objCasesX)
				//^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubjectActDate",42589,5,62845,1145)
				Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubjectActDate",xEpisodeID,SubjectID,xActDate,0))
				Continue:SummaryID=""
				Set objSummary=##Class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
				Continue:'$IsObject(objSummary)
				Set SummaryID=objSummary.%Id()
				Continue:objSummary.ProcessUser<1
				Set ProcessDate=objSummary.ProcessDate
				Set ProcessTime=objSummary.ProcessTime
				Set ProcessUser=objSummary.ProcessUser
				Set ProcessLoc=$p($g(^SSU("SSUSR",+ProcessUser)),"^",4)
				
				Set Status=objSummary.Status
				If Status=1 {
					Set Operation="2"
					Set Opinion=""
					Set FeedBackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexSummary",SummaryID,0))
					Set objFeedBack=##Class(DHCMed.CC.CtlFeedback).GetObjById(FeedBackID)
					If $IsObject(objFeedBack) {
						Set Opinion=objFeedBack.FeedBackNote
						
						Set flg=##class(DHCMed.NINFService.BC.CasesSrv).ProcCasesHandle("HA",aConfigCode,xEpisodeID,xCasesXID,Operation,Opinion,ProcessLoc,ProcessUser,0,ProcessDate,ProcessTime)
						Write:flg<1 "HA:"_flg,!
						Continue:flg<0
						
						Set ReceiveStatus=objFeedBack.Status
						Set ReceiveDate=objFeedBack.ReceiveDate
						Set ReceiveTime=objFeedBack.ReceiveTime
						Set ReceiveUser=objFeedBack.ReceiveUser
						Set ReceiveLoc=$p($g(^SSU("SSUSR",+ReceiveUser)),"^",4)
						Set ReceiveNote=objFeedBack.ReceiveNote
						
						If ReceiveStatus=1 {
							Set ReceiveStatus="3"
						} Else {
							Set ReceiveStatus="1"
						}
						Continue:ReceiveDate=""
						
						Set flg=##class(DHCMed.NINFService.BC.CasesSrv).ProcCasesHandle("HB",aConfigCode,xEpisodeID,"",Operation,ReceiveNote,ReceiveLoc,ReceiveUser,0,ReceiveDate,ReceiveTime)
						Write:flg<1 "HB:"_flg,!
					}
				}
				If Status=9 {
					Set Operation="1"
					Set Opinion=""
					
					Set flg=##class(DHCMed.NINFService.BC.CasesSrv).ProcCasesHandle("HA",aConfigCode,xEpisodeID,xCasesXID,Operation,Opinion,ProcessLoc,ProcessUser,0,ProcessDate,ProcessTime)
					Write:flg<1 "HA:"_flg,!
				}
			}
		}
	}
	
	Quit return
}

}
