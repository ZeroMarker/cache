Class web.DHCANOPOutInDeptLink Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod FindOutInDeptLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutInDeptLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("","","")
Query FindOutInDeptLink(deptId As %String = "") As %Query(ROWSPEC = "outLocId:%String,outLocDesc:%String,inLocIdStr:%String,inLocDesc:%String")
{
}

ClassMethod FindOutInDeptLinkExecute(ByRef qHandle As %Binary, deptId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s deptID=""
	f  s deptID=$o(^DHCANC("OutInLink",deptID)) q:deptID=""  d
		.s dept=$p(^CTLOC(deptID),"^",2)
		.s linklocIdStr=$g(^DHCANC("OutInLink",deptID))
		.s linkloc=""
		.s loclength=$l(linklocIdStr,",")
		.f lnum=1:1:loclength d
		..s linklocID=$p(linklocIdStr,",",lnum)
		..i linkloc'="" s linkloc=linkloc_","_$p(^CTLOC(linklocID),"^",2)
		..e  s linkloc=$p(^CTLOC(linklocID),"^",2)
		.Do Output
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	s data=$lb(deptID,dept,linklocIdStr,linkloc)
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

// 删除

/// w ##class(web.DHCANOPOutInDeptLink).OutInDeptLinkDel(49)
ClassMethod OutInDeptLinkDel(deptID As %String) As %String
{
	q:(deptID="") -3
	k ^DHCANC("OutInLink",deptID) 
	s indepid=$g(^DHCANC("OutInLink",deptID))
	s loclength=$l(indepid,",")
	f ilnum=1:1:loclength d
		.s linklocID=$p(indepid,",",ilnum)
		.q:linklocID=""
		.k ^DHCANC("InOutLink",linklocID) 
	q 0
}

// 修改

ClassMethod OutInDeptLinkModify(outlocId As %String, inlocId As %String) As %String
{
	q:(outlocId="") -3_"^"_"门诊科室为空"
	q:(inlocId="") -2_"^"_"住院科室为空"
	s ^DHCANC("OutInLink",outlocId)=inlocId
	s inlocstr=$g(^DHCANC("OutInLink",outlocId))
	s loclength=$l(inlocstr,",")
	f ilnum=1:1:loclength d
		.s linklocID=$p(inlocstr,",",ilnum)
		.s ^DHCANC("InOutLink",linklocID,outlocId)=outlocId
		.
	
	 q 0
}

/// w ##class(web.DHCANOPOutInDeptLink).GetOutInLinkID(6)
ClassMethod GetOutInLinkID(deptID) As %String
{
	q:(deptID="") -3
	s linkin=""
	i $d(^DHCANC("OutInLink",deptID))>0  d
	.s linkin=$tr($g(^DHCANC("OutInLink",deptID)),",","^")
	i $d(^DHCANC("InOutLink",deptID))>0  d
	.s outid=""
	.f  s outid=$o(^DHCANC("InOutLink",deptID,outid)) q:outid=""  d
	..s linkin=outid_"^"_linkin
	q linkin
}

}
