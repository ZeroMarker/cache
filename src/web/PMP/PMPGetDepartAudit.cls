Import SQLUser

/// 	Creator: liubaoshi
///   CreatDate: 2015-01-25
/// Description: 增加科室审核人
Class web.PMP.PMPGetDepartAudit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPGetDepartAudit","DepartAuditDetail","","")
Query DepartAuditDetail(loc As %String, user As %String, Type As %String, flag As %String) As %Query(ROWSPEC = "AuditRowid:%String,AuditLocDr:%String,AuditLocName:%String,AuditUserDr:%String,AuditUserName:%String,Typedesc:%String,Effect:%String")
{
}

ClassMethod DepartAuditDetailExecute(ByRef qHandle As %Binary, loc As %String, user As %String, Type As %String, flag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    s Id=0
    s ^Temp("DepartAuditDetailExecute")=loc_"^"_user_"^"_Type_"^"_flag
    i flag="Update" s Update="true"
    i loc'="" s loc=##Class(web.DHCINSUPort).GetCNCODE($tr(loc," "),4,"")
    i user'="" s user=##Class(web.DHCINSUPort).GetCNCODE($tr(user," "),4,"")
    f  Set Id=$o(^DepartAudit(Id)) Q:(Id="")  d
    .Set Loc=$p(^DepartAudit(Id),"^",1)
    .Set User=$p(^DepartAudit(Id),"^",2)
    .Set effecti=$p(^DepartAudit(Id),"^",3)
    .Set Spare=$p(^DepartAudit(Id),"^",4)
    .Q:(Type'="")&(Spare'=Type)
    .Q:'$d(^CTLOC(Loc))
    .Q:'$d(^SSU("SSUSR",User))
    .Set locname=$p(^CTLOC(Loc),"^",2)
    .s locdesc=##Class(web.DHCINSUPort).GetCNCODE(locname,4,"")_##Class(web.DHCINSUPort).GetCNCODE(locname,3,"")_locname
    .Q:(loc'="")&(locdesc'[loc)
    .i locname["-" s locname=$p(locname,"-",2)
    .Set username=$p(^SSU("SSUSR",User),"^",2)
    .s userdesc=##Class(web.DHCINSUPort).GetCNCODE(username,4,"")_##Class(web.DHCINSUPort).GetCNCODE(username,3,"")_username
    .Q:(user'="")&(userdesc'[user)
    .i Spare="L" s type="科室分配"
    .i Spare="F" s type="需求分配"
    .i effecti="Y" S effect="有效"
    .i effecti'="Y" S effect="无效"
    .q:(flag="true")&(effecti'="Y")
    .q:(flag'="true")&(effecti="Y")
	.Do QueryDepartAudit
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryDepartAudit
 	set Data=$lb(Id,Loc,locname,User,username,type,effect)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
 	Quit $$$OK
}

ClassMethod DepartAuditDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepartAuditDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DepartAuditDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepartAuditDetailExecute ]
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
	Quit $$$OK
}

Query SearchLoc(loc As %String) As %Query(ROWSPEC = "locname:%String,locid:%String")
{
}

ClassMethod SearchLocExecute(ByRef qHandle As %Binary, loc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	
    If $g(ind)="" Set ind=1
   	s rowid=0
	i $g(loc)=""  d
	.s loc="%"
	e  d
	.s loc=$$ALPHAUP^SSUTIL4(loc)
	.s loc=loc_"%"
	&sql(declare ctloc cursor  for 
	select distinct ctloc_desc,ctloc_rowid
	              from SQLUser.ct_loc 
	              WHERE (UPPER(ctloc_desc) like :loc))
	&sql(open ctloc)
	f  &sql(fetch ctloc into :locname,:locid) q:SQLCODE  d
 	.Do OutputRow	 	
 	&sql(close ctloc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(locname,locid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod SearchLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SearchLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchLocExecute ]
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
	Quit $$$OK
}

//增加

/// w ##class(web.PMP.PMPGetDepartAudit).AddInfo("12","1456","L")
ClassMethod AddInfo(loc As %Library.String, user As %Library.String, type As %Library.String)
{
	
	s Effect="Y",id=""
	s time=$p($h,",",2),date=+$H
	&sql(insert into PMP_DepartAudit(Audit_LocDr,Audit_UserDr,Audit_Effect,Audit_Spare) values(:loc,:user,:Effect,:type))
	i SQLCODE="0" d
	.S Rowid="" f  s Rowid=$o(^PMPPermission(Rowid)) q:Rowid=""  d
	..s type=$p(^PMPPermission(Rowid),"^",5)
	..q:type="N"
	..s id=Rowid,Rowid="9999999999999"
	.B ;1
	.i id'="" d
	..s type=$o(^PMPPermisBusinessi("PERBusUserDr",id,user,""))
	..i type'=""  d
	...B ;2
	...s status=$p(^PMPPermisBusiness(id,"E",type),"^",3)
	...i status="Y"  d
	....B ;3
	....&sql(insert into PMP_PermisBusiness(PMP_Permission_ParRef,PERBus_User_DR,PERBus_IsEffect,PERBus_Date,PERBus_Time) values (:id,:user,'Y',:date,:time))
    ...e  d
    ....s $p(^PMPPermisBusiness(id,"E",type),"^",3)="Y"
    q SQLCODE
}

//更新

ClassMethod UpdateInfo(rowid As %Library.String, loc As %Library.String, user As %Library.String, Effect As %Library.String, type As %Library.String)
{
	Q:loc="" 0
	Q:user="" 0
	&sql(update PMP_DepartAudit set Audit_LocDr=:loc,Audit_UserDr=:user,Audit_Effect=:Effect,Audit_Spare=:type where Audit_Rowid=:rowid)
    Q:SQLCODE -1
    Q 0
}

//查询User

Query UserName(user As %String) As %SQLQuery(CONTAINID = 1)
{
	select SSUSR_Name,SSUSR_Initials,SSUSR_RowId from SQLUSER.SS_User where  SSUSR_Name %STARTSWITH %ALPHAUP (:user) or SSUSR_Initials %STARTSWITH %ALPHAUP(:user)
}

///       Input: loc,user,type
///      Return：存在返回0,不存在返回1
///     Creator：liubaoshi
/// Description: 验证所赠记录是否存在
///       Table：PMP_DepartAudit
///       Other: w ##class(web.PMP.PMPGetDepartAudit).CheckInfo("54","3174","L")
ClassMethod CheckInfo(loc As %Library.String, user As %Library.String, type As %Library.String) As %Library.String
{
	Set ret=1
	Set Id=""
    For  Set Id=$o(^DepartAudit(Id)) Q:(Id="")  d
    .i ($p(^DepartAudit(Id),"^",1)=loc)&($p(^DepartAudit(Id),"^",2)=user)&($p(^DepartAudit(Id),"^",4)=type)  d
    ..Set ret=0  e  d  s ret=1
    Q ret
}

}
