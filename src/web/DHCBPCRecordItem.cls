Import SQLUSER

Class web.DHCBPCRecordItem Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCRecordItem","FindBPCReItem")
Query FindBPCReItem(BPCRICode As %String = "", BPCRIDesc As %String = "") As %Query(ROWSPEC = "tRowId:%String,tBPCRICode:%String,tBPCRIDesc:%String,tBPCRIBPCRecordCatDr :%String,tBPCRIBPCRecordCat :%String,tBPCRITypeDr:%String,tBPCRIType:%String,tBPCRIArcimDr:%String,tBPCRIArcim:%String,tBPCRIUomDr:%String,tBPCRIUom:%String,tBPCRIOptions:%String,tBPCRIDataTypeDr :%String,tBPCRIDataType :%String,tBPCRIMultiValueDesc:%String,tBPCRISortNo:%String,tBPCRIMin:%String,tBPCRIMax:%String,tBPCRIImpossibleMin:%String,tBPCRIImpossibleMax:%String,tBPCRIMainRecordItemDr:%String,tBPCRIMainRecordItem:%String,tBPCRICollectCode:%String")
{
}

ClassMethod FindBPCReItemExecute(ByRef qHandle As %Binary, BPCRICode As %String = "", BPCRIDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tRowId=0
	f  s tRowId=$o(^DHCBPC("RecordItem",tRowId))  q:tRowId=""  d
	.s tBPCRICode=$lg(^DHCBPC("RecordItem",tRowId),1)
	.q:(BPCRICode'="")&&(BPCRICode'=tBPCRICode)	
	.s tBPCRIDesc=$lg(^DHCBPC("RecordItem",tRowId),2)
	.q:(BPCRIDesc'="")&&(BPCRIDesc'=tBPCRIDesc)
	.s tBPCRIBPCRecordCatDr=$lg(^DHCBPC("RecordItem",tRowId),3)
	.q:tBPCRIBPCRecordCatDr=""
	.i tBPCRIBPCRecordCatDr'="" s tBPCRIBPCRecordCat=$lg(^DHCBPC("RecordCat",tBPCRIBPCRecordCatDr),2)
	.s tBPCRITypeDr=$lg(^DHCBPC("RecordItem",tRowId),4)
	.i tBPCRITypeDr="D" s tBPCRIType="药品"
	.i tBPCRITypeDr="V" s tBPCRIType="生命体征"
	.i tBPCRITypeDr="E" s tBPCRIType="事件"
	.i tBPCRITypeDr="T" s tBPCRIType="治疗"
	.i tBPCRITypeDr="L" s tBPCRIType="检验"
	.s tBPCRIArcimDr=$lg(^DHCBPC("RecordItem",tRowId),5)
	.s arcimSub=$p(tBPCRIArcimDr,"||",1)
	.s arcimVer=$p(tBPCRIArcimDr,"||",2)
	.i (arcimSub'="")&&(arcimVer'="") s tBPCRIArcim=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	.s tBPCRIUomDr=$lg(^DHCBPC("RecordItem",tRowId),6)
	.i tBPCRIUomDr'="" s tBPCRIUom=$p(^CT("UOM",tBPCRIUomDr),"^",2)
	.s tBPCRIOptions=$lg(^DHCBPC("RecordItem",tRowId),7)
	.s tBPCRIDataTypeDr=$lg(^DHCBPC("RecordItem",tRowId),8)
	.i tBPCRIDataTypeDr="N" s tBPCRIDataType="数值"
	.i tBPCRIDataTypeDr="S" s tBPCRIDataType="字符串"
	.i tBPCRIDataTypeDr="C" s tBPCRIDataType="单选"
	.i tBPCRIDataTypeDr="M" s tBPCRIDataType="多选"
	.i tBPCRIDataTypeDr="I" s tBPCRIDataType="图标"
	.i tBPCRIDataTypeDr="D" s tBPCRIDataType="日期"
	.s tBPCRIMultiValueDesc=$lg(^DHCBPC("RecordItem",tRowId),9)
	.s tBPCRISortNo=$lg(^DHCBPC("RecordItem",tRowId),10)
	.s tBPCRIMin=$lg(^DHCBPC("RecordItem",tRowId),11)
	.s tBPCRIMax=$lg(^DHCBPC("RecordItem",tRowId),12)
	.s tBPCRIImpossibleMin=$lg(^DHCBPC("RecordItem",tRowId),13)
	.s tBPCRIImpossibleMax=$lg(^DHCBPC("RecordItem",tRowId),14)
	.s BPCRICollectCode=$lg(^DHCBPC("RecordItem",tRowId),16)
	.s tBPCRIMainRecordItemDr=$lg(^DHCBPC("RecordItem",tRowId),15)
	.i tBPCRIMainRecordItemDr'="" s tBPCRIMainRecordItem=$lg(^DHCBPC("RecordItem",tBPCRIMainRecordItemDr),2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tRowId,tBPCRICode,tBPCRIDesc,tBPCRIBPCRecordCatDr,tBPCRIBPCRecordCat,tBPCRITypeDr,tBPCRIType,tBPCRIArcimDr,tBPCRIArcim,tBPCRIUomDr,tBPCRIUom,tBPCRIOptions,tBPCRIDataTypeDr,tBPCRIDataType,tBPCRIMultiValueDesc,tBPCRISortNo,tBPCRIMin,tBPCRIMax,tBPCRIImpossibleMin,tBPCRIImpossibleMax,tBPCRIMainRecordItemDr,tBPCRIMainRecordItem,tBPCRICollectCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCReItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCReItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPCReItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCReItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 插入数据 d ##class(web.DHCBPCRecordItem).InsertBPCReItem("1","2","3","D","5","6","7","D","9","10","11","12","13","14","15")
ClassMethod InsertBPCReItem(Code As %String, Desc As %String, BPCRIBPCRecordCatDr As %String, BPCRIType As %String, BPCRIArcimDr As %String, BPCRIUomDr As %String, BPCRIOptions As %String, BPCRIDataType As %String, BPCRIMultiValueDesc As %String, BPCRISortNo As %String, BPCRIMin As %String, BPCRIMax As %String, BPCRIImpossibleMin As %String, BPCRIImpossibleMax As %String, BPCRIMainRecordItemDr As %String, BPCRICollectCode As %String)
{
	K PLIST
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=BPCRIBPCRecordCatDr
	s PLIST(5)=BPCRIType
	s PLIST(6)=BPCRIArcimDr
	s PLIST(7)=BPCRIUomDr
	s PLIST(8)=BPCRIOptions
	s PLIST(9)=BPCRIDataType
	s PLIST(10)=BPCRIMultiValueDesc
	s PLIST(11)=BPCRISortNo
	s PLIST(12)=BPCRIMin
	s PLIST(13)=BPCRIMax
	s PLIST(14)=BPCRIImpossibleMin
	s PLIST(15)=BPCRIImpossibleMax
	s PLIST(16)=BPCRIMainRecordItemDr
	s PLIST(17)=BPCRICollectCode
	&SQL(insert into DHC_BPC_RecordItem Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

/// 更新
ClassMethod UpdateBPCReItem(BPCRIRowId As %String, Code As %String, Desc As %String, BPCRIBPCRecordCatDr As %String, BPCRIType As %String, BPCRIArcimDr As %String, BPCRIUomDr As %String, BPCRIOptions As %String, BPCRIDataType As %String, BPCRIMultiValueDesc As %String, BPCRISortNo As %String, BPCRIMin As %String, BPCRIMax As %String, BPCRIImpossibleMin As %String, BPCRIImpossibleMax As %String, BPCRIMainRecordItemDr As %String, BPCRICollectCode As %String)
{
	q:(BPCRIRowId="") "" 
	K PLIST
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=BPCRIBPCRecordCatDr
	s PLIST(5)=BPCRIType
	s PLIST(6)=BPCRIArcimDr
	s PLIST(7)=BPCRIUomDr
	s PLIST(8)=BPCRIOptions
	s PLIST(9)=BPCRIDataType
	s PLIST(10)=BPCRIMultiValueDesc
	s PLIST(11)=BPCRISortNo
	s PLIST(12)=BPCRIMin
	s PLIST(13)=BPCRIMax
	s PLIST(14)=BPCRIImpossibleMin
	s PLIST(15)=BPCRIImpossibleMax
	s PLIST(16)=BPCRIMainRecordItemDr
	s PLIST(17)=BPCRICollectCode
	&SQL(update DHC_BPC_RecordItem Values :PLIST() where BPCRI_RowId=:BPCRIRowId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

/// 删除
ClassMethod DeleteBPCReItem(BPCRIRowId As %String)
{
	i BPCRIRowId'="" d
	.&SQL(delete from DHC_BPC_RecordItem where BPCRI_RowId=:BPCRIRowId)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCRecordItem","FindBPCReCat")
Query FindBPCReCat() As %Query(ROWSPEC = "BPCRCCode:%String,BPCRCDesc:%String,BPCRCId:%String")
{
}

ClassMethod FindBPCReCatExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s BPCRCId=0
	f  s BPCRCId=$o(^DHCBPC("RecordCat",BPCRCId))  q:BPCRCId=""  d
	.s BPCRCCode=$lg(^DHCBPC("RecordCat",BPCRCId),1)
    .s BPCRCDesc=$lg(^DHCBPC("RecordCat",BPCRCId),2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(BPCRCCode,BPCRCDesc,BPCRCId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCReCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCReCatExecute ]
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

ClassMethod FindBPCReCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCReCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindBPCRIType() As %Query(ROWSPEC = "Desc:%String,RowId:%String")
{
}

ClassMethod FindBPCRITypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId="D",Desc="药品"
	d OutputRow7
	s RowId="V",Desc="生命体征"
	d OutputRow7
	s RowId="E",Desc="事件"
	d OutputRow7
	s RowId="T",Desc="治疗"
	d OutputRow7
	s RowId="L",Desc="检验"
	d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(Desc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCRITypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCRITypeExecute ]
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

ClassMethod FindBPCRITypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCRITypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCRecordItem","BPCRIDataType")
Query BPCRIDataType() As %Query(ROWSPEC = "Desc:%String,RowId:%String")
{
}

ClassMethod BPCRIDataTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId="N",Desc="数值"
	d OutputRow7
	s RowId="S",Desc="字符串"
	d OutputRow7
	s RowId="C",Desc="单选"
	d OutputRow7
	s RowId="M",Desc="多选"
	d OutputRow7
	s RowId="I",Desc="图标"
	d OutputRow7
	s RowId="D",Desc="日期"
	d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(Desc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod BPCRIDataTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BPCRIDataTypeExecute ]
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

ClassMethod BPCRIDataTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BPCRIDataTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCRecordItem","FindBPCRecordItem")
Query FindBPCRecordItem() As %Query(ROWSPEC = "BPCRICode:%String,BPCRIDesc:%String,BPCRIRowId:%String")
{
}

ClassMethod FindBPCRecordItemExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s BPCRIRowId=0
	f  s BPCRIRowId=$o(^DHCBPC("RecordItem",BPCRIRowId))  q:BPCRIRowId=""  d
	.s BPCRICode=$lg(^DHCBPC("RecordItem",BPCRIRowId),1)
    .s BPCRIDesc=$lg(^DHCBPC("RecordItem",BPCRIRowId),2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(BPCRICode,BPCRIDesc,BPCRIRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCRecordItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCRecordItemExecute ]
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

ClassMethod FindBPCRecordItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCRecordItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetRecordItemList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCRI_Code As Code,
	   BPCRI_Desc As Description,
	   BPCRI_BPCRecordCat_Dr As RecordCatId,
	   BPCRI_Type As ItemType,
	   BPCRI_Arcim_Dr As ArcimId,
	   BPCRI_Uom_Dr As UomId,
	   BPCRI_Options As Options,
	   BPCRI_DataType As DataType,
	   BPCRI_MultiValueDesc As MultiValueDesc,
	   BPCRI_SortNo As SortNo,
	   BPCRI_Min As Minimum,
	   BPCRI_Max As Maximum,
	   BPCRI_ImpossibleMin As ImpossibleMin,
	   BPCRI_ImpossibleMax As ImpossibleMax,
	   BPCRI_MainRecordItem_Dr As MainRecordItemId,
	   BPCRI_CollectCode as CollectCode
	   FROM DHC_BPC_RecordItem
}

/// 根据code获取监护记录项目ID
ClassMethod GetRecordItemIdByCode(code As %String = "") As %String
{
	s retStr=""
	q:(code="") retStr
	s BPCRIRowId=0
	f  s BPCRIRowId=$o(^DHCBPC("RecordItem",BPCRIRowId))  q:BPCRIRowId=""  d
	.s BPCRICode=$lg(^DHCBPC("RecordItem",BPCRIRowId),1)
    .q:(code'="")&&(BPCRICode'=code)
    .s retStr=BPCRIRowId
    q retStr
}

}
