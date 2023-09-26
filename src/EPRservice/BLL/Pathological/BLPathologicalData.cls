/// 名称： EPRservice.BLL.Pathological.BLPathologicalData
/// 描述:  根据EpisodeID或者PatientID,查询患者的病理报告信息
/// 创建者：牛才才
/// 创建时间：2014-08-12
Class EPRservice.BLL.Pathological.BLPathologicalData Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("EPRservice.BLL.Pathological.BLPathologicalData","GetPathologicalOrder","41","5","1","4","1")
Query GetPathologicalOrder(AEpisodeID As %String, APatientID As %String, ArgStartNum As %String, ArgEndNum As %String, ArgQueryType As %String) As %Query(ROWSPEC = "OrderRowID:%String,ReportID:%String,episodeDate:%String,episodeDept:%String,OrderDesc:%String,OrderDate:%String,OrderTime:%String,AcceptDate:%String,AcceptTime:%String,ReportDate:%String,ReportTime:%String")
{
}

ClassMethod GetPathologicalOrderExecute(ByRef qHandle As %Binary, AEpisodeID As %String, APatientID As %String, ArgStartNum As %String, ArgEndNum As %String, ArgQueryType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s count = 1
	
	if (ArgQueryType = "1")
	{
		s EpisodeID = AEpisodeID
		d GetDataByEpisodeID
	}
	else
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(APatientID,"ADM","I",EpisodeID))
			q:(EpisodeID="")
			d GetDataByEpisodeID
		}
		
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(APatientID,"ADM","O",EpisodeID))
			q:(EpisodeID="")
			d GetDataByEpisodeID
		}
	}
	
	Quit $$$OK
GetDataByEpisodeID
	
	
	s episodeDate = $ZD($p($g(^PAADM(EpisodeID)),"^",6),3)	 	
	s deptId=$p(^PAADM(EpisodeID),"^",4)
	if (deptId'="")
	{
		set episodeDept=$p(^CTLOC(deptId),"^",2)
	}
	else
	{
		set episodeDept=""
	}
	if ($f(episodeDept,"-")'=0)
	{
		s episodeDept = $p(episodeDept,"-",2)
	}
	
	//调用病理报告接口
	s Result = ##class(%ResultSet).%New("EPRservice.BLL.Pathological.BLPathologicalData:TestDataQuery")
    d Result.Execute(EpisodeID)
	
	While (Result.Next())
	{
		if (count >= ArgStartNum) && (count <= ArgEndNum)
		{
			s OrderRowID = $g(Result.Data("OrderRowID"))
			s ReportID = $g(Result.Data("ReportID"))
			s OrderDesc = $g(Result.Data("OrderDesc"))
			s OrderDate = $g(Result.Data("OrderDate"))
			s OrderTime = $g(Result.Data("OrderTime"))
			s AcceptDate = $g(Result.Data("AcceptDate"))
			s AcceptTime = $g(Result.Data("AcceptTime"))
			s ReportDate = $g(Result.Data("ReportDate"))
			s ReportTime = $g(Result.Data("ReportTime"))
			
			set ^CacheTemp(repid,ind) = $LB(OrderRowID,ReportID,episodeDate,episodeDept,OrderDesc,OrderDate,OrderTime,AcceptDate,AcceptTime,ReportDate,ReportTime)
			set ind = ind + 1
		}
		s count = count + 1
	}
	
	Quit $$$OK
}

ClassMethod GetPathologicalOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathologicalOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPathologicalOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathologicalOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{			
 		Set Row=^CacheTemp(repid,ind)
 	}

 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据OrderRowID或者ReportID获取病理报告信息
/// d ##class(%ResultSet).RunQuery("EPRservice.BLL.Pathological.BLPathologicalData","GetPathologicalReport","","")
Query GetPathologicalReport(AOrderRowID As %String, AReportID As %String) As %Query(ROWSPEC = "ResultInEye:%String,ResultInMicroscopy:%String,CheckOpinion:%String")
{
}

ClassMethod GetPathologicalReportExecute(ByRef qHandle As %Binary, AOrderRowID As %String, AReportID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	
	s ResultInEye = "肉眼所见结果，测试用数据"
	s ResultInMicroscopy = "镜下所见结果，测试用数据"
	s CheckOpinion = "诊断意见，测试用数据"
	
	set ^CacheTemp(repid,ind) = $LB(ResultInEye,ResultInMicroscopy,CheckOpinion)
	set ind = ind + 1
	
	
	Quit $$$OK
}

ClassMethod GetPathologicalReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathologicalReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPathologicalReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathologicalReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{			
 		Set Row=^CacheTemp(repid,ind)
 	}

 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("EPRservice.BLL.Pathological.BLPathologicalData","TestDataQuery","41")
Query TestDataQuery(AEpisodeID As %String) As %Query(ROWSPEC = "OrderRowID:%String,ReportID:%String,OrderDesc:%String,OrderDate:%String,OrderTime:%String,AcceptDate:%String,AcceptTime:%String,ReportDate:%String,ReportTime:%String")
{
}

ClassMethod TestDataQueryExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	for i=1:1:5
	{
		s OrderRowID = i_"||"_AEpisodeID
		s OrderDesc = AEpisodeID_"医嘱名称"_i
		s OrderDate = AEpisodeID_"下医嘱日期"_i
		s OrderTime = AEpisodeID_"下医嘱时间"_i
		s AcceptDate = AEpisodeID_"标本接收日期"_i
		s AcceptTime = AEpisodeID_"标本接收时间"_i
		s ReportID = AEpisodeID_"报告ID"_i
		s ReportDate = AEpisodeID_"报告日期"_i
		s ReportTime = AEpisodeID_"报告时间"_i
		
		set ^CacheTemp(repid,ind) = $LB(OrderRowID,ReportID,OrderDesc,OrderDate,OrderTime,AcceptDate,AcceptTime,ReportDate,ReportTime)
		set ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod TestDataQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TestDataQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TestDataQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TestDataQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{			
 		Set Row=^CacheTemp(repid,ind)
 	}

 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
