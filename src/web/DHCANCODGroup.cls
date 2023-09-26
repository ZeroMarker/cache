Class web.DHCANCODGroup Extends %RegisteredObject [ ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("web.DHCANCODGroup","FindODGroupClose","1")

ClassMethod FindODGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindODGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindODGroupExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s deptID=$g(%session.Data("LOGON.CTLOCID"))
	i deptID="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s groupID=""
	f  s groupID=$o(^DHCANC("ODGroup",deptID,groupID)) q:groupID=""  d
		.s docID=$p(^DHCANC("ODGroup",deptID,groupID),"^",1)
		.i docID="" s docStr=""
		.e  i $d(^CTPCP(docID)) s docStr=$p($g(^CTPCP(docID,1)),"^",2)
		.s frtAstID=$p(^DHCANC("ODGroup",deptID,groupID),"^",2)
		.i frtAstID="" s frtAst=""
		.e  i $d(^CTPCP(frtAstID)) s frtAst=$p($g(^CTPCP(frtAstID,1)),"^",2)
		.s secAstID=$p(^DHCANC("ODGroup",deptID,groupID),"^",3)
		.i secAstID="" s secAst=""
		.e  i $d(^CTPCP(secAstID)) s secAst=$p($g(^CTPCP(secAstID,1)),"^",2)
		.s trdAstID=$p(^DHCANC("ODGroup",deptID,groupID),"^",4)
		.i trdAstID="" s trdAst=""
		.e  i $d(^CTPCP(trdAstID)) s trdAst=$p($g(^CTPCP(trdAstID,1)),"^",2)
		.Do Output
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	s data=$lb(groupID,docStr,docID,frtAst,frtAstID,secAst,secAstID,trdAst,trdAstID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
}

ClassMethod FindODGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindODGroupExecute ]
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

Query FindODGroup() As %Query(ROWSPEC = "groupID:%String,opDoctor:%String,opDoctorId:%String,frtAst:%String,frtAstId:%String,secAst:%String,secAstId:%String,trdAst:%String,trdAstId:%String")
{
}

ClassMethod FindOPDoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPDoctorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOPDoctorExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s deptID=$g(%session.Data("LOGON.CTLOCID"))
	i deptID="" Quit $$$OK
	s resID=""
	f  s resID=$o(^RB("RES",0,"CTLOC",deptID,resID)) q:resID=""  d
	.s docID=$p(^RB("RES",resID),"^",2)
	.i $d(^CTPCP(docID)) s docName=$p(^CTPCP(docID,1),"^",2)
	.q:docID=""
	.Do Output
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	s data=$lb(docID,docName)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
}

ClassMethod FindOPDoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPDoctorExecute ]
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

Query FindOPDoctor() As %Query(ROWSPEC = "docID:%String,docName:%String")
{
}

// 添加手术医生组，deptID指科室RowId,groupID指组号,groupStr指所添加医生组的RowId

ClassMethod ODGroupAdd(deptID As %String, groupID As %String, groupStr As %String) As %String
{
	q:(deptID="") -3
	q:(groupID="") -2
	i $d(^DHCANC("ODGroup",deptID,groupID))>0 q -1_"组号重复"
	i $p(groupStr,"^",1)="" q -4_"^"_"主刀不能为空"
	s ^DHCANC("ODGroup",deptID,groupID)=groupStr q 0
}

// 删除手术医生组

ClassMethod ODGroupDel(deptID As %String, groupID As %String) As %String
{
	q:(deptID="") -3
	q:(groupID="") -2
	k ^DHCANC("ODGroup",deptID,groupID) q 0
}

// 修改手术医生组的信息，oldGroupID为修改前的组号

ClassMethod ODGroupModify(deptID As %String, groupID As %String, oldGroupID As %String, groupStr As %String) As %String
{
	q:(deptID="") -3_"^"_"科室为id"
	q:(groupID="") -2_"^"_"组号为空"
	q:(oldGroupID="") -4_"^"_"科室为id"
	i $p(groupStr,"^",1)="" q -4_"^"_"主刀不能为空"
	s compare=""
	i oldGroupID'=groupID  d
		.i $d(^DHCANC("ODGroup",deptID,groupID))>0 s compare="组号重复"
		.i compare="" d
			..m ^DHCANC("ODGroup",deptID,groupID)=^DHCANC("ODGroup",deptID,oldGroupID)
			..k ^DHCANC("ODGroup",deptID,oldGroupID)
	q:compare'="" compare
	s ^DHCANC("ODGroup",deptID,groupID)=groupStr q 0
}

ClassMethod GetODGroupID(deptID As %String, groupID As %String) As %String
{
	q:(deptID="") -3
	q:(groupID="") -2
	i $d(^DHCANC("ODGroup",deptID,groupID))  d
	.s docID=$p(^DHCANC("ODGroup",deptID,groupID),"^",1)
	.s frtAstID=$p(^DHCANC("ODGroup",deptID,groupID),"^",2)
	.s secAstID=$p(^DHCANC("ODGroup",deptID,groupID),"^",3)
	.s trdAstID=$p(^DHCANC("ODGroup",deptID,groupID),"^",4)
	q docID_"^"_frtAstID_"^"_secAstID_"^"_trdAstID
}

}
