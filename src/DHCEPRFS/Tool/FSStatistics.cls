Class DHCEPRFS.Tool.FSStatistics Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// debug: d ##class(DHCEPRFS.Tool.FSStatistics).ScanRecordNum("SCAN","2015-10-1","2016-7-25")
/// debug: d ##class(DHCEPRFS.Tool.FSStatistics).ScanRecordNum("ARRANGE","2014-12-3","2015-6-30")
ClassMethod ScanRecordNum(AAction As %String, AStartDate As %String, AEndDate As %String, AUserID As %String = "", AMedRecordNo As %String = "")
{
	s:(AStartDate '= "") StartDate = $zdh(AStartDate,3)
	s:(AEndDate '= "") EndDate = $zdh(AEndDate,3)
	s:(AUserID = $c(0)) AUserID = ""
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""

	s count = 0
	s mrEpisodeID = ""
	for {
		
		s flag = "false"
		s mrEpisodeID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeAction"," "_AAction,mrEpisodeID))	
		q:(mrEpisodeID = "")
		
		s mrLogID = ""
		for {
			s mrLogID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeAction"," "_AAction,mrEpisodeID,mrLogID))
			q:(mrLogID = "")

			s subID = ""
			for {
				s subID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeAction"," "_AAction,mrEpisodeID,mrLogID,subID))
				q:(subID = "")
				s mrLogDetailID = mrLogID_"||"_subID
				s obj = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
				s ActDate = obj.ActDate
				s ActUser = obj.ActUserID

				continue:((AUserID '= "") && (ActUser '= AUserID))
				
				s rowID = ""
				s rowID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMREpisodeID",mrEpisodeID,rowID))
				continue:(rowID = "")
				
				s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(rowID)
				s medRecordNo = objMREpisodePat.MedRecordNo

				continue:((AMedRecordNo '= "") && (medRecordNo '= AMedRecordNo))
				
				if ((ActDate >= StartDate) && (ActDate <= EndDate))
				{
					s flag = "true"
					s count = count + 1
					q	
				}
			}
			q:(flag="true")
		}
	}
	
	w !, AStartDate_" 到 "_AEndDate_" 期间,总共"_AAction_":"_count_"次就诊"
}

/// debug: d ##class(DHCEPRFS.Tool.FSStatistics).ItemCount("111")
ClassMethod ItemCount(AMRItemID As %String) As %String
{
	s count = 0
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID),-1)
		q:(mrEpisodeID = "")
		s version = ""
		for {
			s version = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version))
			q:(version = "")
			s mrVersionID = ""
			for {
				s mrVersionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version,mrVersionID))
				q:(mrVersionID = "")
					
				s mrVerItemID = ""
				for {

					s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVersionID, " "_AMRItemID,mrVerItemID))
					if (mrVerItemID '= "")
					{
						s count = count + 1
						w !,count
					}
					w !,count
				}	
			}
		}
	}
}

Storage Default
{
<Data name="FSStatisticsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.Tool.FSStatisticsD</DataLocation>
<DefaultData>FSStatisticsDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.Tool.FSStatisticsD</IdLocation>
<IndexLocation>^DHCEPRFS.Tool.FSStatisticsI</IndexLocation>
<StreamLocation>^DHCEPRFS.Tool.FSStatisticsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
