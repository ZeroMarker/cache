Import SQLUSER

/// CTOR: QP
/// DATE: 2019-03-08
/// DESC: 检查树医嘱项目所对应安全组设置
Class web.DHCAppTreeGroup Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 保存相关的安全组
/// IN  : IdStr：有权限的安全组id串
/// OUT : 0 成功
/// TABL: 
/// EXEC: w ##class(web.DHCAppTreeGroup).SaveTreeGroup(^TEMP("SaveTreeGroup",11),^TEMP("SaveTreeGroup",22),^TEMP("SaveTreeGroup",33))
ClassMethod SaveTreeGroup(MenuID, IdStr, Length) As %String
{
	n (MenuID,IdStr,Length)
	s ^TEMP("SaveTreeGroup",11)=MenuID
	s ^TEMP("SaveTreeGroup",22)=IdStr
	s ^TEMP("SaveTreeGroup",33)=Length
	q:(Length=0)||(MenuID="") 0
	s LinkDr=MenuID
	s TraID=+LinkDr
	s LinkSub=$p(LinkDr,"||",2)
	s Err=0
	TS
	f i=1:1:Length {
		q:Err'=0
		s cStr=$p(IdStr,",",i)
		s GroupDr=$p(cStr,"-",1)
		s IsAuth=$p(cStr,"-",2)
		if $d(^DHCAPPTRA(0,"TreeGroup",GroupDr,TraID,LinkSub)) {	//存在更新
			s ChildSub=$o(^DHCAPPTRA(0,"TreeGroup",GroupDr,TraID,LinkSub,""))
			s RowId=MenuID_"||"_ChildSub
			&SQL(UPDATE DHC_AppTreeGroup SET TRA_IsAuth=:IsAuth WHERE TRA_RowID=:RowId)
			i SQLCODE  s Err="-101"
		} else { //插入
			s ChildSub=$o(^DHCAPPTRA(TraID,"I",LinkSub,"G",""),-1)+1
			b ;001
   			&SQL(INSERT INTO DHC_AppTreeGroup(TRA_Link_ParRef,TRA_ChildSub,TRA_GroupDR,TRA_IsAuth) 
				VALUES(:LinkDr,:ChildSub,:GroupDr,:IsAuth))
			i SQLCODE  s Err="-102"
		}
	}
	i Err'=0 {
		TRO
		Q Err
	}
	TC
	
    Q Err
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 判断安全组是否有权限
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCAppTreeGroup).SaveTreeGroup("903||1")
ClassMethod GetHasAuthGroup(MenuID As %String, GroupId) As %String
{
	n (MenuID,GroupId)
	s mRtn=0
	q:MenuID="" mRtn
	s Paref=+MenuID,Subref=$p(MenuID,"||",2)
	s Child=""
	f  s Child=$o(^DHCAPPTRA(Paref,"I",Subref,"G",Child)) q:(Child="")||(mRtn=1)  d
	.s groupDr=$P(^DHCAPPTRA(Paref,"I",Subref,"G",Child),"^",1)
	.s hasAuth=$P(^DHCAPPTRA(Paref,"I",Subref,"G",Child),"^",2)
	.q:groupDr'=GroupId
	.q:hasAuth'=1
	.s mRtn=1 
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 查询项目安全组权限
/// IN  : 
/// OUT : 
/// TABL: PAC_AdmTypeLocation
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCAppTreeGroup","QryArcimAuth","2||1")
Query QryArcimAuth(MenuID As %String = "", GroupDesc = "") As %Query(CONTAINID = 1, ROWSPEC = "SSGroupID:%String,SSGroupDesc:%String,HasMenuAccess:%String")
{
}

ClassMethod QryArcimAuthExecute(ByRef qHandle As %Binary, MenuID As %String = "", GroupDesc = "") As %Status
{
	Set repid = $I(^CacheTemp)
 	If $g(ind) = "" Set ind = 1
 	i MenuID="" Set qHandle = $lb(0,repid,0) Quit $$$OK
 	//s desc = $$ALPHAUP^SSUTIL4(desc)
 	Set GroupDescUp = $ZCVT(GroupDesc,"U")
	&sql(DECLARE cSSGroup CURSOR FOR SELECT SSGRP_Rowid, SSGRP_Desc INTO :SSGroupID,:SSGroupDesc FROM SQLUser.SS_Group order by SSGRP_Desc)
	&sql(open cSSGroup)
	while (SQLCODE=0){
		&sql(fetch  cSSGroup)
		Quit:SQLCODE'=0
		Continue:SSGroupID'>0
		Continue:(GroupDesc'="")&&($zcvt(SSGroupDesc,"U")'[GroupDescUp)
		s HasMenuAccess=..GetHasAuthGroup(MenuID,SSGroupID)
		
		set data=$LB(SSGroupID,SSGroupDesc,HasMenuAccess)
		set ^CacheTemp(repid,ind)=data
		set ind=ind+1
	}
	&sql(close cSSGroup)
 	Set qHandle = $lb(0,repid,0)
 	Quit $$$OK
OutputRow1
	set Data = $lb(rowid,OPLocdesc,ContactName)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
	Quit
}

ClassMethod QryArcimAuthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimAuthExecute ]
{
 Set AtEnd = $LIST(qHandle,1)
 Set repid = $LIST(qHandle,2)
 Set ind = $LIST(qHandle,3)
 Set ind = $o(^CacheTemp(repid,ind))
 If ind = "" {				// if there are no more rows, finish fetching
	 Set AtEnd = 1
	 Set Row = ""
 }
 Else  {				// fetch row
	 Set Row = ^CacheTemp(repid,ind)
	 }
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryArcimAuthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimAuthExecute ]
{
 Set repid = $LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
