Class EMRservice.BL.BLOPInterfaceService Extends %RegisteredObject
{

/// w ##class(EMRservice.BL.BLOPInterfaceService).GetInstanceIDByEpisodeID(4133)
ClassMethod GetInstanceIDByEpisodeID(AEpisodeID As %String) As %String
{
	s result = ""

	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time))
			q:(time = "")
			s ecrecordId = ""
			for
			{
				s ecrecordId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time,ecrecordId))
				q:(ecrecordId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time,ecrecordId,subId))
					q:(subId = "")
					s instanceId = ecrecordId_"||"_subId
						//是否过滤无有效签名或无签名病历
					
					s signFlag = ##Class(EMRservice.BOPrivAssist).HasValidSign(instanceId)
					continue:(signFlag = 0)
			
					
					s:(result'="") result=result_"^"_instanceId
					s:(result="") result=instanceId
				}
			}
		}
	}
	//w !,result	
	q result
}

}
