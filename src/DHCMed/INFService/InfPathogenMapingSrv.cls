/// 名称: DHCMed.INFService.InfPathogenDicSrv
/// 描述: DHCMed.INF.InfPathogenMaping 病原体对照维护的常用操作
/// 编写者：liuyh
/// 编写日期: 2010-05-24
Class DHCMed.INFService.InfPathogenMapingSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// *************************************************************
/// CreateDate  ：2009-11-14 Add By ZF
/// Description ：取病原体（细菌）字典
/// Table       ：[LabData]CT_Bugs
/// Input       ：Code,Desc,IsActive
/// Output      ：BugsCode 病原体代码,BugsDesc 病原体名称
/// Others      ：d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfPathogenMapingSrv","QryBugsDic","","菌","Y")
/// *************************************************************
Query QryBugsDic(Code As %String, Alias As %String, IsActive As %String) As %Query(ROWSPEC = "BugsCode:%String,BugsDesc:%String")
{
}

ClassMethod QryBugsDicExecute(ByRef qHandle As %Binary, Code As %String, Alias As %String, IsActive As %String) As %Status
{
 	Set repid=$i(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set IsActive=$Select(IsActive["Y":"Y",IsActive["N":"N",1:"")
	If (Code'="")
	{
	 	Set BugsDesc=$Piece($Get(^TTAB("BUG",Code)),"\",1)
	 	Quit:(Alias'="")&(BugsDesc'[Alias) $$$OK
	 	Set BugsActive=$Piece($Get(^TTAB("BUG",Code)),"\",11)
	 	Quit:(IsActive'="")&(IsActive'=BugsActive) $$$OK
	 	Set Data=$ListBuild(Code,BugsDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}Else{
	 	Set BugsCode=""
	 	For {
		 	Set BugsCode=$o(^TTAB("BUG",BugsCode))
		 	Quit:BugsCode=""
		 	Set BugsDesc=$Piece($Get(^TTAB("BUG",BugsCode)),"\",1)
		 	Continue:((Alias'="")&((BugsDesc'[Alias)&(BugsCode'[Alias)))
		 	Set BugsActive=$Piece($Get(^TTAB("BUG",BugsCode)),"\",11)
		 	Continue:(IsActive'="")&(IsActive'=BugsActive)
		 	Continue:(BugsCode="")!(BugsDesc="")
		 	Set Data=$ListBuild(BugsCode,BugsDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		}
	}
	
	Quit $$$OK
}

ClassMethod QryBugsDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBugsDicExecute ]
{
	
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryBugsDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBugsDicExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-05-24
/// Description:  查询病原体对照信息
/// Table：       DHCMed.INF.InfPathogenMaping
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfPathogenMapingSrv","QueryAllInfPathInfo","","")
Query QueryAllInfPathInfo(Alias As %String, IsActive As %String) As %Query(ROWSPEC = "rowid:%String,BugsCode:%String,BugsDesc:%String,PatID:%String,PatDesc:%String:标准病原体描述,Active:%String")
{
}

ClassMethod QueryAllInfPathInfoExecute(ByRef qHandle As %Binary, Alias As %String, IsActive As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s BugsCode=""
	s IsActive=$Select(IsActive["Y":"Y",IsActive["N":"N",1:"")

	f  s BugsCode=$o(^TTAB("BUG",BugsCode)) q:BugsCode=""  d
    .s BugsDesc=$Piece($Get(^TTAB("BUG",BugsCode)),"\",1)
    .q:((Alias'="")&((BugsDesc'[Alias)&(BugsCode'[Alias)))
    .s BugsActive=$Piece($Get(^TTAB("BUG",BugsCode)),"\",11)
    .q:(IsActive'="")&(IsActive'=BugsActive)
    .q:(BugsCode="")!(BugsDesc="")
    .s InfPathMapID=$o(^DHCMed.INF.InfPathogenMapingI("Code"," "_BugsCode,""))
    .i InfPathMapID'="" d
    ..s obj=##class(DHCMed.INF.InfPathogenMaping).%OpenId(InfPathMapID)
    ..s $li(data,1)=InfPathMapID
    ..s $li(data,2)=BugsCode		//BugsCode	辅助检查病原体Code
    ..s $li(data,3)=BugsDesc		//obj.Description	辅助检查病原体Description
    ..s $li(data,4)=obj.PatID
    ..s $li(data,5)=""
    ..s PatObj=##class(DHCMed.INF.InfPathogenDic).GetObjById(obj.PatID)
    ..s:$IsObject(PatObj) $li(data,5)=PatObj.Description	// 标准病原体描述
    ..s $li(data,6)=$s(obj.Active=1:"Y",obj.Active=0:"N",1:"N")
    .e  d
    ..s $li(data,1)=""
    ..s $li(data,2)=BugsCode
    ..s $li(data,3)=BugsDesc
    ..s $li(data,4)=""
    ..s $li(data,5)=""
    ..s $li(data,6)="Y"
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryAllInfPathInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllInfPathInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllInfPathInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllInfPathInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-05-24
/// Description:  查询标准病原体信息
/// Table：       DHCMed.INF.InfPathogenDic
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfPathogenMapingSrv","QueryInfPatDicInfo")
Query QueryInfPatDicInfo() As %Query(ROWSPEC = "rowid:%String,PatDicDesc:%String")
{
}

ClassMethod QueryInfPatDicInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.INF.InfPathogenDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InfPathogenDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Code_"-"_obj.Description
	.q:obj.Active'=1
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryInfPatDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInfPatDicInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryInfPatDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInfPatDicInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 描述：		 把表细菌CT_Bugs 中的数据插入到 表 DHCMed.INF.InfPathogenDic中
/// 调用方法：	 w ##Class(DHCMed.INFService.InfPathogenMapingSrv).InsertLabPatToDic()
ClassMethod InsertLabPatToDic() As %String
{
	k ^DHCMed.INF.InfPathogenDicD		//清除表中数据
	k ^DHCMed.INF.InfPathogenDicI
	s BugsCode=""
	
	f  s BugsCode=$o(^TTAB("BUG",BugsCode)) q:BugsCode=""  d
    .s BugsDesc=$Piece($Get(^TTAB("BUG",BugsCode)),"\",1)
    .s BugsActive=$Piece($Get(^TTAB("BUG",BugsCode)),"\",11)
    .q:BugsActive'="Y"
	.d ##class(DHCMed.INF.InfPathogenDic).Update("^"_BugsCode_"^"_BugsDesc_"^"_"1"_"^","^")
	
	q $$$OK
}

/// 描述：		 自动匹配检验中的病原体和DHCMed.INF.InfPathogenDic中的病原体
/// 调用方法：	 w ##Class(DHCMed.INFService.InfPathogenMapingSrv).AutoMapLabPatToDic()
ClassMethod AutoMapLabPatToDic() As %String
{
	k ^DHCMed.INF.InfPathogenMapingD
	k ^DHCMed.INF.InfPathogenMapingI
	
	s BugsCode=""
	
	f  s BugsCode=$o(^TTAB("BUG",BugsCode)) q:BugsCode=""  d
    .s BugsDesc=$Piece($Get(^TTAB("BUG",BugsCode)),"\",1)
    .s BugsActive=$Piece($Get(^TTAB("BUG",BugsCode)),"\",11)
    .q:BugsActive'="Y"
	.q:'$d(^DHCMed.INF.InfPathogenDicI("Code"," "_BugsCode))
	.s DicID=$o(^DHCMed.INF.InfPathogenDicI("Code"," "_BugsCode,""))
	.q:DicID=""
	.d ##Class(DHCMed.INF.InfPathogenMaping).Update("^"_BugsCode_"^"_BugsDesc_"^"_DicID_"^"_1_"^^^^","^")
	
	q $$$OK
}

}
