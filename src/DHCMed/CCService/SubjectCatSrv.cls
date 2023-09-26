/// 名称: DHCMed.CCService.SubjectCatSrv
/// 描述: DHCMed.CC.SubjectCat 监控主题类别常用方法
/// 编写者：liuyh
/// 编写日期: 2010-09-26
Class DHCMed.CCService.SubjectCatSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  查询监控主题类别信息
/// Table：       DHCMed.CC.SubjectCat
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectCatSrv","QuerySubjectCatInfo","")
Query QuerySubjectCatInfo(title As %String) As %Query(ROWSPEC = "rowid:%String,Title:%String,Code:%String,Desc:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String")
{
}

ClassMethod QuerySubjectCatInfoExecute(ByRef qHandle As %Binary, title As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.SubjectCatD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.SubjectCat).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:((title'="")&(obj.Title'[title))
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Title
	.s $li(data,3)=obj.Code
	.s $li(data,4)=obj.Description
	.s $li(data,5)=obj.IsActive
	.s $li(data,6)="否"
	.s:obj.IsActive=1 $li(data,6)="是"
	.s $li(data,7)=obj.ResumeText
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QuerySubjectCatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubjectCatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubjectCatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubjectCatInfoExecute ]
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
