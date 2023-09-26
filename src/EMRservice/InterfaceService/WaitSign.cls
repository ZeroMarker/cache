Class EMRservice.InterfaceService.WaitSign Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取该用户为最后修改者的未签名病历，及发消息给该userID请求签名的病历
/// Creator:    Donglulu
/// CreateDate: 2019-1-30
/// Input:      argUserID :当前医生用户ID
/// Output:     EpisodeID:就诊号,PapmiNO:登记号,PapmiName:姓名,DoucumnetDesc:病历名称,InstanceID:实例ID,SignUserName:病历创建者,EMRStatus:病历状态,DocID:DocID
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.WaitSign","GetEMRWaitSign","10209","HISUI")
Query GetEMRWaitSign(argUserID As %String, AInterface As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNO:%String,PapmiName:%String,DoucumnetDesc:%String,InstanceID:%String,SignUserName:%String,EMRStatus:%String,DocID:%String,url:%String,documentType:%String,chartItemType:%String,templateId:%String,isLeadframe:%String,characteristic:%String,isMutex:%String,categoryId:%String,patientID:%String")
{
}

ClassMethod GetEMRWaitSignExecute(ByRef qHandle As %Binary, argUserID As %String, AInterface As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Quit:(argUserID="") $$$OK
	
	//Quit:(argUserCode="") $$$OK
	//Set argUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(argUserCode,"U"),0))
	
	s logID = ""
	for
	{
		s logID = $O(^DHCEMRI.InstanceLogI("IdxOperUserParRefDateTimeFinal",argUserID,logID))
		q:(logID = "")
		
		s date = $O(^DHCEMRI.InstanceLogI("IdxOperUserParRefDateTimeFinal",argUserID,logID,""),-1)
		q:(date = "")
		s time = $O(^DHCEMRI.InstanceLogI("IdxOperUserParRefDateTimeFinal",argUserID,logID,date,""),-1)
		q:(time = "")
		
		s instanceLogID = $O(^DHCEMRI.InstanceLogI("IdxOperUserParRefDateTimeFinal",argUserID,logID,date,time," FINISHED",""))
		continue:(instanceLogID = "")
		
		Set objEMRLog=##Class(EMRinstance.EMRLogs).%OpenId(logID)
		
		Set ECRecordID=""
		Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",objEMRLog.RealEpisodeID,objEMRLog.RealEMRDocID,ECRecordID))
		continue:(ECRecordID="")
	
		Set InstanceID=""
		Set InstanceID=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID," "_objEMRLog.EMRNum,InstanceID))
		continue:(InstanceID="")

		Set EpisodeID=objEMRLog.RealEpisodeID
		Set papmiDr=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(objEMRLog.RealEpisodeID)
		Set PapmiNO=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDr)
		Set PapmiName=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(papmiDr)

		s SignUserName = ""
		Set SingUserID=objEMRLog.CreateUserID
		I SingUserID'="" Set SignUserName=$p($g(^SSU("SSUSR",SingUserID)),"^",2)
		Set EMRStatus=##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(objEMRLog.EMRStatus)

		Set InstanceID=ECRecordID_"||"_InstanceID
		Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		continue:(objInstance = "")
		
		s epsiodeId = objInstance.TheECRecord.RealEpisodeID
		s docId = objInstance.TheECRecord.RealChartItemID
		s num = objInstance.ListNo
		s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
		Set langid=20
		if ($d(%session)){
			set langid=+$g(%session.Data("LOGON.LANGID"))
		}
		s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",title,langid)
		s templateId = objInstance.RealTemplateID
		s summary = objInstance.Memo
		s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		continue:(objCategoryDoc = "")
		s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
		continue:(objChapter = "")
		s categoryId = objChapter.ParentCategoryID
		s isLeadframe = objCategoryDoc.IsLeadframe
		s isMutex = objChapter.IsMutex
		s characteristic = objInstance.TheECRecord.DocumentCharacteristic
		s chartItemType = objInstance.TheECRecord.ChartItemType
		s documentType = objInstance.TheECRecord.DocumentType
		
		if (AInterface ="HISUI"){
			s url = "emr.interface.ip.edit.csp?EpisodeID="_EpisodeID_"&DocID="_docId_"&InstanceID="_InstanceID
		}
		else
		{
			s url = "emr.record.interface.csp?EpisodeID="_EpisodeID_"&DocID="_docId_"&InstanceID="_InstanceID
		}
		s patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
		s data = $LB(EpisodeID,PapmiNO,PapmiName,title,InstanceID,SignUserName,EMRStatus,docId,url,documentType,chartItemType,templateId,isLeadframe,characteristic,isMutex,categoryId,patientID)
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 
				
	}
	
	s instance = ""
	for
	{
		s instance = $O(^DHCEMRI.MessageListI("IdxTypeReceiverInstanceIDStatus"," CHECK"," "_argUserID,instance))
		q:(instance = "")
		continue:($O(^DHCEMRI.MessageListI("IdxTypeReceiverInstanceIDStatus"," CHECK"," "_argUserID,instance," 1",""))="")
		s InstanceID = $tr(instance," ","")
		
		Set ECRecordID = $p(InstanceID,"||",1)
		continue:(ECRecordID="")
		
		Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)

		Set EpisodeID=objEcrecord.RealEpisodeID
		Set papmiDr=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
		Set PapmiNO=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDr)
		Set PapmiName=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(papmiDr)
		
        Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		continue:(objInstance = "")

		s SignUserName = ""
		Set SingUserID=objInstance.CreateUser
		I SingUserID'="" Set SignUserName=$p($g(^SSU("SSUSR",SingUserID)),"^",2)
		
		s epsiodeId = objInstance.TheECRecord.RealEpisodeID
		s docId = objInstance.TheECRecord.RealChartItemID
		s num = objInstance.ListNo
		s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
		Set langid=20
		if ($d(%session)){
			set langid=+$g(%session.Data("LOGON.LANGID"))
		}
		s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",title,langid)
		s templateId = objInstance.RealTemplateID
		s summary = objInstance.Memo
		s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		continue:(objCategoryDoc = "")
		s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
		continue:(objChapter = "")
		s categoryId = objChapter.ParentCategoryID
		s isLeadframe = objCategoryDoc.IsLeadframe
		s isMutex = objChapter.IsMutex
		s characteristic = objInstance.TheECRecord.DocumentCharacteristic
		s chartItemType = objInstance.TheECRecord.ChartItemType
		s documentType = objInstance.TheECRecord.DocumentType
		
		s status = ##Class(EMRservice.BL.BLEMRLogs).GetEMRStatus(EpisodeID,docId,objInstance.ListNo) 
		continue:(status = "deleted")
		Set EMRStatus=##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(status)
		
		if (AInterface ="HISUI"){
			s url = "emr.interface.ip.edit.csp?EpisodeID="_EpisodeID_"&DocID="_docId_"&InstanceID="_InstanceID
		}
		else
		{
			s url = "emr.record.interface.csp?EpisodeID="_EpisodeID_"&DocID="_docId_"&InstanceID="_InstanceID
		}
		s patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
		s data = $LB(EpisodeID,PapmiNO,PapmiName,title,InstanceID,SignUserName,EMRStatus,docId,url,documentType,chartItemType,templateId,isLeadframe,characteristic,isMutex,categoryId,patientID)
		
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 
	}
	
	Quit $$$OK
}

