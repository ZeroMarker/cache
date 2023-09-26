Class web.DHCEPRExt Extends websys.Abstract [ ProcedureBlock ]
{

Parameter BUILD = 359;

ClassMethod SelectTemplate()
{
	w "<img id='btnFind' name='btnFind'  SRC='../images/websys/lookup.gif' ONCLICK='SelectTemplate()' BORDER='0'>"
}

ClassMethod ChooseTemplate()
{
	w "<object width=0 height=0 id='config' name='config' classid='" _ ##class(web.DHCEPR).GetFormURL("1") _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	w "<param name='URL' value='" _ ##class(web.DHCEPR).GetServiceURL() _ "'>",!
	w "<param name='FormURL' value='" _ ##class(web.DHCEPR).GetFormURL("1") _ "'>",!
	w "<param name='DBUserPassword' value='" _ ##class(web.DHCEPR).GetUserPassword() _ "'>",!
	w "</object>",! 
	w "<object id='templatetree' name='templatetree' classid='" _ ##class(web.DHCEPR).GetFormURL("1") _ "WebClient.dll#dhcc.epr.webclient.UCTemplateTree' Width='260' Height='290' VIEWASTEXT >",!
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
	
	//获取Session信息
	set userid = %session.Get("LOGON.USERID")
	set username = %session.Get("LOGON.USERNAME")
	set ssgroupid=%session.Get("LOGON.GROUPID")
	set ctlocid=%session.Get("LOGON.CTLOCID")
	set password = %session.Get("LOGON.PASSWORD")		//Add on 2012-01-17 for 北京协和项目 : 传染病上报所需环境变量 
	set employeeNo = %session.Get("LOGON.EmployeeNo")	//Add on 2012-01-17 for 北京协和项目 : 传染病上报所需环境变量 
	
	//获取页面参数
	set PatientID = $Get(%request.Data("PatientID",1),"")		
	set EpisodeID = $Get(%request.Data("EpisodeID",1),"")
	set CategoryID = $Get(%request.Data("CategoryID",1),"")
	set ChartItemID = $Get(%request.Data("ChartItemID",1),"")
	set docID = $Get(%request.Data("printTemplateDocId",1),"")
	
	//判断就诊类型
	set EpisodeType = ""
	if (EpisodeID '= "")
	{
		set EpisodeType = $p(^PAADM(EpisodeID),"^",2)
	}
	
	//获取绑定界面模板ID及界面模板目录ID
	s bindTemplateCategoryID = ""
	s bindTemplateID = ""
	set category = ##class(EPRmeta.EPRTemplate).%OpenId(ChartItemID)
	if (category '= "")
	{
		set bindTemplateCategoryID = category.BindTemplateCategoryID
		set bindTemplateID = category.BindTemplateID
		do category.%Close()
		set category = ""
	}
	
	//获取目录类型及名称
	set CategoryName = ""
	set CategoryType = "Normal"
	if (CategoryID '= "")
	{
		set CategoryNote = $Get(^DHCEPRM.TemplateCategoryD(CategoryID))
		set CategoryName = $lg(CategoryNote,3)
		set CategoryType = $lg(CategoryNote,7)
	}	
	
	set ProfileID = ""
	set ProfileID = ChartItemID
	
	//获取背景色
	s bgColor=..GetBGColor()
	
	//获取客户端IP地址
	s strHostIP = ##class(web.DHCEPR).GetHostIP()
	
	//判断是否留痕
	s Revisionable = "False"
	s Revision = ##class(EPRmeta.SysOption).GetOptionValueByName("Revision")
	if (Revision = "Y")
	{
		s logID = ##class(EPRinstance.EPRLogs).GetLogID(EpisodeID, docID, "1")	
		if (logID '= "")
		{
			s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(logID)		
			s status = eprLogs.EPRStatus
			s Revisionable = ##Class(EPRservice.BLL.BLEPRRevision).IsRevisionActive(status,docID)
			if (Revisionable="1") 
			{s Revisionable = "True"}
			else 
			{s Revisionable = "False"}
		}
	}

	//判断权限
	s eprNum = ##class(EPRservice.BOEPRLogs).GetSingleEPRNumByDocType(docID)
	s arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(userid, EpisodeID, PatientID, ctlocid, bindTemplateID, ssgroupid, bindTemplateCategoryID, docID, eprNum)
	s canView = arr.GetAt("canView")
	if (canView = "1")
	{
		s canView = "True"
	}
	else
	{
		s canView = "False"
	}	
	
	//隐私级别
	s privacyLevel = ##class(EPRservice.Privilege.BOPrivRule).GetPrivacyLevel2(userid, EpisodeID, PatientID, ctlocid, bindTemplateID, ssgroupid, bindTemplateCategoryID, docID, eprNum)
	
	//禁用数据同步提示
	s needStopDataSync =  ##Class(EPRservice.BLL.BLDataSyncTip).NeedStopDataSync(userid,EpisodeID,%session.SessionId)
	
	w "<object id='config' name='config' width=0 height=0 classid='" _ ##class(web.DHCEPR).GetFormURL("1") _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!
	//w "<object id='config' name='config' width=0 height=0 classid='clsid:0B596853-D803-3E1C-AF3A-11FE02FF7856' codebase='" _ ##class(web.DHCEPR).GetFormURL() _ "EPRCom.CAB#version=1,0,0,1'>",!
	w "<param name='URL' value='" _ ##class(web.DHCEPR).GetServiceURL() _ "'>",!
	w "<param name='FormURL' value='" _ ##class(web.DHCEPR).GetFormURL("1") _ "'>",!
	w "<param name='DBUserPassword' value='" _ ##class(web.DHCEPR).GetUserPassword() _ "'>",!
	w "<param name='GlobalValue1' value='" _ "Password^"_password _ "'>",!     	//Add on 2012-01-17 for 北京协和项目 : 传染病上报所需环境变量 
	w "<param name='GlobalValue2' value='" _ "EmployeeNo^"_employeeNo _ "'>",!		//Add on 2012-01-17 for 北京协和项目 : 传染病上报所需环境变量 
	w "<param name='GlobalValue3' value='" _ "PrivacyLevel^"_privacyLevel _ "'>",!		//隐私级别
	w "<param name='GlobalValue4' value='" _ "NeedStopDataSync^"_needStopDataSync _ "'>",!		//禁用数据同步提示
	
	w "</object>",!	
	
	//w "<link rel='Configuration' href='" _ ##class(web.DHCEPR).GetFormURL("1")_ "WebClient.dll.config' />",!

	
  	if CategoryType="Normal" {
		;w "<object id='eprform' name='eprform' classid='" _ ##class(web.DHCEPR).GetFormURL() _ "WebClient.dll#dhcc.epr.webclient.UCEPR' Width='100%' Height='100%' VIEWASTEXT >", !	
		//w "<object id='eprform' name='eprform' classid='clsid:452F9D7B-CC5A-3737-A2A1-05608B042EEE' codebase='" _ ##class(web.DHCEPR).GetFormURL() _ "EPRCom.CAB#version=1,0,0,1' Width='100%' Height='100%' VIEWASTEXT >", !	
		w "<object id='eprform' name='eprform' classid='" _ ##class(web.DHCEPR).GetFormURL("1") _ "WebClient.dll#dhcc.epr.webclient.EPRNormal' Width=100% Height=100% VIEWASTEXT >", !
	}
	elseif ((CategoryType="Group")||(CategoryType="GroupParent")) {
		w "<object id='eprform' name='eprform' classid='" _ ##class(web.DHCEPR).GetFormURL("1") _ "WebClient.dll#dhcc.epr.webclient.EPRGroup' Width='100%' Height='100%' VIEWASTEXT >", !	
	}
		w "<param name='IsTotalLoad' value='True'>",!
		w "<param name='IsNewFramework' value='True'>",!
		w "<param name='Revisionable' value='" _Revisionable_ "'>",!
		w "<param name='Browsable' value='" _canView_ "'>",!
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
		///w "<param name='UniqueId' value='" _uniqueId_ "' >",! // by gjb 2007-10-23
		w "</object>"
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
/// Desc:		获取病程记录列表
/// Input:		EpisodeID : 就诊指针
/// 
/// ModifyDate:	2008-08-01
/// ModifyUser: HouJ
/// ModifyDesc:	使用M替换原含有objQuery.Prepare()语句的Query
/// 
/// ModifyDate:	2009-01-19
/// ModifyUser:	HouJ
/// ModifyDesc: 1)将历次病历按HappenDate和HappenTime从小到大排序
/// 			2)将CreateDate和CreateTime放入Query结果集
/// 
/// ModifyDate: 2010-07-11
/// ModifyUser: HouJ
/// ModifyDesc:	使用临时Global存储Query的返回值
Query ChartItemEPRList(EpisodeID As %String) As %Query(ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,HappenDate:%String,HappenTime:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String")
{
}

ClassMethod ChartItemEPRListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	//用来排序的临时global节点
	s repidtmp = $I(^CacheTemp)
	
	s SQLCODE=0  
 	s ID=""
 	
 	
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
	
	/*
	If ($Data(%request.Data("CONTEXT",1))) {
		set CONTEXT = $Get(%request.Data("CONTEXT",1))				
		set ProfileID = $E(CONTEXT,$F(CONTEXT,"DL"),$L(CONTEXT))	
	}
	else {
		set ProfileID = ""
	}
	*/
	set ProfileID = $Get(%request.Data("ProfileID",1),"-1")
	
	s RecordID = ""
	&sql(SELECT ID
	into :RecordID 
	FROM EPRinstance.ECRecord
	WHERE EpisodeID = :EpisodeID
	And ChartItemID = :ProfileID )	
	
	IF RecordID'=""
	{
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",RecordID,""))
	}
	IF RecordID="" s listNo=""
	
	// Modified on 2009-01-19 by HouJian
	// 将历次病历按HappenDate和HappenTime从小到大排序
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
			s ^CacheTemp(repidtmp, date, time) = instanceid
		}
		
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",RecordID,listNo))
	}
	
	quit:($d(^CacheTemp(repidtmp))=0) $$$OK
	
	s date =""
	for {
		s date = $O(^CacheTemp(repidtmp,date))
		q:(date="")
		
		s time = ""
		for {
			s time = $O(^CacheTemp(repidtmp,date,time))
			q:(time="")
			
			s instanceid = $g(^CacheTemp(repidtmp,date,time))
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
				WHERE InstanceDataID = :instanceid and PrintStatus <> 'UnPrint')
			
				s StartPageRow = ""
				s EndPageRow = ""
				s NeedPrint = 1
				If (prcount = 1) 
				{			
					&sql(SELECT top 1 STARTPAGENUM, STARTROWNUM,ENDPAGENUM,ENDROWNUM
			 		into :startPageNum, :startRowNum, :endPageNum, :endRowNum 		
					FROM EPRinstance.InstancePrintRecord
					WHERE InstanceDataID = :instanceid and PrintStatus <> 'UnPrint')
					s StartPageRow = startPageNum_","_startRowNum
					s EndPageRow = endPageNum_","_endRowNum
					s NeedPrint = 0
				}
			
				// Modifed on 2012-07-11 by houj
				// 使用临时Global存储Query的返回值
				set ^CacheTemp(repid, ind) = $LB(instanceid,Title,NeedPrint,StartPageRow,EndPageRow,HappenDate,HappenTime,UserName,CreateDate,CreateTime)
				set ind = ind + 1
			}
		}
	}	
	
	//清空用于排序的临时global节点
	kill ^CacheTemp(repidtmp)
	
	Quit $$$OK
}

ClassMethod ChartItemEPRListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChartItemEPRListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ChartItemEPRListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChartItemEPRListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator: 	陈文俊
/// CreatDate: 	2009-08-17
/// Desc：		根据Log检索出某一个目录下的所有记录(增加可重复界面模板RowID和Version)
/// Input: 		episodeID ：病人就诊号
/// 			docIDs ：打印模板的DocID(多个DocID之间用^分隔)
/// 			
/// ModifyDate: 2012-05-22
/// ModifyUser:	houj
/// ModifyDesc:	使用临时Global存储Query的返回值
Query MultipleReportList(episodeID As %String, docIDs As %String, byDesc As %String = "1") As %Query(ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,HappenDate:%String,HappenTime:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,EPRNum:%Integer,LogRowID:%String,EPRStatus:%String,EPRStatusName:%String,LogDocID:%String,Remark:%String,TemplateID:%String,TemplateVersion:%String,TemplateDocID:%String")
{
}

ClassMethod MultipleReportListExecute(ByRef qHandle As %Binary, episodeID As %String, docIDs As %String, byDesc As %String = "1") As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	//用来排序的临时Global节点	
	s repidtmp = $I(^CacheTemp)
	
	//将多个打印模板DocID中取出相应的Logs的docID及eprnum，
	//将其按日期时间作为索引存放在^CacheTemp中
	s docIDCount = $l(docIDs, "^")
	for i = 1:1:docIDCount 
	{
		s curDocID = $p(docIDs, "^", i)
		continue:(curDocID = "")
		
		//是否存在可重复病历数据
		s ecRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_episodeID, " ML"_curDocID, ""))
		continue:(ecRecordID = "") 
			
		//该可重复病历界面模板对应的TemplateDocID
		s templateDocID = ""
		
		//遍历一个打印模板DocID的数据
		s curEPRNum = 0
		for {
			s curEPRNum = $o(^DHCEPRI.EPRLogsI("IdxMain", " "_episodeID, " "_curDocID, curEPRNum))
			q:(curEPRNum = "")
			
			s eprLogsRowID = $o(^DHCEPRI.EPRLogsI("IdxMain", " "_episodeID, " "_curDocID, curEPRNum, ""))
			q:(eprLogsRowID = "")   //此值为空表明表索引出错，直接退出循环，便于在前端发现问题
			
			s eprLogsInfo = $$GetEPRLogsInfo(eprLogsRowID)
			continue:(eprLogsInfo = "")
			
			s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, " "_curEPRNum, ""))
			continue:(childSub = "")	
			s instanceDataID = ecRecordID_"||"_childSub
			
			s instanceDataInfo = $$GetInstanceDataInfo(instanceDataID)
			continue:(instanceDataInfo = "")
			
			if (templateDocID = "")
			{
				s templateID = $List(instanceDataInfo,5)
				s templateDocID = $$GetTemplateDocID(curDocID, templateID)
				q:(templateDocID = "")  //此值为空表明基础数据错误，直接退出循环，便于在前端发现问题
			}
			
			
			//$LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName)
			s happenDate 	= $List(eprLogsInfo, 1)
			s happenTime 	= $List(eprLogsInfo, 2)
			s createDate 	= $List(eprLogsInfo, 3)
			s createTime 	= $List(eprLogsInfo, 4)
			s eprStatus  	= $List(eprLogsInfo, 5)
			s eprStatusName = $List(eprLogsInfo, 6)
			//$LB(userID,userName,title,remark,templateID,templateVersion,startPageRow,endPageRow)
			s userID		= $List(instanceDataInfo, 1)
			s userName		= $List(instanceDataInfo, 2)
			s title			= $List(instanceDataInfo, 3)
			s remark		= $List(instanceDataInfo, 4)
			s templateID	= $List(instanceDataInfo, 5)
			s templateVersion = $List(instanceDataInfo, 6)
			s needPrint		= $List(instanceDataInfo, 7)
			s startPageRow	= $List(instanceDataInfo, 8)
			s endPageRow	= $List(instanceDataInfo, 9)
			
			//ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,
			//HappenDate:%String,HappenTime:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,
			//EPRNum:%Integer,LogRowID:%String,EPRStatus:%String,EPRStatusName:%String,LogDocID:%String,
			//Remark:%String,TemplateID:%String,TemplateVersion:%String,TemplateDocID:%String"
			s output = $LB(instanceDataID,title,needPrint,startPageRow,endPageRow,happenDate,happenTime,userName,createDate,createTime,curEPRNum,eprLogsRowID,eprStatus,eprStatusName,curDocID,remark,templateID,templateVersion,templateDocID)
			s ^CacheTemp(repidtmp, happenDate, happenTime, curDocID) = output
		}
	}
		
		
	quit:($d(^CacheTemp(repidtmp))=0) $$$OK
	
	
	//从^CacheTemp时按日期时间索引取出数据
	s date =""
	for {
		s date = $O(^CacheTemp(repidtmp,date),byDesc)
		q:(date="")
		
		s time = ""
		for {
			s time = $O(^CacheTemp(repidtmp,date,time),byDesc)
			q:(time="")
			
			s printDocID = ""
			for {
				s printDocID = $O(^CacheTemp(repidtmp,date,time,printDocID),byDesc)
				q:(printDocID = "")
				
				//输出返回值
				s output = $g(^CacheTemp(repidtmp,date,time,printDocID))
				s ^CacheTemp(repid, ind) = output
				s ind = ind + 1 
			}
		}
	}	
	kill ^CacheTemp(repidtmp)	

	Quit $$$OK
	
	
	
