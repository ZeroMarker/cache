Class DHCBILL.Diet.DHCIPMealItembyModality Extends %Persistent [ ClassType = "", ProcedureBlock ]
{

/// Creator :吴博实
/// CreateDate:2010-10-20
/// Function  :查询某天的某菜类型的订餐记录
/// Table     :
/// Input     :Date:订餐日期；MealModalityDr：餐形态；MealItmRowID：菜
/// OutPut    :病区，登记号，住院号，病人姓名，床号，数量
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealItembyModality","FindMealInfoByModality","2010-10-22","83","3169")
Query FindMealInfoByModality(Date As %String, MealModalityDr As %String, MealItmRowID As %String) As %Query(ROWSPEC = "ward,papmino,medcare,bedno,patname,qty")
{
}

ClassMethod FindMealInfoByModalityExecute(ByRef qHandle As %Binary, Date As %String, MealModalityDr As %String, MealItmRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    
    i Date["-" s Date=$zdh(Date,3)
   
    s RowID=""
    f  s RowID=$o(^DHCIPMEALORDER(0,"StartDate",Date,RowID)) q:RowID=""  d
    .s AdmDr=$p(^DHCIPMEALORDER(RowID),"^",1)
    .s ChildSub=0
    .f  s ChildSub=$o(^DHCIPMEALORDER(0,"StartDate",Date,RowID,ChildSub)) q:ChildSub=""  d
    ..s ItmRowID=$p(^DHCIPMEALORDER(RowID,"I",ChildSub),"^",1) ;->DHC_IPMealItem
    ..s Modality=$p(^DHCIPMEALORDER(RowID,"I",ChildSub),"^",22)
    ..s WardDr=$p(^DHCIPMEALORDER(RowID,"I",ChildSub),"^",8)
    ..s qty=$p(^DHCIPMEALORDER(RowID,"I",ChildSub),"^",5)
    ..;b ;111
	..q:ItmRowID'=MealItmRowID

	
	..i (Modality=MealModalityDr)||(MealModalityDr="")  d
 	...i WardDr'="" s Ward=$p(^PAWARD(WardDr),"^",2)
 	...s ward=$p(Ward,"-",2)
    ...i AdmDr'=""  d 
    ....s PapmiDr=$p(^PAADM(AdmDr),"^",1)
    ....s BedDr=$p(^PAADM(AdmDr),"^",73)
    ....s BedSub=$p(BedDr,"||",2)
    ....i BedDr'="" s bedno=$p(^PAWARD(WardDr,"BED",BedSub),"^",1)
    ...i PapmiDr'=""  d
	....s patname=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ....s medcare=$p(^PAPER(PapmiDr,"PAT",1),"^",22)
    ....s papmino=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
	...d OutputRow3
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow3
	set Data=$lb(ward,papmino,medcare,bedno,patname,qty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealInfoByModalityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealInfoByModalityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealInfoByModalityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealInfoByModalityExecute ]
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

/// Creator :吴博实
/// CreateDate:2010-10-20
/// Function  :查询某天的菜类型的菜名
/// Table     :
/// Input     :Date:订餐日期；MealModalityDr：餐形态；
/// OutPut    :MealDesc：菜名称  ；MealItmRowID:菜id
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealItembyModality","FindMealNameByModality","2010-10-22","")
Query FindMealNameByModality(date As %String, MealModality As %String) As %Query(ROWSPEC = "mealitmrowid,mealDdesc")
{
}

ClassMethod FindMealNameByModalityExecute(ByRef qHandle As %Binary, Date As %String, MealModality As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    
    i Date["-" s Date=$zdh(Date,3)
    k ^TMP("FindMealNameByModality")
    s RowID=""
    f  s RowID=$o(^DHCIPMEALORDER(0,"StartDate",Date,RowID)) q:RowID=""  d
    .s ChildSub=0
    .f  s ChildSub=$o(^DHCIPMEALORDER(0,"StartDate",Date,RowID,ChildSub)) q:ChildSub=""  d
    ..s MealItmRowID=$p(^DHCIPMEALORDER(RowID,"I",ChildSub),"^",1) ;->DHC_IPMealItem
    ..s ModalityDr=$p(^DHCIPMEALORDER(RowID,"I",ChildSub),"^",22)
    ..;b ;111
    
	..i $d(^DHCIPMEALMODALITY(ModalityDr))  d
	...;s ModalityID=$p(^DHCIPMEALMODALITY(MealModalityDr),"^",1)
	...s ModalityDesc=$p(^DHCIPMEALMODALITY(ModalityDr),"^",2)
	...;b ;222
	...;q:(Modality'=MealModalityDr)&(Modality="")
	...i (MealModality=ModalityDr)||(MealModality="")  d
	....;b ;333
	....i $d(^DHCIPMEALITEM(MealItmRowID))  d
	.....s MealCode= $p(^DHCIPMEALITEM(MealItmRowID),"^",1)
    .....s MealDesc= $p(^DHCIPMEALITEM(MealItmRowID),"^",2)
    .....s ^TMP("FindMealNameByModality",ModalityDr)=MealItmRowID_"^"_MealDesc
    s MealModalityDr=""
    f  s MealModalityDr=$O(^TMP("FindMealNameByModality",MealModalityDr)) q:MealModalityDr=""  d
    .s mealitmrowid=$p(^TMP("FindMealNameByModality",MealModalityDr),"^",1)
    .s mealdesc=$p(^TMP("FindMealNameByModality",MealModalityDr),"^",2)
    .d OutputRow2
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow2
	set Data=$lb(mealitmrowid,mealdesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealNameByModalityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealInfoByModalityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealNameByModalityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealInfoByModalityExecute ]
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

/// Creator :吴博实
/// CreateDate:2010-10-20
/// Function  :查询某天的餐形态
/// Table     :
/// Input     :
/// OutPut    :MealModalityDr：餐形态；
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealItembyModality","FindMealModality")
Query FindMealModality(Date As %String) As %Query(ROWSPEC = "mealmodalitydr,modalitydesc")
{
}

ClassMethod FindMealModalityExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    s RowID=0
    f  s RowID=$o(^DHCIPMEALMODALITY(RowID)) q:RowID=""  d
    .s mealmodalitydr=RowID
    .s modalitydesc=$p(^DHCIPMEALMODALITY(RowID),"^",2)
    .d OutputRow1
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(mealmodalitydr,modalitydesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealModalityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealInfoByModalityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealModalityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealInfoByModalityExecute ]
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

Storage Default
{
<Data name="DHCIPMealItembyModalityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCBILL.Diet.DHCIPMealIte894D</DataLocation>
<DefaultData>DHCIPMealItembyModalityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBILL.Diet.DHCIPMealIte894D</IdLocation>
<IndexLocation>^DHCBILL.Diet.DHCIPMealIte894I</IndexLocation>
<StreamLocation>^DHCBILL.Diet.DHCIPMealIte894S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
