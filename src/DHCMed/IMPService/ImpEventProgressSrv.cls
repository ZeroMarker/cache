/// 事件进程处理
/// 作者：李阳
/// 创建日期：2011-01-16
Class DHCMed.IMPService.ImpEventProgressSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

///  创建者：李阳
///  创建日期：2011-01-13
///  功能：查询重点患者历次进程记录
///  参数：ImpID--重点患者记录的ID
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.IMPService.ImpEventProgressSrv","QueryByImpPatientID",33)
Query QueryByImpPatientID(ImpID As %String) As %Query(ROWSPEC = "EventID:%String,ImpPatientID:%String,EventDate:%String:发生日期,EventTime:%String:发生时间,Category:%String:类别,Title:%String:标题,RecordUser:%String:记录人,RecordDate:%String:记录日期,RecordTime:%String:记录时间,DutyUser:%String")
{
}

ClassMethod QueryByImpPatientIDExecute(ByRef qHandle As %Binary, ImpID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	s rowid="" f  s rowid=$o(^DHCMed.IMP.ImpEventProgressI("ImpPatientIDIndex",ImpID,rowid),-1) q:rowid=""  d
	.s obj=##class(DHCMed.IMP.ImpEventProgress).%OpenId(rowid)
	.q:$IsObject(obj)=0
	.d obj.%Close()
	.s objUser=##class(DHCMed.Base.SSUser).GetObjById(obj.RecordUser)
	.s RecordUser=""
	.i $IsObject(objUser)  d
	..s RecordUser=objUser.Name
	..d objUser.%Close()
	..k objUser
	.s objCate=##class(DHCMed.SS.Dictionary).GetByTypeCode("IMPEVENTPROGRESSCATEGORY", obj.Category, 1)
	.d objCate.%Close()
	.s data=$lb("")
	.s $li(data,1)=obj.%Id()
	.s $li(data,2)=obj.ImpPatientID
	.s $li(data,3)=$s(obj.EventDate="":"",1:$zd(obj.EventDate,3))
	.s $li(data,4)=$s(obj.EventTime="":"",1:$zt(obj.EventTime,1))
	.s $li(data,5)=objCate.Description
	.s $li(data,6)=obj.Title
	.s $li(data,7)=RecordUser
	.s $li(data,8)=$s(obj.RecordDate="":"",1:$zd(obj.RecordDate,3))
	.s $li(data,9)=$s(obj.RecordTime="":"",1:$zt(obj.RecordTime,1))
	.Set objUser=##class(DHCMed.Base.SSUser).GetObjById(obj.DutyUser)
	.Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	.Do objUser.%Close()
	.s $li(data,10)=objUser.Name
	.Set objUser=""
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	.k obj
	Quit $$$OK
}

ClassMethod QueryByImpPatientIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByImpPatientIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryByImpPatientIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByImpPatientIDExecute ]
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

/// 按发生日期查询时间进展记录
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.IMPService.ImpEventProgressSrv","QueryByDutyPerson","2011-12-1","2011-12-31","")
Query QueryByDutyPerson(FromDate As %String, ToDate As %String, DutyPerson As %String) As %Query(ROWSPEC = "EventID:%String,ImpID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,PatientTypeID:%String,PatientType:%String:大类,PatientSubTypeID:%String,PatientSubType:%String:子类,EventDate:%String:事件日期,EventTime:%String:事件时间,EventType:%String:事件类别,Title:%String:标题,EventContents:%String:内容,DutyUser:%String:承办人")
{
}

ClassMethod QueryByDutyPersonExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, DutyPerson As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)	
	For tmpDate=FromDate:1:ToDate 
	{
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.IMP.ImpEventProgressI("EventDateIndex",tmpDate,RowID))
			Quit:RowID=""
			Set objEvent=##class(DHCMed.IMP.ImpEventProgress).%OpenId(RowID)
			Continue:$IsObject(objEvent)=0
			Do objEvent.%Close()
			Continue:((objEvent.DutyUser'=DutyPerson)&&(DutyPerson'=""))
			Set data=$$BuildQueryByDutyPerson(objEvent)
			Set ^CacheTemp(repid,ind)=data
			Set ind=ind+1
		}
		
	}
	Quit $$$OK
BuildQueryByDutyPerson(objEvent)
	n (objEvent)
	Set data=$lb("")
	Set $li(data,1)=objEvent.%Id() //EventID:%String
	Set $li(data,2)=objEvent.ImpPatientID //ImpID:%String
	Set objImp=##class(DHCMed.IMP.ImpPatient).%OpenId(objEvent.ImpPatientID)
	Do objImp.%Close()
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objImp.PatientID)
	do objPatient.%Close()
	Set $li(data,3)=objPatient.PapmiNo //RegNo:%String:登记号
	Set $li(data,4)=objPatient.PatientName //PatientName:%String:患者姓名
	Set objPatSubType=##class(DHCMed.IMP.PatientTypeSub).GetObjById(objImp.ImpType)
	Do objPatSubType.%Close()
	Set objPatType=##class(DHCMed.IMP.PatientType).GetObjById(objPatSubType.ParentID)
	Do objPatType.%Close()
	Set $li(data,5)=objPatType.%Id() //PatientTypeID:%String
	Set $li(data,6)=objPatType.Description //PatientType:%String:大类
	Set $li(data,7)=objPatSubType.%Id() //PatientSubTypeID:%String
	Set $li(data,8)=objPatSubType.Description //PatientSubType:%String:子类
	Set $li(data,9)=$s(objEvent.EventDate'="":$zd(objEvent.EventDate,3),1:"") //EventDate:%String:事件日期
	Set $li(data,10)=$s(objEvent.EventTime'="":$zt(objEvent.EventTime,1),1:"") //EventTime:%String:事件时间
	Set objEventType=##class(DHCMed.SS.Dictionary).GetObjById(objEvent.Category)
	Do objEventType.%Close()
	Set $li(data,11)=objEventType.Description //EventType:%String:事件类别
	Set $li(data,12)=objEvent.Title //Title:%String:标题
	Set $li(data,13)=objEvent.Contents //EventContents:%String:内容
	Set objDutyUser=##class(DHCMed.Base.SSUser).GetObjById(objEvent.DutyUser)
	Do objDutyUser.%Close()
	Set $li(data,14)=objDutyUser.Name //DutyUser:%String:承办人	
	Quit data
}

ClassMethod QueryByDutyPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByDutyPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryByDutyPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByDutyPersonExecute ]
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
