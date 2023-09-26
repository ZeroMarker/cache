Class web.DHCQCUserRole Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, user As %String, depart As %String) As %Status
{
	s code=$g(code)
	s ^TMP($zn,"para")=code
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTUserDepartmentD(20,"Items",4)=<<$LB("","A1")>>
	//lab.DHCCTUserRoleI("MasterIndex",UserDR, ModuleDR,6)=
	s code="" f  s code=$o(^lab.DHCCTSYSModuleD(code)) q:code=""  d
	.s str=$g(^lab.DHCCTSYSModuleD(code))
	.s id=""
	.i '$l(depart) s id=$o(^lab.DHCCTUserRoleI("MasterIndex",user, code,""))
	.i $l(depart) d
	..s ParRef=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,depart,""))
	..i '$l(ParRef) q
	..s id=$o(^lab.DHCCTUserDepartRoleI("MasterIndex",code,ParRef,""))
	.s UseFlag="Y"
	.i '$l(id) s UseFlag="N"
	.s name=$li(str,3)
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(code,name,UseFlag)
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
/// CreatDate：    20100720
/// Description:： 用户访问权限查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(user As %String, depart As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCUserRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCUserRoleD</DataLocation>
<DefaultData>DHCQCUserRoleDefaultData</DefaultData>
<IdLocation>^web.DHCQCUserRoleD</IdLocation>
<IndexLocation>^web.DHCQCUserRoleI</IndexLocation>
<StreamLocation>^web.DHCQCUserRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
