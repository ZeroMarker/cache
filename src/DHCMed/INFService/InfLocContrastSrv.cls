/// 名称: DHCMed.INFService.InfLocContrastSrv
/// 描述: DHCMed.INF.InfLocContrast 科室对照常用方法
/// 编写者：liuyh
/// 编写日期: 2010-05-20
Class DHCMed.INFService.InfLocContrastSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-05-20
/// Description:  通过编码、描述查询部门信息
/// Table：       DHCMed.INF.InfLocDic
/// Input：       LocCode : 部门代码	LocDesc : 部门描述
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfLocContrastSrv","QueryLocDicInfo","","")
Query QueryLocDicInfo(LocCode As %String, LocDesc As %String) As %Query(ROWSPEC = "rowid:%String,Code:%String,Description:%String,Active:%String,ResumeText:%String,ActiveDesc:%String ")
{
}

ClassMethod QueryLocDicInfoExecute(ByRef qHandle As %Binary, LocCode As %String, LocDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.INF.InfLocDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InfLocDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Code
	.q:((LocCode'="")&(obj.Code'[LocCode))
	.s $li(data,3)=obj.Description
	.q:((LocDesc'="")&(obj.Description'[LocDesc))
	.s $li(data,4)=obj.Active
	.s $li(data,5)=obj.ResumeText
	.s $li(data,6)="是"
	.s:obj.Active=0 $li(data,6)="否"
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryLocDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryLocDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocDicInfoExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-20
/// Description:  查询科室对照信息
/// Table：       DHCMed.INF.InfLocContrast
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfLocContrastSrv","QueryAllInfLocConInfo")
Query QueryAllInfLocConInfo() As %Query(ROWSPEC = "LocID:%String,TrakLocID:%String,TrakLocDesc:%String,InflocDR:%String,Description:%String,Active:%String,DateFrom:%String,DateTo:%String,ResumeText:%String")
{
}

ClassMethod QueryAllInfLocConInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s TrakLocID=""

	f  s TrakLocID=$o(^CTLOC(TrakLocID)) q:TrakLocID=""  d
    .q:$p($g(^CTLOC(TrakLocID)),"^",13)'="E"
    .s TrakLocDesc=$p($g(^CTLOC(TrakLocID)),"^",1)
    .s LocID=0
	.s LocID=$o(^DHCMed.INF.InfLocContrastI("CtlocDR",TrakLocID,""))
	.i +LocID>0 d
	..s obj=##class(DHCMed.INF.InfLocContrast).%OpenId(LocID)
	..s $li(data,1)=LocID	// 对照表rowid
	..s $li(data,2)=TrakLocID	// Trak科室rowid
	..s $li(data,3)=TrakLocDesc   // Trak科室描述
	..s $li(data,4)=obj.InflocDR	//标准科室表rowid
	..s $li(data,5)=""
	..s objLoc=##class(DHCMed.INF.InfLocDic).GetObjById(obj.InflocDR)
	..s:$IsObject(objLoc) $li(data,5)=objLoc.Code_"-"_objLoc.Description	// 标准科室描述
	..s $li(data,6)="Y"
	..s:obj.Active=0 $li(data,6)="N"	// 对照科室是否有效
	..s $li(data,7)=""		// 开始日期
	..s:obj.DateFrom>0 $li(data,7)=$zd(obj.DateFrom,3)
	..s $li(data,8)=""			// 结束日期
	..s:obj.DateTo>0 $li(data,8)=$zd(obj.DateTo,3)
	..s $li(data,9)=obj.ResumeText		// 备注
	..do obj.%Close()
	.e  d
	..s $li(data,1)=""
	..s $li(data,2)=TrakLocID
	..s $li(data,3)=TrakLocDesc 
	..s $li(data,4)=""
	..s $li(data,5)=""
	..s $li(data,6)="Y"
	..s $li(data,7)=$zd($h,3)
	..s $li(data,8)=$zd($h,3)
	..s $li(data,9)=""
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryAllInfLocConInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllInfLocConInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAllInfLocConInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllInfLocConInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod admdeplookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admdeplookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admdeplookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s desc=$ZCVT($g(desc),"U")
	s rowid=0
	f  s rowid=$o(^DHCMed.INF.InfLocDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InfLocDic).%OpenId(rowid)
	.q:obj.Active=0
	.//q:((desc'="")&(obj.Code'[desc))
    .s Desc=obj.Code_"-"_obj.Description
    .d OutputRow
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admdeplookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admdeplookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// Creator：    刘学峰
/// CreatDate：  2008-11-03
/// Description：查询科室Query
/// Table：      
/// Input：  	 desc：科室描述  
/// Output：     dep,depid,ContactName
/// w ##Class(%ResultSet).RunQuery("DHCMed.INFService.InfLocContrastSrv","admdeplookup","")
Query admdeplookup(desc As %String) As %Query(ROWSPEC = "depid:%String,dep:%String")
{
}

/// Creator：     liuyh
/// CreatDate：   2010-05-21
/// Description:  往科室对照表中插入数据
/// Table：       DHCMed.INF.InfLocContrast
/// Input：       Str : 科室对照列表信息 $c(2) : 分割行 $c(1) ：分割数据项
/// Return：      
/// w ##class(DHCMed.INFService.InfLocContrastSrv).InsertDataToInfLocCon("")
ClassMethod InsertDataToInfLocCon(Str) As %String
{
	n (Str)
	s ret="",tmp=0,rowid=0
	q:Str="" ret

	set $ZT="Error"
	TStart
	k ^DHCMed.INF.InfLocContrastD
	k ^DHCMed.INF.InfLocContrastI
	s len=$l(Str,$c(2))
	f i=1:1:len q:tmp<0  d
	.s rowStr=$p(Str,$c(2),i)
	.s tmp=##class(DHCMed.INF.InfLocContrast).Update(rowStr,$c(1))
	
	if tmp<0 TRollback		// 出现插入失败后全部rollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

}
