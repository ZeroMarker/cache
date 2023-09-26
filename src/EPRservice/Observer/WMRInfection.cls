Class EPRservice.Observer.WMRInfection Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	获取传染病上报信息
/// Debug：	w ##Class(EPRservice.Observer.WMRInfection).GetInfectionInfo("1","1^sd.001^肺结核")
ClassMethod GetInfectionInfo(AEpisdoeID As %String, ADiagListInfo As %String) As %String
{
	s $zt = "OnErrorHandle1"
	//q "1"_$c(1)_"传染病上报提示信息!"_$c(1)_"dhc.epr.test.wmrinfection.csp?EpisodeID="_AEpisdoeID
	s ret = ##class(DHCMed.EPDService.Service).CheckEPRDiagnosToEpd(AEpisdoeID,ADiagListInfo)
	q ret
OnErrorHandle1
	q ""
}

}
