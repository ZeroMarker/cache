/// creator:	 yunhaibao
/// createdate:  2019-01-30
/// description: 仅住院药房字典
Class web.DHCINPHA.Common.Dict Extends %RegisteredObject
{

/// deccription:住院药房
/// table:      User.DHCPhaLocation
/// d ##class(%ResultSet).RunQuery("web.DHCINPHA.Common.Dict","PhaLocation")
Query PhaLocation(InputStr = "", FilterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PhaLocationExecute(ByRef qHandle As %Binary, InputStr = "", FilterText = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s HospId=$p(InputStr,"^",1)
	s plId=0
	f  s plId=$o(^DHCPL(plId)) q:plId=""  d
	.s plData=^DHCPL(plId)
	.s locId=$p(plData,"^",1)
	.q:+locId=0
	.q:'$d(^CTLOC(locId))
	.q:(HospId'="")&&(HospId'=$p(^CTLOC(locId),"^",22))
	.s locDesc=$p(^CTLOC(locId),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(locId,locDesc)    
	.s ind=ind+1
	q $$$OK
}

/// deccription:药房发药类别字典
/// table:      User.DHCPhaLocDisType
/// d ##class(%ResultSet).RunQuery("web.DHCINPHA.Common.Dict","PhaLocDisType",311)
Query PhaLocDisType(InputStr = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PhaLocDisTypeExecute(ByRef qHandle As %Binary, InputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s LocId=$p(InputStr,"^",1)
	q:LocId="" $$$OK
	s plId=$o(^DHCPL(0,"Loc",LocId,""))
	q:plId="" $$$OK
	s plItm=0
	f  s plItm=$o(^DHCPL(plId,"DIS",plItm)) q:plItm=""  d
	.s plItmData=^DHCPL(plId,"DIS",plItm)
	.s drugTypeId=$p(plItmData,"^",1)
	.q:drugTypeId=""
	.s drugTypeDesc=$p(^DHCSTDRUGGRP(drugTypeId),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(drugTypeId,drugTypeDesc)    
	.s ind=ind+1
	q $$$OK
}

}