GetEPRLogsInfo(eprLogsRowID)	
	s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsRowID)
	q:(eprLogs = "") ""
		
	s happenDate = eprLogs.HappenDate
	s happenTime = eprLogs.HappenTime
	if (happenDate = "")||(happenTime = "")
	{
		s happenDate = $p($H,",",1)
		s happenTime = $p($H,",",2)
	}
	
	s createDate = eprLogs.CreateDate
	s createTime = eprLogs.CreateTime
	
	s eprStatus = eprLogs.EPRStatus
	s eprStatusName = ""					
	&sql(SELECT top 1 StatusName into :eprStatusName
			FROM EPRmeta.EPRStatus
			WHERE StatusCode = :eprStatus)
	
	s eprLogs = ""	
			
	q $LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName)

GetInstanceDataInfo(instanceDataID)
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataID)
	q:(objInstance = "") ""
	
	Quit:(##class(EPRservice.BLRecInstanceData).CheckRecordAvailable(instanceDataID)="Dumped") ""
	
	s userID = objInstance.CreateUser
	if (userID '= "")
	{	s userName = $P($G(^SSU("SSUSR",userID)),"^",2)}
	else
	{	s userName = ""}
	s title = objInstance.Title
	s remark = objInstance.Remark
	if (remark=$c(0)) s remark=""
	s templateID = objInstance.TemplateID
	s templateVersion = objInstance.TemplateVersion
	
	s objInstance = ""
	
	k SQLCODE
	&sql(SELECT top 1 StartPageNum, StartRowNum,EndPageNum,EndRowNum
		into :startPageNum, :startRowNum, :endPageNum, :endRowNum 		
		FROM EPRinstance.InstancePrintRecord
		WHERE InstanceDataID = :instanceDataID and PrintStatus <> 'UnPrint')
	if (SQLCODE = "0")
	{
		s needPrint = "0"
		s startPageRow = startPageNum_","_startRowNum
		s endPageRow = endPageNum_","_endRowNum
	}
	else
	{
		s needPrint = "1"
		s startPageRow = ""
		s endPageRow = ""
	}	
	
	q $LB(userID,userName,title,remark,templateID,templateVersion,needPrint,startPageRow,endPageRow)
	
	
GetTemplateDocID(printDocID, templateID)
	//一个可重复打印模板应该且只能绑定唯一的一个可重复界面模板，
	//要注意一个可重复打印模板同时挂载唯一模板+可重复模板的特殊情况，应该取绑定可重复界面模板的EPRTemplate
	s templateDocID = ""
	s eprTemplateID = ""
	for {
		s eprTemplateID = $O(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_printDocID,eprTemplateID))
		q:(eprTemplateID="")
		
		s objEPRTemplate = ##Class(EPRmeta.EPRTemplate).%OpenId(eprTemplateID)
		continue:(objEPRTemplate = "")
		
		if (objEPRTemplate.BindTemplateID = templateID)
		{
			s templateDocID = eprTemplateID
			q
		}
	}
	q templateDocID
}

