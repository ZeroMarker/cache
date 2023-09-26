Import SQLUser

Class web.DHCWMRCommon.User Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

ClassMethod QueryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryUserExecute(ByRef qHandle As %Binary, Desc, Loc) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^SSU("SSUSR",{SSUSR_RowId})
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s Rowid=0
	f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
	.s tmpSSUser=$g(^SSU("SSUSR",+Rowid))
	.q:tmpSSUser=""
	.s CTPCPID=$p(tmpSSUser,"^",14)
	.s UserCode=$p(tmpSSUser,"^",1)
	.s UserDesc=$p(tmpSSUser,"^",2)
    .q:(Desc'="")&&(($$ALPHAUP^SSUTIL4(UserDesc)'[Desc)&&($$ALPHAUP^SSUTIL4(UserCode)'[Desc))
    .q:(Loc'="")&&('$d(^RB("RES",0,"CTPCP",+CTPCPID,Loc)))  //根据资源表来判断用户科室  RB_Resource
    .s Data=$lb(Rowid,UserCode,UserDesc)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserExecute ]
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

/// 通过工号/姓名、科室查询用户列表
/// Desc(允许为空)--工号/姓名  Loc(允许为空)--科室查询
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRCommon.User","QueryUser","李丽","")
Query QueryUser(Desc, Loc) As %Query(ROWSPEC = "UserID:%String,UserCode:%String,UserDesc:%String")
{
}

ClassMethod QueryCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCareProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryCareProvExecute(ByRef qHandle As %Binary, Desc, Loc) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^SSU("SSUSR",{SSUSR_RowId})
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s Rowid=0
	f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
	.s tmpSSUser=$g(^SSU("SSUSR",+Rowid))
	.q:tmpSSUser=""
	.s CareProvID=$p(tmpSSUser,"^",14)
	.q:CareProvID=""
	.s UserCode=$p(tmpSSUser,"^",1)
	.s UserDesc=$p(tmpSSUser,"^",2)
    .s CareProvCode=$p($g(^CTPCP(+CareProvID,1)),"^",1)
    .s CareProvDesc=$p($g(^CTPCP(+CareProvID,1)),"^",2)
    .q:(Desc'="")&&(($$ALPHAUP^SSUTIL4(UserDesc)'[Desc)&&($$ALPHAUP^SSUTIL4(UserCode)'[Desc))
    .q:(Loc'="")&&('$d(^RB("RES",0,"CTPCP",+CareProvID,Loc)))  //根据资源表来判断用户科室  RB_Resource
    .s Data=$lb(CareProvID,CareProvCode,CareProvDesc)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCareProvExecute ]
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

/// 通过工号/姓名、科室查询医护人员列表
/// Desc(允许为空)--工号/姓名  Loc(允许为空)--科室查询
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRCommon.User","QueryCareProv","李丽","")
Query QueryCareProv(Desc, Loc) As %Query(ROWSPEC = "CareProvID:%String,CareProvCode:%String,CareProvDesc:%String")
{
}

}
