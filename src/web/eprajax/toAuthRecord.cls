Class web.eprajax.toAuthRecord Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s userID = $Get(%request.Data("UserID",1),"-1")
	s ssGroupID = $Get(%request.Data("SSGroupID",1),"-1")
	s ctLocID = $Get(%request.Data("CTLocID",1),"-1")
	s action = $Get(%request.Data("CurAction",1),"-1")
	
	d ..GetRecord(episodeID,userID,ssGroupID,ctLocID,action)
	
	Quit $$$OK
}

/// Debug: d ##class(DHCEPRFS.web.eprajax.EPRRecordStatus).GetRecord("201764")
ClassMethod GetRecord(AEpisodeID As %String, AUserID, ASSGroupID, ACTLocID, AAction)
{
	w "["
	
	s count=0
	s rset = ##class(%ResultSet).%New("web.eprajax.toAuthRecord:GetToSignRecord")
 	s sc = rset.Execute(AEpisodeID,AUserID, ASSGroupID, ACTLocID, AAction)
 	While rset.Next()
 	{
	 	s count = count + 1
		if (count > 1) 
	 	{	w ","}
	 	
	 	//PrintDocID:
	 	//EPRNum:
	 	//EPRLogsID:
	 	//RecordName:
	 	//RecordStatus:
	 	//SignStatus:
	 	//PrintType:
	 	//HappenDate:
	 	//HappenTime:
	 	//RecordTitle:
	 	//InstanceDataID:
	 	
	 	w "{OrderID:'"_count_"',"
	 	w "PrintDocID:'"_rset.Data("PrintDocID")_"',"
	 	w "PrintType:'"_rset.Data("PrintType")_"',"
	 	w "EPRNum:'"_rset.Data("EPRNum")_"',"
		w "RecordName:'"_rset.Data("RecordName")_"',"
	 	w "RecordTitle:'"_rset.Data("RecordTitle")_"',"
	 	w "RecordStatus:'"_rset.Data("RecordStatus")_"',"
	 	w "SignStatus:'"_rset.Data("SignStatus")_"',"
	 	w "HappenDate:'"_rset.Data("HappenDate")_"',"
	 	w "HappenTime:'"_rset.Data("HappenTime")_"',"
	 	w "InstanceDataID:'"_rset.Data("InstanceDataID")_"',"
	 	w "HasPrivilege:'"_rset.Data("HasPrivilege")_"'}"
	}

	w "]"
}

/// Desc:	获取取未签名的病历列表
/// Debug:	d ##Class(%ResultSet).RunQuery("web.eprajax.toAuthRecord","GetToSignRecord","201764")
Query GetToSignRecord(AEpisodeID As %String, AUserID, ASSGroupID, ACTLocID, AAction) As %Query(ROWSPEC = "PrintDocID:%String,EPRNum:%String,EPRLogsID:%String,RecordName:%String,RecordStatus:%String,SignStatus:%String,PrintType:%String,HappenDate:%String,HappenTime:%String,RecordTitle:%String,InstanceDataID:%String,HasPrivilege:%String")
{
}

ClassMethod GetToSignRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetToSignRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetToSignRecordExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AUserID, ASSGroupID, ACTLocID, AAction) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	
	s blankEID = " "_AEpisodeID
	s eprDocID = ""
	for {
		s eprDocID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID))
		q:(eprDocID = "")
		
		s isRecordInfoInited = "0", PrintType = "",RecordName= "", ECRecordID = "", HasPrivilege = "0"
		
		s eprNum = "0"
		for {
			s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID,eprNum))
			q:(eprNum = "")
			
			s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID,eprNum,""))
			continue:(eprLogsID = "")
			
			s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
			continue:(objEPRLogs = "")
			
			s eprLogsStatus =  objEPRLogs.EPRStatus
			continue:(eprLogsStatus '= "finished")
			
			s isSignValid = ..GetSignStatus(AEpisodeID, objEPRLogs.EPRDocID, eprNum)
			continue:(isSignValid = "1")
			if (isSignValid = "0")
			{	s SignStatus = "未签名"}
			elseif(isSignValid = "-1")
			{s SignStatus = "签名失效"}
			
			if (isRecordInfoInited = "0")
			{
				s recordInfo = $$GetRecordInfo(objEPRLogs.EPRDocID)
				s RecordName = $P(recordInfo, "^", 1)
				s PrintType = $P(recordInfo, "^", 2)
			}
			s PrintDocID = objEPRLogs.EPRDocID
			s EPRNum = objEPRLogs.EPRNum
			s EPRLogsID = objEPRLogs.%Id()
			s RecordStatus = objEPRLogs.EPRStatus
			
			s HappenDate = $zd(objEPRLogs.HappenDate,"3")
			s HappenTime = $zt(objEPRLogs.HappenTime)
			s multiInfo = $$GetMultiInstanceInfo(AEpisodeID, PrintDocID, EPRNum)
			s RecordTitle = $p(multiInfo,"^",2)
			s InstanceDataID = $p(multiInfo,"^",1)
			
			s curTemplateID = ""
			s powerArr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(AUserID, AEpisodeID, patientID, ACTLocID, curTemplateID, ASSGroupID, "", PrintDocID, EPRNum)
			s HasPrivilege = powerArr.GetAt("canCommit")
			
			s data = $lb(PrintDocID,EPRNum,EPRLogsID,RecordName,RecordStatus,SignStatus,PrintType,HappenDate,HappenTime,RecordTitle,InstanceDataID,HasPrivilege)
			s ^CacheTemp(repid,ind)=data
			s ind=ind+1 
		}
	}
	
	
	Quit $$$OK
	
GetRecordInfo(PrintDocID)
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(PrintDocID)
	s printTemplateID = objEPRTemplateCategory.BindPrnTemplateID
	q:(printTemplateID = "") ""
	s cateName = objEPRTemplateCategory.CategoryName
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTemplateID)
	q:(objPrintTemplate = "") ""
	s printType = objPrintTemplate.ChartItemType
	
	q cateName_"^"_printType
	
GetMultiInstanceInfo(AEpisodeID, PrintDocID, EPRNum)
	//是否存在可重复病历数据
	s ecRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_AEpisodeID, " ML"_PrintDocID, ""))
	q:(ecRecordID = "") "" 
	
	s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, " "_EPRNum, ""))
	q:(childSub = "") ""	
	
	s instanceDataID = ecRecordID_"||"_childSub
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceDataID)
	q:(objInstance="") ""
	
	q instanceDataID_"^"_objInstance.Title
}

ClassMethod GetToSignRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetToSignRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取数字签名状态
/// Return：1 签名有效
/// 		0 未签名
/// 		-1 签名失效 
ClassMethod GetSignStatus(episodeID, printDocID, eprNum)
{
	s logID=##Class(EPRinstance.DigitalSignLog).GetLastSign(episodeID, printDocID, eprNum)
    q:(""=logID) "0" 
    
    s log=##Class(EPRinstance.DigitalSignLog).%OpenId(logID)
    q:(log="") "-1"
    q:(log.IsValid=0) "-1"
   
    s sign=##Class(CA.DigitalSignature).%OpenId(log.SignID)
    q:(sign="") "-1"
    
    q "1"
}

}
