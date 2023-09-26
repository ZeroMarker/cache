Class web.DHCNurEprMenuMain Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetFatherList(typ, funname) As %String
{
 
    s id="" f  s id=$O(^Nur.DHCNUREPRMenuD(id)) q:id=""  d
 	.s a=##class(Nur.DHCNUREPRMenu).%OpenId(id)
 	.q:a.ifon'="Y"
 	.s desc=a.name
 	.s code=a.code
    .s rtnval=funname_"('"_$ZCVT($g(code),"O","JS")_"','"_$ZCVT($g(desc),"O","JS")_"');"
    .&javascript<#(rtnval)#>
}

ClassMethod GetSonList(fatherId, funname) As %String
{
	s fatherId=$ZConvert(fatherId,"U")
    s fatherId=$o(^Nur.DHCNUREPRMenuI("codeIndex"," "_fatherId,""))
    s id="" f  s id=$O(^Nur.DHCNUREPRMenuSubD(id)) q:id=""  d
 	.s a=##class(Nur.DHCNUREPRMenuSub).%OpenId(id)
 	.q:a.ifon'="Y"
 	.q:a.fatherId'=fatherId
 	.s desc=a.name
 	.s code=id
    .s rtnval=funname_"('"_$ZCVT($g(code),"O","JS")_"','"_$ZCVT($g(desc),"O","JS")_"');"
    .&javascript<#(rtnval)#>
}

/// 维护程序Grid
/// d ##class(%ResultSet).RunQuery("web.DHCNurEprMenuMain","GetMenuDetail","aa")
/// Input:sonNode
Query GetMenuDetail(parr) As %Query(ROWSPEC = "code,name,classMethod,InPutSyj,InPutSyjSub,fatherId,ifon,sort,id")
{
}

ClassMethod GetMenuDetailExecute(ByRef qHandle As %Binary, parr) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;s parr=$ZConvert(parr,"U")
    ;s parr=$o(^Nur.DHCNUREPRMenuSubI("codeIndex"," "_parr,""))
    s id="" f  s id=$O(^Nur.DHCNUREPRMenuDetailD(id)) q:id=""  d
 	.s a=##class(Nur.DHCNUREPRMenuDetail).%OpenId(id)
 	.q:a.fatherId'=parr
 	.s name=a.name
 	.s code=a.code
 	.s fatherId=##class(Nur.DHCNUREPRMenuSub).getnamebyid(a.fatherId)
 	.s ifon=a.ifon
 	.s sort=a.sort
 	.s InPutSyj=a.InPutSyj
 	.s InPutSyjSub=a.InPutSyjSub
 	.s classMethod=a.classMethod
 	.d OutputRowMenuDetail
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
OutputRowMenuDetail
	set Data=$lb(code,name,classMethod,InPutSyj,InPutSyjSub,fatherId,ifon,sort,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMenuDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMenuDetailExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMenuDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMenuDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCNurEprMenuMain","NodeComBoBox","")
Query NodeComBoBox(codedesc As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod NodeComBoBoxExecute(ByRef qHandle As %Binary, codedesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    
    s id="" f  s id=$O(^Nur.DHCNUREPRMenuSubD(id)) q:id=""  d
 	.s a=##class(Nur.DHCNUREPRMenuSub).%OpenId(id)
 	.s desc=a.name
 	.q:a.ifon'="Y"
 	.s code=id
 	.q:(codedesc'="")&(desc'[codedesc)&(code'[codedesc)
 	.s aa="desc|"_desc_"^id|"_code 
 	.d OutputRowNode
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowNode
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NodeComBoBoxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NodeComBoBoxExecute ]
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

ClassMethod NodeComBoBoxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NodeComBoBoxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 电子病历信息Grid
/// d ##class(%ResultSet).RunQuery("web.DHCNurEprMenuMain","GetMenuGridDetail","3^50")
/// Input:sonNode
Query GetMenuGridDetail(parr) As %Query(ROWSPEC = "name,eprInfo")
{
}

ClassMethod GetMenuGridDetailExecute(ByRef qHandle As %Binary, parr) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TEMPGuoxubo("GGG")=parr
 	s nodeId=$p(parr,"^",1)
 	s episodeID=$p(parr,"^",2)
 	if (nodeId="")||(episodeID="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	k GridDataArr
    s id="" f  s id=$O(^Nur.DHCNUREPRMenuDetailD(id)) q:id=""  d
 	.s a=##class(Nur.DHCNUREPRMenuDetail).%OpenId(id)
 	.q:a.fatherId'=nodeId
 	.s name=a.name
 	.s fatherId=a.fatherId
 	.s ifon=a.ifon
 	.q:ifon'="Y"
 	.s sort=+(a.sort)
 	.s InPutSyj=a.InPutSyj
 	.s InPutSyjSub=a.InPutSyjSub
 	.s classMethod=a.classMethod
 	.s eprInfo=..GetEprInfo(episodeID,classMethod,InPutSyj,InPutSyjSub)
 	.s GridDataArr(sort,id,name)=eprInfo
 	
 	s sort="" f  s sort=$o(GridDataArr(sort)) q:sort=""  d
 	.s id=""  f  s id=$o(GridDataArr(sort,id)) q:id=""  d
 	..s name="" f  s name=$o(GridDataArr(sort,id,name)) q:name=""  d
 	...s eprInfo=GridDataArr(sort,id,name)	
 	...d OutputRowGetMenuGridDetail	
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
OutputRowGetMenuGridDetail
	set Data=$lb(name,eprInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMenuGridDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMenuGridDetailExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMenuGridDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMenuGridDetailExecute ]
{

	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取信息
/// w ##class(web.DHCNurEprMenuMain).GetEprInfo("9","","HDSD00.13.01","HDSD00.13.112")
ClassMethod GetEprInfo(episodeID, classMethod, InPutSyj, InPutSyjSub)
{
	n (episodeID,classMethod,InPutSyj,InPutSyjSub)
	Quit:(InPutSyj="")!(InPutSyjSub="")!(episodeID="") ""
	Set InPutSyj=InPutSyj
	Set ret=""
	
	set classMethod=$TR(classMethod," ","")
	If classMethod=""  Set classMethod="EMRservice.BL.BLScatterData:GetNewStdDataByGlossaryCategory"
	Set className=$p(classMethod,":",1)
	Set methodName=$p(classMethod,":",2)
	Set executeMethod="s ret=##class("_className_")."_methodName_"("_episodeID_","_$c(34)_InPutSyj_$c(34)_")"	
	try
    { X executeMethod}
	catch
	{ Set ret=""}  
	
	Quit:ret="" ""
	if $IsObject(ret)
	{
		if ret.IsDefined(InPutSyjSub)
		{			
			Quit ret.GetAt(InPutSyjSub)
		}
		else
		{
			Quit "不能通过参数1("_InPutSyj_")取出打散的术语集("_InPutSyjSub_")"
		}		
	}
	else 
	{
		Quit "请检查维护程序"
	}
}

}
