Class EMRservice.InterfaceService.RecordSigned Extends %RegisteredObject
{

/// 描述：根据EpisodeID、DocID获取病历是否已签名
/// 入参：argEpisodeID：就诊ID，不能为空
///       argDocID：打印模板ID，不能为空
/// 输出：-1：入参为空；
///        0：没有签名；
///    1^SYS：有签名^系统数字签名；
///     1^CA：有签名^CA签名
/// w ##Class(EMRservice.InterfaceService.RecordSigned).hasRecordSigned("151","102")
ClassMethod hasRecordSigned(argEpisodeID As %String, argDocID As %String) As %String
{
	q:(argEpisodeID = "")||(argDocID = "") "-1"
	s ret = "0"
	s EMRNum = ""
	for
	{
		s EMRNum = $O(^DHCEMRI.EMRSignI("IdxLast"," "_argEpisodeID," "_argDocID,EMRNum))
		q:(EMRNum = "")
		
		s SignDate = ""
		for
		{
			s SignDate = $O(^DHCEMRI.EMRSignI("IdxLast"," "_argEpisodeID," "_argDocID,EMRNum,SignDate))
			q:(SignDate = "")
			
			s SignTime = ""
			for
			{
				s SignTime = $O(^DHCEMRI.EMRSignI("IdxLast"," "_argEpisodeID," "_argDocID,EMRNum,SignDate,SignTime))
				q:(SignTime = "")
				
				s EMRSignRowID = ""
				for
				{
					s EMRSignRowID = $O(^DHCEMRI.EMRSignI("IdxLast"," "_argEpisodeID," "_argDocID,EMRNum,SignDate,SignTime,EMRSignRowID))
					q:(EMRSignRowID = "")
					
					s EMRSignObj = ##Class(EMRinstance.EMRSign).%OpenId(EMRSignRowID)
					if (EMRSignObj '= "")
					{
						continue:(EMRSignObj.isSignValid = "0")
						s signValid = EMRSignObj.isSignValid
						s signYype = EMRSignObj.Type
						s ret = signValid_"^"_signYype
					}
				}
			}
		}
	}
	q ret
}

}
