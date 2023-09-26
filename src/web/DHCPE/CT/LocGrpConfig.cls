/// 名称: 科室分组配置
/// 编写者：xy
/// 编写日期: 2021-08-02
Class web.DHCPE.CT.LocGrpConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     xy 
/// CreatDate：   20210802
/// Description:  插入科室分组配置表
/// Table：       科室分组配置表 User.DHCPELocGrpConfig  
/// Input:        LocID 科室ID, LocGrpID 默认科室ID,LocDesc2 科室别名, Active 是否激活, UserID 操作人ID
/// Return：
/// Debug:  w ##class(web.DHCPE.CT.LocGrpConfig).InsertLocGrp("152","152","Y","1")
ClassMethod InsertLocGrp(LocID As %String, LocGrpID As %String, LocDesc2 As %String, Active As %String, UserID As %String)
{
	n (LocID,LocGrpID,LocDesc2,Active,UserID)
	s ^tempdhcpe("InsertLocGrp")=$lb(LocID,LocGrpID,LocDesc2,Active,UserID)
	s result=1
	s Date=+$h
	s Time=$p($h,",",2)
	
	if (LocID="") 
    {
     	s result="-1^科室不能为空"
    }
    elseif(LocGrpID="") 
    {
    	s result="-1^默认科室不能为空"
    }
    
    s obj=##class(User.DHCPELocGrpConfig).%New()
    s obj.LGLocDR=LocID
    s obj.LGLocGrpDR=LocGrpID
    s obj.LGLocDesc2=LocDesc2
    s obj.LGActive=Active
    S obj.LGUpdateDate=Date
    S obj.LGUpdateTime=Time
    S obj.LGUpdateUserDR=UserID
    Ts
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc) 
    {   
    	Tc
    	s id=obj.%Id()
    	s result=id_"^添加成功"
    }
    else
    {
     	Trollback
     	s result="-1^添加失败"
    }
    q result
}

/// Creator：    xy 
/// CreatDate：  20210802
/// Description: 更新科室分组配置表
/// Table：      科室分组配置表 User.DHCPELocGrpConfig 
/// Input:       LGCRowid 数据ID, LocID 科室ID, LocGrpID 默认科室ID, LocDesc2 科室别名, Active 是否激活, UserID 操作人ID
/// Return：
/// Debug: w ##class(web.DHCPE.CT.LocGrpConfig).UpdateLocGrp()
ClassMethod UpdateLocGrp(LGCRowid As %String, LocID As %String, LocGrpID As %String, LocDesc2 As %String, Active As %String, UserID As %String)
{
	n (LGCRowid,LocID,LocGrpID,LocDesc2,Active,UserID)
	s Date=+$h
	s Time=$p($h,",",2)    
    s obj=##class(User.DHCPELocGrpConfig).%OpenId(LGCRowid)
    s obj.LGLocDR=LocID
    s obj.LGLocGrpDR=LocGrpID
    s obj.LGLocDesc2=LocDesc2
    s obj.LGActive=Active
    S obj.LGUpdateDate=Date
    S obj.LGUpdateTime=Time
    S obj.LGUpdateUserDR=UserID
    s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id_"^修改成功"
	}
}

/// Creator：    xy 
/// CreatDate：  20210802
/// Description: 查询科室分组配置
/// Table：      科室分组配置表 User.DHCPELocGrpConfig 
/// Input:       LocID(科室ID),LocGrpID(科室组ID),HospID(医院ID),ActiveFlag(激活)
/// Return：
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.LocGrpConfig","SearchLocGrp")
Query SearchLocGrp(LocID As %String = "", LocGrpID As %String = "", HospID As %String = "", ActiveFlag As %String = "") As %Query(ROWSPEC = "TLGCRowid:%String,TLocRowid:%String,TLocDesc:%String,TLocDesc2:%String,TLocCode:%String,TLocGrpRowid:%String,TLocGrpDesc:%String,THopDesc:%String,TActive:%String,TUpdateDate:%String,TUpdateTime:%String,TUserName:%String")
{
}

