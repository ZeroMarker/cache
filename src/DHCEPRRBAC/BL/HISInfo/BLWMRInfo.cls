Class DHCEPRRBAC.BL.HISInfo.BLWMRInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// CreatDate：  2014-09-04
/// Service User:电子病历组
/// Description：通过病案号取就诊号
/// Table：      
/// Input：      MrNO：病案号 MrType:病案类型(住院病案：7，门诊病案：6 ，急诊病案：101)
/// Debug: 		 w ##class(DHCEPRRBAC.BL.HISInfo.BLWMRInfo).IGetEpisodeIDsByMrNo("90541902","7")
/// Return：     episodeID string
ClassMethod IGetEpisodeIDsByMrNo(aMrNo As %String, aMrType As %String) As %String
{
	s ret = ""
	s episodeList = ##class(web.DHCWMRService).IGetEpisodeIDsByMrNo(aMrNo,aMrType,"")
	if (($p(episodeList,":",1) '= "-2") && ($p(episodeList,":",1) '= "-1"))
	{
		for index=1:1:$listlength(episodeList)
		{
			if (ret = "")
			{
				s ret = $list(episodeList,index)
			}
			else
			{
				s ret = ret_"^"_$list(episodeList,index)
			}
		}
	}
	q ret
}

/// Debug: 		 w ##class(DHCEPRRBAC.BL.HISInfo.BLWMRInfo).IGetEpisodeIDsByMrNoAllString("Z159546")
ClassMethod IGetEpisodeIDsByMrNoAllString(AMedRecordNo As %String)
{
	s ret = ""
	s in = ..IGetEpisodeIDsByMrNo(AMedRecordNo,"7")
	s:((in '= "") && ($p(in,":",1) '= "-2") && ($p(in,":",1) '= "-1")) ret = in
	
	s out = ..IGetEpisodeIDsByMrNo(AMedRecordNo,"6")
	if ((out '="") && ($p(out,":",1) '= "-2") && ($p(out,":",1) '= "-1"))
	{
		if (ret = "")
		{
			s ret = out
		}
		else
		{
			s ret = ret_"^"_out	
		}
	}
	
	s e = ..IGetEpisodeIDsByMrNo(AMedRecordNo,"101")
	if ((e '="") && ($p(e,":",1) '= "-2") && ($p(e,":",1) '= "-1"))
	{
		if (ret = "")
		{
			s ret = e
		}
		else
		{
			s ret = ret_"^"_e
		}
	}
	
	q ret
}

}
