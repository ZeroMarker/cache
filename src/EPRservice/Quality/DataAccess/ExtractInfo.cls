Class EPRservice.Quality.DataAccess.ExtractInfo Extends %RegisteredObject
{

/// Desc 将临时global中的数据存入表(EPRinstance.Quality.ExtractInfo)里
/// 2021-03-29
/// ^tempSelect("ExtractInfo")=AdmType_"^"_StartDate_"^"_EndDate_"^"_LocId_"^"_Proportion_"^"_LocNums_"^"_""  取这个临时global的数据
/// 
ClassMethod addExtractInfo()
{
	///数据存表(EPRinstance.Quality.ExtractInfo)
	s result="添加失败"
	
	//s ^tempSelect("ExtractInfo")=AdmType_"^"_StartDate_"^"_EndDate_"^"_LocId_"^"_Proportion_"^"_LocNums_"^"_""
	s ExtractInfo=$g(^tempSelect("ExtractInfo"))
	q:(ExtractInfo="") result
	
	TSTART
	s OBJExtractInfo=##class(EPRinstance.Quality.ExtractInfo).%New()
	
	q:(OBJExtractInfo="")
	s OBJExtractInfo.StartDate=$p(ExtractInfo,"^",2)
	s OBJExtractInfo.EndDate=$p(ExtractInfo,"^",3)
	s OBJExtractInfo.AdmType=$p(ExtractInfo,"^",1)
	s OBJExtractInfo.LocId=$p(ExtractInfo,"^",4)
	s OBJExtractInfo.Ratio=$p(ExtractInfo,"^",5)
	s OBJExtractInfo.ExtractNumber=$p(ExtractInfo,"^",6)
	s OBJExtractInfo.SpecialAdmType=$p(ExtractInfo,"^",7)
	s sc = OBJExtractInfo.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		s Error = $system.OBJ.DisplayError(sc)
		s result = "失败^"_Error

	}
	else
	{
		TCOMMIT
		s result = "添加成功"
	}

	
	q result
}

/// debug:w ##class(EPRservice.Quality.DataAccess.ExtractInfo).GetAllDateGap("IA")
ClassMethod GetAllDateGap(AdmType) As %String
{
	
	S:(AdmType="O") AdmType="OA"
	s ret=""
	
	s ^tempDateGapSort("DateGapSort")=""
	
	s rowId=""
	for{
		s rowId=$o(^DHCEPRQ.ExtractInfoI("IdxAdmType"," "_AdmType,rowId))
		q:(rowId="")
		
		s OBJExtractInfo=##class(EPRinstance.Quality.ExtractInfo).%OpenId(rowId)
		q:(OBJExtractInfo="")
		
		s startDate=OBJExtractInfo.StartDate
		s endDate=OBJExtractInfo.EndDate
		s:(startDate'="") startDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",startDate)
		s:(endDate'="") endDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",endDate)
		s node=startDate_"---"_endDate
		
		s ^tempDateGapSort("DateGapSort",node)=""
		
 	}
 	
 	s node=""
 	for
 	{
		s node=$o(^tempDateGapSort("DateGapSort",node))
		q:(node="")
		
		s:ret'="" ret=ret_"/"_node	
		s:ret="" ret=node
	}
	
	K ^tempDateGapSort("DateGapSort")
 	
 	
 	
 	q ret
}

}
