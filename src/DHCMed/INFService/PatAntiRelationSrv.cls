/// 名称: DHCMed.INFService.PatAntiRelationSrv
/// 描述: 维护病原体和抗生素之间关系的常用操作
/// 编写者：liuyh
/// 编写日期: 2010-05-26
Class DHCMed.INFService.PatAntiRelationSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-05-24
/// Description:  查询项目对应的病原体
/// Table：       DHCMed.SS.Dictionary、DHCMed.INF.InfPathogenDic
/// Input：       DicID : 类型对应的字典表rowid
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.PatAntiRelationSrv","QuertPatAntiRelation","1")
Query QuertPatAntiRelation(DicID As %String) As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QuertPatAntiRelationExecute(ByRef qHandle As %Binary, DicID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	s DicID=+DicID
	q:DicID<1 $$$OK
	k ^CacheTemp("PatList",DicID)
	
	f  s rowid=$o(^DHCMed.INF.InfPathogenDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InfPathogenDic).%OpenId(rowid)
	.s Resume=obj.ResumeText
	.q:Resume=""
	.s len=$l(Resume,"/")
	.f i=1:1:len d
	..i $p(Resume,"/",i)=DicID d
	...s $li(data,1)=rowid
	...s $li(data,2)=obj.Code
	...s $li(data,3)=obj.Description
	...s ^CacheTemp("PatList",DicID,rowid)=rowid
    ...s ^CacheTemp(repid,ind)=data
    ...s ind=ind+1
    ...do obj.%Close()
	q $$$OK
}

ClassMethod QuertPatAntiRelationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuertPatAntiRelationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuertPatAntiRelationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuertPatAntiRelationExecute ]
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
/// CreatDate：   2010-05-26
/// Description:  查询标准病原体信息
/// Table：       DHCMed.INF.InfPathogenDic
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.PatAntiRelationSrv","QueryInfPatDicInfo")
Query QueryInfPatDicInfo(DicID As %String, PatDesc As %String) As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String,checked:%String")
{
}

