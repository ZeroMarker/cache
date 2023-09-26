/// Desc:通过工具补门急诊病历，关联表
/// Creator:yejian
/// CreateDate:2019-3-15
Class EMRservice.BL.BLInstanceLinkTool Extends %RegisteredObject
{

/// Desc:通过工具补门急诊病历
/// Creator:yejian
/// CreateDate:2019-3-15
ClassMethod SetData(ASaveDate As %String, AEpisodeID As %String, AInstanceID As %String, AUserID As %String) As %String
{
	s result = "-1"
	q:(ASaveDate = "")||(AEpisodeID = "")||(AInstanceID = "") result
	
	TSTART
	s obj = ##class(EMRinstance.InstanceLinkTool).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.InstanceID = AInstanceID
	s obj.UserID = AUserID
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{ 
		s objIn = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
		/* //屏蔽把补病历的时间修改为就诊相关时间
		s date = $p(ASaveDate," ",1),time = $p(ASaveDate," ",2)    
    	s objIn.HappenDate = $Case(date,"":"",:$zdh(date,3))
    	s objIn.HappenTime = $Case(time,"":"",:$zth(time))
    	s objIn.CreateDate = $Case(date,"":"",:$zdh(date,3))
    	s objIn.CreateTime = $Case(time,"":"",:$zth(time))
    	s objIn.ModifyDate = $Case(date,"":"",:$zdh(date,3))
    	s objIn.ModifyTime = $Case(time,"":"",:$zth(time))
    	*/
    	s PAAdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
		s date = $p(PAAdmDateTime,",",1) 
		s time = $p(PAAdmDateTime,",",2) 
		//900:15分钟，5100:2小时
		s random = 900+$R(5100)
		s time = time + random
		//86399表示23:59:59
		if (time>86399)
		{
			s time= 86399
		}
	 	s objIn.CreateDate = date
	 	s objIn.CreateTime = time
	 	s objIn.ModifyDate = date
	 	s objIn.ModifyTime = time
	 	s objIn.HappenDate = date
	 	s objIn.HappenTime = time
    	s sc = objIn.%Save()
    	if ($$$ISOK(sc))
    	{
	    	s result = obj.%Id()
    	}
    	else
    	{
	    	s result = "-1"
    	}
	}
	else
    {
	    s result = "-1"
    }
    if (result ="-1")
	{
		 TROLLBACK
		 quit "-1"
	}
	else
	{
		TCOMMIT
		q result
	}
}

/// Desc:通过工具补门急诊病历
/// Creator:yejian
/// CreateDate:2020-7-20
/// w ##class(EMRservice.BL.BLInstanceLinkTool).SetInstanceDateTime()
ClassMethod SetInstanceDateTime() As %String
{
	s result = "1"
	s AEpisodeID = ""
	for {
		s AEpisodeID =  $o(^DHCEMRI.InstanceLinkToolI("IdxEpisodeID", AEpisodeID))
		q:(AEpisodeID="")	
		s AInstanceID = ""		
		for {
			s AInstanceID =  $o(^DHCEMRI.InstanceLinkToolI("IdxEpisodeID", AEpisodeID,AInstanceID))
			q:(AInstanceID="")
			s strInstatceID = $tr(AInstanceID," ","")			
			s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(strInstatceID)
			q:(objInstanceData = "")
			s strEpisodeID = $tr(AEpisodeID," ","")			
			s PAAdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(strEpisodeID)
			s date = $p(PAAdmDateTime,",",1) 
			s time = $p(PAAdmDateTime,",",2) 
			//900:15分钟，5100:2小时
			s random = 900+$R(5100)
			s time = time + random
			//86399表示23:59:59
			if (time>86399)
			{
				s time= 86399
			}
		 	s objInstanceData.CreateDate = date
		 	s objInstanceData.CreateTime = time
		 	s objInstanceData.ModifyDate = date
		 	s objInstanceData.ModifyTime = time
		 	s objInstanceData.HappenDate = date
		 	s objInstanceData.HappenTime = time
		 	s sc = objInstanceData.%Save()
		 	if $$$ISERR(sc)
			{
				s result = "-1"
				q
			}
		}
	}
	q result
}

}
