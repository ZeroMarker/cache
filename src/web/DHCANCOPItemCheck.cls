Class web.DHCANCOPItemCheck Extends %RegisteredObject
{

// 20150907+dyl

// d ##class(%ResultSet).RunQuery("web.DHCANCOPItemCheck","FindChkItem","")

Query FindChkItem(itemType = "") As %Query(ROWSPEC = "tId:%String,tItemCode:%String,tItemDesc:%String,tCtrType:%String,tItemType:%String,tTypeCode:%String,ctrType:%String")
{
}

ClassMethod FindChkItemExecute(ByRef qHandle As %Binary, itemType = "") As %Status
{
 s repid=$I(^CacheTemp)	
 s ind=1
 //i itemType="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 s id="",tItemType=""
 f  s id=$o(^DHCCLComCode("CheckItemType",id)) q:id=""  d
	 .s type=$p(^DHCCLComCode("CheckItemType",id),"^",1)
	 .s tItemType=$p(^DHCCLComCode("CheckItemType",id),"^",2)
	 .s tId=0
	 .f  s tId=$o(^DHCCLSet(type,tId)) q:tId=""  d
		 ..s tItemCode=$p($g(^DHCCLSet(type,tId)),"^",1)
		 ..s tItemDesc=$p($g(^DHCCLSet(type,tId)),"^",2)
		 ..s ctrType=$p($g(^DHCCLSet(type,tId)),"^",3)
		 ..i ctrType="A" s tCtrType="提示"
		 ..e  i ctrType="F" s tCtrType="禁止"
		 ..e  s tCtrType="无控制"
		 ..;w type_","_tId_","_ctrType_","_tCtrType,!
		 ..;q:(type'=itemType)&(itemType'="")
		 ..d OutputRow1
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutputRow1
	set Data=$lb(tId,tItemCode,tItemDesc,tCtrType,tItemType,type,ctrType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindChkItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindChkItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindChkItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChkItemExecute ]
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

Query FindCheckItemType() As %Query(ROWSPEC = "typeCode:%String,typeDesc:%String")
{
}

ClassMethod FindCheckItemTypeExecute(ByRef qHandle As %Binary) As %Status
{
 s repid=$I(^CacheTemp)	
 s ind=1
 s typeId=""
 f  s typeId=$o(^DHCCLComCode("CheckItemType",typeId)) q:typeId=""  d
 .s typeCode=$p(^DHCCLComCode("CheckItemType",typeId),"^",1)
 .s typeDesc=$p(^DHCCLComCode("CheckItemType",typeId),"^",2)
 .d OutputRow2
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutputRow2
	set Data=$lb(typeCode,typeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCheckItemTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckItemTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckItemTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckItemTypeExecute ]
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

/// w ##class(web.DHCANCOPItemCheck).InsertItemCheck("PTA","凝血酶原活动度","无控制","Assay")
ClassMethod InsertItemCheck(itemCode, itemDesc, ctrType, itemType)
{
 s itemId="",i=0,flag=1
 f  s itemId=$o(^DHCCLSet(itemType,itemId))  q:itemId=""  d
 .s i=itemId
 .s code=$p($g(^DHCCLSet(itemType,itemId)),"^",1),desc=$p($g(^DHCCLSet(itemType,itemId)),"^",2)
 .i (itemCode=code)!(itemDesc=desc) s flag=0
 q:flag=0 0
 s i=i+1
 s ^DHCCLSet(itemType,i)=itemCode_"^"_itemDesc_"^"_ctrType
 s ^DHCCLSet(itemType,0)=i
 q 1
}

ClassMethod UpdateItemCheck(itemCode, itemDesc, ctrType, itemType, rowId, oldStr)
{
 	s oldCode=$p(oldStr,"^",1)
	s oldDesc=$p(oldStr,"^",2)
	s oldCtrotype=$p(oldStr,"^",3)
	s oldTypeCode=$p(oldStr,"^",4)
	 s itemId="",flag=1
	 f  s itemId=$o(^DHCCLSet(itemType,itemId))  q:itemId=""  d
		 .s code=$p($g(^DHCCLSet(itemType,itemId)),"^",1),desc=$p($g(^DHCCLSet(itemType,itemId)),"^",2)
		 .i ((itemCode=code)!(itemDesc=desc))&(itemId'=rowId) s flag=0
	 q:flag=0 0
	i oldTypeCode'=itemType k ^DHCCLSet(oldTypeCode,rowId)
	 
	 s ^DHCCLSet(itemType,rowId)=itemCode_"^"_itemDesc_"^"_ctrType
	 q 1
}

ClassMethod DeleteItemCheck(itemType, rowId)
{
 q:(itemType="")!(rowId="") 0
 k ^DHCCLSet(itemType,rowId)
 q 1
}

// YuanLin 20170921

ClassMethod GetItemType(itemType)
{
 q:(itemType="") ""
 s itemTypeCode=""
 s typeId="" f  s typeId=$o(^DHCCLComCode("CheckItemType",typeId)) q:typeId=""  d
 .s typeCode=$p(^DHCCLComCode("CheckItemType",typeId),"^",1)
 .s typeDesc=$p(^DHCCLComCode("CheckItemType",typeId),"^",2)
 .i (typeDesc=itemType) s itemTypeCode=typeCode
 q itemTypeCode
}

}
