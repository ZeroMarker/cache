Import SQLUser

Class web.DHCBPVascularAccessImageMark Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取上机穿刺点位
/// d ##class(%ResultSet).RunQuery("web.DHCBPVascularAccessImageMark","FindVascularAccessImageMark","2022-11-30","2022-12-30","","472","N")
Query FindVascularAccessImageMark(fromDate As %String, toDate As %String, arrangeId As %String = "", vascularAccessId As %String = "", curStatus As %String = "N") As %Query(ROWSPEC = "Id,ArrangeId,VascularAccessId,PointType,PointNum,PointX,PointY,Status,CtcpId,CtcpDesc,Date,Time,Note") [ SqlProc ]
{
}

ClassMethod FindVascularAccessImageMarkExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, arrangeId As %String = "", vascularAccessId As %String = "", curStatus As %String = "N") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	i (arrangeId="")&&(vascularAccessId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s bpvaimId=""
	if (arrangeId'="")
	{
		f  s bpvaimId=$o(^DHCBPVascularAccessImageMark(0,"Arrange",arrangeId,bpvaimId)) q:bpvaimId=""  d
			.q:$$GetVascularAccessImageMark()<0
			.d OutputRow
	}
	if (vascularAccessId'="")
	{
		f  s bpvaimId=$o(^DHCBPVascularAccessImageMark(0,"VascularAccess",vascularAccessId,bpvaimId)) q:bpvaimId=""  d
			.q:$$GetVascularAccessImageMark()<0
			.s bpaId=$lg(^DHCBPVascularAccessImageMark(bpvaimId),1)
			.w bpaId,!
			.s bpaDate=$lg(^DHCBPArrange(bpaId),4)
			.w bpaDate_"/"_fromDate_"/"_toDate,!
			.q:(fromDate'="")&&(fromDate>bpaDate)
			.q:(toDate'="")&&(toDate<bpaDate)
			.d OutputRow
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetVascularAccessImageMark()
	q:bpvaimId="" -1
	s Id=bpvaimId
	//w bppId,!
	//s bebGroupId=$lg(^DHCBPPatSetUpBedGroup(bppId),1)
	s ArrangeId=$lg(^DHCBPVascularAccessImageMark(bpvaimId),1)
	s VascularAccessId=$lg(^DHCBPVascularAccessImageMark(bpvaimId),2)	
	s PointX=$lg(^DHCBPVascularAccessImageMark(bpvaimId),3)
	s PointY=$lg(^DHCBPVascularAccessImageMark(bpvaimId),4)
	s Status=$lg(^DHCBPVascularAccessImageMark(bpvaimId),7)		
	q:(curStatus'="")&&(curStatus'=Status) -3
	i Status="N" s Status="正常"
	i Status="D" s Status="删除"
	s CtcpId=$lg(^DHCBPVascularAccessImageMark(bpvaimId),8)
	s CtcpDesc=""
	i CtcpId'="" d
		.s CtcpDesc=##class(web.DHCBPCom).GetNameById(CtcpId)
	s Date=$lg(^DHCBPVascularAccessImageMark(bpvaimId),9)	
	i Date'="" d
		.s Date=##class(web.DHCClinicCom).ConvertToDate(Date)
	s Time=$lg(^DHCBPVascularAccessImageMark(bpvaimId),10)
	i Time'="" d
		.s Time=##class(web.DHCClinicCom).ConvertToTime(Time)
	s PointType=$lg(^DHCBPVascularAccessImageMark(bpvaimId),11)
	s PointNum=$lg(^DHCBPVascularAccessImageMark(bpvaimId),12)
	s Note=$lg(^DHCBPVascularAccessImageMark(bpvaimId),13)
	q 0    
OutputRow
	set Data=$lb(Id,ArrangeId,VascularAccessId,PointType,PointNum,PointX,PointY,Status,CtcpId,CtcpDesc,Date,Time,Note)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindVascularAccessImageMarkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVascularAccessImageMarkExecute ]
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

ClassMethod FindVascularAccessImageMarkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVascularAccessImageMarkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 保存上机穿刺点位
/// w ##class(web.DHCBPVascularAccessImageMark).SaveVascularAccessImageMark("114912^N^196")
ClassMethod SaveVascularAccessImageMark(VascularAccessImageMarkStr) As %String
{
	s result=""
	q:VascularAccessImageMarkStr="" "无保存数据"
	s arrangeId=$P(VascularAccessImageMarkStr,"^",1) //透析记录ID
	s vascularAccessId=$P(VascularAccessImageMarkStr,"^",2) //预约、取消预约
	s type=$P(VascularAccessImageMarkStr,"^",7)
	&sql(update DHC_BP_VascularAccessImageMark set BPVAIM_Status='D' where BPVAIM_BPArrange_Dr=:arrangeId and BPVAIM_BPVascularAccess_Dr=:vascularAccessId and BPVAIM_PointType=:type)
    s VAImageMarkInfo=##class(User.DHCBPVascularAccessImageMark).%New()    
    s VAImageMarkInfo.BPVAIMBPArrangeDr=##class(User.DHCBPArrange).%OpenId(arrangeId)
    s VAImageMarkInfo.BPVAIMBPVascularAccessDr=##class(User.DHCBPVascularAccess).%OpenId(vascularAccessId)
    s VAImageMarkInfo.BPVAIMPointX=$P(VascularAccessImageMarkStr,"^",3)
    s VAImageMarkInfo.BPVAIMPointY=$P(VascularAccessImageMarkStr,"^",4)    
    s VAImageMarkInfo.BPVAIMStatus=$P(VascularAccessImageMarkStr,"^",5)
    s VAImageMarkInfo.BPVAIMUpdateUserDr=$P(VascularAccessImageMarkStr,"^",6)
    s VAImageMarkInfo.BPVAIMUpdateDate=+$h
    s VAImageMarkInfo.BPVAIMUpdateTime=$P($h,",",2)
    s VAImageMarkInfo.BPVAIMPointType=type
    s VAImageMarkInfo.BPVAIMPointNum=$P(VascularAccessImageMarkStr,"^",8)
    s VAImageMarkInfo.BPVAIMNote=$P(VascularAccessImageMarkStr,"^",9)
    s result=VAImageMarkInfo.%Save()
    d VAImageMarkInfo.%Close()
    i result=1 s result=0
    q result
}

/// 插入上机穿刺点位
/// w ##class(web.DHCBPVascularAccessImageMark).VascularAccessImageMarkList("114912^N^196")
ClassMethod InsertVascularAccessImageMark(VascularAccessImageMarkPara) As %String
{
	s result=""
	s SQLCODE=0
    s outerSpliter="&"
	f i=1:1:$l(VascularAccessImageMarkPara,outerSpliter) q:(SQLCODE'=0)&(SQLCODE'=100)  d
	.s imageMarkStr=$p(VascularAccessImageMarkPara,outerSpliter,i)
	.s result=..SaveVascularAccessImageMark(imageMarkStr)
	q result
}

/// w ##class(web.DHCBPVascularAccessImageMark).DeleteVascularAccessImageMark()
ClassMethod DeleteVascularAccessImageMark(bpvaimId) As %String
{
	q:bpvaimId="" "ID不能为空!"	
	s result=0
	&SQL(delete from DHC_BP_VascularAccessImageMark where BPVAIM_RowId=:bpvaimId)
	s result=SQLCODE
	q result
}

}
