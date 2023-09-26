Import SQLUser

Class web.DHCICUViewPara Extends %RegisteredObject
{

//d ##class(%ResultSet).RunQuery("web.DHCICUViewPara","GetViewParaList","5666")

Query GetViewParaList(icuaId As %String) As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,RecordDocCode:%String,RecordCatCode:%String,ChartInfo:%String,ChartHeight:%String,TotalHeight:%String,BackColor:%String") [ SqlProc ]
{
}

ClassMethod GetViewParaListExecute(ByRef qHandle As %Binary, icuaId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i icuaId<1 Set qHandle=$lb(0,repid,0) Quit $$$OK
	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s wardLocId=$p(^PAWARD(+icuBedId),"^",5)
	i wardLocId<1 Set qHandle=$lb(0,repid,0) Quit $$$OK
	s icuvpId=0
	f  s icuvpId=$o(^DHCICUViewPara(0,"Ctloc",+wardLocId,icuvpId))  q:icuvpId=""  d
		.s icuvpList(icuvpId)=""
		.s retVal=$$GetViewPara(icuvpId)
	s icuvpId=0
	f  s icuvpId=$o(^DHCICUViewPara(0,"ICUA",icuaId,icuvpId))  q:icuvpId=""  d
		.q:$d(icuvpList(icuvpId))
		.s retVal=$$GetViewPara(icuvpId)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetViewPara(icuvpId)
	s icuvpCode=$lg(^DHCICUViewPara(icuvpId),1)
	s icuvpDesc=$lg(^DHCICUViewPara(icuvpId),2)
	s icuvpICUCVSCCode=$lg(^DHCICUViewPara(icuvpId),5)
	s icuvpICUCVCCode=$lg(^DHCICUViewPara(icuvpId),6)
	s icuvpChartInfo=$lg(^DHCICUViewPara(icuvpId),7)
	s icuvpChartHeight=$lg(^DHCICUViewPara(icuvpId),8)
	s icuvpTotalHeight=$lg(^DHCICUViewPara(icuvpId),9)
	s icuvpBackColor=$lg(^DHCICUViewPara(icuvpId),10)
	s Data=$lb(icuvpId,icuvpCode,icuvpDesc,icuvpICUCVSCCode,icuvpICUCVCCode,icuvpChartInfo,icuvpChartHeight,icuvpTotalHeight,icuvpBackColor)
	d OutputRowViewPara
	q 0
OutputRowViewPara
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetViewParaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetViewParaListExecute ]
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

ClassMethod GetViewParaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetViewParaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//d ##class(%ResultSet).RunQuery("web.DHCICUViewPara","GetViewParaItemList","5666")

Query GetViewParaItemList(icuaId As %String) As %Query(ROWSPEC = "ParentId:%String,Id:%String,Code:%String,Description:%String,ICUCVCCode:%String,RecordItemCode:%String,ArcimCode:%String,StandardTestCode:%String,MainViewParaItemCode:%String,Type:%String,YaxisInfoCode:%String,PenColor:%String,BrushColor:%String,IsDrawLine:%String,IsDrawIcon:%String,FillPathMode:%String,ClosedRecordItemCode:%String,DataDisplayMode:%String") [ SqlProc ]
{
}

ClassMethod GetViewParaItemListExecute(ByRef qHandle As %Binary, icuaId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i icuaId<1 Set qHandle=$lb(0,repid,0) Quit $$$OK
	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s wardLocId=$p(^PAWARD(+icuBedId),"^",5)
	i wardLocId<1 Set qHandle=$lb(0,repid,0) Quit $$$OK
	w wardLocId,!
	k icuvpList
	s icuvpId=0
	f  s icuvpId=$o(^DHCICUViewPara(0,"Ctloc",+wardLocId,icuvpId))  q:icuvpId=""  d
		.s icuvpList(icuvpId)=""
		.s icuvpiSub=0
		.f  s icuvpiSub=$o(^DHCICUViewPara(icuvpId,"I",icuvpiSub)) q:icuvpiSub=""  d
			..s retVal=$$GetViewParaItem(icuvpId,icuvpiSub)
	s icuvpId=0
	f  s icuvpId=$o(^DHCICUViewPara(0,"ICUA",icuaId,icuvpId))  q:icuvpId=""  d
		.q:$d(icuvpList(icuvpId))
		.s icuvpiSub=0
		.f  s icuvpiSub=$o(^DHCICUViewPara(icuvpId,"I",icuvpiSub)) q:icuvpiSub=""  d
			..s retVal=$$GetViewParaItem(icuvpId,icuvpiSub)

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetViewParaItem(icuvpId,icuvpiSub)
	s icuvpiCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),1)
	s icuvpiDesc=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),2)
	s icuvpiICUCVCCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),3)
	s ICUVPIRecordItemCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),4)
	s ICUVPIArcimCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),5)
	s icuvpiStandardTestCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),6)
	s icuvpiMainViewParaItemCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),7)
	s icuvpiType=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),8)
	s icuvpiYaxisInfoCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),9)
	//s icuvpiFontCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),10)
	//s icuvpiPenWidth=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),11)
	s icuvpiPenColor=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),12)
	s icuvpiBrushColor=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),13)
	s icuvpiIsDrawLine=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),14)
	s icuvpiIsDrawIcon=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),15)
	s icuvpiFillPathMode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),16)
	s icuvpiClosedRecordItemCode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),17)
	s icuvpDataDisplayMode=$lg(^DHCICUViewPara(icuvpId,"I",icuvpiSub),18)
	s Data=$lb(icuvpId,icuvpId_"||"_icuvpiSub,icuvpiCode,icuvpiDesc,icuvpiICUCVCCode,ICUVPIRecordItemCode,ICUVPIArcimCode,icuvpiStandardTestCode,icuvpiMainViewParaItemCode,icuvpiType,icuvpiYaxisInfoCode,icuvpiPenColor,icuvpiBrushColor,icuvpiIsDrawLine,icuvpiIsDrawIcon,icuvpiFillPathMode,icuvpiClosedRecordItemCode,icuvpDataDisplayMode)
	d OutputRowViewParaItem

	q 0
OutputRowViewParaItem
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetViewParaItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetViewParaItemListExecute ]
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

ClassMethod GetViewParaItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetViewParaItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
