Class EPRservice.BLL.BLEPRRevision Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##Class(EPRservice.BLL.BLEPRRevision).IsRevisionActive("finished","512")
ClassMethod IsRevisionActive(AEPRStatus As %String, AEPRDocID As %String) As %Boolean
{
	s isActive = 0
	
	s bigStatus = $zcvt(AEPRStatus,"u")
	
	s revvisionActiveStatus = $O(^DHCEPRM.EPRRevisionI("IdxEPRDocIDAndEPRStatus"," "_AEPRDocID,""))
	if (revvisionActiveStatus = "")
	{
		//未对此病历做特殊配置，默认提交之后即留痕
		if (bigStatus = "COMMITED")||(bigStatus="ATTENDINGCHECKED")||(bigStatus="CHIEFCHECKED")
		{
			s isActive = 1
		}
	}
	else
	{
		//使用特殊配置的情况，满足配置情况才留痕
		s count = $L(revvisionActiveStatus,"|")
		for i = 1:1:count
		{
			if (bigStatus = $p(revvisionActiveStatus,"|",i))
			{
				s isActive = "1"
				quit
			}
		}
	}
	
	q isActive
}

/// Debug:	w ##Class(EPRservice.BLL.BLEPRRevision).GetRevisionActiveStatus("512")
ClassMethod GetRevisionActiveStatus(AEPRDocID As %String) As %String
{
	s revvisionActiveStatus = $O(^DHCEPRM.EPRRevisionI("IdxEPRDocIDAndEPRStatus"," "_AEPRDocID,""))
	q:(revvisionActiveStatus = "") ""
	q $e(revvisionActiveStatus,2,$L(revvisionActiveStatus))
}

}
