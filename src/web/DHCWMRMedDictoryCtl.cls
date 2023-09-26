Import SQLUser

/// Creator：李阳
/// Description：用来进行字典信息维护
Class web.DHCWMRMedDictoryCtl Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 91;

/// 通过字典类型/是否活动获取字典列表
/// Type：字典类型
/// Flag：是否活动 是：Y，否：N
ClassMethod GetByType(Type, Flag) As %String
{
	n (Type, Flag)
	s iCount=..QueryByTypeM(Type, Flag)
	s s=""
	q:iCount<0 s	
	f i=0:1:iCount d
	.s s=s_$g(PLIST(i))_$c(1)
	q s
}

ClassMethod QueryByTypeM(Type, Flag)
{
    ;k (Type,Flag)
    k PLIST,MLIST
    k ^CacheTemp($zn,$j)
    ;Index TYPE  : ^DHCMDIC("0","TYPE",{MDIC_Type},{MDIC_Active},{MDIC_Rowid})                           
    q:Type="" -1
    q:'$d(^DHCMDIC("0","TYPE",Type)) -100
    ;i Flag'="" d
    ;.q:'$d(^DHCMDIC("0","TYPE",Type,Flag))
    s n=0
    i Flag="" d
    .s sFlag=""
    .f  s sFlag=$o(^DHCMDIC("0","TYPE",Type,sFlag))  q:sFlag=""  d
    ..s MDICRowid=""
    ..f  s MDICRowid=$o(^DHCMDIC("0","TYPE",Type,sFlag,MDICRowid))  q:MDICRowid=""  d
    ...;s MLIST(n)=$$GetDataById(MDICRowid)
    ...;s n=n+1
    ...q:MDICRowid=""
    ...s DicCode=$p($g(^DHCMDIC(MDICRowid)),"^",1)
    ...q:DicCode=""
    ...s ^CacheTemp($zn,$j,DicCode,MDICRowid)=MDICRowid
    e  d
    .q:'$d(^DHCMDIC("0","TYPE",Type,Flag)) 
    .s MDICRowid=""
    .f  s MDICRowid=$o(^DHCMDIC("0","TYPE",Type,Flag,MDICRowid))  q:MDICRowid=""  d
    ..;s MLIST(n)=$$GetDataById(MDICRowid)
    ..;s n=n+1
    ..q:MDICRowid=""
    ..s DicCode=$p($g(^DHCMDIC(MDICRowid)),"^",1)
    ..q:DicCode=""
    ..s ^CacheTemp($zn,$j,DicCode,MDICRowid)=MDICRowid
    
    s tmpCode=""
    f  s tmpCode=$o(^CacheTemp($zn,$j,tmpCode)) q:tmpCode=""  d
    .s tmpRowid=0
    .f  s tmpRowid=$o(^CacheTemp($zn,$j,tmpCode,tmpRowid)) q:tmpRowid=""  d
    ..s MLIST(n)=..GetDataById(tmpRowid)
    ..s n=n+1
    k ^CacheTemp($zn,$j)
    
    m PLIST=MLIST
    k MLIST
    q n-1
}

ClassMethod GetDataById(MDICRowid)
{
    n (MDICRowid)
    q:'$d(^DHCMDIC(MDICRowid)) ""
    s s=$g(^DHCMDIC(MDICRowid))
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($p(s,"^",5),3)
    s:$p(s,"^",6)'="" $p(s,"^",6)=$zd($p(s,"^",6),3)
    s s=MDICRowid_"^"_s
    q s
}

/// 通过字典类型/字典代码获取字典项
/// Type：字典类型
/// Code：字典Code
ClassMethod GetByTypeCode(Type, Code)
{
	n (Type,Code)
	s s=..QueryByTypeCode(Type,Code)
	zn CurrentNS
	s:s'="" s=$p(s,"^",3)	
	q s
}

//通过字典类型、代码查询字典项

ClassMethod QueryByTypeCode(Type, Code)
{
    n (Type,Code)
    k PLIST,MLIST
    ;Index Type-Code : ^DHCMDIC("0","TypeCode",{MDIC_Type},{MDIC_Code},{MDIC_Rowid})
    q:(Type="")!(Code="") -1
    q:'$d(^DHCMDIC("0","TypeCode",Type,Code)) -100
    s MDICRowid=$o(^DHCMDIC("0","TypeCode",Type,Code,""),-1)
    s s=..GetDataById(MDICRowid)
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
	
    
    s iCount=..QueryByTypeM(Type,Flag)
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
	
    s iCount=..QueryAll("")
    s JIndex=$p(iCount,"^",2),iCount=+iCount
    zn CurrentNS
	q:iCount<0 $$$OK	
	f i=0:1:iCount d
	.zn MEDDATA
	.s s=..GetDataByIndex(JIndex,i)
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

ClassMethod GetDataByIndex(JIndex, CIndex)
{
    n (JIndex,CIndex)
    q:'$d(^CacheTemp("MedInf",JIndex,CIndex)) ""
    s s=$g(^CacheTemp("MedInf",JIndex,CIndex))
    i $o(^CacheTemp("MedInf",JIndex,""),-1)=CIndex k ^CacheTemp("MedInf",JIndex)
    q s
}

ClassMethod QueryAll(NoPara)
{
     k ^CacheTemp("MedInf",$j)
     s i=0
     s InfRowid="0"
     f  s InfRowid=$o(^DHCMIF(InfRowid)) q:InfRowid=""  d
     .s ^CacheTemp("MedInf",$j,i)=..GetData(InfRowid)
     .s i=i+1
     q i-1_"^"_$j
}

ClassMethod GetData(Rowid)
{
     n (Rowid)
     s s=""
     q:'$d(^DHCMIF(+Rowid)) s
     s s=Rowid_"^"_$g(^DHCMIF(Rowid))
     q s
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
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRMedDictoryCtl","QryInfByAlias","肝炎")
Query QryInfByAlias(DiagAlias) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,Type:%String,Rank:%String,Appendix:%String,Multi:%String,Dependence:%String,TimeLimit:%String")
{
}

/// 获取传染病报告
/// infRowID：传染病报告
ClassMethod GetInfection(InfRowid)
{
	n (InfRowid)
	s s=..GetData(InfRowid)
	q s
}

}
