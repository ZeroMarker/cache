/// 生命体征信息
Class EMRservice.BL.BLVitalsigns Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       生命体征
/// Creator:    guozongtao
/// CreateDate: 2014-08-15
/// Input:      AEpisodeID 就诊号
///             AItems 生命体征代码 如：ITEM1^ITME2^ITME3
///             AStDate 开始时间
///             AEndDate 结束时间
/// OutPut:     生命体征信息   
/// debug:    do ##class(EMRservice.BL.BLVitalsigns).GetVitalsignsInfo(811,"ITEM1^ITEM7^ITEM4^ITEM5^ITEM6","2014-01-01","2017-01-01")
ClassMethod GetVitalsignsInfo(AEpisodeID As %String, AItems As %String, AStDate As %String, AEndDate As %String) As %ArrayOfDataTypes
{
	s ReturnValue=##Class(%ArrayOfDataTypes).%New()
	
	q:((AEpisodeID = "")||(AItems = "")) ""
	s count = $l(AItems,"^")
	q:(count > 30) $$$OK
	s mradm = $p($g(^PAADM(AEpisodeID)),"^",61)
	q:(mradm = "") $$$OK
	s episodeDate = $ZD($p($g(^PAADM(AEpisodeID)),"^",6),3)
	s deptId = $p(^PAADM(AEpisodeID),"^",4)
	s deptDesc = $case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
	s date = $Case(AStDate,"":"",:AStDate-1) 
	for
	{
		s date = $o(^MR(mradm,"OBS",0,"DateTime",date))
		q:(date = "")
		q:((AEndDate '="")&&(date > AEndDate))
		s time = ""
		for
		{			
			s time = $o(^MR(mradm,"OBS",0,"DateTime",date,time)) 
			q:(time = "")
			s deptDesc=..GetAdmLoc(AEpisodeID,date,time)
			
			s obj=##Class(%ArrayOfDataTypes).%New()
			
			for I=1:1:count
			{
				s item = $p(AItems,"^",I)
				continue:($d(^MRC("OBITM",0,"Code",$zcvt(item,"u")))<=0)
			    s value = ..GetItemValue(mradm,date,time,item)
   				d obj.SetAt(value,item)
			}
			d obj.SetAt(deptDesc,"DeptDesc")
			d ReturnValue.SetAt(obj,$zd(date,3)_" "_$zt(time))
		}
	}
	Quit ReturnValue
}

/// Desc:       根据Item Code 取值
/// Creator:    Candy
/// CreateDate: 2014-8-15
/// Input:      AMrAdmID 就诊指针
///            ADate,ATime 日期,时间
///            AItem 生命体征code    
/// OutPut:     value 返回值         
ClassMethod GetItemValue(AMrAdmID As %String, ADate As %String, ATime As %String, AItem As %String)
{
	s value = ""
	q:((AMrAdmID = "")||(ADate = "")||(ATime = "")||(AItem = "")) value
	s id = ##class(web.DHCThreeNew).getItmDr(AItem) 
	q:(id = "") value
	s chl = $o(^MR(AMrAdmID,"OBS",0,"Item",id,ADate,ATime,"")) q:(chl="") value
	s value = $p(^MR(AMrAdmID,"OBS",chl),"^",2)
	q value
}

/// Creator： pengjunfu
/// CreatDate：2016-10-28
/// Description:：根据日期获取病人所在科室
/// Table： paadm_transaction
/// Input： episodId:就诊号  searchDate:日期, searchTime:时间
/// Return： 科室id
/// Example: ///  w ##class(EMRservice.BL.BLVitalsigns).getPatLoc(811,64202,64303)
ClassMethod GetAdmLoc(episodId, searchDate, searchTime)
{
		s lastLocId=""
		s locs=""
		s i=0
		s chl="" f  s chl=$O(^PAADM(episodId,"TRANS",chl)) q:chl=""  d
	  	.s locId=$P(^PAADM(episodId,"TRANS",chl),"^",6)
	  	.i (locId="")&&(lastLocId'="") d
	  	..s wardDesc=""
	  	..s wardId=$P(^PAADM(episodId,"TRANS",chl),"^",9)
	  	..i wardId'="" d
	  	...s wardDesc=$P(^PAWARD(wardId),"^",2)
	  	...i wardDesc["-" s wardDesc=$P(wardDesc,"-",2)
	  	..s locs(i,"WardDesc")=wardDesc
	  	.q:locId=""
	  	.s locDesc=$p(^CTLOC(locId),"^",2)
	  	.i locDesc["-" s locDesc=$p(locDesc,"-",2)
	  	.q:lastLocId=locId
	  	.s startDate=$P(^PAADM(episodId,"TRANS",chl),"^",1)
	  	.s startTime=$P(^PAADM(episodId,"TRANS",chl),"^",2)
	  	.s endDate=$P(^PAADM(episodId,"TRANS",chl),"^",3)
	    .s endTime=$P(^PAADM(episodId,"TRANS",chl),"^",4)
	    .i (lastLocId'="") d
	    ..s locs(i,"EndDate")=startDate
	    ..s locs(i,"EndTime")=startTime
	    ..s i=i+1
	  	.s locs(i,"LocId")=locId
	  	.s locs(i,"LocDesc")=locDesc
	  	.s locs(i,"StartDate")=startDate
	  	.s locs(i,"StartTime")=startTime
	    .s lastLocId=locId
	    s locs(i,"EndDate")=""
	    s locs(i,"EndTime")=""
	    s searchDateTime=searchDate*100000+searchTime
	    s i="" f  s i=$o(locs(i)) q:((i="")!($g(targLocId)'=""))  d
	    .s startDate=locs(i,"StartDate")
	    .s startTime=locs(i,"StartTime")
	    .s startDateTime=startDate*100000+startTime
	    .s endDate=locs(i,"EndDate")
	    .s endTime=locs(i,"EndTime")
	    .s endDateTime=endDate*100000+endTime
	    .q:(searchDateTime<startDateTime)
	    .q:(searchDateTime>endDateTime)&&(endDateTime'=0)
	    .s targLocId=locs(i,"LocId")
	    .s targLocDesc=locs(i,"LocDesc")
	    q $g(targLocDesc)
}

}
