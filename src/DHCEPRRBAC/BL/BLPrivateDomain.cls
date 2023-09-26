Class DHCEPRRBAC.BL.BLPrivateDomain Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLPrivateDomain","GetPrivateDomain")
Query GetPrivateDomain() As %Query(ROWSPEC = "PrivateDomainID:%String,PDDName:%String,PDDCode:%String,PDDDesc:%String,PDDLevel:%String")
{
}

ClassMethod GetPrivateDomainExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRRBAC.META.PrivDDFD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(rowID)
		continue:((obj.RPDActive '= "1") && (obj.RPDActive '= "Y"))
		continue:(obj.RPDType '= "FS")
		
		s name = obj.RPDName
		s code = obj.RPDCode
		s desc = obj.RPDDesc
		s level = obj.RPDLevel
		
		s ^CacheTemp(repid,ind) = $lb(rowID,name,code,desc,level)
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetPrivateDomainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrivateDomainExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrivateDomainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrivateDomainExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLPrivateDomain","GetItemByPDDID","3")
Query GetItemByPDDID(APrivateDomainID As %String) As %Query(ROWSPEC = "PrivateDomainID:%String,PrivateDomainDesc:%String,PrivateDomainLevel:%String,ResourceItemID:%String,ItemID:%String,ItemName:%String,ItemCode:%String,ItemDesc:%String,ItemType:%String,ItemTypeDesc:%String")
{
}

ClassMethod GetItemByPDDIDExecute(ByRef qHandle As %Binary, APrivateDomainID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRRBAC.INST.ResourceItemI("IdxPrivateDomain"," Y"," "_APrivateDomainID,rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)
		s itemID = obj.ItemID
		
		s objItem = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(itemID)
		s name = objItem.ItemName
		s code = objItem.ItemCode
		s desc = objItem.ItemDesc
		s type = objItem.ItemType
		
		s objP = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(APrivateDomainID)
		s privateDomainDesc = objP.RPDDesc
		s privateDomainLevel = objP.RPDLevel
		
		s itemTypeDesc = ##class(DHCEPRRBAC.Util.Utilization).GetEPRActionDesc(type)
		
		s ^CacheTemp(repid,ind) = $lb(APrivateDomainID,privateDomainDesc,privateDomainLevel,rowID,itemID,name,code,desc,type,itemTypeDesc)
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetItemByPDDIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemByPDDIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemByPDDIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemByPDDIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