ClassMethod GetEMRWaitSignClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRWaitSignExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEMRWaitSignFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRWaitSignExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       取该用户为最后修改者的未签名病历及发消息给该userID请求签名的病历总数量
/// Creator:    Donglulu
/// CreateDate: 2019-1-30
/// Input:      argUserID :当前医生用户ID
/// OutPut:     病历数 
/// w ##Class(EMRservice.InterfaceService.WaitSign).GetEMRWaitSignCount(4133)
ClassMethod GetEMRWaitSignCount(argUserID As %String) As %String
{
	s count = 0
	q:(argUserID = "") count
	
	s logID = ""
	for
	{
		s logID = $O(^DHCEMRI.InstanceLogI("IdxOperUserParRefDateTimeFinal",argUserID,logID))
		q:(logID = "")
		
		s date = $O(^DHCEMRI.InstanceLogI("IdxOperUserParRefDateTimeFinal",argUserID,logID,""),-1)
		q:(date = "")
		s time = $O(^DHCEMRI.InstanceLogI("IdxOperUserParRefDateTimeFinal",argUserID,logID,date,""),-1)
		q:(time = "")
		
		s instanceLogID = $O(^DHCEMRI.InstanceLogI("IdxOperUserParRefDateTimeFinal",argUserID,logID,date,time," FINISHED",""))
		continue:(instanceLogID = "")
		
		Set objEMRLog=##Class(EMRinstance.EMRLogs).%OpenId(logID)
		continue:(objEMRLog.EMRDocID = "")
		Set ECRecordID=""
		Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",objEMRLog.RealEpisodeID,objEMRLog.RealEMRDocID,ECRecordID))
		continue:(ECRecordID="")
	
		Set InstanceID=""
		Set InstanceID=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID," "_objEMRLog.EMRNum,InstanceID))
		continue:(InstanceID="")

		Set EpisodeID=objEMRLog.RealEpisodeID
		Set papmiDr=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(objEMRLog.RealEpisodeID)
		Set PapmiNO=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDr)
		Set PapmiName=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(papmiDr)

		s SignUserName = ""
		Set SingUserID=objEMRLog.CreateUserID
		I SingUserID'="" Set SignUserName=$p($g(^SSU("SSUSR",SingUserID)),"^",2)
		Set EMRStatus=##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(objEMRLog.EMRStatus)

		Set InstanceID=ECRecordID_"||"_InstanceID
		Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		continue:(objInstance = "")
		
		s epsiodeId = objInstance.TheECRecord.RealEpisodeID
		s docId = objInstance.TheECRecord.RealChartItemID
		s num = objInstance.ListNo
		s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
		Set langid=20
		if ($d(%session)){
			set langid=+$g(%session.Data("LOGON.LANGID"))
		}
		s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",title,langid)
		s templateId = objInstance.RealTemplateID
		s summary = objInstance.Memo
		s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		continue:(objCategoryDoc = "")
		s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
		continue:(objChapter = "")
		s count = count + 1	
				
	}
	
	s instance = ""
	for
	{
		s instance = $O(^DHCEMRI.MessageListI("IdxTypeReceiverInstanceIDStatus"," CHECK"," "_argUserID,instance))
		q:(instance = "")
		continue:($O(^DHCEMRI.MessageListI("IdxTypeReceiverInstanceIDStatus"," CHECK"," "_argUserID,instance," 1",""))="")
		s InstanceID = $tr(instance," ","")
		
		Set ECRecordID = $p(InstanceID,"||",1)
		continue:(ECRecordID="")
		
		Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)

		Set EpisodeID=objEcrecord.RealEpisodeID
		Set papmiDr=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
		Set PapmiNO=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDr)
		Set PapmiName=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(papmiDr)
		
        Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		continue:(objInstance = "")

		s SignUserName = ""
		Set SingUserID=objInstance.CreateUser
		I SingUserID'="" Set SignUserName=$p($g(^SSU("SSUSR",SingUserID)),"^",2)
		
		s epsiodeId = objInstance.TheECRecord.RealEpisodeID
		s docId = objInstance.TheECRecord.RealChartItemID
		s num = objInstance.ListNo
		s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
		Set langid=20
		if ($d(%session)){
			set langid=+$g(%session.Data("LOGON.LANGID"))
		}
		s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",title,langid)
		s templateId = objInstance.RealTemplateID
		s summary = objInstance.Memo
		s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		continue:(objCategoryDoc = "")
		s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
		continue:(objChapter = "")
		s categoryId = objChapter.ParentCategoryID
		s isLeadframe = objCategoryDoc.IsLeadframe
		s isMutex = objChapter.IsMutex
		s characteristic = objInstance.TheECRecord.DocumentCharacteristic
		s chartItemType = objInstance.TheECRecord.ChartItemType
		s documentType = objInstance.TheECRecord.DocumentType
		
		s status = ##Class(EMRservice.BL.BLEMRLogs).GetEMRStatus(EpisodeID,docId,objInstance.ListNo) 
		continue:(status = "deleted")
		s count = count + 1	
	}
	q count
}

