/// CTOR: QP
/// DATE: 2020-09-29
/// DESC: 临床药理添加入科研项目扩展类
Class web.PilotProject.Extend.PatAdd Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-29
/// DESC: 获取项目的阶段ID
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.PatAdd).GetStageBySeqno(19,1)
ClassMethod GetStageBySeqno(PPRowId, Num)
{
	s mRtn=""
	Q:(PPRowId="")||(Num="") mRtn
	;Q:'$d(^CF.DOC.Pilot.ProjectStageI("ProjectSeqno",PPRowId,Num)) mRtn
	;s mRtn=$o(^CF.DOC.Pilot.ProjectStageI("ProjectSeqno",PPRowId,Num,""))
	Q:'$d(^CF.DOC.Pilot.OEStageI("PrjCode",PPRowId,Num)) mRtn
	s mRtn=$o(^CF.DOC.Pilot.OEStageI("PrjCode",PPRowId,Num,""))
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-09
/// DESC: 获取患者当前阶段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.PatAdd).GetStageByAdm(11,"207","140")
ClassMethod GetStageByAdm(PPRowID, AdmID = "", PatientID = "")
{
	s ^QP("GetStageByAdm")=$LB(PPRowID, AdmID,PatientID)
	s mRtn=""
	Q:(AdmID="")&&(PatientID="") mRtn
	i PatientID="" {
		s PatientID=$P(^PAADM(AdmID),"^",1)	
	}
	Q:PatientID="" mRtn
	s SUB=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowID,""))
	Q:SUB="" mRtn
	s mRtn=$p(^DHCDocPPP(PPRowID,SUB),"^",18)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-09
/// DESC: 获取项目的限制人数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.PatAdd).GetPrjMaxNum(11)
ClassMethod GetPrjMaxNum(PPRowId)
{
	s mRtn=""
	Q:PPRowId="" mRtn
	s mRtn=$p(^DHCDocPP(PPRowId),"^",118)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-09
/// DESC: 获取项目的现有人数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.PatAdd).GetPrjNum(11)
ClassMethod GetPrjNum(PPRowId)
{
	s mRtn=0
	s sub=0
	f  s sub=$o(^DHCDocPPP(PPRowId,sub)) q:sub=""  d
	.s status=$p(^DHCDocPPP(PPRowId,sub),"^",2)
	.q:status'="N"
	.s mRtn=mRtn+1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-09
/// DESC: 检查是否超过最大人数
/// IN  : 
/// OUT : 1 超过
/// EXEC: w ##class(web.PilotProject.Extend.PatAdd).CheckMaxNum(11)
ClassMethod CheckMaxNum(PPRowId)
{
	Q:PPRowId="" 0
	s maxNum=..GetPrjMaxNum(PPRowId)
	Q:maxNum="" 0
	s readyNum=..GetPrjNum(PPRowId)
	Q:readyNum>=maxNum 1
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-08-19
/// DESC: 修改病人信息
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.PatAdd).UpdatePat(11)
ClassMethod UpdatePat(PPPID, InPara)
{
	Q:PPPID="" "-1^参数为空"
	s ScreenNo=$p(InPara,$c(1),1)
	s AgreementDate=$p(InPara,$c(1),2)
	s Remark=$p(InPara,$c(1),3)
	Q:AgreementDate="" "-1^知情同意书日期为空！"
	s AgreementDate=##class(websys.Conversions).DateHtmlToLogical(AgreementDate)
	
	&SQL(
		UPDATE SQLUser.DHC_DocPilotProPat 
		SET PPP_ReMark=:Remark,PPP_AgreementDate=:AgreementDate,PPP_ScreenNo=:ScreenNo
		WHERE PPP_RowId=:PPPID
	)
	
	i SQLCODE'=0 {
		Q "-1^保存失败！"_SQLCODE
	} else {
		Q "0^"
	}
}

}
