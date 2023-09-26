Import SQLUser

Class web.DHCNurFaYaoTimeSet Extends %RegisteredObject
{

/// ##class(%ResultSet).RunQuery("web.DHCNurFaYaoTimeSet","GetFaYaoTimeSet","",2)
Query GetFaYaoTimeSet(WardId As %String = "", HospitalRowId As %String = "") As %Query(ROWSPEC = "id,Ward,WardDesc,MedTyp,MedTypDesc,EDate,ETime,HospitalRowId,hospDesc")
{
}

ClassMethod GetFaYaoTimeSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaYaoTimeSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFaYaoTimeSetExecute(ByRef qHandle As %Binary, WardId As %String = "", HospitalRowId As %String = "") As %Status
{
	s ^temp("GetFaYaoTimeSet")=$lb(WardId,HospitalRowId)
    Set repid=$I(^CacheTemp)
 	s ind=1
 	if $d(%session)&&(HospitalRowId=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HospitalRowId=%session.Get("LOGON.HOSPID")
 	}
 	if WardId'=""
 	{
	 	s id="" f  s id=$o(^User.DHCNurFaYaoTimeSetI("Ward"," "_WardId,id)) q:id=""  d
	 	.d out
	}
	else
	{
		s id="" f  s id=$o(^User.DHCNurFaYaoTimeSetD(id)) q:id=""  d
		.d out
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
out
    s (WardDesc,MedTypDesc,EDate,ETime,hospDesc)=""
    s a=^User.DHCNurFaYaoTimeSetD(id)
    s Ward=$ListGet(a,5)
    i Ward'="" s WardDesc=$p(^CTLOC(Ward),"^",2)
    s MedTyp=$ListGet(a,4)
    i MedTyp'="" s MedTypDesc=..GetDrugGroupById(MedTyp)
    s EDate=$ListGet(a,2)
    s ETime=$ListGet(a,3)
    i ETime'="" s ETime=$zt(ETime,2)
    s hospDR=$ListGet(a,6)
    q:hospDR'=HospitalRowId
    i HospitalRowId'="" s hospDesc=$p(^CT("HOSP",HospitalRowId),"^",2)
    d OutPutFYTimeSet
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutFYTimeSet  
	set Data=$lb(id,Ward,WardDesc,MedTyp,MedTypDesc,EDate,ETime,HospitalRowId,hospDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFaYaoTimeSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaYaoTimeSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-03
/// Description: 取科室
/// Table：CT_Loc
/// Input：LocDesc: 查询条件
/// Return：CTLocDesc:科室描述, CTLocId:科室的ID
/// other: ##class(%ResultSet).RunQuery("web.DHCNurFaYaoTimeSet","LookupCTLoc","","2")
Query LookupCTLoc(LocDesc As %String, HospitalRowId As %String = "") As %Query(ROWSPEC = "CTLocDesc:%String,CTLocId:%String")
{
}

/// w ##class(%ResultSet).RunQuery("web.DHCNurFaYaoTimeSet","LookupCTLoc","呼吸")
ClassMethod LookupCTLocExecute(ByRef qHandle As %Binary, LocDesc As %String, HospitalRowId As %String = "") As %Status
{
	s ^temp("LookupCTLoc")=$lb(LocDesc,HospitalRowId)
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i HospitalRowId="" Quit $$$OK
 	;s rowid=0
	i $g(LocDesc)'="" s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
	s len=$l(LocDesc)
    s CTLocId=0 f  s CTLocId=$o(^CTLOC(CTLocId)) q:CTLocId=""  d
    .q:'$d(^CTLOC(CTLocId))
    .;s ifShow=##class(Nur.Interface.Other.BDPInterface).GetHospShowDataFlagSpecial("CT_Loc",CTLocId,HospitalRowId,"")
    .;q:ifShow'="Y"
    .s hospital=$p($g(^CTLOC(CTLocId)),"^",22)
    .q:hospital'=HospitalRowId
    .s CTLocTyp=$p(^CTLOC(CTLocId),"^",13)
    .q:CTLocTyp'="W"
    .s CTLocDesc=$p(^CTLOC(CTLocId),"^",2)
    .s tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
    .s tmpLocDesc=$e(tmpLocDesc,1,len)
    .s spell=$$ALPHAUP^SSUTIL4($p(^CTLOC(CTLocId),"^",43))
    .q:(tmpLocDesc'=LocDesc)&&(spell'[LocDesc)
 	.Do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(CTLocDesc,CTLocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookupCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupCTLocExecute ]
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

ClassMethod LookupCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: panshuai
/// CreatDate: 2011-10-17
/// Description: 取药房组的发药类别
/// Table：
/// Input：MedTyp: 查询条件
/// Return：MedTyp:发药类别描述, MedTypId:发药类别的ID
Query LookupMedTyp(MedTyp As %String) As %Query(ROWSPEC = "MedTyp:%String,MedTypId:%String")
{
}

ClassMethod LookupMedTypExecute(ByRef qHandle As %Binary, MedTyp As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;s rowid=0
	i $g(MedTyp)'="" s MedTyp=$$ALPHAUP^SSUTIL4(MedTyp)
	s len=$l(MedTyp)
	s rtnStr=##class(web.DHCSTPHADRUGGROUP).GetDrugGroup()
	s num=$L(rtnStr,"!")
	for i=1:1:num
	{
		s a=$p(rtnStr,"!",i)
		s id=$p(a,"^",3)
		s MedTypDesc=$p(a,"^")_"-"_$p(a,"^",2)
		s tmpMedTypDesc=$$ALPHAUP^SSUTIL4(MedTypDesc)
		s tmpMedTypDesc=$e(tmpMedTypDesc,1,len)
		b ;001
		i tmpMedTypDesc'=MedTyp continue
		do OutputMedTyp
	}
   
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputMedTyp
	set Data=$lb(MedTypDesc,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookupMedTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupMedTypExecute ]
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

ClassMethod LookupMedTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupMedTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDrugGroupById(GroupId As %String)
{
	s (Code,Desc,result)=""
	&sql(select SDG_Code,SDG_Desc into:Code,:Desc from DHCStkDrugGroup where SDG_RowId=:GroupId)
	s result=Code_"-"_Desc
    q result
}

ClassMethod GetFYTimeSet(LocId As %String)
{
	s rtnStr="12:00"
	q:LocId="" rtnStr
	s rw=""
	s rw=$o(^User.DHCNurFaYaoTimeSetI("Ward"," "_LocId,rw),-1)
	q:rw="" rtnStr
	s ETime=$ListGet(^User.DHCNurFaYaoTimeSetD(rw),3)
	i ETime'="" s ETime=$zt(ETime,2)
	s rtnStr=ETime
    q rtnStr
}

}
