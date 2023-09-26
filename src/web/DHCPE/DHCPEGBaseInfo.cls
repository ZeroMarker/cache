Import SQLUser

/// Create by MLH
Class web.DHCPE.DHCPEGBaseInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

Query aGBaseInfo(GName As %String) As %Query(ROWSPEC = "TRowId:%String,TCode:%String,TDesc:%String,TAddress:%String,TPostalcode:%String,TLinkman:%String,TBank:%String,TTel1:%String,TEmail:%String")
{
}

ClassMethod aGBaseInfoExecute(ByRef qHandle As %Binary, GName As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
 	f  s id=$o(^DHCPEGBI(id)) q:id=""  d
	.s CurData=$g(^DHCPEGBI(id))
	.s Code=$p(CurData,"^",1)
	.s Desc=$p(CurData,"^",2)
	.s Address=$p(CurData,"^",3)
	.s Postalcode=$p(CurData,"^",4)
	.s Linkman=$p(CurData,"^",5)
	.s Bank=$p(CurData,"^",6)
	.s Tel1=$p(CurData,"^",8)
	.s Email=$p(CurData,"^",10)
	.d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	set Data=$lb($g(id),Code,Desc,Address,Postalcode,Linkman,Bank,Tel1,Email)
	s ^lisatest("Data")=Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod aGBaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = aGBaseInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod aGBaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = aGBaseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//

/// 功能 获取团体客户基本信息 的列表
/// 组件 DHCPEItemNoCheck
Query DHCPEGBaseInfoList(Desc As %String) As %SQLQuery(ROWSPEC = "GBI_Desc:%String:名称, GBI_Code:%String:编码, GBI_RowId:%String:ID")
{
	select GBI_Desc,GBI_Code,GBI_RowId  
	From  DHC_PE_GBaseInfo where GBI_Desc %STARTSWITH %ALPHAUP(:Desc) order by GBI_RowId DESC
}

Query GBaseInfoList(GBIDesc As %String = "") As %Query(ROWSPEC = "GBI_Desc:%String:名称, GBI_Code:%String:编码, GBI_RowId:%String:ID")
{
}

ClassMethod GBaseInfoListExecute(ByRef qHandle As %Binary, GBIDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s:GBIDesc'="" GBIDesc=$ZCVT(GBIDesc,"U")
 	s id=""
 	f  s id=$o(^DHCPEGBI(id),-1)  q:(id="")||(id=0)  d
	.s GDesc=$p($g(^DHCPEGBI(id)),"^",2)
	.s GCode=$p($g(^DHCPEGBI(id)),"^",1)
	.s TNamePY=##class(web.DHCINSUPort).GetCNCODE(GDesc,4,"")
	.s ParaTNamePY=##class(web.DHCINSUPort).GetCNCODE(GBIDesc,4,"")
	.q:("0"'=ParaTNamePY)&('(TNamePY[ParaTNamePY))
	.;q:(""'=ParaTNamePY)&('(TNamePY[ParaTNamePY))
	.;q:((""'=GBIDesc)&('(($ZCVT(GDesc,"U")[GBIDesc)||(TNamePY[GBIDesc))))	
    .d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build

	set Data=$lb(GDesc,GCode,$g(id))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GBaseInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GBaseInfoListExecute ]
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

ClassMethod GBaseInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GBaseInfoListExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
