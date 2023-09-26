Import SQLUser

/// 主要功能：将体检结果输出为web形式
/// 
Class web.DHCPE.ReportOutToWeb Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 173;

/// Descript: 获取报告数据源
/// Creator:
/// CreateDate:
/// Input:    ID   Type 
/// Output:
/// Debug:w ##class(web.DHCPE.ReportOutToWeb).GetReportInforNew()
ClassMethod GetReportInforNew(ID As %String, Type As %String)
{
	s reportData=##class(web.DHCPE.Utils.Object).%New()
	s $ZT="GetReportInforNewErr"
	q:((ID="")||(Type="")) reportData
	s PAADM=""
	if (Type="PAADM") {
		s PAADM=ID
	} elseif (Type="IADM") {
		s PAADM=$p($g(^DHCPEIADM(ID)),"^",1)
	} elseif (Type="REPORT") {
		s IADM=$o(^DHCPERPT(0,"IADM",ID,0))
		s:IADM'="" PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	} elseif (Type="TEMP") {
		q ##class(HS.BL.DHCPETool.IReport).GetTempPEData()
	}
	q:PAADM="" reportData
	
	s reportData=##class(HS.BL.DHCPETool.IReport).%New().GetPEDataNew(PAADM,1,"Obj")
	q reportData
GetReportInforNewErr
	s $ZT=""
	q reportData
}

/// d ##Class(web.DHCPE.ReportOutToWeb).GetReportInfor()
ClassMethod GetReportInfor(PAAdmRowid As %String, UserID As %String)
{
	s Flag=##Class(web.DHCPE.ReportGetInfor).GetPatient(PAAdmRowid,UserID)
	Q:("1"'=Flag) ""
	d ##Class(web.DHCPE.ReportGetInfor).GetGeneralAdvice(PAAdmRowid,UserID)
	d ##Class(web.DHCPE.ReportGetInfor).GetSummarize(PAAdmRowid,UserID)
	d ##Class(web.DHCPE.ReportGetInfor).GetReportResult(PAAdmRowid,UserID)
	d ##Class(web.DHCPE.ReportGetInfor).GetRefuseItem(PAAdmRowid)
	d ##class(web.DHCPE.ReportGetInfor).GetRptSettingData(PAAdmRowid,UserID)
	d ##Class(web.DHCPE.ReportGetInfor).GetIllExplain(PAAdmRowid,UserID)
	// 职业病报告数据
	d ##Class(web.DHCPE.ReportGetInfor).GetZYJKTJReportInfor(PAAdmRowid,UserID)
	d ##Class(web.DHCPE.ReportGetInfor).GetZYJKTJSummarizeInfor(PAAdmRowid,UserID)
	Q 1
}

ClassMethod GetContrastInfor(PAAdmRowid As %String, UserID As %String)
{
	s Flag=##Class(web.DHCPE.ReportGetInfor).GetPatient(PAAdmRowid,UserID)
	Q:("1"'=Flag) ""
    Q 1
}

// ##class(web.DHCPE.ReportOutToWeb).ChangeRange(Str)

ClassMethod ChangeRange(Str)
{
	//卵泡期:4.4-7.1 排卵期:8.8-49.7 黄体期:2.6-5.7 绝经期:16.9-42.9
	s Str=##class(web.DHCPE.ReportGetInfor).Replace(Str," 排卵期:","<br>排卵期:")
	s Str=##class(web.DHCPE.ReportGetInfor).Replace(Str," 黄体期:","<br>黄体期:")
	s Str=##class(web.DHCPE.ReportGetInfor).Replace(Str," 绝经期:","<br>绝经期:")
	s Str=##class(web.DHCPE.ReportGetInfor).Replace(Str," 孕期:","<br>孕期:")
	q Str
}

/// d ##Class(web.DHCPE.ReportOutToWeb).OutAdviceToWeb()
ClassMethod OutAdviceToWeb()
{
	//s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode",%session.Get("LOGON.CTLOCID")))
	s ReportCode=$G(^DHCPESetting("DHCPE","ReportCode",%session.Get("LOGON.CTLOCID")))
	i ReportCode'="" s HospitalCode=ReportCode
	s HospitalCode=$zcvt(HospitalCode,"L")
	d $zobjclassmethod("csp.csp.dhcpeireport."_HospitalCode_".normal.generaladvice","OnPageCSPROOT")
}

/// d ##Class(web.DHCPE.ReportOutToWeb).OutReportToWeb()
ClassMethod OutReportToWeb(OnlyAdvice As %String = "")
{
    s HospitalCode=""
    ;s PatientID=
    s LocID=$P(^PAADM(PatientID),"^",4)
	s ReportCode=$G(^DHCPESetting("DHCPE","ReportCode",LocID))
	i ReportCode'="" s HospitalCode=ReportCode
	s HospitalCode=$zcvt(HospitalCode,"L")
	i HospitalCode="bjxh" d
    .d:OnlyAdvice'="Y" $zobjclassmethod("csp.csp.dhcpeireport."_HospitalCode_".normal.cover","OnPageCSPROOT")
    .d $zobjclassmethod("csp.csp.dhcpeireport."_HospitalCode_".normal.generaladvice","OnPageCSPROOT")
    .d:OnlyAdvice="" $zobjclassmethod("csp.csp.dhcpeireport.normal.stationresult","OnPageCSPROOT")
    e  d
    .d $zobjclassmethod("csp.csp.dhcpeireport.normal.cover","OnPageCSPROOT")
    .//d $zobjclassmethod("csp.csp.dhcpeireport.normal.head.patinfo","OnPageCSPROOT")
    .//d $zobjclassmethod("csp.csp.dhcpeireport.normal.head.title","OnPageCSPROOT")
    .d $zobjclassmethod("csp.csp.dhcpeireport.normal.generaladvice","OnPageCSPROOT")
    .//d $zobjclassmethod("csp.csp.dhcpeireport.normal.summarize","OnPageCSPROOT")
    .//d $zobjclassmethod("csp.csp.dhcpeireport.normal.summarizegather","OnPageCSPROOT")
    .d $zobjclassmethod("csp.csp.dhcpeireport.normal.stationresult","OnPageCSPROOT")
    .d $zobjclassmethod("csp.csp.dhcpeireport.normal.footer","OnPageCSPROOT")
}

ClassMethod OutReportToWebSim()
{
	d $zobjclassmethod("csp.csp.dhcpeireport."_HospitalCode_".normal.cover","OnPageCSPROOT")
	d $zobjclassmethod("csp.csp.dhcpeireport."_HospitalCode_".normal.generaladvice","OnPageCSPROOT")
}

/// 获取个人报告页面
/// w ##class(web.DHCPE.ReportOutToWeb).GetReportPageName()
ClassMethod GetReportPageName()
{
	// 个人报告叶面
	Q "dhcpeireport.normal.csp"
}

/// s val=##class(web.DHCPE.ReportOutToWeb).GetReportPageNameSim()
ClassMethod GetReportPageNameSim()
{
	// 个人报告叶面
	Q "dhcpeireport.normalsim.csp"
}

Storage Default
{
<Data name="ReportOutToWebDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.ReportOutToWebD</DataLocation>
<DefaultData>ReportOutToWebDefaultData</DefaultData>
<IdLocation>^web.DHCP.ReportOutToWebD</IdLocation>
<IndexLocation>^web.DHCP.ReportOutToWebI</IndexLocation>
<StreamLocation>^web.DHCP.ReportOutToWebS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
