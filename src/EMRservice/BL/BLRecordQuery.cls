/// Desc:     病历信息查询
/// Creator:   Candy
/// CreateDate:2017-3-9
Class EMRservice.BL.BLRecordQuery Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       查询未签名病历
/// Creator:    Candy
/// CreateDate: 2017-3-9
/// Input:      AStartDate 开始时间 格式 2017-1-1
///            AEndDate   结束时间 格式 2017-3-9
///            AUserID    用户ID
///            所查病历   ADocID 为空查所有病历 (目录展现结构第三层的ID)
/// Output:     就诊ID,病历ID,病历名称,当前状态
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLRecordQuery","GetUnSignRecord","2014-1-1","2017-1-1","105","")
Query GetUnSignRecord(AStartDate As %String, AEndDate As %String, AUserID As %String, ADocID As %String = "") As %Query(ROWSPEC = "argEpisodeID:%String,argInstanceID:%String,argTitle:%String,argCurStatus:%String")
{
}

ClassMethod GetUnSignRecordExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String, ADocID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(AStartDate="")||(AEndDate="")||(AUserID="") $$$OK
	s startDate = $Zdh(AStartDate,3)
	s endDate = $Zdh(AEndDate,3)
	s userLevel = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(AUserID)
	s flag = 0
	s:((userLevel = "Chief")||(userLevel = "ViceChief")) flag = 1
	for admDate = startDate:1:endDate 
	{
		s epiosdeId = ""
		for 
		{	
			s epiosdeId = $o(^PAADMi("PAADM_AdmDate",admDate,epiosdeId))
			q:(epiosdeId = "")
			s docId = $case(ADocID="",1:"",:" "_ADocID)
			for
			{
				if (ADocID = "")
				{
					s docId = $o(^DHCEMRI.EMRLogsI("IdxMain",epiosdeId,docId))
					q:(docId = "")
				}
				s num = ""
				for
				{
					s num = $o(^DHCEMRI.EMRLogsI("IdxMain",epiosdeId,docId,num))
					q:(num = "")
					s rowId = $o(^DHCEMRI.EMRLogsI("IdxMain",epiosdeId,docId,num,""))
					s obj = ##Class(EMRinstance.EMRLogs).%OpenId(rowId)
					s status = ##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(obj.EMRStatus)
					s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",epiosdeId,docId,""))
					s instanceId = ecrecordId_"||"_num
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
					continue:(objInstance = "")						
					if (flag = 0)
					{
						continue:(obj.CreateUserID '= AUserID)
						continue:(obj.EMRStatus '= "finished")
					}
					else
					{
						if ((obj.EMRStatus '= "chiefChecked")&&(obj.EMRStatus '= "viceChiefChecked"))
						{
							continue:($d(^DHCEMRI.MessageListI("InstanceValid"," "_instanceId," CHECK"," "_AUserID))<=0)
						}
					}
					set ^CacheTemp(repid,ind) = $LB(epiosdeId,instanceId,objInstance.Title,status)
					set ind = ind + 1
				}
				q:(ADocID '= "")
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetUnSignRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSignRecordExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSignRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSignRecordExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       查询一段时间内容医生所写病历
/// Creator:    Candy
/// CreateDate: 2017-4-5
/// Input:      AStartDate 开始时间 格式 2017-1-1
///            AEndDate   结束时间 格式 2017-3-9
///            AUserID    用户ID
///            所查病历   ADocID 为空查所有病历 (目录展现结构第三层的ID)
/// Output:     就诊ID,病历ID,病历名称,当前状态
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLRecordQuery","GetRecord","2014-1-1","2017-4-5","","105")
Query GetRecord(AStartDate As %String, AEndDate As %String, ADocID As %String, AUserID As %String) As %Query(ROWSPEC = "")
{
}

ClassMethod GetRecordExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ADocID As %String, AUserID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(AStartDate="")||(AEndDate="")||(AUserID="") $$$OK
	s startDate = $Zdh(AStartDate,3)
	s endDate = $Zdh(AEndDate,3)
	for admDate = startDate:1:endDate 
	{
		s epiosdeId = ""
		for 
		{	
			s epiosdeId = $o(^PAADMi("PAADM_AdmDate",admDate,epiosdeId))
			q:(epiosdeId = "")
			s docId = $case(ADocID="",1:"",:" "_ADocID)
			for
			{
				if (ADocID = "")
				{
					s docId = $o(^DHCEMRI.EMRLogsI("IdxMain",epiosdeId,docId))
					q:(docId = "")
				}
				s num = ""
				for
				{
					s num = $o(^DHCEMRI.EMRLogsI("IdxMain",epiosdeId,docId,num))
					q:(num = "")
					s rowId = $o(^DHCEMRI.EMRLogsI("IdxMain",epiosdeId,docId,num,""))
					s obj = ##Class(EMRinstance.EMRLogs).%OpenId(rowId)
					continue:(obj.CreateUserID '= AUserID)
					continue:(obj.EMRStatus = "deleted")
					s status = ##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(obj.EMRStatus)
					s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",epiosdeId,docId,""))
					s instanceId = ecrecordId_"||"_num
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
					continue:(objInstance = "")						
					set ^CacheTemp(repid,ind) = $LB(epiosdeId,instanceId,objInstance.Title,status)
					set ind = ind + 1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecordExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecordExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc: 获取患者病历的签名状态
/// debug w ##Class(EMRservice.BL.BLRecordQuery).GetRecordSignStatus(112,53,"HDSD00.11.141")
ClassMethod GetRecordSignStatus(AEpisodeID As %String, ADocID As %String, AGlossaryCode As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(ADocID = "") result
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,""))
	q:(ecrecordId = "") result
	s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",""))
	q:(date = "") result
	s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,"")) 
	q:(time = "") result
	s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time,""))
	q:(subId = "") result
	s instanceId =  ecrecordId_"||"_subId
	s obj = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
	q:(obj = "") result
	s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,AGlossaryCode,instanceId)		
	s status = $case(value,"":"0",:"1")
	s text = obj.Title
	s chartItemType = obj.TheECRecord.ChartItemType
	s pluginType = obj.TheECRecord.DocumentType
	s templateId = obj.TemplateID
	s result = 	instanceId_"^"_text_"^"_chartItemType_"^"_pluginType_"^"_templateId_"^"_status
	q result
}

}
