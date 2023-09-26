Class web.DHCREAGModule Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 9;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary) As %Status
{
	s code=$g(code),name=$g(name),visible=$g(visible)
	s ^TMP($zn,"para")=code_","_name_","_visible
	//^lab.DHCCTSYSModuleD("A1")=<<$LB("","A1","新建入库单")>>
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s code="" f  s code=$o(^lab.DHCCTSYSModuleD(code)) q:code=""  d
	.s str=$g(^lab.DHCCTSYSModuleD(code))
	.s uName=$li(str,3)
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(code,uName)
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
/// Description:： 模块查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll() As %Query(ROWSPEC = "Code:%String,Name:%String")
{
}

}
