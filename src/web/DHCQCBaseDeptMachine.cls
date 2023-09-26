Class web.DHCQCBaseDeptMachine Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 检验科室信息查询
ClassMethod GetDeptAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCBaseDeptMachine","GetDeptAll","","")
ClassMethod GetDeptAllExecute(ByRef qHandle As %Binary, Code As %String, Name As %String) As %Status
{
	Set code=$Get(code),name=$Get(name)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set DeptCode="" For  Set DeptCode=$Order(^TTAB("DEP",DeptCode)) Quit:DeptCode=""  Do
	.Set str=$Get(^TTAB("DEP",DeptCode))
	.Set uName=$Piece(str,"\",1)
	.If $Length(code),DeptCode'=code Quit
	.If $Length(uName),uName'[name Quit
	.Do OutputRow1		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
    Set Data=$lb(DeptCode,uName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDeptAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptAllExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20101012
/// Description:： 检验科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetDeptAll(Code As %String, Name As %String) As %Query(ROWSPEC = "Code:%String,Name:%String") [ SqlProc ]
{
}

/// 按照科室查询出仪器。。。
ClassMethod QueryMachineAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMachineAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCBaseDeptMachine","GetDeptAll","","")
ClassMethod QueryMachineAllExecute(ByRef qHandle As %Binary, Code As %String, Name As %String) As %Status
{
	Set code=$Get(code),name=$Get(name)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set DeptCode="" For  Set DeptCode=$Order(^TTAB("DEP",DeptCode)) Quit:DeptCode=""  Do
	.Set str=$Get(^TTAB("DEP",DeptCode))
	.Set uName=$Piece(str,"\",1)
	.If $Length(code),DeptCode'=code Quit
	.If $Length(uName),uName'[name Quit
	.Do OutputRow		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(DeptCode,uName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryMachineAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMachineAllExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20101012
/// Description:： 检验科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryMachineAll(Code As %String, Name As %String) As %Query(ROWSPEC = "Code:%String,Name:%String") [ SqlProc ]
{
}

}
