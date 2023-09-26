Class web.DHCANTimeLine Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      	陈长青
/// CreatDate：    	2015-05-08
/// Description： 	查找麻醉表单时间轴缩放信息
/// Table：        	DHC_AN_TimeLine
/// Input:			opaId：手术申请排班ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANTimeLine","FindTimeLine","59")
Query FindTimeLine(opaId As %String) As %Query(ROWSPEC = "Id,OpaId,StartDateTime,EndDateTime,MinutesPerColumn,EditFlag,DocumentType,UserId,UpdateDateTime")
{
}

ClassMethod FindTimeLineExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	Set qHandle=$lb(0,repid,0)
	if ('##class(User.DHCANOPArrange).%ExistsId(opaId)) quit $$$OK
	if ('$data(^DHCANTimeLine(0,"OPA",opaId))) quit $$$OK
	set timeLineId=0
	for
	{
		set timeLineId=$order(^DHCANTimeLine(0,"OPA",opaId,timeLineId))
		quit:(timeLineId="")
		set timeLineInfo=^DHCANTimeLine(timeLineId)
		set editFlag=$list(timeLineInfo,7)
		continue:("NE"'[editFlag)
		
		set startDate=$list(timeLineInfo,2)
		set startTime=$list(timeLineInfo,3)
		//----------以下时间格式改为MM/dd/yyyy,确保前台格式正确不报错 YuanLin 20170816
		i startDate'="" s startDate=$zd(startDate,1)
	    s startTime=##class(web.DHCClinicCom).ConvertToTime(startTime)
	    s startDateTime=startDate_" "_startTime
		;set startDateTime=##class(web.DHCClinicCom).ConvertToDateTime(startDate,startTime)
		//----------
		
		set endDate=$list(timeLineInfo,4)
		set endTime=$list(timeLineInfo,5)
		//----------以下时间格式改为MM/dd/yyyy,确保前台格式正确不报错 YuanLin 20170816
		i endDate'="" s endDate=$zd(endDate,1)
	    s endTime=##class(web.DHCClinicCom).ConvertToTime(endTime)
	    s endDateTime=endDate_" "_endTime
		;set endDateTime=##class(web.DHCClinicCom).ConvertToDateTime(endDate,endTime)
		//----------
		
		set minutesPerColumn=$list(timeLineInfo,6)
		set documentType=$list(timeLineInfo,8)
		set userId=$list(timeLineInfo,9)
		
		set updateDate=$list(timeLineInfo,10)
		set updateTime=$list(timeLineInfo,11)
		//----------以下时间格式改为MM/dd/yyyy,确保前台格式正确不报错 YuanLin 20170816
		i updateDate'="" s updateDate=$zd(updateDate,1)
	    s updateTime=##class(web.DHCClinicCom).ConvertToTime(updateTime)
	    s updateDateTime=updateDate_" "_updateTime
		;set updateDateTime=##class(web.DHCClinicCom).ConvertToDateTime(updateDate,updateTime)
		//----------
		do OutputRow	
	}

 	Quit $$$OK
OutputRow
 	Set Data=$lb(timeLineId,opaId,startDateTime,endDateTime,minutesPerColumn,editFlag,documentType,userId,updateDateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindTimeLineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTimeLineExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTimeLineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTimeLineExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-05-08
/// Description： 	保存时间轴的缩放信息
/// Table：        	DHC_AN_TimeLine
/// Input:			opaId：手术申请排班ID,timeLinePara时间轴缩放信息
/// Return：       	保存成功返回"0#"_ID(多个ID以"^"连接)，失败返回失败原因
/// w ##class(web.DHCANTimeLine).SaveTimeLine("","")
ClassMethod SaveTimeLine(opaId, timeLinePara) As %String
{
	s ^TEMPYQ("0528")=opaId_"^"_timeLinePara
	set mainSplitChar="^",subSplitChar=$c(3)
	set timeLineCount=$length(timeLinePara,mainSplitChar)
	set timeLineIdBuilder=""
	tstart
	for i=1:1:timeLineCount
	{
		kill PLIST
		set singleTimeLinePara=$piece(timeLinePara,mainSplitChar,i)
		set timeLineId=$piece(singleTimeLinePara,subSplitChar,1)
		if (##class(User.DHCANTimeLine).%ExistsId(timeLineId))
		{
			b ;0
			&sql(select * into :PLIST() from SQLUser.DHC_AN_TimeLine where %ID=:timeLineId)	
		}
		
		// OPA_DR
		set PLIST(2)=opaId
		// StartDate
		set PLIST(3)=##class(web.DHCClinicCom).ConvertToDateH($piece(singleTimeLinePara,subSplitChar,2))
		// StatTime	
		set PLIST(4)=##class(web.DHCClinicCom).ConvertToTimeH($piece(singleTimeLinePara,subSplitChar,3))
		// EndDate
		set PLIST(5)=##class(web.DHCClinicCom).ConvertToDateH($piece(singleTimeLinePara,subSplitChar,4))
		// EndTime
		set PLIST(6)=##class(web.DHCClinicCom).ConvertToTimeH($piece(singleTimeLinePara,subSplitChar,5))
		//MinutesPerTime
		set minutesPerColumn=+$piece(singleTimeLinePara,subSplitChar,6)
		if (minutesPerColumn>0)
		{
			set PLIST(7)=minutesPerColumn	
		}
		//UpdateDate
		set PLIST(8)=+$horolog
		//UpdateTime
		set PLIST(9)=$piece($horolog,",",2)
		//EditFlag
		set PLIST(10)=$piece(singleTimeLinePara,subSplitChar,7)
		//DocumentType
		set PLIST(11)=$piece(singleTimeLinePara,subSplitChar,8)
		//UserDR
		set PLIST(12)=$piece(singleTimeLinePara,subSplitChar,9)
		if (##class(User.DHCANTimeLine).%ExistsId(timeLineId))
		{
			&sql(update SQLUser.DHC_AN_TimeLine values :PLIST() where %ID=:timeLineId)
		}
		else
		{
			&sql(insert into SQLUser.DHC_AN_TimeLine values :PLIST())	
		}
		if (SQLCODE'=0) trollback  quit
		if (i=1)
		{
			set timeLineIdBuilder=%ROWID	
		}
		else
		{
			set timeLineIdBuilder=timeLineIdBuilder_"^"_%ROWID
		}
	}
	
	if (SQLCODE'=0) quit "ErrorCode:"_SQLCODE_", ErrorText:"_$SYSTEM.SQL.SQLCODE(SQLCODE)
	
	tcommit
	
	quit "0#"_timeLineIdBuilder
}

/// Creator：      	杨勤
/// CreatDate：    	2015-05-29
/// Description： 	删除时间轴的缩放信息
/// Table：        	DHC_AN_TimeLine
/// Input:			opaId：手术申请排班ID,timeLineId时间轴缩放信息ID
/// Return：       	删除成功返回"0"，失败返回失败原因
/// w ##class(web.DHCANTimeLine).DeleteTimeLine("","")
ClassMethod DeleteTimeLine(opaId, timeLineId) As %String
{
	q:opaId=""
	i (##class(User.DHCANTimeLine).%ExistsId(timeLineId)=0) q
	
	s TimeLineId=0
	f  s TimeLineId=$o(^DHCANTimeLine(0,"OPA",opaId,TimeLineId)) q:TimeLineId=""  d
	. q:(TimeLineId'=timeLineId)
	.&sql(delete from SQLUser.DHC_AN_TimeLine where %ID=:TimeLineId)
	i SQLCODE'=0 q "数据删除失败！"
	q 0
}

}
