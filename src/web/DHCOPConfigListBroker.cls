Class web.DHCOPConfigListBroker Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: ZhYW
/// CreatDate: 2019-10-22
/// Description: 医嘱子类
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPConfigListBroker","FindItemCat")
Query FindItemCat(hospId As %String) As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String,checked:%Boolean")
{
}

ClassMethod FindItemCatExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set configInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospId)
	set unAuditItemCatStr=$p(configInfo,"^",37)
	
	set id="0"
	for  set id=$o(^ARC("IC",id))  quit:(id="")  do
	.set tmp=$g(^ARC("IC",id))
	.quit:(tmp="")
	.set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", id, hospId)
	.quit:(showFlag="N")
	.set code=$p(tmp,"^",1)
	.set desc=$p(tmp,"^",2)
	.set checked=$s((($c(2)_unAuditItemCatStr_$c(2))[($c(2)_id_$c(2))):"true", 1:"false")
	.do OutputItemCatList
	
	quit $$$OK
	
OutputItemCatList
	set Data=$lb(id,code,desc,checked)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-10-22
/// Description: 审核超级权限科室
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPConfigListBroker","FindSuperAuditLoc")
Query FindSuperAuditLoc(hospId As %String) As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String,checked:%Boolean")
{
}

ClassMethod FindSuperAuditLocExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set configInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospId)
	set superAuditLocStr=$p(configInfo,"^",43)
	
	set id="0"
	for  set id=$o(^CTLOC(0,"LocType","C",id))  quit:(id="")  do
	.set tmp=$g(^CTLOC(id))
	.quit:(tmp="")
	.set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", id, hospId)
	.quit:(showFlag="N")
	.set code=$p(tmp,"^",1)
	.set desc=$p(tmp,"^",2)
	.set checked=$s((($c(2)_superAuditLocStr_$c(2))[($c(2)_id_$c(2))):"true", 1:"false")
	.do OutputSuperAuditLoc
	
	quit $$$OK
	
OutputSuperAuditLoc
	set Data=$lb(id,code,desc,checked)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
