Class web.DHCANRCManageClass Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCANRCManageClass","FindANRCManageClass")
Query FindANRCManageClass() As %Query(ROWSPEC = "RowId,Code,Desc,CtlocDr,Ctloc,AuditCarPrvTpDescStr,AuditCarPrvTpDrStr")
{
}

ClassMethod FindANRCManageClassExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s RowId=0
	f  s RowId=$o(^DHCANRC("ManageClass",RowId)) q:RowId=""  d
	.s Code=$li(^DHCANRC("ManageClass",RowId),1)
	.s Desc=$li(^DHCANRC("ManageClass",RowId),2)
	.s CtlocDr=$li(^DHCANRC("ManageClass",RowId),3)
	.q:CtlocDr=""
	.s Ctloc=$p($g(^CTLOC(CtlocDr)),"^",2)
	.s AuditCarPrvTpDrStr=$li(^DHCANRC("ManageClass",RowId,1),1)
	.s AuditCarPrvTpDescStr=""
	.s len=$l(AuditCarPrvTpDrStr,"^")
	.f i=1:1:len d
	..s AuditCarPrvTpDr=$p(AuditCarPrvTpDrStr,"^",i)
	..s AuditCarPrvTpDesc=$p($g(^CT("CPT",AuditCarPrvTpDr)),"^",2)
	..i AuditCarPrvTpDescStr="" s AuditCarPrvTpDescStr=AuditCarPrvTpDesc
	..e  s AuditCarPrvTpDescStr=AuditCarPrvTpDescStr_","_AuditCarPrvTpDesc
	.d OutputRow 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,Code,Desc,CtlocDr,Ctloc,AuditCarPrvTpDescStr,AuditCarPrvTpDrStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANRCManageClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANRCManageClassExecute ]
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

ClassMethod FindANRCManageClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANRCManageClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InsertANRCManageClass(Code, Desc, CtlocDr, AuditCarPrvTpDr) As %String
{
	q:(Code="")!(Desc="") "代码和名称不能为空！"
	q:CtlocDr="" "科室不能为空！"
	q:AuditCarPrvTpDr="" "-1"
	s AuditCarPrvTp=$tr(AuditCarPrvTpDr,",","^")
	s ObjManageClass=##class(User.DHCANRCManageClass).%New()
	s ObjManageClass.ANRCMCCode=Code
	s ObjManageClass.ANRCMCDesc=Desc
	//s ctlocDr=##class(User.CTLoc).%OpenId(CtlocDr)
	s ObjManageClass.ANRCMCCtlocDr=CtlocDr
	s ObjManageClass.ANRCMCAuditCarPrvTpDr=AuditCarPrvTp
	s SaveStatus=ObjManageClass.%Save()
	q:(+SaveStatus=0) "数据添加失败！"
	s ID=ObjManageClass.%Id()
	d ObjManageClass.%Close()
	q 0
}

ClassMethod UpdateANRCManageClass(RowId, Code, Desc, CtlocDr, AuditCarPrvTpDr) As %String
{
	q:(RowId="") "RowId不能为空！"
	q:(Code="")!(Desc="") "代码和名称不能为空！"
	q:CtlocDr="" "科室不能为空！"
	q:AuditCarPrvTpDr="" "-1"
	q:'##class(User.DHCANRCManageClass).%ExistsId(RowId) "无指针对应记录！"
	s AuditCarPrvTp=$tr(AuditCarPrvTpDr,",","^")
	s ObjManageClass=##class(User.DHCANRCManageClass).%OpenId(RowId)
	s ObjManageClass.ANRCMCCode=Code
	s ObjManageClass.ANRCMCDesc=Desc
	s ObjManageClass.ANRCMCCtlocDr=CtlocDr
	s ObjManageClass.ANRCMCAuditCarPrvTpDr=AuditCarPrvTp
	s UpdateStatus=ObjManageClass.%Save()
	q:(+UpdateStatus=0) "数据修改失败！"
	d ObjManageClass.%Close()
	q 0
}

ClassMethod DeleteANRCManageClass(RowId) As %String
{
	q:(RowId="") 
	q:'##class(User.DHCANRCManageClass).%ExistsId(RowId) "无指针对应记录！"
	s DeleteStatus=##class(User.DHCANRCManageClass).%DeleteId(RowId)
	q:(+DeleteStatus=0) "数据删除失败！"
	q 0
}

}
