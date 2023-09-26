/// 名称: DtPortal.DD.DD18CriticalValue
/// 描述: 查询科室某月危急值相应超时数量
/// 编写者：程鹏
/// 编写日期:2019-01-29
Class DtPortal.DD.DD18CriticalValue Extends %RegisteredObject
{

// DD18.01.01查询科室某月危急值相应超时数量

// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD18CriticalValue","DD180101","2019-01-01","2019-01-31","110")

Query DD180101(StartDate As %String, EndDate As %String, LocGroupId As %String) As DtPortal.Query(ROWSPEC = "ind,EpisodeId,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,TSName,ReportDate,ReportTime,TransDate,TransTime,TransUser,ReportStatusDesc,Summary,ReportDateTime") [ SqlProc ]
{
}

ClassMethod DD180101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set LocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(LocGroupId,"I")
	
	for index=1:1:$l(LocStr,"^")
	{
		set locID=$p(LocStr,"^",index)
		continue:locID=""
		Set rset = ##class(%ResultSet).%New("DtPortal.MD.MD09CriticalValue:MD090102")
		Do rset.Execute(StartDate,EndDate,locID)
		While (rset.Next()) {
			set EpisodeId=rset.Data("EpisodeId")
			set bedCode=rset.Data("bedCode")
			set name=rset.Data("name")
			set sex=rset.Data("sex")
			set age=rset.Data("age")
			set medicareNo=rset.Data("medicareNo")
			set admReason=rset.Data("admReason")
			set regNo=rset.Data("regNo")
			set docDesc=rset.Data("docDesc")
			set locDesc=rset.Data("locDesc")
			set wardDesc=rset.Data("wardDesc")
			set diagnoseDesc=rset.Data("diagnoseDesc")
			set inDay=rset.Data("inDay")
			set inDateTime=rset.Data("inDateTime")
			set TSName=rset.Data("TSName")					//危急值检查项目
			set ReportTime=rset.Data("ReportTime")			//危急值报告时间
			set ReportDate=rset.Data("ReportDate")	//危急值报告日期
			set TransDate=rset.Data("TransDate")			//危急值处理日期
			set TransTime=rset.Data("TransTime")			//危急值处理时间
			set TransUser=rset.Data("TransUser")			//危急值处理人
			set ReportStatusDesc=rset.Data("ReportStatusDesc")		//危急值状态
			set Summary=rset.Data("Summary")					//提示信息
			set ReportDateTime=ReportDate
			set ^||CacheTemp(repid,ind)=$lb(ind,EpisodeId,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,TSName,ReportDate,ReportTime,TransDate,TransTime,TransUser,ReportStatusDesc,Summary,ReportDateTime)
			set ind=ind+1	

		}
	}
	
	

	Quit $$$OK
}

}
