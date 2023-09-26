/// 统计
Class DHCMed.IMPService.IMPSta Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 统计每个员工工作量
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.IMPService.IMPSta","StaWorkLoad","2010-1-1","2011-12-31",1)
Query StaWorkLoad(FromDate As %String, ToDate As %String, PatType As %String) As %Query(ROWSPEC = "UserName:%String:用户名,Start:%String:开始数量,End:%String:结束数量,StartEnd:%String:开始且结束,InProgress:%String:有进展数量,NoProgress:%String:无进展数量,Total:%String:小计")
{
}

ClassMethod StaWorkLoadExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, PatType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	For tmpDate=FromDate:1:ToDate {
		Set tmpTime=""
		For {
			Set tmpTime=$o(^DHCMed.IMP.ImpPatientI("IndexFromDate",tmpDate,tmpTime))
			Quit:tmpTime=""
			Set rowid=""
			For {
				Set rowid=$o(^DHCMed.IMP.ImpPatientI("IndexFromDate",tmpDate,tmpTime,rowid))
				Quit:rowid=""
				Set objIMP=##class(DHCMed.IMP.ImpPatient).GetObjById(rowid)
				Continue:$IsObject(objIMP)=0
				Do objIMP.%Close()
				Set objSubType=##class(DHCMed.IMP.PatientTypeSub).GetObjById(objIMP.ImpType)
				Do objSubType.%Close()
				Continue:objSubType.ParentID'=PatType
				Set tmp=$g(^CacheTemp("StaWorkLoadExecute",repid,objIMP.DutyUser))
				Set $p(tmp,"^",1)=$p(tmp,"^",1)+1 //开始事务数量
				Set:((objIMP.ToDate>=FromDate)&&(objIMP.ToDate<=ToDate)) $p(tmp,"^",2)=$p(tmp,"^",2)+1 //新发且结束
				Set hasProgress=$$HasProgressRec(rowid,FromDate,ToDate) //是否有进展事件
				Set:hasProgress=1 $p(tmp,"^",4)=$p(tmp,"^",4)+1 //有进展
				Set:hasProgress=0 $p(tmp,"^",5)=$p(tmp,"^",5)+1 //无进展
				Set ^CacheTemp("StaWorkLoadExecute",repid,objIMP.DutyUser)=tmp
			}
		}
		For {
			Set tmpTime=$o(^DHCMed.IMP.ImpPatientI("IndexToDate",tmpDate,tmpTime))
			Quit:tmpTime=""
			Set rowid=""
			For {
				Set rowid=$o(^DHCMed.IMP.ImpPatientI("IndexToDate",tmpDate,tmpTime,rowid))
				Quit:rowid=""
				Set objIMP=##class(DHCMed.IMP.ImpPatient).GetObjById(rowid)
				Continue:$IsObject(objIMP)=0
				Set tmp=$g(^CacheTemp("StaWorkLoadExecute",repid,objIMP.DutyUser))
				Set $p(tmp,"^",3)=$p(tmp,"^",3)+1 //结束事务数量
				Set ^CacheTemp("StaWorkLoadExecute",repid,objIMP.DutyUser)=tmp
			}
		}		
	}
	Set UserID=""
	For {
		Set UserID=$o(^CacheTemp("StaWorkLoadExecute",repid,UserID))
		Quit:UserID=""
		Set objUser=##class(DHCMed.Base.SSUser).GetObjById(UserID)
		Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
		Set tmp=$g(^CacheTemp("StaWorkLoadExecute",repid,UserID))
		Set data=$lb("")
		Set $li(data,1)=objUser.Name
		Set $li(data,2)=$p(tmp,"^",1) //新发事务
		Set $li(data,3)=$p(tmp,"^",3) //结束事务数量
		Set $li(data,4)=$p(tmp,"^",2) //新发且结束
		Set $li(data,5)=$p(tmp,"^",4) //进展事务数量
		Set $li(data,6)=$p(tmp,"^",5) //无进展事务数量
		Set $li(data,7)=$li(data,2)+$li(data,3)+$li(data,4)+$li(data,5)+$li(data,6) //小计
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Kill ^CacheTemp("StaWorkLoadExecute",repid)
	Quit $$$OK

HasProgressRec(ImpID,FromDate,ToDate) //判断在指定日期中是否有事件进展记录
	n (ImpID,FromDate,ToDate)
	Set ret=0
	For tmpDate=FromDate:1:ToDate {
		Set rowid=""
		For {
			Set rowid=$o(^DHCMed.IMP.ImpEventProgressI("EventDateIndex",tmpDate,rowid))
			Quit:rowid=""
			Set:($d(^DHCMed.IMP.ImpEventProgressI("EventDateIndex",ImpID,rowid))'=0) ret=1
		}
	}
	Quit ret
}

ClassMethod StaWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaWorkLoadExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 统计工作完成情况
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.IMPService.IMPSta","StaTimeListStaff","2010-1-1","2011-12-31")
Query StaTimeListStaff(FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "UserID:%String,UserName:%String:用户名,NeedComplete:%String:应完成,Complete:%String:已完成,NotComplete:%String:未完成")
{
}

ClassMethod StaTimeListStaffExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	For tmpDate=FromDate:1:ToDate {
		Set rowid=""
		For {
			Set rowid=$o(^DHCMed.IMP.ImpPatientI("IndexWillToDate",tmpDate,rowid))
			Quit:rowid=""
			Set objIMP=##class(DHCMed.IMP.ImpPatient).GetObjById(rowid)
			Continue:$IsObject(objIMP)=0
			Do objIMP.%Close()
			Set tmp=$g(^CacheTemp("StaTimeListStaffExecute",repid,objIMP.DutyUser))
			Set $p(tmp,"^",1)=$p(tmp,"^",1)+1 //应完成数量
			Set:(+objIMP.ToDate)'=0 $p(tmp,"^",2)=$p(tmp,"^",2)+1 //完成数量
			Set:(+objIMP.ToDate)=0 $p(tmp,"^",3)=$p(tmp,"^",3)+1 //未完成数量
			Set ^CacheTemp("StaTimeListStaffExecute",repid,objIMP.DutyUser)=tmp
		}
	}
	For {
		Set UserID=$o(^CacheTemp("StaTimeListStaffExecute",repid,UserID))
		Quit:UserID=""
		Set objUser=##class(DHCMed.Base.SSUser).GetObjById(UserID)
		Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
		Set tmp=$g(^CacheTemp("StaTimeListStaffExecute",repid,UserID))
		Set data=$lb("")
		Set $li(data,1)=objUser.Name
		Set $li(data,2)=$p(tmp,"^",1) //应完成数量
		Set $li(data,3)=$p(tmp,"^",2) //完成数量
		Set $li(data,4)=$p(tmp,"^",3) //未完成数量
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Kill ^CacheTemp("StaTimeListStaffExecute",repid)
	Quit $$$OK
}

ClassMethod StaTimeListStaffClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaTimeListStaffExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaTimeListStaffFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaTimeListStaffExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 按类别统计工作量
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.IMPService.IMPSta","StaWorkLoadByPatType","2011-1-1","2011-12-31",1)
Query StaWorkLoadByPatType(FromDate As %String, ToDate As %String, PatType As %String) As %Query(ROWSPEC = "SubTypeID:%String,SubType:%String:类别,Start:%String:开始数量,End:%String:结束数量,StartEnd:%String:开始且结束,InProgress:%String:有进展数量,NoProgress:%String:无进展数量,Total:%String:小计")
{
}

ClassMethod StaWorkLoadByPatTypeExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, PatType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	For tmpDate=FromDate:1:ToDate {
		Set rowid=""
		For {
			Set rowid=$o(^DHCMed.IMP.ImpPatientI("IndexWillToDate",tmpDate,rowid))
			Quit:rowid=""
			Set objIMP=##class(DHCMed.IMP.ImpPatient).GetObjById(rowid)
			Continue:$IsObject(objIMP)=0
			Do objIMP.%Close()
			Set objSubType=##class(DHCMed.IMP.PatientTypeSub).GetObjById(objIMP.ImpType)
			Do objSubType.%Close()
			Continue:objSubType.ParentID'=PatType
			Set tmp=$g(^CacheTemp("StaWorkLoadByPatTypeExecute",repid,objIMP.ImpType))
			Set $p(tmp,"^",1)=$p(tmp,"^",1)+1 //开始事务数量
			Set:((objIMP.ToDate>=FromDate)&&(objIMP.ToDate<=ToDate)) $p(tmp,"^",2)=$p(tmp,"^",2)+1 //新发且结束
			Set hasProgress=$$HasProgressRec(rowid,FromDate,ToDate) //是否有进展事件
			Set:hasProgress=1 $p(tmp,"^",4)=$p(tmp,"^",4)+1 //有进展
			Set:hasProgress=0 $p(tmp,"^",5)=$p(tmp,"^",5)+1 //无进展
			Set ^CacheTemp("StaWorkLoadByPatTypeExecute",repid,objIMP.ImpType)=tmp
		}
	}
	Set SubTypeID=""
	For {
		Set SubTypeID=$o(^CacheTemp("StaWorkLoadByPatTypeExecute",repid,SubTypeID))
		Quit:SubTypeID=""
		Set objSubType=##class(DHCMed.IMP.PatientTypeSub).GetObjById(SubTypeID)
		Do objSubType.%Close()
		Set tmp=$g(^CacheTemp("StaWorkLoadByPatTypeExecute",repid,SubTypeID))
		Set data=$lb("")
		Set $li(data,1)=objSubType.%Id()
		Set $li(data,2)=objSubType.Description
		Set $li(data,3)=$p(tmp,"^",1) //新发事务
		Set $li(data,4)=$p(tmp,"^",3) //结束事务数量
		Set $li(data,5)=$p(tmp,"^",2) //新发且结束
		Set $li(data,6)=$p(tmp,"^",4) //进展事务数量
		Set $li(data,7)=$p(tmp,"^",5) //无进展事务数量
		Set $li(data,8)=$li(data,3)+$li(data,4)+$li(data,5)+$li(data,6)+$li(data,7) //小计
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Kill ^CacheTemp("StaWorkLoadByPatTypeExecute",repid)
	Quit $$$OK
}

ClassMethod StaWorkLoadByPatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaWorkLoadByPatTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaWorkLoadByPatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaWorkLoadByPatTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
