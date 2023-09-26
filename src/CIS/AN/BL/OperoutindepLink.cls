Import SQLUser

Class CIS.AN.BL.OperoutindepLink Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindOutInDeptLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutInDeptLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperoutindepLink","FindOutInDeptLink","","","")
Query FindOutInDeptLink(deptId As %String = "", deptDesc As %String = "", linkLocDesc As %String = "") As %Query(ROWSPEC = "RowId:%String,outLocId:%String,outLocDesc:%String,inLocIdStr:%String,inLocDesc:%String,LinkTypeCode:%String,LinkTypeDesc:%String")
{
}

ClassMethod FindOutInDeptLinkExecute(ByRef qHandle As %Binary, deptId As %String = "", deptDesc As %String = "", linkLocDesc As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s LinkRowID=""
	f  s LinkRowID=$o(^CF.AN.DeptLinkDeptD(LinkRowID)) q:LinkRowID=""  d
	    .s RowId=LinkRowID,LinkTypeDesc="",LinkTypeCode=""
		.s deptID=$li(^CF.AN.DeptLinkDeptD(LinkRowID),1)
		.s linklocIdStr=$li(^CF.AN.DeptLinkDeptD(LinkRowID),2)
		.s linkloc=$li(^CF.AN.DepartmentD(linklocIdStr),2)
		.s:LinkRowID>221 LinkTypeCode=$li(^CF.AN.DeptLinkDeptD(LinkRowID),4)
		.i LinkTypeCode="DaySurgery" s LinkTypeDesc="日间手术住院科室"
		.i LinkTypeCode="OperDept" s LinkTypeDesc="默认手术室"
		.i LinkTypeCode="AnaDept" s LinkTypeDesc="默认麻醉科"
		.q:(linkLocDesc'="")&&(linkloc'[linkLocDesc)
		.s dept=$li(^CF.AN.DepartmentD(deptID),2)
		.q:(deptDesc'="")&&(dept'[deptDesc)
		.Do Output
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	s data=$lb(RowId,deptID,dept,linklocIdStr,linkloc,LinkTypeCode,LinkTypeDesc)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
}

ClassMethod FindOutInDeptLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutInDeptLinkExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InserDeptLinkModify(outlocId As %String, inlocId As %String, LinkType As %String) As %String
{
	q:(outlocId="") -3_"^"_"门诊科室为空"
	q:(inlocId="") -2_"^"_"住院科室为空"
    &sql(insert into CF_AN.DeptLinkDept(SourceDept,TargetDept,LinkType) values(:outlocId,:inlocId,:LinkType))
	  
	 q %ROWID
}

ClassMethod UpdateDeptLinkModify(RowId As %String, outlocId As %String, inlocId As %String, LinkType As %String) As %String
{
	q:(RowId="") -1_"^"_"请选择一条记录"
	q:(outlocId="") -3_"^"_"门诊科室为空"
	q:(inlocId="") -2_"^"_"住院科室为空"
    s $li(^CF.AN.DeptLinkDeptD(RowId),1)=outlocId
    s $li(^CF.AN.DeptLinkDeptD(RowId),2)=inlocId
    s $li(^CF.AN.DeptLinkDeptD(RowId),4)=LinkType
	 q RowId
}

ClassMethod GetLinkType(deptID As %String) As %String
{
	q:(deptID="") -3
	&sql(delete from CF_AN.DeptLinkDept where RowId=:deptID)
	q 0
}

ClassMethod OutInDeptLinkDel(deptID As %String) As %String
{
	q:(deptID="") -3
	&sql(delete from CF_AN.DeptLinkDept where RowId=:deptID)
	q 0
}

}
