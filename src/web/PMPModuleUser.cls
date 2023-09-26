Import Sqluser

Class web.PMPModuleUser Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod insertModuleUser(ProjectRowid As %String, ModuleDRHidden As %String, remark As %String, MduStDate As %String, MduEnDate As %String, MduStTime As %String, MduEnTime As %String, TModuleUserid As %String) As %String
{
	s userid=%session.Get("LOGON.USERID")  i userid=""  s userid=1
	
	if MduStDate'="" s MduStDate=$zdh(MduStDate,4)
	if MduEnDate'="" s MduEnDate=$zdh(MduEnDate,4)
	if MduStTime'="" s MduStTime=$zth(MduStTime)
	if MduEnTime'="" s MduEnTime=$zth(MduEnTime)
	
	set Date = +$h
	set Time = $p($h,",",2)
	if TModuleUserid'="" {
	s object = ##class(User.PMPModuleUser).%OpenId(TModuleUserid)
		}else{
	s object = ##class(User.PMPModuleUser).%New()		
			}
	
	s objProUser=##class(User.PMPProjectUser).%OpenId(ProjectRowid)
	s object.MDUUserDR=objProUser
	s objModule=##class(User.PMPModule).%OpenId(ModuleDRHidden)
	s ^shen(2211)=ModuleDRHidden
	s object.MDUModuleDR=objModule
	s object.MDURemark=remark
	s object.MDUStDate=MduStDate
	s object.MDUEnDate=MduEnDate
	s objUser=##class(User.SSUser).%OpenId(userid)
	s object.MDUUserDR1=objUser
	s object.MDUStTime=MduStTime
	s object.MDUEnTime=MduEnTime
	s object.MDUDate=Date
	s object.MDUTime=Time
	s object.MDUFalg="Yes"
	
	s sc=object.%Save()
	
	;&sql(INSERT INTO SQLUser.PMP_ModuleUser (MDU_User_DR, MDU_Module_DR, MDU_Remark, MDU_StDate, MDU_EnDate, MDU_User_DR1, MDU_StTime, MDU_EnTime, MDU_Date, MDU_Time, MDU_Falg, MDU_Standby1, MDU_Standby2, MDU_Standby3, MDU_Standby4, MDU_Standby5, MDU_Standby6, MDU_Standby7)
	;VALUES (:ProjectRowid,:ModuleDRHidden,:remark,:MduStDate,:MduEnDate,:userid,:MduStTime,:MduEnTime,:Date,:Time,"Y","","","","","","",""))
 	Quit sc
}

ClassMethod delModuleUser(TModuleUserid As %String) As %String
{
	
	;s object = ##class(User.PMPModuleUser).%OpenId(TModuleUserid)
	;s sc=object.%Delete()
	;&sql(INSERT INTO SQLUser.PMP_ModuleUser (MDU_User_DR, MDU_Module_DR, MDU_Remark, MDU_StDate, MDU_EnDate, MDU_User_DR1, MDU_StTime, MDU_EnTime, MDU_Date, MDU_Time, MDU_Falg, MDU_Standby1, MDU_Standby2, MDU_Standby3, MDU_Standby4, MDU_Standby5, MDU_Standby6, MDU_Standby7)
	;VALUES (:ProjectRowid,:ModuleDRHidden,:remark,:MduStDate,:MduEnDate,:userid,:MduStTime,:MduEnTime,:Date,:Time,"Y","","","","","","",""))
 	&sql(delete from SQLUser.PMP_ModuleUser where MDU_Rowid=:TModuleUserid)
 	
 	Quit SQLCODE
}

//d ##class(%ResultSet).RunQuery("web.PMPPermission","QueryPermission","","")

Query QueryModuleUser(ProjectRowid As %String, PUModNamejs As %String) As %Query(ROWSPEC = "TRowid:%String,TMDUUser:%String,TMDUModule:%String,TMDUModuleID:%String,TMDURemark:%String,TMDUStDate:%String,TMDUEnDate:%String,TMDUStTime:%String,TMDUEnTime:%String,TMDUDate:%String,TMDUTime:%String")
{
}

ClassMethod QueryModuleUserExecute(ByRef qHandle As %Binary, ProjectRowid As %String, PUModNamejs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1 
    i PUModNamejs'="" s PUModNamejs=##class(web.DHCINSUPort).GetCNCODE($tr(PUModNamejs," "),4,"")
    s Rowid=0 f  s Rowid=$o(^PMPModuleUser(Rowid)) q:(Rowid="")  d
    .s TRowid=Rowid
    .s proUserid=$p(^PMPModuleUser(Rowid),"^",10)
    .q:'$d(^PMPProjectUser(proUserid))
    .s SSUserid=$p(^PMPProjectUser(proUserid),"^",1)
    .s TMDUUser=$P(^SSU("SSUSR",SSUserid),"^",2)
    .i ProjectRowid'=""  q:proUserid'=ProjectRowid
    .q:ProjectRowid=""
    .s TMDUModuleID=$p(^PMPModuleUser(Rowid),"^",5)  //userid
    .s TMDUModule=$P(^PMPModule(TMDUModuleID),"^",2)
    .s TMDUModeCode=$P(^PMPModule(TMDUModuleID),"^",1)
    .i TMDUModule'="" s modesesc=##class(web.DHCINSUPort).GetCNCODE($tr(TMDUModule," "),4,"")_TMDUModule_##class(web.DHCINSUPort).GetCNCODE($tr(TMDUModeCode," "),4,"")
    .q:(PUModNamejs'="")&($g(modesesc)'[PUModNamejs)
    .s TMDURemark=$p(^PMPModuleUser(Rowid),"^",6)
    .s TMDUStDate=$zd($p(^PMPModuleUser(Rowid),"^",7),3)  //
    .s TMDUEnDate=$p(^PMPModuleUser(Rowid),"^",2) ;  //
    .i TMDUEnDate'="" s TMDUEnDate=$zd(TMDUEnDate,3)
    .s TMDUStTime=$zt($p(^PMPModuleUser(Rowid),"^",8))  //
    .s TMDUEnTime=$p(^PMPModuleUser(Rowid),"^",3) ;$zt()  //
    .i TMDUEnTime'="" s TMDUEnTime=$zt(TMDUEnTime)
    .s TMDUDate=$zd($p(^PMPModuleUser(Rowid),"^",1),3)  //
    .s TMDUTime=$zt($p(^PMPModuleUser(Rowid),"^",9))  //
    .d OutputRow
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TRowid,TMDUUser,TMDUModule,TMDUModuleID,TMDURemark,TMDUStDate,TMDUEnDate,TMDUStTime,TMDUEnTime,TMDUDate,TMDUTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QueryModuleUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryModuleUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryModuleUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryModuleUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
