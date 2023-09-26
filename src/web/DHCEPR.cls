Class web.DHCEPR Extends websys.Abstract [ ProcedureBlock ]
{

Parameter BUILD = 243;

ClassMethod SelectTemplate()
{
	w "<img id='btnFind' name='btnFind'  SRC='../images/websys/lookup.gif' ONCLICK='SelectTemplate()' BORDER='0'>"
}

ClassMethod ChooseTemplate()
{
	w "<object width=0 height=0 id='config' name='config' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	w "<param name='URL' value='" _ ##class(web.DHCEPR).GetServiceURL() _ "'>",!
	w "<param name='DBUserPassword' value='" _ ##class(web.DHCEPR).GetUserPassword() _ "'>",!
	w "</object>",! 
	w "<object id='templatetree' name='templatetree' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCTemplateTree' Width='260' Height='290' VIEWASTEXT >",!
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
		Quit EpisodeType	
	}
}

ClassMethod GetSex() As %String
{
	If ($Data(%request.Data("EpisodeID"))) {
		set EpisodeID = $Get(%request.Data("EpisodeID",1))
		set PaperDR = $P($g(^PAADM(EpisodeID)),"^",1)
		s sex=$P($g(^PAPER(PaperDR,"ALL")),"^",7)
		i sex'="" s sex=$P($g(^CT("SEX",sex)),"^",1)
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
	///add ssgroupid and ctlocid for privilege
	set ssgroupid=%session.Get("LOGON.GROUPID")
	set ctlocid=%session.Get("LOGON.CTLOCID")
	
	If ($Data(%request.Data("CONTEXT",1))) {
		set CONTEXT = $Get(%request.Data("CONTEXT",1))
		set ProfileID = $E(CONTEXT,$F(CONTEXT,"DH"),$L(CONTEXT))	
		
		s PPParameters = ""		
		
		&SQL(select PPParameters into :PPParameters from epr.CTProfileParams where ID = :ProfileID)	
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
	
	s bgColor=..GetBGColor()
	
	w "<object id='config' name='config' width=0 height=0 classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	w "<param name='URL' value='" _ ##class(web.DHCEPR).GetServiceURL() _ "'>",!
	w "<param name='DBUserPassword' value='" _ ##class(web.DHCEPR).GetUserPassword() _ "'>",!
	w "</object>",!
	
	if CategoryType="Normal" {
		w "<object id='eprform' name='eprform' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.EPRNormal' Width='850' Height='550' VIEWASTEXT >", !	
	}
	elseif ((CategoryType="Group")||(CategoryType="GroupParent")) {
		w "<object id='eprform' name='eprform' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.EPRGroup' Width='850' Height='550' VIEWASTEXT >", !	
	}
	  w "<param name='IsNewFramework' value='False'>",!
	  w "<param name='Browsable' value='True'>",!
	  w "<param name='Revisionable' value='False'>",!
	  w "<param name='IsTotalLoad' value='True'>",!
		w "<param name='BGColor' value='" _bgColor_ "'>",!
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
		w "<param name='SSGroupID' value='" _ ssgroupid _ "' >",!
		w "<param name='CTLocID' value='" _ ctlocid _ "' >",!
		w "</object>"
		
		//w "<script type='text/javascript'>"
		//w "document.getElementById('eprform').InitForm();"
		//w "</script>"
}

ClassMethod SelectCategory()
{
	w "<img id='btnFind' name='btnFind'  SRC='../images/websys/lookup.gif' ONCLICK='SelectCategory()' BORDER='0'>"
}

/*
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
	If ($Data(%request.Data("CONTEXT",1))) {
		set CONTEXT = $Get(%request.Data("CONTEXT",1))				
		set ProfileID = $E(CONTEXT,$F(CONTEXT,"DL"),$L(CONTEXT))	
	}
	else {
		set ProfileID = ""
	}
		
	new RecordID
	&sql(SELECT ID
	into :RecordID 
	FROM EPRinstance.ECRecord
	WHERE EpisodeID = :EpisodeID
	And ChartItemID = :ProfileID )	
	set GetDataSetSql = "Select ID, Title, HappenDate, HappenTime, CreateUser From EPRinstance.InstanceData  Where TheECRecord->ID = ?  "	
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
		&sql(SELECT COUNT(*) into :prcount 
			FROM EPRinstance.InstancePrintRecord
			WHERE InstanceDataID = :instanceid)			
		If prcount = 1 {
			set needprint = 0
			&sql(SELECT STARTPAGENUM, STARTROWNUM,ENDPAGENUM,ENDROWNUM
			 into :startPageNum, startRowNum, endPageNum, endRowNum 		
			FROM EPRinstance.InstancePrintRecord
			WHERE InstanceDataID = :instanceid )
			
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
 	if $o(%ResultID(""),-1) < %counter 
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
*/
/// ModifyReason:使用M替换原含有objQuery.Prepare()语句的Query
/// 
/// ModifyDate:	2009-01-19
/// ModifyUser:	HouJ
/// ModifyReason:将历次病历按HappenDate和HappenTime从小到大排序
/// 				将CreateDate和CreateTime放入Query结果集
Query ChartItemEPRList(EpisodeID As %String) As %Query(ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,HappenDate:%String,HappenTime:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String")
{
}

ClassMethod ChartItemEPRListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s qHandle="1" 
 	s SQLCODE=0  
 	s %counter=0
 	s ID=""
 	S %ResultID=""
 	s qHandle=%ResultID	
 	
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
	}
	else {
		set ProfileID = ""
	}
	;w ProfileID	
	s RecordID = ""
	&sql(SELECT ID
	into :RecordID 
	FROM EPRinstance.ECRecord
	WHERE EpisodeID = :EpisodeID
	And ChartItemID = :ProfileID )	
	;w SQLCODE
	s rowid = 0
	IF RecordID'=""
	{
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",RecordID,""))
	}
	IF RecordID="" s listNo=""
	
	//modified on 2009-01-19 by HouJian
	//将历次病历按HappenDate和HappenTime从小到大排序
	s repid = $I(^CacheTemp)
	while (listNo '= "")
	{
		s instanceid = RecordID_"||"_listNo
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceid)
		if objInstance '= ""
		{
			if (objInstance.HappenDate = "")
			{	s date = $p($H,",",1)}
			else 
			{	s date = objInstance.HappenDate}
			if (objInstance.HappenTime = "")
			{	s time = $p($H,",",2)}
			else
			{	s time = objInstance.HappenTime}
			s ^CacheTemp(repid, date, time) = instanceid
		}
		
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",RecordID,listNo))
	}
	
	quit:($d(^CacheTemp(repid))=0) $$$OK
	
	s date =""
	for {
		s date = $O(^CacheTemp(repid,date))
		q:(date="")
		
		s time = ""
		for {
			s time = $O(^CacheTemp(repid,date,time))
			q:(time="")
			
			s rowid = rowid + 1
			s instanceid = $g(^CacheTemp(repid,date,time))
			s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceid)
			if objInstance '= ""
			{
				s UserId = objInstance.CreateUser
				if UserId '= "" 
				{	s UserName = $P($G(^SSU("SSUSR",UserId)),"^",2)}
				else
				{	s UserName = ""}
				s Title = objInstance.Title
				s HappenDate = objInstance.HappenDate
				s HappenTime = objInstance.HappenTime
			    s CreateDate=objInstance.CreateDate
			    s CreateTime = objInstance.CreateTime
			    
				&sql(SELECT COUNT(*) into :prcount 
				FROM EPRinstance.InstancePrintRecord
				WHERE InstanceDataID = :instanceid)
			
				If prcount = 1 
				{			
					set needprint = 0
					&sql(SELECT STARTPAGENUM, STARTROWNUM,ENDPAGENUM,ENDROWNUM
			 		into :startPageNum, startRowNum, endPageNum, endRowNum 		
					FROM EPRinstance.InstancePrintRecord
					WHERE InstanceDataID = :instanceid )
					set %ResultID(rowid)=$LB(instanceid,Title, needprint, startPageNum _ "," _ startRowNum,	endPageNum _ "," _ endRowNum,HappenDate,HappenTime,UserName,CreateDate,CreateTime)
				}
				else
				{
					set needprint = 1
					set %ResultID(rowid)=$LB(instanceid,Title, needprint, "", "",HappenDate,HappenTime,UserName,CreateDate,CreateTime)
				}
			}
		}
		
	}	
		
	kill ^CacheTemp(repid)	
	
	//modified on 2009-01-19 by HouJian 结束
	
	/*
	while listNo '= ""
	{
		s rowid = rowid + 1
		s instanceid = RecordID_"||"_listNo
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceid)
		if objInstance '= ""
		{
			s UserId = objInstance.CreateUser
			if UserId '= "" 
			{	s UserName = $P($G(^SSU("SSUSR",UserId)),"^",2)}
			else
			{	s UserName = ""}
			s Title = objInstance.Title
			s HappenDate = objInstance.HappenDate
			s HappenTime = objInstance.HappenTime
			
			&sql(SELECT COUNT(*) into :prcount 
			FROM EPRinstance.InstancePrintRecord
			WHERE InstanceDataID = :instanceid)
			
			If prcount = 1 
			{			
				set needprint = 0
				&sql(SELECT STARTPAGENUM, STARTROWNUM,ENDPAGENUM,ENDROWNUM
			 		into :startPageNum, startRowNum, endPageNum, endRowNum 		
					FROM EPRinstance.InstancePrintRecord
					WHERE InstanceDataID = :instanceid )
				set %ResultID(rowid)=$LB(instanceid,Title, needprint, startPageNum _ "," _ startRowNum,	endPageNum _ "," _ endRowNum,HappenDate,HappenTime,UserName)
			}
			else
			{
				set needprint = 1
				set %ResultID(rowid)=$LB(instanceid,Title, needprint, "", "",HappenDate,HappenTime,UserName)
			}
		}
		
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",RecordID,listNo))
	}
	*/
	
 	s qHandle=%ResultID	
	Quit $$$OK
}

