Class DHCEPRFS.ThirdParty.BL.FCYYBUltraSonic Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.ThirdParty.BL.FCYYBUltraSonic).GetFTPPath("5365109")
ClassMethod GetFTPPath(AEpisodeID As %String) As %String
{
	s ret = ""
	s ftpUrl = ""
	
	s studyInfos = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetStudyInfoNew(AEpisodeID)
	q:(studyInfos = "") ret
	
	s count = $l(studyInfos,"^")
	for index=1:1:count
	{
		s studyInfo = $p(studyInfos,"^",index)
		q:(studyInfo = "")
		
		s studyNo = $p(studyInfo,"|",1)
		if ($e(studyNo,1) = "E")
		{
			s ftpUrl = "PDF\M"
			s studyNo = $e(studyNo,2,$l(studyNo))	
		}
		elseif ($e(studyNo,1) = "W")
		{
			s ftpUrl = "WPDF\M"
			s studyNo = $e(studyNo,2,$l(studyNo))				
		}
		
		s RptDate = $p(studyInfo,"|",2)
		
		s ftp = ftpUrl_RptDate_"\"_studyNo_".pdf"
		
		if (ret = "")
		{
			s ret = ftp	
		}
		else
		{
			s ret = ret_"^"_ftp	
		}
	}
	q ret
	//q "DHCEPRFS2014\07\12\120153-2.pdf"
}

/// debug: w ##class(DHCEPRFS.ThirdParty.BL.FCYYBUltraSonic).GetFTPUserNameAndPassword()
ClassMethod GetFTPUserNameAndPassword() As %String
{
	//s username = "Ultrasonic"
	//s password = "115939"
	s username = "anonymous"
	s password = ""
	
	s ret = "ftp^192.168.4.64^2121^"_username_"^"_password_"^5"
	//s ret = "ftp^192.168.4.12^21^"_username_"^"_password_"^5"
	//s ret= "ftp^127.0.0.1^21^anonymous^^5"
	q ret
}

}
