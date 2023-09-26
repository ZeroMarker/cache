Class web.DHCAppPisDicRelationBLMap Extends %RegisteredObject
{

/// w ##class(web.DHCAppPisDicRelationBLMap).InsertBLType("003","ceshi","script")
ClassMethod InsertRelationBLMap(PisDicItem, PisDicType, PisBLmap, PisDefulat)
{
	s count=0
	&sql(select count(*) into :count from SQLUser.DHCAppPisDicRelationBLMap where AppPis_DicItem=:PisDicItem and AppPis_DicType=:PisDicType and AppPis_BLmap=:PisBLmap)
	Q:count>0 count
	&SQL(insert into SQLUser.DHCAppPisDicRelationBLMap 
		(AppPis_DicItem,AppPis_DicType,AppPis_BLmap,AppPis_Defulat
		) Values(:PisDicItem,:PisDicType,:PisBLmap,:PisDefulat))
	s rtn=SQLCODE
	q rtn
}

ClassMethod DelectRelationBLMap(RowID As %String)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHCAppPisDicRelationBLMap where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

Query FindRelationBLMap(PisDicItem) As %Query(ROWSPEC = "RowID:%String,BLMapID:%String,BLMapDesc:%String,Defalute:%String")
{
}

ClassMethod FindRelationBLMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRelationBLMapExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRelationBLMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRelationBLMapExecute ]
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

ClassMethod FindRelationBLMapExecute(ByRef qHandle As %Binary, PisDicItem) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocThreeCheckListAdm","FindThreeDocAdm","4634",110,2)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s RowID=0
	for{
		s RowID=$O(^DHCAppPisDicRelationBLMap("PisDic",PisDicItem,RowID))
		q:RowID=""
		s BLMapID=$P($g(^DHCAppPisDicRelationBLMap(RowID)),"^",3)
		continue:BLMapID=""
		s BLMapDesc=$P(^DHCDocAppBLMap(BLMapID),"^",2)
		s Defalute=$P(^DHCAppPisDicRelationBLMap(RowID),"^",4)
		set Data=$lb(RowID,BLMapID,BLMapDesc,Defalute)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 判断这个项目在这个申请单是否可用
ClassMethod CheckForOneItem(PisDicItem, PisBLmap)
{
	s rtn=0
	s RowID=0
	for {
		s RowID=$O(^DHCAppPisDicRelationBLMap("PisDic",PisDicItem,RowID))
		q:RowID=""
		s BLMapID=$P($g(^DHCAppPisDicRelationBLMap(RowID)),"^",3)
		if (PisBLmap=BLMapID) s rtn=1
	}
	q rtn
}

/// 得到某个申请单的默认
/// w ##class(web.DHCAppPisDicRelationBLMap).GetOneItemDefault("LIVN","固定方式")
ClassMethod GetOneItemDefault(MapCode, Title)
{
	q:MapCode="" ""
	s PisBLmap=$O(^DHCDocAppBLMapi("MapCode",MapCode,""))
	q:PisBLmap="" ""
	s PisDicType=$O(^DHCAPPPDT(0,"Desc",Title,2,""))
	q:PisDicType="" ""
	s RowID=$O(^DHCAppPisDicRelationBLMap("Defualt","Y",PisDicType,PisBLmap,""))
	q:RowID="" ""
	s PisDicItem=$P(^DHCAppPisDicRelationBLMap(RowID),"^",1)
	q PisDicItem
}

}