ClassMethod MultipleReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MultipleReportListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MultipleReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MultipleReportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator: 	陈文俊
/// CreatDate: 	2009-08-17
/// Desc：		根据Log检索出某一个目录下的所有记录(增加可重复界面模板RowID和Version)
/// Input: 		episodeID ：病人就诊号
/// 			docIDs ：打印模板的DocID(多个DocID之间用^分隔)
/// 			
/// ModifyDate: 2012-05-22
/// ModifyUser:	houj
/// ModifyDesc:	使用临时Global存储Query的返回值
/// Debug:		d ##Class(%ResultSet).RunQuery("web.DHCEPRExt","MultipleReportListPaging","")
Query MultipleReportListPaging(episodeID As %String, docIDs As %String, startRow As %Integer, endRow As %Integer, byDesc As %String = "1") As %Query(ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,HappenDate:%String,HappenTime:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,EPRNum:%Integer,LogRowID:%String,EPRStatus:%String,EPRStatusName:%String,LogDocID:%String,Remark:%String,TemplateID:%String,TemplateVersion:%String,TemplateDocID:%String,EpisodeID:%String")
{
}

ClassMethod MultipleReportListPagingExecute(ByRef qHandle As %Binary, episodeID As %String, docIDs As %String, startRow As %Integer, endRow As %Integer, byDesc As %String = "1") As %Status
{
	s ^CacheTempDHCEPRDebug("web.DHCEPRExt","pageing")=episodeID_","_docIDs_","_startRow_","_endRow
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	//用来排序的临时Global节点	
	s repidtmp = $I(^CacheTemp)
	
	//将多个打印模板DocID中取出相应的Logs的docID及eprnum，
	//将其按日期时间作为索引存放在^CacheTemp中
	s docIDCount = $l(docIDs, "^")
	s count = 0
	for i = 1:1:docIDCount 
	{
		s curDocID = $p(docIDs, "^", i)
		continue:(curDocID = "")
			
		//遍历一个打印模板DocID的数据
		s curEPRNum = 0
		for {
			s curEPRNum = $o(^DHCEPRI.EPRLogsI("IdxMain", " "_episodeID, " "_curDocID, curEPRNum))
			q:(curEPRNum = "")
			
			s eprLogsRowID = $o(^DHCEPRI.EPRLogsI("IdxMain", " "_episodeID, " "_curDocID, curEPRNum, ""))
			q:(eprLogsRowID = "")   //此值为空表明表索引出错，直接退出循环，便于在前端发现问题
			
			s eprLogsInfo = $$GetEPRLogsInfo2(eprLogsRowID)
			continue:(eprLogsInfo = "")
			
			//$LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName)
			s happenDate 	= $List(eprLogsInfo, 1)
			s happenTime 	= $List(eprLogsInfo, 2)
			
			s output = $LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName)
			s ^CacheTemp(repidtmp, happenDate, happenTime, curDocID) = eprLogsInfo
		}
		q:(count > endRow)
	}
		
		
	quit:($d(^CacheTemp(repidtmp))=0) $$$OK
	
	
	s currentPrintDocID = ""
	s currentECRecordID = ""
	s currentTemplateDocID = ""
	//从^CacheTemp时按日期时间索引取出数据
	s date =""
	for {
		s date = $O(^CacheTemp(repidtmp,date),byDesc)
		q:(date="")
		
		s time = ""
		for {
			s time = $O(^CacheTemp(repidtmp,date,time),byDesc)
			q:(time="")
			
			s printDocID = ""
			for {
				s printDocID = $O(^CacheTemp(repidtmp,date,time,printDocID),byDesc)
				q:(printDocID = "")
				
				//分页
				s count = count + 1
				continue:(count < startRow)
				q:(count > endRow)
				
				s eprLogsInfo = $g(^CacheTemp(repidtmp,date,time,printDocID))
				
				if (printDocID '= currentPrintDocID)
				{
					s currentPrintDocID = printDocID
					s currentECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_episodeID, " ML"_currentPrintDocID, "")) 
				}
				continue:(currentECRecordID = "")
				
				s curEPRNum = $List(eprLogsInfo, 7)
				s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", currentECRecordID, " "_curEPRNum, ""))
				continue:(childSub = "")	
				s instanceDataID = currentECRecordID_"||"_childSub
			
				s instanceDataInfo = $$GetInstanceDataInfo2(instanceDataID)
				continue:(instanceDataInfo = "")
			
				s templateID = $List(instanceDataInfo,5)
				s templateDocID = $$GetTemplateDocID2(printDocID, templateID)
				q:(templateDocID = "")  //此值为空表明基础数据错误，直接退出循环，便于在前端发现问题
			
				//$LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName)
				s happenDate 	= $List(eprLogsInfo, 1)
				s happenTime 	= $List(eprLogsInfo, 2)
				s createDate 	= $List(eprLogsInfo, 3)
				s createTime 	= $List(eprLogsInfo, 4)
				s eprStatus  	= $List(eprLogsInfo, 5)
				s eprStatusName = $List(eprLogsInfo, 6)
				//$LB(userID,userName,title,remark,templateID,templateVersion,startPageRow,endPageRow)
				s userID		= $List(instanceDataInfo, 1)
				s userName		= $List(instanceDataInfo, 2)
				s title			= $List(instanceDataInfo, 3)
				s remark		= $List(instanceDataInfo, 4)
				s templateID	= $List(instanceDataInfo, 5)
				s templateVersion = $List(instanceDataInfo, 6)
				s needPrint		= $List(instanceDataInfo, 7)
				s startPageRow	= $List(instanceDataInfo, 8)
				s endPageRow	= $List(instanceDataInfo, 9)
				
				//输出返回值
				//ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,
				//HappenDate:%String,HappenTime:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,
				//EPRNum:%Integer,LogRowID:%String,EPRStatus:%String,EPRStatusName:%String,LogDocID:%String,
				//Remark:%String,TemplateID:%String,TemplateVersion:%String,TemplateDocID:%String"
				s output = $LB(instanceDataID,title,needPrint,startPageRow,endPageRow,happenDate,happenTime,userName,createDate,createTime,curEPRNum,eprLogsRowID,eprStatus,eprStatusName,printDocID,remark,templateID,templateVersion,templateDocID,episodeID)
				s ^CacheTemp(repid, ind) = output
				s ind = ind + 1 
			}
		}
	}	
	kill ^CacheTemp(repidtmp)	

	Quit $$$OK
	
	
	
