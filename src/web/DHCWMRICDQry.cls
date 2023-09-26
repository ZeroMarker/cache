Import SQLUser

Class web.DHCWMRICDQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 56;

ClassMethod BuildData(repid, ind, s)
{
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	q
}

ClassMethod QryVersionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVersionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryVersionExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^DHCWMRICDV({RowId})
	s id=0
	f  s id=$o(^DHCWMRICDV(id)) q:id=""  d
	.s s=$g(^DHCWMRICDV(id))
	.q:$p(s,"^",4)'="Y"
	.s s=id_"^"_$p(s,"^",2)
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QryVersionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVersionExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRICDQry","QryVersion")
Query QryVersion() As %Query(ROWSPEC = "lsRowid:%String,lsDesc:%String")
{
}

ClassMethod QueryICDVersionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICDVersionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryICDVersionExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^DHCWMRICDV({RowId})
	s id=0
	f  s id=$o(^DHCWMRICDV(id)) q:id=""  d
	.s s=$g(^DHCWMRICDV(id))
	.;^DHCWMRDIC(0,"DicNameCode",{DictionaryName},{Code},{Rowid})
	.s ICDTpCode=$p(s,"^",3),ICDTpId="",ICDTp=""
	.s:ICDTpCode'="" ICDTpId=$o(^DHCWMRDIC(0,"DicNameCode","ICDType",ICDTpCode,0))
	.s:ICDTpId'="" ICDTp=$g(^DHCWMRDIC(ICDTpId))
	.s:ICDTp'="" $p(s,"^",3)=ICDTpId_"/"_ICDTpCode_"/"_$P(ICDTp,"^",3)
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryICDVersionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICDVersionExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRICDQry","QueryICDVersion")
Query QueryICDVersion() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,ItemTypeDr:%String,IsActive:%String,ResumeText:%String")
{
}

