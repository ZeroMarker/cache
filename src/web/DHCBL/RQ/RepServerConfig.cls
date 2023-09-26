Class web.DHCBL.RQ.RepServerConfig Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

ClassMethod GetReportServiceUrl(website As %String = "") As %String
{
	;w ##class(web.DHCBL.RQ.RepServerConfig).GetReportServiceUrl()
	;serverName + ":" + serverPort + appmap
	;n (website)
	
	s myserverName=$s(website'="":website,1:"127.0.0.1")
	s myserverPort="8080"
	s myAppMap="runqianReport"
	;s myhttp=$g(%request.PageName)
	s myhealthserver = $g(website) 		;$g(%request.GetCgiEnv("SERVER_NAME"))
	s myRowID=##class(web.DHCBL.RQ.RepServerConfig).GetIDByWebSite(myhealthserver)
	if (myRowID'=""){
		s myRSC=##class(User.DHCRepServerConfig).%OpenId(myRowID)
		s myserverName=myRSC.RSCServerIP
		s myserverPort=myRSC.RSCServerPort
		s myAppMap=myRSC.RSCAppName
		s RSCServerName=myRSC.RSCServerName
	}
	if (myserverName[":") {
		s myserverName = $p(myserverName,":",1)
	}
	s myUrl=RSCServerName_"://"_myserverName_":"_myserverPort_"/"_myAppMap_"/"
	//s myUrl="http://"_myserverName_":"_myserverPort_"/"_myAppMap_"/"  //mzc20200706
	s ^TMPURL = myUrl_"^"_myhealthserver
	
	q myUrl
}

ClassMethod GetIDByWebSite(website As %String) As %String
{
	;n (website)
	;q:(website="") $o(^User.DHCRepServerConfigD(""))
	q:(website="") ""
	
	s website = $ZConvert(website, "U")
	s mywebsite=" "_website
	
	s myRowID=$o(^User.DHCRepServerConfigI("HWSIdx",mywebsite, ""))
	i myRowID="" d
	.s myRowID=$o(^User.DHCRepServerConfigI("HWSIdx",mywebsite_":1443", ""))

	q myRowID
}

ClassMethod InsertTest()
{
	;d ##class(web.DHCBL.RQ.RepServerConfig).InsertTest()
	;&sql(select * from SQLUser.DHC_RepServerConfig)
	&sql(insert into SQLUser.DHC_RepServerConfig (RSC_ServerIP,RSC_ServerName,RSC_ServerPort, 
			RSC_HealthWebSite, RSC_AppName) 
		VALUES ('127.0.0.1','127.0.0.1','8080','127.0.0.1','runqianReport'))
		
	&sql(insert into SQLUser.DHC_RepServerConfig (RSC_ServerIP,RSC_ServerName,RSC_ServerPort, 
			RSC_HealthWebSite, RSC_AppName) 
		VALUES ('127.0.0.1','localhost','8080','localhost','runqianReport'))
}

}
