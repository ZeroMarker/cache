Class EMRservice.InterfaceService.ChangeRecord Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:   根据DocID删除对应就诊病历
/// Creator:Donglulu
/// Input:	AEpisodeID : 就诊rowid
/// 		ADocID : 病历展现结构ID
/// 		AUserID : 操作用户
/// 		AUserLocID : 操作用户科室
/// 		AIPAddress : 操作IP地址
/// 		AProductSourceType : 操作产品来源代码（医生站：Oeord）
/// Return:	1 成功，0 失败
/// w ##class(EMRservice.InterfaceService.ChangeRecord).DeleteRecordByDocID("52","66","10209","95","192.168.18.6","Oeord")
ClassMethod DeleteRecordByDocID(AEpisodeID As %String, ADocID As %String, AUserID As %String, AUserLocID As %String, AIPAddress As %String, AProductSourceType As %String) As %String
{
	
	s result = "0"
	q:(AEpisodeID = "")||(ADocID = "")||(AUserID = "")||(AUserLocID = "")||(AIPAddress = "")||(AProductSourceType = "") result
	s:(AProductSourceType = "") AProductSourceType = "EMR"
	
	s instanceID = ##Class(EMRservice.InterfaceService.ChangeRecord).GetInstanceIDByDocID(ADocID,AEpisodeID,"Save")
	q:(instanceID = "") result
	Tstart
	s docStatus = ##Class(EMRservice.BL.BLInstanceData).DeleteDocument(instanceID,AUserID)
	if (docStatus '= "1")
	{
		Trollback
	}
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog("delete",instanceID,AUserID,AUserID,AIPAddress,"",AUserLocID,AProductSourceType)
	if ($p(logStatus,"^",1) = "0")
	{
		Trollback
	}
	TCOMMIT
	s result = "1"
	d ##class(EMRservice.BL.BLInstanceLinkProduct).DeleteData(instanceID,AUserID)
	q result
}

/// Desc:		根据DocId取instanceid
/// Creator:	Donglulu
/// CreateDate: 2020-6-15
/// Input: 		ADocId 目录展现结构ID
/// 			AEpisodeId 就诊号
/// 			AStauts 病历状态
/// 			OutPut instanceid
/// Debug：     w ##Class(EMRservice.InterfaceService.ChangeRecord).GetInstanceIDByDocID(66,52,"Save")
ClassMethod GetInstanceIDByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String) As %String
{
	s result = ""
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "") result
	s docId = ADocId
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,docId,""))
	q:(ecrecordId = "") result
	
	s objEcrecod =  ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecod = "") result
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time))	
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time,subId))			
				q:(subId = "")
 				s result = ecrecordId_"||"_subId
 				q:(result '= "")		
			}
		}
	}
	q result
}

}
