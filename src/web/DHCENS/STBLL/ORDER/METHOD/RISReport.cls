Class web.DHCENS.STBLL.ORDER.METHOD.RISReport Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("S00000016","9045648||751")

/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.RISReport).Test()
ClassMethod Test()
{
	set i=0
	set rowId="0"  for  set rowId=$o(^PAPER(rowId))  q:((rowId="")||(rowId>20000))  d
	.set admType=""  for  set admType=$o(^PAPERdr(rowId,"ADM",admType)) q:admType=""  d
	..set admRowId=""  for  set admRowId=$o(^PAPERdr(rowId,"ADM",admType,admRowId)) q:admRowId=""  d
	...Quit:admRowId=2
	...set subId=""  for  set subId=$o(^OEORD(0,"Adm",admRowId,subId)) q:subId=""  d
	....set childId="0"  for  set childId=$o(^OEORD(subId,"I",childId)) q:childId=""  d	
	.....set reportId=$o(^DHCRBStudyi("Report-Oeorditm",subId_"||"_childId,""))
	.....Quit:reportId=""
	.....set tSc=##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("S00000016",subId_"||"_childId)
	.....set i=i+1
	QUit i
}

// w ##class(web.DHCENS.STBLL.ORDER.METHOD.RISReport).GetRISReport("9053096||1290")

ClassMethod GetRISReport(ordRowId As %String) As %GlobalCharacterStream
{
	set $ztrap="SendMessageET"
	/*
	set retStr=##class(web.DHCENS.Util.Common).GetPatNoByOrderID(ordRowId)
	set tSc=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPATINFO",$p(retStr,"^",1))
	set tSc=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMINFO",$p(retStr,"^",3))
	set tSc=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDDOCORDITEMINFO",ordRowId)
	Quit tSc
	*/
	
	
	set request=##class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	set admRowId=$p($g(^OEORD(+ordRowId)),"^",1)
	
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	// 取院区
	set HospCode="",hospId=""
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set:AdmDeptRowID'="" hospId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
	set:hospId="" hospId=$o(^CT("HOSP","0"))
	set:hospId'="" header.SourceSystem=$p($g(^CT("HOSP",hospId)),"^",1)
	set header.TargetSystem="医院信息平台"
	set request.header=header			
	b ;1
	set body=##class(web.DHCENS.STBLL.ORDER.MODEL.Body).%New()	
	//set Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""))
	set Rptrowid=$o(^DHCRBStudyi("Report-Oeorditm",ordRowId,""))
	set ReportStatusCode=""
	set RptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	set StudyNo=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",1)
	
    set:RptStatusDR'="" ReportStatusCode=$p(^DHCRBCStatus("ReportStatus",RptStatusDR),"^",1)
	q:(ReportStatusCode="N")||(ReportStatusCode="") ""
	set RISOOrderItemID=""
	set RegRowid="0"  for  set RegRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RegRowid)) q:(RegRowid="")  d
	.set rowId=$p(^DHCPACRegInfo(RegRowid),"^",11)
	.set:RISOOrderItemID'="" RISOOrderItemID=RISOOrderItemID_"^"_rowId
	.set:RISOOrderItemID="" RISOOrderItemID=rowId
	set:RISOOrderItemID="" RISOOrderItemID=ordRowId 
	s ExamDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",5)
	i ExamDesc="" d  s ExamDesc=$g(^DHCRBStudy("Report",Rptrowid,"ExamDescEx")) //EyeSee
	s SeeDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",23)
	i SeeDesc="" d  s SeeDesc=$g(^DHCRBStudy("Report",Rptrowid,"SeeDescEx")) //GlassSee
	;检查结果描述
    s ResultDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",6)
   	i ResultDesc="" d  s ResultDesc=$g(^DHCRBStudy("Report",Rptrowid,"ResultDescEx"))
	s RISRDiagDesc=$g(^DHCRBStudy("Report",Rptrowid,"ResultDescEx"))
    ;报告日期
    s RptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
    i RptDate'="" s RptDate=$zd(RptDate,3)
    ;报告时间
    s RptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
    i RptTime'="" s RptTime=$zt(RptTime,1)
    s:(RptDate'="")&&(RptTime'="") RptDate=RptDate_" "_RptTime
    ;报告医生
    s RptUserCode="demo",RptUserName="demo"
    s RptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	s:RptDocDR'="" RptUserCode=$p($g(^SSU("SSUSR",RptDocDR)),"^",1),RptUserName=$p($g(^SSU("SSUSR",RptDocDR)),"^",2)
	;审核日期
    s VerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
    i VerifyDate'="" s VerifyDate=$zd(VerifyDate,3) 
    ;审核时间
    s VerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
    i VerifyTime'="" s VerifyTime=$zt(VerifyTime,1)
    s:(VerifyDate'="")&&(VerifyTime'="") VerifyDate=VerifyDate_" "_VerifyTime
    ;审核医生
    s VerifyUserCode="demo",VerifyUserName="demo"
    s VerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
    s:VerifyDocDR'="" VerifyUserCode=$p($g(^SSU("SSUSR",VerifyDocDR)),"^",1),VerifyUserName=$p($g(^SSU("SSUSR",VerifyDocDR)),"^",2)
	;s LASTEDITEDTIME=$case(RegDate'="",1:RegDate,:$zd($h,3)_" "_$zt($p($h,",",2),1))
	s ExamDesc=$tr(ExamDesc,"^"," ")
	s report=##class(web.DHCENS.STBLL.ORDER.MODEL.RISReport).%New()
	s report.RISRReportID=Rptrowid
	s report.RISRExamID=StudyNo
	s report.RISRReportDocCode=	RptUserCode
	s report.RISRReportDate=$p(RptDate," ",1)
	s report.RISRReportTime=RptTime	
	s report.RISRCheckDocCode=	VerifyUserCode
	s report.RISRCheckDate=$p(VerifyDate," ",1)
	s report.RISRCheckTime=	VerifyTime
	s report.RISRFinalCheckDocCode=	VerifyUserCode
	s report.RISRFinalCheckDate	=$p(VerifyDate," ",1)
	s report.RISRFinalCheckTime=VerifyTime
	s report.RISRItemDesc=""
	s report.RISRMethod=""
	s ExamDesc=$tr(ExamDesc,$c(10),"")
	s ExamDesc=$tr(ExamDesc,$c(13),"")
	s:ExamDesc="" ExamDesc="无"
	s report.RISRExamDesc=ExamDesc
	s RISRDiagDesc=$tr(RISRDiagDesc,$c(10),"")
	s RISRDiagDesc=$tr(RISRDiagDesc,$c(13),"")
	s:RISRDiagDesc="" RISRDiagDesc="无"
	s report.RISRDiagDesc=RISRDiagDesc
	s report.RISRContentXml=ResultDesc
	s report.RISOOrderItemID=RISOOrderItemID
	d body.rISReports.Insert(report)
	set request.body=body	
	d request.XMLExportToStream(.xml)
	b ;00
	q xml
SendMessageET
	s Risobj=##class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	d Risobj.XMLExportToString(.xml)
	q xml
}

