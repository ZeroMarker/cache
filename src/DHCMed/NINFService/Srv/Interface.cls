/// 名称: DHCMed.NINFService.Srv.Interface
/// 描述: 公用方法
/// 编写者：zhufei
/// 编写日期: 2013-03-28
Class DHCMed.NINFService.Srv.Interface Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// C/S病人列表调用，显示感染信息
/// w ##Class(DHCMed.NINFService.Srv.Interface).GetInfNoteToCS(20155432)
ClassMethod GetInfNoteToCS(aEpisodeID As %String, aConfigCode As %String) As %String
{
	new (aEpisodeID,aConfigCode)
	set return=""
	quit:(aEpisodeID="")||(aConfigCode="") return
	
	set $ZT="GetInfNoteToCSErr"
	
	set xRepID=0,flag=0
	for {
		set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xRepID))
		quit:xRepID=""
		quit:flag>0
		
		set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		continue:'$IsObject(objReport)
		continue:'$IsObject(objReport.ReportType)
		set ReportTypeCode=objReport.ReportType.Code
		continue:ReportTypeCode'="COMP"
		continue:'$IsObject(objReport.ReportStatus)
		set ReportStatusDesc=objReport.ReportStatus.Description
		continue:ReportStatusDesc["删除"
		continue:ReportStatusDesc'["退回"
		Set flag=1
	}
	set:flag=1 return=return_"存在退回报告;"
	
	set FeedBackNote=""
	set SubjectID=##class(DHCMed.CCService.Sys.SubjectConfig).GetSubjectIDByConfigCode(aConfigCode)
	if SubjectID'="" {
		set xSubjectID=0
		for {
			set xSubjectID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",aEpisodeID,xSubjectID))
			quit:xSubjectID=""
			
			set xFeedbackID=0
			for {
				set xFeedbackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",aEpisodeID,xSubjectID,xFeedbackID))
				quit:xFeedbackID=""
				
				set objFeedback=##class(DHCMed.CC.CtlFeedback).GetObjById(xFeedbackID)
				continue:'$IsObject(objFeedback)
				set Status=objFeedback.Status
				continue:Status'=0
				set FeedBackNote=FeedBackNote_objFeedback.FeedBackNote_";"
			}
		}
	}
	//set:FeedBackNote'="" return=return_"存在未响应消息("_FeedBackNote_")"
	set:FeedBackNote'="" return=return_"存在未响应消息;"
	
	quit return
	
GetInfNoteToCSErr
	Set Error=$ZError
	Quit Error
}

/// B/S感染消息提醒取值
/// w ##Class(DHCMed.NINFService.Srv.Interface).GetInfNote(20155432)
ClassMethod GetInfNote(aEpisodeID As %String, aConfigCode As %String) As %String
{
	new (aEpisodeID,aConfigCode)
	set return=""
	quit:(aEpisodeID="")||(aConfigCode="") return
	
	set $ZT="GetInfNoteErr"
	
	set xRepID=0,flag=0
	for {
		set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xRepID))
		quit:xRepID=""
		quit:flag>0
		
		set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		continue:'$IsObject(objReport)
		continue:'$IsObject(objReport.ReportType)
		set ReportTypeCode=objReport.ReportType.Code
		continue:ReportTypeCode'="COMP"
		continue:'$IsObject(objReport.ReportStatus)
		set ReportStatusDesc=objReport.ReportStatus.Description
		continue:ReportStatusDesc["删除"
		continue:ReportStatusDesc'["退回"
		Set flag=1
	}
	set:flag=1 return=return_"存在退回报告;"
	
	set FeedBackNote=""
	set SubjectID=##class(DHCMed.CCService.Sys.SubjectConfig).GetSubjectIDByConfigCode(aConfigCode)
	if SubjectID'="" {
		set xSubjectID=0
		for {
			set xSubjectID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",aEpisodeID,xSubjectID))
			quit:xSubjectID=""
			
			set xFeedbackID=0
			for {
				set xFeedbackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",aEpisodeID,xSubjectID,xFeedbackID))
				quit:xFeedbackID=""
				
				set objFeedback=##class(DHCMed.CC.CtlFeedback).GetObjById(xFeedbackID)
				continue:'$IsObject(objFeedback)
				set Status=objFeedback.Status
				continue:Status'=0
				set FeedBackNote=FeedBackNote_objFeedback.FeedBackNote_";"
			}
		}
	}
	//set:FeedBackNote'="" return=return_"存在未响应消息("_FeedBackNote_")"
	set:FeedBackNote'="" return=return_"存在未响应消息;"
	
	quit return
	
GetInfNoteErr
	Set Error=$ZError
	Quit Error
}

/// B/S感染信息提示取值
/// w ##Class(DHCMed.NINFService.Srv.Interface).GetInfMsg(189,"INTCCS")
ClassMethod GetInfMsg(aEpisodeID As %String, aConfigCode As %String) As %String
{
	new (aEpisodeID,aConfigCode)
	set return=""
	quit:(aEpisodeID="")||(aConfigCode="") return
	
	set $ZT="GetInfMsgErr"
	
	set xRepID=0
	for {
		set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xRepID))
		quit:xRepID=""
		
		set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		continue:'$IsObject(objReport)
		continue:'$IsObject(objReport.ReportType)
		set ReportTypeCode=objReport.ReportType.Code
		continue:ReportTypeCode'="COMP"
		continue:'$IsObject(objReport.ReportStatus)
		set ReportStatusDesc=objReport.ReportStatus.Description
		continue:ReportStatusDesc["删除"
		
		set xSubID=0
		for {
			set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"InfPos",xSubID))
			quit:xSubID=""
			
			set objSub=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(xRepID_"||"_xSubID)
			continue:'$IsObject(objSub)
			
			set (InfPosDesc,InfDate,InfDiagDesc)=""
			
			if $IsObject(objSub.InfPos) {
				set InfPosID=objSub.InfPos.%Id()
				set InfPosDesc=objSub.InfPos.IPDesc
			}
			set InfDate=objSub.InfDate
			set:InfDate'="" InfDate=$zd(InfDate,3)
			if $IsObject(objSub.InfDiag) {
				set InfDiagID=objSub.InfDiag.%Id()
				set InfDiagDesc=objSub.InfDiag.IDDesc
			}
			set return=return_InfDate_" "_InfPosDesc_" "_InfDiagDesc_";"
		}
	}
	
	quit return
	
