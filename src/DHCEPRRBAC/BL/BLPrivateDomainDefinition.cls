Class DHCEPRRBAC.BL.BLPrivateDomainDefinition Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLPrivateDomain","GetPrivateDomain")
Query GetPrivateDomain() As %Query(ROWSPEC = "PrivateDomainID:%String,PDDName:%String,PDDCode:%String,PDDDesc:%String,PDDLevel:%String,RPDActive:%String")
{
}

ClassMethod GetPrivateDomainExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s rowID = ""
	for	{
		s rowID = $o(^DHCEPRRBAC.META.PrivDDFD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(rowID)
		//continue:((obj.RPDActive '= "1") && (obj.RPDActive '= "Y"))

		s name = obj.RPDName
		s code = obj.RPDCode
		s desc = obj.RPDDesc
		s level = obj.RPDLevel
		s active = obj.RPDActive
		
		s ^CacheTemp(repid,ind) = $lb(rowID,name,code,desc,level,active)
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

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLPrivateDomain","GetItemByPDDID","3")
Query GetItemByPDDID(APrivateDomainID As %String) As %Query(ROWSPEC = "PrivateDomainID:%String,PrivateDomainDesc:%String,ResourceItemID:%String,ItemID:%String,ItemName:%String,ItemCode:%String,ItemDesc:%String,ItemType:%String,ItemActive:%String")
{
}

ClassMethod GetItemByPDDIDExecute(ByRef qHandle As %Binary, APrivateDomainID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
     B
	s rowID = ""
	for	{
		s rowID = $o(^DHCEPRRBAC.INST.ResourceItemI("IdxPrivateDomain"," Y"," "_APrivateDomainID,rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)

		s itemID = obj.ItemID
		
		s objItem = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(itemID)
		s name = objItem.ItemName
		s code = objItem.ItemCode
		s desc = objItem.ItemDesc
		s type = objItem.ItemType
		s active = objItem.ItemActive
		
		s objP = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(APrivateDomainID)
		s privateDomainDesc = objP.RPDDesc
		
		s ^CacheTemp(repid,ind) = $lb(APrivateDomainID,privateDomainDesc,rowID,itemID,name,code,desc,type,active)
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

//添加隐私域目录

ClassMethod CreatePrivateDomain(aEPrivateDomain As DHCEPRRBAC.Entity.EPrivateDomainDefinition) As %String
{
	s obj = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%New()
	s obj.RPDActive = aEPrivateDomain.RPDActive
	s obj.RPDCode = aEPrivateDomain.RPDCode
	//数字越大级别越高，所屏蔽的信息越少
	s obj.RPDDesc = aEPrivateDomain.RPDDesc
	s obj.RPDLevel = aEPrivateDomain.RPDLevel
	s obj.RPDName = aEPrivateDomain.RPDName
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

//更新隐私域目录

ClassMethod UpdatePrivateDomain(aEPrivateDomain As DHCEPRRBAC.Entity.EPrivateDomainDefinition) As %String
{
	s obj = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(aEPrivateDomain.ID)
	q:(obj = "")
	s obj.RPDActive = aEPrivateDomain.RPDActive
	s obj.RPDCode = aEPrivateDomain.RPDCode
	//数字越大级别越高，所屏蔽的信息越少
	s obj.RPDDesc = aEPrivateDomain.RPDDesc
	s obj.RPDLevel = aEPrivateDomain.RPDLevel
	s obj.RPDName = aEPrivateDomain.RPDName
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q aEPrivateDomain.ID
	}
	else
	{
		q ""
	}
}

//删除隐私域目录

ClassMethod DeletePrivateDomain(aPrivateDomainID As %String) As %String
{
	
	q:(aPrivateDomainID ="") "-1"	
	s obj = ##Class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(aPrivateDomainID)
	q:(obj="") "-1"
	s sc = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%DeleteId(aPrivateDomainID)	
	if ($$$ISOK(sc))
	{
		q aPrivateDomainID
	}
	else
	{
		q "-1"
	}
}

//检查隐私级别是否添加

ClassMethod CheckPrivateDomainLevel(aRPDLevel As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEPRRBAC.META.PrivDDFI("IdxMain"," "_aRPDLevel,rowID))	
	q rowID
}

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLPrivateDomain","GetElementByItemID","7")
Query GetElementByItemID(APrivateDomainID As %String, aItemID As %String) As %Query(ROWSPEC = "ID:%String,ElementName:%String,ElementCode:%String,ElementCodeType:%String,ElementDesc:%String,ElementType:%String,ElementActive:%String")
{
}

ClassMethod GetElementByItemIDExecute(ByRef qHandle As %Binary, APrivateDomainID As %String, aItemID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
    b
	s rowID = ""
	for	{
	    s rowID = $o(^DHCEPRRBAC.INST.RSRCElementI("IdexPrivateDomainItemElementID"," "_APrivateDomainID," "_aItemID,rowID))
		q:(rowID = "")	
		s obj = ##Class(DHCEPRRBAC.INST.ResourceElement).%OpenId(rowID)	      
	    q:(obj="")	
	    s ElRowid=obj.ElementID		  	
	    s obj = ##Class(DHCEPRRBAC.META.ElementDefinition).%OpenId(ElRowid)	      
	    q:(obj="")		
		s ElementName = obj.ElementName
		s ElementCode = obj.ElementCode
		s ElementCodeType = obj.ElementCodeType
		s ElementDesc = obj.ElementDesc
		s ElementType = obj.ElementType
		s ElementActive = obj.ElementActive	
		
		s ^CacheTemp(repid,ind) = $lb(rowID,ElementName,ElementCode,ElementCodeType,ElementDesc,ElementType,ElementActive)
	    s ind=ind+1		
   }	
   Quit $$$OK
}

ClassMethod GetElementByItemIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetElementByItemIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetElementByItemIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetElementByItemIDExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLPrivateDomain","GetRoleDefinition")
Query GetRoleDefinition() As %Query(ROWSPEC = "ID:%String,RoleName:%String,RoleCode:%String,RoleDesc:%String,RoleActive:%String,DefaultRole:%String")
{
}

ClassMethod GetRoleDefinitionExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s rowID = ""
	for	{
		s rowID = $o(^DHCEPRRBAC.META.RoleDFD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(rowID)	

		s name = obj.RoleName
		s code = obj.RoleCode
		s desc = obj.RoleDesc		
		s active = obj.RoleActive
		s defaultrole = obj.DefaultRole
		
		s ^CacheTemp(repid,ind) = $lb(rowID,name,code,desc,active,defaultrole)
	    s ind=ind+1		
   }	
   Quit $$$OK
}

ClassMethod GetRoleDefinitionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleDefinitionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRoleDefinitionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleDefinitionExecute ]
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
