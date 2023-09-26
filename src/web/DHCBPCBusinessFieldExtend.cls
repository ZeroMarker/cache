Class web.DHCBPCBusinessFieldExtend Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCBusinessFieldExtend","FindBusinessFieldExtend","","")
Query FindBusinessFieldExtend(Code As %String = "", Type As %String = "") As %Query(ROWSPEC = "tRowId,BPBusFieldExtCode,BPBusFieldExtDesc,BPBusFieldExtType,BPBusFieldExtTypeDesc,BPBusFieldExtActive,BPBusFieldExtActiveDesc,BPBusFieldExtOption,BPBusFieldExtSortNo,BPBusFieldExtANOPACode")
{
}

ClassMethod FindBusinessFieldExtendExecute(ByRef qHandle As %Binary, Code As %String = "", Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s tRowId="",BPBusFieldExtANOPACode=""
	i (Code'="")&(Type'="") d
	.f  s tRowId=$o(^DHCBPC("BusinessFieldExtend",0,"TypeCode",Type,Code,tRowId)) q:tRowId=""  d
	..q:tRowId=0
	..s retStr=..GetExtendItemById(tRowId)
	..s BPBusFieldExtCode=$p(retStr,"^",1)
	..s BPBusFieldExtDesc=$p(retStr,"^",2)
	..s BPBusFieldExtType=$p(retStr,"^",3)
	..s BPBusFieldExtTypeDesc=$p(retStr,"^",4)
	..s BPBusFieldExtActive=$p(retStr,"^",5)
	..s BPBusFieldExtOption=$p(retStr,"^",6)
	..s BPBusFieldExtSortNo=$p(retStr,"^",7)
	..s BPBusFieldExtActiveDesc=$p(retStr,"^",8)
	..d OutputExtend
	e  i (Code'="")&(Type="") d
	.f  s tRowId=$o(^DHCBPC("BusinessFieldExtend",0,"Code",Code,tRowId)) q:tRowId=""  d
	..q:tRowId=0
	..s retStr=..GetExtendItemById(tRowId)
	..s BPBusFieldExtCode=$p(retStr,"^",1)
	..s BPBusFieldExtDesc=$p(retStr,"^",2)
	..s BPBusFieldExtType=$p(retStr,"^",3)
	..s BPBusFieldExtTypeDesc=$p(retStr,"^",4)
	..s BPBusFieldExtActive=$p(retStr,"^",5)
	..s BPBusFieldExtOption=$p(retStr,"^",6)
	..s BPBusFieldExtSortNo=$p(retStr,"^",7)
	..d OutputExtend	
	..s BPBusFieldExtActiveDesc=$p(retStr,"^",8)
	e  d
	.f  s tRowId=$o(^DHCBPC("BusinessFieldExtend",tRowId)) q:tRowId=""  d
	..q:tRowId=0
	..s retStr=..GetExtendItemById(tRowId)
	..s BPBusFieldExtCode=$p(retStr,"^",1)
	..s BPBusFieldExtDesc=$p(retStr,"^",2)
	..s BPBusFieldExtType=$p(retStr,"^",3)
	..q:(Type'="")&(Type'=BPBusFieldExtType)
	..s BPBusFieldExtTypeDesc=$p(retStr,"^",4)
	..s BPBusFieldExtActive=$p(retStr,"^",5)
	..s BPBusFieldExtOption=$p(retStr,"^",6)
	..s BPBusFieldExtSortNo=$p(retStr,"^",7)
	..s BPBusFieldExtActiveDesc=$p(retStr,"^",8)
	..d OutputExtend
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputExtend
 set Data=$lb(tRowId,BPBusFieldExtCode,BPBusFieldExtDesc,BPBusFieldExtType,BPBusFieldExtTypeDesc,BPBusFieldExtActive,BPBusFieldExtActiveDesc,BPBusFieldExtOption,BPBusFieldExtSortNo,BPBusFieldExtANOPACode)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindBusinessFieldExtendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBusinessFieldExtendExecute ]
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

ClassMethod FindBusinessFieldExtendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBusinessFieldExtendExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 添加 修改 数据
/// w ##class(web.DHCBPCBusinessFieldExtend).SaveExtendItem("a^BAA^S^Y^^","3")
ClassMethod SaveExtendItem(Para As %String, RowId) As %String
{
	s code=$p(Para,"^",1)
	q:code="" "-1"
	s desc=$p(Para,"^",2)
	s type=$p(Para,"^",3)
	q:type="" "-2"
	s active=$p(Para,"^",4)
	s option=$p(Para,"^",5)
	s sortno=$p(Para,"^",6)
	//s rowId=$o(^DHCANC("OPArrangeExtend",0,"TypeCode",type,code,""))   //code可重复，通过type区分
	s rowId=$O(^DHCBPC("BusinessFieldExtend",0,"Code",code,""))    //code不可以重复
	s error =0 
	k ^Liyinuo
	i RowId=""  d
	.i rowId ="" s obj=##class(User.DHCBPCBusinessFieldExtend).%New()
	.i rowId '="" s error=1
	e  d
	.i (rowId'="")&&(RowId'=rowId) s error=1
	.e  d  s obj=##class(User.DHCBPCBusinessFieldExtend).%OpenId(RowId)
	s ^Liyinuo=error
	q:error=1 "-3"
	
	s obj.BPCBFECode=code
	s obj.BPCBFEDesc=desc
	s obj.BPCBFEType=type
	s obj.BPCBFEActive=active
	s obj.BPCBFEOption=option
	s obj.BPCBFESortNo=sortno

	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-2^数据保存失败!"_code
	s RowId=obj.%Id()
	d obj.%Close()
	q RowId
}

ClassMethod DeleteExtendItem(RowId As %String) As %String
{
	q:RowId="" "RowId is null"
	d ##class(User.DHCBPCBusinessFieldExtend).%DeleteId(RowId)
	q 0
}

ClassMethod GetExtendItemById(RowId As %String)
{
	q:RowId="" "RowId is null"
	s BPBusFieldExtCode=$li(^DHCBPC("BusinessFieldExtend",RowId),1)
	s BPBusFieldExtDesc=$li(^DHCBPC("BusinessFieldExtend",RowId),2)
	s BPBusFieldExtType=$li(^DHCBPC("BusinessFieldExtend",RowId),3)
	s BPBusFieldExtActive=$li(^DHCBPC("BusinessFieldExtend",RowId),4)
	s BPBusFieldExtOption=$li(^DHCBPC("BusinessFieldExtend",RowId),5)
	s BPBusFieldExtSortNo=$li(^DHCBPC("BusinessFieldExtend",RowId),6)
	s BPBusFieldExtTypeDesc=""
	i BPBusFieldExtType="S" s BPBusFieldExtTypeDesc="方案"
	e  i BPBusFieldExtType="A" s BPBusFieldExtTypeDesc="安排"
	s BPBusFieldExtActiveDesc="否"
	i BPBusFieldExtActive="Y" s BPBusFieldExtActiveDesc="是"
	
	s retStr=BPBusFieldExtCode_"^"_BPBusFieldExtDesc_"^"_BPBusFieldExtType_"^"_BPBusFieldExtTypeDesc_"^"_BPBusFieldExtActive_"^"_BPBusFieldExtOption_"^"_BPBusFieldExtSortNo_"^"_BPBusFieldExtActiveDesc
	q retStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCBusinessFieldExtend","FindExtendItemBySCode","","")
/// mfc 20161104
/// 功能：根据主项目code和值，获取子项目的扩展表数据
Query FindExtendItemBySCode(SourceCode As %String = "", SourceValue As %String = "") As %Query(ROWSPEC = "tRowId,BPBusFieldExtCode,BPBusFieldExtDesc,BPBusFieldExtType,BPBusFieldExtTypeDesc,BPBusFieldExtActive,BPBusFieldExtActiveDesc,BPBusFieldExtOption,BPBusFieldExtSortNo")
{
}

ClassMethod FindExtendItemBySCodeExecute(ByRef qHandle As %Binary, SourceCode As %String = "", SourceValue As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	q:SourceCode="" ""
	s tRowId=""
	f  s tRowId=$o(^DHCBPC("LinkedData",0,"SourceCode",SourceCode,tRowId)) q:tRowId=""  d
		.s LinkedCode=$li(^DHCBPC("LinkedData",tRowId),2)
		.q:LinkedCode=""
		.s BusinessFieldExtendId=$o(^DHCBPC("BusinessFieldExtend",0,"Code",LinkedCode,""))
		.q:BusinessFieldExtendId=""
		.s retStr=..GetExtendItemById(BusinessFieldExtendId)
		.s BPBusFieldExtCode=$p(retStr,"^",1)
		.s BPBusFieldExtDesc=$p(retStr,"^",2)
		.s BPBusFieldExtType=$p(retStr,"^",3)
		.s BPBusFieldExtTypeDesc=$p(retStr,"^",4)
		.s BPBusFieldExtActive=$p(retStr,"^",5)
		.s BPBusFieldExtOption=$p(retStr,"^",6)
		.s BPBusFieldExtSortNo=$p(retStr,"^",7)
		.s BPBusFieldExtActiveDesc=$p(retStr,"^",8)
		.s SourceOption=$li(^DHCBPC("LinkedData",tRowId),3)
		.q:(SourceValue'="")&&(SourceOption'[SourceValue)
		.d OutputExtend
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputExtend
 	set Data=$lb(tRowId,BPBusFieldExtCode,BPBusFieldExtDesc,BPBusFieldExtType,BPBusFieldExtTypeDesc,BPBusFieldExtActive,BPBusFieldExtActiveDesc,BPBusFieldExtOption,BPBusFieldExtSortNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindExtendItemBySCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExtendItemBySCodeExecute ]
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

ClassMethod FindExtendItemBySCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExtendItemBySCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
