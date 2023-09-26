Class web.DHCPE.ItemSort Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod SerchItemSortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchItemSortExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SerchItemSortExecute(ByRef qHandle As %Binary, IsItem As %String = "N") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i IsItem'="Y" s IsItem="N"
 	i IsItem'="" d
 	.s (StationID,StationName,ID,Name,Sort)=""
 	.i IsItem="Y" d
 	..s Type="Item"
 	.e  d
 	..s Type="Set"
 	.s Sort=""
 	.f  s Sort=$o(^DHCPEItemSort(Type,Sort)) q:Sort=""  d
 	..s Sub=0
 	..f  s Sub=$o(^DHCPEItemSort(Type,Sort,Sub)) q:Sub=""  d
 	...s Data=$G(^DHCPEItemSort(Type,Sort,Sub))
 	...s ID=$p(Data,"^",1)
 	...s Name=..GetName(IsItem,ID)
 	...d FindBuild
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,Name,Sort,Type)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchItemSortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchItemSortExecute ]
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
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query SerchItemSort(IsItem As %String = "N") As %Query(ROWSPEC = "TID:%String,TName:%String:名称,TSort:%String:排序,TType:%String:类型")
{
}

ClassMethod GetName(IsItem, ID)
{
	new Name
	s Name=""
	i IsItem="Y" d
	.s Name=$p(^ARCIM($p(ID,"||",1),$p(ID,"||",2),1),"^",2)
	e  d
	.s myStr=$g(^ARCOS(ID))
	.s Name=$p(myStr,"^",2)
	q Name
}

ClassMethod Insert(Type, ID)
{
	new Sort
	s Sort=$G(^DHCPEItemSort("Sort",Type,ID))
	i Sort'="" q "HadItem"
	s Sort=$o(^DHCPEItemSort(Type,""),-1)
	i Sort="" s Sort=0
	s Sort=Sort+1
	s Sub=1
	s ^DHCPEItemSort(Type,Sort,Sub)=ID
	s ^DHCPEItemSort("Sort",Type,ID)=Sort_"^"_Sub
	
	q 0
}

ClassMethod Delete(Type, ID)
{
	new Sort,Sub,SortStr
	s SortStr=$G(^DHCPEItemSort("Sort",Type,ID))
	k ^DHCPEItemSort("Sort",Type,ID)
	k ^DHCPEItemSort(Type,+SortStr,$P(SortStr,"^",2))
	q 0
}

ClassMethod Update(Type, IDs, Sorts)
{
	new i,j,ID,Sort,Sub
	s i=$L(IDs,"^")
	for j=1:1:i
	{
		s ID=$p(IDs,"^",j)
		s Sort=$p(Sorts,"^",j)
		d ..Delete(Type,ID)
		s Sub=$o(^DHCPEItemSort(Type,Sort,""),-1)
		i Sub="" s Sub=0
		s Sub=Sub+1
		s ^DHCPEItemSort(Type,Sort,Sub)=ID
		s ^DHCPEItemSort("Sort",Type,ID)=Sort_"^"_Sub
	}
	q 0
}

Storage Default
{
<Data name="ItemSortDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.ItemSortD</DataLocation>
<DefaultData>ItemSortDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCP.ItemSortD</IdLocation>
<IndexLocation>^web.DHCP.ItemSortI</IndexLocation>
<StreamLocation>^web.DHCP.ItemSortS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
