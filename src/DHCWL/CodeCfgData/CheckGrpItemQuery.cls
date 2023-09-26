Class DHCWL.CodeCfgData.CheckGrpItemQuery Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.CheckGrpItemQuery","CheckGrpItemQuery","1")
Query CheckGrpItemQuery(grpid As %Text, searcheCond = "", searcheValue = "") As %Query(ROWSPEC = "ID:%String,ItemCode:%String,ItemDesc:%String") [ SqlProc ]
{
}

ClassMethod CheckGrpItemQueryExecute(ByRef qHandle As %Binary, grpid As %Text, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpid="" ""
	s count=0
	s count=##class(DHCWL.CodeCfgData.FunctionModule).CheckStatItem(grpid)
 	f num=0:1:count-1  d
	.s itemList=$g(^TEMPDHCWLCodeCheck($j,num))
	.s ID=$p(itemList,"^",1)
	.s ItemCode=$p(itemList,"^",2)
	.s ItemDesc=$p(itemList,"^",3)
	.;i (searcheCond="Code")&(searcheValue'="") q:ItemCode'[searcheValue
	.i (searcheCond="Code")&(searcheValue'="") q:##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(ItemCode,searcheValue)=0
	.;i (searcheCond="Name")&(searcheValue'="") q:ItemDesc'[searcheValue
	.i (searcheCond="Name")&(searcheValue'="") q:##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(ItemDesc,searcheValue)=0
	.;q:ind>10000    //暂时只显示1000条
	.s ^CacheTemp(repid,ind)=$lb(ID,ItemCode,ItemDesc)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod CheckGrpItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckGrpItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod CheckGrpItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckGrpItemQueryExecute ]
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

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     
/// Table:           
/// Input: 			
/// Output:			
/// Return:
/// Others:     d ##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue("lhcs0617","##lh")
ClassMethod FilterValue(ItemDesc, searcheValue)
{
	s middle=searcheValue
	s top="",bottom=""
	if ($find(searcheValue,"***")){
		s top=$p(searcheValue,"***",1)
		s topLen=$l(top)
		s searchLen=topLen+3
		if ($find(searcheValue,"***",searchLen)){
			s middle=$p(searcheValue,"***",2)
			s bottom=$p(searcheValue,"***",3)
		}else{
			s bottom=$p(searcheValue,"***",2)
			s middle=""
		}
	}
	q:(middle'="")&&(ItemDesc'[middle) 0
	if top'="" {
		s len=$l(top)
		q:($Find(ItemDesc,top))'=(len+1) 0
	}
	if (bottom'=""){ 
		s len=$l(bottom)
		s bottomValue=$e(ItemDesc,$l(ItemDesc)-len+1,$l(ItemDesc))
		q:bottomValue'=bottom 0
	}
	q 1
}

/// d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.CheckGrpItemQuery","CheckGrpItemQuery","1")
Query CheckGroupItemQuery(grpid As %Text, searcheCond = "", searcheValue = "") As %Query(ROWSPEC = "ID:%String,ItemCode:%String,ItemDesc:%String") [ SqlProc ]
{
}

ClassMethod CheckGroupItemQueryExecute(ByRef qHandle As %Binary, grpid As %Text, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpid="" ""
	s count=0
	s count=##class(DHCWL.CodeCfgData.FunctionModule).CheckGroupItem(grpid)
 	f num=0:1:count-1  d
	.s itemList=$g(^TEMPDHCWLCodeGroupCheck($j,num))
	.s ID=$p(itemList,"^",1)
	.s ItemCode=$p(itemList,"^",2)
	.s ItemDesc=$p(itemList,"^",3)
	.i (searcheCond="Code")&(searcheValue'="") q:##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(ItemCode,searcheValue)=0
	.i (searcheCond="Name")&(searcheValue'="") q:##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(ItemDesc,searcheValue)=0
	.;i (searcheCond="Code")&(searcheValue'="") q:ItemCode'[searcheValue
	.;i (searcheCond="Name")&(searcheValue'="") q:ItemDesc'[searcheValue
	.q:ind>1000    //暂时只显示1000条
	.s ^CacheTemp(repid,ind)=$lb(ID,ItemCode,ItemDesc)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod CheckGroupItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckGrpItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod CheckGroupItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckGrpItemQueryExecute ]
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

}
