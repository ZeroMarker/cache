Import websys

Class DHCCPMWeb.CPMBL.DHCBLRepCSP Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetSubmitValue()
{
	;d ##class(DHCCPMWeb.CPMBL.DHCBLRepCSP).GetSubmitValue()
	s myid=""
	k ^TMPDHCREQUEST($j)
	
	//set userid = %session.Get("LOGON.USERID")
	//f  s myid=$o(%session.Get(myid)) q:(myid="")  d
	//.s ^TMPDHCREQUEST($j, "Session", myid)=$g(%session.Get(myid))
	m ^TMPDHCREQUEST($j,"session")=%session.Data	
	
	//m ^TMPDHCREQUEST($j,"req")=%request.Data
	s myid=""
	f  s myid=$o(%request.Data(myid)) q:(myid="")  d
	.s ^TMPDHCREQUEST($j, "request", myid)=%request.Get(myid)
	.
	
	;生成报表参数
	;
	
	;查询报表名称
}

ClassMethod GetComponentItemsList() As %String
{
	;d ##class(DHCCPMWeb.CPMBL.DHCBLRepCSP).GetComponentItemsList()
	
	d ..GetSubmitValue()
	
	s myFormName=""
	s myMenuID=%request.Get("TMENU")
	i myMenuID'="" d
	.s mymenuobj=##class(websys.Menu).%OpenId(myMenuID)
	.s myFormName=mymenuobj.LinkComponent.Name
	.d mymenuobj.%Close()
	
	i myFormName="" d
	.s myFormName=%request.Get("TFORM")
	
	i myFormName="" d
	.s myFormName=%request.Get("WEBSYS.TCOMPONENT")
	
	;q:(myFormName="") ""
	s myItems=""
	
	s myCompID=""
	if (myFormName'=""){
		&sql(select ID into :myCompID from websys.component where Name=:myFormName)
	}
	
	i (myCompID=""){
		s myCompID=+$p($p((%request.Get("TEVENT")),"d",2),"i",1)
	}
	
	q:(myCompID="") ""
	
	s myPanelobj=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByCompDR("", myCompID, "")
	
	s myCount = myPanelobj.RepFields.Count()
	
	
	Write !,"<SCRIPT language=""Javascript"">",!
	;JS 函数
		w "var m_CPMPrintAry = new Array();", !
		w "var m_CPMPrintDispTypeAry = new Array();", !
		w "var m_CPMPrintDataTypeAry = new Array();", !
		
		For i = 1:1:myCount {
			s myFieldObj=myPanelobj.RepFields.GetAt(i)
		    s myIdx=i-1
			w "  "_"m_CPMPrintAry["_myIdx_"]='"_myFieldObj.RFName_"';",!
			w "  "_"m_CPMPrintDispTypeAry["_myIdx_"]='"_myFieldObj.RFDisplayType_"';",!
			w "  "_"m_CPMPrintDataTypeAry["_myIdx_"]='"_myFieldObj.RFDataType_"';",!
		}
		;写系统参数
		;s mySys=%session.Get("")
		w "var m_CPMSysPrintAry = new Array();", !
		w "var m_CPMSysPrintDispTypeAry = new Array();", !
		w "var m_CPMSysPrintDataTypeAry = new Array();", !
		w "var m_CPMSysPrintDataValue = new Array();", !
		
		s mylist=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFieldsValue).GetSysFields()
		
		
		s mySysCount=mylist.Count()
		for i=1:1:mySysCount {
			s mySysFieldObj=mylist.GetAt(i)
			s myIdx=i-1
			w " "_"m_CPMSysPrintAry["_myIdx_"] = '"_mySysFieldObj.RFName_"';",!
			w "  "_"m_CPMSysPrintDispTypeAry["_myIdx_"]='"_mySysFieldObj.RFDisplayType_"';",!
			w "  "_"m_CPMSysPrintDataTypeAry["_myIdx_"]='"_mySysFieldObj.RFDataType_"';",!
			
			w "  "_"m_CPMSysPrintDataValue["_myIdx_"]='"_mySysFieldObj.RFDefaultValue_"';",!
		}
		
	w "</SCRIPT>"
	w !
	d ..CPMReportEdit()
	
	d mylist.%Close()
	d myPanelobj.%Close()
	
	q ""
}

ClassMethod SelectTemplate()
{
	;d ##class(DHCCPMWeb.CPMBL.DHCBLRepCSP).SelectTemplate()
	w "<img id='btnFind' name='btnFind'  SRC='../images/websys/lookup.gif' ONCLICK='SelectTemplate()' BORDER='0'>"
}

