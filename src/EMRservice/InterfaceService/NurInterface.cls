Class EMRservice.InterfaceService.NurInterface Extends %RegisteredObject
{

/// lifengbo
/// 20220914
/// 提供给护理组，输出患者未打印病历信息列表。数据应用： 在护士结算时提示。
/// Input: 就诊号
/// Output: 当前就诊，未打印病历信息JSON：InstanceId实例ID Title文档标题 HappenDate 记录日期 HappenTime 记录时间
/// w ##class(EMRservice.InterfaceService.NurInterface).GetUnPrintInstanceJSON()
ClassMethod GetUnPrintInstanceJSON(AEpisodeID As %String) As %String
{
 s resultJson={}
 q:(AEpisodeID="") resultJson.%ToJSON()
 
 s JsonData=[]
 s count=0
 s happenDate=""
 for
 {
	 s happenDate = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",happenDate))
	 q:(happenDate="")
	 s happenTime=""
	 for
	 {
		s happenTime = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",happenDate,happenTime))
	 	q:(happenTime="")
	 	
	 	s ecrecord=""
	 	for
		 {
			s ecrecord = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",happenDate,happenTime,ecrecord))
		 	q:(ecrecord="")
		 	
		 	s subNum=""
		 	for
			{
				s subNum = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",happenDate,happenTime,ecrecord,subNum))
			 	q:(subNum="")
			 	s InstanceId = ecrecord_"||"_subNum
			 	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceId)
			 	continue:(objInstance="")
			 	
			 	s emrdocId = objInstance.TheECRecord.RealChartItemID
			 	//取最后一次操作日志，判定是否为打印
			 	s emrlogId=##class(EMRservice.BL.BLEMRLogs).GetLogID(AEpisodeID,emrdocId,subNum)
			 	s finOperLog = ##class(EMRservice.BL.BLEMRLogs).GetFinalLog(emrlogId)
			 	s finOperAction = ""
			 	s:(finOperLog'="") finOperAction = finOperLog.Action
			 	
			 	if (finOperAction'="print")
			 	{
					s subJson={}
					s subJson.InstanceId = InstanceId
					s subJson.Title = objInstance.Title
					s subJson.HappenDate = $zd(objInstance.HappenDate,3)
					s subJson.HappenTime = $zt(objInstance.HappenTime,1)
					
					d JsonData.%Push(subJson)
					s count=count+1
				}
			 	
			}
		 }
	 }
 }
 q:(count=0) resultJson.%ToJSON()
 s resultJson.total=count
 s resultJson.data=JsonData
 q resultJson.%ToJSON()
}

}