GetEPRLogsInfo2(eprLogsRowID)	
	s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsRowID)
	q:(eprLogs = "") ""
		
	s happenDate = eprLogs.HappenDate
	s happenTime = eprLogs.HappenTime
	s createDate = eprLogs.CreateDate
	s createTime = eprLogs.CreateTime
	s eprStatus = eprLogs.EPRStatus
	s eprNum = eprLogs.EPRNum
	
	if (happenDate = "")||(happenTime = "")
	{
		s happenDate = $p($H,",",1)
		s happenTime = $p($H,",",2)
	}
	
	s eprStatusName = ""					
	&sql(SELECT top 1 StatusName into :eprStatusName
			FROM EPRmeta.EPRStatus
			WHERE StatusCode = :eprStatus)
	
	s eprLogs = ""	
			
	q $LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName,eprNum)

GetInstanceDataInfo2(instanceDataID)
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataID)
	q:(objInstance = "") ""
	
	Quit:(##class(EPRservice.BLRecInstanceData).CheckRecordAvailable(instanceDataID)="Dumped") ""
	
	s userID = objInstance.CreateUser
	if (userID '= "")
	{	s userName = $P($G(^SSU("SSUSR",userID)),"^",2)}
	else
	{	s userName = ""}
	s title = objInstance.Title
	s remark = objInstance.Remark
	if (remark=$c(0)) s remark=""
	s templateID = objInstance.TemplateID
	s templateVersion = objInstance.TemplateVersion
	
	s objInstance = ""
	
	k SQLCODE
	&sql(SELECT top 1 StartPageNum, StartRowNum,EndPageNum,EndRowNum
		into :startPageNum, :startRowNum, :endPageNum, :endRowNum 		
		FROM EPRinstance.InstancePrintRecord
		WHERE InstanceDataID = :instanceDataID and PrintStatus <> 'UnPrint')
	if (SQLCODE = "0")
	{
		s needPrint = "0"
		s startPageRow = startPageNum_","_startRowNum
		s endPageRow = endPageNum_","_endRowNum
	}
	else
	{
		s needPrint = "1"
		s startPageRow = ""
		s endPageRow = ""
	}	
	
	q $LB(userID,userName,title,remark,templateID,templateVersion,needPrint,startPageRow,endPageRow)
	
	
GetTemplateDocID2(printDocID, templateID)
	//一个可重复打印模板应该且只能绑定唯一的一个可重复界面模板，
	//要注意一个可重复打印模板同时挂载唯一模板+可重复模板的特殊情况，应该取绑定可重复界面模板的EPRTemplate
	s templateDocID = ""
	s eprTemplateID = ""
	for {
		s eprTemplateID = $O(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_printDocID,eprTemplateID))
		q:(eprTemplateID="")
		
		s objEPRTemplate = ##Class(EPRmeta.EPRTemplate).%OpenId(eprTemplateID)
		continue:(objEPRTemplate = "")
		
		if (objEPRTemplate.BindTemplateID = templateID)
		{
			s templateDocID = eprTemplateID
			q
		}
	}
	q templateDocID
}

