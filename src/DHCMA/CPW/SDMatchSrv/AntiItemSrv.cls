Class DHCMA.CPW.SDMatchSrv.AntiItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDMatchSrv.AntiItemSrv","QryAntiItem","J01AA")
Query QryAntiItem(aAntiCat As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,EName:%String,Resume:%String,IsActive:%String")
{
}

ClassMethod QryAntiItemExecute(ByRef qHandle As %Binary, aAntiCat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aAntiCat="") $$$OK
 	Set AntiCatObj=##class(DHCMA.CPW.SDMatch.Anticat).GetObjByCode(aAntiCat)
 	Quit:'$IsObject(AntiCatObj) $$$OK
 	Set AntiCatDr=AntiCatObj.%Id()
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        		= $o(^DHCMA.CPW.SDMatch.AntiItemI("IdxCat",AntiCatDr,xRowID))
	 	Quit:xRowID=""
	 	Set objAntiItem        	= ##class(DHCMA.CPW.SDMatch.AntiItem).GetObjById(xRowID)
	 	Set Code             	= objAntiItem.BTCode
	 	Set Desc             	= objAntiItem.BTDesc 
	 	Set EName             	= objAntiItem.EName  
	 	Set IsActive          	= objAntiItem.IsActive
	 	Set Resume          	= objAntiItem.Resume
	 	Set IsActive = $s(IsActive=1:"是",1:"否")
		Set Data=$lb(xRowID,Code,Desc,EName,Resume,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryAntiItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntiItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiItemExecute ]
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

ClassMethod ImportAntiItems(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=-1
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set PCode            = $p(aInputStr,aSeparete,7)
	Set CarDr= ##class(DHCMA.CPW.SDMatch.Anticat).GetObjByCode(PCode)
	Set CatID=CarDr.%Id()
	Set $p(aInputStr,aSeparete,7)=CatID
	Set return=##class(DHCMA.CPW.SDMatch.AntiItem).Update(aInputStr)
	Quit return
}

}