ClassMethod QueryICDDxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICDDxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryICDDxExecute(ByRef qHandle As %Binary, Alias As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Alias=$g(Alias)
	i Alias="" d
	.;查询全部
	.;^DHCWMRICD({RowId})
	.s id=0
	.f  s id=$o(^DHCWMRICD(id)) q:id=""  d
	..q:'$d(^DHCWMRICD(id))
	..s s=$g(^DHCWMRICD(id))
	..s VersionId=+$p(s,"^",4)
	..s:VersionId'=0 $p(s,"^",4)=VersionId_"/"_$tr($g(^DHCWMRICDV(VersionId)),"^","/")
	..s s=id_"^"_s
	..d ..BuildData(repid,ind,s)
	..s ind=ind+1
	e  d
	.;通过别名查询
	.;^DHCWMRICDA(0,"Alias","Z"_$$ALPHAUP({Alias}),{ICDDxDr},{RowId})
	.s Alias="Z"_##Class(web.DHCWMRICDCtl).ALPHAUP(Alias)
	.s:$d(^DHCWMRICDA(0,"Alias",Alias)) ind=$$xGetICDDx(repid,ind,Alias)
	.s tmpAlias=Alias
	.f  s tmpAlias=$o(^DHCWMRICDA(0,"Alias",tmpAlias)) q:(tmpAlias="")||($e(tmpAlias,1,$l(Alias))'=Alias)  d
	..s ind=$$xGetICDDx(repid,ind,tmpAlias)
	Quit $$$OK
	
xGetICDDx(repid,ind,tmpAlias)
	n (repid,ind,tmpAlias)
	s id=0
	f  s id=$o(^DHCWMRICDA(0,"Alias",tmpAlias,id)) q:id=""  d
	.q:'$d(^DHCWMRICD(id))
	.s s=$g(^DHCWMRICD(id))
	.s VersionId=+$p(s,"^",4)
	.s:VersionId'=0 $p(s,"^",4)=VersionId_"/"_$tr($g(^DHCWMRICDV(VersionId)),"^","/")
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
	q ind
}

ClassMethod QueryICDDxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICDDxExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRICDQry","QueryICDDx")
Query QueryICDDx(Alias As %String) As %Query(ROWSPEC = "Rowid:%String,ICD:%String,ICD1:%String,Name:%String,Version:%String,ResumeText:%String,IsActive:%String")
{
}

ClassMethod QueryICDAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICDAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryICDAliasExecute(ByRef qHandle As %Binary, ICDDxId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	;^DHCWMRICDA(0,"ICDDxDr",{ICDDxDr},{RowId})
	Set ICDDxId=+ICDDxId
	Quit:'$d(^DHCWMRICDA(0,"ICDDxDr",ICDDxId)) $$$OK
	
	s id=0
	f  s id=$o(^DHCWMRICDA(0,"ICDDxDr",ICDDxId,id)) q:id=""  d
	.s s=$g(^DHCWMRICDA(id))
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryICDAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICDAliasExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRICDQry","QueryICDAlias")
Query QueryICDAlias(ICDDxId As %String) As %Query(ROWSPEC = "Rowid:%String,ICDDxDr:%String,Alias:%String")
{
}

ClassMethod QueryICDExplainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICDExplainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryICDExplainExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^DHCWMRICDE({RowId})
	s id=0
	f  s id=$o(^DHCWMRICDE(id)) q:id=""  d
	.s s=$g(^DHCWMRICDE(id))
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryICDExplainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICDExplainExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRICDQry","QueryICDExplainExecute")
Query QueryICDExplain() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,IsActive:%String,ResumeText:%String")
{
}

ClassMethod QryICDDxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDDxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryICDDxExecute(ByRef qHandle As %Binary, Alias As %String, Version As %String, Active As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Alias=$g(Alias),Version=$g(Version),Active=$g(Active)
	q:Alias="" $$$OK
	s:Active'="" Active=$s($g(Active)["Y":"Y",1:"N")
	;通过别名查询
	;^DHCWMRICDA(0,"Alias","Z"_$$ALPHAUP({Alias}),{ICDDxDr},{RowId})
	s Alias="Z"_##Class(web.DHCWMRICDCtl).ALPHAUP(Alias)
	s:$d(^DHCWMRICDA(0,"Alias",Alias)) ind=$$yGetICDDx(repid,ind,Alias,Version,Active)
	s tmpAlias=Alias
	f  s tmpAlias=$o(^DHCWMRICDA(0,"Alias",tmpAlias)) q:(tmpAlias="")||($e(tmpAlias,1,$l(Alias))'=Alias)  d
	.s ind=$$yGetICDDx(repid,ind,Alias,Version,Active)
	
	Quit $$$OK
	
yGetICDDx(repid,ind,tmpAlias,Version,Active)
	n (repid,ind,tmpAlias,Version,Active)
	s id=0
	f  s id=$o(^DHCWMRICDA(0,"Alias",tmpAlias,id)) q:id=""  d
	.q:'$d(^DHCWMRICD(id))
	.s s=$g(^DHCWMRICD(id))
	.s tmpActive=$p(s,"^",6)
	.q:((Active'="")&&(Active'=tmpActive))
	.s tmpVersionId=+$p(s,"^",4)
	.q:((Version'="")&&(Version'=tmpVersionId))
	.;s:tmpVersionId'=0 tmpVersion=$g(^DHCWMRICDV(tmpVersionId))
	.;s s=id_"^"_$p($g(tmpVersion),"^",2)_"  "_$p(s,"^",1)_"  "_$p(s,"^",3)
	.s s=id_"^"_$p(s,"^",1)_"  "_$p(s,"^",3)
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
	q ind
}

ClassMethod QryICDDxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDDxExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRICDQry","QryICDDx",Alias,Version,Active)
/// ICD别名、版本、有效标记-->ICD编码/手术编码
Query QryICDDx(Alias As %String, Version As %String, Active As %String) As %Query(ROWSPEC = "lsRowid:%String,lsDesc:%String")
{
}

}
