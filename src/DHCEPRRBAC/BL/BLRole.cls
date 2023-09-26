Class DHCEPRRBAC.BL.BLRole Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: w ##class(DHCEPRRBAC.BL.BLRole).DefaultRole("2")
ClassMethod DefaultRole(ARoleDefineID As %String) As %String
{
	q:((ARoleDefineID = "") || (ARoleDefineID = $c(0))) "-1"
	s flag = "1"
	TSTART
	s $zt = "OnDefaultRoleErrorHandler"
	
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.RoleDFI("IdxDefaultRole"," FS"," Y",rowID))
	if (rowID '= "")
	{
		s obj = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(rowID)
		s obj.DefaultRole = ""
		s sc = obj.%Save()
		if ($$$ISERR(sc))
		{
			TROLLBACK
			s flag = "-1"
			q flag
		}
	}
	
	s obj = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(ARoleDefineID)
	s obj.DefaultRole = "Y"
	s sc = obj.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		s flag = "-1"
		q flag
	}
	TCOMMIT
	q flag
OnDefaultRoleErrorHandler
	TROLLBACK
	q "-1"
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLRole).DeleteSSGroupRole("2","29")
ClassMethod DeleteSSGroupRole(ARoleID As %String, ASSGroupID As %String) As %String
{
	q:((ARoleID = "") || (ARoleID = $c(0))) "-1"
	s ret = "1"
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxSSGroupID"," "_ASSGroupID,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRRBAC.INST.DefaultRole).%OpenId(rowID)
		s roleID = obj.RoleID
		if (roleID = ARoleID)
		{
			s sc = ##class(DHCEPRRBAC.INST.DefaultRole).%DeleteId(rowID)
			if ($$$ISERR(sc))
			{
				s ret = "-1"
				q
			}
		}
	}
	q ret
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLRole).DefaultRoleSSGroup("2","29")
ClassMethod DefaultRoleSSGroup(ARoleID As %String, ASSGroupIDS As %String) As %String
{
	q:((ARoleID = "") || (ARoleID = $c(0))) "-1"
	s flag = "1"
	TSTART
	s $zt = "OnDefaultRoleSSGErrorHandler"
	
	for index=1:1:$l(ASSGroupIDS,"^")
	{
		s ssgroupID = $p(ASSGroupIDS,"^",index)
		s rowID = ""
		s rowID = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxSSGroupID"," "_ssgroupID,rowID))
		
		//一个安全组只能在一个角色内
		if (rowID '= "")
		{
			s obj = ##class(DHCEPRRBAC.INST.DefaultRole).%OpenId(rowID)
			s obj.RoleID = ARoleID
			s sc = obj.%Save()
			if ($$$ISERR(sc))
			{
				s flag = "-1"
			}
		}
		else
		{
			s obj = ##class(DHCEPRRBAC.INST.DefaultRole).%New()
			s obj.RoleID = ARoleID
			s obj.SSGroupID = ssgroupID
			s sc = obj.%Save()
			if ($$$ISERR(sc))
			{
				s flag = "-1"
			}
		}
	}
	if (flag = "-1")
	{
		TROLLBACK
		q flag
	}
	TCOMMIT
	q flag
OnDefaultRoleSSGErrorHandler
	TROLLBACK
	q "-1"
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLRole","GetRoleItem","1")
Query GetRoleItem(ARoleID As %String) As %Query(ROWSPEC = "OperationID:%String,OperationCode:%String,OperationDesc:%String,PrivateDomainID:%String,PrivateDomainDesc:%String,PrivateDomainLevel:%String,ResourceItemID:%String,ItemID:%String,ItemName:%String,ItemCode:%String,ItemDesc:%String,ItemType:%String,ItemTypeDesc:%String")
{
}

ClassMethod GetRoleItemExecute(ByRef qHandle As %Binary, ARoleID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxMain"," "_ARoleID,sequence))
		q:(sequence = "")
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxMain"," "_ARoleID,sequence,rowID))
			q:(rowID = "")
			
			s obj = ##class(DHCEPRRBAC.INST.ResourceRoleItem).%OpenId(rowID)
			continue:'$IsObject(obj)
			s resourceID = obj.ResourceItemID
			continue:(resourceID = "")
			s operationID = obj.OperationID
			
			s objRItem = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(resourceID)
			s itemID = objRItem.ItemID
			s privacyDomainID = objRItem.PrivateDomainID
			
			s objItem = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(itemID)
			s name = objItem.ItemName
			s code = objItem.ItemCode
			s desc = objItem.ItemDesc
			s type = objItem.ItemType
			
			s objOp = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(operationID)
			s operationCode = objOp.OpCode
			s operationDesc = objOp.OpDesc
			
			s objP = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(privacyDomainID)
			s privateDomainDesc = objP.RPDDesc
			s privateDomainLevel = objP.RPDLevel
			
			s itemTypeDesc = ##class(DHCEPRRBAC.Util.Utilization).GetEPRActionDesc(type)
			
			s ^CacheTemp(repid,ind) = $lb(operationID,operationCode,operationDesc,privacyDomainID,privateDomainDesc,privateDomainLevel,resourceID,itemID,name,code,desc,type,itemTypeDesc)
			s ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetRoleItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRoleItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleItemExecute ]
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

ClassMethod AddRoleItem(ARoleID As %String, AOpID As %String, APrivateDomainIDList As %String, AResourceItemIDList As %String) As %String
{
	s flag = "1"
	TSTART
	s $zt = "OnAddErrorHandler"
	
	d ..DeleteRoleItem(ARoleID)
	
	s:(APrivateDomainIDList = $c(0)) APrivateDomainIDList = ""
	if (APrivateDomainIDList '= "")
	{
		for index=1:1:$l(APrivateDomainIDList,"^")
		{
			s privateDomainID = $p(APrivateDomainIDList,"^",index)
			s resourceItemID = $p(AResourceItemIDList,"^",index)
			
			s obj = ##class(DHCEPRRBAC.INST.ResourceRoleItem).%New()
			s obj.RoleID = ARoleID
			s obj.OperationID = AOpID
			s obj.ResourceItemID = resourceItemID
			s obj.Sequence = +index
			s sc = obj.%Save()
			if ($$$ISERR(sc))
			{
				s flag = "-1"
			}
		}
	}
	if (flag = "-1")
	{
		TROLLBACK
		q flag
	}
	TCOMMIT
	q flag
OnAddErrorHandler
	TROLLBACK
	q "-1"
}

ClassMethod DeleteRoleItem(ARoleID As %String) As %String
{
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxMain"," "_ARoleID,sequence))
		q:(sequence = "")
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxMain"," "_ARoleID,sequence,rowID))
			q:(rowID = "")
			
			s result = ##class(DHCEPRRBAC.INST.ResourceRoleItem).%DeleteId(rowID)
		}
	}
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLRole).AddRole("HigherViewer","nv002","高级查询")
ClassMethod AddRole(ARoleName As %String, ARoleCode As %String, ARoleDesc As %String)
{
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.RoleDFI("IdxMain"," "_$zcvt(ARoleCode,"U"),rowID))
	if (rowID '= "")
	{
		q "-2"
	}
	
	s obj = ##class(DHCEPRRBAC.META.RoleDefinition).%New()
	s obj.RoleName = ARoleName
	s obj.RoleCode = ARoleCode
	s obj.RoleDesc = ARoleDesc
	s obj.RoleActive = "Y"
	s obj.RoleType = "FS"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"
	}
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLRole).ModifyRole("2","HigherViewer","nv002","高级查询")
ClassMethod ModifyRole(ARoleID As %String, ARoleName As %String, ARoleCode As %String, ARoleDesc As %String)
{
	s:(ARoleID = $c(0)) ARoleID = ""
	q:(ARoleID = "") "-1"
	
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.RoleDFI("IdxMain"," "_$zcvt(ARoleCode,"U"),rowID))
	if (rowID '= "")&&(rowID '= ARoleID)
	{
		q "-2"
	}
	
	s obj = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(ARoleID)
	s obj.RoleName = ARoleName
	s obj.RoleCode = ARoleCode
	s obj.RoleDesc = ARoleDesc
	s obj.RoleActive = "Y"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"
	}
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLRole","GetRole")
Query GetRole() As %Query(ROWSPEC = "RoleID:%String,RoleName:%String,RoleCode:%String,RoleDesc:%String,DefaultRole:%String")
{
}