ClassMethod GetDiagnoseInfo(Input As %String) As %String
{
	s $ztrap="SendMessageET"
	s AdmRowID=Input
	s PAAdmNo=$p($g(^PAADM(AdmRowID)),"^",81)
	s MRADMRowID=$p($g(^PAADM(AdmRowID)),"^",61)
	s MRSubRowID="0",DIAGNOSISCODE="",DIAGNOSISNAME="",DIAGNOSISITIMES="",MSNO="",DEPTNO="",DIAGNOSISTYPECODE="",DIAGNOSISTYPENAME=""
	f  s MRSubRowID=$o(^MR(MRADMRowID,"DIA",MRSubRowID)) q:MRSubRowID=""  d
	.s MRRowID=MRADMRowID_"||"_MRSubRowID
	.s TYPSubRowID=$o(^MR(MRADMRowID,"DIA",MRSubRowID,"TYP",0))
	.s MRCDiagTyp=$p($g(^MR(MRADMRowID,"DIA",MRSubRowID,"TYP",TYPSubRowID)),"^",1)
	.;q:(MRCDiagTyp'="4")&(MRCDiagTyp'="2")
	.q:MRCDiagTyp=""
	.s ICDDR=$p($g(^MR(MRADMRowID,"DIA",MRSubRowID)),"^",1)
	.q:ICDDR=""
	.s ICDCode=$p($g(^MRC("ID",ICDDR)),"^",4)
	
	.i (DIAGNOSISCODE="") d
	..s DIAGNOSISCODE=ICDCode
	.e  d
	..s DIAGNOSISCODE=DIAGNOSISCODE_";"_ICDCode
	
	.s ICDDesc=$p($g(^MRC("ID",ICDDR)),"^",2)
	.i (DIAGNOSISNAME="") d
	..s DIAGNOSISNAME=ICDDesc
	.e  d
	..s DIAGNOSISNAME=DIAGNOSISNAME_";"_ICDDesc
	q DIAGNOSISNAME
SendMessageET
	q $ze
}

}