ClassMethod ChooseTemplate()
{
	;d ##class(DHCCPMWeb.CPMBL.DHCBLRepCSP).ChooseTemplate()
	
	w "<object width=0 height=0 id='config' name='config' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	w "<param name='URL' value='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetServiceURL() _ "'>",!
	w "</object>",! 
	w "<object id='templatetree' name='templatetree' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCTemplateTree' Width='260' Height='310' VIEWASTEXT >",!
	w "</object>",!
	w "<br>"	
	w "<a href='#' id='btnConfirm' name='btnConfirm' onclick='btnConfirmClick()'><img SRC='../images/websys/update.gif' BORDER='0'>确定</A>"
	;w "<a href="#" id='btnCancel' name='btnCancel' onclick='btnCancelClick()'><img SRC='../images/websys/delete.gif' BORDER='0'>取消</A>"
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

ClassMethod CPMReportEdit()
{
	;d ##class(DHCCPMWeb.CPMBL.DHCBLRepCSP).CPMReportEdit()
	s strHostIP = ##class(DHCCPMWeb.CPMBL.ServerConfig).GetHostIP()
	
	;w "<object id='CPMReport' name='CPMReport' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "ReportReview.dll#DHCCPM.ReportReview.Presentation.PrintReviewForm' Width='100' Height='600' VIEWASTEXT>",!
	w "<object id='CPMReport' name='CPMReport' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "ReportReview.dll#DHCCPM.ReportReview.CPMClientPrint' Width='0' Height='0' VIEWASTEXT>",!
	w "<param name='URL' value='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetServiceURL() _ "'>",!
	w "</object>",!	
	
	;w "<object width=0 height=0 id='CPMReport' name='CPMReport' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "ReportReview.dll#DHCCPM.ReportReview.PrintClient'>",!
	;w "<param name='URL' value='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetServiceURL() _ "'>",!
	;w "</object>",! 
	
	;w "<object width=0 height=0 id='UCPrint' name='UCPrint' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCPrint'>",!	
	;w "</object>",! 
	;w "<A id='New' name='New' HREF='#' onclick='NewClickHandler(""" _ $g(PatientID) _ """,""" _ $g(EpisodeID) _ """,""" _ $g(CategoryID) _ """,""" _ $g(CategoryType) _  """,""" _ $g(ChartItemID) _ """,""" _ $g(ProfileID) _ """)'><img SRC='../images/websys/new.gif' BORDER='0'>新建</A>"
	;w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
	;w "<A id='Print' name='Print' HREF='#' onclick='PrintClickHandler()'><img SRC='../images/websys/print.gif' BORDER='0'>打印</A>"
}

ClassMethod SelectCategory()
{
	w "<img id='btnFind' name='btnFind'  SRC='../images/websys/lookup.gif' ONCLICK='SelectCategory()' BORDER='0'>"
}

ClassMethod ChartItemEPRListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChartItemEPRListExecute ]
{
	s qHandle="" 
	Quit $$$OK
}

ClassMethod ChartItemEPRListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	
	s qHandle="1" 
 	s SQLCODE=0  
 	s %counter=0
 	s ID=""
 	S %ResultID=""
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
	If ($Data(%request.Data("ChartItemID",1))) {
		set ChartItemID = $Get(%request.Data("ChartItemID",1))
	}
	else {
		set ChartItemID = ""			
	}	
	new RecordID
	
	;&sql(SELECT ID
	;into :RecordID 
	;FROM EPRinstance.ECRecord
	;WHERE EpisodeID = :EpisodeID
	;And ChartItemID = :ChartItemID )	
	;set GetDataSetSql = "Select ID, Title, HappenDate, HappenTime, CreateUser From EPRinstance.InstanceData Where TheECRecord->ID = ?"	
	set result = ##class(%Library.ResultSet).%New()
	do result.Prepare(GetDataSetSql)
	do result.Execute(RecordID)	
	set rowid = 0	
	While (result.Next())
	{		
		set rowid = rowid + 1		
		Set UserId=result.Data("CreateUser")		
		If UserId'="" Set UserName=$P($G(^SSU("SSUSR",UserId)),"^",2)
		Else  Set UserName=""
		set instanceid = result.Data("ID")
		;&sql(SELECT COUNT(*) into :prcount 
		;	FROM EPRinstance.InstancePrintRecord
		;	WHERE InstanceDataID = :instanceid)
		If prcount = 1 {
			set needprint = 0
			;&sql(SELECT STARTPAGENUM, STARTROWNUM,ENDPAGENUM,ENDROWNUM
			; into :startPageNum, startRowNum, endPageNum, endRowNum 		
			;FROM EPRinstance.InstancePrintRecord
			;WHERE InstanceDataID = :instanceid )
			
			set %ResultID(rowid)=$LB(result.Data("ID"),
			result.Data("Title"), needprint, startPageNum _ "," _ startRowNum,
			endPageNum _ "," _ endRowNum,
			result.Data("HappenDate"),result.Data("HappenTime"),UserName)
				
		}
		else {
			set needprint = 1
			set %ResultID(rowid)=$LB(result.Data("ID"),
			result.Data("Title"), needprint, "", "",
			result.Data("HappenDate"),result.Data("HappenTime"),UserName)
		}			
		
				  
	}	 
 	do result.Close() 
 	s qHandle=%ResultID	
	Quit $$$OK
}

ClassMethod ChartItemEPRListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChartItemEPRListExecute ]
{
	s SQLCODE=0 
 	s $ET="QUIT" 
 	s %counter=%counter+1
 	if $o(%ResultID(""),-1)<%counter 
 	{
		s Row = ""
		s AtEnd=1
 	}
 	else 
 	{
		set Row=%ResultID(%counter)
	}

	Quit $$$OK
}

Query ChartItemEPRList(EpisodeID As %String) As %Query(ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,HappenDate:%String,HappenTime:%String,CreateUser:%String")
{
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
	
	
	w "<object width=0 height=0 id='config' name='config' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	w "<param name='URL' value='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetServiceURL() _ "'>",!
	w "</object>",! 
	
	w "<object width=0 height=0 id='UCPrint' name='UCPrint' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCPrint'>",!	
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
	s strHostIP = ..GetHostIP()	
	s strURL = "http://" _ strHostIP _ "/dhceprform"
	Quit strURL
}

ClassMethod GetServiceURL() As %String
{
	s strHostIP = ..GetHostIP()
	s strApp = ..GetAppPath()
	s strURL = "http://" _ strHostIP _  strApp _ ""
	Quit strURL
}

ClassMethod GetBGColor() As %String
{
	s strBGColor = ##class(EPRmeta.SysOption).GetOptionValueByName("BGColor")
	Quit strBGColor
}

}
