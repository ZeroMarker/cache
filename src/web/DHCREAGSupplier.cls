/// 供应商
Class web.DHCREAGSupplier Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 51;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, syn As %String, visible As %String) As %Status
{
	s code=$g(code),name=$g(name),syn=$g(syn),visible=$g(visible),dptment=$g(dptment)
	s ^TMP($zn,"para")=code_","_name_","_syn_","_visible_","_dptment
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s code=$g(code),name=$g(name),syn=$g(syn),visible=$g(visible)
	s seq="" f  s seq=$o(^lab.DHCCTSupplierI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTSupplierI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTSupplierD(id))
	..s uCode=$li(str,2)
	..s code1=" "_code
	..s code2=" "_uCode
	..i $l(code),code2'[code1 q
	..s uName=$li(str,3)
	..s name1=" "_name
	..s name2=" "_uName
	..i $l(name),name2'[name1  q
	..s uSyn=$li(str,10)
	..s syn1=" "_syn
	..s syn2=" "_uSyn
	..i $l(syn),syn2'[syn1 q
	..s uVis=$li(str,9)
	..//i $e(visible)'=$e(uVis) q
	..i $l(visible),visible="No",uVis'="Y" q
	..s uAddress=$li(str,4)
	..s uOfficeTel=$li(str,5)
	..s uMobile=$li(str,6)
	..s uRemark=$li(str,7)
	..s uSeq=$li(str,8)
	..s FullName=$li(str,11)
	..s Carrier=$li(str,12)
	..s Linkman=$li(str,13)
	..s Fax=$li(str,14)
	..s Postcode=$li(str,15)
	..s Email=$li(str,16)
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(uCode,uName,uSyn,uAddress,uOfficeTel,uMobile,FullName,Carrier,Linkman,Fax,Postcode,Email,uRemark,uSeq,uVis)
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
/// CreatDate：    20100422
/// Description:： 供应商查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
/// uAddress,uOfficeTel,uMobile,uRemark,uSeq
Query GetAll(code As %String, name As %String, syn As %String, visible As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Synonym:%String,Address:%String,OfficeTel:%String,Mobile:%String,FullName:%String,Carrier:%String,Linkman:%String,Fax:%String,Postcode:%String,Email:%String,Remark:%String,Sequence:%String,Visible:%String")
{
}

ClassMethod GetDataExecute(ByRef qHandle As %Binary, syn As %String) As %Status
{
	s syn=$g(syn),name=syn
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s seq="" f  s seq=$o(^lab.DHCCTSupplierI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTSupplierI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTSupplierD(id))
	..s uVis=$li(str,9)
	..i uVis'="Y" q
	..s uCode=$li(str,2)
	..s uName=$li(str,3)
	..s name1=" "_name
	..s name2=" "_uName
	..i $l(name),name2'[name1 q
	..s uSyn=$li(str,10)
	..s syn1=" "_syn
	..s syn2=" "_uSyn
	..i $l(syn),syn2'[syn1 q
	..s carrier=$li(str,12)
	..d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(uCode,uSyn_" "_uName,carrier)
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
/// Description:： 供应商快速查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetData(syn As %String) As %Query(ROWSPEC = "code:%String,name:%String,carrier:%String")
{
}

ClassMethod GetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
