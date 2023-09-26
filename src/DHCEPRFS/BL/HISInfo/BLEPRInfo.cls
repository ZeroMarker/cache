Class DHCEPRFS.BL.HISInfo.BLEPRInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEPRInfo).GetDetailInfoToPrint("512","39966","16952183","1","102","1")
ClassMethod GetDetailInfoToPrint(APrintTemplateDocID As %String, APatientID, AEpisodeID, AUserID, AAttachment, AAttachType = "1") As %String
{
	s detailInfo = ""

	if (AAttachment = "")||(AAttachment = $c(0)||(AAttachment = "0"))
	{
		s needPrint = ..NeedPrint(AEpisodeID,APrintTemplateDocID)
		q:(needPrint '= "1") "" 
		
		s detailInfo = ..GetDetailInfo(APrintTemplateDocID, APatientID, AEpisodeID, AUserID)
	}
	//AAttachment非空时考虑附加生成
	else
	{
		//b "s"
		s needPrint = ..NeedPrint(AEpisodeID,APrintTemplateDocID)
		//if (needPrint '= "1") 
		//{
			//自己不需要打印，检查附加项或者被附加项是否需要打印，比如首程+日程，日程不存在，但是需要检查首程是否存在，若首程存在则打印首程
			
		//} 
		
		s detailInfo = ..GetDetailInfo(APrintTemplateDocID,APatientID, AEpisodeID, AUserID)
			
		//有多个附加组合
		s AttachmentCount = $l(AAttachment,"^")
		for i=1:1:AttachmentCount
		{
			//b "s"
			s AttachmentMRItemID = $p(AAttachment,"^",i)
			s AttachmentMRItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(AttachmentMRItemID)
			s AttachmentType = AttachmentMRItem.Type
			s AttachmentTypeParams = AttachmentMRItem.TypeParams
			
			s AttachmentNeedPrint = ..NeedPrint(AEpisodeID,AttachmentTypeParams)
			//不需要生成任何一项
			continue:((needPrint '= "1") && (AttachmentNeedPrint '= "1"))

			s attachDetailInfo = ..GetDetailInfo(AttachmentTypeParams,APatientID, AEpisodeID, AUserID)
			if (AAttachType = "1")
			{
				if (attachDetailInfo = "")
				{
					s detailInfo = detailInfo
				}
				elseif (detailInfo = "")
				{
					s detailInfo = attachDetailInfo
				}
				else
				{
					s detailInfo = attachDetailInfo_"!"_detailInfo
				}
			}
			elseif (AAttachType = "2")
			{
				if (attachDetailInfo = "")
				{
					s detailInfo = detailInfo
				}
				elseif (detailInfo = "")
				{
					s detailInfo = attachDetailInfo
				}
				else
				{
					s detailInfo = detailInfo_"!"_attachDetailInfo
				}
				
			}
			q
		}	
	}
	
	q detailInfo
}

/// Desc:	07病历文书下的节点打印信息
/// Input：	ACategoryChapterDocID - 模板目录ID
/// 		APatientID - 病人ID	
/// 		AEpisodeID - 就诊号
/// 		AUserID - 操作用户
/// Output: printType^APatientID^AEpisodeID^AUserID^printTemplateID^APrintTemplateDocID^instanceDataIDs
ClassMethod GetDetailInfo(APrintTemplateDocID As %String, APatientID, AEpisodeID, AUserID) As %String
{
	//b "s"
	s (printType, patientID, episodeID,userID) = ""
	s (printTemplateID, printDocID, instanceDataIDs) = ""

	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintTemplateDocID)
	s printTemplateID = objEPRTemplateCategory.BindPrnTemplateID
	q:(printTemplateID = "") ""
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTemplateID)
	q:(objPrintTemplate = "") ""
	s printType = objPrintTemplate.ChartItemType
	
	if (printType = "Multiple")
	{
		s instanceDataIDs = ..GetInstanceData(AEpisodeID, APrintTemplateDocID)
		q:(instanceDataIDs = "") "" 
	}
	q printType_"^"_APatientID_"^"_AEpisodeID_"^"_AUserID_"^"_printTemplateID_"^"_APrintTemplateDocID_"^"_instanceDataIDs
}

ClassMethod GetInstanceData(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s instanceDataIDs = ""
	Set rset = ##class(%ResultSet).%New("web.DHCEPRExt:MultipleReportList")
 	Set sc = rset.Execute(AEpisodeID, APrintTemplateDocID)
 	While (rset.Next()){
	 	s status = rset.Data("EPRStatus")
	 	continue:($zcvt(status,"l") = "created")
	 	
 		if (instanceDataIDs = "")
		{	s instanceDataIDs = rset.Data("ID")}
		else
		{	s instanceDataIDs = instanceDataIDs_","_rset.Data("ID")}
 	}
 	
 	q instanceDataIDs
}

