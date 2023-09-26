/// 创建者：牛才才
/// 创建日期：2015-12-18
Class web.eprajax.query.getEPRorEMRInfo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	
	if (action = "getEPRorEMRByEID")
	{
		w ..getEPRorEMRByEpisodeID(episodeID)
	}
	elseif (action = "getPatientIDByEID")
	{
		w ..getPatientIDByEpisodeID(episodeID)
	}
	
	Quit $$$OK
}

/// Description:根据EpisodeID在Global中判断该次就诊是写的二版病历还是三版病历
/// Input:AEpisodeID-病人就诊号,
/// Return:1-三版病历,0-二版病历
/// Debug: w ##class(web.eprajax.query.getEPRorEMRInfo).getEPRorEMRByEpisodeID("53")
ClassMethod getEPRorEMRByEpisodeID(AEpisodeID As %String) As %String
{
	//根据episodeID判断该患者写的是二版病历还是三版病历
	s DHCEMR = 0
	s EPRCategoryID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_AEpisodeID,""))
	if (EPRCategoryID = "") //没有二版病历数据
	{
		s EMRChartItemID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ""))
		if (EMRChartItemID '= "") //有三版病历数据
		{
			s DHCEMR = 1
		}
		else  //既没有二版数据也没有三版数据，患者未写病历，需判断当前系统是否有三版病历环境，有则去写三版病历，没有则写二版病历；
		{
			s SysOptionData = $g(^DHCEMRM.SysOptionD)   //判断三版系统参数数据，来确定是否有三版病历环境
			if (SysOptionData > 0)   //有三版系统参数数据，说明有三版病历环境，至于部分科室是三版病历，部分科室是二版病历，有需要再进一步判断患者所在科室；
			{
				s DHCEMR = 1
			}
		}
	}
	Quit DHCEMR
}

/// Description:根据EpisodeID在Global中获取PatientID
/// Input:AEpisodeID-病人就诊号,
/// Return:PatientID-病人号,
/// Debug: w ##class(web.eprajax.query.getEPRorEMRInfo).getPatientIDByEpisodeID("53")
ClassMethod getPatientIDByEpisodeID(AEpisodeID As %String) As %String
{
	//根据episodeID判断该患者写的是二版病历还是三版病历
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s PatientID = ""
	s PatientID = $P($g(^PAADM(AEpisodeID)),"^",1)
	q:(PatientID '= "") PatientID

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :PatientID from SQLUser.PA_Adm where PAADM_RowId = :AEpisodeID)
	q PatientID
}

}
