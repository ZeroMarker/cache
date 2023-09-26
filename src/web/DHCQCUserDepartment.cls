Class web.DHCQCUserDepartment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, user As %String) As %Status
{
	s code=$g(code)
	s ^TMP($zn,"para")=code
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTUserDepartmentI("MasterIndex","demo","D01",6)=
	//^lab.DHCCTDepartmentI("SequenceIndex",1,"D01")=
	s seq="" f  s seq=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq)) q:seq=""  d
	.s dep="" f  s dep=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq,dep)) q:dep=""  d
	..s name=$li(^lab.DHCCTDepartmentD(dep),3)
	..s UseFlag="Y"
	..s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,dep,""))
	..i '$l(id) s UseFlag="N"
	..s IsDefault=""
	..i $l(id) s IsDefault=$li(^lab.DHCCTUserDepartmentD(id),4)
	..i '$l(IsDefault) s IsDefault="N"
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(dep,name,UseFlag,IsDefault)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100608
/// Description:： 用户科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(user As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String,IsDefault:%String") [ SqlProc ]
{
}

ClassMethod GetAccDepartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccDepartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAccDepartExecute(ByRef qHandle As %Binary, user As %String) As %Status
{
	s code=$g(code)
	s ^TMP($zn,"para")=code
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTUserDepartmentI("MasterIndex","demo","D01",6)=
	//^lab.DHCCTDepartmentI("SequenceIndex",1,"D01")=
	s seq="" f  s seq=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq)) q:seq=""  d
	.s dep="" f  s dep=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq,dep)) q:dep=""  d
	..s name=$li(^lab.DHCCTDepartmentD(dep),3)
	..s UseFlag="Y"
	..s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,dep,""))
	..i '$l(id) q
	..s UseFlag="N"
	..s IsDefault=""
	..i $l(id) s IsDefault=$li(^lab.DHCCTUserDepartmentD(id),4)
	..i '$l(IsDefault) s IsDefault="N"
	..d OutputDep			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDep
	set Data=$lb(dep,name,UseFlag,IsDefault)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAccDepartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccDepartExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100608
/// Description:： 用户科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAccDepart(user As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String,IsDefault:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCUserDepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCUserDepartmentD</DataLocation>
<DefaultData>DHCQCUserDepartmentDefaultData</DefaultData>
<IdLocation>^web.DHCQCUserDepartmentD</IdLocation>
<IndexLocation>^web.DHCQCUserDepartmentI</IndexLocation>
<StreamLocation>^web.DHCQCUserDepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
