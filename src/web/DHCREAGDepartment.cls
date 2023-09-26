/// 科室查询
Class web.DHCREAGDepartment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 44;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, syn As %String, visible As %String) As %Status
{
	s code=$g(code),name=$g(name),syn=$g(syn),visible=$g(visible)
	s ^TMP($zn,"para")=code_","_name_","_syn_","_visible
 	Set repid=$I(^CacheTemp)
 	k ^TMP($zn,$j)
	If $g(ind)="" Set ind=1
	//<<$LB("","D01","生化","1","Y","sh","A")>>
	//^lab.DHCCTDepartmentI("SequenceIndex",1,"D01")
	s code=$g(code),name=$g(name),syn=$g(syn),visible=$g(visible)
	s seq="" f  s seq=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTDepartmentD(id))
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
	..s DepList=$li(str,7)
	..s DepName="",DepCodeList=""
	..f i=1:1:$l(DepList,",") d
	...s DepCode=$p(DepList,",",i)
	...i '$l(DepCode) q
	...i '$d(^TTAB("DEP",DepCode)) q
	...s DepCodeList=DepCodeList_DepCode_","
	...s DepName=DepName_$p(^TTAB("DEP",DepCode),"\",1)_","
	..s DepCodeList=$p(DepCodeList,",",1,$l(DepCodeList,",")-1)
	..s DepName=$p(DepName,",",1,$l(DepName,",")-1)
	..s PurUserDr=$li(str,8)
	..s PurUserName=""
	..i $l(PurUserDr),$d(^lab.DHCCTUserD(PurUserDr)) s PurUserName=$li(^lab.DHCCTUserD(PurUserDr),3)
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(uCode,uName,uSyn,uSeq,DepName,PurUserName,DepCodeList,PurUserDr)
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
/// Description:： 试剂科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(code As %String, name As %String, syn As %String, visible As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Synonym:%String,Sequence:%String,DepName:%String,PurUser:%String,DepCode:%String,PurUserCode:%String")
{
}

ClassMethod GetDepartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDepartExecute(ByRef qHandle As %Binary, DepId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s code="" f  s code=$o(^TTAB("DEP",code)) q:code=""  d
	.s name=$p(^TTAB("DEP",code),"\",1)
	.d OutputDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDep
	set Data=$lb(code,name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDepartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
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
/// Description:： 检验科室查询
/// Table：        CT_Department
/// Input：        
/// Output：       
/// Return：       
/// Others：
Query GetDepart(DepId As %String) As %Query(ROWSPEC = "Code:%String,Name:%String")
{
}

ClassMethod GetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataExecute(ByRef qHandle As %Binary, syn As %String, dep As %String) As %Status
{
	s syn=$g(syn),name=syn,dep=$g(dep)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s seq="" f  s seq=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTDepartmentD(id))
	..s uVis=$li(str,5)
	..i uVis'="Y" q
	..s uCode=$li(str,2)
	..i $l(dep),uCode=dep q
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
/// Description:： 用户快速查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetData(syn As %String, dep As %String) As %Query(ROWSPEC = "代码:%String,名称:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100716
/// Description:： 得到指定科室信息
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod GetDepart(DepCode As %String) As %String
{
	Set RetValue=""
	If '$d(^lab.DHCCTDepartmentD(DepCode)) Quit RetValue
	Set str=$g(^lab.DHCCTDepartmentD(DepCode))
	Set Name=$li(str,3)
	Set Visible=$li(str,4)
	Set Sequence=$l(str,5)
	Set Sync=$li(str,6)
	Set LinkDepDr=$li(str,7)
	Set PurUserDr=$li(str,8)
	IF PurUserDr=$C(0) Set PurUserDr=""
	Set (LinkDepName,PurUserName)=""
	If $l(LinkDepDr),$d(^TTAB("DEP",LinkDepDr)) s LinkDepName=$p(^TTAB("DEP",LinkDepDr),"\",1)
	If $l(PurUserDr),$d(^lab.DHCCTUserD(PurUserDr)) s PurUserName=$li(^lab.DHCCTUserD(PurUserDr),3)
	Set RetValue=Name_$c(2)_Visible_$c(2)_Sequence_$c(2)_Sync_$c(2)_LinkDepName_$c(2)_PurUserName_$c(2)_LinkDepDr_$c(2)_PurUserDr
	Quit RetValue
}

}
