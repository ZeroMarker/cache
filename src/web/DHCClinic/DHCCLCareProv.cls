Class web.DHCClinic.DHCCLCareProv Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2016-05-09
/// Description： 	获取外来医护人员数据
/// Table：        	DHC_CL_CareProv
/// Input:			filterDesc：麻醉方法名称筛选字符串，anaestTypeId：麻醉类型ID
/// Return：       	ResultSet
/// Debug:			d ##class(%ResultSet).RunQuery("web.DHCClinic.DHCCLCareProv","FindCareProv")
Query FindCareProv(filterDesc As %String = "", locId As %String = "", careProvType As %String = "", hospId As %String = "") As %Query(ROWSPEC = "RowId,LocId,Loc,Desc,Alias,DateFrom,DateTo,Active,ActiveDesc,IfDoctor,IfDoctorDesc,CareProvType,CareProvTypeDesc,HospId,Hosp") [ SqlProc ]
{
}

ClassMethod FindCareProvExecute(ByRef qHandle As %Binary, filterDesc As %String = "", locId As %String = "", careProvType As %String = "", hospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	
	set filterDesc=$$ALPHAUP^SSUTIL4(filterDesc)
	set careProvId=0
	for
	{
		set careProvId=$order(^DHCCLCP(careProvId))
		quit:(careProvId="")
		set careProvInfo=^DHCCLCP(careProvId)
		set thisLocId=$list(careProvInfo,1)
		continue:(locId'="")&(locId'=thisLocId)
		set thisLoc=$p($g(^CTLOC(+thisLocId)),"^",2)
		if ($l(thisLoc,"-")=2)
		{
			set thisLoc=$p(thisLoc,"-",2)	
		}
		set desc=$list(careProvInfo,2)
		set alias=$list(careProvInfo,3)
		set dateFrom=##class(web.DHCClinicCom).ConvertToDate($list(careProvInfo,4),"")
		set dateTo=##class(web.DHCClinicCom).ConvertToDate($list(careProvInfo,5),"")
		set active=$list(careProvInfo,6)
		set activeDesc="否"
		if (+active)
		{
			set activeDesc="是"	
		}
		set ifDoctor=$list(careProvInfo,7),ifDoctorDesc="否"
		if (+ifDoctor)
		{
			set ifDoctorDesc="是"	
		}
		set thisCareProvType=$list(careProvInfo,8)
		continue:(careProvType'="")&(careProvType'=thisCareProvType)
		set thisCareProvTypeDesc=$case(thisCareProvType,
									   "E":"专家",
									   "R":"进修",
									   "I":"实习",
									   "S":"学生",
									   "V":"参观",
									   "":"")
		set thisHospId=$list(careProvInfo,9)
		continue:(hospId'="")&(hospId'=thisHospId)
		set thisHosp=$listget($get(^DHCCLC("Hospital",+thisHospId)),2)
		do OutputRow	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(careProvId,thisLocId,thisLoc,desc,alias,dateFrom,dateTo,active,activeDesc,ifDoctor,ifDoctorDesc,thisCareProvType,thisCareProvTypeDesc,thisHospId,thisHosp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCareProvExecute ]
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

ClassMethod FindCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCareProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
