/// Creator:LYN
/// CreatDate:20160423
/// Descripation:手术耗材信息维护
Class web.DHCANOPStock Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStock","FindINCItem","")
/// Creator:LYN
/// CreatDate:20160423
/// Table:INC_Itm
/// 根据Code获取库存表中的信息
Query FindINCItem(Desc As %String) As %Query(ROWSPEC = "rowId,Code,itDesc")
{
}

ClassMethod FindINCItemExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	//i Code="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s rowId=0
	f  s rowId=$o(^INCI(rowId)) q:rowId=""  d
		.q:'$d(^INCI(rowId,1))
		.q:'$d(^INCI(rowId,2))
		.s notUseFlag=$p($g(^INCI(rowId,2)),"^",9)
		.q:notUseFlag="Y"
		.s Code=$p($g(^INCI(rowId,1)),"^",1)
		.s itDesc=$p($g(^INCI(rowId,1)),"^",2)
		.q:(Desc'="")&&(itDesc'[Desc)
		.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(rowId,Code,itDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindINCItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindINCItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindINCItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindINCItemExecute ]
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

/// Descripation：	根据科室关联耗材信息内容，保存关联信息
/// input：			LocId-科室ID INCItmRowId-耗材Id，INCTtmCode-耗材Code, ANCItmDesc-显示到申请画面中的描述信息
/// 					oprFlag- 'S' 更新一条记录操作; ‘D’ 删除一条记录操作 
/// OutPut： 		0-保存成功
/// w ##class(web.DHCANOPStock).SaveINCItmRalLoc(1,1,"CL000001","导引鞘管","D")
/// 
ClassMethod SaveINCItmRalLoc(LocId As %String, INCItmId As %String, ANCItmDesc As %String, oprFlag As %String = "S") As %String
{
	q:(LocId="")!(INCItmId="") "请输入全面的信息"
	s ret=0
	i oprFlag="D" {
		i '$d(^DHCANOPLOCStock(LocId,INCItmId)) s ret="当前记录不存在！"
		s str=$g(^DHCANOPLOCStock(LocId,INCItmId))
		s ^DHCANOPLOCStock(0,"Stop",LocId,INCItmId)=str
		k ^DHCANOPLOCStock(LocId,INCItmId)
	}else{
		
		i $d(^DHCANOPLOCStock(LocId,INCItmId)) s ret="当前记录已经存在！"
		s INCItmCode=$p($g(^INCI(INCItmId,1)),"^",1)
		i ANCItmDesc="" s ANCItmDesc=$p($g(^INCI(INCItmId,1)),"^",2)	
		s ^DHCANOPLOCStock(LocId,INCItmId)=INCItmCode_"^"_ANCItmDesc
	}
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStock","FindANCStock","")
/// Creator:LYN
/// CreatDate:20160423
/// Table:INC_Itm
/// 根据Code获取库存表中的信息
Query FindANCStock(LocId As %String, Desc As %String = "") As %Query(ROWSPEC = "count,LocId,locDesc,incitrRowId,ancCode,ancDesc,itDesc")
{
}

ClassMethod FindANCStockExecute(ByRef qHandle As %Binary, LocId As %String, Desc As %String = "") As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	//i LocId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ^LYNTMP("FindANCStock")=LocId_"/"_Desc
	s incitrRowId=0
	s count=0
	i LocId'=""{
		f  s incitrRowId=$o(^DHCANOPLOCStock(LocId,incitrRowId)) q:incitrRowId=""  d
			.q:'$d(^DHCANOPLOCStock(LocId,incitrRowId))
			.s locId=LocId
			.s locDesc=$P(^CTLOC(LocId),"^",2)
			.s itDesc=$p($g(^INCI(incitrRowId,1)),"^",2)
			.s ancDesc=$p($g(^DHCANOPLOCStock(LocId,incitrRowId)),"^",2)
			.s ancCode=$p($g(^DHCANOPLOCStock(LocId,incitrRowId)),"^",1)
			.q:(Desc'="")&&(ancDesc'[Desc)
			.s count=count+1
			.d OutputRow
	}else{
		s locId=0
		f  s locId=$o(^DHCANOPLOCStock(locId)) q:locId=""  d
		.s incitrRowId=0
		.f  s incitrRowId=$o(^DHCANOPLOCStock(locId,incitrRowId)) q:incitrRowId=""  d
			..q:'$d(^DHCANOPLOCStock(locId,incitrRowId))
			..s locDesc=$P(^CTLOC(locId),"^",2)
			..s itDesc=$p($g(^INCI(incitrRowId,1)),"^",2)
			..s ancDesc=$p($g(^DHCANOPLOCStock(locId,incitrRowId)),"^",2)
			..s ancCode=$p($g(^DHCANOPLOCStock(locId,incitrRowId)),"^",1)
			..q:(Desc'="")&&(ancDesc'[Desc)
			..s count=count+1
			..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(count,locId,locDesc,incitrRowId,ancCode,ancDesc,itDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindANCStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCStockExecute ]
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

}
