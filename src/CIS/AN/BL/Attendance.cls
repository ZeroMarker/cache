Class CIS.AN.BL.Attendance Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-1-8
/// Description： 	查询手术间
/// Table：        	OperRoom
/// Input:			
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.Attendance.SaveAttendance(，296，10850)
ClassMethod SaveAttendance(data As %String, deptId As %String, userId As %String) As %String
{
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	set ^TMPYGB("SaveAttendance")=data
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult="S^"
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		kill attendance
		merge attendance=array(objIndex)
		continue:($g(attendance("ClassName"))'="CIS.AN.Attendance")
		
		set attendance("UpdateUser")=userId
		set attendance("UpdateDate")=+$h
		set attendance("UpdateTime")=$p($h,",",2)
		
		if ($g(attendance("isRemoved"))="Y")
		{
			if ($g(attendance("RowId"))'="") set saveResult=##class(CIS.AN.COM.DataService).DelData(attendance("ClassName"),attendance("RowId"))
		}
		else
		{
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.attendance)
		}
		quit:($piece(saveResult,"^",1)'="S")
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-25
/// Description： 	查询考勤数据
/// Table：        	CIS.AN.Attendance
/// Input:			attendDate,deptId
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Attendance","FindAttendance","2020-5-21","296")
Query FindAttendance(attendDate As %String, deptId As %String) As %Query(ROWSPEC = "RowId,AttendDate,Dept,Member,MemberName,Shift,AuditUser,AuditDate,AuditTime") [ SqlProc ]
{
}

ClassMethod FindAttendanceExecute(ByRef qHandle As %Binary, attendDate As %String, deptId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	set attendDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(attendDate,"")
	
	set resultSet=##class(%ResultSet).%New("CIS.AN.BL.DataQueries:FindAttendance")
	set sc=resultSet.Execute(attendDateH,deptId)
	while(resultSet.%Next())
	{
		set RowId=resultSet.Get("RowId")
		set AttendDate=resultSet.Get("AttendDate")
		set Dept=resultSet.Get("Dept")
		set Member=resultSet.Get("Member")
		set MemberName=resultSet.Get("MemberName")
		set Shift=resultSet.Get("Shift")
		set AuditUser=resultSet.Get("AuditUser")
		set AuditDate=resultSet.Get("AuditDate")
		set AuditTime=resultSet.Get("AuditTime")
		do OutputRow
	}

	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(RowId,AttendDate,Dept,Member,MemberName,Shift,AuditUser,AuditDate,AuditTime)
	s ind=ind+1
	q
}

ClassMethod FindAttendanceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAttendanceExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAttendanceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAttendanceExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-01-24
/// Description： 	查询考勤信息
/// Table：        	CIS.AN.Attendance
/// Input:			attendDate：日期，deptId：科室
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Attendance","FindAttendanceByCode","2020-05-21","296")
Query FindAttendanceByCode(attendDate As %String, deptId As %String, workCode As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	   Shift->Status->Description As WorkDesc,
	   Shift->Status->Code As WorkCode,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",Member) As MemberName
	   From CIS_AN.Attendance
	   where AttendDate=%ODBCIN(:attendDate)
	   and Dept=:deptId
	   and (Shift->Status->Code=:workCode or :workCode is null)
}

/// w ##class(CIS.AN.BL.Attendance).GetAttendanceInfo("2020-05-20","296")
ClassMethod GetAttendanceInfo(attendDate As %String, deptId As %String) As %String
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.Attendance:FindAttendanceByCode")
	if (attendDate["/") set attendDate=$zd($zdh(attendDate,4),3)
	set sc=rs.Execute(attendDate,deptId)
	set workCode="",preCode="",member="",count=0
	k dataArr
	while(rs.%Next())
	{
		set workCode=rs.Get("Shift")
		if ($get(dataArr(1,workCode))'="")
		{
			set dataArr(1,workCode)=dataArr(1,workCode)_","_rs.Get("MemberName")	
		}
		else
		{
			set dataArr(1,workCode)=rs.Get("MemberName")	
		}
	}	
	
	set ret=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit ret
}

/// w ##class(CIS.AN.BL.Attendance).GetAttendanceForCareProv("2019-04-16","201")
ClassMethod GetAttendanceForCareProv(attendDate As %String, deptId As %String, careProvId As %String) As %String
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.Attendance:FindAttendanceByCode")
	set sc=rs.Execute(attendDate,deptId)
	set workDesc="",workCode=""
	while(rs.%Next())
	{
		set member=rs.Get("Member")
		if (member=careProvId)
		{
			set:(workDesc'="") workDesc=workDesc_"，"
			set:(workCode'="") workCode=workCode_"，"
			set workDesc=workDesc_rs.Get("WorkDesc")
			set workCode=workCode_rs.Get("WorkCode")	
		}
		
	}	
	quit:(workCode="") ""
	quit workCode_"^"_workDesc
}

ClassMethod GetShiftByCode(statusCode As %String, deptId As %String, floorId As %String = "") As CF.AN.CrewShift
{
	set shiftId=""
	&sql(select RowId into :shiftId from CF_AN.CrewShift where Status->Code=:statusCode and Dept=:deptId and ((floor=:floorId) or (:floorId is null)))	
	set crewShift=##class(CF.AN.CrewShift).%OpenId(shiftId)
	quit crewShift
}

ClassMethod SaveAttendanceSimple(dataPara As %String) As %String
{
}

}
