Import SQLUser

Class web.UDHCJFSSGrpDepTypeSet Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.UDHCJFSSGrpDepTypeSet","FindDepType")
Query FindDepType() As websys.Query(ROWSPEC = "type:%String:押金类型,rowid:%String:ID")
{
}

ClassMethod FindDepTypeExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set rowid=0
	for  set rowid=$o(^ARC("ARCDT",rowid)) quit:(rowid="")  do
	.set name=$p(^ARC("ARCDT",rowid),"^",2)
	.do OutputDepType
	
	quit $$$OK
OutputDepType 
    set Data=$lb(name,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query FindSSGRP(SSGrp As %String, HospId As %String) As websys.Query(ROWSPEC = "group:%String:安全组,rowid:%String:ID")
{
}

ClassMethod FindSSGRPExecute(ByRef qHandle As %Binary, SSGrp As %String, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

	if (SSGrp'="") do
    .set SSGrp=$$ALPHAUP^SSUTIL4(SSGrp)
    
	set rowid=0
	for  set rowid=$o(^SSU("SSGRP",rowid)) quit:(rowid="")  do
	.set name=$p(^SSU("SSGRP",rowid),"^",1)
	.quit:((SSGrp'="")&&($$ALPHAUP^SSUTIL4(name)'[SSGrp))
	.set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_Group", rowid, HospId)
	.quit:(showFlag="N")
	.do OutPutSSGRP

	quit $$$OK
OutPutSSGRP
    set Data=$lb(name,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFSSGrpDepTypeSet","FindGrpDepType","")
Query FindGrpDepType(UserGrp As %String, HospId As %String) As websys.Query(ROWSPEC = "rowid:%String,grp:%String,depType:%String,def:%String,grpDr:%String,depTypeDr:%String")
{
}

ClassMethod FindGrpDepTypeExecute(ByRef qHandle As %Binary, UserGrp As %String, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (+HospId=0) quit $$$OK
	
	if (UserGrp="") do
	.set rowid=0
	.for  set rowid=$o(^DHCJFSSGRPDEPTYPECONFIG(rowid)) quit:(rowid="")  do
	..set tmp=$g(^DHCJFSSGRPDEPTYPECONFIG(rowid))
	..quit:(tmp="")
	..set myHospDR=$p(tmp,"^",6)
	..quit:(HospId'=myHospDR)
	..set grpDr=$p(tmp,"^",1)
	..quit:(+grpDr=0)
	..set grp=$p($g(^SSU("SSGRP",grpDr)),"^",1)
	..set depTypeDr=$p(tmp,"^",2)
	..set depType=$p($g(^ARC("ARCDT",depTypeDr)),"^",2)
	..set def=$p(tmp,"^",3)
	..do OutputGrpDepType
	else  do
	.set rowid=0
	.for  set rowid=$o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",UserGrp,rowid)) quit:(rowid="")  do
	..set tmp=$g(^DHCJFSSGRPDEPTYPECONFIG(rowid))
	..quit:(tmp="")
	..set myHospDR=$p(tmp,"^",6)
	..quit:(HospId'=myHospDR)
	..set grpDr=$p(tmp,"^",1)
	..quit:(+grpDr=0)
	..set grp=$p($g(^SSU("SSGRP",grpDr)),"^",1)
	..set depTypeDr=$p(tmp,"^",2)
	..set depType=$p($g(^ARC("ARCDT",depTypeDr)),"^",2)
	..set def=$p(tmp,"^",3)
	..do OutputGrpDepType
	  
	quit $$$OK
OutputGrpDepType 
    set Data=$lb(rowid,grp,depType,def,grpDr,depTypeDr)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod AddInfo(Grp As %String, DepType As %String, Default As %String, HospId As %String)
{
	&sql(INSERT INTO DHC_JFSSGrpDepTypeConfig(Grp_Dr,Grp_DepType_Dr,Grp_Default,Grp_Hosp_Dr) 
	VALUES(:Grp,:DepType,:Default,:HospId))
    
    quit SQLCODE
}

/// 删除
ClassMethod DelInfo(rowid As %String)
{
	&sql(DELETE FROM DHC_JFSSGrpDepTypeConfig WHERE Grp_RowId=:rowid)
	quit SQLCODE
}

/// 判断记录是否存在
/// w ##class(web.UDHCJFSSGrpDepTypeSet).CheckInfo()
ClassMethod CheckInfo(grp As %String, drpType As %String, deft As %String, hospId As %String)
{
	s rtn=1
	s rowId=0
	f  s rowId=$o(^DHCJFSSGRPDEPTYPECONFIG(rowId)) q:(rowId="")  d
	.s tmp=$g(^DHCJFSSGRPDEPTYPECONFIG(rowId))
	.q:(tmp="")
	.s myHospDR=$p(tmp,"^",6)
	.q:(myHospDR'=hospId)
	.i ($p(tmp,"^",1)=grp)&&($p(tmp,"^",2)=drpType) d
	..s rtn=0
	.i ($p(tmp,"^",1)=grp)  d
	..i ((deft="Y")&&($p(tmp,"^",3)=deft))  d
	...s rtn=-1
	q rtn
}

/// Creator: tangzf
/// CreateDate: 2019-06-09
/// Descript: 判断记录是否存在(仅更新记录判断使用)
/// Input:	grp: 安全组
/// 		drpType: 押金类型
/// 		deft: 是否默认
/// Output: 
/// Return: rtn(-1:存在相同信息, -2:该安全组下存在默认值)
/// Debug: w ##class(web.UDHCJFSSGrpDepTypeSet).CheckInfoForUpdate("90","240","1","N")
ClassMethod CheckInfoForUpdate(rowId As %String, grp As %String, drpType As %String, defFlag As %String, hospId As %String) As %String
{
	s rtn=0
	s myId=0
	f  s myId=$o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",grp,myId)) q:((myId="")||(rtn'=0))  d
	.s tmp=$g(^DHCJFSSGRPDEPTYPECONFIG(myId))
	.q:(tmp="")
	.s myHospDR=$p(tmp,"^",6)
	.q:(myHospDR'=hospId)
	.s myDepTypeDR=$p(tmp,"^",2)
	.s myDefFlag=$p(tmp,"^",3)
	.i (rowId'=myId) d
	..i (myDepTypeDR=drpType)  d
	...s rtn=-1
	..i ((defFlag="Y")&&(myDefFlag="Y")) d
	...s rtn=-2
	
	q rtn
}

/// Creator: tangzf
/// CreateDate: 2019-06-09
/// Descript: 更新DHC_JFSSGrpDepTypeConfig
/// Input:	rowid : 更新DHC_JFSSGrpDepTypeConfig.Grp_RowId
/// 		DefaultVal  : 是否默认
/// 		Group : 安全组
/// 		DepType  : 押金类型
/// Output: 
/// Return: SQLCODE
/// DeBug: 
/// w ##class(web.UDHCJFSSGrpDepTypeSet).UpdateInfo()
ClassMethod UpdateInfo(rowid As %String, Group As %String, DepType As %String, DefaultVal As %String)
{
   &sql(UPDATE DHC_JFSSGrpDepTypeConfig SET Grp_Dr=:Group,Grp_DepType_Dr=:DepType,Grp_Default=:DefaultVal WHERE Grp_RowId=:rowid)
   q SQLCODE
}

}
