/// 接口服务测试类
Class CIS.OPApp.SRV.Test Extends %RegisteredObject
{

ClassMethod TestHISService() As %String
{
	set HISService = ##class(CIS.OPApp.SRV.Factory).GetHISService()
	set response = HISService.ImportHospital()
	do ##class(CIS.OPApp.SRV.Sync.Hospital).Import(response)
	//handler
}

/// w ##class(CIS.OPApp.SRV.Test).TestAISService()
ClassMethod TestAISService() As %String
{
	write "Test Start>>>",!
	set service = ##class(CIS.OPApp.SRV.Factory).GetAISService()
	write "ready to connect",!
	set response = service.Test()
	write "response is ready"
	set result = ##class(CIS.OPApp.SRV.Event.Handler.Test).Test(response)
	write "Test End<<<",!
	quit ""
}

/// w ##class(CIS.OPApp.SRV.Test).TestSoap()
ClassMethod TestSoap() As %GlobalCharacterStream
{
	set request=##class(%GlobalCharacterStream).%New()
	do request.Write("<Request><Header><SourceSystem>Mediway.AIS</SourceSystem><MessageID></MessageID></Header><Body><Arguments><StartDate>2021-10-01</StartDate><EndDate>2021-10-31</EndDate><EpisodeID></EpisodeID></Arguments><Struct></Struct></Body></Request>")
	
	write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.DirectConn.Adaptor).%New()
	do adaptor.Init()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Handler.Test"
	set options.TargetMethod="Test"
	set options.Purpose="Test"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do adaptor.SetOptions(options)
	
	write "OPApp: adaptor is ready",!
	set deserilizedRequest=##class(CIS.OPApp.DTO.ENS.Request).CloneFromXML(request,options.ContentNode,options.ModelName)
	write "OPApp: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	write "OPApp: all complete, ready to send back response",!
	write "OPApp: Response JSON:",response.ToJSON().%ToJSON(),!
	Quit response
}

/// w ##class(CIS.OPApp.SRV.Test).TestSendOperArrangementList()
ClassMethod TestSendOperArrangementList() As %String
{
	write "Test Start>>>",!
	try
	{
		set request = ##class(%GlobalCharacterStream).%New()
		do request.Write(^CIS.AN.DEBUG.DTS("SRV","ForENS","SendOperArrangementList","Args"))
		write "request is ready:",!
		write request.Read(),!
		
		set response = ##class(CIS.OPApp.SRV.DirectConn.Server.ForENS).SendOperArrangementList(request)
		write "response is ready:",!
		write response.Read(),!
	}
	catch(e)
	{
		write e.DisplayString(),!
	}
	
	write "Test End<<<",!
	quit ""
}

}