ClassMethod QueryInfPatDicInfoExecute(ByRef qHandle As %Binary, DicID As %String, PatDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	q:DicID="" $$$OK
	s PatDesc=$ZCVT(PatDesc,"U")
	f  s rowid=$o(^DHCMed.INF.InfPathogenDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InfPathogenDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Code
	.s $li(data,3)=obj.Description
	.s desc=$ZCVT(obj.Code,"U")_"-"_obj.Description
	.q:((PatDesc'="")&(desc'[PatDesc))
	.q:obj.Active'=1
	.s $li(data,4)=""
	.s ID=""
	.f  s ID=$o(^CacheTemp("PatList",DicID,ID)) q:ID=""  d
	..s:rowid=ID $li(data,4)="true"		// 选中已经添加的数据
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

/// Creator：     liuyh
/// CreatDate：   2010-05-24
/// Description:  查询项目对应的抗生素
/// Table：       DHCMed.SS.Dictionary、DHCMed.INF.InfAntiDic
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.PatAntiRelationSrv","QuertAntiRelation","1")
Query QuertAntiRelation(DicID As %String) As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QuertAntiRelationExecute(ByRef qHandle As %Binary, DicID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	s DicID=+DicID
	q:DicID<1 $$$OK
	k ^CacheTemp("AntiList",DicID)
	f  s rowid=$o(^DHCMed.INF.InfAntiDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InfAntiDic).%OpenId(rowid)
	.s Resume=obj.ResumeText
	.q:Resume=""
	.s len=$l(Resume,"/")
	.f i=1:1:len d
	..i $p(Resume,"/",i)=DicID d
	...s $li(data,1)=rowid
	...s $li(data,2)=obj.Code
	...s $li(data,3)=obj.Description
	...s ^CacheTemp("AntiList",DicID,rowid)=rowid
    ...s ^CacheTemp(repid,ind)=data
    ...s ind=ind+1
    ...do obj.%Close()
	q $$$OK
}

ClassMethod QuertAntiRelationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuertAntiRelationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuertAntiRelationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuertPatAntiRelationExecute ]
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
/// CreatDate：   2010-05-27
/// Description:  查询标准抗生素信息
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.PatAntiRelationSrv","QueryInfAntiDicInfo","","")
Query QueryInfAntiDicInfo(DicID As %String, AntiDesc As %String) As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String,checked:%String")
{
}

ClassMethod QueryInfAntiDicInfoExecute(ByRef qHandle As %Binary, DicID As %String, AntiDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	q:DicID="" $$$OK
	s AntiDesc=$ZCVT(AntiDesc,"U")
	f  s rowid=$o(^DHCMed.INF.InfAntiDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InfAntiDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Code
	.s $li(data,3)=obj.Description
	.s desc=$ZCVT(obj.Code,"U")_"-"_obj.Description
	.q:((AntiDesc'="")&(desc'[AntiDesc))
	.q:obj.Active'=1
	.s $li(data,4)=""
	.s ID=""
	.f  s ID=$o(^CacheTemp("AntiList",DicID,ID)) q:ID=""  d
	..s:rowid=ID $li(data,4)="true"		// 选中已经添加的数据
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryInfAntiDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInfAntiDicInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryInfAntiDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInfPatDicInfoExecute ]
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
/// CreatDate：   2010-05-27
/// Description:  往病原体字典中插入数据
/// Table：       DHCMed.INF.InfPathogenDic
/// Input：       str:项目ID 分割:$c(1)
/// Return		  
/// w ##class(DHCMed.INFService.PatAntiRelationSrv).UpdateDataToPatDic("1","1")
ClassMethod UpdateDataToPatDic(TypeID As %String, PatID As %String) As %String
{
	n (TypeID,PatID)
	s ret=1
	s TypeID=+TypeID
	s PatID=+PatID
	q:TypeID<1 ret
	q:PatID<1 ret

	s rowid=""
	s obj=##class(DHCMed.INF.InfPathogenDic).GetObjById(PatID)
	q:'$IsObject(obj) ret
	s desc=obj.ResumeText		// 格式：数字1/数字2/数字3
	s len=$l(desc,"/")
	s PositionID=0
	f i=1:1:len  q:PositionID'=0   d
	.s:$p(desc,"/",i)=TypeID PositionID=i
	i PositionID=0 d  // 不包含TypeID
	.i ((len=1)&(+desc=0)) d  // desc为空
	..s obj.ResumeText=TypeID
	.e  d  // 包含一个或多个ID
	..s obj.ResumeText=obj.ResumeText_"/"_TypeID
	e  d  // 包含TypeID
	.s ResText=""
	.f i=1:1:len d
	..q:i=PositionID	// 删除该数据
	..s:ResText'="" ResText=ResText_"/"_$p(desc,"/",i)
	..s:ResText="" ResText=$p(desc,"/",i)
	.s obj.ResumeText=ResText
	do obj.%Save()
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-05-27
/// Description:  往抗生素字典中插入数据
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       str:项目ID 分割:$c(1)
/// Return		  
/// w ##class(DHCMed.INFService.PatAntiRelationSrv).UpdateDataToAntiDic("1","1")
ClassMethod UpdateDataToAntiDic(TypeID As %String, AntiID As %String) As %String
{
	n (TypeID,AntiID)
	s ret=1
	s TypeID=+TypeID
	s AntiID=+AntiID
	q:TypeID<1 ret
	q:AntiID<1 ret

	s rowid=""
	s obj=##class(DHCMed.INF.InfAntiDic).GetObjById(AntiID)
	q:'$IsObject(obj) ret
	s desc=obj.ResumeText		// 格式：数字1/数字2/数字3
	s len=$l(desc,"/")
	s PositionID=0
	f i=1:1:len  q:PositionID'=0   d
	.s:$p(desc,"/",i)=TypeID PositionID=i
	i PositionID=0 d  // 不包含TypeID
	.i ((len=1)&(+desc=0)) d  // desc为空
	..s obj.ResumeText=TypeID
	.e  d  // 包含一个或多个ID
	..s obj.ResumeText=obj.ResumeText_"/"_TypeID
	e  d  // 包含TypeID
	.s ResText=""
	.f i=1:1:len d
	..q:i=PositionID	// 删除该数据
	..s:ResText'="" ResText=ResText_"/"_$p(desc,"/",i)
	..s:ResText="" ResText=$p(desc,"/",i)
	.s obj.ResumeText=ResText
	do obj.%Save()
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-05-27
/// Description:  通过抗生素ID查询对应的病原体信息
/// Table：       DHCMed.INF.InfAntiDic,DHCMed.INF.InfPathogenDic
/// Input：       PatID : 标准病原体表ID
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.PatAntiRelationSrv","QueryAntiForPathogen","1")
Query QueryAntiForPathogen(PatID As %String) As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QueryAntiForPathogenExecute(ByRef qHandle As %Binary, PatID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	s PatID=+PatID
	q:PatID="" $$$OK
	
	s objPat=##class(DHCMed.INF.InfPathogenDic).GetObjById(PatID)
	q:'$IsObject(objPat) $$$OK
	s ResText=objPat.ResumeText
	q:ResText="" $$$OK
	s len=$l(ResText,"/")
	
	f i=1:1:len d
	.s DicID=+$p(ResText,"/",i)
	.q:DicID<1
	.f  s rowid=$o(^DHCMed.INF.InfAntiDicD(rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.INF.InfAntiDic).%OpenId(rowid)
	..q:obj.Active'=1
	..s res=obj.ResumeText
	..q:res=""
	..s resLength=$l(res,"/")
	..f j=1:1:resLength d
	...q:+$p(res,"/",j)'=DicID
	...q:obj.Active'=1
	...s $li(data,1)=rowid
	...s $li(data,2)=obj.Code
	...s $li(data,3)=obj.Description
    ...s ^CacheTemp(repid,ind)=data
    ...s ind=ind+1
    ...do obj.%Close()
	q $$$OK
}

ClassMethod QueryAntiForPathogenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAntiForPathogenExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAntiForPathogenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAntiForPathogenExecute ]
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

/// w ##class(DHCMed.INFService.PatAntiRelationSrv).GetAntiByPathogenType(1)
ClassMethod GetAntiByPathogenType(PathID As %String = "") As %String
{
  n (PathID)
  s ret=""
  q:PathID="" ret
  s objClsPath=##class(DHCMed.INF.InfPathogenDic).GetObjById(PathID)
  q:'$IsObject(objClsPath) ret
  s Resume=objClsPath.ResumeText	
  q:Resume="" ret
  f i=1:1:$l(Resume,"/") d
  .//取类型的抗生素
  .s DicID=$p(Resume,"/",i)
  .q:+DicID=0
  .s rSet=##class(%ResultSet).%New("DHCMed.INFService.PatAntiRelationSrv:QuertAntiRelation")
  .s rc=rSet.Execute(DicID)
  .f  q:'rSet.Next()  d
  ..s antiID=rSet.Data("rowid")
  ..s antiDesc=rSet.Data("desc")
  ..//w antiDesc,!
  ..s:ret'="" ret=ret_$c(1)_antiID_"^"_antiDesc
  ..s:ret="" ret=antiID_"^"_antiDesc
  .d rSet.Close()
  q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-05-17
/// Description:  通过类型查询字典表ID
/// Table：       DHCMed.SS.Dictionary
/// Input：       DicType : 类型
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.PatAntiRelationSrv","QueryDicInfoFromType","INFECTIONPYTYPE")
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

}
