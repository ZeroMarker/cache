/// Creator:wangcs
/// Description:出院情况（转归）
/// CreateDate:2011-12-01
Class web.DHCWMRDischConditQuery Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// Creator:wangcs
/// Description:查询出院结果
/// CreateDate:2011-12-01
/// debug:w ##Class(web.DHCWMRDischConditQuery).DischCondit(paadm)
ClassMethod DischCondit(paadm)
{
	new (paadm)
	s dischDesc=""
	s mrAdmId=$p($g(^PAADM(paadm)),"^",61)
	q:mrAdmId=""
	s dischId=$p(^MR(+mrAdmId,"PRO",1),"^",10)    
	s dischDesc=$p($g(^PAC("DISCON",+dischId)),"^",2)
	q dischDesc
}

/// Creator:wangcs
/// Description:转归
/// CreateDate:2011-12-01
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCWMRDischConditQuery","DischConditQry")
Query DischConditQry() As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod DischConditQryExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	;^PAC("DISCON",{DISCON_RowId})
	
	set disconId=0
	
	for{
		set disconId=$o(^PAC("DISCON",disconId))
		q:disconId=""
		
		set dateFrom=+$P($g(^PAC("DISCON",disconId)),"^",4)
		set dateTo=+$p($g(^PAC("DISCON",disconId)),"^",5)
		set dateNow=+$p($h,",",1)
		continue:(dateFrom'=0)&&(dateFrom>dateNow)
		continue:(dateTo'=0)&&(dateTo<dateNow)
		set desc=$p($g(^PAC("DISCON",disconId)),"^",2)
		set data=$lb(disconId,desc)
		set ind=ind+1
		set ^CacheTemp(repid,ind)=data
	}
	
	Quit $$$OK
}

ClassMethod DischConditQryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DischConditQryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DischConditQryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DischConditQryExecute ]
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
