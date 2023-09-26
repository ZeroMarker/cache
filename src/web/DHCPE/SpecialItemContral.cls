Class web.DHCPE.SpecialItemContral Extends %Persistent
{

ClassMethod AddSpecialItemContralUser(UserID)
{
	
	s ^DHCPESpecialContral("DHCPEXH",UserID)="Y"
	q "0"
}

ClassMethod DelSpecialItemContralUser(UserID)
{
	
	s ^DHCPESpecialContral("DHCPEXH",UserID)="N"
	s ItemID=""
    f  s ItemID=$O(^DHCPESpecialContral("DHCPEXH",UserID,ItemID)) q:ItemID=""  d
    .S ^DHCPESpecialContral("DHCPEXH",UserID,ItemID)="N"

	q "0"
}

ClassMethod Save(UserID, String)
{
	
	q:(UserID="") ""
	q:($g(^SSU("SSUSR",UserID))="") ""
	s INum=1
	s ItemID=""
	f  s ItemID=$O(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID)) q:ItemID=""  d
	.;i '$D(^DHCPEST(0,"STORD_ARCIM",ItemID)) d
	.;.k ^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID)
	.q:$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID))'="Y"
	.s Contral=""
	.s Contral=$p(String,"^",INum)
	.s ^DHCPESpecialContral("DHCPEXH",UserID,ItemID)=Contral
	.s INum=INum+1
	
	q 0
}

Query SearchSpecialItemContral() As %Query(ROWSPEC = "UserID:%String,UserName:%String,UserCode:%String")
{
}

ClassMethod SearchSpecialItemContralExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	
	If $g(ind)="" Set ind=2000
	s UserID=0,UserName="",UserCode=""
	f  s UserID=$o(^DHCPESpecialContral("DHCPEXH",UserID)) q:(UserID="")  d
	.q:($g(^DHCPESpecialContral("DHCPEXH",UserID))'="Y")
	.s UserCode=$P($G(^SSU("SSUSR",UserID)),"^",1)
	.s UserName=$P($G(^SSU("SSUSR",UserID)),"^",2)
	.d OutPut9
	.s init="",username="",UserCode=""
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutPut9
	
	set Data=$lb(UserID,UserName,UserCode) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchSpecialItemContralFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSpecialItemContralExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind) 
	Quit $$$OK
}

ClassMethod SearchSpecialItemContralClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSpecialItemContralExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// /特殊项目权限控制detail
Query SearcgSIContralDetail(UserID As %String, EndDate As %String, Item As %String, Status As %String = "", ShowCollect As %String = "", PreDate As %String = "", VIPLevel As %String = "", RegNo As %String = "", hospId As %String = "") As %Query(ROWSPEC = "TItemID:%String,TItemName:%String,TContral:%String")
{
}

ClassMethod SearcgSIContralDetailExecute(ByRef qHandle As %Binary, UserID As %String, EndDate As %String, Item As %String, Status As %String = "", ShowCollect As %String = "", PreDate As %String = "", VIPLevel As %String = "", RegNo As %String = "", hospId As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
		
	If $g(ind)="" Set ind=2000
	
	i (UserID="") 
	{
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
	}	
	s ItemID=""
	f  s ItemID=$O(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID)) q:ItemID=""  d
	.;i '$D(^DHCPEST(0,"STORD_ARCIM",ItemID)) d
	.;.k ^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID)
	.q:$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemID))'="Y"
	.s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ItemID,hospId)
	.q:HOSPshowFlag="N"

	.s Desc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemID)
	.s TContral=$g(^DHCPESpecialContral("DHCPEXH",UserID,ItemID))
	.s:(TContral="Y") TContral=1
	.d OutPut7
	.s TContral=0
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
	
	;q ""
OutPut7
	
	set Data=$lb(ItemID,Desc,TContral)  
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearcgSIContralDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearcgSIContralDetailExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind) 
	Quit $$$OK
}

ClassMethod SearcgSIContralDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearcgSIContralDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(web.DHCPE.SpecialItemContral).GetSpecItemContral()
ClassMethod GetSpecItemContral(UserID, ItemID)
{
	Q:(UserID="")||(ItemID="") ""
	q $g(^DHCPESpecialContral("DHCPEXH",UserID, ItemID))
}

/// d ##class(web.DHCPE.SpecialItemContral).SaveNew(923,"11552||1")
ClassMethod SaveNew(UserID, String)
{
	
	q:(UserID="") ""
	q:($g(^SSU("SSUSR",UserID))="") ""
	s ID=""
	f  s ID=$O(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ID)) q:ID=""  d
	.q:$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ID))'="Y"
	.q:String[ID
	.s ^DHCPESpecialContral("DHCPEXH",UserID,ID)="N"
		
	if (String'="") {
	s len=$l(String,"^")
	f i=1:1:len  d
	.s ItemID=$p(String,"^",i)
	.s ^DHCPESpecialContral("DHCPEXH",UserID,ItemID)="Y"
	}
	
	q 0
}

Storage Default
{
<Data name="SpecialItemContralDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.SpecialItemContralD</DataLocation>
<DefaultData>SpecialItemContralDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.SpecialItemContralD</IdLocation>
<IndexLocation>^web.DHCPE.SpecialItemContralI</IndexLocation>
<StreamLocation>^web.DHCPE.SpecialItemContralS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