ClassMethod MultipleReportListPagingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MultipleReportListPagingExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MultipleReportListPagingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MultipleReportListPagingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc:	获取指定打印模板DocID的EPRLogs记录数
/// Input:	AEpisodeID : 就诊指针，APrintDocIDList ：指定PrintDocID，多个PrintDocID间以^号分隔
/// Outpt:	EPRLogs记录总数
/// Debug:	w ##Class(web.DHCEPRExt).GetTotalLogCount("","")
ClassMethod GetTotalLogCount(AEpisodeID As %String, APrintDocIDList As %String) As %Integer
{
	s totalCount = 0
	q:(AEpisodeID="")||(APrintDocIDList="") totalCount
	
	s docIDCount = $L(APrintDocIDList,"^")
	for i = 1:1:docIDCount
	{
		s printDocID = $P(APrintDocIDList, "^", i)
		s count = ##Class(EPRservice.BOEPRLogs).GetMaxEPRNum(AEpisodeID, printDocID)
		s totalCount = totalCount + (+count)
	} 	
	
	q totalCount
}

/// ModifyDate : 2009-05-06
/// ModifyUser : chenwenjun
/// Description: 历次列表的Object控件
ClassMethod CLBar()
{

	//w "<object width=0 height=0 id='config' name='config' classid='clsid:0B596853-D803-3E1C-AF3A-11FE02FF7856' codebase='" _ ##class(web.DHCEPR).GetFormURL() _ "EPRCom.CAB#version=1,0,0,1'>",!	
	w "<object id='config' name='config' width=0 height=0 classid='" _ ##class(web.DHCEPR).GetFormURL("1") _ "WebClient.dll#dhcc.epr.webclient.UCConfig'>",!

	w "<param name='URL' value='" _ ##class(web.DHCEPR).GetServiceURL() _ "'>",!
	w "<param name='FormURL' value='" _ ##class(web.DHCEPR).GetFormURL("1") _ "'>",!
	w "<param name='DBUserPassword' value='" _ ##class(web.DHCEPR).GetUserPassword() _ "'>",!
	w "</object>",! 	
	
	//w "<object width=0 height=0 id='UCPrint' name='UCPrint' classid='clsid:D7C4096E-D351-37A5-9508-85E74197D9C6' codebase='" _ ##class(web.DHCEPR).GetFormURL() _ "EPRCom.CAB#version=1,0,0,1'>",!
	w "<object width=0 height=0 id='UCPrint' name='UCPrint' classid='" _ ##class(web.DHCEPR).GetFormURL("1") _ "WebClient.dll#dhcc.epr.webclient.UCPrint'>",!	
	w "</object>",!
}

