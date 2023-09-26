Import SQLUser

/// Creator：李阳
/// Description：用来进行字典信息维护
Class web.DHCMedDictoryCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

/// 通过字典类型/是否活动获取字典列表
/// Type：字典类型
/// Flag：是否活动 是：Y，否：N
ClassMethod GetByType(Type, Flag) As %String
{
		n (Type, Flag)
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
	    zn MEDDATA
	    s iCount=$$QueryByType^DHCMedDictory(Type, Flag)
		zn CurrentNS
		s s=""
	q:iCount<0 s	
		f i=0:1:iCount d
		.s s=s_$g(PLIST(i))_$c(1)
		q s
}

/// 通过字典类型/字典代码获取字典项
/// Type：字典类型
/// Code：字典Code
ClassMethod GetByTypeCode(Type, Code)
{
	n (Type,Code)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s s=$$QueryByTypeCode^DHCMedDictory(Type,Code)
	zn CurrentNS
	s:s'="" s=$p(s,"^",3)	
	q s
}

ClassMethod QueryByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByTypeExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;s ^WUQK(0)=Type_"/"_Flag
	;s:Type="" Type="EpidemicAppendixItem"
	;s:Flag="" Flag="Y"
	;s ^WUQK(1)=Type_"/"_Flag
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s iCount=$$QueryByType^DHCMedDictory(Type,Flag)
    zn CurrentNS
	q:iCount<0 $$$OK	
	f i=0:1:iCount d
	.s s=$g(PLIST(i))
	.d BuildData

	Quit $$$OK
BuildData      
	;set Data=$lb(id,code,desc,Fpfl,Lb)
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeExecute ]
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

/// 通过类型获取字典项目
Query QueryByType(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QueryInfectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInfectionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryInfectionExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s iCount=$$QueryAll^DHCMedInfection("")
    s JIndex=$p(iCount,"^",2),iCount=+iCount
    zn CurrentNS
	q:iCount<0 $$$OK	
	f i=0:1:iCount d
	.zn MEDDATA
	.s s=$$GetDataByIndex^DHCMedInfection(JIndex,i)
	.zn CurrentNS
	.d BuildDataInfection

	Quit $$$OK
BuildDataInfection
	;set Data=$lb(id,code,desc,Fpfl,Lb)
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryInfectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInfectionExecute ]
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

/// 查询传染病
Query QueryInfection() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,Type:%String,Rank:%String,Appendix:%String,Multi:%String,Dependence:%String,TimeLimit:%String")
{
}

ClassMethod QryInfByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryInfByAliasExecute(ByRef qHandle As %Binary, DiagAlias) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s DiagAlias=$$ALPHAUP^SSUTIL4(DiagAlias)
	;^DHCMIF(Rowid)
	;^DHCMIF(0,"InfALIAS",{MIFA_Alias},{DHC_MedInfection.MIF_RowId},{MIFA_ChildSub})
	s Rowid=0
	f  s Rowid=$o(^DHCMIF(Rowid)) q:Rowid=""  d
	.s tmp=$g(^DHCMIF(Rowid))
	.s DiagCode=$p(tmp,"^",1)
	.s DiagDesc=$p(tmp,"^",2)
	.s AliasSub=0,AliasFlag=0
	.f  s AliasSub=$o(^DHCMIF(Rowid,"InfALIAS",AliasSub)) q:((AliasSub="")||(AliasFlag=1))  d
	..s AliasTmp=$g(^DHCMIF(Rowid,"InfALIAS",AliasSub))
	..q:(DiagAlias'="")&&(AliasTmp'[DiagAlias)
	..s AliasFlag=1
	.s AliasSub=0
	.f  s AliasSub=$o(^DHCMIF(Rowid,"InfAlias",AliasSub)) q:((AliasSub="")||(AliasFlag=1))  d
	..s AliasTmp=$g(^DHCMIF(Rowid,"InfAlias",AliasSub))
	..q:(DiagAlias'="")&&(AliasTmp'[DiagAlias)
	..s AliasFlag=1
	.q:(DiagAlias'="")&&(DiagDesc'[DiagAlias)&&(AliasFlag'=1)
	.s s=Rowid_"^"_tmp
	.d BuildDataInfection
	
	Quit $$$OK
}

ClassMethod QryInfByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfByAliasExecute ]
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

/// 根据别名或名称查询传染病
/// d ##Class(%ResultSet).RunQuery("web.DHCMedDictoryCtl","QryInfByAlias","肝炎")
Query QryInfByAlias(DiagAlias) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,Type:%String,Rank:%String,Appendix:%String,Multi:%String,Dependence:%String,TimeLimit:%String")
{
}

/// 获取传染病报告
/// infRowID：传染病报告
ClassMethod GetInfection(InfRowid)
{
	n (InfRowid)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s s=$$GetData^DHCMedInfection(InfRowid)
	zn CurrentNS
	q s
}

}
