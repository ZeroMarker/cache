Class DHCEPRFS.ThirdParty.BL.BLCheckFinish Extends %Persistent
{

ClassMethod AutoCheckFinish()
{
	s date = $p($h,",","1") + 1
	for {
		s date = $o(^DHCEPRFS.INST.ThirdCheckFinishLogI("IdxCommitDateTime"," N",date),-1)
		q:(date = "")
		s time = ""
		for {
			s time = $o(^DHCEPRFS.INST.ThirdCheckFinishLogI("IdxCommitDateTime"," N",date,time))
			q:(time = "")
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRFS.INST.ThirdCheckFinishLogI("IdxCommitDateTime"," N",date,time,rowID))
				q:(rowID = "")	
				
				d ..CheckFinsh(rowID)
			}	
		}	
	}
}

/// debug: w ##class(DHCEPRFS.ThirdParty.BL.BLCheckFinish).CheckFinsh("5365109")
ClassMethod CheckFinshByEpisode(AEpisodeID As %String) As %String
{
	s patientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(AEpisodeID)
	
	//调用第三方webservice
	s arg = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).GetInput(AEpisodeID)
	s webservice = ##class(DHCEPRFS.ThirdParty.WebService.XingHe.WLRMXingHeWebServicePort).%New()
	s ret = ""
	s ret = webservice.CheckReport(arg)
	
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.ThirdCheckFinishLogI("IdxMain"," "_AEpisodeID,rowID))
	
	if (rowID = "")
	{
		s obj = ##class(DHCEPRFS.ThirdParty.INST.CheckFinishLog).%New()
		s obj.CheckTimes = 1
	}
	else
	{
		s obj = ##class(DHCEPRFS.ThirdParty.INST.CheckFinishLog).%OpenId(rowID)	
		s obj.CheckTimes = (+obj.CheckTimes) + 1
	}
	
	s obj.EpisodeID = AEpisodeID
	s obj.PatientID = patientID
	s obj.CommitFlag = "N"
	s obj.InputValue = arg
	s obj.OutputValue = ret
	
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	
	s obj.LastCheckDate = date
	s obj.LastCheckTime = time
	
	//拆分结果
	if (ret '= "")
	{
		//假设用^分隔，第一个数为当前发布报告数，第二个数为总报告数，第三位注释
		s reportNum = +$p(ret,"^",1)
		s allNum = +$p(ret,"^",2)
		s unpublish = allNum - reportNum
		s obj.PublishReports = reportNum
		s obj.UnPublishReports = unpulish
		s obj.AllReports = allNum
		s obj.Comment = $p(ret,"^",3)
		
		if (reportNum < allNum)
		{
			d obj.%Save()		
		}
		else
		{
			//提交单项生成
			s retCommit = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLateReportEpisode(episodeID,"CREATE3RDLIS")
			s obj.CommitReturn = retCommit
			s obj.CommitFlag = "Y"
			s obj.CommitDate = date
			s obj.CommitTime = time
			d obj.%Save()
		}
	}
	else
	{
		s obj.ErrorFlag = "Y"
		d obj.%Save()
	}
}

/// debug: w ##class(DHCEPRFS.ThirdParty.BL.BLCheckFinish).CheckFinsh("5365109")
ClassMethod CheckFinsh(ARowID As %String) As %String
{
	s obj = ##class(DHCEPRFS.ThirdParty.INST.CheckFinishLog).%OpenId(ARowID)	
	s obj.CheckTimes = (+obj.CheckTimes) + 1
	s episodeID = obj.EpisodeID
	
	s patientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(episodeID)
	
	//调用第三方webservice
	s arg = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).GetInput(episodeID)
	s webservice = ##class(DHCEPRFS.ThirdParty.WebService.XingHe.WLRMXingHeWebServicePort).%New()
	s ret = ""
	s ret = webservice.CheckReport(arg)
		
	s obj.EpisodeID = episodeID
	s obj.PatientID = patientID
	s obj.CommitFlag = "N"
	s obj.InputValue = arg
	s obj.OutputValue = ret
	
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	
	s obj.LastCheckDate = date
	s obj.LastCheckTime = time
	
	//拆分结果
	if (ret '= "")
	{
		//假设用^分隔，第一个数为当前发布报告数，第二个数为总报告数，第三位注释
		s reportNum = +$p(ret,"^",1)
		s allNum = +$p(ret,"^",2)
		s unpublish = allNum - reportNum
		s obj.PublishReports = reportNum
		s obj.UnPublishReports = unpulish
		s obj.AllReports = allNum
		s obj.Comment = $p(ret,"^",3)
		
		if (reportNum < allNum)
		{
			d obj.%Save()		
		}
		else
		{
			//提交单项生成
			s retCommit = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLateReportEpisode(episodeID,"CREATE3RDLIS")
			s obj.CommitReturn = retCommit
			s obj.CommitFlag = "Y"
			s obj.CommitDate = date
			s obj.CommitTime = time
			d obj.%Save()
		}
	}
	else
	{
		s obj.ErrorFlag = "Y"
		d obj.%Save()
	}
}

Storage Default
{
<Data name="BLCheckFinishDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.Thi8397.BLCheckFinishD</DataLocation>
<DefaultData>BLCheckFinishDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.Thi8397.BLCheckFinishD</IdLocation>
<IndexLocation>^DHCEPRFS.Thi8397.BLCheckFinishI</IndexLocation>
<StreamLocation>^DHCEPRFS.Thi8397.BLCheckFinishS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
