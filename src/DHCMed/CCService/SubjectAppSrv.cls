/// 名称: DHCMed.CCService.SubjectAppSrv
/// 描述: DHCMed.CC.SubjectApp 监控主题应用常用方法
/// 编写者：liuyh
/// 编写日期: 2010-05-12
Class DHCMed.CCService.SubjectAppSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-05-12
/// Description:  通过监控项目代码、子分类查询监控项目信息
/// Table：       DHCMed.CC.SubjectApp、DHCMed.CC.SubjectAppCols
/// Input：       SADr : 指向监控主题应用表(DHCMed.CC.SubjectApp)
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","QuerySubjectAppCols","1")
Query QuerySubjectAppCols(SADr As %String) As %Query(ROWSPEC = "SACParref:%String,SADesc:%String,SACName:%String,SACDesc:%String,SACIsHide:%String,SACWidth:%String,SACIsSort:%String,SACIndex:%String")
{
}

ClassMethod QuerySubjectAppColsExecute(ByRef qHandle As %Binary, SADr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s colStr="",num=0,SACName="",SACChildSub=""

	s objSA=##class(DHCMed.CC.SubjectApp).%OpenId(SADr)
	q:'$IsObject(objSA) $$$OK
	q:+objSA.SAShowDr=0 $$$OK
	
	s objSD=##class(DHCMed.CC.ShowDic).%OpenId(+objSA.SAShowDr)
	q:'$IsObject(objSD) $$$OK
	q:objSD.SDQueryName="" $$$OK
	
	s ret=..GetROWSPECInfo($p(objSD.SDQueryName,":",1),$p(objSD.SDQueryName,":",2))
	q:ret="" $$$OK
 	s num=$l(ret,",")
 	f i=1:1:num  d
 	.s SACName=$p($p(ret,",",i),":",1)
 	.q:SACName=""
 	.s SACChildSub=$o(^DHCMed.CC.SubjectAppD(SADr,"ChildAppCols",""))
 	.i SACChildSub=""  d    // 如果该主题应用对应的列表属性为空
 	..s $li(data,1)=SADr_"||"
 	..s $li(data,2)=objSA.SADesc
 	..s $li(data,3)=SACName
 	..s $li(data,4)=$p($p(ret,",",i),":",3)
 	..s $li(data,5)="Y"
 	..s $li(data,6)=80
 	..s $li(data,7)="N"
 	..s $li(data,8)=$s(i<10:0_i,1:i)
 	.e  d 			//从DHCMed.CC.SubjectAppCols表中查询保存数据
 	..s $li(data,1)=SADr_"||"		//初始化数据
 	..s $li(data,2)=objSA.SADesc
 	..s $li(data,3)=SACName
 	..s $li(data,4)=$p($p(ret,",",i),":",3)
 	..s $li(data,5)="Y"
 	..s $li(data,6)=80
 	..s $li(data,7)="N"
 	..s $li(data,8)=$s(i<10:0_i,1:i)
 	..s SubID=0
 	..f  s SubID=$o(^DHCMed.CC.SubjectAppD(SADr,"ChildAppCols",SubID)) q:SubID=""  d
 	...s SACStr=##class(DHCMed.CC.SubjectAppCols).GetStringById(SADr_"||"_SubID,"")
 	...q:SACStr=""			// 如果ROWSPEC名称和数据库中名称相同，则取数据库中信息
 	...i $p(SACStr,"^",2)=SACName d
 	....s $li(data,1)=SADr_"||"_SubID
 	....s $li(data,4)=$p(SACStr,"^",3)
 	....s $li(data,5)=$s($p(SACStr,"^",4)=1:"Y",1:"N")
 	....s $li(data,6)=$p(SACStr,"^",5)
 	....s $li(data,7)=$s($p(SACStr,"^",6)=0:"N",1:"Y")
 	....s $li(data,8)=$p(SACStr,"^",7)
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QuerySubjectAppColsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubjectAppColsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubjectAppColsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubjectAppColsExecute ]
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
/// CreatDate：   2010-05-12
/// Description:  根据类名和Query名称查询ROWSPEC内容
/// Table：       
/// Input：       ClassName : 类名 QueryName : Query名称           
/// Return：      错误："" 正确：ROWSPEC内容
/// w ##class(DHCMed.CCService.SubjectAppSrv).GetROWSPECInfo("DHCMed.CCService.ContentDicSrv","QueryItemDicInfo")
ClassMethod GetROWSPECInfo(ClassName As %String, QueryName As %String) As %String
{
	n (ClassName,QueryName)
	s ret=""
	q:ClassName="" ret
	q:QueryName="" ret
	
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
	set count = cdef.Queries.Count() 
 	For i = 1:1:count {
	 	 if (cdef.Queries.GetAt(i).Name=QueryName)
	 	 {
		 	s ret=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
		 }
 	 }
 	 q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-05-13
/// Description:  查询监控主题字典信息
/// Table：       DHCMed.CC.SubjectDic
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","QuerySubjectDicInfo")
Query QuerySubjectDicInfo() As %Query(ROWSPEC = "rowid:%String,SDDesc:%String")
{
}

ClassMethod QuerySubjectDicInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	f  s rowid=$o(^DHCMed.CC.SubjectDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.SubjectDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.SDDesc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod QuerySubjectDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubjectDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubjectDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubjectDicInfoExecute ]
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
/// CreatDate：   2010-05-13
/// Description:  查询监控主题展现字典信息
/// Table：       DHCMed.CC.ShowDic
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","QueryShowDicInfo")
Query QueryShowDicInfo() As %Query(ROWSPEC = "rowid:%String,SDDesc:%String")
{
}

ClassMethod QueryShowDicInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	f  s rowid=$o(^DHCMed.CC.ShowDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ShowDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.SDDesc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod QueryShowDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryShowDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryShowDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryShowDicInfoExecute ]
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
/// CreatDate：   2010-05-14
/// Description:  根据监控主题Rowid查询监控主题信息
/// Table：       DHCMed.CC.SubjectApp
/// Input：       SARowid : 监控主题Rowid
/// Return：      错误：""
/// w ##class(DHCMed.CCService.SubjectAppSrv).GetSubAppInfoByID(1)
ClassMethod GetSubAppInfoByID(SARowid As %String) As %String
{
	n (SARowid)
	s ret=""
	q:SARowid="" ret
	
	s obj=##class(DHCMed.CC.SubjectApp).GetObjById(SARowid)
	q:'$IsObject(obj) ret
	
	s ret=SARowid
	s ret=ret_"^"_obj.SACode
	s ret=ret_"^"_obj.SADesc
	s ret=ret_"^"_obj.SASubjectDr
	s SDObj=##class(DHCMed.CC.SubjectDic).GetObjById(obj.SASubjectDr)
	s:$IsObject(SDObj) ret=ret_$c(1)_SDObj.SDDesc
	s ret=ret_"^"_obj.SAShowScore
	s ret=ret_"^"_obj.SAShowDr
	s SDicObj=##class(DHCMed.CC.ShowDic).GetObjById(obj.SAShowDr)
	s:$IsObject(SDicObj) ret=ret_$c(1)_SDicObj.SDDesc
	s ret=ret_"^"_obj.SAResume
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-05-14
/// Description:  查询所有监控主题应用信息
/// Table：       DHCMed.CC.SubjectApp
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","QuerySubAppInfo")
Query QuerySubAppInfo() As %Query(ROWSPEC = "ID:%Integer,SACode:%String,SADesc:%String,SASubjectDr:%String,SAShowScore:%String,SAShowDr:%String,SAResume:%String,SASubjectDrDesc:%String:监控主题,SAShowDrDesc:%String:展现模式")
{
}

ClassMethod QuerySubAppInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=0
	
	f  s rowid=$o(^DHCMed.CC.SubjectAppD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.SubjectApp).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.SACode
	.s $li(data,3)=obj.SADesc
	.s $li(data,4)=obj.SASubjectDr
	.s $li(data,5)=obj.SAShowScore
	.s $li(data,6)=obj.SAShowDr
	.s $li(data,7)=obj.SAResume
	.s SDObj=##class(DHCMed.CC.SubjectDic).GetObjById(obj.SASubjectDr)
	.s:$IsObject(SDObj) $li(data,8)=SDObj.SDDesc
	.s:'$IsObject(SDObj) $li(data,8)=""
	.s SDicObj=##class(DHCMed.CC.ShowDic).GetObjById(obj.SAShowDr)
	.s:$IsObject(SDicObj) $li(data,9)=SDicObj.SDDesc
	.s:'$IsObject(SDicObj) $li(data,9)=SDicObj.SDDesc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod QuerySubAppInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubAppInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubAppInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubAppInfoExecute ]
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
/// CreatDate：   2010-05-14
/// Description:  往监控主题应用列表中插入数据
/// Table：       DHCMed.CC.SubjectAppCols
/// Input：       Str : 监控主题应用列表信息
/// Return：      
/// w ##class(DHCMed.CCService.SubjectAppSrv).InsertDataToSubAppCols("4||^rowid^ID^0^50^1^1")
ClassMethod InsertDataToSubAppCols(Str As %String) As %String
{
	n (Str)
	s ret="",tmp=0,rowid=0
	q:Str="" ret
	s SARowid=+$p(Str,"||",1)
	q:SARowid=0 ret
	
	set $ZT="Error"
	TStart
	k ^DHCMed.CC.SubjectAppD(SARowid,"ChildAppCols")
	k ^DHCMed.CC.SubjectAppColsI("IndexSort",SARowid)
	
	;if tmp<0 TRollback
	
	s len=$l(Str,$c(1))
	f i=1:1:len q:tmp<0  d
	.s rowStr=$p(Str,$c(1),i)
	.s $p(rowStr,"^",1)=SARowid_"||"	// 删除历史数据，保存新数据
	.s tmp=##class(DHCMed.CC.SubjectAppCols).Update(rowStr)
	
	if tmp<0 TRollback		// 出现插入失败后全部rollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// Creator：     liuyh
/// CreatDate：   2010-05-17
/// Description:  查询所有监控主题应用监控项目信息
/// Table：       DHCMed.CC.SubjectAppSub,DHCMed.CC.SubjectApp
/// Input：       SADr : 监控主题应用Rowid
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","QuerySubAppSubInfo","1")
Query QuerySubAppSubInfo(SADr As %String) As %Query(ROWSPEC = "SASRowid:%String,SASItemDr:%String,SASItemDrDesc:%String,SASItemType:%String,SASItemTypeDesc:%String,SASItemScore:%String,SASLocDr:%String,SASLocDrDesc:%String,SASGroupDr:%String,SASGroupDrDesc:%String,SASResume:%String")
{
}

ClassMethod QuerySubAppSubInfoExecute(ByRef qHandle As %Binary, SADr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:SADr="" $$$OK
	s SubID="",DicObj=""
	
	f  s SubID=$o(^DHCMed.CC.SubjectAppD(SADr,"ChildAppSub",SubID)) q:SubID=""  d
	.s obj=##class(DHCMed.CC.SubjectAppSub).%OpenId(SADr_"||"_SubID)
	.q:'$IsObject(obj)
	.s $li(data,1)=SADr_"||"_SubID
	.s $li(data,2)=obj.SASItemDr		// 监控项目表ID
	.s SItemObj=##class(DHCMed.CC.ItemDic).GetObjById(obj.SASItemDr)
	.s $li(data,3)=""
	.s:$IsObject(SItemObj) $li(data,3)=SItemObj.IDDesc	// 监控项目描述
	.s $li(data,4)=obj.SASItemType		// 项目类型
	.s $li(data,5)=""	// 项目类型描述
	.s:+obj.SASItemType>0 DicObj=##class(DHCMed.SS.Dictionary).GetObjById(obj.SASItemType)
	.s:$IsObject(DicObj) $li(data,5)=DicObj.Description
	.s $li(data,6)=obj.SASItemScore		// 分数
	.s $li(data,7)=obj.SASLocDr			// 科室ID
	.s $li(data,8)=""
	.s:+obj.SASLocDr>0 $li(data,8)=$p(^CTLOC(obj.SASLocDr),"^",1)		// 科室描述
	.s $li(data,9)=obj.SASGroupDr		// 部门ID
	.s $li(data,10)=""
	.s:+obj.SASGroupDr>0 $li(data,10)=$p(^SSU("SSGRP",obj.SASGroupDr),"^",1)	// 部门描述
	.s $li(data,11)=obj.SASResume		// 备注
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QuerySubAppSubInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubAppSubInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubAppSubInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubAppSubInfoExecute ]
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
/// CreatDate：   2010-05-17
/// Description:  查询所有监控项目信息
/// Table：       DHCMed.CC.ItemDic
/// Input：       IDDesc : 监控主题描述
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","FindItemDicInfo","外")
Query FindItemDicInfo(IDDesc As %String) As %Query(ROWSPEC = "rowid:%String,IDDesc:%String")
{
}

ClassMethod FindItemDicInfoExecute(ByRef qHandle As %Binary, IDDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	f  s rowid=$o(^DHCMed.CC.ItemDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ItemDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.IDDesc
	.q:((IDDesc'="")&(obj.IDDesc'[IDDesc))
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod FindItemDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindItemDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemDicInfoExecute ]
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
/// CreatDate：   2010-05-17
/// Description:  通过类型查询字典表ID
/// Table：       DHCMed.SS.Dictionary
/// Input：       DicType : 类型
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","QueryDicInfoFromType","SASITEMTYPE")
Query QueryDicInfoFromType(DicType As %String) As %Query(ROWSPEC = "rowid:%String,DicDesc:%String,DicCode:%String")
{
}

ClassMethod QueryDicInfoFromTypeExecute(ByRef qHandle As %Binary, DicType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:DicType="" $$$OK
	s rowid=""
	
	f  s rowid=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_DicType,rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.SS.Dictionary).%OpenId(rowid)
	.q:obj.Active'=1
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Description
	.s $li(data,3)=obj.Code
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryDicInfoFromTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicInfoFromTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDicInfoFromTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicInfoFromTypeExecute ]
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
/// CreatDate：   2010-05-17
/// Description:  通过科室描述查询科室信息
/// Table：       Ct_loc
/// Input：       CtDesc : 描述
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","FindCtlocInfoFromDesc","")
Query FindCtlocInfoFromDesc(CtDesc As %String) As %Query(ROWSPEC = "rowid:%String,CtDesc:%String")
{
}

ClassMethod FindCtlocInfoFromDescExecute(ByRef qHandle As %Binary, CtDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	s CtDesc=$ZCVT(CtDesc,"U")
	
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s $li(data,1)=rowid
	.s cDesc=$p(^CTLOC(rowid),"^",2)
	.q:((CtDesc'="")&(cDesc'[CtDesc))
	.s $li(data,2)=$p(^CTLOC(rowid),"^",1)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1

	q $$$OK
}

ClassMethod FindCtlocInfoFromDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCtlocInfoFromDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindCtlocInfoFromDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCtlocInfoFromDescExecute ]
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
/// CreatDate：   2010-05-17
/// Description:  通过安全组描述查询安全组信息
/// Table：       SS_Group
/// Input：       SSGDesc : 描述
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectAppSrv","FindSSGroupInfoFromDesc","")
Query FindSSGroupInfoFromDesc(SSGDesc As %String) As %Query(ROWSPEC = "rowid:%String,SSGDesc:%String")
{
}

ClassMethod FindSSGroupInfoFromDescExecute(ByRef qHandle As %Binary, SSGDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	f  s rowid=$o(^SSU("SSGRP",rowid)) q:rowid=""  d
	.s $li(data,1)=rowid
	.s sDesc=$p(^SSU("SSGRP",rowid),"^",1)
	.q:((SSGDesc'="")&(sDesc'[SSGDesc))
	.s $li(data,2)=sDesc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1

	q $$$OK
}

ClassMethod FindSSGroupInfoFromDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSSGroupInfoFromDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindSSGroupInfoFromDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSSGroupInfoFromDescExecute ]
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

}