ClassMethod NeedPrint(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintTemplateDocID)
				
	q:(objEPRTemplateCategory = "") "0"
	if (objEPRTemplateCategory.CategoryType = "PhotoScan")
	{
		q "0"	
	}
	q:(objEPRTemplateCategory.CategoryType '= "PrtTemplate") "0"
	q:(..IsSaved(AEpisodeID, APrintTemplateDocID) = "0") "0"
	q "1"
}

/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEPRInfo).IsSaved("5143199","630")
ClassMethod IsSaved(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s isSaved = "0"
	
	q:(AEpisodeID="")||(APrintTemplateDocID="") isSaved
	
	s blankEID = " "_AEpisodeID
	s blankPID = " "_APrintTemplateDocID
	
	s eprNum = "0"
	for {
		s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,blankPID,eprNum))
		q:(eprNum = "")
		
		s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,blankPID,eprNum,""))
		continue:(eprLogsID = "")
		
		s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
		continue:(objEPRLogs = "")
		
		s eprLogsStatus =  objEPRLogs.EPRStatus
		continue:(eprLogsStatus = "created")
		//continue:((eprLogsStatus = "created")||(eprLogsStatus = "unfinished"))
		
		s isSaved = "1"
		quit
	}	
	
	//b
	q isSaved
}

ClassMethod HasValidSign(AEpisodeID As %String) As %String
{
	s isSignValid = "1"
	
	s blankEID = " "_AEpisodeID
	s eprDocID = ""
	for {
		s eprDocID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID))
		q:(eprDocID = "")
		
		s eprNum = "0"
		for {
			//b "s"
			s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID,eprNum))
			q:(eprNum = "")
			
			s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID,eprNum,""))
			continue:(eprLogsID = "")
			
			s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
			continue:(objEPRLogs = "")
			
			s eprLogsStatus =  objEPRLogs.EPRStatus
			continue:(eprLogsStatus = "created")
			//continue:((eprLogsStatus = "created")||(eprLogsStatus = "unfinished"))
			
			s isSignValid = ..GetSignStatus(AEpisodeID, objEPRLogs.EPRDocID, eprNum)
			s:(isSignValid'="1") isSignValid = "0"
			
			q:(isSignValid="0")
		}
		
		q:(isSignValid="0")
	}
	
	q isSignValid
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

/// Desc:	获取取未签名的病历列表
/// Debug:	d ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLEPRInfo","GetUnvalidSignRecord","8749171","125")
Query GetUnvalidSignRecord(AEpisodeID As %String, ACTLocID As %String) As %Query(ROWSPEC = "PrintDocID:%String,EPRNum:%String,EPRLogsID:%String,RecordName:%String,RecordStatus:%String,SignStatus:%String,PrintType:%String,HappenDate:%String,HappenTime:%String,RecordTitle:%String")
{
}

ClassMethod GetUnvalidSignRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnvalidSignRecordExecute ]
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

ClassMethod GetUnvalidSignRecordExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ACTLocID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	//检查科室是否上线CA签名，若没有上线，直接返回
	s retCA = ##Class(CA.DigitalSignatureService).IsCACTLoc(ACTLocID)
	if (retCA = "0")
	{
		Quit $$$OK
	}
	
	s blankEID = " "_AEpisodeID
	s eprDocID = ""
	for {
		s eprDocID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID))
		q:(eprDocID = "")
		
		s isRecordInfoInited = "0", PrintType = "",RecordName= "", ECRecordID = ""
		
		s eprNum = "0"
		for {
			s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID,eprNum))
			q:(eprNum = "")
			
			s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID,eprNum,""))
			continue:(eprLogsID = "")
			
			s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
			continue:(objEPRLogs = "")
			
			s eprLogsStatus =  objEPRLogs.EPRStatus
			continue:(eprLogsStatus = "created")
			//continue:((eprLogsStatus = "created")||(eprLogsStatus = "unfinished"))
			
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
				s PrintType = $P(recordInfo, "^", 1)
			}
			s PrintDocID = objEPRLogs.EPRDocID
			s EPRNum = objEPRLogs.EPRNum
			s EPRLogsID = objEPRLogs.%Id()
			s RecordStatus = objEPRLogs.EPRStatus
			s RecordStatus = ##Class(EPRmeta.EPRStatus).GetStatusName(RecordStatus)
			
			s HappenDate = $zd(objEPRLogs.HappenDate,"3")
			s HappenTime = $zt(objEPRLogs.HappenTime)
			s RecordTitle = $$GetMultiInstanceInfo(AEpisodeID, PrintDocID, EPRNum)
			s data = $lb(PrintDocID,EPRNum,EPRLogsID,RecordName,RecordStatus,SignStatus,PrintType,HappenDate,HappenTime,RecordTitle)
			s ^CacheTemp(repid,ind)=data
			s ind=ind+1 
		}
	}
	
	//必填病历项目校验
	s unfinishRecord = ##class(EPRservice.BLL.BLRecordFinishQC).GetUnfinishRecord(AEpisodeID)
	s unfinishCount = $LL(unfinishRecord)
	for j = 1:1:unfinishCount
	{
		s PrintDocID = "",EPRNum = "",EPRLogsID = "",RecordStatus="未填写",SignStatus="未签名",HappenDate="",HappenTime="",RecordTitle=""
		s RecordName = $lg(unfinishRecord,j)		
		s data = $lb(PrintDocID,EPRNum,EPRLogsID,RecordName,RecordStatus,SignStatus,PrintType,HappenDate,HappenTime,RecordTitle)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	
	s hospitalFlag = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "HYDYFY")
	{
	
		// 要求入院证明书必填
		// 要求入院证明书必填
		s motherAdmDR = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetMotherAdmDR(AEpisodeID)
		if (motherAdmDR = "")
		{
			s hasSaved = "0", eprDocID = " 744", eprNum = "1"
			s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEID,eprDocID,eprNum,""))
			if (eprLogsID '= "")
			{
				s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
				if (objEPRLogs '= "")&&(objEPRLogs.EPRStatus '= "created")
				{
					s hasSaved = "1"
				}
			}
			if (hasSaved = "0")
			{
				s PrintDocID = "744",EPRNum = "1",EPRLogsID = "",RecordStatus="未填写",SignStatus="未签名",HappenDate="",HappenTime="",RecordTitle=""
				s recordInfo = $$GetRecordInfo(PrintDocID)
				s RecordName = $P(recordInfo, "^", 1)
				s PrintType = $P(recordInfo, "^", 1)
			
				s data = $lb(PrintDocID,EPRNum,EPRLogsID,RecordName,RecordStatus,SignStatus,PrintType,HappenDate,HappenTime,RecordTitle)
				s ^CacheTemp(repid,ind)=data
				s ind=ind+1 
			}
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
	
	q objInstance.Title
}

ClassMethod GetUnvalidSignRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnvalidSignRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	编目首页是否完成
/// Input:	AEpisodeID : 就诊rowid
/// 	Return:	1 完成，0 未完成
/// Debug：	w ##Class(DHCEPRFS.BL.HISInfo.BLEPRInfo).IsCodingFPFinished("10080")
ClassMethod IsCodingFPFinished(AEpisodeID As %String) As %String
{
	s fpDocID = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("EPRCodingFPDocID")
	q:(fpDocID = "")||(fpDocID = "NULL") "0"
	
	s id = $O(^DHCEPRI.EPRLogsI("IdxMain", " "_AEpisodeID, " "_fpDocID, "1",""))
	q:(id = "") "0"
	
	s obj = ##Class(EPRinstance.EPRLogs).%OpenId(id)
	q:(obj = "") "0"
	q:(obj.EPRStatus = "created") "0"
	q:(obj.EPRStatus = "unfinished") "0"
	
	q "1"
}

/// Desc:	临床首页是否完成质控医师签名
/// Input:	AEpisodeID : 就诊rowid
/// 	Return:	1 完成，0 未完成
/// Debug：	w ##Class(DHCEPRFS.BL.HISInfo.BLEPRInfo).IsClinicFPFQCDocChecked("10080")
ClassMethod IsClinicFPFQCDocChecked(AEpisodeID As %String) As %String
{
	s hasChecked = 0
	
	s fpDocID = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("EPRClinicFPDocID")
	q:(fpDocID = "")||(fpDocID = "NULL") hasChecked
	
	s id = $O(^DHCEPRI.EPRLogsI("IdxMain", " "_AEpisodeID, " "_fpDocID, "1",""))
	q:(id = "") hasChecked
	
	s objLog = ##Class(EPRinstance.EPRLogs).%OpenId(id)
	q:(objLog = "") hasChecked
	
	s log = "", AAction = "QCDocCheck" 
	s count = objLog.Log.Count()
	for i = count:-1:1 
	{
		s log = objLog.Log.GetAt(i)
		continue:(log = "")
		
		q:($f(log.Action,"refresh") > 0)
		
		if ($zcvt(log.Action,"U")=$zcvt(AAction,"U")) 
		{
			s hasChecked = 1
			quit
		}	
	}
	
	q hasChecked
}

}
