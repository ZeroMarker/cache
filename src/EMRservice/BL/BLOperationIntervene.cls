/// Desc:是否允许新建“术前讨论”的需求
/// Creator:Candy
/// CreateDate:2015-10-14
Class EMRservice.BL.BLOperationIntervene Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod getOperationIntervene(AEpisodeId As %String, ADocId As %String) As %String
{
		s result = ""
		q:(AEpisodeId="")||(ADocId = "") result
		/*
		s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId," "_ADocId,""))
		if (rowId = "") 
		{
			s count = 0
			s date = ""
			for
			{
				s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date))
				q:(date = "")
				s time = ""
				for
				{
					s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date,time))
					q:(time = "")
					s count = count + 1
				}
			}
			s sqeNo = count + 1
		}
		else
		{
			s sqeNo = 1
		}
		
		s result = ##Class(web.DHCANIntervention).IsPreInterveneBySeqNo(AEpisodeId,sqeNo)
		*/
		
		s sqeNo = 1
		s result = ##Class(web.DHCANIntervention).IsEMRBySeqNo(AEpisodeId,ADocId,sqeNo)
		q result
}

}