ClassMethod SearchLocGrpExecute(ByRef qHandle As %Binary, LocID As %String = "", LocGrpID As %String = "", HospID As %String = "", ActiveFlag As %String = "") As %Status
{
	s ^tempdhcpe("SearchLocGrp")=$lb(LocID,LocGrpID,HospID,ActiveFlag)
	Set repid=$I(^CacheTemp)
 	i $g(ind)="" s ind=1 
 	
 	if (LocID'=""){
 		s ID=""
 		f  s ID=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_LocID,ID))  q:ID=""  d
 		.d GetLocGrpList
 	}else{	
 		s ID=""
 		f  s ID=$O(^CF.PE.LocGrpConfigD(ID)) q:ID=""  d
 		.d GetLocGrpList
 	}
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetLocGrpList	
 	s LocDR=$lg($g(^CF.PE.LocGrpConfigD(ID)),2)
 	s LocDesc="",LocCode="",HopDesc="",LocDesc2=""
 	i LocDR'="" d
 	.s LocDesc=$p($g(^CTLOC(LocDR)),"^",2)
 	.s LocCode=$p($g(^CTLOC(LocDR)),"^",1)
 	.s HospDR=$p($g(^CTLOC(LocDR)),"^",22)
 	.i HospDR'="" s HopDesc=$P($g(^CT("HOSP",HospDR)),"^",2)
 	q:(HospID'="")&&(HospDR'=HospID)
	s LocGrpDR=$lg($g(^CF.PE.LocGrpConfigD(ID)),3)
	q:(LocGrpID'="")&&(LocGrpDR'=LocGrpID)
	s LocGrpDesc=""
	i LocGrpDR'=""  s LocGrpDesc=$p($g(^CTLOC(LocGrpDR)),"^",2)
	s Active=$lg($g(^CF.PE.LocGrpConfigD(ID)),5)
	q:(ActiveFlag'="")&&(Active'=ActiveFlag)
	s LocDesc2=$lg($g(^CF.PE.LocGrpConfigD(ID)),4)
	s UpdateDate=$lg($g(^CF.PE.LocGrpConfigD(ID)),6)
	i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	s UpdateTime=$lg($g(^CF.PE.LocGrpConfigD(ID)),7)
	i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
	s UserDR=$lg($g(^CF.PE.LocGrpConfigD(ID)),8)
	s UserName=""
	i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	d FindBuild 
 	q
	
FindBuild  
	set Data=$lb(ID,LocDR,LocDesc,LocDesc2,LocCode,LocGrpDR,LocGrpDesc,HopDesc,Active,UpdateDate,UpdateTime,UserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchLocGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchLocGrpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod SearchLocGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchLocGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator： xy 
/// CreatDate： 20210923
/// Description: 根据科室ID获取科室描述
/// Input: LocID 科室ID
/// Debug: w ##class(web.DHCPE.CT.LocGrpConfig).GetLocDescByID()
ClassMethod GetLocDescByID(LocID)
{
 q:LocID="" ""
 q $p($g(^CTLOC(LocID)),"^",2)
}

/// Creator：    zhufei 
/// CreatDate：  20211209
/// Description: 根据科室ID获取科室组默认科室
/// Input:       LocID 科室ID
/// Debug: w ##class(web.DHCPE.CT.LocGrpConfig).GetLGLocIDByLoc(152)
ClassMethod GetLGLocIDByLoc(aLocID As %String) As %String
{
	New (aLocID)
	Quit:aLocID="" ""
	Set ID=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_aLocID,0))
	Quit:ID="" ""
 	Quit $lg($g(^CF.PE.LocGrpConfigD(ID)),3)
}

/// Creator：    zhufei 
/// CreatDate：  20211210
/// Description: 根据科室ID获取对应科室组下科室列表
/// Input:       LocID 科室ID
/// Debug: w ##class(web.DHCPE.CT.LocGrpConfig).GetLGLocListByLoc(152)
ClassMethod GetLGLocListByLoc(aLocID As %String) As %String
{
	New (aLocID)
	Quit:aLocID="" ""
	
	Set LGLocID=..GetLGLocIDByLoc(aLocID)
	Quit:LGLocID="" ""
	
	Set LGLocList=""
	Set xLGCID=0
	For {
		Set xLGCID=$o(^CF.PE.LocGrpConfigD(xLGCID))
		Quit:xLGCID=""
		Continue:$lg($g(^CF.PE.LocGrpConfigD(xLGCID)),3)'=LGLocID
		Set LocID=$lg($g(^CF.PE.LocGrpConfigD(xLGCID)),2)
		Continue:LocID=""
		Set LGLocList=LGLocList_$lb(LocID)
	}
	Quit LGLocList
}

}