ClassMethod GetHostIP() As %String
{
	///gjb add for debug dll without copying files into the server 2007-10-31
	s isDebug=""
	s isDebug=$g(^EPRWebClient("Debug"))
	
	q:(isDebug="1") ..GetClientIP()
	///gjb add for debug dll without copying files into the server 2007-10-31
	
	&sql(SELECT WebServer INTO :webserver 
          FROM websys.Configuration
          WHERE ID = 1)	
	Quit webserver
}

/// gjb add for debug dll without copying files into the server 2007-10-31
ClassMethod GetClientIP() As %String
{
	s clientIP=""
	s clientIP=$ZU(67,15,$j)
	
	;if clientIP'="" {s ^gjbtest("clientIP",$zd($p($h,",",1),3),$zt($p($h,",",2)))=clientIP}
	
	q clientIP
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
	s strURL = "http://" _ strHostIP _ "/dhceprform/"
	Quit strURL
}

ClassMethod GetBGColor() As %String
{
	s strBGColor = ##class(EPRmeta.SysOption).GetOptionValueByName("BGColor")
	Quit strBGColor
}

/// Creator: 	陈文俊
/// CreatDate: 	2009-08-17
/// Desc：		根据Log检索出某一个目录下的所有记录(增加可重复界面模板RowID和Version)
/// Input: 		episodeID ：病人就诊号
/// 			docIDs ：打印模板的DocID(多个DocID之间用^分隔)
/// 			
/// ModifyDate: 2012-05-22
/// ModifyUser:	houj
/// ModifyDesc:	使用临时Global存储Query的返回值
/// Debug:		d ##Class(%ResultSet).RunQuery("web.DHCEPRExt","MultipleReportListPage2","10","709","1","50")
Query MultipleReportListPage2(AEpisodeID As %String, docIDs As %String, startRow As %Integer, endRow As %Integer, byDesc As %String = "1") As %Query(ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,HappenDate:%String,HappenTime:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,EPRNum:%Integer,LogRowID:%String,EPRStatus:%String,EPRStatusName:%String,LogDocID:%String,Remark:%String,TemplateID:%String,TemplateVersion:%String,TemplateDocID:%String,EpisodeID")
{
}

ClassMethod MultipleReportListPage2Execute(ByRef qHandle As %Binary, AEpisodeID As %String, docIDs As %String, startRow As %Integer, endRow As %Integer, byDesc As %String = "1") As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	//用来排序的临时Global节点	
	s repidtmp = $I(^CacheTemp)
	
	
	s admList = ..GetSubsequentEpisode(AEpisodeID)
	s admCount = $L(admList,"^")
	
	for iadm = 1:1:admCount
	{
		s episodeID = $P(admList,"^",iadm)
		
	
	//将多个打印模板DocID中取出相应的Logs的docID及eprnum，
	//将其按日期时间作为索引存放在^CacheTemp中
	s docIDCount = $l(docIDs, "^")
	s count = 0
	for i = 1:1:docIDCount 
	{
		s curDocID = $p(docIDs, "^", i)
		continue:(curDocID = "")
			
		//遍历一个打印模板DocID的数据
		s curEPRNum = 0
		for {
			s curEPRNum = $o(^DHCEPRI.EPRLogsI("IdxMain", " "_episodeID, " "_curDocID, curEPRNum))
			q:(curEPRNum = "")
			
			s eprLogsRowID = $o(^DHCEPRI.EPRLogsI("IdxMain", " "_episodeID, " "_curDocID, curEPRNum, ""))
			q:(eprLogsRowID = "")   //此值为空表明表索引出错，直接退出循环，便于在前端发现问题
			
			s eprLogsInfo = $$GetEPRLogsInfo3(eprLogsRowID)
			continue:(eprLogsInfo = "")
			
			//$LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName)
			s happenDate 	= $List(eprLogsInfo, 1)
			s happenTime 	= $List(eprLogsInfo, 2)
			
			//s output = $LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName)
			s ^CacheTemp(repidtmp, iadm, happenDate, happenTime, curDocID) = eprLogsInfo
		}
		q:(count > endRow)
	}
		
	}
		
	quit:($d(^CacheTemp(repidtmp))=0) $$$OK
	
	
	s iadm = 0
	for {
		s iadm = $O(^CacheTemp(repidtmp, iadm))
		q:(iadm="")
	
	s currentPrintDocID = ""
	s currentECRecordID = ""
	s currentTemplateDocID = ""
	s currentEpisodeID = ""
	//从^CacheTemp时按日期时间索引取出数据
	s date =""
	for {
		s date = $O(^CacheTemp(repidtmp,iadm,date),byDesc)
		q:(date="")
		
		s time = ""
		for {
			s time = $O(^CacheTemp(repidtmp,iadm,date,time),byDesc)
			q:(time="")
			
			s printDocID = ""
			for {
				s printDocID = $O(^CacheTemp(repidtmp,iadm,date,time,printDocID),byDesc)
				q:(printDocID = "")
				
				//分页
				s count = count + 1
				continue:(count < startRow)
				q:(count > endRow)
				
				s eprLogsInfo = $g(^CacheTemp(repidtmp,iadm,date,time,printDocID))
				s episodeID = $List(eprLogsInfo, 8)
				
				//b
				if (printDocID '= currentPrintDocID)||(episodeID '= currentEpisodeID)
				{
					s currentPrintDocID = printDocID
					s currentEpisodeID = episodeID
					s currentECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_episodeID, " ML"_currentPrintDocID, "")) 
				}
				
				continue:(currentECRecordID = "")
				
				s curEPRNum = $List(eprLogsInfo, 7)
				s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", currentECRecordID, " "_curEPRNum, ""))
				continue:(childSub = "")	
				s instanceDataID = currentECRecordID_"||"_childSub
			
				s instanceDataInfo = $$GetInstanceDataInfo3(instanceDataID)
				continue:(instanceDataInfo = "")
			
				s templateID = $List(instanceDataInfo,5)
				s templateDocID = $$GetTemplateDocID3(printDocID, templateID)
				q:(templateDocID = "")  //此值为空表明基础数据错误，直接退出循环，便于在前端发现问题
			
				//$LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName)
				s happenDate 	= $List(eprLogsInfo, 1)
				s happenTime 	= $List(eprLogsInfo, 2)
				s createDate 	= $List(eprLogsInfo, 3)
				s createTime 	= $List(eprLogsInfo, 4)
				s eprStatus  	= $List(eprLogsInfo, 5)
				s eprStatusName = $List(eprLogsInfo, 6)
				
				//$LB(userID,userName,title,remark,templateID,templateVersion,startPageRow,endPageRow)
				s userID		= $List(instanceDataInfo, 1)
				s userName		= $List(instanceDataInfo, 2)
				s title			= $List(instanceDataInfo, 3)
				s remark		= $List(instanceDataInfo, 4)
				s templateID	= $List(instanceDataInfo, 5)
				s templateVersion = $List(instanceDataInfo, 6)
				s needPrint		= $List(instanceDataInfo, 7)
				s startPageRow	= $List(instanceDataInfo, 8)
				s endPageRow	= $List(instanceDataInfo, 9)
				
				//输出返回值
				//ROWSPEC = "ID:%String,Title:%String,NeedPrint:%Boolean,StartPageRow:%String,EndPageRow:%String,
				//HappenDate:%String,HappenTime:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,
				//EPRNum:%Integer,LogRowID:%String,EPRStatus:%String,EPRStatusName:%String,LogDocID:%String,
				//Remark:%String,TemplateID:%String,TemplateVersion:%String,TemplateDocID:%String"
				s output = $LB(instanceDataID,title,needPrint,startPageRow,endPageRow,happenDate,happenTime,userName,createDate,createTime,curEPRNum,eprLogsRowID,eprStatus,eprStatusName,printDocID,remark,templateID,templateVersion,templateDocID,episodeID)
				s ^CacheTemp(repid, ind) = output
				s ind = ind + 1 
			}
		}
	}
	
	}
		
	kill ^CacheTemp(repidtmp)	

	Quit $$$OK
	
	
	
