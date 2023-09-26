/// 单位查询
Class web.DHCREAGUnit Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, syn As %String, visible As %String) As %Status
{
	s ^TMP($zn,"para")=code_","_name_","_syn_","_visible
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s code=$g(code),name=$g(name),syn=$g(syn),visible=$g(visible)
	s seq="" f  s seq=$o(^lab.DHCCTUnitI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTUnitI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTUnitD(id))
	..s uCode=$li(str,2)
	..s code1=" "_code
	..s code2=" "_uCode
	..i $l(code),code2'[code1 q
	..s uName=$li(str,3)
	..s name1=" "_name
	..s name2=" "_uName
	..i $l(name),name2'[name1 q
	..s uSyn=$li(str,6)
	..s syn1=" "_syn
	..s syn2=" "_uSyn
	..i $l(syn),syn2'[syn1 q
	..s uVis=$li(str,5)
	..i $e(visible)'=$e(uVis) q
	..s uSeq=$li(str,4)
	..d OutputRow
	/*
	s id="" f  s id=$o(^lab.DHCCTUnitD(id)) q:id=""  d
	.s str=$g(^lab.DHCCTUnitD(id))
	.s uCode=$li(str,2)
	.s code1=" "_code
	.s code2=" "_uCode
	.i $l(code),code2'[code1 q
	.s uName=$li(str,3)
	.s name1=" "_name
	.s name2=" "_uName
	.i $l(name),name2'[name1 q
	.s uSyn=$li(str,6)
	.s syn1=" "_syn
	.s syn2=" "_uSyn
	.i $l(syn),syn2'[syn1 q
	.s uVis=$li(str,5)
	.i $e(visible)'=$e(uVis) q
	.s uSeq=$li(str,4)
	.d OutputRow
	*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(uCode,uName,uSyn,uSeq,uVis)
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
/// CreatDate：    20100421
/// Description:： 单位查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(code As %String, name As %String, syn As %String, visible As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Synonym:%String,Sequence:%String,Visible:%String")
{
}

ClassMethod GetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataExecute(ByRef qHandle As %Binary, syn As %String) As %Status
{
	s syn=$g(syn),name=syn
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s seq="" f  s seq=$o(^lab.DHCCTUnitI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTUnitI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTUnitD(id))
	..s uVis=$li(str,5)
	..i uVis'="Y" q
	..s uCode=$li(str,2)
	..s uName=$li(str,3)
	..s name1=" "_name
	..s name2=" "_uName
	..i $l(name),name2'[name1 q
	..s uSyn=$li(str,6)
	..s syn1=" "_syn
	..s syn2=" "_uSyn
	..i $l(syn),syn2'[syn1 q
	..d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(uCode,uSyn_" "_uName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataExecute ]
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
/// CreatDate：    20100429
/// Description:： 单位快速查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetData(syn As %String) As %Query(ROWSPEC = "代码:%String,名称:%String")
{
}

}
