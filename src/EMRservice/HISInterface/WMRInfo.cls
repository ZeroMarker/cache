Class EMRservice.HISInterface.WMRInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	获取传染病上报信息
/// Debug：	w ##Class(EMRservice.HISInterface.WMRInfo).GetInfectionInfo("1","1^sd.001^肺结核")
ClassMethod GetInfectionInfo(APatientId As %String, AEpisdoeID As %String, ADiagListInfo As %String) As %String
{
	s $zt = "OnErrorHandle1"
	//q "1"_$c(1)_"传染病上报提示信息!"_$c(1)_"dhc.epr.test.wmrinfection.csp?EpisodeID="_AEpisdoeID
	//s ret = ##class(DHCMed.EPDService.Service).CheckEPRDiagnosToEpd(AEpisdoeID,ADiagListInfo)
	//q ret
	s returnvalue = ""
	s ret = ##class(DHCMed.EPDService.Service).CheckDiagnosTextToEpd(AEpisdoeID,ADiagListInfo)
	s length = $l(ret,$c(1))
	for I=1:1:length
	{
		continue:($p($p(ret,$c(1),I),"^",1)'= "1")
		if (returnvalue '= "")
		{
			s returnvalue = returnvalue_$c(2)_"dhcmed.epd.report.csp?PatientID="_APatientId_"&EpisodeID="_AEpisdoeID_"&IFRowID="_$p($p(ret,$c(1),I),"^",2)_"&LocFlag=0"
		}else {
			s returnvalue = "1"_$c(1)_"诊断["_$p($p(ret,$c(1),I),"^",3)_"]如为传染病,请及时上报!"_$c(1)_"dhcmed.epd.report.csp?PatientID="_APatientId_"&EpisodeID="_AEpisdoeID_"&IFRowID="_$p($p(ret,$c(1),I),"^",2)_"&LocFlag=0"
		}
	}
	q returnvalue
OnErrorHandle1
	q ""
}

/// Desc:	获取院内感染信息
/// Debug：	w ##Class(EMRservice.HISInterface.WMRInfo).GetNosocomialInfection("1","肺部感染")
ClassMethod GetNosocomialInfection(AEpisdoeID As %String, AInfectionDiag As %String) As %String
{
	s $zt = "OnErrorHandle2"
	//q "1"_$c(1)_"院内感染提示信息!"_$c(1)_"dhc.epr.test.wmrinfection.csp?EpisodeID="_AEpisdoeID
	//q "1"_$c(1)_"诊断["_AInfectionDiag_"]如为院内感染,请及时上报!"_$c(1)_"dhcmed.ninf.rep.infreport.csp?1=1&ReportType=COMP&EpisodeID="_AEpisdoeID
	q "1"_$c(1)_"诊断["_AInfectionDiag_"]如为院内感染,请及时上报!"_$c(1)_"dhchai.ir.inf.report.csp?1=1&Paadm="_AEpisdoeID_"&ReportID=&EpisodeID="

OnErrorHandle2
	q ""
}

/// /// Desc:	获取罕见病信息
/// /// Debug：	w ##Class(EMRservice.HISInterface.WMRInfo).GetRareDiseases("1","肺部感染")
ClassMethod GetRareDiseases(AEpisdoeID As %String, ARareDiseasesDiag As %String) As %String
{
	s $zt = "OnErrorHandle3"
	//电子病历罕见病调用：
	s PatientId = $P(^PAADM(AEpisdoeID),"^",1)
	q "1"_$c(1)_"诊断["_ARareDiseasesDiag_"]如为罕见病,请及时上报!"_$c(1)_"dhcma.rd.report.csp?PatientID="_PatientId_"&EpisodeID="_AEpisdoeID_"&IFRowID=&LocFlag=0"
	
OnErrorHandle3
	q
}

}