GetEPRLogsInfo3(eprLogsRowID)	
	s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsRowID)
	q:(eprLogs = "") ""
		
	s happenDate = eprLogs.HappenDate
	s happenTime = eprLogs.HappenTime
	s createDate = eprLogs.CreateDate
	s createTime = eprLogs.CreateTime
	s eprStatus = eprLogs.EPRStatus
	s eprNum = eprLogs.EPRNum
	s currentAdm = eprLogs.EpisodeID
	
	if (happenDate = "")||(happenTime = "")
	{
		s happenDate = $p($H,",",1)
		s happenTime = $p($H,",",2)
	}
	
	s eprStatusName = ""					
	&sql(SELECT top 1 StatusName into :eprStatusName
			FROM EPRmeta.EPRStatus
			WHERE StatusCode = :eprStatus)
	
	s eprLogs = ""	
			
	q $LB(happenDate,happenTime,createDate,createTime,eprStatus,eprStatusName,eprNum,currentAdm)

GetInstanceDataInfo3(instanceDataID)
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataID)
	q:(objInstance = "") ""
	
	s userID = objInstance.CreateUser
	if (userID '= "")
	{	s userName = $P($G(^SSU("SSUSR",userID)),"^",2)}
	else
	{	s userName = ""}
	s title = objInstance.Title
	s remark = objInstance.Remark
	if (remark=$c(0)) s remark=""
	s templateID = objInstance.TemplateID
	s templateVersion = objInstance.TemplateVersion
	
	s objInstance = ""
	
	k SQLCODE
	&sql(SELECT top 1 StartPageNum, StartRowNum,EndPageNum,EndRowNum
		into :startPageNum, :startRowNum, :endPageNum, :endRowNum 		
		FROM EPRinstance.InstancePrintRecord
		WHERE InstanceDataID = :instanceDataID and PrintStatus <> 'UnPrint')
	if (SQLCODE = "0")
	{
		s needPrint = "0"
		s startPageRow = startPageNum_","_startRowNum
		s endPageRow = endPageNum_","_endRowNum
	}
	else
	{
		s needPrint = "1"
		s startPageRow = ""
		s endPageRow = ""
	}	
	
	q $LB(userID,userName,title,remark,templateID,templateVersion,needPrint,startPageRow,endPageRow)
	
	
GetTemplateDocID3(printDocID, templateID)
	//一个可重复打印模板应该且只能绑定唯一的一个可重复界面模板，
	//要注意一个可重复打印模板同时挂载唯一模板+可重复模板的特殊情况，应该取绑定可重复界面模板的EPRTemplate
	s templateDocID = ""
	s eprTemplateID = ""
	for {
		s eprTemplateID = $O(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_printDocID,eprTemplateID))
		q:(eprTemplateID="")
		
		s objEPRTemplate = ##Class(EPRmeta.EPRTemplate).%OpenId(eprTemplateID)
		continue:(objEPRTemplate = "")
		
		if (objEPRTemplate.BindTemplateID = templateID)
		{
			s templateDocID = eprTemplateID
			q
		}
	}
	q templateDocID
}

