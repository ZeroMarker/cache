Class web.DHCEQCheckCode Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQUpdateEquipsByList","GetEquipsByOCR","")
Query GetEquipsByOCR(OCRHold1 As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipNo:%String,TRequestNo:%String,TLeaveFactoryNo:%String,TFileNo:%String")
{
}

ClassMethod GetEquipsByOCRExecute(ByRef qHandle As %Binary, OCRHold1 As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
	s OCRRowID=""
	f  s OCRRowID=$o(^DHCEQOpenCheckRequest(OCRRowID)) q:OCRRowID=""  d
	.s GRN=^DHCEQOpenCheckRequest(OCRRowID)
	.s RequestNo=$p(GRN,"^",37)   // 取验收单号
	.i RequestNo'=""  d  //验收单号不为空输出	
	..s EQRowID=0
	..s OCLRowID=OCRRowID
	..f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID)) q:(EQRowID="")  Do
	...s TRowID =OCRRowID
	...s TRequestNo=RequestNo
	...s TEquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	...s TLeavefactoryNo=$p(^DHCEQEquip(EQRowID),"^",10)
	...s TFileNo=$p(^DHCEQEquip(EQRowID),"^",85)
	...d OutputRowGetEquipsByOCR

OutputRowGetEquipsByOCR
	set Data=$lb(TRowID,TEquipNo,TRequestNo,TLeaveFactoryNo,TFileNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod GetEquipsByOCRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipsByOCRExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	 // if there are no more rows, finish fetching
 	 Set AtEnd=1
 	 Set Row=""
 	}
 	Else      {	 // fetch row
 	 Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEquipsByOCRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipsByOCRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
