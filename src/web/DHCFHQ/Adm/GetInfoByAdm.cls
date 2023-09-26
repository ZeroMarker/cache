/// 根据ADM获取相关信息
Class web.DHCFHQ.Adm.GetInfoByAdm Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 获取请假证明信息
ClassMethod LeaveProv(repid, StartDate, EndDate As %String)
{
	//d ##class(%ResultSet).RunQuery("web.DHCFHQ.AdmInfo","LeaveProve","2011-11-01","2011-11-23")
	s del="^",RetNum=0
	q:StartDate="" RetNum
	q:EndDate="" RetNum
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s SDate=StartDate-1
	f  s SDate=$o(^DHCDocDisPro(0,"ProveDate",SDate)) q:((SDate>EndDate)!(SDate=""))  d
	.s DisProveId=0
	.f  s DisProveId=$o(^DHCDocDisPro(0,"ProveDate",SDate,DisProveId)) q:DisProveId=""  d
	..s AdmId=$p(^DHCDocDisPro(DisProveId),del,2)
	..s PrintFlag=$p(^DHCDocDisPro(DisProveId),del,5)
	..q:$g(PrintFlag)'="Y"
	..s ProveContext=$p(^DHCDocDisPro(DisProveId),del,1)
	..s PatInfo=##class(web.DHCFHQ.Common.PatAdmInfo).GetPatInfoByAdmId(AdmId)
	..;b ;
	..Q:$g(PatInfo)=""
	..s AdmInfo=##class(web.DHCFHQ.Common.PatAdmInfo).GetAdmInfoByAdm(AdmId)
	..q:$g(AdmInfo)=""
	..s LocDesc=$p(AdmInfo,del,3),DocDesc=$p(AdmInfo,del,12)
	..s PatNo=$p(PatInfo,del,2),PatName=$p(PatInfo,del,3),Sex=$p(PatInfo,del,5),BirthDay=$p(PatInfo,del,6)
	..s RetNum=RetNum+1
	..s ^CacheTempFHQ(repid,RetNum)=$lb(PatNo,PatName,Sex,BirthDay,LocDesc,DocDesc)
	..
	q RetNum
}

}