ClassMethod MultipleReportListPage2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MultipleReportListPage2Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MultipleReportListPage2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MultipleReportListPage2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// w ##Class(web.DHCEPRExt).GetSubsequentEpisode("10")
ClassMethod GetSubsequentEpisode(AEpisodeID) As %String
{
	s admType = $P($g(^PAADM(AEpisodeID)),"^",2)
	q:(admType="I") AEpisodeID
	
	s admList = ""
	s patientID = $P($g(^PAADM(AEpisodeID)),"^",1)
	
		s admID = ""
		for {
			s admID = $O(^PAPERdr(patientID,"ADM",admType,admID))
			q:(admID = "")
			
			s status = $P($g(^PAADM(admID)),"^",20)
			continue:(status="C")
			
			if (admList = "")
			{	s admList = admID}
			else
			{	s admList = admList_"^"_admID}
		}
		
	q admList
}

/// Desc:	获取指定打印模板DocID的EPRLogs记录数
/// Input:	AEpisodeID : 就诊指针，APrintDocIDList ：指定PrintDocID，多个PrintDocID间以^号分隔
/// Outpt:	EPRLogs记录总数
/// Debug:	w ##Class(web.DHCEPRExt).GetTotalLogCount2("10","709")
ClassMethod GetTotalLogCount2(AEpisodeID As %String, APrintDocIDList As %String) As %Integer
{
	s totalCount = 0
	q:(AEpisodeID="")||(APrintDocIDList="") totalCount
	
	s admList = ..GetSubsequentEpisode(AEpisodeID)
	s admCount = $L(admList,"^")
	
	for j = 1:1:admCount
	{
		s episodeID = $P(admList,"^",j)
		
		s docIDCount = $L(APrintDocIDList,"^")
		for i = 1:1:docIDCount
		{
			s printDocID = $P(APrintDocIDList, "^", i)
			s count = ##Class(EPRservice.BOEPRLogs).GetMaxEPRNum(episodeID, printDocID)
			s totalCount = totalCount + (+count)
		} 	
	}
	
	q totalCount
}

}