/// Creator:	DongLulu
/// CreatDate:  2020-5-28
/// Desc:		获取患者的待签数据
/// Input：		AEpisodeID 就诊号
/// Return：	
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.WaitSign","GetWaitSignByEpisodeID","41")
Query GetWaitSignByEpisodeID(AEpisodeID As %String, AInterface As %String = "") As %Query(ROWSPEC = "AEpisodeID:%String,TemplateName:%String,Title:%String,HappenDate:%String,HappenTime:%String,Status:%String,FinishSignInfo:%String,recordURL:%String")
{
}

ClassMethod GetWaitSignByEpisodeIDExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AInterface As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID= "") $$$OK
	s ChartItemID=""
	for
	{
		s ChartItemID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ChartItemID))
		q:(ChartItemID="")
		s EcrecordID=""
		for
		{
			s EcrecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ChartItemID,EcrecordID))
			q:(EcrecordID="")
			s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(EcrecordID)
			q:(objECRecord="")
			
			s count = objECRecord.InstanceCount
			for i=1:1:count
			{
				s objInstance = objECRecord.Instances.GetAt(i)
				continue:(objInstance.Status'="Save")
				s InstanceID = EcrecordID_"||"_i
				s FinishSignInfo = ##class(EMRservice.BL.BLTemplateSign).GetDocumentFinishSign(InstanceID)
				continue:(FinishSignInfo="1")
				s TemplateID=objInstance.RealTemplateID
				s objTemplate=##Class(EMRmeta.Template).%OpenId(TemplateID)
				s TemplateName=objTemplate.Name
				s Title=objInstance.Title
				s HappenDate=objInstance.HappenDate
				s HappenTime=objInstance.HappenTime
				s:(HappenDate'="") HappenDate=$zd(HappenDate,3)
				s:(HappenTime'="") HappenTime=$zt(HappenTime,1)
				s Status=objInstance.Status
				s:(Status="Save") Status="已保存"
				continue:(Status="UnSave")
				if (AInterface ="HISUI"){
					s url = "../csp/emr.interface.ip.main.csp?EpisodeID="_AEpisodeID_"&DocID="_$e(ChartItemID,2,*)_"&InstanceID="_InstanceID
				}
				else
				{
					s url = "../csp/emr.record.interface.csp?EpisodeID="_AEpisodeID_"&DocID="_$e(ChartItemID,2,*)_"&InstanceID="_InstanceID
				}
				s Data =$lb(AEpisodeID,TemplateName,Title,HappenDate,HappenTime,Status,FinishSignInfo,url)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1
				

			}
		}
			
	}
	Quit $$$OK
}

ClassMethod GetWaitSignByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWaitSignByEpisodeIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetWaitSignByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWaitSignByEpisodeIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:       获取该次就诊送病案室时有没有触犯质控条目和待签数据
/// Creator:    Donglulu
/// CreateDate: 2020-7-29
/// Input:      argEpisodeID :就诊号
/// OutPut:     1 有 /0 无
/// w ##Class(EMRservice.InterfaceService.WaitSign).HasQualityOrWaitSignData(4133)
ClassMethod HasQualityOrWaitSignData(argEpisodeID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "") result
	
	//有没有触犯质控条目
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.Interface.GetQualityConfirmRecord:GetAdmQualityConfirmRecord")
	d ds.Execute(argEpisodeID)
	While (ds.Next())
	{
		s result = "1"
		q:(result = "1")
	}
	
	//有没有待签数据
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.InterfaceService.WaitSign:GetWaitSignByEpisodeID")
	d ds.Execute(argEpisodeID)
	While (ds.Next())
	{
		s result = "1"
		q:(result = "1")
	}
	q result
}

}