ClassMethod GetRoleExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s roleID = ""
	for {
		s roleID = $o(^DHCEPRRBAC.META.RoleDFD(roleID))
		q:(roleID = "")
		
		s obj = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(roleID)
		continue:(obj.RoleType '= "FS")
		s RoleName = obj.RoleName
		s RoleCode = obj.RoleCode
		s RoleDesc = obj.RoleDesc
		s DefaultRole = obj.DefaultRole
		
		s ^CacheTemp(repid,ind) = $lb(roleID,RoleName,RoleCode,RoleDesc,DefaultRole)
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleExecute ]
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

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLRole","GetRoleDetail","1")
Query GetRoleDetail(ARoleID As %String) As %Query(ROWSPEC = "RoleID:%String,SSGroupID:%String,SSGroupName:%String")
{
}

ClassMethod GetRoleDetailExecute(ByRef qHandle As %Binary, ARoleID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxRoleID"," "_ARoleID,rowID))
		q:(rowID = "")
		
		s objDefault = ##class(DHCEPRRBAC.INST.DefaultRole).%OpenId(rowID)
		s ssGroupID = objDefault.SSGroupID
		s ssGroupName = ""
		s:(ssGroupID '= "") ssGroupName = $p($g(^SSU("SSGRP",ssGroupID)),"^",1)
		
		s ^CacheTemp(repid,ind) = $lb(ARoleID,ssGroupID,ssGroupName)
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetRoleDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRoleDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleDetailExecute ]
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
