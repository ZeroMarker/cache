/// 评价与反馈报表
Class dhc.pa.report.uEstAndFB Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetReportExecute(ByRef qHandle As %Binary, EstAndFB As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:EstAndFB="" $$$OK
	///estDesc_"!"_estUser_"!"_estDate_"!"_fBDesc_"!"_fBUser_"!"_fBDate    //点评和反馈描述
	s estDesc=""  s estUser="" s estDate=""  s fBDesc="" s fBUser=""  s fBDate =""
	
	s estDesc =$p(EstAndFB,"!",1)
	s estUser =$p(EstAndFB,"!",2)
	s estDate =$p(EstAndFB,"!",3) 
	s fBDesc  =$p(EstAndFB,"!",4)
	s fBUser  =$p(EstAndFB,"!",5)
	s fBDate  =$p(EstAndFB,"!",6)
	
	
	d OutputRowDate

 	q $$$OK
 	
OutputRowDate
	
 	s Data=$lb(estDesc,estUser,estDate,fBDesc,fBUser,fBDate)
 	
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2011-11-04
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uEstAndFB","GetReport","评价!评价人!2000-10-10!反馈!反馈人!2011-10-10")
Query GetReport(EstAndFB As %String) As %Query(ROWSPEC = "estDesc:%String,estUser:%String,estDate:%String,fBDesc:%String,fBUser:%String,fBDate:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uEstAndFBS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
