Class EPRservice.Quality.Interface.EMRQualityForPortal Extends %RegisteredObject
{

/// 查询病历等级数据,按照终末质控日期查询
/// 入参 起始时间，结束时间
/// 返回值：就诊号,等级,分数
/// d ##class(%ResultSet).RunQuery("EPRservice.Quality.Interface.EMRQualityForPortal","GetQualitySummary","2018-01-01","2019-02-01")
Query GetQualitySummary(AStartDate As %String, AEndDate As %String, ARuleDR As %String = 7) As %Query(ROWSPEC = "tmpEpisodeID,tmpGrade,tmpScore") [ SqlProc ]
{
}

ClassMethod GetQualitySummaryExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ARuleDR As %String = 7) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	set:AStartDate["-" AStartDate=$zdh(AStartDate,3)
	set:AEndDate["-" AEndDate=$zdh(AEndDate,3)
	s tmpdate=""
	for tmpdate =AStartDate:1:AEndDate
	{
		set dateCode=$zd(tmpdate,3)
		s QResultID = ""
		for{
			s QResultID=$o(^DHCEPRQ.QualityResultI("IdxExamineDate"," "_dateCode,QResultID))
			q:(QResultID="")
			
			s objQResult=##class(EPRinstance.Quality.QualityResult).%OpenId(QResultID)
			
			continue:(objQResult.RuleDR'=ARuleDR)
			
			s tmpScore = objQResult.ActualScore
			s tmpGrade = objQResult.ActualGrade
			s tmpEpisodeID = objQResult.EpisodeID 
			
			set Data=$lb(tmpEpisodeID,tmpGrade,tmpScore)
	 		set ^||CacheTemp(repid,ind)=Data	
	 		set ind=ind+1
		}
			
	}
	q $$$OK
}

ClassMethod GetQualitySummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualitySummaryExecute ]
{
	s repid = $list(qHandle,2)
 	k ^||CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetQualitySummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualitySummaryExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^||CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^||CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^||CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)

	Quit $$$OK
}

/// 查询终末质控数据,按照质控日期查询
/// 入参 起始时间，结束时间
/// 返回值：就诊号,条目ID   一人多个质控条目,输出多个条目
/// d ##class(%ResultSet).RunQuery("EPRservice.Quality.Interface.EMRQualityForPortal","GetQualityDetail","2018-01-01","2019-02-01")
Query GetQualityDetail(AStartDate As %String, AEndDate As %String, ARuleDR As %String = 7) As %Query(ROWSPEC = "tmpEpisodeID,tmpEntryID") [ SqlProc ]
{
}

ClassMethod GetQualityDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ARuleDR As %String = 7) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	set:AStartDate["-" AStartDate=$zdh(AStartDate,3)
	set:AEndDate["-" AEndDate=$zdh(AEndDate,3)
	s tmpdate=""
	for tmpdate =AStartDate:1:AEndDate
	{
		set dateCode=$zd(tmpdate,3)
		s QResultID = ""
		for{
			s QResultID=$o(^DHCEPRQ.QualityResultI("IdxExamineDate"," "_dateCode,QResultID))
			q:(QResultID="")
			
			s objQResult=##class(EPRinstance.Quality.QualityResult).%OpenId(QResultID)
			
			continue:(objQResult.RuleDR'=ARuleDR)
			
			s tmpEpisodeID = objQResult.EpisodeID 
			s ResultDetails = objQResult.Details
			s subCount=ResultDetails.Count()
			if (subCount=0)
			{
			
			}
			else
			{
				s tmpEntryIDInfo = ""
				for i=1:1:subCount
				{
					s objResultDetail=ResultDetails.GetAt(i)
					s tmpEntryID = objResultDetail.EntryDR
					
					
					set Data=$lb(tmpEpisodeID,tmpEntryID)
			 		set ^||CacheTemp(repid,ind)=Data	
			 		set ind=ind+1
				}
			}
			
		}
			
	}
	q $$$OK
}

ClassMethod GetQualityDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^||CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetQualityDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^||CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^||CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^||CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)

	Quit $$$OK
}

ClassMethod GetQualityDetail(AStartDate As %String, AEndDate As %String, ARuleDR As %String = 7) As %Stream
{
	s Result = ##class(%GlobalCharacterStream).%New()
	s tmpdate=""
	for tmpdate =AStartDate:1:AEndDate
	{
		s QResultID = ""
		for{
			s QResultID=$o(^DHCEPRI.QualityResult("IdxExamineDate"," "_tmpdate,QResultID))
			q:(QResultID="")
			
			s objQResult=##class(EPRinstance.Quality.QualityResult).%OpenId(QResultID)
			
			continue:(objQResult.RuleDR'=ARuleDR)
			
			
			s tmpEpisodeID = objQResult.EpisodeID 
			
			s ResultDetails = objQResult.Details
			s subCount=ResultDetails.Count()
			if (subCount=0)
			{
			
			}
			else
			{
				s tmpEntryIDInfo = ""
				for i=1:1:subCount
				{
					s objResultDetail=listResultDetail.GetAt(i)
					s tmpEntryID = objResultDetail.EntryDR
					s:(tmpEntryIDInfo'="") tmpEntryIDInfo = tmpEntryIDInfo_","_tmpEntryID
					s:(tmpEntryIDInfo="") tmpEntryIDInfo = tmpEntryID
				}
			}
			s ret=tmpEpisodeID_"^"_tmpEntryIDInfo
			d Result.Write(ret)
			if (Result.Size >0)
			{
				d Result.Write("$")
			}
		}
			
	}
	q Result
}

/// 接口说明：AEpisodeID：就诊号
///          AQualityRule:2（提示列表标准ID）
/// 输出项： EntryID：质控点ID
///         EntryDesc:质控点描述
///         EntryScore:质控点分数 
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.Interface.EMRQualityForPortal","GetPromptListForPortal","5541")
Query GetPromptListForPortal(AEpisodeID As %String) As %Query(ROWSPEC = "EntryID,EntryDesc,EntryScore,StrDate,EndDate,Hours,FinishDate,OverFlag")
{
}

ClassMethod GetPromptListForPortalExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetQualityResultList")
	
	s sc = result.Execute(AEpisodeID, 2)
	
	s ColumnCount=result.GetColumnCount()
	
	while result.%Next() {
		
		s Data=""
		s EntryDesc=result.Data("StructName")  //质控描述
		s EntryScore=result.Data("EntryScore")  //分值
		s EntryID=result.Data("EntryID") //质控条目id
		s StrDate=result.Data("StrDate")  //起始时间
		s EndDate=result.Data("EndDate")  //截至时间
		s Hours=result.Data("Hours")    //剩余时间
		s FinishDate=result.Data("FinishDate")  //完成时间
		s OverFlag=result.Data("OverFlag")  //是否超时

		s ^CacheTemp(repid,ind) = $lb(EntryID,EntryDesc,EntryScore,StrDate,EndDate,Hours,FinishDate,OverFlag)

		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod GetPromptListForPortalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPromptListForPortalExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind="") {			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} else {			
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPromptListForPortalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPromptListForPortalExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
