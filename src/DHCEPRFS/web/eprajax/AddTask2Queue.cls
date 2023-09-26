Class DHCEPRFS.web.eprajax.AddTask2Queue Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    s episodeID = $Get(%request.Data("EpisodeID",1),"")
	
	d ..Add(episodeID)
	Quit $$$OK
}

/// 病案相关动作调用ajax方法插入队列
ClassMethod Add(AEpisodeID As %String) As %String
{
	q:((AEpisodeID = "") || (AEpisodeID = $c(0)))
	
	d ##class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",AEpisodeID,"50","","N","")
	//发布麻醉单单独生成（第三方接口，报错较多，从全部生成中摘出）
	d ##class(DHCEPRFS.SI.SIAdmMRStatus).PublishAN(AEpisodeID)
	
	//判断是否是产科婴儿，婴儿没有病案首页，不需要屏蔽隐私，否则队列中隐私项目为空会卡住
	//通过是否有病案号（新生儿无病案号）
	s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetMedNo(AEpisodeID)
	s:(medRecordNo = $c(0)) medRecordNo = ""
	if (medRecordNo '= "")
	{
		d ##class(DHCEPRFS.BL.BLAdmTaskQueue).CreatePrivacyLevel01("DHC",AEpisodeID,"50","N")	
	}
	
	//PIS需要特殊生成
	s ret = ##class(DHCEPRFS.BL.HISInfo.BLPISInfo).HasPISToPrint(AEpisodeID)
	if (ret = "1")
	{
		d ##class(DHCEPRFS.SI.SIAdmMRStatus).PublishPIS(AEpisodeID)	
	}
}

}
