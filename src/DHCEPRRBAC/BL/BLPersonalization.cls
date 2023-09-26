Class DHCEPRRBAC.BL.BLPersonalization Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetLinkInfo(AParam As %String) As %String
{
	s ret = AParam
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "FCYY")
	{
		s MomEpisodeID = AParam
		
		//获取NICU孩子的EpisodeID
		s ret = MomEpisodeID	
	}
	
	q ret
}

}
