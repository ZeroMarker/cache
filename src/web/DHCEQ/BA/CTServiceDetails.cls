Class web.DHCEQ.BA.CTServiceDetails Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 先通过这个方法取到收费项rowid  参数医嘱项ID
/// w ##class(web.DHCINSUPortUse).GetTariDrByArcimRowid("11817||1","")
/// 
/// 取收费项信息  参数收费项ID
/// w $$GetTarDetail^DHCINSUTarContrast(2573) 
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.CTServiceDetails","GetServiceDetails","1",2)
Query GetServiceDetails(ServiceItemID As %String = "", HospID As %String = "") As %Query(ROWSPEC = "TariffDR:%String,TARICode:%String,TARIDesc:%String,TARIUOM:%String,TARIPrice:%String")
{
}

ClassMethod GetServiceDetailsExecute(ByRef qHandle As %Binary, ServiceItemID As %String = "", HospID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s EXType=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemID)),"^",5)
	s ARCIMDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemID)),"^",6)
	
	if EXType="DHC-HIS"
	{
		s TariDrStr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ARCIMDR,"")
	    f Num=1:1:$l(TariDrStr,"^")  d
	    .s TariDr=$p(TariDrStr,"^",Num)
	    .q:(##class(web.DHCINSUPortUse).GetTarItemActiveFlag(TariDr,+$h,"")'="Y")
		.s TarString=$$GetTarDetail^DHCINSUTarContrast(TariDr)
		.s TariCode=$p(TarString,"^",2)
		.s TariDesc=$p(TarString,"^",3)
		.s TARIUOM=$p(TarString,"^",4)
		.;s Price=$fn($p(TarString,"^",7),"",4)
		.s Price=+##class(web.UDHCJFPRICE).GetItmPrice(TariDr,"","","","",HospID,"")
		.s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",2)
		.d OutputRowGetServiceDetails
	}
	Quit $$$OK
OutputRowGetServiceDetails
	Set Data=$lb(TariDr,TariCode,TariDesc,TARIUOM,Price)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetServiceDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceDetailsExecute ]
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

ClassMethod GetServiceDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