ClassMethod ChartItemEPRListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChartItemEPRListExecute ]
{
	s SQLCODE=0 
 	s $ET="QUIT" 
 	s %counter=%counter+1
 	if $o(%ResultID(""),-1) < %counter 
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

ClassMethod ChartItemEPRListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChartItemEPRListExecute ]
{
	s qHandle="" 
	Quit $$$OK
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
	w "<param name='DBUserPassword' value='" _ ##class(web.DHCEPR).GetUserPassword() _ "'>",!
	w "</object>",! 
	
	w "<object width=0 height=0 id='UCPrint' name='UCPrint' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCPrint'>",!	
	w "</object>",! 
	w "<A id='New' name='New' HREF='#' onclick='NewClickHandler(""" _ PatientID _ """,""" _ EpisodeID _ """,""" _ CategoryID _ """,""" _ CategoryType _  """,""" _ ChartItemID _ """,""" _ ProfileID _ """)'><img SRC='../images/websys/new.gif' BORDER='0'>新建</A>"
	w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
	w "<A id='Print' name='Print' HREF='#' onclick='PrintClickHandler()'><img SRC='../images/websys/print.gif' BORDER='0'>打印</A>"
	w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
	w "<A id='SelectAll' name='SelectAll' HREF='#' onclick='SelectAllClickHandler()'><img SRC='../images/webemr/authorise.gif' BORDER='0'>全选</A>"
  w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
  w "<A id='UnSelectAll' name='UnSelectAll' HREF='#' onclick='UnSelectClickHandler()'><img SRC='../images/webemr/Red Cross.gif' BORDER='0'>全消</A>"
}

/// Function:    GetHostIPFromURL
/// Description: 根据页面访问的地址解析服务器地址（IP地址或域名）
/// Input:       parURL: 需要解析的页面地址
/// Return:      服务器地址（IP地址或域名），如127.0.0.1或localhost,www.trakcare.com
/// Others:      这个方法现在已经无用，暂时保留用于参考
ClassMethod GetHostIPFromURL(parURL As %String) As %String
{
	q:(parURL="") "null"
	s $zt="finally"
	
	s firstPos=0
  ;s parURL=%request.CgiEnvs("HTTP_REFERER")
	// 找到第一个斜线的位置
  s firstPos=$f(parURL,"/")
  q:(firstPos=0) "1"
  // 截取剩余字串
  s ipLength=$l(parURL)
  s parURL=$e(parURL,firstPos-1,ipLength)
	// 找到下一个不是斜线的位置
  s ipLength=$l(parURL)
  for i=1:1:ipLength {
	  q:($e(parURL,i,i)'="/")
  }
  s parURL=$e(parURL,i,ipLength)
	// 找到下一个斜线的位置，返回斜线前面的地址
	s firstPos=$f(parURL,"/")
	q:(firstPos=0) "2"
	q $e(parURL,1,firstPos-2)
	
finally
	q ""
}

/// edited by gaojb 20090807
/// Desc: 服务器IP地址
/// Return: 10.10.141.110
ClassMethod GetHostIP() As %String
{
	;&sql(SELECT WebServer INTO :hostip FROM websys.Configuration WHERE ID = 1)
	;Quit hostip
	;Q %request.CgiEnvs("SERVER_NAME")
	s hostip=%request.CgiEnvs("SERVER_NAME")
	s:($e(hostip,$l(hostip),$l(hostip))="/") hostip=$e(1,$L(hostip-1))
	Q hostip
}

/// gjb add for debug dll without copying files into the server 2007-10-31
/// Desc: 客户端IP地址
/// Return: 10.10.141.110
ClassMethod GetClientIP() As %String
{
	s clientIP=""
	s isDebug=$g(^EPRWebClient("Debug"))
	if (isDebug="1") {
		s clientIP="127.0.0.1"
	}
	else{
		s clientIP=$ZU(67,15,$j)
	}
	q clientIP
}

/// Desc: 应用程序目录
/// Retrun: /trakcarelive/trak/web/
ClassMethod GetAppPath() As %String
{
	&sql(SELECT pathtoapp INTO :pathtoapp 
          FROM websys.Configuration
          WHERE ID = 1)	
          
    s:($e(pathtoapp,1,1)'="/") pathtoapp = "/"_pathtoapp
    s:($e(pathtoapp,$L(pathtoapp),$L(pathtoapp))'="/") pathtoapp = pathtoapp_"/"
    
	Quit pathtoapp
}

/// gaojb edit 20090807
/// 获取dll所在完整路径
/// Return: http://10.10.141.110/dhceprform/
ClassMethod GetFormURL(version As %String = "") As %String
{
	///gjb add for debug dll without copying files into the server 2007-10-31
	s isDebug=""
	s isDebug=$g(^EPRWebClient("Debug"))
	
	if (isDebug="1") {
		s strHostIP=..GetClientIP()
	}
	else {
		s strHostIP = ..GetHostIP()	
	}
	
	s strURL = "http://" _ strHostIP _ "/dhceprform/"
	Quit strURL
}

/// gaojb edit 20090807
/// 获取应用程序完整路径
/// Return: http://10.10.141.110/trakcarelive/trak/web/
/// w ##Class(web.DHCEPR).GetServiceURL()
ClassMethod GetServiceURL() As %String
{
	s strHostIP = ..GetHostIP()
	s strApp = ..GetAppPath()
	s strURL = "http://"_strHostIP_strApp
	Quit strURL
}

/// yejian edit 2016-5-11
/// 获取webservice链接数据库的加密用户和密码串
/// w ##Class(web.DHCEPR).GetUserPassword()
ClassMethod GetUserPassword() As %String
{
	s strBGColor = ##class(EPRmeta.SysOption).GetOptionValueByName("DBUserPassword")
	Quit strBGColor
}

ClassMethod GetBGColor() As %String
{
	s strBGColor = ##class(EPRmeta.SysOption).GetOptionValueByName("BGColor")
	Quit strBGColor
}

/// Desc: 可重复病历创建人所属科室(华西医院历次病历列表中显示该信息)
/// Input: ID：可重复病历rowid
/// Output：无
/// Return: 可重复病历创建人所属科室
/// CreateUser: HouJ, suggusted by XueFL for HuaXiYiYuan
/// CreateTime: 2009-08-03
ClassMethod GetUserLoc(ID) As %String
{
	
	s CreateUser=""
	s instanceid=ID
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceid)
	if objInstance '= ""
	{
		s UserId = objInstance.CreateUser
	}
	s CreateUser=UserId	
	s userloc=""
	&sql(
	select ssusr_defaultdept_dr->ctloc_desc into userloc  from SQLUser.SS_User 
	where SSUSR_RowId = :CreateUser
	)
	Quit userloc
}

}