GetInfMsgErr
	Set Error=$ZError
	Quit Error
}

/// B/S住院病人列表图标调用，消息提醒或信息提示
/// w ##Class(DHCMed.NINFService.Srv.Interface).GetInfIcon(189,"INTCCS",0)
ClassMethod GetInfIcon(aEpisodeID As %String, aConfigCode As %String, aFlag As %String) As %String
{
	new (aEpisodeID,aConfigCode,aFlag)
	set return=""
	quit:(aEpisodeID="")||(aConfigCode="")||(aFlag="") return
	
	set $ZT="GetInfIconErr"
	
	set CurrDate=+$h
	set PreoDate=+$o(^TMP("DHCMed.NINF",""),-1)
	if (PreoDate<CurrDate) {
		Kill ^TMP("DHCMed.NINF")
	}
	set CurrTime=$p($h,",",2)
	set PreoTime=+$g(^TMP("DHCMed.NINF",CurrDate,aEpisodeID,"Time"))
	if (CurrTime-PreoTime)>3 {
		set note=..GetInfNote(aEpisodeID,aConfigCode)
		set ^TMP("DHCMed.NINF",CurrDate,aEpisodeID,"Time")=CurrTime
		set ^TMP("DHCMed.NINF",CurrDate,aEpisodeID,"Note")=note
	} else {
		set note=$g(^TMP("DHCMed.NINF",CurrDate,aEpisodeID,"Note"))
	}
	
	if (aFlag=0)&&(note'="") {
		set return=note
	} elseif (aFlag'=0)&&(note="") {
		set return=..GetInfMsg(aEpisodeID,aConfigCode)
	}
	
	quit return
	
GetInfIconErr
	Set Error=$ZError
	Quit Error
}

/// B/S住院病人列表图标调用，多重耐药信息提醒
/// w ##Class(DHCMed.NINFService.Srv.Interface).GetMRBIcon(15263)
ClassMethod GetMRBIcon(aEpisodeID As %String, aConfigCode As %String = "") As %String
{
	New (aEpisodeID,aConfigCode)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set $ZT="GetMRBIconErr"
	Set AdmLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set LogonHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	Set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(LogonHospID,"NINF")
	
	If SSHospCode="11-XH" {
		Set RepTypeCode="MDR",RepTypeID=""
		Set objRepType=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportType",RepTypeCode,"")
		Set:$IsObject(objRepType) RepTypeID=objRepType.%Id()
		Quit:RepTypeID="" return
		
		Set xTransID=""
		For {
			Set xTransID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,aEpisodeID,xTransID))
			Quit:xTransID=""
		
			Set xRepID=0
			For {
				Set xRepID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,aEpisodeID,xTransID,xRepID))
				Quit:xRepID=""
				
				Set xSubID=0
				For {
					Set xSubID=$o(^DHCMed.NINF("AimRep",xRepID,"MDR",xSubID))
					Quit:xSubID=""
				
					Set ReportID=xRepID_"||"_xSubID
					Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(ReportID)
					Continue:'$IsObject(objRepSub)
					
					Set objRepStatus=objRepSub.RepStatus
					If $IsObject(objRepStatus) {
						Set RepStatusCode=objRepStatus.Code
						Continue:RepStatusCode="0"  //删除的报告不显示
					}
					
					Set (PathDate,SampleTypeID,SampleTypeDesc,PathogenyID,PathogenyDesc)=""
					Set PathDate=objRepSub.PathDate
					Set:PathDate'="" PathDate=$zd(+PathDate,3)
					Set objSampleType=objRepSub.SampleType
					If $IsObject(objSampleType) {
						Set SampleTypeID=objSampleType.%Id()
						Set SampleTypeDesc=objSampleType.Description
					}
					Set objPathogeny=objRepSub.Pathogeny
					If $IsObject(objPathogeny) {
						Set PathogenyID=objPathogeny.%Id()
						Set PathogenyDesc=objPathogeny.Description
					}
					
					Set return=return_"【"_SampleTypeDesc_"】"_PathDate_" "_PathogenyDesc_"；"
				}
			}
		}
	} Else {
		//新版本下的接口，暂时未写
	}
	
	Quit return
	
GetMRBIconErr
	Set Error=$ZError
	Quit Error
}

///  生成转科记录的任务
///  K ^DHCMed.CC.CtlResultD("AdmTrans")
///  K ^DHCMed.CC.CtlResultI("AdmTrans")
///  w ##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).InitAdmTransData("E","2013-03-01")
///  w ##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).SyncAdmTransData("E")
///  w ##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).InitAdmTransData("W","2013-03-01")
///  w ##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).SyncAdmTransData("W")
///  生成ICU调查日志任务
///  K ^DHCMed.NINF("Aim","ICUS")
///  K ^DHCMed.NINFi("Aim","ICUS")
///  w ##Class(DHCMed.NINFService.Rep.AimICUSurvery).LogDataProcess($zdh("2013-03-01",3),$zdh("2013-04-30",3),"",1)

}
