/// 获取服务器配置类
Class DHCCPMWeb.CPMBL.ServerConfig [ Abstract, ClassType = "", ProcedureBlock ]
{

ClassMethod SelectTemplate()
{
	w "<img id='btnFind' name='btnFind'  SRC='../images/websys/lookup.gif' ONCLICK='SelectTemplate()' BORDER='0'>"
}

ClassMethod ChooseTemplate()
{
	w "<object width=0 height=0 id='config' name='config' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	w "<param name='URL' value='" _ ##class(web.DHCEPR).GetServiceURL() _ "'>",!
	w "</object>",! 
	w "<object id='templatetree' name='templatetree' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCTemplateTree' Width='260' Height='310' VIEWASTEXT >",!
	w "</object>",!
	w "<br>"	
	w "<a href='#' id='btnConfirm' name='btnConfirm' onclick='btnConfirmClick()'><img SRC='../images/websys/update.gif' BORDER='0'>确定</A>"
	w "<a href="#" id='btnCancel' name='btnCancel' onclick='btnCancelClick()'><img SRC='../images/websys/delete.gif' BORDER='0'>取消</A>"
}

ClassMethod GetEpisodeType() As %String
{
	
	If ($Data(%request.Data("EpisodeID"))) {
		set EpisodeID = $Get(%request.Data("EpisodeID",1))
		set EpisodeType = $p(^PAADM(EpisodeID),"^",2)
		;w EpisodeType
		Quit EpisodeType	
	}
}

ClassMethod GetSex() As %String
{
	If ($Data(%request.Data("EpisodeID"))) {
		set EpisodeID = $Get(%request.Data("EpisodeID",1))
		s sex=$P($g(^PAPER(EpisodeID,"ALL")),"^",7)
		i sex'="" s sex=$P($g(^CT("SEX",sex)),"^",1)
		;w "-"_sex_"-",!
		Quit sex	
	}
}

ClassMethod EPREdit()
{
	/*s name = 0
	for {
		s name=$o(%request.Data(name))
		q:(name="")
		s value=0
		for {
			s value=$o(%request.Data(name,value))
			q:(value="")
			w name , " ",value," ",%request.Data(name,value),!
		}
	}*/
		
	
	If ($Data(%request.Data("PatientID"))) {
		set PatientID = $Get(%request.Data("PatientID",1))		
	}
	else {
		set PatientID = ""			
	}
	
	If ($Data(%request.Data("EpisodeID"))) {
		set EpisodeID = $Get(%request.Data("EpisodeID",1))
		set EpisodeType = $p(^PAADM(EpisodeID),"^",2)		
	}
	else {
		set EpisodeID = ""
		set EpisodeType = ""			
	}
	
	
	
	set userid = %session.Get("LOGON.USERID")
	
	set username = %session.Get("LOGON.USERNAME")	
	
	
	If ($Data(%request.Data("CONTEXT",1))) {
		set CONTEXT = $Get(%request.Data("CONTEXT",1))
				
		set ProfileID = $E(CONTEXT,$F(CONTEXT,"DH"),$L(CONTEXT))	
		
		s PPParameters = ""		
		
		&SQL(select PPParameters into:PPParameters from epr.CTProfileParams where ID = :ProfileID)	
		
		
		set CategoryName = $P(PPParameters,",",1)
		set CategoryID = $P(PPParameters,",",2)
		set CategoryType = $P(PPParameters,",",3)	
		
	}
	
	
	
	If ($Data(%request.Data("ChartItemID",1))) {
		set ChartItemID = $Get(%request.Data("ChartItemID",1))
	}
	else {
		set ChartItemID = ""			
	}
	
	
	
	
	s strHostIP = ##class(web.DHCEPR).GetHostIP()
	
	w "<object id='config' name='config' width=0 height=0 classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	w "<param name='URL' value='" _ ##class(web.DHCEPR).GetServiceURL() _ "'>",!
	w "</object>",!	
	w "<object id='eprform' name='eprform' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCEPR' Width='800' Height='600' VIEWASTEXT >", !	
	w "<param name='BGColor' value='" _ ..GetBGColor() _ "'>",!
	w "<param name='UserID' value='" _ userid _ "'>",!	
	w "<param name='UserName' value='" _ username _ "'>",!
	w "<param name='PatientID' value='" _ PatientID _ "'>",!	
	w "<param name='EpisodeID' value='" _ EpisodeID _ "'>",!
	w "<param name='EpisodeType' value='" _ EpisodeType _ "'>",!		
	w "<param name='CategoryName' value='" _ CategoryName _ "'>",!
	w "<param name='CategoryID' value='" _ CategoryID _ "'>",!
	w "<param name='CategoryType' value='" _ CategoryType _ "'>",!
	w "<param name='ChartItemID' value='" _ ChartItemID _ "'>",!
	w "<param name='ProfileID' value='" _ ProfileID _ "' >",!
	w "<param name='ChartItemType' value='Single'>",!
	w "<param name='ChartListNo' value='1'>",!	
	w "</object>"
}

ClassMethod SelectCategory()
{
	w "<img id='btnFind' name='btnFind'  SRC='../images/websys/lookup.gif' ONCLICK='SelectCategory()' BORDER='0'>"
}

ClassMethod CLBar()
{
	If ($Data(%request.Data("PatientID"))) {
		set PatientID = $Get(%request.Data("PatientID",1))		
	}
	else {
		set PatientID = ""			
	}
	
	If ($Data(%request.Data("EpisodeID"))) {
		set EpisodeID = $Get(%request.Data("EpisodeID",1))		
	}
	else {
		set EpisodeID = ""			
	}
	
	
	If ($Data(%request.Data("CONTEXT",1))) {
		set CONTEXT = $Get(%request.Data("CONTEXT",1))
				
		set ProfileID = $E(CONTEXT,$F(CONTEXT,"DL"),$L(CONTEXT))	
		
		s PPParameters = ""		
		
		&SQL(select PPParameters into:PPParameters from epr.CTProfileParams where ID = :ProfileID)	
		
		
		set CategoryName = $P(PPParameters,",",1)
		set CategoryID = $P(PPParameters,",",2)
		set CategoryType = $P(PPParameters,",",3)	
		
	}
	
	If ($Data(%request.Data("ChartItemID",1))) {
		set ChartItemID = $Get(%request.Data("ChartItemID",1))
	}
	else {
		set ChartItemID = ""			
	}
	
	
	w "<object width=0 height=0 id='config' name='config' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	w "<param name='URL' value='" _ ##class(web.DHCEPR).GetServiceURL() _ "'>",!
	w "</object>",! 
	
	w "<object width=0 height=0 id='UCPrint' name='UCPrint' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCPrint'>",!	
	w "</object>",! 
	w "<A id='New' name='New' HREF='#' onclick='NewClickHandler(""" _ PatientID _ """,""" _ EpisodeID _ """,""" _ CategoryID _ """,""" _ CategoryType _  """,""" _ ChartItemID _ """,""" _ ProfileID _ """)'><img SRC='../images/websys/new.gif' BORDER='0'>新建</A>"
	w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
	w "<A id='Print' name='Print' HREF='#' onclick='PrintClickHandler()'><img SRC='../images/websys/print.gif' BORDER='0'>打印</A>"
}

ClassMethod GetHostIP() As %String
{
	
	&sql(SELECT WebServer INTO :webserver 
          FROM websys.Configuration
          WHERE ID = 1)
    /////s webserver="192.168.1.101"
	Quit webserver
}

ClassMethod GetHostIPOD() As %String
{
	
	&sql(SELECT WebServer INTO :webserver 
          FROM websys.Configuration
          WHERE ID = 1)	
	Quit webserver
}

ClassMethod GetAppPath() As %String
{
	
	&sql(SELECT pathtoapp INTO :pathtoapp 
          FROM websys.Configuration
          WHERE ID = 1)	
	Quit pathtoapp
}

ClassMethod GetFormURL() As %String
{
	;w ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL()
	s strHostIP = ..GetHostIP()	
	s strURL = "http://" _ strHostIP _ "/dhccpmform/"
	;s strURL = "http://" _ strHostIP _ "/dhceprform/"
	Quit strURL
}

ClassMethod GetServiceURL() As %String
{
	;w ##class(DHCCPMWeb.CPMBL.ServerConfig).GetServiceURL()
	s strHostIP = ..GetHostIP()
	s strApp = ..GetAppPath()
	s strURL = "http://" _ strHostIP _  strApp _ "/"
	s ^test= strHostIP_"^"_strApp_"^"_strURL
	Quit strURL
}

ClassMethod GetBGColor() As %String
{
	s strBGColor = ##class(EPRmeta.SysOption).GetOptionValueByName("BGColor")
	Quit strBGColor
}

}
