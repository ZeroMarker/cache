Class web.DHCNurHealthEdu Extends %RegisteredObject
{

/// 根据病区查询该病区健康教育大类 (一级项目)
/// d ##class(%ResultSet).RunQuery("web.DHCNurHealthEdu","FindHealthEduItemOne","22")
Query FindHealthEduItemOne(CtLocId As %String) As %Query(ROWSPEC = "ItemDesc,LocDesc,LocID,rw")
{
}

ClassMethod FindHealthEduItemOneExecute(ByRef qHandle As %Binary, CtLocId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i (CtLocId="")
	{
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	set LocID=CtLocId
	set LocDesc=$p(^CTLOC(LocID),"^",2)
	
	set rw = ""
	for  set rw=$O(^HEDUAP(LocID,"HEAPW",rw)) q:rw=""  do
	.q:$D(^HEDUAP(rw))=0
	.s ItemDesc = $P(^HEDUAP(rw),"^",1)
	.s IsValid = $P(^HEDUAP(rw),"^",3)
	.i IsValid'="N" do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(ItemDesc,LocDesc,LocID,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHealthEduItemOneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHealthEduItemOneExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHealthEduItemOneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHealthEduItemOneExecute ]
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

/// 根据项目一查询该病区健康教育子类 (二级项目)
/// do ##class(%ResultSet).RunQuery("web.DHCNurHealthEdu","FindHealthEduItemTwo","5")
Query FindHealthEduItemTwo(Item1RowId As %String) As %Query(ROWSPEC = "Item2Code,Item2Desc,Item1Desc,Item1RowId,Item2rw")
{
}

ClassMethod FindHealthEduItemTwoExecute(ByRef qHandle As %Binary, Item1RowId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i (Item1RowId="")
	{
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	set Item1Desc = $P(^HEDUAP(Item1RowId),"^",1)
	
	set Item2rw = ""
	for  set Item2rw=$O(^HEDUAPI(Item1RowId,"CARETEACH",Item2rw)) q:Item2rw=""  do
	.q:$D(^HEDUAPI(Item2rw))=0
	.s Item2Code = $P(^HEDUAPI(Item2rw),"^",2)
	.s Item2Desc = $P(^HEDUAPI(Item2rw),"^",3)
	.s IsValid = $P(^HEDUAPI(Item2rw),"^",4)
	.i IsValid'="N" do OutputItemTwo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputItemTwo      
	set Data=$lb(Item2Code,Item2Desc,Item1Desc,Item1RowId,Item2rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHealthEduItemTwoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHealthEduItemTwoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHealthEduItemTwoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHealthEduItemTwoExecute ]
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

/// 根据项目二查询该病区健康教育项目三 (三级项目)
/// d ##class(%ResultSet).RunQuery("web.DHCNurHealthEdu","FindHealthEduItemThree","8")
Query FindHealthEduItemThree(Item2RowId As %String) As %Query(ROWSPEC = "Item3Code,Item3Desc,Item2,Item2RowId,Item3rw")
{
}

ClassMethod FindHealthEduItemThreeExecute(ByRef qHandle As %Binary, Item2RowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	if Item2RowId="" 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	set Item3rw="" for  set Item3rw=$O(^DHCMGNUR.DHCNurHEAPIItemI("ItemDR"," "_Item2RowId,Item3rw)) q:Item3rw=""  do
	.set object = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(Item3rw)
	.;q:'object.%ExistId(ItemId)
	.set Item3Code = object.Item3
	.set Item3Desc = object.Describe
	.set Item3Valid = object.ItemValid
	.quit:Item3Valid="N"
	.set object2 = ##class(DHCMGNUR.DHCNurHEAProjectItem).%OpenId(Item2RowId)
	.set Item2 = object2.Item2
	.Do OutputItemThree
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputItemThree     
	set Data=$lb(Item3Code,Item3Desc,Item2,Item2RowId,Item3rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHealthEduItemThreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHealthEduItemThreeExecute ]
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

ClassMethod FindHealthEduItemThreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHealthEduItemThreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
