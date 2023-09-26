Class EMRservice.HISInterface.Ens.FPInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##Class(EMRservice.HISInterface.Ens.FPInfo).SendAdmFirstPage("")
ClassMethod SendAdmFirstPage(EpisodeID) As %String
{
	s ret = "0"
	s sc = ""
	try 
	{
		//推送患者信息
		s sc = ##class(web.DHCENS.EnsHISService).DHCHisInterface("SendPatientOut",EpisodeID)
		if ($isObject(sc))
		{ s sc = sc.Read()}
		
		//推送首页信息
		if ($p(sc,"^",1) = "0")
		{
			s sc = ##class(web.DHCENS.EnsHISService).DHCHisInterface("SendAdmFirstPage",EpisodeID)
			if ($isObject(sc))
			{ s sc = sc.Read()}
		}
		
		
		if ($p(sc,"^",1) = "0")
		{
			s ret = "1"
		}
		else
		{
			s ret = "0^"_sc
		}
	} catch exception {
		b "s"
		s ret = "0^"_exception.Name_" "_exception.Location
	}
	
	q ret
}

}
