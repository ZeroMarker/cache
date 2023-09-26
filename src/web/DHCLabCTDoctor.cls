Class web.DHCLabCTDoctor Extends (%Library.RegisteredObject, websys.Abstract)
{

Parameter BUILD = 10;

ClassMethod CTDoctorLookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTDoctorLookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CTDoctorLookUpExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
 	
 	s ctDocCode="" f  s ctDocCode=$o(^TTAB("DR",ctDocCode)) q:ctDocCode=""  d
 	.s ctDocName=$p(^TTAB("DR",ctDocCode),"\")
 	.i $l(desc),ctDocName'[desc q
 	.Do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ctDocName,ctDocCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CTDoctorLookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTDoctorLookUpExecute ]
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

/// Creator：      huhm
/// CreatDate：    20090704
/// Description:： 查询科室
/// Table：        lab.CT_Doctor
/// Input：        医生名称
/// Output：       医生名称,医生代码
/// Return：       
/// Others
Query CTDoctorLookUp(desc As %String) As %Query(ROWSPEC = "DoctorName:%String,DoctorCode:%String")
{
}

}
