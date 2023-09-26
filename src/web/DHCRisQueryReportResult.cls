/// 类 web.DHCRisQueryReportResult
/// 外部系统查询检查结果（衢州病案接口）
///  d ##class(%ResultSet).RunQuery("web.DHCRisQueryReportResult","QueryRISReportResult","57652")
Class web.DHCRisQueryReportResult Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Query QueryRISReportResult
/// 功能：查询报告内容
/// 参数 AdmId 就诊号 paadm rowid
/// 结果参数：//记录机器码,病人标识,病人标识类别(门诊号，住院号),检查科室名称，检查报告单编号(检查号)，检查所见，检查结果，检查日期，报告日期，备注，检查项目代码，检查项目名称，检查医生姓名，报告医生姓名，审核医生姓名，审核日期
/// 作者: gongping 
/// 日期：2010-12-15 
Query QueryRISReportResult(AdmId As %String) As %Query(ROWSPEC = "BCJLJQM:%String,BCBRBS:%String,BDBRBSLB:%String,BCJYKSMC:%String,BCBH:%String,BCKGSJ:%String,BCZGTS:%String,BCJYRQ:%String,BCBGRQ:%String,BCBZ:%String,BCJCXM:%String,BCJCXMMC:%String,BCJCYSXM:%String,BCBGYSXM:%String,BCSHYSXM:%String,BCSHRQ:%String")
{
}

ClassMethod QueryRISReportResultExecute(ByRef qHandle As %Binary, AdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	
    If $g(ind)="" Set ind=1
    if AdmId="" 
    {
	   Set qHandle=$lb(0,repid,0)
	   Quit $$$OK
    }
  
	s patmasId=$p($g(^PAADM(AdmId)),"^",1)
	s Type=$p($g(^PAADM(AdmId)),"^",2)
	i Type="I" d
	.s PNO="2"
	else  d
	.s PNO="1" ; $p($g(^PAPER(patmasId,"PER",4)),"^",4) 
    s PatientId=$p($g(^PAPER(patmasId,"PAT",1)),"^",1)
    
    s regrowid=0 f  s regrowid=$o(^DHCPACRegInfoi("PAADM",AdmId,regrowid)) q:regrowid=""  d
    .s ExamDoctor="",ExamLocDesc="",strReportDoc="",strReportDate=""
    .s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
    .q:StudyNo=""
    .s oeorditemId=$p(^DHCPACRegInfo(regrowid),"^",11)
    .s OrderRowid=$p(oeorditemId,"||",1)
    .s itemsub=$p(oeorditemId,"||",2)
    .s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    .q:'$d(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1))
    .s ItemName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    .s ItemCode=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",1)
    .s careProvId=$p(^DHCPACRegInfo(regrowid),"^",5)  ;检查医生
    .i careProvId'="" s ExamDoctor=$p(^CTPCP(careProvId,1),"^",2)
    .s ExamDate=$p(^DHCPACRegInfo(regrowid),"^",8) ; 检查日期（登记日期）
    .s strExamDate=$zd(ExamDate,8)
    .s ExamLocId=$p(^DHCPACRegInfo(regrowid),"^",13)
    .i ExamLocId'="" s ExamLocDesc=$p(^CTLOC(ExamLocId),"^",2)
    .s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
    .i ReportRowid'="" d  ; 病人已经有报告
    ..s ReportDocId=$p(^DHCRBStudy("Report",ReportRowid),"^",8)
    ..i ReportDocId'="" s strReportDoc=$p(^SSU("SSUSR",ReportDocId),"^",2)
    ..s ReportDate=$p(^DHCRBStudy("Report",ReportRowid),"^",9)
    ..s strReportDate="" i ReportDate'="" s strReportDate=$zd(ReportDate,8)
    ..s AuditDate=$p(^DHCRBStudy("Report",ReportRowid),"^",12)
    ..s strAuditDate="" i AuditDate'="" s strAuditDate=$zd(AuditDate,8)
    ..s AuditDocId=$p(^DHCRBStudy("Report",ReportRowid),"^",11)
    ..i AuditDocId'="" s AuditDocDoc=$p(^SSU("SSUSR",ReportDocId),"^",2)
    ..s ReportSee=$g(^DHCRBStudy("Report",ReportRowid,"ExamDescEx")) 
    ..s ReportResult=$g(^DHCRBStudy("Report",ReportRowid,"ResultDescEx"))
    ..s Memo=$g(^DHCRBStudy("Report",ReportRowid,"MemoEx"))
    ..Do OutRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow3
  	set Data=$lb(ReportRowid,PatientId,PNO,ExamLocDesc,StudyNo,ReportSee,ReportResult,strExamDate,strReportDate,Memo,ItemCode,ItemName,ExamDoctor,strReportDoc,AuditDocDoc,strAuditDate)
 	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	quit
}

ClassMethod QueryRISReportResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRISReportResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryRISReportResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRISReportResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
