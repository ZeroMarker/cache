Class web.eprajax.Observer.GetEpsisodeIDToENC Extends %CSP.Page [ Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("episodeID",1),"-1")
	s Ret = ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDINHOSPITALADMFIRSTPAGEINFO",episodeID)
	s ret = $p(Ret,"^",1)
	w ret
	Quit $$$OK
}

}
