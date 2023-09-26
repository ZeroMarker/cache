Class DHCCL.HttpService.ANService Extends (%RegisteredObject, %CSP.Page)
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action", 1), "")
	if (action="GetAnaQualityControl")
	{
		set OperScheduleID=$g(%request.Data("OperScheduleID", 1), "")
		set EpisodeID=$g(%request.Data("EpisodeID", 1), "")
		set DischargeDate=$g(%request.Data("DischargeDate", 1), "")
		quit ##class(DHCCL.Factory.ANInterfaceFactory).GetService().GetAnaQualityControlJson(OperScheduleID,EpisodeID,DischargeDate)
	}
	elseif (action="GetAnaOperThemeInfo")
	{
		set OperScheduleID=$g(%request.Data("OperScheduleID", 1), "")
		set EpisodeID=$g(%request.Data("EpisodeID", 1), "")
		set OperDate=$g(%request.Data("OperDate", 1), "")
		quit ##class(DHCCL.Factory.ANInterfaceFactory).GetService().GetAnaOperThemeInfoJson(OperScheduleID,EpisodeID,OperDate)
	}
	else 
	{
		w "无参数"
	}
	
	Quit $$$OK
}

}
